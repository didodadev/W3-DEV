<!--- anket formunun ilgili kayıt ile ilişkisini kaldırır SG 20120803--->
<!--- <cfquery name="get_control" datasource="#dsn#" maxrows="1">
	SELECT SURVEY_MAIN_ID FROM SURVEY_MAIN_RESULT WHERE SURVEY_MAIN_ID = #attributes.survey_id# AND ACTION_TYPE = #attributes.action_type# AND ACTION_ID = #attributes.action_type_id#
</cfquery>
<cfif get_control.recordcount>
	<script type="text/javascript">
		{
			alert("<cf_get_lang no='285.Bu forma katılan kullanıcı olduğu için silinemez'>!");
			window.close();
		}
	</script>
<cfelse> --->
	<cfif attributes.isContentDelete>
		<cfquery name="del_content_relation" datasource="#dsn#">
			DELETE FROM CONTENT_RELATION WHERE SURVEY_MAIN_ID = #attributes.survey_id# AND RELATION_TYPE = #attributes.action_type# AND RELATION_CAT = #attributes.action_type_id#
		</cfquery>
	<cfelse>
		<cfquery name="close_survey_result" datasource="#dsn#">
			UPDATE SURVEY_MAIN_RESULT SET IS_CLOSED = 1 WHERE SURVEY_MAIN_RESULT_ID = #attributes.SURVEY_MAIN_RESULT_ID#
		</cfquery>
	</cfif>
	<script type="text/javascript">
	  wrk_opener_reload();
	  window.close();
	</script>	
<!--- </cfif> --->
