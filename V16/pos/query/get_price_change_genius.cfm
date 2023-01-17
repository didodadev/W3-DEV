<!--- <cfscript>
//start_date olusuyor
if(len(attributes.start_clock))
	attributes.start_date = date_add('h', attributes.start_clock - session.ep.time_zone, attributes.start_date);
if(len(attributes.start_min))
	attributes.start_date = date_add('n', attributes.start_min, attributes.start_date);
//finish_date olusuyor	
if(len(attributes.finish_clock))
	attributes.finish_date = date_add('h', attributes.finish_clock - session.ep.time_zone, attributes.finish_date);
if(len(attributes.finish_min))
	attributes.finish_date = date_add('n', attributes.finish_min, attributes.finish_date);	
</cfscript> --->

<cfquery name="GET_PRICE_CHANGE_GENIUS" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		FI.E_ID,
		FI.PRODUCT_COUNT,
		FI.TARGET_SYSTEM,
		FI.FILE_NAME,
		FI.FILE_SIZE,
		FI.STARTDATE,
		FI.FINISHDATE,
		FI.PRICE_RECORD_DATE,
		FI.PRODUCT_RECORD_DATE,
		FI.DEPARTMENT_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		FI.RECORD_DATE,
		FI.RECORD_EMP		
	FROM
		FILE_EXPORTS FI,
		#dsn_alias#.EMPLOYEES E
	WHERE
		FI.RECORD_EMP = E.EMPLOYEE_ID AND
		FI.PROCESS_TYPE = -3<!--- fiyat degisim --->
		<cfif session.ep.isBranchAuthorization>
			AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = #attributes.branch_id#)
		</cfif>
		<cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
			AND FI.TARGET_SYSTEM = #attributes.target_pos#
		</cfif>
			AND FI.RECORD_DATE BETWEEN #attributes.start_date#
			AND #attributes.finish_date#
			<!--- 120 gune kaldir BK AND #DATEADD("d",1,attributes.finish_date)# --->
	ORDER BY
		FI.RECORD_DATE DESC
</cfquery>
