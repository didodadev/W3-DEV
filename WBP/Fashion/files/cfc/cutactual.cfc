<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn1="#dsn#_product">

    <cffunction name="list_cutactual" access="public">
        <cfargument name="req_no" default="">
        <cfargument name="order_no" default="">
        <cfargument name="emp_id" default="">
        <cfargument name="emp_name" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="not_in_task" default="">
        <cfargument name="project_id" default="">
        <cfargument name="date_start" default="">
        <cfargument name="date_finish" default="">
        <cfquery name="query_list_cutactual" datasource="#dsn3#">
            SELECT head.*, ord.RELATED_ACTION_ID AS REQ_ID, tsri.MEASURE_FILENAME, CONCAT(emp.EMPLOYEE_NAME, ' ', emp.EMPLOYEE_SURNAME) AS EMP_NAME, comp.FULLNAME AS COMPANY_NAME, ptr.STAGE, orf.PROJECT_ID, orf.ORDER_NUMBER, srq.REQ_NO, ppj.PROJECT_HEAD
            FROM TEXTILE_CUTACTUAL_HEAD head
            OUTER APPLY (
                SELECT TOP 1 RELATED_ACTION_ID from ORDER_ROW WHERE RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND ORDER_ID = head.ORDER_ID
            ) AS ord
            OUTER APPLY (
                SELECT TOP 1 MEASURE_FILENAME FROM
                TEXTILE_SAMPLE_REQUEST_IMAGE 
                WHERE ord.RELATED_ACTION_ID = REQ_ID
            ) AS tsri
            LEFT JOIN #dsn#.EMPLOYEES emp ON head.EMP_ID = emp.EMPLOYEE_ID
            LEFT JOIN #dsn#.COMPANY comp ON head.COMPANY_ID = comp.COMPANY_ID
            LEFT JOIN #dsn#.PROCESS_TYPE_ROWS ptr ON head.STAGE_ID = ptr.PROCESS_ROW_ID
            LEFT JOIN ORDERS orf ON head.ORDER_ID = orf.ORDER_ID
            LEFT JOIN TEXTILE_SAMPLE_REQUEST srq ON ord.RELATED_ACTION_ID = srq.REQ_ID
            LEFT JOIN #dsn#.PRO_PROJECTS ppj ON orf.PROJECT_ID = ppj.PROJECT_ID
            WHERE 1=1
            <cfif len(arguments.req_no)>
                AND ord.REQ_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_no#'>
            </cfif>
            <cfif len(arguments.order_no)>
                AND head.ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_no#'>
            </cfif>
            <cfif len(arguments.emp_id)>
                AND head.EMP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.emp_id#'>
            </cfif>
            <cfif len(arguments.emp_name)>
                AND CONCAT(emp.EMPLOYEE_NAME, ' ', emp.EMPLOYEE_SURNAME) LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.emp_name#%'>
            </cfif>
            <cfif len(arguments.process_stage)>
                AND head.STAGE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.process_stage#'>
            </cfif>
            <cfif len(arguments.date_start)>
                AND head.START_DATE >= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.date_start#'>
            </cfif>
            <cfif len(arguments.date_finish)>
                AND orf.PROJECT_ID = DATEADD('d', 1, <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.date_finish#'>)
            </cfif>
            <cfif len(arguments.not_in_task)>
                AND head.EMP_ID IS NULL
            </cfif>
            <cfif len(arguments.project_id)>
                AND orf.PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
            </cfif>

        </cfquery>
        <cfreturn query_list_cutactual>
    </cffunction>

    <cffunction name="get_cutactual" access="public">
        <cfargument name="cutactual_id" type="numeric">
        <cfquery name="query_get_cutactual" datasource="#dsn3#">
            SELECT head.*, comp.FULLNAME, CONCAT(emp.EMPLOYEE_NAME, ' ', emp.EMPLOYEE_SURNAME) AS EMP_NAME, ord.RELATED_ACTION_ID AS REQ_ID, ohd.ORDER_NUMBER,ppj.PROJECT_ID,ppj.PROJECT_HEAD
            FROM TEXTILE_cutactual_HEAD head
            LEFT JOIN #dsn#.COMPANY comp ON head.COMPANY_ID = comp.COMPANY_ID
            LEFT JOIN #dsn#.EMPLOYEES emp ON head.EMP_ID = emp.EMPLOYEE_ID
            LEFT JOIN ORDERS ohd ON head.ORDER_ID = ohd.ORDER_ID
            LEFT JOIN #dsn#.PRO_PROJECTS ppj ON ohd.PROJECT_ID = ppj.PROJECT_ID
            OUTER APPLY (
                SELECT TOP 1 RELATED_ACTION_ID from ORDER_ROW WHERE RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND RELATED_ACTION_ID>0 AND ORDER_ID = head.ORDER_ID
            ) AS ord
            WHERE cutactual_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
        </cfquery>
        <cfreturn query_get_cutactual>
    </cffunction>

    <cffunction name="add_cutactual" access="public">
        <cfargument name="company_id">
        <cfargument name="order_id">
        <cfargument name="stage_id">
        <cfargument name="fabric_name">
        <cfargument name="plan_unit_meter">
        <cfargument name="plan_arrival_meter">
        <cfargument name="plan_meter">
        <cfargument name="merker_meter">
        <cfargument name="roll_amount">
        <cfargument name="piece_count">
        <cfargument name="total_piece_count">
        <cfargument name="marker_size">
        <cfargument name="margin">
        <cfargument name="stretching_test_id">
        <cfargument name="plan_date">
        <cfquery name="query_add_cutactual" datasource="#dsn3#" result="result_add_cutactual">
            INSERT INTO TEXTILE_cutactual_HEAD(
                COMPANY_ID, ORDER_ID, STAGE_ID, FABRIC_NAME, PLAN_UNIT_METER, PLAN_ARRIVAL_METER, PLAN_METER, MARKER_METER, ROLL_AMOUNT, PIECE_COUNT, TOTAL_PIECE_COUNT, MARKER_SIZE, MARGIN, PLAN_DATE, RECORD_DATE, RECORD_EMP, RECORD_IP
            ) VALUES (
                <cfif isDefined("arguments.company_id") and len(arguments.company_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.company_id#'>
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
                <cfif isDefined("arguments.stage_id") and len(arguments.stage_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stage_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.fabric_name") and len(arguments.fabric_name)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fabric_name#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.plan_unit_meter") and len(arguments.plan_unit_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.plan_unit_meter#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.plan_arrival_meter") and len(arguments.plan_arrival_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.plan_arrival_meter#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.plan_meter") and len(arguments.plan_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.plan_meter#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.merker_meter") and len(arguments.merker_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.merker_meter#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.roll_amount") and len(arguments.roll_amount)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.roll_amount#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.piece_count") and len(arguments.piece_count)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.piece_count#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.total_piece_count") and len(arguments.total_piece_count)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.total_piece_count#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.marker_size") and len(arguments.marker_size)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.marker_size#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.margin") and len(arguments.margin)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#arguments.margin#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.stretching_test_id") and len(arguments.stretching_test_id)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.plan_date") and len(arguments.plan_date)>
                    <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.plan_date#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DATE' null="true">
                </cfif>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
            )
        </cfquery>
        <cfreturn result_add_cutactual>
    </cffunction>

    <cffunction name="upd_cutactual" access="public">
        <cfargument name="cutactual_id" type="numeric">
        <cfargument name="company_id">
        <cfargument name="order_id">
        <cfargument name="stage_id">
        <cfargument name="fabric_name">
        <cfargument name="plan_unit_meter">
        <cfargument name="plan_arrival_meter">
        <cfargument name="plan_meter">
        <cfargument name="marker_meter">
        <cfargument name="roll_amount">
        <cfargument name="piece_count">
        <cfargument name="total_piece_count">
        <cfargument name="marker_size">
        <cfargument name="margin">
        <cfargument name="stretching_test_id">
        <cfargument name="plan_date">
        <cfargument name="emp_id">
        <cfargument name="start_date">
        <cfargument name="finish_date">
        <cfquery name="query_upd_cutactual" datasource="#dsn3#">
            UPDATE TEXTILE_cutactual_HEAD SET
            RECORD_DATE = RECORD_DATE
            <cfif isDefined("arguments.company_id") and len(arguments.company_id)>
                ,COMPANY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.company_id#'>
            </cfif>
            <cfif isDefined("arguments.order_id") and len(arguments.order_id)>
                ,ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
            </cfif>
            <cfif isDefined("arguments.stage_id") and len(arguments.stage_id)>
                ,STAGE_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stage_id#'>
            </cfif>
            <cfif isDefined("arguments.fabric_name") and len(arguments.fabric_name)>
                ,FABRIC_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fabric_name#'>
            </cfif>
            <cfif isDefined("arguments.plan_unit_meter") and len(arguments.plan_unit_meter)>
                ,PLAN_UNIT_METER = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.plan_unit_meter#' scale="2">
            </cfif>
            <cfif isDefined("arguments.plan_arrival_meter") and len(arguments.plan_arrival_meter)>
                ,PLAN_ARRIVAL_METER = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.plan_arrival_meter#' scale="2">
            </cfif>
            <cfif isDefined("arguments.plan_meter") and len(arguments.plan_meter)>
                ,PLAN_METER = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.plan_meter#' scale="2">
            </cfif>
            <cfif isDefined("arguments.marker_meter") and len(arguments.marker_meter)>
                ,MARKER_METER = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.marker_meter#' scale="2">
            </cfif>
            <cfif isDefined("arguments.roll_amount") and len(arguments.roll_amount)>
                ,ROLL_AMOUNT = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.roll_amount#'>
            </cfif>
            <cfif isDefined("arguments.piece_count") and len(arguments.piece_count)>
                ,PIECE_COUNT = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.piece_count#'>
            </cfif>
            <cfif isDefined("arguments.total_piece_count") and len(arguments.total_piece_count)>
                ,TOTAL_PIECE_COUNT = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.total_piece_count#'>
            </cfif>
            <cfif isDefined("arguments.marker_size") and len(arguments.marker_size)>
                ,MARKER_SIZE = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.marker_size#' scale="2">
            </cfif>
            <cfif isDefined("arguments.margin") and len(arguments.margin)>
                ,MARGIN = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.margin#' scale="2">
            </cfif>
            <cfif isDefined("arguments.stretching_test_id") and len(arguments.stretching_test_id)>
                ,MARGIN = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
            </cfif>
            <cfif isDefined("arguments.emp_id") and len(arguments.emp_id)>
                ,EMP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.emp_id#'>
            </cfif>
            <cfif isDefined("arguments.plan_date") and len(arguments.plan_date)>
                ,PLAN_DATE = <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.plan_date#'>
            </cfif>
            <cfif isDefined("arguments.start_date") and len(arguments.start_date)>
                ,START_DATE = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.start_date#'>
            </cfif>
            <cfif isDefined("arguments.finish_date") and len(arguments.finish_date)>
                ,FINISH_DATE = <cfqueryparam cfsqltype='CF_SQL_TIMESTAMP' value='#arguments.finish_date#'>
            </cfif>
            ,UPDATE_DATE = #now()#
            ,UPDATE_EMP = #session.ep.userid#
            ,UPDATE_IP = '#cgi.REMOTE_ADDR#'
            WHERE cutactual_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="get_cutactual_rows" access="public">
        <cfargument name="cutactual_id">
        <cfquery name="query_get_cutactual_rows" datasource="#dsn3#">
            SELECT * FROM TEXTILE_cutactual_ROW WHERE cutactual_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
        </cfquery>
        <cfreturn query_get_cutactual_rows>
    </cffunction>

    <cffunction name="add_cutactual_row" access="public">
        <cfargument name="cutactual_id">
        <cfargument name="marker_name">
        <cfargument name="marker_output">
        <cfargument name="cutactual_name">
        <cfargument name="marker_height">
        <cfargument name="layer_amount">
        <cfargument name="assortment_size_amount">
        <cfargument name="net_marker_meter">
        <cfargument name="gross_marker_height">
        <cfargument name="gross_marker_meter">
        <cfargument name="marker_unit_meter">
        <cfargument name="productivity">
        <cfargument name="after_cut_meter">
        <cfargument name="marker_width">
        <cfargument name="draft_color">
        <cfargument name="draft_width">
        <cfargument name="draft_height">
        <cfargument name="meto_color">
        <cfargument name="cut_amount">
        <cfquery name="queyr_add_cutactual_row" datasource="#dsn3#" result="result_add_cutactual_row">
            INSERT INTO TEXTILE_cutactual_ROW (
                cutactual_ID, MARKER_NAME, MARKER_OUTPUT, cutactual_NAME, MARKER_HEIGHT, LAYER_AMOUNT, ASSORTMENT_SIZE_AMOUNT, NET_MARKER_METER, GROSS_MARKER_HEIGHT, GROSS_MARKER_METER, MARKER_UNIT_METER, PRODUCTIVITY, AFTER_CUT_METER, MARKER_WIDTH, DRAFT_COLOR, DRAFT_WIDTH, DRAFT_HEIGHT, METO_COLOR, CUT_AMOUNT, RECORD_DATE, RECORD_EMP, RECORD_IP
            ) VALUES (
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#cutactual_id#'>
                ,
                <cfif isDefined("arguments.marker_name") and len(arguments.marker_name)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.marker_name#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.marker_output") and len(arguments.marker_output)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.marker_output#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.cutactual_name") and len(arguments.cutactual_name)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.cutactual_name#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.marker_height") and len(arguments.marker_height)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.marker_height#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.layer_amount") and len(arguments.layer_amount)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.layer_amount#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.assortment_size_amount") and len(arguments.assortment_size_amount)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.assortment_size_amount#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.net_marker_meter") and len(arguments.net_marker_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.net_marker_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.gross_marker_height") and len(arguments.gross_marker_height)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.gross_marker_height#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.gross_marker_meter") and len(arguments.gross_marker_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.gross_marker_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.marker_unit_meter") and len(arguments.marker_unit_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.marker_unit_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.productivity") and len(arguments.productivity)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.productivity#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.after_cut_meter") and len(arguments.after_cut_meter)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.after_cut_meter#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.marker_width") and len(arguments.marker_width)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.marker_width#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.draft_color") and len(arguments.draft_color)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.draft_color#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.draft_width") and len(arguments.draft_width)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.draft_width#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.draft_height") and len(arguments.draft_height)>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#arguments.draft_height#' scale="2">
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_DECIMAL' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.meto_color") and len(arguments.meto_color)>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.meto_color#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' null="true">
                </cfif>
                ,
                <cfif isDefined("arguments.cut_amount") and len(arguments.cut_amount)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cut_amount#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
            )
        </cfquery>
        <cfreturn result_add_cutactual_row>
    </cffunction>

    <cffunction name="delete_cutactual_rows" access="public">
        <cfargument name="cutactual_id" type="numeric">
        <cfquery name="query_delete_cutactual_rows" datasource="#dsn3#">
            DELETE TEXTILE_cutactual_ROW WHERE cutactual_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="get_cutactual_sizes" access="public">
        <cfargument name="cutactual_id">
        <cfquery name="query_get_cutactual_sizes" datasource="#dsn3#">
            SELECT * FROM TEXTILE_cutactual_SIZE WHERE cutactual_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
        </cfquery>
        <cfreturn query_get_cutactual_sizes>
    </cffunction>

    <cffunction name="add_cutactual_size" access="public">
        <cfargument name="cutactual_id">
        <cfargument name="size">
        <cfargument name="weight">
        <cfargument name="cut_amount">
        <cfargument name="cutactual_rowid">
        <cfquery name="query_add_cutactual_size" datasource="#dsn3#">
            INSERT INTO TEXTILE_cutactual_SIZE (
                cutactual_ID, cutactual_ROWID, SIZE, WEIGHT, CUT_AMOUNT, RECORD_DATE, RECORD_EMP, RECORD_IP
            ) VALUES (
                <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_rowid#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.size#'>
                ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.weight#'>
                ,<cfif isDefined("arguments.cut_amount") and len(arguments.cut_amount)>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cut_amount#'>
                <cfelse>
                    <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="true">
                </cfif>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
            )
        </cfquery>
    </cffunction>

    <cffunction name="delete_cutactual_size" access="public">
        <cfargument name="cutactual_id">
        <cfquery name="query_delete_cutactual_size" datasource="#dsn3#">
            DELETE TEXTILE_cutactual_SIZE WHERE cutactual_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutactual_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="get_stock_property" access="public">
        <cfargument name="order_id">
          <cfquery name="query_result" datasource="#dsn3#">
              SELECT
                          RENK.PROPERTY_DETAIL AS RENK_,
                          RENK.PROPERTY_DETAIL_ID AS RENK_ID,
                          BEDEN.PROPERTY_DETAIL AS BEDEN_,
                          BEDEN.PROPERTY_DETAIL_ID AS BEDEN_ID,
                          BEDEN.PROPERTY_DETAIL_CODE,
                          BOY.PROPERTY_DETAIL AS BOY_,
                          BOY.PROPERTY_DETAIL_ID AS BOY_ID,
                          STOCKS.STOCK_ID,
                          SUM(ORDER_ROW.QUANTITY) AS QUANTITY
                      FROM 
                          #dsn1#.STOCKS
                          INNER JOIN ORDER_ROW ON STOCKS.STOCK_ID = ORDER_ROW.STOCK_ID
                          OUTER APPLY
                          (
                              SELECT
                                  PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
                                  PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
                                  PPD.PRPT_ID,
                                  PPD.PROPERTY_DETAIL_CODE
                              FROM
                                  #dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
                                  #dsn1#.PRODUCT_PROPERTY PRP,
                                  STOCKS_PROPERTY SP
                              WHERE
                                  PRP.PROPERTY_ID = PPD.PRPT_ID AND
                                  SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
                                  PRP.PROPERTY_COLOR = 1 AND 
                                  SP.STOCK_ID = STOCKS.STOCK_ID 
                          ) AS RENK
                          OUTER APPLY
                          (
                              SELECT 
                                  PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
                                  PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
                                  PPD.PRPT_ID,
                                  PPD.PROPERTY_DETAIL_CODE
                              FROM
                                  #dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
                                  #dsn1#.PRODUCT_PROPERTY PRP,
                                  STOCKS_PROPERTY SP
                              WHERE
                                  PRP.PROPERTY_ID = PPD.PRPT_ID AND
                                  SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
                                  PRP.PROPERTY_SIZE = 1 AND 
                                  SP.STOCK_ID = STOCKS.STOCK_ID 
                          ) AS BEDEN
                          OUTER APPLY
                          (
                              SELECT 
                                  PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
                                  PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
                                  PPD.PRPT_ID,
                                  PPD.PROPERTY_DETAIL_CODE
                              FROM
                                  #dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
                                  #dsn1#.PRODUCT_PROPERTY PRP,
                                  STOCKS_PROPERTY SP
                              WHERE
                                  PRP.PROPERTY_ID = PPD.PRPT_ID AND
                                  SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
                                  PRP.PROPERTY_LEN = 1 AND 
                                  SP.STOCK_ID = STOCKS.STOCK_ID 
                          ) AS BOY
                          
                      WHERE 
                          STOCKS.STOCK_STATUS = 1 AND
                          RENK.PROPERTY_DETAIL_ID IS NOT NULL AND
                          BEDEN.PROPERTY_DETAIL IS NOT NULL AND
                          ORDER_ROW.ORDER_ID = #arguments.order_id#

                          GROUP BY RENK.PROPERTY_DETAIL,
                          RENK.PROPERTY_DETAIL_ID,
                          BEDEN.PROPERTY_DETAIL,
                          BEDEN.PROPERTY_DETAIL_ID,
                          BEDEN.PROPERTY_DETAIL_CODE,
                          BOY.PROPERTY_DETAIL,
                          BOY.PROPERTY_DETAIL_ID,
                          STOCKS.STOCK_ID
                          
                          ORDER BY RENK.PROPERTY_DETAIL, BOY.PROPERTY_DETAIL, BEDEN.PROPERTY_DETAIL
  
          </cfquery>
          <cfreturn query_result>
      </cffunction>
  
      <cffunction name="copyFromPlan" access="public">
        <cfargument name="cutplan_id">
        <cfargument name="stage_id">
        <cfquery name="query_cutplan_copy" datasource="#dsn3#" result="result_cutplan_copy">
            INSERT INTO TEXTILE_CUTACTUAL_HEAD
            (SOURCEPLAN_ID
            ,COMPANY_ID
            ,ORDER_ID
            ,STAGE_ID
            ,FABRIC_NAME
            ,PLAN_UNIT_METER
            ,PLAN_ARRIVAL_METER
            ,PLAN_METER
            ,MARKER_METER
            ,ROLL_AMOUNT
            ,PIECE_COUNT
            ,TOTAL_PIECE_COUNT
            ,MARKER_SIZE
            ,MARGIN
            ,STRETCHING_TEST_ID
            ,RECORD_DATE
            ,RECORD_EMP
            ,RECORD_IP
            )
            SELECT
            CUTPLAN_ID
            ,COMPANY_ID
            ,ORDER_ID
            ,#arguments.stage_id#
            ,FABRIC_NAME
            ,PLAN_UNIT_METER
            ,PLAN_ARRIVAL_METER
            ,PLAN_METER
            ,MARKER_METER
            ,ROLL_AMOUNT
            ,PIECE_COUNT
            ,TOTAL_PIECE_COUNT
            ,MARKER_SIZE
            ,MARGIN
            ,STRETCHING_TEST_ID
            ,#now()#
            ,#session.ep.userid#
            ,'#cgi.REMOTE_ADDR#'
            FROM TEXTILE_CUTPLAN_HEAD
            WHERE CUTPLAN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutplan_id#'>
        </cfquery>
        <cfset cutactual_id = result_cutplan_copy.generatedkey>

        <cfquery name="query_cutplan_rows" datasource="#dsn3#">
            SELECT
            CUTPLAN_ROWID
            ,#cutactual_id# AS CUTACTUAL_ID
            ,MARKER_NAME
            ,MARKER_OUTPUT
            ,CUTPLAN_NAME
            ,MARKER_HEIGHT
            ,LAYER_AMOUNT
            ,ASSORTMENT_SIZE_AMOUNT
            ,NET_MARKER_METER
            ,GROSS_MARKER_HEIGHT
            ,GROSS_MARKER_METER
            ,MARKER_UNIT_METER
            ,PRODUCTIVITY
            ,AFTER_CUT_METER
            ,MARKER_WIDTH
            ,DRAFT_COLOR
            ,DRAFT_WIDTH
            ,DRAFT_HEIGHT
            ,METO_COLOR
            ,CUT_AMOUNT
            ,#now()# AS RECORD_DATE
            ,#session.ep.userid# AS RECORD_EMP
            ,'#cgi.REMOTE_ADDR#' AS RECORD_IP
            FROM TEXTILE_CUTPLAN_ROW
            WHERE CUTPLAN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.cutplan_id#'>
        </cfquery>

        <cfloop query="query_cutplan_rows">
        <cfquery name="query_cutplan_row_copy" datasource="#dsn3#" result="result_cutplan_row_copy">
            INSERT INTO TEXTILE_CUTACTUAL_ROW
            (CUTACTUAL_ID
            ,MARKER_NAME
            ,MARKER_OUTPUT
            ,CUTACTUAL_NAME
            ,MARKER_HEIGHT
            ,LAYER_AMOUNT
            ,ASSORTMENT_SIZE_AMOUNT
            ,NET_MARKER_METER
            ,GROSS_MARKER_HEIGHT
            ,GROSS_MARKER_METER
            ,MARKER_UNIT_METER
            ,PRODUCTIVITY
            ,AFTER_CUT_METER
            ,MARKER_WIDTH
            ,DRAFT_COLOR
            ,DRAFT_WIDTH
            ,DRAFT_HEIGHT
            ,METO_COLOR
            ,CUT_AMOUNT
            ,RECORD_DATE
            ,RECORD_EMP
            ,RECORD_IP)
            VALUES (#cutactual_id#
            ,'#MARKER_NAME#'
            ,'#MARKER_OUTPUT#'
            ,'#CUTPLAN_NAME#'
            ,#len(MARKER_HEIGHT)?MARKER_HEIGHT:'NULL'#
            ,#len(LAYER_AMOUNT)?LAYER_AMOUNT:'NULL'#
            ,#len(ASSORTMENT_SIZE_AMOUNT)?ASSORTMENT_SIZE_AMOUNT:'NULL'#
            ,#len(NET_MARKER_METER)?NET_MARKER_METER:'NULL'#
            ,#len(GROSS_MARKER_HEIGHT)?GROSS_MARKER_HEIGHT:'NULL'#
            ,#len(GROSS_MARKER_METER)?GROSS_MARKER_METER:'NULL'#
            ,#len(MARKER_UNIT_METER)?MARKER_UNIT_METER:'NULL'#
            ,#len(PRODUCTIVITY)?PRODUCTIVITY:'NULL'#
            ,#len(AFTER_CUT_METER)?AFTER_CUT_METER:'NULL'#
            ,#len(MARKER_WIDTH)?MARKER_WIDTH:'NULL'#
            ,'#DRAFT_COLOR#'
            ,#len(DRAFT_WIDTH)?DRAFT_WIDTH:'NULL'#
            ,#len(DRAFT_HEIGHT)?DRAFT_HEIGHT:'NULL'#
            ,'#METO_COLOR#'
            ,#len(CUT_AMOUNT)?CUT_AMOUNT:'NULL'#
            ,#now()#
            ,#session.ep.userid#
            ,'#cgi.REMOTE_ADDR#')
        </cfquery>
        <cfset cutactual_rowid = result_cutplan_row_copy.generatedkey>

        <cfquery name="query_cutplan_sizes_copy" datasource="#dsn3#">
            INSERT INTO TEXTILE_CUTACTUAL_SIZE
            (CUTACTUAL_ID
            ,CUTACTUAL_ROWID
            ,SIZE
            ,WEIGHT
            ,CUT_AMOUNT
            ,RECORD_DATE
            ,RECORD_EMP
            ,RECORD_IP)
            SELECT 
            #cutactual_id#
            ,#cutactual_rowid#
            ,SIZE
            ,WEIGHT
            ,CUT_AMOUNT
            ,#now()#
            ,#session.ep.userid#
            ,'#cgi.REMOTE_ADDR#'
            FROM TEXTILE_CUTPLAN_SIZE
            WHERE CUTPLAN_ROWID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#CUTPLAN_ROWID#'>
        </cfquery>

        </cfloop>
        <cfreturn cutactual_id>
      </cffunction>


</cfcomponent>