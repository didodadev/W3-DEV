<cfquery name="get_training_notes" datasource="#dsn#">
	SELECT 
    	NOTE_ID, 
        EMPLOYEE_ID, 
        PARTNER_ID, 
        NOTE_HEAD, 
        RECORD_DATE, 
        TRAINING_ID, 
        CLASS_ID, 
        UPDATE_DATE
    FROM 
    	TRAINING_NOTES 
    WHERE 
    	TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_id#"> AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<table class="ajax_list">
    <tbody>
        <cfif get_training_notes.recordcount>
            <cfoutput query="get_training_notes">
                <tr>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_form_upd_training_note&note_id=#note_id#','list');">#note_head#</a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</table>
