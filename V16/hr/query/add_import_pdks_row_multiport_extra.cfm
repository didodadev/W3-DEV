<cfquery name="get_imports_all" datasource="#dsn#">
	SELECT
		EIO.START_DATE,
		EIO.IN_OUT_ID,
		EIO.EMPLOYEE_ID,
		EP.UPPER_POSITION_CODE,
		EP.UPPER_POSITION_CODE2,
		SS.START_HOUR,
		SS.START_MIN,
		SS.END_HOUR,
		SS.END_MIN,
		<cfif database_type is "MSSQL">
			SUM(DATEDIFF(MINUTE,EIO.START_DATE,EIO.FINISH_DATE)) AS TOTAL_MIN
		<cfelseif database_type is "DB2">
			SUM(SECONDSDIFF(EIO.FINISH_DATE,EIO.START_DATE))/60 AS TOTAL_MIN
		</cfif>
	FROM 
		EMPLOYEE_DAILY_IN_OUT EIO,
		EMPLOYEES_IN_OUT EI,
		SETUP_SHIFTS SS,
		EMPLOYEE_POSITIONS EP
	WHERE 
		EIO.FINISH_DATE IS NOT NULL AND
		EIO.FILE_ID = #attributes.i_id# AND
		EIO.IN_OUT_ID = EI.IN_OUT_ID AND
		EI.SHIFT_ID = SS.SHIFT_ID AND
		EP.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
		EP.IS_MASTER = 1
		AND ISNULL(EIO.FROM_HOURLY_ADDFARE,0) = 0
	GROUP BY
		EIO.START_DATE,
		EIO.IN_OUT_ID,
		EIO.EMPLOYEE_ID,
		EP.UPPER_POSITION_CODE,
		EP.UPPER_POSITION_CODE2,
		SS.START_HOUR,
		SS.START_MIN,
		SS.END_HOUR,
		SS.END_MIN
</cfquery>
	
<cfoutput query="get_imports_all">
	<cfset date_1 = createdatetime(2007,1,1,START_HOUR,START_MIN,0)>
	<cfset date_2 = createdatetime(2007,1,1,END_HOUR,END_MIN,0)>
	<cfset fark_ = datediff("n",date_1,date_2)>
	<cfif TOTAL_MIN gt fark_>
		<cfset new_date_ = createdatetime(year(START_DATE),month(START_DATE),day(START_DATE),END_HOUR,END_MIN,0)>
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_EXT_WORKTIMES
					(
					IS_FROM_PDKS,
					EMPLOYEE_ID,
					IN_OUT_ID,
					DAY_TYPE,
					VALIDATOR_POSITION_CODE_1,
					VALIDATOR_POSITION_CODE_2,
					START_TIME,
					END_TIME,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
					)
					VALUES
					(
					1,
					#employee_id#,
					#in_out_id#,
					0,
					<cfif len(UPPER_POSITION_CODE)>#UPPER_POSITION_CODE#,<cfelse>NULL,</cfif>
					<cfif len(UPPER_POSITION_CODE2)>#UPPER_POSITION_CODE2#,<cfelse>NULL,</cfif>
					#createodbcdatetime(new_date_)#,
					#createodbcdatetime(date_add("n",TOTAL_MIN-fark_,new_date_))#,
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
					)
		</cfquery>	
	</cfif>
</cfoutput>
