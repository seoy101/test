#!/bin/sh
#mkdir test
#chmod 777 test
#cp -r data test/data
#cp exe1.sh test
#cd test

# make executable shell script in container
echo #!/bin/sh					 > startup.sh
echo SERVER="192.168.0.136"			>> startup.sh
echo USER="buff"  				>> startup.sh
echo PASS="1111"				>> startup.sh
echo cd /home/test				>> startup.sh
echo ftp -in $SERVER 50021<<EOF			>> startup.sh
echo passive					>> startup.sh
echo user $USER $PASS				>> startup.sh
echo mput *					>> startup.sh
echo bye					>> startup.sh
echo EOF					>> startup.sh


# make Dockerfile
echo FROM ubuntu:14.04 > Dockerfile
echo ADD data /home/test/ >>Dockerfile
echo ADD exe1.sh /home/ >>Dockerfile
echo RUN sudo apt-get update >>Dockerfile
echo RUN sudo apt-get install -y ftp >> Dockerfile
echo CMD /home/exe1.sh >> Dockerfile
echo WORKDIR /home >> Dockerfile

# docker image build
# shell script parma tag, id, pwd 
sudo docker build --tag seoy/shelltest1 .
sudo docker login -u "seoy" -p "Neanias78!" 
sudo docker push seoy/shelltest1
sudo docker rmi seoy/shelltest1
rm -rf test

#make json file
echo { 							> docker.json
echo  "schedule": "R1/2014-09-25T17:22:00Z/PT2M",      >> docker.json
echo  "name": "dockerjob", 			       >> docker.json	
echo  "container": {                                   >> docker.json
echo    "type": "DOCKER",                              >> docker.json
echo    "image": "seoy/bwa",                           >> docker.json
echo    "network": "BRIDGE"			       >> docker.json		
       },                   			       >> docker.json
echo  "cpus": "0.5",				       >> docker.json			
echo  "mem": "512",				       >> docker.json
echo  "uris": [],                                      >> docker.json  
echo  "command": "/bwa index MT.fa"                    >> docker.json
echo }                                                 >> docker.json

# job submit
# shell script param json name, ip
curl -L -H 'Content-Type: application/json' -X POST -d @docker.json 192.168.65.121:11701/scheduler/iso8601








