<cfparam name="attributes.page" default="">
<cfif isDefined('attributes.page') and len(attributes.page) LTE 0 >	
	<link rel="stylesheet" href="/css/assets/template/contes/contes.css" type="text/css">
	<link rel="stylesheet" href="/css/assets/template/contes/sass/style.css" type="text/css">
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
	<meta charset="UTF-8">		
	<div id="pageContainer"></div>	
	<script src="JS/assets/plugins/contes/materialize-pagination.js"></script>
	<script src="JS/assets/plugins/contes/contes.js"></script>
<cfelse>
	<cfswitch expression = "#attributes.page#">
		<cfcase value="sites">
			<script src="JS/assets/plugins/contes/materialize.js"></script>
			<cfinclude template="view/sites.cfm">
		</cfcase>
		<cfcase value="newpost">
			<script src="JS/assets/plugins/contes/materialize.js"></script>
			<cfinclude template="view/newpost.cfm">
		</cfcase>
		<cfcase value="category">
			<script src="JS/assets/plugins/contes/materialize.js"></script>
			<cfinclude template="view/category.cfm">
		</cfcase>
		<cfdefaultcase>
			<script src="JS/assets/plugins/contes/materialize.js"></script>
			<cfinclude template="view/home.cfm">
		</cfdefaultcase>
	</cfswitch>

</cfif>