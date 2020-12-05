<?php

echo nl2br("Hello World \n"); //php.ini fajl koji smo dodali u folderu sluzi za omogucavanje debagovanja, tj dobijanje 
//informacija o greskama koje pravimo direktno na serveru, tj kad pokusamo da prikazemo web stranicu

$name = "Luka"; //kao u bashu $ je znak za dodeljivanje promenljive

echo $name;  // i isto ko u bashu radi i kombinacija npr echo "the name is $name" ce prikazati promenljivu
echo nl2br("\n"); // nl2br radi ispis specijalnih karaktera u browseru tipa \n za novi red, valja pogledati o cemu se tacno radi

$string1 = "This is the first part";
$string2 = "of a sentence";

echo $string1." ".$string2; //ovako php radi konkatenaciju stringova(sa tackom), naspram + u pythonu i javascriptu

$myNumber = 45;

$calculation = $myNumber *31 /97 + 4;

echo "</br>The result of the calculation is ".$calculation."</br>";

$myBool = true;

echo "<p>This statement is true? ".$myBool."</p>";

$variableName = "name";
echo $$variableName; // fina forica. variableName sadrzi u sebi ime koje drugi $ uhvati kao novu promenljivu, pa ce ovo ispisati sadrzaj
//od $name na izlazu, tj Luka u ovom slucaju
echo "</br>";

		/* MALO O NIZOVIMA */ 

$myArray = array("Luka","Nada","Igor");
// za ispisivanje array echo ne radi lep ispis, iako nije nuzno greska, te se stoga koristi print_r komanda

$myArray[] = "Drakula"; // dodavanje u niz
print_r($myArray);
echo "</br>".$myArray[1]."</br>";  // ovako se pristupa elementima niza

$anotherArray[0] = "pizza";

$anotherArray[1] = "yoghurt";

$anotherArray[5] = "coffee";

$anotherArray["myFavouriteFood"] = "ice cream";

$anotherArray["luckyNumber"] = 27;
// Moze se primetiti da je array u php-u u stvari vise mapa nego array, tj asocijativni kontejner jako slican
// dictionary-ju u pythonu, gde redom redja potpuno random tipove kljuceva i vrednosti.
print_r($anotherArray);
echo "</br>";
$thirdArray = array("France" => "French", 
					"USA" => "English", 
					"Germany" => "German",
					"Spain" => "Spanish");
//alternativa pravljenju asocijativnog kontejnera

unset($thirdArray["France"]); //brisanje elementa iz niza
unset($thirdArray[2]); // ovo ne radi apsolutno nista za ovaj niz, posto on ne ide po indeksima vec po kljucevima!!!
print_r($thirdArray);
echo "</br>".sizeof($thirdArray)."<br><br>";  // duzina niza


		/*IF KONDICIONAL */

$user = "Nada";
// isto sve ko u javascriptu izgleda sa operatorima, uglastim zagradama, itd.
if ($user == "Luka") {
	
		echo "Hello Luka!";
 }	else {
	 
	 echo "I dont know you $user!</br>";
 }

$age = 17;
if ($age >= 18) echo "Procced to our content!<br>";
else echo "Dude, U are too young to watch porn!<br>";


		/* FOR PETLJA */

for($i = 1; $i <= 30; $i++) {
		if ($i % 2 == 0) echo $i."<br>"; //parni brojevi
}
$family = array("Igor","Nada","Luka");

for ($i = 0; $i < sizeof($family); $i++) {
		echo $family[$i]."<br>";
}

// alternativna for petlja je foreach. Uvodi se kljucna rec as u pozivu petlje(Ovo je izgleda pattern matching u pitanju)

foreach ($family as $key => $value) {
	$family[$key] = $value." Jovanovic"; 
	echo "Array item ".$key." is ".$value."<br>"; //zanimljiva stvar je da php u ovakvom ispisu uzima value sa kojim je usao u petlju, a ne novodobijeni!!!
	echo "My real name is ".$family[$key]."<br>";
}

		/* WHILE PETLJA */
		
$i = 5;

while ($i < 50) {
	echo $i."<br>";
	$i+=5;
}
$pecivo = array("sendvic","kifla","hleb");
$i = 0;

while ($i < sizeof($pecivo)) {
	echo $pecivo[$i]."<br>";
	$i++;
}

?>