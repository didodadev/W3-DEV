<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
	<cfparam name="attributes.sal_mon" default="#month(now())#">
	<cfinclude template="../hr/ehesap/query/get_ssk_offices.cfm">
	
	<cfif isdefined("attributes.ssk_office")>
		<cfinclude template="../hr/ehesap/query/get_branch.cfm">
		<cfset this_month_starts = CreateDate(attributes.sal_year, attributes.sal_mon, 1)>
		<cfset this_month_ends = date_add('m',1,this_month_starts)>
		<cfinclude template="../hr/query/get_emp_codes.cfm">
		
		<cfquery name="get_all_personel" datasource="#dsn#">
			SELECT
				EMPLOYEES_IN_OUT.EMPLOYEE_ID,
				EMPLOYEES_IN_OUT.START_DATE,
				EMPLOYEES_IN_OUT.FINISH_DATE,
				EMPLOYEES_DETAIL.SEX,
				EMPLOYEES_DETAIL.TERROR_WRONGED,
				EMPLOYEES_DETAIL.SENTENCED_SIX_MONTH,
				EMPLOYEES_IN_OUT.DEFECTION_LEVEL
			FROM
				EMPLOYEES_IN_OUT
				INNER JOIN EMPLOYEES ON EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_DETAIL ON EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
				INNER JOIN BRANCH ON BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
			WHERE
				EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_ends#"> AND
				(
					EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this_month_starts#">
					OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
				)
				AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#">
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
		</cfquery>
		
		<cfif not get_all_personel.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='54638.Çalışan Kaydı Bulunamadı'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		
		<cfquery name="cirak_count" datasource="#dsn#">
			SELECT
				EMPLOYEE_ID
			FROM
				EMPLOYEES_IN_OUT
			WHERE
				SSK_STATUTE = 4
				AND EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#valuelist(get_all_personel.employee_id)#">)
		</cfquery>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_print_iskur_shop';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/print_iskur_shop.cfm';
</cfscript>
