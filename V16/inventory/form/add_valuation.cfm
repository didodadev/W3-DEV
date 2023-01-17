<!--- 
    Author : Melek KOCABEY
    Create Date : 11/05/2022
    Desc :  Dosya ismi add_valuation.cfm 
            COMPONENT ismi inventory.cfc
            bir sabit kıymet için yapılan tamir bakım harcamalarından değerine eklenmemiş olanlar satır bazında listelenir
            harcama tutarları toplanarak, Değer artışı ve düşüşü işlemi ile yeni demirbaş oluştur veya var olan demirbaş ilişlili demirbaş oluşturma işlemleri yapılır
---> 
<cfset components = createObject('component','V16.inventory.cfc.inventory')>
<cfset GetValuationAsset = components.GetMaintennanceValuation(inventory_id:attributes.id)>
<cfset GetInvent = components.GetInvent(inventory_id:attributes.id)>

<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','',32923)#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.no'></th>
                    <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57880.Belge No'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th>
                    <th><cf_get_lang dictionary_id='59936.Bütçe Merkezi'></th>
                    <th><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th>
                    <th><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></th>
                    <th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'><cfoutput> #session.ep.money# </cfoutput></th>
                    <th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'><cfoutput>#session.ep.money2#</cfoutput></th>
                    <th width="20" class="header_icn_none"><input type="checkbox" class="checkControl" name="allSelectExpense" id="allSelectExpense" onclick="wrk_select_all('allSelectExpense','row_asset_valitioan');"  total_value="0" amount_value="0" ItemId="0" expenseID="0" expRowId="0"></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="GetValuationAsset">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#DateFormat(expense_date,dateformat_style)#</td>
                        <td><a target="_blank" href="#request.self#?fuseaction=assetcare.form_add_expense_cost&event=upd&expense_id=#expense_id#" class="tableyazi">#paper_no#</a></td>
                        <td>#detail#</td>
                        <td>#assetp#</td>
                        <td><cfif len(project_id)>#get_project_name(project_id)#<cfelse>projesiz</cfif></td>
                        <td>#expense_name#</td>
                        <td>#item_name#</td>
                        <td>#EXPENSE_ACCOUNT_CODE#</td>
                        <td class="text-right">#TLFORMAT(amount)#</td>
                        <td class="text-right">#TLFORMAT(amount_2)#</td>
                        <td><input type="checkbox" class="checkControl" name="row_asset_valitioan" id="row_asset_valitioan#currentrow#" value="#inventory_id#" total_value="#amount_2#" amount_value="#amount#" ItemId="#EXPENSE_ITEM_ID#" expenseID="#expense_id#" expRowId=#EXP_ITEM_ROWS_ID#>  </td>             
                    </tr>
                </cfoutput>
            </tbody>
            <tfoot>
                <cfoutput> 
                    <tr>
                        <td colspan="9" class="text-right"><b>Değer Artışı Oluşturan Harcama Toplamı</b></td>
                        <td class="text-right" id="amounttotal"></td>
                        <td class="text-right" id="amounttotal2"></td>
                        <td class="text-right"></td>
                    </tr>
                </cfoutput>
            </tfoot>
        </cf_grid_list>
        <cfform name="InventForm" id="InventForm" method="post" action="">
            <cfinput type="hidden" name="inventory_id" id="inventory_id" value="#attributes.id#">
            <cfinput type="hidden" name="OldInventoryMoney" id="OldInventoryMoney" value="#GetInvent.last_inventory_value#">
            <cfinput type="hidden" name="OldInventoryMoney_" id="OldInventoryMoney_" value="#GetInvent.last_inventory_value_2#">
            <cfinput type="hidden" name="ItemIdList" id="ItemIdList" value="">
            <cfinput type="hidden" name="ExpRowIdList" id="ExpRowIdList" value="">
            <cfinput type="hidden" name="expenseIdList" id="expenseIdList" value="">
            <cf_seperator title="#getLang('','',56464)#" id="valueCalculative">
            <div id="valueCalculative">
                <cf_box_elements>
                    <cfoutput>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="form-group"  style="margin: 0 0 15px 0;">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="bold"><cf_get_lang dictionary_id='41144.Sabit Kıymetin son değeri'> - #session.ep.money#</label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    #TLFormat(GetInvent.last_inventory_value*GetInvent.quantity)#
                                </div>
                            </div>
                            <div class="form-group" style="margin: 0 0 15px 0;">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="bold"><cf_get_lang dictionary_id='41144.Sabit Kıymetin son değeri'> - #session.ep.money2#</label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                #TLFormat(GetInvent.last_inventory_value_2*GetInvent.quantity)#
                                </div>
                            </div>
                            <div class="form-group" style="margin: 0 0 15px 0;">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="bold"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">                                
                                    <cfif GetInvent.amortizaton_method eq 0>
                                        <cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>
                                    <cfelseif GetInvent.amortizaton_method eq 1 >
                                        <cf_get_lang dictionary_id='29422.Sabit Miktar Üzerinden'>
                                    </cfif>                               
                                </div>
                            </div>
                            <div class="form-group" style="margin: 0 0 15px 0;">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="bold"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                    <cfquery name="GET_ACCOUNT_NAME" datasource="#DSN2#">
                                        SELECT ACCOUNT_NAME,ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetInvent.ACCOUNT_ID#">
                                    </cfquery>                               
                                    #get_account_name.account_code# - #get_account_name.account_name#                              
                                </div>
                            </div>
                            <div class="form-group"  style="margin: 0 0 15px 0;">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="bold"><cf_get_lang dictionary_id='56915.Amortisman Oranı'></label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                #GetInvent.amortizaton_estimate#
                                </div>
                            </div>
                            <div class="form-group"  style="margin: 0 0 15px 0;">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="bold"><cf_get_lang dictionary_id='36804.Kalan Faydalı Omur'></label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cfif len(GetInvent.inventory_duration)>#TLFormat(GetInvent.inventory_duration)#</cfif>
                                </div>
                            </div>
                            <div class="form-group"  style="margin: 0 0 15px 0;">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label class="bold"><cf_get_lang dictionary_id='54744.Kalan Amortisman Dönemi'></label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                #GetInvent.account_period#
                                </div>
                            </div>                        
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="form-group">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <label><cf_get_lang dictionary_id='37620.Hesaplama Yöntemi'></label>
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <select name="calculativeMethod" id="calculativeMethod">
                                        <option value="1"<cfif isdefined('attributes.calculativeMethod') and (attributes.calculativeMethod eq 1)> selected</cfif>><cf_get_lang dictionary_id='32962.Demirbaş İle İlişkili Yeni Demirbaş Oluştur'></option>
                                        <option value="0"<cfif isdefined('attributes.calculativeMethod') and (attributes.calculativeMethod eq 0)> selected</cfif>><cf_get_lang dictionary_id='52055.Demirbaşı sıfırla yeni değerle demirbaş oluştur'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group"><div class="col col-xs-12"><label class="bold"><cf_get_lang dictionary_id='33052.Değer Artışından Kaynaklı Sonuçlar'></label></div></div>
                            <div class="form-group small">
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <label><cf_get_lang dictionary_id='39336.Faydalı ömrü ne kadar arttıracak?'></label>
                                </div>
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <input type="text" value="0" name="amor_count" id="amor_count">
                                </div>
                            </div>
                            <div class="form-group small">
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <label><cf_get_lang dictionary_id='37655.Amortisman Süresini ne kadar arttıracak?'></label>
                                </div>
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <input type="text" value="0" name="amor_usabled" id="amor_usabled">
                                </div>
                            </div>
                        </div>
                    </cfoutput>                
                </cf_box_elements>
            </div>
            <cf_seperator title="#getLang('','',37767)#" id="inventP">
            <div id="inventP">
                <cf_box_elements vertical="1">
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-paperNo">
                            <label><cf_get_lang dictionary_id='57880.Belge No'></label>
                            <cfinput type="text" name="paperNo" id="paperNo" value=#GetInvent.INVENTORY_NUMBER#>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-entryDate">
                            <label><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                            <div class="input-group">
                                <cfinput type="text" name="entryDate" value="#DateFormat(GetInvent.ENTRY_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="entryDate"></span>
                            </div>
                        </div>
                        <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-cat">
                            <label><cf_get_lang dictionary_id='57124.İşlem Kategorisi'>*</label>
                            <cf_workcube_process_cat slct_width="140" module_id="26">
                        </div>
                        <div class="form-group col col-2 col-md-3 col-sm-2 col-xs-12" id="item-processcat">
                            <label><cf_get_lang dictionary_id='41129.Süreç/Aşama'>*</label>
                            <cf_workcube_process is_upd="0" slct_width="180px;" is_detail="0" process_cat_width='300'>
                        </div>
                        <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12" id="item-invent_employee">
                            <label><cf_get_lang dictionary_id='36765.İşlemi Yapan'></label>
                            <div class="input-group">
                                <input type="hidden" name="invent_employee_id" id="invent_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                <input type="text" name="invent_employee" id="invent_employee" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" style="width:140px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=InventForm.invent_employee_id&field_name=InventForm.invent_employee&select_list=1');"></span>
                            </div>
                        </div>
                        <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12" id="item-inventName">
                            <label><cf_get_lang dictionary_id='33265.Demirbaşa yeni bir ad veriniz'>*</label>
                            <cfinput type="text" name="inventName" id="inventName" value="#GetInvent.INVENTORY_NAME#">
                        </div>
                        <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12" id="item-inventory_cat">
                            <label><cf_get_lang dictionary_id='56904.Sabit Kıymet Kategorisi'>*</label>
                            <div class="input-group">
                                <cfinput type="hidden" id="inventory_cat_id" name="inventory_cat_id" value="#GetInvent.inventory_catid#">
                                <cfinput type="text" id="inventory_cat" name="inventory_cat" value="#GetInvent.CAT_NAME#">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory_cat&field_id=InventForm.inventory_cat_id&field_name=InventForm.inventory_cat');"></span>
                            </div>
                        </div>
                        <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12" id="item-detailİnvent">
                            <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <textarea name="detailİnvent" id="detailİnvent" rows="2" cols="21"></textarea>
                        </div>            
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-newValue">
                                <label><cf_get_lang dictionary_id='56950.Yeni Değer'> - <cfoutput>#session.ep.money#</cfoutput></label>
                                <cfinput type="text" name="newValue" id="newValue" value="#tlformat(0)#" class="box" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-newValue_">
                                <label><cf_get_lang dictionary_id='56950.Yeni Değer'> -<cfoutput> #session.ep.money2#</cfoutput></label>
                                <cfinput type="text" name="newValue_" id="newValue_" value="#tlformat(0)#" class="box" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-newValueOther">
                                <label><cf_get_lang dictionary_id='56950.Yeni Değer'></label>
                                <div class="input-group">
                                    <cfinput type="text" name="newValueOther" id="newValueOther" value="#tlformat(0)#" class="box" onkeyup="return(FormatCurrency(this,event));">
                                    <span class="input-group-addon width">
                                        <select name="money_type" id="money_type">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_money">
                                                <option value="#money#">#money#</option>
                                            </cfoutput>
                                        </select>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-amor_method">
                                <label><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></label>
                                <select name="amor_method" id="amor_method">
                                    <option value=""><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></option>
                                    <option value="0" <cfif GetInvent.AMORTIZATON_METHOD eq 0>selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
                                    <option value="1" <cfif GetInvent.AMORTIZATON_METHOD eq 1>selected</cfif>><cf_get_lang dictionary_id='29422.Sabit Miktar Üzerinden'></option>
                                </select>
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-amortization_type_id">
                                <label><cf_get_lang dictionary_id='29425.Amortisman Türü'></label>
                                <select name="amortization_type_id" id="amortization_type_id" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif GetInvent.AMORTIZATION_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='29426.Kıst Amortismana Tabi'></option>
                                    <option value="2" <cfif GetInvent.AMORTIZATION_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='29427.Kıst Amortismana Tabi Değil'></option>
                                </select>
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-amortization_rate">
                                <label><cf_get_lang dictionary_id='58456.Oran'>*</label>
                                <cfinput type="text"  class="box" name="amortization_rate" id="amortization_rate" value="#TLFormat(GetInvent.AMORTIZATON_ESTIMATE)#" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-amortization_period">
                                <label><cf_get_lang dictionary_id='40553.Periyod/Yıl'>*</label>
                                <cfinput type="text"  class="box" name="amortization_period" id="amortization_period" value="#GetInvent.ACCOUNT_PERIOD#" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-inventory_duration">
                                <label><cf_get_lang dictionary_id='57002.Ömür'></label>
                                <cfinput type="text"  class="box" name="inventory_duration" id="inventory_duration" value="#GetInvent.INVENTORY_DURATION#" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-inventory_duration_ifrs">
                                <label>UFRS - <cf_get_lang dictionary_id='57002.Ömür'></label>
                                <cfinput type="text"  class="box" name="inventory_duration_ifrs" id="inventory_duration_ifrs" value="" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-account_code">
                                <label><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                                <div class="input-group">
                                    <CFinput type="hidden" id="account_code" name="account_code" value="#GetInvent.ACCOUNT_ID#">
                                    <cfinput type="text" id="account_name" name="account_name" value="#get_account_name.account_code#-#GET_ACCOUNT_NAME.ACCOUNT_NAME#" class="boxtext" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
                                    <span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&is_form_submitted=1&field_id=InventForm.account_code&field_name=InventForm.account_name')"></span>
                                </div>
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-expense_center_id">
                                <label><cf_get_lang dictionary_id='59936.Bütçe Merkezi'></label>
                                <div class="input-group">
                                    <input type="hidden" id="expense_center_id" name="expense_center_id" value="">
                                    <input type="text" id="expense_center_name" name="expense_center_name" value="" class="boxtext" onFocus="AutoComplete_Create('expense_center_name','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','expense_center_id','','3','175');">
                                    <span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=InventForm.expense_center_id&field_name=InventForm.expense_center_name');"></span>
                                </div>
                            </div>
                            <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-expense_item_id">
                                <label><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
                                <div class="input-group">
                                    <input type="hidden" id="expense_item_id" name="expense_item_id" value="">
                                    <cfinput type="text" id="expense_item_name" name="expense_item_name" value="" class="boxtext" onFocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID','expense_item_id','','3','200');">
                                    <span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=InventForm.expense_item_id&field_name=InventForm.expense_item_name&field_account_no=InventForm.account_code&field_account_no2=InventForm.account_code');"></span>
                                </div>
                            </div>                      
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-currency">
                            <label class ="col col-12 bold"><cf_get_lang dictionary_id='48714.İşlem Para Br'></label>
                        </div>
                        <div class="form-group" id="item-currency_">
                            <div class="col col-12 scrollContent scroll-x2">
                                <cfscript>f_kur_ekle(rate_purchase : 0 , process_type:0,base_value:'ACTION_VALUE',other_money_value:'OTHER_CASH_ACT_VALUE',form_name:'InventForm',select_input:'invent_id');</cfscript>
                            </div>
                        </div>
                    </div> 
                </cf_box_elements>
            </div>
            <cf_box_footer>
                <div class="col col-12">
                    <cf_workcube_buttons
                    is_upd='0'
                    data_action ="/V16/inventory/cfc/inventory:AddValuationInventory"
                    next_page="#request.self#?fuseaction=invent.valuation&event=add&id=">
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	$( document ).ready(function() {
            total_amount_ = 0;
            totalOther = 0;
            $('.checkControl').each(function() {
                if(this.checked){
                    total_amount_ += parseFloat($(this).attr("amount_value"));
                    totalOther += parseFloat($(this).attr("total_value"));
                    alert("aaaa");
                }
            });
            $('#amounttotal').val(commaSplit(total_amount_,4));
            $('#amounttotal2').val(commaSplit(totalOther,4));
        });
    $(function(){
            $('input[name=allSelectExpense]').click(function(){
                if(this.checked){
                    $('.checkControl').each(function(){
                        $(this).prop("checked", true);
                    });
                }
                else{
                    $('.checkControl').each(function(){
                        $(this).prop("checked", false);
                    });
                }
            });
            $('.checkControl').click(function(){
                total_amount_ = 0;
                totalOther = 0;
                itemIdList_ = '';
                itemIdList_2 = [];
                expenseIdList_ = '';
                expenseIdList_2 = [];
                expRowIdList_ = '';
                expRowIdList_2 = [];
                $('.checkControl').each(function() {
                    if(this.checked){
                        total_amount_ += parseFloat($(this).attr("amount_value"));
                        totalOther += parseFloat($(this).attr("total_value"));
                        itemIdList_ = $(this).attr("ItemId");
                        itemIdList_2.push(itemIdList_);
                        expenseIdList_ = $(this).attr("expenseID");
                        expenseIdList_2.push(expenseIdList_);
                        expRowIdList_ = $(this).attr("expRowId");
                        expRowIdList_2.push(expRowIdList_);

                    }
                });
                $('#amounttotal').text(commaSplit(total_amount_,2));
                $('#amounttotal2').text(commaSplit(totalOther,2));
                $('#newValue').val(commaSplit(total_amount_,2));
                $('#newValue_').val(commaSplit(totalOther,2));
                $('#ItemIdList').val(itemIdList_2);
                $('#expenseIdList').val(expenseIdList_2);
                $('#ExpRowIdList').val(expRowIdList_2);
            });
        });
</script>