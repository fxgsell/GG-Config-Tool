import ifaddr
import requests
import json
import socket
import yaml

config = yaml.safe_load(open("config.yml"))
print(config)
adapters = ifaddr.get_adapters()
ips = []
for adapter in adapters:
    print "IPs of network adapter " + adapter.nice_name
    for ip in adapter.ips:
        ip = "%s/%s" % (ip.ip, ip.network_prefix)
        print("   " + ip)
        if ( not ip.startswith("127.") and
             not ip.startswith("('fe80:") and
             not ip.startswith("('::1") ):
            ips.append(ip)

data = json.dumps({"Name": socket.gethostname(), "Addresses": ips})
api_url = config['url']
requests.post(api_url, data=data)