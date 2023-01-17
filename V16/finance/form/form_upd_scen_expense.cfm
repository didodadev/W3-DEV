<cfparam name="attributes.modal_id" default="">

<cfinclude template="../query/get_scen_expense_detail.cfm">
<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="box_counter" title="#iif(isDefined("attributes.draggable"),"getLang('','Gelir Gider Detay',32824)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
        <cfform name="upd_expense" method="post" action="#request.self#?fuseaction=finance.emptypopup_upd_scen_expense">
            <cf_box_elements>
                <input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>" />
                <div class="col col-6 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-scen_expense_status">
                        <label class="col col-12">
                            <cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'>
                            <input type="checkbox" name="scen_expense_status" id="scen_expense_status" <cfif detail.scen_expense_status eq 1>checked</cfif>>
                        </label>
                    </div>
                    <div class="form-group" id="item-extype">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="extype" id="extype" style="width:150px;">
                                <option value="0" <cfif detail.type eq 0>selected</cfif>><cf_get_lang dictionary_id='58678.Gider'></option>
                                <option value="1" <cfif detail.type eq 1>selected</cfif>><cf_get_lang dictionary_id='58677.Gelir'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-scenario_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54557.Senaryo Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfquery name="GET_SETUP_SCENARIO" datasource="#DSN#">
                                SELECT SCENARIO_ID,SCENARIO FROM SETUP_SCENARIO
                            </cfquery>
                            <select name="scenario_type" id="scenario_type" style="width:150px;">
                                <option value="0"><cf_get_lang dictionary_id='54557.Senaryo Tipi'></option>
                                <cfoutput query="get_setup_scenario">
                                    <option value="#get_setup_scenario.scenario_id#"<cfif get_setup_scenario.scenario_id eq detail.scenario_type_id>selected</cfif>>#scenario#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='33337.Açıklama Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="detail" value="#detail.period_detail#" required="yes" message="#message#" maxlength="50" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
                                <cfinput value="#dateformat(detail.START_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="startdate" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"><cf_get_lang dictionary_id='56019.İtibaren'></span>
                            </div>
                        </div>
                    </div>
                    <cfquery name="get_project" datasource="#dsn3#">
                    SELECT 
                        TOP 1 PROJECT_ID
                    FROM
                        SCEN_EXPENSE_PERIOD_ROWS
                    WHERE
                        PERIOD_ID=#detail.PERIOD_ID#
                    </cfquery>
                    <div class="form-group" id="item-project_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_project.project_id#</cfoutput>">
                                <input type="text" value="<cfif len(get_project.project_id)><cfoutput>#get_project_name(get_project.project_id)#</cfoutput></cfif>" name="project_name" id="project_name" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" value="" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='57416.Proje'>" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_expense.project_name&project_id=upd_expense.project_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-repitition">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55875.Tekrar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='54620.Tekrar Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="repitition" required="yes" value="#detail.period_repitition#" validate="integer" message="#message#" onkeyup="return(FormatCurrency(this,event));"  maxlength="2" class="moneybox" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-currency">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='54619.Tutar Girmelisiniz'></cfsavecontent>
                                <cfinput name="period_value" type="text" required="yes" message="#message#" value="#TLFormat(detail.PERIOD_VALUE)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:97px;">
                                <cfinclude template="../query/get_money.cfm">
                                <span class="input-group-addon width">
                                    <select name="currency" id="currency" style="width:50px;">
                                        <cfoutput query="get_money">
                                            <option value="#money#" <cfif money eq detail.period_currency>selected</cfif>>#money#</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-period_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang no='97.Periyot'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="period_type" id="period_type" style="width:150px;">
                                <option value="1" <cfif detail.PERIOD_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='54552.Her Hafta'></option>
                                <option value="2" <cfif detail.PERIOD_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='54553.Her Ay'></option>
                                <option value="6" <cfif detail.PERIOD_TYPE eq 6>selected</cfif>><cf_get_lang dictionary_id='54958.Her 2 Ayda Bir'></option>
                                <option value="3" <cfif detail.PERIOD_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='54554.Her 3 Ayda Bir'></option>
                                <option value="4" <cfif detail.PERIOD_TYPE eq 4>selected</cfif>><cf_get_lang dictionary_id='54555.Her 6 Ayda Bir'></option>
                                <option value="5" <cfif detail.PERIOD_TYPE eq 5>selected</cfif>><cf_get_lang dictionary_id='54550.Her Sene'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons 
                is_upd='1'
                delete_page_url="#request.self#?fuseaction=finance.emptypopup_upd_scen_expense&id=#attributes.id#&del_id=1&detail=#detail.period_detail#"
                add_function='unformat_fields()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function unformat_fields()
	{
		upd_expense.period_value.value = filterNum(upd_expense.period_value.value);
		upd_expense.repitition.value = filterNum(upd_expense.repitition.value);
		<cfif isdefined("attributes.draggable")>
            loadPopupBox('upd_expense' , <cfoutput>#attributes.modal_id#</cfoutput>);
            return false;
        <cfelse>
            return true;
        </cfif>
	}
</script>
