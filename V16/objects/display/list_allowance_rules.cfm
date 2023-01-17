<!---
    File: list_allowance_expense.cfm
    Author: Esma R. UYSAL
    Date: 18/12/2019 
    Description:
        HArcırah kuralı düşürme popupıdır.
--->
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.field_expense_center_id" default=""><!--- masraf merkezi id--->
<cfparam name="attributes.field_expense_center_name" default=""><!--- masraf merkezi adi--->
<cfparam name="attributes.field_expense_item_id" default=""><!--- gider kalemi id--->
<cfparam name="attributes.field_expense_item_name" default=""><!--- gider kalemi adı--->
<cfparam name="attributes.field_id" default="">
<cfparam name="attributes.field_money_type" default="">
<cfparam name="attributes.field_name" default="">
<cfparam name="attributes.field_tax_exception_amount" default=""><!--- İStisna --->
<cfparam name="attributes.field_tax_exception_money_type" default=""><!---İstisna para birimi --->
<cfparam name="attributes.field_is_country_out" default=""><!--- yurtiçi / yurtdışı--->
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.field_additional_allowance_id" default=""><!---Ek Ödenek ID --->
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.is_popup" default="1">
<cfset attributes.employee_id = listFirst(attributes.employee_id,'_')>
<cfset ExpenseRules= createObject("component","V16.workdata.hr_payroll") />

<cfif len(attributes.employee_id)>
    <cfset employee_position_id = ExpenseRules.get_employee_position(attributes.employee_id)>
<cfelse>
    <cfset employee_position_id = "">
</cfif>
<!--- harcırah kuralları --->
<cfset GET_EXPENSE_RULES=ExpenseRules.GET_EXPENSE_RULES(keyword : attributes.keyword, position_cat_id: employee_position_id ) />
<cfparam name="attributes.totalrecords" default='#GET_EXPENSE_RULES.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent  variable="title"><cf_get_lang dictionary_id='41550.Harcırah Kuralları'></cfsavecontent>
    <cf_box id="list_worknet_search" closable="1" collapsable="0" title='#title#' popup_box="#iif(isDefined("attributes.draggable"),1,0)#">
        <cfform name="list_worknet" id="list_worknet" method="post" action="">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search more="0">
                    <div class="form-group" id="form_ul_keyword">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:100px;" placeholder="#message#">
                    </div>
                    <div class="form-group small" id="form_ul_maxrows">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
                    </div>
                    <cfset send_ = "">
                    <cfif isdefined("attributes.employee_id")><cfset send_ = "#send_#&employee_id=#attributes.employee_id#"></cfif>
                    <cfif isdefined("attributes.is_store_module")><cfset send_ = "#send_#&is_store_module=#attributes.is_store_module#"></cfif>
                    <div class="form-group">
                        <cfif isdefined("attributes.is_popup") and attributes.is_popup neq 1>
                            <cfset search_function = "loader_page2('#send_#')">
                        <cfelse>
                            <cfset search_function = ''>
                        </cfif>
                        <cf_wrk_search_button button_type="4" search_function="#search_function#">
                    </div>
            </cf_box_search>
            <cf_ajax_list>
                <thead>
                    <tr>		
                        <th width="100"><cf_get_lang dictionary_id ="57487.No"></th>
                        <th><cf_get_lang dictionary_id = "41539.Harcırah Tipi"></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif GET_EXPENSE_RULES.recordcount>
                        <cfoutput query="GET_EXPENSE_RULES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#currentrow#</td>
                                <td><a href="javascript://" onclick="add_pro('#EXPENSE_HR_RULES_ID#','#EXPENSE_HR_RULES_DETAIL#','#EXPENSE_ITEM_ID#','#EXPENSE_ITEM_NAME#','#EXPENSE_CENTER#','#EXPENSE#','#daily_pay_max#','#MONEY_TYPE#','#TAX_EXCEPTION_AMOUNT#','#is_country_out#',#additional_allowance_id#);" class="tableyazi">#EXPENSE_HR_RULES_DETAIL#</a></td>
                            </tr>		
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="2" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_ajax_list>
        </cfform>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_string="#attributes.fuseaction#">
            <cfif len(attributes.employee_id)>
                <cfset url_string = "#url_string#&employee_id=#attributes.employee_id#">
            </cfif>
            <cfif len(attributes.keyword)>
                <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined("attributes.is_store_module")>
                <cfset url_string = "#url_string#&is_store_module=#attributes.is_store_module#">
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_string#">
        </cfif>
    </cf_box>
<script>
function loader_page2(_x_)
{    
    adress_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_allowance_rules'+_x_+'&keyword='+document.getElementById('keyword').value+'&is_popup=0';
    AjaxPageLoad(adress_,'warning_modal',1);
    return false;
}
function add_pro(rule_id,rule_description,expense_item_id,expense_item_name,expense_center_id,expense_center_name,expense_total,money_type,tax_exception_amount,is_country_out,additional_allowance_id)
{  
    <cfif isdefined("attributes.is_popup") and attributes.is_popup eq 1>
        <cfif isdefined("attributes.field_id") and len(attributes.field_id)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_id#</cfoutput>").value=rule_id;
        </cfif>
        <cfif isdefined("attributes.field_name") and len(attributes.field_name)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_name#</cfoutput>").value=rule_description;
        </cfif>
        <cfif isdefined("attributes.field_expense_item_id") and len(attributes.field_expense_item_id)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_expense_item_id#</cfoutput>").value=expense_item_id;
        </cfif>
        <cfif isdefined("attributes.field_expense_item_name") and len(attributes.field_expense_item_name)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_expense_item_name#</cfoutput>").value=expense_item_name;
        </cfif>
        <cfif isdefined("attributes.field_expense_center_id") and len(attributes.field_expense_center_id)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_expense_center_id#</cfoutput>").value=expense_center_id;
        </cfif>
        <cfif isdefined("attributes.field_expense_center_name") and len(attributes.field_expense_center_name)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_expense_center_name#</cfoutput>").value=expense_center_name;
        </cfif>
        <cfif isdefined("attributes.field_expense_total") and len(attributes.field_expense_total)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_expense_total#</cfoutput>").value=expense_total;
        </cfif>
        <cfif isdefined("attributes.field_tax_exception_money_type") and len(attributes.field_tax_exception_money_type)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_tax_exception_money_type#</cfoutput>").value=money_type;
        </cfif>
        <cfif isdefined("attributes.field_tax_exception_amount") and len(attributes.field_tax_exception_amount)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_tax_exception_amount#</cfoutput>").value=tax_exception_amount;
        </cfif> 
        <cfif isdefined("attributes.field_is_country_out") and len(attributes.field_is_country_out)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_is_country_out#</cfoutput>").value=is_country_out;
        </cfif>
        <cfif isdefined("attributes.field_additional_allowance_id") and len(attributes.field_additional_allowance_id)>
            window.opener.document.getElementById("<cfoutput>#attributes.field_additional_allowance_id#</cfoutput>").value=additional_allowance_id;
        </cfif>
        <cfif isdefined("attributes.field_money_type") and len(attributes.field_money_type)>
            
            window.opener.$("#<cfoutput>#attributes.field_money_type#</cfoutput>").find('option').each(function() {
                $(this).attr('selected', false);
            });
            window.opener.$("#<cfoutput>#attributes.field_money_type#</cfoutput>").find('option').each(function() {
                split_val = $(this).val();
                split_ = split_val.split(",");
                if(split_[0] == money_type){
                    $(this).attr('selected', true);
                }
            });
        //   window.opener.document.getElementById("<cfoutput>#attributes.field_money_type#</cfoutput>").selectedIndex=1;
        </cfif>
        <cfif isdefined("attributes.call_function")>
            <cfif listlen(attributes.call_function,'-') gt 1>
                <cfloop from="1" to="#listlen(attributes.call_function,'-')#" index="call_i">
                    try{opener.<cfoutput>#listgetat(attributes.call_function,call_i,'-')#</cfoutput>;}
                        catch(e){};
                </cfloop>			
            <cfelse>
                try{opener.<cfoutput>#attributes.call_function#</cfoutput>;}
                catch(e){};
            </cfif>
        </cfif>
        window.close();
    <cfelse>
        <cfif isdefined("attributes.field_id") and len(attributes.field_id)>
            window.document.getElementById("<cfoutput>#attributes.field_id#</cfoutput>").value=rule_id;
        </cfif>
        <cfif isdefined("attributes.field_name") and len(attributes.field_name)>
            window.document.getElementById("<cfoutput>#attributes.field_name#</cfoutput>").value=rule_description;
        </cfif>
        <cfif isdefined("attributes.field_expense_item_id") and len(attributes.field_expense_item_id)>
            window.document.getElementById("<cfoutput>#attributes.field_expense_item_id#</cfoutput>").value=expense_item_id;
        </cfif>
        <cfif isdefined("attributes.field_expense_item_name") and len(attributes.field_expense_item_name)>
            window.document.getElementById("<cfoutput>#attributes.field_expense_item_name#</cfoutput>").value=expense_item_name;
        </cfif>
        <cfif isdefined("attributes.field_expense_center_id") and len(attributes.field_expense_center_id)>
            window.document.getElementById("<cfoutput>#attributes.field_expense_center_id#</cfoutput>").value=expense_center_id;
        </cfif>
        <cfif isdefined("attributes.field_expense_center_name") and len(attributes.field_expense_center_name)>
            window.document.getElementById("<cfoutput>#attributes.field_expense_center_name#</cfoutput>").value=expense_center_name;
        </cfif>
        <cfif isdefined("attributes.field_expense_total") and len(attributes.field_expense_total)>
            window.document.getElementById("<cfoutput>#attributes.field_expense_total#</cfoutput>").value=expense_total;
        </cfif>
        <cfif isdefined("attributes.field_tax_exception_money_type") and len(attributes.field_tax_exception_money_type)>
            window.document.getElementById("<cfoutput>#attributes.field_tax_exception_money_type#</cfoutput>").value=money_type;
        </cfif>
        <cfif isdefined("attributes.field_tax_exception_amount") and len(attributes.field_tax_exception_amount)>
            window.document.getElementById("<cfoutput>#attributes.field_tax_exception_amount#</cfoutput>").value=tax_exception_amount;
        </cfif> 
        <cfif isdefined("attributes.field_is_country_out") and len(attributes.field_is_country_out)>
            window.document.getElementById("<cfoutput>#attributes.field_is_country_out#</cfoutput>").value=is_country_out;
        </cfif>
        <cfif isdefined("attributes.field_additional_allowance_id") and len(attributes.field_additional_allowance_id)>
            window.document.getElementById("<cfoutput>#attributes.field_additional_allowance_id#</cfoutput>").value=additional_allowance_id;
        </cfif>
        <cfif isdefined("attributes.field_money_type") and len(attributes.field_money_type)>
            
            window.$("#<cfoutput>#attributes.field_money_type#</cfoutput>").find('option').each(function() {
                $(this).attr('selected', false);
            });
            window.$("#<cfoutput>#attributes.field_money_type#</cfoutput>").find('option').each(function() {
                split_val = $(this).val();
                split_ = split_val.split(",");
                if(split_[0] == money_type){
                    $(this).attr('selected', true);
                }
            });
        //   window.document.getElementById("<cfoutput>#attributes.field_money_type#</cfoutput>").selectedIndex=1;
        </cfif>
        <cfif isdefined("attributes.call_function")>
            <cfif listlen(attributes.call_function,'-') gt 1>
                <cfloop from="1" to="#listlen(attributes.call_function,'-')#" index="call_i">
                    try{<cfoutput>#listgetat(attributes.call_function,call_i,'-')#</cfoutput>;}
                        catch(e){};
                </cfloop>			
            <cfelse>
                try{<cfoutput>#attributes.call_function#</cfoutput>;}
                catch(e){};
            </cfif>
        </cfif>
        window.document.getElementById('warning_modal').style.display = 'none';
    </cfif>
}

</script> 