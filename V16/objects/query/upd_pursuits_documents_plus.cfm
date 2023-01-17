<cfif len(plus_date)><cf_date tarih="plus_date"></cfif>
<cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_order">
 	<cfset database_name = dsn3>
	<cfset plus_table_name = "ORDER_PLUS">
	<cfset plus_column_name = "ORDER_PLUS_ID">
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_invoice">
	<cfset database_name = dsn2>
	<cfset plus_table_name = "INVOICE_PURSUIT_PLUS">
	<cfset plus_column_name = "INVOICE_PLUS_ID">
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_service_application">
	<cfset database_name = dsn3>
	<cfset plus_table_name = "SERVICE_PLUS">
	<cfset plus_column_name = "SERVICE_PLUS_ID">
</cfif>
<cfquery name="upd_pursuit_plus" datasource="#database_name#">
	UPDATE
		#plus_table_name#
	SET
		PLUS_CONTENT = '#plus_content#',
		<cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_service_application">
			SUBJECT
		<cfelse>
			PLUS_SUBJECT
		</cfif>
		 = <cfif isDefined("opp_head")>'#opp_head#'<cfelse>NULL</cfif>,
		<cfif isDefined("attributes.email") and (attributes.email eq "true")>
			MAIL_SENDER = '#attributes.member_emails#',
		</cfif>
		COMMETHOD_ID = <cfif commethod_id neq 0>#commethod_id#<cfelse>NULL</cfif>,
		PLUS_DATE = <cfif len(plus_date)>#plus_date#<cfelse>NULL</cfif>,
		EMPLOYEE_ID = <cfif len(employee_id) and len(member_emails)>#employee_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		#plus_column_name# = #action_plus_id#

</cfquery>

<cfif isDefined("attributes.email") and (attributes.email EQ "true")>
	<cfquery name="GET_MAILFROM" datasource="#dsn#">
		select
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_EMAIL<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_EMAIL</cfif>
		from		
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
		where
			<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID = #session.ep.userid#<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID = #session.pp.userid#</cfif>
			 
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
		<cf_popup_box title="#getLang('main',100)#">	  	  	   
			<table height="100%" width="100%" cellspacing="0" cellpadding="0">
				<tr class="color-row">
					<td class="formbold" style="text-align:center"><cf_get_lang_main no='101.Mail Başarıyla Gönderildi'></td>
				</tr>
			</table>
		</cf_popup_box>	
	<cfcatch type="any">
	<style type="text/css">
		.color-header{background-color: ##a7caed;}
		.color-border	{background-color:##6699cc;}
		.color-row{	background-color: ##f1f0ff;}
		.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
	</style>
	 <cf_popup_box title="#getLang('main',100)#">	
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr height="300">
				<td class="formbold" style="text-align:center"><cfoutput>#getLang('sales',31)#</cfoutput></td>		
			</tr>
		</table>
	</cf_popup_box>
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
