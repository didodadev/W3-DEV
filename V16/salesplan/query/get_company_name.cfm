<cfif len(attributes.COMPANY_ID)>
	<cfquery name="GET_COMPANY_NAME" datasource="#dsn#">
		SELECT 
			COMPANY_ID,
			FULLNAME,
			NICKNAME
		FROM 
			COMPANY
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.COMPANY_ID#">
	</cfquery>
</cfif>
