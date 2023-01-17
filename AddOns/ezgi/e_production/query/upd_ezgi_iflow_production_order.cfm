<cfquery name="get_process_type" datasource="#dsn#">
	SELECT        
    	TOP (1) PR.PROCESS_ROW_ID
	FROM          
    	PROCESS_TYPE AS P INNER JOIN
     	PROCESS_TYPE_ROWS AS PR ON P.PROCESS_ID = PR.PROCESS_ID INNER JOIN
      	PROCESS_TYPE_OUR_COMPANY AS PC ON PR.PROCESS_ID = PC.PROCESS_ID
	WHERE        
    	P.FACTION LIKE N'%prod.add_prod_order,%' AND 
        PC.OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfif not get_process_type.recordcount>
	<script type="text/javascript">
		alert('<cf_get_lang_main no='3448.Üretim Emri Kaydetmek İçin Süreçte Yetkili Olmalısınız'>!');
        window.history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfset attributes.iid = ''>
<cf_date tarih="attributes.p_order_date">
<!---<cflock name="#CREATEUUID()#" timeout="90">
    <cftransaction>--->
    	<cfquery name="upd_parti" datasource="#dsn3#">
        	UPDATE EZGI_IFLOW_PRODUCTION_ORDERS_PARTI SET P_ORDER_PARTI_DETAIL ='#attributes.detail#' WHERE P_ORDER_PARTI_ID = #attributes.rel_p_order_id#
        </cfquery>
        <cfif attributes.record_num gt 0>
        	<cfquery name="get_upd_info" datasource="#dsn3#">
            	SELECT IFLOW_P_ORDER_ID, MASTER_PLAN_ID, QUANTITY FROM EZGI_IFLOW_PRODUCTION_ORDERS WHERE IFLOW_P_ORDER_ID IN (#attributes.iflow_p_order_id_list#)
            </cfquery>
            <cfoutput query="get_upd_info">
            	<cfset 'QUANTITY_#IFLOW_P_ORDER_ID#' = QUANTITY>
                <cfset 'MASTER_PLAN_ID_#IFLOW_P_ORDER_ID#' = MASTER_PLAN_ID>
            </cfoutput>
            <cfquery name="get_max_sira_no" datasource="#dsn3#">
            	SELECT 
                	TOP (1) ISNULL(DP_ORDER_ID,0) AS DP_ORDER_ID 
               	FROM 
                	EZGI_IFLOW_PRODUCTION_ORDERS 
              	<cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
                  	WHERE              	
                    	MASTER_PLAN_ID = #attributes.master_plan_id#
              	</cfif>
               	ORDER BY 
                	DP_ORDER_ID DESC
            </cfquery>
            <cfif get_max_sira_no.recordcount>
            	<cfset sirano = get_max_sira_no.DP_ORDER_ID>
            <cfelse>
            	<cfset sirano = 0>
            </cfif>
            <cfloop from="1" to="#attributes.record_num#" index="i">
            	<cfquery name="get_gen_paper" datasource="#dsn3#">
                    SELECT PRODUCTION_LOT_NUMBER FROM GENERAL_PAPERS WHERE GENERAL_PAPERS_ID = 1
                </cfquery>
                <cfset paper_number = get_gen_paper.PRODUCTION_LOT_NUMBER>
                <cfif isdefined('row_kontrol#i#') and Evaluate('row_kontrol#i#') gt 0> <!---Satır Yeni Eklnmişse--->
                	<cfif ListLen(attributes.iflow_p_order_id_list) lt i>
                        <cfset sirano = sirano + 1>
                        <cfset paper_number = paper_number +1>
						<cfset paper_full = '#paper_number#'>
                    	<cfquery name="add_p_order_row" datasource="#dsn3#">
                        	INSERT INTO   
                                EZGI_IFLOW_PRODUCTION_ORDERS
                                (
                                    <cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
                                        MASTER_PLAN_ID,
                                    </cfif>
                                    REL_P_ORDER_ID,
                                    PRODUCT_TYPE, 
                                    STOCK_ID, 
                                    QUANTITY, 
                                    DETAIL, 
                                    PROD_ORDER_STAGE, 
                                    LOT_NO, 
                                    PLANNING_DATE,
                                    DP_ORDER_ID,
                                    ACTION_TYPE,
									<cfif Evaluate('attributes.action_type#i#') lte 1>
                                        ACTION_ID,
                                    <cfelseif Evaluate('attributes.action_type#i#') eq 2>
                                        ORDER_ROW_ID,
                                    </cfif>
                                    SPECT_MAIN_ID,
                                    RECORD_IP, 
                                    RECORD_EMP, 
                                    RECORD_DATE
                               )
                            VALUES        
                                (
                                    <cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
                                        #attributes.master_plan_id#,
                                    </cfif>
                                    #attributes.rel_p_order_id#,
                                    #Evaluate('attributes.type#i#')#,
                                    #Evaluate('attributes.stock_id#i#')#,
                                    #FilterNum(Evaluate('attributes.quantity#i#'),2)#,
                                    '#Evaluate('attributes.detail#i#')#',
                                    #attributes.process_stage#,
                                    #paper_full#,
                                    #attributes.p_order_date#,
                                    #sirano#,
                                    #Evaluate('attributes.action_type#i#')#,
                                    #Evaluate('attributes.action_id#i#')#,
                                    <cfif len(Evaluate('attributes.spect_main_id#i#')) and Evaluate('attributes.spect_main_id#i#') gt 0>
                                        #Evaluate('attributes.spect_main_id#i#')#,
                                    <cfelse>
                                        NULL,
                                    </cfif>
                                    '#cgi.remote_addr#',
                                    #session.ep.userid#,
                                    #now()#
                             	)
                        </cfquery>
                        <cfquery name="SET_MAX_PAPER" datasource="#dsn3#">
                            UPDATE       
                                GENERAL_PAPERS
                            SET                
                                PRODUCTION_LOT_NUMBER = #paper_number#
                            WHERE        
                                GENERAL_PAPERS_ID = 1
                        </cfquery>
                        <cfquery name="get_iflow_max_id" datasource="#dsn3#">
                            SELECT MAX(IFLOW_P_ORDER_ID) AS IFLOW_P_ORDER_ID FROM EZGI_IFLOW_PRODUCTION_ORDERS
                        </cfquery>
                        <cfset attributes.iid = ListAppend(attributes.iid,get_iflow_max_id.IFLOW_P_ORDER_ID)>
                    <cfelse>
                        <cfquery name="upd_p_order_row" datasource="#dsn3#"> <!---Satırda Bilgiler Değişmişse--->
                            UPDATE   
                                EZGI_IFLOW_PRODUCTION_ORDERS
                            SET
                                DETAIL = '#Evaluate('attributes.detail#i#')#', 
                                UPDATE_IP = '#cgi.remote_addr#', 
                                UPDATE_EMP = #session.ep.userid#, 
                                UPDATE_DATE = #now()#
                            WHERE 
                                IFLOW_P_ORDER_ID = #ListGetAt(attributes.iflow_p_order_id_list,i)#   
                        </cfquery>
                   	</cfif>
                <cfelse> <!---Satır Silinmişse--->
                	<cfquery name="GET_CONTROL" datasource="#DSN3#">
                        SELECT        
                            PO.P_ORDER_ID
                        FROM            
                            EZGI_IFLOW_PRODUCTION_ORDERS AS E INNER JOIN
                            PRODUCTION_ORDERS AS PO ON E.LOT_NO = PO.LOT_NO
                        WHERE        
                            E.MASTER_PLAN_ID = #attributes.master_plan_id# AND
                           	E.IFLOW_P_ORDER_ID = #ListGetAt(attributes.iflow_p_order_id_list,i)#
                    </cfquery>
                    <cfset p_order_id_list = ValueList(GET_CONTROL.P_ORDER_ID)>
                    <cfif ListLen(p_order_id_list)>
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
                    <cfquery name="del_p_operation_row" datasource="#dsn3#">
                    	DELETE FROM EZGI_IFLOW_PRODUCTION_OPERATION WHERE IFLOW_P_ORDER_ID = #ListGetAt(attributes.iflow_p_order_id_list,i)#
                    </cfquery>
                	<cfquery name="del_p_order_row" datasource="#dsn3#">
                    	DELETE FROM EZGI_IFLOW_PRODUCTION_ORDERS WHERE IFLOW_P_ORDER_ID = #ListGetAt(attributes.iflow_p_order_id_list,i)#
                    </cfquery>
                    <cfinclude template="upd_ezgi_iflow_master_plan_operation.cfm">
                </cfif>
            </cfloop>
        </cfif>
        <cfif len(attributes.iid)>
        	<cfset attributes.iflow_master_plan_id = attributes.master_plan_id>
         	<cfinclude template="upd_ezgi_iflow_master_plan_operation.cfm"> <!---Operasyon Planları Oluşturuluyor--->
         	<cfinclude template="add_ezgi_production_order_from_iflow_master.cfm"> <!---İş Emirleri Oluşturuluyor--->
        </cfif>
    <!---</cftransaction>
</cflock>--->

<cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
	<script type="text/javascript">
        wrk_opener_reload();
        window.close();
	</script>
<cfelse>
	<cfif isdefined('iflow_p_order_id_')>
        <cflocation url="#request.self#?fuseaction=prod.upd_ezgi_iflow_production_order&iflow_p_order_id=#iflow_p_order_id_#" addtoken="No">
    <cfelse>
        <cflocation url="#request.self#?fuseaction=prod.list_ezgi_iflow_production_order" addtoken="No">
    </cfif>
</cfif>