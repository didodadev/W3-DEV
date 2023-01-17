<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.branch_id" default="">
	<cfparam name="attributes.department" default="">
	<cfparam name="attributes.is_active" default="1">
	<cfparam name="attributes.is_view" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.pos_cat_id" default="">
	<cfquery name="get_department" datasource="#dsn#">
		SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif len(attributes.branch_id)>BRANCH_ID IN (#attributes.branch_id#) AND </cfif>IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
	</cfquery>
	<cfquery name="get_position_cat" datasource="#dsn#">
		SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT   
	</cfquery>
	<cfscript>
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		cmp_branch = createObject("component","hr.cfc.get_branches");
		cmp_branch.dsn = dsn;
		get_branches = cmp_branch.get_branch(status:0);
		url_str = "";
		if(len(attributes.branch_id))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
		if(len(attributes.department))
			url_str = "#url_str#&department=#attributes.department#";
		if(len(attributes.is_active))
			url_str = "#url_str#&is_active=#attributes.is_active#";
		if(len(attributes.is_view))
			url_str = "#url_str#&is_view=#attributes.is_view#";
		if(len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if(len(attributes.pos_cat_id))
			url_str = "#url_str#&pos_cat_id=#attributes.pos_cat_id#";
		if(isdefined('attributes.form_submit') and len(attributes.form_submit))
			url_str = "#url_str#&form_submit=#attributes.form_submit#";
	</cfscript>
	
	<cfif isdefined('attributes.form_submit')>
		<cfquery name="get_executions" datasource="#dsn#">
			WITH CTE1 AS (
				SELECT
					EE.RECORD_EMP,
	                EE.RECORD_DATE,
	                EE.UPDATE_EMP,
	                EE.UPDATE_DATE,
	                EE.EXECUTION_OFFICE,
	                EE.DETAIL,
	                EI.TC_IDENTY_NO,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					B.BRANCH_NAME,
					D.DEPARTMENT_HEAD,
					SPC.POSITION_CAT,
					EE.EXECUTION_CAT,
					ISNULL(EE.DEBT_AMOUNT,0) AS DEBT_AMOUNT,
					EE.EXECUTION_ID,
					EE.PRIORITY,
					EE.NOTIFICATION_DATE,
					ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3),0) AS ODENEN_TOPLAM,
					(SELECT TOP 1 EP.SAL_MON FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE INNER JOIN EMPLOYEES_PUANTAJ_ROWS PR ON RE.EMPLOYEE_PUANTAJ_ID = PR.EMPLOYEE_PUANTAJ_ID INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = PR.PUANTAJ_ID  WHERE RE.COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3 ORDER BY RE.EMPLOYEE_PUANTAJ_EXT_ID) AS ILK_KESINTI_AY,
					(SELECT TOP 1 EP.SAL_YEAR FROM EMPLOYEES_PUANTAJ_ROWS_EXT RE INNER JOIN EMPLOYEES_PUANTAJ_ROWS PR ON RE.EMPLOYEE_PUANTAJ_ID = PR.EMPLOYEE_PUANTAJ_ID INNER JOIN EMPLOYEES_PUANTAJ EP ON EP.PUANTAJ_ID = PR.PUANTAJ_ID  WHERE RE.COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3 ORDER BY RE.EMPLOYEE_PUANTAJ_EXT_ID) AS ILK_KESINTI_YIL			
				FROM
					EMPLOYEES_EXECUTIONS EE
					INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EE.EMPLOYEE_ID
					INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = EE.EMPLOYEE_ID
					INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EE.EMPLOYEE_ID
					LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
					LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
					LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
				WHERE
					EP.IS_MASTER = 1
					<cfif len(attributes.keyword)>
						AND E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					</cfif>
					<cfif len(attributes.branch_id)>
						AND B.BRANCH_ID IN (#attributes.branch_id#)
					</cfif>
					<cfif len(attributes.department)>
						AND EP.DEPARTMENT_ID IN (#attributes.department#)
					</cfif>
					<cfif len(attributes.pos_cat_id)>
						AND EP.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
					</cfif>
					<cfif len(attributes.is_active) and attributes.is_active eq 1>
						AND EE.IS_ACTIVE = 1
					<cfelseif len(attributes.is_active) and attributes.is_active eq 0>
						AND EE.IS_ACTIVE = 0
					</cfif>
	                <cfif isdefined('attributes.is_view') and attributes.is_view eq 1> <!--- bakiyesi olanlar--->
						AND (EE.DEBT_AMOUNT-ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3),0)) > 0
	                <cfelseif isdefined('attributes.is_view') and attributes.is_view eq 0>
	                	AND (EE.DEBT_AMOUNT-ISNULL((SELECT SUM(CASE WHEN PAY_METHOD = 1 THEN AMOUNT_2 WHEN PAY_METHOD = 2 THEN AMOUNT END) FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE COMMENT_PAY_ID = EE.EXECUTION_ID AND EXT_TYPE = 3),0)) <= 0
	                </cfif>
			),
	            CTE2 AS (
	            	SELECT
	                	CTE1.*,
	                    	ROW_NUMBER() OVER (	ORDER BY
	                        	EMPLOYEE_NAME, EMPLOYEE_SURNAME, PRIORITY
	                      	) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
	               	FROM
	                	CTE1
	           		)
	                SELECT
	                    CTE2.*
	               	FROM
	                	CTE2
					WHERE
						RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
		</cfquery>
	<cfelse>
		<cfset get_executions.recordcount = 0>
		<cfset get_executions.query_count = 0>
	</cfif>
	<cfparam name="attributes.totalrecords" default='#get_executions.query_count#'>
<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfquery name="get_ch_types" datasource="#dsn#">
		SELECT ACC_TYPE_ID,ACC_TYPE_NAME FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
	</cfquery>
	<cfif isdefined("attributes.event") and attributes.event is 'upd'>
		<cfquery name="get_execution" datasource="#dsn#">
			SELECT
				EE.RECORD_EMP,
		        EE.RECORD_DATE,
		        EE.UPDATE_EMP,
		        EE.UPDATE_DATE,
		        EE.IS_ACTIVE,
				EE.EXECUTION_CAT,
				EE.EMPLOYEE_ID,
				EE.EMP_INOUT_ID,
				EE.EXECUTION_OFFICE,
				EE.CREDITOR,
				EE.EXECUTION_OFFICE_IBAN,
				EE.DEDUCTION_TYPE,
				EE.DEDUCTION_VALUE,
				EE.DEBT_AMOUNT,
				EE.ACC_TYPE_ID,
				EE.ACCOUNT_NAME,
				EE.ACCOUNT_CODE,
				EE.COMPANY_ID,
				EE.CONSUMER_ID,
				EE.DETAIL,
				EE.PRIORITY,
				EE.NOTIFICATION_DATE,
		        EE.FILE_NO,
		        E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
		        B.BRANCH_NAME,
				(CASE WHEN EE.COMPANY_ID IS NOT NULL THEN C.NICKNAME WHEN EE.CONSUMER_ID IS NOT NULL THEN CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME ELSE ''END) AS MEMBER_NAME
			FROM
				EMPLOYEES_EXECUTIONS EE
		        INNER JOIN EMPLOYEES E ON EE.EMPLOYEE_ID = E.EMPLOYEE_ID
		        INNER JOIN EMPLOYEES_IN_OUT EIO ON EE.EMP_INOUT_ID = EIO.IN_OUT_ID 
		        INNER JOIN BRANCH B ON B.BRANCH_ID = EIO.BRANCH_ID 
				LEFT JOIN COMPANY C ON C.COMPANY_ID = EE.COMPANY_ID
				LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = EE.CONSUMER_ID
			WHERE
				EE.EXECUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		</cfquery>
		<cfquery name="get_puantaj_rows_ext" datasource="#dsn#">
			SELECT
				EPRE.EMPLOYEE_PUANTAJ_EXT_ID,
				ISNULL((CASE WHEN EPRE.PAY_METHOD = 1 THEN EPRE.AMOUNT_2 WHEN EPRE.PAY_METHOD = 2 THEN EPRE.AMOUNT END),0) AS ODENEN,
				EP.SAL_MON,
				EP.SAL_YEAR
			FROM
				EMPLOYEES_PUANTAJ_ROWS_EXT EPRE
				INNER JOIN EMPLOYEES_PUANTAJ EP ON EPRE.PUANTAJ_ID = EP.PUANTAJ_ID
			WHERE
				EPRE.COMMENT_PAY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
				AND EPRE.EXT_TYPE = 3
			ORDER BY
				EP.SAL_YEAR,
				EP.SAL_MON
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
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
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function control()
		{
			if($('#execution_cat').val() == "")
			{
				alert("<cf_get_lang_main no='218.Tip'>");
				return false;
			}
			if($('#employee_id').val() == "" || $('#employee').val() == "")
			{
				alert("<cf_get_lang_main no='164.Çalışan'>");
				return false;	
			}
			if($('#priority').val() == "")
			{
				alert("<cf_get_lang_main no='73.Öncelik'>");
				return false;	
			}
			if($('#notification_date').val() == "")
			{
				alert("<cf_get_lang dictionary_id='54573.Tebliğ Tarihi'>");
				return false;	
			}
			if($('#deduction_type').val() == "")
			{
				alert("<cf_get_lang dictionary_id='54582.Kesinti Yöntemi'>");
				return false;
			}
			if($('#deduction_value').val() == "")
			{
				alert("<cf_get_lang dictionary_id='54583.Kesinti Yöntemi Tutarı'>");
				return false;
			}
			if ($('#deduction_type').val() == 1 && $('#deduction_value').val() > 25)
			{
				alert("<cf_get_lang dictionary_id='54588.Yüzde Tutarı 25 den Büyük Olamaz'>");
				$('#deduction_value').focus();
				return false;
			}
			if($('#debt_amount').val() == "")
			{
				alert("<cf_get_lang dictionary_id='54589.Borç Miktarı'>");
				return false;
			}		
			$('#debt_amount').val(filterNum($('#debt_amount').val(),4));
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_executions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_emp_execution.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_execution';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/popup_form_add_execution.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_execution.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_executions&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_execution';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/ehesap/form/upd_execution.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/ehesap/query/upd_execution.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_executions&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_execution';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_execution.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_execution.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_executions';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'ehesapListExecutions.cfm';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEES_EXECUTIONS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-execution_cat','item-employee','item-priority','item-notification_date','item-deduction_type','item-debt_amount']";
</cfscript>
