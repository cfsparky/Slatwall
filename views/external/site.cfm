<cfparam name="rc.es" default="http://www.google.com/" />
<html>
<head>
	<script type="text/javascript" src="/default/includes/themes/nytro/js/jquery-1.3.1.min.js"></script>
	<script type="text/javascript" src="js/slatwall.js"></script>
	<link rel="stylesheet" type="text/css" href="css/slatwall_admin.css" media="all" />
	<link rel="stylesheet" type="text/css" href="css/slatwall_toolbar.css" media="all" />
	<script type="text/javascript">
		$(document).ready(function(){
			$('#ExternalSite').height($('body').height()-27); 
		});
	</script>
</head>
<body>
<cfif left(rc.es,4) neq "http">
	<cfset rc.es = "http://#rc.es#" />
</cfif>
<cfoutput>
	<iframe name="ExternalSite" id="ExternalSite" style="border:none; width:100%; height:100%;" src="#rc.es#" ></iframe>
	#view('frontend/toolbar')#
</cfoutput>
</body>
</html>