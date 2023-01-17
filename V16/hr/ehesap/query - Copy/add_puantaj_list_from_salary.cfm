<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfif attributes.puantaj_type eq 0>
	<cfset maas_puantaj_table = "EMPLOYEES_SALARY_PLAN">
</cfif>

<cfsetting showdebugoutput="no">

<cfset puantaj_action = createObject("component", "V16.hr.ehesap.cfc.create_puantaj")>
<cfset puantaj_action.dsn = dsn />

<cfset attributes.ssk_office = urldecode(attributes.ssk_office)>
<cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>
	<cfquery name="get_hierarchy_employees" datasource="#dsn#">
		SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE HIERARCHY LIKE '#attributes.hierarchy_puantaj#%'
	</cfquery>
	<cfif get_hierarchy_employees.recordcount>
		<cfset hierarchy_emp_list = valuelist(get_hierarchy_employees.EMPLOYEE_ID)>
	<cfelse>
		<cfset hierarchy_emp_list = 0>	
	</cfif>
<cfelse>
	<cfset hierarchy_emp_list = ''>
</cfif>

<cfset branch_id_ = attributes.ssk_office>
<cfset ilk_sal_mon_ = attributes.SAL_MON>
<cfset ilk_sal_year_ = attributes.sal_year>
<!---<cfset ilk_ssk_office_ = attributes.SSK_OFFICE>--->
<cfset ilk_puantaj_type_ = attributes.puantaj_type>
<cfquery name="get_action_id" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_PUANTAJ
	WHERE
		PUANTAJ_TYPE = #ilk_puantaj_type_# AND
		SAL_MON = #ilk_sal_mon_# AND
		SAL_YEAR = #ilk_sal_year_# AND
		SSK_BRANCH_ID = #branch_id_#
		<cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>
			AND HIERARCHY = '#attributes.hierarchy_puantaj#'
		</cfif>
</cfquery>
<cfif attributes.puantaj_type eq -2><!--- fark puantaji varsada silinir bir daha yazilir --->
	<cfif get_action_id.recordcount>
		<cfset attributes.reload_off = 1>
		<cfset attributes.puantaj_id = get_action_id.puantaj_id>
		<cfinclude template="delet_puantaj.cfm">
		
		<cfquery name="get_action_id_2" datasource="#dsn#">
			SELECT
				*
			FROM
				EMPLOYEES_PUANTAJ
			WHERE
				PUANTAJ_TYPE = -3 AND
				SAL_MON = #ilk_sal_mon_# AND
				SAL_YEAR = #ilk_sal_year_# AND
				SSK_BRANCH_ID = #branch_id_#
				<cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>
					AND hierarchy_puantaj = '#attributes.hierarchy_puantaj#'
				</cfif>
		</cfquery>
		<cfif get_action_id_2.recordcount>
			<cfset attributes.reload_off = 1>
			<cfset attributes.puantaj_id = get_action_id_2.puantaj_id>
			<cfinclude template="delet_puantaj.cfm">
		</cfif>	
		<cfset get_action_id.recordcount = 0>	
	</cfif>
</cfif>

<cfquery name="get_comp_info" datasource="#DSN#">
	SELECT
		OUR_COMPANY.NICK_NAME COMP_NICK_NAME,
		OUR_COMPANY.COMPANY_NAME COMP_FULL_NAME,
		BRANCH.BRANCH_FULLNAME,
		BRANCH.BRANCH_NAME,
		BRANCH.SSK_OFFICE,
		BRANCH.SSK_NO
	FROM
		OUR_COMPANY,
		BRANCH
	WHERE
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
		BRANCH.BRANCH_ID = #branch_id_#
</cfquery>

<cfif not get_action_id.recordcount>
	<cftransaction>
		<cfquery name="ADD_PUANTAJ" datasource="#dsn#">
			INSERT INTO #main_puantaj_table#
				(
				PUANTAJ_TYPE,
				SAL_MON,
				SAL_YEAR,
				IS_ACCOUNT,
				IS_LOCKED,
 				COMP_NICK_NAME,
				COMP_FULL_NAME,
				PUANTAJ_BRANCH_NAME,
				PUANTAJ_BRANCH_FULL_NAME,
				SSK_OFFICE,
				SSK_OFFICE_NO,
                SSK_BRANCH_ID,
				HIERARCHY,
				STAGE_ROW_ID,
				IS_LOCK_CONTROL,
				PAYMENT_DATE,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
				)
			VALUES
				(
				#attributes.puantaj_type#,
				#attributes.SAL_MON#,
				#attributes.sal_year#,
				0,
				0,
 				'#get_comp_info.COMP_NICK_NAME#',
				'#get_comp_info.COMP_FULL_NAME#',
				'#get_comp_info.BRANCH_NAME#',
				'#get_comp_info.BRANCH_FULLNAME#', 
				'#get_comp_info.SSK_OFFICE#',
				'#get_comp_info.SSK_NO#',
				#attributes.SSK_OFFICE#,
				<cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>'#attributes.hierarchy_puantaj#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				1,
				<cfif isdefined("attributes.payment_day") and len(attributes.payment_day)><cfqueryparam value = "#attributes.payment_day#" CFSQLType = "CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#
				)
		</cfquery>
		<cfquery name="GET_PUANTAJ_ID" datasource="#dsn#">
			SELECT MAX(PUANTAJ_ID) AS MAX_ID FROM #main_puantaj_table#
		</cfquery>
		<cfif attributes.puantaj_type eq -2><!--- fark puantaji olusuyor ---> 
				<cfquery name="ADD_PUANTAJ" datasource="#dsn#">
					INSERT INTO #main_puantaj_table#
						(
						PUANTAJ_TYPE,
						SAL_MON,
						SAL_YEAR,
						IS_ACCOUNT,
						IS_LOCKED,
						COMP_NICK_NAME,
						COMP_FULL_NAME,
						PUANTAJ_BRANCH_NAME,
						PUANTAJ_BRANCH_FULL_NAME,
						SSK_OFFICE,
						SSK_OFFICE_NO,
						SSK_BRANCH_ID,
						HIERARCHY,
						PAYMENT_DATE,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
						)
					VALUES
						(
						-3,
						#attributes.SAL_MON#,
						#attributes.sal_year#,
						0,
						0,
						'#get_comp_info.COMP_NICK_NAME#',
						'#get_comp_info.COMP_FULL_NAME#',
						'#get_comp_info.BRANCH_NAME#',
						'#get_comp_info.BRANCH_FULLNAME#', 
						'#get_comp_info.SSK_OFFICE#',
						'#get_comp_info.SSK_NO#',
						#attributes.SSK_OFFICE#,
						<cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>'#attributes.hierarchy_puantaj#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.payment_day") and len(attributes.payment_day)><cfqueryparam value = "#attributes.payment_day#" CFSQLType = "CF_SQL_TIMESTAMP"><cfelse>NULL</cfif>,
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.userid#
						)
				</cfquery>
				<cfquery name="GET_SON_PUANTAJ_ID" datasource="#dsn#">
					SELECT MAX(PUANTAJ_ID) AS MAX_ID FROM #main_puantaj_table#
				</cfquery>
				<cfset son_puantaj_id = GET_SON_PUANTAJ_ID.MAX_ID>
		</cfif>
	</cftransaction>
	<cfset puantaj_id = GET_PUANTAJ_ID.MAX_ID>
<cfelse>
	<cfset puantaj_id = get_action_id.PUANTAJ_ID>
	<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
		<cfquery name="upd_puantaj" datasource="#dsn#">
			UPDATE 
				#main_puantaj_table# 
			SET 
				STAGE_ROW_ID = #attributes.process_stage#
			WHERE 
				PUANTAJ_ID = #puantaj_id# 
		</cfquery>
	</cfif>
</cfif>
<!--- Ödeme Günü 201091016ERU --->
<cfif isdefined("attributes.payment_day") and len(attributes.payment_day)>
	<cfquery name="upd_puantaj" datasource="#dsn#">
		UPDATE 
			#main_puantaj_table# 
		SET 
			PAYMENT_DATE = <cfqueryparam value = "#attributes.payment_day#" CFSQLType = "CF_SQL_TIMESTAMP">	 
		WHERE 
			PUANTAJ_ID = #puantaj_id# 
	</cfquery>
</cfif>
<cfset attributes.puantaj_id = puantaj_id>
<cfset attributes.action_type = "puantaj_aktarim">
<cfinclude template="../query/get_ssk_employees.cfm">
<cfset is_from_branch_puantaj = 1>
<cfset index_ = 0>
<cfloop query="GET_SSK_EMPLOYEES">
	<cfset index_ = index_ + 1>
	<cfset attributes.EMPLOYEE_ID = GET_SSK_EMPLOYEES.employee_id>
	<cfset attributes.branch_id = GET_SSK_EMPLOYEES.BRANCH_ID>
	<cfset attributes.group_id = "">
	<cfif len(GET_SSK_EMPLOYEES.PUANTAJ_GROUP_IDS)>
		<cfset attributes.group_id = "#GET_SSK_EMPLOYEES.PUANTAJ_GROUP_IDS#,">
	</cfif>
	<cfif index_ eq 1 or (index_ gt 1 and GET_SSK_EMPLOYEES.employee_id[index_ - 1] neq GET_SSK_EMPLOYEES.employee_id[index_])>
		<cfinclude template="../query/add_personal_puantaj_ajax.cfm">
	</cfif>
</cfloop>

<cfset ilk_sal_mon_ = attributes.SAL_MON>
<cfset ilk_sal_year_ = attributes.sal_year>
<cfset ilk_ssk_office_ = attributes.SSK_OFFICE>
<cfset ilk_puantaj_type_ = attributes.puantaj_type>
<cfquery name="get_action_id" datasource="#dsn#">
	SELECT
		PUANTAJ_ID
	FROM
		EMPLOYEES_PUANTAJ
	WHERE
		PUANTAJ_TYPE = #ilk_puantaj_type_# AND
		SAL_MON = #ilk_sal_mon_# AND
		SAL_YEAR = #ilk_sal_year_# AND
		SSK_BRANCH_ID = #ilk_ssk_office_#
		<cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>
			AND HIERARCHY = '#attributes.hierarchy_puantaj#'
		</cfif>
</cfquery>
<cfset attributes.puantaj_id = get_action_id.puantaj_id>
<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
<cfsavecontent variable = "description_">
	<cf_get_lang dictionary_id = "60761.Puantaj Aşama Güncelle">
</cfsavecontent>
<cf_workcube_process
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='EMPLOYEE_PUANTAJ'
	action_column='PUANTAJ_ID'
	action_id='#attributes.PUANTAJ_ID#' 
	action_page='#request.self#?fuseaction=ehesap.list_puantaj' 
	warning_description='#description_# : #attributes.PUANTAJ_ID#'>
</cfif>
<script type="text/javascript">
	adres_menu_1 = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_menu_puantaj_sube&puantaj_id=#attributes.PUANTAJ_ID#<cfif isdefined("attributes.hierarchy_puantaj") and len(attributes.hierarchy_puantaj)>&hierarchy_puantaj=#attributes.hierarchy_puantaj#</cfif>&x_select_process=#x_select_process#<cfif isdefined("attributes.x_puantaj_lock_permission") and len(attributes.x_puantaj_lock_permission)>&x_puantaj_lock_permission=#attributes.x_puantaj_lock_permission#</cfif>&x_payment_day=#attributes.x_payment_day#</cfoutput>';
	AjaxPageLoad(adres_menu_1,'menu_puantaj_1','1','Puantaj Menüsü Yükleniyor');

	adres_ = '<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_ajax_view_puantaj&puantaj_id=#attributes.PUANTAJ_ID#&x_payment_day=#attributes.x_payment_day#</cfoutput>';
	AjaxPageLoad(adres_,'puantaj_list_layer','1','Puantaj Listeleniyor');
</script>