#!/bin/bash
#Nombre del master
Nmaster=`whoami`

#IP master
distro=$(lsb_release -d)
distros=./distros.txt
echo $distro >> $distros
if grep -q 'Ubuntu' "$distros";
    then 
        Imaster=`hostname -I`
    else 
        Imaster=`hostname -i`
fi

#Nombre del client
Nconocidos=conocidos_name.txt
touch ./$Nconocidos
Nclient1=$(cat ./conocidos_name.txt | sed -n 1p)
Nclient2=$(cat ./conocidos_name.txt | sed -n 2p)
Nclient3=$(cat ./conocidos_name.txt | sed -n 3p)

#IP client
Iconocidos=conocidos_ip.txt
touch ./$Iconocidos
Iclient1=$(cat ./conocidos_ip.txt | sed -n 1p )
Iclient2=$(cat ./conocidos_ip.txt | sed -n 2p )
Iclient3=$(cat ./conocidos_ip.txt | sed -n 3p )

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
    echo -e '\n¿Estás seguro de que su IP es '$Iclient'? [si/no]'
    read conf
    echo $Nclient >> ./conocidos_name.txt
    echo $Iclient >> ./conocidos_ip.txt  
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
    echo -e '\nLista de contactos \n 1.-'$Nclient1' \n 2.-'$Nclient2' \n 3.-'$Nclient3' \n 4.-Volver al menú anterior'
        read num
        if [[ $num == 1 || $num == 2 || $num == 3 || $num == 4 ]]
            then
                if [[ $num == 1 ]]
                    then
                        Nclient=$Nclient1
                        Iclient=$Iclient1
                elif [[ $num == 2 ]]
                    then
                        Nclient=$Nclient2
                        Iclient=$Iclient2
                elif [[ $num == 3 ]]
                    then
                        Nclient=$Nclient3
                        Iclient=$Iclient3
                elif [[ $num == 4 ]]
                    then
                        seleccion_conocidos
                fi
        else
                while [[ $num != 1 || $num != 2 || $num != 3 || $num == 4 ]]
                    do
                        echo 'Numero no válido'
                        lista_contactos
                    done
        fi
}
################################################################################################################## 

#Interfaz
#IP del master
echo -e '\nHola '$Nmaster' ¿Esta es tu dirección IP '$Imaster'? [si/no]'
    read conf
    while [[ $conf == no ]]
        do
            ip_master
        done
#Claves
echo -e '\n¿Es la primera vez que utilizás el programa? [si/no]'
    read conf
    if [[ $conf == si ]]
        then
            echo 'Se van a generar las claves, sigue los pasos.'
            ssh-keygen -b 4098 
            #IP y nombre del client
            echo -e '\n¿Cual es el nombre del receptor?';
            read Nclient
            echo $Nclient
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
            echo $Nclient >> ./conocidos_name.txt
            echo $Iclient >> ./conocidos_ip.txt  
    else
        echo -e '\nTe quieres volver a conectar a uno de tus contactos conocidos? [si/no]'
            read conf
            if [[ $conf != si ]]
                then
                    ip_client
                    ssh-copy-id -o "StrictHostKeyChecking no" $Nclient@$Iclient
            else
            echo -e '\nLista de contactos \n 1.-'$Nclient1' \n 2.-'$Nclient2' \n 3.-'$Nclient3' \n 4.-Volver al menú anterior'
                read num
                if [[ $num == 1 || $num == 2 || $num == 3 || $num == 4 ]]   
                    then
                        if [[ $num == 1 ]]
                            then
                                Nclient=$Nclient1
                                Iclient=$Iclient1
                        elif [[ $num == 2 ]]
                            then
                                Nclient=$Nclient2
                                Iclient=$Iclient2
                        elif [[ $num == 3 ]]
                            then
                                Nclient=$Nclient3
                                Iclient=$Iclient3
                        elif [[ $num == 4 ]]
                            then
                                seleccion_conocidos
                        fi
                else
                        while [[ $num != 1 || $num != 2 || $num != 3 || $num != 4 ]]
                            do
                                echo 'Numero no válido'
                                lista_contactos
                            done
                fi
            fi
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