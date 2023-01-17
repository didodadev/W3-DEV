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
<cfquery name="GET_FEES" datasource="#dsn#">
	SELECT
		ES.ACCIDENT,
		ES.BRANCH_ID,
		ES.FEE_ID,
		ES.FEE_DATE,
		ES.EMPLOYEE_ID,
		ES.FEE_HOUR,
		ES.FEE_HOUROUT,
		ES.FEE_DATEOUT,
		ES.VALID,
		ES.VALID_EMP,
		ES.VALIDATOR_POS_CODE,
		ES.VALID_1,
		ES.VALID_EMP-1,
		ES.VALIDATOR_POS_CODE_1,
		ES.VALID_2,
		ES.VALID_EMP_2,
		ES.VALIDATOR_POS_CODE_2,
		ES.IN_OUT_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
 	FROM
		EMPLOYEES_SSK_FEE ES,
		EMPLOYEES E
	WHERE 
		ES.EMPLOYEE_ID = #session.ep.userid# 
		AND E.EMPLOYEE_ID = ES.EMPLOYEE_ID
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND FEE_DATEOUT BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> and  <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#">
	</cfif>
	<cfif not session.ep.ehesap>
		AND ES.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE IN (#pos_code_list#))
	</cfif>
	ORDER BY
		FEE_DATE DESC
</cfquery>
<cfquery name="GET_OTHER_FEES" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		ES.ACCIDENT,
		ES.BRANCH_ID,
		ES.FEE_ID,
		ES.FEE_DATE,
		ES.EMPLOYEE_ID,
		ES.FEE_HOUR,
		ES.FEE_HOUROUT,
		ES.FEE_DATEOUT,
		ES.VALID,
		ES.VALID_EMP,
		ES.VALIDATOR_POS_CODE,
		ES.IN_OUT_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
 	FROM
		EMPLOYEES_SSK_FEE ES,
		EMPLOYEES E
	WHERE 
		((ES.VALIDATOR_POS_CODE_1 IN (#pos_code_list#) AND ES.VALID_1 IS NULL)OR
		(ES.VALIDATOR_POS_CODE_2 IN (#pos_code_list#) AND ES.VALID_2 IS NULL AND
		ES.VALID_EMP_1 IS NOT NULL AND ES.VALID_1=1))
		AND E.EMPLOYEE_ID = ES.EMPLOYEE_ID
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND FEE_DATEOUT BETWEEN #attributes.start_date# and  #attributes.finish_date#
	</cfif>
	<cfif not session.ep.ehesap>
		AND ES.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE IN (#pos_code_list#))
	</cfif>
	ORDER BY
		FEE_DATE DESC
</cfquery>
