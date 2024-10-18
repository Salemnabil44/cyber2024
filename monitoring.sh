#!/bin/bash

# Script de monitoring
# Enlève les messages d'erreur
exec 2>/dev/null

# Fonction pour écrire les informations sur tous les terminaux
write_to_terminals() {
    wall <<EOF
Détails du système :
-----------------------------------
Architecture : $(uname -m)
Version du kernel : $(uname -r)

Nombre de processeurs physiques : $(grep -c 'physical id' /proc/cpuinfo)
Nombre de processeurs virtuels : $(grep -c 'processor' /proc/cpuinfo)

Mémoire vive disponible : $(free -h | awk '/^Mem:/ {print $4}') (Utilisation : $(free | awk '/^Mem:/ {printf "%.2f%\n", $3/$2 * 100.0}'))
Mémoire disponible : $(free -h | awk '/^Swap:/ {print $4}') (Utilisation : $(free | awk '/^Swap:/ {printf "%.2f%\n", $3/$2 * 100.0}'))

Taux d'utilisation des processeurs : $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
Date et heure du dernier redémarrage : $(who -b | awk '{print $3, $4}')

LVM actif : $(lsblk | grep -q lvm && echo "Oui" || echo "Non")
Nombre de connexions actives : $(who | wc -l)
Nombre d'utilisateurs : $(users | wc -w)

Adresse IPv4 : $(hostname -I | awk '{print $1}')
Adresse MAC : $(ip link show | awk '/ether/ {print $2; exit}')

Nombre de commandes exécutées avec sudo : $(grep -c 'COMMAND=' /var/log/auth.log)

EOF
}

# Exécuter la fonction de monitoring toutes les 5 minutes
while true; do
    write_to_terminals
    sleep 300  # 300 secondes = 5 minutes
done
