<cfinclude template="../query/get_positioncat_quiz.cfm">
<cfinclude template="../query/get_position_quiz.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55119.Ölçme Değerlendirme Formları"></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="list_position_quizs" method="post" action="">
    <cf_medium_list>
        <thead>
            <tr>
                <th colspan="2"><cf_get_lang dictionary_id='55953.Form Adı'></th>
                <th width="15" style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_position_list_quizs&position_id=#attributes.position_id#&form_type=1</cfoutput>','page_horizantal');"><img src="images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
            </tr>
        </thead>
        <tbody>
			<cfif GET_POSITIONCAT_QUIZ.recordcount or GET_POSITION_QUIZ.recordcount>
				<cfoutput query="GET_POSITIONCAT_QUIZ">
                    <tr>
                        <td colspan="2"><a href="javascript://" onclick="opener.location.href='#request.self#?fuseaction=hr.quiz&quiz_id=#GET_POSITIONCAT_QUIZ.QUIZ_ID#';" class="tableyazi"> #GET_POSITIONCAT_QUIZ.QUIZ_HEAD#</a>(<cf_get_lang dictionary_id='59004.Pozisyon Tipi'>)</td>
                        <td>&nbsp;</td>
                    </tr>
				</cfoutput>
                <cfoutput query="GET_POSITION_QUIZ">
                    <tr>
                        <td colspan="2"><a href="#request.self#?fuseaction=hr.quiz&quiz_id=#GET_POSITION_QUIZ.QUIZ_ID#" class="tableyazi"> #GET_POSITION_QUIZ.QUIZ_HEAD#</a>(<cf_get_lang dictionary_id='58497.Pozisyon'>)</td>
                        	<cfsavecontent variable="del_alert"><cf_get_lang dictionary_id ='56791.Kayıtlı İçeriği Siliyorsunuz. Emin misiniz'></cfsavecontent>
                        <td width="15" style="text-align:right;"><a HREF="javascript://" onClick="javascript:if (confirm('#del_alert#')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_position_empquiz&quiz_id=#GET_POSITION_QUIZ.quiz_id#&position_id=#attributes.position_id#','small'); else return;"><img src="/images/delete_list.gif" title="<cf_get_lang_main no='51.Sil'>"></a> </td>
                    </tr>
                </cfoutput>
                <cfelse>
                <tr>
                	<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
                </tr>
            </cfif>
        </tbody>
    </cf_medium_list>
</cfform>
</cf_popup_box>
