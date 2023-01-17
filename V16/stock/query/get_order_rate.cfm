<cfif isnumeric(attributes.order_id)>
	<cfquery name="get_ship_amounts" datasource="#dsn2#">
		SELECT
			SUM(SR.AMOUNT) AS SHIP_AMOUNT,
			SR.STOCK_ID
		FROM
			SHIP S,
			SHIP_ROW SR
		WHERE
			S.SHIP_ID=SR.SHIP_ID AND
			SR.ROW_ORDER_ID=#attributes.order_id#
		GROUP BY
			SR.STOCK_ID
	</cfquery>
	
	<cfquery name="get_order_amounts" datasource="#dsn2#">
		SELECT 
			SUM(ORR.QUANTITY) AS ORDER_AMOUNT,
			ORR.STOCK_ID
		FROM 
			#dsn3_alias#.ORDERS O,
			#dsn3_alias#.ORDER_ROW ORR
		WHERE 
			O.ORDER_ID=ORR.ORDER_ID
			AND O.ORDER_ID=#attributes.order_id#
		GROUP BY
			ORR.STOCK_ID
		ORDER BY
			ORR.STOCK_ID
	</cfquery>
	<cfset order_process_flag = false>
	<cfset list_ship_stock_ids = listsort(valuelist(get_ship_amounts.STOCK_ID),'numeric','ASC')>
	<cfloop query="get_order_amounts">
		<cfset stock_id_yeri = listfind(list_ship_stock_ids,STOCK_ID)>
		<cfif stock_id_yeri>
			<cfset order_process_flag = true>
			<cfif ORDER_AMOUNT eq get_ship_amounts.SHIP_AMOUNT[stock_id_yeri]>
				<cfset order_row_currency = -3>
			<cfelseif ORDER_AMOUNT gt get_ship_amounts.SHIP_AMOUNT[stock_id_yeri]>
				<cfset order_row_currency = -7>
			<cfelseif ORDER_AMOUNT lt get_ship_amounts.SHIP_AMOUNT[stock_id_yeri]>
				<cfset order_row_currency = -8>
			</cfif>
			<cfquery name="UPD_ORD_ROW" datasource="#dsn2#">
				UPDATE 
					#dsn3_alias#.ORDER_ROW 
				SET 
					ORDER_ROW_CURRENCY = #order_row_currency#
				WHERE 
					ORDER_ID = #attributes.order_id# AND
					STOCK_ID = #STOCK_ID#
			</cfquery>
		<cfelse>
			<cfquery name="UPD_ORD_ROW" datasource="#dsn2#">
				UPDATE 
					#dsn3_alias#.ORDER_ROW 
				SET 
					ORDER_ROW_CURRENCY = -6
				WHERE 
					ORDER_ID = #attributes.order_id# AND
					STOCK_ID = #STOCK_ID# AND
					ORDER_ROW_CURRENCY IN (-3,-7,-8)
			</cfquery>
		</cfif>
	</cfloop>
	<cfquery name="UPD_ORD" datasource="#dsn2#">
		UPDATE 
			#dsn3_alias#.ORDERS 
		SET 
			IS_PROCESSED = <cfif order_process_flag>1<cfelse>0</cfif>
		<!--- <cfif isdefined('get_process_type.IS_STOCK_ACTION') and get_process_type.IS_STOCK_ACTION eq 1> ---><!---sadece siparisin cekildigi irsaliye stok hareketi yapıyorsa siparişteki rezerve seçeneği kaldırılır  --->
			,RESERVED = 0
		<!--- </cfif> --->
		WHERE 
			ORDER_ID = #attributes.order_id#
	</cfquery>
</cfif>
