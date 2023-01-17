<cfquery name="CHECK_RELATED_TRAIN" datasource="#dsn#">
	SELECT
		TRAINING_ID
	FROM
		TRAINING_RELATED
	WHERE
		TRAINING_ID = #attributes.TRAINING_ID# AND 
		RELATED_TRAINING_ID = #attributes.related_id#
</cfquery>
<cfif not CHECK_RELATED_TRAIN.recordcount>
	<cfquery name="ADD_RELATED_TRAIN" datasource="#dsn#">
	INSERT INTO 
		TRAINING_RELATED
		(
			TRAINING_ID,
			RELATED_TRAINING_ID
		)
		VALUES
		(
			#attributes.TRAINING_ID#,
			#attributes.related_id#
		)
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='520.Bu Konu Zaten İlişkili'>!");
		window.history.go(-1);
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
<cfabort>
