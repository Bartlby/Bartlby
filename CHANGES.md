	+ UI:
		service list uses ajax to load elements, regex search to filter and much faster loading
	+ php/ui
		support bulk force/check_enable/check_disable/notify_enable/notify_disable
	+ php
		* reworked the FE functions to accept an array as object configuration instead of using 27+ function parameters
		  this will help to be  backward compatible and will speed up further development
	+ core - mysql-lib
		* simpler selects for services - enables faster development 
			orphaned services are detected and can be auto deleted if config "autodelete_orphaned_services=true" is set
	+ ui
		adapted to the PHP FE functions
###########################
# RELEASE 1.5.0 24.06.2013
###########################
	# SUPPORT FOR DEBIAN 7
	# packages for debian 6 wont be updated anymore
	core: 
	+ retain count long overflow protection
	+ bartlby_if network perfhandler fix
	+ output service_text on shm tool
	+ php:
		php 5.4 support!! ported the extension
	+ ui:
		support for php 5.4
	+ db field clean up
	+ 27.02.2013 - UI added Dashboards extensions
	+ 25.02.2013 - LONG overflow protection, and atoi changes to atol, RRD bartlby_if shows total throughput
###########################
# RELEASE 1.4.9 22.02.2013
###########################

###########################
# RELEASE 1.4.7 21.02.2013
###########################
	+ 20.02.2013 - retain counter survies db reload
	+ 20.02.2013 - removed unneeded shm field
###########################
# RELEASE 1.4.6 19.02.2013
###########################
	+ 19.02.2013 - added a new field (last_state_changed) - displays the time(unixtimestamp) of the last state change - ui/php/core
###########################
# RELEASE 1.4.5 16.02.2013
###########################
	+ agent - added debian/ folder to generate debian package use git-buildpackage from within the agend source dir
		you all get a .deb file in ../
	+ added a little SH script to in-place upgrade the susestudio appliance
	+ core - generic perf handler added
	+ core/php - SHM reorganised 
		you need to recompile extensions, php and core!!!!
		saves up to 90% of the SHM Size :)
	+ portier - ipv6 support
	+ agent - cmd tool for portier supports ipv6
	+ agentv2 - support ipv6
	+ active - agent - supports ipv6
	+ core/ui - support for managing multi instances
			running on the same machine
			running on remote machines - in read only and read write mode
			see config.php (UI) and https://github.com/Bartlby/Bartlby/tree/master/multi_instances_HA
			a little script to push config to remote and pull status from it
	+ core - more flexible snmp integration
		support for all types using strcmp strstr
	+ ui - group selector has been rewriten much more useable on large networks now
	+ ui 
		new reporting design
		step and donut graph
		fits to new ui layout
	+ core/servergroups
		if a servergroup exists and is named "DEFAULT"
		all servers are added to this group wich are group-less
		DEFAULT group is hidden if there is not any server wich is group-less
	+ core/ui/php 
		groups, server and service object now support to select triggers wich should fired if no value all will be fired
	+ core/ui/php - added check-type:SSH
		run checks via SSH connection
		specify privatekey,passphrase, username - on server object
		only RSA keys support
		plugin will be executed at e.g.: ~/bartlby_plugins/bartlby_load -c 10 -p
	+ core/php/ui: added eventhandlers - if check goes critical - an event handler is called on the remote machine from the plugins dir
	  event_<PLUGIN_NAME>.sh plugin-params state retain_count
	  only if enabled in ui (fires events)
	  e.g.: if webserver goes critical restart apache - if restart fails check stays critical
	+ ui: group alife marker functions
	+ php: group alife marker functions
	+ core: alife marker is set to dead if service is disabled
	+ core: groups support alife marker
	+ core: automake now works for doing make dist
	+ core: replaced most of the calls to sprintf to asprintf 
	+ core: fixed a buffer overflow on call of perf handler
	+ core: added CI (travis-ci)
	+ core: fixed ubuntu c99 compile warnings
	+ core: local checks discard STDERR now
	+ core: trigger_msg variables have to end with $ e.g.: $SERVER$
	+ agent: supports , and % for more common plugin support (e.g.: check_swap, check_load, check_disk)
	+ core: supports nagios plugin performance data
	+ ui/extensions: autodiscoveraddons now supports pnp4nagios graphs
	+ extensions: added an extension wich can emulate nagios performance data and log it to a file - for use with pnp4nagios
	+ core: reworked the scheduler should save a lot a cpu now
	+ php: added downtime support for groups
	+ added server/service groups 
	+ JSON output of services list
		+ used in chrome-extension	
	+ core: added trigger push.sh - to send push notifications to iphone and android 
		+ via "notifications for android", and "prowl"
		+ requires ui-extension "Pusher"
	+ ui:new UI design
	+ chrome: added an extension for google chrome
	+ removed: bartlby-w32 - use the chrome extension instead
	+ agentV2 cfg_log_execs config-var added - logs commands to syslog
	+ agentv2 fixed problem with STATE_INFO
	+ fixed security hole, reported by theall<AT>tenablesecurity.com
	+ UI: runs on 5.3 php now (default setup testet)
		+ you have to set following variables in your php.ini as of DL() not supported anymore
			extension_dir = "/usr/local/lib/php/extensions/no-debug-non-zts-20090626/"
			extension=bartlby.so
	+ core: fixed some debian 5 compile errors (errno.h)
	+ ui: switched from "<?" to "<?php" tags as short tag is disabled by default in php 5.3
	+ bartlby_set_worker_state -> set the activity state of a worker, w/o reload but permanent
	+ ui, set worker activity level without reload on a single overview (standby,active,inactive)
	+ core: FIXED a privilege problem where unprivileged users got notify's wich where not belong to them
	+ warnings can set to hidden in CLI shell
	+ infos can be excluded in CLI
	+ CLI can now reset view to default
	+ you can add a service on multiple servers at once
	+ bulk actions added, right now only "force checks"
	- alert box on force check has been removed
	+ plugin: bartlby_swap no checks if there is even 1 swap partition/file
	+ agent now also compiles and runs on MacOSx >= Leopard
	+ more migration done for the new theme engine
	+ added ability to enable/disable the default box arround a "box"
	+ regexp placement in lineup files
	+ cli: groups services if there are more than X on a server
	+ ui: state is overwriteable via web interface (as it was on passive services) now for all services
	+ ui: exlude "STATE_INFO" services from healthbar
