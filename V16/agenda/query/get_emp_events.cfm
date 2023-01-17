<cfif not isdefined("attributes.startdate") or not len(attributes.startdate)>
	<cfset startdate_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfelse>
	<cf_date tarih="attributes.startdate">
	<cfset startdate_ = attributes.startdate>
</cfif>
<cfif not isdefined("attributes.finishdate") or not len(attributes.finishdate)>
	<cfset finishdate_ = date_add("s",-1,date_add("d",1,createdate(year(now()),month(now()),day(now()))))>
<cfelse>
	<cf_date tarih="attributes.finishdate">
	<cfset finishdate_ = attributes.finishdate>
</cfif>
<cf_date tarih="attributes.start_date_par">
<!--- Employee events --->
<cfif isDefined("attributes.emp_id")>
    <cfquery name="EMP_EVENTS" datasource="#DSN#">
        SELECT
            1 AS TYPE,
            EVENT_ID AS ID,
            EVENT_HEAD AS NAME,
            STARTDATE AS REAL_START,
            FINISHDATE AS REAL_FINISH,
            STARTDATE AS TARGET_START,
            FINISHDATE AS TARGET_FINISH
        FROM
            EVENT
        WHERE
            (
            <cfif database_type IS 'MSSQL'>
                CAST(EVENT_TO_POS AS NVARCHAR(1000)) LIKE '%,#emp_id#,%'
            <cfelseif database_type IS 'DB2'>
                CAST(EVENT_TO_POS AS VARGRAPHIC(1000)) LIKE '%,#emp_id#,%'
            </cfif>
            )     

        UNION ALL

        SELECT
            2 AS TYPE,
            WORK_ID AS ID,
            WORK_HEAD AS NAME,
            TARGET_START AS REAL_START,
            TARGET_FINISH AS REAL_FINISH,
            TARGET_START AS TARGET_START,
            TARGET_FINISH AS TARGET_FINISH
        FROM
            PRO_WORKS
        WHERE
            WORK_STATUS = 1 AND
            PROJECT_EMP_ID  = #emp_id#  

        UNION ALL
        
        SELECT 
            3 AS TYPE,
            OFFTIME.OFFTIME_ID, 
            SETUP_OFFTIME.OFFTIMECAT AS NAME,
            '' AS REAL_START, 
            '' AS REAL_FINISH,
            OFFTIME.STARTDATE AS TARGET_START, 
            OFFTIME.FINISHDATE AS TARGET_FINISH
        FROM 
            OFFTIME,
            SETUP_OFFTIME
        WHERE
            OFFTIME.EMPLOYEE_ID = #emp_id# AND
            OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID 
        
        UNION ALL
            
        SELECT 
            4 AS TYPE,
            EMPLOYEES_SSK_FEE.FEE_ID, 
            'Vizite' AS NAME,
            '' AS REAL_START, 
            '' AS REAL_FINISH,
            EMPLOYEES_SSK_FEE.FEE_DATEOUT AS TARGET_START, 
            EMPLOYEES_SSK_FEE.FEE_DATEOUT AS TARGET_FINISH
        FROM 
            EMPLOYEES_SSK_FEE
        WHERE
            EMPLOYEES_SSK_FEE.EMPLOYEE_ID = #emp_id#
        
        UNION ALL
    
        SELECT 
            7 AS TYPE,
            TRAINING_CLASS.CLASS_ID AS ID,
            TRAINING_CLASS.CLASS_NAME AS NAME,
            '' AS REAL_START, 
            '' AS REAL_FINISH,
            TRAINING_CLASS.START_DATE AS TARGET_START,
            TRAINING_CLASS.FINISH_DATE AS TARGET_FINISH
        FROM 
            TRAINING_CLASS ,
            TRAINING_CLASS_ATTENDER 
        WHERE
            TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID AND 
            TRAINING_CLASS_ATTENDER.EMP_ID = #emp_id#
        ORDER BY 
            TARGET_START DESC
    </cfquery>
</cfif>
<!--- Partner events --->
<cfif isDefined("attributes.par_id")>
    <cfquery name="PAR_EVENTS" datasource="#dsn#">
        SELECT
            'Ajanda' AS TYPE,
            EVENT_ID AS ID,
            EVENT_HEAD AS NAME,
            STARTDATE AS REAL_START,
            FINISHDATE AS REAL_FINISH,
            STARTDATE AS TARGET_START,
            FINISHDATE AS TARGET_FINISH
        FROM
            EVENT
        WHERE       
            (RECORD_PAR = #attributes.par_id# OR EVENT_TO_PAR LIKE '%,#attributes.par_id#,%')      
        UNION

        SELECT
            'Servis' AS TYPE,
            SERVICE_ID AS ID,
            SERVICE_HEAD AS NAME,
            START_DATE AS REAL_START,
            FINISH_DATE AS REAL_FINISH,
            START_DATE AS TARGET_START,
            FINISH_DATE AS TARGET_FINISH
        FROM
            #dsn3_alias#.SERVICE AS SERVICE
        WHERE
            SERVICE_PARTNER_ID = #attributes.par_id# 
        UNION

        SELECT
            'Proje' AS TYPE,
            WORK_ID AS ID,
            WORK_HEAD AS NAME,
            TARGET_START AS REAL_START,<!--- artık REAL_START alanı kullanılmıyor, ön sayfada sıkıntı olmasn diye diğer bailangıc tarihini çağırdık--->
            TARGET_FINISH AS REAL_FINISH,
            TARGET_START AS TARGET_START,
            TARGET_FINISH AS TARGET_FINISH
        FROM
            PRO_WORKS
        WHERE
            OUTSRC_PARTNER_ID = #attributes.par_id#       
        ORDER BY TARGET_START DESC
    </cfquery>
</cfif>
<!--- Consumer events --->
<cfif isDefined("attributes.con_id")>
    <cfquery name="CONS_EVENT" datasource="#dsn#">
        SELECT 
            EVENT_ID AS ID,
            STARTDATE AS TARGET_START,
            FINISHDATE AS TARGET_FINISH,
            EVENTCAT,
            EVENT_HEAD
        FROM 
            EVENT,
            EVENT_CAT
        WHERE
            EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID		
            AND 
            (
                EVENT_TO_CON LIKE '%,#attributes.con_id#,%'
                OR
                EVENT_CC_CON LIKE '%,#attributes.con_id#,%'                
            )
    </cfquery>
</cfif>