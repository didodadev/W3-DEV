<cfparam name="attributes.train_group_id" default="#attributes.train_group_id#">
<cfparam name="attributes.class_id" default="#attributes.class_id#">
<cfparam name="attributes.process_stage" default="">
<cfinclude template="../query/get_training_group_attenders.cfm">
<cf_grid_list>
    <thead>
        <tr>
            <th width="10"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
            <th><cf_get_lang dictionary_id='57756.Durum'></th>
            <th><cf_get_lang dictionary_id='57467.Not'></th>
        </tr>
    </thead>
    <cfset attender_types = "get_attender_emps,get_attender_pars,get_attender_cons,get_attender_grps">
    <cfif get_attender_emps.recordcount or get_attender_pars.recordcount or get_attender_cons.recordcount or get_attender_grps.recordcount>
        <cfset counter = 1>
        <cfloop list="#attender_types#" item="att_type">
            <tbody>
                <cfoutput query="#att_type#">
                    <tr>
                        <td>#counter#</td>
                        <td>
                            <cfif type eq 'employee'>
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#get_attender_emps.k_id#','project');" class="tableyazi">#ad#&nbsp;#soyad#</a>
                            <cfelseif type eq 'partner'>
                                <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_attender_emps.k_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
                            <cfelseif type eq 'consumer'>
                                <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_attender_emps.k_id#','medium');" class="tableyazi">#ad#&nbsp;#soyad#</a>
                            <cfelse>
                                #ad#&nbsp;#soyad#
                            </cfif>
                        </td>
                        <cfquery name="get_joined" datasource="#dsn#">
                            SELECT
                                TGCA.JOINED,
                                TGCA.NOTE,
                                TGCA.PROCESS_STAGE
                            FROM
                                TRAINING_GROUP_CLASS_ATTENDANCE TGCA
                            WHERE
                                TRAINING_GROUP_ATTENDERS_ID = #ATTENDER_ID#
                                AND CLASS_ID = #class_id#
                                AND TRAINING_GROUP_ID = #train_group_id#
                        </cfquery>
                        <td>
                            <select name="joined" id="joined">
                                <option value="0" <cfif get_joined.JOINED eq 0>selected</cfif>><cf_get_lang dictionary_id='63441.Katılmadı'></option>
                                <option value="1" <cfif get_joined.JOINED eq 1>selected</cfif>><cf_get_lang dictionary_id='62465.Katıldı'></option>
                                <option value="2" <cfif get_joined.JOINED eq 2>selected</cfif>><cf_get_lang dictionary_id='40347.Mazeretli'></option>
                                <option value="3" <cfif get_joined.JOINED eq 3>selected</cfif>><cf_get_lang dictionary_id='63442.Geç Katıldı'></option>
                            </select>
                        </td>
                        <td><input type="text" name="note" id="note" value="#IIf(len(get_joined.note),get_joined.note,DE(0))#"></td>
                        <input type="hidden" name="k_id" id="k_id" value="#k_id#">
                        <input type="hidden" name="type" id="type" value="#type#">
                        <input type="hidden" name="class_attender_id" id="class_attender_id" value="#ATTENDER_ID#">
                        <input type="hidden" name="train_group_id" id="train_group_id" value="#train_group_id#">
                    </tr>
                    <cfset counter++ />
                    <cfif get_joined.process_stage gt 0>
                        <cfset process = get_joined.process_stage>
                    </cfif>
                </cfoutput>
            </tbody>
        </cfloop>
        <tfoot>
            <tr>
                <td><cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' is_detail='0'></td>
            </tr>
        </tfoot>
    <cfelse>
            <tr>
                <td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
    </cfif>
</cf_grid_list>