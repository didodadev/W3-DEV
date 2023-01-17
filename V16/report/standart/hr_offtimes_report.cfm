<!--- is bu dosyadaki rapor sube sube olmak kaydiyla son 12 ay icersinde aldiklari ek odenekleri son brut maaslari ve kisisel kidem ve sigorta bilgilerini excel olarak verir--->
<cf_xml_page_edit fuseact='report.hr_offtimes_report'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfsetting showdebugoutput="no">
<cfparam name="attributes.gun_say" default="365">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.pos_cat_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.unit_id" default="">
<cfparam name="attributes.FINISH_DATE_COUNT_TYPE" default="1">
<cfparam name="attributes.emp_status" default="1">
<cfparam name="attributes.gender" default="">
<cfparam name="attributes.ssk_statute" default="">
<cfparam name="attributes.explanation_id" default="">
<cfparam name="attributes.defection_level" default="">

<cfscript>
    cfc = createObject("component","V16.hr.cfc.get_functions");
	cfc.dsn = dsn;
	get_fonc_units = cfc.get_function();
</cfscript>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset get_employee_shift = createObject("component","V16.hr.cfc.get_employee_shift")><!---Vardiya component ---->
<cfquery name="get_work_time" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = 'ehesap.form_add_offtime_popup' AND
		(PROPERTY_NAME = 'start_hour_info' OR
		PROPERTY_NAME = 'start_min_info' OR
		PROPERTY_NAME = 'finish_hour_info' OR
		PROPERTY_NAME = 'finish_min_info' OR
		PROPERTY_NAME = 'finish_am_hour_info' OR
		PROPERTY_NAME = 'finish_am_min_info' OR
		PROPERTY_NAME = 'start_pm_hour_info' OR
		PROPERTY_NAME = 'start_pm_min_info' OR
		PROPERTY_NAME = 'x_min_control'
		)	
</cfquery>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_FeeCalculation = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.popup_form_fire2',
    property_name : 'x_salary_pay_count'
    )
    >
<!--- İzin Süreleri XML'den ayarlanan 'Kaç yıldan itibaren geçmiş günün hesaba katılsın?' parametresi 20191030ERU --->
<cfset get_offtime_old_sgk_year = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.offtime_limit',
    property_name : 'x_old_sgk_days'
)
>
<!--- ehesap izin listeleme xml'i  "İzin Gün Bilgisi Resmi Tatiller ve Haftasonu Tatilleri Düşürülmeden Gelsin" seçeneği 13012020ERU --->
<cfset get_offtime_x_total_offdays_type = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.offtimes',
    property_name : 'x_total_offdays_type'
)
>

<cfif get_offtime_x_total_offdays_type.recordcount>
	<cfset x_total_offdays_type = get_offtime_x_total_offdays_type.PROPERTY_VALUE>
<cfelse>
	<cfset x_total_offdays_type = 1>
</cfif>

<cfif get_work_time.recordcount>
	<cfloop query="get_work_time">	
		<cfif property_name eq 'start_hour_info'>
			<cfset start_hour = property_value>
		<cfelseif property_name eq 'start_min_info'>
			<cfset start_min = property_value>
		<cfelseif property_name eq 'finish_hour_info'>
			<cfset finish_hour = property_value>
		<cfelseif property_name eq 'finish_min_info'>
			<cfset finish_min = property_value>
        <cfelseif PROPERTY_NAME eq 'finish_am_hour_info'>
			<cfset finish_am_hour = PROPERTY_VALUE>
		<cfelseif PROPERTY_NAME eq 'finish_am_min_info'>
			<cfset finish_am_min = PROPERTY_VALUE>
		<cfelseif PROPERTY_NAME eq 'start_pm_hour_info'>
			<cfset start_pm_hour = PROPERTY_VALUE>
		<cfelseif PROPERTY_NAME eq 'start_pm_min_info'>
			<cfset start_pm_min = PROPERTY_VALUE>
		<cfelseif PROPERTY_NAME eq 'x_min_control'>
			<cfset x_min_control = PROPERTY_VALUE>
		</cfif>
	</cfloop>
<cfelse>
	<cfset start_hour = '00'>
	<cfset start_min = '00'>
	<cfset finish_hour = '00'>
	<cfset finish_min = '00'>
</cfif>
<cfif not isdefined("x_min_control")>
    <cfset x_min_control = 0>
</cfif>
<cfif not isdefined("finish_am_hour")>
    <cfset start_hour = '00'>
    <cfset start_min = '00'>
    <cfset finish_hour = '00'>
    <cfset finish_min = '00'>
    <cfset finish_am_hour = '00'>
    <cfset finish_am_min = '00'>
    <cfset start_pm_hour = '00'>
    <cfset start_pm_min = '00'>
</cfif>
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<!--- İzin Süreleri XML'den ayarlanan 'Kaç yıldan itibaren geçmiş günün hesaba katılsın?' parametresi 20191030ERU --->
<cfset get_offtime_old_sgk_year = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.offtime_limit',
    property_name : 'x_old_sgk_days'
    )
    >
<cfif get_offtime_old_sgk_year.recordcount>
	<cfset calc_old_sgk_year = get_offtime_old_sgk_year.property_value>
<cfelse>
	<cfset calc_old_sgk_year = ''>
</cfif>
<!--- E-Profilde 'Geçmiş SGK Günü Girilsin mi?' parametresi 20191030ERU --->
<cfset get_old_sgk_year = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'hr.form_upd_emp',
    property_name : 'xml_old_sgk_days'
    )
    >
<cfset offday_list_ = ''>
<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
<cfset halfofftime_list2 = ''>
<cfset halfofftime_list3 = ''><!--- Bitiş --->
<cfoutput query="get_general_offtimes">
	<cfscript>
		offday_gun = datediff('d',get_general_offtimes.start_date,get_general_offtimes.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, get_general_offtimes.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, get_general_offtimes.finish_date);
		
		for (mck=0; mck lt offday_gun; mck=mck+1)
		{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
			if(not listfindnocase(offday_list_,'#daycode#'))
				offday_list_ = listappend(offday_list_,'#daycode#');
			if(get_general_offtimes.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
			{
				halfofftime_list = listappend(halfofftime_list,'#daycode#');
			}
		}
	</cfscript>
</cfoutput>
<cfquery name="get_hours" datasource="#dsn#">
	SELECT		
		OUR_COMPANY_HOURS.*
	FROM
		OUR_COMPANY_HOURS
	WHERE
		OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
		OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif len(get_hours.recordcount) and len(get_hours.weekly_offday)>
	<cfset this_week_rest_day_ = get_hours.weekly_offday>
<cfelse>
	<cfset this_week_rest_day_ = 1>
</cfif>
<cfquery name="get_progress_payment_outs" datasource="#dsn#">
	SELECT 
		START_DATE,FINISH_DATE,EMP_ID
	FROM 
		EMPLOYEE_PROGRESS_PAYMENT_OUT 
	WHERE 
		START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
UNION ALL
	SELECT 
		STARTDATE AS START_DATE,
		FINISHDATE AS FINISH_DATE,
		EMPLOYEE_ID AS EMP_ID
	FROM 
		OFFTIME,SETUP_OFFTIME 
	WHERE
		(
			(
			ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 AND
			OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
			)
			OR
			OFFTIME.SUB_OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
		) AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		OFFTIME.VALID = 1 AND
		SETUP_OFFTIME.IS_OFFDAY_DELAY = 1
</cfquery>

<cfquery name="get_offtime_limits" datasource="#dsn#">
	SELECT 
		LIMIT_ID,
		<cfloop from="1" to="5" index="i">
		LIMIT_#i#,
		LIMIT_#i#_DAYS,
		</cfloop> 
		MIN_YEARS,
		MAX_YEARS,
		MIN_MAX_DAYS,
		SATURDAY_ON,
		SUNDAY_ON,
		DAY_CONTROL,
		STARTDATE,
		FINISHDATE,
		PUANTAJ_GROUP_IDS,
		DEFINITION_TYPE,
		RECORD_DATE
	FROM 
		SETUP_OFFTIME_LIMIT
</cfquery>
<cfquery name="get_pos_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>

<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.branch_id)>
<cfscript>
	cmp = createObject("component","V16.hr.cfc.get_our_company");
	cmp.dsn = dsn;
	get_our_company = cmp.get_company(is_control : 1);
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(ehesap_control : 1);
</cfscript>
<cfquery name="get_branch" dbtype="query">
    SELECT BRANCH_ID,BRANCH_NAME FROM get_branches WHERE <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            COMPANY_ID IN(#attributes.comp_id#) 
            <cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
        <cfelse>
            1=0
        </cfif> ORDER BY BRANCH_NAME
</cfquery>
<cfset ay_listesi ="Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39254.İzin - Kıdem - İhbar Yükü Raporu'></cfsavecontent>
<cfform name="ara_form" method="post" action="#request.self#?fuseaction=report.hr_offtimes_report">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                        <div class="col col-12 col-md-12 col-xs-12 paddingNone">
                                            <input type="text" name="keyword" id="keyword" value="<cfif len(attributes.keyword)><cfoutput>#attributes.keyword#</cfoutput></cfif>">
                                        </div>					
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <div class="multiselect-z2">
                                                <cf_multiselect_check 
                                                query_name="get_our_company"  
                                                name="comp_id"
                                                option_value="COMP_ID"
                                                option_name="company_name"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.comp_id#"
                                                onchange="get_branch_list(this.value)">
                                            </div>
                                        </div>
                                        					
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <div id="BRANCH_PLACE" class="multiselect-z2">
                                            <cf_multiselect_check 
                                            query_name="get_branch"  
                                            name="branch_id"
                                            option_value="BRANCH_ID"
                                            option_name="BRANCH_NAME"
                                            option_text="#getLang('main',322)#"
                                            value="#attributes.branch_id#"
                                            onchange="get_department_list(this.value)">                                          
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12">&nbsp</label>
                                        <select name="emp_status" id="emp_status">
                                            <option value="0" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 0)>selected</cfif>><cf_get_lang dictionary_id='47833.All Employees'></option>
                                            <option value="1" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='53226.Active Employees'></option>
                                            <option value="-1" <cfif isDefined("attributes.emp_status")and (attributes.emp_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='53859.Employees who left'></option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='65172.Çıkış Gerekçesi'></label>
                                        <select name="explanation_id" id="explanation_id">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfloop list="#reason_order_list()#" index="ccc">
                                                <cfset value_name_ = listgetat(reason_list(),ccc,';')>
                                                <cfset value_id_ = ccc>
                                                <cfoutput><option value="#value_id_#" <cfif attributes.explanation_id eq value_id_>selected</cfif>>#value_name_#</option></cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>                                
                                </div>                                
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                            <div id="DEPARTMENT_PLACE">
                                                <div class="multiselect-z2" id="DEPARTMENT_PLACE">
                                                    <cf_multiselect_check 
                                                    query_name="get_department"  
                                                    name="department"
                                                    option_text="#getLang('main',322)#" 
                                                    option_value="department_id"
                                                    option_name="department_head"
                                                    value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
                                                </div>                                             
                                            </div> 
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                                            <div class="multiselect-z1">
                                                <cf_multiselect_check 
                                                query_name="get_pos_cats"  
                                                name="pos_cat_id"
                                                option_value="POSITION_CAT_ID"
                                                option_name="POSITION_CAT"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.pos_cat_id#">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                                            <div class="input-group">
                                                <cfsavecontent variable="alert2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarih'></cfsavecontent>
                                                <cfinput value="#attributes.finish_date#" type="text" name="finish_date" message="#alert2#" validate="#validate_style#">
                                                <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="finish_date">
                                                </span>
                                            </div>    
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                                            <select name="gender" id="gender">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="0" <cfif attributes.gender eq 0>selected</cfif>><cf_get_lang dictionary_id='58958.Kadın'></option>
                                                <option value="1"<cfif attributes.gender eq 1>selected</cfif>><cf_get_lang dictionary_id='58959.Erkek'></option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38994.Sakatlık Durumu'></label>
                                            <select name="defection_level" id="defection_level">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="0" <cfif attributes.defection_level eq 0>selected</cfif>>
                                                    <cf_get_lang dictionary_id='58546.Yok'>
                                                </option>
                                                <option value="1" <cfif attributes.defection_level eq 1>selected</cfif>>1</option>
                                                <option value="2" <cfif attributes.defection_level eq 2>selected</cfif>>2</option>
                                                <option value="3" <cfif attributes.defection_level eq 3>selected</cfif>>3</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
							</div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id ='55217.Birimler'></label>
                                            <select name="unit_id" id="unit_id">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="get_fonc_units">
                                                    <option value="#unit_id#" <cfif attributes.unit_id eq unit_id>selected</cfif>>#unit_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12">&nbsp</label>
                                            <select name="gun_say" id="gun_say">
                                                <option value="365" <cfif isdefined("attributes.gun_say") and attributes.gun_say eq 365>selected</cfif>>365 <cf_get_lang dictionary_id="39268.Gün Üzerinden"></option>
                                                <option value="360"<cfif isdefined("attributes.gun_say") and attributes.gun_say eq 360>selected</cfif>>360 <cf_get_lang dictionary_id="39268.Gün Üzerinden"></option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12">&nbsp</label>
                                            <select id="FINISH_DATE_COUNT_TYPE" name="FINISH_DATE_COUNT_TYPE">
                                                <option value="0" <cfif attributes.FINISH_DATE_COUNT_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id='54167.Gün Hesabı'></option>
                                                <option value="1" <cfif attributes.FINISH_DATE_COUNT_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="58455.Yıl"> - <cf_get_lang dictionary_id="58724.Ay"> - <cf_get_lang dictionary_id="57490.Gün"></option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='53553.SGK Statüsü'></label>
                                            <select name="ssk_statute" id="ssk_statute">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfset count_ = 0>
                                                <cfloop list="#list_ucret()#" index="ccn">
                                                    <cfset count_ = count_ + 1>
                                                    <cfoutput><option value="#ccn#" <cfif attributes.ssk_statute eq ccn>selected</cfif>>#listgetat(list_ucret_names(),count_,'*')#</option></cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                        <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_submit" id="is_submit" value="1" type="hidden">
                            <cf_wrk_report_search_button button_type='1' is_excel="1" search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>	
<div id ="offtimes_report_excel"> 
<cfif isdefined("attributes.is_submit")>
    <cf_date tarih = "attributes.finish_date">
    <cfset puantaj_gun_ = day(attributes.finish_date)>
    <cfset puantaj_start_ = createdate(year(attributes.finish_date),month(attributes.finish_date),day(attributes.finish_date))>
    <cfset puantaj_finish_ = createodbcdatetime(createdate(year(attributes.finish_date),month(attributes.finish_date),puantaj_gun_))>
    <cfset my_baz_date = puantaj_finish_>
    <cfset attributes.months = month(attributes.finish_date)>
    <cfset attributes.years = year(attributes.finish_date)>
    <cfquery name="get_seniority_comp_max" datasource="#dsn#">
        SELECT ISNULL(SENIORITY_COMPANSATION_MAX,0) AS SENIORITY_COMPANSATION_MAX FROM INSURANCE_PAYMENT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#">
    </cfquery>
    <cfset kidem_max = get_seniority_comp_max.seniority_compansation_max>
    <cfquery name="get_emp" datasource="#dsn#">
        WITH CTE1 AS (
        SELECT 
            E.EMPLOYEE_ID,
            E.EMPLOYEE_NO,
            E.EMPLOYEE_NAME EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
            E.GROUP_STARTDATE,
            ISNULL(E.KIDEM_DATE,0) AS KIDEM_DATE,
            E.IZIN_DATE,
            E.IZIN_DAYS,
            E.OLD_SGK_DAYS,
            D.DEPARTMENT_HEAD,
            B.BRANCH_NAME,
            B.RELATED_COMPANY,
            EI.START_DATE START_DATE,
            EI.FINISH_DATE,
            EI.FIRST_SSK_DATE,
            EI.SOCIALSECURITY_NO,
            EI.SSK_STATUTE,
            EI.GROSS_NET,
            EI.BRANCH_ID,
            EI.IN_OUT_ID,
            EI.SALARY_TYPE,
            EI.PUANTAJ_GROUP_IDS,
            EII.TC_IDENTY_NO,
            EII.BIRTH_DATE,
            EXPLANATION_ID,
            DATEDIFF(DD,E.KIDEM_DATE,GETDATE()) AS Kıdem_gun,
            ED.SEX,
            EI.DEFECTION_LEVEL,
            D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
            CASE 
                WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
            THEN	
                D.HIERARCHY_DEP_ID
            ELSE 
                CASE WHEN 
                    D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
                THEN
                    (SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                ELSE
                    D.HIERARCHY_DEP_ID
                END
            END AS HIERARCHY_DEP_ID,
            (SELECT TOP 1 ES.M#month(attributes.finish_date)# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI.IN_OUT_ID AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) AS MAAS,
            ISNULL((CASE WHEN EI.GROSS_NET = 0 THEN
                ISNULL((CASE WHEN EI.SALARY_TYPE = 2 THEN (SELECT TOP 1 ES.M#month(attributes.finish_date)# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI.IN_OUT_ID AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">)
                    WHEN EI.SALARY_TYPE = 1 THEN ((SELECT TOP 1 ES.M#month(attributes.finish_date)# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI.IN_OUT_ID AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) * 30)
                    WHEN EI.SALARY_TYPE = 0 THEN ((SELECT TOP 1  ES.M#month(attributes.finish_date)# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI.IN_OUT_ID AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) * (SELECT DAILY_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_HOURS.OUR_COMPANY_ID = B.COMPANY_ID) * 30)
                END),(SELECT TOP 1 ((EPR.TOTAL_AMOUNT / EPR.TOTAL_DAYS) * 30)-EPR.EXT_SALARY FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EPU ON EPU.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EPR.IN_OUT_ID = EI.IN_OUT_ID AND EPR.TOTAL_DAYS > 0 AND ((EPU.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#"> AND EPU.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#month(attributes.finish_date)#">) OR EPU.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) ORDER BY EPU.SAL_YEAR DESC, EPU.SAL_MON DESC))
                WHEN EI.GROSS_NET = 1 THEN
                    (SELECT TOP 1 ((EPR.TOTAL_AMOUNT / EPR.TOTAL_DAYS) * 30)-EPR.EXT_SALARY FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EPU ON EPU.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EPR.IN_OUT_ID = EI.IN_OUT_ID AND EPR.TOTAL_DAYS > 0 AND ((EPU.SAL_YEAR = #year(attributes.finish_date)# AND EPU.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#month(attributes.finish_date)#">) OR EPU.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) ORDER BY EPU.SAL_YEAR DESC, EPU.SAL_MON DESC)
            END),0) AS KIDEME_ESAS_MAAS,
            SPC.POSITION_CAT,
            ST.TITLE,
            EI.IS_VARDIYA
        FROM 
            EMPLOYEES_IN_OUT EI LEFT JOIN EMPLOYEES E ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN DEPARTMENT D ON EI.DEPARTMENT_ID = D.DEPARTMENT_ID
            LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
            LEFT JOIN EMPLOYEES_IDENTY EII ON EII.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
            LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
            LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
        WHERE
            <cfif len(attributes.emp_status)>
                <cfif attributes.emp_status eq 1>
                    E.EMPLOYEE_STATUS = 1
                <cfelseif attributes.emp_status eq -1>
                    (
                        E.EMPLOYEE_STATUS = 0
                        OR 
                        (
                            (EP.POSITION_NAME = '' OR EP.POSITION_NAME IS NULL)
                            OR (EP.POSITION_CAT_ID IS NULL OR EP.POSITION_CAT_ID = '')
                            OR ISNULL(EP.EMPLOYEE_ID,0) = 0
                        )
                    )
                <cfelseif attributes.emp_status eq 0>
                    E.EMPLOYEE_STATUS IS NOT NULL
                </cfif>
            <cfelse>
                E.EMPLOYEE_STATUS=1
            </cfif> AND
            <cfif isdefined("attributes.pos_cat_id") and len(attributes.pos_cat_id)>
                EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_cat_id#" list = "yes">) AND
            </cfif>
            <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">) AND
            </cfif>
            <cfif len(attributes.branch_id)>
                B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">) AND
            </cfif>
            <cfif isdefined('attributes.department') and len(attributes.department)>
                D.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">) AND
            </cfif>
            <cfif not session.ep.ehesap>
                B.BRANCH_ID IN (#emp_branch_list#) AND
            </cfif>
            (
                EI.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> 
                AND 
                EI.START_DATE IS NOT NULL
            ) 
            AND 
            <cfif attributes.emp_status eq -1>
                (
                    EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> 
                    AND
                    EI.FINISH_DATE IS NOT NULL
                )
            <cfelse>
                (
                    EI.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> 
                    OR 
                    EI.FINISH_DATE IS NULL
                ) 
            </cfif>
            <cfif attributes.emp_status neq -1>
                AND EP.IS_MASTER = 1
            </cfif>
            <cfif len(attributes.unit_id)>
                AND EP.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#">
            </cfif>
            <cfif len(attributes.keyword)> 
                AND E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif>
            <cfif len(attributes.gender)>
                AND ED.SEX = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gender#">
            </cfif>
            <cfif len(attributes.ssk_statute)>
                AND EI.SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statute#">
            </cfif>
            <cfif len(attributes.explanation_id)>
                AND EI.EXPLANATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.explanation_id#">
            </cfif>
            <cfif len(attributes.defection_level)>
                AND EI.DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defection_level#">
            </cfif>
        <cfif not isdefined("attributes.pos_cat_id") or not len(attributes.pos_cat_id)>
        UNION ALL
        SELECT 
            E2.EMPLOYEE_ID,
            E2.EMPLOYEE_NO,
            E2.EMPLOYEE_NAME EMPLOYEE_NAME,
            E2.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
            E2.GROUP_STARTDATE,
            E2.KIDEM_DATE,
            E2.IZIN_DATE,
            E2.IZIN_DAYS,
            E2.OLD_SGK_DAYS,
            D2.DEPARTMENT_HEAD,
            B2.BRANCH_NAME,
            B2.RELATED_COMPANY,
            EI2.START_DATE START_DATE,
            EI2.FINISH_DATE,
            EI2.FIRST_SSK_DATE,
            EI2.SOCIALSECURITY_NO,
            EI2.SSK_STATUTE,
            EI2.GROSS_NET,
            EI2.BRANCH_ID,
            EI2.IN_OUT_ID,
            EI2.SALARY_TYPE,
            EI2.PUANTAJ_GROUP_IDS,
            EII2.TC_IDENTY_NO,
            EII2.BIRTH_DATE,
            EI2.EXPLANATION_ID,
            EI2.DEFECTION_LEVEL,
            DATEDIFF(DD,E2.KIDEM_DATE,GETDATE()) AS Kıdem_gun,
            ED2.SEX,
            D2.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
            CASE 
                WHEN E2.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
            THEN	
                D2.HIERARCHY_DEP_ID
            ELSE 
                CASE WHEN 
                    D2.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E2.EMPLOYEE_ID))
                THEN
                    (SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D2.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E2.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                ELSE
                    D2.HIERARCHY_DEP_ID
                END
            END AS HIERARCHY_DEP_ID,
            (SELECT ES.M#month(attributes.finish_date)# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI2.IN_OUT_ID AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) AS MAAS,
            ISNULL((CASE WHEN EI2.GROSS_NET = 0 THEN
                ISNULL((CASE WHEN EI2.SALARY_TYPE = 2 THEN (SELECT ES.M#month(attributes.finish_date)# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI2.IN_OUT_ID AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">)
                    WHEN EI2.SALARY_TYPE = 1 THEN ((SELECT ES.M#month(attributes.finish_date)# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI2.IN_OUT_ID AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) * 30)
                    WHEN EI2.SALARY_TYPE = 0 THEN ((SELECT ES.M#month(attributes.finish_date)# FROM EMPLOYEES_SALARY ES WHERE ES.IN_OUT_ID = EI2.IN_OUT_ID AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">) * (SELECT DAILY_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_HOURS.OUR_COMPANY_ID = B2.COMPANY_ID) * 30)
                END),(SELECT TOP 1 (EPR.TOTAL_AMOUNT / EPR.TOTAL_DAYS) * 30 FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EPU ON EPU.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EPR.IN_OUT_ID = EI2.IN_OUT_ID AND EPR.TOTAL_DAYS > 0 AND ((EPU.SAL_YEAR = #year(attributes.finish_date)# AND EPU.SAL_MON <= #month(attributes.finish_date)#) OR EPU.SAL_YEAR < #year(attributes.finish_date)#) ORDER BY EPU.SAL_YEAR DESC, EPU.SAL_MON DESC))
                WHEN EI2.GROSS_NET = 1 THEN
                    (SELECT TOP 1 (EPR.TOTAL_AMOUNT / EPR.TOTAL_DAYS) * 30 FROM EMPLOYEES_PUANTAJ_ROWS EPR INNER JOIN EMPLOYEES_PUANTAJ EPU ON EPU.PUANTAJ_ID = EPR.PUANTAJ_ID WHERE EPR.IN_OUT_ID = EI2.IN_OUT_ID AND EPR.TOTAL_DAYS > 0 AND ((EPU.SAL_YEAR = #year(attributes.finish_date)# AND EPU.SAL_MON <= #month(attributes.finish_date)#) OR EPU.SAL_YEAR < #year(attributes.finish_date)#) ORDER BY EPU.SAL_YEAR DESC, EPU.SAL_MON DESC)
            END),0) AS KIDEME_ESAS_MAAS,
            '' AS POSITION_CAT,
            '' AS TITLE,
            EI2.IS_VARDIYA
        FROM 
            EMPLOYEES_IN_OUT EI2 INNER JOIN EMPLOYEES E2 ON EI2.EMPLOYEE_ID = E2.EMPLOYEE_ID
            INNER JOIN DEPARTMENT D2 ON D2.DEPARTMENT_ID = EI2.DEPARTMENT_ID
            INNER JOIN BRANCH B2 ON B2.BRANCH_ID = D2.BRANCH_ID
            INNER JOIN EMPLOYEES_IDENTY EII2 ON EII2.EMPLOYEE_ID = E2.EMPLOYEE_ID 
            INNER JOIN EMPLOYEES_DETAIL ED2 ON ED2.EMPLOYEE_ID = E2.EMPLOYEE_ID
        WHERE
            EI2.PUANTAJ_GROUP_IDS IS NOT NULL AND
            E2.EMPLOYEE_ID NOT IN (SELECT EP2.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP2 WHERE EP2.IS_MASTER = 1 AND EP2.EMPLOYEE_ID IS NOT NULL <cfif len(attributes.unit_id)>AND EP2.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.unit_id#"></cfif>) AND
            <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
                B2.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">) AND
            </cfif>
            <cfif len(attributes.branch_id)>
                B2.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">) AND
            </cfif>
            <cfif isdefined('attributes.department') and len(attributes.department)>
                D2.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list = "yes">) AND
            </cfif>
            <cfif not session.ep.ehesap>
                B2.BRANCH_ID IN (#emp_branch_list#) AND
            </cfif>
            (EI2.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND EI2.START_DATE IS NOT NULL) AND
            (EI2.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> OR EI2.FINISH_DATE IS NULL)
            <cfif len(attributes.keyword)> 
                AND E2.EMPLOYEE_NAME+' '+E2.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif>
            <cfif len(attributes.gender)>
                AND ED2.SEX = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gender#">
            </cfif>
            <cfif len(attributes.ssk_statute)>
                AND EI2.SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statute#">
            </cfif>
            <cfif len(attributes.explanation_id)>
                AND EI2.EXPLANATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.explanation_id#">
            </cfif>
            <cfif len(attributes.defection_level)>
                AND EI2.DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defection_level#">
            </cfif>
        </cfif>
        ),
            CTE2 AS (
                SELECT
                    CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY
                            EMPLOYEE_NAME, EMPLOYEE_SURNAME,START_DATE DESC
                        ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                <cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
                </cfif>
    </cfquery>	
     <!--- Excel TableToExcel.convert fonksiyonu ile alındığı için kapatıldı. --->
    <cfif attributes.is_excel eq '1'>
        <cfset type_ = 1>
        <cfif not DirectoryExists("#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#")>
            <cfdirectory action="create" directory="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#">
        </cfif>
        <cfset file_name = "hr_offtimes_report_#session.ep.userid#_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#.xls">
        <cfspreadsheet action="write"  filename="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#/#file_name#" QUERY="get_emp"  
        sheet=1 sheetname="Izın Kıdem Ihbar" overwrite=true> 
        <script type="text/javascript">
            <cfoutput>
                get_wrk_message_div("Excel","Excel","documents/reserve_files/#dateFormat(now(),'yyyymmdd')#/#file_name#") ;
            </cfoutput>
        </script>
    </cfif>
    <cfset employee_list = valuelist(get_emp.employee_id)> 
    <cfparam name="attributes.totalrecords" default="#get_emp.query_count#">
    <cfif get_emp.recordcount>
        <cfquery name="get_contracts" datasource="#dsn#">
            SELECT DISTINCT
                EOC.OFFTIME_DATE_1,
                EOC.EMPLOYEE_ID,
                EOC.OFFTIME_PART_1,
                EOC.OFFTIME_DATE_2,
                EOC.OFFTIME_PART_2
            FROM
                EMPLOYEES_OFFTIME_CONTRACT EOC
                INNER JOIN EMPLOYEES_IN_OUT EI ON EOC.EMPLOYEE_ID = EI.EMPLOYEE_ID
                INNER JOIN BRANCH B ON EI.BRANCH_ID = B.BRANCH_ID
            WHERE 
                (
                    (EI.FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND 
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#">) 
                    OR EI.FINISH_DATE IS NULL
                ) AND
                <cfif len(attributes.branch_id)>
                    B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">) AND
                </cfif>
                <cfif not session.ep.ehesap>
                    B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_branch_list#">) AND
                </cfif>
                EOC.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.years#">
            ORDER BY 
                EOC.EMPLOYEE_ID
        </cfquery> 
        <cfset con_employee_list = listsort(listdeleteduplicates(valuelist(get_contracts.employee_id,',')),'numeric','ASC',',')>
        <cfquery name="get_contracts_old" datasource="#dsn#">
            SELECT DISTINCT
                EOC.OFFTIME_DATE_1,
                EOC.EMPLOYEE_ID,
                EOC.OFFTIME_PART_1,
                EOC.OFFTIME_DATE_2,
                EOC.OFFTIME_PART_2
            FROM
                EMPLOYEES_OFFTIME_CONTRACT EOC
                INNER JOIN EMPLOYEES_IN_OUT EI ON EOC.EMPLOYEE_ID = EI.EMPLOYEE_ID
                INNER JOIN BRANCH B ON EI.BRANCH_ID = B.BRANCH_ID
            WHERE 
                ((EI.FINISH_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND 
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#">) OR EI.FINISH_DATE IS NULL) AND
                <cfif len(attributes.branch_id)>
                    B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_branch_list#">) AND
                </cfif>
                <cfif not session.ep.ehesap>
                    B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_branch_list#">) AND
                </cfif>
                EOC.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)-1# ">
            ORDER BY 
                EOC.EMPLOYEE_ID
        </cfquery>
        <cfquery name="get_progress_payment_out" datasource="#dsn#">
            SELECT EMP_ID,START_DATE,FINISH_DATE,PROGRESS_TIME,IS_KIDEM,IS_YEARLY FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE IS_KIDEM = 1
        </cfquery>
        <cfset old_con_employee_list = listsort(listdeleteduplicates(valuelist(get_contracts_old.EMPLOYEE_ID,',')),'numeric','ASC',',')>
        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cfset type_ = 1>
        <cfelse>
            <cfset type_ = 0>
        </cfif>
        <!-- sil -->  
            <cf_report_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                        <th><cf_get_lang dictionary_id="57576.Çalışan"></th>
                        <th><cf_get_lang dictionary_id="38955.İlgili Şirket"></th>
                        <th><cf_get_lang dictionary_id="57453.Şube"></th>
                        <th><cf_get_lang dictionary_id="57572.Departman"></th>
                        <th><cf_get_lang dictionary_id="59004.Pozisyon Tipi"></th>
                        <th><cf_get_lang dictionary_id="57571.Ünvan"></th>
                        <th><cf_get_lang dictionary_id="58487.Çalışan No"></th>
                        <th><cf_get_lang dictionary_id="39269.Sigorta No"></th>
                        <th><cf_get_lang dictionary_id="58025.TC Kimlik No"></th> 
                        <th><cf_get_lang dictionary_id="39429.Gruba Giriş"></th>
                        <th><cf_get_lang dictionary_id="39070.İzin Baz Tarihi"></th>
                        <th><cf_get_lang dictionary_id="39279.Şirkete Giriş"></th>
                        <th><cf_get_lang dictionary_id="38907.Kıdem Baz"></th>
                        <th><cf_get_lang dictionary_id="29438.Çıkış Tarihi"></th>
                        <th><cf_get_lang dictionary_id="58727.Doğum Tarihi"></th>
                        <th><cf_get_lang dictionary_id="39287.Toplam Hakedilen İzin Günü"></th>
                        <th><cf_get_lang dictionary_id="39288.En Son Hakedilen"></th>
                        <th><cf_get_lang dictionary_id="39296.Geçmiş Dönem Kullanılan İzin"></th>
                        <th><cf_get_lang dictionary_id="39310.Toplam Kullanılan İzin"></th>
                        <th><cf_get_lang dictionary_id="39311.Toplam Kullanılmayan İzin"></th>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39312.Tahmini İzin Yükü Brüt"></th></cfif>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39315.Tahmini İzin Yükü Net"></th></cfif>
                        <th><cf_get_lang dictionary_id="39316.Son İzin Hakediş Tarihi"></th>
                        <th><cf_get_lang dictionary_id="39325.İzin Kullanım Bitiş Tarihi"></th>
                        <th><cf_get_lang dictionary_id="39330.Son Dönem İzni Kullanılan"></th>
                        <th><cf_get_lang dictionary_id="39347.Son Dönem İzni Kalan"></th>
                        <th><cfoutput>#year(attributes.finish_date)-1#</cfoutput> 2. <cf_get_lang dictionary_id="39360.Dönem Mutabakat Tarihi"></th>
                        <th><cfoutput>#year(attributes.finish_date)-1#</cfoutput> 2. <cf_get_lang dictionary_id="39365.Dönem Mutabakat Günü"></th>
                        <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 1. <cf_get_lang dictionary_id="39367.İzin Mutabakat Tarihi"></th>
                        <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 1.<cf_get_lang dictionary_id="39369.İzin Mutabakat Günü"></th>
                        <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 2.<cf_get_lang dictionary_id="39367.İzin Mutabakat Tarihi"></th>
                        <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 2.<cf_get_lang dictionary_id="39369.İzin Mutabakat Günü"></th>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39384.Ücret Maaş"></th></cfif>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39385.Kıdeme Esas Maaş"></th></cfif>
                        <cfif get_module_power_user(48)>
                        <cfoutput>
                            <cfloop from="12" to="1" index="x_ay" step="-1">
                                <th>#month(dateadd("m",(-x_ay+1),puantaj_start_))#-#year(dateadd("m",(-x_ay+1),puantaj_start_))#</th>
                            </cfloop>
                        </cfoutput>
                        </cfif>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="39986.Ek Ödenek"></th></cfif>
                        <th><cf_get_lang dictionary_id="39386.Toplam Geçen Gün"></th>
                        <th><cf_get_lang dictionary_id="39387.Boş Geçen Gün"></th>
                        <th><cf_get_lang dictionary_id="39388.Kıdem Günü"></th>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39389.Kıdem Matrahı"></th></cfif>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39402.Kıdem Tutarı"></th></cfif>
                        <th><cf_get_lang dictionary_id="39406.İhbar Günü"></th>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39409.İhbar Tutarı"></th></cfif>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39413.İhbar Tutarı Tahmini Net"></th></cfif>
                        <th><cf_get_lang dictionary_id="39415.Eski Çalışmalar"></th>
                        <th><cf_get_lang dictionary_id="54358.Geçmiş SGK Günü"></th>
                        <th><cf_get_lang dictionary_id="61005.Toplam Kıdem"></th>
                        <th><cf_get_lang dictionary_id="53566.İlk Sigortalı Oluş Tarihi"></th>
                        <cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
                        <th><cf_get_lang dictionary_id='57764.Cinsiyet'></th>
                        <th><cf_get_lang dictionary_id='53553.SGK Statüsü'></th>
                        <th><cf_get_lang dictionary_id='65172.Çıkış Gerekçesi'></th>
                        <th><cf_get_lang dictionary_id='38994.Sakatlık Durumu'></th>
                    </tr>
                </thead> 
                <tbody>
                    <cfoutput query="get_emp">
                        <cfquery name="get_progress_payment_out" datasource="#dsn#">
                            SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
                        </cfquery>
                        <cfquery name="get_progress_time" dbtype="query">
                            SELECT SUM(PROGRESS_TIME) AS PROGRESS_TIME FROM get_progress_payment_out WHERE IS_KIDEM = 1
                        </cfquery>
                        
                        <cfscript>
                            if (get_progress_time.recordcount)
                                attributes.progress_time = get_progress_time.PROGRESS_TIME;
                            else
                                attributes.progress_time = 0;
                            employee_id_ = employee_id;
                            kisi_izin_toplam = 0;
                            kisi_izin_sayilmayan = 0;
                            genel_izin_toplam = 0;
                            izin_sayilmayan = 0;
                            genel_dk_toplam = 0;
                            resmi_izin_sayilmayan = 0;
                            if (len(izin_days))
                                old_days = izin_days;
                            else
                                old_days = 0;
                            attributes.sal_mon = month(attributes.finish_date);
                            attributes.sal_year = year(attributes.finish_date);
                            attributes.group_id = "";
                            if (len(get_emp.puantaj_group_ids))
                                attributes.group_id = "#get_emp.puantaj_group_ids#,";
                            temp_branch_id = attributes.branch_id;
                            attributes.branch_id = get_emp.branch_id;
                            not_kontrol_parameter = 1;
                            include "../../hr/ehesap/query/get_program_parameter.cfm";
                            if (get_program_parameters.recordcount)
                            {
                                ihbar_1_s_ = get_program_parameters.denunciation_1_low;
                                ihbar_1_f_ = get_program_parameters.denunciation_1_high;
                                ihbar_1_g_ = get_program_parameters.denunciation_1;
                                ihbar_2_s_ = get_program_parameters.denunciation_2_low;
                                ihbar_2_f_ = get_program_parameters.denunciation_2_high;
                                ihbar_2_g_ = get_program_parameters.denunciation_2;
                                ihbar_3_s_ = get_program_parameters.denunciation_3_low;
                                ihbar_3_f_ = get_program_parameters.denunciation_3_high;
                                ihbar_3_g_ = get_program_parameters.denunciation_3;
                                ihbar_4_s_ = get_program_parameters.denunciation_4_low;
                                ihbar_4_f_ = get_program_parameters.denunciation_4_high;
                                ihbar_4_g_ = get_program_parameters.denunciation_4;
                                ihbar_5_s_ = get_program_parameters.denunciation_5_low;
                                ihbar_5_f_ = get_program_parameters.denunciation_5_high;
                                ihbar_5_g_ = get_program_parameters.denunciation_5;
                                ihbar_6_s_ = get_program_parameters.denunciation_6_low;
                                ihbar_6_f_ = get_program_parameters.denunciation_6_high;
                                ihbar_6_g_ = get_program_parameters.denunciation_6;
                            }
                            else
                            {
                                ihbar_1_s_ = 0;
                                ihbar_1_f_ = 0;
                                ihbar_1_g_ = 0;
                                ihbar_2_s_ = 0;
                                ihbar_2_f_ = 0;
                                ihbar_2_g_ = 0;
                                ihbar_3_s_ = 0;
                                ihbar_3_f_ = 0;
                                ihbar_3_g_ = 0;
                                ihbar_4_s_ = 0;
                                ihbar_4_f_ = 0;
                                ihbar_4_g_ = 0;
                                ihbar_5_s_ = 0;
                                ihbar_5_f_ = 0;
                                ihbar_5_g_ = 0;
                                ihbar_6_s_ = 0;
                                ihbar_6_f_ = 0;
                                ihbar_6_g_ = 0;
                            }
                        </cfscript>
                        <cfquery name="get_offtimes" datasource="#dsn#">
                            SELECT 
                                OFFTIME.EMPLOYEE_ID,
                                OFFTIME.STARTDATE,
                                OFFTIME.FINISHDATE,
                                SETUP_OFFTIME.OFFTIMECAT_ID,
                                SETUP_OFFTIME.OFFTIMECAT,
                                SETUP_OFFTIME.IS_PAID,
                                SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
                                SETUP_OFFTIME.CALC_CALENDAR_DAY,
                                SETUP_OFFTIME.IS_YEARLY
                            FROM 
                                OFFTIME,
                                SETUP_OFFTIME
                            WHERE
                                SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
                                OFFTIME.IS_PUANTAJ_OFF = 0 AND
                                OFFTIME.VALID = 1 AND
                                SETUP_OFFTIME.IS_PAID = 1 AND
                                SETUP_OFFTIME.IS_YEARLY = 1
                                <cfif len(izin_date)>
                                    AND
                                    (
                                        OFFTIME.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> OR
                                        OFFTIME.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
                                    )
                                    AND OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#izin_date#">
                                </cfif>
                                AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
                            ORDER BY
                                STARTDATE DESC
                        </cfquery>
                        <cfif get_offtimes.recordcount>
                            <cfloop query="get_offtimes">
                                <cfif len(get_emp.izin_date)>
                                    <cfset kidem=datediff('d',get_emp.izin_date,get_offtimes.startdate)>
                                <cfelse>
                                    <cfset kidem=0>
                                </cfif>
                                <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                                    SELECT 
                                        *
                                    FROM 
                                        SETUP_OFFTIME_LIMIT 
                                    WHERE 
                                        STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_offtimes.startdate#"> AND 
                                        FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_offtimes.startdate#">
                                        <cfif len(get_emp.puantaj_group_ids)>
                                            AND (
                                            <cfloop list="#get_emp.puantaj_group_ids#" index="i">
                                                ','+PUANTAJ_GROUP_IDS+',' LIKE '%,#i#,%' <cfif i neq listlast(get_emp.puantaj_group_ids,',')>OR</cfif>
                                            </cfloop> OR PUANTAJ_GROUP_IDS IS NULL) ORDER BY PUANTAJ_GROUP_IDS DESC
                                        <cfelse>
											AND PUANTAJ_GROUP_IDS IS NULL
                                        </cfif>
                                </cfquery>
                                <!--- Çalışanın vardiyalı çalışma saatleri --->
                                <cfset finishdate_ = dateadd("d", 1, finishdate)>
                                <cfset get_shift = get_employee_shift.get_emp_shift(employee_id : employee_id, start_date : startdate, finish_date : finishdate_)>
                                <cfscript>
                                    if (get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on))
                                        saturday_on = get_offtime_cat.saturday_on;
                                    else
                                        saturday_on = 1;
                                    if (get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on))
                                        sunday_on = get_offtime_cat.sunday_on;
                                    else
                                        sunday_on = 0;
                                    if (get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on))
                                        public_holiday_on = get_offtime_cat.public_holiday_on;
                                    else
                                        public_holiday_on = 0;
                                    if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
                                        day_control_ = get_offtime_cat.day_control;
                                    else
                                        day_control_ = 0;
                                    if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
                                        day_control_afternoon = get_offtime_cat.day_control_afternoon;
                                    else
                                        day_control_afternoon = 0;
                                    if (len(get_emp.izin_date))
                                        kidem=datediff('d',get_emp.izin_date,get_offtimes.startdate);
                                    else
                                        kidem=0;
                                    kidem_yil=kidem/365;
                                    if( get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
                                        day_control = get_offtime_cat.day_control;
                                    else
                                        day_control = 0;
                                </cfscript> 
                                    <!--- İzin Hesapları bu dosyada yapılıyor ---->
                                    <cfif x_min_control eq 1>
                                        <cfif get_shift.recordcount>
                                            <cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
                                        <cfelse>
                                            <cfinclude template="/V16/hr/ehesap/display/offtime_calc.cfm">
                                        </cfif>
                                    <cfelse>
                                        <cfif get_shift.recordcount gt 0>
                                            <cfif len(get_shift.WEEK_OFFDAY) and get_emp.is_vardiya eq 2>
                                                <cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
                                            <cfelse>
                                                <cfset this_week_rest_day_ = 1>
                                            </cfif>
                                        <cfelse>
                                            <cfset this_week_rest_day_ = this_week_rest_day_>
                                        </cfif>
                                        <cfinclude template="/V16/hr/ehesap/display/offtime_calc_day.cfm">
                                    </cfif>
                            </cfloop>
                        </cfif>
                        <cfif len(get_emp.izin_date) and isdate(get_emp.izin_date)>
                            <cfscript>
                                tmp_group_id = "";
                                tmp_def_type = 1;
                                if(len(get_emp.puantaj_group_ids))
                                {
                                    tmp_group_id = " AND (";
                                    for(i=1;i lte listlen(get_emp.puantaj_group_ids,',');i=i+1)
                                    {
                                        tmp_group_id = tmp_group_id & "','+PUANTAJ_GROUP_IDS+',' LIKE '%,"&listgetat(get_emp.puantaj_group_ids,i,',')&",%' ";
                                        if (i neq listlen(get_emp.puantaj_group_ids,','))
                                            tmp_group_id = tmp_group_id & 'OR ';
                                    }
                                    tmp_group_id = tmp_group_id & ' OR PUANTAJ_GROUP_IDS IS NULL) ORDER BY PUANTAJ_GROUP_IDS DESC';
                                }
                                
                                tck = 0;
                                tck_ = 0;
                                old_tck = 0;
                                toplam_hakedilen_izin = 0;
                                my_giris_date = get_emp.izin_date;
                                flag = true;
                                baslangic_tarih_ = my_giris_date;
                                tmp_baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
                                get_def_type = cfquery(Datasource="#dsn#",sqlstring="SELECT TOP 1 DEFINITION_TYPE,LIMIT_1,ISNULL(LIMIT_1_DAYS,0) LIMIT_1_DAYS,MIN_MAX_DAYS,MIN_YEARS,MAX_YEARS FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #tmp_baslangic_tarih_# AND FINISHDATE >= #my_baz_date# "&tmp_group_id);
                                if(get_def_type.recordcount)
                                {
                                    tmp_def_type = get_def_type.definition_type;
                                    eklenecek = get_def_type.limit_1_days;
                                }
                                
                                if(tmp_def_type eq 0)
                                {
                                    tck = datediff('yyyy',my_giris_date,my_baz_date) + 1;
                                    while(flag)
                                    {
                                        bitis_tarihi_ = createodbcdatetime(date_add("m",get_def_type.LIMIT_1,baslangic_tarih_));
                                        baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
                                        get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE EMP_ID = #employee_id_# AND ((START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#))");
                                        if(get_bos_zaman_.recordcount eq 0)
                                        {
                                            tck_ = tck_ + 1; 
                                            kontrol_date = bitis_tarihi_;
                                            eklenecek = get_def_type.limit_1_days;
                                            if(len(get_emp.birth_date) and eklenecek lt get_def_type.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_def_type.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_def_type.max_years))
                                                eklenecek = get_def_type.min_max_days;
                                            if(tck_ neq 1 and eklenecek neq 0)
                                            {
                                                toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                                                son_baslangic_ = baslangic_tarih_;
                                                son_bitis_ = bitis_tarihi_;
                                            }
                                        }
                                        else
                                        {
                                            eklenecek_gun = 0;
                                            for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
                                            {
                                                if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0)
                                                {
                                                    fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
                                                }
                                                else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0)
                                                {
                                                    fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
                                                }
                                                eklenecek_gun = eklenecek_gun + fark_;
                                            }
                                            bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
                                            
                                            tck_ = tck_ + 1; 
                                            kontrol_date = bitis_tarihi_;
                                            eklenecek = get_def_type.LIMIT_1_DAYS;
                                            if(len(get_emp.birth_date) and eklenecek lt get_def_type.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_def_type.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_def_type.max_years))
                                                eklenecek = get_def_type.min_max_days;
                                            if(tck_ neq 1 and eklenecek neq 0) 
                                            {
                                                toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                                                son_baslangic_ = baslangic_tarih_;
                                                son_bitis_ = bitis_tarihi_;
                                            }
                                        }
                                        ilk_tarih_ = baslangic_tarih_;
                                        baslangic_tarih_ = bitis_tarihi_;
                                        bitis_tarihi_ = date_add("m",get_def_type.limit_1,bitis_tarihi_);
                                        if(datediff("d",baslangic_tarih_,now()) lt 0)				
                                        {
                                            flag = false;
                                        }
                                    }
                                }
                                else 
                                {
                                    //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve Yıl bilgisi girilmişse 20191030ERU 
                                    if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and get_offtime_old_sgk_year.property_value and len(calc_old_sgk_year))
                                    {
                                        old_sgk_year = 0;
                                        if(len(get_emp.OLD_SGK_DAYS))
                                            old_sgk_year = get_emp.OLD_SGK_DAYS / 360;//Geçmiş zaman sgk günü 360 gün üzerinden yılı hesaplanıyor.
                                    }
                                    else 
                                        old_sgk_year = 0;
                                    while(flag)
                                    {
                                        bitis_tarihi_ = createodbcdatetime(date_add("yyyy",1,baslangic_tarih_));
                                        baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
                                        ilk_tarih_ = baslangic_tarih_;
                                        baslangic_tarih_ = bitis_tarihi_;
                                        get_bos_zaman_ = cfquery(
                                                Datasource="#dsn#",
                                                dbtype="query",
                                                sqlstring="SELECT * FROM get_progress_payment_outs WHERE EMP_ID = #employee_id_# AND ((START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi_#) OR (START_DATE >= #ilk_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #ilk_tarih_#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi_#) OR ((START_DATE BETWEEN #ilk_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#))");	
                                        
                                        if(get_bos_zaman_.recordcount eq 0)
                                        {
                                            //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve hesaplama yılı girilen yıla eşitse 20191030ERU 
                                            if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year and old_tck eq 0)
                                            {
                                                tck  = tck + int(old_sgk_year);
                                            }
                                            tck = tck + 1; 
                                            old_tck = old_tck +1;
                                            kontrol_date = bitis_tarihi_;
                                            get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT TOP 1 ISNULL(LIMIT_1_DAYS,0) LIMIT_1_DAYS, ISNULL(LIMIT_2_DAYS,0) LIMIT_2_DAYS, ISNULL(LIMIT_3_DAYS,0) LIMIT_3_DAYS, ISNULL(LIMIT_4_DAYS,0) LIMIT_4_DAYS,ISNULL(LIMIT_5_DAYS,0) LIMIT_5_DAYS,MIN_MAX_DAYS,MIN_YEARS,MAX_YEARS,LIMIT_1,LIMIT_2,LIMIT_3,LIMIT_4,LIMIT_5,LIMIT_ID FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#"&tmp_group_id);	
                                            
                                            if(get_offtime_limit.recordcount)
                                            {
                                                if(tck lte get_offtime_limit.limit_1)
                                                    eklenecek = get_offtime_limit.limit_1_days;
                                                else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
                                                    eklenecek = get_offtime_limit.limit_2_days;
                                                else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
                                                    eklenecek = get_offtime_limit.limit_3_days;
                                                else if(tck gt get_offtime_limit.limit_3 and tck lte get_offtime_limit.limit_4)
                                                    eklenecek = get_offtime_limit.limit_4_days;
                                                else	
                                                    eklenecek = get_offtime_limit.limit_5_days;
                                                if(len(get_emp.birth_date) and eklenecek lt get_offtime_limit.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_offtime_limit.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_offtime_limit.max_years) and tck gt 1)
                                                    eklenecek = get_offtime_limit.min_max_days;
                                                    
                                                    toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                                                    
                                                    //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve hesaplama yılı girilen yıla eşitse 20191030ERU 
                                                    if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year and old_tck neq 0)
                                                    {
                                                        tck  = tck + int(old_sgk_year);
                                                    }
                                                    
                                                    if(tck neq 1 and eklenecek neq 0) 
                                                    {
                                                        //toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                                                        son_baslangic_ = baslangic_tarih_;
                                                        son_bitis_ = bitis_tarihi_;
                                                    }
                                                    
                                            }
                                            else
                                            {
                                                writeoutput('<tr><td colspan=5>İzin limitleri girilmemiş!</td></tr>');
                                            }                                      
                                        }
                                        else
                                        {
                                        eklenecek_gun = 0;
                                            for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
                                            {
                                                if(datediff("d",get_bos_zaman_.start_date[izd],ilk_tarih_) gt 0)
                                                {
                                                    fark_ = datediff("d",ilk_tarih_,get_bos_zaman_.finish_date[izd]);
                                                }
                                                else if(datediff("d",get_bos_zaman_.start_date[izd],ilk_tarih_) lte 0)
                                                {
                                                    fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]) + 1;
                                                }
                                                fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]) + 1;
                                                eklenecek_gun = eklenecek_gun + fark_;
                                            }
                                            bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
                                            tck = tck + 1; 
                                            old_tck = old_tck + 1;
                                            kontrol_date = bitis_tarihi_;

                                            get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT TOP 1 ISNULL(LIMIT_1_DAYS,0) LIMIT_1_DAYS, ISNULL(LIMIT_2_DAYS,0) LIMIT_2_DAYS, ISNULL(LIMIT_3_DAYS,0) LIMIT_3_DAYS, ISNULL(LIMIT_4_DAYS,0) LIMIT_4_DAYS,ISNULL(LIMIT_5_DAYS,0) LIMIT_5_DAYS,MIN_MAX_DAYS,MIN_YEARS,MAX_YEARS,LIMIT_1,LIMIT_2,LIMIT_3,LIMIT_4,LIMIT_ID FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #bitis_tarihi_# AND FINISHDATE >= #bitis_tarihi_#");	
                                            if(get_offtime_limit.recordcount)
                                            {
                                                if(tck lte get_offtime_limit.limit_1)
                                                    eklenecek = get_offtime_limit.limit_1_days;
                                                else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
                                                    eklenecek = get_offtime_limit.limit_2_days;
                                                else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
                                                    eklenecek = get_offtime_limit.limit_3_days;
                                                else if(tck gt get_offtime_limit.limit_3 and tck lte get_offtime_limit.limit_4)
                                                    eklenecek = get_offtime_limit.limit_4_days;
                                                else 
                                                    eklenecek = get_offtime_limit.limit_5_days;
                                                //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve hesaplama yılı girilen yıla eşitse 20191030ERU 
                                                if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year)
                                                {
                                                    tck  = tck + int(old_sgk_year);
                                                }
                                                if(len(get_emp.birth_date) and eklenecek lt get_offtime_limit.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_offtime_limit.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_offtime_limit.max_years) and tck gt 1)
                                                    eklenecek = get_offtime_limit.min_max_days;
                                                if(tck neq 1 and eklenecek neq 0)
                                                {
                                                    toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
                                                    son_baslangic_ = baslangic_tarih_;
                                                    son_bitis_ = bitis_tarihi_;
                                                }
                                            }
                                        }	
                                        ilk_tarih_ = baslangic_tarih_;
                                        baslangic_tarih_ = bitis_tarihi_;
                                        bitis_tarihi_ = date_add("yyyy",1,bitis_tarihi_);
                                        if(datediff("yyyy",bitis_tarihi_,my_baz_date) lt 0)			
                                            flag = false;
                                    }
                                }
                        </cfscript>
                        <cfelse>
                            <cfscript>
                                tck = 0;
                                toplam_hakedilen_izin = 0;
                                eklenecek_gun = 0;
                            </cfscript>
                        </cfif>               
                        <tr>
                            <td>#rownum#</td>
                            <td>#employee_name# #employee_surname#</td>
                            <td>#related_company#</td>
                            <td>#branch_name#</td>
                            <td>#department_head#</td>
                            <td>#position_cat#</td>
                            <td>#title#</td>
                            <td>#employee_no#</td>
                            <td format="numericextra">#socialsecurity_no#</td>
                            <td format="numericextra">#tc_identy_no#</td>
                            <td format="date"><cfif len(group_startdate)>#dateformat(group_startdate,dateformat_style)#<cfelse>-</cfif></td>
                            <td format="date"><cfif len(izin_date)>#dateformat(izin_date,dateformat_style)#<cfelse>-</cfif></td>
                            <td format="date">#dateformat(start_date,dateformat_style)#</td>
                            <td format="date"><cfif len(kidem_date)>#dateformat(kidem_date,dateformat_style)#<cfelse>-</cfif></td>
                            <td format="date"><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#<cfelse>-</cfif></td>
                            <td format="date"><cfif len(birth_date)>#dateformat(birth_date,dateformat_style)#<cfelse>-</cfif></td>
                            <td format="numeric">#toplam_hakedilen_izin#</td>
                            <td>
                                <cfset bu_yil_isleniyor = 0>
                                <cfif toplam_hakedilen_izin eq 0>
                                <cfset bu_yil_ = 0>
                                <cfelseif len(izin_date)>
                                    <cfscript>
                                        tmp_group_id = "";
                                        tmp_def_type = 1;
                                        if(len(get_emp.puantaj_group_ids))
                                        {
                                            tmp_group_id = " AND (";
                                            for(i=1;i lte listlen(get_emp.puantaj_group_ids,',');i=i+1)
                                            {
                                                tmp_group_id = tmp_group_id & "','+PUANTAJ_GROUP_IDS+',' LIKE '%,"&listgetat(get_emp.puantaj_group_ids,i,',')&",%' ";
                                                if (i neq listlen(get_emp.puantaj_group_ids,','))
                                                    tmp_group_id = tmp_group_id & 'OR ';
                                            }
                                            tmp_group_id = tmp_group_id & ' OR PUANTAJ_GROUP_IDS IS NULL) ORDER BY PUANTAJ_GROUP_IDS DESC';
                                        }
                                        get_def_type = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT DEFINITION_TYPE,LIMIT_1 FROM get_offtime_limits WHERE STARTDATE <= #my_baz_date# AND FINISHDATE >= #my_baz_date# "&tmp_group_id);
                                        if(get_def_type.recordcount)
                                            tmp_def_type = get_def_type.definition_type;
                                        if (tmp_def_type eq 0)
                                            my_tck = datediff("m",my_giris_date,my_baz_date);
                                        else 
                                            my_tck = datediff("yyyy",my_giris_date,my_baz_date) + 1;
                                        get_offtime_limit=cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_offtime_limits WHERE STARTDATE <= #my_baz_date# AND FINISHDATE >= #my_baz_date#"&tmp_group_id);
                                        if (tmp_def_type eq 0)
                                        {
                                            if (my_tck gte get_offtime_limit.limit_1)
                                                bu_yil = get_offtime_limit.limit_1_days;
                                            else 
                                                bu_yil = 0;
                                        }
                                        else 
                                        {
                                            if(my_tck lte get_offtime_limit.limit_1)
                                                bu_yil = get_offtime_limit.limit_1_days;
                                            else if(my_tck gt get_offtime_limit.limit_1 and my_tck lte get_offtime_limit.limit_2)
                                                bu_yil = get_offtime_limit.limit_2_days;
                                            else if(my_tck gt get_offtime_limit.limit_2 and my_tck lte get_offtime_limit.limit_3)
                                                bu_yil = get_offtime_limit.limit_3_days;
                                            else if(my_tck gt get_offtime_limit.limit_3 and my_tck lte get_offtime_limit.limit_4)
                                                bu_yil = get_offtime_limit.limit_4_days;
                                            else
                                                bu_yil = get_offtime_limit.limit_5_days;
                                        }
                                        
                                    if(len(get_emp.birth_date) and bu_yil lt get_offtime_limit.min_max_days and (datediff("yyyy",get_emp.birth_date,my_baz_date) lt get_offtime_limit.min_years or datediff("yyyy",get_emp.birth_date,my_baz_date) gt get_offtime_limit.max_years) )
                                        bu_yil = 0;
                                    </cfscript>
                                    <cfset bu_yil_ = bu_yil>
                                    <cfset bu_yil_isleniyor = 1>
                                <cfelse>
                                    <cfset bu_yil_ = 0>
                                </cfif>
                                #bu_yil_#
                            </td>
                            <td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1> #Replace(old_days,".",",")#<cfelse>#old_days#</cfif> </td>
                            <td style="mso-number-format:\@"><cfif isDefined("x_min_control") and x_min_control eq 1> #wrk_round(genel_dk_toplam+old_days)# <cfelse>#genel_izin_toplam#</cfif></td>
                            <td style="mso-number-format:\@">
                                <cfif isDefined("x_min_control") and x_min_control eq 1> 
                                    #wrk_round(toplam_hakedilen_izin-genel_dk_toplam-old_days)# 
                                    <cfset genel_izin_hesaba_katilacak = wrk_round(genel_dk_toplam)>
                                <cfelse>
                                    #toplam_hakedilen_izin-genel_izin_toplam-old_days#
                                    <cfset genel_izin_hesaba_katilacak = wrk_round(genel_izin_toplam)>
                                </cfif>
                            </td>
                                <cfquery name="get_salary" datasource="#dsn#" maxrows="1">
                                    SELECT
                                        ES.M#month(attributes.finish_date)# SALARY
                                    FROM
                                        EMPLOYEES_SALARY ES INNER JOIN EMPLOYEES_IN_OUT EIO ON ES.IN_OUT_ID = EIO.IN_OUT_ID
                                    WHERE
                                        ES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
                                        AND ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#">
                                        AND ES.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
                                </cfquery>
                                <cfif get_salary.recordcount>
                                    <cfif get_FeeCalculation.recordcount and gross_net eq 0> <!--- Brütse --->
                                        <cfset tahmini_izin_yuku = (((get_salary.salary * get_FeeCalculation.property_value) / 12 ) / 30) * (toplam_hakedilen_izin - genel_izin_hesaba_katilacak - old_days)>
                                    <cfelseif salary_type eq 0>
                                        <cfset tahmini_izin_yuku = get_salary.salary * 225 / 30 * (toplam_hakedilen_izin - genel_izin_hesaba_katilacak-old_days)>
                                    <cfelseif salary_type eq 1>
                                        <cfset tahmini_izin_yuku = get_salary.salary * (toplam_hakedilen_izin - genel_izin_hesaba_katilacak-old_days)>
                                    <cfelse>
                                        <cfset tahmini_izin_yuku = get_salary.salary / 30 * (toplam_hakedilen_izin - genel_izin_hesaba_katilacak-old_days)>
                                    </cfif>
                                <cfelse>
                                    <cfset tahmini_izin_yuku = 0>
                                </cfif>
                                <cfset ssk_payi_ = abs(tahmini_izin_yuku * 15 / 100)>
                                <cfif gross_net eq 0>
                                    <cfset vergi_payi_ = abs((tahmini_izin_yuku - ssk_payi_) * 15 / 100)>
                                <cfelse>
                                    <cfset vergi_payi_ = abs((tahmini_izin_yuku) * 15 / 100)>
                                </cfif>
                                <cfset d_payi_ = abs(tahmini_izin_yuku * 6.6 / 1000)>
                                <cfif get_module_power_user(48)>
                                <cfif gross_net eq 0>
                                    <td format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(tahmini_izin_yuku)#"></td>
                                    <td format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(tahmini_izin_yuku - ssk_payi_ - vergi_payi_ - d_payi_)#"></td>
                                <cfelse>
                                    <td format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(tahmini_izin_yuku + ssk_payi_ + vergi_payi_ + d_payi_)#"></td>
                                    <td format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(tahmini_izin_yuku)#"></td>
                                </cfif>
                                </cfif>
                                <td format="date"><cfif toplam_hakedilen_izin gt 0>#dateformat(son_baslangic_,dateformat_style)#<cfelse>&nbsp;</cfif></td>
                                <td format="date"><cfif toplam_hakedilen_izin gt 0>#dateformat(son_bitis_,dateformat_style)#<cfelse>&nbsp;</cfif></td>
                                    <cfif bu_yil_isleniyor eq 1 and get_offtimes.recordcount and toplam_hakedilen_izin gt 0>
                                        <cfset son_izin_toplam = 0>
                                        <cfquery name="get_ic" dbtype="query">
                                            SELECT * FROM get_offtimes WHERE EMPLOYEE_ID = #get_emp.employee_id# AND STARTDATE >= #son_baslangic_# AND FINISHDATE <= #son_bitis_#
                                        </cfquery>
                                        <cfset genel_dk_toplam_ = 0>
                                        <cfloop query="get_ic">
                                            <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                                                SELECT 
                                                    SATURDAY_ON,
                                                    DAY_CONTROL,
                                                    SUNDAY_ON,
                                                    PUBLIC_HOLIDAY_ON
                                                FROM 
                                                    SETUP_OFFTIME_LIMIT 
                                                WHERE 
                                                    STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_ic.startdate#"> AND 
                                                    FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_ic.startdate#">
                                                    <cfif len(get_emp.puantaj_group_ids)>
                                                        AND (
                                                        <cfloop list="#get_emp.puantaj_group_ids#" index="i">
                                                            ','+PUANTAJ_GROUP_IDS+',' LIKE '%,#i#,%' <cfif i neq listlast(get_emp.puantaj_group_ids,',')>OR</cfif>
                                                        </cfloop> OR PUANTAJ_GROUP_IDS IS NULL) ORDER BY PUANTAJ_GROUP_IDS DESC
                                                    </cfif>
                                            </cfquery>
                                            <cfif get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on)>
                                                <cfset saturday_on = get_offtime_cat.saturday_on>
                                            <cfelse>
                                                <cfset saturday_on = 1>
                                            </cfif>
                                            <cfif get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
                                                <cfset day_control_ = get_offtime_cat.day_control>
                                            <cfelse>
                                                <cfset day_control_ = 0>
                                            </cfif>
                                            <cfif get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on)>
                                                <cfset sunday_on = get_offtime_cat.sunday_on>
                                            <cfelse>
                                                <cfset sunday_on = 0>
                                            </cfif>
                                            <cfif get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on)>
                                                <cfset public_holiday_on = get_offtime_cat.public_holiday_on>
                                            <cfelse>
                                                <cfset public_holiday_on = 0>
                                            </cfif>
                                            <cfscript>
                                                add_sunday_total = 0;
                                                temporary_sunday_total = 0;
                                                temporary_resmi_total = 0;
                                                temporary_offday_total = 0;
                                                temporary_halfday_total = 0;
                                                temporary_halfofftime = 0; //yarım günlük genel tatiller
                                                izin_start_hour_ = "";
                                                izin_finish_hour_ = "";
                                                temp_finishdate = CreateDateTime(year(get_ic.finishdate),month(get_ic.finishdate),day(get_ic.finishdate),0,0,0);
                                                temp_startdate = CreateDateTime(year(get_ic.startdate),month(get_ic.startdate),day(get_ic.startdate),0,0,0);
                                                izin_startdate_ = date_add("h", session.ep.time_zone, get_ic.startdate); 
                                                izin_finishdate_ = date_add("h", session.ep.time_zone, get_ic.finishdate);
                                                total_izin = fix(temp_finishdate-temp_startdate)+1;
                                                izin_startdate = date_add("h", session.ep.time_zone, get_ic.startdate); 
                                                izin_finishdate = date_add("h", session.ep.time_zone, get_ic.finishdate);
                                                fark = 0;
                                                fark2 = 0;
                                                cikarılacak_sabah_izni = 0;
                                                izin_saati_oglenden_once = 0;
                                                izin_saati_oglenden_sonra = 0;
                                                ext_worktime_day = 0;
                                                eklenecek_aksam_izni = 0;
                                                eklenecek_sabah_izni = 0;
                                                if(timeformat(izin_startdate,timeformat_style) lt timeformat('#start_hour#:#start_min#',timeformat_style))
                                                {
                                                    izin_start_hour_ = timeformat('#start_hour#:#start_min#',timeformat_style);
                                                    //Sabah girilen izin için hesaplama ERU
                                                    if(x_min_control eq 1){
                                                        izin_start_hour_time_format = timeformat(izin_startdate_,timeformat_style);
                                                        eklenecek_sabah_izni = datediff("n",izin_start_hour_time_format,baslangic_saat_dk);
                                                    }
                                                }
                                                else
                                                {
                                                    izin_start_hour_ = 	timeformat(izin_startdate,timeformat_style);
                                                    if(x_min_control eq 1){
                                                        izin_start_hour_time_format = timeformat(izin_startdate_,timeformat_style);
                                                        cikarılacak_sabah_izni = datediff("n",baslangic_saat_dk,izin_start_hour_time_format);
                                                    }
                                                }
                                                if(timeformat(izin_finishdate,timeformat_style) gt timeformat('#finish_hour#:#finish_min#',timeformat_style))
                                                {
                                                    izin_finish_hour_ = timeformat('#finish_hour#:#finish_min#',timeformat_style);
                                                    if(x_min_control eq 1){
                                                        izin_finish_hour_parameters = bitis_saat_dk;//izin bitiş saati xml'deki değeri alıyor.
                                                        izin_finish_hour_time_format = timeformat(izin_finishdate_,timeformat_style);
                                                        eklenecek_aksam_izni = datediff("n",bitis_saat_dk,izin_finish_hour_time_format);
                                                    }
                                                }
                                                else
                                                {
                                                    izin_finish_hour_ = timeformat(izin_finishdate,timeformat_style);	
                                                    if(x_min_control eq 1){
                                                        izin_finish_hour_parameters = timeformat(izin_finishdate_,timeformat_style);
                                                    }
                                                }
                                                if(izin_start_hour_ gt timeformat('#start_hour#:#start_min#',timeformat_style))
                                                {
                                                    fark = fark+datediff("n",izin_start_hour_,timeformat('#finish_hour#:#finish_min#',timeformat_style));
                                                    fark = fark/60;
                                                }
                                                else
                                                {
                                                    fark = fark+datediff("n",izin_start_hour_,timeformat('#start_hour#:#start_min#',timeformat_style));
                                                    fark = fark/60;
                                                }
                                                fark2 = fark2+datediff("n",timeformat('#start_hour#:#start_min#',timeformat_style),izin_finish_hour_);
                                                fark2 = fark2/60;
                                                if(fark gt 0 and fark lte day_control_)
                                                {
                                                    if(not listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') and public_holiday_on eq 1)) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
                                                    temporary_halfday_total = temporary_halfday_total + 1;
                                                    halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(startdate,dateformat_style)#');
                                                }
                                                if(fark2 gt 0 and fark2 lte day_control_)
                                                {
                                                    if(not listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') and public_holiday_on eq 1)) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
                                                        temporary_halfday_total = temporary_halfday_total + 1;
                                                    halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(finishdate,dateformat_style)#');
                                                }
                                                if(isdefined("finish_am_hour") and izin_start_hour_ lte timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style) and izin_finish_hour_ lte timeformat('#finish_am_hour#:#finish_am_min#',timeformat_style))//izin başlangıç saati ve bitiş saati 13 ten küçükse ERU
                                                {
                                                    izin_saati_oglenden_once = 1;
                                                }
                                                else if(isdefined("start_pm_hour") and izin_start_hour_ gte timeformat('#start_pm_hour#:#start_pm_min#',timeformat_style))
                                                {
                                                    izin_saati_oglenden_sonra = 1;
                                                }
                                                for (mck=0; mck lt total_izin; mck=mck+1)
                                                    {
                                                    temp_izin_gunu = date_add("d",mck,izin_startdate);
                                                    daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
                                                    if (dayofweek(temp_izin_gunu) eq this_week_rest_day_)
                                                        temporary_sunday_total = temporary_sunday_total + 1;
                                                    else if (dayofweek(temp_izin_gunu) eq 7 and saturday_on eq 0)
                                                        temporary_sunday_total = temporary_sunday_total + 1;
                                                    else if(listlen(offday_list_) and listfindnocase(offday_list_,'#daycode#') and public_holiday_on eq 0)
                                                        if(listfind(halfofftime_list2,'#daycode#') or (listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode#')))
                                                            temporary_offday_total = temporary_offday_total + 0.5;
                                                        else 
                                                            temporary_offday_total = temporary_offday_total +1;
                                                        else if(listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode#') and public_holiday_on eq 0) //yarım günlük genel tatiller
                                                            temporary_halfofftime = temporary_halfofftime + 1; 
                                
                                                        if (dayofweek(temp_izin_gunu) eq 1 and sunday_on eq 1)//pazar gunu ise ve pazar gunleri dahil edilsin secili ise
                                                        {
                                                            add_sunday_total = add_sunday_total+1;	
                                                        }
                                                    }
                                                    if((get_offtimes.is_paid neq 1 and get_offtimes.ebildirge_type_id neq 21) or (get_offtimes.CALC_CALENDAR_DAY)) // ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez  
                                                    {
                                                        izin_gun = total_izin - (0.5 * temporary_halfday_total); //+ (0.5 * temporary_halfofftime)
                                                    }
                                                    else
                                                    {
                                                        izin_gun = total_izin - temporary_sunday_total - temporary_offday_total - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime)+add_sunday_total;
                                                    }
                                                    if((get_ic.is_paid neq 1 and get_ic.ebildirge_type_id neq 21) or (get_ic.CALC_CALENDAR_DAY)) // ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez  
                                                    {
                                                        temp_total_izin_ = total_izin;
                                                    }else{
                                                        temp_total_izin_ = total_izin -  temporary_sunday_total - temporary_offday_total + (0.5 * temporary_halfofftime) + add_sunday_total;
                                                    }
                                                    //İzin günü dk cinsinden hesaplama 20200107ERU
                                                    if(x_min_control eq 1){
                                                    
                                                        total_dk = gunluk_calisma_dk * temp_total_izin_; // toplam izin dk
                                                        
                                                        bitis = datediff("n",izin_finish_hour_parameters,bitis_saat_dk);//Mesai bitis - izin bitiş
                                                        total_dk = (total_dk - bitis);//toplam dk'dan bitiş çıkarılıyor
                                                        if(izin_saati_oglenden_once neq 0){//Öğleden Önce ise çıkaılan öğle arası geri ekleniyor
                                                            total_dk = total_dk + ogle_arasi_dk;
                                                        }
                                                        if(eklenecek_sabah_izni neq 0){
                                                            total_dk = total_dk + eklenecek_sabah_izni;
                                                        }
                                                        if(cikarılacak_sabah_izni neq 0){//izin mesai saatinden sonra başlıyorsa
                                                            total_dk = total_dk - cikarılacak_sabah_izni;
                                                            if(izin_saati_oglenden_sonra){
                                                                total_dk = total_dk + ogle_arasi_dk;
                                                            }
                                                        }
                                                        if(eklenecek_aksam_izni neq 0){//İzin mesai saatinden sonra bitiyorsa.
                                                            total_dk = total_dk + eklenecek_aksam_izni;
                                                        }
                                                        total_dk = abs(total_dk);
                                                        //İzini Gün Saat Dk cinsinden hesaplar
                                                        days = int(total_dk / gunluk_calisma_dk) ;
                                                        minutesRemaining = total_dk - (days * gunluk_calisma_dk);
                                                        hours = int(minutesRemaining / 60);
                                                        minutes = minutesRemaining mod 60;
                                                        total_day_calc = total_dk / gunluk_calisma_dk;
                                                        genel_dk_toplam_ = genel_dk_toplam_ + total_day_calc;
                                                    }
                                                    son_izin_toplam = son_izin_toplam + izin_gun;
                                            </cfscript>
                                        </cfloop>
                                        <cfif x_min_control eq 1>
                                            <cfset son_donem_kullanilan = genel_dk_toplam_>
                                        <cfelse>
                                            <cfset son_donem_kullanilan = son_izin_toplam>
                                        </cfif>
                                    <cfelse>
                                        <cfset son_donem_kullanilan = 0>
                                    </cfif>
                                <td style="mso-number-format:\@">#wrk_round(son_donem_kullanilan)#</td>
                                <td style="mso-number-format:\@"><cfif len(bu_yil_)>#wrk_round(bu_yil_-son_donem_kullanilan)#<cfelse>#wrk_round(0-son_donem_kullanilan)#</cfif></td>
                                <td><cfif listfindnocase(old_con_employee_list,employee_id)>#dateformat(get_contracts_old.offtime_date_2[listfind(old_con_employee_list,employee_id,',')],dateformat_style)#<cfelse>-</cfif></td>
                                <td>
                                    <cfif listfindnocase(old_con_employee_list,employee_id)>
                                        <cfif get_contracts_old.offtime_part_2[listfind(old_con_employee_list,employee_id,',')] contains '.'>
                                        #tlformat(get_contracts_old.offtime_part_2[listfind(old_con_employee_list,employee_id,',')],1)#
                                        <cfelse>
                                        #get_contracts_old.offtime_part_2[listfind(old_con_employee_list,employee_id,',')]#
                                        </cfif>
                                    <cfelse>
                                    -
                                    </cfif>
                                </td>
                                <td format="date"><cfif listfindnocase(con_employee_list,employee_id)>#dateformat(get_contracts.offtime_date_1[listfind(con_employee_list,employee_id,',')],dateformat_style)#<cfelse>-</cfif></td>
                                <td><cfif listfindnocase(con_employee_list,employee_id)>
                                        <cfif get_contracts.offtime_part_1[listfind(con_employee_list,employee_id,',')] contains '.'>
                                            #tlformat(get_contracts.offtime_part_1[listfind(con_employee_list,employee_id,',')],1)#
                                        <cfelse>
                                            #get_contracts.offtime_part_1[listfind(con_employee_list,employee_id,',')]#
                                        </cfif>
                                    <cfelse>-</cfif>
                                </td>
                                <td format="date"><cfif listfindnocase(con_employee_list,employee_id)>#dateformat(get_contracts.offtime_date_2[listfind(con_employee_list,employee_id,',')],dateformat_style)#<cfelse>-</cfif></td>
                                <td><cfif listfindnocase(con_employee_list,employee_id)>
                                    <cfif get_contracts.offtime_part_2[listfind(con_employee_list,employee_id,',')] contains '.'>
                                            #tlformat(get_contracts.offtime_part_2[listfind(con_employee_list,employee_id,',')],1)#
                                        <cfelse>
                                            #get_contracts.offtime_part_2[listfind(con_employee_list,employee_id,',')]#
                                        </cfif>
                                    <cfelse>
                                        -
                                    </cfif>
                                </td>
                                
                                <cfif len(kidem_date)>
                                    <cfif get_module_power_user(48)>
                                        <td format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(maas)#"></td>
                                        <td format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(kideme_esas_maas)#"></td>
                                    </cfif>
                                    <cfset total_kidem = 0>
                                    <cfloop from="12" to="1" index="x_ay" step="-1">
                                        <cfquery name="get_this_odenek" datasource="#dsn#">
                                            SELECT 
                                                SUM(ERPE.AMOUNT) AS TOTAL_AMOUNT,
                                                EPR.EMPLOYEE_ID AS EMPLOYEE_ID,
                                                EP.SAL_MON AS SAL_MON,
                                                EP.SAL_YEAR AS SAL_YEAR
                                            FROM
                                                EMPLOYEES_PUANTAJ AS EP
                                                INNER JOIN EMPLOYEES_PUANTAJ_ROWS AS EPR ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
                                                INNER JOIN EMPLOYEES_PUANTAJ_ROWS_EXT AS ERPE ON EPR.EMPLOYEE_PUANTAJ_ID = ERPE.EMPLOYEE_PUANTAJ_ID AND EP.PUANTAJ_ID = ERPE.PUANTAJ_ID
                                            WHERE
                                                EPR.EMPLOYEE_ID = #EMPLOYEE_ID#  AND
                                                ERPE.IS_KIDEM = 1 AND 
                                                ERPE.EXT_TYPE = 0 AND
                                                EP.SAL_MON = #month(dateadd("m",(-x_ay+1),puantaj_start_))# AND
                                                EP.SAL_YEAR = #year(dateadd("m",(-x_ay+1),puantaj_start_))#
                                            GROUP BY
                                                EPR.EMPLOYEE_ID,
                                                EP.SAL_YEAR,
                                                EP.SAL_MON
                                        </cfquery>
                                        <cfif get_module_power_user(48)>
                                            <td format="numeric">
                                            <cfif get_this_odenek.recordcount>
                                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(get_this_odenek.TOTAL_AMOUNT)#">
                                            <cfelse>
                                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(0)#">
                                            </cfif></td>
                                        </cfif>
                                        <cfif get_this_odenek.recordcount><cfset total_kidem = get_this_odenek.TOTAL_AMOUNT + total_kidem></cfif>
                                    </cfloop>
                                    <cfif get_module_power_user(48)>
                                        <td format="numeric">
                                            <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_kidem)#">
                                        </td>
                                    </cfif>
                                
                                    <td>
                                        <cfquery name="get_emp_offtimes" datasource="#dsn#">
                                            SELECT
                                                SUM(DATEDIFF(DAY,OFFTIME.STARTDATE, OFFTIME.FINISHDATE)+ 1)  AS TOPLAM_GUN
                                            FROM
                                                OFFTIME,
                                                SETUP_OFFTIME
                                            WHERE
                                            (
                                            (OFFTIME.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(kidem_date)#"> AND OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(attributes.finish_date)#">) OR
                                            (OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(kidem_date)#"> AND OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEODBCDATETIME(attributes.finish_date)#">)
                                            ) AND	
                                            OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#"> AND
                                            OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
                                            OFFTIME.VALID = 1 AND
                                            OFFTIME.IS_PUANTAJ_OFF = 0 AND
                                            (SETUP_OFFTIME.IS_KIDEM = 0 OR SETUP_OFFTIME.IS_KIDEM IS NULL)
                                        </cfquery>
                                        <cfscript>
                                            yillar = ceiling(datediff('yyyy',kidem_date,puantaj_finish_));
                                            total_ssk_days = 0;
                                            if(attributes.FINISH_DATE_COUNT_TYPE is 0) // gün hesabı
                                            {
                                                gun_sayisi = (yillar * attributes.gun_say);
                                                if(day(puantaj_finish_) neq day(kidem_date) or month(puantaj_finish_) neq month(kidem_date))
                                                {
                                                    new_year = dateadd("yyyy",yillar,kidem_date);
                                                    fark = datediff('d',new_year,puantaj_finish_);
                                                    gun_sayisi = gun_sayisi + fark;		
                                                    gun_sayisi = gun_sayisi + 1;				
                                                }
                                            }
                                            else // yıl - ay - gün hesabı
                                            {
                                                total_ssk_days = 0;
                                                total_ssk_years = datediff("yyyy",kidem_date,dateadd('d',1,attributes.finish_date));
                                                if (isnumeric(get_emp_offtimes.TOPLAM_GUN))
                                                    toplam_izin = get_emp_offtimes.TOPLAM_GUN;
                                                else
                                                    toplam_izin = 0;
                                                progress_time = attributes.progress_time + toplam_izin;
                                                if (progress_time gte 365)
                                                    progress_time_years = progress_time \ 365; 
                                                else 
                                                    progress_time_years = 0;
                                                temp_kalan = progress_time - (progress_time_years * 365);
                                                if (temp_kalan gte 30)
                                                    progress_time_months = temp_kalan \ 30;
                                                else
                                                    progress_time_months = 0;
                                                progress_time_days = temp_kalan - (progress_time_months * 30);
                                        
                                                
                                                if(yillar gte 1)
                                                {
                                                    total_ssk_months = datediff("m",kidem_date,date_add("yyyy",-yillar,puantaj_finish_));
                                                }
                                                else
                                                {
                                                    total_ssk_months = datediff("m",kidem_date,puantaj_finish_);	
                                                }
                                                {
                                                    new_date = attributes.finish_date; 
                                                    if(total_ssk_years gte 1) new_date = date_add("yyyy",-total_ssk_years,attributes.finish_date);
                                                    if(total_ssk_months gte 1) new_date = date_add("m",-total_ssk_months,new_date);
                                                    if(month(attributes.finish_date) eq 2 and (day(attributes.finish_date) gt daysinmonth(attributes.finish_date) or daysinmonth(attributes.finish_date) gte 28))
                                                    {
                                                        new_date = createdate(year(new_date),month(new_date),daysinmonth(new_date));
                                                    }	
                                                    total_ssk_days_2 = datediff("d",kidem_date,new_date)+1;
                                                }
                                                if(total_ssk_days eq 0 and datediff("d",puantaj_finish_,kidem_date) eq 0)
                                                {
                                                    total_ssk_days = 1;
                                                }
                                                if(yillar lt 0)
                                                    yillar = 0;
                                                if(total_ssk_months lt 0)
                                                    total_ssk_months = 0;
                                                if(total_ssk_days_2 lt 0)
                                                    total_ssk_days_2 = 0;
                                                    
                                                if (total_ssk_days_2 gte progress_time_days)
                                                    total_ssk_days_2 = total_ssk_days_2 - progress_time_days;
                                                else {
                                                    if (total_ssk_months gt 0)
                                                        total_ssk_months = total_ssk_months - 1;
                                                    else {
                                                        total_ssk_months = total_ssk_months + 11;
                                                        total_ssk_years = total_ssk_years - 1;
                                                    }
                                                    total_ssk_days_2 = total_ssk_days_2 + 30;
                                                    total_ssk_days_2 = total_ssk_days_2 - progress_time_days;
                                                }
                                                if (total_ssk_months gte progress_time_months)
                                                    total_ssk_months = total_ssk_months - progress_time_months;
                                                else {
                                                    total_ssk_months = total_ssk_months + 12;
                                                    total_ssk_years = total_ssk_years - 1;
                                                    total_ssk_months = total_ssk_months - progress_time_months;
                                                }		
                                                total_ssk_years = total_ssk_years - progress_time_years;
                                                total_ssk_days = (total_ssk_years * 365) + (total_ssk_months * 30);	
                                                gun_sayisi = total_ssk_days+1;
                                            }
                                        </cfscript>
                                    #gun_sayisi#
                                    </td>
                                    <td>
                                        <cfset bos_gecen = 0>
                                        <cfquery name="get_this_" dbtype="query">
                                            SELECT 
                                                * 
                                            FROM 
                                                get_progress_payment_out 
                                            WHERE
                                                EMP_ID = #employee_id#
                                        </cfquery>
                                        <cfif get_this_.recordcount>
                                            <cfloop query="get_this_">
                                                <cfif len(get_this_.finish_date)>
                                                    <cfset bos_gecen = bos_gecen + datediff("d",get_this_.start_date,get_this_.finish_date)+1>
                                                <cfelse>
                                                    <cfset bos_gecen = bos_gecen + datediff("d",get_this_.start_date,puantaj_start_)+1>
                                                </cfif>
                                            </cfloop>
                                        </cfif>
                                        #bos_gecen#
                                    </td>
                                    <td>#(gun_sayisi)-bos_gecen#</td>
                                    <!--- <cfquery name="get_yillik_izin_" datasource="#dsn#">
                                        SELECT
                                            OFFTIME.EMPLOYEE_ID,
                                            OFFTIME.STARTDATE,
                                            OFFTIME.FINISHDATE
                                        FROM
                                            OFFTIME
                                            INNER JOIN SETUP_OFFTIME ON OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
                                        WHERE
                                            OFFTIME.EMPLOYEE_ID = #EMPLOYEE_ID# AND
                                            OFFTIME.VALID = 1 AND
                                            OFFTIME.IS_PUANTAJ_OFF = 0 AND
                                            SETUP_OFFTIME.IS_YEARLY = 1 AND
                                            OFFTIME.STARTDATE <= #puantaj_start_# AND 
                                            OFFTIME.FINISHDATE >= #createodbcdatetime(KIDEM_DATE)#
                                    </cfquery> --->

                                    <cfquery name="get_old_calisma" datasource="#dsn#">
                                        SELECT 
                                            EP.EMPLOYEE_ID,
                                            EP.RELATED_COMPANY,
                                            EP.STARTDATE,
                                            EP.FINISHDATE,
                                            B.BRANCH_NAME,
                                            O.NICK_NAME
                                        FROM 
                                            EMPLOYEE_PROGRESS_PAYMENT EP
                                            INNER JOIN BRANCH B ON EP.BRANCH_ID = B.BRANCH_ID
                                            INNER JOIN OUR_COMPANY O ON EP.COMP_ID = O.COMP_ID
                                        WHERE
                                            EP.EMPLOYEE_ID = #EMPLOYEE_ID#
                                        ORDER BY 
                                            EP.EMPLOYEE_ID DESC,
                                            STARTDATE DESC
                                    </cfquery>

                                    <cfif get_old_calisma.recordcount>
                                        <cfloop query="#get_old_calisma#">
                                            <cfif get_old_calisma.currentrow neq 1 and get_old_calisma.employee_id[currentrow-1] eq get_old_calisma.employee_id>
                                                <cfset 'old_calisma_#get_old_calisma.employee_id#' = evaluate("old_calisma_#get_old_calisma.employee_id#") & '<b>***</b>' & '#get_old_calisma.related_company# - #get_old_calisma.BRANCH_NAME#-#get_old_calisma.NICK_NAME#/#dateformat(get_old_calisma.startdate,"dd.mm.yyyy")#-#dateformat(get_old_calisma.finishdate,"dd.mm.yyyy")#'>
                                            <cfelse>
                                                <cfset 'old_calisma_#get_old_calisma.employee_id#' = '#get_old_calisma.related_company# - #get_old_calisma.BRANCH_NAME#-#get_old_calisma.NICK_NAME#/#dateformat(get_old_calisma.startdate,"dd.mm.yyyy")#-#dateformat(get_old_calisma.finishdate,"dd.mm.yyyy")#'>
                                            </cfif>
                                        </cfloop>
                                    </cfif>

                                    <cfscript>
                                        kideme_dahil_hesap_tutari = kideme_esas_maas + (total_kidem/12);
                                        kidem_ihbar_gunu_ = (gun_sayisi-bos_gecen+1);
                                        
                                        if(not len(kidem_max))kidem_max = 0;

                                        if(attributes.FINISH_DATE_COUNT_TYPE eq 1)
                                        {
                                            kidem_amount_ = 0;
                                            if (kidem_max lte kideme_dahil_hesap_tutari)
                                                temp_kidem_ucret = kidem_max;
                                            else
                                                temp_kidem_ucret = kideme_dahil_hesap_tutari;
                                            if (total_ssk_years gt 0)
                                            kidem_amount_ = kidem_amount_ + (temp_kidem_ucret * total_ssk_years);
                                            if (total_ssk_months gt 0)
                                            kidem_amount_ = kidem_amount_ + (temp_kidem_ucret / 12 * total_ssk_months);
                                            if (total_ssk_days_2 gt 0)
                                            {
                                                if(isDefined("x_calculate_kidem") and len(x_calculate_kidem) and x_calculate_kidem eq 365)
                                                    kidem_amount_ = kidem_amount_ + (temp_kidem_ucret / 365 * total_ssk_days_2);
                                                else
                                                    kidem_amount_ = kidem_amount_ + (temp_kidem_ucret / 12 / 30 * total_ssk_days_2);	
                                            }	
                                        }
                                        else
                                        {
                                            if (kidem_max lte kideme_dahil_hesap_tutari)
                                            {
                                                kidem_amount_ = (kidem_max * (total_ssk_days-paid_kidem_days)) / 365;
                                            }
                                            else 
                                            {
                                                kidem_amount_ = (kideme_dahil_hesap_tutari * (total_ssk_days-paid_kidem_days)) / 365;
                                            }
                                        }
                                    </cfscript>
                                    <cfif get_module_power_user(48)>
                                    <td format="numeric">
                                        <cfif kidem_max lte kideme_dahil_hesap_tutari>
                                            <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(kidem_max)#">
                                        <cfelse>
                                            <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(kideme_dahil_hesap_tutari)#">
                                        </cfif>					
                                    </td>
                                    <td format="numeric">
                                    <cfif (gun_say eq 365 and Kıdem_gun gte 365) or (gun_say eq 360 and Kıdem_gun gte 360)>
                                        <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(kidem_amount_)#">
                                    <cfelse>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(0)#">
                                    </cfif>
                                    </td>
                                    </cfif>
                                    <td>
                                        <cfif kidem_ihbar_gunu_ gte ihbar_1_s_ and kidem_ihbar_gunu_ lte ihbar_1_f_>
                                            <cfset ihbar_gunu_ = ihbar_1_g_>
                                        <cfelseif kidem_ihbar_gunu_ gte ihbar_2_s_ and kidem_ihbar_gunu_ lte ihbar_2_f_>
                                            <cfset ihbar_gunu_ = ihbar_2_g_>
                                        <cfelseif kidem_ihbar_gunu_ gte ihbar_3_s_ and kidem_ihbar_gunu_ lte ihbar_3_f_>
                                            <cfset ihbar_gunu_ = ihbar_3_g_>
                                        <cfelseif kidem_ihbar_gunu_ gte ihbar_4_s_ and kidem_ihbar_gunu_ lte ihbar_4_f_>
                                            <cfset ihbar_gunu_ = ihbar_4_g_>
                                        <cfelseif len(ihbar_5_s_) and len(ihbar_5_f_) and (kidem_ihbar_gunu_ gte ihbar_5_s_ and kidem_ihbar_gunu_ lte ihbar_5_f_)>
                                            <cfset ihbar_gunu_ = ihbar_5_g_>
                                        <cfelseif len(ihbar_6_s_) and len(ihbar_6_f_) and (kidem_ihbar_gunu_ gte ihbar_6_s_ and kidem_ihbar_gunu_ lte ihbar_6_f_)>
                                            <cfset ihbar_gunu_ = ihbar_6_g_>
                                        <cfelse>
                                            <cfset ihbar_gunu_ = 0>
                                        </cfif>
                                        #ihbar_gunu_#
                                    </td>
                                    <cfif get_module_power_user(48)>
                                    <td format="numeric"><cfif ihbar_gunu_ gt 0><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(kideme_dahil_hesap_tutari / 30 * ihbar_gunu_)#"></cfif></td>
                                    <td format="numeric">
                                        <cfif ihbar_gunu_ gt 0>
                                            <cfset kes1_ = kideme_dahil_hesap_tutari / 30 * ihbar_gunu_ * 6.6 / 1000>
                                            <cfset kes2_ = kideme_dahil_hesap_tutari / 30 * ihbar_gunu_ * 15 / 100>
                                            <cfset ihbar_net_ = (kideme_dahil_hesap_tutari / 30 * ihbar_gunu_) - kes1_ - kes2_>
                                            <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(ihbar_net_)#">
                                        </cfif>
                                    </td>
                                    </cfif>
                                    <td><cfif isdefined("old_calisma_#employee_id#")>#evaluate("old_calisma_#employee_id#")#</cfif></td>
                                    <td><cfif isdefined("old_sgk_days") and len(old_sgk_days)>#wrk_round(old_sgk_days)#</cfif></td>
                                    <td><cfif isdefined("old_sgk_days") and len(old_sgk_days)>#(gun_sayisi)-bos_gecen+old_sgk_days#<cfelse>#(gun_sayisi)-bos_gecen#</cfif></td>
                                    <td>#dateformat(first_ssk_date,dateformat_style)#</td>
                            <cfelse>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <cfloop from="12" to="1" index="x_ay" step="-1">
                                    <td>&nbsp;</td>
                                </cfloop>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </cfif>
                            <cfif isDefined("x_show_level") and x_show_level eq 1>
                                <td>                            
                                    <cfset up_dep_len = listlen(HIERARCHY_DEP_ID1,'.')>
                                    <cfif up_dep_len gt 0>
                                        <cfset temp = up_dep_len> 
                                        <cfloop from="1" to="#up_dep_len#" index="i" step="1">
                                            <cfif isdefined("HIERARCHY_DEP_ID1") and listlen(HIERARCHY_DEP_ID1,'.') gt temp>
                                                <cfset up_dep_id = ListGetAt(HIERARCHY_DEP_ID1, listlen(HIERARCHY_DEP_ID1,'.')-temp,".")>
                                                <cfquery name="get_upper_departments" datasource="#dsn#">
                                                    SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
                                                </cfquery>
                                                <cfset up_dep_head = get_upper_departments.department_head>
                                                #up_dep_head# 
                                                    <cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
                                                    <cfif get_org_level.recordcount>
                                                        (#get_org_level.ORGANIZATION_STEP_NAME#)
                                                    </cfif>
                                                <cfif up_dep_len neq i>
                                                    >
                                                </cfif>
                                            <cfelse>
                                                <cfset up_dep_head = ''>
                                            </cfif>
                                            <cfset temp = temp - 1>
                                        </cfloop>
                                    </cfif>​
                                </td>
                            </cfif>
                            <td>
                                <cfif sex eq 0>
                                    <cf_get_lang dictionary_id='58958.Kadın'>   
                                <cfelseif sex eq 1>
                                    <cf_get_lang dictionary_id='58959.Erkek'>
                                </cfif>
                            </td>
                            <td>
                                <cfloop list="#list_ucret()#" index="ccn">
                                    <cfset count= listfindnocase(list_ucret(),#SSK_STATUTE#,',')>
                                    <cfif SSK_STATUTE eq ccn>#listgetat(list_ucret_names(),count,'*')#</cfif>
                                </cfloop>
                            </td>
                            <td>
                                <cfloop list="#reason_order_list()#" index="ccc">
                                    <cfset value_name_ = listgetat(reason_list(),ccc,';')>
                                    <cfset value_id_ = ccc>
                                    <cfif value_id_ eq explanation_id>#value_name_#</cfif>
                                </cfloop>
                            </td>
                            <td>#DEFECTION_LEVEL#</td>
                        </tr>
                        <cfset attributes.branch_id = temp_branch_id>
                    </cfoutput>
                </tbody>
            </cf_report_list>
        </div> 
    <cfelse>
        <cf_report_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="58577.Sıra"></th>
                    <th><cf_get_lang dictionary_id="57576.Çalışan"></th>
                    <th><cf_get_lang dictionary_id="38955.İlgili Şirket"></th>
                    <th><cf_get_lang dictionary_id="57453.Şube"></th>
                    <th><cf_get_lang dictionary_id="57572.Departman"></th>
                    <th><cf_get_lang dictionary_id="59004.Pozisyon Tipi"></th>
                    <th><cf_get_lang dictionary_id="57571.Ünvan"></th>
                    <th><cf_get_lang dictionary_id="58487.Çalışan No"></th>
                    <th><cf_get_lang dictionary_id="39269.Sigorta No"></th>
                    <th><cf_get_lang dictionary_id="58025.TC Kimlik No"></th> 
                    <th><cf_get_lang dictionary_id="39429.Gruba Giriş"></th>
                    <th><cf_get_lang dictionary_id="39070.İzin Baz Tarihi"></th>
                    <th><cf_get_lang dictionary_id="39279.Şirkete Giriş"></th>
                    <th><cf_get_lang dictionary_id="38907.Kıdem Baz"></th>
                    <th><cf_get_lang dictionary_id="29438.Çıkış Tarihi"></th>
                    <th><cf_get_lang dictionary_id="58727.Doğum Tarihi"></th>
                    <th><cf_get_lang dictionary_id="39287.Toplam Hakedilen İzin Günü"></th>
                    <th><cf_get_lang dictionary_id="39288.En Son Hakedilen"></th>
                    <th><cf_get_lang dictionary_id="39296.Geçmiş Dönem Kullanılan İzin"></th>
                    <th><cf_get_lang dictionary_id="39310.Toplam Kullanılan İzin"></th>
                    <th><cf_get_lang dictionary_id="39311.Toplam Kullanılmayan İzin"></th>
                    <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39312.Tahmini İzin Yükü Brüt"></th></cfif>
                    <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39315.Tahmini İzin Yükü Net"></th></cfif>
                    <th><cf_get_lang dictionary_id="39316.Son İzin Hakediş Tarihi"></th>
                    <th><cf_get_lang dictionary_id="39325.İzin Kullanım Bitiş Tarihi"></th>
                    <th><cf_get_lang dictionary_id="39330.Son Dönem İzni Kullanılan"></th>
                    <th><cf_get_lang dictionary_id="39347.Son Dönem İzni Kalan"></th>
                    <th><cfoutput>#year(attributes.finish_date)-1#</cfoutput> 2. <cf_get_lang dictionary_id="39360.Dönem Mutabakat Tarihi"></th>
                    <th><cfoutput>#year(attributes.finish_date)-1#</cfoutput> 2. <cf_get_lang dictionary_id="39365.Dönem Mutabakat Günü"></th>
                    <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 1. <cf_get_lang dictionary_id="39367.İzin Mutabakat Tarihi"></th>
                    <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 1.<cf_get_lang dictionary_id="39369.İzin Mutabakat Günü"></th>
                    <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 2.<cf_get_lang dictionary_id="39367.İzin Mutabakat Tarihi"></th>
                    <th><cfoutput>#year(attributes.finish_date)#</cfoutput> 2.<cf_get_lang dictionary_id="39369.İzin Mutabakat Günü"></th>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39384.Ücret Maaş"></th></cfif>
                        <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39385.Kıdeme Esas Maaş"></th></cfif>
                        <cfif get_module_power_user(48)>
                        <cfoutput>
                            <cfloop from="12" to="1" index="x_ay" step="-1">
                                <th>#month(dateadd("m",(-x_ay+1),puantaj_start_))#-#year(dateadd("m",(-x_ay+1),puantaj_start_))#</th>
                            </cfloop>
                        </cfoutput>
                        </cfif>
                    <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="39986.Ek Ödenek"></th></cfif>
                    <th><cf_get_lang dictionary_id="39386.Toplam Geçen Gün"></th>
                    <th><cf_get_lang dictionary_id="39387.Boş Geçen Gün"></th>
                    <th><cf_get_lang dictionary_id="39388.Kıdem Günü"></th>
                    <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39389.Kıdem Matrahı"></th></cfif>
                    <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39402.Kıdem Tutarı"></th></cfif>
                    <th><cf_get_lang dictionary_id="39406.İhbar Günü"></th>
                    <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39409.İhbar Tutarı"></th></cfif>
                    <cfif get_module_power_user(48)><th><cf_get_lang dictionary_id="39413.İhbar Tutarı Tahmini Net"></th></cfif>
                    <th><cf_get_lang dictionary_id="39415.Eski Çalışmalar"></th>
                    <th><cf_get_lang dictionary_id="61005.Toplam Kıdem"></th>
                </tr>
                </thead> 
            <tbody>
                <tr>
                    <td colspan="57"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                </tr>
            </tbody>
        </cf_report_list>
    </cfif>
<cfelse>
    <cfset get_emp.recordcount = 0>
</cfif>
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=get_emp.recordcount>
</cfif>
</div>
<cfif isdefined("attributes.is_submit") and attributes.totalrecords gt attributes.maxrows>
<cfscript>
    url_str = "&is_submit=1";
    if (isdefined('attributes.keyword') and len(attributes.keyword))
        url_str = "#url_str#&keyword=#attributes.keyword#";
    if (isdefined('attributes.comp_id') and len(attributes.comp_id))
        url_str = "#url_str#&comp_id=#attributes.comp_id#";
    if (isdefined('attributes.branch_id') and len(attributes.branch_id))
        url_str = "#url_str#&branch_id=#attributes.branch_id#";
    if (isdefined('attributes.pos_cat_id') and len(attributes.pos_cat_id))
        url_str = "#url_str#&pos_cat_id=#attributes.pos_cat_id#";
    if (isdefined('attributes.finish_date') and len(attributes.finish_date))
        url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#";
    if (isdefined('attributes.gun_say') and len(attributes.gun_say))
        url_str = "#url_str#&gun_say=#attributes.gun_say#";
    if (isdefined('attributes.department') and len(attributes.department))
        url_str = "#url_str#&department=#attributes.department#";
    if (isdefined('attributes.emp_status') and len(attributes.emp_status))
        url_str = "#url_str#&emp_status=#attributes.emp_status#";
</cfscript>
<cf_paging page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#attributes.fuseaction##url_str#">
</cfif>
<script type="text/javascript">
    /* <cfif attributes.is_excel eq 1>
		$(function(){TableToExcel.convert(document.getElementById('offtimes_report_excel'));});
	</cfif> */
	document.getElementById('keyword').focus();
    function control()	
	{  
         if(document.getElementById('finish_date').value == '')
        {
            alert("<cf_get_lang dictionary_id='40466.Lütfen Tarih Değerlerini Eksiksiz Doldurunuz'>");
            return false;
        }
		if(document.ara_form.is_excel.checked==false)
		{
			document.ara_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.hr_offtimes_report</cfoutput>";
			return true;
		}
		else 
        {
            document.ara_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_hr_offtimes_report</cfoutput>";
            <cfif isDefined("attributes.is_submit")>
                $('#maxrows').val('<cfoutput>#get_emp.recordcount#</cfoutput>');
            <cfelse>
                $('#maxrows').val('<cfoutput>#attributes.maxrows#</cfoutput>');
            </cfif>
        }
    }    
    function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}    
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}

</script>
