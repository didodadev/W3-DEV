	<cfquery name="GET_BRANCHE_NAME" datasource="#dsn#">
		SELECT 
			BRANCH_ID, 
			BRANCH_NAME 
		FROM 
			BRANCH
		WHERE 
			BRANCH_ID = #attributes.BRANCH_ID#
	</cfquery>
