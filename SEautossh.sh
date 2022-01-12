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
                lista_contactos
        fi
}
lista_contactos(){
    clear
    echo -e '\nLista de contactos \n 1.-'$Nclient1' \n 2.-'$Nclient2' \n 3.-'$Nclient3' \n\n 4.-Borrar contactos \n 5.-Volver al menú anterior'
        read num
        if [[ $num == 1 || $num == 2 || $num == 3 || $num == 4 || $num == 5 ]]
            then
                if [[ $num == 1 ]]
                    then
                        Nclient=$Nclient1
                        Iclient=$Iclient1
                elif [[ $num == 2 ]]
                    then
                        if [[ $num_lin < 2 ]]
                        then
                            echo -e '\nEste contacto no existe aún'
                            sleep 2
                            lista_contactos    
                        else
                            Nclient=$Nclient2
                            Iclient=$Iclient2
                        fi
                elif [[ $num == 3 ]]
                    then
                        if [[ $num_lin < 3 ]]
                        then
                            echo -e '\nEste contacto no existe aún'
                            sleep 2
                            lista_contactos
                        else
                            Nclient=$Nclient3
                            Iclient=$Iclient3
                        fi
                elif [[ $num == 4 ]]
                    then
                        
                        cat /dev/null > ./Datos/conocidos_ip.txt
                        cat /dev/null > ./Datos/conocidos_name.txt 
                        Nclient1=
                        Nclient2=
                        Nclient3=
                        Iclient1=
                        Iclient2=
                        Iclient3=
                        seleccion_conocidos
                elif [[ $num == 5 ]]
                    then
                        seleccion_conocidos
                fi
        else
                while [[ $num != 1 || $num != 2 || $num != 3 || $num != 4 || $num != 5 ]]
                    do
                        echo 'Numero no válido'
                        lista_contactos
                    done
        fi
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
################################################################################################################## 
#Interfaz
#IP del master
bash ./Titulo/Atitle.sh
echo 
echo -e '\nHola '$Nmaster' ¿Esta es tu dirección IP '$Imaster'? [si/no]'
    read conf
    if [[ $conf == si ]]
        then
            echo $Imaster >> ./Datos/ip_master.txt
        else
            while [[ $conf == no ]]
                do
                    rm ./Datos/ip_master.txt
                    ip_master
                    echo $Imaster >> ./Datos/ip_master.txt
                done
        
    fi

#Claves
if [[ -f ./Datos/confirm ]]
    then
        echo -e '\nTe quieres volver a conectar a uno de tus contactos conocidos? [si/no]'
            read conf
            if [[ $conf != si ]]
                then
                    ip_client
                    ssh-copy-id -o "StrictHostKeyChecking no" $Nclient@$Iclient
            else
                clear
                if [[ $num_lin == 0 ]]
                    then
                        echo -e '\nNo hay contactos aún'
                        lista_contactos_vacia
                else
                    lista_contactos    
                fi        
            fi  
    else
        echo -e '\nEs la primera vez que utilizas el programa, se van a generar las claves, sigue los pasos. '
        touch ./Datos/confirm
        ssh-keygen -b 4098 
        #IP y nombre del client
        echo -e '\n¿Cual es el nombre del receptor?';
        read Nclient
        while [[ -z $Nclient ]]
            do 
                nombre_client
            done
        echo -e '\n¿Cuál es la dirección IP de '$Nclient'? Introduce su IP actual(Ej:192.168.X.X).'
            read Iclient
        echo -e '\n¿Estás seguro de que la IP de '$Nclient' es '$Iclient'? [si/no]'
            read conf
            while [[ $conf != si ]]
                do
                    ip_client
                done
        ssh-copy-id -o "StrictHostKeyChecking no" $Nclient@$Iclient
        echo $Nclient >> ./Datos/conocidos_name.txt
        echo $Iclient >> ./Datos/conocidos_ip.txt
    fi

#Tipo de conexión
echo -e '\n¿Que tipo de conexión quieres hacer? \n  1.-Conexión ssh \n  2.-Copiar archivos \n  3.-Instalar paquetes'
    read Amaster
    if [[ $Amaster == 1 || $Amaster == 2 || $Amaster == 3 ]]
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
            fi
        else
        echo "Introduce un numero correcto"
        exit 0
    fi