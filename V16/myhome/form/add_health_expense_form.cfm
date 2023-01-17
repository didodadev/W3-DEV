<!---
    File: health_expense_form.cfm
    Controller: HealthExpenseController.cfm
    Folder: myhome\form\add_health_expense_form.cfm
    Author: Pınar Yıldız, Botan Kayğan, Esma Uysal
    Date: 2019-12-01 14:23:21
    Description:     
    History:      
    To Do:
--->
<cf_xml_page_edit fuseact="hr.health_expense_approve">
<cfif (not isDefined("x_rnd_nmbr")) or (isDefined("x_rnd_nmbr") and not len(x_rnd_nmbr))>
    <cfset x_rnd_nmbr = 2>
</cfif>
<cf_catalystHeader>
<cfparam name="expense_date" default="#now()#" />
<cfparam name="health_id" default="" />
<cfparam name="attributes.expense_id" default="" />
<cfparam name="attributes.expense_employee_id" default="#session.ep.userid#" />
<cf_papers paper_type="health_allowence_expense">
<cfset HealthExpense= createObject("component","V16.myhome.cfc.health_expense") />

<cfif listfirst(attributes.fuseaction,'.') eq 'myhome'>
    <cfset is_requested = 1>
<cfelse>
    <cfset is_requested = ''>
</cfif>
<cfset get_assurance = HealthExpense.GetAssurance(is_requested : is_requested) />

<cfset get_tax = HealthExpense.GetTax() />
<cfset GET_DOCUMENT_TYPE = HealthExpense.GET_DOCUMENT_TYPE(fuseaction: fuseaction) />
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1,comp_id : session.ep.company_id)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department()>
<cfif isDefined("attributes.expense_id") and len(attributes.expense_id)>
    <cfquery name="get_expense" datasource="#dsn2#">
        SELECT EIP.ACC_TYPE_ID, EIP.SYSTEM_RELATION, EIP.EMP_ID, EIP.BRANCH_ID, EIP.TOTAL_AMOUNT, EIP.KDV_TOTAL, EIP.TOTAL_AMOUNT_KDVLI, EIP.EXPENSE_DATE, EIP.CH_CONSUMER_ID, EIP.CH_EMPLOYEE_ID,EIP.CH_COMPANY_ID,EIP.SERIAL_NO ,EIP.CH_PARTNER_ID ,EIP.SERIAL_NUMBER ,(SELECT top 1 MONEY_CURRENCY_ID FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">) AS MONEY_CURRENCY_ID FROM EXPENSE_ITEM_PLANS EIP WHERE EIP.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
    </cfquery>
</cfif>
<cfif not isdefined("x_kdv_inpterrupt")>
    <cfset x_kdv_inpterrupt = 1>
</cfif>
<cfinclude template="../../product/query/get_money.cfm">
<cfscript>
    Position_Assistant= createObject("component","V16.hr.ehesap.cfc.position_assistant");
    get_modules_no = Position_Assistant.GET_MODULES_NO(fuseaction:attributes.fuseaction)
</cfscript>

<cfif listfirst(attributes.fuseaction,'.') eq 'myhome'>
    <div class="col col-9 col-xs-12">
<cfelse>
    <div class="col col-12 col-xs-12">
</cfif>
        <cf_box closable="0">
            <cfform name="add_health_expense" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_health_expense_form">
                <input type="hidden" name="expense_id" id="expense_id" value="<cfoutput>#attributes.expense_id#</cfoutput>">
                <input type="hidden" name="expense_type" id="expense_type" value="2">
                <cfinput type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                <cfinput type="hidden" name="x_is_employee_amount" id="x_is_employee_amount" value="#x_is_employee_amount#">
                <cfinput type="hidden" name="x_is_employee_payment" value="#x_is_employee_payment#">
                <cfinput type="hidden" name="x_is_employee_relative_payment" value="#x_is_employee_relative_payment#">
                <cfinput type="hidden" name="x_acc_type" value="#x_acc_type#">
                <cfinput type="hidden" name="x_kdv_inpterrupt" value="#x_kdv_inpterrupt#">
                <cfinput type="hidden" name="x_is_limit_interruption" value="#x_is_limit_interruption#">
                <cfif isdefined("x_decease_reason")>
                    <cfinput type="hidden" name="x_decease_reason" value="#x_decease_reason#">
                </cfif>
                <cfinput type="hidden" id="dept_id" name="dept_id" value="">
                <cfif isdefined("attributes.health_id") and len(attributes.health_id)>
                    <cfinput type="hidden" name="health_id" id="health_id" value="#attributes.health_id#">
                </cfif>
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
                            <div class="form-group" id="item_process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat slct_width="135">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-expense_stage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'> *</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='120' is_detail='0'>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_employee">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfif fusebox.circuit is 'myhome'><cfoutput>#attributes.expense_employee_id#</cfoutput><cfelseif isdefined("get_expense")><cfoutput>#get_expense.EMP_ID#</cfoutput></cfif>">
                                    <input type="text" name="expense_employee" id="expense_employee" style="width:120px;" value="<cfif fusebox.circuit is 'myhome'><cfoutput>#get_emp_info(attributes.expense_employee_id,0,0)#</cfoutput><cfelseif isdefined("get_expense")><cfoutput>#get_emp_info(get_expense.emp_id,0,0)#</cfoutput></cfif>" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" <cfif fusebox.circuit neq 'myhome'>onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=add_health_expense.expense_employee_id&field_name=add_health_expense.expense_employee&field_type=add_health_expense.expense_employee_id&field_dep_id=add_health_expense.dept_id&field_branch_id=add_health_expense.branch_id&call_function=change_dept()&select_list=1,9','list');"
                                    <cfelse>
                                        onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=add_health_expense.expense_employee_id&field_name=add_health_expense.expense_employee&field_type=add_health_expense.expense_employee_id&field_dep_id=add_health_expense.dept_id&field_branch_id=add_health_expense.branch_id&call_function=change_dept()&is_position_assistant=1&module_id=<cfoutput>#get_modules_no.module_no#</cfoutput>&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1&show_rel_pos=1','list');"
                                    </cfif>>
                                </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" <cfif listfirst(attributes.fuseaction,'.') eq 'myhome'>disabled</cfif>>
                                    <cfoutput query="get_branches" group="NICK_NAME">
                                        <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                        <cfoutput>
                                            <option value="#get_branches.BRANCH_ID#"<cfif listlast(session.ep.user_location,'-') eq get_branches.branch_id and listfirst(attributes.fuseaction,'.') eq 'myhome'> selected<cfelseif isDefined("get_expense.branch_id") and get_expense.branch_id eq get_branches.branch_id>selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                        </cfoutput>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-8 col-xs-12" id="department_div">
                                <select name="DEPARTMENT_ID" id="DEPARTMENT_ID" <cfif listfirst(attributes.fuseaction,'.') eq 'myhome' and listfirst(attributes.fuseaction,'.') eq 'myhome'>disabled</cfif>> 
                                    <option value=""><cf_get_lang_main no='160.Departman'></option>
                                    <cfif listfirst(attributes.fuseaction,'.') eq 'myhome' and listfirst(attributes.fuseaction,'.') eq 'myhome'>   
                                        <cfoutput query="get_department">
                                            <option value="#department_id#" <cfif listfirst(session.ep.user_location,'-') eq get_department.department_id>selected</cfif>>#department_head#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33203.Belge Tarihi"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>   
                                        <input type="text" name="expense_date" id="expense_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" required="yes" message="#alert#" readonly maxlength="10" style="width:120px;" onblur="change_money_info('add_health_expense','expense_date');changeProcessDate();">
                                        <span class="input-group-addon btnPointer">
                                            <cf_wrk_date_image date_field="expense_date" call_function="change_money_info&changeProcessDate">
                                        </span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz !'></cfsavecontent>
                                    <cfinput type="text" name="process_date" style="width:100px;" required="Yes" message="#message#" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#"  passthrough="onBlur=""change_money_info('add_health_expense','process_date');""">
                                    <span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date" call_function="change_money_info"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-expense_paper_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58578.Belge Türü'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="expense_paper_type" id="expense_paper_type">
                                    <option value=""><cf_get_lang dictionary_id='58578.Belge Türü'></option>
                                    <cfoutput query="get_document_type">
                                        <option value="#document_type_id#">#document_type_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-paper_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label> 
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="paper_number" id="paper_number" value="<cfoutput>#paper_code & '-' & paper_number#</cfoutput>">
                            </div>
                        </div>
                        <cfif not len(attributes.expense_id)>
                            <div class="form-group" id="item-expense_company">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59941.Tedavi Yapan Kurum"></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="expense_comp_name" id="expense_comp_name" <cfif isDefined("x_company_firm_type") and len(x_company_firm_type)>onFocus="AutoComplete_Create('expense_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\',\'\',\'\',\'<cfoutput>#x_company_firm_type#</cfoutput>\'','','','','3','250','return_company()','','1');"</cfif>>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-system_relation">
                            <label class="col col-4 col-xs-12">
                                <cfif not len(attributes.expense_id)>
                                    <cf_get_lang dictionary_id="58133.Fatura No">
                                <cfelse>
                                    <cf_get_lang dictionary_id='60244.Kaynak Belge No'>
                                </cfif>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <input name="system_relation" id="system_relation" type="text" value="<cfif isdefined("get_expense") and len(get_expense.SYSTEM_RELATION)><cfoutput>#get_expense.SYSTEM_RELATION#</cfoutput></cfif>">
                            </div>
                        </div>
                        <cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>
                            <cfoutput>
                                <div class="form-group" id="item-ch_member_type2">
                                    <font color ="##E08283"><b><cf_get_lang dictionary_id="59585.Anlaşmalı kurum"></b></font>
                                </div>
                                <div class="form-group" id="item-ch_member_type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59585.Anlaşmalı kurum"></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfset emp_id = get_expense.ch_employee_id>
                                            <cfif len(get_expense.acc_type_id)>
                                                <cfset emp_id = "#emp_id#_#get_expense.acc_type_id#">
                                            </cfif>
                                            <cfif len(get_expense.ch_company_id)>
                                                <cfset ch_member_type="partner">
                                            <cfelseif len(get_expense.ch_consumer_id)>
                                                <cfset ch_member_type="consumer">
                                            <cfelseif len(get_expense.ch_employee_id)>
                                                <cfset ch_member_type="employee">
                                            <cfelse>
                                                <cfset ch_member_type="">
                                            </cfif>
                                            <input type="hidden" name="ch_member_type" id="ch_member_type" value="#ch_member_type#">
                                            <input type="hidden" name="ch_company_id" id="ch_company_id" value="#get_expense.ch_company_id#">
                                            <input type="hidden" name="ch_partner_id" id="ch_partner_id" value="<cfif ch_member_type eq "partner">#get_expense.ch_partner_id#<cfelseif ch_member_type eq "consumer">#get_expense.ch_consumer_id#_#get_expense.acc_type_id#</cfif>">
                                            <input type="hidden" name="emp_id" id="emp_id" value="#emp_id#">
                                            <input type="text" name="ch_company" id="ch_company" style="width:135px;" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','return_company()');" value="<cfif ch_member_type eq 'partner'>#get_par_info(get_expense.ch_company_id,1,1,0)#<cfelseif ch_member_type eq 'consumer'>#get_cons_info(get_expense.ch_consumer_id,0,0)#<cfelseif ch_member_type eq 'employee'>#get_emp_info(get_expense.ch_employee_id,0,0,0,get_expense.acc_type_id)#</cfif>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_id=add_health_expense.ch_partner_id&field_name=add_health_expense.ch_company&field_comp_name=add_health_expense.ch_company&field_comp_id=add_health_expense.ch_company_id&field_type=add_health_expense.ch_member_type&field_emp_id=add_health_expense.emp_id&call_function=change_due_date()<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3,9','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-serial_number">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58133.Fatura No"></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="serial_number" id="serial_number" maxlength="5" value="#get_expense.serial_number#-#get_expense.serial_no#">
                                    </div> 
                                </div>
                                <div class="form-group" id="item-invoice_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58759.Fatura Tarihi"></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfoutput>   
                                                <input type="text" name="invoice_date" id="invoice_date" value="<cfif isdefined("get_expense")>#dateformat(get_expense.expense_date,dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)#</cfif>" validate="#validate_style#" required="yes" message="#alert#" readonly maxlength="10" style="width:120px;" onblur="change_money_info('add_health_expense','invoice_date');">
                                                <span class="input-group-addon btnPointer">
                                                    <cf_wrk_date_image date_field="invoice_date" call_function="change_money_info">
                                                </span>
                                            </cfoutput>
                                        </div>
                                    </div>
                                </div>
                            </cfoutput>
                        </cfif>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-tedavi">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="34712.Tedavi Gören">*</label>
                            <div class="col col-8 col-xs-12">
                                <select name="is_relative" id="is_relative" onchange="getRelatives()">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <option value="1"><cf_get_lang dictionary_id="40429.kendisi"></option>
                                    <option value="2"><cf_get_lang dictionary_id="40117.yakını"></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-relative" style="display:none;">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31277.Yakınlık Derecesi'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="relative_id" id="relative_id" onchange="policyControl()">
                                    <option value="relative_id"></option>
                                </select>
                                <label class="col col-12 col-xs-12" id="policy_control" style="color:red;display:none;"><cf_get_lang dictionary_id='61971.Çalışan yakınına ait poliçe bulunmakta'>!</label>
                            </div>
                        </div>
                        <div class="form-group" id="item-assurance_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58689.Teminat"><cf_get_lang dictionary_id="58651.Tipi"></label>
                            <div class="col col-8 col-xs-12">
                                <select name="assurance_id" id="assurance_id" onChange="get_treatment();">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_assurance">
                                        <cfif RATE neq ""><option value="#assurance_id#_1">#ASSURANCE# - SGK</option></cfif>
                                        <cfif PRIVATE_RATE neq ""><option value="#assurance_id#_2">#ASSURANCE# - <cf_get_lang dictionary_id = "57979.Özel"></option></cfif>
                                        <cfif RATE eq "" and PRIVATE_RATE eq ""><option value="#assurance_id#_0">#ASSURANCE#</option></cfif>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-treatment_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56623.Tedavi"><cf_get_lang dictionary_id="58651.Türü"></label>
                            <div class="col col-8 col-xs-12">
                                <select name="treatment_id" id="treatment_id">
                                    <option value=""><cf_get_lang dictionary_id="38597.Teminat Tipi Seçiniz"></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-reason_ill">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36199.Açıklama"></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput>
                                    <textarea name="reason_ill" id="reason_ill" value="" style="width:175px;height:55px;"></textarea>
                                </cfoutput>
                            </div>
                        </div>
                    <cfif not len(attributes.expense_id) and x_kdv_inpterrupt eq 1>
                        <div class="form-group" id="item-kdv_amounts2">
                            <font color ="#E08283"><b><cf_get_lang dictionary_id="60147.Kdv oranlarına göre harcamaları giriniz"></b></font>
                        </div>
                        <div class="form-group" id="item-kdv_amounts">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64195.KDV Oranlarına Göre Harcama'></label>
                            <div class="col col-8 col-xs-12 mb-1 padding-0">
                                <div class="col col-12 col-xs-12 mb-1 padding-0">
                                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="38563.KDV siz Tutar"></label>
                                    <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id="57639.KDV">%</label>
                                    <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="31175.KDV li Tutar"></label>
                                </div>
                                <!--- TutarA --->
                                <div class="col col-12 col-xs-12 mb-1 padding-0">
                                    <div class="col col-5 col-xs-12">
                                        <input type="text" class="moneybox" name="amount_1" id="amount_1" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                    </div>
                                    <div class="col col-2 col-xs-12">
                                        <input type="text" readonly class="moneybox" name="kdv_1" id="kdv_1" value="8">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <input type="text" class="moneybox" name="amount_kdv_1" id="amount_kdv_1" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onChange="getReverseTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                    </div>
                                </div>
                                <!--- TutarB --->
                                <div class="col col-12 col-xs-12 mb-1 padding-0">
                                    <div class="col col-5 col-xs-12">
                                        <input type="text" class="moneybox" name="amount_2" id="amount_2" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                    </div>
                                    <div class="col col-2 col-xs-12">
                                        <input type="text" readonly class="moneybox" name="kdv_2" id="kdv_2" value="18">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <input type="text" class="moneybox" name="amount_kdv_2" id="amount_kdv_2" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onChange="getReverseTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                    </div>
                                </div>
                                <!--- TutarC --->
                                <div class="col col-12 col-xs-12 mb-1 padding-0">
                                    <div class="col col-5 col-xs-12">
                                        <input type="text" class="moneybox" name="amount_3" id="amount_3" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                    </div>
                                    <div class="col col-2 col-xs-12">
                                        <input type="text" readonly class="moneybox" name="kdv_3" id="kdv_3" value="1">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <input type="text" class="moneybox" name="amount_kdv_3" id="amount_kdv_3" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onChange="getReverseTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                    </div>
                                </div>
                                <!--- TutarD --->
                                <div class="col col-12 col-xs-12 mb-1 padding-0">
                                    <div class="col col-5 col-xs-12">
                                        <input type="text" class="moneybox" name="amount_4" id="amount_4" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                    </div>
                                    <div class="col col-2 col-xs-12">
                                        <input type="text" readonly class="moneybox" name="kdv_4" id="kdv_4" value="0">
                                    </div>
                                    <div class="col col-5 col-xs-12">
                                        <input type="text" class="moneybox" name="amount_kdv_4" id="amount_kdv_4" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onChange="getReverseTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <cfif x_kdv_inpterrupt eq 1>
                        <div class="form-group" id="item-expense_amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59997.Harcama Tutarı"></label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("get_expense") and len(get_expense.TOTAL_AMOUNT)>
                                    <cfset total_amount = get_expense.TOTAL_AMOUNT>
                                <cfelse>
                                    <cfset total_amount = 0>
                                </cfif>
                                <input <cfif isDefined("get_expense")>readonly</cfif> type="text" class="moneybox" name="expense_amount" id="expense_amount" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(total_amount,x_rnd_nmbr)#</cfoutput>" style="width:120px;" />
                            </div>
                        </div>
                        <div class="form-group" id="item-kdv">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51311.KDV Tutar'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif isdefined("get_expense") and len(get_expense.KDV_TOTAL)>
                                    <cfset kdv_total = get_expense.KDV_TOTAL>
                                <cfelse>
                                    <cfset kdv_total = 0>
                                </cfif>
                                <input <cfif isDefined("get_expense")>readonly</cfif> type="text" class="moneybox" name="tax_value" id="tax_value" value="<cfoutput>#TLFormat(kdv_total,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                            </div>
                        </div>
                    </cfif>
                        <div class="form-group" id="item-net_total_amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="48323.Fatura Tutarı">*</label>
                            <div class="col col-2 col-xs-12">
                                <select <cfif isDefined("get_expense")>disabled</cfif> name="moneyType" id = "moneyType" style="width:57px;" class="boxtext">
                                    <cfoutput query="get_money">
                                        <option value="#money#" <cfif not isdefined("get_expense") and session.ep.money eq money>selected<cfelseif isDefined("get_expense") and len(get_expense.MONEY_CURRENCY_ID) and get_expense.MONEY_CURRENCY_ID eq money>selected</cfif>>#money#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cfif isdefined("get_expense") and len(get_expense.TOTAL_AMOUNT_KDVLI)>
                                    <cfset total_amount_kdvli = get_expense.TOTAL_AMOUNT_KDVLI>
                                <cfelse>
                                    <cfset total_amount_kdvli = 0>
                                </cfif>
                                <cfif x_kdv_inpterrupt eq 1>
                                    <cfinput class="moneybox" name="lastTotal" id="lastTotal" value="#TLFormat(TOTAL_AMOUNT_KDVLI,x_rnd_nmbr)#" style="width:120px;" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" readonly />
                                <cfelse>
                                    <cfinput class="moneybox" name="lastTotal" id="lastTotal" value="#TLFormat(TOTAL_AMOUNT_KDVLI,x_rnd_nmbr)#" style="width:120px;" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onChange="getTotalAmount();" />
                                </cfif>
                            </div>
                        </div>
                        <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
                            <div class="form-group" id="item-treatment_amount">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59887.Tedaviye Esas Tutar"></label>
                                <div class="col col-2 col-xs-12">
                                    <cfinput class="moneybox" name="treatment_rate" id="treatment_rate" value="" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="calculationTreatmentAmount(this)">
                                </div>
                                <div class="col col-6 col-xs-12">
                                    <cfif x_kdv_inpterrupt eq 1>
                                        <cfinput readonly class="moneybox" name="TreatmentlastTotal" id="TreatmentlastTotal" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" value="" onchange="ourCompanyHealth(this)" style="width:120px;">
                                    <cfelse>
                                        <cfinput class="moneybox" name="TreatmentlastTotal" id="TreatmentlastTotal" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" value="" onchange="getReverseLastTotal()" style="width:120px;">
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-our-company-health-amount2">
                                <font color ="#E08283"><b><cf_get_lang dictionary_id="59626.limit - Ödenek ve kesinti"></b></font>
                            </div>
                            <div class="form-group" id="item-our-company-health-amount">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41154.Kurum Payı">%</label>
                                <div class="col col-2 col-xs-12">
                                    <cfinput class="moneybox" name="comp_health_rate" id="comp_health_rate" value="" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="calculationAmount(this)">
                                </div>
                                <div class="col col-6 col-xs-12">
                                    <cfinput readonly class="moneybox" name="our_company_health_amount" id="our_company_health_amount" onchange="ourCompanyHealth(this)" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" value="#TLFormat(0,x_rnd_nmbr)#" style="width:120px;" />
                                </div>
                            </div>
                            <div class="form-group" id="item-employee-health-amount">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41148.Çalışan Payı"></label>
                                <div class="col col-2 col-xs-12">
                                </div>
                                <div class="col col-6 col-xs-12">
                                    <cfinput readonly class="moneybox" name="employee_health_amount" id="employee_health_amount" onchange="ourCompanyHealth(this)" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" value="#TLFormat(0,x_rnd_nmbr)#" style="width:120px;"/>
                                </div>
                            </div>
                            <div class="form-group" id="item-interrupt">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58621.Limit Aşımı"> - <cf_get_lang dictionary_id="60173.Ek Kesinti"></label>
                                <div class="col col-2 col-xs-12">
                                </div>
                                <div class="col col-6 col-xs-12">
                                    <cfinput class="moneybox" name="interrupt" id="interrupt" value="" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="ourCompanyHealth(this)">
                                </div>
                            </div>
                        </cfif>
                    </div> 
                </cf_box_elements>
                <cf_box_footer>
                    <cf_basket_form_button margintop="1"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_basket_form_button>
                </cf_box_footer> 
            </cfform>
        </cf_box>
    </div>
<cfif listfirst(attributes.fuseaction,'.') eq 'myhome'>
    <div class="col col-3 col-xs-12">
        <cfinclude template="../../hr/display/list_my_health_expenses_total.cfm">
    </div>
</cfif>

<script type="text/javascript">
    var x_rnd_nmbr = <cfoutput>#x_rnd_nmbr#</cfoutput>;
    $(document).ready(function() {
        $('#paper_number').attr('readonly', true);
    });
    function changeProcessDate(){
        $("#process_date").val($("#expense_date").val());
    }
    <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
        <cfif not len(attributes.expense_id)>
            $('#treatment_rate').val(commaSplit(100,x_rnd_nmbr));
            $('#comp_health_rate').val(commaSplit(0,x_rnd_nmbr));
            calculationTreatmentAmount(document.getElementById('treatment_rate'));
        <cfelse>
            <cfif x_is_employee_amount eq 1>
                $('#treatment_rate').val(commaSplit(0,x_rnd_nmbr));
            <cfelseif x_is_employee_amount eq 0>
                $('#treatment_rate').val(commaSplit(100,x_rnd_nmbr));
            </cfif>
            $('#comp_health_rate').val(commaSplit(0,x_rnd_nmbr));
            calculationTreatmentAmount(document.getElementById('treatment_rate'));
        </cfif>
    </cfif>
    
    function calculationTreatmentAmount(treatment_rate){
        <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
            if(treatment_rate.value != '' && parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)) != 0){
                ourCompanyHealth(treatment_rate);
                if($('#lastTotal').val() != ''){
                    last_total = parseFloat(filterNum($('#lastTotal').val(),x_rnd_nmbr));
                    <cfif x_is_employee_amount eq 0>
                        treatment_amount = wrk_round(last_total * parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)) / 100,x_rnd_nmbr);
                    <cfelseif x_is_employee_amount eq 1>
                        treatment_amount = wrk_round(last_total * 100 / parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)),x_rnd_nmbr);
                    </cfif>
                    $('#TreatmentlastTotal').val(commaSplit(treatment_amount,x_rnd_nmbr));
                    
                    if($("#expense_employee_id").val() != '' && $("#assurance_id").val() != "" && $('#lastTotal').val() != '' && filterNum($('#lastTotal').val(),x_rnd_nmbr) != 0 && $('#TreatmentlastTotal').val() != '' && filterNum($('#TreatmentlastTotal').val(),x_rnd_nmbr) != 0){

                        var assurance_id =  $("#assurance_id").val().split("_",1);

                        var assurance_types = $("#assurance_id").val().split("_",2)[1];

                        user_id = $("#expense_employee_id").val().split("_",1);

                        if($('#is_relative').val() == 2){
                            relative_id = $('#relative_id').val();
                        }
                        else{
                            relative_id = "_";
                        }

                        calcGeneralCompanyAmounts(assurance_id, user_id, relative_id, assurance_types);

                    }
                }
            }
            else{
                treatment_rate.value = commaSplit(0,x_rnd_nmbr);
            }
        </cfif>
    }
    
    function calculationAmount(comp_rate){
        <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
            if(comp_rate.value != '' && parseFloat(filterNum(comp_rate.value,x_rnd_nmbr)) != 0){
                ourCompanyHealth(comp_rate);
                if($('#TreatmentlastTotal').val() != ''){
                    treatment_amount = parseFloat(filterNum($('#TreatmentlastTotal').val(),x_rnd_nmbr));
                    comp_health_amount = wrk_round(treatment_amount * parseFloat(filterNum(comp_rate.value,x_rnd_nmbr)) / 100,x_rnd_nmbr);
                    $('#our_company_health_amount').val(commaSplit(comp_health_amount,x_rnd_nmbr));
                    if($('#lastTotal').val() != ''){
                        last_total = parseFloat(filterNum($('#lastTotal').val(),x_rnd_nmbr));
                        emp_health_amount = wrk_round(last_total - comp_health_amount,x_rnd_nmbr);
                    }
                    else{
                        emp_health_amount = 0;
                    }
                    $('#employee_health_amount').val(commaSplit(emp_health_amount,x_rnd_nmbr));
                }
            }
            else{
                comp_rate.value = commaSplit(0,x_rnd_nmbr);
            }
        </cfif>
    }

    function unformat_fields(){
        <cfif not len(attributes.expense_id) and x_kdv_inpterrupt eq 1>
            if($("#item-kdv_amounts").attr("display") != "none"){
                $('#amount_1').val(filterNum($('#amount_1').val(),x_rnd_nmbr));
                $('#amount_kdv_1').val(filterNum($('#amount_kdv_1').val(),x_rnd_nmbr));
                $('#amount_2').val(filterNum($('#amount_2').val(),x_rnd_nmbr));
                $('#amount_kdv_2').val(filterNum($('#amount_kdv_2').val(),x_rnd_nmbr));
                $('#amount_3').val(filterNum($('#amount_3').val(),x_rnd_nmbr));
                $('#amount_kdv_3').val(filterNum($('#amount_kdv_3').val(),x_rnd_nmbr));
                $('#amount_4').val(filterNum($('#amount_4').val(),x_rnd_nmbr));
                $('#amount_kdv_4').val(filterNum($('#amount_kdv_4').val(),x_rnd_nmbr));
            }
        </cfif>
        <cfif x_kdv_inpterrupt eq 1>
            $('#expense_amount').val(filterNum($('#expense_amount').val(),x_rnd_nmbr));
            $('#tax_value').val(filterNum($('#tax_value').val(),x_rnd_nmbr));
        </cfif>
        $('#lastTotal').val(filterNum($('#lastTotal').val(),x_rnd_nmbr));
        <cfif listFirst(attributes.fuseaction,'.') eq 'hr'>
            $('#TreatmentlastTotal').val(filterNum($('#TreatmentlastTotal').val(),x_rnd_nmbr));
            $('#treatment_rate').val(filterNum($('#treatment_rate').val(),x_rnd_nmbr));
            $('#interrupt').val(filterNum($('#interrupt').val(),x_rnd_nmbr));
            $('#comp_health_rate').val(filterNum($('#comp_health_rate').val(),x_rnd_nmbr));
            document.add_health_expense.our_company_health_amount.value = filterNum(document.add_health_expense.our_company_health_amount.value,x_rnd_nmbr);
            document.add_health_expense.employee_health_amount.value = filterNum(document.add_health_expense.employee_health_amount.value,x_rnd_nmbr);	 
        </cfif>
    }
    
    function kontrol(){
        //if(!paper_control(document.getElementById("paper_number"),'HEALTH_ALLOWENCE_EXPENSE_NUMBER')) return false;
        
        paper_no_control = wrk_safe_query('health_expense_paper_no_control','dsn2',0,$('#paper_number').val());
        if(paper_no_control.recordcount != 0){
            <cfif len(paper_number)> <cfset paper_number += 1> <cfelse> <cfset paper_number =0> </cfif>
            paper_no = parseInt(<cfoutput>#paper_number#</cfoutput>);
            alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
            $('#paper_number').val('<cfoutput>#paper_code#</cfoutput>-' + paper_no);
            return false;
        }

        if(document.getElementById('expense_employee').value == ""){
                alert('<cf_get_lang dictionary_id="46197.Çalışan seçiniz">');
                return false;
            }

        if(!$("#is_relative").val().length)
        {
            alert('<cf_get_lang dictionary_id="38595.Tedavi Gören Seçiniz">');
            $("#is_relative").focus();
            return false;
        }

        if($("#is_relative").val() == 2 && $("#relative_id").val() == '0')
        {
            alert('<cf_get_lang dictionary_id="38595.Tedavi Gören Seçiniz">');
            $("#relative_id").focus();
            return false;
        }

        if(!chk_period(document.getElementById("process_date"),"İşlem")) return false;
        <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
            if(!document.getElementById('our_company_health_amount').value){
                alert("Kurum Payı % sini giriniz!");
                return false;
            }
        </cfif>

        //Anlaşmasız Kurum Mükerrer kayıt kontrolü
        <cfif not len(attributes.expense_id)>
            check_emp_id = $('#expense_employee_id').val().split("_",1);
            check_system_rel = $('#system_relation').val();
            check_comp_name = $('#expense_comp_name').val();
            check_expense_date = js_date($('#expense_date').val());
            if(check_emp_id != '' && check_system_rel != '' && check_comp_name != '' && check_expense_date != ''){
                var listParam = check_emp_id + "*" + check_system_rel + "*" + check_comp_name + "*" + check_expense_date + "*_";
                health_expense_control = wrk_safe_query('health_expense_control','dsn2',0,listParam);
                if(health_expense_control.recordcount != 0){
                    alert("<cf_get_lang dictionary_id='60279.Kontrol ediniz.'>");
                    return false;
                }
            }
        //Anlaşmalı Kurum mükerrer kayıt kontrolü
        <cfelseif len(attributes.expense_id)>
            check_comp_id = $('#ch_company_id').val();
            check_invoice_no = $('#serial_number').val();
            check_invoice_date = js_date($('#invoice_date').val());
            if(check_comp_id != '' && check_invoice_no != '' && check_invoice_date != ''){
                var listParam = check_comp_id + "*" + check_invoice_no + "*" + check_invoice_date + "*_";
                health_expense_control = wrk_safe_query('health_expense_control_efatura','dsn2',0,listParam);
                if(health_expense_control.recordcount != 0){
                    alert("<cf_get_lang dictionary_id='60306.Kontrol ediniz.'>");
                    return false;
                }
            }
        </cfif>
        <cfif listFirst(attributes.fuseaction,'.') eq 'hr'>
            <cfif not len(attributes.expense_id)>
                var kurum_payi = parseFloat(filterNum(document.getElementById('our_company_health_amount').value,x_rnd_nmbr),x_rnd_nmbr);
                var calisan_payi = parseFloat(filterNum(document.getElementById('employee_health_amount').value,x_rnd_nmbr),x_rnd_nmbr);
                var lasttotal = parseFloat(filterNum(document.getElementById('lastTotal').value,x_rnd_nmbr),x_rnd_nmbr);
                var treatment_total = parseFloat(filterNum(document.getElementById('TreatmentlastTotal').value,x_rnd_nmbr),x_rnd_nmbr);

                var total = wrk_round(kurum_payi + calisan_payi,x_rnd_nmbr);

                <cfif x_is_employee_amount eq 0>
                    if (total != lasttotal) {
                        alert('<cf_get_lang dictionary_id="41321.Toplam Tutar, Kurum Payı ile Çalışan Payı toplamına eşit olmalıdır">!'); 
                        document.getElementById('our_company_health_amount').focus(); 
                        return false;         
                    }
                <cfelseif x_is_employee_amount eq 1>
                    if (total != treatment_total) {
                        alert('<cf_get_lang dictionary_id="41321.Toplam Tutar, Kurum Payı ile Çalışan Payı toplamına eşit olmalıdır">!'); 
                        document.getElementById('our_company_health_amount').focus(); 
                        return false;         
                    }
                </cfif>
            </cfif>
        </cfif>

        unformat_fields();

        if($('#moneyType').prop('disabled','disabled')) $('#moneyType').prop('disabled',false);
    }

    function calcGeneralCompanyAmounts(assurance_id, user_id, relative_id, assurance_types){

        get_load_rate = wrk_safe_query('get_limit_rate_by_assurance','dsn',0,assurance_id + "*" + assurance_types);
        if(get_load_rate.recordcount){
            $('#comp_health_rate').val(commaSplit(get_load_rate.RATE,x_rnd_nmbr));
        }

        toplam = 0;//Kurum payı hesaplanıp yazılıyor
        kalan_limit = 0;//hangi limit basamağında hesaplanmaya başlanacağı bulunuyor
        devreden = 0;//önceki harcamalarda limit basamağını aşıp bir sonraki limite aktarılıyorsa
        hesapla = 0;//0 ise; hesaplanmaya başlanmadı. 1 olduğunda; diğer limit basamaklarında direk hesaplamaya sokulacak
        //bu harcamanın tutarı
        harcama_tutari = parseFloat(filterNum($('#TreatmentlastTotal').val(), x_rnd_nmbr));
        //limit basamakları çekiliyor
        var assurance_limit_steps = wrk_safe_query('get_limits_by_assurance','dsn',0,assurance_id);

        //Seçilen teminat tipinin üst teminatı var mı? Üst teminat seçili ise o teminata bağlı olan tüm teminatların kullanımı hesaplanır.
        //Üst teminat yoksa sadece o teminatın harcamaları hesaplanır.
        group_assurance_ids = '';
        var get_main_assurance_type = wrk_safe_query('get_main_assurance_type','dsn',0,assurance_id);
        if(get_main_assurance_type.MAIN_ASSURANCE_TYPE_ID != ''){
            var get_group_assurance_ids = wrk_safe_query('get_group_assurance_ids','dsn',0,get_main_assurance_type.MAIN_ASSURANCE_TYPE_ID);
            for(k=0; k<get_group_assurance_ids.recordcount; k++){
                group_assurance_ids += get_group_assurance_ids.ASSURANCE_ID[k];
                if(k < get_group_assurance_ids.recordcount - 1) group_assurance_ids += ',';
            }
        }
        else{
            group_assurance_ids += assurance_id;
        }

        //Onaylanmış ve ödenmiş harcamalar çekiliyor. Sondaki '_' expense_id içindir. Update sayfasında kayıt onaylanmış ise hesaplarken değerini almasın.
        var sum_employee_expense = wrk_safe_query('get_emp_sum_health_expense','dsn2',0,user_id+"*"+group_assurance_ids+"*"+relative_id+"*_");
        if(sum_employee_expense != false){
            <cfif x_limit_type eq 1>
                employee_total_amount = sum_employee_expense.TOTAL_AMOUNT;
            <cfelse>
                employee_total_amount = sum_employee_expense.TREATMENT_AMOUNT;
            </cfif>
            if(assurance_limit_steps.recordcount){
                for(i = 0; i < assurance_limit_steps.recordcount; i++){
                    if(assurance_limit_steps.MIN[i] != '') min = parseFloat(assurance_limit_steps.MIN[i]);
                    else min = 0;
                    if(assurance_limit_steps.MAX[i] != '') max = parseFloat(assurance_limit_steps.MAX[i]);
                    else max = 9999999;
                    if($("#assurance_id").val().split("_",2)[1] == 1) rate = parseFloat(assurance_limit_steps.RATE[i]);
                    else rate = parseFloat(assurance_limit_steps.PRIVATE_COMP_RATE[i]);
                    if(employee_total_amount != '') sumExp = parseFloat(employee_total_amount);
                    else sumExp = 0;
                    if(harcama_tutari > 0){
                        if(i == 0){
                            //limitte kaldımı kalmadımı kontrol
                            if(sumExp >= min && sumExp <= max){
                                kalan_limit = max - sumExp;
                                hesapla = 1;
                            }
                            else if(sumExp > max){
                                devreden = sumExp - max;
                            }
                            //limitte kaldıysa kalan limit tutardan düşülüp kurum payı hesaplamasına eklenir.
                            if(kalan_limit != 0 && hesapla == 1){
                                if(harcama_tutari > kalan_limit){
                                    toplam += wrk_round(kalan_limit * rate / 100, x_rnd_nmbr);
                                    harcama_tutari = harcama_tutari - kalan_limit;
                                }
                                else{
                                    toplam += wrk_round(harcama_tutari * rate / 100, x_rnd_nmbr);
                                    harcama_tutari = 0;
                                }
                            }
                        }
                        else{
                            if(devreden != 0){
                                //limitte kaldımı kalmadımı kontrol
                                if(sumExp >= min && sumExp <= max){
                                    kalan_limit = max - devreden;
                                    hesapla = 1;
                                }
                                else if(sumExp > max){
                                    devreden = devreden - (max - min);
                                }
                                //limitte kaldıysa kalan limit tutardan düşülüp kurum payı hesaplamasına eklenir.
                                if(kalan_limit != 0 && hesapla == 1){
                                    if(harcama_tutari > kalan_limit){
                                        toplam += wrk_round(kalan_limit * rate / 100, x_rnd_nmbr);
                                        harcama_tutari = harcama_tutari - kalan_limit;
                                    }
                                    else{
                                        toplam += wrk_round(harcama_tutari * rate / 100, x_rnd_nmbr);
                                        harcama_tutari = 0;
                                    }
                                }
                            }
                            else{
                                if(hesapla == 1){
                                    kalan_limit = max - min;
                                    if(harcama_tutari > kalan_limit){
                                        toplam += wrk_round(kalan_limit * rate / 100, x_rnd_nmbr);
                                        harcama_tutari = harcama_tutari - kalan_limit;
                                    }
                                    else{
                                        toplam += wrk_round(harcama_tutari * rate / 100, x_rnd_nmbr);
                                        harcama_tutari = 0;
                                    }
                                }
                            }
                        }
                    }
                }

                fatura_tutari = parseFloat(filterNum($('#lastTotal').val(), x_rnd_nmbr));
                treatment_amount_ = parseFloat(filterNum($('#TreatmentlastTotal').val(), x_rnd_nmbr));
                last_rate = toplam * 100 / treatment_amount_;

                <cfif len(attributes.expense_id)>

                    if($('#comp_health_rate').val() != '' && parseFloat(filterNum($('#comp_health_rate').val(),x_rnd_nmbr)) != 0){
                        comp_health_amount = wrk_round(treatment_amount_ * parseFloat(filterNum($('#comp_health_rate').val(),x_rnd_nmbr)) / 100,x_rnd_nmbr);
                        $('#our_company_health_amount').val(commaSplit(comp_health_amount,x_rnd_nmbr));
                        emp_health_amount = wrk_round(fatura_tutari - comp_health_amount,x_rnd_nmbr);
                        $('#employee_health_amount').val(commaSplit(emp_health_amount,x_rnd_nmbr));
                    }

                    $('#comp_health_rate').val(commaSplit(last_rate,x_rnd_nmbr));

                    interruption = wrk_round(fatura_tutari - (treatment_amount_ * last_rate / 100),x_rnd_nmbr);
                    $('#interrupt').val(commaSplit(interruption,x_rnd_nmbr));

                <cfelse>

                    $('#comp_health_rate').val(commaSplit(last_rate,x_rnd_nmbr));

                    if($('#comp_health_rate').val() != '' && parseFloat(filterNum($('#comp_health_rate').val(),x_rnd_nmbr)) != 0){
                        comp_health_amount = wrk_round(treatment_amount_ * parseFloat(filterNum($('#comp_health_rate').val(),x_rnd_nmbr)) / 100,x_rnd_nmbr);
                        $('#our_company_health_amount').val(commaSplit(comp_health_amount,x_rnd_nmbr));
                        emp_health_amount = wrk_round(last_total - comp_health_amount,x_rnd_nmbr);
                        $('#employee_health_amount').val(commaSplit(emp_health_amount,x_rnd_nmbr));
                    }

                </cfif>
            }
        }
    }

    function get_treatment(){
        var dropdown = $('#treatment_id');
        dropdown.empty();
        dropdown.append(new Option('<cf_get_lang dictionary_id="57734.Seçiniz">', 0));

        if($("#assurance_id").val() != ""){
            var assurance_id =  $("#assurance_id").val().split("_",1);
            var assurance_type_id =  $("#assurance_id").val().split("_",2)[1];

            get_assurance = wrk_safe_query('get_health_assurance_type_treatments','dsn',0,assurance_id);
            
            get_assurance_rate = wrk_safe_query('get_limit_rate_by_assurance','dsn',0,assurance_id + "*" + assurance_type_id);

            <cfif attributes.fuseaction eq 'hr.health_expense_approve'>

                if(get_assurance_rate.recordcount){
                    <cfif len(attributes.expense_id)>
                        <cfif x_is_employee_amount eq 1>
                            $('#treatment_rate').val(commaSplit(get_assurance_rate.RATE,x_rnd_nmbr));
                        <cfelseif x_is_employee_amount eq 0>
                            $('#treatment_rate').val(commaSplit(100,x_rnd_nmbr));
                        </cfif>
                    <cfelse>
                        $('#treatment_rate').val(commaSplit(100,x_rnd_nmbr));
                    </cfif>
                    $('#comp_health_rate').val(commaSplit(get_assurance_rate.RATE,x_rnd_nmbr));
                }
                else{
                    $('#treatment_rate').val(commaSplit(100,x_rnd_nmbr));
                    $('#comp_health_rate').val(commaSplit(100,x_rnd_nmbr));
                }
                calculationTreatmentAmount(document.getElementById('treatment_rate'));
                
            </cfif>

            if(get_assurance.recordcount > 0){
                for(i=1; i<=get_assurance.recordcount; ++i){
                    dropdown.append(new Option(get_assurance.TREATMENT[i-1], get_assurance.TREATMENT_ID[i-1]));
                }
            }
        }
    }

    function ourCompanyHealth(obj){
        obj.value = commaSplit(parseFloat(filterNum(obj.value,x_rnd_nmbr)),x_rnd_nmbr);
    }

    function getReverseTotalAmount(){
        <cfif not len(attributes.expense_id) and x_kdv_inpterrupt eq 1>
            if($("#item-kdv_amounts").attr("display") != "none"){
                if($("#amount_kdv_1").val() == '') $("#amount_kdv_1").val(commaSplit(0,x_rnd_nmbr));
                else $("#amount_kdv_1").val(commaSplit(filterNum($("#amount_kdv_1").val(),x_rnd_nmbr),x_rnd_nmbr));
                if($("#amount_kdv_2").val() == '') $("#amount_kdv_2").val(commaSplit(0,x_rnd_nmbr));
                else $("#amount_kdv_2").val(commaSplit(filterNum($("#amount_kdv_2").val(),x_rnd_nmbr),x_rnd_nmbr));
                if($("#amount_kdv_3").val() == '') $("#amount_kdv_3").val(commaSplit(0,x_rnd_nmbr));
                else $("#amount_kdv_3").val(commaSplit(filterNum($("#amount_kdv_3").val(),x_rnd_nmbr),x_rnd_nmbr));
                if($("#amount_kdv_4").val() == '') $("#amount_kdv_4").val(commaSplit(0,x_rnd_nmbr));
                else $("#amount_kdv_4").val(commaSplit(filterNum($("#amount_kdv_4").val(),x_rnd_nmbr),x_rnd_nmbr));

                amount_kdv_1 = parseFloat(filterNum($("#amount_kdv_1").val(),x_rnd_nmbr));
                amount_kdv_2 = parseFloat(filterNum($("#amount_kdv_2").val(),x_rnd_nmbr));
                amount_kdv_3 = parseFloat(filterNum($("#amount_kdv_3").val(),x_rnd_nmbr));
                amount_kdv_4 = parseFloat(filterNum($("#amount_kdv_4").val(),x_rnd_nmbr));

                kdv_1 = parseFloat($("#kdv_1").val());
                kdv_2 = parseFloat($("#kdv_2").val());
                kdv_3 = parseFloat($("#kdv_3").val());
                kdv_4 = parseFloat($("#kdv_4").val());

                amount_1 = wrk_round(amount_kdv_1 / (1 + (kdv_1 / 100)),x_rnd_nmbr);
                amount_2 = wrk_round(amount_kdv_2 / (1 + (kdv_2 / 100)),x_rnd_nmbr);
                amount_3 = wrk_round(amount_kdv_3 / (1 + (kdv_3 / 100)),x_rnd_nmbr);
                amount_4 = wrk_round(amount_kdv_4 / (1 + (kdv_4 / 100)),x_rnd_nmbr);

                kdv_tutar_1 = wrk_round(amount_kdv_1 - amount_1,x_rnd_nmbr);
                kdv_tutar_2 = wrk_round(amount_kdv_2 - amount_2,x_rnd_nmbr);
                kdv_tutar_3 = wrk_round(amount_kdv_3 - amount_3,x_rnd_nmbr);
                kdv_tutar_4 = wrk_round(amount_kdv_4 - amount_4,x_rnd_nmbr);

                $("#amount_1").val(commaSplit(amount_1,x_rnd_nmbr));
                $("#amount_2").val(commaSplit(amount_2,x_rnd_nmbr));
                $("#amount_3").val(commaSplit(amount_3,x_rnd_nmbr));
                $("#amount_4").val(commaSplit(amount_4,x_rnd_nmbr));

                //Toplam tutar ve Toplam Kdv alt inputlara yazıldı
                $("#expense_amount").val(commaSplit(wrk_round(amount_1 + amount_2 + amount_3 + amount_4,x_rnd_nmbr),x_rnd_nmbr));
                $("#tax_value").val(commaSplit(wrk_round(kdv_tutar_1 + kdv_tutar_2 + kdv_tutar_3 + kdv_tutar_4,x_rnd_nmbr),x_rnd_nmbr));

                if($("#expense_amount").val() == '') $("#expense_amount").val(commaSplit(0,x_rnd_nmbr));
                if($("#tax_value").val() == '') $("#tax_value").val(0);
                exp_amount = parseFloat(filterNum($("#expense_amount").val(),x_rnd_nmbr));
                tax_amount = parseFloat(filterNum($("#tax_value").val(),x_rnd_nmbr));
                total_amount = tax_amount + exp_amount;
                document.getElementById("expense_amount").value = commaSplit(filterNum(document.getElementById("expense_amount").value,x_rnd_nmbr),x_rnd_nmbr);
                document.getElementById("lastTotal").value = commaSplit(total_amount,x_rnd_nmbr);
                document.getElementById("tax_value").value = commaSplit(filterNum(document.getElementById("tax_value").value,x_rnd_nmbr),x_rnd_nmbr);
                <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
                    treatment_rate = document.getElementById('treatment_rate');
                    if(treatment_rate.value != '' && parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)) != 0){
                        calculationTreatmentAmount(treatment_rate);
                    }
                </cfif>
            }
        </cfif>
    }

    function getReverseLastTotal(){
        if($("#TreatmentlastTotal").val() == '') $("#TreatmentlastTotal").val(commaSplit(0,x_rnd_nmbr));
        else $("#TreatmentlastTotal").val(commaSplit(filterNum($("#TreatmentlastTotal").val(),x_rnd_nmbr),x_rnd_nmbr));
        treatment_rate = document.getElementById('treatment_rate');
        if(treatment_rate.value != '' && parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)) != 0){
            ourCompanyHealth(treatment_rate);
            if($('#TreatmentlastTotal').val() != ''){
                treatment_total = parseFloat(filterNum($('#TreatmentlastTotal').val(),x_rnd_nmbr));
                last_total = wrk_round(treatment_total * 100 / parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)),x_rnd_nmbr);
                $('#lastTotal').val(commaSplit(last_total,x_rnd_nmbr));
                if($('#comp_health_rate').val() != '' && parseFloat(filterNum($('#comp_health_rate').val(),x_rnd_nmbr)) != 0){
                    comp_health_amount = wrk_round(last_total * parseFloat(filterNum($('#comp_health_rate').val(),x_rnd_nmbr)) / 100,x_rnd_nmbr);
                    $('#our_company_health_amount').val(commaSplit(comp_health_amount,x_rnd_nmbr));
                    emp_health_amount = wrk_round(last_total - comp_health_amount,x_rnd_nmbr);
                    $('#employee_health_amount').val(commaSplit(emp_health_amount,x_rnd_nmbr));
                }
            }
        }
        else{
            treatment_rate.value = commaSplit(0,x_rnd_nmbr);
        }
    }

    function getTotalAmount(){
        <cfif not len(attributes.expense_id) and x_kdv_inpterrupt eq 1>
            if($("#item-kdv_amounts").attr("display") != "none"){
                if($("#amount_1").val() == '') $("#amount_1").val(commaSplit(0,x_rnd_nmbr));
                else $("#amount_1").val(commaSplit(filterNum($("#amount_1").val(),x_rnd_nmbr),x_rnd_nmbr));
                if($("#amount_2").val() == '') $("#amount_2").val(commaSplit(0,x_rnd_nmbr));
                else $("#amount_2").val(commaSplit(filterNum($("#amount_2").val(),x_rnd_nmbr),x_rnd_nmbr));
                if($("#amount_3").val() == '') $("#amount_3").val(commaSplit(0,x_rnd_nmbr));
                else $("#amount_3").val(commaSplit(filterNum($("#amount_3").val(),x_rnd_nmbr),x_rnd_nmbr));
                if($("#amount_4").val() == '') $("#amount_4").val(commaSplit(0,x_rnd_nmbr));
                else $("#amount_4").val(commaSplit(filterNum($("#amount_4").val(),x_rnd_nmbr),x_rnd_nmbr));

                //Tutar alanları değişkene atandı
                amount_1 = parseFloat(filterNum($("#amount_1").val(),x_rnd_nmbr));
                amount_2 = parseFloat(filterNum($("#amount_2").val(),x_rnd_nmbr));
                amount_3 = parseFloat(filterNum($("#amount_3").val(),x_rnd_nmbr));
                amount_4 = parseFloat(filterNum($("#amount_4").val(),x_rnd_nmbr));

                //Kdv alanları değişkene atandı
                kdv_1 = parseFloat($("#kdv_1").val());
                kdv_2 = parseFloat($("#kdv_2").val());
                kdv_3 = parseFloat($("#kdv_3").val());
                kdv_4 = parseFloat($("#kdv_4").val());

                //Kdv Tutarı hesaplandı
                kdv_tutar_1 = wrk_round(amount_1 * kdv_1 / 100,x_rnd_nmbr);
                kdv_tutar_2 = wrk_round(amount_2 * kdv_2 / 100,x_rnd_nmbr);
                kdv_tutar_3 = wrk_round(amount_3 * kdv_3 / 100,x_rnd_nmbr);
                kdv_tutar_4 = wrk_round(amount_4 * kdv_4 / 100,x_rnd_nmbr);

                //Kdvli tutar hesaplandı ve inputa yazıldı
                amount_kdvli_1 = wrk_round(amount_1 + kdv_tutar_1,x_rnd_nmbr);
                amount_kdvli_2 = wrk_round(amount_2 + kdv_tutar_2,x_rnd_nmbr);
                amount_kdvli_3 = wrk_round(amount_3 + kdv_tutar_3,x_rnd_nmbr);
                amount_kdvli_4 = wrk_round(amount_4 + kdv_tutar_4,x_rnd_nmbr);
                $("#amount_kdv_1").val(commaSplit(amount_kdvli_1,x_rnd_nmbr));
                $("#amount_kdv_2").val(commaSplit(amount_kdvli_2,x_rnd_nmbr));
                $("#amount_kdv_3").val(commaSplit(amount_kdvli_3,x_rnd_nmbr));
                $("#amount_kdv_4").val(commaSplit(amount_kdvli_4,x_rnd_nmbr));

                //Toplam tutar ve Toplam Kdv alt inputlara yazıldı
                $("#expense_amount").val(commaSplit(wrk_round(amount_1 + amount_2 + amount_3 + amount_4,x_rnd_nmbr),x_rnd_nmbr));
                $("#tax_value").val(commaSplit(wrk_round(kdv_tutar_1 + kdv_tutar_2 + kdv_tutar_3 + kdv_tutar_4,x_rnd_nmbr),x_rnd_nmbr));
            }
        </cfif>
        <cfif x_kdv_inpterrupt eq 1>
            if($("#expense_amount").val() == '') $("#expense_amount").val(commaSplit(0,x_rnd_nmbr));
            if($("#tax_value").val() == '') $("#tax_value").val(0);
            exp_amount = parseFloat(filterNum($("#expense_amount").val(),x_rnd_nmbr));
            tax_amount = parseFloat(filterNum($("#tax_value").val(),x_rnd_nmbr));
            total_amount = tax_amount + exp_amount;
            document.getElementById("expense_amount").value = commaSplit(filterNum(document.getElementById("expense_amount").value,x_rnd_nmbr),x_rnd_nmbr);
            document.getElementById("tax_value").value = commaSplit(filterNum(document.getElementById("tax_value").value,x_rnd_nmbr),x_rnd_nmbr);
            document.getElementById("lastTotal").value = commaSplit(total_amount,x_rnd_nmbr);
        </cfif>
        if($("#lastTotal").val() == '') $("#lastTotal").val(commaSplit(0));
        else $("#lastTotal").val(commaSplit(filterNum($("#lastTotal").val(),x_rnd_nmbr),x_rnd_nmbr));
        <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
            treatment_rate = document.getElementById('treatment_rate');
            if(treatment_rate.value != '' && parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)) != 0){
                calculationTreatmentAmount(treatment_rate);
            }
        </cfif>
    }

    function getRelatives(){

        if($('#expense_employee_id').val() == '')
        {
            alert('<cf_get_lang dictionary_id="46197.Çalışan seçiniz">');
            $('#is_relative').val('');
        }

        var is_relative = $("#is_relative").val();

        if (is_relative == 2) {
            $('#item-relative').css('display','');
        }
        else{
            $('#item-relative').css('display','none');
        }

        $('#policy_control').css('display','none');

        $('#relative_id').empty();
        $('#relative_id').append(new Option('<cf_get_lang dictionary_id="57734.Seçiniz">', 0));

        if(is_relative == 2)
        {
            var listparam = $('#expense_employee_id').val();
            if(listparam.includes("_")){
                listparam = listparam.split("_")[0];
            }
            $('#item-relative').show();
            var getRelatives = wrk_safe_query('get_employees_relatives','dsn',0,listparam);
            var relative_name_list = "<cfoutput>#getLang('myhome',	1204,'babası')#,#getLang('myhome',1205,'annesi')#,#getLang('myhome',572,'Eşi')#,#getLang('myhome',573,'Oğlu')#,#getLang('myhome',574,'Kızı')#,#getLang('myhome',692,'Kardeşi')#</cfoutput>";
            relative_name = relative_name_list.split(",");
            for(i = 0;i<getRelatives.recordcount;++i)
            {
                aa = getRelatives.RELATIVE_LEVEL[i];
                $('#relative_id').append(new Option(getRelatives.FULLNAME[i]+ " - "+ relative_name[aa-1], getRelatives.RELATIVE_ID[i]));
            }
        }
    }

    function policyControl() {
        if($('#expense_employee_id').val() != '' && $('#relative_id').val() != '' && $('#relative_id').val() != 0){
            var listparam = $('#expense_employee_id').val();
            if(listparam.includes("_")){
                listparam = listparam.split("_")[0];
            }
            listparam += '*' + $('#relative_id').val();
            var is_policy_control = wrk_safe_query('get_employees_relatives_control','dsn',0,listparam);
            if( is_policy_control.recordcount && (is_policy_control.IS_COMMITMENT_NOT_ASSURANCE == 1 || is_policy_control.IS_ASSURANCE_POLICY == 1) ){
                policy_control_msg = (is_policy_control.IS_COMMITMENT_NOT_ASSURANCE == 1 && is_policy_control.IS_ASSURANCE_POLICY == 1) ? '<cfoutput>#getLang('dictionary_id','Taahhüt ve Poliçe',61971)#</cfoutput>' : ((is_policy_control.IS_COMMITMENT_NOT_ASSURANCE == 1) ? '<cfoutput>#getLang('dictionary_id','Taahhüt',62766)#</cfoutput>' : '<cfoutput>#getLang('dictionary_id','Poliçe',62767)#</cfoutput>');
                $('#policy_control').text(policy_control_msg);
                $('#policy_control').css('display','');
            }
            else
                $('#policy_control').css('display','none');
        }
        else
            $('#policy_control').css('display','none');
    }

    function showDepartment(branch_id)	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
		}
    } 
    
    function change_dept(){
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
            var delayInMilliseconds = 1000; //1 second
            setTimeout(function() {
                document.getElementById('DEPARTMENT_ID').value = document.getElementById('dept_id').value;
            }, delayInMilliseconds);
		}
	}
</script>