<cfquery name="GET_PAYMETHOD" datasource="#dsn#">
	SELECT 
		*
	FROM 
		SETUP_PAYMETHOD
	WHERE
		PAYMETHOD_ID = #attributes.PAYMETHOD_ID#
</cfquery>
