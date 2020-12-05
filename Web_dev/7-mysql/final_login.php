<?php
	session_start();
	$error = "";
	$link = mysqli_connect("localhost","id15431726_user_base","zH=LLUyw%3}5[lIs", "id15431726_users");
	if (mysqli_connect_error($link)) die ("Database connection failed");
	
	if (!isset($_SESSION["confirm"])) header("Location: final_first.php");
	
	if (empty($_SESSION["username"]) && empty($_GET["firstLogin"]) && empty($_POST["userPost"]) || isset($_GET["logout"])) {
		if (isset($_GET["logout"])) {
			if (!empty($_SESSION["username"])) unset($_SESSION["username"]);
			unset($_SESSION["confirm"]);
		}
		unset($_GET);
		unset($_POST);
		session_destroy();
		header("Location: final_first.php"); // VRLO BITNA NAPOMENA!!! NAIME header NECE DA RADI AKO FAJL IMA AMA BILO KAKAV OUTPUT PRE IZVRSAVANJA HEADERA!!
		// ZATO JE KLJUCNO BILO DA SE STAVI isset($_GET["logout"]) DA PHP NE BI ISPISAO NEKI WARNING KOJI BI AUTOMATSKI BIO OUTPUT I SAMIM TIM BI SJEBO header poziv!
	}
	if (!isset($user)) $user = "";
	if (!empty($_SESSION["username"])) $user = $_SESSION["username"];
	else if (!empty($_GET["firstLogin"])) {
		$user = $_GET["firstLogin"];
		unset($_GET["firstLogin"]);
	}
	else $user = $_POST["userPost"]; 
		
	//echo "user is: ".$user;

	
	if (isset($_POST["text"])) {
			$query = "UPDATE `user_info` SET diary = '".$_POST["text"]."' WHERE username = '".$user."' LIMIT 1";
			mysqli_query($link, $query);
	}
	$query = "SELECT diary FROM `user_info` WHERE username = '".$user."'";
	$result = mysqli_query($link, $query);
	$content = mysqli_fetch_array($result);
				
			
?>
	
<html>
	<head>
		<title>Secret diary</title>
	
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
		<script>    
			if (typeof window.history.pushState == 'function') {
					window.history.pushState({}, "Hide", '<?php echo $_SERVER['PHP_SELF'];?>');
			}
		</script>
		<style type="text/css">
		
			* {
				margin: 0;
				padding: 0;
				box-sizing: border-box;
			}
			body {
				background-image:url(https://images.unsplash.com/photo-1476081718509-d5d0b661a376?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1533&q=80);
				height:100%
				overlow-y:none;
			}
			.diary {
				width:100%;
				height:calc(100% - 70px);
			}

		</style>
	</head>
	<body>
		
		<nav id="myNavbar" class="navbar navbar-dark bg-dark">
				<a class="navbar-brand" href="#">SecretDiary</a>
				<button type="submit" class="btn btn-info" onclick="submitForm('textForm')">Save diary</button>
				<a href="final_login.php?logout=true" class="btn btn-success">Log out</a>
		</nav> 
		
		<div class="container">
			<h1 class="text-center" style="color:#00ff00">Welcome! Continue updating your diary below and enjoy!</h1>
			<form id="textForm" method="post">
				<textarea type="text" name="text" class="diary" style="background-image:linear-gradient(to right,#009900,#00e64d);"><?php echo $content["diary"];?></textarea>
				<input type="text" class="d-none" name="userPost" value="<?php echo $user;?>">
			</form>
		</div>
			
		<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
		<script type="text/javascript">
			function submitForm(form){
				document.getElementById(form).submit();
			}
		</script>
	</body>


</html>

