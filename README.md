# server_setup
deze repo bevat alles om de server van scratch op te bouwen. Deze readme begint met het uitleggen van de setup van de certificaten en de docker compose, gevolgd door een stappenplan hoe je de server kan opbouwen van scratch.

## Docker-compose
De docker compose start 3 containers op inclusief een cache. de containers zijn alsvolgt:
 * **Laravel app** dit is de hoofd container, het heeft een PHP base image en daarop staat alles ingesteld zodat de container juist werkt. De repo kan [hier](https://github.com/esac-ic/esac.nl) gevonden worden
 * **nginx** De nginx container zorgt ervoor dat het web verkeer op de juiste manier geroute word, hierin staan dingen zoals dat de http requests naar https geforward worden.
 * **certbot** De certbot container zorgt ervoor dat de certificaten van letsencrypt automatisch vervangen worden voordat deze vervallen.

## Certificaten
Certificaten komen van [LetsEncrypt](https://letsencrypt.org/) een project wat gratis ssl certificaten verstrekt om het internet veiliger te maken. Certificaten aanvragen kan best complex zijn, certificaten vernieuwen word door onze setup automatisch gedaan maar voordat certificaten vernieuwd kunnen worden moet je ze wel eerst hebben. Omdat certificaten niet openbaar mogen zijn zitten ze niet in deze repo, maar we hebben wel een script waarmee je automatisch de certificaten aanmaakt en in de juiste plek opslaat.

## pre install
Deze stappen moet je uitvoeren voordat je aan de server setup kan beginnen
1. installeer [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce-1) en Docker-compose (apt-get install docker-compose)
2. maak een gebruiker "deploy" en geef deze root access
3. installeer [mysq](https://www.digitalocean.com/community/questions/mysql-installation-error-dpkg-error-processing-package-mysql-server-5-5-configure) bekijk de url want normaal lukt dit niet op digitalocean
4. maak root user in database aan: https://stackoverflow.com/questions/5555328/error-1396-hy000-operation-create-user-failed-for-jacklocalhost
5. maak deploy user aan in database: create user deploy@localhost identified by
6. geef gebruiker alle rechten GRANT ALL PRIVILEGES ON * . * TO 'deploy'@'localhost';
7. wijzig de bind op localhost in het interne ip van de server (te vinden met ifconfig eth0) in de file /etc/mysql/mysql.conf.d/mysqld.cnf en herstart mysql: /etc/init.d/mysql restart

## Server setup, installatie
1. Clone de repo

	git clone https://github.com/esac-ic/server_setup.git

2. run het script om certificaten te genereren. een vereist is dat het domein esac.nl naar de server verwijst waar je dit script op draait. dit script maakt 2 containers uit een andere docker compose file aan met de configuratie die een submap openzet voor validatie.

	./init-letsenscript.sh

3. kopieer de mysql en de /storage van de backup server
4. configureer mysql
5. start de server

	docker-compose up -d
	
	
	
	
#start nieuwe docs

command voor setup in laravel container: 
apt-get -y update && apt-get install -y mariadb-client
mysql -h $DB_HOST -u $DB_USERNAME -P $DB_PORT -p$DB_PASSWORD $DB_DATABASE

chown -R www-data:www-data storage/

chmod u+x start.sh
chmod u+x update.sh

deploy setup:
describe setup of ssh keys of deployment

check latest docker image

#todo: 
backup container maken, schrijft elke dag? uur? mysql database weg naar een file, 
en tarbal naar backup en packaged dat weer

restore optie maken?

local development docker compose maken met docker-compose.override.yml
vervangen waardes: nginx, geen  certbot, geen backups

test ci/cd pipeline with new scripts
setup ci/cd pipeline for prod
