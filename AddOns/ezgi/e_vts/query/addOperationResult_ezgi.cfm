﻿<!---<cfdump expand="yes" var="#attributes#">
<cfabort>--->
<cfparam name="attributes.loss_amount_" default="0">
<cfparam name="attributes.action_start_date_" default="0">
<cfif not isdefined('product_time')>
	<cfset product_time_ = 0>
</cfif>
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
        	<cfif (isdefined('attributes.loss_amount_') and attributes.loss_amount_ neq 0 and not isdefined('attributes.is_operation')) or (isdefined('attributes.realized_amount_') and attributes.realized_amount_ neq 0 and not isdefined('attributes.is_operation'))>
            	<cfquery name="get_result_id" datasource="#dsn3#">
                	SELECT
                    	OPERATION_RESULT_ID,
                        ACTION_START_DATE
                	FROM
                    	PRODUCTION_OPERATION_RESULT
                	WHERE     	
                 		ACTION_EMPLOYEE_ID = #attributes.employee_id_# AND 
                     	STATION_ID = #attributes.station_id_# AND 
                       	OPERATION_ID = #attributes.operation_id_# AND 
                       	REAL_AMOUNT = 0	 AND 
                       	LOSS_AMOUNT = 0	
                </cfquery>
                <cfparam name="attributes.result_id" default="#get_result_id.OPERATION_RESULT_ID#">
                <cfquery name="UPDATE_RESULT" datasource="#dsn3#">
                    UPDATE    
                    	PRODUCTION_OPERATION_RESULT
					SET              
                   		REAL_AMOUNT = <cfif isdefined('attributes.realized_amount_') and len(attributes.realized_amount_)>#attributes.realized_amount_#<cfelse>NULL</cfif>, 
                     	LOSS_AMOUNT = <cfif isdefined('attributes.loss_amount_') and len(attributes.loss_amount_)>#attributes.loss_amount_#<cfelse>NULL</cfif>, 
                      	REAL_TIME = <cfif len(get_result_id.ACTION_START_DATE)>#DateDiff('s',get_result_id.ACTION_START_DATE,now())#<cfelse>NULL</cfif>
                    WHERE  
                    	OPERATION_RESULT_ID = #attributes.result_id# 	
                </cfquery>
                <cfif isdefined('attributes.operation_gurup_id') and attributes.operation_gurup_id gt 0> <!---Guruptaki Operasyonlar Bitmeye Başlamışsa--->
                	<cfquery name="upd_operation_gurup_status" datasource="#dsn3#"> <!---Gurubu Bitiş Flag ına çeviriyoruz--->
                		UPDATE    
                        	EZGI_OPERATION_GRUP_NO
						SET              
                        	IS_RESULT = 1
						WHERE     
                        	OPERATION_GRUP_ID = #attributes.operation_gurup_id#
                	</cfquery>
                   	<cfquery name="upd_operation_gurup_end_id" datasource="#dsn3#"> <!--- Operasyonlar Bittikçe Başlangıç ID sini Bitiş ID sine Çekiyoruz--->
                        UPDATE    
                            PRODUCTION_OPERATION_RESULT
                        SET              
                            OPERATION_GRUP_ID = NULL,
                            OPERATION_GRUP_END_ID = #attributes.operation_gurup_id#
                        WHERE     
                            ACTION_EMPLOYEE_ID = #attributes.employee_id_# AND 
                            REAL_TIME IS NOT NULL AND 
                            OPERATION_ID = #attributes.operation_id_# AND
                            STATION_ID = #attributes.station_id_#
                    </cfquery>
                    <cfquery name="get_start_gurup_time" datasource="#dsn3#"> <!---GUrubun Başlama Zamanını Çekiyoruz--->
                    	SELECT     
                        	OPERATION_START_DATE
						FROM         
                        	EZGI_OPERATION_GRUP_NO
						WHERE     
                        	OPERATION_GRUP_ID = #attributes.operation_gurup_id#
                    </cfquery>
                    <cfset gurup_start_time = get_start_gurup_time.OPERATION_START_DATE>
                    <cfset total_working_gurup_time = Datediff('s',gurup_start_time,now())> <!---Toplam Çalışma Zamanı = Şu An ile Başlama zamanının arasındaki Farkı Hesaplıyoruz--->
                    <cfquery name="get_total_pause_time" datasource="#dsn3#"> <!---Gurubun Toplam Duraklama Zamanını Hesaplıyoruz--->
                    	SELECT     
                        	ISNULL(SUM(SETUP_PROD_PAUSE.PROD_DURATION),0) AS PROD_DURATION
						FROM         
                        	PRODUCTION_OPERATION_RESULT INNER JOIN
                      		SETUP_PROD_PAUSE ON PRODUCTION_OPERATION_RESULT.OPERATION_RESULT_ID = SETUP_PROD_PAUSE.OPERATION_RESULT_ID
						WHERE     
                        	PRODUCTION_OPERATION_RESULT.OPERATION_GRUP_END_ID = #attributes.operation_gurup_id#
                    </cfquery> 
                    <cfset total_prod_pause_time = get_total_pause_time.PROD_DURATION>
                    <cfset net_total_working_gurup_time = total_working_gurup_time - total_prod_pause_time> <!---Net Çalışma Zamanı Hesaplıyoruz--->
                    <cfquery name="get_total_working_amount" datasource="#dsn3#"> <!---Gurubun Toplam Çalışma Miktarını Hesaplıyoruz--->
                    	SELECT     
                        	OPERATION_GRUP_END_ID, 
                            ISNULL(SUM(REAL_AMOUNT),0) AS REAL_AMOUNT
						FROM         
                        	PRODUCTION_OPERATION_RESULT
						WHERE     
                        	ACTION_EMPLOYEE_ID = #attributes.employee_id_# AND 
                            STATION_ID = #attributes.station_id_# AND 
                            OPERATION_GRUP_END_ID = #attributes.operation_gurup_id#
						GROUP BY 
                        	OPERATION_GRUP_END_ID
                    </cfquery>
                    <cfset total_working_amount = get_total_working_amount.REAL_AMOUNT>
                    <cfif net_total_working_gurup_time gt 0 and total_working_amount gt 0> 
                    	<cfset gurup_rate = net_total_working_gurup_time / total_working_amount><!---Bir Üretim Miktarının Süresinin Hesaplanması--->
                  	<cfelse>
                    	<cfset gurup_rate = 0>
                    </cfif>
                    <cfif isdefined('attributes.realized_amount_') and len(attributes.realized_amount_)> 
                        <cfquery name="upd_result_time" datasource="#dsn3#"> <!---Guruba Bağlı Biten Tüm Operasyonlar, Biten Miktarıyla Gurup Katsayısının Çarpımı Gerçekleşen Süreye Güncelleniyor--->
                            UPDATE    
                                PRODUCTION_OPERATION_RESULT
                            SET              
                                REAL_TIME = FLOOR(REAL_AMOUNT*#gurup_rate#)
                            WHERE     
                                OPERATION_GRUP_END_ID = #attributes.operation_gurup_id# AND 
                                STATION_ID = #attributes.station_id_# AND 
                                ACTION_EMPLOYEE_ID = #attributes.employee_id_#
                        </cfquery>
                    </cfif>
                <cfelse>
                	<cfquery name="get_total_pause_time" datasource="#dsn3#"> <!---Operasyonun Toplam Duraklama Zamanını Hesaplıyoruz--->
                    	SELECT     
                        	ISNULL(SUM(PROD_DURATION),0) AS PROD_DURATION
						FROM         
                        	SETUP_PROD_PAUSE
						WHERE     
                        	OPERATION_RESULT_ID = #attributes.result_id#
                    </cfquery> 
                    <cfif get_total_pause_time.recordcount> <!---Eğer Duraklama Varsa Grçekleşen süreden duraklama düşülüyor--->
                    	<cfif get_total_pause_time.PROD_DURATION gt 0>
                            <cfquery name="UPDATE_RESULT" datasource="#dsn3#">
                                UPDATE    
                                    PRODUCTION_OPERATION_RESULT
                                SET              
                                    REAL_TIME = REAL_TIME - #get_total_pause_time.PROD_DURATION#
                                WHERE  
                                    OPERATION_RESULT_ID = #attributes.result_id# 	
                            </cfquery>
                        </cfif>
                    </cfif>
                </cfif>
        	<cfelse>  
            	<cfif isdefined('attributes.operation_gurup_id')> <!---Operasyon Guruplanmış ise--->
                	<cfif attributes.operation_gurup_id eq 0> <!---Guruplanmış İlk Operasyon İse--->
                    	<cfquery name="get_min_action_time" datasource="#dsn3#"> <!---İlk Operasyonun Zamanı Bulunuyor--->
                            SELECT     
                                TOP (1) ACTION_START_DATE
                            FROM         
                                PRODUCTION_OPERATION_RESULT
                            WHERE     
                                ACTION_EMPLOYEE_ID = #attributes.employee_id_# AND 
                                REAL_AMOUNT = 0 AND 
                                STATION_ID = #attributes.station_id_# AND
                                ISNULL(REAL_TIME,0) = 0
                            ORDER BY 
                                ACTION_START_DATE
                        </cfquery>
                        <cfquery name="add_operation_gurup_id" datasource="#dsn3#"> <!---Gurup Açılıyor--->
                            INSERT INTO 
                                EZGI_OPERATION_GRUP_NO
                                (
                                OPERATION_START_DATE, 
                                IS_RESULT
                                )
                            VALUES     
                                (
                                '#get_min_action_time.ACTION_START_DATE#',
                                0
                                )
                        </cfquery>
                        <cfquery name="get_max_operation_gurup_id" datasource="#dsn3#">
                        	SELECT     
                            	TOP (1) OPERATION_GRUP_ID
							FROM         
                            	EZGI_OPERATION_GRUP_NO
							ORDER BY 
                            	OPERATION_GRUP_ID DESC
                        </cfquery>
                        <cfset attributes.operation_gurup_id = get_max_operation_gurup_id.OPERATION_GRUP_ID>
                    </cfif>
                </cfif>   
                <cfquery name="ADD_RESULT" datasource="#dsn3#">
                    INSERT INTO
                        PRODUCTION_OPERATION_RESULT
                    (
                    	<cfif isdefined('attributes.operation_gurup_id') and len(attributes.operation_gurup_id)>
                        	OPERATION_GRUP_ID,
                        </cfif>
                        P_ORDER_ID,
                        OPERATION_ID,
                        STATION_ID,
                        REAL_AMOUNT,
                        LOSS_AMOUNT,
                        REAL_TIME,
                        WAIT_TIME,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        ACTION_EMPLOYEE_ID,
                        ACTION_START_DATE
                    )
                    VALUES
                    (
                    	<cfif isdefined('attributes.operation_gurup_id') and len(attributes.operation_gurup_id)>
                        	#attributes.operation_gurup_id#,
                        </cfif>
                        #attributes.upd_id#,
                        #attributes.operation_id_#,
                        #attributes.station_id_#,
                        <cfif isdefined('attributes.realized_amount_') and len(attributes.realized_amount_)>#attributes.realized_amount_#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.loss_amount_') and len(attributes.loss_amount_)>#attributes.loss_amount_#<cfelse>NULL</cfif>,
                        <cfif isdefined('product_time_') and len(product_time_)>#product_time_#<cfelse>NULL</cfif>,
                        <cfif isdefined('attributes.duration_time_') and len(attributes.duration_time_)>#attributes.duration_time_#<cfelse>NULL</cfif>,
                        #SESSION.EP.USERID#,
                        #NOW()#,
                        '#CGI.REMOTE_ADDR#',
                        <cfif isdefined('attributes.employee_id_') and len(attributes.employee_id_)>#attributes.employee_id_#<cfelse>NULL</cfif>,
                        #NOW()#
                    )
                </cfquery>
                <cfif isdefined('attributes.operation_gurup_id') and len(attributes.operation_gurup_id)> <!---Operayon Guruplu ise--->
                    <cfquery name="upd_operation_gurup_id" datasource="#dsn3#"><!---İlgili Operasyonlaraa Gurup ID si yazılıyor--->
                        UPDATE    
                            PRODUCTION_OPERATION_RESULT
                        SET              
                            OPERATION_GRUP_ID = #attributes.operation_gurup_id#
                        WHERE     
                            ACTION_EMPLOYEE_ID = #attributes.employee_id_# AND 
                            REAL_TIME IS NULL AND 
                            REAL_AMOUNT = 0 AND 
                            STATION_ID = #attributes.station_id_#
                    </cfquery>
                </cfif>
            </cfif> 
            <cfquery name="get_end_operation" datasource="#dsn3#">
                SELECT     
                    P_ORDER_ID, 
                    QUANTITY, 
                    ISNULL(
                            (
                            SELECT     
                                sum(PORR.AMOUNT) AS AMOUNT
                            FROM         
                                PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                                PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                            WHERE     
                                POR.P_ORDER_ID = PO.P_ORDER_ID AND 
                                PORR.TYPE = 1
                            )
                        , 0) AS URETILEN,
                    (
                    SELECT     
                        MIN(REAL_AMOUNT) AS REAL_AMOUNT
                    FROM          
                        (
                        SELECT     
                            ISNULL(
                                    (
                                    SELECT     
                                        SUM(REAL_AMOUNT) * PO.QUANTITY  AS REAL_AMOUNT
                                    FROM         
                                        PRODUCTION_OPERATION_RESULT
                                    WHERE     
                                        OPERATION_ID = POO.P_OPERATION_ID
                                    )
                                , 0) / AMOUNT AS REAL_AMOUNT
                        FROM          
                            PRODUCTION_OPERATION AS POO
                        WHERE      
                            P_ORDER_ID = PO.P_ORDER_ID
                        ) AS TBL1
                    ) AS REAL_OPERATION
                FROM         
                    PRODUCTION_ORDERS AS PO
                WHERE     
                    P_ORDER_ID = #attributes.upd_id#
            </cfquery>
            <cfif get_end_operation.REAL_OPERATION gt get_end_operation.URETILEN>
            	<cfif isdefined('attributes.realized_amount_') and attributes.realized_amount_ gt 0>
                	<cfset AMOUNT = get_end_operation.REAL_OPERATION-get_end_operation.URETILEN>
                    <!---<cfoutput>#get_end_operation.REAL_OPERATION# - #get_end_operation.URETILEN# - #amount#</cfoutput>
                    <cfabort>--->
                	<cfinclude template="add_ezgi_prod_order_result.cfm">
                    <cfif GET_DET_PO.recordcount gt 0>
                    	<cfparam name="attributes.pr_order_id" default="#ADD_PRODUCTION_ORDER.MAX_ID#">
                    	<cfinclude template="add_ezgi_prod_order_result_stock.cfm">
                 	<cfelse>
                        <cf_get_lang_main no='3117.Üretim Emirleri Bulunamamıştır'>.!!!!!
                        <cfabort>
                    </cfif> 
                </cfif>
            </cfif>
            <cfquery name="get_order" datasource="#dsn3#">
                SELECT     	PO.P_ORDER_ID, 
                                PO.OPERATION_TYPE_ID, 
                                PO.AMOUNT, 
                                PO.STAGE,
                                ISNULL((	SELECT     	SUM(REAL_AMOUNT) AS REAL_AMOUNT
                                    		FROM       	PRODUCTION_OPERATION_RESULT
                                    		WHERE     	(OPERATION_ID = PO.P_OPERATION_ID)
                                ),0) REAL_AMOUNT,
                                ISNULL((	SELECT     	SUM(LOSS_AMOUNT) AS LOSS_AMOUNT
                                    		FROM       	PRODUCTION_OPERATION_RESULT
                                    		WHERE     	(OPERATION_ID = PO.P_OPERATION_ID)
                                ),0) LOSS_AMOUNT,
                                PRO.STOCK_ID,
                                PRO.STATION_ID, 
                                PRO.START_DATE, 
                                PRO.FINISH_DATE, 
                                PRO.QUANTITY, 
                                PRO.STATUS, 
                                PRO.P_ORDER_NO, 
                                PRO.PO_RELATED_ID, 
                                PRO.SPECT_VAR_ID, 
                                PRO.PROD_ORDER_STAGE, 
                                PRO.IS_DEMONTAJ, 
                                PRO.DEMAND_NO, 
                                PRO.LOT_NO, 
                                PRO.SPEC_MAIN_ID, 
                                PRO.IS_GROUP_LOT, 
                                PRO.IS_STAGE, 
                                PRO.DETAIL, 
                                PRO.SPECT_VAR_NAME, 
                                PRO.PROJECT_ID,
                                PRO.REFERENCE_NO,
                                PRO.RECORD_DATE,
                                S.PRODUCT_ID, 
                                S.PROPERTY, 
                                S.PRODUCT_NAME, 
                                S.STOCK_CODE, 
                                S.PRODUCT_CATID, 
                                PU.MAIN_UNIT, 
                                O.OPERATION_TYPE, 
                                O.OPERATION_CODE,
                                PO.P_OPERATION_ID,
                                ISNULL((SELECT
                                                SUM(POR_.AMOUNT) ORDER_AMOUNT
                                        FROM
                                                PRODUCTION_ORDER_RESULTS_ROW POR_,
                                                PRODUCTION_ORDER_RESULTS POO
                                        WHERE
                                                POR_.PR_ORDER_ID = POO.PR_ORDER_ID
                                                AND POO.P_ORDER_ID = PO.P_ORDER_ID
                                                AND POR_.TYPE = 1
                                                AND POO.IS_STOCK_FIS = 1
                                        ),0) ROW_RESULT_AMOUNT
                    FROM       	PRODUCTION_OPERATION AS PO INNER JOIN
                                PRODUCTION_ORDERS AS PRO ON PO.P_ORDER_ID = PRO.P_ORDER_ID INNER JOIN
                                STOCKS AS S ON PRO.STOCK_ID = S.STOCK_ID INNER JOIN
                                OPERATION_TYPES AS O ON PO.OPERATION_TYPE_ID = O.OPERATION_TYPE_ID LEFT OUTER JOIN
                                PRODUCT_UNIT AS PU ON S.PRODUCT_ID = PU.PRODUCT_ID
                    WHERE     	(PO.P_OPERATION_ID = #attributes.operation_id_#)
            </cfquery>
            
            <cfset kalan = get_order.AMOUNT - get_order.REAL_AMOUNT>
            <cfquery name="UPD_OPERATION" datasource="#dsn3#">
            	UPDATE  PRODUCTION_OPERATION
				SET     STAGE = <cfif kalan eq 0>3<cfelse>1</cfif>
				WHERE 	(P_OPERATION_ID = #attributes.operation_id_#)
            </cfquery>
	</cftransaction>
</cflock>
<cfif session.ep.our_company_info.is_cost eq 1 and isdefined("attributes.pr_order_id")>

	<cfscript>
    if(isdefined('attributes.is_multi'))
		cost_action(action_type:4,action_id:attributes.pr_order_id,query_type:1,multi_cost_page:1);//çoklu sayfadan geliyorsa her sonuç için ayrı maliyet sayfası açılsın..
	else
		cost_action(action_type:4,action_id:attributes.pr_order_id,query_type:1);
    </cfscript>
</cfif>
<cfif isdefined('attributes.operasyon')>
	<script language="JavaScript">
		window.opener.location.reload();
        window.close();
    </script>
<cfelseif not isdefined('attributes.list_type')>
	<script language="JavaScript">
        window.opener.location.reload();
        window.close();
    </script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=prod.popup_display_ezgi_prod_menu_moduler&type=5&is_form_submitted=1&list_type=#attributes.list_type#&master_plan_id=#attributes.master_plan_id#&sub_plan_id=#attributes.sub_plan_id#" addtoken="No">
</cfif>    