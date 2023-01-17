<cfquery name="GET_EMP_POSITION_CAT_ID" datasource="#DSN#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
</cfquery>
<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
	SELECT 
		PRICE_CATID,
		#dsn#.Get_Dynamic_Language(PRICE_CATID,'#session.ep.language#','PRICE_CAT','PRICE_CAT',NULL,NULL,PRICE_CAT) AS PRICE_CAT
	FROM 
		PRICE_CAT 
	WHERE 
		PRICE_CAT_STATUS = 1 
		<!--- Pozisyon tipine gore yetki veriliyor  --->
		<cfif isDefined("xml_related_position_cat") and xml_related_position_cat eq 1>
			AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
		</cfif>
		<!--- //Pozisyon tipine gore yetki veriliyor  --->
	ORDER BY 
		PRICE_CAT
</cfquery>

