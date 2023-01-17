<cfquery name="upd_visit" datasource="#dsn#">
	UPDATE
		EMPLOYEES_SSK_FEE
	SET
	<cfif isDefined("validator_pos_code_1") and len(validator_pos_code_1)>
		VALIDATOR_POS_CODE_1 = #validator_pos_code_1#,
		<cfif isdefined("valid_1") and len(valid_1)>
			VALID_EMP_1 = #SESSION.EP.USERID#,
			VALID_DATE_1 = #NOW()#,
			VALID_1 = #valid_1#, 
		</cfif>
	<cfelseif isDefined("validator_pos_code_2") and len(validator_pos_code_2) >
		VALIDATOR_POS_CODE_2 = #validator_pos_code_2#,
		<cfif isdefined("valid_2") and len(valid_2)>
			VALID_EMP_2 = #SESSION.EP.USERID#,
			VALID_DATE_2 = #NOW()#,
			VALID_2 = #valid_2#, 
		</cfif>
	</cfif>
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#
	WHERE
		FEE_ID = #attributes.FEE_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
