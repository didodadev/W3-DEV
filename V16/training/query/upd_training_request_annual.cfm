<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="upd_request" datasource="#dsn#">
		UPDATE
			TRAINING_REQUEST
		SET
			PROCESS_STAGE = #attributes.process_stage#,
			<cfif isdefined("attributes.period")>REQUEST_YEAR = #attributes.period#,</cfif>
			<cfif isdefined("attributes.validator_position_code_1")>FIRST_BOSS_CODE = <cfif len(validator_position_code_1)>#validator_position_code_1#<cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.validator_position_code_2")>SECOND_BOSS_CODE = <cfif len(validator_position_code_2)>#validator_position_code_2#<cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.first_boss_detail")>FIRST_BOSS_DETAIL = <cfif len(attributes.first_boss_detail)>'#attributes.first_boss_detail#'<cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.second_boss_detail")>SECOND_BOSS_DETAIL = <cfif len(attributes.second_boss_detail)>'#attributes.second_boss_detail#'<cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.third_boss_detail")>THIRD_BOSS_DETAIL = <cfif len(attributes.third_boss_detail)>'#attributes.third_boss_detail#'<cfelse>NULL</cfif>,</cfif>
			<cfif isdefined("attributes.fourth_boss_detail")>FOURTH_BOSS_DETAIL = <cfif len(attributes.fourth_boss_detail)>'#attributes.fourth_boss_detail#'<cfelse>NULL</cfif>,</cfif>
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			TRAIN_REQUEST_ID = #attributes.train_req_id#
	</cfquery>
	<cfquery name="delete_request_row" datasource="#dsn#">
		DELETE FROM TRAINING_REQUEST_ROWS WHERE TRAIN_REQUEST_ID = #attributes.train_req_id#
	</cfquery>
	<cfloop from="1" to="#attributes.add_row_info#" index="r">
		<cfif isdefined('attributes.del_row_info#r#') and  evaluate('attributes.del_row_info#r#') eq 1 and len(evaluate('attributes.train_id#r#')) and len(evaluate('attributes.train_head#r#'))><!--- silinmemis ise.. --->
			<cfquery name="add_row" datasource="#dsn#">
				INSERT INTO
					TRAINING_REQUEST_ROWS
					(
						TRAIN_REQUEST_ID,
						REQUEST_TYPE,
						EMPLOYEE_ID,
						TRAINING_ID,
						TRAINING_PRIORITY,
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
						#attributes.train_req_id#,
						3,<!--- yillik egitim talebi--->
						#attributes.request_emp_id#,
						#wrk_eval('attributes.train_id#r#')#,
						#wrk_eval('attributes.priority#r#')#,
						<cfif isdefined('attributes.is_valid_#r#')>
							#wrk_eval('attributes.is_valid_#r#')#,
						<cfelse>
						NULL,
						</cfif>
						<cfif isdefined('attributes.is_valid2_#r#')>
							#wrk_eval('attributes.is_valid2_#r#')#,
						<cfelse>
						NULL,
						</cfif>
						<cfif isdefined('attributes.is_valid3_#r#')>
							#wrk_eval('attributes.is_valid3_#r#')#,
						<cfelse>
						NULL,
						</cfif>
						<cfif isdefined('attributes.is_valid4_#r#')>
							#wrk_eval('attributes.is_valid4_#r#')#,
						<cfelse>
						NULL,
						</cfif>
						#now()#,
						#session.ep.userid#,
						'#cgi.REMOTE_ADDR#'
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
	action_page='#request.self#?fuseaction=training.popup_form_upd_training_request_annual&training_request_id=#attributes.train_req_id#' 
	warning_description = 'Eğitim Talebi : #attributes.train_req_id#'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
