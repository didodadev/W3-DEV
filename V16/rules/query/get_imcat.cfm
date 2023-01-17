<cfquery name="GET_IMCAT" datasource="#dsn#">
	SELECT * FROM SETUP_IM WHERE IMCAT_ID=#attributes.IMCAT_ID#
</cfquery>