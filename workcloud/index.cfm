<cfif isdefined("dsn")>
	<div class="install_panel">
		<div class="col-md-12 col-sm-12 col-xs-12 paddingLess">	
			<h3>This system is running.</h3> <h4>Contact to system administrator. Workcube Catalyst</h4>
		</div>
	</div>
	<cfabort>
</cfif>

<cfscript>
	index_folder_ilk_ = replace(GetDirectoryFromPath(GetCurrentTemplatePath()),'\','/','all');
	index_folder = replace(index_folder_ilk_,'workcloud/','','all');
	CRLF = Chr(13) & Chr(10);
	attributes = attributes?:structNew();
	StructAppend(attributes, url, "no");
	StructAppend(attributes, form, "no");
	dir_seperator = Server.OS.Name is 'Unix' ? '/' : '\';
	period_date = '01/01/#year(now())#';
	attributes.upload_folder = "#index_folder#V16#dir_seperator#admin_tools#dir_seperator#";
	if(IsDefined("session.ep")) StructDelete(session,'ep');
	installUrl = cgi.SERVER_PORT neq '443' ? "http://#cgi.HTTP_HOST#/workcloud/" : "https://#cgi.HTTP_HOST#/workcloud/";
	site_url = cgi.SERVER_PORT neq '443' ? "http://#cgi.HTTP_HOST#" : "https://#cgi.HTTP_HOST#";
</cfscript>

<cfif not FileExists("#index_folder#/dsn.txt")><cffile action = "write" file = "#index_folder#/dsn.txt" output = "" charset = "utf-8"></cfif>

<cfset parameter = createObject("component","workcloud/cfc/parameter") />

<!DOCTYPE html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
	<link rel="stylesheet" href="html/fonts/font-awesome/4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" href="html/fonts/gui_custom.css">
	<link rel="stylesheet" href="html/css/bootstrap.min.css">
	<link rel="stylesheet" href="html/css/style.css">
	<script src="html/js/jquery-3.2.1.min.js"></script>
</head>
<body>
	<div class="install_panel row">
		<header class="col-md-12 col-xs-12"><h3>Workcube Install</h3></header>
		<section class="col-md-12 col-xs-12 paddingLess">
			<cfif NOT isdefined('attributes.installation_type')>
				<div class="col-md-9 col-sm-7 col-xs-12 paddingLess">
			<cfelse>
				<div class="col-md-3 col-sm-5 col-xs-12 paddingLess">
					<cfinclude template="html/start_html.cfm">
				</div>
				<div class="col-md-9 col-sm-7 col-xs-12 paddingLess">
			</cfif>
				<cfif isdefined('attributes.installation_type') and attributes.installation_type is 'install_1'>
					<cfinclude template="add_installation_1.cfm">
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is 'install_2_1'>
					<cfinclude template="add_installation_2_1.cfm">					
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is 'install_7'>
					<cfinclude template="add_installation_7.cfm">
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '2'>
					<cfinclude template="installation2.cfm">
					<script>$( ".step1" ).addClass( "stepactive" );</script>
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '2_1'>
					<cfinclude template="installation2_1.cfm">
					<script>$( ".step2" ).addClass( "stepactive" );</script>
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '3'>
					<cfinclude template="installation3.cfm">
					<script>$( ".step3" ).addClass( "stepactive" );</script>
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '4'>
					<cfinclude template="installation4.cfm">
					<script>$( ".step4" ).addClass( "stepactive" );</script>
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '5'>
					<cfinclude template="installation5.cfm">
					<script>$( ".step5" ).addClass( "stepactive" );</script>
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '6'>
					<cfinclude template="installation6.cfm">
					<script>$( ".step6" ).addClass( "stepactive" );</script>
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '7'>
					<cfinclude template="installation7.cfm">
					<script>$( ".step7" ).addClass( "stepactive" );</script>
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '8'>
					<cfinclude template="installation8.cfm">
					<script>$( ".step8" ).addClass( "stepactive" );</script>
				<cfelseif isdefined('attributes.installation_type') and attributes.installation_type is '9'>
					<cfinclude template="installation9.cfm">
					<script>$( ".step9" ).addClass( "stepactive" );</script>
				<cfelse>
					<cfinclude template="installation1.cfm">
				</cfif>
				
			</div>
			<cfif NOT isdefined('attributes.installation_type')>
				<div class="col-md-3 col-sm-12 col-xs-12 paddingLess">
					<cfinclude template="html/finish_html.cfm"> 
				</div>
			</cfif>
		</section>
	</div>

	<cffunction name="sql_unicode" returntype="string" output="false">
		<cfscript>
			sql_add = 'N';
		</cfscript>
		<cfreturn sql_add>
	</cffunction>

    <script src="html/js/bootstrap.min.js"></script>
	<script src="html/js/script.js"></script>
	<script>
		$(function(){
			$.install.formControl();
			$.install.formLoading();
		});
	</script>
</body>
</html>