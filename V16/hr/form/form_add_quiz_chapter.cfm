<cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>
	<cfinclude template="../query/get_quiz.cfm">
<cfelseif isdefined("attributes.req_type_id") and len(attributes.req_type_id)>
	<cfquery name="GET_QUIZ" datasource="#dsn#">
		SELECT * FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#"> 
	</cfquery>
</cfif>
<cf_box title="#getLang('','Yeterlilikler',47256)#">
    <cfform enctype="multipart/form-data" name="add_quiz_chapter" method="post" action="#request.self#?fuseaction=hr.add_quiz_chapter">
        <cf_box_elements>
            <cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>
                <input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
            <cfelseif isdefined("attributes.req_type_id") and len(attributes.req_type_id)>
                <input type="hidden" name="req_type_id" id="req_type_id" value="<cfoutput>#attributes.req_type_id#</cfoutput>">
            </cfif>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='29764.Form'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)><cfoutput>#get_quiz.quiz_head#</cfoutput><cfelseif isdefined("attributes.req_type_id") and len(attributes.req_type_id)><cfoutput>#get_quiz.REQ_TYPE#</cfoutput></cfif>
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57995.Bölüm'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <textarea name="CHAPTER" id="CHAPTER"></textarea>
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <textarea name="CHAPTER_INFO" id="CHAPTER_INFO"></textarea>
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id="29784.Ağırlık"> %</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="38677.Ağırlık için 0 ile 100 arasında bir sayı giriniz">!</cfsavecontent>
                    <cfinput type="text" name="chapter_weight" value="" validate="float" message="#message#" required="yes" range="0,100" onkeyup="return(FormatCurrency(this,event));">
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <label class="bold"><cf_get_lang dictionary_id="46689.Aktif (Seçili ise forma aşağıda girilen başlık ile Açıklama alanı eklenir!)"></label>
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id="36199.Açıklama">-1</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12">
                        <input type="checkbox" name="is_exp1" id="is_exp1">
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <input type="text" name="exp1_name" id="exp1_name" maxlength="200" value="">
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_emp_exp1" id="is_emp_exp1"><cf_get_lang dictionary_id='57576.Çalışan'><!--- checkbox işaretli ise çalışana açıklama alanı gösterilmez ---></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief3_exp1" id="is_chief3_exp1"><cf_get_lang dictionary_id='29908.Görüş Bildiren'><!--- checkbox işaretli ise görüş bildirene açıklama alanı gösterilmez ---></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief1_exp1" id="is_chief1_exp1"><cf_get_lang dictionary_id="35927.1.Amir"><!--- checkbox işaretli ise g1.amire açıklama alanı gösterilmez ---></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief2_exp1" id="is_chief2_exp1"><cf_get_lang dictionary_id="35921.2.Amir"><!--- checkbox işaretli ise 2.amire açıklama alanı gösterilmez ---></label>
                    </div>
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id="36199.Açıklama">-2</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12">
                        <input type="checkbox" name="is_exp2" id="is_exp2">
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <input type="text" name="exp2_name" id="exp2_name" maxlength="200" value="">
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_emp_exp2" id="is_emp_exp2"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief3_exp2" id="is_chief3_exp2"><cf_get_lang dictionary_id='29908.Görüş Bildiren'></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief1_exp2" id="is_chief1_exp2"><cf_get_lang dictionary_id="35927.1.Amir"></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief2_exp2" id="is_chief2_exp2"><cf_get_lang dictionary_id="35921.2.Amir"></label>
                    </div>
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id="36199.Açıklama">-3</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12">
                        <input type="checkbox" name="is_exp3" id="is_exp3">
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <input type="text" name="exp3_name" id="exp3_name" maxlength="200" value="">
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_emp_exp3" id="is_emp_exp3"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief3_exp3" id="is_chief3_exp3"><cf_get_lang dictionary_id='29908.Görüş Bildiren'></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief1_exp3" id="is_chief1_exp3"><cf_get_lang dictionary_id="35927.1.Amir"></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief2_exp3" id="is_chief2_exp3"><cf_get_lang dictionary_id="35921.2.Amir"></label>
                    </div>
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id="36199.Açıklama">-4</label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-1 col-md-1 col-sm-1 col-xs-12">
                        <input type="checkbox" name="is_exp4" id="is_exp4">
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <input type="text" name="exp4_name" id="exp4_name" maxlength="200" value="">
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_emp_exp4" id="is_emp_exp4"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief3_exp4" id="is_chief3_exp4"><cf_get_lang dictionary_id='29908.Görüş Bildiren'></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief1_exp4" id="is_chief1_exp4"><cf_get_lang dictionary_id="35927.1.Amir"></label>
                    </div>
                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                        <label><input type="checkbox" name="is_chief2_exp4" id="is_chief2_exp4"><cf_get_lang dictionary_id="35921.2.Amir"></label>
                    </div>
                </div>
            </div>

            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='55288.Tasarım Tipi'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><input type="radio" name="answer_type" id="answer_type" value="1" onclick="goster2(1);"><cf_get_lang dictionary_id='55294.Cevaplar Yan Yana'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <label><input type="radio" name="answer_type" id="answer_type" value="2" onclick="goster2(2);"><cf_get_lang dictionary_id='55295.Cevaplar Alt Alta'></label>
                    </div>
                </div>
            </div>

            <div id="answers" class="form-group col col-8 col-md-8 col-sm-8 col-xs-12" style="display:none;">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='55289.Şık Sayısı'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
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
                </div>
            </div>

            <cfloop from="0" to="19" index="i">
                <div id="answer<cfoutput>#i#</cfoutput>" style="display:none;">
                    <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <label class="bold"><cf_get_lang dictionary_id='29782.Şık'>&nbsp;<cfoutput>#evaluate(i+1)#</cfoutput></label>
                        </div>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="0">
                                <textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text"></textarea>
                            </div>
                            <div class="col col-1 col-md-1 col-sm-1 col-xs-12">
                                <cf_get_lang dictionary_id='58984.Puan'>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <input type="text" name="answer<cfoutput>#i#</cfoutput>_point" id="answer<cfoutput>#i#</cfoutput>_point" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                            <div class="col col-1 col-md-1 col-sm-1 col-xs-12">
                                <cf_get_lang dictionary_id='58080.Resim'>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <input type="File" id="answer<cfoutput>#i#</cfoutput>_photo" name="answer<cfoutput>#i#</cfoutput>_photo">
                            </div>
                        </div>
                    </div>
                </div>
            </cfloop>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-12">
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	document.add_quiz_chapter.chapter_weight.value=filterNum(document.add_quiz_chapter.chapter_weight.value);
	<cfloop from="0" to="19" index="i">
		<cfoutput>
			document.add_quiz_chapter.answer#i#_point.value=filterNum(document.add_quiz_chapter.answer#i#_point.value);
		</cfoutput>
	</cfloop>
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

function goster2(number)
{
    $("#answers").show();
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
</script>


