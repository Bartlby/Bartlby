<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <title>Bartlby by Bartlby</title>

    <link rel="stylesheet" href="stylesheets/styles.css">
    <link rel="stylesheet" href="stylesheets/pygment_trac.css">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <!--[if lt IE 9]>
    <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-521724-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>

  </head>
  <body>
    <div class="wrapper">
      <header>
        <h1>Bartlby</h1>
        <p></p>

        <p class="view"><a href="https://github.com/Bartlby/Bartlby">View the Project on GitHub <small>Bartlby/Bartlby</small></a></p>


        <ul>
          <li><a href="https://github.com/Bartlby/Bartlby">View On <strong>GitHub</strong></a></li>
          <li><a href="http://susestudio.com/a/wErfnN/bartlby-in-a-box">Demo <strong>SuseStudio</strong></a></li>
          <li><a href="https://github.com/Bartlby/Bartlby/wiki">Docs <strong>Wiki</strong></a></li>
        </ul>

    
	<ul style='background:none; border:none; width: 350px; height:200px;'>
		<li style='border:none;width:250px; height: 180px;'><a href='screen1.jpg'><img src='thumbs/screen1.jpg'></A></li>
		<li style='border:none;width:250px; height: 180px;'><a href='screen2.jpg'><img src='thumbs/screen2.jpg'></A></li>
	</ul>
      </header>
      <section>
        <p>Bartlby is a network and system monitor, completely written in C, to provide a scalable framework with the ability to monitor networks of various sizes. It consists of a core daemon, several plugins, and a Web GUI (PHP extension). The core daemon checks (over active/passive TCP) services/hosts and notifies users in case of critical service conditions (mail, SMS, ICQ, and custom triggers are supported). Bartlby provides an open plugin interface to give every administrator an easy to use option to extend the plugin base, and a fully customizable GUI (written in PHP using a C extension). Nearby everything can be controlled via an XML interface.</p>

<h1>Support</h1>

<p>E-Mail: <a href="mailto:helmut@januschka.com">helmut@januschka.com</a><br>
Wiki: <a href="http://wiki.bartlby.org/dokuwiki/">https://github.com/Bartlby/Bartlby/wiki</a></p>
      </section>
<section>
<h1>Debian Packages</h1>
Sources.list entry:<br>
<code>deb http://bartlby.org/Bartlby/debs binary/</code>
<ul>
<?php
$d = opendir("debs/binary");
while($f = readdir($d)) {
	if($f == "." || $f == ".." || $f == "Packages.gz") continue;
	echo "<li><a href='debs/binary/$f'>$f </a><br></li>";
}
?>
</ul>
</section>
<section>
<h1>ChangeLog</h1>

<?php
$cnt = file_get_contents("/storage/SF.NET/BARTLBY/GIT/Bartlby/CHANGES.md");
echo nl2br($cnt);
?>

</section>
      <footer>
        <p>This project is maintained by <a href="https://github.com/Bartlby">Bartlby</a></p>
        <p><small>Hosted on GitHub Pages &mdash; Theme by <a href="https://github.com/orderedlist">orderedlist</a></small></p>
      </footer>
    </div>


    <script src="javascripts/scale.fix.js"></script>
    
  </body>
</html>
