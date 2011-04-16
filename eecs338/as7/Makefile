CC = gcc
# -g : allows use of GNU Debugger
# -Wall : show all warnings
FLAGS = -g -Wall
LIBS = # None yet...
CSOURCE = cookie_client.c cookie_clnt.c cookie.h
SSOURCE = cookie_server.c cookie_svc.c cookie.h
RPCSRC = cookie.x
RPCGEN = cookie.h cookie_clnt.c cookie_svc.c
CLIENT = client
SERVER = server

all: $(CLIENT) $(SERVER)

client: rpc $(CSOURCE)
	$(CC) $(LIBS) $(FLAGS) -o $(CLIENT) $(CSOURCE)
	chmod 755 $(CLIENT)

server: rpc $(SSOURCE)
	$(CC) $(LIBS) $(FLAGS) -o $(SERVER) $(SSOURCE)
	chmod 755 $(SERVER)

rpc: $(RPCSRC)
	rpcgen $(RPCSRC)

# 'clean' rule for remove non-source files
# To use, call 'make clean'
# Note: you don't have to call this in between every
#       compilation, it's only in case you need to
#       clean out your directory for some reason.
clean:
	@# Using the '@' sign suppresses echoing
	@# the line while the command is run
	rm -f $(CLIENT) $(SERVER) $(RPCGEN)
