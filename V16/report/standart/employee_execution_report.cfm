<!--- Icra Raporu created by: GSO 20141001--->
<cfsetting showdebugoutput="TRUE">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.sal_mon" default="">
<cfparam name="attributes.sal_mon_end" default="">
<cfparam name="attributes.sal_year" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_code" default="">
<cfparam name="attributes.expense_code_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.is_view" default="">
<cfparam name="attributes.report_base" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company = cmp_company.get_company(is_control : 1);
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(comp_id : '#iif(len(attributes.comp_id),"attributes.comp_id",DE(""))#', ehesap_control : 1);
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
	url_str = "&is_submitted=1";
	if(len(attributes.comp_id))
		url_str = "#url_str#&comp_id=#attributes.comp_id#";
	if(len(attributes.branch_id))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if(isdefined('attributes.department') and len(attributes.department))
		url_str = "#url_str#&department=#attributes.department#";
	if(isdefined('attributes.sal_year') and len(attributes.sal_year))
		url_str = "#url_str#&sal_year=#attributes.sal_year#";
	if(isdefined('attributes.sal_mon') and len(attributes.sal_mon))
		url_str = "#url_str#&sal_mon=#attributes.sal_mon#";
	if(isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end))
		url_str = "#url_str#&sal_mon_end=#attributes.sal_mon_end#";
	if(isdefined('attributes.execution_cat') and len(attributes.execution_cat))
		url_str = "#url_str#&execution_cat=#attributes.execution_cat#";
	if(isdefined('attributes.keyword') and len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if(isdefined('attributes.expense_center_id') and len(attributes.expense_center_id))
		url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
	if(isdefined('attributes.expense_code') and len(attributes.expense_code))
		url_str = "#url_str#&expense_code=#attributes.expense_code#";
	if(isdefined('attributes.expense_code_name') and len(attributes.expense_code_name))
		url_str = "#url_str#&expense_code_name=#attributes.expense_code_name#";
	if(isdefined('attributes.is_view') and len(attributes.is_view))
		url_str = "#url_str#&is_view=#attributes.is_view#";
	if(isdefined('attributes.report_base') and len(attributes.report_base))
		url_str = "#url_str#&report_base=#attributes.report_base#";
</cfscript>
<cfif isdefined('attributes.is_submitted')>
	<cfquery name="get_execution" datasource="#dsn#">
		WITH CTE1 AS (
			<cfif attributes.report_base eq 1>
			SELECT
				EI.TC_IDENTY_NO,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				B.BRANCH_NAME,
				D.DEPARTMENT_HEAD,
				(SELECT TOP 1 POSITION_NAME FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = EPR.POSITION_CODE) AS POSITION_NAME,
				EE.commandment_type EXECUTION_CAT,
				EE.commandment_value DEBT_AMOUNT,
				ISNULL(CR.CLOSED_AMOUNT, 0) AS COMMANDMENT_ODENEN,
				ISNULL(EE.PRE_COMMANDMENT_VALUE, 0) AS PRE_COMMANDMENT_VALUE,
				EE.COMMANDMENT_ID EXECUTION_ID,
				EE.PRIORITY,
				EE.commandment_date NOTIFICATION_DATE,
				EE.COMMANDMENT_OFFICE EXECUTION_OFFICE,
				EE.IBAN_NO EXECUTION_OFFICE_IBAN,
				EE.DETAIL,
				EE.SERIAL_NO +  ' ' + EE.SERIAL_NUMBER AS  FILE_NO,
				SAT.COMMENT_PAY AS DEDUCTION_TYPE,
				SAT.AMOUNT_PAY AS DEDUCTION_VALUE,
				EE.RATE_VALUE,
				SAT.ACCOUNT_NAME,
				SAT1.ACC_TYPE_NAME,
				EPP.SAL_YEAR,
				EPP.SAL_MON,
				AA.START_DATE,
				AA.FINISH_DATE,
				EPR.EXPENSE_CODE + ' - ' + EC.EXPENSE AS EXPENSE_CODE_NAME,
				(CASE WHEN SAT.COMPANY_ID IS NOT NULL THEN C.NICKNAME WHEN SAT.CONSUMER_ID IS NOT NULL THEN CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME ELSE ''END) AS MEMBER_NAME,
				ISNULL((CASE WHEN EPRE.PAY_METHOD = 1 THEN EPRE.AMOUNT_2 WHEN EPRE.PAY_METHOD = 2 THEN EPRE.AMOUNT END),0) AS ODENEN_TOPLAM_ROW,
				ISNULL((SELECT SUM(CASE WHEN EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD = 1 THEN EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2 WHEN EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD = 2 THEN EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS_EXT.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID WHERE EE.COMMANDMENT_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE_ID AND EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE = 'COMMANDMENT' AND (EMPLOYEES_PUANTAJ.SAL_YEAR < EPP.SAL_YEAR OR (EMPLOYEES_PUANTAJ.SAL_YEAR=EPP.SAL_YEAR AND EMPLOYEES_PUANTAJ.SAL_MON <= EPP.SAL_MON))),0) AS ODENEN_TOPLAM,
				(SELECT TOP 1 EPP.SAL_YEAR FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE INNER JOIN EMPLOYEES_PUANTAJ_ROWS PR ON RE.EMPLOYEE_PUANTAJ_ID = PR.EMPLOYEE_PUANTAJ_ID INNER JOIN EMPLOYEES_PUANTAJ EPP ON EPP.PUANTAJ_ID = PR.PUANTAJ_ID  WHERE EE.COMMANDMENT_ID = re.RELATED_TABLE_ID AND re.RELATED_TABLE = 'COMMANDMENT' ORDER BY RE.EMPLOYEE_PUANTAJ_EXT_ID) AS FIRST_SAL_YEAR,
				(SELECT TOP 1 EPP.SAL_MON FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE INNER JOIN EMPLOYEES_PUANTAJ_ROWS PR ON RE.EMPLOYEE_PUANTAJ_ID = PR.EMPLOYEE_PUANTAJ_ID INNER JOIN EMPLOYEES_PUANTAJ EPP ON EPP.PUANTAJ_ID = PR.PUANTAJ_ID  WHERE EE.COMMANDMENT_ID = re.RELATED_TABLE_ID AND re.RELATED_TABLE = 'COMMANDMENT' ORDER BY RE.EMPLOYEE_PUANTAJ_EXT_ID) AS FIRST_SAL_MON
	
			FROM
				EMPLOYEES_PUANTAJ_ROWS_EXT EPRE
				INNER JOIN EMPLOYEES_PUANTAJ EPP ON EPRE.PUANTAJ_ID = EPP.PUANTAJ_ID
				INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EPRE.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID
				--INNER JOIN EMPLOYEES_IN_OUT EIO ON EPR.IN_OUT_ID = EIO.IN_OUT_ID
				INNER JOIN COMMANDMENT EE ON EE.COMMANDMENT_ID = EPRE.RELATED_TABLE_ID AND EPRE.RELATED_TABLE = 'COMMANDMENT'
				LEFT JOIN COMMANDMENT_ROWS CR ON CR.COMMANDMENT_ID = EE.COMMANDMENT_ID
				 OUTER APPLY
					(
						SELECT TOP 1 IN_OUT_ID,
						START_DATE,
						FINISH_DATE,
						DEPARTMENT_ID
						FROM EMPLOYEES_IN_OUT
						WHERE EMPLOYEE_ID = EE.EMPLOYEE_ID
						ORDER BY START_DATE DESC
					) AS AA
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EE.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = EE.EMPLOYEE_ID
				LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EPR.DEPARTMENT_ID
				LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
				LEFT JOIN SETUP_ACC_TYPE SAT1 ON SAT1.ACC_TYPE_ID = EE.TYPE_ID
				LEFT JOIN SETUP_PAYMENT_INTERRUPTION SAT ON SAT.ODKES_ID = EE.TYPE_ID
				LEFT JOIN COMPANY C ON C.COMPANY_ID = SAT.COMPANY_ID
				LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = SAT.CONSUMER_ID
				LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC ON EC.EXPENSE_CODE = EPR.EXPENSE_CODE
			WHERE
				1 = 1
				<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee') and len(attributes.employee)>
					AND EE.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
					and aa.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
				</cfif>
				<cfif len(attributes.keyword)>
					AND (EE.COMMANDMENT_OFFICE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					EE.SERIAL_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
				</cfif>
				<cfif len(attributes.comp_id)>
					AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)
				</cfif>
				<cfif len(attributes.branch_id)>
					AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
				</cfif>
				<cfif not session.ep.ehesap>
                    AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                    AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
				<cfif len(attributes.expense_code) and len(attributes.expense_code_name)>
					AND EPR.EXPENSE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_code#">
				</cfif>
				<cfif isdefined('attributes.department') and len(attributes.department)>
					AND EP.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.department#">)
				</cfif>
				<cfif isdefined('attributes.execution_cat') and len(attributes.execution_cat)>
					AND EE.COMMANDMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.execution_cat#">
				</cfif>
				<!---<cfif len(attributes.status) and attributes.status eq 1>
					AND EE.IS_ACTIVE = 1
				<cfelseif len(attributes.status) and attributes.status eq 0>
					AND EE.IS_ACTIVE = 0
				</cfif>--->
				<cfif len(attributes.sal_year)>
					AND EPP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
					AND CR.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
				</cfif>
				<cfif len(attributes.sal_mon)>
					AND EPP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
					AND CR.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				</cfif>
				<cfif len(attributes.sal_mon_end)>
					AND EPP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					AND CR.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
				</cfif>
				<cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.member_name') and len(attributes.member_name)>
					AND EE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and isdefined('attributes.member_name') and len(attributes.member_name)>
					AND EE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfif>
				<cfif isdefined('attributes.is_view') and attributes.is_view eq 1> <!--- bakiyesi olanlar--->
					AND (EE.commandment_value-ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EE.COMMANDMENT_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE_ID AND EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE = 'COMMANDMENT'),0)) > 0
                <cfelseif isdefined('attributes.is_view') and attributes.is_view eq 0>
                	AND (EE.commandment_value-ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EE.COMMANDMENT_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE_ID AND EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE = 'COMMANDMENT'),0)) <= 0
                </cfif>
			<cfelse>
				SELECT
	                EE.RECORD_DATE,
                    EE.RECORD_EMP,
                    EE.UPDATE_DATE,
                    EE.UPDATE_EMP,
                    EI.TC_IDENTY_NO,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					B.BRANCH_NAME,
					D.DEPARTMENT_HEAD,
					EE.commandment_type EXECUTION_CAT,
					ISNULL(EE.commandment_value,0) AS DEBT_AMOUNT,
					ISNULL(EE.ODENEN, 0) AS COMMANDMENT_ODENEN,
					ISNULL(EE.PRE_COMMANDMENT_VALUE, 0) AS PRE_COMMANDMENT_VALUE,
					EE.COMMANDMENT_OFFICE EXECUTION_OFFICE,
	                EE.DETAIL,
					EE.COMMANDMENT_ID EXECUTION_ID,
					EE.PRIORITY,
					EE.commandment_date NOTIFICATION_DATE,
					(SELECT TOP 1 POSITION_NAME FROM EMPLOYEE_POSITIONS EP WHERE EP.EMPLOYEE_ID = EE.EMPLOYEE_ID) AS POSITION_NAME,
					AA.START_DATE,
					AA.FINISH_DATE,
					EIOP.EXPENSE_CODE_NAME,
					ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EE.COMMANDMENT_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE_ID AND EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE = 'COMMANDMENT'),0) AS ODENEN_TOPLAM,
					(SELECT TOP 1 EP.SAL_MON FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE INNER JOIN EMPLOYEES_PUANTAJ_ROWS PR ON RE.EMPLOYEE_PUANTAJ_ID = PR.EMPLOYEE_PUANTAJ_ID INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = PR.PUANTAJ_ID  WHERE EE.COMMANDMENT_ID = re.RELATED_TABLE_ID AND re.RELATED_TABLE = 'COMMANDMENT' ORDER BY RE.EMPLOYEE_PUANTAJ_EXT_ID) AS FIRST_SAL_MON,
					(SELECT TOP 1 EP.SAL_YEAR FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE INNER JOIN EMPLOYEES_PUANTAJ_ROWS PR ON RE.EMPLOYEE_PUANTAJ_ID = PR.EMPLOYEE_PUANTAJ_ID INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = PR.PUANTAJ_ID  WHERE EE.COMMANDMENT_ID = re.RELATED_TABLE_ID AND re.RELATED_TABLE = 'COMMANDMENT' ORDER BY RE.EMPLOYEE_PUANTAJ_EXT_ID) AS FIRST_SAL_YEAR			
				FROM
					COMMANDMENT EE
					 OUTER APPLY
					(
						SELECT TOP 1 IN_OUT_ID,
						START_DATE,
						FINISH_DATE,
						DEPARTMENT_ID
						FROM EMPLOYEES_IN_OUT
						WHERE EMPLOYEE_ID = EE.EMPLOYEE_ID
						ORDER BY START_DATE DESC
					) AS AA
					--EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EE.EMP_INOUT_ID
					INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EE.EMPLOYEE_ID
					INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = EE.EMPLOYEE_ID
					LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = AA.DEPARTMENT_ID
					LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
					LEFT JOIN EMPLOYEES_IN_OUT_PERIOD EIOP ON EIOP.IN_OUT_ID = AA.IN_OUT_ID AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				WHERE
					1 = 1
					<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee') and len(attributes.employee)>
						AND EE.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
						and aa.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
					</cfif>
					<cfif len(attributes.keyword)>
						AND (EE.COMMANDMENT_OFFICE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						EE.SERIAL_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
					</cfif>
					<cfif len(attributes.comp_id)>
						AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)
					</cfif>
					<cfif len(attributes.branch_id)>
						AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)
					</cfif>
					<cfif not session.ep.ehesap>
						AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
						AND B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
					<cfif isdefined('attributes.department') and len(attributes.department)>
						AND EP.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.department#">)
					</cfif>
					<cfif isdefined('attributes.execution_cat') and len(attributes.execution_cat)>
						AND EE.COMMANDMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.execution_cat#">
					</cfif>
					<!---<cfif len(attributes.status) and attributes.status eq 1>
						AND EE.IS_ACTIVE = 1
					<cfelseif len(attributes.status) and attributes.status eq 0>
						AND EE.IS_ACTIVE = 0
					</cfif>--->
					<cfif len(attributes.expense_code) and len(attributes.expense_code_name)>
						AND EIOP.EXPENSE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_code#">
					</cfif>
					<cfif isdefined('attributes.company_id') and len(attributes.company_id) and isdefined('attributes.member_name') and len(attributes.member_name)>
						AND EE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
					</cfif>
					<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and isdefined('attributes.member_name') and len(attributes.member_name)>
						AND EE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
					</cfif>
					<cfif isdefined('attributes.is_view') and attributes.is_view eq 1> <!--- bakiyesi olanlar--->
						AND (EE.commandment_value-ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EE.COMMANDMENT_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE_ID AND EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE = 'COMMANDMENT'),0)) > 0
					<cfelseif isdefined('attributes.is_view') and attributes.is_view eq 0>
						AND (EE.commandment_value-ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EE.COMMANDMENT_ID = EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE_ID AND EMPLOYEES_PUANTAJ_ROWS_EXT.RELATED_TABLE = 'COMMANDMENT'),0)) <= 0
					</cfif>
			</cfif>
		),
            CTE2 AS (
            	SELECT
                	CTE1.*,
                    	ROW_NUMBER() OVER (	ORDER BY
                        	EMPLOYEE_NAME, EMPLOYEE_SURNAME,EXECUTION_ID, <cfif attributes.report_base eq 1>SAL_YEAR, SAL_MON,</cfif> PRIORITY
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
<cfelse>
	<cfset get_execution.recordcount = 0>
	<cfset get_execution.query_count = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_execution.query_count#'>
<cfform name="form" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cfsavecontent variable='title'><cf_get_lang dictionary_id='39940.İcra Raporu'></cfsavecontent>
	<cf_report_list_search id="search" title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">							 
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">	
								<input name="is_submitted" id="is_submitted" type="hidden" value="1">						
									<div class="form-group">										  
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
										<div class="col col-12 col-xs-12">
											<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput><cfif isdefined('attributes.in_out_id') and len(attributes.in_out_id) and isdefined('attributes.employee') and len(attributes.employee)>#attributes.in_out_id#</cfif></cfoutput>">
												<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput><cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee') and len(attributes.employee)>#attributes.employee_id#</cfif></cfoutput>">
												<input type="text" name="employee" id="employee" value="<cfoutput><cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee') and len(attributes.employee)>#attributes.employee#</cfif></cfoutput>" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID,IN_OUT_ID','employee_id,in_out_id','ara_form','3','300');">
												<a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=form.in_out_id&field_emp_id=form.employee_id&field_emp_name=form.employee','list');return false"></a>
											</div>
										</div>
									</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
									<div class="col col-12 col-xs-12">
										<select name="execution_cat" id="execution_cat">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif isdefined('attributes.execution_cat') and attributes.execution_cat eq 1> selected</cfif>><cf_get_lang dictionary_id='39719.İcra'></option> 
											<option value="0" <cfif isdefined('attributes.execution_cat') and attributes.execution_cat eq 0> selected</cfif>><cf_get_lang dictionary_id='45514.Nafaka'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38734.Display'></label>
									<div class="col col-12 col-xs-12">
										<select name="is_view" id="is_view">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value="1" <cfif attributes.is_view eq 1>selected</cfif>><cf_get_lang dictionary_id='47402.Bakiyesi Olanlar'></option>
											<option value="0" <cfif attributes.is_view eq 0>selected</cfif>><cf_get_lang dictionary_id='60700.Bakiyesi Olmayanlar'></option>
										</select>
									</div>
								</div>											
							</div>								
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group" id="item-report-date">
									<label class="col col-12 col-xs-12" id="rapor_tarih"><cf_get_lang dictionary_id='58690.Tarih aralığı'>*</label>
									<div class="col col-4 padding-right-5">
										<select name="sal_mon" id="sal_mon">
											<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop from="1" to="12" index="i">
												<cfoutput>												
													<option value="#i#" <cfif (isdefined("attributes.sal_mon") and attributes.sal_mon eq i) or (not isdefined("attributes.sal_mon") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
												</cfoutput>
											</cfloop>
										</select>
									</div>
									<div class="col col-4 padding-right-5">
										<select name="sal_mon_end" id="sal_mon_end">
											<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop from="1" to="12" index="i">
												<cfoutput>												
													<option value="#i#" <cfif (isdefined("attributes.sal_mon_end") and attributes.sal_mon_end eq i) or (not isdefined("attributes.sal_mon_end") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
												</cfoutput>
											</cfloop>
										</select>
									</div>
									<div class="col col-4 padding-right-5">
										<select name="sal_year" id="sal_year">
											<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop from="#year(now())-3#" to="#year(now())+3#" index="i">
												<cfoutput>
													<option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
												</cfoutput>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									<div class="col col-12">
										<select name="report_base" id="report_base" onchange="change_filter()">
											<option value="1" <cfif isdefined("attributes.report_base") and attributes.report_base eq 1>selected</cfif>><cf_get_lang dictionary_id='54938.Aylar Bazında'></option>
											<option value="0" <cfif isdefined("attributes.report_base") and attributes.report_base eq 0>selected</cfif>><cf_get_lang dictionary_id='60701.İcralar Bazında'></option>
										</select>
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
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
								<cf_wrk_report_search_button is_excel='1' search_function='control()' insert_info='#message#' button_type='1'>   
						</div>
					</div>	
					<cf_big_list_search_detail_area>
						<div class="row">
							<div class="col col-12 col-xs-12">
								<div class="row formContent">
									<div class="row" type="row">
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
												<div class="col col-12 col-xs-12">
													<div class="multiselect-z2">
														<cf_multiselect_check 
															query_name="get_company"  
															name="comp_id"
															width="140" 
															option_value="COMP_ID"
															option_name="COMPANY_NAME"
															option_text="#getLang('main',322)#"
															value="#iif(isdefined('attributes.comp_id'),'attributes.comp_id',DE(''))#"
															onchange="get_branch_list(this.value)">
													</div>
												</div>									
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>	
												<div class="col col-12 col-xs-12">
													<div class="input-group">
														<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput>#attributes.expense_center_id#</cfoutput>">
														<input type="hidden" name="expense_code" id="expense_code" value="<cfoutput>#attributes.expense_code#</cfoutput>">
														<cfinput type="Text" name="expense_code_name" value="#attributes.expense_code_name#">
														<a href="javascript://" class="input-group-addon btnPointer icon-ellipsis"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=form.expense_center_id&field_code=form.expense_code&field_acc_code_name=form.expense_code_name</cfoutput>','list')"></a>
													</div>
												</div>
											</div>
										</div>
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12">						
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
												<div class="col col-12 col-xs-12">
													<div id="BRANCH_PLACE" class="multiselect-z2">
															<cf_multiselect_check 
															query_name="get_branches"  
															name="branch_id"
															width="140" 
															option_value="BRANCH_ID"
															option_name="BRANCH_NAME"
															option_text="#getLang('main',322)#"
															value="#iif(isdefined('attributes.branch_id'),'attributes.branch_id',DE(''))#">
													</div>		
												</div>							
											</div>
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57519.Cari Hesap"></label>	
												<div class="col col-12 col-xs-12">
													<div class="input-group">
														<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
														<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
															<cfinput name="member_name" id="member_name" type="text" value="#attributes.member_name#" style="width:160px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','company_id','','3','180','');">
														<a href="javascript://" class="input-group-addon btnPointer icon-ellipsis"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=form.member_name&field_consumer=form.consumer_id&field_comp_id=form.company_id&field_member_name=form.member_name</cfoutput>','list')"></a>
													</div>
												</div>
											</div>
										</div>
										<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
											<div class="form-group">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57572.Departman"></label>
												<div class="col col-12 col-xs-12">
													<div class="multiselect-z2" id="DEPARTMENT_PLACE">
															<cf_multiselect_check 
															query_name="get_department"  
															name="department"
															width="140" 
															option_text="#getLang('main',322)#" 
															option_value="department_id"
															option_name="department_head"
															value="#iif(isdefined('attributes.department'),'attributes.department',DE(''))#">
													</div>
												</div>									
											</div>
										</div>																							
									</div>						
								</div>
							</div>
						</div>		
					</cf_big_list_search_detail_area>		
				</div>
			</div>					
		</cf_report_list_search_area>	
	</cf_report_list_search>
</cfform>

<cfif IsDefined("attributes.is_submitted")>
	<cfif attributes.is_excel eq 1>
		<cfset filename="employee_execution_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-16">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_execution.recordcount>
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
	<cf_report_list>			
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
				<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='57572.Departman'></th>
				<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
				<th ><cf_get_lang dictionary_id='38923.İşe Giriş Tarihi'></th>
				<th><cf_get_lang dictionary_id='39464.İşten Çıkış Tarihi'></th>
				<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
				<th><cf_get_lang dictionary_id='40250.İcra Tipi'></th>
				<th><cf_get_lang dictionary_id='57485.Öncelik'></th>
				<th><cfoutput>#getLang('finance',187)#</cfoutput> </th>
				<th><cf_get_lang dictionary_id='40295.İcra Dairesi'></th>
				<cfif attributes.report_base eq 1>
					<th><cfoutput>#getLang('ch',159)#</cfoutput></th>
					<th><cf_get_lang dictionary_id='38986.Banka Bilgileri'></th>
					<th><cfoutput>#getLang('finance',196)#</cfoutput></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<cfif attributes.report_base eq 1>
					<th><cf_get_lang dictionary_id='40546.Hesap Tipi'></th>
					<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='53083.Kesinti'> <cf_get_lang dictionary_id='58593.Tarihi'></th>
				<th><cf_get_lang dictionary_id='60702.Bordro Dönemi'></th>
				<th><cf_get_lang dictionary_id='57492.Toplam'></th>
				<th><cf_get_lang dictionary_id='50037.Ödenen Tutar'></th>
				<th><cf_get_lang dictionary_id='58444.Kalan'></th>
				<cfif attributes.report_base eq 0>
					<cfset sal_mon=month(now())>
					<cfset sal_year=year(now())>					
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cfoutput>#getLang('hr',727)#</cfoutput></th>
					<th><cf_get_lang dictionary_id='40479.Güncelleme Tarihi'></th>
					<th><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfif get_execution.recordcount>
				<cfset temp_execution_id = 0>
				<cfset temp_kalan = 0>		   
				<cfoutput query="get_execution">
					<cfset temp_kalan = debt_amount - odenen_toplam - COMMANDMENT_ODENEN - PRE_COMMANDMENT_VALUE>
					<tr>
					<td>#rownum#</td>
					<td>#tc_identy_no#</td>
					<td>#employee_name# #employee_surname#</td>
					<td>#branch_name#</td>
					<td>#department_head#</td>
					<td>#position_name#</td>
					<td>#dateformat(start_date,dateformat_style)#</td>
					<td>#dateformat(finish_date,dateformat_style)#</td>
					<td>#expense_code_name#</td>
					<td><cfif execution_cat eq 1><cf_get_lang dictionary_id='50363.İcra'><cfelseif execution_cat eq 2><cf_get_lang dictionary_id='45514.Nafaka'></cfif></td>
					<td>#priority#</td>
					<td>#dateformat(notification_date,dateformat_style)#</td>
					<td>#execution_office#</td>
					<cfif attributes.report_base eq 1>
						<td>#file_no#</td>
						<td>#execution_office_iban#</td>
						<td>
							<cfif deduction_type eq 1><cf_get_lang dictionary_id='39473.Yüzde'><cfelseif deduction_type eq 2><cf_get_lang dictionary_id='39993.Eksi'></cfif>-#deduction_value#
						</td>
					</cfif>
					<td>#detail#</td>
					<cfif attributes.report_base eq 1>
						<td>#acc_type_name#</td>
						<td>#account_name#</td>
						<td>#member_name#</td>
					</cfif>
					<td><cfif len(first_sal_year)>#dateformat(createdate(first_sal_year,first_sal_mon,daysinmonth(createdate(first_sal_year,first_sal_mon,01))),dateformat_style)#</cfif></td>
					<td>#sal_year# / #ListGetAt(ay_list(),sal_mon,',')#</td>
					<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(debt_amount)#"></td>
					<td><cfif attributes.report_base eq 1><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(odenen_toplam_row + COMMANDMENT_ODENEN)#"><cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(odenen_toplam + COMMANDMENT_ODENEN + PRE_COMMANDMENT_VALUE)#"></cfif></td>
					<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(temp_kalan)#"></td>
					<cfif attributes.report_base eq 0>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<td>#get_emp_info(record_emp,0,0)#</td>
						<td>#dateformat(update_date,dateformat_style)#</td>
						<td>#get_emp_info(update_emp,0,0)#</td>
					</cfif>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="25">
						<cfif isdefined('attributes.is_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.filtre ediniz'>!</cfif>
					</td>
				</tr>
			</cfif>
		</tbody>
	</cf_report_list>
</cfif>
<cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#attributes.fuseaction##url_str#">
<script type="text/javascript">
	$(document).ready(function()
	{		
		change_filter();			
	})
	function control()
	{
		var salmon = parseFloat(document.getElementById("sal_mon").value);
		var salmonend = parseFloat(document.getElementById("sal_mon_end").value);
		var salyear = parseFloat(document.getElementById("sal_year").value);

		if($('#report_base').val() == 1)
		{	
			if($('#sal_mon').val() == 0 || $('#sal_mon').val() == 0 || $('#sal_year').val() == 0){
				alert('<cf_get_lang dictionary_id='29722.Please fill in the mandatory fields.'>');
				return false;	
			}	
			if (salmon > salmonend) 
			{ 
				alert("<cf_get_lang dictionary_id ='40467.Başlangıç Tarihi Bitiş Tarihinden Büyük Olmamalıdır'>");
				return false;
			}		
		}	
			if(document.form.is_excel.checked==false)
			{
				document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.employee_execution_report"
				return true;
			}
			else
			{
				document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_employee_execution_report</cfoutput>"
			}
		return true;
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
	function change_filter()
	{
		if($('#report_base').val() == 1)
			$('#item-report-date').css('display','');
		else
			$('#item-report-date').css('display','none');
	}
</script>
