<cf_xml_page_edit fuseact="call.popup_add_helpdesk">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.help_page" default="">
<cfparam name="attributes.workcube_id" default="">
<cfparam name="attributes.event_plan_row_id" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.app_name" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.tel_code" default="">
<cfparam name="attributes.tel" default="">

<cfif isdefined('attributes.mail_id')>
	<cfquery name="GET_MAIL_INFO" datasource="#DSN#">
		SELECT SUBJECT,CONTENT_FILE,MAIL_FROM FROM MAILS WHERE MAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_id#">	  
	</cfquery>
	<cfquery name="FROM_MAIL_GETPARTNER" datasource="#DSN#">
		SELECT 
     		COMPANY_ID,PARTNER_ID,
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_EMAIL,
			COMPANY_PARTNER_SURNAME
		FROM
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_mail_info.mail_from#">
	</cfquery>
	<cfif isdefined('from_mail_getpartner') and len(from_mail_getpartner.recordcount)>
		<cfset attributes.partner_id = from_mail_getpartner.partner_id>
		<cfset upd_pro.company_id = from_mail_getpartner.company_id>
	</cfif>
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfquery name="GET_PARTNER_INF" datasource="#DSN#">
		SELECT 
			CP.PARTNER_ID
		FROM 
			COMPANY_PARTNER CP, 
			COMPANY C
		WHERE 
			C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			C.COMPANY_ID = CP.COMPANY_ID
	</cfquery>
	<cfif get_partner_inf.recordcount>
		<cfset attributes.partner_id = get_partner_inf.partner_id>
	</cfif>
</cfif>
<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			CP.PARTNER_ID,
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			C.COMPANY_ID,
			C.NICKNAME,
            CP.COMPANY_PARTNER_EMAIL MAIL,
            CP.COMPANY_PARTNER_TELCODE AS TELCODE,
            CP.COMPANY_PARTNER_TEL AS TEL
		FROM 
			COMPANY_PARTNER CP, 
			COMPANY C
		WHERE 
			CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"> AND 
			CP.COMPANY_ID = C.COMPANY_ID
	</cfquery> 
<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="GET_CONSUMER" datasource="#DSN#">
		SELECT 
        	CONSUMER_ID,
            CONSUMER_NAME,
            CONSUMER_SURNAME,
            CONSUMER_EMAIL MAIL,
            CONSUMER_HOMETELCODE AS TELCODE,
            CONSUMER_HOMETEL AS TEL
       	FROM 
       		CONSUMER 
        WHERE 
        	CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_helpdesk" method="post" action="#request.self#?fuseaction=call.emptypopup_add_helpdesk">
            <input type="hidden" name="clicked" id="clicked" value="">
            <input type="hidden" name="company" id="company" value="<cfoutput>#attributes.company#</cfoutput>">
            <input type="hidden" name="help_page" id="help_page" value="<cfoutput>#attributes.help_page#</cfoutput>">
            <input type="hidden" name="workcube_id" id="workcube_id" value="<cfoutput>#attributes.workcube_id#</cfoutput>">
            <input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfoutput>#attributes.event_plan_row_id#</cfoutput>">
            <!--- teknotel ozel odeme performansi raporundan etkilesim kaydi girilebilmesi icin konuldu 20130610 --->
            <cfif isdefined("is_rapor") and is_rapor eq 1>
                <input type="hidden" name="is_rapor" id="is_rapor" value="1">
            </cfif>
            <cfif isdefined("is_reply_email") and is_reply_email eq 1>
                <input type="hidden" name="is_reply_email" id="is_reply_email" value="1">
            </cfif>
            <cf_box_elements vertical="1">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <cfif  x_process_cat eq 1>
                        <div class="form-group" id="item-heldesk_process_cat">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'> *</label>
                            <div class="col col-8 col-sm-12">
                                <cf_workcube_process_cat slct_width="150">
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-interaction_date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49292.Başvuru Tarihi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="interaction_date" id="interaction_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" >
                                <span class="input-group-addon"><cf_wrk_date_image date_field="interaction_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-subscription">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58832.Abone'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="subscription_id" id="subscription_id" value="">
                                <input type="text" name="subscription_no" id="subscription_no" value="" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=add_helpdesk.subscription_id&field_no=add_helpdesk.subscription_no'</cfoutput>);"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-commethod">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58090.İletişim Yöntemi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <select name="app_cat" id="app_cat" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_commethod">
                                    <option value="#commethod_id#" <cfif is_default eq 1>selected</cfif>>#commethod#</option>
                                </cfoutput>
                                <option value="edit_communication" style="color:red;"><cf_get_lang dictionary_id='58718.Düzenle'></option>                                    			  
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='220' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-interaction_cat">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="interaction_cat" id="interaction_cat" >
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_interaction_cat">
                                    <option value="#interactioncat_id#">#interactioncat#</option>
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
                                    <option value="#special_definition_id#">#special_definition#</option>
                                </cfoutput>			  
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-product">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57657.Urun'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)> value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                                <input type="text" name="product_name" id="product_name"  value="<cfoutput>#attributes.product_name#</cfoutput>">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_helpdesk.product_id&field_name=add_helpdesk.product_name');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-campaign">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="camp_id" id="camp_id" value="">
                                    <input type="text" name="camp_name" id="camp_name" value="" >
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_helpdesk.camp_id&field_name=add_helpdesk.camp_name');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-company_name">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57457.Müşteri'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="text" name="company_name" id="company_name" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfoutput>#get_partner.nickname#</cfoutput></cfif>"  onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','MEMBER_PARTNER_NAME2,MEMBER_PARTNER_NAME2,CONSUMER_ID,PARTNER_ID,COMPANY_ID,MEMBER_TYPE,EMAIL,MEMBER_TEL_CODE,MEMBER_TEL_NUMBER','applicant_name,member_name,consumer_id,partner_id,company_id,member_type,applicant_mail,tel_code,tel_no','','3','220');">
                                <cfset str_linke_ait="field_partner=add_helpdesk.partner_id&field_consumer=add_helpdesk.consumer_id&field_comp_id=add_helpdesk.company_id&field_comp_name=add_helpdesk.company_name&field_name=add_helpdesk.member_name&field_type=add_helpdesk.member_type&field_mail=add_helpdesk.applicant_mail&call_function=changevalue()">
                                <cfset str_linke_ait = "#str_linke_ait#&field_tel_code=add_helpdesk.tel_code&field_tel_number=add_helpdesk.tel_no">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-member_name">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                            <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfoutput>#get_partner.company_id#</cfoutput></cfif>">
                            <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.partner_id")>partner<cfelseif isdefined("attributes.consumer_id")>consumer</cfif>">			  
                            <input type="text" name="member_name" id="member_name" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput><cfelseif isdefined("attributes.consumer_id")><cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput></cfif>" readonly style="width:220px;">			
                        </div>
                    </div>
                    <div class="form-group" id="item-applicant_name">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='29514.Başvuru Yapan'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="applicant_name" id="applicant_name" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)><cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput><cfelseif isdefined('attributes.consumer_id')><cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput><cfelse><cfoutput>#attributes.app_name#</cfoutput></cfif>" maxlength="100" >			
                        </div>
                    </div>
                    <div class="form-group" id="item-aplicant_mail">
                        <label class="col col-4 col-xs12"><cf_get_lang dictionary_id='49258.Başvuru E-Mail'></label>
                        <div class="col col-8 col-xs-12">
                            <cfset mail_ = ''>
                            <cfif isdefined("attributes.partner_id")>
                                <cfif isdefined("get_partner.mail") and len("get_partner.mail")>
                                    <cfset mail_ = "#get_partner.mail#">
                                </cfif>
                            <cfelse>
                                <cfif isdefined("get_consumer.mail") and len("get_consumer.mail")>
                                    <cfset mail_ = "#get_consumer.mail#">					
                                </cfif>
                            </cfif>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49258.Başvuru E-Mail'></cfsavecontent>
                            <cfinput type="text" name="applicant_mail" id="applicant_mail" value="#mail_#"  message="#message#" data-msg="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-tel_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49207.Kod/Telefon'></label>
                        <cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>
                            <cfset attributes.tel_code = get_partner.telcode>
                            <cfset attributes.tel = get_partner.tel>
                        <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                            <cfset attributes.tel_code = get_consumer.telcode>
                            <cfset attributes.tel = get_consumer.tel>
                        </cfif>
                        <div class="col col-2 col-xs-6">
                            <cfinput type="text" name="tel_code" id="tel_code" value="#attributes.tel_code#" validate="integer" message="Telefon Kodu Hatalı!" maxlength="4" onKeyUp="isNumber(this);" >
                        </div>
                            <div class="col col-6 col-xs-6">
                            <cfinput type="text" name="tel_no" id="tel_no" value="#attributes.tel#" validate="integer" message="Telefon No Hatalı!" maxlength="10" onKeyUp="isNumber(this);" >
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12" type="column" index="3" sort="true">
                    <div class="col col-6 col-xs-12">
                        <div class="form-group" id="item-detail">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'> *</label>
                            <div class="col col-12 col-xs-12">
                                <cfif isdefined("attributes.mail_id")>
                                    <input type="text" name="detail" id="detail" value="<cfoutput>#get_mail_info.subject#</cfoutput>" >
                                <cfelse>
                                    <input type="text" name="detail" id="detail" value="" >
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="col col-6 col-xs-12">
                        <div class="form-group" id="item-template">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='58640.Şablon'></label>
                            <div class="col col-12 col-xs-12">
                                <cfquery name="GET_MODULE_TEMP" datasource="#DSN#">
                                    SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 75
                                </cfquery>
                                <select name="template_id" id="template_id"  onchange="_load(this.value)">
                                    <option value="" selected><cf_get_lang dictionary_id ='58640.Şablon'>
                                    <cfoutput query="get_module_temp">
                                        <option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#template_head# 
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-subject">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                        <div class="col col-12 col-xs-12" >
                            <div id="fckedit">
                                <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarSet="Basic"
                                basePath="/fckeditor/"
                                valign="top"
                                instanceName="subject"
                                width="565"
                                height="180">
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-12">
                    <cfif is_email_send_active eq 1>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='49310.Kayıt ve Mail Gönder'></cfsavecontent>
                        <cf_workcube_buttons is_upd='0' add_function='kontrol(1)' insert_info='#message#' is_cancel='0'>
                    </cfif>
                    <cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol(2)'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
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
	function changevalue()
	{
		document.getElementById('applicant_name').value = document.getElementById('member_name').value;
	}
	function kontrol(type)
	{	

		if(document.getElementById('interaction_date').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49292.Başvuru Tarihi'> !");
			return false;
		}
        if(document.getElementById('company_name').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57457.Müşteri'> !");
			return false;
		}
		if(document.getElementById('detail').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'> !");
			return false;
		}
		
		if(CKEDITOR.instances.subject.getData() == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu'> !");
			return false;
		}
		if(document.getElementById('app_cat').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58090.İletişim Yöntemi'> !");
			return false;
		}
		if((document.getElementById('partner_id').value == "") && (document.getElementById('consumer_id').value == ""))
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58607.Firma'> !");
			return false;
		}
	
		
		if(document.getElementById('applicant_name').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29514.Başvuru Yapan'> !");
			return false;
		}

		if(type==1)
			document.getElementById('clicked').value='&email=true';		
	
		if(type==2)
			document.getElementById('clicked').value='&email=false';
		
		document.add_helpdesk.action = "<cfoutput>#request.self#?fuseaction=call.emptypopup_add_helpdesk</cfoutput>" + document.getElementById('clicked').value;

		if(type==1)
		{
			if(process_cat_control() == true)
			{
				document.add_helpdesk.mail_send.disabled = true;
				document.add_helpdesk.wrk_submit_button.disabled = true;
				document.add_helpdesk.submit();
			}
		}
		else
			return process_cat_control();

        if(!chk_process_cat('add_helpdesk')) return false;
			
	}
	function _load(template_id)
	{
		if(template_id != undefined)
		{
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=call.popup_get_template&width=557&template_id='+template_id+'','fckedit',1);
		}
	}
</script>
