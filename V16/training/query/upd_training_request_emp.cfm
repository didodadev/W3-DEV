<!--- SG20121113 eğitim talebi ekle katalog ve katalog dışı eğitimler için --->
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="upd_request" datasource="#dsn#">
		UPDATE
			TRAINING_REQUEST
		SET
			PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
			<cfif isdefined('attributes.start_date')>START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">,</cfif>
			<cfif isdefined('attributes.finish_date')>FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">,</cfif>
			REQUEST_TYPE = <cfif isdefined("attributes.is_check")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_check#">,</cfif>
			<cfif isdefined("attributes.purpose")>PURPOSE = <cfif len(attributes.purpose)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purpose#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.detail")>DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.total_hour")>TOTAL_HOUR = <cfif len(attributes.total_hour)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.total_hour#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.training_cost")>TRAINING_COST = <cfif len(attributes.training_cost)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.training_cost#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.trainer")>TRAINER = <cfif len(attributes.trainer)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.trainer#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.training_place")>TRAINING_PLACE = <cfif len(attributes.training_place)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.training_place#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.validator_position_code_1")>FIRST_BOSS_CODE = <cfif len(validator_position_code_1)><cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_1#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.validator_position_code_2")>SECOND_BOSS_CODE = <cfif len(validator_position_code_2)><cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_2#"><cfelse>NULL</cfif>,</cfif>
            <cfif isdefined("attributes.validator_position_code_4")>FOURTH_BOSS_CODE = <cfif len(validator_position_code_4)><cfqueryparam cfsqltype="cf_sql_integer" value="#validator_position_code_4#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.first_boss_detail")>FIRST_BOSS_DETAIL = <cfif len(attributes.first_boss_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.first_boss_detail#"><cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.second_boss_detail")>SECOND_BOSS_DETAIL = <cfif len(attributes.second_boss_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.second_boss_detail#"><cfelse>NULL</cfif>,</cfif>
            <cfif isdefined("attributes.third_boss_detail")>THIRD_BOSS_DETAIL = <cfif len(attributes.third_boss_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.third_boss_detail#"><cfelse>NULL</cfif>,</cfif>
            <cfif isdefined("attributes.fourth_boss_detail")>FOURTH_BOSS_DETAIL = <cfif len(attributes.fourth_boss_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fourth_boss_detail#"><cfelse>NULL</cfif>,</cfif>
			TRAINING_MONEY = <cfif len(attributes.training_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.training_money#"><cfelse>NULL</cfif>,
			UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			TRAIN_REQUEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_req_id#">
	</cfquery>
	<cfquery name="delete_request_row" datasource="#dsn#">
		DELETE FROM TRAINING_REQUEST_ROWS WHERE TRAIN_REQUEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_req_id#">
	</cfquery>
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
						IS_VALID,
						IS_VALID2,
						IS_VALID3,
						IS_VALID4,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_req_id#">,
						<cfif isdefined("attributes.is_check")><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_check#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#wrk_eval('attributes.participant_emp_id_#r#')#">,
						<cfif isdefined("attributes.is_check") and attributes.is_check eq 1><!--- Katalog egitimi ise--->
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">,
						<cfelseif isdefined("attributes.is_check") and attributes.is_check eq 2><!--- Katalog dısı egitim ise--->
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#other_train_name#">,					
						</cfif>
						<cfif isdefined('attributes.is_valid_#r#')><cfqueryparam cfsqltype="cf_sql_bit" value="#wrk_eval('attributes.is_valid_#r#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.is_valid2_#r#')><cfqueryparam cfsqltype="cf_sql_bit" value="#wrk_eval('attributes.is_valid2_#r#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.is_valid3_#r#')><cfqueryparam cfsqltype="cf_sql_bit" value="#wrk_eval('attributes.is_valid3_#r#')#"><cfelse>NULL</cfif>,
						<cfif isdefined('attributes.is_valid4_#r#')><cfqueryparam cfsqltype="cf_sql_bit" value="#wrk_eval('attributes.is_valid4_#r#')#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
			</cfquery>
		</cfif>
	</cfloop>
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
	action_id='#attributes.train_req_id#'
	action_page='#request.self#?fuseaction=myhome.list_my_tranings&event=upd&train_req_id=#attributes.train_req_id#' 
	warning_description = 'Eğitim Talebi : #attributes.train_req_id#'>
	<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
		<cfset attributes.train_req_id = contentEncryptingandDecodingAES(isEncode:1,content:attributes.train_req_id,accountKey:session.ep.userid)>
	</cfif>
<script type="text/javascript">
    window.location.href = "<cfoutput>#request.self#?fuseaction=myhome.list_my_tranings&event=upd&train_req_id=#attributes.train_req_id#</cfoutput>";   
</script>

