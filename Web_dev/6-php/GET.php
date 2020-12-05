<?php


// GET varijable mogu biti deo url adrese, i iz nje se uzimaju i pakuju u phpov niz $_GET iz kojeg
// ih on dalje tumaci i upotrebljava u svojim skriptama. Naime u neku URL adresu se dodaju na sledci nacin
//  https://jasamugasudapumpammasu.000webhostapp.com/?name=Luka&password=1234&gender=male Naime, u ovom izrazu je sve
// posle znaka pitanja su GET varijable koje nadovezujemo znakom & i tako se i pakuju u niz $_GET.

// GET promenljive se URL adresama najcesce prosledjuju putem formi, tj unosa iz formi
if ($_GET) {   // radi if samo ako ima nesto u $_GET varijabli
	echo "Hi there ".$_GET["name"]."!<br>";
	$num = $_GET["number"];
	if (is_numeric($num) && $num > 0 && $num == round($num)) {
		$i = 2;
		$end = round(sqrt((int)$num)) + 1;
		while (($num % $i != 0) && $i < $end) $i++;
		if ($i == $end) echo "It is prime indeed!";
		else echo "It's not a prime number dude!";
	} else echo "Please enter a natural number dude!";
}
?>

<p>What's your name?</p>
<form>
	<input name="name" type="text">
	<input type="submit" value="Go!">
	<br> <br>
	<label for="broj">Input a number, we will check if it is prime</label>
	<input id="broj" name="number" type="text">
	<input type="submit" value="Check if prime">
	
</form>
<!-- submitovanje vrednosti ove forme pakuje url sa vrednosti ?name=<ukucan tekst>

