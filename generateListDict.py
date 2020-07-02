import json, os, yaml, sys, ast
paramsFile = sys.argv[1]
listIp = ast.literal_eval(sys.argv[2])
with open(paramsFile, 'r') as stream:
  data_loaded = yaml.load(stream)
stream.close
list = []
for group in data_loaded['ansibleHost']['hostGroup']:
  d = {}
  ips = []
  for ip, vm in zip(listIp, data_loaded['vm']):
    if group == vm['hostGroup']:
      d['name'] = group
      ips.append(ip)
      d['ip'] = ips
  if len(ips) > 0:
    list.append(d)
print(json.dumps(list))
