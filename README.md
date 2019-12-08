# server_setup
deze repo bevat alles om de server van scratch op te bouwen. Deze readme begint met het uitleggen van de setup van de certificaten en de docker compose, gevolgd door een stappenplan hoe je de server kan opbouwen van scratch.

## Docker-compose
De docker compose start 3 containers op inclusief een cache. de containers zijn alsvolgt:
 * **Laravel app** dit is de hoofd container, het heeft een PHP base image en daarop staat alles ingesteld zodat de container juist werkt. De repo kan [hier](https://github.com/esac-ic/esac.nl) gevonden worden
 * **nginx** De nginx container zorgt ervoor dat het web verkeer op de juiste manier geroute word, hierin staan dingen zoals dat de http requests naar https geforward worden.
 * **certbot** De certbot container zorgt ervoor dat de certificaten van letsencrypt automatisch vervangen worden voordat deze vervallen.

## Certificaten
Certificaten komen van [LetsEncrypt](https://letsencrypt.org/) een project wat gratis ssl certificaten verstrekt om het internet veiliger te maken. Certificaten aanvragen kan best complex zijn, certificaten vernieuwen word door onze setup automatisch gedaan maar voordat certificaten vernieuwd kunnen worden moet je ze wel eerst hebben. Omdat certificaten niet openbaar mogen zijn zitten ze niet in deze repo, maar we hebben wel een script waarmee je automatisch de certificaten aanmaakt en in de juiste plek opslaat.

## Server setup, installatie
1. Clone de repo

	git clone https://github.com/esac-ic/server_setup.git

2. run het script om certificaten te genereren. een vereist is dat het domein esac.nl naar de server verwijst waar je dit script op draait. dit script maakt 2 containers uit een andere docker compose file aan met de configuratie die een submap openzet voor validatie.

	./init-letsenscript.sh

3. kopieer de mysql en de /storage van de backup server
4. start de server

	docker-compose up -d

