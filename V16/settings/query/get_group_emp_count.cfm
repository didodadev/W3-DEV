<cfquery name="GET_GROUP_EMP_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(USER_GROUP_ID) AS TOTAL 
	FROM 
	    EMPLOYEE_POSITIONS
	WHERE 
	    USER_GROUP_ID=#attributes.ID# 
	AND 
		POSITION_STATUS = 1
</cfquery>
