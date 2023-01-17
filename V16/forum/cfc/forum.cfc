<cfcomponent>

    <cffunction name = "init" access = "public" output="false" description = "Define dsn" returnType="forum">

        <cfargument name="dsn" type="string">
        <cfset variables.dsn = arguments.dsn>
        <cfreturn this>

    </cffunction>

    <cffunction name="select" access="public" returntype="any">
        
        <cfargument name="keyword" default="">
        <cfargument name="forumid" default="0">
        <cfargument name="status" default="1">
        <cfargument name="tarih" default="">
        <cfargument name="topic_status" default="">
        <cfargument name="topichead" default="">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="#session.ep.maxrows#">

        <cfquery name="SEARCH_FORUM" datasource="#variables.dsn#">
            WITH CTE1 AS(
                SELECT 
                    FORUM_MAIN.FORUMID,
                    FORUM_MAIN.FORUMNAME,
                    FORUM_MAIN.ADMIN_POS,
                    FORUM_MAIN.ADMIN_CONS,
                    FORUM_MAIN.ADMIN_PARS,
                    FORUM_MAIN.FORUM_CONS_CATS, 
                    FORUM_MAIN.FORUM_COMP_CATS,
                    FORUM_MAIN.FORUM_EMPS,
                    FORUM_MAIN.DESCRIPTION,
                    FORUM_MAIN.LAST_MSG_USERKEY,
                    FORUM_MAIN.LAST_MSG_DATE,
                    FORUM_MAIN.REPLY_COUNT,
                    FORUM_MAIN.RECORD_EMP,
                    FORUM_MAIN.TOPIC_COUNT,
                    FORUM_MAIN.RECORD_DATE AS RECORD_DATE
                FROM
                    FORUM_MAIN
                    LEFT JOIN FORUM_TOPIC ON FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID
                    LEFT JOIN FORUM_REPLYS ON FORUM_TOPIC.TOPICID = FORUM_REPLYS.TOPICID
                WHERE
                    1 = 1
                <cfif isDefined("arguments.status") and len(arguments.status)>
                    AND FORUM_MAIN.STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                </cfif>    
                <cfif len(arguments.topic_status)>
                    AND FORUM_TOPIC.TOPIC_STATUS=#arguments.topic_status#
                </cfif>
                <cfif isDefined("arguments.FORUMID") and arguments.FORUMID NEQ 0>
                    AND FORUM_MAIN.FORUMID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FORUMID#">
                </cfif>
                <cfif isDefined("arguments.KEYWORD") and len(arguments.KEYWORD)>
                    AND
                    (
                    FORUM_TOPIC.TITLE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                    OR        
                    FORUM_TOPIC.TOPIC LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                    OR
                    FORUM_REPLYS.REPLY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                    OR
                    FORUM_MAIN.DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                    OR
                    FORUM_MAIN.FORUMNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">  
                    )
                </cfif>
                UNION
                SELECT 
                    FORUM_MAIN.FORUMID,
                    FORUM_MAIN.FORUMNAME,
                    FORUM_MAIN.ADMIN_POS,
                    FORUM_MAIN.ADMIN_CONS,
                    FORUM_MAIN.ADMIN_PARS,
                    FORUM_MAIN.FORUM_CONS_CATS, 
                    FORUM_MAIN.FORUM_COMP_CATS,
                    FORUM_MAIN.FORUM_EMPS,
                    FORUM_MAIN.DESCRIPTION,
                    FORUM_MAIN.LAST_MSG_USERKEY,
                    FORUM_MAIN.LAST_MSG_DATE,
                    FORUM_MAIN.REPLY_COUNT,
                    FORUM_MAIN.RECORD_EMP,
                    FORUM_MAIN.TOPIC_COUNT,
                    FORUM_MAIN.RECORD_DATE AS RECORD_DATE
                FROM
                    FORUM_MAIN
                    LEFT JOIN FORUM_TOPIC ON FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID
                WHERE
                    1 = 1
                    <cfif isDefined("arguments.status") and len(arguments.status)>
                        AND FORUM_MAIN.STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
                    </cfif>
                    <cfif len(arguments.topic_status)>
                        AND FORUM_TOPIC.TOPIC_STATUS=#arguments.topic_status#
                    </cfif>
                    <cfif isDefined("arguments.FORUMID") and arguments.FORUMID NEQ 0>
                        AND FORUM_MAIN.FORUMID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FORUMID#">
                    </cfif>
                    <cfif isDefined("arguments.KEYWORD") and len(arguments.KEYWORD)>
                        AND
                        (
                        FORUM_TOPIC.TITLE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                        OR        
                        FORUM_TOPIC.TOPIC LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                        OR
                        FORUM_MAIN.DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                        OR
                        FORUM_MAIN.FORUMNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.KEYWORD#%">
                        )
                    </cfif>
            ),
            CTE2 AS (
                        SELECT
                            CTE1.*,
                            ROW_NUMBER() OVER (	 
                                    <cfif isdefined('arguments.tarih') and arguments.tarih eq 1>
                                        ORDER BY RECORD_DATE DESC
                                    <cfelse> 
                                        ORDER BY RECORD_DATE
                                    </cfif>					    							    
                            ) AS RowNum,
                            (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM
                            CTE1
                    )
                    SELECT
                        CTE2.*
                    FROM
                        CTE2
                    WHERE
                        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)    
        </cfquery>

        <cfreturn SEARCH_FORUM> 

    </cffunction>

</cfcomponent>