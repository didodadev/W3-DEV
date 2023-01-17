<cfquery name="get_sales_imports" datasource="#DSN2#">
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
		<!---#DSN_ALIAS#.BRANCH.BRANCH_ID,
		#DSN_ALIAS#.BRANCH.BRANCH_NAME, --->
		STOCKS_LOCATION.COMMENT,
		BRANCH.BRANCH_NAME
	FROM
		SAYIMLAR,
		#DSN_ALIAS#.EMPLOYEES AS EMPLOYEES,
		#DSN_ALIAS#.STOCKS_LOCATION AS STOCKS_LOCATION,
		#DSN_ALIAS#.DEPARTMENT AS DEPARTMENT,
		#DSN_ALIAS#.BRANCH AS BRANCH		
	WHERE
		<!--- #DSN_ALIAS#.BRANCH.BRANCH_ID = SAYIMLAR.BRANCH_ID --->
		STOCKS_LOCATION.DEPARTMENT_ID = SAYIMLAR.DEPARTMENT_IN AND
		STOCKS_LOCATION.LOCATION_ID = SAYIMLAR.LOCATION_IN AND
		DEPARTMENT.DEPARTMENT_ID = SAYIMLAR.DEPARTMENT_IN AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID	AND	
		SAYIMLAR.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
		<cfif len(attributes.department_in) and len(attributes.location_in) and len(attributes.txt_departman_in)>
		AND SAYIMLAR.LOCATION_IN = #attributes.location_in# 
		AND SAYIMLAR.DEPARTMENT_IN = #attributes.department_in#
		</cfif>		
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
	<cfif session.ep.isBranchAuthorization>
		AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
	</cfif>
<!--- 	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND #DSN_ALIAS#.BRANCH.BRANCH_ID = #ATTRIBUTES.BRANCH_ID#
	</cfif>
 --->	ORDER BY 
			SAYIMLAR.RECORD_DATE DESC
</cfquery>
