<cfset attributes.process_cat = 110>
<cfif not len(attributes.process_stage)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='3450.Süreç Tanımlarınız Eksiktir'>!");
		window.history.go(-1);
	</script>
    <cfabort>
</cfif>
<cftransaction>
	<cfset attributes.upd_id = attributes.p_order_id>
    <cfset attributes.station_id_ = attributes.station_id>
    <cfset attributes.employee_id_ = session.ep.userid>
    <cfset attributes.realized_amount_ = filterNum(attributes.AMOUNT,2)>
    <cfset get_end_operation.REAL_OPERATION = filterNum(attributes.PRODUCED_AMOUNT,2) + filternum(attributes.AMOUNT,2)>
    <cfset get_end_operation.URETILEN = filterNum(attributes.PRODUCED_AMOUNT,2)>
	<cfinclude template="/AddOns/ezgi/e_vts/query/add_ezgi_prod_order_result.cfm">
    <cfif GET_DET_PO.recordcount gt 0>
     	<cfparam name="attributes.pr_order_id" default="#ADD_PRODUCTION_ORDER.MAX_ID#">
     	<cfinclude template="/AddOns/ezgi/e_vts/query/add_ezgi_prod_order_result_stock.cfm">
  	</cfif>
    <cfquery name="get_stage" datasource="#dsn3#">
    	SELECT IS_STAGE FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = #attributes.upd_id#
    </cfquery>
    <cfquery name="upd_operation_result" datasource="#dsn3#">
    	UPDATE       
        	PRODUCTION_OPERATION
		SET                
        	STAGE = 
				<cfif get_stage.IS_STAGE eq 4 or get_stage.IS_STAGE eq 0>
                	0
				<cfelseif get_stage.IS_STAGE eq 2>
                	3
				<cfelseif get_stage.IS_STAGE eq 1>
                    1
              	</cfif>
		WHERE        
        	P_ORDER_ID = #attributes.upd_id#
    </cfquery>
</cftransaction>
<script type="text/javascript">
		alert("<cf_get_lang_main no='3451.Üretim Sonucu Kaydedilmiştir'>!");
		wrk_opener_reload();
        window.close();
</script>