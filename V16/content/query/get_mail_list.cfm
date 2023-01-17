<!--- get_mail_list --->
<cfquery name="GET_MAIL_LIST" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		MAILLIST M, 
		CONTENT_CAT CC 
	WHERE 
		CC.CONTENTCAT_ID IN (M.CONTENT_CAT_ID)
</cfquery>
