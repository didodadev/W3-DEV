<cfif listfindnocase('70,71,72,73,74,75,76,77,78,79,81,84,140,141,85,86,87,88,811,110,111,112,113,114,115,119,1131,171,1190,116,1193,1194,118,1182',attributes.process_cat_id,',') or (isdefined("attributes.invoice_number") and len(attributes.invoice_number)) or isdefined("url.service_id")>
	<cfquery name="GET_SERIAL_ROW_LIST" datasource="#DSN3#">
	<cfif listfindnocase('70,71,72,73,74,75,76,77,78,79,81,84,87,88,140,141,85,86',attributes.process_cat_id,',') or (isdefined("attributes.invoice_number") and len(attributes.invoice_number)) or isdefined("url.service_id")>
		SELECT
			1 BLOCK_TYPE,
			SHIP_ROW.STOCK_ID,
			SHIP_ROW.PRODUCT_ID,
			SUM(SHIP_ROW.AMOUNT) QUANTITY,
			SUM(SHIP_ROW.AMOUNT2) QUANTITY2,
			SHIP_ROW.UNIT,
			SHIP_ROW.UNIT2,
			SHIP.SHIP_ID PROCESS_ID,
			SHIP.SHIP_TYPE PROCESS_CAT,
			SHIP.PURCHASE_SALES,
			SHIP.SHIP_NUMBER PROCESS_NUMBER,
			SHIP.SHIP_DATE PROCESS_DATE,
			SHIP.DELIVER_DATE,
			SHIP.COMPANY_ID,
			SHIP.PARTNER_ID,
			SHIP.CONSUMER_ID,
			SHIP.LOCATION_IN LOCATION_IN,
			SHIP.DEPARTMENT_IN DEPARTMENT_IN,
			SHIP.LOCATION LOCATION_OUT,
			SHIP.DELIVER_STORE_ID DEPARTMENT_OUT,
			SHIP_ROW.SPECT_VAR_ID SPECT_ID,
			'' AS SPECT_OUT_ID,
            SHIP.PROJECT_ID,
			0 STOCK_EXCHANGE_TYPE,
            ISNULL(SHIP.IS_DELIVERED,0) IS_DELIVERED,
            SHIP_ROW.WRK_ROW_ID,
			SHIP_ROW.LOT_NO
		FROM
			#dsn2_alias#.SHIP SHIP,
			#dsn2_alias#.SHIP_ROW SHIP_ROW,
			STOCKS
		  <cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
			,#dsn2_alias#.INVOICE_SHIPS INVOICE_SHIPS
		  </cfif>
		WHERE
			SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
			SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID AND
			STOCKS.IS_SERIAL_NO = 1 AND
			SHIP.SHIP_STATUS = 1
      AND IS_SHIP_IPTAL = 0
		  <cfif isdefined("url.service_id")>
			AND SHIP_ROW.SERVICE_ID = #url.service_id#
		  </cfif>
		  <cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
			AND SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID
			AND INVOICE_SHIPS.INVOICE_NUMBER = '#attributes.invoice_number#'
			AND INVOICE_SHIPS.SHIP_PERIOD_ID = #session.ep.period_id#
		  </cfif>
		  <cfif len(attributes.process_cat_id)>
			AND SHIP.SHIP_TYPE = #attributes.process_cat_id#
		  </cfif>
		  <cfif len(attributes.employee)>
		  	AND SHIP.RECORD_EMP = #attributes.employee_id#
		  </cfif>
		  <cfif len(attributes.serial_no) or len(attributes.lot_no)>
		  	AND SHIP.SHIP_ID IN (	SELECT
										SERVICE_GUARANTY_NEW.PROCESS_ID
									FROM
										SERVICE_GUARANTY_NEW
									WHERE
										SERVICE_GUARANTY_NEW.PROCESS_ID = SHIP.SHIP_ID
										<cfif len(attributes.serial_no)>
											AND SERVICE_GUARANTY_NEW.SERIAL_NO = '#attributes.serial_no#'
										</cfif>
										<cfif len(attributes.lot_no)>
											AND SERVICE_GUARANTY_NEW.LOT_NO = '#attributes.lot_no#'
										</cfif>
								)
		  </cfif>
		  <cfif isDefined("attributes.process_id") and len(attributes.process_id)>
			AND SHIP_ROW.SHIP_ID = #attributes.process_id#
		  </cfif>
		  <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
			AND SHIP.SHIP_NUMBER = '#attributes.belge_no#'
		  </cfif>
		  <cfif isdate(attributes.date1) and not Len(attributes.process_id)>
			AND SHIP.SHIP_DATE >= #attributes.date1#
		  </cfif>
		  <cfif isdate(attributes.date2) and not Len(attributes.process_id)>
			AND SHIP.SHIP_DATE <  #DATEADD("d",1,attributes.date2)#
		  </cfif>
		  <cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
			AND SHIP.COMPANY_ID = #attributes.company_id#
		  <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.company)>
			AND SHIP.CONSUMER_ID = #attributes.consumer_id#
		  </cfif>
		  <cfif len(attributes.stock_id) and len(attributes.product_name)>
			AND SHIP_ROW.STOCK_ID = #attributes.stock_id#
		  </cfif>
		  <cfif isdefined("attributes.project_id") and len (attributes.project_id) and isdefined("attributes.project_head") and len (attributes.project_head)>
			AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		  </cfif>          
		  <cfif len(attributes.department_id) and len(attributes.department_name)>
			AND 
			(
            	(
                    SHIP.DEPARTMENT_IN = #attributes.department_id# AND			
                    SHIP.LOCATION_IN = #attributes.location_id#
                )
                OR
                (
                    SHIP.DELIVER_STORE_ID = #attributes.department_id# AND 			
                    SHIP.LOCATION = #attributes.location_id#
                )
			)
		  <cfelseif session.ep.isBranchAuthorization>
			AND 
			(
				SHIP.DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#) OR
				SHIP.DELIVER_STORE_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
			)
		  </cfif>	  
		GROUP BY
			SHIP_ROW.STOCK_ID,
			SHIP_ROW.PRODUCT_ID,
			SHIP_ROW.UNIT,
			SHIP_ROW.UNIT2,
			SHIP.SHIP_ID,
			SHIP.SHIP_TYPE,
			SHIP.PURCHASE_SALES,
			SHIP.SHIP_NUMBER,
			SHIP.SHIP_DATE,
			SHIP.DELIVER_DATE,
			SHIP.COMPANY_ID,
			SHIP.PARTNER_ID,
			SHIP.CONSUMER_ID,
			SHIP.LOCATION_IN,
			SHIP.DEPARTMENT_IN,
			SHIP.LOCATION,
			SHIP.DELIVER_STORE_ID,
			SHIP_ROW.SPECT_VAR_ID,
			SHIP_ROW.SHIP_ROW_ID,
            SHIP.PROJECT_ID,
            SHIP.IS_DELIVERED,
            SHIP_ROW.WRK_ROW_ID,
			SHIP_ROW.LOT_NO
		ORDER BY
			SHIP_ROW.SHIP_ROW_ID DESC
	</cfif>
	<cfif listfindnocase('811',attributes.process_cat_id,',')>
		SELECT DISTINCT
			1 BLOCK_TYPE,
			SHIP_ROW.STOCK_ID,
			SHIP_ROW.PRODUCT_ID,
			SUM(SHIP_ROW.AMOUNT) QUANTITY,
			SUM(SHIP_ROW.AMOUNT2) QUANTITY2,
			SHIP_ROW.UNIT,
			SHIP_ROW.UNIT2,
			SHIP.SHIP_ID PROCESS_ID,
			SHIP.SHIP_TYPE PROCESS_CAT,
			0 AS PURCHASE_SALES,
			SHIP.SHIP_NUMBER PROCESS_NUMBER,
			SHIP.SHIP_DATE PROCESS_DATE,
			SHIP.DELIVER_DATE,
			SHIP.COMPANY_ID,
			SHIP.PARTNER_ID,
			SHIP.CONSUMER_ID,
			SHIP.LOCATION_IN LOCATION_IN,
			SHIP.DEPARTMENT_IN DEPARTMENT_IN,
			SHIP.LOCATION LOCATION_OUT,
			SHIP.DELIVER_STORE_ID DEPARTMENT_OUT,
			SHIP_ROW.SPECT_VAR_ID SPECT_ID,
			'' AS SPECT_OUT_ID,
    		SHIP.PROJECT_ID,
			0 STOCK_EXCHANGE_TYPE,
      		ISNULL(SHIP.IS_DELIVERED,0) IS_DELIVERED,
    		SHIP_ROW.WRK_ROW_ID,
			SHIP_ROW.LOT_NO
		FROM
			#dsn2_alias#.SHIP SHIP,
			#dsn2_alias#.SHIP_ROW SHIP_ROW,
			STOCKS
		WHERE
			SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
			SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID AND
			STOCKS.IS_SERIAL_NO = 1 AND
			SHIP.SHIP_STATUS = 1
      AND IS_SHIP_IPTAL = 0
		  <cfif isdefined("url.service_id")>
			AND SHIP_ROW.SERVICE_ID = #url.service_id#
		  </cfif>
		  <cfif isdefined("attributes.invoice_number") and len(attributes.invoice_number)>
			AND SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID
			AND INVOICE_SHIPS.INVOICE_NUMBER = '#attributes.invoice_number#'
			AND INVOICE_SHIPS.SHIP_PERIOD_ID = #session.ep.period_id#
		  </cfif>
		  <cfif len(attributes.process_cat_id)>
			AND SHIP.SHIP_TYPE = #attributes.process_cat_id#
		  </cfif>
		   <cfif len(attributes.employee)>
		  	AND SHIP.RECORD_EMP = #attributes.employee_id#
		  </cfif>
		  <cfif len(attributes.serial_no) or len(attributes.lot_no)>
		  	AND SHIP.SHIP_ID IN (	SELECT
										SERVICE_GUARANTY_NEW.PROCESS_ID
									FROM
										SERVICE_GUARANTY_NEW
									WHERE
										SERVICE_GUARANTY_NEW.PROCESS_ID = SHIP.SHIP_ID
										<cfif len(attributes.serial_no)>
											AND SERVICE_GUARANTY_NEW.SERIAL_NO = '#attributes.serial_no#'
										</cfif>
										<cfif len(attributes.lot_no)>
											AND SERVICE_GUARANTY_NEW.LOT_NO = '#attributes.lot_no#'
										</cfif>
								)
		  </cfif>
		  <cfif isDefined("attributes.process_id") and len(attributes.process_id)>
			AND SHIP_ROW.SHIP_ID = #attributes.process_id#
		  </cfif>
		  <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
			AND SHIP.SHIP_NUMBER = '#attributes.belge_no#'
		  </cfif>
		  <cfif isdate(attributes.date1) and not Len(attributes.process_id)>
			AND SHIP.SHIP_DATE >= #attributes.date1#
		  </cfif>
		  <cfif isdate(attributes.date2) and not Len(attributes.process_id)>
			AND SHIP.SHIP_DATE <  #DATEADD("d",1,attributes.date2)#
		  </cfif>
		  <cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
			AND SHIP.COMPANY_ID = #attributes.company_id#
		  <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.company)>
			AND SHIP.CONSUMER_ID = #attributes.consumer_id#
		  </cfif>
		  <cfif len(attributes.stock_id) and len(attributes.product_name)>
			AND SHIP_ROW.STOCK_ID = #attributes.stock_id#
		  </cfif>
		  <cfif isdefined("attributes.project_id") and len (attributes.project_id) and isdefined("attributes.project_head") and len (attributes.project_head)>
			AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		  </cfif>          
		  <cfif len(attributes.department_id) and len(attributes.department_name)>
			AND 
			(
            	(
                    SHIP.DEPARTMENT_IN = #attributes.department_id# AND			
                    SHIP.LOCATION_IN = #attributes.location_id#
                )
                OR
                (
                    SHIP.DELIVER_STORE_ID = #attributes.department_id# AND 			
                    SHIP.LOCATION = #attributes.location_id#
                )
			)
		  <cfelseif session.ep.isBranchAuthorization>
			AND 
			(
				SHIP.DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#) OR
				SHIP.DELIVER_STORE_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
			)
		  </cfif>	  
		GROUP BY
			SHIP_ROW.STOCK_ID,
			SHIP_ROW.PRODUCT_ID,
			SHIP_ROW.UNIT,
			SHIP_ROW.UNIT2,
			SHIP.SHIP_ID,
			SHIP.SHIP_TYPE,
			SHIP.PURCHASE_SALES,
			SHIP.SHIP_NUMBER,
			SHIP.SHIP_DATE,
			SHIP.DELIVER_DATE,
			SHIP.COMPANY_ID,
			SHIP.PARTNER_ID,
			SHIP.CONSUMER_ID,
			SHIP.LOCATION_IN,
			SHIP.DEPARTMENT_IN,
			SHIP.LOCATION,
			SHIP.DELIVER_STORE_ID,
			SHIP_ROW.SPECT_VAR_ID,
            SHIP.PROJECT_ID,
            SHIP.IS_DELIVERED,
            SHIP_ROW.WRK_ROW_ID,
			SHIP_ROW.LOT_NO
	</cfif>
	<cfif listfindnocase('110,111,112,113,114,115,119,1131,118,1182',attributes.process_cat_id,',')>
		SELECT
			2 BLOCK_TYPE,
			STOCK_FIS_ROW.STOCK_ID,
			1 PRODUCT_ID,
			SUM(STOCK_FIS_ROW.AMOUNT) QUANTITY,
			SUM(STOCK_FIS_ROW.AMOUNT2) QUANTITY2,
			STOCK_FIS_ROW.UNIT,
			STOCK_FIS_ROW.UNIT2,
			STOCK_FIS.FIS_ID PROCESS_ID,
			STOCK_FIS.FIS_TYPE PROCESS_CAT,
			CASE WHEN FIS_TYPE = 113 THEN 1
				 WHEN FIS_TYPE = 112 THEN 1
				 WHEN FIS_TYPE = 111 THEN 1
			ELSE
			3 
			END AS PURCHASE_SALES,
			STOCK_FIS.FIS_NUMBER PROCESS_NUMBER,
			STOCK_FIS.FIS_DATE PROCESS_DATE,
			STOCK_FIS.DELIVER_DATE,
			-1 AS COMPANY_ID,
			-1 AS PARTNER_ID,
			-1 AS CONSUMER_ID,
			STOCK_FIS.LOCATION_IN LOCATION_IN,
			STOCK_FIS.DEPARTMENT_IN DEPARTMENT_IN,
			STOCK_FIS.LOCATION_OUT LOCATION_OUT,
			STOCK_FIS.DEPARTMENT_OUT DEPARTMENT_OUT,
			STOCK_FIS_ROW.SPECT_VAR_ID SPECT_ID,
			'' AS SPECT_OUT_ID,
            STOCK_FIS.PROJECT_ID,
			0 STOCK_EXCHANGE_TYPE,
            '' AS IS_DELIVERED,
            STOCK_FIS_ROW.WRK_ROW_ID,
			STOCK_FIS_ROW.LOT_NO
		FROM
			#dsn2_alias#.STOCK_FIS STOCK_FIS,
			#dsn2_alias#.STOCK_FIS_ROW STOCK_FIS_ROW,
			STOCKS
		  <cfif len(attributes.employee) or len(attributes.serial_no) or len(attributes.lot_no)>
			,SERVICE_GUARANTY_NEW
		  </cfif>
		WHERE
			STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
			STOCK_FIS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
			STOCKS.IS_SERIAL_NO = 1
		  <cfif len(attributes.process_cat_id)>
			AND STOCK_FIS.FIS_TYPE = #attributes.process_cat_id#
		  </cfif>
		  <cfif Len(attributes.employee) or len(attributes.serial_no) or len(attributes.lot_no)>
			AND STOCK_FIS.FIS_ID = SERVICE_GUARANTY_NEW.PROCESS_ID
		  <cfif len(attributes.employee) and len(attributes.employee_id)>
			AND SERVICE_GUARANTY_NEW.RECORD_EMP = #attributes.employee_id#
		  </cfif>
		  <cfif len(attributes.serial_no)>
			AND SERVICE_GUARANTY_NEW.SERIAL_NO = '#attributes.serial_no#'
		  </cfif>
		  <cfif len(attributes.lot_no)>
			AND SERVICE_GUARANTY_NEW.LOT_NO = '#attributes.lot_no#'
		  </cfif>
		  </cfif>
		  <cfif isDefined("attributes.process_id") and len(attributes.process_id)>
			AND STOCK_FIS_ROW.FIS_ID = #attributes.process_id#
		  </cfif>
		  <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
			AND STOCK_FIS.FIS_NUMBER = '#attributes.belge_no#'
		  </cfif>
		  <cfif isdate(attributes.date1) and not len(attributes.process_id)>
			AND STOCK_FIS.FIS_DATE >= #attributes.date1#
		  </cfif>
		  <cfif isdate(attributes.date2) and not len(attributes.process_id)>
			AND STOCK_FIS.FIS_DATE <= #attributes.date2#
		  </cfif>
		  <cfif len(attributes.stock_id) and len(attributes.product_name)>
			AND STOCK_FIS_ROW.STOCK_ID = #attributes.stock_id#
		  </cfif>
		  <cfif isdefined("attributes.project_id") and len (attributes.project_id) and isdefined("attributes.project_head") and len (attributes.project_head)>
			AND STOCK_FIS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		  </cfif>          
		  <cfif len(attributes.department_id) and len(attributes.department_name)>
          AND 
			(
            	(
                    STOCK_FIS.DEPARTMENT_IN = #attributes.department_id# AND			
                    STOCK_FIS.LOCATION_IN = #attributes.location_id#
                )
                OR
                (
                    STOCK_FIS.DEPARTMENT_OUT = #attributes.department_id# AND 			
                    STOCK_FIS.LOCATION_OUT = #attributes.location_id#
                )
			)
		  <cfelseif session.ep.isBranchAuthorization>
			AND 
			(
				STOCK_FIS.DEPARTMENT_IN IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#) OR
				STOCK_FIS.DEPARTMENT_OUT IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
			)
		  </cfif>	  
		  
		GROUP BY
			STOCK_FIS_ROW.STOCK_ID,
			STOCK_FIS_ROW.UNIT,
			STOCK_FIS_ROW.UNIT2,
			STOCK_FIS.FIS_ID,
			STOCK_FIS.FIS_TYPE,
			STOCK_FIS.FIS_NUMBER,
			STOCK_FIS.FIS_DATE,
			STOCK_FIS.DELIVER_DATE,
			STOCK_FIS.LOCATION_IN,
			STOCK_FIS.DEPARTMENT_IN,
			STOCK_FIS.LOCATION_OUT,
			STOCK_FIS.DEPARTMENT_OUT,
			STOCK_FIS_ROW.SPECT_VAR_ID,
			STOCK_FIS_ROW.STOCK_FIS_ROW_ID,
            STOCK_FIS.PROJECT_ID,
            STOCK_FIS_ROW.WRK_ROW_ID,
			STOCK_FIS_ROW.LOT_NO
		ORDER BY
			STOCK_FIS_ROW.STOCK_FIS_ROW_ID DESC
	</cfif>
	<cfif listfindnocase('171',attributes.process_cat_id,',')>
		SELECT
			3 BLOCK_TYPE,
			PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
			PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
			SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT) QUANTITY,
			SUM(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT2) QUANTITY2,
			--PRODUCTION_ORDER_RESULTS_ROW.UNIT,
			PRODUCTION_ORDER_RESULTS_ROW.UNIT2,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID PROCESS_ID,
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
			171 PROCESS_CAT,
			0 AS PURCHASE_SALES,
			PRODUCTION_ORDER_RESULTS.RESULT_NO PROCESS_NUMBER,
			PRODUCTION_ORDER_RESULTS.FINISH_DATE PROCESS_DATE,
			PRODUCTION_ORDER_RESULTS.START_DATE DELIVER_DATE,
			-1 COMPANY_ID,
			-1 PARTNER_ID,
			-1 CONSUMER_ID,
			PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID LOCATION_IN,
			PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID DEPARTMENT_IN,
			PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID LOCATION_OUT,
			PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID DEPARTMENT_OUT,		
			PRODUCTION_ORDER_RESULTS_ROW.SPECT_ID SPECT_ID,
			'' AS SPECT_OUT_ID,
			0 STOCK_EXCHANGE_TYPE,
            '' AS IS_DELIVERED,
            PRODUCTION_ORDER_RESULTS_ROW.WRK_ROW_ID,
			PRODUCTION_ORDER_RESULTS_ROW.LOT_NO
		FROM
			PRODUCTION_ORDER_RESULTS,
			PRODUCTION_ORDER_RESULTS_ROW,
			STOCKS
		  <cfif len(attributes.employee) or len(attributes.serial_no) or len(attributes.lot_no)>
			,SERVICE_GUARANTY_NEW
		  </cfif>
		WHERE
			PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID IS NOT NULL AND
			PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID IS NOT NULL AND
			PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1 AND
			PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS.PR_ORDER_ID AND
			PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
			STOCKS.IS_SERIAL_NO = 1
		  <cfif len(attributes.employee) or len(attributes.serial_no) or len(attributes.lot_no)>
			AND SERVICE_GUARANTY_NEW.PROCESS_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID
		  <cfif Len(attributes.employee) and len(attributes.employee_id)>
			AND SERVICE_GUARANTY_NEW.RECORD_EMP = #attributes.employee_id#
		  </cfif>
		  <cfif len(attributes.serial_no)>
			AND SERVICE_GUARANTY_NEW.SERIAL_NO = '#attributes.serial_no#'
		  </cfif>
		  <cfif len(attributes.lot_no)>
			AND SERVICE_GUARANTY_NEW.LOT_NO = '#attributes.lot_no#'
		  </cfif>
		  </cfif>
		  <cfif isDefined("attributes.process_id") and len(attributes.process_id)>
			AND PRODUCTION_ORDERS.PR_ORDER_ID = #attributes.process_id#
		  </cfif>
		  <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
			AND PRODUCTION_ORDER_RESULTS.RESULT_NO = '#attributes.belge_no#'
		  </cfif>
		  <cfif isdate(attributes.date1) and not len(attributes.process_id)>
			AND PRODUCTION_ORDER_RESULTS.START_DATE >= #attributes.date1#
		  </cfif>
		  <cfif isdate(attributes.date2) and not len(attributes.process_id)>
			AND PRODUCTION_ORDER_RESULTS.START_DATE <  #DATEADD("d",1,attributes.date2)#
		  </cfif>
		  <cfif len("attributes.stock_id") and len(attributes.product_name)>
			AND PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID = #attributes.stock_id#
		  </cfif>
		  <cfif len(attributes.department_id) and len(attributes.department_name)>
           AND 
			(
            	(
                    PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID = #attributes.department_id# AND			
                    PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID = #attributes.location_id#
                )
                OR
                (
                    PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID = #attributes.department_id# AND 			
                    PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID = #attributes.location_id#
                )
			)
		  <cfelseif session.ep.isBranchAuthorization>
			AND 
			(
				PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#) OR 			
				PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
			)
		  </cfif>		  
		GROUP BY 
			PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
			PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
			PRODUCTION_ORDER_RESULTS_ROW.UNIT2,
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
			PRODUCTION_ORDER_RESULTS.RESULT_NO,
			PRODUCTION_ORDER_RESULTS.FINISH_DATE,
			PRODUCTION_ORDER_RESULTS.START_DATE,		
			PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID,
			PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID,
			PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
			PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID,
			PRODUCTION_ORDER_RESULTS_ROW.SPECT_ID,
			PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID,
            PRODUCTION_ORDER_RESULTS_ROW.WRK_ROW_ID,
			PRODUCTION_ORDER_RESULTS_ROW.LOT_NO
		ORDER BY
			PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID DESC
	</cfif>
	<cfif listfindnocase('1190',attributes.process_cat_id,',')>
		SELECT
			4 BLOCK_TYPE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			COUNT(S.STOCK_ID) AS QUANTITY,
			'' QUANTITY2,
			'' UNIT,
			'' UNIT2,
			PROCESS_ID,
			PROCESS_CAT,
			1 AS PURCHASE_SALES,
			PROCESS_NO AS PROCESS_NUMBER,
			SGN.RECORD_DATE AS PROCESS_DATE,
			'' AS DELIVER_DATE,
			PURCHASE_COMPANY_ID AS COMPANY_ID,
			PURCHASE_PARTNER_ID AS PARTNER_ID,
			PURCHASE_CONSUMER_ID AS CONSUMER_ID,
			LOCATION_ID AS LOCATION_IN,
			DEPARTMENT_ID AS DEPARTMENT_IN,
			'' AS LOCATION_OUT,
			'' AS DEPARTMENT_OUT,
			SPECT_ID AS SPECT_ID,
			'' AS SPECT_OUT_ID,
			0 STOCK_EXCHANGE_TYPE,
            '' AS IS_DELIVERED,
            WRK_ROW_ID,
			LOT_NO
		FROM
			SERVICE_GUARANTY_NEW SGN,
			STOCKS S
		WHERE
			S.STOCK_ID = SGN.STOCK_ID AND
			SGN.PROCESS_CAT = 1190
			<cfif len(attributes.department_id) and len(attributes.department_name)>
			AND 
			(SGN.DEPARTMENT_ID = #attributes.department_id# AND SGN.LOCATION_ID = #attributes.location_id#)
			<cfelseif session.ep.isBranchAuthorization>
			AND 
			SGN.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
			</cfif>	
		GROUP BY 
			S.STOCK_ID,
			S.PRODUCT_ID,
			PROCESS_ID,
			PROCESS_CAT,
			PROCESS_NO,
			SGN.RECORD_DATE,
			PURCHASE_COMPANY_ID,
			PURCHASE_PARTNER_ID,
			PURCHASE_CONSUMER_ID,
			LOCATION_ID,
			DEPARTMENT_ID,
			SPECT_ID,
            WRK_ROW_ID,
			LOT_NO
	</cfif>
	<cfif listfindnocase('116',attributes.process_cat_id,',')>
		SELECT
			5 BLOCK_TYPE,
			STOCK_EXCHANGE.STOCK_ID,
			S.PRODUCT_ID,
			AMOUNT AS QUANTITY,
			AMOUNT2 QUANTITY2,
			UNIT,
			UNIT2,
			STOCK_EXCHANGE.PROCESS_TYPE AS PROCESS_CAT,
			STOCK_EXCHANGE.STOCK_EXCHANGE_ID AS PROCESS_ID,
			0 AS PURCHASE_SALES,
			STOCK_EXCHANGE.EXCHANGE_NUMBER AS PROCESS_NUMBER,
			STOCK_EXCHANGE.RECORD_DATE AS PROCESS_DATE,
			'' AS DELIVER_DATE,
			-1 AS COMPANY_ID,
			-1 AS PARTNER_ID,
			-1 AS CONSUMER_ID,
			STOCK_EXCHANGE.DEPARTMENT_ID AS DEPARTMENT_IN,
			STOCK_EXCHANGE.LOCATION_ID AS LOCATION_IN,
			STOCK_EXCHANGE.EXIT_DEPARTMENT_ID AS DEPARTMENT_OUT,
			STOCK_EXCHANGE.EXIT_LOCATION_ID AS LOCATION_OUT,
			STOCK_EXCHANGE.SPECT_MAIN_ID AS SPECT_ID,
			STOCK_EXCHANGE.EXIT_SPECT_MAIN_ID AS SPECT_OUT_ID,
			STOCK_EXCHANGE_TYPE,
            '' AS IS_DELIVERED,
            STOCK_EXCHANGE.WRK_ROW_ID,
			STOCK_EXCHANGE.LOT_NO
		FROM
        	#dsn3_alias#.STOCKS S,
			#dsn2_alias#.STOCK_EXCHANGE AS STOCK_EXCHANGE
		WHERE
			S.STOCK_ID = STOCK_EXCHANGE.STOCK_ID
			<cfif len(attributes.department_id) and len(attributes.department_name)>
             AND 
			(
            	(
                    STOCK_EXCHANGE.DEPARTMENT_ID = #attributes.department_id# AND			
                    STOCK_EXCHANGE.LOCATION_ID = #attributes.location_id#
                )
                OR
                (
                    STOCK_EXCHANGE.EXIT_DEPARTMENT_ID  = #attributes.department_id# AND 			
                    STOCK_EXCHANGE.EXIT_LOCATION_ID  = #attributes.location_id#
                )
			)
			<cfelseif session.ep.isBranchAuthorization>
			AND (
				STOCK_EXCHANGE.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
				OR
				STOCK_EXCHANGE.EXIT_DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
				)
			</cfif>	
			<cfif isdate(attributes.date1) and not Len(attributes.process_id)>
                AND STOCK_EXCHANGE.RECORD_DATE >= #attributes.date1#
            </cfif>
            <cfif isdate(attributes.date2) and not Len(attributes.process_id)>
                AND STOCK_EXCHANGE.RECORD_DATE <  #DATEADD("d",1,attributes.date2)#
            </cfif>
            <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
				AND STOCK_EXCHANGE.EXCHANGE_NUMBER = '#attributes.belge_no#'
			</cfif>
	</cfif>
	<cfif listfindnocase('1193',attributes.process_cat_id,',')>
		SELECT
			6 BLOCK_TYPE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			SUM(SCR.AMOUNT) AS QUANTITY,
			--SUM(SCR.AMOUNT2) QUANTITY2,
			SCR.UNIT,
			--SCR.UNIT2,
			SC.SUBSCRIPTION_ID AS PROCESS_ID,
			1193 AS PROCESS_CAT,
			1 AS PURCHASE_SALES,
			SC.SUBSCRIPTION_NO AS PROCESS_NUMBER,
			SC.RECORD_DATE AS PROCESS_DATE,
			'' AS DELIVER_DATE,
			SC.COMPANY_ID,
			SC.PARTNER_ID,
			SC.CONSUMER_ID,
			'' AS LOCATION_IN,
			'' AS DEPARTMENT_IN,
			'' AS LOCATION_OUT,
			'' AS DEPARTMENT_OUT,
			'' AS SPECT_ID,
			'' AS SPECT_OUT_ID,
			0 STOCK_EXCHANGE_TYPE,
            '' AS IS_DELIVERED ,
            SCR.SUBSCRIPTION_ROW_ID WRK_ROW_ID,
			SCR.LOT_NO
		FROM
			SUBSCRIPTION_CONTRACT SC,
			STOCKS S,
			SUBSCRIPTION_CONTRACT_ROW SCR
			<cfif len(attributes.serial_no) or len(attributes.lot_no)>
			,SERVICE_GUARANTY_NEW SGN
		  </cfif>
		WHERE
			<cfif len(attributes.serial_no) or len(attributes.lot_no)>
			SC.SUBSCRIPTION_ID = SGN.PROCESS_ID AND
			SGN.PROCESS_CAT = 1193 AND
			</cfif>
			S.STOCK_ID = SCR.STOCK_ID AND
			SCR.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
			<cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
				AND SC.SUBSCRIPTION_NO = '#attributes.belge_no#'
			</cfif>
			<cfif len(attributes.serial_no)>
				AND SGN.SERIAL_NO = '#attributes.serial_no#'
		  	</cfif>
		  	<cfif len(attributes.lot_no)>
				AND SGN.LOT_NO = '#attributes.lot_no#'
		  	</cfif>
		  	<cfif isDefined("attributes.process_id") and len(attributes.process_id)>
				AND SC.SUBSCRIPTION_ID = #attributes.process_id#
		 	 </cfif>
		 	 <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
				AND SC.SUBSCRIPTION_NO = '#attributes.belge_no#'
		 	 </cfif>
			  <cfif isdate(attributes.date1) and not Len(attributes.process_id)>
				AND SC.RECORD_DATE >= #attributes.date1#
			  </cfif>
			  <cfif isdate(attributes.date2) and not Len(attributes.process_id)>
				AND SC.RECORD_DATE < #DATEADD("d",1,attributes.date2)#
			  </cfif>
			  <cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
				AND SC.COMPANY_ID = #attributes.company_id#
			  <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.company)>
				AND SC.CONSUMER_ID = #attributes.consumer_id#
			  </cfif>
			  <cfif len(attributes.stock_id) and len(attributes.product_name)>
				AND SCR.STOCK_ID = #attributes.stock_id#
			  </cfif>
		GROUP BY 
			S.STOCK_ID,
			SCR.UNIT,
			S.PRODUCT_ID,
			SC.SUBSCRIPTION_ID,
			SC.SUBSCRIPTION_NO,
			SC.RECORD_DATE,
			SC.COMPANY_ID,
			SC.PARTNER_ID,
			SC.CONSUMER_ID,
            SCR.SUBSCRIPTION_ROW_ID,
			SCR.LOT_NO
	</cfif>
	<cfif listfindnocase('1194',attributes.process_cat_id,',')>
		SELECT
			7 BLOCK_TYPE,
			PRODUCTION_ORDERS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			SUM(PRODUCTION_ORDERS.QUANTITY) QUANTITY,
			<!--- SUM(PRODUCTION_ORDERS.AMOUNT2) QUANTITY2,
			PRODUCTION_ORDERS.UNIT,
			PRODUCTION_ORDERS.UNIT2, --->
			CASE WHEN SUM(PU.MULTIPLIER) <> 0 THEN (SUM(PRODUCTION_ORDERS.QUANTITY)/SUM(PU.MULTIPLIER)) ELSE '' END QUANTITY2,
			PU.MAIN_UNIT UNIT,
			PU.ADD_UNIT UNIT2,
			PRODUCTION_ORDERS.P_ORDER_ID PROCESS_ID,
			1194 PROCESS_CAT,
			0 AS PURCHASE_SALES,
			PRODUCTION_ORDERS.P_ORDER_NO PROCESS_NUMBER,
			PRODUCTION_ORDERS.FINISH_DATE PROCESS_DATE,
			PRODUCTION_ORDERS.START_DATE DELIVER_DATE,
			-1 COMPANY_ID,
			-1 PARTNER_ID,
			-1 CONSUMER_ID,
			PRODUCTION_ORDERS.PRODUCTION_LOC_ID LOCATION_IN,
			PRODUCTION_ORDERS.PRODUCTION_DEP_ID DEPARTMENT_IN,
			PRODUCTION_ORDERS.EXIT_LOC_ID LOCATION_OUT,
			PRODUCTION_ORDERS.EXIT_DEP_ID DEPARTMENT_OUT,		
			PRODUCTION_ORDERS.SPECT_VAR_ID SPECT_ID,
			'' AS SPECT_OUT_ID,
			PRODUCTION_ORDERS.PROJECT_ID,
			0 STOCK_EXCHANGE_TYPE,
            '' AS IS_DELIVERED,
            PRODUCTION_ORDERS.WRK_ROW_ID,
			PRODUCTION_ORDERS.LOT_NO
		FROM
			PRODUCTION_ORDERS,
			STOCKS,
			PRODUCT_UNIT PU
		  <cfif len(attributes.employee) or len(attributes.serial_no) or len(attributes.lot_no)>
			,SERVICE_GUARANTY_NEW
		  </cfif>
		WHERE
			--PRODUCTION_ORDERS.PRODUCTION_DEP_ID IS NOT NULL AND
			--PRODUCTION_ORDERS.EXIT_DEP_ID IS NOT NULL AND
			PRODUCTION_ORDERS.IS_STAGE NOT IN (-1) AND
			PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
			STOCKS.IS_SERIAL_NO = 1 
			AND PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID 
		  <cfif len(attributes.employee) or len(attributes.serial_no) or len(attributes.lot_no)>
				AND SERVICE_GUARANTY_NEW.PROCESS_ID = PRODUCTION_ORDERS.P_ORDER_ID
			  <cfif Len(attributes.employee) and len(attributes.employee_id)>
				AND SERVICE_GUARANTY_NEW.RECORD_EMP = #attributes.employee_id#
			  </cfif>
			  <cfif len(attributes.serial_no)>
				AND SERVICE_GUARANTY_NEW.SERIAL_NO = '#attributes.serial_no#'
			  </cfif>
			  <cfif len(attributes.lot_no)>
				AND SERVICE_GUARANTY_NEW.LOT_NO = '#attributes.lot_no#'
			  </cfif>
		  </cfif>
		  <cfif isDefined("attributes.process_id") and len(attributes.process_id)>
			AND PRODUCTION_ORDERS.P_ORDER_ID = #attributes.process_id#
		  </cfif>
		  <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
			AND PRODUCTION_ORDERS.P_ORDER_NO = '#attributes.belge_no#'
		  </cfif>
		  <cfif isdate(attributes.date1) and not len(attributes.process_id)>
			AND PRODUCTION_ORDERS.START_DATE >= #attributes.date1#
		  </cfif>
		  <cfif isdate(attributes.date2) and not len(attributes.process_id)>
			AND PRODUCTION_ORDERS.START_DATE <  #DATEADD("d",1,attributes.date2)#
		  </cfif>
		  <cfif len("attributes.stock_id") and len(attributes.product_name)>
			AND PRODUCTION_ORDERS.STOCK_ID = #attributes.stock_id#
		  </cfif>
		GROUP BY 
			PRODUCTION_ORDERS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			PU.MAIN_UNIT,
			PU.ADD_UNIT,
			PRODUCTION_ORDERS.P_ORDER_ID,
			PRODUCTION_ORDERS.P_ORDER_NO,
			PRODUCTION_ORDERS.FINISH_DATE,
			PRODUCTION_ORDERS.START_DATE,		
			PRODUCTION_ORDERS.PRODUCTION_LOC_ID,
			PRODUCTION_ORDERS.PRODUCTION_DEP_ID,
			PRODUCTION_ORDERS.EXIT_LOC_ID,
			PRODUCTION_ORDERS.EXIT_DEP_ID,
			PRODUCTION_ORDERS.SPECT_VAR_ID,
			PRODUCTION_ORDERS.PROJECT_ID,
            PRODUCTION_ORDERS.WRK_ROW_ID,
			PRODUCTION_ORDERS.LOT_NO
		ORDER BY
			PRODUCTION_ORDERS.P_ORDER_ID DESC
	</cfif>
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='546.Bu İşlem Tipi İçin Seri Tanımlaması Yapamazsınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
