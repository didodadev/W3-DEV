

<cfset attributes.orderids = left(attributes.orderids,len(attributes.orderids)-1)>
<cfset attributes.amounts = left(attributes.amounts,len(attributes.amounts)-1)>
<cfset attributes.pids=left(attributes.pids,len(attributes.pids)-1)>
<cfset attributes.projectid=left(attributes.projectid,len(attributes.projectid)-1)>
<cfquery name="get_orders" datasource="#dsn3#">
	SELECT 
				ISNULL((SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID =ORR.SPECT_VAR_ID),0) AS SPECT_MAIN_ID,
				
				ORR.ORDER_ROW_ID,
				ORR.QUANTITY,
				O.ORDER_ID,
				ORR.UNIT,
				ORR.ORDER_ROW_CURRENCY,
				ORR.SPECT_VAR_ID,
				S.PROPERTY, 
				CASE WHEN S.STOCK_CODE = '' THEN '_' ELSE ISNULL(S.STOCK_CODE,'_') END AS STOCK_CODE,
				ORR.UNIT2,
				ORR.AMOUNT2,
				ORR.DELIVER_DATE AS ROW_DELIVER_DATE,
				S.STOCK_ID,
				S.PRODUCT_NAME,				
				S.STOCK_CODE_2,
				S.PRODUCT_ID,
				ORR.WRK_ROW_ID
			FROM 
				ORDERS O,
				ORDER_ROW ORR,
				PRODUCT_UNIT PU,
				STOCKS S
			WHERE
				( (O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1) ) AND  
				PU.PRODUCT_ID = S.PRODUCT_ID AND
				ORR.STOCK_ID = S.STOCK_ID AND
				ORR.PRODUCT_ID = S.PRODUCT_ID AND
				S.IS_PRODUCTION = 1 AND
				ORR.ORDER_ID = O.ORDER_ID AND
				O.ORDER_STATUS = 1
				AND	ORR.ORDER_ROW_CURRENCY = -5
			    AND O.ORDER_ID IN(#attributes.orderids#)
			    AND ORR.PRODUCT_ID IN(#attributes.pids#)
    </cfquery>
<form name="go_stock_list" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=prod.tracking">
    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <input type="hidden" name="start_date" id="start_date" value="">
    <input type="hidden" name="finish_date" id="finish_date" value="">
    <input type="hidden" name="list_type" id="list_type" value="2">
    <input type="hidden" name="from_order_list" id="from_order_list" value="1">
    <input type="hidden" name="row_stock_all" id="row_stock_all" value="<cfoutput query="get_orders">#STOCK_CODE#<cfif currentrow neq recordcount>,</cfif></cfoutput>">
	<input type="hidden" name="projectid" id="projectid" value="<cfoutput>#attributes.projectid#</cfoutput>">
	<cfif isDefined("attributes.req_id") and len(attributes.req_id)>
	<input type="hidden" name="req_id" id="req_id" value="<cfoutput>#attributes.req_id#</cfoutput>">
	</cfif>
    <cfif get_orders.recordcount>
        <cfset kalan_uretim_emri__ =''>
        <cfoutput query="get_orders">
				<cfset marj=ListGetAt(attributes.amounts,ListFind(attributes.orderids,ORDER_ID))>
				
                <cfset 'kalan_uretim_emri_#ORDER_ROW_ID#' = ceiling(QUANTITY+(QUANTITY*marj/100))>
            <cfset kalan_uretim_emri__ = ListAppend(kalan_uretim_emri__,evaluate('kalan_uretim_emri_#ORDER_ROW_ID#'))>
        </cfoutput>
    </cfif>

    <input type="hidden" name="row_spect_all" id="row_spect_all" value="<cfoutput query="get_orders"><cfif len(SPECT_MAIN_ID)>#SPECT_MAIN_ID#<cfelse>0</cfif><cfif currentrow neq recordcount>,</cfif></cfoutput>">
    <input type="hidden" name="row_amount_all" id="row_amount_all" value="<cfoutput>#kalan_uretim_emri__#</cfoutput>">
</form>
<script>
    	window.go_stock_list.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_materials_total";
			document.go_stock_list.submit();
</script>