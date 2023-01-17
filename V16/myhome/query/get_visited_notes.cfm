<cfquery name="DETAIL_NOTES_VISITED" datasource="#DSN#">
	<cfif isdefined("attributes.note_id")>
        DELETE FROM
            VISITING_NOTES
        WHERE
            V_NOTE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.note_id#">
    <cfelse> 
         SELECT
            *
        FROM
            VISITING_NOTES
        WHERE
            NOTE_TAKEN_TYPE = 1 AND
            NOTE_TAKEN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
        ORDER BY 
            RECORD_DATE DESC
    </cfif>
</cfquery>
