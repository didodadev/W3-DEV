<cfinclude template="../query/get_content_property.cfm">
<cfinclude template="../query/get_main_menus.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_customer_cat.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="add_banner" method="post" action="#request.self#?fuseaction=content.emptypopup_add_banner" enctype="multipart/form-data">
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
                    <div class="form-group" id="item-is_active">
                        <input type="checkbox" name="is_active" id="is_active" value="checkbox" checked><cf_get_lang dictionary_id='57493.Aktif'>
                    </div>
                    <div class="form-group" id="item-is_internet">
                        <input type="Checkbox" name="is_internet" id="is_internet"><cf_get_lang dictionary_id='58079.İnternet'>
                    </div> 
                    <div class="form-group" id="item-is_career">
                        <input type="Checkbox" name="is_career" id="is_career"><cf_get_lang dictionary_id='58030.Kariyer'>
                    </div> 
                    <div class="form-group" id="item-is_login_page">
                        <input type="checkbox" name="is_login_page" id="is_login_page" value="checkbox"><cf_get_lang dictionary_id='50517.Partner Portal Giriş Ekranında Yayımlansın'>
                    </div> 

                    <div class="form-group" id="item-is_login_page_employee">
                        <input type="checkbox" name="is_login_page_employee" id="is_login_page_employee" value="checkbox"><cf_get_lang dictionary_id='50519.Employee Portal Giriş Ekranında Yayımlansın'>
                    </div> 
                    <div class="form-group" id="item-is_homepage">
                        <input type="checkbox" name="is_homepage" id="is_homepage" value="checkbox"><cf_get_lang dictionary_id='50516.Anasayfada Yayımlansın'>
                    </div>  
                </div>
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-banner_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="banner_name" id="banner_name" value="<cfif isdefined("attributes.banner_name")><cfoutput>#Left(attributes.banner_name,50)#</cfoutput></cfif>" maxlength="50" tabindex="7"> 
                        </div>
                    </div>
                    <div class="form-group" id="item-banner">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64847.Desktop Banner'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="banner" id="banner" value="">
                        </div>              
                    </div>  
                    <div class="form-group" id="item-banner_2">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64848.Mobil Banner'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="file" name="banner_2" id="banner_2" value="">
                        </div>              
                    </div>  
                    <div class="form-group" id="item-explanation">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="explanation" id="explanation" tabindex="33"  maxlength="200" onkeyup="return ismaxlength(this);" onblur="return ismaxlength(this);"><cfif isdefined("attributes.explanation")><cfoutput>#attributes.explanation#</cfoutput></cfif></textarea>
                        </div>   
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50575.Yayın Başlangıç'> / <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.Hatalı Veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                            <cfinput type="text" name="start_date"  value="" message="#message#" validate="#validate_style#">
                            <span class="input-group-addon"> <cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.Hatalı Veri'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
                            <cfinput type="text" name="finish_date"  value="" message="#message#" validate="#validate_style#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-language_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="language_id" id="language_id">
                                <cfoutput query="get_language">
                                    <option value="#language_short#">#language_set#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-banner_area_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50510.Banner Bölgesi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="banner_area_id" id="banner_area_id" >
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                <option Value="1">1- <cf_get_lang dictionary_id='50609.Menü Altı Komple'> (<cf_get_lang dictionary_id='52634.Ana Sayfa'>)</option>
                                <option Value="2">2- <cf_get_lang dictionary_id='50611.Sol Sütun Üst'>(2.<cf_get_lang dictionary_id='57992.Bölge'>)</option>
                                <option Value="3">3- <cf_get_lang dictionary_id='50615.Sol Sütun Alt'>(3.<cf_get_lang dictionary_id='57992.Bölge'>)</option>
                                <option Value="4">4- <cf_get_lang dictionary_id='50618.Sağ Sütun Üst'>(4.<cf_get_lang dictionary_id='57992.Bölge'>)</option>
                                <option Value="5">5- <cf_get_lang dictionary_id='50621.Sağ Sütun Alt'></option>
                                <option Value="6">6- <cf_get_lang dictionary_id='50622.Orta Sütun Üst'></option>
                                <option Value="7">7- <cf_get_lang dictionary_id='50626.Orta Sütun Alt'></option>
                                <option Value="8">8- <cf_get_lang dictionary_id='50627.Yanyana'> 1</option>
                                <option Value="9">9- <cf_get_lang dictionary_id='50627.Yanyana'> 2</option>
                                <option Value="10">10- <cf_get_lang dictionary_id='50627.Yanyana'> 3</option>
                                <option Value="11">11- <cf_get_lang dictionary_id='50637.Menü Üst'></option>
                                <option Value="12">12- <cf_get_lang dictionary_id='50650.Gündemdeki Kampanya'></option>
                                <option Value="13">13- <cf_get_lang dictionary_id='50690.Layer Banner'></option>
                                <option Value="14">14- <cf_get_lang dictionary_id='50651.Yanyana Banner'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-banner_width">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57695.Genişlik'>/<cf_get_lang dictionary_id='57696.Yükseklik'> PX</label>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <input type="text" name="banner_width" id="banner_width" value="<cfif isdefined("attributes.banner_width")><cfoutput>#Left(attributes.banner_width,50)#</cfoutput></cfif>" maxlength="150" tabindex="7"> 
                        </div>
                        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">    
                        <input type="text" name="banner_height" id="banner_height" value="<cfif isdefined("attributes.banner_height")><cfoutput>#Left(banner_height,50)#</cfoutput></cfif>" maxlength="150" tabindex="7"> 
                        </div>
                    </div> 
                    <div class="form-group" id="item-back_color">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50682.Arka Plan'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <!--- <input type="text" name="back_color" id="back_color" value="<cfif isdefined("attributes.back_color")><cfoutput>#Left(attributes.back_color,50)#</cfoutput></cfif>" maxlength="150" tabindex="7">  --->
                        <cfif isdefined("attributes.back_color")>
                            <cf_workcube_color_picker name="back_color" id="back_color" value="#Left(attributes.back_color,50)#">
                        <cfelse>
                            <cf_workcube_color_picker name="back_color" id="back_color" value="">
                        </cfif>
                        </div>
                    </div> 
                    <div class="form-group" id="item-sequence">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58577.Sıra'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="sequence" id="sequence" value="<cfif isdefined("attributes.sequence")><cfoutput>#Left(attributes.sequence,50)#</cfoutput></cfif>" maxlength="150" tabindex="7"> 
                        </div>
                    </div> 
                    <div class="form-group" id="item-banner_target">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50652.Pencere Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="banner_target" id="banner_target">
                                <option value="_self"><cf_get_lang dictionary_id='59207.Normal'></option>
                                <option value="_blank"><cf_get_lang dictionary_id='64551.Yeni Sekme'></option>
                                <option value="popup"><cf_get_lang dictionary_id='64550.Popup'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-banner_property_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50617.İçerik Tipi'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="banner_property_id" id="banner_property_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> 
                                    <cfoutput query="get_content_property">
                                        <option value="#content_property_id#">#name#                      
                                    </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-date_">
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
                    <div class="form-group" id="item-url">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29761.URL'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="url" id="url" value="<cfif isdefined("attributes.url")><cfoutput>#Left(attributes.url,50)#</cfoutput></cfif>" maxlength="150" tabindex="7"> 
                        </div>
                    </div> 
                    <div class="form-group" id="item-url_path">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50683.URL Path'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="url_path" id="url_path" value="<cfif isdefined("attributes.url_path")><cfoutput>#Left(attributes.url_path,50)#</cfoutput></cfif>" maxlength="150" tabindex="7"> 
                        </div>
                    </div>
                </div> 
                <div class="col col-5 col-md-5 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-partner_portal">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51587.Partner Portal'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_multiselect_check 
                            name="COMPANYCAT_ID"
                            query_name="get_partner"
                            option_name="DOMAIN"
                            option_value="SITE_ID">
                        </div>
                    </div>
                    <div class="form-group" id="item-public_portal">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47840.Public Portal'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_multiselect_check 
                            name="CONSCAT_ID"
                            query_name="get_public"
                            option_name="DOMAIN"
                            option_value="SITE_ID">
                        </div>
                    </div> 
                    <div class="form-group" id="item-carrier_portal">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47835.Kariyer Portal'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_multiselect_check 
                            name="CARRIER_ID"
                            query_name="get_carrier"
                            option_name="DOMAIN"
                            option_value="SITE_ID">
                        </div>
                    </div> 
                    <div class="form-group" id="item-menu_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50518.Özel Site'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfset get_protein_sites = createObject('component','AddOns.Yazilimsa.Protein.cfc.siteMethods').GET_SITES()>
                            <select name="menu_id" id="menu_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                <!--- <cfoutput query="get_main_menus">
                                    <option Value="#menu_id#">#menu_name#</option>
                                </cfoutput> --->
                                <cfoutput query="get_protein_sites">
                                    <option Value="#site_id#">#DOMAIN#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 

                    <cf_duxi name="contentcat_id" type="hidden" id="contentcat_id"> 
                    <cf_duxi name="contentcat_name" id="contentcat_name" label="57486" hint="Kategori" threepoint="#request.self#?fuseaction=content.popup_list_content_cat&id=add_banner.contentcat_id&alan=add_banner.contentcat_name" >      

                    <cf_duxi name="chapter_id" type="hidden" id="chapter_id">
                    <cf_duxi name="chapter_name" id="chapter_name" label="57995" hint="Bölüm" threepoint="#request.self#?fuseaction=content.popup_list_chapter&id=add_banner.chapter_id&alan=add_banner.chapter_name" >

                    <cf_duxi name="content_id" type="hidden" id="content_id">
                    <cf_duxi name="content_name" id="content_name" label="57653" hint="İçerik" threepoint="#request.self#?fuseaction=objects.popup_list_content_relation&content=add_banner.content_id&content_name=add_banner.content_name" >

                    <div class="form-group" id="item-campaign_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'> <cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="campaign_id" id="campaign_id">
                                <input type="text" name="camp_name" tabindex="62" id="camp_name" readonly="yes">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=add_banner.campaign_id&field_name=add_banner.camp_name','list','popup_list_ims_code');return false"></span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-banner_productcat_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'> <cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="banner_productcat_id" id="banner_productcat_id">
                                <input type="text" name="product_cat" tabindex="62" id="product_cat" readonly="yes">
                                <span class="input-group-addon btnPointer icon-ellipsis" 
                                onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=add_banner.banner_productcat_id&field_name=add_banner.product_cat')"></span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-banner_product_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> <cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="banner_product_id" id="banner_product_id">
                                <input type="text" name="product_name" tabindex="62" id="product_name" readonly="yes">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_banner.banner_product_id&field_name=add_banner.product_name')"></span>
                        </div>
                        </div>
                    </div> 
                    <div class="form-group" id="item-banner_brand_id">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'> <cfif session.ep.our_company_info.sales_zone_followup eq 1> *</cfif></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="banner_brand_id" id="banner_brand_id">
                                <input type="text" name="brand_name" tabindex="62" id="brand_name">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=add_banner.banner_brand_id&brand_name=add_banner.brand_name')"></span>
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
                                width="99%"
                                height="380"> 
                         </div>
                    </div>
                </cf_box_elements>
            </div> 
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_box_footer>
                            <cf_workcube_buttons is_upd='0' add_function='control()'>
                </cf_box_footer>
            </div>
        </cf_tab>
        </cf_box>
    </cfform>
</div>
<script type="text/javascript">
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
		if ((obj == "") || !((obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'swf') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpeg') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.length).toLowerCase() == 'png')))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='64847.Desktop Banner'>!");        
			return false;
		}
        var obj_2 =  document.getElementById('banner_2').value;		
		if ((obj_2 == "") || !((obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'swf') || (obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'jpeg') || (obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'jpg')   || (obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'gif') || (obj_2.substring(obj_2.indexOf('.')+1,obj_2.length).toLowerCase() == 'png')))
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='64848.Mobil Banner'>!");        
			return false;
		}
	}
</script>
