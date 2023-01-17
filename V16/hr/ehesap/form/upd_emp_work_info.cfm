<cf_xml_page_edit fuseact='ehesap.list_salary'>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset x_university_ = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.list_salary',
    property_name : 'x_university'
    )>
<cfif x_university_.recordcount eq 0>
    <cfset x_university = 1>
<cfelse>
    <cfset x_university = x_university_.PROPERTY_VALUE>
</cfif>
<cf_get_lang_set_main>

<cfset lang_array_main = variables.lang_array_main>

<cfset in_out_cmp = createObject("component","V16.hr.ehesap.cfc.employees_in_out") />
<cfset get_emp_ssk = in_out_cmp.get_emp_ssk(in_out_id : attributes.in_out_id)>
<cfset get_factor_definition_all = in_out_cmp.get_factor_definition()>


<cfif not isdefined("attributes.period_id") >
	<cfset attributes.period_id = SESSION.EP.PERIOD_ID>
</cfif>
<cfset attributes.fuseaction = 'ehesap.list_salary'>

<cfset GET_OTHER_PERIOD = in_out_cmp.GET_OTHER_PERIOD(period_id: attributes.period_id)>
<cfset get_in_out_info = in_out_cmp.get_in_out_info(department_id: get_emp_ssk.department_id)>

<cfif not isdefined("get_moneys")>
	<cfinclude template="../query/get_moneys.cfm">
</cfif>

<cfset attributes.branch_id = get_in_out_info.branch_id>
<cfset attributes.sal_mon = month(now())>
<cfset attributes.sal_year = year(now())>
<cfset ismultiselect_used = 1>

<cfif dateformat(now(),'yyyy') gt attributes.sal_year>
	<cfset attributes.month_ = 'M12'>
<cfelse>
	<cfset attributes.month_ = 'M#dateformat(now(),'m')#'>
</cfif>
<cfinclude template="../query/get_ssk_yearly.cfm">
<cfinclude template="../query/get_active_shifts.cfm">
<cfif len(get_emp_ssk.PAYMETHOD_ID)>
	<cfset attributes.paymethod_id = get_emp_ssk.paymethod_id>
	<cfinclude template="../query/get_paymethod.cfm">
	<cfset PAY_TEMP = "#get_paymethod.paymethod#">
<cfelse>
	<cfset PAY_TEMP = "">
</cfif>

<cfif attributes.SAL_MON neq 1>
	<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
		SELECT 
			EMPLOYEES_PUANTAJ_ROWS.KUMULATIF_GELIR_MATRAH
		FROM 
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS
		WHERE 
			EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
			EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
			EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
		ORDER BY
			EMPLOYEE_PUANTAJ_ID DESC
	</cfquery>
<cfelseif (attributes.SAL_MON eq 1) and (year(now()) gt attributes.sal_year)>
	<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
		SELECT 
			EMPLOYEES_PUANTAJ_ROWS.KUMULATIF_GELIR_MATRAH
		FROM 
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS
		WHERE 
			EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
			EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())-1#"> AND
			EMPLOYEES_PUANTAJ.SAL_MON = 12
		ORDER BY
			EMPLOYEE_PUANTAJ_ID DESC
	</cfquery>
<cfelseif (attributes.SAL_MON eq 1) and (year(now()) eq attributes.sal_year)>
	<cfset get_kumulative.KUMULATIF_GELIR_MATRAH = 0>
	<cfset get_kumulative.recordcount = 0>
</cfif>
<cfif get_kumulative.recordcount>
	<cfset cumulative_tax_total_= get_kumulative.KUMULATIF_GELIR_MATRAH> 
<cfelseif year(get_emp_ssk.start_date) lt attributes.sal_year>
	<cfset cumulative_tax_total_ = 0>
<cfelseif len(get_emp_ssk.CUMULATIVE_TAX_TOTAL)>
	<cfset cumulative_tax_total_ = get_emp_ssk.CUMULATIVE_TAX_TOTAL>
<cfelse>
	<cfset cumulative_tax_total_ = 0>
</cfif>

<cfquery name="get_daily_minimum_wage_base" datasource="#dsn#" maxrows="1">
    SELECT 
        SUM(DAILY_MINIMUM_WAGE_BASE_CUMULATE) DAILY_MINIMUM_WAGE_BASE_CUMULATE 
    FROM 
        EMPLOYEES_PUANTAJ EP,
        EMPLOYEES_PUANTAJ_ROWS EPR
    WHERE
        EP.PUANTAJ_TYPE = -1 AND
        EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
        EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
        EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#">
</cfquery>
<cfif get_daily_minimum_wage_base.recordcount and len(get_daily_minimum_wage_base.DAILY_MINIMUM_WAGE_BASE_CUMULATE)>
	<cfset cumulative_wage_total_ = get_daily_minimum_wage_base.DAILY_MINIMUM_WAGE_BASE_CUMULATE>
<cfelse>
	<cfset cumulative_wage_total_ = 0>
</cfif>
<cfif len(get_emp_ssk.START_CUMULATIVE_WAGE_TOTAL)>
    <cfset cumulative_wage_total_ = cumulative_wage_total_ + get_emp_ssk.START_CUMULATIVE_WAGE_TOTAL>
</cfif>

<div style="display:none;z-index:999;" id="monthly_average_net"></div>
<cfinclude template="/V16/hr/ehesap/query/get_program_parameter.cfm">
<cfif get_program_parameters.recordcount and len(get_program_parameters.PARTIAL_WORK)>
    <cfset partial_work = get_program_parameters.PARTIAL_WORK>
<cfelse>
    <cfset partial_work = 31>
</cfif>
<cfif get_program_parameters.recordcount and len(get_program_parameters.PARTIAL_WORK_TIME)>
    <cfset partial_work_time = get_program_parameters.PARTIAL_WORK_TIME>
<cfelse>
    <cfset partial_work_time = 232.5>
</cfif>
<!--- <cfif not(isdefined('attributes.isAjax') and len(attributes.isAjax))>
    <cf_catalystHeader>
</cfif> --->
<cfset get_service_class = createObject("component","V16.settings.cfc.service_class").listServiceClass()/>

<cfsavecontent  variable="title">
    <cf_get_lang dictionary_id='39066.Salary Card'>
</cfsavecontent>
<div <cfif (isdefined('attributes.isAjax') and len(attributes.isAjax))>style=" margin-top: -5px; "</cfif>>
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_emp_work" method="post" name="employe_work" id="employe_work">
            <cfif isdefined("attributes.isAjax") and len(attributes.isAjax)>
                <input type="hidden" name="callAjaxBranch" id="callAjaxBranch" value="1">  	      
            </cfif>
            <cfif fuseaction contains "popup_">
                <input type="hidden" name="comes_popup" id="comes_popup" value="1">
            </cfif>
            <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput><cfif isdefined("attributes.employee_id")>#attributes.employee_id#<cfelse>#get_emp_ssk.employee_id#</cfif></cfoutput>">
            <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#get_emp_ssk.in_out_id#</cfoutput>">
            <input type="hidden" name="partial_work_hidden" id="partial_work_hidden" value="<cfoutput>#TLFormat(partial_work_time)#</cfoutput>">
            <div class="formContent margin-0">
                <cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                            <div class="col col-4 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value='#get_emp_ssk.in_out_stage#' process_cat_width='150' is_detail='1'>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53806.İşyeri"></cfsavecontent>
                        <cf_seperator title="#message#" id="branch_info_table" is_designer="1" index="2">
                        <cf_box_elements id="branch_info_table">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true" >
                                <div class="form-group" id="item-nick_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                                    <label class="col col-8 col-xs-12 txtbold"><cfoutput>#get_in_out_info.nick_name#</cfoutput></label>
                                </div>
                                <div class="form-group" id="item-old_branch_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                    <label class="col col-8 col-xs-12 txtbold"><cfoutput>#get_in_out_info.branch_name#</cfoutput></label>
                                    <input type="hidden" name="old_branch_id" id="old_branch_id" value="<cfoutput>#get_in_out_info.branch_id#</cfoutput>">
                                    <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_in_out_info.branch_id#</cfoutput>">
                                </div>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                <div class="form-group" id="item-ssk_office">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53552.SGK İşyeri'></label>
                                    <label class="col col-8 col-xs-12 txtbold"><cfoutput>#get_in_out_info.ssk_office# (#get_in_out_info.ssk_no#)</cfoutput></label>
                                </div>
                                <div class="form-group" id="item-department">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="old_department_id" id="old_department_id" value="<cfoutput>#get_in_out_info.department_id#</cfoutput>">
                                            <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_in_out_info.department_id#</cfoutput>">
                                            <input type="text" name="department" id="department" value="<cfoutput>#get_in_out_info.department_head#</cfoutput>" >
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=employe_work.department_id&field_name=employe_work.department&field_branch_id=employe_work.branch_id&branch_id=#get_in_out_info.branch_id#</cfoutput>','list');"></span>
                                        </div>
                                    </div>
                                
                                </div>
                            </div>
                        </cf_box_elements>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57576.Çalışan"></cfsavecontent>
                        <cf_seperator header="#message#" id="employee_info_table" is_designer="1" index="5">
                        <cf_box_elements  id="employee_info_table">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="6" sort="true">
                                <div class="form-group" id="item-use_ssk">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53606.SSK Durumu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53606.SSK Durumu'></cfsavecontent>
                                        <select  name="use_ssk" id="use_ssk" onchange="change_use_ssk(this.value)">
                                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="1" <cfif get_emp_ssk.use_ssk eq 1>selected</cfif>><cf_get_lang dictionary_id='45049.Worker'></option>
                                            <option value="2" <cfif get_emp_ssk.use_ssk eq 2>selected</cfif>><cf_get_lang dictionary_id='62870.Memur'></option>
                                            <option value="3" <cfif get_emp_ssk.use_ssk eq 3>selected</cfif>><cf_get_lang dictionary_id='62871.Serbest Çalışan'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-administrative_academic" <cfif get_emp_ssk.use_ssk neq 2>style="display:none"</cfif>>
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='46563.Akademik'> - <cf_get_lang dictionary_id='58428.idari'></label>
                                    <div class="col col-8 col-xs-12">
                                        <select  name="administrative_academic" id="administrative_academic" onchange="open_jury_check()">
                                            <option value="0" <cfif get_emp_ssk.administrative_academic eq 0>selected</cfif>><cf_get_lang dictionary_id='58428.idari'></option>
                                            <option value="1" <cfif get_emp_ssk.administrative_academic eq 1>selected</cfif>><cf_get_lang dictionary_id='46563.Akademik'></option>
                                            <option value="2" <cfif get_emp_ssk.administrative_academic eq 2>selected</cfif>><cf_get_lang dictionary_id='64624.Emekli Akademik'></option>
                                            <option value="3" <cfif get_emp_ssk.administrative_academic eq 3>selected</cfif>><cf_get_lang dictionary_id='63103.Sanatçı'></option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group" id="item-start_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53543.Son İşe Başlama'> - <cf_get_lang dictionary_id='57502.Bitiş'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53543.Son İşe Başlama'> - <cf_get_lang dictionary_id='57502.Bitiş'></cfsavecontent>
                                        <input name="start_date" id="start_date" type="text" readonly value="<cfoutput>#dateformat(get_emp_ssk.start_date,dateformat_style)#</cfoutput>" style="width:70px;">
                                        <cfif len(get_emp_ssk.finish_date)><cfoutput>#dateformat(get_emp_ssk.finish_date,dateformat_style)#</cfoutput></cfif>
                                    </div>
                                </div>
                                <cfif isdefined("x_registry_no") and x_registry_no eq 1>
                                    <div class="form-group" id="item-registry_no">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32329.Kurum Sicil No'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfinput type="text" name="registry_no" id="registry_no" value="#get_emp_ssk.registry_no#" maxlength="50">
                                        </div>
                                    </div>
                                </cfif>
                                <cfif is_get_sgkno eq 1>
                                    <div class="form-group" id="item-socialsecurity_no">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53237.SGK No'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53237.SGK No'></cfsavecontent>
                                            <cfinput type="text" name="socialsecurity_no"  onKeyUp="isNumber(this);" maxlength="13" value="#get_emp_ssk.socialsecurity_no#">
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group" id="item-RETIRED_SGDP_NUMBER">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53576.Emekli ise SGDP Tahsis No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53576.Emekli ise SGDP Tahsis No'></cfsavecontent>
                                        <cfinput type="text" name="RETIRED_SGDP_NUMBER" value="#get_emp_ssk.RETIRED_SGDP_NUMBER#"   onKeyUp="isNumber(this);">
                                    </div>
                                </div>
                                <div class="form-group" id="item-is_vardiya">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58543.Mesai Tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58543.Mesai Tipi'></cfsavecontent>
                                        <select name="is_vardiya" id="is_vardiya" onchange="open_shift_date(this.value)">
                                            <option value="0" <cfif get_emp_ssk.is_vardiya eq 0>selected</cfif>><cf_get_lang dictionary_id='58544.Sabit'></option>
                                            <option value="1" <cfif get_emp_ssk.is_vardiya eq 1>selected</cfif>><cf_get_lang dictionary_id='65269.Değişken Vardiyalı - Nöbetli'></option>
                                            <option value="2" <cfif get_emp_ssk.is_vardiya eq 2>selected</cfif>><cf_get_lang dictionary_id='65270.Sabit Vardiyalı'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-form_shift_start" style="<cfif get_emp_ssk.is_vardiya eq 0>display:none</cfif>">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36905.Vardiya'> <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
                                            <cfinput type="text" name="startdate_shift" value="#dateFormat(get_emp_ssk.startdate_shift,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate_shift"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-form_shift_finish" style="<cfif get_emp_ssk.is_vardiya eq 0>display:none</cfif>">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36905.Vardiya'> <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="finishdate_shift" value="#dateFormat(get_emp_ssk.finishdate_shift,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate_shift"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-sureli_is_finishdate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56428.Belirli Süreli İş Akdi'></label>
                                    <label class="col col-1"><input type="checkbox" name="sureli_is_akdi" id="sureli_is_akdi" value="1"<cfif get_emp_ssk.sureli_is_akdi eq 1>checked</cfif>></label>
                                    <div class="col col-7 col-xs-11">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='56428.Belirli Süreli İş Akdi'></cfsavecontent>
                                            
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='53581.Süreli İş Akdi Bitiş Tarihi'></cfsavecontent>
                                            <cfinput type="text" name="sureli_is_finishdate" style="width:107px;" value="#dateformat(get_emp_ssk.sureli_is_finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="sureli_is_finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-shift_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53062.Vardiyalar'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53062.Vardiyalar'></cfsavecontent>
                                        <select name="shift_id" id="shift_id" >
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_active_shifts">
                                                <option value="#shift_id#" <cfif GET_EMP_SSK.shift_id eq shift_id>selected</cfif>>#shift_name# (#start_hour#-#end_hour#)</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57734.Seçiniz"></cfsavecontent>
                                <div class="form-group" id="item-group_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56857.Çalışan Grubu"></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id="56857.Çalışan Grubu"></cfsavecontent>
                                        <cfset cmp = createObject("component","V16.hr.ehesap.cfc.employee_puantaj_group")>
                                        <cfset cmp.dsn = dsn/>
                                        <cfset get_groups = cmp.get_groups()>
                                        <cf_multiselect_check 
                                            query_name="get_groups"  
                                            name="group_id"
                                            width="130" 
                                            option_text="#message#" 
                                            option_value="group_id"
                                            option_name="group_name"
                                            value="#get_emp_ssk.puantaj_group_ids#">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="7" sort="true">
                                <div class="form-group" id="item-TRADE_UNION">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56402.Sendika'> - <cf_get_lang dictionary_id='53545.Sendika No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='56402.Sendika'> - <cf_get_lang dictionary_id='53545.Sendika No'></cfsavecontent>
                                            <cfinput type="text" name="TRADE_UNION" value="#get_emp_ssk.trade_union#" style="width:85px;" maxlength="200">
                                            <span class="input-group-addon no-bg"></span>
                                            <cfinput type="text" value="#get_emp_ssk.trade_union_no#" name="TRADE_UNION_NO" style="width:40px;" maxlength="50">
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-business_code" style="<cfif get_emp_ssk.use_ssk eq 2>display:none</cfif>">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53861.Meslek Grubu'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53861.Meslek Grubu'></cfsavecontent>
                                            <input type="hidden" name="business_code_id" id="business_code_id" value="<cfoutput>#get_emp_ssk.business_code_id#</cfoutput>">
                                            <input type="text" name="business_code" id="business_code" value="<cfoutput>#get_emp_ssk.business_code_name# <cfif len(get_emp_ssk.business_code)>(#get_emp_ssk.business_code#)</cfif></cfoutput>" style="width:275px;">
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_business_codes&field_id=employe_work.business_code_id&field_name=employe_work.business_code</cfoutput>','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                    <div class="form-group" id="item-service_class" style="<cfif get_emp_ssk.use_ssk neq 2>display:none</cfif>">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64104.Hizmet Sınıfı'></label>
                                        <div class="col col-8 col-xs-12">
                                            <select name="service_class" id="service_class" onchange="get_service_title(this.value)">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="get_service_class">
                                                    <option value="#SERVICE_CLASS_ID#"<cfif get_emp_ssk.service_class eq get_service_class.SERVICE_CLASS_ID>selected</cfif>>#SERVICE_CLASS#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-service_title" style="<cfif get_emp_ssk.use_ssk neq 2>display:none</cfif>">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64617.Unvan Kodu'>- <cf_get_lang dictionary_id='64618.Unvan Adı'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfinput type="hidden" name="service_title_id" id="service_title_id" value="">
                                            <select name="service_title" id="service_title" onchange="get_title_detail(this.value)">
                                                <cfif len(get_emp_ssk.service_class)>
                                                    <cfquery name="get_titles" datasource="#dsn#">
                                                        SELECT SERVICE_TITLE_ID,SERVICE_TITLE,SERVICE_TITLE_CODE,DETAIL FROM SETUP_SERVICE_TITLE WHERE SERVICE_CLASS_ID= <cfqueryparam value="#get_emp_ssk.service_class#" cfsqltype="cf_sql_integer">
                                                    </cfquery>
                                                    <cfoutput query="get_titles">
                                                        <option value="SERVICE_TITLE_ID" <cfif get_emp_ssk.service_title eq get_titles.SERVICE_TITLE_ID>selected</cfif>>#SERVICE_TITLE_CODE#- #SERVICE_TITLE#</option>
                                                    </cfoutput>
                                                </cfif>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-service_title_detail" style="<cfif get_emp_ssk.use_ssk neq 2>display:none</cfif>">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64616.Unvan Detayı'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfinput type="text" name="service_title_detail" id="service_title_detail" value="#iif(isDefined('get_titles'), "get_titles.DETAIL",DE(""))#">
                                        </div>
                                    </div>
                                <div class="form-group" id="item-ssk_statute">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53553.SGK Statüsü'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53553.SGK Statüsü'></cfsavecontent>
                                        <select name="ssk_statute" id="ssk_statute" style="width:275px;" onchange="working_abroad_open(this.value)">
                                            <cfset count_ = 0>
                                            <cfloop list="#list_ucret()#" index="ccn">
                                                <cfset count_ = count_ + 1>
                                                <cfoutput><option value="#ccn#" <cfif get_emp_ssk.ssk_statute eq ccn>selected</cfif>>#listgetat(list_ucret_names(),count_,'*')#</option></cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <!--Muzaffer Bas Tüm Sigorta Kolları Primine tabi Çalışanlar -->
                                 <div class="form-group" id="item-working_abroad">
                                    
                                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='54295.Sözleşmesiz ülkelere götürülerek çalıştırılanlar'></span></label>
                                    <div  class="col col-8 col-xs-12">
                                        <br>
                                        <label class="col col-12 col-xs-12">
                                            <input type="checkbox" name="IS_USE_506" id="IS_USE_506" value="1"<cfif get_emp_ssk.IS_USE_506 eq 1> checked</cfif>>Tüm Sigorta Kolları Primine Tabi Çalışıp 60 Gün Fiili Hizmet Zammına Tabi Çalışanlar
                                    </label>
                                    <br>
                                    <br>
                                    
                                  <!---  <label class="col col-12 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='54295.Sözleşmesiz ülkelere götürülerek çalıştırılanlar'></cfsavecontent>
                                        <input type="checkbox" name="working_abroad" id="working_abroad" value="1"<cfif get_emp_ssk.working_abroad eq 1> checked</cfif>><cf_get_lang dictionary_id='54295.Sözleşmesiz ülkelere götürülerek çalıştırılanlar'>
                                    </label>--->

                                    </div>
                                    
                                </div>
                                <!--Muzaffer Bit-->
                                <div class="form-group" id="item-working_abroad">
                                    <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='54295.Sözleşmesiz ülkelere götürülerek çalıştırılanlar'></span></label>
                                    <label class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='54295.Sözleşmesiz ülkelere götürülerek çalıştırılanlar'></cfsavecontent>
                                        <input type="checkbox" name="working_abroad" id="working_abroad" value="1"<cfif get_emp_ssk.working_abroad eq 1> checked</cfif>><cf_get_lang dictionary_id='54295.Sözleşmesiz ülkelere götürülerek çalıştırılanlar'>
                                    </label>
                                </div>
                                <div class="form-group" id="item-duty_type">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58538.Görev Tipi'></cfsavecontent>
                                            <select name="duty_type" id="duty_type" style="width:130px; float:left;" onchange="getir_kismi_istihdam_gun();">
                                                <option value="2" <cfif get_emp_ssk.duty_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'></option>
                                                <option value="1" <cfif get_emp_ssk.duty_type eq 1>selected</cfif>><cf_get_lang dictionary_id="53140.İşveren Vekili"></option>
                                                <option value="0" <cfif get_emp_ssk.duty_type eq 0>selected</cfif>><cf_get_lang dictionary_id='53550.İşveren'></option>
                                                <option value="3" <cfif get_emp_ssk.duty_type eq 3>selected</cfif>><cf_get_lang dictionary_id="53152.Sendikalı"></option>
                                                <option value="4" <cfif get_emp_ssk.duty_type eq 4>selected</cfif>><cf_get_lang dictionary_id="53178.Sözleşmeli"></option>
                                                <option value="5" <cfif get_emp_ssk.duty_type eq 5>selected</cfif>><cf_get_lang dictionary_id="53169.Kapsam Dışı"></option>
                                                <option value="6" <cfif get_emp_ssk.duty_type eq 6>selected</cfif>><cf_get_lang dictionary_id="53182.Kısmi İstihdam"></option>
                                                <option value="7" <cfif get_emp_ssk.duty_type eq 7>selected</cfif>><cf_get_lang dictionary_id="53199.Taşeron"></option>
                                                <cfif isdefined("is_gov_payroll") and is_gov_payroll eq 1>
                                                    <option value="8" <cfif get_emp_ssk.duty_type eq 8>selected</cfif>><cf_get_lang dictionary_id="54179.Derece">/<cf_get_lang dictionary_id="58710.Kademe"></option>
                                                </cfif>
                                            </select>
                                            <span class="input-group-addon" id="kismi_istihdam_gun_div" style="<cfif get_emp_ssk.duty_type neq 6 or (get_emp_ssk.duty_type eq 6 and get_emp_ssk.salary_type eq 0)>display:none;</cfif>">&nbsp;
                                                <select name="kismi_istihdam_gun" id="kismi_istihdam_gun">
                                                    <option value=""><cf_get_lang dictionary_id="57490.Gün"></option>
                                                    <cfloop from="1" to="#partial_work#" index="ccc">
                                                        <cfoutput>
                                                            <option value="#ccc#" <cfif get_emp_ssk.kismi_istihdam_gun eq ccc>selected</cfif>>#ccc#</option>
                                                        </cfoutput>
                                                    </cfloop>
                                                </select>
                                            </span>
                                            <span class="input-group-addon no-bg"  id="kismi_istihdam_saat_div" style="<cfif get_emp_ssk.duty_type neq 6 or (get_emp_ssk.duty_type eq 6 and get_emp_ssk.salary_type neq 0)>display:none;</cfif>">&nbsp;
                                                <cf_get_lang dictionary_id='57491.Saat'> <cfinput name="kismi_istihdam_saat" type="text" value="#TLFormat(get_emp_ssk.kismi_istihdam_saat)#" style="width:60px;" onkeyup="control_partial(this);return(formatcurrency(this,event));">
                                            </span>
                                            <span class="input-group-addon no-bg"  id="taseron_div" style="<cfif get_emp_ssk.duty_type neq 7>display:none;</cfif>">
                                                <input type="hidden" name="duty_type_company_id" id="duty_type_company_id" value="<cfoutput>#get_emp_ssk.duty_type_company_id#</cfoutput>">	
                                                <input name="company_name" type="text" id="company_name" style="min-width: 100px;margin: -10px;" value="<cfif isdefined("get_emp_ssk.duty_type_company_id") and len("get_emp_ssk.duty_type_company_id")><cfoutput>#get_par_info(get_emp_ssk.duty_type_company_id,1,1,0)#</cfoutput></cfif>">
                                            </span>
                                            <span  class="input-group-addon icon-ellipsis btnPointer" id="taseron_icon" style="<cfif get_emp_ssk.duty_type neq 7>display:none;</cfif>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&field_comp_id=employe_work.duty_type_company_id&field_comp_name=employe_work.company_name&select_list=7'</cfoutput>,'list','popup_list_all_pars');"></span>

                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-first_ssk_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53566.İlk Sigortalı Oluş Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53566.İlk Sigortalı Oluş Tarihi'></cfsavecontent>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='53566.İlk Sigortalı Oluş Tarihi'></cfsavecontent>
                                            <cfinput type="text" name="first_ssk_date"  value="#dateformat(get_emp_ssk.first_ssk_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="first_ssk_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-get_all_transport_types">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45122.Ulaşım Yöntemi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='45122.Ulaşım Yöntemi'></cfsavecontent>
                                        <cfquery name="get_all_transport_types" datasource="#dsn#">
                                            SELECT 
                                                *
                                            FROM 
                                                SETUP_TRANSPORT_TYPES
                                        </cfquery>
                                        <select name="transport_type_id" id="transport_type_id" >
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_all_transport_types">
                                                    <option value="#get_all_transport_types.transport_type_id#" <cfif get_emp_ssk.transport_type_id eq get_all_transport_types.transport_type_id>selected</cfif>>#get_all_transport_types.transport_type#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-use_pdks">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58009.PDKS'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58009.PDKS'></cfsavecontent>
                                                <select name="use_pdks" id="use_pdks" style="width:130px">
                                                    <option value="0"<cfif get_emp_ssk.use_pdks eq 0>selected</cfif>><cf_get_lang dictionary_id='53210.Bağlı değil'></option>
                                                    <option value="1"<cfif get_emp_ssk.use_pdks eq 1>selected</cfif>><cf_get_lang dictionary_id='53207.Bağlı'></option>
                                                    <option value="2"<cfif get_emp_ssk.use_pdks eq 2>selected</cfif>><cf_get_lang dictionary_id='53229.Tam bağlı'> <cf_get_lang dictionary_id='57491.Saat'></option>
                                                    <option value="3"<cfif get_emp_ssk.use_pdks eq 3>selected</cfif>><cf_get_lang dictionary_id='53229.Tam bağlı'> <cf_get_lang dictionary_id='57490.Gün'></option>
                                                    <option value="4"<cfif get_emp_ssk.use_pdks eq 4>selected</cfif>><cf_get_lang dictionary_id='38806.Vardiya Sistemi'></option>
                                                </select>
                                                <span class="input-group-addon no-bg"></span>
                                                <input type="text" name="pdks_number" id="pdks_number" onkeyup="isNumber(this);" value="<cfoutput>#get_emp_ssk.pdks_number#</cfoutput>" style="width:40px;">
                                                <span class="input-group-addon no-bg"></span>
                                            <cf_wrk_combo
                                                    query_name="get_pdks_type"
                                                    name="pdks_type_id"
                                                    option_value="PDKS_TYPE_ID"
                                                    option_name="PDKS_TYPE"
                                                    value="#get_emp_ssk.PDKS_TYPE_ID#"
                                                    width=100>                                     
                                        </div>
                                </div>
                                </div>
                            </div>
                        </cf_box_elements>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="58539.Dönem Başı Kümüle Vergi Matrahı"></cfsavecontent>
                                <cf_seperator header="#message#" id="kumulatif_info_table" is_designer="1" index="8">
                                <div class="row" type="row" id="kumulatif_info_table">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12 ui-form-list" type="column" index="9" sort="true">
                                        <div class="form-group col col-12" id="item-START_CUMULATIVE_TAX_TOTAL">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58539.Dönem Başı Kümüle Vergi Matrahı'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58539.Dönem Başı Kümüle Vergi Matrahı'></cfsavecontent>
                                                <cfinput name="START_CUMULATIVE_TAX_TOTAL" type="text" value="#TLFormat(get_emp_ssk.CUMULATIVE_TAX_TOTAL,2)#"  onkeyup="return(formatcurrency(this,event));">
                                            </div>
                                        </div>
                                        <div class="form-group col col-12" id="item-START_CUMULATIVE_TAX">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58540.Dönem Başı Kümüle Vergi Tutarı'></label>
                                                <div class="col col-6 col-xs-12">
                                                <input name="START_CUMULATIVE_TAX" id="START_CUMULATIVE_TAX" type="text" value="<cfoutput>#TLFormat(get_emp_ssk.START_CUMULATIVE_TAX)#</cfoutput>" style="width:50px;" onkeyup="return(formatcurrency(this,event));">
                                            </div> 
                                            <label class="col col-2">
                                                <input type="checkbox" name="is_start_cumulative_tax" id="is_start_cumulative_tax" value="1"<cfif get_emp_ssk.IS_START_CUMULATIVE_TAX eq 1>checked</cfif>> <cf_get_lang dictionary_id='53179.Bordro'>
                                            </label>
                                        </div>
										<div class="form-group col col-12" id="item-START_CUMULATIVE_WAGE_TOTAL">
                                            <label class="col col-4 col-xs-12">Dönem Başı Asgari Muafiyet Matrahı</label>
                                            <div class="col col-8 col-xs-12">
                                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58539.Dönem Başı Kümüle Vergi Matrahı'></cfsavecontent>
                                                <cfinput name="START_CUMULATIVE_WAGE_TOTAL" type="text" value="#TLFormat(get_emp_ssk.START_CUMULATIVE_WAGE_TOTAL,2)#"  onkeyup="return(formatcurrency(this,event));">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6col-sm-6 col-xs-12 ui-form-list" type="column" index="10" sort="true">
                                        <div class="form-group col col-12" id="item-START_CUMULATIVE_TAX_TOTAL_">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53573.Son Kümüle Vergi Matrahı'></label>
                                            <label class="col col-8 col-xs-12"><cfoutput>#TLFormat(cumulative_tax_total_)#</cfoutput></label>
                                        </div>
										<div class="form-group col col-12" id="item-START_CUMULATIVE_WAGE_TOTAL_">
                                            <label class="col col-4 col-xs-12">Asgari Muafiyet Vergi Matrahı</label>
                                            <label class="col col-8 col-xs-12"><cfoutput>#TLFormat(cumulative_wage_total_)#</cfoutput></label>
                                        </div>
                                        <div class="form-group col col-12" id="item-PAST_AGI_DAY">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64341.Geçmiş Agi Günü'></label>
                                           <div class="col col-8 col-xs-12">
                                                <cfinput name="past_agi_day" value="#tlFormat(get_emp_ssk.past_agi_day)#" type="text"  onkeyup="return(formatcurrency(this,event));" message="#message#">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53127.Ücret"></cfsavecontent>
                        <cf_seperator header="#message#" id="salary_info_table" is_designer="1" index="11">
                        <cf_box_elements  id="salary_info_table">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="12" sort="true">
                                <div class="form-group" id="item-sabit_prim">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53238.Ücret Tipi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53238.Ücret Tipi'></cfsavecontent>
                                        <select name="sabit_prim" id="sabit_prim" >
                                            <option value="0"<cfif get_emp_ssk.sabit_prim eq 0> selected</cfif>><cf_get_lang dictionary_id='58544.Sabit'></option>
                                            <option value="1"<cfif get_emp_ssk.sabit_prim eq 1> selected</cfif>><cf_get_lang dictionary_id='53558.Primli'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-get_salary_factor">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53127.Ücret'></label>
                                    <label class="col col-8 col-xs-12">
                                        <cfif get_emp_ssk.duty_type neq 8>
                                            <cfoutput>#TLFormat(evaluate("get_ssk_yearly.#attributes.month_#"))# - #get_ssk_yearly.money#</cfoutput>
                                        <cfelse>
                                            <cfset salary_extra_value = 0>
                                            <cfscript>
                                                parameter_last_month_1 = CreateDateTime(year(now()),month(now()),1,0,0,0);
                                                parameter_last_month_30 = CreateDateTime(year(now()),month(now()),daysinmonth(createdate(year(now()),month(now()),1)),0,0,0);
                                            </cfscript>
                                            <cfset get_factor_definition = in_out_cmp.get_factor_definition(startdate : parameter_last_month_1,finishdate:parameter_last_month_30)>
                                            <cfif get_factor_definition.recordcount>
                                                <cfquery name="get_salary_factor_def" datasource="#dsn#" maxrows="1">
                                                    SELECT GRADE,STEP FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> AND EMPLOYEE_ID = #attributes.employee_id#
                                                </cfquery>
                                                <cfif get_salary_factor_def.recordcount>
                                                    <cfquery name="get_salary_factor" datasource="#dsn#">
                                                        SELECT
                                                            EXTRA,
                                                            <cfif get_salary_factor_def.step eq 1>
                                                                GRADE1_VALUE GRADE_VALUE
                                                            <cfelseif get_salary_factor_def.step eq 2>
                                                                GRADE2_VALUE GRADE_VALUE
                                                            <cfelseif get_salary_factor_def.step eq 3>
                                                                GRADE3_VALUE GRADE_VALUE
                                                            <cfelseif get_salary_factor_def.step eq 4>
                                                                GRADE4_VALUE GRADE_VALUE
                                                            </cfif>
                                                        FROM
                                                            SALARY_FACTORS
                                                        WHERE
                                                            GRADE = #get_salary_factor_def.GRADE#
                                                    </cfquery>
                                                    <cfif get_salary_factor.recordcount>
                                                        <cfset salary_extra_value = get_salary_factor.extra>
                                                        <cfset salary_extra_value = salary_extra_value + get_salary_factor.grade_value>
                                                        <cfset salary_extra_value = salary_extra_value*get_factor_definition.SALARY_FACTOR>
                                                    </cfif>
                                                </cfif>
                                            </cfif>
                                            <cfoutput>#TLFormat(salary_extra_value)# - #session.ep.money#</cfoutput>
                                        </cfif>
                                    </label>
                                </div>
                                <div class="form-group" id="item-GROSS_NET">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53131.Brüt'> / <cf_get_lang dictionary_id='58083.Net'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53131.Brüt'> / <cf_get_lang dictionary_id='58083.Net'></cfsavecontent>
                                        <!--- <cfif session.ep.ehesap> --->
                                        <select name="GROSS_NET" id="GROSS_NET" >
                                            <option value="0"<cfif get_emp_ssk.gross_net eq 0> selected</cfif>><cf_get_lang dictionary_id='53131.Brüt'></option>
                                            <option value="1"<cfif get_emp_ssk.gross_net eq 1> selected</cfif>><cf_get_lang dictionary_id='58083.Net'></option>
                                        </select>
                                    </div>
                                </div>
                                <cfif show_average_salary eq 1>
                                    <div class="form-group" id="item-monthly_average_net">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58932.Aylık'><cf_get_lang dictionary_id='62729.Aylık Ortalama Net'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='58932.Aylık'><cf_get_lang dictionary_id='62729.Aylık Ortalama Net'></cfsavecontent>
                                            <cfinput name="monthly_average_net_" type="text" value="#TLFormat(get_emp_ssk.monthly_average_net,2)#"  onkeyup="return(formatcurrency(this,event));">
                                            </label>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group" id="item-SALARY_TYPE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53714.Ücret Yöntemi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53714.Ücret Yöntemi'></cfsavecontent>
                                        <select name="SALARY_TYPE" id="SALARY_TYPE"  onchange="kismi_istihdam_();">
                                            <option value="2" <cfif get_emp_ssk.salary_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
                                            <option value="1" <cfif get_emp_ssk.salary_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
                                            <option value="0" <cfif get_emp_ssk.salary_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57491.Saat'></option>
                                        </select>
                                    </div>
                                </div>
                                <cfif is_get_FMbilgisi eq 1>
                                    <div class="form-group" id="item-fazla_mesai_saat">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53570.Fazla Mesai Saat'></label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53570.Fazla Mesai Saat'></cfsavecontent>
                                            <cfif session.ep.ehesap>
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53582.Fazla Mesai Saati 0-60 arasi olmalidir'></cfsavecontent>
                                                <cfinput name="fazla_mesai_saat" validate="integer" range="0,60" value="#TLFormat(get_emp_ssk.fazla_mesai_saat,0)#" type="text"  onkeyup="return(formatcurrency(this,event,0));" message="#message#">
                                            <cfelse>
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53583.Fazla Mesai Saati 0-20 arasi olmalidir'></cfsavecontent>
                                                <cfinput name="fazla_mesai_saat" validate="integer" range="0,20" value="#TLFormat(get_emp_ssk.fazla_mesai_saat,0)#" type="text"  onkeyup="return(formatcurrency(this,event,0));" message="#message#">
                                            </cfif>
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group" id="item-EFFECTED_CORPORATE_CHANGE">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53578.Toplu ücret ayarlamasından etkilensin'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53578.Toplu ücret ayarlamasından etkilensin'></cfsavecontent>
                                        <input type="checkbox" name="EFFECTED_CORPORATE_CHANGE" id="EFFECTED_CORPORATE_CHANGE" value="1" <cfif get_emp_ssk.EFFECTED_CORPORATE_CHANGE eq 1>checked</cfif>>
                                    </div>
                                </div>
                                <div class="form-group" id="item-is_discount_off">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53660.Asgari Geçimden Yararlanmasın'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53660.Asgari Geçimden Yararlanmasın'></cfsavecontent>
                                        <input type="checkbox" name="is_discount_off" id="is_discount_off" value="1"<cfif get_emp_ssk.is_discount_off eq 1>checked</cfif>>
                                    </div>
                                </div>
                                <div class="form-group" id="item-is_puantaj_off">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53653.Puantaja Gelmesin'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53653.Puantaja Gelmesin'></cfsavecontent>
                                        <input type="checkbox" id="is_puantaj_off" name="is_puantaj_off" value="1" <cfif get_emp_ssk.is_puantaj_off eq 1>checked</cfif>>
                                    </div>
                                </div>
                                <div class="form-group" id="item-is_puantaj_off">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64733.Asgari Ücret İndiriminden Muaf'></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="checkbox" name="use_minimum_wage" id="use_minimum_wage" value="1"<cfif get_emp_ssk.use_minimum_wage eq 1> checked</cfif>> 
                                    </div>
                                </div>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="13" sort="true">
                                <div class="form-group" id="item-is_tax_free">
                                    <label class="col col-4 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53654.Gelir Vergisinden Muaf'></cfsavecontent>
                                        <input type="checkbox" name="is_tax_free" id="is_tax_free" value="1"<cfif get_emp_ssk.is_tax_free eq 1> checked</cfif>> <cf_get_lang dictionary_id='53654.Gelir Vergisinden Muaf'>
                                    </label>
                                    <label class="col col-4 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53126.Damga Vergisinden Muaf'></cfsavecontent>
                                        <input type="checkbox" name="is_damga_free" id="is_damga_free" value="1"<cfif get_emp_ssk.is_damga_free eq 1> checked</cfif>> <cf_get_lang dictionary_id='53126.Damga Vergisinden Muaf'>
                                    </label>
                                    <label class="col col-4 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53565.Vergi İndirimi Kullanıyor'></cfsavecontent>
                                        <input type="checkbox" name="use_tax" id="use_tax" value="1"<cfif get_emp_ssk.use_tax eq 1> checked</cfif>> <cf_get_lang dictionary_id='53565.Vergi İndirimi Kullanıyor'>
                                    </label>
                                </div>
                                <!--- <div class="form-group" id="item-is_damga_free">
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53126.Damga Vergisinden Muaf'></cfsavecontent>
                                        <input type="checkbox" name="is_damga_free" id="is_damga_free" value="1"<cfif get_emp_ssk.is_damga_free eq 1> checked</cfif>> <cf_get_lang dictionary_id='53126.Damga Vergisinden Muaf'>
                                    </div>
                                </div>
                                <div class="form-group" id="item-use_tax">
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53565.Vergi İndirimi Kullanıyor'></cfsavecontent>
                                        <input type="checkbox" name="use_tax" id="use_tax" value="1"<cfif get_emp_ssk.use_tax eq 1> checked</cfif>> <cf_get_lang dictionary_id='53565.Vergi İndirimi Kullanıyor'>
                                    </div>
                                </div> --->                                
                                <div class="form-group" id="item-DEFECTION_LEVEL">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53561.Engelilik Derecesi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53561.Engelilik Derecesi'></cfsavecontent>
                                        <select name="DEFECTION_LEVEL" id="DEFECTION_LEVEL"  onchange="use_tax_open(this.value)">
                                            <option value="0" <cfif get_emp_ssk.DEFECTION_LEVEL eq 0>selected</cfif>>
                                                <cf_get_lang dictionary_id='58546.Yok'>
                                            </option>
                                            <option value="1" <cfif get_emp_ssk.DEFECTION_LEVEL eq 1>selected</cfif>>1</option>
                                            <option value="2" <cfif get_emp_ssk.DEFECTION_LEVEL eq 2>selected</cfif>>2</option>
                                            <option value="3" <cfif get_emp_ssk.DEFECTION_LEVEL eq 3>selected</cfif>>3</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-defection_rate">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60217.Engelilik Oranı'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfinput type="text" id="defection_rate" name="defection_rate" value="#get_emp_ssk.defection_rate#"  onkeyup='isNumber(this)'>
                                    </div>
                                </div>
                                <div class="form-group" id="item-defection_date">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64167.Engellilik Geçerlilik Tarihi'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
                                                <cfinput type="text" name="defection_startdate" value="#dateFormat(get_emp_ssk.defection_startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="defection_startdate"></span>
                                            </div>
                                        </div>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
                                                <cfinput type="text" name="defection_finishdate" value="#dateFormat(get_emp_ssk.defection_finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="defection_finishdate"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-law_numbers">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53709.Özel Kanun Maddeleri'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='53709.Özel Kanun Maddeleri'></cfsavecontent>
                                        <select name="law_numbers" id="law_numbers" multiple="multiple" style="height:170px; width:170px;" onchange="law_number_control();">
                                            <option value="5921"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'5921')>selected</cfif>>5921</option>
                                            <option value="574680"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'574680')>selected</cfif>>5746 (% 80)</option>
                                            <option value="574690"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'574690')>selected</cfif>>5746 (% 90)</option>
                                            <option value="574695"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'574695')>selected</cfif>>5746 (% 95)</option>
                                            <option value="5746100"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'5746100')>selected</cfif>>5746 (% 100)</option>
                                            <option value="6111"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'6111')>selected</cfif>>6111</option>
                                            <option value="5084"<cfif get_emp_ssk.is_5084 eq 1>selected</cfif>>5084 (<cf_get_lang dictionary_id ='53986.Teşvik Yasası'>)</option>
                                            <option value="5763"<cfif get_emp_ssk.is_5510 eq 1>selected</cfif>>5763 (<cf_get_lang dictionary_id ='54136.Yeni İstihdam'>)</option>
                                            <option value="6486"<cfif get_emp_ssk.is_6486 eq 1>selected</cfif>>6486 ( <cf_get_lang dictionary_id ='45455.İlave Teşvik'>)</option>
                                            <option value="6322"<cfif get_emp_ssk.is_6322 eq 1>selected</cfif>>6322 ( <cf_get_lang dictionary_id ='45453.Yatırım Teşviki'>)</option>
                                            <option value="25510"<cfif get_emp_ssk.is_25510 eq 1>selected</cfif>>25510 ( <cf_get_lang dictionary_id ='45455.İlave Teşvik'>)</option>
                                            <option value="4691"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'4691')>selected</cfif>>4691 (% 100)</option>
                                            <option value="14857"<cfif get_emp_ssk.is_14857 eq 1>selected</cfif>>14857 ( %100 <cf_get_lang dictionary_id='45431.Engelli Teşviki'> )</option>
                                            <option value="6645" <cfif get_emp_ssk.is_6645 eq 1>selected</cfif>>6645 ( <cf_get_lang dictionary_id='45432.İşbaşı Eğitim Teşviki'> )</option>
                                            <option value="46486" <cfif get_emp_ssk.is_46486 eq 1>selected</cfif>>46486</option>
                                            <option value="56486" <cfif get_emp_ssk.is_56486 eq 1>selected</cfif>>56486</option>
                                            <option value="66486" <cfif get_emp_ssk.is_66486  eq 1>selected</cfif>>66486 </option>
                                            <option value="68750" <cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'68750')>selected</cfif>>687 (%50)</option>
                                            <option value="687100" <cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'687100')>selected</cfif>>687 (%100)</option>
                                            <option value="17103" <cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'17103')>selected</cfif>>17103 (<cf_get_lang dictionary_id='45435.İmalat ve Bilişim'>)</option>
                                            <option value="27103" <cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'27103')>selected</cfif>>27103 (<cf_get_lang dictionary_id='45430.Diğer Sektörler'>)</option>
                                            <option value="37103" disabled="disabled" <cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'37103')>selected</cfif>>37103 (<cf_get_lang dictionary_id='45618.Bir Senden Bir Benden'>)</option>
                                            <option value="ARGE80"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'ARGE80')>selected</cfif>><cf_get_lang dictionary_id='59684.ARGE'> 5746 (% 80)</option>
                                            <option value="ARGE90"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'ARGE90')>selected</cfif>><cf_get_lang dictionary_id='59684.ARGE'> 5746 (% 90)</option>
                                            <option value="ARGE95"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'ARGE95')>selected</cfif>><cf_get_lang dictionary_id='59684.ARGE'> 5746 (% 95)</option>
                                            <option value="ARGE100"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'ARGE100')>selected</cfif>><cf_get_lang dictionary_id='59684.ARGE'> 5746 (% 100)</option>
                                            <option value="7252"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'7252')>selected</cfif>>7252</option>
                                            <option value="17256"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'17256')>selected</cfif>>17256</option>
                                            <option value="27256"<cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'27256')>selected</cfif>>27256</option>
                                            <option value="3294" <cfif len(get_emp_ssk.law_numbers) and listfindnocase(get_emp_ssk.law_numbers,'3294')>selected</cfif>>3294 (<cf_get_lang dictionary_id='63611.Sosyal Yardım'>)</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <cfif listfindnocase(get_emp_ssk.law_numbers,'17103') or listfindnocase(get_emp_ssk.law_numbers,'27103') or listfindnocase(get_emp_ssk.law_numbers,'37103')><cfset style_= "display:;"><cfelse><cfset style_= "display:none;"></cfif>
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id="59685.Yararlanacağı Ay"></cfsavecontent>
                                <div class="form-group" id="item-form_ul_7103" style="<cfoutput>#style_#</cfoutput>">
                                    <label class="col col-4 col-xs-12" id="7103_content"><cfoutput>#header_#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="benefit_month_7103" id="benefit_month_7103" style="width:50px;">
                                            <option value=""><cf_get_lang dictionary_id='58724.Ay'></option>
                                            <cfoutput>
                                                <cfloop index="m" from="1" to="18">
                                                    <option value="#m#" <cfif (len(get_emp_ssk.benefit_month_7103) and get_emp_ssk.benefit_month_7103 eq m) or (not len(get_emp_ssk.benefit_month_7103) and 18 eq m)>selected</cfif>>#m#</option>
                                                </cfloop>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <!--- 7256 Kısa Çalışma Esma R. Uysal --->
                                <cfif listfindnocase(get_emp_ssk.law_numbers,'7252')><cfset style_7252= "display:;"><cfelse><cfset style_7252= "display:none;"></cfif>
                                <cfsavecontent variable="header_">Yararlanacağı Gün</cfsavecontent>
                                <div class="form-group" id="item-form_ul_7252" style="<cfoutput>#style_7252#</cfoutput>">
                                    <label class="col col-4 col-xs-12" id="7252_content"><cfoutput>#header_#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <select name="benefit_day_7252" id="benefit_day_7252" style="width:50px;">
                                            <option value=""><cf_get_lang dictionary_id='57490.gün'></option>
                                            <cfoutput>
                                                <cfloop index="m" from="1" to="30">
                                                    <option value="#m#"  <cfif (len(get_emp_ssk.benefit_day_7252) and get_emp_ssk.benefit_day_7252 eq m)>selected</cfif>>#m#</option>
                                                </cfloop>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <!--- 7256  İstihdama Dönüş Kanunu Esma R. Uysal --->
                                <cfif listfindnocase(get_emp_ssk.law_numbers,'17256') or listfindnocase(get_emp_ssk.law_numbers,'27256')><cfset style_7256= "display:;"><cfelse><cfset style_7256= "display:none;"></cfif>
                                <div class="form-group" id="item-form_ul_7256" style="<cfoutput>#style_7256#</cfoutput>">
                                    <label class="col col-4 col-xs-12" id="7256_header">7256 <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <cfsavecontent variable="header_">7256 <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_">7256 <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                            <cfsavecontent variable="message">7256 <cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
                                            <cfinput type="text" name="startdate_7256" value="#dateformat(get_emp_ssk.startdate_7256,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate_7256"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-form_ul_finish_7256" style="<cfoutput>#style_7256#</cfoutput>">
                                    <label class="col col-4 col-xs-12" id="7256_finish_header">7256 <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <cfsavecontent variable="header_">7256 <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_">7256 <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                            <cfsavecontent variable="message">7256 <cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
                                            <cfinput type="text" name="finishdate_7256" value="#dateformat(get_emp_ssk.finishdate_7256,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate_7256"></span>
                                        </div>
                                    </div>
                                </div>

                                <cfsavecontent variable="header_">687 <cf_get_lang dictionary_id='59686.Teşviği'></cfsavecontent>
                                <div class="form-group" id="item-form_ul_gv_687" <cfif listfindnocase(get_emp_ssk.law_numbers,'68750') or listfindnocase(get_emp_ssk.law_numbers,'687100')>style="display:;"<cfelse>style="display:none;"</cfif>>
                                    <label class="col col-4 col-xs-12" id="687_content"><cfoutput>#header_#</cfoutput></label>
                                    <div class="col col-8 col-xs-12">
                                        <input type="checkbox" name="is_tax_free_687" id="is_tax_free_687" value="1" <cfif (listfindnocase(get_emp_ssk.law_numbers,'68750') or listfindnocase(get_emp_ssk.law_numbers,'687100')) and get_emp_ssk.is_tax_free_687 eq 1> checked</cfif>> <cf_get_lang dictionary_id='59687.Gelir ve Damga Vergisinden Muaf'>
                                    </div>
                                </div>
                                
                                <div class="form-group" id="item-form_ul_date_6645">
                                    <cfsavecontent variable="header_">6645 <cf_get_lang dictionary_id='58690.Tarih Aralığı'></cfsavecontent>
                                    <label class="col col-4 col-xs-12"><cfoutput>#header_#</cfoutput></label>
                                    <div  class="col col-2 col-xs-12">
                                        <select name="start_mon_6645" id="start_mon_6645">
                                            <cfloop from="1" to="12" index="i">
                                                <cfoutput>
                                                    <option value="#i#" <cfif (len(get_emp_ssk.start_mon_6645) and get_emp_ssk.start_mon_6645 eq i) or (not len(get_emp_ssk.start_mon_6645) and month(now()) eq i)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <span class="input-group-addon no-bg"></span>
                                    <div class="col col-2 col-xs-12">
                                        <select name="start_year_6645" id="start_year_6645">
                                            <cfloop from="#year(now())-3#" to="#year(now())+3#" index="i">
                                                <cfoutput>
                                                    <option value="#i#" <cfif (len(get_emp_ssk.start_year_6645) and get_emp_ssk.start_year_6645 eq i) or (not len(get_emp_ssk.start_year_6645) and year(now()) eq i)>selected</cfif>>#i#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <div class="col col-2 col-xs-12">
                                        <select name="end_mon_6645" id="end_mon_6645">
                                            <cfloop from="1" to="12" index="i">
                                                <cfoutput>
                                                    <option value="#i#" <cfif (len(get_emp_ssk.end_mon_6645) and get_emp_ssk.end_mon_6645 eq i) or (not len(get_emp_ssk.end_mon_6645) and month(now()) eq i)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                    <span class="input-group-addon no-bg"></span>
                                    <div class="col col-2 col-xs-12">
                                        <select name="end_year_6645" id="end_year_6645">
                                            <cfloop from="#year(now())-3#" to="#year(now())+3#" index="i">
                                                <cfoutput>
                                                    <option value="#i#" <cfif (len(get_emp_ssk.end_year_6645) and get_emp_ssk.end_year_6645 eq i) or (not len(get_emp_ssk.end_year_6645) and year(now()) eq i)>selected</cfif>>#i#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                </div>
                                </div>
                                <div class="form-group" id="item-6111_header"  <cfif isdefined("get_emp_ssk.law_numbers") and (listfindnocase(get_emp_ssk.law_numbers,'6111'))>style="display:;"<cfelse>style="display:none;"</cfif>>
                                    <label class="col col-4 col-xs-12" id="6111_content">6111 <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <cfsavecontent variable="header_">6111 <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message">6111 Tarihi Hatalı!</cfsavecontent>
                                            <cfinput type="text" name="date_6111" style="width:65px;" value="#dateformat(get_emp_ssk.DATE_6111,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="date_6111"></span>
                                            <span class="input-group-addon"><select name="date_6111_select" id="date_6111_select">
                                                <option value=""><cf_get_lang dictionary_id='58724.Ay'></option>
                                                <cfoutput>
                                                    <cfloop index="aaa" from="1" to="50">
                                                        <option value="#aaa#" <cfif isdefined("get_emp_ssk.date_6111_select") and get_emp_ssk.date_6111_select eq aaa>selected</cfif>>#aaa#</option>
                                                    </cfloop>
                                                </cfoutput>
                                            </select></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-5746_content" <cfif isdefined("get_emp_ssk.law_numbers") and (listfindnocase(get_emp_ssk.law_numbers,'574680') or listfindnocase(get_emp_ssk.law_numbers,'574690') or listfindnocase(get_emp_ssk.law_numbers,'5746100')or listfindnocase(get_emp_ssk.law_numbers,'574695'))>style="display:'';"<cfelse>style="display:none;"</cfif>>
                                    <label class="col col-4 col-xs-12" id="5746_header">5746 <cf_get_lang dictionary_id='53477.Günü'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_">5746 <cf_get_lang dictionary_id='53477.Günü'></cfsavecontent>
                                        <select name="days_5746" id="days_5746" >
                                            <option value="">5746 <cf_get_lang dictionary_id='53477.Günü'></option>
                                            <cfloop from="0" to="31" index="ccc">
                                                <cfoutput>
                                                    <option value="#ccc#" <cfif get_emp_ssk.days_5746 eq ccc>selected</cfif>>#ccc#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-4691_content" <cfif isdefined("get_emp_ssk.law_numbers") and listfindnocase(get_emp_ssk.law_numbers,'4691')>style="display:'';"<cfelse>style="display:none;"</cfif>>
                                    <label class="col col-4 col-xs-12" id="4691_header">4691 <cf_get_lang dictionary_id='53477.Günü'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfsavecontent variable="header_">4691 <cf_get_lang dictionary_id='53477.Günü'></cfsavecontent>
                                        <select name="days_4691" id="days_4691" >
                                            <option value="">4691 <cf_get_lang dictionary_id='53477.Günü'></option>
                                            <cfloop from="1" to="31" index="ccc">
                                                <cfoutput>
                                                    <option value="#ccc#" <cfif get_emp_ssk.days_4691 eq ccc>selected</cfif>>#ccc#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-5763_content" <cfif isdefined("get_emp_ssk.date_5763") and len(get_emp_ssk.date_5763)>style="display:'';"<cfelse>style="display:none;"</cfif>>
                                    <label class="col col-4 col-xs-12" id="5763_header">5763 <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <cfsavecontent variable="header_">6111 <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="header_">5763 <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                            <cfsavecontent variable="message">5763 <cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
                                            <cfinput type="text" name="date_5763" style="width:65px;" value="#dateformat(get_emp_ssk.date_5763,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="date_5763"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </cf_box_elements>
                    <cfoutput>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='62870.Officer'></cfsavecontent>
                        <div style="#iif(get_emp_ssk.use_ssk neq 2,DE('display:none'),DE(''))#" id="officer_seperator">
                            <cf_seperator header="#message#" id="officer_div" is_designer="1" index="14">
                            <div class="ui-form-list row" type="row" id="officer_div">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="15" sort="true">
                                    <div class="form-group" id="item-grade_normal">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='54179.Degree'> / <cf_get_lang dictionary_id='58710.Level'></label>
                                        <div class="col col-2 col-xs-12">
                                            <input type="number" name="grade_normal" id="grade_normal" value="#get_emp_ssk.grade_normal#" min="1" max="15" onKeyUp="isNumber(this);">
                                        </div>
                                        <div class="col col-2 col-xs-12">
                                            <input type="number" name="step_normal" id="step_normal" value="#get_emp_ssk.step_normal#" min="1" max="9" onKeyUp="isNumber(this);">
                                        </div>
                                        <div class="col col-2 col-xs-12">
                                            <input type="number" class="moneybox"  name="step_normal_div" id="step_normal_div" value="" disabled>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-grade">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='33549.Retirement'> <cf_get_lang dictionary_id='54179.Degree'> / <cf_get_lang dictionary_id='58710.Level'></label>
                                        <div class="col col-2 col-xs-12">
                                            <input type="number" name="grade" id="grade" value="#get_emp_ssk.grade#" min="1" max="15" onKeyUp="isNumber(this);">
                                        </div>
                                        <div class="col col-2 col-xs-12">
                                            <input type="number" name="step" id="step" value="#get_emp_ssk.step#" min="1" max="9" onKeyUp="isNumber(this);">
                                        </div>
                                        <div class="col col-2 col-xs-12">
                                            <input type="number" class="moneybox"  name="step_div" id="step_div" value="" disabled>
                                        </div>
                                    </div>
                                     <div class="form-group" id="item-additional_score_normal">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'></div>
                                                <input type="text" name="additional_score_normal" value="#TLFormat(get_emp_ssk.additional_score_normal)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-additional_score">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='33549.Retirement'> <cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='33549.Retirement'> <cf_get_lang dictionary_id='62877.Ek Gösterge Puanı'></div>
                                                <input type="text" name="additional_score" value="#TLFormat(get_emp_ssk.additional_score)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-perquisite_score">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62878.Yan Ödeme Puanı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='63983.Yan Ödeme Puan Dağılımlarını Girmelisiniz'>!</div>
                                                <input type="text" name="perquisite_score" id="perquisite_score" value="#TLFormat(get_emp_ssk.perquisite_score)#" class="moneybox" onkeyup="return(formatcurrency(this,event));" readonly>
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-language_allowance">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63967.Yan Ödeme Puan Dağılımları'></label>
                                    </div>
                                    <div class="form-group" id="item-work_difficulty">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63962.İş Güçlüğü'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='63962.İş Güçlüğü'></div>
                                                <input type="text" name="work_difficulty" value="#TLFormat(get_emp_ssk.work_difficulty)#" onchange="sum_perquisite_score()" data-id="perqisite_" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-business_risk_emp">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63963.İş Riski'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='63963.İş Riski'></div>
                                                <input type="text" name="business_risk_emp" value="#TLFormat(get_emp_ssk.business_risk_emp)#" class="moneybox" onkeyup="return(formatcurrency(this,event));" onchange="sum_perquisite_score()" data-id="perqisite_">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-jul_difficulties">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63964.Teminde Güçlük'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='63964.Teminde Güçlük'></div>
                                                <input type="text" name="jul_difficulties" value="#TLFormat(get_emp_ssk.jul_difficulties)#" class="moneybox" onkeyup="return(formatcurrency(this,event));" onchange="sum_perquisite_score()" data-id="perqisite_">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-financial_responsibility">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63966.Mali Sorumluluk'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='63966.Mali Sorumluluk'></div>
                                                <input type="text" name="financial_responsibility" value="#TLFormat(get_emp_ssk.financial_responsibility)#" class="moneybox" onkeyup="return(formatcurrency(this,event));" onchange="sum_perquisite_score()" data-id="perqisite_">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    </cfoutput>
                                    <div class="form-group" id="item-language_allowance_">
                                        <cfset get_component = createObject("component","V16.settings.cfc.language_allowance")>
                                        <cfset get_setup_language_list = get_component.GET_SETUP_LANGUAGE_ALLOWANCE()>
                                        <cfset get_setup_language_name = get_component.GET_SETUP_LANGUAGE_NAME()>
                                        <cfif get_setup_language_name.recordcount gt 5>
                                            <cfset max_lang_row = 5>
                                        <cfelse>
                                            <cfset max_lang_row = get_setup_language_name.recordcount>
                                        </cfif>
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62883.Dil Tazminatı'></label>
                                    </div>
                                    <cfloop index = "lang_indx" from = "1" to = "#max_lang_row#">
                                        <div class="form-group" id="item-language_allowance_row">
                                            <label style="display:none;" class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62883.Dil Tazminatı'><cfoutput>#lang_indx#</cfoutput></label>
                                            <div class="col col-6 col-xs-12">
                                                <select name = "<cfoutput>language_id_#lang_indx#</cfoutput>" id = "language_id" >
                                                    <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                    <cfoutput query="get_setup_language_name">
                                                        <option value="#LANGUAGE_ID#" <cfif evaluate("get_emp_ssk.language_id_#lang_indx#") eq LANGUAGE_ID>selected</cfif>>#LANGUAGE_SET#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                            <div class="col col-6 col-xs-12">
                                                <cfif get_setup_language_list.recordcount gt 0>
                                                    <select name = "<cfoutput>language_allowance_#lang_indx#</cfoutput>" id  = "<cfoutput>language_allowance_#lang_indx#</cfoutput>">
                                                        <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfoutput query = "get_setup_language_list" group="LANGUANGE_STATUE">
                                                            <cfif get_setup_language_list.LANGUANGE_STATUE eq 1>
                                                                <cfsavecontent  variable="title_">
                                                                    <cf_get_lang dictionary_id='62897.Yabancı dilden faydalanılması durumunda'>
                                                                </cfsavecontent>
                                                            <cfelse>
                                                                <cfsavecontent  variable="title_">
                                                                    <cf_get_lang dictionary_id='62901.Yabancı dilden faydalanılmadığı durumda'>
                                                                </cfsavecontent>
                                                            </cfif>
                                                            <optgroup label="#title_#">
                                                                <cfoutput>
                                                                    <option value="#LANGUAGE_ALLOWANCE_ID#" <cfif evaluate("get_emp_ssk.language_allowance_#lang_indx#") eq LANGUAGE_ALLOWANCE_ID>selected</cfif>>#get_setup_language_list.LANGUAGE_LEVEL#</option>
                                                                </cfoutput>
                                                            </optgroup>
                                                        </cfoutput>
                                                    </select>
                                                <cfelse>
                                                    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_language_allowance" target="_blank"><cf_get_lang dictionary_id='63764.Yabancı Dil Tazminatı Gösterge Rakamlarını Tanımlayınız!'></a>
                                                </cfif>
                                            </div>
                                        </div>
                                    </cfloop>
                                    <div class="form-group" id="item-is_education_allowance">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63282.Eğitim Öğretim Ödeneği'></label>
                                        <div class="col col-6 col-xs-12">
                                            <select name = "is_education_allowance">
                                                <option value = "0" <cfif get_emp_ssk.is_education_allowance eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                                                <option value = "1" <cfif get_emp_ssk.is_education_allowance eq 1>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-is_penance_deduction">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64057.kefalet Kesintisi'></label>
                                        <div class="col col-6 col-xs-12">
                                            <select name = "is_penance_deduction">
                                                <option value = "0" <cfif get_emp_ssk.is_penance_deduction eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                                                <option value = "1" <cfif get_emp_ssk.is_penance_deduction eq 1>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-is_audit_compensation">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64065.Denetim Tazminatı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <select name = "is_audit_compensation" id="is_audit_compensation">
                                                <option value = "0" <cfif get_emp_ssk.is_audit_compensation eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                                                <option value = "1" <cfif get_emp_ssk.is_audit_compensation eq 1>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-audit_compensation_div" <cfif get_emp_ssk.is_audit_compensation neq 1>style="display:none"</cfif>>
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64066.Denetim Tazminatı Puanı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <cfinput type="text" name="audit_compensation" value="#TLFormat(get_emp_ssk.audit_compensation)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                        </div>
                                    </div>
                                <cfoutput>
                                </div>

                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="16" sort="true">
                                    <div class="form-group" id="item-is_suspension" <cfif get_emp_ssk.use_ssk neq 2>style="display:none"</cfif>>
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64122.Açığa Alma'></label>
                                        <div class="col col-6 col-xs-12">
                                            <input type="checkbox" name="is_suspension" id="is_suspension" value="1"<cfif get_emp_ssk.is_suspension eq 1>checked</cfif> onchange="open_suspension_dates(this.value)"><cf_get_lang dictionary_id='64122.Açığa Alma'>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-is_suspension_dates" <cfif (get_emp_ssk.use_ssk neq 2 and get_emp_ssk.is_suspension neq 1) or (get_emp_ssk.use_ssk eq 2 and get_emp_ssk.is_suspension neq 1)>style="display:none"</cfif>>
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64122.Açığa Alma'> <cf_get_lang dictionary_id='30913.Start - End'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="col col-6 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
                                                    <cfinput type="text" name="suspension_startdate" value="#dateFormat(get_emp_ssk.suspension_startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="suspension_startdate"></span>
                                                </div>
                                            </div>
                                            <div class="col col-6 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='56704.Tarihi Hatalı'>!</cfsavecontent>
                                                    <cfinput type="text" name="suspension_finishdate" value="#dateFormat(get_emp_ssk.suspension_finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="suspension_finishdate"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-is_veteran">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64163.Gazi'></label>
                                        <div class="col col-6 col-xs-12">
                                            <input type="checkbox" name="is_veteran" id="is_veteran" value="1"<cfif get_emp_ssk.is_veteran eq 1>checked</cfif> onchange="open_suspension_dates(this.value)"><cf_get_lang dictionary_id='64163.Gazi'>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-jury_membership">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64673.Jüri Üyeliği'></label>
                                        <div class="col col-6 col-xs-12">
                                            <input type="checkbox" name="jury_membership" id="jury_membership" value="1"<cfif get_emp_ssk.jury_membership  eq 1>checked</cfif> onchange="open_jury_membership_period(this.value)"><cf_get_lang dictionary_id='64673.Jüri Üyeliği'>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-jury_membership_period">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64674.Jüri Üyeliği Katsayı Dönemi'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="col col-6 col-xs-12">
                                                <select name = "jury_membership_period" id = "jury_membership_period">
                                                    <option value=""><cf_get_lang dictionary_id='48567.Dönem Seçiniz'></option>
                                                    <cfloop query="get_factor_definition_all">
                                                        <option value="#get_factor_definition_all.id#" <cfif get_emp_ssk.jury_membership_period eq get_factor_definition_all.id>selected</cfif>>#dateformat(get_factor_definition_all.startdate,dateformat_style)# - #dateformat(get_factor_definition_all.finishdate,dateformat_style)#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                            <div class="col col-6 col-xs-12">
                                                <input type="number" name="jury_number" id="jury_number" value="#get_emp_ssk.jury_number#" min="1" max="30" onKeyUp="isNumber(this);">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-retired_registry_no">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63673.Emekli Sicil No'></label>
                                        <div class="col col-6 col-xs-12">
                                            <cfinput type="text" name="retired_registry_no" id="retired_registry_no" value="#get_emp_ssk.retired_registry_no#" maxlength="50">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-land_compensation_score">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='64567.Arazi Tazminatı Puanı'> / <cf_get_lang dictionary_id='53379.Dönemi'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="col col-6 col-xs-12">
                                                <input type="text" name="land_compensation_score" id="land_compensation_score" value="#TLFormat(get_emp_ssk.land_compensation_score)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                            </div>
                                            <div class="col col-6 col-xs-12">
                                                <select name = "land_compensation_period" id = "land_compensation_period">
                                                    <option value=""><cf_get_lang dictionary_id='48567.Dönem Seçiniz'></option>
                                                    <cfloop query="get_factor_definition_all">
                                                        <option value="#get_factor_definition_all.id#" <cfif get_emp_ssk.land_compensation_period eq get_factor_definition_all.id>selected</cfif>>#dateformat(get_factor_definition_all.startdate,dateformat_style)# - #dateformat(get_factor_definition_all.finishdate,dateformat_style)#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-executive_compensation_indicator_score">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62879.Makam Tazminatı Gösterge Puanı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='62879.Makam Tazminatı Gösterge Puanı'></div>
                                                <input type="text" name="executive_compensation_indicator_score" value="#TLFormat(get_emp_ssk.executive_indicator_score)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-administrative_compensation_indicator_score">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62880.Görev Tazminatı Gösterge Puanı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='62880.Görev Tazminatı Gösterge Puanı'></div>
                                                <input type="text" name="administrative_compensation_indicator_score" value="#TLFormat(get_emp_ssk.administrative_indicator_score)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-private_service_score">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62881.Özel Hizmet Tazminatı Gösterge Puanı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='62881.Özel Hizmet Tazminatı Gösterge Puanı'></div>
                                                <input type="text" name="private_service_score" value="#TLFormat(get_emp_ssk.private_service_score)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-severance_pension_score">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63970.Kıdem Aylığı Puanı'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='63970.Kıdem Aylığı Puanı'></div>
                                                <input type="text" name="severance_pension_score" id="severance_pension_score" value="#TLFormat(get_emp_ssk.severance_pension_score)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-administrative_function_allowance">
                                        <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62882.İdari Görev Ödeneği'> - <cf_get_lang dictionary_id='58456.Oran'></label>
                                        <div class="col col-6 col-xs-12">
                                            <div class="input-group">
                                                <div class="input-group_tooltip"><cf_get_lang dictionary_id='62882.İdari Görev Ödeneği'> - <cf_get_lang dictionary_id='58456.Oran'> %</div>
                                                <input type="text" name="administrative_function_allowance" value="#TLFormat(get_emp_ssk.administrative_function_allowance)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                <span class="input-group-addon icon-question input-group-tooltip"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <cfif x_university eq 1>
                                        <div class="form-group" id="item-university_allowance" >
                                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62884.Ünversite Ödeneği'> - <cf_get_lang dictionary_id='58456.Oran'> %</label>
                                            <div class="col col-6 col-xs-12">
                                                <div class="input-group">
                                                    <div class="input-group_tooltip"><cf_get_lang dictionary_id='62884.Ünversite Ödeneği'> - <cf_get_lang dictionary_id='58456.Oran'> %</div>
                                                    <input type="text" name="university_allowance" value="#TLFormat(get_emp_ssk.university_allowance)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-academic_incentive_allowance">
                                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62936.Akademik Teşvik Ödeneği'></label>
                                            <div class="col col-6 col-xs-12">
                                                <div class="input-group">
                                                    <div class="input-group_tooltip"><cf_get_lang dictionary_id='62936.Akademik Teşvik Ödeneği'></div>
                                                    <input type="text" name="academic_incentive_allowance" value="#TLFormat(get_emp_ssk.academic_incentive_allowance)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-high_education_compensation">
                                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62937.Yüksek Öğretim Tazminatı'> %</label>
                                            <div class="col col-6 col-xs-12">
                                                <div class="input-group">
                                                    <div class="input-group_tooltip"><cf_get_lang dictionary_id='62937.Yüksek Öğretim Tazminatı'></div>
                                                    <input type="text" name="high_education_compensation" value="#TLFormat(get_emp_ssk.HIGH_EDUCATION_COMPENSATION)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-additional_indicator_compensation">
                                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='63812.Ek Ödeme Tazminatı'></label>
                                            <div class="col col-6 col-xs-12">
                                                <div class="input-group">
                                                    <div class="input-group_tooltip"><cf_get_lang dictionary_id='63812.Ek Ödeme Tazminatı'></div>
                                                    <input type="text" name="additional_indicator_compensation" value="#TLFormat(get_emp_ssk.additional_indicator_compensation)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-minimum_course_hours ">
                                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='62885.Minimum Ders Saati'></label>
                                            <div class="col col-6 col-xs-12">
                                                <div class="input-group">
                                                    <div class="input-group_tooltip"><cf_get_lang dictionary_id='62885.Minimum Ders Saati'></div>
                                                    <input type="text" name="minimum_course_hours" value="#get_emp_ssk.minimum_course_hours#" >
                                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-additional_course_position">
                                            <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='55441.Kadro'></label>
                                            <div class="col col-6 col-xs-12">
                                                <div class="input-group">
                                                    <div class="input-group_tooltip"><cf_get_lang dictionary_id='55441.Kadro'></div>
                                                    <select name = "additional_course_position" id = "additional_course_position" >
                                                        <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <option value="1" <cfif get_emp_ssk.additional_course_position eq 1>selected</cfif>><cf_get_lang dictionary_id='63391.Profesör'></option>
                                                        <option value="2" <cfif get_emp_ssk.additional_course_position eq 2>selected</cfif>><cf_get_lang dictionary_id='63392.Doçent'></option>
                                                        <option value="3" <cfif get_emp_ssk.additional_course_position eq 3>selected</cfif>><cf_get_lang dictionary_id='63393.Yardımcı Doçent'></option>
                                                        <option value="4" <cfif get_emp_ssk.additional_course_position eq 4>selected</cfif>><cf_get_lang dictionary_id='63394.Öğretim Görevlisi'></option>
                                                        <option value="5" <cfif get_emp_ssk.additional_course_position eq 5>selected</cfif>><cf_get_lang dictionary_id='63395.Okutman'></option>
                                                        <option value="6" <cfif get_emp_ssk.additional_course_position eq 6>selected</cfif>><cf_get_lang dictionary_id='64061.Araştırma Görevlisi'></option> 
                                                    </select>
                                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='62888.Döner Sermaye'></cfsavecontent>
                        <div <cfif get_emp_ssk.use_ssk neq 2>style="display:none"</cfif> id="circulating_capital_seperator">
                            <cf_seperator header="#message#" id="circulating_capital__div" is_designer="1" index="17">
                            <div class="ui-form-list row" type="row"  id="circulating_capital__div">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="18" sort="true">
                                    <div class="form-group" id="item-director_Share">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62889.Yönetici Payı'> %</label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="text" name="director_Share" id="director_Share" value="#TLFormat(get_emp_ssk.director_Share)#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-employee_share">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41148.Employee Share'> %</label>
                                        <div class="col col-8 col-xs-12">
                                            <select name = "employee_share" id  = "employee_share">
                                                <option value="0" <cfif get_emp_ssk.employee_share eq 0>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="1" <cfif get_emp_ssk.employee_share eq 1>selected</cfif>><cf_get_lang dictionary_id='62890.Proje Bazlı Paylaşım'></option>
                                                <option value="2" <cfif get_emp_ssk.employee_share eq 2>selected</cfif>><cf_get_lang dictionary_id='62891.Zaman Harcamasına Göre'></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfoutput>  
                    <cfif attributes.sal_year lt 2011>
                        <cf_box_elements>
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="19" type="column" sort="false">
                                <div class="form-group" id="div_ozel_gider_indirim_table">
                                    <label class="col col-12 bold"><a href="javascript://" onclick="gizle_goster(ozel_gider_indirim_table);"><cf_get_lang dictionary_id="53547.Özel Gider İndirim Alanları"></a></label>
                                    <div class="col col-12" id="ozel_gider_indirim_table" style="display:none;">
                                        <table >
                                            <tr>
                                                <td><cf_get_lang dictionary_id='53567.Özel Gider İndirim Matrahı'></td>
                                                <td><cfinput name="ozel_gider_indirim" value="#TLFormat(get_emp_ssk.ozel_gider_indirim)#" type="text" onkeyup="return(formatcurrency(this,event));" ></td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang dictionary_id='53577.Özel Gider İnd Harcama Tutarı'></td>
                                                <td><cfinput name="fis_toplam" value="#TLFormat(get_emp_ssk.fis_toplam)#" type="text"  onkeyup="return(formatcurrency(this,event));"></td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang dictionary_id='53568.Özel Gider Vergi Tutarı'></td>
                                                <td><cfinput name="ozel_gider_vergi" value="#TLFormat(get_emp_ssk.ozel_gider_vergi)#" type="text" onkeyup="return(formatcurrency(this,event));" ></td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang dictionary_id='53571.Mahsup Edilen İade Tutarı'></td>
                                                <td><cfinput name="mahsup_iade" value="#TLFormat(get_emp_ssk.mahsup_iade)#" type="text" onkeyup="return(formatcurrency(this,event));" ></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </cf_box_elements>
                    </cfif>  
            </div>
            <cf_box_footer>
                <cf_record_info query_name="get_emp_ssk">
                <cfsavecontent variable="maas_planla"><cf_get_lang dictionary_id='53541.Maaş Planla'></cfsavecontent>   
                <label id="emp_label" style="display:none!important;"></label>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                <cf_workcube_buttons  update_status="0" extraButton="1" extraButtonText="#maas_planla#" extraFunction='MaasPlanla()' >
            </cf_box_footer>             
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function() {
        $(".input-group-tooltip").mouseover(function() {
		    $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().fadeIn("fast");
	    }).mouseout(function() {
		    $( this ).closest("div.input-group").find( ".input-group_tooltip" ).stop().fadeOut("fast");
	    });
		/* working_abroad_open('<cfoutput>#get_emp_ssk.ssk_statute#</cfoutput>'); */
		use_tax_open('<cfoutput>#get_emp_ssk.defection_level#</cfoutput>');
		if(document.getElementById('law_numbers').options[13].selected == false)
			$('#item-form_ul_date_6645').css('display','none');
            
        get_grade_step($("#grade").val(),$("#step").val(),'step_div');
        get_grade_step($("#grade_normal").val(),$("#step_normal").val(),'step_normal_div');
        <cfif x_law_control eq 1>
            law_control();
        </cfif>
        open_jury_check();
        open_jury_membership_period();
    });
    function MaasPlanla()
    {
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_plan_yearly_ssk&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>','','ui-draggable-box-medium');
    }
	function law_number_control()
	{	
		if(document.getElementById('law_numbers').options[5].selected == false)
		{
			document.getElementById('item-6111_header').style.display = 'none';
			document.getElementById('6111_content').style.display = 'none';
		}
		else
		{
			document.getElementById('item-6111_header').style.display = '';
			document.getElementById('6111_content').style.display = '';	
		}
		if(document.getElementById('law_numbers').options[7].selected == true) //5763 (<cf_get_lang no ='1190.Yeni İstihdam'>) checked = true;
		{
			document.getElementById('5763_header').style.display = '';
			document.getElementById('item-5763_content').style.display = '';
		}
		else
		{
			document.getElementById('5763_header').style.display = 'none';
			document.getElementById('item-5763_content').style.display = 'none';
		}
		if(document.getElementById('law_numbers').options[1].selected == true || document.getElementById('law_numbers').options[2].selected == true || document.getElementById('law_numbers').options[3].selected == true || document.getElementById('law_numbers').options[4].selected == true)
		{
			document.getElementById('days_5746').value = "";
			document.getElementById('5746_header').style.display = '';
			document.getElementById('item-5746_content').style.display = '';
		}
		else
		{
			document.getElementById('5746_header').style.display = 'none';
			document.getElementById('item-5746_content').style.display = 'none';
		}
		if(document.getElementById('law_numbers').options[11].selected == true) //4691 gün seçeneği
		{
			document.getElementById('4691_header').style.display = '';
			document.getElementById('item-4691_content').style.display = '';
		}
		else
		{
			document.getElementById('days_4691').value = "";
			document.getElementById('4691_header').style.display = 'none';
			document.getElementById('item-4691_content').style.display = 'none';
		}
		if(document.getElementById('law_numbers').options[13].selected == false)
			$('#item-form_ul_date_6645').css('display','none');
		else
			$('#item-form_ul_date_6645').css('display','');
			
		if(document.getElementById('law_numbers').options[17].selected == true || document.getElementById('law_numbers').options[18].selected == true)
			$('#item-form_ul_gv_687').css('display','');
		else
			$('#item-form_ul_gv_687').css('display','none');
		
		if(document.getElementById('law_numbers').options[19].selected == true || document.getElementById('law_numbers').options[20].selected == true || document.getElementById('law_numbers').options[21].selected == true)
			$('#item-form_ul_7103').css('display','');
		else
			$('#item-form_ul_7103').css('display','none');
        if(document.getElementById('law_numbers').options[26].selected == true )
			$('#item-form_ul_7252').css('display','');
		else
			$('#item-form_ul_7252').css('display','none');
        if(document.getElementById('law_numbers').options[27].selected == true ||  document.getElementById('law_numbers').options[28].selected == true)
		{
            $('#item-form_ul_7256').css('display',''); 
            $('#item-form_ul_finish_7256').css('display','');
        }
		else
        {
            $('#item-form_ul_7256').css('display','none');
            $('#item-form_ul_finish_7256').css('display','none');
        }
			
		kontrol_sayac = 0;
		for (i=document.getElementById('law_numbers').options.length-1; i>=0; i--)
	    {
			if(document.getElementById('law_numbers').options[i].selected == true)
			{
				kontrol_sayac += 1;
			}
		}
		if(kontrol_sayac > 1)
		{
			for (i=document.getElementById('law_numbers').options.length-1; i>=0; i--)	
			{
				document.getElementById('law_numbers').options[i].selected = false;
			}		
			alert("<cf_get_lang dictionary_id ='53987.İki Kanundan Aynı Anda Yararlanamazsınız'>!");
		}
	}
	function getir_kismi_istihdam_gun()
	{
		duty_ = document.getElementById('duty_type').value;
		if(duty_ == '6')
		{
			if(document.getElementById('SALARY_TYPE').value == 0)
			{
				goster(kismi_istihdam_saat_div);
				gizle(kismi_istihdam_gun_div);
				document.getElementById('kismi_istihdam_gun').value = "";
				gizle(taseron_div);
				gizle(taseron_icon);
			}
			else
			{
				gizle(kismi_istihdam_saat_div);
				document.getElementById('kismi_istihdam_saat').value = "";
				goster(kismi_istihdam_gun_div);
				gizle(taseron_div);
				gizle(taseron_icon);
			}
		}
		else if(duty_ == '7')
		{
			gizle(kismi_istihdam_gun_div);
			gizle(kismi_istihdam_saat_div);
			goster(taseron_div);
			goster(taseron_icon);
			document.getElementById('kismi_istihdam_gun').value = "";
			document.getElementById('kismi_istihdam_saat').value = "";
		}
		else
		{
			gizle(kismi_istihdam_gun_div);
			gizle(kismi_istihdam_saat_div);
			gizle(taseron_div);
			gizle(taseron_icon);
			document.getElementById('kismi_istihdam_gun').value = "";
			document.getElementById('kismi_istihdam_saat').value = "";
		}
	}
	function kismi_istihdam_()
	{
		if(document.getElementById('duty_type').value == 6)
		{
			if(document.getElementById('SALARY_TYPE').value == 0)
			{
				goster(kismi_istihdam_saat_div);
				gizle(kismi_istihdam_gun_div);
				document.getElementById('kismi_istihdam_gun').value = "";
			}
			else
			{
				gizle(kismi_istihdam_saat_div);
				goster(kismi_istihdam_gun_div);
				document.getElementById('kismi_istihdam_saat').value = "";
			}
		}
		else
		{
				gizle(kismi_istihdam_saat_div);
				gizle(kismi_istihdam_gun_div);
				document.getElementById('kismi_istihdam_saat').value = "";
				document.getElementById('kismi_istihdam_gun').value = "";
		}

	}
	function kontrol()
	{
		if((document.getElementById('law_numbers').options[1].selected == true || document.getElementById('law_numbers').options[2].selected == true || document.getElementById('law_numbers').options[3].selected == true || document.getElementById('law_numbers').options[4].selected == true) && document.getElementById('days_5746').value == '')
		{
			alert("<cf_get_lang dictionary_id='54598.5746 numaralı kanun için gün seçiniz'>!");
			return false;
		}
		if((document.getElementById('law_numbers').options[11].selected == true) && document.getElementById('days_4691').value == '')
		{
			alert("<cf_get_lang dictionary_id='54595.4691 numaralı kanun için gün seçiniz'>!");
			return false;
		}
		/*	
		if (document.getElementById('law_numbers').options[3].selected == true && document.getElementById('law_numbers').options[4].selected == true)
		{
			alert("6111 ve 5084 kanunları aynı anda kullanılamaz!");
			return false;
		}

		if(document.getElementById('law_numbers').options[4].selected==true && document.getElementById('law_numbers').options[5].selected==true)
		{
			alert("<cf_get_lang no ='1041.İki Kanundan Aynı Anda Yararlanamazsınız'>!");
			return false;
		}*/
		
		if(document.employe_work.old_branch_id.value != document.employe_work.branch_id.value)
		{
			alert("<cf_get_lang dictionary_id='53587.Giriş İşleminin Şubesini Bu Adımda Değiştiremezsiniz'>!\n<cf_get_lang dictionary_id='53588.Çalışan Giriş Çıkışlarından Çıkış İşlemi Yapmalısınız'>!");
			return false;
		}
		
		if ((employe_work.first_ssk_date.value.length != 0) && (employe_work.start_date.value.length != 0))
			if(!date_check(employe_work.first_ssk_date, employe_work.start_date, "<cf_get_lang dictionary_id='53586.İlk SSK lı Oluş Tarihi İşe Başlama Tarihinden Sonra Olamaz'> !"))
				return false;
		
		if(document.getElementById('duty_type').value == 7 && document.getElementById('duty_type_company_id').value == '')
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='54345.Taşeron Şirketi'>");
			return false;
		}
		else if($('#duty_type').val() == 6 )
		{
			if($('#SALARY_TYPE').val() == 0 && $('#kismi_istihdam_saat').val() == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53182.Kısmi istihdam'> <cf_get_lang dictionary_id='57491.saat'>");
				return false;
			}
			else if (($('#SALARY_TYPE').val() == 1 || $('#SALARY_TYPE').val() == 2) && $('#kismi_istihdam_gun').val() == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53182.Kısmi istihdam'> <cf_get_lang dictionary_id='57490.gün'>");
				return false;
			}
        }
        if($('#defection_rate').val() != '' && ( $('#defection_rate').val() < 0 ||  $('#defection_rate').val() > 100))
        {
            alert("<cf_get_lang dictionary_id='38275.0-100 arası değer giriniz'>");
            return false;
        }
        
        if($('#land_compensation_score').val() != '' && $('#land_compensation_period').val() == '')
        {
            alert("<cf_get_lang dictionary_id='64568.Arazi Tazminatı Dönemi Seçiniz'>!");
            return false;
        }
        partial_time = filterNum(employe_work.kismi_istihdam_saat.value);
        partial_work_time_ = filterNum(employe_work.partial_work_hidden.value);
        if(parseFloat(partial_time) > parseFloat(partial_work_time_))
        {
            alert("<cf_get_lang dictionary_id='62280.Kısmi İstihdam Saati Maksimum Alabileceği Değer'> : "+partial_work_time_);
            return false;
        }
		unformatfields();
		process_cat_control();
        //var sub = AjaxFormSubmit('employe_work','emp_label',1,'','','','','true');
        //if(sub)	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.list_salary&event=salary_info&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#</cfoutput>','ajax_right');
       // return false;
	}
	
	function unformatfields()
	{
		employe_work.START_CUMULATIVE_TAX_TOTAL.value = filterNum(employe_work.START_CUMULATIVE_TAX_TOTAL.value);
		employe_work.START_CUMULATIVE_WAGE_TOTAL.value = filterNum(employe_work.START_CUMULATIVE_WAGE_TOTAL.value);
		employe_work.START_CUMULATIVE_TAX.value = filterNum(employe_work.START_CUMULATIVE_TAX.value);
        employe_work.kismi_istihdam_saat.value = filterNum(employe_work.kismi_istihdam_saat.value);
        <cfif show_average_salary eq 1>
            employe_work.monthly_average_net_.value = filterNum(employe_work.monthly_average_net_.value);
        </cfif>
        employe_work.past_agi_day.value = filterNum(employe_work.past_agi_day.value);
        employe_work.land_compensation_score.value = filterNum(employe_work.land_compensation_score.value);

        employe_work.additional_score.value = filterNum(employe_work.additional_score.value);
        employe_work.additional_score_normal.value = filterNum(employe_work.additional_score_normal.value);
        employe_work.perquisite_score.value = filterNum(employe_work.perquisite_score.value);
        employe_work.work_difficulty.value = filterNum(employe_work.work_difficulty.value);
        employe_work.business_risk_emp.value = filterNum(employe_work.business_risk_emp.value);
        employe_work.jul_difficulties.value = filterNum(employe_work.jul_difficulties.value);
        employe_work.financial_responsibility.value = filterNum(employe_work.financial_responsibility.value);
        employe_work.severance_pension_score.value = filterNum(employe_work.severance_pension_score.value);
        employe_work.academic_incentive_allowance.value = filterNum(employe_work.academic_incentive_allowance.value);
        employe_work.university_allowance.value = filterNum(employe_work.university_allowance.value);
        employe_work.high_education_compensation.value = filterNum(employe_work.high_education_compensation.value);
        employe_work.executive_compensation_indicator_score.value = filterNum(employe_work.executive_compensation_indicator_score.value);
        employe_work.administrative_compensation_indicator_score.value = filterNum(employe_work.administrative_compensation_indicator_score.value);
        employe_work.private_service_score.value = filterNum(employe_work.private_service_score.value);
        employe_work.administrative_function_allowance.value = filterNum(employe_work.administrative_function_allowance.value);
        employe_work.director_Share.value = filterNum(employe_work.director_Share.value);
        employe_work.additional_indicator_compensation.value = filterNum(employe_work.additional_indicator_compensation.value);
        employe_work.audit_compensation.value = filterNum(employe_work.audit_compensation.value);

		<cfif attributes.sal_year lt 2011>
			employe_work.ozel_gider_indirim.value = filterNum(employe_work.ozel_gider_indirim.value);
			employe_work.ozel_gider_vergi.value = filterNum(employe_work.ozel_gider_vergi.value);
			employe_work.mahsup_iade.value = filterNum(employe_work.mahsup_iade.value);
			employe_work.fis_toplam.value = filterNum(employe_work.fis_toplam.value);
		</cfif>
        <cfif is_get_FMbilgisi eq 1>
            employe_work.fazla_mesai_saat.value = filterNum(employe_work.fazla_mesai_saat.value);
        </cfif>
	}
	
	function use_tax_open(i)
	{
        if (i == 1 || i == 2 || i == 3)
        {
            $('#form_ul_use_tax').css('display','');
            $('#item-defection_rate').css('display','');
            $('#item-defection_date').css('display','');
        }
		else if (i == 0)
		{
            $('#form_ul_use_tax').css('display','none');          
            /* $('#use_tax').attr('checked',false); */
            $("#defection_rate").val('');
            $('#item-defection_rate').css('display','none');
            $('#item-defection_date').css('display','none');
		}
	}
	
	function working_abroad_open(i)
	{
        if(i == 8 || i == 9)
        {
            $('#is_tax_free').attr('checked',true);
            $('#is_damga_free').attr('checked',true);
            $('#use_tax').attr('checked',true);
        }
    }

    function open_shift_date(i)
    {
        if (i == 1 || i == 2)
        {
			$('#item-form_shift_start').css('display','');
            $('#item-form_shift_finish').css('display','');
        }
		else
		{
			$('#item-form_shift_start').css('display','none');
            $('#item-form_shift_finish').css('display','none');
		}
    }
    
    function open_tab(url,id) {
        document.getElementById(id).style.display ='';	
        document.getElementById(id).style.width ='500px';	
        $("#"+id).css('margin-left',$("#tabMenu").position().left);
        $("#"+id).css('margin-top',$("#tabMenu").position().top);
        $("#"+id).css('position','absolute');	
        
        AjaxPageLoad(url,id,1);
        return false;
    }
    function control_partial(partial_time_)
    {
        partial_time = filterNum(employe_work.kismi_istihdam_saat.value);
        partial_work_time_ = filterNum(employe_work.partial_work_hidden.value);
        if(parseFloat(partial_time) > parseFloat(partial_work_time_))
        {
            alert("<cf_get_lang dictionary_id='62280.Kısmi İstihdam Saati Maksimum Alabileceği Değer'> : "+partial_work_time_);
            return false;
        }
    }
    function change_use_ssk()
    {
        use_ssk_val = $("#use_ssk").val();
        if(use_ssk_val == 2)
        {
            $('#officer_seperator').css('display','');
            $('#circulating_capital_seperator').css('display','');
            $('#item-administrative_academic').css('display','');
            $('#item-is_suspension').css('display','');
            $('#item-is_suspension_dates').css('display','');
            $("#item-business_code").hide();
            $('#item-service_class, #item-service_title, #item-service_title_detail').show();
        }
        else
        {
            $('#officer_seperator').css('display','none');
            $('#circulating_capital_seperator').css('display','none');
            $('#item-administrative_academic').css('display','none');
            $('#item-is_suspension').css('display','none');
            $('#item-is_suspension_dates').css('display','none');
            $("#item-business_code").show();
            $('#item-service_class, #item-service_title, #item-service_title_detail').hide();
        }
    }
    $( "#grade" ).change(function() {
        grade_val = $("#grade").val();
        step_val = $("#step").val();
        if(grade_val > 15 || grade_val < 1)
        {
            alert("<cf_get_lang dictionary_id='62886.'>");
            $("#grade").val("1") ;
        }
        get_grade_step(grade_val,step_val,'step_div');
    });
    $( "#step" ).change(function() {
        grade_val = $("#grade").val();
        step_val = $("#step").val();
        if(step_val > 15 || step_val < 1)
        {
            alert("<cf_get_lang dictionary_id='62887.'>");
            $("#step").val("1") ;
        }
        get_grade_step(grade_val,step_val,'step_div');
    });
    $( "#grade_normal" ).change(function() {
        grade_val = $("#grade_normal").val();
        step_val = $("#step_normal").val();
        if(grade_val > 15 || grade_val < 1)
        {
            alert("<cf_get_lang dictionary_id='62886.'>");
            $("#grade").val("1") ;
        }
        get_grade_step(grade_val,step_val,'step_normal_div');
    });
    $( "#step_normal" ).change(function() {
        grade_val = $("#grade_normal").val();
        step_val = $("#step_normal").val();
        if(step_val > 15 || step_val < 1)
        {
            alert("<cf_get_lang dictionary_id='62887.'>");
            $("#step").val("1") ;
        }
        get_grade_step(grade_val,step_val,'step_normal_div');
    });

    $( "#severance_pension_score" ).change(function() {
        if(filterNum($( this ).val()) > 500)
        {
            alert("<cf_get_lang dictionary_id='63971.Kıdem Aylığı Puanı 500 den büyük olamaz!'>");
            $( this ).val(500);
        }
    });
    
    $('[id="language_id"]').change(function() {

        max_lang_row = '<cfoutput>#max_lang_row#</cfoutput>';
        //alert(max_lang_row);
        for(i = 1;i <= max_lang_row;i++)
        {
            if(($(this).val() == $( "[name='language_id_"+i+"']" ).val()) && ($(this).attr('name') != 'language_id_'+i) && $(this).val() != 0)
            {
                alert("<cf_get_lang dictionary_id='62938.Aynı dili birden çok satırda seçemezsiniz!'>");
                $(this).val(0);
            }
                
        }
        
    });
    function get_grade_step(grade,step,div_id)
    {
        if(grade != 'undefined' && step != 'undefined')
        {
            var listParam = grade + "*" + step;
			var grade_step_val = wrk_safe_query('get_grade_step','dsn',0,listParam);
            column = grade_step_val.columnList;
            $("#"+div_id).val(parseFloat(eval("grade_step_val."+column)));
        }
    }

    function sum_perquisite_score()
    {
        total_perqisite = 0;
        $("input[data-id = perqisite_]").each(function() {
            if($( this ).val()){
                total_perqisite = parseFloat(total_perqisite + parseFloat(filterNum($( this ).val())));
            }
        });

        $("#perquisite_score").val(commaSplit(total_perqisite));

    }

    $( "#is_audit_compensation" ).change(function() {
        if($("#is_audit_compensation").val() == 1){
            $('#item-audit_compensation_div').css('display','');
        }else
        {
            $('#item-audit_compensation_div').css('display','none');
        }
    });
    function law_control()
    {
        if($("#use_ssk").val() == 2)
        {
            listParam = $("#EMPLOYEE_ID").val();
            var get_group_start = wrk_safe_query('get_group_start','dsn',0,listParam);
            x = new Date('2008-10-01');
            y = new Date(get_group_start.GROUP_STARTDATE[0]);
            if(x > y)
            {
                $("#ssk_statute").val(33);
            }else
            {
                $("#ssk_statute").val(1);
            }
        }
    }
    function open_suspension_dates() {
        if( ($('#is_suspension').is(':checked')))
        {
            $('#item-is_suspension_dates').css('display','');
        }
        else
        {
            $('#item-is_suspension_dates').css('display','none');
        }
    }

    function get_service_title(class_id) {
        $("#service_title_detail").attr("value", "");
        $("#service_title").attr("value", "");
		if(class_id != ''){
			var get_service = wrk_query("SELECT SERVICE_TITLE_ID,SERVICE_TITLE,SERVICE_TITLE_CODE FROM SETUP_SERVICE_TITLE WHERE SERVICE_CLASS_ID = " + class_id,"dsn");
			$("#service_title option").remove();
			$("#service_title").append($("<option></option>").attr("value", '').text( "Seçiniz" ));
			if(get_service.recordcount > 0)	
			{
				for(i = 1;i<=get_service.recordcount;++i)
				{
					$("#service_title").append($("<option></option>").attr("value", get_service.SERVICE_TITLE_ID[i-1]).text(get_service.SERVICE_TITLE_CODE[i-1] +" - "+get_service.SERVICE_TITLE[i-1]  ));
					$("#service_title_id").attr("value", get_service.SERVICE_TITLE_ID);
				}
			}
		}
	}

	function get_title_detail(title_id) {
		if(title_id != ''){
			var get_service_detail = wrk_query("SELECT DETAIL FROM SETUP_SERVICE_TITLE WHERE SERVICE_TITLE_ID = " + title_id,"dsn");
			
			if(get_service_detail.recordcount > 0){
				$("#service_title_detail").attr("value", get_service_detail.DETAIL);
			}
		}
		else{
			$("#service_title_detail").attr("value", "");
		}
	}
	$( ".target" ).change(function() {
		
	});
    function open_jury_check()
    {
        if($('#administrative_academic').val() == 1)
        {
            $('#item-jury_membership').css('display','');
        }
        else
        {
            $('#item-jury_membership').css('display','none');
        }
    }
    function open_jury_membership_period()
    {
        if($('#administrative_academic').val() == 1 &&  $('#jury_membership').is(':checked'))
        {
            $('#item-jury_membership_period').css('display','');
        }
        else
        {
            $('#item-jury_membership_period').css('display','none');
        }
    }
</script>