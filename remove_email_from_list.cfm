<cfif isDefined('attributes.mail_adr')>
<cfset cont_key = 'wrk'>
<cfset decmail_ = Decrypt('#attributes.mail_adr#',cont_key,"CFMX_COMPAT","Hex")>
<cfif len(decmail_)>
	<!--- consumer email removal --->
	<cfquery name="GET_EMAIL_ASSETS" datasource="#dsn#">
		UPDATE 
			CONSUMER
		SET
			WANT_EMAIL = 0
		WHERE
			CONSUMER_EMAIL = '#decmail_#'
	</cfquery>
	<!--- partner email removal --->
	<cfquery name="GET_EMAIL_ASSETS" datasource="#dsn#">
		UPDATE 
			COMPANY_PARTNER
		SET
			WANT_EMAIL = 0
		WHERE
			COMPANY_PARTNER_EMAIL = '#decmail_#'
	</cfquery>
	<!--- mail list removal --->
	<cfquery name="GET_EMAIL_ASSETS" datasource="#dsn#">
		UPDATE 
			MAILLIST
		SET
			WANT_EMAIL = 0
		WHERE
			MAILLIST_EMAIL = '#decmail_#'
	</cfquery>
</cfif>
<script type="text/javascript">
	alert('E-postanız Sistemimizden Başarıyla Kaldırılmıştır!');
	window.location.href='<cfoutput>http://#listfirst(server_url,';')#</cfoutput>';
</script>
<cfelse>
	<script type="text/javascript">
		window.location.href='<cfoutput>http://#listfirst(server_url,';')#</cfoutput>';
	</script>
</cfif>