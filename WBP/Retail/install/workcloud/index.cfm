<!DOCTYPE html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
	<link rel="stylesheet" href="html/css/bootstrap.min.css">
    <script src="html/js/jquery-3.2.1.min.js"></script>
    <script src="html/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="html/css/style.css">
	<script src="html/js/script.js"></script>
</head>
<cfset params = CreateObject("component", "/WMO/params")>
    <cfset systemParam = params.systemParam()>
    <cfset dsn = systemParam.dsn>
<body>
	<cfset index_folder_ilk_ = '#GetDirectoryFromPath(GetCurrentTemplatePath())#'>
	<cfset index_folder = replace(index_folder_ilk_,'workcloud\','','all')>
	
	<cfif fileexists('#index_folder#fbx_workcube_param.cfm')>
		<div class="install_panel">
			<div class="col-md-12 col-sm-12 col-xs-12 paddingLess">	
				<h3>This system is running.</h3> <h4>Contact to system administrator. Workcube Catalyst</h4>
			</div>
		</div>
		<cfabort>
	</cfif>

	<cfscript>
		CRLF = Chr(13) & Chr(10);
		if (not IsDefined("attributes"))
			attributes=structNew();
		StructAppend(attributes, url, "no");
		StructAppend(attributes, form, "no");

		if(Server.OS.Name is 'Unix')
			dir_seperator = '/';
		else
			dir_seperator = '\';
	</cfscript>

	<cfset period_date='01/01/2012'>
	<!--- <cf_date tarih="period_date"> --->
	<cfset attributes.upload_folder = "#index_folder#V16#dir_seperator#admin_tools#dir_seperator#">

	<cftry>
		<cfscript>
			StructDelete(session,'ep');
		</cfscript>
		<cfcatch type="any"></cfcatch>
	</cftry>

	<cfif isdefined('session.ep.userid')>
		<cflocation url="#user_domain##request.self#?fuseaction=myhome.welcome" addtoken="no">
	<cfelse>

	<cfif cgi.SERVER_PORT eq '80'><cfset installUrl = "http://#cgi.HTTP_HOST#/wbp/retail/install/workcloud/">
	<cfelse><cfset installUrl = "https://#cgi.HTTP_HOST#/wbp/retail/install/workcloud/">
	</cfif>
	
	<cfif NOT isdefined('attributes.installation_type')>
		<cfset session.licenceVerified = true>
	</cfif>
	
	<div class="install_panel row">

		<header class="col-md-12 col-xs-12">

			<h3>Workcube Catalyst Install - Settings</h3>

		</header>
		<section class="col-md-12 col-xs-12 paddingLess">

			<div class="col-md-3 col-sm-5 col-xs-12 paddingLess">
				<cfinclude template="html/start_html.cfm"> 
			</div>
			
			<div class="col-md-6 col-sm-7 col-xs-12 paddingLess">		
				<cfif isdefined('attributes.installation_type') and attributes.installation_type is 'install_2'>

					<cfinclude template="db/create_main_db.cfm">
					<script>$( ".step2" ).addClass( "stepactive" );</script>  
				<cfelse>
					<cfinclude template="installation2.cfm">
					<script>$( ".step1" ).addClass( "stepactive" );</script>
				</cfif>
				
			</div>

			<div class="col-md-3 col-sm-12 col-xs-12 paddingLess">
				<cfif isDefined("session.licenceVerified") AND session.licenceVerified>
					<cfinclude template="html/finish_html.cfm"> 
				</cfif>
			</div>

		</section>

	</div>

	</cfif>


	<cffunction name="sql_unicode" returntype="string" output="false">
			<cfscript>
					sql_add = 'N';
			</cfscript>
		<cfreturn sql_add>
	</cffunction>

	<script>

		$(function(){
			
			$.install.formControl();
			$.install.formLoading();

		});
		
	</script>

</body>
</html>