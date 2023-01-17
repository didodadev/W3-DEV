<cfquery name="DEL_EMP_AUTHORITY_CODES" datasource="#DSN#">
	DELETE FROM EMPLOYEES_AUTHORITY_CODES WHERE POSITION_ID = #attributes.position_id#
</cfquery>
<!--- <cfloop from="1" to="4" index="i"> --->
<cfloop from="1" to="1" index="i">
	<cfquery name="ADD_EMP_AUTHORITY_CODES" datasource="#DSN#">
		INSERT INTO
			EMPLOYEES_AUTHORITY_CODES
        (
            POSITION_ID,
            MODULE_ID,
            AUTHORITY_CODE,
            RECORD_EMP,
            RECORD_IP,
            RECORD_DATE
        )
        VALUES
        (
            #attributes.position_id#,
            #evaluate("attributes.module_id_#i#")#,
            '#wrk_eval("attributes.authority_code_#i#")#',
            #session.ep.userid#,
            '#remote_addr#',
            #now()#
        )
	</cfquery>
</cfloop>

<script type="text/javascript">
	window.close();
</script>
