<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_xml_page_edit fuseact="ehesap.list_salary">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.upper_salary_range" default="">
	<cfparam name="attributes.lower_salary_range" default="">
	<cfparam name="attributes.hierarchy" default="">
	<cfparam name="attributes.salary_year" default="#year(now())#">
	<cfparam name="attributes.salary_month" default="#dateformat(now(),'m')#">
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.ssk_statute" default="">
	<cfparam name="attributes.duty_type" default="">
	<cfparam name="attributes.defection_level" default="">
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department" default="">
	<cfparam name="attributes.law_numbers" default="">
	<cfparam name="attributes.law_startdate" default="">
	<cfparam name="attributes.law_finishdate" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfscript>
		url_str = "";
		if (not isdefined("attributes.keyword"))
			arama_yapilmali = 1;
		else
			arama_yapilmali = 0;
		if (not isdefined('attributes.status_isactive'))
			attributes.status_isactive = 1;
		if (len(attributes.hierarchy))
			url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
		if (len(attributes.collar_type))
			url_str = "#url_str#&collar_type=#attributes.collar_type#";
		if (len(attributes.duty_type))
			url_str = "#url_str#&duty_type=#attributes.duty_type#";
		url_str = "#url_str#&keyword=#attributes.keyword#";
		url_str = '#url_str#&status_isactive=#attributes.status_isactive#';
		url_str = '#url_str#&salary_year=#attributes.salary_year#';
		url_str = '#url_str#&salary_month=#attributes.salary_month#';
		url_str = '#url_str#&ssk_statute=#attributes.ssk_statute#';
		url_str = '#url_str#&duty_type=#attributes.duty_type#';
		url_str = '#url_str#&defection_level=#attributes.defection_level#';
		url_str = '#url_str#&upper_salary_range=#attributes.upper_salary_range#';
		url_str = '#url_str#&lower_salary_range=#attributes.lower_salary_range#';
		if (isdefined('attributes.branch_id'))
			url_str = '#url_str#&branch_id=#attributes.branch_id#';
		if (isdefined('attributes.department'))
			url_str = '#url_str#&department=#attributes.department#';
		if (isdefined('attributes.status_sabit_prim'))
			url_str = '#url_str#&status_sabit_prim=#attributes.status_sabit_prim#';
		if (isdefined('attributes.ssk_status'))
			url_str = '#url_str#&ssk_status=#attributes.ssk_status#';
		if (isdefined('attributes.collar_type'))
			url_str = '#url_str#&collar_type=#attributes.collar_type#';
		if (len(attributes.law_numbers))
			url_str = '#url_str#&law_numbers=#attributes.law_numbers#';
		if (len(attributes.law_startdate))
			url_str = '#url_str#&law_startdate=#attributes.law_startdate#';
		if (len(attributes.law_finishdate))
			url_str = '#url_str#&law_finishdate=#attributes.law_finishdate#';
		if (not session.ep.ehesap)
		{
			include "../hr/ehesap/query/get_branch_deps.cfm";
			if (get_branch_dep.recordcount)
				dep_list=ValueList(get_branch_dep.department_id);
			else
				dep_list=0;
		}
		if (arama_yapilmali)
			get_salary_list.recordcount = 0;
		else
			include "../hr/ehesap/query/get_salary_list.cfm";
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		cols_ =10;
		if (is_get_sgkno eq 1)
			cols_ = cols_ + 1;
		if (is_get_FMbilgisi eq 1)
			cols_ = cols_ + 3;
		if (is_get_kidemtrh eq 1)
			cols_ = cols_ + 1;
		if (get_salary_list.recordcount)
		{
			employee_id_list = '';
			salary_in_out_id_list = '';
			new_salary_in_out_id_list = '';
			new_employee_id_list = '';
		}
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_salary_list.recordcount#'>
	<cfif get_salary_list.recordcount>
		<cfoutput query="get_salary_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif duty_type eq 8>
				<cfset employee_id_list = listappend(employee_id_list,EMPLOYEE_ID,',')>
			<cfelse>	
				<cfset salary_in_out_id_list = listappend(salary_in_out_id_list,IN_OUT_ID,',')>
			</cfif>
		</cfoutput>
		<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
		<cfset salary_in_out_id_list=listsort(salary_in_out_id_list,"numeric","ASC",",")>
		<cfif listlen(salary_in_out_id_list)><!--- normal çalışanlar için maaş getiriliyor --->
			<cfquery name="get_maas_all" datasource="#dsn#">
				SELECT
					M#attributes.salary_month# AS MAAS,
					MONEY AS SALARY_MONEY,
					IN_OUT_ID
				FROM 
					EMPLOYEES_SALARY 
				WHERE
					IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#salary_in_out_id_list#">) AND
					PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#">
				ORDER BY
					IN_OUT_ID
			</cfquery>
			<cfset new_salary_in_out_id_list = listsort(valuelist(get_maas_all.IN_OUT_ID,','),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(employee_id_list)><!--- derece kademe tipli olanlarda maaş hesabı yapılıyor --->
			<cfscript>
				parameter_last_month_1 = CreateDateTime(attributes.salary_year,attributes.salary_month,1,0,0,0);
				parameter_last_month_30 = CreateDateTime(attributes.salary_year,attributes.salary_month,daysinmonth(createdate(attributes.salary_year,attributes.salary_month,1)),0,0,0);
			</cfscript>
			<cfquery name="get_factor_definition" datasource="#dsn#" maxrows="1">
				SELECT SALARY_FACTOR,BASE_SALARY_FACTOR,BENEFIT_FACTOR FROM SALARY_FACTOR_DEFINITION WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_1#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> 
			</cfquery>
			<cfif get_factor_definition.recordcount>
				<cfquery name="get_maas_all_new" datasource="#dsn#">
					SELECT
						EMPLOYEE_ID,
						(EXTRA+GRADE_VALUE)*#get_factor_definition.SALARY_FACTOR# MAAS
					FROM
					(
						SELECT
							EMPLOYEE_ID,
							EXTRA,
							CASE 
							WHEN STEP = 1 THEN GRADE1_VALUE
							WHEN STEP = 2 THEN GRADE2_VALUE
							WHEN STEP = 3 THEN GRADE3_VALUE
							WHEN STEP = 4 THEN GRADE4_VALUE
							END AS GRADE_VALUE
						FROM
							SALARY_FACTORS
							INNER JOIN EMPLOYEES_RANK_DETAIL ER ON SALARY_FACTORS.GRADE = ER.GRADE
						WHERE
							ER.PROMOTION_START <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> 
							AND ER.PROMOTION_FINISH >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#parameter_last_month_30#"> 
							AND ER.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#employee_id_list#">)
					)T1
					ORDER BY
						EMPLOYEE_ID
				</cfquery>
				<cfset new_employee_id_list = listsort(valuelist(get_maas_all_new.EMPLOYEE_ID,','),'numeric','ASC',',')>
			</cfif>
		</cfif>
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'det'>
	<cfif not isdefined("get_hr_detail")>
		<cfquery name="GET_HR_DETAIL" datasource="#dsn#">
			SELECT SHIFT_ID FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfquery>
	</cfif>
	<cfquery name="get_in_out" datasource="#DSN#">
		SELECT
			BRANCH_ID,
			CUMULATIVE_TAX_TOTAL,
			DEFECTION_LEVEL,
			DUTY_TYPE,
			EFFECTED_CORPORATE_CHANGE,
			FAZLA_MESAI_SAAT,
			FINISH_DATE,
			FIRST_SSK_DATE,
			FIS_TOPLAM,
			GROSS_NET,
			IS_SAKAT_KONTROL,
			IS_VARDIYA,
			MAHSUP_IADE,
			OZEL_GIDER_INDIRIM,
			OZEL_GIDER_VERGI,
			PAYMETHOD_ID,
			PDKS_NUMBER,
			PDKS_TYPE_ID,
			RETIRED_SGDP_NUMBER,
			SABIT_PRIM,
			SALARY_TYPE,
			SALARY_VISIBLE,
			SOCIALSECURITY_NO,
			SSK_STATUTE,
			START_CUMULATIVE_TAX,
			START_DATE,
			SURELI_IS_AKDI,
			SURELI_IS_FINISHDATE,
			TRADE_UNION,
			TRADE_UNION_DEDUCTION,
			TRADE_UNION_DEDUCTION_MONEY,
			TRADE_UNION_NO,
			TRANSPORT_TYPE_ID,
			USE_PDKS,
			USE_SSK,
			USE_TAX
		FROM 
			EMPLOYEES_IN_OUT 
		WHERE 
			IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	</cfquery>
	<cfscript>
		if (not isdefined("get_moneys"))
			include "../hr/ehesap/query/get_moneys.cfm";
		attributes.month_ = 'M#dateformat(now(),"m")#';
		include "../hr/ehesap/query/get_ssk_yearly.cfm";
		include "../hr/ehesap/query/get_active_shifts.cfm";
		include "../hr/ehesap/query/get_position.cfm";
		if (len(get_in_out.paymethod_id))
		{
			attributes.paymethod_id = get_in_out.paymethod_id;
			include "../hr/ehesap/query/get_paymethod.cfm";
			PAY_TEMP = "#get_paymethod.paymethod#";
		}
		else
			PAY_TEMP = "";
		attributes.sal_mon = month(now());
		attributes.sal_year = year(now());
	</cfscript>
	<cfif attributes.SAL_MON neq 1>
		<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
			SELECT 
				EMPLOYEES_PUANTAJ_ROWS.KUMULATIF_GELIR_MATRAH
			FROM
				EMPLOYEES_PUANTAJ_ROWS
				INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			WHERE 
				EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND
				EMPLOYEES_PUANTAJ.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon-1#">
			ORDER BY
				EMPLOYEE_PUANTAJ_ID DESC
		</cfquery>
	<cfelseif (attributes.sal_mon eq 1) and (year(now()) gt session.ep.period_year)>
		<cfquery name="get_kumulative" datasource="#dsn#" maxrows="1">
			SELECT 
				EMPLOYEES_PUANTAJ_ROWS.KUMULATIF_GELIR_MATRAH
			FROM
				EMPLOYEES_PUANTAJ_ROWS
				INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
			WHERE 
				EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())-1#"> AND
				EMPLOYEES_PUANTAJ.SAL_MON = 12
			ORDER BY
				EMPLOYEE_PUANTAJ_ID DESC
		</cfquery>
	<cfelseif (attributes.sal_mon eq 1) and (year(now()) eq session.ep.period_year)>
		<cfset get_kumulative.kumulatif_gelir_matrah = 0>
		<cfset get_kumulative.recordcount = 0>
	</cfif>
	<cfif get_kumulative.recordcount>
		<cfset cumulative_tax_total_= get_kumulative.kumulatif_gelir_matrah> 
	<cfelseif year(get_in_out.start_date) lt session.ep.period_year>
		<cfset cumulative_tax_total_ = 0>
	<cfelseif len(get_in_out.cumulative_tax_total)>
		<cfset cumulative_tax_total_ = get_in_out.cumulative_tax_total>
	<cfelse>
		<cfset cumulative_tax_total_ = 0>
	</cfif>
	<cfquery name="GET_KUMULATIVE_TAX" datasource="#DSN#">
		SELECT
			SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS GELIR_VERGISI
		FROM
			EMPLOYEES_PUANTAJ_ROWS
			INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
		WHERE
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
			EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND
			EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
	</cfquery>
	<cfif get_kumulative_tax.recordcount>
		<cfset gelir_wegisi = get_kumulative_tax.gelir_vergisi>
	<cfelse>
		<cfset gelir_wegisi = 0>  
	</cfif>
	<cfquery name="get_transport_types" datasource="#dsn#">
        SELECT 
        	* 
        FROM 
        (
			SELECT 
				STT1.*,
                STT2.TRANSPORT_TYPE AS UPPER_TYPE 
            FROM 
                SETUP_TRANSPORT_TYPES STT1
                INNER JOIN SETUP_TRANSPORT_TYPES STT2 ON STT1.UPPER_TRANSPORT_TYPE_ID = STT2.TRANSPORT_TYPE_ID
            WHERE
                STT1.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_in_out.branch_id#">
            UNION ALL
            SELECT 
            	*,
                TRANSPORT_TYPE AS UPPER_TYPE 
          	FROM 
                SETUP_TRANSPORT_TYPES
          	WHERE
                UPPER_TRANSPORT_TYPE_ID IS NULL
      	) ALL_TYPES
      	ORDER BY
         	UPPER_TYPE,
          	TRANSPORT_TYPE
    </cfquery>
    <cfquery name="get_pdks_types" datasource="#dsn#">
	    SELECT PDKS_TYPE_ID,PDKS_TYPE FROM SETUP_PDKS_TYPES
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
		function showDepartment(branch_id)	
		{
			var branch_id = document.search.branch_id.value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
		}
		function control_()
		{
			document.search.lower_salary_range.value = filterNum(document.search.lower_salary_range.value);
			document.search.upper_salary_range.value = filterNum(document.search.upper_salary_range.value);
			if ( ($('#law_startdate').val().length != 0)&&($('#law_finishdate').val().length != 0) )
				{return date_check($('#law_startdate'),$('#law_finishdate'),"<cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>");}
		}
		function date_view()
		{
			if($('#law_numbers').val() == '6111' || $('#law_numbers').val() == '5763')
			{
				date_.style.display = '';
			}
			else
			{
				date_.style.display = 'none';
				$('#law_startdate').val("");
				$('#law_finishdate').val("");
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_salary';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_salary.cfm';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'hr.list_emp_work_info';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/display/list_emp_work_info.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'hr/query/upd_emp_work_info.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'hr.list_salary&event=det';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'employee_id=##attributes.employee_id##&in_out_id=##attributes.in_out_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '<cfif not (fuseaction contains "popup_") and isdefined("employee_id")><a href="##request.self##?fuseaction=hr.form_upd_emp&employee_id=##employee_id##"></cfif>##get_position.employee_name##&nbsp;##get_position.employee_surname##<cfif not (fuseaction contains "popup_")></a></cfif>';
</cfscript>
