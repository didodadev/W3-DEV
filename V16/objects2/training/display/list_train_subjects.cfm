<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset training_management = createObject('component','V16.training_management.cfc.training_management')>
<cfset get_trainings = cfc.GET_TRAININGS()>
<cfset cfc2 = createObject('component','V16.training_management.cfc.training_groups')>
<cfset train_subjects = cfc2.get_training_group_subjects(train_group_id:attributes.train_group_id)>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_flat_list>
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='46049.Müfredat'></th>
                <th><cf_get_lang dictionary_id='57486.Kategori'> - <cf_get_lang dictionary_id='57995.Bölüm'></th>
                <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                <th><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
                <th width="20"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
                <th width="20"><i class="fa fa-minus"></i></th>
            </tr>
        </thead>
        <tbody>
            <cfif train_subjects.recordcount and train_subjects.status eq 1>
                <cfoutput query="train_subjects"> 
                    <tr>
                        <td width="35">#currentrow#</td>
                        <td>#train_head#</td>
                        <!--- <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_training_subjects&event=upd&train_id=#train_id#" class="tableyazi">#train_head#</a></td> --->
                        <td>
                            <cfset attributes.sec_id = TRAINING_SEC_ID>
                            <cfinclude template="../../../training_management/query/get_training_sec_names.cfm">
                            #GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#
                        </td>
                        <td> 
                            <cfif len(train_partners)><cf_get_lang dictionary_id='57585.Kurumsal Üye'></cfif>
                            <cfif len(train_partners) and (len(train_consumers) or len(train_departments))>,</cfif>
                            <cfif len(train_consumers)><cf_get_lang dictionary_id='57586.Bireysel Üye'></cfif>
                            <cfif len(train_consumers) and len(train_departments)>,</cfif>
                            <cfif len(train_departments)><cf_get_lang dictionary_id='57576.Çalışan'></cfif>
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
                        <td>
                            <a href="#request.self#?fuseaction=training_management.list_training_subjects&event=upd&train_id=#train_id#&training_sec_id=#TRAINING_SEC_ID#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                        </td>
                        <td>
                            <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=training_management.list_training_groups&event=removeSubject&train_group_id=#attributes.train_group_id#&train_id=#train_id#&subject_id=#TRAINING_GROUP_SUBJECTS_ID#','remove_train_subject_box','ui-draggable-box-small')"><i class="fa fa-minus"></i></a>
                        </td>
                    </tr>
                </cfoutput> 
            <cfelse>
                <tr> 
                    <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
</div>