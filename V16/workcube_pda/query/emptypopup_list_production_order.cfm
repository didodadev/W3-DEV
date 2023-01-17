<cfsetting showdebugoutput="no"><cfif isDate(attributes.start_date)><cf_date tarih='attributes.start_date'><cfelse><cfset attributes.start_date = ""></cfif>
<cfif isDate(attributes.start_date2)><cf_date tarih='attributes.start_date2'><cfelse><cfset attributes.start_date2 = ""></cfif>
<cfif isDate(attributes.finish_date)><cf_date tarih='attributes.finish_date'><cfelse><cfset attributes.finish_date = ""></cfif>
<cfif isDate(attributes.finish_date2)><cf_date tarih='attributes.finish_date2'><cfelse><cfset attributes.finish_date2 = ""></cfif>
<cfquery name="GET_PRODUCTION_ORDERS" datasource="#DSN3#">
	SELECT
		S.PRODUCT_ID,
		S.PRODUCT_NAME,
		PO.P_ORDER_ID,
		PO.P_ORDER_NO,
		PO.START_DATE,
		PO.FINISH_DATE,
		PO.QUANTITY,
		ISNULL((SELECT
					SUM(POR_.AMOUNT) ORDER_AMOUNT
				FROM
					PRODUCTION_ORDER_RESULTS_ROW POR_,
					PRODUCTION_ORDER_RESULTS POO
				WHERE
					POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND 
					POO.P_ORDER_ID = PO.P_ORDER_ID AND 
					POR_.TYPE = 1 AND 
					POO.IS_STOCK_FIS = 1
				),0) ROW_RESULT_AMOUNT
	FROM
		STOCKS S,
		PRODUCTION_ORDERS PO
	WHERE
		ISNULL((SELECT
					SUM(POR_.AMOUNT) ORDER_AMOUNT
				FROM
					PRODUCTION_ORDER_RESULTS_ROW POR_,
					PRODUCTION_ORDER_RESULTS POO
				WHERE
					POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND 
					POO.P_ORDER_ID = PO.P_ORDER_ID AND 
					POR_.TYPE = 1 AND 
					POO.IS_STOCK_FIS = 1
				),0) <> PO.QUANTITY AND
		<cfif isDefined('attributes.product_id') and Len(attributes.product_id) and isDefined('attributes.product_name') and len(attributes.product_name)>
			S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		</cfif>
		<cfif isDefined('attributes.order_no') and Len(attributes.order_no)>
			PO.P_ORDER_ID IN (SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE ORDER_ID IN (SELECT ORDER_ID FROM ORDERS WHERE ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.order_no#">)) AND
		</cfif> 
		<cfif Len(attributes.station_id)>
			PO.STATION_ID <cfif attributes.station_id eq 0>IS NULL<cfelse>IN (#attributes.station_id#)</cfif> AND
		</cfif>
		<cfif isDate(attributes.start_date)>
			PO.START_DATE >= #attributes.start_date# AND
		</cfif>
		<cfif isDate(attributes.start_date2)>
			PO.START_DATE < #attributes.start_date2# AND
		</cfif>
		<cfif isDate(attributes.finish_date)>
			PO.FINISH_DATE >= #attributes.finish_date# AND
		</cfif>
		<cfif isDate(attributes.finish_date2)>
			PO.FINISH_DATE >= #attributes.finish_date2# AND
		</cfif>
		S.STOCK_ID = PO.STOCK_ID
	ORDER BY
		PO.FINISH_DATE DESC
</cfquery>
<cf_box title="Üretim Emirleri" body_style="overflow-y:scroll;height:100px;width:250px;">
   <table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">
        <tr class="color-header">
            <td class="form-title">No</td>
            <td class="form-title">Tarih</td>
            <td class="form-title">Ürün</td>
            <td class="form-title" style="text-align:right;">Miktar</td>
            <td class="form-title" style="text-align:right;">Kalan</td>
        </tr>
        <cfif get_production_orders.recordcount>
            <cfoutput query="get_production_orders">
                <tr class="color-row">
                    <td><a href="#request.self#?fuseaction=pda.form_add_production_result&p_order_id=#p_order_id#" class="tableyazi">#p_order_no#</a></td>
                    <td>#DateFormat(start_date,'dd/mm/yy')# - #DateFormat(finish_date,'dd/mm/yy')#</td>
                    <td>#Left(product_name,10)#</td>
                    <td style="text-align:right;">#quantity#</td>
                    <td style="text-align:right;">#quantity-row_result_amount#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr class="color-row">
                <td colspan="5">Kayıt Yok!</td>
            </tr>
        </cfif>
    </table>
</cf_box> 
