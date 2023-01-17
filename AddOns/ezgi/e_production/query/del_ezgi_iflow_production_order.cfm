<cflock name="#CREATEUUID()#" timeout="90">
    <cftransaction>
    	<cfquery name="GET_CONTROL" datasource="#DSN3#">
        	SELECT        
          		PO.P_ORDER_ID
          	FROM            
            	EZGI_IFLOW_PRODUCTION_ORDERS AS E INNER JOIN
             	PRODUCTION_ORDERS AS PO ON E.LOT_NO = PO.LOT_NO
          	WHERE        
             	E.REL_P_ORDER_ID= #attributes.rel_p_order_id#
      	</cfquery>
		<cfset p_order_id_list = ValueList(GET_CONTROL.P_ORDER_ID)>
        <cfif ListLen(p_order_id_list)>
            <cfquery name="GET_RELATED_PRODUCTION_RESULT" datasource="#dsn3#">
                SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE P_ORDER_ID IN (#p_order_id_list#)
            </cfquery>
            <cfif GET_RELATED_PRODUCTION_RESULT.recordcount>
                <script type="text/javascript">
                    alert("<cf_get_lang no ='633.Bu Üretim Emrinin İlişkili Olduğu Üretimlerden Sonuç Girilenler Var,Öncelikle İlişkili Üretim Emirlerinin Sonuçlarını Siliniz'>!");
                    history.go(-1);
                </script>
                <cfabort>
            </cfif>
            <cfquery name="DEL_ROW" datasource="#dsn3#">
                DELETE FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDER_ID IN(#p_order_id_list#)
            </cfquery>        
            <cfquery name="DEL_PROD_ORDER" datasource="#dsn3#">
                DELETE FROM PRODUCTION_OPERATION WHERE P_ORDER_ID IN(#p_order_id_list#)
            </cfquery>
            <cfquery name="DEL_PROD_ORDER" datasource="#dsn3#">
                DELETE FROM PRODUCTION_ORDERS WHERE P_ORDER_ID IN(#p_order_id_list#)
            </cfquery>
            <cfquery name="DEL_PROD_ORDER_STOCKS" datasource="#dsn3#">
                DELETE FROM PRODUCTION_ORDERS_STOCKS WHERE P_ORDER_ID IN(#p_order_id_list#)
            </cfquery>
       	</cfif>
    	<cfquery name="del_operations" datasource="#dsn3#">
        	DELETE 
            	EZGI_IFLOW_PRODUCTION_OPERATION
			WHERE        
            	IFLOW_P_ORDER_ID IN
                           	(
                            	SELECT        
                                	IFLOW_P_ORDER_ID
                               	FROM            
                                	EZGI_IFLOW_PRODUCTION_ORDERS
                               	WHERE        
                                	REL_P_ORDER_ID = #attributes.rel_p_order_id#
                         	)
        </cfquery>
     	<cfquery name="del_p_order_row" datasource="#dsn3#">
          	DELETE 
            	EZGI_IFLOW_PRODUCTION_ORDERS 
           	WHERE 
            	REL_P_ORDER_ID = #attributes.rel_p_order_id#
    	</cfquery>
        <cfquery name="del_p_order_row" datasource="#dsn3#">
          	DELETE 
            	EZGI_IFLOW_PRODUCTION_ORDERS_PARTI
           	WHERE 
            	P_ORDER_PARTI_ID = #attributes.rel_p_order_id#
    	</cfquery>
    </cftransaction>
</cflock>
<cfinclude template="upd_ezgi_iflow_master_plan_operation.cfm">
<script type="text/javascript">
 	alert('<cf_get_lang_main no='3457.Parti Tamamen Silinmiştir'>!');
   	wrk_opener_reload();
  	window.close();
</script>
