<cfif isdefined("attributes.type")>
	<cfquery name="UPD_REQUEST" datasource="#dsn#">
		UPDATE	
			TRAINING_REQUEST 
		SET
			IS_VALID_VALUE = 0
		WHERE 
			TRAIN_REQUEST_ID = #attributes.train_req_id#
	</cfquery>
	<cfquery name="UPD_ROW" datasource="#dsn#">
		UPDATE 
			TRAINING_REQUEST_ROWS 
		SET
			FIRST_BOSS_VALID_ROW = NULL,
			FIRST_BOSS_DATE_ROW = NULL,
			FIRST_BOSS_DETAIL_ROW = NULL,
			SECOND_BOSS_VALID_ROW = NULL,
			SECOND_BOSS_DATE_ROW = NULL,
			SECOND_BOSS_DETAIL_ROW = NULL,
			THIRD_BOSS_VALID_ROW = NULL,
			THIRD_BOSS_DATE_ROW = NULL,
			THIRD_BOSS_DETAIL_ROW = NULL,
			FOURTH_BOSS_VALID_ROW = NULL,
			FOURTH_BOSS_DATE_ROW = NULL,
			FOURTH_BOSS_DETAIL_ROW = NULL,
			FIFTH_BOSS_VALID_ROW = NULL,
			FIFTH_BOSS_DATE_ROW = NULL,
			FIFTH_BOSS_DETAIL_ROW = NULL
		WHERE 
			TRAIN_REQUEST_ID = #attributes.train_req_id#
	</cfquery>
<cfelse>
	<cfquery name="UPDATE_CLASS" datasource="#dsn#">
		UPDATE
			TRAINING_REQUEST 
		SET
			IS_VALID_VALUE = 1 
		WHERE
			TRAIN_REQUEST_ID = #attributes.train_req_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	window.close();
	wrk_opener_reload();
</script>
