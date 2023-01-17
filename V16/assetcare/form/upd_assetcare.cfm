<cfquery name="GET_ASSET_CARE" datasource="#DSN#">
	SELECT * FROM ASSET_CARE_REPORT WHERE CARE_REPORT_ID = #care_report_id#
</cfquery>
<cfquery name="GET_ASSET_NAME" datasource="#DSN#">
	SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE	ASSETP_ID = #get_asset_care.asset_id#
</cfquery>
<cfquery name="GET_CARE_CAT" datasource="#DSN#">
	SELECT ASSET_CARE, ASSET_CARE_ID FROM ASSET_CARE_CAT ORDER BY ASSET_CARE
</cfquery>
<cfquery name="GET_ASSET_STATE" datasource="#DSN#">
	SELECT ASSET_STATE_ID, ASSET_STATE FROM	ASSET_STATE
</cfquery>
<cfif isDefined("attributes.id") and len(attributes.id)>
	<cfquery name="GET_ASSETP_EXPENSES" datasource="#dsn#">
		SELECT * FROM EXPENSE_ITEMS_ROWS WHERE PYSCHICAL_ASSET_ID = #get_asset_care.asset_id# AND EXPENSE_COST_TYPE = 2 AND EXP_ITEM_ROWS_ID = #attributes.id#
	</cfquery>
    <cfquery name="GET_ASSETP_EXPENSES2" datasource="#dsn#">
		SELECT * FROM EXPENSE_ITEMS_ROWS WHERE PYSCHICAL_ASSET_ID = #get_asset_care.asset_id# AND EXPENSE_COST_TYPE = 2 AND EXPENSE_ID = #attributes.id#
	</cfquery>
   <cfquery name="GET_ASSETP_EXPENSES1" datasource="#dsn#">
		SELECT 
        	EXPENSE_ITEM_NAME,* 
        FROM 
        	ASSET_CARE_REPORT A 
        	LEFT JOIN #dsn2_alias#.EXPENSE_ITEMS E ON E.EXPENSE_ITEM_ID = A.EXPENSE_ITEM_ROW_ID 
        WHERE 
        	ASSET_ID = #get_asset_care.asset_id# AND 
        	EXPENSE_ITEM_ROW_ID = #attributes.id#
	</cfquery>
</cfif>
<cf_box popup_box="#iif(isdefined("attributes.draggable"),1,0)#" title="Güncelle">
    <cfform action="#request.self#?fuseaction=assetcare.emptypopup_upd_asset_care&care_report_id=#url.care_report_id##iif(isdefined('attributes.draggable'),DE('&draggable=1'),DE(''))#" method="post" name="upd_asset_care" enctype="multipart/form-data">
        <input type="hidden" name="id" id="id" value="<cfoutput><cfif isDefined("attributes.id") and len(attributes.id)>#attributes.id#</cfif></cfoutput>">
        <input type="hidden" name="is_detail" id="is_detail" value="1">
		<cf_box_elements vertical="1">
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label ><cf_get_lang_main no='1655.Varlık'> *</label>
                <div class="form-group">
                    <div class="input-group">
                        <cfif isdefined("asset_id") and len(asset_id)>
                            <cfquery name="GET_ASSET_NAME" datasource="#DSN#">
                                SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #url.asset_id#
                            </cfquery>
                        </cfif>
                        <input type="hidden" name="asset_id" id="asset_id" value="<cfif isdefined("asset_id") and len(url.asset_id)><cfoutput>#url.asset_id#</cfoutput></cfif>">
                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'>!</cfsavecontent>
                        <cfif isdefined("asset_id") and len(url.asset_id)>
                            <cfinput type="text" name="asset_name" value="#get_asset_name.assetp#" required="yes" message="#message#" readonly style="width:150px;">
                        <cfelse>
                            <cfinput type="text" name="asset_name" value="" required="yes" message="#message#" readonly style="width:150px;">
                        </cfif>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=upd_asset_care.asset_id&field_name=upd_asset_care.asset_name&event_id=0&motorized_vehicle=0');"></span>
                    </div>                  
                </div>
                <label ><cf_get_lang no='41.Bakım Tarihi'> *</label>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="alert"><cf_get_lang_main no ='1091.Tarih Giriniz'></cfsavecontent>
                        <cfinput type="text" value="#dateformat(GET_ASSET_CARE.CARE_DATE,dateformat_style)#" name="support_finish_date1" validate="#validate_style#" maxlength="10" required="yes" message="#alert#" style="width:150px;">
                        <span class="input-group-addon">
                            <cf_wrk_date_image date_field="support_finish_date1">
                        </span>
                    </div>                    
                </div>
                <label ><cf_get_lang_main no='468.Belge No'></label>
                <div class="form-group">
                    <div class="input-group">
                        <cfif isdefined("get_asset_care.bill_id") and len(get_asset_care.bill_id)>
                            <cfquery name="GET_INVOICE_ID" datasource="#DSN2#">
                                SELECT INVOICE_NUMBER FROM INVOICE WHERE INVOICE_ID = '#get_asset_care.bill_id#'
                            </cfquery>
                        </cfif>
                        <cfif isdefined("get_asset_care.bill_id") and len(get_asset_care.bill_id)>
                            <input type="hidden" name="bill_id" id="bill_id" value="<cfoutput>#get_asset_care.bill_id#</cfoutput>" onChange="bosalt();">
                            <input type="text" name="bill_name" id="bill_name" value="<cfoutput>#GET_INVOICE_ID.INVOICE_NUMBER#</cfoutput>" style="width:150px;" onChange="bosalt();">
                        <cfelse>
                            <input type="hidden" name="bill_id" id="bill_id" value="" onChange="bosalt();">
                            <input type="text" name="bill_name" id="bill_name" value="" style="width:150px;" onChange="bosalt();">
                        </cfif>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_bills&field_id=upd_asset_care.bill_id&field_name=upd_asset_care.bill_name&field_value=upd_asset_care.expense&field_bill_type_name=upd_asset_care.paper_type&cat=0&field_calistir=1</cfoutput>');"></span>
                        <input type="hidden" name="assetp_id" id="assetp_id" value=""><input type="hidden" name="is_detail" id="is_detail" value="0">
                    </div>                      
                </div>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label><cf_get_lang no='50.Bakımı Yapan (Üye)'></label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="member_id" id="member_id" value="">
                        <input type="hidden" name="service_company_id" id="service_company_id" value="<cfoutput>#get_asset_care.company_id#</cfoutput>">
                        <input type="hidden" name="authorized_id" id="authorized_id" value="<cfoutput>#get_asset_care.company_partner_id#</cfoutput>">
                        <input type="text" name="service_company"  id="service_company" value="<cfoutput>#get_par_info(get_asset_care.company_id,1,0,0)#</cfoutput>" style="width:150px;" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=upd_asset_care.service_company&field_comp_id=upd_asset_care.service_company_id&field_name=upd_asset_care.authorized&field_partner=upd_asset_care.authorized_id&draggable=1&is_buyer_seller=1&select_list=7');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='50.Bakımı Yapan (Üye)'>" border="0" align="absbottom"></span>
                    </div>
                    
                </div>
                <label><cf_get_lang no='42.Bakım Tipi'></label>
                <div class="form-group"><select name="care_type_id" id="care_type_id" style="width:150px;">
                    <cfoutput query="get_care_cat">
                        <option value="#asset_care_id#" <cfif get_asset_care.care_type eq asset_care_id>selected</cfif>>#asset_care#</option>
                    </cfoutput>
                    </select>
                </div>
                <label><cf_get_lang_main no='1121.Belge Tipi'></label>
                <div class="form-group"><cfif isdefined("get_assetp_expenses.paper_type") and len(get_assetp_expenses.paper_type)>
                    <cfinput type="text" style="width:150px;" name="paper_type" maxlength="100" value="#get_assetp_expenses.paper_type#">
                    <cfelse>
                        <cfinput type="text" style="width:150px;" name="paper_type" maxlength="100" value="">
                    </cfif>
                </div>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label><cf_get_lang no='38.Bakımı Yapan Yetkili'></label>
                <div class="form-group">
                    <input type="text" style="width:150px;" name="authorized" id="authorized" value="<cfif len(get_asset_care.company_partner_id)><cfoutput>#get_par_info(get_asset_care.company_partner_id,0,0,0)#</cfoutput></cfif>" readonly>
                </div>
                <label><cf_get_lang_main no='1139.Gider Kalemi'> *</label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="exp_item_name" id="exp_item_name" value="<cfif isdefined("GET_ASSETP_EXPENSES1.expense_item_id") and len(GET_ASSETP_EXPENSES1.expense_item_id)><cfoutput>#GET_ASSETP_EXPENSES1.expense_item_id#</cfoutput></cfif>">
                        <cfif isdefined("GET_ASSETP_EXPENSES1.expense_item_id") and len(GET_ASSETP_EXPENSES1.expense_item_id)>
                            <cfinput type="text" name="exp_item_name_id" style="width:150px;" value="#GET_ASSETP_EXPENSES1.EXPENSE_ITEM_NAME#" required="yes" message="Gider Kalemi Giriniz!">
                        <cfelse>
                            <cfinput type="text" name="exp_item_name_id" value="" style="width:150px;" required="yes" message="Gider Kalemi Giriniz!">
                        </cfif>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_asset_care.exp_item_name&field_name=upd_asset_care.exp_item_name_id&draggable=1');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1139.Gider Kalemi'>" border="0" align="absbottom"></span>	
                    </div>              
                </div>
                <label rowspan="2"><cf_get_lang_main no='22.Rapor'></label>
                <div rowspan="2" class="form-group"><textarea style="width:150px;height:50px;" name="care_detail" id="care_detail"><cfif len(get_asset_care.detail)><cfoutput>#get_asset_care.detail#</cfoutput></cfif></textarea></div>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label><cf_get_lang no='39.Bakım Yapan Çalışan'></label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_asset_care.c_employee1_id#</cfoutput>">
                        <input type="text" name="employee" id="employee" style="width:150px;" value="<cfif len(get_asset_care.c_employee1_id)><cfoutput>#get_emp_info(get_asset_care.c_employee1_id,1,0)#</cfoutput></cfif>" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=upd_asset_care.employee_id&field_name=upd_asset_care.employee&select_list=1');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='39.Bakım Yapan Çalışan'>" border="0" align="absbottom"></span>
                    </div>		
                </div>
                <label><cf_get_lang_main no='1048.Masraf Merkezi'> *</label>
                <div class="form-group">
                    <div class="input-group">
                        <cfif isdefined("get_assetp_expenses2.expense_center_id") and len(get_assetp_expenses2.expense_center_id)>
                            <cfquery name="GET_EXPENSE_CENTER_NAME" datasource="#dsn2#">
                                SELECT EXPENSE, EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_assetp_expenses2.expense_center_id#
                            </cfquery>
                        </cfif>
                        <input name="expense_center_id" id="expense_center_id" type="hidden" value="<cfif isdefined("get_assetp_expenses2.expense_center_id") and len(get_assetp_expenses2.expense_center_id)><cfoutput>#get_assetp_expenses2.expense_center_id#</cfoutput></cfif>">
                        <cfif isdefined("get_assetp_expenses2.expense_center_id") and len(get_assetp_expenses2.expense_center_id)>
                            <cfinput name="expense_center" style="width:150px;" type="text" value="#get_expense_center_name.expense#" required="yes" message="Masraf Merkezi Giriniz!">
                        <cfelse>
                            <cfsavecontent variable="messagexp"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1048.Masraf Merkezi'>!</cfsavecontent>
                            <cfinput name="expense_center" style="width:150px;" type="text" value="" required="yes" message="#messagexp#">
                        </cfif>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=upd_asset_care.expense_center&field_id=upd_asset_care.expense_center_id&is_invoice=1</cfoutput>');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1048.Masraf Merkezi'>" border="0" align="absbottom"></span>
                    </div>
                </div>
            </div>          
            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                <label><cf_get_lang no='39.Bakım Yapan Çalışan'> 2</label>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="employee_id2" id="employee_id2" value="<cfoutput>#get_asset_care.c_employee2_id#</cfoutput>">
                    <input type="text" name="employee2" id="employee2"  style="width:150px;" value="<cfif len(get_asset_care.c_employee2_id)><cfoutput>#get_emp_info(get_asset_care.c_employee2_id,1,0)#</cfoutput></cfif>" readonly>
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=upd_asset_care.employee_id2&field_name=upd_asset_care.employee2&select_list=1');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='39.Bakım Yapan Çalışan'>" border="0" align="absbottom"></span>	
                    </div>
                </div>
                <label><cf_get_lang_main no='846.Maliyet '>*</label>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='846.maliyet'></cfsavecontent>
                    <cfif isdefined("get_asset_care.expense_amount") and len(get_asset_care.expense_amount)>
                        <cfinput type="text" name="expense"  value="#tlformat(get_asset_care.expense_amount)#" style="width:97px;" message="#message#" onKeyup="return(FormatCurrency(this,event));">
                    <cfelse>
                        <cfinput type="text" name="expense" value="" style="width:97px;" message="#message#" onKeyup="return(FormatCurrency(this,event));">
                    </cfif>
                    <cfinclude template="../query/get_money.cfm">
                    <select name="money_currency" id="money_currency" style="width:50px;">
                        <cfoutput query="GET_MONEY">
                            <option value="#money#" <cfif isdefined("get_assetp_expenses.money_currency_id") and len(get_assetp_expenses.money_currency_id) and (get_assetp_expenses.money_currency_id eq money)>selected</cfif>>#money#</option>
                        </cfoutput>
                    </select>
                </div>
            </div>
        </cf_box_elements>
        <cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='0' add_function='gonder2()'>
    </cfform>     
</cf_box>
    
<script type="text/javascript">
function first_bosalt()
{
	if (asset_care.bill_id.value != "")
	{
		asset_care.paper_type.readOnly = true;
		asset_care.expense.readOnly = true;
		asset_care.money_currency.disabled = true;
	}
}
first_bosalt();
		
function bosalt()
{
	if (asset_care.bill_name.value == "") 
	{
		asset_care.bill_id.value = "";
	}
	if(asset_care.bill_id.value == "")
	{
		asset_care.paper_type.readOnly = false;
		asset_care.expense.readOnly = false;
		asset_care.money_currency.disabled = false;
	}
	if (asset_care.bill_id.value != "")
	{
		asset_care.paper_type.readOnly = true;
		asset_care.expense.readOnly = true;
		asset_care.money_currency.disabled = true;
	}
}

function gonder2()
{
	<cfif not isdefined("asset_care.money_currency.value")>
		asset_care.money_currency.disabled = false;
	</cfif>
	if ((asset_care.expense.value != "") && (asset_care.exp_item_name_id.value == ""))
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1139.Gider Kalemi'> !");
		return false;
	}
	if ((asset_care.expense.value != "") && (asset_care.expense_center_id.value == ""))
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1048.Masraf Merkezi'> !");
		return false;
	}
	//asset_care.expense.value = filterNum(asset_care.expense.value);
}
</script>
