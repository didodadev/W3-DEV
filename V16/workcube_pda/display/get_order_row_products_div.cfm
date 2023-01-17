<cfsetting showdebugoutput="no">
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT OUR_COMPANY_ID,PERIOD_YEAR,PERIOD_ID FROM SETUP_PERIOD
</cfquery>
<cfif isDefined('attributes.is_prod_barcode') and attributes.is_prod_barcode eq 1>
    <cfquery name="GET_ORDER_ROW_PRODUCTS" datasource="#DSN3#">
        SELECT
            O.ORDER_ID,
            P.BARCOD BARCODE,
            OW.STOCK_ID,
            PU.MULTIPLIER,
            OW.QUANTITY,
            OW.WRK_ROW_ID,
            OW.ORDER_ROW_ID
        FROM
            ORDERS O,
            ORDER_ROW OW,
            PRODUCT_UNIT PU,
            #dsn1_alias#.PRODUCT P
        WHERE
            P.PRODUCT_ID = PU.PRODUCT_ID AND
            O.ORDER_STATUS = 1 AND
            OW.ORDER_ID = O.ORDER_ID AND
            (
                (OW.ORDER_ROW_CURRENCY IN (-6,-7) AND O.IS_PROCESSED = 1) OR 
                (OW.ORDER_ROW_CURRENCY = -6 AND O.IS_PROCESSED = 0)
            ) AND
            PU.PRODUCT_UNIT_STATUS = 1 AND
            PU.PRODUCT_ID = OW.PRODUCT_ID AND
            OW.UNIT = PU.ADD_UNIT AND       
            OW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> 
        GROUP BY
            O.ORDER_ID,
            P.BARCOD,
            OW.STOCK_ID,
            PU.MULTIPLIER,
            OW.QUANTITY,
            OW.WRK_ROW_ID,
            OW.ORDER_ROW_ID        
        ORDER BY
            ORDER_ROW_ID
    </cfquery>
<cfelse>
    <cfquery name="GET_ORDER_ROW_PRODUCTS" datasource="#DSN3#">
        SELECT
            O.ORDER_ID,
            SB.BARCODE,
            OW.STOCK_ID,
            PU.MULTIPLIER,
            OW.QUANTITY,
            OW.WRK_ROW_ID,
            OW.ORDER_ROW_ID
        FROM
            ORDERS O,
            ORDER_ROW OW,
            PRODUCT_UNIT PU,
            STOCKS_BARCODES SB
        WHERE
            OW.STOCK_ID = SB.STOCK_ID AND
            SB.BARCODE IS NOT NULL AND  
            SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND     
            SB.STOCK_ID NOT IN(SELECT SB2.STOCK_ID FROM STOCKS_BARCODES SB2,PRODUCT_UNIT PU2 WHERE PU2.PRODUCT_ID = OW.PRODUCT_ID AND SB2.UNIT_ID = PU2.PRODUCT_UNIT_ID AND PU2.ADD_UNIT = OW.UNIT2 AND SB2.BARCODE IS NOT NULL) AND
            O.ORDER_STATUS = 1 AND
            OW.ORDER_ID = O.ORDER_ID AND
            (
                (OW.ORDER_ROW_CURRENCY IN (-6,-7) AND O.IS_PROCESSED = 1) OR 
                (OW.ORDER_ROW_CURRENCY = -6 AND O.IS_PROCESSED = 0)
            ) AND
            PU.PRODUCT_UNIT_STATUS = 1 AND
            PU.PRODUCT_ID = OW.PRODUCT_ID AND
            OW.UNIT = PU.ADD_UNIT AND       
            OW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> 
        GROUP BY
            O.ORDER_ID,
            SB.BARCODE,
            OW.STOCK_ID,
            PU.MULTIPLIER,
            OW.QUANTITY,
            OW.WRK_ROW_ID,
            OW.ORDER_ROW_ID
        
        UNION
        
        SELECT
            O.ORDER_ID,
            SB.BARCODE,
            OW.STOCK_ID,
            PU.MULTIPLIER,
            OW.QUANTITY,
            OW.WRK_ROW_ID,
            OW.ORDER_ROW_ID
        FROM
            ORDERS O,
            ORDER_ROW OW,
            PRODUCT_UNIT PU,
            STOCKS_BARCODES SB
        WHERE
            OW.STOCK_ID = SB.STOCK_ID AND
            SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
            SB.BARCODE IS NOT NULL AND
            O.ORDER_STATUS = 1 AND
            OW.ORDER_ID = O.ORDER_ID AND
            (
                (OW.ORDER_ROW_CURRENCY IN (-6,-7) AND O.IS_PROCESSED = 1) OR 
                (OW.ORDER_ROW_CURRENCY = -6 AND O.IS_PROCESSED = 0)
            ) AND
            PU.PRODUCT_UNIT_STATUS = 1 AND
            PU.PRODUCT_ID = OW.PRODUCT_ID AND
            OW.UNIT2 = PU.ADD_UNIT AND        
            OW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
        GROUP BY
            O.ORDER_ID,
            SB.BARCODE,
            OW.STOCK_ID,
            PU.MULTIPLIER,
            OW.QUANTITY,
            OW.WRK_ROW_ID,
            OW.ORDER_ROW_ID
        ORDER BY
            ORDER_ROW_ID
    </cfquery>
</cfif>
<cfquery name="CONTROL_ORDER_SHIPS" datasource="#DSN3#">
    SELECT
		STOCK_ID,
		WRK_ROW_RELATION_ID,
		SUM(AMOUNT) AS AMOUNT,
		ORDER_ID
	FROM
		(
            <cfloop query="get_period">
                SELECT
                    SHIP_ROW.STOCK_ID,
                    SHIP_ROW.WRK_ROW_RELATION_ID,
                    SUM(AMOUNT) AS AMOUNT,
                    ORDERS_SHIP.ORDER_ID
                FROM
                    #dsn#_#period_year#_#our_company_id#.SHIP SHIP,
                    #dsn#_#period_year#_#our_company_id#.SHIP_ROW SHIP_ROW,
                    ORDERS_SHIP
                WHERE
                    SHIP.SHIP_ID = ORDERS_SHIP.SHIP_ID AND
                    ORDERS_SHIP.ORDER_ID = SHIP_ROW.ROW_ORDER_ID AND
                    SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND
                    SHIP_ROW.ROW_ORDER_ID IN (#attributes.order_id#) AND
                    ORDERS_SHIP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_period.period_id#">
                GROUP BY
                    SHIP_ROW.STOCK_ID,SHIP_ROW.WRK_ROW_RELATION_ID,ORDERS_SHIP.ORDER_ID
                <cfif get_period.currentrow neq get_period.recordcount>
                	UNION ALL
                </cfif>
            </cfloop>
		) AS T1
	GROUP BY
		STOCK_ID,WRK_ROW_RELATION_ID,ORDER_ID
</cfquery>
<cfset order_ref_no_ = "">
<cfset order_detail_ = "">
<cfif get_order_row_products.recordcount>
	<cfif not (len(order_ref_no_) and len(order_detail_))>
		<cfquery name="GET_ORDER_DETAIL" datasource="#DSN3#">
			SELECT REF_NO,ORDER_DETAIL FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row_products.order_id#">
		</cfquery>
		<cfset order_ref_no_ = get_order_detail.ref_no>
		<cfset replace_list = "',#Chr(10)#,#Chr(13)#"><!--- Satir kirma vb sorun oldugundan kaldirmak icin eklendi degistirmeyin FBS --->
		<cfset replace_list_new = ",,">
		<cfset order_detail_ = ReplaceList(get_order_detail.order_detail,replace_list,replace_list_new)>
	</cfif>
	<cfoutput query="get_order_row_products">
		<cfset quantity_ = get_order_row_products.quantity>
		<cfif control_order_ships.recordcount>
			<cfquery name="GET_USED_ORDER_AMOUNT" dbtype="query">
				SELECT SUM(AMOUNT) AMOUNT FROM CONTROL_ORDER_SHIPS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row_products.stock_id#"> AND WRK_ROW_RELATION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order_row_products.wrk_row_id#">
			</cfquery>
			<cfif get_used_order_amount.recordcount>
				<cfset used_amount = get_used_order_amount.amount>
			<cfelse>
				<cfset used_amount = 0>
			</cfif>
		<cfelse>
			<cfset used_amount = 0>
		</cfif>
		<cfif isDefined('attributes.only_quantity') and attributes.only_quantity eq 1>
			<cfset yeni_miktar = quantity_>
		<cfelse>
			<cfset yeni_miktar = (quantity_-used_amount)/get_order_row_products.multiplier>
		</cfif>
		<cfif yeni_miktar gt 0>
			<script type="text/javascript">
				<cfif Len(order_ref_no_)>
					if(document.getElementById('ref_no') != undefined && document.getElementById('ref_no').value == "")
						document.getElementById('ref_no').value = "#order_ref_no_#";
				</cfif>
				<cfif Len(order_detail_)>
					if(document.getElementById('detail') != undefined && document.getElementById('detail').value == "")
						document.getElementById('detail').value = "#order_detail_#";
				</cfif>
						
				i = parseInt(document.getElementById('row_count').value) + 1;
				add_barcode2(document.getElementById('row_count').value,'#get_order_row_products.BARCODE#',2)
				document.getElementById('amount'+i).value = "#TLFormat(yeni_miktar,4)#";
				document.getElementById('row_ship_id'+i).value = "#attributes.order_id#";
				
				document.getElementById('wrk_row_relation_id'+i).value = <cfif len(get_order_row_products.wrk_row_id)>'#get_order_row_products.wrk_row_id#'<cfelse>''</cfif>;
				
			</script>
		</cfif>
	</cfoutput>
</cfif>
<td colspan="2">
	<div id="order_row_div"></div>
	<div id="order_row_div_action"></div>
</td>
