<cfquery name="EXCHANGE_SETTINGS_INF" datasource="#dsn#">
	SELECT
		SETTING_ID,
		SERVER_ADDRESS,
		USERNAME,
		PASSWORD,
		PORT,
		PROTOCOL
	FROM
		EXCHANGE_SETTINGS
	WHERE 
		SETTING_ID = #session.mailbox_id#
</cfquery>

<cfoutput query="EXCHANGE_SETTINGS_INF">
	<cftry>
  	<cfif len(PROTOCOL)>
		<cfset p_ = PROTOCOL>
	<cfelse>
		<cfset p_ = "http://">
	</cfif>
	<cfexchangeconnection connection="wrk_exchange_connection" action="open" 
		server="#SERVER_ADDRESS#" 
		username="#USERNAME#" 
		password="#PASSWORD#" 
		formBasedAuthentication = "no"
		protocol="#p_#"
		ExchangeServerLanguage = "english">
		<cfset session.mailbox_username = USERNAME>
		<cfset session.mailbox_username_folder = USERNAME>
		<cfset session.mailbox_password = PASSWORD>
		<cfset session.mailbox_server = SERVER_ADDRESS>
	<cfcatch>
		<script language="javascript">
			alert("<cf_get_lang dictionary_id='54776.Bağlantı Sağlanamadı'> ! <cf_get_lang dictionary_id='54777.Yanlış kullanıcı adı ya da şifre tanımlanmıştır.'>");
			window.location = '#request.self#?fuseaction=correspondence.welcome';
		</script>		
		<cfabort>
	</cfcatch>
	</cftry>
</cfoutput>
