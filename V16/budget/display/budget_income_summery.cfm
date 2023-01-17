<cf_xml_page_edit>
<cfparam name="attributes.income_cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.process_cat" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.expense_employee" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.branch_id" default="">
<cfif isDefined("attributes.record_date1") and isDate(attributes.record_date1)>
	<cf_date tarih = "attributes.record_date1">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.record_date1=''>
	<cfelse>
		<cfset attributes.record_date1 = dateadd('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isDefined("attributes.record_date2") and isDate(attributes.record_date2)>
	<cf_date tarih = "attributes.record_date2">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.record_date2=''>
	<cfelse>
		<cfset attributes.record_date2 = dateadd('d',-7,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
	<cf_date tarih = "attributes.search_date1">
<cfelse>	
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date1 = ''>
	<cfelse>
		<cfset attributes.search_date1 = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
	<cf_date tarih = "attributes.search_date2">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date2 = ''>
	<cfelse>
		<cfset attributes.search_date2 = date_add('d',7,attributes.search_date1)>
	</cfif>
</cfif>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_xauthorizedbranch = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'budget.detail_budget_report',
    property_name : 'x_authorized_branch'
    )>
<cfset x_authorized_branch = get_xauthorizedbranch.PROPERTY_VALUE>
<cfset get_xauthorizedbranchall = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'budget.detail_budget_report',
    property_name : 'x_authorized_branch_all'
    )>
<cfset x_authorized_branch_all = get_xauthorizedbranchall.PROPERTY_VALUE>
<cfset get_xauthorizedbranchpositions = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'budget.detail_budget_report',
    property_name : 'x_authorized_branch_positions'
    )>
<cfset x_authorized_branch_positions = get_xauthorizedbranchpositions.PROPERTY_VALUE>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER 
	WHERE
	EXPENSE_ACTIVE = 1
	<cfif x_authorized_branch eq 1 and isdefined("x_authorized_branch_positions") and not listfind(x_authorized_branch_positions,session.ep.position_code)>
		AND 
			(
			EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
			<cfif isdefined("x_authorized_branch_all") and x_authorized_branch_all neq 1>
				OR (EXPENSE_BRANCH_ID = -1)
			</cfif>
			)
		AND 
		(
		(
			(EXPENSE_DEPARTMENT_ID IN(SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
			or
			(EXPENSE_DEPARTMENT_ID IN(select D2.DEPARTMENT_ID from #dsn_alias#.DEPARTMENT D LEFT JOIN #dsn_alias#.DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID) where d.DEPARTMENT_ID = (SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)))
		)
		)
			OR
			EXPENSE_DEPARTMENT_ID IN (
				SELECT EP.DEPARTMENT_ID
				FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP
				WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
				)
			OR
			(EXPENSE_DEPARTMENT_ID = - 1)
			)	 
	</cfif>
	ORDER BY EXPENSE
</cfquery>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<cfif len(attributes.form_submitted)>
	<cfquery name="GET_EXPENSE_ITEM_ROW_ALL" datasource="#dsn2#">
		WITH CTE1 AS ( 
        SELECT 
			EXPENSE_ITEMS_ROWS.EXPENSE_ID,
			EXPENSE_ITEMS_ROWS.EXPENSE_EMPLOYEE,
			EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID,
			EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
			EXPENSE_ITEMS_ROWS.AMOUNT,
			EXPENSE_ITEMS_ROWS.AMOUNT_KDV,
			EXPENSE_ITEMS_ROWS.AMOUNT_OTV,
			EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
			EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT,
			EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE,
			EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL,
			EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE,
			EXPENSE_ITEMS_ROWS.ACTION_ID,
			EXPENSE_ITEMS_ROWS.INVOICE_ID,
			EXPENSE_ITEMS_ROWS.DETAIL,
			EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
             (CASE WHEN EXPENSE_ITEMS_ROWS.MEMBER_TYPE='partner' THEN C.FULLNAME WHEN EXPENSE_ITEMS_ROWS.MEMBER_TYPE='consumer' THEN CN.CONSUMER_NAME +' '+ CN.CONSUMER_SURNAME ELSE E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME END)COMPANY_NAME,
            (CASE WHEN EXPENSE_ITEMS_ROWS.MEMBER_TYPE='partner' THEN C1.COMPANY_ID WHEN EXPENSE_ITEMS_ROWS.MEMBER_TYPE='consumer' THEN CN1.CONSUMER_ID ELSE E1.EMPLOYEE_ID END) COMPANY_PARTNER_ID,
            (CASE WHEN EXPENSE_ITEMS_ROWS.MEMBER_TYPE='partner' THEN C1.FULLNAME WHEN EXPENSE_ITEMS_ROWS.MEMBER_TYPE='consumer' THEN CN1.CONSUMER_NAME +' '+ CN1.CONSUMER_SURNAME ELSE E1.EMPLOYEE_NAME +' '+ E1.EMPLOYEE_SURNAME END) COMPANY_PARTNER_NAME,
			ISNULL(ROW_PAPER_NO,ISNULL((SELECT EXP.PAPER_NO FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID),(SELECT II.INVOICE_NUMBER FROM INVOICE II WHERE II.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID))) PAPER_NO,
			EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
			EXPENSE_CENTER.EXPENSE,
			BR.BRANCH_NAME BRANCH
		FROM 
			EXPENSE_ITEMS_ROWS 
			 JOIN EXPENSE_ITEMS ON EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
			 JOIN EXPENSE_CENTER ON EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
            LEFT JOIN INVOICE INV ON INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID
            LEFT JOIN EXPENSE_ITEM_PLANS EXP ON EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
            LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = (ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.COMPANY_ID,EXP.CH_COMPANY_ID))) 
            LEFT JOIN #dsn_alias#.CONSUMER CN ON  CN.CONSUMER_ID = (ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL(INV.CONSUMER_ID ,EXP.CH_CONSUMER_ID ))) 
            LEFT JOIN #dsn_alias#.EMPLOYEES E ON  E.EMPLOYEE_ID = (ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,CH_EMPLOYEE_ID)) 
           
            
            LEFT JOIN #dsn_alias#.COMPANY C1 ON C1.COMPANY_ID=EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID 
            LEFT JOIN #dsn_alias#.CONSUMER CN1 ON CN1.CONSUMER_ID = EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES E1 ON E1.EMPLOYEE_ID = EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID
			LEFT JOIN #dsn_alias#.BRANCH BR ON EXPENSE_ITEMS_ROWS.BRANCH_ID=BR.BRANCH_ID
		WHERE 
			EXPENSE_ITEMS_ROWS.IS_INCOME = 1 
			<cfif session.ep.isBranchAuthorization>
				AND EXPENSE_ITEMS_ROWS.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
			</cfif>
			<cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
				AND EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE IN (#attributes.process_cat#)
			</cfif>
			<cfif len(attributes.keyword)>
			AND 
			(
				(EXPENSE_ITEMS_ROWS.ROW_PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
				(EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE '%#attributes.keyword#%') OR
				(EXPENSE_ITEMS_ROWS.DETAIL LIKE '%#attributes.keyword#%') OR
				(EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
							(SELECT 
								EXP.EXPENSE_ID 
							FROM 
								EXPENSE_ITEM_PLANS EXP 
							WHERE 
								EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
								AND EXP.PAPER_NO LIKE '%#attributes.keyword#%'))
			)
			</cfif>
			<cfif len(attributes.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.search_date1#</cfif>
			<cfif len(attributes.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,attributes.search_date2)#</cfif>
			<cfif len(attributes.record_date1)>
				AND 
				(
					(EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
						(SELECT 
							EXP.EXPENSE_ID 
						FROM 
							EXPENSE_ITEM_PLANS EXP 
						WHERE 
							EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
							AND EXP.RECORD_DATE >= #attributes.record_date1#)
					)
				OR
					(
					EXPENSE_ITEMS_ROWS.RECORD_DATE >= #attributes.record_date1#
					)
				)
			</cfif>
			<cfif len(attributes.record_date2)>
				AND 
				(	
					(EXPENSE_ITEMS_ROWS.EXPENSE_ID IN
						(SELECT 
							EXP.EXPENSE_ID 
						FROM 
							EXPENSE_ITEM_PLANS EXP 
						WHERE 
							EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID
							AND EXP.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#)
					)
				OR
					(
					EXPENSE_ITEMS_ROWS.RECORD_DATE < #dateadd("d",1,attributes.record_date2)#
					)
				)
			</cfif>
			<cfif len(attributes.employee_id)>
				AND MEMBER_TYPE='employee'
				AND COMPANY_PARTNER_ID = #attributes.employee_id#
			</cfif>			
			<cfif len(attributes.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #attributes.expense_item_id#</cfif>
			<cfif len(attributes.expense_center_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = #attributes.expense_center_id#</cfif>
			<cfif len(attributes.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #attributes.activity_type#</cfif>
			<cfif len(attributes.asset) and len(attributes.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #attributes.asset_id#</cfif>
			<cfif len(attributes.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#" list="yes">)</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND EXPENSE_ITEMS_ROWS.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			<cfif isdefined("attributes.member_type") and (attributes.member_type is 'partner') and len(attributes.member_name) and len(attributes.company_id)>
				AND ISNULL(ISNULL((SELECT INV.COMPANY_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_COMPANY_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)),EXPENSE_ITEMS_ROWS.COMPANY_ID) = #attributes.company_id#
			</cfif>
			<cfif isdefined("attributes.member_type") and (attributes.member_type is 'consumer') and len(attributes.member_name) and len(attributes.consumer_id)>
				AND	ISNULL(ISNULL((SELECT INV.CONSUMER_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_CONSUMER_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)),EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID) = #attributes.consumer_id#
			</cfif> 
            <cfif isdefined("attributes.income_cat") and len(attributes.income_cat)>AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID = #attributes.income_cat#</cfif>
            
            ),
            CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY EXPENSE_DATE,EXP_ITEM_ROWS_ID DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT,
					XXX.*
                FROM
					CTE1
                    	OUTER APPLY
						(
							SELECT 
                                SUM(AMOUNT) AS TOPLAM1,
                                SUM(AMOUNT_KDV) AS TOPLAM2,
                                SUM(AMOUNT_OTV) AS TOPLAM7, 
                                SUM(TOTAL_AMOUNT) AS TOPLAM3
							FROM CTE1 
						) AS XXX
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
		
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_expense_item_row_all.query_count#">
	<cfif GET_EXPENSE_ITEM_ROW_ALL.recordcount>
		<cfset company_id_list=''>
		<cfset consumer_id_list=''>
        <cfset employee_id_list=''>
		<cfoutput query="get_expense_item_row_all">
			<cfif isdefined('company_id') and len(company_id) and not listfind(company_id_list,company_id)>
				<cfset company_id_list=listappend(company_id_list,company_id)>
			</cfif>
			<cfif isdefined('consumer_id') and len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
				<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
			</cfif>
            <cfif isdefined('employee_id') and len(employee_id) and not listfind(employee_id_list,employee_id)>
				<cfset employee_id_list=listappend(employee_id_list,employee_id)>
			</cfif>
		</cfoutput>
		<cfif listlen(company_id_list)>
			<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
			<cfquery name="get_company" datasource="#DSN#">
				SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID IN(#company_id_list#) ORDER BY COMPANY_ID
			</cfquery>
			<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company.COMPANY_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(consumer_id_list)>
			<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
			<cfquery name="get_consumer" datasource="#dsn#">
				SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
			</cfquery>
			<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer.CONSUMER_ID,',')),'numeric','ASC',',')>
		</cfif>
        <cfif listlen(employee_id_list)>
			<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
			<cfquery name="get_employee" datasource="#dsn#">
				SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
			<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.EMPLOYEE_ID,',')),'numeric','ASC',',')>
		</cfif>
	</cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=budget.budget_income_summery">
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#​">
				</div>
				<div class="form-group">
					<div class="input-group x-3_5">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3">
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-expense_center_id">
						<label><cf_get_lang_main no='760.Gelir Merkezi'></label>
						<select name="expense_center_id" id="expense_center_id">
							<option value=""><cfoutput>#getLang('main',322)#​</cfoutput></option>
							<cfoutput query="get_expense_center">
								<option value="#expense_id#" title="#expense#" <cfif attributes.expense_center_id eq expense_id>selected</cfif>>#expense#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-activity_type">
						<label><cf_get_lang no='90.Aktivite Tipi'></label>
						<cfsavecontent variable="text"><cfoutput>#getLang('main',322)#​</cfoutput></cfsavecontent>
						<cf_wrk_budgetactivity
						name="activity_type"
						class="txt"
						width="160"
						option_text="#text#"
						value="#attributes.activity_type#">
					</div>
					<div class="form-group" id="item-expense_item_id">
						<label><cf_get_lang_main no='761.Gelir Kalemi'></label>
						<cfsavecontent variable="text"><cfoutput>#getLang('main',322)#​</cfoutput></cfsavecontent>
						<cf_wrk_budgetItem 
						name="expense_item_id"
						value="#attributes.expense_item_id#"
						option_text="#text#"
						width="160"
						income_expense="1"
						class="txt">	
					</div>
					<div class="form-group" id="item-process_cat">
						<label class="col col-12 "><cf_get_lang dictionary_id="57800.İşlem Tipi"></label>
						<cfquery name="get_process_cat" datasource="#dsn3#">
							SELECT PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (18,302,21,22,23,2311,2313,24,25,30,31,32,33,34,35,44,45,46,48,49,50,51,52,53,54,55,56,58,59,60,62,63,64,65,66,67,68,120,161,1201,1202,1203,121,122,130,131,311,254,592,531,533,534,5312,5313,555,561,591,601,690,691,241,2410,243,291,292,293,294,2931,2932,296,318)
						</cfquery>
						<cf_multiselect_check 
							query_name="get_process_cat"  
							name="process_cat"
							width="135" 
							option_value="process_type"
							option_name="process_cat"
							value="#attributes.process_cat#"
							>	
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-income_cat">
						<label><cf_get_lang no='96.Gelir Kategori'></label>
						<cfsavecontent variable="text"><cfoutput>#getLang('main',322)#​</cfoutput></cfsavecontent>
						<cf_wrk_budgetcat name="income_cat" option_text="#text#" value="#attributes.income_cat#" width="160">
					</div>
					<div class="form-group" id="item-branch_id">
						<label><cf_get_lang_main no='41.Şube'></label>
						<cfsavecontent variable="opt_value"><cfoutput>#getLang('main',322)#​</cfoutput></cfsavecontent>
						<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='160' selected_value='#attributes.branch_id#' option_value='#opt_value#'>
					</div>
					<div class="form-group" id="item-consumer_id">
						<label><cf_get_lang_main no='107.Cari Hesap'></label>
						<div class="input-group">
							<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
							<input type="hidden" name="company_id"  id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
							<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
							<input type="text" name="member_name"   id="member_name"  value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" title="<cf_get_lang_main no='107.Cari Hesap'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=search_asset.consumer_id&field_comp_id=search_asset.company_id&field_member_name=search_asset.member_name&field_type=search_asset.member_type&select_list=7,8&keyword='+encodeURIComponent(document.search_asset.member_name.value),'list');"></span>
						</div>
					</div>
					<div class="form-group" id="item-search_date2">
						<label><cfoutput>#getLang('main',216)#</cfoutput></label>
						<div class="input-group">
							<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
								<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
							<cfelse>
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
								<cfinput type="text" name="search_date1" message="#message#" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
							<span class="input-group-addon no-bg"></span>
							<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
								<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
							<cfelse>
							<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
								<cfinput type="text" name="search_date2" message="#message#" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-employee_id">
						<label><cf_get_lang no='89.Satış Yapan'></label>
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
							<input name="expense_employee" type="text" id="expense_employee" onFocus="AutoComplete_Create('expense_employee','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','EMPLOYEE_ID','employee_id','search_asset','3','250');" value="<cfoutput>#attributes.expense_employee#</cfoutput>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis" title="<cf_get_lang no='89.Satış Yapan'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.employee_id&field_name=search_asset.expense_employee&select_list=1,7,8,9','list','popup_list_positions');"></span>
						</div>
					</div>
					<div class="form-group" id="item-asset">
						<label><cf_get_lang_main no='1655.Varlık'></label>
						<div class="input-group">
							<cfif len(attributes.asset) and len(attributes.asset_id)>
								<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
								<input type="text" name="asset" id="asset" value="<cfoutput>#attributes.asset#</cfoutput>">
							<cfelse>
								<input type="hidden" name="asset_id" id="asset_id" value="">
								<input type="text" name="asset" id="asset" value="">
							</cfif>
							<span class="input-group-addon icon-ellipsis" title="<cf_get_lang_main no='1655.Varlık'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=search_asset.asset_id&field_name=search_asset.asset&event_id=0','list');"></span>
						</div>
					</div>
					<div class="form-group" id="item-project_id">
						<label><cf_get_lang_main no='4.Proje'></label>
						<cfif x_is_project_popup eq 0>
							<cfset get_project = get_fuseaction_property.get_project()>
							<cf_multiselect_check 
								query_name="get_project"  
								name="project_id"
								width="135" 
								option_value="project_id"
								option_name="project_head"
								value="#attributes.project_id#">
						<cfelse>
							<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
							<div class="input-group">
								<input name="project_head" type="text" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','217');" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_asset.project_id&project_head=search_asset.project_head&is_empty_project&moreProject=1&draggable=1');"></span>
							</div>
						</cfif>
					</div>
					<div class="form-group" id="item-record_date1">
						<label><cf_get_lang_main no='215.Kayıt Tarihi'></label>
						<div class="input-group">
							<cfinput type="text" name="record_date1" value="#dateformat(attributes.record_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="record_date1"></span>
							<span class="input-group-addon no-bg"></span>
							<cfinput type="text" name="record_date2" value="#dateformat(attributes.record_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('main',677)#" uidrop="1" hide_table_column="1" resize="1" collapsable="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang_main no='1165.Sıra'></th>
					<th><cf_get_lang_main no='1048.Masraf Merkezi'></th>
					<th><cf_get_lang_main no='761.Gelir Kalemi'></th>
					<th><cf_get_lang_main no='107.Cari Hesap'></th>
					<th><cf_get_lang_main no='41.Şube'></th>
					<th><cf_get_lang_main no='468.Belge No'></th>
					<th><cf_get_lang_main no='217.Açıklama'></th>
					<th><cf_get_lang_main no='388.İşlem Tipi'></th>
					<th><cf_get_lang_main no='330.Tarih'></th>
					<th><cf_get_lang no='89.Satış Yapan'></th>
					<th><cf_get_lang_main no ='712.Döviz Toplam'></th>
					<th><cf_get_lang_main no ='77.Para Br'></th>
					<th><cf_get_lang_main no ='1105.Dövizli Son Toplam'></th>
					<th><cf_get_lang_main no ='77.Para Br'></th>
					<th><cf_get_lang_main no='261.Tutar'></th>
					<th><cf_get_lang_main no ='77.Para Br'></th>
					<th><cf_get_lang_main no='227.KDV'></th>
					<th><cf_get_lang_main no ='77.Para Br'></th>
					<th><cf_get_lang_main no='609.ÖTV'></th>
					<th><cf_get_lang_main no ='77.Para Br'></th>
					<th><cf_get_lang_main no ='232.Son Toplam'></th>
					<th><cf_get_lang_main no ='77.Para Br'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif len(attributes.form_submitted)>
					<cfif  get_expense_item_row_all.recordcount>
						<cfscript>
							toplam1 = 0;
							toplam2 = 0;
							toplam3 = 0;
							toplam4 = 0;
							toplam5 = 0;
							toplam6 = 0;
							toplam7 = 0;
							toplam8 = 0;
						</cfscript>
						<cfoutput query="get_expense_item_row_all">
							<cfif currentrow eq 1>
								<cfscript>
									toplam1 = get_expense_item_row_all.toplam1 ;				
									toplam2 = get_expense_item_row_all.toplam2 ;
									toplam7 = get_expense_item_row_all.toplam7 ;
									toplam3 = get_expense_item_row_all.toplam3 ;
								</cfscript>
							</cfif>
							<cfscript>
								toplam4 = toplam4 + amount;				
								toplam5 = toplam5 + amount_kdv;
								if(len(amount_otv))
									toplam8 = toplam8 + amount_otv;
								else
									toplam8 = toplam8;
								toplam6 = toplam6 + total_amount;
							</cfscript>
							<tr>
								<td>#rownum#</td>
								<td>#expense#</td>
								<td>#expense_item_name#</td>
								<td>
									#COMPANY_NAME#
								</td>
								<td>#BRANCH#</td>
								<td>#paper_no#</td>
								<td>#detail#</td>
								<td><cfif len(expense_id) and expense_id neq 0><cf_get_lang_main no ='653.Gelir Fişi'><cfelse>#get_process_name(expense_cost_type)#</cfif></td>
								<td>#dateformat(expense_date,dateformat_style)#</td>
								<td>
									<cfif member_type eq 'partner'>#get_par_info(company_partner_id,0,0,1)#
									<cfelseif member_type eq 'consumer'>#get_cons_info(company_partner_id,0,1)#
									<cfelseif member_type eq 'employee'>#get_emp_info(company_partner_id,0,1)#
									<cfelse>#get_emp_info(company_partner_id,1,1)#</cfif>						
								</td>
								<td class="text-right">#TLFormat(other_money_value)# </td>
								<td>#money_currency_id#</td>
								<td class="text-right">#TLFormat(other_money_gross_total)#</td>
								<td>#money_currency_id#</td>
								<td class="text-right">#tlformat(amount)# </td>
								<td>#session.ep.money#</td>
								<td class="text-right"><cfif len(amount_kdv)>#tlformat(amount_kdv)#<cfelse>0</cfif></td>
								<td><cfif len(amount_kdv)>#session.ep.money#</cfif></td>
								<td class="text-right"><cfif len(amount_otv)>#tlformat(amount_otv)#<cfelse>0</cfif></td>
								<td><cfif len(amount_otv)>#session.ep.money#</cfif></td>
								<td class="text-right">
									<cfif len(total_amount)>
										#tlformat(total_amount)#
									<cfelse>
										<cfif len(amount_kdv)>
											<cfset kdv_deger = amount_kdv>
										<cfelse>
											<cfset kdv_deger = 0>
										</cfif>
										<cfif len(amount_otv)>
											<cfset otv_deger = amount_otv>
										<cfelse>
											<cfset otv_deger = 0>
										</cfif>
										#tlformat((kdv_deger + otv_deger + amount))#
									</cfif>
								</td>
								<td>#session.ep.money#</td>
								<!-- sil -->
								<td>
									<cfif expense_id neq 0>
										<cfif expense_cost_type eq 18>
											<a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#expense_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										<cfelse>
											<a href="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#expense_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
									<cfelse>
										<cfif expense_cost_type eq 32>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=cash.popup_upd_cash_payment&id=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("50,52,53,56,62,67,531",expense_cost_type,",")>
											<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#invoice_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("51,54,55,59,60,63,64,68,591,64,690,691",expense_cost_type,",")>
											<a href="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#invoice_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("65",expense_cost_type,",")>
											<a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#action_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("66",expense_cost_type,",")>
											<a href="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#action_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("41",expense_cost_type,",")>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_print_upd_debit_claim_note&id=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("292",expense_cost_type,",")>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=credit.popup_dsp_credit_payment&id=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("45",expense_cost_type,",")>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_print_upd_debit_claim_note&ID=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("1057",expense_cost_type,",")>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ch.popup_voucher_preview&ID=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("69",expense_cost_type,",")>
											<a href="#request.self#?fuseaction=finance.upd_daily_zreport&iid=#action_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("247",expense_cost_type,",")>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=bank.popup_upd_bank_cc_payment&ID=#action_id#','small');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("58",expense_cost_type,",")>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_invoice&ID=#action_id#','list');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
										<cfif listfind("162",expense_cost_type,",")>
											<a href="#request.self#?fuseaction=budget.MagicbudgeterRun&wizard_id=#action_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
										</cfif>
									</cfif>
								</td>
								<!-- sil -->
							</tr>
						</cfoutput>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="14" class="txtbold" ><cf_get_lang no='88.Sayfa Toplam'></td>
								<td class="txtbold text-right"><cfoutput>#TLFormat(toplam4)# </cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								<td class="txtbold text-right"><cfoutput>#TLFormat(toplam5)#</cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								<td class="txtbold text-right"><cfoutput>#TLFormat(toplam8)#</cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>	
								<td class="txtbold text-right"><cfoutput>#TLFormat(toplam6)#</cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								<!-- sil --><td></td><!-- sil -->
							</tr>
							
							<tr>
								<td colspan="14" class="txtbold"><cf_get_lang_main no='268.Genel Toplam'></td>
								<td class="txtbold text-right"><cfoutput>#TLFormat(toplam1)#</cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								<td class="txtbold text-right"><cfoutput>#TLFormat(toplam2)# </cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								<td class="txtbold text-right"><cfoutput>#TLFormat(toplam7)# </cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								<td class="txtbold text-right"><cfoutput>#TLFormat(toplam3)# </cfoutput></td>
								<td class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
								<!-- sil --><td></td><!-- sil -->
							</tr>
						
						</tfoot>
					<cfelse>
						<tr>
							<td colspan="23"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
						</tr>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="23"><cf_get_lang_main no='289.Filtre Ediniz'> !</td>
					</tr>
				</cfif>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.search_date1)>
			<cfset url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#">
		</cfif>	
		<cfif len(attributes.search_date2)>
			<cfset url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#">
		</cfif>
		<cfif len(attributes.employee_id)>
			<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
		</cfif>
		<cfif len(attributes.expense_employee)>
			<cfset url_str = "#url_str#&expense_employee=#attributes.expense_employee#">
		</cfif>
		<cfif len(attributes.expense_item_id)>
			<cfset url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#">
		</cfif>
		<cfif len(attributes.process_cat)>
			<cfset url_str = "#url_str#&process_cat=#attributes.process_cat#">
		</cfif>	
		<cfif len(attributes.expense_center_id)>
			<cfset url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#">
		</cfif>
		<cfif len(attributes.activity_type)>
			<cfset url_str = "#url_str#&activity_type=#attributes.activity_type#">
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
		</cfif>
		<cfif len(attributes.consumer_id)>
			<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif len(attributes.member_type)>
			<cfset url_str = "#url_str#&member_type=#attributes.member_type#">
		</cfif>
		<cfif len(attributes.member_name)>
			<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
		</cfif>
		<cfif len(attributes.income_cat)>
			<cfset url_str = "#url_str#&income_cat=#attributes.income_cat#">
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="budget.budget_income_summery&form_submitted=1#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
