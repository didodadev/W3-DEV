<!--- zaman harcaması, seri no --->
<cfset attributes.process_type_111 = process_type_111>
<cfset attributes.process_type_112 = process_type_112>
<cfset attributes.process_type_81 = process_type_81>
<cfset attributes.process_type_110 = process_type_110>
<cfset attributes.process_type_119 = process_type_119>
<cfquery name="get_prod_result" datasource="#dsn3#">
	SELECT 
		POR.P_ORDER_ID,
		POR.RESULT_NO,
		PORR.STOCK_ID,
		(SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = POR.PROCESS_ID) PROCESS_CAT
	FROM
		PRODUCTION_ORDER_RESULTS POR,
		PRODUCTION_ORDER_RESULTS_ROW PORR
	WHERE
		POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
		POR.PR_ORDER_ID = #attributes.pr_order_id# AND
		PORR.TYPE = 1
</cfquery>
<cfquery name="GET_DETAIL" datasource="#DSN3#">
	SELECT 
    	PRODUCTION_ORDERS.PROJECT_ID,
		PRODUCTION_ORDERS.P_ORDER_NO,
		PRODUCTION_ORDERS.ORDER_ID,
		PRODUCTION_ORDERS.IS_DEMONTAJ,
		PRODUCTION_ORDERS.FINISH_DATE,
		PRODUCTION_ORDERS.QUANTITY AS AMOUNT,
		PRODUCTION_ORDER_RESULTS.*
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS
	WHERE
		PRODUCTION_ORDERS.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id_list#">  AND 
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
		PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID
</cfquery>
<cfquery name="get_operations" datasource="#dsn3#">
	SELECT 
		DATEDIFF(minute,OPERATION_DATE,(SELECT TOP 1 POO.OPERATION_DATE FROM PRODUCTION_ORDER_OPERATIONS POO WHERE POO.P_ORDER_ID = #attributes.p_order_id_list# AND POO.WRK_ROW_ID = '#attributes.wrk_row_id#' ORDER BY POO.RECORD_DATE DESC)) TOTAL_TIME,
		OPERATION_DATE,
		P_ORDER_ID,
		POR_OPERATION_ID,
		PAUSE_TYPE,
		TYPE,
		ASSET_ID,
		SERIAL_NO
	FROM
		PRODUCTION_ORDER_OPERATIONS
	WHERE
		P_ORDER_ID = #attributes.p_order_id_list# AND
		WRK_ROW_ID = '#attributes.wrk_row_id#'
	ORDER BY 
		OPERATION_DATE DESC
</cfquery>
<cfquery name="get_process_stage" datasource="#dsn#" maxrows="1">
	SELECT
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.time_cost%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif len(get_operations.asset_id)>
	<cfquery name="add_assetp_relation_prod_result" datasource="#dsn#">
		INSERT INTO	
			ASSET_P_RESERVE 
		(
			PROD_RESULT_ID,
			ASSETP_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			#attributes.pr_order_id#,
			#get_operations.asset_id#,
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
		) 
	</cfquery>
</cfif>
<cfif isdefined("get_operations.serial_no") and len(get_operations.serial_no)>
	<cfset wrk_id = '#get_operations.serial_no#' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
	<cfquery name="add_serial_no" datasource="#dsn3#">
		INSERT INTO
			SERVICE_GUARANTY_NEW
		(
			STOCK_ID,
			SERIAL_NO,
			IN_OUT,
			IS_PURCHASE,
			IS_SALE,
			IS_RETURN,
			IS_RMA,
			IS_SERVICE,
			PROCESS_CAT,
			PROCESS_ID,
			PROCESS_NO,
			DEPARTMENT_ID,
			LOCATION_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			PERIOD_ID,
			IS_SARF,
			IS_SERI_SONU,
			WRK_ID,
			PURCHASE_GUARANTY_CATID
		)
		VALUES
		(
			#get_prod_result.stock_id#,
			'#get_operations.serial_no#',
			1,
			0,
			0,
			0,
			0,
			0,
			#get_prod_result.process_cat#,
			#attributes.pr_order_id#,
			'#get_prod_result.result_no#',
			<cfif len(attributes.exit_department_id)>#attributes.exit_department_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.exit_location_id)>#attributes.exit_location_id#<cfelse>NULL</cfif>,
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#session.ep.period_id#,
			0,
			0,
			'#wrk_id#',
			1
		)
	</cfquery>
</cfif>
<cfquery name="get_totaltime" dbtype="query" maxrows="1">
	SELECT TOTAL_TIME FROM get_operations ORDER BY OPERATION_DATE
</cfquery>
<!--- Zaman Harcaması Hesaplaması --->
<cfset tot_pause_duration = 0>
<cfloop query="get_operations">
	<cfif type[currentrow] eq 1 and type[currentrow+1] eq 0>
		<cfset operation_date_1 = createodbcdatetime(OPERATION_DATE[currentrow])>
		<cfset operation_date_2 = createodbcdatetime(OPERATION_DATE[currentrow+1])>
		<cfset duration = datediff("n",operation_date_2,operation_date_1)>
		<cfset tot_pause_duration = tot_pause_duration + duration>
	</cfif>
    <cfquery name="get_hourly_salary" datasource="#dsn#">
        SELECT ON_MALIYET,ON_HOUR,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IN  (SELECT EMPLOYEE_ID FROM #dsn3_alias#.PRODUCTION_ORDER_OPERATIONS_EMPLOYEE WHERE OPERATION_ID = #get_operations.POR_OPERATION_ID#) AND IS_MASTER = 1
    </cfquery>
    <cfif get_hourly_salary.recordcount>
        <cfloop query="get_hourly_salary">
             <cfif not len(get_hourly_salary.ON_MALIYET) or not len(get_hourly_salary.ON_HOUR)>
                <script type="text/javascript">
                    alert("<cf_get_lang no='74.İnsan Kaynakları Bölümü Pozisyon Çalışma Maliyetinizi Belirtilmemiş'>!");
                    history.back();
                </script>
                <cfabort>
            <cfelse>
                <cfset salary_minute = get_hourly_salary.ON_MALIYET/get_hourly_salary.ON_HOUR/60>
            </cfif>
            <cfif not len(get_hourly_salary.ON_HOUR)>
                <script type="text/javascript">
                    alert("<cf_get_lang no='75.Lütfen SSK Aylık İş Saatlerini Düzenleyin'>!");
                    history.back();
                </script>
                <cfabort>
            </cfif>
            <cfset degerim = 1> 
            <cfset para=wrk_round(salary_minute*get_totaltime.TOTAL_TIME*degerim)>
            <cfquery name="add_time_cost" datasource="#dsn#">
                INSERT INTO
                    TIME_COST
                (
                    OUR_COMPANY_ID,
                    P_ORDER_RESULT_ID,
                    TOTAL_TIME,
                    EXPENSED_MONEY,
                    EXPENSED_MINUTE,
                    EMPLOYEE_ID,
                    EVENT_DATE,
                    STATE,
                    TIME_COST_STAGE,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                    VALUES
                (
                    #session.ep.company_id#,
                    #attributes.pr_order_id#,
                    #wrk_round((get_totaltime.TOTAL_TIME - tot_pause_duration)/60)#,
                    #PARA#,
                    #get_totaltime.TOTAL_TIME - tot_pause_duration#,
                    #GET_HOURLY_SALARY.employee_id#,
                    #now()#,
                    1,
                    <cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#'
                )
            </cfquery>
        </cfloop>
    </cfif>
    <!--- Zaman Harcaması Hesaplaması --->
</cfloop>
<!--- Üretim Sonucu Duraklamaları Kaydediliyor --->
<cfoutput query="get_operations">
	<cfif len(PAUSE_TYPE)>
		<cfquery name="add_prod_pause" datasource="#dsn3#">
			INSERT INTO 
				SETUP_PROD_PAUSE
				(  
					PROD_PAUSE_TYPE_ID,
					PROD_DURATION,
					PR_ORDER_ID,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP,
					ACTION_DATE			
				)
				VALUES     
				(
					#GET_OPERATIONS.PAUSE_TYPE#, 
					#datediff('n',GET_OPERATIONS.OPERATION_DATE[currentrow],GET_OPERATIONS.OPERATION_DATE[currentrow-1])#, 
					#attributes.pr_order_id#,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#createodbcdatetime(get_detail.finish_date)#		 
				)
		</cfquery>
	</cfif>
</cfoutput>
<!--- Üretim Sonucu Duraklamaları Kaydediliyor --->
<!--- OPERASYON SATIR BİLGİSİ ÜRETİM EMRİ OLUŞTURURKEN OPERASYON SEÇİLİ İSE OPERASYONDA EKLİ OLAN SATIRLARIN BİLGİSİNİ ÜRETİ SONUCUNDA ZAMAN HARCAMASI,DURAKLAMALARA ATAR --->
<cfquery name="get_operation_row" datasource="#dsn3#">
	SELECT 
		DATEDIFF(minute,OPERATION_DATE,(SELECT TOP 1 POR_.OPERATION_DATE FROM P_ORDER_OPERATIONS_ROW POR_ WHERE POR_.P_ORDER_ID = #attributes.p_order_id_list# AND POR_.WRK_ROW_RELATION_ID = '#attributes.wrk_row_id#' ORDER BY POR_.RECORD_DATE DESC)) TOTAL_TIME,
		OPERATION_DATE,
		P_ORDER_ID,
		PAUSE_TYPE,
		OPERATION_TYPE_ID,
		TYPE,
		ASSET_ID,
		QUANTITY,
		WRK_ROW_ID
	FROM
		P_ORDER_OPERATIONS_ROW
	WHERE
		P_ORDER_ID = #attributes.p_order_id_list# AND
		WRK_ROW_RELATION_ID = '#attributes.wrk_row_id#'
	ORDER BY 
		OPERATION_DATE DESC
</cfquery>
<cfif get_operation_row.recordcount>
	<cfoutput query="get_operation_row">
		<cfset wrk_id_list = listdeleteduplicates(ValueList(get_operation_row.WRK_ROW_ID))>
	</cfoutput>
	<cfloop list="#wrk_id_list#" index="ww">
		<cfquery name="get_operation_row__" datasource="#dsn3#">
			SELECT 
				DATEDIFF(minute,OPERATION_DATE,(SELECT TOP 1 POR_.OPERATION_DATE FROM P_ORDER_OPERATIONS_ROW POR_ WHERE POR_.P_ORDER_ID = #attributes.p_order_id_list# AND POR_.WRK_ROW_ID = '#ww#' ORDER BY POR_.RECORD_DATE DESC)) TOTAL_TIME,
				OPERATION_DATE,
				P_ORDER_ID,
				PAUSE_TYPE,
				OPERATION_TYPE_ID,
				P_OPERATION_ID,
				(SELECT TOP 1 OPERATION_TYPE FROM OPERATION_TYPES OT WHERE OT.OPERATION_TYPE_ID = P_ORDER_OPERATIONS_ROW.OPERATION_TYPE_ID) OPERATION_TYPE,
				TYPE,
				ASSET_ID,
				QUANTITY,
				WRK_ROW_ID
			FROM
				P_ORDER_OPERATIONS_ROW
			WHERE
				WRK_ROW_ID = '#ww#'
			ORDER BY 
				OPERATION_DATE DESC
		</cfquery>
		<!--- fiziki varlıklar --->
		<cfif len(get_operation_row__.asset_id[1])>
			<cfquery name="add_assetp_relation_prod_result_" datasource="#dsn#">
				INSERT INTO	
					ASSET_P_RESERVE 
				(
					PROD_RESULT_ID,
					ASSETP_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
				VALUES
				(
					#attributes.pr_order_id#,
					#get_operation_row__.asset_id[1]#,
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#'
				) 
			</cfquery>		
		</cfif>
		<cfset tot_pause_duration_ = 0><!--- duraklama ve zaman harcamalarını hesaplıyor --->
		<cfloop query="get_operation_row__">
			<cfif type[currentrow] eq 1 and type[currentrow+1] eq 0>
				<cfset operation_date_1_ = createodbcdatetime(OPERATION_DATE[currentrow])>
				<cfset operation_date_2_ = createodbcdatetime(OPERATION_DATE[currentrow+1])>
				<cfset duration_ = datediff("n",operation_date_2_,operation_date_1_)>
				<cfset tot_pause_duration_ = tot_pause_duration_ + duration_>
			</cfif>
		</cfloop>
		<cfset last_total_time_ = get_operation_row__.TOTAL_TIME[get_operation_row__.recordcount]>
		<cfset para_ = wrk_round(salary_minute*get_operation_row__.TOTAL_TIME[get_operation_row__.recordcount]*degerim)>
		<cfset expense_time = last_total_time_ -tot_pause_duration_>
		<cfoutput query="get_operation_row__">
			<cfif len(get_operation_row__.PAUSE_TYPE)>
				<cfquery name="add_prod_pause" datasource="#dsn3#">
					INSERT INTO 
						SETUP_PROD_PAUSE
						(  
							PROD_PAUSE_TYPE_ID,
							PROD_DURATION,
							PR_ORDER_ID,
							RECORD_DATE,
							RECORD_IP,
							RECORD_EMP,
							ACTION_DATE,
							PROD_DETAIL			
						)
						VALUES     
						(
							#get_operation_row__.PAUSE_TYPE#, 
							#datediff('n',get_operation_row__.OPERATION_DATE[currentrow],get_operation_row__.OPERATION_DATE[currentrow-1])#, 
							#attributes.pr_order_id#,
							#now()#,
							'#cgi.remote_addr#',
							#session.ep.userid#,
							#createodbcdatetime(get_detail.finish_date)#,
							'#OPERATION_TYPE#'
						)
				</cfquery>
			</cfif>
            <!--- Zaman Harcaması Hesaplaması --->
            <cfquery name="get_emps" datasource="#dsn3#">
            	SELECT EMPLOYEE_ID FROM PRODUCTION_ORDER_OPERATIONS_EMPLOYEE WHERE OPERATION_ID = #get_operations.POR_OPERATION_ID#
            </cfquery>
            <cfif get_emps.recordcount>
            <cfquery name="add_time_cost" datasource="#dsn#">
                <cfloop query="get_emps">
                    INSERT INTO
                        TIME_COST
                    (
                        OUR_COMPANY_ID,
                        P_ORDER_RESULT_ID,
                        TOTAL_TIME,
                        EXPENSED_MONEY,
                        EXPENSED_MINUTE,
                        EMPLOYEE_ID,
                        EVENT_DATE,
                        STATE,
                        TIME_COST_STAGE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                        VALUES
                    (
                        #session.ep.company_id#,
                        #attributes.pr_order_id#,
                        #wrk_round(expense_time/60)#,
                        #para_#,
                        #expense_time#,
                        #get_emps.employee_id#,
                        #now()#,
                        1,
                        <cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>,
                        #now()#,
                        #session.ep.userid#,
                        '#cgi.remote_addr#'
                    )
                </cfloop>
            </cfquery>
            </cfif>
		</cfoutput>
		<cfquery name="add_operation_result" datasource="#dsn3#">
			INSERT INTO
				PRODUCTION_OPERATION_RESULT
			(
				P_ORDER_ID,
				OPERATION_ID,
				STATION_ID,
				REAL_AMOUNT,
				REAL_TIME,
				WAIT_TIME,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				#attributes.p_order_id_list#,
				#get_operation_row__.P_OPERATION_ID[1]#,
				#get_detail.station_id#,
				#get_operation_row__.quantity[1]#,
				#expense_time#,
				#tot_pause_duration_#,
				#SESSION.EP.USERID#,
				#NOW()#,
				'#CGI.REMOTE_ADDR#'
			)
		</cfquery>
	</cfloop>
</cfif>
