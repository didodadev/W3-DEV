<!---
File: upd_health_expense_form.cfm
Controller: HealthExpenseController.cfm
Folder: myhome\form\
Author: Canan Ebret
Date: 2019-12-01 22:02:22 
Description:
    
History:
    
To Do:

--->

<cf_xml_page_edit fuseact="hr.health_expense_approve">
<cfif (not isDefined("x_rnd_nmbr")) or (isDefined("x_rnd_nmbr") and not len(x_rnd_nmbr))>
    <cfset x_rnd_nmbr = 2>
</cfif>
<cf_get_lang_set module_name="myhome">
<cfparam name="attributes.expense_id" default="">
<cfif not isdefined("x_kdv_inpterrupt")>
    <cfset x_kdv_inpterrupt = 1>
</cfif>
<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.health_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.health_id,accountKey:'wrk')>
</cfif>
<cfparam name="expense_date" default="#now()#" />
<cfset HealthExpense= createObject("component","V16.myhome.cfc.health_expense") />
<cfif fusebox.circuit eq 'myhome'>
    <cfset get_expense=HealthExpense.GET_EXPENSE(health_id : attributes.health_id,emp_id : session.ep.userid) />
<cfelse>   
    <cfset get_expense=HealthExpense.GET_EXPENSE(health_id : attributes.health_id) />
</cfif>
<cfif len( get_expense.EXPENSE_ITEM_PLANS_ID)>
    <cfset get_expense_invoice=HealthExpense.GET_EXPENSE_INVOICE(expense_id : get_expense.EXPENSE_ITEM_PLANS_ID) />
<cfelse>
    <cfset get_expense_invoice.recordcount = 0>
</cfif>

<cfif len( get_expense.EXPENSE_ITEM_PLANS_ID) and len( get_expense.INVOICE_NO )>
    <cfset health_invoice_control = HealthExpense.HEALTH_INVOICE_CONTROL(invoice_id : get_expense.EXPENSE_ITEM_PLANS_ID , invoice_no : get_expense.INVOICE_NO) />
<cfelse>
    <cfset health_invoice_control.recordcount = 0>
</cfif>

<cfif listfirst(attributes.fuseaction,'.') eq 'myhome'>
    <cfset is_requested = 1>
<cfelse>
    <cfset is_requested = ''>
</cfif>
<cfset get_assurance = HealthExpense.GetAssurance(is_requested : is_requested) />

<cfif len(get_expense.ASSURANCE_ID)>
    <cfset get_treatment = HealthExpense.GetTreatment(assurance_id: get_expense.ASSURANCE_ID) />
<cfelse>
    <cfset get_treatment = HealthExpense.GetTreatment() />
</cfif>
<cfset get_tax = HealthExpense.GetTax() />
<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1,comp_id : session.ep.company_id)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department(branch_id : get_expense.branch_id)>
<cfset GET_DOCUMENT_TYPE = HealthExpense.GET_DOCUMENT_TYPE(fuseaction: fuseaction) />
<cfscript>
    Position_Assistant= createObject("component","V16.hr.ehesap.cfc.position_assistant");
    get_modules_no = Position_Assistant.GET_MODULES_NO(fuseaction:attributes.fuseaction)
</cfscript>
<cf_catalystHeader>
<cfinclude template="../../product/query/get_money.cfm">

<div class="col col-9 col-xs-12 uniqueRow">
    <cfform name="add_health_expense" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_health_expense_approve">
        <cf_box>
            <cfinput type="hidden" name="health_id" id="health_id" value="#attributes.health_id#">
            <cfinput type="hidden" name="x_is_employee_amount" value="#x_is_employee_amount#">
            <cfinput type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
            <cfinput type="hidden" id="dept_id" name="dept_id" value="">
            <cfinput type="hidden" name="x_is_employee_payment" value="#x_is_employee_payment#">
            <cfinput type="hidden" name="x_is_employee_relative_payment" value="#x_is_employee_relative_payment#">
            <cfinput type="hidden" name="x_is_limit_interruption" value="#x_is_limit_interruption#">
            <cfinput type="hidden" name="x_acc_type" value="#x_acc_type#">
            <cfinput type="hidden" name="x_kdv_inpterrupt" value="#x_kdv_inpterrupt#">
            <cfif isdefined("x_decease_reason")>
                <cfinput type="hidden" name="x_decease_reason" value="#x_decease_reason#">
            </cfif>
            <input type="hidden" name="expense_id" id="expense_id" value="<cfoutput>#attributes.expense_id#</cfoutput>">
            <input type="hidden" name="expense_type" id="expense_type" value="2">
            <cfinput type="hidden" name="from_health_approve" value="1">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
                        <div class="form-group" id="item_process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process_cat process_cat='#get_expense.PROCESS_CAT#' slct_width="135">
                            </div>
                        </div>
                    </cfif>  
                    <div class="form-group" id="item-expense_stage">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' is_detail='1' select_value='#get_expense.EXPENSE_STAGE#' >
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_employee">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfset new_emp_id =get_expense.emp_id>
                                <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#new_emp_id#</cfoutput>">
                                <input type="text" name="expense_employee" id="expense_employee" style="width:120px;" value="<cfoutput>#get_emp_info(new_emp_id,0,0)#</cfoutput>" readonly>
                                <span class="input-group-addon btnPointer icon-ellipsis" <cfif fusebox.circuit neq 'myhome' and get_expense.EXPENSE_ITEM_PLANS_ID eq ''> onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=add_health_expense.expense_employee_id&field_name=add_health_expense.expense_employee&field_type=add_health_expense.expense_employee_id&field_dep_id=add_health_expense.dept_id&field_branch_id=add_health_expense.branch_id&call_function=change_dept()&select_list=1,9','list');"
                                <cfelse>
                                    onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=add_health_expense.expense_employee_id&field_name=add_health_expense.expense_employee&field_type=add_health_expense.expense_employee_id&field_dep_id=add_health_expense.dept_id&field_branch_id=add_health_expense.branch_id&call_function=change_dept()&is_position_assistant=1&module_id=<cfoutput>#get_modules_no.module_no#</cfoutput>&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1&show_rel_pos=1','list');"
                                </cfif>></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-organizational_units">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" <cfif listfirst(attributes.fuseaction,'.') eq 'myhome'>readonly</cfif>>
                                <cfoutput query="get_branches" group="NICK_NAME">
                                    <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                    <cfoutput>
                                        <option value="#get_branches.BRANCH_ID#"<cfif listlast(session.ep.user_location,'-') eq branch_id and listfirst(attributes.fuseaction,'.') eq 'myhome'> selected<cfelseif get_expense.branch_id eq branch_id>selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                    </cfoutput>
                                </cfoutput>
                            </select>
                        </div>
                    </div>            
                    <div class="form-group" id="item-organizational_units">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-xs-12" id="department_div">
                            <select name="DEPARTMENT_ID" id="DEPARTMENT_ID" <cfif listfirst(attributes.fuseaction,'.') eq 'myhome' and listfirst(attributes.fuseaction,'.') eq 'myhome'>readonly</cfif>> 
                                <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                                <cfif listfirst(attributes.fuseaction,'.') eq 'myhome' and listfirst(attributes.fuseaction,'.') eq 'myhome'>   
                                    <cfoutput query="get_department">
                                        <option value="#department_id#" <cfif listfirst(session.ep.user_location,'-') eq get_department.department_id>selected</cfif>>#department_head#</option>
                                    </cfoutput>
                                <cfelse>
                                    <cfoutput query="get_department">
                                        <option value="#department_id#" <cfif get_expense.department_id eq department_id>selected</cfif>>#department_head#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-expense_date"><!---Belge Tarihi--->
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33203.Belge Tarihi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="text" name="expense_date" id="expense_date" value="#dateformat(get_expense.expense_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#alert#" readonly maxlength="10" style="width:120px;" onblur="change_money_info('add_health_expense','expense_date');changeProcessDate();">
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
                                <cfif not len(get_expense.process_date)>
                                    <cfset p_date = get_expense.expense_date>
                                <cfelse>
                                    <cfset p_date = get_expense.process_date>
                                </cfif>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz !'></cfsavecontent>
                                <cfinput type="text" name="process_date" style="width:100px;" required="Yes" message="#message#" value="#dateformat(p_date,dateformat_style)#" validate="#validate_style#" passthrough="onBlur=""change_money_info('add_health_expense','process_date');""">
                                <span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date" call_function="change_money_info"></span>
                            </div>
                        </div>
                        </div>
                <cfif listFirst(attributes.fuseaction,'.') eq 'hr'>
                    <div class="form-group" id="item-payment_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfif not len(get_expense.payment_date)>
                                    <cfinput type="text" name="payment_date" value="" validate="#validate_style#" onblur="change_money_info('add_health_expense','payment_date');">
                                <cfelse>
                                    <cfinput type="text" name="payment_date" value="#dateformat(get_expense.payment_date,dateformat_style)#" validate="#validate_style#" onblur="change_money_info('add_health_expense','payment_date');">
                                </cfif>
                                <span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>">
                                    <cf_wrk_date_image date_field="payment_date" call_function="change_money_info">
                                </span>
                            </div>
                        </div>
                    </div>
                </cfif>
                    <div class="form-group" id="item-expense_paper_type"><!---Belge Türü--->
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58578.Belge Türü'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="expense_paper_type" id="expense_paper_type">
                                <option value=""><cf_get_lang dictionary_id='58578.Belge Türü'></option>
                                <cfoutput query="get_document_type">
                                    <option value="#document_type_id#" <cfif get_expense.paper_type eq document_type_id>selected</cfif>>#document_type_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 
                    <div class="form-group" id="item-paper_number"><!---Belge No--->
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="paper_number" id="paper_number" value="<cfoutput>#get_expense.paper_no#</cfoutput>">
                        </div>
                    </div>
                    <cfif not len(get_expense.invoice_no)>
                        <div class="form-group" id="item-expense_company">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59941.Tedavi Yapan Kurum"></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="expense_comp_name" id="expense_comp_name" value="<cfoutput>#get_expense.COMPANY_NAME#</cfoutput>" <cfif isDefined("x_company_firm_type") and len(x_company_firm_type)>onFocus="AutoComplete_Create('expense_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\',\'\',\'\',\'<cfoutput>#x_company_firm_type#</cfoutput>\'','','','','3','250','return_company()','','1');"</cfif>>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-system_relation">
                        <label class="col col-4 col-xs-12">
                            <cfif not len(get_expense.invoice_no)>
                                <cf_get_lang dictionary_id="58133.Fatura No">
                            <cfelse>
                                <cf_get_lang dictionary_id='60244.Kaynak Belge No'>
                            </cfif>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <input name="system_relation" id="system_relation" type="text" value="<cfoutput>#get_expense.system_relation#</cfoutput>">
                        </div>
                    </div>
                    <cfif len(get_expense.invoice_no)>
                        <div class="form-group" id="item-ch_member_type2">
                            <font color ="#E08283"><b><cf_get_lang dictionary_id="59585.Anlaşmalı kurum"></b></font>
                        </div>
                        <div class="form-group" id="item-ch_member_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59585.Anlaşmalı kurum"></label>
                            <div class="col col-8 col-xs-12">
                                <cfoutput>
                                    <div class="input-group">
                                        <cfif get_expense.member_type eq "employee">
                                            <cfset emp_id = get_expense.partner_id>
                                            <cfif len(get_expense.acc_type_id)>
                                                <cfset emp_id = "#emp_id#_#get_expense.acc_type_id#">
                                            </cfif>
                                        <cfelse>
                                            <cfset emp_id = ''>
                                        </cfif>
                                        <cfif len(get_expense.company_id)>
                                            <cfset ch_member_type="partner">
                                        <cfelseif len(get_expense.consumer_id)>
                                            <cfset ch_member_type="consumer">
                                        <cfelseif len(get_expense.emp_id)>
                                            <cfset ch_member_type="employee">
                                        <cfelse>
                                            <cfset ch_member_type="">
                                        </cfif>
                                        <input type="hidden" name="ch_member_type" id="ch_member_type" value="#get_expense.member_type#">
                                        <input type="hidden" name="ch_company_id" id="ch_company_id" value="#get_expense.company_id#">
                                        <input type="hidden" name="ch_partner_id" id="ch_partner_id" value="<cfif get_expense.member_type eq "partner">#get_expense.partner_id#<cfelseif get_expense.member_type eq "consumer">#get_expense.consumer_id#</cfif>">
                                        <input type="hidden" name="emp_id" id="emp_id" value="#emp_id#">
                                        <input type="text" name="ch_company" id="ch_company" style="width:135px;" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'\',\'\',\'\',\'\',\'\',\'\',\'1\'','MEMBER_TYPE,COMPANY_ID,PARTNER_CODE,EMPLOYEE_ID,MEMBER_PARTNER_NAME','ch_member_type,ch_company_id,ch_partner_id,emp_id,ch_partner','','3','250','return_company()');" value="<cfif get_expense.member_type eq 'partner'>#get_par_info(get_expense.company_id,1,1,0)#<cfelseif get_expense.member_type eq 'consumer'>#get_cons_info(get_expense.consumer_id,0,0)#<cfelseif get_expense.member_type eq 'employee'>#get_emp_info(get_expense.partner_id,0,0,0,get_expense.acc_type_id)#</cfif>" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_id=add_health_expense.ch_partner_id&field_name=add_health_expense.ch_company&field_comp_name=add_health_expense.ch_company&field_comp_id=add_health_expense.ch_company_id&field_type=add_health_expense.ch_member_type&field_emp_id=add_health_expense.emp_id&call_function=change_due_date()<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3,9','list');"></span>
                                    </div>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group" id="item-serial_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58133.Fatura No"></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="serial_number" id="serial_number" maxlength="5" value="<cfoutput>#get_expense.invoice_no#</cfoutput>">
                            </div> 
                        </div>
                        <div class="form-group" id="item-invoice_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58759.Fatura Tarihi"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfoutput>   
                                        <input type="text" name="invoice_date" id="invoice_date" value="<cfif isdefined("get_expense")>#dateformat(get_expense.invoice_date,dateformat_style)#<cfelse>#dateformat(now(),dateformat_style)#</cfif>" validate="#validate_style#" required="yes" message="#alert#" readonly maxlength="10" style="width:120px;" onblur="change_money_info('add_health_expense','invoice_date');">
                                        <span class="input-group-addon btnPointer">
                                            <cf_wrk_date_image date_field="invoice_date" call_function="change_money_info">
                                        </span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <cfset company_name		= '' />
                    <cfset invoice_number	= '' />
                    <cfif Len(get_expense.RECEIVING_ID)>
                        <cfquery name="GET_INV_DET" datasource="#DSN2#">
                            SELECT
                                EINVOICE_ID,
                                PARTY_NAME
                            FROM
                                EINVOICE_RECEIVING_DETAIL
                            WHERE
                                RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.RECEIVING_ID#">
                        </cfquery>
                        <cfset company_name		= GET_INV_DET.PARTY_NAME />
                        <cfset invoice_number	= GET_INV_DET.EINVOICE_ID />
                    </cfif>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">                    
                    <div class="form-group" id="item-tedavi">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="34712.Tedavi Gören"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="is_relative" id="is_relative" onchange="getRelatives(<cfoutput>'#new_emp_id#'</cfoutput>)">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <option value="1" <cfif len(get_expense.treated) and get_expense.treated eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="40429.kendisi"></option>
                                <option value="2" <cfif len(get_expense.treated) and get_expense.treated eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id="40117.yakını"></option>
                            </select>
                        </div>
                    </div> 
                    <div id="Choosen">                                    
                        <cfset relative_level_name_list = "#getLang('myhome',1204,'babası')#,#getLang('myhome',1205,'annesi')#,#getLang('myhome',572,'Eşi')#,#getLang('myhome',573,'Oğlu')#,#getLang('myhome',574,'Kızı')#,#getLang('myhome',692,'Kardeşi')#">
                        <div class="form-group" id="item-relative" <cfif not len(get_expense.relative_id)>style="display:none"</cfif>>
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55820.Yakınlığı'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(get_expense.emp_id)>
                                    <cfquery name="get_relative" datasource="#dsn#">
                                        select RELATIVE_ID, NAME + ' ' + SURNAME AS FULLNAME,RELATIVE_LEVEL from EMPLOYEES_RELATIVES where employee_Id = #get_expense.emp_id#
                                    </cfquery>
                                <cfelse>
                                    <cfset get_relative.recordcount = 0>
                                </cfif>
                                <select name="relative_id" id="relative_id" onchange="policyControl()">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfif get_relative.recordcount>
                                        <cfoutput query="get_relative">
                                            <cfset relative_level_name = RELATIVE_LEVEL>
                                            <option value="#relative_id#" <cfif get_expense.relative_id eq relative_id> selected</cfif>>#get_relative.FULLNAME# - #listGetAt(relative_level_name_list,RELATIVE_LEVEL)#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                                <label class="col col-12 col-xs-12" id="policy_control" style="color:red;display:none;"><cf_get_lang dictionary_id='61971.Çalışan yakınına ait poliçe bulunmakta'>!</label>
                            </div>    
                        </div> 
                    </div>
                    <div class="form-group" id="item-assurance_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58689.Teminat"><cf_get_lang dictionary_id="38937.Tipi"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="assurance_id" id="assurance_id" onChange="get_treatment();">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_assurance">
                                        <cfif RATE neq ""><option value="#assurance_id#_1" <cfif get_expense.assurance_id eq assurance_id and get_expense.assurance_type_id eq 1>selected</cfif>>#ASSURANCE# - SGK</option></cfif>
                                        <cfif PRIVATE_RATE neq ""><option value="#assurance_id#_2" <cfif get_expense.assurance_id eq assurance_id and get_expense.assurance_type_id eq 2>selected</cfif>>#ASSURANCE#</option></cfif>
                                        <cfif RATE eq "" and PRIVATE_RATE eq ""><option value="#assurance_id#_0" <cfif get_expense.assurance_id eq assurance_id and get_expense.assurance_type_id eq 0>selected</cfif>>#ASSURANCE#</option></cfif>
                                    </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-treatment_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56623.Tedavi"><cf_get_lang dictionary_id="58651.Türü"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="treatment_id" id="treatment_id">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_treatment">
                                        <option value="#treatment_id#" <cfif get_expense.treatment_id eq treatment_id>selected</cfif>>#TREATMENT#</option>
                                    </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-reason_ill">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36199.Açıklama"></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <textarea name="reason_ill" id="reason_ill" value="" style="width:175px;height:45px;">#get_expense.detail#</textarea>
                            </cfoutput>
                        </div>
                    </div>
                <cfif not len(get_expense.invoice_no) and x_kdv_inpterrupt eq 1>
                    <div class="form-group" id="item-kdv_amounts">
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
                                    <input type="text" class="moneybox" name="amount_1" id="amount_1" value="<cfoutput>#TLFormat(get_expense.AMOUNT_1,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <input type="text" readonly class="moneybox" name="kdv_1" id="kdv_1" value="8">
                                </div>
                                <div class="col col-5 col-xs-12">
                                    <input type="text" class="moneybox" name="amount_kdv_1" id="amount_kdv_1" value="<cfoutput>#TLFormat(get_expense.AMOUNT_KDV_1,x_rnd_nmbr)#</cfoutput>" onChange="getReverseTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                </div>
                            </div>
                            <!--- TutarB --->
                            <div class="col col-12 col-xs-12 mb-1 padding-0">
                                <div class="col col-5 col-xs-12">
                                    <input type="text" class="moneybox" name="amount_2" id="amount_2" value="<cfoutput>#TLFormat(get_expense.AMOUNT_2,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <input type="text" readonly class="moneybox" name="kdv_2" id="kdv_2" value="18">
                                </div>
                                <div class="col col-5 col-xs-12">
                                    <input type="text" class="moneybox" name="amount_kdv_2" id="amount_kdv_2" value="<cfoutput>#TLFormat(get_expense.AMOUNT_KDV_2,x_rnd_nmbr)#</cfoutput>" onChange="getReverseTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                </div>
                            </div>
                            <!--- TutarC --->
                            <div class="col col-12 col-xs-12 mb-1 padding-0">
                                <div class="col col-5 col-xs-12">
                                    <input type="text" class="moneybox" name="amount_3" id="amount_3" value="<cfoutput>#TLFormat(get_expense.AMOUNT_3,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <input type="text" readonly class="moneybox" name="kdv_3" id="kdv_3" value="1">
                                </div>
                                <div class="col col-5 col-xs-12">
                                    <input type="text" class="moneybox" name="amount_kdv_3" id="amount_kdv_3" value="<cfoutput>#TLFormat(get_expense.AMOUNT_KDV_3,x_rnd_nmbr)#</cfoutput>" onChange="getReverseTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                </div>
                            </div>
                            <!--- TutarD --->
                            <div class="col col-12 col-xs-12 mb-1 padding-0">
                                <div class="col col-5 col-xs-12">
                                    <input type="text" class="moneybox" name="amount_4" id="amount_4" value="<cfoutput>#TLFormat(get_expense.AMOUNT_4,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                </div>
                                <div class="col col-2 col-xs-12">
                                    <input type="text" readonly class="moneybox" name="kdv_4" id="kdv_4" value="0">
                                </div>
                                <div class="col col-5 col-xs-12">
                                    <input type="text" class="moneybox" name="amount_kdv_4" id="amount_kdv_4" value="<cfoutput>#TLFormat(get_expense.AMOUNT_KDV_4,x_rnd_nmbr)#</cfoutput>" onChange="getReverseTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                                </div>
                            </div>
                        </div>
                    </div>
                </cfif>
                <cfif x_kdv_inpterrupt eq 1>
                    <div class="form-group" id="item-expense_amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59997.Harcama Tutarı"></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput class="moneybox" name="expense_amount" id="expense_amount" onChange="getTotalAmount();" value="#TLFormat(get_expense.TOTAL_AMOUNT,x_rnd_nmbr)#" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" style="width:120px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-kdv">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51311.KDV Tutar'></label>
                        <div class="col col-8 col-xs-12" class="moneybox">
                            <cfif isdefined("get_expense") and len(get_expense.NET_KDV_AMOUNT)>
                                <cfset kdv_total = get_expense.NET_KDV_AMOUNT>
                            <cfelse>
                                <cfset kdv_total = 0>
                            </cfif>
                            <cfif len(get_expense.invoice_no)>
                                <input type="text" class="moneybox" name="tax_value" id="tax_value" value="<cfoutput>#TLFormat(kdv_total,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" readonly="readonly">
                            <cfelse>
                                <input type="text" class="moneybox" name="tax_value" id="tax_value" value="<cfoutput>#TLFormat(kdv_total,x_rnd_nmbr)#</cfoutput>" onChange="getTotalAmount();" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));">
                            </cfif>
                        </div>
                    </div>
                </cfif>
                    <div class="form-group" id="item-net_total_amount">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="48323.Fatura Tutarı">*</label>
                        <div class="col col-2 col-xs-12">
                            <select name="moneyType" id = "moneyType" style="width:57px;" class="boxtext" <cfif get_expense.EXPENSE_ITEM_PLANS_ID neq ''>disabled</cfif>>
                                <cfoutput query="get_money">
                                    <option value="#money#" <cfif isDefined("get_expense.MONEY") and len(get_expense.MONEY) and get_expense.MONEY eq money>selected</cfif>>#money#</option>
                                </cfoutput>
                            </select>
                        </div>
                        <div class="col col-6 col-xs-12">
                            <cfif x_kdv_inpterrupt eq 1>
                                <cfinput readonly class="moneybox" name="lastTotal" id="lastTotal" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" value="#TLFormat(get_expense.NET_TOTAL_AMOUNT,x_rnd_nmbr)#" style="width:120px;" />
                            <cfelse>
                                <cfinput class="moneybox" name="lastTotal" id="lastTotal" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" value="#TLFormat(get_expense.NET_TOTAL_AMOUNT,x_rnd_nmbr)#" style="width:120px;" onChange="getTotalAmount();" />
                            </cfif>
                        </div>
                    </div>
                    <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
                        <div class="form-group" id="item-treatment_amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59887.Tedaviye Esas Tutar"></label>
                            <div class="col col-2 col-xs-12">
                                <cfinput class="moneybox" name="treatment_rate" id="treatment_rate" value="#TLFormat(get_expense.TREATMENT_AMOUNT_RATE,x_rnd_nmbr)#" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="calculationTreatmentAmount(this)">
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cfif x_kdv_inpterrupt eq 1>
                                    <cfinput readonly class="moneybox" name="TreatmentlastTotal" id="TreatmentlastTotal" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" value="#TLFormat(get_expense.TREATMENT_AMOUNT,x_rnd_nmbr)#" onchange="ourCompanyHealth(this)" style="width:120px;">
                                <cfelse>
                                    <cfinput class="moneybox" name="TreatmentlastTotal" id="TreatmentlastTotal" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" value="#TLFormat(get_expense.TREATMENT_AMOUNT,x_rnd_nmbr)#" onchange="getReverseLastTotal()" style="width:120px;">
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-our-company-health-amount2">
                            <font color ="#E08283"><b><cf_get_lang dictionary_id="59626.limit - Ödenek ve kesinti"></b></font>
                        </div>
                        <div class="form-group" id="item-our-company-health-amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41154.Kurum Payı">%</label>
                            <div class="col col-2 col-xs-12">
                                <cfinput class="moneybox" name="comp_health_rate" id="comp_health_rate" value="#TLFormat(get_expense.COMPANY_AMOUNT_RATE,x_rnd_nmbr)#" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="calculationAmount(this)">
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cfinput readonly class="moneybox" name="our_company_health_amount" id="our_company_health_amount" value="#TLFormat(get_expense.OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#" style="width:120px;" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="ourCompanyHealth(this)"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-employee-health-amount">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41148.Çalışan Payı"></label>
                            <div class="col col-2 col-xs-12">
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cfinput readonly class="moneybox" name="employee_health_amount" id="employee_health_amount" value="#TLFormat(get_expense.EMPLOYEE_HEALTH_AMOUNT,x_rnd_nmbr)#" style="width:120px;" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="ourCompanyHealth(this)"/>
                            </div>
                        </div>
                        <div class="form-group" id="item-interrupt">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58621.Limit Aşımı"> - <cf_get_lang dictionary_id="60173.Ek Kesinti"></label>
                            <div class="col col-2 col-xs-12">
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cfinput class="moneybox" name="interrupt" id="interrupt" value="#TLFormat(get_expense.PAYMENT_INTERRUPTION_VALUE,x_rnd_nmbr)#" onkeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="ourCompanyHealth(this)">
                            </div>
                        </div>
                    </cfif>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                    <cf_record_info query_name="get_expense" record_emp="record_emp" update_emp="UPDATE_EMP">
                    <cf_basket_form_button margintop="1">
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_health_expense_approve&health_id=#attributes.health_id#&is_del=1&EXPENSE_ITEM_PLANS_ID=#get_expense.EXPENSE_ITEM_PLANS_ID#&process_stage=#get_expense.EXPENSE_STAGE#&active_period=#session.ep.period_id#">
                    <cfif listFirst(attributes.fuseaction,'.') eq 'hr'>
                        <!--- <input type="button" class = '<cfif len(get_expense.HEALTH_APPROVE) and get_expense.HEALTH_APPROVE eq 1>btn grey<cfelse>btn blue</cfif>' value="<cf_get_lang dictionary_id = '59634.HArcamayı onayla'>" onclick='approve_salary_param()' <cfif len(get_expense.HEALTH_APPROVE) and get_expense.HEALTH_APPROVE eq 1>disabled</cfif>> --->
                        <cfif len(get_expense.EXPENSE_ITEM_PLANS_ID)>
                            <input type = "hidden" name = "EXPENSE_ITEM_PLANS_ID" value = "<cfif len(get_expense.EXPENSE_ITEM_PLANS_ID)><cfoutput>#get_expense.EXPENSE_ITEM_PLANS_ID#</cfoutput></cfif>">
                            <input type="button" value="<cf_get_lang dictionary_id='64642.Harcama Fişine Git'>"  class="ui-btn ui-btn-success"onclick='goToHealthExpenseReceipt(<cfoutput>#get_expense.EXPENSE_ITEM_PLANS_ID#</cfoutput>)'>
                        </cfif>
                    </cfif>
                    </cf_basket_form_button>
            </cf_box_footer>
        </cf_box>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='56623.Tedavi'> <cf_get_lang dictionary_id='35919.İlaç ve Malzemeler'></cfsavecontent>
        <cf_box id="is_medicine_complation_box" title="#message#" closable="0" box_page="#request.self#?fuseaction=health.expense_detail&health_id=#attributes.health_id#&emp_id=#get_expense.emp_id#&assurance_id=#get_expense.assurance_id#">
            <div id="is_medicine_complation" >
            </div>
        </cf_box>
    </cfform>
</div>
<div class="col col-3 col-xs-12 uniqueRow">
    <cfif listFirst(attributes.fuseaction,'.') eq 'hr'>
        <cfif x_show_process_box eq 1>
            <div class="row" type="row">
                <cfsavecontent variable="process_box_title"><cf_get_lang dictionary_id="36301.Süreç Güncelle"></cfsavecontent>
                <cf_box id="box_upd_health_expense_process" title="#process_box_title#" closable="0" collapsable="1" box_page="#request.self#?fuseaction=hr.emptypopup_upd_health_expense_process&health_id=#attributes.health_id#">
                </cf_box>
            </div>
        </cfif>
    </cfif>
    <div class="row" type="row">                       
        <cfif fusebox.circuit eq 'hr'>
            <cf_get_workcube_asset asset_cat_id="-17" module_id='70' company_id='#session.ep.company_id#' period_id='#session.ep.period_id#' action_section='EXPENSE_ITEM_PLAN_REQUESTS' action_id='#attributes.health_id#'>    
        <cfelse>
            <cf_get_workcube_asset asset_cat_id="-17" module_id='81' company_id='#session.ep.company_id#' period_id='#session.ep.period_id#' action_section='EXPENSE_ITEM_PLAN_REQUESTS' action_id='#attributes.health_id#'>    
        </cfif>                                        
    </div>
    <div class="row" type="row">
        <cfinclude template="../../hr/display/list_my_health_expenses_total.cfm">
    </div>
</div>

<script type="text/javascript">
    var x_rnd_nmbr = <cfoutput>#x_rnd_nmbr#</cfoutput>;
    
    $(document).ready(function() {
        $('#paper_number').attr('readonly', true);
        policyControl();

        <cfif len( get_expense.EXPENSE_ITEM_PLANS_ID) and health_invoice_control.recordcount>
            $('.fa-tags').css('color','green');
        <cfelseif len( get_expense.EXPENSE_ITEM_PLANS_ID) and not health_invoice_control.recordcount>
            $('.fa-tags').css('color','red');
        </cfif>
    });
    function changeProcessDate(){
        $("#process_date").val($("#expense_date").val());
    }
    <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
        get_load_rate = wrk_safe_query('get_limit_rate_by_assurance','dsn',0,$("#assurance_id").val().split("_",1) + "*" + $("#assurance_id").val().split("_",2)[1]);
        if(get_load_rate.recordcount){
            <cfif get_expense.TREATMENT_AMOUNT_RATE eq "">
                <cfif len(get_expense.invoice_no)>
                    <cfif x_is_employee_amount eq 1>
                        $('#treatment_rate').val(commaSplit(get_load_rate.RATE,x_rnd_nmbr));
                    <cfelseif x_is_employee_amount eq 0>
                        $('#treatment_rate').val(commaSplit(100,x_rnd_nmbr));
                    </cfif>
                <cfelse>
                    $('#treatment_rate').val(commaSplit(100,x_rnd_nmbr));
                </cfif>
            </cfif>
            <cfif get_expense.COMPANY_AMOUNT_RATE eq "">
                $('#comp_health_rate').val(commaSplit(get_load_rate.RATE,x_rnd_nmbr));
            </cfif>
        }
        else{
            <cfif get_expense.TREATMENT_AMOUNT_RATE eq "">
                $('#treatment_rate').val(commaSplit(100,x_rnd_nmbr));
            </cfif>
            <cfif get_expense.COMPANY_AMOUNT_RATE eq "">
                $('#comp_health_rate').val(commaSplit(100,x_rnd_nmbr));
            </cfif>
        }
        <cfif not len(get_expense.OUR_COMPANY_HEALTH_AMOUNT) and not len(get_expense.TREATMENT_AMOUNT) and not len(get_expense.EMPLOYEE_HEALTH_AMOUNT)>
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

                    if($("#assurance_id").val() != "" && $('#lastTotal').val() != '' && filterNum($('#lastTotal').val(),x_rnd_nmbr) != 0 && $('#TreatmentlastTotal').val() != '' && filterNum($('#TreatmentlastTotal').val(),x_rnd_nmbr) != 0){

                        var assurance_id =  $("#assurance_id").val().split("_",1);

                        var assurance_types = $("#assurance_id").val().split("_",2)[1];

                        user_id = <cfoutput>#get_expense.emp_id#</cfoutput>;

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

    <cfif len(get_expense.TREATED) and get_expense.TREATED eq 1>
        $('#item-relative').css('display','none');
    </cfif>

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

    function sendtoExpenseReceipt(){
        $("#add_health_expense").attr("action", "<cfoutput>#request.self#</cfoutput>?fuseaction=health.expenses&event=add&health_id=<cfoutput>#attributes.health_id#</cfoutput>");
        $("#add_health_expense").submit();
    }

    function goToHealthExpenseReceipt(expense_id) {
        window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=health.expenses&event=upd&expense_id=" + expense_id;
        window.location.target = '_blank';
        return false;
    }

    function kontrol(){
            //if(!paper_control(add_health_expense.paper_number,'health_allowence_expense')) return false;
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
        <cfif not len(get_expense.invoice_no)>
            check_emp_id = $('#expense_employee_id').val();
            check_system_rel = $('#system_relation').val();
            check_comp_name = $('#expense_comp_name').val();
            check_expense_date = js_date($('#expense_date').val());
            check_expense_id = <cfoutput>#attributes.health_id#</cfoutput>;
            if(check_emp_id != '' && check_system_rel != '' && check_comp_name != ''){
                var listParam = check_emp_id + "*" + check_system_rel + "*" + check_comp_name + "*" + check_expense_date + "*" + check_expense_id;
                health_expense_control = wrk_safe_query('health_expense_control','dsn2',0,listParam);
                if(health_expense_control.recordcount != 0){
                    alert("<cf_get_lang dictionary_id='60279.Kontrol ediniz.'>");
                    return false;
                }
            }
        //Anlaşmalı Kurum mükerrer kayıt kontrolü
        <cfelseif len(get_expense.invoice_no)>
            check_comp_id = $('#ch_company_id').val();
            check_invoice_no = $('#serial_number').val();
            check_invoice_date = js_date($('#invoice_date').val());
            check_expense_id = <cfoutput>#attributes.health_id#</cfoutput>;
            if(check_comp_id != '' && check_invoice_no != '' && check_invoice_date != ''){
                var listParam = check_comp_id + "*" + check_invoice_no + "*" + check_invoice_date + "*" + check_expense_id;
                health_expense_control = wrk_safe_query('health_expense_control_efatura','dsn2',0,listParam);
                if(health_expense_control.recordcount != 0){
                    alert("<cf_get_lang dictionary_id='60306.Kontrol ediniz.'>");
                    return false;
                }
            }
        </cfif>
        
        <cfif listFirst(attributes.fuseaction,'.') eq 'hr'>
            <cfif not len(get_expense.invoice_no)>
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
        harcama_tutari = parseFloat(filterNum($('#lastTotal').val(), x_rnd_nmbr));
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

        //Onaylanmış ve ödenmiş harcamalar çekiliyor.
        var sum_employee_expense = wrk_safe_query('get_emp_sum_health_expense','dsn2',0,user_id+"*"+group_assurance_ids+"*"+relative_id+"*"+"<cfoutput>#attributes.health_id#</cfoutput>");
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
                last_rate = toplam * 100 / fatura_tutari;

                <cfif len(get_expense.invoice_no)>

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
                    <cfif len(get_expense.invoice_no)>
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

    function unformat_fields(){
        <cfif not len(attributes.expense_id) and x_kdv_inpterrupt eq 1>
            if($("#kdv_1").val() != undefined){
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

    function getReverseTotalAmount(){
        <cfif not len(get_expense.invoice_no) and x_kdv_inpterrupt eq 1>
            if($("#kdv_1").val() != undefined){
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
                <cfif listFirst(attributes.fuseaction,'.') eq 'hr'>
                    treatment_rate = document.getElementById('treatment_rate');
                    if(treatment_rate.value != '' && parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)) != 0){
                        calculationTreatmentAmount(treatment_rate);
                        calculationAmount(document.getElementById('comp_health_rate'));
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
        <cfif not len(get_expense.invoice_no) and x_kdv_inpterrupt eq 1>
            if($("#kdv_1").val() != undefined){
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
            if($("#expense_amount").val() == '') $("#expense_amount").val(0);
            if($("#tax_value").val() == '') $("#tax_value").val(0);
            exp_amount = parseFloat(filterNum($("#expense_amount").val(),x_rnd_nmbr));
            tax_amount = parseFloat(filterNum($("#tax_value").val(),x_rnd_nmbr));
            total_amount = tax_amount + exp_amount;
            document.getElementById("expense_amount").value = commaSplit(filterNum(document.getElementById("expense_amount").value,x_rnd_nmbr),x_rnd_nmbr);
            document.getElementById("tax_value").value = commaSplit(filterNum(document.getElementById("tax_value").value,x_rnd_nmbr),x_rnd_nmbr);
            document.getElementById("lastTotal").value = commaSplit(total_amount,x_rnd_nmbr);
        </cfif>
        if($("#lastTotal").val() == '') $("#lastTotal").val(commaSplit(0,x_rnd_nmbr));
        else $("#lastTotal").val(commaSplit(filterNum($("#lastTotal").val(),x_rnd_nmbr),x_rnd_nmbr));
        <cfif listFirst(attributes.fuseaction,'.') eq 'hr'>
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
            $('#item-relative').show();
            var getRelatives= wrk_safe_query('get_employees_relatives','dsn',0,listparam);
            var relative_name_list = "<cfoutput>#getLang('myhome',1204,'babası')#,#getLang('myhome',1205,'annesi')#,#getLang('myhome',572,'Eşi')#,#getLang('myhome',573,'Oğlu')#,#getLang('myhome',574,'Kızı')#,#getLang('myhome',692,'Kardeşi')#</cfoutput>";
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

    function showDepartment(branch_id)	
    {
        var branch_id = document.getElementById('branch_id').value;
        if (branch_id != "")
        {
            var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
            AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
        }
    }

    function reset_fields() {
        $('#company_id').val('');
        $('#company_name').val('');
        $('#receiving_id').val('');
        $('#invoice_number').val('');
        $('#lastTotal').val(0);
        <cfif x_kdv_inpterrupt eq 1>
            $('#expense_amount').val(0);
            $('#tax_value').val(0);
        </cfif>
        <cfif attributes.fuseaction eq 'hr.health_expense_approve'>
            $('#comp_health_rate').val(0);
            $('#our_company_health_amount').val(0);
            $('#employee_health_amount').val(0);
            $('#TreatmentlastTotal').val(0);
            $('#treatment_rate').val(0);
        </cfif>
    }

    function ourCompanyHealth(obj){
        obj.value = commaSplit(parseFloat(filterNum(obj.value,x_rnd_nmbr)),x_rnd_nmbr);
    }    
    function approve_salary_param(type){
        if(confirm('<cf_get_lang dictionary_id="59998.Harcamayı onaylamak istediğinizden emin misiniz">?'))
        {
            unformat_fields();
            $("#add_health_expense").attr("action", "<cfoutput>#request.self#?fuseaction=hr.health_expense_approve&event=approve</cfoutput>&type="+type)
            $("#add_health_expense").submit();
        }
        else
        {
            return false;
        }

    }       
    function change_dept()	
    {
        var branch_id = document.getElementById('branch_id').value;
        if (branch_id != "")
        {
            var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
            AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
            var delayInMilliseconds = 1000; //1 second
            console.log(document.getElementById('dept_id').value);
            setTimeout(function() {
                document.getElementById('DEPARTMENT_ID').value = document.getElementById('dept_id').value;
            }, delayInMilliseconds);
            console.log(document.getElementById('DEPARTMENT_ID').value);
        }
    }    
</script>