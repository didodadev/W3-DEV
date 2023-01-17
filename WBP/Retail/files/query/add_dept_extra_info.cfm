<cfloop list="#attributes.branch_id_list#" index="ccc">
	<cfquery name="upd_" datasource="#dsn_dev#">
    	UPDATE
        	BRANCH_EXTRA_INFO
        SET
        	LOCAL_FOLDER = '#evaluate("attributes.local_folder_#ccc#")#'
       	WHERE 
        	BRANCH_ID = #ccc#
    </cfquery>
</cfloop>
<script>
	window.location.href = '<cfoutput>#request.self#?fuseaction=retail.list_department_extra_info</cfoutput>';
</script>