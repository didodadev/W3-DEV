<cfsetting showdebugoutput="no">
<cfset xfa.upd = "#request.self#?fuseaction=training_management.emptypopup_upd_quiz_chapter">
<cfinclude template="../query/get_quiz_chapter.cfm">
<script type="text/javascript">
	function kontrol()
	{
		document.upd_CHAPTER.chapter_weight.value=filterNum(document.upd_CHAPTER.chapter_weight.value);
		return true;
	}
	<!--
	function goster(number)
	{
	// sayı seçilenin 1 eksiği geliyor
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
	
	function goster2(number)
	{
		if (number==1)
		{
			cevap_tasarim.style.display = '';
		}
		else
		{
			cevap_tasarim.style.display = 'none';
			document.add_quiz_chapter.answer_number.selectedIndex=0;
			goster(0);
		}
	}
	//-->
</script>
<cfform enctype="multipart/form-data" name="upd_CHAPTER" method="post" action="#XFA.upd#">
	<cf_popup_box title="#getLang('training_management',314)# : #GET_QUIZ_CHAPTER.CHAPTER#">
    <input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
    <input type="Hidden" name="CHAPTER_id" id="CHAPTER_id" value="<cfoutput>#attributes.CHAPTER_id#</cfoutput>">
    <cfif IsDefined("attributes.answertype")>
        <input type="Hidden" name="answertype" id="answertype" value="1">
    </cfif>
        <table>
            <tr>
                <td width="75" valign="top"><cf_get_lang_main no='583.Bölüm'></td>
                <td>
                	<textarea name="CHAPTER" id="CHAPTER" style="width:250px;height:60px;"><cfoutput>#get_quiz_chapter.CHAPTER#</cfoutput></textarea>
                </td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang_main no='217.Açıklama'> </td>
                <td>
                	<textarea name="CHAPTER_INFO" id="CHAPTER_INFO"  style="width:250px;height:60px;"><cfoutput>#get_quiz_chapter.CHAPTER_info#</cfoutput></textarea>
                </td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang_main no='1987.Ağırlık'> (%)</td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang no ='481.Ağırlık için 1 ile 100 arasında bir sayı giriniz'> !</cfsavecontent>
                    <cfinput type="text" name="chapter_weight" value="#TLFormat(get_quiz_chapter.chapter_weight,1)#" validate="float" style="width:50px" message="#message#" required="yes" range="1,100" onkeyup="return(FormatCurrency(this,event));">
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td class="txtbold"><cf_get_lang no='482.Aktif (Seçili ise forma aşağıda girilen başlık ile Açıklama alanı eklenir!)'></td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='217.Açıklama'>-1</td>
                <td>
                    <input type="checkbox" name="is_exp1" id="is_exp1" <cfif 1 IS get_quiz_chapter.is_exp1>checked</cfif>>
                    <input type="text" name="exp1_name" id="exp1_name" maxlength="200" value="<cfif len(get_quiz_chapter.exp1_name)><cfoutput>#get_quiz_chapter.exp1_name#</cfoutput></cfif>" style="width:230px;">
                    <input type="checkbox" name="is_emp_exp1" id="is_emp_exp1" <cfif 1 IS get_quiz_chapter.is_emp_exp1>checked</cfif>><cf_get_lang_main no='164.Çalışan'>
                    <input type="checkbox" name="is_chief3_exp1" id="is_chief3_exp1" <cfif 1 IS get_quiz_chapter.is_chief3_exp1>checked</cfif>><cf_get_lang_main no='157.Görevli'>
                    <input type="checkbox" name="is_chief1_exp1" id="is_chief1_exp1" <cfif 1 IS get_quiz_chapter.is_chief1_exp1>checked</cfif>>1.<cf_get_lang_main no='1869.Amir'>
                    <input type="checkbox" name="is_chief2_exp1" id="is_chief2_exp1" <cfif 1 IS get_quiz_chapter.is_chief2_exp1>checked</cfif>>2.<cf_get_lang_main no='1869.Amir'>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='217.Açıklama'>-2</td>
                <td>
                    <input type="checkbox" name="is_exp2" id="is_exp2" <cfif 1 IS get_quiz_chapter.is_exp2>checked</cfif>>
                    <input type="text" name="exp2_name" id="exp2_name" maxlength="200" value="<cfif len(get_quiz_chapter.exp2_name)><cfoutput>#get_quiz_chapter.exp2_name#</cfoutput></cfif>" style="width:230px;">
                    <input type="checkbox" name="is_emp_exp2" id="is_emp_exp2" <cfif 1 IS get_quiz_chapter.is_emp_exp2>checked</cfif>><cf_get_lang_main no='164.Çalışan'>
                    <input type="checkbox" name="is_chief3_exp2" id="is_chief3_exp2" <cfif 1 IS get_quiz_chapter.is_chief3_exp2>checked</cfif>><cf_get_lang_main no='157.Görevli'>
                    <input type="checkbox" name="is_chief1_exp2" id="is_chief1_exp2" <cfif 1 IS get_quiz_chapter.is_chief1_exp2>checked</cfif>>1.<cf_get_lang_main no='1869.Amir'>
                    <input type="checkbox" name="is_chief2_exp2" id="is_chief2_exp2" <cfif 1 IS get_quiz_chapter.is_chief2_exp2>checked</cfif>>2.<cf_get_lang_main no='1869.Amir'>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='217.Açıklama'>-3</td>
                <td>
                    <input type="checkbox" name="is_exp3" id="is_exp3" <cfif 1 IS get_quiz_chapter.is_exp3>checked</cfif>>
                    <input type="text" name="exp3_name" id="exp3_name" maxlength="200" value="<cfif len(get_quiz_chapter.exp2_name)><cfoutput>#get_quiz_chapter.exp3_name#</cfoutput></cfif>" style="width:230px;">
                    <input type="checkbox" name="is_emp_exp3" id="is_emp_exp3" <cfif 1 IS get_quiz_chapter.is_emp_exp3>checked</cfif>><cf_get_lang_main no='164.Çalışan'>
                    <input type="checkbox" name="is_chief3_exp3" id="is_chief3_exp3" <cfif 1 IS get_quiz_chapter.is_chief3_exp3>checked</cfif>><cf_get_lang_main no='157.Görevli'>
                    <input type="checkbox" name="is_chief1_exp3" id="is_chief1_exp3" <cfif 1 IS get_quiz_chapter.is_chief1_exp3>checked</cfif>>1.<cf_get_lang_main no='1869.Amir'>
                    <input type="checkbox" name="is_chief2_exp3" id="is_chief2_exp3" <cfif 1 IS get_quiz_chapter.is_chief2_exp3>checked</cfif>>2.<cf_get_lang_main no='1869.Amir'>
                </td>
            </tr>
            <tr>
                <td><cf_get_lang_main no='217.Açıklama'>-4</td>
                <td>
                    <input type="checkbox" name="is_exp4" id="is_exp4" <cfif 1 IS get_quiz_chapter.is_exp4>checked</cfif>>
                    <input type="text" name="exp4_name" id="exp4_name" maxlength="200" value="<cfif len(get_quiz_chapter.exp4_name)><cfoutput>#get_quiz_chapter.exp4_name#</cfoutput></cfif>" style="width:230px;">
                    <input type="checkbox" name="is_emp_exp4" id="is_emp_exp4" <cfif 1 IS get_quiz_chapter.is_emp_exp4>checked</cfif>><cf_get_lang_main no='164.Çalışan'>
                    <input type="checkbox" name="is_chief3_exp4" id="is_chief3_exp4" <cfif 1 IS get_quiz_chapter.is_chief3_exp4>checked</cfif>><cf_get_lang_main no='157.Görevli'>
                    <input type="checkbox" name="is_chief1_exp4" id="is_chief1_exp4" <cfif 1 IS get_quiz_chapter.is_chief1_exp4>checked</cfif>>1.<cf_get_lang_main no='1869.Amir'>
                    <input type="checkbox" name="is_chief2_exp4" id="is_chief2_exp4" <cfif 1 IS get_quiz_chapter.is_chief2_exp4>checked</cfif>>2.<cf_get_lang_main no='1869.Amir'> 
                </td>
            </tr>
            <cfif not IsDefined("attributes.answertype")>
                <tr>
                    <td><cf_get_lang no='124.Şık Sayısı'></td>
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
            <cfloop from="0" to="#evaluate(get_quiz_chapter.answer_number-1)#" index="i">
                <tr id="answer<cfoutput>#i#</cfoutput>" style="display:none;" class="color-row">
                	<td colspan="2">
                        <table>
                            <tr>
                                <td></td>
                                <td class="formbold"><cf_get_lang_main no='1985.Şık'><cfoutput>#evaluate(i+1)#</cfoutput></td>
                            </tr>
                                <!--- <input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" value="<cfoutput>#evaluate("get_quiz_chapter.answer"&i+1&"_true")#</cfoutput>"> --->
                            <tr>
                                <td valign="top" width="70"><cf_get_lang no='126.Yazı'></td>
                                <td valign="top">
                                    <textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" style="width:250px;height:60px;"><cfoutput>#evaluate("get_quiz_chapter.answer"&i+1&"_text")#</cfoutput></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" width="70"><cf_get_lang_main no='1572.Puan'></td>
                                <td valign="top">
                                	<input type="text" name="answer<cfoutput>#i#</cfoutput>_point" id="answer<cfoutput>#i#</cfoutput>_point" style="width:250px;" <cfoutput>value=#evaluate("get_quiz_chapter.answer"&i+1&"_point")#</cfoutput>>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top"><cf_get_lang_main no='668.Resim'></td>
                                <td>
									<cfif len(evaluate("get_quiz_chapter.answer"&i+1&"_photo"))>
										<!---  <img src="#file_web_path#hr/<cfoutput>#evaluate("get_quiz_chapter.answer"&i+1&"_photo")#</cfoutput>" border="0"> --->
                                        <cf_get_server_file output_file="hr/#evaluate("get_quiz_chapter.answer"&i+1&"_photo")#" output_server="#evaluate("get_quiz_chapter.answer"&i+1&"_photo_server_id")#" output_type="0" image_link="0"><br/>
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
            <cfloop from="#get_quiz_chapter.answer_number#" to="19" index="i">
                <tr id="answer<cfoutput>#i#</cfoutput>" style="display:none;">
                	<td colspan="2">
                		<table>
                            <tr>
                                <td></td>
                                <td><cf_get_lang_main no='1985.Şık'><cfoutput>#evaluate(i+1)#</cfoutput></td>
                            </tr>
                            <input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="">
                            <tr>
                                <td valign="top" width="70"><cf_get_lang no='126.Yazı'></td>
                                <td valign="top">
                                	<textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" style="width:250px;height:60px;"></textarea>
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
        </table>
        <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()' type_format="1"></cf_popup_box_footer>
    </cf_popup_box>
</cfform>
<script type="text/javascript">
	<cfif evaluate(get_quiz_chapter.answer_number) neq 0>
		document.upd_CHAPTER.answer_number.selectedIndex = <cfoutput>#evaluate(get_quiz_chapter.answer_number-1)#</cfoutput>;
		goster(<cfoutput>#evaluate(get_quiz_chapter.answer_number-1)#</cfoutput>);
	</cfif>
</script>
