<cfquery name="CONTRACTLIST" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		CONTRACT
	WHERE 
		OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
		<cfif attributes.is_active is 2>
			AND STATUS IN (0,1)
		<cfelse>
			AND STATUS = #attributes.is_active#
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND CONTRACT_HEAD LIKE '%#attributes.keyword#%'
			<cfloop query="GET_COMPANY">	
			OR COMPANY LIKE '%,#COMPANY_ID#,%'
			</cfloop>
		</cfif>
</cfquery>
