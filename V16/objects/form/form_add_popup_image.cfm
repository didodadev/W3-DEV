<!---
    File: form_add_popup_image.cfm
    Folder: V16\objects\form\
	Controller:
    Author:
    Date:
    Description:
        Ürün resim yükleme popup sayfası
    History:
        2019-12-31 00:06:33 Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
        Görsel düzenlemeler yapıldı
    To Do:

--->

<cfset getComponent = createObject('component','cfc.wrk_images')>
<cfparam name="attributes.detail" default="">
<cfif attributes.type eq "product">
    <cf_xml_page_edit fuseact="product.form_add_popup_image">
    <cfinclude template="../../objects/display/imageprocess/imcontrol.cfm">
    <cfset getStocks = getComponent.GET_STOCKS(stocksId:attributes.id)>
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.id)>
    <cfset session.resim=3>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor'>!</b></font></div></cfsavecontent>
    <cfset form_title="#getLang('product',124)#">
<cfelseif attributes.type eq "content">
    <cfset form_title="#getLang('content',54)#">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.contentId)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor'>!</b></font></div></cfsavecontent>
<cfelseif attributes.type eq "training">
    <cfset form_title="#getLang('content',54)#">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.class_id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor'>!</b></font></div></cfsavecontent>
<cfelseif attributes.type eq "train_subject">
    <cfset form_title="#getLang('content',54)#">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.train_id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor'>!</b></font></div></cfsavecontent>
<cfelseif attributes.type eq "sample">
    <cfset form_title="#getLang('content',54)#">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.product_sample_id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor'>!</b></font></div></cfsavecontent>
    <cfelseif attributes.type eq "train_group">
    <cfset form_title="#getLang('content',54)#">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.train_group_id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor'>!</b></font></div></cfsavecontent>
</cfif>
<cf_box title="#form_title#" right_images="#right_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="gonderform" action="#request.self#?fuseaction=objects.emptypopup_add_image&type=#attributes.type#" method="post" enctype="multipart/form-data">
        <cf_box_elements vertical="1">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cfif attributes.type eq "product">
                    <input type="hidden" name="image_action_id" id="image_action_id" value="<cfoutput>#attributes.id#</cfoutput>">
                    <input type="hidden" name="image_type" id="image_type" value="<cfoutput>#attributes.type#</cfoutput>">
                <cfelseif attributes.type eq "content">
                    <input type="hidden" name="process_id" id="process_id" value="<cfoutput>#attributes.contentId#</cfoutput>">
                    <input type="hidden" name="up_type" id="up_type" value="img">
                <cfelseif attributes.type eq "sample">
                    <input type="hidden" name="product_sample_id" id="product_sample_id" value="<cfoutput>#attributes.product_sample_id#</cfoutput>">
                    <input type="hidden" name="up_type" id="up_type" value="img">
                <cfelseif attributes.type eq "training">
                    <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
                    <input type="hidden" name="up_types" id="up_types" value="img">
                <cfelseif attributes.type eq "train_subject">
                    <input type="hidden" name="train_id" id="train_id" value="<cfoutput>#attributes.train_id#</cfoutput>">
                    <input type="hidden" name="up_typs" id="up_typs" value="imgs">
                <cfelseif attributes.type eq "train_group">
                    <input type="hidden" name="train_group_id" id="train_group_id" value="<cfoutput>#attributes.train_group_id#</cfoutput>">
                    <input type="hidden" name="up_typ" id="up_typ" value="im">
                </cfif>
                <cfif attributes.type eq "product">
                <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58079.İnternet'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_internet" id="is_internet" checked value="1"></div>
                    </div>
                </cfif>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="language_id" id="language_id">
                            <cfoutput query="getLanguage">
                                <option value="#language_short#">#language_set#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50608.İçerik Yönetimi'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='50608.İmaj Adı !'></cfsavecontent>
                        <cfinput type="text" name="image_name" id="image_name" required="yes" message="#message#" maxlength="250" value="#attributes.detail#">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="File" name="image_file" id="image_file"/></div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="29761.URL">*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="image_url_link" id="image_url_link"></div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="33506.Video Link">Embed</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="video_link" id="video_link"></div>
                </div>
                <!--- xml deki stoga resim eklensin parametresi --->
                <cfif attributes.type eq "product">
                    <cfif is_stock_picture><!--- Sadece urun altindan ekleniyorsa stoklar gelsin --->
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57452.Main'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="stock_id" id="stock_id" multiple>
                                <cfoutput query="getStocks">
                                    <option value="#stock_id#">#stock_code#-#property#</option>
                                </cfoutput>
                            </select>								
                        </div>
                    </div>	
                    </cfif>	
                </cfif>
                <div class="form-group"> 
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><textarea name="detail" id="detail" maxlength="2000"></textarea></div>
                </div>			
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="radio" name="size" id="size0" value="0" checked><label><cf_get_lang dictionary_id='57927.Küçük'></label>
                        <input type="radio" name="size" id="size1" value="1"><label><cf_get_lang dictionary_id='57928.Orta'></label>
                        <input type="radio" name="size" id="size2" value="2"><label><cf_get_lang dictionary_id='57929.Büyük'></label>
                        <input type="radio" name="size" id="size3" value="3"><label><cf_get_lang dictionary_id='58029.İkon'>- <cf_get_lang dictionary_id='58637.Logo'></label>
                    </div>
                </div>
                </div>
        </cf_box_elements>
        <cfset session.imPath = "#upload_folder#product#dir_seperator#">
        <cfif attributes.type eq "product"> 
            <cfset session.module = "product">
        <cfelseif attributes.type eq "content">
            <cfset session.module = "content">
        </cfif>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="control()">
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
	function control()
	{
        <cfif isDefined("attributes.image_file")  and len(attributes.image_file) eq 1> 
            if(document.getElementById('size0').checked == false && document.getElementById('size1').checked == false && document.getElementById('size2').checked == false && document.getElementById('size3').checked == false)
            {
                alert("<cf_get_lang dictionary_id='58194.Girilmesi Zorunlu Alan'>: <cf_get_lang dictionary_id='57713.Boyut'>");
                return false;
            }
        </cfif>
        <cfif isDefined("attributes.draggable")>
            loadPopupBox('gonderform' , <cfoutput>#attributes.modal_id#</cfoutput>)
            return false;
        </cfif>
	}
</script>