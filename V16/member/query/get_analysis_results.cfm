<cfquery name="GET_ANALYSIS_RESULTS" datasource="#DSN#">
	SELECT 
		1 TYPE,
		COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME MEMBER_PARTNER_NAME,
		C.FULLNAME MEMBER_NAME,
		C.COMPANY_ID,
        MAT.TERM,
		MAR.*
	FROM 
		MEMBER_ANALYSIS_RESULTS MAR 
        LEFT JOIN SETUP_MEMBER_ANALYSIS_TERM MAT ON MAR.PERIOD = MAT.TERM_ID,
		COMPANY_PARTNER CP,
		COMPANY C
	WHERE
		MAR.PARTNER_ID = CP.PARTNER_ID AND
		CP.COMPANY_ID = C.COMPANY_ID AND
		MAR.ANALYSIS_ID = #attributes.analysis_id#
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND	(C.FULLNAME LIKE #sql_unicode()#'%#attributes.keyword#%' )
		</cfif>
		<cfif isdefined("attributes.employee") and len(attributes.employee) and len(attributes.employee_id)>
			AND	MAR.RECORD_EMP = #attributes.employee_id#
		</cfif>
		<cfif len(attributes.start_dates)>AND MAR.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_dates#"></cfif>
		<cfif len(attributes.finish_dates)>AND MAR.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_dates#"></cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.member_type") and len(attributes.member_type) and isdefined("attributes.member_id") and len(attributes.member_id)>
			<cfif attributes.member_type is 'partner'>
				AND CP.PARTNER_ID = #attributes.member_id#
			<cfelse>
				AND 1 = 0
			</cfif>
		</cfif>
	UNION
	SELECT 
		2 TYPE,
		'' MEMBER_PARTNER_NAME,
		C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME MEMBER_PARTNER_NAME,
		'' COMPANY_ID,
        MAT.TERM,
		MAR.*
	FROM 
		MEMBER_ANALYSIS_RESULTS MAR
        LEFT JOIN SETUP_MEMBER_ANALYSIS_TERM MAT ON MAR.PERIOD = MAT.TERM_ID,	
		CONSUMER C		
	WHERE
		MAR.CONSUMER_ID = C.CONSUMER_ID AND
		MAR.ANALYSIS_ID = #attributes.analysis_id#
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND	(C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME LIKE #sql_unicode()#'%#attributes.keyword#%')
		</cfif>
		<cfif isdefined("attributes.employee") and len(attributes.employee) and len(attributes.employee_id)>
			AND	MAR.RECORD_EMP = #attributes.employee_id#
		</cfif>
		<cfif len(attributes.start_dates)>AND MAR.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_dates#"></cfif>
		<cfif len(attributes.finish_dates)>AND MAR.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_dates#"></cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.member_type") and len(attributes.member_type) and isdefined("attributes.member_id") and len(attributes.member_id)>
			<cfif attributes.member_type is 'consumer'>
				AND C.CONSUMER_ID = #attributes.member_id#
			<cfelse>
				AND 1 = 0
			</cfif>
		</cfif>
	UNION
	SELECT 
		3 TYPE,
		ATTENDANCE_NAME MEMBER_PARTNER_NAME,
		ATTENDANCE_COMPANY MEMBER_PARTNER_NAME,
		COMPANY_ID,
        MAT.TERM,
		MAR.*
	FROM 
		MEMBER_ANALYSIS_RESULTS MAR
        LEFT JOIN SETUP_MEMBER_ANALYSIS_TERM MAT ON MAR.PERIOD = MAT.TERM_ID	
	WHERE
		MAR.CONSUMER_ID IS NULL AND
		MAR.PARTNER_ID IS NULL AND
		MAR.ANALYSIS_ID = #attributes.analysis_id#
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND	(C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME LIKE #sql_unicode()#'%#attributes.keyword#%')
		</cfif>
		<cfif isdefined("attributes.employee") and len(attributes.employee) and len(attributes.employee_id)>
			AND	MAR.RECORD_EMP = #attributes.employee_id#
		</cfif>
		<cfif len(attributes.start_dates)>AND MAR.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_dates#"></cfif>
		<cfif len(attributes.finish_dates)>AND MAR.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_dates#"></cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.member_type") and len(attributes.member_type) and isdefined("attributes.member_id") and len(attributes.member_id)>
			<cfif attributes.member_type is 'consumer'>
				AND C.CONSUMER_ID = #attributes.member_id#
			<cfelse>
				AND 1 = 0
			</cfif>
		</cfif>
	ORDER BY
		USER_POINT DESC
</cfquery>
