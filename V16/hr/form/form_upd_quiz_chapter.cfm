<cfinclude template="../query/get_quiz_chapter.cfm">
<cfset pageHead="#GET_QUIZ_CHAPTER.CHAPTER#">
<cfif not isdefined("attributes.modal_id")>
<cf_catalystHeader>
    </cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box  popup_box="1" title="#getLang('main',675)#">
        <cfform enctype="multipart/form-data" name="upd_CHAPTER" method="post" action="#request.self#?fuseaction=hr.upd_quiz_chapter">
            <cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>
            <input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
            <cfelseif isdefined("attributes.req_type_id") and len(attributes.req_type_id)>
                <input type="hidden" name="req_type_id" id="req_type_id" value="<cfoutput>#attributes.req_type_id#</cfoutput>">
            </cfif>
            <input type="Hidden" name="CHAPTER_id" id="CHAPTER_id" value="<cfoutput>#attributes.CHAPTER_id#</cfoutput>">
            <cfif IsDefined("attributes.answertype")>
                <input type="Hidden" name="answertype" id="answertype" value="1">
            </cfif>
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="CHAPTER" id="CHAPTER" style="width:300px;height:60px;"><cfoutput>#get_quiz_chapter.CHAPTER#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="CHAPTER_INFO" id="CHAPTER_INFO"  style="width:300px;height:100px;"><cfoutput>#get_quiz_chapter.CHAPTER_info#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29784.Ağırlık"> (%</label>
                        <div class="col col-4 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="38677.Ağırlık için 0 ile 100 arasında bir sayı giriniz"></cfsavecontent>
                            <cfinput type="text" name="chapter_weight" value="#TLFormat(get_quiz_chapter.chapter_weight,1)#" validate="float" style="width:50px" message="#message#" required="yes" range="0,100" onkeyup="return(FormatCurrency(this,event));">
                        </div>
                    </div>
                    <cfif not IsDefined("attributes.answertype")>
                        <div class="form-group" id="item-answer_number">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55289.şık sayısı'></label>
                            <div class="col col-4 col-xs-12">
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
                            </div>
                        </div>
                    <cfelse>
                        <input type="Hidden" name="answer_number" id="answer_number" value="0">
                    </cfif>
                </div>
                <label class="col col-12 bold"><cf_get_lang dictionary_id="46689.Aktif (Seçili ise forma aşağıda girilen başlık ile Açıklama alanı eklenir)"></label>
              
                    <div class="col col-12" type="column" index="2" sort="true">
                        <div class="form-group">
                            <label class="col col-4"><cf_get_lang dictionary_id="59067.Açıklama">-1</label>
                        <div class="col col-1">
                            <input type="checkbox" name="is_exp1" id="is_exp1" <cfif 1 IS get_quiz_chapter.is_exp1>checked</cfif>>
                        </div>
                        <div class="col col-3">
                            <input type="text" name="exp1_name" id="exp1_name" maxlength="200" value="<cfif len(get_quiz_chapter.exp1_name)><cfoutput>#get_quiz_chapter.exp1_name#</cfoutput></cfif>" style="width:230px;">
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_emp_exp1" id="is_emp_exp1" <cfif 1 IS get_quiz_chapter.is_emp_exp1>checked</cfif>>Çal.</label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief3_exp1" id="is_chief3_exp1" <cfif 1 IS get_quiz_chapter.is_chief3_exp1>checked</cfif>>Gör.</label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief1_exp1" id="is_chief1_exp1" <cfif 1 IS get_quiz_chapter.is_chief1_exp1>checked</cfif>><cf_get_lang dictionary_id="35927.1.Amir"></label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief2_exp1" id="is_chief2_exp1" <cfif 1 IS get_quiz_chapter.is_chief2_exp1>checked</cfif>><cf_get_lang dictionary_id="35921.2.Amir"></label>
                            </div>
                        </div>
                    </div>
             
                    <div class="col col-12" type="column" index="3" sort="true">
                        <div class="form-group">
                            <label class="col col-4"><cf_get_lang dictionary_id="59067.Açıklama">-2</label>
                            <div class="col col-1"><input type="checkbox" name="is_exp2" id="is_exp2" <cfif 1 IS get_quiz_chapter.is_exp2>checked</cfif>></div>
                        <div class="col col-3">
                            <input type="text" name="exp2_name" id="exp2_name" maxlength="200" value="<cfif len(get_quiz_chapter.exp2_name)><cfoutput>#get_quiz_chapter.exp2_name#</cfoutput></cfif>" style="width:230px;">
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_emp_exp2" id="is_emp_exp2" <cfif 1 IS get_quiz_chapter.is_emp_exp2>checked</cfif>>Çal.</label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief3_exp2" id="is_chief3_exp2" <cfif 1 IS get_quiz_chapter.is_chief3_exp2>checked</cfif>>Gör.</label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief1_exp2" id="is_chief1_exp2" <cfif 1 IS get_quiz_chapter.is_chief1_exp2>checked</cfif>><cf_get_lang dictionary_id="35927.1.Amir"></label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief2_exp2" id="is_chief2_exp2" <cfif 1 IS get_quiz_chapter.is_chief2_exp2>checked</cfif>><cf_get_lang dictionary_id="35921.2.Amir"></label>
                        </div>
                    </div>
                </div>
               
                    <div class="col col-12" type="column" index="4" sort="true">
                        <div class="form-group">
                            <label class="col col-4"><cf_get_lang dictionary_id="59067.Açıklama">-3</label>
                       
                        <div class="col col-1">
                            <input type="checkbox" name="is_exp3" id="is_exp3" <cfif 1 IS get_quiz_chapter.is_exp3>checked</cfif>>
                        </div>
                        <div class="col col-3">
                            <input type="text" name="exp3_name" id="exp3_name" maxlength="200" value="<cfif len(get_quiz_chapter.exp2_name)><cfoutput>#get_quiz_chapter.exp3_name#</cfoutput></cfif>" style="width:230px;">
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_emp_exp3" id="is_emp_exp3" <cfif 1 IS get_quiz_chapter.is_emp_exp3>checked</cfif>>Çal.</label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief3_exp3" id="is_chief3_exp3" <cfif 1 IS get_quiz_chapter.is_chief3_exp3>checked</cfif>>Gör.</label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief1_exp3" id="is_chief1_exp3" <cfif 1 IS get_quiz_chapter.is_chief1_exp3>checked</cfif>><cf_get_lang dictionary_id="35927.1.Amir"></label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief2_exp3" id="is_chief2_exp3" <cfif 1 IS get_quiz_chapter.is_chief2_exp3>checked</cfif>><cf_get_lang dictionary_id="35921.2.Amir"></label>
                        </div>
                    </div>
                </div>
               
                    <div class="col col-12" type="column" index="5" sort="true">
                        <div class="form-group">
                            <label class="col col-4"><cf_get_lang dictionary_id="59067.Açıklama">-4</label>
                      
                        <div class="col col-1">
                            <input type="checkbox" name="is_exp4" id="is_exp4" <cfif 1 IS get_quiz_chapter.is_exp4>checked</cfif>>
                        </div>
                        <div class="col col-3">
                            <input type="text" name="exp4_name" id="exp4_name" maxlength="200" value="<cfif len(get_quiz_chapter.exp4_name)><cfoutput>#get_quiz_chapter.exp4_name#</cfoutput></cfif>" style="width:230px;">
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_emp_exp4" id="is_emp_exp4" <cfif 1 IS get_quiz_chapter.is_emp_exp4>checked</cfif>>Çal.</label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief3_exp4" id="is_chief3_exp4" <cfif 1 IS get_quiz_chapter.is_chief3_exp4>checked</cfif>>Gör.</label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief1_exp4" id="is_chief1_exp4" <cfif 1 IS get_quiz_chapter.is_chief1_exp4>checked</cfif>><cf_get_lang dictionary_id="35927.1.Amir"></label>
                        </div>
                        <div class="col col-1">
                            <label><input type="checkbox" name="is_chief2_exp4" id="is_chief2_exp4" <cfif 1 IS get_quiz_chapter.is_chief2_exp4>checked</cfif>><cf_get_lang dictionary_id="35921.2.Amir"></label>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="6" id="item-question">
                        
                    <cfloop from="0" to="#evaluate(get_quiz_chapter.answer_number-1)#" index="i">
                        <div id="answer<cfoutput>#i#</cfoutput>" style="display:none;">
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'> <cfoutput>#evaluate(i+1)#</cfoutput></label>
                        <!---     <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55291.Yazı'></label> --->
                            <div class="col col-8 col-xs-12">
                                <textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" style="width:250px;height:60px;"><cfoutput>#evaluate("get_quiz_chapter.answer"&i+1&"_text")#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="answer<cfoutput>#i#</cfoutput>_point" id="answer<cfoutput>#i#</cfoutput>_point" style="width:250px;" value='<cfoutput>#tlformat(evaluate("get_quiz_chapter.answer"&i+1&"_point"))#</cfoutput>' onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'></label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(evaluate("get_quiz_chapter.answer"&i+1&"_photo"))>
                                <!---  <img src="<cfoutput>#file_web_path#hr/#evaluate("get_quiz_chapter.answer"&i+1&"_photo")#</cfoutput>" border="0"> --->
                                <cf_get_server_file output_file="hr/#evaluate("get_quiz_chapter.answer"&i+1&"_photo")#" output_server="#evaluate("get_quiz_chapter.answer"&i+1&"_photo_server_id")#" output_type="0"   image_link="1"><br/> 
                                <!--- <a href="<cfoutput>#file_web_path#hr/#evaluate("get_quiz_chapter.answer"&i+1&"_photo")#</cfoutput>" target="_blank"><cfoutput>#evaluate("get_quiz_chapter.answer"&i+1&"_photo")#</cfoutput>
                                </a> --->
                                <input type="Checkbox" name="del_image<cfoutput>#i#</cfoutput>" id="del_image<cfoutput>#i#</cfoutput>" value="1">
                                <cf_get_lang dictionary_id="42592.Resmi sil"> <br/>
                                </cfif>
                                <input type="File" id="answer<cfoutput>#i#</cfoutput>_photo" name="answer<cfoutput>#i#</cfoutput>_photo" id="answer<cfoutput>#i#</cfoutput>_photo">
                            </div>
                        </div>
                    </div>
                    </cfloop>
                    <cfloop from="#get_quiz_chapter.answer_number#" to="19" index="i">
                    <div id="answer<cfoutput>#i#</cfoutput>" <cfif #i# eq 0>style="display:none;"<cfelse>style="display"</cfif>>
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'> <cfoutput>#evaluate(i+1)#</cfoutput></label>
                        <!---  <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55291.Yazı'></label> --->
                            <div class="col col-8 col-xs-12">
                                <input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="">
                            </div>
                        </div>
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="answer<cfoutput>#i#</cfoutput>_point" id="answer<cfoutput>#i#</cfoutput>_point" style="width:250px;" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'></label>
                            <div class="col col-8 col-xs-12">
                                <input type="File" id="answer<cfoutput>#i#</cfoutput>_photo" name="answer<cfoutput>#i#</cfoutput>_photo" style="width:250px;">
                            </div>
                        </div>
                    </div>
                    </cfloop>
                </div>
               
               
                  
               
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function goster(number)
{
    /* sayı seçilenin 1 eksiği geliyor*/
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


<cfif evaluate(get_quiz_chapter.answer_number) neq 0>
		document.upd_CHAPTER.answer_number.selectedIndex = <cfoutput>#evaluate(get_quiz_chapter.answer_number-1)#</cfoutput>;
		goster(<cfoutput>#evaluate(get_quiz_chapter.answer_number-1)#</cfoutput>);
	</cfif>
function kontrol()
{
	document.upd_CHAPTER.chapter_weight.value=filterNum(document.upd_CHAPTER.chapter_weight.value);
	<cfoutput>
		<cfloop from="0" to="19" index="i">
			document.upd_CHAPTER.answer#i#_point.value=filterNum(document.upd_CHAPTER.answer#i#_point.value);
		</cfloop>
	</cfoutput>
	return true;
}


function goster2(number)

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

