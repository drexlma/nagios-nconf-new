
Nagios Setup
==========================================
* Docker container for CORP IT Nagios
* will install from source - apache2,mysql,nagios,nconf,mysqlsetup for nconf.
* uses supervisord for process control.
* Generate Nagios config on nconf ui will executed deploy_local.sh internally
* All valid  generated confs pushed directly to inmobi-noc s3 and directly downloaded on container starts.
* To build container sudo docker build -t  tagname location of Dockerfile .eg sudo docker build -t  monsetup .
* To run docker container in background run
  sudo docker run  -d  -h desired docker hostname -e "stack=desired stack" -p 80:80 -it   docker image tag 
* Example :  sudo docker run -d -h corpit-nagios.corp.inmobi.com --restart=always -e "stack=corpit-nagios" -p 9000:80 --name corpit-nagios -it dev-dockerhub.corp.             inmobi.com:7000/noc/corpit-nagios:dc0a7272ea8c-master-2
* latest - dev-dockerhub.corp.inmobi.com:7000/noc/corpit-nagios:dc0a7272ea8c-master-2
   
   
