<cfquery name="upd_class_req" datasource="#dsn#">
	UPDATE 
		TRAINING_REQUEST 
	SET
	<cfif len(attributes.amir_id_1) and len(attributes.amir_code_1) and len(attributes.amir_name_1)>
		FIRST_BOSS_ID=#attributes.amir_id_1#,
		FIRST_BOSS_CODE=#attributes.amir_code_1#,
	</cfif>
	<cfif len(attributes.amir_id_2) and len(attributes.amir_code_2) and len(attributes.amir_name_2)>
		SECOND_BOSS_ID = #attributes.amir_id_2#,
		SECOND_BOSS_CODE = #attributes.amir_code_2#,
	<cfelse>
		SECOND_BOSS_ID = NULL,
		SECOND_BOSS_CODE = NULL,
	</cfif>
	<cfif len(attributes.amir_id_3) and len(attributes.amir_code_3) and len(attributes.amir_name_3)>
		THIRD_BOSS_ID = #attributes.amir_id_3#,
		THIRD_BOSS_CODE = #attributes.amir_code_3#,
	<cfelse>
		THIRD_BOSS_ID = NULL,
		THIRD_BOSS_CODE = NULL,
	</cfif>
	<cfif len(attributes.amir_id_4) and len(attributes.amir_code_4) and len(attributes.amir_name_4)>
		FOURTH_BOSS_ID = #attributes.amir_id_4#,
		FOURTH_BOSS_CODE = #attributes.amir_code_4#,
	<cfelse>
		FOURTH_BOSS_ID = NULL,
		FOURTH_BOSS_CODE = NULL,
	</cfif>
	<cfif len(attributes.amir_id_5) and len(attributes.amir_code_5) and len(attributes.amir_name_5)>
		FIFTH_BOSS_ID = #attributes.amir_id_5#,
		FIFTH_BOSS_CODE = #attributes.amir_code_5#,
	<cfelse>
		FIFTH_BOSS_ID = NULL,
		FIFTH_BOSS_CODE = NULL,
	</cfif>
		FIRST_BOSS_VALID=NULL,
		FIRST_BOSS_VALID_DATE=NULL,
		SECOND_BOSS_VALID=NULL,
		SECOND_BOSS_VALID_DATE=NULL,
		THIRD_BOSS_VALID=NULL,
		THIRD_BOSS_VALID_DATE=NULL,
		FOURTH_BOSS_VALID=NULL,
		FOURTH_BOSS_VALID_DATE=NULL,
		FIFTH_BOSS_VALID=NULL,
		FIFTH_BOSS_VALID_DATE=NULL,
		FORM_VALID=0,	

		UPDATE_DATE = #now()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #session.ep.userid#
	WHERE
		TRAIN_REQUEST_ID=#attributes.train_req_id#
</cfquery>

<cfquery name="upd_class_req_row" datasource="#dsn#">
	UPDATE 
		TRAINING_REQUEST_ROWS
	SET
		FIRST_BOSS_VALID_ROW=NULL,
		FIRST_BOSS_DATE_ROW=NULL,
		FIRST_BOSS_DETAIL_ROW=NULL,
		SECOND_BOSS_VALID_ROW=NULL,
		SECOND_BOSS_DATE_ROW=NULL,
		SECOND_BOSS_DETAIL_ROW=NULL,		
		THIRD_BOSS_VALID_ROW=NULL,
		THIRD_BOSS_DATE_ROW=NULL,
		THIRD_BOSS_DETAIL_ROW=NULL,	
		FOURTH_BOSS_VALID_ROW=NULL,
		FOURTH_BOSS_DATE_ROW=NULL,
		FOURTH_BOSS_DETAIL_ROW=NULL,	
		FIFTH_BOSS_VALID_ROW=NULL,
		FIFTH_BOSS_DATE_ROW=NULL,		
		FIFTH_BOSS_DETAIL_ROW=NULL,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #session.ep.userid#
	WHERE
		TRAIN_REQUEST_ID=#attributes.train_req_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

