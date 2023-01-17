<cfset getComponent = createObject('component','V16.content.cfc.get_content')>
<cf_xml_page_edit>
<cf_get_lang_set module_name="content">
<cfset session.userFilesPath = "/documents/content/" />
<cfinclude template="../../objects/display/imageprocess/imcontrol.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_chapter_menu.cfm">
<cfset form_add = 1 > <!--- Sadece Aktif durumdaki kategorilerin gelmesi için eklendi --->
<cfinclude template="../query/get_customer_cat.cfm">
<cfset GET_LANGUAGE = getComponent.GET_LANGUAGE()>
<cfset GET_USER_GROUPS = getComponent.GET_USER_GROUPS()>
<cfset GET_POSITION_CATS = getComponent.GET_POSITION_CATS()>
<cfset GET_CAT = getComponent.GET_CAT()>

<script type="text/javascript">
	function check_view()
	{
		if (fHtmlEditor.is_viewed.checked && (fHtmlEditor.view_date_finish.value == ""))
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='50601.Ana Sayfa Duyuru Bitiş Tarihi !'>");
			return false;
		}
		return true;
	}
	
	function val_kontrol()
	{	
		window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.add_form_content&cont_catid="+document.getElementById('cont_catid').value;
	}
	
	function chk_poz(gelen)
	{
		if ( (gelen == 1) && (fHtmlEditor.ana_sayfayan.checked) ) fHtmlEditor.ana_sayfayan.checked = false;
		if ( (gelen == 2) && (fHtmlEditor.ana_sayfa.checked) ) fHtmlEditor.ana_sayfa.checked = false;
		if ( (gelen == 3) && (fHtmlEditor.bolum_yan.checked) ) fHtmlEditor.bolum_yan.checked = false;
		if ( (gelen == 4) && (fHtmlEditor.bolum_basi.checked) ) fHtmlEditor.bolum_basi.checked = false;
		if ( (gelen == 5) && (fHtmlEditor.ch_yan.checked) ) fHtmlEditor.ch_yan.checked = false;
		if ( (gelen == 6) && (fHtmlEditor.ch_bas.checked) ) fHtmlEditor.ch_bas.checked = false;
	}
</script>

<cfif isDefined("attributes.cntid")> <!--- İçerik Kopyalama için cid ile gelinmesi durumunda --->
	<cfif isnumeric(attributes.cntid)>
		<cfscript>
            get_content_list_action = CreateObject("component","V16.content.cfc.get_content");
            get_content_list_action.dsn = dsn;
            get_content = get_content_list_action.get_content_list_fnc(
            cntid : '#iif(isdefined("attributes.cntid"),"attributes.cntid",DE(""))#'
            );
        </cfscript>
    <cfelse>
        <cfset get_content.recordcount = 0>
	</cfif>
</cfif>
<cf_catalystheader>
<cfform name="fHtmlEditor" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_content" method="post">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box>
                <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2" divLang="İçerik;Yayın Bilgileri;">
                        <!--- isbu blok icerige farkli yerlerden yapilan eklemeler icin kullanilmaktadir silinmesin 13102008 --->
                        <cfif isdefined("attributes.action_type_id")>
                            <input type="hidden" name="action_type_id" id="action_type_id" value="<cfoutput>#attributes.action_type_id#</cfoutput>">
                            <input type="hidden" name="action_type" id="action_type" value="<cfoutput><cfif isdefined("attributes.action_type") and len (attributes.action_type)>#attributes.action_type#</cfif></cfoutput>">
                        </cfif>
                        <!--- isbu blok icerige farkli yerlerden yapilan eklemeler icin kullanilmaktadir silinmesin 13102008 --->
                        <div id="unique_sayfa_2" class="ui-info-text uniqueBox">	
                            <cf_box_elements>
                                <div class="col col-2 col-md-2 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                    <div class="form-group" id="item-status">
                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="status" id="status" value="1" checked<cfif isDefined("attributes.cntid")><cfif get_content.content_status is 1> checked</cfif></cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="spot" id="spot" value="1"<cfif isDefined("attributes.cntid")><cfif get_content.spot is 1> checked</cfif></cfif>><cf_get_lang dictionary_id='50578.Spot'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_dsp_header" id="is_dsp_header" <cfif isDefined("attributes.cntid")><cfif get_content.is_dsp_header is 1> checked</cfif></cfif>><cf_get_lang dictionary_id='50581.Başlık Gösterme'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_dsp_summary" id="is_dsp_summary" <cfif isDefined("attributes.cntid")><cfif get_content.is_dsp_summary is 1> checked</cfif></cfif>><cf_get_lang dictionary_id='50573.Özet Gösterme'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_viewed" id="is_viewed" <cfif isDefined("attributes.cntid")><cfif get_content.is_viewed is 1> checked</cfif></cfif>><cf_get_lang dictionary_id='50541.Anasayfada Duyur'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="ana_sayfa" id="ana_sayfa" onclick="chk_poz(1)" <cfif isDefined("attributes.cntid")><cfif get_content.cont_position contains 1> checked</cfif></cfif>><cf_get_lang dictionary_id='50532.Anasayfa'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="ana_sayfayan" id="ana_sayfayan" onclick="chk_poz(2)" <cfif isDefined("attributes.cntid")><cfif get_content.cont_position contains 2> checked</cfif></cfif>><cf_get_lang dictionary_id='50533.Anasayfa Yan'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="bolum_basi" id="bolum_basi" onclick="chk_poz(3)" <cfif isDefined("attributes.cntid")><cfif get_content.cont_position contains 3> checked</cfif></cfif>><cf_get_lang dictionary_id='50534.Kategori Başı'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="bolum_yan" id="bolum_yan" onclick="chk_poz(4)" <cfif isDefined("attributes.cntid")><cfif get_content.cont_position contains 4> checked</cfif></cfif>><cf_get_lang dictionary_id='50535.Kategori Yanı'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="ch_bas" id="ch_bas" onclick="chk_poz(5)" <cfif isDefined("attributes.cntid")><cfif get_content.cont_position contains 5> checked</cfif></cfif>><cf_get_lang dictionary_id='50536.Bölüm Başı'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="ch_yan" id="ch_yan" onclick="chk_poz(6)" <cfif isDefined("attributes.cntid")><cfif get_content.cont_position contains 6> checked</cfif></cfif>><cf_get_lang dictionary_id='50537.Bölüm Yanı'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="none_tree" id="none_tree" <cfif isDefined("attributes.cntid")><cfif get_content.none_tree is 1> checked</cfif></cfif>><cf_get_lang dictionary_id='50538.Bölüm İçerisinde Göster'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_rule_popup" id="is_rule_popup" <cfif isDefined("attributes.cntid")><cfif len(get_content.is_rule_popup) and get_content.is_rule_popup is 1>checked</cfif></cfif>><cf_get_lang dictionary_id="50515.Kural Popupları Açılsın"></label>   
                                    
                                        </div>        
                                    </div>
                                </div>
                                <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort="true">	  
                                    <div class="form-group" id="item-surec">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cf_workcube_process is_upd='0' process_cat_width='90' is_detail='0'>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-outhor_emp_id"> 
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50545.Yazar'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="outhor_emp_id" id="outhor_emp_id" value="<cfif isDefined ("attributes.cntid")><cfoutput>#get_content.outhor_emp_id#</cfoutput></cfif>">
                                                <input type="hidden" name="outhor_par_id" id="outhor_par_id" value="<cfif isDefined ("attributes.cntid")><cfoutput>#get_content.outhor_par_id#</cfoutput></cfif>">
                                                <input type="hidden" name="outhor_cons_id" id="outhor_cons_id" value="<cfif isDefined ("attributes.cntid")><cfoutput>#get_content.outhor_cons_id#</cfoutput></cfif>"> 
                                                <input type="text" name="outhor_name" id="outhor_name" value="<cfif isDefined ("attributes.cntid")><cfoutput><cfif len(get_content.outhor_emp_id)>#get_emp_info(get_content.outhor_emp_id,0,0)#<cfelseif len(get_content.outhor_par_id)>#get_par_info(get_content.outhor_par_id,0,-1,0)#<cfelseif len(get_content.outhor_cons_id)>#get_cons_info(get_content.outhor_cons_id,0,0)#</cfif></cfoutput></cfif>" readonly>
                                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=fHtmlEditor.outhor_emp_id&field_name=fHtmlEditor.outhor_name&field_partner=fHtmlEditor.outhor_par_id&field_consumer=fHtmlEditor.outhor_cons_id&select_list=1,7,8</cfoutput>','list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-view_date_start">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="50575.Yayın Başlangıç"></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='50542.Anasayfada Duyur Girmelisiniz !'></cfsavecontent>
                                                <cfinput type="text" name="view_date_start" id="view_date_start" value="#iif(isdefined("attributes.cntid"),"dateformat(get_content.view_date_start,dateformat_style)",DE(""))#" validate="#validate_style#" message="#message#" >
                                                <span class="input-group-addon"> <cf_wrk_date_image date_field="view_date_start"> </span>
                                            </div> 
                                        </div> 
                                    </div>
                                    <div class="form-group" id="item-view_date_finish">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="50700.Yayın Bitiş"></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='50542.Anasayfada Duyur Girmelisiniz !'></cfsavecontent>
                                                <cfinput type="text" name="view_date_finish" id="view_date_finish" value="#iif(isdefined("attributes.cntid"),"dateformat(get_content.view_date_finish,dateformat_style)",DE(""))#" validate="#validate_style#" message="#message#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="view_date_finish"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-writing_date"> 
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58184.Yazım Tarihi'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <div class="input-group">
                                                <cfinput type="text" name="writing_date" id="writing_date" value="#iif(isdefined("attributes.cntid"),"dateformat(get_content.writing_date,dateformat_style)",DE(""))#" validate="#validate_style#">
                                                <span class="input-group-addon"> <cf_wrk_date_image date_field="writing_date"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-version_date"> 
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='678.Revizyon Trh'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <div class="input-group">
                                                <cfinput type="text" name="version_date" id="version_date" value="#iif(isdefined("attributes.cntid"),"dateformat(get_content.version_date,dateformat_style)",DE(""))#" validate="#validate_style#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="version_date"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-write_version"> 
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='677.Revizyon No'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <input type="text" name="write_version" id="write_version" value="<cfif isdefined("attributes.cntid")><cfoutput>#get_content.write_version#</cfoutput></cfif>">
                                        </div>
                                    </div>  
                                </div>    
                                <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                    <div class="form-group" id="item-priority">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cfinput type="text" name="priority" id="priority" maxlength="15" value="#iif(isdefined("attributes.cntid"),"get_content.priority",DE(""))#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-language_id">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <select name="language_id" id="language_id" style="width:60px;">
                                                <cfoutput query="get_language">
                                                    <option value="#language_short#" <cfif isDefined ("attributes.cntid")> <cfif get_content.language_id is language_short> selected</cfif><cfelseif session.ep.language eq language_short>selected</cfif>>#language_set#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-cont_catid">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cfif fusebox.circuit eq 'training_management'>
                                                <cfset attributes.is_training = 1>
                                            <cfelse>
                                                <cfset attributes.is_training = 0>
                                            </cfif>
                                            <cf_wrk_selectlang
                                                name="cont_catid"
                                                width="130"
                                                option_name="contentcat"
                                                option_value="contentcat_id"
                                                onchange="showChapter(this.value);"
                                                table_name="CONTENT_CAT"
                                                value="#iif(isdefined("attributes.cntid"),"get_content.CONTENTCAT_ID",DE(""))#"
                                                condition="CONTENTCAT_ID <> 0 AND CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = #session.ep.company_id# OR COMPANY_ID IS NULL) AND IS_TRAINING =#attributes.is_training#">
                                        </div>    
                                    </div>
                                    <div class="form-group" id="item-chapter_id">
                                        <cfsavecontent variable="text"><cf_get_lang dictionary_id='57995.Bölüm Seçiniz'></cfsavecontent>
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57995.Bölüm'>*</label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12" id="chapter_place">
                                            <cf_wrk_selectlang
                                                name="chapter"
                                                width="130"
                                                option_name="chapter"
                                                option_value="chapter_id"
                                                table_name="CONTENT_CHAPTER"
                                                option_text="#text#"
                                                value="#iif(isdefined("attributes.cntid"),"get_content.chapter_id",DE(""))#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-content_property_id">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cf_wrk_combo
                                                    name="content_property_id"
                                                    query_name="GET_CONTENT_PROPERTY"
                                                    option_name="name"
                                                    option_value="content_property_id"
                                                    value="#iif(isdefined("attributes.cntid"),"get_content.content_property_id",DE(""))#"
                                                    width="100"
                                                    required="1">	  
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                    <div class="form-group" id="item-ana_sayfa">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50560.Erişim Yetkisi'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="internet_view" id="internet_view" <cfif isdefined("attributes.cntid")><cfif get_content.internet_view is 1>checked</cfif></cfif>><cf_get_lang dictionary_id='50612.İnternet'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="career_view" id="career_view" 	<cfif isdefined("attributes.cntid")><cfif get_content.career_view is 1>checked</cfif></cfif>><cf_get_lang dictionary_id='50526.Kariyer Portal'></label>
                                            <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="employee_view" id="employee_view" <cfif isdefined("attributes.cntid")><cfif get_content.employee_view eq 1>checked</cfif></cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'></label>
                                        </div>
                                        
                                    </div>   
                                    <div class="form-group" id="item-comp_cat">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30426.Partner Portal'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><!--- Partner Portal --->
                                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='30426.Partner Portal'></cfsavecontent>
                                            <cf_multiselect_check 
                                                query_name="get_company_cat"  
                                                name="comp_cat"
                                                option_text="#message#"
                                                option_name="companycat" 
                                                option_value="companycat_id"
                                                value="#iif(isdefined("attributes.cntid"),"get_content.company_cat",DE(""))#"> 
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-cunc_cat">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30283.Public Portal'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><!--- Public Portal --->
                                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='30283.Public Portal'></cfsavecontent>
                                            <cf_multiselect_check 
                                                query_name="get_customer_cat" 
                                                option_text="#message#" 
                                                name="cunc_cat"
                                                width="180" 
                                                option_name="conscat" 
                                                option_value="conscat_id"
                                                value="#iif(isdefined("attributes.cntid"),"get_content.consumer_cat",DE(""))#"> 
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-position_cat_ids">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><!--- Pozisyon Tipleri --->
                                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></cfsavecontent>
                                            <cf_multiselect_check 
                                                query_name="get_position_cats"
                                                option_text="#message#" 
                                                name="position_cat_ids"
                                                width="180" 
                                                option_name="position_cat" 
                                                option_value="position_cat_id"
                                                value="#iif(isdefined("attributes.cntid"),"get_content.position_cat_ids",DE(""))#"> 
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-user_group_ids">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42144.Yetki Grupları'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><!--- Yetki Grupları --->
                                            <cfsavecontent  variable="message"><cf_get_lang dictionary_id='42144.Yetki Grupları'></cfsavecontent>
                                            <cf_multiselect_check 
                                                query_name="get_user_groups" 
                                                option_text="#message#" 
                                                name="user_group_ids"
                                                width="180" 
                                                option_name="user_group_name" 
                                                option_value="user_group_id"
                                                value="#iif(isdefined("attributes.cntid"),"get_content.user_group_ids",DE(""))#"> 
                                        </div>
                                    </div>
                                </div>
                            </cf_box_elements>
                        </div>
                        <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
                            <cf_box_elements vertical="1">
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="5" sort="true">
                                    <div class="form-group" id="item-subject">
                                        <label class="bold"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık !'></cfsavecontent>
                                        <cfinput type="text"  name="subject" id="subject"  required="Yes" message="#message#" value="#iif(isdefined("attributes.cntid"),"get_content.cont_head",DE(""))#">
                                    </div>
                                    <div class="form-group" id="item-summary">
                                        <label class="bold"><cf_get_lang dictionary_id='58052.Özet'></label>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='50699.Ozet satırında fazla karakter sayisi'></cfsavecontent>
                                        <textarea name="summary" id="summary" style="width:500px;height:60px;" message="<cfoutput>#message#</cfoutput>" maxlength="3999" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"> <cfif isdefined("attributes.cntid")><cfoutput>#get_content.cont_summary#</cfoutput></cfif></textarea>
                                    </div>
                                    <div class="form-group" id="item-template_id">
                                        <label class="bold"><cf_get_lang dictionary_id='58640.Templates'></label>
                                        <select name="template_id" id="template_id" onchange="document.fHtmlEditor.action = '';document.fHtmlEditor.submit();">
                                            <option value="" selected> <cf_get_lang dictionary_id='58640.Şablon'>
                                            <cfoutput query="get_cat">
                                                <option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#template_head# 
                                            </cfoutput>
                                        </select>
                                    </div>
                                    <div class="form-group" id="item-editor">
                                        <label style="display:none!important;"><cf_get_lang dictionary_id='57653.İçerik'></label>
                                        <cfmodule
                                            template="/fckeditor/fckeditor.cfm"
                                            toolbarset="de"
                                            basePath="/fckeditor/"
                                            instancename="CONT_BODY"
                                            valign="top"
                                            devmode="1"
                                            value="#iif(isdefined("attributes.cntid"),"get_content.cont_body",DE(""))#"
                                            width="99%"
                                            height="380"> 
                                     </div>
                                </div>
                            </cf_box_elements>
                        </div> 
                    </cf_tab>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_box_footer>
                            <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                        </cf_box_footer>
                    </div>
            </cf_box>
        </div>
</cfform>
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
		$('#language_id').change(function() { get_lang_(); })
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
								<cfif isdefined("attributes.cntid")>
									if(CONTENTCAT_ID == '<cfoutput>#get_content.CONTENTCAT_ID#</cfoutput>')	
										var new_opt = '<option value="'+CONTENTCAT_ID+'" selected>'+CONTENTCAT+'</option>';
									else
										var new_opt = '<option value="'+CONTENTCAT_ID+'">'+CONTENTCAT+'</option>';									
								<cfelse>
									var new_opt = '<option value="'+CONTENTCAT_ID+'">'+CONTENTCAT+'</option>';
								</cfif>
								$('#cont_catid').append(new_opt);
							}
						});
					});
				}
			});
			get_chapter();
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
				var new_opt = '<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>';
				$('#chapter').append(new_opt);
				data_ = jQuery.parseJSON(read_data);
					$.each(data_.DATA,function(i){
						$.each(data_.COLUMNS,function(k){
							var CHAPTER_ID = data_.DATA[i][0];
							var CHAPTER = data_.DATA[i][1];
							if(k == 1){
								<cfif isdefined("attributes.cntid")>
									if(CHAPTER_ID == '<cfoutput>#get_content.chapter_id#</cfoutput>')
										var new_opt = '<option value="'+CHAPTER_ID+'" selected>'+CHAPTER+'</option>';
									else
										var new_opt = '<option value="'+CHAPTER_ID+'">'+CHAPTER+'</option>';
								<cfelse>
									var new_opt = '<option value="'+CHAPTER_ID+'">'+CHAPTER+'</option>';
								</cfif>
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
        
        x = document.getElementById('cont_catid').selectedIndex;
		if (document.getElementById('cont_catid')[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='50531.İçerik Kategorisi!'>");
			return false;
        } 
        
        x = document.getElementById('chapter').selectedIndex;
		if (document.getElementById('chapter')[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='50582.İçerik Bölümü '>!");
			return false;
		} 
        if(!date_check(fHtmlEditor.view_date_start,fHtmlEditor.view_date_finish,"<cf_get_lang dictionary_id='47767'>")){
			return false;
		}
		return check_view==undefined ? true : check_view() ;
	}
	
	<cfif isdefined("attributes.template_id") AND len(attributes.template_id)>
		<cfinclude template="../query/get_templates.cfm">  	
		document.fHtmlEditor.CONT_BODY.value = '<cfoutput>#SETUP_TEMPLATE.TEMPLATE_CONTENT#</cfoutput>';	
	</cfif>	
	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
