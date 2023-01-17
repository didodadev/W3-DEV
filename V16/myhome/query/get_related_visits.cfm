<cfquery name="GET_REL_FEES" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		EMPLOYEE_ID,
		FEE_ID,
		ILL_NAME,
		ILL_RELATIVE,
		ILL_SURNAME,
		FEE_HOUR,
		FEE_DATE,
		VALID,
		VALID_EMP,
		VALIDATOR_POS_CODE,
		VALID_1,
		VALID_EMP_1,
		VALIDATOR_POS_CODE_1,
		VALID_2,
		VALID_EMP_2,
		VALIDATOR_POS_CODE_2
 	FROM
		EMPLOYEES_SSK_FEE_RELATIVE
	WHERE 
		EMPLOYEE_ID = #session.ep.userid# 
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND FEE_DATE BETWEEN #attributes.start_date# and  #attributes.finish_date#
	</cfif>
	<cfif not session.ep.ehesap>
		AND BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	</cfif>
	ORDER BY
		FEE_DATE DESC
</cfquery>
<cfquery name="GET_OTHER_REL_FEES" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		EMPLOYEE_ID,
		FEE_ID,
		ILL_NAME,
		ILL_RELATIVE,
		ILL_SURNAME,
		FEE_HOUR,
		FEE_DATE,
		VALID,
		VALID_EMP,
		VALIDATOR_POS_CODE
 	FROM
		EMPLOYEES_SSK_FEE_RELATIVE
	WHERE 
		((VALIDATOR_POS_CODE_1 = #SESSION.EP.POSITION_CODE# AND VALID_1 IS NULL)OR
		(VALIDATOR_POS_CODE_2 = #SESSION.EP.POSITION_CODE# AND VALID_2 IS NULL AND
		VALID_EMP_1 IS NOT NULL AND VALID_1=1))
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND FEE_DATE BETWEEN #attributes.start_date# and  #attributes.finish_date#
	</cfif>
	<cfif not session.ep.ehesap>
		AND BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	</cfif>
	ORDER BY
		FEE_DATE DESC
</cfquery>
