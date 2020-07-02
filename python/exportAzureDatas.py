import requests, json, os, yaml, sys
hostFile = sys.argv[1]
# hostFile = '../../aviAzureBootstrap/hosts'
# outputFile = '../../aviAzureCloud/vars/azureDatas.yml'
outputFile = sys.argv[2]
with open(hostFile, 'r') as stream:
    data_loaded = yaml.load(stream)
stream.close
servers = [*data_loaded['all']['children']['webA']['hosts']]
newList = []
for server in servers:
  myDict1 = {}
  myDict1['addr'] = server
  myDict1['type'] = 'V4'
  myDict2 = {}
  myDict2['ip'] = myDict1
  newList.append(myDict2)
data = {}
data['servers'] = newList
with open(outputFile, 'w') as outfile:
  yaml.dump(data, outfile, default_flow_style=False)
outfile.close
