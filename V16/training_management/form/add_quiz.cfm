<!--- <cfset xfa.add = "#request.self#?fuseaction=training_management.emptypopup_add_quiz"> --->
<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfparam name="attributes.is_active_consumer_cat" default="1"><!--- Aktif kategorilerin gelmesi için --->
<cfset get_training_sec=cfc.GET_TRAINING_SECS_FUNC()>
<cfset GET_TRAINING_CAT=cfc.GET_TRAINING_CAT_FUNC()>
<cfset GET_TRAINING=cfc.GET_TRAINING_FUNC()>
<cfset get_position_cats=cfc.GET_POSITION_CATS_FUNC()>
<cfset get_quiz_stages=cfc.GET_QUIZ_STAGES_F()>
<cfset get_consumer_cats=cfc.GET_CONSUMER_FUNC(is_active_consumer_cat:attributes.is_active_consumer_cat)>
<cfset get_partner_cats=cfc.GET_PARTNERS_FUNC()>
<cfset get_departments=cfc.GET_DEPARTMENTS_FUNC()>
<cfset get_test_types=cfc.GET_TEST_TYPES_FUNC()>
		<div class="row">
			<div class="col col-12 col-xs-12 uniqueRow">
				<cf_box title="#getLang('training',59)#: #getLang('main',2352)#" closable="0" collapsable="0">
                    <cf_box_elements>
                        <cfform name="add_quiz" method="post" action="#request.self#?fuseaction=training_management.emptypopup_add_quiz">
                            <div class="row" type="row">	
                                <cfif isdefined("attributes.class_id")>
                                    <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
                                    <!--- eğitimden geliyorsa ve eğitim detayındaki xml de sadece 1 adet eklenebilsin seçili ise bu kontrole girer SG20120717--->
                                    <cfif isdefined('attributes.xml_is_quiz_add') and attributes.xml_is_quiz_add eq 1>
                                        <cfquery name="get_control" datasource="#dsn#">
                                            SELECT QR.QUIZ_ID FROM QUIZ Q,QUIZ_RELATION QR WHERE Q.QUIZ_ID = QR.QUIZ_ID AND QR.CLASS_ID = #attributes.class_id# 
                                        </cfquery>
                                        <cfif get_control.recordcount>
                                            <script type="text/javascript">
                                                {
                                                    alert("<cf_get_lang no='508.Eğitime Bağlı 1 tane test ekleyebilirsiniz'>");
                                                    history.go(-1);
                                                }
                                            </script>			
                                        </cfif>
                                    </cfif>
                                </cfif>								
                                <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">	
                                    <div class="form-group" id="item-quiz_head">
                                        <label class="col col-12 col-xs-12"><cf_get_lang no='195.test başlığı'>*</label>
                                        <div class="col col-12 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang no='195.test basligi'></cfsavecontent>
                                            <cfinput type="text" name="quiz_head" value="" id="quiz_head" required="yes" message="#message#" maxlength="125">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-test_type_id">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='38585.Sınav Tipi'>*</label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="test_type_id" id="test_type_id" size="1">
                                                <option value="0"><cf_get_lang dictionary_id='38583.Sınav tipi seçiniz'>!</option>
                                                <cfoutput query="get_test_types">
                                                    <option value="#id#">#test_type#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-training_subject">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='46049.Müfredat'>*</label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <cfinput type="hidden" name="train_id" id="train_id" value="">
                                                <cfinput type="text" name="train_head" id="train_head" value="">
                                                <span class="input-group-addon icon-ellipsis btnPointer"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_list_training_subjects&field_id=add_quiz.train_id&field_name=add_quiz.train_head&field_cat_id=add_quiz.training_cat_id&field_sec_id=add_quiz.training_sec_id</cfoutput>','list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-training_cat_id">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="training_cat_id" id="training_cat_id" size="1" onchange="get_tran_sec(this.value)">
                                                <option value="0"><cf_get_lang dictionary_id='57486.Kategori'>!</option>
                                                <cfoutput query="get_training_cat">
                                                    <option value="#training_cat_id#">#training_cat#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-training_sec_id">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='583.bölüm'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="training_sec_id" id="training_sec_id" onchange="get_tran(this.value)">
                                                <option value="0"><cf_get_lang_main no='583.bölüm'>!</option>
                                                <cfoutput query="get_training_sec">
                                                    <option value="#training_sec_id#">#section_name#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-training_id">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='68.konu'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="training_id" id="training_id">
                                                <option value="0"><cf_get_lang_main no='68.Konu'> !</option>
                                                <cfoutput query="get_training">
                                                    <option value="#train_id#">#train_head#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-training_id">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
                                        <div class="col col-12 col-xs-12">
                                        <!--- aşama süreç ten gelecek ve Yayın aşamasında stage_id alanı display file ile update edilecek SG20120619--->
                                            <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
                                        
                                        <!---<select name="stage_id" style="width:170px;">
                                            <cfoutput query="get_quiz_stages">
                                            <option value="#stage_id#">#stage_name#</option>
                                            </cfoutput>
                                        </select>--->
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-event_start_clock">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no="641.Başlangıç Tarihi"></label>
                                        <cfset sdate="">
                                        <cfset shour="">
                                        <cfset sminute="">
                                        <cfset quiz_startdate_ = dateformat(now(),dateformat_style)>
                                        <div class="col col-12">
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
                                                    <cfinput type="text" validate="#validate_style#" name="QUIZ_STARTDATE" value="#quiz_startdate_#" required="Yes" message="#message#" maxlength="10">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="QUIZ_STARTDATE"></span>
                                                </div>
                                            </div>
                                            <div class="col col-2 col-xs-3">
                                                <cf_wrkTimeFormat name="event_start_clock" value="0">
                                            </div>
                                            <div class="col col-2 col-xs-3">
                                                <select name="event_start_minute" id="event_start_minute">
                                                        <cfloop from="0" to="55" index="a" step="5">
                                                            <cfoutput><option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option></cfoutput>
                                                        </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-event_finish_clock">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='288.bitiş tarihi'></label>
                                        <cfset sdate="">
                                        <cfset shour="">
                                        <cfset sminute="">
                                        <cfset quiz_finishdate_ = dateformat(now(),dateformat_style)>	
                                        <div class="col col-12">
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
                                                    <cfinput type="text" validate="#validate_style#" name="QUIZ_FINISHDATE" value="#quiz_finishdate_#" required="Yes" message="#message#" maxlength="10">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="QUIZ_FINISHDATE"></span>
                                                </div>
                                            </div>
                                            <div class="col col-2 col-xs-3">
                                                <cf_wrkTimeFormat name="event_finish_clock" value="0">
                                            </div>
                                            <div class="col col-2 col-xs-3">
                                                <select name="event_finish_minute" id="event_finish_minute">
                                                    <cfloop from="0" to="55" index="a" step="5">
                                                        <cfoutput>
                                                            <option value="#Numberformat(a,00)#">#Numberformat(a,00)#</option>
                                                        </cfoutput>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <cf_seperator id="basari_yorumlari_" header="Başarı Yorumları" is_closed="0">
                                    <div id="basari_yorumlari_">
                                        <div class="form-group col col-12 col-xs-12">
                                            <div class="col col-2 col-xs-4">
                                                <cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
                                                <cfinput type="text"  name="score1" value="" validate="integer" onKeyUp="isNumber(this)" message="#message#">
                                            </div>
                                            <div class="col col-1 col-xs-4">
                                                %<cf_get_lang_main no='1976.üstü'>
                                            </div>
                                            <div class="col col-4 col-xs-4">
                                                <cfinput type="text" name="comment1" style="width:300px;" value="">
                                            </div>
                                        </div>
                                        <div class="form-group col col-12 col-xs-12">
                                            <div class="col col-2 col-xs-4">
                                                <cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="score2" value="" onKeyUp="isNumber(this)" validate="integer" message="#message#">
                                            </div>
                                            <div class="col col-1 col-xs-4">
                                                %<cf_get_lang_main no='1976.üstü'>
                                            </div>
                                            <div class="col col-4 col-xs-4">
                                                <cfinput type="text" name="comment2" style="width:300px;" value="">
                                            </div>
                                        </div>
                                        <div class="form-group col col-12 col-xs-12">
                                            <div class="col col-2 col-xs-4">
                                                <cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="score3" value="" onKeyUp="isNumber(this)" validate="integer" message="#message#">
                                            </div>
                                            <div class="col col-1 col-xs-4">
                                                %<cf_get_lang_main no='1976.üstü'>
                                            </div>
                                            <div class="col col-4 col-xs-4">
                                                <cfinput type="text" name="comment3" style="width:300px;" value="">
                                            </div>
                                        </div>
                                        <div class="form-group col col-12 col-xs-12">
                                            <div class="col col-2 col-xs-4">
                                                <cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
                                                <cfinput type="text" name="score4" value="" onKeyUp="isNumber(this)" validate="integer" message="#message#">
                                            </div>
                                            <div class="col col-1 col-xs-4">
                                                %<cf_get_lang_main no='1976.üstü'>
                                            </div>
                                            <div class="col col-4 col-xs-4">
                                                <cfinput type="text" name="comment4" style="width:300px;" value="">
                                            </div>
                                        </div>
                                        <div class="form-group col col-12 col-xs-12">
                                            <div class="col col-2 col-xs-4">
                                                <cfsavecontent variable="message"><cf_get_lang no='198.üstü girmelisiniz'></cfsavecontent>
                                                    <cfinput type="text" name="score5" value="" onKeyUp="isNumber(this)" validate="integer" message="#message#">
                                            </div>
                                            <div class="col col-1 col-xs-4">	
                                                %<cf_get_lang_main no='1976.üstü'>
                                            </div>
                                            <div class="col col-4 col-xs-4">
                                                    <cfinput type="text" name="comment5" style="width:300px;" value="">
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
                                    <div class="col col-12 col-xs-12"> 
                                        <div class="form-group" id="item-quiz_objective">
                                            <label class="col col-12 col-xs-12"><cf_get_lang no='32.Amaç'></label>
                                            <div class="col col-12 col-xs-12"><cfinput type="text" id="quiz_objective" name="quiz_objective" value=""></div>
                                        </div>
                                        <div class="form-group" id="item-quiz_type">
                                            <label class="col col-12 col-xs-12"><cf_get_lang_main no='218.tip'> *</label>
                                            <div class="col col-12 col-xs-12">
                                                <label class="col col-4 col-xs-12"><input type="radio" name="quiz_type" id="quiz_type" value="1" onclick="time_check();"><cf_get_lang no='133.sorular birarada'></label>
                                                <label class="col col-4 col-xs-12"><input type="radio" name="quiz_type" id="quiz_type" value="2" onclick="time_check();"><cf_get_lang no='134.sorular ardarda'></label>
                                                <label class="col col-4 col-xs-12"><input type="radio" name="quiz_type" id="quiz_type" value="3" onclick="time_check();"><cf_get_lang no='135.soru cevap ardarda'></label>
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-max_questions">
                                            <label class="col col-12 col-xs-12"><cf_get_lang no='139.kaç soru çıksın'> *</label>
                                            <div class="col col-12 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang no='139.testte maksimum kac soru cıksın'></cfsavecontent>
                                                <cfinput type="text"  name="max_questions" id="max_questions" value="" required="Yes" validate="integer" message="#message#" onKeyUp="isNumber(this)" maxlength="5">
                                            </div>
                                        </div>
                                        <div class="form-group" id="item-TAKE_LIMIT">
                                            <label class="col col-12 col-xs-12"><cf_get_lang no='140.test tekrarı'>*</label>
                                            <div class="col col-12 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang no='140.test tekrarı'></cfsavecontent>
                                                <cfinput type="text"  name="TAKE_LIMIT" id="TAKE_LIMIT" value="" required="Yes" validate="integer" message="#message#" maxlength="5" onKeyUp="isNumber(this)">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group" id="item-random">
                                            <label class="col col-12 col-xs-12"><cf_get_lang no='136.rastgele soru'></label>
                                            <div class="col col-12 col-xs-12">
                                                <label><input type="radio" name="random" id="random" value="1" checked><cf_get_lang_main no='83.evet'></label>
                                                <label><input type="radio" name="random" id="random" value="0"><cf_get_lang_main no='84.hayır'></label>
                                            </div>
                                        </div>
                                        <div class="form-group"  id="item-QUIZ_AVERAGE">
                                            <label class="col col-12 col-xs-12"><cf_get_lang no='145.başarı sınırı'> *</label>	
                                            <div class="col col-12 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang no='145.başarı sınırı'></cfsavecontent>
                                                <cfinput type="text" name="QUIZ_AVERAGE" id="QUIZ_AVERAGE" value="" required="Yes" message="#message#" maxlength="5" onKeyUp="isNumber(this)">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group" id="item-timing_style">
                                            <label class="col col-12 col-xs-12"><cf_get_lang_main no='1716.süre'> (<cf_get_lang_main no='715.dakika'>) *</label>
                                            <div class="col col-12 col-xs-12">
                                                <input type="radio" name="timing_style" id="timing_style" value="0" onclick="add_quiz.total_time.disabled=true; time_check2();"><cf_get_lang no='141.soruya özel süre'>
                                            </div>
                                            <label class="col col-12 col-xs-12"><input type="radio" name="timing_style" id="timing_style" value="1" onclick="add_quiz.total_time.disabled=false; time_check2();" checked><cf_get_lang no='87.toplam süre'></label>
                                            <div class="col col-12 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1716.süre'></cfsavecontent>
                                                <cfinput type="text"  name="total_time" value="" validate="integer" message="#message#" maxlength="5" onKeyUp="isNumber(this)">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group" id="item-grade_style">
                                            <label class="col col-12 col-xs-12"><cf_get_lang_main no='1572.Puan'></label>
                                            <div class="col col-12 col-xs-12">
                                                <input type="radio" name="grade_style" id="grade_style" value="0" onclick="add_quiz.total_points.disabled=true;">
                                                <cf_get_lang no='144.soruya özel puan'>	
                                            </div>
                                            <label class="col col-12 col-xs-12"><input type="radio" name="grade_style" id="grade_style" value="1" onclick="add_quiz.total_points.disabled=false;" checked><cf_get_lang_main no='1573.toplam puan'></label>
                                            <div class="col col-12 col-xs-12">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang_main no='1573.toplam puan'></cfsavecontent>
                                                <cfinput type="text" name="total_points" id="total_points" value="100" validate="integer" message="#message#" maxlength="5" onKeyUp="isNumber(this)">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-12">
                                        <cf_seperator id="kimler_almali_" header="#getLang('training_management',72)#" is_closed="0">
                                        <div id="kimler_almali_">
                                            <div class="form-group">
                                                <label class="col col-12 col-xs-12"><cf_get_lang no='151.kurumsal'></label>
                                                <div class="col col-12 col-xs-12">
                                                    <cf_multiselect_check
                                                    name="quiz_partners"
                                                    query_name="get_partner_cats"
                                                    option_value="companycat_id"
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
                                                    option_value="position_cat_id">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>			
                            </div>
                            <div class="row formContentFooter">
                                <div class="col col-12 col-xs-12">
                                    <cf_workcube_buttons
                                        type_format='1'
                                        is_upd='0'
                                        add_function = 'form_check()'
                                        data_action = "/V16/training_management/cfc/TrainingTest:ADD_QUIZ_FUNC" 
                                        next_page = "#request.self#?fuseaction=training_management.list_quizs&event=det&quiz_id="
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
	if (add_quiz.quiz_type[0].checked)
		{
		add_quiz.timing_style[1].checked = true;
		add_quiz.total_time.disabled = false;
		}
}
function time_check2()
{
	if (add_quiz.timing_style[0].checked && add_quiz.quiz_type[0].checked)
		{
		add_quiz.timing_style[1].checked = true;
		add_quiz.total_time.disabled = false;
		}
}
function get_tran_sec(cat_id)
{
	document.add_quiz.training_sec_id.options.length = 0;
	document.add_quiz.training_id.options.length = 0;
	var get_sec =  wrk_safe_query('trn_get_sec','dsn',0,cat_id); 
	document.add_quiz.training_sec_id.options[0]=new Option('Bölüm !','0')
	document.add_quiz.training_id.options[0]=new Option('Konu !','0');
	for(var jj=0;jj<get_sec.recordcount;jj++)
	{
		document.add_quiz.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
	}
}
function get_tran(sec_id)
{
	document.add_quiz.training_id.options.length = 0;
	var get_konu = wrk_safe_query('trnm_get_subj','dsn',0,sec_id);
	document.add_quiz.training_id.options[0]=new Option('Konu !','0')
	for(var xx=0;xx<get_konu.recordcount;xx++)
	{
		document.add_quiz.training_id.options[xx+1]=new Option(get_konu.TRAIN_HEAD[xx],get_konu.TRAIN_ID[xx])
	}
}
<!---/*function hepsi()
{
	if (add_quiz.all.checked)
		{
	<cfif get_partner_cats.recordcount gt 1>	
		for(i=0;i<add_quiz.quiz_partners.length;i++) add_quiz.quiz_partners[i].checked = true;
	<cfelseif get_partner_cats.recordcount eq 1>
		add_quiz.quiz_partners.checked = true;
	</cfif>
	<cfif get_consumer_cats.recordcount gt 1>	
		for(i=0;i<add_quiz.quiz_consumers.length;i++) add_quiz.quiz_consumers[i].checked = true;
	<cfelseif get_consumer_cats.recordcount eq 1>
		add_quiz.quiz_consumers.checked = true;
	</cfif>
	<cfif get_departments.recordcount gt 1>	
		for(i=0;i<add_quiz.quiz_departments.length;i++) add_quiz.quiz_departments[i].checked = true;
	<cfelseif get_departments.recordcount eq 1>
		add_quiz.quiz_departments.checked = true;
	</cfif>
	<cfif get_position_cats.recordcount gt 1>	
		for(i=0;i<add_quiz.quiz_position_cats.length;i++) add_quiz.quiz_position_cats[i].checked = true;
	<cfelseif get_position_cats.recordcount eq 1>
		add_quiz.quiz_position_cats.checked = true;
	</cfif>
		}
	else
		{
	<cfif get_partner_cats.recordcount gt 1>	
		for(i=0;i<add_quiz.quiz_partners.length;i++) add_quiz.quiz_partners[i].checked = false;
	<cfelseif get_partner_cats.recordcount eq 1>
		add_quiz.quiz_partners.checked = false;
	</cfif>
	<cfif get_consumer_cats.recordcount gt 1>	
		for(i=0;i<add_quiz.quiz_consumers.length;i++) add_quiz.quiz_consumers[i].checked = false;
	<cfelseif get_consumer_cats.recordcount eq 1>
		add_quiz.quiz_consumers.checked = false;
	</cfif>
	<cfif get_departments.recordcount gt 1>	
		for(i=0;i<add_quiz.quiz_departments.length;i++) add_quiz.quiz_departments[i].checked = false;
	<cfelseif get_departments.recordcount eq 1>
		add_quiz.quiz_departments.checked = false;
	</cfif>
	<cfif get_position_cats.recordcount gt 1>	
		for(i=0;i<add_quiz.quiz_position_cats.length;i++) add_quiz.quiz_position_cats[i].checked = false;
	<cfelseif get_position_cats.recordcount eq 1>
		add_quiz.quiz_position_cats.checked = false;
	</cfif>
		}
}*/--->
function form_check()
{
	if (!process_cat_control()) return false;
	add_quiz.total_points.value = filterNum(add_quiz.total_points.value);
	add_quiz.TAKE_LIMIT.value = filterNum(add_quiz.TAKE_LIMIT.value);
	add_quiz.total_time.value = filterNum(add_quiz.total_time.value);
	add_quiz.score1.value = filterNum(add_quiz.score1.value);
	add_quiz.score2.value = filterNum(add_quiz.score2.value);
	add_quiz.score3.value = filterNum(add_quiz.score3.value);
	add_quiz.score4.value = filterNum(add_quiz.score4.value);
	add_quiz.score5.value = filterNum(add_quiz.score5.value);
	add_quiz.QUIZ_AVERAGE.value = filterNum(add_quiz.QUIZ_AVERAGE.value);

	if (add_quiz.quiz_head.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='62825.Sınav Adı'>");
		return false;
	}
	if (add_quiz.train_id.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='46049.Müfredat'>");
		return false;
	}
	if (add_quiz.test_type_id.value == "0")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='38585.Sınav Tipi'>");
		return false;
	}
	if (add_quiz.max_questions.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='46346.Testte yer almasını istediğiniz maksimum soru miktarı?'>");
		return false;
	}
	if (add_quiz.TAKE_LIMIT.value == "")
	{ 
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='46347.Test Tekrarı (Bir kişi kaç kere bu testi çözebilir)'>");
		return false;
	}
	if(add_quiz.quiz_type[0].checked == false && add_quiz.quiz_type[1].checked == false && add_quiz.quiz_type[2].checked == false)
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57630.Tip'>");
		return false;
	}
	if ( (add_quiz.total_time.value == "") && (add_quiz.timing_style[1].checked) )
	{ 
		alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang no ='87.Toplam Süre'> !");
		return false;
	}
	if ( (add_quiz.total_points.value == "") && (add_quiz.grade_style[1].checked) )
	{ 
		alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang_main no='1573.Toplam Puan'> !");
		return false;
	}
	if(add_quiz.grade_style[1].checked && parseInt(document.getElementById('QUIZ_AVERAGE').value) > parseInt(document.getElementById('total_points').value))
	{
		alert("<cf_get_lang dictionary_id='63820.Başarı sınırı toplam puandan büyük olamaz'>");
		return false;
	}
	
	return date_check(add_quiz.QUIZ_STARTDATE, add_quiz.QUIZ_FINISHDATE, "<cf_get_lang dictionary_id='56696.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'>");
}
</script>
