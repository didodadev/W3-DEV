<cfquery name="DEL_CLASS" datasource="#DSN#">
	DELETE
	FROM
		TRAINING_CLASS_SECTIONS
	WHERE
		TRAIN_SECTION_ID=#attributes.TRAIN_SECTION_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
