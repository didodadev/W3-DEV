<cfparam name="attributes.keyword" default="">
<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset get_training_cat = cfc.get_training_cat()>
<cfset get_emp_det = cfc.get_emp_det()>
<cfset get_training_sec = cfc.get_training_sec()>
<cfset get_train_id = cfc.get_train_id( 
    RELATION_ACTION :iif(isDefined("attributes.RELATION_ACTION"),"attributes.RELATION_ACTION",DE("")),
    RELATION_ACTION_ID : iif(isDefined("attributes.RELATION_ACTION_ID"),"attributes.RELATION_ACTION_ID",DE(""))
)>
<cfif isdefined("attributes.form_submitted")>
    <cfset GET_TRAININGS = cfc.GET_TRAININGS( 
        KEYWORD :iif(isDefined("attributes.KEYWORD"),"attributes.KEYWORD",DE("")), 
        TRAINING_CAT_ID :iif(isDefined("attributes.TRAINING_CAT_ID"),"attributes.TRAINING_CAT_ID",DE("")), 
        TRAINING_SEC_ID : iif(isDefined("attributes.TRAINING_SEC_ID"),"attributes.TRAINING_SEC_ID",DE("")),
        STATUS : iif(isDefined("attributes.STATUS"),"attributes.STATUS",DE(""))
    )>
<cfelse>
    <cfset get_trainings.recordcount = 0>
</cfif>
<cfset GET_LANGUAGE = cmp.GET_LANGUAGE_F()>
<cfset train_id_list = valuelist(get_train_id.RELATION_FIELD_ID)>
<cfset url_str = "">
<cfset url_str = "#url_str#&form_submitted=1">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_sec_id")>
	<cfset url_str = "#url_str#&training_sec_id=#training_sec_id#">
<cfelse>
	<cfset attributes.training_sec_id = 0>
</cfif>
<cfif isdefined("attributes.training_cat_id")>
	<cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
<cfelse>
	<cfset attributes.training_sec_id = 0>
</cfif>
<cfif isdefined("attributes.status")>
	<cfset url_str = "#url_str#&status=#attributes.status#">
<cfelse>
	<cfset attributes.status = 1>
</cfif>
<cfif isdefined("attributes.currency_id")>
	<cfset url_str = "#url_str#&currency_id=#attributes.currency_id#">
<cfelse>
	<cfset attributes.currency_id = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_trainings.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform method="post" action="#request.self#?fuseaction=training_management.list_training_subjects">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search><!---20131104--->
				<!---<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" maxlength="50" value="#attributes.keyword#" style="width:80px;">
				</div>--->
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" id="keyword" placeHolder="#getlang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="training_cat_id" id="training_cat_id">
						<option value="0"><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_training_cat">
							<option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and (attributes.training_cat_id eq training_cat_id)>selected</cfif>>#training_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="training_sec_id" id="training_sec_id">
						<option value="0"><cf_get_lang dictionary_id='57995.Bölüm'></option>
						<cfoutput query="get_training_sec">
							<option value="#training_sec_id#" <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id eq training_sec_id)>selected</cfif>>#section_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="status" id="status">
						<option VALUE="1" <cfif isdefined("attributes.status") and attributes.status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option VALUE="0" <cfif isdefined("attributes.status") and attributes.status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option VALUE="" <cfif isdefined("attributes.status") and not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" onKeyUp="isNumber (this)">
				</div>	
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
			</cf_box_search> 
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Müfredat',46049)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="15"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='46049.Müfredat'></th>
					<th width="250"><cf_get_lang dictionary_id='57486.Kategori'> - <cf_get_lang dictionary_id='57995.Bölüm'></th>
					<th width="100"><cf_get_lang dictionary_id='58996.Dil'></th>
					<th width="100"><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th width="150"><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
					<th width="100"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="20"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_training_subjects&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_trainings.recordcount>
					<cfoutput query="get_trainings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_training_subjects&event=upd&train_id=#train_id#" class="tableyazi">#train_head#</a></td>
							<td>
								<cfset attributes.sec_id = TRAINING_SEC_ID>
								<cfinclude template="../query/get_training_sec_names.cfm">
								#GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#
							</td>
							<td>
                                <cfloop query="GET_LANGUAGE">
                                    <cfif GET_LANGUAGE.language_short eq get_trainings.language>#GET_LANGUAGE.language_set#</cfif>
                                </cfloop>
							</td>
                            <td>
                                <cf_workcube_process type="color-status" process_stage='#get_trainings.training_stage#'>
                            </td>
							<td>
								<cfif len(get_trainings.record_emp)>
									#get_emp_info(get_trainings.record_emp,0,1)#
								<cfelseif len(record_par)>
									<cfset attributes.partner_id = record_par>
									<cfinclude template="../query/get_partner.cfm">
									<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.PARTNER_ID#','medium');" class="tableyazi">#get_partner.company_partner_name# #get_partner.company_partner_surname#</a>
								</cfif>
							</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil -->
							<td>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_training_subjects&event=upd&train_id=#train_id#&training_sec_id=#TRAINING_SEC_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="10"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif get_trainings.recordcount and attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#listgetat(attributes.fuseaction,1,'.')#.list_training_subjects#url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>