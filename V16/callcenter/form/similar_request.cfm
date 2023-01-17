<cfquery name="GET_HELP" datasource="#DSN#">
	SELECT
		DETAIL,
		COMPANY_ID,
		CONSUMER_ID
    FROM
		CUSTOMER_HELP
	WHERE
		CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
</cfquery>

<cfquery name="GET_DETAIL" datasource="#DSN#">
    SELECT TOP 20 
        CUS_HELP_ID,
        DETAIL
    FROM
        CUSTOMER_HELP
    WHERE
    <cfif len(get_help.company_id)>
        COMPANY_ID = #get_help.company_id# AND
    <cfelseif len(get_help.consumer_id)>
        CONSUMER_ID = #get_help.consumer_id# AND
    </cfif>
        DETAIL  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_help.detail#"> AND
        SOLUTION_DETAIL IS NOT NULL AND
        CUS_HELP_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
</cfquery>
<cf_ajax_list>
    <thead>
        <tr>
            <th><cf_get_lang_main no="68.Konu"></th>
        </tr>
    </thead>	
    <cfif get_detail.recordcount>
        <cfoutput query="get_detail"> 
            <tr>
                <td>
                    <a target="_blank" href="#request.self#?fuseaction=call.helpdesk&event=upd&cus_help_id=#get_detail.cus_help_id#">#detail#</a>
                </td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</cf_ajax_list>
