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
<cfif isdefined("attributes.cntid")>
  <cfset url_str = "#url_str#&cntid=#cntid#">
<cfelse>
	<cfset attributes.cntid = 0>
</cfif>
<cfset cfc = createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset getContent = createObject("component","V16.content.cfc.get_content")>
<cfset get_training_sec_names=cfc.GET_TRAINING_SECS_FUNC()>
<cfinclude template="../query/get_questions.cfm">

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
					<cf_wrk_search_button button_type="4">
				</div>
			</div>
		</cf_box_elements>
	</cfform>

	<cfform name="add_questions_form" method="post" action="">
		<cf_flat_list>
			<thead>
				<tr>
                    <th width="15">No</th>
					<th><cf_get_lang_main no='1398.Soru'></th>
					<th width="100"><cf_get_lang_main no='74.Bölüm'></th>
					<th><cf_get_lang_main no='68.Konu'></th>
					<th width="100"><cf_get_lang_main no='487.Kaydeden'></th>
					<th width="55"><cf_get_lang_main no='71.Kayıt'></th>
	                <th nowrap="nowrap" style="text-align:center;"><input type="checkbox" name="allSelecthemand" id="allSelecthemand" onClick="wrk_select_all('allSelecthemand','row_demand_accept');"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_questions.recordcount>
					<cfoutput query="get_questions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
                            <td>#currentrow#</td>
							<td style="word-wrap:break-word;">#left(QUESTION,100)#</td>
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
			                <td style="text-align:center;"><input type="checkbox" name="row_demand_accept" id="row_demand_accept" value="#attributes.cntid#;#question_id#"></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
        <cf_box_footer>
            <cf_workcube_buttons
                add_function="kontrol()"
                id_upd="0"
                data_action="/V16/content/cfc/get_content:add_related_questions"
            >
        </cf_box_footer>
        <cfinput name="id_list" id="id_list" type="hidden">
	</cfform>
	<cfif get_questions.recordcount and (attributes.totalrecords gt attributes.maxrows)>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="training_management.popup_list_questions#url_str#">
	</cfif>
</cf_box>

<script type="text/javascript">
	function kontrol(){
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
            if(list_len(id_list,',') > 1){
                id_list = id_list.substr(0,id_list.length-1);
                document.getElementById('id_list').value=id_list;
                document.getElementById('add_questions').value=1;
                add_questions_ = document.getElementById('add_questions').value;
                /* add_questions_form.action='<cfoutput>#request.self#?fuseaction=training_management.emptypopup_add_question2quiz</cfoutput>&id_list='+document.getElementById('id_list').value; */
                $("#id_list").val(add_questions_);
            }
		} else {
			alert("En az bir satır seçmelisiniz.");
			return false;
		}
		<cfoutput>
			#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_questions_form' , #attributes.modal_id#)"),DE(""))#
		</cfoutput>
	}
</script>