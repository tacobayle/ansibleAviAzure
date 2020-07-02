import json, os, yaml, sys, ast
paramsFile = sys.argv[1]
dict = ast.literal_eval(sys.argv[2])
suffix = sys.argv[3]
# paramsFile = 'vars/params.yml'
# dictPrivateIp": {
#         "controller1-subnet1-if": "172.16.1.5",
#         "jump-subnet1-if": "172.16.1.4",
#         "jump-subnet2-if": "172.16.2.4",
#         "web1-subnet1-if": "172.16.1.6",
#         "web1-subnet2-if": "172.16.2.5"
#     }
with open(paramsFile, 'r') as stream:
  data_loaded = yaml.load(stream)
stream.close
#print(data_loaded)
list = []
# print(IpPubDict)
for vm in data_loaded['vm']:
  list.append(dict[vm['name'] + '-' + vm['subnet'][0]['name'] + suffix])
print(json.dumps(list))
