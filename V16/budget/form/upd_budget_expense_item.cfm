<cfinclude template="../../objects/query/tax_type_code.cfm">
<cfinclude template="../query/get_expense_item_static_cat.cfm">
<cfinclude template="../query/get_expense_cat_list.cfm">
<cfscript>
	cfc = createObject("component", "V16.budget.cfc.budget_expense_cat");
	BudgetCats = cfc.GetBudgetCats();
    itemCat =cfc.GetBudgetCats(not_upper_cats:1,expense_category_id:get_expense_item_sta.expense_category_id);
</cfscript>
<cfsavecontent variable="right"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=budget.popup_form_add_expense_item"><img src="/images/plus1.gif" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='51365.Bütçe Kalemleri'> <cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
    <cf_box title="#head#">
        <cfform name="upd_expense_item" method="post" action="#request.self#?fuseaction=budget.emptypopup_upd_expense_item">
        <input type="hidden" name="item_id" id="item_id" value="<cfoutput>#attributes.item_id#</cfoutput>"/>
        <!--- <cfset item_code=listlast(get_expense_item_sta.expense_item_code,".")> --->
        <cfset len_upper = len(itemCat.expense_cat_code) + 1>
        <cfset len_sub = len(get_expense_item_sta.expense_item_code) - len_upper>
        <cfif get_expense_item_sta.expense_item_code contains '.'>
            <cfif len_sub neq 0>
                <cfset item_code = Right(get_expense_item_sta.expense_item_code,len_sub)>
            <cfelse>
                <cfset item_code = get_expense_item_sta.expense_item_code>
            </cfif>
        <cfelse>
            <cfset item_code = get_expense_item_sta.expense_item_code>
        </cfif>
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_active">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" <cfif get_expense_item_sta.is_active eq 1>checked</cfif>>
                    </label>
                </div>
                <div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="income_expense">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_get_lang dictionary_id='58677.Gelir'><input type="checkbox" name="income_expense" id="income_expense" <cfif len(get_expense_item_sta.income_expense) and (get_expense_item_sta.income_expense eq 1)>checked</cfif>>
                    </label>
                </div>
                <div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="is_expense">
                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12" id="is_expense">
                        <cf_get_lang dictionary_id='58678.Gider'><input type="checkbox" name="is_expense" id="is_expense" <cfif len(get_expense_item_sta.is_expense) and (get_expense_item_sta.is_expense eq 1)>checked</cfif>>
                    </label>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-expense_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                    <div class="col col-8 col-xs-12">
                        <select name="expense_cat" id="expense_cat" onchange="document.upd_expense_item.head_cat_code.value=document.upd_expense_item.expense_cat[document.upd_expense_item.expense_cat.selectedIndex].value;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="BudgetCats">
                                    <option value="#expense_cat_code#"<cfif IsDefined("IS_SUB_EXPENSE_CAT") and IS_SUB_EXPENSE_CAT eq 1> disabled style="font-weight:bold;" </cfif><cfif get_expense_item_sta.expense_category_id eq expense_cat_id> selected</cfif>>
                                <cfif ListLen(expense_cat_code,".") neq 1>
                                    <cfloop from="1" to="#ListLen(expense_cat_code,".")#" index="i">&nbsp;&nbsp;</cfloop>
                                </cfif> 
                                #expense_cat_code# #expense_cat_name#</option>
                            </cfoutput>
                        </select>                    
                    </div>
                </div>
                <div class="form-group" id="item-expense_item_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32775.Kategori Kodu'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfoutput><input type="text" name="head_cat_code" id="head_cat_code" placeholder="<cf_get_lang dictionary_id='57986.Alt'><cf_get_lang dictionary_id='57559.Bütçe'><cf_get_lang dictionary_id='32775.Kategori Kodu'>" value="#itemCat.expense_cat_code#" disabled >
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37431.Kategori Kodu girmelisiniz'></cfsavecontent>
                            <span class="input-group-addon no-bg"></span>
                            <input type="text" name="expense_item_code" id="expense_item_code" placeholder="<cf_get_lang dictionary_id='58234.Bütçe Kalemi'><cf_get_lang dictionary_id='49089. Kodu'>" value="#item_code#" maxlength="50" required="yes" message="#message#"></cfoutput>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-expense_item_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#url.item_id#</cfoutput>">
                            <cfinput type="Text" name="expense_item_name" id="expense_item_name" size="60" value="#get_expense_item_sta.expense_item_name#" maxlength="50" required="Yes">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="EXPENSE_ITEMS" 
                                    column_name="EXPENSE_ITEM_NAME" 
                                    column_id_value="#url.item_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="EXPENSE_ITEM_ID" 
                                    control_type="0">
                                </span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-account_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfset attributes.account_code = get_expense_item_sta.account_code>
                            <cfquery name="get_account_name" datasource="#dsn2#">
                                SELECT ACCOUNT_NAME,ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#attributes.account_code#'		
                            </cfquery>              
                            <input type="hidden" name="account_id" id="account_id" value="<cfoutput>#attributes.account_code#</cfoutput>">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='49155.Muhasebe Kodu Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="account_code" id="account_code" value="#get_account_name.account_code# - #get_account_name.account_name#" required="yes" message="#message#" readonly="yes">
                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=upd_expense_item.account_code&field_id=upd_expense_item.account_id','list')" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                <cfif session.ep.our_company_info.is_efatura>
                    <div class="form-group" id="item-tax_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30006.Vergi Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="tax_code" id="tax_code">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="TAX_CODES">
                                    <option value="#TAX_CODE_ID#;#TAX_CODE_NAME#" title="#detail#" <cfif GET_EXPENSE_ITEM_STA.tax_code eq tax_codes.tax_code_id>selected="selected"</cfif>>#TAX_CODE_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </cfif>
                <div class="form-group" id="item-expense_item_code">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <textarea name="expense_item_detail" id="expense_item_detail"><cfoutput>#get_expense_item_sta.expense_item_detail#</cfoutput></textarea>
                            <span class="input-group-addon">
                                <cf_language_info 
                                table_name="EXPENSE_ITEMS" 
                                column_name="EXPENSE_ITEM_DETAIL" 
                                column_id_value="#url.item_id#" 
                                maxlength="500" 
                                datasource="#dsn#" 
                                column_id="EXPENSE_ITEM_ID" 
                                control_type="0">
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
                <cf_box_footer>
                	<div class="col col-6">
        				<cf_record_info query_name="get_expense_item_sta">	
                    </div>
                    <div class="col col-6">
                    	<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'><!--- Bk kaldirdi 20060725 delete_page_url='#request.self#?fuseaction=budget.popup_del_expense_item&item_id=#url.item_id#' delete_alert='Bu Gider Kategorisini Siliyorsunuz! Emin misiniz?'  --->
                    </div>
                </cf_box_footer>
</cfform>
</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("expense_cat").value == '')
		{
			alert("<cf_get_lang dictionary_id='49177.Bütçe Kategorisi Seçmediniz'> !");
			return false;
		}
        else
            document.getElementById("expense_cat").options[document.getElementById("expense_cat").selectedIndex].disabled=false;
            
		if(document.getElementById("expense_item_name").value =='')
		{
			alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'> !");
			return false;
        }
        if(document.getElementById("account_code").value == '')
		{
			alert("<cf_get_lang dictionary_id='49155.Muhasebe Kodu girmelisiniz'>!");
			return false;
		}
		if(document.getElementById("expense_item_code").value =='')
		{
			alert("<cf_get_lang dictionary_id='33952.Kod Girmelisiniz'> !");			
			return false;
        }
		if(document.getElementById("income_expense").checked == false && document.getElementById("is_expense").checked == false)
		{
			alert("<cf_get_lang dictionary_id='49158.Gelir yada Gider Seçmelisiniz'> !");
			return false;
		}	
		return true;
        	 
	}
</script>
