<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
        <!--- <cfargument name="startRow" default="1">
        <cfargument name="maxRows" default="20"> --->
        <cfquery name="getProject_" datasource="#dsn#">
          <!---  SELECT * FROM
             ( --->
                SELECT  
                    DISTINCT(PRO_PROJECTS.PROJECT_ID),
                    PRO_PROJECTS.PROJECT_HEAD,
                    CASE WHEN (PRO_PROJECTS.COMPANY_ID IS NOT NULL) 
                    THEN
                        (SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID =PRO_PROJECTS.COMPANY_ID )
                    ELSE
                        CASE WHEN (PRO_PROJECTS.CONSUMER_ID IS NOT NULL) 
                        THEN
                            (SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID =PRO_PROJECTS.CONSUMER_ID )
                        ELSE
                            '-'
                        END
                    END AS CUSTOMER  
                    ,
                    CASE WHEN(PRO_PROJECTS.PROJECT_EMP_ID IS NOT NULL)
                        THEN
                            (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = PRO_PROJECTS.PROJECT_EMP_ID )
                        ELSE
                            '-'
                        END
                    AS EMPLOYEE,
                    CONVERT(VARCHAR(30), TARGET_START, 103)+' '+CONVERT(VARCHAR(30), TARGET_START, 108) as STARTDATE,
                    CONVERT(VARCHAR(30), TARGET_FINISH, 103)+' '+CONVERT(VARCHAR(30), TARGET_FINISH, 108) AS FINISHDATE,
                    PRO_PROJECTS.AGREEMENT_NO as AgreementNo,
                    (SELECT STAGE FROM PROCESS_TYPE,PROCESS_TYPE_ROWS WHERE PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID = PRO_PROJECTS.PRO_CURRENCY_ID) AS STAGE,
                    '<font color='+SETUP_PRIORITY.COLOR+'>'+SETUP_PRIORITY.PRIORITY+'</font>' as PRIORITY
                    <!--- ,ROW_NUMBER () OVER (ORDER BY PRO_PROJECTS.PROJECT_ID) AS ROW_NUMBER --->
                FROM 
                    PRO_PROJECTS,
                    SETUP_PRIORITY 
                WHERE 
                    PRO_PROJECTS.PRO_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID
                    AND PRO_PROJECTS.PROJECT_STATUS = 1
                    AND PRO_PROJECTS.PROCESS_CAT IN
                    (
                        SELECT  
                            SMC.MAIN_PROCESS_CAT_ID
                        FROM 
                            SETUP_MAIN_PROCESS_CAT SMC,
                            SETUP_MAIN_PROCESS_CAT_ROWS SMR,
                            EMPLOYEE_POSITIONS
                        WHERE
                            SMC.MAIN_PROCESS_CAT_ID=SMR.MAIN_PROCESS_CAT_ID AND
                            EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.position_code# AND 
                            (EMPLOYEE_POSITIONS.POSITION_CAT_ID=SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE = SMR.MAIN_POSITION_CODE)
                    )
                    <cfif len(arguments.keyword)>AND PRO_PROJECTS.PROJECT_HEAD LIKE'%#arguments.keyword#%'</cfif>
             <!--- ) AS PAGING_TABLE 
			 WHERE ROW_NUMBER BETWEEN #arguments.startRow# AND #arguments.maxRows#     ---> 
        </cfquery>
        <cfreturn getProject_>
    </cffunction>
</cfcomponent>

