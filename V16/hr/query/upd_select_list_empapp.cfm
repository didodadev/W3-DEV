<cfif IsDefined('attributes.del') and attributes.del eq 1>
	<cfif isdefined("attributes.ROW_STATUS") and attributes.ROW_STATUS eq 0>
		<cfquery name="del_empapp" datasource="#dsn#">
			DELETE FROM 
				EMPLOYEES_APP_SEL_LIST_ROWS
			WHERE
				LIST_ID=#attributes.list_id#
			<cfif len(attributes.empapp_id)>
				AND EMPAPP_ID =#attributes.empapp_id#
			</cfif>
			<cfif len(attributes.app_pos_id)>
				AND APP_POS_ID=#attributes.app_pos_id#
			</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="del_empapp" datasource="#dsn#">
			UPDATE
				EMPLOYEES_APP_SEL_LIST_ROWS
			SET
				ROW_STATUS=0,
				UPDATE_DATE=#now()#,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_IP='#cgi.REMOTE_ADDR#'
			WHERE
				LIST_ID=#attributes.list_id#
			<cfif len(attributes.empapp_id)>
				AND EMPAPP_ID =#attributes.empapp_id#
			</cfif>
			<cfif len(attributes.app_pos_id)>
				AND APP_POS_ID=#attributes.app_pos_id#
			</cfif>
		</cfquery>
	</cfif>
<cfelseif IsDefined('attributes.add') and attributes.add eq 1>
	<cfquery name="del_empapp" datasource="#dsn#">
		UPDATE
			EMPLOYEES_APP_SEL_LIST_ROWS
		SET
			ROW_STATUS=1,
			UPDATE_DATE=#now()#,
			UPDATE_EMP=#session.ep.userid#,
			UPDATE_IP='#cgi.REMOTE_ADDR#'
		WHERE
			LIST_ID=#attributes.list_id#
			<cfif len(attributes.empapp_id)>
			AND EMPAPP_ID =#attributes.empapp_id#
			</cfif>
			<cfif len(attributes.app_pos_id)>
			AND APP_POS_ID=#attributes.app_pos_id#
			</cfif>
	</cfquery>
</cfif>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
