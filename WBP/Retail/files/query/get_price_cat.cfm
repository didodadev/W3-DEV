<cfquery name="GET_EMP_POSITION_CAT_ID" datasource="#DSN#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
</cfquery>
<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		PRICE_CAT
	WHERE
		PRICE_CATID IS NOT NULL AND
		PRICE_CAT_STATUS = 1
	<cfif fusebox.circuit is 'store'>
		AND BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
	</cfif>
	<cfif isDefined("attributes.pcat_id") and len(attributes.pcat_id)>
		AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#">
	</cfif>
	<!--- Pozisyon tipine gore yetki veriliyor  --->
	<cfif isDefined("xml_related_position_cat") and xml_related_position_cat eq 1>
		AND CAST(POSITION_CAT AS NVARCHAR) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
	</cfif>
	<!--- //Pozisyon tipine gore yetki veriliyor  --->
	ORDER BY
		PRICE_CAT
</cfquery>