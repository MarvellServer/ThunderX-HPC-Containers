
#  Sequoia benchmark packaging defaults
ENV_OBJ = ../presta*/util.o
#CFLAGS = -DPRINT_ENV

#  Modify the following values
CC = mpicc
CFLAGS += __CFLAGS__
LD = $(CC)
LDFLAGS += __LDFLAGS__

