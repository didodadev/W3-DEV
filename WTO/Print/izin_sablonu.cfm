<!---
    File: izin_sablonu.cfm
    Author: Esma R. UYSAL<esmauysal@workcube.com>
    Date: 14/04/2020
    Description:
        Şablonda;
            Çalışan Bilgileri, Kulanılmak İstenen İzin Bilgileri, İzin Bilgileri, Çalışan İmza ve İzin Akış Tarihçesi vardır.
--->
<cfquery name="get_offtime_emp_info" datasource="#dsn#">
    SELECT 
        OFFTIME.*,
        SO.OFFTIMECAT AS KATEGORI,
        SO2.OFFTIMECAT AS ALT_KATEGORI,
        EMPLOYEES.EMPLOYEE_NAME,
        EMPLOYEES.EMPLOYEE_SURNAME,
        EMPLOYEES.EMPLOYEE_EMAIL,
        EMPLOYEES.EMPLOYEE_NO,
        EMPLOYEES.IZIN_DAYS,
        EMPLOYEES.IZIN_DATE,
        EMPLOYEES.OLD_SGK_DAYS,	
        EMPLOYEES_IDENTY.BIRTH_DATE,
        SO.OFFTIMECAT,
        SO.IS_PAID,
        SO.IS_YEARLY,
        SO.CALC_CALENDAR_DAY,
        (SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS,
    (SELECT TOP 1 FINISH_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS FINISH_DATE,
        SO.EBILDIRGE_TYPE_ID
    FROM 
        OFFTIME 
            INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID 
            INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES_IDENTY.EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID 
        LEFT JOIN SETUP_OFFTIME SO
        ON SO.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
        LEFT JOIN SETUP_OFFTIME SO2
    ON SO2.OFFTIMECAT_ID = OFFTIME.SUB_OFFTIMECAT_ID
	WHERE 
        OFFTIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
</cfquery> 
<cfset get_emp.izin_days = get_offtime_emp_info.IZIN_DAYS>
<cfset get_emp.izin_date = get_offtime_emp_info.IZIN_DATE>
<cfset get_emp.finish_date = get_offtime_emp_info.finish_date>
<cfset get_emp.PUANTAJ_GROUP_IDS = get_offtime_emp_info.PUANTAJ_GROUP_IDS>
<cfset get_emp.OLD_SGK_DAYS = get_offtime_emp_info.OLD_SGK_DAYS>
<cfset get_emp.BIRTH_DATE = get_offtime_emp_info.BIRTH_DATE>
<CFSET attributes.employee_id = get_offtime_emp_info.employee_id>
<cfset get_employee_shift = createObject("component","V16.hr.cfc.get_employee_shift")>
<cfif len(get_emp.IZIN_DATE)>
<!--- İZİN BAZ TARİHİNDEN ÖNCEKİ İZİNLER --->						
<cfquery name="get_offtime_old" datasource="#dsn#">
    SELECT 
        OFFTIME.*,
        SETUP_OFFTIME.OFFTIMECAT_ID,
        SETUP_OFFTIME.OFFTIMECAT,
        SETUP_OFFTIME.IS_PAID
    FROM 
        OFFTIME,
        SETUP_OFFTIME
    WHERE
        SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID AND
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
</cfif>

<cfset free_time_cmp = createObject("component","V16.myhome.cfc.free_time")>
<cfset calc_var = free_time_cmp.CALC_FREE_TIME(employee_id : get_offtime_emp_info.employee_id)>
<!--- İzin Süreleri XML'den ayarlanan 'Kaç yıldan itibaren geçmiş günün hesaba katılsın?' parametresi 20191030ERU --->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_FeeCalculation = get_fuseaction_property.get_fuseaction_property(
company_id : session.ep.company_id,
fuseaction_name : 'ehesap.popup_form_fire2',
property_name : 'x_salary_pay_count'
)
>
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

<!--- E-Profilde 'Geçmiş SGK Günü Girilsin mi?' parametresi 20191030ERU --->
<cfset get_old_sgk_year = get_fuseaction_property.get_fuseaction_property(
company_id : session.ep.company_id,
fuseaction_name : 'hr.form_upd_emp',
property_name : 'xml_old_sgk_days'
)
>
<cfif get_offtime_emp_info.recordcount>
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
    SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset offday_list = ''>
<cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
<cfset halfofftime_list2 = ''>
<cfset halfofftime_list3 = ''>
<cfset izin_sayilmayan_ = 0>
<cfset izin_sayilmayan = 0>
<cfscript>
    toplam_hakedilen_izin = 0;
    genel_izin_toplam = 0;
    old_days = 0;
</cfscript>
<!--- Genel tatiller --->
<cfoutput query="GET_GENERAL_OFFTIMES">
    <cfscript>
        offday_gun = datediff('d',get_general_offtimes.start_date,get_general_offtimes.finish_date)+1;
        offday_startdate = date_add("h", session.ep.time_zone, get_general_offtimes.start_date); 
        offday_finishdate = date_add("h", session.ep.time_zone, get_general_offtimes.finish_date);
        
        for (mck=0; mck lt offday_gun; mck=mck+1)
        {
            temp_izin_gunu =  date_add("d",mck,offday_startdate);
            daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
            if(not listfindnocase(offday_list,'#daycode#'))
                offday_list = listappend(offday_list,'#daycode#');
            if(get_general_offtimes.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
            {
                halfofftime_list = listappend(halfofftime_list,'#daycode#');
            }
        }
    </cfscript>
</cfoutput>
<!--- çalışma saati başlangıç ve bitişleri--->
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
<!--- Çalışan Pozisyon Bilgileri ---->
<cfquery name="get_positions_pdf" datasource="#dsn#">
    SELECT * FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_offtime_emp_info.employee_id# AND IS_MASTER = 1
</cfquery> 
<!--- Çalışan Ünvan ---->
<cfquery name="get_unvan" datasource="#dsn#">
 SELECT 
        TITLE
    FROM 
        SETUP_TITLE 
     WHERE 
         IS_ACTIVE = 1 
        AND TITLE_ID = #get_positions_pdf.title_id#
</cfquery>	
<!--- Çalışan Departman ---->
<cfquery name="get_department" datasource="#dsn#">
    SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_positions_pdf.department_id#
</cfquery>
<!--- Çalışan Bilgileri ---->
<cfquery name="get_employee" datasource="#dsn#">
    SELECT E.*,
    EI.BIRTH_DATE,
    (SELECT TOP 1 PUANTAJ_GROUP_IDS FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS PUANTAJ_GROUP_IDS,
    (SELECT TOP 1 FINISH_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID AND (FINISH_DATE IS NULL OR FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">) AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ORDER BY START_DATE DESC) AS FINISH_DATE
    FROM EMPLOYEES E
    INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
    WHERE E.EMPLOYEE_ID = #get_offtime_emp_info.employee_id#
</cfquery>
<!--- Çalışan İzinleri --->
<cfquery name="get_emp_in_out" datasource="#dsn#">
    SELECT   
        TOP 1 OUR_COMPANY.COMP_ID AS COMP_ID
    FROM
        EMPLOYEES_IN_OUT EI,
        BRANCH,
        DEPARTMENT,
        OUR_COMPANY
    WHERE
        EI.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime_emp_info.employee_id#"> AND
        DEPARTMENT.DEPARTMENT_ID = EI.DEPARTMENT_ID
        AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
        AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
    ORDER BY EI.IN_OUT_ID DESC
</cfquery>
<!--- Şirket çalışma saatleri --->
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
<cfquery name="get_progress_payment_outs" datasource="#dsn#">
    SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime_emp_info.employee_id#"> AND START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
</cfquery>
<!---- Yıllık limitler --->
<cfquery name="get_offtime_limits" datasource="#dsn#">
    SELECT 
        *
    FROM 
        SETUP_OFFTIME_LIMIT
</cfquery>
<!--- Çalışan izinleri --->
<cfquery name="get_offtime" datasource="#dsn#">
    SELECT 
        OFFTIME.*,
        SETUP_OFFTIME.OFFTIMECAT_ID,
        SETUP_OFFTIME.OFFTIMECAT,
        SETUP_OFFTIME.IS_PAID
    FROM 
        OFFTIME,
        SETUP_OFFTIME
    WHERE

        SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
        OFFTIME.IS_PUANTAJ_OFF = 0 AND
        OFFTIME.VALID = 1 AND
        SETUP_OFFTIME.IS_PAID = 1 AND
        SETUP_OFFTIME.IS_YEARLY = 1 AND
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offtime_emp_info.employee_id#">
    ORDER BY
        STARTDATE DESC
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
        EP.EMPLOYEE_ID = #get_offtime_emp_info.EMPLOYEE_ID# AND
        EP.BRANCH_ID = B.BRANCH_ID AND
        EP.COMP_ID = O.COMP_ID
    ORDER BY STARTDATE
</cfquery>
<cfset calisilan = 0>
<cfset calisilan_yil = 0>
<cfoutput query="get_eski_izinler">
    <cfif len(WORKED_DAY)>
        <cfset calisilan_employee = WORKED_DAY>
    <cfelse>
        <cfset calisilan_employee = datediff("d",startdate,finishdate)>
    </cfif>
    <cfset calisilan = calisilan + calisilan_employee>
</cfoutput>
<cfset calisilan_yil = calisilan / 365>
<cfscript>
    if (get_hours.recordcount and len(get_hours.weekly_offday))
        this_week_rest_day_ = get_hours.weekly_offday;
    else
        this_week_rest_day_ = 1;
    if (len(get_employee.izin_days))
        old_days = get_employee.izin_days;
    else
        old_days = 0;
</cfscript>
<cfsavecontent variable="yillik_izin_form">
    <style>
        #yillik_izin_baslik {
        display:table;
        border-collapse: collapse;
        width: 100%;
        font-family:'Verdana';
        font-size:13px;
        }
        
        #yillik_izin_baslik tr, #yillik_izin_baslik th, #yillik_izin_baslik td {
        border: 1px solid #eaeaea;
        padding:2px;
        }
        #yillik_izin_baslik th {
        text-align: center;
        
        }
    </style>
    <cfquery name="CHECK" datasource="#DSN#">
    SELECT
    ASSET_FILE_NAME3
    FROM
    OUR_COMPANY
    WHERE
    COMP_ID = #SESSION.EP.COMPANY_ID#
</cfquery>
    <cfoutput>
        <table id="yillik_izin_baslik">
            <tr>
                <table id="yillik_izin_baslik">
                    <tr>
                        <th colspan="2" style="text-align: right;">
                            <cfif len(CHECK.asset_file_name3)><cfoutput><img src="#user_domain##file_web_path#settings/#CHECK.asset_file_name3#" border="0"></cfoutput></cfif>
                        </th>
                    </tr>
                    <tr>
                        <th colspan="2" style="padding : 5px; font-weight:bold; font-size:16px;">BORSA İSTANBUL A.Ş. ÇALIŞAN <cfif get_offtime_emp_info.is_yearly eq 1>YILLIK</cfif> İZİN FORMU</th>
                    </tr>
                    <tr>
                        <td style="width:50%">Belge Numarası : #year(now())# - IZIN - #get_offtime_emp_info.OFFTIME_ID#</td>
                        <td style="width:50%">Form Tarihi : #dateFormat(now(),dateformat_style)#</td>
                    </tr>
                    <tr>
                        <th colspan="2" style="padding : 5px;">Çalışan Bilgileri</td>
                    </tr>
                    <tr>
                        <td style="width:50%">Sicil No</td>
                        <td style="width:50%">#get_offtime_emp_info.EMPLOYEE_NO#</td>
                    </tr>
                    <tr>
                        <td style="width:50%">Adı Soyadı</td>
                        <td style="width:50%">#get_employee.employee_name# #get_employee.employee_surname#</td>
                    </tr>
                    <tr>
                        <td style="width:50%">Unvan</td>
                        <td style="width:50%">#get_unvan.title#</td>
                    </tr>
                    <tr>
                        <td style="width:50%">Pozisyon</td>
                        <td style="width:50%">#get_positions_pdf.position_name#</td>
                    </tr>
                    <tr>
                        <td style="width:50%">Görev Yaptığı Birim</td>
                        <td style="width:50%">#get_department.DEPARTMENT_HEAD#</td>
                    </tr>
                    <tr>
                        <th colspan="2" style="padding : 5px;">	Kulanılmak İstenen İzin Bilgileri</th>
                    </tr>
                    <tr>
                        <td style="width:50%">İzin Türü</td>
                        <td style="width:50%"><cfif len(get_offtime_emp_info.ALT_KATEGORI)>#get_offtime_emp_info.ALT_KATEGORI#<cfelse>#get_offtime_emp_info.KATEGORI#</cfif></td>
                    </tr>
                    <tr>
                        <td style="width:50%">İzin Başlangıç Tarihi</td>
                        <td style="width:50%">#dateFormat(get_offtime_emp_info.startdate,dateformat_style)# #timeformat(get_offtime_emp_info.startdate,'HH:MM')#</td>
                    </tr>
                    <tr>
                        <td style="width:50%">İzin Bitiş Tarihi</td>
                        <td style="width:50%">#dateFormat(get_offtime_emp_info.finishdate,dateformat_style)# #timeformat(get_offtime_emp_info.finishdate,'HH:MM')#</td>
                    </tr>
                    <tr>
                        <td style="width:50%">İş Başlama Tarihi</td>
                        <td style="width:50%">#dateFormat(get_offtime_emp_info.work_startdate,dateformat_style)# #timeformat(get_offtime_emp_info.work_startdate,'HH:MM')#</td>
                    </tr>
                    <tr>
                        <td style="width:50%">Toplam İzinli Gün Sayısı</td>
                        <td style="width:50%">
                            <cfset offday_list_ = ''>
                            <cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
                            <cfset halfofftime_list2 = ''>
                            <cfloop query="GET_GENERAL_OFFTIMES">
                                <cfscript>
                                    offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
                                    offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
                                    offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
                                    for (mck=0; mck lt offday_gun; mck=mck+1)
                                    {
                                        temp_izin_gunu = date_add("d",mck,offday_startdate);
                                        daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
                                        if(not listfindnocase(offday_list_,'#daycode#'))
                                        offday_list_ = listappend(offday_list_,'#daycode#');
                                        if(GET_GENERAL_OFFTIMES.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
                                        {
                                            halfofftime_list = listappend(halfofftime_list,'#daycode#');
                                        }
                                    }
                                    
                                </cfscript>
							</cfloop>
							<!--- ortak dosya kullanıldığı için atamaları yapılıyor --->
                            <cfset finishdate = get_offtime_emp_info.finishdate>
                            <cfset startdate  = get_offtime_emp_info.startdate>
                            <cfset get_offtimes.is_paid = get_offtime_emp_info.is_paid>
                            <cfset get_offtimes.ebildirge_type_id = get_offtime_emp_info.ebildirge_type_id>
                            <cfset saturday_on = get_offtime_limits.saturday_on>
							<cfset sunday_on = get_offtime_limits.sunday_on>
							<cfif  get_offtime_limits.recordcount and len(get_offtime_limits.day_control)>
								<cfset day_control_afternoon = get_offtime_limits.day_control_afternoon>
							<cfelse>
								<cfset day_control_afternoon = 0>
							</cfif>
							<cfif  get_offtime_limits.recordcount and len(get_offtime_limits.day_control)>
								<cfset day_control = get_offtime_limits.day_control>
							<cfelse>
								<cfset day_control = 0>
							</cfif>
                            <cfif get_offtime_limits.recordcount and len(get_offtime_limits.public_holiday_on)>
                                <cfset public_holiday_on = get_offtime_limits.public_holiday_on>
                            <cfelse>
                                <cfset public_holiday_on = 0>
                            </cfif> 
                            <cfset get_offtimes.CALC_CALENDAR_DAY = get_offtime_emp_info.CALC_CALENDAR_DAY>
                            <cfset genel_dk_toplam = 0>
                            <!--- Çalışanın vardiyalı çalışma saatleri --->
                            <cfset get_shift = get_employee_shift.get_emp_shift(employee_id : get_offtime_emp_info.employee_id)>
                            
                            <cfif get_shift.recordcount>
                                <cfinclude template="/V16/hr/ehesap/display/offtime_calc_shift.cfm">
                            <cfelse>
                                <cfinclude template="/V16/hr/ehesap/display/offtime_calc.cfm">
                            </cfif>
                            <!--- #izin_gun# --->
                            #TLFormat(total_day_calc,2)# (
                            <cfsavecontent variable = "day">
                                <cf_get_lang dictionary_id ="57490.Gün">
                            </cfsavecontent>
                            <cfsavecontent variable = "hour">
                                <cf_get_lang dictionary_id ="57491.Saat">
                            </cfsavecontent>
                            <cfsavecontent variable = "min">
                                <cf_get_lang dictionary_id ="58827.Dk">
                            </cfsavecontent>
                            <cfif days neq 0>#days##left(day,1)# </cfif>
                            <cfif hours neq 0>#hours##left(hour,1)# </cfif>
                            <cfif minutes neq 0>#minutes##min# </cfif>)
                        </td>
                    </tr>
                    <tr>
                        <td style="width:50%">Yeri(Adres)</td>
                        <td style="width:50%">#get_offtime_emp_info.address#</td>
                    </tr>
                </table>
            </tr>
            <tr>
				<td>
					<cfset attributes.employee_id = get_offtime_emp_info.employee_id>
					<cfsavecontent variable="izin_detay_info">
						<cfinclude template="/V16/hr/display/list_offtime_emp_days.cfm">
					</cfsavecontent>
					<table id="yillik_izin_baslik">
						<tr>
							<th colspan="2" style="padding : 5px;">İzin Bilgileri</th>
						</tr>
						<tr>
							<td style="width:50%">İşe Giriş Tarihi</td>
							<td style="width:50%">#dateFormat(get_employee.GROUP_STARTDATE,dateformat_style)#</td>
						</tr>
						<tr>
							<td style="width:50%">Daha Önceki Çalışma Süresi(Yıl)</td>
							<td style="width:50%">#wrk_round(old_sgk_year,2)#</td>
						</tr>
						<tr>
							<cfset toplam_calisma = DateDiff("d",get_employee.GROUP_STARTDATE,now())>
							<cfset toplam_calisma = toplam_calisma + calisilan	>
							<cfset toplam_calisma = toplam_calisma / 365>
							<td style="width:50%">Toplam Çalışma Süresi (Yıl)</td>
							<td style="width:50%">#wrk_round(toplam_calisma,2)#</td>
						</tr>
						<tr>
							<td style="width:50%">Kalan İzin Hakkı(Gün)</td>
							<td style="width:50%">#wrk_round(toplam_hakedilen_izin-genel_dk_toplam-old_days,2)#</td>
						</tr>
					</table>
					<table id="yillik_izin_baslik">
						<tr>
							<th colspan="2" style="height : 100px; vertical-align : top;">Çalışanın İmzası</th>
						</tr>
					</table>
				</td>
            </tr>
            <tr>
                <td>
                    <table id="yillik_izin_baslik">
                        <tr>
                            <th colspan="4">Akış Tarihçesi</th>
                        </tr>
                        <tr>
                            <th style="width:25%">Kullanıcı</th>
                            <th style="width:25%">Unvanı</th>
                            <th style="width:25%">İşlem</th>
                            <th style="width:25%">Tarih</th>
                        </tr>
                        <cfquery name="get_actions" datasource="#dsn#">
                            SELECT 
                                PW.WARNING_HEAD,
                                PW.W_ID,
                                PW.POSITION_CODE,
                                PW.RECORD_EMP,
                                PW.RECORD_PAR,
                                PW.RECORD_CON,
                                PW.SETUP_WARNING_ID,
                                PWA.WARNING_ID AS PWA_WARNING_ID,
                                PWA.IS_CONFIRM AS PWA_IS_CONFIRM, 
                                PWA.IS_AGAIN AS PWA_IS_AGAIN,
                                PWA.IS_SUPPORT AS PWA_IS_SUPPORT,
                                PWA.IS_CANCEL AS PWA_IS_CANCEL,
                                PWA.IS_REFUSE AS PWA_IS_REFUSE,
                                PWA.RECORD_DATE AS PWA_RECORD_DATE
                            FROM 
                                PAGE_WARNINGS AS PW
                                LEFT JOIN PAGE_WARNINGS_ACTIONS AS PWA ON PW.W_ID = PWA.WARNING_ID
                            WHERE 
                                PW.ACTION_ID = #attributes.iid#
                                AND PW.ACTION_TABLE = 'OFFTIME'
                                AND PW.IS_PARENT=1 
                        </cfquery>
                        <tr>
                            <td style="width:25%">#get_employee.employee_name# #get_employee.employee_surname#</td>
                            <td style="width:25%">#get_unvan.title#</td>
                            <td style="width:25%">Oluşturma - Onaya Gönderme</td>
                            <td style="width:25%">#dateFormat(get_offtime_emp_info.record_date,dateformat_style)# #timeformat(get_offtime_emp_info.record_date,'HH:MM')#</td>
                        </tr>
                        <cfloop query="get_actions">
                            <!--- yönetici Pozisyon Bilgileri ---->
                            <cfquery name="get_positions_process" datasource="#dsn#">
                                SELECT TITLE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_actions.POSITION_CODE# AND IS_MASTER = 1
                            </cfquery> 
                            <!--- yönetici Ünvan ---->
                            <cfquery name="get_unvan" datasource="#dsn#">
                            SELECT 
                                    TITLE
                                FROM 
                                    SETUP_TITLE 
                                WHERE 
                                    IS_ACTIVE = 1 
                                    AND TITLE_ID = #get_positions_process.title_id#
                            </cfquery>
                            <tr>
                                <td style="width:25%">#get_emp_info(get_actions.POSITION_CODE,1,0,0)#</td>
                                <td style="width:25%">#get_unvan.title#</td>
                                <td style="width:25">
                                    <cfif len(get_actions.PWA_IS_CONFIRM) and get_actions.PWA_IS_CONFIRM eq 1>
                                        (Onaylandı)
                                    <cfelseif  len(get_actions.PWA_IS_REFUSE) and get_actions.PWA_IS_REFUSE eq 1>
                                        (Reddedildi)
                                         
                                    <cfelse>
                                        (Onay Bekliyor)
                                    </cfif>
                                </td>
                                <td style="width:25%">#dateFormat(get_actions.PWA_RECORD_DATE,dateformat_style)# #timeformat(get_actions.PWA_RECORD_DATE,'HH:MM')#</td>
                            </tr>
                            <cfif  len(get_actions.PWA_IS_REFUSE) and get_actions.PWA_IS_REFUSE eq 1>
                                <cfbreak>
                            </cfif>
                        </cfloop>
                    </table>
                </td>
            </tr>
        </table>
    </cfoutput>
</cfif>