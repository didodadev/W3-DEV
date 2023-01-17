<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_sec_id")>
  <cfset url_str = "#url_str#&training_sec_id=#training_sec_id#">
<cfelse>
	<cfset attributes.training_sec_id = 0>
</cfif>
<cfif isdefined("attributes.quiz_id")>
  <cfset url_str = "#url_str#&quiz_id=#quiz_id#">
<cfelse>
	<cfset attributes.quiz_id = 0>
</cfif>
<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset get_training_sec_names=cfc.GET_TRAINING_SECS_FUNC()>
<cfinclude template="../query/get_questions.cfm">
<cfquery name="GET_MAX_QUESTIONS" datasource="#dsn#">
	SELECT 
    	MAX_QUESTIONS
  	FROM
    	QUIZ
  	WHERE
    	QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
</cfquery>
<cfquery name="GET_QUESTION_COUNT" datasource="#dsn#">
	SELECT COUNT(QUESTION_ID) AS Q_COUNT
  	FROM
    	QUIZ_QUESTIONS
  	WHERE
    	QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
</cfquery>
<cfset max_q = GET_MAX_QUESTIONS.MAX_QUESTIONS - GET_QUESTION_COUNT.Q_COUNT>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_questions.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('main',675)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform method="post" action="" name="add_question_search">
		<cf_box_elements>
			<div class="ui-form-list flex-list">
                <div class="form-group medium">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group medium">
					<select name="training_sec_id" id="training_sec_id" style="width:125px;">
						<option value="0" selected><cf_get_lang_main no='28.Egitim Yonetimi'> 
						<cfoutput query="get_training_sec_names">
							<option value="#training_sec_id#" <cfif attributes.training_sec_id eq training_sec_id>selected</cfif>>#training_cat# / #section_name#
						</cfoutput>
					</select>
                </div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_question_search' , '#attributes.modal_id#')"),DE(""))#">
				</div>
			</div>
		</cf_box_elements>
	</cfform>
	<cfform name="add_questions_form" method="post" action="">
        <cfinput name="quiz_id" type="hidden" value="#attributes.quiz_id#">
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang_main no='1398.Soru'></th>
					<th width="100"><cf_get_lang_main no='74.Bölüm'></th>
					<th><cf_get_lang_main no='68.Konu'></th>
					<th width="100"><cf_get_lang_main no='487.Kaydeden'></th>
					<th width="55"><cf_get_lang_main no='71.Kayıt'></th>
	<!---20131031---><th nowrap="nowrap" style="text-align:center;"><input type="checkbox" name="allSelecthemand" id="allSelecthemand" onClick="wrk_select_all('allSelecthemand','row_demand_accept');"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_questions.recordcount>
					<cfoutput query="get_questions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td><a href="#request.self#?fuseaction=training_management.emptypopup_add_question2quiz&quiz_id=#attributes.quiz_id#&id_list=#attributes.quiz_id#;#question_id#&" class="tableyazi">#left(QUESTION,100)#</a></td><!--- Seçilen soruyu ekle ve göster --->
							<td>
								<cfif len(training_sec_id)>
									<cfset attributes.training_sec_id = training_sec_id>
									<cfinclude template="../query/get_training_sec.cfm">
									#get_training_sec.section_name#
								</cfif>
							</td>
							<td>
								<cfif len(training_id)>
									<cfset attributes.training_id = training_id>
									<cfinclude template="../query/get_training_name.cfm">
									#get_training_name.train_head#
								</cfif>
							</td>
							<td>
								<cfif len(RECORD_EMP)>
									#get_emp_info(get_questions.RECORD_EMP,0,0)#
								<cfelseif len(record_par)>
									<cfset attributes.partner_id = RECORD_PAR>
									<cfinclude template="../query/get_partner.cfm">
									#get_partner.company_partner_name# #get_partner.company_partner_surname#
								</cfif>
							</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
			<!---20131031---><td style="text-align:center;"><input type="checkbox" name="row_demand_accept" id="row_demand_accept" value="#attributes.quiz_id#;#question_id#"></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
			<tfoot><!---20131031--->
				<tr height="25">
					<td colspan="6" style="text-align:right;">
						<cf_workcube_buttons add_function='SoruEkle()'>
						<!--- <input type="button" name="kaydetBtn" id="kaydetBtn" value="<cf_get_lang_main no='49.Kaydet'>" onclick="SoruEkle();"> --->
						<input type="hidden" name="id_list" id="id_list" value="">
						<input type="hidden" name="add_questions" id="add_questions" value="">
						<input type="hidden" name="max_questions" id="max_questions" value="<cfoutput>#max_q#</cfoutput>">
					</td>
				</tr>
			</tfoot><!---20131031--->
		</cf_flat_list>
	</cfform>
	<cfif get_questions.recordcount and (attributes.totalrecords gt attributes.maxrows)>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.popup_list_questions#url_str#">
	</cfif>
</cf_box>

<script type="text/javascript">
/* function get_tran_sec(cat_id)
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
</cfif> */
	function SoruEkle(){<!---20131031--->
		var is_selected=0;
		if(document.getElementsByName('row_demand_accept').length > 0){
			var id_list="";
			if(document.getElementsByName('row_demand_accept').length ==1){
				if(document.getElementById('row_demand_accept').checked==true){
					is_selected=1;
					id_list+=document.add_questions_form.row_demand_accept.value+',';
				}
			} else {
				for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
					if(document.add_questions_form.row_demand_accept[i].checked==true){ 
						id_list+=document.add_questions_form.row_demand_accept[i].value+',';
						is_selected=1;	
					}
				}
			}
		}
		if(is_selected==1){
			if (document.getElementById('max_questions').value != 0){
				if (list_len(id_list,',')-1 > document.getElementById('max_questions').value){
					alert("En fazla "+ document.getElementById('max_questions').value +" soru seçmelisiniz.");
				}
				else if(list_len(id_list,',') > 1){
					id_list = id_list.substr(0,id_list.length-1);
					document.getElementById('id_list').value=id_list;
					document.getElementById('add_questions').value=1;
					add_questions_ = document.getElementById('add_questions').value;
					
					add_questions_form.action='<cfoutput>#request.self#?fuseaction=training_management.emptypopup_add_question2quiz</cfoutput>&id_list='+document.getElementById('id_list').value;
					add_questions_form.submit();
					
				}
			} else {
				alert('Testteki soru sayısı maksimuma ulaşmıştır!');
			}
		} else {
			alert("En az bir satır seçmelisiniz.");
			return false;
		}
		<cfoutput>
			#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_questions_form' , #attributes.modal_id#)"),DE(""))#
		</cfoutput>
	}<!---20131031--->
</script>
