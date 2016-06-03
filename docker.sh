#!/bin/bash

while getopts "i,b,c,n" opt; do
  case $opt in
      i)
      echo "installing"
      sudo apt-get update
      sudo apt-get install docker docker.io curl linux-image-generic-lts-trusty
      curl -sSL https://get.docker.com/ | sh
      ;;     
     b)
     echo "building docker con";
     sudo docker  build   -t monsetup . 
     ;;
     c) 
      sudo docker  build  --no-cache=true -t monsetup . 
        ;;

      n)
       sudo killall docker;
#      sudo docker run   -e "stack=geo" -e "colo=uj1"  -p 80:80 -i -t myd 
#       sudo docker run  -d  --restart=always -h docker.geo.mon.hkg1.inmobi.com  -e "stack=geo" -e "colo=hkg1"  -p 80:80 -t monsetup
       ;;
     \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
