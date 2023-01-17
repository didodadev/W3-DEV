<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT EMP_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#"> AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_par_att" datasource="#dsn#">
	SELECT PAR_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#"> AND PAR_ID IS NOT NULL AND EMP_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_con_att" datasource="#dsn#">
	SELECT CON_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#"> AND CON_ID IS NOT NULL AND PAR_ID IS NULL AND EMP_ID IS NULL
</cfquery>
<cfset att_list = ''>
<cfif get_emp_att.RECORDCOUNT>
	<cfloop query="get_emp_att">
		<cfset att_list = listappend(att_list,"emp-#get_emp_att.EMP_ID#",",")>
	</cfloop>
</cfif>
<cfif get_par_att.RECORDCOUNT>
	<cfloop query="get_par_att">
		<cfset att_list = listappend(att_list,"par-#get_par_att.PAR_ID#",",")>
	</cfloop>
</cfif>
<cfif get_con_att.RECORDCOUNT>
	<cfloop query="get_con_att">
		<cfset att_list = listappend(att_list,"con-#get_con_att.CON_ID#",",")>
	</cfloop>
</cfif>
