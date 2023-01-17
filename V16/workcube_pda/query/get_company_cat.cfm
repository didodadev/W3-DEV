<cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
	SELECT 
		DISTINCT
		SP.OUR_COMPANY_ID
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_PERIOD SP,
		EMPLOYEE_POSITION_PERIODS EPP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID AND
		EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
</cfquery>

<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT 
		DISTINCT
		CT.COMPANYCAT_ID, 
		CT.COMPANYCAT
	FROM
		COMPANY_CAT CT,
		COMPANY_CAT_OUR_COMPANY CO
	WHERE
		CT.COMPANYCAT_ID = CO.COMPANYCAT_ID AND
		CO.OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#) 
		<cfif isdefined('session.pda.member_company_cat_id') and len(session.pda.member_company_cat_id)>
			AND CT.COMPANYCAT_ID IN (#session.pda.member_company_cat_id#)
		</cfif>		
	ORDER BY
		COMPANYCAT
</cfquery>

