<cfquery name="GET_SERIAL_ROW_LIST" datasource="#dsn3#">
	SELECT
		ORDER_ROW.STOCK_ID,
		ORDER_ROW.ORDER_ROW_ID AS PROCESS_ROW_ID,
		ORDER_ROW.PRODUCT_ID,
		ORDER_ROW.QUANTITY,
		ORDERS.ORDER_ID AS PROCESS_ID,
		ORDERS.ORDER_ZONE AS PROCESS_ZONE,
		ORDERS.PURCHASE_SALES,
		ORDERS.ORDER_NUMBER AS PROCESS_NUMBER,
		ORDERS.ORDER_DATE AS PROCESS_DATE,
		ORDERS.DELIVERDATE,
		ORDERS.PARTNER_ID,
		ORDERS.CONSUMER_ID,
		ORDERS.LOCATION_ID,
		ORDERS.DELIVER_DEPT_ID
	FROM
		ORDERS,
		ORDER_ROW,
		STOCKS
		<cfif Len(attributes.employee) or Len(attributes.serial_no) or Len(attributes.lot_no)>
		,SERVICE_GUARANTY_TEMP
		</cfif>
	WHERE
		ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
	AND
		ORDER_ROW.STOCK_ID = STOCKS.STOCK_ID
	AND
		STOCKS.IS_SERIAL_NO = 1
	AND
		ORDERS.ORDER_STATUS = 1
<cfif Len(attributes.employee) or Len(attributes.serial_no) or Len(attributes.lot_no)>
	AND
		ORDER_ROW.ORDER_ROW_ID = SERVICE_GUARANTY_TEMP.ROW_ID
	<cfif Len(attributes.employee) and Len(attributes.employee_id)>
	AND
		SERVICE_GUARANTY_TEMP.RECORD_EMP = #attributes.employee_id#
	</cfif>
	<cfif Len(attributes.serial_no)>
	AND
	  (
		SERVICE_GUARANTY_TEMP.TEMP_SERIAL_NOS LIKE '%#attributes.serial_no#,%'
		OR
		SERVICE_GUARANTY_TEMP.TEMP_SERIAL_NOS LIKE '%,#attributes.serial_no#%'
	   )
	</cfif>
	<cfif Len(attributes.lot_no)>
	AND
	  (
		SERVICE_GUARANTY_TEMP.TEMP_LOT_N0 LIKE '%#attributes.lot_no#,%'
		OR
		SERVICE_GUARANTY_TEMP.TEMP_LOT_N0 LIKE '%,#attributes.lot_no#%'
	   )
	</cfif>
</cfif>
<cfif isDefined("attributes.order_id") and len(attributes.order_id)>
	AND
		ORDER_ROW.ORDER_ID = #attributes.order_id#
</cfif>
<cfif Len(attributes.process_cat_id) and attributes.process_cat_id eq 0>
	AND	
		(ORDERS.ORDER_ZONE = 0 AND ORDERS.PURCHASE_SALES = 0)		
<cfelseif Len(attributes.process_cat_id) and attributes.process_cat_id eq 1>
	AND 
		(
		(
			(ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0)
			OR
			(ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1)	
		)
		OR 
			ORDERS.ORDER_ZONE = 2 
		)
</cfif>
<cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
	AND
		(
			ORDERS.ORDER_NUMBER LIKE '%#attributes.belge_no#%' OR ORDERS.ORDER_HEAD LIKE '%#attributes.belge_no#%'
		)
</cfif>
<cfif isdate(attributes.date1) and not isDefined("attributes.order_id")>
	AND ORDERS.DELIVERDATE >= #attributes.date1#
</cfif>
<cfif isdate(attributes.date2) and not isDefined("attributes.order_id")>
	AND ORDERS.DELIVERDATE <= #attributes.date2#
</cfif>
<cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
	AND
		ORDERS.COMPANY_ID = #attributes.company_id#
</cfif>
	ORDER BY ORDER_ROW.ORDER_ID,ORDER_ROW.DELIVER_DEPT
</cfquery>
