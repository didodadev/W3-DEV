<cfquery name="get_old_stock" datasource="#dsn3#">
	SELECT
    	POR_STOCK_ID,    
    	STOCK_ID, 
        AMOUNT
	FROM         
    	PRODUCTION_ORDERS_STOCKS
	WHERE     
    	POR_STOCK_ID IN (#attributes.por_stock_id#)
</cfquery>
<cfquery name="get_old_stock_total" dbtype="query">
	SELECT     
    	STOCK_ID, 
        SUM(AMOUNT) AS AMOUNT
	FROM         
    	get_old_stock
	WHERE     
    	POR_STOCK_ID IN (#attributes.por_stock_id#)
	GROUP BY 
    	STOCK_ID
</cfquery>
<cfoutput query="get_old_stock_total">
	<cfset 'oran_#STOCK_ID#' = (Filternum(Evaluate('T_AMOUNT_#STOCK_ID#')) - AMOUNT)/AMOUNT>
</cfoutput>
<cftransaction>
	<cfif attributes.upd eq 1>
    	<cfloop query="get_old_stock">
            <cfquery name="upd_metarial_control" datasource="#dsn3#">
                UPDATE 
                	EZGI_METARIAL_CONTROL
                SET
                    STATUS= <cfif isdefined('var_yok_#POR_STOCK_ID#') and len(evaluate('var_yok_#POR_STOCK_ID#'))>#Evaluate('var_yok_#POR_STOCK_ID#')#<cfelse>NULL</cfif>,
                    PASTAL_CODE= <cfif isdefined('pastal_code_#POR_STOCK_ID#') and len(evaluate('pastal_code_#POR_STOCK_ID#'))>'#Evaluate('pastal_code_#POR_STOCK_ID#')#'<cfelse>NULL</cfif>,
                    UPDATE_EMP=#session.ep.userid#,  
                    UPDATE_DATE=#now()#, 
                    UPDATE_IP='#CGI.REMOTE_ADDR#'
                WHERE     
                    POR_STOCK_ID = #POR_STOCK_ID# AND
                    <cfif isdefined('attributes.lot_no') and len(attributes.lot_no)>
                        LOT_NO = '#attributes.lot_no#' 
                    <cfelseif isdefined('attributes.order_id') and len(attributes.order_id)>
                    	ORDER_ID = #attributes.order_id#
                    </cfif>
            </cfquery>
            <cfset new_amount = NumberFormat((Evaluate('oran_#STOCK_ID#') * amount) + amount,'9.99')>
            <cfquery name="upd_product_orders_stocks" datasource="#dsn3#">
                UPDATE    
                    PRODUCTION_ORDERS_STOCKS
                SET              
                    AMOUNT = #new_amount#
                WHERE     
                    POR_STOCK_ID = #POR_STOCK_ID#
            </cfquery>
        </cfloop>
   	<cfelse>     
        <cfloop query="get_old_stock">
            <cfquery name="ADD_METARIAL_CONTROL" datasource="#dsn3#">
                INSERT INTO 
                    EZGI_METARIAL_CONTROL
                    (
                    <cfif isdefined('attributes.lot_no') and len(attributes.lot_no)>
                        LOT_NO, 
                    <cfelseif isdefined('attributes.order_id') and len(attributes.order_id)>
                    	ORDER_ID,
                    </cfif>
                    POR_STOCK_ID, 
                    AMOUNT,
                    PASTAL_CODE,
                    RECORD_EMP, 
                    RECORD_DATE, 
                    RECORD_IP
                    )
                VALUES     
                    (
                    <cfif isdefined('attributes.lot_no') and len(attributes.lot_no)>
                        '#attributes.lot_no#',
                    <cfelseif isdefined('attributes.order_id') and len(attributes.order_id)>
                    	#attributes.order_id#,
                    </cfif>
                    #POR_STOCK_ID#,
                    #evaluate('attributes.old_amount_#POR_STOCK_ID#')#,
                    '#evaluate('attributes.pastal_code_#POR_STOCK_ID#')#',
                    #session.ep.userid#,
                    #now()#,
                    '#CGI.REMOTE_ADDR#'
                    )
            </cfquery>
            <cfset new_amount = NumberFormat((Evaluate('oran_#STOCK_ID#') * amount) + amount,'9.99')>
            <cfquery name="upd_product_orders_stocks" datasource="#dsn3#">
                UPDATE    
                    PRODUCTION_ORDERS_STOCKS
                SET              
                    AMOUNT = #new_amount#
                WHERE     
                    POR_STOCK_ID = #POR_STOCK_ID#
            </cfquery>
        </cfloop>
	</cfif>        
</cftransaction>
<script language="javascript">
	wrk_opener_reload();
	window.close()
</script>