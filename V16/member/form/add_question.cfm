<cfquery name="getMaxPoint" datasource="#dsn#">
    SELECT 
        SUM(TOTAL) TOTAL_QUESTION,
        (SELECT TOTAL_POINTS FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = 1) AS MAX
    FROM
        (
        SELECT
            ISNULL((CASE WHEN QUESTION_TYPE = 1 THEN (SELECT MAX(ANSWER_POINT) FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = MQ.QUESTION_ID) END),0)+ISNULL((CASE WHEN QUESTION_TYPE = 2 THEN (SELECT SUM(ANSWER_POINT) FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = MQ.QUESTION_ID) END ),0) AS TOTAL	
        FROM 
                MEMBER_QUESTION MQ
        WHERE 
                ANALYSIS_ID = #attributes.analysis_id#
        )AS TABLO
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Yeni Soru Ekle',55849)#" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform enctype="multipart/form-data" name="add_question" method="post" action="#request.self#?fuseaction=member.emptypopup_add_question">
			<input type="hidden" name="analysis_id" id="analysis_id" value="<cfoutput>#attributes.analysis_id#</cfoutput>">
			<div class="ui-scroll">
				<cf_box_elements>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-question">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58810.Soru'> *</label>
							<div class="col col-8 col-xs-12"> 
								<textarea name="question" id="question"></textarea>
							</div>
						</div>
						<div class="form-group" id="itemquestion_info">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12"> 
								<textarea name="question_info" id="question_info"></textarea>
							</div>
						</div>
						<div class="form-group" id="item-question_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="question_type" id="question_type" onchange="gizle(this.selectedIndex)">
									<option value="1"><cf_get_lang dictionary_id='30178.Tek Cevaplı'></option>
									<option value="2"><cf_get_lang dictionary_id='30398.Çok Cevaplı'></option>
									<option value="3"><cf_get_lang dictionary_id='30296.Açık Uçlu Soru'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-answer_number">
							<label class="col col-4 col-xs-12" id="answer_number1"><cf_get_lang dictionary_id='30433.Şık Sayısı'></label>
							<div class="col col-8 col-xs-12" id="answer_number2"> 
								<select name="answer_number" id="answer_number" onChange="goster(this.selectedIndex);">
									<cfloop from="0" to="50" index="i">
										<cfif i neq 1>
											<cfoutput><option value="#i#">#NumberFormat(i,00)#</option></cfoutput>
										</cfif>
									</cfloop>
								</select>
							</div>
						</div>
						<cfloop from="0" to="50" index="i">
							<cfoutput>
								<div class="row" id="answer#i#" style="display:none;">
									<cfsavecontent variable="title"><cf_get_lang dictionary_id='29782.Şık'>#evaluate(i+1)#</cfsavecontent>
									<cf_seperator title="#title#" id="form_#evaluate(i+1)#">
									<div id="form_#evaluate(i+1)#">
										<input type="hidden" name="answer#i#_type" id="answer#i#_type" value="0">
										<div class="form-group" id="item-answer#i#_text">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'></label>
											<div class="col col-8 col-xs-12"> 
												<textarea name="answer#i#_text" id="answer#i#_text" cols="35" rows="3"></textarea>
											</div>
										</div>
										<div class="form-group" id="itemanswer#i#_info-">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
											<div class="col col-8 col-xs-12"> 
												<textarea name="answer#i#_info" id="answer#i#_info" cols="35" rows="3"></textarea>
											</div>
										</div>
										<div class="form-group" id="item-answer#i#_point">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
											<div class="col col-8 col-xs-12"> 
												<cfinput type="text" name="answer#i#_point" onKeyUp="isNumber(this)" maxlength="20">
											</div>
										</div>
										<div class="form-group" id="item-answer#i#_photo">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'></label>
											<div class="col col-8 col-xs-12"> 
												<input type="file" name="answer#i#_photo" id="answer#i#_photo">
											</div>
										</div>
										<div class="form-group" id="item-answer#i#_product_name">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30427.Ürün Önerisi'></label>
											<div class="col col-8 col-xs-12"> 
												<div class="input-group">
													<input type="hidden" name="answer#i#_product_id" id="answer#i#_product_id" value="">
													<input type="text" name="answer#i#_product_name" id="answer#i#_product_name" value="" readonly="yes">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=add_question.answer#i#_product_id&field_name=add_question.answer#i#_product_name','list','popup_product_names');" title="<cf_get_lang dictionary_id='30416.Ürün Seç'>"></span>
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
					<cf_workcube_buttons is_upd='0' is_cancel='0' add_function="checkmax()"> 		
				</div> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function goster(number)
{
	if (number!=0)
	{
		for (i=0;i<=number;i++)
		{
			eleman = eval("answer"+i);
			eleman.style.display = "";
		}
		for (i=number+1;i<=49;i++)
		{
			eleman = eval("answer"+i);
			eleman.style.display = "none";
		}
	}
	else
	{
		for (i=0;i<=49;i++)
		{
			eleman = eval("answer"+i);
			eleman.style.display = "none";
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
function checkmax()
	{
		if (i == 1){
			document.add_question.more.value=1;
		}
		else {
			document.add_question.more.value=0;
		}
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
				for (i=0;i<51;i++)
				{		
					id = "answer"+i+"_point";
					eleman = document.getElementById(id);
					if (!isNaN(eleman.value) && eleman.value != "")		
						if( parseInt(eleman.value) > max_point)
							max_point = parseInt(eleman.value);
				}				
			}
		else if (option == 2 || option == 3)
			{
				for (i=0;i<51;i++)
				{		
					id = "answer"+i+"_point";
					eleman = document.getElementById(id);
					if (!isNaN(eleman.value) && eleman.value != "")		
					total = total + parseInt(eleman.value);
				}
			}
		var limit = 0;
        <cfif len(getMaxPoint.MAX)>
            limit = <cfoutput>#getMaxPoint.MAX#</cfoutput>;
        </cfif>
		/* var previous_total = <cfif len(getMaxPoint.TOTAL_QUESTION)><cfoutput>#getMaxPoint.TOTAL_QUESTION#</cfoutput><cfelse>0</cfif>;
		var avaliable_point = limit - previous_total;
		if(avaliable_point == 0)
			{
				alert("<cf_get_lang dictionary_id='59892.Soru oluşturmak için yeterli puanınız yok'>!");
				return false;
			}
		else if (total > avaliable_point || max_point > avaliable_point)
			{
				alert('<cf_get_lang dictionary_id ="59893.Sorudan kazanılacak maksimum puan">:' + avaliable_point);
				return false;
			} */
	}
</script>
