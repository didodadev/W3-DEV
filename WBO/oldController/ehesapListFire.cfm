<cf_get_lang_set module_name="ehesap">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="ehesap.list_fire">
	<cfscript>
		if (not isdefined("attributes.keyword"))
		{
			arama_yapilmali = 1;
			attributes.is_out_statue = 1;
		}
		else
			arama_yapilmali = 0;
		if (arama_yapilmali eq 1)
			get_in_outs.recordcount = 0;
		else
			include "../hr/ehesap/query/get_in_outs.cfm";
	
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
		
		duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
		if(isdefined("is_gov_payroll") and is_gov_payroll eq 1)
		{	
			QueryAddRow(duty_type,9);
		}
		else
		{
			QueryAddRow(duty_type,8);
		}
		QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#lang_array_main.item[164]#",1);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[194]#',2);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[604]#',3);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[206]#',4);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[232]#',5);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[223]#',6);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[236]#',7);
		QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[253]#',8);
		if(isdefined("is_gov_payroll") and is_gov_payroll eq 1)
		{
			QuerySetCell(duty_type,"DUTY_TYPE_ID",8,9);
			QuerySetCell(duty_type,"DUTY_TYPE_NAME",'#lang_array.item[1233]#/#lang_array_main.item[1298]#',9);
		}
		include "../hr/ehesap/query/get_ssk_offices.cfm";
	</cfscript>
	<cfparam name="attributes.startdate" default="#date_add('m',-1,bu_ay_basi)#">
	<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.tc_identy_no" default="">
	<cfparam name="attributes.duty_type" default="">
	<cfparam name="attributes.department_id" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.explanation_id" default="">
	<cfparam name="attributes.explanation_id2" default="">
	<cfparam name="attributes.inout_statue" default="2">
	<cfparam name="attributes.out_statue" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_in_outs.recordcount#'>
	<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
		<cfquery name="get_departmant" datasource="#dsn#">
			SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS = 1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
		</cfquery>
	</cfif>
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		adres=attributes.fuseaction;
		adres = "#adres#&keyword=#attributes.keyword#";
		adres = "#adres#&hierarchy=#attributes.hierarchy#";
		adres = "#adres#&branch_id=#attributes.branch_id#";
		adres = "#adres#&inout_statue=#attributes.inout_statue#";
		adres = "#adres#&explanation_id=#attributes.explanation_id#";
		adres = "#adres#&explanation_id2=#attributes.explanation_id2#";
		if (isdefined('attributes.is_out_statue') and len(attributes.is_out_statue))
			adres = "#adres#&is_out_statue=#attributes.is_out_statue#";
		if (len(attributes.out_statue))
			adres = "#adres#&out_statue=#attributes.out_statue#";
		if (isdefined("attributes.startdate") and isdate(attributes.startdate))
			adres = "#adres#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#";
		if (isdefined("attributes.finishdate") and isdate(attributes.finishdate))
			adres = "#adres#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#";
		if (isdefined("attributes.record_startdate") and isdate(attributes.record_startdate))
			adres = "#adres#&record_startdate=#dateformat(attributes.record_startdate,'dd/mm/yyyy')#";
		if (isdefined("attributes.record_finishdate") and isdate(attributes.record_finishdate))
			adres = "#adres#&record_finishdate=#dateformat(attributes.record_finishdate,'dd/mm/yyyy')#";
		if (x_get_position_cat)
			adres = "#adres#&is_position_cat=1";
		if (x_get_duty_type)
			adres = "#adres#&duty_type=#attributes.duty_type#";
	</cfscript>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="ehesap.form_add_position_in">
	<cfscript>
		my_employee_id = '';
		my_position_code = '';
		my_position_name = '';
		my_branch_id = '';
		my_branch = '';
		my_department_id = '';
		my_department = '';
		my_kidem_date = now();
		use_ssk = 1;
		socialsecurity_no = "";
		gross_net = 0;
		salary_type = 2;
		emp_business_code_id = '';
		emp_business_code_name = '';
		emp_business_code = '';
		/*cmp_business_code = createobject("component","hr.ehesap.cfc.get_business_codes");
		cmp_business_code.dsn = dsn;
		get_business_codes = cmp_business_code.get_business_code();*/
		if (isdefined("attributes.position_code"))
		{
			include "../hr/ehesap/query/get_position.cfm";
			my_employee_id = get_position.employee_id;
			my_position_code = get_position.position_code;
			my_position_name = '#get_position.employee_name# #get_position.employee_surname#';
			my_branch_id = get_position.branch_id;
			my_branch = get_position.branch_name;
			my_department_id = get_position.department_id;
			my_department = get_position.department_head;
			if(len(get_position.kidem_date))
				my_kidem_date = get_position.kidem_date;
			if(len(get_position.business_code_id))
			{
				emp_business_code_id = get_position.business_code_id;
				emp_business_code_name = get_position.business_code_name;
				emp_business_code = get_position.business_code;
			}
		}
		else if (isdefined("attributes.employee_id"))
		{
			cmp_branch_dept = createobject("component","hr.ehesap.cfc.get_branch_dept_info");
			cmp_branch_dept.dsn = dsn;
			get_branch_dept_info = cmp_branch_dept.get_branch_dept_info(employee_id : attributes.employee_id);
			my_employee_id = attributes.employee_id;
			my_position_name = "#get_emp_info(attributes.employee_id,0,0)#";
			my_branch_id = get_branch_dept_info.branch_id;
			my_branch = get_branch_dept_info.branch_name;
			my_department_id = get_branch_dept_info.department_id;
			my_department = get_branch_dept_info.department_head;
			if(len(get_branch_dept_info.business_code_id))
			{
				emp_business_code_id = get_branch_dept_info.business_code_id;
				emp_business_code_name = get_branch_dept_info.business_code_name;
				emp_business_code = get_branch_dept_info.business_code;
			}
		}
		
		if (len(my_employee_id))
		{
			cmp = createobject("component","hr.ehesap.cfc.get_emp_last_in_out");
			cmp.dsn = dsn;
			get_emp_last_in_out = cmp.get_emp_last_in_out(employee_id : my_employee_id, date_ : now());
			if (get_emp_last_in_out.recordcount and len(get_emp_last_in_out.in_out_id))
			{
				use_ssk = get_emp_last_in_out.use_ssk;
				socialsecurity_no = get_emp_last_in_out.socialsecurity_no;
				gross_net = get_emp_last_in_out.gross_net;
				salary_type = get_emp_last_in_out.salary_type;
				if (emp_business_code_id eq '' and len(get_emp_last_in_out.business_code_id))
				{
					emp_business_code_id = get_emp_last_in_out.business_code_id;
					emp_business_code_name = get_emp_last_in_out.business_code_name;
					emp_business_code = get_emp_last_in_out.business_code;
				}
			}
		}
	</cfscript>
	<cfif not isdefined('attributes.position_code') and isdefined('attributes.employee_id')>
		<cfquery name="get_kidem_date" datasource="#dsn#">
			SELECT KIDEM_DATE FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
		<cfif len(get_kidem_date.kidem_date)>
			<cfset my_kidem_date = get_kidem_date.kidem_date>
		</cfif>
	</cfif>
	<cfif len(my_employee_id)>
		<cfquery name="get_tc_identy" datasource="#dsn#">
			SELECT EI.TC_IDENTY_NO FROM EMPLOYEES E,EMPLOYEES_IDENTY EI WHERE E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_employee_id#"> AND EI.EMPLOYEE_ID = E.EMPLOYEE_ID
		</cfquery>
	</cfif>
	<cfquery name="get_survey_form" datasource="#dsn#" maxrows="1">
		SELECT
			TOP 1 
			SM.SURVEY_MAIN_ID,
			SM.SURVEY_MAIN_HEAD
		FROM 
			CONTENT_RELATION CR
			INNER JOIN SURVEY_MAIN SM ON CR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID
		WHERE
			SM.TYPE = 6 AND
			CR.RELATION_TYPE = 6 AND<!--- deneme süresi--->
			CR.RELATED_ALL =1 AND
			SM.IS_ACTIVE = 1
		ORDER BY
			SM.RECORD_DATE DESC		
	</cfquery>
	<cfif len(my_branch_id)>
		<cfquery name="get_period" datasource="#dsn#">
            SELECT 
                SP.PERIOD_ID 
            FROM 
                SETUP_PERIOD SP INNER JOIN OUR_COMPANY OC ON SP.OUR_COMPANY_ID = OC.COMP_ID
                INNER JOIN BRANCH B ON OC.COMP_ID = B.COMPANY_ID
            WHERE
                B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_branch_id#"> AND
                SP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(my_kidem_date)#">
        </cfquery>
        <cfscript>
            cmp = createObject("component","hr.cfc.create_account_period");
            cmp.dsn = dsn;
            get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:my_branch_id,department_id:my_department_id);
            if(not get_acc_def.recordcount)
            {
                get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:my_branch_id);
            }	
            if(get_acc_def.recordcount)
            {
                get_account_bill_type = cmp.get_account_definiton_code_row(account_definition_id:get_acc_def.id);
            }
            else
            {
                get_account_bill_type.recordcount = 0;	
            }
        </cfscript>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cfif (not session.ep.ehesap)>
		<cfinclude template="../hr/ehesap/query/get_emp_branches.cfm">
	</cfif>
	<cfquery name="GET_EMP_SSK" datasource="#dsn#">
		SELECT
			EIO.EMPLOYEE_ID,
			EIO.BRANCH_ID,
			EIO.DEPARTMENT_ID,
			EIO.PAYMETHOD_ID,
			EIO.BUSINESS_CODE_ID,
			EIO.IN_OUT_ID,
			EIO.USE_SSK,
			EIO.START_DATE,
			EIO.FINISH_DATE,
			EIO.TRADE_UNION,
			EIO.TRADE_UNION_NO,
			EIO.IS_5510,
			EIO.IS_START_CUMULATIVE_TAX,
			EIO.KISMI_ISTIHDAM_GT_GUN,
			EIO.DUTY_TYPE_COMPANY_ID,
			EIO.SOCIALSECURITY_NO,
			EIO.SSK_STATUTE,
			EIO.RETIRED_SGDP_NUMBER,
			EIO.DUTY_TYPE,
			EIO.KISMI_ISTIHDAM_GUN,
			EIO.KISMI_ISTIHDAM_SAAT,
			EIO.IS_VARDIYA,
			EIO.FIRST_SSK_DATE,
			EIO.SURELI_IS_AKDI,
			EIO.SURELI_IS_FINISHDATE,
			EIO.SHIFT_ID,
			EIO.USE_PDKS,
			EIO.PDKS_NUMBER,
			EIO.PDKS_TYPE_ID,
			EIO.CUMULATIVE_TAX_TOTAL,
			EIO.START_CUMULATIVE_TAX,
			EIO.SABIT_PRIM,
			EIO.IS_TAX_FREE,
			EIO.IS_DAMGA_FREE,
			EIO.GROSS_NET,
			EIO.USE_TAX,
			EIO.SALARY_TYPE,
			EIO.DEFECTION_LEVEL,
			EIO.FAZLA_MESAI_SAAT,
			EIO.IS_SAKAT_KONTROL,
			EIO.EFFECTED_CORPORATE_CHANGE,
			EIO.DAYS_5746,
			EIO.IS_DISCOUNT_OFF ,
			EIO.IS_5084,
			EIO.IS_PUANTAJ_OFF,
			EIO.DATE_5763,
			EIO.LAW_NUMBERS,
			EIO.RECORD_EMP,
			EIO.UPDATE_EMP,
			EIO.RECORD_DATE,
			EIO.UPDATE_DATE,
			EIO.TRANSPORT_TYPE_ID,
	        EIO.DATE_6111,
	        EIO.DATE_6111_SELECT,
			EIO.PUANTAJ_GROUP_IDS,
			EIO.IS_6486,
			EIO.IS_6322,
			EIO.IS_25510,
			EIO.IN_OUT_STAGE,
	        EIO.DAYS_4691,
			SBC.BUSINESS_CODE,
			SBC.BUSINESS_CODE_NAME
		FROM
			EMPLOYEES_IN_OUT EIO
			LEFT JOIN SETUP_BUSINESS_CODES SBC ON SBC.BUSINESS_CODE_ID = EIO.BUSINESS_CODE_ID
		WHERE
			EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	</cfquery>
	<cfset attributes.employee_id = get_emp_ssk.employee_id>
	<cfif get_emp_ssk.recordcount>
		<cfif (not session.ep.ehesap) and (not listFind(emp_branch_list, get_emp_ssk.branch_id))>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !");
				history.back();
			</script>
			<!--- yetki dışı kullanım için mail şablonu hazırlanmalı erk 20030911--->
			<cfabort>
		</cfif>	
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='724.Çalışan İçin İşe Giriş-Çıkış Kaydı Bulunamadı'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_worktimes_xml" datasource="#dsn#">
	    SELECT 
			PROPERTY_VALUE,
			PROPERTY_NAME
		FROM
			FUSEACTION_PROPERTY
	    WHERE
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			FUSEACTION_NAME = 'ehesap.list_ext_worktimes' AND
			PROPERTY_NAME = 'is_extwork_type'	
	</cfquery>
	<cfif not isdefined("attributes.period_id") >
		<cfset attributes.period_id = session.ep.period_id>
	</cfif>
	<cfquery name="GET_OTHER_PERIOD" datasource="#DSN#">
		SELECT	
			* 
		FROM 
			SETUP_PERIOD 
		WHERE 
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfif not isdefined("get_moneys")>
		<cfinclude template="../hr/ehesap/query/get_moneys.cfm">
	</cfif>
	<cfquery name="get_in_out_info" datasource="#dsn#">
		SELECT
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_ID,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			BRANCH.SSK_OFFICE,
			BRANCH.SSK_NO,
			OUR_COMPANY.NICK_NAME
		FROM
			DEPARTMENT,
			BRANCH,
			OUR_COMPANY
		WHERE
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
			DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_ssk.department_id#">
	</cfquery>
	<cfset attributes.sal_mon = month(now())>
	<cfset attributes.sal_year = year(now())>
	<cfif dateformat(now(),'yyyy') gt attributes.sal_year>
		<cfset attributes.month_ = 'M12'>
	<cfelse>
		<cfset attributes.month_ = 'M#dateformat(now(),"m")#'>
	</cfif>
	<cfinclude template="../hr/ehesap/query/get_ssk_yearly.cfm">
	<cfinclude template="../hr/ehesap/query/get_active_shifts.cfm">
	<cfif len(get_emp_ssk.paymethod_id)>
		<cfset attributes.paymethod_id = get_emp_ssk.paymethod_id>
		<cfinclude template="../hr/ehesap/query/get_paymethod.cfm">
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
	<cfset cmp = createObject("component","hr.ehesap.cfc.employee_puantaj_group")>
    <cfset cmp.dsn = dsn/>
    <cfset get_groups = cmp.get_groups()>
    <cfquery name="get_all_transport_types" datasource="#dsn#">
        SELECT 
            *
        FROM 
            SETUP_TRANSPORT_TYPES
    </cfquery>
    <cfquery name="get_ust_transport_types" dbtype="query">
        SELECT 
            *
        FROM 
            get_all_transport_types
        WHERE
            UPPER_TRANSPORT_TYPE_ID IS NULL
        ORDER BY
            TRANSPORT_TYPE
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd_unf'>
	<cfquery name="get_fire_detail" datasource="#dsn#">
		SELECT
			EMPLOYEES_IN_OUT.*,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
		FROM
			EMPLOYEES_IN_OUT
			INNER JOIN EMPLOYEES ON EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
		WHERE
			EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	</cfquery>
	<cfif len(get_fire_detail.FINISH_DATE)>
		<cfquery name="get_puantaj_id" datasource="#dsn#">
			SELECT
				*
			FROM
				EMPLOYEES_PUANTAJ
				INNER JOIN EMPLOYEES_PUANTAJ_ROWS ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			WHERE
				AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
				AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(get_fire_detail.finish_date)#">
				AND EMPLOYEES_PUANTAJ.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#month(get_fire_detail.finish_date)#">
		</cfquery>
	</cfif>
	<cfif get_fire_detail.recordcount>
		<cfset attributes.employee_id = get_fire_detail.employee_id>
	</cfif>
	<cfif not session.ep.ehesap>
		<cfinclude template="../hr/ehesap/query/get_emp_branches.cfm">
	</cfif>
	<cfif len(get_fire_detail.department_id)>
        <cfquery name="DEPARTMENT" datasource="#DSN#">
            SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_fire_detail.DEPARTMENT_ID#
        </cfquery>
        <cfset department_name = DEPARTMENT.DEPARTMENT_HEAD>
    <cfelse>
        <cfset department_name = "">
    </cfif>
    <cfinclude template="../hr/ehesap/query/get_emp_branches.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is 'view_fire'>
	<cfscript>
		if (not session.ep.ehesap)
			include "../hr/ehesap/query/get_emp_branches.cfm";
		include "../hr/ehesap/query/get_ssk_offices.cfm";
	</cfscript>
	<cfquery name="get_fire_detail" datasource="#dsn#">
		SELECT 
	    	EIO.EMPLOYEE_ID,
	        EIO.FINISH_DATE,
	        E.EMPLOYEE_NAME,
	        E.EMPLOYEE_SURNAME,
	        E.KIDEM_DATE,
	        EIO.DETAIL,
	        EIO.IS_KIDEM_BAZ ,
	        EIO.START_DATE,
	        EIO.IN_OUT_ID,
	        EIO.EXPLANATION_ID,
	        EIO.BRANCH_ID,
	        EIO.DEPARTMENT_ID,
	        EIO.SALARY,
	        EIO.IHBAR_DATE,
	        EIO.KIDEM_YEARS,
	        EIO.TOTAL_DENEME_DAYS,
	        EIO.TOTAL_SSK_MONTHS,
	        EIO.IHBAR_DAYS,
	        EIO.TOTAL_SSK_DAYS,
	        EIO.KULLANILMAYAN_IZIN_COUNT,
	        EIO.KIDEM_AMOUNT,
	        EIO.HAKEDILEN_YILLIK_IZIN,
	        EIO.IHBAR_AMOUNT,
	        EIO.GROSS_COUNT_TYPE,
	        EIO.KULLANILMAYAN_IZIN_AMOUNT,
	        EIO.IN_COMPANY_REASON_ID,
	       	EIO.VALIDATOR_POSITION_CODE,
	        EIO.IS_EMPTY_POSITION,
	        EIO.VALID,
	        EIO.VALID_EMP,
	        EIO.VALID_DATE,
	        EIO.ENTRY_DATE,
	        EIO.ENTRY_BRANCH_ID,
	        EIO.ENTRY_DEPARTMENT_ID,
	        EIO.IS_SALARY_TRANSFER,
	        EIO.IS_SALARY_DETAIL_TRANSFER,
	        EIO.IS_ACCOUNTING_TRANSFER,
	        EIO.IS_UPDATE_POSITION,
	        EIO.IN_OUT_STAGE,
	        EIO.NEW_CARD_ACCOUNT_BILL_TYPE,
	        (SELECT TOP 1 SD.DEFINITION FROM EMPLOYEES_IN_OUT_PERIOD EIOP INNER JOIN SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SD ON EIOP.ACCOUNT_BILL_TYPE=SD.PAYROLL_ID WHERE IN_OUT_ID = EIO.IN_OUT_ID ORDER BY PERIOD_YEAR DESC) AS DEFINITION
	    FROM 
	    	EMPLOYEES_IN_OUT EIO,
	        EMPLOYEES E 
	    WHERE 
	    	EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND 
	        EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	</cfquery>
	<cfif not get_fire_detail.recordcount>
		<script type="text/javascript">
			alert("Böyle bir kayıt yok !");
			window.close();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_fire_count" datasource="#dsn#" maxrows="2">
		SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
	</cfquery>
	<cfquery name="get_assetps" datasource="#dsn#">
		SELECT
			ASSET_P.ASSETP_ID,
			ASSET_P.ASSETP,
			ASSET_P_CAT.ASSETP_CAT
		FROM
			ASSET_P
			LEFT JOIN ASSET_P_CAT ON ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
		WHERE
			ASSET_P.STATUS = 1 AND
			ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
		ORDER BY
			ASSET_P.ASSETP
	</cfquery>
	<cfquery name="get_zimmets" datasource="#dsn#">
		SELECT 
			ERZR.* 
		FROM 
			EMPLOYEES_INVENT_ZIMMET_ROWS ERZR,
			EMPLOYEES_INVENT_ZIMMET EIZ
		WHERE 
			ERZR.ZIMMET_ID = EIZ.ZIMMET_ID AND
			EIZ.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
	</cfquery>
	<cfquery name="get_note" datasource="#dsn#">
		SELECT NOTE_HEAD,NOTE_BODY FROM NOTES WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
	</cfquery>
	<cfquery name="get_all_emps" datasource="#dsn#">
		SELECT 
			EMPLOYEES.EMPLOYEE_ID MEMBER_ID,
			EMPLOYEES.EMPLOYEE_NAME MEMBER_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME MEMBER_SURNAME,
			WORKGROUP_EMP_PAR.ROLE_ID ROLE,
			SPR.PROJECT_ROLES
		FROM 
			EMPLOYEES,
			WORKGROUP_EMP_PAR
			LEFT JOIN SETUP_PROJECT_ROLES SPR ON WORKGROUP_EMP_PAR.ROLE_ID = PROJECT_ROLES_ID
		WHERE 
			EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
			WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
		 ORDER BY
			MEMBER_ID		
	</cfquery>
	<cfquery name="get_all_emps_related" datasource="#dsn#">
		SELECT 
			EMPLOYEES.EMPLOYEE_ID MEMBER_ID,
			EMPLOYEES.EMPLOYEE_NAME MEMBER_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME MEMBER_SURNAME,
			WORKGROUP_EMP_PAR.ROLE_ID ROLE,
			SPR.PROJECT_ROLES
		FROM
			EMPLOYEES,
			WORKGROUP_EMP_PAR
			LEFT JOIN SETUP_PROJECT_ROLES SPR ON WORKGROUP_EMP_PAR.ROLE_ID = PROJECT_ROLES_ID
		WHERE 
			EMPLOYEES.EMPLOYEE_ID = WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID AND
			WORKGROUP_EMP_PAR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#"> AND
			WORKGROUP_EMP_PAR.MAIN_EMPLOYEE_ID IS NOT NULL
		 ORDER BY
			MEMBER_ID
	</cfquery>
	<cfset updateable = session.ep.ehesap or ListFindNoCase(emp_branch_list,get_fire_detail.branch_id, ',')>
	<cfif len(get_fire_detail.finish_date)>
		<cfquery name="get_puantaj_id" datasource="#dsn#">
			SELECT
				*
			FROM
				EMPLOYEES_PUANTAJ,
				EMPLOYEES_PUANTAJ_ROWS
			WHERE
				EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
				AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.employee_id#">
				AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(get_fire_detail.finish_date)#">
				AND EMPLOYEES_PUANTAJ.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#month(get_fire_detail.finish_date)#">
		</cfquery>
	</cfif>
	<cfset attributes.sal_mon = month(get_fire_detail.finish_date)>
	<cfset attributes.sal_year = year(get_fire_detail.finish_date)>
	<cfset attributes.employee_id = get_fire_detail.employee_id>
	<cfquery name="get_emp_kidem_dahil_odeneks" datasource="#dsn#">
		SELECT
			EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID,
			EMPLOYEES_PUANTAJ_ROWS.SALARY,
			EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY,
			EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT,
			EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2,
			EMPLOYEES_PUANTAJ.SAL_MON,
			EMPLOYEES_PUANTAJ.SAL_YEAR,
			EMPLOYEES_PUANTAJ.SSK_OFFICE,
			EMPLOYEES_PUANTAJ.SSK_OFFICE_NO,
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
		FROM
			EMPLOYEES_PUANTAJ_ROWS_EXT,
			EMPLOYEES_PUANTAJ_ROWS,
			EMPLOYEES_PUANTAJ
		WHERE
			EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
			AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ_ROWS_EXT.IS_KIDEM = 1
			AND EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE = 0
			AND
			(
				(
				EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				)				
				OR
				(
				EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year-2#"> AND
				EMPLOYEES_PUANTAJ.SAL_MON > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				)
			)
		ORDER BY
			EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
			EMPLOYEES_PUANTAJ.SAL_MON DESC
	</cfquery>
	<!--- kıdem toplamı gün yüzde dikkate alınarak toplanacak ortalaması alınacak --->
	<cfset TEMP_AVG = 0>
	<cfoutput query="get_emp_kidem_dahil_odeneks">
		<cfif AMOUNT_2 EQ 0><!--- ARTI --->
			<cfset TEMP_AVG = TEMP_AVG + AMOUNT>
		<cfelse><!--- YÜZDE --->
			<cfset TEMP_AVG = TEMP_AVG + AMOUNT_2>
		</cfif>
	</cfoutput>
	<cfif get_fire_detail.is_kidem_baz eq 1>
		<cfset datediff_ = datediff('d',get_fire_detail.kidem_date,get_fire_detail.finish_date)/30>
	<cfelse>
		<cfset datediff_ = datediff('d',get_fire_detail.start_date,get_fire_detail.finish_date)/30>
	</cfif>
	<cfif datediff_ eq 0>
		<cfset datediff_ = 1>
	</cfif>
	<cfif datediff_ mod 30 neq 0>
		<cfset datediff_ = Int(datediff_)+1>
	</cfif>
	<cfif datediff_ gt 12>
		<cfset datediff_ = 12>
	</cfif>
	<cfset kidem_dahil_odenek = TEMP_AVG / datediff_>
	<cfquery name="GET_SIGORTA" datasource="#dsn#" maxrows="1">
		SELECT
			(VERGI_ISTISNA_SSK + VERGI_ISTISNA_VERGI + VERGI_ISTISNA_DAMGA) AS TOPLAM_SIGORTA
		FROM
			EMPLOYEES_PUANTAJ_ROWS EPR,
			EMPLOYEES_PUANTAJ EP
		WHERE
			EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
			EPR.TOTAL_DAYS > 0 AND		
			EP.PUANTAJ_TYPE = -1 AND
			EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
			(
				(
				EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
				AND
				EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				)
				OR
				(
				EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#YEAR(get_fire_detail.FINISH_DATE)#">
				AND
				EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#MONTH(get_fire_detail.FINISH_DATE)#">
				)
				OR
				(
				EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
				)
			)
		ORDER BY 
			EP.SAL_YEAR DESC,
			EP.SAL_MON DESC
	</cfquery>
	<cfscript>
		get_fire_xml = createObject("component","hr.ehesap.cfc.get_fire_xml");
		get_fire_xml.dsn = dsn;
		get_fire_xml_ = get_fire_xml.get_xml_det(property:'x_tax_acc');
		get_fire_xml_control = get_fire_xml.get_xml_det(property:'x_is_salaryparam_get_control');
		
		if ((get_fire_xml_.recordcount and get_fire_xml_.property_value eq 1) or get_fire_xml_.recordcount eq 0)
			x_tax_acc = 1;
		else
			x_tax_acc = 0;
		sigorta_toplam = 0;
		if (GET_SIGORTA.recordcount and GET_SIGORTA.TOPLAM_SIGORTA gt 0 and x_tax_acc eq 1)
			sigorta_toplam = GET_SIGORTA.TOPLAM_SIGORTA;
		if (get_fire_detail.explanation_id neq 18 and get_fire_xml_control.recordcount) //çıkış nakil değilse bu kontrole girecek
			x_is_salaryparam_get_control = get_fire_xml_control.property_value;
		else
			x_is_salaryparam_get_control = 0;
		ayni_yardim_total = 0;
	</cfscript>
	<cfquery name="get_ayni_yardims" datasource="#dsn#">
		SELECT
			SUM(AMOUNT_PAY) AS AYNI_TOTAL
		FROM
			SALARYPARAM_PAY
		WHERE
			IS_AYNI_YARDIM = 1 AND
			START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
			END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
			TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
			IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.in_out_id#">
	</cfquery>
	<cfif get_ayni_yardims.recordcount and len(get_ayni_yardims.AYNI_TOTAL)>
		<cfset ayni_yardim_total = get_ayni_yardims.AYNI_TOTAL>
	</cfif>
	<cfquery name="get_zimmet" datasource="#DSN#">
		SELECT ZIMMET_ID FROM EMPLOYEES_INVENT_ZIMMET WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfquery>
	<cfset attributes.branch_id = get_fire_detail.branch_id>
	<cfinclude template="../hr/ehesap/query/get_branch_ssk.cfm">
	<cfif len(get_fire_detail.department_id)>
		<cfquery name="DEPARTMENT" datasource="#DSN#">
		  SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.department_id#">
		</cfquery>
		<cfset department_name = department.department_head>
	<cfelse>
		<cfset department_name = "">
	</cfif>
	<cfif updateable>
		<cfquery datasource="#dsn#" name="fire_reasons">
			SELECT 
                REASON_ID, 
                REASON, 
                REASON_DETAIL, 
                RECORD_EMP,
                RECORD_IP, 
                RECORD_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                UPDATE_DATE 
            FROM 
                SETUP_EMPLOYEE_FIRE_REASONS 
            ORDER BY 
            	REASON
		</cfquery>
	<cfelse>
		<cfif len(get_fire_detail.in_company_reason_id)>
			<cfquery datasource="#dsn#" name="fire_reason">
				SELECT REASON FROM SETUP_EMPLOYEE_FIRE_REASONS WHERE REASON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.in_company_reason_id#">
			</cfquery>
		</cfif>
	</cfif>
	<cfif get_fire_detail.explanation_id eq 18>
		<cfif len(get_fire_detail.entry_branch_id) and len(get_fire_detail.entry_department_id)>
			<cfquery name="get_branch_name" datasource="#dsn#">
				SELECT 
					D.DEPARTMENT_HEAD,
					D.DEPARTMENT_ID,
					B.BRANCH_ID,
					B.BRANCH_NAME 
				FROM
					BRANCH B,
					DEPARTMENT D
				WHERE 
					D.BRANCH_ID = B.BRANCH_ID AND
					B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.entry_branch_id#"> AND
					D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.entry_department_id#">
			</cfquery>
			<cfset attributes.entry_branch_id = get_branch_name.BRANCH_ID>
			<cfset attributes.entry_branch_name = get_branch_name.BRANCH_NAME>
			<cfset attributes.entry_department_id = get_branch_name.DEPARTMENT_ID>
			<cfset attributes.entry_department_name = get_branch_name.DEPARTMENT_HEAD>
		<cfelse>
			<cfset attributes.entry_branch_id = "">
			<cfset attributes.entry_branch_name = "">
			<cfset attributes.entry_department_id = "">
			<cfset attributes.entry_department_name = "">
		</cfif>
	</cfif>
	<cfif get_fire_detail.is_accounting_transfer eq 1>
		<cfquery name="get_period" datasource="#dsn#">
            SELECT 
                SP.PERIOD_ID 
            FROM 
                SETUP_PERIOD SP INNER JOIN OUR_COMPANY OC ON SP.OUR_COMPANY_ID = OC.COMP_ID
                INNER JOIN BRANCH B ON OC.COMP_ID = B.COMPANY_ID
            WHERE
                B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fire_detail.entry_branch_id#"> AND
                SP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(get_fire_detail.entry_date)#">
        </cfquery>
        <cfscript>
            cmp = createObject("component","hr.cfc.create_account_period");
            cmp.dsn = dsn;
            get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:get_fire_detail.entry_branch_id,department_id:get_fire_detail.entry_department_id);
            if(not get_acc_def.recordcount)
            {
                get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:get_fire_detail.entry_branch_id);
            }	
            if(get_acc_def.recordcount)
            {
                get_account_bill_type = cmp.get_account_definiton_code_row(account_definition_id:get_acc_def.id);
            }
            else
            {
                get_account_bill_type.recordcount = 0;	
            }
        </cfscript>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'fire'>
	<cfquery name="get_in_out" datasource="#dsn#">
		SELECT 
			EIO.START_DATE,
			EIO.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.KIDEM_DATE,
	        (SELECT TOP 1 SD.DEFINITION FROM EMPLOYEES_IN_OUT_PERIOD EIOP INNER JOIN SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF SD ON EIOP.ACCOUNT_BILL_TYPE=SD.PAYROLL_ID WHERE IN_OUT_ID = EIO.IN_OUT_ID ORDER BY PERIOD_YEAR DESC) AS DEFINITION
		FROM 
			EMPLOYEES_IN_OUT EIO,
			EMPLOYEES E 
		WHERE 
			EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IN_OUT_ID#"> AND 
			EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
	</cfquery>
	<cfquery name="GET_USER_NAME" datasource="#DSN#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	</cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'whole_exit'>
	<cfparam name="attributes.branch" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department" default="">
	<cfparam name="attributes.department_id" default="">
	<cfquery name="get_branch" datasource="#dsn#">
		SELECT
			BRANCH_ID,
			BRANCH_NAME,
			SSK_OFFICE,
			SSK_NO
		FROM
			BRANCH
		WHERE
			BRANCH.SSK_NO IS NOT NULL AND
			BRANCH.SSK_OFFICE IS NOT NULL AND
			BRANCH.SSK_BRANCH IS NOT NULL AND
			BRANCH.SSK_NO <> '' AND
			BRANCH.SSK_OFFICE <> '' AND
			BRANCH.SSK_BRANCH <> ''
			<cfif not session.ep.ehesap>
				AND BRANCH_ID IN (
								SELECT
									BRANCH_ID
								FROM
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
							)
			</cfif>
		ORDER BY
			BRANCH_NAME,
			SSK_OFFICE
	</cfquery>
	<cfquery name="fire_reasons" datasource="#dsn#">
		SELECT REASON_ID,REASON FROM SETUP_EMPLOYEE_FIRE_REASONS ORDER BY REASON
	</cfquery>
	<cfparam name="attributes.exitdate" default="">
</cfif>

<script type="text/javascript">
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
		
		function filtre_gizle_goster(value)
		{
			if(value == 0){
				$('#explanation_id_td').css('display','');
				$('#explanation_id_td2').css('display','none');
				$('#is_out_statue_td').css('display','none');
				$('#explanation_id2').val('');
			}
			else if(value == 1) {
				$('#is_out_statue').attr('checked',true);
				$('#explanation_id_td2').css('display','');
				$('#is_out_statue_td').css('display','');
				$('#explanation_id_td').css('display','none');
				$('#explanation_id').val('');
			} else {
				$('#explanation_id_td').css('display','none');
				$('#explanation_id').val('');
				$('#explanation_id_td2').css('display','none');
				$('#explanation_id2').val('');
				$('#is_out_statue_td').css('display','none');
				$('#is_out_statue').val('');
			}
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function sec_form()
		{
			if ($('#test_process').is(':checked') == true)
			{
				$('#row_form').css('display','');
				$('#row_form1').css('display','');
			}
			else
			{
				$('#row_form').css('display','none');
				$('#row_form1').css('display','none');
			}	
		}
		function get_bill_type()
		{	
			var branch_id = $('#branch_id').val();
			var department_id = $('#department_id').val();
			var startdate =  $('#START_DATE').val();
			if (branch_id != "" && department_id != "")
			{ 
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_list_account_bill_type&branch_id="+branch_id+"&department_id="+department_id+"&startdate="+startdate;
				AjaxPageLoad(send_address,'ACCOUNT_BILL_TYPE_PLACE',1,'İlişkili Kod Grupları');
			}
		}
		function control()
		{
			// eger şube veya departmana ait birden fazla tanımlı kod grubu var ise 1 tanesini seçmesi gerekiyor SG 20150413
			if(document.add_in_out.account_bill_type != undefined && document.add_in_out.account_bill_type.length > 0)
			{
				var account = "";
				for (i = 0; i < document.add_in_out.account_bill_type.length; i++)
				{
					if ( document.add_in_out.account_bill_type[i].checked) 
					{
						account = document.add_in_out.account_bill_type[i].value;
						break;
					}
				}
			}
			if(account != undefined && account == "")
			{
				alert('<cf_get_lang no="1171.Muhasebe Kod Grubu">!');	
				return false;
			}
			if($('#test_process').is(':checked') == true && ($('#quiz_id').val() == "" || $('#quiz_name').val() == ""))
			{
				alert("<cf_get_lang_main no='1967.Form'>");
				return false;
			}
			return process_cat_control();
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function law_number_control()
		{	
			if(document.getElementById('law_numbers').options[4].selected == false)
			{
				$('#6111_header').css('display','none');
				$('#6111_content').css('display','none');
			}
			else
			{
				$('#6111_header').css('display','');
				$('#6111_content').css('display','');	
			}
			if(document.getElementById('law_numbers').options[6].selected == true) //5763 (<cf_get_lang no ='1190.Yeni İstihdam'>) checked = true;
			{
				$('#5763_header').css('display','');
				$('#5763_content').css('display','');
			}
			else
			{
				$('#5763_header').css('display','none');
				$('#5763_content').css('display','none');
			}
			if(document.getElementById('law_numbers').options[1].selected == true || document.getElementById('law_numbers').options[2].selected == true || document.getElementById('law_numbers').options[3].selected == true)
			{
				$('#days_5746').val("");
				$('#5746_header').css('display','');
				$('#5746_content').css('display','');
			}
			else
			{
				$('#5746_header').css('display','none');
				$('#5746_content').css('display','none');
			}
			if(document.getElementById('law_numbers').options[10].selected == true) //4691 gün seçeneği
			{
				$('#4691_header').css('display','');
				$('#4691_content').css('display','');
			}
			else
			{
				$('#days_4691').val("");
				$('#4691_header').css('display','none');
				$('#4691_content').css('display','none');
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
				alert("<cf_get_lang no ='1041.İki Kanundan Aynı Anda Yararlanamazsınız'>!");
			}
		}
		function getir_kismi_istihdam_gun()
		{
			duty_ = $('#duty_type').val();
			if(duty_ == '6')
			{
				if($('#SALARY_TYPE').val() == 0)
				{
					goster(kismi_istihdam_saat_div);
					gizle(kismi_istihdam_gun_div);
					$('#kismi_istihdam_gun').val("");
					gizle(taseron_div);
				}
				else
				{
					gizle(kismi_istihdam_saat_div);
					$('#kismi_istihdam_saat').val("");
					goster(kismi_istihdam_gun_div);
					gizle(taseron_div);
				}
			}
			else if(duty_ == '7')
			{
				gizle(kismi_istihdam_gun_div);
				gizle(kismi_istihdam_saat_div);
				goster(taseron_div);
				$('#kismi_istihdam_gun').val("");
				$('#kismi_istihdam_saat').val("");
			}
			else
			{
				gizle(kismi_istihdam_gun_div);
				gizle(kismi_istihdam_saat_div);
				gizle(taseron_div);
				$('#kismi_istihdam_gun').val("");
				$('#kismi_istihdam_saat').val("");
			}
		}
		function kismi_istihdam_()
		{
			if($('#duty_type').val() == 6)
			{
				if($('#SALARY_TYPE').val() == 0)
				{
					goster(kismi_istihdam_saat_div);
					gizle(kismi_istihdam_gun_div);
					$('#kismi_istihdam_gun').val("");
				}
				else
				{
					gizle(kismi_istihdam_saat_div);
					goster(kismi_istihdam_gun_div);
					$('#kismi_istihdam_saat').val("");
				}
			}
			else
			{
				gizle(kismi_istihdam_saat_div);
				gizle(kismi_istihdam_gun_div);
				$('#kismi_istihdam_saat').val("");
				$('#kismi_istihdam_gun').val("");
			}
		}
		function kontrol()
		{
			if((document.getElementById('law_numbers').options[1].selected == true || document.getElementById('law_numbers').options[2].selected == true || document.getElementById('law_numbers').options[3].selected == true) && $('#days_5746').val() == '')
			{
				alert("<cf_get_lang dictionary_id='54598.5746 numaralı kanun için gün seçiniz'>!");
				return false;
			}
			if((document.getElementById('law_numbers').options[10].selected == true) && $('#days_4691').val() == '')
			{
				alert("<cf_get_lang dictionary_id='54595.4691 numaralı kanun için gün seçiniz'>!");
				return false;
			}
			
			if(document.employe_work.old_branch_id.value != document.employe_work.branch_id.value)
			{
				alert("<cf_get_lang no='641.Giriş İşleminin Şubesini Bu Adımda Değiştiremezsiniz'>!\n<cf_get_lang no='642.Çalışan Giriş Çıkışlarından Çıkış İşlemi Yapmalısınız'>!");
				return false;
			}
		
			if ((employe_work.first_ssk_date.value.length != 0) && (employe_work.start_date.value.length != 0))
				if(!date_check(employe_work.first_ssk_date, employe_work.start_date, "<cf_get_lang no='640.İlk SSK lı Oluş Tarihi İşe Başlama Tarihinden Sonra Olamaz'> !"))
					return false;
			
			if($('#duty_type').val() == 7 && $('#duty_type_company_id').val() == '')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='1399.Taşeron Şirketi'>");
				return false;
			}
			else if($('#duty_type').val() == 6 )
			{
				if($('#SALARY_TYPE').val() == 0 && $('#kismi_istihdam_saat').val() == '')
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : Kısmi istihdam saat");
					return false;
				}
				else if (($('#SALARY_TYPE').val() == 1 || $('#SALARY_TYPE').val() == 2) && $('#kismi_istihdam_gun').val() == '')
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : Kısmi istihdam gün");
					return false;
				}
			}
			unformatfields();
			return process_cat_control();
		}
		
		function unformatfields()
		{
			employe_work.START_CUMULATIVE_TAX_TOTAL.value = filterNum(employe_work.START_CUMULATIVE_TAX_TOTAL.value);
			employe_work.START_CUMULATIVE_TAX.value = filterNum(employe_work.START_CUMULATIVE_TAX.value);
			employe_work.kismi_istihdam_saat.value = filterNum(employe_work.kismi_istihdam_saat.value);
			<cfif attributes.sal_year lt 2011>
				employe_work.ozel_gider_indirim.value = filterNum(employe_work.ozel_gider_indirim.value);
				employe_work.ozel_gider_vergi.value = filterNum(employe_work.ozel_gider_vergi.value);
				employe_work.mahsup_iade.value = filterNum(employe_work.mahsup_iade.value);
				employe_work.fis_toplam.value = filterNum(employe_work.fis_toplam.value);
			</cfif>
			employe_work.fazla_mesai_saat.value = filterNum(employe_work.fazla_mesai_saat.value);
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'upd_unf'>
		function kontrol()
		{
			if($('#is_5084').is(':checked')==true && $('#is_5510').is(':checked')==true)
			{
				alert("<cf_get_lang no ='1041.İki Kanundan Aynı Anda Yararlanamazsınız'>!");
				return false;
			}
			return true;
		}
		
		function employment_control(value)
		{
			if(value==1)
				$('#is_5510').attr('checked',false);
			else if(value==2)
				$('#is_5084').attr('checked',false);
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'view_fire'>
		<cfif updateable>
			function get_bill_type()
			{	
				if($('#is_accounting').is(':checked') == true) //muhasebe bilgileri aktarılsın seçili ise çalışsın
				{	
					var branch_id = $('#entry_branch_id').val();
					var department_id = $('#entry_department_id').val();
					var startdate = $('#start_date').val();
					if (branch_id != "" && department_id!= "")
					{ 
						var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_list_account_bill_type&branch_id="+branch_id+"&department_id="+department_id+"&startdate="+startdate;
						AjaxPageLoad(send_address,'ACCOUNT_BILL_TYPE_PLACE',1,'İlişkili Kod Grupları');
					}
				}
			}
			function control()
			{
				// eger şube veya departmana ait birden fazla tanımlı kod grubu var ise 1 tanesini seçmesi gerekiyor SG 20150413
				if($('#finish_date').val() != "" && $('#account_bill_type_count').val() != undefined && $('#account_bill_type_count').val() > 0)
				{
					
					var account = "";
					for (i = 0; i < document.upd_fire2.account_bill_type.length; i++)
					{
						if ( document.upd_fire2.account_bill_type[i].checked) 
						{
							account = document.upd_fire2.account_bill_type[i].value;
							break;
						}
					}
					if(account != undefined && account == "")
					{
						alert('<cf_get_lang no="1171.Muhasebe Kod Grubu">!');	
						return false;
					}
				}
				UnformatFields();
				return true;
			}
			function UnformatFields()
			{
				if(upd_fire2.finish_date.value == "")
				{
					upd_fire2.valid.value = 0;
				}
				upd_fire2.kidem_amount.value = filterNum(upd_fire2.kidem_amount.value);
				upd_fire2.salary.value = filterNum(upd_fire2.salary.value);
				upd_fire2.ihbar_amount.value = filterNum(upd_fire2.ihbar_amount.value);
				upd_fire2.KULLANILMAYAN_IZIN_AMOUNT.value= filterNum(upd_fire2.KULLANILMAYAN_IZIN_AMOUNT.value);
			}
		</cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'fire'>
		function get_bill_type()
		{	
			if(document.getElementById('is_accounting').checked == true) //muhasebe bilgileri aktarılsın seçili ise çalışsın
			{
				if(document.getElementById('entry_date').value == "")
				{
					alert("<cf_get_lang no='402.İşe Giriş Tarihi'>");
					return false;
				}
				var branch_id = document.getElementById('branch_id').value;
				var department_id = document.getElementById('department_id').value;
				var startdate =  document.getElementById('entry_date').value;
				if (branch_id != "" && department_id!= "")
				{ 
					var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ajax_list_account_bill_type&branch_id="+branch_id+"&department_id="+department_id+"&startdate="+startdate;
					AjaxPageLoad(send_address,'ACCOUNT_BILL_TYPE_PLACE',1,'İlişkili Kod Grupları');
				}
			}
		}
		/*karakter sınırı*/
		function check_form() 
		{
			if(cari.ihbar_hesap.checked==true && cari.ihbardate.value.length==0)
			{
				alert("<cf_get_lang dictionary_id='54599.İhbar Hesaplanan Kişi İçin İhbar Tarihi Seçmelisiniz'>!");
				return false;
			}
			
			if(cari.is_kidem_baz.checked==true && cari.kidem_baz.value.length==0)
			{
				alert("<cf_get_lang no ='700.Kıdem Baz Tarihi Girilmemiş Çalışan İçin Bu İşlemi Gerçekleştiremezsiniz'>!");
				return false;
			}
			if(document.getElementById('explanation_id').value == 18) //nakil işlemi ise
			{
				if(document.getElementById('entry_date').value == '' || document.getElementById('department_id').value == '')
					{
						alert("<cf_get_lang dictionary_id='54600.Başka Şubeye Geçiş Yapmak İçin Giriş Tarihi ve  Şube Seçmelisiniz'>!");
						return false;
					}
			}
			<cfif x_is_select_reason_show eq 1 and x_is_select_reason eq 1>
				if(document.getElementById('reason_id').value == '') //şirket içi gerekçe boş ise
				{
					alert("<cf_get_lang dictionary_id='54601.Şirket İçi Gerekçe Seçmelisiniz'>!");
					return false;
				}
			</cfif>
			
			// eger şube veya departmana ait birden fazla tanımlı kod grubu var ise 1 tanesini seçmesi gerekiyor SG 20150413
			if(document.getElementById('account_bill_type_count').value > 0)
			{
				var account = "";
				for (i = 0; i < document.getElementById('account_bill_type_count').value; i++)
				{
					if ( document.cari.account_bill_type[i].checked) 
					{
						account = document.cari.account_bill_type[i].value;
						break;
					}
				}
				if(account != undefined && account == "")
				{
					alert('<cf_get_lang no="1171.Muhasebe Kod Grubu">!');	
					return false;
				}
			}
			
			StrLen = cari.fire_detail.value.length;
			if (StrLen == 1 && cari.fire_detail.value.substring(0,1) == " ") 
			{
				cari.fire_detail.value = "";
				StrLen = 0;
			}
			return true;
		}
		function is_check(deger)
		{
			if(deger == 18)
			{
				document.cari.action = "";
				gizle1.style.display = '';
				gizle2.style.display = '';
				gizle3.style.display = '';
				gizle4.style.display = '';
				gizle5.style.display = '';
				gizle6.style.display = '';
				gizle7.style.display = '';
				gizle_kod_grubu.style.display = '';
				document.cari.action = "<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_fire</cfoutput>";//nakil ise direk kayıt ekranına yönlendir
			}
			else 
			{
				document.cari.action = "";
				gizle1.style.display = 'none';
				gizle2.style.display = 'none';
				gizle3.style.display = 'none';
				gizle4.style.display = 'none';
				gizle5.style.display = 'none';
				gizle6.style.display = 'none';
				gizle7.style.display = 'none';
				gizle_kod_grubu.style.display = 'none';
				document.cari.action = "<cfoutput>#request.self#?fuseaction=ehesap.popup_form_fire2</cfoutput>";//nakil değil ise ücret işlemlerinin yapıldığı ekrana yönlendir
			}
		}
		function nakil_tarih_change()
		{
			document.getElementById('entry_date').value = date_add('d',1,document.getElementById('finishdate').value);
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'whole_exit'>
		function listele()
		{
			if(document.whole_exit_form.branch.value != '')
			{
				dep = '';
				if(document.getElementById('department').value!='')
				{
				dep = '&department_id='+document.getElementById('department').value;
				}
				var send_adress='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_work_exit_list&branch_id='+document.whole_exit_form.branch.value+dep;</cfoutput>
				AjaxPageLoad(send_adress,'list_branch_employee',1,'Şube Çalışanları Listeleniyor.');
			}
		}
		function list_control()
		{
			if(isDefined('worker_count')==false)
			{
				alert("<cf_get_lang dictionary_id='54602.Seçtiğiniz Şubede Çalışan Bulunamadı'>!");
				return false;
			}
			if(document.whole_exit_form.branch.value=='')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='41.Şube'>");
				return false;
			}
			if(document.whole_exit_form.exitdate.value=='')
			{
				alert('<cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="1641.Çıkış Tarihi">');
				return false;
			}
			if(document.whole_exit_form.pass_branch.checked == true)
			{
				if(document.whole_exit_form.entry_date.value == '' || document.whole_exit_form.department_id.value == '')
				{
					alert('<cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="216.Giriş Tarihi"> - <cf_get_lang_main no="41.Şube">');
					return false;
				}
			}
			return true;
		}
		
		function showDepartment(branch_id)	
		{
			var branch_id = document.getElementById('branch').value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&onchange_func=listele&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="1376.İlişkili Departmanlar">');
			}
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_fire';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_fire.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_position_in';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_position_in.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_position_in.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_fire&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.form_upd_salary';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_salary.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_emp_work.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_fire&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'in_out_id=##attributes.in_out_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#lang_array.item[464]# : ##get_emp_info(attributes.employee_id,0,0)##';
	/*if (not (attributes.fuseaction contains "popup_"))
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#lang_array.item[464]# : <a href="#request.self#?fuseaction=hr.form_upd_emp&employee_id=#attributes.employee_id#">#get_emp_info(attributes.employee_id,0,0)#</a>';
	else
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#lang_array.item[464]# : #get_emp_info(attributes.employee_id,0,0)#';*/
		
	WOStruct['#attributes.fuseaction#']['upd_unf'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd_unf']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd_unf']['fuseaction'] = 'ehesap.popup_view_unfired';
	WOStruct['#attributes.fuseaction#']['upd_unf']['filePath'] = 'hr/ehesap/display/unfired.cfm';
	WOStruct['#attributes.fuseaction#']['upd_unf']['queryPath'] = 'hr/ehesap/query/upd_unfired.cfm';
	WOStruct['#attributes.fuseaction#']['upd_unf']['nextEvent'] = 'ehesap.list_fire&event=upd';
	WOStruct['#attributes.fuseaction#']['upd_unf']['parameters'] = 'in_out_id=##attributes.in_out_id##';
	WOStruct['#attributes.fuseaction#']['upd_unf']['Identity'] = '#lang_array.item[538]#';
	
	WOStruct['#attributes.fuseaction#']['det_fire'] = structNew();
	WOStruct['#attributes.fuseaction#']['det_fire']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det_fire']['fuseaction'] = 'ehesap.popup_view_unfired';
	WOStruct['#attributes.fuseaction#']['det_fire']['filePath'] = 'hr/ehesap/display/unfired.cfm';
	WOStruct['#attributes.fuseaction#']['det_fire']['queryPath'] = 'hr/ehesap/query/upd_unfired.cfm';
	WOStruct['#attributes.fuseaction#']['det_fire']['nextEvent'] = 'ehesap.list_fire&event=upd';
	WOStruct['#attributes.fuseaction#']['det_fire']['parameters'] = 'in_out_id=##attributes.in_out_id##';
	WOStruct['#attributes.fuseaction#']['det_fire']['Identity'] = '#lang_array.item[538]#';
	
	WOStruct['#attributes.fuseaction#']['view_fire'] = structNew();
	WOStruct['#attributes.fuseaction#']['view_fire']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['view_fire']['fuseaction'] = 'ehesap.popup_view_fired';
	WOStruct['#attributes.fuseaction#']['view_fire']['filePath'] = 'hr/ehesap/display/fired.cfm';
	WOStruct['#attributes.fuseaction#']['view_fire']['queryPath'] = 'hr/ehesap/form/fire_action.cfm';
	WOStruct['#attributes.fuseaction#']['view_fire']['nextEvent'] = 'ehesap.list_fire&event=upd';
	WOStruct['#attributes.fuseaction#']['view_fire']['parameters'] = 'in_out_id=##attributes.in_out_id##';
	WOStruct['#attributes.fuseaction#']['view_fire']['Identity'] = '#lang_array.item[47]#';
	
	WOStruct['#attributes.fuseaction#']['fire'] = structNew();
	WOStruct['#attributes.fuseaction#']['fire']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['fire']['fuseaction'] = 'ehesap.popup_form_fire';
	WOStruct['#attributes.fuseaction#']['fire']['filePath'] = 'hr/ehesap/form/fire.cfm';
	WOStruct['#attributes.fuseaction#']['fire']['queryPath'] = 'hr/ehesap/query/upd_fire.cfm';
	WOStruct['#attributes.fuseaction#']['fire']['nextEvent'] = 'ehesap.list_fire&event=upd';
	WOStruct['#attributes.fuseaction#']['fire']['parameters'] = 'in_out_id=##attributes.in_out_id##';
	WOStruct['#attributes.fuseaction#']['fire']['Identity'] = '#lang_array.item[47]#';
	
	WOStruct['#attributes.fuseaction#']['whole_exit'] = structNew();
	WOStruct['#attributes.fuseaction#']['whole_exit']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['whole_exit']['fuseaction'] = 'ehesap.popup_work_whole_exit';
	WOStruct['#attributes.fuseaction#']['whole_exit']['filePath'] = 'hr/ehesap/display/work_whole_exit.cfm';
	WOStruct['#attributes.fuseaction#']['whole_exit']['queryPath'] = 'hr/ehesap/query/work_exit.cfm';
	WOStruct['#attributes.fuseaction#']['whole_exit']['nextEvent'] = 'ehesap.list_fire';
	WOStruct['#attributes.fuseaction#']['whole_exit']['Identity'] = '#lang_array.item[47]#';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_fire';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_fire.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_fire.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_fire';
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['text'] = '#lang_array.item[47]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['list']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.list_fire&event=whole_exit','medium');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		i = 0;
		if (get_module_power_user(48))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[350]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_list_salary_plan&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id# ','horizantal');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'ehesap.popup_list_period'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array_main.item[1399]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_list_period&in_out_id=#attributes.in_out_id#','medium');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_fuse'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[508]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_fuse&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','project');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_odenek_hr'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[453]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_odenek_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','wide2');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_kesinti_hr'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[327]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_kesinti_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','wide2');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_vergi_istisna_hr'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[139]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_vergi_istisna_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','medium');";
			i = i + 1;
		}
		if (get_worktimes_xml.property_value eq 1)
		{
			if (not listfindnocase(denied_pages,'ehesap.popup_add_emp_ext_worktimes'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[24]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_add_emp_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','list');";
				i = i + 1;
			}
		}
		else
		{
			if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_ext_worktimes'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[24]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','medium');";
				i = i + 1;
			}
		}
		if (not listfindnocase(denied_pages,'ehesap.popup_pay_history'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[281]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_pay_history&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','horizantal');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'ehesap.popup_in_out_history'))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[725]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_in_out_history&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','horizantal');";
			i = i + 1;
		}
		if (not listfindnocase(denied_pages,'ehesap.popup_list_multi_in_out'))
		{
			if (not (attributes.fuseaction contains "popup_"))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[596]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_list_multi_in_out&employee_id=#attributes.employee_id#','list');";
				i = i + 1;
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[596]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=ehesap.popup_list_multi_in_out&employee_id=#attributes.employee_id#";
				i = i + 1;
			}
		}
		if (not (attributes.fuseaction contains "popup_"))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#lang_array.item[511]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.form_upd_emp&employee_id=#attributes.employee_id#";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd_unf')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_unf'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_unf']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_unf']['icons']['add']['text'] = '#lang_array.item[1030]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd_unf']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_fire&event=add";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'view_fire')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['view_fire'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['view_fire']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['view_fire']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['view_fire']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.in_out_id#&print_type=179&iid=#attributes.employee_id#','page');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'fire')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['fire'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['fire']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['fire']['menus'][0]['text'] = '#lang_array.item[511]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['fire']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_work_detail&employee_id=#get_in_out.employee_id#','medium');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
