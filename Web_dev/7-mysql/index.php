<?php


	$link = mysqli_connect("localhost","id15431726_user_base","zH=LLUyw%3}5[lIs", "id15431726_users");  // parametri su ip adresa(localhost je kad je na istom serveru), zatim database user pa password databaze, pa database name
	// database user i database name su najcesce isti, ali ovde nisu za moju bazu
	if (mysqli_connect_error()) die ("Failed to connect to database!"); // ovo je valjda process kill komanda (die);
	
	//$query = "INSERT INTO `user_info` (`username`, `password`) VALUES('DZERONIMO@indian.com','654321000')";  //sintaksa sa ```` je neobavezna ali po pravilu ide tako za tabelu i polja tabele
	$query = "UPDATE `user_info` SET password = 'Sokolcina' WHERE id = 1 LIMIT 1"; // promena vrednosti polja password sa limitom promene na jedno polje
	
	if (mysqli_query($link, $query)) echo "success!<br>";
	else echo "FAIL!<br>";
	
	$query = "SELECT * FROM user_info";
	

	if ($result = mysqli_query($link, $query)) {  // mysqli_query sprovodi sql query na bazi podataka
		
		$row = mysqli_fetch_array($result);  // fetch zapravo vraca rezultat querija kao podatke
		print_r($row);
	}   
	
?>