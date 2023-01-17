<cfinclude template="../query/get_training_quiz_names.cfm">
<table class="ajax_list">
    <tbody>
        <cfif get_training_quiz_names.recordcount>
            <cfoutput query="get_training_quiz_names"> 
                <cfif ((dateformat(get_training_quiz_names.quiz_startdate,"yyyymmdd") lte dateformat(now(),"yyyymmdd")) and (dateformat(get_training_quiz_names.quiz_finishdate,"yyyymmdd") gte dateformat(now(),"yyyymmdd")))>
                    <tr>
                        <td>
                            <img src="/images/tree_1.gif"> <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.popup_make_quiz&quiz_id=#get_training_quiz_names.quiz_id#','list');">#quiz_head#</a><br/>
                        </td>
                    </tr>
                </cfif>
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
