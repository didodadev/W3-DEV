<cf_get_lang_set_main>
<cfset lang_array_main = variables.lang_array_main>
<cfparam name="faction" default="">
<cfif isdefined("attributes.output_template") and attributes.output_template eq 1>
    <cfquery name="get_fus" datasource="#dsn#">
        SELECT RELATED_WO, WRK_OUTPUT_TEMPLATE_NAME FROM WRK_OUTPUT_TEMPLATES WHERE WRK_OUTPUT_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
    <cfset faction = get_fus.RELATED_WO>
    <cfsavecontent  variable="head"><cfoutput>#get_fus.WRK_OUTPUT_TEMPLATE_NAME#</cfoutput> : <cf_get_lang dictionary_id="52734.WO"></cfsavecontent>
<cfelseif isdefined("attributes.process_template") and attributes.process_template eq 1>
    <cfquery name="get_fus" datasource="#dsn#">
        SELECT RELATED_WO, WRK_PROCESS_TEMPLATE_NAME FROM WRK_PROCESS_TEMPLATES WHERE WRK_PROCESS_TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
    <cfset faction = get_fus.RELATED_WO>
    <cfsavecontent  variable="head"><cfoutput>#get_fus.WRK_PROCESS_TEMPLATE_NAME#</cfoutput> : <cf_get_lang dictionary_id="52734.WO"></cfsavecontent>
<cfelse>
    <cfquery name="get_fus" datasource="#dsn#">
        SELECT FACTION, PROCESS_NAME FROM PROCESS_TYPE WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfquery>
    <cfset faction = get_fus.FACTION>
    <cfsavecontent  variable="head"><cfoutput>#get_fus.PROCESS_NAME#</cfoutput> : <cf_get_lang dictionary_id="52734.WO"></cfsavecontent>
</cfif>  
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">        
    <cf_box title="#head#" closable="1" resize="0" collapsable="0" draggable="1">
        <cf_flat_list>
            <thead>
                <th><cf_get_lang dictionary_id="52734.WO"></th>
                <th><cf_get_lang dictionary_id="36185.Fuseaction"></th>
                <th><cf_get_lang dictionary_id="57630.Tip"></th>
            </thead>
            <tbody>
                <cfif len(faction)>
                    <cfset fuseactions=listToArray(faction)>
                    <cfloop array="#fuseactions#" index="i">
                        <cfquery name="GET_FUSEACTIONS" datasource="#dsn#">
                            SELECT HEAD, FULL_FUSEACTION, TYPE FROM WRK_OBJECTS WHERE FULL_FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(i)#%">
                        </cfquery>
                        <cfoutput query="GET_FUSEACTIONS">
                            <tr>
                                <td>#head#</td>
                                <td>#FULL_FUSEACTION#</td>
                                <td>
                                    <cfif type eq 0><cf_get_lang dictionary_id="52708.WBO"></cfif>
                                    <cfif type eq 13><cf_get_lang dictionary_id="55731.Dashboard"></cfif>
                                    <cfif type eq 8><cf_get_lang dictionary_id="52714.Report"></cfif>
                                    <cfif type eq 9><cf_get_lang dictionary_id="29954.General"></cfif>
                                    <cfif type eq 1><cf_get_lang dictionary_id="222.Param"></cfif>
                                    <cfif type eq 2><cf_get_lang dictionary_id="47646.System"></cfif>
                                    <cfif type eq 3><cf_get_lang dictionary_id="58641.Import"></cfif>
                                    <cfif type eq 12><cf_get_lang dictionary_id="29742.Export"></cfif>
                                    <cfif type eq 4><cf_get_lang dictionary_id="51459.Period"></cfif>
                                    <cfif type eq 5><cf_get_lang dictionary_id="40691.Maintenance"></cfif>
                                    <cfif type eq 6><cf_get_lang dictionary_id="60175.Utility"></cfif>
                                    <cfif type eq 7><cf_get_lang dictionary_id="47614.Dev"></cfif>
                                    <cfif type eq 10><cf_get_lang dictionary_id="60687.Child"> <cf_get_lang dictionary_id="52734.WO"></cfif>
                                    <cfif type eq 11><cf_get_lang dictionary_id="60688.Query-Backend"></cfif>
                                </td>
                            </tr>
                        </cfoutput>
                    </cfloop>
                <cfelse>
                    <tr><td colspan="3"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td></tr>
                </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>