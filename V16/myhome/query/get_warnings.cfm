<!--- 
	History : {
		31/01/2020 - Uğur Hamurpet - İzin işlemleri sürece taşındığından get_warnings sorgusunda ilgili union all kısmı kaldırıldı
		02/03/2020 - Uğur Hamurpet - Workflow filtresine tekil ve toplu süreç filtresi eklendi
	}
--->
<cfif isdefined('attributes.start_response_date') and isdefined('attributes.finish_response_date') and (not attributes.start_response_date contains "{ts") and (not attributes.finish_response_date contains "{ts")>
	<cfset attributes.start_response_date = URLDecode(attributes.start_response_date) />
	<cfset attributes.finish_response_date = URLDecode(attributes.finish_response_date) />
	<cf_date tarih="attributes.start_response_date">
	<cf_date tarih="attributes.finish_response_date">
	<cfset attributes.finish_response_date = date_add('h',23,attributes.finish_response_date)>
</cfif>
<cfquery name="get_all_positions" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfset pos_id_list = valuelist(get_all_positions.position_code)>
<cfparam name="attributes.reservedfuseaction" type="string" default="">

<cfset attributes.view_mode = attributes.view_mode?:'list' />

<cfif attributes.view_mode eq 'list'>
	<cfquery name="GET_WARNINGS" datasource="#dsn#">
		SELECT 
			PW.W_ID,
			PW.URL_LINK,
			PW.WARNING_HEAD,
			PW.WARNING_DESCRIPTION,
			PW.RECORD_EMP,
			PW.RECORD_PAR,
			PW.RECORD_CON,
			PW.RECORD_DATE,
			PW.PARENT_ID,
			PW.POSITION_CODE,
			PW.WARNING_RESULT,
			PW.IS_CONTENT,
			PW.IS_ACTIVE,
			PW.IS_CONFIRM,
			PW.CONFIRM_RESULT,
			PW.RESPONSE,
			PW.OUR_COMPANY_ID,
			PW.LAST_RESPONSE_DATE,
			PW.PERIOD_ID,
			PW.ACTION_TABLE,
			PW.ACTION_COLUMN,
			PW.ACTION_ID,
			PW.ACTION_STAGE_ID,
			0 AS TYPE,
			ISNULL(PW.COMMENT_REQUEST,0) AS COMMENT_REQUEST,
			0 AS ID,
			PW.IS_AGAIN,
			PW.IS_SUPPORT,
			PW.IS_CANCEL,
			PW.IS_REFUSE,
			PW.IS_MANDATE,
			ISNULL(PW.IS_NOTIFICATION,0) AS IS_NOTIFICATION,
			ISNULL(PW.IS_CONFIRM_COMMENT_REQUIRED,0) AS IS_CONFIRM_COMMENT_REQUIRED,
			ISNULL(PW.IS_REFUSE_COMMENT_REQUIRED,0) AS IS_REFUSE_COMMENT_REQUIRED,
			ISNULL(PW.IS_AGAIN_COMMENT_REQUIRED,0) AS IS_AGAIN_COMMENT_REQUIRED,
			ISNULL(PW.IS_SUPPORT_COMMENT_REQUIRED,0) AS IS_SUPPORT_COMMENT_REQUIRED,
			ISNULL(PW.IS_CANCEL_COMMENT_REQUIRED,0) AS IS_CANCEL_COMMENT_REQUIRED,
			ISNULL(PW.IS_MANUEL_NOTIFICATION,0) AS IS_MANUEL_NOTIFICATION,
			PWA.WARNING_ID AS PWA_WARNING_ID,
			PWA.IS_CONFIRM AS PWA_IS_CONFIRM, 
			PWA.IS_AGAIN AS PWA_IS_AGAIN,
			PWA.IS_SUPPORT AS PWA_IS_SUPPORT,
			PWA.IS_CANCEL AS PWA_IS_CANCEL,
			PWA.IS_REFUSE AS PWA_IS_REFUSE,
			PWA.RECORD_DATE AS PWA_RECORD_DATE,
			PWA.WARNING_DESCRIPTION AS PWA_WARNING_DESCRIPTION,
			CONCAT( EMPS.EMPLOYEE_NAME, ' ', EMPS.EMPLOYEE_SURNAME ) AS PWA_USERNAME,
			ISNULL(PTR.ANSWER_HOUR,0) ANSWER_HOUR,
			ISNULL(PTR.ANSWER_MINUTE,0) ANSWER_MINUTE,
			ISNULL(PTR.DESTINATION_WO,'') DESTINATION_WO,
			ISNULL(PTR.DESTINATION_EVENT,'') DESTINATION_EVENT,
			ISNULL(PTR.IS_REQUIRED_PREVIEW,0) IS_REQUIRED_PREVIEW,
			ISNULL(PTR.IS_REQUIRED_ACTION_LINK,0) IS_REQUIRED_ACTION_LINK,
			PW.PAPER_NO,
			PW.ACCESS_CODE WSR_CODE
			<cfif not (isdefined("warningAttached") and warningAttached eq 1 ) >
			,GP.GENERAL_PAPER_NO
			,GP.GENERAL_PAPER_ID
			,GP.GENERAL_PAPER_PARENT_ID
			,GP.ACTION_LIST_ID
			</cfif>
		FROM 
			PAGE_WARNINGS AS PW
			LEFT JOIN #dsn3#.SETUP_PROCESS_CAT AS PS ON PS.PROCESS_CAT_ID=PW.ACTION_PROCESS_CAT_ID
			LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON PW.ACTION_STAGE_ID = PTR.PROCESS_ROW_ID
			LEFT JOIN PAGE_WARNINGS_ACTIONS AS PWA ON PW.W_ID = PWA.WARNING_ID
			LEFT JOIN EMPLOYEES AS EMPS ON PWA.RECORD_EMP = EMPS.EMPLOYEE_ID
			<cfif not (isdefined("warningAttached") and warningAttached eq 1 ) >
			<cfif isdefined('attributes.process_mode') and ( not len(attributes.process_mode) or attributes.process_mode eq 1)>
			LEFT JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
			<cfelse>
			JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
			</cfif>
			</cfif>
		WHERE
			<cfif isDefined("attributes.page_type") and attributes.page_type eq 1><!--- Onay veya Red Olanlar Gelmeli --->
				PW.IS_CONFIRM IS NOT NULL AND
			<cfelseif isDefined("attributes.page_type") and (attributes.fuseaction neq 'process.list_warnings' and attributes.reservedfuseaction neq 'process.list_warnings') and attributes.page_type neq 0>
				PW.IS_CONFIRM IS NULL AND
			</cfif>
			<cfif isDefined("attributes.list_type") and Len(attributes.list_type) and attributes.list_type eq 1>
				PW.IS_CONFIRM IS NOT NULL AND
			<cfelseif isDefined("attributes.list_type") and Len(attributes.list_type) and attributes.list_type eq 0>
				PW.IS_CONFIRM IS NULL AND
			</cfif>
			<cfif isDefined("attributes.process_type_warning") and Len(attributes.process_type_warning)>
				PW.IS_CONFIRM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_warning#"> AND
			</cfif>
			<cfif isDefined("attributes.action_table") and Len(attributes.action_table)>
				PW.ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_table#"> AND
			</cfif>
			<cfif not isDefined('attributes.parent_id') and isDefined('attributes.warning_id')>
				PW.W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.warning_id#"> AND
			<cfelseif isDefined('attributes.parent_id')>			
				PW.PARENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parent_id#"> AND
				PW.IS_PARENT = 0 AND
			</cfif>
			<cfif isdefined("warningAttached") and warningAttached eq 1><!--- Header.cfm sayfasında tanımlanıyor --->
				PW.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningStartResponseDate#"> AND
				PW.RECORD_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningFinishResponseDate#"> AND
				PW.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			<cfelse>
				<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
					PW.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#"> AND
					PW.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#"> AND
				</cfif>
				<cfif isDefined('attributes.warning_isactive') and Len(attributes.warning_isactive)>
					PW.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.warning_isactive#"> AND
				</cfif>
			</cfif>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				(
					PW.WARNING_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					PW.WARNING_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				) AND
			</cfif>
			<cfif IsDefined("attributes.process_id") and len(attributes.process_id)>
				PTR.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
			</cfif>
			<cfif IsDefined("attributes.process_row_id") and len(attributes.process_row_id)>
				PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#"> AND
			</cfif>
			<cfif attributes.fuseaction eq 'process.list_warnings' or attributes.reservedfuseaction eq 'process.list_warnings' or (isdefined("is_mandate") and attributes.is_mandate eq 1)><!--- Processten Gelenlerde Baskalarinin Da Uyarı Onaylari Gorulur --->
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and IsDefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
					<cfif not isdefined('attributes.warning_condition') or not len(attributes.warning_condition)>
						(PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">) AND
					<cfelseif attributes.warning_condition eq 0><!--- Giden --->
						PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
					<cfelseif attributes.warning_condition eq 1><!--- Gelen --->
						PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"> AND
					</cfif>
				</cfif>
				PW.IS_PARENT = 1
			<cfelse>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and IsDefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
					(PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">) AND
				</cfif>
				<cfif isdefined("warningAttached") and warningAttached eq 1>
					PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
				<cfelse>
					<cfif isdefined('attributes.warning_condition') and attributes.warning_condition eq 0><!--- Giden --->
						PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					<cfelseif isdefined('attributes.warning_condition') and attributes.warning_condition eq 1><!--- Gelen --->
						PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
					<cfelse>
						(PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
				</cfif>
			</cfif>
		<cfif not (isdefined('attributes.warning_condition') and attributes.warning_condition eq 0)>
		UNION ALL
			SELECT 
				0 W_ID,
				'index.cfm?fuseaction=myhome.popupform_upd_payment_request_valid&id='+ CAST(ID AS NVARCHAR) URL_LINK,
				'Avans Talebi' WARNING_HEAD,
				COP.DETAIL WARNING_DESCRIPTION,
				COP.RECORD_EMP,
				'' RECORD_PAR,
				0 RECORD_CON,
				COP.RECORD_DATE,
				0 PARENT_ID,
				'' POSITION_CODE,
				'' WARNING_RESULT,
				0 IS_CONTENT,
				1 IS_ACTIVE,
				NULL IS_CONFIRM,
				NULL CONFIRM_RESULT,
				'' RESPONSE,
				#session.ep.company_id# OUR_COMPANY_ID,
				COP.DUEDATE LAST_RESPONSE_DATE,
				#session.ep.period_id# PERIOD_ID,
				'' ACTION_TABLE,
				'' ACTION_COLUMN,
				'' ACTION_ID,
				'' ACTION_STAGE_ID,
				2 AS TYPE,
				0 AS COMMENT_REQUEST,
				COP.ID,
				0 IS_AGAIN,
				0 IS_SUPPORT,
				0 IS_CANCEL,
				0 IS_REFUSE,
				0 IS_MANDATE,
				0 IS_NOTIFICATION,
				0 IS_CONFIRM_COMMENT_REQUIRED,
				0 IS_REFUSE_COMMENT_REQUIRED,
				0 IS_AGAIN_COMMENT_REQUIRED,
				0 IS_SUPPORT_COMMENT_REQUIRED,
				0 IS_CANCEL_COMMENT_REQUIRED,
				0 IS_MANUEL_NOTIFICATION,
				'' PWA_WARNING_ID,
				'' PWA_IS_CONFIRM,
				'' PWA_IS_AGAIN,
				'' PWA_IS_SUPPORT,
				'' PWA_IS_CANCEL,
				'' PWA_IS_REFUSE,
				'' PWA_RECORD_DATE,
				'' PWA_USERNAME,
				'' PWA_WARNING_DESCRIPTION,
				ISNULL(PTR.ANSWER_HOUR,0) ANSWER_HOUR,
				ISNULL(PTR.ANSWER_MINUTE,0) ANSWER_MINUTE,
				ISNULL(PTR.DESTINATION_WO,'') DESTINATION_WO,
				ISNULL(PTR.DESTINATION_EVENT,'') DESTINATION_EVENT,
				ISNULL(PTR.IS_REQUIRED_PREVIEW,0) IS_REQUIRED_PREVIEW,
				ISNULL(PTR.IS_REQUIRED_ACTION_LINK,0) IS_REQUIRED_ACTION_LINK,
				'' WSR_CODE,
				'' PAPER_NO
				<cfif not (isdefined("warningAttached") and warningAttached eq 1 ) >
				,'' GENERAL_PAPER_NO
				,'' GENERAL_PAPER_ID
				,'' GENERAL_PAPER_PARENT_ID
				,'' ACTION_LIST_ID
				</cfif>
			FROM 
				CORRESPONDENCE_PAYMENT AS COP
				JOIN PROCESS_TYPE_ROWS AS PTR ON COP.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			WHERE
				((COP.VALIDATOR_POSITION_CODE_1 = #session.ep.position_code# AND VALID_1 IS NULL)OR
				(COP.VALIDATOR_POSITION_CODE_2 = #session.ep.position_code# AND VALID_2 IS NULL AND
				COP.VALID_EMPLOYEE_ID_1 IS NOT NULL AND COP.VALID_1=1))
				AND STATUS IS NULL
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND	COP.DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
				</cfif>
				<cfif IsDefined("attributes.process_id") and len(attributes.process_id)>
					AND PTR.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
				</cfif>
				<cfif IsDefined("attributes.process_row_id") and len(attributes.process_row_id)>
					AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
				</cfif>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
					AND COP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isdefined("warningAttached") and warningAttached eq 1><!--- Header.cfm sayfasında tanımlanıyor --->
						AND	COP.DUEDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningStartResponseDate#"> 
						AND	COP.DUEDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningFinishResponseDate#">
				<cfelse>
					<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
						AND COP.DUEDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
						AND COP.DUEDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
					</cfif>
				</cfif>
		UNION ALL
			SELECT
				0 W_ID,
				'index.cfm?fuseaction=myhome.popupform_upd_other_payment_request_valid&id='+ CAST(SPGR_ID AS NVARCHAR) URL_LINK,
				'Taksitli Avans Talebi' WARNING_HEAD,
				DETAIL WARNING_DESCRIPTION,
				RECORD_EMP,
				'' RECORD_PAR,
				0 RECORD_CON,
				RECORD_DATE,
				0 PARENT_ID,
				'' POSITION_CODE,
				'' WARNING_RESULT,
				0 IS_CONTENT,
				1 IS_ACTIVE,
				NULL IS_CONFIRM,
				NULL CONFIRM_RESULT,
				'' RESPONSE,
				#session.ep.company_id# OUR_COMPANY_ID,
				RECORD_DATE LAST_RESPONSE_DATE,
				#session.ep.period_id# PERIOD_ID,
				'' ACTION_TABLE,
				'' ACTION_COLUMN,
				'' ACTION_ID,
				'' ACTION_STAGE_ID,
				3 AS TYPE,
				0 AS COMMENT_REQUEST,
				0 AS ID,
				0 IS_AGAIN,
				0 IS_SUPPORT,
				0 IS_CANCEL,
				0 IS_REFUSE,
				0 IS_MANDATE,
				0 IS_NOTIFICATION,
				0 IS_CONFIRM_COMMENT_REQUIRED,
				0 IS_REFUSE_COMMENT_REQUIRED,
				0 IS_AGAIN_COMMENT_REQUIRED,
				0 IS_SUPPORT_COMMENT_REQUIRED,
				0 IS_CANCEL_COMMENT_REQUIRED,
				0 IS_MANUEL_NOTIFICATION,
				'' PWA_WARNING_ID,
				'' PWA_IS_CONFIRM,
				'' PWA_IS_AGAIN,
				'' PWA_IS_SUPPORT,
				'' PWA_IS_CANCEL,
				'' PWA_IS_REFUSE,
				'' PWA_RECORD_DATE,
				'' PWA_USERNAME,
				'' PWA_WARNING_DESCRIPTION,
				0 ANSWER_HOUR,
				0 ANSWER_MINUTE,
				'' DESTINATION_WO,
				'' DESTINATION_EVENT,
				0 IS_REQUIRED_PREVIEW,
				0 IS_REQUIRED_ACTION_LINK,
				'' WSR_CODE,
				'' PAPER_NO
				<cfif not (isdefined("warningAttached") and warningAttached eq 1 ) >
				,'' GENERAL_PAPER_NO
				,'' GENERAL_PAPER_ID
				,'' GENERAL_PAPER_PARENT_ID
				,'' ACTION_LIST_ID
				</cfif>
			FROM
				SALARYPARAM_GET_REQUESTS
			WHERE 
				((VALIDATOR_POSITION_CODE_1 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND VALID_1 IS NULL)OR
				(VALIDATOR_POSITION_CODE_2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND VALID_2 IS NULL AND
				VALID_EMPLOYEE_ID_1 IS NOT NULL AND VALID_1=1))	AND 
				IS_VALID IS NULL
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND	DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
				</cfif>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
					AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isdefined("warningAttached") and warningAttached eq 1><!--- Header.cfm sayfasında tanımlanıyor --->
					AND	RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningStartResponseDate#"> 
					AND	RECORD_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningFinishResponseDate#">
				<cfelse>
					<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
						AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
						AND RECORD_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
					</cfif>
				</cfif>
		UNION ALL
			SELECT
				0 W_ID,
				'index.cfm?fuseaction=agenda.view_daily&event=upd&control_all_=0&event_id='+ CAST(EVENT_ID AS NVARCHAR) URL_LINK,
				EVENT.EVENT_HEAD WARNING_HEAD,
				EVENT.EVENT_DETAIL WARNING_DESCRIPTION,
				EVENT.RECORD_EMP,
				'' RECORD_PAR,
				0 RECORD_CON,
				EVENT.RECORD_DATE,
				0 PARENT_ID,
				'' POSITION_CODE,
				'' WARNING_RESULT,
				0 IS_CONTENT,
				1 IS_ACTIVE,
				NULL IS_CONFIRM,
				NULL CONFIRM_RESULT,
				'' RESPONSE,
				#session.ep.company_id# OUR_COMPANY_ID,
				EVENT.STARTDATE LAST_RESPONSE_DATE,
				#session.ep.period_id# PERIOD_ID,
				'' ACTION_TABLE,
				'' ACTION_COLUMN,
				'' ACTION_ID,
				'' ACTION_STAGE_ID,
				4 AS TYPE,
				0 AS COMMENT_REQUEST,
				0 AS ID,
				0 IS_AGAIN,
				0 IS_SUPPORT,
				0 IS_CANCEL,
				0 IS_REFUSE,
				0 IS_MANDATE,
				0 IS_NOTIFICATION,
				0 IS_CONFIRM_COMMENT_REQUIRED,
				0 IS_REFUSE_COMMENT_REQUIRED,
				0 IS_AGAIN_COMMENT_REQUIRED,
				0 IS_SUPPORT_COMMENT_REQUIRED,
				0 IS_CANCEL_COMMENT_REQUIRED,
				0 IS_MANUEL_NOTIFICATION,
				'' PWA_WARNING_ID,
				'' PWA_IS_CONFIRM,
				'' PWA_IS_AGAIN,
				'' PWA_IS_SUPPORT,
				'' PWA_IS_CANCEL,
				'' PWA_IS_REFUSE,
				'' PWA_RECORD_DATE,
				'' PWA_USERNAME,
				'' PWA_WARNING_DESCRIPTION,
				ISNULL(PTR.ANSWER_HOUR,0) ANSWER_HOUR,
				ISNULL(PTR.ANSWER_MINUTE,0) ANSWER_MINUTE,
				ISNULL(PTR.DESTINATION_WO,'') DESTINATION_WO,
				ISNULL(PTR.DESTINATION_EVENT,'') DESTINATION_EVENT,
				ISNULL(PTR.IS_REQUIRED_PREVIEW,0) IS_REQUIRED_PREVIEW,
				ISNULL(PTR.IS_REQUIRED_ACTION_LINK,0) IS_REQUIRED_ACTION_LINK,
				'' WSR_CODE,
				'' PAPER_NO
				<cfif not (isdefined("warningAttached") and warningAttached eq 1 ) >
				,'' GENERAL_PAPER_NO
				,'' GENERAL_PAPER_ID
				,'' GENERAL_PAPER_PARENT_ID
				,'' ACTION_LIST_ID
				</cfif>
			FROM
				EVENT
				JOIN PROCESS_TYPE_ROWS AS PTR ON EVENT.EVENT_STAGE = PTR.PROCESS_ROW_ID
			WHERE 
				EVENT.VALIDATOR_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
				AND EVENT.VALID IS NULL
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					AND	EVENT.EVENT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
				</cfif>
				<cfif IsDefined("attributes.process_id") and len(attributes.process_id)>
					AND PTR.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#">
				</cfif>
				<cfif IsDefined("attributes.process_row_id") and len(attributes.process_row_id)>
					AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
				</cfif>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
					AND EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isdefined("warningAttached") and warningAttached eq 1><!--- Header.cfm sayfasında tanımlanıyor --->
						AND	EVENT.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningStartResponseDate#"> 
						AND	EVENT.STARTDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningFinishResponseDate#">
				<cfelse>
					<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
						AND EVENT.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#">
						AND EVENT.STARTDATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#">
					</cfif>
				</cfif>
		</cfif>
		ORDER BY 
			W_ID DESC
	</cfquery>
<cfelseif attributes.view_mode eq 'card'>
	<cfquery name="GET_WARNINGS" datasource="#dsn#">
		SELECT
			PT.PROCESS_ID,
			PT.PROCESS_NAME,
			PROCESS_ROW_ID,
			COUNT(PTR.PROCESS_ROW_ID) AS PROCESS_STAGE_COUNT,
			PTR.STAGE
		FROM PAGE_WARNINGS AS PW
		 JOIN #dsn3#.SETUP_PROCESS_CAT AS PS ON PS.PROCESS_CAT_ID=PW.ACTION_PROCESS_CAT_ID
		JOIN PROCESS_TYPE_ROWS AS PTR ON PW.ACTION_STAGE_ID = PTR.PROCESS_ROW_ID
		JOIN PROCESS_TYPE AS PT ON PTR.PROCESS_ID = PT.PROCESS_ID
		<cfif isdefined('attributes.process_mode') and ( not len(attributes.process_mode) or attributes.process_mode eq 1)>
		LEFT JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
		<cfelse>
		JOIN GENERAL_PAPER AS GP ON PW.GENERAL_PAPER_ID = GP.GENERAL_PAPER_ID
		</cfif>
		WHERE
			<cfif isDefined("attributes.page_type") and attributes.page_type eq 1><!--- Onay veya Red Olanlar Gelmeli --->
				PW.IS_CONFIRM IS NOT NULL AND
			<cfelseif isDefined("attributes.page_type") and (attributes.fuseaction neq 'process.list_warnings' and attributes.reservedfuseaction neq 'process.list_warnings') and attributes.page_type neq 0>
				PW.IS_CONFIRM IS NULL AND
			</cfif>
			<cfif isDefined("attributes.list_type") and Len(attributes.list_type) and attributes.list_type eq 1>
				PW.IS_CONFIRM IS NOT NULL AND
			<cfelseif isDefined("attributes.list_type") and Len(attributes.list_type) and attributes.list_type eq 0>
				PW.IS_CONFIRM IS NULL AND
			</cfif>
			<cfif isDefined("attributes.process_type_warning") and Len(attributes.process_type_warning)>
				PW.IS_CONFIRM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_type_warning#"> AND
			</cfif>
			<cfif isDefined("attributes.action_table") and Len(attributes.action_table)>
				PW.ACTION_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.action_table#"> AND
			</cfif>
			<cfif not isDefined('attributes.parent_id') and isDefined('attributes.warning_id')>
				PW.W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.warning_id#"> AND
			<cfelseif isDefined('attributes.parent_id')>			
				PW.PARENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parent_id#"> AND
				PW.IS_PARENT = 0 AND
			</cfif>
			<cfif isdefined("warningAttached") and warningAttached eq 1><!--- Header.cfm sayfasında tanımlanıyor --->
				PW.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningStartResponseDate#"> AND
				PW.RECORD_DATE	<= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#warningFinishResponseDate#"> AND
				PW.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			<cfelse>
				<cfif isDefined('attributes.start_response_date') and isDefined('attributes.finish_response_date') and len(attributes.start_response_date) and Len(attributes.finish_response_date)>
					PW.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_response_date#"> AND
					PW.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_response_date#"> AND
				</cfif>
				<cfif isDefined('attributes.warning_isactive') and Len(attributes.warning_isactive)>
					PW.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.warning_isactive#"> AND
				</cfif>
			</cfif>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				(
					PW.WARNING_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					PW.WARNING_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				) AND
			</cfif>
			<cfif IsDefined("attributes.process_id") and len(attributes.process_id)>
				PTR.PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
			</cfif>
			<cfif attributes.fuseaction eq 'process.list_warnings' or attributes.reservedfuseaction eq 'process.list_warnings' or (isdefined("is_mandate") and attributes.is_mandate eq 1)><!--- Processten Gelenlerde Baskalarinin Da Uyarı Onaylari Gorulur --->
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and IsDefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
					<cfif not isdefined('attributes.warning_condition') or not len(attributes.warning_condition)>
						(PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">) AND
					<cfelseif attributes.warning_condition eq 0><!--- Giden --->
						PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
					<cfelseif attributes.warning_condition eq 1><!--- Gelen --->
						PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"> AND
					</cfif>
				</cfif>
				PW.IS_PARENT = 1
			<cfelse>
				<cfif isdefined('attributes.employee_name') and len(attributes.employee_name) and IsDefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.position_code") and len(attributes.position_code)>
					(PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> OR PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">) AND
				</cfif>
				<cfif isdefined("warningAttached") and warningAttached eq 1>
					PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
				<cfelse>
					<cfif isdefined('attributes.warning_condition') and attributes.warning_condition eq 0><!--- Giden --->
						PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					<cfelseif isdefined('attributes.warning_condition') and attributes.warning_condition eq 1><!--- Gelen --->
						PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
					<cfelse>
						(PW.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR PW.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
				</cfif>
			</cfif>
		GROUP BY
			PT.PROCESS_ID,
			PT.PROCESS_NAME,
			PTR.PROCESS_ROW_ID,
			PTR.STAGE
		ORDER BY 
			PT.PROCESS_NAME ASC
	</cfquery>
</cfif>