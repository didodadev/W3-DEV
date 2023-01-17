<cfquery name="GET_BANNERS" datasource="#DSN#">
	SELECT 
		BANNER_ID, 
		IS_ACTIVE, 
		IS_FLASH, 
		IS_HOMEPAGE, 
		IS_LOGIN_PAGE, 
		IS_LOGIN_PAGE_EMPLOYEE, 
		BANNER_NAME, 
		START_DATE, 
		FINISH_DATE, 
		BANNER_FILE, 
		BANNER_SERVER_ID, 
		URL, 
		URL_PATH, 
		BANNER_WIDTH, 
		BANNER_HEIGHT, 
		DETAIL, 
		BANNER_AREA_ID, 
		MENU_ID, 
		BANNER_PROPERTY_ID, 
		BANNER_TARGET, 
		CONTENTCAT_ID, 
		BANNER_PRODUCTCAT_ID, 
		CHAPTER_ID, 
		BANNER_BRAND_ID, 
		CONTENT_ID, 
		BANNER_PRODUCT_ID, 
		BANNER_CAMPAIGN_ID, 
		BACK_COLOR ,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE,
        LANGUAGE,
        SEQUENCE,
        CONTENT,
        MOBILE_BANNER_FILE
	FROM 
		CONTENT_BANNERS 
	WHERE 
		BANNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.banner_id#">
</cfquery>

<cfquery name="GET_BANNER_USERS" datasource="#DSN#">
	SELECT 
		BANNER_ID, 
		COMPANYCAT_ID, 
		CONSCAT_ID, 
		IS_INTERNET, 
		IS_CAREER,
        CARRIER_ID
	FROM 
		CONTENT_BANNERS_USERS 
	WHERE 
		BANNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.banner_id#">
</cfquery>
<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_banner_users.companycat_id,',')),'numeric','ASC',',')>
<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_banner_users.conscat_id,',')),'numeric','ASC',',')>
<cfset carrier_id_list = listsort(listdeleteduplicates(valuelist(get_banner_users.carrier_id,',')),'numeric','ASC',',')>

<cfquery name="GET_INTERNET" dbtype="query">
	SELECT IS_INTERNET FROM GET_BANNER_USERS WHERE IS_INTERNET = 1
</cfquery>
<cfquery name="GET_CAREER" dbtype="query">
	SELECT IS_CAREER FROM GET_BANNER_USERS WHERE IS_CAREER = 1
</cfquery>
<cfquery name="GET_LANGUAGE" datasource="#DSN#">
        SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery>
<cfinclude template="../query/get_main_menus.cfm">
<cfinclude template="../query/get_content_property.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_customer_cat.cfm">
<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfform name="upd_banner" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=content.emptypopup_upd_banner">
        <input type="hidden" name="banner_id" id="banner_id" value="<cfoutput>#get_banners.banner_id#</cfoutput> ">
            <!--- <cfsavecontent variable="txt"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang no='67.İmaj Upload Ediliyor'>!</b></font></div></cfsavecontent> --->
            <cf_box><!---Banner Ekle--->
                <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2" divLang="Yayın Bilgileri;İçerik;">
                <cfquery name="GET_LANGUAGE" datasource="#DSN#">
                    SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
                </cfquery>
                <cfquery name="get_partner" datasource="#DSN#">
                    SELECT
                        SITE_ID,
                        DOMAIN
                    FROM 
                        PROTEIN_SITES
                     WHERE
                        ACCESS_DATA LIKE '%"COMPANY":{"STATUS":"1"%'
                    AND STATUS = 1
                </cfquery>
                <cfquery name="get_public" datasource="#DSN#">
                    SELECT
                        SITE_ID,
                        DOMAIN
                    FROM 
                        PROTEIN_SITES
                    WHERE
                        ACCESS_DATA LIKE '%"PUBLIC":{"STATUS":"1"%' 
                    AND STATUS = 1
                </cfquery>
                <cfquery name="get_carrier" datasource="#DSN#">
                    SELECT
                        SITE_ID,
                        DOMAIN
                    FROM 
                        PROTEIN_SITES
                    WHERE
                        ACCESS_DATA LIKE '%"CARIER":{"STATUS":"1"%' 
                    AND STATUS = 1
                </cfquery>
                <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
                <cf_box_elements>
                    <div class="col col-2 col-md-2 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="is_active">
                            <input type="checkbox" name="is_active" id="is_active" value="checkbox" <cfif get_banners.is_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                        </div>
                        <div class="form-group" id="is_internet">
                            <input type="Checkbox" name="is_internet" id="is_internet" <cfif get_internet.recordcount>checked</cfif>><cf_get_lang dictionary_id='58079.İnternet'>
                        </div> 
                        <div class="form-group" id="is_career">
                            <input type="Checkbox" name="is_career" id="is_career" <cfif get_career.recordcount>checked</cfif>><cf_get_lang dictionary_id='58030.Kariyer'>
                        </div> 
                        <div class="form-group" id="is_login_page">
                            <input type="checkbox" name="is_login_page" id="is_login_page" value="checkbox"<cfif get_banners.is_login_page eq 1> checked</cfif>><cf_get_lang dictionary_id='50517.Partner Portal Giriş Ekranında Yayımlansın'>
                        </div> 
    
                        <div class="form-group" id="is_login_page_employee">
                            <input type="checkbox" name="is_login_page_employee" id="is_login_page_employee" value="checkbox"<cfif get_banners.is_login_page_employee EQ 1> checked</cfif>><cf_get_lang dictionary_id='50519.Employee Portal Giriş Ekranında Yayımlansın'>
                        </div> 
                        <div class="form-group" id="is_homepage">
                            <input type="checkbox" name="is_homepage" id="is_homepage" value="checkbox"<cfif get_banners.is_homepage eq 1> checked</cfif>><cf_get_lang dictionary_id='50516.Anasayfada Yayımlansın'>
                        </div>  
                    </div>
                    <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-banner_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="banner_name" id="banner_name" value="#get_banners.banner_name#">
                            </div>
                        </div>
                        <div class="form-group" id="item-banner">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64847.Desktop Banner'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="banner_file" id="banner_file" value="<cfoutput>#get_banners.banner_file#</cfoutput>">
                                    <input type="hidden" name="banner_file_server_id" id="banner_file_server_id" value="<cfoutput>#get_banners.banner_server_id#</cfoutput>">
                                    <cfinput type="file" name="banner" id="banner" value="#get_banners.banner_file#">
                                    <cfif len(get_banners.banner_file)>
                                    <span class="input-group-addon" onClick="windowopen('<cfoutput>#file_web_path#content/banner/#get_banners.banner_file#</cfoutput>','page');"><i class="fa fa-file-image-o"></i></span>
                                    </cfif>
                                </div>
                            </div>              
                        </div>
                        <div class="form-group" id="item-banner_2">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64848.Mobil Banner'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="banner_file_2" id="banner_file_2" value="<cfoutput>#get_banners.MOBILE_BANNER_FILE#</cfoutput>">
                                    <input type="hidden" name="banner_file_server_id_2" id="banner_file_server_id_2" value="<cfoutput>#get_banners.banner_server_id#</cfoutput>">
                                    <cfinput type="file" name="banner_2" id="banner_2" value="#get_banners.MOBILE_BANNER_FILE#">
                                    <cfif len(get_banners.MOBILE_BANNER_FILE)>
                                    <span class="input-group-addon" onClick="windowopen('<cfoutput>#file_web_path#content/banner/#get_banners.MOBILE_BANNER_FILE#</cfoutput>','page');"><i class="fa fa-file-image-o"></i></span>
                                    </cfif>
                                </div>
                            </div>            
                        </div>  
                        <div class="form-group" id="explanation">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="explanation" id="explanation" style="width:150px;height:45px;"><cfoutput>#get_banners.detail#</cfoutput></textarea>
                            </div>   
                        </div>
                        <div class="form-group" id="item-">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50575.Yayın Başlangıç'> / <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.Hatalı Veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                                    <cfinput type="text" name="start_date" id="start_date" value="#dateformat(get_banners.start_date,dateformat_style)#" message="#message#" validate="#validate_style#">
                                <span class="input-group-addon"> <cf_wrk_date_image date_field="start_date"></span>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.Hatalı Veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                                    <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(get_banners.finish_date,dateformat_style)#" message="#message#" validate="#validate_style#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="language_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="language_id" id="language_id">
                                    <cfoutput query="get_language">
                                        <option value="#language_short#" <cfif get_banners.language eq language_short>selected</cfif>>#language_set#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="banner_area_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50510.Banner Bölgesi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="banner_area_id" id="banner_area_id" >
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                    <option Value="1" <cfif get_banners.banner_area_id eq 1>selected</cfif>>1- <cf_get_lang dictionary_id='50609.Menü Altı Komple'> (<cf_get_lang dictionary_id='52634.Ana Sayfa'>)</option>
                                    <option Value="2" <cfif get_banners.banner_area_id eq 2>selected</cfif>>2- <cf_get_lang dictionary_id='50611.Sol Sütun Üst'>(2.<cf_get_lang dictionary_id='57992.Bölge'>)</option>
                                    <option Value="3" <cfif get_banners.banner_area_id eq 3>selected</cfif>>3- <cf_get_lang dictionary_id='50615.Sol Sütun Alt'>(3.<cf_get_lang dictionary_id='57992.Bölge'>)</option>
                                    <option Value="4" <cfif get_banners.banner_area_id eq 4>selected</cfif>>4- <cf_get_lang dictionary_id='50618.Sağ Sütun Üst'>(4.<cf_get_lang dictionary_id='57992.Bölge'>)</option>
                                    <option Value="5" <cfif get_banners.banner_area_id eq 5>selected</cfif>>5- <cf_get_lang dictionary_id='50621.Sağ Sütun Alt'></option>
                                    <option Value="6" <cfif get_banners.banner_area_id eq 6>selected</cfif>>6- <cf_get_lang dictionary_id='50622.Orta Sütun Üst'></option>
                                    <option Value="7" <cfif get_banners.banner_area_id eq 7>selected</cfif>>7- <cf_get_lang dictionary_id='50626.Orta Sütun Alt'></option>
                                    <option Value="8" <cfif get_banners.banner_area_id eq 8>selected</cfif>>8- <cf_get_lang dictionary_id='50627.Yanyana'> 1</option>
                                    <option Value="9" <cfif get_banners.banner_area_id eq 9>selected</cfif>>9- <cf_get_lang dictionary_id='50627.Yanyana'> 2</option>
                                    <option Value="10" <cfif get_banners.banner_area_id eq 10>selected</cfif>>10- <cf_get_lang dictionary_id='50627.Yanyana'> 3</option>
                                    <option Value="11" <cfif get_banners.banner_area_id eq 11>selected</cfif>>11- <cf_get_lang dictionary_id='50637.Menü Üst'></option>
                                    <option Value="12" <cfif get_banners.banner_area_id eq 12>selected</cfif>>12- <cf_get_lang dictionary_id='50650.Gündemdeki Kampanya'></option>
                                    <option Value="13" <cfif get_banners.banner_area_id eq 13>selected</cfif>>13- <cf_get_lang dictionary_id='50690.Layer Banner'></option>
                                    <option Value="14" <cfif get_banners.banner_area_id eq 14>selected</cfif>>14- <cf_get_lang dictionary_id='50651.Yanyana Banner'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="banner_width">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57695.Genişlik'>/<cf_get_lang dictionary_id='57696.Yükseklik'> PX</label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="text" name="banner_width" id="banner_width" value="<cfoutput>#get_banners.banner_width#</cfoutput>">
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">    
                                <input type="text" name="banner_height" id="banner_height" value="<cfoutput>#get_banners.banner_height#</cfoutput>" >
                            </div>
                        </div> 
                        <div class="form-group" id="item-back_color">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50682.Arka Plan'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_color_picker name="back_color" id="back_color" value="#get_banners.back_color#">
                            </div>
                        </div> 
                        <div class="form-group" id="sequence">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58577.Sıra'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="sequence" id="sequuence" value="<cfoutput>#get_banners.sequence#</cfoutput>" onkeyup="isNumber(this)" onblur="isNumber(this)">
                            </div>
                        </div> 
                        <div class="form-group" id="banner_target">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50652.Pencere Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="banner_target" id="banner_target">
                                    <option value="_self" <cfif get_banners.banner_target is "_self">selected</cfif>><cf_get_lang dictionary_id='59207.Normal'></option>
                                    <option value="_blank" <cfif get_banners.banner_target is "_blank">selected</cfif>><cf_get_lang dictionary_id='64551.Yeni Sekme'></option>
                                    <option value="popup" <cfif get_banners.banner_target is "popup">selected</cfif>><cf_get_lang dictionary_id='64550.Popup'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="banner_property_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50617.İçerik Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="banner_property_id" id="banner_property_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                                        <cfoutput query="get_content_property">
                                            <option value="#content_property_id#" <cfif get_banners.banner_property_id is content_property_id>selected</cfif>>#name#
                                        </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-">
                            <cfif isdefined("is_special_period_date") and is_special_period_date eq 1>
                            <div class="form-group" id="item-">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58690.Tarih Aralığı"></label>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
                                        <cfinput validate="#validate_style#" message="#message#" type="text" name="start_date" id="start_date">							
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date">
                                    </div>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'>!</cfsavecontent>
                                    <div class="input-group">
                                        <cfinput validate="#validate_style#" message="#message#" type="text" name="finish_date" id="finish_date">						
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date">
                                    </div>
                                </div>
                            </div>
                            </cfif>
                        </div>
                        <div class="form-group" id="url">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29761.URL'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="url" id="url" value="#get_banners.url#" maxlength="150">
                            </div>
                        </div> 
                        <div class="form-group" id="url_path">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50683.URL Path'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="text" name="url_path" id="url_path" value="#get_banners.url_path#" maxlength="150">
                            </div>
                        </div>
                    </div> 
                    <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="partner_portal">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51587.Partner Portal'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_multiselect_check 
                                name="COMPANYCAT_ID"
                                query_name="get_partner"
                                option_name="DOMAIN"
                                option_value="SITE_ID"
                                value="#company_id_list#">
            
                            </div>
                        </div>
                        <div class="form-group" id="public_portal">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47840.Public Portal'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_multiselect_check 
                                name="CONSCAT_ID"
                                query_name="get_public"
                                option_name="DOMAIN"
                                option_value="SITE_ID"
                                value="#consumer_id_list#">
                                                                
                            </div>
                        </div> 
                        <div class="form-group" id="carrier_portal">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47835.Kariyer Portal'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_multiselect_check 
                                name="CARRIER_ID"
                                query_name="get_carrier"
                                option_name="DOMAIN"
                                option_value="SITE_ID"
                                value="#carrier_id_list#">

                            </div>
                        </div> 
                        <div class="form-group" id="menu_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50518.Özel Site'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfset get_protein_sites = createObject('component','AddOns.Yazilimsa.Protein.cfc.siteMethods').GET_SITES()>
                                <select name="menu_id" id="menu_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                    <!--- <cfoutput query="get_main_menus">
                                        <option Value="#menu_id#" <cfif len(get_banners.menu_id) and get_banners.menu_id eq menu_id>selected</cfif>>#menu_name#</option>
                                    </cfoutput> --->
                                    <cfoutput query="get_protein_sites">
                                        <option Value="#site_id#" <cfif len(get_banners.menu_id) and get_banners.menu_id eq site_id>selected</cfif>>#DOMAIN#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>                  
                                                       
                        <cf_duxi name="contentcat_id" type="hidden" id="contentcat_id"  value="#get_banners.contentcat_id#">                                   
                        <cfif len(get_banners.contentcat_id)>
                            <cfset attributes.contentcat_id = get_banners.contentcat_id>
                            <cfinclude template="../query/get_content_cat_name.cfm">
                            <cf_duxi name="contentcat_name" id="contentcat_name" label="57486" hint="Kategori" value="#get_content_cat_name.contentcat#" threepoint="#request.self#?fuseaction=content.popup_list_content_cat&id=upd_banner.contentcat_id&alan=upd_banner.contentcat_name" >                                         
                        <cfelse>
                            <cf_duxi name="contentcat_name" id="contentcat_name" label="57486" hint="Kategori" type="text"  threepoint="#request.self#?fuseaction=content.popup_list_content_cat&id=upd_banner.contentcat_id&alan=upd_banner.contentcat_name">                                        
                        </cfif>  
                        
                        <cf_duxi name="chapter_id" type="hidden" id="chapter_id"  value="#get_banners.chapter_id#">                                
                        <cfif len(get_banners.chapter_id)>
                            <cfset attributes.chpid = get_banners.chapter_id>
                            <cfinclude template="../query/get_chapter_name.cfm">
                            <cf_duxi name="chapter_name" id="chapter_name" label="57995" hint="Bölüm" value="#get_chapter_name.chapter#" threepoint="#request.self#?fuseaction=content.popup_list_chapter&id=upd_banner.chapter_id&alan=upd_banner.chapter_name" >                                    
                        <cfelse>
                            <cf_duxi name="chapter_name" id="chapter_name" label="57995" hint="Bölüm" value="" threepoint="#request.self#?fuseaction=content.popup_list_chapter&id=upd_banner.chapter_id&alan=upd_banner.chapter_name" >
                        </cfif>     
                            
                        <cf_duxi name="content_id" type="hidden" id="content_id"  value="#get_banners.content_ID#">                                    
                        <cfif len(get_banners.Content_ID)>
                            <cfset attributes.Content_ID = get_banners.Content_ID>
                            <cfinclude template="../query/get_content_name.cfm">
                            <cf_duxi name="content_name" id="content_name" label="57653" hint="İçerik" value="#get_content_name.Cont_head#" threepoint="#request.self#?fuseaction=objects.popup_list_content_relation&content=upd_banner.content_id&content_name=upd_banner.content_name" >                                        
                        <cfelse>
                            <cf_duxi name="content_name" id="content_name" label="57653" hint="İçerik" value="" threepoint="#request.self#?fuseaction=objects.popup_list_content_relation&content=upd_banner.content_id&content_name=upd_banner.content_name" >
                        </cfif>      
                      
                        <div class="form-group" id="campaign_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="campaign_id" id="campaign_id" value="<cfoutput>#get_banners.banner_campaign_id#</cfoutput>">
                                    <cfif len(get_banners.banner_campaign_id)>
                                        <cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
                                            SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_banners.banner_campaign_id#">
                                        </cfquery>
                                        <input type="text" name="camp_name" id="camp_name" style="width:150px;" value="<cfoutput>#get_campaign.camp_head#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="camp_name" id="camp_name" style="width:150px;" value="">
                                    </cfif>
                                    <span class="input-group-addon" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=upd_banner.campaign_id&field_name=upd_banner.camp_name');"><i class="icon-ellipsis"></i></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="banner_productcat_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="banner_productcat_id" id="banner_productcat_id" value="<cfoutput>#get_banners.banner_productcat_id#</cfoutput>">
                                    <cfif len(get_banners.banner_productcat_id)>
                                        <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
                                            SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_banners.banner_productcat_id#">
                                        </cfquery>
                                        <input type="text" name="product_cat" id="product_cat" value="<cfoutput>#get_product_cat.product_cat#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="product_cat" id="product_cat" value="">
                                    </cfif>
                                    <span class="input-group-addon" 
                                    onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=upd_banner.banner_productcat_id&field_name=upd_banner.product_cat');"><i class="icon-ellipsis"></i></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="banner_product_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="banner_product_id" id="banner_product_id" value="<cfoutput>#get_banners.banner_product_id#</cfoutput>">
                                    <cfif len(get_banners.banner_product_id)>
                                        <cfquery name="GET_PRODUCT" datasource="#DSN3#">
                                            SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_banners.banner_product_id#">
                                        </cfquery>
                                        <input type="text" name="product_name" id="product_name" <!--- onKeyUp="get_product();" --->  value="<cfoutput>#get_product.product_name#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="product_name" id="product_name" value="" <!--- onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','banner_product_id','','2','200');" ---> autocomplete="off">
                                    </cfif>
                                    <span class="input-group-addon" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_banner.banner_product_id&field_name=upd_banner.product_name');"><i class="icon-ellipsis"></i></span>
                            </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-brand_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="banner_brand_id" id="banner_brand_id" value="<cfoutput>#get_banners.banner_brand_id#</cfoutput>">
                                    <cfif len(get_banners.banner_brand_id)>
                                        <cfquery name="GET_PRODUCT_BRANDS" datasource="#DSN3#">
                                            SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_banners.banner_brand_id#">
                                        </cfquery>
                                        <input type="text" name="brand_name" id="brand_name" value="<cfoutput>#get_product_brands.brand_name#</cfoutput>">
                                    <cfelse>
                                        <input type="text" name="brand_name" id="brand_name" value="">
                                    </cfif>
                                    <span class="input-group-addon" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=upd_banner.banner_brand_id&brand_name=upd_banner.brand_name');"><i class="icon-ellipsis"></i></span>
                                </div>
                            </div>
                        </div> 
                    </div>  
                </cf_box_elements>
                </div>
                <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
                    <cf_box_elements vertical="1">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="5" sort="true">                       
                            <div class="form-group" id="item-editor">
                                <label style="display:none!important;"><cf_get_lang dictionary_id='57653.İçerik'></label>
                                <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="de"
                                    basePath="/fckeditor/"
                                    instancename="CONTENT"
                                    valign="top"
                                    devmode="1"
                                    value="#get_banners.content#"
                                    width="99%"
                                    height="380"> 
                             </div>
                        </div>
                    </cf_box_elements>
                </div> 
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_box_footer>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cf_record_info query_name="get_banners">
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=content.emptypopup_del_banner&banner_id=#attributes.banner_id#&banner_file=#get_banners.banner_file#&banner_file_server_id=#get_banners.banner_server_id#&head=#get_banners.banner_name#' add_function='control()'>
                    </div>
                </cf_box_footer>
                </div>
            </cf_tab>
            </cf_box>
        </cfform>
    </div>

    <script type="text/javascript">
        document.getElementById('upload_status').style.display = 'none';
        function control()
        {	
            tarih1_ = document.getElementById('start_date').value.substr(6,4) + document.getElementById('start_date').value.substr(3,2) + document.getElementById('start_date').value.substr(0,2);
            tarih2_ = document.getElementById('finish_date').value.substr(6,4) + document.getElementById('finish_date').value.substr(3,2) + document.getElementById('finish_date').value.substr(0,2);
            
            if (document.getElementById('banner_name').value == '')
		    {
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57631.Ad'>");        
			return false;	
		    }
            if(tarih1_ != '' & tarih2_ != '' && tarih1_ > tarih2_)
            {
                alert("<cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>");
                return false;			
            } 
            
            var obj =  document.getElementById('banner').value;		
            if ((obj != "") && !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'swf') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png'))){
                alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='64847.Desktop Banner'>!");        
                return false;
            }

            var obj_2 =  document.getElementById('banner_2').value;		
            if ((obj_2 == "") || !((obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'swf') || (obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'jpeg') || (obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'jpg')   || (obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'gif') || (obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'png')))
            {
                alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='64848.Mobil Banner'>!");        
                return false;
            }
            
            document.getElementById('upload_status').style.display = '';
            return true;
        }
    </script>
    