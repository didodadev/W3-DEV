<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Producton Plan Graph component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    

    <!--- GET PROGRAM LIST --->
    <cffunction name="getProgramList" access="remote" returntype="any" output="no">
    	<cfargument name="time_zone" type="numeric" required="yes">
		<cfset _now_ = DateAdd('h', time_zone, now())>
        
		<cfquery name="get_prog_list" datasource="#dsn#">
        	SELECT
            	SHIFT_NAME AS name,
                START_HOUR AS startHour,
                START_MIN AS startMin,
                END_HOUR AS endHour,
                END_MIN AS endMin
        	FROM
            	SETUP_SHIFTS
            WHERE 
            	IS_PRODUCTION = 1 AND FINISHDATE > #_now_#
        </cfquery>
        
        <cfreturn get_prog_list>
	
    </cffunction>
    

    <!--- GET PRODUCT CATEGORY LIST --->
    <cffunction name="getProductCategoryList" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="string" required="yes"><!-- dsn tespiti i�in g�nderilmesi zorunludur. -->
    
    	<cfquery name="get_product_category_list" datasource="#dsn#_#company_id#">
            SELECT PRODUCT_CATID AS id, PRODUCT_CAT AS name FROM PRODUCT_CAT ORDER BY name
        </cfquery>
        
        <cfreturn get_product_category_list>
    </cffunction>
    
    <!--- GET BRANCH LIST --->
    <cffunction name="getBranchList" access="remote" returntype="query" output="no">
    	<cfquery name="get_branch_list" datasource="#dsn#">
            SELECT
            	BRANCH_ID AS id,
                BRANCH_NAME AS name
        	FROM
            	BRANCH
			WHERE
            	IS_PRODUCTION = 1
        	ORDER BY
            	BRANCH_NAME
        </cfquery>
        
        <cfreturn get_branch_list>
    </cffunction>
    
    <!--- GET DEPARTMENT LIST --->
    <cffunction name="getDepartmentList" access="remote" returntype="query" output="no">
    	<cfargument name="branch_id" type="string" required="yes">
    
    	<cfquery name="get_department_list" datasource="#dsn#">
            SELECT
            	DEPARTMENT_HEAD AS name,
                DEPARTMENT_ID AS id
			FROM
            	DEPARTMENT
			WHERE
            	DEPARTMENT_STATUS = 1 AND IS_PRODUCTION = 1 AND
				BRANCH_ID = #arguments.branch_id#
        </cfquery>
        
        <cfreturn get_department_list>
    </cffunction>
    
    <!--- GET STATION LIST --->
    <cffunction name="getStationList" access="remote" returntype="query" output="no">
    	<cfargument name="company_id" type="string" required="yes"><!-- dsn tespiti i�in g�nderilmesi zorunludur. -->
        <cfargument name="department_id" type="string" required="yes">
        <cfargument name="employee_id" type="numeric" required="yes">
    
    	<!---<cfif len(arguments.employee_id)>
        	<cfquery name="getWorkStationControl" datasource="#dsn#">
            	SELECT TOP 1
                	ISNULL(WORKSTATION_VIEW_CONTROL,0) AS WORKSTATION_VIEW_CONTROL 
                FROM 
                	EMPLOYEE_POSITIONS
                WHERE
                	POSITION_STATUS = 1 AND
					IS_MASTER = 1 AND
                   	EMPLOYEE_ID = #arguments.employee_id#
            </cfquery>
        <cfelse>
        	<cfset getWorkStationControl.WORKSTATION_VIEW_CONTROL = 0>
        </cfif>--->
    
    	<cfquery name="get_station_list" datasource="#dsn#_#company_id#">
            SELECT
            	STATION_ID AS id,
                STATION_NAME AS name
			FROM
            	WORKSTATIONS
			WHERE
            	DEPARTMENT = #arguments.department_id#
                <cfif len(arguments.employee_id)>
	                AND EMP_ID LIKE '%,#arguments.employee_id#,%'
                </cfif>
        </cfquery>
        
        <cfreturn get_station_list>
    </cffunction>
    
    <!--- GET SUB STATION LIST --->
    <cffunction name="getSubStationList" access="remote" returntype="query" output="no">
    	<cfargument name="company_id" type="string" required="yes"><!-- dsn tespiti i�in g�nderilmesi zorunludur. -->
        <cfargument name="department_id" type="string" required="yes">
        <cfargument name="station_id" type="string" required="yes">
        <cfargument name="employee_id" type="numeric" required="yes">
    
    <!---	<cfif len(arguments.employee_id)>
        	<cfquery name="getWorkStationControl" datasource="#dsn#">
            	SELECT TOP 1
                	ISNULL(WORKSTATION_VIEW_CONTROL,0) AS WORKSTATION_VIEW_CONTROL 
                FROM 
                	EMPLOYEE_POSITIONS
                WHERE
                	POSITION_STATUS = 1 AND
					IS_MASTER = 1 AND
                   	EMPLOYEE_ID = #arguments.employee_id#
            </cfquery>
        <cfelse>
        	<cfset getWorkStationControl.WORKSTATION_VIEW_CONTROL = 0>
        </cfif>--->
    
    	<cfquery name="get_station_list" datasource="#dsn#_#company_id#">
            SELECT
            	STATION_ID AS id,
                STATION_NAME AS name
			FROM
            	WORKSTATIONS
			WHERE
            	DEPARTMENT = #arguments.department_id# 
		<!--- AND
                UP_STATION = #arguments.station_id#
               <cfif getWorkStationControl.WORKSTATION_VIEW_CONTROL eq 1>
	                AND EMP_ID LIKE '%,#arguments.employee_id#,%'
                </cfif> --->
        </cfquery>
        
        <cfreturn get_station_list>
    </cffunction>
    
    <!--- GET PRODUCTION ORDERS --->
    <cffunction name="getProductionOrders" access="remote" returntype="struct" output="no">
    	<cfargument name="company_id" type="string" required="yes"><!-- dsn tespiti i�in g�nderilmesi zorunludur. -->
        <cfargument name="type" type="numeric" required="yes">
        <cfargument name="employee_id" type="numeric" required="yes">
        <cfargument name="branch_id" type="string" required="no">
        <cfargument name="department_id" type="string" required="no">
        <cfargument name="station_id" type="string" required="no">
        <cfargument name="start_date" type="date" required="yes">
        <cfargument name="finish_date" type="date" required="yes">
        <cfargument name="keyword" type="string" required="no">
        <cfargument name="product_category_id" type="any" required="no">
        <cfargument name="consumer_id" type="any" required="no">
        <cfargument name="is_consumer_company" type="any" required="no">        
        
      <!---  <cfif len(arguments.employee_id)>
        	<cfquery name="getWorkStationControl" datasource="#dsn#">
            	SELECT TOP 1
                	ISNULL(WORKSTATION_VIEW_CONTROL,0) AS WORKSTATION_VIEW_CONTROL 
                FROM 
                	EMPLOYEE_POSITIONS
                WHERE
                	POSITION_STATUS = 1 AND
					IS_MASTER = 1 AND
                   	EMPLOYEE_ID = #arguments.employee_id#
            </cfquery>
        <cfelse>
        	<cfset getWorkStationControl.WORKSTATION_VIEW_CONTROL = 0>
        </cfif> --->
        <cfset getWorkStationControl.WORKSTATION_VIEW_CONTROL = 0>
        <cfquery name="get_workstations" datasource="#dsn#_#company_id#">
            SELECT 
                STATION_ID AS id,
                STATION_NAME AS name,
                ACTIVE AS isActive
            FROM	
                WORKSTATIONS
            WHERE
                1 = 1
                <cfif len(arguments.employee_id)>
	                AND EMP_ID LIKE '%,#arguments.employee_id#,%'
                </cfif>
                <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>AND BRANCH = #arguments.branch_id# </cfif>
                <cfif isdefined('arguments.department_id') and len(arguments.department_id)>AND DEPARTMENT = #arguments.department_id# </cfif>
                <cfif isdefined('arguments.station_id') and len(arguments.station_id)>AND (UP_STATION = #arguments.station_id# OR STATION_ID = #arguments.station_id#)</cfif>
            ORDER BY
                STATION_NAME
        </cfquery>
        
        <cfquery name="get_orders" datasource="#dsn#_#company_id#">
            SELECT 
                DISTINCT
                	STOCKS.PRODUCT_NAME AS product,
                	STOCKS.PRODUCT_CATID AS productCatID,
                	(CASE WHEN ORDERS.CONSUMER_ID IS NULL THEN COMPANY.FULLNAME ELSE CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME END)AS consumer,
                    PRODUCTION_ORDERS.IS_STAGE AS phase,
                    PRODUCTION_ORDERS.P_ORDER_ID AS id,
                    PRODUCTION_ORDERS.SPEC_MAIN_ID AS specMainID,
                    PRODUCTION_ORDERS.SPECT_VAR_ID AS specVarID,
                    PRODUCTION_ORDERS.QUANTITY AS quantity,
                    PRODUCTION_ORDERS.DETAIL AS description,
                    PRODUCTION_ORDERS.START_DATE AS startDate,
                    PRODUCTION_ORDERS.FINISH_DATE AS finishDate,
                    PRODUCTION_ORDERS.STATION_ID AS stationID,
                    WORKSTATIONS.STATION_NAME AS stationName,
                    PRODUCTION_ORDERS.P_ORDER_NO AS productionNo,
                    PRODUCTION_ORDERS.STATUS AS isActive,
                    PRODUCTION_ORDERS.PROJECT_ID,
                    PRO_PROJECTS.PROJECT_HEAD AS projectName,
                    ORDERS.ORDER_NUMBER AS orderNo,
                    ORDERS.ORDER_HEAD AS orderHead,
					ORDERS.DELIVERDATE AS terminDate,
                    PRODUCTION_ORDERS.PO_RELATED_ID AS relatedOrder,
                    0 AS isLastRelatedOrder
               	FROM	
                    PRODUCTION_ORDERS
                    LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = PRODUCTION_ORDERS.PROJECT_ID,
               		PRODUCTION_ORDERS_ROW,
					ORDERS
					LEFT JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID = ORDERS.COMPANY_ID
					LEFT JOIN #dsn#.CONSUMER ON CONSUMER.CONSUMER_ID = ORDERS.CONSUMER_ID,
					STOCKS,
                    WORKSTATIONS
                WHERE
                    PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
					PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND
					PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
                    PRODUCTION_ORDERS.STATION_ID = WORKSTATIONS.STATION_ID
                    <cfif #arguments.type# is 0>
                    	AND PRODUCTION_ORDERS.IS_STAGE = -1
					<cfelseif #arguments.type# is 1>
                    	AND PRODUCTION_ORDERS.IS_STAGE <> -1
                    <cfelseif #arguments.type# is 2>
                    	AND (PRODUCTION_ORDERS.IS_STAGE = 1 OR PRODUCTION_ORDERS.IS_STAGE = 3)
					</cfif>
                    <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>AND WORKSTATIONS.BRANCH = #arguments.branch_id# </cfif>
                    <cfif isdefined('arguments.department_id') and len(arguments.department_id)>AND WORKSTATIONS.DEPARTMENT = #arguments.department_id# </cfif>
                    <cfif isdefined('arguments.station_id') and len(arguments.station_id)>AND (WORKSTATIONS.UP_STATION = #arguments.station_id# OR WORKSTATIONS.STATION_ID = #arguments.station_id#)</cfif>
                    AND (
                    	PRODUCTION_ORDERS.START_DATE < #arguments.start_date# AND PRODUCTION_ORDERS.FINISH_DATE > #arguments.start_date#
                        OR
                    	PRODUCTION_ORDERS.START_DATE >= #arguments.start_date# AND PRODUCTION_ORDERS.FINISH_DATE <= #arguments.finish_date#
                        OR
                        PRODUCTION_ORDERS.START_DATE >= #arguments.start_date# AND PRODUCTION_ORDERS.START_DATE < #arguments.finish_date# AND PRODUCTION_ORDERS.FINISH_DATE > #arguments.finish_date#
                        OR
                        PRODUCTION_ORDERS.START_DATE < #arguments.start_date# AND PRODUCTION_ORDERS.FINISH_DATE > #arguments.finish_date#
                        )
                    <cfif isdefined('arguments.keyword') and len(arguments.keyword)> AND PRODUCTION_ORDERS.P_ORDER_NO LIKE '%#arguments.keyword#%'</cfif>
                    <cfif isdefined('arguments.product_category_id') and len(arguments.product_category_id)> AND STOCKS.PRODUCT_CATID = #arguments.product_category_id#</cfif>
                    <cfif isdefined('arguments.consumer_id') and len(arguments.consumer_id) and isdefined('arguments.is_consumer_company') and arguments.is_consumer_company is 1> 
                    	AND (ORDERS.COMPANY_ID IS NOT NULL AND ORDERS.COMPANY_ID = #arguments.consumer_id#)
                    <cfelseif isdefined('arguments.consumer_id') and len(arguments.consumer_id)>
                    	AND (ORDERS.CONSUMER_ID IS NOT NULL AND ORDERS.CONSUMER_ID = #arguments.consumer_id#)
                    </cfif>
                    <cfif getWorkStationControl.WORKSTATION_VIEW_CONTROL eq 1>
                        AND WORKSTATIONS.EMP_ID LIKE '%,#arguments.employee_id#,%'
                    </cfif>
            <cfif not isdefined('arguments.consumer_id')> 
                UNION ALL
                SELECT 
                    DISTINCT
                        STOCKS.PRODUCT_NAME AS product,
                        STOCKS.PRODUCT_CATID AS productCatID,
                        NULL AS consumer,
                        PRODUCTION_ORDERS.IS_STAGE AS phase,
                        PRODUCTION_ORDERS.P_ORDER_ID AS id,
                        PRODUCTION_ORDERS.SPEC_MAIN_ID AS specMainID,
                        PRODUCTION_ORDERS.SPECT_VAR_ID AS specVarID,
                        PRODUCTION_ORDERS.QUANTITY AS quantity,
                        PRODUCTION_ORDERS.DETAIL AS description,
                        PRODUCTION_ORDERS.START_DATE AS startDate,
                        PRODUCTION_ORDERS.FINISH_DATE AS finishDate,
                        PRODUCTION_ORDERS.STATION_ID AS stationID,
                        WORKSTATIONS.STATION_NAME AS stationName,
                        PRODUCTION_ORDERS.P_ORDER_NO AS productionNo,
                        PRODUCTION_ORDERS.STATUS AS isActive,
                        PRODUCTION_ORDERS.PROJECT_ID,
                        PRO_PROJECTS.PROJECT_HEAD AS projectName,
                        '' AS orderNo,
                        '' AS orderHead,
                        '' AS terminDate,
                        PRODUCTION_ORDERS.PO_RELATED_ID AS relatedOrder,
                        0 AS isLastRelatedOrder
                    FROM	
                        PRODUCTION_ORDERS
                        LEFT JOIN #dsn#.PRO_PROJECTS ON PRO_PROJECTS.PROJECT_ID = PRODUCTION_ORDERS.PROJECT_ID,
                        STOCKS,
                        WORKSTATIONS
                    WHERE
                        PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
                        PRODUCTION_ORDERS.P_ORDER_ID NOT IN(SELECT PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) AND
                        PRODUCTION_ORDERS.STATION_ID = WORKSTATIONS.STATION_ID
                        <cfif #arguments.type# is 0>
                            AND PRODUCTION_ORDERS.IS_STAGE = -1
                        <cfelseif #arguments.type# is 1>
                            AND PRODUCTION_ORDERS.IS_STAGE <> -1
                        <cfelseif #arguments.type# is 2>
                            AND (PRODUCTION_ORDERS.IS_STAGE = 1 OR PRODUCTION_ORDERS.IS_STAGE = 3)
                        </cfif>
                        <cfif isdefined('arguments.branch_id') and len(arguments.branch_id)>AND WORKSTATIONS.BRANCH = #arguments.branch_id# </cfif>
                        <cfif isdefined('arguments.department_id') and len(arguments.department_id)>AND WORKSTATIONS.DEPARTMENT = #arguments.department_id# </cfif>
                        <cfif isdefined('arguments.station_id') and len(arguments.station_id)>AND (WORKSTATIONS.UP_STATION = #arguments.station_id# OR WORKSTATIONS.STATION_ID = #arguments.station_id#)</cfif>
                        AND (
                            PRODUCTION_ORDERS.START_DATE < #arguments.start_date# AND PRODUCTION_ORDERS.FINISH_DATE > #arguments.start_date#
                            OR
                            PRODUCTION_ORDERS.START_DATE >= #arguments.start_date# AND PRODUCTION_ORDERS.FINISH_DATE <= #arguments.finish_date#
                            OR
                            PRODUCTION_ORDERS.START_DATE >= #arguments.start_date# AND PRODUCTION_ORDERS.START_DATE < #arguments.finish_date# AND PRODUCTION_ORDERS.FINISH_DATE > #arguments.finish_date#
                            OR
                            PRODUCTION_ORDERS.START_DATE < #arguments.start_date# AND PRODUCTION_ORDERS.FINISH_DATE > #arguments.finish_date#
                            )
                        <cfif isdefined('arguments.keyword') and len(arguments.keyword)> AND PRODUCTION_ORDERS.P_ORDER_NO LIKE '%#arguments.keyword#%'</cfif>
                        <cfif isdefined('arguments.product_category_id') and len(arguments.product_category_id)> AND STOCKS.PRODUCT_CATID = #arguments.product_category_id#</cfif>
                        <cfif getWorkStationControl.WORKSTATION_VIEW_CONTROL eq 1>
                            AND WORKSTATIONS.EMP_ID LIKE '%,#arguments.employee_id#,%'
                        </cfif>
            	</cfif>
           	ORDER BY
            	product
        </cfquery>
        
        <!-- Check and sign the order as related if it is last related order in its related orders. If an order's relation field is null but its ID in other orders's relation field, it is the top order which means last order -->
        <cfloop query="get_orders">
        	<cfif not isDefined("get_orders.relatedOrder") or isDefined("get_orders.relatedOrder") and not len(get_orders.relatedOrder)>
                <cfquery name="check_order_relation" datasource="#dsn#_#company_id#">
                    SELECT TOP(1) P_ORDER_ID FROM PRODUCTION_ORDERS WHERE PO_RELATED_ID = #get_orders.id#
                </cfquery>
                <!-- If there is no top and bottom relation, it means main product has just 1 order. So sign for this case too (gte 0) -->
                <cfif check_order_relation.recordCount gte 0>
                	<cfset res = QuerySetCell(get_orders, "isLastRelatedOrder", 1, get_orders.currentRow)>
				</cfif>
            </cfif>
        </cfloop>
        
        <cfset result = StructNew()>
        <cfset result["workstations"] = get_workstations>
        <cfset result["orders"] = get_orders>
        
        <cfreturn result>
	</cffunction>
    
    <!--- UPDATE ORDER --->
    <cffunction name="updateOrders" access="remote" returntype="boolean" output="no">
    	<cfargument name="company_id" type="string" required="yes"><!-- dsn tespiti i�in g�nderilmesi zorunludur. -->
        <cfargument name="employee_id" type="numeric" required="yes">
    	<cfargument name="time_zone" type="numeric" required="yes">
        <cfargument name="order_list" type="any" required="yes">
    	
        <cfloop from="1" to="#ArrayLen(arguments.order_list)#" index="i">
        	<cfset order = arguments.order_list[i]>
            <cfquery name="update_order" datasource="#dsn#_#company_id#">
                UPDATE
                    PRODUCTION_ORDERS
                SET
                    START_DATE = DateAdd(hour, #arguments.time_zone#, #order.startDate#),
                    FINISH_DATE = DateAdd(hour, #arguments.time_zone#, #order.finishDate#),
                    STATION_ID = #order.stationID#,
                    UPDATE_DATE = #now()#,
                    UPDATE_EMP = #arguments.employee_id#,
                    UPDATE_IP = '#cgi.REMOTE_ADDR#'
                WHERE
                    P_ORDER_ID = #order.id#
            </cfquery>
        </cfloop>
        
        <cfreturn true>
    </cffunction>

</cfcomponent>