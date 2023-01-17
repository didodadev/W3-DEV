<!---<cfinclude template="../../../fbx_workcube_funcs.cfm">--->
<cffunction name="get_po_det_fnc" returntype="query" displayname="Üretim Sonuçlarını Listeler">
	<cfargument name="authority_station_id_list" default="" displayname="yetkili olunan istasyon id listesi">
	<cfargument name="keyword" default="" displayname="Üretim No,Sipariş No veya Üretim Sonuç No'ya Göre Arama Yapıyor">
	<cfargument name="start_date" default="" displayname="Üretim Emri Kayıt Tarihi'ne Bakıyor">
	<cfargument name="finish_date" default="" displayname="Üretim Emri Kayıt Tarihi'ne Bakıyor">
	<cfargument name="spect_main_id" default="">
	<cfargument name="spect_name" default="">
	<cfargument name="process" default="">
	<cfargument name="position_code" default="">
	<cfargument name="position_name" default="">
	<cfargument name="station_id" default="">
	<cfargument name="department" default="">
	<cfargument name="department_id" default="">
	<cfargument name="location_id" default="">
	<cfargument name="product_cat" default="">
	<cfargument name="hierarchy" default="">
	<cfargument name="project_head" default="">
	<cfargument name="project_id" default="">
	<cfargument name="product_id" default="">
	<cfargument name="product_name" default="">
	<cfargument name="start_date_result" default="">
	<cfargument name="finish_date_result" default="">
	<cfargument name="stock_fis_status" default="">
	<cfargument name="opplist" default="">
	<cfquery name="get_period" datasource="#this.dsn3#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #this.dsn_alias#.SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
	</cfquery>
	<cfquery name="get_po_det" datasource="#this.dsn3#">
		SELECT
			PRODUCTION_ORDERS.SPEC_MAIN_ID,
			PRODUCTION_ORDERS.ORDER_ID,
			PRODUCTION_ORDERS.P_ORDER_NO,
			PRODUCTION_ORDERS.P_ORDER_ID,
			PRODUCTION_ORDERS.SPECT_VAR_NAME,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.ORDER_NO,
			PRODUCTION_ORDER_RESULTS.RESULT_NO,
			PRODUCTION_ORDER_RESULTS.PRODUCTION_ORDER_NO,
			PRODUCTION_ORDER_RESULTS.STATION_ID,
			PRODUCTION_ORDER_RESULTS.REFERENCE_NO,
			PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID,
			PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID,
			STOCKS.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.STOCK_CODE,
			STOCKS.PRODUCT_ID,
			PRODUCTION_ORDER_RESULTS.LOT_NO,
			PRODUCTION_ORDERS.STOCK_ID,
			PRODUCTION_ORDERS.FINISH_DATE,
			PRODUCTION_ORDERS.START_DATE,
			PRODUCTION_ORDERS.STOCK_ID,
			PRODUCTION_ORDERS.QUANTITY,
			PRODUCTION_ORDERS.STATUS_ID,
			PRODUCTION_ORDERS.PROJECT_ID,
			PRODUCTION_ORDER_RESULTS.START_DATE RESULT_START_DATE,
			PRODUCTION_ORDER_RESULTS.FINISH_DATE RESULT_FINISH_DATE,
			PROCESS_TYPE_ROWS.STAGE,
			PRO_PROJECTS.PROJECT_HEAD,
			(SELECT COMMENT FROM #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID AND LOCATION_ID = PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID) COMMENT,
			(SELECT SUM(AMOUNT) AS TOPLAM FROM PRODUCTION_ORDER_RESULTS_ROW WHERE TYPE = 1 AND PR_ORDER_ID = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID) MIKTAR,
			PRODUCTION_ORDERS_MAIN.*
		FROM
			TEXTILE_PRODUCTION_ORDERS_MAIN AS PRODUCTION_ORDERS_MAIN,
			PRODUCTION_ORDERS
			LEFT JOIN #this.dsn_alias#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID=PRODUCTION_ORDERS.PROJECT_ID,
			PRODUCTION_ORDER_RESULTS,
			STOCKS AS STOCKS,
			#this.dsn1_alias#.PRODUCT AS PRODUCT,
			#this.dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS
		WHERE
			PRODUCTION_ORDERS_MAIN.PARTY_ID=PRODUCTION_ORDER_RESULTS.PARTY_ID AND
			PRODUCTION_ORDERS.PARTY_ID = PRODUCTION_ORDER_RESULTS.PARTY_ID AND
			PRODUCTION_ORDERS.STOCK_ID IS NOT NULL AND
			STOCKS.STOCK_ID = PRODUCTION_ORDERS.STOCK_ID AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			 <cfif isdefined('arguments.spect_main_id') and len(arguments.spect_main_id) and isdefined('arguments.spect_name') and len(arguments.spect_name)>PRODUCTION_ORDERS.SPEC_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#"> AND</cfif>
			PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PRODUCTION_ORDER_RESULTS.PROD_ORD_RESULT_STAGE AND
			PRODUCTION_ORDER_RESULTS.STATION_ID IN(#authority_station_id_list#)
			<cfif isdefined('arguments.process') and len(arguments.process)>AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process#"></cfif>
			<cfif isdefined('arguments.position_code') and len(arguments.position_code) and isdefined('arguments.position_name') and len(arguments.position_name)>
				AND PRODUCT.PRODUCT_CATID IN (SELECT 
													PC2.PRODUCT_CATID
												FROM 
													PRODUCT_CAT PC1,
													PRODUCT_CAT PC2 
												WHERE 
													PC2.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
													AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
											)
			</cfif>
			<cfif isdefined('arguments.keyword') and len(arguments.keyword)>
				AND(
					(PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
					OR
					(PRODUCTION_ORDER_RESULTS.ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
					OR
					(PRODUCTION_ORDER_RESULTS.RESULT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
					OR
               		(PRODUCTION_ORDER_RESULTS.LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
					OR
					(PRODUCTION_ORDER_RESULTS.PR_ORDER_ID IN (SELECT PORR.PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW PORR WHERE PORR.LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">))
					OR (PRODUCTION_ORDERS_MAIN.PARTY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
					
				)
			</cfif>
			<cfif isdefined('arguments.station_id') and len(arguments.station_id)>
				AND PRODUCTION_ORDER_RESULTS.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">
			<cfelseif isdefined('arguments.authority_station_id_list') and len(arguments.authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
				AND PRODUCTION_ORDER_RESULTS.STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">)
			</cfif>
			<cfif (isdefined('arguments.department') and len(arguments.department) and isdefined('arguments.department_id') and len(arguments.department_id)) and (isdefined('arguments.location_id') and len(arguments.location_id))>	
				AND 
					(
						(PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> AND PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">) OR
						(PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> AND PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">) OR
						(PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> AND PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">)
					)
			</cfif>
			<cfif isdefined('arguments.product_cat') and len(arguments.product_cat) and isdefined('arguments.hierarchy') and len(arguments.hierarchy)>
		     	AND PRODUCT.PRODUCT_CATID IN (SELECT 
              									PRODUCT_CATID 
                                            FROM 
                                            	PRODUCT_CAT  
                                            WHERE 
                                            	HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hierarchy#%">)
												 
			</cfif>
			<cfif isdefined('arguments.project_head') and len(arguments.project_head) and isdefined('arguments.project_id') and len(arguments.project_id)>
				AND PRODUCTION_ORDERS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
			</cfif>
			<cfif isdefined('arguments.product_id') and len(arguments.product_id) and isdefined('arguments.product_name') and len(arguments.product_name)>AND PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"></cfif>
			<cfif isDefined("arguments.start_date_result") and isdate(arguments.start_date_result)>
				AND PRODUCTION_ORDER_RESULTS.FINISH_DATE >= #arguments.start_date_result#
			</cfif>
			<cfif isDefined("arguments.finish_date_result") and isdate(arguments.finish_date_result)>
				AND PRODUCTION_ORDER_RESULTS.FINISH_DATE < #dateadd('d',1,arguments.finish_date_result)#
			</cfif>
			<cfif isdefined('arguments.stock_fis_status') and len(arguments.stock_fis_status)>
				<cfif arguments.stock_fis_status eq 1>
					AND PRODUCTION_ORDER_RESULTS.PR_ORDER_ID IN
					(
						<cfloop query="get_period">
							SELECT SF.PROD_ORDER_RESULT_NUMBER FROM #this.dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#.dbo.STOCK_FIS SF WHERE SF.PROD_ORDER_RESULT_NUMBER = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID
						<cfif currentrow neq get_period.recordcount> UNION ALL </cfif> 
						</cfloop>	
					)
				<cfelse>
					AND PRODUCTION_ORDER_RESULTS.PR_ORDER_ID NOT IN
					(
						<cfloop query="get_period">
							SELECT SF.PROD_ORDER_RESULT_NUMBER FROM #this.dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#.dbo.STOCK_FIS SF WHERE SF.PROD_ORDER_RESULT_NUMBER = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID
						<cfif currentrow neq get_period.recordcount> UNION ALL </cfif> 
						</cfloop>	
					)
				</cfif>
			</cfif>
			<cfif isdefined('arguments.start_date') and len(arguments.start_date)>
				AND PRODUCTION_ORDERS.RECORD_DATE >= #arguments.start_date#
			 </cfif>
			 <cfif isdefined('arguments.finish_date') and len(arguments.finish_date)>
				AND PRODUCTION_ORDERS.RECORD_DATE < #DATE_ADD('d',1,arguments.finish_date)#
			 </cfif>
			 <cfif isdefined('arguments.opplist') and len(arguments.opplist)>
				and TEXTILE_PRODUCTION_ORDERS_MAIN.OPERATION_TYPE_ID IN(#arguments.opplist#)
				</cfif>
		ORDER BY
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID DESC
		</cfquery>
		<cfreturn get_po_det>
</cffunction>