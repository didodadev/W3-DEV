<cfparam name="attributes.product_code" default="">

<cfif isdefined("attributes.stock_id")>
	<cfquery name="get_product_info" datasource="#dsn3#">
		SELECT 
			*
		FROM 
			STOCKS 
		WHERE		
			STOCK_ID = #attributes.stock_id#
	</cfquery>
	<cfif get_product_info.recordcount>
		<cfset attributes.product_code = get_product_info.stock_code_2>
	</cfif>
</cfif>

<cfform action="index.cfm?fuseaction=sevkiyat.product_control" method="post" name="service_form">
	<cfinput type="hidden" name="is_submit" value="1">
	<cf_big_list_search title="#attributes.product_code#" export="0">
	<cf_big_list_search_area>
		<cfoutput>
			<div class="row form-inline">
				<div class="form-group">
					<label>Product Control</label>
				</div>
				<div class="form-group">
					<div class="input-group x-12">
						<input type="text" name="product_code" value="#attributes.product_code#" maxlength="50" placeholder="">
						<span class="input-group-addon btnSearch icon-search" onclick="document.service_form.submit();"></span>
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button>
				</div>
			</div>
		</cfoutput>
	</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cfif isdefined("attributes.is_submit")>
	<cfquery name="get_product_info" datasource="#dsn3#">
		SELECT 
			*,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS STOCK_COUNT_IN,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS STOCK_COUNT_OUT,
			ISNULL((SELECT COUNT(WT.TASK_ID) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS ACTION_IN,
			ISNULL((SELECT COUNT(WT.TASK_ID) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS ACTION_OUT,
			ISNULL((SELECT MULTIPLIER FROM PRODUCT_UNIT WHERE ADD_UNIT = 'Pallet' AND MULTIPLIER IS NOT NULL AND MULTIPLIER <> '' AND PRODUCT_ID = STOCKS.PRODUCT_ID),1) AS PALLET_MIKTAR,
			ISNULL((SELECT SUM(CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT)) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS PALLET_COUNT_IN,
			ISNULL((SELECT SUM(CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT)) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS PALLET_COUNT_OUT,
			(SELECT C.NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = STOCKS.COMPANY_ID) AS COMPANY_NAME,
			(SELECT C.MEMBER_CODE FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = STOCKS.COMPANY_ID) AS MEMBER_CODE,
			ISNULL((SELECT COUNT(S2.PRODUCT_ID) FROM STOCKS S2 WHERE S2.COMPANY_ID = STOCKS.COMPANY_ID),1) AS COMPANY_PRODUCT_COUNT,
			(SELECT PC.PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = STOCKS.PRODUCT_CATID) AS PRODUCT_CAT,
			ISNULL((SELECT COUNT(S2.PRODUCT_ID) FROM STOCKS S2 WHERE S2.PRODUCT_CATID = STOCKS.PRODUCT_CATID),1) AS CATEGORY_PRODUCT_COUNT
		FROM 
			STOCKS 
		WHERE
			<cfif isdefined("attributes.stock_id")>
			STOCK_ID = #attributes.stock_id#
			<cfelse>
			STOCK_CODE_2 = '#attributes.product_code#'
			</cfif>
	</cfquery>
	
	<cfif not get_product_info.recordcount>
		<br><br><br><br>
		Product Code doesn't Found.
		<cfexit method="exittemplate">
	</cfif>
	
	<cfset total_stock_ = get_product_info.STOCK_COUNT_IN - get_product_info.STOCK_COUNT_OUT>
	<cfset pallet_count_ = ceiling(get_product_info.PALLET_COUNT_IN - get_product_info.PALLET_COUNT_OUT)>
	
	<div class="row myhomeBox">	
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
						<div class="status-title"><cfoutput>Pallets (#get_product_info.PALLET_MIKTAR#)</cfoutput></div>
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
						<h4 class="font-blue-sharp"> 
							<span data-counter="counterup" class="bold"><cfoutput>#get_product_info.COMPANY_NAME#</cfoutput></span>
							<small class="font-blue-sharp"></small>
						</h4>
						<small><cfoutput>#get_product_info.MEMBER_CODE#</cfoutput></small>
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
						<div class="status-title"><cfoutput>Total Product Number of Company</cfoutput></div>
						<div class="status-number">
						<cfoutput>#TLFormat(get_product_info.COMPANY_PRODUCT_COUNT,0)#</cfoutput>
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
							<span data-counter="counterup" class="bold">Total Receiving : <cfoutput>#get_product_info.ACTION_IN#</cfoutput></span>
							<small class="font-purple-soft"></small>
						</h4>
						<small>Total Shipment : <cfoutput>#get_product_info.ACTION_OUT#</cfoutput></small>
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
						<cfoutput>#TLFormat(get_product_info.ACTION_IN + get_product_info.ACTION_OUT,0)#</cfoutput>
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
							<span data-counter="counterup" class="bold">Category : <cfoutput>#get_product_info.PRODUCT_CAT#</cfoutput></span>
							<small class="font-green-sharp"></small>
						</h4>
						<small>&nbsp;</small>
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
						<div class="status-title"><cfoutput>Total Product Number of Category</cfoutput></div>
						<div class="status-number">
						<cfoutput>#TLFormat(get_product_info.CATEGORY_PRODUCT_COUNT,0)#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</cfif>