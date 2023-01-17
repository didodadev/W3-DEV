<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="SELECT" access = "public">
        <cfargument name="ANNOUNCE_ID">
        <cfargument name="keyword" type="string" default="">
        <cfquery name="get_announce" datasource="#dsn#">
            SELECT
			*
            FROM
                TRAINING_CLASS_ANNOUNCEMENTS
            WHERE
                1=1
                <cfif isDefined('arguments.keyword') and len(arguments.keyword)>AND ANNOUNCE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%"></cfif> 
                <cfif isDefined('arguments.ANNOUNCE_ID') and len(arguments.ANNOUNCE_ID)>AND ANNOUNCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ANNOUNCE_ID#"></cfif>
        </cfquery>
        <cfreturn get_announce>
    </cffunction>
    <cffunction name="SELECTCOUNT" access = "public">
        <cfargument name="ANNOUNCE_ID">
        <cfquery name="get_class_num" datasource="#DSN#">
            SELECT
                COUNT(CLASS_ID) AS TOT
            FROM
                TRAINING_CLASS_ANNOUNCE_CLASSES
            WHERE
                1=1
                <cfif isDefined('arguments.ANNOUNCE_ID') and len(arguments.ANNOUNCE_ID)>AND ANNOUNCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ANNOUNCE_ID#"></cfif>
        </cfquery>
        <cfreturn get_class_num>
    </cffunction>
    <cffunction name="COUNTEMPLOYEEID" access = "public">
        <cfargument name="ANNOUNCE_ID">
        <cfquery name="GET_EMP_REQ" datasource="#DSN#">
            SELECT
                COUNT(EMPLOYEE_ID) AS EMPLOYEE 
            FROM 
                TRAINING_CLASS_ANNOUNCE_ATTS 
            WHERE
            ANNOUNCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ANNOUNCE_ID#">
        </cfquery>
        <cfreturn GET_EMP_REQ>
    </cffunction>
    <cffunction name="INSERT" access = "public">
        <cfargument  name="announce_head" type="string" default="">
        <cfargument  name="detail" type="string" default="">
        <cfargument  name="start_date" type="date" default="">
        <cfargument  name="finish_date" type="date" default="">
        <cfquery name="ADD_ANNOUNCE" datasource="#dsn#" result="result">
            INSERT INTO
                TRAINING_CLASS_ANNOUNCEMENTS
                (
                RECORD_DATE,
                RECORD_EMP, 
                RECORD_IP,
                ANNOUNCE_HEAD, 
                DETAIL,
                START_DATE,
                FINISH_DATE
                )
            VALUES
                (
                #now()#,
                #SESSION.EP.USERID#,
                '#CGI.REMOTE_ADDR#',
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.announce_head#">, 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finish_date#">
                )
        </cfquery>
        <cfset response = result>
        <cfreturn response>   
    </cffunction>
    <cffunction name="UPDATE" access="public">
        <cfargument name="announce_head" type="string" default="">
        <cfargument name="detail" type="string" default="">
        <cfargument name="start_date" type="date" default="">
        <cfargument name="finish_date" type="date" default="">
        <cfquery name="UPD_ANNOUNCE" datasource="#dsn#">
            UPDATE 
                TRAINING_CLASS_ANNOUNCEMENTS
            SET
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #SESSION.EP.USERID#, 
                UPDATE_IP = '#CGI.REMOTE_ADDR#',
                ANNOUNCE_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.announce_head#">, 
                DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#">,
                START_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.start_date#">,
                FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.finish_date#">
            WHERE
                ANNOUNCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.announce_id#">
        </cfquery>		
    </cffunction>
    <cffunction name="SELECTTRAININGS" access = "public">
        <cfargument name="ANNOUNCE_ID" type="numeric">
        <cfquery name="GET_TRAININGS" datasource="#DSN#">
            SELECT
                TC.CLASS_ID,
                TC.CLASS_NAME,
                TC.START_DATE,
                TC.FINISH_DATE,
                TCG.ANNOUNCE_CLASS_ID 
            FROM
                TRAINING_CLASS_ANNOUNCE_CLASSES TCG,
                TRAINING_CLASS TC
            WHERE
                TC.CLASS_ID = TCG.CLASS_ID AND
                TCG.ANNOUNCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ANNOUNCE_ID#">
        </cfquery>
        <cfreturn GET_TRAININGS>
    </cffunction>
    <cffunction name="THECONTROL" access = "public">
        <cfargument name="ANNOUNCE_ID" type="numeric">
        <cfquery name="control" datasource="#dsn#">
            SELECT 
                EMPLOYEE_ID, 
                CLASS_ID, 
                ANNOUNCE_ID, 
                CONTENT_ID
            FROM 
                TRAINING_REQUEST_ROWS 
            WHERE 
                ANNOUNCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ANNOUNCE_ID#">
        </cfquery>
        <cfreturn control>
    </cffunction>
    <cffunction name="DELETEANNOUNCE" access = "public">
        <cfquery name="DEL_RELATED_CONT" datasource="#dsn#">
				DELETE 
				FROM
					TRAINING_CLASS_ANNOUNCEMENTS 
				WHERE 
					ANNOUNCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ANNOUNCE_ID#">
			</cfquery>
    </cffunction>
</cfcomponent>
