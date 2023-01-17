<cfquery name="GET_ORDER_PRODUCTS" datasource="#dsn3#">
	SELECT
		ORDERS.GENERAL_PROM_ID,
		ORDERS.GENERAL_PROM_LIMIT,
		ORDERS.GENERAL_PROM_AMOUNT,
		ORDERS.GENERAL_PROM_DISCOUNT,
		ORDERS.FREE_PROM_ID,
		ORDERS.FREE_PROM_LIMIT,
		ORDERS.FREE_PROM_COST,
		ORDERS.FREE_PROM_AMOUNT,
		ORDERS.FREE_PROM_STOCK_ID,
		ORDERS.FREE_STOCK_PRICE,
		ORDERS.FREE_STOCK_MONEY,
		ORDERS.SA_DISCOUNT,
		(ORDER_ROW.QUANTITY-ORDER_ROW.CANCEL_AMOUNT) AS ROW_QUANTITY,
		ORDER_ROW.*
	FROM 
		ORDERS,
		ORDER_ROW
	WHERE
		ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
		AND ORDERS.ORDER_ID IN (#attributes.ORDER_ID#)
		<cfif isdefined("attributes.order_row_id")><!--- Emirlerde satir bazinda siparis gonderimi --->
			AND ORDER_ROW.ORDER_ROW_ID IN (#attributes.order_row_id#)
		</cfif>
		<cfif not isdefined("attributes.is_view")>
			AND ORDER_ROW.ORDER_ROW_CURRENCY IN (-6,-7)
		</cfif>
		<cfif isdefined("attributes.deliver_dept") and len(attributes.deliver_dept)>
			AND ORDER_ROW.DELIVER_DEPT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deliver_dept#">
		</cfif>		
	ORDER BY
		ORDER_ROW.ORDER_ROW_ID
</cfquery>

<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfif len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)> <!--- bulunan kayıtlara gore liste yeniden set ediliyor --->
</cfif>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
<input type="hidden" name="ship_order_row_list" id="ship_order_row_list" value="<cfoutput>#ValueList(GET_ORDER_PRODUCTS.ORDER_ROW_ID)#</cfoutput>">
<cfif not isdefined("attributes.is_view")>
	<cfquery name="get_order_ship_periods" datasource="#dsn3#">
		SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID =#attributes.order_id#
	</cfquery>
	<cfif get_order_ship_periods.recordcount>
		<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
		<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
			<cfquery name="GET_ORDER_SHIP" datasource="#dsn3#">
				SELECT
					PRODUCT_ID,STOCK_ID,SHIP_ROW.WRK_ROW_RELATION_ID,SUM(AMOUNT) AS SHIP_AMOUNT
				FROM
					#dsn2_alias#.SHIP SHIP,
					#dsn2_alias#.SHIP_ROW SHIP_ROW,
					ORDERS_SHIP
				WHERE
					SHIP.SHIP_ID = ORDERS_SHIP.SHIP_ID AND
					ORDERS_SHIP.ORDER_ID = #attributes.order_id# AND
					SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
					SHIP_ROW.ROW_ORDER_ID = #attributes.order_id# AND
					ORDERS_SHIP.PERIOD_ID = #session.ep.period_id#
				GROUP BY
					PRODUCT_ID,STOCK_ID,SHIP_ROW.WRK_ROW_RELATION_ID
			</cfquery>
			<cfquery name="GET_ORDER_SHIP_IADE" datasource="#dsn3#">
				SELECT
					SHIP_ROW.PRODUCT_ID,SHIP_ROW.STOCK_ID,SHIP_ROW.WRK_ROW_RELATION_ID,SUM(SHIP_ROW2.AMOUNT) AS SHIP_AMOUNT
				FROM
					#dsn2_alias#.SHIP SHIP,
					#dsn2_alias#.SHIP_ROW SHIP_ROW,
					#dsn2_alias#.SHIP_ROW SHIP_ROW2,
					#dsn2_alias#.SHIP SHIP2,
					ORDERS_SHIP
				WHERE
					SHIP.SHIP_ID = ORDERS_SHIP.SHIP_ID AND
					ORDERS_SHIP.ORDER_ID = #attributes.order_id# AND
					SHIP_ROW2.SHIP_ID = SHIP2.SHIP_ID AND
					SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
					SHIP_ROW.ROW_ORDER_ID = #attributes.order_id# AND
					SHIP_ROW.WRK_ROW_ID = SHIP_ROW2.WRK_ROW_RELATION_ID AND
					ORDERS_SHIP.PERIOD_ID = #session.ep.period_id#
					AND SHIP2.SHIP_TYPE IN (73,74,75)
				GROUP BY
					SHIP_ROW.PRODUCT_ID,SHIP_ROW.STOCK_ID,SHIP_ROW.WRK_ROW_RELATION_ID
			</cfquery>
		<cfelse>
			<cfquery name="get_period_dsns" datasource="#dsn#">
				SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
			</cfquery>
			<cfquery name="GET_ORDER_SHIP" datasource="#dsn3#">
				SELECT				
					SUM(AMOUNT) AS SHIP_AMOUNT,
					PRODUCT_ID,STOCK_ID,WRK_ROW_RELATION_ID
				FROM
				(
				<cfloop query="get_period_dsns">
					SELECT
						SUM(AMOUNT) AMOUNT,PRODUCT_ID,STOCK_ID,SR.WRK_ROW_RELATION_ID
					FROM
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
					WHERE
						S.SHIP_ID=SR.SHIP_ID AND
						SR.ROW_ORDER_ID=#attributes.order_id#
					GROUP BY
						PRODUCT_ID,STOCK_ID,SR.WRK_ROW_RELATION_ID
					<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
				</cfloop> ) AS A1
					GROUP BY
						PRODUCT_ID,STOCK_ID,WRK_ROW_RELATION_ID
			</cfquery>
			<cfquery name="GET_ORDER_SHIP_IADE" datasource="#dsn3#">
				SELECT				
					SUM(AMOUNT) AS SHIP_AMOUNT,
					PRODUCT_ID,STOCK_ID,WRK_ROW_RELATION_ID
				FROM
				(
				<cfloop query="get_period_dsns">
					SELECT
						SUM(SRR.AMOUNT) AMOUNT,SR.PRODUCT_ID,SR.STOCK_ID,SR.WRK_ROW_RELATION_ID
					FROM
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SRR,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S2
					WHERE
						S.SHIP_ID=SR.SHIP_ID AND
						S2.SHIP_ID=SRR.SHIP_ID AND
						SR.ROW_ORDER_ID=#attributes.order_id# AND
						SR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID
						AND S2.SHIP_TYPE IN (73,74,75)
					GROUP BY
						SR.PRODUCT_ID,SR.STOCK_ID,SR.WRK_ROW_RELATION_ID
					<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
				</cfloop> ) AS A1
					GROUP BY
						PRODUCT_ID,STOCK_ID,WRK_ROW_RELATION_ID
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.otv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.total_otv = 0;
	sepet.net_total = 0;
	if (isnumeric(get_order_products.SA_DISCOUNT))
		sepet.genel_indirim = get_order_products.SA_DISCOUNT;
	else
		sepet.genel_indirim = 0;

	if( len(get_order_products.general_prom_id) )
	{
		sepet.general_prom_id = get_order_products.general_prom_id;
		sepet.general_prom_limit = get_order_products.general_prom_limit;
		sepet.general_prom_discount = get_order_products.general_prom_discount;
		sepet.general_prom_amount = get_order_products.general_prom_amount;
	}
	if( len(get_order_products.free_prom_id) )
	{
		sepet.free_prom_id = get_order_products.free_prom_id;
		sepet.free_prom_limit = get_order_products.free_prom_limit;
		sepet.free_prom_amount = get_order_products.free_prom_amount;
		sepet.free_prom_cost = get_order_products.free_prom_cost;
		sepet.free_prom_stock_id = get_order_products.free_prom_stock_id;
		sepet.free_stock_price = get_order_products.free_stock_price;
		sepet.free_stock_money = get_order_products.free_stock_money;
	}

	yeni_miktar =0;
	i=0;
	for (k = 1; k lte get_order_products.recordcount;k=k+1)
		{
		if(isdefined('attributes.is_view'))
			yeni_miktar = get_order_products.quantity[k];
		else
		{
			temp_stock_id=get_order_products.stock_id[k];
			temp_product_id=get_order_products.product_id[k];
			temp_wrk_row_id=get_order_products.wrk_row_id[k];
			if(get_order_ship_periods.recordcount) //siparisin cekildigi irsaliye varsa
			{
				SQLString = "SELECT SHIP_AMOUNT FROM GET_ORDER_SHIP WHERE PRODUCT_ID=#temp_product_id# AND STOCK_ID=#temp_stock_id# AND WRK_ROW_RELATION_ID='#temp_wrk_row_id#'";
				check_ship_amount = cfquery(SQLString : SQLString, Datasource : DSN3, dbtype:'1');
				if(len(check_ship_amount.ship_amount))
					yeni_miktar = (get_order_products.quantity[k]-check_ship_amount.ship_amount);
				else
					yeni_miktar = get_order_products.quantity[k];
				SQLString = "SELECT SHIP_AMOUNT FROM GET_ORDER_SHIP_IADE WHERE PRODUCT_ID=#temp_product_id# AND STOCK_ID=#temp_stock_id# AND WRK_ROW_RELATION_ID='#temp_wrk_row_id#'";
				check_ship_amount_iade = cfquery(SQLString : SQLString, Datasource : DSN3, dbtype:'1');
				if(len(check_ship_amount_iade.ship_amount))
					yeni_miktar = (yeni_miktar+check_ship_amount_iade.ship_amount);
			}
			else
				yeni_miktar = get_order_products.quantity[k];
				
		}
		if(yeni_miktar gt 0)
		{	
			i=i+1;
			sepet.satir[i] = StructNew();
			sepet.satir[i].row_ship_id = get_order_products.ORDER_ID[k];
			sepet.satir[i].product_id = get_order_products.product_id[k];
			sepet.satir[i].product_name = get_order_products.product_name[k];
			sepet.satir[i].row_paymethod_id = get_order_products.paymethod_id[k];
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id =get_order_products.wrk_row_id[k];
			sepet.satir[i].promosyon_yuzde = get_order_products.PROM_COMISSION[k];	
			if(len(get_order_products.PROM_COST[k]))
				sepet.satir[i].promosyon_maliyet = get_order_products.PROM_COST[k];
			else
				sepet.satir[i].promosyon_maliyet = 0;
			sepet.satir[i].iskonto_tutar = get_order_products.DISCOUNT_COST[k];
			sepet.satir[i].is_promotion = get_order_products.IS_PROMOTION[k];
			sepet.satir[i].prom_stock_id = get_order_products.prom_stock_id[k];
			sepet.satir[i].row_promotion_id =get_order_products.PROM_ID[k] ;
			sepet.satir[i].is_commission = get_order_products.IS_COMMISSION[k];

			if(len(get_order_products.ORDER_ROW_CURRENCY[k]) ) sepet.satir[i].order_currency = get_order_products.ORDER_ROW_CURRENCY[k]; else sepet.satir[i].order_currency ='';
			if(len(get_order_products.RESERVE_TYPE[k]) ) sepet.satir[i].reserve_type=get_order_products.RESERVE_TYPE[k]; else sepet.satir[i].reserve_type='';
			if(len(get_order_products.reserve_date[k]) ) sepet.satir[i].reserve_date = dateformat(get_order_products.reserve_date[k],dateformat_style);	else sepet.satir[i].reserve_date ='';

			sepet.satir[i].amount = yeni_miktar;
			sepet.satir[i].unit = get_order_products.unit[k];
			sepet.satir[i].unit_id = get_order_products.unit_id[k];
			sepet.satir[i].price = get_order_products.price[k];
			if(len(get_order_products.price_other[k]) and len(get_order_products.other_money[k]) and get_order_products.other_money[k] is not '#session.ep.money#')
				sepet.satir[i].price_other = get_order_products.price_other[k];
			else
				sepet.satir[i].price_other = get_order_products.price[k];
			sepet.satir[i].tax_percent = get_order_products.tax[k];
			if(len(get_order_products.otv_oran[k])) //özel tüketim vergisi
				sepet.satir[i].otv_oran = get_order_products.otv_oran[k];
			else 
				sepet.satir[i].otv_oran = 0;
			sepet.satir[i].catalog_id = 0;
			sepet.satir[i].stock_id = get_order_products.stock_id[k];
			if( len(get_order_products.UNIQUE_RELATION_ID[k]) ) sepet.satir[i].row_unique_relation_id = get_order_products.UNIQUE_RELATION_ID[k]; else sepet.satir[i].row_unique_relation_id = "";
			if( len(get_order_products.PROM_RELATION_ID[k]) ) sepet.satir[i].prom_relation_id = get_order_products.PROM_RELATION_ID[k]; else sepet.satir[i].prom_relation_id = "";
			if( len(get_order_products.PRODUCT_NAME2[k]) ) sepet.satir[i].product_name_other = get_order_products.PRODUCT_NAME2[k]; else sepet.satir[i].product_name_other = "";
			if( len(get_order_products.AMOUNT2[k]) ) sepet.satir[i].amount_other = get_order_products.AMOUNT2[k]; else sepet.satir[i].amount_other = "";
			if( len(get_order_products.UNIT2[k]) ) sepet.satir[i].unit_other = get_order_products.UNIT2[k]; else sepet.satir[i].unit_other = "";
			if( len(get_order_products.EXTRA_PRICE[k]) ) sepet.satir[i].ek_tutar = get_order_products.EXTRA_PRICE[k]; else sepet.satir[i].ek_tutar = 0;
			//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
			if(len(get_order_products.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_order_products.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
			if(len(get_order_products.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_order_products.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
			if(len(get_order_products.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_order_products.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
			if(len(get_order_products.ROW_PROJECT_ID[i]))
			{
				sepet.satir[i].row_project_id=get_order_products.ROW_PROJECT_ID[i];
				sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_order_products.ROW_PROJECT_ID[i])];
			}
			if(len(get_order_products.EK_TUTAR_PRICE[k]))
			{
				sepet.satir[i].ek_tutar_price = get_order_products.EK_TUTAR_PRICE[k];
				if(len(get_order_products.AMOUNT2[k])) sepet.satir[i].ek_tutar_cost = get_order_products.EK_TUTAR_PRICE[k]*get_order_products.AMOUNT2[k]; else sepet.satir[i].ek_tutar_cost = get_order_products.EK_TUTAR_PRICE[k];
			}
			else
			{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
			
			if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
				sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
			else
				sepet.satir[i].ek_tutar_marj ='';
			//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
			
			if( len(get_order_products.EXTRA_PRICE_TOTAL[k]) ) sepet.satir[i].ek_tutar_total = get_order_products.EXTRA_PRICE_TOTAL[k]; else sepet.satir[i].ek_tutar_total = 0;
			if( len(get_order_products.EXTRA_PRICE_OTHER_TOTAL[k])) sepet.satir[i].ek_tutar_other_total = get_order_products.EXTRA_PRICE_OTHER_TOTAL[k]; else sepet.satir[i].ek_tutar_other_total = 0;
			
			if( len(get_order_products.SHELF_NUMBER[k]) ) sepet.satir[i].shelf_number = get_order_products.SHELF_NUMBER[k]; else sepet.satir[i].shelf_number = "";
			if( len(get_order_products.BASKET_EXTRA_INFO_ID[k]) ) sepet.satir[i].basket_extra_info = get_order_products.BASKET_EXTRA_INFO_ID[k]; else sepet.satir[i].basket_extra_info="";
			if( len(get_order_products.SELECT_INFO_EXTRA[k]) ) sepet.satir[i].select_info_extra = get_order_products.SELECT_INFO_EXTRA[k]; else sepet.satir[i].select_info_extra="";
			if( len(get_order_products.DETAIL_INFO_EXTRA[k]) ) sepet.satir[i].detail_info_extra = get_order_products.DETAIL_INFO_EXTRA[k]; else sepet.satir[i].detail_info_extra="";
			
			if( len(get_order_products.DUEDATE[k]) ) sepet.satir[i].duedate = get_order_products.duedate[k]; else sepet.satir[i].duedate = '';
			if( len(get_order_products.LIST_PRICE[k]) ) sepet.satir[i].list_price = get_order_products.LIST_PRICE[k]; else sepet.satir[i].list_price = get_order_products.PRICE[k];
			if( len(get_order_products.PRICE_CAT[k]) ) sepet.satir[i].price_cat = get_order_products.PRICE_CAT[k]; else sepet.satir[i].price_cat = '';
			if( len(get_order_products.NUMBER_OF_INSTALLMENT[k]) ) sepet.satir[i].number_of_installment = get_order_products.NUMBER_OF_INSTALLMENT[k]; else sepet.satir[i].number_of_installment = 0; 
			if(len(get_order_products.BASKET_EMPLOYEE_ID[k]))
			{	
				sepet.satir[i].basket_employee_id = get_order_products.BASKET_EMPLOYEE_ID[k]; 
				sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_order_products.BASKET_EMPLOYEE_ID[k])]; 
			}
			else
			{		
				sepet.satir[i].basket_employee_id = '';
				sepet.satir[i].basket_employee = '';
			}
			
			if(len(get_order_products.karma_product_id[k]) ) sepet.satir[i].karma_product_id=get_order_products.KARMA_PRODUCT_ID[k]; else sepet.satir[i].karma_product_id='';
			if (not len(get_order_products.discount_1[k])) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = get_order_products.discount_1[k];
			if (not len(get_order_products.discount_2[k])) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = get_order_products.discount_2[k];
			if (not len(get_order_products.discount_3[k])) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = get_order_products.discount_3[k];
			if (not len(get_order_products.discount_4[k])) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = get_order_products.discount_4[k];
			if (not len(get_order_products.discount_5[k])) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = get_order_products.discount_5[k];
			if (not len(get_order_products.discount_6[k])) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = get_order_products.discount_6[k];
			if (not len(get_order_products.discount_7[k])) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = get_order_products.discount_7[k];
			if (not len(get_order_products.discount_8[k])) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = get_order_products.discount_8[k];
			if (not len(get_order_products.discount_9[k])) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = get_order_products.discount_9[k];
			if (not len(get_order_products.discount_10[k])) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = get_order_products.discount_10[k];
			sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
			
			if(len(get_order_products.SPECT_VAR_ID[k]))
				maliyet=get_cost_info(stock_id:get_order_products.stock_id[k],spec_id:get_order_products.SPECT_VAR_ID[k]);
			else
				maliyet=get_cost_info(stock_id:get_order_products.stock_id[k]);
			if(listlen(maliyet,','))
			{
				if(len(listgetat(maliyet,2,','))) sepet.satir[i].net_maliyet=listgetat(maliyet,2,','); else sepet.satir[i].net_maliyet=0;
				if(len(listgetat(maliyet,3,','))) sepet.satir[i].extra_cost=listgetat(maliyet,3,','); else sepet.satir[i].extra_cost=0;
			}else
			{
				sepet.satir[i].net_maliyet =0;
				sepet.satir[i].extra_cost = 0;
			}
			
			if(len(get_order_products.GTIP_NUMBER[k]))
				sepet.satir[i].gtip_number=get_order_products.GTIP_NUMBER[k];
			else
				sepet.satir[i].gtip_number='';

			if(len(get_order_products.MARJ[k])) sepet.satir[i].marj = get_order_products.MARJ[k]; else sepet.satir[i].marj = 0;
			//Teslim tarihi irsaliyeye tasinsin mi 
			if(isDefined("xml_order_row_deliverdate_copy_to_ship") and xml_order_row_deliverdate_copy_to_ship eq 0)
				sepet.satir[i].deliver_date = "";
			else
				sepet.satir[i].deliver_date = dateformat(get_order_products.deliver_date[k],dateformat_style);
			
			if(len(trim(get_order_products.deliver_LOCATION[k])))
				sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[k]#-#get_order_products.deliver_LOCATION[k]#";
			else
				sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[k]#";
			
			sepet.satir[i].spect_id = get_order_products.SPECT_VAR_ID[k];
			sepet.satir[i].spect_name = get_order_products.SPECT_VAR_NAME[k];
			sepet.satir[i].lot_no = get_order_products.LOT_NO[k];

			SQLString = "SELECT STOCK_CODE,STOCK_CODE_2, BARCOD, IS_SERIAL_NO, IS_INVENTORY, IS_PRODUCTION, MANUFACT_CODE FROM STOCKS WHERE STOCK_ID = #get_order_products.stock_id[k]#";
			get_stock_name = cfquery(SQLString : SQLString, Datasource : DSN3);
			sepet.satir[i].barcode = get_stock_name.barcod;
			sepet.satir[i].special_code = get_stock_name.STOCK_CODE_2;
			sepet.satir[i].stock_code = get_stock_name.stock_code;
			sepet.satir[i].manufact_code = get_order_products.PRODUCT_MANUFACT_CODE[k];
			sepet.satir[i].is_inventory = get_stock_name.is_inventory;
			sepet.satir[i].is_production = get_stock_name.is_production;
			
			sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price)+sepet.satir[i].ek_tutar_total ;
			sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
			//sepet.satir[i].row_nettotal = get_order_products.NETTOTAL[k];
			sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
			if(len(get_order_products.otvtotal[k]))
			{ 
				sepet.satir[i].row_otvtotal = get_order_products.otvtotal[k];
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
			}
			else
			{
				sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal =sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
			}
			if(get_order_products.OTHER_MONEY[k] neq session.ep.money){
				sepet.satir[i].other_money = get_order_products.OTHER_MONEY[k];
				sepet.satir[i].other_money_value = get_order_products.OTHER_MONEY_VALUE[k];
				}
			else{
				sepet.satir[i].other_money = session.ep.money;
				sepet.satir[i].other_money_value = sepet.satir[i].row_nettotal;
				}
	
			
			sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
			sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
			sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_ a daha sonra kdv toplam ekleniyor altta
		
			// kdv array
			kdv_flag = 0;
			for (kk=1;kk lte arraylen(sepet.kdv_array);kk=kk+1)
				{
				if (sepet.kdv_array[kk][1] eq sepet.satir[i].tax_percent)
					{
					kdv_flag = 1;
					sepet.kdv_array[kk][2] = sepet.kdv_array[kk][2] + 0;
					if (ListFindNoCase(display_list, "otv_from_tax_price"))
					sepet.kdv_array[kk][3] = sepet.kdv_array[kk][3] + wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
				else
					sepet.kdv_array[kk][3] = sepet.kdv_array[kk][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
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
			if(len(get_order_products.LIST_PRICE[k])) sepet.satir[i].list_price = get_order_products.LIST_PRICE[k]; else sepet.satir[i].list_price = get_order_products.PRICE[k];
			if(len(get_order_products.PRICE_CAT[k])) sepet.satir[i].price_cat = get_order_products.PRICE_CAT[k]; else  sepet.satir[i].price_cat = '';
			if(len(get_order_products.CATALOG_ID[k])) sepet.satir[i].row_catalog_id = get_order_products.CATALOG_ID[k]; else  sepet.satir[i].row_catalog_id = '';
			if(len(get_order_products.NUMBER_OF_INSTALLMENT[k])) sepet.satir[i].number_of_installment = get_order_products.NUMBER_OF_INSTALLMENT[k]; else sepet.satir[i].number_of_installment = 0;
			if(len(get_order_products.REASON_CODE[k])) sepet.satir[i].reason_code = get_order_products.REASON_CODE[k] & '--' & get_order_products.REASON_NAME[k]; else  sepet.satir[i].row_catalog_id = '';
		
			// urun asortileri 
			SQLString = "SELECT * FROM PRODUCTION_ASSORTMENT WHERE ACTION_TYPE=2 AND ASSORTMENT_ID=#get_order_products.ORDER_ROW_ID[k]# ORDER BY PARSE1,PARSE2";
			get_assort = cfquery(SQLString : SQLString, Datasource : DSN3);
	
			sepet.satir[i].assortment_array = ArrayNew(1);
			for(j = 1 ; j lte get_assort.recordcount ; j=j+1)
				{
				sepet.satir[i].assortment_array[j] = StructNew();
				sepet.satir[i].assortment_array[j].property_id = get_assort.PARSE1[j];
				sepet.satir[i].assortment_array[j].property_detail_id = get_assort.PARSE2[j];
				sepet.satir[i].assortment_array[j].property_amount = get_assort.AMOUNT[j];
				}	
			}	
		}

	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];

	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
