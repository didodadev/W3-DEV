<cfquery name="GET_CAUTION" datasource="#dsn#">
	SELECT
		EC.CAUTION_ID,
		EC.CAUTION_DATE,
		EC.CAUTION_DETAIL,		
		EC.CAUTION_HEAD,
		EC.WARNER,
        EC.WARNER_NAME,
		EC.CAUTION_TO,
		EC.IS_DISCIPLINE_CENTER,
		EC.IS_DISCIPLINE_BRANCH,
		EC.APOLOGY,
        EC.STAGE,
        EC.RECORD_EMP,
        EC.RECORD_DATE,
        EC.UPDATE_DATE,
        EC.UPDATE_EMP,
        EC.DECISION_NO,
        EC.APOLOGY_DATE,
        EC.IS_ACTIVE,
        EC.SPECIAL_DEFINITION_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		CT.CAUTION_TYPE,
		CT.CAUTION_TYPE_ID,
		SPI.COMMENT_PAY,
		EC.INTERRUPTION_ID,
		INTERRUPTION_DIVIDEND,
		INTERRUPTION_DENOMINATOR
 	FROM
		EMPLOYEES_CAUTION EC
		INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID=EC.CAUTION_TO
		LEFT JOIN SETUP_CAUTION_TYPE CT ON EC.CAUTION_TYPE_ID = CT.CAUTION_TYPE_ID
		LEFT JOIN SETUP_PAYMENT_INTERRUPTION SPI ON EC.INTERRUPTION_ID = SPI.ODKES_ID
	WHERE 
		EC.CAUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_id#">
</cfquery>


