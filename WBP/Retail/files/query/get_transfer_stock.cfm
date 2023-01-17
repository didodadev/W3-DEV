<cfquery name="get_" datasource="#dsn_Dev#">
    SELECT
        STOCK_ID,
        DEPARTMENT_ID
    FROM
        STOCK_TRANSFER_LIST
    WHERE
        STOCK_ID = #attributes.stock_id# AND
        DEPARTMENT_ID = #attributes.department_id#
</cfquery>
<cfoutput>
	<cfif get_.recordcount>
        <a href="javascript://" onclick="manage_s_tranfer_row('#attributes.stock_id#','#attributes.DEPARTMENT_ID#');"><img src="/images/update_list.gif" /></a>
    <cfelse>
        <a href="javascript://" onclick="manage_s_tranfer_row('#attributes.stock_id#','#attributes.DEPARTMENT_ID#');"><img src="/images/plus_list.gif" /></a>
    </cfif>
</cfoutput>