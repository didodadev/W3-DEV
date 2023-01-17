<cfif isDefined("attributes.password") and Len(attributes.password)>
	<cfset pass = Encrypt(attributes.password,session.ep.userid)>
<cfelse>	
	<cfset pass = "">
</cfif>

<cfquery name="UPD_MAIL_SETTING" datasource="#DSN#">  
	UPDATE
		EXCHANGE_SETTINGS
	SET
		SERVER_ADDRESS = '#attributes.SERVER_ADDRESS#',
		USERNAME = '#attributes.USERNAME#',
		PASSWORD = '#attributes.PASSWORD#',
		PORT = '#attributes.PORT#',
		PROTOCOL = '#attributes.PROTOCOL#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE=#now()#,
		UPDATE_IP='#cgi.remote_addr#'
	WHERE
		SETTING_ID = #attributes.mailbox_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=correspondence.list_mymails_exchange" addtoken="no"> 
