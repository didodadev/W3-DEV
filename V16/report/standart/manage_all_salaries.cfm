<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.manage_all_salaries">

<script type="text/javascript">
function gonder(tip)
{ 
	windowopen('','wide','toplu_dekont_window');
	employee.action='<cfoutput>#request.self#?fuseaction=ehesap.popup_add_collacted_dekont&dekont_type='+tip+'&sal_mon='+document.employee.sal_mon.value+'&sal_year='+document.employee.sal_year.value+'</cfoutput>';
	employee.target='toplu_dekont_window';
	employee.submit();
	employee.action='<cfoutput>#request.self#?fuseaction=report.manage_all_salaries&iframe=1</cfoutput>';
	employee.target='';
	return true;
}
</script>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.sal_mon" default="#dateformat(now(),'m')-1#">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.salary_type" default="1">
<cfif attributes.sal_mon EQ 0>		<!---bir onceki ay değerinin alması için 1 cıkarıldığında sal_mon'un sıfır kalmasının önune geçebilmek için --->
	<cfset attributes.sal_mon = 1>
</cfif>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfinclude template="../../hr/ehesap/query/get_ssk_offices.cfm">

<cfquery name="get_emp_branches" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset emp_branch_list = valuelist(get_emp_branches.branch_id)>	
	
<cfscript>
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department();
	cmp_func = createObject("component","V16.hr.cfc.get_functions");
	cmp_func.dsn = dsn;
	get_units = cmp_func.get_function();
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	titles = cmp_title.get_title();
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cats = cmp_pos_cat.get_position_cat();
	
	puantaj_gun_ = daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1));
	puantaj_start_ = createodbcdatetime(createdate(attributes.sal_year,attributes.sal_mon,1));
	puantaj_finish_ = createodbcdatetime(date_add("d",1,createdate(attributes.sal_year,attributes.sal_mon,puantaj_gun_)));
</cfscript>

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_people" datasource="#dsn#">
		SELECT
			1 AS TYPE,
			E.EMPLOYEE_ID,
			EI.TC_IDENTY_NO,
			EIO.USE_SSK,
			EIO.IN_OUT_ID,
			EIO.START_DATE,
			EIO.FINISH_DATE,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			ES.M#attributes.sal_mon# AS MAAS,
			ES.MONEY,
			EIO.GROSS_NET,
			EIO.SOCIALSECURITY_NO,
			EPR.EMPLOYEE_PUANTAJ_ID,
			EPR.TOTAL_DAYS,
			EPR.IZIN,
			EPR.NET_UCRET,
			EPR.EXT_SALARY,
			EPR.TOTAL_SALARY,
			EPR.AVANS,
			EPR.OZEL_KESINTI,
			EPR.VERGI_INDIRIMI,
			EPR.VERGI_IADESI,
            ISNULL(EPR.BES_ISCI_HISSESI,0) AS BES_ISCI_HISSESI,
			EPR.TOTAL_PAY,
			EPR.TOTAL_PAY_TAX,
			EPR.TOTAL_PAY_SSK,
			EPR.TOTAL_PAY_SSK_TAX,
            EPR.KIDEM_AMOUNT_NET,
            EPR.IHBAR_AMOUNT_NET,
            EPR.YILLIK_IZIN_AMOUNT_NET,
			#dsn#.Get_Dynamic_Language(B.BRANCH_ID,'#session.ep.language#','B','BRANCH_NAME',NULL,NULL,B.BRANCH_NAME) AS BRANCH_NAME,
			#dsn#.Get_Dynamic_Language(D.DEPARTMENT_ID,'#session.ep.language#','D','DEPARTMENT_HEAD',NULL,NULL,D.DEPARTMENT_HEAD) AS DEPARTMENT_HEAD,
			EIO.BRANCH_ID,
			EIO.PUANTAJ_GROUP_IDS,
			#dsn#.Get_Dynamic_Language(EPP.POSITION_CAT_ID,'#session.ep.language#','EPP','POSITION_NAME',NULL,NULL,EPP.POSITION_NAME) AS POSITION_NAME,
			#dsn#.Get_Dynamic_Language(SPC.POSITION_CAT_ID,'#session.ep.language#','SPC','POSITION_CAT',NULL,NULL,SPC.POSITION_CAT) AS POSITION_CAT,
			#dsn#.Get_Dynamic_Language(ST.TITLE_ID,'#session.ep.language#','ST','TITLE',NULL,NULL,ST.TITLE) AS TITLE,
			#dsn#.Get_Dynamic_Language(SCU.UNIT_ID,'#session.ep.language#','SCU','UNIT_NAME',NULL,NULL,SCU.UNIT_NAME) AS UNIT_NAME,

			#dsn#.Get_Dynamic_Language(POSD.DEPARTMENT_ID,'#session.ep.language#','POSD','DEPARTMENT_HEAD',NULL,NULL,POSD.DEPARTMENT_HEAD) AS POSITION_DEP,
			SBT.BANK_NAME,
			BA.BANK_BRANCH_CODE,
			BA.BANK_ACCOUNT_NO,
            BA.IBAN_NO
		FROM
			EMPLOYEES_IN_OUT EIO
			INNER JOIN EMPLOYEES E ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_SALARY ES ON EIO.IN_OUT_ID = ES.IN_OUT_ID
			INNER JOIN BRANCH B ON EIO.BRANCH_ID=B.BRANCH_ID
			INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID
			INNER JOIN EMPLOYEES_PUANTAJ_ROWS EPR ON EIO.IN_OUT_ID = EPR.IN_OUT_ID AND E.EMPLOYEE_ID=EPR.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID=EPR.PUANTAJ_ID AND B.SSK_OFFICE=EP.SSK_OFFICE AND B.SSK_NO=EP.SSK_OFFICE_NO
			LEFT JOIN EMPLOYEE_POSITIONS EPP ON EPP.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EPP.IS_MASTER=1
			LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EPP.POSITION_CAT_ID
			LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EPP.TITLE_ID
			LEFT JOIN SETUP_CV_UNIT SCU ON SCU.UNIT_ID = EPP.FUNC_ID
			LEFT JOIN DEPARTMENT POSD ON POSD.DEPARTMENT_ID = EPP.DEPARTMENT_ID
			LEFT JOIN EMPLOYEES_BANK_ACCOUNTS BA ON BA.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND BA.DEFAULT_ACCOUNT = 1
			LEFT JOIN SETUP_BANK_TYPES SBT ON SBT.BANK_ID = BA.BANK_ID
		WHERE
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				(E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) AND
			</cfif>
			<cfif isdefined('attributes.branch_id') and listlen(attributes.branch_id)>
				B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">) AND 
			</cfif>
			<cfif isdefined('attributes.department') and listlen(attributes.department)>
				EIO.DEPARTMENT_ID IN (#ATTRIBUTES.department#) AND
			</cfif>
			(EIO.IS_PUANTAJ_OFF = 0 OR EIO.IS_PUANTAJ_OFF IS NULL) AND
			ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
			EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
			EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
			EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND
			(EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> OR EIO.FINISH_DATE IS NULL)
			<!--- pozisyon kontrolleri --->
			<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">)
			</cfif>
			<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">)
			</cfif>
			<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">)
			</cfif>
			<cfif isdefined('attributes.position_department') and listlen(attributes.position_department)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND DEPARTMENT_ID IN (#attributes.position_department#))
			</cfif>
			<cfif isdefined('attributes.position_branch_id') and listlen(attributes.position_branch_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT POSITION_D WHERE EP.IS_MASTER = 1 AND EP.DEPARTMENT_ID = POSITION_D.DEPARTMENT_ID AND POSITION_D.BRANCH_ID IN (#attributes.position_branch_id#))
			</cfif>
			<!--- pozisyon kontrolleri --->
			<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (#emp_branch_list#)</cfif>
	UNION ALL
		SELECT
			3 AS TYPE,
			E.EMPLOYEE_ID,
			EI.TC_IDENTY_NO,
			EIO.USE_SSK,
			EIO.IN_OUT_ID,
			EIO.START_DATE,
			EIO.FINISH_DATE,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			ES.M#attributes.sal_mon# AS MAAS,
			ES.MONEY,
			EIO.GROSS_NET,
			EIO.SOCIALSECURITY_NO,
			0 AS EMPLOYEE_PUANTAJ_ID,
			0 AS TOTAL_DAYS,
			0 AS IZIN,
			0 AS NET_UCRET,
			0 AS EXT_SALARY,
			0 AS TOTAL_SALARY,
			0 AS AVANS,
			0 AS OZEL_KESINTI,
			0 AS VERGI_INDIRIMI,
			0 AS VERGI_IADESI,
            0 AS BES_ISCI_HISSESI,
			0 AS TOTAL_PAY,
			0 AS TOTAL_PAY_TAX,
			0 AS TOTAL_PAY_SSK,
			0 AS TOTAL_PAY_SSK_TAX,
            0 AS KIDEM_AMOUNT_NET,
            0 AS IHBAR_AMOUNT_NET,
            0 AS YILLIK_IZIN_AMOUNT_NET,
			#dsn#.Get_Dynamic_Language(B.BRANCH_ID,'#session.ep.language#','B','BRANCH_NAME',NULL,NULL,B.BRANCH_NAME) AS BRANCH_NAME,
			#dsn#.Get_Dynamic_Language(D.DEPARTMENT_ID,'#session.ep.language#','D','DEPARTMENT_HEAD',NULL,NULL,D.DEPARTMENT_HEAD) AS DEPARTMENT_HEAD,
			EIO.BRANCH_ID,
			EIO.PUANTAJ_GROUP_IDS,
			#dsn#.Get_Dynamic_Language(EPP.POSITION_CAT_ID,'#session.ep.language#','EPP','POSITION_NAME',NULL,NULL,EPP.POSITION_NAME) AS POSITION_NAME,
			#dsn#.Get_Dynamic_Language(SPC.POSITION_CAT_ID,'#session.ep.language#','SPC','POSITION_CAT',NULL,NULL,SPC.POSITION_CAT) AS POSITION_CAT,
			#dsn#.Get_Dynamic_Language(ST.TITLE_ID,'#session.ep.language#','ST','TITLE',NULL,NULL,ST.TITLE) AS TITLE,
			#dsn#.Get_Dynamic_Language(SCU.UNIT_ID,'#session.ep.language#','SCU','UNIT_NAME',NULL,NULL,SCU.UNIT_NAME) AS UNIT_NAME,
			POSD.DEPARTMENT_HEAD AS POSITION_DEP,
			SBT.BANK_NAME,
			BA.BANK_BRANCH_CODE,
			BA.BANK_ACCOUNT_NO,
            BA.IBAN_NO
		FROM
			EMPLOYEES_IN_OUT EIO
			INNER JOIN EMPLOYEES E ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_SALARY ES ON EIO.IN_OUT_ID = ES.IN_OUT_ID
			INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID
			INNER JOIN BRANCH B ON EIO.BRANCH_ID=B.BRANCH_ID
			LEFT JOIN EMPLOYEE_POSITIONS EPP ON EPP.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EPP.IS_MASTER=1
			LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EPP.POSITION_CAT_ID
			LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EPP.TITLE_ID
			LEFT JOIN SETUP_CV_UNIT SCU ON SCU.UNIT_ID = EPP.FUNC_ID
			LEFT JOIN DEPARTMENT POSD ON POSD.DEPARTMENT_ID = EPP.DEPARTMENT_ID
			LEFT JOIN EMPLOYEES_BANK_ACCOUNTS BA ON BA.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND BA.DEFAULT_ACCOUNT = 1
			LEFT JOIN SETUP_BANK_TYPES SBT ON SBT.BANK_ID = BA.BANK_ID
		WHERE
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				(E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) AND
			</cfif>
			<cfif isdefined('attributes.branch_id') and listlen(attributes.branch_id)>
				B.BRANCH_ID IN (#ATTRIBUTES.branch_id#) AND
			</cfif>
			<cfif isdefined('attributes.department') and listlen(attributes.department)>
				EIO.DEPARTMENT_ID IN (#ATTRIBUTES.department#) AND
			</cfif>
			EIO.IS_PUANTAJ_OFF = 1 AND
			ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
			EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND
			(EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> OR EIO.FINISH_DATE IS NULL)
			<!--- pozisyon kontrolleri --->
			<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">)
			</cfif>
			<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">)
			</cfif>
			<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">)
			</cfif>
			<cfif isdefined('attributes.position_department') and listlen(attributes.position_department)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND DEPARTMENT_ID IN (#attributes.position_department#))
			</cfif>
			<cfif isdefined('attributes.position_branch_id') and listlen(attributes.position_branch_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT POSITION_D WHERE EP.IS_MASTER = 1 AND EP.DEPARTMENT_ID = POSITION_D.DEPARTMENT_ID AND POSITION_D.BRANCH_ID IN (#attributes.position_branch_id#))
			</cfif>
			<!--- pozisyon kontrolleri --->
			<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (#emp_branch_list#)</cfif>
	UNION ALL
		SELECT
			3 AS TYPE,
			E.EMPLOYEE_ID,
			EI.TC_IDENTY_NO,
			EIO.USE_SSK,
			EIO.IN_OUT_ID,
			EIO.START_DATE,
			EIO.FINISH_DATE,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			0 AS MAAS,
			'#session.ep.money#' AS MONEY,
			EIO.GROSS_NET,
			EIO.SOCIALSECURITY_NO,
			0 AS EMPLOYEE_PUANTAJ_ID,
			0 AS TOTAL_DAYS,
			0 AS IZIN,
			0 AS NET_UCRET,
			0 AS EXT_SALARY,
			0 AS TOTAL_SALARY,
			0 AS AVANS,
			0 AS OZEL_KESINTI,
			0 AS VERGI_INDIRIMI,
			0 AS VERGI_IADESI,
            0 AS BES_ISCI_HISSESI,
			0 AS TOTAL_PAY,
			0 AS TOTAL_PAY_TAX,
			0 AS TOTAL_PAY_SSK,
			0 AS TOTAL_PAY_SSK_TAX,
            0 AS KIDEM_AMOUNT_NET,
            0 AS IHBAR_AMOUNT_NET,
            0 AS YILLIK_IZIN_AMOUNT_NET,
			#dsn#.Get_Dynamic_Language(B.BRANCH_ID,'#session.ep.language#','B','BRANCH_NAME',NULL,NULL,B.BRANCH_NAME) AS BRANCH_NAME,
			#dsn#.Get_Dynamic_Language(D.DEPARTMENT_ID,'#session.ep.language#','D','DEPARTMENT_HEAD',NULL,NULL,D.DEPARTMENT_HEAD) AS DEPARTMENT_HEAD,
			EIO.BRANCH_ID,
			EIO.PUANTAJ_GROUP_IDS,
			#dsn#.Get_Dynamic_Language(EPP.POSITION_CAT_ID,'#session.ep.language#','EPP','POSITION_NAME',NULL,NULL,EPP.POSITION_NAME) AS POSITION_NAME,
			#dsn#.Get_Dynamic_Language(SPC.POSITION_CAT_ID,'#session.ep.language#','SPC','POSITION_CAT',NULL,NULL,SPC.POSITION_CAT) AS POSITION_CAT,
			#dsn#.Get_Dynamic_Language(ST.TITLE_ID,'#session.ep.language#','ST','TITLE',NULL,NULL,ST.TITLE) AS TITLE,
			#dsn#.Get_Dynamic_Language(SCU.UNIT_ID,'#session.ep.language#','SCU','UNIT_NAME',NULL,NULL,SCU.UNIT_NAME) AS UNIT_NAME,
			POSD.DEPARTMENT_HEAD AS POSITION_DEP,
			SBT.BANK_NAME,
			BA.BANK_BRANCH_CODE,
			BA.BANK_ACCOUNT_NO,
            BA.IBAN_NO
		FROM
			EMPLOYEES_IN_OUT EIO
			INNER JOIN EMPLOYEES E ON EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID
			INNER JOIN BRANCH B ON EIO.BRANCH_ID=B.BRANCH_ID
			LEFT JOIN EMPLOYEE_POSITIONS EPP ON EPP.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EPP.IS_MASTER=1
			LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EPP.POSITION_CAT_ID
			LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EPP.TITLE_ID
			LEFT JOIN SETUP_CV_UNIT SCU ON SCU.UNIT_ID = EPP.FUNC_ID
			LEFT JOIN DEPARTMENT POSD ON POSD.DEPARTMENT_ID = EPP.DEPARTMENT_ID
			LEFT JOIN EMPLOYEES_BANK_ACCOUNTS BA ON BA.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND BA.DEFAULT_ACCOUNT = 1
			LEFT JOIN SETUP_BANK_TYPES SBT ON SBT.BANK_ID = BA.BANK_ID
		WHERE
			EIO.IN_OUT_ID NOT IN (SELECT IN_OUT_ID FROM EMPLOYEES_SALARY WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">) AND
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				(E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) AND
			</cfif>
			<cfif isdefined('attributes.branch_id') and listlen(attributes.branch_id)>
				B.BRANCH_ID IN (#ATTRIBUTES.branch_id#) AND
			</cfif>
			<cfif isdefined('attributes.department') and listlen(attributes.department)>
				EIO.DEPARTMENT_ID IN (#ATTRIBUTES.department#) AND
			</cfif>
			EIO.IS_PUANTAJ_OFF = 1 AND
			EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND
			(EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> OR EIO.FINISH_DATE IS NULL)
			<!--- pozisyon kontrolleri --->
			<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">)
			</cfif>
			<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.func_id#">)
			</cfif>
			<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">)
			</cfif>
			<cfif isdefined('attributes.position_department') and listlen(attributes.position_department)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND DEPARTMENT_ID IN (#attributes.position_department#))
			</cfif>
			<cfif isdefined('attributes.position_branch_id') and listlen(attributes.position_branch_id)>
				AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT POSITION_D WHERE EP.IS_MASTER = 1 AND EP.DEPARTMENT_ID = POSITION_D.DEPARTMENT_ID AND POSITION_D.BRANCH_ID IN (#attributes.position_branch_id#))
			</cfif>
			<!--- pozisyon kontrolleri --->
			<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (#emp_branch_list#)</cfif>
		ORDER BY
			BRANCH_NAME,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_people.recordcount = 0>
</cfif>

<cfif isDefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows = get_people.recordcount>
</cfif>
<cfif get_people.recordcount>
	<cfset puantaj_row_id_list = "">
	<cfset in_out_id_list = "">
	<cfset in_out_id_list_ilk = "">
	<cfset employee_id_list = "">
	<cfset employee_id_offtime_list = "">
	<cfoutput query="get_people" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
		<cfif not listfindnocase(puantaj_row_id_list,employee_puantaj_id) and type eq 1>
			<cfset puantaj_row_id_list = listappend(puantaj_row_id_list,employee_puantaj_id)>
		</cfif>
		<cfif not listfindnocase(in_out_id_list,in_out_id)>
			<cfset in_out_id_list = listappend(in_out_id_list,in_out_id)>
		</cfif>
		<cfif not listfindnocase(employee_id_list,employee_id)>
			<cfset employee_id_list = listappend(employee_id_list,employee_id)>
			<cfset employee_id_offtime_list = listappend(employee_id_offtime_list,employee_id)>
		</cfif>
	</cfoutput>
	<cfset in_out_id_list_ilk = in_out_id_list>
	<cfif listlen(in_out_id_list)>
		<cfset in_out_id_list=listsort(in_out_id_list,"numeric","ASC",",")>
		<cfquery name="GET_GR_MAAS" datasource="#dsn#">
			SELECT
				ESP.M#attributes.sal_mon# AS GR_MAAS,
				ESP.IN_OUT_ID,
				ESP.MONEY AS GR_MONEY_TYPE,
				EIO.SALARY_TYPE
			FROM
				EMPLOYEES_SALARY_PLAN ESP,
				EMPLOYEES_IN_OUT EIO
			WHERE
				ESP.SALARY_PLAN_ID = (SELECT TOP 1 ESP2.SALARY_PLAN_ID FROM EMPLOYEES_SALARY_PLAN ESP2,EMPLOYEES_IN_OUT EIO2 WHERE ESP2.IN_OUT_ID = ESP.IN_OUT_ID AND ESP2.IN_OUT_ID = EIO2.IN_OUT_ID AND ESP2.IN_OUT_ID IN (#in_out_id_list#) AND ESP2.PERIOD_YEAR = #attributes.sal_year# ORDER BY ESP2.SALARY_PLAN_ID DESC) AND
				ESP.IN_OUT_ID = EIO.IN_OUT_ID AND
				ESP.IN_OUT_ID IN (#in_out_id_list#) AND
				ESP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
			ORDER BY 
				ESP.IN_OUT_ID
		</cfquery>
		<cfset in_out_id_list = listsort(listdeleteduplicates(valuelist(GET_GR_MAAS.IN_OUT_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif listlen(employee_id_list)>
		<cfif x_count_off_puantaj_offtime eq 1>
			<cfquery name="get_offtimes_all_off" datasource="#dsn#">
				SELECT
					OFFTIME.TOTAL_HOURS,
					OFFTIME.STARTDATE,
					OFFTIME.FINISHDATE,
					OFFTIME.EMPLOYEE_ID,
                    OFFTIME.IN_OUT_ID
				FROM
					OFFTIME
				WHERE
					OFFTIME.EMPLOYEE_ID IN (#employee_id_offtime_list#) AND
					OFFTIME.VALID = 1 AND
					OFFTIME.IS_PUANTAJ_OFF = 1 AND
					OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND
					OFFTIME.FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#">
			</cfquery>
		</cfif>
	</cfif>

	<cfif listlen(in_out_id_list_ilk)>
		<cfquery name="get_gr_odeneks" datasource="#dsn#">
			SELECT
                SALARYPARAM_PAY.*,
                #dsn#.Get_Dynamic_Language(ODKES_ID,'#session.ep.language#','SETUP_PAYMENT_INTERRUPTION','COMMENT_PAY',NULL,NULL,SP.COMMENT_PAY) AS COMMENT_PAY_
			FROM
				SALARYPARAM_PAY
                LEFT JOIN SETUP_PAYMENT_INTERRUPTION SP ON SP.ODKES_ID = SALARYPARAM_PAY.COMMENT_PAY_ID
			WHERE
                SALARYPARAM_PAY.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				SALARYPARAM_PAY.START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_MON#"> AND
				SALARYPARAM_PAY.END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_MON#"> AND
				(SALARYPARAM_PAY.SHOW = 0 OR SALARYPARAM_PAY.SHOW IS NULL) AND
				SALARYPARAM_PAY.IN_OUT_ID IN (#in_out_id_list_ilk#)
		</cfquery>
		<cfquery name="get_gr_odenek_adlar" dbtype="query">
			SELECT DISTINCT COMMENT_PAY_ AS COMMENT_PAY FROM get_gr_odeneks
		</cfquery>
		<cfset gr_odenek_names = valuelist(get_gr_odenek_adlar.COMMENT_PAY)>
		<cfif listlen(gr_odenek_names)>
			<cfset count_ = 0>
			<cfloop list="#gr_odenek_names#" index="cc">
				<cfset count_ = count_ + 1>
				<cfset 't_gr_odenek_#count_#' = 0>
			</cfloop>
		</cfif>
		<cfquery name="get_gr_kesintis" datasource="#dsn#">
			SELECT
                SALARYPARAM_GET.*,
                #dsn#.Get_Dynamic_Language(ODKES_ID,'#session.ep.language#','SETUP_PAYMENT_INTERRUPTION','COMMENT_PAY',NULL,NULL,SP.COMMENT_PAY) AS COMMENT_GET_
			FROM
				SALARYPARAM_GET 
                LEFT JOIN SETUP_PAYMENT_INTERRUPTION SP ON SP.ODKES_ID = SALARYPARAM_GET.COMMENT_GET_ID
			WHERE
                SALARYPARAM_GET.TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
				SALARYPARAM_GET.START_SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_MON#"> AND
				SALARYPARAM_GET.END_SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_MON#"> AND
				(SALARYPARAM_GET.SHOW = 0 OR SALARYPARAM_GET.SHOW IS NULL) AND
				SALARYPARAM_GET.IN_OUT_ID IN (#in_out_id_list_ilk#)
		</cfquery>
		<cfquery name="get_gr_kesinti_adlar" dbtype="query">
			SELECT DISTINCT COMMENT_GET_ AS COMMENT_GET FROM get_gr_kesintis
		</cfquery>
		<cfset gr_kesinti_names = valuelist(get_gr_kesinti_adlar.COMMENT_GET)>
		<cfif listlen(gr_kesinti_names)>
			<cfset count_ = 0>
			<cfloop list="#gr_kesinti_names#" index="cc">
				<cfset count_ = count_ + 1>
				<cfset 't_gr_kesinti_#count_#' = 0>
			</cfloop>
		</cfif>
		<cfquery name="GET_GR_AVANS" datasource="#dsn#">
			SELECT
				TO_EMPLOYEE_ID,
				IN_OUT_ID,
				STATUS,
				DUEDATE,
				AMOUNT
			FROM 
				CORRESPONDENCE_PAYMENT
			WHERE
				DUEDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#"> AND
				DUEDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> AND
				IN_OUT_ID IN (#in_out_id_list_ilk#)
		</cfquery>
		<cfset month_day_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.sal_mon,1))>
		<cfset month_start_ = CREATEDATE(attributes.sal_year,attributes.sal_mon,1)>
		<cfset month_finish_ = CreateDateTime(attributes.sal_year,attributes.sal_mon,month_day_,'23','59','59')>
		<cfquery name="GET_EXT_WORKTIMES" datasource="#DSN#">
			SELECT 
				START_TIME,
				END_TIME,
				IN_OUT_ID,
				DAY_TYPE
			FROM
				EMPLOYEES_EXT_WORKTIMES
			WHERE
				IN_OUT_ID IN (#in_out_id_list_ilk#) AND
				IS_PUANTAJ_OFF = 1 AND
				START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#month_start_#">  AND
				START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#month_finish_#"> AND
				END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#month_start_#">  AND
				END_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#month_finish_#">
		</cfquery>
		<cfquery name="GET_OUR_COMPANY_HOURS" datasource="#dsn#">
			SELECT SSK_MONTHLY_WORK_HOURS SSK_AYLIK_MAAS,DAILY_WORK_HOURS AS GUNLUK_SAAT,SSK_WORK_HOURS FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfif get_ext_worktimes.recordcount>
			<cfquery name="GET_SALARY_MONTH" datasource="#dsn#">
				SELECT  
					ES.MONEY, 
					ES.M#month(puantaj_start_)# AYLIK_MAAS,
					ES.EMPLOYEE_ID,
					EIO.SALARY_TYPE
				FROM 
					EMPLOYEES_SALARY ES,
					EMPLOYEES_IN_OUT EIO
				WHERE 
					ES.IN_OUT_ID = EIO.IN_OUT_ID AND
					ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
			</cfquery>
		</cfif>
	<cfelse>
		<cfset get_ext_worktimes.recordcount = 0>
		<cfset get_gr_odeneks.recordcount = 0>
		<cfset get_gr_odenek_adlar.recordcount = 0>
		<cfset get_gr_kesintis.recordcount = 0>
		<cfset get_gr_kesinti_adlar.recordcount = 0>
		<cfset get_gr_avans.recordcount = 0>
	</cfif>

	<cfif listlen(puantaj_row_id_list)>
            <cfquery name="get_kesintis" datasource="#dsn#">
                SELECT 
                    EPRE.*,
                    #dsn#.Get_Dynamic_Language(ODKES_ID,'#session.ep.language#','SETUP_PAYMENT_INTERRUPTION','COMMENT_PAY',NULL,NULL,SP.COMMENT_PAY) AS COMMENT_PAY_ 

                FROM 
                    EMPLOYEES_PUANTAJ_ROWS_EXT EPRE
                    LEFT JOIN SETUP_PAYMENT_INTERRUPTION SP ON SP.COMMENT_PAY = EPRE.COMMENT_PAY
                WHERE 
                    EPRE.EMPLOYEE_PUANTAJ_ID IN (#puantaj_row_id_list#) AND 
                    EPRE.EXT_TYPE = 1 
                ORDER BY 
                    EPRE.COMMENT_PAY
            </cfquery>
			<cfquery name="get_kesinti_adlar" dbtype="query">
				SELECT DISTINCT COMMENT_PAY_ AS COMMENT_PAY FROM get_kesintis WHERE COMMENT_PAY <> 'Avans'
			</cfquery>
			<cfset kesinti_names = valuelist(get_kesinti_adlar.COMMENT_PAY)>
			<cfset count_ = 0>
			<cfif listlen(kesinti_names)>
				<cfloop list="#kesinti_names#" index="cc">
					<cfset count_ = count_ + 1>
					<cfset 't_kesinti_#count_#' = 0>
				</cfloop>
			</cfif>
			<cfset t_avans = 0>
	
			<cfquery name="get_odeneks" datasource="#dsn#">
				SELECT 
                    EPRE.*,
                    #dsn#.Get_Dynamic_Language(ODKES_ID,'#session.ep.language#','SETUP_PAYMENT_INTERRUPTION','COMMENT_PAY',NULL,NULL,SP.COMMENT_PAY) AS COMMENT_PAY_, 
					SP.FROM_SALARY AS FROM_SALARY2
				FROM 
					EMPLOYEES_PUANTAJ_ROWS_EXT EPRE
					LEFT JOIN SETUP_PAYMENT_INTERRUPTION SP ON SP.COMMENT_PAY = EPRE.COMMENT_PAY
				WHERE 
					EPRE.EMPLOYEE_PUANTAJ_ID IN (#puantaj_row_id_list#) AND 
					EPRE.EXT_TYPE = 0
				ORDER BY 
					EPRE.COMMENT_PAY
			</cfquery>
			<cfquery name="get_odenek_adlar" dbtype="query">
				SELECT DISTINCT COMMENT_PAY_ AS COMMENT_PAY FROM get_odeneks where COMMENT_PAY IS NOT NULL
			</cfquery>
			<cfset odenek_names = valuelist(get_odenek_adlar.COMMENT_PAY)>
			<cfif listlen(odenek_names)>
				<cfset count_ = 0>
				<cfloop list="#odenek_names#" index="cc">
					<cfset count_ = count_ + 1>
					<cfset 't_odenek_#count_#' = 0>
				</cfloop>
			</cfif>
	<cfelse>
		<cfset get_kesintis.recordcount = 0>
		<cfset get_kesinti_adlar.recordcount = 0>
		<cfset get_odeneks.recordcount = 0>
		<cfset get_odenek_adlar.recordcount = 0>
	</cfif>
<cfelse>
	<cfset get_kesintis.recordcount = 0>
	<cfset get_odeneks.recordcount = 0>
	<cfset get_odenek_adlar.recordcount = 0>
	<cfset get_kesinti_adlar.recordcount = 0>
	<cfset get_gr_odeneks.recordcount = 0>
	<cfset get_gr_odenek_adlar.recordcount = 0>
	<cfset get_gr_kesintis.recordcount = 0>
	<cfset get_gr_kesinti_adlar.recordcount = 0>
	<cfset get_gr_avans.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_people.recordCount#">
<script type="text/javascript">
function control()	{
		if(document.employee.is_excel.checked==false)
		{
			document.employee.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.employee.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_manage_all_salaries</cfoutput>"
					}
function get_department_list(gelen)
{
	document.employee.department.options.length = 0;
	var document_id = document.employee.branch_id.options.length;	
	var document_name = '';
	for(i=0;i<document_id;i++)
	{
		if(document.employee.branch_id.options[i].selected && document_name.length==0)
			document_name = document_name + document.employee.branch_id.options[i].value;
		else if(document.employee.branch_id.options[i].selected)
			document_name = document_name + ',' + document.employee.branch_id.options[i].value;
	}
	var get_department_name = wrk_safe_query('rpr_get_dep_name','dsn',0,document_name);
	document.employee.department.options[0]=new Option('Departman Seçiniz','0')
	if(get_department_name.recordcount != 0)
	{
		for(var xx=0;xx<get_department_name.recordcount;xx++)
		{
			document.employee.department.options[xx+1]=new Option(get_department_name.DEPARTMENT_HEAD[xx],get_department_name.DEPARTMENT_ID[xx]);
		}
	}
}
function get_department_list2(gelen)
{
	document.employee.position_department.options.length = 0;
	var document_id = document.employee.position_branch_id.options.length;	
	var document_name = '';
	for(i=0;i<document_id;i++)
	{
		if(document.employee.position_branch_id.options[i].selected && document_name.length==0)
			document_name = document_name + document.employee.position_branch_id.options[i].value;
		else if(document.employee.position_branch_id.options[i].selected)
			document_name = document_name + ',' + document.employee.position_branch_id.options[i].value;
	}
	var get_position_department_name = wrk_safe_query('rpr_get_dep_name','dsn',0,document_name);
	document.employee.position_department.options[0]=new Option('Departman Seçiniz','0')
	if(get_position_department_name.recordcount != 0)
	{
		for(var xx=0;xx<get_position_department_name.recordcount;xx++)
		{
			document.employee.position_department.options[xx+1]=new Option(get_position_department_name.DEPARTMENT_HEAD[xx],get_position_department_name.DEPARTMENT_ID[xx]);
		}
	}
}
</script>
<cfsavecontent variable="head"><cf_get_lang dictionary_id="39924.Ücret Yönetim Raporu"></cfsavecontent>
<cfform name="employee" method="post" action="#request.self#?fuseaction=report.manage_all_salaries&iframe=1">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57460.Filtre"></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58724.Ay"></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="sal_mon" id="sal_mon">
                                                <cfloop from="1" to="12" index="i">
                                                <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58455.Yıl"></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="sal_year" id="sal_year">
                                                <cfloop from="#session.ep.period_year#" to="#session.ep.period_year-3#" step="-1" index="i">
                                                    <cfoutput><option value="#i#"<cfif attributes.sal_year eq i> selected</cfif>>#i#</option></cfoutput>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12">&nbsp</label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="salary_type" id="salary_type">
                                                <option value="1" <cfif attributes.salary_type eq 1> selected</cfif>><cf_get_lang dictionary_id="39910.Planlanan Maaş Resmi İçermez"></option>
                                                <option value="0" <cfif attributes.salary_type eq 0> selected</cfif>><cf_get_lang dictionary_id="39911.Planlanan Maaş Tam Maaş"></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">                  
                                <div class="col col-12 col-md-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="branch_id" id="branch_id" multiple onchange="get_department_list(this.value)" style="height:70px;">
                                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                <cfoutput query="get_ssk_offices" group="nick_name">
                                                    <optgroup label="#nick_name#"></optgroup>
                                                    <cfoutput>
                                                        <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and listfindnocase(attributes.branch_id,branch_id)>selected</cfif>>#BRANCH_FULLNAME#</option>
                                                    </cfoutput>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57572.Departman"></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="department" id="department" style="height:70px;" multiple>
                                                <cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
                                                    <cfquery name="get_depts" dbtype="query">
                                                        SELECT * FROM GET_DEPARTMENT WHERE BRANCH_ID IN (#attributes.branch_id#)
                                                    </cfquery>
                                                    <cfoutput query="get_depts">
                                                        <option value="#department_id#" <cfif isdefined("attributes.department") and listfindnocase(attributes.department,department_id)>selected</cfif>>#department_head#</option>
                                                    </cfoutput>
                                                <cfelse>	
                                                    <option value="0"><cf_get_lang dictionary_id="57572.Departman"> <cf_get_lang dictionary_id="57734.Seçiniz"></option>		 
                                                </cfif>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12">
                                    <div class="form-group">    
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58497.Pozisyon"> <cf_get_lang dictionary_id="57453.Şube"></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="position_branch_id" id="position_branch_id" style="height:70px;" multiple onchange="get_department_list2(this.value)">
                                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                                <cfoutput query="get_ssk_offices">
                                                    <option value="#branch_id#" <cfif isdefined("attributes.position_branch_id") and listfindnocase(attributes.position_branch_id,branch_id)>selected</cfif>>#BRANCH_FULLNAME#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <div class="col col-12 col-md-12 col-xs-12"> 
                                            <label><cf_get_lang dictionary_id="39928.Pozisyon Departmanı"></label>
                                        </div>
                                        <div class="col col-12 col-md-12 col-xs-12">    
                                            <select name="position_department" id="position_department" style="height:70px;" multiple>
                                                <cfif isdefined("attributes.position_branch_id") and listlen(attributes.position_branch_id)>
                                                <cfquery name="get_depts" dbtype="query">
                                                    SELECT * FROM GET_DEPARTMENT WHERE BRANCH_ID IN (#attributes.position_branch_id#)
                                                </cfquery>
                                                <cfoutput query="get_depts">
                                                    <option value="#department_id#" <cfif isdefined("attributes.position_department") and listfindnocase(attributes.position_department,department_id)>selected</cfif>>#department_head#</option>
                                                </cfoutput>
                                                <cfelse>	
                                                <option value="0"><cf_get_lang dictionary_id="57572.Departman"> <cf_get_lang dictionary_id="57734.Seçiniz"></option>		 
                                                </cfif>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57779.Pozisyon Tipleri"></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="position_cat_id" id="position_cat_id">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="GET_POSITION_CATS">
                                                    <option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="39393.Ünvanlar"></label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="title_id" id="title_id">
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <cfoutput query="titles">
                                                    <option value="#title_id#" <cfif attributes.title_id eq title_id>selected</cfif>>#title#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>         
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12">&nbsp</label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <select name="func_id" id="func_id">
                                                <option value=""><cf_get_lang dictionary_id="58701.Fonksiyon"></option>
                                                <cfoutput query="get_units">
                                                    <option value="#unit_id#" <cfif attributes.func_id eq unit_id>selected</cfif>>#UNIT_NAME#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12">&nbsp</label>
                                        <div class="col col-12 col-md-12 col-xs-12">
                                            <input type="checkbox" value="1" name="is_bank_accounts" id="is_bank_accounts" <cfif isdefined("attributes.is_bank_accounts")>checked</cfif>> <cf_get_lang dictionary_id="39252.Banka Bilgisi">
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isDefined("attributes.is_excel") and attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cfinput type="hidden" name="form_submitted" id="form_submitted" value="1">
							<cf_wrk_report_search_button button_type="1" is_excel="1" search_function="control()"> 
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isDefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>	
<cfif isdefined("form_submitted")>
    <cf_report_list>
        <cfset myCol = 0>
            <thead>	
            <cfoutput>
                <tr height="25">
                <th>&nbsp;</th>
                <th>&nbsp;</th>	
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <cfif isdefined("attributes.is_bank_accounts")>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                </cfif>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th></th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <cfif x_count_off_puantaj_offtime eq 1><th>&nbsp;</th></cfif>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                <th>&nbsp;</th>
                    <cfif attributes.salary_type eq 0><th>&nbsp;</th></cfif>
                    <th width="1"></th>
                    <th colspan="8" align="center"><cf_get_lang dictionary_id="39997.PUANTAJ BİLGİLERİ"></th>
                    <cfif get_people.recordcount and get_odenek_adlar.recordcount>
                    <th width="1"></th>
                    <th colspan="#get_odenek_adlar.recordcount + get_odenek_adlar.recordcount#" align="center"><cf_get_lang dictionary_id="39998.P ÖDENEKLER"></th>
                    </cfif>
                    <th width="1"></th>
                    <cfif get_people.recordcount and get_kesinti_adlar.recordcount>
                        <cfset cols_ = get_kesinti_adlar.recordcount+1>
                    <cfelse>
                        <cfset cols_ = 1>
                    </cfif>
                    <th colspan="#cols_#" align="center"><cf_get_lang dictionary_id="58869.Planlanan"> <cf_get_lang dictionary_id="38977.KESİNTİLER"></th>
                    <cfif get_people.recordcount and get_gr_odenek_adlar.recordcount>
                        <th width="1"></th>
                        <th colspan="#get_gr_odenek_adlar.recordcount+1#" align="center"><cf_get_lang dictionary_id="39998.Planlanan ÖDENEKLER"></th>
                    </cfif>
                    <cfif get_people.recordcount and get_gr_kesinti_adlar.recordcount>
                        <th width="1"></th>
                        <th colspan="#get_gr_kesinti_adlar.recordcount+1#" align="center"><cf_get_lang dictionary_id="58869.Planlanan"> <cf_get_lang dictionary_id="38977.KESİNTİLER"></th>
                    </cfif>
                    <th width="1"></th>
                    <th align="center"><cf_get_lang dictionary_id="58869.Planlanan"> <cf_get_lang dictionary_id="58204.AVANS"></th>
                    <th width="1"></th>
                    <th align="center"><cf_get_lang dictionary_id="39995.Planlanan F MESAİ"></th>
                    <th width="1"></th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <cfif attributes.salary_type eq 0>
                        <th>&nbsp;</th>
                        <th>&nbsp;</th>
                        <th>&nbsp;</th>
                    </cfif>
                </tr>
                <tr height="22">
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="57487.No"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="29532.Şube Adı"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="59138.Departman Adı"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="39928.Pozisyon Departmanı"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="58497.Pozisyon"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="59004.Pozisyon Tipi"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="57571.Ünvan"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="58701.Fonksiyon"></td>
                    <td style="font-weight: bold;" width="150"><cf_get_lang dictionary_id="57576.Çalışan"></td>
                    <td style="font-weight: bold;" width="100" ><cf_get_lang dictionary_id="58025.TC Kimlik No"></td>
                    <td style="font-weight: bold;" width="100" ><cf_get_lang dictionary_id="39937.SSK No"></td>
                    <cfif isdefined("attributes.is_bank_accounts")>
                        <td style="font-weight: bold;"><cf_get_lang dictionary_id="48695.Banka Adı"></td><cfset myCol = myCol + 1>
                        <td style="font-weight: bold;"><cf_get_lang dictionary_id="58178.Hesap No"></td><cfset myCol = myCol + 1>
                        <td style="font-weight: bold;"><cf_get_lang dictionary_id="54332.Iban No"></td><cfset myCol = myCol + 1>
                    </cfif>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="64695.S"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="986.P"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="987.Br."></td>
                    <td style="font-weight: bold;"></td>
                    <td style="font-weight: bold;"><cf_get_lang dictionary_id="57490.Gün"></td>
                    <cfif x_count_off_puantaj_offtime eq 1><td style="font-weight: bold;" width="25"  ><cf_get_lang dictionary_id="881.GR"> <cf_get_lang dictionary_id="58575.İzin"></td><cfset myCol = myCol + 1></cfif>
                    <td style="font-weight: bold;" width="25"><cf_get_lang dictionary_id="881.GR"> <cf_get_lang dictionary_id="57490.Gün"></td>
                    <td style="font-weight: bold;" width="75" align="right"><cf_get_lang dictionary_id="40071.Maaş"></td>
                    <td style="font-weight: bold;"></td>
                    <td style="font-weight: bold;" width="75"><cf_get_lang dictionary_id="40523.Planlanan Maaş"></td>
                    <td style="font-weight: bold;"></td>
                    <cfif attributes.salary_type eq 0>
                    <td style="font-weight: bold;" width="75" align="right"  ><cf_get_lang dictionary_id="40071.Maaş"> <cf_get_lang dictionary_id="58583.Fark"></td><cfset myCol = myCol + 1>
                    </cfif>
                    <td style="font-weight: bold;" width="1"></td>
                    <td style="font-weight: bold;" align="right" width="75"><cf_get_lang dictionary_id="879.P."> <cf_get_lang dictionary_id="58083.Net"></td>
                    <td style="font-weight: bold;" align="right" width="75"><cf_get_lang dictionary_id="879.P."> <cf_get_lang dictionary_id="38990.Brüt"></td>
                    <td style="font-weight: bold;" align="right" width="75"><cf_get_lang dictionary_id="38224.Fazla M"></td>
                    <td style="font-weight: bold;" align="right" width="75"><cf_get_lang dictionary_id="39986.Ek Ödenek"></td>
                    <td style="font-weight: bold;" align="right" width="75"><cf_get_lang dictionary_id="39992.Kesinti"></td>
                    <td style="font-weight: bold;" align="right" width="75"><cf_get_lang dictionary_id="880.V."> <cf_get_lang dictionary_id="39939.İstisna"></td>
                    <td style="font-weight: bold;" align="right" width="75"><cf_get_lang dictionary_id="39964.AGİ"></td>
                    <td style="font-weight: bold;" align="right" width="75"><cf_get_lang dictionary_id="63079.BES"></td>
                    <cfif get_odenek_adlar.recordcount>
                        <td style="font-weight: bold;" width="1"></td><cfset myCol = myCol + 1>
                        <cfloop query="get_odenek_adlar">
                            <td style="font-weight: bold;" align="right" width="100">#comment_pay#</td><cfset myCol = myCol + 1>
                            <td style="font-weight: bold;" align="right" width="100">#comment_pay# (Net)</td><cfset myCol = myCol + 1>
                        </cfloop>
                    </cfif>
                    <td style="font-weight: bold;" width="1"></td>
                    <td style="font-weight: bold;" align="right" width="100"><cf_get_lang dictionary_id="58204.Avans"></td>
                    <cfif get_kesinti_adlar.recordcount>
                        <cfloop query="get_kesinti_adlar">
                            <td style="font-weight: bold;" align="right" width="100">#COMMENT_PAY#</td><cfset myCol = myCol + 1>
                        </cfloop>
                    </cfif>
                    <cfif get_gr_odenek_adlar.recordcount>
                        <td style="font-weight: bold;" width="1"></td><cfset myCol = myCol + 1>
                        <cfloop query="get_gr_odenek_adlar">
                            <td style="font-weight: bold;" align="right" width="100">#COMMENT_PAY#</td><cfset myCol = myCol + 1>
                        </cfloop>
                        <td style="font-weight: bold;" align="right" width="100"><cf_get_lang dictionary_id="39967.Ek Ödenek Toplamı"></td><cfset myCol = myCol + 1>
                    </cfif>
                    <cfif get_gr_kesinti_adlar.recordcount>
                        <td style="font-weight: bold;" width="1"></td><cfset myCol = myCol + 1>
                        <cfloop query="get_gr_kesinti_adlar">
                            <td style="font-weight: bold;" align="right" width="100"  >#COMMENT_GET#</td><cfset myCol = myCol + 1>
                        </cfloop>
                        <td style="font-weight: bold;" align="right" width="100"  ><cf_get_lang dictionary_id="39999.Ek Kesinti Toplamı"></td><cfset myCol = myCol + 1>
                    </cfif>
                    <td style="font-weight: bold;" width="1"></td>
                    <td style="font-weight: bold;" align="right" width="100"><cf_get_lang dictionary_id="39987.Planlanan AVANS"></td>
                    <td style="font-weight: bold;" width="1"></td>
                    <td style="font-weight: bold;" align="right" width="100"><cf_get_lang dictionary_id="39995.Planlanan F Mesai"></td>
                    <td style="font-weight: bold;" width="1"></td>
                    <td style="font-weight: bold;" align="right"><cf_get_lang dictionary_id="58869.Planlanan"> <cf_get_lang dictionary_id="57756.Durum"></td>
                    <td style="font-weight: bold;"></td>
                    <td style="font-weight: bold;" align="right"><cf_get_lang dictionary_id="39996.Resmi Durum"></td>
                    <td style="font-weight: bold;"></td>
                    <cfif attributes.salary_type eq 0>
                        <td style="font-weight: bold;" align="right"><cf_get_lang dictionary_id="39964.AGİ"></td><cfset myCol = myCol + 1>
                        <td style="font-weight: bold;" align="right"><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="57756.Durum"></td><cfset myCol = myCol + 1>
                        <td style="font-weight: bold;" align="right"><cf_get_lang dictionary_id="29398.Son"> <cf_get_lang dictionary_id="57756.Durum"></td><cfset myCol = myCol + 1>
                    </cfif>
                </tr>
            </cfoutput>
            </thead>
            <cfif isdefined("attributes.form_submitted")>
                <cfif get_people.recordcount>
                    <cfset mesai_farki = 0>
                    <cfset gun_toplam = 0>
                    <cfset gr_gun_toplam = 0>
                    <cfset gr_izin_toplam = 0>
                    <cfset maas_toplam = 0>
                    <cfset gr_maas_toplam = 0>
                    <cfset gt_total_odenek = 0>
                    <cfset gt_total_odenek_net = 0>
                    <cfset gt_total_kesinti = 0>
                    <cfset gt_total_gr_odenek = 0>
                    <cfset gt_total_gr_kesinti = 0>
                    <cfset gt_total_avans = 0>
                    <cfset gt_vergi_indirimi = 0>
                    <cfset gt_p_fazla_mesai = 0>
                    <cfset gt_net_ucret = 0>
                    <cfset gt_total_salary = 0>
                    <cfset gt_ext_salary = 0>
                    <cfset gt_ek_odenek = 0>
                    <cfset gt_kesinti = 0>
                    <cfset gt_vergi_iadesi = 0>
                    <cfset gt_bes = 0>
                    <cfset gt_total_avans = 0>
                    <cfset gt_gr_durum = 0>
                    <cfset gt_r_durum = 0>
                    <cfset this_ =  0>
                    <cfset g_net_total = 0>
                    <tbody>
                    <cfoutput query="get_people" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                        <cfset total_gr_odenek = 0>
                        <cfset total_p_fazla_mesai = 0>
                        <cfset sayfa_tutar = 0>
                        <cfset total_gr_kesinti = 0>
                        <cfset total_odenek = 0>
                        <cfset total_odenek_net = 0>
                        <cfset total_kesinti = 0>
                        <cfset total_avans = 0>
                            <tr title="#employee_name# #employee_surname#">
                            <td>#currentrow#</td>
                            <td>#branch_name#</td>
                            <td>#department_head#</td>
                            <td>#position_dep#</td>
                            <td>#position_name#</td>
                            <td>#position_cat#</td>
                            <td>#title#</td>
                            <td>#unit_name#</td>
                            <td><cfif not isdefined("attributes.is_excel")><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a><cfelse>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</cfif></td>
                            <td>#TC_IDENTY_NO#</td>
                            <td>#SOCIALSECURITY_NO#</td>
                            <cfif isdefined("attributes.is_bank_accounts")>
                                <td>#bank_name#</td>
                                <td>#bank_branch_code# - #bank_account_no#</td>
                                <td>#iban_no#</td>
                            </cfif>
                            <td><cfif USE_SSK eq 1>S</cfif></td>
                            <td><cfif type eq 3>P</cfif></td>
                            <td>#MONEY#</td>
                            <td><cfif GROSS_NET eq True><cf_get_lang dictionary_id='58083.Net'><cfelseif GROSS_NET eq False><cf_get_lang dictionary_id='38990.Brüt'></cfif></td>
                            <cfset gr_type = 0>
                            <cfif type eq 1>
                                <cfset total_days_ = total_days>
                            <cfelse>
                                <cfif month(start_date) eq attributes.sal_mon and year(start_date) eq attributes.sal_year and len(finish_date) and month(finish_date) gt attributes.sal_mon>
                                    <cfset total_days_ = datediff("d",start_date,puantaj_finish_)>
                                    <cfset gr_type = 1>
                                <cfelseif month(start_date) eq attributes.sal_mon and year(start_date) eq attributes.sal_year and (len(finish_date) and month(finish_date) eq attributes.sal_mon and year(finish_date) eq attributes.sal_year)>
                                    <cfset total_days_ = datediff("d",start_date,finish_date) + 1>
                                    <cfset gr_type = 1>
                                <cfelseif month(start_date) eq attributes.sal_mon and year(start_date) eq attributes.sal_year and not len(finish_date)>
                                    <cfset total_days_ = datediff("d",start_date,puantaj_finish_)>
                                    <cfset gr_type = 1>
                                <cfelseif len(finish_date) and month(finish_date) eq attributes.sal_mon and year(finish_date) eq attributes.sal_year>
                                    <cfset total_days_ = datediff("d",puantaj_start_,finish_date) + 1>
                                    <cfset gr_type = 1>
                                <cfelse>
                                    <cfset total_days_ = 30>
                                </cfif>
                                <cfif total_days_ gt 30>
                                    <cfset total_days_ = 30>
                                </cfif>
                            </cfif>
                            <cfset gun_toplam = gun_toplam + total_days_>
                            <cfif puantaj_gun_ gt 30>
                                <cfset puantaj_gun_ = 30>
                            <cfelse>
                                <cfset puantaj_gun_ = puantaj_gun_>
                            </cfif>
                            <cfif total_days_ eq 30>
                                <cfset gr_gun_ = 30>
                            <cfelse>
                                <cfif gr_type eq 1>
                                    <cfset gr_gun_ = total_days_>	
                                <cfelse>
                                    <cfif izin gt 0>
                                        <cfif izin gt 0>
                                            <cfset gr_gun_ = DaysInMonth(CreateDate(attributes.sal_year,attributes.sal_mon,day(now()))) - izin>
                                        <cfelse>
                                            <cfset gr_gun_ = 30 - izin>
                                        </cfif>
                                        <cfif is_gr_gun_equal_ay_gun eq 1>
                                            <cfset gr_gun_ = DaysInMonth(CreateDate(attributes.sal_mon, attributes.sal_mon, Day(Now()))) - izin>
                                            <cfif gr_gun_ lt 0>
                                                <cfset gr_gun_ = 0>
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                        <cfset gr_gun_ = total_days>
                                    </cfif>
                                </cfif>
                            </cfif>
                            <cfif x_count_off_puantaj_offtime eq 1>
                                <cfset gr_izin = 0>
                                <cfquery name="get_emp_off_off" dbtype="query">
                                    SELECT * FROM get_offtimes_all_off WHERE EMPLOYEE_ID = #employee_id# AND IN_OUT_ID = #in_out_id#
                                </cfquery>
                                <cfscript>
                                    for(j=1; j lte get_emp_off_off.recordcount; j=j+1)
                                    {
                                        izin_startdate = date_add("h", session.ep.time_zone, get_emp_off_off.startdate[j]); 
                                        izin_finishdate = date_add("h", session.ep.time_zone, get_emp_off_off.finishdate[j]);
                                        if(datediff("h",izin_startdate,puantaj_start_) gte 0) izin_startdate=puantaj_start_;
                                        if(datediff("h",puantaj_finish_,izin_finishdate) gte 0) izin_finishdate=puantaj_finish_;
                                        a = datediff('d',izin_startdate,izin_finishdate) + 1;
                                        if(a gt 0)
                                            gr_izin = gr_izin + a;
                                    }
                                </cfscript>
                                <cfset gr_izin_toplam = gr_izin_toplam + gr_izin>
                            <cfelse>
                                <cfset gr_izin_toplam = 0>
                                <cfset gr_izin = 0>
                            </cfif>
                            <cfif is_gr_gun_equal_resmi_gun eq 1>
                                <cfset gr_gun_ = total_days_>
                            </cfif>
                            <cfset gr_gun_toplam = gr_gun_toplam + gr_gun_-gr_izin>
                            <td>#total_days_#</td>
                            <cfif x_count_off_puantaj_offtime eq 1><td>#gr_izin#</td></cfif>
                            <td>#gr_gun_-gr_izin#</td>
                            <cfset maas_toplam = maas_toplam + (MAAS/30*total_days_)>	
                            <td style="text-align:right;" class="txtbold" format="numeric"  ><cfif MAAS gt 0><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(MAAS/30*total_days_)#"></cfif></td><!---maas--->
                            <td>#MONEY#</td>
                            <td style="text-align:right;" class="txtbold" format="numeric"  >
                                <cfif listfindnocase(in_out_id_list,in_out_id)>
                                    <cfset gr_maas_ = GET_GR_MAAS.GR_MAAS[listfind(in_out_id_list,in_out_id,',')]>
                                    <cfif GET_GR_MAAS.SALARY_TYPE[listfind(in_out_id_list,in_out_id,',')] eq 0>
                                        <cfif Len(GET_GR_MAAS.GR_MAAS[listfind(in_out_id_list,in_out_id,',')])>
                                            <cfset gr_maas_ = GET_GR_MAAS.GR_MAAS[listfind(in_out_id_list,in_out_id,',')] * 225>
                                        <cfelse>
                                            <cfset gr_maas_ = 0>
                                        </cfif>
                                    <cfelseif GET_GR_MAAS.SALARY_TYPE[listfind(in_out_id_list,in_out_id,',')] eq 1> 
                                        <cfset gr_maas_ = GET_GR_MAAS.GR_MAAS[listfind(in_out_id_list,in_out_id,',')] * 30>
                                    <cfelse>
                                        <cfset gr_maas_ = GET_GR_MAAS.GR_MAAS[listfind(in_out_id_list,in_out_id,',')]>
                                    </cfif>
                                    <cfset money_type_= GET_GR_MAAS.GR_MONEY_TYPE>
                                <cfelse>
                                    <cfset gr_maas_  = 0>
                                </cfif>
                                <cfset gr_maas_gosterilecek_ = gr_maas_>
                                <cfif total_days_ gt 0 and gr_maas_ gt 0>
                                    <cfset gr_maas_  = gr_maas_ / 30 * (gr_gun_-gr_izin)>
                                <cfelse>
                                    <cfset gr_maas_  = 0>
                                </cfif>
                                <cfif gr_maas_gosterilecek_ gt 0>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gr_maas_gosterilecek_/30*(gr_gun_-gr_izin))#"><!---planlanan maas--->
                                </cfif>
                            </td>
                            <td>
                                <cfif GET_PEOPLE.IN_OUT_ID>
                                    <cfquery name="GET_GRR" datasource="#dsn#">
                                        SELECT MONEY AS GRR FROM EMPLOYEES_SALARY_PLAN WHERE (IN_OUT_ID = #GET_PEOPLE.IN_OUT_ID# AND PERIOD_YEAR = #attributes.sal_year#)
                                    </cfquery>
                                    <cfif isdefined("GET_GRR.GRR")>#GET_GRR.GRR#</cfif>
                                </cfif>
                            </td>
                            <cfset gr_maas_toplam = gr_maas_toplam + gr_maas_>
                            <cfif attributes.salary_type eq 0>
                                <td style="text-align:right;" class="txtbold" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gr_maas_ - (MAAS/30*total_days_))#"> <!--- <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(maas_)# #maas_money_#">#TLFormat(gr_maas_ - MAAS)#---></td>
                            </cfif>
                            <td width="1"></td>
                            <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(NET_UCRET)#"></td>
                            <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(TOTAL_SALARY)#"></td>
                            <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(ext_salary)#"></td>
                            <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total_pay+total_pay_tax+total_pay_ssk+total_pay_ssk_tax)#"></td>
                            <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(AVANS + ozel_kesinti)#"></td>
                            <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(vergi_indirimi)#"></td>
                            <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(vergi_iadesi)#"></td>
                            <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(bes_isci_hissesi)#"></td>
                            <cfset gt_net_ucret = gt_net_ucret + NET_UCRET>
                            <cfset gt_total_salary = gt_total_salary + TOTAL_SALARY>
                            <cfset gt_ext_salary = gt_ext_salary + ext_salary>
                            <cfset gt_ek_odenek = gt_ek_odenek + (total_pay+total_pay_tax+total_pay_ssk+total_pay_ssk_tax)>
                            <cfset gt_kesinti = gt_kesinti + (AVANS + ozel_kesinti)>
                            <cfset gt_vergi_indirimi = gt_vergi_indirimi + vergi_indirimi>
                            <cfset gt_vergi_iadesi = gt_vergi_iadesi + vergi_iadesi>
                            <cfset gt_bes = gt_bes + bes_isci_hissesi>
                            <!--- resmi odenekler --->
                            <cfif get_odenek_adlar.recordcount>
                                <td width="1"></td>
                                <cfset count_ = 0>
                                <cfloop list="#odenek_names#" index="cca">
                                    <cfset count_ = count_ + 1>
                                    <cfquery name="get_this_" dbtype="query">
                                        SELECT SUM(AMOUNT_2) AS TOTAL_ODENEK FROM get_odeneks WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND COMMENT_PAY = '#cca#' AND PAY_METHOD = 2
                                    </cfquery>
                                    <cfif get_this_.recordcount and len(get_this_.TOTAL_ODENEK)>
                                        <cfset this_ =  get_this_.TOTAL_ODENEK>
                                    <cfelse>
                                        <cfset this_ =  0>
                                    </cfif>
                                    <cfquery name="get_this_" dbtype="query">
                                        SELECT SUM(AMOUNT) AS TOTAL_ODENEK FROM get_odeneks WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND COMMENT_PAY = '#cca#' AND (PAY_METHOD <> 2 OR PAY_METHOD IS NULL)
                                    </cfquery>
                                    <cfif get_this_.recordcount and len(get_this_.TOTAL_ODENEK)>
                                        <cfset this_ = this_ + get_this_.TOTAL_ODENEK>
                                    </cfif>
                                    <cfset total_odenek = total_odenek + this_>
                                    <cfquery name="get_this_net" dbtype="query">
                                        SELECT SUM(AMOUNT_PAY) AS TOTAL_ODENEK_NET FROM get_odeneks WHERE EMPLOYEE_PUANTAJ_ID = #employee_puantaj_id# AND COMMENT_PAY = '#cca#'
                                    </cfquery>
                                    <cfif get_this_net.recordcount and len(get_this_net.total_odenek_net)>
                                        <cfset this_net =  get_this_net.total_odenek_net>
                                    <cfelse>
                                        <cfset this_net =  0>
                                    </cfif>
                                    <cfset total_odenek_net = total_odenek_net + this_net>
                                    <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(this_)#"></td>
                                    <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(this_net)#"></td>
                                </cfloop>
                            </cfif>
                            <!--- //resmi odenekler --->
                            <!--- avans ve kesinti hesabi --->
                            <td width="1"></td>
                            <cfif get_kesinti_adlar.recordcount>
                                <cfquery name="get_this_avans_" dbtype="query">
                                    SELECT SUM(AMOUNT) AS TOTAL_AVANS FROM get_kesintis WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND COMMENT_PAY = 'Avans'
                                </cfquery>	
                            </cfif>
                            <cfif get_kesinti_adlar.recordcount and get_this_avans_.recordcount and len(get_this_avans_.TOTAL_AVANS)>
                                <cfset this_avans_ =  avans + get_this_avans_.TOTAL_AVANS>
                            <cfelse>
                                <cfset this_avans_ =  avans>
                            </cfif>			
                            <td style="text-align:right;">#this_avans_#</td>
                            <cfif get_kesinti_adlar.recordcount>
                                <cfset count_ = 0>
                                <cfloop list="#kesinti_names#" index="cca">
                                    <cfset count_ = count_ + 1>
                                    <cfquery name="get_this_" dbtype="query">
                                        SELECT SUM(AMOUNT_2) AS TOTAL_ODENEK FROM get_kesintis WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND COMMENT_PAY = '#cca#' AND PAY_METHOD = 2
                                    </cfquery>
                                    <cfif get_this_.recordcount and len(get_this_.TOTAL_ODENEK)>
                                        <cfset this_ =  get_this_.TOTAL_ODENEK>
                                    <cfelse>
                                        <cfset this_ =  0>
                                    </cfif>
                                    <cfquery name="get_this_" dbtype="query">
                                        SELECT SUM(AMOUNT) AS TOTAL_ODENEK FROM get_kesintis WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND COMMENT_PAY = '#cca#' AND (PAY_METHOD <> 2 OR PAY_METHOD IS NULL)
                                    </cfquery>
                                    <cfif get_this_.recordcount and len(get_this_.TOTAL_ODENEK)>
                                        <cfset this_ =  this_ + get_this_.TOTAL_ODENEK> 
                                    </cfif>
                                    <cfset total_kesinti = total_kesinti + this_>
                                    <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(this_)#"></td>
                                </cfloop>
                            </cfif>
                            <!--- //avans ve kesinti hesabi --->
                            <!--- g resmi odenekler --->
                            <cfif get_gr_odenek_adlar.recordcount>
                                <td width="1"></td>
                                <cfset count_ = 0>
                                <cfset satir_gr_toplam = 0>
                                <cfloop list="#gr_odenek_names#" index="cca">
                                    <cfset count_ = count_ + 1>
                                    <cfquery name="get_this_gr_odenek" dbtype="query">
                                        SELECT AMOUNT_PAY,CALC_DAYS FROM get_gr_odeneks WHERE IN_OUT_ID = #IN_OUT_ID# AND COMMENT_PAY = '#cca#'
                                    </cfquery>
                                    <cfset this_ =  0>
                                    <cfif get_this_gr_odenek.recordcount>
                                        <cfloop query="get_this_gr_odenek">
                                            <cfset tutar_ = get_this_gr_odenek.AMOUNT_PAY>
                                            <cfif get_this_gr_odenek.CALC_DAYS eq 1>
                                                <cfset tutar_ = (tutar_ / 30) * (gr_gun_-gr_izin)>
                                            </cfif>
                                            <cfset this_ = this_ + tutar_>
                                        </cfloop>								
                                    </cfif>
                                    <cfset total_gr_odenek = total_gr_odenek + this_>
                                    <cfset satir_gr_toplam = satir_gr_toplam + this_>
                                    <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(this_)#"></td>
                                </cfloop>
                                <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(satir_gr_toplam)#"></td>
                            </cfif>
                            <!--- //g resmi odenekler --->
                            <!--- g resmi kesinti --->
                            <cfif get_gr_kesinti_adlar.recordcount>
                                <td width="1" format="numeric"></td>
                                <cfset count_ = 0>
                                <cfset satir_gr_kesinti_toplam = 0>
                                <cfloop list="#gr_kesinti_names#" index="cca">
                                    <cfset count_ = count_ + 1>
                                    <cfquery name="get_this_" dbtype="query">
                                        SELECT SUM(AMOUNT_GET) AS TOTAL_ODENEK FROM get_gr_kesintis WHERE IN_OUT_ID = #IN_OUT_ID# AND COMMENT_GET = '#cca#'
                                    </cfquery>
                                    <cfif get_this_.recordcount and len(get_this_.TOTAL_ODENEK)>
                                        <cfset this_ =  get_this_.TOTAL_ODENEK>
                                    <cfelse>
                                        <cfset this_ =  0>
                                    </cfif>
                                    <cfset total_gr_kesinti = total_gr_kesinti + this_>
                                    <cfset satir_gr_kesinti_toplam = satir_gr_kesinti_toplam + this_>
                                    <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(this_)#"></td>
                                </cfloop>
                                <td style="text-align:right;" format="numeric"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(satir_gr_kesinti_toplam)#"></td>
                            </cfif>
                            <!--- //g resmi kesinti --->
                            <!--- g resmi avans --->
                            <td width="1"></td>
                            <td style="text-align:right;" format="numeric">
                                <cfif get_gr_avans.recordcount>
                                    <cfquery name="get_this_" dbtype="query">
                                        SELECT SUM(AMOUNT) AS TOTAL_ODENEK FROM get_gr_avans WHERE IN_OUT_ID = #IN_OUT_ID#
                                    </cfquery>
                                    <cfif get_this_.recordcount and len(get_this_.TOTAL_ODENEK)>
                                        <cfset this_ =  get_this_.TOTAL_ODENEK>
                                    </cfif>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(this_)#">
                                    <cfset this_ =  0>
                                <cfelse>
                                    <cfset this_ =  0>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(this_)#">
                                </cfif>
                                <cfset total_avans = total_avans + this_>
                            </td>
                            <!--- //g resmi avans --->
                            <td width="1"></td>
                            <!--- gr fazla mesai --->
                            <td style="text-align:right;" format="numeric">
                                <cfif get_ext_worktimes.recordcount>
                                    <cfquery name="GET_EXT_WORKTIMES_ROW" dbtype="query">
                                        SELECT 
                                            START_TIME,
                                            DAY_TYPE,
                                            END_TIME									
                                        FROM
                                            GET_EXT_WORKTIMES
                                        WHERE
                                            IN_OUT_ID = #in_out_id#
                                    </cfquery>
                                    <cfif get_ext_worktimes_row.recordcount>
                                        <cfquery name="GET_SALARY_MONTH_ROW" dbtype="query">
                                            SELECT 
                                                *
                                            FROM 
                                                GET_SALARY_MONTH
                                            WHERE 
                                                EMPLOYEE_ID = #employee_id#
                                        </cfquery>
                                        <cfset GET_SALARY_MONTH_ROW.aylik_maas = gr_maas_>
                                        <cfset GET_SALARY_MONTH_ROW.SALARY_TYPE = GET_GR_MAAS.GR_MAAS[listfind(in_out_id_list,in_out_id,',')]>
                                        <cfset attributes.sal_mon = MONTH(get_ext_worktimes_row.start_time)>
                                        <cfset attributes.sal_year = YEAR(get_ext_worktimes_row.start_time)>
                                        <cfset attributes.group_id = "">
                                        <cfif len(puantaj_group_ids)>
                                            <cfset attributes.group_id = "#PUANTAJ_GROUP_IDS#,">
                                        </cfif>
                                        <cfset attributes.branch_id = branch_id>
                                        <cfset not_kontrol_parameter = 1>
                                        <cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
                                        <cfif get_program_parameters.recordcount>
                                            <cfif isdefined("get_salary_month") and get_salary_month_row.recordcount and len(get_salary_month_row.aylik_maas) and len(get_our_company_hours.ssk_aylik_maas)>
                                                <cfif get_salary_month_row.SALARY_TYPE eq 0>
                                                    <cfset aylik_maas_birim = get_salary_month_row.aylik_maas>
                                                <cfelseif get_salary_month_row.SALARY_TYPE eq 1> 
                                                    <cfset aylik_maas_birim = get_salary_month_row.aylik_maas / get_our_company_hours.gunluk_saat>
                                                <cfelse>
                                                    <cfset aylik_maas_birim = get_salary_month_row.aylik_maas/get_our_company_hours.ssk_aylik_maas>
                                                </cfif>
                                            <cfelse>
                                                <cfset aylik_maas_birim = 0>	
                                            </cfif>
                                            
                                            <cfset mesai_farki = 0>
                                            <cfloop query="GET_EXT_WORKTIMES_ROW">
                                                <cfif get_ext_worktimes_row.day_type eq 0>
                                                    <cfif len(get_program_parameters.EX_TIME_PERCENT_HIGH)>
                                                        <cfset mesai_turu = get_program_parameters.EX_TIME_PERCENT_HIGH/100>
                                                    <cfelse>
                                                        <cfset mesai_turu = 1.5>
                                                    </cfif>
                                                <cfelseif get_ext_worktimes_row.day_type eq 1>
                                                    <cfif len(get_program_parameters.WEEKEND_MULTIPLIER)>
                                                        <cfset mesai_turu = get_program_parameters.WEEKEND_MULTIPLIER>
                                                    <cfelse>
                                                        <cfset mesai_turu = get_program_parameters.EX_TIME_PERCENT_HIGH/100>
                                                    </cfif>
                                                <cfelseif get_ext_worktimes_row.day_type eq 2>
                                                    <cfif len(get_program_parameters.OFFICIAL_MULTIPLIER)>
                                                        <cfset mesai_turu = get_program_parameters.OFFICIAL_MULTIPLIER>
                                                    <cfelse>
                                                        <cfset mesai_turu = 1>
                                                    </cfif>
                                                <cfelseif get_ext_worktimes_row.day_type eq 3>
                                                    <cfif len(get_program_parameters.OFFICIAL_MULTIPLIER)>
                                                        <cfset mesai_turu = get_program_parameters.OFFICIAL_MULTIPLIER>
                                                    <cfelse>
                                                        <cfset mesai_turu = 1>
                                                    </cfif>
                                                </cfif>
                                                <cfset mesai_farki = datediff("n",get_ext_worktimes_row.START_TIME,get_ext_worktimes_row.END_TIME)/60>
                                                <cfset total_p_fazla_mesai = total_p_fazla_mesai+gr_maas_gosterilecek_ /(GET_OUR_COMPANY_HOURS.ssk_work_hours* 30)* mesai_turu * mesai_farki>
                                                <cfset gt_p_fazla_mesai = gt_p_fazla_mesai + (gr_maas_gosterilecek_ /(GET_OUR_COMPANY_HOURS.ssk_work_hours* 30)* mesai_turu * mesai_farki)>
                                            </cfloop>
                                        </cfif>
                                    </cfif>
                                <cfelse>
                                    <cfset total_p_fazla_mesai= 0>
                                </cfif>
                                <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total_p_fazla_mesai)#"><!---planlanan fazla mesai--->
                            </td>
                            <td width="1"></td>
                            <!--- gr fazla mesai --->					
        
                            <!--- planlanan mesai --->
                            <td style="text-align:right;"   format="numeric">
                                <cfif attributes.salary_type eq 0>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gr_maas_+ total_p_fazla_mesai + total_gr_odenek - bes_isci_hissesi - total_gr_kesinti - total_avans - AVANS - ozel_kesinti)#">
                                    <cfif not isdefined("attributes.is_excel")><input type="hidden" value="#(gr_maas_ + total_gr_odenek - bes_isci_hissesi - total_gr_kesinti)#" name="gr_durum" id="gr_durum"></cfif>
                                <cfelse>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gr_maas_ + total_p_fazla_mesai + total_gr_odenek - bes_isci_hissesi - total_gr_kesinti)#">
                                    <cfif not isdefined("attributes.is_excel")><input type="hidden" value="#(gr_maas_ + total_gr_odenek - bes_isci_hissesi - total_gr_kesinti - total_avans)#" name="gr_durum" id="gr_durum"></cfif>
                                </cfif>
                            </td>
                            <td style="text-align:right;"><cfif isdefined("GET_GRR.GRR")>#GET_GRR.GRR#</cfif></td>
                            <td style="text-align:right;"   format="numeric">
                                <cfif attributes.salary_type eq 0>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(NET_UCRET-vergi_iadesi)#"><cfif not isdefined("attributes.is_excel")><input type="hidden" value="#NET_UCRET-vergi_iadesi#" name="resmi_durum" id="resmi_durum"></cfif>
                                <cfelse>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(NET_UCRET)#"><cfif not isdefined("attributes.is_excel")><input type="hidden" value="#NET_UCRET#" name="resmi_durum" id="resmi_durum"></cfif>
                                </cfif>
                            </td>
                            <td>#MONEY#</td>
                            <cfif attributes.salary_type eq 0>
                                <td style="text-align:right;" format="numeric"  ><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(vergi_iadesi)#"><cfif not isdefined("attributes.is_excel")><input type="hidden" value="#vergi_iadesi#" name="agi_durum" id="agi_durum"></cfif></td>
                                <td style="text-align:right;" format="numeric"  >
                                    <cfif attributes.salary_type eq 0>
                                        <cfset value_ = (gr_maas_ + total_gr_odenek + total_p_fazla_mesai) - bes_isci_hissesi - total_gr_kesinti- (NET_UCRET - vergi_iadesi) - AVANS - ozel_kesinti+(KIDEM_AMOUNT_NET+IHBAR_AMOUNT_NET+YILLIK_IZIN_AMOUNT_NET)>
                                    <cfelse>
                                        <cfset value_ = (gr_maas_ + total_gr_odenek + gt_p_fazla_mesai - bes_isci_hissesi - total_gr_kesinti - total_avans) + (NET_UCRET - vergi_iadesi)+(KIDEM_AMOUNT_NET+IHBAR_AMOUNT_NET+YILLIK_IZIN_AMOUNT_NET)>
                                    </cfif>
                                    <cfif not isdefined("attributes.is_excel")><input type="hidden" value="#value_#" name="son_durum" id="son_durum"></cfif>
                                    <cfset toplam_durum = value_>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(value_)#">
                                </td>
                                <td style="text-align:right;" format="numeric"  >
                                    <!---<cfset value_ = (gr_maas_ + total_p_fazla_mesai + total_gr_odenek - bes_isci_hissesi - total_gr_kesinti - total_avans) - (NET_UCRET - vergi_iadesi) - AVANS - ozel_kesinti+(KIDEM_AMOUNT_NET+IHBAR_AMOUNT_NET+YILLIK_IZIN_AMOUNT_NET)>--->
                                    <cfset son_durum = toplam_durum+vergi_iadesi>
                                    <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(son_durum)#">
                                </td>
                            </cfif>
                            <cfif not isdefined("attributes.is_excel")><input type="hidden" value="#employee_id#" name="employee_id_list" id="employee_id_list"></cfif>
                            <cfif not isdefined("attributes.is_excel")><input type="hidden" value="#in_out_id#" name="in_out_id_list" id="in_out_id_list"></cfif>
                        </tr>
                        <cfset gt_total_odenek = gt_total_odenek + total_odenek>
                        <cfset gt_total_odenek_net = gt_total_odenek_net + total_odenek_net>
                        <cfset gt_total_kesinti = gt_total_kesinti + total_kesinti + this_avans_>
                        <cfset gt_total_gr_odenek = gt_total_gr_odenek + total_gr_odenek>
                        <cfset gt_total_gr_kesinti = gt_total_gr_kesinti + total_gr_kesinti>
                        <cfset gt_total_avans = gt_total_avans + total_avans>
                        <cfif attributes.salary_type eq 0>
                            <cfset gt_gr_durum = gt_gr_durum + (gr_maas_ + total_p_fazla_mesai + total_gr_odenek - bes_isci_hissesi - total_gr_kesinti - total_avans - AVANS - ozel_kesinti)+(KIDEM_AMOUNT_NET+IHBAR_AMOUNT_NET+YILLIK_IZIN_AMOUNT_NET)>
                        <cfelse>
                            <cfset gt_gr_durum = gt_gr_durum + (gr_maas_ + total_p_fazla_mesai + total_gr_odenek - bes_isci_hissesi - total_gr_kesinti)+(KIDEM_AMOUNT_NET+IHBAR_AMOUNT_NET+YILLIK_IZIN_AMOUNT_NET)>
                        </cfif>
                        <cfset gt_r_durum = gt_r_durum + NET_UCRET>
                        <cfset g_net_total = g_net_total +(KIDEM_AMOUNT_NET+IHBAR_AMOUNT_NET+YILLIK_IZIN_AMOUNT_NET)>                
                    </cfoutput>
                    </tbody>
                    <cfif not isdefined("attributes.is_excel")>
                        <cfset cols_ = 15>
                        <cfif isdefined("attributes.is_bank_accounts")>
                            <cfset cols_ = cols_ + 3>
                        </cfif>
                        <cfoutput>
                        <tfoot>
                            <tr height="25">
                                <td colspan="#cols_#" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id="40302.Toplamlar"></td>
                                <td class="txtbold">#gun_toplam#</td>
                                <cfif x_count_off_puantaj_offtime eq 1>
                                    <td class="txtbold">#gr_izin_toplam#</td>
                                </cfif>
                                <td class="txtbold">#gr_gun_toplam#</td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(maas_toplam)#"></td>
                                <td>&nbsp;</td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gr_maas_toplam)#"></td>
                                <td>&nbsp;</td>
                                <cfif attributes.salary_type eq 0>
                                    <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gr_maas_toplam - maas_toplam)#"></td>
                                </cfif>
                                <td width="1"></td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_net_ucret)#"></td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_total_salary)#"></td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_ext_salary)#"></td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_ek_odenek)#"></td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_kesinti)#"></td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_vergi_indirimi)#"></td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_vergi_iadesi)#"></td>
                                <td align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_bes)#"></td>
                                <cfif get_people.recordcount and get_odenek_adlar.recordcount>
                                    <td width="1"></td>
                                    <td colspan="<cfoutput>#get_odenek_adlar.recordcount + get_odenek_adlar.recordcount#</cfoutput>" class="txtbold" style="text-align:right;"  ><cf_get_lang dictionary_id='38990.Brüt'>: <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_total_odenek)#"> - Net: <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_total_odenek_net)#"></td>
                                </cfif>
                                <td width="1"></td>
                                    <td colspan="<cfif get_people.recordcount and get_kesinti_adlar.recordcount><cfoutput>#get_kesinti_adlar.recordcount+1#</cfoutput><cfelse>1</cfif>" align="right" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_total_kesinti)#"></td>
                                <cfif get_people.recordcount and get_gr_odenek_adlar.recordcount>
                                    <td width="1"></td>
                                    <td colspan="<cfoutput>#get_gr_odenek_adlar.recordcount+1#</cfoutput>" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_total_gr_odenek)#"></td>
                                </cfif>
                                <cfif get_people.recordcount and get_gr_kesinti_adlar.recordcount>
                                    <td width="1"></td>
                                    <td colspan="<cfoutput>#get_gr_kesinti_adlar.recordcount+1#</cfoutput>" class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_total_gr_kesinti)#"></td>
                                </cfif>
                                <td width="1"></td>
                                <td class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_total_avans)#"></td>
                                <td width="1"></td>
                                <td class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_p_fazla_mesai)#"></td>
                                <td width="1"></td>
                                <td   class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_gr_durum)#"></td>
                                <td></td>
                                <td align="right"   class="txtbold" style="text-align:right;"><cfif attributes.salary_type eq 0><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_r_durum-gt_vergi_iadesi)#"><cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_r_durum)#"></cfif></td>
                                <td></td>
                                <cfif attributes.salary_type eq 0>
                                    <td   class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_vergi_iadesi)#"></td>
                                    <td   class="txtbold" style="text-align:right;">
                                        <cfset toplam_son_durum = gt_gr_durum - (gt_r_durum - gt_vergi_iadesi)>
                                        <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(gt_gr_durum - (gt_r_durum - gt_vergi_iadesi))#"></td>
                                    <td   class="txtbold" style="text-align:right;">
                                        <!---<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(maas_)# #maas_money_#">#TLFormat((gr_maas_toplam + gt_total_gr_odenek) + total_p_fazla_mesai - gt_bes - (gt_r_durum - gt_vergi_iadesi) - gt_total_gr_kesinti - gt_total_avans+g_net_total)#--->
                                        <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(toplam_son_durum+gt_vergi_iadesi)#">
                                    </td>
                                </cfif>
                            </tr>
                            <cfset cols_ = 32>
                            <cfif isdefined("attributes.is_bank_accounts")>
                                <cfset cols_ = cols_ + 3>
                            </cfif>
                            <cfif x_count_off_puantaj_offtime eq 1>
                            <cfset cols_ = cols_ + 1>
                            </cfif>
                            <cfif get_people.recordcount and get_odenek_adlar.recordcount>
                                <cfset cols_ = cols_ + 1 + get_odenek_adlar.recordcount  + get_odenek_adlar.recordcount> 
                            </cfif>
                            <cfif get_people.recordcount and get_kesinti_adlar.recordcount>
                                <cfset cols_ = cols_ + 1 + get_kesinti_adlar.recordcount + 1>
                            <cfelse>
                                <cfset cols_ = cols_ + 2>
                            </cfif>
                            <cfif get_people.recordcount and get_gr_odenek_adlar.recordcount>
                                <cfset cols_ = cols_ + 1 + get_gr_odenek_adlar.recordcount + 1>
                            </cfif>
                            <cfif get_people.recordcount and get_gr_kesinti_adlar.recordcount>
                                <cfset cols_ = cols_ + 1 + get_gr_kesinti_adlar.recordcount + 1>
                            </cfif>
                            <cfset cols_ = cols_ + 3>
                            <cfif attributes.salary_type eq 1>
                                <cfset cols_ = cols_ - 1>
                            </cfif>
                            <tr height="25">
                                <td colspan="#cols_#" align="right" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id="40302.Toplamlar"></td>
                                <td></td>
                                <td align="center"><input type="button" value="TD 1" style="color:blue" onclick="gonder('1');"></td>
                                <td>&nbsp;</td>
                                <td align="center"><input type="button" value="TD 2" style="color:blue" onclick="gonder('2');"></td>
                                <td>&nbsp;</td>
                                <cfif attributes.salary_type eq 0>
                                    <td align="center"><input type="button" value="TD 3" onclick="gonder('3');"></td>
                                    <td align="center"><input type="button" value="TD 4" onclick="gonder('4');"></td>
                                    <td></td>
                                </cfif>
                            </tr>
                        </tfoot>
                        </cfoutput>
                    </cfif>
                <cfelse>
                    <tbody>
                        <tr height="20">
                            <td colspan="<cfoutput>#myCol+44#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                        </tr>
                    </tbody>
                </cfif>
            </cfif>
    </cf_report_list>
</cfif>
</cfform>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfscript>
            adres = '';
            if (isDefined('attributes.branch_id') and len(attributes.branch_id))
                adres = adres&"&branch_id="&attributes.branch_id;
            if (isDefined('attributes.department') and len(attributes.department))
                adres = adres&"&department="&attributes.department;
            if (isDefined('attributes.position_branch_id') and len(attributes.position_branch_id))
                adres = adres&"&position_branch_id="&attributes.position_branch_id;
            if (isDefined('attributes.position_department') and len(attributes.position_department))
                adres = adres&"&position_department="&attributes.position_department;
            if (isDefined('attributes.sal_mon') and len(attributes.sal_mon))
                adres = adres&"&sal_mon="&attributes.sal_mon;
            if (isDefined('attributes.sal_year') and len(attributes.sal_year))
                adres = adres&"&sal_year="&attributes.sal_year;
            if (isDefined('attributes.salary_type') and len(attributes.salary_type))
                adres = adres&"&salary_type="&attributes.salary_type;
            if (isDefined('attributes.func_id') and len(attributes.func_id))
                adres = adres&"&func_id="&attributes.func_id;
            if (isDefined('attributes.position_cat_id') and len(attributes.position_cat_id))
                adres = adres&"&position_cat_id="&attributes.position_cat_id;
            if (isDefined('attributes.title_id') and len(attributes.title_id))
                adres = adres&"&title_id="&attributes.title_id;
            if (isDefined('attributes.is_bank_accounts'))
                adres = adres&"&is_bank_accounts=1";
            if (isDefined('attributes.is_excel'))
                adres = adres&"&is_excel=1";
            if (len(attributes.keyword))
                adres = adres&"&keyword="&attributes.keyword;
            adres = adres&"&form_submitted=1";
        </cfscript>
        <cf_paging 
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="report.manage_all_salaries#adres#">
    </cfif>