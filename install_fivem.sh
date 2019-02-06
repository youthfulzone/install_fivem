#!/bin/bash

file=`basename "$0"`

function newFivemServer()
{

yes | sudo apt-get install xz-utils

set -e

function cleanup_exit {

  echo "Instalarea serverului a fost anulata de catre utilizator."
  
  rm -rf ~/ftp/server/$1 >/dev/null 2>&1
  
  rm ~/$1 >/dev/null 2>&1
  
  rm -rf ~/runtime.fivem.net >/dev/null 2>&1
}

function cleanup_error {

  echo "Instalarea serverului a esuat. Va rugam contactati un administrator pentru support."
  
  rm -rf ~/ftp/server/$1 >/dev/null 2>&1
  
  rm ~/$1 >/dev/null 2>&1
  
  rm -rf ~/runtime.fivem.net >/dev/null 2>&1
}

trap cleanup_exit INT

trap cleanup_error ERR

trap "" SIGTSTP

mkdir "/home/$me/ftp/server/$1" 

wget --spider -r --no-parent https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ 
		
rm -rf ~/runtime.fivem.net/artifacts/fivem/build_proot_linux/master/revoked
	
url=$(ls ~/runtime.fivem.net/artifacts/fivem/build_proot_linux/master | tail -1)

cd ~/ftp/server/$1

wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$url/fx.tar.xz 

sudo tar xf ~/ftp/server/$1/fx.tar.xz

rm ~/ftp/server/$1/fx.tar.xz

git clone https://github.com/citizenfx/cfx-server-data.git ~/ftp/server/$1/server-data

cat >> ~/ftp/server/$1/server-data/server.cfg <<EOM
# you probably don't want to change these!
# only change them if you're using a server with multiple network interfaces
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

start mapmanager
start chat
start spawnmanager
start sessionmanager
start fivem
start hardcap
start rconlog
start scoreboard
start playernames

sv_scriptHookAllowed 1

# change this
#rcon_password yay

# a comma-separated list of tags for your server
# for example: sets tags "drifting, cars, racing" or sets tags "roleplay, military, tanks"
sets tags "default"
# set an optional server info and connecting banner image url.
# size doesn't matter, any banner sized image will be fine.
#sets banner_detail "http://url.to/image.png"
#sets banner_connecting "http://url.to/image.png"

sv_hostname "My new FXServer!"

# nested configs!
#exec server_internal.cfg

# loading a server icon (96x96 PNG file)
#load_server_icon myLogo.png

# convars for use from script
set temp_convar "hey world!"

# disable announcing? clear out the master by uncommenting this (your server will not be listed in the serverlist if you uncomment this!)
#sv_master1 ""

# want to only allow players authenticated with a third-party provider like Steam (don't forget, Social Club is a third party probvider too!)?
#sv_authMaxVariance 1
#sv_authMinTrust 5

# add system admins
add_ace group.admin command.quit deny # but don't allow quit
add_principal identifier.steam:110000112345678 group.admin # add the admin to the group

# remove the # to hide player endpoints in external log output
sv_endpointprivacy true

# server slots limit (must be between 1 and 31)
sv_maxclients 30

# license key for server (https://keymaster.fivem.net)
sv_licenseKey changeme
EOM
cat >> ~/$1 <<EOM
#!/bin/bash

set -e

me=\$(whoami)
name=\`basename "\$0"\`
path="/home/\$me/ftp/server/\$name/"
loc="/home/\$me/ftp/server/\$name/server-data"
ip=\$(hostname -i)

function delete {
echo ""

read -r -p "Sigur doresti asta? Toate fiserele serverului vor fi sterse. [Da/Nu]: " response

echo ""

response=\$(echo "\$response" | tr '[:upper:]' '[:lower:]')

if [ "\$response" = "da" ]; then

if [ -d "/home/\$me/ftp/server/\$name" ]; then

	rm -rf ~/ftp/server/\$name

fi

rm -rf ~/\$name

else

  echo ""

  echo -e "\033[0;31mOperatiune anulata de catre utilizator.\033[0m"

  echo ""

  exit

fi

}

function backup {

if [ ! -d "/home/\$me/ftp/server/backups" ]; then

  mkdir /home/\$me/ftp/server/backups

fi

date=\$(date +%Y-%m-%d_%H:%M:%S)

tar cf - /home/\$me/ftp/server/\$name -P | pv -s \$(du -sb \$name | awk '{print \$1}') |  gzip > /home/\$me/ftp/server/backups/\$name-\$date.tar.gz

}

function install_service {

if [ ! -d "/home/\$me/ftp/server/\$name" ]; then

function cleanup_install_error {

  echo ""

  echo -e "\033[0;31mOperatiunea a esuat. Va rugam contactati un administrator pentru support.\033[0m"

  echo ""

  if [ -d "/home/\$me/ftp/server/\$name" ]; then

        rm -rf ~/ftp/server/\$name >/dev/null 2>&1

  fi

  if [ -d "/home/\$me/runtime.fivem.net" ]; then

        rm -rf ~/runtime.fivem.net

  fi

  exit
}

function cleanup_install_exit {

  echo ""

  echo -e "\033[0;31mOperatiunea a esuat. Va rugam contactati un administrator pentru support.\033[0m"

  echo ""

  if [ -d "/home/\$me/ftp/server/\$name" ]; then

        rm -rf ~/ftp/server/\$name >/dev/null 2>&1

  fi

  if [ -d "/home/\$me/runtime.fivem.net" ]; then

        rm -rf ~/runtime.fivem.net

  fi

  exit
}

trap cleanup_install_exit INT

trap cleanup_install_error ERR

trap "" SIGTSTP

mkdir "/home/\$me/ftp/server/\$name"

wget --spider -r --no-parent https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/

rm -rf ~/runtime.fivem.net/artifacts/fivem/build_proot_linux/master/revoked

url=\$(ls ~/runtime.fivem.net/artifacts/fivem/build_proot_linux/master | tail -1)

cd ~/ftp/server/\$name

wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/\$url/fx.tar.xz

sudo tar xf ~/ftp/server/\$name/fx.tar.xz

rm ~/ftp/server/\$name/fx.tar.xz

git clone https://github.com/citizenfx/cfx-server-data.git ~/ftp/server/\$name/server-data

cat >> ~/ftp/server/\$name/server-data/server.cfg <<EOF
# you probably don't want to change these!
# only change them if you're using a server with multiple network interfaces
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

start mapmanager
start chat
start spawnmanager
start sessionmanager
start fivem
start hardcap
start rconlog
start scoreboard
start playernames

sv_scriptHookAllowed 1

# change this
#rcon_password yay

# a comma-separated list of tags for your server
# for example: sets tags "drifting, cars, racing" or sets tags "roleplay, military, tanks"
sets tags "default"
# set an optional server info and connecting banner image url.
# size doesn't matter, any banner sized image will be fine.
#sets banner_detail "http://url.to/image.png"
#sets banner_connecting "http://url.to/image.png"

sv_hostname "My new FXServer!"

# nested configs!
#exec server_internal.cfg

# loading a server icon (96x96 PNG file)
#load_server_icon myLogo.png

# convars for use from script
set temp_convar "hey world!"

# disable announcing? clear out the master by uncommenting this (your server will not be listed in the serverlist if you uncomment this!)
#sv_master1 ""

# want to only allow players authenticated with a third-party provider like Steam (don't forget, Social Club is a third party probvider too!)?
#sv_authMaxVariance 1
#sv_authMinTrust 5

# add system admins
add_ace group.admin command.quit deny # but don't allow quit
add_principal identifier.steam:110000112345678 group.admin # add the admin to the group

# remove the # to hide player endpoints in external log output
sv_endpointprivacy true

# server slots limit (must be between 1 and 31)
sv_maxclients 30

# license key for server (https://keymaster.fivem.net)
sv_licenseKey changeme
EOF

echo ""

echo -e "\033[0;32mServerul a fost instalat cu succes!\033[0m"

exit

else

        echo ""

        read -r -p "Sigur doresti asta? Toate fisierele serverul vor fi sterse iar serverul va fi reinstalat. [Da/Nu]: " response

        echo ""

        response=\$(echo "\$response" | tr '[:upper:]' '[:lower:]')

        if [ "\$response" = "da" ]; then

          rm -rf ~/ftp/server/\$name

          install_service

        else

          exit

        fi

fi

}

function start_service {

if [ -d "\$path" ]; then

  if [ -d "\$loc" ]; then

    if ! screen -list | grep -q \$name; then

      if [ -d "/home/\$me/ftp/server/\$name/server-data/cache" ]; then

        rm -rf /home/\$me/ftp/server/\$name/server-data/cache

      fi

      cd \$loc

      screen -L -d -m -S \$name bash -c "sh \${path}run.sh +exec server.cfg"

      sleep 3

      if screen -list | grep -q \$name; then >/dev/null 2>&1

        echo ""

        echo \-e "\033[0;32mServerul a fost pornit cu succes.\033[0m"

        echo ""

        echo "Puteti accesa serverul la IP: \$ip"

        echo ""

      else

        echo ""

        echo -e "\033[0;31mEroare la pornirea serverului. Va rugam verificati configuratia serverului.\033[0m"

        echo ""

      fi

    else

      echo ""

      echo "Serverul este deja pornit."

      echo ""

    fi

  fi

else

echo "Nu exista nici un server instalat cu numele \$me."

echo ""

echo "Folositi comanda ./\$me install pentru a instala serverul."

fi

}

function stop_service {

if screen -list | grep -q \$name; then >/dev/null 2>&1

  screen -X -S \$name quit

  sleep 3

  if ! screen -list | grep -q \$name; then >/dev/null 2>&1

    echo ""

    echo "\033[0;32mServerul a fost oprit cu succes.\033[0m"

    echo ""

  else

    echo ""

    echo -e "\033[0;31mOprirea serverului a esuat.\033[0m"

    echo ""

  fi

else

echo ""

echo -e "\033[0;31mOperatiunea anulata. Serverul nu este pornit.\033[0m"

echo ""

exit

fi

}

function console {

echo ""

read -r -p "Sigur doresti asta? [Da/Nu] (CTRL + D pentru a iesi din consola): " response

response=\$(echo "\$response" | tr '[:upper:]' '[:lower:]')

if [ "\$response" = "da" ]; then

   if screen -list | grep -q \$name; then >/dev/null 2>&1

     screen -r \$name

   else

     echo ""

     echo -e "\033[0;31mOperatiunea anulata. Serverul nu este pornit.\033[0m"

     echo ""

   fi

else

  echo ""

  echo -e "\033[0;31mOperatiune anulata de catre utilizator.\033[0m"

  echo ""

  exit

fi

}

function upgrade_service {

if [ -d "/home/\$me/ftp/server/\$name" ]; then

function cleanup_server_exit {

  echo ""

  echo -e "\033[0;31mOperatiune anulata de catre utilizator.\033[0m"

  echo ""

  if [ -f "/home/\$me/ftp/server/\$name/fx.tar.xz" ]; then

        rm ~/ftp/server/\$name/fx.tar.xz >/dev/null 2>&1

  fi

  if [ -d "/home/\$me/runtime.fivem.net" ]; then

        rm -rf ~/runtime.fivem.net

  fi

  exit
}

function cleanup_server_error {

  echo ""

  echo -e "\033[0;31mOperatiunea a esuat. Va rugam contactati un administrator pentru support.\033[0m"

  echo ""

  if [ -f "/home/\$me/ftp/server/\$name/fx.tar.xz" ]; then

        rm ~/ftp/server/\$name/fx.tar.xz >/dev/null 2>&1

  fi

  if [ -d "/home/\$me/runtime.fivem.net" ]; then

        rm -rf ~/runtime.fivem.net

  fi

  exit
}

trap cleanup_server_exit INT

trap cleanup_server_error ERR

trap "" SIGTSTP

wget --spider -r --no-parent https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/

rm -rf ~/runtime.fivem.net/artifacts/fivem/build_proot_linux/master/revoked

url=\$(ls ~/runtime.fivem.net/artifacts/fivem/build_proot_linux/master | tail -1)

cd ~/ftp/server/\$name

wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/\$url/fx.tar.xz

sudo tar xf ~/ftp/server/\$name/fx.tar.xz

rm ~/ftp/server/\$name/fx.tar.xz

rm -rf ~/runtime.fivem.net >/dev/null 2>&1

version=\$(echo \$url | head -c 4)

echo \-e "Serverul a fost upgradat la ultima versiune disponibila: \033[1;36m\$version\033[0m."

echo ""

else

        echo ""

        echo -e "\033[0;31mOperatiune anulata. Serverul nu este instalat.\033[0m"

        echo ""

fi
}

if [ "\$1" = "start" ]; then
start_service
elif [ "\$1" = "stop" ]; then
stop_service
elif [ "\$1" = "restart" ]; then
stop_service

  if [ \$? -eq 0 ]; then

    sleep 3

    start_service

  fi

elif [ "\$1" = "console" ]; then
console
elif [ "\$1" = "delete"  ]; then
delete
elif [ "\$1" = "upgrade" ]; then
upgrade_service
elif [ "\$1" = "install" ]; then
install_service
elif [ "\$1" = "backup" ]; then
backup
else
echo "Alegeti o comanda (copiaza codul albastru):"
echo ""
echo \-e "\033[1;36m ./\$name start\033[0m       | Pentru a PORNI serverul."
echo \-e "\033[1;36m ./\$name stop\033[0m        | Pentru a OPRI serverul."
echo \-e "\033[1;36m ./\$name restart\033[0m     | Pentru a RESTARTA serverul."
echo \-e "\033[1;36m ./\$name upgrade\033[0m     | Pentru a UPGRADA serverul."
echo \-e "\033[1;36m ./\$name install\033[0m     | Pentru a instala serverul."
echo \-e "\033[1;36m ./\$name backup\033[0m      | Pentru a efectua backup serverului."
echo \-e "\033[1;36m ./\$name console\033[0m     | Pentru a intra in CONSOLA."
echo \-e "\033[1;36m ./\$name delete\033[0m      | Pentru a sterge serverul."
echo ""
fi
EOM

chmod 777 ~/$1

rm -rf ~/runtime.fivem.net

cd

./$1

}

if [ "$1" = "fivem" ]; then

me=$(whoami)

number=1

name="fivem"

  if [ ! -d "/home/$me/ftp/server/$name" ]; then

   newFivemServer "$name"

  elif [ -d "/home/$me/ftp/server/$name" ]; then

    while [[ -d "/home/$me/ftp/server/$name-$number"  ]]; do

      number=$(($number+1))

    done

    newFivemServer "$name-$number"
	
  fi

else

echo ""

echo -e "\033[1;36m ./$file fivem\033[0m     | Pentru a instala un server fivem." 
  
echo ""  
  
fi
