CC = gcc
# -g : allows use of GNU Debugger
# -Wall : show all warnings
FLAGS = -g -Wall -std=gnu99
LIBS = # None yet...
CSOURCEA = cookie_client_t.c cookie_clnt.c cookie.h
CSOURCEB = cookie_client_j.c cookie_clnt.c cookie.h
SSOURCE = cookie_server.c cookie_svc.c cookie.h
RPCSRC = cookie.x
RPCGEN = cookie.h cookie_clnt.c cookie_svc.c
CLIENTA = tina
CLIENTB = judy
SERVER = mother

all: $(CLIENTA) $(CLIENTB) $(SERVER)

tina: rpc $(CSOURCE)
	$(CC) $(LIBS) $(FLAGS) -o $(CLIENTA) $(CSOURCEA)
	chmod 755 $(CLIENTA)
	
judy: rpc $(CSOURCE)
	$(CC) $(LIBS) $(FLAGS) -o $(CLIENTB) $(CSOURCEB)
	chmod 755 $(CLIENTB)

mother: rpc $(SSOURCE)
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
	rm -f $(CLIENTA) $(CLIENTB) $(SERVER) $(RPCGEN)
