<cfif attributes.gurupla eq 0><!---Gurup Çöz Denmişse--->
 	<cfquery name="upd_group_lot" datasource="#dsn3#">
     	UPDATE PRODUCTION_ORDERS SET IS_GROUP_LOT = 0, GROUP_LOT_NO = NULL WHERE P_ORDER_ID IN (#attributes.p_order_id_list#)
   	</cfquery>
<cfelse><!---Gurupla Denmişse--->
    <cfinclude template="../query/get_ezgi_iflow_production_order.cfm">
    
    <cfif get_production_orders.recordcount>
        <cfquery name="get_group" dbtype="query">
            SELECT
                COUNT(*) AS SAY,
                STOCK_ID
            FROM
                get_production_orders
            GROUP BY
                <cfif attributes.list_type eq 3>
                    LOT_NO,STOCK_ID
                <cfelseif attributes.list_type eq 4>  
                    P_ORDER_PARTI_NUMBER,STOCK_ID
                <cfelseif attributes.list_type eq 5>
                    STOCK_ID
                </cfif>
            HAVING
                COUNT(*) > 1
        </cfquery>
        <cfif get_group.recordcount>
            <cflock timeout="60">
                <cfquery name="get_gen_paper" datasource="#dsn3#">
                    SELECT PRODUCTION_LOT_NUMBER FROM GENERAL_PAPERS WHERE GENERAL_PAPERS_ID = 1
                </cfquery>
                <cfset paper_number = get_gen_paper.PRODUCTION_LOT_NUMBER>
                <cftransaction>
                    <cfloop query="get_group">
                        <cfset paper_number = paper_number +1>
                        <cfquery name="upd_group_lot" datasource="#dsn3#">
                            UPDATE 
                                PRODUCTION_ORDERS 
                            SET 
                                IS_GROUP_LOT = 1, 
                                GROUP_LOT_NO = '#paper_number#' 
                            WHERE 
                                P_ORDER_ID IN (#attributes.p_order_id_list#) AND 
                                STOCK_ID = #get_group.STOCK_ID#
                        </cfquery>
                    </cfloop>
                    <cfquery name="SET_MAX_PAPER" datasource="#dsn3#">
                        UPDATE       
                            GENERAL_PAPERS
                        SET                
                            PRODUCTION_LOT_NUMBER = #paper_number#
                        WHERE        
                            GENERAL_PAPERS_ID = 1
                    </cfquery>
                </cftransaction>
            </cflock>
        </cfif>
    </cfif>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
 	window.close();
</script>