<!--- SG20121113 eğitim talebi ekle katalog ve katalog dışı eğitimler için --->
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="add_request" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			TRAINING_REQUEST
			(
				EMPLOYEE_ID,
				POSITION_CODE,
				PROCESS_STAGE,
				START_DATE,
				FINISH_DATE,
				REQUEST_TYPE,
				PURPOSE,
				DETAIL,
				TOTAL_HOUR,
				TRAINING_COST,
				TRAINER,
				TRAINING_PLACE,
				FIRST_BOSS_CODE,
				SECOND_BOSS_CODE,
				FOURTH_BOSS_CODE,
				TRAINING_MONEY,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
		VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_emp_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_position_code#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">,
				<cfif isdefined("attributes.is_check")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_check#"><cfelse>NULL</cfif>,
				<cfif len(attributes.purpose)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purpose#"><cfelse>NULL</cfif>,
				<cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
				<cfif len(attributes.total_hour)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.total_hour#"><cfelse>NULL</cfif>,
				<cfif len(attributes.training_cost)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.training_cost#"><cfelse>NULL</cfif>,
				<cfif len(attributes.trainer)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.trainer#"><cfelse>NULL</cfif>,
				<cfif len(attributes.training_place)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.training_place#"><cfelse>NULL</cfif>,
				<cfif isdefined("validator_position_code_1") and len(validator_position_code_1)><cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_1#"><cfelse>NULL</cfif>,
				<cfif isdefined("validator_position_code_2") and len(validator_position_code_2)><cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_2#"><cfelse>NULL</cfif>,
				<cfif isdefined('validator_position_code_4') and len(validator_position_code_4)><cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_4#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.training_money') and len(attributes.training_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.training_money#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
	</cfquery>
	<cfif isdefined("attributes.add_row_info") and len(attributes.add_row_info)>
	<cfloop from="1" to="#attributes.add_row_info#" index="r">
		<cfif isdefined('attributes.del_row_info#r#') and  evaluate('attributes.del_row_info#r#') eq 1 and len(evaluate('attributes.participant_emp_id_#r#')) and len(evaluate('attributes.participant_emp_name_#r#'))><!--- silinmemiş ise.. --->
			<cfquery name="add_row" datasource="#dsn#">
				INSERT INTO
					TRAINING_REQUEST_ROWS
					(
						TRAIN_REQUEST_ID,
						REQUEST_TYPE,
						EMPLOYEE_ID,
						<cfif isdefined("attributes.is_check") and attributes.is_check eq 1><!--- Katalog egitimi ise--->
							TRAINING_ID,
						<cfelseif isdefined("attributes.is_check") and attributes.is_check eq 2><!--- Katalog dısı egitim ise--->
							OTHER_TRAIN_NAME,
						</cfif>
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#max_id.identitycol#">,
						<cfif isdefined("attributes.is_check")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_check#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#wrk_eval('attributes.participant_emp_id_#r#')#">,
						<cfif isdefined("attributes.is_check") and attributes.is_check eq 1><!--- Katalog egitimi ise--->
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">,
						<cfelseif isdefined("attributes.is_check") and attributes.is_check eq 2><!--- Katalog dısı egitim ise--->
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#other_train_name#">,					
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
			</cfquery>
		</cfif>
	</cfloop>
	</cfif>
	</cftransaction>
</cflock>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='TRAINING_REQUEST'
	action_column='TRAIN_REQUEST_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=training.popup_form_upd_training_request&train_req_id=#max_id.identitycol#' 
	warning_description = 'Eğitim Talebi : #max_id.identitycol#'>
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
	<cfset MAX_ID.IDENTITYCOL = contentEncryptingandDecodingAES(isEncode:1,content:max_id.identitycol,accountKey:session.ep.userid)>
</cfif>
<script type="text/javascript">
	 window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_my_tranings&event=upd&train_req_id=#MAX_ID.IDENTITYCOL#</cfoutput>";   
</script>
