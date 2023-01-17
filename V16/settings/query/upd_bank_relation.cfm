<cfquery name="get_banks" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		OUR_COMPANY_BANK_RELATION 
	WHERE 
		BANK_ID = #attributes.bank_id# AND 
		OUR_COMPANY_ID = #attributes.our_company# AND 
		<cfif len(attributes.our_branch_id)>
			BRANCH_ID = #attributes.our_branch_id# AND
		<cfelse>
			BRANCH_ID IS NULL AND
		</cfif>
		RELATION_ID <> #attributes.relation_id#
</cfquery>
<cfif get_banks.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='44526.Bankayı birden fazla kez aynı şirketle şubesiz veya aynı şirketin aynı şubesiyle ilişkilendiremezsiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="UPD_RELATION" datasource="#dsn#">
	UPDATE
		OUR_COMPANY_BANK_RELATION
	SET
		BRANCH_ID = <cfif len(attributes.our_branch_id)>#attributes.our_branch_id#,<cfelse>NULL,</cfif>
		OUR_COMPANY_ID = #attributes.our_company#,
		RELATION_NUMBER = '#attributes.relation_number#',
		BANK_ACCOUNT_CODE = '#attributes.bank_account_code#',
		BANK_BRANCH_CODE = '#attributes.bank_branch_code#',
		BANK_USER_CODE = '#attributes.bank_user_code#',
		IBAN_NO = '#attributes.IBAN_NO#',
		UPDATE_DATE=#NOW()#,
		UPDATE_IP='#CGI.REMOTE_ADDR#',
		UPDATE_EMP=#SESSION.EP.USERID#
	WHERE
		RELATION_ID = #attributes.relation_id#
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>
</script>
