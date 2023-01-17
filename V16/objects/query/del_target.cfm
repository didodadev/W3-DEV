<cflock timeout="60">
	<cftransaction>
	<cfquery name="DEL_TARGET" datasource="#dsn#">
		DELETE FROM TARGET WHERE TARGET_ID=#attributes.TARGET_ID#
	</cfquery>
	<!--- hedef yetkinlik formundan gelen silme icin--->
	<cfif isdefined('attributes.per_id') and len(attributes.per_id)>
		<cfquery name="upd_perform" datasource="#dsn#">
			UPDATE
				EMPLOYEE_PERFORMANCE_TARGET
			SET
				FIRST_BOSS_VALID_FORM = NULL,
				FIRST_BOSS_VALID_DATE_FORM = NULL,
				SECOND_BOSS_VALID_FORM = NULL,
				SECOND_BOSS_VALID_DATE_FORM =NULL,
				THIRD_BOSS_VALID_FORM =NULL,
				THIRD_BOSS_VALID_DATE_FORM =NULL,
				FOURTH_BOSS_VALID_FORM =NULL,
				FOURTH_BOSS_VALID_DATE_FORM =NULL,
				FIFTH_BOSS_VALID_FORM =NULL,
				FIFTH_BOSS_VALID_DATE_FORM =NULL,
				UPDATE_EMP = '#SESSION.EP.USERID#',
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_DATE = #now()#
			WHERE
				PER_ID = #attributes.per_id#
		</cfquery>
	</cfif>
	<!--- //hedef yetkinlik formundan gelen silme icin--->
	<cf_add_log  log_type="-1" action_id="#attributes.target_id#" action_name="#attributes.head#"  process_type="#attributes.cat#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href=<cfoutput>"#request.self#?fuseaction=hr.targets" </cfoutput>
</script>

