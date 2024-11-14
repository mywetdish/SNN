.PHONY: all clean

BUILD_DIR = build

PATH_TO_CPP = ./src/

CC = gcc
CFLAGS = -c -fPIC -Wall -O3
LDFLAGS = -shared

LIB_SRCS = fifo_dpi.c
LIBS_OBJS = $(patsubst %.c, $(BUILD_DIR)/%.o, $(LIB_SRCS))
LIBRARY = libArnixFifo.so

# $(info $(shell $(CC) -v))

all: directories $(SOURCES) $(LIBRARY)

directories:
	@mkdir -p $(BUILD_DIR)

$(LIBRARY): $(LIBS_OBJS)
	$(CC) $(LIBS_OBJS) $(LDFLAGS) -o $@

$(BUILD_DIR)/%.o: $(PATH_TO_CPP)%.c*
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f $(LIBS_OBJS) $(LIBRARY)
