<?php
	session_start();
	$error = "";
	$link = mysqli_connect("localhost","id15431726_user_base","zH=LLUyw%3}5[lIs", "id15431726_users");
	if (mysqli_connect_error($link)) die ("Database connection failed");
	
	if (!empty($_SESSION["username"])) header("Location: final_login.php");
	
	if (!empty($_POST)){
			$regex = '/^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/';
			if (preg_match($regex,$_POST["email"]) && $_POST["password"] != ""){
				
				if ($_POST["logsig"] == "signup") {
					
					$query = "SELECT username FROM `user_info` WHERE username = '".mysqli_real_escape_string($link, $_POST["email"])."'";
					$result = mysqli_query($link, $query);
					
					if (mysqli_fetch_array($result)) $error = "<div class='alert alert-danger p-4 h6'>You already have a profile. Please go to login section and input data there!</div>";
					else {
						$query = "INSERT INTO `user_info` (`username`, `password`, `diary`) VALUES('".$_POST["email"]."', '".$_POST["password"]."', '')";
						if (mysqli_query($link, $query)) {
							$lastID = mysqli_insert_id($link);
							$query = "UPDATE `user_info` SET password = '".md5(md5($lastID).$_POST["password"])."' WHERE id = ".$lastID." LIMIT 1";
							if (mysqli_query($link, $query)) {
								if (!empty($_POST["staylogged"])) $_SESSION["username"] = $_POST["email"];						
								header("Location: final_login.php?firstLogin=".$_POST['email']);
							}
							else $error = "<div class='alert alert-danger p-4 h6'>Error with database update. Please try again!</div>";
						}
						else $error = "<div class='alert alert-danger p-4 h6'>Error with database insertion. Please try again!</div>";
					}
				}
				
				if ($_POST["logsig"] == "login") {
					$query = "SELECT id, username, password FROM `user_info` WHERE username = '".mysqli_real_escape_string($link, $_POST["email"])."'";
					$result =  mysqli_query($link, $query);
					$user = mysqli_fetch_array($result);
					if (empty($user)) $error = "<div class='alert alert-danger p-4 h6'>You are not our member, please sign up first!</div>";
					else if ($user["password"] != md5(md5($user["id"]).$_POST["password"])) $error = "<div class='alert alert-danger p-4 h6'>Check ur password dude! Something's wrong!</div>";
					else {
						if (!empty($_POST["staylogged"])) $_SESSION["username"] = $_POST["email"];				
						header("Location: final_login.php?firstLogin=".$_POST['email']);	
					}
				}
				//echo "Dont have BUTTON PRESS!";
			}
			else $error = "<div class='alert alert-danger p-4 h6'>Something is wrong with your email or password. Please try again!</div>";
	}
?>
	  
	
<html>
	<head>
		<title>Secret diary</title>
	
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
		<style type="text/css">
			* {
					margin: 0;
					padding: 0;
					box-sizing:border-box;
					
			}
			body {
				background-image:url(https://images.unsplash.com/photo-1476081718509-d5d0b661a376?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1533&q=80);
				height:100%;
				width:100%;
			}
			#container {
				display:flex;
				flex-direction:column;
				justify-content:center;
				align-items:center;
				height:100%;
			}
			#myForm {
				display:flex;
				flex-direction:column;
				justify-content:center;
				align-items:center;
				max-width:800px;
				width:75%;	
			}
			#email, #password {
				max-width:400px;
				width:100%;
				
			}
			#fieldCheck {
				margin-left:20px ;
				position:relative;
				width:180px;
			}
			#checkbox {
					position:relative;
					top:2px;
					height:15px;
					width:15px;
					z-index:100;
				
			}
			.login, .signup {
					width: 100px;
					margin:0 auto;
				
			}
			.greeny {
					color:#00ff00;
			}
		</style>
	</head>
	<body>
		<div id="container" class="container">
			<h1 class="text-center greeny display-4 mb-4 font-weight-bold"> Secret diary</h1>
			<p class="text-center text-white mb-4 lead">store your thoughts permanently and securely.</p>
			
			<p class="text-center text-white"><span>Login using your username and password</span><span class="d-none">Interested? Sign up now</span> </p>
			
			<div id="alert">
				<?php echo $error; ?>
			
			</div>
			
			<form id="myForm"  method="post">
				<fieldset class="w-75" style="max-width:400px;">
					<input id="email" name="email" type="text" placeholder="Email" class="form-control mb-2" value="<?php if ($error) echo $_POST["email"]; else echo ""; ?>">
				</fieldset>
				<fieldset class="mt-3 m-auto w-75" style="max-width:400px;">
					<input id="password" name="password" type="password" placeholder="Password" class="form-control mb-2" value="<?php if ($error) echo $_POST["password"]; else echo ""; ?>">
				</fieldset>
				<fieldset id="fieldCheck" class="mt-2 mb-2 ">
					<label for="checkbox" class="text-white mr-3 pl-3">Stay logged in?</label>
					<input id="checkbox" class="mt-2" type="checkbox" name="staylogged">
				</fieldset>
				<input type="text" id="logsig" name="logsig" class="d-none" value="login">
			</form>				
			
			<button id="signup" type="submit" class="d-none btn btn-primary signup">Sign up</button>
			<button id="login" type="submit" class="btn btn-primary login" >Log in </button>
		
			<a href="#" class="text-center mt-2"><span class="d-none">Log in</span><span>Sign up</span></a>
		</div>		
			
		<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
	
		<script type="text/javascript">
		
			function isEmail(email) {
				var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
			return regex.test(email);
			}
			$("button").on('click',function () {

					var errorReport = "";
					var fields_missing = "";
					
					if ($("#email").val() == "") fields_missing += "Email is missing<br>";				
					else if (!isEmail($("#email").val())) errorReport += "Email you inputted is not valid<br>";
					if ($("#password").val() == "") fields_missing += "Pssword is missing<br>"; 
					
					if (errorReport || fields_missing) {
							errorReport = "<strong>You have errors in your form:</strong><br>" + errorReport + fields_missing;
							$("#alert").addClass("alert alert-danger p-4 h6");
							$("#alert").html(errorReport);
					}
					else {
						if ($(this).attr("id") == "login") $("#logsig").val("login");
						else $("#logsig").val("signup");
						document.getElementById("myForm").submit();
					}
		});
			$("a").click(function() {
				$("span").toggleClass("d-none");
				$("button").toggleClass("d-none");
			});
		
		</script>
	</body>


</html>

