#!/bin/bash
#
clear
#
#Nombre del master
Nmaster=`whoami`
distros=./distros.txt
#IP master
if [[ -f ./Datos/ip_master.txt ]]
    then
        Imaster=$(cat ./Datos/ip_master.txt | sed -n 1p)
        #Guardamos posible cambio de IP
        distro=$(lsb_release -d)
        echo $distro >> $distros
        if grep -o 'Ubuntu' "$distros";
            then 
                Imaster_nw=`hostname -I | awk '{print $1}'`
            else 
                Imaster_nw=`hostname -i | awk '{print $1}'`
        fi
    else
        distro=$(lsb_release -d)
        echo $distro >> $distros
        if grep -o 'Ubuntu' "$distros";
            then 
                Imaster=`hostname -I | awk '{print $1}'`
            else 
                Imaster=`hostname -i | awk '{print $1}'`
        fi
fi
#Comprobar cambio de IP
if [[ $Imaster != $Imaster_nw ]]
    then
        Imaster=$Imaster_nw
fi
#Borrado de fichero de distros
if [[ -f ./distros.txt ]]
    then
        rm $distros
fi
#Nombre del client
Nconocidos=conocidos_name.txt
touch ./Datos/$Nconocidos
Nclient1=$(cat ./Datos/conocidos_name.txt | sed -n 1p)
Nclient2=$(cat ./Datos/conocidos_name.txt | sed -n 2p)
Nclient3=$(cat ./Datos/conocidos_name.txt | sed -n 3p)

#IP client
Iconocidos=conocidos_ip.txt
touch ./Datos/$Iconocidos
Iclient1=$(cat ./Datos/conocidos_ip.txt | sed -n 1p )
Iclient2=$(cat ./Datos/conocidos_ip.txt | sed -n 2p )
Iclient3=$(cat ./Datos/conocidos_ip.txt | sed -n 3p )

#Cliente completo
client1=$Nclient1@$Iclient1
client2=$Nclient2@$Iclient2
client3=$Nclient3@$Iclient3

#Numero de lineas
num_lin=$(awk 'END {print NR}' ./Datos/conocidos_name.txt)

################################################################################################################## 
#Funciones
nombre_master(){
    echo -e '\n¿Quien está ejecutando el script? Introduce tu nombre de usuario.'
    read Nmaster
}
ip_master(){
    echo -e '\n¿Cuál es tu dirección IP? Introduce tu IP actual(Ej:192.168.X.X).'
    read Imaster
    echo -e '\n¿Estás seguro de que tu IP es '$Imaster'? [si/no]'
    read conf
}
nombre_client(){
    echo -e '\n¿Cual es el nombre del receptor?'
    read Nclient
}
ip_client(){
    echo -e '\n¿Cual es el nombre del receptor?'
    read Nclient
    while [[ -z $Nclient ]]
        do
            nombre_client
        done
    echo -e '\n¿Cuál es su dirección IP? Introduce su IP actual(Ej:192.168.X.X).'
    read Iclient
    echo -e '\n¿Estás seguro de que su IP es '$Iclient' y su nombre es '$Nclient'? [si/no]'
    read conf
    while [[ $conf == no ]]
        do
            ip_client
        done
    ssh-copy-id -o "StrictHostKeyChecking no" $Nclient@$Iclient
    echo $Nclient >> ./Datos/conocidos_name.txt
    echo $Iclient >> ./Datos/conocidos_ip.txt  
}
seleccion_conocidos(){
    echo -e '\nTe quieres volver a conectar a uno de tus contactos conocidos? [si/no]'
        read conf
        if [[ $conf != si ]]
            then
                ip_client
                ssh-copy-id -o "StrictHostKeyChecking no" $Nclient@$Iclient
            else
                if [[ $num_lin == 0 ]]
                    then
                        lista_contactos_vacia
                    else
                        lista_contactos
                fi
        fi
}
lista_contactos(){
    clear
    echo -e '\nLista de contactos \n 1.-'$Nclient1' \n 2.-'$Nclient2' \n 3.-'$Nclient3' \n\n 4.-Borrar contactos \n 5.-Volver al menú anterior'
        read num
        case $num in
        1)  Nclient=$Nclient1
            Iclient=$Iclient1
        ;;
        2)  if [[ $num_lin < 2 ]]
            then
                echo -e '\nEste contacto no existe aún'
                sleep 2
                lista_contactos    
            else
                Nclient=$Nclient2
                Iclient=$Iclient2
            fi
        ;;
        3)  if [[ $num_lin < 3 ]]
            then
                echo -e '\nEste contacto no existe aún'
                sleep 2
                lista_contactos
            else
                Nclient=$Nclient3
                Iclient=$Iclient3
            fi
        ;;
        4)  cat /dev/null > ./Datos/conocidos_ip.txt
            cat /dev/null > ./Datos/conocidos_name.txt 
            Nclient1=
            Nclient2=
            Nclient3=
            Iclient1=
            Iclient2=
            Iclient3=
            seleccion_conocidos
        ;;
        5)  seleccion_conocidos
        ;;
        *)
            while [[ $num != 1 || $num != 2 || $num != 3 || $num != 4 || $num != 5 ]]
                do
                    echo 'Numero no válido'
                    lista_contactos
                done
        esac
}
lista_contactos_vacia(){
    clear
    echo -e '\nNo hay contactos aún'
    echo -e '\nLista de contactos \n 1.-'$Nclient1' \n 2.-'$Nclient2' \n 3.-'$Nclient3' \n\n 4.-Volver al menú anterior'
        read num
        if [[ $num == 1 || $num == 2 || $num == 3 || $num == 4 ]]
            then
                if [[ $num == 1 ]]
                    then
                        lista_contactos_vacia
                elif [[ $num == 2 ]]
                    then
                        lista_contactos_vacia
                elif [[ $num == 3 ]]
                    then
                        lista_contactos_vacia
                elif [[ $num == 4 ]]
                    then    
                        seleccion_conocidos
                fi
        else
                while [[ $num != 1 || $num != 2 || $num != 3 || $num == 4 ]]
                    do
                        echo 'Numero no válido'
                        lista_contactos_vacia
                    done
        fi
}
clusterssh_desconocidos(){
    cat /dev/null > ./Datos/clusters
    echo -e '¿A que IPs quieres haacer cluster ssh?'
    echo -e 'Introduce los nombres y las IPs de la siguiente manera (equipo1@IPequipo1 equipo2@IPequipo2...)'
    read ipcluster
    echo -e '¿EStá seguro de que estos son los equipos a los que se quiere conectar, '$ipcluster'? [si/no]'
    read conf
    while [[ $conf == no ]]
        do
            clusterssh_desconocidos
        done
    echo -e 'autossh '$ipcluster'' >> /home/$Nmaster/.clusterssh/clusters 
    cssh autossh
}
clusterssh_conocidos(){
    if [[ $Nclient1 != "" ]]
        then
            sleep 3
            cluster_conocidos=''$Nclient1@$Iclient1' '$Nclient2@$Iclient2' '$Nclient3@$Iclient3''
        else
            echo -e "No tienes contactos aún"
            sleep 2
            clusterssh_desconocidos
        fi
    cat /dev/null > /home/$Nmaster/.clusterssh/clusters 
    echo -e '¿Quieres hacer cluster ssh a tus contactos conocidos? [si/no]'
    read conf
    if [[ $conf == si ]]
        then
            echo -e 'autossh '$cluster_conocidos'' >> /home/$Nmaster/.clusterssh/clusters 
            cssh autossh
        else
            clusterssh_desconocidos
    fi
}
tipo_de_conexion(){
    echo -e '\n¿Que tipo de conexión quieres hacer? \n  1.-Conexión ssh \n  2.-Copiar archivos \n  3.-Instalar paquetes \n  4.-Conexión por cssh'
    read Amaster
    if [[ $Amaster == 1 || $Amaster == 2 || $Amaster == 3 || $Amaster == 4 ]]
        then
            if [[ $Amaster == 1 ]]
                then
                    ssh -o "StrictHostKeyChecking no" $Nclient@$Iclient
            
            elif [[ $Amaster == 2 ]]
                then
                    echo -e '\n¿Que archivo quieres copiar? Introduce la ruta(/home/tunombre/Escritorio...)'
                    read Rmaster
                    echo -e '\n¿Donde quiere pegar el archivo? Por defecto será el home del receptor. Introduce la ruta(/home/sunombre/Escritorio...)'
                    read Rclient
                    if [[ -z $Rclient ]]
                        then
                            scp $Rmaster $Nclient@$Iclient:/home/$Nclient
                        else
                            scp $Rmaster $Nclient@$Iclient:$Rclient
                    fi  
            elif [[ $Amaster == 3 ]]
                then
                    echo '¿Que paquete/s quieres instalar? Introduce su nombre(Ej:Vim)'
                    read Pclient
                    ssh -o "StrictHostKeyChecking no" $Nclient@$Iclient -X 'sudo -S apt install '$Pclient''
            elif [[ $Amaster == 4 ]]
                then
                    if [[ -f /home/$Nmaster/.clusterssh/clusters ]]
                        then
                            if [[ $num_lin == 0 ]]
                                then
                                    clusterssh_desconocidos
                                    echo -e 'autossh '$ipcluster'' >> /etc/clusters
                                    cssh autossh
                            else
                                clusterssh_conocidos
                                
                            fi
                    else
                        sudo apt install clusterssh
                        touch /home/$Nmaster/.clusterssh/clusters
                        clusterssh_desconocidos
                    fi
            fi
        else
        echo "Introduce un numero correcto"
        exit 0
    fi
}
conexion_s(){
    ssh -o "StrictHostKeyChecking no" $Nclient@$Iclient
}
conexion_cp(){
    echo -e '\n¿Que archivo quieres copiar? Introduce la ruta(/home/tunombre/Escritorio...)'
    read Rmaster
    echo -e '\n¿Donde quiere pegar el archivo? Por defecto será el home del receptor. Introduce la ruta(/home/sunombre/Escritorio...)'
    read Rclient
    if [[ -z $Rclient ]]
        then
            scp $Rmaster $Nclient@$Iclient:/home/$Nclient
        else
            scp $Rmaster $Nclient@$Iclient:$Rclient
    fi  
}
instalar_paquetes(){
    echo '¿Que paquete/s quieres instalar? Introduce su nombre(Ej:Vim)'
    read Pclient
    ssh -o "StrictHostKeyChecking no" $Nclient@$Iclient -X 'sudo -S apt install '$Pclient''
}
tipo_de_conexion_comprobacion(){
    echo -e '\n¿Que tipo de conexión quieres hacer? \n  1.-Conexión ssh \n  2.-Copiar archivos \n  3.-Instalar paquetes \n  4.-Conexión por cssh'
    read Amaster
    if [[ $Amaster == 1 || $Amaster == 2 || $Amaster == 3 || $Amaster == 4 ]]
        then
            if [[ $Amaster == 1 ]]
                then
                    if [[ $num_lin == 0 ]]
                        then
                            ip_client
                            claves
                            conexion_s
                        else
                            seleccion_conocidos
                            claves
                            conexion_s
                    fi
            elif [[ $Amaster == 2 ]]
                then
                    if [[ $num_lin == 0 ]]
                        then
                            ip_client
                            claves
                            conexion_cp
                        else
                            seleccion_conocidos
                            conexion_cp
                    fi
            elif [[ $Amaster == 3 ]]
                then
                    if [[ $num_lin == 0 ]]
                        then
                            ip_client
                            claves
                            instalar_paquetes
                        else
                            seleccion_conocidos
                            instalar_paquetes
                    fi
            elif [[ $Amaster == 4 ]]
                then
                    if [[ -f /home/$Nmaster/.clusterssh/clusters ]]
                    then
                        clusterssh_conocidos
                    else
                        touch /home/$Nmaster/.clusterssh/clusters
                        clusterssh_desconocidos

                    fi
            fi
        else
        echo "Introduce un numero correcto"
        exit 0
    fi
}
claves(){
    if [[ -f ./Datos/confirm ]]
        then
            echo
        else
            echo -e '\nEs la primera vez que utilizas el programa, se van a generar las claves, sigue los pasos. '
            touch ./Datos/confirm
            ssh-keygen -b 4098 
            #IP y nombre del client
            ssh-copy-id -o "StrictHostKeyChecking no" $Nclient@$Iclient
    fi
}
################################################################################################################## 
#Interfaz
#IP del master
bash ./Titulo/Atitle.sh
echo 
echo -e '\nHola '$Nmaster' ¿Esta es tu dirección IP '$Imaster'? [si/no]'
    read conf
    if [[ $conf == si ]]
        then
            echo $Imaster > ./Datos/ip_master.txt
        else
            while [[ $conf == no ]]
                do
                    rm ./Datos/ip_master.txt
                    ip_master
                    echo $Imaster >> ./Datos/ip_master.txt
                done
        
    fi
tipo_de_conexion_comprobacion