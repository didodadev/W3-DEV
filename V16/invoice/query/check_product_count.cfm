<cfif listlen(attributes.stcid,',') gt 1>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfoutput>
                <cfloop from="1" to="#listlen(attributes.stcid,',')-1#" index="i">
                    <cfquery name="GET_ORDER_ROW_ID" datasource="#DSN3#">
                        SELECT 
                            ORDER_ROW.STOCK_ID,
                            ORDER_ROW.ORDER_ROW_ID,
                            ORDER_ROW.QUANTITY,
                            ORDER_ROW.PRICE,
                            ORDER_ROW.PRICE_OTHER,
                            ORDER_ROW.TAX,
                            ORDER_ROW.UNIT_ID,
                            ORDER_ROW.PRODUCT_NAME,
                            ORDERS.CONSUMER_ID,
                            ORDER_ROW.WRK_ROW_ID
                        FROM 
                            ORDER_ROW,
                            ORDERS
                        WHERE 
                            ORDER_ROW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.oid#"> AND
                            ORDER_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.stcid,i,',')#"> AND
                            ORDER_ROW.ORDER_ID = ORDERS.ORDER_ID
                    </cfquery>
                    <cfset kalan = listgetat(attributes.remain,i,',')>	
                    <cfloop from="1" to="#get_order_row_id.recordcount#" index="k">
                        <cfquery name="GET_STOCK_ACTION_TYPE" datasource="#DSN3#">
                            SELECT
                                STOCK_ACTION_TYPE
                            FROM
                                STOCK_STRATEGY,
                                SETUP_SALEABLE_STOCK_ACTION
                            WHERE				
                                STOCK_STRATEGY.STOCK_ACTION_ID = SETUP_SALEABLE_STOCK_ACTION.STOCK_ACTION_ID AND
                                STOCK_STRATEGY.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row_id.stock_id#">
                        </cfquery>
                        <cfif kalan gte get_order_row_id.quantity[k]>
                            <cfquery name="DEL_ROW" datasource="#DSN3#">  
                                DELETE FROM ORDER_ROW WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row_id.order_row_id[k]#">
                            </cfquery>	
                            <cfquery name="DEL_ROW_RESERVED" datasource="#DSN3#">  
                                DELETE FROM ORDER_ROW_RESERVED WHERE ORDER_WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order_row_id.wrk_row_id[k]#">
                            </cfquery>						
                            <cfquery name="INS_BCK_ORDER" datasource="#DSN3#">  
                                INSERT INTO
                                    ORDER_DEMANDS
                                (
                                    DEMAND_STATUS,
                                    STOCK_ID,
                                    DEMAND_TYPE,
                                    PRICE,
                                    PRICE_KDV,
                                    PRICE_MONEY,
                                    DEMAND_AMOUNT,
                                    GIVEN_AMOUNT,
                                    DEMAND_UNIT_ID,
                                    <!---DOMAIN_NAME,--->
                                    MENU_ID,
                                    STOCK_ACTION_TYPE,
                                    DEMAND_NOTE,
                                    RECORD_CON,
                                    RECORD_PAR,
                                    RECORD_EMP,
                                    RECORD_DATE,
                                    RECORD_IP				
                                )
                                VALUES
                                (
                                    1,
                                    #get_order_row_id.stock_id[k]#,
                                    3,
                                    #get_order_row_id.price[k]#,
                                    #wrk_round((get_order_row_id.price[k]*((100+get_order_row_id.tax[k])/100)),4)#,
                                    '#session.ep.money#',
                                     #get_order_row_id.quantity[k]#,
                                    0,
                                    #get_order_row_id.unit_id[k]#,
                                    <!---'#cgi.http_host#',--->
                                    #session.ep.menu_id#,
                                    <cfif get_stock_action_type.recordcount and len(get_stock_action_type.stock_action_type)>#get_stock_action_type.stock_action_type#<cfelse>NULL</cfif>,
                                    '#get_order_row_id.product_name[k]#',
                                    #get_order_row_id.consumer_id[k]#,
                                    NULL,
                                    #session.ep.userid#,
                                    #now()#,
                                    '#cgi.remote_addr#'
                                )
                            </cfquery>
                            <cfset kalan = kalan - get_order_row_id.quantity[k]>
                        <cfelseif kalan lt get_order_row_id.quantity[k] and kalan neq 0>
                            <cfquery name="UPD_ORDER_ROW" datasource="#DSN3#">  <!--- Sepet şablonu değişirse buraya kolonları eklemek gerekir!! ---> 
                                UPDATE 
                                    ORDER_ROW				
                                SET
                                    QUANTITY = #(get_order_row_id.quantity[k]-kalan)#,
                                    NETTOTAL = #(get_order_row_id.price[k]*(get_order_row_id.quantity[k]-kalan))#,
                                    OTHER_MONEY_VALUE = #(get_order_row_id.price_other[k]*(get_order_row_id.quantity[k]-kalan))#
                                WHERE
                                    ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row_id.order_row_id[k]#">
                            </cfquery>
                            <cfquery name="UPD_ORDER_ROW_RESERVE" datasource="#DSN3#">  <!--- Sepet şablonu değişirse buraya kolonları eklemek gerekir!! ---> 
                                UPDATE 
                                    ORDER_ROW_RESERVED				
                                SET
                                    RESERVE_STOCK_OUT = #(get_order_row_id.quantity[k]-kalan)#
                                WHERE
                                    ORDER_WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_order_row_id.wrk_row_id[k]#">
                            </cfquery>
                            <cfquery name="INS_BCK_ORDER" datasource="#DSN3#">  
                                INSERT INTO
                                    ORDER_DEMANDS
                                (
                                    DEMAND_STATUS,
                                    STOCK_ID,
                                    DEMAND_TYPE,
                                    PRICE,
                                    PRICE_KDV,
                                    PRICE_MONEY,
                                    DEMAND_AMOUNT,
                                    GIVEN_AMOUNT,
                                    DEMAND_UNIT_ID,
                                    <!---DOMAIN_NAME,--->
                                    MENU_ID,
                                    STOCK_ACTION_TYPE,
                                    DEMAND_NOTE,
                                    RECORD_CON,
                                    RECORD_PAR,
                                    RECORD_EMP,
                                    RECORD_DATE,
                                    RECORD_IP				
                                )
                                VALUES
                                (
                                    1,
                                    #get_order_row_id.stock_id[k]#,
                                    3,
                                    #get_order_row_id.price[k]#,
                                    #wrk_round((get_order_row_id.price[k]*((100+get_order_row_id.tax[k])/100)),4)#,
                                    '#session.ep.money#',
                                     #kalan#,
                                    0,
                                    #get_order_row_id.unit_id[k]#,
                                    <!---'#cgi.http_host#',--->
                                    #session.ep.menu_id#,
                                    <cfif get_stock_action_type.recordcount and len(get_stock_action_type.stock_action_type)>#get_stock_action_type.stock_action_type#<cfelse>NULL</cfif>,
                                    '#get_order_row_id.product_name[k]#',
                                    #get_order_row_id.consumer_id[k]#,
                                    NULL,
                                    #session.ep.userid#,
                                    #now()#,
                                    '#cgi.remote_addr#'
                                )
                            </cfquery>  
                            <cfbreak>
                        </cfif>
                    </cfloop>
                </cfloop>
                <cfquery name="UPD_ORDER_1" datasource="#DSN3#">
                    UPDATE 
                        ORDERS 
                    SET 
                        ORDERS.TAXTOTAL = (SELECT SUM(ORDER_ROW.NETTOTAL * (ORDER_ROW.TAX/100)) FROM ORDER_ROW WHERE ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID GROUP BY ORDER_ID)
                    WHERE
                        ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.oid#">
                </cfquery>
                <cfquery name="GET_ROW_TOTAL" datasource="#DSN3#">
                    SELECT SUM(NETTOTAL) LAST_TOTAL,SUM(OTHER_MONEY_VALUE) LAST_TOTAL_OTHER FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.oid#">
                </cfquery>
                <cfquery name="UPD_ORDER_LAST_1" datasource="#DSN3#">
                    UPDATE 
                        ORDERS 
                    SET 
                        OTHER_MONEY_VALUE = #get_row_total.LAST_TOTAL_OTHER#,
                        GROSSTOTAL = #get_row_total.LAST_TOTAL#
                    WHERE
                        ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.oid#">
                </cfquery>
                <cfquery name="UPD_ORDER_LAST_2" datasource="#DSN3#">
                    UPDATE 
                        ORDERS 
                    SET 
                        NETTOTAL = GROSSTOTAL+TAXTOTAL
                    WHERE
                        ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.oid#">
                </cfquery>
            </cfoutput>
		</cftransaction>
	</cflock>
</cfif> 
<script type="text/javascript">
	opener.location.href='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&order_id=#attributes.oid#&barkod=1</cfoutput>';
	window.close();
</script> 
