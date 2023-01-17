<cfquery name="GET_OPTION_STATUS" datasource="#dsn#">
	SELECT
		PAYMETHOD_ID,
		PAYMETHOD
	FROM 
		SETUP_PAYMETHOD
		<cfif isdefined("attributes.option_status_id")>
		WHERE
			PAYMETHOD_STATUS = 1 AND
			PAYMETHOD_ID = #attributes.option_status_id#
		</cfif>	
	ORDER BY
		PAYMETHOD_ID
</cfquery>
