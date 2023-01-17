<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>   
    <cfif session.ep.dateformat_style is 'dd/mm/yyyy'>
        <cfset dateformat_style_ = 'dd/MM/yyyy'>
    <cfelse>
        <cfset dateformat_style_ = 'MM/dd/yyyy'>
    </cfif>

<!--- intranet güncel tartışmalar sayaç--->
    <cffunction name="forumCounts" access="remote" returntype="query">
        <cfquery name="forumCountsQuery" datasource="#dsn#">        	
			SELECT 
                t1.forumCount,
                t2.topicCount,
                t3.replyCount
            FROM
                (SELECT count(FORUMID) AS forumCount, '<intranet/sa>' as jn FROM FORUM_MAIN) AS t1
                LEFT JOIN (SELECT count(TOPICID) AS topicCount, '<intranet/sa>' as jn FROM FORUM_TOPIC) AS t2 ON t1.jn = t2.jn
                LEFT JOIN (SELECT count(REPLYID) AS replyCount, '<intranet/sa>' as jn FROM FORUM_REPLYS) AS t3 ON t1.jn = t3.jn  
        </cfquery>
        <cfreturn forumCountsQuery>
    </cffunction> 
<!--- intranet son mesajlar--->
    <cffunction name="lastReplys" access="remote" returntype="query">
        <cfquery name="lastReplysQuery" datasource="#dsn#">
            SELECT TOP 10 
                R.REPLY,
                R.REPLYID,
                T.TOPICID,
                T.TITLE AS TOPIC,
                R.RECORD_EMP,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.PHOTO,
                FORMAT(R.RECORD_DATE, '#dateformat_style_#') AS REC_DATE,
                T.FORUMID
            FROM
                FORUM_REPLYS AS R
                LEFT JOIN FORUM_TOPIC AS T ON R.TOPICID = T.TOPICID
                LEFT JOIN EMPLOYEES AS E ON R.RECORD_EMP = E.EMPLOYEE_ID
            ORDER BY R.RECORD_DATE DESC
        </cfquery>
        <cfreturn lastReplysQuery>
    </cffunction>

<!--- Eğitim Kataloğu --->
    <cffunction name="trainingSec" access="remote" returntype="query">
        <cfquery name="get_emp_det" datasource="#dsn#">
            SELECT
                OC.COMP_ID,
                B.BRANCH_ID,
                D.DEPARTMENT_ID,
                EP.FUNC_ID,
                EP.POSITION_CAT_ID,
                EP.ORGANIZATION_STEP_ID
            FROM
                EMPLOYEE_POSITIONS EP,
                OUR_COMPANY OC,
                BRANCH B,
                DEPARTMENT D
            WHERE
                OC.COMP_ID = B.COMPANY_ID AND
                B.BRANCH_ID = D.BRANCH_ID AND
                D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
                EP.EMPLOYEE_ID = #session.ep.userid# AND
                EP.IS_MASTER = 1
        </cfquery>
        <cfquery name="traningSecQuery" datasource="#dsn#">
            WITH CTE1 AS (
            SELECT
                RECORD_DATE,
                TRAIN_ID,
                TRAIN_HEAD,
                TRAIN_OBJECTIVE 
            FROM 
                TRAINING
            WHERE
            TRAIN_ID IN (
                SELECT
                    RELATION_FIELD_ID
                FROM
                    RELATION_SEGMENT_TRAINING
                WHERE 
                <cfif len(get_emp_det.COMP_ID)>
                (
                    RELATION_ACTION = 1 AND
                    RELATION_ACTION_ID = #get_emp_det.COMP_ID#
                ) OR
                </cfif>
                <cfif len(get_emp_det.DEPARTMENT_ID)>
                (
                    RELATION_ACTION = 2 AND
                    RELATION_ACTION_ID = #get_emp_det.DEPARTMENT_ID#
                ) OR
                </cfif>
                <cfif len(get_emp_det.POSITION_CAT_ID)>
                (
                    RELATION_ACTION = 3 AND
                    RELATION_ACTION_ID = #get_emp_det.POSITION_CAT_ID#
                ) OR
                </cfif>
                <cfif len(get_emp_det.FUNC_ID)>
                (
                    RELATION_ACTION = 5 AND
                    RELATION_ACTION_ID = #get_emp_det.FUNC_ID#
                ) OR
                </cfif>
                <cfif len(get_emp_det.ORGANIZATION_STEP_ID)>
                (
                    RELATION_ACTION = 6 AND
                    RELATION_ACTION_ID = #get_emp_det.ORGANIZATION_STEP_ID#
                ) OR
                </cfif>
                <cfif len(get_emp_det.BRANCH_ID)>
                (
                    RELATION_ACTION = 7 AND
                    RELATION_ACTION_ID = #get_emp_det.BRANCH_ID#
                )
                </cfif>
                ) AND SUBJECT_STATUS=1
            ),
            CTE2 AS (
                   SELECT
                       CTE1.*,
                       ROW_NUMBER() OVER (	 ORDER BY RECORD_DATE DESC ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                   FROM
                       CTE1
               )
               SELECT
                   CTE2.*
               FROM
                   CTE2
               WHERE
                   RowNum BETWEEN 1 and 10
        </cfquery>
        <cfreturn traningSecQuery>
    </cffunction>

<!----Traininig.Welcome------>
<cffunction name="trainingClass" access="remote" returntype="query">
    <cfquery name="trainingClassQuery" datasource="#dsn#">
        WITH CTE1 AS (
            SELECT DISTINCT 
                t1.CLASS_ID
                ,STUFF((
                        SELECT ',' + convert(VARCHAR(10), t2.EMP_ID, 120)
                        FROM TRAINING_CLASS_TRAINERS t2
                        WHERE t1.CLASS_ID = t2.CLASS_ID
                        FOR XML PATH('')
                        ), 1, 1, '') AS EMPLOYEE_IDS
                ,STUFF((
                        SELECT ',' + convert(VARCHAR(10), E.EMPLOYEE_NAME, 120)
                        FROM 
                            TRAINING_CLASS_TRAINERS AS TT
                            LEFT JOIN EMPLOYEES AS E ON TT.EMP_ID = E.EMPLOYEE_ID
                        WHERE t1.CLASS_ID = TT.CLASS_ID
                        FOR XML PATH('')
                        ), 1, 1, '') AS EMPLOYEE_NAMES
                ,STUFF((
                        SELECT ',' + convert(VARCHAR(10), E.EMPLOYEE_SURNAME, 120)
                        FROM 
                            TRAINING_CLASS_TRAINERS AS TT
                            LEFT JOIN EMPLOYEES AS E ON TT.EMP_ID = E.EMPLOYEE_ID
                        WHERE t1.CLASS_ID = TT.CLASS_ID
                        FOR XML PATH('')
                        ), 1, 1, '') AS EMPLOYEE_SURNAMES
                            
            FROM TRAINING_CLASS_TRAINERS t1
        )
        SELECT <cfif isDefined('arguments.top') and len(arguments.top)>  TOP #arguments.top# </cfif>
            TC.CLASS_ID,
            TC.CLASS_NAME,
            TC.CLASS_OBJECTIVE,
            TC.CLASS_TARGET,
            TC.CLASS_ANNOUNCEMENT_DETAIL,
            TC.CLASS_PLACE,
            TCA.TRAINING_CAT,
            TS.SECTION_NAME,
            A.ASSET_FILE_NAME,
            FORMAT(TC.START_DATE, 'dd/MM/yyyy') AS S_DATE,
            FORMAT(TC.FINISH_DATE, 'dd/MM/yyyy') AS F_DATE,
            FORMAT(TC.START_DATE, N'hh.mm') AS S_TIME,
            FORMAT(TC.FINISH_DATE, N'hh.mm') AS F_TIME,
            CTE1.EMPLOYEE_IDS,
		    CTE1.EMPLOYEE_NAMES,
            CTE1.EMPLOYEE_SURNAMES
        FROM
            TRAINING_CLASS AS TC
            LEFT JOIN TRAINING_CLASS_SECTIONS AS TCS ON TC.CLASS_ID = TCS.CLASS_ID
            LEFT JOIN TRAINING_CAT AS TCA ON TC.TRAINING_CAT_ID = TCA.TRAINING_CAT_ID
            LEFT JOIN TRAINING_SEC AS TS ON TC.TRAINING_SEC_ID = TS.TRAINING_SEC_ID
            LEFT JOIN (SELECT ACTION_ID, ASSET_FILE_NAME from ASSET WHERE ACTION_SECTION = 'CLASS_ID' AND (ASSET_FILE_NAME LIKE '%.jpg' OR ASSET_FILE_NAME LIKE '%.gif' OR ASSET_FILE_NAME LIKE '%.bmp' OR ASSET_FILE_NAME LIKE '%.png')) AS A ON TC.CLASS_ID = A.ACTION_ID
            LEFT JOIN CTE1 ON CTE1.CLASS_ID = TC.CLASS_ID
        WHERE
            TC.FINISH_DATE >= #now()# AND
            TC.CLASS_ID IS NOT NULL AND
            (
                TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.POSITION_CODE# ))))) OR
                TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_TRAINERS WHERE EMP_ID = #session.ep.userid#) OR
                TC.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER) OR 
                TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = #session.ep.userid#) OR
                TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = #session.ep.userid#)
            )
        ORDER BY TC.RECORD_DATE DESC
    </cfquery>
    <cfreturn trainingClassQuery>
</cffunction>
<!----Traininig.Welcome Duyurular------>
<cffunction name="trainingAnounce" access="remote" returntype="query">
    <cfquery name="trainingAnounceQuery" datasource="#dsn#">
        SELECT TOP 4
			ANNOUNCE_ID,
			ANNOUNCE_HEAD,
			FORMAT(START_DATE, 'dd/MM/yyyy') AS S_DATE
		FROM
			TRAINING_CLASS_ANNOUNCEMENTS
       ORDER BY START_DATE DESC
    </cfquery>
    <cfreturn trainingAnounceQuery>
</cffunction>



          
</cfcomponent>