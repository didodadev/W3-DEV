<cfif isDefined("attributes.keyword") and len(attributes.keyword) and Isdefined("attributes.isSpecial") and attributes.isSpecial>
	<cfquery name="CONTRACTLIST2" datasource="#dsn3#">
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
	</cfquery>
	<cfset attributes.comp_Ids = ValueList(contractlist2.company,',')>
<cfelseif  Isdefined("attributes.isSpecial") and attributes.isSpecial>
	<cfset attributes.comp_Ids = '-1'>
</cfif>

<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY_ID,
		NICKNAME,
		FULLNAME
	FROM 
		COMPANY
	WHERE 
		COMPANY_ID IN (#ListSort(attributes.comp_ids,'numeric')#)
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND 
			NICKNAME LIKE '%#attributes.keyword#%'
	</cfif>		
</cfquery>


