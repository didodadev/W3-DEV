<cfquery name="DEL_" datasource="#dsn_dev#">
	DELETE  FROM SEARCH_TABLES_LAYOUTS_USERS WHERE USER_ID = #session.ep.userid#
</cfquery>

<cfquery name="add_" datasource="#dsn_dev#">
	INSERT INTO
    	SEARCH_TABLES_LAYOUTS_USERS
        (
        USER_ID,
        LAYOUT_ID
        )
        VALUES
        (
        #session.ep.userid#,
        #attributes.layout_id#
        )
</cfquery>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=retail.table_spe_user</cfoutput>";
</script>