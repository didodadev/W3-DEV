<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

<cfset order_stage_ = 43>
<cfset birim_ = 7>



<cfset myQuery = QueryNew("ROW_ID,DEPARTMENT_ID,ORDER_DATE,COMPANY_ID,STOCK_ID,PRODUCT_ID,AMOUNT,VALID,NETTOTAL,PRICE,DISCOUNT_COST,DISCOUNT_1,DISCOUNT_2,DISCOUNT_3,DISCOUNT_4,DISCOUNT_5,DISCOUNT_6,DISCOUNT_7,DISCOUNT_8,DISCOUNT_9,DISCOUNT_10,PROJECT_ID", "Integer,Integer,Date,Integer,Integer,Integer,Decimal,Integer,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Integer")>
<cfset query_count = 0>

<cfloop list="#attributes.selected_product_list#" index="product_id">
<cfif isdefined("attributes.PRODUCT_STOCK_LIST_#product_id#")>
	<cfset stock_list = evaluate("attributes.PRODUCT_STOCK_LIST_#product_id#")>
    <cfloop list="#stock_list#" index="stock_id">
        <cfloop list="#attributes.DEPARTMENT_ID_LIST#" index="depo_id">
            <cfset company_id = listfirst(evaluate("attributes.company_id_#product_id#"))>
            <cfset project_id = listfirst(evaluate("attributes.project_id_#product_id#"))>
			
			<cfif listlen(stock_list) eq 1 and listlen(attributes.DEPARTMENT_ID_LIST) eq 1>
            	<cfset amount1 = evaluate("attributes.STOCK_SATIS_AMOUNT_#product_id#")>
                <cfset date1 = evaluate("attributes.ORDER_DATE_1_#product_id#")>
                
                <cfset amount2 = evaluate("attributes.STOCK_SATIS_AMOUNT_2_#product_id#")>
                <cfset date2 = evaluate("attributes.ORDER_DATE_2_#product_id#")>
            <cfelse>
            	<cfset amount1 = evaluate("attributes.STOCK_SATIS_AMOUNT_#product_id#_#stock_id#_#depo_id#")>
                <cfset date1 = evaluate("attributes.ORDER_DATE_1_#product_id#")>
                
                <cfset amount2 = evaluate("attributes.STOCK_SATIS_AMOUNT_2_#product_id#_#stock_id#_#depo_id#")>
                <cfset date2 = evaluate("attributes.ORDER_DATE_2_#product_id#")>
            </cfif>
            
            
            <cfquery name="get_p" datasource="#dsn_dev#">
            	SELECT
                	ISNULL(( 
                        SELECT TOP 1 
                            PT1.NEW_ALIS
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_P = 1 AND
                            PT1.STARTDATE <= #bugun_# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_# AND
                            PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID
                        ORDER BY
                            PT1.STARTDATE DESC,
                            PT1.ROW_ID DESC
                    ),PS.PRICE) AS LISTE_FIYAT,
                    ISNULL(( 
                        SELECT TOP 1 
                            PT1.NEW_ALIS_KDV
                        FROM
                            #DSN_DEV#.PRICE_TABLE PT1
                        WHERE
                            PT1.IS_ACTIVE_P = 1 AND
                            PT1.STARTDATE <= #bugun_# AND 
                            DATEADD("d",-1,PT1.FINISHDATE) >= #bugun_# AND
                            PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID
                        ORDER BY
                            PT1.STARTDATE DESC,
                            PT1.ROW_ID DESC
                    ),PS.PRICE_KDV) AS LISTE_FIYAT_KDV,
                    PS.PRICE
                FROM
                	#dsn1_alias#.PRODUCT P,
                    #dsn1_alias#.PRICE_STANDART PS
                WHERE
                	PS.PRODUCT_ID = P.PRODUCT_ID AND
                    PS.PURCHASESALES = 0 AND
                    PS.PRICESTANDART_STATUS = 1 AND
                    P.PRODUCT_ID = #product_id#
            </cfquery>
            
            
            
            <cfset price = GET_P.PRICE>
            <cfset price_net = GET_P.LISTE_FIYAT>
            <cfset price_kdv = GET_P.LISTE_FIYAT_KDV>
                        
            <cfset discount_ilk = evaluate('sales_discount_#product_id#')>
			<cfset discount_manuel = evaluate('p_discount_manuel_#product_id#')>
            <cfif len(discount_manuel)>
            	<cfset discount_manuel = filternum(discount_manuel,4)>
            <cfelse>
            	<cfset discount_manuel = 0>
            </cfif>
            
            <cfset vade_row = evaluate('p_dueday_#product_id#')>
            <cfif not len(vade_row)>
            	<cfset vade_row = 30>
            </cfif>

            <cfloop from="1" to="10" index="i">
                <cfset 'discount_#i#' = 0>
            </cfloop>

			<cfset i = 0>
            <cfloop list="#discount_ilk#" index="dis" delimiters="+">
                <cfset i = i+1>
                <cfset 'discount_#i#' = filternum(dis)>
            </cfloop>
                
                
				<cfif isdefined("attributes.is_order_#product_id#_#stock_id#_#depo_id#") and len(amount1) and len(date1) and isdate(date1) and len(company_id) and amount1 gt 0>
                	<cf_date tarih = 'date1'>
                    <cfset query_count = query_count + 1>
					<cfset newRow = QueryAddRow(MyQuery,1)>
                    <cfset temp = QuerySetCell(myQuery,"ROW_ID","#query_count#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DEPARTMENT_ID","#depo_id#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"ORDER_DATE","#date1#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"COMPANY_ID","#company_id#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"STOCK_ID","#stock_id#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"PRODUCT_ID","#product_id#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"AMOUNT","#filternum(amount1)#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"VALID","#vade_row#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_COST","#discount_manuel#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_1","#discount_1#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_2","#discount_2#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_3","#discount_3#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_4","#discount_4#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_5","#discount_5#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_6","#discount_6#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_7","#discount_7#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_8","#discount_8#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_9","#discount_9#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_10","#discount_10#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"PRICE","#price#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"NETTOTAL","#price_net * filternum(amount1)#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"PROJECT_ID","#project_id#",query_count)>
                </cfif>
                
                <cfif isdefined("attributes.is_order2_#product_id#_#stock_id#_#depo_id#") and len(amount2) and len(date2) and isdate(date2) and len(company_id) and amount2 gt 0>
                	<cf_date tarih = 'date2'>
                	<cfset query_count = query_count + 1>
					<cfset newRow = QueryAddRow(MyQuery,1)>
                    <cfset temp = QuerySetCell(myQuery,"ROW_ID","#query_count#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DEPARTMENT_ID","#depo_id#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"ORDER_DATE","#date2#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"COMPANY_ID","#company_id#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"STOCK_ID","#stock_id#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"PRODUCT_ID","#product_id#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"AMOUNT","#filternum(amount2)#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"VALID","#vade_row#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_COST","#discount_manuel#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_1","#discount_1#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_2","#discount_2#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_3","#discount_3#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_4","#discount_4#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_5","#discount_5#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_6","#discount_6#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_7","#discount_7#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_8","#discount_8#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_9","#discount_9#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"DISCOUNT_10","#discount_10#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"PRICE","#price#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"NETTOTAL","#price_net * filternum(amount2)#",query_count)>
                    <cfset temp = QuerySetCell(myQuery,"PROJECT_ID","#project_id#",query_count)>
                </cfif>
        </cfloop>
    </cfloop>
</cfif>
</cfloop>




<cfquery name="myQuery" dbtype="query">
	SELECT * FROM myQuery WHERE AMOUNT > 0
</cfquery>

<cfif myQuery.recordcount>
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
  
  	<cfset order_id_list = listappend(order_id_list,lsat_order_id_)>
  
  	<cfset order_nettotal = 0>
    <cfset order_grosstotal = 0>
    <cfset order_kdvtotal = 0>
   	<cfloop query="get_rows"> 
    	<cfset stock_id_ = get_rows.STOCK_ID>
        <cfset product_id_ = get_rows.PRODUCT_ID>
        <cfset amount_ = get_rows.AMOUNT> 
        
        
        <cfquery name="get_product_info" datasource="#dsn3#">
            SELECT 
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
                '#wrk_eval("attributes.STOCK_NAME_#product_id_#_#stock_id_#")#',
                #amount_#,
                #get_product_info.TAX_PURCHASE#,
                '#get_product_info.MAIN_UNIT#',
                #get_product_info.MAIN_UNIT_ID#,
                -1,
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
        <cfset last_order_row_id_ = my_row_result.IDENTITYCOL>
        <cfset alis_kdv_rank = 1 + (price_kdv / 100)>
        <cfset grosstotal = nettotal * alis_kdv_rank>
        <cfset kdvtotal = grosstotal - nettotal>
        <cfset order_nettotal = order_nettotal + nettotal>
        <cfset order_kdvtotal = order_kdvtotal + kdvtotal>
        <cfset order_grosstotal = order_grosstotal + grosstotal>
    </cfloop>
    
    <cfquery name="upd_order" datasource="#dsn3#">
    	UPDATE
        	ORDERS
        SET
        	NETTOTAL = #order_grosstotal#,
            TAXTOTAL = #kdvtotal#,
            GROSSTOTAL = #order_nettotal#
        WHERE
        	ORDER_ID = #lsat_order_id_#
    </cfquery>
    
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
	<cfinclude template="add_order2.cfm">
</cfif>
<cfelse>
	İlgili Sipariş Satırı Bulunamadı!
</cfif>