<cfset getComponent = createObject('component','cfc.wrk_images')>
<cfparam name="attributes.detail" default="">
<cfif attributes.type eq "product">
    <cf_xml_page_edit fuseact="product.form_add_popup_image">
    <cfinclude template="../../../../V16/objects/display/imageprocess/imcontrol.cfm">
    <cfset getStocks = getComponent.GET_STOCKS(stocksId:attributes.id)>
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.id)>
    <cfset session.resim=3>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>İmaj Upload Ediliyor</b></font></div></cfsavecontent>
    <cfset form_title="Resim Ekle">
<cfelseif attributes.type eq "brand">
    <cfset form_title="Parça İçin Resim Ekle">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.Id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>İmaj Upload Ediliyor!!</b></font></div></cfsavecontent>
<cfelseif attributes.type eq "brand">
    <cfset form_title="Parça İçin Resim Ekle">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.Id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>İmaj Upload Ediliyor!!</b></font></div></cfsavecontent>
<cfelseif attributes.type eq "package">
    <cfset form_title="Paket İçin Resim Ekle">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.Id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>İmaj Upload Ediliyor!!</b></font></div></cfsavecontent>
<cfelseif attributes.type eq "lift_sub">
    <cfset form_title="Alt Gurup İçin Resim Ekle">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.Id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>İmaj Upload Ediliyor!!</b></font></div></cfsavecontent>
<cfelseif attributes.type eq "lift_offer">
    <cfset form_title="Sanal Teklif İçin Resim Ekle">
    <cfset getLanguage = getComponent.GET_LANGUAGE(stocksId:attributes.Id)>
    <cfsavecontent variable="right_"><div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>İmaj Upload Ediliyor!!</b></font></div></cfsavecontent>
</cfif>
<cf_popup_box title="#form_title#" right_images="#right_#">
    <cfform name="gonderform" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_image&type=#attributes.type#" method="post" enctype="multipart/form-data">
        <table>
       		<input type="hidden" name="image_action_id" id="image_action_id" value="<cfoutput>#attributes.id#</cfoutput>">
        	<input type="hidden" name="image_type" id="image_type" value="<cfoutput>#attributes.type#</cfoutput>">
            <cfif attributes.type eq "product">
                <tr>
                    <td colspan="2"></td>
                    <td><input type="checkbox" name="is_internet" id="is_internet" checked value="1"><cf_get_lang_main no='667.İnternet'></td>
                </tr>
            </cfif>
            <cfif attributes.type eq "lift_offer">
                <cfinput name="lift_default_id" type="hidden" value="#attributes.lift_default_id#">
            </cfif>
            <tr>
                <td colspan="2"><cf_get_lang_main no='1584.Dil'></td>
                <td>
                    <select name="language_id" id="language_id" style="width:60px; height:20px">
                        <cfoutput query="getLanguage">
                            <option value="#language_short#">#language_set#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2"><cfoutput>#getLang('content',109,'imaj adı')#</cfoutput>*</td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:109.İmaj Adı !</cfsavecontent>
                    <cfinput type="text" name="image_name" id="image_name" required="yes" message="#message#" style="width:200px;" maxlength="250" value="#attributes.detail#">
                </td>
            </tr>
            <tr>
                <td colspan="2"><cf_get_lang_main no='668.Resim'> *</td>
                <td><input type="File" name="image_file" id="image_file" onfocus="select_radio(1)" style="width:200px;"/></td>
            </tr>
            <tr>
                <td colspan="2"><cf_get_lang_main no="1964.URL">*</td>
                <td><input type="text" name="image_url_link" id="image_url_link" onfocus="select_radio(2)" style="width:200px;"></td>
                <td><input type="checkbox" name="video_link" id="video_link"></td>
                <td><label>Video Link</label></td>
            </tr>
            <!--- xml deki stoga resim eklensin parametresi --->
            <cfif attributes.type eq "product">
                <cfif is_stock_picture><!--- Sadece urun altindan ekleniyorsa stoklar gelsin --->
                <tr>
                    <td colspan="2" style="vertical-align:top;"><cf_get_lang_main no='40.Main'></td>
                    <td>
                        <select name="stock_id" id="stock_id" style="width:200px; height:70px;" multiple>
                            <cfoutput query="getStocks">
                                <option value="#stock_id#">#stock_code#-#property#</option>
                            </cfoutput>
                        </select>								
                    </td>
                </tr>	
                </cfif>	
            </cfif>
            <tr> 
                <td colspan="2" style="vertical-align:top"><cf_get_lang_main no='217.Açıklama'></td>
                <td><textarea name="detail" id="detail" style="width:200px;height:60px;"></textarea></td>
            </tr>			
            <tr>
                <td colspan="2"><cf_get_lang_main no='301.Boyut'></td>
                <td>
                    <input type="radio" name="size" id="size0" value="0"><cf_get_lang_main no='515.Küçük'>
                    <input type="radio" name="size" id="size1" value="1"><cf_get_lang_main no='516.Orta'>
                    <input type="radio" name="size" id="size2" value="2"><cf_get_lang_main no='517.Büyük'>
                </td>
            </tr>
        </table>
        <cfset session.imPath = "#upload_folder#product#dir_seperator#">
        <cfif attributes.type eq "product"> 
            <cfset session.module = "product">
        <cfelseif attributes.type eq "brand">
            <cfset session.module = "brand">
       	<cfelseif attributes.type eq "package">
            <cfset session.module = "package">
       	<cfelseif attributes.type eq "lift_sub">
            <cfset session.module = "brand">
       	<cfelseif attributes.type eq "lift_offer">
            <cfset session.module = "brand">
        </cfif>
        <cf_popup_box_footer>
            <cfinput type="submit" name="image_button" value="#getLang('main',170)#" onClick="control()">
        </cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
	function control()
	{
		if(document.getElementById('size0').checked == false && document.getElementById('size1').checked == false && document.getElementById('size2').checked == false)
		{
			alert("<cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>: <cf_get_lang_main no='301.Boyut'>");
			return false;
		}
        x = (100 - document.getElementById('detail').value.length);
		if ( x < 0 )
		{ 
			alert ("Açıklama Alanı Uzun !"+ ((-1) * x) +"");
			return false;
		}
		return true;
	}
	function select_radio(selected)
	{
		document.getElementById('image_file_type'+selected).checked = true;
	}

</script>
