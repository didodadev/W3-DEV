<cftransaction>
<cfquery name="SET_QUESTION_POINT" datasource="#dsn#">
	UPDATE
		MEMBER_ANALYSIS_RESULTS_DETAILS
	SET
		QUESTION_POINT = #attributes.QUESTION_POINT#
	WHERE
		RESULT_DETAIL_ID = #attributes.RESULT_DETAIL_ID#
</cfquery>
<cfif attributes.USER_POINT Eq "">
	<cfset attributes.USER_POINT = 0>
</cfif>
<cfif attributes.question_point_old Eq "">
	<cfset attributes.question_point_old = 0>
</cfif>
<cfif attributes.QUESTION_POINT Eq "">
	<cfset attributes.QUESTION_POINT = 0>
</cfif>
<cfquery name="SET_RESULT_ID" datasource="#dsn#">
	UPDATE
		MEMBER_ANALYSIS_RESULTS
	SET
		USER_POINT = #evaluate(attributes.USER_POINT - attributes.question_point_old + attributes.QUESTION_POINT)#
	WHERE
		RESULT_ID = #attributes.RESULT_ID#
</cfquery>
</cftransaction>
<script type="text/javascript">
	window.opener.make_analysis.<cfoutput>#attributes.puan#</cfoutput>.value=<cfoutput>#attributes.QUESTION_POINT#</cfoutput>;
	window.opener.reloadOpener();
	wrk_opener_reload();
	window.close();
</script>
