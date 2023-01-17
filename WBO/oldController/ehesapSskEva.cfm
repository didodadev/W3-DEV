<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<!-- sil --><cf_xml_page_edit fuseact="ehesap.popup_ssk_eva"><!-- sil -->
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
	<cfparam name="attributes.salary_year" default="#year(now())#">
	<cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
	<cfif isdefined("attributes.ssk_office")>
		<cfscript>
			bu_ay_basi = CreateDate(attributes.salary_year, attributes.sal_mon,1);
			bu_ay_sonu = date_add("d",DaysInMonth(bu_ay_basi),bu_ay_basi);
		</cfscript>
		<cfquery name="get_izins" datasource="#dsn#">
			SELECT 
				OFFTIME.EMPLOYEE_ID, SETUP_OFFTIME.EBILDIRGE_TYPE_ID, SETUP_OFFTIME.IS_PAID, SETUP_OFFTIME.SIRKET_GUN,
				OFFTIME.STARTDATE,OFFTIME.FINISHDATE
			FROM 
				OFFTIME
				INNER JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
			WHERE
				OFFTIME.VALID = 1 AND 
				OFFTIME.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND 
				OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND
				OFFTIME.IS_PUANTAJ_OFF = 0
			ORDER BY 
				OFFTIME.EMPLOYEE_ID, OFFTIME.STARTDATE
		</cfquery>
		<cfinclude template="../hr/ehesap/query/get_branch.cfm">
		<cfinclude template="../hr/query/get_emp_codes.cfm">
		<cfquery name="get_offtimes" datasource="#dsn#">
		  	SELECT 
				'0' AS KANUN_NO,
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES_IDENTY.TC_IDENTY_NO,
				EMPLOYEES_PUANTAJ_ROWS.IZIN,
				EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID,
				EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS,
				EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY,
				EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY,
				EMPLOYEES_PUANTAJ_ROWS.YILLIK_IZIN_AMOUNT,
				EMPLOYEES_PUANTAJ_ROWS.IHBAR_AMOUNT,
				EMPLOYEES_PUANTAJ_ROWS.KIDEM_AMOUNT,
				EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY,
				EMPLOYEES_PUANTAJ_ROWS.SSK_NO,
				EMPLOYEES_PUANTAJ_ROWS.SALARY,
				(EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS - EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY) AS GUN_SAYISI,
				EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH,
				EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE,
				EMPLOYEES_PUANTAJ_ROWS.IS_KISMI_ISTIHDAM,
		        EMPLOYEES_IN_OUT.DUTY_TYPE
			FROM
				EMPLOYEES_PUANTAJ_ROWS
				INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
				INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID
				INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
			WHERE
				EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS < 30 AND
				(
				(EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY = 0 AND (EMPLOYEES_PUANTAJ_ROWS.IZIN > 0 OR EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE = 0))
				OR
				(EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY > 0 AND (EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS + EMPLOYEES_PUANTAJ_ROWS.IZIN) > EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY)
				)
				AND
				EMPLOYEES_IN_OUT.USE_SSK = 1 AND
				EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> AND
				EMPLOYEES_PUANTAJ.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.ssk_office,3,'-')#">
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
		UNION ALL
			SELECT 
				'5921' AS KANUN_NO,
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES.EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME,
				EMPLOYEES_IDENTY.TC_IDENTY_NO,
				EMPLOYEES_PUANTAJ_ROWS.IZIN,
				EMPLOYEES_PUANTAJ_ROWS.IZIN_PAID,
				EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS,
				EMPLOYEES_PUANTAJ_ROWS.TOTAL_SALARY,
				EMPLOYEES_PUANTAJ_ROWS.EXT_SALARY,
				EMPLOYEES_PUANTAJ_ROWS.YILLIK_IZIN_AMOUNT,
				EMPLOYEES_PUANTAJ_ROWS.IHBAR_AMOUNT,
				EMPLOYEES_PUANTAJ_ROWS.KIDEM_AMOUNT,
				EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY,
				EMPLOYEES_PUANTAJ_ROWS.SSK_NO,
				EMPLOYEES_PUANTAJ_ROWS.SALARY,
				EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY AS GUN_SAYISI,
				EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH,
				EMPLOYEES_PUANTAJ_ROWS.SALARY_TYPE,
				EMPLOYEES_PUANTAJ_ROWS.IS_KISMI_ISTIHDAM,
		        EMPLOYEES_IN_OUT.DUTY_TYPE
			FROM
				EMPLOYEES_PUANTAJ_ROWS
				INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
				INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID
				INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
			WHERE
				EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY > 0 AND		
				EMPLOYEES_PUANTAJ_ROWS.SSK_ISVEREN_HISSESI_5921_DAY < (EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS + EMPLOYEES_PUANTAJ_ROWS.IZIN) AND
				EMPLOYEES_IN_OUT.USE_SSK = 1 AND
				EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> AND
				EMPLOYEES_PUANTAJ.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				EMPLOYEES_PUANTAJ.SSK_OFFICE + '-' + EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = '#attributes.SSK_OFFICE#'
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
			ORDER BY
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
		</cfquery>
		<cfset total_pages = ceiling(get_offtimes.recordcount / 20)>
		<cfset curr_page = 0>
		<cfif not get_offtimes.RECORDCOUNT>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='54639.Bu Ay İzin Kaydı Bulunamadı'>!");
				history.back();
			</script>
			<cfexit method="exittemplate">
		</cfif>
	</cfif>
</cfif>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_ssk_eva';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/ssk_eva.cfm';
</cfscript>
