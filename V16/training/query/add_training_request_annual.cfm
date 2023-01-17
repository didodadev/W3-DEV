<!--- <cfquery name="get_kontrol" datasource="#dsn#">
	SELECT 
		TRAIN_REQUEST_ID 
	FROM 
		TRAINING_REQUEST 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid# AND
		REQUEST_YEAR = #attributes.period#
</cfquery>
<cfif get_kontrol.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='205.Egitim Talep Edilen D�neme Ait Bir Talep Formunuz Var'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>  --->
<!--- 20121114 YILLIK egitim talebi--->
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="add_request" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			TRAINING_REQUEST
			(
				EMPLOYEE_ID,
				POSITION_CODE,
				REQUEST_TYPE,
				REQUEST_YEAR,
				PROCESS_STAGE,
				FIRST_BOSS_CODE,
				SECOND_BOSS_CODE,
				FOURTH_BOSS_CODE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				#attributes.request_emp_id#,
				#attributes.request_position_code#,
				3,<!--- yillik egitim talebi--->
				#attributes.period#,
				#attributes.process_stage#,
				<cfif len(validator_position_code_1)>#validator_position_code_1#<cfelse>NULL</cfif>,
				<cfif len(validator_position_code_2)>#validator_position_code_2#<cfelse>NULL</cfif>,
				<cfif isdefined('validator_position_code_4' )and len(validator_position_code_4)>#validator_position_code_4#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
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
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						3,<!--- yillik egitim talebi--->
						#attributes.request_emp_id#,
						#wrk_eval('attributes.train_id#r#')#,
						#wrk_eval('attributes.priority#r#')#,
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
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=training.form_upd_training_request&training_request_id=#MAX_ID.IDENTITYCOL#' 
	warning_description = 'Egitim Talebi : #MAX_ID.IDENTITYCOL#'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
