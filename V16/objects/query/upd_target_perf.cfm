<cfquery name="UPD_TARGET_PERF" datasource="#dsn#">
	UPDATE
		TARGET
	SET
		PERFORM_COMMENT = '#attributes.PERFORM_COMMENT#',
		<cfif IsDefined("attributes.PERFORM_POINT_ID")>
		PERFORM_POINT_ID = #attributes.PERFORM_POINT_ID#,
		</cfif>
		PERFORM_REC_EMP = #Session.ep.userid#,
		PERFORM_REC_DATE = #now()#
	WHERE
		TARGET_ID = #attributes.TARGET_ID#
</cfquery>

<cfquery name="ADD_TARGET_HISTORY" datasource="#dsn#">
	INSERT INTO 
		TARGET_PERFORMANCE_HISTORY
	(
		TARGET_ID,
		PERFORM_COMMENT,
		<cfif IsDefined("attributes.PERFORM_POINT_ID")>
			PERFORM_POINT_ID,
		</cfif>
		PERFORM_REC_EMP,
		PERFORM_REC_DATE
	)
	VALUES
	(
		#attributes.TARGET_ID#,
		'#attributes.PERFORM_COMMENT#',
		<cfif IsDefined("attributes.PERFORM_POINT_ID")>
			#attributes.PERFORM_POINT_ID#,
		</cfif>
		#Session.ep.userid#,
		#now()#
	)
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
