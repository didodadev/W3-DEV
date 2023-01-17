<cfquery name="MAIN_MENUS" datasource="#DSN#">
    SELECT 
        MMS.*,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        E.EMPLOYEE_ID 
    FROM 
        MAIN_MENU_SETTINGS MMS,
        EMPLOYEES E 
    WHERE 
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee_name)>
            MMS.TO_EMPS LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%,#attributes.employee_id#,%"> AND
        </cfif>
        <cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
            MMS.POSITION_CAT_IDS LIKE  <cfqueryparam cfsqltype="cf_sql_char" value="%,#attributes.position_cat_id#,%"> AND
        </cfif>
        <cfif isdefined("attributes.user_group_id") and len(attributes.user_group_id)>
            MMS.USER_GROUP_IDS LIKE <cfqueryparam cfsqltype="cf_sql_char" value="%,#attributes.user_group_id#,%"> AND
        </cfif>
        (
        	MMS.MENU_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR 
        	MMS.SITE_DOMAIN LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		) AND
        MMS.RECORD_EMP = E.EMPLOYEE_ID 
        <cfif len(attributes.menu_status)> AND MMS.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.menu_status#"></cfif>
    ORDER BY 
        MMS.MENU_NAME
</cfquery>
