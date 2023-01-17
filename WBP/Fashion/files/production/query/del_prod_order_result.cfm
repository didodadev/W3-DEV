<cfif isdefined("attributes.pr_order_id")>
	<cfquery name="GET_FIS" datasource="#DSN3#">
		SELECT
			FIS_NUMBER,
			FIS_TYPE,
			FIS_ID,
			FIS_DATE
		FROM
			#dsn2_alias#.STOCK_FIS
		WHERE
			PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
	</cfquery>
	<cflock name="#CreateUUID()#" timeout="60">
	  <cftransaction>
	  <!---TolgaS 20060725 eski kayitlari silerken ambar fisi muhasebeleri silinmesi gerektigi icin duruyor ---> 
		<cfscript>
			AMBAR_FIS =cfquery(datasource:"#dsn3#",sqlstring:"SELECT * FROM GET_FIS WHERE FIS_TYPE=113",dbtype="1");
			if(len(AMBAR_FIS.FIS_ID))
				muhasebe_sil(action_id:AMBAR_FIS.FIS_ID, process_type:113, muhasebe_db : '#dsn3#');
			
			muhasebe_sil(action_id:attributes.pr_order_id, process_type:form.old_process_type,muhasebe_db : '#dsn3#');
			
			//Seri Siliniyor
			//include('del_serial_no.cfm','\objects\functions');
			del_serial_no(
				process_id : attributes.pr_order_id,
				process_cat : get_process_type.process_type, 
				period_id : session.ep.period_id,
				is_dsn3 : 1
				);
		</cfscript>
		<!--- SARF SERİLERİNİN SİLİNMESİ PY--->
        <cfquery name="DEL_SARF_SERI" datasource="#DSN3#">
            DELETE FROM SERVICE_GUARANTY_NEW WHERE GUARANTY_ID IN ( 
            														SELECT 
            															GUARANTY_ID 
            														FROM 
                                                                    	SERVICE_GUARANTY_NEW 
                                                                    WHERE 
                                                                    	PROCESS_CAT = 1719 
                                                                        <cfif isDefined('session.ep.userid')>
                                                                            AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                                                                        <cfelse>
                                                                            AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#">                                                                        
                                                                        </cfif>
                                                                    	AND MAIN_PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
                                                                    	AND MAIN_PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_type.process_type#">
                                                           			 )
        </cfquery>
		<cfloop query="GET_FIS">
			<cfquery name="DEL_MONEY" datasource="#DSN3#">
				DELETE FROM
					#dsn2_alias#.STOCK_FIS_MONEY 
				WHERE
					ACTION_ID = #get_fis.fis_id#
			</cfquery>
			<cfquery name="DEL_ROW" datasource="#DSN3#">
				DELETE FROM
					#dsn2_alias#.STOCK_FIS_ROW 
				WHERE
					FIS_ID = #get_fis.fis_id#
			</cfquery>
			<cfquery name="DEL_ROW_STOCK" datasource="#DSN3#">
				DELETE FROM
					#dsn2_alias#.STOCKS_ROW
				WHERE
					UPD_ID = #get_fis.fis_id#
					AND PROCESS_TYPE=#get_fis.fis_type#
			</cfquery>
			<cfquery name="DEL_ROWS" datasource="#DSN3#">
				DELETE FROM
					PRODUCTION_ORDER_RESULTS
				WHERE
					PR_ORDER_ID = #attributes.pr_order_id#
			</cfquery>
				  <cfscript>
				del_serial_no(
					process_id : get_fis.FIS_ID,
					process_cat : get_fis.FIS_TYPE, 
					period_id : session.ep.period_id,
					is_dsn3 : 1
					);
			</cfscript> 
		</cfloop>
			<cfquery name="DEL_FIS" datasource="#DSN3#">
				DELETE FROM
					#dsn2_alias#.STOCK_FIS 
				WHERE
					PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
			</cfquery>
			<cfquery name="DEL_ROWS" datasource="#DSN3#">
				DELETE FROM
					PRODUCTION_ORDER_RESULTS_ROW
				WHERE
					PR_ORDER_ID = #attributes.pr_order_id#
			</cfquery>
			<cfquery name="DEL_ORDER_RES" datasource="#DSN3#">
				DELETE FROM
					PRODUCTION_ORDER_RESULTS
				WHERE
					PR_ORDER_ID = #attributes.pr_order_id#
			</cfquery>
			<cfquery name="DEL_ORDER_OPERA" datasource="#DSN3#">
				DELETE FROM
					PRODUCTION_ORDER_OPERATIONS
				WHERE
					PR_ORDER_ID = #attributes.pr_order_id#
			</cfquery>
			<cfquery name="DEL_ORDER_OPERA_P" datasource="#DSN3#">
				DELETE P FROM 
					PRODUCTION_ORDER_OPERATIONS_PRODUCT P,PRODUCTION_ORDERS PO
				WHERE
					PO.P_ORDER_ID=P.P_ORDER_ID AND
					PO.PARTY_ID = #attributes.party_id#
			</cfquery>
			<!---depo sevk siliniyor--->
				<cfquery name="GET_SHIP" datasource="#DSN3#">
					SELECT
						SHIP_ID,
						SHIP_TYPE
					FROM
						#dsn2_alias#.SHIP
					WHERE 
						PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
				</cfquery>
				<cfloop query="get_ship">
					<cfquery name="DEL_SHIP_ROW" datasource="#DSN3#">
						DELETE FROM
							#dsn2_alias#.SHIP_ROW
						WHERE
							SHIP_ID = #get_ship.ship_id#
					</cfquery>
					<cfquery name="DEL_STOCK_ROW" datasource="#DSN3#">
						DELETE FROM
							#dsn2_alias#.STOCKS_ROW
						WHERE
							UPD_ID = #get_ship.ship_id#
							AND PROCESS_TYPE=#get_ship.ship_type#
					</cfquery>
					 <cfscript>
						del_serial_no(
							process_id : get_ship.SHIP_ID,
							process_cat : get_ship.SHIP_TYPE, 
							period_id : session.ep.period_id,
							is_dsn3 : 1
							);
                    </cfscript> 
				</cfloop>
				<cfquery name="DEL_SHIP" datasource="#DSN3#">
					DELETE FROM
						#dsn2_alias#.SHIP
					WHERE
						PROD_ORDER_RESULT_NUMBER = #attributes.pr_order_id#
				</cfquery>
				<cfquery name="get_result_amount" datasource="#dsn3#">
					SELECT
						ISNULL(SUM(POR_.AMOUNT),0) RESULT_AMOUNT
					FROM
						PRODUCTION_ORDER_RESULTS_ROW POR_,
						PRODUCTION_ORDER_RESULTS POO
					WHERE
						POR_.PR_ORDER_ID = POO.PR_ORDER_ID
						AND POO.PARTY_ID = #attributes.party_id#
						AND POR_.TYPE = 1
						AND POO.IS_STOCK_FIS = 1
						<!---AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)--->
				</cfquery>
				
				 <cfquery name="upd_prod_orders" datasource="#dsn3#">
					UPDATE TEXTILE_PRODUCTION_ORDERS_MAIN SET RESULT_AMOUNT=#get_result_amount.RESULT_AMOUNT# WHERE PARTY_ID = #attributes.party_id#
				</cfquery>
				<cf_add_log  log_type="-1" action_id="#attributes.pr_order_id#" action_name="#attributes.production_order_no#" data_source="#dsn3#" process_stage="#attributes.process_stage#">
			<!---//depo sevk siliniyor--->

		</cftransaction>
	</cflock>
</cfif>
<!--- su ana kadar emire girilen sonuçlardan stok fisi kesilenler toplam emirdeki miktarı karsılıyorsa rezerveyi kaldırıyoruz degilse rezerve kalıyor--->
<!---<cfquery name="GET_P_O_R" datasource="#DSN3#">
	SELECT 
		SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT),
		PRODUCTION_ORDERS.QUANTITY,
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID
	FROM
		PRODUCTION_ORDERS,
		PRODUCTION_ORDER_RESULTS,
		PRODUCTION_ORDER_RESULTS_ROW
	WHERE
		PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND
		PRODUCTION_ORDER_RESULTS.PR_ORDER_ID=PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID=#attributes.p_order_id# AND
		PRODUCTION_ORDERS.STOCK_ID=PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
		PRODUCTION_ORDER_RESULTS_ROW.TYPE=<cfif is_demontaj eq 0>1<cfelse>2</cfif> AND
		PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS=1
	GROUP BY
		PRODUCTION_ORDERS.QUANTITY,
		PRODUCTION_ORDER_RESULTS.P_ORDER_ID
	HAVING 
		SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT)>=PRODUCTION_ORDERS.QUANTITY
</cfquery>
<cfif not GET_P_O_R.RECORDCOUNT>
	<cfquery name="UPD_PROD_ORDER" datasource="#dsn3#">
		UPDATE 
			PRODUCTION_ORDERS
		SET
			IS_STOCK_RESERVED = 1
		WHERE
			P_ORDER_ID =  #attributes.p_order_id#
	</cfquery>
</cfif>--->