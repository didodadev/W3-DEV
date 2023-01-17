<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		COMPANY.*,
		COMPANY_CAT.COMPANYCAT 
	FROM 
		COMPANY,
		COMPANY_CAT
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
</cfquery>
<cfquery name="GET_MANAGER" datasource="#dsn#">
	SELECT 
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE 
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND 
		CP.COMPANY_ID = C.COMPANY_ID AND
		CP.PARTNER_ID = C.MANAGER_PARTNER_ID
	ORDER BY
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME
</cfquery>
<cfquery name="GET_COMPANY_SECTOR" datasource="#dsn#">
	SELECT
   		SECTOR_CAT		
	FROM 
		COMPANY,
		SETUP_SECTOR_CATS 
	WHERE
		COMPANY.SECTOR_CAT_ID = SETUP_SECTOR_CATS.SECTOR_CAT_ID AND
		COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
</cfquery>
<cfquery name="GET_COMPANY_SIZE" datasource="#dsn#">
	SELECT 
		COMPANY_SIZE_CAT
    FROM 
	   COMPANY,
	   SETUP_COMPANY_SIZE_CATS
	WHERE
	   COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
	   SETUP_COMPANY_SIZE_CATS.COMPANY_SIZE_CAT_ID = COMPANY.COMPANY_SIZE_CAT_ID
</cfquery>
<cfquery name="GET_EMPLOYEE_POSITIONS" datasource="#dsn#">
	SELECT 
  		EP.POSITION_CODE, 
		EP.EMPLOYEE_NAME, 
		EP.EMPLOYEE_SURNAME 
	FROM 
		WORKGROUP_EMP_PAR WEP,
		EMPLOYEE_POSITIONS EP
	WHERE
		WEP.COMPANY_ID IS NOT NULL AND
		WEP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		EP.POSITION_CODE = WEP.POSITION_CODE AND 
		EP.POSITION_STATUS = 1 AND
		WEP.IS_MASTER = 1 AND
		WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif len(get_company.hierarchy_id)>
	<cfquery name="GET_UPPER_COMPANY" datasource="#dsn#">
	   SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.hierarchy_id#">
	</cfquery>
</cfif>

