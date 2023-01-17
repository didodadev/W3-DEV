<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.training_subject_id" default="">
<!--- <cfinclude template="../query/get_training_sec_names.cfm"> --->
<cfquery name="get_training_cat" datasource="#dsn#">
	SELECT 
        TRAINING_CAT_ID, 
        TRAINING_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP
    FROM 
        TRAINING_CAT
</cfquery>
<cfquery name="get_training_sec" datasource="#dsn#">
	SELECT 
        TRAINING_CAT_ID, 
        TRAINING_SEC_ID, 
        SECTION_NAME, 
        RECORD_EMP, 
        RECORD_PAR, 
        RECORD_DATE, 
        RECORD_IP 
    FROM 
        TRAINING_SEC
</cfquery>
<cfinclude template="../query/get_training_subjects.cfm">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_questions.cfm">
<cfelse>
	<cfset get_questions.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_questions.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform method="post" action="#request.self#?fuseaction=training_management.list_questions">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0" plus="0">
				<div class="form-group" >
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" maxlength="50" placeholder="#place#" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<select name="training_cat_id" id="training_cat_id" style="width:135px">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_training_cat">
							<option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and (attributes.training_cat_id eq training_cat_id)>selected</cfif>>#training_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="training_sec_id" id="training_sec_id" style="width:135px">
						<option value=""><cf_get_lang dictionary_id='57995.Bölüm'></option>
						<cfoutput query="get_training_sec">
							<option value="#training_sec_id#" <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id eq training_sec_id)>selected</cfif>>#section_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="training_subject_id" id="training_subject_id">
						<option value=""><cf_get_lang dictionary_id='57480.Konu'>
						<cfoutput query="get_training_subjects">
							<option value="#TRAIN_ID#" <cfif attributes.training_subject_id eq TRAIN_ID>selected</cfif>>#TRAIN_HEAD#
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="status" id="status">
						<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="" <cfif not len(attributes.status)>selected</cfif> ><cf_get_lang dictionary_id='58081.Hepsi'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyup="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group" id="item-submit">    
					<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.popup_form_add_question')" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                </div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Soru Bankası',29993)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58810.Soru'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="35"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.popup_form_add_question')"><i class="fa fa-plus" alt="<cf_get_lang no='503.Formu Doldur'>" title="<cf_get_lang_main no='170.Ekle'>" ></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_questions.recordcount>
					<cfoutput query="get_questions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td height="22"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_upd_question&question_id=#question_id#&popup=1');" class="tableyazi">#left(QUESTION,100)#</a></td>
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
								<cfif len(get_questions.RECORD_EMP)>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#get_questions.record_emp#','project');" class="tableyazi">#get_emp_info(get_questions.record_emp,0,1)#</a>
								<cfelseif len(record_par)>
								<cfset attributes.partner_id = RECORD_PAR>
								<cfinclude template="../query/get_partner.cfm">
									<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.PARTNER_ID#');" class="tableyazi">#get_partner.company_partner_name# #get_partner.company_partner_surname#</a>
								</cfif>
							</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td width="35"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=training_management.popup_form_upd_question&question_id=#question_id#')"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>   
							</a>
						</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "">
		<cfif get_questions.recordcount gt 0 and (attributes.totalrecords gt attributes.maxrows)>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif isdefined("attributes.training_sec_id")>
			<cfset url_str = "#url_str#&training_sec_id=#training_sec_id#">
			<cfelse>
				<cfset attributes.training_sec_id = 0>
			</cfif>
			<cfif isdefined("attributes.training_cat_id")>
			<cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
			<cfelse>
				<cfset attributes.training_cat_id = 0>
			</cfif>
			<cfif isdefined("attributes.training_subject_id")>
			<cfset url_str = "#url_str#&training_subject_id=#training_subject_id#">
			<cfelse>
				<cfset attributes.training_subject_id = 0>
			</cfif>
			<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="training_management.list_questions#url_str#"></td>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
