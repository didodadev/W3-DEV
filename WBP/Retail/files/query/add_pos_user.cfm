<cfquery name="add_" datasource="#dsn_dev#">
	INSERT INTO
    	POS_USERS
        (
        EMPLOYEE_ID,
        BRANCH_ID,
        USERNAME,
        PASSWORD,
        POS_TYPE,
        EMPLOYEE_STATUS,
        RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
        )
        VALUES
        (
        #attributes.employee_id#,
        #attributes.branch_id#,
        '#attributes.username#',
        '#attributes.password#',
        #attributes.pos_type#,
        <cfif isdefined("attributes.employee_status")>1<cfelse>0</cfif>,
        #session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#'
        )
</cfquery>
<script type="text/javascript">
    window.location.href ="<cfoutput>#request.self#?fuseaction=retail.list_pos_users</cfoutput>";
</script>