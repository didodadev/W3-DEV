<cfquery name="GET_MY_COMPANY" datasource="#dsn#">
	SELECT DISTINCT
		C.COMPANY_ID AS COMPANY_ID,
		C.FULLNAME,
		C.NICKNAME,
		C.MANAGER_PARTNER_ID AS MANAGER_PARTNER_ID,	
		WEP.POSITION_CODE POSITION_CODE,
		WEP.ROLE_ID,
		WEP.IS_MASTER,
		'COMPANY' AS TYPE
	FROM
		COMPANY C,
		WORKGROUP_EMP_PAR WEP
	WHERE
		(
			C.COMPANY_ID = WEP.COMPANY_ID  AND 
			WEP.COMPANY_ID IS NOT NULL AND
			WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		)
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
UNION ALL
	SELECT 
		CR.CONSUMER_ID AS COMPANY_ID,
		CR.CONSUMER_NAME AS FULLNAME,
		CR.COMPANY NAME,		
		CR.HIERARCHY_ID AS MANAGER_PARTNER_ID, <!--- bu alan sadece union eleman sayısı eşit olsun diye koyuldu silmeyin --->
		WEP.POSITION_CODE POSITION_CODE,
		WEP.ROLE_ID,
		WEP.IS_MASTER,
		'CONSUMER' AS TYPE
	FROM
		CONSUMER CR,
		WORKGROUP_EMP_PAR WEP
	WHERE
		CR.CONSUMER_ID = WEP.CONSUMER_ID AND
		WEP.CONSUMER_ID IS NOT NULL AND
		WEP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
		WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		   (
		   CR.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
		   CR.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
		   CR.COMPANY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		   )
		</cfif> 
	ORDER BY FULLNAME
</cfquery>
