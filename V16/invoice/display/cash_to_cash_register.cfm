<cfobject name="whops_cash" type="component" component="V16.invoice.cfc.cash_to_cash">
<cfif isDefined('attributes.store_report_id') and len(attributes.store_report_id)>
    <cfset get_store_report = whops_cash.get_store_report(store_report_id:attributes.store_report_id)>
</cfif>
<cfscript>
    get_pos_equipment = whops_cash.get_pos_equipment();

    get_branch = whops_cash.get_branch();
    </cfscript>
<div class="col col-12 col-xs-12">
    <cf_box title="#getLang('','Yazar Kasadan Kasaya Para Yatırma',45677)#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="cash_to_cash" action="">
            <input type="hidden" name="store_report_id" id="store_report_id" value="<cfoutput><cfif isDefined('attributes.store_report_id')>#attributes.store_report_id#</cfif></cfoutput>">
            <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62481.Whops'>-<cf_get_lang dictionary_id='57520.Kasa'></label>
                            <div class="col col-8 col-xs-8">
                                <input type="hidden" id="whops_branch_id" name="whops_branch_id" value="">
                                <select id="whops_pos_id" name="whops_pos_id" onchange="load_cash('1')">
                                    <option value="-1"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_pos_equipment">
                                        <option value="#pos_id#" <cfif isDefined('get_store_report.pos_id') and get_store_report.pos_id eq pos_id>selected</cfif>>#EQUIPMENT#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
                            <div class="col col-8 col-xs-8">
                                <select id="whops_cash_id" name="whops_cash_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfif isdefined('get_store_report')>
                                        <cfscript>
                                            get_pos_cash_ = whops_cash.get_pos_cash(pos_id:get_store_report.pos_id);
                                        </cfscript>	
                                        <cfoutput query="get_pos_cash_">
                                            <option value="#cash_id#" <cfif isDefined('get_store_report') and get_store_report.cash_id eq cash_id>selected</cfif>>#CASH_NAME#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12 col-xs-12 bold"><cf_get_lang dictionary_id='43633.Yazar Kasadaki Nakit'></label>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37345.TL'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="cash_TL" name="cash_TL" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.cash_TL)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37344.USD'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="cash_USD" name="cash_USD" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.cash_USD)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40533.Euro'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="cash_Euro" name="cash_Euro" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.cash_Euro)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12 col-xs-12 bold"><cf_get_lang dictionary_id='40288.Teslim Edilen'><cf_get_lang dictionary_id='58645.Nakit'></label>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37345.TL'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="delivered_TL" name="delivered_TL" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.delivered_TL)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37344.USD'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="delivered_USD" name="delivered_USD" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.delivered_USD)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40533.Euro'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="delivered_Euro" name="delivered_Euro" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.delivered_Euro)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="form-group">
                                <label class="col col-12 col-xs-12 bold"><cf_get_lang dictionary_id='58444.Kalan'>- <cf_get_lang dictionary_id='58034.Devreden'></label>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37345.TL'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="remaining_transferred_TL" name="remaining_transferred_TL" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.REMAINING_TRANSFERRED_TL)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37344.USD'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="remaining_transferred_USD" name="remaining_transferred_USD" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.REMAINING_TRANSFERRED_USD)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='40533.Euro'></label>
                                <div class="col col-6 col-xs-8">
                                <input class="moneybox" id="remaining_transferred_Euro" name="remaining_transferred_Euro" value="<cfoutput><cfif isDefined('get_store_report')>#TLformat(get_store_report.REMAINING_TRANSFERRED_EURO)#<cfelse>#TLformat(0)#</cfif></cfoutput>" onkeyup="return(FormatCurrency(this,event,0));">
                                </div>
                            </div>
                        </div>
                    </div>
                    </cf_box_elements>
                <cf_box_elements vertical="1" scroll="0">
                    <div class="col col-3 col-md-4 col-sm-4 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='53313.Teslim Eden'><cf_get_lang dictionary_id='54577.Kasiyer'></label>
                            <div class="col col-12 col-xs-12">
                                <cfif isDefined('get_store_report.delivery_emp_id') and len(get_store_report.delivery_emp_id)>
                                    <cfset delivery_emp_ = get_emp_info(get_store_report.delivery_emp_id,0,0)>
                                <cfelse>
                                    <cfset delivery_emp_ = ''>
                                </cfif>
                                <div class="input-group">
                                    <input type="hidden" name="delivery_emp_id" id="delivery_emp_id" value="<cfoutput><cfif isDefined('get_store_report')>#get_store_report.delivery_emp_id#</cfif></cfoutput>">
                                    <cfinput type="text" name="delivery_emp" id="delivery_emp" value="#delivery_emp_#" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=cash_to_cash.delivery_emp_id&field_name=cash_to_cash.delivery_emp</cfoutput>','','ui-draggable-box-medium');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-4 col-xs-12" type="column" index="5" sort="true">
                        <div class="form-group">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                            <div class="col col-12 col-xs-12">
                                <cfif isDefined('get_store_report.receiver_emp_id') and len(get_store_report.receiver_emp_id)>
                                    <cfset receiver_emp_ = get_emp_info(get_store_report.receiver_emp_id,0,0)>
                                    <cfelse>
                                    <cfset receiver_emp_ = ''>
                                    </cfif>
                                <div class="input-group">
                                    <input type="hidden" name="receiver_emp_id" id="receiver_emp_id" value="<cfoutput><cfif isDefined('get_store_report')>#get_store_report.receiver_emp_id#</cfif></cfoutput>">
                                    <cfinput type="text" name="receiver_emp" id="receiver_emp" value="#receiver_emp_#" readonly>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=cash_to_cash.receiver_emp_id&field_name=cash_to_cash.receiver_emp</cfoutput>','','ui-draggable-box-medium');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-4 col-xs-12" type="column" index="6" sort="true">
                        <div class="form-group" id="item-process_date">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                            <div class="col col-12 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="delivery_date" id="delivery_date" value="<cfoutput><cfif isDefined('get_store_report')>#dateformat(get_store_report.store_report_date,dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)#</cfif></cfoutput>" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="delivery_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cfif isdefined("attributes.store_report_id")>
                        <cf_record_info query_name="get_store_report">
                        <cf_workcube_buttons is_upd="1" 
                        data_action="/V16/invoice/cfc/cash_to_cash:upd_cash"
                        next_page="#request.self#?fuseaction=whops.cash_to_cash_register&is_submitted=1"
                        add_function="kontrol()"
                        del_action= '/V16/invoice/cfc/cash_to_cash:del_cash:store_report_id=#get_store_report.store_report_id#'
                        del_next_page="#request.self#?fuseaction=whops.cash_to_cash_register&is_submitted=1">
                    <cfelse>
                        <cf_workcube_buttons is_upd="0" data_action="/V16/invoice/cfc/cash_to_cash:add_cash" add_function="kontrol()"
                        next_page="#request.self#?fuseaction=whops.cash_to_cash_register</cfif>&is_submitted=1">
                    </cfif>
                </cf_box_footer>
        </cfform>
    </cf_box>
</div>
