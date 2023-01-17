<cfquery name="GET_PLUS" datasource="#dsn#">
	SELECT 
		STEP_NO,
		RELATED_POS_CAT_ID
	FROM
		EMPLOYEE_CAREER
	WHERE
		POSITION_CAT_ID = #attributes.pcat_id# AND
		STEP_NO > #attributes.step_no#
	ORDER BY 
		RELATED_POS_CAT_ID
</cfquery>
<cfoutput query="GET_PLUS">
	<cfquery name="UPD_PLUS" datasource="#dsn#">
		UPDATE
			EMPLOYEE_CAREER
		SET
			STEP_NO = #get_plus.STEP_NO-1#
		WHERE
			POSITION_CAT_ID = #attributes.pcat_id# AND
			RELATED_POS_CAT_ID = #get_plus.RELATED_POS_CAT_ID#
	</cfquery>
</cfoutput>
<cfquery name="del_related_pos_cat" datasource="#dsn#">
	DELETE 
	FROM
		 EMPLOYEE_CAREER 
	WHERE 
		POSITION_CAT_ID = #attributes.pcat_id#
		AND RELATED_POS_CAT_ID=#attributes.rel_pos_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
