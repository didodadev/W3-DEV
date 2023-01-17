<cfquery name="GET_PRO_WORKS" datasource="#DSN#">
    SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#"> AND CUS_HELP_ID IS NOT NULL
</cfquery>
<cfquery name="GET_CALL_SERVICE" datasource="#DSN#">
    SELECT SERVICE_ID,SERVICE_HEAD FROM G_SERVICE WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#"> AND CUS_HELP_ID IS NOT NULL
</cfquery>
<cfquery name="GET_SERVICE" datasource="#DSN3#">
    SELECT SERVICE_ID,SERVICE_HEAD FROM SERVICE WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#"> AND CUS_HELP_ID IS NOT NULL
</cfquery>
<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
    SELECT OPP_ID,OPP_HEAD FROM OPPORTUNITIES WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#"> AND CUS_HELP_ID IS NOT NULL
</cfquery>
<cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
    SELECT 
        EVENT_PLAN.EVENT_PLAN_ID,
        EVENT_PLAN.event_plan_head,
        EVENT_PLAN_ROW.*,
        CUSTOMER_HELP.EVENT_PLAN_ROW_ID,
        CUSTOMER_HELP.CUS_HELP_ID
    FROM
        EVENT_PLAN ,
        EVENT_PLAN_ROW,
        CUSTOMER_HELP 
      WHERE
        EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
        <cfif len(attributes.event_plan_row_id)>EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#"> AND</cfif> 
        CUSTOMER_HELP.CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#"> AND CUS_HELP_ID IS NOT NULL
</cfquery>
<cf_ajax_list>
    <tbody>
        <cfif get_pro_works.recordcount or get_call_service.recordcount or get_service.recordcount or get_opportunity.recordcount or GET_EVENT_PLAN.recordcount and len(attributes.event_plan_row_id)>
            <tr>
                <td>
                    <cfif get_pro_works.recordcount>
                        <strong><cf_get_lang no='43.İşler/Görevler'></strong><br>
                        <cfoutput query="get_pro_works">
                            <a href="#request.self#?fuseaction=project.works&event=det&id=#work_id#" class="tableyazi">#work_head#</a><br />
                        </cfoutput>
                        <br>
                    </cfif>
                    <cfif get_call_service.recordcount>
                        <strong><cf_get_lang_main no='1056.Call Center Başvuruları'></strong><br>
                        <cfoutput query="get_call_service">
                            <a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#get_call_service.service_id#" class="tableyazi" target="_blank">#service_head#</a><br />
                        </cfoutput>
                        <br>
                    </cfif>
                    <cfif get_service.recordcount>
                        <strong><cf_get_lang no='44.Servis İşlemleri'></strong><br>
                        <cfoutput query="get_service">
                            <a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service.service_id#" class="tableyazi" target="_blank">#service_head#</a><br />
                        </cfoutput>
                        <br>
                    </cfif>
                    <cfif get_opportunity.recordcount>
                        <strong><cf_get_lang_main no='1282.Fırsatlar'></strong><br>
                        <cfoutput query="get_opportunity">
                            <a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#get_opportunity.opp_id#" class="tableyazi" target="_blank">#opp_head#</a><br />
                        </cfoutput>
                        <br>
                    </cfif>
                    <cfif GET_EVENT_PLAN.recordcount>
                        <cfoutput query="GET_EVENT_PLAN">
                            <a href="#request.self#?fuseaction=sales.list_visit&event=upd&visit_id=#GET_EVENT_PLAN.event_plan_id#" class="tableyazi" target="_blank">#event_plan_head#</a><br />
                        </cfoutput>
                    </cfif>
                </td>
            </tr>
        <cfelse> 
            <tr>
                <td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
