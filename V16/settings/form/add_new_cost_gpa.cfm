<cfif isdefined("attributes.aktarim_kaynak_period")>
	<cfset dsn3 = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfset dsn3_alias = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset dsn2_alias = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfset kaynak_dsn3 = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfif isdefined('attributes.aktarim_date1') or not len(attributes.aktarim_date1)>
		<cf_date tarih='attributes.aktarim_date1'>
	</cfif>
	<cfif isdefined('attributes.aktarim_date2') or not len(attributes.aktarim_date2)>
		<cf_date tarih='attributes.aktarim_date2'>
	</cfif>
	<!--- maliyet islemi yapacak kategori varmi --->
	<cfquery name="GET_PROCESS_CAT" datasource="#kaynak_dsn3#">
		SELECT
			PROCESS_CAT_ID,
			PROCESS_TYPE,
			IS_COST
		FROM 
			SETUP_PROCESS_CAT
		WHERE 
			IS_COST = 1
	</cfquery>
	<cfif GET_PROCESS_CAT.RECORDCOUNT>
		<cfset proc_list=valuelist(GET_PROCESS_CAT.PROCESS_CAT_ID,',')>
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2121.Maliyet işlemi yapması için bir işlem kategorisi seçilmemiş'>!");
			history.go(-2);
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="GET_NOT_DEP_COST_" datasource="#DSN#">
		SELECT 
			DEPARTMENT_ID,LOCATION_ID 
		FROM 
			STOCKS_LOCATION STOCKS_LOCATION
		WHERE 
			ISNULL(IS_COST_ACTION,0)=1
	</cfquery>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
	<div class="ui-info-text">
	<cfif attributes.step eq 1>
		<!--- silme --->
		<br/><b>1. <cf_get_lang no ='2120.Adım Silinmiş Belgelerden Maliyeti Silinmeyenler'></b><br/>
		<cfquery name="GET_DELETE_PAPER" datasource="#kaynak_dsn3#">
            SELECT
				ISNULL(ACTION_ID,0) ACTION_ID,
				PRODUCT_COST_ID,
				ACTION_TYPE,
				START_DATE ACTION_DATE
			FROM
				PRODUCT_COST
			WHERE
				1 = 1
				<cfif x_del_all_cost eq 0>
					AND 
					(
						(ACTION_TYPE = 1 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID NOT IN(SELECT INVOICE_ID FROM #kaynak_dsn2#.INVOICE WHERE IS_IPTAL<>1))
					OR
						(ACTION_TYPE = 2 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID NOT IN(SELECT SHIP_ID FROM #kaynak_dsn2#.SHIP WHERE IS_SHIP_IPTAL<>1))
					OR
						(ACTION_TYPE = 3 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID NOT IN(SELECT FIS_ID FROM #kaynak_dsn2#.STOCK_FIS))
					OR
						(ACTION_TYPE = 4 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID NOT IN(SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS))
					OR
						(ACTION_TYPE IN (5,7) AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID NOT IN(SELECT STOCK_EXCHANGE_ID FROM #kaynak_dsn2#.STOCK_EXCHANGE))
					OR	
						(ACTION_TYPE =8 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID NOT IN(SELECT INVOICE_ID FROM #kaynak_dsn2#.PRODUCT_COST_INVOICE))
					OR
						(ACTION_PROCESS_CAT_ID IS NOT NULL AND ACTION_PROCESS_CAT_ID > 0 AND ACTION_PROCESS_CAT_ID NOT IN(SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE IS_COST = 1))
					)
				</cfif>
				<cfif len(attributes.aktarim_paper_no)>
					AND 
					(
						(ACTION_TYPE = 1 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID  IN(SELECT INVOICE_ID FROM #kaynak_dsn2#.INVOICE WHERE INVOICE_NUMBER = '#attributes.aktarim_paper_no#'))
					OR
						(ACTION_TYPE = 2 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID  IN(SELECT SHIP_ID FROM #kaynak_dsn2#.SHIP WHERE SHIP_NUMBER =  '#attributes.aktarim_paper_no#'))
					OR
						(ACTION_TYPE = 3 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID  IN(SELECT FIS_ID FROM #kaynak_dsn2#.STOCK_FIS WHERE FIS_NUMBER =  '#attributes.aktarim_paper_no#'))
					OR
						(ACTION_TYPE = 4 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID  IN(SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE PRODUCTION_ORDER_NO =  '#attributes.aktarim_paper_no#'))
					OR
						(ACTION_TYPE IN (5,7) AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID  IN(SELECT STOCK_EXCHANGE_ID FROM #kaynak_dsn2#.STOCK_EXCHANGE WHERE EXCHANGE_NUMBER =  '#attributes.aktarim_paper_no#'))
					OR	
						(ACTION_TYPE =8 AND ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.aktarim_kaynak_period#"> AND ACTION_ID  IN(SELECT I.INVOICE_ID FROM #kaynak_dsn2#.PRODUCT_COST_INVOICE PO JOIN #kaynak_dsn2#.INVOICE I ON PO.INVOICE_ID = I.INVOICE_ID WHERE I.INVOICE_NUMBER =  '#attributes.aktarim_paper_no#'))
						)
				</cfif>
				<cfif x_del_all_cost eq 1 and not (isdefined("attributes.aktarim_is_manuel_cost") and attributes.aktarim_is_manuel_cost eq 1)>
					AND ISNULL(ACTION_ID,0) <> 0
				</cfif>
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
				<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
					AND	
					(
							(
								1=1
								<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
									AND PRODUCT_COST.START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								</cfif>
								<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
									AND PRODUCT_COST.START_DATE < <cfqueryparam value="#dateadd('d',1,attributes.aktarim_date2)#" cfsqltype="cf_sql_timestamp">
								</cfif>
							)
					)
				</cfif>
		</cfquery>
		<cfoutput><cf_get_lang_main no ='80.Toplam'> #GET_DELETE_PAPER.recordcount#<cf_get_lang no ='2119.adet belgenin maliyetleri silindi'><br /></cfoutput>
		<cfset attributes.is_print=1>
		<cfset attributes.dsn_type=#kaynak_dsn3#>
		<cfset attributes.period_dsn_type=#kaynak_dsn2#>
		<cfset attributes.query_type=3>
		<cfset attributes.user_id=#session_userid#>
		<cfset attributes.period_id=#attributes.aktarim_kaynak_period#>
		<cfset attributes.company_id=#attributes.aktarim_kaynak_company#>
		<cfset attributes.not_close_page=1>
		<cfif GET_DELETE_PAPER.RECORDCOUNT>
			<cfoutput query="GET_DELETE_PAPER">
				<cfif ACTION_ID gt 0 and x_del_all_cost eq 0>
					#currentrow#--<cfif ACTION_TYPE eq 1><cf_get_lang_main no ='29.Fatura'> ID:<cfelseif ACTION_TYPE eq 2><cf_get_lang_main no ='361.İrsaliye'> ID:<cfelseif ACTION_TYPE eq 3><cf_get_lang no ='2116.Stok Fişi'> ID:<cfelseif ACTION_TYPE eq 4><cf_get_lang_main no ='44.Üretim'>:</cfif>#ACTION_ID# <cf_get_lang_main no ='330.Tarih'>:#dateformat(ACTION_DATE,'dd:mm:yyyy')#<br />
					<cfset attributes.action_type=#ACTION_TYPE#>
					<cfset attributes.action_id=#ACTION_ID#>
					<cfset attributes.control_type=0>
					<cfinclude template="../../objects/query/cost_action.cfm"><br />
				<cfelse>
					<cfquery name="del_cost" datasource="#dsn1#">
						DELETE FROM PRODUCT_COST WHERE PRODUCT_COST_ID = #PRODUCT_COST_ID#
					</cfquery>	
				</cfif>
                <cfset son_deger = GET_DELETE_PAPER.currentrow>
                <cfset toplam_kayit = GET_DELETE_PAPER.recordcount>
			</cfoutput>
		</cfif>
		<form action="" name="form1_" id="step1" method="post">		
            <cfif isdefined("attributes.is_oto")>
        		<input type="hidden" name="is_oto" id="is_oto" value="1" />
        	</cfif>
			<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#attributes.aktarim_kaynak_period#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#attributes.aktarim_kaynak_year#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#attributes.aktarim_kaynak_company#</cfoutput>">
			<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfif isdate(attributes.aktarim_date1)><cfoutput>#dateformat(attributes.aktarim_date1,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfif isdate(attributes.aktarim_date2)><cfoutput>#dateformat(attributes.aktarim_date2,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_product_name" id="aktarim_product_name" value="<cfoutput>#attributes.aktarim_product_name#</cfoutput>">
			<input type="hidden" name="aktarim_product_id" id="aktarim_product_id" value="<cfoutput>#attributes.aktarim_product_id#</cfoutput>">
			<input type="hidden" name="aktarim_paper_no" id="aktarim_paper_no" value="<cfoutput>#attributes.aktarim_paper_no#</cfoutput>">
			<input type="hidden" name="session_userid" id="session_userid" value="<cfoutput>#attributes.session_userid#</cfoutput>">
			<input type="hidden" name="session_period_id" id="session_period_id" value="<cfoutput>#attributes.session_period_id#</cfoutput>">
			<input type="hidden" name="session_money" id="session_money" value="<cfoutput>#attributes.session_money#</cfoutput>">
			<input type="hidden" name="session_money2" id="session_money2" value="<cfoutput>#attributes.session_money2#</cfoutput>">
			<cfif isdefined('attributes.aktarim_is_cost_again') and len(attributes.aktarim_is_cost_again)>
            <input type="hidden" name="aktarim_is_cost_again" id="aktarim_is_cost_again" value="<cfoutput>#attributes.aktarim_is_cost_again#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_invent_again') and len(attributes.aktarim_is_invent_again)>
            <input type="hidden" name="aktarim_is_invent_again" id="aktarim_is_invent_again" value="<cfoutput>#attributes.aktarim_is_invent_again#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_date_kontrol') and len(attributes.aktarim_is_date_kontrol)>
            <input type="hidden" name="aktarim_is_date_kontrol" id="aktarim_is_date_kontrol" value="<cfoutput>#attributes.aktarim_is_date_kontrol#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_location_based_cost') and len(attributes.aktarim_is_location_based_cost)>
            <input type="hidden" name="aktarim_is_location_based_cost" id="aktarim_is_location_based_cost" value="<cfoutput>#attributes.aktarim_is_location_based_cost#</cfoutput>"></cfif>
			<cf_get_lang no ='2028.Kaynak Veri Tabanı'>: <cfoutput>#attributes.aktarim_kaynak_period# (#attributes.aktarim_kaynak_year#)</cfoutput><br/>
			<br /><br />
            <cfif toplam_kayit gt son_deger>
                <input type="text" name="page" id="page" value="<cfoutput>#(attributes.page+1)#</cfoutput>">
                <input type="hidden" name="step" id="step" value="1">
                <input type="button" value="part_<cfoutput>#attributes.page#</cfoutput>" onClick="basamak_2();">
            <cfelse>
            	<input type="hidden" name="step" id="step" value="2">
                <b><font color="FF0000">Sonraki İşlem : <cf_get_lang no ='2118.Maliyetlerin Oluşturulması'></font> </b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
            </cfif>           
		</form>
	<cfelseif attributes.step eq 2>
		<!--- maliyet islemi yapacak kategori varmi --->
		<br/><b>2.<cf_get_lang no ='2118.Maliyetlerin Oluşturulması'> </b><br/>
		<cfquery name="delete_total_costs" datasource="#kaynak_dsn3#">
			DELETE FROM 
				#dsn1_alias#.PRODUCT_COST 
			WHERE 
				ACTION_TYPE = -2 
				<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
					AND START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
				</cfif>
				<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
					AND START_DATE < <cfqueryparam value="#dateadd('d',1,attributes.aktarim_date2)#" cfsqltype="cf_sql_timestamp">
				</cfif>
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
		</cfquery>
		<cfquery name="GET_PROCESS_CAT" datasource="#kaynak_dsn3#">
			SELECT
				PROCESS_CAT_ID,
				PROCESS_TYPE,
				IS_COST
			FROM 
				SETUP_PROCESS_CAT
			WHERE 
				IS_COST = 1
		</cfquery>
		<cfset proc_list=valuelist(GET_PROCESS_CAT.PROCESS_CAT_ID,',')>
		<!---Parametreler: 
			#attributes.aktarim_product_id#
			attributes.aktarim_is_cost_again
			attributes.aktarim_date1
			attributes.aktarim_date2
			attributes.aktarim_paper_no
		--->
	<cfif attributes.page eq 1 > 
        <cfquery name="delete_GET_STOCK_ACT_ALL" datasource="#kaynak_dsn2#">
            IF EXISTS (SELECT * FROM tempdb.sys.tables where name = '####GET_STOCK_ACT_ALL_REPORT')
            DROP TABLE ####GET_STOCK_ACT_ALL_REPORT
        </cfquery> 
        <cfquery name="GET_STOCK_ACT_ALL" datasource="#kaynak_dsn2#">
           SELECT * 
           INTO ####GET_STOCK_ACT_ALL_REPORT
           FROM ( 
            SELECT
                SUM(STOCK_IN - STOCK_OUT) AS AMOUNT_ALL,
                PRODUCT_ID,
                <cfif is_stock_based_cost eq 1>
                STOCK_ID,
                </cfif>
                STORE_LOCATION LOCATION_ID,
                STORE DEPARTMENT_ID,
                ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID,
                ISNULL(PROCESS_TIME,PROCESS_DATE) PROCESS_DATE,
                PROCESS_TYPE,
                STOCK_IN
            FROM
                STOCKS_ROW
            WHERE
                PROCESS_TYPE NOT IN (72,75) <!--- konsinye çıkış faturası kesilmemiş olanlar --->
            GROUP BY
                PRODUCT_ID,
                <cfif is_stock_based_cost eq 1>
                STOCK_ID,
                </cfif>
                STORE_LOCATION,
                STORE,
				PROCESS_TIME,
                ISNULL(SPECT_VAR_ID,0),
                PROCESS_DATE,
                PROCESS_TYPE,
                STOCK_IN
        UNION ALL
        <!--- br onceki donemden devretmesi gereken faturalandırılmamıs cıkıs konsinye irsaliyelerindeki miktarda maliyet hesabına katılıyor --->
            SELECT
                SUM(STOCK_IN - STOCK_OUT) AS AMOUNT_ALL,
                PRODUCT_ID,
                <cfif is_stock_based_cost eq 1>
                STOCK_ID,
                </cfif>
                LOCATION_ID,
                DEPARTMENT_ID,
                ISNULL(SPECT_MAIN_ID,0) AS SPECT_VAR_ID,
                ACTION_DATE AS PROCESS_DATE,
                72 AS PROCESS_TYPE,
                STOCK_IN
            FROM
                GET_PRE_PERIOD_CONSIGMENT_DETAIL
            GROUP BY
                PRODUCT_ID,
                <cfif is_stock_based_cost eq 1>
                STOCK_ID,
                </cfif>
                LOCATION_ID,
                DEPARTMENT_ID,
                ISNULL(SPECT_MAIN_ID,0),
                ACTION_DATE,
                STOCK_IN
                ) AS XXX
			</cfquery>
            <cfquery name="CRT_IND" datasource="#kaynak_dsn2#">
                CREATE CLUSTERED INDEX CL_REPORT_GET_STOCK_ACT_ALL ON ####GET_STOCK_ACT_ALL_REPORT (PRODUCT_ID ,PROCESS_DATE) 	   
            </cfquery>    
            <cfquery name="delete_GET_INVOICE_INSERT" datasource="#kaynak_dsn2#">
                IF EXISTS (SELECT * FROM tempdb.sys.tables where name = '####GET_INVOICE')
                DROP TABLE ####GET_INVOICE
            </cfquery> 
            <cfquery name="GET_INVOICE_INSERT" datasource="#kaynak_dsn2#">
                SELECT *
                INTO ####GET_INVOICE
                FROM
                (SELECT DISTINCT
                    1 ACTION_TYPE,
                    2 QUERY_TYPE,
                    INVOICE.INVOICE_ID ACTION_ID,
                    '' ACTION_ROW_ID,
					ISNULL((SELECT TOP 1 ISNULL(S.DELIVER_DATE,S.SHIP_DATE) FROM SHIP S, SHIP_ROW R WHERE S.SHIP_ID = R.SHIP_ID AND ((INVOICE.IS_WITH_SHIP = 0 AND R.WRK_ROW_ID = INVOICE_ROW.WRK_ROW_RELATION_ID) OR (INVOICE.IS_WITH_SHIP = 1 AND R.WRK_ROW_RELATION_ID = INVOICE_ROW.WRK_ROW_ID)) ORDER BY ISNULL(S.DELIVER_DATE,S.SHIP_DATE) DESC),INVOICE.INVOICE_DATE) ACTION_DATE,
					<!--- ISNULL((SELECT TOP 1 ISNULL(S.DELIVER_DATE,S.SHIP_DATE) FROM SHIP S,INVOICE_SHIPS ISS WHERE S.SHIP_ID = ISS.SHIP_ID AND ISS.INVOICE_ID = INVOICE.INVOICE_ID ORDER BY ISNULL(S.DELIVER_DATE,S.SHIP_DATE) DESC),INVOICE.INVOICE_DATE) ACTION_DATE, --->
					<!--- INVOICE.INVOICE_DATE ACTION_DATE, --->
                    INVOICE.RECORD_DATE INSERT_DATE,
                    INVOICE.INVOICE_NUMBER AS PAPER_NUMBER_,
                    0 IS_ADD_INVENTORY,
                    0 SHIP_TYPE,
                    0 SHIP_TYPE_NEW
                FROM 
                    INVOICE,
                    INVOICE_ROW,
                    #dsn1_alias#.PRODUCT PRODUCT
                WHERE
                    INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                    INVOICE_ROW.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                    PRODUCT.IS_COST=1 AND
                    PROCESS_CAT IN (#proc_list#)
                    <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                        AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#

                    </cfif>
                    <cfif not isdefined('attributes.aktarim_is_cost_again')>
                        AND INVOICE.INVOICE_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=1)
                    </cfif>
                    <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND	(
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND INVOICE.INVOICE_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                    <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND INVOICE.INVOICE_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                )
                        )
                    </cfif>
                    <cfif GET_NOT_DEP_COST_.RECORDCOUNT>
                    AND
                        ( 
                        <cfset rw_count=0>
                        <cfloop query="GET_NOT_DEP_COST_">
                            <cfset rw_count=rw_count+1>
                            NOT (DEPARTMENT_LOCATION = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND INVOICE.DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
                            <cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
                        </cfloop>
                        )
                    </cfif>
                    <cfif len(attributes.aktarim_paper_no)>
                        AND INVOICE.INVOICE_NUMBER = '#attributes.aktarim_paper_no#'
                    <cfelse>
                        AND INVOICE.INVOICE_ID NOT IN (SELECT ISNULL(DIFF_INVOICE_ID,0) FROM INVOICE_CONTRACT_COMPARISON)
                    </cfif>
                    AND IS_IPTAL <> 1
            UNION ALL
                SELECT  DISTINCT
                    2 ACTION_TYPE,
                    2 QUERY_TYPE,
                    SHIP.SHIP_ID ACTION_ID,
                    '' ACTION_ROW_ID,
                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                    SHIP.RECORD_DATE INSERT_DATE,
                    SHIP.SHIP_NUMBER AS PAPER_NUMBER_,
                    ISNULL((SELECT IS_ADD_INVENTORY FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = SHIP.PROCESS_CAT),0) AS IS_ADD_INVENTORY,
                    CASE WHEN ISNULL((SELECT IS_ADD_INVENTORY FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = SHIP.PROCESS_CAT),0) = 1
                    THEN
                    SHIP_TYPE
                    ELSE
                    0
                    END AS SHIP_TYPE,
                    SHIP.SHIP_TYPE SHIP_TYPE_NEW
                FROM 
                    SHIP,
                    SHIP_ROW,
                    #dsn1_alias#.PRODUCT PRODUCT
                WHERE
                    SHIP.SHIP_ID=SHIP_ROW.SHIP_ID AND
                    SHIP_ROW.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                    PRODUCT.IS_COST=1 AND
                    ((SHIP.SHIP_TYPE = 81 AND ISNULL(SHIP.IS_DELIVERED,0)=1) OR SHIP.SHIP_TYPE <> 81) AND
                    (PROCESS_CAT IN (#proc_list#) OR ISNULL((SELECT IS_ADD_INVENTORY FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = SHIP.PROCESS_CAT),0)=1) AND
                    
                    SHIP.SHIP_ID NOT IN (
                                SELECT 
                                    SHIP_ID 
                                FROM 
                                    INVOICE_SHIPS,INVOICE 
                                WHERE 
                                    INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND 
                                    INVOICE.PROCESS_CAT IN (#proc_list#) 
                                )
                    <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                        AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#
                    </cfif>
                    <cfif not isdefined('attributes.aktarim_is_cost_again')>
                    AND SHIP.SHIP_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=2)
                    </cfif>
                    <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND	(
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND SHIP.DELIVER_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
									<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND ((SHIP.DELIVER_DATE < <cfqueryparam value="#dateadd('d',1,attributes.aktarim_date2)#" cfsqltype="cf_sql_timestamp">  AND (SHIP_TYPE <> 74 OR ISNULL((SELECT IS_ADD_INVENTORY FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = SHIP.PROCESS_CAT),0) = 0)) OR (SHIP_TYPE = 74 AND ISNULL((SELECT IS_ADD_INVENTORY FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = SHIP.PROCESS_CAT),0) = 1))
                                    </cfif>
                                )
                        )
                    </cfif>
                    <cfif GET_NOT_DEP_COST_.RECORDCOUNT>
                    AND
                        (
                        ( 
                        <cfset rw_count=0>
                        <cfloop query="GET_NOT_DEP_COST_">
                            <cfset rw_count=rw_count+1>
                            NOT (LOCATION_IN = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND DEPARTMENT_IN = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
                            <cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
                        </cfloop>
                        )
                        OR SHIP_TYPE = 71
                        )
                    </cfif>
                    <cfif len(attributes.aktarim_paper_no)>
                        AND SHIP.SHIP_NUMBER = '#attributes.aktarim_paper_no#'
                    </cfif>
            UNION ALL
                SELECT DISTINCT
                    3 ACTION_TYPE,
                    2 QUERY_TYPE,
                    STOCK_FIS.FIS_ID ACTION_ID,
                    '' ACTION_ROW_ID,
                    STOCK_FIS.FIS_DATE ACTION_DATE,
                    STOCK_FIS.RECORD_DATE INSERT_DATE,
                    STOCK_FIS.FIS_NUMBER AS PAPER_NUMBER_,
                    0 IS_ADD_INVENTORY,
                    0 SHIP_TYPE,
                    0 SHIP_TYPE_NEW
                FROM 
                    STOCK_FIS,
                    STOCK_FIS_ROW,
                    #dsn1_alias#.STOCKS STOCKS,
                    #dsn1_alias#.PRODUCT PRODUCT
                WHERE
                    STOCK_FIS.FIS_ID=STOCK_FIS_ROW.FIS_ID AND
                    STOCKS.STOCK_ID=STOCK_FIS_ROW.STOCK_ID AND
                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                    PRODUCT.IS_COST=1 AND
                    PROCESS_CAT IN (#proc_list#) 
                    <cfif x_is_prod_cost eq 1>
                        AND PROD_ORDER_NUMBER IS NULL
                    </cfif>
                    AND STOCK_FIS.RELATED_SHIP_ID IS NULL
                    <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                        AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#
                    </cfif>
                    <cfif not isdefined('attributes.aktarim_is_cost_again')>
                        AND STOCK_FIS.FIS_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=3)
                    </cfif>
                    <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND	(
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND STOCK_FIS.FIS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                    <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND STOCK_FIS.FIS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                )
                        )
                    </cfif>
                    <cfif GET_NOT_DEP_COST_.RECORDCOUNT>
                    AND
                        ( 
                        <cfset rw_count=0>
                        <cfloop query="GET_NOT_DEP_COST_">
                            <cfset rw_count=rw_count+1>
                            NOT (LOCATION_IN = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND DEPARTMENT_IN = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
                            <cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
                        </cfloop>
                        )
                    </cfif>
                    <cfif len(attributes.aktarim_paper_no)>
                        AND STOCK_FIS.FIS_NUMBER = '#attributes.aktarim_paper_no#'
                    </cfif>
            UNION ALL
                SELECT DISTINCT
                    5 ACTION_TYPE,
                    2 QUERY_TYPE,
                    STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ID,
                    '' ACTION_ROW_ID,
                    STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                    STOCK_EXCHANGE.RECORD_DATE INSERT_DATE,
                    '' AS PAPER_NUMBER_,
                    0 IS_ADD_INVENTORY,
                    0 SHIP_TYPE,
                    0 SHIP_TYPE_NEW
                FROM 
                    STOCK_EXCHANGE,
                    #dsn1_alias#.STOCKS STOCKS,
                    #dsn1_alias#.PRODUCT PRODUCT
                WHERE
                    STOCKS.STOCK_ID=STOCK_EXCHANGE.STOCK_ID AND
                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                    PRODUCT.IS_COST=1 AND
                    STOCK_EXCHANGE.STOCK_EXCHANGE_TYPE=1 AND 
                    PROCESS_CAT IN (#proc_list#)
                    <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                        AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#
                    </cfif>
                    <cfif not isdefined('attributes.aktarim_is_cost_again')>
                        AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=5)
                    </cfif>
                    <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND	(
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND STOCK_EXCHANGE.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                    <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND STOCK_EXCHANGE.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                )
                        )
                    </cfif>
                    <cfif GET_NOT_DEP_COST_.RECORDCOUNT>
                    AND
                        ( 
                        <cfset rw_count=0>
                        <cfloop query="GET_NOT_DEP_COST_">
                            <cfset rw_count=rw_count+1>
                            NOT (LOCATION_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND STOCK_EXCHANGE.DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
                            <cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
                        </cfloop>
                        )
                    </cfif>
                    <cfif len(attributes.aktarim_paper_no)>
                            AND STOCK_EXCHANGE.EXCHANGE_NUMBER = '#attributes.aktarim_paper_no#'
                    </cfif>
            UNION ALL
                SELECT DISTINCT
                    7 ACTION_TYPE,
                    2 QUERY_TYPE,
                    STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ID,
                    '' ACTION_ROW_ID,
                    STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                    STOCK_EXCHANGE.RECORD_DATE INSERT_DATE,
                    '' AS PAPER_NUMBER_,
                    0 IS_ADD_INVENTORY,
                    0 SHIP_TYPE,
                    0 SHIP_TYPE_NEW
                FROM 
                    STOCK_EXCHANGE,
                    #dsn1_alias#.STOCKS STOCKS,
                    #dsn1_alias#.PRODUCT PRODUCT
                WHERE
                    STOCKS.STOCK_ID=STOCK_EXCHANGE.STOCK_ID AND
                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                    PRODUCT.IS_COST=1 AND
                    STOCK_EXCHANGE.STOCK_EXCHANGE_TYPE=0 AND 
                    PROCESS_CAT IN (#proc_list#)
                    <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                        AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#
                    </cfif>
                    <cfif not isdefined('attributes.aktarim_is_cost_again')>
                        AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=5)
                    </cfif>
                    <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND	(
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND STOCK_EXCHANGE.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                    <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND STOCK_EXCHANGE.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                )
                        )
                    </cfif>
                    <cfif GET_NOT_DEP_COST_.RECORDCOUNT>
                    AND
                        ( 
                        <cfset rw_count=0>
                        <cfloop query="GET_NOT_DEP_COST_">
                            <cfset rw_count=rw_count+1>
                            NOT (LOCATION_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND STOCK_EXCHANGE.DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
                            <cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
                        </cfloop>
                        )
                    </cfif>
                    <cfif len(attributes.aktarim_paper_no)>
                            AND STOCK_EXCHANGE.EXCHANGE_NUMBER = '#attributes.aktarim_paper_no#'
                    </cfif>
                    
            UNION ALL
                SELECT
                    8 ACTION_TYPE,
                    2 QUERY_TYPE,
                    PRODUCT_COST_INVOICE.INVOICE_ID ACTION_ID,
                    PRODUCT_COST_INVOICE_ID ACTION_ROW_ID,
                    PRODUCT_COST_INVOICE.COST_DATE ACTION_DATE,
                    PRODUCT_COST_INVOICE.RECORD_DATE INSERT_DATE,
                    '' AS PAPER_NUMBER_,
                    0 IS_ADD_INVENTORY,
                    0 SHIP_TYPE,
                    0 SHIP_TYPE_NEW
                FROM 
                    PRODUCT_COST_INVOICE,
                    INVOICE,
                    #dsn1_alias#.STOCKS STOCKS,
                    #dsn1_alias#.PRODUCT PRODUCT
                WHERE
                    STOCKS.STOCK_ID=PRODUCT_COST_INVOICE.STOCK_ID AND
                    INVOICE.INVOICE_ID=PRODUCT_COST_INVOICE.INVOICE_ID AND
                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                    PRODUCT.IS_COST=1 AND
                    PROCESS_CAT IN (#proc_list#)
                    <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                        AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#
                    </cfif>
                    <cfif not isdefined('attributes.aktarim_is_cost_again')>
                        AND PRODUCT_COST_INVOICE.INVOICE_ID NOT IN (SELECT ACTION_ID FROM PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=8)
                    </cfif>
                    <cfif GET_NOT_DEP_COST_.RECORDCOUNT>
                    AND
                        ( 
                        <cfset rw_count=0>
                        <cfloop query="GET_NOT_DEP_COST_">
                            <cfset rw_count=rw_count+1>
                            NOT (DEPARTMENT_LOCATION = <cfqueryparam value="#GET_NOT_DEP_COST_.LOCATION_ID#" cfsqltype="cf_sql_integer"> AND INVOICE.DEPARTMENT_ID = <cfqueryparam value="#GET_NOT_DEP_COST_.DEPARTMENT_ID#" cfsqltype="cf_sql_integer">)
                            <cfif rw_count lt GET_NOT_DEP_COST_.RECORDCOUNT>AND</cfif>
                        </cfloop>
                        )
                    </cfif>
                    <cfif len(attributes.aktarim_paper_no)>
                        AND INVOICE.INVOICE_NUMBER = '#attributes.aktarim_paper_no#'
                    </cfif>
                    <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND (
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND PRODUCT_COST_INVOICE.COST_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                    <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND PRODUCT_COST_INVOICE.COST_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                )
                        )
                    </cfif>
                    ) AS XXX 
                   OPTION (MAXDOP 1)
            </cfquery> 
     </cfif>
     <!--- sevk irsaliyesinde maliyet güncelleniyor öncelikle --->
     	<cfstoredproc procedure="UPD_SHIP_COST" datasource="#dsn2#">
     	<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1> 
        	<cfprocparam cfsqltype="cf_sql_integer" value="1">
        <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2> <!--- depo bazlı maliyet--->
        	<cfprocparam cfsqltype="cf_sql_integer" value="2">
        <cfelse>
        	<cfprocparam cfsqltype="cf_sql_integer" value="0">
        </cfif>
        
       	<cfif session.ep.our_company_info.is_prod_cost_type eq 0 >
        	<cfprocparam cfsqltype="cf_sql_bit" value="0">
        <cfelse>
        	<cfprocparam cfsqltype="cf_sql_bit" value="1">
        </cfif>
     </cfstoredproc>     
		<cfif isdefined('attributes.aktarim_is_invent_again')> 
            <cfquery name="delete_GET_INVOICE_INSERT" datasource="#kaynak_dsn2#">
                IF EXISTS (SELECT * FROM tempdb.sys.tables where name = '####GET_INVENTORY')
                DROP TABLE ####GET_INVENTORY
            </cfquery>
        </cfif>         
		<cfif isdefined('attributes.aktarim_is_invent_again')>       
        	<cfquery name="GET_INVOICE" datasource="#kaynak_dsn2#">        
                WITH CTE1 AS (
                SELECT 
                    * 
                FROM 
                    ####GET_INVOICE
                ),
                    CTE2 AS (
                        SELECT
                            CTE1.*,
                                ROW_NUMBER() OVER ( ORDER BY 
                                                        ACTION_DATE,
                                                        SHIP_TYPE_NEW,
                                                        INSERT_DATE
                ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    INTO ####GET_INVENTORY
                FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
        	</cfquery>
        
            <cfquery name="GET_INVOICE" datasource="#kaynak_dsn2#"> 
            	SELECT * FROM ####GET_INVENTORY
            </cfquery>
        <cfelse>
        	<cfquery name="GET_INVOICE" datasource="#kaynak_dsn2#">        
                WITH CTE1 AS (
                SELECT 
                    * 
                FROM 
                    ####GET_INVOICE
                ),
                    CTE2 AS (
                        SELECT
                            CTE1.*,
                                ROW_NUMBER() OVER ( ORDER BY 
                                                        ACTION_DATE,
                                                        SHIP_TYPE,
                                                        INSERT_DATE
                ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*            
                FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
        	</cfquery>
        </cfif> 
       
       <cfsavecontent variable="toplam_kayit_xxx">
			<cfoutput>
                <cf_get_lang_main no ='80.Toplam'> #GET_INVOICE.QUERY_COUNT# <cf_get_lang no ='2117.adet belge var'>.<br/>
            </cfoutput>
        </cfsavecontent>
        <cfoutput>
        	#toplam_kayit_xxx#
        </cfoutput>
        <cfif attributes.page eq 1>
        	<cfset file_name = 'mal_'&dateformat(now(),'ddmmyyyy')&'_'&timeformat(now(),'HHMMl')&'_'&session.ep.userid>
            <cffile action="write" file="#download_folder#documents#dir_seperator#settings#dir_seperator##file_name#.txt" output="#REReplaceNoCase(toplam_kayit_xxx, '<(.|\n)*?>', '', 'ALL')#" charset="utf-8">
            <cfquery name="add_maliyet_txt" datasource="#dsn#">
            	INSERT INTO COST_TXT 
                (
                	DOCUMENT_NAME,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#download_folder#documents#dir_seperator#settings#dir_seperator##file_name#.txt">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
            </cfquery>
            <cfset session.ep.file_name = "#download_folder#documents#dir_seperator#settings#dir_seperator##file_name#.txt">
        </cfif>
		<cfif GET_INVOICE.RECORDCOUNT>
			<cfset attributes.is_print=1>
			<cfset attributes.dsn_type=#kaynak_dsn3#>
			<cfset attributes.period_dsn_type=#kaynak_dsn2#>
			<cfset attributes.query_type=2>
			<cfset attributes.user_id=#session_userid#>
			<cfset attributes.period_id=#attributes.aktarim_kaynak_period#>
			<cfset attributes.company_id=#attributes.aktarim_kaynak_company#>
			<cfset attributes.not_close_page=1>
			<cfif isdefined('attributes.aktarim_is_invent_again')>
				<cfquery name="control_amortization" datasource="#dsn3#">
					SELECT
						INVENTORY_AMORTIZATION_MAIN.INV_AMORT_MAIN_ID
					FROM
						INVENTORY_AMORTIZATON,
						INVENTORY_AMORTIZATION_MAIN,
						INVENTORY
					WHERE
						INVENTORY_AMORTIZATON.INVENTORY_ID = INVENTORY.INVENTORY_ID AND
						INVENTORY.INVENTORY_TYPE = 4 AND
						INVENTORY_AMORTIZATION_MAIN.INV_AMORT_MAIN_ID=INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID AND
						YEAR(INVENTORY_AMORTIZATION_MAIN.ACTION_DATE) = #session.ep.period_year#
						<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
							AND INVENTORY_AMORTIZATION_MAIN.ACTION_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
						</cfif>
				</cfquery>
				<cfif control_amortization.recordcount>
					<font color="FF0000">Belirtilen Tarihler Arasında Demirbaş Değerleme İşlemi Olduğu İçin Maliyet İşlemi Çalıştıramazsınız.</font><br/>
					<cfabort>
				</cfif>
			</cfif>
             <!--- Eğer irsaliye işlem kategorisinde demirabş stok fişi eklensin seçilmiş ise öncelikle irsaliyenin demirbaş işlemlerini yapacak --->
			<cfif isdefined('attributes.aktarim_is_invent_again')>
                <cfinclude template="../../settings/query/add_ship_inventory.cfm">
            </cfif>
			<cfloop query="GET_INVOICE">
				<!---<cfquery name="get_max_document" datasource="#dsn#_report">
                    SELECT TOP 1 DOCUMENT_NAME FROM COST_TXT ORDER BY RECORD_DATE DESC
                </cfquery>--->
                    <cfsavecontent variable="text_123">
						<cfoutput> #rownum#<cf_get_lang_main no='1204.Belge Numarası'>: #PAPER_NUMBER_# <cfif ACTION_TYPE eq 1><cf_get_lang_main no ='29.Fatura'> ID:<cfelseif ACTION_TYPE eq 2><cf_get_lang_main no ='361.İrsaliye'> ID:<cfelseif ACTION_TYPE eq 3><cf_get_lang no ='2116.Stok Fişi'> ID:<cfelseif ACTION_TYPE eq 5><cf_get_lang_main no='1412.Stok Virman'></cfif>#ACTION_ID# <cf_get_lang_main no ='330.Tarih'>:#dateformat(ACTION_DATE,dateformat_style)#</cfoutput>
                        <cfset GET_S_ID.MAX_ID = ''>
                        <cfset attributes.ship_type=SHIP_TYPE>
                        <cfset attributes.action_type=ACTION_TYPE>
                        <cfset attributes.action_id=ACTION_ID>
                        <cfset attributes.action_row_id=ACTION_ROW_ID>
						<cfif ACTION_TYPE eq 8>
                       	 <cfset attributes.extra_action_row_id=ACTION_ROW_ID>
						</cfif>
                        <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                            <cfset attributes.aktarim_product_id=attributes.aktarim_product_id>
                        </cfif>
                        <!--- Eğer irsaliye işlem kategorisinde demirabş stok fişi eklensin seçilmiş ise öncelikle irsaliyenin demirbaş işlemlerini yapacak --->
                        <cfif get_invoice.is_add_inventory eq 1 and isdefined('attributes.aktarim_is_invent_again')>
                            <cfinclude template="../../settings/query/add_ship_inventory_check.cfm">
                        </cfif>
                        <cfif get_invoice.ship_type neq 71>
                            <cfset attributes.control_type=0>
                            <cfinclude template="../../objects/query/cost_action.cfm">
                        </cfif><br/>
                        <cfif isdefined("GET_S_ID.MAX_ID") and len(GET_S_ID.MAX_ID) and isdefined('attributes.aktarim_is_invent_again')>
                           <cfoutput> <cf_get_lang_main no='1204.Belge Numarası'>: #PAPER_NUMBER_# <cf_get_lang no ='2116.Stok Fişi'> ID:#GET_S_ID.MAX_ID# <cf_get_lang_main no ='330.Tarih'>:#dateformat(ACTION_DATE,dateformat_style)#<br/></cfoutput>
                            <cfset attributes.action_type=3>
                            <cfset attributes.action_id=GET_S_ID.MAX_ID>
                            <cfset attributes.control_type=0>
                            <cfinclude template="../../objects/query/cost_action.cfm">
                        </cfif>
                        <cfset son_deger = GET_INVOICE.rownum >
                        <cfset toplam_kayit = GET_INVOICE.QUERY_COUNT>
					</cfsavecontent>
                    <cfoutput>#text_123#</cfoutput>
                    <cffile action="append" addnewline="yes" file="#session.ep.file_name#" output="#REReplaceNoCase(text_123, '<(.|\n)*?>', '', 'ALL')#" charset="utf-8">
            </cfloop>
		</cfif>
		<form action="" name="form1_" method="post" id="step2">
            <cfif isdefined("attributes.is_oto")>
        		<input type="hidden" name="is_oto" id="is_oto" value="1" />
        	</cfif>
            <input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#attributes.aktarim_kaynak_period#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#attributes.aktarim_kaynak_year#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#attributes.aktarim_kaynak_company#</cfoutput>">
			<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfif isdate(attributes.aktarim_date1)><cfoutput>#dateformat(attributes.aktarim_date1,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfif isdate(attributes.aktarim_date2)><cfoutput>#dateformat(attributes.aktarim_date2,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_product_name" id="aktarim_product_name" value="<cfoutput>#attributes.aktarim_product_name#</cfoutput>">
			<input type="hidden" name="aktarim_product_id" id="aktarim_product_id" value="<cfoutput>#attributes.aktarim_product_id#</cfoutput>">
			<input type="hidden" name="aktarim_paper_no" id="aktarim_paper_no" value="<cfoutput>#attributes.aktarim_paper_no#</cfoutput>">
			<cfif isdefined('attributes.aktarim_is_cost_again') and len(attributes.aktarim_is_cost_again)>
            <input type="hidden" name="aktarim_is_cost_again" id="aktarim_is_cost_again" value="<cfoutput>#attributes.aktarim_is_cost_again#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_invent_again') and len(attributes.aktarim_is_invent_again)>
            <input type="hidden" name="aktarim_is_invent_again" id="aktarim_is_invent_again" value="<cfoutput>#attributes.aktarim_is_invent_again#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_date_kontrol') and len(attributes.aktarim_is_date_kontrol)>
            <input type="hidden" name="aktarim_is_date_kontrol" id="aktarim_is_date_kontrol" value="<cfoutput>#attributes.aktarim_is_date_kontrol#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_location_based_cost') and len(attributes.aktarim_is_location_based_cost)>
            <input type="hidden" name="aktarim_is_location_based_cost" id="aktarim_is_location_based_cost" value="<cfoutput>#attributes.aktarim_is_location_based_cost#</cfoutput>"></cfif>
			<input type="hidden" name="session_userid" id="session_userid" value="<cfoutput>#attributes.session_userid#</cfoutput>">
			<input type="hidden" name="session_period_id" id="session_period_id" value="<cfoutput>#attributes.session_period_id#</cfoutput>">
			<input type="hidden" name="session_money" id="session_money" value="<cfoutput>#attributes.session_money#</cfoutput>">
			<input type="hidden" name="session_money2" id="session_money2" value="<cfoutput>#attributes.session_money2#</cfoutput>">
			<cf_get_lang no ='2028.Kaynak Veri Tabanı'>: <cfoutput>#attributes.aktarim_kaynak_period# (#attributes.aktarim_kaynak_year#)</cfoutput><br/>
			<br /><br />
			<!--- <cfoutput>#toplam_kayit# ----#son_deger#</cfoutput> --->
			<cfif toplam_kayit gt son_deger>
                <input type="text" name="page" id="page" value="<cfoutput>#(attributes.page+1)#</cfoutput>">
                <input type="hidden" name="step" id="step" value="2">
                <input type="button" value="part_<cfoutput>#attributes.page#</cfoutput>" onClick="basamak_2();">
			<cfelseif x_is_prod_cost eq 1>
				<input type="hidden" name="step" id="step" value="3">
				<br /><br />
				<b><font color="FF0000">Sonraki İşlem : <cf_get_lang no ='2113.Üretim Maliyetlerinin Oluşması (Maliyetlerin Oluşturulması, Sarf, Üretim Çıkış Fişi ve Üretim Sonuç Satırlarının Güncellenmesi)'></font></b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
			<cfelseif x_is_total_cost eq 1>
				<input type="hidden" name="step" id="step" value="4">
				<br /><br />
				<b><font color="FF0000">Sonraki İşlem : Kümüle Maliyetlerin Oluşması</font></b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
			<cfelseif x_is_upd_inv eq 1>
				<input type="hidden" name="step" id="step" value="5">
				<br /><br />
				<b><font color="FF0000">Sonraki İşlem : Çıkış İşlemlerinin Güncellenmesi</font></b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
			<cfelse>
				<b><br /><br /><cf_get_lang no ='2109.Maliyet İşlemi Tamamlanmıştır'>!</b><cfabort>
			</cfif>
		</form>
	<cfelseif attributes.step eq 3>
		<!--- uretim maliyetlerinin eklenmesi --->
        <cfsavecontent variable="toplam_kayit_xxxx">
			<cfoutput>
                <br/><b>3.<cf_get_lang no ='2113.Üretim Maliyetlerinin Oluşması (Maliyetlerin Oluşturulması, Sarf, Üretim Çıkış Fişi ve Üretim Sonuç Satırlarının Güncellenmesi)'></b><br/>
            </cfoutput>
        </cfsavecontent>
        <cfoutput>
        	#toplam_kayit_xxxx#
        </cfoutput>
        <cfif attributes.page eq 1>
        	<cfset file_name = 'uretim_Maliyetleri'&dateformat(now(),'ddmmyyyy')&'_'&timeformat(now(),'HHMMl')&'_'&session.ep.userid>
            <cffile action="write" file="#download_folder#documents#dir_seperator#settings#dir_seperator##file_name#.txt" output="#REReplaceNoCase(toplam_kayit_xxxx, '<(.|\n)*?>', '', 'ALL')#" charset="utf-8">
            <cfquery name="add_maliyet_txt" datasource="#dsn#">
            	INSERT INTO COST_TXT 
                (
                	DOCUMENT_NAME,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#download_folder#documents#dir_seperator#settings#dir_seperator##file_name#.txt">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
            </cfquery>
            <cfset session.ep.file_name = "#download_folder#documents#dir_seperator#settings#dir_seperator##file_name#.txt">
        </cfif>
        
		<!--- maliyet islemi yapacak kategori varmi --->
		<cfquery name="GET_PROCESS_CAT" datasource="#kaynak_dsn3#">
			SELECT
				PROCESS_CAT_ID,
				PROCESS_TYPE,
				IS_COST
			FROM 
				SETUP_PROCESS_CAT
			WHERE 
				IS_COST = 1
		</cfquery>
		<cfset proc_list=valuelist(GET_PROCESS_CAT.PROCESS_CAT_ID,',')>
		<!--- malyiet olusturmamıs uretim sonucları --->
		<cfquery name="delete_GET_PROD" datasource="#kaynak_dsn3#">
       		IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_PROD_#session.ep.userid#')
        	DROP TABLE ####GET_PROD_#session.ep.userid#
        </cfquery>
        <cfquery name="GET_PROD_INSERT" datasource="#kaynak_dsn3#">
			SELECT
				4 ACTION_TYPE,
				2 QUERY_TYPE,
				PORR.PR_ORDER_ID ACTION_ID,
				POR.FINISH_DATE ACTION_DATE,<!--- bitisi aldık cunku bu uretim sırasında baska bir alt uretim varsa o uretim once --->
				PR_ORDER_ROW_ID,
				POR.PRODUCTION_ORDER_NO,
				POR.RESULT_NO,
				PORR.AMOUNT,
				PORR.PRODUCT_ID,
				PORR.STOCK_ID,
				PORR.KDV_PRICE TAX,
				POR.START_DATE,
                POR.FINISH_DATE,
				ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
				ISNULL(PORR.LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM
			INTO ####GET_PROD_#session.ep.userid#
            FROM 
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDER_RESULTS POR,
				PRODUCTION_ORDER_RESULTS_ROW PORR,
				#dsn1_alias#.STOCKS STOCKS,
				#dsn1_alias#.PRODUCT PRODUCT
			WHERE
			<cfif not isdefined('attributes.aktarim_is_cost_again')>
				POR.PR_ORDER_ID NOT IN (SELECT ACTION_ID FROM #kaynak_dsn2#.PRODUCT_COST_REFERENCE WHERE ACTION_TYPE=4) AND
			</cfif>
				POR.PROCESS_ID IN (#proc_list#) AND
				PO.P_ORDER_ID = POR.P_ORDER_ID AND
                --PO.STOCK_ID = PORR.STOCK_ID AND
				POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
				STOCKS.STOCK_ID = PORR.STOCK_ID AND
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
				PRODUCT.IS_COST = 1 AND
				PORR.TYPE = 1 AND
				PO.IS_DEMONTAJ <> 1 AND
				ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
				POR.IS_STOCK_FIS=1
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
				<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
					AND	(
							<cfif not(isdefined("x_is_prod_record_date") and x_is_prod_record_date eq 1)>
								(
									1=1
									<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
										AND POR.RECORD_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
									</cfif>
									<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
										AND POR.RECORD_DATE < #dateadd('d',1,attributes.aktarim_date2)#
									</cfif>
								)
								OR
							</cfif>
							(
								1=1
								<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
									AND POR.FINISH_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								</cfif>
								<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
									AND POR.FINISH_DATE < #dateadd('d',1,attributes.aktarim_date2)#
								</cfif>
							)
					)
				</cfif>
				<cfif len(attributes.aktarim_paper_no)>
					AND POR.PRODUCTION_ORDER_NO = '#attributes.aktarim_paper_no#'
				</cfif>
			ORDER BY
				POR.FINISH_DATE,
                ISNULL((SELECT TOP 1 PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PRODUCT_ID = PORR.PRODUCT_ID AND TYPE=2),0) DESC,
				POR.RECORD_DATE DESC
		</cfquery>
        <cfquery name="GET_PROD" datasource="#kaynak_dsn3#">        
            WITH CTE1 AS (
            SELECT 
                * 
            FROM 
                ####GET_PROD_#session.ep.userid#
            ),
                CTE2 AS (
                    SELECT
                        CTE1.*,
                            ROW_NUMBER() OVER (ORDER BY FINISH_DATE) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
        </cfquery>
		<cfset attributes.is_print=1>
		<cfset attributes.dsn_type=kaynak_dsn3>
		<cfset attributes.period_dsn_type=kaynak_dsn2>
		<cfset attributes.query_type=2>
		<cfset attributes.user_id=session_userid>
		<cfset attributes.period_id=attributes.aktarim_kaynak_period>
		<cfset attributes.company_id=attributes.aktarim_kaynak_company>
		<cfset attributes.not_close_page=1>
		<cfloop query="GET_PROD">
			<cfsavecontent variable="text_123">
				<!--- SARF VE FİRE SATIRLARINI ALIYORUZ --->
                <cfquery name="GET_RESULT_SARF" datasource="#kaynak_dsn3#">
                    SELECT 
                        PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
                        PRODUCTION_ORDER_RESULTS.START_DATE,
                        PRODUCTION_ORDER_RESULTS.FINISH_DATE,
                        PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
                        PRODUCTION_ORDER_RESULTS_ROW.KDV_PRICE TAX,
                        PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
                        PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID,
                        ISNULL(PRODUCTION_ORDER_RESULTS_ROW.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
                        PRODUCT.IS_PRODUCTION,
                        ISNULL(PRODUCTION_ORDER_RESULTS_ROW.IS_MANUAL_COST,0) AS IS_MANUAL_COST,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_EXTRA_COST,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_EXTRA_COST_SYSTEM,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_2,
						PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_EXTRA_COST_SYSTEM_2,
						ISNULL(PRODUCTION_ORDER_RESULTS_ROW.STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
						ISNULL(PRODUCTION_ORDER_RESULTS_ROW.LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM
                    FROM
                        PRODUCTION_ORDERS,
                        PRODUCTION_ORDER_RESULTS,
                        PRODUCTION_ORDER_RESULTS_ROW,
                        #dsn1_alias#.STOCKS STOCKS,
                        #dsn1_alias#.PRODUCT PRODUCT
                    WHERE
                        <!---ISNULL(PRODUCTION_ORDER_RESULTS_ROW.IS_MANUAL_COST,0) <> 1 AND<!--- üretim sonuc satirinda maliyeti güncellenmesin secilenlerin maliyetleri guncellenmeyecek --->--->
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = #ACTION_ID# AND
                        IS_DEMONTAJ <> 1 AND
                        PRODUCTION_ORDER_RESULTS_ROW.TYPE IN(2,3)<!--- 2 SARF 3 FİRE ---> AND
                        STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
                        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                        PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND 
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID
                </cfquery>
                <cfset purchase_net_sarf_total=0>
                <cfset purchase_extra_sarf_total=0>
                <cfset purchase_extra_sarf_total_=0>
				<cfset extra_cost_total__=GET_PROD.STATION_REFLECTION_COST_SYSTEM+GET_PROD.LABOR_COST_SYSTEM>
                 
                <cfset purchase_net_sarf_total_2=0>
                <cfset purchase_extra_sarf_total_2=0>
                <!--- yansıyan maliyet çalışması PY --->
                <cfquery name="get_Related_prods" datasource="#dsn3#">
					SELECT 
						PO.PO_RELATED_ID
					FROM 
						PRODUCTION_ORDERS PO,
						PRODUCTION_ORDER_RESULTS POR
					WHERE 
						PO.P_ORDER_ID = POR.P_ORDER_ID AND
						POR.PR_ORDER_ID = #ACTION_ID#
				</cfquery>
				<cfif get_Related_prods.recordcount and len(get_Related_prods.PO_RELATED_ID)>
					<cfquery name="upd_rels" datasource="#dsn3#">
						UPDATE 
							PRODUCTION_ORDER_RESULTS_ROW
						SET
							LABOR_COST_SYSTEM = #GET_PROD.LABOR_COST_SYSTEM/AMOUNT#,
							STATION_REFLECTION_COST_SYSTEM = #GET_PROD.STATION_REFLECTION_COST_SYSTEM/AMOUNT#
						WHERE
							PR_ORDER_ROW_ID IN
							(
								SELECT 
									PRR.PR_ORDER_ROW_ID
								FROM
									PRODUCTION_ORDER_RESULTS PR JOIN 
									PRODUCTION_ORDER_RESULTS_ROW PRR ON PR.PR_ORDER_ID = PRR.PR_ORDER_ID
								WHERE
									PR.P_ORDER_ID = #get_Related_prods.PO_RELATED_ID#
									AND PRR.TYPE IN (2,3)
									AND PRR.STOCK_ID IN(SELECT S.STOCK_ID FROM STOCKS S WHERE S.IS_COST = 1)
									AND PRR.SPEC_MAIN_ID IS NOT NULL
									AND PRR.STOCK_ID IN (SELECT STOCK_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #ACTION_ID# AND TYPE = 1)
							)
					</cfquery>
				</cfif>
	                <!--- yansıyan maliyet çalışması PY --->
                 <cfloop query="GET_RESULT_SARF">
                    <cfquery name="GET_COST" datasource="#kaynak_dsn3#" maxrows="1">
                        SELECT
                            PRODUCT_COST_ID,
                            <cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
                            	ISNULL(PURCHASE_NET_LOCATION,0)  AS PURCHASE_NET,
                                ISNULL(PURCHASE_NET_MONEY_LOCATION,0)  AS PURCHASE_NET_MONEY,
                                ISNULL(PURCHASE_NET_SYSTEM_LOCATION,0)  AS PURCHASE_NET_SYSTEM,
                                ISNULL(PURCHASE_EXTRA_COST_LOCATION,0)  AS PURCHASE_EXTRA_COST,
                                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0)  AS PURCHASE_EXTRA_COST_SYSTEM,
                                ISNULL(PURCHASE_NET_SYSTEM_MONEY_LOCATION,0)  AS PURCHASE_NET_SYSTEM_MONEY,
                                ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION,0)  AS PURCHASE_NET_SYSTEM_2,
								ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,0)  AS PURCHASE_EXTRA_COST_SYSTEM_2,
								ISNULL(LABOR_COST_SYSTEM_LOCATION,0)  AS LABOR_COST_SYSTEM,
								ISNULL(STATION_REFLECTION_COST_SYSTEM_LOCATION,0)  AS STATION_REFLECTION_COST_SYSTEM
                            <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
                            	ISNULL(PURCHASE_NET_DEPARTMENT,0)  AS PURCHASE_NET,
                                ISNULL(PURCHASE_NET_MONEY_DEPARTMENT,0)  AS PURCHASE_NET_MONEY,
                                ISNULL(PURCHASE_NET_SYSTEM_DEPARTMENT,0)  AS PURCHASE_NET_SYSTEM,
                                ISNULL(PURCHASE_EXTRA_COST_DEPARTMENT,0)  AS PURCHASE_EXTRA_COST,
                                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT,0)  AS PURCHASE_EXTRA_COST_SYSTEM,
                                ISNULL(PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT,0)  AS PURCHASE_NET_SYSTEM_MONEY,
                                ISNULL(PURCHASE_NET_SYSTEM_2_DEPARTMENT,0)  AS PURCHASE_NET_SYSTEM_2,
								ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_DEPARTMENT,0)  AS PURCHASE_EXTRA_COST_SYSTEM_2,
								ISNULL(LABOR_COST_SYSTEM_DEPARTMENT,0)  AS LABOR_COST_SYSTEM,
								ISNULL(STATION_REFLECTION_COST_DEPARTMENT,0)  AS STATION_REFLECTION_COST_SYSTEM
                            <cfelse>
                            	ISNULL(PURCHASE_NET,0) AS PURCHASE_NET,
                                ISNULL(PURCHASE_NET_MONEY,0) AS PURCHASE_NET_MONEY,
                                ISNULL(PURCHASE_NET_SYSTEM,0) PURCHASE_NET_SYSTEM,
                                ISNULL(PURCHASE_EXTRA_COST,0) AS PURCHASE_EXTRA_COST,
                                ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) AS PURCHASE_EXTRA_COST_SYSTEM,
                                ISNULL(PURCHASE_NET_SYSTEM_MONEY,0) AS PURCHASE_NET_SYSTEM_MONEY,
                                ISNULL(PURCHASE_NET_SYSTEM_2,0) AS PURCHASE_NET_SYSTEM_2,
								ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0)  AS PURCHASE_EXTRA_COST_SYSTEM_2,
								ISNULL(LABOR_COST_SYSTEM,0)  AS LABOR_COST_SYSTEM,
                                ISNULL(STATION_REFLECTION_COST_SYSTEM,0)  AS STATION_REFLECTION_COST_SYSTEM
                            </cfif>
                        FROM
                            PRODUCT_COST
                        WHERE
                            PRODUCT_ID = #GET_RESULT_SARF.PRODUCT_ID#
                            AND START_DATE <= #createodbcdatetime(GET_RESULT_SARF.FINISH_DATE)#
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								AND ISNULL(SPECT_MAIN_ID,0)<cfif GET_RESULT_SARF.SPECT_MAIN_ID gte 0>=#GET_RESULT_SARF.SPECT_MAIN_ID#<cfelse> IS NULL</cfif>
							</cfif>
                            <cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
                                AND LOCATION_ID = #GET_RESULT_SARF.EXIT_LOC_ID#
                                AND DEPARTMENT_ID = #GET_RESULT_SARF.EXIT_DEP_ID#
                             <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
                                AND DEPARTMENT_ID = #GET_RESULT_SARF.EXIT_DEP_ID#
                            </cfif>
                        ORDER BY
                            START_DATE DESC, RECORD_DATE DESC, PRODUCT_COST_ID DESC
                    </cfquery>
                    <cfif GET_COST.RECORDCOUNT>
                    	<cfset amount_=GET_PROD.AMOUNT>
                        <cfset other_money_=GET_COST.PURCHASE_NET_MONEY>
                        <cfif GET_RESULT_SARF.is_manual_cost eq 1>
							<cfset price_=GET_RESULT_SARF.PURCHASE_NET_SYSTEM>
                            <cfset extra_cost_=wrk_round(GET_RESULT_SARF.PURCHASE_EXTRA_COST_SYSTEM,8,1)>
                            <cfset price_other_=GET_RESULT_SARF.PURCHASE_NET>
                            <cfset total_=GET_RESULT_SARF.PURCHASE_NET_SYSTEM*AMOUNT>
                            <cfset extra_cost_total_=wrk_round(GET_RESULT_SARF.PURCHASE_EXTRA_COST_SYSTEM,8,1)*AMOUNT>
                            <cfset extra_cost_other_=wrk_round(GET_RESULT_SARF.PURCHASE_EXTRA_COST,8,1)>
                            <cfset total_price_2_ = GET_RESULT_SARF.PURCHASE_NET_2*AMOUNT>
							<cfset extra_cost_total_2_ = GET_RESULT_SARF.PURCHASE_EXTRA_COST_SYSTEM_2*AMOUNT>
							<cfset reflection_cost_ = wrk_round(GET_RESULT_SARF.STATION_REFLECTION_COST_SYSTEM,8,1)>
                            <cfset labor_cost_ = wrk_round(GET_RESULT_SARF.LABOR_COST_SYSTEM,8,1)>
                        <cfelse>
                        	<cfset price_=GET_COST.PURCHASE_NET_SYSTEM>
                            <cfset extra_cost_=wrk_round(GET_COST.PURCHASE_EXTRA_COST_SYSTEM,8,1)>
                            <cfset price_other_=GET_COST.PURCHASE_NET>
                            <cfset total_=GET_COST.PURCHASE_NET_SYSTEM*AMOUNT>
                            <cfset extra_cost_total_=wrk_round(GET_COST.PURCHASE_EXTRA_COST_SYSTEM,8,1)*AMOUNT>
                            <cfset extra_cost_other_=wrk_round(GET_COST.PURCHASE_EXTRA_COST,8,1)>
                            
                            <cfset total_price_2_ = GET_COST.PURCHASE_NET_SYSTEM_2*AMOUNT>
							<cfset extra_cost_total_2_ = GET_COST.PURCHASE_EXTRA_COST_SYSTEM_2*AMOUNT>
							<cfset reflection_cost_ = wrk_round(GET_COST.STATION_REFLECTION_COST_SYSTEM,8,1)>
                            <cfset labor_cost_ = wrk_round(GET_COST.LABOR_COST_SYSTEM,8,1)>
                        </cfif>
                        <cfset other_total_=price_other_*AMOUNT>
                        
                        <cfif TAX gt 0>
                            <cfset total_tax_=((price_*AMOUNT)*TAX)/100>
                        <cfelse>
                            <cfset total_tax_=0>
                        </cfif>
                        <cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
                            UPDATE
                                STOCK_FIS_ROW
                            SET
                                TOTAL=#total_#,
                                TOTAL_TAX=#total_tax_#,
                                NET_TOTAL=#total_#,
                                PRICE=#price_#,
                                TAX=#TAX#,
                                OTHER_MONEY='#other_money_#',
                                PRICE_OTHER=#price_other_#,
                                COST_PRICE=#price_#,
                                EXTRA_COST=#extra_cost_#,
                                COST_ID=#GET_COST.PRODUCT_COST_ID#
                            WHERE
                                FIS_ID IN (
                                		SELECT 
                                            STOCK_FIS.FIS_ID
                                        FROM 
                                            STOCK_FIS,
                                            #kaynak_dsn3#.PRODUCTION_ORDER_RESULTS_ROW PRR
                                        WHERE 
                                            ISNULL(PRR.IS_MANUAL_COST,0) <> 1 AND
                                            PRR.PR_ORDER_ID = STOCK_FIS.PROD_ORDER_RESULT_NUMBER AND
                                            STOCK_FIS_ROW.STOCK_ID = PRR.STOCK_ID AND
                                            STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#PR_ORDER_ID#
                                            AND FIS_TYPE IN(111,112)
											)
                                AND STOCK_ID=#STOCK_ID#
                                AND AMOUNT=#AMOUNT#
                        </cfquery>
                        <cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
                            UPDATE
                                PRODUCTION_ORDER_RESULTS_ROW
                            SET
                                COST_ID=#GET_COST.PRODUCT_COST_ID#,
                                PURCHASE_NET_SYSTEM=#price_#,
                                PURCHASE_NET_SYSTEM_MONEY='#GET_COST.PURCHASE_NET_SYSTEM_MONEY#',
                                PURCHASE_EXTRA_COST_SYSTEM=#extra_cost_#,
                                PURCHASE_NET_SYSTEM_TOTAL=#total_#,
                                PURCHASE_NET=#price_other_#,
                                PURCHASE_NET_MONEY='#other_money_#',
                                PURCHASE_EXTRA_COST=#extra_cost_other_#,
                                PURCHASE_NET_TOTAL=#other_total_#,
								PURCHASE_NET_2 = #total_price_2_/amount#,
								STATION_REFLECTION_COST_SYSTEM = #reflection_cost_#,
                                LABOR_COST_SYSTEM = #labor_cost_#
                            WHERE
                                ISNULL(IS_MANUAL_COST,0) <> 1 AND<!--- üretim sonuc satirinda maliyeti güncellenmesin secilenlerin maliyetleri guncellenmeyecek --->
                                PR_ORDER_ROW_ID=#PR_ORDER_ROW_ID#
                        </cfquery>
                        <cfset purchase_net_sarf_total=purchase_net_sarf_total+total_>
                        <cfset purchase_extra_sarf_total=purchase_extra_sarf_total+extra_cost_total_>
                        <cfset purchase_extra_sarf_total_=purchase_extra_sarf_total_+extra_cost_total__>
                        <cfset purchase_net_sarf_total_2=purchase_net_sarf_total_2+total_price_2_>
		                <cfset purchase_extra_sarf_total_2=purchase_extra_sarf_total_2+extra_cost_total_2_>
                        
                    <cfelse>
                       <cfoutput> <font color="red"><cf_get_lang no ='2110.Üretim satırındaki Ürünün Kayıtlı Maliyeti Yok:'> <cf_get_lang_main no ='2252.Üretim Emri'>:#evaluate('GET_PROD.PRODUCTION_ORDER_NO[#GET_PROD.CURRENTROW#]')# <cf_get_lang no ='2112.Üretim Sonuç'>  ID:#evaluate('GET_PROD.RESULT_NO[#GET_PROD.CURRENTROW#]')# <cf_get_lang_main no='245.Ürün'> ID:#GET_RESULT_SARF.PRODUCT_ID# <cfif GET_RESULT_SARF.SPECT_MAIN_ID gt 0>Main Spec ID:#GET_RESULT_SARF.SPECT_MAIN_ID#</cfif></font><br/></cfoutput>
                        <cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
                            UPDATE
                                STOCK_FIS_ROW
                            SET
                                TOTAL=0,
                                TOTAL_TAX=0,
                                NET_TOTAL=0,
                                PRICE=0,
                                TAX=#TAX#,
                                OTHER_MONEY='#session_money2#',
                                PRICE_OTHER=0,
                                COST_PRICE=0,
                                EXTRA_COST=0,
                                COST_ID=NULL
                            WHERE
                                FIS_ID IN(
                                		SELECT 
                                            STOCK_FIS.FIS_ID
                                        FROM 
                                            STOCK_FIS,
                                            #kaynak_dsn3#.PRODUCTION_ORDER_RESULTS_ROW PRR
                                        WHERE 
                                            ISNULL(PRR.IS_MANUAL_COST,0) <> 1 AND
                                            PRR.PR_ORDER_ID = STOCK_FIS.PROD_ORDER_RESULT_NUMBER AND
                                            STOCK_FIS_ROW.STOCK_ID = PRR.STOCK_ID AND
                                            STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#PR_ORDER_ID#
                                            AND FIS_TYPE IN(111,112)	
										)
                                AND STOCK_ID=#STOCK_ID#
                        </cfquery>
                        <cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
                            UPDATE
                                PRODUCTION_ORDER_RESULTS_ROW
                            SET
                                COST_ID=NULL,
                                PURCHASE_NET_SYSTEM=0,
                                PURCHASE_NET_SYSTEM_MONEY='#session_money#',
                                PURCHASE_EXTRA_COST_SYSTEM=0,
                                PURCHASE_NET_SYSTEM_TOTAL=0,
                                PURCHASE_NET=0,
                                PURCHASE_NET_MONEY='#session_money2#',
                                PURCHASE_EXTRA_COST=0,
                                PURCHASE_NET_TOTAL=0,
								PURCHASE_NET_2 = 0,
								STATION_REFLECTION_COST_SYSTEM = 0,
								LABOR_COST_SYSTEM = 0
                            WHERE
                                ISNULL(IS_MANUAL_COST,0) <> 1 AND<!--- üretim sonuc satirinda maliyeti güncellenmesin secilenlerin maliyetleri guncellenmeyecek --->
                                PR_ORDER_ROW_ID=#PR_ORDER_ROW_ID#
                        </cfquery>
                    </cfif>
                </cfloop>
                <cfquery name="GET_STANDART_COST_MONEY_PURCHASE" datasource="#kaynak_dsn3#">
                    SELECT 
                        MAX(PRICE) AS PRICE,
                        MONEY 
                    FROM
                        PRICE_STANDART
                    WHERE
                        PRODUCT_ID=#GET_PROD.PRODUCT_ID# AND
                        PURCHASESALES=0 AND
                        PRICESTANDART_STATUS=1
                    GROUP BY MONEY
                </cfquery>
                <cfif GET_STANDART_COST_MONEY_PURCHASE.RECORDCOUNT and GET_STANDART_COST_MONEY_PURCHASE.PRICE>
                    <cfset cost_money = GET_STANDART_COST_MONEY_PURCHASE.MONEY>
                <cfelse>
                    <cfset cost_money = session_money2>
                </cfif>
                <cfif cost_money neq session_money>
                    <cfquery name="GET_MONEY" datasource="#dsn#">
                        SELECT
                            (RATE2/RATE1) AS RATE,MONEY 
                        FROM 
                            MONEY_HISTORY
                        WHERE 
                            VALIDATE_DATE <= #CreateODBCDatetime(GET_PROD.ACTION_DATE)#
                            AND PERIOD_ID = #session_period_id#
                            AND MONEY = '#cost_money#'
                        ORDER BY 
                            MONEY_HISTORY_ID DESC
                    </cfquery>
                    <cfif GET_MONEY.RECORDCOUNT and len(GET_MONEY.RATE)>
                        <cfset rate_=GET_MONEY.RATE>
                    <cfelse>
                        <cfquery name="GET_MONEY" datasource="#kaynak_dsn2#">
                            SELECT
                                (RATE2/RATE1) AS RATE,MONEY 
                            FROM 
                                SETUP_MONEY
                            WHERE
                                PERIOD_ID = #session_period_id#
                                AND MONEY = '#cost_money#'
                        </cfquery>
                        <cfset rate_=GET_MONEY.RATE>
                    </cfif>
                <cfelse>
                    <cfset rate_=1>
                </cfif>
                <cfif purchase_net_sarf_total gt 0 AND GET_PROD.AMOUNT gt 0 AND rate_ gt 0>
                    <cfset total_net=(purchase_net_sarf_total/GET_PROD.AMOUNT)/rate_>
                <cfelse>
                    <cfset total_net=0>
                </cfif>
                <cfif purchase_extra_sarf_total gt 0 AND GET_PROD.AMOUNT gt 0 AND rate_ gt 0>
                    <cfset total_extra=(purchase_extra_sarf_total/GET_PROD.AMOUNT)/rate_>
                <cfelse>
                    <cfset total_extra=0>
                </cfif>
                <cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
                    UPDATE
                        PRODUCTION_ORDER_RESULTS_ROW
                    SET
                        COST_ID=NULL,
                        PURCHASE_NET_SYSTEM=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
                        PURCHASE_NET_SYSTEM_MONEY='#session.ep.money#',
                        PURCHASE_EXTRA_COST_SYSTEM=#purchase_extra_sarf_total/GET_PROD.AMOUNT#,
                        PURCHASE_NET_SYSTEM_TOTAL=#purchase_net_sarf_total#,
                        PURCHASE_NET=#total_net#,
                        PURCHASE_NET_MONEY='#cost_money#',
                        PURCHASE_EXTRA_COST=#total_extra#,
                        PURCHASE_NET_TOTAL=#total_net#*#GET_PROD.AMOUNT#,
                        PURCHASE_NET_2 = #purchase_net_sarf_total_2/GET_PROD.AMOUNT#,
                        PURCHASE_EXTRA_COST_SYSTEM_2 = #purchase_extra_sarf_total_2/GET_PROD.AMOUNT#
                    WHERE
                        PR_ORDER_ROW_ID=#GET_PROD.PR_ORDER_ROW_ID#
                </cfquery>
                <cfif GET_PROD.TAX gt 0>
                    <cfset total_tax_=((purchase_net_sarf_total/GET_PROD.AMOUNT)*GET_PROD.TAX)/100>
                <cfelse>
                    <cfset total_tax_=0>
                </cfif>
                <cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
                    UPDATE
                        STOCK_FIS_ROW
                    SET
                        TOTAL=#purchase_net_sarf_total#,
                        TOTAL_TAX=#total_tax_#,
                        NET_TOTAL=#purchase_net_sarf_total#,
                        PRICE=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
                        TAX=#GET_PROD.TAX#,
                        OTHER_MONEY='#cost_money#',
                        PRICE_OTHER=#total_net#,
                        COST_PRICE=#(purchase_net_sarf_total+purchase_extra_sarf_total)/GET_PROD.AMOUNT#,
                        EXTRA_COST=#extra_cost_total__#,
                        COST_ID=NULL
                    WHERE
                        FIS_ID IN(SELECT 
                                    STOCK_FIS.FIS_ID
                                FROM 
                                    STOCK_FIS
                                WHERE 
                                    STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#ACTION_ID#
                                    AND FIS_TYPE = 110)
                        AND STOCK_ID=#GET_PROD.STOCK_ID#
                        AND AMOUNT=#GET_PROD.AMOUNT#
                </cfquery>
                <cfoutput>#currentrow#-<cf_get_lang dictionary_id ='49884.Üretim Emri'>No:#PRODUCTION_ORDER_NO# <cf_get_lang no ='1296.Üretim Sonuç No'>:#GET_PROD.RESULT_NO# <cf_get_lang_main no ='330.Tarih'> :#dateformat(ACTION_DATE,'dd:mm:yyyy')#<br /></cfoutput>
                <cfset attributes.action_type=4>
                <cfset attributes.control_type=0>
                <cfset attributes.action_id=ACTION_ID>
                <cfinclude template="../../objects/query/cost_action.cfm">
				<cfset son_deger = GET_PROD.rownum >
                <cfset toplam_kayit = GET_PROD.QUERY_COUNT>
            </cfsavecontent>
			<cfoutput>#text_123#</cfoutput>
            <cffile action="append" addnewline="yes" file="#session.ep.file_name#" output="#REReplaceNoCase(text_123, '<(.|\n)*?>', '', 'ALL')#" charset="utf-8">
		</cfloop>
		<form action="" name="form1_" method="post" id="step3">
			<cfif isdefined("attributes.is_oto")>
        		<input type="hidden" name="is_oto" id="is_oto" value="1" />
        	</cfif>
            <input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#attributes.aktarim_kaynak_period#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#attributes.aktarim_kaynak_year#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#attributes.aktarim_kaynak_company#</cfoutput>">
			<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfif isdate(attributes.aktarim_date1)><cfoutput>#dateformat(attributes.aktarim_date1,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfif isdate(attributes.aktarim_date2)><cfoutput>#dateformat(attributes.aktarim_date2,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_product_name" id="aktarim_product_name" value="<cfoutput>#attributes.aktarim_product_name#</cfoutput>">
			<input type="hidden" name="aktarim_product_id" id="aktarim_product_id" value="<cfoutput>#attributes.aktarim_product_id#</cfoutput>">
			<input type="hidden" name="aktarim_paper_no" id="aktarim_paper_no" value="<cfoutput>#attributes.aktarim_paper_no#</cfoutput>">
			<cfif isdefined('attributes.aktarim_is_cost_again') and len(attributes.aktarim_is_cost_again)>
            <input type="hidden" name="aktarim_is_cost_again" id="aktarim_is_cost_again" value="<cfoutput>#attributes.aktarim_is_cost_again#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_invent_again') and len(attributes.aktarim_is_invent_again)>
            <input type="hidden" name="aktarim_is_invent_again" id="aktarim_is_invent_again" value="<cfoutput>#attributes.aktarim_is_invent_again#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_location_based_cost') and len(attributes.aktarim_is_location_based_cost)>
            <input type="hidden" name="aktarim_is_location_based_cost" id="aktarim_is_location_based_cost" value="<cfoutput>#attributes.aktarim_is_location_based_cost#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_date_kontrol') and len(attributes.aktarim_is_date_kontrol)>
            <input type="hidden" name="aktarim_is_date_kontrol" id="aktarim_is_date_kontrol" value="<cfoutput>#attributes.aktarim_is_date_kontrol#</cfoutput>"></cfif>
			<input type="hidden" name="session_userid" id="session_userid" value="<cfoutput>#attributes.session_userid#</cfoutput>">
			<input type="hidden" name="session_period_id" id="session_period_id" value="<cfoutput>#attributes.session_period_id#</cfoutput>">
			<input type="hidden" name="session_money" id="session_money" value="<cfoutput>#attributes.session_money#</cfoutput>">
			<input type="hidden" name="session_money2" id="session_money2" value="<cfoutput>#attributes.session_money2#</cfoutput>">
			<cf_get_lang no ='2028.Kaynak Veri Tabanı'>: <cfoutput>#attributes.aktarim_kaynak_period# (#attributes.aktarim_kaynak_year#)</cfoutput><br/>
			<cfif isdefined("toplam_kayit") and isdefined("son_deger") and  (toplam_kayit gt son_deger) >
                <input type="text" name="page" id="page" value="<cfoutput>#(attributes.page+1)#</cfoutput>">
                <input type="hidden" name="step" id="step" value="3">
                <input type="button" value="part_<cfoutput>#attributes.page#</cfoutput>" onClick="basamak_2();">
			<cfelseif x_is_total_cost eq 1>
				<input type="hidden" name="step" id="step" value="4">
				<br /><br />
				<b><font color="FF0000">Sonraki İşlem : Kümüle Maliyetlerin Oluşması</font></b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
			<cfelseif x_is_upd_inv eq 1>
				<input type="hidden" name="step" id="step" value="5">
				<br /><br />
				<b><font color="FF0000">Sonraki İşlem : Çıkış İşlemlerinin Güncellenmesi</font></b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
			<cfelse>
				<b><br /><br /><cf_get_lang no ='2109.Maliyet İşlemi Tamamlanmıştır'>!</b><cfabort>
			</cfif>
		</form>
	<cfelseif attributes.step eq 4>
		<!--- Kümüle maliyet oluşturma  --->
		<br/><b>4. Kümüle Maliyetlerin Oluşması</b><br/>
		<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) and isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
			<cfquery name="get_all_cost" datasource="#kaynak_dsn3#">
				SELECT
					SUM(ACTION_AMOUNT) TOTAL_AMOUNT,
					ISNULL((SELECT 
						   SUM(SR.STOCK_IN-SR.STOCK_OUT)
					 FROM
							#kaynak_dsn2#.STOCKS_ROW SR
						WHERE
							SR.PRODUCT_ID = T1.PRODUCT_ID
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(T1.SPECT_MAIN_ID,0)
							</cfif>
							AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
					),0) AVAILABLE_STOCK_,					
					SUM(ACTION_ROW_PRICE*ACTION_AMOUNT)/SUM(ACTION_AMOUNT) TOTAL_COST,
					SUM(ACTION_ROW_PRICE/NULLIF(RATE2,0)*ACTION_AMOUNT)/SUM(ACTION_AMOUNT) TOTAL_COST_2,
					SUM(ISNULL(ACTION_EXTRA_COST,0)*ACTION_EXTRA_AMOUNT)/SUM(ACTION_AMOUNT) EXTRA_COST,
					SUM(ISNULL(ACTION_EXTRA_COST,0)/NULLIF(RATE2,0)*ACTION_EXTRA_AMOUNT)/SUM(ACTION_AMOUNT) EXTRA_COST_2,
					PRODUCT_ID,
					PRODUCT_UNIT_ID,
					0 SPECT_MAIN_ID
				FROM
				(
					SELECT
						CASE WHEN ACTION_TYPE<> -2
                        THEN
							ROUND(PC.ACTION_ROW_PRICE,4)
                        ELSE
                        	ROUND((PC.PURCHASE_NET_SYSTEM+PC.PURCHASE_EXTRA_COST_SYSTEM),4)
                        END AS ACTION_ROW_PRICE,
						CASE WHEN ACTION_ID IS NOT NULL
						THEN
							CASE WHEN ACTION_PROCESS_TYPE = 62 THEN -1*PC.ACTION_AMOUNT ELSE PC.ACTION_AMOUNT END
						ELSE
						ISNULL((SELECT 
									   SUM(SR.STOCK_IN-SR.STOCK_OUT)
								 FROM
										#kaynak_dsn2#.STOCKS_ROW SR
									WHERE
										SR.PRODUCT_ID = PC.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0)
										</cfif>
										AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
								),0)
						END AS ACTION_AMOUNT,
                        CASE WHEN ACTION_ID IS NOT NULL
						THEN
							CASE WHEN ACTION_PROCESS_TYPE = 62 THEN -1*PC.ACTION_AMOUNT ELSE PC.ACTION_AMOUNT END
						ELSE
						ISNULL((SELECT 
									   SUM(SR.STOCK_IN-SR.STOCK_OUT)
								 FROM
										#kaynak_dsn2#.STOCKS_ROW SR
									WHERE
										SR.PRODUCT_ID = PC.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0)
										</cfif>
										AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
								),0)
						END AS ACTION_EXTRA_AMOUNT,
						PC.PURCHASE_EXTRA_COST,
						PC.ACTION_EXTRA_COST,
						ISNULL(PC.PURCHASE_NET_SYSTEM/NULLIF(PC.PURCHASE_NET_SYSTEM_2,0),0) RATE2,
						PC.PRODUCT_ID,
						PC.UNIT_ID PRODUCT_UNIT_ID,
						ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID
					FROM
						PRODUCT_COST PC,
						PRODUCT P
					WHERE
						--PC.PURCHASE_NET_SYSTEM > 0 AND 
                        P.PRODUCT_ID = PC.PRODUCT_ID
                       AND (PC.ACTION_PROCESS_TYPE NOT IN(811,55) OR ACTION_PROCESS_TYPE IS NULL) 
						<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
							AND P.PRODUCT_ID = #attributes.aktarim_product_id#
						</cfif>
                        --AND P.PRODUCT_ID = 2500
						AND 
						(
							(
								PC.START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.START_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
								AND ACTION_ID IS NOT NULL
							)
							OR
							(
								PC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE PCC.PRODUCT_ID = PC.PRODUCT_ID 
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									AND ISNULL(PCC.SPECT_MAIN_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0) 
								</cfif>
								AND PCC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> 
								ORDER BY PCC.START_DATE DESC)
							)
						)					
                   UNION ALL
                   SELECT
						(SELECT
								TOP 1 
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										ROUND((PURCHASE_NET_SYSTEM_LOCATION_ALL),8)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT_ALL),8)
									<cfelse>
										ROUND((PURCHASE_NET_SYSTEM_ALL),8)
									</cfif>
								FROM 
									#kaynak_dsn3#.PRODUCT_COST GPCP
								WHERE
									GPCP.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
									AND GPCP.PRODUCT_ID = PC.PRODUCT_ID
                                    AND GPCP.ACTION_TYPE=-2
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(PC.SPECT_MAIN_ID,0)
									</cfif>
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										AND GPCP.LOCATION_ID = PC.LOCATION_ID
										AND GPCP.DEPARTMENT_ID = PC.DEPARTMENT_ID
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										AND GPCP.DEPARTMENT_ID = PC.DEPARTMENT_ID
									</cfif>
									ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC) ACTION_ROW_PRICE,
						CASE WHEN ACTION_ID IS NOT NULL
						THEN
							CASE WHEN ACTION_PROCESS_TYPE = 62 THEN -1*PC.ACTION_AMOUNT ELSE PC.ACTION_AMOUNT END
						ELSE
						ISNULL((SELECT 
									   SUM(SR.STOCK_IN-SR.STOCK_OUT)
								 FROM
										#kaynak_dsn2#.STOCKS_ROW SR
									WHERE
										SR.PRODUCT_ID = PC.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0)
										</cfif>
										AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
								),0)
						END AS ACTION_AMOUNT,
                        CASE WHEN ACTION_ID IS NOT NULL
						THEN
							CASE WHEN ACTION_PROCESS_TYPE = 62 THEN -1*PC.ACTION_AMOUNT ELSE PC.ACTION_AMOUNT END
						ELSE
						ISNULL((SELECT 
									   SUM(SR.STOCK_IN-SR.STOCK_OUT)
								 FROM
										#kaynak_dsn2#.STOCKS_ROW SR
									WHERE
										SR.PRODUCT_ID = PC.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0)
										</cfif>
										AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
								),0)
						END AS ACTION_EXTRA_AMOUNT,
						PC.PURCHASE_EXTRA_COST,
						PC.ACTION_EXTRA_COST,
						ISNULL(PC.PURCHASE_NET_SYSTEM/NULLIF(PC.PURCHASE_NET_SYSTEM_2,0),0) RATE2,
						PC.PRODUCT_ID,
						PC.UNIT_ID PRODUCT_UNIT_ID,
						ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID
					FROM
						PRODUCT_COST PC,
						PRODUCT P
					WHERE
						--PC.PURCHASE_NET_SYSTEM > 0 AND 
                        P.PRODUCT_ID = PC.PRODUCT_ID
                        AND PC.ACTION_PROCESS_TYPE = 55
						<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
							AND P.PRODUCT_ID = #attributes.aktarim_product_id#
						</cfif>
                        --AND P.PRODUCT_ID = 2500
						AND 
						(
							(
								PC.START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.START_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
								AND ACTION_ID IS NOT NULL
							)
							OR
							(
								PC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE PCC.PRODUCT_ID = PC.PRODUCT_ID 
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									AND ISNULL(PCC.SPECT_MAIN_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0) 
								</cfif>
								AND PCC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> 
								ORDER BY PCC.START_DATE DESC)
							)
						)
                     UNION ALL
                     SELECT
						0 ACTION_ROW_PRICE,
						0 AS ACTION_AMOUNT,
                        PC.ACTION_AMOUNT ACTION_EXTRA_AMOUNT,
						PC.PURCHASE_EXTRA_COST,
						PC.ACTION_EXTRA_COST ACTION_EXTRA_COST,
						ISNULL(PC.PURCHASE_NET_SYSTEM/NULLIF(PC.PURCHASE_NET_SYSTEM_2,0),0) RATE2,
						PC.PRODUCT_ID,
						PC.UNIT_ID PRODUCT_UNIT_ID,
						ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID
					FROM
						PRODUCT_COST PC,
						PRODUCT P
					WHERE
						P.PRODUCT_ID = PC.PRODUCT_ID
                        AND PC.ACTION_PROCESS_TYPE=811
						<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
							AND P.PRODUCT_ID = #attributes.aktarim_product_id#
						</cfif>
                        --AND P.PRODUCT_ID = 2500
						AND 
						(
							(
								PC.START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.START_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
								AND ACTION_ID IS NOT NULL
							)
							OR
							(
								PC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE PCC.PRODUCT_ID = PC.PRODUCT_ID 
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									AND ISNULL(PCC.SPECT_MAIN_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0) 
								</cfif>
								AND PCC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> 
								ORDER BY PCC.START_DATE DESC)
							)
						)

				)T1
				GROUP BY
					PRODUCT_ID,
					PRODUCT_UNIT_ID
                    <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                    ,T1.SPECT_MAIN_ID
                    </cfif>
				HAVING
					SUM(ACTION_AMOUNT) > 0
			</cfquery>
			<cfoutput query="get_all_cost">
				<cfif len(total_cost)>
					<cfquery name="add_cost" datasource="#kaynak_dsn3#">
						INSERT INTO
							#dsn1_alias#.PRODUCT_COST
								(
									PRODUCT_COST_STATUS,
									INVENTORY_CALC_TYPE,
									COST_TYPE_ID,
									START_DATE,
									PRODUCT_ID,
									UNIT_ID,
									IS_SPEC,
									IS_STANDARD_COST,
									IS_ACTIVE_STOCK,
									IS_PARTNER_STOCK,
									COST_DESCRIPTION,
									ACTION_ID,
									ACTION_TYPE,
									ACTION_PERIOD_ID,
									ACTION_AMOUNT,
									ACTION_ROW_ID,											
									AVAILABLE_STOCK,
									PARTNER_STOCK,
									ACTIVE_STOCK,
									PRODUCT_COST,
									MONEY,
									STANDARD_COST,
									STANDARD_COST_MONEY,
									STANDARD_COST_RATE,
									PURCHASE_NET,
									PURCHASE_NET_MONEY,
									PURCHASE_EXTRA_COST,
									PRICE_PROTECTION,
									PRICE_PROTECTION_MONEY,
									PURCHASE_NET_SYSTEM,
									PURCHASE_NET_SYSTEM_MONEY,
									PURCHASE_EXTRA_COST_SYSTEM,
									PURCHASE_NET_SYSTEM_2,
									PURCHASE_NET_SYSTEM_MONEY_2,
									PURCHASE_EXTRA_COST_SYSTEM_2,					
									SPECT_MAIN_ID,
									RECORD_DATE,
									RECORD_EMP,
									RECORD_IP
								)
							VALUES
								(
									0,
									3,
									NULL,
									#attributes.aktarim_date1#,
									#get_all_cost.product_id#,
									#get_all_cost.product_unit_id#,
									<cfif len(spect_main_id)>1<cfelse>0</cfif>,
									0,
									0,
									0,
									NULL,											
									NULL,
									-2,<!--- kümüleden gelenler --->
									#attributes.aktarim_kaynak_period#,
									0,
									NULL,
									#AVAILABLE_STOCK_#,
									0,
									0,
									#wrk_round(total_cost+extra_cost,4)#,
									'#session.ep.money#',
									0,
									'#session.ep.money#',
									0,
									#total_cost#,
									'#session.ep.money#',
									#extra_cost#,
									0,
									'#session.ep.money#',
									#total_cost#,
									'#session.ep.money#',
									#extra_cost#,
									#total_cost_2#,
									'#session.ep.money2#',
									#extra_cost_2#,
									#spect_main_id#,
									#NOW()#,
									#SESSION.EP.USERID#,
									'#cgi.REMOTE_ADDR#'
								)
					</cfquery>
				 	<cfquery name="GET_P_COST_ID" datasource="#kaynak_dsn3#">
						SELECT
							MAX(PRODUCT_COST_ID) AS MAX_ID 
						FROM 
							#dsn1_alias#.PRODUCT_COST
					</cfquery>
					<cfset purchase_net_all = 0>
					<cfset purchase_net_all_location = 0>
					<cfset rate_other =1>
					<cfset rate_price = 1>
					<cfif total_cost_2 neq 0>
						<cfset rate_2 = wrk_round(total_cost/total_cost_2,4)>
					<cfelse>
						<cfset rate_2 =1>
					</cfif>
					<cfquery name="upd_cost" datasource="#dsn1#">
						UPDATE
							PRODUCT_COST
						SET
							PURCHASE_NET_ALL = PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
							PURCHASE_NET_SYSTEM_ALL = (PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
							PURCHASE_NET_SYSTEM_2_ALL = (PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#),
							PURCHASE_NET_LOCATION_ALL = PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
							PURCHASE_NET_SYSTEM_LOCATION_ALL = (PURCHASE_NET_SYSTEM_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
							PURCHASE_NET_SYSTEM_2_LOCATION_ALL = (PURCHASE_NET_SYSTEM_2_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#),
                            PURCHASE_NET_DEPARTMENT_ALL = PURCHASE_NET_DEPARTMENT + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
							PURCHASE_NET_SYSTEM_DEPARTMENT_ALL = (PURCHASE_NET_SYSTEM_DEPARTMENT + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
							PURCHASE_NET_SYSTEM_2_DEPARTMENT_ALL = (PURCHASE_NET_SYSTEM_2_DEPARTMENT + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#)
						WHERE
							PRODUCT_COST_ID = #GET_P_COST_ID.MAX_ID#
					</cfquery>
				</cfif>
			</cfoutput>
			<!--- Kümüle maliyetler oluştuktan sonra üretim sonuçları güncelleniyor --->
			<!--- maliyet islemi yapacak kategori varmi --->
			<cfquery name="GET_PROCESS_CAT" datasource="#kaynak_dsn3#">
				SELECT
					PROCESS_CAT_ID,
					PROCESS_TYPE,
					IS_COST
				FROM 
					SETUP_PROCESS_CAT
				WHERE 
					IS_COST = 1
			</cfquery>
			<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
				<cfset loop_count = 3>
			<cfelse>
				<cfset loop_count = 2>
			</cfif>
            <cfloop from="1" to="#loop_count#" index="kkk">
			<cfset proc_list=valuelist(GET_PROCESS_CAT.PROCESS_CAT_ID,',')>
			<!--- malyiet olusturmamıs uretim sonucları --->
			<cfquery name="GET_PROD" datasource="#kaynak_dsn3#">
				SELECT
					4 ACTION_TYPE,
					2 QUERY_TYPE,
					PORR.PR_ORDER_ID ACTION_ID,
					POR.FINISH_DATE ACTION_DATE,<!--- bitisi aldık cunku bu uretim sırasında baska bir alt uretim varsa o uretim once --->
					PR_ORDER_ROW_ID,
					POR.PRODUCTION_ORDER_NO,
					POR.RESULT_NO,
					PORR.AMOUNT,
					PORR.PRODUCT_ID,
					PORR.STOCK_ID,
					PORR.KDV_PRICE TAX,
					POR.START_DATE,
					ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
					ISNULL(PORR.LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM
				FROM 
					PRODUCTION_ORDERS PO,
					PRODUCTION_ORDER_RESULTS POR,
					PRODUCTION_ORDER_RESULTS_ROW PORR,
					#dsn1_alias#.STOCKS STOCKS,
					#dsn1_alias#.PRODUCT PRODUCT
				WHERE
					PO.P_ORDER_ID = POR.P_ORDER_ID AND
					POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
					PO.STOCK_ID = PORR.STOCK_ID AND
                    STOCKS.STOCK_ID = PORR.STOCK_ID AND
					STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
					PRODUCT.IS_COST = 1 AND
					PORR.TYPE = 1 AND
					PO.IS_DEMONTAJ <> 1 AND
					ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
					POR.IS_STOCK_FIS=1
					<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
						AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#
					</cfif>
					<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND	(
                                <cfif not(isdefined("x_is_prod_record_date") and x_is_prod_record_date eq 1)>
                                    (
                                        1=1
                                        <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                            AND POR.RECORD_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                        </cfif>
                                        <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
											AND POR.RECORD_DATE <= #dateadd('d',1,attributes.aktarim_date2)#
                                        </cfif>
                                    )
                                    OR
                                </cfif>
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND POR.FINISH_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                    <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND POR.FINISH_DATE < #dateadd('d',1,attributes.aktarim_date2)#
                                    </cfif>
                                )
                        )
                    </cfif>
					<cfif len(attributes.aktarim_paper_no)>
						AND POR.PRODUCTION_ORDER_NO = '#attributes.aktarim_paper_no#'
					</cfif>
				ORDER BY
					POR.FINISH_DATE,
					POR.RECORD_DATE DESC
			</cfquery>
			<cfset attributes.is_print=1>
			<cfset attributes.dsn_type=#kaynak_dsn3#>
			<cfset attributes.period_dsn_type=#kaynak_dsn2#>
			<cfset attributes.query_type=2>
			<cfset attributes.user_id=#session_userid#>
			<cfset attributes.period_id=#attributes.aktarim_kaynak_period#>
			<cfset attributes.company_id=#attributes.aktarim_kaynak_company#>
			<cfset attributes.not_close_page=1>
			<cfoutput query="GET_PROD">
				<!--- SARF VE FİRE SATIRLARINI ALIYORUZ --->
				<cfquery name="GET_RESULT_SARF" datasource="#kaynak_dsn3#">
					SELECT 
						PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
						PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
						PRODUCTION_ORDER_RESULTS.START_DATE,
						PRODUCTION_ORDER_RESULTS.FINISH_DATE,
						PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID,
						PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
						PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
						PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
						PRODUCTION_ORDER_RESULTS_ROW.KDV_PRICE TAX,
                        PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID,
                        PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
						ISNULL(PRODUCTION_ORDER_RESULTS_ROW.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
						PRODUCT.IS_PRODUCTION,
						ISNULL(PRODUCTION_ORDER_RESULTS_ROW.STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
						ISNULL(PRODUCTION_ORDER_RESULTS_ROW.LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM
					FROM
						PRODUCTION_ORDERS,
						PRODUCTION_ORDER_RESULTS,
						PRODUCTION_ORDER_RESULTS_ROW,
						#dsn1_alias#.STOCKS STOCKS,
						#dsn1_alias#.PRODUCT PRODUCT
					WHERE
						<!---ISNULL(PRODUCTION_ORDER_RESULTS_ROW.IS_MANUAL_COST,0) <> 1 AND<!--- üretim sonuc satirinda maliyeti güncellenmesin secilenlerin maliyetleri guncellenmeyecek --->--->
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = #ACTION_ID# AND
						IS_DEMONTAJ <> 1 AND
						PRODUCTION_ORDER_RESULTS_ROW.TYPE IN(2,3)<!--- 2 SARF 3 FİRE ---> AND
						STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
						STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
						PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND 
						PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID
				</cfquery>
				<cfset purchase_net_sarf_total=0>
				<cfset extra_cost_total__=GET_PROD.STATION_REFLECTION_COST_SYSTEM+GET_PROD.LABOR_COST_SYSTEM>
				<cfset purchase_extra_sarf_total=0>
				<cfloop query="GET_RESULT_SARF">
					<cfquery name="GET_COST" datasource="#kaynak_dsn3#" maxrows="1">
						SELECT
							PRODUCT_COST_ID,
                            <cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
                            	PURCHASE_NET_LOCATION AS PURCHASE_NET,
                                PURCHASE_NET_MONEY_LOCATION AS PURCHASE_NET_MONEY,
                                PURCHASE_NET_SYSTEM_LOCATION AS PURCHASE_NET_SYSTEM,
                                PURCHASE_EXTRA_COST_LOCATION AS PURCHASE_EXTRA_COST,
                                PURCHASE_EXTRA_COST_SYSTEM_LOCATION AS PURCHASE_EXTRA_COST_SYSTEM,
                                PURCHASE_NET_SYSTEM_MONEY_LOCATION AS PURCHASE_NET_SYSTEM_MONEY
                            <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
                            	PURCHASE_NET_DEPARTMENT AS PURCHASE_NET,
                                PURCHASE_NET_MONEY_DEPARTMENT AS PURCHASE_NET_MONEY,
                                PURCHASE_NET_SYSTEM_DEPARTMENT AS PURCHASE_NET_SYSTEM,
                                PURCHASE_EXTRA_COST_DEPARTMENT AS PURCHASE_EXTRA_COST,
                                PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT AS PURCHASE_EXTRA_COST_SYSTEM,
                                PURCHASE_NET_SYSTEM_MONEY_DEPARTMENT AS PURCHASE_NET_SYSTEM_MONEY
                            <cfelse>
                            	PURCHASE_NET AS PURCHASE_NET,
                                PURCHASE_NET_MONEY,
                                PURCHASE_NET_SYSTEM PURCHASE_NET_SYSTEM,
                                PURCHASE_EXTRA_COST,
                                PURCHASE_EXTRA_COST_SYSTEM,
                                PURCHASE_NET_SYSTEM_MONEY
                            </cfif>
						FROM
							PRODUCT_COST
						WHERE
							PRODUCT_ID = #GET_RESULT_SARF.PRODUCT_ID#
							AND START_DATE <= #createodbcdatetime(GET_RESULT_SARF.FINISH_DATE)#
							AND ISNULL(SPECT_MAIN_ID,0)<cfif GET_RESULT_SARF.SPECT_MAIN_ID gte 0>=#GET_RESULT_SARF.SPECT_MAIN_ID#<cfelse> IS NULL</cfif>
                            <cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
                                AND LOCATION_ID = #GET_RESULT_SARF.EXIT_LOC_ID#
                                AND DEPARTMENT_ID = #GET_RESULT_SARF.EXIT_DEP_ID#
                            <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
                                AND DEPARTMENT_ID = #GET_RESULT_SARF.EXIT_DEP_ID#
                            </cfif>
						ORDER BY
							ACTION_TYPE,START_DATE DESC, RECORD_DATE DESC, PRODUCT_COST_ID DESC
					</cfquery>
					<cfif GET_COST.RECORDCOUNT>
						<cfset price_=GET_COST.PURCHASE_NET_SYSTEM>
						<cfset amount_=AMOUNT>
						<cfset extra_cost_=GET_COST.PURCHASE_EXTRA_COST_SYSTEM>
						<cfset other_money_=GET_COST.PURCHASE_NET_MONEY>
						<cfset price_other_=GET_COST.PURCHASE_NET>
						<cfset other_total_=price_other_*AMOUNT>
						<cfset total_=GET_COST.PURCHASE_NET_SYSTEM*AMOUNT>
						<cfset extra_cost_total_=GET_COST.PURCHASE_EXTRA_COST_SYSTEM*AMOUNT>
						<cfif TAX gt 0>
							<cfset total_tax_=((price_*AMOUNT)*TAX)/100>
						<cfelse>
							<cfset total_tax_=0>
						</cfif>
						<cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
							UPDATE
								STOCK_FIS_ROW
							SET
								TOTAL=#total_#,
								TOTAL_TAX=#total_tax_#,
								NET_TOTAL=#total_#,
								PRICE=#price_#,
								TAX=#TAX#,
								OTHER_MONEY='#other_money_#',
								PRICE_OTHER=#price_other_#,
								COST_PRICE=#price_#,
								EXTRA_COST=#extra_cost_#,
								COST_ID=#GET_COST.PRODUCT_COST_ID#
							WHERE
								FIS_ID IN (
                                		SELECT 
                                            STOCK_FIS.FIS_ID
                                        FROM 
                                            STOCK_FIS,
                                            #kaynak_dsn3#.PRODUCTION_ORDER_RESULTS_ROW PRR
                                        WHERE 
                                            ISNULL(PRR.IS_MANUAL_COST,0) <> 1 AND
                                            PRR.PR_ORDER_ID = STOCK_FIS.PROD_ORDER_RESULT_NUMBER AND
                                            STOCK_FIS_ROW.STOCK_ID = PRR.STOCK_ID AND
                                            STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#PR_ORDER_ID#
                                            AND FIS_TYPE IN (111,112)
										)
								AND STOCK_ID=#STOCK_ID#
								AND AMOUNT=#AMOUNT#
						</cfquery>
						<cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
							UPDATE
								PRODUCTION_ORDER_RESULTS_ROW
							SET
								COST_ID=#GET_COST.PRODUCT_COST_ID#,
								PURCHASE_NET_SYSTEM=#price_#,
								PURCHASE_NET_SYSTEM_MONEY='#GET_COST.PURCHASE_NET_SYSTEM_MONEY#',
								PURCHASE_EXTRA_COST_SYSTEM=#extra_cost_#,
								PURCHASE_NET_SYSTEM_TOTAL=#total_#,
								PURCHASE_NET=#price_other_#,
								PURCHASE_NET_MONEY='#other_money_#',
								PURCHASE_EXTRA_COST=#GET_COST.PURCHASE_EXTRA_COST#,
								PURCHASE_NET_TOTAL=#other_total_#
							WHERE
								ISNULL(IS_MANUAL_COST,0) <> 1 AND<!--- üretim sonuc satirinda maliyeti güncellenmesin secilenlerin maliyetleri guncellenmeyecek --->
                                PR_ORDER_ROW_ID=#PR_ORDER_ROW_ID#
						</cfquery>
						<cfset purchase_net_sarf_total=purchase_net_sarf_total+total_>
						<cfset purchase_extra_sarf_total=purchase_extra_sarf_total+extra_cost_total_>
					<cfelse>
						<cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
							UPDATE
								STOCK_FIS_ROW
							SET
								TOTAL=0,
								TOTAL_TAX=0,
								NET_TOTAL=0,
								PRICE=0,
								TAX=#TAX#,
								OTHER_MONEY='#session_money2#',
								PRICE_OTHER=0,
								COST_PRICE=0,
								EXTRA_COST=0,
								COST_ID=NULL
							WHERE
								FIS_ID IN(
                                		SELECT 
                                            STOCK_FIS.FIS_ID
                                        FROM 
                                            STOCK_FIS,
                                            #kaynak_dsn3#.PRODUCTION_ORDER_RESULTS_ROW PRR
                                        WHERE 
                                            ISNULL(PRR.IS_MANUAL_COST,0) <> 1 AND
                                            PRR.PR_ORDER_ID = STOCK_FIS.PROD_ORDER_RESULT_NUMBER AND
                                            STOCK_FIS_ROW.STOCK_ID = PRR.STOCK_ID AND
                                            STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#PR_ORDER_ID#
                                            AND FIS_TYPE IN (111,112)
										)
								AND STOCK_ID=#STOCK_ID#
						</cfquery>
						<cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
							UPDATE
								PRODUCTION_ORDER_RESULTS_ROW
							SET
								COST_ID=NULL,
								PURCHASE_NET_SYSTEM=0,
								PURCHASE_NET_SYSTEM_MONEY='#session_money#',
								PURCHASE_EXTRA_COST_SYSTEM=0,
								PURCHASE_NET_SYSTEM_TOTAL=0,
								PURCHASE_NET=0,
								PURCHASE_NET_MONEY='#session_money2#',
								PURCHASE_EXTRA_COST=0,
								PURCHASE_NET_TOTAL=0
							WHERE
								ISNULL(IS_MANUAL_COST,0) <> 1 AND<!--- üretim sonuc satirinda maliyeti güncellenmesin secilenlerin maliyetleri guncellenmeyecek --->
                                PR_ORDER_ROW_ID=#PR_ORDER_ROW_ID#
						</cfquery>
					</cfif>
				</cfloop>				
				<cfquery name="GET_STANDART_COST_MONEY_PURCHASE" datasource="#kaynak_dsn3#">
					SELECT 
						MAX(PRICE) AS PRICE,
						MONEY 
					FROM
						PRICE_STANDART
					WHERE
						PRODUCT_ID=#GET_PROD.PRODUCT_ID# AND
						PURCHASESALES=0 AND
						PRICESTANDART_STATUS=1
					GROUP BY MONEY
				</cfquery>
				<cfif GET_STANDART_COST_MONEY_PURCHASE.RECORDCOUNT and GET_STANDART_COST_MONEY_PURCHASE.PRICE>
					<cfset cost_money = GET_STANDART_COST_MONEY_PURCHASE.MONEY>
				<cfelse>
					<cfset cost_money = session_money2>
				</cfif>
				<cfif cost_money neq session_money>
					<cfquery name="GET_MONEY" datasource="#dsn#">
						SELECT
							(RATE2/RATE1) AS RATE,MONEY 
						FROM 
							MONEY_HISTORY
						WHERE 
							VALIDATE_DATE <= #CreateODBCDatetime(GET_PROD.ACTION_DATE)#
							AND PERIOD_ID = #session_period_id#
							AND MONEY = '#cost_money#'
						ORDER BY 
							MONEY_HISTORY_ID DESC
					</cfquery>
					<cfif GET_MONEY.RECORDCOUNT and len(GET_MONEY.RATE)>
						<cfset rate_=GET_MONEY.RATE>
					<cfelse>
						<cfquery name="GET_MONEY" datasource="#kaynak_dsn2#">
							SELECT
								(RATE2/RATE1) AS RATE,MONEY 
							FROM 
								SETUP_MONEY
							WHERE
								PERIOD_ID = #session_period_id#
								AND MONEY = '#cost_money#'
						</cfquery>
						<cfset rate_=GET_MONEY.RATE>
					</cfif>
				<cfelse>
					<cfset rate_=1>
				</cfif>
				<cfif purchase_net_sarf_total gt 0 AND GET_PROD.AMOUNT gt 0 AND rate_ gt 0>
					<cfset total_net=(purchase_net_sarf_total/GET_PROD.AMOUNT)/rate_>
				<cfelse>
					<cfset total_net=0>
				</cfif>
				<cfif purchase_extra_sarf_total gt 0 AND GET_PROD.AMOUNT gt 0 AND rate_ gt 0>
					<cfset total_extra=(purchase_extra_sarf_total/GET_PROD.AMOUNT)/rate_>
				<cfelse>
					<cfset total_extra=0>
				</cfif>
	
				<cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
					UPDATE
						PRODUCTION_ORDER_RESULTS_ROW
					SET
						COST_ID=NULL,
						PURCHASE_NET_SYSTEM=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
						PURCHASE_NET_SYSTEM_MONEY='#session.ep.money#',
						PURCHASE_EXTRA_COST_SYSTEM=#purchase_extra_sarf_total/GET_PROD.AMOUNT#,
						PURCHASE_NET_SYSTEM_TOTAL=#purchase_net_sarf_total#,
						PURCHASE_NET=#total_net#,
						PURCHASE_NET_MONEY='#cost_money#',
						PURCHASE_EXTRA_COST=#total_extra#,
						PURCHASE_NET_TOTAL=#total_net#*#GET_PROD.AMOUNT#
					WHERE
						PR_ORDER_ROW_ID=#GET_PROD.PR_ORDER_ROW_ID#
				</cfquery>
				<cfif GET_PROD.TAX gt 0>
					<cfset total_tax_=((purchase_net_sarf_total/GET_PROD.AMOUNT)*GET_PROD.TAX)/100>
				<cfelse>
					<cfset total_tax_=0>
				</cfif>
				<cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
					UPDATE
						STOCK_FIS_ROW
					SET
						TOTAL=#purchase_net_sarf_total#,
						TOTAL_TAX=#total_tax_#,
						NET_TOTAL=#purchase_net_sarf_total#,
						PRICE=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
						TAX=#GET_PROD.TAX#,
						OTHER_MONEY='#cost_money#',
						PRICE_OTHER=#total_net#,
						COST_PRICE=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
						EXTRA_COST=#purchase_extra_sarf_total/GET_PROD.AMOUNT#,
						COST_ID=NULL
					WHERE
						FIS_ID IN(SELECT 
									STOCK_FIS.FIS_ID
								FROM 
									STOCK_FIS
								WHERE 
									STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#ACTION_ID#
									AND FIS_TYPE=110)
						AND STOCK_ID=#GET_PROD.STOCK_ID#
						AND AMOUNT=#GET_PROD.AMOUNT#
				</cfquery>
                <cfset attributes.action_type=4>
				<cfset attributes.control_type=-2>
                <cfset attributes.action_id=#ACTION_ID#>
                <cfinclude template="../../objects/query/cost_action.cfm">
			</cfoutput>
            <cfquery name="get_all_cost" datasource="#kaynak_dsn3#">
				SELECT
					SUM(ACTION_AMOUNT) TOTAL_AMOUNT,
					ISNULL((SELECT 
						   SUM(SR.STOCK_IN-SR.STOCK_OUT)
					 FROM
							#kaynak_dsn2#.STOCKS_ROW SR
						WHERE
							SR.PRODUCT_ID = T1.PRODUCT_ID
							<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
								AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(T1.SPECT_MAIN_ID,0)
							</cfif>
							AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
					),0) AVAILABLE_STOCK_,					
					SUM(ACTION_ROW_PRICE*ACTION_AMOUNT)/SUM(ACTION_AMOUNT) TOTAL_COST,
					SUM(ACTION_ROW_PRICE/NULLIF(RATE2,0)*ACTION_AMOUNT)/SUM(ACTION_AMOUNT) TOTAL_COST_2,
					SUM(ISNULL(ACTION_EXTRA_COST,0)*ACTION_EXTRA_AMOUNT)/SUM(ACTION_AMOUNT) EXTRA_COST,
					SUM(ISNULL(ACTION_EXTRA_COST,0)/NULLIF(RATE2,0)*ACTION_EXTRA_AMOUNT)/SUM(ACTION_AMOUNT) EXTRA_COST_2,
					PRODUCT_ID,
					PRODUCT_UNIT_ID,
					0 SPECT_MAIN_ID
				FROM
				(
					SELECT
						CASE WHEN ACTION_TYPE<> -2
                        THEN
							ROUND(PC.ACTION_ROW_PRICE,4)
                        ELSE
                        	ROUND((PC.PURCHASE_NET_SYSTEM+PC.PURCHASE_EXTRA_COST_SYSTEM),4)
                        END AS ACTION_ROW_PRICE,
						CASE WHEN ACTION_ID IS NOT NULL
						THEN
							CASE WHEN ACTION_PROCESS_TYPE = 62 THEN -1*PC.ACTION_AMOUNT ELSE PC.ACTION_AMOUNT END
						ELSE
						ISNULL((SELECT 
									   SUM(SR.STOCK_IN-SR.STOCK_OUT)
								 FROM
										#kaynak_dsn2#.STOCKS_ROW SR
									WHERE
										SR.PRODUCT_ID = PC.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0)
										</cfif>
										AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
								),0)
						END AS ACTION_AMOUNT,
                        CASE WHEN ACTION_ID IS NOT NULL
						THEN
							CASE WHEN ACTION_PROCESS_TYPE = 62 THEN -1*PC.ACTION_AMOUNT ELSE PC.ACTION_AMOUNT END
						ELSE
						ISNULL((SELECT 
									   SUM(SR.STOCK_IN-SR.STOCK_OUT)
								 FROM
										#kaynak_dsn2#.STOCKS_ROW SR
									WHERE
										SR.PRODUCT_ID = PC.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0)
										</cfif>
										AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
								),0)
						END AS ACTION_EXTRA_AMOUNT,
						PC.PURCHASE_EXTRA_COST,
						PC.ACTION_EXTRA_COST,
						ISNULL(PC.PURCHASE_NET_SYSTEM/NULLIF(PC.PURCHASE_NET_SYSTEM_2,0),0) AS RATE2,
						PC.PRODUCT_ID,
						PC.UNIT_ID PRODUCT_UNIT_ID,
						ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID
					FROM
						PRODUCT_COST PC,
						PRODUCT P
					WHERE
						--PC.PURCHASE_NET_SYSTEM > 0 AND 
                        P.PRODUCT_ID = PC.PRODUCT_ID
                       AND (PC.ACTION_PROCESS_TYPE NOT IN(811,55) OR ACTION_PROCESS_TYPE IS NULL) 
						<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
							AND P.PRODUCT_ID = #attributes.aktarim_product_id#
						</cfif>
                        --AND P.PRODUCT_ID = 2500
						AND 
						(
							(
								PC.START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.START_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
								AND ACTION_ID IS NOT NULL
							)
							OR
							(
								PC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE PCC.PRODUCT_ID = PC.PRODUCT_ID 
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									AND ISNULL(PCC.SPECT_MAIN_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0) 
								</cfif>
								AND PCC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> 
								ORDER BY PCC.START_DATE DESC)
							)
						)					
                   UNION ALL
                   SELECT
						(SELECT
								TOP 1 
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										ROUND((PURCHASE_NET_SYSTEM_LOCATION_ALL),8)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT_ALL),8)
									<cfelse>
										ROUND((PURCHASE_NET_SYSTEM_ALL),8)
									</cfif>
								FROM 
									#kaynak_dsn3#.PRODUCT_COST GPCP
								WHERE
									GPCP.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
									AND GPCP.PRODUCT_ID = PC.PRODUCT_ID
                                    AND GPCP.ACTION_TYPE=-2
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL(PC.SPECT_MAIN_ID,0)
									</cfif>
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										AND GPCP.LOCATION_ID = PC.LOCATION_ID
										AND GPCP.DEPARTMENT_ID = PC.DEPARTMENT_ID
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										AND GPCP.DEPARTMENT_ID = PC.DEPARTMENT_ID
									</cfif>
									ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC) ACTION_ROW_PRICE,
						CASE WHEN ACTION_ID IS NOT NULL
						THEN
							CASE WHEN ACTION_PROCESS_TYPE = 62 THEN -1*PC.ACTION_AMOUNT ELSE PC.ACTION_AMOUNT END
						ELSE
						ISNULL((SELECT 
									   SUM(SR.STOCK_IN-SR.STOCK_OUT)
								 FROM
										#kaynak_dsn2#.STOCKS_ROW SR
									WHERE
										SR.PRODUCT_ID = PC.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0)
										</cfif>
										AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
								),0)
						END AS ACTION_AMOUNT,
                        CASE WHEN ACTION_ID IS NOT NULL
						THEN
							CASE WHEN ACTION_PROCESS_TYPE = 62 THEN -1*PC.ACTION_AMOUNT ELSE PC.ACTION_AMOUNT END
						ELSE
						ISNULL((SELECT 
									   SUM(SR.STOCK_IN-SR.STOCK_OUT)
								 FROM
										#kaynak_dsn2#.STOCKS_ROW SR
									WHERE
										SR.PRODUCT_ID = PC.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_VAR_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0)
										</cfif>
										AND (PROCESS_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> OR PROCESS_TYPE = 114)
								),0)
						END AS ACTION_EXTRA_AMOUNT,
						PC.PURCHASE_EXTRA_COST,
						PC.ACTION_EXTRA_COST,
						ISNULL(PC.PURCHASE_NET_SYSTEM/NULLIF(PC.PURCHASE_NET_SYSTEM_2,0),0) AS RATE2,
						PC.PRODUCT_ID,
						PC.UNIT_ID PRODUCT_UNIT_ID,
						ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID
					FROM
						PRODUCT_COST PC,
						PRODUCT P
					WHERE
						--PC.PURCHASE_NET_SYSTEM > 0 AND 
                        P.PRODUCT_ID = PC.PRODUCT_ID
                        AND PC.ACTION_PROCESS_TYPE = 55
						<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
							AND P.PRODUCT_ID = #attributes.aktarim_product_id#
						</cfif>
                        --AND P.PRODUCT_ID = 2500
						AND 
						(
							(
								PC.START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.START_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
								AND ACTION_ID IS NOT NULL
							)
							OR
							(
								PC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE PCC.PRODUCT_ID = PC.PRODUCT_ID 
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									AND ISNULL(PCC.SPECT_MAIN_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0) 
								</cfif>
								AND PCC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> 
								ORDER BY PCC.START_DATE DESC)
							)
						)
                     UNION ALL
                     SELECT
						0 ACTION_ROW_PRICE,
						0 AS ACTION_AMOUNT,
                        PC.ACTION_AMOUNT ACTION_EXTRA_AMOUNT,
						PC.PURCHASE_EXTRA_COST,
						PC.ACTION_EXTRA_COST ACTION_EXTRA_COST,
						ISNULL(PC.PURCHASE_NET_SYSTEM/NULLIF(PC.PURCHASE_NET_SYSTEM_2,0),0) AS RATE2,
						PC.PRODUCT_ID,
						PC.UNIT_ID PRODUCT_UNIT_ID,
						ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID
					FROM
						PRODUCT_COST PC,
						PRODUCT P
					WHERE
						P.PRODUCT_ID = PC.PRODUCT_ID
                        AND PC.ACTION_PROCESS_TYPE=811
						<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
							AND P.PRODUCT_ID = #attributes.aktarim_product_id#
						</cfif>
                        --AND P.PRODUCT_ID = 2500
						AND 
						(
							(
								PC.START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.START_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
								AND ACTION_ID IS NOT NULL
							)
							OR
							(
								PC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
								AND PC.PRODUCT_COST_ID = (SELECT TOP 1 PCC.PRODUCT_COST_ID FROM PRODUCT_COST PCC WHERE PCC.PRODUCT_ID = PC.PRODUCT_ID 
								<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
									AND ISNULL(PCC.SPECT_MAIN_ID,0) = ISNULL(PC.SPECT_MAIN_ID,0) 
								</cfif>
								AND PCC.START_DATE < <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> 
								ORDER BY PCC.START_DATE DESC)
							)
						)

				)T1
				GROUP BY
					PRODUCT_ID,
					PRODUCT_UNIT_ID
                    <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                   		,T1.SPECT_MAIN_ID
                    </cfif>
				HAVING
					SUM(ACTION_AMOUNT) > 0
			</cfquery>
			<cfoutput query="get_all_cost">
                <cfif kkk eq loop_count>
                    <cfquery name="del_cost" datasource="#kaynak_dsn3#">
                        DELETE FROM #dsn1_alias#.PRODUCT_COST WHERE ACTION_ID IS NOT NULL 
                        AND PRODUCT_ID = #get_all_cost.product_id# 
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND ISNULL(SPECT_MAIN_ID,0) = #get_all_cost.spect_main_id#
                        </cfif>	
                        AND START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> AND START_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                    </cfquery>
                    <cfquery name="delete_total_costs" datasource="#kaynak_dsn3#">
                        DELETE FROM #dsn1_alias#.PRODUCT_COST WHERE ACTION_TYPE = -2 AND START_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp"> AND START_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                        AND PRODUCT_ID = #get_all_cost.product_id# 
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND ISNULL(SPECT_MAIN_ID,0) = #get_all_cost.spect_main_id#
                        </cfif>	
                    </cfquery>
                </cfif>
				<cfif len(total_cost)>
					<cfquery name="add_cost" datasource="#kaynak_dsn3#">
						INSERT INTO
							#dsn1_alias#.PRODUCT_COST
								(
									PRODUCT_COST_STATUS,
									INVENTORY_CALC_TYPE,
									COST_TYPE_ID,
									START_DATE,
									PRODUCT_ID,
									UNIT_ID,
									IS_SPEC,
									IS_STANDARD_COST,
									IS_ACTIVE_STOCK,
									IS_PARTNER_STOCK,
									COST_DESCRIPTION,
									ACTION_ID,
									ACTION_TYPE,
									ACTION_PERIOD_ID,
									ACTION_AMOUNT,
									ACTION_ROW_ID,											
									AVAILABLE_STOCK,
									PARTNER_STOCK,
									ACTIVE_STOCK,
									PRODUCT_COST,
									MONEY,
									STANDARD_COST,
									STANDARD_COST_MONEY,
									STANDARD_COST_RATE,
									PURCHASE_NET,
									PURCHASE_NET_MONEY,
									PURCHASE_EXTRA_COST,
									PRICE_PROTECTION,
									PRICE_PROTECTION_MONEY,
									PURCHASE_NET_SYSTEM,
									PURCHASE_NET_SYSTEM_MONEY,
									PURCHASE_EXTRA_COST_SYSTEM,
									PURCHASE_NET_SYSTEM_2,
									PURCHASE_NET_SYSTEM_MONEY_2,
									PURCHASE_EXTRA_COST_SYSTEM_2,					
									SPECT_MAIN_ID,
									RECORD_DATE,
									RECORD_EMP,
									RECORD_IP
								)
							VALUES
								(
									0,
									3,
									NULL,
									#attributes.aktarim_date1#,
									#get_all_cost.product_id#,
									#get_all_cost.product_unit_id#,
									<cfif len(spect_main_id)>1<cfelse>0</cfif>,
									0,
									0,
									0,
									NULL,											
									NULL,
									-2,<!--- kümüleden gelenler --->
									#attributes.aktarim_kaynak_period#,
									0,
									NULL,
									#AVAILABLE_STOCK_#,
									0,
									0,
									#wrk_round(total_cost+extra_cost,4)#,
									'#session.ep.money#',
									0,
									'#session.ep.money#',
									0,
									#total_cost#,
									'#session.ep.money#',
									#extra_cost#,
									0,
									'#session.ep.money#',
									#total_cost#,
									'#session.ep.money#',
									#extra_cost#,
									#total_cost_2#,
									'#session.ep.money2#',
									#extra_cost_2#,
									#spect_main_id#,
									#NOW()#,
									#SESSION.EP.USERID#,
									'#cgi.REMOTE_ADDR#'
								)
					</cfquery>
					<cfquery name="GET_P_COST_ID" datasource="#kaynak_dsn3#">
						SELECT
							MAX(PRODUCT_COST_ID) AS MAX_ID 
						FROM 
							#dsn1_alias#.PRODUCT_COST
					</cfquery>
					<cfset purchase_net_all = 0>
					<cfset purchase_net_all_location = 0>
					<cfset rate_other =1>
					<cfset rate_price = 1>
					<cfif total_cost_2 neq 0>
						<cfset rate_2 = wrk_round(total_cost/total_cost_2,4)>
					<cfelse>
						<cfset rate_2 =1>
					</cfif>
					<cfquery name="upd_cost" datasource="#dsn1#">
						UPDATE
							PRODUCT_COST
						SET
							PURCHASE_NET_ALL = PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
							PURCHASE_NET_SYSTEM_ALL = (PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
							PURCHASE_NET_SYSTEM_2_ALL = (PURCHASE_NET + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#),
							PURCHASE_NET_LOCATION_ALL = PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#),
							PURCHASE_NET_SYSTEM_LOCATION_ALL = (PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*#rate_other#,
							PURCHASE_NET_SYSTEM_2_LOCATION_ALL = (PURCHASE_NET_LOCATION + (PRICE_PROTECTION*-1*ISNULL(PRICE_PROTECTION_TYPE,0)*#rate_price#/#rate_other#))*(#rate_other#/#rate_2#)
						WHERE
							PRODUCT_COST_ID = #GET_P_COST_ID.MAX_ID#
					</cfquery>
				</cfif>
			</cfoutput>
            </cfloop>
		</cfif>
		<form action="" name="form1_" id="step4" method="post">
			<cfif isdefined("attributes.is_oto")>
        		<input type="hidden" name="is_oto" id="is_oto" value="1" />
        	</cfif>
            <input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#attributes.aktarim_kaynak_period#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#attributes.aktarim_kaynak_year#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#attributes.aktarim_kaynak_company#</cfoutput>">
			<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfif isdate(attributes.aktarim_date1)><cfoutput>#dateformat(attributes.aktarim_date1,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfif isdate(attributes.aktarim_date2)><cfoutput>#dateformat(attributes.aktarim_date2,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_product_name" id="aktarim_product_name" value="<cfoutput>#attributes.aktarim_product_name#</cfoutput>">
			<input type="hidden" name="aktarim_product_id" id="aktarim_product_id" value="<cfoutput>#attributes.aktarim_product_id#</cfoutput>">
			<input type="hidden" name="aktarim_paper_no" id="aktarim_paper_no" value="<cfoutput>#attributes.aktarim_paper_no#</cfoutput>">
			<cfif isdefined('attributes.aktarim_is_cost_again') and len(attributes.aktarim_is_cost_again)>
            <input type="hidden" name="aktarim_is_cost_again" id="aktarim_is_cost_again" value="<cfoutput>#attributes.aktarim_is_cost_again#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_invent_again') and len(attributes.aktarim_is_invent_again)>
            <input type="hidden" name="aktarim_is_invent_again" id="aktarim_is_invent_again" value="<cfoutput>#attributes.aktarim_is_invent_again#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_location_based_cost') and len(attributes.aktarim_is_location_based_cost)>
            <input type="hidden" name="aktarim_is_location_based_cost" id="aktarim_is_location_based_cost" value="<cfoutput>#attributes.aktarim_is_location_based_cost#</cfoutput>"></cfif>
			<cfif isdefined('attributes.aktarim_is_date_kontrol') and len(attributes.aktarim_is_date_kontrol)>
            <input type="hidden" name="aktarim_is_date_kontrol" id="aktarim_is_date_kontrol" value="<cfoutput>#attributes.aktarim_is_date_kontrol#</cfoutput>"></cfif>
			<input type="hidden" name="session_userid" id="session_userid" value="<cfoutput>#attributes.session_userid#</cfoutput>">
			<input type="hidden" name="session_period_id" id="session_period_id" value="<cfoutput>#attributes.session_period_id#</cfoutput>">
			<input type="hidden" name="session_money" id="session_money" value="<cfoutput>#attributes.session_money#</cfoutput>">
			<input type="hidden" name="session_money2" id="session_money2" value="<cfoutput>#attributes.session_money2#</cfoutput>">
			<cf_get_lang no ='2028.Kaynak Veri Tabanı'>: <cfoutput>#attributes.aktarim_kaynak_period# (#attributes.aktarim_kaynak_year#)</cfoutput><br/>
			<cfif x_is_upd_inv eq 1>
				<input type="hidden" name="step" id="step" value="5">
				<br /><br />
				<b><font color="FF0000">Sonraki İşlem : Çıkış İşlemlerinin Güncellenmesi</font></b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
			<cfelse>
				<b><br /><br /><cf_get_lang no ='2109.Maliyet İşlemi Tamamlanmıştır'>!</b><cfabort>
			</cfif>
		</form>
	<cfelseif attributes.step eq 5>
		<cfif x_is_total_cost eq 1>
			<br/><b>5. Çıkış İşlemlerinin Güncellenmesi</b><br/>
		<cfelse>
			<br/><b>4. Çıkış İşlemlerinin Güncellenmesi</b><br/>
		</cfif>
		<cfquery name="UPD_INV_COST" datasource="#dsn2#">
			UPDATE
				INVOICE_ROW
			SET
				COST_PRICE=ISNULL((SELECT
								TOP 1
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										ROUND((PURCHASE_NET_SYSTEM_LOCATION_ALL),8)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT_ALL),8)
									<cfelse>
										ROUND((PURCHASE_NET_SYSTEM_ALL),8)
									</cfif>
								FROM 
									#dsn3_alias#.PRODUCT_COST GPCP
								WHERE
									GPCP.START_DATE <= (SELECT ISNULL(INV.PROCESS_TIME,INV.INVOICE_DATE) AS INVOICE_DATE FROM INVOICE INV WHERE INV.INVOICE_ID = INVOICE_ROW.INVOICE_ID)
									AND GPCP.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS S WHERE S.SPECT_VAR_ID = INVOICE_ROW.SPECT_VAR_ID),0)
									</cfif>
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										AND GPCP.LOCATION_ID = (SELECT II.DEPARTMENT_LOCATION FROM INVOICE II WHERE II.INVOICE_ID = INVOICE_ROW.INVOICE_ID)
										AND GPCP.DEPARTMENT_ID = (SELECT II.DEPARTMENT_ID FROM INVOICE II WHERE II.INVOICE_ID = INVOICE_ROW.INVOICE_ID)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										AND GPCP.DEPARTMENT_ID = (SELECT II.DEPARTMENT_ID FROM INVOICE II WHERE II.INVOICE_ID = INVOICE_ROW.INVOICE_ID)
									</cfif>
									ORDER BY GPCP.START_DATE DESC
									--,GPCP.RECORD_DATE DESC
									,GPCP.PRODUCT_COST_ID DESC
									),0),
										EXTRA_COST=ISNULL((SELECT
										TOP 1 
										<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM_LOCATION),4)
                                        <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4)
										<cfelse>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM),4)
										</cfif>
									FROM 
										#dsn3_alias#.PRODUCT_COST GPCP
									WHERE
										GPCP.START_DATE <= (SELECT ISNULL(INV.PROCESS_TIME,INV.INVOICE_DATE) AS INVOICE_DATE FROM INVOICE INV WHERE INV.INVOICE_ID = INVOICE_ROW.INVOICE_ID)
										AND GPCP.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS S WHERE S.SPECT_VAR_ID = INVOICE_ROW.SPECT_VAR_ID),0)
										</cfif>
										<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
											AND GPCP.LOCATION_ID = (SELECT II.DEPARTMENT_LOCATION FROM INVOICE II WHERE II.INVOICE_ID = INVOICE_ROW.INVOICE_ID)
											AND GPCP.DEPARTMENT_ID = (SELECT II.DEPARTMENT_ID FROM INVOICE II WHERE II.INVOICE_ID = INVOICE_ROW.INVOICE_ID)
                                        <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
											AND GPCP.DEPARTMENT_ID = (SELECT II.DEPARTMENT_ID FROM INVOICE II WHERE II.INVOICE_ID = INVOICE_ROW.INVOICE_ID)
										</cfif>
									ORDER BY GPCP.START_DATE DESC
									--,GPCP.RECORD_DATE DESC
									,GPCP.PRODUCT_COST_ID DESC
									),0)
			WHERE
				INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE INV WHERE INV.PURCHASE_SALES=1 
				<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
					<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
						AND INV.INVOICE_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
					</cfif>
					<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
						AND INV.INVOICE_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
					</cfif>
				</cfif>
				)
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND INVOICE_ROW.PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
		</cfquery>
		<cfquery name="UPD_SHIP_COST" datasource="#dsn2#">
			UPDATE
				SHIP_ROW
			SET
				COST_PRICE=ISNULL((SELECT
								TOP 1 
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										ROUND((PURCHASE_NET_SYSTEM_LOCATION_ALL),8)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT_ALL),8)
									<cfelse>
										ROUND((PURCHASE_NET_SYSTEM_ALL),8)
									</cfif>
								FROM 
									#dsn3_alias#.PRODUCT_COST GPCP
								WHERE
									GPCP.START_DATE <= (SELECT ISNULL(INV.DELIVER_DATE,INV.SHIP_DATE) AS  SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
									AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS S WHERE S.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0)
									</cfif>
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										AND GPCP.LOCATION_ID = (SELECT II.LOCATION FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
										AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
									</cfif>
									ORDER BY GPCP.START_DATE DESC
									--,GPCP.RECORD_DATE DESC
									,GPCP.PRODUCT_COST_ID DESC
									),0),            
									EXTRA_COST=ISNULL((SELECT
										TOP 1 
										<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM_LOCATION),4)
                                        <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4)
										<cfelse>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM),4)
										</cfif>
									FROM 
										#dsn3_alias#.PRODUCT_COST GPCP
									WHERE
										GPCP.START_DATE <= (SELECT ISNULL(INV.DELIVER_DATE,INV.SHIP_DATE) AS  SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
										AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS S WHERE S.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0)
										</cfif>
										<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
											AND GPCP.LOCATION_ID = (SELECT II.LOCATION FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
											AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                        <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
											AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
										</cfif>
									ORDER BY GPCP.START_DATE DESC
									--,GPCP.RECORD_DATE DESC
									,GPCP.PRODUCT_COST_ID DESC
									),0)
			WHERE
				SHIP_ID IN (SELECT SHIP_ID FROM SHIP INV WHERE INV.PURCHASE_SALES=1 AND SHIP_TYPE <> 811
				<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
					<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
						AND INV.SHIP_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
					</cfif>
					<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
						AND INV.SHIP_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
					</cfif>
				</cfif>
				)
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND SHIP_ROW.PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
		</cfquery>
        
        <cfquery name="UPD_FIS_MANUEL" datasource="#dsn2#">
            UPDATE
                STOCK_FIS_ROW
            SET
                COST_PRICE=ISNULL((SELECT
								TOP 1 
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										ROUND((PURCHASE_NET_SYSTEM_LOCATION_ALL),8)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT_ALL),8)
									<cfelse>
										ROUND((PURCHASE_NET_SYSTEM_ALL),8)
									</cfif>
								FROM 
									#dsn3_alias#.PRODUCT_COST GPCP
								WHERE
									GPCP.START_DATE <= (SELECT ISNULL(STOCK_FIS.DELIVER_DATE,STOCK_FIS.FIS_DATE) AS  FIS_DATE FROM STOCK_FIS WHERE STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID)
									AND GPCP.PRODUCT_ID = (SELECT TOP 1 STOCKS.PRODUCT_ID FROM #dsn3_alias#.STOCKS WHERE STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID)
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS S WHERE S.SPECT_VAR_ID = STOCK_FIS_ROW.SPECT_VAR_ID),0)
									</cfif>
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										AND GPCP.LOCATION_ID = (SELECT LOCATION_OUT FROM STOCK_FIS WHERE STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID)
										AND GPCP.DEPARTMENT_ID = (SELECT DEPARTMENT_OUT FROM STOCK_FIS  WHERE  STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										AND GPCP.DEPARTMENT_ID = (SELECT DEPARTMENT_OUT FROM STOCK_FIS  WHERE  STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID)
									</cfif>
									ORDER BY GPCP.START_DATE DESC
									--,GPCP.RECORD_DATE DESC
									,GPCP.PRODUCT_COST_ID DESC
									),0),
                EXTRA_COST=ISNULL((SELECT
										TOP 1 
										<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM_LOCATION),4)
                                        <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4)
										<cfelse>
											ROUND((PURCHASE_EXTRA_COST_SYSTEM),4)
										</cfif>
									FROM 
										#dsn3_alias#.PRODUCT_COST GPCP
									WHERE
										GPCP.START_DATE <= (SELECT ISNULL(STOCK_FIS.DELIVER_DATE,STOCK_FIS.FIS_DATE) AS  FIS_DATE FROM STOCK_FIS WHERE STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID)
										AND GPCP.PRODUCT_ID = (SELECT TOP 1 STOCKS.PRODUCT_ID FROM #dsn3_alias#.STOCKS WHERE STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID)
									<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
										AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS S WHERE S.SPECT_VAR_ID = STOCK_FIS_ROW.SPECT_VAR_ID),0)
									</cfif>
									<cfif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 1>
										AND GPCP.LOCATION_ID = (SELECT LOCATION_OUT FROM STOCK_FIS WHERE STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID)
										AND GPCP.DEPARTMENT_ID = (SELECT DEPARTMENT_OUT FROM STOCK_FIS  WHERE  STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID)
                                    <cfelseif isdefined('attributes.aktarim_is_location_based_cost') and attributes.aktarim_is_location_based_cost eq 2>
										AND GPCP.DEPARTMENT_ID = (SELECT DEPARTMENT_OUT FROM STOCK_FIS  WHERE  STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID)
									</cfif>
									ORDER BY GPCP.START_DATE DESC
									--,GPCP.RECORD_DATE DESC
									,GPCP.PRODUCT_COST_ID DESC
									),0),
                COST_ID=NULL
            WHERE
                FIS_ID IN (SELECT 
                            STOCK_FIS.FIS_ID
                        FROM 
                            STOCK_FIS
                        WHERE 
                            STOCK_FIS.PROD_ORDER_RESULT_NUMBER IS NULL
                            AND FIS_TYPE IN (111,112,113)
							<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
								<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                    AND STOCK_FIS.FIS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                </cfif>
                                <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                    AND STOCK_FIS.FIS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                </cfif>
                            </cfif>
                            )
                <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND STOCK_FIS_ROW.STOCK_ID = (SELECT TOP 1 STOCKS.STOCK_ID FROM #dsn3_alias#.STOCKS WHERE STOCKS.PRODUCT_ID = #attributes.aktarim_product_id#)
				</cfif>
        </cfquery>
        
		<b><br /><br /><cf_get_lang no ='2109.Maliyet İşlemi Tamamlanmıştır'>!</b><cfabort>
	</cfif>
	</div>
	</cf_box>
	</div>
</cfif>