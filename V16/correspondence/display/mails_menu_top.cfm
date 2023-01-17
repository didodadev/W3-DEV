<cfsetting showdebugoutput="no">
<cfparam name="attributes.mail_id" default="">
<cfparam name="attributes.maxrows" default="">
<cfset next_mail = 0>
<cfset prew_mail = 0>
<cfif isdefined("attributes.mail_id") and len(attributes.mail_id) and isdefined("attributes.folder_id")>
    <cfquery  name="GET_NEXT" datasource="#DSN#">
        SELECT 
            TOP 1 M.MAIL_ID,M.FOLDER_ID
        FROM 
            MAILS M,
            CUBE_MAIL C
        WHERE 
            M.MAIL_ID > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_id#"> 
            AND M.FOLDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.folder_id#">
            AND C.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            AND C.ISACTIVE = 1
        ORDER BY MAIL_ID ASC 
    </cfquery>
    <cfquery  name="GET_PREW" datasource="#DSN#">
            SELECT 
            TOP 10 M.MAIL_ID,M.FOLDER_ID
        FROM 
            MAILS M,
            CUBE_MAIL C
        WHERE 
            M.MAIL_ID < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_id#"> 
            AND M.FOLDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.folder_id#">
            AND C.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            AND C.ISACTIVE = 1
        ORDER BY MAIL_ID DESC
    </cfquery>
    <cfif get_next.recordcount>
		<cfset next_mail = get_next.mail_id>
    <cfelse>
    	<cfset next_mail = 0>
    </cfif>
    <cfif get_prew.recordcount>
		<cfset prew_mail = get_prew.mail_id>
    <cfelse>
    	<cfset prew_mail = 0>
    </cfif>
<cfelse>
    <cfset get_next.recordcount = 0>
    <cfset get_prew.recordcount = 0>
</cfif>

<table style="text-align:right;">
	<tr>
    	<td width="100%"></td>
		<td nowrap style="text-align:right;">
		 	<table cellpadding="0" cellspacing="0">
                <tr>
                    <td></td>
                    <td nowrap>
						<cfoutput>
                        <cfif isdefined("attributes.mail_id") and len(attributes.mail_id) and not isdefined("attributes.relation_type")>
                            <a href="javascript://" onclick="get_associate();"><img src="/images/mail/attach.jpg"  alt="İlişkilendir" border="0" title="İlişkilendir"></a> 
                        </cfif>
                        <cfif isdefined("attributes.mail_id") and len(attributes.mail_id) and isdefined("attributes.folder_id")>
                            <a href="javascript://" onclick="delete_mail(#attributes.folder_id#,#attributes.mail_id#,1,#next_mail#);"><img src="/images/mail/deletebox.jpg" border="0" title="Sil"/></a>
                        </cfif>
                        <cfif isdefined("attributes.mail_id") and len(attributes.mail_id) and GET_PREW.recordcount>
                            <a href="javascript://" onclick="get_mail(#GET_PREW.MAIL_ID#,#GET_PREW.FOLDER_ID#)"><img src="../images/mail/prew1.jpg" border="0" title="Daha Eski"/></a>
                        </cfif>
                        <cfif isdefined("attributes.mail_id") and len(attributes.mail_id) and GET_NEXT.recordcount>
                            <a href="javascript://" onclick="get_mail(#GET_NEXT.MAIL_ID#,#GET_NEXT.FOLDER_ID#);"><img src="../images/mail/next1.jpg" border="0" title="Daha Yeni"/></a>
                        </cfif>
                        
                        <cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>
                            <cfif not isdefined("attributes.relation_type")>
                                <a href="#request.self#?fuseaction=project.works&event=add&mail_id=#attributes.mail_id#"><img src="/images/mail/add_work.jpg" alt="<cf_get_lang_main no ='521.İş Ekle'>" border="0" title="<cf_get_lang_main no ='521.İş Ekle'>"></a>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=call.popup_add_helpdesk&mail_id=#attributes.mail_id#','wide')"><img src="/images/mail/add_note.jpg" border="0" alt="<cf_get_lang no= '179.Etkileşim Ekle'>" title="<cf_get_lang no= '179.Etkileşim Ekle'>"></a>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=call.popup_add_service&mail_id=#attributes.mail_id#','wide')"><img src="/images/mail/add_service.jpg" border="0" alt="<cf_get_lang no='180.Başvuru Ekle'>" title="<cf_get_lang no='180.Başvuru Ekle'>"></a>
                            </cfif>
                                <a href="javascript://" onclick="create_mail('#attributes.mail_id#','reply','1');"><img src="/images/mail/reply.jpg" alt="<cf_get_lang no='50.yanıtla'>" border="0" title="<cf_get_lang no='50.yanıtla'>"></a>
                                <a href="javascript://" onclick="create_mail('#attributes.mail_id#','all_replies','1','1');"><img src="/images/mail/reply_all.jpg" alt="<cf_get_lang no='51.hepsini yanıtla'>" border="0" title="<cf_get_lang no='51.hepsini yanıtla'>"></a> 
                                <a href="javascript://" onclick="create_mail('#attributes.mail_id#','forward','1');"><img src="/images/mail/forward1.jpg" alt="<cf_get_lang no='52.ilet'>" border="0" title="<cf_get_lang no='52.ilet'>"></a>
                        </cfif>
                        <cfif isdefined("attributes.is_new_mail") and not isdefined("attributes.relation_type")>
                            <a href="javascript://" onclick="get_templates();"><img src="/images/mail/template.gif" alt="Template Ekle" border="0" title="Template Ekle"></a>
                            <a href="javascript://" onclick="get_signature();"><img src="/images/mail/signature.jpg" alt="İmza Ekle" border="0" title="İmza Ekle"></a>
                        </cfif>
                        </cfoutput>
                        <a href="javascript://" onclick="create_mail();" class="tableyazi"><img src="/images/mail/compose.jpg" alt="Mail Gönder" border="0" title="Mail Gönder"/></a>
                        <cfif not isdefined("attributes.relation_type")>
                            <a href="javascript://" onclick="check_mail();" class="tableyazi";><img src="/images/mail/sent_receive.jpg" alt="<cf_get_lang no='7.Mail Al'>" border="0" title="<cf_get_lang no='7.Mail Al'>" /></a>
                            <a href="javascript://" onclick="get_search_div();" class="tableyazi";><img src="/images/mail/search.jpg" alt="Mail Ara" border="0" title="Mail Ara" /></a>
                            <a href="javascript://" onclick="get_mail_adress();" class="tableyazi"><img src="/images/mail/adressbook.jpg" title="Mail Adres" alt="Mail Adres" border="0" /></a>
                            <a href="<cfoutput>#request.self#?fuseaction=correspondence.list_mymails</cfoutput>" class="tableyazi"><img src="/images/mail/setings.jpg" alt="Ayarlama" title="Ayarlarım" border="0" /></a>
                        </cfif>
                        <cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>
                            <a href="javascript://" onclick="geri_don();"><img src="/images/mail/back.gif" border="0" alt="Geri Dön" title="Geri Dön"></a>
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.mail_id#&print_type=500</cfoutput>','print_page');"><img src="/images/mail/pencil.jpg" title="<cf_get_lang_main no='62.Yazdır'>" border="0" style="vertical-align:top;"></a>
                        </cfif>
                	</td>
                </tr>
		 	</table>
	  	</td> 
    </tr>
	<tr height="1">
		<td></td>
		<td>
			<cf_box title="İlişkiler" id="associate_div" style="height:300px%;width:240px;display:none;position:absolute; margin-left:60px;;" body_style="height:97%;" closable="1" collapsable="1">
				<cfform name="associate" method="post" action="#request.self#?fuseaction=correspondence.emptypopup_add_associate_items&mail_id=#attributes.mail_id#">
                    <table>
                        <tr>
                            <td><cf_get_lang_main no="4.Proje"></td>
                            <td>
                                <input type="hidden" name="project_id" id="project_id" value="">
                                <input type="text" name="project_head"  id="project_head" style="width:130px;" value="">
                                <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=associate.project_id&project_head=associate.project_head');"><img src="/images/plus_thin.gif" border="0" alt="Proje"  align="absmiddle"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no="173.Kurumsal Üye"></td>
                            <td>
                                <input type="hidden" name="consumer_id" id="consumer_id" value="">			
                                <input type="hidden" name="company_id" id="company_id" value="">
                                <input type="text" name="member_name" id="member_name" style="width:130px;" value="">
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=associate.member_name&field_comp_id=associate.company_id&field_consumer=associate.consumer_id&field_member_name=associate.member_name','list');"><img src="/images/plus_thin.gif" alt="Kurumsal Üye" border="0" align="absmiddle"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no="174.Bireysel Üye"></td>
                            <td>
                                <input type="hidden" name="consumer_id2" id="consumer_id2" value="">			
                                <input type="text" name="member_name2" id="member_name2" style="width:130px;" value="">
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_cons&select_list=3&field_consumer=associate.consumer_id2&field_name=associate.member_name2','list');"><img src="/images/plus_thin.gif" alt="Bireysel Üye" border="0" align="absmiddle"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no="133.Teklif"></td>
                            <td>
                                <input type="hidden" name="offer_id" id="offer_id" value="">
                                <input type="text" name="offer_name" id="offer_name" value=""  style="width:130px;">
                                <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_offers&order_id=associate.offer_id&order_name=associate.offer_name','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td style="text-align:right;"><input type="button" name="Kaydet" value="Kaydet" onclick="control_associate();"> </td>
                        </tr>
                    </table>
                </cfform>
			</cf_box>
			<cfquery name="GET_CAT" datasource="#DSN#">
				SELECT CORRCAT_ID,DETAIL,CORRCAT FROM SETUP_CORR ORDER BY CORRCAT
			</cfquery>
			<cf_box title="E-posta Şablonları" id="template_div" style="display:none;position:absolute;" body_style="height:97%;" closable="1" collapsable="0">
				<cfif GET_CAT.recordcount>
					<cfoutput query="GET_CAT">
						<a href="javascript://" onclick="add_template(#corrcat_id#);">#corrcat#</a><br/>
					</cfoutput>
				<cfelse>
				<cf_get_lang dictionary_id="54834.Şablon Bulunamadı">!
				</cfif>
			</cf_box>
			<cfquery name="GET_SIGN" datasource="#DSN#">
				SELECT * FROM CUBE_MAIL_SIGNATURE WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			</cfquery>
			<cf_box title="E-posta İmzaları" id="signature_div" style="display:none;position:absolute;" body_style="height:97%;" closable="1" collapsable="0">
				<cfif get_sign.recordcount>
					<cfoutput query="get_sign">
						<a href="javascript://" onclick="add_signature(#signature_id#);">#signature_name#</a><br/> 
					</cfoutput>
				<cfelse>
					<cf_get_lang dictionary_id="54836.Tanımlı İmza Bulunamadı Standart İmza Kullan">!<br/>
				</cfif>
			</cf_box>
		</td>
	</tr>
</table>

<script type="text/javascript">
	function control_associate()
	{
		<cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>
			AjaxFormSubmit("associate","associate_div",0,"Kaydediliyor","Kaydedildi!","<cfoutput>#request.self#?fuseaction=correspondence.popup_get_cubemail&mail_id=#attributes.mail_id#</cfoutput>","action_div");
		</cfif>
		gizle(associate_div);
		get_top_menu('<cfoutput>#attributes.mail_id#</cfoutput>');
	}
</script> 
