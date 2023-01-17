﻿<cfif len(plus_date)><cf_date tarih="plus_date"></cfif>
<cfquery name="UPD_OFFER_PLUS" datasource="#DSN3#">
	UPDATE
		OPPORTUNITIES_PLUS
	SET
		COMMETHOD_ID = <cfif Len(commethod_id)>#commethod_id#<cfelse>NULL</cfif>,
		MAIL_SENDER = <cfif Len(attributes.employee_emails)>'#attributes.employee_emails#'<cfelse>NULL</cfif>,
		MAIL_CC = <cfif Len(attributes.employee_emails1)>'#attributes.employee_emails1#'<cfelse>NULL</cfif>,
		PLUS_DATE = <cfif len(plus_date)>#plus_date#<cfelse>NULL</cfif>,
		PLUS_CONTENT = '#PLUS_CONTENT#',
		EMPLOYEE_ID  = <cfif len(employee_id)>#employee_id#<cfelse>NULL</cfif>,
		UPDATE_DATE  = #now()#,
		UPDATE_EMP   = #session.ep.userid#,
		UPDATE_IP    = '#cgi.remote_addr#',
        IS_EMAIL 	 = <cfif isDefined("email") and (email eq "true") and Len(attributes.employee_emails)>1,<cfelse>0,</cfif>
	    PLUS_SUBJECT = '#attributes.opp_head#'
	WHERE
		OPP_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#opp_plus_id#">
</cfquery>
<cfquery name="GET_OPP_INFO" datasource="#DSN3#">
	SELECT 
		O.OPP_NO,
		O.OPP_HEAD 
	FROM
		OPPORTUNITIES_PLUS OP LEFT JOIN OPPORTUNITIES O ON OP.OPP_ID = O.OPP_ID 
	WHERE
		 OP.OPP_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#opp_plus_id#">
</cfquery>
<cfif isDefined("email") and (email eq "true") and Len(attributes.employee_emails)>
	<cfquery name="GET_MAILFROM" datasource="#DSN#">
		SELECT
        	<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_NAME NAME_,EMPLOYEE_SURNAME SURNAME_,EMPLOYEE_EMAIL EMAIL_<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_NAME NAME_,COMPANY_PARTNER_SURNAME NAME_,COMPANY_PARTNER_EMAIL EMAIL_</cfif>
		FROM		
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
		WHERE
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"></cfif>
			 
	</cfquery>
	<cfif get_mailfrom.recordcount>
    	<cfset from_ = "#get_mailfrom.name_# #get_mailfrom.surname_#<#get_mailfrom.email_#>">
    </cfif>
    <!---from = "#from_#"--->
	<cftry>
		<cfmail to = "#attributes.employee_emails#" cc="#attributes.employee_emails1#" from="#session.ep.company_email#" subject = "#get_opp_info.OPP_NO# #get_opp_info.OPP_HEAD#" type="HTML">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
				.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
			</style>		
			<table class="css1">
				<tr>
					<td valign="top"><strong><cf_get_lang_main no="68.Konu"></strong>&nbsp;</td>
					<td valign="top">#attributes.opp_head#</td>
				</tr>
				<tr>
					<td valign="top"><strong><cf_get_lang_main no="217.Açıklama"></strong>&nbsp;</td>
					<td valign="top">#attributes.plus_content#</td>
				</tr>
			</table>  
			
		</cfmail>
		<cfsavecontent variable="css">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>
		</cfsavecontent>	
		<cfset attributes.body="#css##attributes.plus_content#">
		<cfset attributes.to_list="#attributes.employee_emails#">
		<cfset attributes.cc_list="#attributes.employee_emails1#">
		<cfset attributes.from = from_>
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
						<td align="center" class="headbold"><cf_get_lang no='25.Fırsat Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz'></td>
					</tr>
				</table>
				</td>
			</tr>
			</table>
		</cfcatch>
	</cftry>
	<script type="text/javascript">
		location.href = document.referrer;
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
location.href = document.referrer;
	wrk_opener_reload();
	window.close();
</script>
