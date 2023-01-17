<cfquery name="GET_EMP_INFORM_ATT" datasource="#DSN#">
	SELECT EMP_ID FROM TRAINING_CLASS_INFORM WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="GET_PAR_INFORM_ATT" datasource="#DSN#">
	SELECT PAR_ID FROM TRAINING_CLASS_INFORM WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND PAR_ID IS NOT NULL AND EMP_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="GET_CON_INFORM_ATT" datasource="#DSN#">
	SELECT CON_ID FROM TRAINING_CLASS_INFORM WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND CON_ID IS NOT NULL AND PAR_ID IS NULL AND EMP_ID IS NULL
</cfquery>
<cfset att_inform_list = ''>
<cfif get_emp_inform_att.recordcount>
	<cfloop query="get_emp_inform_att">
		<cfset att_inform_list = listappend(att_inform_list,"inf_emp-#get_emp_inform_att.EMP_ID#",",")>
	</cfloop>
</cfif>
<cfif get_par_inform_att.recordcount>
	<cfloop query="get_par_inform_att">
		<cfset att_inform_list = listappend(att_inform_list,"inf_par-#get_par_inform_att.PAR_ID#",",")>
	</cfloop>
</cfif>
<cfif get_con_inform_att.recordcount>
	<cfloop query="get_con_inform_att">
		<cfset att_inform_list = listappend(att_inform_list,"inf_con-#get_con_inform_att.CON_ID#",",")>
	</cfloop>
</cfif>
