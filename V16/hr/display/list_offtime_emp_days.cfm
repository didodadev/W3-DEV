<cfset get_employee_shift = createObject("component","V16.hr.cfc.get_employee_shift")>
<cfparam name="from_action" default="0">
<cfparam name="from_fire_action" default="0">
<cfparam name="mutabakat_year" default=""><!--- Myhome Dashboard da izin mutabakatı varsa hakedilişde kullanılması için konuldu BK-29122020 --->

<cfif not isdefined("fusebox.circuit")>
	<cfset fusebox.circuit = 'hr'>
</cfif>
<cfif from_action eq 0>
	<cf_xml_page_edit fuseact="myhome.my_offtimes">
</cfif>

<cfif isdefined("attributes.startdate") and len(attributes.startdate) and from_fire_action eq 0>
	<cf_date tarih="attributes.startdate">
<cfelseif from_fire_action eq 0>
	<cfparam name="attributes.startdate" default="">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfparam name="attributes.finishdate" default="">
</cfif>
<cfif not isdefined("GET_GENERAL_OFFTIMES.recordCount")>
	<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
		SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
	</cfquery>
</cfif>
<cfscript>
	toplam_hakedilen_izin = 0;
	genel_izin_toplam = 0;
	old_days = 0;
	genel_dk_toplam = 0;
	ext_worktime_day = 0;
	old_sgk_year = 0;
	tahmini_izin_yuku = 0;
	active_year_genel_dk_toplam = 0;
	kalan_izin = 0;
	kisi_izin_toplam = 0;
	kisi_izin_sayilmayan = 0;
	total_min_emp = 0;
</cfscript>
<cfif (not isdefined("get_emp.izin_days")) or (isdefined('from_action_file') and from_action_file eq 1)>
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
			(SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS,
			(SELECT TOP 1 FINISH_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS FINISH_DATE
		FROM
			EMPLOYEES E
			INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
		WHERE 
			E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
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
				(
					(
					OFFTIME.SUB_OFFTIMECAT_ID = 0 AND
					OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
					)
					OR
					OFFTIME.SUB_OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
				) AND
				OFFTIME.IS_PUANTAJ_OFF = 0 AND
				OFFTIME.VALID = 1 AND
				SETUP_OFFTIME.IS_PAID = 1 AND
				SETUP_OFFTIME.IS_YEARLY = 1	AND
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				OFFTIME.FINISHDATE < <cfqueryparam cfsqltype="cf_sql_date" value="#get_emp.izin_date#">
			ORDER BY
				STARTDATE DESC
		</cfquery>
		<!--- // İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLER --->
		<cfscript>
			kalan_izin = toplam_hakedilen_izin - genel_izin_toplam - old_days;
		</cfscript>    
	<cfelse>
		<cfset kalan_izin = 0>
	</cfif>
</cfif>
<cfquery name="get_progress_payment_outs" datasource="#dsn#">
	SELECT 
		START_DATE,FINISH_DATE 
	FROM 
		EMPLOYEE_PROGRESS_PAYMENT_OUT 
	WHERE 
		EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
		START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
UNION ALL
	SELECT 
		STARTDATE AS START_DATE,
		FINISHDATE AS FINISH_DATE 
	FROM 
		OFFTIME,SETUP_OFFTIME 
	WHERE 
		<cfif isdefined('attributes.IZIN_DATE') and len(attributes.IZIN_DATE)>
			OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.IZIN_DATE#"> AND
		</cfif>
		(
			(
			OFFTIME.SUB_OFFTIMECAT_ID = 0 AND
			OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
			)
			OR
			OFFTIME.SUB_OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
		) AND
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
		OFFTIME.VALID = 1 AND
		SETUP_OFFTIME.IS_OFFDAY_DELAY = 1 AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>

<cfquery name="get_offtime" datasource="#dsn#">
	SELECT 
		OFFTIME.*,
		SETUP_OFFTIME.OFFTIMECAT_ID,
		SETUP_OFFTIME.OFFTIMECAT,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.CALC_CALENDAR_DAY,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID
	FROM 
		OFFTIME,
		SETUP_OFFTIME
	WHERE
		<cfif isdefined('attributes.IZIN_DATE') and len(attributes.IZIN_DATE)>
			OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.IZIN_DATE#"> AND
		</cfif>
		(
			(
				ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 AND
				OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
			)
			OR
				OFFTIME.SUB_OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
		) AND
		
		OFFTIME.VALID = 1 AND
		SETUP_OFFTIME.IS_PAID = 1 AND
		SETUP_OFFTIME.IS_YEARLY = 1 AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	ORDER BY
		STARTDATE DESC
</cfquery>
<cfquery name="get_offtime_show_entitlements" datasource = "#dsn#">
	SELECT 
		OFFTIMECAT_ID
		,OFFTIMECAT
		,IS_PAID
		,SHOW_ENTITLEMENTS
		,IS_PERMISSION_TYPE
		,WEEKING_WORKING_DAY
		,MAX_PERMISSION_TIME
	FROM 
		SETUP_OFFTIME
	WHERE 
		IS_ACTIVE = 1 
		AND SHOW_ENTITLEMENTS = 1
</cfquery>
<cfset wdo = createObject("component","V16.myhome.cfc.offtimes")>
<cfset get_offtimes = WDO.GET_OFFTIMES(employee_id : attributes.employee_id,startdate: attributes.startdate, finishdate: attributes.finishdate)>
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
	<cfif not len(calc_old_sgk_year)>
		<cfset calc_old_sgk_year = 0>
	</cfif>
<cfelse>
	<cfset calc_old_sgk_year = 0>
</cfif>
<cfset free_time_cmp = createObject("component","V16.myhome.cfc.free_time")>
<cfset calc_var_query = free_time_cmp.CALC_FREE_TIME(employee_id : attributes.employee_id,branch_id: IsDefined("attributes.branch_id") ? attributes.branch_id : '' )>

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
<cfif not(isdefined("finish_am_min") or isdefined("finish_am_hour") or isdefined("start_pm_hour") or isdefined("start_pm_min"))>
	<cfset finish_am_min = '00'>
	<cfset finish_am_hour = '00'>
	<cfset start_pm_hour = '00'>
	<cfset start_pm_min = '00'>
</cfif>	
<cfif not isdefined("x_min_control")>
	<cfset x_min_control = 0>
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
<cfset halfofftime_list2 = ''><!--- başlangıç --->
<cfset halfofftime_list3 = ''><!--- Bitiş --->
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
		EI.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		DEPARTMENT.DEPARTMENT_ID = EI.DEPARTMENT_ID
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	ORDER BY EI.IN_OUT_ID DESC, IS_VARDIYA DESC
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
	<cfquery name="get_hours" datasource="#dsn#">
		SELECT		
			OUR_COMPANY_HOURS.*
		FROM
			OUR_COMPANY_HOURS
		WHERE
			OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
			OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
			OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
			OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"><!---Çalışan kartındaki son şirkete göre---->
	</cfquery>
</cfif>
<cfscript>
	if (get_hours.recordcount and len(get_hours.weekly_offday))
		this_week_rest_day_ = get_hours.weekly_offday;
	else
		this_week_rest_day_ = 1;
	temp_this_week_rest_day_ = this_week_rest_day_;

	if (len(get_emp.izin_days))
		old_days = get_emp.izin_days;
	else
		old_days = 0;
	// Listeleme de saat cinsinden gösterilsin seçildiğinde 20200106ERU
	if(isdefined("x_min_control") and x_min_control eq 1 and get_hours.recordcount){
		baslangic_saat_dk = timeformat('#get_hours.start_hour#:#get_hours.start_min#',timeformat_style);// mesai başlangıç 
		bitis_saat_dk = timeformat('#get_hours.end_hour#:#get_hours.end_min#',timeformat_style);// mesai bitiş 
	}else if((isdefined("x_min_control") and x_min_control eq 1) or xml_offtime_show_hour){
		baslangic_saat_dk = timeformat('#start_hour#:#start_min#',timeformat_style);// mesai başlangıç 
		bitis_saat_dk = timeformat('#finish_hour#:#finish_min#',timeformat_style);// mesai bitiş 
	}

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
	<cf_box title="İzin Baz Tarihinden Önceki İzin Listesi : <cfoutput>#get_emp.employee_name# #get_emp.employee_surname#</cfoutput>">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='56645.Yıllar'></th>
					<th width="65"><cf_get_lang dictionary_id ='56644.Son İzin'></th>
					<th><cf_get_lang dictionary_id='55235.İzin Tipi'></th>
					<th><cf_get_lang dictionary_id='58575.İzin'></th>
					<th><cf_get_lang dictionary_id='55236.HS'></th>
					<th><cf_get_lang dictionary_id='55239.GT'></th>
					<th width="75"><cf_get_lang dictionary_id='56642.İzni Hakediş'></th>
					<th width="40"><cf_get_lang dictionary_id='56630.Kıdem'> (<cf_get_lang dictionary_id='58575.İzin'>) </th>
					<th width="40"><cf_get_lang dictionary_id='29513.Süre'></th>
					<th width="65"><cf_get_lang dictionary_id='58467.Başlama'></th>
					<th width="65"><cf_get_lang dictionary_id='58695.Dönüş'></th>
				</tr>
			</thead>
			<cfset izin_sayilmayan_ = 0>
			<cfoutput query="get_offtime_old">
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
					
					add_sunday_total = 0;
					temporary_sunday_total = 0;
					temporary_offday_total = 0;
					temporary_halfday_total = 0;
					temporary_halfofftime = 0; //yarım günlük genel tatiller
					izin_start_hour_ = "";
					izin_finish_hour_ = "";
					temp_finishdate = CreateDateTime(year(finishdate),month(finishdate),day(finishdate),0,0,0);
					temp_startdate = CreateDateTime(year(startdate),month(startdate),day(startdate),0,0,0);
					total_izin = fix(get_offtime_old.finishdate-get_offtime_old.startdate)+1;
					izin_startdate = date_add("h", session.ep.time_zone, get_offtime_old.startdate); 
					izin_finishdate = date_add("h", session.ep.time_zone, get_offtime_old.finishdate);
					fark = 0;
					fark2 = 0;
					if(timeformat(izin_startdate,timeformat_style) lt timeformat('#start_hour#:#start_min#',timeformat_style))
					{
						izin_start_hour_ = timeformat('#start_hour#:#start_min#',timeformat_style);
					}
					else
					{
						izin_start_hour_ = 	timeformat(izin_startdate,timeformat_style);
					}
					if(timeformat(izin_finishdate,timeformat_style) gt timeformat('#finish_hour#:#finish_min#',timeformat_style))
					{
						izin_finish_hour_ = timeformat('#finish_hour#:#finish_min#',timeformat_style);
					}
					else
					{
						izin_finish_hour_ = timeformat(izin_finishdate,timeformat_style);	
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
					if(fark gt 0 and fark lte day_control)
					{
						if(not listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(startdate,dateformat_style)#') and public_holiday_on eq 1)) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
						temporary_halfday_total = temporary_halfday_total + 1;
						halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(startdate,dateformat_style)#');
					}
					if(fark2 gt 0 and fark2 lte day_control)
					{
						if(not listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') or (listfind(halfofftime_list,'#dateformat(finishdate,dateformat_style)#') and public_holiday_on eq 1)) //saatten oluşan yarım günlük izine yarım günlük genel tatil gunune denk gelmiyorsa girecek
						temporary_halfday_total = temporary_halfday_total + 1;
						halfofftime_list2 = listappend(halfofftime_list2,'#dateformat(finishdate,dateformat_style)#');
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
					// ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez y da  parametrelerden tavim günü hesaplansın seçilmediyse genel tatil ve hafta tatili dusulmez
					if((get_offtime_old.is_paid neq 1 and get_offtime_old.ebildirge_type_id neq 21) or  (isdefined("get_offtime_old.CALC_CALENDAR_DAY") and len(get_offtime_old.CALC_CALENDAR_DAY) and get_offtime.CALC_CALENDAR_DAY neq 0) )   
					{
						izin_gun = total_izin - (0.5 * temporary_halfday_total);
					}
					else
					{
						izin_gun = total_izin - temporary_sunday_total - temporary_offday_total - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime) + add_sunday_total;
					}
					//genel_izin_toplam = genel_izin_toplam+izin_gun; //izin baz tarihinden onceki izinler kullanilan izine dahil edilmesin
				</cfscript>
				<tbody>
					<tr>
						<td>#dateformat(izin_startdate,'yyyy')#</td>
						<td>#dateformat(get_pre_offtime_.startdate,dateformat_style)#</td>
						<td>#get_offtime_old.offtimecat#</td>
						<td>#total_izin-temporary_sunday_total-temporary_offday_total#</td>
						<td>#temporary_sunday_total#</td>
						<td>#temporary_offday_total#</td>
						<td><cfif len(get_offtime_old.DESERVE_DATE)>#dateformat(get_offtime_old.DESERVE_DATE,dateformat_style)#</cfif></td>
						<td>-</td>
						<td>#int(total_izin)#</td>
						<td>#dateformat(izin_startdate,dateformat_style)#</td>
						<td>#dateformat(izin_finishdate,dateformat_style)#</td>
					</tr>
				</tbody>
				<cfset izin_sayilmayan_ = izin_sayilmayan_ + temporary_sunday_total + temporary_offday_total>
			</cfoutput>
		</cf_flat_list>
	</cf_box>				
</cfif>
<!--- İZİN LİSTESİ--->
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_offtimes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset toplam_saat = 0>
<cfif attributes.fuseaction is 'myhome.my_offtimes'>	
	<cf_box title="#getLang('myhome',63)#" closable="0" add_href="?fuseaction=myhome.my_offtimes&event=add&employee_id=#session.ep.userid#&kalan_izin=#kalan_izin#" is_blank="0">
		<cf_flat_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th><cf_get_lang dictionary_id='31111.Tarihler'></th>
						<th><cf_get_lang dictionary_id='57490.Gün'></th>
						<cfif xml_offtime_show_hour and x_min_control>
							<th><cf_get_lang dictionary_id='57491.Saat'></th>
						</cfif>
						<th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_offtimes.recordcount>
						<cfset genel_dk_toplam = 0>	
						<cfset genel_izin_toplam = 0>
						<cfset kisi_izin_toplam = 0>	
						<cfset kisi_izin_sayilmayan = 0>
						<cfoutput query="get_offtimes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td><a href="#request.self#?fuseaction=myhome.my_offtimes&event=info&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')#">#offtime_id#</a></td>
								<td><a href="#request.self#?fuseaction=myhome.my_offtimes&event=info&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')#">#new_cat_name#</a></td>
								<td>#get_emp_info(get_offtimes.employee_id,0,0)#</td>
								<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)# ) - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)# )</td>
								<td>
									<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
										SELECT SATURDAY_ON,DAY_CONTROL,SUNDAY_ON,PUBLIC_HOLIDAY_ON,DAY_CONTROL_AFTERNOON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">  AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
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
									<cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
										<cfset day_control_afternoon = get_offtime_cat.day_control_afternoon>
									<cfelse>
										<cfset day_control_afternoon = 0>
									</cfif>
									<cfif  get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
										<cfset day_control = get_offtime_cat.day_control>
									<cfelse>
										<cfset day_control = 0>
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
									<!--- Çalışanın vardiyalı çalışma saatleri --->
									<cfset finishdate_ = dateadd("d", 1, finishdate)>
									<cfset get_shift = get_employee_shift.get_emp_shift(employee_id : get_offtimes.employee_id,start_date : startdate, finish_date : finishdate_)>
									<!--- İzin Hesapları bu dosyada yapılıyor ---->
									<cfif x_min_control eq 1>
										<cfif get_shift.recordcount>
											<cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
										<cfelse>
											<cfinclude template="/V16/hr/ehesap/display/offtime_calc.cfm">
										</cfif>
										#TLFormat(total_day_calc,2)# 
									<cfelse>
										<cfif get_shift.recordcount gt 0 and get_emp_in_out.IS_VARDIYA eq 2>
											<cfif len(get_shift.WEEK_OFFDAY)>
												<cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
											<cfelse>
												<cfset this_week_rest_day_ = 1>
											</cfif>
										<cfelse>
											<cfset this_week_rest_day_ = this_week_rest_day_>
										</cfif>
										<cfinclude template="/V16/hr/ehesap/display/offtime_calc_day.cfm">
										#izin_gun# 
									</cfif>
								</td>
								<cfif xml_offtime_show_hour and x_min_control>
									<td  align="center">
										<cfsavecontent variable = "day">
											<cf_get_lang dictionary_id ="57490.Gün">
										</cfsavecontent>
										<cfsavecontent variable = "hour">
											<cf_get_lang dictionary_id ="57491.Saat">
										</cfsavecontent>
										<cfsavecontent variable = "min">
											<cf_get_lang dictionary_id ="58827.Dk">
										</cfsavecontent>
										<cfif isdefined("days") and days neq 0>#days##left(day,1)# </cfif>
										<cfif isdefined("hours") and hours neq 0>#hours##left(hour,1)# </cfif>
										<cfif isdefined("minutes") and minutes neq 0>#minutes##min# </cfif>
									</td>
								</cfif>
								<td>
									<cf_workcube_process type="color-status" process_stage="#OFFTIME_STAGE#">
								</td>
								<td class="text-right"><a href="#request.self#?fuseaction=myhome.my_offtimes&event=upd&offtime_id=#contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')#"><i class="fa fa-retweet"  title="<cf_get_lang dictionary_id='30923.Güncelle'>"></i></a></td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
				</tbody>
		</cf_flat_list>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#get_offtimes.recordcount#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction#">
	</cf_box>
<cfelse>
	<cf_box title="#getLang('myhome',63)#" closable="0">
		<cf_flat_list>
			<div class="extra_list">
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th><cf_get_lang dictionary_id='31111.Tarihler'></th>
						<th><cf_get_lang dictionary_id='57490.Gün'></th>
						<cfif xml_offtime_show_hour><th><cf_get_lang dictionary_id='57491.Saat'></th></cfif>
						<!-- sil --><th></th><!-- sil -->
					</tr>
				</thead>
				<tbody>
					<cfif get_offtimes.recordcount>
						<cfoutput query="get_offtimes">
							<tr>
								<cfif isdefined("from_action_file") and from_action_file eq 1>
									<cfset offtime_id_  = offtime_id>
								<cfelse>
								<cfset offtime_id_ = contentEncryptingandDecodingAES(isEncode:1,content:offtime_id,accountKey:'wrk')>
								</cfif>
								<td><a href="#request.self#?fuseaction=myhome.my_offtimes&event=info&offtime_id=#offtime_id#" class="tableyazi">#new_cat_name#</a></td>
								<td>
									<cfif isdefined("from_action_file") and from_action_file eq 1>
										#caller.get_emp_info(get_offtimes.employee_id,0,0)#
									<cfelse>
										#get_emp_info(get_offtimes.employee_id,0,0)#
									</cfif>
								</td>
								<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)# ) - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# ( #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)# )</td>
								<td>
									<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
										SELECT SATURDAY_ON,DAY_CONTROL,SUNDAY_ON,PUBLIC_HOLIDAY_ON,DAY_CONTROL_AFTERNOON FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">  AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#"> AND
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
										if (get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on))
											sunday_on = get_offtime_cat.sunday_on;
										else
											sunday_on = 0;
										if (get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on))
											public_holiday_on = get_offtime_cat.public_holiday_on;
										else
											public_holiday_on = 0;
										if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
										{
											day_control_ = get_offtime_cat.day_control;
											day_control = get_offtime_cat.day_control;
										}
										else
										{
											day_control_ = 0;
											day_control = 0;
										}
											
										if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control_afternoon))
											day_control_afternoon = get_offtime_cat.day_control_afternoon;
										else
											day_control_afternoon = 0;
											
									</cfscript>
									<!--- Çalışanın vardiyalı çalışma saatleri --->
									<cfset finishdate_ = dateadd("d", 1, finishdate)>
									<cfset get_shift = get_employee_shift.get_emp_shift(employee_id : get_offtimes.employee_id,start_date : startdate, finish_date : finishdate_<!---  --->)>
									<!--- İzin Hesapları bu dosyada yapılıyor ---->
									<cfif x_min_control eq 1>
										<cfif get_shift.recordcount>
											<cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
										<cfelse>
											<cfinclude template="/V16/hr/ehesap/display/offtime_calc.cfm">
										</cfif>
									<cfelse>
										<cfif get_shift.recordcount gt 0 and get_emp_in_out.IS_VARDIYA eq 2>
											<cfif len(get_shift.WEEK_OFFDAY)>
												<cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
											<cfelse>
												<cfset this_week_rest_day_ = 1>
											</cfif>
										<cfelse>
											<cfset this_week_rest_day_ = this_week_rest_day_>
										</cfif>
										<cfinclude template="/V16/hr/ehesap/display/offtime_calc_day.cfm">
									</cfif>
									<cfif x_min_control eq 1>
										#TLFormat(total_day_calc,2)#
									<cfelse>
										#izin_gun#
									</cfif>
								</td>
								<cfif xml_offtime_show_hour>
									<td>
										<cfsavecontent variable = "day">
											<cf_get_lang dictionary_id ="57490.Gün">
										</cfsavecontent>
										<cfsavecontent variable = "hour">
											<cf_get_lang dictionary_id ="57491.Saat">
										</cfsavecontent>
										<cfsavecontent variable = "min">
											<cf_get_lang dictionary_id ="58827.Dk">
										</cfsavecontent>
										<cfif isdefined("days") and days neq 0>#days##left(day,1)#</cfif>
										<cfif isdefined("hours") and hours neq 0>#hours##left(hour,1)# </cfif>
										<cfif isdefined("minutes") and minutes neq 0>#minutes##min# </cfif>
									</td>
								</cfif>
									<!-- sil --><td></td><!-- sil -->
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
				</tbody>
			</div>
		</cf_flat_list>
	</cf_box>
</cfif>
<!--- YILLIK İZİN LİSTESİ--->
<cf_box title="#getLang(dictionary_id:43082)#">
	<cf_flat_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id ='56645.Yıllar'></th>
				<th width="65"><cf_get_lang dictionary_id ='56644.Son İzin'></th>
				<th><cf_get_lang dictionary_id='55235.İzin Tipi'></th>
				<th><cf_get_lang dictionary_id='58575.İzin'></th>
				<cfif x_min_control eq 1><th></th></cfif>
				<th><cf_get_lang dictionary_id='55236.HS'></th>
				<th><cf_get_lang dictionary_id='55239.GT'></th>
				<th width="75"><cf_get_lang dictionary_id='56642.İzni Hakediş'></th>
				<th width="40"><cf_get_lang dictionary_id='56630.Kıdem'> (<cf_get_lang dictionary_id='58575.İzin'>) </th>
				<th width="40"><cf_get_lang dictionary_id='29513.Süre'></th>
				<th width="65"><cf_get_lang dictionary_id='58467.Başlama'></th>
				<th width="65"><cf_get_lang dictionary_id='58695.Dönüş'></th>
				<!-- sil -->
				<th width="15">
					<cfif fusebox.circuit is not 'myhome'>
						<a href="javascript://" onclick="gizle_goster(employee_izin_days_tr);"><img src="/images/plus_list.gif" alt="<cf_get_lang dictionary_id='55778.Geçmiş İzin Günü Gir'>" title="<cf_get_lang dictionary_id='55778.Geçmiş İzin Günü Gir'>"/></a>
					</cfif>
				</th>
				<!-- sil -->
			</tr>
		</thead>
		<cfset izin_sayilmayan = 0>
		<cfset genel_izin_toplam = 0>
		<cfset genel_dk_toplam = 0>	
		<cfif get_offtime.recordcount>
			<cfoutput query="get_offtime">
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
					if (get_offtime_cat.recordcount and len(get_offtime_cat.sunday_on))
						sunday_on = get_offtime_cat.sunday_on;
					else
						sunday_on = 0;
					if (get_offtime_cat.recordcount and len(get_offtime_cat.public_holiday_on))
						public_holiday_on = get_offtime_cat.public_holiday_on;
					else
						public_holiday_on = 0;
					if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control))
					{
						day_control_ = get_offtime_cat.day_control;
						day_control = get_offtime_cat.day_control;
					}
					else
					{
						day_control_ = 0;
						day_control = 0;
					}
						
					if (get_offtime_cat.recordcount and len(get_offtime_cat.day_control_afternoon))
						day_control_afternoon = get_offtime_cat.day_control_afternoon;
					else
						day_control_afternoon = 0;
						
				</cfscript>
				<!--- Çalışanın vardiyalı çalışma saatleri --->
				<cfset finishdate_ = dateadd("d", 1, finishdate)>
				<cfset get_shift = get_employee_shift.get_emp_shift(employee_id : attributes.employee_id,start_date : startdate, finish_date : finishdate_)>
				<!--- İzin Hesapları bu dosyada yapılıyor ---->
				<cfif x_min_control eq 1>
					<cfif get_shift.recordcount>
						<cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
					<cfelse>
						<cfinclude template="/V16/hr/ehesap/display/offtime_calc.cfm">
					</cfif>
				<cfelse>
					<cfif get_shift.recordcount gt 0 and get_emp_in_out.IS_VARDIYA eq 2>
						<cfif len(get_shift.WEEK_OFFDAY)>
							<cfset this_week_rest_day_ = get_shift.WEEK_OFFDAY>
						<cfelse>
							<cfset this_week_rest_day_ = 1>
						</cfif>
					<cfelse>
						<cfset this_week_rest_day_ = this_week_rest_day_>
					</cfif>
					<cfinclude template="/V16/hr/ehesap/display/offtime_calc_day.cfm">
				</cfif>
				<cfscript>
					if (len(get_emp.izin_date))
						kidem=datediff('d',get_emp.izin_date,get_offtime.startdate);
					else
						kidem=0;
					kidem_yil=kidem/365;
				</cfscript>
				<tr <cfif kidem_yil lt 0>style="color:red;"</cfif>>
					<td>#dateformat(izin_startdate_,'yyyy')#</td>
					<td>#dateformat(get_pre_offtime.startdate,dateformat_style)#</td>
					<td>#get_offtime.offtimecat#</td>
					<td>
						<cfif x_min_control eq 1>
							#tlFormat(total_day_calc)#
						<cfelse>
							#izin_gun# 
						</cfif><!--- #total_izin-temporary_sunday_total-temporary_offday_total - (0.5 * temporary_halfday_total)+ (0.5 * temporary_halfofftime)# ---></td>
					<cfif x_min_control eq 1>
						<td  align="center">
							<cfsavecontent variable = "day">
								<cf_get_lang dictionary_id ="57490.Gün">
							</cfsavecontent>
							<cfsavecontent variable = "hour">
								<cf_get_lang dictionary_id ="57491.Saat">
							</cfsavecontent>
							<cfsavecontent variable = "min">
								<cf_get_lang dictionary_id ="58827.Dk">
							</cfsavecontent>
							<cfif  isdefined("days") and days neq 0>#days##left(day,1)# </cfif>
							<cfif  isdefined("hours") and hours neq 0>#hours##left(hour,1)# </cfif>
							<cfif  isdefined("minutes") and minutes neq 0>#minutes##min# </cfif>
						</td>
					</cfif>
					<td>#temporary_sunday_total_#</td>
					<td>#temporary_offday_total_#</td>
					<td><cfif len(get_offtime.DESERVE_DATE)>#dateformat(get_offtime.DESERVE_DATE,dateformat_style)#</cfif></td>
					<td>
						<cfif kidem_yil lt 0>
							<cf_get_lang dictionary_id='55249.Dönem dışı'>
						<cfelse>
							#Int(kidem_yil)#
						</cfif>
					</td>
					<td>#total_izin_#<!--- #int(total_izin)# ---></td>
					<td>#dateformat(izin_startdate_,dateformat_style)#</td>
					<td>#dateformat(izin_finishdate_,dateformat_style)#</td>
					<!-- sil --><td>&nbsp;</td><!-- sil -->
				</tr>
				<cfset izin_sayilmayan = izin_sayilmayan + temporary_sunday_total_ + temporary_offday_total_>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</cf_flat_list>
</cf_box>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="51044.Hakedişler"></cfsavecontent>
<cf_box title="#message#" closable="0">
	<cf_flat_list>
		<div class="extra_list">
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='56641.Hakediş T'></th>
					<th><cf_get_lang dictionary_id='58053.Başlangıç T'></th>
					<th><cf_get_lang dictionary_id='56640.İzin Kul Bitiş'></th>
					<th><cf_get_lang dictionary_id='57490.Gün'></th>
					<th><cf_get_lang dictionary_id='57492.Toplam'></th>
				</tr>
			</thead>
			<tbody>
				<cfif len(get_emp.izin_date)>
		
					<cfscript>
						tck = 0;
						tck_ = 0;
						old_tck = 0;
						toplam_hakedilen_izin = 0;
						diff_ = 0;
						my_giris_date = get_emp.IZIN_DATE;
						flag = true;
						if(len(mutabakat_year)){
							mutabakat_date = CreateDateTime(mutabakat_year+1,DatePart('m', my_giris_date),DatePart('d', my_giris_date),00,00,00);
							baslangic_tarih_ = mutabakat_date;
							diff_ = datediff('yyyy',my_giris_date,mutabakat_date);
						}
						else{
							baslangic_tarih_ = my_giris_date;
						}
						my_baz_date = now();
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
										writeoutput('<tr><td>#dateformat(ilk_tarih_,dateformat_style)#</td>');
										writeoutput('<td>#dateformat(baslangic_tarih_,dateformat_style)#</td>');
										writeoutput('<td>#dateformat(bitis_tarihi_,dateformat_style)#</td><td align=right>#eklenecek#</td><td align=right>#toplam_hakedilen_izin#</td>');
										writeoutput('</tr>');
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
										writeoutput('<tr>');
										writeoutput('<td>#dateformat(ilk_tarih_,dateformat_style)#</td>');
										writeoutput('<td>#dateformat(baslangic_tarih_,dateformat_style)#</td>');
										writeoutput('<td>#dateformat(bitis_tarihi_,dateformat_style)#</td><td>#eklenecek#</td><td>#toplam_hakedilen_izin#</td>');
										writeoutput('</tr>');
									}
								}
								ilk_tarih_ = baslangic_tarih_;
								baslangic_tarih_ = bitis_tarihi_;
								bitis_tarihi_ = date_add("m",get_def_type.limit_1,bitis_tarihi_);
								if(datediff("d",baslangic_tarih_,now()) lt 0)				
									flag = false;
							}
						}
						else 
						{
							//xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve Yıl bilgisi girilmişse 20191030ERU 
							if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year))
							{
								old_sgk_year = 0;
								if(len(get_emp.OLD_SGK_DAYS))
									old_sgk_year = get_emp.OLD_SGK_DAYS / 360;//Geçmiş zaman sgk günü 360 gün üzerinden yılı hesaplanıyor.
							}
							total_row = 0;
							tck = tck + diff_;
							while(flag)
							{
								bitis_tarihi_ = createodbcdatetime(date_add("yyyy",1,baslangic_tarih_));
								baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
								ilk_tarih_ = baslangic_tarih_;
								baslangic_tarih_ = bitis_tarihi_;
								get_bos_zaman_ = cfquery(
										Datasource="#dsn#",
										dbtype="query",
										sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi_#) OR (START_DATE >= #ilk_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #ilk_tarih_#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi_#) OR ((START_DATE BETWEEN #ilk_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#)");	
								if(get_bos_zaman_.recordcount eq 0)
								{
									//xmlden geçmiş sgk günü gelsin işaretliyse ve izin süreleri xml'inden yıl bilgisi girildiyse ve hesaplama yılı girilen yıla eşitse 20191030ERU 
									if(get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year) and tck eq calc_old_sgk_year and old_tck eq 0)
									{
										tck  = tck + int(old_sgk_year);
									}
									tck = tck + 1 ; 
									
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
											writeoutput('<tr><td>#dateformat(ilk_tarih_,dateformat_style)#</td>');
											writeoutput('<td>#dateformat(baslangic_tarih_,dateformat_style)#</td>');
											writeoutput('<td>#dateformat(bitis_tarihi_,dateformat_style)#</td><td align=right>#eklenecek#</td><td align=right>#toplam_hakedilen_izin#</td>');
											writeoutput('</tr>');
											
									}
									else
									{
										writeoutput('<tr><td colspan=5>İzin limitleri girilmemiş!</td></tr>');
									}
								}
								else
								{	
									eklenecek_gun = 0;	
									
									//Peşpeşe İzin ve Kıdemden Sayılmayacak Günler eklendiyse 210416ERU
									bitis_tarihi__bos = bitis_tarihi_;
									get_bos_zaman_ = cfquery(
										Datasource="#dsn#",
										dbtype="query",
										sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi__bos#) OR (START_DATE >= #ilk_tarih_# AND FINISH_DATE <= #bitis_tarihi__bos#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #ilk_tarih_#) OR (START_DATE <= #ilk_tarih_# AND FINISH_DATE >= #bitis_tarihi__bos#) OR ((START_DATE BETWEEN #ilk_tarih_# AND #bitis_tarihi__bos#) AND FINISH_DATE >= #bitis_tarihi__bos#)");	
									for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
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
										
											bitis_tarihi__bos = date_add("d",eklenecek_gun,bitis_tarihi__bos);
																			
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
										//if(tck neq 1 and eklenecek neq 0) 
										{
											toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
											writeoutput('<tr>');
											writeoutput('<td>#dateformat(ilk_tarih_,dateformat_style)#</td>');
											writeoutput('<td>#dateformat(baslangic_tarih_,dateformat_style)#</td>');
											writeoutput('<td>#dateformat(bitis_tarihi_,dateformat_style)#</td><td>#eklenecek#</td><td>#toplam_hakedilen_izin#</td>');
											writeoutput('</tr>');
										}
									}
									else
									{
										writeoutput('<tr><td colspan=5><cf_get_lang dictionary_id="54161.Girilen Tarihlerde İzin Limitleri Girilmemiş"></td></tr>');
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
					</cfscript>
					<cfquery name="get_salary" datasource="#dsn#" maxrows="1">
						SELECT 
							EPR.SALARY,
							EPR.SALARY_TYPE,
							EPR.GROSS_NET
						FROM 
							EMPLOYEES_PUANTAJ EP,
							EMPLOYEES_PUANTAJ_ROWS EPR
						WHERE
							EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
							EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
						ORDER BY
							EP.SAL_YEAR DESC,
							EP.SAL_MON DESC
					</cfquery>
					<cfif get_salary.recordcount>
						<cfif get_FeeCalculation.recordcount and get_salary.gross_net eq 0><!--- Brütse --->
							<cfset tahmini_izin_yuku = (((get_salary.salary * get_FeeCalculation.property_value) / 12 ) / 30) * (toplam_hakedilen_izin - genel_izin_toplam - old_days)>
						<cfelseif get_salary.salary_type eq 0>
							<cfset tahmini_izin_yuku = get_salary.salary * 225 / 30 * (toplam_hakedilen_izin - genel_izin_toplam - old_days)>
						<cfelseif get_salary.salary_type eq 1>
							<cfset tahmini_izin_yuku = get_salary.salary * (toplam_hakedilen_izin - genel_izin_toplam - old_days)>
						<cfelse>
							<cfset tahmini_izin_yuku = get_salary.salary / 30 * (toplam_hakedilen_izin - genel_izin_toplam - old_days)>
						</cfif>
					<cfelse>
						<cfset tahmini_izin_yuku = 0>
					</cfif>
					<cfelse>
						<tr>
							<td colspan="5">&nbsp;<cf_get_lang dictionary_id ='56634.İzin Baz Tarihi Girilmediğinden Detay Bilgisi Verilememektedir'>!</td>
						</tr>
					</cfif>
					<!-- sil -->
					<tr id="employee_izin_days_tr" style="display:none;" class="no-shared-content">
						<td colspan="5">
						<cf_get_lang dictionary_id='55241.Geçmiş İzin Günü'>
							<cfif fusebox.circuit is not 'myhome'><!---20131101 GSO virgullu 4 haneli sayı yazılabilmesi için maxlength arttırıldı--->					
								<input type="text" name="employee_izin_days" id="employee_izin_days" value="<cfoutput>#Tlformat(get_emp.IZIN_DAYS)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,2));" style="width:40px;" maxlength="6"/> <input type="button" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onclick="save_employee_izin_days('<cfoutput>#attributes.employee_id#</cfoutput>');"/>
							<cfelse>
								<cfif len(get_emp.IZIN_DAYS)>  
									<cfoutput>#Tlformat(get_emp.IZIN_DAYS)#</cfoutput> 
								<cfelse>
									0
								</cfif>
							</cfif>
							<div id="employee_izin_days_div"></div>
						</td>
					</tr>
					<!-- sil -->
			</tbody>
		</div>
	</cf_flat_list>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfoutput>
				<table class="ui-table-list ui-form" >
					<tr class="bold">
						<td><cf_get_lang dictionary_id='43082.Yıllık İzin'></td>
						<td></td>
					</tr>
					<cfif get_offtime_old_sgk_year.recordcount and get_old_sgk_year.recordcount and get_old_sgk_year.property_value eq 1 and len(calc_old_sgk_year)>
						<tr>
							<td>
								<cf_get_lang dictionary_id ='54358.Geçmiş SGK Gün'> <cf_get_lang dictionary_id ='56292.Kıdem Yıl'>
							</td>
							<td>
								<cfif isdefined('old_sgk_year') and len(old_sgk_year)>#tlFormat(old_sgk_year)#<cfelse>0</cfif>
							</td>
						</tr>
						<tr>
							<td>
								<cf_get_lang dictionary_id="57574.Şirket"> <cf_get_lang dictionary_id ='56292.Kıdem Yıl'>
							</td>
							<td>
								<cfif isdefined('get_emp.kidem_date') and len(get_emp.kidem_date)>
									<cfset kidem_day = datediff("d",get_emp.kidem_date,now())>
									#tlFormat(kidem_day/365)#
								<cfelse>
									0
								</cfif> 
							</td>
						</tr>
					<cfelse>
						<tr>
							<td>
								<cf_get_lang dictionary_id ='56635.Toplam Kıdem Yıl'>
							</td>
							<td>
								<cfif isdefined('tck') and len(tck)>#tck-1#<cfelse>0</cfif>
							</td>
						</tr>
					</cfif>
					<cfif x_min_control eq 1>
						<tr>
							<td>
								<cf_get_lang dictionary_id='63582.Fazla Mesaiden Hakedilen İzin'> (<cf_get_lang dictionary_id='63585.Serbest Zaman'>)
							</td>
							<td class="margin-0">
								#tlformat(wrk_round(calc_var_query.FM_DAY))#<!---FM den gelen izin--->
							</td>
						</tr>
						<tr>
							<td>
								<cf_get_lang dictionary_id='63583.Fazla Mesaiden Kullanılan İzin'> (<cf_get_lang dictionary_id='63585.Serbest Zaman'>)
							</td>
							<td>
								#tlformat(wrk_round(calc_var_query.used_days))#<!---FM den gelen izin--->
							</td>
						</tr>
						<tr>
							<td>
								<cf_get_lang dictionary_id='63584.Fazla Mesaiden Kalan İzin'> (<cf_get_lang dictionary_id='63585.Serbest Zaman'>)
							</td>
							<td>
								#tlformat(wrk_round(calc_var_query.unused_days))#<!---FM den gelen izin--->
							</td>
						</tr>
					</cfif>
					<tr>
						<td>
							<cf_get_lang dictionary_id ='61317.Toplam Hakedilen Yıllık İzin'>
						</td>
						<td>
							#toplam_hakedilen_izin#
						</td>
					</tr>
					<cfif old_days gt 0>
						<tr>
							<td>
								<cf_get_lang dictionary_id='61318.Geçmiş Dönem Kullanılan Yıllık İzin'>
							</td>
							<td>
								#old_days#
							</td>
						</tr>
					</cfif>
					<tr>
						<td>
							<cf_get_lang dictionary_id ='61319.Kullanılan Yıllık İzin'>
						</td>
						<td>
							<cfif x_min_control eq 1> #tlFormat(genel_dk_toplam)# <cfelse> #genel_izin_toplam#</cfif>
						</td>
					</tr>
					<tr>
						<td>
							<cf_get_lang dictionary_id ='61320.Kalan Yıllık İzin'>
						</td>
						<td>
							<cfif x_min_control eq 1> #tlFormat(toplam_hakedilen_izin - genel_dk_toplam - old_days)# <cfelse>#toplam_hakedilen_izin - genel_izin_toplam - old_days#</cfif>
						</td>
					</tr>
					<cfif get_module_power_user(48) and get_module_user(48) and fusebox.circuit is 'hr'><!--- ehesap yetkisi yoksa izin tutarini goremez --->
						<tr>
							<td>
								<cf_get_lang dictionary_id ='56639.Tahmini İzin Yükü'>
							</td>
							<td>
								#tlformat(tahmini_izin_yuku)#
							</td>
						</tr>
					</cfif>
				</table>
			</cfoutput>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<table class="ui-table-list ui-form">
				<cfif get_offtime_show_entitlements.recordcount>
					<tr class="bold">
						<td><cf_get_lang dictionary_id='57486.Kategori'></td>
						<td><cf_get_lang dictionary_id='64227.Hakedilen'></td>
						<td><cf_get_lang dictionary_id='59563.Kullanılan'></td>
						<td><cf_get_lang dictionary_id='58444.Kalan'></td>
					</tr>
				</cfif>
				<cfoutput query = "get_offtime_show_entitlements">
					<cfset get_offtime_cfc = WDO.GET_OFFTIMES_(employee_id : attributes.employee_id,offtimecat_id : OFFTIMECAT_ID)>
					<cfset used_izin_gun = 0>
					<cfif IS_PERMISSION_TYPE eq 2><!--- gün cinsindense --->
						<cfsavecontent variable ="type_name">
							<cf_get_lang dictionary_id="57490.Gün">
						</cfsavecontent>
						<cfloop query="get_offtime_cfc">
							<!--- <cfset temp_finishdate = CreateDateTime(year(finishdate),month(finishdate),day(finishdate),0,0,0)>
							<cfset temp_startdate = CreateDateTime(year(startdate),month(startdate),day(startdate),0,0,0)> --->
							<cfscript>
								day_total_ = 0;
								temp_finishdate = CreateDateTime(year(get_offtime_cfc.finishdate),month(get_offtime_cfc.finishdate),day(get_offtime_cfc.finishdate),0,0,0);
								temp_startdate = CreateDateTime(year(get_offtime_cfc.startdate),month(get_offtime_cfc.startdate),day(get_offtime_cfc.startdate),0,0,0);
								total_izin_ = fix(temp_finishdate-temp_startdate)+1;
								izin_startdate_ = date_add("h", session.ep.time_zone, startdate);
								izin_finishdate_ = date_add("h", session.ep.time_zone, finishdate);
								if (get_offtime_show_entitlements.WEEKING_WORKING_DAY eq 5)
									day_total_ = day_total_;
								else if (get_offtime_show_entitlements.WEEKING_WORKING_DAY eq 6)
									{
										for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
											{
												temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
												if (dayofweek(temp_izin_gunu_) eq 1)
													day_total_ = day_total_ + 1;
											}
									}	
								else if (get_offtime_show_entitlements.WEEKING_WORKING_DAY eq 7)
									{
										for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
											{
												temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
												if (dayofweek(temp_izin_gunu_) eq 7)
													day_total_ = day_total_ + 2;
											}									}						
								used_izin_gun = used_izin_gun + total_izin_ - day_total_;
							</cfscript>
						</cfloop>
					</cfif>
					<cfif IS_PERMISSION_TYPE eq 1><!--- saaat/dk cinsindense --->
						<cfsavecontent variable ="type_name">
							<cf_get_lang dictionary_id="57491.Saat">-<cf_get_lang dictionary_id="58127.Minute">
						</cfsavecontent>
						<cfset total_min_emp = 0>
                        <cfset use_hour = 1>
						<cfloop query="get_offtime_cfc">
							<cfif get_shift.recordcount>
								<cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
							<cfelse>
								<cfinclude template="/V16/hr/ehesap/display/offtime_calc.cfm">
							</cfif>
						</cfloop>
                        <cfset use_hour = 0>
						<tbody>
							<tr>
								<td>#OFFTIMECAT# (#type_name#)</td>
								<cfif len(MAX_PERMISSION_TIME)>
									<cfset max_per_hour = listfirst(MAX_PERMISSION_TIME,".")*60 + listlast(MAX_PERMISSION_TIME,".")>
									<cfset kalan_izin = max_per_hour - total_min_emp>
								<cfelse>
									<cfset kalan_izin = 0>
								</cfif>
								<td><cfif len(MAX_PERMISSION_TIME)>#TLformat(MAX_PERMISSION_TIME)#</cfif></td>
								<td>#int(total_min_emp / 60)#,#total_min_emp mod 60#</td>
								<td>#int(kalan_izin / 60)#,#kalan_izin mod 60#</td>
							</tr>
						</tbody>
					</cfif>
					<cfif IS_PERMISSION_TYPE eq 3><!--- yıl cinsindense --->
						<cfsavecontent variable ="type_name">
							<cf_get_lang dictionary_id="58455.Yıl">
						</cfsavecontent>
						<cfloop query="get_offtime_cfc">
							<cfset temp_finishdate = CreateDateTime(year(finishdate),month(finishdate),day(finishdate),0,0,0)>
							<cfset temp_startdate = CreateDateTime(year(startdate),month(startdate),day(startdate),0,0,0)>						
							<cfset 	used_izin_gun = fix(temp_finishdate-temp_startdate)>
						</cfloop>
					</cfif> 
					<cfif IS_PERMISSION_TYPE neq 1>
						<cfsavecontent variable ="type_name">
							<cf_get_lang dictionary_id='57490.Gün'>
						</cfsavecontent>
						<tbody>
							<tr>
								<td>#OFFTIMECAT# (#type_name#)</td>
								<cfif len(MAX_PERMISSION_TIME)>
									<cfset kalan_izin = MAX_PERMISSION_TIME - used_izin_gun>
								<cfelse>
									<cfset kalan_izin = 0>
								</cfif>
								<td><cfif len(MAX_PERMISSION_TIME)>#TLformat(MAX_PERMISSION_TIME)#</cfif></td>
								<td>#TLformat(used_izin_gun)#</td>
								<td>#TLformat(kalan_izin)#</td>
							</tr>
						</tbody>
					</cfif>
				</cfoutput>
			</table>
		</div>
</cf_box>