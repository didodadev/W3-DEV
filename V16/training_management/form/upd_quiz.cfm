<cf_catalystheader>
<cfparam name="attributes.is_active_consumer_cat" default="">
<cfparam name="attributes.result_id" default="">
<cfparam name="attributes.class_id" default="">
<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset get_position_cats=cfc.GET_POSITION_CATS_FUNC()>
<cfset get_departments=cfc.GET_DEPARTMENTS_FUNC()>
<cfset get_consumer_cats=cfc.GET_CONSUMER_FUNC(is_active_consumer_cat:attributes.is_active_consumer_cat)>
<cfset get_partner_cats=cfc.GET_PARTNERS_FUNC()>
<cfset get_quiz=cfc.GET_QUIZS_FUNC(quiz_id:url.quiz_id)>
<cfset get_quiz_result_count=cfc.QUIZ_RESULT_COUNT(quiz_id:url.quiz_id,result_id:attributes.result_id,class_id:attributes.class_id)>
<cfset get_quiz_stages=cfc.GET_QUIZ_STAGES_F()>
<!--- <cfif get_quiz_result_count.toplam gte 1>
	<cfexit method="exittemplate">
</cfif> --->
<cfset get_training_secs=cfc.GET_TRAINING_SECS_FUNC()>
<cfset get_training_cat=cfc.GET_TRAINING_CAT_FUNC()>
<cfset get_test_types=cfc.GET_TEST_TYPES_FUNC()>
<cfset get_quiz_subject=cfc.GET_QUIZ_SUBJECT_FUNC(quiz_id: attributes.quiz_id)>
	<div class="row">
		<div class="col col-12 col-xs-12 uniqueRow">
			<cf_box title="#getLang('','Sınavlar',46059)#: #url.quiz_id#" closable="0" collapsable="0">
				<cf_box_elements>
					<cfform name="upd_quiz" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_quiz">
						<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">	
						<div class="row" type="row">
							<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								<div class="form-group" id="item-quiz_head">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62825.Sınav Adı'>*</label>
									<div class="col col-12 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='63587.Girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='62825.Sınav Adı'></cfsavecontent>
										<cfinput type="text" name="quiz_head" id="quiz_head" value="#DecodeForHTML(get_quiz.quiz_head)#" required="Yes" message="#message#" maxlength="125">
									</div>
								</div>
                                <div class="form-group" id="item-test_type_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38585.Sınav Tipi'>*</label>
									<div class="col col-12 col-xs-12">
										<select name="test_type_id" id="test_type_id">
											<option value="0"><cf_get_lang dictionary_id='38583.Sınav tipi seçiniz'>!</option>
											<cfoutput query="get_test_types">
											    <option value="#id#" <cfif get_quiz.test_type eq id>selected</cfif>>#test_type#</option>
											</cfoutput>
										</select>
									</div>
								</div>
                                <div class="form-group" id="item-training_subject">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='46049.Müfredat'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="hidden" name="QUIZ_TRAINING_SUBJECTS" id="QUIZ_TRAINING_SUBJECTS" value="#iif(len(get_quiz_subject.QUIZ_TRAINING_SUBJECTS),"get_quiz_subject.QUIZ_TRAINING_SUBJECTS",DE("0"))#">
                                            <cfinput type="hidden" name="train_id" id="train_id" value="#get_quiz_subject.TRAINING_SUBJECT_ID#">
                                            <cfinput type="text" name="train_head" id="train_head" value="#get_quiz_subject.train_head#">
                                            <span class="input-group-addon icon-ellipsis btnPointer"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_list_training_subjects&field_id=upd_quiz.train_id&field_name=upd_quiz.train_head&field_cat_id=upd_quiz.training_cat_id&field_sec_id=upd_quiz.training_sec_id</cfoutput>','list');"></span>
                                        </div>
                                    </div>
                                </div>
								<div class="form-group" id="item-training_cat_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
									<div class="col col-12 col-xs-12">
										<select name="training_cat_id" id="training_cat_id" size="1" onChange="get_tran_sec(this.value)">
											<option value="0"><cf_get_lang dictionary_id='57486.Kategori'>!</option>
											<cfoutput query="get_training_cat">
											    <option value="#training_cat_id#" <cfif get_quiz.training_cat_id eq training_cat_id>selected</cfif>>#training_cat#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-training_sec_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'></label>
									<div class="col col-12 col-xs-12">
										<select name="training_sec_id" id="training_sec_id" onChange="get_tran(this.value)">
											<option value="0"><cf_get_lang dictionary_id='57995.Bölüm'>!</option>
											<cfoutput query="get_training_secs">
												<option value="#training_sec_id#">#section_name#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-training_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
									<div class="col col-12 col-xs-12">
										<select name="training_id" id="training_id">
											<option value="0"><cf_get_lang dictionary_id='57480.Konu'>!</option>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-process_stage">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
									<div class="col col-12 col-xs-12">
										<cf_workcube_process is_upd='0' select_value='#get_quiz.process_stage#' is_detail='1'>
									</div>
								</div>
								<div class="form-group" id="item-event_start_clock">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfset startdate = date_add('h', session.ep.time_zone, get_quiz.quiz_startdate)>
											<cfset finishdate = date_add('h', session.ep.time_zone, get_quiz.quiz_finishdate)>
											<cfinput type="text"  name="QUIZ_STARTDATE"  value="#dateformat(startdate,dateformat_style)#" validate="#validate_style#" message="Başlangıç Tarihi !">
											<span class="input-group-addon"><cf_wrk_date_image date_field="QUIZ_STARTDATE"></span>
											<div class="col col-6">
												<select name="event_start_clock" id="event_start_clock">
													<option value="0">24</option>
													<cfloop from="1" to="23" index="i">
														<cfoutput>
															<option value="#i#"<cfif timeformat(STARTDATE,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
														</cfoutput>
													</cfloop>
												</select>
											</div>
											<div class="col col-6">
												<select name="event_start_minute" id="event_start_minute">
													<option value="00">00</option>
													<option value="05"<cfif timeformat(STARTDATE,'MM') eq 05> selected</cfif>>05</option>
													<option value="10"<cfif timeformat(STARTDATE,'MM') eq 10> selected</cfif>>10</option>
													<option value="15"<cfif timeformat(STARTDATE,'MM') eq 15> selected</cfif>>15</option>
													<option value="20"<cfif timeformat(STARTDATE,'MM') eq 20> selected</cfif>>20</option>
													<option value="25"<cfif timeformat(STARTDATE,'MM') eq 25> selected</cfif>>25</option>
													<option value="30"<cfif timeformat(STARTDATE,'MM') eq 30> selected</cfif>>30</option>
													<option value="35"<cfif timeformat(STARTDATE,'MM') eq 35> selected</cfif>>35</option>
													<option value="40"<cfif timeformat(STARTDATE,'MM') eq 40> selected</cfif>>40</option>
													<option value="45"<cfif timeformat(STARTDATE,'MM') eq 45> selected</cfif>>45</option>
													<option value="50"<cfif timeformat(STARTDATE,'MM') eq 50> selected</cfif>>50</option>
													<option value="55"<cfif timeformat(STARTDATE,'MM') eq 55> selected</cfif>>55</option>
												</select>
											</div>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-event_finish_clock">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfinput type="text"  name="QUIZ_FINISHDATE" value="#dateformat(finishdate,dateformat_style)#" validate="#validate_style#" message="Bitiş Tarihi !">
											<span class="input-group-addon"><cf_wrk_date_image date_field="QUIZ_FINISHDATE"></span>
											<div class="col col-6">
												<select name="event_finish_clock" id="event_finish_clock">
													<option value="0">24</option>
													<cfloop from="1" to="23" index="i">
														<cfoutput>
														<option value="#i#"<cfif timeformat(FINISHDATE,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
														</cfoutput>
													</cfloop>
												</select>
											</div>
											<div class="col col-6">
												<select name="event_finish_minute" id="event_finish_minute">
													<option value="00">00</option>
													<option value="05"<cfif timeformat(FINISHDATE,'MM') eq 05> selected</cfif>>05</option>
													<option value="10"<cfif timeformat(FINISHDATE,'MM') eq 10> selected</cfif>>10</option>
													<option value="15"<cfif timeformat(FINISHDATE,'MM') eq 15> selected</cfif>>15</option>
													<option value="20"<cfif timeformat(FINISHDATE,'MM') eq 20> selected</cfif>>20</option>
													<option value="25"<cfif timeformat(FINISHDATE,'MM') eq 25> selected</cfif>>25</option>
													<option value="30"<cfif timeformat(FINISHDATE,'MM') eq 30> selected</cfif>>30</option>
													<option value="35"<cfif timeformat(FINISHDATE,'MM') eq 35> selected</cfif>>35</option>
													<option value="40"<cfif timeformat(FINISHDATE,'MM') eq 40> selected</cfif>>40</option>
													<option value="45"<cfif timeformat(FINISHDATE,'MM') eq 45> selected</cfif>>45</option>
													<option value="50"<cfif timeformat(FINISHDATE,'MM') eq 50> selected</cfif>>50</option>
													<option value="55"<cfif timeformat(FINISHDATE,'MM') eq 55> selected</cfif>>55</option>
												</select>
											</div>
										</div>
									</div>
								</div>
								<cf_seperator id="basari_yorumlari_" header="Başarı Yorumları" is_closed="0">
								<div id="basari_yorumlari_">
									<div class="form-group col col-12 col-xs-12">
										<div class="col col-2">
											<cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
											<cfinput type="text"  name="score1" style="width:50px;" value="#get_quiz.score1#" validate="integer" onKeyUp="isNumber(this)" message="#message#">
										</div>
										<label class="col col-1">%<cf_get_lang_main no='1976.üstü'></label>
										<div class="col col-4">	
											<cfinput type="text" name="comment1" style="width:300px;" value="#get_quiz.comment1#">
										</div>
									</div>
									<div class="form-group col col-12 col-xs-12">
										<div class="col col-2">
											<cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="score2" style="width:50px;" value="#get_quiz.score2#" onKeyUp="isNumber(this)" validate="integer" message="#message#">
										</div>
										<label class="col col-1">%<cf_get_lang_main no='1976.üstü'></label>
										<div class="col col-4">	
											<cfinput type="text" name="comment2" style="width:300px;" value="#get_quiz.comment2#">
										</div>
									</div>
									<div class="form-group col col-12 col-xs-12">
										<div class="col col-2">
											<cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="score3" style="width:50px;" value="#get_quiz.score3#" onKeyUp="isNumber(this)" validate="integer" message="#message#">
										</div>
										<label class="col col-1">%<cf_get_lang_main no='1976.üstü'></label>
										<div class="col col-4">
											<cfinput type="text" name="comment3" style="width:300px;" value="#get_quiz.comment3#">
										</div>
									</div>
									<div class="form-group col col-12 col-xs-12">
										<div class="col col-2">
											<cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="score4" style="width:50px;" value="#get_quiz.score4#" onKeyUp="isNumber(this)" validate="integer" message="#message#">
										</div>
										<label class="col col-1">%<cf_get_lang_main no='1976.üstü'></label>
										<div class="col col-4">
											<cfinput type="text" name="comment4" style="width:300px;" value="#get_quiz.comment4#">
										</div>
									</div>
									<div class="form-group col col-12 col-xs-12">
										<div class="col col-2">
											<cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="score5" style="width:50px;" value="#get_quiz.score5#" onKeyUp="isNumber(this)" validate="integer" message="#message#">
										</div>
										<label class="col col-1">%<cf_get_lang_main no='1976.üstü'></label>
										<div class="col col-4">
											<cfinput type="text" name="comment5" style="width:300px;" value="#get_quiz.comment5#">
										</div>
									</div>
									<div class="form-group col col-12 col-xs-12">
										<div class="col col-12 col-xs-12">
											<label><cfoutput>#getLang('training_management',142)#</cfoutput></label>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
								<div clas="col col-12 col-xs-12">
									<div class="form-group" id="item-quiz_objective">
										<label class="col col-12 col-xs-12"><cf_get_lang no='32.Amaç'></label>
										<div class="col col-12 col-xs-12"><cfinput type="text" name="quiz_objective" value="#get_quiz.quiz_objective#"></div>
									</div>
									<br/>
									<div class="form-group" id="item-quiz_type">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'>*</label>
										<div class="col col-12 col-xs-12">
											<label class="col col-4 col-xs-12"><input type="radio" name="quiz_type" id="quiz_type" value="1" <cfif get_quiz.quiz_type eq 1>checked</cfif> onclick="time_check();"><cf_get_lang no='133.sorular birarada'></label>
											<label class="col col-4 col-xs-12"><input type="radio" name="quiz_type" id="quiz_type" value="2" <cfif get_quiz.quiz_type eq 2>checked</cfif> onclick="time_check();"><cf_get_lang no='134.sorular ardarda'></label>
											<label class="col col-4 col-xs-12"><input type="radio" name="quiz_type" id="quiz_type" value="3" <cfif get_quiz.quiz_type eq 3>checked</cfif> onclick="time_check();"><cf_get_lang no='135.soru cevap ardarda'></label>
										</div>
									</div>
									<br/>
									<div class="form-group" id="item-max_questions">
										<label class="col col-10 col-xs-12"><cf_get_lang dictionary_id='46346.Testte yer almasını istediğiniz maksimum soru miktarı?'>*</label>
										<div class="col col-2 col-xs-12">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='46346.Testte yer almasını istediğiniz maksimum soru miktarı?'></cfsavecontent>
											<cfinput type="text" name="max_questions" value="#get_quiz.max_questions#" required="Yes" validate="integer" message="#message#" onKeyUp="isNumber(this)" maxlength="5">
										</div>
									</div>
									<div class="form-group" id="item-TAKE_LIMIT">
										<label class="col col-10 col-xs-12"><cf_get_lang dictionary_id='46347.Test Tekrarı (Bir kişi kaç kere bu testi çözebilir)'>*</label>
										<div class="col col-2 col-xs-12">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='46347.Test Tekrarı (Bir kişi kaç kere bu testi çözebilir)'></cfsavecontent>
											<cfinput type="text" name="TAKE_LIMIT" value="#get_quiz.take_limit#" required="Yes" validate="integer" message="#message#" maxlength="5" onKeyUp="isNumber(this)">
										</div>
									</div>
								</div>
								<div clas="form-group col">
									<div class="form-group col col-6 col-xs-12" id="item-random">
										<label class="col col-12 col-xs-12"><cf_get_lang no='136.rastgele soru'></label>
										<div class="col col-12 col-xs-12">
											<label><input type="radio" name="random" id="random" value="1" <cfif get_quiz.random>checked</cfif>><cf_get_lang_main no='83.evet'></label>
											<label><input type="radio" name="random" id="random" value="0" <cfif not get_quiz.random>checked</cfif>><cf_get_lang_main no='84.hayır'></label>
										</div>
									</div>
									<div class="form-group col col-6 col-xs-12" id="item-QUIZ_AVERAGE">
										<label class="col col-12 col-xs-12"><cf_get_lang no='145.başarı sınırı'> *</label>
										<div class="col col-12 col-xs-12">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang no='145.başarı sınırı'></cfsavecontent>
											<cfinput type="text" name="quiz_average" value="#DecodeForHTML(get_quiz.quiz_average)#" required="Yes" message="#message#" maxlength="5" onKeyUp="isNumber(this)">
										</div>
									</div>
								</div>
								<div class="col col-12">
									<div class="form-group" id="item-timing_style">
										<div class="form-group col col-6 col-xs-12">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='1716.süre'> (<cf_get_lang_main no='715.dakika'>) *</label>
											<div class="col col-12 col-xs-12">
												<input type="radio" name="timing_style" id="timing_style" value="0" onClick="upd_quiz.total_time.disabled=true; time_check2();"<cfif not get_quiz.timing_style>checked</cfif>><label><cf_get_lang no='141.soruya özel süre'></label>
											</div>
										</div>	
										<div class="form-group col col-6 col-xs-12">
											<label class="col col-12 col-xs-12"><input type="radio" name="timing_style" id="timing_style" value="1" onClick="upd_quiz.total_time.disabled=false; time_check2();"<cfif get_quiz.timing_style>checked</cfif>><cf_get_lang no='87.toplam süre'></label>
											<div class="col col-12 col-xs-12">	
												<cfsavecontent variable="message"><cf_get_lang no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1716.süre'></cfsavecontent>
												<input type="text"  name="total_time" id="total_time" <cfif not get_quiz.timing_style>disabled</cfif> value="<cfoutput>#get_quiz.total_time#</cfoutput>" validate="integer" message="#message#" maxlength="5" onKeyUp="isNumber(this)">
											</div>	
										</div>
									</div>
								</div>
								<div class="col col-12">
									<div class="form-group" id="item-grade_style">
										<div class="form-group col col-6 col-xs-12">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='1572.Puan'></label>
											<div class="col col-12 col-xs-12">
												<input type="radio" name="grade_style" id="grade_style"  <cfif not get_quiz.grade_style>checked</cfif> value="0" onClick="upd_quiz.total_points.disabled=true;">
												<cf_get_lang no='144.soruya özel puan'>	
											</div>
										</div>	
										<div class="form-group col col-6 col-xs-12">	
											<label class="col col-12 col-xs-12"><input type="radio" name="grade_style" id="grade_style" value="1" <cfif get_quiz.grade_style>checked</cfif> onClick="upd_quiz.total_points.disabled=false;"><cf_get_lang_main no='1573.toplam puan'></label>
											<div class="col col-12 col-xs-12">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang_main no='1573.toplam puan'></cfsavecontent>
												<input type="text" name="total_points" id="total_points" <cfif not get_quiz.grade_style>disabled</cfif> value="<cfoutput>#get_quiz.total_points#</cfoutput>" validate="integer" message="#message#" maxlength="5" onKeyUp="isNumber(this)">
											</div>
										</div>
									</div>
								</div>
								<cf_seperator id="kimler_almali_" header="#getLang('training_management',72)#" is_closed="0">
								<div id="kimler_almali_">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='151.kurumsal'></label>
										<div class="col col-12 col-xs-12">
											<cf_multiselect_check
											name="quiz_partners"
											query_name="get_partner_cats"
											option_value="companycat_id"
											value = "#get_quiz.quiz_partners#"
											option_name="companycat">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='152.bireysel'></label>
										<div class="col col-12 col-xs-12">
											<cf_multiselect_check
											name="quiz_consumers"
											query_name="get_consumer_cats"
											option_name="conscat"
											value="#get_quiz.quiz_consumers#"
											option_value="conscat_id">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='130.departmanlar'></label>
										<div class="col col-12 col-xs-12">
											<cf_multiselect_check
											name="quiz_departments"
											query_name="get_departments"
											option_name="department_head"
											value = "#get_quiz.quiz_departments#"
											option_value="department_id">
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='367.pozisyon tipleri'></label>
										<div class="col col-12 col-xs-12">
											<cf_multiselect_check
											name="quiz_position_cats"
											query_name="get_position_cats"
											option_name="position_cat"
											value ="#get_quiz.quiz_position_cats#"
											option_value="position_cat_id">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row formContentFooter">
							<div class="col col-12 col-xs-12">
								<cf_workcube_buttons
                                    is_upd='1'
                                    add_function = 'form_check()'
                                    data_action = "/V16/training_management/cfc/TrainingTest:UPD_QUIZ_FUNC" 
                                    next_page = "#request.self#?fuseaction=training_management.list_quizs&event=upd&quiz_id=#attributes.quiz_id#"
                                    delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_quiz&quiz_id=#attributes.quiz_id#'
                                >
							</div>
						</div>
					</cfform>
				</cf_box_elements>
			</cf_box>
		</div>
	</div>
<script type="text/javascript">
function time_check()
	{
	if (upd_quiz.quiz_type[0].checked)
		{
		upd_quiz.timing_style[1].checked = true;
		upd_quiz.total_time.disabled = false;
		}
	}
function time_check2()
	{
	if (upd_quiz.timing_style[0].checked && upd_quiz.quiz_type[0].checked)
		{
		upd_quiz.timing_style[1].checked = true;
		upd_quiz.total_time.disabled = false;
		}
	}

function get_tran_sec(cat_id)
{
	document.upd_quiz.training_sec_id.options.length = 0;
	document.upd_quiz.training_id.options.length = 0;
	var get_sec = wrk_safe_query('trn_get_sec','dsn',0,cat_id);
	document.upd_quiz.training_sec_id.options[0]=new Option('<cf_get_lang_main no="583.bölüm"> !','0')
	document.upd_quiz.training_id.options[0]=new Option('<cf_get_lang_main no="68.konu"> !','0')
	for(var jj=0;jj<get_sec.recordcount;jj++)
	{
		document.upd_quiz.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
	}
}
function get_tran(sec_id)
{
	document.upd_quiz.training_id.options.length = 0;
	var get_konu = wrk_safe_query('trnm_get_subj','dsn',0,sec_id);
	document.upd_quiz.training_id.options[0]=new Option('<cf_get_lang_main no="68.konu"> !','0')
	for(var xx=0;xx<get_konu.recordcount;xx++)
	{
		document.upd_quiz.training_id.options[xx+1]=new Option(get_konu.TRAIN_HEAD[xx],get_konu.TRAIN_ID[xx])
	}
}

<cfif isDefined("get_quiz.training_cat_id") and len(get_quiz.training_cat_id)>
	get_tran_sec(<cfoutput>#get_quiz.training_cat_id#</cfoutput>);
</cfif>

<cfif isDefined("get_quiz.training_sec_id") and len(get_quiz.training_sec_id)>
	get_tran(<cfoutput>#get_quiz.training_sec_id#</cfoutput>);
	upd_quiz.training_sec_id.value = <cfoutput>#get_quiz.training_sec_id#</cfoutput>;
</cfif>

<cfif isDefined("get_quiz.training_id") and len(get_quiz.training_id)>
	upd_quiz.training_id.value = <cfoutput>#get_quiz.training_id#</cfoutput>;
</cfif>


function hepsi()
{
	if (upd_quiz.all.checked)
		{
	<cfif get_partner_cats.recordcount gt 1>	
		for(i=0;i<upd_quiz.quiz_partners.length;i++) upd_quiz.quiz_partners[i].checked = true;
	<cfelseif get_partner_cats.recordcount eq 1>
		upd_quiz.quiz_partners.checked = true;
	</cfif>
	<cfif get_consumer_cats.recordcount gt 1>	
		for(i=0;i<upd_quiz.quiz_consumers.length;i++) upd_quiz.quiz_consumers[i].checked = true;
	<cfelseif get_consumer_cats.recordcount eq 1>
		upd_quiz.quiz_consumers.checked = true;
	</cfif>
	<cfif get_departments.recordcount gt 1>	
		for(i=0;i<upd_quiz.quiz_departments.length;i++) upd_quiz.quiz_departments[i].checked = true;
	<cfelseif get_departments.recordcount eq 1>
		upd_quiz.quiz_departments.checked = true;
	</cfif>
	<cfif get_position_cats.recordcount gt 1>	
		for(i=0;i<upd_quiz.quiz_position_cats.length;i++) upd_quiz.quiz_position_cats[i].checked = true;
	<cfelseif get_position_cats.recordcount eq 1>
		upd_quiz.quiz_position_cats.checked = true;
	</cfif>
		}
	else
		{
	<cfif get_partner_cats.recordcount gt 1>	
		for(i=0;i<upd_quiz.quiz_partners.length;i++) upd_quiz.quiz_partners[i].checked = false;
	<cfelseif get_partner_cats.recordcount eq 1>
		upd_quiz.quiz_partners.checked = false;
	</cfif>
	<cfif get_consumer_cats.recordcount gt 1>	
		for(i=0;i<upd_quiz.quiz_consumers.length;i++) upd_quiz.quiz_consumers[i].checked = false;
	<cfelseif get_consumer_cats.recordcount eq 1>
		upd_quiz.quiz_consumers.checked = false;
	</cfif>
	<cfif get_departments.recordcount gt 1>	
		for(i=0;i<upd_quiz.quiz_departments.length;i++) upd_quiz.quiz_departments[i].checked = false;
	<cfelseif get_departments.recordcount eq 1>
		upd_quiz.quiz_departments.checked = false;
	</cfif>
	<cfif get_position_cats.recordcount gt 1>	
		for(i=0;i<upd_quiz.quiz_position_cats.length;i++) upd_quiz.quiz_position_cats[i].checked = false;
	<cfelseif get_position_cats.recordcount eq 1>
		upd_quiz.quiz_position_cats.checked = false;
	</cfif>
		}
}

function form_check()
{
	if (!process_cat_control()) return false;
	upd_quiz.quiz_average.value = filterNum(upd_quiz.quiz_average.value);
	if (upd_quiz.quiz_type.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57630.Tip'>");
		return false;
	}
	if (upd_quiz.quiz_head.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='62825.Sınav Adı'>");
		return false;
	}
	if (upd_quiz.test_type_id.value == "0")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='38585.Sınav Tipi'>");
		return false;
	}
	if (upd_quiz.max_questions.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='46346.Testte yer almasını istediğiniz maksimum soru miktarı?'>");
		return false;
	}
	if (upd_quiz.TAKE_LIMIT.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='46347.Test Tekrarı (Bir kişi kaç kere bu testi çözebilir)'>");
		return false;
	}
	if ( (upd_quiz.total_time.value == "") && (upd_quiz.timing_style[1].checked) )
	{ 
		alert("<cf_get_lang dictionary_id='46683.Toplam Süre Yazmadınız'>");
		return false;
	}
	if ( (upd_quiz.total_points.value == "") && (upd_quiz.grade_style[1].checked) )
	{ 
		alert("<cf_get_lang dictionary_id='46684.Toplam Puan Yazmadınız'>");
		return false;
	}
	if(upd_quiz.grade_style[1].checked)
	{
		if(parseInt(upd_quiz.total_points.value) < parseInt(upd_quiz.quiz_average.value))
		{
			alert("<cf_get_lang dictionary_id='63820.Başarı sınırı toplam puandan büyük olamaz'>");
			return false;
		}
	}
	return date_check(upd_quiz.QUIZ_STARTDATE, upd_quiz.QUIZ_FINISHDATE, "<cf_get_lang dictionary_id='56696.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'>");
}
</script>
