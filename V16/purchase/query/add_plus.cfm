<cfif len(attributes.plus_date)><cf_date tarih="attributes.plus_date"></cfif>
<cfswitch expression="#FORM.PLUS_TYPE#">
	<cfcase value="ORDER">
		<cfquery name="ADD_ORDER_PLUS" datasource="#dsn3#">
			INSERT INTO 
				ORDER_PLUS 
				(
					ORDER_ID,
					PLUS_DATE,
					COMMETHOD_ID,
					EMPLOYEE_ID,
					PLUS_CONTENT,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					ORDER_ZONE,
					MAIL_SENDER
				)
			VALUES
				(
					#FORM.ORDER_ID#,
					<cfif len(attributes.plus_date)>
						#attributes.plus_date#,
					<cfelse>
						NULL,
					</cfif>
					#FORM.COMMETHOD_ID#,
					#FORM.EMPLOYEE_ID#,
					'#FORM.PLUS_CONTENT#',
					#NOW()#,
					#SESSION.EP.USERID#,
					'#REMOTE_ADDR#',
					0,
					<cfif isDefined("attributes.email") and (attributes.email EQ "true")>
					'#attributes.employee_names#'
					<cfelse>
					''
					</cfif>					
				)
		</cfquery>
	</cfcase>
	<cfcase value="offer">
		<cfquery name="ADD_ORDER_PLUS" datasource="#dsn3#">
			INSERT INTO 
				OFFER_PLUS 
				(
					OFFER_ID,
					PLUS_DATE,
					COMMETHOD_ID,
					EMPLOYEE_ID,
					SUBJECT,
					PLUS_CONTENT,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					OFFER_ZONE,
					MAIL_SENDER
				)
			VALUES
				(
					#FORM.OFFER_ID#,
					<cfif len(attributes.plus_date)>
						#attributes.plus_date#,
					<cfelse>
						NULL,
					</cfif>
					<cfif FORM.COMMETHOD_ID IS "0">
						17,
					<cfelse>
						#FORM.COMMETHOD_ID#,
					</cfif>
					#FORM.EMPLOYEE_ID#,
					'#FORM.header#',
					'#FORM.PLUS_CONTENT#',
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					0,
					<cfif isDefined("attributes.email") and (attributes.email EQ "true")>					
					'#attributes.employee_names#'
					<cfelse>
					''
					</cfif>					
				)
		</cfquery>
	</cfcase>
</cfswitch>
<cfif isDefined("attributes.email") and (attributes.email EQ "true")>
	<cfquery name="GET_MAILFROM" datasource="#dsn#">
		select
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_NAME NAME_,EMPLOYEE_SURNAME SURNAME_,EMPLOYEE_EMAIL EMAIL_<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_NAME NAME_,COMPANY_PARTNER_SURNAME NAME_,COMPANY_PARTNER_EMAIL EMAIL_</cfif>
		from		
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
		where
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID=#session.ep.USERID#
			<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID=#session.pp.USERID#</cfif>
	</cfquery>
	<cfif GET_MAILFROM.RECORDCOUNT>
		<cfset sender = "#GET_MAILFROM.NAME_# #GET_MAILFROM.SURNAME_#<#GET_MAILFROM.EMAIL_#>">
	</cfif>
	<cftry>
	  <cfmail  
		  to = "#attributes.employee_names#"
		  from = "#sender#"
		  subject = "#attributes.header#" type="HTML">
			  
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
	  <cfset attributes.to_list="#attributes.employee_names#">
	  <cfset attributes.type=0>
	  <cfset attributes.module="purchase">
	  <cfset attributes.subject="#attributes.header#">
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
						<td align="center" class="headbold">
						<cf_get_lang no='21.Fırsat Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz !'></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</cfcatch>
	</cftry>
	<script type="text/javascript">
		wrk_opener_reload();
		function waitfor(){
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
