<cfinclude template="../query/get_training_questions.cfm">
<table class="ajax_list">
    <tbody>
        <cfif get_training_questions.recordcount>
            <cfoutput query="get_training_questions">
                <tr>
                    <td> 
                        <img src="/images/tree_1.gif"> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_form_upd_question&question_id=#question_id#','small');">#question#</a><br/>
                    </td>
                </tr>
            </cfoutput> 
        <cfelse>
            <tr>
                <td>
                    <cf_get_lang_main no='72.Kayıt Bulunamadı'>!
                </td>
            </tr>
        </cfif> 
   </tbody>
</table>
