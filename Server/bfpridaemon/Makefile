
CC := gcc
CFLAGS := -O -Wall -s

TARGET := bfpridaemon
INSTALL_DIR := /usr/local/sbin

.PHONY: clean install

$(TARGET): bfpridaemon.c

clean:
	$(RM) $(TARGET)

install:
	install -v -oroot -groot -p -m 4711 $(TARGET) $(INSTALL_DIR)

