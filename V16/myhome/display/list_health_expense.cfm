<!---
    File: list_health_expense.cfm
    Controller: HealthExpenseController.cfm
    Folder: myhome\display\
    Author: Canan Ebret
    Date: 2019-12-01 12:36:49 
    Description:
        Sağlık modülü tedavi harcama taleplerinin listelenmesi için kullanılır
        HR ve Myhome modülü ortak kullanım sayfadır
    History:
        
    To Do:
--->
<cf_xml_page_edit fuseact="hr.health_expense_approve">
    <cfif (not isDefined("x_rnd_nmbr")) or (isDefined("x_rnd_nmbr") and not len(x_rnd_nmbr))>
        <cfset x_rnd_nmbr = 2>
    </cfif>
    <cfset getComponent = createObject('component','V16.process.cfc.get_design') />
    <cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
        <cfset attributes.maxrows = session.ep.maxrows />
    </cfif>
    <cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt attributes.maxrows>
        <cfset attributes.maxrows = Listlen(attributes.action_list_id)>
    </cfif>
    <cfparam name="attributes.page" default="1" />
    <cfparam name="attributes.is_link" default="" />
    <cfparam name="attributes.start_date" default="" />
    <cfparam name="attributes.finish_date" default="" />
    <cfparam name="attributes.keyword" default="" />
    <cfparam name="attributes.new_emp_id" default="" />
    <cfparam name="attributes.expense_employee" default="" />
    <cfparam name="attributes.expense_employee_id" type="numeric" default="-1" />
    <cfparam name="attributes.upd_employee_id" default="" />
    <cfparam name="attributes.upd_employee" default="" />
    <cfparam name="attributes.branch_name" default="" />
    <cfparam name="attributes.expense_stage" default="" />
    <cfparam name="attributes.assurance_id" default="" />
    <cfparam name="attributes.expense_branch" default="" />
    <cfparam name="attributes.treatment_id" default="" />
    <cfparam name="attributes.expense_department" default="" />
    <cfparam name="attributes.search_date1" default="">
    <cfparam name="attributes.search_date2" default="">
    <cfparam name="attributes.payment_date1" default="">
    <cfparam name="attributes.payment_date2" default="">
    <cfparam name="attributes.sortType" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.box_submitted" default="" />
    <cfparam name="attributes.process_cat_id" default="" />
    <cfparam name="attributes.is_relative" default="" />
    <cfparam name="attributes.is_invoice" default="" />
    <cfparam name="attributes.group_paper_no" default="" />
    <cfif len(attributes.upd_employee_id)>
        <cfset attributes.upd_employee_id = listfirst(attributes.upd_employee_id,'_')>
    </cfif>
    <cfif listfirst(attributes.fuseaction,'.') eq 'hr'>
        <cfif attributes.box_submitted eq 1>
            <cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0 and not isdefined("attributes.is_excel") and not isDefined("attributes.create_excel")>
                <cfset totalValues = structNew()>
                <cfset totalValues = {
                    amount_last_total : #attributes.amount_last_total#,
                    treatment_last_total : #attributes.treatment_last_total#,
                    comp_last_total : #attributes.comp_last_total#,
                    emp_last_total : #attributes.emp_last_total#
                }>
                <cf_workcube_general_process
                    mode = "query"
                    general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
                    general_paper_no = "#attributes.general_paper_no#"
                    general_paper_date = "#attributes.general_paper_date#"
                    action_list_id = "#attributes.action_list_id#"
                    process_stage = "#attributes.process_stage#"
                    general_paper_notice = "#attributes.general_paper_notice#"
                    responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
                    responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
                    action_table = 'EXPENSE_ITEM_PLAN_REQUESTS'
                    action_column = 'EXPENSE_ID'
                    action_page = '#request.self#?fuseaction=hr.health_expense_approve'
                    total_values = '#totalValues#'
                >
            </cfif>
        </cfif>
    </cfif>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 />
    <cfparam name="health_id" default="" />
    <cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
        <cf_date tarih = "attributes.search_date1">
    </cfif>
    <cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
        <cf_date tarih = "attributes.search_date2">
    </cfif>
    <cfif isdefined("attributes.payment_date1") and isdate(attributes.payment_date1)>
        <cf_date tarih = "attributes.payment_date1">
    </cfif>
    <cfif isdefined("attributes.payment_date2") and isdate(attributes.payment_date2)>
        <cf_date tarih = "attributes.payment_date2">
    </cfif>
    <cfset HealthExpense    = createObject("component","V16.myhome.cfc.health_expense") />
    <cfset GET_EXPENSE = HealthExpense.GET_EXPENSE_LIST(
            search_date1 :'#iif(isdefined("attributes.search_date1") and len(attributes.search_date1),"attributes.search_date1",DE(""))#',
            search_date2 :'#iif(isdefined("attributes.search_date2") and len(attributes.search_date2),"attributes.search_date2",DE(""))#',
            payment_date1 :'#iif(isdefined("attributes.payment_date1") and len(attributes.payment_date1),"attributes.payment_date1",DE(""))#',
            payment_date2 :'#iif(isdefined("attributes.payment_date2") and len(attributes.payment_date2),"attributes.payment_date2",DE(""))#',
            startrow :'#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
            maxrows :'#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
            keyword :'#attributes.keyword#',
            expense_stage: attributes.expense_stage,
            expense_branch: attributes.expense_branch,
            assurance_id: attributes.assurance_id,
            treatment_id: attributes.treatment_id,
            expense_department: attributes.expense_department,
            process_cat_id: attributes.process_cat_id,
            is_relative: '#iIf(len(attributes.is_relative),"attributes.is_relative",DE(""))#',
            is_invoice: '#iIf(len(attributes.is_invoice),"attributes.is_invoice",DE(""))#',
            module_name: fusebox.circuit,
            expense_type : 2,
            sortType: attributes.sortType,
            company_id : '#iif((len(attributes.company) or len(attributes.is_link)) and len(attributes.company_id),"attributes.company_id",DE(""))#',
            expense_employee: '#iif(isdefined("attributes.expense_employee") and Len(attributes.expense_employee) and attributes.expense_employee_id neq -1,"attributes.expense_employee_id",DE(-1))#',
            update_employee : '#iif(isDefined("attributes.upd_employee") and len(attributes.upd_employee) and len(attributes.upd_employee_id),"attributes.upd_employee_id",DE(""))#',
            row_expense_id : '#iif(isdefined("attributes.action_list_id") and len(attributes.action_list_id),"attributes.action_list_id",DE(""))#',
            group_paper_no : '#iif(len(attributes.group_paper_no),"attributes.group_paper_no",DE(""))#' 
        ) />
    <cfset get_assurance    = HealthExpense.GetAssurance() />
    <cfset get_treatment    = HealthExpense.GetTreatment() />
    <cfset get_branch       = HealthExpense.GetBranch() />
    <cfset get_department   = HealthExpense.GetDepartment() />
    <cfset get_process_type = HealthExpense.GetProcessType(fuseaction : attributes.fuseaction) />
    <cfset get_Accounts = HealthExpense.GET_ACCOUNTS()>
    <cfparam name="attributes.totalrecords" default='#GET_EXPENSE.query_count#' />
    
    <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
        <cfloop from="1" to="#GET_EXPENSE.recordcount#" index="i">  
            <cfset acc_no = GET_EXPENSE.BANK_ACCOUNT_NO[i]>
            <cfset iban_no = GET_EXPENSE.IBAN_NO[i]>
            <cfset emp = GET_EXPENSE.EMP_FULLNAME[i]>
        <cfif not len(acc_no) or not len(iban_no)>
            <script>
                alert("Lütfen <cfoutput>#emp# </cfoutput>"+"' nin banka bilgilerini kontrol ediniz");
                window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.health_expense_approve';
            </script>
            <cfabort>
        </cfif>
        </cfloop>
        <cfinclude template="health_expense_excel.cfm">
    </cfif>
    <cfif isDefined("attributes.create_excel") and attributes.create_excel eq 1>
        <cfinclude template="health_expense_excel.cfm">
    </cfif>
    <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.health_expense_approve" />
    
    <cfif isDefined('attributes.keyword') and Len(attributes.keyword)>
        <cfset adres = '#adres#&keyword=#attributes.keyword#' />
    </cfif>
    <cfif isDefined('attributes.expense_employee') and Len(attributes.expense_employee)>
        <cfset adres = '#adres#&expense_employee=#attributes.expense_employee#' />
    </cfif>
    <cfif isDefined('attributes.expense_employee_id') and Len(attributes.expense_employee_id)>
        <cfset adres = '#adres#&expense_employee_id=#attributes.expense_employee_id#' />
    </cfif>
    <cfif isDefined('attributes.upd_employee') and Len(attributes.upd_employee)>
        <cfset adres = '#adres#&upd_employee=#attributes.upd_employee#' />
    </cfif>
    <cfif isDefined('attributes.upd_employee_id') and Len(attributes.upd_employee_id)>
        <cfset adres = '#adres#&upd_employee_id=#attributes.upd_employee_id#' />
    </cfif>
    <cfif isDefined('attributes.expense_branch') and Len(attributes.expense_branch)>
        <cfset adres = '#adres#&expense_branch=#attributes.expense_branch#' />
    </cfif>
    <cfif isDefined('attributes.expense_department') and Len(attributes.expense_department)>
        <cfset adres = '#adres#&expense_department=#attributes.expense_department#' />
    </cfif>
    <cfif isDefined('attributes.assurance_id') and Len(attributes.assurance_id)>
        <cfset adres = '#adres#&assurance_id=#attributes.assurance_id#' />
    </cfif>
    <cfif isDefined('attributes.treatment_id') and Len(attributes.treatment_id)>
        <cfset adres = '#adres#&treatment_id=#attributes.treatment_id#' />
    </cfif>
    <cfif isDefined('attributes.expense_stage') and Len(attributes.expense_stage)>
        <cfset adres = '#adres#&expense_stage=#attributes.expense_stage#' />
    </cfif>
    <cfif isDefined('attributes.sortType') and Len(attributes.sortType)>
        <cfset adres = '#adres#&sortType=#attributes.sortType#' />
    </cfif>
    <cfif isDefined('attributes.company_id') and Len(attributes.company_id)>
        <cfset adres = '#adres#&company_id=#attributes.company_id#' />
    </cfif>
    <cfif isDefined('attributes.is_link') and Len(attributes.is_link)>
        <cfset adres = '#adres#&is_link=#attributes.is_link#' />
    </cfif>
    <cfif len(attributes.search_date1)>
        <cfset adres = "#adres#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#">
    </cfif>
    <cfif len(attributes.search_date2)>
        <cfset adres = "#adres#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#">
    </cfif>
    <cfif len(attributes.payment_date1)>
        <cfset adres = "#adres#&payment_date1=#dateformat(attributes.payment_date1,dateformat_style)#">
    </cfif>
    <cfif len(attributes.payment_date2)>
        <cfset adres = "#adres#&payment_date2=#dateformat(attributes.payment_date2,dateformat_style)#">
    </cfif>
    <cfif len(attributes.process_cat_id)>
        <cfset adres = "#adres#&process_cat_id=#attributes.process_cat_id#">
    </cfif>
    <cfif len(attributes.is_relative)>
        <cfset adres = "#adres#&is_relative=#attributes.is_relative#">
    </cfif>
    <cfif len(attributes.is_invoice)>
        <cfset adres = "#adres#&is_invoice=#attributes.is_invoice#">
    </cfif>
    <cfif isDefined('attributes.group_paper_no') and Len(attributes.group_paper_no)>
        <cfset adres = '#adres#&group_paper_no=#attributes.group_paper_no#' />
    </cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id="33706.Sağlık Harcaması"></cfsavecontent>
    <cfif listfirst(attributes.fuseaction,'.') eq 'hr'>
        <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
            SELECT 
                PROCESS_TYPE,
                PROCESS_CAT,
                PROCESS_CAT_ID
            FROM 
                SETUP_PROCESS_CAT
            WHERE 
                PROCESS_TYPE IN (2503,1201) ORDER BY PROCESS_TYPE
        </cfquery>
        <cfform name="health_expense_approve" method="post" action="">
            <cf_box id="list_health_expense_search">
                <cf_box_search plus="0">
                    <div class="form-group">
                        <input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="<cfoutput>#attributes.keyword#</cfoutput>" />
                    </div>
                    <cfif fusebox.circuit is 'myhome'>
                        <cfset attributes.new_emp_id   = session.ep.userid />
                    </cfif>
                    <cfif fusebox.circuit is 'hr'><!--- Yalnızca HR modülünde çalışan ve şube filtresi gelmeli mcifci 01.12.2019 --->
                    <div class="form-group">
                        <div class="input-group">
                            <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#attributes.expense_employee_id#</cfoutput>" />
                            <input type="text" name="expense_employee" id="expense_employee" placeholder="<cf_get_lang dictionary_id="57576.Çalışan">" onFocus="AutoComplete_Create('expense_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,MEMBER_TYPE','expense_employee_id','','3','135');" style="width:120px;" value="<cfif isDefined('attributes.expense_employee') And Len(attributes.expense_employee)><cfoutput>#get_emp_info(attributes.expense_employee_id,0,0)#</cfoutput></cfif>" />
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&field_emp_id=health_expense_approve.expense_employee_id&field_name=health_expense_approve.expense_employee&field_type=health_expense_approve.expense_employee_id&select_list=1,9','list');"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <input type="hidden" name="upd_employee_id" id="upd_employee_id" value="<cfoutput>#attributes.upd_employee_id#</cfoutput>" />
                            <input type="text" name="upd_employee" id="upd_employee" placeholder="<cf_get_lang dictionary_id="57891.Güncelleyen">" onFocus="AutoComplete_Create('upd_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID','upd_employee_id','','3','135');" style="width:120px;" value="<cfif isDefined('attributes.upd_employee') And Len(attributes.upd_employee)><cfoutput>#get_emp_info(attributes.upd_employee_id,0,0)#</cfoutput></cfif>" />
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&field_emp_id=health_expense_approve.upd_employee_id&field_name=health_expense_approve.upd_employee&field_type=health_expense_approve.upd_employee_id&select_list=1,9','list');"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <input type="text" name="group_paper_no" id="group_paper_no" placeholder="Toplu Belge No" value="<cfoutput>#attributes.group_paper_no#</cfoutput>" />
                    </div>
                    <cfelse>
                    <input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#attributes.new_emp_id#</cfoutput>">
                    </cfif>
                    <div class="form-group">
                        <select name="sortType" id="sortType">
                            <option value=""><cf_get_lang dictionary_id='30588.Sıralama Şekli'></option>
                            <option value="1" <cfif attributes.sortType eq 1>selected</cfif>><cf_get_lang dictionary_id="53668.Çalışana göre"></option>
                            <option value="2" <cfif attributes.sortType eq 2>selected</cfif>><cf_get_lang dictionary_id="59585.Anlaşmalı Kurum"></option>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function="kontrol()">
                    </div>
                    <cfoutput>
                        <div class="form-group">
                            <a class="ui-btn ui-btn-gray" href="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.health_expense_approve&event=add" ><i class="fa fa-plus" title = "<cf_get_lang dictionary_id ='44630.Ekle'>" alt="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a>
                        </div>
                    </cfoutput>
                </cf_box_search>
                <cf_box_search_detail>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        <div class="form-group">
                            <label class="col col-12"><cf_get_lang dictionary_id="58689.Teminat"><cf_get_lang dictionary_id="216.Tipi"></label>
                            <div class="col col-12">
                                <cf_multiselect_check
                                    name="assurance_id"
                                    option_name="ASSURANCE"
                                    option_value="assurance_id"
                                    width="130"
                                    value="#attributes.assurance_id#"
                                    query_name="get_assurance">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-12"><cf_get_lang dictionary_id="56623.Tedavi"><cf_get_lang dictionary_id="58651.Türü"></label>
                            <div class="col col-12">
                                <select name="treatment_id" id="treatment_id">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_treatment">
                                        <option value="#treatment_id#" <cfif attributes.treatment_id eq get_treatment.treatment_id>selected</cfif>>#TREATMENT#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_relative">
                            <label class="col col-12"><cf_get_lang dictionary_id="34712.Tedavi Gören"></label>
                            <div class="col col-12">
                                <select name="is_relative" id="is_relative">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <option value="1" <cfif attributes.is_relative eq 1>selected</cfif>><cf_get_lang dictionary_id="37769.kendisi"></option>
                                    <option value="2" <cfif attributes.is_relative eq 2>selected</cfif>><cf_get_lang dictionary_id="40117.yakını"></option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                        <cfif fusebox.circuit is 'myhome'>
                            <cfset attributes.new_emp_id   = session.ep.userid />
                        </cfif>
                        <div class="form-group">
                            <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-12">
                                <select name="expense_branch" id="expense_branch">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_branch">
                                        <option value="#branch_id#"<cfif attributes.expense_branch eq branch_id> selected</cfif>>#BRANCH_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-12">
                                <select name="expense_department" id="expense_department">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_department">
                                        <option value="#DEPARTMENT_ID#" <cfif attributes.expense_department eq DEPARTMENT_ID> selected</cfif>>#DEPARTMENT_HEAD#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-search_company">
                            <label class="col col-12"><cf_get_lang dictionary_id='59977.Sağlık Kurumu'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <input type="text" name="company" id="company" style="width:152px;" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\'','COMPANY_ID','company_id','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=health_expense_approve.company&field_comp_id=health_expense_approve.company_id','list');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                        <div class="form-group" id="form_ul_is_invoice">
                            <label class="col col-12"><cf_get_lang dictionary_id="59585.Anlaşmalı kurum"></label>
                            <div class="col col-12">
                                <select name="is_invoice" id="is_invoice" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <option value="1" <cfif attributes.is_invoice eq 1>selected</cfif>><cf_get_lang dictionary_id="57495.Evet"></option>
                                    <option value="2" <cfif attributes.is_invoice eq 2>selected</cfif>><cf_get_lang dictionary_id="57496.Hayır"></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-12"><cf_get_lang_main no='70.Aşama'></label>
                            <div class="col col-12">
                                <select name="expense_stage" id="expense_stage">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_process_type">
                                        <option value="#process_row_id#" <cfif attributes.expense_stage eq get_process_type.process_row_id>selected</cfif>>#stage#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="form_ul_cat">
                            <label class="col col-12"><cf_get_lang dictionary_id='57124.İşlem Kategorisi'></label>
                            <div class="col col-12">
                                <select name="process_cat_id" id="process_cat_id" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_process_cat">
                                    <option value="#process_cat_id#" <cfif '#process_cat_id#' is attributes.process_cat_id>selected</cfif>>#process_cat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
                        <div class="form-group" id="item-search_date">
                            <label class="col col-12"><cf_get_lang dictionary_id="33203.Belge Tarihi"></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="txt1"><cf_get_lang dictionary_id="57782.Tarih Değerini Kontrol Ediniz">!</cfsavecontent>
                                    <cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date1"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date2"></span> 
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-payment_date">
                            <label class="col col-12"><cf_get_lang dictionary_id="58851.Ödeme Tarihi"></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfinput type="text" name="payment_date1" value="#dateformat(attributes.payment_date1, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="payment_date1"></span>
                                    <span class="input-group-addon no-bg"></span>
                                    <cfinput type="text" name="payment_date2" value="#dateformat(attributes.payment_date2, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="payment_date2"></span> 
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_search_detail>
            </cf_box>
        </cfform>
    </cfif>
    <cfform name="setProcessForm" id="setProcessForm" method="post" action="">
        <cf_box id="list_health_expense_list"  title="#title#" hide_table_column="1" uidrop="1"> 
            <cfif not isDefined("attributes.wrkflow")>
                <input type="hidden" name="box_submitted" id="box_submitted" value="1">
            </cfif>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th class="drag-enable" width="50"><cf_get_lang dictionary_id="58577.Sıra"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable" width="50"><cf_get_lang dictionary_id='57880.Belge No'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable" width="50"><cf_get_lang dictionary_id='60286.Toplu Belge No'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="57576.Çalışan"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="34712.tedavi gören"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="59977.Sağlık Kurumu"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="58689.Teminat"><cf_get_lang dictionary_id="216.Tipi"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="56623.Tedavi"><cf_get_lang dictionary_id="58651.Türü"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="33203.Belge Tarihi"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="58794.Referans No"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="34434.Para Br"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="48323.Fatura Tutarı"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="59887.Tedaviye Esas Tutar"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="61027.Ödeme Oranı"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="41154.Kurum Payı"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id="41148.Çalışan Payı"><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang_main no='70.Aşama'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <cfif listfirst(attributes.fuseaction,'.') eq 'hr'>
                        <th class="drag-enable"><cf_get_lang dictionary_id='57124.İşlem Kategorisi'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        </cfif>
                        <th class="drag-enable"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <th class="drag-enable"><cf_get_lang dictionary_id='36234.Güncelleme Tarihi'><span class="table-handle"><i class="fa fa-sort"></i></span></th>
                        <!-- sil -->
                        <th width="20"><a href="javascript://"><i class="fa fa-link"></i></a></th>
                        <th width="20"><a href="<cfoutput>#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.health_expense_approve&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='44630.Ekle'>" alt="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a></th>
                        <cfif listfirst(attributes.fuseaction,'.') eq 'hr' and ( len(attributes.sortType) or isDefined("attributes.gp_id")) and len(attributes.expense_stage)>
                            <th><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0" total_value="0" amount_value="0" comp_value="0" emp_value="0" /></th>
                        </cfif>
                        <!-- sil -->
                    </tr>
                </thead>
                <cfif GET_EXPENSE.recordcount>
                    <cfset expense_stage_list = ''>
                    <cfoutput query="get_expense">
                        <cfif len(expense_stage) and not listfind(expense_stage_list,expense_stage)>
                            <cfset expense_stage_list=listappend(expense_stage_list,expense_stage)>
                        </cfif>
                    </cfoutput>
                    <cfif len(expense_stage_list)>
                        <cfquery name="get_stage" datasource="#dsn#">
                            SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#expense_stage_list#)
                        </cfquery> 
                        <cfset expense_stage_list = listsort(listdeleteduplicates(valuelist(get_stage.process_row_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <tbody>
                        <cfoutput query="GET_EXPENSE">
                            <cfif fusebox.circuit eq 'myhome'>
                                <cfset health_id = contentEncryptingandDecodingAES(isEncode:1,content:expense,accountKey:'wrk')>
                            <cfelse>
                                <cfset health_id = expense>
                            </cfif>
                                <tr>
                                    <cfset relative_name = '' />
                                    <td>#currentRow#</td>
                                    <td><a href="#request.self#?fuseaction=#fusebox.circuit#.health_expense_approve&event=upd&health_id=#health_id#">&nbsp;#paper_no#</a></td>
                                    <td>#GET_EXPENSE.general_paper_no#</td>
                                    <td><a href="#request.self#?fuseaction=#fusebox.circuit#.health_expense_approve&event=upd&#health_id#" target = "_blank" style="color:blue">#get_emp_info(EMP_ID, 0, 1)#</a></td> 
                                    <cfif Len(RELATIVE_ID) and len(RELATIVE_LEVEL)>
                                        <cfswitch expression="#RELATIVE_LEVEL#">
                                            <cfcase value="1">
                                                <cfset relative_name = 'Babası' />
                                            </cfcase>
                                            <cfcase value="2">
                                                <cfset relative_name = 'Annesi' />
                                            </cfcase>
                                            <cfcase value="3">
                                                <cfset relative_name = 'Eşi' />
                                            </cfcase>
                                            <cfcase value="4">
                                                <cfset relative_name = 'Oğlu' />
                                            </cfcase>
                                            <cfcase value="5">
                                                <cfset relative_name = 'Kızı' />
                                            </cfcase>
                                            <cfcase value="6">
                                                <cfset relative_name = 'Kardeşi' />
                                            </cfcase>
                                        </cfswitch>
                                        <td>#relative_name#</td>
                                    <cfelse>
                                        <td><cf_get_lang dictionary_id="40429.kendisi"></td>
                                    </cfif>
                                    <td>#BRANCH_NAME# - #DEPARTMENT_HEAD#</td>
                                    <td>
                                        <cfif len(company_id) or len(consumer_id)>
                                            <cfif len(company_id)>
                                                #get_par_info(company_id,1,1,0)#
                                            <cfelseif len(consumer_id)>
                                                #get_cons_info(consumer_id,2,0)#>
                                            </cfif>
                                        <cfelse>
                                            <cfif len(COMPANY_NAME)>
                                                #COMPANY_NAME#
                                            </cfif>
                                        </cfif>
                                    </td>
                                    <td>#ASSURANCE#<cfif assurance_type_id eq 1> - <cf_get_lang dictionary_id = "41536.Kamu"><cfelseif assurance_type_id eq 2> - <cf_get_lang dictionary_id = "57979.Özel"></cfif></td>
                                    <td>#TREATMENT#</td>
                                    <td>#dateFormat(EXP_DATE,dateformat_style)#</td>
                                    <td><cfif len(SYSTEM_RELATION)>#SYSTEM_RELATION#<cfelse>#INVOICE_NO#</cfif></td>
                                    <td style="text-align:right;">#MONEY#</td>
                                    <td style="text-align:right;">#TLFormat(AMOUNT,x_rnd_nmbr)#</td>
                                    <td style="text-align:right;">#TLFormat(TREATMENT_AMOUNT,x_rnd_nmbr)#</td>
                                    <td style="text-align:right;">#TLFormat(COMPANY_AMOUNT_RATE,x_rnd_nmbr)#</td>
                                    <td style="text-align:right;">#TLFormat(OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                                    <td style="text-align:right;">#TLFormat(EMPLOYEE_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                                    <td>
                                        <cfif len(expense_stage)>
                                            <cf_workcube_process type="color-status" process_stage="#expense_stage#">
                                            <!--- #get_stage.stage[listfind(expense_stage_list,expense_stage,',')]# --->
                                        </cfif>
                                    </td>
                                    <cfif listfirst(attributes.fuseaction,'.') eq 'hr' >
                                    <td>
                                        <cfif len(process_cat) and isdefined("GET_PROCESS_CAT")>
                                            <cfquery name="get_cat_" dbtype="query">
                                                SELECT PROCESS_CAT FROM GET_PROCESS_CAT WHERE PROCESS_CAT_ID = #process_cat#
                                            </cfquery>
                                            #get_cat_.PROCESS_CAT#
                                        </cfif>
                                    </td>
                                    </cfif>
                                    <td>#dateFormat(record_date,dateformat_style)#</td>
                                    <td>#dateFormat(update_date,dateformat_style)#</td>
                                    <!-- sil -->
                                    <td>
                                        <cfif EXPENSE_ITEM_PLANS_ID neq "">
                                            <a href="#request.self#?fuseaction=health.expenses&event=upd&expense_id=#EXPENSE_ITEM_PLANS_ID#&health_id=#health_id#"><i class="fa fa-link" style="color:green !important;" title="<cf_get_lang dictionary_id='41796.Sağlık Harcama Fişi Güncelle'>"></i></a>
                                        <cfelse>
                                            <a href="javascript://"><i class="fa fa-link" style="color:red !important;cursor:default;" title="<cf_get_lang dictionary_id='41797.Sağlık Harcama Fişi Yok'>"></i></a>
                                        </cfif>
                                    </td>
                                    <td><a href="#request.self#?fuseaction=#fusebox.circuit#.health_expense_approve&event=upd&health_id=#health_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                    <cfif listfirst(attributes.fuseaction,'.') eq 'hr' and ( len(attributes.sortType) or isDefined("attributes.gp_id")) and len(attributes.expense_stage)>
                                        <td>
                                            <input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#health_id#" total_value="#TREATMENT_AMOUNT#" amount_value="#AMOUNT#" comp_value="#OUR_COMPANY_HEALTH_AMOUNT#" emp_value="#EMPLOYEE_HEALTH_AMOUNT#" #(isDefined("attributes.gp_id") ? 'checked' : '')# />
                                        </td>
                                    </cfif>
                                    <!-- sil -->
                                </tr>
                        </cfoutput>
                    </tbody>
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="19"><cf_get_lang dictionary_id ="57484. kayıt yok"></td>
                        </tr>
                    </tbody>
                </cfif>
            </cf_grid_list>
            <cf_paging
                name="setProcessForm"
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#"
                is_form="1">
        </cf_box>
        <cfif listfirst(attributes.fuseaction,'.') eq 'hr' and ( len(attributes.sortType) or isDefined("attributes.gp_id")) and len(attributes.expense_stage)>
            <cfset get_det_form = HealthExpense.GET_DET_FORM()>
            <cfinclude template="checked_health_expenses.cfm">
        </cfif>
    </cfform>
</div>
    <script type="text/javascript">
        $("input[name=get_excel], div#item-bank_id, input[name=is_create_excel], div#item-excel_type").hide();
    
        <cfif listfirst(attributes.fuseaction,'.') eq 'hr' and isDefined('attributes.gp_id')>
            $( document ).ready(function() {
                total_amount_ = 0;
                comp_amount_ = 0;
                emp_amount_ = 0;
                net_kdv_amount_ = 0;
                $('.checkControl').each(function() {
                    if(this.checked){
                        net_kdv_amount_ += parseFloat($(this).attr("amount_value"));
                        total_amount_ += parseFloat($(this).attr("total_value"));
                        comp_amount_ += parseFloat($(this).attr("comp_value"));
                        emp_amount_ += parseFloat($(this).attr("emp_value"));
                    }
                });
                $('#amount_last_total').val(commaSplit(net_kdv_amount_,<cfoutput>#x_rnd_nmbr#</cfoutput>));
                $('#treatment_last_total').val(commaSplit(total_amount_,<cfoutput>#x_rnd_nmbr#</cfoutput>));
                $('#comp_last_total').val(commaSplit(comp_amount_,<cfoutput>#x_rnd_nmbr#</cfoutput>));
                $('#emp_last_total').val(commaSplit(emp_amount_,<cfoutput>#x_rnd_nmbr#</cfoutput>));
            });
        </cfif>
    
        function kontrol()
        {
            if(document.getElementById('search_date1').value != '' && document.getElementById('search_date2').value != ''){
                if(!date_check (document.getElementById('search_date1'),document.getElementById('search_date2'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!")){
                    document.getElementById('search_date1').focus();
                    return false;
                }
            }
            if(document.getElementById('payment_date1').value != '' && document.getElementById('payment_date2').value != ''){
                if(!date_check (document.getElementById('payment_date1'),document.getElementById('payment_date2'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!")){
                    document.getElementById('payment_date1').focus();
                    return false;
                }
            }
            return true;
        }
        <cfif listfirst(attributes.fuseaction,'.') eq 'hr' and ( len(attributes.sortType) or isDefined("attributes.gp_id") )>
            $(function(){
                $('input[name=checkAll]').click(function(){
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
                    total_amount = 0;
                    comp_amount = 0;
                    emp_amount = 0;
                    net_kdv_amount = 0;
                    $('.checkControl').each(function() {
                        if(this.checked){
                            net_kdv_amount += parseFloat($(this).attr("amount_value"));
                            total_amount += parseFloat($(this).attr("total_value"));
                            comp_amount += parseFloat($(this).attr("comp_value"));
                            emp_amount += parseFloat($(this).attr("emp_value"));
                        }
                    });
                    $('#amount_last_total').val(commaSplit(net_kdv_amount,<cfoutput>#x_rnd_nmbr#</cfoutput>));
                    $('#treatment_last_total').val(commaSplit(total_amount,<cfoutput>#x_rnd_nmbr#</cfoutput>));
                    $('#comp_last_total').val(commaSplit(comp_amount,<cfoutput>#x_rnd_nmbr#</cfoutput>));
                    $('#emp_last_total').val(commaSplit(emp_amount,<cfoutput>#x_rnd_nmbr#</cfoutput>));
                });
            });
    
            function setHealthExpenseProcess(){
                var controlChc = 0;
                $('.checkControl').each(function(){
                    if(this.checked){
                        controlChc += 1;
                    }
                });
                if(controlChc == 0){
                    alert("<cf_get_lang dictionary_id='59942.Hiçbir sağlık harcaması seçmediniz.'>");
                    return false;
                }
                if( $.trim($('#general_paper_no').val()) == '' ){
                    alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
                    return false;
                }
                if( $.trim($('#general_paper_date').val()) == '' ){
                    alert("Lütfen Belge Tarihi Giriniz!");
                    return false;
                }
                if( $.trim($('#general_paper_notice').val()) == '' ){
                    alert("Lütfen Ek Açıklama Giriniz!");
                    return false;
                }
    
                <cfif isDefined("attributes.wrkflow") and attributes.wrkflow eq 1>
                    $('#setProcessForm').attr('action', '<cfoutput>#request.self#?fuseaction=#adres#&box_submitted=1</cfoutput>');
                </cfif>
    
                document.getElementById("amount_last_total").value = filterNum(document.getElementById("amount_last_total").value,<cfoutput>#x_rnd_nmbr#</cfoutput>);
                document.getElementById("treatment_last_total").value = filterNum(document.getElementById("treatment_last_total").value,<cfoutput>#x_rnd_nmbr#</cfoutput>);
                document.getElementById("comp_last_total").value = filterNum(document.getElementById("comp_last_total").value,<cfoutput>#x_rnd_nmbr#</cfoutput>);
                document.getElementById("emp_last_total").value = filterNum(document.getElementById("emp_last_total").value,<cfoutput>#x_rnd_nmbr#</cfoutput>);
            
                $('#setProcessForm').submit();
                
            }
    
            function openPrintTab() {
                var id_list = [];
                control = 0;
                $('.checkControl').each(function(){
                    if(this.checked){
                        id_list.push($(this).val());
                        control += 1;
                    }
                });
                if(control == 0){
                    alert("<cf_get_lang dictionary_id='59942.Hiçbir sağlık harcaması seçmediniz.'>");
                    return false;
                }
                if($('#general_paper_no').val() == ''){
                    alert("<cf_get_lang dictionary_id='33367.Lütfen belge no giriniz.'>");
                    $('#general_paper_no').focus();
                    return false;
                }
                windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&iid='+id_list+'&print_type=490&form_type=185&date1='+$('#general_paper_date').val()+'&keyword='+$('#general_paper_no').val()+'&action_type='+$('#process_stage option:selected').html()+'&action_id='+$('#sortType').val()+'','page','workcube_print');
            }
            function excelToggle(){
                if(document.getElementById('is_print_excel').checked){
                    document.getElementById('is_print_excel').checked = false;
                    $("input[name=is_create_excel], div#item-excel_type").toggle();
                }
                $("input[name=get_excel], div#item-bank_id").toggle();
            }
            function buttonToggle(){
                if(document.getElementById('is_payment_order').checked){
                    document.getElementById('is_payment_order').checked = false;
                    $("input[name=get_excel], div#item-bank_id").toggle();
                }
                $("input[name=is_create_excel], div#item-excel_type").toggle();
            }
    
            function getExcel(){
                control = 0;
                $('.checkControl').each(function(){
                    if(this.checked){
                        control += 1;
                    }
                });
                if(control == 0){
                    alert("<cf_get_lang dictionary_id='59942.Hiçbir sağlık harcaması seçmediniz.'>");
                    return false;
                }else{
                    if(!document.getElementById('is_print_excel').checked){
                        var bank_id = $("select[name=bank_id]").val();
                        if(bank_id != ''){
                            $('#setProcessForm').attr("action","<cfoutput>#request.self#</cfoutput>?fuseaction=hr.health_expense_approve<cfif isdefined("attributes.maxrows")>&maxrows=<cfoutput>#attributes.maxrows#</cfoutput></cfif>&is_excel=1&bank_id="+bank_id);
                            $('#setProcessForm').submit();
                        }
                        else{
                            alert("Banka Seçiniz");
                        }
                    }
                    else{
                        var excel_type_id = $("select[name=excel_type_id]").val();
                        if(excel_type_id != ''){
                            $('#setProcessForm').attr("action","<cfoutput>#request.self#</cfoutput>?fuseaction=hr.health_expense_approve<cfif isdefined("attributes.maxrows")>&maxrows=<cfoutput>#attributes.maxrows#</cfoutput></cfif>&create_excel=1&sort_type=<cfoutput>#attributes.sortType#</cfoutput>&excel_type_id="+excel_type_id);
                            $('#setProcessForm').submit();
                        }
                        else{
                            alert("<cf_get_lang dictionary_id='43942.Aktarım Formatı Seçiniz'>");
                        }
                    }
                }
            }
        </cfif>
    </script>
    <cfsetting showdebugoutput="no">