<cfquery name="GET_CONTROL" datasource="#dsn#">
	SELECT 
		TRAIN_REQUEST_ID 
	FROM 
		TRAINING_REQUEST 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid# AND
		REQUEST_YEAR = #attributes.request_year# AND
		TRAIN_REQUEST_ID <> #attributes.train_req_id#
</cfquery>
<cfif get_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='205.Eğitim Talep Edilen Döneme Ait Bir Talep Formunuz Var'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cflock name="#CREATEUUID()#" timeout="30">
	<cftransaction>
		<cfquery name="ADD_TRAINING_REQUESTS" datasource="#dsn#">
			UPDATE 
				TRAINING_REQUEST
			SET
				UPDATE_DATE=#now()#,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP='#REMOTE_ADDR#'
			WHERE 
				TRAIN_REQUEST_ID=#attributes.train_req_id#
		</cfquery>
		<cfquery name="del_row" datasource="#dsn#">
			DELETE FROM TRAINING_REQUEST_ROWS WHERE TRAIN_REQUEST_ID=#attributes.train_req_id#
		</cfquery>
		<cfloop from="1" to="#attributes.record_num_pos_req#" index="i">
			<cfif isdefined("attributes.row_kontrol_pos_req#i#") and evaluate("attributes.row_kontrol_pos_req#i#") eq 1 and len(evaluate("attributes.class_name_pos_req#i#"))>
				<cfquery name="ADD_TRAINING_ROW_POS_REQ" datasource="#dsn#">
					INSERT INTO
						TRAINING_REQUEST_ROWS
						(
							EMPLOYEE_ID,
							TRAIN_REQUEST_ID,
							<!---REQUEST_TYPE,--->
							REQUEST_STATUS,
							TRAINING_ID,
							<!---CONTENT_ID,--->
							TRAINING_PRIORITY,
							WORK_TARGET_ADDITION,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
					VALUES
						(
							#session.ep.userid#,
							#attributes.train_req_id#,
							<!---3,--->
							1,
							#evaluate('attributes.class_id_pos_req#i#')#,
							'#wrk_eval('attributes.priority_pos_req#i#')#',
							'#wrk_eval('attributes.work_addition_pos_req#i#')#',
							#now()#,
							#session.ep.userid#,
							'#REMOTE_ADDR#'
						)
				</cfquery>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=training.form_upd_class_request&train_req_id=#attributes.train_req_id#" addtoken="no">
