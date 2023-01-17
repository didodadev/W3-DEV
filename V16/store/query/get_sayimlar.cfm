<cfquery name="get_sales_imports" datasource="#dsn2#">
	SELECT
		SAYIMLAR.GIRIS_ID,
		SAYIMLAR.FILE_NAME,
		SAYIMLAR.RECORD_DATE,
		SAYIMLAR.RECORD_EMP,
		SAYIMLAR.DESCRIPTION,
		SAYIMLAR.DEPARTMENT_IN,
		SAYIMLAR.LOCATION_IN,		
		SAYIMLAR.TOPLAM_MALIYET,
		SAYIMLAR.FIS_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		STOCKS_LOCATION.COMMENT,
		BRANCH.BRANCH_NAME
	FROM
		SAYIMLAR,
		#dsn_alias#.EMPLOYEES AS EMPLOYEES,
		#dsn_alias#.STOCKS_LOCATION AS STOCKS_LOCATION,
		#dsn_alias#.DEPARTMENT AS DEPARTMENT,
		#dsn_alias#.BRANCH AS BRANCH		
	WHERE
		STOCKS_LOCATION.DEPARTMENT_ID = SAYIMLAR.DEPARTMENT_IN AND
		STOCKS_LOCATION.LOCATION_ID = SAYIMLAR.LOCATION_IN AND
		DEPARTMENT.DEPARTMENT_ID = SAYIMLAR.DEPARTMENT_IN AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID	AND	
		SAYIMLAR.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND BRANCH.BRANCH_ID = #attributes.branch_id#
	</cfif>
	<cfif len(attributes.startdate) and (not len(attributes.finishdate))>
		AND SAYIMLAR.RECORD_DATE >= #attributes.startdate#
	<cfelseif len(attributes.finishdate)  and (not len(attributes.startdate))>
		AND SAYIMLAR.RECORD_DATE <= #attributes.finishdate#
	<cfelseif len(attributes.startdate) and len(attributes.finishdate)>
		AND 
		(
			SAYIMLAR.RECORD_DATE >= #attributes.startdate# AND
			SAYIMLAR.RECORD_DATE <= #DATEADD("d",1,attributes.finishdate)#
		)
	</cfif>
	ORDER BY 
		SAYIMLAR.RECORD_DATE DESC
</cfquery>
