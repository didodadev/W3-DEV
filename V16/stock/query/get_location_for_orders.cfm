<cfquery name="GET_LOCATION" datasource="#dsn#">
	SELECT
		SL.*,
		D.DEPARTMENT_HEAD
	FROM 
		STOCKS_LOCATION AS SL,
		DEPARTMENT AS D
	WHERE
		SL.DEPARTMENT_ID=D.DEPARTMENT_ID
	<cfif isDefined('attributes.department_id') and len(attributes.department_id)>
		AND  SL.DEPARTMENT_ID=#attributes.department_id#
	</cfif>
	<cfif isDefined('attributes.location_id') and len(attributes.location_id)>
		AND  SL.LOCATION_ID=#attributes.location_id#
	</cfif>

</cfquery>
