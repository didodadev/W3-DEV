<cfcomponent extends="cfc.queryJSONConverter">
    <cfset getMMFunct = createObject("component", "cfc.mmFunctions")>
    <cfset specer = getMMFunct.specer >
    <cfset dsn = application.systemParam.systemParam().dsn />
    <cfset dsn_alias = application.systemParam.systemParam().dsn />
    <cfset dsn1_alias = "#dsn#_product" />
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
    <cfset dsn2_alias = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
    <cfset dsn3 = "#dsn#_#session.ep.company_id#" />
    <cfset dsn3_alias = "#dsn#_#session.ep.company_id#" />
    
    <cffunction name="getRegisterVisitor" access="remote" returnformat="JSON">
		<cfargument name = "refinery_visitor_register_tc" default="">
        <cfargument name = "our_company_id" default="">

		<cfquery name="get_query" datasource="#DSN#">
			SELECT TOP 1
                REFI.VISITOR_NAME,
                REFI.SPECIAL_CODE,
                REFI.PHONE_NUMBER,
                REFI.EMAIL_ADDRESS,
                REFI.CONSUMER_ID,
                REFI.COMPANY_ID,
                REFI.MEMBER_TYPE,
                REFI.CAR_NUMBER,
                REFI.EMPLOYEE_ID,
                (SELECT TOP 1 FORMAT(ISG_ENTRY_TIME, 'dd/MM/yyyy ') FROM REFINERY_VISITOR_REGISTER WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND TC_IDENTITY_NUMBER = REFI.TC_IDENTITY_NUMBER AND ISG_ENTRY_TIME IS NOT NULL ORDER BY VISIT_TIME DESC) AS ISG_ENTRY_TIME,
                (SELECT TOP 1 FORMAT(ISG_EXIT_TIME, 'dd/MM/yyyy ') FROM REFINERY_VISITOR_REGISTER WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> AND TC_IDENTITY_NUMBER = REFI.TC_IDENTITY_NUMBER AND ISG_EXIT_TIME IS NOT NULL ORDER BY VISIT_TIME DESC) AS ISG_EXIT_TIME,
                CASE
                    WHEN REFI.CONSUMER_ID IS NOT NULL THEN CONI.CONSUMER_NAME + ' ' + CONI.CONSUMER_SURNAME
                    WHEN REFI.COMPANY_ID IS NOT NULL THEN COMI.FULLNAME
                    ELSE ''
                END AS MEMBER_NAME,
				EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS EMP_FULLNAME
			FROM 
				REFINERY_VISITOR_REGISTER AS REFI
            JOIN PROCESS_TYPE_ROWS AS PTR ON REFI.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			LEFT JOIN CONSUMER AS CONI ON REFI.CONSUMER_ID = CONI.CONSUMER_ID
			LEFT JOIN COMPANY AS COMI ON REFI.COMPANY_ID = COMI.COMPANY_ID
			JOIN EMPLOYEES AS EMP ON REFI.EMPLOYEE_ID = EMP.EMPLOYEE_ID
			WHERE 1 = 1 AND REFI.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
			<cfif isDefined("arguments.refinery_visitor_register_tc") and len(arguments.refinery_visitor_register_tc)>
				AND REFI.TC_IDENTITY_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_visitor_register_tc#">
			</cfif>
			ORDER BY
				REFI.VISIT_TIME DESC
		</cfquery>
        
        <cfif get_query.recordcount><cfreturn Replace(SerializeJson(this.returnData( Replace( SerializeJson( get_query ), "//", "" ))), "//", "") /><cfelse>[]</cfif>

    </cffunction>
    
    <cffunction name="getAutomationModel" access="remote" returnformat="JSON">
        <cfargument name="our_company_id" default="" required="yes">
        <cfquery name="getAutomationModel" datasource="#dsn#">
            SELECT TOP 1 * FROM REFINERY_AUTOMATION_MODEL WHERE STATUS = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
        </cfquery>
        
        <cfset response = {} />

        <cfif getAutomationModel.recordcount and len( getAutomationModel.MODEL_JSON )>

            <cfset automotionModel = deserializeJSON(getAutomationModel.MODEL_JSON) />

            <cfscript>
                structMap(automotionModel, function(key, item){
                    arrayMap( item, function( panelItem, panelIndex ){
                        arrayMap( panelItem["department"], function( departmentItem, departmentIndex ){
                            if( arrayLen( departmentItem["block"] ) ){

                                arrayMap( departmentItem["block"], function( blockItem, blockIndex ){
                                
                                    getDepartment = this.getDepartment( department_id: blockItem.department_id );
                                    automotionModel[key][panelIndex]["department"][departmentIndex]["block"][blockIndex]["department_head"] = getDepartment.DEPARTMENT_HEAD;
    
                                    arrayReduce( blockItem.location, function( acc, locationItem, locationIndex ){
                                        
                                        locationVar = automotionModel[key][panelIndex]["department"][departmentIndex]["block"][blockIndex]["location"][locationIndex];

                                        getLocation = this.getLocation(department_location: locationItem.department_location);
                                        if( getLocation.recordcount ){
                                            locationVar = {
                                                location_id: getLocation.LOCATION_ID,
                                                department_id: getLocation.DEPARTMENT_ID,
                                                department_location: getLocation.DEPARTMENT_LOCATION,
                                                lacation_comment: getLocation.COMMENT,
                                                department_head: getLocation.DEPARTMENT_HEAD,
                                                location_color: locationItem["location_color"],
                                                lacation_width: len(getLocation.WIDTH) ? getLocation.WIDTH : 0,
                                                lacation_height: len(getLocation.HEIGHT) ? getLocation.HEIGHT : 0,
                                                lacation_depth: len(getLocation.DEPTH) ? getLocation.DEPTH : 0,
                                                location_total_waste: 0,
                                                location_total_waste_rate: 0,
                                                production_order: getLocation.IS_PRODUCTION,
                                                transfer_location: [],
                                                location_product: [],
                                                temperature : len(getLocation.TEMPERATURE) ? getLocation.TEMPERATURE : 0000,
                                                pressure : len(getLocation.PRESSURE) ? getLocation.PRESSURE : 0000
                                            };

                                            getStockAmount = this.getStockAmount( locationItem["is_acceptance"], locationItem["department_location"] );
                                            //writeDump( getStockAmount );

                                            if( getStockAmount.recordcount ){
                                                
                                                productCounter = 1;
                                                for (i = 1; i <= getStockAmount.recordcount; i++) {
                                                    locationVar["location_total_waste"] += getStockAmount.TOTAL_ENTRY[i] - getStockAmount.TOTAL_EXIT[i];
                                                    
                                                    if( getStockAmount.TOTAL_ENTRY[i] - getStockAmount.TOTAL_EXIT[i] > 0 ){
                                                        locationVar["location_product"][productCounter] = {
                                                            product_id: getStockAmount.PRODUCT_ID[i],
                                                            product_name: getStockAmount.PRODUCT_NAME[i],
                                                            product_unit_id: getStockAmount.PRODUCT_UNIT_ID[i],
                                                            product_unit_name: getStockAmount.MAIN_UNIT[i],
                                                            stock_id: getStockAmount.STOCK_ID[i],
                                                            amount: getStockAmount.TOTAL_ENTRY[i] - getStockAmount.TOTAL_EXIT[i]
                                                        };
                                                        productCounter++;
                                                    }
                                                }
                                            }

                                            locationVar["location_total_waste_rate"] = locationVar["location_total_waste"] * 100 / (locationVar["lacation_width"] * locationVar["lacation_height"] * locationVar["lacation_depth"] / 1000)
                                            
                                            /* getTotalWaste = this.getTotalWaste(location_id: getLocation.LOCATION_ID, department_id: getLocation.DEPARTMENT_ID);
                                            if( getTotalWaste.recordcount ) automotionModel[key][panelIndex]["department"][departmentIndex]["block"][blockIndex]["location"][locationIndex]["location_total_waste"] = len(getTotalWaste.TOTAL) ? getTotalWaste.TOTAL : 0; */
                                            
                                            if( structKeyExists( locationItem, 'transfer_location' ) and arrayLen( locationItem['transfer_location'] ) ){
    
                                                for (i = 1; i <= arrayLen( locationItem['transfer_location'] ); i++) {
                                                    getTransferLocation = this.getLocation(department_location: locationItem['transfer_location'][i]['department_location']);
                                                    if( getTransferLocation.recordcount ){
                                                        locationVar["transfer_location"][i] = {
                                                            location_id: getLocation.LOCATION_ID,
                                                            department_id: getLocation.DEPARTMENT_ID,
                                                            department_location: getLocation.DEPARTMENT_LOCATION,
                                                            lacation_comment: getLocation.DEPARTMENT_HEAD & ' : ' & getLocation.COMMENT
                                                        }
                                                    }
                                                }
    
                                            }
                                        }

                                        automotionModel[key][panelIndex]["department"][departmentIndex]["block"][blockIndex]["location"][locationIndex] = locationVar;
    
                                    } );
    
                                } );

                            }
                        } );
                    });
                });
                /* writeDump(automotionModel);
                abort; */
            </cfscript>

            <cfset response = automotionModel />

        </cfif>

        <cfif structCount(response)><cfreturn Replace( SerializeJson( response ), "//", "" ) /><cfelse>[]</cfif>

    </cffunction>

    <cffunction name="getDepartment" access="public">
        <cfargument name="department_id" />
        
        <cfquery name="getDepartment" datasource="#dsn#">
            SELECT DEPARTMENT_ID, DEPARTMENT_HEAD
            FROM DEPARTMENT
            WHERE DEPARTMENT_ID = #arguments.department_id# AND DEPARTMENT_STATUS = 1
        </cfquery>

        <cfreturn getDepartment />

    </cffunction>

    <cffunction name="getLocation" access="public">
        <cfargument name="department_location" />
        
        <cfquery name="getLocation" datasource="#dsn#">
            SELECT
                SL.DEPARTMENT_ID,
                SL.LOCATION_ID,
                SL.DEPARTMENT_LOCATION,
                SL.COMMENT,
                SL.WIDTH,
                SL.HEIGHT,
                SL.DEPTH,
                SL.TEMPERATURE,
                SL.PRESSURE,
                D.BRANCH_ID,
                D.DEPARTMENT_HEAD,
                D.IS_PRODUCTION
            FROM 
                STOCKS_LOCATION SL,
                DEPARTMENT D
            WHERE
                SL.DEPARTMENT_LOCATION = '#arguments.department_location#' AND SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.STATUS = 1
        </cfquery>

        <cfreturn getLocation />

    </cffunction>

    <cffunction name="getTotalWaste" access="public">
        <cfargument name="location_id" />
        <cfargument name="department_id" />

        <cfquery name="getTotalWaste" datasource="#dsn#">
            SELECT SUM( ISNULL(CAR_ENTRY_KG,0) - ISNULL(CAR_EXIT_KG,0) ) AS TOTAL FROM REFINERY_WASTE_OIL
            WHERE LOCATION_ID = #arguments.location_id# AND DEPARTMENT_ID = #arguments.department_id# AND CAR_EXIT_KG IS NOT NULL
            GROUP BY LOCATION_ID, DEPARTMENT_ID
        </cfquery>

        <cfreturn getTotalWaste />
        
    </cffunction>

    <cffunction name="getStockAmount" access="public" returntype="any">
        <cfargument name = "acceptance" required="true">
        <cfargument name = "department_location" required="true">

        <cfset department_id = listFirst( arguments.department_location, "-" ) />
        <cfset location_id = listLast( arguments.department_location, "-" ) />

        <cfquery name="getStockAmount" datasource="#dsn2#">
            <cfif arguments.acceptance>
                
                SELECT
                    STR.STOCK_ID,
                    ST.PRODUCT_ID,
                    ST.PRODUCT_NAME,
                    PU.PRODUCT_UNIT_ID,
                    PU.MAIN_UNIT,
                    ISNULL(SUM(STOCK_IN - STOCK_OUT),0) AS TOTAL_ENTRY,
                    ISNULL(SUM(STOCKFIS.SFISAMOUNT),0) AS TOTAL_EXIT
                FROM STOCKS_ROW AS STR
                LEFT JOIN (
                    SELECT 
                        SFISROW.STOCK_ID, 
                        SUM(SFISROW.AMOUNT) AS SFISAMOUNT
                    FROM STOCK_FIS AS SFIS 
                    JOIN STOCK_FIS_ROW AS SFISROW ON SFIS.FIS_ID = SFISROW.FIS_ID 
                    WHERE 
                        SFIS.DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#"> 
                        AND SFIS.LOCATION_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#location_id#">
                    GROUP BY SFISROW.STOCK_ID
                ) AS STOCKFIS ON STR.STOCK_ID = STOCKFIS.STOCK_ID
                JOIN #dsn3#.STOCKS AS ST ON STR.STOCK_ID = ST.STOCK_ID
                JOIN #dsn3#.PRODUCT_UNIT AS PU ON ST.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                WHERE 
                    STR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
                    AND STR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#location_id#">
                GROUP BY 
                    STR.STOCK_ID,
                    ST.PRODUCT_ID,
                    ST.PRODUCT_NAME,
                    PU.PRODUCT_UNIT_ID,
                    PU.MAIN_UNIT

            <cfelse>
                
                SELECT 
                    ENTRIES.STOCK_ID, 
                    ISNULL(ENTRIES.TOTAL_ENTRY,0) AS TOTAL_ENTRY,
                    ISNULL(EXITS.TOTAL_EXIT,0) AS TOTAL_EXIT,
                    ST.PRODUCT_ID,
                    ST.PRODUCT_NAME,
                    PU.PRODUCT_UNIT_ID,
                    PU.MAIN_UNIT
                FROM(
                    SELECT SFISROW.STOCK_ID, ISNULL(SUM(SFISROW.AMOUNT),0) AS TOTAL_ENTRY
                    FROM STOCK_FIS AS SFIS 
                    JOIN STOCK_FIS_ROW AS SFISROW ON SFIS.FIS_ID = SFISROW.FIS_ID 
                    WHERE 
                        SFIS.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#"> 
                        AND SFIS.LOCATION_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#location_id#">
                    GROUP BY SFISROW.STOCK_ID
                ) AS ENTRIES
                LEFT JOIN(
                    SELECT SFISROW.STOCK_ID, ISNULL(SUM(SFISROW.AMOUNT),0) AS TOTAL_EXIT
                    FROM STOCK_FIS AS SFIS 
                    JOIN STOCK_FIS_ROW AS SFISROW ON SFIS.FIS_ID = SFISROW.FIS_ID 
                    WHERE 
                        SFIS.DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#"> 
                        AND SFIS.LOCATION_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#location_id#">
                    GROUP BY SFISROW.STOCK_ID
                ) AS EXITS ON ENTRIES.STOCK_ID = EXITS.STOCK_ID
                JOIN #dsn3#.STOCKS AS ST ON ENTRIES.STOCK_ID = ST.STOCK_ID
                JOIN #dsn3#.PRODUCT_UNIT AS PU ON ST.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID

            </cfif>
        </cfquery>
        
        
		<cfreturn getStockAmount />
    </cffunction>
    
    <!--- <cffunction name="getLabTest" access="remote" returntype="any">
		<cfargument name = "refinery_lab_test_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">
		<cfargument name = "analyze_cat" default="" required="false">

		<cfquery name="getLabTest" datasource="#DSN#">
			SELECT 
				REF.*,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				EMPX.EMPLOYEE_NAME AS SAMPLE_EMPLOYEE_NAME,
				EMPX.EMPLOYEE_SURNAME AS SAMPLE_EMPLOYEE_SURNAME,
				CON.CONSUMER_NAME,
				CON.CONSUMER_SURNAME,
				COM.FULLNAME,
				#dsn#.#dsn#.Get_Dynamic_Language(PROCESS_ROW_ID,'#ucase(session.ep.language)#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE
			FROM 
				REFINERY_LAB_TESTS AS RET
			JOIN PROCESS_TYPE_ROWS AS PTR ON RET.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			JOIN EMPLOYEES AS EMP ON RET.REQUESTING_EMPLOYE_ID = EMP.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES AS EMPX ON RET.SAMPLE_EMPLOYEE_ID = EMPX.EMPLOYEE_ID
			LEFT JOIN CONSUMER AS CON ON RET.CONSUMER_ID = CON.CONSUMER_ID
			LEFT JOIN COMPANY AS COM ON RET.COMPANY_ID = COM.COMPANY_ID
            JOIN REFINERY_WASTE_OIL AS REF ON RET.REFINERY_WASTE_OIL_ID = REF.REFINERY_WASTE_OIL_ID
			WHERE 
                RET.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                AND 
			ORDER BY
				REFINERY_LAB_TEST_ID DESC
		</cfquery>
		<cfreturn getLabTest />
	</cffunction> --->

    <cffunction name="saveTransportOrders" access="remote" returnformat="JSON">
        <cfargument default="" name="process_stage" required="false">
		<cfargument default="" name="transport_ordering_employee_id" required="false">
		<cfargument default="" name="transport_ordering_name" required="false">
		<cfargument default="" name="operator_employee_id" required="false">
		<cfargument default="" name="operator_name" required="false">
		<cfargument default="" name="location_exit_id" required="false">
		<cfargument default="" name="department_exit_id" required="false">
		<cfargument default="" name="branch_exit_id" required="false">
		<cfargument default="" name="location_entry_id" required="false">
		<cfargument default="" name="department_entry_id" required="false">
		<cfargument default="" name="branch_entry_id" required="false">
        <cfargument default="" name="product_id" required="false">
        <cfargument default="" name="stock_id" required="false">
		<cfargument default="" name="product_name" required="false">
		<cfargument default="" name="unit_product_id" required="false">
		<cfargument default="" name="unit_product_name" required="false">
        <cfargument default="" name="amount" required="false">
        <cfargument default="" name="exit_tank_department_location" required="false">
        <cfargument default="" name="exit_tank_location_comment" required="false">
        <cfargument default="" name="entry_tank_transfer_location_id" required="false">

        <cfset result = structNew()>
        <cfset result.status = true>

        <cftry>
            <cftransaction>
                <cfquery name="getProcessStage" datasource="#dsn#">
                    SELECT TOP 1
                        PTR.PROCESS_ROW_ID
                    FROM
                        PROCESS_TYPE_ROWS PTR,
                        PROCESS_TYPE_OUR_COMPANY PTO,
                        PROCESS_TYPE PT
                    WHERE
                        PT.IS_ACTIVE = 1 AND
                        PTR.PROCESS_ID = PT.PROCESS_ID AND
                        PT.PROCESS_ID = PTO.PROCESS_ID AND
                        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%recycle.transport_orders%">
                    ORDER BY
                        PTR.LINE_NUMBER
                </cfquery>
                <cfset arguments.process_stage = getProcessStage.PROCESS_ROW_ID>
                
                <cfif len(arguments.exit_tank_department_location)>
                    <cfset getExitLocation = this.getLocation(department_location : arguments.exit_tank_department_location)>
                    <cfset arguments.location_exit_id = getExitLocation.LOCATION_ID>
                    <cfset arguments.department_exit_id = getExitLocation.DEPARTMENT_ID>
                    <cfset arguments.branch_exit_id = getExitLocation.BRANCH_ID>
                </cfif>

                <cfif len(arguments.entry_tank_transfer_location_id)>
                    <cfset getEntryLocation = this.getLocation(department_location : arguments.entry_tank_transfer_location_id)>
                    <cfset arguments.location_entry_id = getEntryLocation.LOCATION_ID>
                    <cfset arguments.department_entry_id = getEntryLocation.DEPARTMENT_ID>
                    <cfset arguments.branch_entry_id = getEntryLocation.BRANCH_ID>
                </cfif>

                <cfquery name="saveTransportOrders" datasource="#dsn#">
                    INSERT INTO
                        REFINERY_TRANSPORT_ORDERS
                    (
                        PROCESS_STAGE,
                        ORDERING_EMPLOYEE_ID,
                        OPERATOR_EMPLOYEE_ID,
                        LOCATION_EXIT_ID,
                        DEPARTMENT_EXIT_ID,
                        BRANCH_EXIT_ID,
                        LOCATION_ENTRY_ID,
                        DEPARTMENT_ENTRY_ID,
                        BRANCH_ENTRY_ID,
                        PRODUCT_ID,
                        STOCK_ID,
                        UNIT_PRODUCT_ID,
                        AMOUNT,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        OUR_COMPANY_ID
                    )
                    VALUES
                    (
                        <cfif len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"></cfif>,
                        <cfif len(arguments.transport_ordering_employee_id) AND len(arguments.transport_ordering_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transport_ordering_employee_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.operator_employee_id) AND len(arguments.operator_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.operator_employee_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.location_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_exit_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.department_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_exit_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.branch_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_exit_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.location_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_entry_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.department_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_entry_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.branch_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_entry_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.product_id) AND len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.stock_id) AND len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.unit_product_id) AND len(arguments.unit_product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_product_id#"><cfelse>NULL</cfif>,
                        <cfif len(arguments.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.amount#"><cfelse>NULL</cfif>,
                        #session.ep.userid#,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    )
                </cfquery>
            </cftransaction>
            <cfcatch type="any">
                <cfset result.status = false>
            </cfcatch>
        </cftry>

        <cfreturn LCase(Replace(serializeJSON(result), "//", ""))>
    </cffunction>

    <cffunction name="get_sub_product" access="remote" returnformat="JSON">
        <cfargument name="stock_id" required="true">
        
        <cfquery name="get_sub_product" datasource="#dsn3#">
            SELECT
                SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
                SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
                ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
                STOCKS.PRODUCT_ID,
                STOCKS.STOCK_ID,
                STOCKS.STOCK_CODE,
                STOCKS.PRODUCT_NAME,
                PRODUCT_UNIT.PRODUCT_UNIT_ID,
                PRODUCT_UNIT.MAIN_UNIT,
                0 IS_PHANTOM,
                SPECT_MAIN_ROW.IS_SEVK,
                SPECT_MAIN_ROW.IS_PROPERTY,
                ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
                ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
                0 AS SUB_SPEC_MAIN_ID,
                SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
                ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) LINE_NUMBER,
                ISNULL(SPECT_MAIN_ROW.LINE_NUMBER,0) MAIN_LINE_NUMBER,
                SPECT_MAIN.SPECT_MAIN_NAME
            FROM
                SPECT_MAIN,
                SPECT_MAIN_ROW,
                STOCKS,
                PRODUCT_UNIT,
                PRICE_STANDART
            WHERE
                PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                PRICE_STANDART.PURCHASESALES = 1 AND
                PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                STOCKS.STOCK_STATUS = 1	AND
                SPECT_MAIN.SPECT_MAIN_ID = (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">) AND
                SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
                ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
                PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID AND
                STOCKS.STOCK_ID NOT IN (0)
            ORDER BY
                MAIN_LINE_NUMBER,
                LINE_NUMBER
        </cfquery>

        <cfreturn get_sub_product.recordcount ? Replace(SerializeJson(this.returnData( Replace( SerializeJson( get_sub_product ), "//", "" ))), "//", "") : '[]' />

    </cffunction>

    <cffunction name="saveProductionOrders" access="remote" returnformat="JSON">
        <cfargument name="product_id" required="true">
        <cfargument name="stock_id" required="true">
		<cfargument name="product_name" required="true">
		<cfargument name="unit_product_id" required="true">
		<cfargument name="unit_product_name" required="true">
        <cfargument name="amount" required="true">
        <cfargument name="spect_main_id" required="true">
        <cfargument name="spect_main_name" required="true">
        <cfargument name="sub_products" required="true">

        <cfset all_sub_products = deserializeJson(arguments.sub_products) />

        <cfset result = structNew()>
        <cfset result.status = true>

        <cfset wrk_prod_order_id = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##round(rand()*100)#'>
		<cf_papers paper_type = "prod_order"><!--- Belge Numarası her üretim için tek tek alınıyor! --->
		<cfset p_order_paper_no = paper_code & '-' & paper_number>
		<cfset p_order_paper_no_add = paper_number>
		<cf_papers paper_type = "production_lot"><!--- Lot numarası sadece 1 kere alınacak --->
		<cfset lot_p_order_paper_no = paper_code & '-' & paper_number>
		<cfset lot_p_order_paper_no_add = paper_number>
		<cfquery name="get_prod_name" datasource="#dsn3#">
			SELECT P.PRODUCT_NAME FROM STOCKS AS S JOIN PRODUCT AS P ON P.PRODUCT_ID = S.PRODUCT_ID WHERE S.STOCK_ID = #arguments.stock_id#
        </cfquery>
        <cfquery name="get_workstation" datasource="#dsn3#">
            SELECT WSP.WS_ID, W.EXIT_DEP_ID, W.EXIT_LOC_ID, W.ENTER_DEP_ID, W.ENTER_LOC_ID, W.PRODUCTION_DEP_ID, W.PRODUCTION_LOC_ID
            FROM WORKSTATIONS_PRODUCTS WSP, WORKSTATIONS W 
            WHERE W.STATION_ID = WSP.WS_ID AND WSP.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
        </cfquery>

        <cfquery name="getProcessStage" datasource="#dsn#">
            SELECT TOP 1
                PTR.PROCESS_ROW_ID
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.list_results%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfset attributes.process_stage = getProcessStage.PROCESS_ROW_ID>

        <!--- <cftry> --->
            <cftransaction>
                <!--- ÜRETİM EMRİ --->
                <cfquery name="PRODUCTION_ORDERS" datasource="#dsn3#">
                    INSERT INTO 
                        PRODUCTION_ORDERS(
                            STOCK_ID,
                            QUANTITY,
                            START_DATE,
                            FINISH_DATE,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP,
                            STATUS,
                            P_ORDER_NO,
                            PROD_ORDER_STAGE,
                            STATION_ID,
                            SPECT_VAR_ID,
                            SPECT_VAR_NAME,
                            IS_STOCK_RESERVED,
                            IS_DEMONTAJ,
                            LOT_NO,
                            PRODUCTION_LEVEL,
                            SPEC_MAIN_ID,
                            IS_STAGE,
                            WRK_ROW_ID,
                            EXIT_DEP_ID,
                            EXIT_LOC_ID,
                            PRODUCTION_DEP_ID,
                            PRODUCTION_LOC_ID
                        )
                        VALUES
                        ( 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.amount#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#dateadd('m',1,now())#">,
                            #session.ep.userid#,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                            1,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#p_order_paper_no#">,
                            NULL,
                            <cfif get_workstation.recordcount>#get_workstation.WS_ID#<cfelse>NULL</cfif>,
                            NULL,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_prod_name.PRODUCT_NAME#">,
                            0,
                            0,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#lot_p_order_paper_no#">,
                            0,
                            NULL,
                            1,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrk_prod_order_id#">,
                            24,
                            14,
                            24,
                            13	
                        )
                </cfquery>
                <cfstoredproc procedure="UPD_GENERAL_PAPERS_LOT_NUMBER" datasource="#dsn3#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#lot_p_order_paper_no_add#">
                </cfstoredproc>
                <cfstoredproc procedure="UPD_GENERAL_PAPERS_PROD_ORDER_NUMBER" datasource="#dsn3#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#p_order_paper_no_add#">
                </cfstoredproc>
                <cfstoredproc procedure="GET_PRODUCTION_ORDER_MAX" datasource="#dsn3#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_prod_order_id#">
                    <cfprocresult name="GET_MAX">
                </cfstoredproc>

                <cfquery name="get_spect_main" datasource="#dsn3#">
                    SELECT SPECT_MAIN_ID FROM SPECT_MAIN WHERE STOCK_ID = #arguments.stock_id#
                </cfquery>

                <cfloop array="#all_sub_products#" item="item">
                    <cfset amount_ = item.is_free_amount eq 1 ? item.amount : item.amount * get_max.amount />
                    <cfset item["wrk_id_new_sarf"] = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')#22#round(rand()*100)#U#get_max.pid#S#item.stock_id#'>

                    <cfstoredproc procedure="ADD_PRODUCTION_ORDERS_STOCKS" datasource="#dsn3#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#get_max.pid#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.product_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.stock_id#">
                        <cfif len(item.related_main_spect_id)>
                            <cfprocparam cfsqltype="cf_sql_integer" value="#item.related_main_spect_id#">
                        <cfelse>
                            <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        </cfif>
                        <cfprocparam cfsqltype="cf_sql_float" value="#amount_#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="2">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.unit_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="22">
                        <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
                        <cfprocparam cfsqltype="cf_sql_bit" value="#item.is_phantom#">
                        <cfprocparam cfsqltype="cf_sql_bit" value="#item.is_sevk#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.is_property#">
                        <cfprocparam cfsqltype="cf_sql_bit" value="#item.is_free_amount#">
                        <cfprocparam cfsqltype="cf_sql_float" value="#item.fire_amount#">
                        <cfprocparam cfsqltype="cf_sql_float" value="#item.fire_rate#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.spect_main_row_id#">
                        <cfprocparam cfsqltype="cf_sql_bit" value="1">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#item.wrk_id_new_sarf#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.main_line_number#">
                    </cfstoredproc>
                </cfloop>

                <cfquery name="upd_spect_main" datasource="#dsn3#">
                    UPDATE PRODUCTION_ORDERS SET SPEC_MAIN_ID = #get_spect_main.SPECT_MAIN_ID# WHERE P_ORDER_ID = #get_max.pid#
                </cfquery>
                <!--- ÜRETİM EMRİ --->

                <!--- ÜRETİM SONUCU --->
                <cf_papers paper_type="PRODUCTION_RESULT">
                <cfset pr_order_paper_no = paper_code & '-' & paper_number>
                <cfscript>
                    //pr_order_paper_no_add = paper_number;
                    start_minute = 0;
                    finish_minute = 0;
                    hour_time = ( finish_minute - start_minute ) / 60;
                </cfscript>

                <cfstoredproc procedure="ADD_PRODUCTION_ORDER_RESULT" datasource="#DSN3#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#get_max.pid#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="110">
                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    <cfif get_workstation.recordcount and len(get_workstation.EXIT_DEP_ID)><cfprocparam cfsqltype="cf_sql_integer" value="#get_workstation.EXIT_DEP_ID#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif get_workstation.recordcount and len(get_workstation.EXIT_LOC_ID)><cfprocparam cfsqltype="cf_sql_integer" value="#get_workstation.EXIT_LOC_ID#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif get_workstation.recordcount and len(get_workstation.WS_ID)><cfprocparam cfsqltype="cf_sql_integer" value="#get_workstation.WS_ID#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#p_order_paper_no#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#pr_order_paper_no#">
                    <cfif get_workstation.recordcount and len(get_workstation.ENTER_DEP_ID)><cfprocparam cfsqltype="cf_sql_integer" value="#get_workstation.ENTER_DEP_ID#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif get_workstation.recordcount and len(get_workstation.ENTER_LOC_ID)><cfprocparam cfsqltype="cf_sql_integer" value="#get_workstation.ENTER_LOC_ID#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    <cfprocparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#lot_p_order_paper_no#">
                    <cfif get_workstation.recordcount and len(get_workstation.PRODUCTION_DEP_ID)><cfprocparam cfsqltype="cf_sql_integer" value="#get_workstation.PRODUCTION_DEP_ID#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfif get_workstation.recordcount and len(get_workstation.PRODUCTION_LOC_ID)><cfprocparam cfsqltype="cf_sql_integer" value="#get_workstation.PRODUCTION_LOC_ID#"><cfelse><cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes"></cfif>
                    <cfprocparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
                    <cfprocparam cfsqltype="cf_sql_bit" value="0">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#">
                    <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                </cfstoredproc>
            
                <cfstoredproc procedure="GET_PRODUCTION_ORDER_RESULT_MAX_ID" datasource="#dsn3#">
                    <cfprocresult name="GET_MAX2">
                </cfstoredproc>

                <cfstoredproc procedure="UPD_GENERAL_PAPERS" datasource="#dsn3#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#paper_number#">
                </cfstoredproc>

                <cfscript>
                    value_price = 0;
                    value_price_extra = 0;
                    value_price2 = 0;
                    value_price_extra2 = 0;
                </cfscript>

                <!--- Sarf --->

                <cfloop array="#all_sub_products#" item="item">

                    <cfset wrk_row_id_sarf = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##get_max2.max_id##item.stock_id#_2'>
                    
                    <cfstoredproc procedure="ADD_PRODUCTION_ORDER_RESULTS_ROW_S" datasource="#dsn3#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="S"><!--- EĞER S GELİRSE NORMAL SARF P GELİRSE  PHANTOM ÜRÜN'ÜN İÇERİĞİNDEN  O GELİRSE OPERASYONUN ALTINDAN GELEN ÜRÜN ANLAMAINA GELMEKTEDİR. --->
                        <cfprocparam cfsqltype="cf_sql_integer" value="2">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#get_max2.max_id#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.stock_id#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.product_id#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        <cfprocparam cfsqltype="cf_sql_float" value="#item.amount#">
                        <cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.unit_id#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#left(item.product_name,75)#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#left(item.unit,75)#">
                        <cfprocparam cfsqltype="cf_sql_bit" value="#item.is_sevk#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                        <cfif len(item.spect_main_row_id)><cfprocparam cfsqltype="cf_sql_integer" value="#item.spect_main_row_id#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes"></cfif>
                        <cfif len(item.spect_main_name)><cfprocparam cfsqltype="cf_sql_varchar" value="#left(item.spect_main_name,50)#"><cfelse><cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes"></cfif>
                        <cfprocparam cfsqltype="cf_sql_integer" value="0">
                        <cfprocparam cfsqltype="cf_sql_float" value="18">
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                        <cfprocparam cfsqltype="cf_sql_float" value="0">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="NULL" null="yes">
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                        <cfprocparam cfsqltype="cf_sql_bit" value="#item.is_free_amount#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_row_id_sarf#">
                        <cfprocparam cfsqltype="cf_sql_varchar" value="#item.wrk_id_new_sarf#">
                        <cfprocparam cfsqltype="cf_sql_integer" value="#item.line_number#">
                        <cfprocparam cfsqltype="cf_sql_bit" value="0">
                        <cfprocparam cfsqltype="cf_sql_timestamp" value="NULL" null="yes">
                    </cfstoredproc>
                    <cfscript>
                        form_amount_exit = item.amount;
                        form_cost_price_system_exit = 0;
                        form_cost_price_exit_2 = 0;
                        form_purchase_extra_cost_system_exit = 0;
                        form_cost_price_exit_extra_2 = 0;
                        deger_value_total_price = 0;

                        value_price = value_price + form_cost_price_system_exit * form_amount_exit;
                        value_price_extra = value_price_extra + form_purchase_extra_cost_system_exit * form_amount_exit;
                        value_price2 = value_price2 + form_cost_price_exit_2 * form_amount_exit;
                        value_price_extra2 = value_price_extra2 + form_cost_price_exit_extra_2 * form_amount_exit;
                    </cfscript>
                </cfloop>

                <cfset wrk_row_id_ = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##get_max2.max_id##arguments.stock_id#_1'>
                <cfstoredproc procedure="ADD_PRODUCTION_ORDER_RESULTS_ROW" datasource="#dsn3#">	
                    <cfprocparam cfsqltype="cf_sql_varchar" value="S"><!--- EĞER S GELİRSE NORMAL SARF P GELİRSE  PHANTOM ÜRÜN'ÜN İÇERİĞİNDEN  O GELİRSE OPERASYONUN ALTINDAN GELEN ÜRÜN ANLAMAINA GELMEKTEDİR. --->
                    <cfprocparam cfsqltype="cf_sql_integer" value="1">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#get_max2.max_id#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="NULL">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                    <cfprocparam cfsqltype="cf_sql_float" value="#arguments.amount#">
                    <cfprocparam cfsqltype="cf_sql_float" value="NULL" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#arguments.unit_product_id#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="NULL">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(arguments.product_name,75)#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(arguments.unit_product_name,75)#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    <cfprocparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#left(arguments.spect_main_name,50)#">
                    <cfprocparam cfsqltype="cf_sql_integer" value="NULL" null="yes">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_float" value="#deger_value_total_price#">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="NULL">
                    <cfprocparam cfsqltype="cf_sql_float" value="0">
                    <cfprocparam cfsqltype="cf_sql_bit" value="0">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_row_id_#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#wrk_prod_order_id#">
                </cfstoredproc>

                <!--- üRETİMİN AŞAMSINI DEĞİŞTİRİYORUZ. --->	
                <cfquery name="get_result_amount" datasource="#dsn3#">
                    SELECT
                        ISNULL(SUM(POR_.AMOUNT),0) RESULT_AMOUNT
                    FROM
                        PRODUCTION_ORDER_RESULTS_ROW POR_,
                        PRODUCTION_ORDER_RESULTS POO
                    WHERE
                        POR_.PR_ORDER_ID = POO.PR_ORDER_ID
                        AND POO.P_ORDER_ID = #get_max.pid#
                        AND POR_.TYPE = 1
                        AND POO.IS_STOCK_FIS = 1
                        AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
                </cfquery>
                <cfquery name="upd_prod_orders" datasource="#dsn3#">
                    UPDATE PRODUCTION_ORDERS SET IS_STAGE = 1, RESULT_AMOUNT = #get_result_amount.RESULT_AMOUNT# WHERE P_ORDER_ID = #get_max.pid#
                </cfquery>

                <!--- ÜRETİM SONUCU STOK FİŞLERİ --->
                
                <cfset session_userid = session.ep.userid>
                <cfset session_period_year = session.ep.period_year>
                <cfset session_period_id = session.ep.period_id>
                <cfset session_company_id = session.ep.company_id>
                <cfset session_money = session.ep.money>
                <cfset session_money2 = session.ep.money2>
                <cfset session_our_company_info_spect_type = session.ep.our_company_info.spect_type>
                <cfset session_our_company_info_is_cost = session.ep.our_company_info.is_cost>

                <cfset session_base.money = session.ep.money>
                <cfset session_base.money2 = session.ep.money2>
                <cfset session_base.userid = session.ep.userid> 
                <cfset session_base.company_id = session.ep.company_id>
                <cfset session_base.period_id = session.ep.period_id>

                <cfset attributes.p_order_id = get_max.pid>
                <cfset attributes.pr_order_id = get_max2.max_id >

                <cfquery name="GET_ROW_RESULT" datasource="#DSN3#">
                    SELECT
                    (SELECT PROJECT_ID FROM PRODUCTION_ORDERS WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">) PROJECT_ID,
                        PRODUCTION_ORDER_RESULTS.ORDER_NO,
                        PRODUCTION_ORDER_RESULTS.RESULT_NO,
                        PRODUCTION_ORDER_RESULTS.PRODUCTION_ORDER_NO,
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
                        PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
                        PRODUCTION_ORDER_RESULTS.PROCESS_ID,
                        PRODUCTION_ORDER_RESULTS.FINISH_DATE,
                        PRODUCTION_ORDER_RESULTS.PRODUCTION_DEP_ID,
                        PRODUCTION_ORDER_RESULTS.PRODUCTION_LOC_ID,
                        PRODUCTION_ORDER_RESULTS.ENTER_DEP_ID,
                        PRODUCTION_ORDER_RESULTS.ENTER_LOC_ID,
                        PRODUCTION_ORDER_RESULTS.EXIT_DEP_ID,
                        PRODUCTION_ORDER_RESULTS.EXIT_LOC_ID,
                        PRODUCTION_ORDER_RESULTS.POSITION_ID,
                        PRODUCTION_ORDER_RESULTS.LOT_NO,
                        PRODUCTION_ORDER_RESULTS_ROW.TYPE,
                        PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.LOT_NO ROW_LOT_NO,
                        PRODUCTION_ORDER_RESULTS_ROW.EXPIRATION_DATE ROW_EXPIRATION_DATE,
                        PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
                        PRODUCTION_ORDER_RESULTS_ROW.AMOUNT2,
                        PRODUCTION_ORDER_RESULTS_ROW.UNIT_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.UNIT2,
                        PRODUCTION_ORDER_RESULTS_ROW.SPECT_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.SPEC_MAIN_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.NAME_PRODUCT,
                        PRODUCTION_ORDER_RESULTS_ROW.KDV_PRICE,
                        PRODUCTION_ORDER_RESULTS_ROW.COST_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM AMOUNT_PRICE,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM_TOTAL TOTAL_PRICE,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_MONEY OTHER_MONEY_CURRENCY,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET OTHER_MONEY,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_TOTAL OTHER_MONEY_TOTAL,
                        PRODUCTION_ORDER_RESULTS_ROW.UNIT_NAME,
                        PRODUCTION_ORDER_RESULTS_ROW.SPECT_NAME,
                        PRODUCTION_ORDER_RESULTS_ROW.IS_SEVKIYAT,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_EXTRA_COST_SYSTEM PURCHASE_EXTRA_COST,
                        PRODUCTION_ORDER_RESULTS.IS_STOCK_FIS,
                        ISNULL(PRODUCTION_ORDER_RESULTS_ROW.LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM, 
                        ISNULL(PRODUCTION_ORDER_RESULTS_ROW.STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
                        PRODUCTION_ORDER_RESULTS.EXPIRATION_DATE
                    FROM
                        PRODUCTION_ORDER_RESULTS,
                        PRODUCTION_ORDER_RESULTS_ROW,
                        STOCKS S
                    WHERE
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
                        S.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
                        S.IS_INVENTORY = 1
                </cfquery>

                <cfquery name="GET_ROW" dbtype="query">
                    SELECT * FROM GET_ROW_RESULT WHERE TYPE = 1
                </cfquery>

                <cfquery name="GET_ROW_EXIT" dbtype="query">
                    SELECT * FROM GET_ROW_RESULT WHERE TYPE = 2
                </cfquery>
                <cfquery name="GET_ROW_OUTAGE" dbtype="query">
                    SELECT * FROM GET_ROW_RESULT WHERE TYPE = 3
                </cfquery>
                <cfquery name="GET_MONEY_FIS" datasource="#dsn3#">
                    SELECT * FROM #dsn2#.SETUP_MONEY<!--- STOCK_FIS_MONEY KAYITLARI ICIN --->
                </cfquery>
                <cfset new_finish_date = createdate(year(get_row_result.finish_date),month(get_row_result.finish_date),day(get_row_result.finish_date))>
                <cfset value_finish_date = createdatetime(year(get_row_result.finish_date),month(get_row_result.finish_date),day(get_row_result.finish_date),0,0,0)>
                <cfset finish_date_time = createdatetime(year(get_row_result.finish_date),month(get_row_result.finish_date),day(get_row_result.finish_date),hour(get_row_result.finish_date),minute(get_row_result.finish_date),0)>

                <cfquery name="GET_PROCESS_TYPE_URT" datasource="#DSN3#">
                    SELECT 
                        PROCESS_CAT_ID,
                        PROCESS_TYPE,
                        IS_STOCK_ACTION,
                        IS_COST
                     FROM 
                        SETUP_PROCESS_CAT
                    WHERE 
                        PROCESS_TYPE = 110
                </cfquery>

                <cfquery name="GET_PROCESS_TYPE_SARF" datasource="#DSN3#">
                    SELECT 
                        PROCESS_CAT_ID,
                        PROCESS_TYPE,
                        IS_STOCK_ACTION
                    FROM 
                        SETUP_PROCESS_CAT 
                    WHERE 
                        PROCESS_TYPE = 111
                        <cfif isdefined("attributes.process_type_111") and len(attributes.process_type_111)>
                            AND PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_111#">
                        </cfif>
                </cfquery>

                <!--- üretimden çıkış fişi --->
                <cfif get_row.recordcount>
                    <cf_papers paper_type="stock_fis">
                    <cfscript>
                        attributes.system_paper_no = paper_code & '-' & paper_number;
                        attributes.system_paper_no_add = paper_number;
                        attributes.fis_no = attributes.system_paper_no;
                        attributes.fis_type = get_process_type_urt.process_type;
                    </cfscript>
                    <cfquery name="ADD_STOCK_FIS_1" datasource="#DSN3#">
                        INSERT INTO 
                            #dsn2#.STOCK_FIS
                        (
                            FIS_TYPE,
                            PROCESS_CAT,
                            FIS_NUMBER,
                            DEPARTMENT_IN,
                            LOCATION_IN,
                            PROD_ORDER_RESULT_NUMBER,
                            PROD_ORDER_NUMBER,
                            EMPLOYEE_ID,
                            FIS_DATE,
                            DELIVER_DATE,
                            PROJECT_ID_IN,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP,
                            REF_NO
                        )
                        VALUES
                        (
                            #attributes.fis_type#,
                            #get_process_type_urt.process_cat_id#,
                            '#attributes.fis_no#',
                            #get_row.production_dep_id#,
                            #get_row.production_loc_id#,
                            #get_row.pr_order_id#,
                            #get_row.p_order_id#,
                            <cfif len(get_row.position_id)>#get_row.position_id#<cfelse>NULL</cfif>,
                            #value_finish_date#,
                            #finish_date_time#,
                            <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                            #new_finish_date#,
                            #session_userid#,
                            '#cgi.remote_addr#',
                            '#get_row.order_no#'
                        )
                    </cfquery>
                    
                    <cfquery name="GET_ID" datasource="#DSN3#">
                        SELECT
                            MAX(FIS_ID) MAX_ID
                        FROM
                            #dsn2#.STOCK_FIS STOCK_FIS
                    </cfquery>

                    <cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
                        <cfquery name="ADD_FIS_MONEY" datasource="#DSN3#">
                            INSERT INTO
                                #dsn2#.STOCK_FIS_MONEY
                                (
                                    ACTION_ID,
                                    MONEY_TYPE,
                                    RATE2,
                                    RATE1,
                                    IS_SELECTED
                                )
                                VALUES
                                (
                                    #get_id.max_id#,
                                    '#get_money_fis.money#',
                                    #get_money_fis.rate2#,
                                    #get_money_fis.rate1#,
                                    <cfif get_money_fis.money eq session_money>1<cfelse>0</cfif>
                                )
                        </cfquery>
                    </cfoutput>
                    <cfoutput query="get_row">
                        <cfscript>
                            project_id = get_row.PROJECT_ID;
                            amount_rw = get_row.amount;
                            _form_products_id_ = get_row.product_id;
                            _form_stocks_id_ = get_row.stock_id;
                            form_spect_id = get_row.spect_id;
                            form_spect_name = get_row.spect_name;
                            form_spec_main_id = get_row.spec_main_id;
                            form_unit_id = get_row.unit_id;
                            form_unit2 =  get_row.unit2;
                            _form_amounts_ = get_row.amount;
                            form_amount2 = get_row.amount2;
                            form_amount_price = get_row.amount_price;
                            form_tax = get_row.kdv_price;
                            //form_total_price = get_row.total_price
                            form_other_money = get_row.other_money;
                            form_other_money_currency = get_row.other_money_currency;
                            form_cost = get_row.amount_price + get_row.purchase_extra_cost;
                            form_extra_cost = get_row.labor_cost_system + get_row.station_reflection_cost_system;
                        </cfscript>
                        <cfquery name="GET_UNIT" datasource="#DSN3#">
                            SELECT 
                                ADD_UNIT,
                                MULTIPLIER,
                                MAIN_UNIT,
                                PRODUCT_UNIT_ID
                            FROM
                                PRODUCT_UNIT 
                            WHERE 
                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_form_products_id_#"> AND
                                PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_unit_id#">
                        </cfquery>
                        <cfif get_unit.recordcount and len(get_unit.multiplier)>
                            <cfset multi = get_unit.multiplier*amount_rw>
                        <cfelse>
                            <cfset multi = amount_rw>
                        </cfif>
                        <cfif len(form_spec_main_id) and form_spec_main_id gt 0 and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
                            <cfscript>
                                //Buradada fonksiyondan gelen main_spect_id kullanılarak yeni bir spect_id oluşturuluyor
                                main_to_spect = specer(
                                        dsn_type:dsn3,
                                        spec_type:1,
                                        main_spec_id:form_spec_main_id,
                                        add_to_main_spec:1
                                );
                            </cfscript>
                            <cfset form_spect_id = listgetat(main_to_spect,2,',')>
                        </cfif>
                        <cfquery name="ADD_STOCK_FIS_ROW_1" datasource="#DSN3#">
                            INSERT INTO 
                                #dsn2#.STOCK_FIS_ROW
                            (
                                FIS_ID,
                                FIS_NUMBER,
                                STOCK_ID,
                                AMOUNT,
                                AMOUNT2,
                                UNIT,
                                UNIT2,					
                                UNIT_ID,
                                PRICE,
                                TAX,
                                TOTAL,
                                TOTAL_TAX,
                                NET_TOTAL,
                                SPECT_VAR_ID,
                                SPEC_MAIN_ID,
                                SPECT_VAR_NAME,
                                <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>LOT_NO,</cfif>
                                OTHER_MONEY,
                                PRICE_OTHER,
                                COST_PRICE,
                                EXTRA_COST,
                                ROW_PROJECT_ID,
                                DELIVER_DATE,
                                WRK_ROW_ID
                            )
                            VALUES
                            (
                                #get_id.max_id#,
                                '#attributes.fis_no#',						
                                #_form_stocks_id_#,
                                #amount_rw#,
                                <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
                                '#get_unit.main_unit#',
                                <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
                                #form_unit_id#,
                                #form_amount_price#,
                                #form_tax#,
                                #amount_rw*form_amount_price#,
                                #(amount_rw*form_amount_price*form_tax)/100#,
                                #amount_rw*form_amount_price#,																						
                                <cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
                                <cfif len(form_spec_main_id) and form_spec_main_id gt 0 >#form_spec_main_id#<cfelse>NULL</cfif>,
                                <cfif len(form_spect_name)>'#form_spect_name#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                                    <cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>,
                                </cfif>
                                '#form_other_money_currency#',
                                #form_other_money#,
                                #form_cost#,
                                <cfif len(form_extra_cost)>#form_extra_cost#<cfelse>0</cfif>,
                                <cfif len(project_id)>#project_id#<CFELSE>NULL</cfif>,
                                <cfif len(GET_ROW_RESULT.EXPIRATION_DATE)>#createodbcdatetime(GET_ROW_RESULT.EXPIRATION_DATE)#<cfelse>NULL</cfif>
                                ,'#createUUID()#'
                            )
                        </cfquery>
                        <cfquery name="ADD_STOCK_ROW" datasource="#DSN3#">
                            INSERT INTO
                                #dsn2#.STOCKS_ROW
                            (
                                UPD_ID,
                                PRODUCT_ID,
                                STOCK_ID,
                                PROCESS_TYPE,
                                STOCK_IN,
                                STORE,
                                STORE_LOCATION,
                                PROCESS_DATE,
                                PROCESS_TIME,
                                SPECT_VAR_ID
                                <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>,LOT_NO,DELIVER_DATE</cfif>
                            )
                            VALUES
                            (
                                #get_id.max_id#,
                                #_form_products_id_#,
                                #_form_stocks_id_#,
                                #attributes.fis_type#,
                                #multi#,
                                #get_row.production_dep_id#,
                                #get_row.production_loc_id#,
                                #value_finish_date#,
                                #finish_date_time#,
                                <cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>
                                <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                                    ,<cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>
                                    ,<cfif len(GET_ROW_RESULT.EXPIRATION_DATE)>#createodbcdatetime(GET_ROW_RESULT.EXPIRATION_DATE)#<cfelse>NULL</cfif>
                                </cfif>
                            )
                        </cfquery>
                    </cfoutput>
                    <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                        UPDATE 
                            GENERAL_PAPERS
                        SET
                            STOCK_FIS_NUMBER = #attributes.system_paper_no_add#
                        WHERE
                            STOCK_FIS_NUMBER IS NOT NULL
                    </cfquery>
                </cfif>
                
                <!--- sarf fişi --->
                <cfif get_row_exit.recordcount>
                    <cf_papers paper_type="stock_fis">
                    <cfscript>
                        attributes.system_paper_no = paper_code & '-' & paper_number;
                        attributes.system_paper_no_add = paper_number;
                        attributes.fis_no = attributes.system_paper_no;
                        attributes.fis_type = get_process_type_sarf.process_type;
                    </cfscript>
                    <cfquery name="GET_FIS_NUMBER_2" datasource="#DSN3#">
                        SELECT 
                            *
                         FROM 
                            #dsn2_alias#.STOCK_FIS
                        WHERE 
                            FIS_NUMBER = '#attributes.fis_no#'
                    </cfquery>
                    <cfif GET_FIS_NUMBER_2.recordcount>
                        <script type="text/javascript">
                            alert("Aynı Belge Numaralı Stok Fişi Var!");                    
                            history.go(-1);                 
                        </script>
                        <cfabort>
                    </cfif>
                    <cfquery name="ADD_STOCK_FIS_2" datasource="#DSN3#">
                        INSERT INTO 
                            #dsn2_alias#.STOCK_FIS
                        (
                            FIS_TYPE,
                            PROCESS_CAT,
                            FIS_NUMBER,
                            DEPARTMENT_OUT,
                            LOCATION_OUT,
                            PROD_ORDER_RESULT_NUMBER,
                            PROD_ORDER_NUMBER,
                            EMPLOYEE_ID,
                            FIS_DATE,
                            DELIVER_DATE,
                            PROJECT_ID,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP,
                            REF_NO
                        )
                        VALUES
                        (
                            #attributes.fis_type#,
                            #get_process_type_sarf.process_cat_id#,
                           '#attributes.fis_no#',
                            #get_row.exit_dep_id#,
                            #get_row.exit_loc_id#,
                            #get_row.pr_order_id#,
                            #attributes.p_order_id#,
                            <cfif len(get_row.position_id)>#get_row.position_id#<cfelse>NULL</cfif>,
                            #value_finish_date#,
                            #finish_date_time#,
                            <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                            #now()#,
                            #session_userid#,
                           '#cgi.remote_addr#',
                           '#get_row.order_no#'
                        )
                    </cfquery>
                    <cfquery name="GET_ID_EXIT" datasource="#DSN3#">
                        SELECT
                            MAX(FIS_ID) MAX_ID
                        FROM
                            #dsn2_alias#.STOCK_FIS STOCK_FIS
                    </cfquery>
                    <cfoutput query="GET_MONEY_FIS"><!--- fis_money_kayitlari --->
                        <cfquery name="ADD_FIS_MONEY" datasource="#DSN3#">
                            INSERT INTO
                                #dsn2_alias#.STOCK_FIS_MONEY
                                (
                                    ACTION_ID,
                                    MONEY_TYPE,
                                    RATE2,
                                    RATE1,
                                    IS_SELECTED
                                )
                                VALUES
                                (
                                    #get_id_exit.max_id#,
                                    '#get_money_fis.money#',
                                    #get_money_fis.rate2#,
                                    #get_money_fis.rate1#,
                                    <cfif get_money_fis.money eq session_money>1<cfelse>0</cfif>
                                )
                        </cfquery>
                    </cfoutput>
                    <cfoutput query="get_row_exit">
                        <cfscript>
                            project_id = get_row_exit.PROJECT_ID;
                            amount_rw = get_row_exit.amount;
                            _form_products_id_ = get_row_exit.product_id;
                            _form_stocks_id_ = get_row_exit.stock_id;
                            form_spect_id = get_row_exit.spect_id;
                            form_spect_name = get_row_exit.spect_name;
                            form_spec_main_id = get_row_exit.spec_main_id;
                            form_unit_id = get_row_exit.unit_id;
                            form_unit2 = get_row_exit.unit2;
                            _form_amounts_ = get_row_exit.amount;
                            form_amount2 = get_row_exit.amount2;
                            form_amount_price = get_row_exit.amount_price;
                            form_tax = get_row_exit.kdv_price;
                            form_total_price = get_row_exit.total_price;
                            //form_kdv_price = get_row_exit.total_kdv;
                            form_other_money = get_row_exit.other_money;
                            form_other_money_currency = get_row_exit.other_money_currency;
                            form_extra_cost = get_row_exit.purchase_extra_cost;
                            form_cost_id = get_row_exit.COST_ID;
                        </cfscript>
                        <cfquery name="GET_UNIT" datasource="#DSN3#">
                            SELECT 
                                ADD_UNIT,
                                MULTIPLIER,
                                MAIN_UNIT,
                                PRODUCT_UNIT_ID
                            FROM
                                PRODUCT_UNIT 
                            WHERE 
                                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_form_products_id_#"> AND
                                PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_unit_id#"> AND
                                PRODUCT_UNIT_STATUS = 1
                        </cfquery>
                        <cfif get_unit.recordcount and len(get_unit.multiplier)>
                            <cfset multi = get_unit.multiplier*amount_rw>
                        <cfelse>
                            <cfset multi = amount_rw>
                        </cfif>
                        <cfif len(form_spec_main_id) and form_spec_main_id gt 0 and not len(form_spect_id) ><!--- Eğerki main spec varsa ancak spec_var_id yoksa bu main spec'den yeni bir spect_var_id oluşturucaz. --->
                            
                            <cfset main_to_spect = specer(
                                        dsn_type:dsn3,
                                        spec_type:1,
                                        main_spec_id:form_spec_main_id,
                                        add_to_main_spec:1 )>
                           <!---  <cfset form_spect_id = listgetat("#main_to_spect#",2,',')> --->
                        </cfif>
                        <cfquery name="ADD_STOCK_FIS_ROW_2" datasource="#DSN3#">
                            INSERT INTO 
                                #dsn2_alias#.STOCK_FIS_ROW
                            (
                                FIS_ID,
                                FIS_NUMBER,
                                STOCK_ID,
                                AMOUNT,
                                AMOUNT2,
                                UNIT,
                                UNIT2,
                                UNIT_ID,					
                                PRICE,
                                TAX,
                                TOTAL,
                                TOTAL_TAX,
                                NET_TOTAL,
                                SPECT_VAR_ID,
                                SPEC_MAIN_ID,
                                SPECT_VAR_NAME,
                                <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>LOT_NO,DELIVER_DATE,</cfif>
                                OTHER_MONEY,
                                PRICE_OTHER,
                                COST_PRICE,
                                EXTRA_COST,
                                ROW_PROJECT_ID,
                                WRK_ROW_ID
                            )
                            VALUES
                            (
                                #get_id_exit.max_id#,
                                '#attributes.fis_no#',							
                                #_form_stocks_id_#,
                                #amount_rw#,
                                <cfif len(form_amount2) and len(form_unit2)>#form_amount2#<cfelse>NULL</cfif>,
                                '#get_unit.main_unit#',
                                <cfif len(form_unit2)>'#form_unit2#'<cfelse>NULL</cfif>,
                                #form_unit_id#,
                                #form_amount_price#,
                                #form_tax#,
                                #amount_rw*form_amount_price#,
                                #(amount_rw*form_amount_price*form_tax)/100#,
                                #amount_rw*form_amount_price#,																						
                                <cfif len(form_spect_id)>#form_spect_id#<cfelse>NULL</cfif>,
                                <cfif len(form_spec_main_id) and form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>,
                                <cfif len(form_spect_name)>'#form_spect_name#'<cfelse>NULL</cfif>,
                                <!--- <cfif len(get_row.lot_no)>'#get_row.lot_no#'<cfelse>NULL</cfif>, --->
                                <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                                    <cfif Len(get_row_exit.row_lot_no)>'#get_row_exit.row_lot_no#'<cfelse>NULL</cfif>,
                                    <cfif Len(get_row_exit.row_EXPIRATION_DATE)>#createodbcdatetime(get_row_exit.row_EXPIRATION_DATE)#<cfelse>NULL</cfif>,
                                </cfif>
                                '#form_other_money_currency#',
                                #form_other_money#,
                                #form_amount_price#,
                                <cfif len(form_extra_cost)>#form_extra_cost#<cfelse>0</cfif>
                                <!--- ,<cfif len(form_cost_id)>#form_cost_id#<cfelse>NULL</cfif> --->
                                ,
                           <cfif len(project_id)>#project_id#<CFELSE>NULL</cfif>
                           ,'#createUUID()#'
                            )
                        </cfquery>
                        
                        <cfquery name="ADD_STOCK_ROW_2" datasource="#DSN3#">
                            INSERT INTO 
                                #dsn2_alias#.STOCKS_ROW
                            (
                                UPD_ID,
                                PRODUCT_ID,
                                STOCK_ID,
                                PROCESS_TYPE,
                                STOCK_OUT,
                                STORE,
                                STORE_LOCATION,
                                PROCESS_DATE,
                                PROCESS_TIME,
                                SPECT_VAR_ID
                                <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>,LOT_NO,DELIVER_DATE</cfif>
                            )
                            VALUES
                            (
                                #get_id_exit.max_id#,
                                #_form_products_id_#,
                                #_form_stocks_id_#,
                                #attributes.fis_type#,
                                #multi#,
                                #get_row_exit.exit_dep_id#,
                                #get_row_exit.exit_loc_id#,
                                #value_finish_date#,
                                #finish_date_time#,
                                <cfif len(form_spec_main_id) and  form_spec_main_id gt 0>#form_spec_main_id#<cfelse>NULL</cfif>
                                <cfif isdefined("attributes.x_lot_no_in_stocks_row") and attributes.x_lot_no_in_stocks_row eq 1>
                                    ,<cfif len(get_row_exit.row_lot_no)>'#get_row_exit.row_lot_no#'<cfelse>NULL</cfif>
                                    ,<cfif len(get_row_exit.row_EXPIRATION_DATE)>#createodbcdatetime(get_row_exit.row_EXPIRATION_DATE)#<cfelse>NULL</cfif>
                                </cfif>
                            )
                        </cfquery>
                    </cfoutput>
                
                    <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                        UPDATE 
                            GENERAL_PAPERS
                        SET
                            STOCK_FIS_NUMBER = #attributes.system_paper_no_add#
                        WHERE
                            STOCK_FIS_NUMBER IS NOT NULL
                    </cfquery>
                </cfif>

                <!--- fis kayıt edildiği zaman IS_STOCK_FIS 1 set ediliyor --->
                <cfquery name="UPD_RESULT" datasource="#DSN3#">
                    UPDATE
                        PRODUCTION_ORDER_RESULTS
                    SET
                        IS_STOCK_FIS=1
                    WHERE
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
                </cfquery>
                <cfquery name="UPD_RESULT" datasource="#DSN3#">
                    UPDATE
                        PRODUCTION_ORDER_RESULTS_ROW
                    SET
                        IS_STOCK_FIS=1
                    WHERE
                        PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
                </cfquery>
                <cfquery name="GET_RESULT_AMOUNT" datasource="#DSN3#">
                    SELECT
                        ISNULL(SUM(POR_.AMOUNT),0) RESULT_AMOUNT
                    FROM
                        PRODUCTION_ORDER_RESULTS_ROW POR_,
                        PRODUCTION_ORDER_RESULTS POO
                    WHERE
                        POR_.PR_ORDER_ID = POO.PR_ORDER_ID
                        AND POO.P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
                        AND POR_.TYPE = 1
                        AND POO.IS_STOCK_FIS = 1
                        AND POR_.SPEC_MAIN_ID IN (SELECT PRODUCTION_ORDERS.SPEC_MAIN_ID FROM PRODUCTION_ORDERS WHERE PRODUCTION_ORDERS.P_ORDER_ID = POO.P_ORDER_ID)
                </cfquery>
                <cfquery name="UPD_PROD_ORDERS" datasource="#DSN3#">
                    UPDATE PRODUCTION_ORDERS SET RESULT_AMOUNT=#get_result_amount.RESULT_AMOUNT# WHERE P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_id#">
                </cfquery>
            </cftransaction>
        <!--- <cfcatch type="any">
            <cfset result.status = false>
        </cfcatch>
        </cftry> --->

        <cfreturn LCase(Replace(serializeJSON(result), "//", ""))>
    </cffunction>

    <cffunction name="getServiceDetails" access="remote" returnformat="JSON">
        <cfargument name="service_id" default="">
        <cfquery name="getServiceDetails" datasource="#dsn3#">
            SELECT
                CB.COMPBRANCH_ADDRESS ADDRESS,
                CB.COMPBRANCH_POSTCODE POSTCODE,
                CB.COUNTY_ID COUNTY,
                CB.CITY_ID CITY,
                CB.COUNTRY_ID COUNTRY,
                CB.SEMT SEMT,
                CB.COMPBRANCH_ID BRANCH_ID,
                CB.SZ_ID,
                SCTRY.COUNTRY_NAME,
                SCITY.CITY_NAME ,
                SCTY.COUNTY_NAME,
                P.COMPANY_PARTNER_ADDRESS,
                P.COMPANY_PARTNER_POSTCODE,
                P.SEMT P_SEMT,
                SCTRY2.COUNTRY_NAME P_COUNTRY_NAME,
                SCITY2.CITY_NAME P_CITY_NAME,
                SCTY2.COUNTY_NAME P_COUNTY_NAME,
                (SELECT SUM(ISNULL(AMOUNT,0)) AMOUNT FROM #dsn3#.SERVICE_OPERATION WHERE SERVICE_ID = SERVICE.SERVICE_ID) AMOUNT
            FROM
                SERVICE
                LEFT JOIN #dsn#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = SERVICE.OTHER_COMPANY_BRANCH_ID
                LEFT JOIN #dsn#.COMPANY C ON CB.COMPANY_ID = C.COMPANY_ID AND CB.COMPANY_ID = SERVICE.OTHER_COMPANY_ID
                LEFT JOIN #dsn#.SETUP_COUNTRY SCTRY ON SCTRY.COUNTRY_ID = CB.COUNTRY_ID
                LEFT JOIN #dsn#.SETUP_CITY SCITY ON SCITY.CITY_ID = CB.CITY_ID
                LEFT JOIN #dsn#.SETUP_COUNTY SCTY ON SCTY.COUNTY_ID = CB.COUNTY_ID
                LEFT JOIN #dsn#.COMPANY_PARTNER P ON SERVICE.SERVICE_COMPANY_ID = P.COMPANY_ID AND SERVICE.SERVICE_PARTNER_ID = P.PARTNER_ID
                LEFT JOIN #dsn#.SETUP_COUNTRY SCTRY2 ON SCTRY2.COUNTRY_ID = P.COUNTRY
                LEFT JOIN #dsn#.SETUP_CITY SCITY2 ON SCITY2.CITY_ID = P.CITY
                LEFT JOIN #dsn#.SETUP_COUNTY SCTY2 ON SCTY2.COUNTY_ID = P.COUNTY
            WHERE
                CB.COMPBRANCH_STATUS = 1
                AND SERVICE.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
        </cfquery>
        <cfif getServiceDetails.recordcount><cfreturn Replace(SerializeJson(this.returnData( Replace( SerializeJson( getServiceDetails ), "//", "" ))), "//", "") /><cfelse>[]</cfif>
    </cffunction>

    <cffunction name="getServiceControl" access="remote" returnformat="JSON">
        <cfargument name="service_id" default="">
        <cfquery name="getServiceControl" datasource="#dsn#">
            SELECT
                SERVICE_ID
            FROM 
                REFINERY_WASTE_COLLECTION_ROWS
            WHERE
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
        </cfquery>
        <cfif getServiceControl.recordcount><cfreturn Replace(SerializeJson(this.returnData( Replace( SerializeJson( getServiceControl ), "//", "" ))), "//", "") /><cfelse>[]</cfif>
    </cffunction>

    <cffunction name="cfquery" returntype="any" output="false">
        <!--- 
            usage : my_query_name = cfquery(SQLString:required,Datasource:required(bos olabilir),dbtype:optional,is_select:optinal); 
            Select olmayan yerlerde is_select:false olarak verilmelidir
        --->
        <cfargument name="SQLString" type="string" required="true">
        <cfargument name="Datasource" type="string" required="true">
        <cfargument name="dbtype" type="string" required="no">
        <cfargument name="is_select" type="boolean" required="no" default="true">
        
        <cfif isdefined("arguments.dbtype") and len(arguments.dbtype)>
            <cfquery name="workcube_cf_query" dbtype="query">
                #preserveSingleQuotes(arguments.SQLString)#
            </cfquery>
        <cfelse>
            <cfquery name="workcube_cf_query" datasource="#arguments.Datasource#">
                #preserveSingleQuotes(arguments.SQLString)#
            </cfquery>
        </cfif>
        <cfif arguments.is_select>
            <cfreturn workcube_cf_query>
        <cfelse>
            <cfreturn true>
        </cfif>
    </cffunction>

    <cffunction name="getSampleAnalyzes" access="remote" returntype="any" returnformat="JSON">
		<cfargument name = "department_id" default="" required="false">
		<cfargument name = "location_id" default="" required="false">
        <cfargument name = "branch_id" default="" required="false">
        <cfargument name = "our_company_id" required="true">
        <cfargument name = "department_location" required="true">

        <cfset response = [] />

        <cfif len(arguments.department_location)>
            <cfset getLocation = this.getLocation(department_location : arguments.department_location)>
            <cfset arguments.location_id = getLocation.LOCATION_ID>
            <cfset arguments.department_id = getLocation.DEPARTMENT_ID>
            <cfset arguments.branch_id = getLocation.BRANCH_ID>
        </cfif>

		<cfquery name="getSampleAnalyzes" datasource="#DSN#">
			SELECT 
                REF.REFINERY_LAB_TEST_ID,
				REF.LAB_REPORT_NO,
                (CONVERT(VARCHAR(10), REF.NUMUNE_DATE, 103) + ' '  + convert(VARCHAR(8), REF.NUMUNE_DATE, 14)) AS NUMUNE_DATE,
                (CONVERT(VARCHAR(10), REF.NUMUNE_ACCEPT_DATE, 103) + ' '  + convert(VARCHAR(8), REF.NUMUNE_ACCEPT_DATE, 14)) AS NUMUNE_DATE,
                REF.NUMUNE_NAME,
                REF.NUMUNE_PLACE,
                (CONVERT(VARCHAR(10), REF.ANALYSE_DATE, 103) + ' '  + convert(VARCHAR(8), REF.ANALYSE_DATE, 14)) AS ANALYSE_DATE,
                (CONVERT(VARCHAR(10), REF.ANALYSE_DATE_EXIT, 103) + ' '  + convert(VARCHAR(8), REF.ANALYSE_DATE_EXIT, 14)) AS ANALYSE_DATE_EXIT,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				EMPX.EMPLOYEE_NAME AS SAMPLE_EMPLOYEE_NAME,
				EMPX.EMPLOYEE_SURNAME AS SAMPLE_EMPLOYEE_SURNAME,
				DP.DEPARTMENT_HEAD,
				ST.COMMENT,
                SP.SAMPLING_POINTS_NAME
			FROM 
				REFINERY_LAB_TESTS AS REF
			JOIN PROCESS_TYPE_ROWS AS PTR ON REF.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			JOIN EMPLOYEES AS EMP ON REF.REQUESTING_EMPLOYE_ID = EMP.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES AS EMPX ON REF.SAMPLE_EMPLOYEE_ID = EMPX.EMPLOYEE_ID
			LEFT JOIN STOCKS_LOCATION AS ST ON REF.LOCATION_ID = ST.LOCATION_ID and REF.DEPARTMENT_ID = ST.DEPARTMENT_ID
			LEFT JOIN DEPARTMENT AS DP ON REF.DEPARTMENT_ID = DP.DEPARTMENT_ID
            LEFT JOIN SAMPLING_POINTS AS SP ON SP.SAMPLING_ID = REF.NUMUNE_POINT
			WHERE 
                REF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
                AND REF.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#">
                AND REF.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                AND REF.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
			ORDER BY
				REFINERY_LAB_TEST_ID DESC
		</cfquery>

        <cfif getSampleAnalyzes.recordcount>

            <cfset response = this.returnData( replace( serializeJson( getSampleAnalyzes ), "//", "" ) ) />
            
            <cfloop from="1" to="#ArrayLen(response)#" index="i">
                
                <cfquery name="getSampleAnalyzesRow" datasource="#DSN#">
                    SELECT REFINERY_LAB_TESTS_ROW.*, REFINERY_TEST_UNITS.UNIT_NAME, REFINERY_TEST_METHODS.TEST_METHOD_NAME, REFINERY_TEST_PARAMETERS.PARAMETER_NAME FROM REFINERY_LAB_TESTS_ROW
                    LEFT JOIN REFINERY_TEST_PARAMETERS ON REFINERY_TEST_PARAMETERS.REFINERY_TEST_PARAMETER_ID = REFINERY_LAB_TESTS_ROW.PARAMETER_ID
                    LEFT JOIN REFINERY_TEST_METHODS ON REFINERY_TEST_METHODS.REFINERY_TEST_METHOD_ID = REFINERY_LAB_TESTS_ROW.TEST_METHOD_ID
                    LEFT JOIN REFINERY_TEST_UNITS ON REFINERY_TEST_UNITS.REFINERY_UNIT_ID = REFINERY_LAB_TESTS_ROW.UNIT_ID
                    WHERE REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#response[i].REFINERY_LAB_TEST_ID#">
                </cfquery>
                
                <cfset response[i]["ANALYSE_ROW"] = getSampleAnalyzesRow.recordcount ? this.returnData( replace( serializeJson( getSampleAnalyzesRow ), "//", "" ) ) : [] />

            </cfloop>

            <cfreturn Replace( SerializeJson(response), "//", "" )>
        <cfelse>
            <cfreturn '[]'>
        </cfif>
        
    </cffunction>

</cfcomponent>