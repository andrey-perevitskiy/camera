CC = gcc
CFLAGS = -Wall -Wextra -Iinclude `pkg-config --cflags gtk+-3.0`
LDFLAGS = `pkg-config --libs gtk+-3.0`
SRCDIR = src
OBJDIR = obj
BINDIR = bin
# I want build the client and server, separately.
# For this, linking must be unique for each program, while
# it is not necessary for compiling.
SRCS = $(addprefix $(SRCDIR)/,client.c server.c camera.c)
SRCS_CLI = $(addprefix $(SRCDIR)/,client.c camera.c)
SRCS_SRV = $(addprefix $(SRCDIR)/,server.c camera.c)
OBJS = $(SRCS:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
OBJS_CLI = $(SRCS_CLI:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
OBJS_SRV = $(SRCS_SRV:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

.PHONY: all
all: $(BINDIR)/client $(BINDIR)/server

$(BINDIR)/client: $(OBJS_CLI) | $(BINDIR)
	$(CC) -o $@ $^ $(LDFLAGS)

$(BINDIR)/server: $(OBJS_SRV) | $(BINDIR)
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR):
	@[ -d $(OBJDIR) ] || mkdir $(OBJDIR)

$(BINDIR):
	@[ -d $(BINDIR) ] || mkdir $(BINDIR)

.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(BINDIR)
