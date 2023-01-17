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
		AND
		((STARTDATE <= #startdate_# AND FINISHDATE >= #startdate_#) OR (STARTDATE >= #startdate_# AND STARTDATE <= #finishdate_#))
	
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
        PROJECT_EMP_ID  = #emp_id# AND
        ((TARGET_START >= #startdate_# AND TARGET_START <= #finishdate_#) OR (TARGET_START <= #startdate_# AND TARGET_FINISH >= #startdate_#))
    
    <!--- xml de izinler görüntülenmesin seçili ise izinler alınmaz---> 
	<cfif ( isDefined("xml_event_offtime_permission") && xml_event_offtime_permission ) || not isDefined("xml_event_offtime_permission")>
			
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
        OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
        ((OFFTIME.STARTDATE >= #startdate_# AND OFFTIME.STARTDATE <= #finishdate_#) OR (OFFTIME.STARTDATE <= #startdate_# AND OFFTIME.FINISHDATE >= #startdate_#))
    </cfif>
    <!--- xml de viziteler görüntülenmesin seçili ise viziteler alınmaz---> 
	<cfif ( isDefined("xml_event_vizite_permission") && xml_event_vizite_permission ) || not isDefined("xml_event_vizite_permission")>
	
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
        EMPLOYEES_SSK_FEE.EMPLOYEE_ID = #emp_id# AND
        (
            (EMPLOYEES_SSK_FEE.FEE_DATEOUT >= #startdate_# AND EMPLOYEES_SSK_FEE.FEE_DATEOUT <= #finishdate_#) OR
            (EMPLOYEES_SSK_FEE.FEE_DATEOUT <= #startdate_# AND EMPLOYEES_SSK_FEE.FEE_DATEOUT >= #startdate_#)
        )
    </cfif>
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
         TRAINING_CLASS_ATTENDER.EMP_ID = #emp_id# AND
        (
            (TRAINING_CLASS.START_DATE >= #startdate_# AND TRAINING_CLASS.START_DATE <= #finishdate_#) OR
            (TRAINING_CLASS.START_DATE <= #startdate_# AND TRAINING_CLASS.FINISH_DATE >= #startdate_#)
        )	
    ORDER BY 
        TARGET_START DESC
</cfquery>
