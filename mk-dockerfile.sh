#!/bin/bash
# make Dockerfile

usage()
{
        echo "Usage: $0 [-d \"seoy/shellTest2\"] [-u \"seoy\"] [-p \"pwd\"]"
       	echo " -d : docker image name"
	echo " -u : docker public repository server id"
	echo " -p : docker public repository server pwd"
        1>&2;
	exit 1;
}

while getopts ":d:u:p:" o; do
    case "${o}" in
        d)
          	echo "FROM ubuntu:14.04"                                   > Dockerfile
	        echo "RUN mkdir imageRepo/"                                >> Dockerfile
        	echo "ADD startup.sh imageRepo/"                           >> Dockerfile
        	echo "RUN chmod 777 -Rf imageRepo/"                        >> Dockerfile
        	echo "RUN sudo apt-get update"                             >> Dockerfile
        	echo "WORKDIR imageRepo"                                   >> Dockerfile
        	echo "RUN sudo apt-get install -y ftp"                     >> Dockerfile
        	echo "CMD /imageRepo/startup.sh"                           >> Dockerfile

		d=${OPTARG}
		sudo docker build --tag ${d} .

            ;;
	u)
          	u=${OPTARG}
            ;;
	p)
          	p=${OPTARG}
		sudo docker login -u ${u} -p ${p}

            ;;

	?)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${d}" ] || [ -z "${u}" ] || [ -z "${p}" ] ; then
  usage
fi

#echo "s = ${s}"
#echo "u = ${p}"
#echo "p = ${u}"


