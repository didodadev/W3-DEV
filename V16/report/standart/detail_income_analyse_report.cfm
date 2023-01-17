<!--- Detayli Gelir Analiz Raporu 20110110_h.gul --->
<cf_xml_page_edit fuseact="report.detail_income_analyse_report">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.expense_cat" default="">
<cfparam name="attributes.search_date1" default='#dateformat(now(),dateformat_style)#'>
<cfparam name="attributes.search_date2" default='#dateformat(now(),dateformat_style)#'>
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.asset_id" default="">
<cfparam name="attributes.asset" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_name" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.partner_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.report_sort" default="0">
<cfparam name="attributes.is_expence" default="0">
<cfparam name="attributes.is_expence_item" default="0">
<cfparam name="attributes.is_activity" default="0">
<cfparam name="attributes.is_expence_cat" default="0">
<cfparam name="attributes.is_expence_member" default="0">
<cfparam name="attributes.is_date" default="0">
<cfparam name="attributes.is_other_money" default="0">
<cfparam name="attributes.is_asset" default="0">
<cfparam name="attributes.is_stock" default="0">
<cfparam name="attributes.is_detail" default="0">
<cfparam name="attributes.is_project" default="0">
<cfparam name="attributes.is_work" default="0">
<cfparam name="attributes.is_opp" default="0">
<cfparam name="attributes.is_row" default="0">
<cfparam name="attributes.opp_id_" default="">
<cfparam name="attributes.opp_head_" default="">
<cfparam name="attributes.work_id_" default="">
<cfparam name="attributes.work_head_" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.company_id_" default="">
<cfparam name="attributes.company_" default="">
<cfparam name="attributes.consumer_id_" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfif isdefined('attributes.ajax')><!--- Kümüle Raporlar için Dönem ve şirket farklı gönderilebilir! --->
	<cfif isdefined('attributes.new_sirket_data_source')>
		<cfset dsn3 = attributes.new_sirket_data_source>
	</cfif>
	<cfif isdefined('attributes.new_donem_data_source')>
		<cfset dsn2 = attributes.new_donem_data_source>
	</cfif>
</cfif>

<cfif not (attributes.is_expence or attributes.is_asset or attributes.is_stock or attributes.is_detail or attributes.is_project or attributes.is_work or attributes.is_opp or attributes.is_row or attributes.is_other_money or attributes.is_date or attributes.is_expence_item or attributes.is_activity or attributes.is_expence_cat or attributes.is_expence_member)>
	<cfset attributes.form_exist = 0>
</cfif>
<cfif len(attributes.search_date1)>
	<cf_date tarih='attributes.search_date1'>
</cfif>
<cfif len(attributes.search_date2)>
	<cf_date tarih='attributes.search_date2'>
</cfif>
 <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery> 
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT 
		EXPENSE_ID,
		EXPENSE,
		EXPENSE_CODE 
	FROM 
		EXPENSE_CENTER 
	WHERE 
		EXPENSE_ACTIVE = 1 
		<cfif x_authorized_branch eq 1>
			AND EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			AND EXPENSE_DEPARTMENT_ID IN(SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY 
		EXPENSE_CODE
</cfquery>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CAT" datasource="#dsn2#">
	SELECT * FROM EXPENSE_CATEGORY ORDER BY EXPENSE_CAT_NAME
</cfquery>
<cfquery name="get_tax" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfif attributes.form_exist eq 1>
	<cfquery name="GET_EXPENSE_ITEM_ROW_ALL" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
			EXPENSE_ITEMS_ROWS.IS_INCOME,
			EXPENSE_ITEMS_ROWS.INVOICE_ID,
		<cfif attributes.is_expence>
			EXPENSE_CENTER.EXPENSE,
			EXPENSE_CENTER.EXPENSE_ID,
		</cfif>
		<cfif attributes.is_expence_item>
			EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
			EXPENSE_ITEMS.EXPENSE_ITEM_ID,
		</cfif>
		<cfif attributes.is_activity>
			EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE,
		</cfif>
		<cfif attributes.is_expence_cat>
			EXPENSE_ITEMS.EXPENSE_CATEGORY_ID,
		</cfif>
		<cfif attributes.is_expence_member>
			EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
			EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
			EXPENSE_ITEMS_ROWS.COMPANY_ID,
		</cfif>
		<cfif attributes.is_date>
			EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
		</cfif>
		<cfif attributes.is_other_money>
			<cfif attributes.is_row eq 0>
				SUM(EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL) OTHER_MONEY_GROSS_TOTAL,
			<cfelse>
				EXPENSE_ITEMS_ROWS.OTHER_MONEY_GROSS_TOTAL,
			</cfif>
			EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
		</cfif>
		<cfif attributes.is_asset>
			EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID,
		</cfif>
		<cfif attributes.is_stock>
			EXPENSE_ITEMS_ROWS.PRODUCT_ID,
			EXPENSE_ITEMS_ROWS.STOCK_ID_2,
		</cfif>
		<cfif attributes.is_detail>
			SUBSTRING(EXPENSE_ITEMS_ROWS.DETAIL,1,50) DETAIL,
		</cfif>
		<cfif attributes.is_project>
			EXPENSE_ITEMS_ROWS.PROJECT_ID,
		</cfif>
		<cfif attributes.is_work>
			EXPENSE_ITEMS_ROWS.WORK_ID,
		</cfif>
		<cfif attributes.is_opp>
			EXPENSE_ITEMS_ROWS.OPP_ID,
		</cfif>
		EXPENSE_ITEMS_ROWS.RECORD_EMP,
		<cfif attributes.is_row eq 0>
			SUM(EXPENSE_ITEMS_ROWS.AMOUNT*(ISNULL(EXPENSE_ITEMS_ROWS.QUANTITY,1))) AMOUNT,
			SUM(EXPENSE_ITEMS_ROWS.AMOUNT_KDV) AMOUNT_KDV,
			SUM(EXPENSE_ITEMS_ROWS.AMOUNT_OTV) AMOUNT_OTV,
			SUM(EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT) TOTAL_AMOUNT
		<cfelse>
			ISNULL(EXPENSE_ITEMS_ROWS.EXPENSE_ID,(SELECT INV.INVOICE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID)) EXPENSE_ID,
			EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
			EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
			EXPENSE_ITEMS_ROWS.COMPANY_ID,
			SUBSTRING(EXPENSE_ITEMS_ROWS.DETAIL,1,50) DETAIL,
			EXPENSE_ITEMS_ROWS.AMOUNT*(ISNULL(EXPENSE_ITEMS_ROWS.QUANTITY,1)) AMOUNT,
			EXPENSE_ITEMS_ROWS.AMOUNT_KDV,
			EXPENSE_ITEMS_ROWS.AMOUNT_OTV,
			EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT,			
			ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_ID,ISNULL((SELECT INV.COMPANY_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_COMPANY_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))) CH_COMPANY_ID,
			ISNULL(EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,ISNULL((SELECT INV.CONSUMER_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_CONSUMER_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID))) CH_CONSUMER_ID,
			ISNULL((SELECT INV.EMPLOYEE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EXP.CH_EMPLOYEE_ID FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)) CH_EMPLOYEE_ID,
			ISNULL(ROW_PAPER_NO,ISNULL((SELECT EXP.PAPER_NO FROM EXPENSE_ITEM_PLANS EXP WHERE EXP.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID),(SELECT II.INVOICE_NUMBER FROM INVOICE II WHERE II.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID))) PAPER_NO,
			ISNULL((SELECT INV.INVOICE_ID FROM INVOICE INV WHERE INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID),(SELECT EX.EXPENSE_ID FROM EXPENSE_ITEM_PLANS EX WHERE EX.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID)) PLANS_ID,
			(SELECT EX.PROCESS_CAT FROM EXPENSE_ITEM_PLANS EX WHERE EX.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID) PROCESS_CAT
		</cfif>
		FROM 
			EXPENSE_ITEMS_ROWS,
			EXPENSE_ITEMS,
			EXPENSE_CENTER
		WHERE 
			EXPENSE_ITEMS_ROWS.IS_INCOME = 1 AND
			EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND
			EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
			<cfif len(attributes.expense_cat)>AND EXPENSE_ITEMS.EXPENSE_CATEGORY_ID IN (#attributes.expense_cat#)</cfif>
			<cfif len(attributes.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #attributes.search_date1#</cfif>
			<cfif len(attributes.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #date_add("d",1,attributes.search_date2)#</cfif>
			<cfif len(attributes.member_name) and len(attributes.member_type) and len(attributes.member_id)>
				AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE='#attributes.member_type#'
				AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID=#member_id#
			</cfif>
			<cfif len(attributes.company_id_) and len(attributes.company_)>
				AND (
						EXPENSE_ITEMS_ROWS.EXPENSE_ID IN (SELECT EX.EXPENSE_ID	FROM EXPENSE_ITEM_PLANS EX WHERE EX.CH_COMPANY_ID = #attributes.company_id_#)
				      	OR (EXPENSE_ITEMS_ROWS.INVOICE_ID IN (SELECT INV.INVOICE_ID FROM INVOICE INV WHERE COMPANY_ID = #attributes.company_id_# AND INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID))
					)
			</cfif>
			<cfif len(attributes.consumer_id_) and len(attributes.company_)>
				AND (
					EXPENSE_ITEMS_ROWS.EXPENSE_ID IN (SELECT EX.EXPENSE_ID 	FROM EXPENSE_ITEM_PLANS EX WHERE EX.CH_CONSUMER_ID = #attributes.consumer_id_#)
													 OR 
					EXPENSE_ITEMS_ROWS.INVOICE_ID IN (SELECT INV.INVOICE_ID FROM INVOICE INV WHERE COMPANY_ID = #attributes.company_id_# AND INV.INVOICE_ID = EXPENSE_ITEMS_ROWS.INVOICE_ID)
					)		
			</cfif>
			<cfif len(attributes.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID IN (#attributes.expense_item_id#)</cfif>
			<cfif len(attributes.expense_center_id)>
				AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID IN (#attributes.expense_center_id#)
			<cfelseif x_authorized_branch eq 1 and isdefined("get_expense_center")>
				<cfif len(get_expense_center.expense_id)>
					AND EXPENSE_CENTER.EXPENSE_ID IN (#ListDeleteDuplicates(Valuelist(get_expense_center.expense_id,','))#)
				<cfelse>
					AND 1=0
				</cfif>
			</cfif>	
			<cfif len(attributes.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE IN (#attributes.activity_type#)</cfif>
			<cfif len(attributes.asset) and len(attributes.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #attributes.asset_id#</cfif>
			<cfif len(attributes.project) and len(attributes.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = #attributes.project_id#</cfif>
			<cfif len(attributes.subscription_name) and len(attributes.subscription_id)>AND EXPENSE_ITEMS_ROWS.SUBSCRIPTION_ID = #attributes.subscription_id#</cfif>
			<cfif len(attributes.process_type)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ID IN (SELECT EXPENSE_ID FROM EXPENSE_ITEM_PLANS WHERE PROCESS_CAT IN (#attributes.process_type#))</cfif>
			<cfif isdefined("attributes.work_id_") and len(attributes.work_id_) and isdefined("attributes.work_head_") and len(attributes.work_head_)>AND EXPENSE_ITEMS_ROWS.WORK_ID IN (#attributes.work_id_#)</cfif>
			<cfif isdefined("attributes.opp_id_") and len(attributes.opp_id_) and isdefined("attributes.opp_head_") and len(attributes.opp_head_)>AND EXPENSE_ITEMS_ROWS.OPP_ID IN (#attributes.opp_id_#)</cfif>
			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>AND EXPENSE_ITEMS_ROWS.RECORD_EMP = #attributes.record_emp_id#</cfif>
		<cfif attributes.is_row eq 0>
			GROUP BY
				<cfif attributes.is_expence>
					EXPENSE_CENTER.EXPENSE,
					EXPENSE_CENTER.EXPENSE_ID,
				</cfif>
				<cfif attributes.is_expence_item>
					EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
					EXPENSE_ITEMS.EXPENSE_ITEM_ID,
				</cfif>
				<cfif attributes.is_activity>
					EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE,
				</cfif>
				<cfif attributes.is_expence_cat>
					EXPENSE_ITEMS.EXPENSE_CATEGORY_ID,
				</cfif>
				<cfif attributes.is_expence_member>
					EXPENSE_ITEMS_ROWS.MEMBER_TYPE,
					EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID,
					EXPENSE_ITEMS_ROWS.COMPANY_ID,
				</cfif>
				<cfif attributes.is_date>
					EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
				</cfif>
				<cfif attributes.is_other_money>
					EXPENSE_ITEMS_ROWS.MONEY_CURRENCY_ID,
				</cfif>
				<cfif attributes.is_asset>
					EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID,
				</cfif>
				<cfif attributes.is_stock>
					EXPENSE_ITEMS_ROWS.PRODUCT_ID,
					EXPENSE_ITEMS_ROWS.STOCK_ID_2,
				</cfif>
				<cfif attributes.is_detail>
					SUBSTRING(EXPENSE_ITEMS_ROWS.DETAIL,1,50),
				</cfif>
				<cfif attributes.is_project>
					EXPENSE_ITEMS_ROWS.PROJECT_ID,
				</cfif>
				<cfif attributes.is_work>
					EXPENSE_ITEMS_ROWS.WORK_ID,
				</cfif>
				<cfif attributes.is_opp>
					EXPENSE_ITEMS_ROWS.OPP_ID,
				</cfif>
				EXPENSE_ITEMS_ROWS.IS_INCOME
				,EXPENSE_ITEMS_ROWS.INVOICE_ID
				,EXPENSE_ITEMS_ROWS.RECORD_EMP
		</cfif>			
		
		ORDER BY
			<cfif attributes.is_expence and attributes.report_sort eq 1>
				EXPENSE_CENTER.EXPENSE,
				TOTAL_AMOUNT DESC
			<cfelseif attributes.is_expence_item and attributes.report_sort eq 2>
				EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
				TOTAL_AMOUNT DESC
			<cfelseif attributes.is_date and attributes.report_sort eq 3>
				EXPENSE_ITEMS_ROWS.EXPENSE_DATE,
				TOTAL_AMOUNT DESC
			<cfelseif attributes.is_project and attributes.report_sort eq 4>
				EXPENSE_ITEMS_ROWS.PROJECT_ID,
				TOTAL_AMOUNT DESC
			<cfelse>
				TOTAL_AMOUNT DESC
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_expense_item_row_all.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_expense_item_row_all.recordcount#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfform name="search_asset" action="#request.self#?fuseaction=report.detail_income_analyse_report" method="post">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40713.Detaylı Gelir Analiz Raporu'></cfsavecontent>
	<cf_report_list_search title="#title#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-xs-12">
								<input name="form_exist" id="form_exist" type="hidden" value="1">
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='58172.Gelir Merkezi'></label>
									<div class="col col-12">
										<select name="expense_center_id" id="expense_center_id" multiple>
											<cfoutput query="get_expense_center">
												<option value="#EXPENSE_ID#" <cfif listfind(attributes.expense_center_id,EXPENSE_ID,',')>selected</cfif>><cfif find('.',EXPENSE_CODE)>&nbsp;&nbsp;&nbsp;</cfif>#expense#</option><!--- #RepeatString('&nbsp;&nbsp;',listlen(EXPENSE_CODE,'.')-1)# --->
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
									<div class="col col-12">
										<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
											SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (121) ORDER BY PROCESS_CAT
										</cfquery>
										<select name="process_type" id="process_type" multiple>
											<cfoutput query="get_process_cat">
												<option value="#process_cat_id#" <cfif listfind(attributes.process_type,process_cat_id,',')>selected</cfif>>#process_cat#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></label>
									<div class="col col-12">
										<select name="expense_item_id" id="expense_item_id" multiple>
											<cfoutput query="get_expense_item">
												<option value="#EXPENSE_ITEM_ID#" <cfif listfind(attributes.expense_item_id,EXPENSE_ITEM_ID,',')>selected</cfif>>#EXPENSE_ITEM_NAME#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='39173.Aktivite Tipi'></label>
									<div class="col col-12">
										<select name="activity_type" id="activity_type" multiple>
											<cfoutput query="get_activity_types">
												<option value="#ACTIVITY_ID#" <cfif listfind(attributes.activity_type,ACTIVITY_ID,',')>selected</cfif>>#ACTIVITY_NAME#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
									<div class="col col-12">
										<select name="expense_cat" id="expense_cat" multiple>
											<cfoutput query="get_expense_cat">
												<option value="#expense_cat_id#" <cfif listfind(attributes.expense_cat,expense_cat_id,',')>selected</cfif>>#expense_cat_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 "><cf_get_lang dictionary_id='29452.Varlık'></label>
									<div class="col col-12">
										<div class="input-group">
											<cfif len(attributes.asset) and len(attributes.asset_id)>
												<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
												<input type="text" name="asset" id="asset" onFocus="AutoComplete_Create('asset','ASSETP','ASSETP','get_assept','3','ASSETP_ID','asset_id','',3,160);" value="<cfoutput>#attributes.asset#</cfoutput>" style="width:160px;">
											<cfelse>
												<input type="hidden" name="asset_id" id="asset_id" value="">
												<input type="text" name="asset" id="asset" onFocus="AutoComplete_Create('asset','ASSETP','ASSETP','get_assept','3','ASSETP_ID','asset_id','',3,160);" value="" style="width:160px;">
											</cfif>
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=search_asset.asset_id&field_name=search_asset.asset&event_id=0&motorized_vehicle=0','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-12">
										<div class="input-group">
											<cfif len(attributes.project_id) and len(attributes.project)>
												<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
												<input type="text" name="project" id="project" onFocus="AutoComplete_Create('project','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','',3,160);" value="<cfoutput>#attributes.project#</cfoutput>" style="width:160px;">
											<cfelse>
												<input type="hidden" name="project_id" id="project_id" value="">
												<input type="text" name="project" id="project" onFocus="AutoComplete_Create('project','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','',3,160);" value="" style="width:160px;">					
											</cfif>
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_asset.project_id&project_head=search_asset.project');"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='58445.İş'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="work_id_" id="work_id_" value="<cfif isdefined("attributes.work_id_")><cfoutput>#attributes.work_id_#</cfoutput></cfif>">
											<input type="text" name="work_head_" id="work_head_" value="<cfif isdefined("attributes.work_head_")><cfoutput>#attributes.work_head_#</cfoutput></cfif>" onFocus="AutoComplete_Create('work_head_','WORK_HEAD','WORK_HEAD','get_work','1','WORK_ID','work_id_','',3,160);" style="width:160px;">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=search_asset.work_id_&field_name=search_asset.work_head_','list')"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id="57612.Fırsat"></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="opp_id_" id="opp_id_" value="<cfoutput>#attributes.opp_id_#</cfoutput>">
											<input type="text" name="opp_head_" id="opp_head_" style="width:160px;" onFocus="AutoComplete_Create('opp_head_','OPP_HEAD','OPP_HEAD','get_opportunity','3','OPP_ID','opp_id_','',3,160);" value="<cfif isdefined("attributes.opp_head_")><cfoutput>#attributes.opp_head_#</cfoutput></cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_opportunities&field_opp_id=search_asset.opp_id_&field_opp_head=search_asset.opp_head_','list')"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='39157.Harcama Yapan'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
											<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#attributes.member_id#</cfoutput>">
											<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
											<input type="text" style="width:160px;" name="member_name" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,2,3','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID','member_type,member_id,company_id','',3,160);" value="<cfoutput>#attributes.member_name#</cfoutput>" class="txt">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac_company();"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
											<input type="text" name="record_emp_name" id="record_emp_name" style="width:160px;" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','search_asset','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_asset.record_emp_name&field_emp_id=search_asset.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="consumer_id_" id="consumer_id_" value="<cfif isdefined('attributes.consumer_id_') and len(attributes.company_)><cfoutput>#attributes.consumer_id_#</cfoutput></cfif>">
											<input type="hidden" name="company_id_" id="company_id_" value="<cfif len(attributes.company_)><cfoutput>#attributes.company_id_#</cfoutput></cfif>">
											<input type="text" name="company_" id="company_" style="width:160px;" onFocus="AutoComplete_Create('company_','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,2,3','COMPANY_ID,CONSUMER_ID','company_id_,consumer_id_','',3,160);" value="<cfif len(attributes.company_)><cfoutput>#attributes.company_#</cfoutput></cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_asset.company_&field_comp_id=search_asset.company_id_&field_consumer=search_asset.consumer_id_&field_member_name=search_asset.company_&select_list=2,3','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='58832.Abone'></label>
									<div class="col col-12">
										<div class="input-group">
											<cfif len(attributes.subscription_id) and len(attributes.subscription_name)>
												<input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#attributes.subscription_id#</cfoutput>">
												<input type="text" name="subscription_name" id="subscription_name" onFocus="AutoComplete_Create('subscription_name','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','160');" value="<cfoutput>#attributes.subscription_name#</cfoutput>" style="width:160px;">
											<cfelse>
												<input type="hidden" name="subscription_id" id="subscription_id" value="">
												<input type="text" name="subscription_name" id="subscription_name" onFocus="AutoComplete_Create('subscription_name','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','160');" value="" style="width:160px;">					
											</cfif>
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=search_asset.subscription_id&field_no=search_asset.subscription_name','list');"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='58924.Sıralama'></label>
									<div class="col col-12">
										<select name="report_sort" id="report_sort">
											<option value="0" <cfif attributes.report_sort eq 0>selected</cfif>><cf_get_lang dictionary_id='57673.Tutar'></option>
											<option value="4" <cfif attributes.report_sort eq 4>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
											<option value="1" <cfif attributes.report_sort eq 1>selected</cfif>><cf_get_lang dictionary_id='58172.Gelir Merkezi'></option>
											<option value="2" <cfif attributes.report_sort eq 2>selected</cfif>><cf_get_lang dictionary_id='58173.Gelir Kalemi'></option>
											<option value="3" <cfif attributes.report_sort eq 3>selected</cfif>><cf_get_lang dictionary_id='58690.Tarih'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id ='39741.Grafik'></label>
									<div class="col col-12">
										<select name="graph_type" id="graph_type" style="width:100px;">
											<option value="" selected><cf_get_lang dictionary_id='57950.Grafik Format'></option>
											<option value="cylinder" <cfif attributes.graph_type eq 'cylinder'> selected</cfif>>Cylinder</option>
											<option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
											<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
									<div class="col col-12">
										<div class="input-group">
											 <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
											<cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:65px;">
											<cfif not isdefined('attributes.ajax')>
											<span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
											</cfif>
											<span class="input-group-addon no-bg"></span>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
											<cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" required="yes" style="width:65px;">
											<cfif not isdefined('attributes.ajax')>
											<span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
											</cfif>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12"><cf_get_lang dictionary_id='39174.Rapor Baz'></label>
									<div class="col col-12">
										<cfset list_num = 0>
										<div class="form-group">
											<label><cf_get_lang dictionary_id='57416.Proje'><input name="is_project" id="is_project" value="1" type="checkbox" <cfif attributes.is_project eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='58445.İş'><input name="is_work" id="is_work" value="1" type="checkbox" <cfif attributes.is_work eq 1 >checked<cfset list_num = list_num + 1></cfif>></label>
											<label><cf_get_lang dictionary_id='57612.Fırsat'><input name="is_opp" id="is_opp" value="1" type="checkbox" <cfif attributes.is_opp eq 1 >checked<cfset list_num = list_num + 1></cfif>></label>
											<label><cf_get_lang dictionary_id='58172.Gelir Merkezi'><input name="is_expence" id="is_expence" value="1" type="checkbox" <cfif attributes.is_expence eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='57486.Kategori'><input name="is_expence_cat" id="is_expence_cat" value="1" type="checkbox" <cfif attributes.is_expence_cat eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='58173.Gelir Kalemi'><input name="is_expence_item" id="is_expence_item" value="1" type="checkbox" <cfif attributes.is_expence_item eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='39173.Aktivite Tipi'><input name="is_activity" id="is_activity" value="1" type="checkbox" <cfif attributes.is_activity eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='39157.Harcama Yapan'><input name="is_expence_member" id="is_expence_member" value="1" type="checkbox" <cfif attributes.is_expence_member eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='58690.Tarih'><input name="is_date" id="is_date" value="1" type="checkbox" <cfif attributes.is_date eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='57677.Döviz'><input name="is_other_money" id="is_other_money" value="1" type="checkbox" <cfif attributes.is_other_money eq 1 >checked<cfset list_num = list_num +2></cfif>></label>
											<label><cf_get_lang dictionary_id='29452.Varlık'><input name="is_asset" id="is_asset" value="1" type="checkbox" <cfif attributes.is_asset eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='57452.Stok'><input name="is_stock" id="is_stock" value="1" type="checkbox" <cfif attributes.is_stock eq 1 >checked<cfset list_num = list_num +1></cfif>></label>
											<label><cf_get_lang dictionary_id='57629.Açıklama'><input name="is_detail" id="is_detail" value="1" type="checkbox" <cfif attributes.is_detail eq 1 >checked<cfif attributes.is_row eq 0><cfset list_num = list_num +1></cfif></cfif>></label>
											<label><cf_get_lang dictionary_id='58508.Satır'><input name="is_row" id="is_row" value="1" type="checkbox" <cfif attributes.is_row eq 1 >checked<cfset list_num = list_num + 4></cfif>></label>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1"<cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
							<cf_wrk_report_search_button insert_info='#message#' search_function='control()' button_type='1' is_excel='1'>
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
	<cfset type_ = 1>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined('attributes.ajax')>
	<cfset style_="display:none;">
<cfelse>
	<cfset style_="">
</cfif>
<cf_report_list>
		<thead>
			<tr>
				<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
				<cfif attributes.is_detail and attributes.is_row eq 0>
					<th width="180"><cf_get_lang dictionary_id='57629.Açıklama'></th>
				</cfif>
				<cfif attributes.is_project>
					<th width="180"><cf_get_lang dictionary_id='57416.Proje'></th>
				</cfif>
				<cfif attributes.is_work>
					<th width="130"><cf_get_lang dictionary_id="58445.İş"></th>
				</cfif>
				<cfif attributes.is_opp>
					<th width="130"><cf_get_lang dictionary_id="57612.Fırsat"></th>
				</cfif>
				<cfif attributes.is_expence>
					<th width="170"><cf_get_lang dictionary_id='58172.Gelir Merkezi'></th>
				</cfif>
				<cfif attributes.is_expence_cat>
					<th width="180"><cf_get_lang dictionary_id='57486.Kategori'></th>
				</cfif>
				<cfif attributes.is_expence_item>
					<th width="170"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></th>
				</cfif>
				<cfif attributes.is_row>
					<th width="180"><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th width="100"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>					
					<th width="100"><cf_get_lang dictionary_id='57629.Açıklama'></th>
				</cfif>
				<th width="100"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
				
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				
				<cfif attributes.is_date>
					<th><cf_get_lang dictionary_id='58690.Tarih'></th>
				</cfif>
				<cfif attributes.is_expence_member>
					<th width="180"><cf_get_lang dictionary_id='39157.Harcama Yapan'></th>
				</cfif>
				<cfif attributes.is_activity>
					<th width="180"><cf_get_lang dictionary_id='39180.Aktivite'></th>
				</cfif>
				<cfif attributes.is_asset>
					<th width="180"><cf_get_lang dictionary_id='29452.Varlık'></th>
				</cfif>
				<cfif attributes.is_stock>
					<th width="180"><cf_get_lang dictionary_id='57452.Stok'></th>
				</cfif>
				<cfif attributes.is_other_money>
					<th style="text-align:right;" width="120"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></th>
					<th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th style="text-align:right;" width="120"><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th style="text-align:center;" ><cf_get_lang dictionary_id='58474.Birim'></th>
				<th  style="text-align:right;" width="120"><cf_get_lang dictionary_id='57639.KDV'></th>
				<th style="text-align:center;" ><cf_get_lang dictionary_id='58474.Birim'></th>		 
				<th style="text-align:right;" width="120"><cf_get_lang dictionary_id='58021.ÖTV'></th>
				<th style="text-align:center;" ><cf_get_lang dictionary_id='58474.Birim'></th>		 
				<th style="text-align:right;" width="120"><cf_get_lang dictionary_id='57644.Son Toplam'></th>
				<th style="text-align:center;" ><cf_get_lang dictionary_id='58474.Birim'></th>	
			</tr>
		</thead>
		<cfif len(attributes.form_exist)>
			<cfif get_expense_item_row_all.recordcount>
				<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows = get_expense_item_row_all.recordcount>
				</cfif>
				<cfquery name="GET_ACTIVITY_TYPES_1" dbtype="query">
					SELECT ACTIVITY_ID, ACTIVITY_NAME FROM GET_ACTIVITY_TYPES ORDER BY ACTIVITY_ID
				</cfquery>
				<cfquery name="GET_EXPENSE_CAT_1" dbtype="query">
					SELECT EXPENSE_CAT_ID, EXPENSE_CAT_NAME FROM GET_EXPENSE_CAT ORDER BY EXPENSE_CAT_ID
				</cfquery>
				<cfquery name="GET_EXPENSE_ALL" dbtype="query">
					SELECT 
						SUM(AMOUNT) AMOUNT_TOTAL,
						SUM(AMOUNT_KDV) AMOUNT_KDV_TOTAL,
						SUM(AMOUNT_OTV) AMOUNT_OTV_TOTAL,
						SUM(TOTAL_AMOUNT) TOTAL_AMOUNT_TOTAL
					FROM
						get_expense_item_row_all
				</cfquery>
				<cfoutput query="get_tax">
					<cfset 'genel_toplam_#tax#' = 0>
				</cfoutput>
				<cfset asset_id_list=''>
				<cfset stock_id_list=''>
				<cfset project_id_list=''>
				<cfset consumer_id_list=''>
				<cfset company_id_list=''>
				<cfset employee_id_list=''>
				<cfset work_head_list = "">
				<cfset opp_head_list = "">
				<cfset record_emp_id_list=''>
				<cfoutput query="get_expense_item_row_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<cfif attributes.is_asset eq 1>
						<cfif len(pyschical_asset_id) and not listfind(asset_id_list,pyschical_asset_id)>
							<cfset asset_id_list=listappend(asset_id_list,pyschical_asset_id)>
						</cfif>
					</cfif>
					<cfif attributes.is_stock eq 1>
						<cfif len(stock_id_2) and not listfind(stock_id_list,stock_id_2)>
							<cfset stock_id_list=listappend(stock_id_list,stock_id_2)>
						</cfif>
					</cfif>
					<cfif attributes.is_project eq 1>
						<cfif len(project_id) and not listfind(project_id_list,project_id)>
							<cfset project_id_list=listappend(project_id_list,project_id)>
						</cfif>
					</cfif>
					<cfif attributes.is_work eq 1>
						<cfif len(work_id) and not listfind(work_head_list,work_id)>
							<cfset work_head_list=listappend(work_head_list,work_id)>
						</cfif>
					</cfif>
					<cfif attributes.is_opp eq 1>
						<cfif len(opp_id) and not listfind(opp_head_list,opp_id)>
							<cfset opp_head_list=listappend(opp_head_list,opp_id)>
						</cfif>
					</cfif>
					<cfif isdefined("member_type")>
						<cfif MEMBER_TYPE eq 'partner'>
							<cfif isdefined("company_partner_id") and len(company_partner_id) and not listfind(company_id_list,company_partner_id)>
								<cfset company_id_list=listappend(company_id_list,company_partner_id)>
							</cfif>
						<cfelseif MEMBER_TYPE eq 'consumer'>
							<cfif isdefined("company_partner_id") and len(company_partner_id) and not listfind(consumer_id_list,company_partner_id)>
								<cfset consumer_id_list=listappend(consumer_id_list,company_partner_id)>
							</cfif>
						<cfelseif MEMBER_TYPE eq 'employee'>
							<cfif isdefined("company_partner_id") and len(company_partner_id) and not listfind(employee_id_list,company_partner_id)>
								<cfset employee_id_list=listappend(employee_id_list,company_partner_id)>
							</cfif>
						</cfif>
					</cfif>
					<cfif isdefined("ch_company_id") and len(ch_company_id)>
						<cfif len(ch_company_id) and not listfind(company_id_list,ch_company_id)>
							<cfset company_id_list=listappend(company_id_list,ch_company_id)>
						</cfif>
					</cfif>
					<cfif isdefined("ch_consumer_id") and len(ch_consumer_id)>
						<cfif len(ch_consumer_id) and not listfind(consumer_id_list,ch_consumer_id)>
							<cfset consumer_id_list=listappend(consumer_id_list,ch_consumer_id)>
						</cfif>
					</cfif>
					<cfif isdefined("record_emp") and len(record_emp) and not listfind(record_emp_id_list,record_emp)>
						<cfset record_emp_id_list=listappend(record_emp_id_list,record_emp)>
					</cfif>
				</cfoutput>
				<cfif len(company_id_list)>
					<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
					<cfquery name="get_company" datasource="#dsn#">
						SELECT FULLNAME,COMPANY_ID	FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
					</cfquery>
					<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company.COMPANY_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(consumer_id_list)>
					<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
					<cfquery name="get_consumer" datasource="#dsn#">
						SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
					</cfquery>
					<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer.CONSUMER_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(employee_id_list)>
					<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
					<cfquery name="get_employee" datasource="#dsn#">
						SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
					</cfquery>
					<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.EMPLOYEE_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(asset_id_list)>
					<cfset asset_id_list=listsort(asset_id_list,"numeric","ASC",",")>
					<cfquery name="get_asset" datasource="#dsn#">
						SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#asset_id_list#) ORDER BY ASSETP_ID
					</cfquery>
				</cfif>
				<cfif len(stock_id_list)>
					<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
					<cfquery name="get_stock" datasource="#dsn3#">
						SELECT STOCK_ID,PRODUCT_NAME FROM STOCKS WHERE STOCK_ID IN (#stock_id_list#) ORDER BY STOCK_ID
					</cfquery>
				</cfif>
				<cfif len(project_id_list)>
					<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
					<cfquery name="get_project" datasource="#dsn#">
						SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
					</cfquery>
				</cfif>
				<cfif len(work_head_list)>
					<cfset work_head_list=listsort(work_head_list,"numeric","ASC",",")>
					<cfquery name="get_work" datasource="#dsn#">
						SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_head_list#) ORDER BY WORK_ID
					</cfquery>
					<cfset work_head_list = ListSort(ListDeleteDuplicates(ValueList(get_work.work_id)),'numeric','ASC',',')>
				</cfif>
				<cfif len(opp_head_list)>
					<cfset opp_head_list=listsort(opp_head_list,"numeric","ASC",",")>
					<cfquery name="get_opportunities" datasource="#DSN3#">
						SELECT OPP_ID,OPP_HEAD FROM OPPORTUNITIES WHERE OPP_ID IN (#opp_head_list#) ORDER BY OPP_ID
					</cfquery>
					<cfset opp_head_list = ListSort(ListDeleteDuplicates(ValueList(get_opportunities.opp_id)),'numeric','ASC',',')>
				</cfif>
				<cfif len(record_emp_id_list)>
					<cfset record_emp_id_list=listsort(record_emp_id_list,'numeric','asc',',')>
					<cfquery name="get_rec_emp" datasource="#DSN#">
						SELECT EMPLOYEE_ID,EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam list="yes" value="#record_emp_id_list#">) ORDER BY EMPLOYEE_ID
					</cfquery>
					<cfset record_emp_id_list = listsort(listdeleteduplicates(valuelist(get_rec_emp.employee_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfscript>
					activity_type_ids = listsort(valuelist(GET_ACTIVITY_TYPES_1.ACTIVITY_ID,','),'numeric','ASC',',');
					expense_cat_ids = listsort(valuelist(GET_EXPENSE_CAT_1.EXPENSE_CAT_ID,','),'numeric','ASC',',');
					toplam_amount = 0;
					toplam_amount_kdv = 0;
					toplam_amount_otv = 0;
					toplam_total_amount = 0;
				</cfscript>
					<cfif isdefined('attributes.ajax')><!--- Kümülatif raporlar oluşturuluyorsa! --->
						<cfoutput query="get_expense_item_row_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
							<cfinclude template="../../settings/cumulative/cumulative_expense_month.cfm">
						</cfoutput>
						<cfif get_expense_item_row_all.recordcount gte (attributes.startrow+attributes.maxrows)>
							<script type="text/javascript">
								user_info_show_div(<cfoutput>#attributes.page+1#,#(((attributes.startrow+attributes.maxrows)*100)/get_expense_item_row_all.recordcount)#</cfoutput>);
							</script>
						<cfelse>
							<script type="text/javascript">
								user_info_show_div(1,1,1);
							</script>
							<cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
								UPDATE 
									REPORT_SYSTEM 
								SET 
									PROCESS_FINISH_DATE = #NOW()#,
									PROCESS_ROW_COUNT = #get_expense_item_row_all.recordcount#
								WHERE 
									REPORT_TABLE = '#attributes.table_name#' AND 
									PERIOD_YEAR = #attributes.period_year# AND 
									PERIOD_MONTH = #attributes.period_month# AND 
									OUR_COMPANY_ID = #attributes.period_our_company_id#
							</cfquery>
						</cfif>
						<cfabort>
					<cfelse>  
						<tbody>  
						<cfoutput query="get_expense_item_row_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
							<cfif isDefined("INVOICE_ID") and len(INVOICE_ID)>
								<cfquery name="get_product_name" datasource="#dsn2#">
									SELECT PRODUCT_ID,NAME_PRODUCT,AMOUNT FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#INVOICE_ID#">
								</cfquery>
							</cfif>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								<cfset attributes.startrow=1>
								<cfset attributes.maxrows = get_expense_item_row_all.recordcount>
							</cfif>
							<cfscript>
								toplam_amount = toplam_amount + amount;				
								toplam_amount_kdv = toplam_amount_kdv + amount_kdv;
								if(len(amount_otv))toplam_amount_otv = toplam_amount_otv + amount_otv;
								toplam_total_amount = toplam_total_amount + total_amount;
							</cfscript>
							<tr>
								<td>#currentrow#</td>
								<cfif attributes.is_detail and attributes.is_row eq 0>
									<td>#DETAIL#</td>					
								</cfif>
								<cfif attributes.is_project>
									<td><cfif len(project_id_list) and len(project_id)>
											#get_project.project_head[listfind(project_id_list,project_id,',')]#
										</cfif>
									</td>					
								</cfif>
								<cfif attributes.is_work>
									<td>
										<cfif len(work_head_list) and len(work_id)>
											#get_work.work_head[listfind(work_head_list,work_id,',')]#
										</cfif>
									</td>					
								</cfif>
								<cfif attributes.is_opp>
									<td>
										<cfif len(opp_head_list) and len(opp_id)>
											#get_opportunities.opp_head[listfind(opp_head_list,opp_id,',')]#
										</cfif>
									</td>					
								</cfif>
								<cfif attributes.is_expence>
									<td>#expense#</td>
								</cfif>
								<cfif attributes.is_expence_cat>
									<td>#get_expense_cat_1.expense_cat_name[listfind(expense_cat_ids,expense_category_id,',')]#</td>
								</cfif>
								<cfif attributes.is_expence_item>
									<td>#expense_item_name#</td>
								</cfif>
								<cfif attributes.is_row>
									<td>
										<cfif not isdefined("is_excel")>
											<cfif PROCESS_CAT eq 102>
												<cfif isdefined('plans_id') and len(plans_id)>
													<a href="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#plans_id#" class="tableyazi">#PAPER_NO#</a>
												<cfelse>
													<a href="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#expense_id#" class="tableyazi">#PAPER_NO#</a>
												</cfif>
											<cfelse>
												<cfif isdefined('plans_id') and len(plans_id)>
													<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#plans_id#" class="tableyazi">#PAPER_NO#</a>
												<cfelse>
													<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#expense_id#" class="tableyazi">#PAPER_NO#</a>
												</cfif>
											</cfif>
										<cfelse>
											#PAPER_NO#
										</cfif>
									</td>
									<td>
										<cfif isdefined("ch_company_id") and len(ch_company_id)>
											#get_company.FULLNAME[listfind(company_id_list,ch_company_id,',')]#
										<cfelseif isdefined("ch_consumer_id") and len(ch_consumer_id)>
											#get_consumer.CONSUMER_NAME[listfind(consumer_id_list,ch_consumer_id,',')]# #get_consumer.CONSUMER_SURNAME[listfind(consumer_id_list,ch_consumer_id,',')]#
										<cfelseif isdefined("CH_EMPLOYEE_ID") and len(CH_EMPLOYEE_ID)>
											#get_emp_info(CH_EMPLOYEE_ID,0,0)#
										</cfif>
									</td>
									
									<td>#DETAIL#</td>					
								</cfif>
								<td> 
									<cfif isdefined("record_emp") and len(record_emp)>
										<cfif not isdefined("is_excel")>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#get_rec_emp.employee[listfind(record_emp_id_list,record_emp,',')]#</a>
										<cfelse>
											#get_rec_emp.employee[listfind(record_emp_id_list,record_emp,',')]#
										</cfif>
									</cfif>
								</td>
								
									<td style="text-align:right;" format="numeric"><cfif isdefined("get_product_name.AMOUNT")>#TLFormat(get_product_name.AMOUNT)#</cfif></td>
								
								<cfif attributes.is_date>
									<td>#dateformat(expense_date,dateformat_style)#</td>
								</cfif>
								<cfif attributes.is_expence_member>
									<td>
										<cfif MEMBER_TYPE eq 'partner'>
											#get_company.FULLNAME[listfind(company_id_list,company_partner_id,',')]#
										<cfelseif MEMBER_TYPE eq 'consumer'>
											#get_consumer.CONSUMER_NAME[listfind(consumer_id_list,company_partner_id,',')]# #get_consumer.CONSUMER_SURNAME[listfind(consumer_id_list,company_partner_id,',')]#
										<cfelseif MEMBER_TYPE eq 'employee'>
											#get_employee.EMPLOYEE_NAME[listfind(employee_id_list,company_partner_id,',')]# #get_employee.EMPLOYEE_SURNAME[listfind(employee_id_list,company_partner_id,',')]#
										</cfif>
									</td>
								</cfif>
								<cfif attributes.is_activity>
									<td>#GET_ACTIVITY_TYPES_1.ACTIVITY_NAME[listfind(activity_type_ids,ACTIVITY_TYPE,',')]#</td>
								</cfif>
								<cfif attributes.is_asset>
									<td><cfif len(asset_id_list) and len(pyschical_asset_id)>#get_asset.assetp[listfind(asset_id_list,pyschical_asset_id,',')]#</cfif></td>					
								</cfif>
								<cfif attributes.is_stock>
									<td>
										<cfif len(stock_id_list) and len(stock_id_2)>
											<cfif type_ eq 1>
												#get_stock.product_name[listfind(stock_id_list,stock_id_2,',')]#
											<cfelse> 
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','large');" class="tableyazi">
													#get_stock.product_name[listfind(stock_id_list,stock_id_2,',')]#
												</a>
											</cfif>
										<cfelseif isDefined("INVOICE_ID") and len(INVOICE_ID)>                                            
                                            <cfquery name="get_product_name_" datasource="#dsn2#">
                                                SELECT PRODUCT_ID,NAME_PRODUCT,AMOUNT FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#INVOICE_ID#">
                                            </cfquery>                                            
                                            #get_product_name_.NAME_PRODUCT#
										</cfif>
									</td>					
								</cfif>
								<cfif attributes.is_other_money>
									<td style="text-align:right;" format="numeric">#TLFormat(other_money_gross_total)#</td>
									<td style="text-align:center;">#money_currency_id#</td>
								</cfif>
								<td style="text-align:right;" format="numeric">#TLFormat(amount)#</td>
								<td style="text-align:center;">#session.ep.money#</td>
								<cfif attributes.is_expence>
									<cfset expense_id = get_expense_item_row_all.expense_id>
								</cfif>
								<cfif attributes.is_expence_item>
									<cfset expense_item_id = get_expense_item_row_all.expense_item_id>
								</cfif>
								<cfif attributes.is_activity>
									<cfset activity_type = get_expense_item_row_all.activity_type>
								</cfif>
								<cfif attributes.is_expence_cat>
									<cfset expense_category_id = get_expense_item_row_all.expense_category_id>
								</cfif>
								<cfif attributes.is_expence_member>
									<cfset member_type = get_expense_item_row_all.member_type>
									<cfset company_partner_id = get_expense_item_row_all.company_partner_id>
									<cfset company_id = get_expense_item_row_all.company_id>
								</cfif>
								<cfif attributes.is_date>
									<cfset expense_date = get_expense_item_row_all.expense_date>
								</cfif>
								<cfif attributes.is_other_money>
									<cfset money_currency_id = get_expense_item_row_all.money_currency_id>
								</cfif>
								<cfif attributes.is_asset>
									<cfset pyschical_asset_id = get_expense_item_row_all.pyschical_asset_id>	
								</cfif>
								<cfif attributes.is_stock>
									<cfset stock_id_2 = get_expense_item_row_all.stock_id_2>	
								</cfif>
								<cfif attributes.is_project>
									<cfset project_id = get_expense_item_row_all.project_id>	
								</cfif>
								<cfif attributes.is_work>
									<cfset work_id = get_expense_item_row_all.work_id>	
								</cfif>
								<cfif attributes.is_opp>
									<cfset opp_id = get_expense_item_row_all.opp_id>	
								</cfif>
								<td style="text-align:right;" format="numeric"><cfif len(amount_kdv)>#TLFormat(amount_kdv)#</cfif></td>
								<td style="text-align:center;"><cfif len(amount_kdv)>#session.ep.money# <cfelse>0 #session.ep.money#</cfif></td>
								<td style="text-align:right;" format="numeric"><cfif len(amount_otv)>#TLFormat(amount_otv)#</cfif></td>
								<td style="text-align:center;"><cfif len(amount_kdv)>#session.ep.money# <cfelse>0 #session.ep.money#</cfif></td>
								<td style="text-align:right;" format="numeric">#TLFormat(total_amount)#</td>
								<td style="text-align:center;">#session.ep.money#</td>
							</tr>
						</cfoutput>
						</tbody>
						<tfoot>
						<tr>
							<td style="text-align:right;" colspan="<cfoutput>#list_num+2#</cfoutput>" class="txtbold"><cf_get_lang dictionary_id='39183.Sayfa Toplam'></td>
							<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(toplam_amount)#</cfoutput></td>
							<td style="text-align:center;" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
							<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(toplam_amount_kdv)#</cfoutput></td>
							<td style="text-align:center;" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
							<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(toplam_amount_otv)#</cfoutput></td>
							<td style="text-align:center;" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
							<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(toplam_total_amount)#</cfoutput></td>
							<td style="text-align:center;" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
						</tr>
						<tr>
							<td style="text-align:right;" colspan="<cfoutput>#list_num+2#</cfoutput>" class="txtbold"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
							<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(GET_EXPENSE_ALL.AMOUNT_TOTAL)#</cfoutput></td>
							<td style="text-align:center;" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
							<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(GET_EXPENSE_ALL.AMOUNT_KDV_TOTAL)#</cfoutput></td>
							<td style="text-align:center;" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
							<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(GET_EXPENSE_ALL.AMOUNT_OTV_TOTAL)#</cfoutput></td>
							<td style="text-align:center;" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
							<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput>#TLFormat(GET_EXPENSE_ALL.TOTAL_AMOUNT_TOTAL)#</cfoutput></td>
							<td style="text-align:center;" class="txtbold"><cfoutput>#session.ep.money#</cfoutput></td>
						</tr>
						</tfoot>
					</cfif>
			<cfelse>
				<cfif isdefined('attributes.ajax')>
					<script type="text/javascript">
						user_info_show_div(1,1,1);
					</script>
				</cfif>
				<cfset colspan = 9>
				<cfif attributes.is_detail>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_project>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_work>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_opp>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_expence>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_expence_cat>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_expence_item>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_row>
					<cfset colspan = colspan + 4>
				</cfif>
				<cfif attributes.is_date>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_expence_member>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_activity>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_asset>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_stock>
					<cfset colspan = colspan + 1>
				</cfif>
				<cfif attributes.is_other_money>
					<cfset colspan = colspan + 2>
				</cfif>
				<tr>
					<td colspan="<cfoutput>#colspan+2#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>
		<cfelse>
			<tr>
				<td colspan="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
			</tr>
		</cfif>	
</cf_report_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="98%" align="center" cellpadding="0" cellspacing="0" height="35"<cfif isdefined('attributes.ajax')>style="display:none;"</cfif>>
		<tr>
			<td>
				<cfscript>
					url_str = "" ;
					url_str = "#url_str#&is_expence=#attributes.is_expence#";
					url_str = "#url_str#&is_asset=#attributes.is_asset#";
					url_str = "#url_str#&is_stock=#attributes.is_stock#";
					url_str = "#url_str#&is_detail=#attributes.is_detail#";
					url_str = "#url_str#&is_project=#attributes.is_project#";
					url_str = "#url_str#&is_work=#attributes.is_work#";
					url_str = "#url_str#&is_opp=#attributes.is_opp#";
					url_str = "#url_str#&is_expence_item=#attributes.is_expence_item#";
					url_str = "#url_str#&is_activity=#attributes.is_activity#";
					url_str = "#url_str#&is_expence_cat=#attributes.is_expence_cat#";
					url_str = "#url_str#&is_expence_member=#attributes.is_expence_member#";
					url_str = "#url_str#&is_date=#attributes.is_date#&is_row=#attributes.is_row#";
					url_str = "#url_str#&is_other_money=#attributes.is_other_money#";
					url_str = "#url_str#&report_sort=#attributes.report_sort#&process_type=#attributes.process_type#";
					url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#";
					if ( len(attributes.asset_id) )
						url_str = "#url_str#&asset_id=#attributes.asset_id#&asset=#attributes.asset#";
					if ( len(attributes.project_id) )
						url_str = "#url_str#&project_id=#attributes.project_id#&project=#attributes.project#";
					if ( len(attributes.subscription_id) )
						url_str = "#url_str#&subscription_id=#attributes.subscription_id#&subscription_name=#attributes.subscription_name#";
					if ( len(attributes.member_type) )
						url_str = "#url_str#&member_type=#attributes.member_type#";
					if ( len(attributes.member_id) )
						url_str = "#url_str#&member_id=#attributes.member_id#";
					if ( len(attributes.company_id) )
						url_str = "#url_str#&company_id=#attributes.company_id#";
					if ( len(attributes.member_name) )
						url_str = "#url_str#&member_name=#attributes.member_name#";
					if ( len(attributes.expense_item_id) )
						url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
					if ( len(attributes.expense_center_id) )
						url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
					if ( len(attributes.activity_type) )
						url_str = "#url_str#&activity_type=#attributes.activity_type#";
					if ( len(attributes.form_exist) )
						url_str = "#url_str#&form_exist=#attributes.form_exist#";
					if ( len(attributes.expense_cat) )
						url_str = "#url_str#&expense_cat=#attributes.expense_cat#";
					if ( len(attributes.record_emp_id) )
						url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#";
					if ( len(attributes.record_emp_name) )
						url_str = "#url_str#&record_emp_name=#attributes.record_emp_name#";
				</cfscript>
				<cf_pages 
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#attributes.fuseaction#&#url_str#">
			</td>
			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>  
</cfif>
<br/>
<script type="text/javascript">
function pencere_ac_company()
{
	eval("document.search_asset.member_type").value = '';
	eval("document.search_asset.member_id").value = '';
	eval("document.search_asset.company_id").value = '';
	eval("document.search_asset.member_name").value = '';
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.member_id&field_id=search_asset.member_id&field_comp_name=search_asset.member_name&field_name=search_asset.member_name&field_comp_id=search_asset.company_id&field_type=search_asset.member_type&select_list=1,2,3','list');
}
function control(){
	     if ((document.search_asset.search_date1.value != '') && (document.search_asset.search_date2.value != '') &&
	    !date_check(search_asset.search_date1,search_asset.search_date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.search_asset.is_excel.checked==false)
			{
				document.search_asset.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.detail_income_analyse_report"
				return true;
			}
			else
       
				document.search_asset.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_income_analyse_report</cfoutput>"
	}
</script>
<cfif isdefined("attributes.form_exist") and get_expense_item_row_all.recordcount and len(attributes.graph_type) and not isdefined('attributes.ajax')>
	<table width="98%" cellpadding="2" cellspacing="1" border="0"  style="text-align:center;" class="color-border">
		<tr class="color-row">
			<td style="text-align:center;">
				<cfif isDefined("form.graph_type") and len(form.graph_type)>
					<cfset graph_type = form.graph_type>
					<cfelse>
					<cfset graph_type = "bar">
				</cfif>
				<script src="JS/Chart.min.js"></script> 
					<cfoutput query="GET_EXPENSE_ITEM_ROW_ALL" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfset item_value = ''>
						<cfif attributes.is_expence>
							<cfset item_value = '#item_value#-#left(expense,30)#'>
						</cfif>
						<cfif attributes.is_expence_item>
							<cfset item_value = '#item_value#-#left(expense_item_name,30)#'>
						</cfif>
						<cfif attributes.is_expence_member>
							<cfif MEMBER_TYPE eq 'partner'>
								<cfset item_value = left('#item_value#-#get_par_info(company_partner_id,0,-1,0)# - #item_value#-#get_par_info(company_partner_id,0,1,0)#' ,30)>
							<cfelseif MEMBER_TYPE eq 'consumer'>
								<cfset item_value = left('#item_value#-#get_cons_info(company_partner_id,0,0)# - #item_value#-#get_cons_info(company_id,2,0)#',30)>
							<cfelseif MEMBER_TYPE eq 'employee'>
								<cfset item_value = left('#item_value#-#get_emp_info(company_partner_id,0,0)#',30)>
							<cfelse>
								<cfset item_value = left('#item_value#-#get_emp_info(company_partner_id,0,0)#',30)>
							</cfif>
						</cfif> 
						<cfif attributes.is_date>
						<cfset item_value = '#item_value#-#dateformat(expense_date,dateformat_style)#'>
						</cfif>
						<cfif attributes.is_activity>
							<cfset item_value = left('#item_value#-#GET_ACTIVITY_TYPES_1.ACTIVITY_NAME[listfind(activity_type_ids,ACTIVITY_TYPE,',')]#',30)>
						</cfif>
						<cfif attributes.is_expence_cat>
							<cfset item_value = left('#item_value#-#get_expense_cat_1.expense_cat_name[listfind(expense_cat_ids,expense_category_id,',')]#',30)>
						</cfif>
						<cfif attributes.is_asset and len(asset_id_list) and len(pyschical_asset_id)>
							<cfset item_value = left('#item_value#-#get_asset.assetp[listfind(asset_id_list,pyschical_asset_id,',')]#',30)>
						</cfif>
						<cfif attributes.is_stock and len(stock_id_list) and len(stock_id_2)>
							<cfset item_value = left('#item_value#-#get_stock.product_name[listfind(stock_id_list,stock_id_2,',')]#',30)>
						</cfif>
						<cfif attributes.is_detail>
							<cfset item_value = left('#item_value#-#DETAIL#',30)>
						</cfif>
						<cfif attributes.is_project and len(project_id_list) and len(project_id)>
							<cfset item_value = left('#item_value#-#get_project.project_head[listfind(project_id_list,project_id,',')]#',30)>
						</cfif>
						<cfset 'item_#currentrow#' = "#item_value#">
						<cfset 'value_#currentrow#' = "#amount#">
					</cfoutput>
				<canvas id="myChart" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#GET_EXPENSE_ITEM_ROW_ALL.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Detaylı Analiz",
									backgroundColor: [<cfloop from="1" to="#GET_EXPENSE_ITEM_ROW_ALL.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#GET_EXPENSE_ITEM_ROW_ALL.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>
			</td>
		</tr>
	</table> 
</cfif>
