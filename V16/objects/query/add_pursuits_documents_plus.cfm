<cfif len(plus_date)><cf_date tarih="plus_date"></cfif>
<cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_order">
 	<cfset database_name = dsn3>
	<cfset plus_table_name = "ORDER_PLUS">
	<cfset main_column_name = "ORDER_ID">
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_invoice">
	<cfset database_name = dsn2>
	<cfset plus_table_name = "INVOICE_PURSUIT_PLUS">
	<cfset main_column_name = "INVOICE_ID">
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_service_application">
	<cfset database_name = dsn3>
	<cfset plus_table_name = "SERVICE_PLUS">
	<cfset main_column_name = "SERVICE_ID">
</cfif>
<cfquery name="add_pursuit_plus" datasource="#database_name#">
	INSERT INTO
		#plus_table_name#
	(
		#main_column_name#,
		PLUS_CONTENT,
		<cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_service_application">
			SUBJECT,
		<cfelse>
			PLUS_SUBJECT,
		</cfif>
		<cfif commethod_id neq 0>
			COMMETHOD_ID,
		</cfif>
		<cfif len(plus_date)>
			PLUS_DATE,
		</cfif>
		<cfif len(employee_id)>
			EMPLOYEE_ID,
		</cfif>
		<cfif len(partner_id)>
			PARTNER_ID,
		</cfif>
		RECORD_DATE,
		RECORD_EMP,
		<cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_service_application">
			SERVICE_ZONE,
		<cfelse>
			ORDER_ZONE,
		</cfif>
		RECORD_IP,
		MAIL_SENDER
		)
	VALUES
		(
		#action_id#,
		'#plus_content#',
		'#opp_head#',
		<cfif commethod_id neq 0>
			#commethod_id#,
		</cfif>
		<cfif len(plus_date)>
			#plus_date#,
		</cfif>
		<cfif len(employee_id)>
			#employee_id#,
		</cfif>
		<cfif len(partner_id)>
			#partner_id#,
		</cfif>
		#now()#,
		#session.ep.userid#,
		0,
		'#cgi.remote_addr#',
		<cfif isDefined("attributes.email") and (attributes.email eq "true")>
			'#attributes.member_emails#'
		<cfelse>
			''
		</cfif>		
		)
</cfquery>

<cfif isDefined("email") and (email EQ "true")>
	<cfquery name="GET_MAILFROM" datasource="#dsn#">
		select
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_EMAIL</cfif>
		from		
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
		where
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID=#session.ep.userid#<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID=#session.pp.userid#</cfif>
			 
	</cfquery>
	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		<cfset sender = "#GET_MAILFROM.EMPLOYEE_EMAIL#">
	<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		<cfset sender = "#GET_MAILFROM.COMPANY_PARTNER_EMAIL#">
	</cfif>

	<cftry>
		<cfmail  
			to = "#attributes.member_emails#"
			from = "#sender#"
			subject = "#attributes.opp_head#" type="HTML">
			
				<style type="text/css">
					.color-header{background-color: ##a7caed;}
					.color-border	{background-color:##6699cc;}
					.color-row{	background-color: ##f1f0ff;}
					.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
				</style>		  
			#attributes.plus_content#
		</cfmail>
	   
		<cfsavecontent variable="css">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>
		</cfsavecontent>	
        <cfset attributes.from = sender>  
		<cfset attributes.body="#css##attributes.plus_content#">
		<cfset attributes.to_list="#attributes.member_emails#">
		<cfset attributes.type=0>
		<cfset attributes.module="sales">
		<cfset attributes.subject="#attributes.opp_head#">
		<cfinclude template="../../objects/query/add_mail.cfm">
	  
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
						<td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
					</tr>
					<tr class="color-row">
						<td align="center" class="headbold"><cf_get_lang_main no='101.Mail Başarıyla Gönderildi'></td>
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
								<td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang_main no='100.Workcube E-Mail'></td>
							</tr>
							<tr class="color-row">
								<td align="center" class="headbold"><cf_get_lang no='24.Teklif Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</cfcatch>
	</cftry>
	<script type="text/javascript">
		wrk_opener_reload();
		function waitfor()
		{
		  window.close();
		}
		setTimeout("waitfor()",5000); 		
	</script>
	<cfabort>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
