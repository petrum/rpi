#!/usr/bin/python

import socket
import sys

REMOTE_SERVER = "www.google.com"

def test():
  try:
    host = socket.gethostbyname(REMOTE_SERVER)
    s = socket.create_connection((host, 80), 2)
    return True
  except:
     pass
  return False

if __name__ == '__main__':
    sys.exit(0 if test() else -1)
