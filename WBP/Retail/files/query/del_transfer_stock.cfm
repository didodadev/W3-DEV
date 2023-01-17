<cfif isdefined("attributes.row_id") and len(attributes.row_id)>
    <cfquery name="add_" datasource="#dsn_dev#">
        DELETE FROM
            STOCK_TRANSFER_LIST
        WHERE
            ROW_ID = #attributes.row_id#
    </cfquery>
</cfif>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
    <cfquery name="add_" datasource="#dsn_dev#">
        DELETE FROM
            STOCK_TRANSFER_LIST
        WHERE
            DEPARTMENT_ID = #attributes.department_id#
    </cfquery>
</cfif>
<script>
	window.opener.location.reload();
	window.close();
</script>
