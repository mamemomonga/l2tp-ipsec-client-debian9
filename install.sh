#!/bin/bash
set -eu

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y strongswan xl2tpd

