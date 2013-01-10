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
