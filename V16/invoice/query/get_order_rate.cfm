<cfif isdefined("order_id_list") and len(order_id_list)>
	<cfloop list="#order_id_list#" index="k">
		<cfset attributes.order_id = k >
		<cfquery name="get_inv_amounts" datasource="#dsn2#">
			SELECT
				SUM(IR.AMOUNT) AS INVOICE_AMOUNT,
				IR.STOCK_ID
			FROM
				INVOICE I,
				INVOICE_ROW IR
			WHERE
				I.INVOICE_ID=IR.INVOICE_ID AND
				IR.ORDER_ID=#attributes.order_id#
			GROUP BY
				IR.STOCK_ID
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
		<cfset list_inv_stock_ids = listsort(valuelist(get_inv_amounts.STOCK_ID),'numeric','ASC')>
		<cfloop query="get_order_amounts">
			<cfset stock_id_yeri = listfind(list_inv_stock_ids,STOCK_ID)>
			<cfif stock_id_yeri>
				<cfset order_process_flag = true>
				<cfif ORDER_AMOUNT eq get_inv_amounts.INVOICE_AMOUNT[stock_id_yeri]>
					<cfset order_row_currency = -3>
				<cfelseif ORDER_AMOUNT gt get_inv_amounts.INVOICE_AMOUNT[stock_id_yeri]>
					<cfset order_row_currency = -7>
				<cfelseif ORDER_AMOUNT lt get_inv_amounts.INVOICE_AMOUNT[stock_id_yeri]>
					<cfset order_row_currency = -8>
				</cfif>
				<cfquery name="UPD_ORD_ROW" datasource="#DSN2#">
					UPDATE 
						#dsn3_alias#.ORDER_ROW 
					SET 
						ORDER_ROW_CURRENCY = #order_row_currency#
					WHERE 
						ORDER_ID = #attributes.order_id# AND
						STOCK_ID = #STOCK_ID#
				</cfquery>
			<cfelse>
				<cfquery name="UPD_ORD_ROW" datasource="#DSN2#">
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
		<cfquery name="UPD_ORD" datasource="#DSN2#">
			UPDATE 
				#dsn3_alias#.ORDERS 
			SET 
				IS_PROCESSED = <cfif order_process_flag>1<cfelse>0</cfif>,
				RESERVED = 0
			WHERE 
				ORDER_ID = #attributes.order_id#
		</cfquery>
	</cfloop>
</cfif>

