<cfset xfa.upd = "#request.self#?fuseaction=training_management.emptypopup_upd_eval_question">
<cfinclude template="../query/get_quiz_chapter.cfm">
<cfinclude template="../query/get_eval_question.cfm">
<cfinclude template="../query/get_eval_question.cfm">

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
<cfform enctype="multipart/form-data" name="upd_question" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_eval_question">
	<input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
	<input type="Hidden" name="question_id" id="question_id" value="<cfoutput>#attributes.question_id#</cfoutput>">
	<input type="Hidden" name="CHAPTER_id" id="CHAPTER_id" value="<cfoutput>#attributes.CHAPTER_id#</cfoutput>">
	<cfif IsDefined("attributes.answertype")>
	<input type="Hidden" name="answertype" id="answertype" value="1">
	</cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr class="color-border">
    <td>
	  <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
		  <tr class="color-list"> 
    <td height="35" class="headbold"><cf_get_lang no='128.Soru Güncelle'> : <cfoutput>#GET_QUIZ_CHAPTER.CHAPTER#</cfoutput></td>
	
  </tr>
		<tr class="color-row">  
		 <td valign="top">
              <table>
                <tr> 
                  <td width="75" valign="top">&nbsp;<cf_get_lang_main no='1398.Soru'></td>
                  <td> 
                    <textarea name="question" id="question" style="width:250px;height:40px;"><cfoutput>#get_question.question#</cfoutput></textarea>
                  </td>
                </tr>
               <!---  <tr> 
                  <td width="75" valign="top">&nbsp;Cevap Tipi</td>
                  <td> 
                    <input type="radio" name="answer_type" value="1" <cfif get_question.answer_type Is 1>checked</cfif>>
					Tek cevaplı
					<input type="radio" name="answer_type" value="2" <cfif get_question.answer_type Is 2>checked</cfif>>
					Çok cevaplı
                  </td> 
                </tr>--->
                <tr> 
                  <td valign="top">&nbsp;<cf_get_lang_main no='217.Açıklama'> </td>
                  <td>
                    <textarea name="QUESTION_INFO" id="QUESTION_INFO" style="width:250px;height:40px;"><cfoutput>#get_question.question_info#</cfoutput></textarea>
                  </td>
                </tr>
            
				<cfif not IsDefined("attributes.answertype")>
                <tr> 
				  <td>&nbsp;<cf_get_lang no='124.Şık Sayısı'> </td>
                  <td class="txtbold">
                    <!--- şık sayısı seçilecek --->
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

                <cfloop from="0" to="#evaluate(get_question.answer_number-1)#" index="i">
                  <tr id="answer<cfoutput>#i#</cfoutput>" style="display:none;" class="color-row"> 
                    <td colspan="2"> 
                      <table>
                        <tr> 
                          <td></td>
                          <td class="formbold"><cf_get_lang_main no='1985.Şık'> <cfoutput>#evaluate(i+1)#</cfoutput></td>
                        </tr>
                        <!--- <input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" value="<cfoutput>#evaluate("get_question.answer"&i+1&"_true")#</cfoutput>"> --->
                        <tr> 
                          <td valign="top" width="70"><cf_get_lang no='126.Yazı'></td>
                          <td valign="top"> 
                            <textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" style="width:250px;height:40px;"><cfoutput>#evaluate("get_question.answer"&i+1&"_text")#</cfoutput></textarea>
                          </td>
                        </tr>
                        <tr> 
                          <td valign="top" width="70"><cf_get_lang_main no='1572.Puan'></td>
                          <td valign="top"> 
                            <input type="text" name="answer<cfoutput>#i#</cfoutput>_point" id="answer<cfoutput>#i#</cfoutput>_point" style="width:250px;" <cfoutput>value=#evaluate("get_question.answer"&i+1&"_point")#</cfoutput>>
                          </td>
                        </tr>
                        <tr> 
                          <td valign="top"><cf_get_lang_main no='668.Resim'></td>
                        <td> 
                            <cfif len(evaluate("get_question.answer"&i+1&"_photo"))>
                            <!--- <img src="#file_web_path#hr/<cfoutput>#evaluate('get_question.answer'&i+1&'_photo')#</cfoutput>" border="0"><br/> --->
							 	<cf_get_server_file output_file="hr/#evaluate("get_question.answer"&i+1&"_photo")#" output_server="#evaluate("get_question.answer"&i+1&"_photo_server_id")#" output_type="0">
                            	<br/>
						    	<input type="Checkbox" name="del_image<cfoutput>#i#</cfoutput>" id="del_image<cfoutput>#i#</cfoutput>" value="1">
                            	<cf_get_lang no='329.Resmi sil'> <br/>
                            </cfif>
                            <input type="File" name="answer<cfoutput>#i#</cfoutput>_photo" id="answer<cfoutput>#i#</cfoutput>_photo" style="width:250px;">
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </cfloop>
                <cfloop from="#get_question.answer_number#" to="19" index="i">
                  <tr id="answer<cfoutput>#i#</cfoutput>" style="display:none;"> 
                    <td colspan="2"> 
                      <table>
                        <tr> 
                          <td></td>
                          <td class="formbold"><cf_get_lang_main no='1985.Şık'> <cfoutput>#evaluate(i+1)#</cfoutput></td>
                        </tr>
                        <input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="">
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
                      </table>
                    </td>
                  </tr>
                </cfloop>
                <tr> 
                  <td height="35" colspan="2" style="text-align:right;"> 
                    <input type="Hidden" name="more" id="more" value=0>
		  			<cfsavecontent variable="message"><cf_get_lang no='254.Kaydet ve Yeni Soru Ekle'></cfsavecontent>
						 <cf_workcube_buttons 
						is_upd='0' 
						insert_info='#message#' 
					add_function="(document.upd_question.more.value=1)"
					is_cancel='0'>
                  <cf_workcube_buttons is_upd='0'>
				  </td>
                </tr>
              </table>
		  </td>
	  </tr>
	</table>
   </td>
  </tr>
</table>
</cfform>
<script type="text/javascript">
	<cfif evaluate(get_question.answer_number) neq 0>
		document.upd_question.answer_number.selectedIndex = <cfoutput>#evaluate(get_question.answer_number-1)#</cfoutput>;
		goster(<cfoutput>#evaluate(get_question.answer_number-1)#</cfoutput>);
	</cfif>
</script>
