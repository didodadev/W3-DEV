<cfif isDefined("session.pda.user_location") and ListLen(session.pda.user_location,'-') eq 3>
	<cfif not (isDefined("attributes.department_id") and Len(attributes.department_id))><cfset attributes.department_id = ListGetAt(session.pda.user_location,1,'-')></cfif>
	<cfif not (isDefined("attributes.branch_id") and Len(attributes.branch_id))><cfset attributes.branch_id = ListGetAt(session.pda.user_location,2,'-')></cfif>
	<cfif not (isDefined("attributes.location_id") and Len(attributes.location_id))><cfset attributes.location_id = ListGetAt(session.pda.user_location,3,'-')></cfif>
	<cfif not (isDefined("attributes.department_location") and Len(attributes.department_location))><cfset attributes.department_location = ""></cfif>
<cfelse>
	<cfif not (isDefined("attributes.department_id") and Len(attributes.department_id))><cfset attributes.department_id = ""></cfif>
	<cfif not (isDefined("attributes.branch_id") and Len(attributes.branch_id))><cfset attributes.branch_id = ""></cfif>
	<cfif not (isDefined("attributes.location_id") and Len(attributes.location_id))><cfset attributes.location_id = ""></cfif>
	<cfif not (isDefined("attributes.department_location") and Len(attributes.department_location))><cfset attributes.department_location = ""></cfif>
</cfif>
<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
	<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
		SELECT DEPARTMENT_HEAD,BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND IS_STORE <> 2 AND BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">)
	</cfquery>
	<cfif get_department.recordcount><cfset attributes.department_name = get_department.department_head><cfelse><cfset attributes.department_name = ""></cfif>
</cfif>
<cfif isDefined("attributes.location_id") and Len(attributes.location_id)>
	<cfquery name="GET_LOCATION" datasource="#DSN#">
		SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"><cfif isDefined("attributes.department_id") and Len(attributes.department_id)>AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"></cfif>
	</cfquery>
	<cfif get_location.recordcount><cfset attributes.location_name = get_location.comment><cfelse><cfset attributes.location_name = ""></cfif>
</cfif>
<cfif isDefined("attributes.department_name") and Len(attributes.department_name) and isDefined("attributes.location_name") and Len(attributes.location_name)>
	<cfset attributes.department_location = "#attributes.department_name# - #attributes.location_name#">
</cfif>
