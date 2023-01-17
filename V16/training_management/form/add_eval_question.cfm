<cfinclude template="../query/get_quiz_chapter.cfm">
<cfform enctype="multipart/form-data" name="add_question" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_eval_question">
<input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<input type="Hidden" name="chapter_id" id="chapter_id" value="<cfoutput>#attributes.CHAPTER_id#</cfoutput>">
<cfif IsDefined("attributes.answertype")>
    <input type="Hidden" name="answertype" id="answertype" value="1">
</cfif>
    <cf_popup_box title="#getLang('training_management',105)# : #GET_QUIZ_CHAPTER.CHAPTER#">
        <table>
            <tr>
                <td width="75" valign="top">&nbsp;<cf_get_lang_main no='1398.Soru'></td>
                <td>
                	<textarea name="question" id="question" style="width:250px;height:40px;"></textarea>
                </td>
            </tr>
            <tr>
                <td valign="top">&nbsp;<cf_get_lang_main no='217.Açıklama'> </td>
                <td>
                	<textarea name="QUESTION_INFO" id="QUESTION_INFO" style="width:250px;height:40px;"></textarea>
                </td>
            </tr>
            <cfif not IsDefined("attributes.answertype")>
                <tr>
                    <td>&nbsp;<cf_get_lang no='124.şık sayısı'></td>
                    <td class="txtbold">
                        <select name="answer_number" id="answer_number" onchange="goster(this.selectedIndex);">
                            <option value="0">0</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6">6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                            <option value="13">13</option>
                            <option value="14">14</option>
                            <option value="15">15</option>
                            <option value="16">16</option>
                            <option value="17">17</option>
                            <option value="18">18</option>
                            <option value="19">19</option>
                            <option value="20">20</option>
                        </select>
                    </td>
                </tr>
            <cfelse>
            	<input type="Hidden" name="answer_number" id="answer_number" value="0">
            </cfif>
            <cfloop from="0" to="19" index="i">
                <tr id="answer<cfoutput>#i#</cfoutput>" style="display:none;" class="color-row">
                	<td colspan="2">
                        <table>
                            <tr>
                                <td>&nbsp;</td>
                                <td class="formbold"><cf_get_lang_main no='1985.Şık'> <cfoutput>#evaluate(i+1)#</cfoutput></td>
                            </tr>
                            <input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="0">
                            <tr>
                                <td valign="top" width="70"><cf_get_lang no='126.Yazı'></td>
                                <td valign="top">
                                	<textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" style="width:250px;height:40px;"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="70"><cf_get_lang_main no='1572.Puan'></td>
                                <td valign="top">
                               		<input type="text" name="answer<cfoutput>#i#</cfoutput>_point" id="answer<cfoutput>#i#</cfoutput>_point" style="width:250px;">
                                </td>
                            </tr>
                            <tr>
                                <td><cf_get_lang_main no='668.Resim'></td>
                                <td>
                                	<input type="File" name="answer<cfoutput>#i#</cfoutput>_photo" id="answer<cfoutput>#i#</cfoutput>_photo" style="width:250px;">
                                </td>
                            </tr>
                            <tr>
                            	<td colspan="2" height="10"></td>
                            </tr>
                        </table>
                	</td>
                </tr>
            </cfloop>
        </table>
        <cf_popup_box_footer>
            <input type="Hidden" name="more" id="more" value=0>
            <cfsavecontent variable="message"><cf_get_lang no='254.Kaydet ve Yeni Soru Ekle'></cfsavecontent>
            <cf_workcube_buttons  type_format="1"
                is_upd='0' 
                insert_info='#message#' 
                add_function="(document.add_question.more.value=1)"
                is_cancel='0'>
                <cf_workcube_buttons is_upd='0'>
        </cf_popup_box_footer>    
	</cf_popup_box>
</cfform>
<script type="text/javascript">
function goster(number)
{
/*sayı seçilenin 1 eksiği geliyor*/
if (number!=0)
{
	for (i=0;i<=number;i++)
	{
		eleman = eval('answer'+i);
		eleman.style.display = '';
	}
	for (i=number+1;i<=19;i++)
	{
		eleman = eval('answer'+i);
		eleman.style.display = 'none';
	}
}
else
{
	for (i=0;i<=19;i++)
	{
		eleman = eval('answer'+i);
		eleman.style.display = 'none';
	}
}
}
</script>

