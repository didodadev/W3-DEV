<cfsetting showdebugoutput="no">
<cfquery name="process_list" datasource="#DSN#">
    SELECT
        PTR.STAGE,
        PTR.PROCESS_ROW_ID
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PTR.PROCESS_ID = PT.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        <cfif attributes.is_demand eq 1>
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_purchasedemand%">
        <cfelse>
            <cfif attributes.list_type eq 2>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.popup_add_project%">
            <cfelse>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_internaldemand%">
            </cfif>
        </cfif>
        <cfif isdefined("attributes.Process_RowId_List") and  ListLen(attributes.Process_RowId_List)>
            AND PTR.PROCESS_ROW_ID IN (#attributes.Process_RowId_List#)
        </cfif>
</cfquery>
<select name="internaldemand_stage" id="internaldemand_stage" style="width:150px;">
    <option value=""><cf_get_lang_main no='642.Süreç'></option>
    <cfoutput query="process_list">
        <option value="#process_row_id#">#stage#</option>
    </cfoutput>
</select>

