# aviAzure

## Goals
Spin up a full Azure/Avi environment (through Ansible)

## Prerequisites:
1. make sure ansible[azure] is installed (pip install 'ansible[azure]')
2. make sure Azure Avi Terms and Conditions have been accepted
```
avi@ansible:~/azure$ az vm image accept-terms --urn avi-networks:avi-vantage-adc:avi-vantage-se-1802-byol:18.02.08
This command has been deprecated and will be removed in version '3.0.0'. Use 'az vm image terms accept' instead.
{
  "accepted": true,
  "id": "/subscriptions/b37d5cfa-0c68-422c-84af-82d99bb0ffd5/providers/Microsoft.MarketplaceOrdering/offerTypes/Microsoft.MarketplaceOrdering/offertypes/publishers/avi-networks/offers/avi-vantage-adc/plans/avi-vantage-se-1802-byol/agreements/current",
  "licenseTextLink": "https://storelegalterms.blob.core.windows.net/legalterms/3E5ED_legalterms_AVI%253a2DNETWORKS%253a24AVI%253a2DVANTAGE%253a2DADC%253a24AVI%253a2DVANTAGE%253a2DSE%253a2D1802%253a2DBYOL%253a24FLXT6XNKN4CQRSJSKMF476KLU5OMSED26Q3JQW4RQAE35JZC7HMGUKB4VAFG5J7QAXONDT6Q3MJEKE7ERDOYGCOKAVZW5QSODVHVABI.txt",
  "name": "avi-vantage-se-1802-byol",
  "plan": "avi-vantage-se-1802-byol",
  "privacyPolicyLink": "https://kb.avinetworks.com/docs/latest/privacy-policy/",
  "product": "avi-vantage-adc",
  "publisher": "avi-networks",
  "retrieveDatetime": "2020-06-30T09:19:47.4890026Z",
  "signature": "JO3R5URTGOYLU2YOTRF4O42L35ITE4WLPUTZEQLOXBNOH7TXVJZAAQUE5VY3UFRLS2UQE3G5WEDRAYWHBAHF5OK36I3MKQIODX3WBEQ",
  "type": "Microsoft.MarketplaceOrdering/offertypes"
}
avi@ansible:~/azure$

```
3. Azure credentials need to be stored in azureCreate.yml
4. Pythom modules: json, os, yaml, sys, ast

## Environment:

Playbook(s) has/have been tested against:


### terraform

```
avi@ansible:~/creds$ ansible --version
ansible 2.9.5
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/home/avi/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /home/avi/.local/lib/python2.7/site-packages/ansible
  executable location = /home/avi/.local/bin/ansible
  python version = 2.7.12 (default, Oct  8 2019, 14:14:10) [GCC 5.4.0 20160609]
```

### Avi version

```
Avi 18.2.8
```

### Azure  Region:

```
West Europe
```

## Input/Parameters:

1. All the paramaters/variables are stored in params.yml

## Use the ansible playbook to:
Create an infratructure in Azure:
1. resource group
2. storage accounts (one per VM)
3. Virtual Networks (vnet)
4. routing table (one per subnet)
6. subnets with associated routing table
7. public IPs address
8. security group
9. NICs
10. VMs (jump server, Avi Ctrl, web servers)
11. Populate routing tables
12. Create Ansible Host inventory with private IP (Primary IP) based on group:
```
---
all:
  children:
    jump:
      hosts:
        172.16.1.4:
    controller:
      hosts:
        172.16.1.5:
    webA:
      hosts:
        172.16.2.4:
        172.16.2.5:
  vars:
    ansible_user: "avi"
    ansible_ssh_private_key_file: "/home/avi/.ssh/id_rsa.azure"
```
13. Create Ansible Host inventory with public IP (Primary IP)
```
avi@ansible:~/aviAzure$ more hostsAzurePublicIp
---
all:
  hosts:
    jump:
      ansible_host: 52.157.93.223
    controller1:
      ansible_host: 52.157.89.28
    web1:
      ansible_host: 52.157.89.158
    web2:
      ansible_host: 52.157.95.32
  vars:
    ansible_user: "avi"
    ansible_ssh_private_key_file: "/home/avi/.ssh/id_rsa.azure"
```
14. Create a file with Avi credentials:
```
avi_cluster: false
avi_credentials:
  api_version: 18.2.8
  controller: 172.16.1.5
  password: Avi_2020
  username: admin
```

15. Configure a ssh VPN between the Ansible host (outside the Azure cloud) and the VM named jump (in the cloud)
16. Create a yaml file with the backend servers info:
```
servers:
- ip:
    addr: 172.16.2.4
    type: V4
- ip:
    addr: 172.16.2.5
    type: V4
```

## Run the playbook:
Use the following command to create the infratructure:
```
rm -f hostAzurePublicIp ; ansible-playbook azureCreate.yml ; sleep 5 ; ansible-playbook -i hostsAzurePublicIp routingSsh.yml
```
Use the following command to destroy the infratructure:
```
ansible-playbook destroyRg.yml
```

## Improvement (dev branch):

### dev branch:

### future devlopment:
- Handle a controller cluster use case (multi AZ)
- Handle a multi cloud demonstration
