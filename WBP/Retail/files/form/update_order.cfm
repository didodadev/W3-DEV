<cfparam name="attributes.is_view" default="0">
<cfif attributes.is_view eq 1>
	<cfquery name="get_orders" datasource="#dsn3#">
        SELECT 
            ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ID = O.ORDER_ID),0) AS URUN_SAYISI,
            ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ROW_CURRENCY = -1 AND ORR2.ORDER_ID = O.ORDER_ID),0) AS ACIK_URUN_SAYISI,
            ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ROW_CURRENCY = -6 AND ORR2.ORDER_ID = O.ORDER_ID),0) AS SEVK_URUN_SAYISI,
            O.ORDER_ID 
        FROM 
            ORDERS O
        WHERE 
            <cfif isdefined("attributes.order_code") and len(attributes.order_code)>
                O.ORDER_CODE = '#attributes.order_code#'
            <cfelseif isdefined("attributes.order_company_code") and len(attributes.order_company_code)>
                O.ORDER_ID IN (#attributes.order_company_order_list#)
            <cfelse>
                O.ORDER_ID = #attributes.order_id#
            </cfif>
    </cfquery>
	<cfset attributes.order_id_list = valuelist(get_orders.order_id)>
    <cfset order_id_list = attributes.order_id_list>
	<cfinclude template="add_order2.cfm">    
<cfelse>
	<cfset new_basket = DeserializeJSON(URLDecode(attributes.print_note, "utf-8"))>
	<cfset department_count = listlen(attributes.department_id_list)>
	<cfset attributes.department_list = attributes.department_id_list>
	<!--- order_code --->
	
	<cfset satir_sayisi = arraylen(new_basket)>
	
	<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
	<cfset birim_ = 7>
	
	<cfset myQuery = QueryNew("ROW_ID,DEPARTMENT_ID,ORDER_DATE,COMPANY_ID,STOCK_ID,PRODUCT_ID,AMOUNT,VALID,NETTOTAL,PRICE,DISCOUNT_COST,DISCOUNT_1,DISCOUNT_2,DISCOUNT_3,DISCOUNT_4,DISCOUNT_5,DISCOUNT_6,DISCOUNT_7,DISCOUNT_8,DISCOUNT_9,DISCOUNT_10,PROJECT_ID,STATUS", "Integer,Integer,Date,Integer,Integer,Integer,Decimal,Integer,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Integer,Integer")>
	<cfset query_count = 0>
	
	<cfloop from="1" to="#satir_sayisi#" index="ccc">
		<cfset satir_numarasi = ccc>
		<cfset row_type_ = new_basket[satir_numarasi].row_type>
		<cfset product_code_ = new_basket[satir_numarasi].product_code>
		<cfset stock_count_ = new_basket[satir_numarasi].stock_count>
		<cfset comp_code_ = new_basket[satir_numarasi].company_code>
		<cfset siparis_onay_ = new_basket[satir_numarasi].siparis_onay>
		<cfset siparis_sevk_ = new_basket[satir_numarasi].siparis_sevk>
		<cfset siparis_onay_2_ = new_basket[satir_numarasi].siparis_onay_2>
		<cfset siparis_sevk_2_ = new_basket[satir_numarasi].siparis_sevk_2>
		<cfset vade_ = new_basket[satir_numarasi].dueday>
		<cfif not len(vade_)>
			<cfset vade_ = 30>
		</cfif>
		
		<cfif row_type_ eq 1>
			<cfif len(comp_code_)>
				<cfset company_id = listfirst(comp_code_,'_')>
				<cfset project_id = listlast(comp_code_,'_')>
			<cfelse>
				<cfset company_id = ''>
				 <cfset project_id = ''>
			</cfif>
			<cfset date1 = new_basket[satir_numarasi].siparis_tarih_1>
			<cfset date2 = new_basket[satir_numarasi].siparis_tarih_2>
			
			<cfif len(date1) and date1 is not 'null' and len(date1) gt 10>
				<cfset date1 = createodbcdatetime(createdate(listgetat(date1,1,'-'),listgetat(date1,2,'-'),left(listgetat(date1,3,'-'),2)))>
				<cfif not new_basket[satir_numarasi].siparis_tarih_1 contains 'T00:00'>
					<cfset date1 = dateadd('d',1,date1)>
				</cfif>
				<cfset date1 = dateformat(date1,'dd/mm/yyyy')>
			<cfelseif len(date1) and date1 is not 'null'>
				<cfset date1 = date1>
			</cfif>
			
			<cfif len(date2) and date2 is not 'null' and len(date2) gt 10>
				<cfset date2 = createodbcdatetime(createdate(listgetat(date2,1,'-'),listgetat(date2,2,'-'),left(listgetat(date2,3,'-'),2)))>
				<cfif not new_basket[satir_numarasi].siparis_tarih_2 contains 'T00:00'>
					<cfset date2 = dateadd('d',1,date2)>
				</cfif>
				<cfset date2 = dateformat(date2,'dd/mm/yyyy')>
			<cfelseif len(date2) and date2 is not 'null'>
				<cfset date2 = date2>
			</cfif>
			
			<cfif len(date1) and date1 is not 'null'>
				<cf_date tarih = 'date1'>
			</cfif>
			
			<cfif len(date2) and date1 is not 'null'>
				<cf_date tarih = 'date2'>
			</cfif>
			
			
			<cfset stock_id_ = new_basket[satir_numarasi].stock_id>
			<cfset product_id_ = new_basket[satir_numarasi].product_id>
		<cfelseif row_type_ eq 3>
			<cfset stock_id_ = listgetat(product_code_,2,'_')>
			<cfset product_id_ = listgetat(product_code_,1,'_')>
		</cfif>
		
		<cfif row_type_ eq 1>
			<cfif stock_count_ eq 1 and department_count eq 1>
				<cfset amount1 = new_basket[satir_numarasi].siparis_miktar>
				<cfset amount2 = new_basket[satir_numarasi].siparis_miktar_2>
				<cfset department_id_ = attributes.department_list>
			</cfif>
		<cfelseif row_type_ eq 3>
			<cfset amount1 = new_basket[satir_numarasi].siparis_miktar>
			<cfset amount2 = new_basket[satir_numarasi].siparis_miktar_2>
			<cfset department_id_ = listgetat(product_code_,3,'_')>
		</cfif>
					
					
		<cfif (row_type_ eq 1 and stock_count_ eq 1 and department_count eq 1) or row_type_ eq 3>
			<cfset query_count = query_count + 1>
			<cfset newRow = QueryAddRow(MyQuery,1)>
			<cfset temp = QuerySetCell(myQuery,"ROW_ID","#query_count#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DEPARTMENT_ID","#department_id_#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"ORDER_DATE","#date1#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"COMPANY_ID","#company_id#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"STOCK_ID","#stock_id_#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"PRODUCT_ID","#product_id_#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"VALID","#vade_#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_COST","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_1","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_2","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_3","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_4","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_5","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_6","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_7","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_8","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_9","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_10","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"PRICE","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"NETTOTAL","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"PROJECT_ID","#project_id#",query_count)>
			<cfif (siparis_sevk_ is true or siparis_sevk_ is 'yes')>
				<cfset temp = QuerySetCell(myQuery,"STATUS","-6",query_count)>
			<cfelse>
				<cfset temp = QuerySetCell(myQuery,"STATUS","-1",query_count)>
			</cfif>
			
			<cfif (siparis_onay_ is true or siparis_onay_ is 'yes') and len(amount1) and amount1 is not 'null' and len(date1) and isdate(date1) and len(company_id) and amount1 gt 0>
				<cfset temp = QuerySetCell(myQuery,"AMOUNT","#amount1#",query_count)>
			<cfelse>
				<cfset temp = QuerySetCell(myQuery,"AMOUNT","0",query_count)>
			</cfif>
			
			<cfset query_count = query_count + 1>
			<cfset newRow = QueryAddRow(MyQuery,1)>
			<cfset temp = QuerySetCell(myQuery,"ROW_ID","#query_count#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DEPARTMENT_ID","#department_id_#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"ORDER_DATE","#date2#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"COMPANY_ID","#company_id#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"STOCK_ID","#stock_id_#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"PRODUCT_ID","#product_id_#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"AMOUNT","#amount2#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"VALID","#vade_#",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_COST","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_1","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_2","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_3","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_4","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_5","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_6","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_7","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_8","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_9","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"DISCOUNT_10","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"PRICE","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"NETTOTAL","0",query_count)>
			<cfset temp = QuerySetCell(myQuery,"PROJECT_ID","#project_id#",query_count)>
			<cfif (siparis_sevk_2_ is true or siparis_sevk_2_ is 'yes')>
				<cfset temp = QuerySetCell(myQuery,"STATUS","-6",query_count)>
			<cfelse>
				<cfset temp = QuerySetCell(myQuery,"STATUS","-1",query_count)>
			</cfif>
			
			<cfif (siparis_onay_2_ is true or siparis_onay_2_ is 'yes') and len(amount2) and amount2 is not 'null' and len(date2) and isdate(date2) and len(company_id) and amount2 gt 0>
				<cfset temp = QuerySetCell(myQuery,"AMOUNT","#amount2#",query_count)>
			<cfelse>
				<cfset temp = QuerySetCell(myQuery,"AMOUNT","0",query_count)>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfquery name="myQuery" dbtype="query">
		SELECT * FROM myQuery WHERE AMOUNT > 0
	</cfquery>
	
	
	<cfif myQuery.recordcount>
		<cfif isdefined("attributes.order_code") and len(attributes.order_code)>
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_ROW
					WHERE
						ORDER_ID IN (SELECT O.ORDER_ID FROM ORDERS O WHERE O.ORDER_CODE = '#attributes.order_code#')
			</cfquery>
			
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_MONEY
					WHERE
						ACTION_ID IN (SELECT O.ORDER_ID FROM ORDERS O WHERE O.ORDER_CODE = '#attributes.order_code#')
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_ROW
					WHERE
						ORDER_ID = #attributes.order_id#
			</cfquery>
			
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_MONEY
					WHERE
						ACTION_ID = #attributes.order_id#
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.order_company_code") and len(attributes.order_company_code)>
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_ROW
					WHERE
						ORDER_ID IN (SELECT O.ORDER_ID FROM ORDERS O WHERE O.ORDER_ID IN (#attributes.order_company_order_list#))
			</cfquery>
			
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_MONEY
					WHERE
						ACTION_ID IN (SELECT O.ORDER_ID FROM ORDERS O WHERE O.ORDER_ID IN (#attributes.order_company_order_list#))
			</cfquery>        	
		</cfif>
		
		<cfset order_id_list = "">
		<cftransaction>
			<cfquery name="get_group" dbtype="query">
				SELECT
					DISTINCT
						PROJECT_ID,
						DEPARTMENT_ID,
						ORDER_DATE,
						COMPANY_ID
				FROM
					myQuery
				ORDER BY
					COMPANY_ID,
					PROJECT_ID,
					ORDER_DATE,
					DEPARTMENT_ID
			</cfquery>
			
			
			<cfoutput query="get_group">
				<cfquery name="get_rows" dbtype="query">
					SELECT
						*
					FROM
						myQuery
					WHERE
						<cfif len(get_group.PROJECT_ID)>
							PROJECT_ID = #get_group.PROJECT_ID# AND
						<cfelse>
							PROJECT_ID IS NULL AND 
						</cfif>
						DEPARTMENT_ID = #get_group.DEPARTMENT_ID# AND
						ORDER_DATE = #get_group.ORDER_DATE# AND
						COMPANY_ID = #get_group.COMPANY_ID#
				</cfquery>
				
				<cfset dept_id_ = get_group.DEPARTMENT_ID>
				<cfset order_date_ = get_group.ORDER_DATE>
				<cfset company_id_ = get_group.COMPANY_ID>
				<cfset project_id_ = get_group.PROJECT_ID>
				
				
				<cfquery name="get_cont" datasource="#dsn3#">
					SELECT
						ORDER_ID
					FROM
						ORDERS
					WHERE
						<cfif isdefined("attributes.order_code") and len(attributes.order_code)>
							ORDER_CODE = '#attributes.order_code#' AND
							<cfif len(project_id_)>
								ISNULL(PROJECT_ID,0) = #project_id_# AND
							<cfelse>
								ISNULL(PROJECT_ID,0) = 0 AND
							</cfif>
							DELIVER_DEPT_ID = #dept_id_# AND
							ORDER_DATE = #order_date_# AND
							COMPANY_ID = #company_id_#
						<cfelseif isdefined("attributes.order_company_code") and len(attributes.order_company_code)>
							<cfif len(project_id_)>
								ISNULL(PROJECT_ID,0) = #project_id_# AND
							<cfelse>
								ISNULL(PROJECT_ID,0) = 0 AND
							</cfif>
							ORDER_ID IN (#attributes.order_company_order_list#) AND
							DELIVER_DEPT_ID = #dept_id_# AND
							ORDER_DATE = #order_date_# AND
							COMPANY_ID = #company_id_#
						<cfelseif len(attributes.order_id)>
							ORDER_ID = #attributes.order_id#
						</cfif>
				</cfquery>
				
				<cfif not get_cont.recordcount>
					<cfquery name="get_order_code" datasource="#dsn3#">
						SELECT ORDER_NO, ORDER_NUMBER FROM GENERAL_PAPERS WHERE PAPER_TYPE = 1 AND ZONE_TYPE = 0
					</cfquery>
					<cfset paper_code = evaluate('get_order_code.ORDER_NO')>
					<cfset paper_number = evaluate('get_order_code.ORDER_NUMBER') +1>
					<cfset paper_full = '#paper_code#-#paper_number#'>
					<cfquery name="UPD_OFFER_CODE" datasource="#dsn3#">
						UPDATE 
							GENERAL_PAPERS 
						SET 
							ORDER_NUMBER = ORDER_NUMBER+1
						WHERE 
							PAPER_TYPE = 1 
							AND ZONE_TYPE = 0
					</cfquery>
					
					<cfquery name="INS_ORDER" datasource="#dsn3#" result="my_result">
						INSERT INTO 
							ORDERS 
							(
							ORDER_CODE,
							PROJECT_ID,
							ORDER_STATUS,
							ORDER_STAGE,
							ORDER_DATE,
							ORDER_NUMBER,
							PURCHASE_SALES,
							COMPANY_ID,
							PARTNER_ID,
							CONSUMER_ID,
							STARTDATE,
							DELIVERDATE,
							PRIORITY_ID,								   
							PAYMETHOD,
							ORDER_HEAD,
							ORDER_DETAIL,
							NETTOTAL,
							DELIVER_DEPT_ID,
							LOCATION_ID,
							INVISIBLE,
							RESERVED,
							TAXTOTAL,
							DISCOUNTTOTAL,
							GROSSTOTAL,
							DUE_DATE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
							)
						VALUES  
							(
							<cfif isdefined("attributes.order_code") and len(attributes.order_code)>'#attributes.order_code#'<cfelse>NULL</cfif>,
							<cfif len(project_id_)>#project_id_#<cfelse>NULL</cfif>,
							1,
							#order_stage_#,
							#order_date_#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_full#">,
							0,
							#company_id_#,
							NULL,
							NULL,
							#now()#,
							#CREATEODBCDATETIME(order_date_)#,
							1,
							NULL,
							'#market_name# Otomatik Sipariş',
							'',
							0,
							#dept_id_#,
							1,
							0,
							1,
							0,
							0,
							0,
							#dateadd('d',1,order_date_)#,
							#now()#,
							#session.ep.userid#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
							)
					</cfquery>
					<cfset lsat_order_id_ = my_result.IDENTITYCOL>
				<cfelse>
					<cfset lsat_order_id_ = get_cont.order_id>
				</cfif>
			<cfset order_id_list = listappend(order_id_list,lsat_order_id_)>
		  
			<cfset order_nettotal = 0>
			<cfset order_grosstotal = 0>
			<cfset order_kdvtotal = 0>
		
			<cfloop query="get_rows"> 
				<cfset stock_id_ = get_rows.STOCK_ID>
				<cfset product_id_ = get_rows.PRODUCT_ID>
				<cfset amount_ = get_rows.AMOUNT> 
				<cfset order_row_currency_ = get_rows.STATUS> 
				
				<cfquery name="get_product_info" datasource="#dsn3#">
					SELECT 
						(SELECT S.PROPERTY FROM STOCKS S WHERE STOCK_ID = #stock_id_#)  AS STOCK_NAME,
						P.TAX,
						P.TAX_PURCHASE,
						PU.MAIN_UNIT,
						PU.MAIN_UNIT_ID
					FROM 
						#dsn1_alias#.PRODUCT_UNIT PU,
						#dsn1_alias#.PRODUCT P
					WHERE
						PU.PRODUCT_ID = P.PRODUCT_ID AND
						PU.PRODUCT_UNIT_STATUS = 1 AND
						PU.IS_MAIN = 1 AND
						P.PRODUCT_ID = #product_id_#
				</cfquery>
					
					
				<cfquery name="ADD_ORDER_ROW_" datasource="#dsn3#" result="my_row_result">
					INSERT INTO 
						ORDER_ROW 	 
						(
						DUEDATE,
						ORDER_ID,
						STOCK_ID,
						PRODUCT_ID,
						PRODUCT_NAME,
						QUANTITY,
						TAX,
						UNIT,
						UNIT_ID,
						ORDER_ROW_CURRENCY,
						PRICE,
						NETTOTAL,
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
						DISCOUNT_COST,
						DISCOUNT_1,
						DISCOUNT_2,
						DISCOUNT_3,
						DISCOUNT_4,
						DISCOUNT_5,
						DISCOUNT_6,
						DISCOUNT_7,
						DISCOUNT_8,
						DISCOUNT_9,
						DISCOUNT_10
						)
					VALUES 
						(
						#VALID#,
						#lsat_order_id_#,
						#stock_id_#,
						#product_id_#,
						'#get_product_info.STOCK_NAME#',
						#amount_#,
						#get_product_info.TAX_PURCHASE#,
						'#get_product_info.MAIN_UNIT#',
						#get_product_info.MAIN_UNIT_ID#,
						#order_row_currency_#,
						#price#,
						#nettotal#,
						'TL',
						#nettotal#,
						#DISCOUNT_COST#,
						#DISCOUNT_1#,
						#DISCOUNT_2#,
						#DISCOUNT_3#,
						#DISCOUNT_4#,
						#DISCOUNT_5#,
						#DISCOUNT_6#,
						#DISCOUNT_7#,
						#DISCOUNT_8#,
						#DISCOUNT_9#,
						#DISCOUNT_10#
						)
				</cfquery>
			</cfloop>
					
			<cfquery name="add_order_money" datasource="#dsn3#">
				INSERT INTO 
					ORDER_MONEY
					(
					MONEY_TYPE,
					RATE1,
					RATE2,
					IS_SELECTED,
					ACTION_ID
					)
					VALUES
					(
					'TL',
					1,
					1,
					1,
					#lsat_order_id_#
					)
			</cfquery>
			</cfoutput>
		</cftransaction>
		<cfif len(order_id_list)>
			<cfinclude template="add_order_price.cfm">
		</cfif>
		
		<cfquery name="get_orders" datasource="#dsn3#">
			SELECT 
				ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ID = O.ORDER_ID),0) AS URUN_SAYISI,
				ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ROW_CURRENCY = -1 AND ORR2.ORDER_ID = O.ORDER_ID),0) AS ACIK_URUN_SAYISI,
				ISNULL((SELECT COUNT(ORDER_ROW_ID) FROM ORDER_ROW ORR2 WHERE ORR2.ORDER_ROW_CURRENCY = -6 AND ORR2.ORDER_ID = O.ORDER_ID),0) AS SEVK_URUN_SAYISI,
				O.ORDER_ID 
			FROM 
				ORDERS O
			WHERE 
				<cfif isdefined("attributes.order_code") and len(attributes.order_code)>
					O.ORDER_CODE = '#attributes.order_code#'
				<cfelseif isdefined("attributes.order_company_code") and len(attributes.order_company_code)>
					O.ORDER_ID IN (#attributes.order_company_order_list#)
				<cfelse>
					O.ORDER_ID = #attributes.order_id#
				</cfif>
		</cfquery>
		
		<cfset del_order_list = "">
		<cfset onaysiz_order_list = "">
		<cfset onayli_order_list = "">
		
		<cfoutput query="get_orders">
			<cfset order_id_ = order_id>
			<cfif get_orders.URUN_SAYISI eq 0>
				<cfset del_order_list = listappend(del_order_list,order_id_)>
			</cfif>
			<cfif SEVK_URUN_SAYISI eq 0>
				<cfset onaysiz_order_list = listappend(onaysiz_order_list,order_id_)>
			<cfelse>
				<cfset onayli_order_list = listappend(onayli_order_list,order_id_)>
			</cfif>
		</cfoutput>
		
		<cfif listlen(del_order_list)>
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDERS WHERE ORDER_ID IN (#del_order_list#)
			</cfquery>
		</cfif>
		
		<cfif listlen(onaysiz_order_list)>
			<cfquery name="UPD_" datasource="#dsn3#">
				UPDATE ORDERS SET ORDER_STAGE = #order_stage_# WHERE ORDER_ID IN (#onaysiz_order_list#)
			</cfquery>
		</cfif>
		
		<cfif listlen(onayli_order_list)>
			<cfquery name="UPD_" datasource="#dsn3#">
				UPDATE ORDERS SET ORDER_STAGE = #valid_order_stage_# WHERE ORDER_ID IN (#onayli_order_list#)
			</cfquery>
		</cfif>
		
		<cfset attributes.order_id_list = valuelist(get_orders.order_id)>
		<cfinclude template="add_order2.cfm">
	<cfelse>
		<cfquery name="get_orders" datasource="#dsn3#">
			DELETE FROM ORDERS WHERE
				<cfif isdefined("attributes.order_code") and len(attributes.order_code)>
					ORDER_CODE = '#attributes.order_code#'
				<cfelseif isdefined("attributes.order_company_code") and len(attributes.order_company_code)>
					ORDER_ID IN (#attributes.order_company_order_list#)
				<cfelse>
					ORDER_ID = #attributes.order_id#
				</cfif>
		</cfquery>
		<cfif isdefined("attributes.order_code") and len(attributes.order_code)>
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_ROW
					WHERE
						ORDER_ID IN (SELECT O.ORDER_ID FROM ORDERS O WHERE O.ORDER_CODE = '#attributes.order_code#')
			</cfquery>
			
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_MONEY
					WHERE
						ACTION_ID IN (SELECT O.ORDER_ID FROM ORDERS O WHERE O.ORDER_CODE = '#attributes.order_code#')
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_ROW
					WHERE
						ORDER_ID = #attributes.order_id#
			</cfquery>
			
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_MONEY
					WHERE
						ACTION_ID = #attributes.order_id#
			</cfquery>
		</cfif>
		<cfif isdefined("attributes.order_company_code") and len(attributes.order_company_code)>
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_ROW
					WHERE
						ORDER_ID IN (#attributes.order_company_order_list#)
			</cfquery>
			
			<cfquery name="del_" datasource="#dsn3#">
				DELETE FROM ORDER_MONEY
					WHERE
						ACTION_ID IN (#attributes.order_company_order_list#)
			</cfquery>
		</cfif>
		<p style="font-size:20px; color:red;"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbspOluşturulmuş Siparişleri İptal Ettiniz.</b></p>
	</cfif>
</cfif>