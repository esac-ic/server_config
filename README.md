# server_setup
deze repo bevat alles om de server van scratch op te bouwen. Deze readme begint met het uitleggen van de setup van de certificaten en de docker compose, gevolgd door een stappenplan hoe je de server kan opbouwen van scratch.

## Docker-compose
De docker compose start 4 containers op inclusief een cache. de containers zijn alsvolgt:
 * **Laravel app** dit is de hoofd container, het heeft een PHP base image en daarop staat alles ingesteld zodat de container juist werkt. De repo kan [hier](https://github.com/esac-ic/esac.nl) gevonden worden
 * **nginx** De nginx container zorgt ervoor dat het web verkeer op de juiste manier geroute word, hierin staan dingen zoals dat de http requests naar https geforward worden.
 * **certbot** De certbot container zorgt ervoor dat de certificaten van letsencrypt automatisch vervangen worden voordat deze vervallen.
 * **Mysql** de Mysql container bevat de database, deze zit aan een volume vast die persistant is.

## Certificaten
Certificaten komen van [LetsEncrypt](https://letsencrypt.org/) een project wat gratis ssl certificaten verstrekt om het internet veiliger te maken. Certificaten aanvragen kan best complex zijn, certificaten vernieuwen word door onze setup automatisch gedaan maar voordat certificaten vernieuwd kunnen worden moet je ze wel eerst hebben. Omdat certificaten niet openbaar mogen zijn zitten ze niet in deze repo, maar we hebben wel een script waarmee je automatisch de certificaten aanmaakt en in de juiste plek opslaat.

## install
Deze stappen moet je uitvoeren voordat je aan de server setup kan beginnen
1. installeer [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1) en Docker-compose (apt-get install docker-compose)
2. maak een gebruiker "deploy" en geef deze root access
3. clone dit project met ```git clone https://github.com/esac-ic/server_setup.git```
4. zet de /storage map in de home directory van de gebruiker deploy 
5. start ```init.sh``` om de rechten goed te zetten van de /storage map en de rest van de repository 
6. run het script om certificaten te genereren. een vereist is dat het domein esac.nl naar de server verwijst waar je dit script op draait. dit script maakt 2 containers uit een andere docker compose file aan met de configuratie die een submap openzet voor validatie ```init-letsenscript.sh```
7. start de server ```start.sh``` de eerste keer dat je de server draait zal hij de initiele versie pakken, het kan zijn dat deze niet meer werkt, kijk dan in de [docker hub](https://hub.docker.com/repository/docker/esac/website) wat de laatste productie versie is en zet deze versie in ```/versions/website```
8. zet de mysql backup terug, hiervoor moet je eerst mariadb-client installeren op de laravel container en de backup in de /storage folder zetten. ```docker exec -it laravel_app 'apt-get -y update && apt-get install -y mariadb-client && mysql -h $DB_HOST -u $DB_USERNAME -P $DB_PORT -p$DB_PASSWORD $DB_DATABASE < storage/<backup_file.sql>'``` mariadb-client is er weer vanaf bij de eerstvolgende reboot.

That's it, nu zou alles moeten werken.
	

### SSH key instellen voor deployment
Om ervoor te zorgen dat travis kan deployment naar de productie server heeft travis een private key nodig waarvan de public key opgeslagen is op de productie server.
1. maak de ssh key aan: ```ssh-keygen -f prod_key```
2. sla de private key op in travis encoded met base64: ```cat prod_key | base64``` sla deze waarde op onder ```private_key_productie_server``` in https://travis-ci.org/esac-ic/esac.nl/settings en zorg ervoor dat deze alleen in de master branch gebruikt kan worden
3. sla de public key op in de ```authorized keys``` op de server met ```cat prod_key.pub | ssh ic@esac.nl 'cat >> .ssh/authorized_keys'```