<?php
$success = "";
if ($_GET){
	$regex = '/^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/';
	if (preg_match($regex,$_GET["email"]) && $_GET["subject"] != "" && $_GET["questions"] != ""){
		
		$emailTo = "elukej@gmail.com";

		$subject = $_GET["subject"];

		$body = $_GET["questions"];

		$headers = "From: ".$_GET["email"];
		
		if (mail($emailTo, $subject, $body, $headers)) $success .= "<div class='alert alert-success p-4 h6'>Your message was sent, we will get back to you ASAP!</div>";
		else $success .= "<div class='alert alert-danger p-4 h6'>Your mail wasn't sent! Please try again!</div>";
	} 
}


?>


<html>
	<head> 
	
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
		
	</head>
	
	
	
	<body class="container">
		
		<h1 class="display-3 mb-sm-4  font-weight-normal">Get in touch!</h1>
		<div id="alert">
			<?php echo "$success"; ?>
		</div>
			
		
		<form  id="myForm" method="get">

			<fieldset class="form-group">
				<label for="email" class="font-weight-bold">Email adress</label>
				<input id="email" name="email" type="text" class="form-control" placeholder="Enter email">
			</fieldset>
			<p class="text-muted" style="position:relative;top:-10px;">We'll never share your email with anyone else!</p>
			<fieldset class="form-group">
				<label for="subject" class="font-weight-bold">Subject</label>
				<input id="subject" name="subject" type="text" class="form-control">
			</fieldset>
			<fieldset class="form-group">
				<label for="questions" class="font-weight-bold">What would you like to ask us?</label>
				<textarea id="questions" name="questions" class="form-control" style="height:100px"></textarea>
			</fieldset>
		</form>
		<button id="submit" type="submit" class="btn btn-primary">Submit</button>
		
		<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
		<script type="text/javascript">
			function isEmail(email) {
				var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
			return regex.test(email);
			}
			function submitForm() {
				//document.getElementById("myForm").reset();
				document.getElementById("myForm").submit();
			}
			$("#submit").on('click',function () {

					var errorReport = "";
					var fields_missing = "";
					
					if ($("#email").val() == "") fields_missing += "Email is missing<br>";				
					else if (!isEmail($("#email").val())) errorReport += "Email you inputted is not valid<br>";

					if ($("#subject").val() == "") fields_missing += "Subject is missing<br>";							
					if ($("#questions").val() == "") fields_missing += "The questions are missing<br>";
					
					if (errorReport || fields_missing) {
							errorReport = "<strong>You have errors in your form:</strong><br>" + errorReport + fields_missing;
							$("#alert").addClass("alert alert-danger p-4 h6");
							$("#alert").html(errorReport);
					}
					else submitForm();
	
			});
		
		</script>
	</body>
</html>