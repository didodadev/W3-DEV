<cfinclude template="../query/get_quiz_chapter.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="46312.Soru Ekle"></cfsavecontent>
  <div class="col col-12 col-md-12 col-sm-12 col-xs-12 ">
	<cf_box title="#GET_QUIZ_CHAPTER.CHAPTER# - #message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform enctype="multipart/form-data" name="add_question" method="post" action="#request.self#?fuseaction=hr.add_question">
			<cfif isdefined("attributes.quiz_id")>
				<input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
			<cfelseif isdefined("attributes.req_type_id") and len(attributes.req_type_id)>
				<input type="Hidden" name="req_type_id" id="req_type_id" value="<cfoutput>#attributes.req_type_id#</cfoutput>">
			</cfif>
			<input type="Hidden" name="CHAPTER_id" id="CHAPTER_id" value="<cfoutput>#attributes.CHAPTER_id#</cfoutput>">
			<cfif IsDefined("attributes.answertype")>
			<input type="Hidden" name="answertype" id="answertype" value="1">
			</cfif>
			<cf_box_elements>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-question">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58810.Soru'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="question" id="question" style="width:250px;height:40px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-QUESTION_INFO">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="QUESTION_INFO" id="QUESTION_INFO" style="width:250px;height:40px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-open_ended">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="29796.Açık Uçlu"></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" name="open_ended" id="open_ended" value="1" onclick="answershow()">
						</div>
					</div>
					<cfif not IsDefined("attributes.answertype")>
						<div class="form-group" id="item-answer_number">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55289.şık sayısı'></label>
							<div class="col col-4 col-xs-12">
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
					<cfloop from="0" to="19" index="i">
						<div id="answer<cfoutput>#i#</cfoutput>" style="display:none;">
							<div class="col col-12 ui-form-list-btn">
								<div class="form-group" id="item-">&nbsp;
								</div>
							</div>
							<input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="0">
							
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29782.Şık'> <cfoutput>#evaluate(i+1)#</cfoutput></label>
								<div class="col col-8 col-xs-12">
									<div class="form-group" id="item-answer">
										<textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" style="width:250px;height:40px;"></textarea>
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12  col-xs-12">
								<div class="form-group" id="item-_point">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
									<div class="col col-8 col-xs-12">
										<input type="text" name="answer<cfoutput>#i#</cfoutput>_point" id="answer<cfoutput>#i#</cfoutput>_point" style="width:250px;">
									</div>
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12  col-xs-12">
								<div class="form-group" id="item-_photo">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'></label>
									<div class="col col-8 col-xs-12">
										<input type="File" id="answer<cfoutput>#i#</cfoutput>_photo" name="answer<cfoutput>#i#</cfoutput>_photo" style="width:250px;">
									</div>
								</div>
							</div>
						</div>
					</cfloop>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<input type="Hidden" name="more" id="more" value=0>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='55549.Kaydet ve Yeni Soru Ekle'></cfsavecontent>
				<cf_workcube_buttons is_upd='0' insert_info='#message#' add_function="(document.add_question.more.value=1)" is_cancel='0'>
				<cf_workcube_buttons is_upd='0'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
 function answershow()
            {
            var checked = add_question.open_ended.checked;
                if(checked ==1)
                {
                
					add_question.answer_number.disabled=true;
                return true;
                }
                    
                if(checked =="")
                {
					add_question.answer_number.disabled=false;
               
                return true;
                }
                else
                {
					add_question.answer_number.disabled=false;
				
              
                return true;
                }
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
</script>

