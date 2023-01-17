<cfif isdefined('attributes.start_response_date') and isdefined('attributes.finish_response_date') and (not attributes.start_response_date contains "{ts") and (not attributes.finish_response_date contains "{ts")>
	<cf_date tarih="attributes.start_response_date">
	<cf_date tarih="attributes.finish_response_date">
	<cfset attributes.finish_response_date = date_add('h',23,attributes.finish_response_date)>
</cfif>
<cfquery name="get_all_positions" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset pos_id_list = valuelist(get_all_positions.position_code)>

<cfquery name="GET_GROUP_WARNINGS" datasource="#dsn#">
	SELECT 
		URL_LINK,
		WARNING_HEAD,
		WARNING_DESCRIPTION,
		RECORD_EMP,
		RECORD_PAR,
		RECORD_CON,
		RECORD_DATE,
		PARENT_ID,
		WARNING_RESULT,
		IS_CONTENT,
		IS_ACTIVE,
		IS_CONFIRM,
		CONFIRM_RESULT,
		RESPONSE,
		OUR_COMPANY_ID,
		LAST_RESPONSE_DATE,
		PERIOD_ID,
		ACTION_TABLE,
		ACTION_COLUMN,
		ACTION_ID,
		0 AS TYPE,
		0 AS ID
	FROM 
		PAGE_WARNINGS
	WHERE
		<cfif isDefined("page_type") and page_type eq 1><!--- Onay veya Red Olanlar Gelmeli --->
			IS_CONFIRM IS NOT NULL AND
		<cfelseif isDefined("page_type") and page_type neq 3 and page_type neq 0>
			IS_CONFIRM IS NULL AND
		</cfif>
		<cfif isDefined("attributes.list_type") and Len(attributes.list_type) and attributes.list_type eq 1>
			IS_CONFIRM IS NOT NULL AND
		<cfelseif isDefined("attributes.list_type") and Len(attributes.list_type) and attributes.list_type eq 0>
			IS_CONFIRM IS NULL AND
		</cfif>
		<cfif isDefined("attributes.process_type_warning") and Len(attributes.process_type_warning)>
			IS_CONFIRM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_warning#"> AND
		</cfif>
		<cfif isDefined("attributes.action_table") and Len(attributes.action_table)>
			ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_table#"> AND
		</cfif>
		<cfif not isDefined('attributes.parent_id') and isDefined('attributes.warning_id')>
			W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.warning_id#"> AND
		<cfelseif isDefined('attributes.parent_id')>			
			PARENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parent_id#"> AND
			IS_PARENT = 0 AND
		</cfif>
        <cfif isdefined("warningAttached") and warningAttached eq 1><!--- Header.cfm sayfasında tanımlanıyor --->
			LAST_RESPONSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningStartResponseDate#"> AND
			LAST_RESPONSE_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningFinishResponseDate#"> AND
            IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
        <cfelse>
			<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
                LAST_RESPONSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#"> AND
                LAST_RESPONSE_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#"> AND
            </cfif>
            <cfif isDefined('attributes.warning_isactive') and Len(attributes.warning_isactive)>
                IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.warning_isactive#"> AND
            </cfif>
        </cfif>
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			(
				WARNING_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				WARNING_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			) AND
		</cfif>
		<cfif isDefined("page_type") and page_type eq 3><!--- Processten Gelenlerde Baskalarinin Da Uyarı Onaylari Gorulur --->
			<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and IsDefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
				<cfif not isdefined('attributes.warning_condition') and not len(attributes.warning_condition)>
					(PAGE_WARNINGS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR PAGE_WARNINGS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">) AND
				<cfelseif attributes.warning_condition eq 0><!--- Giden --->
					PAGE_WARNINGS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
				<cfelseif attributes.warning_condition eq 1><!--- Gelen --->
					PAGE_WARNINGS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"> AND
				</cfif>
			</cfif>
			IS_PARENT = 1
		<cfelse>
			<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and IsDefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
				(RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">) AND
			</cfif>
            <cfif isdefined("warningAttached") and warningAttached eq 1>
            	POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
            <cfelse>
				<cfif isdefined('attributes.warning_condition') and attributes.warning_condition eq 0><!--- Giden --->
                    RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                <cfelseif isdefined('attributes.warning_condition') and attributes.warning_condition eq 1><!--- Gelen --->
                    POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                <cfelse>
                    (RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
            </cfif>
		</cfif>
    GROUP BY
		URL_LINK,
		WARNING_HEAD,
		WARNING_DESCRIPTION,
		RECORD_EMP,
		RECORD_PAR,
		RECORD_CON,
		RECORD_DATE,
		PARENT_ID,
		WARNING_RESULT,
		IS_CONTENT,
		IS_ACTIVE,
		IS_CONFIRM,
		CONFIRM_RESULT,
		RESPONSE,
		OUR_COMPANY_ID,
		LAST_RESPONSE_DATE,
		PERIOD_ID,
		ACTION_TABLE,
		ACTION_COLUMN,
		ACTION_ID

</cfquery>