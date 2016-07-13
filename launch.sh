#! /bin/sh 

# make executable shell script in container

echo "#!/bin/sh"                                   > startup.sh
echo "cd /imageRepo"                               >> startup.sh
echo "SERVER=\"192.168.0.136\""                    >> startup.sh
echo "USER=\"buff\""                               >> startup.sh
echo "PASS=\"1111\""                               >> startup.sh
echo "ftp -in \$SERVER 50021<<EOF"                 >> startup.sh
echo "passive"                                     >> startup.sh
echo "user \$USER \$PASS"                          >> startup.sh
echo "mput *"                                      >> startup.sh
echo "bye"                                         >> startup.sh
echo "EOF"                                         >> startup.sh

sudo chmod 777 startup.sh

# make Dockerfile

echo "FROM ubuntu:14.04"                                   > Dockerfile
echo "RUN mkdir imageRepo/"                                >> Dockerfile
echo "ADD startup.sh imageRepo/"                           >> Dockerfile
echo "RUN chmod 777 -Rf imageRepo/"                        >> Dockerfile
echo "RUN sudo apt-get update"                             >> Dockerfile
echo "WORKDIR imageRepo"                                   >> Dockerfile
echo "RUN sudo apt-get install -y ftp"                     >> Dockerfile
echo "CMD /imageRepo/startup.sh"                           >> Dockerfile

# docker image build

sudo docker build --tag seoy/shelltest2 .
sudo docker login -u "seoy" -p "Neanias78!"
sudo docker push seoy/shelltest2



# make json file to job submit

echo "{"                                                  > docker.json
echo  "	\"schedule\": \"R1/2014-09-25T17:22:00Z/PT2M\","  >> docker.json
echo  "	\"name\": \"shellTest\","                         >> docker.json
echo  "	\"container\": {"                                 >> docker.json
echo  "		\"type\": \"DOCKER\","                    >> docker.json
echo  "		\"image\": \"seoy/shelltest2\","          >> docker.json
echo  "		\"network\": \"BRIDGE\""                  >> docker.json
echo  "	},"                                               >> docker.json
echo  "	\"cpus\": \"0.5\","                               >> docker.json
echo  "	\"mem\": \"512\","                                >> docker.json
echo  "	\"uris\": [],"                                    >> docker.json
echo  "	\"command\": \"/imageRepo/startup.sh\""           >> docker.json
echo "}"                                                  >> docker.json

# job submit

curl -L -H 'Content-Type: application/json' -X POST -d @docker.json 192.168.65.141:5465/scheduler/iso8601

