<cf_xml_page_edit fuseact="stock.add_ship_from_file">
<cfquery name="get_open_orders" datasource="#dsn3#">
	SELECT
		O.ORDER_NUMBER,
		ROUND((ORR.QUANTITY-ORR.CANCEL_AMOUNT),4) ORDER_AMOUNT,
		ISNULL(ORR.SHIP_AMOUNT,0) AS SHIP_AMOUNT,
		ORR.*
	FROM
		ORDERS O,
		ORDER_ROW ORR
	WHERE
		O.ORDER_ID = ORR.ORDER_ID AND
		O.PURCHASE_SALES = 0 AND
		O.ORDER_ZONE = 0 AND
		O.ORDER_STATUS = 1 AND
		O.COMPANY_ID = #attributes.company_id# AND
		ORR.STOCK_ID = #get_product_main.STOCK_ID# AND
		ORR.ORDER_ROW_CURRENCY IN (-6,-7)
		<cfif isDefined('xml_order_relation_location_control') And xml_order_relation_location_control Eq 1 And isDefined('attributes.department_id') And Len(attributes.department_id) And isDefined('attributes.location_id') And Len(attributes.location_id)>
		AND O.DELIVER_DEPT_ID = #attributes.department_id#
		AND O.LOCATION_ID = #attributes.location_id#
		</cfif>
	ORDER BY
		O.ORDER_DATE,
		O.RECORD_DATE
</cfquery>

<cfset relation_ship_list = ''>
<cfoutput query="get_open_orders">
	<cfif order_id and not listfind(relation_ship_list,order_id)>
		<cfset relation_ship_list = ListAppend(relation_ship_list,order_id,',')>
	</cfif>
</cfoutput>
<cfif ListLen(relation_ship_list)>
	<cfquery name="get_setup_period" datasource="#dsn#">
		SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfquery name="get_relation_ship" datasource="#dsn3#">
		<cfloop query="get_setup_period">
			SELECT
				SHIP_ROW.WRK_ROW_RELATION_ID, 
				SHIP_ROW.AMOUNT
			FROM
				#dsn#_#get_setup_period.period_year#_#get_setup_period.our_company_id#.SHIP_ROW SHIP_ROW,
				ORDERS_SHIP OS,
				ORDER_ROW ORR
			WHERE
				OS.SHIP_ID = SHIP_ROW.SHIP_ID AND 
				OS.ORDER_ID = ORR.ORDER_ID AND 
				SHIP_ROW.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND 
				OS.ORDER_ID IN (<cfqueryparam list="yes" value="#relation_ship_list#">)
			<cfif currentrow neq get_setup_period.recordcount>
			UNION ALL
			</cfif>
		</cfloop>
		ORDER BY WRK_ROW_RELATION_ID
	</cfquery>
</cfif>
<cfset kalan_miktar = miktar>
<cfoutput query="get_open_orders">
	<cfset ship_amount = 0>
	<cfif isdefined("get_relation_ship")>
		<cfquery name="get_sub_amount" dbtype="query">
			SELECT SUM(AMOUNT) AMOUNT FROM get_relation_ship WHERE WRK_ROW_RELATION_ID = '#get_open_orders.wrk_row_id#'
		</cfquery>
		<cfif Len(get_sub_amount.amount)>
			<cfset ship_amount = get_sub_amount.amount>
		</cfif>
	</cfif>
	<cfif stock_id eq get_product_main.stock_id>
		<cfif not isdefined("use_amount_#wrk_row_id#")><cfset "use_amount_#wrk_row_id#" = 0></cfif>
		<cfset row_amount = order_amount - ship_amount - evaluate("use_amount_#wrk_row_id#")>
		<!--- order: <cfdump var="#order_amount#">
		use:<cfdump var="#evaluate("use_amount_#wrk_row_id#")#">
		row_amount:<cfdump var="#row_amount#">
		kalan:<cfdump var="#kalan_miktar#"><br> --->
		<cfif kalan_miktar gt 0 and row_amount gt 0>
			<cfif row_amount lt kalan_miktar>
				<cfset use_amount = row_amount>
			<cfelseif row_amount gte kalan_miktar>
				<cfset use_amount = kalan_miktar>
			</cfif>
			<cfscript>
				i = i+1;
				sepet.satir[i] = StructNew();
				
				sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				sepet.satir[i].wrk_row_relation_id = '#get_open_orders.wrk_row_id#';
				sepet.satir[i].row_ship_id = get_open_orders.order_id;
				sepet.satir[i].product_id = get_product_main.PRODUCT_ID;
				sepet.satir[i].product_name = get_product_main.PRODUCT_NAME&' '&get_product_main.PROPERTY;
				sepet.satir[i].amount = use_amount;

				sepet.satir[i].unit = get_open_orders.unit;
				sepet.satir[i].unit_id = get_open_orders.unit_id;
				sepet.satir[i].paymethod_id = get_open_orders.paymethod_id;
				sepet.satir[i].promosyon_yuzde = get_open_orders.PROM_COMISSION;	
				if(len(get_open_orders.PROM_COST))
					sepet.satir[i].promosyon_maliyet = get_open_orders.PROM_COST;
				else
					sepet.satir[i].promosyon_maliyet = 0;
				sepet.satir[i].iskonto_tutar = get_open_orders.DISCOUNT_COST;
				sepet.satir[i].is_promotion = get_open_orders.IS_PROMOTION;
				sepet.satir[i].prom_stock_id = get_open_orders.prom_stock_id;
				sepet.satir[i].row_promotion_id =get_open_orders.PROM_ID ;
				sepet.satir[i].is_commission = get_open_orders.IS_COMMISSION;

				if(len(get_open_orders.ORDER_ROW_CURRENCY) ) sepet.satir[i].order_currency = get_open_orders.ORDER_ROW_CURRENCY; else sepet.satir[i].order_currency ='';
				if(len(get_open_orders.RESERVE_TYPE) ) sepet.satir[i].reserve_type=get_open_orders.RESERVE_TYPE; else sepet.satir[i].reserve_type='';
				if(len(get_open_orders.reserve_date) ) sepet.satir[i].reserve_date = dateformat(get_open_orders.reserve_date,dateformat_style);	else sepet.satir[i].reserve_date ='';

				sepet.satir[i].price = get_open_orders.price;
				if(len(get_open_orders.price_other) and len(get_open_orders.other_money) and get_open_orders.other_money is not '#session.ep.money#')
					sepet.satir[i].price_other = get_open_orders.price_other;
				else
					sepet.satir[i].price_other = get_open_orders.price;
				sepet.satir[i].tax_percent = get_open_orders.tax;
				if(len(get_open_orders.otv_oran)) //özel tüketim vergisi
					sepet.satir[i].otv_oran = get_open_orders.otv_oran;
				else 
					sepet.satir[i].otv_oran = 0;
				sepet.satir[i].catalog_id = 0;
				sepet.satir[i].stock_id = get_open_orders.stock_id;
				if( len(get_open_orders.UNIQUE_RELATION_ID) ) sepet.satir[i].row_unique_relation_id = get_open_orders.UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
				if( len(get_open_orders.PROM_RELATION_ID) ) sepet.satir[i].prom_relation_id = get_open_orders.PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
				if( len(get_open_orders.PRODUCT_NAME2) ) sepet.satir[i].product_name_other = get_open_orders.PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
				if( len(get_open_orders.AMOUNT2) ) sepet.satir[i].amount_other = get_open_orders.AMOUNT2; else sepet.satir[i].amount_other = "";
				if( len(get_open_orders.UNIT2) ) sepet.satir[i].unit_other = get_open_orders.UNIT2; else sepet.satir[i].unit_other = "";
				if( len(get_open_orders.EXTRA_PRICE) ) sepet.satir[i].ek_tutar = get_open_orders.EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
				//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
				if(len(get_open_orders.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_open_orders.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
				if(len(get_open_orders.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_open_orders.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
				if(len(get_open_orders.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_open_orders.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
				if(len(get_open_orders.ROW_PROJECT_ID[i]))
				{
					sepet.satir[i].row_project_id=get_open_orders.ROW_PROJECT_ID[i];
					sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_open_orders.ROW_PROJECT_ID[i])];
				}
				if(len(get_open_orders.EK_TUTAR_PRICE))
				{
					sepet.satir[i].ek_tutar_price = get_open_orders.EK_TUTAR_PRICE;
					if(len(get_open_orders.AMOUNT2)) sepet.satir[i].ek_tutar_cost = get_open_orders.EK_TUTAR_PRICE*get_open_orders.AMOUNT2; else sepet.satir[i].ek_tutar_cost = get_open_orders.EK_TUTAR_PRICE;
				}
				else
				{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
				
				if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
					sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
				else
					sepet.satir[i].ek_tutar_marj ='';
				//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
				
				if( len(get_open_orders.EXTRA_PRICE_TOTAL) ) sepet.satir[i].ek_tutar_total = get_open_orders.EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
				if( len(get_open_orders.EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = get_open_orders.EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
				
				if( len(get_open_orders.SHELF_NUMBER) ) sepet.satir[i].shelf_number = get_open_orders.SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
				if( len(get_open_orders.BASKET_EXTRA_INFO_ID) ) sepet.satir[i].basket_extra_info = get_open_orders.BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
				if(len(get_open_orders.SELECT_INFO_EXTRA) ) sepet.satir[i].select_info_extra = get_open_orders.SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
				if(len(get_open_orders.DETAIL_INFO_EXTRA) ) sepet.satir[i].detail_info_extra = get_open_orders.DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";
				
				if( len(get_open_orders.DUEDATE) ) sepet.satir[i].duedate = get_open_orders.duedate; else sepet.satir[i].duedate = '';
				if( len(get_open_orders.LIST_PRICE) ) sepet.satir[i].list_price = get_open_orders.LIST_PRICE; else sepet.satir[i].list_price = get_open_orders.PRICE;
				if( len(get_open_orders.PRICE_CAT) ) sepet.satir[i].price_cat = get_open_orders.PRICE_CAT; else sepet.satir[i].price_cat = '';
				if( len(get_open_orders.NUMBER_OF_INSTALLMENT) ) sepet.satir[i].number_of_installment = get_open_orders.NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0; 
				if(len(get_open_orders.BASKET_EMPLOYEE_ID))
				{	
					sepet.satir[i].basket_employee_id = get_open_orders.BASKET_EMPLOYEE_ID; 
					sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_open_orders.BASKET_EMPLOYEE_ID)]; 
				}
				else
				{		
					sepet.satir[i].basket_employee_id = '';
					sepet.satir[i].basket_employee = '';
				}
				
				if(len(get_open_orders.karma_product_id) ) sepet.satir[i].karma_product_id=get_open_orders.KARMA_PRODUCT_ID; else sepet.satir[i].karma_product_id='';
				if (not len(get_open_orders.discount_1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = get_open_orders.discount_1;
				if (not len(get_open_orders.discount_2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = get_open_orders.discount_2;
				if (not len(get_open_orders.discount_3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = get_open_orders.discount_3;
				if (not len(get_open_orders.discount_4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = get_open_orders.discount_4;
				if (not len(get_open_orders.discount_5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = get_open_orders.discount_5;
				if (not len(get_open_orders.discount_6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = get_open_orders.discount_6;
				if (not len(get_open_orders.discount_7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = get_open_orders.discount_7;
				if (not len(get_open_orders.discount_8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = get_open_orders.discount_8;
				if (not len(get_open_orders.discount_9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = get_open_orders.discount_9;
				if (not len(get_open_orders.discount_10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = get_open_orders.discount_10;
				sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
				
				if(len(get_open_orders.SPECT_VAR_ID))
					maliyet=get_cost_info(stock_id:get_open_orders.stock_id,spec_id:get_open_orders.SPECT_VAR_ID);
				else
					maliyet=get_cost_info(stock_id:get_open_orders.stock_id);
				if(listlen(maliyet,','))
				{
					if(len(listgetat(maliyet,2,','))) sepet.satir[i].net_maliyet=listgetat(maliyet,2,','); else sepet.satir[i].net_maliyet=0;
					if(len(listgetat(maliyet,3,','))) sepet.satir[i].extra_cost=listgetat(maliyet,3,','); else sepet.satir[i].extra_cost=0;
				}else
				{
					sepet.satir[i].net_maliyet =0;
					sepet.satir[i].extra_cost = 0;
				}
				if(len(get_open_orders.MARJ)) sepet.satir[i].marj = get_open_orders.MARJ; else sepet.satir[i].marj = 0;
				//Teslim tarihi irsaliyeye tasin mi 
				if(isDefined("xml_order_row_deliverdate_copy_to_ship") and xml_order_row_deliverdate_copy_to_ship eq 0)
					sepet.satir[i].deliver_date = "";
				else
					sepet.satir[i].deliver_date = dateformat(get_open_orders.deliver_date,dateformat_style);
				
				if(len(trim(get_open_orders.deliver_LOCATION)))
					sepet.satir[i].deliver_dept = "#get_open_orders.deliver_dept#-#get_open_orders.deliver_LOCATION#";
				else
					sepet.satir[i].deliver_dept = "#get_open_orders.deliver_dept#";
				sepet.satir[i].spect_id = get_open_orders.SPECT_VAR_ID;
				sepet.satir[i].spect_name = get_open_orders.SPECT_VAR_NAME;
				sepet.satir[i].lot_no = get_open_orders.LOT_NO;

				sepet.satir[i].barcode = get_product_main.barcode;
				sepet.satir[i].special_code = get_product_main.STOCK_CODE_2;
				sepet.satir[i].stock_code = get_product_main.stock_code;
				sepet.satir[i].manufact_code = get_open_orders.PRODUCT_MANUFACT_CODE;
				sepet.satir[i].is_inventory = get_product_main.is_inventory;
				sepet.satir[i].is_production = get_product_main.is_production;
				
				sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price)+sepet.satir[i].ek_tutar_total ;
				sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
				//sepet.satir[i].row_nettotal = get_open_orders.NETTOTAL;
				sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
				if(len(get_open_orders.otvtotal))
				{ 
					sepet.satir[i].row_otvtotal = get_open_orders.otvtotal;
					sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
				}
				else
				{
					sepet.satir[i].row_otvtotal = 0;
					sepet.satir[i].row_lasttotal =sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
				}
				if(get_open_orders.OTHER_MONEY neq session.ep.money){
					sepet.satir[i].other_money = get_open_orders.OTHER_MONEY;
					sepet.satir[i].other_money_value = get_open_orders.OTHER_MONEY_VALUE;
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
				for (kxj=1;kxj lte arraylen(sepet.kdv_array);kxj=kxj+1)
					{
					if (sepet.kdv_array[kxj][1] eq sepet.satir[i].tax_percent)
						{
						kdv_flag = 1;
						sepet.kdv_array[kxj][2] = sepet.kdv_array[kxj][2] + sepet.satir[i].row_taxtotal;
						sepet.kdv_array[kxj][3] = sepet.kdv_array[kxj][3] + sepet.satir[i].row_nettotal;
						}
					}
				if (not kdv_flag)
					{
					sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
					sepet.kdv_array[arraylen(sepet.kdv_array)][2] = sepet.satir[i].row_taxtotal;
					sepet.kdv_array[arraylen(sepet.kdv_array)][3] = sepet.satir[i].row_nettotal;
					}
				if(len(get_open_orders.LIST_PRICE)) sepet.satir[i].list_price = get_open_orders.LIST_PRICE; else sepet.satir[i].list_price = get_open_orders.PRICE;
				if(len(get_open_orders.PRICE_CAT)) sepet.satir[i].price_cat = get_open_orders.PRICE_CAT; else  sepet.satir[i].price_cat = '';
				if(len(get_open_orders.CATALOG_ID)) sepet.satir[i].row_catalog_id = get_open_orders.CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
				if(len(get_open_orders.NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = get_open_orders.NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;

				// urun asortileri 
				SQLString = "SELECT * FROM PRODUCTION_ASSORTMENT WHERE ACTION_TYPE = 2 AND ASSORTMENT_ID = #get_open_orders.order_row_id# ORDER BY PARSE1,PARSE2";
				get_assort = cfquery(SQLString : SQLString, Datasource : DSN3);
		
				sepet.satir[i].assortment_array = ArrayNew(1);
				for(j = 1 ; j lte get_assort.recordcount ; j=j+1)
				{
					sepet.satir[i].assortment_array[j] = StructNew();
					sepet.satir[i].assortment_array[j].property_id = get_assort.PARSE1[j];
					sepet.satir[i].assortment_array[j].property_detail_id = get_assort.PARSE2[j];
					sepet.satir[i].assortment_array[j].property_amount = get_assort.AMOUNT[j];
				}
				if(not listfind(order_id_list,get_open_orders.order_id))
				{
					order_id_list = listappend(order_id_list,get_open_orders.order_id);
					order_no_list = listappend(order_no_list,get_open_orders.order_number);
				}
				kalan_miktar = kalan_miktar - use_amount;
				"use_amount_#wrk_row_id#" = evaluate("use_amount_#wrk_row_id#") + use_amount;
			</cfscript>
		</cfif>
	</cfif>
</cfoutput>
<!--- <cfdump var="#kalan_miktar#"><br> --->
<cfif kalan_miktar gt 0><!--- Eğer açık kalan kısım varsa son siparişten verileri alıp basketi doldurur --->
	<cfquery name="get_open_orders" datasource="#dsn3#">
		SELECT
			O.ORDER_NUMBER,
			(ORR.QUANTITY-ORR.CANCEL_AMOUNT) ORDER_AMOUNT,
			ORR.*
		FROM
			ORDERS O,
			ORDER_ROW ORR
		WHERE
			O.ORDER_ID = ORR.ORDER_ID
			AND O.PURCHASE_SALES = 0 
			AND O.ORDER_ZONE = 0
			AND O.ORDER_STATUS = 1
			AND O.COMPANY_ID = #attributes.company_id#
			AND ORR.PRODUCT_ID = #get_product_main.product_id#
			AND ORR.ORDER_ROW_CURRENCY IN (-6,-7)
		ORDER BY
			O.ORDER_DATE DESC
	</cfquery>
	<cfif get_open_orders.recordcount>
		<cfscript>
			i = i+1;
			sepet.satir[i] = StructNew();
			sepet.kdv_array = ArrayNew(2);
			sepet.otv_array = ArrayNew(2);
			sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id = '';
			
			sepet.satir[i].product_id = get_product_main.PRODUCT_ID;
			sepet.satir[i].product_name = get_product_main.PRODUCT_NAME&' '&get_product_main.PROPERTY;
			sepet.satir[i].amount = kalan_miktar;
	
			sepet.satir[i].unit = get_open_orders.unit;
			sepet.satir[i].unit_id = get_open_orders.unit_id;
			sepet.satir[i].paymethod_id = get_open_orders.paymethod_id;
			sepet.satir[i].promosyon_yuzde = get_open_orders.PROM_COMISSION;	
			if(len(get_open_orders.PROM_COST))
				sepet.satir[i].promosyon_maliyet = get_open_orders.PROM_COST;
			else
				sepet.satir[i].promosyon_maliyet = 0;
			sepet.satir[i].iskonto_tutar = get_open_orders.DISCOUNT_COST;
			sepet.satir[i].is_promotion = get_open_orders.IS_PROMOTION;
			sepet.satir[i].prom_stock_id = get_open_orders.prom_stock_id;
			sepet.satir[i].row_promotion_id =get_open_orders.PROM_ID ;
			sepet.satir[i].is_commission = get_open_orders.IS_COMMISSION;
	
			if(len(get_open_orders.ORDER_ROW_CURRENCY) ) sepet.satir[i].order_currency = get_open_orders.ORDER_ROW_CURRENCY; else sepet.satir[i].order_currency ='';
			if(len(get_open_orders.RESERVE_TYPE) ) sepet.satir[i].reserve_type=get_open_orders.RESERVE_TYPE; else sepet.satir[i].reserve_type='';
			if(len(get_open_orders.reserve_date) ) sepet.satir[i].reserve_date = dateformat(get_open_orders.reserve_date,dateformat_style);	else sepet.satir[i].reserve_date ='';
	
			sepet.satir[i].price = get_open_orders.price;
			if(len(get_open_orders.price_other) and len(get_open_orders.other_money) and get_open_orders.other_money is not '#session.ep.money#')
				sepet.satir[i].price_other = get_open_orders.price_other;
			else
				sepet.satir[i].price_other = get_open_orders.price;
			sepet.satir[i].tax_percent = get_open_orders.tax;
			if(len(get_open_orders.otv_oran)) //özel tüketim vergisi
				sepet.satir[i].otv_oran = get_open_orders.otv_oran;
			else 
				sepet.satir[i].otv_oran = 0;
			sepet.satir[i].catalog_id = 0;
			sepet.satir[i].stock_id = get_open_orders.stock_id;
			if( len(get_open_orders.UNIQUE_RELATION_ID) ) sepet.satir[i].row_unique_relation_id = get_open_orders.UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
			if( len(get_open_orders.PROM_RELATION_ID) ) sepet.satir[i].prom_relation_id = get_open_orders.PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
			if( len(get_open_orders.PRODUCT_NAME2) ) sepet.satir[i].product_name_other = get_open_orders.PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
			if( len(get_open_orders.AMOUNT2) ) sepet.satir[i].amount_other = get_open_orders.AMOUNT2; else sepet.satir[i].amount_other = "";
			if( len(get_open_orders.UNIT2) ) sepet.satir[i].unit_other = get_open_orders.UNIT2; else sepet.satir[i].unit_other = "";
			if( len(get_open_orders.EXTRA_PRICE) ) sepet.satir[i].ek_tutar = get_open_orders.EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
			//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
			if(len(get_open_orders.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_open_orders.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
			if(len(get_open_orders.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_open_orders.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
			if(len(get_open_orders.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_open_orders.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
			if(len(get_open_orders.ROW_PROJECT_ID[i]))
			{
				sepet.satir[i].row_project_id=get_open_orders.ROW_PROJECT_ID[i];
				sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_open_orders.ROW_PROJECT_ID[i])];
			}
			if(len(get_open_orders.EK_TUTAR_PRICE))
			{
				sepet.satir[i].ek_tutar_price = get_open_orders.EK_TUTAR_PRICE;
				if(len(get_open_orders.AMOUNT2)) sepet.satir[i].ek_tutar_cost = get_open_orders.EK_TUTAR_PRICE*get_open_orders.AMOUNT2; else sepet.satir[i].ek_tutar_cost = get_open_orders.EK_TUTAR_PRICE;
			}
			else
			{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
			
			if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
				sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
			else
				sepet.satir[i].ek_tutar_marj ='';
			//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
			
			if( len(get_open_orders.EXTRA_PRICE_TOTAL) ) sepet.satir[i].ek_tutar_total = get_open_orders.EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
			if( len(get_open_orders.EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = get_open_orders.EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
			
			if( len(get_open_orders.SHELF_NUMBER) ) sepet.satir[i].shelf_number = get_open_orders.SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
			if( len(get_open_orders.BASKET_EXTRA_INFO_ID) ) sepet.satir[i].basket_extra_info = get_open_orders.BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
			if( len(get_open_orders.SELECT_INFO_EXTRA) ) sepet.satir[i].select_info_extra = get_open_orders.SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
			if( len(get_open_orders.DETAIL_INFO_EXTRA) ) sepet.satir[i].detail_info_extra = get_open_orders.DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";
			
			
			if( len(get_open_orders.DUEDATE) ) sepet.satir[i].duedate = get_open_orders.duedate; else sepet.satir[i].duedate = '';
			if( len(get_open_orders.LIST_PRICE) ) sepet.satir[i].list_price = get_open_orders.LIST_PRICE; else sepet.satir[i].list_price = get_open_orders.PRICE;
			if( len(get_open_orders.PRICE_CAT) ) sepet.satir[i].price_cat = get_open_orders.PRICE_CAT; else sepet.satir[i].price_cat = '';
			if( len(get_open_orders.NUMBER_OF_INSTALLMENT) ) sepet.satir[i].number_of_installment = get_open_orders.NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0; 
			if(len(get_open_orders.BASKET_EMPLOYEE_ID))
			{	
				sepet.satir[i].basket_employee_id = get_open_orders.BASKET_EMPLOYEE_ID; 
				sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_open_orders.BASKET_EMPLOYEE_ID)]; 
			}
			else
			{		
				sepet.satir[i].basket_employee_id = '';
				sepet.satir[i].basket_employee = '';
			}
			
			if(len(get_open_orders.karma_product_id) ) sepet.satir[i].karma_product_id=get_open_orders.KARMA_PRODUCT_ID; else sepet.satir[i].karma_product_id='';
			if (not len(get_open_orders.discount_1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = get_open_orders.discount_1;
			if (not len(get_open_orders.discount_2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = get_open_orders.discount_2;
			if (not len(get_open_orders.discount_3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = get_open_orders.discount_3;
			if (not len(get_open_orders.discount_4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = get_open_orders.discount_4;
			if (not len(get_open_orders.discount_5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = get_open_orders.discount_5;
			if (not len(get_open_orders.discount_6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = get_open_orders.discount_6;
			if (not len(get_open_orders.discount_7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = get_open_orders.discount_7;
			if (not len(get_open_orders.discount_8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = get_open_orders.discount_8;
			if (not len(get_open_orders.discount_9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = get_open_orders.discount_9;
			if (not len(get_open_orders.discount_10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = get_open_orders.discount_10;
			sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
			
			if(len(get_open_orders.SPECT_VAR_ID))
				maliyet=get_cost_info(stock_id:get_open_orders.stock_id,spec_id:get_open_orders.SPECT_VAR_ID);
			else
				maliyet=get_cost_info(stock_id:get_open_orders.stock_id);
			if(listlen(maliyet,','))
			{
				if(len(listgetat(maliyet,2,','))) sepet.satir[i].net_maliyet=listgetat(maliyet,2,','); else sepet.satir[i].net_maliyet=0;
				if(len(listgetat(maliyet,3,','))) sepet.satir[i].extra_cost=listgetat(maliyet,3,','); else sepet.satir[i].extra_cost=0;
			}else
			{
				sepet.satir[i].net_maliyet =0;
				sepet.satir[i].extra_cost = 0;
			}
			if(len(get_open_orders.MARJ)) sepet.satir[i].marj = get_open_orders.MARJ; else sepet.satir[i].marj = 0;
			//Teslim tarihi irsaliyeye tasin mi 
			if(isDefined("xml_order_row_deliverdate_copy_to_ship") and xml_order_row_deliverdate_copy_to_ship eq 0)
				sepet.satir[i].deliver_date = "";
			else
				sepet.satir[i].deliver_date = dateformat(get_open_orders.deliver_date,dateformat_style);
			
			if(len(trim(get_open_orders.deliver_LOCATION)))
				sepet.satir[i].deliver_dept = "#get_open_orders.deliver_dept#-#get_open_orders.deliver_LOCATION#";
			else
				sepet.satir[i].deliver_dept = "#get_open_orders.deliver_dept#";
			sepet.satir[i].spect_id = get_open_orders.SPECT_VAR_ID;
			sepet.satir[i].spect_name = get_open_orders.SPECT_VAR_NAME;
			sepet.satir[i].lot_no = get_open_orders.LOT_NO;
	
			sepet.satir[i].barcode = get_product_main.barcode;
			sepet.satir[i].stock_code = get_product_main.stock_code;
			sepet.satir[i].special_code = get_product_main.STOCK_CODE_2;
			sepet.satir[i].manufact_code = get_open_orders.PRODUCT_MANUFACT_CODE;
			sepet.satir[i].is_inventory = get_product_main.is_inventory;
			sepet.satir[i].is_production = get_product_main.is_production;
			
			sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price)+sepet.satir[i].ek_tutar_total ;
			sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
			//sepet.satir[i].row_nettotal = get_open_orders.NETTOTAL;
			sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
			if(len(get_open_orders.otvtotal))
			{ 
				sepet.satir[i].row_otvtotal = get_open_orders.otvtotal;
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
			}
			else
			{
				sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal =sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
			}
			if(get_open_orders.OTHER_MONEY neq session.ep.money){
				sepet.satir[i].other_money = get_open_orders.OTHER_MONEY;
				sepet.satir[i].other_money_value = get_open_orders.OTHER_MONEY_VALUE;
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
			for (kxj=1;kxj lte arraylen(sepet.kdv_array);kxj=kxj+1)
				{
				if (sepet.kdv_array[kxj][1] eq sepet.satir[i].tax_percent)
					{
					kdv_flag = 1;
					sepet.kdv_array[kxj][2] = sepet.kdv_array[kxj][2] + sepet.satir[i].row_taxtotal;
					sepet.kdv_array[kxj][3] = sepet.kdv_array[kxj][3] + sepet.satir[i].row_nettotal;
					}
				}
			if (not kdv_flag)
				{
				sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
				sepet.kdv_array[arraylen(sepet.kdv_array)][2] = sepet.satir[i].row_taxtotal;
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = sepet.satir[i].row_nettotal;
				}
			if(len(get_open_orders.LIST_PRICE)) sepet.satir[i].list_price = get_open_orders.LIST_PRICE; else sepet.satir[i].list_price = get_open_orders.PRICE;
			if(len(get_open_orders.PRICE_CAT)) sepet.satir[i].price_cat = get_open_orders.PRICE_CAT; else  sepet.satir[i].price_cat = '';
			if(len(get_open_orders.CATALOG_ID)) sepet.satir[i].row_catalog_id = get_open_orders.CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
			if(len(get_open_orders.NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = get_open_orders.NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;
	
			// urun asortileri 
			SQLString = "SELECT * FROM PRODUCTION_ASSORTMENT WHERE ACTION_TYPE = 2 AND ASSORTMENT_ID=#get_open_orders.order_row_id# ORDER BY PARSE1,PARSE2";
			get_assort = cfquery(SQLString : SQLString, Datasource : DSN3);
	
			sepet.satir[i].assortment_array = ArrayNew(1);
			for(j = 1 ; j lte get_assort.recordcount ; j=j+1)
			{
				sepet.satir[i].assortment_array[j] = StructNew();
				sepet.satir[i].assortment_array[j].property_id = get_assort.PARSE1[j];
				sepet.satir[i].assortment_array[j].property_detail_id = get_assort.PARSE2[j];
				sepet.satir[i].assortment_array[j].property_amount = get_assort.AMOUNT[j];
			}
		</cfscript>		
	<cfelse><!--- Siapriş yoksa basketi eski yöntemle doldurur --->
		<cfscript>
			i = i+1;
			sepet.satir[i] = StructNew();
			sepet.kdv_array = ArrayNew(2);
			sepet.otv_array = ArrayNew(2);
			sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id = '';
			
			sepet.satir[i].product_id = get_product_main.PRODUCT_ID;
			sepet.satir[i].is_inventory = get_product_main.IS_INVENTORY;
			sepet.satir[i].is_production = get_product_main.IS_PRODUCTION;
			sepet.satir[i].product_name = get_product_main.PRODUCT_NAME&' '&get_product_main.PROPERTY;
			sepet.satir[i].amount = kalan_miktar;
			sepet.satir[i].unit = get_product_main.add_unit;
			sepet.satir[i].unit_id = get_product_main.PRODUCT_UNIT_ID;
			sepet.satir[i].price = FIYAT;
			sepet.satir[i].indirim1 =0;
			sepet.satir[i].indirim2 =0;
			sepet.satir[i].indirim3 =0;
			sepet.satir[i].indirim4 =0;
			sepet.satir[i].indirim5 =0;
			sepet.satir[i].indirim6 =0;
			sepet.satir[i].indirim7 =0;
			sepet.satir[i].indirim8 =0;
			sepet.satir[i].indirim9 =0;
			sepet.satir[i].indirim10=0;
		</cfscript>
		<cfif get_aksiyons_all.recordcount>
			<cfquery name="get_aksiyons" dbtype="query" maxrows="1">
				SELECT
					DISCOUNT1,
					DISCOUNT2,
					DISCOUNT3,
					DISCOUNT4,
					DISCOUNT5,
					DISCOUNT6,
					DISCOUNT7,
					DISCOUNT8,
					DISCOUNT9,
					DISCOUNT10,
					PURCHASE_PRICE,
					MONEY
				FROM
					get_aksiyons_all
				WHERE
					PRODUCT_ID = #get_product_main.PRODUCT_ID#
				ORDER BY
					CATALOG_ID DESC
			</cfquery>
		<cfelse>
			<cfset get_aksiyons.recordcount = 0>
		</cfif>
		<cfscript>
			if(get_aksiyons.recordcount){
			if(len(get_aksiyons.discount1))sepet.satir[i].indirim1 = get_aksiyons.discount1;
			if(len(get_aksiyons.discount2))sepet.satir[i].indirim2 = get_aksiyons.discount2;
			if(len(get_aksiyons.discount3))sepet.satir[i].indirim3 = get_aksiyons.discount3;
			if(len(get_aksiyons.discount4))sepet.satir[i].indirim4 = get_aksiyons.discount4;
			if(len(get_aksiyons.discount5))sepet.satir[i].indirim5 = get_aksiyons.discount5;
			if(len(get_aksiyons.discount6))sepet.satir[i].indirim6 = get_aksiyons.discount6;
			if(len(get_aksiyons.discount7))sepet.satir[i].indirim7 = get_aksiyons.discount7;
			if(len(get_aksiyons.discount8))sepet.satir[i].indirim8 = get_aksiyons.discount8;
			if(len(get_aksiyons.discount9))sepet.satir[i].indirim9 = get_aksiyons.discount9;
			if(len(get_aksiyons.discount10))sepet.satir[i].indirim10 = get_aksiyons.discount10;
			if(len(get_aksiyons.PURCHASE_PRICE))sepet.satir[i].price = get_aksiyons.PURCHASE_PRICE;
			}
		</cfscript>
		<cfif not get_aksiyons.recordcount and get_contracts_all.recordcount>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				<cfquery name="get_contracts" dbtype="query" maxrows="1">
					SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10
					FROM
						get_contracts_all
					WHERE
						PRODUCT_ID = #get_product_main.PRODUCT_ID# AND
						COMPANY_ID = #attributes.company_id#
					ORDER BY
						C_P_PROD_DISCOUNT_ID DESC
				</cfquery>
				<cfif not get_contracts.recordcount>
					<cfquery name="get_contracts" dbtype="query" maxrows="1">
						SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10
						FROM
							get_contracts_all
						WHERE
							PRODUCT_ID = #get_product_main.PRODUCT_ID# AND
							COMPANY_ID IS NULL
						ORDER BY
							C_P_PROD_DISCOUNT_ID DESC
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="get_contracts" dbtype="query" maxrows="1">
					SELECT DISCOUNT1,DISCOUNT2,DISCOUNT3,DISCOUNT4,DISCOUNT5,DISCOUNT6,DISCOUNT7,DISCOUNT8,DISCOUNT9,DISCOUNT10
					FROM
						get_contracts_all
					WHERE
						PRODUCT_ID = #get_product_main.PRODUCT_ID#
					ORDER BY
						C_P_PROD_DISCOUNT_ID DESC
				</cfquery>
			</cfif>
			<cfscript>
				if(get_contracts.recordcount){
					if(len(get_contracts.discount1))sepet.satir[i].indirim1 = get_contracts.discount1;
					if(len(get_contracts.discount2))sepet.satir[i].indirim2 = get_contracts.discount2;
					if(len(get_contracts.discount3))sepet.satir[i].indirim3 = get_contracts.discount3;
					if(len(get_contracts.discount4))sepet.satir[i].indirim4 = get_contracts.discount4;
					if(len(get_contracts.discount5))sepet.satir[i].indirim5 = get_contracts.discount5;
					if(len(get_contracts.discount6))sepet.satir[i].indirim6 = get_contracts.discount6;
					if(len(get_contracts.discount7))sepet.satir[i].indirim7 = get_contracts.discount7;
					if(len(get_contracts.discount8))sepet.satir[i].indirim8 = get_contracts.discount8;
					if(len(get_contracts.discount9))sepet.satir[i].indirim9 = get_contracts.discount9;
					if(len(get_contracts.discount10))sepet.satir[i].indirim10 = get_contracts.discount10;
				}
			</cfscript>
		</cfif>
		<cfif isdefined('get_c_general_discounts') and get_c_general_discounts.recordcount><!--- genel indirimlerden gelen iskontolar --->
			<cfloop query="get_c_general_discounts">
				<cfset 'row_disc_#currentrow+5#' = get_c_general_discounts.DISCOUNT>
			</cfloop>
		</cfif>
		<cfscript>
			if(isdefined('row_disc_6') and len(row_disc_6)) sepet.satir[i].indirim6 = row_disc_6;
			if(isdefined('row_disc_7') and len(row_disc_7)) sepet.satir[i].indirim7 = row_disc_7;
			if(isdefined('row_disc_8') and len(row_disc_8)) sepet.satir[i].indirim8 = row_disc_8;
			if(isdefined('row_disc_9') and len(row_disc_9)) sepet.satir[i].indirim9 = row_disc_9;
			if(isdefined('row_disc_10') and len(row_disc_10)) sepet.satir[i].indirim10 = row_disc_10;
			sepet.satir[i].tax_percent = get_product_main.TAX_PURCHASE;
			sepet.satir[i].paymethod_id = 0;
			sepet.satir[i].stock_id = get_product_main.stock_id;
			sepet.satir[i].barcode = barkod_no;
			sepet.satir[i].stock_code = get_product_main.STOCK_CODE;
			sepet.satir[i].special_code = get_product_main.STOCK_CODE_2;
			sepet.satir[i].manufact_code = get_product_main.MANUFACT_CODE;
			sepet.satir[i].duedate = "";
			sepet.satir[i].row_total = miktar * sepet.satir[i].price ;
			sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
			sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
			sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
			sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
			sepet.satir[i].other_money = get_product_main.MONEY;
			sepet.satir[i].other_money_value =(sepet.satir[i].row_nettotal*temp_rate_);
			sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
			sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
			sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
			sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_
			sepet.satir[i].deliver_date = "";
			sepet.satir[i].deliver_dept = "" ;
			sepet.satir[i].spect_id = "";
			sepet.satir[i].spect_name = "";
			sepet.satir[i].lot_no = "";
			sepet.satir[i].price_other = FIYAT_OTHER;
			// kdv array
			kdv_flag = 0;
			for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
				{
				if (sepet.kdv_array[1] eq sepet.satir[i].tax_percent)
					{
					kdv_flag = 1;
					sepet.kdv_array[2] = sepet.kdv_array[2] + sepet.satir[i].row_taxtotal;
					sepet.kdv_array[3] = sepet.kdv_array[3] +  wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
					}
				}
			if (not kdv_flag)
				{
					sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
					sepet.kdv_array[arraylen(sepet.kdv_array)][2] = sepet.satir[i].row_taxtotal;
					sepet.kdv_array[arraylen(sepet.kdv_array)][3] = sepet.satir[i].row_nettotal;
				}
			sepet.satir[i].assortment_array = ArrayNew(1); //20041212 basket inputta gozukmuyor neden set ediliyor,incelensin?
			</cfscript>
	</cfif>
</cfif>

