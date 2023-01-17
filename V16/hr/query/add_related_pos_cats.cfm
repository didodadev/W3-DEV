<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery datasource="#dsn#" name="get_max_step_no">
			SELECT
				MAX(STEP_NO) AS MAX_ID
			FROM
				EMPLOYEE_CAREER
			WHERE
				POSITION_CAT_ID=#attributes.pcat_id#
				AND STATE=<cfif is_ust eq 1>1<cfelse>0</cfif>
		</cfquery>
		<cfquery datasource="#dsn#" name="add_related_pos_cat">
			INSERT INTO
				EMPLOYEE_CAREER
					(
					POSITION_CAT_ID,
					RELATED_POS_CAT_ID,
					STATE,
					STEP_NO 
					)
				VALUES
					(
					#attributes.pcat_id#,
					#attributes.rel_pos_id#,
					<cfif is_ust eq 1>1,<cfelse>0,</cfif>
					<cfif (get_max_step_no.recordcount) and len(get_max_step_no.MAX_ID)>#get_max_step_no.MAX_ID+1#<cfelse>1</cfif>
					)
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
	<cfif isDefined('attributes.modal_id')>
		closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_add_employee_career&position_cat_id=#attributes.pcat_id#','#attributes.modal_id#</cfoutput>');
	<cfelse>
	wrk_opener_reload();
	window.close();
	</cfif>
</script>
