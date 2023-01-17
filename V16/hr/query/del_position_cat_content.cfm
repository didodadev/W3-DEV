<cfquery name="del_positions" datasource="#DSN#">
	DELETE FROM 
		EMPLOYEE_POSITIONS_AUTHORITY 
	WHERE 
		AUTHORITY_ID = #URL.AUTHORITY_ID# 
		AND 
		POSITION_ID IS NULL
</cfquery>

<cfquery name="upd_AUTHORITY" datasource="#DSN#">
DELETE FROM 
	EMPLOYEE_AUTHORITY 
WHERE
	AUTHORITY_ID = #URL.AUTHORITY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=hr.list_contents" addtoken="no">
