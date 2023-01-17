<cfif not isdefined("attributes.ANSWER")>
	<script type="text/javascript">
		alert("Bir Seçim Yapmalısınız!");
		history.back();
	</script>
	<cfabort>
</cfif>
<!--- if cons votes --->
<cfif isdefined("session.ww.userid")>
	<cfif IsDefined("attributes.ANSWER")>
		<cfquery name="GET_SURVEY_VOTE" datasource="#dsn#">
			SELECT
				SURVEY_ID
			FROM
				SURVEY_VOTES
			WHERE
				CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
				SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_id#">
		</cfquery>
		<cfif not GET_SURVEY_VOTE.RecordCount>
			<cfquery name="ADD_SURVEY_VOTE" datasource="#dsn#">
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
					#session.ww.userid#,
					0,
					',#attributes.ANSWER#,',
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<CFloop list="#attributes.ANSWER#" index="i">
				<cfquery name="UPD_VOTE" datasource="#dsn#">
					UPDATE
						SURVEY_ALTS
					SET
						VOTE_COUNT = VOTE_COUNT+1
					WHERE
						ALT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				</cfquery>
			</CFloop>
		</cfif> 
	</cfif>
</cfif>
<!--- if partner votes --->
<cfif isdefined("session.pp.userid")>
	<cfif IsDefined("attributes.ANSWER")>
		<cfquery name="GET_SURVEY_VOTE" datasource="#dsn#">
			SELECT
				SURVEY_ID
			FROM
				SURVEY_VOTES
			WHERE
				PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
				SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_id#">
		</cfquery>
		<cfif Not GET_SURVEY_VOTE.RecordCount>
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
					#attributes.SURVEY_ID#,
					#session.pp.userid#,
					0,
					',#attributes.ANSWER#,',
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<CFloop list="#attributes.ANSWER#" index="i">
				<cfquery name="UPD_VOTE" datasource="#dsn#">
					UPDATE
						SURVEY_ALTS
					SET
						VOTE_COUNT = VOTE_COUNT+1
					WHERE
						ALT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				</cfquery>
			</CFloop>
		</cfif> 
	</cfif>
</cfif>
<cfif isdefined("session.ww") and not isdefined("session.ww.userid")>
	<cfif IsDefined("attributes.ANSWER")>
		<cfquery name="GET_SURVEY_VOTE" datasource="#dsn#">
			SELECT
				SURVEY_ID
			FROM
				SURVEY_VOTES
			WHERE
				SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
				GUEST = 1 AND
				RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">
		</cfquery>
		<cfif Not GET_SURVEY_VOTE.RecordCount>
			<cfquery name="ADD_SURVEY_VOTE" datasource="#dsn#">
				INSERT INTO
					SURVEY_VOTES
					(
					SURVEY_ID,
					GUEST,
					VOTES,
					RECORD_IP
					)
				VALUES
					(
					#attributes.SURVEY_ID#,
					1,
					',#attributes.ANSWER#,',
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<CFloop list="#attributes.ANSWER#" index="i">
				<cfquery name="UPD_VOTE" datasource="#dsn#">
					UPDATE
						SURVEY_ALTS
					SET
						VOTE_COUNT = VOTE_COUNT+1
					WHERE
						ALT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				</cfquery>
			</CFloop>
		</cfif> 
	</cfif>
</cfif>
<cfif isdefined("session.cp") and not isdefined("session.ww.userid")>
	<cfif IsDefined("attributes.ANSWER")>
		<cfquery name="GET_SURVEY_VOTE" datasource="#dsn#">
			SELECT
				SURVEY_ID
			FROM
				SURVEY_VOTES
			WHERE
				SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
				GUEST = 1 AND
				RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">
		</cfquery>
		<cfif Not GET_SURVEY_VOTE.RecordCount>
			<cfquery name="ADD_SURVEY_VOTE" datasource="#dsn#">
				INSERT INTO
					SURVEY_VOTES
					(
					SURVEY_ID,
					GUEST,
					VOTES,
					RECORD_IP
					)
				VALUES
					(
					#attributes.SURVEY_ID#,
					1,
					',#attributes.ANSWER#,',
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<CFloop list="#attributes.ANSWER#" index="i">
				<cfquery name="UPD_VOTE" datasource="#dsn#">
					UPDATE
						SURVEY_ALTS
					SET
						VOTE_COUNT = VOTE_COUNT+1
					WHERE
						ALT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				</cfquery>
			</CFloop>
		</cfif> 
	</cfif>
</cfif>
<cfif isdefined("session.wp")>
	<cfif IsDefined("attributes.ANSWER")>
		<cfquery name="GET_SURVEY_VOTE" datasource="#dsn#">
			SELECT
				SURVEY_ID
			FROM
				SURVEY_VOTES
			WHERE
				SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
				GUEST = 1 AND
				RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">
		</cfquery>
		<cfif Not GET_SURVEY_VOTE.RecordCount>
			<cfquery name="ADD_SURVEY_VOTE" datasource="#dsn#">
				INSERT INTO
					SURVEY_VOTES
					(
					SURVEY_ID,
					GUEST,
					VOTES,
					RECORD_IP
					)
				VALUES
					(
					#attributes.SURVEY_ID#,
					1,
					',#attributes.ANSWER#,',
					'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<CFloop list="#attributes.ANSWER#" index="i">
				<cfquery name="UPD_VOTE" datasource="#dsn#">
					UPDATE
						SURVEY_ALTS
					SET
						VOTE_COUNT = VOTE_COUNT+1
					WHERE
						ALT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				</cfquery>
			</CFloop>
		</cfif> 
	</cfif>
</cfif>
<script type="text/javascript">
	window.open('<cfoutput>#request.self#?fuseaction=objects2.popup_vote_results&survey_id=#SURVEY_ID#</cfoutput>','small','height=500,width=400');
	window.location='<cfoutput>#HTTP_REFERER#</cfoutput>';
</script> 


