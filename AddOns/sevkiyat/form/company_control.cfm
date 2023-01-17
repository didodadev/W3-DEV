<cfparam name="attributes.company_code" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.project_id" default="">
<cfform action="index.cfm?fuseaction=sevkiyat.company_control" method="post" name="service_form">
	<cfinput type="hidden" name="is_submit" value="1">		
	<cf_big_list_search title="#attributes.company_code#" is_excel="1">
	<cf_big_list_search_area>
		<cfoutput>
			<div class="row form-inline">
				<div class="form-group">
					<label>Customer</label>
				</div>
				<div class="form-group">
					<div class="input-group x-12">
						<input type="text" name="company_code" value="#attributes.company_code#" maxlength="50" placeholder="">
						<span class="input-group-addon btnSearch icon-search" onclick="document.service_form.submit();"></span>
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button is_excel="1" is_printbuton="1">
				</div>
			</div>
		</cfoutput>
	</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cfif isdefined("attributes.is_submit")>
	<cfquery name="get_search_company" datasource="#dsn3#">
		SELECT 
			C.NICKNAME AS COMPANY_NAME,
			C.COMPANY_ID,
			NULL AS PROJECT_ID,
			'' AS PROJECT_HEAD
		FROM 
			#dsn_alias#.COMPANY C
		WHERE 
			C.COMPANY_ID IS NOT NULL
			<cfif len(attributes.project_id)>
				AND C.COMPANY_ID = 0
			</cfif>
			<cfif len(attributes.company_id)>
				AND C.COMPANY_ID = #attributes.company_id#
			<cfelse>
			AND
			(
			C.MEMBER_CODE = '#attributes.company_code#'
			OR
			C.FULLNAME LIKE '#attributes.company_code#%'
			)
			</cfif>
		UNION ALL
		SELECT 
			C.NICKNAME AS COMPANY_NAME,
			C.COMPANY_ID,
			PP.PROJECT_ID,
			PP.PROJECT_HEAD
		FROM 
			#dsn_alias#.COMPANY C,
			#dsn_alias#.PRO_PROJECTS PP
		WHERE
			C.COMPANY_ID = PP.COMPANY_ID
			<cfif len(attributes.project_id)>
				AND PP.PROJECT_ID = #attributes.project_id#
			</cfif>
			<cfif len(attributes.company_id)>
				AND C.COMPANY_ID = #attributes.company_id#
			<cfelse>
			AND
			(
				C.MEMBER_CODE = '#attributes.company_code#'
				OR
				C.FULLNAME LIKE '#attributes.company_code#%'
				OR
				PP.PROJECT_HEAD LIKE '%#attributes.company_code#%'
			)
			</cfif>
	</cfquery>
	<cfif not get_search_company.recordcount>
		<br><br><br><br>
		Company Code doesn't Found.
		<cfexit method="exittemplate">
	<cfelseif get_search_company.recordcount eq 1>
		<cfset attributes.company_id = get_search_company.company_id>
		<cfset attributes.project_id = get_search_company.project_id>
		<cfset attributes.project_head = get_search_company.project_head>
	<cfelse>
		<cf_ajax_list>
			<thead>
				<tr>
					<th width="150">Customer</th>
					<th width="150">Project</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
			<cfoutput query="get_search_company">
				<tr>
					<td><a href="index.cfm?fuseaction=sevkiyat.company_control&company_code=#get_search_company.company_name#-#get_search_company.project_head#&is_submit=1&company_id=#company_id#&project_id=#project_id#" class="tableyazi">#COMPANY_NAME#</a></td>
					<td><a href="index.cfm?fuseaction=sevkiyat.company_control&company_code=#get_search_company.company_name#-#get_search_company.project_head#&is_submit=1&company_id=#company_id#&project_id=#project_id#" class="tableyazi">#PROJECT_HEAD#</a></td>
					<td></td>
				</tr>
			</cfoutput>
			</tbdoy>
		</cf_ajax_list>
		<cfexit method="exittemplate">
	</cfif>

	<cfquery name="get_company_info" datasource="#dsn3#">
		SELECT 
			C.*,
			C.NICKNAME AS COMPANY_NAME,
			ISNULL((
				SELECT 
					COUNT(S2.PRODUCT_ID) 
				FROM 
					STOCKS S2 
				WHERE 
					S2.COMPANY_ID = C.COMPANY_ID
					<cfif len(attributes.project_id)>
						AND S2.STOCK_ID IN (SELECT WTP.STOCK_ID FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WTP.TASK_ID = WT.TASK_ID AND WT.PROJECT_ID = #attributes.project_id# AND WTP.STOCK_ID IS NOT NULL)
					</cfif>
					),1) AS COMPANY_PRODUCT_COUNT,
			ISNULL((SELECT 
					COUNT(DISTINCT S2.PRODUCT_CATID) FROM STOCKS S2 
					WHERE 						
						S2.COMPANY_ID = C.COMPANY_ID
						<cfif len(attributes.project_id)>
							AND S2.STOCK_ID IN (SELECT WTP.STOCK_ID FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WTP.TASK_ID = WT.TASK_ID AND WT.PROJECT_ID = #attributes.project_id# AND WTP.STOCK_ID IS NOT NULL)
						</cfif>
						),1) AS COMPANY_PRODUCT_CAT_COUNT,
			ISNULL((
				SELECT 
					SUM(TOTAL) 
				FROM 
					(
						SELECT 
							CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT) AS TOTAL 
						FROM 
							WAREHOUSE_TASKS_PRODUCTS WTP,
							WAREHOUSE_TASKS WT 
						WHERE 
							<cfif len(attributes.project_id)>
								WT.PROJECT_ID = #attributes.project_id# AND
							</cfif> 
							WTP.AMOUNT > 0 AND 
							WTP.TOTAL_UNIT_TYPE = 'Pallet' AND 
							WT.TASK_ID = WTP.TASK_ID AND 
							WT.COMPANY_ID = C.COMPANY_ID AND 
							WT.WAREHOUSE_IN_OUT IN (0,2)
					) AS T1
				),0) AS STOCK_COUNT_IN_PALLETS,
			ISNULL((
				SELECT 
					SUM(TOTAL) 
				FROM 
					(
						SELECT 
							CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT) AS TOTAL 
						FROM 
							WAREHOUSE_TASKS_PRODUCTS WTP,
							WAREHOUSE_TASKS WT 
						WHERE 
							<cfif len(attributes.project_id)>
								WT.PROJECT_ID = #attributes.project_id# AND
							</cfif>
							WTP.AMOUNT > 0 AND 
							WTP.TOTAL_UNIT_TYPE = 'Pallet' AND 
							WT.TASK_ID = WTP.TASK_ID AND 
							WT.COMPANY_ID = C.COMPANY_ID AND 
							WT.WAREHOUSE_IN_OUT IN (1)
					) AS T1
				),0) AS STOCK_COUNT_OUT_PALLETS,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE <cfif len(attributes.project_id)>WT.PROJECT_ID = #attributes.project_id# AND</cfif> WT.TASK_ID = WTP.TASK_ID AND WT.COMPANY_ID = C.COMPANY_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS STOCK_COUNT_IN,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE <cfif len(attributes.project_id)>WT.PROJECT_ID = #attributes.project_id# AND</cfif> WT.TASK_ID = WTP.TASK_ID AND WT.COMPANY_ID = C.COMPANY_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS STOCK_COUNT_OUT,
			ISNULL((SELECT COUNT(WT.TASK_ID) FROM WAREHOUSE_TASKS WT WHERE <cfif len(attributes.project_id)>WT.PROJECT_ID = #attributes.project_id# AND</cfif> WT.COMPANY_ID = C.COMPANY_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS ACTION_IN,
			ISNULL((SELECT COUNT(WT.TASK_ID) FROM WAREHOUSE_TASKS WT WHERE <cfif len(attributes.project_id)>WT.PROJECT_ID = #attributes.project_id# AND</cfif> WT.COMPANY_ID = C.COMPANY_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS ACTION_OUT
		FROM 
			#dsn_alias#.COMPANY C
		WHERE 
			C.COMPANY_ID = #attributes.company_id#
	</cfquery>

	<cfquery name="get_products" datasource="#dsn3#">
	SELECT
		*
	FROM
		(
		SELECT 
			*,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS STOCK_COUNT_IN,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS STOCK_COUNT_OUT,
			ISNULL((SELECT COUNT(WT.TASK_ID) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS ACTION_IN,
			ISNULL((SELECT COUNT(WT.TASK_ID) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS ACTION_OUT,
			ISNULL((SELECT SUM(CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT)) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WTP.AMOUNT > 0 AND WTP.TOTAL_UNIT_TYPE = 'Pallet' AND WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS PALLET_COUNT_IN,
			ISNULL((SELECT SUM(CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT)) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WTP.AMOUNT > 0 AND WTP.TOTAL_UNIT_TYPE = 'Pallet' AND WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS PALLET_COUNT_OUT,
			ISNULL((SELECT MULTIPLIER FROM PRODUCT_UNIT WHERE ADD_UNIT = 'Pallet' AND MULTIPLIER IS NOT NULL AND MULTIPLIER <> '' AND PRODUCT_ID = STOCKS.PRODUCT_ID),1) AS PALLET_MIKTAR,
			(SELECT C.NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = STOCKS.COMPANY_ID) AS COMPANY_NAME,
			(SELECT C.MEMBER_CODE FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = STOCKS.COMPANY_ID) AS MEMBER_CODE,
			(SELECT PC.PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = STOCKS.PRODUCT_CATID) AS PRODUCT_CAT
		FROM 
			STOCKS 
		WHERE 
			COMPANY_ID = #attributes.company_id#
			<cfif len(attributes.project_id)>
				AND STOCK_ID IN (SELECT WTP.STOCK_ID FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WTP.TASK_ID = WT.TASK_ID AND WT.PROJECT_ID = #attributes.project_id# AND WTP.STOCK_ID IS NOT NULL)
			</cfif>
		) AS T1
	ORDER BY
		PRODUCT_CAT ASC,
		PRODUCT_NAME
	</cfquery>
	
	<cfset total_stock_ = get_company_info.STOCK_COUNT_IN - get_company_info.STOCK_COUNT_OUT>
	<cfset pallet_count_ = get_company_info.STOCK_COUNT_IN_PALLETS - get_company_info.STOCK_COUNT_OUT_PALLETS>
	<div class="row myhomeBox">
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 class="font-blue-sharp"> 
							<span data-counter="counterup" class="bold"><cfoutput>#get_company_info.COMPANY_NAME# #attributes.project_head#</cfoutput></span>
							<small class="font-blue-sharp"></small>
						</h4>
						<small><cfoutput>#get_company_info.MEMBER_CODE#</cfoutput></small>
					</div>
					<div class="icon">
						<i class="icon-industry"></i>
					</div>
				</div>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;" class="progress-bar progress-bar-success blue-sharp">
						</span>
					</div>
					<div class="status">
						<div class="status-title"><cfoutput>Total Product Number of Customer</cfoutput></div>
						<div class="status-number">
						<cfoutput>#TLFormat(get_company_info.COMPANY_PRODUCT_COUNT,0)#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 class="font-red-haze"> 
							<span data-counter="counterup" class="bold"><cfoutput>#TLFormat(total_stock_,0)#&nbsp;</cfoutput></span>
							<small class="font-red-haze"></small>
						</h4>
						<small>Stock Count</small>
					</div>
					<div class="icon">
						<i class="icon-archive"></i>
					</div>
				</div>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;" class="progress-bar progress-bar-success red-haze">
						</span>
					</div>
					<div class="status">
						<div class="status-title">Pallets</div>
						<div class="status-number">
						<cfoutput>#TLFormat(pallet_count_,0)#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 class="font-purple-soft"> 
							<span data-counter="counterup" class="bold">Total Receiving : <cfoutput>#get_company_info.ACTION_IN#</cfoutput></span>
							<small class="font-purple-soft"></small>
						</h4>
						<small>Total Shipment : <cfoutput>#get_company_info.ACTION_OUT#</cfoutput></small>
					</div>
					<div class="icon">
						<i class="icon-cogs"></i>
					</div>
				</div>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;" class="progress-bar progress-bar-success purple-soft">
						</span>
					</div>
					<div class="status">
						<div class="status-title"><cfoutput>Total</cfoutput></div>
						<div class="status-number">
						<cfoutput>#TLFormat(get_company_info.ACTION_IN + get_company_info.ACTION_OUT,0)#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 class="font-green-sharp"> 
							<span data-counter="counterup" class="bold">Total Category : <cfoutput>#get_company_info.COMPANY_PRODUCT_CAT_COUNT#</cfoutput></span>
							<small class="font-green-sharp"></small>
						</h4>
						<small>Total Product : <cfoutput>#get_company_info.COMPANY_PRODUCT_COUNT#</cfoutput></small>
					</div>
					<div class="icon">
						<i class="icon-branch"></i>
					</div>
				</div>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;" class="progress-bar progress-bar-success green-sharp">
						</span>
					</div>
					<div class="status">
						<div class="status-title"><cfoutput>Total</cfoutput></div>
						<div class="status-number">
						<cfoutput>#get_company_info.COMPANY_PRODUCT_CAT_COUNT#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<cfset total_q = 0>
	<cfset total_p = 0>
	<div class="row myhomeBox">
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_medium_list_search title="Items"></cf_medium_list_search>
			<cf_medium_list id="print_data">
				<thead>
				<tr>
					<th>Company</th>
					<th>Project</th>
					<th>Category</th>
					<th>Product</th>
					<th style="text-align:right;">Piece Per Pallet</th>
					<th style="text-align:right;">Total Pieces</th>
					<th style="text-align:right;">Total Pallets</th>
				</tr>
				</thead>
				<tbody>
				<cfoutput query="get_products">
				<tr>
					<td>#COMPANY_NAME#</td>
					<td>#attributes.project_head#</td>
					<td>#PRODUCT_CAT#</td>
					<td><a href="index.cfm?fuseaction=sevkiyat.product_control&is_submit=1&stock_id=#stock_id#" class="tableyazi">#PRODUCT_NAME#</a></td>
					<td style="text-align:right;">#PALLET_MIKTAR#</td>
					<td style="text-align:right;">#STOCK_COUNT_IN - STOCK_COUNT_OUT#</td>
					<td style="text-align:right;">#PALLET_COUNT_IN - PALLET_COUNT_OUT#</td>
				</tr>
				<cfset total_q = total_q + (STOCK_COUNT_IN - STOCK_COUNT_OUT)>
				<cfset total_p = total_p + (PALLET_COUNT_IN - PALLET_COUNT_OUT)>
				</cfoutput>
				</tbody>
				<cfoutput>
				<tfoot>
				<tr>
					<td colspan="5">Totals</td>
					<td style="text-align:right;">#total_q#</td>
					<td style="text-align:right;">#total_p#</td>
				</tr>
				</cfoutput>
				</tfoot>
			</cf_medium_list>
		</div>
	</div>
</cfif>