<?

define(MIN_ELS_REQUIRED, 8);
define(MAX_SPAN_TIME, 10);


if(!$argv[1]) {
        define(DO_DB, 0);
} else {
        define(DO_DB, 1);
}
echo "DOING DB: " . DO_DB . "\n";

$CFG="/opt/bartlby/etc/bartlby.cfg";
$map = bartlby_svc_map($CFG,"", "");

///GROUP BY
for($x=0; $x<count($map); $x++) {
        $secs[$map[$x]["check_interval"]][counter] += 1;
        $secs[$map[$x]["check_interval"]][svc][] = $map[$x];
}

while(list($k, $v) = each($secs)) {
        if(count($v[svc]) < MIN_ELS_REQUIRED) continue;
        echo "seconds " . $k . " number of elements: " .  count($v[svc]) . "\n";

        for($x=0; $x<count($v[svc]); $x++) {

                        $new_interval = $v[svc][$x][check_interval] + rand(1, MAX_SPAN_TIME);
                        echo "Spanning " . $v[svc][$x][server_name] . "/" . $v[svc][$x][service_name] . " from " . $v[svc][$x][check_interval] . " to " . $new_interval . "\n";

        //              if(DO_DB == 1) {
                                bartlby_service_set_interval($CFG, $v[svc][$x][shm_place], $new_interval, DO_DB);
        //              }

        }


}

?>
