<cfset getComponent = createObject('component','V16.content.cfc.get_content')>
<cfparam name="attributes.view_date_start" default="">
<cfparam name="attributes.view_date_finish" default="">
<cf_xml_page_edit> 
<cf_get_lang_set module_name="content">
<cfset session.userFilesPath = "/documents/content/">
<cfif isnumeric(attributes.cntid)>
        <cfset get_content = getComponent.get_content_list_fnc(
			record_member_id : '#iif(isdefined("record_member_id"),"record_member_id",DE(""))#' ,
			record_member : '#iif(isdefined("attributes.record_member"),"attributes.record_member",DE(""))#',
			keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#', 
			language_id : '#iif(isdefined("attributes.language_id"),"attributes.language_id",DE(""))#',
			stage_id : '#iif(isdefined("attributes.stage_id"),"attributes.stage_id",DE(""))#',
			priority : '#iif(isdefined("attributes.priority"),"attributes.priority",DE(""))#',
			status : '#iif(isdefined("attributes.status"),"attributes.status",DE(""))#',
			content_property_id : '#iif(isdefined("attributes.content_property_id"),"attributes.content_property_id",DE(""))#',
			internet_view : '#iif(isdefined("attributes.internet_view"),"attributes.internet_view",DE(""))#',
			cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
			record_date : '#iif(isdefined("attributes.record_date"),"attributes.record_date",DE(""))#',
			user_friendly_url : '#iif(isdefined("attributes.user_friendly_url"),"attributes.user_friendly_url",DE(""))#',
			ana_sayfa : '#iif(isdefined("attributes.ana_sayfa"),"attributes.ana_sayfa",DE(""))#',
			ana_sayfayan : '#iif(isdefined("attributes.ana_sayfayan"),"attributes.ana_sayfayan",DE(""))#',
			bolum_basi : '#iif(isdefined("attributes.bolum_basi"),"attributes.bolum_basi",DE(""))#',
			bolum_yan : '#iif(isdefined("attributes.bolum_yan"),"attributes.bolum_yan",DE(""))#' ,
			ch_bas : '#iif(isdefined("attributes.ch_bas"),"attributes.ch_bas",DE(""))#',
			ch_yan : '#iif(isdefined("attributes.ch_yan"),"attributes.ch_yan",DE(""))#',
			none_tree : '#iif(isdefined("attributes.none_tree"),"attributes.none_tree",DE(""))#' ,
			is_viewed : '#iif(isdefined("attributes.is_viewed"),"attributes.is_viewed",DE(""))#',
			order_type : '#iif(isdefined("attributes.order_type"),"attributes.order_type",DE(""))#',  
			spot : '#iif(isdefined("attributes.spot"),"attributes.spot",DE(""))#',
			is_rule_popup : '#iif(isdefined("attributes.is_rule_popup"),"attributes.is_rule_popup",DE(""))#',
			cntid : '#iif(isdefined("attributes.cntid"),"attributes.cntid",DE(""))#',
			is_fulltext_search : '#iif(isdefined("is_fulltext_search"),"is_fulltext_search",DE(""))#'
        )>
<cfelse>
	<cfset get_content.recordcount = 0>
</cfif>
<cfif get_content.recordcount eq 0>
	<cfset hata  = 11>
	<cfsavecontent variable="hata_mesaj"><cf_get_lang dictionary_id="54730.Şirket Yetkiniz Uygun Değil Veya Böyle Bir Kayıt Bulunamadı"> !</cfsavecontent>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfset get_company_cat = getComponent.GetCompanyCat()>
    <cfset get_customer_cat = getComponent.GetCustomerCat()>
    <cfset get_content_cat = getComponent.GetContentCat()>
    <cfset GET_LANGUAGE = getComponent.GET_LANGUAGE()>
    <cfset GET_POSITION_CATS = getComponent.GET_POSITION_CATS()>
    <cfset GET_USER_GROUPS = getComponent.GET_USER_GROUPS()>
    <cfset GET_CAT = getComponent.GET_CAT()>
  	<cfscript>
        if (isdefined("Session.cid"))
        structdelete(Session,"CID");
    </cfscript>
    <cfset session.cid  = url.cntid>
    <cfif fuseaction contains "popup">
        <cfset is_popup=1>
    <cfelse>
        <cfset is_popup=0>
    </cfif>
    <script type="text/javascript">
        function val_kontrol()
        {
            window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#</cfoutput>.view_content&cntid=<cfoutput>#url.cntid#</cfoutput>&cont_catid="+document.fHtmlEditor.cont_catid.value;
        }
        function chk_poz(gelen)
        {
            if ( (gelen == 1) && (fHtmlEditor.ana_sayfayan.checked) ) fHtmlEditor.ana_sayfayan.checked = false;
            if ( (gelen == 2) && (fHtmlEditor.ana_sayfa.checked) ) fHtmlEditor.ana_sayfa.checked = false;
            if ( (gelen == 3) && (fHtmlEditor.bolum_yan.checked) ) fHtmlEditor.bolum_yan.checked = false;
            if ( (gelen == 4) && (fHtmlEditor.bolum_basi.checked) ) fHtmlEditor.bolum_basi.checked = false;
            if ( (gelen == 5) && (fHtmlEditor.ch_bas.checked) ) fHtmlEditor.ch_yan.checked = false;	
            if ( (gelen == 6) && (fHtmlEditor.ch_yan.checked) ) fHtmlEditor.ch_bas.checked = false;
        }
    </script>
    <div style="display:none;z-index:999;" id="tab"></div>
    <cfparam name="attributes.subject" default="#decodeForHTML(get_content.cont_head)#">
<cf_catalystHeader>
<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
    <cf_box>
        <cfform name="fHtmlEditor" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_content">
            <input type="hidden" name="cntid" id="cntid" value="<cfoutput>#attributes.cntid#</cfoutput>">
            <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2" divLang="#getLang('','İçerik',57653)#;#getLang('','Yayın Bilgileri',65063)#;">
                <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
                    <cf_box_elements vertical="1">
                            <div class="col col-2 col-md-2 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group" id="item-status">
                                    <div class="col col-12 col-xs-12">
                                        <label class="col col-12 col-xs-6"><input type="checkbox" <cfif get_content.content_status is 1> checked</cfif> name="status" id="status"><cf_get_lang dictionary_id='57493.Aktif'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" value="1" <cfif get_content.spot eq 1> checked</cfif> name="spot" id="spot"><cf_get_lang dictionary_id='50578.Spot'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" <cfif get_content.is_dsp_header eq 1> checked</cfif> name="is_dsp_header" id="is_dsp_header"><cf_get_lang dictionary_id='50581.Başlık Gösterme'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" <cfif get_content.is_dsp_summary eq 1> checked</cfif> name="is_dsp_summary" id="is_dsp_summary"><cf_get_lang dictionary_id='50573.Özet Gösterme'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" <cfif get_content.is_viewed is 1>checked</cfif> name="is_viewed" id="is_viewed"><cf_get_lang dictionary_id='50541.Anasayfada Duyur'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" onclick="chk_poz(1)" <cfif get_content.cont_position contains 1> checked</cfif> name="ana_sayfa" id="ana_sayfa"><cf_get_lang dictionary_id='50532.Anasayfa'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" onclick="chk_poz(2)" <cfif get_content.cont_position contains 2> checked</cfif> name="ana_sayfayan" id="ana_sayfayan"><cf_get_lang dictionary_id='50533.Anasayfa Yan'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" onclick="chk_poz(3)" <cfif get_content.cont_position contains 3> checked</cfif> name="bolum_basi" id="bolum_basi"><cf_get_lang dictionary_id='50534.Kategori Başı'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" onclick="chk_poz(4)" <cfif get_content.cont_position contains 4> checked</cfif> name="bolum_yan" id="bolum_yan"><cf_get_lang dictionary_id='50535.Kategori Yanı'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" onclick="chk_poz(5)" <cfif get_content.cont_position contains 5> checked</cfif> name="ch_bas" id="ch_bas"><cf_get_lang dictionary_id='50536.Bölüm Başı'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" onclick="chk_poz(6)" width="100" <cfif get_content.cont_position contains 6> checked</cfif> name="ch_yan" id="ch_yan"><cf_get_lang dictionary_id='50537.Bölüm Yanı'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox"  name="none_tree" id="none_tree" <cfif get_content.none_tree is 1>checked</cfif>><cf_get_lang dictionary_id='50538.Bölüm İçerinde Gösterme'></label>
                                        <label class="col col-12 col-xs-6"><input type="checkbox" name="is_rule_popup" id="is_rule_popup" <cfif len(get_content.is_rule_popup) and get_content.is_rule_popup is 1>checked</cfif>><cf_get_lang dictionary_id="50515.Kural Popupları Açılsın"></label>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                <div class="form-group" id="item-user_friendly_url">
                                    <input type="hidden" name="is_autofill" id="is_autofill" value="<cfif isdefined("x_is_auto_fill_user_friendly") and x_is_auto_fill_user_friendly eq 1>1<cfelse>0</cfif>">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='50659.Kullanıcı Dostu Url Adres'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cf_publishing_settings fuseaction="content.list_content" event="det" action_type="cntid" action_id="#attributes.cntid#">
                                        <input type="hidden" name="is_autofill" id="is_autofill" value="<cfif isdefined("x_is_auto_fill_user_friendly") and x_is_auto_fill_user_friendly eq 1>1<cfelse>0</cfif>">
                                        <div class="input-group">
                                            <input type="text" name="user_friendly_url" id="user_friendly_url"  value="<cfoutput>#decodeForHTML(get_content.user_friendly_url)#</cfoutput>">
                                            <span class="input-group-addon">Legacy</span>
                                        </div>                                            
                                    </div>
                                </div>
                                <div class="form-group" id="item-outhor_name">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50545.Yazar'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <div class="input-group">
                                            <input type="text" name="outhor_name" id="outhor_name" value="<cfoutput><cfif len(get_content.outhor_emp_id)>#get_emp_info(get_content.outhor_emp_id,0,0)#<cfelseif len(get_content.outhor_par_id)>#get_par_info(get_content.outhor_par_id,0,-1,0)#<cfelseif len(get_content.outhor_cons_id)>#get_cons_info(get_content.outhor_cons_id,0,0)#</cfif></cfoutput>"  readonly>
                                            <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=fHtmlEditor.outhor_emp_id&field_name=fHtmlEditor.outhor_name&field_partner=fHtmlEditor.outhor_par_id&field_consumer=fHtmlEditor.outhor_cons_id&select_list=1,7,8</cfoutput>','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57742.Tarih !'></cfsavecontent>
                                <div class="form-group" id="item-writing_date">
                                    <input type="hidden" name="outhor_emp_id" id="outhor_emp_id" value="<cfoutput>#get_content.outhor_emp_id#</cfoutput>">
                                    <input type="hidden" name="outhor_par_id" id="outhor_par_id" value="<cfoutput>#get_content.outhor_par_id#</cfoutput>">
                                    <input type="hidden" name="outhor_cons_id" id="outhor_cons_id" value="<cfoutput>#get_content.outhor_cons_id#</cfoutput>"> 
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58184.Yazım Tarihi'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="writing_date" id="writing_date" value="#dateformat(get_content.writing_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="writing_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-view_date_start">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="50575.Yayın Başlangıç"></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='50542.Anasayfada Duyur Girmelisiniz !'></cfsavecontent>
                                            <cfif len(get_content.view_date_start)>
                                                <cfinput type="text" name="view_date_start" id="view_date_start" value="#dateformat(get_content.view_date_start,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:70px;">
                                            <cfelse>
                                                <cfinput type="text" name="view_date_start" id="view_date_start" value="" validate="#validate_style#" message="#message#" style="width:70px;">
                                            </cfif>
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="view_date_start"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-view_date_finish">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="50700.Yayın Bitiş"></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='50542.Anasayfada Duyur Girmelisiniz !'></cfsavecontent>
                                            <cfif len(get_content.view_date_finish)>
                                                <cfinput type="text" name="view_date_finish" id="view_date_finish" style="width:70px;" value="#dateformat(get_content.view_date_finish,dateformat_style)#" validate="#validate_style#" message="#message#">
                                            <cfelse>
                                                <cfinput type="text" name="view_date_finish" id="view_date_finish" style="width:70px;" value="" validate="#validate_style#" message="#message#">
                                            </cfif>
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="view_date_finish"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-version_date">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='678.Revizyon Trh'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="version_date" id="version_date" value="#dateformat(get_content.version_date,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:70px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="version_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-process_stage">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cf_workcube_process is_upd='0' id="process_stage" select_value='#get_content.process_stage#' process_cat_width='130' is_detail='1'>
                                    </div>
                                </div>	
                                <div class="form-group" id="item-write_version">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='677.Revizyon No'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <input name="write_version" id="write_version" type="text" value="<cfoutput>#decodeForHTML(get_content.write_version)#</cfoutput>">
                                    </div>
                                </div>
                                <div class="form-group" id="item-priority">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cfinput type="text" name="priority" id="priority" maxlength="15" value="#get_content.priority#">
                                    </div>
                                </div>
                               
                            </div>
                            <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                <div class="form-group" id="item-language_id">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <select name="language_id" id="language_id">
                                            <cfoutput query="get_language">
                                                <option value="#language_short#" <cfif get_content.language_id is language_short> selected</cfif>>#language_set#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-cont_catid">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                                    <cfif fusebox.circuit eq 'training_management'>
                                        <cfset attributes.is_training = 1>
                                    <cfelse>
                                        <cfset attributes.is_training = 0>
                                    </cfif>
                                    <cfset GET_CONTENT_CAT = getComponent.GET_CONTENT_CAT()>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cf_wrk_selectlang
                                            name="cont_catid"
                                            width="130"
                                            option_name="contentcat"
                                            option_value="contentcat_id"
                                            table_name="CONTENT_CAT"
                                            onchange="showChapter(this.value);"
                                            value="#get_content.CONTENTCAT_ID#"
                                            condition="CONTENTCAT_ID <> 0 AND CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = #session.ep.company_id# OR COMPANY_ID IS NULL) AND IS_TRAINING = #attributes.is_training#"
                                            is_option_text="#iif(not (isdefined("attributes.cont_catid") and (attributes.cont_catid neq 0)),'1','0')#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-chapter_id">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'> *</label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="chapter_place">
                                        <cf_wrk_selectlang
                                            name="chapter"
                                            width="130"
                                            value="#get_content.chapter_id#"
                                            option_name="chapter"
                                            table_name="CONTENT_CHAPTER"
                                            extra_params="CONTENTCAT_ID"
                                            option_value="chapter_id"
                                            condition="CONTENTCAT_ID = #get_content.contentcat_id#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-content_property_id">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cf_wrk_combo
                                            name="content_property_id"
                                            query_name="GET_CONTENT_PROPERTY"
                                            option_name="name"
                                            value="#get_content.content_property_id#"
                                            option_value="content_property_id"
                                            width="100"
                                            required="1">
                                    </div>
                                </div>
                                <div class="form-group" id="item-ana_sayfa">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50560.Erişim Yetkisi'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="internet_view" id="internet_view" <cfif isdefined("attributes.cntid")><cfif get_content.internet_view is 1>checked</cfif></cfif>><cf_get_lang dictionary_id='50612.İnternet'></label>
                                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"> <input type="checkbox" name="career_view" id="career_view" 	<cfif isdefined("attributes.cntid")><cfif get_content.career_view is 1>checked</cfif></cfif>><cf_get_lang dictionary_id='50526.Kariyer Portal'></label>
                                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="employee_view" id="employee_view" <cfif isdefined("attributes.cntid")><cfif get_content.employee_view eq 1>checked</cfif></cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'></label>
                                   </div>
                                </div>  
                                <div class="form-group" id="item-companycat_id">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30426.Partner Portal'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='30426.Partner Portal'></cfsavecontent>
                                        <cf_multiselect_check 
                                            query_name="get_company_cat"  
                                            option_text="#message#"
                                            name="comp_cat" 
                                            width="150"
                                            option_name="companycat" 
                                            option_value="companycat_id" 
                                            value="#get_content.company_cat#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-conscat_id">
                                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='30283.Public Portal'></cfsavecontent>
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30283.Public Portal'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cf_multiselect_check 
                                            query_name="get_customer_cat" 
                                            option_text="#message#" 
                                            name="cunc_cat"
                                            width="150" 
                                            option_name="conscat" 
                                            option_value="conscat_id" 
                                            value="#get_content.consumer_cat#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-position_cat_id">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></cfsavecontent>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cf_multiselect_check 
                                            query_name="get_position_cats" 
                                            option_text="#message#" 
                                            name="position_cat_ids"
                                            width="150" 
                                            option_name="position_cat" 
                                            option_value="position_cat_id" 
                                            value="#get_content.position_cat_ids#"> 
                                    </div>
                                </div> 
                                <div class="form-group" id="item-user_group_id">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42144.Yetki Grupları'></label>
                                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='42144.Yetki Grupları'></cfsavecontent>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <cf_multiselect_check 
                                            query_name="get_user_groups"  
                                            option_text="#message#" 
                                            name="user_group_ids"
                                            width="150" 
                                            option_name="user_group_name" 
                                            option_value="user_group_id" 
                                            value="#get_content.user_group_ids#"> 
                                    </div>
                                </div>
                            </div>
                    </cf_box_elements>
                </div>
                <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
                    <cf_box_elements vertical="1">
                        <div class="col col-12 col-xs-12" type="column" index="4" sort="true">	
                            <div class="form-group" id="item-subject">
                                <label class="bold"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık !'></cfsavecontent>
                                    <cfinput type="text" name="subject" id="subject" value="#decodeForHTML(get_content.cont_head)#" required="yes" message="#message#" maxlength="125">
                            </div> 
                            <div class="form-group" id="item-summary">
                                <label class="bold"><cf_get_lang dictionary_id=' 58052.Özet'></label>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='50699.Ozet satırında fazla karakter sayisi'></cfsavecontent>
                                <textarea name="summary" id="summary" style="width:500px;height:60px;" rows="4" message="<cfoutput>#message#</cfoutput>" maxlength="3999" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfoutput>#decodeForHTML(get_content.cont_summary)#</cfoutput></textarea>
                            </div>
                                <cfset tr_topic = get_content.cont_body>
                                <cfif isdefined("attributes.corrcat_id")>
                                    <cfset setup_template = getComponent.SetupTemplate(template_id: attributes.template_id)>
                                    <cfset tr_topic = setup_template.template_content>
                                </cfif>
                                <div class="form-group" id="item-template_id">
                                    <label class="bold"><cf_get_lang dictionary_id="58640.şablonlar"></label>
                                    <select name="template_id" id="template_id" style="width:150px;" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open('<cfoutput>#request.self#?fuseaction=content.list_content&event=det&cntid=#attributes.cntid#</cfoutput>&template_id='+this.options[this.selectedIndex].value,'_self') }">
                                        <option value="" selected><cf_get_lang dictionary_id='58640.Şablon'>
                                        <cfoutput query="get_cat">
                                            <option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#template_head# 
                                        </cfoutput>
                                    </select>
                                </div>
                            <div class="form-group" id="item-editor">
                                <label style="display:none!important;"><cf_get_lang dictionary_id='57653.İçerik'></label>	
                                <cfmodule 
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="WRKContent"
                                    basepath="/fckeditor/"
                                    devmode="1"
                                    instancename="CONT_BODY"
                                    value="#get_content.cont_body#"
                                    width="99%"
                                    height="350">
                            </div>   
                        </div>
                    </cf_box_elements>
                </div>
            </cf_tab>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_box_footer>  
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cf_record_info query_name="get_content" record_emp="record_member" update_emp="update_member">
                                <!--- Bu div ve altindaki table yapisi record_info'ya benzetebilmek amaciyla eklenmistir. P.Y 20120904 --->
                                <div style="margin-top:12px;">
                                    <cfif len(get_content.write_version)>
                                        <cfoutput>
                                            &nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='677.Revizyon No'>:
                                            #get_content.write_version#
                                        </cfoutput>
                                    </cfif>
                                    <cfif len(get_content.upd_count)>
                                        <cfoutput>
                                            <span style="font-size:11px;"> &nbsp; V : 
                                            #get_content.upd_count# </span>
                                        </cfoutput>
                                    </cfif>
                                </div>  
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cf_workcube_buttons is_upd='1' 
                                delete_page_url='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.del_content&cntid=#url.cntid#'
                                add_function='kontrol()'>
                            </div>
                        </cf_box_footer>
                    </div>
                </cfform>  
            </cf_box> 
        </div>
        <div class="col col-3 col-xs-12">
            <!--- İlişkili Sorular --->
            <cf_box
                id = "related_questions"
                title = "#getLang('','İlişkili Sorular',63824)#"
                box_page = "#request.self#?fuseaction=training_management.list_content&event=relatedQuestions&cntid=#url.cntid#"
                info_href = "javascript:openBoxDraggable('#request.self#?fuseaction=training_management.list_content&event=listContentQuestions&cntid=#url.cntid#','related_questions_box','ui-draggable-box-larger')"
            >
            </cf_box>
            <!--- Belgeler --->
            <cf_get_workcube_asset asset_cat_id="-7" module_id='2' action_section='CONTENT_ID' action_id='#attributes.cntid#'>
            <!---icerikler--->
            <cf_get_workcube_content action_type='CONTENT_ID' action_type_id='#attributes.cntid#' design='0' is_add_upd='1'>
            <!--- imajlar --->
            <cf_wrk_images type="content" contentId="#url.cntid#">
            <!--- konu goruntulenme --->
            <cfsavecontent variable="text"><cf_get_lang dictionary_id='50539.Hit'></cfsavecontent>
            <cf_box 
                id="_content_related_hit_"
                box_page="#request.self#?fuseaction=content.emptypopup_content_related_hit_ajax&cntid=#url.cntid#"
                title="#text#"
                closable="0">
            </cf_box>
            <!--- meta tanımları --->
            <cf_meta_descriptions action_id = '#attributes.cntid#' action_type ='CONTENT_ID' faction_type='#listgetat(attributes.fuseaction,1,"&")#'> 
            <!--- degerlendirme formları--->
            <cf_get_workcube_form_generator action_type='2' related_type='2' action_type_id='#url.cntid#' design='1'>
        </div>
	<script type="text/javascript">
		function showChapter(cont_catid)	
		{
			var cont_catid = document.getElementById('cont_catid').value;
			if (cont_catid != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=content.popup_ajax_list_chapter&cont_catid="+cont_catid;
				AjaxPageLoad(send_address,'chapter_place',1,'İlişkili Bölümler');
			}
		}

		<cfif fusebox.circuit eq 'training_management'>
			var is_training = 1;
		<cfelse>
			var is_training = 0;
		</cfif>	
				
		<cfif isdefined('x_is_selected_language') and (x_is_selected_language eq 1)> 
			<!--- Dil seçeneği değişince ilişkili dildeki kategorileri getirir --->
			$('#language_id').change(function() { get_lang_(); } ) 
			function get_lang_()
			{                                                                           
			   url_ = "/web_services/get_list_cat.cfc?method=get_cat_list_fnc&language_id="+document.getElementById("language_id").value+"&is_training="+is_training+"";
			   $.ajax({
				  cache: false,
				  url: url_,
				  dataType: "text",
				  success: function(read_data)
				  {
					$('#cont_catid option').remove();
					var new_opt = '<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
					$('#cont_catid').append(new_opt);
					data_ = jQuery.parseJSON(read_data);
						$.each(data_.DATA,function(i){
							$.each(data_.COLUMNS,function(k){
								var CONTENTCAT = data_.DATA[i][0];
								var CONTENTCAT_ID = data_.DATA[i][1];
								
								if(k == 1){
									if(CONTENTCAT_ID == '<cfoutput>#get_content.CONTENTCAT_ID#</cfoutput>')	
										var new_opt = '<option value="'+CONTENTCAT_ID+'" selected>'+CONTENTCAT+'</option>';
									else
										var new_opt = '<option value="'+CONTENTCAT_ID+'">'+CONTENTCAT+'</option>';									
									$('#cont_catid').append(new_opt);
								}
							});
						});
						get_chapter();
				  }
			   });
			};

			get_lang_(); <!--- Sayfa ilk yüklendiğinde varsayılan dile göre kategorileri getirir --->					
			<!--- Kategori diline uygun ilişkili bölümleri getirir --->	
			
			
			$('#cont_catid').change(function() { get_chapter(); } );
			
			function get_chapter()
			{  
			   url_ = "/web_services/get_list_cat.cfc?method=get_chapter_list_fnc&cont_catid="+document.getElementById("cont_catid").value;
			   
			   $.ajax({
				  cache: false,
				  url: url_,
				  dataType: "text",
				  success: function(read_data)
				  {
					$('#chapter option').remove();
					var new_opt = '<option value=""><cf_get_lang dictionary_id='322.Seçiniz'></option>';
					$('#chapter').append(new_opt);
					data_ = jQuery.parseJSON(read_data);
						$.each(data_.DATA,function(i){
							$.each(data_.COLUMNS,function(k){
								var CHAPTER_ID = data_.DATA[i][0];
								var CHAPTER = data_.DATA[i][1];	
								if(k == 1){
									if(CHAPTER_ID == '<cfoutput>#get_content.chapter_id#</cfoutput>')	
										var new_opt = '<option value="'+CHAPTER_ID+'" selected>'+CHAPTER+'</option>';
									else
										var new_opt = '<option value="'+CHAPTER_ID+'">'+CHAPTER+'</option>';									
									$('#chapter').append(new_opt);
								}
							});
						});
				  }
				  
			   });
			}
		</cfif>  
				
		function kontrol()
		{
	
            if(!date_check(document.getElementById('view_date_start'),document.getElementById('view_date_finish'))){
                alert("<cf_get_lang dictionary_id='30306.Girdiğiniz yayın bitiş tarihi başlangıç tarihinden önce gözüküyor! Lütfen düzeltiniz!'>");
				return false;	
            }
			
			x = document.fHtmlEditor.cont_catid.selectedIndex;
			if (document.fHtmlEditor.cont_catid[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id ='50531.İçerik Kategorisi '>!");
				return false;
			}
			
			x = document.fHtmlEditor.chapter.selectedIndex;
			if (document.fHtmlEditor.chapter[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='50582.İçerik Bölümü '>!");
				return false;
            }
            
            /* return true;
			
			x = document.fHtmlEditor.process_stage.selectedIndex;
			if (document.fHtmlEditor.process_stage[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='564.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok ! '>");
				return false;
			}
			*/
			return process_cat_control();
			
		}

        //page loading for ajax TÖ
		<cfif isdefined("attributes.template_id")>
            <cfset setup_template = getComponent.SetupTemplate(template_id: attributes.template_id)>	
			document.fHtmlEditor.CONT_BODY.value = '<cfoutput>#setup_template.template_content#</cfoutput>';	
		</cfif>
		function buyult_kucult(type)
		{	
			if(type==1)//1 ise küçültsün
				document.getElementById('cont').style.height="335px";
			if(type==2)//2 ise büyültsün
				document.getElementById('cont').style.height="600px";
		}
		
		function usergroup_hepsi()
		{
			if (document.fHtmlEditor.user_group_id_all.checked)
			{	
				for(say=0;say<<cfoutput>#get_user_groups.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.user_group_ids[say].checked = true;
			}
			else
			{
				for(say=0;say<<cfoutput>#get_user_groups.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.user_group_ids[say].checked = false;
			}
			return false;
		}
		
		function position_hepsi()
		{
			if (document.fHtmlEditor.position_cat_id_all.checked)
			{	
				for(say=0;say<<cfoutput>#get_position_cats.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.position_cat_ids[say].checked = true;
			}
			else
			{
				for(say=0;say<<cfoutput>#get_position_cats.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.position_cat_ids[say].checked = false;
			}
			return false;
		}
		
		function partner_hepsi()
		{
			if (document.fHtmlEditor.comp_cat_all.checked)
			{	
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.comp_cat[say].checked = true;
			}
			else
			{
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.comp_cat[say].checked = false;
			}
			return false;
		}
		
		function public_hepsi()
		{
			if (document.fHtmlEditor.cunc_cat_all.checked)
			{	
				document.fHtmlEditor.internet_view.checked = true;
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.cunc_cat[say].checked = true;
			}
			else
			{	
				document.fHtmlEditor.internet_view.checked = false;
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.cunc_cat[say].checked = false;
			}
			return false;
		}
		
		function career_hepsi()
		{
			if (document.fHtmlEditor.career_view_all.checked)
				document.fHtmlEditor.career_view.checked = true;
			else
				document.fHtmlEditor.career_view.checked = false;
		}
		function hepsi()
		{
			if(document.fHtmlEditor.all.checked)
			{
				document.fHtmlEditor.internet_view.checked = true;
				document.fHtmlEditor.user_group_id_all.checked = true;
				document.fHtmlEditor.position_cat_id_all.checked = true;
				document.fHtmlEditor.career_view_all.checked = true;
				document.fHtmlEditor.cunc_cat_all.checked = true;
				document.fHtmlEditor.comp_cat_all.checked = true;
				document.fHtmlEditor.employee_view.checked = true;
				document.fHtmlEditor.career_view.checked = true;
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.comp_cat[say].checked = true;
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.cunc_cat[say].checked = true;
				for(say=0;say<<cfoutput>#get_position_cats.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.position_cat_ids[say].checked = true;
				for(say=0;say<<cfoutput>#get_user_groups.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.user_group_ids[say].checked = true;
			}
			else
			{
				document.fHtmlEditor.internet_view.checked = false;
				document.fHtmlEditor.user_group_id_all.checked = false;
				document.fHtmlEditor.position_cat_id_all.checked = false;
				document.fHtmlEditor.career_view_all.checked = false;
				document.fHtmlEditor.cunc_cat_all.checked = false;
				document.fHtmlEditor.comp_cat_all.checked = false;
				document.fHtmlEditor.employee_view.checked = false;
				document.fHtmlEditor.career_view.checked = false;
				for(say=0;say<<cfoutput>#get_company_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.comp_cat[say].checked = false;
				for(say=0;say<<cfoutput>#get_customer_cat.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.cunc_cat[say].checked = false;
				for(say=0;say<<cfoutput>#get_position_cats.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.position_cat_ids[say].checked = false;
				for(say=0;say<<cfoutput>#get_user_groups.recordcount#</cfoutput>;say++)
					document.fHtmlEditor.user_group_ids[say].checked = false;
			}
		}
    </script>
</cfif>
<script>
    function open_tab(url,id) {
        document.getElementById(id).style.display ='';	
        document.getElementById(id).style.width ='500px';	
		$("#"+id).css('margin-left',$("#tabMenu").position().left-300);
		$("#"+id).css('margin-top',$("#tabMenu").position().top);
		$("#"+id).css('position','absolute');	
		
		AjaxPageLoad(url,id,1);
		return false;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">


