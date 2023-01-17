<cfset emp_list = "">
<cfloop index="cc" from="1" to="10">
	<cfif cc eq 1>
    	<cfset emp_list = evaluate("emp_id#cc#")>
    <cfelse>
    	<cfset emp_list = listappend(emp_list,evaluate("emp_id#cc#"))>
    </cfif>
</cfloop>
<cfset emp_list = ListDeleteDuplicates(emp_list)>
<cfloop index="i" from="1" to="#listlen(emp_list)#">  
	<cfif len(evaluate("attributes.emp_id#i#"))>
		<cfset emp_id=evaluate("attributes.emp_id#i#")>
        <cfquery name="add_worker_emp" datasource="#DSN3#">
        	INSERT INTO SERVICE_EMPLOYEES
            (
            	SERVICE_ID,
                EMPLOYEE_ID,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
            	#attributes.service_id#,
                #listgetat(emp_list,i)#,
                #now()#,
                #session.ep.userid#,
                '#cgi.REMOTE_ADDR#'
            )
        </cfquery>
    </cfif>
</cfloop>
<script type="text/javascript">	
	wrk_opener_reload();
	window.close();
</script>
