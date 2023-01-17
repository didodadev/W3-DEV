<cfquery name="CONSUMER_CAT_NAME" datasource="#dsn#">
	SELECT CONSCAT FROM CONSUMER_CAT WHERE CONSCAT_ID = #attributes.CONSCAT_ID#
</cfquery>
