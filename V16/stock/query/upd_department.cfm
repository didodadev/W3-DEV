<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.department_head=replacelist(attributes.department_head,list,list2)>
<cfif isDefined('attributes.department_id') and len(attributes.department_id)>
	<cfquery name="UPD_DEPARTMENT" datasource="#DSN#">
		UPDATE 
			DEPARTMENT
		SET
			BRANCH_ID = #attributes.branch_id#,
			DEPARTMENT_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.department_head#">,
			DEPARTMENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.department_detail,100)#">,
		  <cfif len(POS_ID2)>
			ADMIN2_POSITION_CODE = #attributes.pos_id2#,
		  </cfif>
			ADMIN1_POSITION_CODE = #attributes.pos_id#,
			DEPARTMENT_STATUS = <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			DEPARTMENT_ID = #attributes.department_id#
	</cfquery>
    <cf_wrk_get_history datasource="#dsn#" source_table="DEPARTMENT" target_table="DEPARTMENT_HISTORY" record_id= "#attributes.department_id#" record_name="DEPARTMENT_ID">
</cfif>
<cfset attributes.actionId = attributes.department_id >
<script type="text/javascript">
	location.href = document.referrer;
	self.close();
</script>
