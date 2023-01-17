<cfset cfc = createObject('component','V16.content.cfc.get_content')>
<cfset get_related_questions = cfc.get_related_questions(cntid: attributes.cntid)>
<cfsetting showdebugoutput="no">
<cf_ajax_list>
    <thead>
        <tr>
            <th width="15"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='58810.Soru'></th>
            <th width="15"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_related_questions">
            <cfif get_related_questions.recordcount>
                <tr>
                    <td>#currentrow#</td>
                    <td>#question#</td>
                    <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=training_management.list_content&event=delRelatedQuestions&question_id=#question_id#&cntid=#attributes.cntid#','del_related_question_box')"><i class="fa fa-minus"></i></a></td>
                </tr>
            <cfelse>
                <cf_get_lang dictionary_id='57484.Kayıt Yok'>
            </cfif>
        </cfoutput>
    </tbody>
</cf_ajax_list>