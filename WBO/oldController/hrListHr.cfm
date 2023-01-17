<cfif (isdefined("attributes.event") and listfind('list,add,upd,assets,certificate,training,testtime',attributes.event)) or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="hr">
	<cfif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
		<cf_xml_page_edit fuseact="hr.form_upd_emp">
	</cfif>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="hr.list_hr">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.position_cat_status" default="1">
	<cfparam name="attributes.dep_status" default="1">
	<cfparam name="attributes.is_active" default=1>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.keyword2" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.position_cat_id" default="">
	<cfparam name="attributes.title_id" default="">
	<cfparam name="attributes.position_name" default="">
	<cfparam name="attributes.func_id" default="">
	<cfparam name="attributes.organization_step_id" default="">
	<cfparam name="attributes.duty_type" default="">
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.totalrecords" default="0">
	
	<cfscript>
		attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1;
		
		cmp_title = createObject("component","hr.cfc.get_titles");
		cmp_title.dsn = dsn;
		titles = cmp_title.get_title();
		//pozisyon ekleme sayfasinin xml ine gore pozisyon alanini kapatiyoruz
		cmp_property = createObject("component","hr.cfc.get_fuseaction_property");
		cmp_property.dsn = dsn;
		get_position_list_xml = cmp_property.get_property(
			our_company_id: session.ep.company_id,
			fuseaction_name: 'hr.form_add_position',
			property_name: 'x_add_position_name'
		);
		if ((get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1) or get_position_list_xml.recordcount eq 0)
			show_position = 1;
		else
			show_position = 0;
		cmp_process = createObject("component","hr.cfc.get_process_rows");
		cmp_process.dsn = dsn;
		get_process_stage = cmp_process.get_process_type_rows(faction: 'hr.list_hr');
		if (isdefined("attributes.keyword"))
			filtered = 1;
		url_str = "&keyword=#attributes.keyword#&keyword2=#attributes.keyword2#";
		if (len(attributes.hierarchy))
			url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
		if (len(attributes.title_id))
			url_str="#url_str#&title_id=#attributes.title_id#";
		if (len(attributes.position_name))
			url_str="#url_str#&position_name=#attributes.position_name#";
		if (len(attributes.position_cat_id))
			url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
		if (isdefined("attributes.branch_id"))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
		if (isdefined("attributes.department"))
			url_str = "#url_str#&department=#attributes.department#";
		if (isdefined("attributes.emp_status") and len(attributes.emp_status))
			url_str = "#url_str#&emp_status=#attributes.emp_status#";
		if (isdefined("attributes.func_id") and len(attributes.func_id))
			url_str = "#url_str#&func_id=#attributes.func_id#";
		if (isdefined("attributes.organization_step_id") and len(attributes.organization_step_id))
			url_str = "#url_str#&organization_step_id=#attributes.organization_step_id#";
		if (isdefined("attributes.process_stage") and len(attributes.process_stage))
			url_str = "#url_str#&process_stage=#attributes.process_stage#";
		if (isdefined("attributes.duty_type") and len(attributes.duty_type))
			url_str = "#url_str#&duty_type=#attributes.duty_type#";
		include "../hr/query/get_emp_codes.cfm";
		if (isdefined("filtered"))
		{
			cmp_hrs = createObject("component","hr.cfc.get_hrs");
			cmp_hrs.dsn = dsn;
			get_hrs = cmp_hrs.get_hr(
				keyword: attributes.keyword,
				keyword2: attributes.keyword2,
				position_cat_id: attributes.position_cat_id,
				title_id: attributes.title_id,
				branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#',
				func_id: attributes.func_id,
				organization_step_id: attributes.organization_step_id,
				position_name: attributes.position_name,
				collar_type: attributes.collar_type,
				emp_status: '#iif(isdefined("attributes.emp_status"),"attributes.emp_status",DE(""))#',
				hierarchy: attributes.hierarchy,
				emp_code_list: emp_code_list,
				department: '#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
				process_stage: '#iif(isdefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
				duty_type: attributes.duty_type,
				fusebox_dynamic_hierarchy: fusebox.dynamic_hierarchy,
				database_type: database_type,
				maxrows: attributes.maxrows,
				startrow: attributes.startrow
			);
		}
		else
		{
			recordcount.recct = 0;
			get_hrs.recordcount = 0;
		}
		cmp_unit = createObject("component","hr.cfc.get_functions");
		cmp_unit.dsn = dsn;
		get_units = cmp_unit.get_function();
		cmp_org_step = createObject("component","hr.cfc.get_organization_steps");
		cmp_org_step.dsn = dsn;
		get_organization_steps = cmp_org_step.get_organization_step();
		cmp_pos_cat = createObject("component","hr.cfc.get_position_cat");
		cmp_pos_cat.dsn = dsn;
		get_position_cats_ = cmp_pos_cat.get_position_cat();
		cmp_branch = createObject("component","hr.cfc.get_branch_comp");
		cmp_branch.dsn = dsn;
		get_branches = cmp_branch.get_branch(ehesap_control:1,branch_status:attributes.is_active);
		if (isdefined('attributes.branch_id') and isnumeric(attributes.branch_id))
		{
			cmp_department = createObject("component","hr.cfc.get_departments");
			cmp_department.dsn = dsn;
			get_department = cmp_department.get_department(branch_id:attributes.branch_id);
		}
	</cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_papers paper_type="EMPLOYEE">
	<cfscript>
		system_paper_no = paper_code & '-' & paper_number;
		system_paper_no_add = paper_number;
		employee_no = system_paper_no;
		names = "yes";
		include "../hr/query/get_titles.cfm";
		include "../hr/query/get_im_cats.cfm";
		include "../hr/query/get_languages.cfm";
		include "../hr/query/get_moneys.cfm";
		include "../hr/query/get_active_shifts.cfm";
		include "../hr/query/get_id_card_cats.cfm";
		include "../hr/query/get_know_levels.cfm";
		crm = 0;
		if (isdefined("attributes.crm"))
			crm = attributes.crm;
		attributes.tc_identy_no = "";
		attributes.employee_name = "";
		attributes.employee_surname  = "";
		attributes.employee_email = "";
	</cfscript>
	<cfif isDefined("attributes.per_assign_id") and Len(attributes.per_assign_id)>
		<!--- Atama Talebinden Iliskili Calisan Ekleniyor --->
		<cfquery name="get_assign_info" datasource="#dsn#">
			SELECT PERSONEL_NAME, PERSONEL_SURNAME,PERSONEL_TC_IDENTY_NO FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_ASSIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.per_assign_id#">
		</cfquery>
		<cfset attributes.tc_identy_no = get_assign_info.personel_tc_identy_no>
		<cfset attributes.employee_name = get_assign_info.personel_name>
		<cfset attributes.employee_surname  = get_assign_info.personel_surname>
	<cfelseif isDefined("url.service")>
		<cfset attributes.employee_name = attributes.consumer_name>
		<cfset attributes.employee_surname = attributes.consumer_surname>
		<cfset attributes.employee_email = attributes.consumer_email>
	</cfif>
	<cfset attributes.form_name = "employe_detail">
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfscript>
		if (not isnumeric(attributes.employee_id))
		{
			hata = 10;
			include "../dsp_hata.cfm";
			abort;
		}
		names = "yes";
		kontrol_branch = 1;
		include "../hr/query/get_hr.cfm";
		if (get_hr.recordcount)
		{
			include "../hr/query/get_position_master.cfm";
			include "../objects/display/imageprocess/imcontrol.cfm";
			session.resim = 1;
			emp_id = employee_id;
			salary_flag = 1;
		}
	</cfscript>
	<cfif get_hr.recordcount>
		<cfquery name="get_test_time" datasource="#dsn#">
			SELECT TEST_TIME,TEST_DETAIL,CAUTION_TIME,CAUTION_EMP FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
		
		<cfquery name="GET_REQS" datasource="#DSN#">
			SELECT * FROM EMPLOYEE_REQUIREMENTS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
		
		<cfif not session.ep.ehesap>
			<cfinclude template="../hr/query/get_emp_branches.cfm">
		</cfif>
		<cfif not get_position.recordcount>
			<cfquery name="check_in_out" datasource="#dsn#" maxrows="1">
				SELECT BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> ORDER BY IN_OUT_ID DESC
			</cfquery>
			<cfif check_in_out.recordcount>
				<cfif (not session.ep.ehesap) and (not listFindNoCase(emp_branch_list,check_in_out.branch_id))>
					<cfset salary_flag = 0>
				</cfif>	
			<cfelse>
				<cfset salary_flag = 0>
			</cfif>
		</cfif>
		<cfset employee = get_hr.employee_name & ' ' & get_hr.employee_surname>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !");
			history.back();
		</script>
	</cfif>
	<cfif isdefined("is_gov_payroll") and is_gov_payroll eq 1>
		<cfquery name="get_rank" datasource="#dsn#">
			SELECT TOP 1 GRADE,STEP FROM EMPLOYEES_RANK_DETAIL WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(now(),'dd/mm/yyyy')#"> AND PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(now(),'dd/mm/yyyy')#"> ORDER BY PROMOTION_START DESC
		</cfquery>
	</cfif>
	
	<cfset attributes.employee_id = emp_id>
	<cfinclude template="../hr/query/get_im_cats.cfm">
	<cfinclude template="../hr/query/get_languages.cfm">
	<cfinclude template="../hr/query/get_hr_settings.cfm">
	<cfinclude template="../hr/query/get_in_out_other.cfm">
	
	<cfquery name="last_login" datasource="#DSN#" maxrows="1">
		SELECT IN_OUT_TIME,LOGIN_IP FROM WRK_LOGIN WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IN_OUT = 1 ORDER BY IN_OUT_TIME DESC
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'list_mail'>
	<cfquery name="get_email_list" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID,MAILBOX_ID,EMAIL,ACCOUNT,POP,SMTP 
		FROM 
			CUBE_MAIL
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'mail_upd'>
	<cfquery  name="upd_mail_info" datasource="#DSN#">
		SELECT
			ACCOUNT,
			EMAIL,
			ISACTIVE,
			POP,
			RECORD_DATE,
			RECORD_EMP,
			SMTP,
			UPDATE_DATE,
			UPDATE_EMP
		FROM 
			CUBE_MAIL
		WHERE 
			MAILBOX_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mailbox_id#">
	</cfquery>
	<cfscript>
		secim = "yes";
		if (upd_mail_info.ISACTIVE != 1)
			secim = "no";
	</cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'hobbies'>
	<cfquery name="get_hobby" datasource="#dsn#">
		SELECT HOBBY_NAME,HOBBY_ID FROM SETUP_HOBBY
	</cfquery>
	<cfquery name="get_emp_hobbies" datasource="#dsn#"> 
		SELECT HOBBY_ID FROM EMPLOYEES_HOBBY WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfset liste = valuelist(get_emp_hobbies.hobby_id)>
<cfelseif isdefined("attributes.event") and attributes.event is 'assets'>
	<cfquery name="CATEGORIES" datasource="#dsn#">
		SELECT 
			ASSET_CAT,
			HIERARCHY,
			ASSET_CAT_ID,
			SPECIAL_HIERARCHY
		FROM 
			SETUP_EMPLOYMENT_ASSET_CAT 
		ORDER BY 
			HIERARCHY,
			SPECIAL_HIERARCHY,
			ASSET_CAT
	</cfquery>
	<cfquery name="DRIVERLICENCECATEGORIES" dbtype="query">
		SELECT 
			ASSET_CAT,
			HIERARCHY,
			ASSET_CAT_ID,
			SPECIAL_HIERARCHY
		FROM 
			categories
		WHERE
			HIERARCHY NOT LIKE '%.%'
		ORDER BY 
			HIERARCHY,
			SPECIAL_HIERARCHY,
			ASSET_CAT
	</cfquery>
	<cfsavecontent variable="select_"><cfoutput query="driverLicenceCategories"><optgroup label="#asset_cat#"><cfquery name="get_alts" dbtype="query">SELECT ASSET_CAT,HIERARCHY,ASSET_CAT_ID FROM categories WHERE HIERARCHY LIKE '#hierarchy#.%' ORDER BY HIERARCHY,ASSET_CAT</cfquery><cfloop query="get_alts"><option value="#get_alts.asset_cat_id#"><cfloop from="1" to="#listlen(get_alts.hierarchy,'.')-1#" index="ccc">&nbsp;&nbsp;</cfloop>#get_alts.asset_cat#</option></cfloop></optgroup></cfoutput></cfsavecontent>		
	<cfif not DRIVERLICENCECATEGORIES.recordcount>
		<script type="text/javascript">
			alert("Önce Özlük Belge Kategorilerini Tanımlayınız!");
			window.close();
		</script>
		<cfabort>
	<cfelse>
		<cfquery name="get_old_rows" datasource="#dsn#">
			SELECT 
	        	EMPLOYEE_ID, 
	            ASSET_CAT_ID, 
	            ASSET_DATE, 
	            ASSET_FINISH_DATE, 
	            ASSET_NO, 
	            ASSET_NAME, 
	            ASSET_FILE, 
	            ROW_ID 
	        FROM 
	    	    EMPLOYEE_EMPLOYMENT_ROWS 
	        WHERE 
		        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
	        	ASSET_CAT_ID NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valuelist(driverlicencecategories.asset_cat_id)#">)
		</cfquery>
	</cfif>
	<cfset rowcount = 0>
	<cfset rowcount_sabit = 0>
<cfelseif isdefined("attributes.event") and attributes.event is 'safeguard'>
	<cfquery name="get_branchs" datasource="#DSN#">
		SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
	</cfquery>
	<cfquery name="get_safe" datasource="#dsn#">
		SELECT 
	    	EMPLOYEE_ID, 
	        SAFEGUARD_FILE, 
	        RECORD_DATE, 
	        RECORD_EMP, 
	        RECORD_IP, 
	        UPDATE_DATE, 
	        UPDATE_EMP,
	        UPDATE_IP, 
	        BRANCH_ID, 
	        SAFEGUARD_FILE_SERVER_ID 
	    FROM 
		    EMPLOYEES_SAFEGUARD 
	    WHERE 
	    	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'certificate'>
	<cfif not isdefined("get_id_card_cats")>
		<cfinclude template="../hr/query/get_id_card_cats.cfm">
	</cfif>
	<cfif not isdefined("get_hr_detail")>
		<cfinclude template="../hr/query/get_hr_more_detail.cfm">
	</cfif>
	<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
        SELECT
            LICENCECAT_ID, 
            LICENCECAT, 
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            UPDATE_DATE, 
            IS_LAST_YEAR_CONTROL
        FROM
            SETUP_DRIVERLICENCE
        ORDER BY
            IS_LAST_YEAR_CONTROL ASC,
            LICENCECAT
    </cfquery>
    <cfquery name="get_employee_belge" datasource="#DSN#">
        SELECT
            EMPLOYEE_ID, 
            LICENCECAT_ID, 
            LICENCE_START_DATE, 
            LICENCE_FINISH_DATE, 
            LICENCE_NO, 
            UPDATE_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            LICENCE_FILE
        FROM
            EMPLOYEE_DRIVERLICENCE_ROWS
        WHERE
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'personal'>
	<cfif not isdefined("get_id_card_cats")>
		<cfinclude template="../hr/query/get_id_card_cats.cfm">
	</cfif>
	<cfif not isdefined("get_hr_detail")>
		<cfinclude template="../hr/query/get_hr_more_detail.cfm">
	</cfif>
	<cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
		SELECT
			*
		FROM
			SETUP_DRIVERLICENCE
		ORDER BY
			LICENCECAT
	</cfquery>
	<cfset RELATIVE_URL_STRING="">
	<cfset SSK_EK="">
<cfelseif isdefined("attributes.event") and attributes.event is 'requirement'>
	<cfquery name="GET_EMP_REQ" datasource="#DSN#">
		SELECT 
			ER.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_REQUIREMENTS ER,
			EMPLOYEES E
		WHERE 
			ER.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'identy'>
	<cf_xml_page_edit fuseact="hr.form_upd_emp_identy">
	<cfif not isdefined("get_emp_detail")>
		<cfinclude template="../hr/query/get_emp_identy.cfm">
	</cfif>
	<cfquery name="get_country" datasource="#dsn#">
		SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
	</cfquery>
	<cfquery name="get_city" datasource="#dsn#">
		SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
	</cfquery>
	<cfquery name="geT_employee" datasource="#dsn#">
        SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'training'>
	<cfif not isdefined("get_hr_detail")>
	    <cfinclude template="../hr/query/get_hr_detail.cfm">
	</cfif>
	<cfquery name="get_education_level" datasource="#dsn#">
	    SELECT 
	        EDU_LEVEL_ID, 
	        EDUCATION_NAME, 
	        EDU_TYPE, 
	        RECORD_DATE, 
	        RECORD_EMP, 
	        RECORD_IP, 
	        UPDATE_DATE, 
	        UPDATE_EMP, 
	        UPDATE_IP 
	    FROM 
	        SETUP_EDUCATION_LEVEL
	</cfquery>
	<cfquery name="get_unv" datasource="#dsn#">
		SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
	</cfquery>
	<cfquery name="get_school_part" datasource="#dsn#"> 
		SELECT PART_ID,PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
	</cfquery>
	<cfquery name="get_high_school_part" datasource="#dsn#">
		SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
	</cfquery>
	<cfquery name="GET_LANGUAGES" datasource="#dsn#">
		SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
	</cfquery>
	<cfquery name="KNOW_LEVELS" datasource="#dsn#">
		SELECT KNOWLEVEL_ID,KNOWLEVEL FROM SETUP_KNOWLEVEL
	</cfquery>
	<cfquery name="get_emp_language" datasource="#dsn#">
        SELECT 
            EMPLOYEE_ID,
            LANG_ID,
            LANG_SPEAK,
            LANG_WRITE,
            LANG_MEAN,
            LANG_WHERE 
        FROM 
            EMPLOYEES_APP_LANGUAGE
        WHERE
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
    <cfquery name="get_edu_info" datasource="#DSN#">
		SELECT
			EMPAPP_EDU_ROW_ID, 
            EMPAPP_ID, 
            EMPLOYEE_ID, 
            EDU_TYPE, 
            EDU_ID, 
            EDU_NAME, 
            EDU_PART_ID, 
            EDU_PART_NAME, 
            EDU_START, 
            EDU_FINISH, 
            EDU_RANK, 
            IS_EDU_CONTINUE
		FROM
			EMPLOYEES_APP_EDU_INFO
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfquery name="get_emp_course" datasource="#dsn#">
        SELECT 
            COURSE_SUBJECT,
            COURSE_EXPLANATION,
            COURSE_YEAR,
            COURSE_LOCATION,
            COURSE_PERIOD
        FROM 
            EMPLOYEES_COURSE
        WHERE
         EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
    <cfquery name="get_work_info" datasource="#DSN#">
	    SELECT
	        EMPAPP_ROW_ID, 
	        EMPAPP_ID, 
	        EMPLOYEE_ID, 
	        EXP, 
	        EXP_POSITION, 
	        EXP_START, 
	        EXP_FINISH, 
	        EXP_REASON, 
	        EXP_EXTRA, 
	        EXP_TELCODE, 
	        EXP_TEL, 
	        EXP_SECTOR_CAT, 
	        EXP_SALARY, 
	        EXP_EXTRA_SALARY, 
	        EXP_TASK_ID, 
	        IS_CONT_WORK
	    FROM
	        EMPLOYEES_APP_WORK_INFO
	    WHERE
	        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'com'>
	<cfscript>
		get_imcat = createObject("component","hr.cfc.get_im");
		get_imcat.dsn = dsn;
		get_ims = get_imcat.get_im(
			employee_id : attributes.employee_id
		);
		if (not isdefined("get_hr_detail"))
			include "../hr/query/get_hr_detail.cfm";
	</cfscript>
	<cfif len(get_hr_detail.homecity)>
		<cfquery name="get_county" datasource="#dsn#">
			SELECT COUNTY_NAME,COUNTY_ID,CITY FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_detail.homecity#"> ORDER BY COUNTY_NAME
		</cfquery>
	</cfif>
	<cfif len(get_hr_detail.homecountry)>
		<cfquery name="get_city" datasource="#dsn#">
			SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_detail.homecountry#">
		</cfquery>
	</cfif>
	<cfquery name="get_country" datasource="#dsn#">
		SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
	</cfquery>
	<cfquery name="get_reference_type" datasource="#dsn#">
		SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
	</cfquery>
	<cfquery name="get_im_cats" datasource="#dsn#">
		SELECT IMCAT_ID, IMCAT FROM SETUP_IM
	</cfquery>
	<cfquery name="get_referance" datasource="#dsn#">
		SELECT 
			REFERENCE_ID,
			REFERENCE_TYPE,
			REFERENCE_NAME,
			REFERENCE_COMPANY,
			REFERENCE_POSITION,
			REFERENCE_TELCODE,
			REFERENCE_TEL,
			REFERENCE_EMAIL
		FROM 
			EMPLOYEES_REFERENCE 
		WHERE 
			<cfif len(get_hr_detail.empapp_id)>
				EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_hr_detail.empapp_id#">
			<cfelseif len(attributes.employee_id)>
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			 </cfif>
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'tools'>
	<cfif not isdefined("get_know_levels")>
		<cfinclude template="../hr/query/get_know_levels.cfm">
	</cfif>
	<cfif not isdefined("get_hr_detail")>
		<cfinclude template="../hr/query/get_hr_detail.cfm">
	</cfif>
	<cfset tools_list = get_hr_detail.tools>
	<cfset counter = 0>
	<cfset tools = "">
	<cfset tools_values = "">
	<cfloop list="#tools_list#" index="item" delimiters=";">
		<cfset counter = counter +1>
		<cfif counter mod 2>
			<cfset tools = ListAppend(tools, item,";")>
		<cfelse>
			<cfset tools_values = ListAppend(tools_values, item,";")>
		</cfif>
	</cfloop>
<cfelseif isdefined("attributes.event") and attributes.event is 'trainings'>
	<cf_xml_page_edit fuseact="hr.popup_list_emp_trainings">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset url_str="keyword=#attributes.keyword#">
	<cfinclude template="../hr/query/get_emp_training.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'testtime'>
	<cf_xml_page_edit fuseact="hr.emp_test_time">
	<cfquery name="get_test_time" datasource="#dsn#">
		SELECT 
			TEST_TIME, 
			TEST_DETAIL, 
			CAUTION_TIME, 
			CAUTION_EMP,
			QUIZ_ID,
			RECORD_EMP,
			RECORD_DATE,
			UPDATE_EMP,
			UPDATE_DATE
		FROM 
			EMPLOYEES_DETAIL
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
	</cfquery>
	<cfquery name="get_work_startdate" datasource="#dsn#" maxrows="1">
		SELECT 
			START_DATE,
			IN_OUT_ID
		FROM
			EMPLOYEES_IN_OUT
		WHERE
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
		ORDER BY IN_OUT_ID DESC
	</cfquery>
	<cfif len(get_test_time.test_time)>
		<cfset test_time_value = get_test_time.test_time>
	<cfelseif len(xml_test_time)>
		<cfset test_time_value = xml_test_time>
	<cfelse>
		<cfset test_time_value = "">
	</cfif>
	<cfif len(get_test_time.caution_time)>
		<cfset caution_time_value = get_test_time.caution_time>
	<cfelseif len(xml_caution_time)>
		<cfset caution_time_value = xml_caution_time>
	<cfelse>
		<cfset caution_time_value = "">
	</cfif>
	<cfif len(get_test_time.QUIZ_ID)> 
		<cfquery name="GET_QUIZ" datasource="#DSN#">
            SELECT SURVEY_MAIN_HEAD FROM SURVEY_MAIN WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_test_time.quiz_id#">
        </cfquery>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'orientations'>
	<cfset url_str = "">
	<cfparam name="attributes.keyword" default="">
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfquery name="GET_ORIENTATION" datasource="#DSN#">
	   SELECT 
	     * 
	   FROM 
	     TRAINING_ORIENTATION
	   WHERE
	      ATTENDER_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		 <cfif len(attributes.keyword)>
			AND ORIENTATION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		 </cfif>
	</cfquery>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#GET_ORIENTATION.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfelseif isdefined("attributes.event") and attributes.event is 'healty'>
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfparam name="attributes.employee_id" default="">
	<cfinclude template="../hr/ehesap/query/get_emp_healty.cfm">
	<cfparam name="attributes.totalrecords" default="#get_healty.recordcount#">
</cfif>

<script language="javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = $('#branch_id').val();
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
		}
	<cfelseif isdefined("attributes.event") and listfind('add,upd',attributes.event)>
		$(document).ready(function() {
			$('#employee_name').focus();
		});
		function kontrol()
		{
			var emp_no = $('#employee_no').val();
			<cfif attributes.event is 'add'>
				var get_employee_no_query = wrk_safe_query('hr_employee_no_qry','dsn',0,emp_no);
			<cfelseif attributes.event is 'upd'>
				var listParam = emp_no + "*" + "<cfoutput>#attributes.employee_id#</cfoutput>";
				var get_employee_no_query = wrk_safe_query("hr_get_employee_no_query",'dsn',0,listParam);
			</cfif>
			if(get_employee_no_query.recordcount)
			{
				alert('Aynı Çalışan No İle Kayıt Var!  Yeni Numara Atanacaktır!');
				<cfif attributes.event is 'add'>
					var run_query = wrk_safe_query('hr_emp_detail','dsn',0,'<cfoutput>#paper_code#</cfoutput>');
					var emp_num = parseFloat(run_query.BIGGEST_NUMBER)+ 1;
					var emp_num_join = '<cfoutput>#paper_code#</cfoutput>' + '-' +emp_num;
					$('#system_paper_no_add').val(emp_num);
				<cfelseif attributes.event is 'upd'>
					var run_query = wrk_safe_query('hr_emp_no','dsn');
					var run_query2 = wrk_safe_query('hr_emp_detail','dsn',0,run_query.EMPLOYEE_NO );
					var emp_num = parseFloat(run_query2.BIGGEST_NUMBER)+ 1;
					var emp_num_join = run_query.EMPLOYEE_NO + '-' +emp_num;
				</cfif>
				$('#employee_no').val(emp_num_join);
			}
			
			<cfif (attributes.event is 'add' and session.ep.ehesap) or attributes.event is 'upd'>
				
				
				var obj =  $('input#photo').val().toUpperCase();
				var obj_ = list_len(obj,'.');
				var uzanti_ = list_getat(obj,list_len(obj,'.'),'.');
				if(obj!='' && uzanti_!='GIF' && uzanti_!='PNG' && uzanti_!='JPG' && uzanti_!='JPEG') 
				{
					alert("<cf_get_lang no='993.Lütfen bir resim dosyası(gif,jpg,jpeg veya png) giriniz'>!");        
					return false;
				}
			</cfif>
			
			if (($('#is_ip_control').is(":checked") == true) && ($('#ip_address').val() == ''))
			{
				alert("<cf_get_lang no='991.IP Adresi Girmelisiniz'>!");
				return false;
			}
			
			if (($('#is_ip_control').is(":checked") == true) && ($('#computer_name').val() == ''))
			{
				alert("<cf_get_lang no='992.Bilgisayar Adı Girmelisiniz'>!");
				return false;
			}
			
			<cfif attributes.event is 'add'>
				if ($('#detailed').val() == 1)
				{
					if ($('#salary').val() != "")
					{
						if ($('#maas_startdate').val() == "")
						{
							alert("<cf_get_lang no='1041.Maaş Başlangıç Tarihi giriniz'> !");
							return false
						}
						if ($('#startdate').val() == "")
						{
							alert("<cf_get_lang no='1042.İşe Giriş Tarihi giriniz'> !");
							return false
						}
					}
					if (($('#exp1_start').val() == "") && ($('#exp1_finish').val() != ""))
					{
						alert("1. <cf_get_lang no='1043.işe giriş tarihini yazınız'> !");
						$('#exp1_start').focus();
						return false;
					}
						
					if (($('#exp2_start').val() == "") && ($('#exp2_finish').val() != ""))
					{
						alert("2. <cf_get_lang no='1043.işe giriş tarihini yazınız'> !");
						$('#exp2_start').focus();
						return false;
					}
						
					if (($('#exp3_start').val() == "") && ($('#exp3_finish').val() != ""))
					{
						alert("3.<cf_get_lang no='1043.işe giriş tarihini yazınız'> !");
						$('#exp3_start').focus();
						return false;
					}
				
					if (($('#startdate').val() != "") && ($('#finishdate').val() != ""))
						if (!date_check(employe_detail.startdate, employe_detail.finishdate, "<cf_get_lang no='1044.İşe giriş tarihi çıkış tarihinden küçük olmalıdır'> !"))
							return false;
				
					if (($('#exp1_start').val() != "") && ($('#exp1_finish').val() != ""))
						if (!date_check(employe_detail.exp1_start, employe_detail.exp1_finish, "1. <cf_get_lang no='1044.İşe giriş tarihi çıkış tarihinden küçük olmalıdır'> !"))
							return false;
				
					if (($('#exp2_start').val() != "") && ($('#exp2_finish').val() != ""))
						if (!date_check(employe_detail.exp2_start, employe_detail.exp2_finish, "2. <cf_get_lang no='1044.İşe giriş tarihi çıkış tarihinden küçük olmalıdır'> !"))
							return false;
				
					if (($('#exp3_start').val() != "") && ($('#exp3_finish').val() != ""))
						if (!date_check(employe_detail.exp3_start, employe_detail.exp3_finish, "3. <cf_get_lang no='1044.İşe giriş tarihi çıkış tarihinden küçük olmalıdır'> !"))
							return false;
				}
				
				if (process_cat_control())
					return last_control();
			<cfelseif attributes.event is 'upd'>
				return process_cat_control();
			</cfif>
		}
		<cfif attributes.event is 'add'>
			function last_control()
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_dsp_employee_prerecords&employee_name=' + $('#employee_name').val() + '&employee_surname=' + $('#employee_surname').val(),'project','popup_dsp_employee_prerecords');
				return true;
			}
		<cfelseif attributes.event is 'upd'>
			function deneme(obj)
			{
				<cfoutput>windowopen('#request.self#?fuseaction=objects.popup_setup_form_objects&amp;act_=#attributes.fuseaction#&amp;selected_element='+obj,'medium');</cfoutput>
			}
		</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'list_mail'>
		function open_add_mail()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_hr&event=mail_add&employee_id=<cfoutput>#attributes.employee_id#</cfoutput>','medium');
		}
		function open_upd_mail(mbox_id)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_hr&event=mail_upd&employee_id=<cfoutput>#attributes.employee_id#</cfoutput>&mailbox_id='+mbox_id,'medium');
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'assets'>
		$(document).ready(function() {
			rowCount = <cfoutput>#rowcount#</cfoutput>;
		});
		function add_row()
		{
			rowCount++;
			var newRow;
			var newCell;
			
			newRow = table_list.insertRow();
			newRow.className = 'color-row';
			newRow.setAttribute("name","my_row_" + rowCount);
			newRow.setAttribute("id","my_row_" + rowCount);		
			newRow.setAttribute("NAME","my_row_" + rowCount);
			newRow.setAttribute("ID","my_row_" + rowCount);
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML= '<input type="hidden" name="row_kontrol_' + rowCount + '" value="1"><a href="javascript://" onClick="sil(' + rowCount + ');"><i class="icon-trash-o"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML= '<select style="width:150px;" name="asset_cat_id' + rowCount + '"><cfoutput>#trim(select_)#</cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML= '<input type="text" name="asset_name' + rowCount + '" maxrows="100" style="width:65px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML= '<input type="text" name="asset_no' + rowCount + '" maxrows="100" style="width:65px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("name","asset_date" + rowCount + "_td");
			newCell.setAttribute("id","asset_date" + rowCount + "_td");
			newCell.setAttribute("NAME","asset_date" + rowCount + "_td");
			newCell.setAttribute("ID","asset_date" + rowCount + "_td");
			newCell.innerHTML = '<input type="text" name="asset_date' + rowCount + '" id="asset_date' + rowCount + '" maxrows="10" style="width:65px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.setAttribute("name","asset_finish_date" + rowCount + "_td");
			newCell.setAttribute("id","asset_finish_date" + rowCount + "_td");
			newCell.setAttribute("NAME","asset_finish_date" + rowCount + "_td");
			newCell.setAttribute("ID","asset_finish_date" + rowCount + "_td");
			newCell.innerHTML = '<input type="text" name="asset_finish_date' + rowCount + '" id="asset_finish_date' + rowCount + '" maxrows="10" style="width:65px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML= '<input type="file" name="asset_file' + rowCount + '" style="width:100px;">';
			wrk_date_image('asset_date' + rowCount);
			wrk_date_image('asset_finish_date' + rowCount);
			return true;
		}
		
		function sil(sy)
		{
			var my_element=eval("form_basket.row_kontrol_"+sy);
			my_element.value=0;
		
			var my_element=eval("my_row_"+sy);
			my_element.style.display="none";
		}
		
		function sabit_sil(sy)
		{
			var my_element=eval("form_basket.sabit_row_kontrol_"+sy);
			my_element.value=0;
		
			var my_element=eval("sabit_my_row_"+sy);
			my_element.style.display="none";
		}
		
		function check_form()
		{
			form_basket.rowCount.value = rowCount;
			var tur_char = ["ü","ğ","ı","ş","ç","ö","Ü","Ğ","İ","Ş","Ç","Ö"]; 
			for(j=1; j<=rowCount; j++){
				for(i=0; i<12; i++)
				{
					var lstln = list_len(eval("form_basket.asset_file" + j).value,"\\");
					var file_string = list_getat(eval("form_basket.asset_file" + j).value,lstln,"\\");
					if(file_string.indexOf("" + tur_char[i] + "") > -1)
					{
						alert("<cf_get_lang no='824.Dosya adında türkçe karakter içermemeli'>");
						$('#asset_file' + j).focus();
						return false;	
					}
				}
			}
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'certificate'>
		function kontrol_()
		{
			<cfoutput query="GET_DRIVER_LIS">
				if(employe_personal.licence_type_#LICENCECAT_ID#.checked==true)
				{
					if(employe_personal.driver_licence_start_date_#LICENCECAT_ID#.value=='' || employe_personal.licence_no_#LICENCECAT_ID#.value=='')
					{
						alert('<cf_get_lang no="580.Seçili Belge Tipleri İçin Veriliş Tarihi ve Belge No Girmelisiniz">!');
						return false;
					}
				}
			</cfoutput>
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'personal'>
		function seviye()
		{
			if(document.employe_personal.defected_level.disabled==true)
				document.employe_personal.defected_level.disabled=false;
		}
		
		function seviye1()
		{
			if(document.employe_personal.defected_level.disabled==false)
				document.employe_personal.defected_level.disabled=true;
		}
		
		function tecilli_fonk(gelen)
		{
			if (gelen == 4)
			{
				$('#military_delay_reason').css('display','');
				$('#item-military_delay_date').css('display','');
				$('#item-military_finishdate').css('display','none');
				$('#item-military_month').css('display','none');
				$('#item-military_exempt_detail').css('display','none');
			}
			else if(gelen == 1)
			{
				$('#item-military_finishdate').css('display','');
				$('#item-military_month').css('display','');
				$('#military_delay_reason').css('display','none');
				$('#item-military_delay_date').css('display','none');
				$('#item-military_exempt_detail').css('display','none');
			}
			else if(gelen == 2)
			{
				$('#item-military_exempt_detail').css('display','');
				$('#military_delay_reason').css('display','none');
				$('#item-military_delay_date').css('display','none');
				$('#item-military_finishdate').css('display','none');
				$('#item-military_month').css('display','none');
			}
			else
			{
				$('#military_delay_reason').css('display','none');
				$('#item-military_delay_date').css('display','none');
				$('#item-military_finishdate').css('display','none');
				$('#item-military_month').css('display','none');
				$('#item-military_exempt_detail').css('display','none');
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'requirement'>
		$(document).ready(function() {
			row_count = 0;
		});
		function kontrol_et()
		{
			if(row_count ==0)
				return false;
			else
				return true;
		}
	
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			document.add_pos_requirement.record_num.value=row_count;			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="req_type_id_' + row_count + '"><input type="text" name="req_type_' + row_count + '" id="req_type' + row_count + '" style="width:170px;" class="formfieldright"><a onclick="javascript:opage(' + row_count +');"><i class="icon-pluss"></i></a>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="coefficient_' + row_count + '" id="coefficient' + row_count + '" style="width:50px;"   value="" class="formfieldright">';
		
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
		}		
	
		function opage(deger)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_pos_req_types&field_id=add_pos_requirement.req_type_id_' + deger + '&field_name=add_pos_requirement.req_type_' + deger,'list');
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'identy'>
		<cfif isdefined("is_tc_number")>
			var is_tc_number = '<cfoutput>#is_tc_number#</cfoutput>';
		<cfelse>
			var is_tc_number = 0;
		</cfif>
		
		function kontrol()
		{
			if(is_tc_number == 1)
			{
				if(!isTCNUMBER(document.getElementById('TC_IDENTY_NO'))) return false;
			}
			if (document.getElementById('TC_IDENTY_NO').value.length < 11) 
			{
				alert("Eksik Veri: TC Kimlik No");
				return false;
			}
			return true;
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'training'>
		var emp_ex_course = <cfoutput>#get_emp_course.recordcount#</cfoutput>;
		function sil_(del){
			var my_element_=eval("employe_train.del_course_prog"+del);
			my_element_.value=0;
			var my_element_=eval("pro_course"+del);
			my_element_.style.display="none";
		}
		function add_row_course(){
			emp_ex_course++;
			employe_train.emp_ex_course.value = emp_ex_course;
			var newRow;
			var newCell;
			newRow = document.getElementById("emp_course_info").insertRow(document.getElementById("emp_course_info").rows.length);
			newRow.setAttribute("name","pro_course" + emp_ex_course);
			newRow.setAttribute("id","pro_course" + emp_ex_course);
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" value="1" name="del_course_prog' + emp_ex_course +'"><a style="cursor:pointer" onclick="sil_(' + emp_ex_course + ');"><i class="icon-trash-o" title="<cf_get_lang_main no ='51.sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="kurs1_' + emp_ex_course +'" style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="kurs1_exp' + emp_ex_course +'" style="width:100px;"  maxlength="200">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="kurs1_yil' + emp_ex_course +'" style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="kurs1_yer' + emp_ex_course +'" style="width:100px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="kurs1_gun' + emp_ex_course +'" style="width:100px;">';
		}
		<cfif isdefined('get_work_info') and (get_work_info.recordcount)>
			row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
			satir_say=0;
		<cfelse>
			row_count=0;
			satir_say=0;
		</cfif>
		<cfif isdefined('get_edu_info') and (get_edu_info.recordcount)>
			row_edu=<cfoutput>#get_edu_info.recordcount#</cfoutput>;
			satir_say_edu=0;
		<cfelse>
			row_edu=0;
			satir_say_edu=0;
		</cfif>
		function control_lenght()
		{  
			for (var counter_=1; counter_ <=  document.employe_train.emp_ex_course.value; counter_++)
			{ 
				if(eval("document.employe_train.del_course_prog"+counter_).value == 1 && eval("document.employe_train.kurs1_"+counter_).value == '')
				{
					alert("Lütfen Kurs-Sertifika Seçenek " + counter_ + " İçin Konu Giriniz!");
					return false;
				}
			}
			for (var counter_=1; counter_ <=  document.employe_train.emp_ex_course.value; counter_++)
			{
				if(eval("document.employe_train.del_course_prog"+counter_).value == 1 && (eval("document.employe_train.kurs1_yil"+counter_).value == '' || eval("document.employe_train.kurs1_yil"+counter_).value.length <4))
				{
					alert("Lütfen Kurs-Sertifika Seçenek " + counter_ + " İçin Yıl Giriniz!");
					return false;
				}
			}
			if(document.employe_train.edu4_diploma_no.value.length > 50)
			{
				alert("<cf_get_lang no ='1532.Diploma Notu 50 Karakterden Fazla Olamaz'>!");
				return false;
			}
			return true;
		}
		/*İŞ TECRÜBESİ*/
		function sil(sy)
		{
			var my_element=eval("employe_train.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
			satir_say--;
		}
		
		function gonder_upd(count)
		{
			form_work_info.exp_name_new.value = eval("employe_train.exp_name"+count).value;
			form_work_info.exp_position_new.value = eval("employe_train.exp_position"+count).value;
			form_work_info.exp_sector_cat_new.value = eval("employe_train.exp_sector_cat"+count).value;
			form_work_info.exp_task_id_new.value = eval("employe_train.exp_task_id"+count).value;
			form_work_info.exp_start_new.value = eval("employe_train.exp_start"+count).value;
			form_work_info.exp_finish_new.value = eval("employe_train.exp_finish"+count).value;
			form_work_info.exp_telcode_new.value = eval("employe_train.exp_telcode"+count).value;
			form_work_info.exp_tel_new.value = eval("employe_train.exp_tel"+count).value;
			form_work_info.exp_salary_new.value = eval("employe_train.exp_salary"+count).value;
			form_work_info.exp_extra_salary_new.value = eval("employe_train.exp_extra_salary"+count).value;
			form_work_info.exp_extra_new.value = eval("employe_train.exp_extra"+count).value;
			form_work_info.exp_reason_new.value = eval("employe_train.exp_reason"+count).value;
			form_work_info.is_cont_work_new.value = eval("employe_train.is_cont_work"+count).value;
			windowopen('','medium','kariyer_pop');
			form_work_info.target='kariyer_pop';
			form_work_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
			form_work_info.submit();	
		}
		
		function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_extra,exp_reason,control,my_count,is_cont_work)
		{
			if(control == 1)
			{
				eval("employe_train.exp_name"+my_count).value=exp_name;
				eval("employe_train.exp_position"+my_count).value=exp_position;
				eval("employe_train.exp_start"+my_count).value=exp_start;
				eval("employe_train.exp_finish"+my_count).value=exp_finish;
				eval("employe_train.exp_sector_cat"+my_count).value=exp_sector_cat;
				if(exp_sector_cat != '')
				{
					var get_emp_cv_new = wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
					var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
				}
				else
					var exp_sector_cat_name = '';
				eval("employe_train.exp_sector_cat_name"+my_count).value=exp_sector_cat_name;
				eval("employe_train.exp_task_id"+my_count).value=exp_task_id;
				if(exp_task_id != '')
				{
				
					var get_emp_task_cv_new = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
					var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
				}
				else
					var exp_task_name = '';
				eval("employe_train.exp_task_name"+my_count).value=exp_task_name;
				eval("employe_train.exp_telcode"+my_count).value=exp_telcode;
				eval("employe_train.exp_tel"+my_count).value=exp_tel;
				eval("employe_train.exp_salary"+my_count).value=exp_salary;
				eval("employe_train.exp_extra_salary"+my_count).value=exp_extra_salary;
				eval("employe_train.exp_extra"+my_count).value=exp_extra;
				eval("employe_train.exp_reason"+my_count).value=exp_reason;
				eval("employe_train.is_cont_work"+my_count).value=is_cont_work;
			}
			else
			{
				row_count++;
				employe_train.row_count.value = row_count;
				satir_say++;
				var new_Row;
				var new_Cell;
				new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
				new_Row.setAttribute("name","frm_row" + row_count);
				new_Row.setAttribute("id","frm_row" + row_count);		
				new_Row.setAttribute("NAME","frm_row" + row_count);
				new_Row.setAttribute("ID","frm_row" + row_count);
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_upd('+row_count+');"><i class="icon-update"></i></a>';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><i class="icon-trash-o"></i></a>';		
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly>';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" value="'+ exp_position +'" class="boxtext" readonly>';
				if(exp_sector_cat != '')
				{
					var get_emp_cv =  wrk_safe_query('hr_get_emp_cv_new','dsn',0,exp_sector_cat);
					var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
				}
				else
					var exp_sector_cat_name = '';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly>';
				if(exp_task_id != '')
				{
					var get_emp_task_cv = wrk_safe_query('hr_get_emp_task_cv_new','dsn',0,exp_task_id);
					var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
				}
				else
					var exp_task_name = '';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input type="text" name="exp_task_name' + row_count + '" value="'+exp_task_name+'" class="boxtext" readonly>';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" value="'+ exp_start +'" class="boxtext" readonly>';
				new_Cell = new_Row.insertCell(new_Row.cells.length);
				new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" value="'+ exp_finish +'" class="boxtext" readonly>';
				
				new_Cell.innerHTML += '<input type="hidden" name="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
				new_Cell.innerHTML += '<input type="hidden" name="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
				new_Cell.innerHTML += '<input type="hidden" name="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
				new_Cell.innerHTML += '<input type="hidden" name="exp_tel' + row_count + '" value="'+ exp_tel +'">';
				new_Cell.innerHTML += '<input type="hidden" name="exp_salary' + row_count + '" value="'+ exp_salary +'">';
				new_Cell.innerHTML += '<input type="hidden" name="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
				new_Cell.innerHTML += '<input type="hidden" name="exp_extra' + row_count + '" value="'+ exp_extra +'">';
				new_Cell.innerHTML += '<input type="hidden" name="exp_reason' + row_count + '" value="'+ exp_reason +'">';
				new_Cell.innerHTML += '<input type="hidden" name="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
			}
		}
		/*İŞ TECRÜBESİ*/
		/*eğitim bilgileri*/
		function sil_edu(sv)
		{
			var my_element_edu=eval("employe_train.row_kontrol_edu"+sv);
			my_element_edu.value=0;
			var my_element_edu = eval("frm_row_edu"+sv);
			my_element_edu.style.display="none";
			satir_say_edu--;
		}
		
		function gonder_upd_edu(count_new)
		{
			
			form_edu_info.edu_type_new.value = eval("employe_train.edu_type"+count_new).value;//Okul Türü
			if(eval("employe_train.edu_id"+count_new) != undefined && eval("employe_train.edu_id"+count_new).value != '')//eğerki okul listeden seçiliyorsa seçilen okulun id si
				form_edu_info.edu_id_new.value = eval("employe_train.edu_id"+count_new).value;
			else
				form_edu_info.edu_id_new.value = '';
			
			if(eval("employe_train.edu_name"+count_new) != undefined && eval("employe_train.edu_name"+count_new).value != '')
				form_edu_info.edu_name_new.value = eval("employe_train.edu_name"+count_new).value;
			else
				form_edu_info.edu_name_new.value = '';
			
			form_edu_info.edu_start_new.value = eval("employe_train.edu_start"+count_new).value;
			form_edu_info.edu_finish_new.value = eval("employe_train.edu_finish"+count_new).value;
			form_edu_info.edu_rank_new.value = eval("employe_train.edu_rank"+count_new).value;
			if(eval("employe_train.edu_high_part_id"+count_new) != undefined && eval("employe_train.edu_high_part_id"+count_new).value != '')
				form_edu_info.edu_high_part_id_new.value = eval("employe_train.edu_high_part_id"+count_new).value;
			else
				form_edu_info.edu_high_part_id_new.value = '';
				
			if(eval("employe_train.edu_part_id"+count_new) != undefined && eval("employe_train.edu_part_id"+count_new).value != '')
				form_edu_info.edu_part_id_new.value = eval("employe_train.edu_part_id"+count_new).value;
			else
				form_edu_info.edu_part_id_new.value = '';
				
			if(eval("employe_train.edu_part_name"+count_new) != undefined && eval("employe_train.edu_part_name"+count_new).value != '')
				form_edu_info.edu_part_name_new.value = eval("employe_train.edu_part_name"+count_new).value;
			else
				form_edu_info.edu_part_name_new.value = '';
			form_edu_info.is_edu_continue_new.value = eval("employe_train.is_edu_continue"+count_new).value;
			windowopen('','medium','kryr_pop');
			form_edu_info.target='kryr_pop';
			form_edu_info.action = '<cfoutput>#request.self#?fuseaction=hr.popup_add_edu_info&count_edu='+count_new+'&ctrl_edu=1</cfoutput>';
			form_edu_info.submit();	
		}
		
		function gonder_edu(edu_type,ctrl_edu,count_edu,edu_id,edu_name,edu_start,edu_finish,edu_rank,edu_high_part_id,edu_part_id,is_edu_continue,edu_part_name)
		{
			var edu_type = edu_type.split(';')[0];
			var edu_name_degisken = '';
			var edu_part_name_degisken = '';
			if(ctrl_edu == 1)
			{
				eval("employe_train.edu_type"+count_edu).value=edu_type;
				if(edu_type != undefined && edu_type != '')
				{
					var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
					if(get_edu_part_name_sql.recordcount)
						var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
				}
				eval("employe_train.edu_type_name"+count_edu).value=edu_type_name;
				eval("employe_train.edu_id"+count_edu).value=edu_id;
				eval("employe_train.edu_high_part_id"+count_edu).value=edu_high_part_id;
				eval("employe_train.edu_part_id"+count_edu).value=edu_part_id;
				if(edu_id != '' && edu_id != -1)
				{
					var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
					if(get_cv_edu_new.recordcount)
						var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
					eval("employe_train.edu_name"+count_edu).value=edu_name_degisken;
				}
				else
				{
					eval("employe_train.edu_name"+count_edu).value=edu_name;
				}
				eval("employe_train.edu_start"+count_edu).value=edu_start;
				eval("employe_train.edu_finish"+count_edu).value=edu_finish;
				eval("employe_train.edu_rank"+count_edu).value=edu_rank;
				if(eval("employe_train.edu_high_part_id"+count_edu) != undefined && eval("employe_train.edu_high_part_id"+count_edu).value != '' && edu_high_part_id != -1 )
				{
					var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
					if(get_cv_edu_high_part_id.recordcount)
						var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
					eval("employe_train.edu_part_name"+count_edu).value=edu_part_name_degisken;
				}
				else if(eval("employe_train.edu_part_id"+count_edu) != undefined && eval("employe_train.edu_part_id"+count_edu).value != '' && edu_part_id != -1)
				{
					var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
					if(get_cv_edu_part_id.recordcount)
						var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
					eval("employe_train.edu_part_name"+count_edu).value=edu_part_name_degisken;
				}
				else 
				{
					var edu_part_name_degisken = edu_part_name;
					eval("employe_train.edu_part_name"+count_edu).value=edu_part_name_degisken;
				}
				eval("employe_train.is_edu_continue"+count_edu).value=is_edu_continue;
			}
			else
			{
				row_edu++;
				employe_train.row_edu.value = row_edu;
				satir_say_edu++;
				var new_Row_Edu;
				var new_Cell_Edu;
				new_Row_Edu = document.getElementById("table_edu_info").insertRow(document.getElementById("table_edu_info").rows.length);
				new_Row_Edu.setAttribute("name","frm_row_edu" + row_edu);
				new_Row_Edu.setAttribute("id","frm_row_edu" + row_edu);		
				new_Row_Edu.setAttribute("NAME","frm_row_edu" + row_edu);
				new_Row_Edu.setAttribute("ID","frm_row_edu" + row_edu);
		
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<a href="javascript://" onClick="gonder_upd_edu('+row_edu+');"><i class="icon-update"></i></a>';
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_edu' + row_edu +'" ><a href="javascript://" onclick="sil_edu(' + row_edu + ');"><i class="icon-trash-o"></i></a>';
				
				if(edu_type != undefined && edu_type != '')
				{
					var get_edu_part_name_sql = wrk_safe_query('hr_get_edu_part_name','dsn',0,edu_type);
					if(get_edu_part_name_sql.recordcount)
						var edu_type_name = get_edu_part_name_sql.EDUCATION_NAME;
				}
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input style="width:75px;" type="text" name="edu_type_name' + row_edu + '" value="'+ edu_type_name +'" class="boxtext" readonly>';
				if(edu_id != undefined && edu_id != '' && edu_id != -1)
				{
					var get_cv_edu_new = wrk_safe_query('hr_get_cv_edu_new','dsn',0,edu_id);
					if(get_cv_edu_new.recordcount)
						var edu_name_degisken = get_cv_edu_new.SCHOOL_NAME;
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input  style="width:100%;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name_degisken +'" class="boxtext" readonly>';
				}
				if(edu_name != undefined && edu_name != '')
				{
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input style="width:100%;" type="text" name="edu_name' + row_edu + '" value="'+ edu_name +'" class="boxtext" readonly>';
				}
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_start' + row_edu + '" value="'+ edu_start +'" class="boxtext" readonly>';
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_finish' + row_edu + '" value="'+ edu_finish +'" class="boxtext" readonly>';
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input style="width:65px;" type="text" name="edu_rank' + row_edu + '" value="'+ edu_rank +'" class="boxtext" readonly>';
				if(edu_high_part_id != undefined && edu_high_part_id != '' && edu_high_part_id != -1)
				{
					var get_cv_edu_high_part_id = wrk_safe_query('hr_cv_edu_high_part_id_q','dsn',0,edu_high_part_id);
					if(get_cv_edu_high_part_id.recordcount)
						var edu_part_name_degisken = get_cv_edu_high_part_id.HIGH_PART_NAME;
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input style="width:100%;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
				}
				else if(edu_part_id != undefined && edu_part_id != '' && edu_part_id != -1)
				{
					var get_cv_edu_part_id = wrk_safe_query('hr_cv_edu_part_id_q','dsn',0,edu_part_id);
					if(get_cv_edu_part_id.recordcount)
						var edu_part_name_degisken = get_cv_edu_part_id.PART_NAME;
					new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
					new_Cell_Edu.innerHTML = '<input style="width:100%;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name_degisken +'" class="boxtext" readonly>';
				}
				else
				{
				new_Cell_Edu = new_Row_Edu.insertCell(new_Row_Edu.cells.length);
				new_Cell_Edu.innerHTML = '<input style="width:100%;" type="text" name="edu_part_name' + row_edu + '" value="'+ edu_part_name +'" class="boxtext" readonly>';
				}
				new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_type' + row_edu + '" value="'+ edu_type +'" class="boxtext" readonly>';
				new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_id' + row_edu + '" value="'+ edu_id +'" class="boxtext" readonly>';
				new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_high_part_id' + row_edu + '" value="'+ edu_high_part_id +'" style="width:150px;" class="boxtext" readonly>';
				new_Cell_Edu.innerHTML += '<input type="hidden" name="edu_part_id' + row_edu + '" value="'+ edu_part_id +'" style="width:150px;" class="boxtext" readonly>';
				new_Cell_Edu.innerHTML += '<input type="hidden" name="is_edu_continue' + row_edu + '" value="'+ is_edu_continue +'" style="width:150px;" class="boxtext" readonly>';
				new_Cell_Edu.innerHTML += '<input style="width:10;" type="hidden" name="gizli' + row_edu + '" value="" class="boxtext" readonly>';
			}
		}
		
		/*Eğitim Bilgileri*/
		/* Dil Bilgileri */
		var add_lang_info=<cfif isdefined("get_emp_language")><cfoutput>#get_emp_language.recordcount#</cfoutput><cfelse>0</cfif>;
		function del_lang(dell){
			var my_emement1=eval("employe_train.del_lang_info"+dell);
			my_emement1.value=0;
			var my_element1=eval("lang_info_"+dell);
			my_element1.style.display="none";
		}
		function add_lang_info_()
		{
			add_lang_info++;
			employe_train.add_lang_info.value=add_lang_info;
			var newRow;
			var newCell;
			newRow = document.getElementById("lang_info").insertRow(document.getElementById("lang_info").rows.length);
			newRow.setAttribute("name","lang_info_" + add_lang_info);
			newRow.setAttribute("id","lang_info_" + add_lang_info);
			employe_train.language_info.value=add_lang_info;
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="hidden" value="1" name="del_lang_info'+ add_lang_info +'"><a style="cursor:pointer" onclick="del_lang(' + add_lang_info + ');"><i class="icon-trash-o" title="<cf_get_lang_main no ="51.sil">"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="lang' + add_lang_info +'" style="width:100px;"><option value=""><cf_get_lang_main no="1584.Dil"></option><cfoutput query="get_languages"><option value="#language_id#">#language_set#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="lang_speak' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="lang_mean' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="lang_write' + add_lang_info +'" style="width:100px;"><cfoutput query="know_levels"><option value="#knowlevel_id#">#knowlevel#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="lang_where' + add_lang_info + '" value="" style="width:150px;">';
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'com'>
		var add_ref_info=<cfif isdefined("get_referance")><cfoutput>#get_referance.recordcount#</cfoutput><cfelse>0</cfif>;
		var add_im_info=<cfif isdefined("get_ims")><cfoutput>#get_ims.recordcount#</cfoutput><cfelse>0</cfif>;
	
		function del_ref(dell){
			var my_element1=eval("employe_com.del_ref_info"+dell);
			my_element1.value=0;
			var my_element2=eval("ref_info_"+dell);
			my_element2.style.display="none";
		}
		function del_im(dell){
			var my_element3=eval("employe_com.del_im_info"+dell);
			my_element3.value=0;
			var my_element4=eval("im_info_"+dell);
			my_element4.style.display="none";
		}
		function add_ref_info_(){
			add_ref_info++;
			employe_com.add_ref_info.value=add_ref_info;
			var newRow;
			var newCell;
			newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
			newRow.setAttribute("name","ref_info_" + add_ref_info);
			newRow.setAttribute("id","ref_info_" + add_ref_info);
			document.employe_com.referance_info.value=add_ref_info;
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'"><a style="cursor:pointer" onclick="del_ref(' + add_ref_info + ');"><i class="icon-trash-o" title="<cf_get_lang_main no ="51.sil">"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="ref_type' + add_ref_info +'" style="width:100px;"><option value="">Referans Tipi</option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_name' + add_ref_info +'" style=" width:90px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_company' + add_ref_info +'" style=" width:90px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_telcode' + add_ref_info +'" style=" width:50px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_tel' + add_ref_info +'" style=" width:75px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_position' + add_ref_info +'" style=" width:75px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="ref_mail' + add_ref_info +'" style=" width:75px;">';
		}
		function add_im_info_(){
			add_im_info++;
			employe_com.add_im_info.value=add_im_info;
			var newRow;
			var newCell;
			newRow = document.getElementById("im_info").insertRow(document.getElementById("im_info").rows.length);
			newRow.setAttribute("name","im_info_" + add_im_info);
			newRow.setAttribute("id","im_info_" + add_im_info);
			document.employe_com.instant_info.value=add_im_info;
			
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="hidden" value="1" name="del_im_info'+ add_im_info +'"><a style="cursor:pointer" onclick="del_im(' + add_im_info + ');"><i class="icon-trash-o" title="<cf_get_lang_main no ="51.sil">"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="imcat_id' + add_im_info +'" style="width:112px;"><option value="">Seçiniz</option><cfoutput query="get_im_cats"><option value="#imcat_id#">#imcat#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="im_address' + add_im_info +'" style=" width:120px;">';
		}
		<cfif not len(get_hr_detail.homecity)>
			var country_ = document.employe_com.homecountry.value;
			if(country_.length)
				LoadCity(country_,'select_city','select_county',0);	
		</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'testtime'>
		function control_warning()//herhangibir alan değiştiğinde hidden alanı 1 set eder ve uyarı ozaman eklenir
		{
			document.employe_detail.control_upd.value = '1';
		}
		function control_warning2()
		{
			if(document.employe_detail.caution_emp_id.value != "" && document.employe_detail.caution_emp.value != "" && (document.employe_detail.quiz_id.value == "" || document.employe_detail.quiz_head.value == ""))
			{
				alert("<cf_get_lang no='822.Değerlendirme Formu'>");
				return false;
			}
			if(document.employe_detail.quiz_id_old.value != document.employe_detail.quiz_id.value)
			{
				document.employe_detail.control_upd.value = '1';
			}
			if(document.employe_detail.caution_emp_old_id.value != document.employe_detail.caution_emp_id.value)
			{
				document.employe_detail.control_upd.value = '1';
			}
			return true;
		}
	</cfif>
</script> 

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_hr';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_hr.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_emp';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/form_add_emp.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_emp.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_hr&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_emp';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/form_upd_emp.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_emp_std.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_hr&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'employee_id=##attributes.employee_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.employee_id##';
	/*if (isdefined("is_gov_payroll") and is_gov_payroll eq 1 and get_rank.recordcount)
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_hr.employee_name## ##get_hr.employee_surname##   (##get_rank.grade##/##get_rank.step##)';
	else
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_hr.employee_name## ##get_hr.employee_surname##';*/
		
	WOStruct['#attributes.fuseaction#']['list_mail'] = structNew();
	WOStruct['#attributes.fuseaction#']['list_mail']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list_mail']['fuseaction'] = 'hr.popup_list_mail_info';
	WOStruct['#attributes.fuseaction#']['list_mail']['filePath'] = 'hr/display/list_mail_info.cfm';
	WOStruct['#attributes.fuseaction#']['list_mail']['parameters'] = 'employee_id=##attributes.employee_id##';
	WOStruct['#attributes.fuseaction#']['list_mail']['Identity'] = '##attributes.employee_id##';
	
	WOStruct['#attributes.fuseaction#']['mail_add'] = structNew();
	WOStruct['#attributes.fuseaction#']['mail_add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['mail_add']['fuseaction'] = 'hr.popup_crate_mail_account';
	WOStruct['#attributes.fuseaction#']['mail_add']['filePath'] = 'hr/form/create_mail_account.cfm';
	WOStruct['#attributes.fuseaction#']['mail_add']['queryPath'] = 'hr/query/add_email.cfm';
	WOStruct['#attributes.fuseaction#']['mail_add']['nextEvent'] = 'hr.list_hr&event=upd';
	WOStruct['#attributes.fuseaction#']['mail_add']['Identity'] = '##lang_array.item[501]##';
	
	WOStruct['#attributes.fuseaction#']['mail_upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['mail_upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['mail_upd']['fuseaction'] = 'hr.popup_upd_email';
	WOStruct['#attributes.fuseaction#']['mail_upd']['filePath'] = 'hr/form/update_email.cfm';
	WOStruct['#attributes.fuseaction#']['mail_upd']['queryPath'] = 'hr/query/update_email_account.cfm';
	WOStruct['#attributes.fuseaction#']['mail_upd']['nextEvent'] = 'hr.list_hr&event=upd';
	WOStruct['#attributes.fuseaction#']['mail_upd']['Identity'] = '##lang_array.item[179]##';
	
	WOStruct['#attributes.fuseaction#']['mail_del'] = structNew();
	WOStruct['#attributes.fuseaction#']['mail_del']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['mail_del']['fuseaction'] = 'hr.emptypopup_del_email_account';
	WOStruct['#attributes.fuseaction#']['mail_del']['filePath'] = 'hr/query/delete_email_account.cfm';
	WOStruct['#attributes.fuseaction#']['mail_del']['queryPath'] = 'hr/query/delete_email_account.cfm';
	WOStruct['#attributes.fuseaction#']['mail_del']['nextEvent'] = 'hr.list_hr&event=list_mail';
	
	WOStruct['#attributes.fuseaction#']['hobbies'] = structNew();
	WOStruct['#attributes.fuseaction#']['hobbies']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['hobbies']['fuseaction'] = 'hr.popup_form_emp_hobbies';
	WOStruct['#attributes.fuseaction#']['hobbies']['filePath'] = 'hr/form/form_add_emp_hobbies.cfm';
	WOStruct['#attributes.fuseaction#']['hobbies']['queryPath'] = 'hr/query/emp_hobbies_upd.cfm';
	WOStruct['#attributes.fuseaction#']['hobbies']['nextEvent'] = 'hr.list_hr&event=hobbies';
	WOStruct['#attributes.fuseaction#']['hobbies']['Identity'] = '##lang_array.item[1514]##';
	
	WOStruct['#attributes.fuseaction#']['safeguard'] = structNew();
	WOStruct['#attributes.fuseaction#']['safeguard']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['safeguard']['fuseaction'] = 'hr.popup_form_upd_emp_safeguard';
	WOStruct['#attributes.fuseaction#']['safeguard']['filePath'] = 'hr/form/form_upd_emp_safeguard.cfm';
	WOStruct['#attributes.fuseaction#']['safeguard']['queryPath'] = 'hr/query/upd_emp_safeguard.cfm';
	WOStruct['#attributes.fuseaction#']['safeguard']['nextEvent'] = 'hr.list_hr&event=upd';
	WOStruct['#attributes.fuseaction#']['safeguard']['Identity'] = '##attributes.employee_id##';
	
	WOStruct['#attributes.fuseaction#']['assets'] = structNew();
	WOStruct['#attributes.fuseaction#']['assets']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['assets']['fuseaction'] = 'hr.popup_form_upd_emp_employment_assets';
	WOStruct['#attributes.fuseaction#']['assets']['filePath'] = 'hr/form/upd_emp_employment_assets.cfm';
	WOStruct['#attributes.fuseaction#']['assets']['queryPath'] = 'hr/query/upd_emp_employment_assets.cfm';
	WOStruct['#attributes.fuseaction#']['assets']['nextEvent'] = 'hr.list_hr&event=assets';
	WOStruct['#attributes.fuseaction#']['assets']['Identity'] = '##lang_array.item[227]## : ##get_emp_info(attributes.employee_id,0,0)##';
	
	WOStruct['#attributes.fuseaction#']['certificate'] = structNew();
	WOStruct['#attributes.fuseaction#']['certificate']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['certificate']['fuseaction'] = 'hr.popup_form_upd_emp_personal_certificate';
	WOStruct['#attributes.fuseaction#']['certificate']['filePath'] = 'hr/form/form_upd_emp_personal_certificate.cfm';
	WOStruct['#attributes.fuseaction#']['certificate']['queryPath'] = 'hr/query/upd_emp_personal_certificate.cfm';
	WOStruct['#attributes.fuseaction#']['certificate']['nextEvent'] = 'hr.list_hr&event=certificate';
	WOStruct['#attributes.fuseaction#']['certificate']['Identity'] = '##lang_array.item[282]## : ##get_hr_detail.employee_name## ##get_hr_detail.employee_surname##';
	
	WOStruct['#attributes.fuseaction#']['personal'] = structNew();
	WOStruct['#attributes.fuseaction#']['personal']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['personal']['fuseaction'] = 'hr.popup_form_upd_emp_personal';
	WOStruct['#attributes.fuseaction#']['personal']['filePath'] = 'hr/form/form_upd_emp_personal.cfm';
	WOStruct['#attributes.fuseaction#']['personal']['queryPath'] = 'hr/query/upd_emp_personal.cfm';
	WOStruct['#attributes.fuseaction#']['personal']['nextEvent'] = 'hr.list_hr&event=personal';
	WOStruct['#attributes.fuseaction#']['personal']['Identity'] = '##attributes.employee_id##';
	
	WOStruct['#attributes.fuseaction#']['requirement'] = structNew();
	WOStruct['#attributes.fuseaction#']['requirement']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['requirement']['fuseaction'] = 'hr.popup_upd_emp_requirement';
	WOStruct['#attributes.fuseaction#']['requirement']['filePath'] = 'hr/form/add_emp_requirement.cfm';
	WOStruct['#attributes.fuseaction#']['requirement']['queryPath'] = 'hr/query/add_emp_requirement.cfm';
	WOStruct['#attributes.fuseaction#']['requirement']['nextEvent'] = 'hr.list_hr&event=requirement';
	WOStruct['#attributes.fuseaction#']['requirement']['Identity'] = '##lang_array.item[363]## : ##get_emp_info(attributes.employee_id,0,0)##';
	
	WOStruct['#attributes.fuseaction#']['identy'] = structNew();
	WOStruct['#attributes.fuseaction#']['identy']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['identy']['fuseaction'] = 'hr.popup_form_upd_emp_identy';
	WOStruct['#attributes.fuseaction#']['identy']['filePath'] = 'hr/form/form_upd_emp_identy.cfm';
	WOStruct['#attributes.fuseaction#']['identy']['queryPath'] = 'hr/query/upd_emp_identy.cfm';
	WOStruct['#attributes.fuseaction#']['identy']['nextEvent'] = 'hr.list_hr&event=identy';
	WOStruct['#attributes.fuseaction#']['identy']['Identity'] = '##lang_array.item[42]##';
	
	WOStruct['#attributes.fuseaction#']['training'] = structNew();
	WOStruct['#attributes.fuseaction#']['training']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['training']['fuseaction'] = 'hr.popup_form_upd_emp_training';
	WOStruct['#attributes.fuseaction#']['training']['filePath'] = 'hr/form/form_upd_emp_training.cfm';
	WOStruct['#attributes.fuseaction#']['training']['queryPath'] = 'hr/query/upd_emp_train.cfm';
	WOStruct['#attributes.fuseaction#']['training']['nextEvent'] = 'hr.list_hr&event=training';
	WOStruct['#attributes.fuseaction#']['training']['Identity'] = '##lang_array.item[864]##';
	
	WOStruct['#attributes.fuseaction#']['com'] = structNew();
	WOStruct['#attributes.fuseaction#']['com']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['com']['fuseaction'] = 'hr.popup_form_upd_emp_com';
	WOStruct['#attributes.fuseaction#']['com']['filePath'] = 'hr/form/form_upd_emp_com.cfm';
	WOStruct['#attributes.fuseaction#']['com']['queryPath'] = 'hr/query/upd_emp_com.cfm';
	WOStruct['#attributes.fuseaction#']['com']['nextEvent'] = 'hr.list_hr&event=com';
	WOStruct['#attributes.fuseaction#']['com']['Identity'] = '##attributes.employee_id##';
	
	WOStruct['#attributes.fuseaction#']['tools'] = structNew();
	WOStruct['#attributes.fuseaction#']['tools']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['tools']['fuseaction'] = 'hr.popup_form_upd_emp_tools';
	WOStruct['#attributes.fuseaction#']['tools']['filePath'] = 'hr/form/form_upd_emp_tools.cfm';
	WOStruct['#attributes.fuseaction#']['tools']['queryPath'] = 'hr/query/upd_emp_tools.cfm';
	WOStruct['#attributes.fuseaction#']['tools']['nextEvent'] = 'hr.list_hr&event=tools';
	WOStruct['#attributes.fuseaction#']['tools']['Identity'] = '##attributes.employee_id##';
	
	WOStruct['#attributes.fuseaction#']['trainings'] = structNew();
	WOStruct['#attributes.fuseaction#']['trainings']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['trainings']['fuseaction'] = 'hr.popup_list_emp_trainings';
	WOStruct['#attributes.fuseaction#']['trainings']['filePath'] = 'hr/display/list_employee_tranings.cfm';
	WOStruct['#attributes.fuseaction#']['trainings']['Identity'] = '##get_emp_info(attributes.emp_id,0,0)##';
	
	WOStruct['#attributes.fuseaction#']['testtime'] = structNew();
	WOStruct['#attributes.fuseaction#']['testtime']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['testtime']['fuseaction'] = 'hr.popup_emp_upd_test_time';
	WOStruct['#attributes.fuseaction#']['testtime']['filePath'] = 'hr/form/upd_emp_test_time.cfm';
	WOStruct['#attributes.fuseaction#']['testtime']['queryPath'] = 'hr/query/upd_emp_test_time.cfm';
	WOStruct['#attributes.fuseaction#']['testtime']['nextEvent'] = 'hr.list_hr&event=testtime';
	WOStruct['#attributes.fuseaction#']['testtime']['Identity'] = '##lang_array.item[240]##';
	
	WOStruct['#attributes.fuseaction#']['orientations'] = structNew();
	WOStruct['#attributes.fuseaction#']['orientations']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['orientations']['fuseaction'] = 'hr.popup_list_employee_orientations';
	WOStruct['#attributes.fuseaction#']['orientations']['filePath'] = 'hr/display/list_training_orientation.cfm';
	
	WOStruct['#attributes.fuseaction#']['notes'] = structNew();
	WOStruct['#attributes.fuseaction#']['notes']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['notes']['fuseaction'] = 'hr.popup_list_perf_remind_notes';
	WOStruct['#attributes.fuseaction#']['notes']['filePath'] = 'hr/display/list_perf_remind_notes.cfm';
	WOStruct['#attributes.fuseaction#']['notes']['Identity'] = '##lang_array.item[1259]##';
	
	WOStruct['#attributes.fuseaction#']['healty'] = structNew();
	WOStruct['#attributes.fuseaction#']['healty']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['healty']['fuseaction'] = 'hr.popup_list_employee_healty';
	WOStruct['#attributes.fuseaction#']['healty']['filePath'] = 'hr/display/list_employee_healty.cfm';
	WOStruct['#attributes.fuseaction#']['healty']['Identity'] = '##lang_array.item[1260]##  : <cfif get_healty.recordcount>##get_healty.employee_name## ##get_healty.employee_surname##<cfelseif isdefined("attributes.employee_id")>##get_emp_info(attributes.employee_id,0,0)##</cfif>';
		
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1709]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_password_maker&employee_id=#attributes.employee_id#','list','popup_list_password_maker');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[176]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=list_mail&employee_id=#attributes.employee_id#','list','popup_list_mail_info');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=hr.form_upd_emp&action_name=employee_id&action_id=#attributes.employee_id#','list','popup_page_warnings');";
		i = 3;
		if (get_module_user(3) and not listfindnocase(denied_pages,'report.bsc_company'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[557]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=report.popup_bsc_company&employee_id=#attributes.employee_id#&employee=#employee#','wide2','popup_bsc_company');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_emp_hobbies'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1314]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=hobbies&employee_id=#attributes.employee_id#','small','popup_form_emp_hobbies');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_employment_assets'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[227]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=assets&employee_id=#attributes.employee_id#','page','popup_form_upd_emp_employment_assets');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_safeguard'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[554]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=safeguard&employee_id=#attributes.employee_id#','page','popup_form_upd_emp_safeguard');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_personal_certificate'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[282]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=certificate&employee_id=#attributes.employee_id#','page','popup_form_upd_emp_personal_certificate');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_personal'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[41]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=personal&employee_id=#attributes.employee_id#','page','popup_form_upd_emp_personal');";
			i = i + 1;
		}
		if (get_reqs.recordcount)
		{
			if (not listfindnocase(denied_pages,'hr.popup_upd_emp_requirement'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1256]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=requirement&employee_id=#attributes.employee_id#','medium','popup_upd_emp_requirement');";
				i = i + 1;
			}
		}
		else
		{
			if (not listfindnocase(denied_pages,'hr.popup_upd_emp_requirement'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[118]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=requirement&employee_id=#attributes.employee_id#','medium','popup_upd_emp_requirement');";
				i = i + 1;
			}
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_identy'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[42]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=identy&employee_id=#attributes.employee_id#','medium','popup_form_upd_emp_identy');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_training'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[40]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=training&employee_id=#attributes.employee_id#','wide','popup_form_upd_emp_training');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_com'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[731]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=com&employee_id=#attributes.employee_id#','list','popup_form_upd_emp_com');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_tools'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[39]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=tools&employee_id=#attributes.employee_id#','medium','popup_form_upd_emp_tools');";
			i = i + 1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[44]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.employee_id#&type_id=-4','list','popup_list_comp_add_info');";
		i = i + 1;
		if (not listfindnocase(denied_pages,'hr.popup_form_add_relative'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[611]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_add_relative&employee_id=#attributes.employee_id#','page','popup_form_add_relative');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_add_employee_contract'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1725]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_list_employee_contract&employee_id=#attributes.employee_id#','medium','popup_list_employee_contract');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_list_emp_trainings'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1257]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=trainings&emp_id=#attributes.employee_id#','list','popup_add_employee_contract');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_emp_upd_test_time'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1979]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=testtime&emp_id=#attributes.employee_id#','small','popup_emp_upd_test_time');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_list_employee_orientations'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[124]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=orientations&employee_id=#attributes.employee_id#','project','popup_list_employee_orientations');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'hr.popup_list_perf_remind_notes'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1259]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=notes&employee_id=#attributes.employee_id#','medium','popup_list_perf_remind_notes');";
			i = i + 1;
		}
		if (fusebox.use_period and get_module_power_user(48))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[36]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ch.list_company_extre&member_type=employee&member_id=#attributes.employee_id#','wide2','popup_list_comp_extre');";
			i = i + 1;
		}
		if (get_module_user(3))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1260]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_hr&event=healty&employee_id=#attributes.employee_id#','list','popup_list_employee_healty');";
			i = i + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[743]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_list_emp_healty_report&employee_id=#attributes.employee_id#','project','popup_list_emp_healty_report');";
			i = i + 1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_history_position&employee_id=#attributes.employee_id#','project','popup_history_position');";
		i = i + 1;
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1261]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_training_trainer&employee_id=#attributes.employee_id#','horizantal','popup_training_trainer');";
		i = i + 1;
		if (len(get_hr.per_assign_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[1786]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.from_upd_personel_assign_form&per_assign_id=#get_hr.per_assign_id#";
			i = i + 1;
		}
		if (isdefined("is_gov_payroll") and is_gov_payroll eq 1 and not listfindnocase(denied_pages,'hr.popup_form_add_rank'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = 'Derece-Kademe Ekle';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_add_rank&employee_id=#attributes.employee_id#','page','popup_form_add_rank');";
			i = i + 1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.employee_id#&print_type=173','page','workcube_print');";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_hr&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if (attributes.event is 'mail_upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['mail_upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['mail_upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['mail_upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['mail_upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_hr&event=mail_add&employee_id=#attributes.employee_id#";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if (isdefined("attributes.event") and listfind('upd,mail_add,mail_upd,personal,identy,safeguard,add,com,tools,testtime',attributes.event))
	{
		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'hrListHr.cfm';
		if (listfind('add,upd',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'upd';
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES';
			WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
			WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-employee_name','item-employee_surname','item-employee_username']";
		}
		else if (listfind('mail_add,mail_upd',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'mail_add,mail_upd';
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'CUBE_MAIL';
			WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
		}
		else if (listfind('personal,com,tools,testtime',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'personal,com,tools,testtime';
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_DETAIL';
			WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
		}
		else if (listfind('identy',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'identy';
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_IDENTY';
			WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
		}
		else if (listfind('safeguard',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'safeguard';
			WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_SAFEGUARD';
			WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
		}
	}
</cfscript>
