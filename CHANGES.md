#########################
# Release 1.6.0
#########################
	+ UI:
		* redesign
		* drop old basic_auth stuff
		* passwords are sha1 now
	+ core:
		* config overrid with env vars
		* upgrade script for old dat files (ui)
		* LSB-compliant RC script
		* re-worked build process (faster cleaner etc..)
		* portier rewritten (now talks json)
		* added a bunch of service/server options
		* exec_plan on server objects
		* svc prio
		* REST API (see api/sdk/..)
		* report filter on HARD/soft state
		* JSON check type
		* TRAP check type
		* webhooks
		* TRAPS
		* mysql sql injection prevention
	+ php:
		* object audit
		* bartlby_get_object_by_id($RES, TYPE, ID); - get shm object BY id - to avoid usind findSHMPlace stuff.		
	+ all:
		* travis-ci integration
		* coverityscan integration
		* docker support
		* php7 (branch in bartlby-php) support
		* unit tests (bartlby-core, bartlby-php)
	+ ui:
		* state history		
	+ core/portier
		* support for notification upstreaming (when running in replicated/remote mode)
	+ core/php/ui
		added support for remote managed/replicated instances
		extension: "SiteManager"
	+ core/notifications
		* added support for aggregation of notification + notification log in UI
	+ core/agent
		multiline plugin output support for active, agentv2, ssh, local check types (only passives are not supported right now);
	+ core
		implement another sched_mode (SCHED_MODE_WORKER) - wich eleminates the need of a fork() on every svc-check, N workers will be preforked - and execute the checks by loadbalancing
	+ php/ui
		fixed limitations on large setups - UI/php should now support up to 100k+ services/servers/groups etc
	+ php
		reworked the module to use a shared resource instead of every function having to open shm/lib
	+ ui
		rollup for resource change in php module
	+ ui
		"all failures" now excludes INFO state services (messed up the view - and INFO is not a failure)
		quick look now uses datatables for prettier output
		nice extensions overview
		nice statistic
		nice event queue
	+ php
		added bartlby_get_core_extension_info() FE function to retrieve core extension info
	+ core/php
		set GROUP_MEMBER_STR_LENGTH and MAX_GROUP_MEMBERS constant for defining group size
	+ UI
		removed the alive indicator old search -  replaced with ajax chosen
		perf data graphs are now displayed in tabs
		groupstr searcher uses ajax chosen
		global support for getParam "json=1" the whole $layout will be printed as json serialized string
		added auto_refshable_objects 
			can be registered by every extension and if the page (e.g.: overview) enables auto refresh it will be called sample:_
				js (for example in your extension):
				btl_add_refreshable_object(function(data) {
						json_value = btl_get_refreshable_value(data, "my_stored_key");
						alert(json_value);
				});
				
				php code (for example in your extension):
				$layout->setRefreshableVariable("my_stored_key", "value");

			  and your JS function will be called every 5 secs. if the Auto-Refresh checkbox is enabled and the browser/tab has focus
				
	+ UI
		service_detail: added gauglets (load,swap sample added)
	+ UI
		replaced long optionlists with ajax one (ajax-chosen)
	+ overall
		added little helper script "rorder_intervall.php" to span checks - so if you have 100 checks wich all have 60 sec. intervall
		this script will span them so that e.g. 5 are at 61, 5 at 62 etc...
	+ php
		new FE function bartlby_service_set_interval($CFG, $SHM_PLACE, $INTERVALL_IN_SECONDS, $WRITE_TO_DB);
		for setting new intervall
	+ core:
		autodelete_orphaned_services is by default now "true" if you expierience orphaned services hit reload 2 times :)
	+ php
		support "checks_performed", "check_performend_time"
	+ ui
		show performed checks and checks/s
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
