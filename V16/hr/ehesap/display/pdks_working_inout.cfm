<!---
    File: V16\hr\ehesap\display\pdks_working_inout.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-11-1
    Description: Çalışan pdks giriş çıkışlar
--->
<cf_xml_page_edit>
<script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.js"></script>
<script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout-mapping.js"></script>
<cfif isdefined("attributes.attributes_json")>
    <cfset deserialize_atributes = DeserializeJSON(URLDecode(attributes.ATTRIBUTES_JSON))>
    <cfset StructAppend(attributes,deserialize_atributes,true)>
</cfif>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.in_out_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id_par" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.sal_mon" default="#month(dateadd('m',-1,now()))#">
<cfparam name="attributes.sal_year" default="#session.ep.PERIOD_YEAR#">
<cfif not(isdefined("is_extworktime_process") and len(is_extworktime_process)) or not(isdefined("is_offtime_process") and len(is_offtime_process))>
    <cf_get_lang dictionary_id='32947.Bu Sayfa İçin XML Tanımı Yapılmamış'>
    <cfabort>
</cfif>

<cfset number_of_days = daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1))>
<cfset last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon,1,0,0,0)>
<cfset last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon,daysinmonth(last_month_1),23,59,59)>
<cfset general_offtime_days = ''>
<cfsavecontent  variable="day_names"><cf_get_lang_main no='213.paz'>,<cf_get_lang_main no='207.pzt'>,<cf_get_lang_main no='208.sal'>,<cf_get_lang_main no='209.crs'>,<cf_get_lang_main no='210.per'>,<cf_get_lang_main no='211.cum'>,<cf_get_lang_main no='212.cmt'></cfsavecontent>

<cfset cmp_company = createObject("component","V16.hr.cfc.get_our_company")>
<cfset cmp_company.dsn = dsn>
<cfset get_our_company = cmp_company.get_company()>

<cfparam name="attributes.comp_id" default="#get_our_company.comp_id#">

<cfif (isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all")>
	<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branches")>
	<cfset cmp_branch.dsn = dsn>
	<cfset get_branch = cmp_branch.get_branch(comp_id: attributes.comp_id)>
</cfif>

<cfif (isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all")>
	<cfset	cmp_department = createObject("component","V16.hr.cfc.get_departments")>
	<cfset	cmp_department.dsn = dsn>
	<cfset	get_department = cmp_department.get_department(branch_id: attributes.branch_id)>
</cfif>

<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset get_projects = getComponent.get_projects()>

<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>

<cfset get_calender_offtimes_cmp = createObject("component","V16.hr.ehesap.cfc.hourly_addfare_percantege")>
<cfset get_calender_offtimes = get_calender_offtimes_cmp.get_calender_offtimes()>

<cfset setup_working_type_cmp = createObject("component","V16.settings.cfc.setup_working_type")>
<cfset get_setup_working_type = setup_working_type_cmp.get_setup_working_type()>
<cfset get_setup_offtime = setup_working_type_cmp.get_setup_offtime()>

<cfset pdks_working_inout_cmp = createObject("component","V16.hr.ehesap.cfc.pdks_working_inout")>

<cfset cmp_process = createObject('component','V16.workdata.get_process')>

<cfif get_calender_offtimes.recordcount>	
	<cfoutput query="get_calender_offtimes">
        <cfset general_offtime_days = listappend(general_offtime_days,createodbcdatetime(createdate(year(get_calender_offtimes.START_DATE),month(get_calender_offtimes.START_DATE),day(get_calender_offtimes.START_DATE))))>
        <cfset general_offtime_days = listappend(general_offtime_days,createodbcdatetime(createdate(year(get_calender_offtimes.FINISH_DATE),month(get_calender_offtimes.FINISH_DATE),day(get_calender_offtimes.FINISH_DATE))))>
	</cfoutput>
    <cfset general_offtime_days = ListRemoveDuplicates(general_offtime_days)>
</cfif>

<cfif isDefined("attributes.is_submit")>
    <cfset pdks_working_inout_cmp = createObject("component","V16.hr.ehesap.cfc.pdks_working_inout")>
    <cfset get_pdks_working_inout = pdks_working_inout_cmp.get_pdks_working_inout(
            project_id: len(attributes.project_id) ? attributes.project_id : '',
            sal_mon : attributes.sal_mon,
            sal_year : attributes.sal_year,
            in_out_id : len(attributes.in_out_id) ? attributes.in_out_id : '',
            employee_id : len(attributes.employee_id) ? attributes.employee_id : '',
            employee_name : len(attributes.employee_name) ? attributes.employee_name : '',
            department_id : len(attributes.department) ? attributes.department : '',
            company_id_par : len(attributes.company_id) ? attributes.company_id : '',
            consumer_id_par : len(attributes.consumer_id) ? attributes.consumer_id : '',
            employee_id_par : len(attributes.employee_id_par) ? attributes.employee_id_par : '',
            member_type : len(attributes.member_type) ? attributes.member_type : '',
            member_name : len(attributes.member_name) ? attributes.member_name : '',
            company_id : len(attributes.comp_id) ? attributes.comp_id : '',
            branch_id :  len(attributes.branch_id) ? attributes.branch_id : ''
    )>
<cfelse>
    <cfset get_pdks_working_inout.recordcount = 0>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_pdks" id="search_pdks" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
            <cf_box_search>
                <cfinput type="hidden" name = "is_submit" value = "1">
                <div class="form-group" id="item-comp_id">
                    <select name="comp_id" id="comp_id" onChange="showBranch(this.value)" style="width:150px !important">
                        <cfoutput query="get_our_company"><option value="#comp_id#"<cfif attributes.comp_id eq comp_id>selected</cfif>>#nick_name#</option></cfoutput>
                    </select>
                </div>
                <div class="form-group" id="item-BRANCH_PLACE">
                    <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)" style="width:250px !important">
                        <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                        <cfif isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all">
                            <cfoutput query="get_branch">
                                <option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group" id="item-DEPARTMENT_PLACE">
                    <select name="department" id="department" style="width:150px !important">
                        <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
                            <cfoutput query="get_department">
                                <option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group" id="item-employee_name" >
                    <cf_wrk_employee_in_out
                        form_name="search_pdks"
                        emp_id_fieldname="employee_id"
                        in_out_id_fieldname="in_out_id"
                        width="188"
                        emp_name_fieldname="employee_name"
                        emp_id_value="#len(attributes.employee_name) ? attributes.employee_id : ''#"
                        in_out_value="#len(attributes.employee_name) ? attributes.in_out_id : ''#"
                        >
                </div>
                <div class="form-group" id="item-project_id"  style="width:250px !important">
                    <cf_multiselect_check
                        option_text=#getLang('main','',57416,'Proje')#
                        filter=1
                        query_name="get_projects"
                        name="project_id"
                        option_value="PROJECT_ID"
                        option_name="PROJECT_HEAD" value="#attributes.project_id#">
                </div>
                <div class="form-group" id="item-company">
                    <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company_id)>value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                    <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.consumer_id)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                    <input type="hidden" name="employee_id_par" id="employee_id_par" <cfif len(attributes.employee_id_par)>value="<cfoutput>#attributes.employee_id_par#</cfoutput>"</cfif>>
                    <input type="hidden" name="member_type" id="member_type" <cfif len(attributes.member_type)>value="<cfoutput>#attributes.member_type#</cfoutput>"</cfif>>
                    <div class="input-group">
                        <input type="text" name="member_name" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id_par,member_type','','3','225');" <cfif len(attributes.member_name)>value="<cfoutput>#attributes.member_name#</cfoutput>"</cfif> autocomplete="off" placeholder="<cf_get_lang dictionary_id='57519.Cari Hesap'>">
                        <cfset str_linke_ait="field_consumer=form_list.consumer_id&field_comp_id=form_list.company_id&field_comp_name=form_list.member_name&field_name=form_list.member_name&field_emp_id=form_list.employee_id_par&field_type=form_list.member_type">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1&<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9');"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="sal_year" id="sal_year">
                        <cfloop from="#period_years.period_year[1]-period_years.recordcount#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="sal_mon" id="sal_mon">
                        <cfloop from="1" to="12" index="i">
                            <cfoutput>
                                <option value="#i#" <cfif (attributes.sal_mon eq i)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                            </cfoutput>
                        </cfloop>
                    </select>	
                </div>
                <div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray2" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.list_emp_daily_in_out&event=Add</cfoutput>')"><i class="fa fa-download" title="<cf_get_lang dictionary_id='58641.İmport'>" alt="<cf_get_lang dictionary_id='58641.İmport'>"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfform name="branch_pdks" action="" method="post">
        <cf_box title="#getLang('','Giriş Çıkışlar',32389)#" hide_table_column="1" uidrop="1">
            <cfif not isDefined("attributes.is_submit")>
                <cf_grid_list>
                    <tbody>
                        <tr>
                            <td colspan="50"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
                        </tr>
                    </tbody>
                </cf_grid_list>
            <cfelse>
                <cfif get_pdks_working_inout.recordcount>
                    <input type="hidden" value="<cfoutput>#get_pdks_working_inout.recordcount#</cfoutput>" name="total_count" id="total_count">
                    <input type="hidden" value="<cfoutput>#SESSION.EP.PERIOD_YEAR##attributes.comp_id##attributes.sal_mon##attributes.sal_year#</cfoutput>" name="special_code" id="special_code">
                    <input type="hidden" value="<cfoutput>#attributes.SAL_MON#</cfoutput>" name="sal_mon" id="sal_mon">
                    <input type="hidden" value="<cfoutput>#attributes.sal_year#</cfoutput>" name="sal_year" id="sal_year">
                    <input type="hidden" value="<cfoutput>#number_of_days#</cfoutput>" name="number_of_days" id="number_of_days">
                    <input type="hidden" value="" name="action_list" id="action_list">
                    <input type="hidden" value="<cfoutput>#is_extworktime_process#</cfoutput>" name="is_extworktime_process" id="is_extworktime_process">
                    <input type="hidden" value="<cfoutput>#is_offtime_process#</cfoutput>" name="is_offtime_process" id="is_offtime_process">
                    <cfset attributes_json = Replace(SerializeJSON(attributes),"//","")>
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
                                <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                                <th><cf_get_lang dictionary_id='55478.Rol'></th>
                                <cfloop from="1" to="#number_of_days#" index="i">
                                    <cfset temp_ = createodbcdatetime(createdate(attributes.sal_year,attributes.sal_mon,i))>
                                    <th><cfoutput>#i# #listgetat(day_names,dayofweek(temp_))#</cfoutput></th>
                                </cfloop>
                            </tr>
                        </thead>
                        <tbody data-bind="foreach: TableData()">
                            <tr>
                                <input type="hidden" data-bind="value: in_out_id">
                                <input type="hidden" data-bind="value: employee_id">
                                <input type="hidden" data-bind="value: branch_id">
                                <td data-bind="text: tc_identy_no"></td>
                                <td data-bind="text: emp_name_surname"></td>
                                <td data-bind="text: position_name"></td>       
                                <cfloop from="1" to="#number_of_days#" index="i">
                                    <cfset temp_2 = createodbcdatetime(createdate(attributes.sal_year,attributes.sal_mon,i))>
                                    <cfoutput>
                                        <td style="background:#chr(35)#<cfif listfindnocase(general_offtime_days,temp_2)>FFF2F2<cfelseif session.ep.week_start eq 0 and (dayofweek(temp_2) eq 7 or dayofweek(temp_2) eq 6)>F7F7F7<cfelseif session.ep.week_start eq 1 and (dayofweek(temp_2) eq 7 or dayofweek(temp_2) eq 1)>F7F7F7<cfelse>FFFFFF</cfif>" data-bind=" 
                                            html: days_#i#, 
                                            style: { cursor : 'pointer', padding:0}, 
                                            click: function() { openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.working_inout_day&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&day=#i#&branch_id='+$data.branch_id+'&in_out_id='+$data.in_out_id+'&employee_id='+$data.employee_id+'&currentrow='+$data.currentrow,'','ui-draggable-box-medium'); }">
                                        </td>
                                    </cfoutput>
                                </cfloop>         
                           </tr>
                            <!--- <cfoutput query = "get_pdks_working_inout">
                                <input type="hidden" value="#in_out_id#" name="in_out_id_#currentrow#" id="in_out_id_#currentrow#">
                                <input type="hidden" value="#employee_id#" name="employee_id_#currentrow#" id="employee_id_#currentrow#">
                                <input type="hidden" value="#branch_id#" name="branch_id" id="branch_id">
                                <tr>
                                    <td>#tc_identy_no#</td>
                                    <td>#emp_name_surname#</td>
                                    <td>#position_name#</td>
                                    <cfloop from="1" to="#number_of_days#" index="i">
                                        <cfset get_employee_daily_in_out = pdks_working_inout_cmp.get_employee_daily_in_out(
                                            day_ : i, 
                                            sal_mon : attributes.sal_mon,
                                            sal_year : attributes.sal_year, 
                                            in_out_id : in_out_id
                                        )>
                                        <td <cfif get_employee_daily_in_out.recordcount>style="background-color: #chr(35)##get_employee_daily_in_out.COLOR_CODE#"</cfif>>
                                            <select name="working_type_#in_out_id#_#i#_#currentrow#" id="working_type_#in_out_id#_#i#_#currentrow#">
                                                <cfloop query="get_setup_working_type">
                                                    <option value="#get_setup_working_type.working_type#" style="background-color: #chr(35)##get_setup_working_type.COLOR_CODE#" <cfif get_employee_daily_in_out.DAY_TYPE eq get_setup_working_type.working_type>selected</cfif>>#get_setup_working_type.detail#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                    </cfloop>
                                </tr>
                            </cfoutput>  --->
                        </tbody>
                    </cf_grid_list>
                <cfelse>
                    <cf_grid_list>
                        <tbody>
                            <tr>
                                <td colspan="50"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                            </tr>
                        </tbody>
                    </cf_grid_list>
                </cfif>
            </cfif>
        </cf_box>
        <cfif get_pdks_working_inout.recordcount>
            <cf_box title="#getLang('','Renk Kodlarına Göre Mesai ve İzin',64216)#">
                <div class="col col-12 col-xs-12" type="column" index="1" sort="true">
                    <cfoutput query="get_setup_working_type">
                        <div class="form-group col col-3" id="item-total_net_amount">
                            <div class="col col-1 col-md-2 col-sm-3 col-xs-12">
                                <svg width="20" height="20">
                                    <rect width="20" height="20" style="fill:#chr(35)##get_setup_working_type.COLOR_CODE#;stroke-width:3;stroke:rgb(0,0,0)" />
                                </svg>
                            </div>
                            <div class="col col-11 col-md-10 col-sm-9 col-xs-12">
                                <cfif working_type eq -1><cf_get_lang dictionary_id='55753.Çalışma Günü'> <cf_get_lang dictionary_id='53539.FM'></cfif>
                                <cfif working_type eq -2><cf_get_lang dictionary_id='58867.Hafta Tatili'> <cf_get_lang dictionary_id='53539.FM'></cfif> 
                                <cfif working_type eq -3><cf_get_lang dictionary_id='31473.Resmi Tatil'> <cf_get_lang dictionary_id='53539.FM'></cfif>
                                <cfif working_type eq -4><cf_get_lang dictionary_id='54251.Gece Çalışması'> <cf_get_lang dictionary_id='53539.FM'></cfif>
                                <cfif working_type eq -5><cf_get_lang dictionary_id='55753.Çalışma Günü'></cfif>
                                <cfif working_type eq -6><cf_get_lang dictionary_id='58867.Hafta Tatili'></cfif>
                                <cfif working_type eq -7><cf_get_lang dictionary_id='29482.Genel Tatil'></cfif>
                                <cfloop query = "get_setup_offtime">
                                    <cfif get_setup_working_type.working_type eq get_setup_offtime.OFFTIMECAT_ID>#OFFTIMECAT#</cfif>
                                </cfloop>  
                            </div>
                        </div>
                    </cfoutput>
                </div>
            </cf_box>
            <cf_box title="#getLang('','Veri Gönderimi',64131)#">
                <cf_box_elements>
                    <div class="col col-4 col-xs-12" type="column" index="2" sort="true">
                        <cfoutput query="get_setup_working_type">                        
                            <div class="form-group" id="item-total_net_amount">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57492.Toplam"> #get_setup_working_type.detail#</label>
                                <cfset get_employee_daily_in_out_total = pdks_working_inout_cmp.get_employee_daily_in_out_diff(
                                    sal_mon : attributes.sal_mon,
                                    sal_year : attributes.sal_year, 
                                    <!--- in_out_id : "#ValueList(get_pdks_working_inout.in_out_id)#", --->
                                    day_type : working_type,
                                    attr : attributes
                                )>
                                <cfif len(get_employee_daily_in_out_total.minute_)>
                                    <cfset hours = int(get_employee_daily_in_out_total.minute_ / 60)>
                                    <cfset minute = get_employee_daily_in_out_total.minute_ mod 60>
                                <cfelse>
                                    <cfset hours = 0>
                                    <cfset minute = 0>
                                </cfif>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" readonly class="moneybox" name="amount_#working_type#" id="amount_#working_type#" value="#hours#:#minute#">
                                </div>
                            </div>
                        </cfoutput>
                    </div>
                    <div class="col col-4 col-xs-12" type="column" index="2" sort="true">
                        <cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
                            faction_list : 'ehesap.working_inout')>
                        <cf_workcube_general_process select_value = '#get_process_f.process_row_id#' print_type="318" is_termin_date="0">
                    </div>
                </cf_box_elements>
                <cfset send_url = ''>
                <cfif len(attributes.branch_id)>
                    <cfset send_url = send_url & '&branch_id=#attributes.branch_id#'>
                </cfif>
                <cfif len(attributes.department)>
                    <cfset send_url = send_url & '&department=#attributes.department#'>
                </cfif>
                <cfif len(attributes.employee_id)>
                    <cfset send_url = send_url & '&employee_id=#attributes.employee_id#'>
                </cfif>
                <cfif len(attributes.employee_name)>
                    <cfset send_url = send_url & '&employee_name=#attributes.employee_name#'>
                </cfif>
                <cfif len(attributes.in_out_id)>
                    <cfset send_url = send_url & '&in_out_id=#attributes.in_out_id#'>
                </cfif>
                <cfif len(attributes.project_id)>
                    <cfset send_url = send_url & '&project_id=#attributes.project_id#'>
                </cfif>
                <cfif len(attributes.consumer_id)>
                    <cfset send_url = send_url & '&consumer_id=#attributes.consumer_id#'>
                </cfif>
                <cfif len(attributes.company_id)>
                    <cfset send_url = send_url & '&company_id=#attributes.company_id#'>
                </cfif>
                <cfif len(attributes.employee_id_par)>
                    <cfset send_url = send_url & '&employee_id_par=#attributes.employee_id_par#'>
                </cfif>
                <cfif len(attributes.member_name)>
                    <cfset send_url = send_url & '&member_name=#attributes.member_name#'>
                </cfif>
                <cfif len(attributes.member_type)>
                    <cfset send_url = send_url & '&member_type=#attributes.member_type#'>
                </cfif>
                <cfif len(attributes.sal_mon)>
                    <cfset send_url = send_url & '&sal_mon=#attributes.sal_mon#'>
                </cfif>
                <cfif len(attributes.sal_year)>
                    <cfset send_url = send_url & '&sal_year=#attributes.sal_year#'>
                </cfif>
                <cfif isdefined("attributes.is_submit")>
                    <cfset send_url = send_url & '&is_submit=#attributes.is_submit#'>
                </cfif>
                <cfif isdefined("attributes.attributes_json")>
                    <cfset send_url = send_url & '&attributes_json=#URLEncodedFormat(attributes_json)#'>
                </cfif>
                <div class="form-group">
                    <cf_workcube_buttons is_upd='0' data_action = "/V16/hr/ehesap/cfc/pdks_working_inout:add_pdks_working_inout" insert_info="#getLang('','İzin ve fazla mesai kaydet',64150)#" add_function="ProcessControl()" next_page="#request.self#?fuseaction=ehesap.working_inout#send_url#">
                <!--- <cf_workcube_buttons extraButton="1"   extraButtonText="#getLang('','İzin ve fazla mesai kaydet',64150)#" update_status="0" data_action = "/V16/hr/ehesap/cfc/pdks_working_inout:add_pdks_working_inout" extraFunction="ProcessControl()" next_page="#request.self#?fuseaction=ehesap.working_inout"> --->
                </div>
            </cf_box>
        </cfif>
    </cfform>
</div>
<script type="text/javascript">
    <cfif get_pdks_working_inout.recordcount>
        <cfset action_list = ''>
        $(document).ready(function() {
            ko.applyBindings(TableData());
        });
        var employee_in_out_struct = [
        <cfoutput query = "get_pdks_working_inout">
            { 
                currentrow: "#currentrow#",
                in_out_id: "#in_out_id#",
                employee_id : "#employee_id#",
                branch_id : "#branch_id#",
                tc_identy_no: "#tc_identy_no#", 
                emp_name_surname:  "#emp_name_surname#",
                position_name: "#position_name#",

                <cfloop from="1" to="#number_of_days#" index="i">
                    <cfset get_employee_daily_in_out = pdks_working_inout_cmp.get_employee_daily_in_out(
                        day_ : i, 
                        sal_mon : attributes.sal_mon,
                        sal_year : attributes.sal_year, 
                        in_out_id : "#in_out_id#"
                    )>
                    <cfif get_employee_daily_in_out.recordcount>
                        <cfset days_list = "<table style='width: 100%; border-collapse: collapse; margin: 0px!important;'><tr id='day_table_#currentrow#_#i#'>">
                        <cfloop query = "get_employee_daily_in_out">
                            <cfset days_list = days_list & "<td style='background: #chr(35)##get_employee_daily_in_out.color_code#;padding: 7px;'>#get_employee_daily_in_out.working_abbreviation#</td>">
                            <cfif len(action_list)>
                                <cfset action_list = action_list & ",#get_employee_daily_in_out.row_id#">
                            <cfelse>
                                <cfset action_list = "#get_employee_daily_in_out.row_id#">
                            </cfif>
                        </cfloop>
                        <cfset days_list = days_list&'</tr></table>'>
                        days_#i# : "#days_list#",
                    <cfelse>
                        days_#i# : "<table style='width: 100%; border-collapse: collapse; margin: 0px!important;'><tr id='day_table_#currentrow#_#i#'></tr></table>",
                    </cfif>
                </cfloop>
            }<cfif currentrow neq get_pdks_working_inout.recordcount>,</cfif>
        </cfoutput>
        ];
        this.TableData = ko.computed(function()
        {
            var data = ko.unwrap(employee_in_out_struct)
            var res = ko.observableArray();
            
            for (var i in data)
            {
                res.push(
                { 
                    currentrow: data[i].currentrow, 
                    employee_id: data[i].employee_id, 
                    branch_id: data[i].branch_id,
                    tc_identy_no: data[i].tc_identy_no, 
                    emp_name_surname: data[i].emp_name_surname, position_name: data[i].position_name,
                    <cfloop from="1" to="#number_of_days#" index="i">
                        days_<cfoutput>#i#</cfoutput> : data[i].days_<cfoutput>#i#</cfoutput>,
                    </cfloop>
                    in_out_id: data[i].in_out_id
                });
            }
            $("#action_list").val("<cfoutput>#action_list#</cfoutput>");
            return res;
        }, this);
    </cfif>
	function showDepartment(branch_id)	
	{
		var branch_id = $("#branch_id").val();
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'item-DEPARTMENT_PLACE',0,'İlişkili Departmanlar');
		}
		else
		{
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode("<cf_get_lang dictionary_id='57572.Departman'>"));
			myList.appendChild(txtFld);
		}
	}
	function showBranch(comp_id)	
	{
		var comp_id = $("#comp_id").val();
		if (comp_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
			AjaxPageLoad(send_address,'item-BRANCH_PLACE',0,"<cf_get_lang dictionary_id='55769.İlişkili Şubeler'>");
		}
		else {
            $("#branch_id").val() = "";
            $("#department").val();
        }
		//departman bilgileri sıfırla
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
		AjaxPageLoad(send_address,'item-DEPARTMENT_PLACE',0,"<cf_get_lang dictionary_id='55770.İlişkili Departmanlar'>");
	}
    function ProcessControl()
    {
        if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
			return false;
		}else{
			paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
			if(paper_no_control.recordcount > 0)
			{
            	alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
				paper_no_val = $('#general_paper_no').val();
				paper_no_split = paper_no_val.split("-");
				if(paper_no_split.length == 1)
					paper_no = paper_no_split[0];
				else
					paper_no = paper_no_split[1];
				paper_no = parseInt(paper_no);
				paper_no++;
				if(paper_no_split.length == 1)
					$('#general_paper_no').val(paper_no);
				else
					$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
				return false;
			}
		}
		if( $.trim($('#general_paper_date').val()) == '' ){
			alert("Lütfen Belge Tarihi Giriniz!");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("Lütfen Ek Açıklama Giriniz!");
			return false;
		}
        if(!$("#action_list").val()){
            alert("<cf_get_lang dictionary_id='64155.Çalışanlara Giriş Çıkış Tanımlamaları Yapınız!'>");
            return false;
        }
    }
</script>