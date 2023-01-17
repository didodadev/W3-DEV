<cfinclude template="../query/get_expense_cat_list.cfm">
<cfscript>
    cfc = createObject("component", "V16.budget.cfc.budget_expense_cat");
    BudgetCats = cfc.GetBudgetCats();
    get_category_ids = cfc.GetIemsBudgetCats(cat_id:attributes.cat_id);
</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57964.Hedefler'></cfsavecontent>
<cf_box title="#message#" closable="0">
<cfform name="upd_expense_cat" method="post" action="#request.self#?fuseaction=budget.emptypopup_upd_expense_cat">
    <input type="hidden" name="cat_id" id="cat_id" value="<cfoutput>#attributes.cat_id#</cfoutput>">
    <cfif len(get_expense_cat_list.expense_cat_code)>
        <cfset cat_code=listlast(get_expense_cat_list.expense_cat_code,".")>
        <cfset ust_cat_code=listdeleteat(get_expense_cat_list.expense_cat_code,ListLen(get_expense_cat_list.expense_cat_code,"."),".")>
    <cfelse>
        <cfset cat_code = "">
        <cfset ust_cat_code = "" >
    </cfif>
    <cfoutput>
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-expense_is_hr">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29661.HR - İK'><input type="checkbox" name="expence_is_hr" id="expence_is_hr" value="1" <cfif get_expense_cat_list.expence_is_hr eq 1>checked</cfif>></label>
                </div>
                <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-expense_is_training">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'><input type="checkbox" name="expence_is_training" id="expence_is_training" value="1" <cfif get_expense_cat_list.expence_is_training eq 1>checked</cfif>></label>
                </div>
            </div>
            <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-budget_cat_hierarchy">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
                    <div class="col col-9 col-xs-12">
                        <select name="budget_cat_hierarchy" id="budget_cat_hierarchy" value="" onchange="document.upd_expense_cat.head_cat_code.value=document.upd_expense_cat.budget_cat_hierarchy[document.upd_expense_cat.budget_cat_hierarchy.selectedIndex].value;" style="width:175px;" <cfif get_category_ids.recordcount> disabled </cfif>>
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="BudgetCats">
                                <cfif expense_cat_code is not get_expense_cat_list.expense_cat_code>
                                    <option value="#expense_cat_code#"<cfif compare(ust_cat_code,expense_cat_code) eq 0 and len(ust_cat_code) eq len(expense_cat_code)> selected</cfif>>
                                    <cfif ListLen(expense_cat_code,".") neq 1>
                                        <cfloop from="1" to="#ListLen(expense_cat_code,".")#" index="i">&nbsp;</cfloop>
                                    </cfif>
                                    #expense_cat_code# #expense_cat_name#</option>
                                </cfif>
                            </cfloop> 
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-head_cat_code">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='32775.Kategori Kodu'>*</label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="placeholder"><cf_get_lang dictionary_id='57986.Alt'> <cf_get_lang dictionary_id='57559.Bütçe'> <cf_get_lang dictionary_id='32775.Kategori Kodu	'></cfsavecontent>
                            <input type="text" name="head_cat_code" id="head_cat_code" placeholder="#placeholder#" value="#ust_cat_code#" disabled style="width:74px;">
                            <span class="input-group-addon no-bg"></span>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37431.Kategori Kodu Girmelisiniz'></cfsavecontent>
                            <cfsavecontent variable="placeholder"><cf_get_lang dictionary_id='57559.Bütçe'> <cf_get_lang dictionary_id='32775.Kategori Kodu'></cfsavecontent>
                            <input type="text" name="expense_cat_code" id="expense_cat_code" placeholder="#placeholder#" value="#cat_code#" maxlength="50" required="yes" message="#message#" style="width:98px;">
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-expense_cat_name">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="expense_cat_id" id="expense_cat_id" value="#attributes.cat_id#">
                            <cfinput type="Text" name="expense_cat_name" id="expense_cat_name" size="60" value="#get_expense_cat_list.expense_cat_name#" maxlength="50" required="Yes">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="EXPENSE_CATEGORY" 
                                    column_name="EXPENSE_CAT_NAME" 
                                    column_id_value="#url.cat_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="EXPENSE_CAT_ID" 
                                    control_type="0">
                                </span>
                        </div>	
                    </div>
                </div>
                <div class="form-group" id="item-expense_cat_detail">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-9 col-xs-12">
                        <textarea name="expense_cat_detail" id="expense_cat_detail">#get_expense_cat_list.expense_cat_detail#</textarea>
                    </div>
                </div>
                
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name="get_expense_cat_list">
            </div>
            <div class="col col-6">
                <cfsavecontent variable="message">#getLang('ehesap',1309)#</cfsavecontent>
                <cfif get_category_ids.recordcount>
                    <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function='kontrol()'>
                <cfelse>
                    <cf_workcube_buttons type_format="1" is_upd='1' is_delete='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=budget.emptypopup_budget_expense_cat_del&cat_id=#attributes.cat_id#' delete_alert="#message#">
                </cfif>
            </div>
        </cf_box_footer>
    </cfoutput>

</cfform>

<script type="text/javascript">
    <cfif get_category_ids.recordcount>               
        alert('<cf_get_lang dictionary_id="59983.Bu Kategoriye Bağlı Bütçe Kalemi var.Kategori Kodunu Değiştiremezsiniz!!!">');
    </cfif>
function kontrol()
{
	if(upd_expense_cat.expense_cat_name.value =='')
	{
		alert("<cf_get_lang dictionary_id='49130.Kategori Girmelisiniz'>");			
		return false;
    }
    <!---
	if(upd_expense_cat.expense_cat_code.value =='')
	{
		alert("<cf_get_lang dictionary_id='33952.Kod Girmelisiniz'> !");			
		return false;
    }
    --->
	return true;

    
}


</script>
