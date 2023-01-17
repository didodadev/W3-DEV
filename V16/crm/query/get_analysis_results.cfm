<cfquery name="GET_ANALYSIS_RESULTS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		MEMBER_ANALYSIS_RESULTS
	WHERE 1=1 
		<cfif isdefined("attributes.cpid")>
			AND CONSUMER_ID IN (
					SELECT 
						COMPANY_PARTNER.PARTNER_ID
					FROM
						COMPANY_PARTNER,
						COMPANY
					WHERE
						COMPANY.COMPANY_ID = #attributes.cpid# AND
					COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
				)
		<cfelseif isDefined("attributes.ANALYSIS_ID") and len(attributes.ANALYSIS_ID)>
			AND ANALYSIS_ID=  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ANALYSIS_ID#"> 
		</cfif>
	ORDER BY
		USER_POINT DESC
</cfquery>		
