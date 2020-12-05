<?php
	session_start(); //neophodno dodati ovde zbog sprege sa session.php fajlom

	$link = mysqli_connect("localhost","id15431726_user_base","zH=LLUyw%3}5[lIs", "id15431726_users"); 
	if (mysqli_connect_error()) die ("Failed to connect to database!"); 
	
	if(!empty($_GET)){
		
		if ($_GET["password"] == "") echo "Please input the Password!<br>";		
		if ($_GET["email"] == "") echo "Please input email adress!<br>";
		else {
		
			$query = "SELECT `username` FROM user_info WHERE username = '".mysqli_real_escape_string($link, $_GET["email"])."'";			
			$result = mysqli_query($link, $query);
			if (mysqli_fetch_array($result)) echo "User is already in the database!<br>";			
			else {
					$query = "INSERT INTO `user_info` (`username`,`password`) VALUES('".$_GET["email"]."', '".$_GET["password"]."')";
					if (mysqli_query($link, $query)) {
						
						$_SESSION["email"] = $_GET["email"];
						header("Location: session.php");  // ova komanda izgleda radi redirekciju na drugu stranicu

					}
			}	
		}
	}	
			
			
			/*while ($row = mysqli_fetch_array($result) {
				OVAKO SLJAKA WHILE PO BAZI 
			}*/
	  
	
?>

<hmtl>
	<head>
		<title>Forma</title>
	</head>
	<body>
		<form>
			<label for="email">Email</label>
			<input id="email" name="email" type="email" placeholder="Email">
			<label for="Password">Password</label>
			<input id="password" name="password" type="password">
			<button type="submit">Submit </button>
		</form>
		
		
	</body>


</html>

