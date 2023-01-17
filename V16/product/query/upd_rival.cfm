<cfquery name="add_rival" datasource="#dsn#">
	UPDATE
		SETUP_RIVALS
	SET
		RIVAL_NAME = '#attributes.rival_name#',
		RIVAL_DETAIL = '#attributes.rival_detail#',
		STATUS = <cfif isdefined("attributes.status")>1,<cfelse>0,</cfif>
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		R_ID = #attributes.rival_id#
</cfquery>
<cfquery name="DEL_BRANCH" datasource="#DSN#">
	DELETE FROM SETUP_RIVALS_BRANCH WHERE R_ID = #attributes.rival_id#
</cfquery>
<cfif len(attributes.record_num) and attributes.record_num neq "">
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#")>
			<cfscript>
				form_branch = evaluate("attributes.branch_id#i#");
			</cfscript>
			<cfquery name="INS_BRANCH" datasource="#DSN#">
				INSERT INTO 
					SETUP_RIVALS_BRANCH 
				(
					R_ID,
					BRANCH_ID
				) 
				VALUES
				(
					#attributes.rival_id#,
					#form_branch#
				)
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>
