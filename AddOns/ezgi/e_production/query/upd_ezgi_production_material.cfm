<cfset katsayi = FilterNum(attributes.optimizasyon,3)/FilterNum(attributes.plan_demand,3)>
<cfif LEN(attributes.PRODUCT_ID) and attributes.PRODUCT_ID neq attributes.pid>
    <cfquery name="GET_STOCK_ID" datasource="#DSN1#">
        SELECT MAX(STOCK_ID) AS STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #attributes.PRODUCT_ID# AND STOCK_STATUS = 1
    </cfquery>
</cfif>
<cftransaction>
	<cfquery name="upd_production_order_material" datasource="#DSN3#">
		UPDATE       
        	PRODUCTION_ORDERS_STOCKS
		SET                
        	AMOUNT = AMOUNT * #katsayi# 
            <cfif LEN(attributes.PRODUCT_ID) and attributes.PRODUCT_ID neq attributes.pid>
            	,PRODUCT_ID = #attributes.PRODUCT_ID#,
                STOCK_ID = #GET_STOCK_ID.STOCK_ID#
            </cfif>
		WHERE        
        	P_ORDER_ID IN
                     	(
                        	SELECT        
                            	PO.P_ORDER_ID
                         	FROM            
                            	EZGI_IFLOW_PRODUCTION_ORDERS AS E INNER JOIN
                             	PRODUCTION_ORDERS AS PO ON E.LOT_NO = PO.LOT_NO
                      		WHERE        
                            	E.IFLOW_P_ORDER_ID IN (#attributes.iid#)
                      	) AND 
          	STOCK_ID = #attributes.sid# AND 
            TYPE = 2
	</cfquery>
</cftransaction>
<script type="text/javascript">
	alert('<cf_get_lang_main no='3466.Optimizasyon Girişi Tamamlandı'>.')
	wrk_opener_reload();
	window.close();
</script>