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

<!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
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

<cfquery name="get_requests" datasource="#DSN#">
	SELECT 
		*
	FROM 
		CORRESPONDENCE_PAYMENT
	WHERE
		TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
	ORDER BY
		DUEDATE DESC
</cfquery>
<cfquery name="get_other_requests" datasource="#dsn#">
	SELECT 
		*
	FROM
		SALARYPARAM_GET_REQUESTS
	WHERE 
		EMPLOYEE_ID = #SESSION.EP.USERID#
		<cfif LEN(attributes.keyword)>
			AND DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif len(attributes.status) and (attributes.status eq 0 or attributes.status eq 1)>
			AND IS_VALID = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
		<cfelseif len(attributes.status) and attributes.status eq 2>
			AND IS_VALID IS NULL
		</cfif>
	ORDER BY
		TERM DESC,
		START_SAL_MON DESC
</cfquery>
<cfquery name="get_reserve_requests" datasource="#DSN#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
        PTR.STAGE,
		CP.*
	FROM 
		CORRESPONDENCE_PAYMENT CP,
		EMPLOYEES E,
        PROCESS_TYPE_ROWS PTR
	WHERE
		E.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID 
        AND CP.TO_EMPLOYEE_ID IN(#list_emp_ids#)
        AND CP.PROCESS_STAGE = PTR.PROCESS_ROW_ID
		<cfif len(attributes.process_status) and (attributes.process_status eq 1 OR attributes.process_status eq 0)>
			AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_status#">
		<cfelseif len(attributes.process_status) and attributes.process_status eq 2>
			AND STATUS IS NULL
		</cfif>
    ORDER BY
		CP.DUEDATE DESC
</cfquery>
<!--- <cfquery name="get_reserve_other_requests" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
        PTR.STAGE,
		SR.*
	FROM
		SALARYPARAM_GET_REQUESTS SR,
		EMPLOYEES E,
        PROCESS_TYPE_ROWS PTR
	WHERE 
		E.EMPLOYEE_ID = SR.EMPLOYEE_ID
        AND SR.EMPLOYEE_ID IN(#list_emp_ids#)
        AND CP.PROCESS_STAGE = PTR.PROCESS_ROW_ID
	ORDER BY
		SR.TERM DESC,
		SR.START_SAL_MON DESC
</cfquery> --->
<cfquery name="get_info_requests" datasource="#DSN#">
	SELECT 
		CP.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
        PTR.STAGE
	FROM 
		CORRESPONDENCE_PAYMENT CP,
		EMPLOYEES E,
        PROCESS_TYPE_ROWS PTR
	WHERE
		E.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID AND
		CP.CC_EMP LIKE '#SESSION.EP.USERID#'
        AND CP.DUEDATE >= #DateAdd('d', -1, NOW())#
        AND CP.TO_EMPLOYEE_ID IN(#list_emp_ids#)
        AND CP.PROCESS_STAGE = PTR.PROCESS_ROW_ID
		<cfif len(attributes.process_status_2) and (attributes.process_status_2 eq 1 OR attributes.process_status_2 eq 0)>
			AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_status_2#">
		<cfelseif len(attributes.process_status_2) and attributes.process_status_2 eq 2>
			AND STATUS IS NULL
		</cfif>
	ORDER BY
		CP.DUEDATE DESC
</cfquery>
