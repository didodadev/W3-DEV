<cfinclude template="../query/get_training_cats.cfm">
<cfinclude template="../query/get_trainings.cfm">
<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#field_name#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_cat_id")>
	<cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
</cfif>
<cfif isdefined("attributes.attenders")>
	<cfset url_str = "#url_str#&attenders=#attenders#">
</cfif>
<cfif isdefined("attributes.train_group_id")>
	<cfset url_str = "#url_str#&train_group_id=#train_group_id#">
</cfif>
<cfif isdefined("attributes.draggable")>
	<cfset url_str = "#url_str#&draggable=#draggable#">
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_trainings.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head_">
	<cfif isdefined("attributes.training_sec_id") and len(attributes.training_sec_id)>
	  <cfquery name="get_section" datasource="#dsn#">
		SELECT SECTION_NAME FROM TRAINING_SEC WHERE TRAINING_SEC_ID = #attributes.training_sec_id#
	  </cfquery>
	   <cfoutput>#get_section.SECTION_NAME#</cfoutput>
	<cfelse>
	   <cf_get_lang dictionary_id='46584.Bağlı Konular'>
	</cfif>
</cfsavecontent>
<cf_box title="#getLang('','Bağlı Konular',46584)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="training_subject_select_form" method="post" action="">
        <cfif isdefined("attributes.train_group_id")>
            <cfinput type="hidden" name="train_group_id" value="#attributes.train_group_id#">
        </cfif>
        <div class="ui-form-list flex-list">
            <div class="form-group medium">
                <cfif isdefined("attributes.keyword")>
                    <cfinput type="text" name="keyword" value="#attributes.keyword#">
                <cfelse>
                    <cfinput type="text" name="keyword">
                </cfif>
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </div>
    </cfform>
    <cf_flat_list>
        <thead>
            <tr> 
                <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='46049.Müfredat'></th>
                <th><cf_get_lang dictionary_id='57486.Kategori'> - <cf_get_lang dictionary_id='57995.Bölüm'></th>
                <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                <th><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
                <th width="20"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                <th width="20"><i class="fa fa-plug" title="<cf_get_lang dictionary_id='57909.İlişkilendir'>" alt="<cf_get_lang dictionary_id='57909.İlişkilendir'>"></i></th>
            </tr>
        </thead>  
        <tbody>
            <cfif get_trainings.recordcount>
                <cfoutput query="get_trainings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="35">#currentrow#</td>
                        <td>#train_head#</td>
                        <td>
                            <cfset attributes.sec_id = TRAINING_SEC_ID>
                            <cfinclude template="../query/get_training_sec_names.cfm">
                            #GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#
                        </td>
                        <td>#left(train_objective, 50)#</td>
                        <td>
                            <cfif len(get_trainings.record_emp)>
                                #get_emp_info(get_trainings.record_emp,0,0)#
                            <cfelseif len(record_par)>
                                <cfset attributes.partner_id = record_par>
                                <cfinclude template="../query/get_partner.cfm">
                                #get_partner.company_partner_name# #get_partner.company_partner_surname#
                            </cfif>
                        </td>
                        <td>
                            <a href="#request.self#?fuseaction=training_management.list_training_subjects&event=upd&train_id=#train_id#&training_sec_id=#TRAINING_SEC_ID#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                        </td>
                        <td style="text-align:center;" nowrap="nowrap">
                            <cfif isDefined("attributes.train_group_id")>
                                <a href="javascript://" onClick="<cfif isdefined("attributes.draggable") >openBoxDraggable('#request.self#?fuseaction=training_management.popup_add_training_group_subjects&train_id=#train_id#&training_sec_id=#TRAINING_SEC_ID#&training_cat_id=#TRAINING_CAT_ID#&train_group_id=#attributes.train_group_id#',#attributes.modal_id#)<cfelse>windowopen('#request.self#?fuseaction=training_management.popup_add_training_group_subjects&train_id=#train_id#&training_sec_id=#TRAINING_SEC_ID#&training_cat_id=#TRAINING_CAT_ID#&train_group_id=#attributes.train_group_id#','list');</cfif>"><i class="fa fa-plug" title="<cf_get_lang dictionary_id='57909.İlişkilendir'>"></i></a>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput> 
            <cfelse>
                <tr> 
                    <td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
    <cfif get_trainings.recordcount>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="training_management.popup_list_training_subjects_popup#url_str#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cfif>
</cf_box>
<cfif isdefined("attributes.train_group_id")>
    <script>
        window.onbeforeunload = function (e) {
            window.opener.refresh_box('curriculum','index.cfm?fuseaction=objects.widget_loader&widget_load=listTrainSubjects&train_group_id=<cfoutput>#attributes.TRAIN_GROUP_ID#</cfoutput>','0');
        };
    </script>
</cfif>