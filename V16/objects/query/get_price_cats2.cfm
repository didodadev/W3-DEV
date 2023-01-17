<cfquery name="GET_EMP_POSITION_CAT_ID" datasource="#DSN#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
</cfquery>
<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
	SELECT
		PRICE_CATID,
        PRICE_CAT
	FROM
		PRICE_CAT
	WHERE 
		<!--- Pozisyon tipine gore yetki veriliyor  --->
		POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
		<!--- //Pozisyon tipine gore yetki veriliyor  --->
	ORDER BY
		PRICE_CAT
</cfquery>
