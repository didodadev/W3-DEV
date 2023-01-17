<cfparam name="attributes.warning_mode" default="add_comment">
<!---- 
	Yorum ekleme ve süreç aşaması değiştirme parametreye bağlandı!
	Yorum eklemek için warning_mode değeri 'add_comment' gönderilir.
	Popuptan Yorum eklemek için warning_mode değeri 'add_comment_from_popup' gönderilir.
	Süreç aşaması değiştirmek için warning_mode değeri 'change_process_stage' gönderilir.
--->
<cfif attributes.warning_mode eq 'add_comment'>

	<cfparam name="attributes.TO_POS_CODES" default="">
	<cfset POSITION_CODE = ( len(attributes.TO_POS_CODES) ) ? attributes.TO_POS_CODES : session.ep.position_code>
	<cfloop from="1" to="#listlen(POSITION_CODE)#" index="i">
		<cfif ListGetAt(POSITION_CODE,i) neq session.ep.position_code>
			<cfquery name="getUser" datasource="#dsn#">
				SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(POSITION_CODE,i)#">
			</cfquery>
			<cfif getUser.recordCount>
				<cfset newFuseaction = ReplaceNoCase(ListFirst(ListLast( attributes.url_link, "?"),"&"),"fuseaction=","")>
				<cfquery name="ADD_MESSAGE" datasource="#dsn#">
					INSERT INTO
						WRK_MESSAGE
						(
							RECEIVER_ID,
							RECEIVER_TYPE,
							SENDER_ID,
							SENDER_TYPE,
							MESSAGE,
							IS_CHAT,
							SEND_DATE,
							WARNING_HEAD,
							ACTION_ID,
							ACTION_COLUMN,
							WARNING_PARENT_ID,
							ACTION_PAGE,
							FUSEACTION
						)
						VALUES(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#getUser.EMPLOYEE_ID#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.warning_response#">,
							0,
							#NOW()#,
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.warning_head#">,
							<cfif IsDefined("attributes.action_id") and len(attributes.action_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"><cfelse>NULL</cfif>,
							<cfif IsDefined("attributes.action_column") and len(attributes.action_column)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.action_column#"><cfelse>NULL</cfif>,
							<cfif IsDefined("attributes.parent_id") and len(attributes.parent_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parent_id#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.url_link#">,
							<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#newFuseaction#">
						)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>

<cfelseif attributes.warning_mode eq 'change_process_stage'>
	<cfset getWorkcubeProcess = createObject("component","Customtags.cfc.get_workcube_process")>
	<cfset getActionInfo = createObject("component","cfc.getActionInfo")>

	<cfset actionInfo = getActionInfo.get(action_table:attributes.action_table)>

	<!--- Belgenin aşamasını değiştirir ---->
	<cfset changeAction = getWorkcubeProcess.changeAction(
		process_db: "#actionInfo.action_db#.",
		data_source: dsn,
		actionTable: UCase(attributes.action_table),
		actionStageColumn: UCase(actionInfo.action_stage_column),
		actionIdColumn: UCase(attributes.action_column),
		actionId: attributes.action_id,
		process_stage: attributes.process_stage
	)/>
	
	<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='#attributes.action_table#'
	action_column='#attributes.action_column#'
	action_id='#attributes.action_id#' 
	action_page='#request.self#?fuseaction=#attributes.fusact#&event=upd&#attributes.action_column#=#attributes.action_id#' 
	warning_description='#attributes.warning_description# : #attributes.action_id#'
	position_code='#attributes.position_code#'
	>

<cfelseif attributes.warning_mode eq 'add_comment_from_popup'>

	<cfquery name="GET_RESPONSE_ID" datasource="#dsn#">
		SELECT 
			RESPONSE_ID,
			OUR_COMPANY_ID,
			PERIOD_ID,
			ACTION_TABLE,
			ACTION_COLUMN,
			ACTION_STAGE_ID,
			ACTION_ID
		FROM 
			PAGE_WARNINGS 
		WHERE
			W_ID = #attributes.last_warning_id#
	</cfquery>

	<cfif GET_RESPONSE_ID.recordCount>
		<cftry>
			<cfquery name="add_warning" datasource="#dsn#">
				INSERT INTO
					PAGE_WARNINGS
					(
						URL_LINK,
						WARNING_HEAD,
						SETUP_WARNING_ID,
						WARNING_RESULT,
						WARNING_DESCRIPTION,
						LAST_RESPONSE_DATE,
						RECORD_DATE,
						IS_ACTIVE,
						IS_PARENT,
						RESPONSE_ID,
						PARENT_ID,
						RECORD_IP,
						RECORD_EMP,
						POSITION_CODE,
						OUR_COMPANY_ID,
						PERIOD_ID,
						ACTION_TABLE,
						ACTION_COLUMN,
						ACTION_STAGE_ID,
						ACTION_ID,
						IS_AGENDA
					)
				VALUES
					(
						'#attributes.url_link#',
						'#attributes.warning_head#',
						<cfif len(attributes.setup_warning_id)>#attributes.setup_warning_id#,<cfelse>NULL,</cfif>
						'#attributes.warning_result#',
						'#attributes.warning_response#',
						#CreateODBCDateTime(attributes.response_date)#,
						#NOW()#,
						1,
						0,
						<cfif isdefined('res_id') and len(res_id)>#res_id#<cfelse>NULL</cfif>,
						#attributes.parent_id#,
						'#CGI.REMOTE_ADDR#',
						#SESSION.EP.USERID#,
						<cfif isDefined("attributes.position_code") and isDefined("attributes.employee") and len(attributes.employee) and len(attributes.position_code)>#attributes.position_code#<cfelse>NULL</cfif>,
						<cfif len(GET_RESPONSE_ID.OUR_COMPANY_ID)>#GET_RESPONSE_ID.OUR_COMPANY_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_RESPONSE_ID.PERIOD_ID)>#GET_RESPONSE_ID.PERIOD_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_RESPONSE_ID.ACTION_TABLE)>'#GET_RESPONSE_ID.ACTION_TABLE#'<cfelse>NULL</cfif>,
						<cfif len(GET_RESPONSE_ID.ACTION_COLUMN)>'#GET_RESPONSE_ID.ACTION_COLUMN#'<cfelse>NULL</cfif>,
						<cfif len(GET_RESPONSE_ID.ACTION_STAGE_ID)>#GET_RESPONSE_ID.ACTION_STAGE_ID#<cfelse>NULL</cfif>,
						<cfif len(GET_RESPONSE_ID.ACTION_ID)>#GET_RESPONSE_ID.ACTION_ID#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.is_agenda') and attributes.is_agenda eq 1>1<cfelse>0</cfif>
					)
			</cfquery>
			<cfcatch>
				<script>
					alert("<cf_get_lang dictionary_id='52126.Bir Hata Oluştu'>");
				</script>
			</cfcatch>
		</cftry>
	<cfelse>
		<script>
			alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>");
		</script>
	</cfif>
	<cfset warning_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.warning_id,accountKey:'wrk')>
	<cfset sub_warning_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.sub_warning_id,accountKey:'wrk')>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=#warning_id#&warning_is_active=0&style=0&sub_warning_id=#sub_warning_id#</cfoutput>';
	</script>	

</cfif>