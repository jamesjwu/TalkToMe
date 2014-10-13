from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
 

users = []

class talkToMe(Protocol):

    def connectionMade(self):
        print "Guest client added."
 
    def connectionLost(self, reason):
        if hasattr(self, 'server_name'):
            for c in self.factory.users:
                # telnet includes \n automatically
                c.transport.write(self.server_name + " has left.\n")
            print self.server_name + " has left"
        print "Guest client left."


    def dataReceived(self, data):
        if data[:4] == "usr>":
            data = data[4:]
            self.factory.users[self] = data.strip() 
            self.server_name = data.strip()
            print data.strip() + " has logged on."
            for c in self.factory.users:
                # telnet includes \n automatically
                c.transport.write(data.strip() + " has logged on.\n")

        elif data[:4] == "msg>":
            data = data[4:]
            if self in self.factory.users:
              username = self.factory.users[self]
              for c in self.factory.users:
                  # telnet includes \n automatically
                  if data[-1] != "\n":
                      data += "\n"
                  c.transport.write(username + ": " + data)
                  print username + ": " + data,

            else:
              self.transport.write("Invalid request. Please log in.\n")

        else:
          self.transport.write("Improper protocol. Use usr> or msg>\n")



factory = Factory()
factory.users = {}
factory.protocol = talkToMe

reactor.listenTCP(1112, factory)
print "TalkToMe server started"
reactor.run()

