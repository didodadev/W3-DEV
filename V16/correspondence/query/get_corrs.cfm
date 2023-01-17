<cfquery name="SETUP_CORR" datasource="#dsn#">
	SELECT * FROM SETUP_CORR
	<cfif isDefined("attributes.CORRCAT_ID") and len(attributes.CORRCAT_ID)>		
	WHERE
		CORRCAT_ID = #attributes.CORRCAT_ID#
	</cfif>			
</cfquery>
