<cfquery name="GET_CSS_SETTINGS" datasource="#dsn#">
SELECT 
	CS.CSS_ID,
	CS.CSS_NAME,
	CS.RECORD_DATE,
	CS.RECORD_EMP,
	E.EMPLOYEE_NAME,
	E.EMPLOYEE_SURNAME,
	E.EMPLOYEE_ID 
FROM 
	CSS_SETTINGS CS,
	EMPLOYEES E 
WHERE 
	<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee_name)>
		CS.RECORD_EMP = #attributes.employee_id# AND
	</cfif>
	<!--- <cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
		MMS.POSITION_CAT_IDS LIKE '%,#attributes.position_cat_id#,%' AND
	</cfif>
	<cfif isdefined("attributes.user_group_id") and len(attributes.user_group_id)>
		MMS.USER_GROUP_IDS LIKE '%,#attributes.user_group_id#,%' AND
	</cfif>
	MMS.MENU_NAME LIKE '%#attributes.keyword#%' AND 
 --->	
 	CS.RECORD_EMP = E.EMPLOYEE_ID 
	<cfif len(attributes.menu_status)>AND CS.IS_ACTIVE = #attributes.menu_status#</cfif>
</cfquery>
