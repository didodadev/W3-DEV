<cfabort>
<CFTRANSACTION>
	<cfquery name="ADD_ANALYSIS_RESULT" datasource="#dsn#">
		INSERT INTO
			MEMBER_ANALYSIS_RESULTS
			(
			ANALYSIS_ID,
			PARTNER_ID,
			CONSUMER_ID,
			USER_POINT
			)
		VALUES
			(
			#SESSION.ANALYSIS_ID#,
			<cfif attributes.member_type EQ "partner">
			#SESSION.MEMBERID#, 
			NULL,
			<cfelse><!--- consumer --->
			NULL, 
			#SESSION.MEMBERID#,
			</cfif>
			0
			)
	</cfquery>	
	<cfquery name="GET_RESULT_ID" datasource="#dsn#">
		SELECT
			MAX(RESULT_ID) AS MAX_ID
		FROM
			MEMBER_ANALYSIS_RESULTS
		WHERE
			<cfif attributes.member_type EQ "partner">
				PARTNER_ID=#SESSION.memberid#
			<cfelse>
				CONSUMER_ID=#SESSION.memberid#
			</cfif>
			AND
				ANALYSIS_ID = #SESSION.ANALYSIS_ID#
	</cfquery>
</CFTRANSACTION>
<cfset SESSION.RESULT_ID = GET_RESULT_ID.MAX_ID>

