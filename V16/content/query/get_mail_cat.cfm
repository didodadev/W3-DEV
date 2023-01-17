<!--- get_mail_cat.cfm --->
<cfquery name="GET_MAIL_CAT" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		MAILLIST_CAT
	WHERE 
		MAILLIST_CAT_STATUS = 1
</cfquery>
