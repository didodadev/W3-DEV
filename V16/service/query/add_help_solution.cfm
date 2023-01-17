<cfif isdefined("attributes.help_mail") and len(attributes.help_mail)>
	<cfquery name="add_help_mail" datasource="#dsn#">
		INSERT INTO
			CUST_HELP_SOLUTIONS
			(
				CUS_HELP_ID,
				SOLUTION_SUBJECT,
				SOLUTION_DETAIL,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
			<cfif isDefined("attributes.email") and (attributes.email eq "true")>
				,IS_MAIL_SEND
			</cfif>
			)
			VALUES
			(
				#attributes.help_id#,
				'#attributes.header#',
				'#attributes.content#',
				#now()#,
				'#cgi.REMOTE_ADDR#',
				#session.ep.userid#
			<cfif isDefined("attributes.email") and (attributes.email eq "true")>
				,1
			</cfif>
			)
	</cfquery>
	<cftry>
	  <cfmail  
		  to = "#attributes.help_mail#"
		  from = "#session.ep.company#<#session.ep.company_email#>"
		  subject = "#attributes.header#" type="HTML">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>
			#attributes.content#
	  </cfmail>
	  <cfsavecontent variable="css">
		<style type="text/css">
			.color-header{background-color: ##a7caed;}
			.color-border	{background-color:##6699cc;}
			.color-row{	background-color: ##f1f0ff;}
			.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
		</style>
	  </cfsavecontent>	
    <!---<cfset attributes.from = "#session.ep.company#<#session.ep.company_email#>">  
	<cfset attributes.body="#css##attributes.content#">
	<cfset attributes.to_list="#attributes.help_mail#">
	<cfset attributes.type=0>
	<cfset attributes.module="service">
	<cfset attributes.subject="#attributes.header#">
	<cfinclude template="../../objects/query/add_mail.cfm"> py kapattı 1114--->

		<style type="text/css">
			.color-header{background-color: ##a7caed;}
			.color-border	{background-color:##6699cc;}
			.color-row{	background-color: ##f1f0ff;}
			.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
		</style>	  	   
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top"> 
					<table height="100%" width="100%" cellspacing="1" cellpadding="2">
						<tr class="color-list">
							<td height="35" class="headbold">&nbsp;&nbsp;Workcube E-Mail</td>
						</tr>
						<tr class="color-row">
							<td align="center" class="headbold">Mail Başarıyla Gönderildi</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<cfcatch type="any">
		<style type="text/css">
			.color-header{background-color: ##a7caed;}
			.color-border	{background-color:##6699cc;}
			.color-row{	background-color: ##f1f0ff;}
			.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
		</style>	
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top"> 
					<table height="100%" width="100%" cellspacing="1" cellpadding="2">
						<tr class="color-list">
							<td height="35" class="headbold">&nbsp;&nbsp;Workcube E-Mail</td>
						</tr>
						<tr class="color-row">
							<td align="center" class="headbold"> Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</cfcatch>
	</cftry>
	<script type="text/javascript">
		function waitfor(){
			window.close();
		}
		setTimeout("waitfor()",3000); 	
		wrk_opener_reload();
	</script>
	<cfabort>	
</cfif>
