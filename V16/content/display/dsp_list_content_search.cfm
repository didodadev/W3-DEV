<cfparam name="attributes.meta_title" default="">
<cfparam name="attributes.meta_head" default="">
<cfparam name="attributes.meta_keyword" default="">
<cfform name="form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_content">
	<cf_box_search>
        <div class="form-group" id="item-keyword">
            <cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Filtre',62273)#" value="#decodeForHTML(attributes.keyword)#" maxlength="50">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
        </div>
        <div class="form-group" id="item-language_id">
            <select name="language_id" id="language_id" onChange="get_content_cat(this.value,'<cfoutput>#decodeForHTML(session.ep.company_id)#</cfoutput>');">
                <option value=""><cf_get_lang dictionary_id='58996.Dil'></option>
                <cfoutput query="get_language">
                    <option value="#language_short#" <cfif attributes.language_id eq language_short>selected="selected"</cfif>>#language_set#</option>
                </cfoutput>
            </select>
        </div>
        <div class="form-group" id="item-content_cat_place">
            <div id="content_cat_place"></div>
        </div>
        <div class="form-group" id="item-content_property_id">
            <cfsavecontent variable="icerik_tipi_opt_txt"><cf_get_lang dictionary_id='50617.İçerik Tipi'></cfsavecontent>
            <cf_wrk_combo
            name="content_property_id"
            query_name="GET_CONTENT_PROPERTY"
            option_text="#icerik_tipi_opt_txt#"
            option_name="name"
            option_value="content_property_id"
            value="#iif(len(attributes.content_property_id),'attributes.content_property_id',DE(''))#">
        </div>
        <div class="form-group" id="item-status">
            <select name="status" id="status">
                <option value="1" <cfif attributes.status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                <option value="2" <cfif attributes.status eq 2> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                <option value="3" <cfif attributes.status eq 3> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
            </select>
        </div>
        <div class="form-group small">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
            <cfinput type="text" name="maxrows" id="maxrows" value="#decodeForHTML(attributes.maxrows)#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
        </div>
        <div class="form-group"><cf_wrk_search_button button_type="4"></div>
    </cf_box_search>
    <cf_box_search_detail>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group" id="item-user_friendly_url">
                <label><cf_get_lang dictionary_id="50659.Kullanıcı Dostu Url"></label>
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='50659.Kullanıcı dostu url'>
                    </cfsavecontent>
                <cfinput type="text" name="user_friendly_url" id="user_friendly_url" value="#decodeForHTML(attributes.user_friendly_url)#" maxlength="255" placeholder="#message#">
            </div>
            <div class="form-group" id="item-stage_id">
                <label><cf_get_lang dictionary_id='58859.Süreç'></label>
                <select name="stage_id" id="stage_id">
                    <option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>                                    
                    <cfoutput query="get_content_process_stages"> 
                        <option value="#stage_id#" <cfif isdefined("attributes.stage_id") and len(attributes.stage_id) and (attributes.stage_id eq stage_id)>selected</cfif>>#stage_name#</option>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group" id="item-priority">
                <label><cf_get_lang dictionary_id ='57485.Öncelik'></label>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57734.Seciniz'></cfsavecontent>
                <cfinput type="text" name="priority" placeholder="#message#" id="priority" maxlength="15" value="#attributes.priority#">
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-order_type">
                <label><cf_get_lang dictionary_id='57780.İçerik Sırası'></label>
                <select name="order_type" id="order_type">
                    <option value="1" <cfif attributes.order_type eq 1> selected</cfif>><cf_get_lang dictionary_id='57780.İçerik Sırası'></option>
                    <option value="2" <cfif attributes.order_type eq 2> selected</cfif>><cf_get_lang dictionary_id='57781.Öncelik Sırası'></option>
                    <cfif isdefined('x_is_hit') and (x_is_hit eq 1)>
                        <option value="3" <cfif attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id="54732.Public Hit Sırası"></option>
                        <option value="4" <cfif attributes.order_type eq 4> selected</cfif>><cf_get_lang dictionary_id="54740.Partner Hit Sırası"></option>
                        <option value="5" <cfif attributes.order_type eq 5> selected</cfif>><cf_get_lang dictionary_id="54743.Employee Hit Sırası"></option>
                        <option value="6" <cfif attributes.order_type eq 6> selected</cfif>><cf_get_lang dictionary_id="54745.Ziyaretçi Hit Sırası"></option>
                    </cfif>
                </select>
            </div>
            <div class="form-group" id="item-record_member">
                <label><cf_get_lang dictionary_id="57899.Kaydeden"></label>
                <div class="input-group">
                    <input type="hidden" name="record_member_id" id="record_member_id" value="<cfif isdefined('attributes.record_member_id') and len(attributes.record_member_id)><cfoutput>#attributes.record_member_id#</cfoutput></cfif>">
                    <input type="text" name="record_member" placeholder="<cf_get_lang dictionary_id='57734.Seciniz'>" id="record_member" onFocus="AutoComplete_Create('record_member','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_member_id','','3','100');" value="<cfoutput>#decodeForHTML(attributes.record_member)#</cfoutput>" autocomplete="off">	
                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.record_member_id&field_name=form.record_member&is_form_submitted=1&select_list=1');" ></span>
                </div>
            </div>
            <div class="form-group"  id="item-record_date">
                <label><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></label>
                <div class="input-group">
                    <cfsavecontent variable="placeholder"><cf_get_lang dictionary_id='57734.Seciniz'></cfsavecontent>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerlerini Kontrol Ediniz'>!</cfsavecontent>
                    <cfinput type="text" name="record_date" id="record_date" placeholder="#placeholder#" validate="#validate_style#" value="#dateformat(attributes.record_date,dateformat_style)#" message="#message#" maxlength="10">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
                </div>
            </div>
        </div>
        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group" id="item-ana_sayfa">
                <label><input type="checkbox" name="ana_sayfa" id="ana_sayfa" <cfif isdefined("attributes.ana_sayfa")> checked</cfif>><cf_get_lang dictionary_id ='50532.Anasayfa'></label>
                <label><input type="checkbox" name="ana_sayfayan" id="ana_sayfayan" value="" <cfif isdefined("attributes.ana_sayfayan")> checked</cfif>><cf_get_lang dictionary_id ='50533.Anasayfa Yanı'></label>
                <label><input type="checkbox" name="bolum_basi" id="bolum_basi" value="" <cfif isdefined("attributes.bolum_basi")> checked</cfif>><cf_get_lang dictionary_id ='50534.Kategori Başı'></label>
                <label><input type="checkbox" name="bolum_yan" id="bolum_yan" value="" <cfif isdefined("attributes.bolum_yan")> checked</cfif>><cf_get_lang dictionary_id ='50535.Kategori Yanı'></label>
                <label><input type="checkbox" name="ch_bas" id="ch_bas" value="" <cfif isdefined("attributes.ch_bas")> checked</cfif>><cf_get_lang dictionary_id ='50536.Bölüm Başı'></label>
                <label><input type="checkbox" name="ch_yan" id="ch_yan" value="" <cfif isdefined("attributes.ch_yan")> checked</cfif>><cf_get_lang dictionary_id ='50537.Bölüm Yanı'></label>
                <label><input type="checkbox" name="none_tree" id="none_tree" <cfif isdefined("attributes.none_tree")> checked</cfif>><cf_get_lang dictionary_id ='50538.Bölüm İçerisinde Gösterme'></label>
                <label><input type="checkbox" name="is_viewed" id="is_viewed" <cfif isdefined("attributes.is_viewed")> checked</cfif>><cf_get_lang dictionary_id='50541.Anasayfada Duyur'></label>
            </div>
        </div>
        <cfif isdefined('x_is_show_meta_descriptions') and (x_is_show_meta_descriptions eq 1)>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12"  type="column" index="4" sort="true">
                <cf_seperator title="#getLang('','Meta Tanımlar','32472')#" id="sep">
                <div id="sep" >
                    <div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='58983.Meta Başlığı'></label>
                        <cfinput type="text" name="meta_title" id="meta_title" value="#attributes.meta_title#">
                    </div>
                    <div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='58993.Meta Tanımı'></label>
                        <cfinput type="text" name="meta_head" id="meta_head" value="#attributes.meta_head#">
                    </div>
                    <div class="form-group col col-4 col-md-4 col-sm-6 col-xs-12">
                        <label><cf_get_lang dictionary_id='58994.Meta Anahtar Kelimeleri'></label>
                        <cfinput type="text" name="meta_keyword" id="meta_keyword" value="#attributes.meta_keyword#">
                    </div>
                </div>
            </div>
        </cfif>
    </cf_box_search_detail>

</cfform>
