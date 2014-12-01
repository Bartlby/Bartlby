a.k.a ROADMAP


#done for 1.6 
- [x] mobile html5 gui first shot
- [x] ui: compact json - for mobile UI (json=2 and you get the rendered values)
- [x] modify downtime - fix bug loosing dt_type
- [x] ui: add worker fix selected/visible server/services - not stored at all
- [x] core: change bartlby_worker_has_service to not require local-ui permission file ?
		YOU need to rework your permissions!!! 
- [x] core: upstream notifications to a portier instance
	CONFIG:
		portier_password=myPAsss
		upstream_enabled=true
		upstream_has_local_users=false
		upstream_my_node_id=1
		upstream_host=127.0.0.1
		upstream_port=9031
	[x] portier - make password
	[x] core: make portierhost and portierport a cfg variable
		[x] portier - get following svc fields
			[x] svc->service_id
			[x] svc->server_id
			[x] svc->notify_last_state
			[x] svc->current_state
			[x] svc->recovery_outstanding
			[x]NODE_ID
	[x] portier make node_id a param (optional):
		[x] bartlby_worker_has_service
		[x] bartlby_trigger_escalation
		[x] bartlby_trigger_worker_level
- [x] server detail fix ajax trigger icon bug
- [x] bulk edit - make delete button
- [x] postinst-pak.in support for $ENV vars - so upgrade can be automated
- [x] server object add "default service check type field"
		service_add - make checkbox "add service as a server default check type"
				for bulk add of services with servers wich have diffrent service_types
- [x] service bulk edit
	see gist: https://gist.github.com/hjanuschka/6a9d06c0f2b233dba22b
- [x] fix FailedServices (to use new svc_list_loop)
- [x] agentSyncer has been replaced by "Deploy"
	* sync config
	* dl/sync plugins
	* add bartlby user
	* add inted service 
	* install agent
- [x] ui fixed datatables service list
- [x] UI: added Whats On - Notification and State-Change statistic/summary
- [x] OcL Re-Done
- [x] remove AgentSyncer Extension
- [x] AutoReports Re-Done
- [x] OcL add schedule management automated active/standby
- [x] reworked progressbars displaying oks/warnings/infos/criticals
- [x] user detail page
- [x]  SiteManager
	manage multiple remote bartlby instance in one UI (push or pull)
- [x]  bartlbystorage has support for SQLLite DBS (if php5-sqlite is installed)
		* $s = new BartlbyStorage("plugin");
			$db = $s->SQLDB("CREATE TABLE....");
			$db->query("select...")
- [x]  handled/unhandled - services state (WARN/CRIT)
		* exclude from cli
		* exclude from overview / healthbar
- [x] support for TABS in layout class $layout->Tab("Tab Name", "Tab Content")
		* will work in extensions too
- [x] fixed memory bugs in check_active and check_ssh
- [x] make a Dockerfile for bartlby-core (to quickly up and run a core instance)
	* index.docker.io/bartlby
	* upgrade to latest dev/stage -> /opt/bartlby/deploy.sh system_upgrade
- [x] UI: dropdown to select service type and override the one included in an pkg
- [x] Multiline Plugin output support
	* agentv2   x
	* agentv1   x
	* local     x
	* ssh       x 
- [x] implement sched_mode (1 == traditional fork on every check!  - 2 == prefork N workers, and dispatch service checks (SCHED_MODE_WORKER))
- [x] UI fix a few performance issues - by loading data async - so atleast the gui stays responsive
	* remove all _map functions and replace by a iter function like service_list_loop(function($svc) {
			echo "i am service:" . $svc[service_name]";
		});
	* will re