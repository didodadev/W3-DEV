
<!--- 	
	FBS 20130124 Sayfadaki Degiskenlerin Tanimina Dikkat Edilmeli, Tablodaki Alan ve Js Degiskenleri Ayni Olmamali, Cakisma Oluyor Dolayisiyla Yanlıs Geliyor!!!!!
	Project_Id yi Buna Gore Duzenledim
 --->
<cfsetting showdebugoutput="yes">
<cfif not (isdefined("company_order_") and listlen(company_order_)) and not (isdefined("cons_order_") and listlen(cons_order_))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='60010.Sipariş Seçmelisiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset listem = "">
<cfset depo_list = "">
<!--- farklı şirket kontrol --->
<cfif isdefined("company_order_") and listlen(company_order_)>
	<cfloop from="1" to="#listlen(company_order_)#" index="i">
		<cfset deger_uzunluk_ = listlen(listfirst(company_order_),';')>
		<cfif deger_uzunluk_ eq 3>
			<cfif listgetat(listfirst(company_order_),2,';') neq listgetat(listgetat(company_order_,i),2,';')>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='60011.Yanlış Seçim'> !");
					history.back();
				</script>
				<cfabort>
			<cfelse>
				<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1)>
					<cfset depo_list = ListAppend(depo_list,listlast(listgetat(company_order_,i),';'))>
				</cfif>
				<cfset listem = listappend(listem,listfirst(listgetat(company_order_,i),';'))>
			</cfif>
		<cfelseif deger_uzunluk_ eq 4>
			<cfif listgetat(listfirst(company_order_),3,';') neq listgetat(listgetat(company_order_,i),3,';')>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='60011.Yanlış Seçim'> !");
					history.back();
				</script>
				<cfabort>
			<cfelse>
				<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1)>
					<cfset depo_list = ListAppend(depo_list,listlast(listgetat(company_order_,i),';'))>
				</cfif>
				<cfset listem = listappend(listem,listgetat(listgetat(company_order_,i),2,';'))>
			</cfif>
		</cfif>
	</cfloop>
<cfelseif isdefined("cons_order_") and listlen(cons_order_)>
	<cfloop from="1" to="#listlen(cons_order_)#" index="i">
		<cfset deger_uzunluk_ = listlen(listfirst(cons_order_),';')>
		<cfif deger_uzunluk_ eq 3>
			<cfif listgetat(listfirst(cons_order_),2,';') neq listgetat(listgetat(cons_order_,i),2,';')>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='60011.Yanlış Seçim'> !");
					history.back();
				</script>
				<cfabort>
			<cfelse>
				<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1)>
					<cfset depo_list = ListAppend(depo_list,listlast(listgetat(cons_order_,i),';'))>
				</cfif>
				<cfset listem = listappend(listem,listfirst(listgetat(cons_order_,i),';'))>
			</cfif>
		<cfelseif deger_uzunluk_ eq 4>
			<cfif listgetat(listfirst(cons_order_),3,';') neq listgetat(listgetat(cons_order_,i),3,';')>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='60011.Yanlış Seçim'> !");
					history.back();
				</script>
				<cfabort>
			<cfelse>
				<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1)>
					<cfset depo_list = ListAppend(depo_list,listlast(listgetat(cons_order_,i),';'))>
				</cfif>
				<cfset listem = listappend(listem,listgetat(listgetat(cons_order_,i),2,';'))>
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
	SELECT
		ORDERS.REF_NO,
		ORDERS.LOCATION_ID AS PAPER_LOCATION_ID,
		ORDERS.DELIVER_DEPT_ID AS PAPER_DEPARTMENT_ID,
		ORDERS.ORDER_ID,
		ORDERS.ORDER_NUMBER,	
		ORDERS.SALES_PARTNER_ID,
		ORDERS.DELIVERDATE,		
		ORDERS.PAYMETHOD,
		ORDERS.COMMETHOD_ID,
		ORDERS.OTHER_MONEY AS ORDER_MONEY,
		ORDERS.GENERAL_PROM_ID,
		ORDERS.GENERAL_PROM_LIMIT,
		ORDERS.GENERAL_PROM_AMOUNT,
		ORDERS.GENERAL_PROM_DISCOUNT,
		ORDERS.CARD_PAYMETHOD_ID,
		ORDERS.CARD_PAYMETHOD_RATE,
		ORDERS.ORDER_EMPLOYEE_ID,
		ISNULL(ORDER_ROW.ROW_PROJECT_ID,ORDERS.PROJECT_ID) PROJECT_ID_NEW,
		(SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = ISNULL(ORDER_ROW.ROW_PROJECT_ID,ORDERS.PROJECT_ID)) PROJECT_HEAD_NEW,
        (SELECT WORK_HEAD FROM #dsn_alias#.PRO_WORKS PW WHERE PW.WORK_ID = ORDER_ROW.ROW_WORK_ID) ROW_WORK_HEAD,
		ORDERS.DUE_DATE,
		ORDERS.ORDER_DATE,
		ORDERS.ORDER_DETAIL,
		ORDERS.DELIVER_COMP_ID,
		ORDERS.DELIVER_CONS_ID,
		ORDERS.SUBSCRIPTION_ID,
        ORDERS.SHIP_METHOD,
		ORDER_ROW.*,	
		EXC.EXPENSE,
		EXI.EXPENSE_ITEM_NAME,
		(SELECT E.EMPLOYEE_NAME +' '+E.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE E.EMPLOYEE_ID=ORDER_ROW.BASKET_EMPLOYEE_ID) AS BASKET_EMPLOYEE,
	<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1)>
		-1 AS PURCHASE,
		ODR.DEPARTMENT_ID AS DELIVER_DEPT_2,
		ODR.LOCATION_ID AS LOCATION_ID,
		ODR.ORDER_ROW_ID,
		(ODR.AMOUNT-ISNULL(ORDER_ROW.CANCEL_AMOUNT,0)) AS URUN_MIKTAR,
	<cfelse>
		1 AS IS_SALE,
		ORDERS.SHIP_ADDRESS,
		ORDER_ROW.DELIVER_DEPT AS DELIVER_DEPT_2,
		ORDER_ROW.DELIVER_LOCATION AS LOCATION_ID,
		(ORDER_ROW.QUANTITY-ISNULL(ORDER_ROW.CANCEL_AMOUNT,0)) AS URUN_MIKTAR,
	</cfif>
		STOCKS.STOCK_CODE,
		STOCKS.STOCK_CODE_2,
		STOCKS.BARCOD,
		STOCKS.MANUFACT_CODE,
		STOCKS.IS_SERIAL_NO,
		STOCKS.IS_INVENTORY,
		STOCKS.IS_PRODUCTION
	FROM 
		ORDERS,
		ORDER_ROW 
		LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORDER_ROW.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
        LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORDER_ROW.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID,
	<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1)>
		ORDER_ROW_DEPARTMENTS ODR,
	</cfif>
		STOCKS AS STOCKS
	WHERE 
		ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID AND
		<cfif isdefined('attributes.from_order_row') and attributes.from_order_row eq 1> <!--- siparis satırı bazında bazında --->
		ORDER_ROW.ORDER_ROW_ID IN (#LISTEM#) AND
		<cfelse>
		ORDER_ROW.ORDER_ID IN (#LISTEM#) AND
		</cfif>
		ORDER_ROW.STOCK_ID = STOCKS.STOCK_ID
	<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1) and len(depo_list)>
		AND ODR.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID 
        	<cfif (isdefined('attributes.list_type') and attributes.list_type eq 2) or isdefined("attributes.FROM_ORDER_ROW")>
				AND ODR.DEPARTMENT_ID IN(#depo_list#)
            <cfelse>
				AND ORDERS.DELIVER_DEPT_ID IN(#depo_list#)
            </cfif>
   	</cfif>
    
	<cfif not isdefined("attributes.is_return") or (isdefined("attributes.is_return") and attributes.is_return eq 0)>
		AND ORDER_ROW.ORDER_ROW_CURRENCY IN (-6,-7)
	</cfif>
	ORDER BY
		ORDERS.ORDER_ID,
		ORDER_ROW.ORDER_ROW_ID
</cfquery>

<cfset order_row_list = listem >
<cfset LISTEM = listdeleteduplicates(valuelist(GET_ORDER_ROW.ORDER_ID))> <!--- urun bazında listelenmisse LISTEM ORDER_ROW_ID degerlerini taşır, burda listeyi ORDER_ID bazında set ediyoruz yeniden--->
<cfif not isdefined('attributes.from_order_row') and (not isdefined("attributes.is_return") or (isdefined("attributes.is_return") and attributes.is_return eq 0))> <!--- siparis satırlarından ekleme yapılıyorsa, arayuzde miktar kontrolleri oldugundan burda tekrarlamıyoruz --->
	<cfif listlen(LISTEM)>
		<cfquery name="get_order_ship_periods" datasource="#dsn3#">
			SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID IN (#LISTEM#)
			UNION ALL
			SELECT DISTINCT PERIOD_ID FROM ORDERS_INVOICE WHERE ORDER_ID IN (#LISTEM#)
		</cfquery>
	</cfif>
	<cfif isdefined("get_order_ship_periods") and get_order_ship_periods.recordcount> <!--- siparisle ilgili irsaliye kaydı varsa --->
		<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
		<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
			<cfquery name="control_order_ships" datasource="#dsn3#">
				SELECT
					STOCK_ID,
					SUM(AMOUNT) AS AMOUNT,
					ORDERS_SHIP.ORDER_ID,
					SHIP_ROW.ROW_ORDER_ID,
					ISNULL(SHIP_ROW.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID 
				FROM
					#dsn2_alias#.SHIP SHIP,
					#dsn2_alias#.SHIP_ROW SHIP_ROW,
					ORDERS_SHIP
				WHERE
					SHIP.SHIP_ID = ORDERS_SHIP.SHIP_ID AND
					ORDERS_SHIP.ORDER_ID IN (#LISTEM#) AND
					SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
					SHIP_ROW.ROW_ORDER_ID IN (#LISTEM#) AND
					ORDERS_SHIP.PERIOD_ID = #session.ep.period_id#
				GROUP BY
					STOCK_ID,ORDERS_SHIP.ORDER_ID,SHIP_ROW.ROW_ORDER_ID,
					ISNULL(SHIP_ROW.WRK_ROW_RELATION_ID,0)
				UNION ALL
				SELECT
					SHIP_ROW.STOCK_ID,
					SUM(-1*SHIP_ROW2.AMOUNT) AS AMOUNT,
					ORDERS_SHIP.ORDER_ID,
					SHIP_ROW.ROW_ORDER_ID,
					ISNULL(SHIP_ROW.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID 
				FROM
					#dsn2_alias#.SHIP SHIP,
					#dsn2_alias#.SHIP SHIP2, <!--- İade İşlemlerinden sonra Depolararası Sevk İrsaliyeleri mevcut stokları yükseltiyordu. --->
					#dsn2_alias#.SHIP_ROW SHIP_ROW,
					#dsn2_alias#.SHIP_ROW SHIP_ROW2,
					ORDERS_SHIP
				WHERE
					SHIP.SHIP_ID = ORDERS_SHIP.SHIP_ID AND
					ORDERS_SHIP.ORDER_ID IN (#LISTEM#) AND
					SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
					SHIP_ROW.ROW_ORDER_ID IN (#LISTEM#) AND
					ORDERS_SHIP.PERIOD_ID = #session.ep.period_id# AND
					SHIP_ROW.WRK_ROW_ID=SHIP_ROW2.WRK_ROW_RELATION_ID AND
					<!--- İade İşlemlerinden sonra Depolararası Sevk İrsaliyeleri mevcut stokları yükseltiyordu. EY20141611 --->
					SHIP2.SHIP_ID = SHIP_ROW2.SHIP_ID AND
					SHIP2.SHIP_TYPE <> 81
					<!--- İade İşlemlerinden sonra Depolararası Sevk İrsaliyeleri mevcut stokları yükseltiyordu. EY20141611 --->
				GROUP BY
					SHIP_ROW.STOCK_ID,ORDERS_SHIP.ORDER_ID,SHIP_ROW.ROW_ORDER_ID,
					ISNULL(SHIP_ROW.WRK_ROW_RELATION_ID,0)
				UNION ALL
				SELECT
					STOCK_ID,
					SUM(AMOUNT) AS AMOUNT,
					ORDERS_INVOICE.ORDER_ID,
					INVOICE_ROW.ORDER_ID ROW_ORDER_ID,
					ISNULL(INVOICE_ROW.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID 
				FROM
					#dsn2_alias#.INVOICE INVOICE,
					#dsn2_alias#.INVOICE_ROW INVOICE_ROW,
					ORDERS_INVOICE
				WHERE
					INVOICE.INVOICE_ID = ORDERS_INVOICE.INVOICE_ID AND
					ORDERS_INVOICE.ORDER_ID IN (#LISTEM#) AND
					INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND
					INVOICE_ROW.ORDER_ID IN (#LISTEM#) AND
					ORDERS_INVOICE.PERIOD_ID = #session.ep.period_id#
				GROUP BY
					STOCK_ID,ORDERS_INVOICE.ORDER_ID,INVOICE_ROW.ORDER_ID,
					ISNULL(INVOICE_ROW.WRK_ROW_RELATION_ID,0)
			</cfquery>
		<cfelse>
			<cfquery name="get_period_dsns" datasource="#dsn#">
				SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
			</cfquery>
			<cfquery name="control_order_ships" datasource="#dsn3#">
				SELECT
					STOCK_ID,SUM(AMOUNT) AS AMOUNT,ORDER_ID,ROW_ORDER_ID,WRK_ROW_RELATION_ID
				FROM
				(
				<cfloop query="get_period_dsns">
					SELECT
						STOCK_ID,SUM(AMOUNT) AS AMOUNT,ORDERS_SHIP.ORDER_ID,SR.ROW_ORDER_ID,ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID 
					FROM
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR,
						ORDERS_SHIP
					WHERE
						S.SHIP_ID = ORDERS_SHIP.SHIP_ID AND
						ORDERS_SHIP.ORDER_ID IN (#LISTEM#) AND
						SR.SHIP_ID = S.SHIP_ID AND
						SR.ROW_ORDER_ID IN (#LISTEM#) AND
						ORDERS_SHIP.PERIOD_ID = #get_period_dsns.period_id#
					GROUP BY
						STOCK_ID,ORDERS_SHIP.ORDER_ID,SR.ROW_ORDER_ID,ISNULL(SR.WRK_ROW_RELATION_ID,0)
					UNION ALL
					SELECT
						STOCK_ID,
						SUM(AMOUNT) AS AMOUNT,
						ORDERS_INVOICE.ORDER_ID,
						INVOICE_ROW.ORDER_ID ROW_ORDER_ID,
						ISNULL(INVOICE_ROW.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID 
					FROM
						#dsn2_alias#.INVOICE INVOICE,
						#dsn2_alias#.INVOICE_ROW INVOICE_ROW,
						ORDERS_INVOICE
					WHERE
						INVOICE.INVOICE_ID = ORDERS_INVOICE.INVOICE_ID AND
						ORDERS_INVOICE.ORDER_ID IN (#LISTEM#) AND
						INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND
						INVOICE_ROW.ORDER_ID IN (#LISTEM#) AND
						ORDERS_INVOICE.PERIOD_ID=#get_period_dsns.period_id#
					GROUP BY
						STOCK_ID,ORDERS_INVOICE.ORDER_ID,INVOICE_ROW.ORDER_ID,
						ISNULL(INVOICE_ROW.WRK_ROW_RELATION_ID,0)
					<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
				</cfloop> ) AS A1
					GROUP BY
						STOCK_ID,ORDER_ID,ROW_ORDER_ID,WRK_ROW_RELATION_ID
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<cfset attributes.list_order_ids = listem>
<cfquery name="get_d" dbtype="query">
	SELECT DISTINCT ORDER_NUMBER FROM GET_ORDER_ROW
</cfquery>
<cfquery name="get_ref_no_d" dbtype="query">
	SELECT DISTINCT REF_NO FROM GET_ORDER_ROW WHERE REF_NO IS NOT NULL
</cfquery>
<cfset order_number_list = ListSort(valueList(get_d.ORDER_NUMBER), "Text")>
<cfset ref_no_list = ListSort(valueList(get_ref_no_d.REF_NO), "Text")>
<cfquery name="get_system" dbtype="query">
	SELECT DISTINCT SUBSCRIPTION_ID FROM GET_ORDER_ROW
</cfquery>
<cfset order_system_id_list_real = ListSort(valueList(get_system.SUBSCRIPTION_ID), "Text")>

<!--- sepet doldurulur --->
<cfif len(GET_ORDER_ROW.COMMETHOD_ID[GET_ORDER_ROW.recordcount])>
	<cfset invoice_commethod_id = GET_ORDER_ROW.COMMETHOD_ID[GET_ORDER_ROW.recordcount]>
<cfelse>
	<cfset invoice_commethod_id = ''>
</cfif>
<!--- en son siparisin vade tarihiyle siparis tarihi arasındaki fark irsaliyedeki basket_due_date alanına tasınır. --->
<cfif len(GET_ORDER_ROW.DUE_DATE[GET_ORDER_ROW.recordcount])>
	<cfset last_due_date = GET_ORDER_ROW.DUE_DATE[GET_ORDER_ROW.recordcount]>
</cfif>
<cfif len(GET_ORDER_ROW.ORDER_DATE[GET_ORDER_ROW.recordcount])>
	<cfset last_order_date = GET_ORDER_ROW.ORDER_DATE[GET_ORDER_ROW.recordcount]>
</cfif>
<cfif isdefined('last_due_date') and len(last_due_date) and isdefined('last_order_date') and len(last_order_date)>
	<cfset temp_basket_due_day= datediff('d',last_order_date,last_due_date)>
<cfelse>
	<cfset temp_basket_due_day=''>
</cfif>
<cfset order_detail_list = "">
<cfset paper_dept_id_info="">
<cfset paper_loc_id_info="">
<cfset paper_dept_name="">

<script type="text/javascript">
	try
	{ /*komisyon satırlarının hesaplamalarında belgedeki komisyon oranları, vs kontrol edildiginden bu bolum satırlardan onceye tasındı*/
		<cfif len(GET_ORDER_ROW.PAYMETHOD)>
			<cfquery name="GET_PAYMENT_METHOD" datasource="#dsn#">
				SELECT PAYMETHOD_ID,PAYMETHOD,DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #GET_ORDER_ROW.PAYMETHOD#
			</cfquery>			
			if(window.opener.form_basket.paymethod_id != undefined)
				window.opener.form_basket.paymethod_id.value = '<cfoutput>#GET_PAYMENT_METHOD.PAYMETHOD_ID#</cfoutput>';
			if(window.opener.form_basket.paymethod != undefined)
				window.opener.form_basket.paymethod.value = '<cfoutput>#GET_PAYMENT_METHOD.PAYMETHOD#</cfoutput>';
			/*if(window.opener.form_basket.basket_due_value != undefined)
				window.opener.form_basket.basket_due_value.value = '<cfoutput>#GET_PAYMENT_METHOD.DUE_DAY#</cfoutput>';*/
			if(window.opener.form_basket.card_paymethod_id != undefined)
				window.opener.form_basket.card_paymethod_id.value  ='';
			if(window.opener.form_basket.commission_rate != undefined)
				window.opener.form_basket.card_paymethod_id.value  ='';
			if(window.opener.form_basket.commethod_id != undefined)
					window.opener.form_basket.commethod_id.value = '<cfoutput>#invoice_commethod_id#</cfoutput>';
		<cfelseif len(GET_ORDER_ROW.CARD_PAYMETHOD_ID)>
			if(window.opener.form_basket.card_paymethod_id != undefined)
				window.opener.form_basket.card_paymethod_id.value  = '<cfoutput>#GET_ORDER_ROW.CARD_PAYMETHOD_ID#</cfoutput>';
			if(window.opener.form_basket.commission_rate != undefined)
				window.opener.form_basket.commission_rate.value = '<cfif len(GET_ORDER_ROW.CARD_PAYMETHOD_RATE)><cfoutput>#GET_ORDER_ROW.CARD_PAYMETHOD_RATE#</cfoutput></cfif>';
			if(window.opener.form_basket.paymethod_id != undefined)
				window.opener.form_basket.paymethod_id.value = '';
			if(window.opener.form_basket.paymethod != undefined)
				window.opener.form_basket.paymethod.value = '';
			/*if(window.opener.form_basket.basket_due_value != undefined)
				window.opener.form_basket.basket_due_value.value = '';*/
		</cfif>
		<cfif isdefined("attributes.order_system_id_list") and len(attributes.order_system_id_list)>
			window.opener.<cfoutput>#attributes.order_system_id_list#</cfoutput>.value = '<cfoutput>#order_system_id_list_real#</cfoutput>';
		</cfif>
	}
	catch(e)
	{
	}
	
	<cfif isdefined("attributes.control") and attributes.control eq 1>
		window.opener.form_basket.order_id_listesi.value='<cfoutput>#LISTEM#</cfoutput>';
		window.opener.form_basket.order_id_form.value='<cfoutput>#order_number_list#</cfoutput>';
		window.opener.form_basket.order_date.value='<cfoutput>#dateformat(last_order_date,'dd-mm-yyyy')#</cfoutput>';
		<cfif isdefined("attributes.from_order_row") and attributes.from_order_row eq 1>
		window.opener.form_basket.order_create_from_row.value = 1;	
		window.opener.form_basket.order_create_row_list.value = '<cfoutput>#order_row_list#</cfoutput>'; 
		</cfif>
		window.close();
	<cfelseif isdefined("attributes.control") and attributes.control eq 2>
		window.opener.form_basket_2.list_ord_id.value='<cfoutput>#LISTEM#</cfoutput>';
		window.opener.form_basket_2.id_order_form.value='<cfoutput>#order_number_list#</cfoutput>';
		window.close();
	</cfif>
	<cfif not isdefined("attributes.control")>
		<cfoutput query="GET_ORDER_ROW">
			<cfif Len(order_id) and order_id neq order_id[currentrow+1]>
				<cfset Replace_List = "',#Chr(10)#,#Chr(13)#"><!--- Satir kirma vb sorun oldugundan kaldirmak icin eklendi degistirmeyin FBS --->
				<cfset Replace_List_New = ",,">
				<cfset Order_Detail_ = ReplaceList(Order_Detail,Replace_List,Replace_List_New)>
				<cfset order_detail_list = Listappend(order_detail_list,Order_Detail_,',')>
			</cfif>
			<cfif isdefined('attributes.order_add_amount_#GET_ORDER_ROW.ORDER_ID#_#GET_ORDER_ROW.ORDER_ROW_ID#') and len(evaluate('attributes.order_add_amount_#GET_ORDER_ROW.ORDER_ID#_#GET_ORDER_ROW.ORDER_ROW_ID#'))>
				<cfset yeni_miktar = evaluate('attributes.order_add_amount_#GET_ORDER_ROW.ORDER_ID#_#GET_ORDER_ROW.ORDER_ROW_ID#')>
			<cfelseif  not isdefined('from_order_row') and (not isdefined("attributes.is_return") or (isdefined("attributes.is_return") and attributes.is_return eq 0)) and get_order_ship_periods.recordcount neq 0>
				<cfquery name="get_used_order_amount" dbtype="query">
					SELECT * FROM control_order_ships WHERE ORDER_ID=#GET_ORDER_ROW.order_id# AND STOCK_ID=#GET_ORDER_ROW.stock_id# AND ROW_ORDER_ID=#GET_ORDER_ROW.order_id#
				</cfquery>	
				<cfset yeni_miktar=GET_ORDER_ROW.URUN_MIKTAR>
				<cfset new_stck_id=GET_ORDER_ROW.STOCK_ID>
				<cfset new_order_id=GET_ORDER_ROW.ORDER_ID>
				<cfset new_wrk_row=GET_ORDER_ROW.WRK_ROW_ID>
				<cfloop query="get_used_order_amount">
					<cfif not (isdefined('_used_order_stock_amount_#new_order_id#_#new_stck_id#') and len(evaluate('_used_order_stock_amount_#new_order_id#_#new_stck_id#')) ) and get_used_order_amount.WRK_ROW_RELATION_ID eq 0>
						<cfset '_used_order_stock_amount_#new_order_id#_#new_stck_id#'=get_used_order_amount.AMOUNT>
					<cfelse>
						<cfset '_used_order_stock_amount_#new_order_id#_#new_stck_id#'=0>
					</cfif>
					<cfif len(WRK_ROW_RELATION_ID) and WRK_ROW_RELATION_ID neq 0 and WRK_ROW_RELATION_ID is new_wrk_row>
						<cfset yeni_miktar=yeni_miktar-get_used_order_amount.AMOUNT>
					</cfif>
					<cfif yeni_miktar gt 0 and evaluate('_used_order_stock_amount_#new_order_id#_#new_stck_id#') gt 0>
						<cfif yeni_miktar gt evaluate('_used_order_stock_amount_#new_order_id#_#new_stck_id#')>
							<cfset yeni_miktar=yeni_miktar-evaluate('_used_order_stock_amount_#new_order_id#_#new_stck_id#')>
							<cfset '_used_order_stock_amount_#new_order_id#_#new_stck_id#'=0>
						<cfelse>
							<cfset yeni_miktar=0>
							<cfset '_used_order_stock_amount_#new_order_id#_#new_stck_id#'=evaluate('_used_order_stock_amount_#new_order_id#_#new_stck_id#')+yeni_miktar>//-kalan_miktar
						</cfif>
					</cfif>
				</cfloop>
			<cfelse>
				<cfset yeni_miktar = GET_ORDER_ROW.URUN_MIKTAR>
			</cfif>
		
			<cfif yeni_miktar gt 0>
				<cfset attributes.location_id = LOCATION_ID>
				<cfset attributes.department_id = DELIVER_DEPT_2>
				<cfset DELIVER_DEPT = GET_ORDER_ROW.DELIVER_DEPT_2>
				<cfif len(attributes.location_id)>
					<cfinclude template="../query/get_location_for_orders.cfm">//objects e tasındı
					<cfset attributes.branch_id = get_location.branch_id>
				<cfelseif len(DELIVER_DEPT)>
					<cfinclude template="../query/get_dep_name.cfm">
					<cfset attributes.branch_id = get_dep.branch_id>
				<cfelse>
					<cfset attributes.branch_id ="">
				</cfif>
				<cfscript>
					if(len(DISCOUNT_1)) d1 = DISCOUNT_1; else d1=0;
					if(len(DISCOUNT_2)) d2 = DISCOUNT_2; else d2=0;
					if(len(DISCOUNT_3)) d3 = DISCOUNT_3; else d3=0;
					if(len(DISCOUNT_4)) d4 = DISCOUNT_4; else d4=0;
					if(len(DISCOUNT_5)) d5 = DISCOUNT_5; else d5=0;
					if(len(DISCOUNT_6)) d6 = DISCOUNT_6; else d6=0;
					if(len(DISCOUNT_7)) d7 = DISCOUNT_7; else d7=0;
					if(len(DISCOUNT_8)) d8 = DISCOUNT_8; else d8=0;
					if(len(DISCOUNT_9)) d9 = DISCOUNT_9; else d9=0;
					if(len(DISCOUNT_10)) d10 = DISCOUNT_10; else d10=0;
					if(len(DELIVERDATE)) d_date = dateformat(DELIVERDATE,dateformat_style); else d_date="";
					if(len(LOCATION_ID)) 
					{
						d_dept_id = attributes.department_id & "-" & attributes.location_id;
						d_dept_name = GET_LOCATION.department_head& "-" &GET_LOCATION.comment ;
					}
					else if (len(attributes.department_id))
					{
						d_dept_id = attributes.department_id;
						d_dept_name = get_dep.department_head;
					}
					else
					{
						d_dept_id = "";
						d_dept_name = "";
					}
					if(len(spect_var_id))
					{
						if(len(d_date)) _date=d_date; else _date=now();
						maliyet=get_cost_info(stock_id:stock_id,spec_id:spect_var_id,cost_date:_date);
					}
					else
					{
						if(len(d_date)) _date=d_date; else _date=now();
						maliyet=get_cost_info(stock_id:stock_id,cost_date:_date);
					}
					if(isdefined("attributes.x_cost_price_info") and attributes.x_cost_price_info eq 1)
					{
						if(len(cost_price)) temp_net_cost = cost_price; else temp_net_cost = 0;
						if(len(extra_cost)) temp_extra_cost = extra_cost; else temp_extra_cost = 0;
					}
					else
					{
						if(listlen(maliyet,','))
						{
							if(len(listgetat(maliyet,2,','))) temp_net_cost=listgetat(maliyet,2,','); else temp_net_cost=0;
							if(not isdefined("attributes.is_purchase") or attributes.is_purchase neq 1)//alissa ekmaliyeti atmasın
								if(len(listgetat(maliyet,3,','))) temp_extra_cost=listgetat(maliyet,3,','); else temp_extra_cost=0;
							else
								temp_extra_cost = 0;
						}
						else
						{
							temp_extra_cost = 0;
							temp_net_cost =0;
						}
					}
					if (len(PROM_COST)) temp_prom_cost =PROM_COST; else temp_prom_cost =0;	
					if(len(UNIQUE_RELATION_ID)) temp_unique_relation_id= UNIQUE_RELATION_ID; else temp_unique_relation_id = "";
					if(len(PROM_RELATION_ID)) temp_prom_relation_id= PROM_RELATION_ID; else temp_prom_relation_id = "";
					if(len(PRODUCT_NAME2))
					{
						temp_product_name2 = replace(PRODUCT_NAME2,"'","","all");
						temp_product_name2 = replace(temp_product_name2,'"','','all');
						temp_product_name2 = replace(temp_product_name2,';','','all');
						temp_product_name2 = replace(temp_product_name2,'#chr(13)&chr(10)#','','all');
					}
					else
						temp_product_name2 = "";
						
					if(len(PRODUCT_NAME))
					{
						temp_product_name_ = replace(PRODUCT_NAME,"'","","all");
						temp_product_name_ = replace(temp_product_name_,'"','','all');
						temp_product_name_ = replace(temp_product_name_,';','','all');
						temp_product_name_ = replace(temp_product_name_,'#chr(13)&chr(10)#','','all');
					}
					else
						temp_product_name_ = "";
						
					if(len(spect_var_name))
					{
						temp_spect_var_name = replace(spect_var_name,"'","","all");
						temp_spect_var_name = replace(temp_spect_var_name,'"','','all');
						temp_spect_var_name = replace(temp_spect_var_name,';','','all');
						temp_spect_var_name = replace(temp_spect_var_name,'#chr(13)&chr(10)#','','all');	
					}
					else
						temp_spect_var_name = "";
					
					if(len(AMOUNT2)) temp_amount2 = yeni_miktar*(AMOUNT2/QUANTITY); else temp_amount2 = "";
					if(len(UNIT2))temp_unit2 = UNIT2; else temp_unit2 = "";
					if(len(EXTRA_PRICE))temp_ek_tutar = EXTRA_PRICE; else temp_ek_tutar = 0;
					if(len(SHELF_NUMBER)) temp_shelf_number = SHELF_NUMBER; else temp_shelf_number = "";
					if(len(OTV_ORAN)) temp_otv_oran =OTV_ORAN; else temp_otv_oran = 0;
					if(len(DUEDATE)) temp_due_date = DUEDATE; else temp_due_date=0;
					if(len(KARMA_PRODUCT_ID)) temp_karma_product_id = KARMA_PRODUCT_ID; else temp_karma_product_id ='';
					if(len(CATALOG_ID)) row_catalog_id = CATALOG_ID; else row_catalog_id='';
					if(len(WRK_ROW_ID)) row_wrk_relation_id=WRK_ROW_ID; else row_wrk_relation_id='';
					
					if(len(WIDTH_VALUE)) row_width_value = WIDTH_VALUE; else row_width_value = '';
					if(len(DEPTH_VALUE)) row_depth_value = DEPTH_VALUE; else row_depth_value = '';
					if(len(HEIGHT_VALUE)) row_height_value = HEIGHT_VALUE; else row_height_value = '';
					if(len(SHIP_METHOD)) ship_method_id = SHIP_METHOD; else ship_method_id = '';

					/*Masraf Merkezi*/
					if( len(EXPENSE_CENTER_ID) )
					{
						row_exp_center_id = EXPENSE_CENTER_ID;
						row_exp_center_name = EXPENSE;
					}
					else{
						row_exp_center_id = '';
						row_exp_center_name = '';
					}

					//Aktivite Tipi
					row_activity_id = ACTIVITY_TYPE_ID;

					//Bütçe Kalemi
					if( len(EXPENSE_ITEM_ID) )
					{
						row_exp_item_id = EXPENSE_ITEM_ID;
						row_exp_item_name = EXPENSE_ITEM_NAME;
					}
					else{
						row_exp_item_id = '';
						row_exp_item_name = '';
					}

					row_oiv_rate = ( len( OIV_RATE ) ) ? OIV_RATE : '';
					row_oiv_amount = ( len( OIV_AMOUNT ) ) ? OIV_AMOUNT : '';
					row_bsmv_rate = ( len( BSMV_RATE ) ) ? BSMV_RATE : '';
					row_bsmv_amount = ( len( BSMV_AMOUNT ) ) ? BSMV_AMOUNT : '';
					row_bsmv_currency = ( len( BSMV_CURRENCY ) ) ? BSMV_CURRENCY : '';
					row_tevkifat_rate = ( len( TEVKIFAT_RATE ) ) ? TEVKIFAT_RATE : '';
					row_tevkifat_amount = ( len( TEVKIFAT_AMOUNT ) ) ? TEVKIFAT_AMOUNT : '';	
					row_reason_code = ( len( REASON_CODE ) ) ? REASON_CODE & '--' & REASON_NAME : '';
					gtip_number = ( len( gtip_number ) ) ? gtip_number : '';

					//belgedeki depo-lokasyon bilgisi en son eklenen siparise gore set edilecek
					if(	len(PAPER_DEPARTMENT_ID) and len(PAPER_LOCATION_ID) )
					{
						paper_dept_id_info=PAPER_DEPARTMENT_ID;
						paper_loc_id_info=PAPER_LOCATION_ID;
					}
					if(len(PAYMETHOD_ID)) row_paymethod_id = PAYMETHOD_ID; else row_paymethod_id = '';

					if (isDefined("attributes.xml_order_row_deliverdate_copy_to_ship") and attributes.xml_order_row_deliverdate_copy_to_ship neq 1)
						d_date = "";
					if(len(DETAIL_INFO_EXTRA))
					DETAIL_INFO_EXTRA_ = replace(DETAIL_INFO_EXTRA,"'","","all");
					else
					DETAIL_INFO_EXTRA_ = DETAIL_INFO_EXTRA;
			</cfscript>
			toplam_hesap=0;
			<cfif currentrow eq GET_ORDER_ROW.recordcount>
				toplam_hesap=1;
			</cfif>
			window.opener.add_basket_row('#product_id#', '#stock_id#', '#stock_code#', '#barcod#', '#product_manufact_code#', '#temp_product_name_#', '#unit_id#', '#unit#', '#spect_var_id#', '#temp_spect_var_name#', '#price#', '#price_other#', '#tax#', '#temp_due_date#', '#d1#', '#d2#', '#d3#', '#d4#', '#d5#', '#d6#', '#d7#', '#d8#', '#d9#', '#d10#', '#d_date#', '#d_dept_id#', '#d_dept_name#', '#LOT_NO#', '#OTHER_MONEY#', '#GET_ORDER_ROW.ORDER_ID#', '#yeni_miktar#', '', '#IS_INVENTORY#','#IS_PRODUCTION#','#temp_net_cost#','#TLFormat(MARJ)#','#wrk_round(temp_extra_cost,4)#','#PROM_ID#','#PROM_COMISSION#','#temp_prom_cost#','#DISCOUNT_COST#','#IS_PROMOTION#','#prom_stock_id#','#temp_otv_oran#','#temp_product_name2#','#temp_amount2#','#temp_unit2#','#temp_ek_tutar#','#temp_shelf_number#','#temp_unique_relation_id#','#row_catalog_id#',toplam_hesap,'#IS_COMMISSION#','#BASKET_EXTRA_INFO_ID#','#temp_prom_relation_id#','','','#NUMBER_OF_INSTALLMENT#','#PRICE_CAT#','#temp_karma_product_id#','','','#row_wrk_relation_id#','','','#row_width_value#','#row_depth_value#','#row_height_value#','','#PROJECT_ID_NEW#','#PROJECT_HEAD_NEW#',0,'','#row_paymethod_id#','#replace(stock_code_2,"'","","all")#','#basket_employee_id#','#basket_employee#','#row_work_id#','#row_work_head#','#row_exp_center_id#','#row_exp_center_name#','#row_exp_item_id#','#row_exp_item_name#','','#SELECT_INFO_EXTRA#','#DETAIL_INFO_EXTRA_#','#gtip_number#','#row_activity_id#','','','','','#row_bsmv_rate#','#row_bsmv_amount#','#row_bsmv_currency#','#row_oiv_rate#','#row_oiv_amount#','#row_tevkifat_rate#','#row_tevkifat_amount#','#row_reason_code#');
			
			<cfif len(GET_ORDER_ROW.SALES_PARTNER_ID) and isnumeric(GET_ORDER_ROW.SALES_PARTNER_ID)>
				window.opener.form_basket.deliver_get_id.value = '#SALES_PARTNER_ID#';
				window.opener.form_basket.deliver_get.value = '#get_emp_info(SALES_PARTNER_ID,0,0)#';	
			</cfif>
		</cfif>
		<cfif len(GET_ORDER_ROW.ORDER_EMPLOYEE_ID) and isnumeric(GET_ORDER_ROW.ORDER_EMPLOYEE_ID)>
			if(window.opener.form_basket.sale_emp != undefined)
				window.opener.form_basket.sale_emp.value = '#ORDER_EMPLOYEE_ID#';
			if(window.opener.form_basket.sale_emp_name != undefined)
				window.opener.form_basket.sale_emp_name.value = '#get_emp_info(ORDER_EMPLOYEE_ID,0,0)#';	
		</cfif>
			if(window.opener.form_basket.deliver_comp_id != undefined)
				window.opener.form_basket.deliver_comp_id.value = '#DELIVER_COMP_ID#';
			if(window.opener.form_basket.deliver_cons_id != undefined)
				window.opener.form_basket.deliver_cons_id.value = '#DELIVER_CONS_ID#';
		</cfoutput>
		window.opener.kur_degistir(); //irsaliyedeki kur siparistekinden farklıysa sorun olmaması icin satırlar eklendikten sonra kur_degistir calıstırılıyor
	</cfif>
	try
	{
	
		if(window.opener.form_basket.ref_no.value.length == 0)
			window.opener.form_basket.ref_no.value = "<cfoutput>#ref_no_list#</cfoutput>";
		else if('<cfoutput>#ref_no_list#</cfoutput>' != '')
			window.opener.form_basket.ref_no.value +=",<cfoutput>#ref_no_list#</cfoutput>";
		<cfif (not isdefined("attributes.is_from_invoice"))>
			if(window.opener.form_basket.order_id_listesi.value != undefined)
			{
				if(window.opener.form_basket.order_id_listesi.value == '')
				{
					window.opener.$("#order_id_listesi").val('<cfoutput>#attributes.list_order_ids#</cfoutput>');
				}
				else
				{
					window.opener.$("#order_id_listesi").val(window.opener.$("#order_id_listesi").val()+',<cfoutput>#attributes.list_order_ids#</cfoutput>');
				}
			}
			if(window.opener.form_basket.order_id != undefined){
				if(window.opener.form_basket.order_id.value.length == 0)
					window.opener.$("#order_id").val('<cfoutput>#order_number_list#</cfoutput>');
				else
					window.opener.$("#order_id").val(window.opener.$("#order_id").val()+',<cfoutput>#order_number_list#</cfoutput>');
			}
				
		<cfelse>
			if(window.opener.form_basket.order_id_listesi.value != undefined)
			{
				if(window.opener.form_basket.order_id_listesi.value == '')
					window.opener.$("#order_id_listesi").val('<cfoutput>#attributes.list_order_ids#</cfoutput>');
				else
					window.opener.$("#order_id_listesi").val(window.opener.$("#order_id_listesi").val()+',<cfoutput>#attributes.list_order_ids#</cfoutput>');
			}
			if(window.opener.form_basket.order_id_form.value.length == 0)
				window.opener.$("#order_id_form").val('<cfoutput>#order_number_list#</cfoutput>');
			else
				window.opener.$("#order_id_form").val(window.opener.$("#order_id_form").val()+',<cfoutput>#order_number_list#</cfoutput>');
		</cfif>
		
		if(window.opener.form_basket.siparis_date_listesi != undefined && window.opener.form_basket.siparis_date_listesi.value != undefined)
		{
			if(window.opener.form_basket.siparis_date_listesi.value == '')
				window.opener.form_basket.siparis_date_listesi.value = '<cfoutput>#dateformat(GET_ORDER_ROW.order_date,dateformat_style)#</cfoutput>';
			else
				window.opener.form_basket.siparis_date_listesi.value += ',<cfoutput>#dateformat(GET_ORDER_ROW.order_date,dateformat_style)#</cfoutput>';
		}
		<cfif len(paper_dept_id_info) and len(paper_loc_id_info)>/*belge depo-lokasyın bilgileri varsa*/
			<cfoutput>
				window.opener.form_basket.department_id.value = '#paper_dept_id_info#';
				window.opener.form_basket.location_id.value = '#paper_loc_id_info#';
				<cfquery name="GET_PAPER_DEPT" datasource="#dsn#">
					SELECT D.DEPARTMENT_HEAD,SL.COMMENT,D.BRANCH_ID FROM STOCKS_LOCATION AS SL,	DEPARTMENT AS D WHERE SL.DEPARTMENT_ID=D.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#paper_dept_id_info# AND SL.LOCATION_ID=#paper_loc_id_info#		
				</cfquery>
				paper_dept_name='#GET_PAPER_DEPT.DEPARTMENT_HEAD#-#GET_PAPER_DEPT.COMMENT#';
				window.opener.form_basket.branch_id.value = '#GET_PAPER_DEPT.BRANCH_ID#';
				if (window.opener.form_basket.department_name != undefined)
					window.opener.form_basket.department_name.value = paper_dept_name;
				else
					window.opener.form_basket.txt_departman_.value = paper_dept_name;
			</cfoutput>
		</cfif> 
		
		//sevk yöntemi
		<cfif isdefined("ship_method_id")  and len(ship_method_id)>
			<cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
				SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #ship_method_id#
			</cfquery>
			if(window.opener.form_basket.ship_method != undefined)
				window.opener.form_basket.ship_method.value = '<cfoutput>#ship_method_id#</cfoutput>';
			<cfif GET_SHIP_METHOD.recordcount>
			if(window.opener.form_basket.ship_method_name != undefined)
				window.opener.form_basket.ship_method_name.value = '<cfoutput>#GET_SHIP_METHOD.SHIP_METHOD#</cfoutput>';
			</cfif>
		</cfif>
		
		<cfif len(temp_basket_due_day)>
			if(window.opener.form_basket.basket_due_value != undefined)
				window.opener.form_basket.basket_due_value.value = '<cfoutput>#temp_basket_due_day#</cfoutput>';
		</cfif>
		<cfif isdefined("attributes.x_send_order_detail") and attributes.x_send_order_detail eq 1>
			if(window.opener.form_basket.detail != undefined)
				window.opener.form_basket.detail.value = '<cfoutput>#order_detail_list#</cfoutput>';
		</cfif>
		<cfif len(GET_ORDER_ROW.PROJECT_ID_NEW)>		
			if(window.opener.form_basket.project_id != undefined)
				window.opener.form_basket.project_id.value = '<cfoutput>#GET_ORDER_ROW.PROJECT_ID_NEW#</cfoutput>';
			if(window.opener.form_basket.project_head != undefined)
				window.opener.form_basket.project_head.value = '<cfoutput>#Replace(GET_ORDER_ROW.PROJECT_HEAD_NEW,"'","","all")#</cfoutput>';
	    </cfif>
		<cfif len(GET_ORDER_ROW.SUBSCRIPTION_ID)>
			<cfquery name="GET_SUBSCRIPTION" datasource="#dsn3#">
				SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #GET_ORDER_ROW.SUBSCRIPTION_ID#
			</cfquery>
			if(window.opener.form_basket.subscription_id != undefined)
				window.opener.form_basket.subscription_id.value = '<cfoutput>#GET_SUBSCRIPTION.SUBSCRIPTION_ID#</cfoutput>';
			if(window.opener.form_basket.subscription_no != undefined)
				window.opener.form_basket.subscription_no.value = '<cfoutput>#Replace(GET_SUBSCRIPTION.SUBSCRIPTION_NO,"'","","all")#</cfoutput>';
	    </cfif>
		<cfif not (isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1))>
			window.opener.form_basket.adres.value = '<cfoutput>#GET_ORDER_ROW.SHIP_ADDRESS#</cfoutput>';
		</cfif>
	}
	catch(e)
	{
		//alert(e);
	}
	window.location.href = '<cfoutput>#request.self#?fuseaction=objects.popup_list_orders_for_ship<cfif isdefined('attributes.is_from_invoice') and len(attributes.is_from_invoice)>&is_from_invoice=#attributes.is_from_invoice#</cfif><cfif isdefined('attributes.is_return') and len(attributes.is_return)>&is_return=#attributes.is_return#</cfif>&is_form_submitted=1&keyword=<cfif isdefined('attributes.keyword') and len(attributes.keyword)>#attributes.keyword#</cfif><cfif len(attributes.company_id)>&company_id=#attributes.company_id#<cfelseif len(attributes.consumer_id)>&consumer_id=#attributes.consumer_id#</cfif><cfif len(attributes.dept_id)>&dept_id=#attributes.dept_id#</cfif>&is_purchase=<cfif isdefined("attributes.is_purchase") and (attributes.is_purchase eq 1)>1<cfelse>0</cfif><cfif isdefined("attributes.list_type")>&list_type=#attributes.list_type#</cfif><cfif isdefined("attributes.order_system_id_list") and len(attributes.order_system_id_list)>&order_system_id_list=#attributes.order_system_id_list#</cfif><cfif len(attributes.product_id)>&product_id=#attributes.product_id#</cfif><cfif len(attributes.product_name)>&product_name=#attributes.product_name#</cfif><cfif len(attributes.spect_main_id)>&spect_main_id=#attributes.spect_main_id#</cfif><cfif len(attributes.spect_name)>&spect_name=#attributes.spect_name#</cfif></cfoutput>&order_id_liste=<cfoutput>#attributes.list_order_ids#</cfoutput>';
</script>
