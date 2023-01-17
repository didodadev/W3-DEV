<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
<script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
<cfset get_employee_shift = createObject("component","V16.hr.cfc.get_employee_shift")>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.send_status" default="">
<cfparam name="attributes.confirm_status" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.period_year" default="">
<cfparam name="attributes.keyword" default="">

<cfset genel_izin_toplam = 0>
<cfset genel_dk_toplam = 0>
<cfset kisi_izin_toplam = 0>
<cfset kisi_izin_sayilmayan = 0>
<cfset izin_sayilmayan = 0>

<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<!--- çalışma saati başlangıç ve bitişleri al--->
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
	<cfif get_work_time.recordcount>
		<cfloop query="get_work_time">	
			<cfif PROPERTY_NAME eq 'start_hour_info'>
				<cfset start_hour = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'start_min_info'>
				<cfset start_min = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'finish_hour_info'>
				<cfset finish_hour = PROPERTY_VALUE>
			<cfelseif PROPERTY_NAME eq 'finish_min_info'>
				<cfset finish_min = PROPERTY_VALUE>
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
		<cfset finish_am_hour = '00'>
		<cfset finish_am_min = '00'>
		<cfset start_pm_hour = '00'>
		<cfset start_pm_min = '00'>
		<cfset x_min_control = 0>
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
<!--- Filtre BEGIN --->	
    <cfscript>
        attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
        
        cmp_period_year = createObject("component","V16.hr.cfc.get_period_year");
        cmp_period_year.dsn = dsn;
        get_period_year = cmp_period_year.get_period_year()
        
        cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
        cmp_pos_cat.dsn = dsn;
        get_position_cats_ = cmp_pos_cat.get_position_cat();
        cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp");
        cmp_branch.dsn = dsn;
        get_branches = cmp_branch.get_branch(ehesap_control:1,branch_status:attributes.is_active);
        if (isdefined('attributes.branch_id') and isnumeric(attributes.branch_id))
        {
            cmp_department = createObject("component","V16.hr.cfc.get_departments");
            cmp_department.dsn = dsn;
            get_department = cmp_department.get_department(branch_id:attributes.branch_id);
        }
    </cfscript>
<!--- Filtre END --->
<!--- Search Qery BEGIN --->
    <cfscript>
        url_str = "ehesap.hr_offtime_approve&event=batch&keyword=#attributes.keyword#";
        if (isdefined("attributes.form_submitted"))
            url_str = "#url_str#&form_submitted=#attributes.form_submitted#";	
        if (len(attributes.position_name))
            url_str="#url_str#&position_name=#attributes.position_name#";
        if (len(attributes.position_cat_id))
            url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
        if (isdefined("attributes.branch_id"))
            url_str = "#url_str#&branch_id=#attributes.branch_id#";
        if (isdefined("attributes.department"))
            url_str = "#url_str#&department=#attributes.department#";
        if (isdefined("attributes.period_year"))
            url_str = "#url_str#&period_year=#attributes.period_year#";
        if (isdefined("attributes.form_submitted"))
        {
            cmp_emps = createObject("component","V16.hr.cfc.get_employee");
            cmp_emps.dsn = dsn;
            get_employee = cmp_emps.get_employee(
                keyword: attributes.keyword,
                position_cat_id: attributes.position_cat_id,
                branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
                position_name: attributes.position_name,
                department: '#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
                fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
                database_type: database_type,
                maxrows: attributes.maxrows,
                startrow: attributes.startrow
            );
        }
        else
        {
            get_employee.recordcount = 0;
        }
    </cfscript>
<!--- Search Qery END --->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="leave_reconciliation" action="#request.self#?fuseaction=#url.fuseaction#&event=batch">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
            <cf_box_search plus="0">        	
                        <div class="form-group">
                            <input type="text" name="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="50" placeholder="<cfoutput>#getLang('main',48)#</cfoutput>">
                        </div>
                        <div class="form-group">
                            <select name="period_year" id="period_year">
                                <cfoutput query="get_period_year">
                                    <option value="#PERIOD_YEAR#" <cfif isdefined("attributes.period_year") and attributes.period_year eq PERIOD_YEAR> selected <cfelseif len(attributes.period_year) eq 0 AND session.ep.PERIOD_YEAR eq PERIOD_YEAR>selected</cfif>>#PERIOD_YEAR#</option>
                                </cfoutput>
                            </select>
                        </div>
                        <div class="form-group small">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                        </div>
                        <div class="form-group">
                            <cf_wrk_search_button button_type="4">                        
                        </div>
                        <div class="form-group">
                            <a class="ui-btn ui-btn-gray" href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a>
                        </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">					
                            <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                                <option value="all" <cfif isdefined("attributes.branch_id") and attributes.branch_id is 'all'>selected</cfif>><cf_get_lang dictionary_id='57453.Şube'></option>
                                <cfoutput query="get_branches" group="NICK_NAME">
                                    <optgroup label="#get_branches.NICK_NAME#"></optgroup>
                                    <cfoutput>
                                        <option value="#get_branches.BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq get_branches.branch_id)> selected</cfif>>#get_branches.BRANCH_NAME#</option>
                                    </cfoutput>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <cfoutput>
                    <div class="form-group" id="item-department">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="DEPARTMENT_PLACE">					
                            <select name="department" id="department">
                                <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                                <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                    <cfloop query="get_department">
                                        <option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_department.department_id)>selected</cfif>>#department_head#</option>
                                    </cfloop>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_cat_id">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">					
                            <select name="position_cat_id" id="position_cat_id">
                                <option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>
                                <cfloop query="GET_POSITION_CATS_">
                                    <option value="#position_cat_id#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    </cfoutput>
                </div>                
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','İzin Mutabakatları','31567')#" uidrop="1" id="create_approve_app">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th> 
                    <th width="180"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th width="125"><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th width="125"><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th width="35"><cf_get_lang dictionary_id='58472.Dönem'></th>
                    <th width="45"><cf_get_lang dictionary_id='31404.Toplam Hakedilen İzin'></th>
                    <th width="90"><cf_get_lang dictionary_id='40601.Önceki Dönemden Devredenler'></th>
                    <th width="90"><cf_get_lang dictionary_id='59770.Önceki Dönem Kullanılan İzin Günü'></th>
                    <th width="90"><cf_get_lang dictionary_id="59771.İlgili Dönem Hakedilen İzin Günü"></th>
                    <th width="90"><cf_get_lang dictionary_id="59772.İlgili Dönem Kullanılan İzin Günü"></th>
                    <th width="45"><cf_get_lang dictionary_id='63448.İlgili Yıl Kalan'></th>
                    <th width="45"><cf_get_lang dictionary_id="59773.Toplam Kalan"></th>
                    <th width="15" class="text-center"><i class="fa fa-paper-plane"></i></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_employee.recordcount>
                        <cfobject component="/WMO/GeneralFunctions" name="GnlFunctions">
                        <cfset attributes.totalrecords = get_employee.query_count>
                        <cfloop query="get_employee">
                            <cfset genel_dk_toplam = 0>
                            <cfset genel_izin_toplam = 0>
                            <cfset response = StructNew()>
                            <cfset response.status = true>
                            <cfset response.emp = #EMPLOYEE_ID#>
                            <cfset response.ilgili_yil_hakedilen = 0>
                            <cfset response.gecmis_sgk_gun = 0>
                            <cfset response.kidem = 0>
                            <cfset response.toplam_hakedilen_izin = 0>
                            <cfset response.gecmis_donem_kullanilan = 0>
                            <cfset response.ilgili_yil_kullanilan_izin = 0>
                            <cfset response.kalan_izin = 0>
                            <cfset response.period = "#attributes.period_year#-12-31">

                            <!--- İzin Hesabı BEGIN --->
                                <cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
                                    SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
                                </cfquery> <!--- Tatil Günleri --->
                                <cfquery name="get_emp" datasource="#dsn#">
                                    SELECT 
                                        E.EMPLOYEE_ID,
                                        E.EMPLOYEE_NAME,
                                        E.EMPLOYEE_SURNAME,
                                        E.KIDEM_DATE,
                                        E.IZIN_DATE,
                                        E.IZIN_DAYS,
                                        E.OLD_SGK_DAYS,
                                        EI.BIRTH_DATE,
                                        E.GROUP_STARTDATE,
                                        (SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#response.period#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#response.period#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS,
                                        (SELECT TOP 1 FINISH_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#response.period#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#response.period#"> ORDER BY START_DATE DESC) AS FINISH_DATE
                                    FROM
                                        EMPLOYEES E
                                        INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
                                    WHERE 
                                        E.EMPLOYEE_ID = #EMPLOYEE_ID#
                                </cfquery>

                                <cfif len(get_emp.IZIN_DATE)>
                                    <!--- İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLER --->						
                                    <cfquery name="get_offtime_old" datasource="#dsn#">
                                        SELECT 
                                            OFFTIME.*,
                                            SETUP_OFFTIME.OFFTIMECAT_ID,
                                            SETUP_OFFTIME.OFFTIMECAT,
                                            SETUP_OFFTIME.IS_PAID,
                                            SETUP_OFFTIME.CALC_CALENDAR_DAY
                                        FROM 
                                            OFFTIME,
                                            SETUP_OFFTIME
                                        WHERE
                                            SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
                                            OFFTIME.IS_PUANTAJ_OFF = 0 AND
                                            OFFTIME.VALID = 1 AND
                                            SETUP_OFFTIME.IS_PAID = 1 AND
                                            SETUP_OFFTIME.IS_YEARLY = 1	AND
                                            EMPLOYEE_ID = #EMPLOYEE_ID# AND
                                            OFFTIME.FINISHDATE < <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.izin_date#">
                                        ORDER BY
                                            STARTDATE DESC
                                    </cfquery>
                                    <!--- // İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLER --->
                                </cfif>

                                <cfquery name="get_progress_payment_out" datasource="#dsn#">
                                    SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#">
                                </cfquery>

                                <cfquery name="get_progress_payment_outs" datasource="#dsn#">
                                    SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#"> AND START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
                                </cfquery>

                                <cfquery name="get_eski_izinler" datasource="#DSN#">
                                    SELECT 
                                        EP.*,
                                        B.BRANCH_NAME,
                                        O.NICK_NAME
                                    FROM 
                                        EMPLOYEE_PROGRESS_PAYMENT EP,
                                        BRANCH B,
                                        OUR_COMPANY O
                                    WHERE
                                        EP.EMPLOYEE_ID = #EMPLOYEE_ID# AND
                                        EP.BRANCH_ID = B.BRANCH_ID AND
                                        EP.COMP_ID = O.COMP_ID
                                    ORDER BY STARTDATE
                                </cfquery>
                                <cfquery name="get_in_out_other" datasource="#dsn#">
                                    SELECT 
                                        EI.EMPLOYEE_ID,
                                        EI.IN_OUT_ID,
                                        EI.POSITION_CODE,
                                        EI.START_DATE,
                                        EI.FINISH_DATE,
                                        BRANCH.BRANCH_NAME,
                                        DEPARTMENT.DEPARTMENT_HEAD,
                                        OUR_COMPANY.NICK_NAME,
                                        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE
                                    FROM
                                        EMPLOYEES_IN_OUT EI
                                        LEFT JOIN EMPLOYEES AS E ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID,
                                        BRANCH,
                                        DEPARTMENT,
                                        OUR_COMPANY
                                    WHERE
                                        EI.EMPLOYEE_ID = #EMPLOYEE_ID# AND
                                        DEPARTMENT.DEPARTMENT_ID = EI.DEPARTMENT_ID
                                        AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                                        AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
                                    ORDER BY EI.START_DATE DESC
                                </cfquery>
                                
                                <cfset genel_izin_toplam = 0>
                                <cfscript>
                                    toplam_hakedilen_izin = 0;
                                    genel_izin_toplam = 0;
                                    old_days = 0;
                                </cfscript>
                                <cfquery name="get_offtime" datasource="#dsn#">
                                    SELECT 
                                        OFFTIME.*,
                                        SETUP_OFFTIME.*
                                    FROM 
                                        OFFTIME,
                                        SETUP_OFFTIME
                                    WHERE
                                        <cfif isdefined('get_emp.IZIN_DATE') and len(get_emp.IZIN_DATE)>
                                            OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.IZIN_DATE#"> AND
                                        </cfif>
                                        SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
                                        OFFTIME.IS_PUANTAJ_OFF = 0 AND
                                        OFFTIME.VALID = 1 AND
                                        SETUP_OFFTIME.IS_PAID = 1 AND
                                        SETUP_OFFTIME.IS_YEARLY = 1 AND
                                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#"> AND
                                        (OFFTIME.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#response.period#"> OR
                                        OFFTIME.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#response.period#">)
                                    ORDER BY
                                        STARTDATE DESC
                                </cfquery>

                                <!--- çalışma saati başlangıç ve bitişleri al--->
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
                                        PROPERTY_NAME = 'finish_min_info'
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
                                <cfif get_work_time.recordcount>
                                    <cfloop query="get_work_time">	
                                        <cfif PROPERTY_NAME eq 'start_hour_info'>
                                            <cfset start_hour = PROPERTY_VALUE>
                                        <cfelseif PROPERTY_NAME eq 'start_min_info'>
                                            <cfset start_min = PROPERTY_VALUE>
                                        <cfelseif PROPERTY_NAME eq 'finish_hour_info'>
                                            <cfset finish_hour = PROPERTY_VALUE>
                                        <cfelseif PROPERTY_NAME eq 'finish_min_info'>
                                            <cfset finish_min = PROPERTY_VALUE>
                                        </cfif>
                                    </cfloop>
                                <cfelse>
                                    <cfset start_hour = '00'>
                                    <cfset start_min = '00'>
                                    <cfset finish_hour = '00'>
                                    <cfset finish_min = '00'>
                                </cfif>		
                                <script>
                                    function save_employee_izin_days(emp_id)
                                    {
                                        var day_ = 	filterNum(document.getElementById('employee_izin_days').value);
                                        var adres_ = '<cfoutput>#request.self#?fuseaction=hr.emptypopup_upd_employee_offdays</cfoutput>';
                                        var adres_ = adres_ + '&employee_id=' + emp_id;
                                        var adres_ = adres_ + '&izin_days=' + day_;
                                        AjaxPageLoad(adres_,'employee_izin_days_div',0,'Kaydediliyor');
                                    }
                                </script>
                                <cfset offday_list_ = ''>
                                <cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
                                <cfset halfofftime_list2 = ''>
                                <cfset halfofftime_list3 = ''>
                                <cfoutput query="GET_GENERAL_OFFTIMES">
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
                                <cfquery name="get_emp_in_out" datasource="#dsn#">
                                    SELECT   
                                        TOP 1 OUR_COMPANY.COMP_ID AS COMP_ID,
                                        IS_VARDIYA
                                    FROM
                                        EMPLOYEES_IN_OUT EI,
                                        BRANCH,
                                        DEPARTMENT,
                                        OUR_COMPANY
                                    WHERE
                                        EI.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#EMPLOYEE_ID#"> AND
                                        DEPARTMENT.DEPARTMENT_ID = EI.DEPARTMENT_ID
                                        AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                                        AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
                                    ORDER BY EI.IN_OUT_ID DESC
                                </cfquery>
                                <cfif get_emp_in_out.recordCount>
                                    <cfquery name="get_hours" datasource="#dsn#">
                                        SELECT		
                                            OUR_COMPANY_HOURS.*
                                        FROM
                                            OUR_COMPANY_HOURS
                                        WHERE
                                            OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
                                            OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
                                            OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
                                            OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_in_out.comp_id#"><!---Çalışan kartındaki son şirkete göre---->
                                    </cfquery>
                                <cfelse>
                                    <cfset get_hours.recordcount = 0>
                                </cfif>
                                <cfscript>
                                    if (get_hours.recordcount and len(get_hours.weekly_offday))
                                        this_week_rest_day_ = get_hours.weekly_offday;
                                    else
                                        this_week_rest_day_ = 1;
                                    if (len(get_emp.izin_days))
                                        old_days = get_emp.izin_days;
                                    else
                                        old_days = 0;
                                    
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
                                </cfscript>

                                <!--- İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLERİ GETİR --->
                                <cfif len(get_emp.izin_date) and get_offtime_old.recordcount>
                                    <cfset izin_sayilmayan_ = 0>
                                    <cfoutput query="get_offtime_old">
                                        <!--- Çalışanın vardiyalı çalışma saatleri --->
										<cfset finishdate_ = dateadd("d", 1, finishdate)>
										<cfset get_shift = get_employee_shift.get_emp_shift(employee_id : employee_id, start_date : startdate, finish_date : finishdate_, control : 0)>
                                        <cfquery name="get_pre_offtime_" dbtype="query">
                                            SELECT
                                                STARTDATE
                                            FROM
                                                get_offtime
                                            WHERE
                                                STARTDATE < '#get_offtime_old.startdate#'
                                            ORDER BY 
                                                STARTDATE DESC
                                        </cfquery>
                                        <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                                            SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_offtime_old.startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_offtime_old.startdate#"> AND
                                            <cfif len(get_emp.PUANTAJ_GROUP_IDS)>
                                            (
                                                <cfloop from="1" to="#listlen(get_emp.PUANTAJ_GROUP_IDS)#" index="i">
                                                    ','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(get_emp.PUANTAJ_GROUP_IDS,i,',')#,%' <cfif listlen(get_emp.PUANTAJ_GROUP_IDS) neq i>OR</cfif> 
                                                </cfloop>
                                            )
                                            <cfelse>
                                                PUANTAJ_GROUP_IDS IS NULL
                                            </cfif>	
                                        </cfquery>
                                        <cfscript>
                                            if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
                                                day_control = get_offtime_cat.day_control;
                                            else
                                                day_control = 0;
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
                                            if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control_afternoon))
                                                day_control_afternoon = get_offtime_cat.day_control_afternoon;
                                            else
                                                day_control_afternoon = 0;
                                            
                                        </cfscript>
                                        <!--- İzin Hesapları bu dosyada yapılıyor ---->
                                        <cfif x_min_control eq 1>
                                            <cfif get_shift.recordcount>
                                                <cfinclude template="offtime_calc_shift.cfm">
                                            <cfelse>
                                                <cfinclude template="offtime_calc.cfm">
                                            </cfif>
                                            <!--- #TLFormat(total_day_calc,2)#  --->
                                        <cfelse>
                                            <cfif get_shift.recordcount gt 0 and get_emp_in_out.is_vardiya eq 2>
                                                <cfif len(get_shift.WEEK_OFFDAY)>
                                                    <cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
                                                <cfelse>
                                                    <cfset this_week_rest_day_ = 1>
                                                </cfif>
                                            <cfelse>
                                                <cfset this_week_rest_day_ = this_week_rest_day_>
                                            </cfif>
                                            <cfinclude template="offtime_calc_day.cfm">
                                            <!--- #izin_gun#  --->
                                        </cfif>
                                        <cfset izin_sayilmayan_ = izin_sayilmayan_ + temporary_sunday_total_ + temporary_sunday_total_>
                                        
                                    </cfoutput>
                                </cfif>
                                <cfset izin_sayilmayan = 0>
                                <cfif get_offtime.recordcount>
                                    <cfoutput query="get_offtime">
                                        <!--- Çalışanın vardiyalı çalışma saatleri --->
										<cfset finishdate_ = dateadd("d", 1, finishdate)>
										<cfset get_shift = get_employee_shift.get_emp_shift(employee_id : employee_id, start_date : startdate, finish_date : finishdate_, control : 0)>
                                        <cfquery name="get_pre_offtime" dbtype="query">
                                            SELECT
                                                STARTDATE
                                            FROM
                                                get_offtime
                                            WHERE
                                                STARTDATE < '#get_offtime.startdate#'
                                            ORDER BY 
                                                STARTDATE DESC
                                        </cfquery>
                                        <cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                                            SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value = '#get_offtime.startdate#'> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value = '#get_offtime.startdate#'> AND
                                            <cfif len(get_emp.PUANTAJ_GROUP_IDS)>
                                            (
                                                <cfloop from="1" to="#listlen(get_emp.PUANTAJ_GROUP_IDS)#" index="i">
                                                    ','+PUANTAJ_GROUP_IDS+',' LIKE '%,#listgetat(get_emp.PUANTAJ_GROUP_IDS,i,',')#,%' <cfif listlen(get_emp.PUANTAJ_GROUP_IDS) neq i>OR</cfif> 
                                                </cfloop>
                                            )
                                            <cfelse>
                                                PUANTAJ_GROUP_IDS IS NULL
                                            </cfif>	
                                        </cfquery>
                                        <cfscript>
                                            if (get_offtime_cat.recordcount and len(get_offtime_cat.saturday_on))
                                                saturday_on = get_offtime_cat.saturday_on;
                                            else
                                                saturday_on = 1;
                                            if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
                                                day_control = get_offtime_cat.day_control;
                                            else
                                                day_control = 0;
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

                                            if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control_afternoon))
                                                day_control_afternoon = get_offtime_cat.day_control_afternoon;
                                            else
                                                day_control_afternoon = 0;

                                            if (len(get_emp.izin_date))
                                                kidem=datediff('d',get_emp.izin_date,get_offtime.startdate);
                                            else
                                                kidem=0;
                                            kidem_yil=kidem/365;
                                            
                                            
                                        </cfscript>		
                                        <cfset get_offtimes = get_offtime>
                                        <cfif x_min_control eq 1>
                                            <cfif get_shift.recordcount>
                                                <cfinclude template="offtime_calc_shift.cfm">
                                            <cfelse>
                                                <cfinclude template="offtime_calc.cfm">
                                            </cfif>
                                        <cfelse>
                                            <cfif get_shift.recordcount gt 0>
                                                <cfif len(get_shift.WEEK_OFFDAY)>
                                                    <cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
                                                <cfelse>
                                                    <cfset this_week_rest_day_ = 1>
                                                </cfif>
                                            <cfelse>
                                                <cfset this_week_rest_day_ = this_week_rest_day_>
                                            </cfif>
                                            <cfinclude template="offtime_calc_day.cfm">
                                        </cfif>
                                        <cfset izin_sayilmayan = izin_sayilmayan + temporary_sunday_total_ + temporary_offday_total_>
                                    </cfoutput>		
                                </cfif>
                                    <cfif len(get_emp.izin_date)>
                                    <cfscript>
                                        tck = 0;
                                        tck_ = 0;
                                        old_tck = 0;
                                        toplam_hakedilen_izin = 0;
                                        my_giris_date = get_emp.IZIN_DATE;
                                        flag = true;
                                        baslangic_tarih_ = my_giris_date;
                                        my_baz_date = response.period;
                                        if(len(get_emp.FINISH_DATE))
                                        {
                                            finish_date = get_emp.FINISH_DATE;	
                                        }else{
                                            finish_date = '';
                                        }
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
                                            old_tck = datediff('yyyy',my_giris_date,my_baz_date) + 1;
                                            while(flag)
                                            {
                                                bitis_tarihi_ = createodbcdatetime(date_add("m",get_def_type.limit_1,baslangic_tarih_));
                                                baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
                                                get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#)");
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
                                                    eklenecek = get_def_type.limit_1_days;
                                                    if(len(get_emp.birth_date) and eklenecek lt get_def_type.min_max_days and (datediff("yyyy",get_emp.birth_date,kontrol_date) lt get_def_type.min_years or datediff("yyyy",get_emp.birth_date,kontrol_date) gt get_def_type.max_years))
                                                        eklenecek = get_def_type.min_max_days;
                                                    if(tck_ neq 1 and eklenecek neq 0) 
                                                    {
                                                        toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;                                            
                                                    }
                                                }
                                                ilk_tarih_ = baslangic_tarih_;
                                                baslangic_tarih_ = bitis_tarihi_;
                                                bitis_tarihi_ = date_add("m",get_def_type.limit_1,bitis_tarihi_);
                                                if(datediff("d",baslangic_tarih_,response.period) lt 0)				
                                                    flag = false;
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
                                            while(flag)
                                            {
                                                bitis_tarihi_ = createodbcdatetime(date_add("yyyy",1,baslangic_tarih_));
                                                baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
                                                ilk_tarih_ = baslangic_tarih_;
                                                baslangic_tarih_ = bitis_tarihi_;
                                                get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#)");	
                                                
                                                if(get_bos_zaman_.recordcount eq 0)
                                                {
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
                                                            if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year)
                                                            {
                                                                tck  = tck + int(old_sgk_year);
                                                            } 
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

                                                    tck = tck + 1; 
                                                    old_tck = old_tck + 1;
                                                    kontrol_date = bitis_tarihi_;
                                                    get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #bitis_tarihi_# AND FINISHDATE >= #bitis_tarihi_#"&tmp_group_id);	
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
                                                        //xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve hesaplama yılı girilen yıla eşitse 20191030ERU 
                                                        if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year)
                                                        {
                                                            tck  = tck + int(old_sgk_year);
                                                        }
                                                        if(tck neq 1 and eklenecek neq 0) 
                                                        {
                                                            toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;                                                
                                                        }
                                                    }
                                                }	
                                                ilk_tarih_ = baslangic_tarih_;
                                                baslangic_tarih_ = bitis_tarihi_;
                                                bitis_tarihi_ = date_add("yyyy",1,bitis_tarihi_);
                                                
                                                if((finish_date neq '' and datediff("yyyy",bitis_tarihi_,finish_date) lt 0) or (finish_date eq '' and datediff("yyyy",bitis_tarihi_,now()) lt 0))			
                                                {
                                                    flag = false;
                                                }
                                            }
                                        }
                                        response.ilgili_yil_hakedilen = eklenecek;
                                    </cfscript>
                                    <cfoutput>						
                                        <cfif get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year)>
                                            <cfif isdefined('old_tck') and len(old_tck)>
                                                <cfset response.gecmis_sgk_gun = tck-1>
                                            <cfelse>
                                                <cfset response.gecmis_sgk_gun = 0>
                                            </cfif>
                                            <cfif isdefined('tck') and len(tck)>
                                                <cfset response.kidem = old_tck-1>
                                            <cfelse>
                                                <cfset response.kidem = 0>
                                            </cfif>
                                        <cfelse>
                                            <cfif isdefined('tck') and len(tck)>
                                                <cfset response.kidem = tck-1>
                                            <cfelse>
                                                <cfset response.kidem = 0>
                                            </cfif>
                                        </cfif>
                                        <cfset response.toplam_hakedilen_izin = toplam_hakedilen_izin>
                                        <cfif old_days gt 0>
                                            <cfset response.gecmis_donem_kullanilan = old_days>
                                        </cfif>
                                        <cfset response.ilgili_yil_kullanilan_izin = genel_izin_toplam>
                                        <cfset response.kalan_izin = toplam_hakedilen_izin - genel_izin_toplam - old_days>
                                </cfoutput>
                                <cfelse>
                                    <cfset response.status = false>
                                    <cfset response.message = "İzin Baz Tarihi Girilmediğinden Detay Bilgisi Verilememektedir!">
                                </cfif>  
                            <!--- İzin Hesabı END --->
                            <tr  
                                <cfoutput> 
                                    :data-id="id_list[#rownum-1#]=#EMPLOYEE_ID#"
                                    :data-row="#rownum#"
                                    :data-status="0"
                                    :data-SAL_YEAR = "#attributes.period_year#" 
                                    :data-EX_SAL_YEAR_REMAINDER_DAY = "#(response.KALAN_IZIN+response.ilgili_yil_kullanilan_izin)-response.ilgili_yil_hakedilen#" 
                                    :data-EX_SAL_YEAR_OFTIME_DAY = "#response.gecmis_donem_kullanilan#"
                                    :data-SAL_YEAR_REMAINDER_DAY = "#response.ilgili_yil_hakedilen#" 
                                    :data-SAL_YEAR_OFTIME_DAY = "#response.ilgili_yil_kullanilan_izin#" 
                                </cfoutput>>
                                <cfoutput>                    
                                    <td title="#EMPLOYEE_ID#">#rownum#</td>
                                    <td <cfif len(last_surname)>title="Kızlık Soyadı : #last_surname#"</cfif>><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
                                    <td>#BRANCH_NAME#</td>
                                    <td>#DEPARTMENT_HEAD#</td>
                                    <td>#attributes.period_year#</td>
                                </cfoutput>
                                <td>
                                    <cfif response.status eq true>
                                        <!--- (Önceki Döne Kalan + Önceki Dönem Kullanılan) + ilgili dönem hakedilen --->                        
                                        <cfoutput>#((response.KALAN_IZIN+response.ilgili_yil_kullanilan_izin)-response.ilgili_yil_hakedilen)+(response.gecmis_donem_kullanilan)+(response.ilgili_yil_hakedilen)#</cfoutput>
                                    </cfif>
                                </td>
                                <td><cfif response.status eq true><cfoutput>#(response.KALAN_IZIN+response.ilgili_yil_kullanilan_izin)-response.ilgili_yil_hakedilen#</cfoutput></cfif></td>
                                <td><cfif response.status eq true><cfoutput>#old_days#</cfoutput></cfif></td>
                                <td><cfif response.status eq true><cfoutput>#response.ilgili_yil_hakedilen#</cfoutput></cfif></td>
                                <td><cfif response.status eq true><cfoutput><cfif x_min_control eq 1> #tlFormat(genel_dk_toplam)# <cfelse> #genel_izin_toplam#</cfif></cfoutput></cfif></td>
                                <td><cfif response.status eq true><cfoutput>#response.ilgili_yil_hakedilen-response.ilgili_yil_kullanilan_izin#</cfoutput></cfif></td>
                                <td><cfif response.status eq true><cfoutput><cfif x_min_control eq 1> #tlFormat(toplam_hakedilen_izin - genel_dk_toplam - old_days)# <cfelse>#toplam_hakedilen_izin - genel_izin_toplam - old_days#</cfif></cfoutput></cfif></td>
                                <td data-icon class="text-center"><i class="fa fa-paper-plane font-blue"></i></td>
                            </tr>
                        </cfloop>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#url_str#">
        <cfif get_employee.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
            </div>
        </cfif>
        <cfif isdefined("attributes.form_submitted") and get_employee.recordcount neq 0>
            <cf_box_footer>
                <span class="ui-wrk-btn ui-wrk-btn-success" @click="createApprove()"><i class="fa fa-paper-plane margin-0"></i> &nbsp <cf_get_lang dictionary_id='57461.Kaydet'></span>
            </cf_box_footer>
        </cfif>

    </cf_box>
</div>
<script language="javascript">
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'item-department',1,'İlişkili Departmanlar');
		}
	}
</script>
<script>
    var w3vap = new Vue({
        el: '#create_approve_app',
        data: {   
        id_list:[],
        sequence : 0,
        error: []
        },
        mounted(){
            $('#create_approve_app').removeAttr('style')
        },
        methods: {
            createApprove: function(value){
                if (!value) value = w3vap.id_list[0];
                if (w3vap.sequence <= w3vap.$data.id_list.length){                                        
                    var status_content = $('[data-id="'+value+'"] [data-icon]');
                    var status = $('[data-id="'+value+'"]').data('status');
                    row = $('[data-id="'+value+'"]').data();
                    if(status == 0 || status == -1 ){
                        $(status_content).empty().append('<i class="fa fa-spinner fa-spin font-yellow-crusta"></i>');
                        axios
                            .get("/V16/hr/cfc/add_approve.cfc",{
                                params:{
                                    method		: 'add_approve',
                                    id			: value,
                                    SAL_YEAR    : row.sal_year,
                                    EX_SAL_YEAR_REMAINDER_DAY : row.ex_sal_year_remainder_day,
                                    EX_SAL_YEAR_OFTIME_DAY : row.ex_sal_year_oftime_day,
                                    SAL_YEAR_REMAINDER_DAY : row.sal_year_remainder_day,
                                    SAL_YEAR_OFTIME_DAY : row.sal_year_oftime_day
                                }
                            })
                            .then(
                                response => {
                                    if(response.data.STATUS == true){
                                        $(status_content).empty().append('<i class="fa fa-paper-plane font-green-jungle"></i>');
                                        $('[data-id="'+value+'"]').data('status',1).attr('data-status',1);
                                    }else{
                                       w3vap.error.push({ecode: 1000, message:response.data.error}) 
                                        $(status_content).empty().append('<i class="fa fa-paper-plane font-red" title="'+response.data.ERROR+'"></i>');
                                        $('[data-id="'+value+'"]').data('status',-1).attr('data-status',-1);
                                    }
                                   w3vap.sequence = w3vap.sequence + 1;
                                   w3vap.createApprove(w3vap.id_list[w3vap.sequence]);											
                                }
                            )
                            .catch(
                                e => {
                                       w3vap.error.push({ecode: 2000, message:response.data.ERROR}) 
                                        $(status_content).empty().append('<i class="fa fa-paper-plane font-red"></i>');
                                        $('[data-id="'+value+'"]').data('status',-1).attr('data-status',-1);
                                       w3vap.sequence =w3vap.sequence + 1;
                                       w3vap.createApprove(w3vap.id_list[w3vap.sequence]);
                                }
                            );								
                    }else{
                       w3vap.sequence =w3vap.sequence + 1;
                       w3vap.createApprove(w3vap.id_list[w3vap.sequence]);
                    }
                
                }else{
                   w3vap.sequence = 0;
                }
            }
        }  
    })
    function triggerPlusIcon(){
        location.href="/index.cfm?fuseaction=ehesap.hr_offtime_approve&event=add";
    }		
</script>