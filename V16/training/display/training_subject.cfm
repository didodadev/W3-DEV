<cfquery name="GET_TRAINING_IN_SUBJECT" datasource="#DSN#">
	SELECT 
		IS_READED
	FROM 
		TRAINING_IN_SUBJECT
	WHERE 
		TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#"> AND 
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>

<cfset attributes.training_id = attributes.train_id>
<cfinclude template="../query/get_related_cont.cfm">
<cfinclude template="../query/get_training_subject.cfm">
<cfif len(get_training_subject.training_sec_id)>
	<cfset attributes.training_sec_id = get_training_subject.training_sec_id>
	<cfinclude template="../query/get_training_sec.cfm">
<cfelse>
	<cfset attributes.training_sec_id = ''>
</cfif>
<cfinclude template="../query/get_training_quiz_names.cfm">
<cfinclude template="../query/get_training_questions.cfm">
<table class="dph">
	<tr>
    	<td class="dpht"><cf_get_lang_main no='68.Konu'> : <cfoutput>#get_training_subject.train_head#</cfoutput></td>
        <td class="dphb">
			<cfoutput>
				<cfif len(get_training_subject.record_emp) and get_workcube_app_user(get_training_subject.record_emp, 0).recordcount>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_message&employee_id=#get_training_subject.RECORD_EMP#','medium');"><img src="/images/onlineuser.gif"  border="0" title="<cf_get_lang no='85.Soru Sor'>"></a>
				<cfelse>
					<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_nott&public=1&employee_id=#get_training_subject.RECORD_EMP#','small');"><img src="/images/visit_note.gif"  border="0" title="<cf_get_lang no='85.Soru Sor'>"></a>
				</cfif>			
				<cfif not listfindnocase(denied_pages,'training.popup_form_add_training_note')><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.popup_form_add_training_note&training_id=#attributes.train_id#','list');"><img src="/images/add_not.gif" title="<cf_get_lang_main no='53.Not Ekle'>" border="0"></a></cfif>
				<cfif not listfindnocase(denied_pages,'training.popup_view_training_comment')><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.popup_view_training_comment&training_id=#attributes.train_id#','medium');"><img src="/images/im.gif" border="0" title="<cf_get_lang no='75.Yorum Oku'>"></a></cfif>
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_training_subject&action=mail&id=#url.train_id#&module=training&trail=1','page');return false;"><img src="/images/mail.gif" border="0" title="<cf_get_lang_main no='63.Mail Gönder'>"></a> 
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_training_subject&action=pdf&id=#url.train_id#&module=training&trail=1','page')"><img src="/images/pdf.gif" title="<cf_get_lang_main no='66.PDF Yap'>" border="0"></a>	
				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_training_subject&action=print&id=#url.train_id#&module=training&trail=1','page');return false;"><img src="/images/print.gif"  title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a> 
			</cfoutput>
			<cfif get_module_user(34)>
				<cfoutput><a href="#request.self#?fuseaction=training.form_upd_training_subject&train_id=#attributes.train_id#"><img src="/images/refer.gif" border="0"></a></cfoutput>
			</cfif>
        </td>
    </tr>
</table>
<table class="dpm">
	<tr>
    	<td class="dpml">
			<cfoutput>
            	<cf_box> 
                    <table>
                        <tr>
                            <td class="txtbold" width="120"><cf_get_lang no='97.Konuyu Aldım'></td>
                            <td>:</td>
                            <td>
                            	<div id="set_in_subject_div">
                                    <input <cfif isDefined("attributes.is_readed") or (get_training_in_subject.RecordCount and get_training_in_subject.is_readed)>disabled="disabled"</cfif> name="is_readed" id="is_readed" type="checkbox" <cfif isDefined("attributes.is_readed") or (get_training_in_subject.RecordCount and get_training_in_subject.is_readed)>checked</cfif> onclick="ajax_yukle()">
                                    <font color="red"><cfif isDefined("attributes.is_readed") or (get_training_in_subject.RecordCount and get_training_in_subject.is_readed)>Konuyu Okudunuz.<cfelse><cf_get_lang no='207.Konuyu okuduysanız lütfen checkbox ı şeçiniz'></cfif></font>
                                </div>
                           </td>
                       </tr>
                       <tr>
                           <td class="txtbold"><cf_get_lang_main no='583.Bölüm'></td>
                           <td>:</td>
                           <td><cfif len(attributes.training_sec_id)>#get_training_sec.section_name#</cfif></td>
                       </tr>
                       <tr>
                           <td class="txtbold"><cf_get_lang no='7.Amaç'></td>
                           <td>:</td>
                           <td>#get_training_subject.train_objective#</td>
                       </tr>
                       <tr>
                            <td class="txtbold"><cf_get_lang_main no='68.Başlık'></td>
                            <td>:</td>
                            <td>#get_training_subject.train_head#</td>
                       </tr>
                       <tr>
                            <td class="txtbold"><cf_get_lang no='51.Eğitimci'></td>
                            <td>:</td>
                            <td>
                                <cfif len(get_training_subject.trainer_emp)>
                                    #get_emp_info(get_training_subject.trainer_emp,0,0)#
                          </cfif>
                                <cfif len(get_training_subject.trainer_par)>
                                    <cfset attributes.partner_id = get_training_subject.trainer_par>
                                    <cfinclude template="../query/get_partner.cfm">
                                    #get_partner.company_partner_name# #get_partner.company_partner_surname#
                              </cfif>
                            </td>
                       </tr>
                       <tr>
                            <td class="txtbold"><cf_get_lang no ='120.Eğitim Tipi'></td>
                            <td>:</td>
                            <td>
                                <cfif get_training_subject.training_type eq 1>
                                    <cf_get_lang no ='105.Standart Eğitim'>
                                <cfelseif get_training_subject.training_type eq 2>
                                    <cf_get_lang no ='121.Teknik Gelişim Eğitimi'>
                                <cfelseif get_training_subject.training_type eq 3>
                                    <cf_get_lang no ='108.Zorunlu Eğitim'>
                                <cfelseif get_training_subject.training_type eq 4>
                                    <cf_get_lang no ='138.Yetkinlik Gelişim Eğitimi'>
                                </cfif>
                            </td>
                       </tr>
                       <tr>
                            <td class="txtbold"><cf_get_lang no='29.Eğitim Şekli'></td>
                            <td>:</td>
                            <td>
                                <cfif len(get_training_subject.training_style)>
                                    <cfquery name="get_train_style" datasource="#dsn#">
                                        SELECT 
                                            TRAINING_STYLE_ID,
                                            TRAINING_STYLE
                                        FROM 
                                            SETUP_TRAINING_STYLE
                                        WHERE
                                            TRAINING_STYLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_training_subject.training_style#">
                                    </cfquery>
                                    <cfoutput>#get_train_style.training_style#</cfoutput>
                                </cfif>
                            </td>
                       </tr>
                       <tr>
                            <td class="txtbold"><cf_get_lang_main no ='217.Açıklama'></td>
                            <td>:</td>
                            <td>
                                <cfif len(get_training_subject.train_detail)>
                                  <cfoutput>#get_training_subject.train_detail#</cfoutput> 
                                </cfif>
                            </td>
                       </tr>
                       <tr>
                            <td class="txtbold"><cf_get_lang no='96.Kayıt Bilgisi'></td>
                            <td>:</td>
                            <td>
                                <cfif len(get_training_subject.record_emp)>
                                    #get_emp_info(get_training_subject.record_emp,0,0)#
                          </cfif>
                                <cfif len(get_training_subject.record_par)>
                                    <cfset attributes.partner_id = get_training_subject.record_par>
                                    <cfinclude template="../query/get_partner.cfm">
                                    #get_partner.company_partner_name# #get_partner.company_partner_surname#
                              </cfif>- #dateformat(get_training_subject.record_date,dateformat_style)#
                         </td>
                        </tr>
                    </table>
                </cf_box>
            </cfoutput>
            </td>
            <td class="dpmr">
			<!---Eğitim Konusu Notları--->
                <cf_box 
                    id="subjects_" 
                    title="#getLang('training',82)#" 
                    closable="0" 
                    unload_body="1" 
                    box_page="#request.self#?fuseaction=training.training_subjects_note&training_id=#attributes.training_id#">
                </cf_box>
			<!---İlişkili Eğitim Konuları--->
             <cf_box 
                id="relt_train" 
                title="İlişkili Eğitim Konuları" 
                closable="0" 
                unload_body="1" 
                box_page="#request.self#?fuseaction=training.related_train&training_id=#attributes.training_id#">
            </cf_box>
            <!--- Varlıklar --->
            <cf_get_workcube_asset asset_cat_id="-6" module_id='9' action_section='TRAINING_SEC_ID' action_id='#url.train_id#' is_add="0">
            <!--- Testler --->
            <cf_box 
                id="quiz_names" 
                title="#getLang('training',25)#" 
                closable="0" 
                unload_body="1" 
                box_page="#request.self#?fuseaction=training.training_quiz_names&training_id=#attributes.training_id#">
            </cf_box>
            <!--- Sorular --->
            <cf_box 
                id="train_quest" 
                title="#getLang('training',26)#" 
                closable="0" 
                unload_body="1" 
                box_page="#request.self#?fuseaction=training.training_questions&training_id=#attributes.training_id#">
            </cf_box>
            <!--- Katılım İsteği --->
            <cf_box 
                id="lesson_" 
                title="#getLang('main',2115)#" 
                closable="0" 
                unload_body="1" 
                box_page="#request.self#?fuseaction=training.lesson&training_id=#attributes.training_id#">
            </cf_box>
       </td>
    </tr>
</table>
<script type="text/javascript">
function ajax_yukle()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=training.set_in_subject&train_id=#attributes.training_id#</cfoutput>','set_in_subject_div');
}
</script>
