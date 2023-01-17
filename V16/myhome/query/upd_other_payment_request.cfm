
<cfquery name="UPD_REQUEST" datasource="#DSN#">
	UPDATE
		SALARYPARAM_GET_REQUESTS
	SET
		AMOUNT_GET = #filterNum(attributes.amount_get)#,		
		TAKSIT_NUMBER = #attributes.taksit#,
		DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP =#SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		VALIDATOR_POSITION_CODE_1 = <cfif len(attributes.validator_pos_code)>#attributes.validator_pos_code#<cfelse>NULL</cfif>,
		VALIDATOR_POSITION_CODE_2 = <cfif len(attributes.validator_pos_code2)>#attributes.validator_pos_code2#<cfelse>NULL</cfif>
	WHERE
		SPGR_ID=#attributes.id#
</cfquery>
<cfif not isdefined("attributes.draggable")>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.href = document.referrer;
	</script>
</cfif>