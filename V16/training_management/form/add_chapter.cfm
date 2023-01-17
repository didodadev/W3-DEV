<cfset xfa.add = "#request.self#?fuseaction=training_management.emptypopup_add_quiz_chapter">
<cfquery name="GET_QUIZ" datasource="#dsn#">
	SELECT 
		EMPLOYEE_QUIZ.*, COMMETHOD
	FROM 
		EMPLOYEE_QUIZ, SETUP_COMMETHOD
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
		AND
		EMPLOYEE_QUIZ.COMMETHOD_ID = SETUP_COMMETHOD.COMMETHOD_ID
</cfquery>
<cf_popup_box title="#getLang('training_management',149)#">
    <cfform enctype="multipart/form-data" name="add_quiz_chapter" method="post" action="#XFA.add#">
    <input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
        <table>
            <tr height="22">
                <td><cf_get_lang_main no='1967.Form'></td>
                <td class="txtbold"><cfoutput>#get_quiz.quiz_head#</cfoutput></td>
            </tr>
            <tr>
                <td width="75" valign="top"><cf_get_lang_main no='583.Bölüm'></td>
                <td>
                	<textarea name="CHAPTER" id="CHAPTER" style="width:250px;height:40px;"></textarea>
                </td>
            </tr>
            <tr>
                <td valign="top"><cf_get_lang_main no='217.Açıklama'> </td>
                <td>
                	<textarea name="CHAPTER_INFO"  id="CHAPTER_INFO"  style="width:250px;height:40px;"></textarea>
                </td>
            </tr>
            <tr>
                <td valign="top">&nbsp;<cf_get_lang_main no='1987.Ağırlık'> (%)</td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang no ='481.Ağırlık için 1 ile 100 arasında bir sayı giriniz'>!</cfsavecontent>
                    <cfinput type="text" name="chapter_weight" value="" validate="float" style="width:50px" message="#message#" required="yes" range="1,100" onkeyup="return(FormatCurrency(this,event));">
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td class="txtbold"><cf_get_lang no ='482.Aktif (Seçili ise forma aşağıda girilen başlık ile Açıklama alanı eklenir!)'></td>
            </tr>
            <tr>
                <td>&nbsp;<cf_get_lang_main no ='217.Açıklama'>-1</td>
                <td>
                    <input type="checkbox" name="is_exp1" id="is_exp1">
                    <input type="text" name="exp1_name" id="exp1_name" maxlength="200" value="" style="width:225px;">
                    <input type="checkbox" name="is_emp_exp1" id="is_emp_exp1"><cf_get_lang_main no ='164.Çalışan'><!--- checkbox işaretli ise çalışana açıklama alanı gösterilmez --->
                    <input type="checkbox" name="is_chief3_exp1" id="is_chief3_exp1"><cf_get_lang_main no ='2111.Görüş Bildiren'><!--- checkbox işaretli ise görüş bildirene açıklama alanı gösterilmez --->
                    <input type="checkbox" name="is_chief1_exp1" id="is_chief1_exp1">1.<cf_get_lang_main no='1869.Amir'><!--- checkbox işaretli ise g1.amire açıklama alanı gösterilmez --->
                    <input type="checkbox" name="is_chief2_exp1" id="is_chief2_exp1">2.<cf_get_lang_main no='1869.Amir'><!--- checkbox işaretli ise 2.amire açıklama alanı gösterilmez --->
                </td>
            </tr>
            <tr>
                <td>&nbsp;<cf_get_lang_main no ='217.Açıklama'>-2</td>
                <td>
                    <input type="checkbox" name="is_exp2" id="is_exp2">
                    <input type="text" name="exp2_name" id="exp2_name" maxlength="200" value="" style="width:225px;">
                    <input type="checkbox" name="is_emp_exp2" id="is_emp_exp2"><cf_get_lang_main no ='164.Çalışan'>
                    <input type="checkbox" name="is_chief3_exp2" id="is_chief3_exp2"><cf_get_lang_main no ='2111.Görüş Bildiren'>
                    <input type="checkbox" name="is_chief1_exp2" id="is_chief1_exp2">1.<cf_get_lang_main no='1869.Amir'>
                    <input type="checkbox" name="is_chief2_exp2" id="is_chief2_exp2">2.<cf_get_lang_main no='1869.Amir'>
                </td>
            </tr>
            <tr>
                <td>&nbsp;<cf_get_lang_main no ='217.Açıklama'>-3</td>
                <td>
                    <input type="checkbox" name="is_exp3" id="is_exp3">
                    <input type="text" name="exp3_name" id="exp3_name" maxlength="200" value="" style="width:225px;">
                    <input type="checkbox" name="is_emp_exp3" id="is_emp_exp3"><cf_get_lang_main no ='164.Çalışan'>
                    <input type="checkbox" name="is_chief3_exp3" id="is_chief3_exp3"><cf_get_lang_main no ='2111.Görüş Bildiren'>
                    <input type="checkbox" name="is_chief1_exp3" id="is_chief1_exp3">1.<cf_get_lang_main no='1869.Amir'>
                    <input type="checkbox" name="is_chief2_exp3" id="is_chief2_exp3">2.<cf_get_lang_main no='1869.Amir'> 
                </td>
            </tr>
            <tr>
                <td>&nbsp;<cf_get_lang_main no ='217.Açıklama'>-4</td>
                <td>
                    <input type="checkbox" name="is_exp4" id="is_exp4">
                    <input type="text" name="exp4_name" id="exp4_name" maxlength="200" value="" style="width:225px;">
                    <input type="checkbox" name="is_emp_exp4" id="is_emp_exp4"><cf_get_lang_main no ='164.Çalışan'>
                    <input type="checkbox" name="is_chief3_exp4" id="is_chief3_exp4"><cf_get_lang_main no ='2111.Görüş Bildiren'>
                    <input type="checkbox" name="is_chief1_exp4" id="is_chief1_exp4">1.<cf_get_lang_main no='1869.Amir'>
                    <input type="checkbox" name="is_chief2_exp4" id="is_chief2_exp4">2.<cf_get_lang_main no='1869.Amir'>
                </td>
            </tr>
		<!--- <tr>
            	<td width="75" valign="top"><cf_get_lang no='326.Tasarım Tipi'></td>
            	<td>
				<input type="radio" name="answer_type" value="1" onclick="goster2(1);">
				<cf_get_lang no='327.Cevaplar Yan Yana'>
				<input type="radio" name="answer_type" value="2" onclick="goster2(2);">
				<cf_get_lang no='328.Cevaplar Alt Alta'></td>
            </tr> --->
            <tr id="cevap_tasarim" style="display:;">
                <td><cf_get_lang no='124.Şık Sayısı'></td>
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
                                    <textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" style="width:250px; height:40px;"></textarea>
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
        <cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()' type_format="1"></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	document.add_quiz_chapter.chapter_weight.value=filterNum(document.add_quiz_chapter.chapter_weight.value);
	return true;
}
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

/*function goster2(number)
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
}*/
</script>
