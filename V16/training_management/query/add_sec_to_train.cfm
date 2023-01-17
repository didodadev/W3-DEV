<cfquery name="GET_CLASS" datasource="#DSN#">
	SELECT
		*
	FROM
		TRAINING_CLASS_SECTIONS
	WHERE
		CLASS_ID = #attributes.CLASS_ID# AND
		TRAINING_SEC_ID = #attributes.SEC_ID# AND
		TRAINING_CAT_ID = #attributes.CAT_ID# AND
		TRAIN_ID = #attributes.TRAIN_ID#
</cfquery>
<cfif NOT GET_CLASS.RECORDCOUNT>
	<cfquery name="add_q" datasource="#DSN#">
		INSERT INTO 
			TRAINING_CLASS_SECTIONS
			(
				CLASS_ID,
				TRAINING_SEC_ID,
				TRAINING_CAT_ID,
				TRAIN_ID     
			)
			VALUES
			(
				#attributes.CLASS_ID#,
				#attributes.SEC_ID#,
				#attributes.CAT_ID#,
				#attributes.TRAIN_ID#
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	window.close();
</script>
