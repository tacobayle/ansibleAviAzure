---
rules:
  - name: ssh
    protocol: Tcp
    dest_port: "22"
    priority: "101"
    direction: Inbound

  - name: http
    protocol: Tcp
    dest_port: "80"
    priority: "102"
    direction: Inbound

  - name: https
    protocol: Tcp
    dest_port: "443"
    priority: "103"
    direction: Inbound

vnet:
  name: avi-vnet
  subnet:
    - name: subnet1
      cidr: 172.16.1.0/24
    - name: subnet2
      cidr: 172.16.2.0/24

routes:
  - name: sshTunnel
    cidr: 192.168.100.100/32
    nexthop: jump
    subnet: subnet1
    subnetGw: 172.16.1.1
  - name: devstackIPs
    cidr: 11.1.1.0/24
    nexthop: devstack
    subnet: subnet1
    subnetGw: 172.16.1.1
  - name: aviKvm
    cidr: 200.1.1.0/24
    nexthop: kvm
    subnet: subnet1
    subnetGw: 172.16.1.1


rg:
  name: rg-avi
  location: westeurope

sa:
  name: storageavi

vm:
  - name: jump1
    size: Standard_B1s
    offer: "UbuntuServer"
    publisher: "Canonical"
    sku: "16.04-LTS"
    version: "latest"
    marketplace: false
    hostGroup: jump
    subnet:
      - subnet1
  - name: devstack1
#    size: Standard_D2s_v3
    #size: Standard_D8s_v3
    size: Standard_D16s_v3
    offer: "UbuntuServer"
    publisher: "Canonical"
    sku: "16.04-LTS"
    version: "latest"
    marketplace: false
    hostGroup: devstack
    subnet:
      - subnet1
  - name: kvm1
#    size: Standard_D2s_v3
    size: Standard_D8s_v3
    #size: Standard_D32s_v3
    offer: "UbuntuServer"
    publisher: "Canonical"
    sku: "16.04-LTS"
    version: "latest"
    marketplace: false
    hostGroup: kvm
    subnet:
      - subnet1



ssh:
  hostGroup:
    - jump
    - controller
    - kvm
    - devstack
  username: avi
  privateKeyFile: /home/avi/.ssh/id_rsa.azure
  authorizedKeysFile: "/home/avi/.ssh/authorized_keys"
  sshPubKey: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDE1yEkrWAnnsODTzZZghrqXK2i0ZzSkgnbFW4h9gysNPTl09/K+doGQaeX07YMY7vbsVYDQT44nLhW1ysZcaDitUI/ECEIGI08etqGxEGziiPPY0Iw09I1FcxxrMHRcI4u/FBU98NhuUH9VY9zHT1Z/WR4/cG4Xn5wwOfoR1/dL1/x0kGyDL91aEGd930FVsxK6DmR6yHKHFrmrc3KGkhwUGfq2VIYCUA/NyBAC1++9o7Sm9nvB3aziil/Vs3J62Uz5KpcUT1SEe+TU8UI7BHLpZeWHceXWCasRUouX5813Mvc8S7tY/qnlFmRnntnVdHw8ekDwE02z16/NdLapU2n"
  endpoint: "192.168.100.100"
  endpointCloud: "192.168.100.101"
  localPassword: "avi123"

ansibleHost:
  publicTemplate: hostsAzurePublicIp.j2
  public:
    - hostsAzurePublicIp
  privateTemplate: hostsAzurePrivate.j2
  private:
    - /home/avi/devstack/hostsAzurePrivate
    - /home/avi/aviKvm/hostsAzurePrivate
    - /home/avi/aviAzure/hostsAzurePrivate
  username: avi
