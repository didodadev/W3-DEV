<cfquery name="get_emp_par" datasource="#dsn#">
	SELECT 
		1 TYPE,
			EP.POSITION_CODE MEMBER_VALUE,
		'' NICKNAME,
		EP.EMPLOYEE_NAME MEMBER_NAME,
		EP.EMPLOYEE_SURNAME MEMBER_SURNAME,
		PEP.ROLE_ID ROLE_ID
	FROM 
		EMPLOYEE_POSITIONS EP,
		#dsn3_alias#.PRODUCTGROUP_EMP_PAR PEP
	WHERE 
		EP.POSITION_STATUS = 1 AND
		EP.POSITION_CODE = PEP.POSITION_CODE AND
		PEP.PRODUCT_ID = #attributes.pid#
	
	UNION
	
	SELECT 
		2 TYPE,
		CP.PARTNER_ID MEMBER_VALUE,
		C.NICKNAME NICKNAME,
		CP.COMPANY_PARTNER_NAME MEMBER_NAME,
		CP.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
		PEP.ROLE_ID ROLE_ID
	FROM 
		COMPANY_PARTNER CP,
		COMPANY C,
		#dsn3_alias#.PRODUCTGROUP_EMP_PAR PEP
	 WHERE 
		CP.PARTNER_ID = PEP.PARTNER_ID AND
		C.COMPANY_ID = CP.COMPANY_ID AND
		PEP.PRODUCT_ID = #attributes.pid#
	ORDER BY
		TYPE,
		MEMBER_NAME
</cfquery> 
