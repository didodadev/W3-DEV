<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset pos_code_list = valuelist(get_emp_pos.position_code)>
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
		SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#pos_code_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position1">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#pos_code_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position2">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
	</cfoutput>
	<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
		SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#pos_code_list#)
	</cfquery>
	<cfoutput query="Get_StandBy_Position3">
		<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
	</cfoutput>
</cfif>
<cfquery name="get_requests" datasource="#DSN#">
	SELECT 
		*
	FROM 
		CORRESPONDENCE_PAYMENT
	WHERE
		TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
		<cfif len(attributes.keyword)>
			AND (DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
		</cfif>
		<cfif len(attributes.status) and (attributes.status eq 0 or attributes.status eq 1)>
			AND STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
		<cfelseif len(attributes.status) and attributes.status eq 2>
			AND STATUS IS NULL
		</cfif>
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
		CP.*
	FROM 
		CORRESPONDENCE_PAYMENT CP,
		EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID AND
		((CP.VALIDATOR_POSITION_CODE_1 IN (#pos_code_list#) AND CP.VALID_1 IS NULL)OR
		(CP.VALIDATOR_POSITION_CODE_2 IN (#pos_code_list#) AND CP.VALID_2 IS NULL AND
		CP.VALID_EMPLOYEE_ID_1 IS NOT NULL AND CP.VALID_1=1))
		<cfif len(attributes.keyword)>
			AND (CP.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
		</cfif>
		<cfif len(attributes.status) and (attributes.status eq 0 or attributes.status eq 1)>
			AND CP.STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
		<cfelseif len(attributes.status) and attributes.status eq 2>
			AND CP.STATUS IS NULL
		</cfif>
	ORDER BY
		CP.DUEDATE DESC
</cfquery>
<cfquery name="get_reserve_other_requests" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		SR.*
	FROM
		SALARYPARAM_GET_REQUESTS SR,
		EMPLOYEES E
	WHERE 
		E.EMPLOYEE_ID = SR.EMPLOYEE_ID AND
		((SR.VALIDATOR_POSITION_CODE_1 IN (#pos_code_list#) AND SR.VALID_1 IS NULL)OR
		(SR.VALIDATOR_POSITION_CODE_2 IN (#pos_code_list#) AND SR.VALID_2 IS NULL AND
		SR.VALID_EMPLOYEE_ID_1 IS NOT NULL AND SR.VALID_1=1))	
		<cfif LEN(attributes.keyword)>
			AND SR.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif len(attributes.status) and (attributes.status eq 0 or attributes.status eq 1)>
			AND SR.IS_VALID = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
		<cfelseif len(attributes.status) and attributes.status eq 2>
			AND SR.IS_VALID IS NULL
		</cfif>
	ORDER BY
		SR.TERM DESC,
		SR.START_SAL_MON DESC
</cfquery>
<cfquery name="get_info_requests" datasource="#DSN#">
	SELECT 
		CP.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM 
		CORRESPONDENCE_PAYMENT CP,
		EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID AND
		CP.CC_EMP LIKE '#SESSION.EP.USERID#'
		<cfif len(attributes.keyword)>
			AND (CP.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR CP.SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
		</cfif>
		<cfif len(attributes.status) and (attributes.status eq 0 or attributes.status eq 1)>
			AND CP.STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
		<cfelseif len(attributes.status) and attributes.status eq 2>
			AND CP.STATUS IS NULL
		</cfif>
		AND CP.DUEDATE >= #DateAdd('d', -1, NOW())#
	ORDER BY
		CP.DUEDATE DESC
</cfquery>
