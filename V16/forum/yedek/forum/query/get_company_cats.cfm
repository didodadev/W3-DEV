<cfquery name="COMPANY_CATS" datasource="#DSN#">
	SELECT
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		COMPANY_CAT
		<cfif isDefined("attributes.comp_ids") and len(Listsort(attributes.comp_ids,'numeric'))>
			WHERE
				COMPANYCAT_ID IN (#Listsort(attributes.comp_ids,'numeric')#)
		</cfif>
	ORDER BY
		COMPANYCAT
</cfquery>	


	
