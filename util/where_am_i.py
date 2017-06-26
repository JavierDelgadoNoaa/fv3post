#!/usr/bin/env python

import socket
import re

def where_am_i(distinguish_frontend=False):
    """
    Determine what host I'm in (theia or Jet).
    Return a string: 'jet' + suffix OR 'theia' + suffix
    If `distinguish_frontend' is True, suffix is either "_frontend" or "_compute"
    Otherwise, suffix is empty string (i.e. just return 'jet' or 'theia')
    """
    suffix = ""
    if distinguish_frontend:
        suffix = "_frontend"
    hostname = socket.gethostname()
    if hostname.startswith("tfe"): 
        return "theia" + suffix
    elif hostname.startswith("fe"):
        return "jet" + suffix
    else:
        if distinguish_frontend: 
            suffix = "_compute"
        jet_compute = re.compile("[tusvx][0-9][0-9]?[0-9]?$") # no padding for Jet
        theia_compute = re.compile("t[0-9][0-9][0-9][0-9]$") 
        theia_bigmem = re.compile("tb[0-0][0-9]")
        if jet_compute.match(hostname):
            return "jet" + suffix
        elif theia_compute.match(hostname):
            return "theia" + suffix
        elif theia_bigmem.match(hostname):
            return "theia" + suffix
        else:
            raise Exception("Unknown host: {0}".format(hostname))

if __name__ == "__main__":
    print where_am_i()
    #print where_am_i(distinguish_frontend=True)

