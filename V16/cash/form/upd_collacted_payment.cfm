<cf_xml_page_edit fuseact="cash.add_collacted_payment">
<cfinclude template="../query/get_cashes.cfm">
<cfif not isdefined("attributes.new_dsn3")><cfset new_dsn3 = dsn3><cfelse><cfset new_dsn3 = attributes.new_dsn3></cfif>
<cfif not isdefined("attributes.new_dsn2")><cfset new_dsn2 = dsn2><cfelse><cfset new_dsn2 = attributes.new_dsn2></cfif>
<cfquery name="get_money" datasource="#new_dsn2#">
	SELECT MONEY_TYPE AS MONEY,* FROM CASH_ACTION_MULTI_MONEY WHERE ACTION_ID = #url.multi_id# ORDER BY ACTION_MONEY_ID
</cfquery>
<cfif not get_money.recordcount>
	<cfquery name="get_money" datasource="#new_dsn2#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
	</cfquery>
</cfif>
<cfquery name="get_action_detail" datasource="#new_dsn2#">
	SELECT
		CM.*,
		CA.CASH_ACTION_TO_COMPANY_ID AS ACTION_COMPANY_ID,
		CA.CASH_ACTION_TO_CONSUMER_ID AS ACTION_CONSUMER_ID,
		CA.CASH_ACTION_TO_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
		CA.OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
		CA.PROJECT_ID,
		CA.PAPER_NO,
		CA.CASH_ACTION_VALUE AS ACTION_VALUE,
		CA.ACTION_DETAIL,
		CA.ACTION_ID,
		CA.OTHER_MONEY AS ACTION_CURRENCY,
		CA.PAYER_ID AS EMPLOYEE_ID,
		CM.UPD_STATUS,
		CA.ASSETP_ID,
		CA.SPECIAL_DEFINITION_ID,
        CA.ACC_TYPE_ID,
		CA.AVANS_ID,
        CA.SUBSCRIPTION_ID
	FROM
		CASH_ACTIONS_MULTI CM,
		CASH_ACTIONS CA
	WHERE
		CM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID 
		AND CM.MULTI_ACTION_ID = #url.multi_id#
</cfquery>
<cfset pageHead = getLang('','Nakit ödeme',63540) & ' : ' & attributes.multi_id><!--- Toplu Ödeme : multi_id--->
<cf_catalystHeader>
<cf_box>
<cfform name="add_process">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="multi_id" id="multi_id" value="<cfoutput>#attributes.multi_id#</cfoutput>">
    <input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delMulti" />
    <cfif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)>
        <input type="hidden" name="new_dsn2" id="new_dsn2" value="<cfoutput>#attributes.new_dsn2#</cfoutput>">
        <input type="hidden" name="is_virtual" id="is_virtual" value="<cfoutput>#attributes.is_virtual_puantaj#</cfoutput>">
        <input type="hidden" name="new_dsn3" id="new_dsn3" value="<cfoutput>#attributes.new_dsn3#</cfoutput>">
        <input type="hidden" name="puantaj_id" id="puantaj_id" value="<cfoutput>#attributes.puantaj_id#</cfoutput>">
        <input type="hidden" name="new_period_id" id="new_period_id" value="<cfoutput>#attributes.new_period_id#</cfoutput>">
    </cfif>
    <cf_basket_form id="collacted_payment">
            <cf_box_elements>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='388.İşlem tipi'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat process_cat="#get_action_detail.process_cat#" slct_width="150" action_db_type="#new_dsn3#" process_db3="#new_dsn3#">
                                </div>
                            </div>
                            <div class="form-group" id="item-cash_action_from_cash_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='108.Kasa'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_Cash name="cash_action_from_cash_id" currency_branch="0" value="#get_action_detail.from_cash_id#">
                                </div>
                            </div>
                            <div class="form-group" id="item-action_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang_main no='330.Tarih'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                                    <div class="input-group">
                                        <cfinput type="text" name="action_date" value="#dateformat(get_action_detail.action_date,dateformat_style)#" maxlength="10" validate="#validate_style#" required="Yes" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                            <cf_record_info query_name='get_action_detail'>
                            <cfif isdefined("attributes.puantaj_id") and len(attributes.puantaj_id) and dsn2 eq new_dsn2>
                                <cf_workcube_buttons
                                	is_upd='1'
                                    is_cancel="0"
                                    add_function='control_form()'
                                    update_status='#get_action_detail.upd_status#'
                                    del_function_for_submit='control_del_form()'
                                    delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_collacted_action&is_virtual=#attributes.is_virtual_puantaj#&puantaj_id=#attributes.puantaj_id#&multi_id=#url.multi_id#&old_process_type=#get_action_detail.action_type_id#'>
                            <cfelseif (isdefined("attributes.puantaj_id") and len(attributes.puantaj_id))>
                                <cf_workcube_buttons is_upd='1'
                                    is_cancel="0"
                                    add_function='control_form()'
                                    update_status='#get_action_detail.upd_status#'
                                    is_delete="0">
                            <cfelse>
                                <cf_workcube_buttons
                                	is_upd='1'
                                    is_cancel="0"
                                    add_function='control_form()'
                                    update_status='#get_action_detail.upd_status#'
                                    del_function_for_submit='control_del_form()'
                                    delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_collacted_action&multi_id=#url.multi_id#&old_process_type=#get_action_detail.action_type_id#'>
                            </cfif>                        
                        </cf_box_footer>
    </cf_basket_form>
    <br>
    <cf_basket id="collacted_payment_bask">
        <cfset paper_type = 4>
        <cfset is_update = 1>
        <cfinclude template="../../objects/display/add_bank_cash_process_row.cfm">
    </cf_basket>
</cfform>
</cf_box>
