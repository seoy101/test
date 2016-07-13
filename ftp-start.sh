#!/bin/bash

usage() 
{ 
	echo "Usage: $0 [-s \"192.168.0.136\"] [-u \"buff\"] [-p \"1111\"]"  
	echo " -s : ftp Server address"
	echo " -u : ftp user id"
	echo " -p : ftp user password"
	1>&2;
        exit 1;
}

while getopts ":s:u:p:" o; do
    case "${o}" in
        s)
		s=${OPTARG}
		echo "#!/bin/sh"                                   > startup.sh
		echo "cd /imageRepo"                               >> startup.sh
		echo "SERVER=${s}"                            	   >> startup.sh

            ;;
        u)
             	u=${OPTARG}
		echo "USER=${u}"                              	   >> startup.sh
            ;;
	p)
		p=${OPTARG}
		echo "PASS=${p}"                              	   >> startup.sh
                echo "ftp -in \$SERVER 50021<<EOF"                 >> startup.sh
                echo "passive"                                     >> startup.sh
                echo "user \$USER \$PASS"                          >> startup.sh
                echo "mput *"                                      >> startup.sh
                echo "bye"                                         >> startup.sh
                echo "EOF"                                         >> startup.sh		
		sudo chmod 777 startup.sh
	    ;;
        ?)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${s}" ] || [ -z "${u}" ] || [ -z "${p}" ]; then
  usage
fi

#echo "s = ${s}"
#echo "u = ${p}"
#echo "p = ${u}"
