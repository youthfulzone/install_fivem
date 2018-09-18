# Fishy Hosting - FiveM Install

Pentru automatizarea procesului de instalare a serverelor FiveM puteti folosi acest script.

Instructiuni:

1. Intrati in PuTTY: https://wiki.fishy-hosting.ro/putty.php

2. Scrieti comanda `cd` in PuTTY. Copiati comanda si dati click-dreapta in fereastra PuTTY, apoi apasati ENTER.
`~/
3. Scrieti comanda `git clone https://github.com/youthfulzone/install_fivem.git; sudo mv ~/install_fivem/install_fivem.sh ~/; rm -rf install_fivem; chmod 777 install_fivem.sh`. Din nou copiati comanda si dati click dreapta in fereastra PuTTY, apoi apasati ENTER.

4. Scrieti comanda `./install_fivem.sh fivem` pentru a instala un nou server FiveM.

5. Dupa instalarea cu succes a primului server FiveM o sa fie afisate o lista cu comenzile disponibile ale serverului respectiv.

> Foarte important! Acest script functioneaza fara buguri doar pe VPS-urile noastre Ubuntu cu support. Nu garantam functionarea in parametri normali pe alte sisteme.

Acest script va oferi posibilitatea sa porniti/ opriti/ reporniti/ reinstalati/ upgradati/ stergeti serverul. 

