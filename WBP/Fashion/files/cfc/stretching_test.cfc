<cfcomponent>
    <cfproperty name="dsn3" type="string">
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">

    <cffunction name="list_stretching_test" access="public" returntype="query">
        <cfargument name="opp_id" default="">
        <cfargument name="project_id" default="">
        <cfargument name="emp_id" default="">
        <cfargument name="test_date_start" default="">
        <cfargument name="test_date_end" default="">
        <cfargument name="stage_id" default="">
        <!--- <cfquery name="query_stretching_test" datasource="#dsn3#"> --->
        <cfquery name="query_stretching_test" datasource="#dsn#">
            SELECT 
				TEXTILE_STRETCHING_TEST_HEAD.STRETCHING_TEST_ID, 
				TEXTILE_STRETCHING_TEST_HEAD.TEST_DATE,
				TEXTILE_STRETCHING_TEST_HEAD.PROJECT_ID,
				TEXTILE_STRETCHING_TEST_HEAD.FABRIC_ARRIVAL_DATE, 
				TEXTILE_STRETCHING_TEST_HEAD.WAYBILL, 
				TEXTILE_STRETCHING_TEST_HEAD.EMP_ID, 
				COMPANY.FULLNAME,
				PRO_PROJECTS.PROJECT_NUMBER,
                PRO_PROJECTS.PROJECT_HEAD,
                TEXTILE_STRETCHING_TEST_HEAD.STAGE_ID,
                TEXTILE_STRETCHING_TEST_HEAD.WASHING_ID,
                TEXTILE_STRETCHING_TEST_HEAD.REQUIRED_FABRIC_METER,
                TEXTILE_STRETCHING_TEST_HEAD.NOTES,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                PROCESS_TYPE_ROWS.STAGE
            FROM #dsn3#.TEXTILE_STRETCHING_TEST_HEAD
            LEFT JOIN #dsn#.PRO_PROJECTS ON TEXTILE_STRETCHING_TEST_HEAD.PROJECT_ID = PRO_PROJECTS.PROJECT_ID 
            LEFT JOIN #dsn3#.ORDERS ord ON TEXTILE_STRETCHING_TEST_HEAD.ORDER_ID = ord.ORDER_ID
            LEFT JOIN #dsn#.COMPANY ON ord.COMPANY_ID = COMPANY.COMPANY_ID
            LEFT JOIN #dsn#.EMPLOYEES ON TEXTILE_STRETCHING_TEST_HEAD.EMP_ID = EMPLOYEES.EMPLOYEE_ID
            LEFT JOIN #dsn#.PROCESS_TYPE_ROWS ON TEXTILE_STRETCHING_TEST_HEAD.STAGE_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
            <cfif isDefined("arguments.opp_id") or isDefined("arguments.project_id") or isDefined("arguments.test_date")>
                WHERE 1 = 1
                <cfif len(arguments.emp_id)>
                    AND TEXTILE_STRETCHING_TEST_HEAD.EMP_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.emp_id#">
                </cfif>
                <cfif len(arguments.stage_id)>
                    AND TEXTILE_STRETCHING_TEST_HEAD.STAGE_ID IN (#arguments.stage_id#)
                </cfif>
                <cfif len(arguments.opp_id)>
                    AND TEXTILE_STRETCHING_TEST_HEAD.STRETCHING_TEST_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.opp_id#">
                </cfif>
                <cfif len(arguments.project_id)>
                    AND TEXTILE_STRETCHING_TEST_HEAD.PROJECT_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.project_id#">
                </cfif>
                <cfif len(arguments.test_date_start)>
                    AND DATEDIFF('DAY', <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.test_date_start#">, TEXTILE_STRETCHING_TEST_HEAD.TEST_DATE) >= 0
                </cfif>
                <cfif len(arguments.test_date_end)>
                    AND DATEDIFF('DAY', TEXTILE_STRETCHING_TEST_HEAD.TEST_DATE, <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.test_date_end#">) >= 0
                </cfif>
            </cfif>
        </cfquery>
        <cfreturn query_stretching_test>
    </cffunction>

    <cffunction name="get_stretching_test_by_opp" access="public" returntype="any">
        <cfargument name="project_id">
        <cfargument name="order_id">

        <cfquery name="query_get" datasource="#dsn2#">
            SELECT TOP 1 test.*, projects.PROJECT_HEAD, ord.ORDER_HEAD
            FROM #dsn3#.TEXTILE_STRETCHING_TEST_HEAD test
            INNER JOIN #dsn#.PRO_PROJECTS projects ON test.PROJECT_ID = projects.PROJECT_ID
            LEFT JOIN #dsn3#.ORDERS ord ON test.ORDER_ID = ord.ORDER_ID
            WHERE 1=1
            <cfif arguments.project_id gt 0>
                AND test.PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
            </cfif>
            <cfif isDefined("arguments.order_id") and arguments.order_id gt 0>
                AND test.ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
            </cfif>
        </cfquery>
        <cfreturn query_get>
    </cffunction>

    <cffunction name="get_stretching_test" access="public" returntype="any">
        <cfargument name="test_id">
        
        <cfquery name="query_get" datasource="#dsn#">
            SELECT TOP 1 test.*, projects.PROJECT_HEAD, O.ORDER_NUMBER, O.ORDER_ID, CONCAT(EMP.EMPLOYEE_NAME, ' ', EMP.EMPLOYEE_SURNAME ) AS EMP_NAME
            
            FROM #dsn3#.TEXTILE_STRETCHING_TEST_HEAD test
            LEFT JOIN #dsn#.PRO_PROJECTS projects ON test.PROJECT_ID = projects.PROJECT_ID
            LEFT JOIN #dsn3#.ORDERS O ON test.ORDER_ID = O.ORDER_ID
            LEFT JOIN #dsn#.EMPLOYEES EMP ON test.EMP_ID = EMP.EMPLOYEE_ID
            
            WHERE test.STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.test_id#'>
        </cfquery>

        <cfreturn query_get>
    </cffunction>

    <cffunction name="add_stretching_test" access="public" returntype="any">
        <cfargument name="stageid">
        <cfargument name="test_date" type="date">
        <cfargument name="project_id">
        <cfargument name="req_id">
        <cfargument name="order_id">
        <cfargument name="waybill">
        <cfargument name="washing_id">
        <cfargument name="production_orderid">
        <cfargument name="required_fabric_meter">
        <cfargument name="fabric_arrival_date">
        <cfargument name="emp_id">
        <cfargument name="notes">
        <cfargument name="start_date">
        <cfargument name="finish_date">
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
        <cfquery name="add_stretching_test" datasource="#dsn3#" result="query_result">
            INSERT INTO TEXTILE_STRETCHING_TEST_HEAD
                (STAGE_ID
                ,TEST_DATE
                ,FABRIC_ARRIVAL_DATE
                ,PROJECT_ID
                ,REQ_ID
                ,ORDER_ID
                ,WAYBILL
                ,WASHING_ID
                ,PRODUCTION_ORDERID
                ,REQUIRED_FABRIC_METER
                ,NOTES
                ,START_DATE
                ,FINISH_DATE
                ,EMP_ID
                ,RECORD_DATE
                ,RECORD_EMP
                ,RECORD_IP
                )
            VALUES
                (
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stageid#'>
                ,<cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.test_date#'>
                ,<cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.fabric_arrival_date#'>
                ,
                <cfif isDefined("arguments.project_id") and len(arguments.project_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.req_id") and len(arguments.req_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
                <cfelseif isDefined("arguments.project_id") and len(arguments.project_id)>
                    (SELECT TOP 1 REQ_ID FROM TEXTILE_SAMPLE_REQUEST WHERE PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>)
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.order_id") and len(arguments.order_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.waybill") and len(arguments.waybill)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.waybill#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.washing_id") and len(arguments.washing_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.washing_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.production_orderid") and len(arguments.production_orderid)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.production_orderid#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.required_fabric_meter") and len(arguments.required_fabric_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.required_fabric_meter#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.notes") and len(arguments.notes)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.notes#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.start_date") and len(arguments.start_date)>
                    <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.start_date#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.finish_date") and len(arguments.finish_date)>
                    <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.finish_date#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.emp_id") and len(arguments.emp_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.emp_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
                )
        </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn query_result>
    </cffunction>

    <cffunction name="update_stretching_test" access="public" returntype="any">
        <cfargument name="stretching_test_id" type="numeric">
        <cfargument name="stageid">
        <cfargument name="test_date" type="date">
        <cfargument name="project_id">
        <cfargument name="req_id">
        <cfargument name="order_id">
        <cfargument name="waybill">
        <cfargument name="washing_id">
        <cfargument name="production_orderid">
        <cfargument name="required_fabric_meter">
        <cfargument name="fabric_arrival_date">
        <cfargument name="notes">
        <cfargument name="emp_id">
        <cfargument name="start_date">
        <cfargument name="finish_date">
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
        <cfquery name="query_stretching_test" datasource="#dsn3#" result="query_result">
            UPDATE TEXTILE_STRETCHING_TEST_HEAD SET
                TEST_DATE = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.test_date#">
                ,STAGE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stageid#'>
                
                <cfif isDefined("arguments.project_id") and len(arguments.project_id)>
                ,PROJECT_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.project_id#">
                </cfif>
                
                <cfif isDefined("arguments.req_id") and len(arguments.req_id)>
                ,REQ_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.req_id#">
                <cfelseif isDefined("arguments.project_id") and len(arguments.project_id)>
                ,REQ_ID = (SELECT TOP 1 REQ_ID FROM TEXTILE_SAMPLE_REQUEST WHERE PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>)
                </cfif>

                <cfif isDefined("arguments.order_id") and len(arguments.order_id)>
                ,ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
                </cfif>

                <cfif isDefined("arguments.waybill") and len(arguments.waybill)>
                ,WAYBILL = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.waybill#'>
                </cfif>

                <cfif isDefined("arguments.washing_id") and len(arguments.washing_id)>
                ,WASHING_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.washing_id#'>
                </cfif>

                <cfif isDefined("arguments.production_orderid") and len(arguments.production_orderid)>
                ,PRODUCTION_ORDERID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.production_orderid#'>
                </cfif>

                <cfif isDefined("arguments.required_fabric_meter") and len(arguments.required_fabric_meter)>
                ,REQUIRED_FABRIC_METER = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.required_fabric_meter#'>
                </cfif>

                <cfif isDefined("arguments.fabric_arrival_date") and len(arguments.fabric_arrival_date)>
                ,FABRIC_ARRIVAL_DATE = <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.fabric_arrival_date#'>
                </cfif>

                <cfif isDefined("arguments.notes")>
                ,NOTES = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.notes#'>
                </cfif>

                <cfif isDefined("arguments.emp_id") and len(arguments.emp_id)>
                ,EMP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.emp_id#'>
                </cfif>

                <cfif isDefined("arguments.start_date") and len(arguments.start_date)>
                ,START_DATE = <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.start_date#'>
                </cfif>

                <cfif isDefined("arguments.finish_date") and len(arguments.finish_date)>
                ,FINISH_DATE = <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.finish_date#'>
                </cfif>

                ,UPDATE_DATE = #now()#
                ,UPDATE_EMP = #session.ep.userid#
                ,UPDATE_IP = '#cgi.REMOTE_ADDR#'

                WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
        </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn query_result>
    </cffunction>

    <cffunction name="get_stretching_test_rows" access="public" returntype="any">
        <cfargument name="sretching_test_id" type="numeric">
        <cfquery name="query_stretching_test_row" datasource="#dsn3#">
            SELECT * FROM TEXTILE_STRETCHING_TEST_ROWS WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sretching_test_id#'>
        </cfquery>
        <cfreturn query_stretching_test_row>
    </cffunction>

    <cffunction name="add_stretching_test_rows" access="public" returntype="any">
        <cfargument name="stretching_test_id" type="numeric">
        <cfargument name="product_id">
        <cfargument name="roll_id">
        <cfargument name="roll_meter">
        <cfargument name="roll_test_meter">
        <cfargument name="fabric_width">
        <cfargument name="height_shrinkage">
        <cfargument name="width_shrinkage">width_shrinkage
        <cfargument name="smooth">
        <cfargument name="color_lot">
        <cfargument name="color_name">
        <cfargument name="desc_one">
        <cfargument name="desc_two">
        <cfquery name="query_add_stretching_test_rows" datasource="#dsn3#">
        INSERT INTO TEXTILE_STRETCHING_TEST_ROWS (
            STRETCHING_TEST_ID,
            PRODUCT_ID,
            ROLL_ID,
            ROLL_METER,
            ROLL_TEST_METER,
            FABRIC_WIDTH,
            HEIGHT_SHRINKAGE,
            WIDTH_SHRINKAGE,
            SMOOTH,
            COLOR_LOT,
            COLOR_NAME,
            DESC_ONE,
            DESC_TWO,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        ) VALUES (
            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
            ,
            <cfif isDefined("arguments.product_id") and len(arguments.product_id)>
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.product_id#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.roll_id") and len(arguments.roll_id)>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.roll_id#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.roll_meter") and len(arguments.roll_meter)>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.roll_meter#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.roll_test_meter") and len(arguments.roll_test_meter)>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.roll_test_meter#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.fabric_width") and len(arguments.fabric_width)>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.fabric_width#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.height_shrinkage") and len(arguments.height_shrinkage)>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.height_shrinkage#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.width_shrinkage") and len(arguments.width_shrinkage)>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.width_shrinkage#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.smooth") and len(arguments.smooth)>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.smooth#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.color_lot") and len(arguments.color_lot)>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.color_lot#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.color_name") and len(arguments.color_name)>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.color_name#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.desc_one") and len(arguments.desc_one)>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.desc_one#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
            </cfif>
            ,
            <cfif isDefined("arguments.desc_two") and len(arguments.desc_two)>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.desc_two#'>
            <cfelse>
                <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
            </cfif>
            ,#now()#
            ,#session.ep.userid#
            ,'#cgi.REMOTE_ADDR#'
        )
        </cfquery>
    </cffunction>

    <cffunction name="delete_stretching_test_rows" access="public" returntype="any">
        <cfargument name="stretching_test_id" type="numeric">
        <cfquery name="query_delete_stretching_test_rows" datasource="#dsn3#">
            DELETE FROM TEXTILE_STRETCHING_TEST_ROWS WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="get_stretching_test_groups" access="public" returntype="any">
        <cfargument name="stretching_test_id" type="numeric">
        <cfquery name="query_group" datasource="#dsn3#">
            SELECT * FROM TEXTILE_STRETCHING_TEST_GROUP WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#stretching_test_id#'>
        </cfquery>
        <cfreturn query_group>
    </cffunction>

    <cffunction name="add_stretching_test_group" access="public" returntype="any">
        <cfargument name="stretching_test_id" type="numeric">
        <cfargument name="group_name">
        <cfargument name="width">
        <cfargument name="height">
        <cfquery name="query_add_group" datasource="#dsn3#">
            INSERT INTO TEXTILE_STRETCHING_TEST_GROUP (
                STRETCHING_TEST_ID,
                GROUP_NAME,
                WIDTH,
                HEIGHT,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            ) VALUES (
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.group_name#'>
                ,
                <cfif isDefined("arguments.width") and len(arguments.width)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.width#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.height") and len(arguments.height)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.height#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
            )
        </cfquery>
    </cffunction>
	
    <cffunction name="delete_stretching_test_group" access="public" returntype="any">
        <cfargument name="stretching_test_id" type="numeric">
        <cfquery name="query_delete_group" datasource="#dsn3#">
            DELETE FROM TEXTILE_STRETCHING_TEST_GROUP WHERE STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="get_stretching_test_groups_by_request" access="public" returntype="any">
        <cfargument name="request_id">

        <cfquery name="query_stretching_test" datasource="#dsn3#">
            SELECT * FROM TEXTILE_STRETCHING_TEST_GROUP 
            WHERE STRETCHING_TEST_ID IN (
                SELECT STRETCHING_TEST_ID FROM TEXTILE_STRETCHING_TEST_HEAD WHERE REQ_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.request_id#'>
            )
        </cfquery>

        <cfreturn query_stretching_test>
    </cffunction>

</cfcomponent>