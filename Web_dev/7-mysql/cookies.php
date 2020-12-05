<?php

	/*setcookie("customerId","1234", time() + 60*60*24 ); // parametri- id kolacica, vrednost i vreme koliko ce da traje (u sekundama)
	// 60*60*24 je cookie koji traje 1 dan;
	echo $_COOKIE["customerId"];*/
	
	/* BRISANJE COOKIE-A */
	
	setcookie("customerId", "", time() - 60*60); //brise se setovanjem negativnog vremena i prazne vrednosti. trebaju dva reloada stranice da stvarno nestane;
	echo $_COOKIE["customerId"];
?>
	  
	
