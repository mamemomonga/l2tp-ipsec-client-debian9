#!/bin/bash
set -eux

sudo ip route flush all
sudo ip route restore < ip-route-save

