<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_daily"  access="remote"  returntype="any">
        <cfargument name="event_id">
        <cfargument name="event_id3"> 
        <cfargument name="year">
        <cfargument name="month">
        <cfargument name="day">
        <cfargument name="hour">
        <cfargument name="start_hour">
        <cfargument name="start_year">
        <cfargument name="start_day">
        <cfargument name="start_month">
        <cfargument name="start_minute">
        <cfargument name="minute">
        <cfargument name="class_id">
        <cfargument name="event_plan_id">
        <cfif isDefined("event_id") and len(event_id)>
            <cfset start_date_ =CreateDateTime(arguments.start_year, arguments.start_month, arguments.start_day, arguments.start_hour,arguments.start_minute,0) >
            <cfset start_date_ = dateadd('h',-session.ep.time_zone,start_date_)>
            <cfset finish_date_ =CreateDateTime(arguments.year, arguments.month, arguments.day, arguments.hour,arguments.minute,0) >                           
            <cfset finish_date_ = dateadd('h',-session.ep.time_zone,finish_date_)>
            <cfquery name="board_column" datasource="#dsn#">
                UPDATE
                    EVENT
                SET
                    STARTDATE = #start_date_#,
                    FINISHDATE = #finish_date_#
                WHERE 
                    EVENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.event_id#">
            </cfquery>
        <cfelseif  isDefined("class_id") and len(class_id) >
            <cfset start_date_ =CreateDateTime(arguments.start_year, arguments.start_month, arguments.start_day, arguments.start_hour,arguments.start_minute,0) >
            <cfset start_date_ = dateadd('h',-session.ep.time_zone,start_date_)>
            <cfset finish_date_ =CreateDateTime(arguments.year, arguments.month, arguments.day, arguments.hour,arguments.minute,0) >                           
            <cfset finish_date_ = dateadd('h',-session.ep.time_zone,finish_date_)>
            <cfquery name="board_column" datasource="#dsn#">
                UPDATE
                    TRAINING_CLASS
                SET
                    START_DATE = #start_date_#,
                    FINISH_DATE = #finish_date_#
                WHERE 
                    CLASS_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_id#">
            </cfquery>
        <cfelseif  isDefined("event_plan_id") and len(event_plan_id) >
            <cfset start_date_ =CreateDateTime(arguments.start_year, arguments.start_month, arguments.start_day, arguments.start_hour,arguments.start_minute,0) >
            <cfset start_date_ = dateadd('h',-session.ep.time_zone,start_date_)>
            <cfset finish_date_ =CreateDateTime(arguments.year, arguments.month, arguments.day, arguments.hour,arguments.minute,0) >                           
            <cfset finish_date_ = dateadd('h',-session.ep.time_zone,finish_date_)>
            <cfquery name="board_column" datasource="#dsn#">
                UPDATE
                    EVENT_PLAN_ROW
                SET
                    START_DATE = #start_date_#,
                    FINISH_DATE = #finish_date_#
                WHERE
                    EVENT_PLAN_ID =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.event_plan_id#">
            </cfquery>
        <cfelseif  isDefined("event_id3") and len(event_id3) >
            <cfset start_date_ =CreateDateTime(arguments.start_year, arguments.start_month, arguments.start_day, arguments.start_hour,arguments.start_minute,0) >
            <cfset start_date_ = dateadd('h',-session.ep.time_zone,start_date_)>
            <cfquery name="board_column" datasource="#dsn#">
                UPDATE
                    PAGE_WARNINGS
                SET
                    WARNING_START = #start_date_#
                WHERE
                    W_ID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.event_id3#">
            </cfquery> 
        </cfif> 
        <cfreturn 1>
    </cffunction>
</cfcomponent>
