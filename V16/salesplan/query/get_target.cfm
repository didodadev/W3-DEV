<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT 
		T.*,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EP.EMPLOYEE_ID,
		EP.POSITION_CODE 
	FROM 
		TARGET AS T,
		EMPLOYEE_POSITIONS AS EP
	WHERE 
		TARGET_ID = #attributes.TARGET_ID#
		AND T.POSITION_CODE = EP.POSITION_CODE
		<cfif isDefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
		AND EP.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfif>
		<cfif isDefined("attributes.POSITION_CODE") and len(attributes.POSITION_CODE)>
		AND EP.POSITION_CODE = #attributes.POSITION_CODE#
		</cfif>
</cfquery>
