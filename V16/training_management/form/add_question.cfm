<cf_xml_page_edit fuseact="training_management.popup_form_add_question">	
<cfif fuseaction eq "training_management.popup_form_add_question">
	<cfset attributes.popup=1>
</cfif>	

<cfset xfa.add = "#request.self#?fuseaction=training_management.emptypopup_add_question">
<cfif not isdefined("attributes.training_sec_id")>
	<cfset attributes.training_sec_id = 0>
</cfif>
<cfif not isdefined("attributes.training_cat_id")>
	<cfset attributes.training_cat_id = 0>
</cfif>
<cfif not isdefined("attributes.training_id")>
	<cfset attributes.training_id = 0>
</cfif>
<cfquery name="GET_TRAINING_SEC" datasource="#dsn#">
	SELECT TRAINING_SEC_ID,SECTION_NAME FROM TRAINING_SEC
</cfquery>
<cfquery name="GET_TRAINING_CAT" datasource="#dsn#">
	SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12 ">
<cf_box title="#getLang('','Soru Ekle',46312)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform enctype="multipart/form-data" name="add_question" method="post" action="#xfa.add#">
		<cfif isdefined("attributes.popup")>
			<input type="Hidden" name="popup" id="popup" value="1">
		</cfif>
		<cfif isdefined("attributes.quiz_id")>
			<input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
		</cfif>
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<cf_seperator title="#getLang('','',58810)#" id="soru" is_closed="1">
				<div id="soru" >
					<div class="form-group" id="item-status" >
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='344.durum'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 "><input type="checkbox" name="status" id="status" value="1"><label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='81.aktif'>
					</div>
					</div>
					<div class="form-group" id="item-training_cat_id">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='74.kategori'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 ">
							<select name="training_cat_id" id="training_cat_id" size="1" onChange="get_tran_sec(this.value)" style="width:250px;">
								<option value="0"><cf_get_lang_main no='74.kateogri'>  !</option>
								<cfoutput query="get_training_cat">
									<option value="#training_cat_id#"<cfif attributes.training_cat_id eq training_cat_id>selected</cfif>>#training_cat#</option>
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
							<option value="0"><cf_get_lang_main no='68.konu'>!</option>
						</select>				  
						</div>
					</div>
					<div class="form-group" id="item-question">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1398.soru'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 "><textarea name="question" id="question" style="width:250px;height:60px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-QUESTION_INFO">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='217.açıklama'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12 "><textarea name="QUESTION_INFO" id="QUESTION_INFO" style="width:250px;height:60px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-time">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1716.süre'></label>
						<div class="col col-3 col-md-2 col-sm-2 ">
						<cfsavecontent variable="message"><cf_get_lang no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1716.süre'></cfsavecontent>
						<cfinput type="text" name="time" value="1" style="width:50px;"required="Yes" validate="integer" message="#message#"></div>
						<div class="col col-2 col-md-2 col-sm-2 ">
						<label><cf_get_lang_main no='715.dk'></label>
						</div>
					</div>
					<div class="form-group" id="item-QUESTION_point">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang_main no='1572.puan'></label>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12 ">
						<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1572.puan'></cfsavecontent>
						<cfinput type="text" name="QUESTION_point" value="0" style="width:50px;" required="Yes" validate="integer" message="#message#" maxlength="5">
						</div>
					</div>
					<div class="form-group" id="item-answer_number">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang no='124.şık sayısı'></label>
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12 ">
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
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<cf_seperator title="#getLang('','cevap',58654)#" id="cevap" is_closed="1">
				<div id="cevap" >
					<cfloop from="0" to="19" index="i">
					
						<div id="answer<cfoutput>#i#</cfoutput>" style="display:none;">
							<div class="col col-12 ui-form-list-btn">
								<div class="form-group">&nbsp;
								</div>
							</div>
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12 btn.yellow-mint-stripe " ><cf_get_lang_main no='1985.şık'> <cfoutput>#evaluate(i+1)#</cfoutput>   </label>  <span></span>
							<input type="Hidden" name="answer<cfoutput>#i#</cfoutput>_type" id="answer<cfoutput>#i#</cfoutput>_type" value="0">
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<div class="form-group" id="item-answer_2">
									<textarea name="answer<cfoutput>#i#</cfoutput>_text" id="answer<cfoutput>#i#</cfoutput>_text" cols="35" rows="3" style="width:150px;"></textarea>
								</div>
							</div>
							<div class="col col-12 col-md-12 col-sm-12  col-xs-12">
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
									<label ><cf_get_lang dictionary_id='46269.yanlis'></label>
								</div>
							</div>
						</div>
					
					</cfloop>
				</div>
				
			</div>
		</cf_box_elements>
		
			<cf_box_footer>
				<input type="hidden" name="more" id="more" value="0">
				<cfsavecontent variable="message"><cf_get_lang no='254.Kaydet ve Yeni Soru Ekle'></cfsavecontent>
				<cf_workcube_buttons 
					is_upd='0' 
					insert_info='#message#' 
					insert_alert=''
					add_function='add_question_control()&&(document.add_question.more.value=1)'
					is_cancel='0'>
				<cf_workcube_buttons is_upd='0' add_function='add_question_control()&&(document.add_question.more.value=0)'>
			</cf_box_footer>
		
	</cfform>
</cf_box>
</div>
<script type="text/javascript">
function get_tran_sec(cat_id)
{
	document.add_question.training_sec_id.options.length = 0;
	document.add_question.training_id.options.length = 0;
	var get_sec = wrk_safe_query('trn_get_sec','dsn',0,cat_id);
	document.add_question.training_sec_id.options[0]=new Option('Bölüm !','0')
	document.add_question.training_id.options[0]=new Option('Konu !','0');
	for(var jj=0;jj<get_sec.recordcount;jj++)
	{
		document.add_question.training_sec_id.options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
	}
}
function get_tran(sec_id)
{
	document.add_question.training_id.options.length = 0;
	var get_konu = wrk_safe_query('trnm_get_subj','dsn',0,sec_id);
	document.add_question.training_id.options[0]=new Option('Konu !','0')
	for(var xx=0;xx<get_konu.recordcount;xx++)
	{
		document.add_question.training_id.options[xx+1]=new Option(get_konu.TRAIN_HEAD[xx],get_konu.TRAIN_ID[xx])
	}
}
   
<cfif isDefined("attributes.training_cat_id") and len(attributes.training_cat_id)>//bölüme bu soruya ait kategori id yolluyor
	get_tran_sec(<cfoutput>#attributes.training_cat_id#</cfoutput>);
</cfif>

<cfif isDefined("attributes.training_sec_id") and len(attributes.training_sec_id)>//konuya bu souya ait bölüm id yolluyor ve bu bölüme ait konular gelmiş oluyor
	get_tran(<cfoutput>#attributes.training_sec_id#</cfoutput>);
	document.add_question.training_sec_id.value = <cfoutput>#attributes.training_sec_id#</cfoutput>;
</cfif>

<cfif isDefined("attributes.training_id") and len(attributes.training_id)>//bu soruya ait konu id yollanıyor seçili hale geliyor
	document.add_question.training_id.value = <cfoutput>#attributes.training_id#</cfoutput>;
</cfif>
function goster(number)
{
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
function add_question_control()
{
	var x_pictureSize = <cfoutput>#x_picture#</cfoutput>;
	var pictureSize_ = x_pictureSize * 1024;
	if (document.add_question.training_cat_id.value == 0)
	{
		alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='74.Kategori'>");
		return false;
	}
	for (var i=0;i<=document.add_question.answer_number.value-1;i=i+1)
			{
				
		var photo = document.getElementById("answer"+i+"_photo");
        if(photo.files.length > 0){ 
	  var photoSize = photo.files[0].size;
	  if(photoSize > pictureSize_){
		  alert("<cf_get_lang dictionary_id='62913.Dosyanızın Maximum Boyutu'>" + x_pictureSize + "KB <cf_get_lang dictionary_id='44746.olmalıdır'>");
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
	if(document.add_question.answer_number.value > 0)
		{
			for (var abc=0;abc<=document.add_question.answer_number.value-1;abc=abc+1)
			{
				if(eval('document.add_question.answer'+abc+'_true[0]').checked)
					dogru_ = dogru_ + 1;
			}
			if(dogru_ != '1')
				{
				alert('En Fazla Bir Adet Doğru Seçenek İşaretlemelisiniz!');
				return false;
				}
		}
	<cfoutput>
		#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_question' , #attributes.modal_id#)"),DE(""))#
	</cfoutput>
	/* return true; */
}

</script>
