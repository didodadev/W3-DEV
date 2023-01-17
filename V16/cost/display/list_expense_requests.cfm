<cf_get_lang_set module_name="cost">
<cf_xml_page_edit fuseact="cost.list_my_expense_requests">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_date1" default=''>
<cfparam name="attributes.search_date2" default=''>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.expense_employee" default="">
<cfparam name="attributes.form_exist" default="">
<cfparam name="attributes.document_type" default="">
<cfparam name="attributes.date_filter" default="1">
<cfparam name="attributes.stage_filter" default="">
<cfparam name="attributes.to_transforming" default="0">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_employee_id" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfparam name="attributes.process_stage" default="">
<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
	<cf_date tarih = "attributes.search_date1">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date1=''>
	<cfelse>
		<cfset attributes.search_date1 = dateadd('d',-7,wrk_get_today())>	
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
	<cf_date tarih = "attributes.search_date2">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date2=''>
	<cfelse>
		<cfset attributes.search_date2 = dateadd('d',7,attributes.search_date1)>
	</cfif>
</cfif>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE_CODE,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
	SELECT
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
	FROM
		SETUP_DOCUMENT_TYPE,
		SETUP_DOCUMENT_TYPE_ROW
	WHERE
		SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
		SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%'
	ORDER BY
		DOCUMENT_TYPE_NAME
</cfquery>
<cfquery name="get_service_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_expense_requests%">
</cfquery>
<cfquery name="get_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%cost.form_add_expense_cost%">
</cfquery>
<cfif  len(attributes.form_exist)>
	<cfquery name="GET_EXPENSE" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
    WITH CTE1 AS(
		SELECT
			EXPENSE_ITEM_PLAN_REQUESTS.RECORD_EMP,
			EXPENSE_ITEM_PLAN_REQUESTS.PAPER_NO,
			EXPENSE_ITEM_PLAN_REQUESTS.RECORD_DATE,
			EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID,
			EXPENSE_ITEM_PLAN_REQUESTS.IS_APPROVE,
			EXPENSE_ITEM_PLAN_REQUESTS.PROCESS_CAT,
			EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_COST_TYPE,
        <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
            EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXP_ITEM_ROWS_ID,
      		EXPENSE_ITEM_PLAN_REQUESTS_ROWS.AMOUNT,
			EXPENSE_ITEM_PLAN_REQUESTS_ROWS.DETAIL,
			EXPENSE_ITEM_PLAN_REQUESTS_ROWS.TOTAL_AMOUNT,
			EXPENSE_ITEM_PLAN_REQUESTS_ROWS.AMOUNT_KDV,
            E_C.EXPENSE,
            E_I.EXPENSE_ITEM_NAME,
			EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_DATE,
       <cfelse>
        	EXPENSE_ITEM_PLAN_REQUESTS.TOTAL_AMOUNT,
            EXPENSE_ITEM_PLAN_REQUESTS.NET_KDV_AMOUNT,
            EXPENSE_ITEM_PLAN_REQUESTS.NET_TOTAL_AMOUNT,
			EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_DATE,
        </cfif> 
			EXPENSE_ITEM_PLAN_REQUESTS.INVOICE_NO,	
			EXPENSE_ITEM_PLAN_REQUESTS.PAPER_TYPE,
			EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID,
			EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_STAGE,
			EXPENSE_ITEM_PLAN_REQUESTS.SALES_COMPANY_ID,
			EXPENSE_ITEM_PLAN_REQUESTS.SALES_CONSUMER_ID,
            CONSUMER.CONSUMER_NAME,
            CONSUMER.CONSUMER_SURNAME,
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME,
            EMP.EMPLOYEE_NAME,
            EMP.EMPLOYEE_SURNAME,
            C.FULLNAME,
            PTR.PROCESS_ROW_ID
		FROM
			EXPENSE_ITEM_PLAN_REQUESTS
            	LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = EXPENSE_ITEM_PLAN_REQUESTS.SALES_CONSUMER_ID
                LEFT JOIN #dsn_alias#.SETUP_DOCUMENT_TYPE ON SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID = EXPENSE_ITEM_PLAN_REQUESTS.PAPER_TYPE
                LEFT JOIN #dsn_alias#.EMPLOYEES EMP on EMP.EMPLOYEE_ID =EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID
                LEFT JOIN #dsn_alias#.COMPANY C on C.COMPANY_ID=EXPENSE_ITEM_PLAN_REQUESTS.SALES_COMPANY_ID
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR on PTR.PROCESS_ROW_ID=EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_STAGE
        <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS_ROWS on EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID = EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ID
                LEFT JOIN EXPENSE_ITEMS E_I on E_I.EXPENSE_ITEM_ID=EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID
                LEFT JOIN EXPENSE_CENTER E_C on E_C.EXPENSE_ID=EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID
        </cfif>
		WHERE
        <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
			 EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID = EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ID AND 
        </cfif>  
			EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_STAGE IN (<cfif get_service_stage.recordcount>#valuelist(get_service_stage.process_row_id,',')#<cfelse>0</cfif>)
		<cfif len(attributes.to_transforming) and attributes.to_transforming eq 1>
				AND EXPENSE_ITEM_PLAN_REQUESTS.IS_APPROVE = 1
				AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID IN (SELECT REQUEST_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ITEM_PLANS.REQUEST_ID = EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID)
		<cfelseif  len(attributes.to_transforming) and attributes.to_transforming eq 0>
				AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID NOT IN (SELECT REQUEST_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ITEM_PLANS.REQUEST_ID = EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID)
		</cfif>
		<cfif len(attributes.ch_company_id) and len(attributes.ch_company)>
			AND EXPENSE_ITEM_PLAN_REQUESTS.SALES_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ch_company_id#">
		<cfelseif len(attributes.ch_consumer_id) and len(attributes.ch_company)>
			AND EXPENSE_ITEM_PLAN_REQUESTS.SALES_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ch_consumer_id#">
		<cfelseif len(attributes.ch_employee_id) and len(attributes.ch_company)>
			AND EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ch_employee_id#">
		</cfif>
		<cfif len(attributes.keyword)>
			AND 
			(
				EXPENSE_ITEM_PLAN_REQUESTS.PAPER_NO LIKE '%#attributes.keyword#%' 
				OR 
				EXPENSE_ITEM_PLAN_REQUESTS.SYSTEM_RELATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
		<cfif xml_expense_center_is_popup eq 1>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) and len(attributes.expense_center_name))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_item_id') and len(attributes.expense_item_id) and len(attributes.expense_item_name))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
		<cfelse>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) )>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_item_id') and len(attributes.expense_item_id) )>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
		</cfif>
		<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
			<cfif len(attributes.search_date1)>
				AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_DATE >=<cfqueryparam  cfsqltype="cf_sql_date" value="#attributes.search_date1#">
			</cfif>
			<cfif len(attributes.search_date2)>
				AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_DATE <=<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.search_date2#">
			</cfif>
		<cfelse>
			<cfif len(attributes.search_date1)>
				AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_DATE >=<cfqueryparam  cfsqltype="cf_sql_date" value="#attributes.search_date1#">
			</cfif>
			<cfif len(attributes.search_date2)>
				AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_DATE <=<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.search_date2#">
			</cfif>
		</cfif>
			<cfif len(attributes.expense_employee) and len(attributes.employee_id)>AND EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
			<cfif len(attributes.document_type)>AND EXPENSE_ITEM_PLAN_REQUESTS.PAPER_TYPE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.document_type#"></cfif>
			<cfif len(attributes.stage_filter)>AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_STAGE =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stage_filter#"></cfif>
			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>AND EXPENSE_ITEM_PLAN_REQUESTS.RECORD_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#"></cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_TYPE IS NULL
		 ),
         CTE2 AS (
				SELECT
					CTE1.*,
						ROW_NUMBER() OVER (
                        					ORDER BY  
											<cfif len(attributes.date_filter) and attributes.date_filter eq 2>
                                                EXPENSE_DATE
                                            <cfelseif len(attributes.date_filter) and attributes.date_filter eq 1>
                                                EXPENSE_DATE DESC,EXPENSE_ID
                                            </cfif>
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
	<cfparam name="attributes.totalrecords" default="#get_expense.QUERY_COUNT#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
	<cfset get_expense.recordcount = 0>
</cfif>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset GET_XMLSTAGE = get_fuseaction_property.get_fuseaction_property(
company_id : session.ep.company_id,
fuseaction_name : 'objects.expense_cost',
property_name : 'xml_show_process_stage'
)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_asset" action="#request.self#?fuseaction=cost.list_expense_requests" method="post">
			<input name="form_exist" id="form_exist" type="hidden" value="1">
			<cf_box_search>
				<input type="hidden" name="is_submit" id="is_submit" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="record_emp_id" maxlength="50" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
						<input type="text" name="record_emp_name"  maxlength="50" placeholder=<cfoutput>"#getLang(487,'Kaydeden',57899)#"</cfoutput> id="record_emp_name" style="width:125px;"  onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','search_asset','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_asset.record_emp_name&field_emp_id=search_asset.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false" title="<cfoutput>#getLang(487,'Kaydeden',57899)#</cfoutput>"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" maxlength="50" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<input name="expense_employee" type="text" maxlength="50" placeholder=<cfoutput>"#getLang('cost',9)#"</cfoutput> id="expense_employee" style="width:150px;" onFocus="AutoComplete_Create('expense_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','150');" value="<cfoutput>#attributes.expense_employee#</cfoutput>" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.employee_id&field_name=search_asset.expense_employee','list');" title="<cfoutput>#getLang('account',9)#</cfoutput>"></span>
					</div>
				</div>
				<div class="form-group" id="item-ch_company">
					<div class="col col-12">
						<div class="input-group">
							<input type="hidden" name="ch_company_id" id="ch_company_id" value="<cfif isdefined("attributes.ch_company_id") and len(attributes.ch_company_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'partner'><cfoutput>#attributes.ch_company_id#</cfoutput></cfif>">
							<input type="hidden" name="ch_consumer_id" id="ch_consumer_id" value="<cfif isdefined("attributes.ch_consumer_id") and len(attributes.ch_consumer_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'consumer'><cfoutput>#attributes.ch_consumer_id#</cfoutput></cfif>">
							<input type="hidden" name="ch_employee_id"  id="ch_employee_id"value="<cfif isdefined("attributes.ch_employee_id") and len(attributes.ch_employee_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'employee'><cfoutput>#attributes.ch_employee_id#</cfoutput></cfif>">
							<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
							<input name="ch_company" type="text" placeHolder="<cfoutput>#getLang('','',57519)#</cfoutput>" id="ch_company" style="width:120px;" onfocus="AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','ch_company_id,ch_consumer_id,ch_employee_id,member_type','','3','225');" value="<cfif  isdefined("attributes.ch_company") and len(attributes.ch_company)><cfoutput>#attributes.ch_company#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_name=search_asset.ch_company&is_cari_action=1&field_type=search_asset.member_type&field_comp_name=search_asset.ch_company&field_consumer=search_asset.ch_consumer_id&field_emp_id=search_asset.ch_employee_id&field_comp_id=search_asset.ch_company_id&select_list=2,3,1,9</cfoutput>','list');" title="<cfoutput>#getLang(107,'Cari Hesap',57519)#</cfoutput>"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<select name="listing_type" id="listing_type" style="width:100px;" onchange="show_filter();">
						<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cfoutput>#getLang(248,'Belge Bazında',57660)#</cfoutput></option>
						<option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cfoutput>#getLang(1742,'Satır Bazında',29539)#</cfoutput></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber(this)" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type='4' search_function="kontrol()">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-stage_filter">
						<label class="col col-12"><cfoutput>#getLang(70,'Aşama',57482)#</cfoutput></label>
						<div class="col col-12">
							<select name="stage_filter" id="stage_filter" style="width:100px;">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfloop query="get_service_stage">
									<cfoutput><option value="#process_row_id#" <cfif attributes.stage_filter eq process_row_id>selected</cfif>>#stage#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-document_type">
						<label class="col col-12"><cfoutput>#getLang(1166,'Belge Türü',58578)#</cfoutput></label>
						<div class="col col-12">
							<select name="document_type" id="document_type" class="txt">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_document_type">
									<option value="#document_type_id#" <cfif document_type_id eq attributes.document_type>selected</cfif>>#document_type_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-branch_id">
						<label class="col col-12"><cfoutput>#getLang(41,'Şube',57453)#</cfoutput></label>
						<div class="col col-12">
							<cfsavecontent variable="opt_value"><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></cfsavecontent>
							<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' width='150' selected_value='#attributes.branch_id#' option_value='#opt_value#'>
						</div>
					</div>
					<div class="form-group" id="item-to_transforming">
						<label class="col col-12">&nbsp;<span class="hide"><cf_get_lang dictionary_id='51305.Dönüştürülmüş'> / <cf_get_lang dictionary_id='51306.Dönüştürülmemiş'></span></label>
						<div class="col col-12">
							<select name="to_transforming" id="to_transforming">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<option value="1" <cfif attributes.to_transforming eq 1>selected</cfif>><cf_get_lang dictionary_id='51305.Dönüştürülmüş'></option>
								<option value="0" <cfif attributes.to_transforming eq 0>selected</cfif>><cf_get_lang dictionary_id='51306.Dönüştürülmemiş'></option>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-date_filter">
						<label class="col col-12"><cfoutput>#getLang(330,'Tarih',57742)#</cfoutput></label>
						<div class="col col-12">
							<select name="date_filter" id="date_filter">
								<option value="1" <cfif attributes.date_filter eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
								<option value="2" <cfif attributes.date_filter eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-search_date1">
						<label class="col col-12"><cfoutput>#getLang(89,'Başlangıç',57501)#-#getLang(90,'Bitiş',57502)# #getLang(1181,'Tarihi',58593)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
									<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent> 
									<cfinput type="text" name="search_date1" message="#message#" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#">
								</cfif>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date1"></span>
								<span class="input-group-addon no-bg"></span>
								<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
									<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								<cfelse>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent> 
									<cfinput type="text" name="search_date2" message="#message#" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#">
								</cfif>
								<span class="input-group-addon btnPointer"> <cf_wrk_date_image date_field="search_date2"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true" id="rows_">
					<div class="form-group" id="exp_cen_1">
						<label class="col col-12"><cfoutput>#getLang(1048,'Masraf Merkezi',58460)#</cfoutput></label>
						<div class="col col-12">
							<cfif xml_expense_center_is_popup eq 1>
								<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfif len(attributes.expense_center_id)><cfoutput>#attributes.expense_center_id#</cfoutput></cfif>">
								<input type="text" name="expense_center_name" id="expense_center_name" style="width:90px;" onfocus="AutoComplete_Create('expense_center_name','EXPENSE','EXPENSE','get_expense_center','3','EXPENSE_ID','expense_center_id','search_asset','3','150');" autocomplete="off" value="<cfif len(attributes.expense_center_name)><cfoutput>#attributes.expense_center_name#</cfoutput></cfif>">
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=search_asset.expense_center_id'+'&field_name=search_asset.expense_center_name','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							<cfelse>
								<select name="expense_center_id" id="expense_center_id" style="width:150px;">
									<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
									<cfoutput query="get_expense_center">
										<option value="#expense_id#" <cfif attributes.expense_center_id eq expense_id>selected</cfif>>#GET_EXPENSE_CENTER.expense#</option>
									</cfoutput>
								</select> 
							</cfif>
						</div>
					</div>
					<div class="form-group" id="exp_it_1">
						<label class="col col-12"><cfoutput>#getLang(1139,'Gider Kalemi',58551)#</cfoutput></label>
						<div class="col col-12">
							<cfif xml_expense_center_is_popup eq 1>
							<input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfif len(attributes.expense_item_id)><cfoutput>#attributes.expense_item_id#</cfoutput></cfif>">
							<input type="text" name="expense_item_name" id="expense_item_name" style="width:90px;" onfocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','3','EXPENSE_ITEM_ID','expense_item_id','search_asset','3','150');" autocomplete="off" value="<cfif len(attributes.expense_item_name)><cfoutput>#attributes.expense_item_name#</cfoutput></cfif>">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_invoice=1&field_id=search_asset.expense_item_id'+'&field_name=search_asset.expense_item_name','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							<cfelse>
							<select name="expense_item_id" id="expense_item_id" style="width:150px;">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_expense_item">
									<option value="#expense_item_id#" <cfif attributes.expense_item_id eq expense_item_id>selected</cfif>>#expense_item_name#</option>
								</cfoutput>
							</select>
							</cfif>
						</div>
					</div> 
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(11,'Harcama Talepleri',51315)#" uidrop="1" hide_table_column="1">
		<cf_grid_list id="table1">
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='58578.Belge Türü'></th>
					<th><cf_get_lang dictionary_id='51328.Harcama Tarihi'></th>
					<th><cf_get_lang dictionary_id='58061.Cari'></th>
					<th><cf_get_lang dictionary_id='51313.Ödeme Yapan'></th>
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
					<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
					<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57492.Toplam'></th>
					<th><cf_get_lang dictionary_id='51317.Toplam KDV'></th>
					<th><cf_get_lang dictionary_id='51316.KDV li Toplam'></th>
					<th><cf_get_lang dictionary_id='57756.Süreç'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th><!-- sil -->
					<th width="20" class="header_icn_none"><input type="checkbox" class="checkControl" name="allSelectRequest" id="allSelectRequest" onclick="wrk_select_all('allSelectRequest','row_expense_requests');"  total_value="0" amount_value="0" comp_value="0"></th>
					<th>Status</th>
				</tr>
			</thead>
			<cfif isdefined("attributes.form_exist") and get_expense.recordcount neq 0>
				<cfset toplam1 = 0>
				<cfset toplam2 = 0>
				<cfset toplam3 = 0>					
					<tbody>
						<cfoutput query="get_expense">
							<tr>
								<td>#RowNum#</td>
								<td><a href="#request.self#?fuseaction=cost.list_expense_requests&event=upd&request_id=#expense_id#" class="tableyazi">&nbsp;#paper_no#</a></td>
								<td>#document_type_name#</td>
								<td>#dateformat(expense_date,dateformat_style)#</td>
								<td width="120">
									<cfif len(GET_EXPENSE.SALES_COMPANY_ID)>
										#FULLNAME#
									<cfelseif len(GET_EXPENSE.SALES_CONSUMER_ID)>
										#CONSUMER_NAME# #CONSUMER_SURNAME#
									</cfif>
								</td>
								<td><cfif len(employee_name)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></cfif></td>
								<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
								<td>#EXPENSE#</td>
								<td>#EXPENSE_ITEM_NAME#</td>
								</cfif>
								<td style="text-align:right;">#tlformat(total_amount)# #session.ep.money#</td>
								<td style="text-align:right;"><cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)><cfset net_total_amount= net_total_amount> #tlformat(net_total_amount)# #session.ep.money#<cfelse><cfset net_total_amount= amount_kdv>#tlformat(amount_kdv)# #session.ep.money#</cfif></td>
								<td style="text-align:right;"><cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)><cfset net_kdv_amount= net_kdv_amount> #tlformat(net_kdv_amount)# #session.ep.money#<cfelse><cfset net_kdv_amount= total_amount>#tlformat(total_amount)# #session.ep.money#</cfif></td>
								<td>
									<cfif len(PROCESS_ROW_ID)>
										<cf_workcube_process type="color-status" process_stage="#PROCESS_ROW_ID#">
										<!--- #get_stage.stage[listfind(expense_stage_list,expense_stage,',')]# --->
									</cfif>
								</td>
								<td>#dateformat(record_date,dateformat_style)#</td>
								<td>#get_emp_info(record_emp,0,1)#</td>
								<!-- sil -->
								<td><a href="#request.self#?fuseaction=cost.list_expense_requests&event=upd&request_id=#expense_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
								<!-- sil -->
								<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 1)>
									<cfscript>
										toplam1 = toplam1 + total_amount;			
										toplam2 = toplam2 + net_kdv_amount;  
										toplam3 = toplam3 + net_total_amount; 	
									</cfscript>
								<cfelse>
									<cfscript>
										toplam1 = toplam1 + amount;					
										toplam2 = toplam2 + total_amount; 
										toplam3 = toplam3 + amount_kdv; 	
								</cfscript>
								</cfif>						 
								<td width="1%" align="center">
									<cfquery name="GET_EXPENSE_ITEM_PLANS" datasource="#dsn2#">
										SELECT REQUEST_ID FROM EXPENSE_ITEM_PLANS WHERE REQUEST_ID = #expense_id#
									</cfquery>
									<input type="hidden" name="money_info#currentrow#" id="money_info#currentrow#" value="">
									<cfif not GET_EXPENSE_ITEM_PLANS.recordcount and get_expense.is_approve eq 1>
										<input type="checkbox" class="checkControl" name="row_expense_requests" id="row_expense_requests#currentrow#" value="#expense_id#" total_value="#total_amount#" amount_value="#net_kdv_amount#" comp_value="#net_total_amount#">
									<cfelse>
										<input type="checkbox" name="row_expense_requests" id="row_expense_requests#currentrow#" value="#expense_id#" title="Daha Önce Masraf Fişine Dönüştürülen Talep" disabled>
									</cfif>
								</td>	
								<td><cfif not GET_EXPENSE_ITEM_PLANS.recordcount and get_expense.is_approve eq 1><i class="fa fa-2x fa-bookmark-o"></i><cfelse><i class="fa fa-2x fa-bookmark flagWarning"></i></cfif></td>										 
							</tr>
						</cfoutput>
					</tbody>
					<tfoot>
						<cfoutput>
							<tr>
								<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
									<td colspan="8" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
								<cfelse>
									<td colspan="6" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
								</cfif>
								<td class="txtbold" style="text-align:right;">#TLFormat(toplam1)#&nbsp;#session.ep.money#</td>
								<td class="txtbold" style="text-align:right;">#TLFormat(toplam3)#&nbsp;#session.ep.money#</td>
								<td class="txtbold" style="text-align:right;">#TLFormat(toplam2)#&nbsp;#session.ep.money#</td>
								<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
									<td colspan="3" class="txtbold" ></td>
								<cfelse>
									<td colspan="4" class="txtbold" ></td>
								</cfif>
								<!-- sil --><td>&nbsp;</td><!-- sil -->
								<!-- sil --><td>&nbsp;</td><!-- sil -->
							</tr>
						</cfoutput>  
					</tfoot>
					<div id="user_message_demand"></div>
			<cfelse>
				<tr>
					<td colspan="15" height="20"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
				</tr>
			</cfif>
		</cf_grid_list>
		<cfscript>
			url_str = "" ;
			if ( len(attributes.keyword) )
			url_str = "#url_str#&keyword=#attributes.keyword#";
			if ( len(attributes.search_date1) )
			url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#";
			if ( len(attributes.search_date2) )
			url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#";
			if ( len(attributes.employee_id) )
			url_str = "#url_str#&employee_id=#attributes.employee_id#";
			if ( len(attributes.expense_employee) )
			url_str = "#url_str#&expense_employee=#attributes.expense_employee#";
			if ( len(attributes.form_exist) )
			url_str = "#url_str#&form_exist=#attributes.form_exist#";
			if ( len(attributes.date_filter) )
			url_str = "#url_str#&date_filter=#attributes.date_filter#";
			if ( len(attributes.stage_filter) )
			url_str = "#url_str#&stage_filter=#attributes.stage_filter#";
			if ( len(attributes.to_transforming) )
			url_str = "#url_str#&to_transforming=#attributes.to_transforming#";
			if (len(attributes.record_emp_id))
			url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#";
			if (len(attributes.record_emp_name))
			url_str = "#url_str#&record_emp_name=#attributes.record_emp_name#";
			if (len(attributes.branch_id))
			url_str = "#url_str#&branch_id=#attributes.branch_id#";
			if (len(attributes.listing_type))
			url_str = "#url_str#&listing_type=#attributes.listing_type#";
			if (len(attributes.expense_center_name))
			url_str = "#url_str#&expense_center_name=#attributes.expense_center_name#";
			if (len(attributes.expense_center_id))
			url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
			if (len(attributes.expense_item_id))
			url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
			if (len(attributes.expense_item_name))
			url_str = "#url_str#&expense_item_name=#attributes.expense_item_name#";
			if (len(attributes.ch_company_id))
			url_str = "#url_str#&ch_company_id=#attributes.ch_company_id#";
			if (len(attributes.ch_consumer_id))
			url_str = "#url_str#&ch_consumer_id=#attributes.ch_consumer_id#";
			if (len(attributes.ch_employee_id))
			url_str = "#url_str#&ch_employee_id=#attributes.ch_employee_id#";
		</cfscript>
		
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="cost.list_expense_requests&#url_str#">
	</cf_box>
	<form name="upd_all_action" id="upd_all_action" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=<cfoutput>#fusebox.circuit#</cfoutput>.emptypopup_add_request_from_expense">		
		<input type="hidden" name="RequestIdList" id="RequestIdList" value="">
		<input type="hidden" name="xml_acc_type" value="<cfoutput>#xml_acc_type#</cfoutput>">
		<cfif isdefined("attributes.form_exist") and get_expense.recordcount neq 0>
			<cfsavecontent variable="title2"><cf_get_lang dictionary_id='61161.Toplu Talep'></cfsavecontent>
			<cf_box closable="0" collapsable="0" title="#title2#">
				<cf_box_elements vertical="1">
					<div class="col col-4 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-total_net_amount">
							<label class="col col-6 col-xs-12"><cf_get_lang dictionary_id="29534.Toplam Tutar"></label>
							<div class="col col-6 col-xs-12">
								<input type="text" readonly class="moneybox" name="amount_last_total" id="amount_last_total" value="<cfoutput>#TLFormat(0,4)#</cfoutput>">
							</div>
						</div>
						<div class="form-group" id="item-total_treatment_amount">
							<label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='51317.Toplam KDV'></label>
							<div class="col col-6 col-xs-12">
								<input type="text" readonly class="moneybox" name="kdv_last_total" id="kdv_last_total" value="<cfoutput>#TLFormat(0,4)#</cfoutput>">
							</div>
						</div>
						<div class="form-group" id="item-total_comp_amount">
							<label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='51316.KDV li Toplam'></label>
							<div class="col col-6 col-xs-12">
								<input type="text" readonly class="moneybox" name="kdv_net_last_total" id="kdv_net_last_total" value="<cfoutput>#TLFormat(0,4)#</cfoutput>">
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
							<cf_workcube_process_cat slct_width="150" process_cat='#get_expense.process_cat#'>										
						</div>
						<cfif GET_XMLSTAGE.PROPERTY_VALUE eq 1>
							<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
								<select name="process_stage" id="process_stage">
									<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
									<cfloop query="get_stage">
										<cfoutput><option value="#process_row_id#" <cfif attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option></cfoutput>
									</cfloop>
								</select>
							</div>
						</cfif>
					</div>
				</cf_box_elements>
				<cf_box_footer>								
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='33492.Masraf Fişine Dönüştür'></cfsavecontent>
					<cf_workcube_buttons type_format="1" is_upd='0' insert_info="#message#" is_cancel='0' add_function='ConvertExpenseRequest()'>
				</cf_box_footer>
									
			</cf_box>				
		</cfif>
	</form>
</div>
<script type="text/javascript">
	window.onload = show_filter;
	document.getElementById('keyword').focus();
	$( document ).ready(function() {
            total_amount_ = 0;
            comp_amount_ = 0;
            emp_amount_ = 0;
            net_kdv_amount_ = 0;
            $('.checkControl').each(function() {
                if(this.checked){
                    net_kdv_amount_ += parseFloat($(this).attr("amount_value"));
                    total_amount_ += parseFloat($(this).attr("total_value"));
                    comp_amount_ += parseFloat($(this).attr("comp_value"));
                }
            });
            $('#amount_last_total').val(commaSplit(net_kdv_amount_,<cfoutput>#4#</cfoutput>));
            $('#kdv_last_total').val(commaSplit(total_amount_,<cfoutput>#4#</cfoutput>));
            $('#kdv_net_last_total').val(commaSplit(comp_amount_,<cfoutput>#4#</cfoutput>));
        });
	function kontrol()
	{
		if (!date_check (document.getElementById('search_date1'),document.getElementById('search_date2'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Küçük Olamaz'>!") )
			return false;
		if(!$("#maxrows").val().length)
		{
			alertObject({message: "<cfoutput>#getLang('main',125)# !</cfoutput>"})    
			return false;
		}
		else
			return true;	
	}
	$(function(){
            $('input[name=allSelectRequest]').click(function(){
                if(this.checked){
                    $('.checkControl').each(function(){
                        $(this).prop("checked", true);
                    });
                }
                else{
                    $('.checkControl').each(function(){
                        $(this).prop("checked", false);
                    });
                }
            });
            $('.checkControl').click(function(){
                total_amount = 0;
                comp_amount = 0;
                emp_amount = 0;
                net_kdv_amount = 0;
                $('.checkControl').each(function() {
                    if(this.checked){
                        net_kdv_amount += parseFloat($(this).attr("amount_value"));
                        total_amount += parseFloat($(this).attr("total_value"));
                        comp_amount += parseFloat($(this).attr("comp_value"));
                    }
                });
                $('#amount_last_total').val(commaSplit(net_kdv_amount,<cfoutput>#4#</cfoutput>));
                $('#kdv_last_total').val(commaSplit(total_amount,<cfoutput>#4#</cfoutput>));
                $('#kdv_net_last_total').val(commaSplit(comp_amount,<cfoutput>#4#</cfoutput>));
            });
        });
	function show_filter()
	{
		if(document.getElementById('listing_type').value==2)
		{
			document.getElementById('exp_cen_1').style.display="";
			document.getElementById('exp_it_1').style.display="";
			document.getElementById('rows_').style.display="";
		}	
		else
		{
			document.getElementById('exp_cen_1').style.display="none";
			document.getElementById('exp_it_1').style.display="none";
			document.getElementById('rows_').style.display="none";
		}
	}
	
	function ConvertExpenseRequest()
	{
		if(!chk_process_cat('upd_all_action')) return false;
		var is_selected=0;
		check_list = '';
		is_secili = 0;
		if(document.getElementsByName("row_expense_requests").length != undefined) /*n tane*/
		{	
			for (var i=0; i < document.getElementsByName("row_expense_requests").length; i++)
			{
				if((document.getElementsByName("row_expense_requests")[i].checked==true)){
                    check_list = check_list + document.getElementsByName("row_expense_requests")[i].value + "," ;
                    window.warningCounter.warningCounter--;
					is_secili = 1;
				}
			}
		}
		else
		{
			if((document.upd_all_action.row_expense_requests.checked==true))
				is_secili = 1;
		}
		
		if(is_secili==0)
		{
			alert("<cf_get_lang dictionary_id='38840.Lütfen İşlem Seçiniz!'>");
			return false;
		}
		else
		{

			if(confirm("<cf_get_lang dictionary_id='33491.Talep Masraf Fişine Dönüştürülecektir Emin misiniz'>"))
			{
				if(list_len(check_list,',') > 1)
				{
					document.getElementById('RequestIdList').value = check_list;
					user_message="masraf Fişleri Ekleniyor Lütfen Bekleyiniz !'>";
					AjaxFormSubmit(upd_all_action,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
					return false;
				}
			}
			else
				return false;
        }
	}
</script>	
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">