<cfquery name="GET_SHIP" datasource="#dsn2#">
	SELECT * FROM SHIP WHERE SHIP_ID = #row_ship_id#
</cfquery>
<cfquery name="get_inventory_type" datasource="#dsn2#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,IS_ACCOUNT_GROUP,IS_PROJECT_BASED_ACC,IS_BUDGET,IS_STOCK_ACTION,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_COST FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 118 AND IS_DEFAULT = 1
</cfquery>
<cfif get_inventory_type.recordcount eq 0>
	<script type="text/javascript">
		alert("Demirbaş Stok Fişi İşlem Kategorisi Tanımlayınız !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif len(GET_SHIP.SUBSCRIPTION_ID)>
	<cfquery name="get_inv_stock" datasource="#dsn2#">
		SELECT * FROM STOCK_FIS WHERE RELATED_SHIP_ID = #row_ship_id#
	</cfquery>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
		SELECT
			SHIP_ROW.*,
			ISNULL((
					SELECT 
						TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
					FROM 
						#dsn3_alias#.PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=SHIP_ROW.PRODUCT_ID AND
						ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0) AND
						PRODUCT_COST.START_DATE <= SHIP.SHIP_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),SHIP_ROW.PRICE) AS PROD_COST
		FROM 
			SHIP_ROW,
			SHIP 
		WHERE 
			SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
			SHIP_ROW.SHIP_ID = #row_ship_id#
		ORDER BY
			SHIP_ROW.SHIP_ROW_ID
	</cfquery>
	<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
		SELECT * FROM SHIP_MONEY WHERE ACTION_ID = #row_ship_id#
	</cfquery>
	<cfquery name="GET_SUBS_INFO" datasource="#dsn2#">
		SELECT * FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #GET_SHIP.SUBSCRIPTION_ID#
	</cfquery>
	<cfquery name="GET_BRANCH" datasource="#dsn2#">
		SELECT * FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = #GET_SHIP.DELIVER_STORE_ID#
	</cfquery>
	<cfquery name="get_gen_paper_" datasource="#dsn2#">
		  SELECT * FROM #dsn3_alias#.GENERAL_PAPERS WHERE ZONE_TYPE = 0 AND STOCK_FIS_NO IS NOT NULL
	</cfquery>
	<cfset paper_code = evaluate('get_gen_paper_.STOCK_FIS_NO')>
	<cfset system_paper_no_add_inv = evaluate('get_gen_paper_.STOCK_FIS_NUMBER') +1>
	<cfset attributes.FIS_NO = '#paper_code#-#system_paper_no_add_inv#'>
	<cfscript>
		attributes.start_date = dateformat(GET_SHIP.SHIP_DATE,dateformat_style);
		form.process_cat = get_inventory_type.process_cat_id;
		attributes.process_cat = get_inventory_type.process_cat_id;
		attributes.kur_say = GET_MONEY_INFO.RECORDCOUNT;
		for(stp_mny=1;stp_mny lte GET_MONEY_INFO.RECORDCOUNT;stp_mny=stp_mny+1)
		{
			if(GET_MONEY_INFO.IS_SELECTED[stp_mny])
				attributes.rd_money = "#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#,#stp_mny#,#GET_MONEY_INFO.RATE1[stp_mny]#,#GET_MONEY_INFO.RATE2[stp_mny]#";
			if(GET_SHIP.OTHER_MONEY eq GET_MONEY_INFO.MONEY_TYPE[stp_mny])
				currency_mult_other = (GET_MONEY_INFO.RATE2[stp_mny]/GET_MONEY_INFO.RATE1[stp_mny]);

			'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY_INFO.MONEY_TYPE[stp_mny];
			'attributes.txt_rate1_#stp_mny#'=GET_MONEY_INFO.RATE1[stp_mny];	
			'attributes.txt_rate2_#stp_mny#'=GET_MONEY_INFO.RATE2[stp_mny];
			'attributes.t_txt_rate1_#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#'=GET_MONEY_INFO.RATE1[stp_mny];	
			'attributes.t_txt_rate2_#GET_MONEY_INFO.MONEY_TYPE[stp_mny]#'=GET_MONEY_INFO.RATE2[stp_mny];
		}
		attributes.department_id_2 = GET_SHIP.DELIVER_STORE_ID;
		attributes.location_id_2 = GET_SHIP.LOCATION;
		attributes.department_id = "";
		attributes.location_id = "";
		branch_id_2 = GET_BRANCH.BRANCH_ID;
		branch_id = "";
		if (len(GET_SHIP.DELIVER_EMP_ID))
			deliver_get_id = GET_SHIP.DELIVER_EMP_ID;
		else
			deliver_get_id = session.ep.userid;

		attributes.ref_no = GET_SHIP.ref_no;
		attributes.project_id = GET_SHIP.PROJECT_ID;
		attributes.project_head = GET_SHIP.PROJECT_ID;
		attributes.detail = GET_SHIP.SHIP_DETAIL;
		attributes.subscription_id = GET_SHIP.SUBSCRIPTION_ID;
		attributes.record_num = GET_SHIP_ROW.recordcount;
		inventory_type_info = 4;
		alert_product_1 = '';
		alert_product_2 = '';
	</cfscript>
	<cfloop query="GET_SHIP_ROW">
		<cfset row_info = GET_SHIP_ROW.currentrow>
		<cfquery name="GET_INV_CAT" datasource="#dsn2#">
			SELECT INVENTORY_CAT_ID,INVENTORY_CODE,AMORTIZATION_METHOD_ID,AMORTIZATION_TYPE_ID,AMORTIZATION_EXP_CENTER_ID,AMORTIZATION_EXP_ITEM_ID,AMORTIZATION_CODE FROM #dsn3_alias#.PRODUCT_PERIOD WHERE PRODUCT_ID = #GET_SHIP_ROW.PRODUCT_ID# AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfif not GET_INV_CAT.recordcount or (GET_INV_CAT.recordcount and not len(GET_INV_CAT.INVENTORY_CAT_ID))>
			<cfset alert_product_1 = "#alert_product_1##GET_SHIP_ROW.currentrow#.Satır : #GET_SHIP_ROW.NAME_PRODUCT#\n">
		</cfif>		
		<cfif len(GET_INV_CAT.AMORTIZATION_EXP_ITEM_ID)>
			<cfquery name="GET_EXPENSE_ITEM_STA_CODE" datasource="#dsn2#">
				SELECT
					ACCOUNT_CODE
				FROM
					EXPENSE_ITEMS
				WHERE 
					EXPENSE_ITEM_ID = #GET_INV_CAT.AMORTIZATION_EXP_ITEM_ID#
			</cfquery>
		</cfif>
		<cfif len(GET_INV_CAT.INVENTORY_CAT_ID)>
			<cfquery name="GET_INV_CAT_DETAIL" datasource="#dsn2#">
				SELECT AMORTIZATION_RATE,INVENTORY_DURATION FROM #dsn3_alias#.SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = #GET_INV_CAT.INVENTORY_CAT_ID#
			</cfquery>
		<cfelse>
			<cfset GET_INV_CAT_DETAIL.recordcount = 0>	
			<cfset GET_INV_CAT_DETAIL.INVENTORY_DURATION = 0>	
			<cfset GET_INV_CAT_DETAIL.AMORTIZATION_RATE = 0>	
		</cfif>
		<cfif not GET_INV_CAT_DETAIL.recordcount>
			<cfset alert_product_2 = "#alert_product_2##GET_SHIP_ROW.currentrow#.Satır : #GET_SHIP_ROW.NAME_PRODUCT#\n">
		</cfif>
		<cfscript>
			row_gross_total = GET_SHIP_ROW.PROD_COST;
			row_tax_total = 0;
			row_rate_1 = evaluate('attributes.t_txt_rate1_#GET_SHIP_ROW.OTHER_MONEY#');
			row_rate_2 = evaluate('attributes.t_txt_rate2_#GET_SHIP_ROW.OTHER_MONEY#');
			row_currency_mult = row_rate_2 / row_rate_1;
			row_other_gross_total = GET_SHIP_ROW.PROD_COST/row_currency_mult;
			'attributes.row_kontrol#row_info#' = 1;
			'attributes.invent_no#row_info#' = "#GET_SUBS_INFO.SUBSCRIPTION_NO#_#GET_SHIP.SHIP_ID#_#currentrow#";
			'attributes.invent_name#row_info#' = GET_SHIP_ROW.NAME_PRODUCT;
			'attributes.quantity#row_info#' = GET_SHIP_ROW.AMOUNT;
			'attributes.row_total#row_info#' = row_gross_total;
			'attributes.amortization_rate#row_info#' = GET_INV_CAT_DETAIL.AMORTIZATION_RATE;
			if(len(GET_INV_CAT.AMORTIZATION_METHOD_ID))
				'attributes.amortization_method#row_info#' = GET_INV_CAT.AMORTIZATION_METHOD_ID;//sabit miktar uzerinden
			else
				'attributes.amortization_method#row_info#' = 1;//sabit miktar uzerinden
			'attributes.account_id#row_info#' = GET_INV_CAT.INVENTORY_CODE;
			'attributes.period#row_info#' = 12;
			'attributes.expense_center_id#row_info#' = GET_INV_CAT.AMORTIZATION_EXP_CENTER_ID;
			'attributes.expense_item_id#row_info#' = GET_INV_CAT.AMORTIZATION_EXP_ITEM_ID;
			if(len(GET_INV_CAT.AMORTIZATION_EXP_ITEM_ID))
				'attributes.debt_account_id#row_info#' = GET_EXPENSE_ITEM_STA_CODE.ACCOUNT_CODE;
			else
				'attributes.debt_account_id#row_info#' = '';
			'attributes.claim_account_id#row_info#' = "#GET_INV_CAT.AMORTIZATION_CODE#";
			
			'attributes.expense_item_name#row_info#' = "Gider Kalemi";
			'attributes.inventory_cat_id#row_info#' = GET_INV_CAT.INVENTORY_CAT_ID;
			'attributes.inventory_cat#row_info#' = 'Sabit Kıymet Kategorisi';
			'attributes.inventory_duration#row_info#' = GET_INV_CAT_DETAIL.INVENTORY_DURATION;
			if(len(GET_INV_CAT.AMORTIZATION_TYPE_ID))	
				'attributes.amortization_type#row_info#' = GET_INV_CAT.AMORTIZATION_TYPE_ID;
			else
				'attributes.amortization_type#row_info#' = 2;
			'attributes.subscription_id#row_info#' = GET_SHIP.SUBSCRIPTION_ID;
			'attributes.stock_id#row_info#' = GET_SHIP_ROW.STOCK_ID;
			'attributes.product_id#row_info#' = GET_SHIP_ROW.PRODUCT_ID;
			'attributes.stock_unit#row_info#' = GET_SHIP_ROW.UNIT;
			'attributes.stock_unit_id#row_info#' = GET_SHIP_ROW.UNIT_ID;
			'attributes.row_other_total#row_info#' = row_other_gross_total;
			'attributes.tax_rate#row_info#' = 0;
			'attributes.kdv_total#row_info#' = row_tax_total;
			'attributes.money_id#row_info#' = GET_SHIP_ROW.OTHER_MONEY;
			related_ship_id = row_ship_id;
			is_transaction = 1;
		</cfscript>
	</cfloop>
	<cfif len(alert_product_1)>
		<script type="text/javascript">
			alert("<cfoutput>#alert_product_1#</cfoutput>" + "\n\nYukarıdaki Ürünler İçin Sabit Kıymet Tanımlarını Kontrol Ediniz!");
			history.back();
		</script>
	</cfif>
	<cfif len(alert_product_2)>
		<script type="text/javascript">
			alert("<cfoutput>#alert_product_2#</cfoutput>" + "\n\nYukarıdaki Ürünler İçin Sabit Kıymet Kategorilerini Kontrol Ediniz!");
			history.back();
		</script>
	</cfif>
	<cfif get_inv_stock.recordcount eq 0><!--- Ekleme --->
		<cfinclude template="../../inventory/query/add_invent_stock_fis.cfm">
	<cfelseif get_inv_stock.recordcount neq 0><!--- Güncelleme --->
		<cfset attributes.fis_id = get_inv_stock.FIS_ID>
		<cfset form.old_process_type = get_inv_stock.FIS_TYPE>
		<cfquery name="DEL_INV" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID IN (SELECT INVENTORY_ID FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #get_inv_stock.FIS_ID# AND PROCESS_TYPE = #get_inv_stock.FIS_TYPE# AND PERIOD_ID = #session.ep.period_id#)
		</cfquery>
		<cfquery name="DEL_INV_ROW" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #get_inv_stock.FIS_ID# AND PROCESS_TYPE = #get_inv_stock.FIS_TYPE# AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfinclude template="../../inventory/query/upd_invent_stock_fis.cfm">
	</cfif>
</cfif>


