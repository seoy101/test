#!/bin/sh

# make Dockerfile
echo "FROM ubuntu:14.04"                                   > Dockerfile
echo "RUN mkdir imageRepo/"          	       	       	   >> Dockerfile
echo "RUN chmod 777 imageRepo/"                            >> Dockerfile
echo "ADD startup.sh imageRepo/"                           >> Dockerfile
echo "RUN sudo apt-get update"                             >> Dockerfile
echo "WORKDIR imageRepo"                                   >> Dockerfile
echo "RUN sudo apt-get install -y ftp"                     >> Dockerfile
echo "CMD imageRpo/startup.sh"                             >> Dockerfile

# docker image build

sudo docker build --tag seoy/shelltest1 .
sudo docker login -u "seoy" -p "Neanias78!"
sudo docker push seoy/shelltest1
sudo docker run -it --name shelltest1 seoy/shelltest1 /bin/sh

