<?php

	$row['id'] = 73; // ova vrednost se uobicajeno naziva salt. Ona sluzi da se slabi korisnicki passwordi dopune u jace
	
	echo md5(md5($row['id'])."password"); // md5 radi hashiranje passworda. Naime u ovom redu se uzima neki staticni parametar 
	//baze podataka tipa id reda da bude salt pa se on hashira, zatim konkatenira na string, i potom se ceo taj novi string
	// hashira sa md5 algoritmom. Ovo bi kao trebao da bude razumno ozbiljan algoritam da cak i uzasne korisnicke passworde lepo
	// zamaskira kako hakerski napad ne bi mogao toliko lako da ih otkrije
		
		
	/* novija funkcija od ovoga se naziva password_hash koja izgleda sama barata sa saltovima svojim i slicnim sranjima

					// Generate a hash of the password "mypassword"
					$hash = password_hash("mypassword", PASSWORD_DEFAULT);
					 
					// Echoing it out, so we can see it:
					echo $hash;
					 
					// Some line breaks for a cleaner output:
					echo "<br><br>";
					 
					// Using password_verify() to check if "mypassword" matches the hash.
					// Try changing "mypassword" below to something else and then refresh the page.
					if (password_verify('mypassword', $hash)) {
						echo 'Password is valid!';
					} else {
						echo 'Invalid password.';
				} 
		*/

?>
	  
	
