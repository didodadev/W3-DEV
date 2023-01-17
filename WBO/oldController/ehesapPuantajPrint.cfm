<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cf_get_lang_set module_name="ehesap">
	<cfparam name="attributes.sal_year" default="#year(now())#">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.department" default="">
	<cfparam name="attributes.ssk_office" default="">
	<cfparam name="attributes.is_submit" default="0">
	<cfparam name="attributes.duty_type" default="">
	<cfparam name="attributes.collar_type" default="">
	<cfparam name="attributes.title_id" default="">
	<cfif month(now()) eq 1>
		<cfparam name="attributes.sal_mon" default="1">
	<cfelse>
		<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	</cfif>
	<cfscript>
		cmp_title = createObject("component","hr.cfc.get_titles");
		cmp_title.dsn = dsn;
		get_title = cmp_title.get_title();
		include "../hr/ehesap/query/get_ssk_offices.cfm";
	</cfscript>
	<cfquery name="GET_DET_FORM" datasource="#dsn3#">
	  	SELECT 
			SPF.TEMPLATE_FILE,
			SPF.FORM_ID,
			SPF.NAME,
			SPF.PROCESS_TYPE,
			SPF.MODULE_ID,
			SPFC.PRINT_NAME
		FROM 
			SETUP_PRINT_FILES SPF
			INNER JOIN #dsn_alias#.SETUP_PRINT_FILES_CATS SPFC ON SPFC.PRINT_TYPE = SPF.PROCESS_TYPE
		WHERE
			SPF.ACTIVE = 1 AND
			SPFC.PRINT_TYPE = 180
	</cfquery>
	<cfif isdefined("attributes.ssk_office") and Len(attributes.ssk_office)>
		<cfquery name="get_departmant" datasource="#dsn#">
            SELECT 
                DEPARTMENT_ID, 
                DEPARTMENT_HEAD,
                HIERARCHY_DEP_ID
            FROM 
                DEPARTMENT 
            WHERE 
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.ssk_office, 3, '-')#"> 
                AND DEPARTMENT_STATUS = 1
            ORDER BY 
                HIERARCHY_DEP_ID,DEPARTMENT_HEAD
        </cfquery>
	</cfif>
	<cfif isdefined("attributes.is_submit") and attributes.is_submit eq 1>
		<cfset puantaj_gun_ = daysinmonth(createdate(attributes.sal_year_end,attributes.sal_mon_end,1))>
		<cfif not isdefined("attributes.puantaj_id")>
			<cfset puantaj_start_ = createodbcdatetime(createdate(attributes.sal_year,attributes.sal_mon,1))>
			<cfset puantaj_finish_ = createodbcdatetime(date_add("d",1,createdate(attributes.sal_year_end,attributes.sal_mon_end,puantaj_gun_)))>
		</cfif>
		<cfset bu_ay_sonu = createodbcdatetime(date_add("d",1,createdate(attributes.sal_year_end,attributes.sal_mon_end,puantaj_gun_)))>
		<cfquery name="get_puantaj_rows" datasource="#dsn#">
			SELECT
				EMPLOYEES_PUANTAJ_ROWS.*,
				EMPLOYEES_PUANTAJ.*,
				EMPLOYEES_IN_OUT.IN_OUT_ID,
				EMPLOYEES_IN_OUT.USE_SSK,
				EMPLOYEES_IN_OUT.START_DATE,
				EMPLOYEES_IN_OUT.FINISH_DATE,
				EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
				EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
				EMPLOYEES.HIERARCHY,
				EMPLOYEES.EMPLOYEE_NO,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES.GROUP_STARTDATE,
				EMPLOYEES.KIDEM_DATE,
				EMPLOYEES_IDENTY.TC_IDENTY_NO,
				EMPLOYEES_IDENTY.BIRTH_DATE,
				BRANCH.*,
				EMPLOYEES_IN_OUT.IS_5084 AS KISI_5084,
				EMPLOYEES_IN_OUT.IS_5510 AS KISI_5510,
				EMPLOYEES_IN_OUT.START_CUMULATIVE_TAX,
				EMPLOYEES_IN_OUT.IS_START_CUMULATIVE_TAX,
				EMPLOYEES_IN_OUT.USE_PDKS,
				BRANCH.SSK_NO AS B_SSK_NO,
				DEPARTMENT.DEPARTMENT_HEAD,
				OUR_COMPANY.COMPANY_NAME,
				OUR_COMPANY.WEB,
				OUR_COMPANY.ADDRESS,
				OUR_COMPANY.T_NO
			FROM
				EMPLOYEES_PUANTAJ_ROWS
				INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
				INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID
				INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
				INNER JOIN DEPARTMENT ON EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
				INNER JOIN BRANCH ON BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
				INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
			WHERE
				1 = 1
				<cfif not isdefined("attributes.puantaj_id")>
					AND EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#">
					AND (EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
				</cfif>
				<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
					AND EMPLOYEES.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.employee_name#%">
				</cfif>
				<cfif isdefined("attributes.collar_type") and Len(attributes.collar_type)>
					AND EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">)
				</cfif>
				<cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
					AND EMPLOYEES_IN_OUT.DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.duty_type#">
				</cfif>
				<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
					AND EMPLOYEES_PUANTAJ_ROWS.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.title_id#">)
				</cfif>
				<cfinclude template="../hr/query/get_emp_codes.cfm">
				<cfif fusebox.dynamic_hierarchy>
					<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
						<cfif database_type is "MSSQL">
							AND ('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
						<cfelseif database_type is "DB2">
							AND ('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
						</cfif>
					</cfloop>
				<cfelse>
					<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
						<cfif database_type is "MSSQL">
							AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
						<cfelseif database_type is "DB2">
							AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
						</cfif>
					</cfloop>
				</cfif>
				<cfif not isdefined("attributes.puantaj_id") and not isdefined("attributes.list_employee_id")>
					AND (
						(EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						OR
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
							EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
							(
								EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
								(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
							)
						)
						OR
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
							(
								EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
								(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
							)
						)
						OR
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
							EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
							EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
						)
					)
					<cfif isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE)>
						AND EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.ssk_office,3,'-')#">
					</cfif>
				<cfelseif isdefined("attributes.puantaj_id")>
					AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
				<cfelseif attributes.style is 'list' and isdefined("attributes.list_employee_id")>
					AND (
						(EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						OR
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
							EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
							(
								EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
								(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
							)
						)
						OR
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
							(
								EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
								(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
							)
						)
						OR
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
							EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
							EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
						)
					)
					AND EMPLOYEES.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.list_employee_id#">)
				</cfif>
				<cfif not session.ep.ehesap>
					AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					<cfif database_type is "MSSQL">
						AND ((EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' OR EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#' OR EMPLOYEES.EMPLOYEE_NO = '#attributes.keyword#')
					<cfelse>
						AND ((EMPLOYEES.EMPLOYEE_NAME || ' ' || EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' OR EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#')
					</cfif>
				</cfif>
				<cfif isdefined('attributes.department') and len(attributes.department)>
					AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
				</cfif>
			ORDER BY
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME
		</cfquery>
		<cfif not get_puantaj_rows.recordcount>
			<script type="text/javascript">
				document.body.innerHTML = "";
				window.location.href = "<cfoutput>#request.self#?fuseaction=ehesap.popup_puantaj_print&keyword=#attributes.keyword#&form_type=#attributes.form_type#&sal_mon=#attributes.sal_mon#&department=#attributes.department#&ssk_office=#attributes.ssk_office#</cfoutput>";
				alert("<cf_get_lang no='766.Puantaj Kaydı Bulunamadı'>!");
			</script>
			<cfabort>
		</cfif>
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='20'>
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfset attributes.action_id = get_puantaj_rows.employee_puantaj_id>
		<cfquery name="GET_FORM" datasource="#dsn3#">
			SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#"> ORDER BY IS_XML,NAME
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		function showDepartment(branch_id)	
		{
			var branch_id = list_getat($('#ssk_office').val(), 3, '-');
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&upper_dep=1&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,"<cf_get_lang no='1376.İlişkili Departmanlar'>");
			}
			else
			{
				var myList = document.getElementById("department");
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
				myList.appendChild(txtFld);
			}
		}
	
		function sbmtKontrol()
		{
			if ($('#form_type').val() == "")
			{
				alert("<cf_get_lang no='1378.Lütfen Yazıcı Belge Tipi seçin'>!");
				return false;
			}
			return true;
		}
		function change_mon(i)
		{
			$('#sal_mon_end').val(i);
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
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_puantaj_print';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/popup_puantaj_print.cfm';
</cfscript>
