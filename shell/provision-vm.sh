#!/bin/bash

# https://cloud.ibm.com/docs/vpc?topic=vpc-creating-virtual-servers&interface=cli
#
# prerequisites
# 
# Check if you have the infrastructure-service plug-in installed.
#   ibmcloud plugin show vpc-infrastructure
# If not, install it:
#   ibmcloud plugin install vpc-infrastructure
#
# Choose an existing resource group or create a new one using
#   ibmcloud resource group-create <group-name>
# 
# Have a VPC ready or create a new one using
#   ibmcloud is vpc-create [name-vpc]
#
# Select an existing subnet in the VPC or create a new one:
#   ibmcloud is subnet-create my-subnet $vpc eu-de-1 --ipv4-cidr-block "10.243.0.0/24"
#
# Use an existing or create a new SSH key
#   https://cloud.ibm.com/vpc-ext/compute/sshKeys
# 
# Login into IBM Cloud e.g. using "ibmcloud login --sso"

# Turn on command echoing
set -x

# Exit immediately if a command exits with a non-zero status.
set -e

REGION=eu-de
RESOURCE_GROUP=martin-test-nfs

# VPC_NAME=kombit-test-vpc
# VPC_NAME=vpc-prod-platform
# VPC_ID=r010-149a7a52-10e8-4234-a6ee-5fa0ef6c5b43
# VPC_ID=r010-6d95af1c-c797-4b9d-8438-c0768ced2776
# SUBNET_ID=02b7-3aac82ff-e913-4ec9-b9f6-0b3efbf80206
# SUBNET_ID=02b7-9cf65574-785f-4d15-bb54-0046db7722af

VPC_NAME=martin-test-nfs-vpc
VPC_ID=r010-a5d24308-8f45-4ea5-8f81-3cbaee1d36ac
SUBNET_ID=02b7-3b930fa8-2919-409e-b701-d7b612444119

# https://cloud.ibm.com/vpc-ext/compute/sshKeys
SSH_KEY_ID=r010-6543cd88-ff7c-4ccd-bd76-b603c19ed130
# ibmcloud is zones
ZONE_NAME=eu-de-1
VM_INSTANCE_NAME=nfs-test
# ibmcloud is instance-profiles
INSTANCE_PROFILE_NAME=bx2-2x8
# ibmcloud is images
IMAGE_NAME=ibm-ubuntu-22-04-3-minimal-amd64-1

# Configure the CLI plug-in to target generation 2 virtual server instances for VPC
ibmcloud is target --gen 2

# Set a target region
ibmcloud target -r $REGION

# Set a target resource group
ibmcloud target -g $RESOURCE_GROUP

# Create a public gateway:
# ibmcloud is public-gateway-create [my-gateway] $vpc eu-de-1

# Attach the public gateway to your subnet:
# ibmcloud is subnet-update $subnet --pgw $gateway

ibmcloud is instance-create $VM_INSTANCE_NAME $VPC_ID $ZONE_NAME $INSTANCE_PROFILE_NAME \
$SUBNET_ID --image-id $IMAGE_NAME --key-ids $SSH_KEY_ID

# ibmcloud is vpc-sg $VPC_ID

ibmcloud is instance $VM_INSTANCE_NAME

# ibmcloud is floating-ip-reserve nfs-test-floatingip --nic $NIC
#ibmcloud is floating-ip-reserve nfs-test1-floatingip --nic 02b7-540a63b8-1106-45c2-bfa9-40a0ffd3cbb4

# connect to the VM
# ssh -i $HOME/.ssh/id_rsa root@$address

# Cleanup:
# - delete resource group: ibmcloud resource group-delete martin-nfs-test
# - delete SSH key
# - delete VM instance: ibmcloud is instance-delete <instance-id_or_name>
# - delete the floating IP: ibmcloud is floating-ip-release <floating-ip-name>
# - delete security group rules
