#!/bin/bash

rsync -av /opt/bartlby/ -e "ssh -i /storage/SF.NET/BARTLBY/priv" root@januschka.com:/opt/bartlby-second/
rsync -av /var/www/htdocs/bartlby.januschka.com/bartlby-ui/rights/ -e "ssh -i /storage/SF.NET/BARTLBY/priv" root@januschka.com:/var/www/htdocs/bartlby.januschka.com/bartlby-ui/rights-1/
rsync -av /opt/pnp4nagios/var/perfdata/ -e "ssh -i /storage/SF.NET/BARTLBY/priv" root@januschka.com:/opt/pnp4nagios/var/perfdata/
rsync -av /var/www/htdocs/bartlby.januschka.com/bartlby-ui/rrd/ -e "ssh -i /storage/SF.NET/BARTLBY/priv" root@januschka.com:/var/www/htdocs/bartlby.januschka.com/bartlby-ui/rrd/

~
~

