<cfinclude template="../query/get_analysis_questions.cfm">
<cfquery name="get_result_control" datasource="#dsn#">
	SELECT TOP 1 RESULT_ID FROM MEMBER_ANALYSIS_RESULTS WHERE ANALYSIS_ID = #analysis_id#
</cfquery>
<cfquery name="getMaxPoint" datasource="#dsn#">
     SELECT 
        SUM(TOTAL) TOTAL_QUESTION,
        ISNULL((SELECT 
			CASE 
				 WHEN QUESTION_TYPE = 1 THEN (SELECT MAX(ANSWER_POINT) FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = #attributes.question_id#)
				 WHEN QUESTION_TYPE = 2 THEN (SELECT SUM(ANSWER_POINT) FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = #attributes.question_id#)
                 WHEN QUESTION_TYPE = 3 THEN (SELECT SUM(ANSWER_POINT) FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = #attributes.question_id#)
			 END
		FROM
			MEMBER_QUESTION
		WHERE 
        	QUESTION_ID = #attributes.question_id#),0) AS CURRENT_QUESTION ,
        (SELECT TOTAL_POINTS FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = 1) AS MAX
    FROM
        (
        SELECT
			QUESTION_ID,
            ISNULL((CASE WHEN QUESTION_TYPE = 1 THEN (SELECT MAX(ANSWER_POINT) FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = MQ.QUESTION_ID) END),0)+ISNULL((CASE WHEN QUESTION_TYPE = 2 THEN (SELECT SUM(ANSWER_POINT) FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = MQ.QUESTION_ID) END ),0) AS TOTAL	
        FROM 
                MEMBER_QUESTION MQ
        WHERE 
                ANALYSIS_ID = #attributes.analysis_id#
        )AS TABLO
</cfquery>
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
            for (i=number+1;i<=49;i++)
            {
                eleman = eval('answer'+i);
                eleman.style.display = 'none';
            }
        }
        else
        {
            for (i=0;i<=49;i++)
            {
                eleman = eval('answer'+i);
                eleman.style.display = 'none';
            }
        }
    }
    function gizle(id)
    {
        if(id == 2)
        {
            answer_number1.style.display = 'none';
            answer_number2.style.display = 'none';
        }
        else
        {
            answer_number1.style.display = '';
            answer_number2.style.display = '';
        }
        document.getElementById('answer_number').value = 0;
        return goster(0);
    }
</script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Soru Güncelle',55852)#" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform enctype="multipart/form-data" name="upd_question" id="upd_question" method="post" action="#request.self#?fuseaction=member.emptypopup_upd_question">
            <input type="hidden" name="question_id" id="question_id" value="<cfoutput>#attributes.question_id#</cfoutput>">
            <input type="hidden" name="analysis_id" id="analysis_id" value="<cfoutput>#attributes.analysis_id#</cfoutput>">
			<div class="ui-scroll">
                <cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-question">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58810.Soru'> *</label>
                            <div class="col col-8 col-xs-12"> 
                                <textarea name="question" id="question"><cfoutput>#get_analysis_questions.question#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="itemquestion_info">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12"> 
                                <textarea name="question_info" id="question_info"><cfoutput>#get_analysis_questions.question_info#</cfoutput></textarea>
                            </div>
                        </div>
                        <div class="form-group" id="item-question_type">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                            <div class="col col-8 col-xs-12"> 
                                <select name="question_type" id="question_type" onchange="gizle(this.selectedIndex)" <cfif get_result_control.recordcount>disabled="disabled"</cfif>>
                                    <option value="1" <cfif get_analysis_questions.question_type eq 1> selected</cfif>><cf_get_lang dictionary_id='30178.Tek Cevaplı'></option>
                                    <option value="2" <cfif get_analysis_questions.question_type eq 2> selected</cfif>><cf_get_lang dictionary_id='30398.Çok Cevaplı'></option>
                                    <option value="3" <cfif get_analysis_questions.question_type eq 3> selected</cfif>><cf_get_lang dictionary_id='30296.Açık Uçlu Soru'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-answer_number">
                            <label class="col col-4 col-xs-12" id="answer_number1" <cfif get_analysis_questions.question_type eq 3>style="display:none"</cfif>><cf_get_lang dictionary_id='30433.Şık Sayısı'></label>
                            <div class="col col-8 col-xs-12" id="answer_number2" <cfif get_analysis_questions.question_type eq 3>style="display:none"</cfif>> 
                                <select name="answer_number" id="answer_number" onChange="goster(this.selectedIndex);" <cfif get_result_control.recordcount>disabled="disabled"</cfif>>
                                    <cfloop from="0" to="50" index="i">
                                    <cfif i neq 1>
                                        <cfoutput><option value="#i#">#NumberFormat(i,00)#</option></cfoutput></cfif>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <cfinclude template="../query/get_question_answers.cfm">
                        <cfif get_question_answers.recordcount>
                            <cfset satir_index = 0>
                            <cfloop query="get_question_answers">
                                <cfoutput>
                                    <div class="row" id="answer#satir_index#">
                                        <input type="hidden" name="answer#satir_index#_type" id="answer#satir_index#_type" value="0">
                                        <cfsavecontent variable="title"><cf_get_lang dictionary_id='29782.Şık'>#evaluate(currentrow)#</cfsavecontent>
                                        <cf_seperator title="#title#" id="form_#evaluate(currentrow)#">
                                        <div id="form_#evaluate(currentrow)#">
                                            <div class="form-group" id="item-answer#satir_index#_text">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'></label>
                                                <div class="col col-8 col-xs-12"> 
                                                    <cfset temp_text = evaluate("get_question_answers.answer_text")>
                                                    <textarea name="answer#satir_index#_text" id="answer#satir_index#_text" cols="35" rows="3">#temp_text#</textarea>
                                                </div>
                                            </div>
                                            <div class="form-group" id="itemanswer#satir_index#_info-">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                                <div class="col col-8 col-xs-12"> 
                                                    <cfset temp_text_info = evaluate("get_question_answers.answer_info")>
                                                    <textarea name="answer#satir_index#_info" id="answer#satir_index#_info">#temp_text_info#</textarea>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-answer#satir_index#_point">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
                                                <div class="col col-8 col-xs-12"> 
                                                    <cfset temp_point = evaluate("get_question_answers.answer_point")>
                                                    <input type="text" name="answer#satir_index#_point" id="answer#satir_index#_point" onkeyup="isNumber(this);" value="#temp_point#" maxlength="20" <cfif get_result_control.recordcount>readonly</cfif>>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-answer#satir_index#_photo">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'></label>
                                                <div class="col col-8 col-xs-12"> 
                                                    <cfif len(evaluate("get_question_answers.answer_photo"))>
                                                        <cf_get_server_file output_file="member/#evaluate("get_question_answers.answer_photo")#" output_server="#evaluate("get_question_answers.answer_photo_server_id")#" output_type="0" image_width="38" image_height="35" image_link="1">
                                                        <br/><input type="Checkbox" name="del_image#satir_index#" id="del_image#satir_index#" value="1"><cf_get_lang dictionary_id='30274.Fotoğrafı Sil'><br/>
                                                    </cfif>
                                                    <input type="file" name="answer#satir_index#_photo" id="answer#satir_index#_photo" <cfif get_result_control.recordcount>readonly="readonly"</cfif>>
                                                </div>
                                            </div>
                                            <div class="form-group" id="item-answer#satir_index#_product_name">
                                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30427.Ürün Önerisi'></label>
                                                <div class="col col-8 col-xs-12"> 
                                                    <div class="input-group">
                                                        <input type="hidden" name="answer#satir_index#_product_id" id="answer#satir_index#_product_id" value="#evaluate('get_question_answers.answer_product_id')#">
                                                        <cfif len(evaluate('get_question_answers.answer_product_id'))>
                                                            <cfset product_id = evaluate('get_question_answers.answer_product_id')>
                                                            <cfinclude template="../query/get_product_name.cfm">
                                                            <input type="text" name="answer#satir_index#_product_name" id="answer#satir_index#_product_name" value="<cfif get_product_name.recordCount>#get_product_name.product_name#</cfif>" readonly="yes">     
                                                        <cfelse>
                                                            <input type="text" name="answer#satir_index#_product_name" id="answer#satir_index#_product_name" value="" readonly="yes">     
                                                        </cfif> 
                                                        <cfif not get_result_control.recordcount>
                                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=upd_question.answer#satir_index#_product_id&field_name=upd_question.answer#satir_index#_product_name','list','popup_product_names');" title="<cf_get_lang dictionary_id='30416.Ürün Seç'>"></span>
                                                        </cfif>
                                                    </div>
                                                </div>
                                            </div>   
                                        </div>  
                                    </div>
                                </cfoutput>
                                <cfset satir_index = satir_index+1>
                            </cfloop>
                        </cfif>
                        <cfloop from="#get_analysis_questions.answer_number#" to="49" index="i">
                            <cfoutput>
                                <div class="row" id="answer#i#" style="display:none;">
                                    <input type="hidden" name="answer#i#_type" id="answer#i#_type" value="">
                                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='29782.Şık'>#evaluate(i+1)#</cfsavecontent>
                                    <cf_seperator title="#title#" id="form_#evaluate(i+1)#">
                                    <div id="form_#evaluate(i+1)#">                              
                                        <div class="form-group" id="item-answer#i#_text">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'></label>
                                            <div class="col col-8 col-xs-12"> 
                                                <textarea name="answer#i#_text" id="answer#i#_text" cols="35" rows="3"></textarea>
                                            </div>
                                        </div>                                   
                                        <div class="form-group" id="itemanswer#i#_info-">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                            <div class="col col-8 col-xs-12"> 
                                                <textarea name="answer#i#_info" id="answer#i#_info"></textarea>
                                            </div>
                                        </div>                                   
                                        <div class="form-group" id="item-answer#i#_point">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
                                            <div class="col col-8 col-xs-12"> 
                                                <input type="text" name="answer#i#_point" id="answer#i#_point" value="" <cfif get_result_control.recordcount>readonly</cfif>>
                                            </div>
                                        </div>                                     
                                        <div class="form-group" id="item-answer#i#_photo">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'></label>
                                            <div class="col col-8 col-xs-12"> 
                                                <input type="file" name="answer#i#_photo" id="answer#i#_photo" <cfif get_result_control.recordcount> readonly="readonly"</cfif>>
                                            </div>
                                        </div>                                    
                                        <div class="form-group" id="item-answer#i#_product_name">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30427.Ürün Önerisi'></label>
                                            <div class="col col-8 col-xs-12"> 
                                                <div class="input-group">
                                                    <input type="hidden" name="answer#i#_product_id" id="answer#i#_product_id" value="">
                                                    <input type="text" name="answer#i#_product_name" id="answer#i#_product_name" value="" <cfif get_result_control.recordcount>readonly="readonly"</cfif>>     
                                                    <cfif not get_result_control.recordcount>
                                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=upd_question.answer#i#_product_id&field_name=upd_question.answer#i#_product_name','list','popup_product_names');" title="<cf_get_lang dictionary_id='30416.Ürün Seç'>"></span>
                                                    </cfif>
                                                </div>
                                            </div>
                                        </div>       
                                    </div>                             
                                </div>
                            </cfoutput>
                        </cfloop>
                    </div>
                </cf_box_elements>
            </div>
            <cf_box_footer>	
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <input type="hidden" name="more" id="more" value="0">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='30719.Guncelle ve Yeni Soru Ekle'></cfsavecontent>
                    <cfif not get_result_control.recordcount>
                        <cf_workcube_buttons is_upd='0' insert_info='#message#' is_cancel='0' add_function="checkmax('1')"> 
                    </cfif>
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function="checkmax('0')">
                </div> 
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	<cfif evaluate(get_analysis_questions.answer_number) neq 0>
		document.upd_question.answer_number.selectedIndex = <cfoutput>#evaluate(get_analysis_questions.answer_number-1)#</cfoutput>;
		goster(<cfoutput>#evaluate(get_analysis_questions.answer_number-1)#</cfoutput>);
	</cfif>
</script>
<cfset total_withoutthis = getMaxPoint.TOTAL_QUESTION - getMaxPoint.CURRENT_QUESTION>
<script type="text/javascript">
	function checkmax(id)
	{
        $('#more').val(id);
        
		if(document.getElementById('question').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58810.Soru'>!");
			return false;
		}
		if(document.getElementById('question_type').value != 3 && document.getElementById('answer_number').value == 0)
		{
			alert('<cf_get_lang dictionary_id="30433.Şık Sayısı"> : <cf_get_lang dictionary_id='506.Girilen Miktar 0 Olamaz'>!');
			return false;
		}

		var selectbox = document.getElementById('question_type');
		var option = selectbox.options[selectbox.selectedIndex].value;
		var total = 0;
		var max_point = 0;
	
		if (option == 1)
        {
            for (i=0;i<<cfoutput>#get_question_answers.recordcount#</cfoutput>;i++)
            {
                id = "answer"+i+"_point";
                eleman = document.getElementById(id);
                    if( parseInt(eleman.value) > max_point)
                        max_point = parseInt(eleman.value);			
            }				
        }
		else if(option == 2 || option == 3)
				{
					for (i=0;i<<cfoutput>#get_question_answers.recordcount#</cfoutput>;i++)
						{		
							id = "answer"+i+"_point";
							eleman = document.getElementById(id);
							total = total + parseInt(eleman.value);
						}
				}
        /* var limit = 0;
        <cfif len(getMaxPoint.MAX)>
            limit = <cfoutput>#getMaxPoint.MAX#</cfoutput>;
        </cfif>
		var previous_total = <cfoutput>#total_withoutthis#</cfoutput>;
		var avaliable_point = limit - previous_total;
		
		if (total > avaliable_point || max_point > avaliable_point)
			{
			alert('Girdiğiniz puanlar ' + avaliable_point + ' puandan fazla olamaz');
			return false;
			}
		else
			return true; */
	}
</script>
