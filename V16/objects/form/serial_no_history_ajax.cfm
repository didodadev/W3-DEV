<cfquery name="get_last_guaranties" datasource="#dsn3#">
    SELECT
		SG.GUARANTY_ID,
		SG.PERIOD_ID,
		(SELECT PERIOD_YEAR FROM #dsn_alias#.SETUP_PERIOD SP WHERE SP.PERIOD_ID = SG.PERIOD_ID) PERIOD_YEAR,
		SG.RECORD_DATE,
		SG.STOCK_ID,
		SG.PROCESS_ID,
		SG.PROCESS_CAT,
		SG.SERIAL_NO,
		SG.LOT_NO,
		SG.IS_SALE,
		SG.PROCESS_NO,
		SG.SALE_CONSUMER_ID,
		SG.SALE_COMPANY_ID,
		SG.PURCHASE_COMPANY_ID,
		SG.PURCHASE_CONSUMER_ID,
		SG.PURCHASE_GUARANTY_CATID,
		SG.SALE_GUARANTY_CATID,
		SG.IN_OUT,
		SG.RECORD_EMP,
		SG.MAIN_PROCESS_TYPE,
		SG.MAIN_PROCESS_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		D.DEPARTMENT_HEAD,
		SL.COMMENT AS LOCATION,
		CASE 			
			WHEN SG.PROCESS_CAT IN (1193) THEN (SELECT PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = SG.PROCESS_ID) --1193 sistem
			WHEN SG.PROCESS_CAT IN (1194) THEN (SELECT PROJECT_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = SG.PROCESS_ID)--ÜRETİM EMRİ
			WHEN SG.PROCESS_CAT IN (1719,171) THEN (SELECT	
														PRODUCTION_ORDERS.PROJECT_ID
													FROM
														PRODUCTION_ORDERS,
														PRODUCTION_ORDER_RESULTS
													WHERE
														PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
														PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = SG.PROCESS_ID) --ÜRETİM SONUCU
		ELSE ''
		END AS PROJECT_ID
    FROM
		STOCKS S, 
        SERVICE_GUARANTY_NEW SG
        LEFT JOIN #dsn_alias#.EMPLOYEES E ON SG.RECORD_EMP = E.EMPLOYEE_ID
        LEFT JOIN #dsn_alias#.DEPARTMENT D ON SG.DEPARTMENT_ID = D.DEPARTMENT_ID
        LEFT JOIN #dsn_alias#.STOCKS_LOCATION SL ON SG.LOCATION_ID = SL.LOCATION_ID AND SG.DEPARTMENT_ID = SL.DEPARTMENT_ID
    WHERE 
        SG.STOCK_ID = S.STOCK_ID AND 
        SG.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.seri_stock_id#"> AND
        (SG.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> OR SG.REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> OR SG.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">)
        <cfif isdefined("attributes.is_store")>
            AND ( SG.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">) )
        </cfif>
        AND SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
    ORDER BY
		RECORD_DATE,
        GUARANTY_ID
</cfquery>

<cf_ajax_list>
    <thead>
        <tr>
            <th>&nbsp;</th>
            <th><cf_get_lang dictionary_id ='57630.Tip'></th>
            <th><cf_get_lang dictionary_id ='32653.Garanti Kategori'></th>
            <th><cf_get_lang dictionary_id ='57800.İşlem Tipi'></th>
            <th><cf_get_lang dictionary_id ='57554.Giriş'> <cf_get_lang dictionary_id='58763.Depo'></th>
            <th><cf_get_lang dictionary_id ='57431.Çıkış'> <cf_get_lang dictionary_id='58763.Depo'></th>
            <th><cf_get_lang dictionary_id ='57416.Proje'></th>
            <th><cf_get_lang dictionary_id ='57483.Kayıt'></th>
            <th><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></th>
            <th><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></th>
            <th><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
        </tr>
     </thead>
     <tbody>
    <cfif get_last_guaranties.recordcount>
        <cfset c_ = 0>
        <cfset old_list_ = "">
        <cfset last_writen_code = "">
        <cfoutput query="get_last_guaranties">
            <cfset code_ = "#PROCESS_ID#-#PROCESS_CAT#-#IN_OUT#">
            <cfif code_ is not last_writen_code>
                <cfset last_writen_code = code_>
                <cfset c_ = c_ + 1>
                <cfset old_list_ = listappend(old_list_,code_)>
                <tr>
                    <td>#c_#</td>
                    <td><cfif is_sale eq 1>
                            <cf_get_lang dictionary_id='57448.Satış'><cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
                        <cfelseif MAIN_PROCESS_TYPE eq 171 or process_cat eq 111>
                        	<cf_get_lang dictionary_id='57448.Satış'><cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
                        <cfelseif listfind('81,116,811,113',process_cat)><!--- sevk irsaliyesi --->
							<cfif in_out eq 1>
                                <cf_get_lang dictionary_id='58176.Alış'>
                                <cfset attributes.guarantycat_id = PURCHASE_GUARANTY_CATID>
                            <cfelse>
                                <cf_get_lang dictionary_id='57448.Satış'>
                                <cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
                            </cfif>
                        <cfelse>
                        	<cfif in_out eq 0>
                            	<cf_get_lang dictionary_id='57448.Satış'><cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
                            <cfelse>
                                <cf_get_lang dictionary_id='58176.Alış'><cfset attributes.guarantycat_id = PURCHASE_GUARANTY_CATID>
                            </cfif>
                        </cfif>
                    </td>
                    <td><cfif len(attributes.guarantycat_id)>
                            <cfquery name="GET_GUARANTY_CAT" datasource="#dsn#">
                                SELECT 
                                	SGT.GUARANTYCAT_TIME GUARANTYCAT_TIME,
                                	SG.GUARANTYCAT
                                FROM 
                                	SETUP_GUARANTY SG
                                    LEFT JOIN SETUP_GUARANTYCAT_TIME SGT ON SG.GUARANTYCAT_TIME = SGT.GUARANTYCAT_TIME_ID
                                WHERE 
                                	SG.GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guarantycat_id#">
                            </cfquery>
                            #GET_GUARANTY_CAT.guarantycat# - #GET_GUARANTY_CAT.GUARANTYCAT_TIME# ay
                        </cfif>
                    </td>
					<cfset url_link_ = "">
					<cfif process_cat eq 1193>
						<cfset url_link_ = "sales.list_subscription_contract&event=upd&subscription_id=#process_id#">
					</cfif>
					<cfif ListFind("70,71,72,78,85,141,73,74,75,76,77,84,86,87,88,140,81,811,79",process_cat)><!--- Irsaliyeler --->
						<cfquery name="get_relation_papers" datasource="#dsn3#">
							SELECT RECORD_DATE, SHIP_DATE PROCESS_DATE FROM #dsn#_#period_year#_#session.ep.company_id#.SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id#">
						</cfquery>
						<cfif process_cat eq 81>
							<cfset url_link_ = "stock.add_ship_dispatch&event=upd&ship_id=#process_id#">
						<cfelseif process_cat eq 811>
							<cfset url_link_ = "stock.upd_stock_in_from_customs&ship_id=#process_id#">
						<cfelseif listfind("70,71,72,78,85,141,79",process_cat)>
							<cfset url_link_ = "stock.form_add_sale&event=upd&ship_id=#process_id#">
						<cfelseif listfind("73,74,75,76,77,84,86,87,88,140",process_cat)>
							<cfset url_link_ = "stock.form_add_purchase&event=upd&ship_id=#process_id#">
						</cfif>
					<cfelseif ListFind("110,111,112,113,114,115,119,1131",process_cat)><!--- Fisler --->
						<cfquery name="get_relation_papers" datasource="#dsn3#">
							SELECT RECORD_DATE, FIS_DATE PROCESS_DATE FROM #dsn#_#period_year#_#session.ep.company_id#.STOCK_FIS WHERE FIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id#">
						</cfquery>
                        <cfif process_cat eq 114 and process_id eq 0>
							<cfset url_link_ = "objects.popup_upd_serialno_guaranty&id=#guaranty_id#">
                        <cfelse>
							<cfset url_link_ = "stock.form_add_fis&event=upd&upd_id=#process_id#">
                        </cfif>
					<cfelseif ListFind("1719,171",process_cat)><!--- Uretimler --->
						<cfquery name="get_relation_papers" datasource="#dsn3#">
							SELECT P_ORDER_ID,RESULT_NO,START_DATE PROCESS_DATE,RECORD_EMP,RECORD_DATE FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id#">
						</cfquery>
						<cfset url_link_ = "prod.list_results&event=upd&p_order_id=#get_relation_papers.p_order_id#&pr_order_id=#process_id#">
						<cfset get_last_guaranties.process_no = get_relation_papers.result_no>
                    <cfelseif ListFind("116",process_cat)><!--- stok virman --->
						<cfquery name="get_relation_papers" datasource="#dsn2#">
							SELECT STOCK_EXCHANGE_ID,EXCHANGE_NUMBER,PROCESS_DATE,RECORD_EMP,RECORD_DATE FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id#">
						</cfquery>
						<cfset url_link_ = "stock.form_upd_stock_exchange&exchange_id=#get_relation_papers.STOCK_EXCHANGE_ID#">
						<cfset get_last_guaranties.process_no = get_relation_papers.EXCHANGE_NUMBER>
					<cfelse>
						<cfset get_relation_papers.recordcount = 0>
					</cfif>
                    <td><cfif listfind('171,110,111,112,113,114,115,119',process_cat,',')>
                            <cfset page_type='list'>
                        <cfelse>
                            <cfset page_type='medium'>
                        </cfif>
						<cfif Len(url_link_) and session.ep.period_id eq period_id>
							<a href="#request.self#?fuseaction=#url_link_#" class="tableyazi" target="_blank">(#process_no#) - #get_process_name(process_cat)#</a>
						<cfelse>
							(#process_no#) - #get_process_name(process_cat)#
						</cfif>
                    </td>
                    <td><cfif IN_OUT eq 1>#DEPARTMENT_HEAD# - #LOCATION#</cfif></td>
                    <td><cfif IN_OUT eq 0>
							<cfif process_cat eq 111 and main_process_type eq 171>
                                <cfquery name="get_dep" datasource="#dsn3#">
                                    SELECT 
                                        D.DEPARTMENT_HEAD,
                                        SL.COMMENT AS LOCATION
                                    FROM
                                        #DSN_ALIAS#.DEPARTMENT D,
                                        #DSN_ALIAS#.STOCKS_LOCATION SL
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                                        D.DEPARTMENT_ID IN (SELECT EXIT_DEP_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAIN_PROCESS_ID#">)
                                        AND SL.LOCATION_ID IN (SELECT EXIT_LOC_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAIN_PROCESS_ID#">)
                                </cfquery>
                                <cfif get_dep.recordcount>
                                #GET_DEP.DEPARTMENT_HEAD# - #GET_DEP.LOCATION#
                                </cfif>
                            <cfelse>
                                #DEPARTMENT_HEAD# - #LOCATION#
                            </cfif>
                        </cfif>
                    </td>
                    <td>
                    <cfif ListFind("70,71,72,78,85,141,73,74,75,76,77,84,86,87,88,140,81,811",process_cat)>
                        <cfquery name="get_project_id" datasource="#dsn3#">
                            SELECT TOP 1 ISNULL(SR.ROW_PROJECT_ID,SHIP.PROJECT_ID) PROJECT_ID
                            	FROM #dsn#_#period_year#_#session.ep.company_id#.SHIP,
                                #dsn#_#period_year#_#session.ep.company_id#.SHIP_ROW SR
                            WHERE 
                            	SHIP.SHIP_ID=SR.SHIP_ID AND
                            	SHIP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id#">
                        </cfquery>
                    <cfelseif ListFind("110,111,112,113,114,115,119,1131",process_cat)>
                        <cfquery name="get_project_id" datasource="#dsn3#">                         	
                            SELECT 
                            	TOP 1 ISNULL(SR.ROW_PROJECT_ID,STOCK_FIS.PROJECT_ID) PROJECT_ID
                            FROM 
                            	#dsn#_#period_year#_#session.ep.company_id#.STOCK_FIS,
                                #dsn#_#period_year#_#session.ep.company_id#.STOCK_FIS_ROW SR                                
                            WHERE 
                            	STOCK_FIS.FIS_ID=SR.FIS_ID AND
                            	STOCK_FIS.FIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_id#">
                        </cfquery>
                    <cfelse>
                            <cfset get_project_id.recordcount = 0>
                    </cfif>
                    <cfif get_project_id.recordcount>
                    	<cfset project_id1=get_project_id.PROJECT_ID>
                    <cfelse>
                    	<cfset project_id1=get_last_guaranties.PROJECT_ID>
                    </cfif>   
                    <cfif len(project_id1)>            
                    	#GET_PROJECT_NAME(project_id1)#
                    </cfif>
                    </td>
                   <!--- <td><cfif len(project_id)>#GET_PROJECT_NAME(project_id)#</cfif></td>--->
                    <td><cfif ListFind("1719,171",process_cat) and get_relation_papers.recordcount>#get_emp_info(get_relation_papers.record_emp,0,0)#<cfelse>#employee_name# #employee_surname#</cfif></td>
                    <td><cfif get_relation_papers.recordcount>#dateformat(get_relation_papers.record_date,dateformat_style)#<cfelse>#dateformat(record_date,dateformat_style)#</cfif></td>
                    <td><cfif get_relation_papers.recordcount>#dateformat(get_relation_papers.process_date,dateformat_style)#</cfif></td>
                    <td><cfif len(sale_consumer_id)>#get_cons_info(sale_consumer_id,1,1)#
                        <cfelseif len(sale_company_id)>#get_par_info(sale_company_id,1,1,1)#
                        <cfelseif len(purchase_company_id)>#get_par_info(purchase_company_id,1,1,1)#
                        <cfelseif len(purchase_consumer_id)>#get_cons_info(purchase_consumer_id,1,1)#
                        </cfif>
                    </td>
                </tr>
            </cfif>	
        </cfoutput>
    </cfif>
   </tbody>
</cf_ajax_list>
