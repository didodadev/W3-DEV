<cfquery name="get_banks" datasource="#dsn#">
	SELECT 
		BANK_ID 
	FROM 
		OUR_COMPANY_BANK_RELATION 
	WHERE 
		BANK_ID = #attributes.bank_id# AND 
		OUR_COMPANY_ID = #attributes.our_company#
		<cfif len(attributes.our_branch_id)>
			AND BRANCH_ID = #attributes.our_branch_id# 
		<cfelse>
			AND BRANCH_ID IS NULL 
		</cfif>
</cfquery>
<cfif get_banks.recordcount>
	<script type="text/javascript">
		alert("Banka Seçili Birimle Eşleştirilmiş! Başka Birim Seçmelisiniz!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="ADD_RELATION" datasource="#dsn#">
	INSERT INTO
		OUR_COMPANY_BANK_RELATION
		(
			BANK_ID,
			OUR_COMPANY_ID,
			<cfif len(attributes.our_branch_id)>BRANCH_ID,</cfif>
			RELATION_NUMBER,
			BANK_ACCOUNT_CODE,
			BANK_BRANCH_CODE,
			BANK_USER_CODE,
			IBAN_NO,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
			
		)
		VALUES
		(
			#attributes.bank_id#,
			#attributes.our_company#,
			<cfif len(attributes.our_branch_id)>#attributes.our_branch_id#,</cfif>
			'#attributes.relation_number#',
			'#attributes.bank_account_code#',
			'#attributes.bank_branch_code#',
			'#attributes.bank_user_code#',
			'#attributes.IBAN_NO#',
			#session.ep.userid#,
			#now()#,
			'#CGI.REMOTE_ADDR#'
		)
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.draggable")>location.href = document.referrer;<cfelse>	wrk_opener_reload();window.close();</cfif>

</script>
