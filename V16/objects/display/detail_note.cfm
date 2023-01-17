<cfsetting showdebugoutput="no">
<cfquery name="DETAIL_NOTE" datasource="#DSN#">
	SELECT 
		NOTE_BODY,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE 
	FROM 
		NOTES 
	WHERE	
		NOTE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfoutput>
	<div style="overflow:auto;border:1;" >
		<table id="notes_#attributes.id#" width="100%">
			<tr>
				<td colspan="2" width="100%">
					#detail_note.note_body#
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<cfif len(detail_note.record_emp)><cf_get_lang dictionary_id='57483.Kayıt'>: #get_emp_info(detail_note.record_emp,0,0)# #dateformat(detail_note.record_date,dateformat_style)# #Timeformat(date_add("h", 2, detail_note.record_date),timeformat_style)#</cfif>
					<cfif len(detail_note.update_emp)><cf_get_lang dictionary_id='57703.Güncelleme'>: #get_emp_info(detail_note.update_emp,0,0)# #dateformat(detail_note.update_date,dateformat_style)# #Timeformat(date_add("h", session.ep.time_zone, detail_note.update_date),timeformat_style)#</cfif>
				</td>
			</tr>
		</table>
	</div>
</cfoutput>

