
/*
 * bfpridaemon.c -- Changes bf1942 gameserver priority on request.
 *
 * Copyright Digital Illusions CE AB 2003
 *
 * Note that you are not allowed to distribute copies of this code
 * in modified form, but you ARE allowed to modify it for local
 * use (such as within your company).
 *
 * This program comes with no warranty of any kind. Use at your
 * own risk. This program is distributed with source code to
 * enable you to read what you are running as root, nothing
 * else.
 *
 * Author: Andreas Fredriksson <andreas.fredriksson@dice.se>
 *
 * Theory of operation:
 *
 * The bf1942 server will, if started with +priorityDaemon 1, send
 * two datagrams to the local UDP port 2202 when it
 *  a) begins loading, requesting a lower priority
 *  b) and ends loading.
 *
 * The format of these UDP datagrams is as follows. The first
 * byte represents a character, 'l' and 'p' are the only valid
 * alternatives representing "loading" and "playing" respectively.
 *
 * Immediately following the first character is the pid of the
 * sending process.
 * 
 * For example, the message string "p1234" means that the process
 * with PID 1234 is requesting play priority.
 */

#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <syslog.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/resource.h>

#define BUFLEN (256)
#define DAEMON_LISTEN_PORT (2022)

void process_requests(void);
void usage(void);

int main(int argc, char** argv)
{
	int i;
	int null_rd, null_wr;
	int daemonize = 1;

	for(i=1; i<argc; ++i) {
		const char* curr = argv[i];
		if( strcmp(curr, "-h") == 0 || strcmp(curr, "--help") == 0 ) {
			usage();
			exit(0);
		}

		if( strcmp(curr, "-f") == 0 || strcmp(curr, "--foreground") == 0 ) {
			daemonize = 0;
		}
	}

	if( daemonize ) {
		if(fork()) exit(0);
		setsid();
		if(fork()) exit(0);

		for(i=0;i<sysconf(_SC_OPEN_MAX);i++) { close(i); }

		null_rd = open("/dev/null", O_RDONLY);
		null_wr = open("/dev/null", O_WRONLY);

		if( null_rd == -1 || null_wr == -1 ) {
			/* couldn't open /dev/null?! */
			exit(1);
		}

		dup2(null_rd, 0);
		dup2(null_wr, 1);
		dup2(null_wr, 2);

		chdir("/tmp"); /* instead of /, in case we dump a core */
	}

	umask(0);
	alarm(0);
	
	process_requests();
	/* never reached */
	return 0;
}


void process_requests(void)
{
	int sock_fd = 0;
	struct protoent *proto = NULL;
	struct sockaddr_in my_addr;
	int msglen;
	char msgbuf[BUFLEN];

	openlog("bfpridaemon", LOG_ODELAY, LOG_DAEMON);

	/* build address */
	memset(&my_addr, 0, sizeof(my_addr));
	my_addr.sin_family = AF_INET;
	my_addr.sin_port = htons(DAEMON_LISTEN_PORT);

	if( !inet_aton("127.0.0.1", &my_addr.sin_addr) ) {
		syslog(LOG_CRIT, "couldn't map address via inet_aton(), exiting\n");
		exit(1);
	}

	/* look up UDP protocol entry */
	if( !(proto = getprotobyname("udp")) ) {
		syslog(LOG_CRIT, "no protocol entry for \"udp\"\n");
		exit(1);
	}

	/* create datagram socket */
	sock_fd = socket(PF_INET, SOCK_DGRAM, proto->p_proto);
	if( sock_fd == -1 ) {
		syslog(LOG_CRIT, "error creating socket: %m");
		exit(1);
	}

	/* bind it to our listening port */
	if( bind(sock_fd, (struct sockaddr*)&my_addr, sizeof(my_addr)) == -1 ) {
		syslog(LOG_CRIT, "error binding socket: %m");
		exit(1);
	}

	syslog(LOG_INFO, "accepting requests");

	/* loop forever reading messages from the UDP socket */
	while( (msglen = recv(sock_fd, msgbuf, BUFLEN-1, 0)) > 0 ) {
		char caller_req = 0;
		int caller_pid = 0;
		int target_priority = 0;

		/* zero-terminate the message */
		msgbuf[msglen] = 0;

		if( msglen < 2 ) {
			/* bogus message */
			continue;
		}

		/* parse the message */
		caller_req = msgbuf[0];
		caller_pid = atoi(msgbuf+1);

		/* negative, zero or /sbin/init.. won't do */
		if( caller_pid < 2 ) continue;

		if( caller_req == 'p' )
			target_priority = 0;
		else if( caller_req == 'l' )
			target_priority = 10;
		else {
			/* bogus request */
			syslog(LOG_WARNING, "ignoring badly formatted request");
			continue;
		}

		/* adjust the priority and report any failure */
		errno = 0;
		setpriority(PRIO_PROCESS, caller_pid, target_priority);
		if( errno ) {
			syslog(LOG_WARNING,
					"bfpridaemon: failed to renice pid %d to %d: %m",
					caller_pid, target_priority);
		}
	}
}

void usage(void)
{
	puts(
	"bfpridaemon -- changes bf1942 server niceness during loading\n\n"
	"usage: bfpridaemon [-f/--foreground] [-h/--help]\n"
	" -f, --foreground         don't daemonize, run in foreground\n"
	" -h, --help               this message\n"
	);
}
