<cfset ExpenseRules= createObject("component","V16.hr.ehesap.cfc.expense_rules") />
<cfparam name="attributes.expense_hr_rules_id">
<cfset get_money=ExpenseRules.GET_MONEY() />
<cfset get_expense_rules=ExpenseRules.GET_EXPENSE_RULES(attributes.expense_hr_rules_id) />
<cfinclude template="../../query/get_position_cats.cfm">
<cf_get_lang_set module_name="ehesap">
    <cfform name="upd_expense_rules" action=""  method="post" enctype="multipart/form-data">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id="41550.Harcırah Kuralları"></cfsavecontent>
        <cf_box title="#message#" add_href="#request.self#?fuseaction=ehesap.list_expense_rules" closable="0" collapsed="0">
            <div class="row" type="row">
                <div class="col col-3 col-xs-12">
                    <div class="scrollbar" style="max-height:357px;overflow:auto;">
                        <div id="cc">
                            <cfinclude template="/V16/hr/ehesap/display/list_expense_rules.cfm">
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-xs-12">	
                    <div class="form-group" id="item-active">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57493.Aktif"></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_active" id="is_active" <cfif get_expense_rules.is_active eq 1>checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58233.Tanım"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="expense_hr_rules_detail" id="expense_hr_rules_detail" value="<cfoutput>#get_expense_rules.expense_hr_rules_detail#</cfoutput>">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="EXPENSE_HR_RULES" 
                                    column_name="EXPENSE_HR_RULES_DETAIL" 
                                    column_id_value="#url.expense_hr_rules_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="EXPENSE_HR_RULES_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_hr_rules_description">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <textarea type="text" name="expense_hr_rules_description" id="expense_hr_rules_description"><cfoutput>#get_expense_rules.expense_hr_rules_description#</cfoutput></textarea>
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="EXPENSE_HR_RULES" 
                                    column_name="EXPENSE_HR_RULES_DESCRIPTION" 
                                    column_id_value="#url.expense_hr_rules_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="EXPENSE_HR_RULES_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_country_out">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58664.Yer"></label>
                        <div class="col col-4 col-xs-12">                                    
                            <input type="radio" name="is_country_out" id="is_country_out" value="0" <cfif get_expense_rules.is_country_out eq 0>checked</cfif>>
                            <label><cf_get_lang dictionary_id='29691.Yurtiçi'></label>
                        </div>
                        <div class="col col-4 col-xs-12">                                       
                            <input type="radio" name="is_country_out" id="is_country_out" value="1" <cfif get_expense_rules.is_country_out eq 1>checked</cfif>>
                            <label><cf_get_lang dictionary_id='29692.Yurtdışı'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-rule_start_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49335.Yürürlük Tarihi"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">                                    
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="49335.Yürürlük Tarihi"></cfsavecontent>
                                <cfinput value="#dateformat(get_expense_rules.rule_start_date,dateformat_style)#"  type="text" name="rule_start_date" id="rule_start_date" validate="#validate_style#" message="#alert#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="rule_start_date"></span>
                            </div>          
                        </div>
                    </div>
                    <div class="form-group" id="item-is_stamp_tax">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41439.Damga Vergisi"><cf_get_lang dictionary_id="32924.Dahil"></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_stamp_tax" id="is_stamp_tax" value="0" <cfif get_expense_rules.is_stamp_tax eq 1>checked</cfif>>       
                        </div>
                    </div>
                    <div class="form-group" id="item-is_income_tax_include">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53249.Gelir Vergisi Matrahı"><cf_get_lang dictionary_id="32924.Dahil"></label>
                        <div class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_income_tax_include" id="is_income_tax_include" value="0" <cfif get_expense_rules.is_income_tax_include eq 1>checked</cfif>>       
                        </div>
                    </div>
                    <div class="form-group" id="item-tax_rank_factor">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36455.Harcırah Katsayısı"></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="tax_rank_factor" id="tax_rank_factor"  value="#get_expense_rules.tax_rank_factor#">       
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-xs-12">
                    <div class="form-group" id="item-expense_hr_rules_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41539.Harcırah Tipi"></label>
                        <div class="col col-8 col-xs-12">
                            <cfselect name="expense_rules_type" id="expense_hr_rules_type">
                                <option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <option value="1"<cfif get_expense_rules.expense_hr_rules_type eq 1>selected</cfif>><cf_get_lang dictionary_id="47281.Yevmiye"></option>
                                <option value="2"<cfif get_expense_rules.expense_hr_rules_type eq 2>selected</cfif>><cf_get_lang dictionary_id="41745.Yol Masrafı"></option>
                                <option value="3"<cfif get_expense_rules.expense_hr_rules_type eq 3>selected</cfif>><cf_get_lang dictionary_id="41739.Aile Masrafı"></option>
                                <option value="4"<cfif get_expense_rules.expense_hr_rules_type eq 4>selected</cfif>><cf_get_lang dictionary_id="41748.Yer Değiştirme"></option>
                            </cfselect>       
                        </div>
                    </div>
                    <div class="form-group" id="item-daily_pay_max">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57673.Tutar"></label>
                        <div class="col col-5 col-xs-12">
                            <input class="box" type="text" name="daily_pay_max" id="daily_pay_max"  value="<cfoutput>#TLFormat(get_expense_rules.daily_pay_max)#</cfoutput>"  onkeyup="return(FormatCurrency(this,event))" >
                        </div>                    
                        <div class="col col-3 col-xs-12">                                                                      
                            <cfselect name="money_type" id="money_type">
                                <cfoutput query="get_money">                                     
                                    <option value="#MONEY#" <cfif get_expense_rules.MONEY_TYPE eq MONEY>selected</cfif>>#MONEY#</option>                                                                             
                                </cfoutput>
                            </cfselect>                                   
                        </div>
                    </div>

                    <div class="form-group" id="item-first_level_day_max">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57490.Gün"></label>
                        <div class="col col-4 col-xs-12">
                            <input type="text" name="first_level_day_max" id="first_level_day_max" value="<cfoutput>#get_expense_rules.first_level_day_max#</cfoutput>">
                        </div>
                        <label class="col col-1 bold text-center margin-top-5">%</label>
                        <div class="col col-3 col-xs-12">
                            <input type="text" name="first_level_pay_rate" id="first_level_pay_rate" value="<cfoutput>#get_expense_rules.first_level_pay_rate#</cfoutput>">
                        </div>
                      
                    </div>
                    <div class="form-group" id="item-second_level">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58909.Max"><cf_get_lang dictionary_id="57490.Gün"></label>
                        <div class="col col-4 col-xs-12">
                            <input type="text" name="second_level_day_max" id="second_level_day_max" value="<cfoutput>#get_expense_rules.second_level_day_max#</cfoutput>">
                        </div>
                        <label class="col col-1 bold text-center margin-top-5">%</label>
                        <div class="col col-3 col-xs-12">
                            <input type="text" name="second_level_pay_rate" id="second_level_pay_rate" value="<cfoutput>#get_expense_rules.second_level_pay_rate#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-tax_exception_amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53017.Vergi İstisna"><cf_get_lang dictionary_id="57673.Tutar"></label>
                        <div class="col col-5 col-xs-12">
                            <input class="box" type="text" name="tax_exception_amount" id="tax_exception_amount"  value="<cfoutput>#TLFormat(get_expense_rules.tax_exception_amount)#</cfoutput>" onkeyup="return(FormatCurrency(this,event))">
                        </div>
                        <div class="col col-3 col-xs-12">                                                                      
                            <cfselect name="tax_exception_money_type" id="tax_exception_money_type">
                                <cfoutput query="get_money">                                     
                                    <option value="#MONEY#" <cfif get_expense_rules.tax_exception_money_type eq MONEY>selected</cfif>>#MONEY#</option>                                                                             
                                </cfoutput>
                            </cfselect>                                   
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_item_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58551.Gider Kalemi"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cf_wrk_expense_items form_name='upd_expense_rules' expense_item_id='expense_item_id' expense_item_name='expense_item_name'>
                                <input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#get_expense_rules.expense_item_id#</cfoutput>">
                                <input type="text" name="expense_item_name" value="<cfoutput>#get_expense_rules.expense_item_name#</cfoutput>" onKeyUp="get_expense_item();" style="width:175px;">
                                <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=upd_expense_rules.expense_item_id&field_name=upd_expense_rules.expense_item_name','list');"></a>                                       
                            </div>
                        </div>                              
                    </div>
                    <div class="form-group" id="item-expense_center">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58460.Masraf Merkezi"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cf_wrk_expense_centers form_name='upd_expense_rules' expense_center_id='expense_center_id' expense_center_name='expense_center_name'>
                                <input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput>#get_expense_rules.expense_center#</cfoutput>">
                                <input type="text" name="expense_center_name"  value="<cfoutput>#get_expense_rules.expense#</cfoutput>" onKeyUp="get_expense_center();" style="width:175px;" >
                                <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=upd_expense_rules.expense_center_name&field_id=upd_expense_rules.expense_center_id&is_invoice=1</cfoutput>','list');"></a>    
                            </div>
                        </div>                              
                    </div>
                </div>
                <div class="col col-3 col-xs-12">
                    <div class="form-group" id="item-get_titles">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57779.Pozisyon Tipi"></label>
                        <div class="col col-12 col-xs-12">
                            <cfquery name="get_title" datasource="#dsn#">
                                SELECT POSITION_CAT_ID FROM MARCHING_MONEY_POSITION_CATS  WHERE EXPENSE_HR_RULES_ID = '#attributes.expense_hr_rules_id#'
                            </cfquery>
                            <select name="titles" id="titles"  multiple="multiple" style="height:300px;">
                                <cfoutput query="GET_POSITION_CATS">                                        
                                    <option value="#POSITION_CAT_ID#"<cfif listlen(valuelist(get_title.POSITION_CAT_ID,',')) and listfind(valuelist(get_title.POSITION_CAT_ID,','),POSITION_CAT_ID,',')>selected</cfif>>#POSITION_CAT#</option>                                        
                                </cfoutput>                                                                        
                            </select>       
                        </div>
                    </div>   
                </div>
            </div>    
            <cf_box_footer>
                <cf_record_info query_name="get_expense_rules">
                <cf_workcube_buttons type_format='1' is_upd='1' is_delete = '0'  add_function="upd_form()">
            </cf_box_footer>
        </cf_box>
    </cfform>
<script>


    function upd_form(){
        
        if(document.getElementById("is_active").checked)
            is_active = 1;
        else
            is_active = 0;

        if(document.getElementById("is_stamp_tax").checked)
            is_stamp_tax = 1;
        else
            is_stamp_tax = 0;

        if(document.getElementById("is_income_tax_include").checked)
            is_income_tax_include = 1;
        else
            is_income_tax_include = 0;

        if(document.getElementById("is_country_out").checked)
            is_country_out = 0;
        else
            is_country_out = 1;
   
        expense_hr_rules_type = document.getElementById("expense_hr_rules_type").value;
        expense_hr_rules_description = document.getElementById("expense_hr_rules_description").value;
        expense_hr_rules_detail = document.getElementById("expense_hr_rules_detail").value;
        daily_pay_max = parseFloat(filterNum(document.getElementById("daily_pay_max").value));
        money_type= document.getElementById("money_type").value;
        first_level_day_max= document.getElementById("first_level_day_max").value;
        first_level_pay_rate= document.getElementById("first_level_pay_rate").value;
        second_level_day_max= document.getElementById("second_level_day_max").value;
        second_level_pay_rate= document.getElementById("second_level_pay_rate").value;
        rule_start_date= document.getElementById("rule_start_date").value;
        tax_exception_amount= parseFloat(filterNum(document.getElementById("tax_exception_amount").value));
        tax_exception_money_type= document.getElementById("tax_exception_money_type").value;
        tax_rank_factor= document.getElementById("tax_rank_factor").value;
        expense_center= document.getElementById("expense_center_id").value;
        expense_item_id= document.getElementById("expense_item_id").value;
        expense_hr_rules_id='<cfoutput>#attributes.expense_hr_rules_id#</cfoutput>';
        title_id = "";

        $.each($('#titles').val(), function( index, value ) {
            title_id += value;
            if(index < $('#titles').val().length-1) title_id += ',';
        });

        if (isNaN(daily_pay_max)) {

            daily_pay_max = document.getElementById("daily_pay_max").value;
        }

        if (isNaN(tax_exception_amount)) {
            
            tax_exception_amount = document.getElementById("tax_exception_amount").value;
        }
            
        if(expense_hr_rules_detail == "")
		{									
                alert("<cf_get_lang dictionary_id='43223.Tanım Giriniz !'>");
                $('#expense_hr_rules_detail').focus();
				return false;	
        }  

        if(expense_hr_rules_type == 0)
		{									
                alert("<cf_get_lang dictionary_id='41539.Harcırah Tipi'> <cf_get_lang dictionary_id='57734.Seçiniz !'>");                   
                $('#expense_hr_rules_type').focus();
				return false;	
        }  

        $.ajax({ 
            type:'POST',  
            url:'V16/hr/ehesap/cfc/expense_rules.cfc?method=UPDATE_EXPENSE_RULES',
            data: { 
                expense_hr_rules_type : expense_hr_rules_type,
                expense_hr_rules_description : expense_hr_rules_description,
                expense_hr_rules_detail : expense_hr_rules_detail,
                daily_pay_max : daily_pay_max,
                money_type : money_type,
                first_level_day_max : first_level_day_max,
                first_level_pay_rate : first_level_pay_rate,
                second_level_day_max : second_level_day_max,
                second_level_pay_rate : second_level_pay_rate,
                rule_start_date : rule_start_date,
                tax_exception_amount : tax_exception_amount,
                tax_exception_money_type : tax_exception_money_type,
                is_income_tax_include : is_income_tax_include,
                is_stamp_tax : is_stamp_tax,
                tax_rank_factor : tax_rank_factor,
                expense_center : expense_center,
                expense_item_id : expense_item_id,
                is_country_out : is_country_out,
                is_active : is_active,
                title_id : title_id,
                expense_hr_rules_id : expense_hr_rules_id
            },
            success: function (returnData) { 
                 window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_expense_rules&event=upd&expense_hr_rules_id=#expense_hr_rules_id#</cfoutput>';
                 return true;
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        }); 
        return false;
    }
    </script>  