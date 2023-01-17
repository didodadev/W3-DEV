<cf_xml_page_edit fuseact="training_management.popup_form_upd_question">
<cfif fuseaction eq "training_management.popup_form_upd_question">
	<cfset attributes.popup=1>
</cfif>

<cfinclude template="../query/get_question.cfm">
<cfquery name="GET_TRAINING_SEC" datasource="#dsn#">
	SELECT TRAINING_SEC_ID,SECTION_NAME FROM TRAINING_SEC
</cfquery>
<cfquery name="GET_TRAINING_CAT" datasource="#dsn#">
	SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
</cfquery>
<cfquery name="UPD_QUESTION" datasource="#dsn#">
	SELECT *FROM QUESTION WHERE	QUESTION_ID = #attributes.QUESTION_ID#
</cfquery>
<!--- <cfsavecontent variable="txt">
	<a href="<cfoutput>#request.self#?fuseaction=training_management.popup_form_add_question</cfoutput>"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
</cfsavecontent> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box id="list_quiz_questions" title="#getLang('','Soru',58810)#: #question_id#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform enctype="multipart/form-data" name="upd_question" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_question">
		<input type="Hidden" name="question_id" id="question_id" value="<cfoutput>#attributes.question_id#</cfoutput>">
		<cfif isdefined("attributes.popup")>
			<input type="Hidden" name="popup" id="popup" value="1">
		</cfif>
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<cf_seperator title="#getLang('','',58810)#" id="soru" is_closed="1">
					<div id="soru" >
					<div class="form-group" id="item-status" >
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='344.durum'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 "><input type="checkbox" name="status" id="status" <cfif get_question.STATUS eq 1>checked</cfif> value="1"><label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='81.aktif'></label>
					</div>	
					</div>	         
					<div class="form-group" id="item-training_cat_id">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='74.kateogri'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 ">
							<select name="training_cat_id" id="training_cat_id" size="1" onChange="get_tran_sec(this.value)" style="width:250px;">
								<option value="0"><cf_get_lang_main no='322.Seçiniz'>!</option>
								<cfoutput query="get_training_cat">
									<option value="#training_cat_id#" <cfif get_question.training_cat_id eq training_cat_id>selected</cfif>>#training_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-training_sec_id">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='583.bölüm'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 ">
							<select name="training_sec_id" id="training_sec_id" size="1" style="width:250px;" onChange="get_tran(this.value)">
								<option value="0"><cf_get_lang_main no='583.bölüm'>!</option>
							</select>				  
						</div>
					</div>
					<div class="form-group" id="item-training_id">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='68.konu'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 ">
							<select name="training_id" id="training_id" size="1" style="width:250px;">
								<option value="0"><cf_get_lang_main no='322.Seçiniz'>!</option>
							</select>				  
						</div>
					</div>
					<div class="form-group" id="item-question">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1398.soru'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 ">
							<textarea name="question" id="question" style="width:250px;height:80px;"><cfoutput>#get_question.question#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-QUESTION_INFO">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='217.açıklam'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 ">
							<textarea name="QUESTION_INFO" id="QUESTION_INFO" style="width:250px;height:80px;"><cfoutput>#get_question.question_info#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-time">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1716.süre'></label>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12 ">
						<cfsavecontent variable="message"><cf_get_lang no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1716.süre'></cfsavecontent>
						<cfinput type="text" name="time" value="#get_question.question_time#" style="width:50px;" required="Yes" validate="integer" message="#message#"></div>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12 ">
						<label><cf_get_lang_main no='715.dk'></label>
						</div>
					</div>
					<div class="form-group" id="item-QUESTION_point">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1572.puan'></label>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12 ">
							<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1572.puan'></cfsavecontent>
							<cfinput type="text" name="QUESTION_point" value="#get_question.question_point#" style="width:50px;" required="Yes" validate="integer" message="#message#" maxlength="5">
						</div>
					</div>
					<div class="form-group" id="item-answer_number">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang no='124.sık sayısı'></label>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12 ">
							<!--- şık sayısı seçilecek --->
							<select name="answer_number" id="answer_number" onchange="goster(this.selectedIndex);" >
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
						</label>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<cf_seperator title="#getLang('','cevap',58654)#" id="cevap" is_closed="1">
				<div id="cevap" >

					<cfloop from="0" to="#evaluate(get_question.answer_number-1)#" index="i">	
						<div id="answer<cfoutput>#i#</cfoutput>" style="display:none;">
							<div class="col col-12 ui-form-list-btn">
								<div class="form-group">&nbsp;
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12  col-xs-12" >
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1985.şık'> <cfoutput>#evaluate(i+1)#</cfoutput></label>
								<input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="<cfoutput>#evaluate("get_question.answer"&i+1&"_true")#</cfoutput>">
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
									<div class="form-group" id="item-answer_2">
										<textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text"  cols="35" rows="3" style="width:150px;"><cfoutput>#evaluate("get_question.answer"&i+1&"_text")#</cfoutput></textarea>
									</div>
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12  col-xs-12">
							<div class="form-group" id="item-answer_resim">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='668.resim'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12" >
									<cfif len(evaluate("get_question.answer"&i+1&"_photo"))>
										<img src="<cfoutput>#file_web_path#training/#evaluate("get_question.answer"&i+1&"_photo")#</cfoutput>" border="0"><br/>
										<input type="Checkbox" name="del_image<cfoutput>#i#</cfoutput>" id="del_image<cfoutput>#i#</cfoutput>" value="1">
										<cf_get_lang_main no='51.Sil'><br/>
									</cfif>
									<input type="File" name="answer<cfoutput>#i#</cfoutput>_photo" id="answer<cfoutput>#i#</cfoutput>_photo" style="width:250px;">
								</div>
							</div>
						</div>
							<div class="col col-12 col-md-12 col-sm-12  col-xs-12" >
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12" >
								</div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12" >
								<input type="radio" name="answer<cfoutput>#i#</cfoutput>_true" id="answer<cfoutput>#i#</cfoutput>_true" value="1" <cfif evaluate("get_question.answer"&i+1&"_true") eq 1>checked</cfif>>
								<label><cf_get_lang dictionary_id='46053.doğru'></label>
								</div>
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12" >
								<input type="radio" name="answer<cfoutput>#i#</cfoutput>_true" id="answer<cfoutput>#i#</cfoutput>_true" value="0" <cfif evaluate("get_question.answer"&i+1&"_true") eq 0>checked</cfif>>
								<label><cf_get_lang dictionary_id='46269.yanlis'></label>
							</div>
						</div>
						</div>
					</cfloop>
					<cfloop from="#get_question.answer_number#" to="19" index="i">
						<div id="answer<cfoutput>#i#</cfoutput>" style="display:none;">
							<div class="col col-12 ui-form-list-btn">
								<div class="form-group">&nbsp;
								</div>
							</div>
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1985.şık'> <cfoutput>#evaluate(i+1)#</cfoutput></label>
							<input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="">
						
								<!--- <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1985.şık'> <cfoutput>#evaluate(i+1)#</cfoutput></label> --->
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<div class="form-group" id="item-answer_3">
									<textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" cols="35" rows="3" style="width:150px;" ><cfoutput>#evaluate("get_question.answer"&i+1&"_text")#</cfoutput></textarea>
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12  col-xs-12" >
							<div class="form-group" id="item-answer_resim">
								<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='668.resim'></label>
								<div class="col col-9 col-md-9 col-sm-9 col-xs-12" >
									<input type="File" name="answer<cfoutput>#i#</cfoutput>_photo" id="answer<cfoutput>#i#</cfoutput>_photo" style="width:250px;">
								</div>
							</div>
						</div>
							<div class="col col-12 col-md-12 col-sm-12  col-xs-12" >
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12" >
								</div>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12" >
									<input type="radio" name="answer<cfoutput>#i#</cfoutput>_true" id="answer<cfoutput>#i#</cfoutput>_true" value="1" checked>
									<label><cf_get_lang dictionary_id='46053.doğru'></label>
								</div>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12" >
									<input type="radio" name="answer<cfoutput>#i#</cfoutput>_true" id="answer<cfoutput>#i#</cfoutput>_true" value="0">
									<label><cf_get_lang dictionary_id='46269.yanlis'></label>
								</div>	
						</div>
					</div>
					</cfloop>	
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<div class="col col-6 col-sm-12 right" >
				<cf_record_info query_name="UPD_QUESTION">
					<input type="Hidden" name="more" id="more" value=0>
					
					<cfinclude template="../query/get_ques_questions.cfm">
				</div>
				<div class="col col-6 col-sm-12" >
					<cfif get_ques_questions.recordcount>
						<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
					<cfelse>
						<cf_workcube_buttons type_format="1"  is_upd='1' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_question&question_id=#attributes.question_id#' add_function='kontrol()'>
					</cfif>	
					<cfsavecontent variable="message"><cf_get_lang no='254.Kaydet ve Yeni Soru Ekle'></cfsavecontent>
					<cf_workcube_buttons type_format="1" 
						is_upd='0' 
						insert_info='#message#' 
						insert_alert=''
						add_function="(upd_question.more.value=1)"
						is_cancel='0'>
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
			for (i=number+1;i<=19;i++)
			{
				eleman = eval("answer"+i);
				eleman.style.display = "none";
			}
		}
	else
		{
			for (i=0;i<=19;i++)
			{
				eleman = eval("answer"+i);
				eleman.style.display = "none";
			}
		}
			
	}
function kontrol()
	{
		if (document.upd_question.training_cat_id.value == 0)
		{
			alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='74.Kategori'>");
			return false;
		}
		var x_picture_Size = <cfoutput>#x_picture_#</cfoutput>;
	var pictureSize_ = x_picture_Size * 1024;
		for (var i=0;i<=document.upd_question.answer_number.value-1;i=i+1)
			{
				
		var photo = document.getElementById("answer"+i+"_photo");
        if(photo.files.length > 0){ 
	  var photoSize = photo.files[0].size;
	  if(photoSize > pictureSize_){
		  alert("<cf_get_lang dictionary_id='62913.Dosyanızın Maximum Boyutu'>" + x_picture_Size + "KB <cf_get_lang dictionary_id='44746.olmalıdır'>");
		  return false;
	  }
	}
	var obj =  photo.value.toUpperCase();
		var obj_ = list_len(obj,'.');
		var uzanti_ = list_getat(obj,list_len(obj,'.'),'.');
		if(obj!='' && uzanti_!='GIF' && uzanti_!='PNG' && uzanti_!='JPG' && uzanti_!='svg') 
		{
			alert("<cf_get_lang dictionary_id='62904.Lütfen bir resim dosyası(gif,jpg,svg veya png) giriniz'>!");        
			return false;
		}
	}
  
	  
		dogru_ = 0;
		if(document.upd_question.answer_number.value > 0)
			{
				for (var abc=0;abc<=document.upd_question.answer_number.value-1;abc=abc+1)
				{
					if(eval('document.upd_question.answer'+abc+'_true[0]').checked)
						dogru_ = dogru_ + 1;
				}
				if(dogru_ != '1')
					{
					alert('En Fazla Bir Adet Doğru Seçenek İşaretlemelisiniz!');
					return false;
					}
			}
		<cfoutput>
			#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_question' , #attributes.modal_id#)"),DE(""))#
		</cfoutput>
		/* return true; */
		
	}
function get_tran_sec(cat_id)//bölümün içini dolduruyor
	{
		document.upd_question.training_sec_id.options.length = 0;
		document.upd_question.training_id.options.length = 0;
		var get_sec = wrk_safe_query('trn_get_sec','dsn',0,cat_id);
		document.upd_question.training_sec_id.options[0]=new Option('Bölüm !','0');
		document.upd_question.training_id.options[0]=new Option('Konu !','0');
		for(var jj=0;jj<get_sec.recordcount;jj++)
			document.upd_question.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
		return true;
	}
function get_tran(sec_id)//konunun içini dolduruyor
	{
		document.upd_question.training_id.options.length = 0;
		var get_konu = wrk_safe_query('trnm_get_subj','dsn',0,sec_id);
		document.upd_question.training_id.options[0]=new Option('Konu !','0');
		for(var xx=0;xx<get_konu.recordcount;xx++)
			document.upd_question.training_id.options[xx+1]=new Option(get_konu.TRAIN_HEAD[xx],get_konu.TRAIN_ID[xx])
		return true;
	}
	<cfif isDefined("get_question.training_cat_id") and len(get_question.training_cat_id)>//bölüme bu soruya ait kategori id yolluyor
		get_tran_sec(<cfoutput>#get_question.training_cat_id#</cfoutput>);
	</cfif>
	
	<cfif isDefined("get_question.training_sec_id") and len(get_question.training_sec_id)>//konuya bu souya ait bölüm id yolluyor ve bu bölüme ait konular gelmiş oluyor
		get_tran(<cfoutput>#get_question.training_sec_id#</cfoutput>);
		document.upd_question.training_sec_id.value = <cfoutput>#get_question.training_sec_id#</cfoutput>;
	</cfif>
	
	<cfif isDefined("get_question.training_id") and len(get_question.training_id)>//bu soruya ait konu id yollanıyor seçili hale geliyor
		document.upd_question.training_id.value = <cfoutput>#get_question.training_id#</cfoutput>;
	</cfif>
	<cfif evaluate(get_question.answer_number) neq 0>
		upd_question.answer_number.selectedIndex = <cfoutput>#evaluate(get_question.answer_number-1)#</cfoutput>;
		goster(<cfoutput>#evaluate(get_question.answer_number-1)#</cfoutput>);
	</cfif>
</script>
