<cfquery name="get_tax_exc" datasource="#dsn#">
	SELECT 
		TE.* 
	FROM 
		TAX_EXCEPTION TE
	WHERE
		1 = 1
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
			AND TAX_EXCEPTION LIKE '%#attributes.KEYWORD#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
		</cfif>
		<cfif isDefined("attributes.status") and len(attributes.status)>
			AND STATUS = #attributes.status#
		</cfif>
</cfquery>
