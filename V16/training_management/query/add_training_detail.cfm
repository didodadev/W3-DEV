<cfquery name="get_training_performance" datasource="#dsn#">
	SELECT 
    	* 
    FROM 
    	TRAINING_PERFORMANCE 
    WHERE 
    	CLASS_ID = #attributes.class_id# AND TRAINING_QUIZ_ID = #attributes.quiz_id#
</cfquery>
<cfif get_training_performance.recordcount>
	<cfloop query="get_training_performance">
		<cfquery name="update_training_detail" datasource="#dsn#">
			UPDATE TRAINING_PERFORMANCE SET TRAINING_DETAIL = '#wrk_eval("training_detail_#training_performance_id#")#' WHERE TRAINING_PERFORMANCE_ID = #TRAINING_PERFORMANCE_ID# 
		</cfquery>
	</cfloop>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
