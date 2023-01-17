<cfquery name="GET_SCENARIO" datasource="#dsn#">
	SELECT
        #dsn#.Get_Dynamic_Language(SCENARIO_ID,'#session.ep.language#','SETUP_SCENARIO','SCENARIO',NULL,NULL,SCENARIO) AS SCENARIO,
        #dsn#.Get_Dynamic_Language(SCENARIO_ID,'#session.ep.language#','SETUP_SCENARIO','SCENARIO_DETAIL',NULL,NULL,SCENARIO_DETAIL) AS SCENARIO_DETAIL,
		*,
		'' UPDATE_DATE,
		'' UPDATE_EMP
	FROM
		SETUP_SCENARIO
	WHERE
		SCENARIO_ID=#attributes.id#
</cfquery>
<cfquery name="GET_SCE_ID" datasource="#dsn3#">
	SELECT
		SCENARIO_TYPE_ID
	FROM
		SCEN_EXPENSE_PERIOD
	WHERE
		SCENARIO_TYPE_ID=#attributes.id#
</cfquery>
<cf_catalystHeader>
<cf_box>
    <cfform name="add_note" action="#request.self#?fuseaction=finance.emptypopup_upd_scenario" method="post">
        <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-scenario_head">
                    <label class="col col-3 col-xs-12"><cfoutput>#getLang('main',68)#</cfoutput> *</label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="scenario_head" required="yes" maxlength="100" value="#get_scenario.scenario#">
                            <span class="input-group-addon">
                                <cf_language_info 
                                table_name="SETUP_SCENARIO" 
                                column_name="SCENARIO" 
                                column_id_value="#attributes.id#" 
                                maxlength="500" 
                                datasource="#dsn#" 
                                column_id="SCENARIO_ID" 
                                control_type="0">
                            </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-3 col-xs-12"><cfoutput>#getLang('main',217)#</cfoutput></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <textarea name="detail" id="detail" rows="5"><cfoutput>#get_scenario.scenario_detail#</cfoutput></textarea>
                            <span class="input-group-addon">
                                <cf_language_info 
                                table_name="SETUP_SCENARIO" 
                                column_name="SCENARIO_DETAIL" 
                                column_id_value="#attributes.id#" 
                                maxlength="500" 
                                datasource="#dsn#" 
                                column_id="SCENARIO_ID" 
                                control_type="0">
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name = "get_scenario">
            </div>
            <div class="col col-6">
                <cfif get_sce_id.recordcount>
                    <cf_workcube_buttons is_upd='1' is_delete='0'>
                <cfelse>
                    <cf_workcube_buttons 
                        is_upd='1' add_function='kontrol()'
                        delete_page_url='#request.self#?fuseaction=finance.emptypopup_del_scenario&id=#get_scenario.scenario_id#&detail=#get_scenario.scenario_detail#'> 
                </cfif>
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol(){
	if(!$("#scenario_head").val().length)
	{
		alertObject({message: '<cfoutput>#getLang('hr',1206)#</cfoutput>' })    
		return false;
	}
}
</script>             
