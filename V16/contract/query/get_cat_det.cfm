<cfquery name="GET_CAT_DET" datasource="#dsn3#">
	SELECT * FROM CONTRACT_CAT WHERE CONTRACT_CAT_ID=#GET_DET_CONT.CONTRACT_CAT_ID#
</cfquery>
