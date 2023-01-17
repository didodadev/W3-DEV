<cfquery name="DELOFFERSTATUS" datasource="#dsn#">
	DELETE 
	FROM 
		OFFER_STATUS 
	WHERE 
		OFFERSTATUS_ID=#OFFERSTATUS_ID#
</cfquery>

