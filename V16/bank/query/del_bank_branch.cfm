<cfif fusebox.use_period>
	<cfset dsn_branch = dsn3>
	<cfquery name="CONTROL_ACCOUNT" datasource="#dsn_branch#">
		SELECT ACCOUNT_BRANCH_ID FROM ACCOUNTS WHERE ACCOUNT_BRANCH_ID = #attributes.ID#
	</cfquery>
	<cfif CONTROL_ACCOUNT.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='409.İlişkili Hesap Bulunduğundan Dolayı Şubeyi Silemezsiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfset dsn_branch = dsn>
</cfif>

<cfquery name="DEL_BRANCH" datasource="#dsn_branch#">
	DELETE	FROM 
		BANK_BRANCH
	WHERE
		BANK_BRANCH_ID=#attributes.ID#
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.branch#">
<cfquery name="GET_MAXID" datasource="#dsn_branch#">
	SELECT MAX(BANK_BRANCH_ID) AS MAX_ID FROM BANK_BRANCH
</cfquery>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=#listFirst(attributes.fuseaction,".")#.list_bank_branch</cfoutput>';
</script>
