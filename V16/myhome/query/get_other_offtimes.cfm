<cfquery name="get_upper_pos_code" datasource="#dsn#">
	SELECT 
		POSITION_CODE 
	FROM 
		EMPLOYEES E, 
		EMPLOYEE_POSITIONS EP 
	WHERE 
	E.EMPLOYEE_ID = EP.EMPLOYEE_ID 
	AND (
		UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		OR UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	)
	AND EMPLOYEE_STATUS = 1
</cfquery>
<cfset list_pos_code = 0>
<cfset list_pos_code = listappend(valuelist(get_upper_pos_code.position_code),list_pos_code)>

<!---İzinde olan kişilerin vekalet bilgileri alınıyor --->
<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
	SELECT
		O.EMPLOYEE_ID,
		EP.POSITION_CODE
	FROM
		OFFTIME O,
		EMPLOYEE_POSITIONS EP
	WHERE
		O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		O.VALID = 1 AND
		#Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
</cfquery>

<cfif Get_Offtime_Valid.recordcount>
	<cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
	<cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#list_pos_code#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position1">
		<cfset list_pos_code = ListAppend(list_pos_code,ValueList(Get_StandBy_Position1.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#list_pos_code#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position2">
		<cfset list_pos_code = ListAppend(list_pos_code,ValueList(Get_StandBy_Position2.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#list_pos_code#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position3">
		<cfset list_pos_code = ListAppend(list_pos_code,ValueList(Get_StandBy_Position3.Position_Code))>
	</cfoutput>
</cfif>

<cfquery name="get_upper_emps" datasource="#dsn#">
    SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#list_pos_code#)
</cfquery>
<cfset list_emp_ids = 0>
<cfset list_emp_ids = listappend(valuelist(get_upper_emps.employee_id),list_emp_ids)>
<cfquery name="GET_OTHER_OFFTIMES" datasource="#DSN#">
	SELECT 
		PW.W_ID,
		OFFTIME.VALID, 
		OFFTIME.VALIDDATE,
		OFFTIME.EMPLOYEE_ID, 
		OFFTIME.OFFTIME_ID, 
		OFFTIME.VALID_EMPLOYEE_ID, 
		OFFTIME.STARTDATE, 
		OFFTIME.FINISHDATE, 
		OFFTIME.TOTAL_HOURS, 
		OFFTIME.RECORD_DATE,
		OFFTIME.VALIDATOR_POSITION_CODE,
		OFFTIME.OFFTIME_STAGE,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.OFFTIMECAT,
		CASE 
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = OFFTIME.SUB_OFFTIMECAT_ID)
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM OFFTIME B WHERE B.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID)
        END AS NEW_CAT_NAME,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.IS_YEARLY,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
        EIO.START_DATE,
		PUANTAJ_GROUP_IDS,
		SETUP_OFFTIME.CALC_CALENDAR_DAY
	FROM 
		PAGE_WARNINGS AS PW
        LEFT JOIN PAGE_WARNINGS_ACTIONS AS PWA ON PW.W_ID = PWA.WARNING_ID
		INNER JOIN OFFTIME ON PW.ACTION_ID = OFFTIME.OFFTIME_ID
		INNER JOIN SETUP_OFFTIME ON OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
		INNER JOIN EMPLOYEES ON OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
		INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EIO.IN_OUT_ID = (SELECT MAX(IN_OUT_ID) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EX_IN_OUT_ID IS NULL)
	WHERE
		PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"><!--- pozisyona ait üzerinde süreç --->
		AND PW.ACTION_TABLE = 'OFFTIME'
		AND 
		<!--- Onaylayacak dolu ise o da gorunur fbs 20120614 --->
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		(
			OFFTIME.IS_PLAN <> 1 OR OFFTIME.IS_PLAN IS NULL
		)
		<cfif isdefined("attributes.event") and attributes.event eq 'cancelList'>
			AND OFFTIME.IS_CANCEL = 1
		</cfif>
		 <cfif  isdefined("attributes.process_status")  and len(attributes.process_status) and (attributes.process_status eq 1 OR attributes.process_status eq 0)>
			AND EMP_VALID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_status#">
		<cfelseif len(attributes.process_status) and attributes.process_status eq 2>
			AND EMP_VALID IS NULL
		<cfelseif len(attributes.process_status) and attributes.process_status eq 3>
			AND PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
			AND
			(
				(
					ISNULL(VALID_1,0) = 0
				)
				OR
				(
					ISNULL(VALID_2,0) = 0
				)
			)
		</cfif>
		<!--- Eğer süreç tablosunda seçilen sürece dair kayıt varsa ERU20042020--->
		<cfif isdefined("attributes.process_filter")  and len(attributes.process_filter)>
			AND PW.ACTION_STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.process_filter)#"> 
			AND PWA.ACTION_STAGE_ID IS NULL
		</cfif>
	ORDER BY
		OFFTIME_ID DESC
</cfquery>