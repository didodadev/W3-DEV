<cfquery name="GET_NOTES" datasource="#DSN#">
	SELECT
		NOTE_HEAD
	FROM
		NOTES
	WHERE
	<cfif isDefined("session.pp")>
		RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	<cfelseif isDefined("session.ww")>
		RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfif>
	ORDER BY 
		RECORD_DATE
</cfquery>

<div class="table-responsive-lg">
	<table class="table">
		<cfif get_notes.recordcount>
			<cfoutput query="get_notes">
				<tr>
					<td>
						#note_head#
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td>
					<cf_get_lang dictionary_id="57484.Kayit Yok">!
				</td>
			</tr>
		</cfif>
	</table>
</div>