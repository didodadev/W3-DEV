<cf_xml_page_edit fuseact="call.popup_add_helpdesk">
<cfquery name="GET_HELP" datasource="#DSN#">
	SELECT
		CH.DETAIL,
		CH.CUS_HELP_ID,
		CH.COMPANY_ID,
		CH.PARTNER_ID,
		CH.CONSUMER_ID,
		CH.SUBJECT,
		CH.APP_CAT,
		CH.PROCESS_STAGE,
		CH.SOLUTION_DETAIL,
		CH.APPLICANT_NAME,
		CH.APPLICANT_MAIL,
		CH.MAIL_RECORD_DATE,
		CH.MAIL_RECORD_EMP,
		CH.RECORD_EMP,
		CH.RECORD_PAR,
		CH.RECORD_CONS,
		CH.RECORD_APP,
		CH.GUEST,
		CH.RECORD_DATE,
		CH.UPDATE_DATE,
		CH.UPDATE_EMP,
		CH.IS_REPLY,
        CH.EVENT_PLAN_ROW_ID,
		CH.IS_REPLY_MAIL,
		CH.SUBSCRIPTION_ID,
        CH.INTERACTION_CAT,
        CH.INTERACTION_DATE,
        CH.CUSTOMER_TELCODE,
        CH.CUSTOMER_TELNO,
		CH.CAMP_ID,
		CH.PRODUCT_ID,
		SPECIAL_DEFINITION_ID,
        PROCESS_CAT
    FROM
		CUSTOMER_HELP CH,
		SETUP_COMMETHOD SC
	WHERE
		CH.APP_CAT = SC.COMMETHOD_ID AND
		CH.CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
</cfquery>
<cfif get_help.recordcount>
	<cfquery name="GET_MODULE_TEMP" datasource="#DSN#">
		SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 75
	</cfquery>
	<cfif isdefined("attributes.answer_id")>
		<cfquery name="GET_ANSWER" datasource="#DSN#">
			SELECT SOLUTION_DETAIL, SUBJECT, CUS_HELP_ID FROM CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.answer_id#">
		</cfquery>
	</cfif>
	<cfquery name="GET_COMMETHOD" datasource="#DSN#">
        SELECT
            CASE
                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                ELSE COMMETHOD
            END AS COMMETHOD,
            COMMETHOD_ID,
            IS_DEFAULT
        FROM
            SETUP_COMMETHOD
            LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COMMETHOD.COMMETHOD_ID
            AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMMETHOD">
            AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COMMETHOD">
            AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
        ORDER BY COMMETHOD
	</cfquery>
	<cfquery name="GET_INTERACTION_CAT" datasource="#DSN#">
        SELECT
            CASE
                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                ELSE INTERACTIONCAT
            END AS INTERACTIONCAT,
            INTERACTIONCAT_ID
        FROM
            SETUP_INTERACTION_CAT
            LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_INTERACTION_CAT.INTERACTIONCAT_ID
            AND SLI.COLUMN_NAME =  <cfqueryparam cfsqltype="cf_sql_varchar" value="INTERACTIONCAT">
            AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_INTERACTION_CAT">
            AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
        ORDER BY INTERACTIONCAT
	</cfquery>
	<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#"><!--- 5: Etkilesim Kategorisindeki Ozel Tanimlar --->
		SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 5 ORDER BY SPECIAL_DEFINITION
	</cfquery>
    <cf_catalystHeader>
        
<cfform name="upd_helpdesk" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=call.emptypopup_upd_helpdesk">
    <input type="hidden" name="clicked" id="clicked" value="">
    <input type="hidden" name="help_mail" id="help_mail" value="<cfoutput>#get_help.applicant_mail#</cfoutput>">
    <input type="hidden" name="cus_help_id" id="cus_help_id" value="<cfoutput>#attributes.cus_help_id#</cfoutput>">
    <input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfif len(get_help.event_plan_row_id)><cfoutput>#get_help.event_plan_row_id#</cfoutput></cfif>">
    <cfif is_reply_email eq 1>
        <input type="hidden" name="is_reply_email" id="is_reply_email" value="1"  />
    </cfif>
    <div class="row">
        <div class="col col-9 col-xs-12 uniqueRow">
            <cf_box title="#getLang('','Etkileşim',49270)# #getLang('','Detay',57771)#" closable="0">
                <cf_box_elements vertical="1">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <cfif  isdefined('x_process_cat') and x_process_cat eq 1>
                            <div class="form-group" id="item-heldesk_process_cat">
                                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
                                <div class="col col-8 col-sm-12">
                                    <cf_workcube_process_cat process_cat="#get_help.process_cat#">
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-interaction_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49292.Başvuru Tarihi'> *</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='49292.Başvuru Tarihi'> !</cfsavecontent>
                                    <cfinput type="text" name="interaction_date" id="interaction_date" value="#dateformat(get_help.interaction_date,dateformat_style)#" validate="#validate_style#" message="#message1#" >
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="interaction_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-subscription">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58832.Abone'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_help.subscription_id)>
                                        <cfquery name="GET_SUBS" datasource="#DSN3#">
                                            SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_help.subscription_id#">
                                        </cfquery>
                                        <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#get_subs.subscription_id#</cfoutput>">
                                        <input type="text" name="subscription_no" id="subscription_no" value="<cfoutput>#get_subs.subscription_no#</cfoutput>"   onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
                                    <cfelse>
                                        <input type="hidden" name="subscription_id" id="subscription_id" value="">
                                        <input type="text" name="subscription_no" id="subscription_no" value=""   onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
                                    </cfif>
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=upd_helpdesk.subscription_id&field_no=upd_helpdesk.subscription_no</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-commethod">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58090.İletişim Yöntemi'>*</label>
                            <div class="col col-8 col-xs-12">
                                <select name="app_cat" id="app_cat" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_commethod">
                                        <option value="#commethod_id#" <cfif get_help.app_cat eq commethod_id>selected</cfif>>#commethod#</option>
                                    </cfoutput>		
                                    <option value="edit_communication" style="color:red;"><cf_get_lang dictionary_id='58718.Düzenle'></option>                                    			  	  
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
                            <div class="col col-8 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value='#get_help.process_stage#' process_cat_width='220' is_detail='1'>
                            </div>
                        </div>
                        <div class="form-group" id="item-interaction_cat">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="interaction_cat" id="interaction_cat" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_interaction_cat">
                                        <option value="#interactioncat_id#"<cfif interactioncat_id eq get_help.interaction_cat>selected</cfif>>#interactioncat#</option>
                                    </cfoutput>		
                                    <option value="edit_cat"  style="color:red;"><cf_get_lang dictionary_id='58718.Düzenle'></option>	  
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-special_definition">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='38511.Özel Tanım'></label>
                            <div class="col col-8 col-xs-12">
                                <select name="special_definition" id="special_definition" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_special_definition">
                                        <option value="#special_definition_id#" <cfif get_help.special_definition_id eq special_definition_id>selected</cfif>>#special_definition#</option>
                                    </cfoutput>			  
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-product">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57657.Urun'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_help.product_id)>
                                        <cfquery name="GET_PRODUCT_NAME" datasource="#DSN1#">
                                            SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_help.product_id#">
                                        </cfquery>
                                    </cfif>
                                    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#get_help.product_id#</cfoutput>">
                                    <input type="text" name="product_name" id="product_name" value="<cfif len(get_help.product_id)><cfoutput>#get_product_name.product_name#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_helpdesk.product_id&field_name=upd_helpdesk.product_name');"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-campaign">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_help.camp_id)>
                                        <cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
                                            SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_help.camp_id#">
                                        </cfquery>
                                    <cfelse>
                                        <cfset get_camp_info.camp_head = ''>
                                    </cfif>
                                    <cfoutput>
                                        <input type="hidden" name="camp_id" id="camp_id" value="#get_help.camp_id#">
                                        <input type="text" name="camp_name" id="camp_name" value="#get_camp_info.camp_head#" >
                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=upd_helpdesk.camp_id&field_name=upd_helpdesk.camp_name');"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-company_name">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57457.Müşteri'>*</label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="company_name" id="company_name" value="<cfif len(get_help.partner_id)><cfoutput>#get_par_info(get_help.partner_id,0,1,0)#</cfoutput></cfif>"  onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','MEMBER_PARTNER_NAME2,MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID,COMPANY_ID,MEMBER_TYPE,EMAIL,MEMBER_TEL_CODE,MEMBER_TEL_NUMBER','applicant_name,member_name,consumer_id,partner_id,company_id,member_type,applicant_mail,tel_code,tel_no','','3','250');">
                                    <cfset str_linke_ait="field_partner=upd_helpdesk.partner_id&field_consumer=upd_helpdesk.consumer_id&field_comp_id=upd_helpdesk.company_id&field_comp_name=upd_helpdesk.company_name&field_name=upd_helpdesk.member_name&field_type=upd_helpdesk.member_type&field_mail=upd_helpdesk.applicant_mail&call_function=changevalue()">
                                    <cfset str_linke_ait = "#str_linke_ait#&field_tel_code=upd_helpdesk.tel_code&field_tel_number=upd_helpdesk.tel_no&type=1">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57578.Yetkili'>*</label>
                            <div class="col col-8 col-xs-12">
                                <cfif len(get_help.partner_id)>
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_help.partner_id#</cfoutput>">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_help.company_id#</cfoutput>">
                                    <input type="hidden" name="member_type" id="member_type" value="partner">	 		  
                                    <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_par_info(get_help.partner_id,0,-1,0)#</cfoutput>" readonly >
                                <cfelse>
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_help.consumer_id#</cfoutput>">
                                    <input type="hidden" name="partner_id" id="partner_id" value="">
                                    <input type="hidden" name="company_id" id="company_id" value="">
                                    <input type="hidden" name="member_type" id="member_type" value="consumer"> 			  
                                    <input type="text" name="member_name" id="member_name" value="<cfoutput>#get_cons_info(get_help.consumer_id,0,0)#</cfoutput>" readonly >
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group" id="item-applicant_name">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='29514.Başvuru Yapan'>*</label>
                            <div class="col col-8 col-xs-12">
                                <input type="text" name="applicant_name" id="applicant_name" value="<cfoutput>#get_help.applicant_name#</cfoutput>" maxlength="100" >			
                            </div>
                        </div>
                        <div class="form-group" id="item-aplicant_mail">
                            <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='49258.Başvuru E-Mail'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57477.Hatalı Veri"> : <cf_get_lang dictionary_id ='57428.E-Posta'></cfsavecontent>
                                <cfinput type="text" name="applicant_mail" id="applicant_mail" validate="email" value="#get_help.applicant_mail#" message="#message#" data-msg="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-tel_no">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'></label>
                            <div class="col col-2 col-xs-12">
                                <cfinput type="text" name="tel_code" id="tel_code" value="#get_help.customer_telcode#" validate="integer" message="Telefon Kodu Hatalı!" maxlength="4" onKeyUp="isNumber(this);" >
                            </div>
                            <div class="col col-6 col-xs-12">
                                <cfinput type="text" name="tel_no" id="tel_no" value="#get_help.customer_telno#" validate="integer" message="Telefon No Hatalı!" maxlength="10" onKeyUp="isNumber(this);" >
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-detail">
                            <label class="col col-12 col-xs12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
                            <div class="col col-12 col-xs-12">
                                <cfsavecontent variable="message_detail"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                                <cfinput type="text" name="detail" id="detail" value="#get_help.detail#" required="yes" message="#message_detail#" >
                            </div>
                        </div>
                        <div class="form-group" id="item-subject">
                            <label class="col col-12 col-xs12"><span class="hide"><cf_get_lang dictionary_id="30637.Editör"></span></label>
                            <div class="col col-12 col-xs-12">
                                <cfmodule 
                                    template="/fckeditor/fckeditor.cfm" 
                                    toolbarSet="Basic" 
                                    basePath="/fckeditor/" 
                                    instanceName="subject" 
                                    value="#get_help.subject#" 
                                    width="587" 
                                    height="180">
                            </div>
                        </div>
                        <div class="form-group" id="item-template">
                            <label class="col col-8 col-xs12"><span class="hide"><cf_get_lang dictionary_id="58640.Şablon"></span></label>
                            <label class="col col-8 col-xs12"><cf_get_lang dictionary_id='49266.Kullanıcıya Cevap Yazmak için aşağıdaki formu doldurabilirsiniz.'></label>
                            <div class="col col-4 col-xs-12">
                                <select name="template_id" id="template_id"  onchange="_load(this.value);">
                                    <option value="" selected><cf_get_lang dictionary_id ='58640.Şablon'>
                                    <cfoutput query="get_module_temp">
                                        <option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#template_head# 
                                    </cfoutput>
                                </select>
                            </div>
                        </div>    
                        <div class="form-group" id="item-content">
                            <label class="col col-12 col-xs-12"><span class="hide">Şablon</span></label>
                            <div class="col col-12 col-xs-12">
                            <div id="fckedit">                          
                                <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarSet="Basic"
                                    basePath="/fckeditor/"
                                    instanceName="content"
                                    value="#get_help.solution_detail#"
                                    width="587"
                                    height="300">
                                </div>
                            </div>
                        </div>                              
                    </div>
                    <div class="col col-6 col-md-6 col-xs-12">
                        <!---
                            <div class="form-group" id="item-help_fuse">
                                <label class="col col-12"><cf_get_lang dictionary_id='42.Yardım Olarak Kaydedilsin'><input type="checkbox" name="is_help_desk" id="is_help_desk" value="1" onclick="gizle_goster(is_help_);gizle_goster(is_help2_);"></label>
                                <input type="hidden" name="help_fuse" id="help_fuse" value="<cfoutput>#attributes.fuseaction#</cfoutput>">
                            </div>
                            <div class="form-group" id="is_help_" style="display:none;" >
                                <label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='1408.Başlık'>*</label>
                                <div class="col col-5 col-xs-8">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="782.Zorunlu Alan"> : <cf_get_lang dictionary_id='1408.Başlık'></cfsavecontent>
                                    <cfinput type="text" name="help_head" value="#message#" onFocus="this.value='';"required="Yes" message="#message#" maxlength="100" >
                                </div>
                                <div class="col col-4 col-xs-4">
                                    <label><cf_get_lang dictionary_id ='667.Yayın'><input type="checkbox" name="is_internet" id="is_internet" value="1"></label>
                                    <label>SSS<input type="checkbox" name="is_faq" id="is_faq" value="1"></label>
                                </div>
                            </div>
                            <div class="form-group" id="is_help2_" style="display:none;">
                                <label class="col col-3 col-xs-12 "><cf_get_lang dictionary_id='169.Sayfa'></label>
                                <div class="col col-4 col-xs-6">
                                    <input type="hidden" name="faction_id" id="faction_id" value="">
                                    <cfinput type="text" name="modul_name" id="modul_name" value="" >
                                </div>
                                <div class="col col-5 col-xs-6">
                                    <div class="input-group">
                                        <cfinput type="text" name="faction" id="faction" value="" >
                                        <cfif not listfindnocase(denied_pages,'settings.popup_faction_list')>	
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_faction_list&field_faction_id=upd_helpdesk.faction_id&field_faction=upd_helpdesk.faction&field_modul=upd_helpdesk.modul_name</cfoutput>','medium');"></span>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                        --->
                        <div class="form-group" id="item-e_mail">
                            <div class="col col-12 col-xs-12">
                                <cfif len(get_help.mail_record_date)>
                                    <cf_get_lang dictionary_id='49257.Mail Gönderildi'> : <cfoutput>#get_emp_info(get_help.mail_record_emp,0,0)# #DateFormat(get_help.mail_record_date,dateformat_style)# #TimeFormat(dateadd('h',session.ep.time_zone,get_help.mail_record_date),timeformat_style)#</cfoutput>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-6 col-xs-12"><cf_record_info query_name="get_help" is_partner="1" is_consumer="1" record_other="#get_help.applicant_name#"></div>
                    <div class="col col-6 col-xs-12">
                        <cfif is_email_send_active eq 1>
                            <cf_workcube_buttons is_upd='0' add_function='control(1)' insert_info='#getLang('','Güncelle ve Mail Gönder',49265)#' is_cancel='0'>
                        </cfif>
                        <cf_workcube_buttons type_format='1' is_upd='1' add_function='control(2)' delete_page_url='#request.self#?fuseaction=call.emptypopup_del_helpdesk&cus_help_id=#attributes.cus_help_id#'>
                    </div>
                </cf_box_footer>
            </cf_box>
        </div>
        <div class="col col-3 col-xs-12 uniqueRow"> <!---///content sağ---><!--- Yan kısım--->
            <div class="row">
                <div class="col col-12">
                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='49313.Benzer Başvurular'></cfsavecontent>
                    <cf_box 
                        id="similar_call" 
                        title="#title#" 
                        closable="0" 
                        unload_body="1" 
                        box_page="#request.self#?fuseaction=call.similar_request&cus_help_id=#cus_help_id#">
                    </cf_box>
                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='49235.İlişkili Aksiyonlar'></cfsavecontent>
                        <cf_box 
                        id="Related_Actions" 
                        title="#title#" 
                        closable="0" 
                        unload_body="1" 
                        box_page="#request.self#?fuseaction=call.list_detail_related_actions&cus_help_id=#cus_help_id#&event_plan_row_id=#get_help.event_plan_row_id#">
                    </cf_box>
                    <cf_get_workcube_asset asset_cat_id="-2" module_id='27' action_section='CUS_HELP_ID' action_id='#attributes.cus_help_id#' style="1"><br><br>
                </div>
            </div>
        </div>
    </div>
</cfform>
<cfelse>
	<script>
		alert("<cf_get_lang dictionary_id='54631.Sistemde Böyle Bir Kayıt Bulunmamaktadır!'>");
		history.back(-1);
	</script>
</cfif>
<script type="text/javascript">
    $('#interaction_cat').change(function() {
        if($(this).val() === 'edit_cat'){
            window.open("<cfoutput>#request.self#?fuseaction=settings.form_add_interaction_cats</cfoutput>","_blank");
        
        }
    });
    $('#app_cat').change(function() {
        if($(this).val() === 'edit_communication'){
            window.open("<cfoutput>#request.self#?fuseaction=settings.form_add_com_method</cfoutput>","_blank");
        
        }
    });
	function control(type)
	{

		if(document.getElementById('interaction_date').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='49292.Başvuru Tarihi'> !");
			return false;
		}
		
		if(document.getElementById('app_cat').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58090.İletişim Yöntemi'> !");
			return false;
		}
		
		if(document.getElementById('applicant_name').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='29514.Başvuru Yapan'> !");
			return false;
		}

		if (type==1)
		{
			if(document.getElementById('applicant_mail').value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='49258.Başvuru E-Mail'> !");
				return false;
			}
			document.getElementById('clicked').value='&email=true';
		}
	
		if (type==2)
			document.getElementById('clicked').value='&email=false';
			
		
		document.all.subject.disabled = false;
		document.upd_helpdesk.action = "<cfoutput>#request.self#?fuseaction=call.emptypopup_upd_helpdesk</cfoutput>" + document.getElementById('clicked').value;
        if(!chk_process_cat('upd_helpdesk')) return false;
		return process_cat_control();
	}
	
	function kontrol()
	{
		if(trim(document.add_email_cont.content.value).length == 0)
		{
			alert("<cf_get_lang dictionary_id='49264.Cevap Girilmiş Olmalıdır!'>");
			return false;
		} 
	}
	
	function kontrol1()
	{
		if(document.upd_helpdesk.content.value == '<P>&nbsp;</P>')
		{
			alert("<cf_get_lang dictionary_id='49263.Cevap Boş Olamaz!'>");
			return false;
		} 
	}
	
	function changevalue()
	{
		document.getElementById('applicant_name').value = document.getElementById('member_name').value;
	}
	
	function changevalues()
	{
		document.getElementById('applicant_name').value = document.getElementById('about_par_name').value;
	}
		
	function _load(template_id)
	{
		if(template_id != undefined)
		{
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=call.popup_get_template&cus_help_id=#url.cus_help_id#</cfoutput>&width=587&template_id='+template_id+'','fckedit',1);
		}
	}
</script>
