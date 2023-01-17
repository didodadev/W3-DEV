<cfsetting showdebugoutput="no" requestTimeout = "2000">
<cfprocessingdirective suppresswhitespace="yes">
<cf_xml_page_edit fuseact='report.employee_analyse_report'>
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.salary_year" default="#session.ep.period_year#">
<cfparam name="attributes.salary_month" default="#dateformat(now(),'m')#">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.kidem_date1" default="">
<cfparam name="attributes.kidem_date2" default="">
<cfparam name="attributes.izin_date1" default="">
<cfparam name="attributes.izin_date2" default="">
<cfparam name="attributes.lower_salary_range" default="">
<cfparam name="attributes.upper_salary_range" default="">
<cfparam name="attributes.group_start_date1" default="">
<cfparam name="attributes.group_start_date2" default="">
<cfparam name="attributes.birth_date1" default="">
<cfparam name="attributes.birth_date2" default="">
<cfparam name="attributes.birth_place" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.married" default="">
<cfparam name="attributes.sex" default="">
<cfparam name="attributes.blood_type" default="">
<cfparam name="attributes.last_school" default="">
<cfparam name="attributes.languages" default="">
<cfparam name="attributes.position_cats" default="">
<cfparam name="attributes.titles" default="">
<cfparam name="attributes.organization_steps" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.user_type" default="">
<cfparam name="attributes.upper_position_code2" default="">
<cfparam name="attributes.upper_position2" default="">
<cfparam name="attributes.upper_position_code" default="">
<cfparam name="attributes.upper_position" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.pos_status" default="-1">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.add_info" default="">
<cfparam name="attributes.explanation_id" default="">
<cfparam name="attributes.branch_type" default="">
<cfparam name="attributes.transport_type_id" default="">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.military_status" default="">
<cfparam name="attributes.old_sgk_days" default="">
<cfparam name="attributes.is_special_code" default="">
<cfparam name="attributes.document_name" default="">
<cfparam name="attributes.document_date" default="">
<cfparam name="attributes.lang_status" default="">
<cfparam name="attributes.education_name" default="">
<cfparam name="attributes.edu_lang" default="">
<cfparam name="attributes.edu_part_id" default="">
<cfparam name="attributes.edu_high_part_id" default="">
<cfparam name="attributes.group_id" default="">
<cfparam name="attributes.paper_name" default="">
<cfparam name="attributes.position_status" default="-1">
<cfparam name="attributes.proxy_user_type" default="">
<cfparam name="attributes.country_id" default="">
<cfparam name="attributes.sureli_is_akdi" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">

<cfscript>
	if (fusebox.use_period)
		center_dsn = dsn2_alias;
	else
		center_dsn = dsn_alias;
	attributes.to_day = CreateDate(year(now()),month(now()), day(now()));
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = CreateDate(year(now()),month(now()),DaysInMonth(bu_ay_basi));
</cfscript>
<cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company = cmp_company.get_company(is_control : 1);
	cmp_zone = createObject("component","V16.hr.cfc.get_zones");
	cmp_zone.dsn = dsn;
	get_zone = cmp_zone.get_zone();
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(comp_id : '#iif(len(attributes.comp_id),"attributes.comp_id",DE(""))#', ehesap_control : 1);
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	get_title = cmp_title.get_title();
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cat = cmp_pos_cat.get_position_cat();
	cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps");
	cmp_org_step.dsn = dsn;
	get_org_step = cmp_org_step.get_organization_step();
	cmp_func = createObject("component","V16.hr.cfc.get_functions");
	cmp_func.dsn = dsn;
	get_func = cmp_func.get_function();
	url_str = "";
	if(isdefined('attributes.form_submitted'))
		url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
	if(isdefined('attributes.comp_id') and len(attributes.comp_id))
		url_str = "#url_str#&comp_id=#attributes.comp_id#";
	if(isdefined('attributes.branch_id') and len(attributes.branch_id))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if(isdefined('attributes.zone_id') and len(attributes.zone_id))
        url_str = "#url_str#&zone_id=#attributes.zone_id#";
    if(isdefined('attributes.department_id') and len(attributes.department_id))
		url_str = "#url_str#&department_id=#attributes.department_id#";
	if(isdefined('attributes.department') and len(attributes.department))
		url_str = "#url_str#&department=#attributes.department#";
	if(isdefined('attributes.title_id') and len(attributes.title_id))
		url_str = "#url_str#&title_id=#attributes.title_id#";
	if(isdefined('attributes.collar_type') and len(attributes.collar_type))
		url_str = "#url_str#&collar_type=#attributes.collar_type#";
	if(isdefined('attributes.pos_cat_id') and len(attributes.pos_cat_id))
		url_str = "#url_str#&pos_cat_id=#attributes.pos_cat_id#";
	if(isdefined('attributes.org_step_id') and len(attributes.org_step_id))
		url_str = "#url_str#&org_step_id=#attributes.org_step_id#";
	if(isdefined('attributes.func_id') and len(attributes.func_id))
		url_str = "#url_str#&func_id=#attributes.func_id#";
	if(isdefined('attributes.status') and len(attributes.status))
		url_str = "#url_str#&status=#attributes.status#";
	if(isdefined('attributes.blood_type') and len(attributes.blood_type))
		url_str = "#url_str#&blood_type=#attributes.blood_type#";
	if(isdefined('attributes.gender') and len(attributes.gender))
		url_str = "#url_str#&gender=#attributes.gender#";
	if(isdefined('attributes.education') and len(attributes.education))
		url_str = "#url_str#&education=#attributes.education#";
	if(isdefined('attributes.inout_statue') and len(attributes.inout_statue))
		url_str = "#url_str#&inout_statue=#attributes.inout_statue#";
	if(isdefined('attributes.defection_level') and len(attributes.defection_level))
		url_str = "#url_str#&defection_level=#attributes.defection_level#";
	if(isdefined('attributes.duty_type') and len(attributes.duty_type))
		url_str = "#url_str#&duty_type=#attributes.duty_type#";
	if(isdefined('attributes.use_ssk') and len(attributes.use_ssk))
		url_str = "#url_str#&use_ssk=#attributes.use_ssk#";
	if(isdefined('attributes.ssk_statute') and len(attributes.ssk_statute))
		url_str = "#url_str#&ssk_statute=#attributes.ssk_statute#";
	if(isdefined('attributes.startdate') and len(attributes.startdate))
		url_str = "#url_str#&start_date=#dateformat(attributes.startdate,dateformat_style)#";
	if(isdefined('attributes.finishdate') and len(attributes.finishdate))
		url_str = "#url_str#&finish_date=#dateformat(attributes.finishdate,dateformat_style)#";
	if(isdefined('attributes.report_type') and len(attributes.report_type))
		url_str = "#url_str#&report_type=#attributes.report_type#";
	if(isdefined("attributes.report_base") and len(attributes.report_base))
		url_str = "#url_str#&report_base=#attributes.report_base#";
	if(isdefined('is_get_pos_chng') and len(attributes.is_get_pos_chng))
		url_str = "#url_str#&is_get_pos_chng=#attributes.is_get_pos_chng#";
	if(isdefined('is_all_dep') and len(attributes.is_all_dep))
		url_str = "#url_str#&is_all_dep=#attributes.is_all_dep#";
    if(isdefined('old_sgk_days') and len(attributes.old_sgk_days))
        url_str = "#url_str#&old_sgk_days=#attributes.old_sgk_days#";
    if(isdefined('military_status') and len(attributes.military_status))
    url_str = "#url_str#&military_status=#attributes.military_status#";
    if(isdefined('attributes.document_name') and len(attributes.document_name))
        url_str = "#url_str#&document_name=#attributes.document_name#";
    if(isdefined('attributes.document_date') and len(attributes.document_date))
        url_str = "#url_str#&document_date=#dateformat(attributes.document_date,dateformat_style)#";
    if(isdefined('attributes.lang_status') and len(attributes.lang_status))
        url_str = "#url_str#&lang_status=#attributes.lang_status#";
    if(isdefined('attributes.group_id') and len(attributes.group_id))
        url_str = "#url_str#&group_id=#attributes.group_id#";
    if(isdefined('attributes.paper_name') and len(attributes.paper_name))
        url_str = "#url_str#&paper_name=#attributes.paper_name#";
    if(isdefined('attributes.country_id') and len(attributes.country_id))
        url_str = "#url_str#&country_id=#attributes.country_id#";
</cfscript>

<cfif isdefined("attributes.form_submitted")>
	<cfif
		isdefined('attributes.is_position_name') or
		isdefined('attributes.is_poscat') or
		isdefined('attributes.is_function') or
		isdefined('attributes.is_collar_type') or
		isdefined('attributes.is_org_position') or
		isdefined('attributes.is_title') or
		isdefined('attributes.is_idariamir') or
		isdefined('attributes.is_fonkamir') or
		isdefined('attributes.is_organization_step')or
		len(attributes.position_cats) or
		len(attributes.organization_steps) or
		len(attributes.upper_position_code) or
		len(attributes.upper_position) or
		len(attributes.func_id) or
		len(attributes.titles) or
		len(attributes.upper_position_code2) or
		len(attributes.upper_position2) or
		len(attributes.user_type) or
		(len(attributes.comp_id) and attributes.branch_type eq 1) or
		(len(attributes.zone_id) and attributes.branch_type eq 1) or
		(len(attributes.branch_id) and attributes.branch_type eq 1) or
		(len(attributes.department_id) and attributes.branch_type eq 1) or
        len(attributes.collar_type) or
        len(attributes.group_id) or
        len(attributes.position_status) or
        len(attributes.proxy_user_type) or
		attributes.branch_type eq 1
		>
		<cfset attributes.is_pos = 1>
	</cfif>
	<cfif
		isdefined('attributes.is_pdks') or
		isdefined('attributes.is_salary_plan') or
		isdefined('attributes.is_salary') or
		isdefined('attributes.is_salary_type') or
		isdefined('attributes.is_accounting_accounts') or
		isdefined('attributes.is_first_ssk') or
		isdefined('attributes.is_finish_date') or
		isdefined('attributes.is_start_date') or
		isdefined('attributes.is_expense') or
		isdefined('attributes.is_account_code') or
		isdefined('attributes.is_reason') or
		isdefined('attributes.is_reason_out') or
		isdefined('attributes.is_duty_type') or
		isdefined('attributes.is_business_code') or
		isdefined('attributes.is_expense') or
		isdefined('attributes.in_comp_reason') or <!---20131108--->
		isdefined('attributes.fire_detail') or
		isdefined('attributes.is_kidem_') or
        isdefined('attributes.is_country_id') or
		len(attributes.explanation_id) or
		len(attributes.inout_statue) or
		len(attributes.startdate) or
		len(attributes.finishdate) or
		len(attributes.salary_type) or
		len(attributes.gross_net) or
		len(attributes.ssk_statute) or
		len(attributes.defection_level) or
		len(attributes.law_numbers) or
		len(attributes.transport_type_id) or
		len(attributes.duty_type) or
		len(attributes.use_pdks) or
		len(attributes.shift_id) or
		len(attributes.lower_salary_range) or
		len(attributes.upper_salary_range) or
		len(attributes.expense_center_id) or
		attributes.branch_type eq 2
		>
		<cfset attributes.in_out = 1>
	</cfif>
	<cfif
		isdefined('attributes.is_company') or
		isdefined('attributes.is_comp_branch') or
		isdefined('attributes.is_branch') or
		isdefined('attributes.is_department') or
		isdefined('attributes.is_hierarchy_dep') or
		isdefined('attributes.is_position_name') or
		isdefined('attributes.is_poscat')
		>
		<cfif not ((isdefined('attributes.in_out') and attributes.in_out eq 1) or attributes.branch_type eq 2)>
			<cfset attributes.branch_type = 1>
			<cfset attributes.is_pos = 1>
		</cfif>
		<cfif not ((isdefined('attributes.is_pos') and attributes.is_pos eq 1) or attributes.branch_type eq 1)>
			<cfset attributes.branch_type = 2>
			<cfset attributes.in_out = 1>
		</cfif>
	</cfif>
	<cfif isdate(attributes.kidem_date1)><cf_date tarih = "attributes.kidem_date1"></cfif>
	<cfif isdate(attributes.kidem_date2)><cf_date tarih = "attributes.kidem_date2"></cfif>
	<cfif isdate(attributes.group_start_date1)><cf_date tarih = "attributes.group_start_date1"></cfif>
	<cfif isdate(attributes.group_start_date2)><cf_date tarih = "attributes.group_start_date2"></cfif>
	<cfif isdate(attributes.birth_date1)><cf_date tarih = "attributes.birth_date1"></cfif>
	<cfif isdate(attributes.birth_date2)><cf_date tarih = "attributes.birth_date2"></cfif>
	<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
	<cfif isdate(attributes.izin_date1)><cf_date tarih = "attributes.izin_date1"></cfif>
    <cfif isdate(attributes.izin_date2)><cf_date tarih = "attributes.izin_date2"></cfif>
    <cfif isdate(attributes.document_date)><cf_date tarih = "attributes.document_date"></cfif>
	<cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1>
    	<cfquery name="get_expense_center" datasource="#center_dsn#">
        	IF EXISTS (SELECT * FROM TEMPDB.SYS.TABLES WHERE NAME='####EMP_ANALY_REPORT')
            DROP TABLE ####EMP_ANALY_REPORT
        </cfquery>	
	</cfif>
    <cfquery name="get_employee" datasource="#dsn#">
		SELECT DISTINCT
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NO,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_EMAIL,
			E.MOBILCODE,
			E.MOBILTEL,
			E.GROUP_STARTDATE,
			E.KIDEM_DATE,
			E.IZIN_DATE,
            E.HIERARCHY,
            E.OZEL_KOD,
            E.OZEL_KOD2,
            CASE 
                WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 
                    THEN '/documents/hr/'+E.PHOTO 
                WHEN E.PHOTO IS NULL AND ED.SEX = 0
                    THEN  '/images/female.jpg'
            ELSE '/images/male.jpg' END AS PHOTO,
            E.OLD_SGK_DAYS,
            ED.MOBILCODE_SPC,
            ED.MOBILTEL_SPC,
			ED.HOMEADDRESS AS ADDRESS,
			ED.HOMECITY AS CITY,
			ED.HOMECOUNTY AS COUNTY,
			ED.HOMETEL_CODE,
			ED.HOMETEL,
			ED.SEX,
			ED.LAST_SCHOOL,
			ED.MILITARY_STATUS,
            EI.LAST_SURNAME,
			EI.TC_IDENTY_NO,
			EI.TAX_NUMBER,
			EI.TAX_OFFICE,
			EI.BLOOD_TYPE,
			EI.BIRTH_DATE,
			EI.MARRIED,
			EI.BIRTH_PLACE,
			EI.FATHER,
			EI.MOTHER,
            EI.CITY AS IDENTY_CITY,
            EI.BINDING,
            EI.COUNTY AS IDENTY_COUNTY,
            EI.FAMILY,
            EI.WARD,
            EI.CUE,
            EI.VILLAGE,
            EI.GIVEN_PLACE,
            EI.RECORD_NUMBER,
            EI.GIVEN_REASON,
            EI.GIVEN_DATE,
            EI.SERIES,
            EI.NUMBER
            <cfif isdefined('attributes.is_country_id') and Len(attributes.is_country_id)>
                ,SETUP_COUNTRY.COUNTRY_NAME
            </cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
				,B.BRANCH_NAME
				,D.DEPARTMENT_HEAD,
                SPECIAL_CODE,
                <cfif isdefined("attributes.inout_statue") and ((isdefined('attributes.startdate') and isdate(attributes.startdate)) and (isdefined('attributes.finishdate') and isdate(attributes.finishdate)))>
                	CASE
                    	WHEN D.DEPARTMENT_ID NOT IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
                  	THEN
                    	 D.HIERARCHY_DEP_ID
                   	ELSE
                    	CASE WHEN 
                    		(SELECT TOP 1 DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CHANGE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ORDER BY CHANGE_DATE) IS NULL
                        THEN
                        	(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ORDER BY CHANGE_DATE DESC)
                      	ELSE
                        	(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CHANGE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ORDER BY CHANGE_DATE)
                      	END 
                    END AS HIERARCHY_DEP_ID
				<cfelse>
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
                    END AS HIERARCHY_DEP_ID
                </cfif>,
                <cfif isdefined("attributes.inout_statue") and ((isdefined('attributes.startdate') and isdate(attributes.startdate)) and (isdefined('attributes.finishdate') and isdate(attributes.finishdate)))>
                	CASE
                    	WHEN D.DEPARTMENT_ID NOT IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
                  	THEN
                    	 D.LEVEL_NO
                   	ELSE
                    	CASE WHEN 
                    		(SELECT TOP 1 DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CHANGE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ORDER BY CHANGE_DATE) IS NULL
                        THEN
                        	(SELECT TOP 1 LEVEL_NO FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> ORDER BY CHANGE_DATE DESC)
                      	ELSE
                        	(SELECT TOP 1 LEVEL_NO FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CHANGE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> ORDER BY CHANGE_DATE)
                      	END 
                    END AS LEVEL_NO
				<cfelse>
                    CASE 
                        WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
                    THEN	
                        D.LEVEL_NO
                    ELSE 
                    	CASE WHEN 
                        	D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
                     	THEN
                        	(SELECT TOP 1 LEVEL_NO FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                 		ELSE
                        	D.LEVEL_NO
                     	END
                   	END AS LEVEL_NO
                </cfif>
				,(SELECT ZONE_NAME FROM ZONE WHERE ZONE_ID = B.ZONE_ID) ZONE_NAME
				,OC.NICK_NAME
			</cfif>
			<cfif isdefined('attributes.is_pos') and attributes.is_pos eq 1>
				,(CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POSITION_CODE ELSE EPOS.POSITION_CODE END) AS POSITION_CODE
                ,(CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POSITION_NAME ELSE EPOS.POSITION_NAME END) AS POSITION_NAME
                ,(CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POSITION_ID ELSE EPOS.POSITION_ID END) AS POSITION_ID
				,(CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.COLLAR_TYPE ELSE EPOS.COLLAR_TYPE END) AS COLLAR_TYPE
				,(CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.ORGANIZATION_STEP_ID ELSE EPOS.ORGANIZATION_STEP_ID END) AS ORGANIZATION_STEP_ID1
				,ST.TITLE AS TITLE1
				,(SELECT SPC.POSITION_CAT FROM SETUP_POSITION_CAT SPC WHERE SPC.POSITION_CAT_ID = (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POSITION_CAT_ID ELSE EPOS.POSITION_CAT_ID END)) POSITION_CAT
				,(SELECT SCU.UNIT_NAME FROM SETUP_CV_UNIT SCU WHERE SCU.UNIT_ID = (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.FUNC_ID ELSE EPOS.FUNC_ID END)) UNIT_NAME
				,(CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN (SELECT TOP 1 EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS_HISTORY EPH WHERE EPH.POSITION_CODE = ECH.UPPER_POSITION_CODE) ELSE (SELECT TOP 1 EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = EPOS.UPPER_POSITION_CODE) END) AS IDARIAMIR
				,(CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN (SELECT TOP 1 EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS_HISTORY EPH WHERE EPH.POSITION_CODE = ECH.UPPER_POSITION_CODE2) ELSE (SELECT TOP 1 EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = EPOS.UPPER_POSITION_CODE2) END) AS FONKSIYONAMIR
                ,(CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POSITION_STATUS ELSE EPOS.POSITION_STATUS END) POSITION_STATUS
			</cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1)>
            	,FR.REASON
                ,EIO.PUANTAJ_GROUP_IDS
				,EIO.DUTY_TYPE
                ,EIO.DETAIL
				,EIO.FIRST_SSK_DATE
				,EIO.START_DATE
				,EIO.SALARY_TYPE
				,EIO.GROSS_NET
				,(SELECT TOP 1 EIOP.EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">) AS EXPENSE_CODE
				,(SELECT TOP 1 EIOP.EXPENSE_CENTER_ID FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">) AS EXPENSE_CENTER_ID
				,(SELECT TOP 1 EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">) AS ACCOUNT_CODE
				,(SELECT TOP 1 ST2.TITLE FROM SETUP_TITLE ST2,EMPLOYEE_POSITIONS EP2 WHERE ST2.TITLE_ID = EP2.TITLE_ID AND EP2.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP2.IS_MASTER = 1) AS TITLE
				,EIO.EXPLANATION_ID AS Gerekce
				,EIO.FINISH_DATE
				,EIO.PDKS_NUMBER
				,EIO.USE_PDKS
				,EIO.PDKS_TYPE_ID
				,EIO.IN_OUT_ID
				,EIO.EX_IN_OUT_ID
                ,EIO.SURELI_IS_FINISHDATE
				,(SELECT TOP 1 SP.DEFINITION FROM EMPLOYEES_IN_OUT_PERIOD EIOP,SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SP WHERE SP.PAYROLL_ID = EIOP.ACCOUNT_BILL_TYPE AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">) AS ACCOUNT_BILL_TYPE
                ,(SELECT TOP 1 BUSINESS_CODE_NAME FROM SETUP_BUSINESS_CODES WHERE BUSINESS_CODE_ID = EIO.BUSINESS_CODE_ID) AS BUSINESS_CODE_NAME
                ,(SELECT TOP 1 BUSINESS_CODE FROM SETUP_BUSINESS_CODES WHERE BUSINESS_CODE_ID = EIO.BUSINESS_CODE_ID) AS BUSINESS_CODE
                ,(SELECT STEP FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND EMPLOYEE_ID = EIO.EMPLOYEE_ID) AS STEP
                ,(SELECT GRADE FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND EMPLOYEE_ID = EIO.EMPLOYEE_ID) AS GRADE
                ,(SELECT EXTRA FROM SALARY_FACTORS WHERE GRADE = (SELECT GRADE FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND EMPLOYEE_ID = EIO.EMPLOYEE_ID)) AS EXTRA
                ,(SELECT 
                CASE WHEN (SELECT STEP FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND EMPLOYEE_ID = EIO.EMPLOYEE_ID) = 1 THEN
                        GRADE1_VALUE 
                WHEN (SELECT STEP FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND EMPLOYEE_ID = EIO.EMPLOYEE_ID) = 2THEN
                        GRADE2_VALUE 
                WHEN (SELECT STEP FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND EMPLOYEE_ID = EIO.EMPLOYEE_ID)= 3THEN
                        GRADE3_VALUE 
                WHEN (SELECT STEP FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND EMPLOYEE_ID = EIO.EMPLOYEE_ID) = 4THEN
                        GRADE4_VALUE 
                END GRADE_VALUE
                FROM
                    SALARY_FACTORS
                WHERE
                    GRADE =(SELECT GRADE FROM EMPLOYEES_RANK_DETAIL WHERE PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND EMPLOYEE_ID = EIO.EMPLOYEE_ID)
                ) AS GRADE_VALUE
               , (SELECT SALARY_FACTOR FROM SALARY_FACTOR_DEFINITION WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> )	AS SALARY_FACTOR				
				,(SELECT TOP 1 HesaplanmisKidemBaslangic FROM GET_EMPLOYEE_IN_OUT WHERE IN_OUT_ID = EIO.IN_OUT_ID) KIDEM_STARTDATE				
            </cfif>
             ,SOS.ORGANIZATION_STEP_ID
             ,SOS.ORGANIZATION_STEP_NAME
              <cfif (isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1)>
                 ,get_account_no.BANK_BRANCH_CODE
                 ,get_account_no.BANK_ACCOUNT_NO
                 ,get_account_no.BANK_NAME
                 ,get_account_no.BANK_BRANCH_NAME
                 ,get_account_no.IBAN_NO 
             </cfif>
             <cfif isdefined("attributes.is_address")>
             	,SETUP_CITY.CITY_NAME
                ,SETUP_COUNTY.COUNTY_NAME
             </cfif>
			<cfif isdefined("attributes.is_salary") and attributes.is_salary eq 1>
                ,get_employees_salary.MONEY
                ,get_employees_salary.AY_ADI 
            </cfif>
			<cfif isdefined("attributes.is_salary_plan") and attributes.is_salary_plan eq 1>
                ,GET_GR_MAAS.GR_MAAS
                ,GET_GR_MAAS.MONEY AS MONEY1
            </cfif>
            <cfif isdefined("attributes.is_last_school") and attributes.is_last_school eq 1>
             	,SEL2.EDUCATION_NAME LAST_SCHOOL_
             </cfif>
             <cfif isdefined("attributes.is_edu_type") and attributes.is_edu_type eq 1>
             	,SEL.EDUCATION_NAME EDU_NAME_
                ,EAI.EDU_TYPE
             </cfif>
             <cfif isdefined("attributes.is_language") and attributes.is_language eq 1>
                ,SL.LANGUAGE_SET  
			</cfif> 
            <cfif isdefined("attributes.is_document") and attributes.is_document eq 1>
                ,EAL.PAPER_NAME
			</cfif> 
            <cfif isdefined("attributes.is_document_date") and attributes.is_document_date eq 1>
                ,EAL.PAPER_DATE
			</cfif> 
            <cfif isdefined("attributes.is_point") and attributes.is_point eq 1>
                ,EAL.LANG_POINT
			</cfif> 
            <cfif isdefined("attributes.is_lang_where") and attributes.is_lang_where eq 1>
                ,EAL.LANG_WHERE
			</cfif> 
            <cfif isdefined("attributes.is_paper_finish_date") and attributes.is_paper_finish_date eq 1>
                ,EAL.PAPER_FINISH_DATE
			</cfif> 
            <cfif isdefined("attributes.is_edu_lang") and attributes.is_edu_lang eq 1>
                ,EAI.EDUCATION_LANG
			</cfif> 
            <cfif isdefined("attributes.is_edu_name") and attributes.is_edu_name eq 1>
                ,EAI.EDU_NAME
			</cfif>
            <cfif isdefined("attributes.is_part_name") and attributes.is_part_name eq 1>
                ,EAI.EDU_PART_NAME
			</cfif>  
            <cfif isdefined("attributes.is_edu_lang_rate") and attributes.is_edu_lang_rate eq 1>
                ,EAI.EDU_LANG_RATE
			</cfif> 
            <cfif isdefined("attributes.is_edu_startdate") and attributes.is_edu_startdate eq 1>
                ,EAI.EDU_START
            </cfif>
            <cfif isdefined("attributes.is_edu_finishdate") and attributes.is_edu_finishdate eq 1>
                ,EAI.EDU_FINISH
            </cfif>
       <cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1>
       	INTO ####EMP_ANALY_REPORT
	   </cfif>	 
       FROM 
			EMPLOYEES E
                LEFT JOIN 
                
                (
                     SELECT
                        EP.EMPLOYEE_ID,
                        SOS.ORGANIZATION_STEP_ID,
                        SOS.ORGANIZATION_STEP_NAME
                    FROM
                        SETUP_ORGANIZATION_STEPS SOS,
                        EMPLOYEE_POSITIONS EP
                        LEFT JOIN  EMPLOYEE_POSITIONS_HISTORY EPH ON EP.EMPLOYEE_ID = EPH.EMPLOYEE_ID 
                    WHERE
                        SOS.ORGANIZATION_STEP_ID = (CASE WHEN EP.ORGANIZATION_STEP_ID IS NULL THEN EPH.ORGANIZATION_STEP_ID ELSE EP.ORGANIZATION_STEP_ID END)
                       AND (CASE WHEN EP.IS_MASTER IS NULL THEN EPH.IS_MASTER ELSE EP.IS_MASTER END)  = 1 
                )  AS SOS
            ON
 				SOS.EMPLOYEE_ID = E.EMPLOYEE_ID 
            	LEFT JOIN EMPLOYEES_RANK_DETAIL ERANK ON ERANK.EMPLOYEE_ID = E.EMPLOYEE_ID AND ERANK.ID = (SELECT TOP 1 ID FROM EMPLOYEES_RANK_DETAIL WHERE EMPLOYEE_ID = E.EMPLOYEE_ID ORDER BY PROMOTION_START DESC)
                
             <cfif isdefined("attributes.is_pos") and attributes.is_pos eq 1>
                LEFT JOIN EMPLOYEE_POSITIONS EPOS ON EPOS.EMPLOYEE_ID = E.EMPLOYEE_ID
                OUTER APPLY (
                                SELECT TOP 1 
                                    EMPLOYEE_ID, 
                                    IS_MASTER, 
                                    POSITION_CAT_ID, 
                                    POSITION_STATUS, 
                                    POSITION_ID, 
                                    POSITION_NAME, 
                                    TITLE_ID, 
                                    DEPARTMENT_ID, 
                                    ORGANIZATION_STEP_ID, 
                                    FUNC_ID, 
                                    UPPER_POSITION_CODE2, 
                                    UPPER_POSITION_CODE, 
                                    COLLAR_TYPE, 
                                    IS_CRITICAL, 
                                    POWER_USER, 
                                    EHESAP, 
                                    IS_VEKALETEN, 
                                    POSITION_CODE 
                                FROM 
                                    EMPLOYEE_POSITIONS_HISTORY 
                                WHERE 
                                    EMPLOYEE_ID = E.EMPLOYEE_ID 
                                ORDER BY 
                                    HISTORY_ID DESC
                            ) AS ECH
				LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.TITLE_ID ELSE EPOS.TITLE_ID END)     
			 </cfif>   
             LEFT JOIN EMPLOYEES_APP_LANGUAGE EAL ON EAL.EMPLOYEE_ID = E.EMPLOYEE_ID   
             <cfif isdefined('attributes.is_language') or isdefined(attributes.document_name) or len(attributes.document_date)>
                LEFT JOIN SETUP_LANGUAGES  SL ON SL.LANGUAGE_ID = EAL.LANG_ID
                LEFT JOIN SETUP_LANGUAGES_DOCUMENTS STD ON STD.DOCUMENT_ID = EAL.LANG_PAPER_NAME
			 </cfif> 
                LEFT JOIN EMPLOYEES_APP_EDU_INFO EAI ON EAI.EMPLOYEE_ID = E.EMPLOYEE_ID
            <cfif (isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1)>
            	LEFT JOIN
                	(
                    	SELECT 
                        	EMPLOYEE_ID,
                            BANK_BRANCH_CODE,
                            BANK_ACCOUNT_NO,
                            BANK_NAME,
                            BANK_BRANCH_NAME,
                            IBAN_NO 
                        FROM 
                        	EMPLOYEES_BANK_ACCOUNTS 
                        WHERE
                           DEFAULT_ACCOUNT = 1
                    ) as get_account_no
             ON
             	get_account_no.EMPLOYEE_ID = E.EMPLOYEE_ID       
            </cfif>
            <cfif isdefined("attributes.is_edu_type") and attributes.is_edu_type eq 1>
            	LEFT JOIN 
                	SETUP_EDUCATION_LEVEL SEL
                ON
                	EAI.EDU_TYPE =SEL.EDU_LEVEL_ID
            </cfif>
            ,
			EMPLOYEES_DETAIL ED
             <cfif isdefined("attributes.is_address")>
                LEFT JOIN 
                	SETUP_CITY	
                ON
                	SETUP_CITY.CITY_ID = ED.HOMECITY
                LEFT JOIN
                	SETUP_COUNTY
                ON
                	SETUP_COUNTY.COUNTY_ID = ED.HOMECOUNTY
            </cfif>
            <cfif isdefined("attributes.is_last_school") and attributes.is_last_school eq 1>
            	LEFT JOIN 
                	SETUP_EDUCATION_LEVEL SEL2
                ON
                	ED.LAST_SCHOOL =SEL2.EDU_LEVEL_ID
            </cfif>
            ,
			EMPLOYEES_IDENTY EI
            <cfif isdefined('attributes.is_country_id') and Len(attributes.is_country_id)>
                LEFT JOIN SETUP_COUNTRY ON SETUP_COUNTRY.COUNTRY_ID = EI.NATIONALITY
            </cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
				,DEPARTMENT D
				,BRANCH B
				,OUR_COMPANY OC
                ,ZONE Z
			</cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1)>
				,EMPLOYEES_IN_OUT EIO
                LEFT JOIN SETUP_EMPLOYEE_FIRE_REASONS FR ON FR.REASON_ID = EIO.IN_COMPANY_REASON_ID <!---20131108--->
             	<cfif isdefined("attributes.is_salary") and attributes.is_salary eq 1>
                     LEFT JOIN 
                         (
                            SELECT
                                IN_OUT_ID,
                                MONEY, 
                                M#attributes.salary_month# AY_ADI 
                            FROM 
                                EMPLOYEES_SALARY 
                            WHERE 
                                PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> 
                          ) AS get_employees_salary
                      ON   
                      EIO.IN_OUT_ID = get_employees_salary.IN_OUT_ID
        		</cfif>
				<cfif isdefined("attributes.is_salary_plan") and attributes.is_salary_plan eq 1>
                      LEFT JOIN 
                        (                           
                           SELECT
                                MIN(M#attributes.salary_month#) AS GR_MAAS,
                                IN_OUT_ID,
                                MIN(MONEY) AS MONEY
                            FROM
                                EMPLOYEES_SALARY_PLAN
                            WHERE
                                PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#">
                            GROUP BY 
                            	  IN_OUT_ID   
                        )  AS GET_GR_MAAS
                        ON   EIO.IN_OUT_ID = GET_GR_MAAS.IN_OUT_ID
                </cfif>
			</cfif>
		WHERE
			E.EMPLOYEE_ID = ED.EMPLOYEE_ID
			AND E.EMPLOYEE_ID = EI.EMPLOYEE_ID 
			<cfif isdefined("attributes.is_pos") and attributes.is_pos eq 1>
				<cfif attributes.branch_type eq 2>
					AND EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
				<cfelseif not (isdefined("attributes.in_out") and attributes.in_out eq 1)>
					AND D.DEPARTMENT_ID = (CASE WHEN EPOS.DEPARTMENT_ID IS NULL THEN ECH.DEPARTMENT_ID ELSE EPOS.DEPARTMENT_ID END)
				<cfelseif attributes.branch_type neq 2>
					AND D.DEPARTMENT_ID = (CASE WHEN EPOS.DEPARTMENT_ID IS NULL THEN ECH.DEPARTMENT_ID ELSE EPOS.DEPARTMENT_ID END)
				</cfif>
			</cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1)>
				AND E.EMPLOYEE_ID = EIO.EMPLOYEE_ID 
				<cfif attributes.branch_type eq 2>
					AND EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
				<cfelseif not (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
					AND EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
				</cfif>
			</cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
				AND D.BRANCH_ID = B.BRANCH_ID
				AND B.COMPANY_ID = OC.COMP_ID
                AND Z.ZONE_ID = B.ZONE_ID
			</cfif>
			<cfif attributes.branch_type eq 1>
				AND D.DEPARTMENT_ID = (CASE WHEN EPOS.DEPARTMENT_ID IS NULL THEN ECH.DEPARTMENT_ID ELSE EPOS.DEPARTMENT_ID END)
			<cfelseif attributes.branch_type eq 2>
				AND EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
			</cfif>
			<cfif attributes.branch_type eq 1 or attributes.branch_type eq 2>
				<cfif not session.ep.ehesap>
					AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
			<cfelse>
				<cfif not session.ep.ehesap>
					AND 
					(E.EMPLOYEE_ID IN
					(
						SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP LEFT JOIN EMPLOYEE_POSITIONS_HISTORY ECH ON EP.EMPLOYEE_ID = ECH.EMPLOYEE_ID WHERE (CASE WHEN EP.DEPARTMENT_ID IS NULL THEN ECH.DEPARTMENT_ID ELSE EP.DEPARTMENT_ID END) IN (SELECT DD.DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES EPB,DEPARTMENT DD WHERE DD.BRANCH_ID = EPB.BRANCH_ID AND EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					)
					OR 
					E.EMPLOYEE_ID NOT IN
					(
						SELECT (CASE WHEN EP.EMPLOYEE_ID IS NULL THEN ECH.EMPLOYEE_ID ELSE EP.EMPLOYEE_ID END)
			            FROM EMPLOYEE_POSITIONS EP LEFT JOIN  EMPLOYEE_POSITIONS_HISTORY ECH ON EP.EMPLOYEE_ID = ECH.EMPLOYEE_ID
					)
					)
				</cfif>
			</cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
				<cfif len(trim(attributes.comp_id))>
					AND OC.COMP_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.comp_id#">)
				</cfif>
			</cfif>
            <cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
                <cfif len(trim(attributes.zone_id))>
					AND Z.ZONE_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.zone_id#">)
				</cfif>
          	</cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
				<cfif len(trim(attributes.branch_id))>
					AND B.BRANCH_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
				</cfif>
			</cfif>
			<cfif (isdefined('attributes.in_out') and attributes.in_out eq 1) or (isdefined("attributes.is_pos") and attributes.is_pos eq 1)>
				<cfif len(trim(attributes.department_id))>
                	AND
                    <cfif isdefined('attributes.is_all_dep')>
                        D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE <cfif isdefined('attributes.is_dep_level')> LEVEL_NO IS NOT NULL AND </cfif> 
                            (<cfloop list="#attributes.department_id#" delimiters="," index="i">
                                '.' + HIERARCHY_DEP_ID +'.' LIKE '%.#i#.%' <cfif i neq listlast(attributes.department_id,',')>OR</cfif> 
                            </cfloop>))
                   	<cfelse>
                    	D.DEPARTMENT_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.department_id#">)
					</cfif>
				</cfif>
			</cfif>
			<cfif len(attributes.position_cats)> AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POSITION_CAT_ID ELSE EPOS.POSITION_CAT_ID END) IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.position_cats#">)</cfif>
			<cfif len(attributes.titles)>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.TITLE_ID ELSE EPOS.TITLE_ID END) IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.titles#">)</cfif>			
			<cfif len(attributes.organization_steps)>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.ORGANIZATION_STEP_ID ELSE EPOS.ORGANIZATION_STEP_ID END) IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.organization_steps#">)</cfif>
			<cfif len(attributes.func_id)>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.FUNC_ID ELSE EPOS.FUNC_ID END) IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.func_id#">)</cfif>
			<cfif len(attributes.upper_position_code2) and len(attributes.upper_position2)>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.UPPER_POSITION_CODE2 ELSE EPOS.UPPER_POSITION_CODE2 END) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code2#"></cfif>
			<cfif len(attributes.upper_position_code) and len(attributes.upper_position)>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.UPPER_POSITION_CODE ELSE EPOS.UPPER_POSITION_CODE END) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"></cfif>
			<cfif len(attributes.collar_type)>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.COLLAR_TYPE ELSE EPOS.COLLAR_TYPE END) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#"></cfif>
			<cfif listfind(attributes.user_type,1,',')>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.IS_MASTER ELSE EPOS.IS_MASTER END) = 1</cfif>
			<cfif listfind(attributes.user_type,5,',')>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.IS_MASTER ELSE EPOS.IS_MASTER END) = 0</cfif>
			<cfif listfind(attributes.user_type,2,',')>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.IS_CRITICAL ELSE EPOS.IS_CRITICAL END) = 1</cfif>
			<cfif listfind(attributes.user_type,3,',')>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POWER_USER ELSE EPOS.POWER_USER END) = 1</cfif>
            <cfif listfind(attributes.user_type,4,',')>AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.EHESAP ELSE EPOS.EHESAP END) = 1</cfif>
            <cfif listfind(attributes.proxy_user_type,1,',')> AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.IS_VEKALETEN ELSE EPOS.IS_VEKALETEN END) = 1 </cfif>
			<cfif listfind(attributes.proxy_user_type,2,',')> AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.IS_VEKALETEN ELSE EPOS.IS_VEKALETEN END) = 0 </cfif>
            <cfif isdefined("attributes.position_status") and (attributes.position_status eq 0)>
				AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POSITION_STATUS ELSE EPOS.POSITION_STATUS END) = 0		  
			<cfelseif isdefined("attributes.position_status") and (attributes.position_status eq 1)>
				AND (CASE WHEN EPOS.EMPLOYEE_ID IS NULL THEN ECH.POSITION_STATUS ELSE EPOS.POSITION_STATUS END) = 1
			</cfif>
			<cfif isdefined("attributes.pos_status") and (attributes.pos_status eq 0)>
				AND E.EMPLOYEE_STATUS = 0		  
			<cfelseif isdefined("attributes.pos_status") and (attributes.pos_status eq 1)>
				AND E.EMPLOYEE_STATUS = 1
			</cfif>
			<cfif len(attributes.sex)> AND ED.SEX = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.sex#"></cfif>
			<cfif len(attributes.group_start_date1)> AND E.GROUP_STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.group_start_date1#"></cfif>
			<cfif len(attributes.group_start_date2)> AND E.GROUP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.group_start_date2#"></cfif>
			<cfif len(attributes.education_name)>AND EAI.EDU_TYPE IN (<cfqueryparam list="true"  cfsqltype="cf_sql_integer" value="#attributes.education_name#">)</cfif>
            <cfif len(attributes.last_school)>AND ED.LAST_SCHOOL IN (<cfqueryparam list="true"  cfsqltype="cf_sql_integer" value="#attributes.last_school#">)</cfif>
            <cfif len(attributes.edu_lang)>AND EAI.EDUCATION_LANG = <cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#attributes.edu_lang#"></cfif>
            <cfif len(attributes.edu_part_id)>AND EAI.EDU_PART_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.edu_part_id#">)</cfif>
            <cfif len(attributes.edu_high_part_id)>AND EAI.EDU_PART_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.edu_high_part_id#">)</cfif>
			<cfif len(attributes.blood_type)>AND EI.BLOOD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.blood_type#"></cfif>
			<cfif len(attributes.kidem_date1)> AND E.KIDEM_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.kidem_date1#"></cfif>
			<cfif len(attributes.kidem_date2)> AND E.KIDEM_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.kidem_date2#"></cfif>
			<cfif len(attributes.married)>AND EI.MARRIED = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.married#"></cfif>
			<!--- <cfif len(attributes.languages)>AND (ED.LANG1 IN (#attributes.languages#)OR ED.LANG2 IN (#attributes.languages#)OR ED.LANG3 IN (#attributes.languages#)OR ED.LANG4 IN (#attributes.languages#)OR ED.LANG5 IN (#attributes.languages#))</cfif> --->
			<cfif len(attributes.languages)> AND EAL.LANG_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.languages#"></cfif>
            <cfif len(attributes.document_name)> AND EAL.LANG_PAPER_NAME  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.document_name#"></cfif>
            <cfif len(attributes.paper_name)> AND EAL.PAPER_NAME  LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_name#%"></cfif>
            <cfif len(attributes.document_date)> AND EAL.PAPER_DATE  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.document_date#"></cfif>
			<cfif len(attributes.lang_status)> AND STD.IS_ACTIVE  = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.lang_status#"></cfif>
			<cfif len(attributes.izin_date1)> AND E.IZIN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.izin_date1#"></cfif>
			<cfif len(attributes.izin_date2)> AND E.IZIN_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.izin_date2#"></cfif>
			<cfif len(attributes.birth_place)> AND EI.BIRTH_PLACE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.birth_place#%"></cfif>
			<cfif len(attributes.birth_mon)> AND DATEPART(MONTH,EI.BIRTH_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.birth_mon#"></cfif>
			<cfif len(attributes.birth_date1)> AND EI.BIRTH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.birth_date1#"></cfif>
            <cfif len(attributes.birth_date2)> AND EI.BIRTH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.birth_date2#"></cfif>
            <cfif len(attributes.country_id)> AND EI.NATIONALITY IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.country_id#">)</cfif>
			<cfif isdefined("attributes.special_position") and attributes.special_position eq 1>
				AND ED.DEFECTED = 1 
			<cfelseif isdefined("attributes.special_position") and attributes.special_position eq 2>
				AND ED.SENTENCED = 1
			<cfelseif isdefined("attributes.special_position") and attributes.special_position eq 3>
				AND ED.TERROR_WRONGED = 1 
			</cfif>
			<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)>AND E.EMPLOYEE_ID = #attributes.employee_id#</cfif>
			<cfif isdefined('attributes.in_out') and attributes.in_out>
				<cfif len(attributes.explanation_id)>
					<cfif listfind(attributes.explanation_id,0)>
						AND EIO.FINISH_DATE IS NULL AND EIO.EX_IN_OUT_ID IS NULL
					<cfelseif listfind(attributes.explanation_id,-1)>
						AND EIO.EX_IN_OUT_ID IS NOT NULL
					<cfelse>
						AND EIO.EXPLANATION_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.explanation_id#">) 
					</cfif>
				</cfif>
            </cfif>
            <cfif len(attributes.group_id)>
                    AND EIO.PUANTAJ_GROUP_IDS IN ('#attributes.group_id#') AND EIO.PUANTAJ_GROUP_IDS IS NOT NULL
            </cfif>
           
			<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
				AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE IS NULL
							)
							OR
							(
							EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
							EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EIO.FINISH_DATE IS NULL
					</cfif>
				)
			<cfelseif isdefined("attributes.inout_statue") and  attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
				)
			</cfif>
			<cfif len(attributes.salary_type)>
				AND EIO.SALARY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_type#">
			</cfif>
			<cfif len(attributes.gross_net)>
				AND EIO.GROSS_NET = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.gross_net#">
			</cfif>
			<cfif len(attributes.expense_center_id)>
				<!--- AND (SELECT EIOP.EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = #session.ep.period_year# AND EIOP.PERIOD_ID = #session.ep.period_id#) IN(SELECT EXPENSE_CODE FROM #center_dsn#.EXPENSE_CENTER WHERE EXPENSE_ID = #attributes.expense_center_id#) --->
				AND (SELECT TOP 1 EIOP.EXPENSE_CENTER_ID FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">) IN (#attributes.expense_center_id#)
			</cfif>
			<cfif len(attributes.ssk_statute)>
				AND EIO.SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statute#">
			</cfif>
			<cfif len(attributes.defection_level)>
				AND EIO.DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defection_level#">
			</cfif>
			<cfif len(attributes.law_numbers)>
				<cfif attributes.law_numbers eq '5763'>
					AND EIO.IS_5510 = 1
				<cfelseif attributes.law_numbers eq '5084'>
					AND EIO.IS_5084 = 1
				<cfelseif attributes.law_numbers eq '6486'>
					AND EIO.IS_6486 = 1
				<cfelseif attributes.law_numbers eq '6322'>
					AND EIO.IS_6322 = 1
				<cfelseif attributes.law_numbers eq '25510'>
					AND EIO.IS_25510 = 1
				<cfelse>
					AND EIO.LAW_NUMBERS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.law_numbers#">
				</cfif>
			</cfif>
			<cfif len(attributes.transport_type_id)>
				AND EIO.TRANSPORT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.transport_type_id#">
			</cfif>
			<cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
				AND EIO.DUTY_TYPE IN (#attributes.duty_type#)
			</cfif>
			<cfif len(attributes.use_pdks)>
				AND EIO.USE_PDKS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.use_pdks#">
			</cfif>
			<cfif len(attributes.shift_id)>
				AND EIO.SHIFT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.shift_id#">
			</cfif>
			<cfif len(attributes.lower_salary_range)>
				AND EIO.IN_OUT_ID IN (SELECT TOP 1 IN_OUT_ID FROM EMPLOYEES_SALARY WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> AND M#attributes.salary_month# >= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.lower_salary_range,'.','')#">)
			</cfif>
			<cfif len(attributes.upper_salary_range)>
            	AND EIO.IN_OUT_ID IN (SELECT TOP 1 IN_OUT_ID FROM EMPLOYEES_SALARY WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> AND M#attributes.salary_month# <= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(attributes.upper_salary_range,'.','')#">)
            </cfif>
			<cfif isdefined('attributes.hierarchy') and len(attributes.hierarchy)>
				AND 
					(
						<cfloop list="#attributes.hierarchy#" delimiters="+" index="code_i">
							E.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
							E.OZEL_KOD2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
							E.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
							E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">)
							<cfif listlen(attributes.hierarchy,'+') gt 1 and listlast(attributes.hierarchy,'+') neq code_i>OR</cfif>	 
						</cfloop>
						<cfif fusebox.dynamic_hierarchy>
						OR(
							<cfloop list="#attributes.hierarchy#" delimiters="+" index="code_i">
								<cfif database_type is "MSSQL">
									('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
									<cfif listlen(attributes.hierarchy,'+') gt 1 and listlast(attributes.hierarchy,'+') neq code_i>AND</cfif>
								<cfelseif database_type is "DB2">
									('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
									<cfif listlen(attributes.hierarchy,'+') gt 1 and listlast(attributes.hierarchy,'+') neq code_i>AND</cfif>
								</cfif>
							</cfloop>
						)
						</cfif>
					)
			</cfif>
            <cfif len(attributes.sureli_is_akdi)>
                AND EIO.SURELI_IS_AKDI =1
                <cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>
                    AND  EIO.SURELI_IS_FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                <cfelseif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
                    AND EIO.SURELI_IS_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                <cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
                    AND EIO.SURELI_IS_FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                </cfif>
            </cfif>
		ORDER BY 
			E.EMPLOYEE_NAME
            <cfif isdefined("attributes.is_edu_type")>,EAI.EDU_TYPE DESC</cfif>
	</cfquery>
	<cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1>
         <cfquery name="GET_EMPLOYEE" datasource="#center_dsn#">   
            SELECT EAP.*,EXPENSE_CENTER.EXPENSE_CODE,EXPENSE_CENTER.EXPENSE
            FROM
                ####EMP_ANALY_REPORT EAP
            LEFT JOIN
                EXPENSE_CENTER
            ON
                EAP.EXPENSE_CENTER_ID = EXPENSE_CENTER.EXPENSE_ID
            ORDER BY 
                EMPLOYEE_NAME    
          </cfquery>      
    </cfif>
<cfelse>
	<cfset get_employee.recordcount = 0>
</cfif>
<cfif isdefined('attributes.is_hierarchy_dep') and len(attributes.is_hierarchy_dep) and get_employee.recordcount and not isdefined('is_dep_level')>
	<cfset up_dep_len = 1>
    <cfoutput query="get_employee">
    	<cfif listlen(get_employee.HIERARCHY_DEP_ID,'.') gt up_dep_len>
        	<cfset up_dep_len = listlen(get_employee.HIERARCHY_DEP_ID,'.')>
		</cfif>
	</cfoutput>
    <cfset up_dep_len = up_dep_len - 1>
<cfelseif isdefined('attributes.is_hierarchy_dep') and len(attributes.is_hierarchy_dep) and isdefined('is_dep_level') and get_employee.recordcount>
	<cfquery name="get_dep_lvl" datasource="#dsn#">
        SELECT DISTINCT LEVEL_NO FROM DEPARTMENT WHERE LEVEL_NO IS NOT NULL ORDER BY LEVEL_NO
    </cfquery>
    <cfset up_dep_len = get_dep_lvl.recordcount>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_employee.recordcount#'>
<cfscript>
	if (isdate(attributes.kidem_date1))
		attributes.kidem_date1 = dateformat(attributes.kidem_date1, dateformat_style);
	if (isdate(attributes.kidem_date2))
		attributes.kidem_date2 = dateformat(attributes.kidem_date2, dateformat_style);
	if (isdate(attributes.group_start_date1))
		attributes.group_start_date1 = dateformat(attributes.group_start_date1, dateformat_style);
	if (isdate(attributes.group_start_date2))
		attributes.group_start_date2 = dateformat(attributes.group_start_date2, dateformat_style);
	if (isdate(attributes.birth_date1))
		attributes.birth_date1 = dateformat(attributes.birth_date1, dateformat_style);
	if (isdate(attributes.birth_date2))
		attributes.birth_date2 = dateformat(attributes.birth_date2, dateformat_style);
	if (isdate(attributes.izin_date1))
		attributes.izin_date1 = dateformat(attributes.izin_date1, dateformat_style);
	if (isdate(attributes.izin_date2))
		attributes.izin_date2 = dateformat(attributes.izin_date2, dateformat_style);
	attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	titles = cmp_title.get_title();
</cfscript>
<cfquery name="get_active_shifts" datasource="#dsn#">
	SELECT * FROM SETUP_SHIFTS
</cfquery>
<cfquery name="get_education_level" datasource="#dsn#">
	SELECT * FROM SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="get_languages" datasource="#dsn#">
	SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES
</cfquery>
<cfquery name="get_high_school_part" datasource="#dsn#">
	SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
	SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="get_unv" datasource="#dsn#">
	SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_lang_document" datasource="#dsn#">
	SELECT DOCUMENT_ID,DOCUMENT_NAME FROM SETUP_LANGUAGES_DOCUMENTS
</cfquery>
<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_organization_steps" datasource="#dsn#">
	SELECT ORGANIZATION_STEP_ID,ORGANIZATION_STEP_NAME FROM SETUP_ORGANIZATION_STEPS ORDER BY ORGANIZATION_STEP_NO
</cfquery>
<cfquery name="get_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT 
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME,NICK_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="get_acc_types" datasource="#dsn#">
	SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_ID DESC
</cfquery>
<cfquery name="get_expense_center_list" datasource="#center_dsn#">
	SELECT EXPENSE_ID, EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE_CODE
</cfquery>
<cfquery name="get_emp_accounts" datasource="#dsn#">
	SELECT 
    	ACCOUNT_CODE,
        ACC_TYPE_ID,
        EMPLOYEE_ID 
    FROM 
    	EMPLOYEES_ACCOUNTS
    WHERE
    	PERIOD_ID IN(SELECT PERIOD_ID FROM SETUP_PERIOD WHERE 
        				(PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> OR YEAR(FINISH_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#">)
						AND (FINISH_DATE IS NULL OR (FINISH_DATE IS NOT NULL AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#">))
                     ) 
    ORDER BY 
    	ACC_TYPE_ID
</cfquery>
<cfquery name="get_transport_types" datasource="#dsn#">
	SELECT * FROM SETUP_TRANSPORT_TYPES ORDER BY TRANSPORT_TYPE
</cfquery>
<cfform name="rapor" action="#request.self#?fuseaction=report.employee_analyse_report" method="post">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='39930.Çalışan Detaylı Analiz Raporu'></cfsavecontent>
    <cf_report_list_search id="analyse_report" title="#title#">	
        <cf_report_list_search_area> 
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">	
                    <div class="row formContent">
                        <cfsavecontent variable='header'><cf_get_lang dictionary_id='57972.Organizasyon'></cfsavecontent>
                        <cf_seperator id="organizasyon_" header="#header#" is_closed="0">
                        <div class="row" type="row" id="organizasyon_">
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12 ">
                                <div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z5">
											<cf_multiselect_check
												query_name="get_company"
												name="comp_id"
												width="140"
												option_value="COMP_ID"
												option_name="COMPANY_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.comp_id#"
												onchange="get_branch_list(this.value)">
										</div>
									</div>
								</div>		
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >								
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57992.Bölge'></label>
									<div class="col col-12 col-xs-12">
										<div class="multiselect-z4">
											<cf_multiselect_check
												query_name="get_zone"
												name="zone_id"
												width="140"
												option_value="ZONE_ID"
												option_name="ZONE_NAME"
												option_text="#getLang('main',322)#"
												value="#attributes.zone_id#">
										</div>
									</div>
								</div>					
							</div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
									<div class="col col-12 col-xs-12">
                                        <div id="BRANCH_PLACE" class="multiselect-z5">                                           
                                            <cf_multiselect_check 
                                                query_name="get_branches"  
                                                name="branch_id"
                                                width="140" 
                                                option_value="BRANCH_ID"
                                                option_name="branch_name"
                                                option_text="#getLang('main',322)#"
                                                value="#attributes.branch_id#"
                                                onchange="get_department_list(this.value)">
										</div>
									</div>
								</div>									
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12">														
								<div class="form-group">										  
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
									<div class="col col-12 col-xs-12">
										<div id="DEPARTMENT_PLACE" class="multiselect-z4">
											<cf_multiselect_check 
												query_name="get_department"  
												name="department_id"
												width="140" 
												option_value="DEPARTMENT_ID"
												option_name="DEPARTMENT_HEAD"
												option_text="#getLang('main',322)#"
												value="#attributes.department_id#"
												onchange="alt_departman_chckbx(this.value);">
										</div>
									</div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">																					
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="check_all_box1" id="check_all_box1" onclick="hepsini_sec(1);" value="1" <cfif isdefined("attributes.check_all_box1")>checked</cfif>><cf_get_lang dictionary_id='51050.Hepsini Seç'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_company" id="is_company" value="1" <cfif isdefined('attributes.is_company')>checked</cfif>><cf_get_lang dictionary_id='57574.Şirket'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_comp_branch" id="is_comp_branch" value="1" <cfif isdefined('attributes.is_comp_branch')>checked</cfif>><cf_get_lang dictionary_id='57992.Bölge'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input name="branch_type" id="branch_type" type="radio" value="1" <cfif attributes.branch_type eq 1>checked</cfif>><cf_get_lang dictionary_id='58497.Pozisyon'>
										</div>                                      
                                    </div> 
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_branch" id="is_branch" value="1" <cfif isdefined('attributes.is_branch')>checked</cfif>><cf_get_lang dictionary_id='57453.Şube'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_department" id="is_department" value="1" <cfif isdefined('attributes.is_department')>checked</cfif> onChange="specialcode_check();"><cf_get_lang dictionary_id='57572.Departman'>
                                        </div>
                                       <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_hierarchy_dep" id="is_hierarchy_dep" value="1" <cfif isdefined('attributes.is_hierarchy_dep')>checked</cfif> onChange="department_level_chckbx();"><cf_get_lang dictionary_id='39710.Üst Departman'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input name="branch_type" id="branch_type" type="radio" value="2" <cfif attributes.branch_type eq 2>checked</cfif>><cf_get_lang dictionary_id='39066.Ücret Kartı'>
										</div>                                      
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                       
                                        <div class="col col-4 col-xs-12" id="department_level_td" style="<cfif not(isdefined('attributes.is_hierarchy_dep') and len(attributes.is_hierarchy_dep))>display:none;</cfif>">
                                            <input type="checkbox" name="is_dep_level" id="is_dep_level" value="1" <cfif isdefined('attributes.is_dep_level')>checked</cfif>><cf_get_lang dictionary_id="58432.Kademeli"><cf_get_lang dictionary_id="52302.Getir">
                                        </div>                                      
                                        <div class="col col-4 col-xs-12" id="alt_departman_td" style="<cfif not(isdefined('attributes.department_id') and len(attributes.department_id))>display:none;</cfif>">
                                            <input type="checkbox" name="is_all_dep" id="is_all_dep" value="1" <cfif isdefined('attributes.is_all_dep')>checked</cfif>><cf_get_lang dictionary_id='45397.Alt Departmanları Getir'>
                                        </div>                              
                                    </div>                               
								</div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-4 col-xs-12" id="special_code_td" style="<cfif not(isdefined('attributes.is_special_code') and len(attributes.is_special_code))>display:none;</cfif>">
                                            <input type="checkbox" name="is_special_code" id="is_special_code" value="1" <cfif isdefined('attributes.is_special_code') and len(attributes.is_special_code)>checked</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'>
                                        </div>                             
                                    </div>                               
								</div>
                            </div>                        
                        </div>
                        <cfsavecontent variable='header'><cf_get_lang dictionary_id='58123.Planlama'></cfsavecontent>
                        <cf_seperator id="planning_" header="#header#" is_closed="0">
                        <div class="row" type="row" id="planning_">
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12 ">
                                <div class="form-group">										  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                            query_name="get_position_cats"
                                            value="#attributes.position_cats#"  
                                            name="position_cats"
                                            width="150" 
                                            height="100"
                                            option_value="position_cat_id"
                                            option_name="position_cat">
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                            query_name="titles"  
                                            name="titles"
                                            value="#attributes.titles#"  
                                            width="150" 
                                            height="100"
                                            option_value="title_id"
                                            option_name="title">
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                                        <div class="col col-12 col-xs-12">
                                            <input type="text" name="hierarchy" id="hierarchy" value="<cfif isdefined('attributes.hierarchy') and len(attributes.hierarchy)><cfoutput>#attributes.hierarchy#</cfoutput></cfif>">
                                        </div>
                                </div>		
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >								
                                <div class="form-group">										  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58710.Kademe'></label>    
                                    <div class="col col-12 col-xs-12">
                                        <div class="multiselect-z4">
                                            <cf_multiselect_check 
                                                query_name="get_organization_steps"  
                                                name="organization_steps"
                                                value="#attributes.organization_steps#"  
                                                width="150" 
                                                height="100"
                                                option_value="organization_step_id"
                                                option_name="organization_step_name">
                                        </div>
                                    </div>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57734.Seçiniz"></cfsavecontent>
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="56857.Çalışan Grubu"></label>
                                        <div class="col col-12 col-xs-12">
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
                                                value="#attributes.group_id#">
                                        </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38925.Kullanıcı Tipi'></label>    
                                        <div class="col col-12 col-xs-12">
                                            <select name="user_type" id="user_type" style="width:150px;">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="1" <cfif listfind(attributes.user_type,1,',')>selected</cfif>><cf_get_lang dictionary_id='38926.Master'></option>
                                                <option value="5" <cfif listfind(attributes.user_type,5,',')>selected</cfif>><cf_get_lang dictionary_id='39177.Master Olmayan'></option>
                                                <option value="2" <cfif listfind(attributes.user_type,2,',')>selected</cfif>><cf_get_lang dictionary_id='38927.Kritik Pozisyon'></option>
                                                <option value="3" <cfif listfind(attributes.user_type,3,',')>selected</cfif>><cf_get_lang dictionary_id='29884.Süper Kullanıcı'></option>
                                                <option value="4" <cfif listfind(attributes.user_type,4,',')>selected</cfif>><cf_get_lang dictionary_id='39178.Üst Düzey İK da Yetkili'></option>
                                            </select>
                                        </div>
                                </div>					
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >
                                <div class="form-group">										  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="multiselect-z4">
                                            <cf_multiselect_check 
                                            query_name="get_units"  
                                            name="func_id"
                                            value="#attributes.func_id#"
                                            width="150" 
                                            height="100"
                                            option_value="unit_id"
                                            option_name="unit_name">
                                        </div>
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38908.Yaka Tipi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="collar_type" id="collar_type" style="width:150px;">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="1" <cfif attributes.collar_type eq 1>selected</cfif>><cf_get_lang dictionary_id='38910.Mavi Yaka'>
                                                <option value="2" <cfif attributes.collar_type eq 2>selected</cfif>><cf_get_lang dictionary_id='38911.Beyaz Yaka'>
                                            </select>
                                        </div> 
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38935.Pozisyon Durumu'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="position_status" id="position_status">
                                            <option value="-1"<cfif isdefined("attributes.position_status") and (attributes.position_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <option value="1"<cfif isdefined("attributes.position_status") and (attributes.position_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                            <option value="0"<cfif isdefined("attributes.position_status") and (attributes.position_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                        </select>
                                    </div>                                     
                                </div>									
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12">														
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38934.İdari Amir'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">                                           
                                            <input type="hidden" name="upper_position_code" id="upper_position_code" value="<cfoutput>#attributes.upper_position_code#</cfoutput>">
                                            <input type="text" name="upper_position" id="upper_position" value="<cfif len(attributes.upper_position_code)><cfoutput>#attributes.upper_position#</cfoutput></cfif>">
                                            <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=rapor.upper_position_code&position_employee=rapor.upper_position&show_empty_pos=1','list');return false"></a>
                                        </div>
                                    </div>	
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38936.Fonksiyonel Amir'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">                                           
                                            <input type="hidden" name="upper_position_code2" id="upper_position_code2" value="<cfoutput>#attributes.upper_position_code2#</cfoutput>">
                                            <input type="text" name="upper_position2" id="upper_position2" value="<cfif len(attributes.upper_position_code2)><cfoutput>#attributes.upper_position2#</cfoutput></cfif>" style="width:145px;">
                                            <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=rapor.upper_position_code2&position_employee=rapor.upper_position2&show_empty_pos=1','list');return false"></a>
                                        </div>
                                    </div>	
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61469.Vekalet Durumu'></label>    
                                    <div class="col col-12 col-xs-12">
                                        <select name="proxy_user_type" id="proxy_user_type">
                                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <option value="1" <cfif listfind(attributes.proxy_user_type,1,',')>selected</cfif>><cf_get_lang dictionary_id='55573.Vekaleten'></option>
                                            <option value="2" <cfif listfind(attributes.proxy_user_type,2,',')>selected</cfif>><cf_get_lang dictionary_id='55573.Vekaleten'><cf_get_lang dictionary_id='30056.Olmayanlar'></option>
                                        </select>
                                    </div>								                                         
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">																					
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="check_all_box2" id="check_all_box2" onclick="hepsini_sec(2);" value="1" <cfif isdefined("attributes.check_all_box2")>checked</cfif>><cf_get_lang dictionary_id='51050.Hepsini Seç'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_function" id="is_function" value="1" <cfif isdefined('attributes.is_function')>checked</cfif>><cf_get_lang dictionary_id='58701.Fonksiyon'>

                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_idariamir" id="is_idariamir" value="1" <cfif isdefined('attributes.is_idariamir')>checked</cfif>><cf_get_lang dictionary_id='38934.Birinci Amir'>

                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_title" id="is_title" value="1" <cfif isdefined('attributes.is_title')>checked</cfif>><cf_get_lang dictionary_id='57571.Ünvan'>
                                        </div>                                      
                                    </div> 
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_position_name" id="is_position_name" value="1" <cfif isdefined('attributes.is_position_name')>checked</cfif>><cf_get_lang dictionary_id='58497.Pozisyon'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_organization_step" id="is_organization_step" value="1" <cfif isdefined('attributes.is_organization_step')>checked</cfif>><cf_get_lang dictionary_id='58710.Kademe'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_fonkamir" id="is_fonkamir" value="1" <cfif isdefined('attributes.is_fonkamir') >checked</cfif>><cf_get_lang dictionary_id='38936.İkinci Amir'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_collar_type" id="is_collar_type" value="1" <cfif isdefined('attributes.is_collar_type')>checked</cfif>><cf_get_lang dictionary_id='38908.Yaka Tipi'>
                                        </div>                                      
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_poscat" id="is_poscat" value="1" <cfif isdefined('attributes.is_poscat')>checked</cfif>><cf_get_lang dictionary_id='59004.Pozisyon Tipi'>
                                        </div>   
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_group" id="is_group" value="1" <cfif isdefined('attributes.is_group')>checked</cfif>><cf_get_lang dictionary_id='56857.Çalışan Grubu'>
                                        </div>                                                                      
                                    </div>                               
                                </div>
                            </div>                        
                        </div>
                        <cfsavecontent variable='header'><cf_get_lang dictionary_id='39097.Profil'></cfsavecontent>
                        <cf_seperator id="profile_" header="#header#" is_closed="0">
                        <div class="row" type="row" id="profile_">
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12 ">
                                <div class="form-group">										  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="pos_status" id="pos_status">
                                            <option value="-1"<cfif isdefined("attributes.pos_status") and (attributes.pos_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                            <option value="1"<cfif isdefined("attributes.pos_status") and (attributes.pos_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                            <option value="0"<cfif isdefined("attributes.pos_status") and (attributes.pos_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                        </select>
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38914.Medeni Durum'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="married" id="married">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="0" <cfif (attributes.married eq 0)>selected</cfif>><cf_get_lang dictionary_id='38915.Bekar'></option>
                                            <option value="1" <cfif (attributes.married eq 1)>selected</cfif>><cf_get_lang dictionary_id='38916.Evli'></option>
                                        </select>
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39778.Özel Durum'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="special_position" id="special_position">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="1"<cfif isdefined("attributes.special_position") and listfindnocase(attributes.special_position,1)>selected</cfif>><cf_get_lang dictionary_id='40526.Engelli Çalışan'></option>
                                            <option value="2"<cfif isdefined("attributes.special_position") and listfindnocase(attributes.special_position,2)>selected</cfif>><cf_get_lang dictionary_id='40525.Eski Hükümlü'></option>
                                            <option value="3"<cfif isdefined("attributes.special_position") and listfindnocase(attributes.special_position,3)>selected</cfif>><cf_get_lang dictionary_id='40524.Terör Mağduru'></option>
                                        </select>
                                    </div>  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>    
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                                <input name="employee_name" type="text" id="employee_name" style="width:145px;" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','rapor','3','300');" value="<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and isdefined('attributes.employee_id') and len(attributes.employee_id)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" autocomplete="off">
                                                <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emps&field_id=rapor.employee_id&field_name=rapor.employee_name&conf_=1','list');return false"></a>
                                            </div>                                      
                                        </div>
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>    
                                        <div class="col col-12 col-xs-12">
                                            <select name="sex" id="sex" style="width:150px;">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="0" <cfif (attributes.sex eq 0)>selected</cfif>><cf_get_lang dictionary_id='58958.Kadın'></option>
                                                <option value="1" <cfif (attributes.sex eq 1)>selected</cfif>><cf_get_lang dictionary_id='58959.Erkek'></option>
                                            </select>
                                        </div>                                                              
                                </div>		
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >								
                                <div class="form-group">										  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="blood_type" id="blood_type" style="width:150px;">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="0"<cfif len(attributes.blood_type) and (attributes.blood_type eq 0)>selected</cfif>>0 Rh+</option>
                                                <option value="1"<cfif len(attributes.blood_type) and (attributes.blood_type eq 1)>selected</cfif>>0 Rh-</option>
                                                <option value="2"<cfif len(attributes.blood_type) and (attributes.blood_type eq 2)>selected</cfif>>A Rh+</option>
                                                <option value="3"<cfif len(attributes.blood_type) and (attributes.blood_type eq 3)>selected</cfif>>A Rh-</option>
                                                <option value="4"<cfif len(attributes.blood_type) and (attributes.blood_type eq 4)>selected</cfif>>B Rh+</option>
                                                <option value="5"<cfif len(attributes.blood_type) and (attributes.blood_type eq 5)>selected</cfif>>B Rh-</option>
                                                <option value="6"<cfif len(attributes.blood_type) and (attributes.blood_type eq 6)>selected</cfif>>AB Rh+</option>
                                                <option value="7"<cfif len(attributes.blood_type) and (attributes.blood_type eq 7)>selected</cfif>>AB Rh-</option>
                                            </select>
                                        </div>  
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                                        <div class="col col-12 col-xs-12">
                                            <input type="text" name="birth_place" id="birth_place" style="width:150px;" value="<cfif isdefined('attributes.birth_place') and len(attributes.birth_place)><cfoutput>#attributes.birth_place#</cfoutput></cfif>">
                                        </div>		
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'>(<cf_get_lang dictionary_id='58724.Ay'>)</label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="birth_mon" id="birth_mon">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfloop from="1" to="12" index="i">
                                                    <cfoutput>
                                                        <option value="#i#" <cfif isdefined("attributes.birth_mon") and attributes.birth_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                                    </cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>  
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                                            <div class="col col-12 col-xs-12">
                                                <cfquery name="get_info_name" datasource="#dsn#">
                                                    SELECT * FROM SETUP_INFOPLUS_NAMES WHERE OWNER_TYPE_ID = -4
                                                </cfquery>
                                                <cfscript>
                                                    add_info_list = QueryNew("ADD_INFO_ID, ADD_INFO_NAME");
                                                    QueryAddRow(add_info_list,20);
                                                    for(kk=1;kk<=20;kk++)
                                                    {
                                                        QuerySetCell(add_info_list,"ADD_INFO_ID",kk,kk);
                                                        QuerySetCell(add_info_list,"ADD_INFO_NAME",evaluate("get_info_name.property#kk#_name"),kk);
                                                    }
                                                </cfscript>
                                                <cf_multiselect_check 
                                                    query_name="add_info_list"
                                                    name="add_info"
                                                    value="#attributes.add_info#"
                                                    width="150" 
                                                    height="100"
                                                    option_value="add_info_id"
                                                    option_name="add_info_name">
                                            </div>
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='56135.Uyruğu'></label>
                                            <div class="col col-12 col-xs-12">
                                                <cfquery name="get_country" datasource="#dsn#">
                                                    SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
                                                </cfquery>
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57734.Seçiniz"></cfsavecontent>
                                                <cf_multiselect_check 
                                                    query_name="get_country"  
                                                    name="country_id"
                                                    width="130" 
                                                    option_text="#message#" 
                                                    option_value="country_id"
                                                    option_name="country_name"
                                                    value="#attributes.country_id#">
                                            </div>                                                                                                   
                                </div>					
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >
                                <div class="form-group">
                                                                           								                                                                    
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></cfsavecontent>
                                            <cfinput value="#attributes.birth_date1#" type="text" name="birth_date1" validate="#validate_style#" message="#alert#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="birth_date1"></span>
                                        </div>	                                                                       
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40538.Kıdem Baz Tarihi'><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></cfsavecontent>
                                            <cfinput value="#attributes.kidem_date1#" type="text" name="kidem_date1" message="#alert#" validate="#validate_style#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="kidem_date1"></span>
                                        </div>	                                                                       
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39070.İzin Baz Tarihi'><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></cfsavecontent>
                                            <cfinput value="#attributes.izin_date1#" type="text" name="izin_date1" message="#alert#"  validate="#validate_style#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="izin_date1"></span>
                                        </div>	                                                                       
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38912.Gruba Giriş Tarihi'><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></cfsavecontent>
                                            <cfinput value="#attributes.group_start_date1#" type="text" name="group_start_date1" style="width:60px;" message="#alert#" validate="#validate_style#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="group_start_date1"></span>
                                        </div>	                                                                       
                                    </div>
                                </div>									
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12">														
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'><cf_get_lang dictionary_id='57502.Bitiş'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarih'></cfsavecontent>
                                                <cfinput value="#attributes.birth_date2#" type="text" name="birth_date2" validate="#validate_style#" message="#alert2#">											
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="birth_date2"></span>
                                        </div>											
                                    </div> 
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40538.Kıdem Baz Tarihi'><cf_get_lang dictionary_id='57502.Bitiş'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarih'></cfsavecontent>
                                            <cfinput value="#attributes.kidem_date2#" type="text" name="kidem_date2" message="#alert2#" validate="#validate_style#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="kidem_date2"></span>
                                        </div>											
                                    </div> 
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39070.İzin Baz Tarihi'><cf_get_lang dictionary_id='57502.Bitiş'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarih'></cfsavecontent>
                                            <cfinput value="#attributes.izin_date2#" type="text" name="izin_date2" message="#alert2#" validate="#validate_style#">											
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="izin_date2"></span>
                                        </div>											
                                    </div>   
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38912.Gruba Giriş Tarihi'><cf_get_lang dictionary_id='57502.Bitiş'></label>                                  
                                    <div class="col col-12 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="alert2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarih'></cfsavecontent>
                                        <cfinput value="#attributes.group_start_date2#" type="text" name="group_start_date2" style="width:60px;" message="#alert2#" validate="#validate_style#">      
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="group_start_date2"></span>
                                    </div>											
                                    </div>   								                                         
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">																					
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="check_all_box3" id="check_all_box3" onclick="hepsini_sec(3);" value="1" <cfif isdefined("attributes.check_all_box3")>checked</cfif>><cf_get_lang dictionary_id='39711.Hepsini Seç'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_father_and_mother" id="is_father_and_mother" value="1" <cfif isdefined('attributes.is_father_and_mother')>checked</cfif>><cf_get_lang dictionary_id='39703.Anne Baba Adı'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_birthdate" id="is_birthdate" <cfif isdefined('attributes.is_birthdate')>checked</cfif>><cf_get_lang dictionary_id='58727.Dogum Tarihi'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_birthplace" id="is_birthplace" <cfif isdefined('attributes.is_birthplace')>checked</cfif>><cf_get_lang dictionary_id='57790.Dogum Yeri'>
                                        </div>                                      
                                    </div> 
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_identy" id="is_identy" <cfif isdefined('attributes.is_identy')>checked</cfif>><cf_get_lang dictionary_id='58025.Tc Kimlik No'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_cinsiyet" id="is_cinsiyet" value="1" <cfif isdefined('attributes.is_cinsiyet') >checked</cfif>><cf_get_lang dictionary_id='57764.Cinsiyet'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_married" id="is_married" value="1" <cfif isdefined('attributes.is_married')>checked</cfif>><cf_get_lang dictionary_id='38914.Medeni Durum'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_blood" id="is_blood" value="1" <cfif isdefined('attributes.is_blood')>checked</cfif>><cf_get_lang dictionary_id='58441.Kan Grubu'>
                                        </div>                                      
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">        
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_address" id="is_address" value="1" <cfif isdefined('attributes.is_address') >checked</cfif>><cf_get_lang dictionary_id='58723.Adres'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_mail" id="is_mail" <cfif isdefined('attributes.is_mail')>checked</cfif>><cf_get_lang dictionary_id='39186.E-mail'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_mobiltel" id="is_mobiltel" <cfif isdefined('attributes.is_mobiltel')>checked</cfif>><cf_get_lang dictionary_id='58482.Mobil Tel'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_mobiltel_spc" id="is_mobiltel_spc" <cfif isdefined('attributes.is_mobiltel_spc')>checked</cfif>><cf_get_lang dictionary_id='58482.Mobil Tel'>(<cf_get_lang dictionary_id='29688.Kişisel'>)
                                        </div>                                                                                                                
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12"> 
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_hometel" id="is_hometel" value="1" <cfif isdefined('attributes.is_hometel')>checked</cfif>><cf_get_lang dictionary_id='39704.Ev Tel'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_bank_no" id="is_bank_no" value="1" <cfif isdefined('attributes.is_bank_no')>checked</cfif>><cf_get_lang dictionary_id='38986.Banka bilgileri'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_groupstart" id="is_groupstart" <cfif isdefined('attributes.is_groupstart')>checked</cfif>><cf_get_lang dictionary_id='38912.Gruba Giriş T'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_kidem" id="is_kidem" <cfif isdefined('attributes.is_kidem')>checked</cfif>><cf_get_lang dictionary_id='40538.Kıdem Baz T'>
                                        </div>                                                                                                                
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12"> 
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_izin" id="is_izin" <cfif isdefined('attributes.is_izin')>checked</cfif>><cf_get_lang dictionary_id='39070.İzin Baz Tarihi'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_identity_info" id="is_identity_info" value="1" <cfif isdefined('attributes.is_identity_info')>checked</cfif>><cf_get_lang dictionary_id='40018.Kimlik Bilgileri'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_kidem_" <cfif isdefined('attributes.is_kidem_')>checked</cfif>><cf_get_lang dictionary_id='56630.Kıdem'> <cf_get_lang dictionary_id='58053.Başlangıç T.'>
                                        </div>  
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_country_id" <cfif isdefined('attributes.is_country_id')>checked</cfif>><cf_get_lang dictionary_id ='56135.Uyruğu'>
                                        </div>                                                                                                                
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12"> 
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_hierarchy" id="is_hierarchy" <cfif isdefined('attributes.is_hierarchy')>checked</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'> (<cf_get_lang dictionary_id='57761.Hiyerarşi'>)
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_kidem_bilgisi" id="is_kidem_bilgisi" <cfif isdefined('attributes.is_kidem_bilgisi')>checked</cfif>><cf_get_lang dictionary_id='60695.Kıdem Bilgisi'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_grade_step" id="is_grade_step" <cfif isdefined('attributes.is_grade_step')>checked</cfif>><cf_get_lang dictionary_id='34749.Derece-Kademe'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_age" id="is_age" <cfif isdefined('attributes.is_age')>checked</cfif>><cf_get_lang dictionary_id='39398.Yaş'>
                                        </div>                                                                                                                
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12"> 
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_last_surname" id="is_last_surname" <cfif isdefined('attributes.is_last_surname')>checked</cfif>><cf_get_lang dictionary_id='39226.Onceki Soyad'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="military_status" id="military_status" <cfif isdefined('attributes.military_status') and len(attributes.military_status)>checked</cfif>><cf_get_lang dictionary_id='40503.Askerlik'>                                            
                                        </div>     
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="old_sgk_days" id="old_sgk_days" <cfif isdefined('attributes.old_sgk_days') and len(attributes.old_sgk_days)>checked</cfif>> <cf_get_lang dictionary_id="54358.Geçmiş SGK Günü">
                                        </div>     
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="employee_photo" id="employee_photo" <cfif isdefined('attributes.employee_photo') and len(attributes.employee_photo)>checked</cfif>> <cf_get_lang dictionary_id='30243.Photo'>
                                        </div>                                                                                                                                        
                                    </div>                               
                                </div>

                            </div>                        
                        </div>
                        <cfsavecontent variable='header'><cf_get_lang dictionary_id='39110.Ücret Bilgileri'></cfsavecontent>
                        <cf_seperator id="inout_table_" header="#header#" is_closed="0">
                        <div class="row" type="row" id="inout_table_">
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12 ">
                                <div class="form-group">										  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39081.Gerekçe'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfscript>
                                            explanation_list = QueryNew("explanation_id, explanation_name");
                                            QueryAddRow(explanation_list,43);
                                            QuerySetCell(explanation_list,"explanation_id",0,1);
                                            QuerySetCell(explanation_list,"explanation_name","Yeni Giriş",1);
                                            QuerySetCell(explanation_list,"explanation_id",-1,2);
                                            QuerySetCell(explanation_list,"explanation_name","Nakil Giriş",2);
                                        </cfscript>
                                        <cfset count = 1>
                                         <cfloop list="#reason_order_list()#" index="ccc">
                                            <cfset count = count + 1>
                                            <cfset value_name_ = listgetat(reason_list(),ccc,';')>
                                            <cfset value_id_ = ccc>
                                            <cfif isdefined("explanation_name") and len(explanation_name)>
                                                <cfset QuerySetCell(explanation_list,"explanation_id",value_id_,count)>
                                            </cfif>
                                            <cfif isdefined("explanation_name") and len(explanation_name)>
                                                <cfset QuerySetCell(explanation_list,"explanation_name",value_name_,count)>
                                            </cfif>
                                        </cfloop> 
                                        <cf_multiselect_check 
                                            query_name="explanation_list"
                                            name="explanation_id"
                                            value="#attributes.explanation_id#"  
                                            width="150" 
                                            height="100"
                                            option_value="explanation_id"
                                            option_name="explanation_name">
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40450.Ücret Yönetimi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="salary_type" id="salary_type">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="2" <cfif isDefined('attributes.salary_type') and attributes.salary_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
                                            <option value="1" <cfif isDefined('attributes.salary_type') and attributes.salary_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
                                            <option value="0" <cfif isDefined('attributes.salary_type') and attributes.salary_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57491.Saat'></option>
                                        </select>
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38993.SGK Statü'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="ssk_statute" id="ssk_statute">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfset count_ = 0>
                                            <cfloop list="#list_ucret()#" index="ccn">
                                                <cfset count_ = count_ + 1>
                                                <cfoutput><option value="#ccn#" <cfif isdefined("attributes.ssk_statute") and attributes.ssk_statute eq ccn>selected</cfif>>#listgetat(list_ucret_names(),count_,'*')#</option></cfoutput>
                                            </cfloop>
                                        </select>  
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='45122.Ulaşım Yöntemi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="transport_type_id" id="transport_type_id">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_transport_types">
                                                <option value="#transport_type_id#" <cfif attributes.transport_type_id eq transport_type_id>selected</cfif>>#transport_type#</option>
                                            </cfoutput>
                                        </select>
                                    </div>                                    
                                </div>		
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >								
                                <div class="form-group">										  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38969.Vardiyalar'></label>    
                                    <div class="col col-12 col-xs-12">
                                        <select name="shift_id" id="shift_id">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_active_shifts">
                                                <option value="#shift_id#" <cfif isDefined('attributes.shift_id') and attributes.shift_id eq shift_id>selected</cfif>>#shift_name# (#start_hour#-#end_hour#)</option>
                                            </cfoutput>
                                        </select>                                     
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39082.Çalışma Durumu'></label>    
                                    <div class="col col-12 col-xs-12">
                                        <select name="inout_statue" id="inout_statue">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="3"<cfif attributes.inout_statue eq 3> selected</cfif>><cf_get_lang dictionary_id='29518.Girişler ve Çıkışlar'></option>
                                            <option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
                                            <option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
                                            <option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='39083.Aktif Çalışanlar'></option>
                                        </select>
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38989.Brüt / Net'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="gross_net" id="gross_net">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="0"<cfif isDefined('attributes.gross_net') and attributes.gross_net eq 0> selected</cfif>><cf_get_lang dictionary_id='38990.Brüt'></option>
                                            <option value="1"<cfif isDefined('attributes.gross_net') and attributes.gross_net eq 1> selected</cfif>><cf_get_lang dictionary_id='58083.Net'></option>
                                        </select>
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39085.Sakatlık Derecesi'></label>
                                    <div class="col col-12 col-xs-12">                                          
                                        <select name="defection_level" id="defection_level">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="0" <cfif isdefined("attributes.defection_level") and attributes.defection_level eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                                            <option value="1" <cfif isdefined("attributes.defection_level") and attributes.defection_level eq 1>selected</cfif>>1</option>
                                            <option value="2" <cfif isdefined("attributes.defection_level") and attributes.defection_level eq 2>selected</cfif>>2</option>
                                            <option value="3" <cfif isdefined("attributes.defection_level") and attributes.defection_level eq 3>selected</cfif>>3</option>
                                        </select> 
                                    </div>                                                                                                     
                                </div>					
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="duty_type" id="duty_type">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="2" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,2,',')>selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'></option>
                                            <option value="1" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,1,',')>selected</cfif>><cf_get_lang dictionary_id='38967.İşveren Vekili'></option>
                                            <option value="0" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,0,',')>selected</cfif>><cf_get_lang dictionary_id='38968.İşveren'></option>
                                            <option value="3" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,3,',')>selected</cfif>><cf_get_lang dictionary_id='39111.Sendikalı'></option>
                                            <option value="4" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,4,',')>selected</cfif>><cf_get_lang dictionary_id='39113.Sözleşmeli'></option>
                                            <option value="5" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,5,',')>selected</cfif>><cf_get_lang dictionary_id='39146.Kapsam dışı'></option>
                                            <option value="6" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,6,',')>selected</cfif>><cf_get_lang dictionary_id='39152.Kısmi İstihdam'></option>
                                            <option value="7" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,7,',')>selected</cfif>><cf_get_lang dictionary_id='39156.Taşeron'></option>
                                            <option value="8" <cfif isdefined("attributes.duty_type") and listfind(attributes.duty_type,8,',')>selected</cfif>><cf_get_lang dictionary_id='34749.Derece/Kademe'></option>
                                        </select>
                                    </div>  
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39096.Maaş Aralığı'></label>
                                    <div class="col col-6 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="lower_salary_range" value="#attributes.lower_salary_range#" onKeyUp="return(FormatCurrency(this,event));"/> 
                                        </div>	                                                                       
                                    </div>
                                    <div class="col col-6 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="upper_salary_range" value="#attributes.upper_salary_range#" onKeyUp="return(FormatCurrency(this,event));"/>
                                        </div>											
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'>/<cf_get_lang dictionary_id='58724.Ay'></label>
                                   	 <div class="col col-6 col-xs-12">
                                        <select name="salary_year" id="salary_year">
                                            <cfloop from="#session.ep.period_year-3#" to="#session.ep.period_year+3#" index="i">
                                                <cfoutput>
                                                    <option value="#i#"<cfif attributes.salary_year eq i> selected</cfif>>#i#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>		
                                    <div class="col col-6 col-xs-12">	  
                                        <select name="salary_month" id="salary_month" style="width:60px;">
                                            <cfloop from="1" to="12" index="i">
                                                <cfoutput>
                                                    <option value="#i#"<cfif attributes.salary_month eq i> selected</cfif>>#i#</option>
                                                </cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>		 	
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                                    <div class="col col-12 col-xs-12">                                               
                                        <div class="input-group">
                                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='58053.Başlangıç Tarih'></cfsavecontent>
                                            <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                                <cfinput type="text" name="startdate" maxlength="10" validate="#validate_style#"  value="#dateformat(attributes.startdate,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="startdate" maxlength="10" validate="#validate_style#">
                                            </cfif>
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>	                                                                       
                                    </div>
                                        	
                                                                              								                                                                                                                                                                             
                                </div>									
                            </div>
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12">														
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39087.Kanun Maddeleri'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="law_numbers" id="law_numbers">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="5921" <cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 5921>selected</cfif>>5921</option>
                                            <option value="574680" <cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 574680>selected</cfif>>5746 (% 80)</option>
                                            <option value="574690" <cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 574690>selected</cfif>>5746 (% 90)</option>
                                            <option value="5746100"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 5746100>selected</cfif>>5746 (% 100)</option>
                                            <option value="6111" <cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 6111>selected</cfif>>6111</option>
                                            <option value="5763" <cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 5763>selected</cfif>>5763</option>
                                            <option value="5084" <cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 5084>selected</cfif>>5084</option>
                                            <option value="6486"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 6486>selected</cfif>>6486 ( İlave Teşvik)</option>
                                            <option value="6322"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 6322>selected</cfif>>6322 ( Yatırım Teşviki)</option>
                                            <option value="25510"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 25510>selected</cfif>>25510 ( İlave Teşviki)</option>
                                            <option value="4691"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 4691>selected</cfif>>4691 (% 100)</option>
                                            <option value="17103"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 17103>selected</cfif>>17103 (<cf_get_lang dictionary_id='45435.İmalat ve Bilişim'>)</option>
                                            <option value="27103"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 27103>selected</cfif>>27103 (<cf_get_lang dictionary_id='45430.Diğer Sektörler'>)</option>
                                            <option value="37103"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 37103>selected</cfif>>37103 (<cf_get_lang dictionary_id='45618.Bir Senden Bir Benden'>)</option>
                                            <option value="7252"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 7252>selected</cfif>>7252</option>
                                            <option value="17256"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 17256>selected</cfif>>17256</option>
                                            <option value="27256"<cfif isdefined("attributes.law_numbers") and attributes.law_numbers eq 27256>selected</cfif>>27256</option>
                                        </select>                                                                      
                                    </div>                                   
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58009.PDKS'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="use_pdks" id="use_pdks">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <option value="0" <cfif isdefined("attributes.use_pdks") and attributes.use_pdks eq 0>selected</cfif>><cf_get_lang dictionary_id='39158.Bağlı Değil'></option>
                                            <option value="1" <cfif isdefined("attributes.use_pdks") and attributes.use_pdks eq 1>selected</cfif>><cf_get_lang dictionary_id='39014.Bağlı'></option>
                                            <option value="2" <cfif isdefined("attributes.use_pdks") and attributes.use_pdks eq 2>selected</cfif>><cf_get_lang dictionary_id='53229.Tam Bağlı'> <cf_get_lang dictionary_id='57491.Saat'></option>
                                            <option value="3" <cfif isdefined("attributes.use_pdks") and attributes.use_pdks eq 3>selected</cfif>><cf_get_lang dictionary_id='53229.Tam Bağlı'> <cf_get_lang dictionary_id='57490.Gün'></option>
                                            <option value="4" <cfif isdefined("attributes.use_pdks") and attributes.use_pdks eq 4>selected</cfif>><cf_get_lang dictionary_id='38806.Vardiya Sistemi'></option>
                                        </select>
                                    </div>                                   
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_expense_center_list"  
                                        name="expense_center_id"
                                        value="#attributes.expense_center_id#"  
                                        width="147" 
                                        height="100"
                                        option_value="expense_id"
                                        option_name="expense">
                                    </div>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'><cf_get_lang dictionary_id='57502.Başlangıç'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="alert2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id ='57700.Bitiş Tarih'></cfsavecontent>
                                            <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
                                                <cfinput type="text" name="finishdate"  maxlength="10" validate="#validate_style#" value="#dateformat(attributes.finishdate,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="finishdate" maxlength="10" validate="#validate_style#">
                                            </cfif>
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                        </div>											
                                    </div>			                                         
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">																					
                                <div class="form-group">    
                                    <div class="col col-12 col-xs-12">
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="check_all_box4" id="check_all_box4" onclick="hepsini_sec(4);" value="1" <cfif isdefined("attributes.check_all_box4")>checked</cfif>><cf_get_lang dictionary_id='39711.Hepsini Seç'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_pdks" id="is_pdks" value="1" <cfif isdefined('attributes.is_pdks')>checked</cfif>><cf_get_lang dictionary_id ='58009.PDKS'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_accounting_accounts" id="is_accounting_accounts" value="1" <cfif isdefined('attributes.is_accounting_accounts')>checked</cfif>><cf_get_lang dictionary_id ='38814.Muhasebe Hesapları'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_first_ssk" id="is_first_ssk" value="1" <cfif isdefined('attributes.is_first_ssk')>checked</cfif>><cf_get_lang dictionary_id='38883.İlk Sigortalı Oluş'>
                                        </div>                                      
                                    </div> 
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">      
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_start_date" id="is_start_date" <cfif isdefined('attributes.is_start_date')>checked</cfif>><cf_get_lang dictionary_id='38923.İşe Giriş Tarihi'>                                            
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_finish_date" id="is_finish_date" <cfif isdefined('attributes.is_finish_date')>checked</cfif>><cf_get_lang dictionary_id='39464.isten Cikis Tarihi'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_account_code" id="is_account_code" value="1" <cfif isdefined('attributes.is_account_code')>checked</cfif>><cf_get_lang dictionary_id='39706.Masraf Kodu'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_expense" id="is_expense" value="1" <cfif isdefined('attributes.is_expense')>checked</cfif>><cf_get_lang dictionary_id='58460.Masraf Merkezi'>
                                        </div>                                      
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">                
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_reason" id="is_reason" <cfif isdefined('attributes.is_reason')>checked</cfif>><cf_get_lang dictionary_id='57554.Giriş'><cf_get_lang dictionary_id='39081.Gerekçe'>                                            
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_reason_out" id="is_reason_out" <cfif isdefined('attributes.is_reason_out')>checked</cfif>><cf_get_lang dictionary_id='57431.Çıkış'><cf_get_lang dictionary_id='39081.Gerekçe'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_duty_type" id="is_duty_type" <cfif isdefined('attributes.is_duty_type')>checked</cfif>><cf_get_lang dictionary_id='58538.Görev Tipi'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_business_code" id="is_business_code" <cfif isdefined('attributes.is_business_code')>checked</cfif>><cf_get_lang dictionary_id='53861.Meslek Grubu'>
                                        </div>                                                                                                                
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12">                                                                              	
                                    <cfif get_module_user(48)>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_salary_plan" id="is_salary_plan" value="1" <cfif isdefined('attributes.is_salary_plan')>checked</cfif>><cf_get_lang dictionary_id='40523.Planlanan Maaş'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_salary" id="is_salary" value="1" <cfif isdefined('attributes.is_salary')>checked</cfif>><cf_get_lang dictionary_id='40071.Maaş'>
                                        </div>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="is_salary_type" id="is_salary_type" value="1" <cfif isdefined('attributes.is_salary_type')>checked</cfif>><cf_get_lang dictionary_id='40450.Ücret Yönetimi'>
                                        </div>
                                    </cfif>
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="in_comp_reason" id="in_comp_reason" value="1" <cfif isdefined('attributes.in_comp_reason')>checked</cfif>><cf_get_lang dictionary_id='38957.Şirket içi gerekçe'>							
                                        </div>                                                                                                                
                                    </div>                               
                                </div>
                                <div class="form-group">
                                    <div class="col col-12 col-xs-12"> 
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="fire_detail" id="fire_detail" value="1" <cfif isdefined('attributes.fire_detail')>checked</cfif>><cf_get_lang dictionary_id='38884.Çıkış Açıklaması'>
                                        </div>                                                                                                                                                     
                                        <div class="col col-3 col-xs-12">
                                            <input type="checkbox" name="sureli_is_akdi" id="sureli_is_akdi" value="1" <cfif isdefined('attributes.sureli_is_akdi') and len(attributes.sureli_is_akdi)>checked</cfif>><cf_get_lang dictionary_id='56428.Belirli Süreli İş Akdi'>
                                        </div>                                                                                                                                            
                                    </div>                               
                                </div>                              
                            </div>                        
                        </div>
                        <cfsavecontent variable='header'><cf_get_lang dictionary_id='55216.Yabancı Dil'></cfsavecontent>
                            <cf_seperator id="language_" header="#header#" is_closed="0">
                            <div class="row" type="row" id="language_">
                                <div class="col col-2 col-md-2 col-sm-6 col-xs-12 ">
                                    <div class="form-group">										  
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38917.Yabancı Dil'></label>
                                        <div class="col col-12 col-xs-12">                                          
                                            <select name="languages" id="languages">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="get_languages">
                                                    <option value="#language_id#" <cfif listfind(attributes.languages,language_id,',')>selected</cfif>>#language_set#</option>
                                                </cfoutput>
                                            </select>
                                        </div> 
                                    </div>		
                                    	
                                </div>
                                <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >
                                    <cfif isdefined('x_document_name') and x_document_name eq 1>   								
                                        <div class="form-group">										  
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38917.Yabancı Dil'><cf_get_lang dictionary_id='55652.Belge Adı'></label>
                                            <div class="col col-12 col-xs-12">   
                                                <select name="document_name" id="document_name">
                                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                    <cfoutput query="get_lang_document">
                                                        <option value="#document_id#" <cfif listfind(attributes.document_name,document_id,',')>selected</cfif>>#document_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div> 
                                        </div>	
                                    <cfelse>   							
                                        <div class="form-group">										  
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='55652.Belge Adı'></label>
                                            <div class="col col-12 col-xs-12">   
                                                <input type="text" name="paper_name" id="paper_name" value="<cfif isdefined('attributes.paper_name') and len(attributes.paper_name)><cfoutput>#attributes.paper_name#</cfoutput></cfif>">
                                            </div> 
                                        </div>
                                    </cfif>
                                </div>	
                                <div class="col col-2 col-md-2 col-sm-6 col-xs-12">														
                                    <div class="form-group">										  
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="lang_status" id="lang_status">
                                                <option value=""<cfif isdefined("attributes.lang_status") and (attributes.lang_status eq '')>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                <option value="1"<cfif isdefined("attributes.lang_status") and (attributes.lang_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                                <option value="0"<cfif isdefined("attributes.lang_status") and (attributes.lang_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >
                                    <div class="form-group">										  
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39422.Belge Tarihi'></label>
                                            <div class="col col-12 col-xs-12">                                               
                                                <div class="input-group">
                                                    <cfif isdefined('attributes.document_date') and isdate(attributes.document_date)>
                                                        <cfinput type="text" name="document_date" maxlength="10" validate="#validate_style#"  value="#dateformat(attributes.document_date,dateformat_style)#">
                                                    <cfelse>
                                                        <cfinput type="text" name="document_date" maxlength="10" validate="#validate_style#">
                                                    </cfif>
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="document_date"></span>
                                                </div>	                                                                       
                                            </div>
                                    </div>									
                                </div>
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12">																					
                                    <div class="form-group">
                                        <div class="col col-12 col-xs-12">
                                            <div class="col col-3 col-xs-12">
                                                <input type="checkbox" name="check_all_box5" id="check_all_box5" onclick="hepsini_sec(5);" value="1" <cfif isdefined("attributes.check_all_box5")>checked</cfif>><cf_get_lang dictionary_id='51050.Hepsini Seç'>
                                            </div>
                                            <div class="col col-3 col-xs-12">
                                                <input type="checkbox" name="is_language" id="is_language" value="1" <cfif isdefined('attributes.is_language')>checked</cfif>><cf_get_lang dictionary_id='55216.Yabancı Dil'>
                                            </div>
                                            <div class="col col-3 col-xs-12">
                                                <input type="checkbox" name="is_document" id="is_document" value="1" <cfif isdefined('attributes.is_document')>checked</cfif>><cf_get_lang dictionary_id='55652.Belge Adı'>
                                            </div>
                                            <div class="col col-3 col-xs-12">
                                                <input type="checkbox" name="is_document_date" id="is_document_date" value="1" <cfif isdefined('attributes.is_document_date')>checked</cfif>><cf_get_lang dictionary_id='39422.Belge Tarihi'>
                                            </div>   
                                        </div> 
                                    </div>
                                    <div class="form-group">
                                        <div class="col col-12 col-xs-12">
                                            <div class="col col-3 col-xs-12">
                                                <input type="checkbox" name="is_point" id="is_point" value="1" <cfif isdefined('attributes.is_point')>checked</cfif>><cf_get_lang dictionary_id='41169.Dil Puanı'>
                                            </div> 
                                            <div class="col col-3 col-xs-12">
                                                <input type="checkbox" name="is_lang_where" id="is_lang_where" value="1" <cfif isdefined('attributes.is_lang_where')>checked</cfif>><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'>
                                            </div>  
                                            <div class="col col-6 col-xs-12">
                                                <input type="checkbox" name="is_paper_finish_date" id="is_paper_finish_date" value="1" <cfif isdefined('attributes.is_paper_finish_date')>checked</cfif>><cf_get_lang dictionary_id='53065.Geçerlilik Bitiş Tarihi'>
                                            </div>                              
                                        </div>                               
                                    </div>
                                </div>                        
                            </div>
                            <cfsavecontent variable='header'><cf_get_lang dictionary_id='30644.Eğitim Bilgileri'></cfsavecontent>
                                <cf_seperator id="education_" header="#header#" is_closed="0">
                                <div class="row" type="row" id="education_">
                                    <div class="col col-2 col-md-2 col-sm-6 col-xs-12 ">
                                        <div class="form-group" id="education_name">										  
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39521.Eğitim Seviyesi'></label>
                                            <div class="col col-12 col-xs-12">
                                                <select name="education_name" id="education_name" onchange="degistir_okul();">
                                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                    <cfoutput query="get_education_level">
                                                    <option value="#edu_level_id#" <cfif listfind(attributes.education_name,edu_level_id,',')>selected</cfif>>#education_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>		
                                    </div>
                                    <div class="col col-2 col-md-2 col-sm-6 col-xs-12">								
                                        <div class="form-group"  id="university" <cfif attributes.education_name neq 1>style="display:"<cfelse>style="display:none"</cfif>>
                                            <label class="col ol-12 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label> 	
                                            <div class="col col-12 col-xs-12">
                                                <select name="edu_part_id" id="edu_part_id">
                                                    <option value=""><cf_get_lang dictionary_id='58139.Bölümler'></option>
                                                    <cfoutput query="get_school_part">
                                                        <option value="#part_id#" <cfif listfind(attributes.edu_part_id,part_id,',')>selected</cfif>>#part_name#</option>	
                                                    </cfoutput>
                                                    <option value="-1" <cfif listfind(attributes.edu_part_id,'-1',',')>selected</cfif>>Diğer</option>
                                                </select>
                                            </div>
                                        </div>	
                                        <div class="form-group" id="high_school" <cfif attributes.education_name eq 1>style="display:"<cfelse>style="display:none"</cfif>>	
                                            <label class="col ol-12 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label> 	
                                            <div class="col col-12 col-xs-12">
                                                <select name="edu_high_part_id" id="edu_high_part_id">
                                                    <option value=""><cf_get_lang dictionary_id='56154.Lise Bölümleri'></option>
                                                    <cfoutput query="get_high_school_part">
                                                        <option value="#high_part_id#" <cfif listfind(attributes.edu_high_part_id,high_part_id,',')>selected</cfif>>#high_part_name#</option>	
                                                    </cfoutput>
                                                    <option value="-1" <cfif listfind(attributes.edu_high_part_id,'-1',',')>selected</cfif>>Diğer</option>
                                                </select>
                                            </div>
                                        </div>						
                                    </div>
                                    <div class="col col-2 col-md-2 col-sm-6 col-xs-12">														
                                        <div class="form-group">										  
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='41520.Öğrenim Dili'></label>
                                                <div class="col col-12 col-xs-12">                                          
                                                    <select name="edu_lang" id="edu_lang">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfoutput query="get_languages">
                                                            <option value="#language_set#" <cfif listfind(attributes.edu_lang,language_set,',')>selected</cfif>>#language_set#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-2 col-sm-6 col-xs-12" >
                                        <div class="form-group">										  
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='55725.En son Bitirilen Okul'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <select name="last_school" id="last_school">
                                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                        <cfoutput query="get_education_level">
                                                        <option value="#edu_level_id#" <cfif listfind(attributes.last_school
                                                        ,edu_level_id,',')>selected</cfif>>#education_name#</option>
                                                        </cfoutput>
                                                    </select>
                                                </div>
                                        </div>									
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">																					
                                        <div class="form-group">
                                            <div class="col col-12 col-xs-12">
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="check_all_box6" id="check_all_box6" onclick="hepsini_sec(6);" value="1" <cfif isdefined("attributes.check_all_box6")>checked</cfif>><cf_get_lang dictionary_id='51050.Hepsini Seç'>
                                                </div>
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="is_edu_type" id="is_edu_type" value="1" <cfif isdefined('attributes.is_edu_type')>checked</cfif>><cf_get_lang dictionary_id='39708.Eğitim Durumu'>
                                                </div>
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="is_last_school" id="is_last_school" value="1" <cfif isdefined('attributes.is_last_school')>checked</cfif>><cf_get_lang dictionary_id='55725.En son Bitirilen okul'>
                                                </div>
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="is_edu_lang" id="is_edu_lang" value="1" <cfif isdefined('attributes.is_edu_lang')>checked</cfif>><cf_get_lang dictionary_id='41520.Öğrenim Dili'>
                                                </div>
                                            </div> 
                                        </div>
                                        <div class="form-group">
                                            <div class="col col-12 col-xs-12">
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="is_edu_name" id="is_edu_name" value="1" <cfif isdefined('attributes.is_edu_name')>checked</cfif>><cf_get_lang dictionary_id='30645.Okul Adı'>
                                                </div>  
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="is_part_name" id="is_part_name" value="1" <cfif isdefined('attributes.is_part_name')>checked</cfif>><cf_get_lang dictionary_id='57995.Bölüm'>
                                                </div>  
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="is_edu_lang_rate" id="is_edu_lang_rate" value="1" <cfif isdefined('attributes.is_edu_lang_rate')>checked</cfif>><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cf_get_lang dictionary_id ='58671.Oranı'> 
                                                </div>  
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="is_edu_startdate" id="is_edu_startdate" value="1" <cfif isdefined('attributes.is_edu_startdate')>checked</cfif>><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'>
                                                </div>    
                                                <div class="col col-3 col-xs-12">
                                                    <input type="checkbox" name="is_edu_finishdate" id="is_edu_finishdate" value="1" <cfif isdefined('attributes.is_edu_finishdate')>checked</cfif>><cf_get_lang dictionary_id ='30695.Mezuniyet Tarihi'>
                                                </div>                        
                                            </div>                               
                                        </div>
                                    </div>                        
                                </div>
                    </div>   
                    <div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>				
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                                <cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>
						
						</div>
            		</div>	                 
                </div>	
            </div>
        </cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
</cfprocessingdirective>

<cfif isdefined("attributes.form_submitted")>
    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename="employee_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-16">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
        <cfset attributes.startrow=1>
        <cfset attributes.maxrows=get_employee.recordcount>
    </cfif>
   
<cf_report_list>
    
        <cfif get_employee.recordcount>
        	<cfscript>        	
        		employee_id_list = '';
        		position_type_list = "";
        		fonksiyon_name_list = "";
        		collar_type_list = "";
        		organization_step_list = "";
        		city_id_list = "";
        		county_id_list = "";
        		end_school_list ="";
        		in_out_id_list ="";
        		employees_salary_list ="";
        		expense_center_list = "";
        		position_code_list = "";
        		org_colspan = 0;
        		poz_colspan = 0;
        		pro_colspan = 0;
                ino_colspan = 0;
                lang_colspan = 0;
                edu_colspan = 0;
                general_colspan = 3;
                if (isdefined('attributes.employee_photo')) general_colspan = general_colspan + 1;
        		if (isdefined('attributes.is_company')) org_colspan = org_colspan + 1;
        		if (isdefined('attributes.is_comp_branch')) org_colspan = org_colspan + 1;
        		if (isdefined('attributes.is_branch')) org_colspan = org_colspan + 1;
        		if (isdefined('attributes.is_department')) org_colspan = org_colspan + 1;
                if (isdefined('attributes.is_special_code') and len(attributes.is_special_code)) org_colspan = org_colspan + 1;
                if (isdefined('attributes.is_dep_level') and len(is_dep_level)) org_colspan = org_colspan + 1;
                if (isdefined('attributes.is_hierarchy_dep')) org_colspan = org_colspan + 3;
        		if (isdefined('attributes.is_position_name')) poz_colspan = poz_colspan + 1;
        		if (isdefined('attributes.is_poscat')) poz_colspan = poz_colspan + 1;
        		if (isdefined('attributes.is_title')) poz_colspan = poz_colspan + 1;
        		if (isdefined('attributes.is_organization_step')) poz_colspan = poz_colspan + 1;
        		if (isdefined('attributes.is_function')) poz_colspan = poz_colspan + 1;
        		if (isdefined('attributes.is_collar_type')) poz_colspan = poz_colspan + 1;
        		if (isdefined('attributes.is_idariamir')) poz_colspan = poz_colspan + 1;
                if (isdefined('attributes.is_fonkamir')) poz_colspan = poz_colspan + 1;
                if (isdefined('attributes.is_group')) poz_colspan = poz_colspan + 1;
        		if (isdefined('attributes.is_father_and_mother') and attributes.is_father_and_mother eq 1) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_birthdate') and len(attributes.is_birthdate)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_birthplace') and len(attributes.is_birthplace)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_identy') and len(attributes.is_identy)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_cinsiyet') and attributes.is_cinsiyet eq 1) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_married') and attributes.is_married eq 1) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_blood') and attributes.is_blood eq 1) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_address') and len(attributes.is_address)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_address') and len(attributes.is_address)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_address') and len(attributes.is_address)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_mail') and len(attributes.is_mail)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_mobiltel') and len(attributes.is_mobiltel)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_mobiltel_spc') and len(attributes.is_mobiltel_spc)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_hometel') and len(attributes.is_hometel)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1) pro_colspan = pro_colspan + 5;
        		if (isdefined('attributes.is_groupstart') and len(attributes.is_groupstart)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_kidem') and len(attributes.is_kidem)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_kidem_') and len(attributes.is_kidem_)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_kidem_bilgisi') and len(attributes.is_kidem_bilgisi)) pro_colspan = pro_colspan + 1;
                if (isdefined('attributes.is_country_id') and len(attributes.is_country_id)) pro_colspan = pro_colspan + 1;
                if (isdefined('attributes.country_id') and len(attributes.country_id)) pro_colspan = pro_colspan + 1;
                if (isdefined('attributes.old_sgk_days') and len(attributes.old_sgk_days)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_izin') and len(attributes.is_izin)) pro_colspan = pro_colspan + 1;
        		if (isdefined("attributes.add_info") and len(attributes.add_info)) pro_colspan = pro_colspan + listlen(attributes.add_info);
        		if (isdefined('attributes.is_hierarchy') and len(attributes.is_hierarchy)) pro_colspan = pro_colspan + 3;
        		if (isdefined('attributes.is_grade_step') and len(attributes.is_grade_step)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_age') and len(attributes.is_age)) pro_colspan = pro_colspan + 1;
                if (isdefined('attributes.is_last_surname') and len(attributes.is_last_surname)) pro_colspan = pro_colspan + 1;
                if (isdefined('attributes.military_status') and len(attributes.military_status)) pro_colspan = pro_colspan + 1;
        		if (isdefined('attributes.is_pdks')) ino_colspan = ino_colspan + 3;
        		if (isdefined('attributes.is_accounting_accounts')) ino_colspan = ino_colspan + 1 + get_acc_types.recordcount;
        		if (isdefined('attributes.is_business_code')) ino_colspan = ino_colspan + 2;
        		if (isdefined('attributes.is_first_ssk')) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.is_start_date')) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.is_finish_date')) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.is_account_code') and attributes.is_account_code eq 1) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.is_expense') and attributes.is_expense eq 1) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.is_reason')) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.is_reason_out')) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.is_duty_type')) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.in_comp_reason')) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.fire_detail')) ino_colspan = ino_colspan + 1;
        		if (isdefined('attributes.is_salary_plan') and attributes.is_salary_plan eq 1) ino_colspan = ino_colspan + 2;
        		if (isdefined('attributes.is_salary') and attributes.is_salary eq 1) ino_colspan = ino_colspan + 3;
        		if (isdefined('attributes.is_salary_type') and attributes.is_salary_type eq 1) ino_colspan = ino_colspan + 1;
                if (isdefined('attributes.is_identity_info') and attributes.is_identity_info eq 1) pro_colspan = pro_colspan + 12;
                if (isdefined('attributes.is_language')) lang_colspan = lang_colspan + 4;
                if (isdefined('attributes.is_document')) lang_colspan = lang_colspan + 4;
                if (isdefined('attributes.is_document')) lang_colspan = lang_colspan + 4;
                if (isdefined('attributes.is_document_date')) lang_colspan = lang_colspan + 4;
                if (isdefined('attributes.is_point')) lang_colspan = lang_colspan + 4;
                if (isdefined('attributes.is_lang_where')) lang_colspan = lang_colspan + 4;
                if (isdefined('attributes.is_paper_finish_date')) lang_colspan = lang_colspan + 4;
                if (isdefined('attributes.is_edu_type') and attributes.is_edu_type eq 1) edu_colspan = edu_colspan + 1;
                if (isdefined('attributes.is_last_school') and attributes.is_last_school eq 1) edu_colspan = edu_colspan + 1;
                if (isdefined('attributes.is_edu_lang') and attributes.is_edu_lang eq 1) edu_colspan = edu_colspan + 12;
                if (isdefined('attributes.is_edu_name') and attributes.is_edu_name eq 1) edu_colspan = edu_colspan + 12;
                if (isdefined('attributes.is_part_name') and attributes.is_part_name eq 1) edu_colspan = edu_colspan + 12;
                if (isdefined('attributes.is_edu_lang_rate') and attributes.is_edu_lang_rate eq 1) edu_colspan = edu_colspan + 12;
                if (isdefined('attributes.is_edu_startdate') and attributes.is_edu_startdate eq 1) edu_colspan = edu_colspan + 12;
                if (isdefined('attributes.is_edu_finishdate') and attributes.is_edu_finishdate eq 1) edu_colspan = edu_colspan + 12;
                

            </cfscript>
            <thead>
        <cfif org_colspan gt 0 or lang_colspan gt 0 or poz_colspan gt 0 or pro_colspan gt 0 or edu_colspan gt 0 or ino_colspan gt 0 or (isdefined('attributes.is_org_position') and get_organization_steps.recordcount)>
            <cfoutput>
            	
                    <tr>
                        <th  colspan="#general_colspan#">&nbsp;</th>
                        <cfif org_colspan gt 0>
                            <th colspan="#org_colspan#"><cf_get_lang dictionary_id='57972.Organizasyon'></th>
                        </cfif>
                        <cfif poz_colspan gt 0>
                            <th colspan="#poz_colspan#"><cf_get_lang dictionary_id='58123.Planlama'></th>
                        </cfif>
                        <cfif isdefined('attributes.is_org_position')>
                            <th colspan="#get_organization_steps.recordcount#"><cf_get_lang dictionary_id='39068.Kademesel Amirler'></th>
                        </cfif>
                        <cfif pro_colspan gt 0>
                            <th colspan="#pro_colspan#"><cf_get_lang dictionary_id='39097.Profil'></th>
                        </cfif>
                        <cfif ino_colspan gt 0>
                            <th colspan="#ino_colspan#"><cf_get_lang dictionary_id='39110.Ücret Bilgileri'></th>
                        </cfif>
                        <cfif lang_colspan gt 0>
                            <th colspan="#lang_colspan#"><cf_get_lang dictionary_id='55872.Yabancı Diller'></th>
                        </cfif>
                        <cfif edu_colspan gt 0>
                            <th colspan="#edu_colspan#"><cf_get_lang dictionary_id='30644.Eğitim Bilgileri'></th>
                        </cfif>
                        <cfif len(attributes.sureli_is_akdi)>
                            <th><cf_get_lang dictionary_id='56428.Belirli Süreli İş Akdi'></th>
                        </cfif>
                    </tr>
               
            </cfoutput>
        </cfif>
        <tr>
            <cfif isdefined("attributes.employee_photo")><th width="45" ><cf_get_lang dictionary_id='30243.Photo'></th></cfif>
            <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th width="150"><cf_get_lang dictionary_id='57576.calisan'><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='57576.calisan'></th>
            <!--- organizasyon --->
            <cfif isdefined('attributes.is_company')><th><cf_get_lang dictionary_id='57574.Şirket'></th></cfif>
            <cfif isdefined('attributes.is_comp_branch')><th><cf_get_lang dictionary_id='57992.Bölge'></th></cfif>
            <cfif isdefined('attributes.is_branch')><th><cf_get_lang dictionary_id='57453.Şube'></th></cfif>
            <cfif isdefined('attributes.is_hierarchy_dep') and not isdefined('is_dep_level')>
				<cfif up_dep_len gt 0>
                    <cfif x_show_level_column eq 0>
                        <th><cf_get_lang dictionary_id='63128.İş Birimi'></th>
                    <cfelse>
                        <cfloop from="#up_dep_len#" to="1" index="i" step="-1">
                            <th><cfoutput><cf_get_lang dictionary_id='39710.Üst Departman'>#i#</cfoutput></th>
                        </cfloop>
                    </cfif>
				</cfif>
           	<cfelseif isdefined('attributes.is_hierarchy_dep') and isdefined('is_dep_level')>
                <cfif get_dep_lvl.recordcount>
                    <cfif x_show_level_column eq 0>
                        <th><cf_get_lang dictionary_id='63128.İş Birimi'></th>
                    <cfelse>
                        <cfloop query="get_dep_lvl">
                            <th>
                                <cfoutput>
                                    <cf_get_lang dictionary_id='57572.Departman'>
                                    <cfif x_show_level eq 1>
                                            <cfset get_org_level = cmp_org_step.get_organization_step(level_no : level_no)>
                                            <cfif get_org_level.recordcount>
                                                (#get_org_level.ORGANIZATION_STEP_NAME#)
                                            </cfif>
                                    <cfelse>
                                        (#level_no#)
                                    </cfif>
                                </cfoutput>
                            </th>
                        </cfloop>
                    </cfif>
				</cfif>
			</cfif>
            <cfif isdefined('attributes.is_department')><th ><cf_get_lang dictionary_id='57572.Departman'></th></cfif>
            <cfif isdefined('attributes.is_special_code') and len(attributes.is_special_code)><th ><cf_get_lang dictionary_id='57789.Özel Kod'></th></cfif>
            <!--- planlama --->
            <cfif isdefined('attributes.is_position_name')><th><cf_get_lang dictionary_id='58497.Pozisyon'></th></cfif>
            <cfif isdefined('attributes.is_poscat')><th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th></cfif>
            <cfif isdefined('attributes.is_title')><th><cf_get_lang dictionary_id='57571.Ünvan'></th></cfif>
            <cfif isdefined('attributes.is_organization_step')><th><cf_get_lang dictionary_id='58710.Kademe'></th></cfif>
            <cfif isdefined('attributes.is_function')><th><cf_get_lang dictionary_id='58701.Fonksiyon'></th></cfif>
            <cfif isdefined('attributes.is_collar_type')><th><cf_get_lang dictionary_id='38908.Yaka Tipi'></th></cfif>
            <cfif isdefined('attributes.is_idariamir')><th><cf_get_lang dictionary_id='38934.İdari Amir'></th></cfif>
            <cfif isdefined('attributes.is_fonkamir')><th><cf_get_lang dictionary_id='38936.Fonksiyonel Amir'></th></cfif>
            <cfif isdefined('attributes.is_group')><th><cf_get_lang dictionary_id='56857.Çalışan Grubu'></th></cfif>
            <cfif isdefined('attributes.is_org_position')>
                <cfoutput query="get_organization_steps">
                    <th>#organization_step_name#</th>
                </cfoutput>
            </cfif>
            <!--- profil --->
             <cfif isdefined('attributes.is_last_surname') and len(attributes.is_last_surname)><th><cf_get_lang dictionary_id='39226.Onceki Soyad'></th></cfif>
            <cfif isdefined('attributes.military_status') and len(attributes.military_status)><th><cf_get_lang dictionary_id='40503.Askerlik'></th></cfif>
            <cfif isdefined('attributes.is_father_and_mother') and attributes.is_father_and_mother eq 1><th><cf_get_lang dictionary_id='39703.Anne Baba Adı'></th></cfif>
            <cfif isdefined('attributes.is_birthdate') and len(attributes.is_birthdate)><th><cf_get_lang dictionary_id='58727.Dogum Tarihi'></th></cfif>
            <cfif isdefined('attributes.is_birthplace') and len(attributes.is_birthplace)><th><cf_get_lang dictionary_id='57790.Dogum Yeri'></th></cfif>
            <cfif isdefined('attributes.is_age') and len(attributes.is_age)><th><cf_get_lang dictionary_id='39398.Yaş'></th></cfif>
            <cfif isdefined('attributes.is_identy') and len(attributes.is_identy)><th><cf_get_lang dictionary_id='58025.Tc Kimlik No'></th></cfif>
            <cfif isdefined('attributes.is_cinsiyet') and attributes.is_cinsiyet eq 1><th><cf_get_lang dictionary_id='57764.Cinsiyet'></th></cfif>
            <cfif isdefined('attributes.is_married') and attributes.is_married eq 1><th><cf_get_lang dictionary_id='38914.Medeni Durum'></th></cfif>
            <cfif isdefined('attributes.is_blood') and attributes.is_blood eq 1><th><cf_get_lang dictionary_id='58441.Kan Grubu'></th></cfif>
            <cfif isdefined('attributes.is_address') and len(attributes.is_address)><th><cf_get_lang dictionary_id='58723.Adres'></th></cfif>
            <cfif isdefined('attributes.is_address') and len(attributes.is_address)><th><cf_get_lang dictionary_id='58638.İlçe'></th></cfif>
            <cfif isdefined('attributes.is_address') and len(attributes.is_address)><th><cf_get_lang dictionary_id='58608.İl'></th></cfif>
            <cfif isdefined('attributes.is_mail') and len(attributes.is_mail)><th><cf_get_lang dictionary_id='57428.E-mail'></th></cfif>
            <cfif isdefined('attributes.is_mobiltel') and len(attributes.is_mobiltel)><th><cf_get_lang dictionary_id='58482.Mobil Tel'></th></cfif>
            <cfif isdefined('attributes.is_mobiltel_spc') and len(attributes.is_mobiltel_spc)><th><cf_get_lang dictionary_id='58482.Mobil Tel'>(<cf_get_lang dictionary_id='29688.Kişisel'>)</th></cfif>
            <cfif isdefined('attributes.is_hometel') and len(attributes.is_hometel)><th><cf_get_lang dictionary_id='39704.Ev Tel'></th></cfif>
            <cfif isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1>
                <th><cf_get_lang dictionary_id='57521.Banka'></th>	
                <th><cf_get_lang dictionary_id='58933.Banka Şubesi'></th>
                <th><cf_get_lang dictionary_id='59005.Şube Kodu'></th>
                <th><cf_get_lang dictionary_id='39707.Banka Hesap No'></th>
                <th><cf_get_lang dictionary_id='59007.Iban kodu'></th>
            </cfif>
            <cfif isdefined('attributes.is_groupstart') and len(attributes.is_groupstart)><th><cf_get_lang dictionary_id='39429.Gruba Giriş'></th></cfif>
            <cfif isdefined('attributes.is_kidem') and len(attributes.is_kidem)><th><cf_get_lang dictionary_id='38907.Kıdem Baz'></th></cfif>
			<cfif isdefined('attributes.is_kidem_') and len(attributes.is_kidem_)><th><cf_get_lang dictionary_id='56630.Kıdem'> <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th></cfif>
            <cfif isdefined('attributes.is_kidem_bilgisi') and len(attributes.is_kidem_bilgisi)><th ><cf_get_lang dictionary_id='60695.Kıdem Bilgisi'></th></cfif>
            <cfif isdefined('attributes.old_sgk_days') and len(attributes.old_sgk_days)><th ><cf_get_lang dictionary_id="54358.Geçmiş SGK Günü"></th></cfif>
		    <cfif isdefined('attributes.is_izin') and len(attributes.is_izin)><th><cf_get_lang dictionary_id='39077.İzin Baz'></th></cfif>
            <cfif isdefined("attributes.add_info") and len(attributes.add_info)>
                <cfoutput>
                    <cfquery name="get_info_name" datasource="#dsn#">
                        SELECT * FROM SETUP_INFOPLUS_NAMES WHERE OWNER_TYPE_ID = -4
                    </cfquery>
                    <cfloop list="#attributes.add_info#" index="kk">
                        <th>#evaluate("get_info_name.property#kk#_name")#</th>
                    </cfloop>
                </cfoutput>
            </cfif>
            <cfif isdefined('attributes.is_hierarchy') and len(attributes.is_hierarchy)>
				<th><cf_get_lang dictionary_id='57789.Özel Kod'>(<cf_get_lang dictionary_id='57761.Hiyerarşi'>)</th>
				<th><cf_get_lang dictionary_id='57789.Özel Kod'>1</th>
                <th><cf_get_lang dictionary_id='57789.Özel Kod'>2</th>
			</cfif>
            <cfif isdefined('attributes.is_grade_step') and len(attributes.is_grade_step)><th><cf_get_lang dictionary_id='34749.Derece-Kademe'></th>
            </cfif>
            <!---Profil altında ayrıntılı kimlik bilgileri --->
            <cfif isdefined("attributes.is_identity_info") and len(attributes.is_identity_info)>
                <th><cf_get_lang dictionary_id='55636.Cüzdan Seri/No'></th>
                <th><cf_get_lang dictionary_id='58608.İl'></th>
                <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                <th><cf_get_lang dictionary_id='58735.Mahalle'></th>
                <th><cf_get_lang dictionary_id='55645.Köy'></th>
                <th><cf_get_lang dictionary_id='39236.Cilt No'></th>
                <th><cf_get_lang dictionary_id='55656.Aile Sıra No'></th>
                <th><cf_get_lang dictionary_id='55657.Sıra No'></th>
                <th><cf_get_lang dictionary_id='60696.Cüzdanın Verildiği Yer'></th>
                <th><cf_get_lang dictionary_id='55648.Veriliş Nedeni'></th>
                <th><cf_get_lang dictionary_id='55658.Kayıt No'></th>
                <th><cf_get_lang dictionary_id='55659.Veriliş Tarihi'></th>
            </cfif>
            <!--- ücret --->
            <cfif isdefined('attributes.is_pdks')>
                <th><cf_get_lang dictionary_id='39968.PDKS No'></th>
                <th><cf_get_lang dictionary_id='29489.PDKS Tipi'></th>
                <th><cf_get_lang dictionary_id='38797.Bağlılık Türü'></th>
            </cfif>
            <cfif isdefined('attributes.is_accounting_accounts')>
                <th><cf_get_lang dictionary_id='38817.Muhasebe Kod Grubu'></th>
                <cfoutput query="get_acc_types">
                    <th>#acc_type_name#</th>
                </cfoutput>
            </cfif>
            <cfif isdefined('attributes.is_first_ssk')><th><cf_get_lang dictionary_id='38883.İlk Sigortalı Oluş'></th></cfif>
            <cfif isdefined('attributes.is_start_date')><th><cf_get_lang dictionary_id='38923.İşe Giriş Tarihi'></th></cfif>
            <cfif isdefined('attributes.is_finish_date')><th><cf_get_lang dictionary_id='39464.İşten Çıkış Tarihi'></th></cfif>
            <cfif isdefined('attributes.is_account_code') and attributes.is_account_code eq 1><th><cf_get_lang dictionary_id='39706.Masraf Kodu'></th></cfif>
            <cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1><th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th></cfif>
            <cfif isdefined('attributes.is_reason')><th><cf_get_lang dictionary_id='57554.Giriş'><cf_get_lang dictionary_id='39081.Gerekçe'></th></cfif>
            <cfif isdefined('attributes.is_reason_out')><th><cf_get_lang dictionary_id='57431.Çıkış'><cf_get_lang dictionary_id='39081.Gerekçe'></th></cfif>
            <cfif isdefined('attributes.is_duty_type')><th><cf_get_lang dictionary_id='58538.Görev Tipi'></th></cfif>
            <cfif isdefined('attributes.is_business_code')>
				<th><cf_get_lang dictionary_id='53840.Meslek Kodu'></th>
				<th><cf_get_lang dictionary_id='55900.Meslek Grubu'></th>
			</cfif>
            <cfif isdefined('attributes.is_salary_plan') and attributes.is_salary_plan eq 1>
                <th><cf_get_lang dictionary_id='40523.Planlanan Maaş'></th>
                <th><cf_get_lang dictionary_id='57489.Para Br'></th>
            </cfif>
            <cfif isdefined('attributes.is_salary') and attributes.is_salary eq 1>
                <th><cf_get_lang dictionary_id='40071.Maaş'></th>
                <th><cf_get_lang dictionary_id='57489.Para Br'></th>
                <th><cf_get_lang dictionary_id='38990.Brüt'>/<cf_get_lang dictionary_id='58083.Net'></th>	
            </cfif>
            <cfif isdefined('attributes.is_salary_type') and attributes.is_salary_type eq 1>
                <th><cf_get_lang dictionary_id='38983.Ü Y'></th>
            </cfif>
            <cfif isdefined('attributes.in_comp_reason') and attributes.in_comp_reason eq 1> <!---20131108--->
                <th><cf_get_lang dictionary_id='38957.Şirket içi gerekçe'></th>
            </cfif>
            <cfif isdefined('attributes.fire_detail') and attributes.fire_detail eq 1>
                <th><cf_get_lang dictionary_id='38884.Çıkış Açıklaması'></th>
            </cfif>
             <!--- Yabancı Dil ---->
             <cfloop from="1" to="4" index="i"><cfif isdefined('attributes.is_language')><th><cf_get_lang dictionary_id='55216.Yabancı Dil'><cfoutput>#i#</cfoutput></th></cfif>
            <cfif isdefined('attributes.is_point')><th><cf_get_lang dictionary_id='41169.Dil Puanı'><cfoutput>#i#</cfoutput></th></cfif>
            <cfif isdefined('attributes.is_document')><th><cf_get_lang dictionary_id='55652.Belge Adı'><cfoutput>#i#</cfoutput></th></cfif>
            <cfif isdefined('attributes.is_document_date')><th><cf_get_lang dictionary_id='39422.Belge Tarihi'><cfoutput>#i#</cfoutput></th></cfif>
            <cfif isdefined('attributes.is_lang_where')><th><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'><cfoutput>#i#</cfoutput></th></cfif>
            <cfif isdefined('attributes.is_paper_finish_date')><th><cf_get_lang dictionary_id='53065.Geçerlilik Bitiş Tarihi'><cfoutput>#i#</cfoutput></th></cfif></cfloop>
                <!--- Eğitim ---->
            <cfif isdefined('attributes.is_edu_type') and attributes.is_edu_type eq 1><th><cf_get_lang dictionary_id ='39708.Eğitim Durumu'></th></cfif>
            <cfif isdefined('attributes.is_last_school') and attributes.is_last_school eq 1><th><cf_get_lang dictionary_id ='55725.En Son Bitirilen Okul'></th></cfif>
            <!---Lise--->
            <cfif isdefined('attributes.is_edu_name') and attributes.is_edu_name eq 1><th><cf_get_lang dictionary_id ='44283.Lise'></th></cfif>
            <cfif isdefined('attributes.is_part_name') and attributes.is_part_name eq 1><th><cf_get_lang dictionary_id="44283.Lise"><cf_get_lang dictionary_id ='57995.Bölüm'></th></cfif>
            <cfif isdefined('attributes.is_edu_lang') and attributes.is_edu_lang eq 1><th><cf_get_lang dictionary_id ='44283.Lise'><cf_get_lang dictionary_id ='41520.Öğrenim dili'></th></cfif>
            <cfif isdefined('attributes.is_edu_lang_rate') and attributes.is_edu_lang_rate eq 1><th><cf_get_lang dictionary_id ='44283.Lise'><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cf_get_lang dictionary_id ='58671.Oranı'></th></cfif>
            <cfif isdefined('attributes.is_edu_startdate')><th><cf_get_lang dictionary_id ='44283.Lise'><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th></cfif>
            <cfif isdefined('attributes.is_edu_finishdate')><th><cf_get_lang dictionary_id ='44283.Lise'><cf_get_lang dictionary_id='30695.Mezuniyet Tarihi'></th></cfif>
            <!---Lisans--->
            <cfloop from="1" to="3" index="i">
                <cfif isdefined('attributes.is_edu_name') and attributes.is_edu_name eq 1><th><cf_get_lang dictionary_id="42197.Lisans"><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_part_name') and attributes.is_part_name eq 1><th><cf_get_lang dictionary_id="42197.Lisans"><cf_get_lang dictionary_id ='57995.Bölüm'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_lang') and attributes.is_edu_lang eq 1><th><cf_get_lang dictionary_id="42197.Lisans"><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_lang_rate') and attributes.is_edu_lang_rate eq 1><th><cf_get_lang dictionary_id="42197.Lisans"><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cf_get_lang dictionary_id ='58671.Oranı'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_startdate')><th><cf_get_lang dictionary_id="42197.Lisans"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_finishdate')><th><cf_get_lang dictionary_id="42197.Lisans"><cf_get_lang dictionary_id='30695.Mezuniyet Tarihi'><cfoutput>#i#</cfoutput></th></cfif>
            </cfloop>
            <!---Y. Lisans--->
            <cfloop from="1" to="2" index="i"><cfif isdefined('attributes.is_edu_name') and attributes.is_edu_name eq 1><th><cf_get_lang dictionary_id="30483.Y.Lisans"><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_part_name') and attributes.is_part_name eq 1><th><cf_get_lang dictionary_id="30483.Y.Lisans"><cf_get_lang dictionary_id ='57995.Bölüm'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_lang') and attributes.is_edu_lang eq 1><th><cf_get_lang dictionary_id="30483.Y.Lisans"><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_lang_rate') and attributes.is_edu_lang_rate eq 1><th><cf_get_lang dictionary_id="30483.Y.Lisans"><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cf_get_lang dictionary_id ='58671.Oranı'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_startdate')><th><cf_get_lang dictionary_id="30483.Y.Lisans"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_finishdate')><th><cf_get_lang dictionary_id="30483.Y.Lisans"><cf_get_lang dictionary_id='30695.Mezuniyet Tarihi'><cfoutput>#i#</cfoutput></th></cfif>
            </cfloop>
            <!---Doktora--->
            <cfloop from="1" to="1" index="i"><cfif isdefined('attributes.is_edu_name') and attributes.is_edu_name eq 1><th><cf_get_lang dictionary_id="31293.Doktora"><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_part_name') and attributes.is_part_name eq 1><th><cf_get_lang dictionary_id="31293.Doktora"><cf_get_lang dictionary_id ='57995.Bölüm'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_lang') and attributes.is_edu_lang eq 1><th><cf_get_lang dictionary_id="31293.Doktora"><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_lang_rate') and attributes.is_edu_lang_rate eq 1><th><cf_get_lang dictionary_id="31293.Doktora"><cf_get_lang dictionary_id ='41520.Öğrenim dili'><cf_get_lang dictionary_id ='58671.Oranı'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_startdate')><th><cf_get_lang dictionary_id="31293.Doktora"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'><cfoutput>#i#</cfoutput></th></cfif>
                <cfif isdefined('attributes.is_edu_finishdate')><th><cf_get_lang dictionary_id="31293.Doktora"><cf_get_lang dictionary_id='30695.Mezuniyet Tarihi'><cfoutput>#i#</cfoutput></th></cfif>
            </cfloop>
            <cfif isDefined("attributes.special_position") and attributes.special_position eq 1>
                <th><cf_get_lang dictionary_id='60217.Disability Rate'></th>
            </cfif>
            <cfif isdefined('attributes.is_country_id') and len(attributes.is_country_id)><th><cf_get_lang dictionary_id ='56135.Uyruğu'></th></cfif>
            <cfif len(attributes.sureli_is_akdi)>
                <th><cf_get_lang dictionary_id='56428.Belirli Süreli İş Akdi'></th>
            </cfif>
        </tr>
        </thead>
        <cfset emp_id_list="">
        <tbody>
        <cfoutput query="get_employee" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfif isdefined("POSITION_ID") and len(POSITION_ID)>
                <cfset control_id = POSITION_ID>
            <cfelse>
                <cfset control_id = EMPLOYEE_ID>
            </cfif>
            <cfif not listfind(emp_id_list,control_id,',')>
                <cfset emp_id_list=listappend(emp_id_list,'#control_id#')>
                <cfquery name="get_employee_" dbtype="query">
                    SELECT DISTINCT EMPLOYEE_ID FROM get_employee
                </cfquery>  
                <cfset attributes.totalrecords = get_employee_.recordcount>
            <tr>
               <cfif isdefined("attributes.employee_photo")><td align="center"><img src="#PHOTO#" width="30" height="30" class="usersListLeft img-circle btnPointer"></td></cfif> 
                <td>#currentrow#</td>
                <td>#employee_no#</td>
                <td>#employee_name# #employee_surname#</td>
                <!--- organizasyon --->
                <cfif isdefined('attributes.is_company')><td>#nick_name#</td></cfif>
                <cfif isdefined('attributes.is_comp_branch')><td>#zone_name#</td></cfif>
                <cfif isdefined('attributes.is_branch')><td>#branch_name#</td></cfif>
                <cfif x_show_level_column eq 0>
                    <cfif isdefined('attributes.is_hierarchy_dep') and len(attributes.is_hierarchy_dep) and not isdefined('is_dep_level')>
                        <cfif up_dep_len gt 0>
                            <cfset temp = up_dep_len> <td>
                            <cfloop from="1" to="#up_dep_len#" index="i" step="1">
                                <cfif isdefined("get_employee.hierarchy_dep_id") and listlen(get_employee.hierarchy_dep_id,'.') gt temp>
                                    <cfset up_dep_id = ListGetAt(get_employee.hierarchy_dep_id, listlen(get_employee.hierarchy_dep_id,'.')-temp,".")>
                                    <cfquery name="get_upper_departments" datasource="#dsn#">
                                        SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
                                    </cfquery>
                                    <cfset up_dep_head = get_upper_departments.department_head>
                                    #up_dep_head# 
                                    <cfif x_show_level eq 1 and len(get_upper_departments.LEVEL_NO)>
                                        <cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
                                        <cfif get_org_level.recordcount>
                                            (#get_org_level.ORGANIZATION_STEP_NAME#)
                                        </cfif>
                                    </cfif>
                                    <cfif up_dep_len neq i>
                                        >
                                    </cfif>

                                <cfelse>
                                    <cfset up_dep_head = ''>
                                </cfif>
                                <cfset temp = temp - 1>
                            </cfloop></td>
                        </cfif>
                        <cfif isdefined("get_employee.hierarchy_dep_id") and listlen(get_employee.hierarchy_dep_id,'.') gt 1>
                            <cfset up_dep=ListGetAt(get_employee.hierarchy_dep_id,evaluate("#listlen(get_employee.hierarchy_dep_id,".")#-1"),".") >	
                            <cfquery name="get_upper_departments" datasource="#dsn#">
                                SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep#">
                            </cfquery>
                            <cfset up_dep_name="#get_upper_departments.department_head#">
                        <cfelse>
                            <cfset up_dep="">
                            <cfset up_dep_name="">	
                        </cfif>
                    <cfelseif isdefined('attributes.is_hierarchy_dep') and isdefined('is_dep_level')>
                        <cfif isdefined("get_employee.hierarchy_dep_id") and listlen(get_employee.hierarchy_dep_id,'.') gt 1>
                            <cfquery name="get_upper_departments" datasource="#dsn#">
                                SELECT
                                    DEPARTMENT.DEPARTMENT_HEAD, 
                                    CASE WHEN DEPARTMENT_HISTORY.DEPARTMENT_ID IS NOT NULL
                                    THEN DEPARTMENT_HISTORY.LEVEL_NO
                                    ELSE DEPARTMENT.LEVEL_NO
                                    END AS LEVEL_NO
                                FROM 
                                    DEPARTMENT
                                    LEFT JOIN DEPARTMENT_HISTORY ON DEPARTMENT.DEPARTMENT_ID = DEPARTMENT_HISTORY.DEPARTMENT_ID AND DEPT_HIST_ID = (SELECT TOP 1 DEPT_HIST_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND <cfif len(attributes.finishdate) or len(attributes.startdate)>DEPARTMENT_HISTORY.CHANGE_DATE IS NOT NULL <cfif len(attributes.finishdate)>AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"><cfelseif len(attributes.startdate)>AND CHANGE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"></cfif><cfelse>1=0</cfif> ORDER BY CHANGE_DATE DESC)
                                WHERE 
                                    DEPARTMENT.DEPARTMENT_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#replace(get_employee.hierarchy_dep_id,'.',',','all')#">)
                            </cfquery>
                        </cfif>  
                        <td>
                            <cfloop query="get_dep_lvl">
                                <cfif listlen(get_employee.hierarchy_dep_id,".") gt 1>
                                    <cfquery name="get_dep_head" dbtype="query">
                                        SELECT DEPARTMENT_HEAD,LEVEL_NO FROM get_upper_departments WHERE LEVEL_NO = #get_dep_lvl.level_no#
                                    </cfquery>
                                    <cfif get_dep_head.recordcount>
                                        #get_dep_head.department_head# 
                                        <cfif get_dep_lvl.recordcount neq currentrow>  > </cfif>
                                        <cfif x_show_level eq 1 and len(get_upper_departments.LEVEL_NO)>
                                            <cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
                                            <cfif get_org_level.recordcount>
                                                (#get_org_level.ORGANIZATION_STEP_NAME#)
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelse>
                                    <cfif get_dep_lvl.level_no eq get_employee.level_no>#get_employee.department_head# > <cfelse>-</cfif>
                                </cfif>
                            </cfloop>
                        </td>
                    </cfif>
                <cfelse>
                    <cfif isdefined('attributes.is_hierarchy_dep') and len(attributes.is_hierarchy_dep) and not isdefined('is_dep_level')>
                        <cfif up_dep_len gt 0>
                            <cfset temp = up_dep_len>
                            <cfloop from="1" to="#up_dep_len#" index="i" step="1">
                                <cfif isdefined("get_employee.hierarchy_dep_id") and listlen(get_employee.hierarchy_dep_id,'.') gt temp>
                                    <cfset up_dep_id = ListGetAt(get_employee.hierarchy_dep_id, listlen(get_employee.hierarchy_dep_id,'.')-temp,".")>
                                    <cfquery name="get_upper_departments" datasource="#dsn#">
                                        SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
                                    </cfquery>
                                    <cfset up_dep_head = get_upper_departments.department_head>
                                <cfelse>
                                    <cfset up_dep_head = ''>
                                </cfif>
                                <td>#up_dep_head#</td>
                                <cfset temp = temp - 1>
                            </cfloop>
                        </cfif>
                        <cfif isdefined("get_employee.hierarchy_dep_id") and listlen(get_employee.hierarchy_dep_id,'.') gt 1>
                            <cfset up_dep=ListGetAt(get_employee.hierarchy_dep_id,evaluate("#listlen(get_employee.hierarchy_dep_id,".")#-1"),".") >	
                            <cfquery name="get_upper_departments" datasource="#dsn#">
                                SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep#">
                            </cfquery>
                            <cfset up_dep_name="#get_upper_departments.department_head#">
                        <cfelse>
                            <cfset up_dep="">
                            <cfset up_dep_name="">	
                        </cfif>
                    <cfelseif isdefined('attributes.is_hierarchy_dep') and isdefined('is_dep_level')>
                        <cfif isdefined("get_employee.hierarchy_dep_id") and listlen(get_employee.hierarchy_dep_id,'.') gt 1>
                            <cfquery name="get_upper_departments" datasource="#dsn#">
                                SELECT
                                    DEPARTMENT.DEPARTMENT_HEAD, 
                                    CASE WHEN DEPARTMENT_HISTORY.DEPARTMENT_ID IS NOT NULL
                                    THEN DEPARTMENT_HISTORY.LEVEL_NO
                                    ELSE DEPARTMENT.LEVEL_NO
                                    END AS LEVEL_NO
                                FROM 
                                    DEPARTMENT
                                    LEFT JOIN DEPARTMENT_HISTORY ON DEPARTMENT.DEPARTMENT_ID = DEPARTMENT_HISTORY.DEPARTMENT_ID AND DEPT_HIST_ID = (SELECT TOP 1 DEPT_HIST_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND <cfif len(attributes.finishdate) or len(attributes.startdate)>DEPARTMENT_HISTORY.CHANGE_DATE IS NOT NULL <cfif len(attributes.finishdate)>AND CHANGE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"><cfelseif len(attributes.startdate)>AND CHANGE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"></cfif><cfelse>1=0</cfif> ORDER BY CHANGE_DATE DESC)
                                WHERE 
                                    DEPARTMENT.DEPARTMENT_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#replace(get_employee.hierarchy_dep_id,'.',',','all')#">)
                            </cfquery>
                        </cfif>
                        <cfloop query="get_dep_lvl">
                            <td>
                                <cfif listlen(get_employee.hierarchy_dep_id,".") gt 1>
                                    <cfquery name="get_dep_head" dbtype="query">
                                        SELECT DEPARTMENT_HEAD FROM get_upper_departments WHERE LEVEL_NO = #get_dep_lvl.level_no#
                                    </cfquery>
                                    <cfif get_dep_head.recordcount>
                                        #get_dep_head.department_head#
                                    <cfelse>
                                        -
                                    </cfif>
                                <cfelse>
                                    <cfif get_dep_lvl.level_no eq get_employee.level_no>#get_employee.department_head#<cfelse>-</cfif>
                                </cfif>
                            </td>
                        </cfloop>
                    </cfif>
                </cfif>
                <cfif isdefined('attributes.is_department')>
					<td>#department_head#</td>
				</cfif>  
                <cfif isdefined('attributes.is_special_code') and len(attributes.is_special_code)>
					<td>#special_code#</td>
				</cfif>
                <!--- planlama --->
                <cfif isdefined('attributes.is_position_name')>
                    <td>#position_name#</td>
                </cfif>
                <cfif isdefined('attributes.is_poscat')>
                    <td>#position_cat#</td>
                </cfif>
                <cfif isdefined('attributes.is_title')>
                    <td><cfif isdefined('title1')>#title1#<cfelseif isdefined('title')>#title#</cfif></td>
                </cfif>
                <cfif isdefined('attributes.is_organization_step')>
                    <td>
                    	#organization_step_name#
                       <!--- #get_organization_step.organization_step_name[listfind(organization_step_list,employee_id,',')]#--->
                     </td>
                </cfif>
                <cfif isdefined('attributes.is_function')>
                    <td>#unit_name#</td>
                </cfif>
                <cfif isdefined('attributes.is_collar_type')>
                    <td><cfif collar_type eq 1><cf_get_lang dictionary_id='38910.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang dictionary_id='38911.Beyaz Yaka'></cfif></td>
                </cfif>
                <cfif isdefined('attributes.is_idariamir')>
                    <td>#idariamir#</td>
                </cfif>
                <cfif isdefined('attributes.is_fonkamir')>
                    <td>#fonksiyonamir#</td>
                </cfif>
                <cfif isdefined('attributes.is_group')>
                    <cfif isdefined('get_employee.PUANTAJ_GROUP_IDS') and len(get_employee.PUANTAJ_GROUP_IDS)>
                        <cfquery name="get_employee_group" datasource="#dsn#">
                            SELECT GROUP_NAME FROM EMPLOYEES_PUANTAJ_GROUP WHERE GROUP_ID IN (#get_employee.PUANTAJ_GROUP_IDS#)
                        </cfquery>
                        <cfset calisan_grubu = ValueList(get_employee_group.GROUP_NAME)>
                        <td>#calisan_grubu#</td>
                    <cfelse>
                        <td></td>
                    </cfif>
                </cfif>
                <cfif isdefined('attributes.is_org_position')>
                    <cfloop query="get_organization_steps">
                        <td>
                            <cfif isdefined("upper_emp_#get_employee.position_code#_#organization_step_id#")>
                                #evaluate("upper_emp_#get_employee.position_code#_#organization_step_id#")#
                            </cfif>
                        </td>
                    </cfloop>
                </cfif>
                <!--- profil --->
                 <cfif isdefined('attributes.is_last_surname') and len(attributes.is_last_surname)><td><cfif len(last_surname)>#last_surname#</cfif></td></cfif>
                 <cfif isdefined('attributes.military_status') and len(attributes.military_status)>
                    <td>
                        <cfif len(military_status)>
                            <cfif military_status eq 0>    
                                <cf_get_lang dictionary_id='31210.Yapmadı'> 
                            <cfelseif military_status eq 1> 
                                <cf_get_lang dictionary_id='31211.Yaptı'> 
                            <cfelseif military_status eq 2>  
                                <cf_get_lang dictionary_id='53401.Muaf'>
                            <cfelseif military_status eq 3> 
                                <cf_get_lang dictionary_id='31213.Yabancı'>
                            <cfelseif military_status eq 4> 
                                <cf_get_lang dictionary_id='31214.Tecilli'>
                            </cfif>
                        </cfif>
                    </td>
                </cfif>
                <cfif isdefined('attributes.is_father_and_mother') and attributes.is_father_and_mother eq 1>
                    <td><cfif len(mother)>#mother#</cfif> <cfif len(father)>- #father#</cfif></td>
                </cfif>
                <cfif isdefined('attributes.is_birthdate') and len(attributes.is_birthdate)><td format="date">#dateformat(birth_date,dateformat_style)#</td></cfif>
                <cfif isdefined('attributes.is_birthplace') and len(attributes.is_birthplace)><td>#birth_place#</td></cfif>
                <cfif isdefined('attributes.is_age') and len(attributes.is_age)><td><cfif len(birth_date)>#dateDiff("yyyy",birth_date,now())#</cfif></td></cfif>
                <cfif isdefined('attributes.is_identy') and len(attributes.is_identy)> <td format="numericextra"><cfif attributes.is_excel eq 1> <cf_duxi name='identity_no'  type="label" value="#tc_identy_no#"gdpr="2"   > <cfelse> <cf_duxi name='identity_no'  type="label" value="#tc_identy_no#"gdpr="2"   ></cfif></td></cfif>
                <cfif isdefined('attributes.is_cinsiyet') and len(attributes.is_cinsiyet)><td><cfif sex eq 1><cf_get_lang dictionary_id='58959.Erkek'><cfelse><cf_get_lang dictionary_id='58958.Kadın'></cfif></td></cfif>
                <cfif isdefined('attributes.is_married') and len(attributes.is_married)><td><cfif married eq 1><cf_get_lang dictionary_id='38916.Evli'><cfelse><cf_get_lang dictionary_id='38915.Bekar'></cfif></td></cfif>
                <cfif isdefined('attributes.is_blood') and len(attributes.is_blood)>
                    <td><cfswitch expression="#blood_type#">
                            <cfcase value="0">0 Rh+</cfcase>
                            <cfcase value="1">0 Rh-</cfcase>
                            <cfcase value="2">A Rh+</cfcase>
                            <cfcase value="3">A Rh-</cfcase>
                            <cfcase value="4">B Rh+</cfcase>
                            <cfcase value="5">B Rh-</cfcase>
                            <cfcase value="6">AB Rh+</cfcase>
                            <cfcase value="7">AB Rh-</cfcase>
                        </cfswitch>
                    </td>
                </cfif>
                <cfif isdefined('attributes.is_address')><td><cf_duxi name='address'  type="label" value="#address#" gdpr="1"   ></td></cfif>
                <cfif isdefined('attributes.is_address')><td><cfif len(county)><cf_duxi name='county_name'  type="label" value="#county_name#" gdpr="1"   ></cfif></td></cfif>
                <cfif isdefined('attributes.is_address')><td><cfif len(city)><cf_duxi name='city_name'  type="label" value="#city_name#" gdpr="1"   ></cfif></td></cfif>
                <cfif isdefined('attributes.is_mail') and len(attributes.is_mail)><td>#employee_email#</td></cfif>
                <cfif isdefined('attributes.is_mobiltel') and len(attributes.is_mobiltel)><td><cfif len(mobilcode) and len(mobiltel)>#mobilcode# <cf_duxi name='mobiltel'  type="label" value="#mobiltel#" gdpr="1"   ></cfif></td></cfif>
                <cfif isdefined('attributes.is_mobiltel_spc') and len(attributes.is_mobiltel_spc)><td><cfif len(mobilcode_spc) and len(mobiltel_spc)>#mobilcode_spc# <cf_duxi name='mobiltel_spc'  type="label" value="#mobiltel_spc#" gdpr="1"   ></cfif></td></cfif>
                <cfif isdefined('attributes.is_hometel') and len(attributes.is_hometel)><td><cfif len(hometel_code) and len(hometel)>#hometel_code# #hometel#</cfif></td></cfif>
                <cfif isdefined('attributes.is_bank_no') and attributes.is_bank_no eq 1>
                  <!---  <td>#get_account_no.bank_name[listfind(bank_account_list,employee_id,',')]#</td>
                    <td>#get_account_no.bank_branch_name[listfind(bank_account_list,employee_id,',')]#</td>
                    <td>#get_account_no.bank_branch_code[listfind(bank_account_list,employee_id,',')]#</td>
                    <td>#get_account_no.bank_account_no[listfind(bank_account_list,employee_id,',')]#</td>
                    <td>#get_account_no.iban_no[listfind(bank_account_list,employee_id,',')]#</td>--->
                    <td>#bank_name#</td>
                    <td>#bank_branch_name#</td>
                    <td format="numeric">#bank_branch_code#</td>
                    <td format="numeric">#bank_account_no#</td>
                    <td>#iban_no#</td>
                </cfif>
                <cfif isdefined('attributes.is_groupstart') and len(attributes.is_groupstart)><td format="date">#dateformat(group_startdate,dateformat_style)#</td></cfif>
                <cfif isdefined('attributes.is_kidem') and len(attributes.is_kidem)><td format="date">#dateformat(kidem_date,dateformat_style)#</td></cfif>
                <cfif isdefined('attributes.is_kidem_') and len(attributes.is_kidem_)><td format="date">#dateformat(kidem_startdate,dateformat_style)#</td></cfif>
				<cfif isdefined('attributes.is_kidem_bilgisi') and len(attributes.is_kidem_bilgisi)>
                	<cfif len(kidem_date)>
						<cfif isdefined('finish_date') and len(finish_date)>
                            <cfset kidem_gun = datediff("d",kidem_date,finish_date)>
                        <cfelse>
                            <cfset kidem_gun = datediff('d',kidem_date,now())>
                        </cfif>
                        <cfif kidem_gun gte 365>
                            <cfset kidem_yil = kidem_gun \ 365>
                        <cfelse>
                            <cfset kidem_yil = 0>
                        </cfif>
                        <cfset kidem_gun = kidem_gun - (kidem_yil * 365)>
                        <cfif kidem_gun gte 30>
                            <cfset kidem_ay = kidem_gun \ 30>
                        <cfelse>
                            <cfset kidem_ay = 0>
                        </cfif>
                        <cfset kidem_gun = kidem_gun - (kidem_ay * 30)>
                    </cfif>
                    <td><cfif isdefined('kidem_yil') and kidem_yil gt 0>#kidem_yil# yıl </cfif><cfif isdefined('kidem_ay') and kidem_ay gt 0>#kidem_ay# ay </cfif><cfif isdefined('kidem_gun') and kidem_gun gt 0>#kidem_gun# gün</cfif></td>
				</cfif>
                <cfif isdefined('attributes.old_sgk_days') and len(attributes.old_sgk_days)>
                    <td>
                        <cfif len(old_sgk_days) and old_sgk_days gte 365>
                            <cfset old_sgk_year = old_sgk_days \ 365>
                        <cfelse>
                            <cfset old_sgk_year = 0>
                        </cfif>
                        <cfif len(old_sgk_days)>
                            <cfset old_sgk_days_ = old_sgk_days - (old_sgk_year * 365)>
                            <cfif old_sgk_days_ gte 30>
                                <cfset old_sgk_month = old_sgk_days_ \ 30>
                            <cfelse>
                                <cfset old_sgk_month = 0>
                            </cfif>
                            <cfset old_sgk_days_ = old_sgk_days_ - (old_sgk_month * 30)>
                        <cfelse>
                            <cfset old_sgk_days_ = 0>
                        </cfif>
                        <cfif isdefined('old_sgk_year') and old_sgk_year gt 0>#old_sgk_year# yıl </cfif><cfif isdefined('old_sgk_month') and old_sgk_month gt 0>#old_sgk_month# ay </cfif><cfif isdefined('old_sgk_days_') and old_sgk_days_ gt 0>#old_sgk_days_# gün</cfif>
                        <!---#old_sgk_days_#------->
                    </td>
                </cfif>
				<cfif isdefined('attributes.is_izin') and len(attributes.is_izin)><td format="date">#dateformat(izin_date,dateformat_style)#</td></cfif>
                <cfif isdefined("attributes.add_info") and len(attributes.add_info)>
                    <cfquery name="GET_INFO_PLUS_ROW" datasource="#dsn#">
                        SELECT 
                            * 
                        FROM 
                            INFO_PLUS 
                        WHERE 
                            INFO_OWNER_TYPE = -4 AND
                            OWNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee.employee_id#">
                    </cfquery>
                    <cfloop list="#attributes.add_info#" index="kk">
                        <td>#evaluate("get_info_plus_row.property#kk#")#</td>
                    </cfloop>
                </cfif>
                <cfif isdefined('attributes.is_hierarchy') and len(attributes.is_hierarchy)>
					<td>#hierarchy#</td>
					<td>#ozel_kod#</td>
                    <td>#ozel_kod2#</td>
				</cfif>
                <cfif isdefined('attributes.is_grade_step') and len(attributes.is_grade_step)><td style="mso-number-format:\@;"><cfif len(grade) or len(step)>#grade#-#step#</cfif></td></cfif>
                <cfif isdefined("attributes.is_identity_info") and len(attributes.is_identity_info)>
                    <td>#series#<cfif len(number)>/#number#</cfif></td>
                    <td>#identy_city#</td>
                    <td>#identy_county#</td>
                    <td>#ward#</td>
                    <td>#village#</td>
                    <td format="numeric">#binding#</td>
                    <td format="numeric">#family#</td>
                    <td format="numeric">#cue#</td>
                    <td>#given_place#</td>
                    <td>#given_reason#</td>
                    <td format="numeric">#record_number#</td>
                    <td format="date">#dateformat(given_date,dateformat_style)#</td>
                </cfif>
                <!--- ücret --->
                <cfif isdefined('attributes.is_pdks')>
                    <td>#pdks_number#</td>
                    <td>
                        <cfif len(use_pdks) and use_pdks eq 0><cf_get_lang dictionary_id='39014.Bağlı'> <cf_get_lang dictionary_id='39011.Değil'>
                        <cfelseif len(use_pdks) and use_pdks eq 1><cf_get_lang dictionary_id='39014.Bağlı'>
                        <cfelseif len(use_pdks) and use_pdks eq 2><cf_get_lang dictionary_id='38799.Tam'> <cf_get_lang dictionary_id='39014.Bağlı'> <cf_get_lang dictionary_id='57491.Saat'>
                        <cfelseif len(use_pdks) and use_pdks eq 3><cf_get_lang dictionary_id='38799.Tam'> <cf_get_lang dictionary_id='39014.Bağlı'> <cf_get_lang dictionary_id='57490.Gün'>
                        <cfelseif len(use_pdks) and use_pdks eq 4><cf_get_lang dictionary_id='38806.Vardiya Sistemi'>
                        </cfif>
                    </td>
                    <td>
                        <cfif len(pdks_type_id) and pdks_type_id eq 1><cf_get_lang dictionary_id='58009.PDKS'> <cf_get_lang dictionary_id='38801.Kullananlar'>
                        <cfelseif len(pdks_type_id) and pdks_type_id eq 2><cf_get_lang dictionary_id='58009.PDKS'> <cf_get_lang dictionary_id='38804.Kullanmayanlar'>
                        </cfif>
                    </td>
                </cfif>
                <cfif isdefined('attributes.is_accounting_accounts')>
                    <td>#account_bill_type#</td>
                    <cfloop query="get_acc_types">
                        <td>
                            <cfquery name="get_emp_accounts_" dbtype="query">
                                SELECT ACCOUNT_CODE,ACC_TYPE_ID FROM get_emp_accounts WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee.employee_id#"> AND ACC_TYPE_ID = #get_acc_types.ACC_TYPE_ID#
                            </cfquery>
                            <cfif get_emp_accounts.recordcount>#get_emp_accounts_.account_code#</cfif>
                        </td>
                    </cfloop>
                </cfif>
                <cfif isdefined('attributes.is_first_ssk')><td format="date">#dateformat(first_ssk_date,dateformat_style)#</td></cfif>
                <cfif isdefined('attributes.is_start_date')><td format="date">#dateformat(start_date,dateformat_style)#</td></cfif>
                <cfif isdefined('attributes.is_finish_date')><td format="date">#dateformat(finish_date,dateformat_style)#</td></cfif>
                <cfif isdefined('attributes.is_account_code') and attributes.is_account_code eq 1><td>#expense_code#</td></cfif>
                <cfif isdefined('attributes.is_expense') and attributes.is_expense eq 1><td><cfif len(expense_center_id)>#expense#<cfelse></cfif></td></cfif>
                <cfif isdefined('attributes.is_reason')>
                    <td>
                        <cfif len(ex_in_out_id)><cf_get_lang dictionary_id="40516.Nakil"><cfelse><cf_get_lang dictionary_id="58674.Yeni"> <cf_get_lang dictionary_id="57554.Giriş"></cfif>
                    </td>
                </cfif>
                <cfif isdefined('attributes.is_reason_out')>
                    <td>
                        <cfif Gerekce gt 0>
                            <cfloop list="#reason_order_list()#" index="ccc">
                            	<cfset value_name_ = listgetat(reason_list(),ccc,';')>
                                <cfset value_id_ = ccc>
                                <cfif Gerekce eq value_id_>#value_name_#</cfif>
                            </cfloop>
                        </cfif>
                    </td>
                </cfif>
                <cfif isdefined('attributes.is_duty_type')>
                    <td>
                         <cfif duty_type eq 2><cf_get_lang dictionary_id='57576.Çalışan'>
                         <cfelseif duty_type eq 1><cf_get_lang dictionary_id='38967.İşveren Vekili'>
                         <cfelseif duty_type eq 0><cf_get_lang dictionary_id='38968.İşveren'>
                         <cfelseif duty_type eq 3><cf_get_lang dictionary_id='39111.Sendikalı'>
                         <cfelseif duty_type eq 4><cf_get_lang dictionary_id='39113.Sözleşmeli'>
                         <cfelseif duty_type eq 5><cf_get_lang dictionary_id='39146.Kapsam dışı'>
                         <cfelseif duty_type eq 6><cf_get_lang dictionary_id='39152.Kısmi İstihdam'>
                         <cfelseif duty_type eq 7><cf_get_lang dictionary_id='39156.Taşeron'>
                         <cfelseif duty_type eq 8><cf_get_lang dictionary_id='34749.Derece-Kademe'>
                         </cfif>
                    </td>
                </cfif>
                <cfif isdefined('attributes.is_business_code')>
                    <td>#business_code#</td>
                    <td>#business_code_name#</td>
                </cfif>
                <cfif isdefined('attributes.is_salary_plan') and attributes.is_salary_plan eq 1>
                    <td format="numeric">
                        <cf_duxi name='salary_plan'  type="label" value="#tlformat(gr_maas)#" gdpr="7">
                    </td>
                    <td>#MONEY1#</td>
                </cfif>
                <cfif isdefined('attributes.is_salary') and attributes.is_salary eq 1>
                    <td format="numeric">
                    	<cfif duty_type eq 8><!---görev tipi derece/kademe --->
                    		<cfif len(extra)><cfset extra_ = extra><cfelse><cfset extra_ = 0></cfif>
                    		<cfif len(grade_value)><cfset grade_value_ = grade_value><cfelse><cfset grade_value_ = 0></cfif>
                                <cf_duxi name='salary'  type="label" value="#tlformat((extra_+grade_value_)*salary_factor)#" gdpr="7">
                        <cfelse>
							    <cf_duxi name='salary'  type="label" value="#tlformat(ay_adi)#" gdpr="7">
                    	</cfif>
                    </td>
                    <td>#money#</td>
                    <td><cfif get_employee.gross_net eq 1><cf_get_lang dictionary_id='58083.Net'><cfelse><cf_get_lang dictionary_id='38990.Brüt'></cfif></td>
                </cfif>
                <cfif isdefined('attributes.is_salary_type') and attributes.is_salary_type eq 1>
                    <td><cfif get_employee.salary_type eq 0><cf_get_lang dictionary_id='57491.Saat'><cfelseif get_employee.salary_type eq 1><cf_get_lang dictionary_id='57490.Gün'><cfelse><cf_get_lang dictionary_id='58724.Ay'></cfif></td>
                </cfif>
                <cfif isdefined('attributes.in_comp_reason') and attributes.in_comp_reason eq 1>
                    <td>#reason#</td>
                </cfif>
                <cfif isdefined('attributes.fire_detail') and attributes.fire_detail eq 1>
                    <td><div !important;>#detail#</div></td>
                </cfif>
                 <!---Yabancı Dil---->
                 <cfquery name="lang_emp" datasource="#dsn#">
                    SELECT TOP 4 LANGUAGE_SET,LANG_POINT,DOCUMENT_NAME,PAPER_DATE,PAPER_FINISH_DATE,LANG_WHERE,PAPER_NAME
                    FROM EMPLOYEES_APP_LANGUAGE EA 
                    LEFT JOIN SETUP_LANGUAGES S ON S.LANGUAGE_ID = EA.LANG_ID 
                    LEFT JOIN SETUP_LANGUAGES_DOCUMENTS SD ON SD.DOCUMENT_ID = EA.LANG_PAPER_NAME
                WHERE EMPLOYEE_ID = #employee_id#
            </cfquery>
            <cfif lang_emp.recordcount>
                <cfloop query="lang_emp">
                    <cfif isdefined('attributes.is_language')><td>#LANGUAGE_SET#</td></cfif>
                    <cfif isdefined('attributes.is_point')><td>#lang_point#</td></cfif>
                    <cfif isdefined('attributes.is_document') and isdefined('x_document_name') and x_document_name eq 1><td>#document_name#</td><cfelseif isdefined('attributes.is_document')><td>#paper_name#</td></cfif>
                    <cfif isdefined('attributes.is_document_date')><td>#dateformat(paper_date,dateformat_style)#</td></cfif>
                    <cfif isdefined('attributes.is_lang_where')><td>#lang_where#</td></cfif>
                    <cfif isdefined('attributes.is_paper_finish_date')><td>#dateformat(paper_finish_date,dateformat_style)#</td></cfif>
                </cfloop> 
                <cfset x = 4 - lang_emp.recordcount>
                <cfif x gt 0 and x lt 4>
                     <cfloop from= "1" to="#x#" index="i">
                         <cfif isdefined('attributes.is_language')><td></td></cfif>
                         <cfif isdefined('attributes.is_point')><td></td></cfif>
                         <cfif isdefined('attributes.is_document')><td></td></cfif>
                         <cfif isdefined('attributes.is_document_date')><td></td></cfif>
                         <cfif isdefined('attributes.is_lang_where')><td></td></cfif>
                         <cfif isdefined('attributes.is_paper_finish_date')><td></td></cfif>
                     </cfloop>
                </cfif>
            <cfelse>
                <cfloop from="1" to="4" index="i">
                    <cfif isdefined('attributes.is_language')><td></td></cfif>
                    <cfif isdefined('attributes.is_point')><td></td></cfif>
                    <cfif isdefined('attributes.is_document')><td></td></cfif>
                    <cfif isdefined('attributes.is_document_date')><td></td></cfif>
                    <cfif isdefined('attributes.is_lang_where')><td></td></cfif>
                    <cfif isdefined('attributes.is_paper_finish_date')><td></td></cfif>
                </cfloop>
            </cfif>
             <!---eğitim---->
                <!---Lise--->
                <cfquery name="edu_info_emp_0" datasource="#dsn#">
                    SELECT TOP 1 EDUCATION_NAME,EAE.EDU_TYPE, EDU_NAME,EDU_PART_NAME,EDUCATION_LANG,EDU_LANG_RATE,EDU_START,EDU_FINISH
                    FROM EMPLOYEES_APP_EDU_INFO EAE LEFT JOIN SETUP_EDUCATION_LEVEL S ON S.EDU_LEVEL_ID = EAE.EDU_TYPE
                    WHERE EMPLOYEE_ID = #employee_id# AND S.EDU_TYPE = 1
                </cfquery>
                <!---Lisans--->
                <cfquery name="edu_info_emp_2" datasource="#dsn#">
                    SELECT TOP 3 EDUCATION_NAME,EAE.EDU_TYPE, EDU_NAME,EDU_PART_NAME,EDUCATION_LANG,EDU_LANG_RATE,EDU_START,EDU_FINISH
                    FROM EMPLOYEES_APP_EDU_INFO EAE LEFT JOIN SETUP_EDUCATION_LEVEL S ON S.EDU_LEVEL_ID = EAE.EDU_TYPE
                    WHERE EMPLOYEE_ID = #employee_id# AND S.EDU_TYPE = 2
                </cfquery>
                <!---Y.Lisans--->
                <cfquery name="edu_info_emp_3" datasource="#dsn#">
                    SELECT TOP 2 EDUCATION_NAME,EAE.EDU_TYPE, EDU_NAME,EDU_PART_NAME,EDUCATION_LANG,EDU_LANG_RATE,EDU_START,EDU_FINISH
                    FROM EMPLOYEES_APP_EDU_INFO EAE LEFT JOIN SETUP_EDUCATION_LEVEL S ON S.EDU_LEVEL_ID = EAE.EDU_TYPE
                    WHERE EMPLOYEE_ID = #employee_id# AND S.EDU_TYPE = 3
                </cfquery>
                 <!---Doktora--->
                <cfquery name="edu_info_emp_4" datasource="#dsn#">
                    SELECT TOP 1 EDUCATION_NAME,EAE.EDU_TYPE, EDU_NAME,EDU_PART_NAME,EDUCATION_LANG,EDU_LANG_RATE,EDU_START,EDU_FINISH
                    FROM EMPLOYEES_APP_EDU_INFO EAE LEFT JOIN SETUP_EDUCATION_LEVEL S ON S.EDU_LEVEL_ID = EAE.EDU_TYPE
                    WHERE EMPLOYEE_ID = #employee_id# AND S.EDU_TYPE = 4
                </cfquery>
                <cfif isdefined('attributes.is_edu_type') and len(attributes.is_edu_type)><td>#EDU_NAME_#</td></cfif>
                <cfif isdefined('attributes.is_last_school') and len(attributes.is_last_school)><td>#last_school_#</td></cfif>
                <cfif edu_info_emp_0.recordcount> 
                    <cfset y = 1 - edu_info_emp_0.recordcount>
                    <cfloop query="edu_info_emp_0">
                        <cfif isdefined('attributes.is_edu_name') and len(attributes.is_edu_name)><td>#EDU_NAME#</td></cfif>
                        <cfif isdefined('attributes.is_part_name') and len(attributes.is_part_name)><td>#edu_part_name#</td></cfif>
                        <cfif isdefined('attributes.is_edu_lang') and len(attributes.is_edu_lang)><td>#education_lang#</td></cfif> 
                        <cfif isdefined('attributes.is_edu_lang_rate') and len(attributes.is_edu_lang_rate)><td>#edu_lang_rate#</td></cfif>
                        <cfif isdefined('attributes.is_edu_startdate') and len(attributes.is_edu_startdate)><td>#dateformat(edu_start,dateformat_style)#</td></cfif>
                        <cfif isdefined('attributes.is_edu_finishdate') and len(attributes.is_edu_finishdate)><td>#dateformat(edu_finish,dateformat_style)#</td></cfif>
                    </cfloop>
                    <cfif y gt 0 and y lt 1>
                        <cfloop from= "1" to="#y#" index="i">
                            <cfif isdefined('attributes.is_edu_name')><td></td></cfif>
                            <cfif isdefined('attributes.is_part_name')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_lang')><td></td></cfif> 
                            <cfif isdefined('attributes.is_edu_lang_rate')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_startdate')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_finishdate')><td></td></cfif>
                        </cfloop>
                    </cfif>
                <cfelse>
                    <cfloop from="1" to="1" index="i">
                        <cfif isdefined('attributes.is_edu_name') and len(attributes.is_edu_name)><td></td></cfif>
                        <cfif isdefined('attributes.is_part_name') and len(attributes.is_part_name)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_lang') and len(attributes.is_edu_lang)><td></td></cfif> 
                        <cfif isdefined('attributes.is_edu_lang_rate') and len(attributes.is_edu_lang_rate)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_startdate') and len(attributes.is_edu_startdate)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_finishdate') and len(attributes.is_edu_finishdate)><td></td></cfif>
                    </cfloop>
                </cfif>
                <cfif edu_info_emp_2.recordcount> 
                    <cfset y = 3 - edu_info_emp_2.recordcount>
                    <cfloop query="edu_info_emp_2"> <cfif isdefined('attributes.is_edu_name') and len(attributes.is_edu_name)><td>#EDU_NAME#</td></cfif>
                        <cfif isdefined('attributes.is_part_name') and len(attributes.is_part_name)><td>#edu_part_name#</td></cfif>
                        <cfif isdefined('attributes.is_edu_lang') and len(attributes.is_edu_lang)><td>#education_lang#</td></cfif> 
                        <cfif isdefined('attributes.is_edu_lang_rate') and len(attributes.is_edu_lang_rate)><td>#edu_lang_rate#</td></cfif>
                        <cfif isdefined('attributes.is_edu_startdate') and len(attributes.is_edu_startdate)><td>#dateformat(edu_start,dateformat_style)#</td></cfif>
                        <cfif isdefined('attributes.is_edu_finishdate') and len(attributes.is_edu_finishdate)><td>#dateformat(edu_finish,dateformat_style)#</td></cfif>
                    </cfloop>
                    <cfif y gt 0 and y lt 3>
                        <cfloop from= "1" to="#y#" index="i">
                            <cfif isdefined('attributes.is_edu_name')><td></td></cfif>
                            <cfif isdefined('attributes.is_part_name')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_lang')><td></td></cfif> 
                            <cfif isdefined('attributes.is_edu_lang_rate')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_startdate')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_finishdate')><td></td></cfif>
                        </cfloop>
                    </cfif>
                <cfelse>
                    <cfloop from="1" to="3" index="i">
                        <cfif isdefined('attributes.is_edu_name') and len(attributes.is_edu_name)><td></td></cfif>
                        <cfif isdefined('attributes.is_part_name') and len(attributes.is_part_name)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_lang') and len(attributes.is_edu_lang)><td></td></cfif> 
                        <cfif isdefined('attributes.is_edu_lang_rate') and len(attributes.is_edu_lang_rate)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_startdate') and len(attributes.is_edu_startdate)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_finishdate') and len(attributes.is_edu_finishdate)><td></td></cfif>
                    </cfloop>
                </cfif>
                <cfif edu_info_emp_3.recordcount> 
                    <cfset y = 2 - edu_info_emp_3.recordcount>
                    <cfloop query="edu_info_emp_3"> <cfif isdefined('attributes.is_edu_name') and len(attributes.is_edu_name)><td>#EDU_NAME#</td></cfif>
                        <cfif isdefined('attributes.is_part_name') and len(attributes.is_part_name)><td>#edu_part_name#</td></cfif>
                        <cfif isdefined('attributes.is_edu_lang') and len(attributes.is_edu_lang)><td>#education_lang#</td></cfif> 
                        <cfif isdefined('attributes.is_edu_lang_rate') and len(attributes.is_edu_lang_rate)><td>#edu_lang_rate#</td></cfif>
                        <cfif isdefined('attributes.is_edu_startdate') and len(attributes.is_edu_startdate)><td>#dateformat(edu_start,dateformat_style)#</td></cfif>
                        <cfif isdefined('attributes.is_edu_finishdate') and len(attributes.is_edu_finishdate)><td>#dateformat(edu_finish,dateformat_style)#</td></cfif>
                    </cfloop>
                    <cfif y gt 0 and y lt 2>
                        <cfloop from= "1" to="#y#" index="i">
                            <cfif isdefined('attributes.is_edu_name')><td></td></cfif>
                            <cfif isdefined('attributes.is_part_name')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_lang')><td></td></cfif> 
                            <cfif isdefined('attributes.is_edu_lang_rate')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_startdate')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_finishdate')><td></td></cfif>
                        </cfloop>
                    </cfif>
                <cfelse>
                    <cfloop from="1" to="2" index="i">
                        <cfif isdefined('attributes.is_edu_name') and len(attributes.is_edu_name)><td></td></cfif>
                        <cfif isdefined('attributes.is_part_name') and len(attributes.is_part_name)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_lang') and len(attributes.is_edu_lang)><td></td></cfif> 
                        <cfif isdefined('attributes.is_edu_lang_rate') and len(attributes.is_edu_lang_rate)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_startdate') and len(attributes.is_edu_startdate)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_finishdate') and len(attributes.is_edu_finishdate)><td></td></cfif>
                    </cfloop>
                </cfif>
                <cfif edu_info_emp_4.recordcount> 
                    <cfset y = 1 - edu_info_emp_4.recordcount>
                    <cfloop query="edu_info_emp_4"> <cfif isdefined('attributes.is_edu_name') and len(attributes.is_edu_name)><td>#EDU_NAME#</td></cfif>
                        <cfif isdefined('attributes.is_part_name') and len(attributes.is_part_name)><td>#edu_part_name#</td></cfif>
                        <cfif isdefined('attributes.is_edu_lang') and len(attributes.is_edu_lang)><td>#education_lang#</td></cfif> 
                        <cfif isdefined('attributes.is_edu_lang_rate') and len(attributes.is_edu_lang_rate)><td>#edu_lang_rate#</td></cfif>
                        <cfif isdefined('attributes.is_edu_startdate') and len(attributes.is_edu_startdate)><td>#dateformat(edu_start,dateformat_style)#</td></cfif>
                        <cfif isdefined('attributes.is_edu_finishdate') and len(attributes.is_edu_finishdate)><td>#dateformat(edu_finish,dateformat_style)#</td></cfif>
                    </cfloop>
                    <cfif y gt 0 and y lt 1>
                        <cfloop from= "1" to="#y#" index="i">
                            <cfif isdefined('attributes.is_edu_name')><td></td></cfif>
                            <cfif isdefined('attributes.is_part_name')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_lang')><td></td></cfif> 
                            <cfif isdefined('attributes.is_edu_lang_rate')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_startdate')><td></td></cfif>
                            <cfif isdefined('attributes.is_edu_finishdate')><td></td></cfif>
                        </cfloop>
                    </cfif>
                <cfelse>
                    <cfloop from="1" to="1" index="i">
                        <cfif isdefined('attributes.is_edu_name') and len(attributes.is_edu_name)><td></td></cfif>
                        <cfif isdefined('attributes.is_part_name') and len(attributes.is_part_name)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_lang') and len(attributes.is_edu_lang)><td></td></cfif> 
                        <cfif isdefined('attributes.is_edu_lang_rate') and len(attributes.is_edu_lang_rate)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_startdate') and len(attributes.is_edu_startdate)><td></td></cfif>
                        <cfif isdefined('attributes.is_edu_finishdate') and len(attributes.is_edu_finishdate)><td></td></cfif>
                    </cfloop>
                </cfif>
                <cfif isDefined("attributes.special_position") and attributes.special_position eq 1>
                    <cfquery name="get_defected_level" datasource="#dsn#">
                            SELECT * FROM EMPLOYEES_DETAIL WHERE EMPLOYEES_DETAIL.EMPLOYEE_ID = #employee_id#
                    </cfquery>
                    <td>#get_defected_level.defected_level#%</td>
                </cfif>
                <cfif isdefined('attributes.is_country_id') and len(attributes.is_country_id)><td>#get_employee.COUNTRY_NAME#</td></cfif>
                <cfif len(attributes.sureli_is_akdi)>
                    <td>#dateformat(get_employee.SURELI_IS_FINISHDATE,dateformat_style)#</td>
                </cfif>
            </tr>
      
        </cfif>
        </cfoutput>
        </tbody>
        <cfelse>
            <tbody>
                <tr>
                    <td class="color-row"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                </tr>
            </tbody>
        </cfif>
   
</cf_report_list> 

<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
    <!---20131108---><cfscript>
    adres = "report.employee_analyse_report";
    wrkUrlStrings('url_str',
    'is_excel','check_all_box1','check_all_box2','check_all_box3','check_all_box4','check_all_box5','check_all_box6','branch_type','salary_year','salary_month','is_company','is_comp_branch','is_branch','is_department','is_special_code','is_hierarchy_dep','is_position_name','is_poscat','is_group','is_function','is_collar_type','is_title','is_idariamir','is_fonkamir','is_organization_step','is_last_surname','military_status','is_father_and_mother','is_birthdate','is_org_position','is_birthplace','is_age','is_cinsiyet','is_married','is_blood','is_address','is_mail','is_hierarchy','is_grade_step','is_mobiltel','is_mobiltel_spc','is_hometel','is_identy','is_bank_no','is_groupstart','is_kidem','is_kidem_','is_country_id','is_kidem_bilgisi','old_sgk_days','is_izin','is_end_school','is_pdks','is_salary_plan','is_salary','is_salary_type','is_accounting_accounts','is_first_ssk','is_finish_date','is_start_date','is_account_code','is_expense','is_reason','is_duty_type','is_reason_out','is_business_code','in_comp_reason', 'fire_detail','form_submitted','comp_id','branch_id','department_id','is_dep_level','is_language','is_point','is_document','is_document_date','is_lang_where','is_lang_where','is_paper_finish_date','is_edu_name','is_part_name','is_edu_lang','is_edu_lang_rate','is_edu_startdate','is_edu_finishdate','position_cats','organization_steps','upper_position_code','upper_position','func_id','titles','upper_position_code2','upper_position2','user_type','collar_type','hierarchy', 'pos_status','sex','group_start_date1','group_start_date2','last_school','blood_type','kidem_date1','kidem_date2','married','languages','izin_date1','izin_date2','birth_place','birth_mon','birth_date1','birth_date2','special_position','add_info','country_id','employee_id','employee_name','explanation_id','group_id','inout_statue','startdate','finishdate','salary_type','gross_net','expense_center_id','ssk_statute','defection_level','law_numbers','transport_type_id','duty_type','use_pdks','shift_id','lower_salary_range','upper_salary_range','position_status','proxy_user_type','is_edu_type','is_last_school'
    );</cfscript>
    <cf_paging
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="#adres#&#url_str#">
</cfif>
</cfif>


<cfset box_list_1 = 'is_company,is_comp_branch,is_branch,is_department,is_special_code,is_hierarchy_dep'>
<cfset box_list_2 = 'is_position_name,is_poscat,is_function,is_collar_type,is_org_position,is_title,is_idariamir,is_fonkamir,is_organization_step,is_group'>
<cfset box_list_3 = 'is_last_surname,is_last_surname,is_father_and_mother,is_birthdate,is_birthplace,is_age,is_cinsiyet,is_married,is_blood,is_address,is_mail,is_mobiltel,is_mobiltel_spc,is_hometel,is_identy,is_bank_no,is_groupstart,is_kidem,is_kidem_,is_country_id,is_kidem_bilgisi,old_sgk_days,military_status,employee_photo,is_izin,is_identity_info,is_hierarchy,is_grade_step'>
<cfset box_list_4 = 'is_pdks,is_salary_plan,is_salary,is_salary_type,is_accounting_accounts,is_first_ssk,is_finish_date,is_start_date,is_account_code,is_expense,is_reason,is_duty_type,is_reason_out,is_business_code,in_comp_reason,fire_detail,sureli_is_akdi'>
<cfset box_list_5 = 'is_language,is_document,is_document_date,is_point,is_lang_where,is_paper_finish_date'>
<cfset box_list_6 = 'is_edu_type,is_last_school,is_edu_lang,is_edu_name,is_part_name,is_edu_lang_rate,is_edu_startdate,is_edu_finishdate'>

<script type="text/javascript">
function degistir_okul()
{
	document.rapor.edu_part_id.value = "";
	document.rapor.edu_high_part_id.value = "";
	var education_name = document.rapor.education_name.value;
;
	if((education_name == ''))
	{
		university.style.display = '';
		high_school.style.display = 'none';
    }
    else if((education_name == 1))
	{
		university.style.display = 'none';
		high_school.style.display = '';
	}
	else
	{
		university.style.display = '';
		high_school.style.display = 'none';
	}
	
}


function control(){
    if(document.rapor.is_excel.checked==false)
        {
            document.rapor.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.employee_analyse_report"
            return true;
        }
        else

        
        document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_employee_analyse_report</cfoutput>"
    }   
	function hepsini_sec(type)
	{
		if(type == 1)
		{
			if (document.rapor.check_all_box1.checked)
			{	
				<cfloop list="#box_list_1#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = true;
				</cfloop>
			}
			else
			{
				<cfloop list="#box_list_1#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = false;
				</cfloop>
			}
		}
		else if(type == 2)
		{
			if (document.rapor.check_all_box2.checked)
			{	
				<cfloop list="#box_list_2#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = true;
				</cfloop>
			}
			else
			{
				<cfloop list="#box_list_2#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = false;
				</cfloop>
			}
		}
		else if(type == 3)
		{
			if (document.rapor.check_all_box3.checked)
			{	
				<cfloop list="#box_list_3#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = true;
				</cfloop>
			}
			else
			{
				<cfloop list="#box_list_3#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = false;
				</cfloop>
			}
		}
		else if(type == 4)
		{
			if (document.rapor.check_all_box4.checked)
			{	
				<cfloop list="#box_list_4#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = true;
				</cfloop>
			}
			else
			{
				<cfloop list="#box_list_4#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = false;
				</cfloop>
			}
		}
        else if(type == 5)
		{
			if (document.rapor.check_all_box5.checked)
			{	
				<cfloop list="#box_list_5#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = true;
				</cfloop>
			}
			else
			{
				<cfloop list="#box_list_5#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = false;
				</cfloop>
			}
        }
        else if(type == 6)
		{
			if (document.rapor.check_all_box6.checked)
			{	
				<cfloop list="#box_list_6#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = true;
				</cfloop>
			}
			else
			{
				<cfloop list="#box_list_6#" index="x">
					if(document.rapor.<cfoutput>#x#</cfoutput> != undefined)
					document.rapor.<cfoutput>#x#</cfoutput>.checked = false;
				</cfloop>
			}
		}
		return false;
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
	function alt_departman_chckbx(val)
	{
		checkedValues_b = $("#department").multiselect("getChecked");
		if(checkedValues_b.length > 0)
		{
			document.getElementById('alt_departman_td').style.display = '';
		}
		else
		{
			document.getElementById('alt_departman_td').style.display = 'none';
			document.getElementById('is_all_dep').checked = false;
		}
	}
	function department_level_chckbx()
	{
		if(document.getElementById('is_hierarchy_dep').checked == true)
		{
			document.getElementById('department_level_td').style.display = '';
		}
		else
		{
			document.getElementById('department_level_td').style.display = 'none';
			document.getElementById('is_dep_level').checked = false;
		}
	}
    function specialcode_check()
	{
		if(document.getElementById('is_department').checked == true)
		{
			document.getElementById('special_code_td').style.display = '';
		}
		else
		{
			document.getElementById('special_code_td').style.display = 'none';
			document.getElementById('is_special_code').checked = false;
		}
	}
</script>
