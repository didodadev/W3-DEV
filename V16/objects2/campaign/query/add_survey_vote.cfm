<cfquery name="ADD_SURVEY_VOTE" datasource="#dsn#">
	INSERT INTO
		SURVEY_VOTES
		(
		SURVEY_ID,
		PAR_ID,
		GUEST,
		VOTES,
		RECORD_IP
		)
	VALUES
		(
		#SURVEY_ID#,
		#SESSION.PP.USERID#,
		0,
		',#ANSWER#,',
		'#CGI.REMOTE_ADDR#'
		)
</cfquery>

<cfloop list="#answer#" index="i">
	<cfquery name="UPD_VOTE" datasource="#dsn#">
		UPDATE
			SURVEY_ALTS
		SET
			VOTE_COUNT = VOTE_COUNT+1
		WHERE
			ALT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
	</cfquery>
</cfloop>
