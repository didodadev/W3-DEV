<cfif isDefined('sayfa_ad') and isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfquery name="get_emps" datasource="#dsn#">
		SELECT 
			DISTINCT POSITION_CODE
		FROM 
			EMPLOYEE_POSITIONS
		WHERE 
			(EMPLOYEE_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI) AND
			POSITION_STATUS = 1
	</cfquery>
</cfif>
<cfquery name="productcats" datasource="#dsn1#">
	SELECT
		#dsn#.Get_Dynamic_Language(PRODUCT_CATID,'#session.ep.language#','PRODUCT_CAT','PRODUCT_CAT',NULL,NULL,PRODUCT_CAT) AS PRODUCT_CAT,
		*
	FROM
		PRODUCT_CAT
	WHERE 
		PRODUCT_CATID IS NOT NULL
	<cfif isDefined('attributes.cat') and len(attributes.cat)>
		AND HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#%">
	</cfif>
	<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		AND ((PRODUCT_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
		<cfif isDefined('sayfa_ad') and GET_EMPS.RecordCount>
			OR POSITION_CODE IN (#ValueList(GET_EMPS.POSITION_CODE)#)
			OR POSITION_CODE2 IN (#ValueList(GET_EMPS.POSITION_CODE)#)
		</cfif>
		)
	</cfif>
	<cfif isDefined('attributes.class_category')>
		AND HIERARCHY NOT LIKE '%.%'
	</cfif>
	<cfif isdefined("attributes.our_company") and len(attributes.our_company)>
		AND PRODUCT_CATID IN (SELECT PRODUCT_CATID FROM PRODUCT_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID = #attributes.our_company#)
	</cfif>
	<cfif len(attributes.show)>
		<cfif attributes.show eq 1>
			AND IS_PUBLIC = 1
		<cfelseif attributes.show eq 2>	
			AND IS_CASH_REGISTER = 1
		<cfelseif attributes.show eq 3>
			AND IS_CUSTOMIZABLE = 1
		</cfif>
	</cfif>
	ORDER BY 
		HIERARCHY
</cfquery>
