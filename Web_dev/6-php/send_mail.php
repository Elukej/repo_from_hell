<?php

$emailTo = "texhnolainx@gmail.com";

$subject = "Ponuda za posao!";

$body = "Pozdrav Mare!\n\nPozivamo vas da budete PHP inzenjer za nas novi sajt u usponu https://en.paradisehill.cc/ .\nMlad i perspektivan developer kao vi je sve sto nam treba da probijemo barijeru!\n\nPozdrav od paradisehill-a!";

$headers = "From: phpmagija@jasamugasudapumpammasu.000webhostapp.com";

if (mail($emailTo, $subject, $body, $headers)) echo "The email was sent succesfully";
else echo "The email could not be sent"

?>


