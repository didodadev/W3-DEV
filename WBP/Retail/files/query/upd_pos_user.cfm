<cfquery name="add_" datasource="#dsn_dev#">
	UPDATE
    	POS_USERS
    SET
        EMPLOYEE_ID = #attributes.employee_id#,
        BRANCH_ID = #attributes.branch_id#,
        USERNAME = '#attributes.username#',
        PASSWORD = '#attributes.password#',
        POS_TYPE = #attributes.pos_type#,
        EMPLOYEE_STATUS = <cfif isdefined("attributes.employee_status")>1<cfelse>0</cfif>,
        UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
   WHERE
   		ROW_ID = #attributes.row_id#
</cfquery>
<script type="text/javascript">
    window.location.href ="<cfoutput>#request.self#?fuseaction=retail.list_pos_users</cfoutput>";
</script>