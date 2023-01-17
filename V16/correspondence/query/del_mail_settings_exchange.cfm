<cfparam name="attributes.mailbox_id" default="">
<cfif attributes.mailbox_id is "">
	<cfabort>
</cfif>
<cfquery name="DEL_MAIL_SETTING" datasource="#DSN#">  
	  DELETE FROM
		EXCHANGE_SETTINGS
	  WHERE
		SETTING_ID = #attributes.mailbox_id#	 
</cfquery>
<cflocation url="#request.self#?fuseaction=correspondence.list_mymails_exchange" addtoken="no"> 
