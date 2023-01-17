<cfparam name="attributes.sal_mon" default="#month(now())-1#">
<cfparam name="attributes.sal_year" default="#session.ep.PERIOD_YEAR#">
<cfparam name="attributes.general_budget_id" default="">
<cfparam name="attributes.ssk_statue" default="2">
<cfparam name="attributes.statue_type" default="2">
<cfparam name="attributes.is_submit" default="0">
<cfparam name="attributes.branch_id" default="">

<cfset startdate = "01/#attributes.sal_mon#/#attributes.sal_year#">
<cfset finishdate = "#DaysInMonth(CreateDateTime(attributes.sal_year, attributes.sal_mon,1,0,0,0))#/#attributes.sal_mon#/#attributes.sal_year#">

<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_component = createObject("component","V16.hr.cfc.project_allowance") />
<cfset get_project = get_component.get_project(project_id: attributes.project_id)>
<cfset get_branch = createObject("component","V16.hr.cfc.get_branches")>

<cfset get_budget = get_component.get_budget_center(general_budget_id: attributes.general_budget_id)>
<cfset get_income = get_component.get_income_expense(
    project_id: attributes.project_id,
    is_income: 1, 
    start_date: get_project.TARGET_START, 
    finish_date: get_project.TARGET_FINISH, 
    process_cat_id: '561,56,53,531,58',<!--- 561: Verilen Hakedisler , 56: Verilen Hizmetler,53: Toptan Satis F, 531: ihracat F, 58: Alinan Fiyat Farki F --->
    is_income_type:'121'
)>
<cfset get_expense = get_component.get_income_expense(
    project_id: attributes.project_id, 
    is_income : 0, 
    start_date: get_project.TARGET_START, 
    finish_date: get_project.TARGET_FINISH,
    process_cat_id: '601,60,59,591,691,68,65'<!--- 601: Alınan Hakedisler , 60: alınan Hizmetler,59,591,691,68,65 : Alımlar --->
    )>
<cfset get_salaryparam = get_component.get_salaryparam(
    project_id: attributes.project_id,
    start_date: get_project.TARGET_START, 
    finish_date: get_project.TARGET_FINISH
    )>    
<cfset get_project_actions = get_component.get_project_actions(project_id: attributes.project_id)>

<cfinclude template="../query/get_moneys.cfm">
<cfif attributes.is_submit eq 1>
    <!--- type : 0 -> çalışan, 1 -> yönetici --->
    <cfset get_project_team = get_component.get_project_detail(
        project_id: attributes.project_id, 
        ssk_statue : attributes.ssk_statue,
        statue_type : attributes.statue_type,
        sal_mon : attributes.sal_mon,
        sal_year : attributes.sal_year,
        general_budget_id : len(attributes.general_budget_id) ? attributes.general_budget_id : '',
        from_draggable : 0,
        type : 0
        )> 
    <cfset get_project_director = get_component.get_project_detail(
        project_id: attributes.project_id, 
        ssk_statue : attributes.ssk_statue,
        statue_type : attributes.statue_type,
        sal_mon : attributes.sal_mon,
        sal_year : attributes.sal_year,
        general_budget_id : len(attributes.general_budget_id) ? attributes.general_budget_id : '',
        from_draggable : 0,
        type : 1
        )> 
    <cfset get_main_project_allowance = get_component.get_main_project_allowance(
        project_id: attributes.project_id, 
        ssk_statue : attributes.ssk_statue,
        statue_type : attributes.statue_type,
        sal_mon : attributes.sal_mon,
        sal_year : attributes.sal_year,
        general_budget_id : len(attributes.general_budget_id) ? attributes.general_budget_id : ''
        )> 
</cfif>
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>

<cfsavecontent variable = "title">
    <cf_get_lang dictionary_id='57416.Proje'> : <cfoutput>#get_project.PROJECT_HEAD#</cfoutput>
</cfsavecontent>

<!--- Özet --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#title#">
        <cfoutput query="get_project">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-xs-3"><b><cf_get_lang dictionary_id='63128.İş Birimi'>:</b></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfset get_branch = get_branch.get_branch(branch_id : branch_id)>
                                #get_branch.BRANCH_NAME# - #get_budget.DEPARTMENT_HEAD#
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-3"><b><cf_get_lang dictionary_id='59936.Bütçe Merkezi'>:</b></label>
                        <div class="col col-8 col-xs-12">
                            #get_budget.BUDGET_NAME#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-3"><b><cf_get_lang dictionary_id='34996.Proje Lideri'>:</b></label>
                        <div class="col col-8 col-xs-12">
                            <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_project.PROJECT_EMP_ID#')">#get_emp_info(get_project.PROJECT_EMP_ID,0,0)# </a>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-3"><b><cf_get_lang dictionary_id='57742.Tarih'>:</b></label>
                        <div class="col col-8 col-xs-12">
                            #Dateformat(target_start,dateformat_style)# - #Dateformat(target_finish,dateformat_style)#
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="col col-8 col-xs-3"><b><cf_get_lang dictionary_id='58677.Gelir'> - <cf_get_lang dictionary_id='63137.Satılan Mal ve Hizmetler'>:</b></label>
                        <div class="col col-4 col-xs-12 moneybox">
                                #TLFORMAT(get_income.PRICE)# #session.ep.money#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-8 col-xs-3"><b><cf_get_lang dictionary_id='58678.Gider'> - <cf_get_lang dictionary_id='63138.Alınan Mal ve Hizmetler'>:</b></label>
                        <div class="col col-4 col-xs-12 moneybox">
                            #TLFORMAT(get_expense.PRICE)# #session.ep.money#
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-8 col-xs-3"><b><cf_get_lang dictionary_id='58678.Gider'> - <cf_get_lang dictionary_id='63139.İş Gücü Ödenekleri'>:</b></label>
                        <div class="col col-4 col-xs-12 moneybox">
                            <cfif get_salaryparam.recordcount>
                                #TLFORMAT(get_salaryparam.TOTAL_PAY)# #get_salaryparam.MONEY#
                                <cfset TOTAL_PAY = get_salaryparam.TOTAL_PAY> 
                            <cfelse>
                                #TLFORMAT(0)# #session.ep.money#
                                <cfset TOTAL_PAY = 0> 
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-8 col-xs-3"><b><cf_get_lang dictionary_id='63140.Proje Kazancı'>:</b></label>
                        <div class="col col-4 col-xs-12 moneybox">
                            #TLFORMAT(get_income.PRICE - get_expense.PRICE - TOTAL_PAY)#
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-xs-3"><b><cf_get_lang dictionary_id='63141.Proje Tahsilatı'>:</b></label>
                        <div class="col col-8 col-xs-12 moneybox">
                            <cfif len(get_project_actions.value)>
                                #TLFORMAT(get_project_actions.value)# #get_project_actions.CURRENCY#
                                <cfset action_value = get_project_actions.value>
                            <cfelse>
                                #TLFORMAT(0)# #session.ep.money#
                                <cfset action_value = 0>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-3"><b><cf_get_lang dictionary_id='63142.Proje Ödemeleri'>:</b></label>
                        <div class="col col-8 col-xs-12 moneybox">
                            <cfif get_salaryparam.recordcount>
                                #TLFORMAT(get_salaryparam.TOTAL_PAY)# #get_salaryparam.MONEY#
                                <cfset TOTAL_PAY = get_salaryparam.TOTAL_PAY> 
                            <cfelse>
                                #TLFORMAT(0)# #session.ep.money#
                                <cfset TOTAL_PAY = 0> 
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-3"><b><cf_get_lang dictionary_id='63143.Nakit Pozisyonu'>:</b></label>
                        <div class="col col-8 col-xs-12 moneybox">
                            #TLFORMAT(action_value - TOTAL_PAY)#
                        </div>
                    </div>
                </div>
            </cf_box_elements>
        </cfoutput>
    </cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" method="post" action="#request.self#?fuseaction=process.list_process">
            <input name="is_submitted" id="is_submitted" type="hidden" value="1">
            <input name="branch_id" id="branch_id" type="hidden" value="<cfoutput>#attributes.branch_id#</cfoutput>">
            <cf_box_search>
                <div class="form-group">
                    <select name="sal_year" id="sal_year">
                        <option value="0"><cf_get_lang dictionary_id='58455.Yıl'></option>
                        <cfloop from="#period_years.period_year[1]-period_years.recordcount#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="sal_mon" id="sal_mon">
                        <option value="0"><cf_get_lang dictionary_id='58724.Ay'></option>
                        <cfloop from="1" to="12" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif (attributes.sal_mon eq i)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                            </cfoutput>
                        </cfloop>
                    </select>	
                </div>
                <div class="form-group" id="item-ssk_statue">
                    <select  name="ssk_statue" id="ssk_statue" onchange="change_ssk_statue(this.value)">
                        <option value="0"><cf_get_lang dictionary_id='53606.SSK Durumu'></option>
                        <option value="1" <cfif attributes.ssk_statue eq 1>selected</cfif>><cf_get_lang dictionary_id='45049.Worker'></option>
                        <option value="2" <cfif attributes.ssk_statue eq 2>selected</cfif>><cf_get_lang dictionary_id='62870.Memur'></option>
                        <option value="3" <cfif attributes.ssk_statue eq 3>selected</cfif>><cf_get_lang dictionary_id='62871.Serbest Çalışan'></option>
                        <option value="4" <cfif attributes.ssk_statue eq 4>selected</cfif>><cf_get_lang dictionary_id='63103.Sanatçı'></option>
                        <option value="5" <cfif attributes.ssk_statue eq 5>selected</cfif>><cf_get_lang dictionary_id='30439.Dış Kaynak'></option>
                    </select>
                </div>
                <div class="form-group" id="statue_type_div" <cfif  attributes.ssk_statue neq 2>style="display:none"</cfif>>
                    <select name="statue_type" id="statue_type">
                        <option value="0"><cf_get_lang dictionary_id='63047.Bordro Tipi'></option>
                        <option value="1" <cfif attributes.statue_type eq 1>selected</cfif>><cf_get_lang dictionary_id='40071.Maaş'></option>
                        <option value="2" <cfif attributes.statue_type eq 2>selected</cfif>><cf_get_lang dictionary_id='62888.Döner Sermaye'></option>
                        <option value="3" <cfif attributes.statue_type eq 3>selected</cfif>><cf_get_lang dictionary_id='62956.Ek Ders'></option>
                        <option value="4" <cfif attributes.statue_type eq 4>selected</cfif>><cf_get_lang dictionary_id='58015.Projeler'></option>
                        <option value="6" <cfif attributes.statue_type eq 6>selected</cfif>><cf_get_lang dictionary_id='64673.Jüri Üyeliği'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="list_allowance(#attributes.project_id#,#attributes.general_budget_id#)">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
</div>

<cfif attributes.is_submit eq 1>
    <div id="employees_allowance">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cfsavecontent variable="title_2">
                <cf_get_lang dictionary_id='63144.Ödenek Hakediş Hesabı'>
            </cfsavecontent>
            <cf_box title="#title_2#">
                <cfform name="project_allowance" id="project_allowance" action="V16/hr/cfc/project_allowance.cfc?method=add_project_allowance" method="post">
                    <cfif get_main_project_allowance.recordcount>
                        <input type="hidden" name="project_allowance_id" value="<cfoutput>#get_main_project_allowance.PROJECT_ALLOWANCE_ID#</cfoutput>" >
                    </cfif>
                    <input type="hidden" name="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>" >
                    <input type="hidden" name="general_budget_id" value="<cfoutput>#attributes.general_budget_id#</cfoutput>" >
                    <input type="hidden" name="ssk_statue" value="<cfoutput>#attributes.ssk_statue#</cfoutput>" >
                    <input type="hidden" name="statue_type" value="<cfoutput>#attributes.statue_type#</cfoutput>" >
                    <input type="hidden" name="director_row_count" id="director_row_count" value="<cfoutput>#get_project_director.recordcount#</cfoutput>" >
                    <input type="hidden" name="employee_row_count" id="employee_row_count" value="<cfoutput>#get_project_team.recordcount#</cfoutput>" >
                    <input type="hidden" name="row_count" id="row_count" value="0" >
                    <input type="hidden" name="statue_type" value="<cfoutput>#attributes.statue_type#</cfoutput>" >
                    <input type="hidden" name="branch_id" value="<cfoutput><cfif len(get_main_project_allowance.branch_id)>#get_main_project_allowance.branch_id#<cfelse>#attributes.branch_id#</cfif></cfoutput>" >
                    <cfoutput>
                        <cf_box_elements>
                            <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                                <cfset get_process_f = cmp_process.GET_PROCESS_TYPES(faction_list : 'hr.project_allowance')>
                                <cf_workcube_general_process select_value = '#get_main_project_allowance.process_id#' print_type="319" is_termin_date="0" is_detail="0">
                            </div>
                            <div class="col col-4 col-xs-12" type="column" index="2" sort="true">
                                <div class="form-group">
                                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58455.Yıl'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="sal_year" id="sal_year" readonly>
                                            <cfloop from="#period_years.period_year[1]-period_years.recordcount#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
                                                <option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58724.Ay'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="sal_mon" id="sal_mon"readonly>
                                            <cfloop from="1" to="12" index="i">
                                                <option value="#i#" <cfif (attributes.sal_mon eq i)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                            </cfloop>
                                        </select>	
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col col-4 col-xs-12">
                                        <label><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                                    </div>
                                    <div class="col col-8 col-xs-12">
                                        <select name="money" id="money">
                                            <cfloop query="get_moneys">
                                                <option value="#get_moneys.MONEY#" <cfif get_main_project_allowance.CURRENCY_UNIT eq get_moneys.MONEY>selected</cfif>>#get_moneys.MONEY#</option>
                                            </cfloop>
                                        </select>
                                    </div>	
                                </div>
                            </div>
                            <div class="col col-4 col-xs-12" type="column" index="3" sort="true">
                                <div class="form-group">
                                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='63145.Yönetim Payı'>%</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="director_share" id="director_share" value="<cfif len(get_main_project_allowance.DIRECTOR_SHARE)>#tlformat(get_main_project_allowance.DIRECTOR_SHARE)#<cfelse>#tlformat(0)#</cfif>" class="unformat_input moneybox" onkeyup="return(FormatCurrency(this,event,8));" onchange="director_share_calc(1)">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='61106.Dağıtım'>%</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="distribution" id="distribution" value="<cfif len(get_main_project_allowance.distribution)>#tlformat(get_main_project_allowance.distribution)#<cfelse>#tlformat(0)#</cfif>" class="unformat_input moneybox" onkeyup="return(FormatCurrency(this,event,8));" onchange="director_share_calc(2)">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='63146.Yönetim Tutarı'>%</label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="director_amount" id="director_amount" value="<cfif len(get_main_project_allowance.director_amount)>#tlformat(get_main_project_allowance.director_amount)#<cfelse>#tlformat(0)#</cfif>" class="unformat_input moneybox"  onkeyup="return(FormatCurrency(this,event,8));">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='63147.Çalışan Tutarı'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="employee_amount" id="employee_amount" value="<cfif len(get_main_project_allowance.employee_amount)>#tlformat(get_main_project_allowance.employee_amount)#<cfelse>#tlformat(0)#</cfif>" class="unformat_input moneybox" onkeyup="return(FormatCurrency(this,event,8));">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57492.Toplam'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="text" name="total" id="total" value="<cfif len(get_main_project_allowance.TOTAL_AMOUNT)>#tlformat(get_main_project_allowance.TOTAL_AMOUNT)#<cfelse>#tlformat(0)#</cfif>" class="unformat_input moneybox"  onkeyup="return(FormatCurrency(this,event,8));">
                                    </div>
                                </div>
                            </div>
                            <!--- <div class="form-group">
                                <cf_wrk_search_button button_type="4" search_function="list_allowance(#attributes.project_id#)">
                            </div> --->
                        </cf_box_elements>
                    </cfoutput>

                    <cf_grid_list id="employee_info">
                        <cfset total_emp = 0>
                        <thead>
                            <tr>
                                <th colspan="9"><cf_get_lang dictionary_id='58875.Çalışanlar'></th> 
                            </tr>
                        </thead>
                        <thead>
                            <tr>
                                <th width="20"><a href="javascript://" onClick="add_employee(<cfoutput>#attributes.project_id#,#attributes.sal_mon#,#attributes.sal_year#,#attributes.ssk_statue#,#attributes.statue_type#,'addRow'</cfoutput>)"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                <th width="70"><cf_get_lang dictionary_id='58487.Çalışan No'></th>
                                <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                                <th><cf_get_lang dictionary_id='55478.Rol'></th>
                                <th><cf_get_lang dictionary_id='53610.Ödenek'></th>
                                <th width="70"><cf_get_lang dictionary_id='57491.Saat'> / <cf_get_lang dictionary_id='55123.Ücret'></th>
                                <th>
                                    <i class="fa fa-calendar" id="search_date1_image" alt="Tarih">
                                        <i class="icon-date-number"></i> 
                                    </i>
                                </th>
                                <th width="70"><cf_get_lang dictionary_id='41730.adam'> / <cf_get_lang dictionary_id='57491.Saat'></th>
                                <th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>     
                            </tr>
                        </thead>
                        <tbody id="employee_info">
                            <cfif get_project_team.recordcount>
                                <cfoutput query="get_project_team">
                                    <tr id='#currentrow#'>
                                        <td>
                                            <a style='cursor:pointer;' onclick='sil_fixed(#currentrow#);'><i class='fa fa-minus'></i></a>
                                            <input type="hidden" name="project_allowance_row_id_fixed#currentrow#" id="" value="#PROJECT_ALLOWANCE_ROW_ID#">
                                            <input type='hidden' name='fixed#currentrow#' id='fixed#currentrow#' value='1'>
                                            <input type='hidden' name='type_fixed#currentrow#' id='type_fixed#currentrow#' value='0'>
                                            <input type='hidden' name='comment_pay_id_fixed#currentrow#' id='comment_pay_id_fixed#currentrow#' value='#comment_pay_id#'>
                                            <input type='hidden' name='in_out_id_fixed#currentrow#' id='in_out_id_fixed#currentrow#' value='#in_out_id#'>
                                            <input type='hidden' name='employee_id_fixed#currentrow#' id='employee_id_fixed#currentrow#' value='#employee_id#'>
                                        </td>
                                        <td>#EMPLOYEE_NO#</td>
                                        <td>#get_emp_info(employee_id,0,0)#</td>
                                        <td>#ROLE_HEAD#</td>
                                        <td>#COMMENT_PAY#</td>
                                        <td style="text-align:right;"><input type="text"  class="unformat_input moneybox"  name="per_hour_salary_fixed#currentrow#" id="per_hour_salary_fixed#currentrow#" onkeyup="return(FormatCurrency(this,event,8));" value="#tlformat(HOUR_PAYMENT)#" onchange="row_calculate(#currentrow#,'fixed')"></td>
                                        <td  align="center">
                                            <cfset startdate = "01/#attributes.sal_mon#/#attributes.sal_year#">
                                            <cfset finishdate = "#DaysInMonth(CreateDateTime(attributes.sal_year, attributes.sal_mon,1,0,0,0))#/#attributes.sal_mon#/#attributes.sal_year#">
                                            <a href="#request.self#?fuseaction=report.time_cost_report&employee_id=#employee_id#&employee=#get_emp_info(employee_id,0,0)#&is_submit=1&start_date=#startdate#&finish_date=#finishdate#" target="_blank">
                                                <i class="fa fa-calendar" id="search_date1_image" alt="Tarih">
                                                    <i class="icon-date-number"></i> 
                                                </i>
                                            </a>
                                        </td>
                                        <td style="text-align:right;">
                                            <input type="text"  class="unformat_input moneybox"  name="total_time_fixed#currentrow#" id="total_time_fixed#currentrow#" onkeyup="return(FormatCurrency(this,event,8));" value="#tlformat(HOURLY_WORK)#" total-share = "employee"  onchange='calc_director("employee");row_calculate(#currentrow#,"fixed")'>
                                        </td>
                                        <td style="text-align:right;">
                                            <input type="text"  class="unformat_input moneybox"  name="total_value_fixed#currentrow#" id="total_value_fixed#currentrow#" onkeyup="return(FormatCurrency(this,event,8));" value="#tlformat(AMOUNT)#" total-value = 'employee' onchange='calc_director_value("employee")'>
                                        </td>
                                    </tr>
                                    <cfset total_emp = currentrow>
                                </cfoutput>
                            </cfif>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="7" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <td><input type="text" name="total_emp_hour_fixed" id="total_emp_hour_fixed" value="" class="unformat_input moneybox" readonly></td>
                                <td><input type="text" name="total_emp_time_fixed" id="total_emp_time_fixed" value="" class="unformat_input moneybox" readonly></td>
                            </tr>
                        </tfoot>
                    </cf_grid_list>

                    <cfset total_emp += 1>
                    <cf_grid_list id="director_info">
                        <thead>
                            <tr>
                                <th colspan="9"><cf_get_lang dictionary_id='35313.Yöneticiler'></th> 
                            </tr>
                        </thead>
                        <thead>
                            <tr>
                                <th width="20">
                                    <a href="javascript://" onClick="add_employee(<cfoutput>#attributes.project_id#,#attributes.sal_mon#,#attributes.sal_year#,#attributes.ssk_statue#,#attributes.statue_type#,'addRowDirector'</cfoutput>)"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                                </th>
                                <th width="70"><cf_get_lang dictionary_id='58487.Çalışan No'></th>
                                <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                                <th><cf_get_lang dictionary_id='55478.Rol'></th>
                                <th><cf_get_lang dictionary_id='53610.Ödenek'></th>
                                <th width="70"><cf_get_lang dictionary_id='57668.Pay'>%</th>
                                
                                <th width="70"><cf_get_lang dictionary_id='57673.Tutar'></th>     
                            </tr>
                        </thead>
                        <tbody id="director_info">
                            <cfif get_project_director.recordcount>
                                <cfoutput query="get_project_director">
                                    <tr  id='#total_emp#'>
                                        <td>
                                            <!--- <input type="checkbox" name="is_allowance#currentrow#" id="is_allowance#currentrow#" value="1"> --->
                                            <a style='cursor:pointer;' onclick='delete_director_fixed(#total_emp#);'><i class='fa fa-minus'></i></a>
                                            <input name='empRow_fixed' value='#total_emp#' type='hidden'>
                                            <input type='hidden' name='fixed#total_emp#' id='fixed#total_emp#' value='1'>
                                            <input type="hidden" name="project_allowance_row_id_fixed#total_emp#" id="" value="#PROJECT_ALLOWANCE_ROW_ID#">
                                            <input type='hidden' name='type_fixed#total_emp#' id='type_fixed#total_emp#' value='1'>
                                            <input type='hidden' name='comment_pay_id_fixed#total_emp#' id='comment_pay_id_fixed#total_emp#' value='#comment_pay_id#'>
                                            <input type='hidden' name='in_out_id_fixed#total_emp#' id='in_out_id_fixed#total_emp#' value='#in_out_id#'>
                                            <input type='hidden' name='employee_id_fixed#total_emp#' id='employee_id_fixed#total_emp#' value='#employee_id#'>
                                        </td>
                                        <td>#EMPLOYEE_NO#</td>
                                        <td>#get_emp_info(employee_id,0,0)#</td>
                                        <td>#ROLE_HEAD#</td>
                                        <td>#COMMENT_PAY#</td>
                                        <td style="text-align:right;">
                                            <input type="text"  class="unformat_input moneybox"  name="share_fixed#total_emp#" id="share_fixed#total_emp#" onkeyup="return(FormatCurrency(this,event,8));" value="#tlformat(SHARE)#">
                                        </td>
                                        <td style="text-align:right;">
                                            <input type="text"  class="unformat_input moneybox"  name="total_value_fixed#total_emp#" id="total_value_fixed#total_emp#" onkeyup="return(FormatCurrency(this,event,8));" value="#tlformat(AMOUNT)#"  total-value = 'director' onchange='calc_director_value("director")'>
                                        </td>
                                    </tr>
                                    <cfset total_emp += 1>
                                </cfoutput>
                            </cfif>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="6" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                <td><input type="text" name="total_director_time" id="total_director_time" value=""  class="unformat_input moneybox" readonly></td>
                            </tr>
                        </tfoot>
                    </cf_grid_list>
                    <cf_box_footer>
                        <cfif get_project_director.recordcount eq 0 and get_project_team.recordcount eq 0>
                            <cf_workcube_buttons is_upd='0' add_function="control()" data_action = "/V16/hr/cfc/project_allowance:add_project_detail_info" next_page="#request.self#?fuseaction=hr.project_allowance">
                        <cfelse>
                            <cfsavecontent  variable="ext_button">
                                <cf_get_lang dictionary_id='63193.Ödenek Oluştur'>
                            </cfsavecontent>
                            <cf_workcube_buttons extraButton = "1" update_status="0" extraFunction="add_allowance()" extraButtonText="#ext_button#" extraButtonClass="ui-wrk-btn ui-wrk-btn-red">
                            <cf_workcube_buttons 
                                is_upd='1' 
                                add_function="control()" 
                                data_action = "/V16/hr/cfc/project_allowance:upd_project_detail_info" 
                                next_page="#request.self#?fuseaction=hr.project_allowance"
                                del_action= '/V16/hr/cfc/project_allowance:del_project:project_allowance_id=#get_main_project_allowance.project_allowance_id#'
                                del_next_page = '#request.self#?fuseaction=hr.project_allowance'
                                >
                        </cfif>
                    </cf_box_footer>
                </cfform>
            </cf_box>
        </div>
    </div>
</cfif>
<div id="message">
</div>
<script type = "text/javascript">
    <cfif isdefined("attributes.call_function") and len(attributes.call_function)>
        calc_director("employee");
        calc_director_value("employee");
        calc_director_value("director");
    </cfif>
    var row_count_service = 0;
    function control()
    {
        fixed_row = $("#director_row_count").val()+$("#employee_row_count").val();
        if($("#process_stage").val() == '')
        {
            alert("<cf_get_lang dictionary_id='58842.Lütfen Süreç Seçiniz'>");
            return false;
        }
        if($("#general_paper_no").val() == '')
        {
            alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
            return false;
        }
        if($("#general_paper_date").val() == '')
        {
            alert("<cf_get_lang dictionary_id='62954.Lütfen Belge Tarihi Giriniz'>");
            return false;
        }
        if($("#director_share").val() == '')
        {
            alert("<cf_get_lang dictionary_id='63145.Yönetim Payı'>!");
            return false;
        }
        if($("#distribution").val() == '')
        {
            alert("<cf_get_lang dictionary_id='61106.Dağıtım'>!");
            return false;
        }
        if($("#director_amount").val() == '')
        {
            alert("<cf_get_lang dictionary_id='63146.Yönetim Tutarı'>!");
            return false;
        }
        if($("#employee_amount").val() == '')
        {
            alert("<cf_get_lang dictionary_id='63147.Çalışan Tutarı'>!");
            return false;
        }
        if(row_count_service == 0 && fixed_row == 0)
        {
            alert("<cf_get_lang dictionary_id='34016.Lütfen Kayıt Giriniz'>!");
            return false;
        }

        UnformatFields();
    }
    function director_share_calc(type_)
    {
        if(type_ == 1)
        {
            $("#distribution").val(commaSplit(100-filterNum($("#director_share").val())));
        } else
        {
            $("#director_share").val(commaSplit(100-filterNum($("#distribution").val())));
        } 
    }

    function list_allowance(project_id,general_budget_id)
    {
        sal_mon = $("#sal_mon").val();
        sal_year =  $("#sal_year").val();
        ssk_statue = $("#ssk_statue").val();
        statue_type = $("#statue_type").val();
        branch_id = $("#branch_id").val();
        if(ssk_statue == 0)
        {
            alert("<cf_get_lang dictionary_id='53606.SGK Durumu'>!");
            return false;
        }else if(ssk_statue == 2 && statue_type == 0)
        {
            alert("<cf_get_lang dictionary_id='63047.Bordro Tipi'>!");
            return false;
        }
        var send_address_ = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=ProjectDetailInfo&ajax=1&is_submit=1&ajax_box_page=1&isAjax=1&project_id="+project_id+"&sal_mon="+sal_mon+"&sal_year="+sal_year+"&ssk_statue="+ssk_statue+"&statue_type="+statue_type+"&call_function="+1+"&branch_id=" + branch_id+"&general_budget_id="+general_budget_id;
        AjaxPageLoad(send_address_,'ajax_right',1,'Projeler'); 
    }

    function add_allowance()
    {
        UnformatFields();
        //AjaxFormSubmit('project_allowance','message','0');
        //location.reload()
        return true;
    }

    function change_ssk_statue()
    {
        ssk_statue_val = $("#ssk_statue").val();
        if(ssk_statue_val == 2)
        {
            $('#statue_type_div').css('display','');
            $('#button_').css('display','none');
        }
        else
        {
            $('#statue_type_div').css('display','none');
            $('#button_').css('display','');
        }

    }

    function add_employee(project_id,sal_mon,sal_year,ssk_statue,statue_type,function_)
    {	
        openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.project_allowance_employee&project_id='+project_id+'&sal_mon='+sal_mon+'&sal_year='+sal_year+'&ssk_statue='+ssk_statue+'&statue_type='+statue_type+'&function_='+function_);
    }

    function sil(no)
	{
        $("#employee_info tr#"+no).hide();
        $("#satir"+no).val("0");
	}
    function delete_director(no)
	{
        $("#director_info tr#"+no).hide();
        $("#satir"+no).val("0");
	}
    function sil_fixed(no)
	{
        $("#employee_info tr#"+no).hide();
        $("#fixed"+no).val("0");
	}
    function delete_director_fixed(no)
	{
        $("#director_info tr#"+no).hide();
        $("#fixed"+no).val("0");
	}

    
    function addRow(employee_no,in_out_id,employee_id,emp_name,comment_pay,comment_pay_id,role,per_hour_salary,total_time,total_value,modal_id)
    {
        row_count_service +=1;
        var jsonArray = [
            {
            "sil" : "<a style='cursor:pointer;' onclick='sil(###id###,\"satir\");'><i class='fa fa-minus'></i></a><input name='empRow' value='"+row_count_service+"' type='hidden'>",
            "employee_no" : employee_no,
            "employee" : emp_name+"<input type='hidden' name='employee_id###id###' id='employee_id###id###' value='"+employee_id+"'><input type='hidden' name='in_out_id###id###' id='in_out_id###id###' value='"+in_out_id+"'><input type='hidden' name='type###id###' id='type###id###' value='0'>",
            "role" : role,
            "comment_pay" : comment_pay+"<input type='hidden' name='comment_pay_id###id###' id='comment_pay_id###id###' value='"+comment_pay_id+"'>",
            "per_hour_salary" : "<input type='text' name='per_hour_salary###id###' id='per_hour_salary###id###'  class='unformat_input moneybox'  value='"+commaSplit(per_hour_salary)+"' onchange='row_calculate("+row_count_service+",\"new_row\")'>",
            "report" : "<a href='index.cfm?fuseaction=report.time_cost_report&employee_id="+employee_id+"&employee="+emp_name+"&is_submit=1&start_date=<cfoutput>#startdate#&finish_date=#finishdate#</cfoutput>' target='_blank'><i class='fa fa-calendar' id='search_date1_image' alt='Tarih'><i class='icon-date-number'></i></i></a>",
            "total_time" : "<input type='text' name='total_time###id###' id='total_time###id###'  class='unformat_input moneybox'  value='"+commaSplit(total_time)+"' total-share = 'employee'  onchange='calc_director(\"employee\");row_calculate("+row_count_service+",\"new_row\")'>",
            "total_value" : "<input type='text' name='total_value###id###' id='total_value###id###'  class='unformat_input moneybox'  value='"+commaSplit(total_value)+"' total-value = 'employee' onchange='calc_director_value(\"employee\")'>"
            }
        ];
        
        jsonArray.filter((a) => {
            var template="<tr id='"+row_count_service+"'><input type='hidden' name='satir###id###' id='satir###id###' value='1'><td width='20' class='text-center'>{sil}</td><td>{employee_no}</td><td>{employee}</td><td>{role}</td><td>{comment_pay}</td><td>{per_hour_salary}</td><td align='center'>{report}</td><td>{total_time}</td><td>{total_value}</td></tr>";
            $('#employee_info').append(nano( template, a ).replace(/###id###/g,row_count_service));
        });
        calc_director("employee");
        calc_director_value("employee");
        closeBoxDraggable(modal_id);
    }

    function addRowDirector(employee_no,in_out_id,employee_id,emp_name,comment_pay,comment_pay_id,role,per_hour_salary,total_time,total_value,modal_id){
        row_count_service +=1;
        var jsonArrayDirector = [
            {
            "sil" : "<a style='cursor:pointer;' onclick='delete_director(###id###,\"satir\");'><i class='fa fa-minus'></i></a><input name='directorRow' value='"+row_count_service+"' type='hidden'>",
            "employee_no" : employee_no,
            "employee" : emp_name+"<input type='hidden' name='employee_id###id###' id='employee_id###id###' value='"+employee_id+"'><input type='hidden' name='in_out_id###id###' id='in_out_id###id###' value='"+in_out_id+"'><input type='hidden' name='type###id###' id='type###id###' value='1'>",
            "role" : role,
            "comment_pay" : comment_pay+"<input type='hidden' name='comment_pay_id###id###' id='comment_pay_id###id###' value='"+comment_pay_id+"'>",
            "share" : "<input type='text' name='share###id###' id='share###id###'  class='unformat_input moneybox'  value='0,00'>",
            "total_value" : "<input type='text' name='total_value###id###' id='total_value###id###'  class='unformat_input moneybox'  value='0,00' total-value = 'director' onchange='calc_director_value(\"director\")'>"
            }
        ];
        
        jsonArrayDirector.filter((a) => {
            var template="<tr id='"+row_count_service+"'><input type='hidden' name='satir###id###' id='satir###id###' value='1'><td width='20' class='text-center'>{sil}</td><td>{employee_no}</td><td>{employee}</td><td>{role}</td><td>{comment_pay}</td><td>{share}</td><td>{total_value}</td></tr>";
            $('#director_info').append(nano( template, a ).replace(/###id###/g,row_count_service));
        });
        
        calc_director_value("director");
        closeBoxDraggable(modal_id);
    }

    function calc_director(type)
    {
        share_total = 0;
        $("input[total-share = "+type+"]:text").each(function(){
            share_total = share_total + parseFloat(filterNum($(this).val()));
        });
        $("#total_emp_hour_fixed").val(commaSplit(share_total)); 
        
    }

    function calc_director_value(type)
    {
        share_total = 0;
        $("input[total-value = "+type+"]:text").each(function(){
            share_total = share_total + parseFloat(filterNum($(this).val()));
        });
        if(type == 'director')
        {
            $("#total_director_time").val(commaSplit(share_total));
            $("#director_amount").val(commaSplit(share_total));
        }
        else
        {
            $("#total_emp_time_fixed").val(commaSplit(share_total)); 
            $("#employee_amount").val(commaSplit(share_total)); 
        }
        $("#total").val(commaSplit(parseFloat(filterNum($("#employee_amount").val())) + parseFloat(filterNum($("#director_amount").val()))));
    }

    

    function UnformatFields()
    {
        $(".unformat_input").each(function(){
            $(this).val(filterNum($(this).val()))
        });

        $("#row_count").val(row_count_service);
    }

    function row_calculate(no,type)
    {
        if(type == 'fixed')
        {
            $("#total_value_fixed"+no).val(commaSplit(parseFloat(filterNum($("#per_hour_salary_fixed"+no).val())) * parseFloat(filterNum($("#total_time_fixed"+no).val()))));
        }else
        {
            $("#total_value"+no).val(commaSplit(parseFloat(filterNum($("#per_hour_salary"+no).val())) * parseFloat(filterNum($("#total_time"+no).val()))));
        }
        calc_director("employee");
        calc_director_value("employee");
    }
    
</script>