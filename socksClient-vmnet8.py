import extlib.socksipy.socks as socks

s = socks.socksocket()
s.setproxy(socks.PROXY_TYPE_SOCKS4,"172.16.1.1")
s.connect(('127.0.0.1',22))

s.send('\n\n')
print s.recv(1024)
s.close()
