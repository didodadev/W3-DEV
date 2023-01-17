<cfquery name="GET_TRAINING_NOTES" datasource="#DSN#">
    SELECT 
		NOTE_ID,
		NOTE_HEAD			
    FROM 
        TRAINING_NOTES 
    WHERE 
        CLASS_ID = #attributes.CLASS_ID# 
	<cfif isdefined('session.ep')>
		AND EMPLOYEE_ID = #session.ep.userid#
	<cfelseif isdefined('session.pp')>
		AND PARTNER_ID = #session.pp.userid#
	</cfif>
</cfquery>
<cf_ajax_list>
    <tbody>
		<cfif get_training_notes.recordcount>
            <cfoutput query="get_training_notes">
                <tr>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_training_note&note_id=#note_id#','medium');" class="tableyazi">#note_head#</a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
