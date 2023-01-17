<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_par_att" datasource="#dsn#">
	SELECT PAR_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND PAR_ID IS NOT NULL AND EMP_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_con_att" datasource="#dsn#">
	SELECT CON_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND CON_ID IS NOT NULL AND PAR_ID IS NULL AND EMP_ID IS NULL
</cfquery>
<!---<cfquery name="get_emp_tra" datasource="#dsn#">
	SELECT EMP_ID FROM TRAINING_CLASS_TRAINER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND GRP_ID IS NULL
</cfquery>
<cfquery name="get_par_tra" datasource="#dsn#">
	SELECT PAR_ID FROM TRAINING_CLASS_TRAINER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND PAR_ID IS NOT NULL AND EMP_ID IS NULL AND GRP_ID IS NULL
</cfquery>
<cfquery name="get_grp_tra" datasource="#dsn#">
	SELECT GRP_ID FROM TRAINING_CLASS_TRAINER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#"> AND GRP_ID IS NOT NULL AND PAR_ID IS NULL AND EMP_ID IS NULL
</cfquery>--->
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
