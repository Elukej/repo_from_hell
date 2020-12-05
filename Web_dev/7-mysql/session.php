<?php


	session_start(); // ova linija je neophodna da bi se sesija zapocela i dabi varijable sesije mogle da se pamte
	
	$_SESSION["username"] = "lukajovanovic"; // ovo cudo kad jednom prodje ostaje zapamceno do sledeceg gasenja browsera
	// na ovaj nacin se omogucava ljudima da ostane zapamcen login na nekom sajtu cak i kad izadju sa njega.
	// zanimljiva stvar ove dodele je sto ako jednom pokrenemo skriptu sa njom, pa je pokrenemo ponovo bez te dodele, ona
	// svejedno ostaje zapamcena tako da smo konstantno ulogovani do gasenja browsera jel

	if (!empty($_SESSION["email"])) echo "You are logged in mr ".$_SESSION["username"]." with an email ".$_SESSION["email"]."!";
	else header("Location: looping.php");
?>
	  
	
