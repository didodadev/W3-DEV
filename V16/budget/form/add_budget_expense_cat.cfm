<cfscript>
    cfc = createObject("component", "V16.budget.cfc.budget_expense_cat");
    BudgetCats = cfc.GetBudgetCats();
</cfscript>
<cfparam name="attributes.upper_cat" default="">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57964.Hedefler'></cfsavecontent>
<cf_box title="#message#" closable="0">
<cfform name="add_expense_cat" method="post" action="#request.self#?fuseaction=budget.emptypopup_add_expense_cat">
    <cfoutput>
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-expense_is_hr">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29661.HR - İK'><input type="checkbox" name="expence_is_hr" id="expence_is_hr" value="1"></label>
                </div>
                <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="item-expense_is_training">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'><input type="checkbox" name="expence_is_training" id="expence_is_training" value="1"></label>
                </div>
            </div>
            <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-budget_cat_hierarchy">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
                    <div class="col col-9 col-xs-12">
                        <select name="budget_cat_hierarchy" id="budget_cat_hierarchy" value="<cfif len(attributes.upper_cat)>#attributes.upper_cat#</cfif>" onchange="document.getElementById('head_cat_code').value = document.add_expense_cat.budget_cat_hierarchy[document.add_expense_cat.budget_cat_hierarchy.selectedIndex].value;" style="width:175px;">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="BudgetCats">
                                <option value="#expense_cat_code#"<cfif len(attributes.upper_cat) and compare(upper_cat,budget_cat_hierarchy) eq 0> selected</cfif>>
                                <cfif ListLen(expense_cat_code,".") neq 1>
                                    <cfloop from="1" to="#ListLen(expense_cat_code,".")#" index="i">&nbsp;</cfloop>
                                </cfif>
                                #expense_cat_code# #expense_cat_name#</option>
                            </cfloop> 
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-head_cat_code">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='32775.Kategori Kodu'>*</label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="placeholder"><cf_get_lang dictionary_id='57986.Alt'> <cf_get_lang dictionary_id='57559.Bütçe'> <cf_get_lang dictionary_id='32775.Kategori Kodu	'></cfsavecontent>
                            <input type="text" name="head_cat_code" id="head_cat_code" placeholder=" #placeholder#" value="<cfif len(attributes.upper_cat)>#attributes.upper_cat#</cfif>" disabled style="width:74px;">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37431.Kategori Kodu Girmelisiniz'></cfsavecontent>
                            <span class="input-group-addon no-bg"></span>
                            <cfsavecontent variable="placeholder2"><cf_get_lang dictionary_id='57559.Bütçe'> <cf_get_lang dictionary_id='32775.Kategori Kodu'></cfsavecontent>
                            <input type="text" name="expense_cat_code" id="expense_cat_code" placeholder="#placeholder2#" value="" maxlength="50" required="yes" message="#message#" style="width:98px;">
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-expense_cat_name">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                    <div class="col col-9 col-xs-12">
                        <input type="text" name="expense_cat_name" id="expense_cat_name" >
                    </div>
                </div>
                <div class="form-group" id="item-expense_cat_detail">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-9 col-xs-12">
                        <textarea name="expense_cat_detail" id="expense_cat_detail"></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol()">
        </cf_box_footer>
    </cfoutput>
</cfform>
<script type="text/javascript">
function kontrol()
{
	if(add_expense_cat.expense_cat_name.value =='')
	{
		alert("<cf_get_lang dictionary_id='49135.Kategori Girmelisiniz'> !");			
		return false;
    }
    <!---
	if(add_expense_cat.expense_cat_code.value =='')
	{
		alert("<cf_get_lang dictionary_id='33952.Kod Girmelisiniz'> !");			
		return false;
    }
    --->
	return true;
}
</script>
