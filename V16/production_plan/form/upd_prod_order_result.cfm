<style>
	#prod_stock_and_spec_detail_div{
		position:fixed;
		left:50%;
		top:50%;
		transform: translate(-50%, -50%);
		min-width:400px; 
		height:auto; 
		z-index:9999;
	}
	iframe body{
		background:#fff;
	}
</style>
<div id="prod_stock_and_spec_detail_div" align="center" style=""></div>
<style type="text/css">
	.detail_basket_list tbody tr.operasyon td {background-color:#FFCCCC !important;}
	.detail_basket_list tbody tr.phantom td {background-color:#FFCC99 !important;}
</style>

<cfquery name="get_xml_alternative_question" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="prod.add_product_tree"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_related_alternative_question_product">
</cfquery>
<cfquery name="get_workstation_xml" datasource="#dsn#">
	SELECT PROPERTY_VALUE FROM FUSEACTION_PROPERTY WHERE FUSEACTION_NAME = 'prod.add_prod_order' AND PROPERTY_NAME = 'is_product_station_relation' AND OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfif get_workstation_xml.recordcount and get_workstation_xml.property_value eq 1>
	<cfset is_product_station_relation = 1 >
</cfif>
<cfset is_add_alternative_product = get_xml_alternative_question.PROPERTY_VALUE>
<cf_xml_page_edit fuseact="prod.upd_prod_order_result">
<cfif is_show_product_name2 eq 1><cfset product_name2_display =""><cfelse><cfset product_name2_display='none'></cfif>
<cfif is_show_spec_id eq 1><cfset spec_display = 'text'><cfelse><cfset spec_display = 'hidden'></cfif>
<cfif is_show_spec_name eq 1><cfset spec_name_display = 'text'><cfelse><cfset spec_name_display = 'hidden'></cfif>
<cfif is_show_spec_id eq 0 and isdefined('is_show_spec_name') and is_show_spec_name eq 0><cfset spec_img_display="none"><cfelse><cfset spec_img_display=""></cfif>
<cfif is_change_amount_demontaj eq 1><cfset _readonly_ =''><cfelse><cfset _readonly_ = 'readonly'></cfif>
<cfset variable_ = '0'>
<cfset variable = '1'>
<cfset variable2 = '2'> 
<cfset variable3 = '3'>
<cfset xml_all_depo_entry = iif(isdefined("xml_location_auth_entry"),xml_location_auth_entry,DE('-1'))>
<cfset xml_all_depo_outer = iif(isdefined("xml_location_auth_outer"),xml_location_auth_outer,DE('-1'))>
<cfset xml_all_depo_prod = iif(isdefined("xml_location_auth_prod"),xml_location_auth_prod,DE('-1'))>
<cfif not isnumeric(attributes.p_order_id) or not isnumeric(attributes.pr_order_id)>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
	<cfabort>
</cfif>
<cfquery name="GET_DETAIL" datasource="#DSN3#">
	SELECT 
		PRODUCTION_ORDERS.REFERENCE_NO REFERANS,
		PRODUCTION_ORDERS.PROJECT_ID,
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.ORDER_ID,
		PRODUCTION_ORDERS.IS_DEMONTAJ,
		PRODUCTION_ORDERS.QUANTITY AS AMOUNT,
		PRODUCTION_ORDER_RESULTS.*
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS
	WHERE
		PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">  AND 
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
		PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
</cfquery>
<cfset dep_id_list =''>
<cfset loc_id_list =''>
<cfif len(GET_DETAIL.exit_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.exit_dep_id,',')>
	<cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.exit_loc_id,',')>
</cfif>
<cfif len(GET_DETAIL.production_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.production_dep_id,',')>
	<cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.production_loc_id,',')>
</cfif>
<cfif len(GET_DETAIL.enter_dep_id)>
	<cfset dep_id_list = ListAppend(dep_id_list,GET_DETAIL.enter_dep_id,',')>
	<cfset loc_id_list = ListAppend(loc_id_list,GET_DETAIL.enter_loc_id,',')>
</cfif>
<cfif len(dep_id_list)>
	<cfquery name="GET_DEP" datasource="#DSN#">
		SELECT
			DEPARTMENT_HEAD,
			DEPARTMENT_ID,
			BRANCH_ID
		FROM
			DEPARTMENT
		WHERE
			DEPARTMENT_ID IN (#dep_id_list#)
	</cfquery>
	<cfif len(loc_id_list)> 
		<cfquery name="GET_LOC" datasource="#DSN#">
			SELECT
				COMMENT,
				LOCATION_ID,
				DEPARTMENT_ID
			FROM
				STOCKS_LOCATION
			WHERE
				LOCATION_ID IN (#loc_id_list#) AND
				DEPARTMENT_ID IN (#dep_id_list#)
		</cfquery>
</cfif>
<cfset production_branch_id = ''>
<cfset exit_dep_name = ''>
<cfset production_dep_name = ''>
<cfset enter_dep_name = ''>
<cfset exit_loc_comment = ''>
<cfset production_loc_comment = ''>
<cfset enter_loc_comment = ''>
<cfloop query="GET_DEP">
	<cfif GET_DETAIL.exit_dep_id eq DEPARTMENT_ID>
		<cfset exit_dep_name = DEPARTMENT_HEAD>
	</cfif>
	<cfif GET_DETAIL.production_dep_id eq DEPARTMENT_ID>
		<cfset production_dep_name = DEPARTMENT_HEAD>
		<cfset production_branch_id = BRANCH_ID>
	</cfif>
	<cfif GET_DETAIL.enter_dep_id eq DEPARTMENT_ID>
		<cfset enter_dep_name = DEPARTMENT_HEAD>
	</cfif>
</cfloop>
<cfloop query="GET_LOC">
	<cfif GET_DETAIL.exit_loc_id eq LOCATION_ID and GET_DETAIL.exit_dep_id eq DEPARTMENT_ID>
		<cfset exit_loc_comment = COMMENT>
	</cfif>
	<cfif GET_DETAIL.production_loc_id eq LOCATION_ID and GET_DETAIL.production_dep_id eq DEPARTMENT_ID>
		<cfset production_loc_comment =  COMMENT>
	</cfif>
	<cfif GET_DETAIL.enter_loc_id eq LOCATION_ID and GET_DETAIL.enter_dep_id eq DEPARTMENT_ID>
		<cfset enter_loc_comment = COMMENT>
	</cfif>
</cfloop>
</cfif>
<cfif GET_DETAIL.recordcount>
<!--- Bu blok,üretim emri birden fazla sipariş ile ilişkili ise,yapılacak spec değişikliklerinde 
ilgili siparişlerin de spect_var_id'leri güncellenerek ilişkinin kopmamış olması sağlanıyor--->
	<cfquery name="get_orders_all" datasource="#dsn3#">
		SELECT ORDER_ROW_ID FROM PRODUCTION_ORDERS_ROW POR_ WHERE POR_.PRODUCTION_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
	</cfquery>
</cfif>
<cfif not GET_DETAIL.RECORDCOUNT>
	<cfset hata  = 10 >
	
	<cfabort>
</cfif>
<cfquery name="get_money" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_detail.finish_date)#"> GROUP BY MONEY)
</cfquery>
<cfif get_money.recordcount eq 0>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY
	</cfquery>
</cfif>
<cfquery name="get_money_rate" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_detail.finish_date)#"> GROUP BY MONEY)
</cfquery>
<cfif get_money_rate.recordcount eq 0>
	<cfset per_year = year(get_detail.finish_date)>
	<cfquery name="get_per_id" datasource="#dsn#">
		SELECT PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR = #per_year# AND OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cfquery name="get_money_rate" datasource="#dsn#">
		SELECT MONEY,RATE1,RATE2 FROM MONEY_HISTORY WHERE MONEY_HISTORY_ID IN(SELECT MAX(MONEY_HISTORY_ID) FROM MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = #get_per_id.PERIOD_ID# AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_detail.finish_date)#"> GROUP BY MONEY)
	</cfquery>
	<!---<cfquery name="get_money_rate" datasource="#dsn2#">
		SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
	</cfquery>   PY 0216 kapatıldı --->
</cfif>
<cfquery name="GET_ROW_AMOUNT" datasource="#DSN3#">
	SELECT 
		PR_ORDER_ID
	FROM 
		PRODUCTION_ORDER_RESULTS
	WHERE 
		P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
</cfquery>
<cfif GET_ROW_AMOUNT.RECORDCOUNT>
	<cfquery name="GET_SUM_AMOUNT" datasource="#DSN3#">
		SELECT 
			SUM(AMOUNT) AS SUM_AMOUNT
		FROM 
			PRODUCTION_ORDER_RESULTS_ROW
		WHERE 
			PR_ORDER_ID IN
			(
			SELECT 
				PR_ORDER_ID
			FROM 
				PRODUCTION_ORDER_RESULTS
			WHERE 
				P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
				)
			<cfif GET_DETAIL.IS_DEMONTAJ EQ 0> AND TYPE=<cfqueryparam cfsqltype="cf_sql_integer" value="#variable#"><cfelse>AND TYPE=<cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"></cfif>
	</cfquery>
</cfif>
<!---<cfset new_dsn2 = '#dsn#_#year(GET_DETAIL.FINISH_DATE)#_#session.ep.company_id#'>--->
<cfset new_dsn2 = dsn2>
<cfquery name="GET_ROW_ENTER" datasource="#DSN3#">
	<!---SELECT ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable#">  ORDER BY PR_ORDER_ROW_ID---->
	SELECT ISNULL(STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,ISNULL(LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM,ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable#">  ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_ROW_EXIT" datasource="#DSN3#">
	<!----SELECT ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,ISNULL(PURCHASE_NET_2,0) PURCHASE_NET_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"> ORDER BY PR_ORDER_ROW_ID---->
	SELECT ISNULL(STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,ISNULL(LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM,ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,ISNULL(PURCHASE_NET_2,0) PURCHASE_NET_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable2#"> ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_ROWS_REFLECTION" datasource="#DSN3#">
	SELECT 
    	ISNULL(SUM(STATION_REFLECTION_COST_SYSTEM),0) AS TOTAL_STATION_REFLECTION_COST_SYSTEM,
        ISNULL(SUM(LABOR_COST_SYSTEM),0) AS TOTAL_LABOR_COST_SYSTEM 
    FROM 
    	PRODUCTION_ORDER_RESULTS_ROW 
    WHERE 
		PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> 
		AND 
		TYPE IN (2,3)
	 </cfquery>
<cfquery name="GET_ROW_OUTAGE" datasource="#DSN3#">
	<!---SELECT ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,ISNULL(PURCHASE_NET_2,0) PURCHASE_NET_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable3#">  ORDER BY PR_ORDER_ROW_ID--->
	SELECT ISNULL(STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,ISNULL(LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM,ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,ISNULL(PURCHASE_NET_2,0) PURCHASE_NET_2,* FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.pr_order_id#"> AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#variable3#">  ORDER BY PR_ORDER_ROW_ID
</cfquery>
<cfquery name="GET_STOK_FIS" datasource="#new_dsn2#">
	SELECT SHIP_NUMBER,SHIP_ID,SHIP_TYPE FROM SHIP WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
</cfquery>
<cfif len(get_detail.order_id)>
	<cfquery name="GET_ORDER_NUMBER" datasource="#DSN3#">
		SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.order_id#">
	</cfquery>
</cfif>
<cfset var119 = '119'>
<cfset var110 = '110'>
<cfset var111 = '111'>
<cfset var112 = '112'>
<cfset var113 = '113'>
<cfset GET_CAT.recordcount = 0>
<cfset GET_FIS.recordcount = 0>
<cfset GET_FIS_SARF.recordcount = 0>
<cfset GET_FIS_AMBAR.recordcount = 0>
<cfset GET_FIS_FIRE.recordcount = 0>
<cfset GET_FIS2.recordcount = 0>
<cfquery name="GET_CAT" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE =<cfif GET_DETAIL.IS_DEMONTAJ eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#var119#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#var110#"></cfif><!--- uretimden giris fisi demontej veya uretimden giris fisi --->
</cfquery>
<cfif GET_CAT.recordcount>
	<cfquery name="GET_FIS" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 110
	</cfquery>
	<cfquery name="GET_FIS2" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 119
	</cfquery>
</cfif>
<cfquery name="GET_CAT_SARF" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var111#">
</cfquery>
<cfif GET_CAT_SARF.recordcount>
	<cfquery name="GET_FIS_SARF" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 111
	</cfquery>
</cfif>
<cfquery name="GET_CAT_AMBAR" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var113#">
</cfquery>
<cfif GET_CAT_AMBAR.recordcount>
	<cfquery name="GET_FIS_AMBAR" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 113
	</cfquery>
</cfif>
<cfquery name="GET_CAT_FIRE" datasource="#DSN3#">
	SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#var112#">
</cfquery>
<cfif GET_CAT_FIRE.recordcount>
	<cfquery name="GET_FIS_FIRE" datasource="#new_dsn2#">
		SELECT FIS_NUMBER,FIS_TYPE,FIS_ID,FIS_DATE FROM STOCK_FIS WHERE PROD_ORDER_RESULT_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND FIS_TYPE = 112
	</cfquery>
</cfif>
<cfset Product_id_List = ''>
<cfset Product_cat_List = ''>
<cfif get_row_enter.recordcount>
	<cfoutput query="GET_ROW_ENTER">
		<cfif isdefined('product_id') and len(product_id) and not listfind(Product_id_List,product_id)>
			<cfset Product_id_List=listappend(Product_id_List,product_id)>
		</cfif>
	</cfoutput>
	<cfif len(Product_id_List)>
		<cfset Product_id_List=listsort(Product_id_List,"numeric","ASC",",")>
		<cfquery name="get_product_cat" datasource="#dsn1#">
			SELECT PRODUCT_CATID,PRODUCT_ID FROM PRODUCT WHERE PRODUCT_ID IN (#Product_id_List#) ORDER BY PRODUCT_ID
		</cfquery>
		<cfset Product_id_List = listsort(listdeleteduplicates(valuelist(get_product_cat.PRODUCT_ID,',')),'numeric','ASC',',')>
		<cfset Product_cat_List = listsort(listdeleteduplicates(valuelist(get_product_cat.PRODUCT_CATID,',')),'numeric','ASC',',')>
	</cfif>
</cfif>

<cf_catalystHeader>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_prod_order_result_act">
	<cfif GET_DETAIL.IS_DEMONTAJ eq 0><!--- Ürünün kaç tane alt ürünü olduğunu gösteriyor. --->
		<input type="hidden" name="is_demontaj" id="is_demontaj" value="0">
		<input type="hidden" name="sarf_recordcount" id="sarf_recordcount" value="<cfoutput>#GET_ROW_EXIT.RECORDCOUNT#</cfoutput>">
	<cfelse>
		<input type="hidden" name="is_demontaj" id="is_demontaj" value="1">
		<input type="hidden" name="sarf_recordcount" id="sarf_recordcount" value="<cfoutput>#GET_ROW_ENTER.RECORDCOUNT#</cfoutput>">
	</cfif>
	<input type="hidden" name="is_changed_spec_main" id="is_changed_spec_main" value="<cfoutput>#is_changed_spec_main#</cfoutput>">
	<input type="hidden" name="fire_recordcount" id="fire_recordcount" value="<cfoutput>#GET_ROW_OUTAGE.RECORDCOUNT#</cfoutput>">
	<input type="hidden" name="x_is_add_operation_result" id="x_is_add_operation_result" value="<cfif isdefined("x_is_add_operation_result")><cfoutput>#x_is_add_operation_result#</cfoutput><cfelse>0</cfif>"><!--- Stok fişi oluşturma sayfasında kullanılıyor xl parametresi --->
	<input type="hidden" name="x_lot_no_in_stocks_row" id="x_lot_no_in_stocks_row" value="<cfif isdefined("x_lot_no_in_stocks_row")><cfoutput>#x_lot_no_in_stocks_row#</cfoutput><cfelse>0</cfif>"><!--- Stok fişi oluşturma sayfasında kullanılıyor xl parametresi --->
	<input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.p_order_id#</cfoutput>">
	<input type="hidden" name="pr_order_id" id="pr_order_id" value="<cfoutput>#get_Detail.pr_order_id#</cfoutput>">
	<input type="hidden" name="process_type_111" id="process_type_111" value="<cfoutput>#process_type_111#</cfoutput>">
	<input type="hidden" name="process_type_112" id="process_type_112" value="<cfoutput>#process_type_112#</cfoutput>">
	<input type="hidden" name="process_type_81" id="process_type_81" value="<cfoutput>#process_type_81#</cfoutput>">
	<input type="hidden" name="process_type_110" id="process_type_110" value="<cfoutput>#process_type_110#</cfoutput>">
	<input type="hidden" name="process_type_119" id="process_type_119" value="<cfoutput>#process_type_119#</cfoutput>">
	<input type="hidden" name="del_pr_order_id" id="del_pr_order_id" value="0">
	<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
	<input type="hidden" id="today_date_" name="today_date_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
	<input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
	<cfoutput query="get_money">
		<input type="hidden" name="hidden_rd_money_#CURRENTROW#" id="hidden_rd_money_#CURRENTROW#" value="#money#">
		<input type="hidden" name="txt_rate1_#CURRENTROW#" id="txt_rate1_#CURRENTROW#" value="#tlformat(rate1)#">
		<input type="hidden" name="txt_rate2_#CURRENTROW#" id="txt_rate2_#CURRENTROW#" value="#tlformat(rate2,session.ep.our_company_info.rate_round_num)#">
	</cfoutput>
	<cf_box>

				<cf_box_elements>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36760.İşlem Kategorisi'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="135" process_cat='#get_detail.process_id#'>
							</div>
						</div>
						<div class="form-group" id="item-production_order_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36346.Üretim Emir No'> *</label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="production_order_no" id="production_order_no" style="width:135px;" readonly maxlength="25" value="<cfoutput>#get_detail.production_order_no#</cfoutput>">
							</div>
						</div>
						<div class="form-group" id="item-order_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58211.Siparis No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="order_no" id="order_no" value="<cfoutput>#get_detail.order_no#</cfoutput>" readonly maxlength="25" style="width:135px;">
								<input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined("get_orders_all.ORDER_ROW_ID")><cfoutput>#valuelist(get_orders_all.ORDER_ROW_ID,',')#</cfoutput></cfif>">
							</div>
						</div>
						<div class="form-group" id="item-expense_employee">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36765.İşlemi Yapan'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(get_detail.position_id)>
										<input type="hidden" name="expense_employee_id" id="expense_employee_id" value="<cfoutput>#get_detail.position_id#</cfoutput>">
										<input type="text" name="expense_employee" id="expense_employee" value="<cfoutput>#get_emp_info(get_detail.position_id,0,0)#</cfoutput>" style="width:135px;">
									<cfelse>
										<input type="hidden" name="expense_employee_id" id="expense_employee_id" value="">
										<input type="text" name="expense_employee" id="expense_employee" value="" style="width:135px;">
									</cfif>
									<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.expense_employee_id&field_name=form_basket.expense_employee&select_list=1','list');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-start_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> *</label>
							<cfoutput>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="start_date" id="start_date" value="#dateformat(get_detail.start_date,dateformat_style)#" validate="#validate_style#" readonly required="Yes" message="#message#" style="width:65px;">
										
										
											<cfif len(get_detail.start_date)>
												<cfset hour_detail = hour(get_detail.start_date)>
												<cfset minute_detail = minute(get_detail.start_date)>
											<cfelse>
												<cfset hour_detail = 0>
												<cfset minute_detail = 0>
											</cfif>
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date" control_date="#dateformat(get_detail.start_date,dateformat_style)#"></span>
									</div>
								</div>
								<div class="col col-2 col-xs-12">
									<cf_wrkTimeFormat name="start_h" value="#hour_detail#">
								</div>
								<div class="col col-2 col-xs-12">
									<select name="start_m" id="start_m">
										<cfloop from="0" to="59" index="i">
											<option value="#i#" <cfif minute_detail eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
										</cfloop>
									</select>
								</div>
							</cfoutput>
						</div>
						<div class="form-group" id="item-finish_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'> *</label>
							<cfoutput>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
										<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(get_detail.finish_date,dateformat_style)#" readonly required="Yes" message="#message#" validate="#validate_style#" style="width:65px;" onBlur="change_money_info('form_basket','finish_date');">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date" call_function="change_money_info" control_date="#dateformat(get_detail.finish_date,dateformat_style)#"></span>
									</div>
								</div>
								<div class="col col-2 col-xs-12">
									<cfif len(get_detail.finish_date)>
										<cfset value_finish_h = hour(get_detail.finish_date)>
										<cfset value_finish_m = minute(get_detail.finish_date)>
									<cfelse>
										<cfset value_finish_h = 0>
										<cfset value_finish_m = 0>
									</cfif>
									<cf_wrkTimeFormat name="finish_h" value="#value_finish_h#">
								</div>
								<div class="col col-2 col-xs-12">
									<select name="finish_m" id="finish_m">
										<cfloop from="0" to="60" index="i">
											<option value="#i#" <cfif value_finish_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
										</cfloop>
									</select>
								</div>
							</cfoutput>
						</div>
						<div class="form-group" id="item-production_result_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36762.Sonuç No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="production_result_no" id="production_result_no" value="<cfoutput>#get_detail.result_no#</cfoutput>" readonly maxlength="25" style="width:167px;">
							</div>
						</div>
						<div class="form-group" id="item-project_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="project_id" id="project_id" value="<cfif len(get_detail.PROJECT_ID)><cfoutput>#get_detail.PROJECT_ID#</cfoutput></cfif>">
								<input type="text" name="project_name" id="project_name" value="<cfif len(get_detail.PROJECT_ID)><cfoutput>#get_project_name(get_detail.PROJECT_ID)#</cfoutput></cfif>" readonly style="width:167px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-process">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process is_upd='0' select_value='#get_detail.prod_ord_result_stage#' process_cat_width='135' is_detail=','>
							</div>
						</div>
						<div class="form-group" id="item-lot_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36698.Lot No'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="old_lot_no" id="old_lot_no" value="<cfoutput>#get_detail.lot_no#</cfoutput>">
								<input type="text" name="lot_no" id="lot_no" maxlength="25" value="<cfoutput>#get_detail.lot_no#</cfoutput>" onKeyup="lotno_control(1,1);" <cfif isdefined("x_lot_no") and x_lot_no eq 0>readonly</cfif> style="width:135px;">
							</div>
						</div>
						<div class="form-group" id="item-expiration_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="expiration_date" value="#dateformat(get_detail.expiration_date,dateformat_style)#" readonly validate="#validate_style#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="expiration_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-station_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58834.İstasyon'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfif len(get_detail.station_id)>
										<cfquery name="GET_STATION" datasource="#dsn3#">
											SELECT STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.station_id#">
										</cfquery>
										<input type="hidden" name="station_id" id="station_id" value="<cfoutput>#get_detail.station_id#</cfoutput>">
										<input type="text" name="station_name" id="station_name" <cfif is_change_station eq 0>readonly</cfif> value="<cfoutput>#get_station.station_name#</cfoutput>" style="width:135px;" <cfif is_change_station eq 1>onFocus="AutoComplete_Create('station_name','STATION_NAME','STATION_NAME','get_station','','STATION_ID','station_id','','3','135','send_dep_loc()');"</cfif> autocomplete="off">
										<cfif is_change_station eq 1>
											<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="open_station()"></span>
										</cfif>
										<cfelse>
											<input type="hidden" name="station_id" id="station_id"  value="">
											<input type="text" name="station_name" id="station_name" style="width:135px;" onfocus="AutoComplete_Create('station_name','STATION_NAME','STATION_NAME','get_station','','STATION_ID','station_id','','3','135','send_dep_loc()');" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="open_station()"></span>
										</cfif>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-ref_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="ref_no" id="ref_no" value="<cfoutput>#get_detail.REFERANS#</cfoutput>" style="width:135px;">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-location">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36761.Sarf Depo'></label>
							<div class="col col-8 col-xs-12">
								<cfif len(get_detail.exit_dep_id) and len(get_detail.exit_loc_id)>
									<cf_wrkdepartmentlocation
										returninputvalue="exit_location_id,exit_department,exit_department_id,branch_id"
										returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldname="exit_department"
										fieldid="exit_location_id"
										department_fldid="exit_department_id"
										department_id="#get_detail.exit_dep_id#"
										xml_all_depo = "#xml_all_depo_outer#"
										location_id="#get_detail.exit_loc_id#"
										location_name="#exit_dep_name#- #exit_loc_comment#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										line_info = 1
										width="135">
								<cfelse>
										<cf_wrkdepartmentlocation
										returninputvalue="exit_location_id,exit_department,exit_department_id,branch_id"
										returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
										fieldname="exit_department"
										fieldid="exit_location_id"
										xml_all_depo = "#xml_all_depo_outer#"
										department_fldid="exit_department_id"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										line_info = 1
										width="135">
						</cfif>
						<cfif GET_DETAIL.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
							<cfset location_type =3>
						<cfelse>
							<cfset location_type =1>
						</cfif>
							</div>
						</div>
						<div class="form-group" id="item-department">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36763.Üretim Depo'></label>
							<div class="col col-8 col-xs-12">
									<cfif isdefined("get_detail.production_dep_id") and len(get_detail.production_dep_id)>
								<cfquery name="GET_PRODUCTION_DEP" datasource="#DSN#">
									SELECT
										DEPARTMENT_HEAD,
										BRANCH_ID
									FROM 
										DEPARTMENT
									WHERE
										DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_dep_id#">
								</cfquery>
								<cfquery name="GET_PRODUCTION_LOC" datasource="#DSN#">
									SELECT
										COMMENT
									FROM
										STOCKS_LOCATION
									WHERE
										LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_loc_id#"> AND
										DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_detail.production_dep_id#">
								</cfquery>
								<cf_wrkdepartmentlocation
									returninputvalue="production_location_id,production_department,production_department_id,production_branch_id"
									returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldname="production_department"
									fieldid="production_location_id"
									department_fldid="production_department_id"
									branch_fldid="production_branch_id"
									branch_id="#get_production_dep.branch_id#"
									department_id="#get_detail.production_dep_id#"
									location_id="#get_detail.production_loc_id#"
									xml_all_depo = "#xml_all_depo_prod#"
									location_name="#get_production_dep.department_head# - #get_production_loc.comment#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 2
									width="135">
							<cfelse>
								<cf_wrkdepartmentlocation
									returninputvalue="production_location_id,production_department,production_department_id,production_branch_id"
									returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldname="production_department"
									fieldid="production_location_id"
									department_fldid="production_department_id"
									branch_fldid="production_branch_id"
									xml_all_depo = "#xml_all_depo_prod#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									line_info = 2
									width="135">
							</cfif>
							<cfif GET_DETAIL.is_demontaj eq 1><!--- TolgaS 20060912 demontaj isleminde depo seceneleri ters olmali --->
								<cfset location_type =1>
							<cfelse>
								<cfset location_type =3>
							</cfif>
							</div>
						</div>
						<div class="form-group" id="item-enter_loc">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36764.Sevkiyat Depo'></label>
							<div class="col col-8 col-xs-12">
								<cfif len(get_detail.enter_dep_id) and len(get_detail.enter_loc_id)>
							<cf_wrkdepartmentlocation
								returninputvalue="enter_location_id,enter_department,enter_department_id,branch_id"
								returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldname="enter_department"
								fieldid="enter_location_id"
								department_fldid="enter_department_id"
								department_id="#get_detail.enter_dep_id#"
								location_id="#get_detail.enter_loc_id#"
								xml_all_depo = "#xml_all_depo_entry#"
								location_name="#enter_dep_name# - #enter_loc_comment#"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 3
								user_location = 0
								width="135">
						<cfelse>
							<cf_wrkdepartmentlocation
								returninputvalue="enter_location_id,enter_department,enter_department_id,branch_id"
								returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldname="enter_department"
								fieldid="enter_location_id"
								xml_all_depo = "#xml_all_depo_entry#"
								department_fldid="enter_department_id"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								line_info = 3
								user_location = 0
								width="135">
						</cfif>
							</div>
						</div>
						<div class="form-group" id="item-reference_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">
								<textarea name="reference_no" id="reference_no" maxlength="500" style="width:167px;height:73px;" onkeydown="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onkeyup="counter(this.form.reference_no,this.form.detailLen,500);return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#get_detail.reference_no#</cfoutput></textarea>
								<!--- <input type="text" name="detailLen" id="detailLen" size="1" value="500" readonly /> --->
							</div>
						</div>
					</div>
					<div class="col col-12">
						<cfif get_fis.recordcount or get_fis_sarf.recordcount or get_fis_fire.recordcount>
							<cfif get_fis.recordcount>
								<label><cf_get_lang dictionary_id='36778.Üretimde Çıkış Fişi'>:
									<cfoutput>
										<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#get_fis.FIS_ID#"  target="_blank">#get_fis.fis_number#</a>
									</cfoutput>
								</label>
							</cfif>
							<cfif get_fis2.recordcount>
								<label>
									<cf_get_lang dictionary_id='45267.Üretimden Giriş Fişi'>:
									<cfoutput>
										<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#get_fis2.FIS_ID#"  target="_blank">#get_fis2.fis_number#</a>
									</cfoutput>
								</label>
							</cfif>
							<cfif get_fis_sarf.recordcount>
								<label>
									<cf_get_lang dictionary_id='29628.Sarf Fişi'>:
									<cfoutput>
										<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#get_fis_sarf.FIS_ID#"  target="_blank">#get_fis_sarf.fis_number#</a>
									</cfoutput>
								</label>
							</cfif>
							<cfif get_fis_ambar.recordcount or GET_STOK_FIS.recordcount>
								<cfquery name="get_ship_kontrol" datasource="#dsn2#">
									SELECT ISNULL(IS_DELIVERED,0) IS_DELIVERED FROM SHIP WHERE SHIP_ID = #GET_STOK_FIS.SHIP_ID#
								</cfquery>
								<label>
									<cf_get_lang dictionary_id='36780.Dep Arası İrsaliye'>
									<cf_get_lang dictionary_id='36784.Ambar Fisi (Depolar Arasi)'> :
									<cfoutput>
										<a href="#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#GET_STOK_FIS.SHIP_ID#"  target="_blank">#get_fis_ambar.fis_number# #GET_STOK_FIS.ship_number# </a>
									</cfoutput>
								</label>
							</cfif>
							<cfif GET_FIS_FIRE.RECORDCOUNT>
								<label>
									<cf_get_lang dictionary_id='29629.Fire Fişi'>:
									<cfoutput>
										<a href="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#GET_FIS_FIRE.FIS_ID#"  target="_blank">#GET_FIS_FIRE.fis_number#</a>
									</cfoutput>
								</label>
							</cfif>
						</cfif>
						<cfif get_fis.recordcount or get_fis_sarf.recordcount><div class="form-group pull-right"><label><input type="checkbox" name="is_delstock" id="is_delstock" value="1"><cf_get_lang dictionary_id='36777.Stok Fişleri Silinsin'></label></div></cfif>
					</div>
				</cf_box_elements>
				<div class="ui-form-list-btn">
					<div class="col col-6 col-xs-12">
						<cf_record_info query_name='get_detail'>
					</div>
					<div class="col col-6 col-xs-12">
						<cfif not (get_fis.recordcount or get_fis2.recordcount) and len(get_detail.exit_dep_id) and len(get_detail.production_dep_id)><!--- Fis olusmamıs,sarf ve üretim depo dolu ise --->
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='36881.Stok Fişi Oluştur'></cfsavecontent>
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='36882.Stok Fişi Oluşturmak İstediğinizden Emin misiniz'></cfsavecontent>
							<cfoutput>
								<cf_workcube_buttons is_upd='0' is_cancel="0" is_delete='0' insert_info="#message#" add_function='kontrol_et()' insert_alert="#message2#"> 
								<script language="javascript">
									function _sesion_control_(){
										var user_control = wrk_safe_query("prdp_user_control","dsn");
										if(user_control.recordcount == undefined){
											alert('<cf_get_lang dictionary_id="36982.Kullanıcı Girişi Yapınız">!');
											return false;
										}
										else
											return true;
									}
								</script>
							</cfoutput>
						</cfif>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57463.Sil'></cfsavecontent>
						<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='57533.Silmek İstediğinizden Emin misiniz'></cfsavecontent>
						<cf_workcube_buttons is_upd='1' is_delete='1' add_function='kontrol()' del_function="kontrol2()">
						
					</div>
				</div>
			<cfsavecontent variable='title'><cf_get_lang dictionary_id='29651.Üretim Sonucu'></cfsavecontent>
			<cf_seperator header="#title#" id="table1_sep">
			<div id="table1_sep">
				<cf_grid_list id="table1" name="id1">
					<cfif x_pro_add_barkod_and_seri_no eq 1>
						<div id="add_prod1" class="col-6"></div>
					</cfif>
					<thead>
						<tr>
							<th style="min-width:20px;"><input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_row_enter.recordcount#</cfoutput>"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#&p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>&type=1&project_head=<cfoutput><cfif len(GET_DETAIL.PROJECT_ID)>#get_project_name(GET_DETAIL.PROJECT_ID)#</cfif></cfoutput>&record_num=' + form_basket.record_num.value,'list')"><i class="fa fa-plus" id="add_row_image"></i></a></th>
							<th style="min-width:20px;text-align:center;"><i class="fa fa-print"></i></th>
							<th style="min-width:125px;"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<cfif x_is_barkod_col eq 1><th style="min-width:95px;"><cf_get_lang dictionary_id='57633.Barkod'></th></cfif>
							<th style="min-width:256px;"><cf_get_lang dictionary_id='57452.Stok'></th>
							<th style="min-width:265px; display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang dictionary_id='57647.spect'></th>
							<cfif xml_work eq 1><th style="min-width:150px;"><cf_get_lang dictionary_id='58445.İş'></th></cfif>
							<th style="min-width:90px;"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<cfif x_is_fire_product eq 1>
								<th style="min-width:65px;"><cf_get_lang dictionary_id='29471.Fire'></th>
							</cfif>
							<th style="min-width:65px;"><cf_get_lang dictionary_id='57636.Birim'></th>
							<th style="min-width:65px;"><cf_get_lang dictionary_id='29784.Ağırlık'>(KG)</th>
							<cfif x_is_show_abh eq 1>
								<th style="min-width:65px;"><cf_get_lang dictionary_id="48152.En">(cm)</th>
								<th style="min-width:65px;"><cf_get_lang dictionary_id="55735.Boy">(cm)</th>
								<th style="min-width:65px;"><cf_get_lang dictionary_id="57696.Yükseklik">(cm)</th>
							</cfif>
							<cfif xml_specific_weight eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="64080.Özgül Ağırlık"></th>
								</cfif>
							<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
								<th style="min-width:130px; text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'></th>
								<th style="min-width:130px; text-align:right;"><cf_get_lang dictionary_id = "57175.Ek maliyet"></th>
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
									<th style="min-width:22px; text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'></th>
								</cfif>
								<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
									<th id="labor_cost" style="min-width:95x; text-align:right;"><cf_get_lang dictionary_id="47560.İşçilik Maliyeti"></th>
									<th id="labor_cost" style="min-width:95x; text-align:right;"><cf_get_lang dictionary_id='60596.İşçilik Toplam Maliyeti'></th>
								</cfif>
								<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
									<th id="refl_cost" style="min-width:95px; text-align:right;"><cf_get_lang dictionary_id='36983.Yansıyan Maliyet'></th>
									<th id="refl_cost" style="min-width:95px; text-align:right;"><cf_get_lang dictionary_id='60597.Yansıyan Toplam Maliyet'></th>
								</cfif>
								<th style="min-width:55px;"><cf_get_lang dictionary_id='57489.Para Br'></th>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
									<th style="min-width:130px; text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<th width="100" style="text-align:right;"><cf_get_lang dictionary_id = "57175.Ek maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<th id="labor_cost" style="min-width:22px; text-align:right;"><cf_get_lang dictionary_id="47560.İşçilik Maliyeti"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
										<th id="labor_cost" style="min-width:22px; text-align:right;"><cf_get_lang dictionary_id='60596.İşçilik Toplam Maliyeti'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>													
									<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<th id="refl_cost" style="min-width:95px; text-align:right;"><cf_get_lang dictionary_id='36983.Yansıyan Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
										<th id="refl_cost" style="min-width:95px; text-align:right;"><cf_get_lang dictionary_id='60597.Yansıyan Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<th style="min-width:130px; text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>
								</cfif>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
									<th style="min-width:55px;"><cf_get_lang dictionary_id='57489.Para Br'></th>
								</cfif>
							</cfif>
							<cfif is_show_two_units eq 1>
								<th style="min-width:75px;">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
								<th style="min-width:40px;">2.<cf_get_lang dictionary_id='57636.Birim'></th>
							</cfif>
							<cfif is_show_product_name2 eq 1>
								<th style="min-width:75px;">2.<cf_get_lang dictionary_id='57629.Açıklama'></th>
							</cfif>
							<th width="20" class="header_icn_none text-center"><i class="fa fa-qrcode" title="<cf_get_lang dictionary_id='57717.Garanti'>-<cf_get_lang dictionary_id='57718.Seri Nolar'>"></i></th>
							<th width="20" class="header_icn_none text-center"><i class="fa fa-check-square" title="<cf_get_lang dictionary_id='36650.Kalite Kontrol'>"></i></th>
							<th width="20" class="header_icn_none text-center"><i class="fa fa-barcode" title="<cf_get_lang dictionary_id='60225.Hızlı Seri Giriş'>"></i></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="get_row_enter">
							<cfquery name="GET_PRODUCT" datasource="#dsn1#">
								SELECT 
									PRODUCT.PRODUCT_NAME,
									STOCKS.BARCOD,
									STOCKS.PRODUCT_UNIT_ID,
									PRODUCT_UNIT.ADD_UNIT,
									PRODUCT_UNIT.MAIN_UNIT,
									PRODUCT_UNIT.DIMENTION,
									STOCKS.PROPERTY,
									STOCKS.STOCK_CODE,
									PRODUCT.IS_SERIAL_NO
								FROM 
									PRODUCT,
									STOCKS,
									PRODUCT_UNIT
								WHERE 
									STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
									STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
									PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
									PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
									PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
							</cfquery>
							<cfif GET_DETAIL.IS_DEMONTAJ eq 0 and isdefined('x_quality_control') and x_quality_control eq 1>
								<cfquery name="get_prod_quality_info" datasource="#dsn3#">
									SELECT IS_QUALITY FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
								</cfquery>
								<cfif get_prod_quality_info.is_quality eq 1>
									<cfquery name="get_quality" datasource="#dsn3#">
										SELECT TOP 1
											QS.SUCCESS,
											QS.IS_SUCCESS_TYPE,
											ORQ.CONTROL_AMOUNT,
											ORQ.IS_ALL_AMOUNT
										FROM 
											ORDER_RESULT_QUALITY ORQ,
											QUALITY_SUCCESS QS
										WHERE 
											ORQ.PROCESS_ID = #attributes.p_order_id# AND
											ORQ.SHIP_WRK_ROW_ID = '#WRK_ROW_ID#' AND
											ORQ.PROCESS_CAT = 171 AND
											ORQ.STAGE IN (SELECT PTR.PROCESS_ROW_ID FROM #dsn_alias#.PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID = ORQ.STAGE AND PTR.IS_CONFIRM = 1) AND <!--- Asamasinin Onay Secili Olmasi Lazim --->
											ORQ.SUCCESS_ID = QS.SUCCESS_ID
										ORDER BY
											ISNULL(ORQ.UPDATE_DATE,ORQ.RECORD_DATE) DESC
									</cfquery>
									<cfif get_quality.recordcount>
										<!--- 1 Kabul, 0 Red, 2 Yeniden Muayene --->
										<input type="hidden" name="is_success_type_#pr_order_id#" id="is_success_type_#pr_order_id#" value="#get_quality.IS_SUCCESS_TYPE#" />
										<input type="hidden" name="is_all_amount_#pr_order_id#" id="is_all_amount_#pr_order_id#" value="#get_quality.IS_ALL_AMOUNT#" />
									<cfelse>
										<input type="hidden" name="is_success_type_#pr_order_id#" id="is_success_type_#pr_order_id#" value="" />
										<input type="hidden" name="is_all_amount_#pr_order_id#" id="is_all_amount_#pr_order_id#" value="" />
									</cfif>
								</cfif>
							</cfif>
							<!--- Ana Ürün --->
							<tr id="frm_row#currentrow#" <cfif TREE_TYPE is 'P'>class="phantom" title="Phantom Ağaçtan Ürünler"<cfelseif TREE_TYPE is 'O'>class="operasyon" title="Operasyondan Gelen Ürünler"</cfif>>
								<td>
									<input type="hidden" name="wrk_row_id_#currentrow#" id="wrk_row_id_#currentrow#" value="#get_row_enter.wrk_row_id#">
									<input type="hidden" name="wrk_row_relation_id_#currentrow#" id="wrk_row_relation_id_#currentrow#" value="#get_row_enter.wrk_row_relation_id#">
									<input type="hidden" name="is_free_amount_#currentrow#" id="is_free_amount_#currentrow#" value="#get_row_enter.is_free_amount#">
									<input type="hidden" name="tree_type_#currentrow#" id="tree_type_#currentrow#" value="#TREE_TYPE#">
									<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
									<input type="hidden" name="cost_id#currentrow#" id="cost_id#currentrow#" value="#COST_ID#">
									<input type="hidden" name="kdv_amount#currentrow#" id="kdv_amount#currentrow#" value="#KDV_PRICE#">
									<input type="hidden" name="cost_price_system#currentrow#" id="cost_price_system#currentrow#" value="#PURCHASE_NET_SYSTEM#">
									<input type="hidden" name="purchase_extra_cost_system#currentrow#" id="purchase_extra_cost_system#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
									<input type="hidden" name="purchase_extra_cost#currentrow#" id="purchase_extra_cost#currentrow#" value="#PURCHASE_EXTRA_COST#">
									<input type="hidden" name="money_system#currentrow#" id="money_system#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
									<a onclick="sil('#currentrow#');"><i  class="fa fa-minus"  title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
								</td>
								<td style="text-align:center;">
									<div class="form-group">
										<a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.pr_order_id#&iid=#attributes.p_order_id#&action=#attributes.fuseaction#&stock_id=#stock_id#','woc')"><i class="fa fa-print"></i></a>
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="text" name="stock_code#currentrow#" id="stock_code#currentrow#" value="#get_product.stock_code#" readonly style="width:120px;">
									</div>
								</td>
								<cfif x_is_barkod_col eq 1>
									<td>
										<div class="form-group">
											<input type="text" name="barcode#currentrow#" id="barcode#currentrow#" value="#get_product.barcod#" readonly style="width:90px;">
										</div>
									</td>
								</cfif>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" value="#product_id#" name="product_id#currentrow#"  id="product_id#currentrow#"/>
											<input type="hidden" value="#stock_id#" name="stock_id#currentrow#" id="stock_id#currentrow#">
											<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#get_product.product_name# #get_product.property#" readonly>
											<span class="input-group-addon" onclick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang dictionary_id ='36369.Stok Detaylar'>"></span>
										</div>
									</div>
								</td>
								<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
								<td style="display:#spec_img_display#;" nowrap>
									<div class="form-group">
										<cfif len(spect_id) or len(SPEC_MAIN_ID)>
											<cfquery name="GET_SPECT" datasource="#dsn3#">
												<cfif len(spect_id)>
													SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_id#">
												<cfelse>
													SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SPEC_MAIN_ID#">
												</cfif>
											</cfquery>
											<input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="#spect_id#">
											<div class="col col-3">
												<input type="#Evaluate('spec_display')#" value="#SPEC_MAIN_ID#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" readonly style="width:40px;">
											</div>
											<div class="col col-3">
												<input type="#Evaluate('spec_display')#" name="spect_id#currentrow#" id="spect_id#currentrow#"value="#spect_id#" readonly style="width:40px;">
											</div>
											<div class="col col-6">
												<div class="input-group">
													<input type="#Evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
													<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_spect('#currentrow#');"></span>
													<span class="input-group-addon" onclick="pencere_ac_spect('#currentrow#',4);"><img src="/images/plus_thin_p.gif" align="absbottom" border="0" title="<cf_get_lang dictionary_id='36794.Spect Detay'>"></span>
												</div>
											</div>
										<cfelse>
											<input type="hidden" name="spect_id_#currentrow#" id="spect_id_#currentrow#" value="">
											<div class="col col-3">
												<input type="#Evaluate('spec_display')#" name="spec_main_id#currentrow#" id="spec_main_id#currentrow#" value="" readonly style="width:40px;">
											</div>
											<div class="col col-3">
												<input type="#Evaluate('spec_display')#" name="spect_id#currentrow#" id="spect_id#currentrow#" value="" readonly style="width:40px;">
											</div>
											<div class="col col-6">
												<div class="input-group">
													<input type="#Evaluate('spec_name_display')#" name="spect_name#currentrow#" id="spect_name#currentrow#" value="" readonly style="width:150px;">
													<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_spect('#currentrow#');"></span>
													<span class="input-group-addon" onclick="pencere_ac_spect('#currentrow#',4);"><img src="/images/plus_thin_p.gif" align="absbottom" border="0" title="<cf_get_lang dictionary_id='36794.Spect Detay'>"></span>
												</div>
											</div>
										</cfif>
									</div>
								</td>
								<cfif xml_work eq 1>
								<td style="width:140px;" nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<input type="text" name="work_head#currentrow#" id="work_head#currentrow#" style="width:110px;" value="#WORK_HEAD#">
											<input type="hidden" name="work_id#currentrow#" id="work_id#currentrow#" value="#WORK_ID#">
											<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58691.iş listesi'>" onclick="pencere_ac_work('#currentrow#');"></span> 
										</div>
									</div>					
								</td>
							</cfif>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<cfif isDefined("x_exit_amount_change_auto") and x_exit_amount_change_auto neq 1><cfset auto_calc_amount_exit_ = 0><cfelse><cfset auto_calc_amount_exit_ = 1></cfif>
											<input type="hidden" name="auto_calc_amount_exit" id="auto_calc_amount_exit" value="#auto_calc_amount_exit_#">
											<input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onchange="find_amount2(#currentrow#)" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);<cfif GET_DETAIL.IS_DEMONTAJ eq 0 and isdefined('GET_SUM_AMOUNT')>aktar();</cfif>"<cfif is_change_amount_demontaj eq 0 or GET_FIS.RECORDCOUNT>readonly</cfif> class="moneybox" style="width:70px;">
											<cfif auto_calc_amount_exit_ eq 0>
												<span class="input-group-addon" onclick="document.getElementById('auto_calc_amount_exit').value=1;aktar();"><i class="fa fa-pencil"></i></span>
											</cfif>
										</div>
									</div>
								</td>
								<cfif len(get_row_enter.fire_amount)><cfset fire_amount_ = get_row_enter.fire_amount><cfelse><cfset fire_amount_ = 0></cfif>
								<input type="hidden" name="amount_#currentrow#" id="amount_#currentrow#" value="#TlFormat(wrk_round(amount+fire_amount_,round_number,1),round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,1);aktar();" class="moneybox" style="width:60px;" <cfif is_change_amount_demontaj eq 0 or GET_FIS.RECORDCOUNT>readonly</cfif>>
								<cfif x_is_fire_product eq 1>
									<td>
										<div class="form-group">
											<input type="hidden" class="moneybox" name="fire_amount__#currentrow#" id="fire_amount__#currentrow#" value="#TlFormat(wrk_round(get_row_enter.fire_amount,round_number,1),round_number)#" style="width:60px;" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,3);aktar();">
											<input type="text" class="moneybox" name="fire_amount_#currentrow#" id="fire_amount_#currentrow#" value="#TlFormat(wrk_round(get_row_enter.fire_amount,round_number,1),round_number)#" style="width:60px;" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,3);aktar();">
										</div>
									</td>
								</cfif>
								<td>
									<div class="form-group">
										<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#get_product.product_unit_id#">
										<input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#get_product.main_unit#" readonly style="width:60px;">
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="text" onchange="find_amount2(#currentrow#);Get_Product_Unit_2_And_Quantity_2(#currentrow#);" name="weight#currentrow#" id="weight#currentrow#" value="#TLFormat(weight,round_number)#">
									</div>
								</td>
								<cfif x_is_show_abh eq 1>
									<td>
										<div class="form-group">
											<input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" name="width#currentrow#" id="width#currentrow#" value="#TLFormat(GET_ROW_ENTER.width)#" style="width:60px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" name="height#currentrow#" id="height#currentrow#" value="#TLFormat(GET_ROW_ENTER.height)#"  style="width:60px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)"onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" name="length#currentrow#" id="length#currentrow#" value="#TLFormat(GET_ROW_ENTER.length)#"  style="width:60px;">
										</div>
									</td>
								</cfif>
							 	<cfif xml_specific_weight eq 1> 
									<td>
										<div class="form-group">
											<input type="text" onchange="find_weight(#currentrow#)" name="specific_weight#currentrow#" id="specific_weight#currentrow#" value="#TLFormat(GET_ROW_ENTER.specific_weight)#"  style="width:60px;">
										</div>
									</td>
							 	</cfif> 
								<cfscript>
									purchase_net_ = wrk_round(PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM,8,1);
									purchase_net_extra_ = wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1);
									if(len(PURCHASE_NET_2)){
										purchase_net_2_ = wrk_round(PURCHASE_NET_2 + PURCHASE_EXTRA_COST_SYSTEM_2,8,1);
										purchase_net_extra_2_ = wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1);
									}
									else
									{
										purchase_net_2_ = 0;
										purchase_net_extra_2_ = 0;
									}
									labor_cost_total = LABOR_COST_SYSTEM+GET_ROWS_REFLECTION.TOTAL_LABOR_COST_SYSTEM;
									reflection_cost_total = STATION_REFLECTION_COST_SYSTEM+GET_ROWS_REFLECTION.TOTAL_STATION_REFLECTION_COST_SYSTEM;
								</cfscript>
								<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
									<td>
										<div class="form-group">
											<input type="text" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#TLFormat(purchase_net_,round_number)#" class="moneybox" readonly style="width:125px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" name="cost_price_extra#currentrow#" id="cost_price_extra#currentrow#" value="#TLFormat(PURCHASE_NET_EXTRA_,round_number)#" class="moneybox" readonly style="width:125px;">
										</div>
									</td>
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<td>
											<div class="form-group">
												<input type="text" name="total_cost_price#currentrow#" id="total_cost_price#currentrow#" value="#TLFormat(purchase_net_ * _AMOUNT_,round_number)#" class="moneybox" readonly style="width:125px;">
											</div>
										</td>
									</cfif>
									<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<td>
											<div class="form-group">
												<input type="hidden" name="labor_cost#currentrow#" id="labor_cost#currentrow#" value="#LABOR_COST_SYSTEM#" style="width:0px;">
												<input type="text" name="____labor_cost#currentrow#" id="____labor_cost#currentrow#" class="moneybox" readonly value="#TLFormat(LABOR_COST_SYSTEM,round_number)#" style="width:90px;">
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="____labor_cost_total#currentrow#" id="____labor_cost_total#currentrow#" class="moneybox" readonly value="#TLFormat(labor_cost_total,round_number)#" style="width:90px;">
											</div>
										</td>
									</cfif>
									<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<td>
											<div class="form-group">
												<input type="hidden" name="station_reflection_cost_system#currentrow#" id="station_reflection_cost_system#currentrow#" value="#STATION_REFLECTION_COST_SYSTEM#" style="width:0px;">
												<input type="text" name="____station_reflection_cost_system#currentrow#" id="____station_reflection_cost_system#currentrow#" class="moneybox" readonly value="#TLFormat(STATION_REFLECTION_COST_SYSTEM,round_number)#" style="width:90px;">
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="____station_reflection_cost_system_total#currentrow#" id="____station_reflection_cost_system_total#currentrow#" class="moneybox" readonly value="#TLFormat(reflection_cost_total,round_number)#" style="width:90px;">
											</div>
										</td>
									</cfif>
									<cfif (len(LABOR_COST_SYSTEM) and LABOR_COST_SYSTEM neq 0) or (len(GET_ROWS_REFLECTION.TOTAL_LABOR_COST_SYSTEM)  and GET_ROWS_REFLECTION.TOTAL_LABOR_COST_SYSTEM neq 0)>
										<cfset LABOR_COST_SYSTEM_ = (LABOR_COST_SYSTEM + GET_ROWS_REFLECTION.TOTAL_LABOR_COST_SYSTEM) / get_money_rate.rate2>
									<cfelse>
										<cfset LABOR_COST_SYSTEM_ = LABOR_COST_SYSTEM>
									</cfif>
									<cfif (len(STATION_REFLECTION_COST_SYSTEM) and STATION_REFLECTION_COST_SYSTEM neq 0) or (len(GET_ROWS_REFLECTION.TOTAL_STATION_REFLECTION_COST_SYSTEM) and GET_ROWS_REFLECTION.TOTAL_STATION_REFLECTION_COST_SYSTEM neq 0)>
										<cfset STATION_REFLECTION_COST_SYSTEM_ = (STATION_REFLECTION_COST_SYSTEM + GET_ROWS_REFLECTION.TOTAL_STATION_REFLECTION_COST_SYSTEM) / get_money_rate.rate2>
									<cfelse>
										<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM>
									</cfif>
									<td>
										<div class="form-group">
											<input type="text" name="money#currentrow#" id="money#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#" readonly style="width:50px;">
										</div>
									</td>
									<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
										<td>
											<div class="form-group">
												<input type="text" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(purchase_net_2_,round_number)#" class="moneybox" readonly style="width:125px;">
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" class="moneybox" value="#TLFormat(purchase_net_extra_2_,round_number)#">
											</div>
										</td>
										<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
											<td>
												<div class="form-group">
													<input type="text" name="____labor_cost2_#currentrow#" id="____labor_cost2_#currentrow#" class="moneybox" readonly value="#TLFormat( (LABOR_COST_SYSTEM/get_money_rate.rate2),round_number)#" style="width:90px;">
												</div>
											</td>
											<td>
												<div class="form-group">
													<input type="text" name="____labor_cost2_total#currentrow#" id="____labor_cost2_total#currentrow#" class="moneybox" readonly value="#TLFormat(LABOR_COST_SYSTEM_,round_number)#" style="width:90px;">
												</div>
											</td>
										</cfif>
										<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
											<td>
												<div class="form-group">
													<input type="text" name="____station_reflection_cost_system2_#currentrow#" id="____station_reflection_cost_system2_#currentrow#" class="moneybox" readonly value="#TLFormat((STATION_REFLECTION_COST_SYSTEM / get_money_rate.rate2),round_number)#" style="width:90px;">
												</div>
											</td>
											<td>
												<div class="form-group">
													<input type="text" name="____station_reflection_cost_system2_total#currentrow#" id="____station_reflection_cost_system2_total#currentrow#" class="moneybox" readonly value="#TLFormat(STATION_REFLECTION_COST_SYSTEM_,round_number)#" style="width:90px;">
												</div>
											</td>
										</cfif>
										<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
											<td>
												<div class="form-group">
													<input type="text" name="total_cost_price_2#currentrow#" id="total_cost_price_2#currentrow#" value="#TLFormat(purchase_net_2_ * _AMOUNT_,round_number)#" class="moneybox" readonly style="width:125px;">
												</div>
											</td>
										</cfif>
									<cfelse>
										<input type="hidden" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#">
										<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(PURCHASE_NET_EXTRA_2_,round_number)#">
									</cfif>
									<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
										<td>
											<div class="form-group">
												<input type="text" name="money_2#currentrow#" id="money_2#currentrow#" value="#PURCHASE_NET_MONEY_2#" readonly style="width:50px;">
											</div>
										</td>
									<cfelse>
										<input type="hidden" name="money_2#currentrow#" id="money_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
									</cfif>
								<cfelse>
									<cfif len(LABOR_COST_SYSTEM)>
										<cfset LABOR_COST_SYSTEM_ = LABOR_COST_SYSTEM / get_money_rate.rate2>
									<cfelse>
										<cfset LABOR_COST_SYSTEM_ = LABOR_COST_SYSTEM>
									</cfif>
									<cfif len(STATION_REFLECTION_COST_SYSTEM)>
										<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM / get_money_rate.rate2>
									<cfelse>
										<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM>
									</cfif>
									<input type="hidden" name="labor_cost#currentrow#" id="labor_cost#currentrow#" value="#LABOR_COST_SYSTEM#">
									<input type="hidden" name="station_reflection_cost_system#currentrow#" id="station_reflection_cost_system#currentrow#" value="#STATION_REFLECTION_COST_SYSTEM#">
									<input type="hidden" name="labor_cost2_#currentrow#" id="labor_cost2_#currentrow#" value="#LABOR_COST_SYSTEM_#">
									<input type="hidden" name="station_reflection_cost_system2_#currentrow#" id="station_reflection_cost_system2_#currentrow#" value="#STATION_REFLECTION_COST_SYSTEM_#">
									<input type="hidden" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#">
									<input type="hidden" name="money#currentrow#" id="money#currentrow#" value="#PURCHASE_NET_MONEY#">
									<input type="hidden" name="cost_price_2#currentrow#" id="cost_price_2#currentrow#" value="#TLFormat(PURCHASE_NET_2,round_number)#">
									<input type="hidden" name="cost_price_extra_2#currentrow#" id="cost_price_extra_2#currentrow#" value="#TLFormat(PURCHASE_NET_EXTRA_2_,round_number)#">
									<input type="hidden" name="money_2#currentrow#" id="money_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
								</cfif>
								<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
									<cfquery name="production_orders_unit2" datasource="#dsn3#">
										-- Select rows from a Table or View 'TableOrViewName' in schema 'SchemaName'
										SELECT QUANTITY_2,UNIT_2,PR.MULTIPLIER
										  FROM PRODUCTION_ORDERS PO
									  LEFT JOIN PRODUCT_UNIT      PR ON PR.ADD_UNIT=PO.UNIT_2
										 WHERE P_ORDER_ID=#attributes.p_order_id# 
										   AND PR.PRODUCT_ID=#PRODUCT_ID#
									</cfquery>
									<td>
										<div class="form-group">
											<input type="hidden" name="unit2_order" id="unit2_order" value="#production_orders_unit2.UNIT_2#">
											<input type="hidden" name="unit2_multiplier" id="unit2_multiplier" value="#production_orders_unit2.MULTIPLIER#">
											<input type="text" name="amount2_#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2(#currentrow#)" id="amount2_#currentrow#" value="#TLFormat(AMOUNT2,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="" class="moneybox" style="width:70px;">										</div>
									</td>
									<td>
										<cfset _unıt2_ = UNIT2>
										<cfquery name="get_all_unit2" datasource="#dsn3#">
											SELECT 
												PRODUCT_UNIT_ID,ADD_UNIT
											FROM 
												PRODUCT_UNIT 
											WHERE
												PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
												AND PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#">
												AND IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable_#">
										</cfquery>
										<div class="form-group">
											<input type="hidden" name="indexCurrent" id="indexCurrent" value="#currentrow#">
											<select name="unit2#currentrow#" id="unit2#currentrow#" style="width:60;" disabled="true">
												<cfloop query="get_all_unit2">
													<option value="#PRODUCT_UNIT_ID#"<cfif _unıt2_ eq PRODUCT_UNIT_ID>selected</cfif>>#ADD_UNIT#</option>
												</cfloop>
											</select>
										</div>
									</td>
								</cfif>
								<td style="display:#product_name2_display#">
									<div class="form-group">
										<input type="text" style="width:70px;" name="product_name2#currentrow#" id="product_name2#currentrow#" value="#product_name2#">
									</div>
								</td>
								<cfif len(GET_PRODUCT.is_serial_no) and GET_PRODUCT.is_serial_no eq 1>
								<td>
									<cfif len(get_detail.exit_dep_id)>
										<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
											SELECT
												SG.LOT_NO,
												SG.SERIAL_NO
											FROM
												SERVICE_GUARANTY_NEW AS SG
											WHERE
												STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#"> AND
												PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
												PROCESS_CAT = 171 AND
												<cfif len(spect_id)>
													SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spect_id#"> AND
												</cfif>
												SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
										</cfquery>
										<a href="javascript://" onclick="window.open('#request.self#?fuseaction=stock.list_serial_operations&event=det&wrk_row_id=#get_row_enter.wrk_row_id#&product_id=#product_id#&stock_id=#stock_id#&process_number=#get_detail.result_no#&process_date=#get_detail.finish_date#&process_cat=171&process_id=#attributes.pr_order_id#&is_serial_no=1&product_amount=#amount#&recorded_count=#get_serial_info.recordcount#&sale_product=0&company_id=&con_id=&location_out=#get_detail.exit_loc_id#&department_out=#get_detail.exit_dep_id#&location_in=#get_detail.production_loc_id#&department_in=#get_detail.production_dep_id#&guaranty_cat=&guaranty_startdate=&spect_id=#spect_id#');"><i class="fa fa-qrcode" title="<cf_get_lang dictionary_id='57717.Garanti'>-<cf_get_lang dictionary_id='57718.Seri Nolar'>"></i></a>
									</cfif>
								</td>
								<cfelse>
									<td><a href="javascript://"><i class="fa fa-qrcode" title="Seçilen Ürün İçin Seri No Takibi Yapılmamaktadır!" disabled> </a></td>
								</cfif>
								<td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=prod.list_quality_controls&event=add&pr_order_id=#attributes.pr_order_id#&product_id=#product_id#&stock_id=#stock_id#&pid=#product_id#&process_id=#attributes.p_order_id#&process_row_id=#PR_ORDER_ROW_ID#&process_cat=171&ship_wrk_row_id=#wrk_row_id#','project');"><i class="fa fa-check-square" title="<cf_get_lang dictionary_id='36650.Kalite Kontrol'>"></i></a></td>
								<cfif len(GET_PRODUCT.is_serial_no) and GET_PRODUCT.is_serial_no eq 1><td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_upper_serial_operations&wrk_row_id=#get_detail.wrk_row_id#&p_order_id=#attributes.p_order_id#&product_id=#product_id#&stock_id=#stock_id#&process_number=#get_detail.result_no#&process_cat_id=171&process_id=#attributes.pr_order_id#&is_serial_no=1&product_amount=#amount#&location_out=#get_detail.exit_loc_id#&department_out=#get_detail.exit_dep_id#&location_in=#get_detail.production_loc_id#&department_in=#get_detail.production_dep_id#&belge_no=#get_detail.production_order_no#&new_dsn2=#new_dsn2#&spect_id=#spec_main_id#');"><i class="fa fa-barcode" title="<cf_get_lang dictionary_id='60225.Hızlı Seri Giriş'>"></a></td>
								<cfelse>
									<td><a href="javascript://"><i class="fa fa-barcode" title="Seçilen Ürün İçin Seri No Takibi Yapılmamaktadır!" disabled> </a></td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
			</div>
			<cfsavecontent variable='title'><cf_get_lang dictionary_id='36768.Sarf'></cfsavecontent>
			<cf_seperator header="#title#" id="table2_sep">
			<div id="table2_sep">
				<cf_grid_list id="table2" name="table2">
					<!---Alan 2 için iframe--->
					<cfif x_pro_add_barkod_and_seri_no eq 1>
						<div id="add_prod2" class="col-6"></div>
					</cfif>
					<thead>
						<tr>
							<th style="min-width:54px; text-align:center;"><input type="hidden" name="record_num_exit" id="record_num_exit" value="<cfoutput>#get_row_exit.recordcount#</cfoutput>"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=0&record_num_exit=' + form_basket.record_num_exit.value,'list')"><i class="fa fa-plus" id="add_row_exit_image"></i></a></th>
							<th style="min-width:125px;"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
							<cfif x_is_barkod_col eq 1><th style="min-width:95px;"><cf_get_lang dictionary_id='57633.Barkod'></th></cfif>
							<th style="min-width:259px;"><cf_get_lang dictionary_id='57452.Stok'></th>
							<th style="min-width:200px; display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang dictionary_id='57647.spect'></th>
							<th style="min-width:92px;"><cf_get_lang dictionary_id='36698.Lot No'></th>
							<th style="min-width:90px;" nowrap><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></th>
							<th style="min-width:75px;"><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th style="min-width:65px;"><cf_get_lang dictionary_id='57636.Birim'></th>
							<th style="min-width:65px;"><cf_get_lang dictionary_id='29784.Ağırlık'>(KG)</th>
								<cfif x_is_show_abh eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="48152.En">(cm)</th>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="55735.Boy">(cm)</th>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="57696.Yükseklik">(cm)</th>
								</cfif>
								<cfif xml_specific_weight eq 1>
									<th style="min-width:65px;"><cf_get_lang dictionary_id="64080.Özgül Ağırlık"></th>
								</cfif>
							<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
								<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'></th>
								<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="57175.Ek maliyet"></th>
								<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
									<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="47560.İşçilik Maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
								</cfif>
								<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
									<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="47561.Yansıyan Maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
								</cfif>
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
									<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'></th>
								</cfif>
								<th style="min-width:55px; text-align:right;"><cf_get_lang dictionary_id='57489.Para Br'></th>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
									<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="57175.Ek maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<th id="labor_cost" style="min-width:22px; text-align:right;"><cf_get_lang dictionary_id="47560.İşçilik Maliyeti"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
										<th id="labor_cost" style="min-width:22px; text-align:right;"><cf_get_lang dictionary_id='60596.İşçilik Toplam Maliyeti'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>		
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>
									<th style="min-width:55px;"><cf_get_lang dictionary_id='57489.Para Br'></th>
								</cfif>
							</cfif>
							<cfif is_show_two_units eq 1>
								<th style="min-width:75px;">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
								<th style="min-width:40px;">2.<cf_get_lang dictionary_id='57636.Birim'></th>
							</cfif>
							<cfif is_show_product_name2 eq 1>
								<th style="min-width:75px;">2.<cf_get_lang dictionary_id='57629.Açıklama'></th>
							</cfif>
							<cfif GET_DETAIL.is_demontaj neq 1 and x_is_show_sb eq 1>
								<th style="min-width:22px;"><cf_get_lang dictionary_id='36615.Sevkte Birleştir'></th>
							</cfif>
							<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1><th width="30" title="<cf_get_lang dictionary_id='57400.Manuel Maliyet'>"> M</th></cfif>
						</tr>
					</thead>
					<tbody id="table2_body">
						<cfoutput query="get_row_exit">
							<cfquery name="GET_PRODUCT" datasource="#DSN1#">
								SELECT 
									PRODUCT.PRODUCT_NAME,
									PRODUCT.BARCOD,
									STOCKS.PRODUCT_UNIT_ID,
									PRODUCT_UNIT.ADD_UNIT,
									PRODUCT_UNIT.MAIN_UNIT,
									PRODUCT_UNIT.DIMENTION,
									STOCKS.PROPERTY,
									STOCKS.STOCK_CODE
								FROM 
									PRODUCT,
									STOCKS,
									PRODUCT_UNIT
								WHERE 
									STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
									STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
									PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
									PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
									PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
							</cfquery>
							<!--- Sarflar --->
							<tr id="frm_row_exit#currentrow#" <cfif TREE_TYPE is 'P'>class="phantom" title="Phantom Ağaçtan Ürünler"<cfelseif TREE_TYPE is 'O'>class="operasyon" title="<cf_get_lang dictionary_id='60507.Operasyondan Gelen Ürünler'>"</cfif>>
								<cfif is_from_spect eq 1>
									<input type="hidden" name="is_add_info_#currentrow#" id="is_add_info_#currentrow#" value="1">
								</cfif>
								<cfset cols_ = 11>
								<cfquery name="get_is_production" datasource="#dsn3#">
									SELECT TOP 1 IS_PRODUCTION FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
								</cfquery>
								<input type="hidden" name="line_number_exit_#currentrow#" id="line_number_exit_#currentrow#" value="#line_number#">
								<input type="hidden" name="wrk_row_id_exit_#currentrow#" id="wrk_row_id_exit_#currentrow#" value="#wrk_row_id#">
								<input type="hidden" name="wrk_row_relation_id_exit_#currentrow#" id="wrk_row_relation_id_exit_#currentrow#" value="#wrk_row_relation_id#">
								<input type="hidden" name="tree_type_exit_#currentrow#" id="tree_type_exit_#currentrow#" value="#TREE_TYPE#">
								<input type="hidden" name="row_kontrol_exit#currentrow#" id="row_kontrol_exit#currentrow#" value="1">
								<input type="hidden" name="cost_id_exit#currentrow#" id="cost_id_exit#currentrow#" value="#COST_ID#">
								<input type="hidden" name="kdv_amount_exit#currentrow#" id="kdv_amount_exit#currentrow#" value="#KDV_PRICE#">
								<input type="hidden" name="is_free_amount#currentrow#" id="is_free_amount#currentrow#" value="#is_free_amount#">						
								<input type="hidden" name="is_production_spect_exit#currentrow#" id="is_production_spect_exit#currentrow#" value="<cfif GET_DETAIL.is_demontaj neq 1>#get_is_production.IS_PRODUCTION#<cfelse>0</cfif>"><!--- Üretilen bir ürün ise hidden alan 1 oluyor ve query sayfasında bu ürün için otomatik bir spect oluşuyor --->	
								<td nowrap="nowrap" style="text-align:center;width:40px;">
									<ul class="ui-icon-list">
										<li><a href="javascript://" onclick="copy_row_exit('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy"></i></a></li>
										<li><a href="javascript://" onclick="sil_exit('#currentrow#');"><i  class="fa fa-minus"  title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>
									</ul>
								</td>
								<td>
									<div class="form-group">
										<input type="text" name="stock_code_exit#currentrow#" id="stock_code_exit#currentrow#" value="#get_product.stock_code#" readonly style="width:120px;">
									</div>
								</td>
								<cfif x_is_barkod_col eq 1><td><div class="form-group"><input type="text" name="barcode_exit#currentrow#" id="barcode_exit#currentrow#" value="#get_product.barcod#" readonly style="width:90px;"></div></td><cfset cols_ = cols_ + 1></cfif>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="product_id_exit#currentrow#" id="product_id_exit#currentrow#" value="#product_id#">
											<input type="hidden" name="stock_id_exit#currentrow#" id="stock_id_exit#currentrow#" value="#stock_id#">
											<input type="text" name="product_name_exit#currentrow#" id="product_name_exit#currentrow#" value="#get_product.product_name# #get_product.property#" readonly style="width:230px;">
											<span class="input-group-addon" onclick="pencere_ac_alternative(1,'#currentrow#',document.form_basket.product_id_exit#currentrow#.value,document.all.stock_id1.value);"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang dictionary_id ='36839.Alternatif Ürünler'>"></span>
											<span class="input-group-addon" onclick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang dictionary_id ='36369.Stok Detay'>"></span>
										</div>
									</div>
								</td>
								<td style="display:#spec_img_display#;" nowrap>
									<cfif len(get_row_exit.spect_id) OR LEN(get_row_exit.SPEC_MAIN_ID) >
										<cfquery name="GET_SPECT" datasource="#dsn3#">
											<cfif len(get_row_exit.spect_id)>
												SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_exit.spect_id#">
											<cfelse>
												SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_exit.SPEC_MAIN_ID#">
											</cfif>
										</cfquery>
										<div class="form-group">
											<div class="col col-3">
												<input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="#get_row_exit.spect_id#" >
												<input type="#Evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="#get_row_exit.SPEC_MAIN_ID#" readonly style="width:40px;">
											</div>
											<div class="col col-3">
												<input type="#Evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="#get_row_exit.spect_id#"  readonly style="width:40px;">
											</div>
											<div class="col col-6">
												<div class="input-group">
													<input type="#Evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:160px;">
													<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_spect('#currentrow#',2);"></span>
												</div>
											</div>
										</div>
									<cfelse>
										<div class="form-group">
											<div class="col col-3">
												<!--- Demontaj sırasında spect'in değişip değişmediğini kontrol etmek için,değişmiş ise sayfa reload ediliyor. --->
												<input type="hidden" name="spect_id_exit_#currentrow#" id="spect_id_exit_#currentrow#" value="">
												<input type="#Evaluate('spec_display')#" name="spec_main_id_exit#currentrow#" id="spec_main_id_exit#currentrow#" value="" readonly style="width:40px;">
											</div>
											<div class="col col-3">
												<input type="#Evaluate('spec_display')#" name="spect_id_exit#currentrow#" id="spect_id_exit#currentrow#" value="" readonly style="width:40px;">
											</div>
											<div class="col col-6">
												<div class="input-group">
													<input type="#Evaluate('spec_name_display')#" name="spect_name_exit#currentrow#" id="spect_name_exit#currentrow#" value="" readonly style="width:160px;">
													<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_spect('#currentrow#',2);"></span>
												</div>
											</div>
										</div>
									</cfif>
								</td>
								<td nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<input type="text" name="lot_no_exit#currentrow#" id="lot_no_exit#currentrow#" value="#get_row_exit.lot_no#" onKeyup="lotno_control(#currentrow#,2);" style="width:75px;" />
											<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_list_product('#currentrow#','2');"></span>
										</div>
									</div>
								</td>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<input type="text" name="expiration_date_exit#currentrow#" id="expiration_date_exit#currentrow#" value="#dateformat(get_row_exit.expiration_date,dateformat_style)#" style="width:70px;" />
											<span class="input-group-addon"><cf_wrk_date_image date_field="expiration_date_exit#currentrow#"></span>
										</div>
									</div>
								</td>
								<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
								<td>
									<div class="form-group">
										<input type="text" name="amount_exit#currentrow#" onchange="find_amount2_exit(#currentrow#)" id="amount_exit#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));"  onblur="hesapla_deger(#currentrow#,0);<cfif GET_DETAIL.IS_DEMONTAJ eq 1 and isdefined('GET_SUM_AMOUNT')>aktar();</cfif>" <cfif GET_DETAIL.IS_DEMONTAJ eq 0 or GET_FIS.RECORDCOUNT>#_readonly_#</cfif>  class="moneybox" style="width:70px;">
										<input type="hidden" name="amount_exit_#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="amount_exit_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));"  onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;">
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="hidden" name="unit_id_exit#currentrow#" id="unit_id_exit#currentrow#" value="#get_product.product_unit_id#">
										<input type="text" name="unit_exit#currentrow#" id="unit_exit#currentrow#" value="#get_product.main_unit#" readonly style="width:60px;">
										<input type="hidden" name="serial_no_exit#currentrow#" id="serial_no_exit#currentrow#" value="#serial_no#" style="width:150px;">
									</div>
								</td>
								<cfset PURCHASE_NET_ = wrk_round(PURCHASE_NET,8,1)>
								<cfif len(PURCHASE_NET_2)>
									<cfset PURCHASE_NET_2_ = wrk_round(PURCHASE_NET_2,8,1)>
								<cfelse>	
									<cfset PURCHASE_NET_2_ = 0>
								</cfif>
								<td>
									<div class="form-group">
										<input type="text" onchange="find_amount2_exit(#currentrow#);Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#);" name="weight_exit#currentrow#" id="weight_exit#currentrow#" value="#TLFormat(get_row_exit.weight,round_number)#">
									</div>
								</td>
								<cfif x_is_show_abh eq 1>
									<td>
										<div class="form-group">
											<input type="text" name="width_exit#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="width_exit#currentrow#" value="#TLFormat(get_row_exit.width)#" style="width:60px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text"  name="height_exit#currentrow#"  onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="height_exit#currentrow#" value="#TLFormat(get_row_exit.height)#"  style="width:60px;">
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" name="length_exit#currentrow#"  onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="length_exit#currentrow#" value="#TLFormat(get_row_exit.length)#"  style="width:60px;">
										</div>
									</td>
								</cfif>
								<cfif xml_specific_weight eq 1> 
									<td>
										<div class="form-group">
											<input type="text" onchange="find_weight_exit(#currentrow#)" name="specific_weight_exit#currentrow#" id="specific_weight_exit#currentrow#" value="#TLFormat(get_row_exit.specific_weight)#"  style="width:60px;">
										</div>
									</td>
							 	</cfif>
								<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
									<td>
										<div class="form-group">
											<input type="text" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,2);"</cfif>>
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM#">
											<input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
											<input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
											<input type="text" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,2);"</cfif>>
										</div>
									</td>
									<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<td>
											<div class="form-group">
												<input type="text" name="labor_cost_exit#currentrow#" id="labor_cost_exit#currentrow#" value="#TLFormat(labor_cost_system,round_number)#" readonly class="moneybox">
											</div>
										</td>
									</cfif>
									<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<td>
											<div class="form-group">
												<input type="text" name="reflection_cost_exit#currentrow#" id="reflection_cost_exit#currentrow#" value="#TLFormat(STATION_REFLECTION_COST_SYSTEM,round_number)#" readonly class="moneybox">
											</div>
										</td>	
									</cfif>				
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<td>
											<div class="form-group">
												<input type="text" name="total_cost_price_exit#currentrow#" id="total_cost_price_exit#currentrow#" value="#TLFormat((PURCHASE_NET_+PURCHASE_EXTRA_COST)*_AMOUNT_,round_number)#" readonly class="moneybox">
											</div>
										</td>
									</cfif>
									<td>
										<div class="form-group">
											<input type="text" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#PURCHASE_NET_MONEY#" readonly style="width:50px;">
										</div>
									</td>
									<cfset cols_ = cols_ + 3>
									<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
										<td><div class="form-group"><input type="text" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></div></td>
										<td><div class="form-group"><input type="text" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></div></td>
										<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
											<td>
												<cfif len(labor_cost_system)>
													<cfset labor_cost_system_ = labor_cost_system / get_money_rate.rate2>
												<cfelse>
													<cfset labor_cost_system_ = labor_cost_system>
												</cfif>
												<div class="form-group"><input type="text" name="total_labor_cost_exit_2#currentrow#" id="total_labor_cost_exit_2#currentrow#" value="#TLFormat(labor_cost_system_,round_number)#" readonly class="moneybox"></div>
											</td>
										</cfif>
										<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
											<td>
												<cfif len(STATION_REFLECTION_COST_SYSTEM)>
													<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM / get_money_rate.rate2>
												<cfelse>
													<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM>
												</cfif>
												<div class="form-group"><input type="text" name="total_reflection_cost_exit_2#currentrow#" id="total_reflection_cost_exit_2#currentrow#" value="#TLFormat(STATION_REFLECTION_COST_SYSTEM_,round_number)#" readonly class="moneybox"></div>
											</td>  	
										</cfif>	
										<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
											<td><div class="form-group"><input type="text" name="total_cost_price_exit_2#currentrow#" id="total_cost_price_exit_2#currentrow#" value="#TLFormat((PURCHASE_NET_2_+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1))*_AMOUNT_,round_number)#" readonly class="moneybox"></div></td><cfset cols_ = cols_ + 1>
										</cfif>
										<td>
											<div class="form-group">
												<input type="text" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#PURCHASE_NET_MONEY_2#" <cfif is_change_sarf_cost eq 0>readonly</cfif> style="width:50px;">
											</div>
										</td>
										<cfset cols_ = cols_ + 3>
									<cfelse>
										<input type="hidden" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#">
										<input type="hidden" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#">
										<input type="hidden" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
									</cfif>
								<cfelse>
									<input type="hidden" name="labor_cost_exit#currentrow#" id="labor_cost_exit#currentrow#" value="#labor_cost_system#">
									<input type="hidden" name="reflection_cost_exit#currentrow#" id="reflection_cost_exit#currentrow#" value="#STATION_REFLECTION_COST_SYSTEM#">
									<input type="hidden" name="cost_price_system_exit#currentrow#" id="cost_price_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM#">
									<input type="hidden" name="purchase_extra_cost_system_exit#currentrow#" id="purchase_extra_cost_system_exit#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
									<input type="hidden" name="money_system_exit#currentrow#" id="money_system_exit#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
									<input type="hidden" name="purchase_extra_cost_exit#currentrow#" id="purchase_extra_cost_exit#currentrow#" value="#TLFormat(PURCHASE_EXTRA_COST,round_number)#" class="moneybox" readonly>
									<input type="hidden" name="cost_price_exit#currentrow#" id="cost_price_exit#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#">
									<input type="hidden" name="money_exit#currentrow#" id="money_exit#currentrow#" value="#PURCHASE_NET_MONEY#">
									<input type="hidden" name="cost_price_exit_2#currentrow#" id="cost_price_exit_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#">
									<input type="hidden" name="purchase_extra_cost_exit_2#currentrow#" id="purchase_extra_cost_exit_2#currentrow#" value="#TLFormat(PURCHASE_EXTRA_COST_SYSTEM_2,round_number)#" class="moneybox" readonly>
									<input type="hidden" name="money_exit_2#currentrow#" id="money_exit_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
								</cfif>
								<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
								<td>
									<div class="form-group">
										<input type="text" name="amount_exit2_#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_exit(#currentrow#)" id="amount_exit2_#currentrow#" value="#TLFormat(AMOUNT2,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="" class="moneybox" style="width:70px;">
									</div>
								</td>
								<td>
									<cfset _unit2e_ = UNIT2>
									<cfquery name="get_all_unit2" datasource="#dsn3#">
										SELECT 
											PRODUCT_UNIT_ID,ADD_UNIT
										FROM 
											PRODUCT_UNIT 
										WHERE
											PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
											AND PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#">
											AND IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable_#">
									</cfquery>
									<div class="form-group">
										<select name="unit2_exit#currentrow#" id="unit2_exit#currentrow#" style="width:60;" disabled="true">
											<cfloop query="get_all_unit2">
												<option value="#ADD_UNIT#"<cfif _unit2e_ eq ADD_UNIT>selected</cfif>>#ADD_UNIT#</option>
											</cfloop>
										</select>
									</div>
								</td>
								<cfset cols_ = cols_ + 2>
								</cfif>
								<td style="display:#product_name2_display#"><input type="text" style="width:70px;" name="product_name2_exit#currentrow#" id="product_name2_exit#currentrow#" value="#product_name2#"></td>
								<cfif GET_DETAIL.is_demontaj neq 1>
									<cfif x_is_show_sb eq 1>
										<td>
											<input type="checkbox" name="is_sevkiyat#currentrow#" id="is_sevkiyat#currentrow#" <cfif get_row_exit.is_sevkiyat eq 1>checked</cfif>>
										</td>
										<cfset cols_ = cols_ + 1>
									</cfif>
								</cfif>
								<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
									<td>
										<input type="checkbox" name="is_manual_cost_exit#currentrow#" id="is_manual_cost_exit#currentrow#" value="1" <cfif get_row_exit.is_manual_cost eq 1>checked</cfif>>
									</td>
								</cfif>
								<cfif GET_DETAIL.is_demontaj eq 1>
									<cfset cols_ = cols_ + 1>
									<td>
										<cf_get_lang dictionary_id='36860.Demontaj'>
									</td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
				<cfif get_row_exit.recordcount>
					<div class="ui-info-bottom flex-end">
						<div><a class="ui-wrk-btn ui-wrk-btn-success" onclick="sil_exit_all();"><cf_get_lang dictionary_id="30036.hepsini sil"></a></div>
					</div>
				</cfif>
			</div>
			<cfsavecontent variable='header'><cf_get_lang dictionary_id='29471.Fire'></cfsavecontent>
			<cf_seperator header="#header#" id="table3_sep">
			<div id="table3_sep">
			<cf_grid_list id="table3" name="table3">
				<cfif x_pro_add_barkod_and_seri_no eq 1>
					<div class="col-6" id="add_prod3"></div>
				</cfif>
				<thead>
					<tr>
						<th style="min-width:54px; text-align:center;"><input type="hidden" name="record_num_outage" id="record_num_outage" value="<cfoutput>#get_row_outage.recordcount#</cfoutput>"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product#xml_str#</cfoutput>&type=2&record_num_outage=' + form_basket.record_num_outage.value,'list')"><i class="fa fa-plus" id="add_row_outage_image"></i></a></th>
						<th style="min-width:125px;"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
						<cfif x_is_barkod_col eq 1><th style="min-width:95px;"><cf_get_lang dictionary_id='57633.Barkod'></th></cfif>
						<th style="min-width:259px;"><cf_get_lang dictionary_id='57452.Stok'></th>
						<th style="min-width:253px; display:<cfoutput>#spec_img_display#</cfoutput>"><cf_get_lang dictionary_id='57647.spect'></th>
						<th style="min-width:92px;"><cf_get_lang dictionary_id='36698.Lot No'></th>
						<th style="min-width:90px;" nowrap><cf_get_lang dictionary_id='33892.Son Kullanma Tarihi'></th>
						<th style="min-width:75px;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						<th style="min-width:65px;"><cf_get_lang dictionary_id='57636.Birim'></th>
						<th style="min-width:65px;"><cf_get_lang dictionary_id='29784.Ağırlık'>(KG)</th>
							<cfif x_is_show_abh eq 1>
								<th style="min-width:65px;"><cf_get_lang dictionary_id="48152.En">(cm)</th>
								<th style="min-width:65px;"><cf_get_lang dictionary_id="55735.Boy">(cm)</th>
								<th style="min-width:65px;"><cf_get_lang dictionary_id="57696.Yükseklik">(cm)</th>
							</cfif>
							<cfif xml_specific_weight eq 1>
								<th style="min-width:65px;"><cf_get_lang dictionary_id="64080.Özgül Ağırlık"></th>
							</cfif>
						<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
							<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'></th>
							<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="57175.Ek maliyet"></th>
							<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
								<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="47560.İşçilik Maliyet"></th>
							</cfif>
							<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
								<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="47561.Yansıyan Maliyet"></th>
							</cfif>
							<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
								<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'></th>
							</cfif>
							<th style="min-width:55px;"><cf_get_lang dictionary_id='57489.Para Br'></th>
							<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
								<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id='36767.Birim Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
								<th width="120" style="text-align:right;"><cf_get_lang dictionary_id="57175.Ek maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="47560.İşçilik Maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>
									<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id="47561.Yansıyan Maliyet"> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
									</cfif>	
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
									<th style="min-width:151px; text-align:right;"><cf_get_lang dictionary_id='36812.Toplam Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
								</cfif>
								<th style="min-width:55px;"><cf_get_lang dictionary_id='57489.Para Br'></th>
							</cfif>
						</cfif>
						<cfif is_show_two_units eq 1>
							<th style="min-width:75px;">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
							<th style="min-width:40px;">2.<cf_get_lang dictionary_id='57636.Birim'></th>
						</cfif>
						<cfif is_show_product_name2 eq 1>
							<th style="min-width:75px;">2.<cf_get_lang dictionary_id='57629.Açıklama'></th>
						</cfif>
						<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1><th width="30" title="<cf_get_lang dictionary_id='57400.Manuel Maliyet'>">M</th></cfif>
					</tr>
				</thead>
				<tbody id="table3_body">
					<cfoutput query="get_row_outage">
						<cfquery name="GET_PRODUCT" datasource="#DSN1#">
							SELECT 
								PRODUCT.PRODUCT_NAME,
								PRODUCT.BARCOD,
								STOCKS.PRODUCT_UNIT_ID,
								PRODUCT_UNIT.ADD_UNIT,
								PRODUCT_UNIT.MAIN_UNIT,
								PRODUCT_UNIT.DIMENTION,
								STOCKS.PROPERTY,
								STOCKS.STOCK_CODE
							FROM 
								PRODUCT,
								STOCKS,
								PRODUCT_UNIT
							WHERE 
								PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
								STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
								STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND
								PRODUCT_UNIT.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
								PRODUCT_UNIT.PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> AND
								PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
						</cfquery>
						<tr id="frm_row_outage#currentrow#">
							<input type="hidden" name="line_number_outage_#currentrow#" id="line_number_outage_#currentrow#" value="#line_number#">
							<input type="hidden" name="wrk_row_id_outage_#currentrow#" id="wrk_row_id_outage_#currentrow#" value="#wrk_row_id#">
							<input type="hidden" name="wrk_row_relation_id_outage_#currentrow#" id="wrk_row_relation_id_outage_#currentrow#" value="#wrk_row_relation_id#">
							<input type="hidden" name="row_kontrol_outage#currentrow#" id="row_kontrol_outage#currentrow#" value="1">
							<input type="hidden" name="cost_id_outage#currentrow#" id="cost_id_outage#currentrow#" value="#COST_ID#">
							<input type="hidden" name="kdv_amount_outage#currentrow#" id="kdv_amount_outage#currentrow#" value="#KDV_PRICE#">
							<input type="hidden" name="is_free_amount#currentrow#" id="is_free_amount#currentrow#" value="#is_free_amount#">
							<td>
								<ul class="ui-icon-list">
									<li><a href="javascript://" onclick="copy_row_outage('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy"></i></a></li>
									<li><a href="javascript://" onclick="sil_outage('#currentrow#');"><i  class="fa fa-minus"  title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></li>
								</ul>
							</td>
							<td>
								<div class="form-group">
									<input type="text" name="stock_code_outage#currentrow#" id="stock_code_outage#currentrow#" value="#get_product.stock_code#" readonly style="width:120px;">
								</div>
							</td>
							<cfif x_is_barkod_col eq 1>
								<td>
									<div class="form-group">
										<input type="text" name="barcode_outage#currentrow#" id="barcode_outage#currentrow#" value="#get_product.barcod#" readonly style="width:90px;">
									</div>
								</td>
							</cfif>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="product_id_outage#currentrow#" id="product_id_outage#currentrow#" value="#product_id#">
										<input type="hidden" name="stock_id_outage#currentrow#" id="stock_id_outage#currentrow#" value="#stock_id#">
										<input type="text" name="product_name_outage#currentrow#" id="product_name_outage#currentrow#" value="#get_product.product_name# #get_product.property#" readonly style="width:230px;">
										<span class="input-group-addon" onclick="pencere_ac_alternative(2,'#currentrow#',document.form_basket.product_id_outage#currentrow#.value,document.all.stock_id1.value);"><img src="/images/plus_thin.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang dictionary_id ='36839.Alternatif Ürünler'>"></span>
										<span class="input-group-addon" onclick="get_stok_spec_detail_ajax('#product_id#');"><img src="/images/plus_thin_p.gif" style="cursor:pointer;" align="absbottom" border="0" title="<cf_get_lang dictionary_id ='36369.Stok Detay'>"></span>
									</div>
								</div>
							</td>
							<td nowrap="nowrap" style="display:#spec_img_display#;">
								<cfif len(get_row_outage.spect_id)  OR LEN(get_row_outage.SPEC_MAIN_ID) >
									<cfquery name="GET_SPECT" datasource="#dsn3#">
										<cfif len(get_row_outage.spect_id)>
											SELECT SPECT_VAR_NAME FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_outage.spect_id#">
										<cfelse>
											SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_row_outage.SPEC_MAIN_ID#">
										</cfif>
									</cfquery>
									<div class="form-group">
										<div class="col col-3">
											<input type="#Evaluate('spec_display')#" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="#get_row_outage.SPEC_MAIN_ID#" readonly style="width:40px;">
										</div>
										<div class="col col-3">
											<input type="#Evaluate('spec_display')#" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="#get_row_outage.spect_id#" readonly style="width:40px;">
										</div>
										<div class="col col-6">
											<div class="input-group">
												<input type="#Evaluate('spec_name_display')#" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="#get_spect.spect_var_name#" readonly style="width:150px;">
												<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_spect('#currentrow#',2);"></span>
											</div>
										</div>
									</div>
								<cfelse>
									<div class="form-group">
										<div class="col col-3">
											<input type="#Evaluate('spec_display')#" name="spec_main_id_outage#currentrow#" id="spec_main_id_outage#currentrow#" value="" readonly style="width:40px;">
										</div>
										<div class="col col-3">
											<input type="#Evaluate('spec_display')#" name="spect_id_outage#currentrow#" id="spect_id_outage#currentrow#" value="" readonly style="width:40px;">
										</div>
										<div class="col col-6">
											<div class="input-group">
												<input type="#Evaluate('spec_name_display')#" name="spect_name_outage#currentrow#" id="spect_name_outage#currentrow#" value="" readonly style="width:150px;">
												<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_spect('#currentrow#',2);"></span>
											</div>
										</div>
									</div>
								</cfif>
							</td>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="lot_no_outage#currentrow#" id="lot_no_outage#currentrow#" value="#get_row_outage.lot_no#" onKeyup="lotno_control(#currentrow#,3);" style="width:75px;" />
										<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_list_product('#currentrow#','3');"></span>
									</div>
								</div>
							</td>
							<td nowrap>
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="expiration_date_outage#currentrow#" id="expiration_date_outage#currentrow#" value="#dateformat(get_row_outage.expiration_date,dateformat_style)#" style="width:70px;" />
										<span class="input-group-addon"><cf_wrk_date_image date_field="expiration_date_outage#currentrow#"></span>
									</div>
								</div>
							</td>
							<cfset _AMOUNT_ = wrk_round(AMOUNT,round_number,1)>
							<td>
								<div class="form-group">
									<input type="text" name="amount_outage#currentrow#" onchange="find_amount2_outage(#currentrow#);" id="amount_outage#currentrow#" #_readonly_# value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="hesapla_deger(#currentrow#,2);" class="moneybox" style="width:70px;">
									<input type="hidden" name="amount_outage_#currentrow#" id="amount_outage_#currentrow#" value="#TlFormat(_AMOUNT_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));"  onblur="hesapla_deger(#currentrow#,0);" class="moneybox" style="width:60px;">
								</div>
							</td>
							<td>
								<div class="form-group">
									<input type="hidden" name="unit_id_outage#currentrow#" id="unit_id_outage#currentrow#" value="#get_product.product_unit_id#">
									<input type="text" name="unit_outage#currentrow#" id="unit_outage#currentrow#" value="#get_product.main_unit#" readonly style="width:60px;">
									<input type="hidden" name="serial_no_outage#currentrow#" id="serial_no_outage#currentrow#" value="#serial_no#" style="width:150px;">
								</div>
							</td>
							<td>
								<div class="form-group">
									<input type="text" onchange="find_amount2_outage(#currentrow#);Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#);" name="weight_outage#currentrow#" id="weight_outage#currentrow#" value="#TLFormat(get_row_outage.weight,round_number)#">
								</div>
							</td>
							<cfif x_is_show_abh eq 1>
								<td>
									<div class="form-group">
										<input type="text" name="width_outage#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#)" id="width_outage#currentrow#" value="#TLFormat(get_row_outage.width)#" style="width:60px;">
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="text"  name="height_outage#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#)" id="height_outage#currentrow#" value="#TLFormat(get_row_outage.height)#"  style="width:60px;">
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="text" name="length_outage#currentrow#" onchange="Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#)" id="length_outage#currentrow#" value="#TLFormat(get_row_outage.length)#"  style="width:60px;">
									</div>
								</td>
							</cfif>
							<cfif xml_specific_weight eq 1> 
								<td>
									<div class="form-group">
										<input type="text" onchange="find_weight_outage(#currentrow#)" name="specific_weight_outage#currentrow#" id="specific_weight_outage#currentrow#" value="#TLFormat(get_row_outage.specific_weight)#"  style="width:60px;">
									</div>
								</td>
							 </cfif>
							<cfset PURCHASE_NET_ = wrk_round(PURCHASE_NET,8,1)>
							<cfset PURCHASE_NET_2_ = wrk_round(PURCHASE_NET_2,8,1)>
							<cfif get_module_user(5) and session.ep.COST_DISPLAY_VALID neq 1>
								<td>
									<div class="form-group">
										<input type="text" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,8));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,3);"</cfif>>
									</div>
								</td>
								<td>
									<div class="form-group">
										<input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="#PURCHASE_NET_SYSTEM#">
										<input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
										<input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
										<input type="text" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST,8,1),8,0)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,8));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost(#currentrow#,3);"</cfif>>
									</div>
								</td>
								<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
									<td>
										<div class="form-group">
											<input type="text" name="labor_cost_outage#currentrow#" id="labor_cost_outage#currentrow#" value="#TLFormat(labor_cost_system,round_number)#" readonly class="moneybox">
										</div>
									</td>
								</cfif>
								<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
									<td>
										<div class="form-group">
											<input type="text" name="reflection_cost_outage#currentrow#" id="reflection_cost_outage#currentrow#" value="#TLFormat(STATION_REFLECTION_COST_SYSTEM,round_number)#" readonly class="moneybox">
										</div>
									</td>	
								</cfif>	
								<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
									<td>
										<div class="form-group">
											<input type="text" name="total_cost_price_outage#currentrow#" id="total_cost_price_outage#currentrow#" value="#TLFormat((PURCHASE_NET_+PURCHASE_EXTRA_COST)*_AMOUNT_,round_number)#" readonly class="moneybox">
										</div>
									</td>
								</cfif>
								<td>
									<div class="form-group">
										<input type="text" name="money_outage#currentrow#" id="money_outage#currentrow#" value="#PURCHASE_NET_MONEY#" readonly style="width:50px;">
									</div>
								</td>
								<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
									<td><div class="form-group">v<input type="text" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></div></td>
									<td><div class="form-group"><input type="text" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#" onkeyup="return(FormatCurrency(this,event,8));" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly</cfif>></div></td>
									<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
											<td>
											<cfif len(labor_cost_system)>
												<cfset labor_cost_system_ = labor_cost_system / get_money_rate.rate2>
											<cfelse>
												<cfset labor_cost_system_ = labor_cost_system>
											</cfif>
											<div class="form-group"><input type="text" name="labor_cost_outage_2#currentrow#" id="labor_cost_outage_2#currentrow#" value="#TLFormat(labor_cost_system_,round_number)#" readonly class="moneybox"></div>
										</td>
									</cfif>
									<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
										<td>
											<cfif len(STATION_REFLECTION_COST_SYSTEM)>
												<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM / get_money_rate.rate2>
											<cfelse>
												<cfset STATION_REFLECTION_COST_SYSTEM_ = STATION_REFLECTION_COST_SYSTEM>
											</cfif>
											<div class="form-group"><input type="text" name="reflection_cost_outage_2#currentrow#" id="reflection_cost_outage_2#currentrow#" value="#TLFormat(STATION_REFLECTION_COST_SYSTEM_,round_number)#" readonly class="moneybox"></div>
										</td>	
									</cfif>	
									<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
										<td><div class="form-group"><input type="text" name="total_cost_price_outage_2#currentrow#" id="total_cost_price_outage_2#currentrow#" value="#TLFormat((PURCHASE_NET_2_+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1))*_AMOUNT_,round_number)#" readonly class="moneybox"></div></td>
									</cfif>
									<td><div class="form-group"><input type="text" name="money_outage_2#currentrow#" id="money_outage_2#currentrow#" value="#PURCHASE_NET_MONEY_2#" readonly style="width:50px;"></div></td>
								<cfelse>
									<input type="hidden" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#" onkeyup="return(FormatCurrency(this,event,8));">
									<input type="hidden" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),8,0)#">
									<input type="hidden" name="money_outage_2#currentrow#" id="money_outage_2#currentrow#" value="#PURCHASE_NET_MONEY_2#">
								</cfif>
							<cfelse>
								<input type="hidden" name="labor_cost_outage#currentrow#" id="labor_cost_outage#currentrow#" value="#labor_cost_system#">
							<input type="hidden" name="reflection_cost_outage#currentrow#" id="reflection_cost_outage#currentrow#" value="#STATION_REFLECTION_COST_SYSTEM#">
								<input type="hidden" name="cost_price_system_outage#currentrow#" id="cost_price_system_outage#currentrow#" value="#PURCHASE_NET_SYSTEM#">
								<input type="hidden" name="purchase_extra_cost_system_outage#currentrow#" id="purchase_extra_cost_system_outage#currentrow#" value="#wrk_round(PURCHASE_EXTRA_COST_SYSTEM,8,1)#">
								<input type="hidden" name="money_system_outage#currentrow#" id="money_system_outage#currentrow#" value="#PURCHASE_NET_SYSTEM_MONEY#">
								<input type="hidden" name="purchase_extra_cost_outage#currentrow#" id="purchase_extra_cost_outage#currentrow#" value="#TLFormat(PURCHASE_EXTRA_COST,round_number)#" />
								<input type="hidden" name="cost_price_outage#currentrow#" id="cost_price_outage#currentrow#" value="#TLFormat(PURCHASE_NET_,round_number)#">
								<input type="hidden" name="money_outage#currentrow#"  id="money_outage#currentrow#"value="#PURCHASE_NET_MONEY#">
								<input type="hidden" name="cost_price_outage_2#currentrow#" id="cost_price_outage_2#currentrow#" value="#TLFormat(PURCHASE_NET_2_,round_number)#">
								<input type="hidden" name="purchase_extra_cost_outage_2#currentrow#" id="purchase_extra_cost_outage_2#currentrow#" value="#TLFormat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,8,1),round_number)#">
								<input type="hidden" name="money_outage_2#currentrow#"  id="money_outage_2#currentrow#"value="#PURCHASE_NET_MONEY_2#">
							</cfif>
							<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
							<td><div class="form-group"><input type="text" onchange="Get_Product_Unit_2_And_Quantity_2_outage(#currentrow#)" name="amount_outage2_#currentrow#" id="amount_outage2_#currentrow#" value="#TLFormat(AMOUNT2,round_number)#" onkeyup="return(FormatCurrency(this,event,8));" onblur="" class="moneybox" style="width:70px;"></div></td>
							<td>
								<cfset _unit2o_ = UNIT2>
								<cfquery name="get_all_unit2" datasource="#dsn3#">
									SELECT 
										PRODUCT_UNIT_ID,ADD_UNIT
									FROM 
										PRODUCT_UNIT 
									WHERE
										PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">
										AND PRODUCT_UNIT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable#"> 
										AND IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="#variable_#">
								</cfquery>
								<div class="form-group">
									<select name="unit2_outage#currentrow#" id="unit2_outage#currentrow#" style="width:60;">
										<cfloop query="get_all_unit2">
											<option value="#ADD_UNIT#"<cfif _unit2o_ eq ADD_UNIT>selected</cfif>>#ADD_UNIT#</option>
										</cfloop>
									</select>
								</div>
							</td>
							</cfif>
							<td style="display:#product_name2_display#"><div class="form-group"><input type="text" style="width:70px;" name="product_name2_outage#currentrow#" id="product_name2_outage#currentrow#" value="#product_name2#"></div></td>
							<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
								<td>
									<input type="checkbox" name="is_manual_cost_outage#currentrow#" id="is_manual_cost_outage#currentrow#" value="1" <cfif is_manual_cost eq 1>checked</cfif>>
								</td>
							</cfif>
						</tr>
					</cfoutput>
				</tbody>
			</cf_grid_list>
			<cfif get_row_outage.recordcount>
				<div class="ui-info-bottom flex-end">
					<div><a class="ui-wrk-btn ui-wrk-btn-success" onclick="sil_outage_all();"><cf_get_lang dictionary_id="30036.hepsini sil"></a></div>
				</div>
			</cfif>
			</div>
	</cf_box>							
</cfform>

<script language="javascript">

		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&iframe=1</cfoutput>&type=outage','add_prod3',1);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&iframe=1</cfoutput>&type=exit','add_prod2',1);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.popup_add_production_result&iframe=1</cfoutput>','add_prod1',1);

		row_count=<cfoutput>#get_row_enter.recordcount#</cfoutput>;
		row_count_exit=<cfoutput>#get_row_exit.recordcount#</cfoutput>;
		row_count_outage = <cfoutput>#get_row_outage.recordcount#</cfoutput>;
		round_number = <cfoutput>#round_number#</cfoutput>;//xmlden geliyor. miktar kusuratlarini burdan aliyor
		get_process = wrk_safe_query('prdp_get_process','dsn3',0,document.getElementById("process_cat").value);

	function change_row_cost(row_no,type)
	{
		if(type == 2)
		{
			new_cost = filterNum(document.getElementById("cost_price_exit"+row_no).value,round_number);
			extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_exit"+row_no).value,round_number);
			new_money = document.getElementById("money_exit"+row_no).value;
			amount = document.getElementById("amount_exit"+row_no).value;
			kontrol_money = 0;
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.getElementById("hidden_rd_money_"+s).value == new_money)
				{
					rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
					rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
					kontrol_money = 1;
				}
			}
			if(kontrol_money==0){rate1=1;rate2=1;}
			document.getElementById("cost_price_system_exit"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
			document.getElementById("purchase_extra_cost_system_exit"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
			total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
			</cfif>
		}
		else if (type == 3)
		{
			new_cost = filterNum(document.getElementById("cost_price_outage"+row_no).value,round_number);
			extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_outage"+row_no).value,round_number);
			new_money = document.getElementById("money_outage"+row_no).value;
			amount = document.getElementById("amount_outage"+row_no).value;
			kontrol_money = 0;
			for(s=1;s<=document.getElementById("kur_say").value;s++)
			{
				if(document.getElementById("hidden_rd_money_"+s).value == new_money)
				{
					rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
					rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
					kontrol_money = 1;
				}
			}
			if(kontrol_money==0){rate1=1;rate2=1;}
			document.getElementById("cost_price_system_outage"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
			document.getElementById("purchase_extra_cost_system_outage"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
			total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
			</cfif>
		}
		else if(type == 1)
		{
			row_no = 1;
			for (var row_no=1;row_no<=row_count_exit;row_no++)//sarflarin satirdaki maliyetlerini gunceliiyor
			{
				if(document.getElementById("row_kontrol_exit"+row_no).value==1)// sarf ürün satırı olması için kontrol eklendi.
				{
					new_cost = filterNum(document.getElementById("cost_price_exit"+row_no).value,round_number);
					extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_exit"+row_no).value,round_number);
					new_money = document.getElementById("money_exit"+row_no).value;
					amount = document.getElementById("amount_exit"+row_no).value;
					kontrol_money = 0;
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.getElementById("hidden_rd_money_"+s).value == new_money)
						{
							rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
							rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
							kontrol_money = 1;
						}
					}
					if(kontrol_money==0){rate1=1;rate2=1;}
					document.getElementById("cost_price_system_exit"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
					document.getElementById("purchase_extra_cost_system_exit"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
					total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
					<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
					document.getElementById("total_cost_price_exit"+row_no).value = commaSplit(total_cost,round_number);
					</cfif>
				}
			}
			for (var row_no=1;row_no<=row_count_outage;row_no++)//firelerin satirdaki maliyetlerini gunceliiyor
			{
				if(document.getElementById("row_kontrol_outage"+row_no).value==1)// fire ürün satırı olması için kontrol eklendi.
				{
					new_cost = filterNum(document.getElementById("cost_price_outage"+row_no).value,round_number);
					extra_new_cost = filterNum(document.getElementById("purchase_extra_cost_outage"+row_no).value,round_number);
					new_money = document.getElementById("money_outage"+row_no).value;
					amount = document.getElementById("amount_outage"+row_no).value;
					kontrol_money = 0;
					for(s=1;s<=document.getElementById("kur_say").value;s++)
					{
						if(document.getElementById("hidden_rd_money_"+s).value == new_money)
						{
							rate1 = filterNum(document.getElementById("txt_rate1_"+s).value);
							rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
							kontrol_money = 1;
						}
					}
					if(kontrol_money==0){rate1=1;rate2=1;}
					document.getElementById("cost_price_system_outage"+row_no).value = parseFloat(new_cost)*parseFloat(rate2);
					document.getElementById("purchase_extra_cost_system_outage"+row_no).value = parseFloat(extra_new_cost)*parseFloat(rate2);
					total_cost = (parseFloat(new_cost)+parseFloat(extra_new_cost))*parseFloat(filterNum(amount,round_number),round_number);
					<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
					document.getElementById("total_cost_price_outage"+row_no).value = commaSplit(total_cost,round_number);
					</cfif>
				}
			}
		}
	}
	function counter(field, countfield, maxlimit){ 
		if(field.value.length > maxlimit){ 
			field.value = field.value.substring(0, maxlimit);
			alert("Max "+maxlimit+"!"); 
		}
		else 
			countfield.value = maxlimit - field.value.length; 
	} 
	function kontrol2()
	{
		if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
		if (!process_cat_control()) return false;
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		form_basket.del_pr_order_id.value = <cfoutput>#get_Detail.pr_order_id#</cfoutput>;
		if(get_process.IS_ZERO_STOCK_CONTROL == 1)
		{
			if(!zero_stock_control(1)) return false; 
		}
		<cfif x_fis_kontrol eq 1 and isdefined("get_ship_kontrol") and get_ship_kontrol.recordcount and get_ship_kontrol.is_delivered eq 1>
			alert("<cf_get_lang dictionary_id='60508.Oluşan Sevk İrsaliyesi Teslim Alınmıştır. Lütfen Teslim Al Seçeneğini Kaldırınız'> !");
			return false
		</cfif>
		return true;
	}
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
	function sil_exit(sy)
	{
		var my_element=document.getElementById("row_kontrol_exit"+sy);
		my_element.value=0;

		var my_element=eval("frm_row_exit"+sy);
		my_element.style.display="none";
	}
	function sil_exit_all()
	{
		for(i=1;i<=<cfoutput>#get_row_exit.recordcount#</cfoutput>;i++)
		{
				document.getElementById('frm_row_exit' + i).style.display="none";
				//my_element.parentNode.removeChild(my_element);
				document.getElementById("row_kontrol_exit"+i).value = 0;
		}
	}
	
	function sil_outage(sy)
	{
		var my_element=document.getElementById("row_kontrol_outage"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_outage"+sy);
		my_element.style.display="none";
	}
	function sil_outage_all(sy)
	{
		for(i=1;i<=<cfoutput>#get_row_outage.recordcount#</cfoutput>;i++)
		{
				document.getElementById('frm_row_outage' + i).style.display="none";
				document.getElementById("row_kontrol_outage"+i).value = 0;
		}
	}
	//iframe çalıstiriyor add_row fonksiyonunu
	<!--- XX --->
	function add_row(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name)
	{
		row_count++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		document.getElementById("record_num").value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		//newCell.innerHTML = '<input type="hidden" name="tree_type_' + row_count +'" id="tree_type_' + row_count +'" value="S"><input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="Sil"></i></a><input type="hidden" name="cost_id' + row_count +'" id="cost_id' + row_count +'" value="'+cost_id+'"><input type="hidden" name="product_cost' + row_count +'" id="product_cost' + row_count +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money' + row_count +'" id="product_cost_money' + row_count +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system' + row_count +'" id="cost_price_system' + row_count +'" value="'+cost_price_system+'"><input type="hidden" name="money_system' + row_count +'" id="money_system' + row_count +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost' + row_count +'" id="purchase_extra_cost' + row_count +'" value="'+purchase_extra_cost+'"><input type="hidden" name="purchase_extra_cost_system' + row_count +'" id="purchase_extra_cost_system' + row_count +'" value="'+purchase_extra_cost_system+'"><cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1><input type="hidden" name="cost_price_extra_2' + row_count +'" id="cost_price_extra_2' + row_count +'" value="'+purchase_extra_cost_2+'" readonly class="moneybox"></cfif>';
		newCell.innerHTML = '<input type="hidden" name="tree_type_' + row_count +'" id="tree_type_' + row_count +'" value="S"><input type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a href="javascript://" onclick="sil(' + row_count + ');"><i class="fa fa-minus" alt="Sil"></i></a><input type="hidden" name="cost_id' + row_count +'" id="cost_id' + row_count +'" value="'+cost_id+'"><input type="hidden" name="product_cost' + row_count +'" id="product_cost' + row_count +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money' + row_count +'" id="product_cost_money' + row_count +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system' + row_count +'" id="cost_price_system' + row_count +'" value="'+cost_price_system+'"><input type="hidden" name="money_system' + row_count +'" id="money_system' + row_count +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost' + row_count +'" id="purchase_extra_cost' + row_count +'" value="'+purchase_extra_cost+'"><cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1><input type="hidden" name="cost_price_extra_2' + row_count +'" id="cost_price_extra_2' + row_count +'" value="'+purchase_extra_cost_2+'" readonly class="moneybox"></cfif>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="stock_code' + row_count +'" id="stock_code' + row_count +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount' + row_count +'" id="kdv_amount' + row_count +'" value="'+tax+'"></div>';
		<cfif x_is_barkod_col eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="barcode' + row_count +'" id="barcode' + row_count +'" value="'+barcode+'" readonly style="width:90px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+product_id+'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" value="'+ product_name + property +'" readonly style="width:230px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";	
		newCell.innerHTML = '<div class="form-group"><div class="col col-3"><input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id' + row_count +'" id="spec_main_id' + row_count +'" value="'+spect_main_id+'" readonly style="width:40px;"></div><div class="col col-3"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id' + row_count +'" id="spect_id' + row_count +'" value="" readonly style="width:40px;"></div><div class="col col-6"><div class="input-group"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name' + row_count +'" id="spect_name' + row_count +'"value="'+spect_name+'" readonly style="width:150px;"><span class="input-group-addon icon-ellipsis"  onClick="pencere_ac_spect('+ row_count +');"></span></div></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount' + row_count +'" id="amount' + row_count +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:70px;"></div>';
		<cfif isdefined("x_is_fire_product") and x_is_fire_product eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="fire_amount_' + row_count +'" id="fire_amount_' + row_count +'" value="0" onKeyup="return(FormatCurrency(this,event,8));" onBlur="hesapla_deger(' + row_count +',1);" class="moneybox" style="width:60px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" value="'+product_unit_id+'" name="unit_id' + row_count +'" id="unit_id' + row_count +'"><input type="text" name="unit' + row_count +'" id="unit' + row_count +'" value="'+main_unit+'" readonly style="width:60px;"></div>';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="dimention' + row_count +'" id="dimention' + row_count +'" value="'+dimention+'" readonly style="width:60px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price' + row_count +'" id="cost_price' + row_count +'" value="'+cost_price+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="purchase_extra_cost_system' + row_count +'" id="purchase_extra_cost_system' + row_count +'" value="'+purchase_extra_cost_system+'">';
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price' + row_count +'" id="total_cost_price' + row_count +'" value="'+commaSplit(filterNum(cost_price,round_number) * filterNum(amount,round_number),round_number)+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
		</cfif>
		<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="labor_cost' + row_count +'" id="labor_cost' + row_count +'" value="" class="moneybox" style="width:0px;"><input type="text" name="____labor_cost' + row_count +'" id="____labor_cost' + row_count +'" value="" style="width:90px;">';
			newCell.innerHTML = '<div class="form-group"><input type="text" name="____labor_cost_total' + row_count +'" id="____labor_cost_total' + row_count +'" value="" class="moneybox" style="width:0px;"></div>';
		</cfif>
		<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="hidden" name="station_reflection_cost_system' + row_count +'" id="station_reflection_cost_system' + row_count +'" value="" class="moneybox" style="width:0px;"><input type="text" name="____station_reflection_cost_system' + row_count +'" id="____station_reflection_cost_system' + row_count +'" value="" style="width:90px;"></div>'
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<div class="form-group"><input type="text" name="____station_reflection_cost_system_total' + row_count +'" id="____station_reflection_cost_system_total' + row_count +'" value="" class="moneybox" style="width:0px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="money' + row_count +'" id="money' + row_count +'" value="'+cost_price_money+'" readonly style="width:50px;"></div>';	
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_2' + row_count +'" id="cost_price_2' + row_count +'" value="'+cost_price_2+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_extra_2' + row_count +'" id="cost_price_extra_2' + row_count +'" value="'+cost_price_2+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_2' + row_count +'" id="total_cost_price_2' + row_count +'" value="'+commaSplit(filterNum(cost_price_2,round_number) * filterNum(amount,round_number),round_number)+'" readonly style="width:125px;" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
			</cfif>
		</cfif>
		<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="____labor_cost2_' + row_count +'" id="____labor_cost2_' + row_count +'" value="" style="width:90px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="____labor_cost2_total' + row_count +'" id="____labor_cost2_total' + row_count +'" value="" style="width:90px;"></div>';
		</cfif>
		<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="____station_reflection_cost_system2_' + row_count +'" id="____station_reflection_cost_system2_' + row_count +'" value="" style="width:90px;"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="____station_reflection_cost_system2_total' + row_count +'" id="____station_reflection_cost_system2_total' + row_count +'" value="" style="width:90px;"></div>';
		</cfif>
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="money_2' + row_count +'" id="money_2' + row_count +'" value="'+cost_price_money_2+'" readonly style="width:50px;"></div>';	
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount2_' + row_count +'" id="amount2_' + row_count +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;"></div>';
		//2.birim ekleme
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
		var unit2_values ='<div class="form-group"><select name="unit2'+row_count+'" id="unit2'+row_count+'" style="width:60;">';
		if(get_Unit2_Prod.recordcount){
		for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
			unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
		}
		unit2_values +='</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ''+unit2_values+'';
		//2.birim ekleme bitti.
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell.innerHTML = '<div class="form-group"><input type="text" style="width:70px;" name="product_name2' + row_count +'" id="product_name2' + row_count +'" value=""></div>';
		//2.birim ekleme bitti.
	}
	satir_sarf = document.getElementById("table2").rows.length;
	function add_row_exit(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name,expiration_date_exit)
	{
		row_count_exit++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2_body").insertRow(document.getElementById("table2_body").rows.length);
		newRow.setAttribute("name","frm_row_exit" + row_count_exit);
		newRow.setAttribute("id","frm_row_exit" + row_count_exit);
		newRow.setAttribute("NAME","frm_row_exit" + row_count_exit);
		newRow.setAttribute("ID","frm_row_exit" + row_count_exit);
		document.getElementById("record_num_exit").value = row_count_exit;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML = '<input type="hidden" name="is_production_spect_exit' + row_count_exit +'" id="is_production_spect_exit' + row_count_exit +'" value="'+ is_production +'"><input type="hidden" name="is_add_info_' + row_count_exit +'" id="is_add_info_' + row_count_exit +'" value="1"><input type="hidden" name="tree_type_exit_' + row_count_exit +'" id="tree_type_exit_' + row_count_exit +'" value="S"><input type="hidden" name="row_kontrol_exit' + row_count_exit +'" id="row_kontrol_exit' + row_count_exit +'" value="1"><a href="javascript://" onclick="copy_row_exit('+row_count_exit+');" title="<cf_get_lang dictionary_id="58972.Satır Kopyala">"><i class="fa fa-copy"></i></a> <a href="javascript://" onclick="sil_exit(' + row_count_exit + ');"><i class="fa fa-minus" alt="Sil"></i></a><input type="hidden" name="cost_id_exit' + row_count_exit +'" id="cost_id_exit' + row_count_exit +'" value="'+cost_id+'"><input type="hidden" name="product_cost_exit' + row_count_exit +'" id="product_cost_exit' + row_count_exit +'" value="'+product_cost+'"><input type="hidden" name="product_cost_money_exit' + row_count_exit +'" id="product_cost_money_exit' + row_count_exit +'" value="'+product_cost_money+'"><input type="hidden" name="cost_price_system_exit' + row_count_exit +'" id="cost_price_system_exit' + row_count_exit +'" value="'+cost_price_system+'"><input type="hidden" name="money_system_exit' + row_count_exit +'" id="money_system_exit' + row_count_exit +'" value="'+cost_price_system_money+'"><input type="hidden" name="purchase_extra_cost_system_exit' + row_count_exit +'" id="purchase_extra_cost_system_exit' + row_count_exit +'" value="'+purchase_extra_cost_system+'">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="stock_code_exit' + row_count_exit +'" id="stock_code_exit' + row_count_exit +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount_exit' + row_count_exit +'" id="kdv_amount_exit' + row_count_exit +'" value="'+tax+'"></div>';
		<cfif x_is_barkod_col eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="barcode_exit' + row_count_exit +'" id="barcode_exit' + row_count_exit +'" value="'+barcode+'" readonly style="width:90px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_id_exit' + row_count_exit +'" id="product_id_exit' + row_count_exit +'" value="'+product_id+'"><input type="hidden" name="stock_id_exit' + row_count_exit +'" id="stock_id_exit' + row_count_exit +'" value="'+stock_id+'"><input type="text" name="product_name_exit' + row_count_exit +'" id="product_name_exit' + row_count_exit +'" value="'+ product_name + property +'" readonly style="width:230px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = ' <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id_exit' + row_count_exit +'" id="spec_main_id_exit' + row_count_exit +'"  value="'+spect_main_id+'" readonly style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id_exit' + row_count_exit +'" id="spect_id_exit' + row_count_exit +'" value="" style="width:40px;"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name_exit' + row_count_exit +'" id="spect_name_exit' + row_count_exit +'" value="'+spect_name+'" readonly style="width:160px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="lot_no_exit' + row_count_exit +'" id="lot_no_exit' + row_count_exit +'" value="" onKeyup="lotno_control('+ row_count_exit +',2);" style="width:75px;"> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_list_product('+ row_count_exit +',2);"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","expiration_date_exit" + row_count_exit + "_td");
		newCell.innerHTML = '<input type="text" name="expiration_date_exit' + row_count_exit +'" id="expiration_date_exit' + row_count_exit +'" value=""  style="width:70px;"> ';
		wrk_date_image('expiration_date_exit' + row_count_exit);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount_exit' + row_count_exit +'" id="amount_exit' + row_count_exit +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count_exit +',0);" class="moneybox" style="width:70px;"><input type="hidden" name="amount_exit_' + row_count_exit +'" id="amount_exit_' + row_count_exit +'" value="'+commaSplit(filterNum(amount,6),6)+'"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="unit_id_exit' + row_count_exit +'" id="unit_id_exit' + row_count_exit +'" value="'+product_unit_id+'"><input type="text" name="unit_exit' + row_count_exit +'" id="unit_exit' + row_count_exit +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no_exit' + row_count_exit +'" id="serial_no_exit' + row_count_exit +'" value="'+serial+'"></div>';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="dimention_exit' + row_count_exit +'" id="dimention_exit' + row_count_exit +'" value="'+dimention+'" readonly style="width:60px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_exit' + row_count_exit +'" id="cost_price_exit' + row_count_exit +'" value="'+cost_price+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif>></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="purchase_extra_cost_exit' + row_count_exit +'" id="purchase_extra_cost_exit' + row_count_exit +'" value="'+purchase_extra_cost+'"  onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_exit+',2);"</cfif> class="moneybox"></div>';
		<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="labor_cost_exit' + row_count +'" id="labor_cost_exit' + row_count +'" value="" style="width:90px;"></div>';
		</cfif>
		<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="reflection_cost_exit' + row_count +'" id="reflection_cost_exit' + row_count +'" value="" style="width:90px;"></div>';
		</cfif>
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_exit' + row_count_exit +'" id="total_cost_price_exit' + row_count_exit +'" value="'+commaSplit((parseFloat(filterNum(cost_price,round_number))+parseFloat(filterNum(purchase_extra_cost,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="money_exit' + row_count_exit +'" id="money_exit' + row_count_exit +'" value="'+cost_price_money+'" readonly style="width:50px;"></div>';
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_exit_2' + row_count_exit +'" id="cost_price_exit_2' + row_count_exit +'" value="'+cost_price_2+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="purchase_extra_cost_exit_2' + row_count_exit +'" id="purchase_extra_cost_exit_2' + row_count_exit +'" value="'+purchase_extra_cost_2+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly</cfif> class="moneybox"></div>';
			<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="labor_cost_exit_2' + row_count +'" id="labor_cost_exit_2' + row_count +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="reflection_cost_exit_2' + row_count +'" id="reflection_cost_exit_2' + row_count +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_exit_2' + row_count_exit +'" id="total_cost_price_exit_2' + row_count_exit +'" value="'+commaSplit((parseFloat(filterNum(cost_price_2,round_number))+parseFloat(filterNum(purchase_extra_cost_2,round_number)))*filterNum(amount,round_number),round_number)+'" class="moneybox" readonly></div>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="money_exit_2' + row_count_exit +'" id="money_exit_2' + row_count_exit +'" value="'+cost_price_money_2+'" readonly style="width:50px;"></div>';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount_exit2_' + row_count_exit +'" id="amount_exit2_' + row_count_exit +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;"></div>';
		//2.birim ekleme
		var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
		var unit2_values ='<div class="form-group"><select name="unit2_exit'+row_count_exit+'" id="unit2_exit'+row_count_exit+'" style="width:60;">';
		if(get_Unit2_Prod.recordcount){
		for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
			unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
		}
		unit2_values +='</select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ''+unit2_values+'';
		//2.birim ekleme bitti.
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell.innerHTML = '<div class="form-group"><input type="text" style="width:70px;" name="product_name2_exit' + row_count_exit +'" id="product_name2_exit' + row_count_exit +'" value=""></div>';
		<cfif isdefined("x_is_show_sb") and x_is_show_sb eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_sevkiyat' + row_count_exit +'" id="is_sevkiyat' + row_count_exit +'" value="1">';
		</cfif>
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_exit' + row_count_exit +'" id="is_manual_cost_exit' + row_count_exit +'" value="1">';
		</cfif>
	}
	
	function add_row_outage(stock_id,product_id,stock_code,product_name,property,barcode,main_unit,product_unit_id,amount,tax,cost_id,cost_price,cost_price_money,cost_price_2,purchase_extra_cost_2,cost_price_money_2,cost_price_system,cost_price_system_money,purchase_extra_cost,purchase_extra_cost_system,product_cost,product_cost_money,serial,is_production,dimention,spect_main_id,spect_name,expiration_date_outage)

	{
		row_count_outage++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table3_body").insertRow(document.getElementById("table3_body").rows.length);
		newRow.setAttribute("name","frm_row_outage" + row_count_outage);
		newRow.setAttribute("id","frm_row_outage" + row_count_outage);
		newRow.setAttribute("NAME","frm_row_outage" + row_count_outage);
		newRow.setAttribute("ID","frm_row_outage" + row_count_outage);
		document.getElementById("record_num_outage").value = row_count_outage;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.textAlign="center";
		newCell.innerHTML  ='<input type="hidden" name="row_kontrol_outage' + row_count_outage +'" id="row_kontrol_outage' + row_count_outage +'" value="1">';
		newCell.innerHTML +='<a href="javascript://" onclick="copy_row_outage('+row_count_outage+');" title="<cf_get_lang dictionary_id="58972.Satır Kopyala">"><i class="fa fa-copy"></i></a> ';
		newCell.innerHTML +='<a href="javascript://" onclick="sil_outage(' + row_count_outage + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id="57463.Sil">"></i></a>';
		newCell.innerHTML +='<input type="hidden" name="cost_id_outage' + row_count_outage +'" id="cost_id_outage' + row_count_outage +'" value="'+cost_id+'">';
		newCell.innerHTML +='<input type="hidden" name="product_cost_outage' + row_count_outage +'" id="product_cost_outage' + row_count_outage +'" value="'+product_cost+'">';
		newCell.innerHTML +='<input type="hidden" name="product_cost_money_outage' + row_count_outage +'" id="product_cost_money_outage' + row_count_outage +'" value="'+product_cost_money+'">';
		newCell.innerHTML +='<input type="hidden" name="cost_price_system_outage' + row_count_outage +'" id="cost_price_system_outage' + row_count_outage +'" value="'+cost_price_system+'">';
		newCell.innerHTML +='<input type="hidden" name="money_system_outage' + row_count_outage +'" id="money_system_outage' + row_count_outage +'" value="'+cost_price_system_money+'">';
		newCell.innerHTML +='<input type="hidden" name="purchase_extra_cost_system_outage' + row_count_outage +'" id="purchase_extra_cost_system_outage' + row_count_outage +'" value="'+purchase_extra_cost_system+'">';'';
		
		newCell.setAttribute('nowrap','nowrap');
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="stock_code_outage' + row_count_outage +'" id="stock_code_outage' + row_count_outage +'" value="'+stock_code+'" readonly style="width:120px;"><input type="hidden" name="kdv_amount_outage' + row_count_outage +'" id="kdv_amount_outage' + row_count_outage +'" value="'+tax+'"></div>';
		<cfif x_is_barkod_col eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="barcode_outage' + row_count_outage +'" id="barcode_outage' + row_count_outage +'" value="'+barcode+'" readonly style="width:90px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="product_id_outage' + row_count_outage +'" id="product_id_outage' + row_count_outage +'" value="'+product_id+'"><input type="hidden" name="stock_id_outage' + row_count_outage +'" id="stock_id_outage' + row_count_outage +'" value="'+stock_id+'"><input type="text" name="product_name_outage' + row_count_outage +'" id="product_name_outage' + row_count_outage +'" value="'+ product_name + property +'" readonly style="width:230px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.display = "<cfoutput>#spec_img_display#</cfoutput>";
		newCell.innerHTML = ' <div class="form-group"><div class="col col-3"><input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spec_main_id_outage' + row_count_outage +'" id="spec_main_id_outage' + row_count_outage +'" value="'+spect_main_id+'" readonly style="width:40px;"></div><div class="col col-3"> <input type="<cfoutput>#Evaluate('spec_display')#</cfoutput>" name="spect_id_outage' + row_count_outage +'" id="spect_id_outage' + row_count_outage +'" value="" style="width:40px;"></div><div class="col col-6"><div class="input-group"> <input type="<cfoutput>#Evaluate('spec_name_display')#</cfoutput>" name="spect_name_outage' + row_count_outage +'" id="spect_name_outage' + row_count_outage +'" value="'+spect_name+'" readonly style="width:150px;"> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_spect('+ row_count_outage +',3);"></span></div></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="lot_no_outage' + row_count_outage +'" id="lot_no_outage' + row_count_outage +'" value="" onKeyup="lotno_control('+ row_count_outage +',3);" style="width:75px;"> <span class="input-group-addon icon-ellipsis" onClick="pencere_ac_list_product('+ row_count_outage +',3);"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","expiration_date_outage" + row_count_outage + "_td");
		newCell.innerHTML = '<div class="form-group"><input type="text" name="expiration_date_outage' + row_count_outage +'" id="expiration_date_outage' + row_count_outage +'" value=""  style="width:70px;"></div> ';
		wrk_date_image('expiration_date_outage' + row_count_outage);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="amount_outage' + row_count_outage +'" id="amount_outage' + row_count_outage +'" value="'+commaSplit(filterNum(amount,6),6)+'" onKeyup="return(FormatCurrency(this,event,6));" onBlur="hesapla_deger(' + row_count_outage +',2);" class="moneybox" style="width:70px;"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" value="'+product_unit_id+'" name="unit_id_outage' + row_count_outage +'" id="unit_id_outage' + row_count_outage +'"><input type="text" name="unit_outage' + row_count_outage +'" id="unit_outage' + row_count_outage +'" value="'+main_unit+'" readonly style="width:60px;"><input type="hidden" name="serial_no_outage' + row_count_outage +'" id="serial_no_outage' + row_count_outage +'" value="'+serial+'"></div>';
		<cfif isdefined('x_is_show_abh') and x_is_show_abh eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="dimention_outage' + row_count_outage +'" id="dimention_outage' + row_count_outage +'" value="'+dimention+'" readonly style="width:60px;"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_outage' + row_count_outage +'" id="cost_price_outage' + row_count_outage +'" value="'+cost_price+'" class="moneybox" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_outage+',3);"</cfif> onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="purchase_extra_cost_outage' + row_count_outage +'" id="purchase_extra_cost_outage' + row_count_outage +'" value="'+purchase_extra_cost+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly<cfelse>onBlur="change_row_cost('+row_count_outage+',3);"</cfif> class="moneybox"></div>';
		<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="labor_cost_outage' + row_count +'" id="labor_cost_outage' + row_count +'" value="" style="width:90px;"></div>';
		</cfif>
		<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="reflection_cost_outage' + row_count +'" id="reflection_cost_outage' + row_count +'" value="" style="width:90px;"></div>';
		</cfif>
		<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_outage' + row_count_outage +'" id="total_cost_price_outage' + row_count_outage +'" value="'+commaSplit((parseFloat(filterNum(cost_price,round_number))+parseFloat(filterNum(purchase_extra_cost,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="money_outage' + row_count_outage +'" id="money_outage' + row_count_outage +'" value="'+cost_price_money+'" readonly style="width:50px;"></div>';
		<cfif isdefined("x_is_cost_price_2") and x_is_cost_price_2 eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="cost_price_outage_2' + row_count_outage +'" id="cost_price_outage_2' + row_count_outage +'" value="'+cost_price_2+'" class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="purchase_extra_cost_outage_2' + row_count_outage +'" id="purchase_extra_cost_outage_2' + row_count_outage +'" value="'+purchase_extra_cost_2+'" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));" <cfif is_change_sarf_cost eq 0>readonly</cfif> class="moneybox"></div>';
			<cfif x_is_show_labor_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="labor_cost_outage_2' + row_count +'" id="labor_cost_outage_2' + row_count +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif x_is_show_refl_cost eq 1 and GET_DETAIL.IS_DEMONTAJ eq 0>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="reflection_cost_outage_2' + row_count +'" id="reflection_cost_outage_2' + row_count +'" value="" style="width:90px;"></div>';
			</cfif>
			<cfif isdefined("x_is_show_total_cost_price") and x_is_show_total_cost_price eq 1>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="total_cost_price_outage_2' + row_count_outage +'" id="total_cost_price_outage_2' + row_count_outage +'" value="'+commaSplit((parseFloat(filterNum(cost_price_2,round_number))+parseFloat(filterNum(purchase_extra_cost_2,round_number)))*filterNum(amount,round_number),round_number)+'" readonly class="moneybox" onKeyup="return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));"></div>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="money_outage_2' + row_count_outage +'" id="money_outage_2' + row_count_outage +'" value="'+cost_price_money_2+'" readonly style="width:50px;"></div>';
		</cfif>
		<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="amount_outage2_' + row_count_outage +'" id="amount_outage2_' + row_count_outage +'" value="" onKeyup="return(FormatCurrency(this,event,6));" onBlur="" class="moneybox" style="width:70px;"></div>';
			//2.birim ekleme
			var get_Unit2_Prod = wrk_safe_query('prdp_get_unit2_prod','dsn3',0,product_id)
			var unit2_values ='<div class="form-group"><select name="unit2_outage'+row_count_outage+'" id="unit2_outage'+row_count_outage+'" style="width:60;">';
			if(get_Unit2_Prod.recordcount){
			for(xx=0;xx<get_Unit2_Prod.recordcount;xx++)
				unit2_values += '<option value="'+get_Unit2_Prod.ADD_UNIT[xx]+'">'+get_Unit2_Prod.ADD_UNIT[xx]+'</option>';
			}
			unit2_values +='</select></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = ''+unit2_values+'';
		</cfif>
		newCell.style.display = "<cfoutput>#product_name2_display#</cfoutput>";
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" style="width:50px;" name="product_name2_outage' + row_count_outage +'" id="product_name2_outage' + row_count_outage +'" value="'+cost_price_money_2+'"></div>';
		//2.birim ekleme bitti.
		<cfif isdefined('x_is_show_mc') and x_is_show_mc eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_manual_cost_outage' + row_count_outage +'" id="is_manual_cost_outage' + row_count_outage +'" value="1">';
		</cfif>
		
	}
	function copy_row_exit(no_info)
	{
		if (document.getElementById("is_production_spect_exit" + no_info) == undefined) is_production_spect_exit =""; else is_production_spect_exit = document.getElementById("is_production_spect_exit" + no_info).value;
		if (document.getElementById("is_add_info_" + no_info) == undefined) is_add_info_ =""; else is_add_info_ = document.getElementById("is_add_info_" + no_info).value;
		if (document.getElementById("product_cost_money_exit" + no_info) == undefined) product_cost_money_exit =""; else product_cost_money_exit = document.getElementById("product_cost_money_exit" + no_info).value;
		if (document.getElementById("stock_code_exit" + no_info) == undefined) stock_code_exit =""; else stock_code_exit = document.getElementById("stock_code_exit" + no_info).value;
		if (document.getElementById("barcode_exit" + no_info) == undefined) barcode_exit =""; else barcode_exit = document.getElementById("barcode_exit" + no_info).value;
		if (document.getElementById("product_id_exit" + no_info) == undefined) product_id_exit =""; else product_id_exit = document.getElementById("product_id_exit" + no_info).value;
		if (document.getElementById("spec_main_id_exit" + no_info) == undefined) spec_main_id_exit =""; else spec_main_id_exit = document.getElementById("spec_main_id_exit" + no_info).value;
		if (document.getElementById("lot_no_exit" + no_info) == undefined) lot_no_exit =""; else lot_no_exit = document.getElementById("lot_no_exit" + no_info).value;
		if (document.getElementById("amount_exit" + no_info) == undefined) amount_exit =""; else amount_exit = document.getElementById("amount_exit" + no_info).value;
		if (document.getElementById("unit_id_exit" + no_info) == undefined) unit_id_exit =""; else unit_id_exit = document.getElementById("unit_id_exit" + no_info).value;
		if (document.getElementById("dimention_exit" + no_info) == undefined) dimention_exit =""; else dimention_exit = document.getElementById("dimention_exit" + no_info).value;
		if (document.getElementById("cost_price_exit" + no_info) == undefined) cost_price_exit =""; else cost_price_exit = document.getElementById("cost_price_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_exit" + no_info) == undefined) purchase_extra_cost_exit =""; else purchase_extra_cost_exit = document.getElementById("purchase_extra_cost_exit" + no_info).value;
		if (document.getElementById("total_cost_price_exit" + no_info) == undefined) total_cost_price_exit =""; else total_cost_price_exit = document.getElementById("total_cost_price_exit" + no_info).value;
		if (document.getElementById("money_exit" + no_info) == undefined) money_exit =""; else money_exit = document.getElementById("money_exit" + no_info).value;
		if (document.getElementById("cost_price_exit_2" + no_info) == undefined) cost_price_exit_2 =""; else cost_price_exit_2 = document.getElementById("cost_price_exit_2" + no_info).value;
		if (document.getElementById("total_cost_price_exit_2" + no_info) == undefined) total_cost_price_exit_2 =""; else total_cost_price_exit_2 = document.getElementById("total_cost_price_exit_2" + no_info).value;
		if (document.getElementById("money_exit_2" + no_info) == undefined) money_exit_2 =""; else money_exit_2 = document.getElementById("money_exit_2" + no_info).value;
		if (document.getElementById("amount_exit2_" + no_info) == undefined)  amount_exit2_ =""; else  amount_exit2_ = document.getElementById("amount_exit2_" + no_info).value;
		if (document.getElementById("product_name2_exit" + no_info) == undefined)  product_name2_exit =""; else  product_name2_exit = document.getElementById("product_name2_exit" + no_info).value;
		if (document.getElementById("is_sevkiyat" + no_info) == undefined) is_sevkiyat =""; else is_sevkiyat = document.getElementById("is_sevkiyat" + no_info).value;
		if (document.getElementById("is_manual_cost_exit" + no_info) == undefined) is_manual_cost_exit =""; else is_manual_cost_exit = document.getElementById("is_manual_cost_exit" + no_info).value;
		if (document.getElementById("tree_type_exit_" + no_info) == undefined) tree_type_exit_ =""; else tree_type_exit_ = document.getElementById("tree_type_exit_" + no_info).value;
		if (document.getElementById("row_kontrol_exit" + no_info) == undefined) row_kontrol_exit =""; else row_kontrol_exit = document.getElementById("row_kontrol_exit" + no_info).value;
		if (document.getElementById("cost_id_exit" + no_info) == undefined) cost_id_exit =""; else cost_id_exit = document.getElementById("cost_id_exit" + no_info).value;
		if (document.getElementById("product_cost_exit" + no_info) == undefined) product_cost_exit =""; else product_cost_exit = document.getElementById("product_cost_exit" + no_info).value;
		if (document.getElementById("cost_price_system_exit" + no_info) == undefined) cost_price_system_exit =""; else cost_price_system_exit = document.getElementById("cost_price_system_exit" + no_info).value;
		if (document.getElementById("money_system_exit" + no_info) == undefined) money_system_exit =""; else money_system_exit = document.getElementById("money_system_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_system_exit" + no_info) == undefined) purchase_extra_cost_system_exit =""; else purchase_extra_cost_system_exit = document.getElementById("purchase_extra_cost_system_exit" + no_info).value;
		if (document.getElementById("purchase_extra_cost_exit_2" + no_info) == undefined) purchase_extra_cost_exit_2 =""; else purchase_extra_cost_exit_2 = document.getElementById("purchase_extra_cost_exit_2" + no_info).value;
		if (document.getElementById("amount_exit_" + no_info) == undefined) amount_exit_ =""; else amount_exit_ = document.getElementById("amount_exit_" + no_info).value;
		if (document.getElementById("kdv_amount_exit" + no_info) == undefined) kdv_amount_exit =""; else kdv_amount_exit = document.getElementById("kdv_amount_exit" + no_info).value;
		if (document.getElementById("stock_id_exit" + no_info) == undefined) stock_id_exit =""; else stock_id_exit = document.getElementById("stock_id_exit" + no_info).value;
		if (document.getElementById("product_name_exit" + no_info) == undefined) product_name_exit =""; else product_name_exit = document.getElementById("product_name_exit" + no_info).value;
		if (document.getElementById("spect_id_exit" + no_info) == undefined) spect_id_exit =""; else spect_id_exit = document.getElementById("spect_id_exit" + no_info).value;
		if (document.getElementById("spect_name_exit" + no_info) == undefined) spect_name_exit =""; else spect_name_exit = document.getElementById("spect_name_exit" + no_info).value;
		if (document.getElementById("unit_exit" + no_info) == undefined) unit_exit =""; else unit_exit = document.getElementById("unit_exit" + no_info).value;
		if (document.getElementById("serial_no_exit" + no_info) == undefined) serial_no_exit =""; else serial_no_exit = document.getElementById("serial_no_exit" + no_info).value;
		if (document.getElementById("expiration_date_exit" + no_info) == undefined) expiration_date_exit =""; else expiration_date_exit = document.getElementById("expiration_date_exit" + no_info).value;
		add_row_exit(stock_id_exit,product_id_exit,stock_code_exit,product_name_exit,'',barcode_exit,unit_exit,unit_id_exit,amount_exit,kdv_amount_exit,cost_id_exit,cost_price_exit,money_exit,cost_price_exit_2,purchase_extra_cost_exit_2,money_exit_2,cost_price_system_exit,money_system_exit,purchase_extra_cost_exit,purchase_extra_cost_system_exit,product_cost_exit,product_cost_money_exit,serial_no_exit,is_production_spect_exit,dimention_exit,spec_main_id_exit,spect_name_exit,expiration_date_exit);
 	}
	function copy_row_outage(no_info)
	{
		if (document.getElementById("money_system_outage" + no_info) == undefined) money_system_outage =""; else money_system_outage = document.getElementById("money_system_outage" + no_info).value;
		if (document.getElementById("stock_code_outage" + no_info) == undefined) stock_code_outage =""; else stock_code_outage = document.getElementById("stock_code_outage" + no_info).value;
		if (document.getElementById("barcode_outage" + no_info) == undefined) barcode_outage =""; else barcode_outage = document.getElementById("barcode_outage" + no_info).value;
		if (document.getElementById("product_id_outage" + no_info) == undefined) product_id_outage =""; else product_id_outage = document.getElementById("product_id_outage" + no_info).value;
		if (document.getElementById("lot_no_outage" + no_info) == undefined) lot_no_outage =""; else lot_no_outage = document.getElementById("lot_no_outage" + no_info).value;
		if (document.getElementById("amount_outage" + no_info) == undefined) amount_outage =""; else amount_outage = document.getElementById("amount_outage" + no_info).value;
		if (document.getElementById("unit_id_outage" + no_info) == undefined) unit_id_outage =""; else unit_id_outage = document.getElementById("unit_id_outage" + no_info).value;
		if (document.getElementById("dimention_outage" + no_info) == undefined) dimention_outage =""; else dimention_outage = document.getElementById("dimention_outage" + no_info).value;
		if (document.getElementById("cost_price_outage" + no_info) == undefined) cost_price_outage =""; else cost_price_outage = document.getElementById("cost_price_outage" + no_info).value;
		if (document.getElementById("purchase_extra_cost_outage" + no_info) == undefined) purchase_extra_cost_outage =""; else purchase_extra_cost_outage = document.getElementById("purchase_extra_cost_outage" + no_info).value;
		if (document.getElementById("total_cost_price_outage" + no_info) == undefined) total_cost_price_outage =""; else total_cost_price_outage = document.getElementById("total_cost_price_outage" + no_info).value;
		if (document.getElementById("money_outage" + no_info) == undefined) money_outage =""; else money_outage = document.getElementById("money_outage" + no_info).value;
		if (document.getElementById("cost_price_outage_2" + no_info) == undefined) cost_price_outage_2 =""; else cost_price_outage_2 = document.getElementById("cost_price_outage_2" + no_info).value;
		if (document.getElementById("purchase_extra_cost_outage_2" + no_info) == undefined) purchase_extra_cost_outage_2 =""; else purchase_extra_cost_outage_2 = document.getElementById("purchase_extra_cost_outage_2" + no_info).value;
		if (document.getElementById("total_cost_price_outage_2" + no_info) == undefined) total_cost_price_outage_2 =""; else total_cost_price_outage_2 = document.getElementById("total_cost_price_outage_2" + no_info).value;
		if (document.getElementById("money_outage_2" + no_info) == undefined) money_outage_2 =""; else money_outage_2 = document.getElementById("money_outage_2" + no_info).value;
		if (document.getElementById("amount_outage2_" + no_info) == undefined) amount_outage2_ =""; else amount_outage2_ = document.getElementById("amount_outage2_" + no_info).value;
		if (document.getElementById("product_name2_outage" + no_info) == undefined) product_name2_outage =""; else product_name2_outage = document.getElementById("product_name2_outage" + no_info).value;
		if (document.getElementById("unit_outage" + no_info) == undefined) unit_outage =""; else unit_outage = document.getElementById("unit_outage" + no_info).value;
		if (document.getElementById("cost_id_outage" + no_info) == undefined) cost_id_outage =""; else cost_id_outage = document.getElementById("cost_id_outage" + no_info).value;
		if (document.getElementById("product_cost_outage" + no_info) == undefined) product_cost_outage =""; else product_cost_outage = document.getElementById("product_cost_outage" + no_info).value;
		if (document.getElementById("product_cost_money_outage" + no_info) == undefined) product_cost_money_outage =""; else product_cost_money_outage = document.getElementById("product_cost_money_outage" + no_info).value;
		if (document.getElementById("cost_price_system_outage" + no_info) == undefined) cost_price_system_outage =""; else cost_price_system_outage = document.getElementById("cost_price_system_outage" + no_info).value;
		if (document.getElementById("purchase_extra_cost_system_outage" + no_info) == undefined) purchase_extra_cost_system_outage =""; else purchase_extra_cost_system_outage = document.getElementById("purchase_extra_cost_system_outage" + no_info).value;
		if (document.getElementById("kdv_amount_outage" + no_info) == undefined) kdv_amount_outage =""; else kdv_amount_outage = document.getElementById("kdv_amount_outage" + no_info).value;
		if (document.getElementById("stock_id_outage" + no_info) == undefined) stock_id_outage =""; else stock_id_outage = document.getElementById("stock_id_outage" + no_info).value;
		if (document.getElementById("product_name_outage" + no_info) == undefined) product_name_outage =""; else product_name_outage = document.getElementById("product_name_outage" + no_info).value;
		if (document.getElementById("spect_id_outage" + no_info) == undefined) spect_id_outage =""; else spect_id_outage = document.getElementById("spect_id_outage" + no_info).value;
		if (document.getElementById("spect_name_outage" + no_info) == undefined) spect_name_outage =""; else spect_name_outage = document.getElementById("spect_name_outage" + no_info).value;
		if (document.getElementById("serial_no_outage" + no_info) == undefined) serial_no_outage =""; else serial_no_outage = document.getElementById("serial_no_outage" + no_info).value;
		if (document.getElementById("is_manual_cost_outage" + no_info) == undefined) is_manual_cost_outage =""; else is_manual_cost_outage = document.getElementById("is_manual_cost_outage" + no_info).value;
		if (document.getElementById("expiration_date_outage" + no_info) == undefined) expiration_date_outage =""; else expiration_date_outage = document.getElementById("expiration_date_outage" + no_info).value;
		 add_row_outage(stock_id_outage,product_id_outage,stock_code_outage,product_name_outage,'',barcode_outage,unit_outage,unit_id_outage,amount_outage,kdv_amount_outage,cost_id_outage,cost_price_outage,money_outage,cost_price_outage_2,purchase_extra_cost_outage_2,money_outage_2,cost_price_system_outage,money_system_outage,purchase_extra_cost_outage,purchase_extra_cost_system_outage,product_cost_outage,product_cost_money_outage,serial_no_outage,'',dimention_outage,spect_id_outage,spect_name_outage,expiration_date_outage);
 	}
	function pencere_ac_alternative(type,no,pid,sid)//ürünlerin alternatiflerini açıyor
	{
		if(type == 1)
		{
		form_stock = document.getElementById("stock_id_exit"+no);
		//&field_is_production=form_basket.is_production_spect_exit'+no+'
			<cfif is_add_alternative_product eq 0>
				//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
				url_str='&tree_info_null_=1&field_is_production=form_basket.is_production_spect_exit'+no+'&field_tax_purchase=form_basket.kdv_amount_exit'+no+'&product_id=form_basket.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_exit'+no+'</cfif>&field_id=form_basket.stock_id_exit'+no+'&field_unit_name=form_basket.unit_exit'+no+'&field_code=form_basket.stock_code_exit'+no+'&field_name=form_basket.product_name_exit' + no + '&field_unit=form_basket.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&tree_stock_id='+sid+'&is_form_submitted=1&is_only_alternative=1';
			<cfelse>
				sqlstr = 'SELECT TOP 1 P.STOCK_ID FROM SPECT_MAIN_ROW SR,ALTERNATIVE_PRODUCTS AP,PRODUCT_TREE P,SPECT_MAIN WHERE SR.PRODUCT_ID = AP.PRODUCT_ID AND SR.RELATED_TREE_ID = P.PRODUCT_TREE_ID AND AP.TREE_STOCK_ID = P.STOCK_ID AND AP.PRODUCT_ID = '+ pid +' AND AP.QUESTION_ID <> 0 AND AP.TREE_STOCK_ID = '+ sid +' AND P.RELATED_ID = SR.STOCK_ID AND SR.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID';
				my_query = wrk_query(sqlstr,'dsn3');
				if(my_query.recordcount)
				sid = my_query.STOCK_ID;
				url_str='&tree_stock_id='+sid+'&field_is_production=form_basket.is_production_spect_exit'+no+'&field_tax_purchase=form_basket.kdv_amount_exit'+no+'&product_id=form_basket.product_id_exit'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_exit'+no+'</cfif>&field_id=form_basket.stock_id_exit'+no+'&field_unit_name=form_basket.unit_exit'+no+'&field_code=form_basket.stock_code_exit'+no+'&field_name=form_basket.product_name_exit' + no + '&field_unit=form_basket.unit_id_exit'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
			</cfif>
		//console.log(url_str);
		}
		else
		{
		form_stock = document.getElementById("stock_id_outage"+no);
		//&field_is_production=form_basket.is_production_spect_exit'+no+'
		<cfif is_add_alternative_product eq 0>
				//var tree_info_null_ = 1;  1 olarak gönderildiğinde sadece ürün detayındaki alternatifleri getirir.
				url_str='&tree_info_null_=1&form_basket.is_production_spect_outage'+no+'&field_tax_purchase=form_basket.kdv_amount_outage'+no+'&product_id=form_basket.product_id_outage'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_outage'+no+'</cfif>&field_id=form_basket.stock_id_outage'+no+'&field_unit_name=form_basket.unit_outage'+no+'&field_code=form_basket.stock_code_outage'+no+'&field_name=form_basket.product_name_outage' + no + '&field_unit=form_basket.unit_id_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&tree_stock_id='+sid+'&is_form_submitted=1&is_only_alternative=1';
			<cfelse>
				sqlstr = 'SELECT TOP 1 P.STOCK_ID FROM SPECT_MAIN_ROW SR,ALTERNATIVE_PRODUCTS AP,PRODUCT_TREE P,SPECT_MAIN WHERE SR.PRODUCT_ID = AP.PRODUCT_ID AND SR.RELATED_TREE_ID = P.PRODUCT_TREE_ID AND AP.TREE_STOCK_ID = P.STOCK_ID AND AP.PRODUCT_ID = '+ pid +' AND AP.QUESTION_ID <> 0 AND AP.QUESTION_ID <> 0 AND AP.TREE_STOCK_ID = '+ sid +' AND P.RELATED_ID = SR.STOCK_ID AND SR.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID';
				my_query = wrk_query(sqlstr,'dsn3');
				if(my_query.recordcount)
				sid = my_query.STOCK_ID;
				url_str='&tree_stock_id='+sid+'&form_basket.is_production_spect_outage'+no+'&field_tax_purchase=form_basket.kdv_amount_outage'+no+'&product_id=form_basket.product_id_outage'+no+'&run_function=alternative_product_cost&send_product_id=p_id,'+no+'<cfif x_is_barkod_col>&field_barcode=form_basket.barcode_outage'+no+'</cfif>&field_id=form_basket.stock_id_outage'+no+'&field_unit_name=form_basket.unit_outage'+no+'&field_code=form_basket.stock_code_outage'+no+'&field_name=form_basket.product_name_outage' + no + '&field_unit=form_basket.unit_id_outage'+no+'&stock_id=' + form_stock.value+'&alternative_product='+pid+'&is_form_submitted=1&is_only_alternative=1';
			</cfif>
		
			}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names'+url_str+'','list');
	}

	function pencere_ac_list_product(no,type)//ürünlere lot_no ekliyor
	{
		var department_str = '';
		department_str = '&department_out=' + $("#exit_department_id").val() + '&location_out=' + $("#exit_location_id").val();
		if(type == 2)
		{//sarf ise type 2
			form_stock_code = document.getElementById("stock_code_exit"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&deliver_date=form_basket.expiration_date_exit'+no+'&lot_no=form_basket.lot_no_exit' + no + department_str + '&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
		else if(type == 3)
		{//fire ise type 3
			form_stock_code = document.getElementById("stock_code_outage"+no).value;
			url_str='&is_sale_product=1&update_product_row_id=0<cfoutput>&round_number=#round_number#</cfoutput>&is_lot_no_based=1&prod_order_result_=1&sort_type=1&deliver_date=form_basket.expiration_date_outage'+no+'&lot_no=form_basket.lot_no_outage'+no+ department_str + '&keyword=' + form_stock_code+'&is_form_submitted=1&int_basket_id=1';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products'+url_str+'','list');
		}
	}
	
	function alternative_product_cost(pid,no)
		{
			var new_sql = "SELECT TOP 1 PRODUCT_COST_ID,PURCHASE_NET,PURCHASE_NET_MONEY,PURCHASE_NET_SYSTEM,PURCHASE_NET_SYSTEM_MONEY,PURCHASE_EXTRA_COST,PURCHASE_EXTRA_COST_SYSTEM,PRODUCT_COST,MONEY FROM PRODUCT_COST WHERE PRODUCT_ID = "+pid+" AND START_DATE <= <cfoutput>#createodbcdate(GET_DETAIL.finish_date)#</cfoutput> ORDER BY START_DATE DESC,RECORD_DATE DESC";	
			var listParam = pid + "*" + "<cfoutput>#createodbcdate(GET_DETAIL.finish_date)#</cfoutput>";
			var GET_PRODUCT_COST = wrk_safe_query("prdp_GET_PRODUCT_COST",'dsn3',0,listParam);
			if(!GET_PRODUCT_COST.recordcount)
			{
					cost_id = 0;
					purchase_extra_cost = 0;
					product_cost = 0;
					product_cost_money = '<cfoutput>#session.ep.money#</cfoutput>';
					cost_price = 0;
					cost_price_money = '<cfoutput>#session.ep.money#</cfoutput>';
					cost_price_system = 0;
					cost_price_system_money = '<cfoutput>#session.ep.money#</cfoutput>';
					purchase_extra_cost_system = 0;
			}
			else
			{
				cost_id = GET_PRODUCT_COST.PRODUCT_COST_ID;
				purchase_extra_cost = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
				product_cost = GET_PRODUCT_COST.PRODUCT_COST;
				product_cost_money = GET_PRODUCT_COST.MONEY;
				cost_price = GET_PRODUCT_COST.PURCHASE_NET;
				cost_price_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
				cost_price_system = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
				cost_price_system_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
				purchase_extra_cost_system = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
			}
			//Ürünün maliyet değerleri
			document.getElementById("purchase_extra_cost_exit"+no).value = purchase_extra_cost;
			document.getElementById("cost_price_exit"+no).value = commaSplit(cost_price,round_number);
			document.getElementById("money_exit"+no).value = cost_price_money;
			document.getElementById("cost_price_system_exit"+no).value =  cost_price_system;
			document.getElementById("money_system_exit"+no).value = cost_price_system_money;
			document.getElementById("purchase_extra_cost_system_exit"+no).value =  purchase_extra_cost_system;
			//ürün değiştiği için spectler sıfırlanıyor
			document.getElementById("spect_id_exit_"+no).value = "";
			document.getElementById("spect_id_exit"+no).value = "";
			document.getElementById("spect_name_exit"+no).value = "";
	
		}
	function pencere_ac_spect(no,type)
	{
		_department_id_="";
		var exit_department_id_ = document.getElementById('exit_department_id').value;
		var exit_location_id_ = document.getElementById('exit_location_id').value;
		if(exit_department_id_ != "")
		_department_id_ = exit_department_id_;
		if(exit_department_id_ != "" && exit_location_id_!= "")
		_department_id_ +='-'+exit_location_id_;
	
		if(type==4 && document.getElementById("spect_id"+no).value != "")//Type'nin 4 olması açılacak olan sayfanın GÜNCELLEME sayfası olduğunu gösteriyor.
		{
			if(document.getElementById("stock_id"+no) == undefined || document.getElementById("stock_id"+no) == "")
				alert("<cf_get_lang dictionary_id='461.Lütfen Ürün Seçiniz'>");
			else
			 url_str='&id='+document.getElementById("spect_id"+no).value;
			 windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_spec&is_spec=1' + url_str,'list');<!--- objects.popup_list_spect_main --->
		}
		else
		{	
		<cfif (not get_fis.recordcount or not get_fis_sarf.recordcount)>//stok fişi oluşturulmamış ise
			if(type==2)
			{	
				form_stock = document.getElementById("stock_id_exit"+no);
				<cfif GET_DETAIL.IS_DEMONTAJ eq 1>
					url_str='&field_var_id=form_basket.spect_id_exit'+no+'&field_main_id=form_basket.spec_main_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&is_demontaj=1&p_order_id=<cfoutput>#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				<cfelse>
					url_str='&field_var_id=form_basket.spect_id_exit'+no+'&field_main_id=form_basket.spec_main_id_exit'+no+'&field_id=form_basket.spect_id_exit'+no+'&field_name=form_basket.spect_name_exit' + no + '&stock_id=' + form_stock.value+'&last_spect=1&create_main_spect_and_add_new_spect_id=1';
				</cfif>
				
			}
			else if(type==3)
			{
				form_stock = document.getElementById("stock_id_outage"+no);
				if(<cfoutput>#GET_DETAIL.is_demontaj#</cfoutput> == 1)
				url_str='&field_var_id=form_basket.spect_id_outage'+no+'&field_main_id=form_basket.spec_main_id_outage'+no+'&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value + '&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&p_order_id=<cfoutput>#attributes.p_order_id#</cfoutput>';
				else
				url_str='&field_var_id=form_basket.spect_id_outage'+no+'&field_main_id=form_basket.spec_main_id_outage'+no+'&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1';

				//url_str='&field_id=form_basket.spect_id_outage'+no+'&field_name=form_basket.spect_name_outage' + no + '&stock_id=' + form_stock.value+'&last_spect=1';
			
			}
			else
			{
				form_stock = document.getElementById("stock_id"+no);
				<cfif GET_DETAIL.IS_DEMONTAJ eq 1>
					url_str='&field_var_id=form_basket.spect_id'+no+'&field_main_id=form_basket.spec_main_id'+no+'&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value +'&create_main_spect_and_add_new_spect_id=1&last_spect=1&<cfoutput>p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				<cfelse>
					url_str='&field_var_id=form_basket.spect_id'+no+'&field_main_id=form_basket.spec_main_id'+no+'&p_order_row_id='+document.getElementById('order_row_id').value+'&field_id=form_basket.spect_id'+no+'&field_name=form_basket.spect_name' + no + '&stock_id=' + form_stock.value +'&last_spect=1&spect_change=1&create_main_spect_and_add_new_spect_id=1&<cfoutput>p_order_id=#attributes.p_order_id#&pr_order_id=#attributes.pr_order_id#</cfoutput>';
				</cfif>
			}
			if(form_stock.value == "")
				alert("<cf_get_lang dictionary_id='36774.Lütfen Ürün Seçiniz'>");
			else
				 windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1' + url_str,'list');
		<cfelse>
			alert("<cf_get_lang dictionary_id ='36883.Stok Fişi Oluşturulduğu için spectlerde herhangi bi değişiklik yapamazsınız'>");
		</cfif>
		}
	}
	
	function pencere_ac_serial_no(no)
	{
		form_serial_no_exit = document.getElementById("serial_no_exit"+no);
		if(form_serial_no_exit.value == "")
			alert("<cf_get_lang dictionary_id='36775.Lütfen Seri No Giriniz'> !");
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&product_serial_no=' + form_serial_no_exit.value,'list');	
	}
	function lotno_control(crntrow,type)
	{
		//var prohibited=' [space] , ",	#,  $, %, &, ', (, ), *, +, ,, ., /, <, =, >, ?, @, [, \, ], ],  `, {, |,   }, , «, ';
		var prohibited_asci='32,34,35,36,37,38,39,40,41,42,43,44,47,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171';
		if(type == 2)
			lot_no = document.getElementById('lot_no_exit'+crntrow);
		else if(type ==3)
			lot_no = document.getElementById('lot_no_outage'+crntrow);
		else
			lot_no = document.getElementById('lot_no');
		toplam_ = lot_no.value.length;
		deger_ = lot_no.value;
		if(toplam_>0)
		{
			for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
			{
				tus_ = deger_.charAt(this_tus_);
				cont_ = list_find(prohibited_asci,tus_.charCodeAt());
				if(cont_>0)
				{
					alert("[space],\"\,#,$,%,&,',(,),*,+,,/,<,=,>,?,@,[,\,],],`,{,|,},«,; <cf_get_lang dictionary_id='60598.Karakterlerinden Oluşan Lot No Girilemez'>!");
					lot_no.value = '';
					break;
				}
			}
		}
	}
	
	function hesapla_deger(value,id)
	{
		if(id==0)
		{
			var value_amount_exit = document.getElementById("amount_exit"+value);
			if((value_amount_exit.value == "") || (value_amount_exit.value == 0))
			{
				value_amount_exit.value = 1;
			}
		}
		else if(id==1)
		{
			var value_amount = document.getElementById("amount"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 1;
			}
		}
		else if(id==2)
		{
			var value_amount = document.getElementById("amount_outage"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 1;
			}
		}
		else if(id==3)
		{
			var value_amount = document.getElementById("fire_amount_"+value);
			if((value_amount.value == "") || (value_amount.value == 0))
			{
				value_amount.value = 0;
			}
		}
	}
	function kontrol()
	{
		//if( document.getElementById('is_delstock') && document.getElementById('is_delstock').checked == true || document.getElementById('is_delstock') == undefined){//Üretime sonuç girilmiş ise güncelleme yapılamasın üretim emrinde.
			var round_number = document.getElementById('round_number').value;
			if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
			if(!chk_process_cat('form_basket')) return false;
			if(!check_display_files('form_basket')) return false;
			if (!process_cat_control()) return false;
			if(document.getElementById("production_result_no").value != '')
			{
				var listParam = document.getElementById("production_result_no").value + "*" + "<cfoutput>#attributes.pr_order_id#</cfoutput>";
				var doc_no_control = wrk_safe_query("prdp_doc_no_control","dsn3",0,listParam);
				if(doc_no_control.recordcount > 0)
				{
					alert("<cf_get_lang dictionary_id='58122.Girdiğiniz Belge No Kullanılıyor'>!");
					return false;
				}
			}
			if(document.getElementById("station_id").value == "" || document.getElementById("station_name").value == "")
			{
				alert("<cf_get_lang dictionary_id='58837.Lütfen İstasyon Seçiniz'> !");
				return false;
			}
			tarih1_ = form_basket.start_date.value.substr(6,6) + form_basket.start_date.value.substr(3,2) + form_basket.start_date.value.substr(0,2);
			tarih2_ = form_basket.finish_date.value.substr(6,6) + form_basket.finish_date.value.substr(3,2) + form_basket.finish_date.value.substr(0,2);
		
			if (form_basket.start_h.value.length < 2) saat1_ = '0' + form_basket.start_h.value; else saat1_ = form_basket.start_h.value;
			if (form_basket.start_m.value.length < 2) dakika1_ = '0' + form_basket.start_m.value; else dakika1_ = form_basket.start_m.value;
			if (form_basket.finish_h.value.length < 2) saat2_ = '0' + form_basket.finish_h.value; else saat2_ = form_basket.finish_h.value;
			if (form_basket.finish_m.value.length < 2) dakika2_ = '0' + form_basket.finish_m.value; else dakika2_ = form_basket.finish_m.value;
		
			tarih1_ = tarih1_ + saat1_ + dakika1_;
			tarih2_ = tarih2_ + saat2_ + dakika2_;	
			
			if (tarih1_ >= tarih2_) 
			{
				alert("<cf_get_lang dictionary_id='36776.Başlangıç Tarihi Bitiş Tarihinden Büyük'> !");
				return false;
			}
			var row_count_ = 0;
			for (var r=1;r<=row_count;r++)
			{
				if(document.getElementById("row_kontrol"+r).value==1)//En az bir ana ürün satırı olması için kontrol eklendi.
				{
					row_count_ = row_count_ + 1;
					if(filterNum(document.getElementById("amount"+r).value,round_number) <= 0)
					{
						alert("<cf_get_lang dictionary_id='60509.Ürün Miktarı 0 Olamaz'> , <cf_get_lang dictionary_id='60510.Lütfen Miktarları Kontrol Ediniz'> !");
						return false;
					}
				}
			}
			if(row_count_ == 0)
			{
				alert("<cf_get_lang dictionary_id='35971.Ana ürün seçmelisiniz!'>");
				return false;
			}
			var row_count_exit_ = 0;
			for (var k=1;k<=row_count_exit;k++)
			{
				if(document.getElementById("row_kontrol_exit"+k).value==1)//En az bir sarf ürün satırı olması için kontrol eklendi.
				{
					row_count_exit_ = row_count_exit_ + 1;
					if(filterNum(document.getElementById("amount_exit_"+k).value,round_number) <= 0)
					{
						alert("<cf_get_lang dictionary_id='60513.Sarf Miktarı 0 Olamaz'> , <cf_get_lang dictionary_id='60510.Lütfen Miktarları Kontrol Ediniz'> !");
						return false;
					}
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_exit"+k).value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.getElementById("lot_no_exit"+k).value == '')
								{
									alert(row_count_exit_+'. <cf_get_lang dictionary_id='60582.sarf satırındaki'> '+ document.getElementById("product_name_exit"+k).value + "<cf_get_lang dictionary_id='59285.ürünü için lot no takibi yapılmaktadır'>!");
									return false;
								}
							}
						}
					</cfif>
				}
			}
			if(row_count_exit_ == 0)
			{
				alert("<cf_get_lang dictionary_id='60514.Lütfen Sarf Ürünü Seçiniz'>!");
				return false;
			}	
			for (var k=1;k<=row_count_exit;k++)//eğer sarfların içinde üretilen bir ürün varsa onun için spect seçilmesini zorunlu kılıyor.Onun kontrolü
			{	
				if((document.getElementById("is_delstock") == undefined) || (document.getElementById("is_delstock") != undefined && document.getElementById("is_delstock").checked == false))//Stok Fişleri Silinsin tanımlı değilse yada tanımlı ancak seçili değilse,eğer seçili ise kontrole sokmuyoruz ve direkt olarak siliyoruz.
				{	
					if((document.getElementById("spec_main_id_exit"+k).value == "" || document.getElementById("spect_name_exit"+k).value == "") && (document.getElementById("is_production_spect_exit"+k)!= undefined && document.getElementById("is_production_spect_exit"+k).value == 1) && document.getElementById("row_kontrol_exit"+k).value==1)//spect id ve spect name varsa vede ürtilen bir ürünse//vede 
					{
						//alert("<cf_get_lang dictionary_id ="571.Üretilen Ürünler İçin Spec Seçmeniz Gerekmektedir">.(' + eval("document.form_basket.product_name_exit"+k).value + ')");
						alert('<cf_get_lang dictionary_id ="36884.Üretilen Ürünler İçin Spec Seçmeniz Gerekmektedir">.(' + document.getElementById("product_name_exit"+k).value + ')');
						return false;
					}
				}
			}
			row_count_outage_ = 0;
			for (var k=1;k<=row_count_outage;k++)
			{
				if(document.getElementById("row_kontrol_outage"+k).value==1)// fire ürün satırı olması için kontrol eklendi.
				{
					row_count_outage_ = row_count_outage_ + 1;
					if(filterNum(document.getElementById("amount_outage"+k).value,round_number) <= 0)
					{
						alert("<cf_get_lang dictionary_id='65396.Fire Miktarı 0 Olamaz'> , <cf_get_lang dictionary_id='60510.Lütfen Miktarları Kontrol Ediniz'> !");
						return false;
					}
					<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
						if(check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,document.getElementById("stock_id_outage"+k).value);
							if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
							{
								if(document.getElementById("lot_no_outage"+k).value == '')
								{
									alert(row_count_outage_+'. <cf_get_lang dictionary_id="60583.fire satırındaki"> '+ document.getElementById("product_name_outage"+k).value + ' <cf_get_lang dictionary_id="59285.ürünü için lot no takibi yapılmaktadır">!');
									return false;
								}
							}
						}
					</cfif>
				}
			}
			<cfif get_fis.recordcount or get_fis_sarf.recordcount>
				<cfif isdefined("x_update_result") and x_update_result eq 1>
					if(document.getElementById("is_delstock").checked == false)
					{
						alert("<cf_get_lang dictionary_id='60515.Stok Fişleri Silinsin Seçeneğini Seçmeden Güncelleme Yapamazsınız'> !");
						return false;
					}
				</cfif>
				if(document.getElementById("is_delstock").checked == true)
				{
					if(! confirm("<cf_get_lang dictionary_id='36783.Fişleri Siliyorsunuz'>. <cf_get_lang dictionary_id ='36885.Yaptığınız Değişiklikler Stok ve İrsaliye Fişlerinin Silinmesine Neden Olacak Kayda Devam Etmek İstediğinizden Emin misiniz'> ! ")) return false;
					if(get_process.IS_ZERO_STOCK_CONTROL == 1)
					{
						if(!zero_stock_control(1)) return false; 
					}
				}
				for (var r=1;r<=row_count;r++)
				{
					document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,round_number);
					if(document.getElementById("amount2_"+r))
						document.getElementById("amount2_"+r).value = filterNum(document.getElementById("amount2_"+r).value,round_number);
					document.getElementById("cost_price"+r).value = filterNum(document.getElementById("cost_price"+r).value,round_number);
					document.getElementById("purchase_extra_cost"+r).value = filterNum(document.getElementById("purchase_extra_cost"+r).value,round_number);
					document.getElementById("purchase_extra_cost_system"+r).value = filterNum(document.getElementById("purchase_extra_cost_system"+r).value,round_number);
					if(document.getElementById("cost_price_2"+r) != undefined)
						document.getElementById("cost_price_2"+r).value = filterNum(document.getElementById("cost_price_2"+r).value,round_number);
					if(document.getElementById("cost_price_extra_2"+r) != undefined)
						document.getElementById("cost_price_extra_2"+r).value = filterNum(document.getElementById("cost_price_extra_2"+r).value,round_number);
					<cfif x_is_fire_product eq 1>
						document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,round_number);
					</cfif>
					document.getElementById("weight"+r).value = filterNum(document.getElementById("weight"+r).value,round_number);
					<cfif xml_specific_weight eq 1>
					document.getElementById("specific_weight"+r).value = filterNum(document.getElementById("specific_weight"+r).value,round_number);
					</cfif>
					<cfif x_is_show_abh eq 1>
					document.getElementById("width"+r).value = filterNum(document.getElementById("width"+r).value,round_number);
					document.getElementById("height"+r).value = filterNum(document.getElementById("height"+r).value,round_number);
					document.getElementById("length"+r).value = filterNum(document.getElementById("length"+r).value,round_number);
					</cfif>
				}
				for (var k=1;k<=row_count_exit;k++)
				{
					document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,round_number);
					if(document.getElementById("amount_exit2_"+k))
						document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,round_number);
					document.getElementById("cost_price_exit"+k).value = filterNum(document.getElementById("cost_price_exit"+k).value,round_number);
	
					document.getElementById("purchase_extra_cost_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit"+k).value,round_number);
					if(document.getElementById("labor_cost_exit"+k) != undefined)
						document.getElementById("labor_cost_exit"+k).value = filterNum(document.getElementById("labor_cost_exit"+k).value,round_number);
					if(document.getElementById("reflection_cost_exit"+k) != undefined)
						document.getElementById("reflection_cost_exit"+k).value = filterNum(document.getElementById("reflection_cost_exit"+k).value,round_number);
					//document.getElementById("purchase_extra_cost_system_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_system_exit"+k).value,8);
					if(document.getElementById("cost_price_exit_2"+k) != undefined)
						document.getElementById("cost_price_exit_2"+k).value = filterNum(document.getElementById("cost_price_exit_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_exit_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_exit_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit_2"+k).value,round_number);
						<cfif x_is_show_abh eq 1>
					document.getElementById("width_exit"+k).value = filterNum(document.getElementById("width_exit"+k).value,round_number);
					document.getElementById("height_exit"+k).value = filterNum(document.getElementById("height_exit"+k).value,round_number);
					document.getElementById("length_exit"+k).value = filterNum(document.getElementById("length_exit"+k).value,round_number);
					</cfif>
					document.getElementById("weight_exit"+k).value = filterNum(document.getElementById("weight_exit"+k).value,round_number);
					<cfif xml_specific_weight eq 1>
					document.getElementById("specific_weight_exit"+k).value = filterNum(document.getElementById("specific_weight_exit"+k).value,round_number);
					</cfif>
					}
				for (var k=1;k<=row_count_outage;k++)
				{
					document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,round_number);
					if(document.getElementById("amount_outage2_"+k))
						document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,round_number);
					document.getElementById("cost_price_outage"+k).value = filterNum(document.getElementById("cost_price_outage"+k).value,round_number);
					if(document.getElementById("labor_cost_outage"+k) != undefined)
						document.getElementById("labor_cost_outage"+k).value = filterNum(document.getElementById("labor_cost_outage"+k).value,round_number);
					if(document.getElementById("reflection_cost_outage"+k) != undefined)
						document.getElementById("reflection_cost_outage"+k).value = filterNum(document.getElementById("reflection_cost_outage"+k).value,round_number);
					if(document.getElementById("cost_price_outage_2"+k) != undefined)
						document.getElementById("cost_price_outage_2"+k).value = filterNum(document.getElementById("cost_price_outage_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_outage_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_outage_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage_2"+k).value,round_number);
					document.getElementById("purchase_extra_cost_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage"+k).value,round_number);
					<cfif x_is_show_abh eq 1>
					document.getElementById("width_outage"+k).value = filterNum(document.getElementById("width_outage"+k).value,round_number);
					document.getElementById("height_outage"+k).value = filterNum(document.getElementById("height_outage"+k).value,round_number);
					document.getElementById("length_outage"+k).value = filterNum(document.getElementById("length_outage"+k).value,round_number);
					</cfif>
					document.getElementById("weight_outage"+k).value = filterNum(document.getElementById("weight_outage"+k).value,round_number);
					<cfif xml_specific_weight eq 1>
					document.getElementById("specific_weight_outage"+k).value = filterNum(document.getElementById("specific_weight_outage"+k).value,round_number);
					</cfif>
					//document.getElementById("purchase_extra_cost_system_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_system_outage"+k).value,8);
				}
			<cfelse>
				for (var r=1;r<=row_count;r++)
				{
					document.getElementById("amount"+r).value = filterNum(document.getElementById("amount"+r).value,round_number);
					if(document.getElementById("amount2_"+r))
						document.getElementById("amount2_"+r).value = filterNum(document.getElementById("amount2_"+r).value,round_number);
					document.getElementById("cost_price"+r).value = filterNum(document.getElementById("cost_price"+r).value,round_number);
					document.getElementById("purchase_extra_cost"+r).value = filterNum(document.getElementById("purchase_extra_cost"+r).value,round_number);
					if(document.getElementById("cost_price_2"+r) != undefined)
						document.getElementById("cost_price_2"+r).value = filterNum(document.getElementById("cost_price_2"+r).value,round_number);
					if(document.getElementById("cost_price_extra_2"+r) != undefined)
						document.getElementById("cost_price_extra_2"+r).value = filterNum(document.getElementById("cost_price_extra_2"+r).value,round_number);
					<cfif x_is_fire_product eq 1>
						document.getElementById("fire_amount_"+r).value = filterNum(document.getElementById("fire_amount_"+r).value,round_number);
					</cfif>
					document.getElementById("weight"+r).value = filterNum(document.getElementById("weight"+r).value,round_number);
					<cfif xml_specific_weight eq 1>
					document.getElementById("specific_weight"+r).value = filterNum(document.getElementById("specific_weight"+r).value,round_number);
					</cfif>
					<cfif x_is_show_abh eq 1>
					document.getElementById("width"+r).value = filterNum(document.getElementById("width"+r).value,round_number);
					document.getElementById("height"+r).value = filterNum(document.getElementById("height"+r).value,round_number);
					document.getElementById("length"+r).value = filterNum(document.getElementById("length"+r).value,round_number);
					</cfif>
				}
				for (var k=1;k<=row_count_exit;k++)
				{
					document.getElementById("amount_exit"+k).value = filterNum(document.getElementById("amount_exit"+k).value,round_number);
					if(document.getElementById("amount_exit2_"+k))
						document.getElementById("amount_exit2_"+k).value = filterNum(document.getElementById("amount_exit2_"+k).value,round_number);
					document.getElementById("cost_price_exit"+k).value = filterNum(document.getElementById("cost_price_exit"+k).value,round_number);
					if(document.getElementById("labor_cost_exit"+k) != undefined)
						document.getElementById("labor_cost_exit"+k).value = filterNum(document.getElementById("labor_cost_exit"+k).value,round_number);
					if(document.getElementById("reflection_cost_exit"+k) != undefined)
						document.getElementById("reflection_cost_exit"+k).value = filterNum(document.getElementById("reflection_cost_exit"+k).value,round_number);
	
					document.getElementById("purchase_extra_cost_exit"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit"+k).value,round_number);
					if(document.getElementById("cost_price_exit_2"+k) != undefined)
						document.getElementById("cost_price_exit_2"+k).value = filterNum(document.getElementById("cost_price_exit_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_exit_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_exit_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_exit_2"+k).value,round_number);
					<cfif x_is_show_abh eq 1>
					document.getElementById("width_exit"+k).value = filterNum(document.getElementById("width_exit"+k).value,round_number);
					document.getElementById("height_exit"+k).value = filterNum(document.getElementById("height_exit"+k).value,round_number);
					document.getElementById("length_exit"+k).value = filterNum(document.getElementById("length_exit"+k).value,round_number);
					</cfif>
					document.getElementById("weight_exit"+k).value = filterNum(document.getElementById("weight_exit"+k).value,round_number);
					<cfif xml_specific_weight eq 1>
					document.getElementById("specific_weight_exit"+k).value = filterNum(document.getElementById("specific_weight_exit"+k).value,round_number);
					</cfif>
					}
				for (var k=1;k<=row_count_outage;k++)
				{
					document.getElementById("amount_outage"+k).value = filterNum(document.getElementById("amount_outage"+k).value,round_number);
					if(document.getElementById("labor_cost_outage"+k) != undefined)
						document.getElementById("labor_cost_outage"+k).value = filterNum(document.getElementById("labor_cost_outage"+k).value,round_number);
					if(document.getElementById("reflection_cost_outage"+k) != undefined)
						document.getElementById("reflection_cost_outage"+k).value = filterNum(document.getElementById("reflection_cost_outage"+k).value,round_number);
					if(document.getElementById("amount_outage2_"+k))
						document.getElementById("amount_outage2_"+k).value = filterNum(document.getElementById("amount_outage2_"+k).value,round_number);
					document.getElementById("cost_price_outage"+k).value = filterNum(document.getElementById("cost_price_outage"+k).value,round_number);
					if(document.getElementById("cost_price_outage_2"+k) != undefined)
						document.getElementById("cost_price_outage_2"+k).value = filterNum(document.getElementById("cost_price_outage_2"+k).value,round_number);
					if(document.getElementById("purchase_extra_cost_outage_2"+k) != undefined)
						document.getElementById("purchase_extra_cost_outage_2"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage_2"+k).value,round_number);
					document.getElementById("purchase_extra_cost_outage"+k).value = filterNum(document.getElementById("purchase_extra_cost_outage"+k).value,round_number);
					<cfif x_is_show_abh eq 1>
					document.getElementById("width_outage"+k).value = filterNum(document.getElementById("width_outage"+k).value,round_number);
					document.getElementById("height_outage"+k).value = filterNum(document.getElementById("height_outage"+k).value,round_number);
					document.getElementById("length_outage"+k).value = filterNum(document.getElementById("length_outage"+k).value,round_number);
					</cfif>
					document.getElementById("weight_outage"+k).value = filterNum(document.getElementById("weight_outage"+k).value,round_number);
					<cfif xml_specific_weight eq 1>
					document.getElementById("specific_weight_outage"+k).value = filterNum(document.getElementById("specific_weight_outage"+k).value,round_number);
					</cfif>
				}
			</cfif>
			return true;
		/*
		}
		else
			alert('Sonuç Girilmiş Üretim Emri Güncellenemez!');
			return false;
		*/
	}
	<!--- todo --->
	function zero_stock_control(is_del_)
	{
		var hata = '';
		var lotno_hata = '';
		var stock_list = 0;
		var stock_type = 0;
		var is_update = 0;
		var round_number = document.getElementById('round_number').value;
		var stock_id_list='0';
		var stock_amount_list='0';
		var spec_id_list='0';
		var spec_amount_list='0';
		var main_spec_id_list='0';
		var main_spec_amount_list='0';
		if(isNaN(is_del_)) var is_del_=0;
		var popup_spec_type=<cfoutput>#is_stock_control_with_spec#</cfoutput>;//specli mi normal stokmu
		//stok kontrollerinin hangi tarihe gore yapılacagi XML parametresi ile belirlenir
		var loc_id = form_basket.exit_location_id.value;
		var dep_id = form_basket.exit_department_id.value;
		zero_stock_control_date = <cfoutput>'#zero_stock_control_date#'</cfoutput>;
		var p_stock_id_list='0';
		var p_stock_amount_list='0';
		var p_spec_id_list='0';
		var p_spec_amount_list='0';
		var p_main_spec_id_list='0';
		var p_main_spec_amount_list='0';
		var p_query_stock_id_list = '0';
		<cfif isdefined('zero_stock_control_date') and zero_stock_control_date eq 1>
			var paper_date_kontrol = js_date(document.getElementById('finish_date').value.toString());	
		<cfelse>
			var paper_date_kontrol = js_date(document.getElementById('today_date_').value.toString());	
		</cfif>
		<cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
			if(check_lotno('form_basket') != undefined && check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
			{
				for (var k=1;k<=row_count_exit;k++)
				{//sarf
					if(document.getElementById("row_kontrol_exit"+k).value==1)
					{
						varName = "lot_no_" + document.getElementById("stock_id_exit"+k).value + document.getElementById("lot_no_exit"+k).value.replace(/-/g, '_').replace(/\./g, '_');
						this[varName] = 0;
						stock_list=stock_list+';'+document.getElementById("stock_id_exit"+k).value+'§'+document.getElementById("lot_no_exit"+k).value+'§'+document.getElementById("amount_exit_"+k).value;
					}
				}
				for (var k=1;k<=row_count_outage;k++)
				{//fire
					if(document.getElementById("row_kontrol_outage"+k).value==1)
					{
						varName = "lot_no_" + document.getElementById("stock_id_outage"+k).value + document.getElementById("lot_no_outage"+k).value.replace(/-/g, '_').replace(/\./g, '_');
						this[varName] = 0;
						stock_list=stock_list+';'+document.getElementById("stock_id_outage"+k).value+'§'+document.getElementById("lot_no_outage"+k).value+'§'+document.getElementById("amount_outage"+k).value;
					}
				}
			}
			if(stock_list != undefined && stock_list != 0)
			{
				//var xx = '';
				var myarray = stock_list.split(';');
				for(var ss=1;ss<=myarray.length;ss++)
				{
					if(myarray[ss] != undefined && myarray[ss] != 0)
					{
						var stock_id = list_getat(myarray[ss],1,'§');
						var lot_no = list_getat(myarray[ss],2,'§');
						var stock_amount = list_getat(myarray[ss],3,'§');
						if(stock_id != '' )
						{
							get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,stock_id);
							if(get_prod_detail.IS_LOT_NO == 1 && get_prod_detail.IS_ZERO_STOCK == 0)//üründe lot no takibi yapılıyor seçili ise ve sifir stok ile calis secili degil ise
							{
								varName = "lot_no_" + stock_id + lot_no.replace(/-/g, '_').replace(/\./g, '_');
								var xxx = commaSplit(String(this[varName]),round_number);
								var yyy = stock_amount;
								this[varName] = parseFloat( filterNum(xxx,round_number) ) + parseFloat( filterNum(yyy,round_number) );
								if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
								{
									if(stock_type==undefined || stock_type==0)
									{
										if(is_update != 0)
											url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol)+'&is_update='+ is_update;
										else
											url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_2&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol);		
									}
									else
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_3&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id;
								}
								else
								{
									if(is_update != 0)
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_4&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id +'&is_update='+ is_update;
									else
										url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=prdp_get_total_lot_no_stock_5&lot_no='+ encodeURIComponent(lot_no) +'&stock_id='+ stock_id +'&paper_date_kontrol='+ encodeURIComponent(paper_date_kontrol) +'&loc_id='+ loc_id +'&dep_id='+ dep_id;
								}
								//$('#reference_no').val(url_);
								$.ajax({
										url: url_,
										dataType: "text",
										cache:false,
										async: false,
										success: function(read_data) {
										data_ = jQuery.parseJSON(read_data);
										if(data_.DATA.length != 0)
										{
											$.each(data_.DATA,function(i){
												var PRODUCT_TOTAL_STOCK = data_.DATA[i][0];
												var STOCK_ID = data_.DATA[i][1];
												var STOCK_CODE = data_.DATA[i][2];
												var PRODUCT_NAME = data_.DATA[i][3];
												if(eval(varName) > wrk_round(parseFloat(PRODUCT_TOTAL_STOCK),8) || (is_del_!=0 && wrk_round(parseFloat(PRODUCT_TOTAL_STOCK),8) <0 ) || (is_del_==0 &&( wrk_round(parseFloat(PRODUCT_TOTAL_STOCK),8)+ parseFloat(eval(varName)))< 0) )
												{
													lotno_hata = lotno_hata+ 'Ürün:'+PRODUCT_NAME+'(Stok Kodu:'+STOCK_CODE+')\n';
												}
											});
										}
										else if(data_.DATA.length == 0)
										{
											lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										}
										else
										{
											if(parseFloat(eval(varName))< 0)
												lotno_hata = lotno_hata+ 'Ürün:'+get_prod_detail.PRODUCT_NAME+'(Stok Kodu:'+get_prod_detail.STOCK_CODE+')\n';
										}
									}
								});
							}
						}
					}
				}
			}
		</cfif>
		
		for (var k=1;k<=row_count;k++)
		{//üretilen ürün kontrolleri
				if(document.getElementById("row_kontrol"+k).value==1)
			{
				if(document.getElementById('spec_main_id'+k).value != undefined && document.getElementById('spec_main_id'+k).value != '')
				{
					var p_yer=list_find(p_spec_id_list,document.getElementById('spec_main_id'+k).value,',');
					if(p_yer)
					{
						p_top_stock_miktar=parseFloat(list_getat(p_spec_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount"+k).value));
						p_spec_amount_list=list_setat(p_spec_amount_list,yer,p_top_stock_miktar,',');
					}else{
						p_spec_id_list=p_spec_id_list+','+document.getElementById('spec_main_id'+k).value;
						p_spec_amount_list=p_spec_amount_list+','+filterNum(document.getElementById("amount"+k).value);
					}
				}
				//artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
				var p_yer=list_find(p_stock_id_list,document.getElementById("stock_id"+k).value,',');
				if(p_yer)
				{
					p_top_stock_miktar=parseFloat(list_getat(p_stock_amount_list,p_yer,','))+parseFloat(filterNum(document.getElementById("amount"+k).value));
					p_stock_amount_list=list_setat(p_stock_amount_list,yer,p_top_stock_miktar,',');
				}
				else
				{
					p_stock_id_list=p_stock_id_list+','+document.getElementById("stock_id"+k).value;
					p_stock_amount_list=p_stock_amount_list+','+filterNum(document.getElementById("amount"+k).value);
				}
			}
		}	
		for (var k=1;k<=row_count_exit;k++)
		{//sarf
			if(document.getElementById('is_sevkiyat'+k) != undefined && document.getElementById('is_sevkiyat'+k).value != undefined && document.getElementById('is_sevkiyat'+k).value != 0) 
				var sb=document.getElementById('is_sevkiyat'+k).checked; 
			else 
				var sb=false;
			if(sb!=true)
			{
				if(document.getElementById("row_kontrol_exit"+k).value==1)
				{
					if(document.getElementById('spec_main_id_exit'+k).value != undefined && document.getElementById('spec_main_id_exit'+k).value != '')
					{
						var yer=list_find(spec_id_list,document.getElementById('spec_main_id_exit'+k).value,',');
						if(yer)
						{
							top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_exit_"+k).value));
							spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
						}else{
							spec_id_list=spec_id_list+','+document.getElementById('spec_main_id_exit'+k).value;
							spec_amount_list=spec_amount_list+','+filterNum(document.getElementById("amount_exit_"+k).value);
						}
					}
					//artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
					var yer=list_find(stock_id_list,document.getElementById("stock_id_exit"+k).value,',');
					if(yer)
					{
						top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_exit_"+k).value));
						stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
					}
					else
					{
						stock_id_list=stock_id_list+','+document.getElementById("stock_id_exit"+k).value;
						stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("amount_exit_"+k).value);
					}
				}
			}			
		}
		for (var k=1;k<=row_count_outage;k++)
		{//fire
			if(document.getElementById("row_kontrol_outage"+k).value==1)
			{
				if(document.getElementById('spec_main_id_outage'+k).value != undefined && document.getElementById('spec_main_id_outage'+k).value != '')
				{
					var yer=list_find(spec_id_list,document.getElementById('spec_main_id_outage'+k).value,',');
					if(yer)
					{
						top_stock_miktar=parseFloat(list_getat(spec_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_outage"+k).value));
						spec_amount_list=list_setat(spec_amount_list,yer,top_stock_miktar,',');
					}else{
						spec_id_list=spec_id_list+','+document.getElementById('spec_main_id_outage'+k).value;
						spec_amount_list=spec_amount_list+','+filterNum(document.getElementById("amount_outage"+k).value);
					}
				}
				//artık uretilen urun ıcınde once kendi stok miktarı olmalı sonra specli stoğa bakılıyor
				var yer=list_find(stock_id_list,document.getElementById("stock_id_outage"+k).value,',');
				if(yer)
				{
					top_stock_miktar=parseFloat(list_getat(stock_amount_list,yer,','))+parseFloat(filterNum(document.getElementById("amount_outage"+k).value));
					stock_amount_list=list_setat(stock_amount_list,yer,top_stock_miktar,',');
				}
				else
				{
					stock_id_list=stock_id_list+','+document.getElementById("stock_id_outage"+k).value;
					stock_amount_list=stock_amount_list+','+filterNum(document.getElementById("amount_outage"+k).value);
				}
			}
		}
		main_spec_id_list = spec_id_list;
		main_spec_amount_list = spec_amount_list;
		get_spect='';
		var stock_id_count=list_len(stock_id_list,',');
		//stock kontrolleri
		//üretilen ürün için eklendi - sıfır stok kontrolü PY
	
			var p_stock_id_count=list_len(p_stock_id_list,',');
			if(p_stock_id_count >1 && is_del_ == 1)
			{
				if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)//departman ve lokasyon yok ise
				{
					if(stock_type==undefined || stock_type==0)
					{
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + p_stock_id_list + "*" + is_update + "*" + paper_date_kontrol;
						if(is_update != 0)
							var new_sql = 'prdp_get_total_stock';
						else
							var new_sql = 'prdp_get_total_stock_2';
					}
					else
					{
						var listParam = p_stock_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + "<cfoutput>#dsn_alias#</cfoutput>" + "*" + is_update + "*" + paper_date_kontrol;
						if(is_update != 0)
							var new_sql='prdp_get_total_stock_3';
						else
							var new_sql='prdp_get_total_stock_4';
					}
				}
				else
				{
					var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + p_stock_id_list + "*" + loc_id + "*" + dep_id + "*" + is_update  + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql = 'prdp_get_total_stock_5';
					else
						var new_sql = 'prdp_get_total_stock_6';
				}
				
			//	console.log(new_sql);
			//	console.log(listParam);
				var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			//	console.log(get_total_stock);
				if(get_total_stock.recordcount)
				{
					var p_query_stock_id_list='0';
					for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
					{
						p_query_stock_id_list=p_query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
						var yer=list_find(p_stock_id_list,get_total_stock.STOCK_ID[cnt],',');
					//	if( ( is_del_!=0 && parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(p_stock_amount_list,yer,',')) ) || ( is_del_==0 &&( parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt])+ parseFloat(list_getat(p_stock_amount_list,yer,',')) )< 0) )
						if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(p_stock_amount_list,yer,',')))
							hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]+')\n';
					}
				}
				var diff_stock_id='0';
				for(var lst_cnt=1;lst_cnt <= list_len(p_stock_id_list);lst_cnt++)
				{
					var stk_id=list_getat(p_stock_id_list,lst_cnt,',')
					if(p_query_stock_id_list==undefined || p_query_stock_id_list=='0' || list_find(p_query_stock_id_list,stk_id,',') == '0')
						diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
				}
				if(list_len(diff_stock_id,',')>1)
				{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
					var get_stock = wrk_safe_query('prdp_get_stock','dsn3',0,diff_stock_id);
					for(var cnt=0; cnt < get_stock.recordcount; cnt++)
						hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_stock.STOCK_CODE[cnt]+')\n';
				}
				get_total_stock='';
			}
		//üretilen ürün için eklendi PY

		if(stock_id_count >1)
		{
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)//departman ve lokasyon yok ise
			{
				if(stock_type==undefined || stock_type==0)
				{
					var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql = 'prdp_get_total_stock';
					else
						var new_sql = 'prdp_get_total_stock_2';
				}
				else
				{
					var listParam = stock_id_list + "*" + "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + "<cfoutput>#dsn_alias#</cfoutput>" + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql='prdp_get_total_stock_3';
					else
						var new_sql='prdp_get_total_stock_4';
				}
			}
			else
			{
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + stock_id_list + "*" + loc_id + "*" + dep_id + "*" + is_update  + "*" + paper_date_kontrol;
				if(is_update != 0)
					var new_sql = 'prdp_get_total_stock_5';
				else
					var new_sql = 'prdp_get_total_stock_6';
			}
			var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			if(get_total_stock.recordcount)
			{
				var query_stock_id_list='0';
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_stock_id_list=query_stock_id_list+','+get_total_stock.STOCK_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(stock_id_list,get_total_stock.STOCK_ID[cnt],',');
					if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(stock_amount_list,yer,',')))
						hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]+')\n';
				}
			}
			var diff_stock_id='0';
			for(var lst_cnt=1;lst_cnt <= list_len(stock_id_list);lst_cnt++)
			{
				var stk_id=list_getat(stock_id_list,lst_cnt,',')
				if(query_stock_id_list==undefined || query_stock_id_list=='0' || list_find(query_stock_id_list,stk_id,',') == '0')
					diff_stock_id=diff_stock_id+','+stk_id;//kayıt gelmeyen urunler
			}
			if(list_len(diff_stock_id,',')>1)
			{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden yazıldı
				var get_stock = wrk_safe_query('prdp_get_stock','dsn3',0,diff_stock_id);
				for(var cnt=0; cnt < get_stock.recordcount; cnt++)
					hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_stock.STOCK_CODE[cnt]+')\n';
			}
			get_total_stock='';
			//document.getElementById('product_name_exit1').value =new_sql;
		}
		//specli stok kontrolleri
		if(popup_spec_type==1 && list_len(main_spec_id_list,',') >1)//sepcli stok bakılacaksa 
		{
			if(dep_id=='' || dep_id==undefined || loc_id=='' || loc_id==undefined)
			{
				
				if(stock_type==undefined || stock_type==0)
				{
					var listParam2 = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
						var new_sql = 'prdp_get_total_stock_7';
					else
						var new_sql = 'prdp_get_total_stock_8';
				}
				else
				{
					var listParam = main_spec_id_list + "*" + <cfoutput>#dsn3_alias#</cfoutput> + "*" + <cfoutput>#dsn_alias#</cfoutput> + "*" + is_update + "*" + paper_date_kontrol;
					if(is_update != 0)
					{
						var new_sql='prdp_get_total_stock_9';
					}
					else
					{					
						var new_sql='prdp_get_total_stock_10';
					}
				}
			}
			else
			{
				var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + main_spec_id_list + "*" + is_update + "*" + loc_id + "*" + dep_id + "*" + paper_date_kontrol;
				if(is_update != 0)
					var new_sql = 'prdp_get_total_stock_11';
				else
					var new_sql = 'prdp_get_total_stock_12';
			}
			var get_total_stock = wrk_safe_query(new_sql,'dsn2',0,listParam);
			var query_spec_id_list='0';
			if(get_total_stock.recordcount)
			{
				for(var cnt=0; cnt < get_total_stock.recordcount; cnt++)
				{
					query_spec_id_list=query_spec_id_list+','+get_total_stock.SPECT_MAIN_ID[cnt];//queryden gelen kayıtları tutuyruz gelmeyenlerde stokta yoktur cunku
					var yer=list_find(main_spec_id_list,get_total_stock.SPECT_MAIN_ID[cnt],',');
					//alert(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]);
					//alert(main_spec_amount_list);
					if(parseFloat(get_total_stock.PRODUCT_TOTAL_STOCK[cnt]) < parseFloat(list_getat(main_spec_amount_list,yer,',')))
						hata = hata+ 'Ürün:'+get_total_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_total_stock.STOCK_CODE[cnt]+') (main spec id: '+get_total_stock.SPECT_MAIN_ID[cnt]+')\n';
				}
			}
			var diff_spec_id='0';
			for(var lst_cnt=1;lst_cnt <= list_len(main_spec_id_list,',');lst_cnt++)
			{
				var spc_id=list_getat(main_spec_id_list,lst_cnt,',');
				if(!list_find(query_spec_id_list,spc_id,','))
					diff_spec_id=diff_spec_id+','+spc_id;//kayıt ge"lmeyen urunler
			}
			if(diff_spec_id!='0' && list_len(diff_spec_id,',')>1)
			{//bu lokasyona hiç giriş veya çıkış olmadı ise kayıt gelemyecektir o yüzden else yazıldı
				var get_stock = wrk_safe_query('prdp_get_stock_2','dsn3',0,diff_spec_id);
				for(var cnt=0; cnt < get_stock.recordcount; cnt++)
					hata = hata+ 'Ürün:'+get_stock.PRODUCT_NAME[cnt]+' (Stok Kodu: '+get_stock.STOCK_CODE[cnt]+') (main spec id: '+get_stock.SPECT_MAIN_ID[cnt]+')\n';
			}
			get_total_stock='';
		}
	
		if(lotno_hata != '')
		{
			if(stock_type==undefined || stock_type==0)
				alert(lotno_hata+'\n\n <cf_get_lang dictionary_id="60055.Yukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir">. <cf_get_lang dictionary_id='60599.Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz'> !');
			else
				alert(lotno_hata+'\n\ <cf_get_lang dictionary_id="60055.Yukarıdaki ürünlerde lot no bazında stok miktarı yeterli değildir">. <cf_get_lang dictionary_id="60510.Lütfen miktarları kontrol ediniz"> !');
			lotno_hata='';
			return false;
		}
		else if(hata!='')
		{
			if(stock_type==undefined || stock_type==0)
				alert(hata+"\n\n<cf_get_lang dictionary_id ='36888.Yukarıdaki ürünlerde stok miktarı yeterli değildir Lütfen seçtiğiniz depo-lokasyonundaki miktarları kontrol ediniz'> ");
			else
				alert(hata+"\n\n<cf_get_lang dictionary_id ='36887.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir Lütfen miktarları kontrol ediniz'>");
			hata='';
			return false;
		}
		else
			return true;
	}
	<!--- todo --->
	function kontrol_et()
	{
		if(!chk_period(document.getElementById("finish_date"), 'İşlem')) return false;
		if((document.getElementById("exit_department_id").value == "") || (document.getElementById("production_department_id").value == ""))
		{
			alert("<cf_get_lang dictionary_id='36781.Stok Fişi Oluşturuyorsunuz'> ! <cf_get_lang dictionary_id='36782.Lütfen Giriş ve Çıkış Depolarınız Seçiniz'> !");
			return false;
		}
		<cfif isdefined('x_quality_control') and x_quality_control eq 1>
			<cfoutput query="get_row_enter">
				var pr_order_id_ = #pr_order_id#;
				if(document.getElementById("is_success_type_"+pr_order_id_) != undefined && document.getElementById("is_success_type_"+pr_order_id_).value != 1)
				{
					alert("<cf_get_lang dictionary_id='60516.Kalite Kontrol İşlemi Tamamlanmadan Sevk Edemezsiniz'>!");
					return false;
				}
			</cfoutput>
		</cfif>
		
		pr_order_id = $("#pr_order_id").val();
		//eğer fiş oluşurulmuşsa başka bir ekrandan fiş oluşturmayı engellemek için
		url_= '/V16/production_plan/cfc/get_prod_stock_detail.cfc?method=get_result_fis_info&pr_order_id='+ pr_order_id;
		$.ajax({
					url: url_,
					dataType: "text",
					cache:false,
					async: false,
					success: function(read_data) {
					data_ = jQuery.parseJSON(read_data);
					if(data_.DATA.length != 0)
					{
						alert("<cf_get_lang dictionary_id='60600.Bu Üretim Sonucuna Dair Fiş Oluşturulmuş'>. <cf_get_lang dictionary_id ='35615.Lütfen Sayfayı Yenileyiniz.'>");
						return false;
					}
				}
			});

		urlexit_= 'V16/production_plan/cfc/get_prod_stock_detail.cfc?method=get_prod_amount_exit_control&pr_order_id='+ pr_order_id;
		var hata = "";
		var hata2 = "";
		$.ajax({
				url: urlexit_,
				dataType: "text",
				cache:false,
				async: false,
				success: function(read_data) {
				data_ = jQuery.parseJSON(read_data);
				if(data_.DATA.length != 0)
				{
					$.each(data_.DATA,function(i){
						
						k = i + 1;
						var STOCK_ID_ = data_.DATA[i][0];
						var LOT_NO_ = data_.DATA[i][1];
						var AMOUNT_ = data_.DATA[i][2];
						var WRK_ROW_ID_ = data_.DATA[i][3];
						if(document.getElementById("row_kontrol_exit"+k).value==1)
						{
							var s_id = document.getElementById("stock_id_exit"+k).value;
							var amount_ = parseFloat(filterNum(document.getElementById("amount_exit"+k).value,8),8);
							var l_id = document.getElementById("lot_no_exit"+k).value;//.replace(/-/g, '_').replace(/\./g, '_');
							if(s_id !=STOCK_ID_ || l_id != LOT_NO_ || amount_ != AMOUNT_){
								var get_name = wrk_query("SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID = " +STOCK_ID_,'dsn3');
								hata = hata + 'Stok Kodu :' + get_name.STOCK_CODE+'\n';
							}
							
						}
						else{
							var wrk_row_id_ = document.getElementById("wrk_row_id_exit_"+k).value;
							if(wrk_row_id_ == WRK_ROW_ID_){
								hata2 = 'Satır sildikten sonra öncelikle belgeyi güncelleyiniz!';
							}
						}
					});
				}
			}
		});

		urloutage_= 'V16/production_plan/cfc/get_prod_stock_detail.cfc?method=get_prod_amount_outage_control&pr_order_id='+ pr_order_id;
		$.ajax({
				url: urloutage_,
				dataType: "text",
				cache:false,
				async: false,
				success: function(read_data) {
				data_ = jQuery.parseJSON(read_data);
				if(data_.DATA.length != 0)
				{
					$.each(data_.DATA,function(i){
						
						k = i + 1;
						var STOCK_ID_ = data_.DATA[i][0];
						var LOT_NO_ = data_.DATA[i][1];
						var AMOUNT_ = data_.DATA[i][2];
						var WRK_ROW_ID_ = data_.DATA[i][3];
						if(document.getElementById("row_kontrol_outage"+k).value==1)
						{
							var s_id = document.getElementById("stock_id_outage"+k).value;
							var amount_ = parseFloat(filterNum(document.getElementById("amount_outage"+k).value,8),8);
							var l_id = document.getElementById("lot_no_outage"+k).value;//.replace(/-/g, '_').replace(/\./g, '_')
							if(s_id !=STOCK_ID_ || l_id != LOT_NO_ || amount_ != AMOUNT_){
								var get_name = wrk_query("SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID = " +STOCK_ID_,'dsn3');
								hata = hata + 'Stok Kodu :' + get_name.STOCK_CODE+'\n';
							}
							
						}
						else{
							var wrk_row_id_ = document.getElementById("wrk_row_id_outage_"+k).value;
							if(wrk_row_id_ == WRK_ROW_ID_){
								hata2 = 'Satır sildikten sonra öncelikle belgeyi güncelleyiniz!';
							}
						}
					});
				}
			}
			
		});

		if(hata != ''){
			alert(hata+"<cf_get_lang dictionary_id='60601.Ürünlerde Değişiklik Yaptıktan Sonra Belgeyi Güncelleyiniz'>!");	
			return false;
		}
		if(hata2 != ''){
			alert(hata2);	
			return false;
		}
		
		var get_process = wrk_safe_query('prdp_get_process','dsn3',0,document.getElementById("process_cat").value);
		if(get_process.IS_ZERO_STOCK_CONTROL == 1)
		{
			if(!zero_stock_control()) return false; //todo
			//if(!zero_stock_control(form_basket.exit_department_id.value,form_basket.exit_location_id.value,0,'form_basket.record_num_exit','form_basket.product_id_exit','form_basket.stock_id_exit','form_basket.amount_exit_','form_basket.product_name_exit','form_basket.is_sevkiyat','form_basket.row_kontrol_exit','form_basket.spec_main_id_exit',0,'form_basket.lot_no_exit')) return false;
			//if(!zero_stock_control(form_basket.exit_department_id.value,form_basket.exit_location_id.value,0,'form_basket.record_num_outage','form_basket.product_id_outage','form_basket.stock_id_outage','form_basket.amount_outage','form_basket.product_name_outage',0,'form_basket.row_kontrol_outage','form_basket.spec_main_id_outage',0,'form_basket.lot_no_outage')) return false;
		}
		_sesion_control_();
		form_basket.action='<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_add_production_result_to_stock';
		form_basket.submit();
		return false;
	}
	
	function temizle(id)
	{
		if(id==0)
		{
			document.getElementById("station_id").value = "";
			document.getElementById("station_name").value = "";
		}
	}
	function aktar()
	{
		var round_number = document.getElementById('round_number').value;
		if(document.getElementById("fire_recordcount"))
			var fire_uzunluk=document.getElementById("fire_recordcount").value;
		else
			var fire_uzunluk=0;
		var sarf_uzunluk=parseInt(document.getElementById("sarf_recordcount").value);/*Toplam alt ürünlerin sayısı*/
		var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
		var emir=parseFloat(<cfoutput>#GET_DETAIL.AMOUNT#</cfoutput>);
		var kalan=wrk_round(parseFloat(emir)-parseFloat(toplam),round_number);
		<cfif x_por_amount_lte_po eq 0>//<!--- XML ayarlarında üretim sonuçlarının toplamı üretim emrinin miktarından fazla olamaz denildi ise.... --->
			<cfif GET_DETAIL.IS_DEMONTAJ eq 0 and isdefined('GET_SUM_AMOUNT')>
				var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_exit_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
				if(filterNum(document.getElementById("amount"+1).value,round_number)>(kalan))
					{
					alert("<cf_get_lang dictionary_id ='36886.Girilen Üretim Miktarı,Belirtilen Emir Miktarını Geçmektedir,Değerlerinizi Kontrol Ediniz Max Üretim Miktarı'>: "+kalan);
					document.getElementById("amount"+1).value = document.getElementById("amount_"+1).value;
					}
			<cfelseif GET_DETAIL.IS_DEMONTAJ eq 1 and isdefined('GET_SUM_AMOUNT')>
				var toplam=parseFloat(<cfoutput>#GET_SUM_AMOUNT.SUM_AMOUNT#</cfoutput>)-filterNum(document.getElementById("amount_"+1).value,round_number);/*Şu ana kadar üretilen toplam*/
				if(filterNum(document.getElementById("amount_exit"+1).value,round_number)>(kalan))
					{
					alert("<cf_get_lang dictionary_id ='36886.Girilen Üretim Miktarı,Belirtilen Emir Miktarını Geçmektedir,Değerlerinizi Kontrol Ediniz Max Üretim Miktarı'>: "+kalan);
					document.getElementById("amount_exit"+1).value = document.getElementById("amount_exit_"+1).value;
					}
			</cfif>
		</cfif>

		<cfif get_detail.is_demontaj eq 0>
			if(document.getElementById("auto_calc_amount_exit") != undefined && document.getElementById("auto_calc_amount_exit").value == 1)
			{
				for (i=1;i<=sarf_uzunluk;i++)
				{
					if(document.getElementById("is_free_amount"+i).value == 0)
					{
						<cfif isdefined('GET_SUM_AMOUNT')>
							var x=parseInt(document.getElementById("amount"+1).value);
							if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
								{
									<cfif x_is_fire_product eq 1>
										var a=document.getElementById("amount_exit"+i).value=(parseFloat(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/parseFloat(filterNum(document.getElementById("amount_"+1).value,round_number)))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
									<cfelse>
										var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
									</cfif>
									var b=commaSplit(a,round_number);
									document.getElementById("amount_exit"+i).value=b;
								}
						<cfelseif not isdefined('GET_SUM_AMOUNT')>
							var x=parseInt(document.getElementById("amount"+1).value);
							if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
								{
									<cfif x_is_fire_product eq 1>
										var a=document.getElementById("amount_exit"+i).value=parseFloat((filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
									<cfelse>
										var a=document.getElementById("amount_exit"+i).value=(filterNum(document.getElementById("amount_exit_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
									</cfif>
									var b=commaSplit(a,round_number);
									document.getElementById("amount_exit"+i).value=b;
									
								}
						</cfif>
					}
				}
				if(fire_uzunluk>0)
				{
					for (i=1;i<=fire_uzunluk;i++)
					{	
						<cfif get_detail.is_demontaj eq 0 and isdefined('GET_SUM_AMOUNT')>
							var x=parseInt(document.getElementById("amount"+1).value);
							if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
								{
									if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
									{
										<cfif x_is_fire_product eq 1>
											var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
										<cfelse>
											var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
										</cfif>
									}
									else
									{
										var c=0;
									}
									var d=commaSplit(c,round_number);
									document.getElementById("amount_outage"+i).value=d;
								}
						<cfelseif get_detail.is_demontaj eq 0 and not isdefined('GET_SUM_AMOUNT')>
							var x=parseInt(document.getElementById("amount"+1).value);
							if(x>0)/*Eğer Üretilecek olan ana ürün miktarı 1den büyükse.*/
								{
									if(parseFloat(document.getElementById("amount_"+1).value) != 0 && parseFloat(document.getElementById("amount"+1).value) != 0)
									{
										<cfif x_is_fire_product eq 1>
											var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(parseFloat(filterNum(document.getElementById("amount"+1).value,round_number))+parseFloat(filterNum(document.getElementById("fire_amount_"+1).value,round_number)));
										<cfelse>
											var c=document.getElementById("amount_outage"+i).value=(filterNum(document.getElementById("amount_outage_"+i).value,round_number))/(filterNum(document.getElementById("amount_"+1).value,round_number))*(filterNum(document.getElementById("amount"+1).value,round_number));
										</cfif>
									}
									else
									{
										var c=0;
									}
									var d=commaSplit(c,round_number);
									document.getElementById("amount_outage"+i).value=d;
								}
						</cfif>
					}
				}
				<cfif isDefined("x_exit_amount_change_auto") and x_exit_amount_change_auto neq 1>
					document.getElementById("auto_calc_amount_exit").value = 0;
				</cfif>
			}
		</cfif>
	}
	function spect_degistir()
		{
			<cfif GET_DETAIL.IS_DEMONTAJ eq 0>
				if(document.getElementById("spect_id_1").value!= document.getElementById("spect_id1").value)
				window.location.reload();
			<cfelse><!--- Eğer demontaj ise --->
				if(document.getElementById("spect_id_exit_1").value!= document.getElementById("spect_id_exit1").value)
				window.location.reload();
			</cfif>
		}
	function get_stok_spec_detail_ajax(product_id){
		goster(prod_stock_and_spec_detail_div);
		tempX = event.clientX + document.body.scrollLeft;
		tempY = event.clientY + document.body.scrollTop;
		document.getElementById('prod_stock_and_spec_detail_div').style.left = tempX + "px";
		document.getElementById('prod_stock_and_spec_detail_div').style.top = tempY + "px";
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&from_production_result_detail=1&uidrop_control=1&pid='+product_id+'</cfoutput>','prod_stock_and_spec_detail_div',1)	
	}
	function send_dep_loc(){	
		var station_id=document.getElementById('station_id').value;
		if(station_id!="")
		{
			var GET_STATION=wrk_safe_query('prdp_get_station','dsn3',0,station_id);
			var exit_dep_id=GET_STATION.EXIT_DEP_ID;
			var exit_loc_id=GET_STATION.EXIT_LOC_ID;
			var production_dep_id=GET_STATION.PRODUCTION_DEP_ID;
			var production_loc_id=GET_STATION.PRODUCTION_LOC_ID;
			var enter_dep_id=GET_STATION.ENTER_DEP_ID;
			var enter_loc_id=GET_STATION.ENTER_LOC_ID;
			if(exit_dep_id!="" && exit_loc_id!="" ){
					var exit_dep_query=workdata('get_department_id',exit_dep_id);
					var exit_loc_query=workdata('get_location_id',exit_loc_id,exit_dep_id);
					document.getElementById('exit_department_id').value=exit_dep_query.DEPARTMENT_ID;
					document.getElementById('exit_location_id').value=exit_loc_query.LOCATION_ID;
					document.getElementById('exit_department').value=exit_dep_query.DEPARTMENT_HEAD +'-' + exit_loc_query.COMMENT;
				}
			else{
					document.getElementById('exit_department_id').value="";
					document.getElementById('exit_location_id').value="";
					document.getElementById('exit_department').value="";
				}
		  if(production_dep_id!="" && production_loc_id!="" ){
					var production_dep_query=workdata('get_department_id',production_dep_id);
					var production_loc_query=workdata('get_location_id',production_loc_id,production_dep_id);
					document.getElementById('production_department_id').value=production_dep_query.DEPARTMENT_ID;
					document.getElementById('production_location_id').value=production_loc_query.LOCATION_ID;
					document.getElementById('production_department').value=production_dep_query.DEPARTMENT_HEAD +'-'+ production_loc_query.COMMENT;
				}
			else{
					document.getElementById('production_department_id').value="";
					document.getElementById('production_location_id').value="";
					document.getElementById('production_department').value="";
				}
			if(enter_dep_id!="" && enter_loc_id!="" ){
					var enter_dep_query=workdata('get_department_id',enter_dep_id);
					var enter_loc_query=workdata('get_location_id',enter_loc_id,enter_dep_id);
					document.getElementById('enter_department_id').value=enter_dep_query.DEPARTMENT_ID;
					document.getElementById('enter_location_id').value=enter_loc_query.LOCATION_ID;
					document.getElementById('enter_department').value=enter_dep_query.DEPARTMENT_HEAD +'-' + enter_loc_query.COMMENT;
				}
			else{
					document.getElementById('enter_department_id').value="";
					document.getElementById('enter_location_id').value="";
					document.getElementById('enter_department').value="";
				}
		}
		else
		return false;
	} 
	function open_station(){
		<cfoutput>
			stock_id = document.getElementById('stock_id1').value ;
			str = '#request.self#?fuseaction=prod.popup_list_workstation&field_name=form_basket.station_name&field_id=form_basket.station_id';
			<cfif isdefined("is_product_station_relation") and is_product_station_relation eq 1>
				str = str + '&stock_id='+stock_id ;
			</cfif>
			windowopen(str,'list');
		</cfoutput>
	}
	function find_amount2(value){
		if($("#form_basket #amount"+value).val()!='' && $("#form_basket #weight"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight"+value).val());
				amount=filterNum($("#form_basket #amount"+value).val());
				$("#form_basket #amount2_"+value).val(commaSplit(amount/weight));
			}
	}
	function find_weight(value) {
		if($("#form_basket #width"+value).val()!='' && $("#form_basket #height"+value).val()!='' && $("#form_basket #length"+value).val()!='')
		{
			dimention=filterNum($("#form_basket #width"+value).val())*filterNum($("#form_basket #height"+value).val())*filterNum($("#form_basket #length"+value).val());
			specific_weight=filterNum($("#form_basket #specific_weight"+value).val());
			$("#form_basket #weight"+value).val(commaSplit(dimention/1000*specific_weight));
		}
		find_amount2(value);
	}
	function Get_Product_Unit_2_And_Quantity_2(value) {
		<!--- elementUnit='unit2'+value;
		get_product_unit = wrk_safe_query('get_units_by_product_unit_id','dsn3',0,document.getElementById(elementUnit).value);
        _quantityValue = document.getElementById('amount'+value).value;
        _quantityValue = _quantityValue.replace(".","");
        _quantityValue = _quantityValue.replace(",",".");
        _selectValue = get_product_unit.MULTIPLIER;
        _quantityValue2=Math.ceil(_quantityValue / _selectValue);
        w=_quantityValue % _selectValue; //kalan ihtiyaç olursa diye..
        document.getElementById('amount2_'+value).value=_quantityValue2;
        return _quantityValue2; --->
		if($("#form_basket #width"+value).val()!='' && $("#form_basket #height"+value).val()!='' && $("#form_basket #length"+value).val()!='')
		{
		dimention=filterNum($("#form_basket #width"+value).val())*filterNum($("#form_basket #height"+value).val())*filterNum($("#form_basket #length"+value).val());
		weight=filterNum($("#form_basket #weight"+value).val());
		$("#form_basket #specific_weight"+value).val(commaSplit(weight*1000/dimention));
		}
		if($("#form_basket #amount2_"+value).val()!='' && $("#form_basket #weight"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight"+value).val());
				amount2=filterNum($("#form_basket #amount2_"+value).val());
				$("#form_basket #amount"+value).val(commaSplit(amount2*weight));
			}
    }
	function pencere_ac_work(no)
		{
			

			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&is_form_submitted=1&modal_project_head=<cfoutput><cfif len(get_detail.PROJECT_ID)>#get_project_name(get_detail.PROJECT_ID)#</cfif>&modal_project_id=<cfif len(get_detail.PROJECT_ID)>#get_detail.PROJECT_ID#</cfif></cfoutput>&field_id=form_basket.work_id' + no +'&field_name=form_basket.work_head' + no);
		}
	<!--- SARFLAR --->
	function find_amount2_exit(value){
		if($("#form_basket #amount_exit"+value).val()!='' && $("#form_basket #weight_exit"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight_exit"+value).val());
				amount=filterNum($("#form_basket #amount_exit"+value).val());
				$("#form_basket #amount_exit2_"+value).val(commaSplit(amount/weight));
			}
	}
	function find_weight_exit(value) {
		if($("#form_basket #width_exit"+value).val()!='' && $("#form_basket #height_exit"+value).val()!='' && $("#form_basket #length_exit"+value).val()!='')
		{
			dimention=filterNum($("#form_basket #width_exit"+value).val())*filterNum($("#form_basket #height_exit"+value).val())*filterNum($("#form_basket #length_exit"+value).val());
			specific_weight=filterNum($("#form_basket #specific_weight_exit"+value).val());
			$("#form_basket #weight_exit"+value).val(commaSplit(dimention/1000*specific_weight));
		}
		find_amount2_exit(value);
	}
	function Get_Product_Unit_2_And_Quantity_2_exit(value) {
		if($("#form_basket #width_exit"+value).val()!='' && $("#form_basket #height_exit"+value).val()!='' && $("#form_basket #length_exit"+value).val()!='')
		{
		dimention=filterNum($("#form_basket #width_exit"+value).val())*filterNum($("#form_basket #height_exit"+value).val())*filterNum($("#form_basket #length_exit"+value).val());
		weight=filterNum($("#form_basket #weight_exit"+value).val());
		$("#form_basket #specific_weight_exit"+value).val(commaSplit(weight*1000/dimention));
		}
		if($("#form_basket #amount_exit2_"+value).val()!='' && $("#form_basket #weight_exit"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight_exit"+value).val());
				amount2=filterNum($("#form_basket #amount_exit2_"+value).val());
				$("#form_basket #amount_exit"+value).val(commaSplit(amount2*weight));
			}
    }
	<!--- FİRELER --->
function find_amount2_outage(value){
		if($("#form_basket #amount_outage"+value).val()!='' && $("#form_basket #weight_outage"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight_outage"+value).val());
				amount=filterNum($("#form_basket #amount_outage"+value).val());
				$("#form_basket #amount_outage2_"+value).val(commaSplit(amount/weight));
			}
	}
	function find_weight_outage(value) {
		if($("#form_basket #width_outage"+value).val()!='' && $("#form_basket #height_outage"+value).val()!='' && $("#form_basket #length_outage"+value).val()!='')
		{
			dimention=filterNum($("#form_basket #width_outage"+value).val())*filterNum($("#form_basket #height_outage"+value).val())*filterNum($("#form_basket #length_outage"+value).val());
			specific_weight=filterNum($("#form_basket #specific_weight_outage"+value).val());
			$("#form_basket #weight_outage"+value).val(commaSplit(dimention/1000*specific_weight));
		}
		find_amount2_outage(value);
	}
	function Get_Product_Unit_2_And_Quantity_2_outage(value) {
		if($("#form_basket #width_outage"+value).val()!='' && $("#form_basket #height_outage"+value).val()!='' && $("#form_basket #length_outage"+value).val()!='')
		{
		dimention=filterNum($("#form_basket #width_outage"+value).val())*filterNum($("#form_basket #height_outage"+value).val())*filterNum($("#form_basket #length_outage"+value).val());
		weight=filterNum($("#form_basket #weight_outage"+value).val());
		$("#form_basket #specific_weight_outage"+value).val(commaSplit(weight*1000/dimention));
		}
		if($("#form_basket #amount_outage2_"+value).val()!='' && $("#form_basket #weight_outage"+value).val()!='')
			{
				weight=filterNum($("#form_basket #weight_outage"+value).val());
				amount2=filterNum($("#form_basket #amount_outage2_"+value).val());
				$("#form_basket #amount_outage"+value).val(commaSplit(amount2*weight));
			}
    }
	<cfif isdefined('is_show_two_units') and is_show_two_units eq 1>
	$(document).ready(function(){

		value=document.getElementById("indexCurrent").value;
		sel=document.getElementById('unit2'+value);
		for (i = 0; i < sel.length; i++) {
			opt = sel[i];
			if (document.getElementById("unit2_order").value== opt.text) {
				document.getElementById('unit2'+value).selectedIndex=opt.index;
			}
		}
		Get_Product_Unit_2_And_Quantity_2(value);
	});
	</cfif>
</script>