<cfquery name="FIS" datasource="#dsn2#">
	SELECT
		*
	FROM
		STOCK_FIS,
	WHERE
	FIS_ID IS NOT NULL
	<cfif len(attributes.keyword)>
		AND 
		FIS_NUMBER LIKE '%#attributes.keyword#%' 
	</cfif>
	<cfif len(attributes.cat)>
		AND FIS_TYPE =#attributes.cat#
	</cfif>		
	<cfif attributes.department_id neq 0>
		AND 
		(
		DEPARTMENT_IN=#attributes.department_id#
		OR 
		DEPARTMENT_OUT=#attributes.department_id#
		)
	</cfif>
	
</cfquery>
