<cfquery name="get_sales_imports" datasource="#DSN2#">
	SELECT
		SAYIMLAR.GIRIS_ID,
		SAYIMLAR.FILE_NAME,
		SAYIMLAR.RECORD_DATE,
		SAYIMLAR.RECORD_EMP,
		#DSN_ALIAS#.EMPLOYEES.EMPLOYEE_NAME,
		#DSN_ALIAS#.EMPLOYEES.EMPLOYEE_SURNAME,
		#DSN_ALIAS#.BRANCH.BRANCH_ID,
		#DSN_ALIAS#.BRANCH.BRANCH_NAME
	FROM
		SAYIMLAR,
		#DSN_ALIAS#.EMPLOYEES,
		#DSN_ALIAS#.BRANCH
	WHERE
		#DSN_ALIAS#.BRANCH.BRANCH_ID = SAYIMLAR.BRANCH_ID
		AND SAYIMLAR.RECORD_EMP = #DSN_ALIAS#.EMPLOYEES.EMPLOYEE_ID
	<cfif len(attributes.startdate) and (not len(attributes.finishdate))>
		AND SAYIMLAR.RECORD_DATE >= #ATTRIBUTES.STARTDATE#
	<cfelseif len(attributes.finishdate)  and (not len(attributes.startdate))>
		AND SAYIMLAR.RECORD_DATE <= #ATTRIBUTES.FINISHDATE#
	<cfelseif len(attributes.startdate) and len(attributes.finishdate)>
		AND 
		(
			SAYIMLAR.RECORD_DATE >= #ATTRIBUTES.STARTDATE#
			AND SAYIMLAR.RECORD_DATE <= #DATEADD("d",1,ATTRIBUTES.FINISHDATE)#
		)
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND #DSN_ALIAS#.BRANCH.BRANCH_ID = #ATTRIBUTES.BRANCH_ID#
	</cfif>
	ORDER BY SAYIMLAR.RECORD_DATE DESC
</cfquery>ORD_DATE DESC
</cfquery>
