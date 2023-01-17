<!---Satış veya satınalma siparişinden,satış veya alış faturası ekleme basketi--->
<cfquery name="GET_ORDER_ROW" datasource="#dsn3#">
	SELECT
		ODR.DUEDATE ROW_DUE_DATE,
		ODR.*,
		(ODR.QUANTITY-ISNULL(ODR.CANCEL_AMOUNT,0)) AS ROW_QUANTITY,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		S.STOCK_CODE,
		S.BARCOD,
		S.IS_SERIAL_NO,
		S.MANUFACT_CODE,
		S.STOCK_CODE_2,
		EXC.EXPENSE,
		EXI.EXPENSE_ITEM_NAME
	FROM 
		ORDER_ROW ODR
		LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ODR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
		LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ODR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
		STOCKS S
	WHERE
		ODR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
		<cfif isDefined("attributes.order_row_id") and Len(attributes.order_row_id)>
			AND ODR.ORDER_ROW_ID IN  (#attributes.order_row_id#)
		</cfif>
		AND ODR.STOCK_ID = S.STOCK_ID
		AND ODR.ORDER_ROW_CURRENCY IN (-6,-7)
	ORDER BY
		ODR.ORDER_ROW_ID
</cfquery>
<cfif GET_ORDER_ROW.recordcount>
<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_ROW.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_ROW.ROW_WORK_ID)),'numeric','asc',',')>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
<cfif len(row_work_id_list_)>
	<cfquery name="GET_ROW_WORKS" datasource="#dsn#">
		SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#row_work_id_list_#) ORDER BY WORK_ID
	</cfquery>
	<cfset row_work_id_list_=valuelist(GET_ROW_WORKS.WORK_ID)>
</cfif>
<cfif len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)> <!--- bulunan kayıtlara gore liste yeniden set ediliyor --->
</cfif>
<!--- Onceki Donem Faturalari Var Mi --->
<cfquery name="get_order_invoice_periods" datasource="#dsn3#">
	SELECT DISTINCT PERIOD_ID FROM ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfset orders_invoice_period_list = valuelist(get_order_invoice_periods.PERIOD_ID)>
<cfif listlen(orders_invoice_period_list) eq 1 and orders_invoice_period_list eq session.ep.period_id>
	<cfquery name="GET_ORDER_INV" datasource="#dsn3#">
		SELECT
			PRODUCT_ID,STOCK_ID,SUM(AMOUNT) AS INV_AMOUNT,ISNULL(WRK_ROW_RELATION_ID,0) AS INV_ROW_RELATION_ID
		FROM
			#dsn2_alias#.INVOICE INV,
			#dsn2_alias#.INVOICE_ROW INV_ROW,
			ORDERS_INVOICE
		WHERE
			INV.INVOICE_ID = ORDERS_INVOICE.INVOICE_ID AND
			ORDERS_INVOICE.ORDER_ID = INV_ROW.ORDER_ID AND
			ORDERS_INVOICE.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
			ISNULL(INV_ROW.WRK_ROW_RELATION_ID,0) IN (#ListQualify(ValueList(get_order_row.wrk_row_id,","),"'",",")#) AND
			INV_ROW.INVOICE_ID = INV.INVOICE_ID AND
			ORDERS_INVOICE.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		GROUP BY
			PRODUCT_ID,STOCK_ID,ISNULL(WRK_ROW_RELATION_ID,0)
	</cfquery>
<cfelseif ListLen(orders_invoice_period_list)>
	<cfquery name="get_period_dsns" datasource="#dsn#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_invoice_period_list#)
	</cfquery>
	<cfquery name="GET_ORDER_INV" datasource="#dsn3#">
		SELECT	
			PRODUCT_ID,STOCK_ID,SUM(AMOUNT) AS INV_AMOUNT,ISNULL(WRK_ROW_RELATION_ID,0) AS INV_ROW_RELATION_ID		
		FROM
			(
			<cfloop query="get_period_dsns">
				SELECT
					SUM(AMOUNT) AMOUNT,PRODUCT_ID,STOCK_ID,INV_ROW.WRK_ROW_RELATION_ID
				FROM
					#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE INV,
					#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW INV_ROW,
					ORDERS_INVOICE
				WHERE
					INV.INVOICE_ID = ORDERS_INVOICE.INVOICE_ID AND
					ORDERS_INVOICE.ORDER_ID = INV_ROW.ORDER_ID AND
					ORDERS_INVOICE.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
					ISNULL(INV_ROW.WRK_ROW_RELATION_ID,0) IN (#ListQualify(ValueList(get_order_row.wrk_row_id,","),"'",",")#) AND
					INV_ROW.INVOICE_ID = INV.INVOICE_ID AND
					ORDERS_INVOICE.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_period_dsns.period_id#">
				GROUP BY
					PRODUCT_ID,STOCK_ID,INV_ROW.WRK_ROW_RELATION_ID
				<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
			</cfloop> 
			) AS A1
		GROUP BY
			PRODUCT_ID,STOCK_ID,WRK_ROW_RELATION_ID
	</cfquery>
</cfif>
<!--- Onceki Donem Irsaliyeleri Var Mi --->
<cfquery name="get_order_ship_periods" datasource="#dsn3#">
	SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
	<cfquery name="GET_ORDER_SHP" datasource="#dsn3#">
		SELECT
			PRODUCT_ID,STOCK_ID,SUM(AMOUNT) AS INV_AMOUNT,ISNULL(WRK_ROW_RELATION_ID,0) AS INV_ROW_RELATION_ID
		FROM
			#dsn2_alias#.SHIP SHP,
			#dsn2_alias#.SHIP_ROW SHP_ROW,
			ORDERS_SHIP
		WHERE
			SHP.SHIP_ID = ORDERS_SHIP.SHIP_ID AND
			ORDERS_SHIP.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
			ISNULL(SHP_ROW.WRK_ROW_RELATION_ID,0) IN (#ListQualify(ValueList(get_order_row.wrk_row_id,","),"'",",")#) AND
			SHP_ROW.SHIP_ID = SHP.SHIP_ID AND
			ORDERS_SHIP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		GROUP BY
			PRODUCT_ID,STOCK_ID,ISNULL(WRK_ROW_RELATION_ID,0)
	</cfquery>
<cfelseif ListLen(orders_ship_period_list)>
	<cfquery name="get_period_dsns" datasource="#dsn#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
	</cfquery>
	<cfquery name="GET_ORDER_SHP" datasource="#dsn3#">
		SELECT	
			PRODUCT_ID,STOCK_ID,SUM(AMOUNT) AS INV_AMOUNT,ISNULL(WRK_ROW_RELATION_ID,0) AS INV_ROW_RELATION_ID			
		FROM
			(
			<cfloop query="get_period_dsns">
				SELECT
					SUM(AMOUNT) AMOUNT,PRODUCT_ID,STOCK_ID,SR.WRK_ROW_RELATION_ID
				FROM
					#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
					#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR,
					ORDERS_SHIP
				WHERE
					S.SHIP_ID = ORDERS_SHIP.SHIP_ID AND
					ORDERS_SHIP.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
					ISNULL(SR.WRK_ROW_RELATION_ID,0) IN (#ListQualify(ValueList(get_order_row.wrk_row_id,","),"'",",")#) AND
					S.SHIP_ID = SR.SHIP_ID AND
					ORDERS_SHIP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_period_dsns.period_id#">
				GROUP BY
					PRODUCT_ID,STOCK_ID,SR.WRK_ROW_RELATION_ID
				<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
			</cfloop> 
			) AS A1
		GROUP BY
			PRODUCT_ID,STOCK_ID,WRK_ROW_RELATION_ID
	</cfquery>
</cfif>

<cfset new_product_id_list=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_ROW.PRODUCT_ID)),'numeric','asc',',')>
<cfif len(new_product_id_list)>
	<cfquery name="get_product_accounts" datasource="#dsn3#">
		SELECT
			PER.ACCOUNT_CODE,
			PER.ACCOUNT_CODE_PUR,
			PER.PRODUCT_ID
		FROM
			PRODUCT_PERIOD PER
		WHERE
			PER.PRODUCT_ID IN (#new_product_id_list#) AND
			PER.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		ORDER BY
			PER.PRODUCT_ID
	</cfquery>
	<cfset new_product_id_list=listsort(ListDeleteDuplicates(valuelist(get_product_accounts.PRODUCT_ID)),'numeric','asc',',')>
</cfif>
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.otv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.stopaj = 0;
	sepet.stopaj_yuzde = 0;
	sepet.stopaj_rate_id = 0;
	sepet.total_otv = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	i=0;
	if (isnumeric(get_order_info.SA_DISCOUNT))
		sepet.genel_indirim = get_order_info.SA_DISCOUNT;

	if( len(get_order_info.general_prom_id) )
	{
		sepet.general_prom_id = get_order_info.general_prom_id;
		sepet.general_prom_limit = get_order_info.general_prom_limit;
		sepet.general_prom_discount = get_order_info.general_prom_discount;
		sepet.general_prom_amount = get_order_info.general_prom_amount;
	}
	if(len(get_order_info.free_prom_id))
	{
		sepet.free_prom_id = get_order_info.free_prom_id;
		sepet.free_prom_limit = get_order_info.free_prom_limit;
		sepet.free_prom_amount = get_order_info.free_prom_amount;
		sepet.free_prom_cost = get_order_info.free_prom_cost;
		sepet.free_prom_stock_id = get_order_info.free_prom_stock_id;
		sepet.free_stock_price = get_order_info.free_stock_price;
		sepet.free_stock_money = get_order_info.free_stock_money;
	}
</cfscript>
<cfoutput query="GET_ORDER_ROW">
	<cfscript>
		temp_stock_id=stock_id;
		temp_product_id=product_id;
		temp_order_row_id=ORDER_ROW_ID;
		yeni_miktar = row_quantity;
		
		//Fatura Bilgileri
		if(isDefined("GET_ORDER_INV") and GET_ORDER_INV.recordcount)
		{
			SQLString = "SELECT SUM(INV_AMOUNT) AS INV_AMOUNT,INV_ROW_RELATION_ID FROM GET_ORDER_INV WHERE PRODUCT_ID=#temp_product_id# AND STOCK_ID=#temp_stock_id# GROUP BY INV_ROW_RELATION_ID";
			check_ship_amount = cfquery(SQLString : SQLString, Datasource : DSN3, dbtype:'1');
			if(check_ship_amount.recordcount)
			{
				for(chck_shp_i=1;chck_shp_i lte check_ship_amount.recordcount;chck_shp_i=chck_shp_i+1)
				{
					if(len(check_ship_amount.INV_AMOUNT[chck_shp_i]) and check_ship_amount.INV_ROW_RELATION_ID[chck_shp_i] neq 0 and check_ship_amount.INV_ROW_RELATION_ID[chck_shp_i] is GET_ORDER_ROW.WRK_ROW_ID) //satır ilişkisi tutulan kayıtlar
					{
						yeni_miktar=yeni_miktar-check_ship_amount.INV_AMOUNT[chck_shp_i];
					}
					else if(len(check_ship_amount.INV_AMOUNT) and check_ship_amount.INV_ROW_RELATION_ID[chck_shp_i] eq 0) //eski kayıtlar
					{
						if(isdefined('stock_left_amount_#temp_stock_id#') and len(evaluate('stock_left_amount_#temp_stock_id#')))
							used_stock_amount=evaluate('stock_left_amount_#temp_stock_id#');
						else
							used_stock_amount=check_ship_amount.INV_AMOUNT;
						if(used_stock_amount gte yeni_miktar)
						{	
							'stock_left_amount_#temp_stock_id#'=used_stock_amount-get_order_row.row_quantity;
							yeni_miktar = 0;
						}
						else if(used_stock_amount lt yeni_miktar)
						{
							yeni_miktar = yeni_miktar-used_stock_amount;
							'stock_left_amount_#temp_stock_id#'=0;
						}
					}
				}
			}
		}
		//Irsaliye Bilgileri
		if(isDefined("GET_ORDER_SHP") and GET_ORDER_SHP.recordcount)
		{
			SQLString2 = "SELECT SUM(INV_AMOUNT) AS INV_AMOUNT,INV_ROW_RELATION_ID FROM GET_ORDER_SHP WHERE PRODUCT_ID=#temp_product_id# AND STOCK_ID=#temp_stock_id# GROUP BY INV_ROW_RELATION_ID";
			check_ship_amount_shp = cfquery(SQLString : SQLString2, Datasource : DSN3, dbtype:'1');
			//yeni_miktar = row_quantity;
			if(check_ship_amount_shp.recordcount)
			{
				for(chck_shp_i=1;chck_shp_i lte check_ship_amount_shp.recordcount;chck_shp_i=chck_shp_i+1)
				{
					if(len(check_ship_amount_shp.INV_AMOUNT[chck_shp_i]) and check_ship_amount_shp.INV_ROW_RELATION_ID[chck_shp_i] neq 0 and check_ship_amount_shp.INV_ROW_RELATION_ID[chck_shp_i] is GET_ORDER_ROW.WRK_ROW_ID) //satır ilişkisi tutulan kayıtlar
					{
						yeni_miktar=yeni_miktar-check_ship_amount_shp.INV_AMOUNT[chck_shp_i];
					}
					else if(len(check_ship_amount_shp.INV_AMOUNT) and check_ship_amount_shp.INV_ROW_RELATION_ID[chck_shp_i] eq 0) //eski kayıtlar
					{
						if(isdefined('stock_left_amount_#temp_stock_id#') and len(evaluate('stock_left_amount_#temp_stock_id#')))
							used_stock_amount=evaluate('stock_left_amount_#temp_stock_id#');
						else
							used_stock_amount=check_ship_amount_shp.INV_AMOUNT;
						if(used_stock_amount gte yeni_miktar)
						{	
							'stock_left_amount_#temp_stock_id#'=used_stock_amount-get_order_row.row_quantity;
							yeni_miktar = 0;
						}
						else if(used_stock_amount lt yeni_miktar)
						{
							yeni_miktar = yeni_miktar-used_stock_amount;
							'stock_left_amount_#temp_stock_id#'=0;
						}
					}
				}
			}
		}
			
	if(yeni_miktar gt 0 or IS_INVENTORY eq 0)
	{
	i = i+1;
	sepet.satir[i] = StructNew();
	sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	if(len(wrk_row_id[i])) sepet.satir[i].wrk_row_relation_id = wrk_row_id[i]; else  sepet.satir[i].wrk_row_relation_id =''; //siparisin wrk_row_id si cekildigi belgeye wrk_related_row_id olarak aktarılır
	sepet.satir[i].product_id = PRODUCT_ID;
	sepet.satir[i].is_inventory = IS_INVENTORY;
	sepet.satir[i].is_production = IS_PRODUCTION;
	sepet.satir[i].product_name = PRODUCT_NAME;
	if(IS_INVENTORY  eq 0)
		sepet.satir[i].amount = ROW_QUANTITY;
	else
		sepet.satir[i].amount = yeni_miktar;
	sepet.satir[i].unit = UNIT;
	sepet.satir[i].unit_id = UNIT_ID;
	sepet.satir[i].price = PRICE;
	if (len(new_product_id_list)){
		if(sale_product eq 0)
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE_PUR[listfind(new_product_id_list,PRODUCT_ID,',')];
		else
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE[listfind(new_product_id_list,PRODUCT_ID,',')];
	}
	else
		sepet.satir[i].product_account_code = "";
	
	if(len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
	if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
	if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;
	if(len(GET_ORDER_ROW.ROW_DUE_DATE)) sepet.satir[i].duedate = GET_ORDER_ROW.ROW_DUE_DATE; else sepet.satir[i].duedate = '';
	if(len(PAYMETHOD_ID)) sepet.satir[i].row_paymethod_id = PAYMETHOD_ID; else  sepet.satir[i].row_paymethod_id = '';
	if(len(BASKET_EMPLOYEE_ID))
	{	
		sepet.satir[i].basket_employee_id = BASKET_EMPLOYEE_ID; 
		sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,BASKET_EMPLOYEE_ID)]; 
	}
	else
	{		
		sepet.satir[i].basket_employee_id = '';
		sepet.satir[i].basket_employee = '';
	}
	if(not (isdefined("attributes.event") and (attributes.event is 'copy')) and isdefined("order_id") and len(order_id))
	sepet.satir[i].row_ship_id = order_id;
	//if (len(MARJ)) sepet.satir[i].marj = MARJ; else sepet.satir[i].marj = '';
	//if (len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; /else sepet.satir[i].net_maliyet = 0;
	if(len(KARMA_PRODUCT_ID)) sepet.satir[i].karma_product_id = KARMA_PRODUCT_ID; else  sepet.satir[i].karma_product_id = '';
	if (not len(DISCOUNT_1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT_1;
	if (not len(DISCOUNT_2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = DISCOUNT_2;
	if (not len(DISCOUNT_3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = DISCOUNT_3;
	if (not len(DISCOUNT_4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = DISCOUNT_4;
	if (not len(DISCOUNT_5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = DISCOUNT_5;
	if (not len(DISCOUNT_6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = DISCOUNT_6;
	if (not len(DISCOUNT_7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = DISCOUNT_7;
	if (not len(DISCOUNT_8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = DISCOUNT_8;
	if (not len(DISCOUNT_9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = DISCOUNT_9;
	if (not len(DISCOUNT_10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = DISCOUNT_10;
	sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	sepet.satir[i].net_maliyet = 0;
	sepet.satir[i].paymethod_id = PAYMETHOD_ID;
	sepet.satir[i].stock_id = STOCK_ID;
	sepet.satir[i].barcode = BARCOD;
	sepet.satir[i].special_code = STOCK_CODE_2;
	sepet.satir[i].stock_code = STOCK_CODE;
	sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
	if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
	if(len(PROM_RELATION_ID)) sepet.satir[i].prom_relation_id = PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
	if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
	if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
	if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
	if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
	//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
	if(len(EK_TUTAR_PRICE))
		{
			sepet.satir[i].ek_tutar_price = EK_TUTAR_PRICE;
			if(len(AMOUNT2)) sepet.satir[i].ek_tutar_cost = EK_TUTAR_PRICE*AMOUNT2; else sepet.satir[i].ek_tutar_cost = EK_TUTAR_PRICE;
		}
		else
		{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
		
		if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
			sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
		else
			sepet.satir[i].ek_tutar_marj ='';
	//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
	if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
	if(len(EXTRA_PRICE_OTHER_TOTAL) ) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
	if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
	if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
	if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
	if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";

	if(len(WIDTH_VALUE[i])) sepet.satir[i].row_width = WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
	if(len(DEPTH_VALUE[i])) sepet.satir[i].row_depth = DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
	if(len(HEIGHT_VALUE[i])) sepet.satir[i].row_height = HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
	if(len(ROW_PROJECT_ID[i]))
	{
		sepet.satir[i].row_project_id=ROW_PROJECT_ID[i];
		sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID[i])];
	}
	if(len(ROW_WORK_ID[i]))
	{
		sepet.satir[i].row_work_id=ROW_WORK_ID[i];
		sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,ROW_WORK_ID[i])];
	}
	if(len(TAX)) sepet.satir[i].tax_percent = TAX; else sepet.satir[i].tax_percent = 0;
	if(len(OTV_ORAN)) sepet.satir[i].otv_oran = OTV_ORAN; else sepet.satir[i].otv_oran = 0;
	sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;

	sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan);
	sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
	if(len(OTVTOTAL))
	{ 
		sepet.satir[i].row_otvtotal =OTVTOTAL;
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
	}
	else
	{
		sepet.satir[i].row_otvtotal = 0;
		sepet.satir[i].row_lasttotal =sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
	}
	sepet.satir[i].other_money = OTHER_MONEY;
	if(len(OTHER_MONEY_VALUE))
		sepet.satir[i].other_money_value = ((OTHER_MONEY_VALUE/row_quantity)*yeni_miktar);
	else
		sepet.satir[i].other_money_value =0;
	
	sepet.satir[i].promosyon_yuzde = PROM_COMISSION;	
	if(len(PROM_COST)) sepet.satir[i].promosyon_maliyet = PROM_COST; else sepet.satir[i].promosyon_maliyet = 0;
	
	
	if(isdefined('is_copy_order_cost_') and is_copy_order_cost_ eq 1) /*xml de satış siparisteki maliyeti aktar secilmisse*/
	{
		if(len(COST_PRICE)) sepet.satir[i].net_maliyet=COST_PRICE; else sepet.satir[i].net_maliyet=0;
		if(len(EXTRA_COST)) sepet.satir[i].extra_cost = EXTRA_COST; else sepet.satir[i].extra_cost=0;
		if(len(MARJ)) sepet.satir[i].marj = MARJ; else sepet.satir[i].marj = '';
	}
	else
	{
		/*ONEMLİ: siparisten direk fatura olusturulan yerlerde, siparis ve irsaliye tarihleri arasında buyuk farklar olabilecegi ve bu surecte urun maliyeti degismis 
		olacagından ek maliyet functionla hesaplanıyor, irsaliyeden faturaya geciş gibi durumlarda ise standart olarak irsaliyedeki ek maliyet faturaya da
		 aktarılıyor*/
		if(len(SPECT_VAR_ID))
			maliyet=get_cost_info(stock_id:STOCK_ID,spec_id:SPECT_VAR_ID);
		else
			maliyet=get_cost_info(stock_id:STOCK_ID);
		if(listlen(maliyet,','))
		{
			if(len(listgetat(maliyet,2,','))) sepet.satir[i].net_maliyet=listgetat(maliyet,2,','); else sepet.satir[i].net_maliyet=0;
			//attributes.is_rate_extra_cost_to_incoice == SatınAlma Siparişini Faturaya Çekilirken ürüne ait son EK maliyet satıra yansıtılsın seçeneği seçilmişse,bu değişken SatınAlma Siparişinde XML ayarlarından değiştirilir..
			if( isdefined('attributes.is_rate_extra_cost_to_incoice') and  attributes.is_rate_extra_cost_to_incoice eq 1 and len(listgetat(maliyet,3,','))) 
				sepet.satir[i].extra_cost=listgetat(maliyet,3,','); 
			else
				sepet.satir[i].extra_cost=0;
		}else
		{
			sepet.satir[i].net_maliyet =0;
			sepet.satir[i].extra_cost = 0;
		}
	}
	
	sepet.satir[i].iskonto_tutar = DISCOUNT_COST;
	sepet.satir[i].is_promotion = IS_PROMOTION;
	sepet.satir[i].prom_stock_id = prom_stock_id;
	sepet.satir[i].row_promotion_id = PROM_ID ;
	sepet.satir[i].is_commission = IS_COMMISSION;
	sepet.satir[i].other_money_grosstotal = 0;
	sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_	
	
	sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_
	if(len(DELIVER_LOCATION)) 
		sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOCATION ; 
	else 
		sepet.satir[i].deliver_dept = DELIVER_DEPT ; 
	sepet.satir[i].spect_id = spect_var_id;
	sepet.satir[i].spect_name = spect_var_name;
	sepet.satir[i].lot_no = LOT_NO;
	if(len(PRICE_OTHER) and len(OTHER_MONEY) and OTHER_MONEY is not '#session.ep.money#')
		sepet.satir[i].price_other = PRICE_OTHER;
	else
		sepet.satir[i].price_other = PRICE;
		
	//kdv array ve 	ötv array satış siparişinden satış faturası keserken dip doplamlarda sorun olduğu için açıldı. MT 23/03/2016 #98017
	// kdv array
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
				if (ListFindNoCase(display_list, "otv_from_tax_price"))
					sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
				else
					sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);		
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
			if (ListFindNoCase(display_list, "otv_from_tax_price"))
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
			else
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
			}
	// ötv array
	otv_flag = 0;
	for (z=1;z lte arraylen(sepet.otv_array);z=z+1)
		{
		if (sepet.otv_array[z][1] eq sepet.satir[i].otv_oran)
			{
			otv_flag = 1;
			sepet.otv_array[z][2] = sepet.otv_array[z][2] + sepet.satir[i].row_otvtotal;
			}
		}
	if (not otv_flag)
		{
		sepet.otv_array[arraylen(sepet.otv_array)+1][1] = sepet.satir[i].otv_oran;
		sepet.otv_array[arraylen(sepet.otv_array)][2] = sepet.satir[i].row_otvtotal;
		}
	
	if(len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
	if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
	if(len(CATALOG_ID)) sepet.satir[i].row_catalog_id = CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
	if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;

		/*Masraf Merkezi*/
			if( len(EXPENSE_CENTER_ID[i]) )
			{
				sepet.satir[i].row_exp_center_id = EXPENSE_CENTER_ID[i];
				sepet.satir[i].row_exp_center_name = EXPENSE[i];
			}
	
			//Aktivite Tipi
			sepet.satir[i].row_activity_id = ACTIVITY_TYPE_ID[i];
	
			//Bütçe Kalemi
			if( len(EXPENSE_ITEM_ID[i]) )
			{
				sepet.satir[i].row_exp_item_id = EXPENSE_ITEM_ID[i];
				sepet.satir[i].row_exp_item_name = EXPENSE_ITEM_NAME[i];
			}
	
			//Muhasebe Kodu
			if(len(ACC_CODE[i]))
			{
				sepet.satir[i].row_acc_code = ACC_CODE[i];
			}
			
			sepet.satir[i].row_oiv_rate = ( len( OIV_RATE[i] ) ) ? OIV_RATE[i] : '';
			sepet.satir[i].row_bsmv_rate = ( len( BSMV_RATE[i] ) ) ? BSMV_RATE[i] : '';
			sepet.satir[i].row_bsmv_currency = ( len( BSMV_CURRENCY[i] ) ) ? BSMV_CURRENCY[i] : '';
			sepet.satir[i].row_tevkifat_rate = ( len( TEVKIFAT_RATE[i] ) ) ? TEVKIFAT_RATE[i] : '';
			sepet.satir[i].row_tevkifat_amount = ( len( TEVKIFAT_AMOUNT[i] ) ) ? TEVKIFAT_AMOUNT[i] : '';
			sepet.satir[i].reason_code = ( len( REASON_CODE[i] ) ) ? REASON_CODE[i] & '--' & REASON_NAME[i] : '';
			sepet.satir[i].gtip_number = ( len( GTIP_NUMBER[i] ) ) ? gtip_number[i] : '';
			sepet.satir[i].is_serial_no = ( len( IS_SERIAL_NO[i] ) ) ? IS_SERIAL_NO[i] : 0;
	sepet.satir[i].assortment_array = ArrayNew(1);
	}
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
