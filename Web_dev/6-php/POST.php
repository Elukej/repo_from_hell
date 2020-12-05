<?php

// Post varijable mu dodju kao bezbednija verzija GET varijable posto se njihove vrednosti ne utiskuju u url adresu direktno
// vec se negde drugo cuvaju a da url to ne prikazuje
// takodje ako promenljive u GET-u sadrze znak & moze da dodje do problema, a u Postu to nije slucja
// Post se pakuje kao get u poseban array po imenu $_POST

// VRLO VAZAN DETALJ JE DA FORMA MORA DA ATRIBUT method="post" DA BI RADILA SA POST PROMENLJIVAMA
print_r($_POST);
echo "<br><br>";

$users = array("Luka","Nada","Igor","Gangula","Hristo");

if ($_POST) {
		$i = 0;
		while ( $i < sizeof($users)) {
			if ($users[$i] == $_POST["name"]){
				echo "Hello ".$users[$i]."!";
				break;
			}
			$i++;
		}
		if ($i ==sizeof($users)) echo "I don't know you ".$_POST["name"]." dude!";
}

?>

<p>What's your name?</p>
<form method="post">   
	<input name="name" type="text">
	<input type="submit" value="Go!">
</form>


