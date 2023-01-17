<cfquery name="add_emp_announce" datasource="#dsn#">
    INSERT INTO
        TRAINING_CLASS_TRAINERS
        (
            CLASS_ID,
            EMP_ID,
            PAR_ID,
            CONS_ID,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
        )
    VALUES
        (
            #attributes.class_id#,
            <cfif len(attributes.emp_id)>
            	#attributes.emp_id#,
                NULL,
                NULL,
            <cfelseif len(attributes.par_id)>
                NULL,
            	#attributes.par_id#,
                NULL,
            <cfelseif len(attributes.cons_id)>
                NULL,
                NULL,
            	#attributes.cons_id#,
           </cfif>
           #session.ep.userid#,
           #now()#,
           '#cgi.REMOTE_ADDR#'
        )	
</cfquery>
<script type="text/javascript">
location.href=document.referrer
	wrk_opener_reload();
	window.close();
</script>
