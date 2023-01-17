<cfif not isdefined("attributes.answer")>
	<script type="text/javascript">
		alert("<cf_get_lang no='296.Seçim Yapmadınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<!--- if emp votes --->
<cfif Not IsDefined("attributes.consumer_id") AND Not IsDefined("attributes.partner_id") AND IsDefined("session.ep.userid")>
	<cfif IsDefined("attributes.ANSWER")>
		<cfquery name="GET_SURVEY_VOTE" datasource="#DSN#">
			SELECT
				SURVEY_ID
			FROM
				SURVEY_VOTES
			WHERE
				EMP_ID = #SESSION.EP.USERID# AND
				SURVEY_ID = #SURVEY_ID#
		</cfquery>
		<cfif Not GET_SURVEY_VOTE.RecordCount>
			<cfquery name="ADD_SURVEY_VOTE" datasource="#DSN#">
				INSERT INTO
					SURVEY_VOTES
				(
					SURVEY_ID,
					EMP_ID,
					GUEST,
					VOTES,
					RECORD_IP,
					RECORD_DATE
					)
				VALUES
					(
					#attributes.SURVEY_ID#,
					#SESSION.EP.USERID#,
					0,
					',#attributes.ANSWER#,',
					'#CGI.REMOTE_ADDR#',
					#NOW()#
					)
			</cfquery>
			<cfloop list="#attributes.ANSWER#" index="i">
				<cfquery name="UPD_VOTE" datasource="#DSN#">
					UPDATE
						SURVEY_ALTS
					SET
						VOTE_COUNT = VOTE_COUNT+1
					WHERE
						ALT_ID = #I#
				</cfquery>
			</cfloop>
		</cfif> 
	</cfif>
</cfif>
<!--- if cons votes --->
<cfif IsDefined("attributes.consumer_id")>
	<cfif IsDefined("attributes.ANSWER")>
		<cfquery name="GET_SURVEY_VOTE" datasource="#DSN#">
			SELECT
				SURVEY_ID
			FROM
				SURVEY_VOTES
			WHERE
				CON_ID = #attributes.consumer_id# 
			AND
				SURVEY_ID = #SURVEY_ID#
		</cfquery>
		<cfif Not GET_SURVEY_VOTE.RecordCount>
			<cfquery name="ADD_SURVEY_VOTE" datasource="#DSN#">
				INSERT INTO
					SURVEY_VOTES
					(
					SURVEY_ID,
					CON_ID,
					GUEST,
					VOTES,
					RECORD_IP
					)
				VALUES
					(
					#attributes.SURVEY_ID#,
					#attributes.consumer_id#,
					0,
					',#attributes.ANSWER#,',
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<cfloop list="#attributes.ANSWER#" index="i">
				<cfquery name="UPD_VOTE" datasource="#DSN#">
					UPDATE
						SURVEY_ALTS
					SET
						VOTE_COUNT = VOTE_COUNT+1
					WHERE
						ALT_ID = #I#
				</cfquery>
			</cfloop>
		</cfif> 
	</cfif>
</cfif>
<!--- if partner votes --->
<cfif IsDefined("attributes.partner_id")>
	<cfif IsDefined("attributes.ANSWER")>
		<cfquery name="GET_SURVEY_VOTE" datasource="#DSN#">
			SELECT
				SURVEY_ID
			FROM
				SURVEY_VOTES
			WHERE
				PAR_ID = #attributes.partner_id#
				AND
				SURVEY_ID = #SURVEY_ID#
		</cfquery>
		<cfif Not GET_SURVEY_VOTE.RecordCount>
			<cfquery name="ADD_SURVEY_VOTE" datasource="#DSN#">
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
					#attributes.SURVEY_ID#,
					#attributes.partner_id#,
					0,
					',#attributes.ANSWER#,',
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<cfloop list="#attributes.ANSWER#" index="i">
				<cfquery name="UPD_VOTE" datasource="#DSN#">
					UPDATE
						SURVEY_ALTS
					SET
						VOTE_COUNT = VOTE_COUNT+1
					WHERE
						ALT_ID = #I#
				</cfquery>
			</cfloop>
		</cfif> 
	</cfif>
</cfif>
<script type="text/javascript">
	window.location='<cfoutput>#HTTP_REFERER#</cfoutput>';
</script>
