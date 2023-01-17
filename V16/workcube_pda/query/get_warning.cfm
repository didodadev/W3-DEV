<cfif isdefined('attributes.start_response_date') and isdefined('attributes.finish_response_date') and (not attributes.start_response_date contains "{ts") and (not attributes.finish_response_date contains "{ts")>
	<cf_date tarih="attributes.start_response_date">
	<cf_date tarih="attributes.finish_response_date">
	<cfset attributes.finish_response_date = date_add('h',23,attributes.finish_response_date)>
</cfif>
<cfquery name="GET_ALL_POSITIONS" datasource="#DSN#">
	SELECT 
    	POSITION_CODE 
	FROM 
    	EMPLOYEE_POSITIONS 
    WHERE
    	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
</cfquery>
<cfset pos_id_list = valuelist(get_all_positions.position_code)>
<cfquery name="GET_WARNINGS" datasource="#dsn#">
	SELECT 
		W_ID,
		URL_LINK,
		WARNING_HEAD,
		WARNING_DESCRIPTION,
		RECORD_EMP,
		RECORD_PAR,
		RECORD_CON,
		RECORD_DATE,
		PARENT_ID,
		POSITION_CODE,
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
		0 AS TYPE
	FROM 
		PAGE_WARNINGS
	WHERE
   		<cfif isDefined('attributes.conf_status') and len(attributes.conf_status)>
       		IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.conf_status#"> AND
        </cfif>	
		<cfif isDefined("page_type") and page_type eq 1><!--- Onay veya Red Olanlar Gelmeli --->
			IS_CONFIRM IS NOT NULL AND
		<cfelseif isDefined("page_type") and page_type eq 2>
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
		<cfelse>
		</cfif>
		<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
			LAST_RESPONSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#"> AND
			LAST_RESPONSE_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#"> AND
		</cfif>
		<cfif isDefined('attributes.warning_isactive') and Len(attributes.warning_isactive)>
			IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.warning_isactive#"> AND
		</cfif>
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			(
				WARNING_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				WARNING_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			) AND
		</cfif>
		<cfif isDefined("page_type") and page_type eq 3><!--- Processten Gelenlerde Baskalarinin Da Uyarı Onaylari Gorulur --->
			<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and len(attributes.employee_id) and len(attributes.position_code)>
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
			<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and len(attributes.employee_id) and len(attributes.position_code)>
				(RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">) AND
			</cfif>
			<cfif isdefined('attributes.warning_condition') and attributes.warning_condition eq 0><!--- Giden --->
				RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#">
			<cfelseif isdefined('attributes.warning_condition') and attributes.warning_condition eq 1><!--- Gelen --->
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">
			<cfelse>
				(RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> OR POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">)
			</cfif>
		</cfif>
	<cfif isdefined("x_select_izin") and x_select_izin eq 1 and not (isdefined('attributes.warning_condition') and attributes.warning_condition eq 0)>
		UNION ALL
			SELECT 
				0 W_ID,
				'index.cfm?fuseaction=myhome.popup_upd_other_offtime&offtime_id='+ CAST(OFFTIME_ID AS NVARCHAR) URL_LINK,
				'İzin Talebi' WARNING_HEAD,
				OFFTIME.DETAIL WARNING_DESCRIPTION,
				OFFTIME.RECORD_EMP,
				'' RECORD_PAR,
				0 RECORD_CON,
				OFFTIME.RECORD_DATE,
				0 PARENT_ID,
				'' POSITION_CODE,
				'' WARNING_RESULT,
				0 IS_CONTENT,
				1 IS_ACTIVE,
				NULL IS_CONFIRM,
				NULL CONFIRM_RESULT,
				'' RESPONSE,
				#session.pda.our_company_id# OUR_COMPANY_ID,
				OFFTIME.STARTDATE LAST_RESPONSE_DATE,
				#session.pda.period_id# PERIOD_ID,
				'' ACTION_TABLE,
				'' ACTION_COLUMN,
				'' ACTION_ID,
				1 AS TYPE
			FROM 
				OFFTIME
			WHERE
				OFFTIME.VALID IS NULL AND
				(
					(
						OFFTIME.VALIDATOR_POSITION_CODE_1 IN (#pos_id_list#) AND 
						OFFTIME.VALID_1 IS NULL
					)
				OR
					(
						OFFTIME.VALIDATOR_POSITION_CODE_2 IN (#pos_id_list#) AND 
						OFFTIME.VALID_2 IS NULL AND
						OFFTIME.VALID_EMPLOYEE_ID_1 IS NOT NULL AND 
						OFFTIME.VALID_1=1
					)
				)
				AND(OFFTIME.IS_PLAN <> 1 OR OFFTIME.IS_PLAN IS NULL)
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND	OFFTIME.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
				</cfif>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and len(attributes.employee_id) and len(attributes.position_code)>
					AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
					AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
					AND STARTDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
				</cfif>
	</cfif>
	<cfif isdefined("x_select_avans") and x_select_avans eq 1 and not (isdefined('attributes.warning_condition') and attributes.warning_condition eq 0)>
		UNION ALL
			SELECT 
				0 W_ID,
				'index.cfm?fuseaction=myhome.popupform_upd_payment_request_valid&id='+ CAST(ID AS NVARCHAR) URL_LINK,
				'Avans Talebi' WARNING_HEAD,
				CP.DETAIL WARNING_DESCRIPTION,
				CP.RECORD_EMP,
				'' RECORD_PAR,
				0 RECORD_CON,
				CP.RECORD_DATE,
				0 PARENT_ID,
				'' POSITION_CODE,
				'' WARNING_RESULT,
				0 IS_CONTENT,
				1 IS_ACTIVE,
				NULL IS_CONFIRM,
				NULL CONFIRM_RESULT,
				'' RESPONSE,
				#session.pda.our_company_id# OUR_COMPANY_ID,
				CP.DUEDATE LAST_RESPONSE_DATE,
				#session.pda.period_id# PERIOD_ID,
				'' ACTION_TABLE,
				'' ACTION_COLUMN,
				'' ACTION_ID,
				2 AS TYPE
			FROM 
				CORRESPONDENCE_PAYMENT CP
			WHERE
				((CP.VALIDATOR_POSITION_CODE_1 = #session.pda.position_code# AND CP.VALID_1 IS NULL)OR
				(CP.VALIDATOR_POSITION_CODE_2 = #session.pda.position_code# AND CP.VALID_2 IS NULL AND
				CP.VALID_EMPLOYEE_ID_1 IS NOT NULL AND CP.VALID_1=1))
				AND CP.STATUS IS NULL
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND	CP.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
				</cfif>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and len(attributes.employee_id) and len(attributes.position_code)>
					AND CP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
					AND DUEDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
					AND DUEDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
				</cfif>
		UNION ALL
			SELECT
				0 W_ID,
				'index.cfm?fuseaction=myhome.popupform_upd_other_payment_request_valid&id='+ CAST(SPGR_ID AS NVARCHAR) URL_LINK,
				'Taksitli Avans Talebi' WARNING_HEAD,
				SR.DETAIL WARNING_DESCRIPTION,
				SR.RECORD_EMP,
				'' RECORD_PAR,
				0 RECORD_CON,
				SR.RECORD_DATE,
				0 PARENT_ID,
				'' POSITION_CODE,
				'' WARNING_RESULT,
				0 IS_CONTENT,
				1 IS_ACTIVE,
				NULL IS_CONFIRM,
				NULL CONFIRM_RESULT,
				'' RESPONSE,
				#session.pda.our_company_id# OUR_COMPANY_ID,
				SR.RECORD_DATE LAST_RESPONSE_DATE,
				#session.pda.period_id# PERIOD_ID,
				'' ACTION_TABLE,
				'' ACTION_COLUMN,
				'' ACTION_ID,
				3 AS TYPE
			FROM
				SALARYPARAM_GET_REQUESTS SR
			WHERE 
				((SR.VALIDATOR_POSITION_CODE_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> AND SR.VALID_1 IS NULL)OR
				(SR.VALIDATOR_POSITION_CODE_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> AND SR.VALID_2 IS NULL AND
				SR.VALID_EMPLOYEE_ID_1 IS NOT NULL AND SR.VALID_1=1))	
				AND SR.IS_VALID IS NULL
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND	SR.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
				</cfif>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and len(attributes.employee_id) and len(attributes.position_code)>
					AND SR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
					AND SR.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
					AND SR.RECORD_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
				</cfif>
	</cfif>
	<cfif isdefined("x_select_ajanda") and x_select_ajanda eq 1 and not (isdefined('attributes.warning_condition') and attributes.warning_condition eq 0)>
		UNION ALL
			SELECT
				0 W_ID,
				'index.cfm?fuseaction=agenda.form_upd_event&control_all_=0&event_id='+ CAST(EVENT_ID AS NVARCHAR) URL_LINK,
				E.EVENT_HEAD WARNING_HEAD,
				E.EVENT_DETAIL WARNING_DESCRIPTION,
				E.RECORD_EMP,
				'' RECORD_PAR,
				0 RECORD_CON,
				E.RECORD_DATE,
				0 PARENT_ID,
				'' POSITION_CODE,
				'' WARNING_RESULT,
				0 IS_CONTENT,
				1 IS_ACTIVE,
				NULL IS_CONFIRM,
				NULL CONFIRM_RESULT,
				'' RESPONSE,
				#session.pda.our_company_id# OUR_COMPANY_ID,
				E.STARTDATE LAST_RESPONSE_DATE,
				#session.pda.period_id# PERIOD_ID,
				'' ACTION_TABLE,
				'' ACTION_COLUMN,
				'' ACTION_ID,
				4 AS TYPE
			FROM
				EVENT E
			WHERE 
				E.VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">
				AND E.VALID IS NULL
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND	E.EVENT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
				</cfif>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and len(attributes.employee_id) and len(attributes.position_code)>
					AND E.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
					AND E.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
					AND E.STARTDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
				</cfif>
	</cfif>
	ORDER BY 
		RECORD_DATE DESC
</cfquery>
