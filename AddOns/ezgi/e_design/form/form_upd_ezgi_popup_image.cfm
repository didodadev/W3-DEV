<cf_xml_page_edit fuseact="product.form_add_popup_image">
<cfset getComponent = createObject('component','cfc.wrk_images')>
<cfif attributes.type eq "brand"><!--- Ürün kategorilerinden Eklenmişse --->
	<cfset table = "EZGI_DESIGN_PIECE_IMAGES">
    <cfset identity_column = "DESIGN_PIECE_ROW_ID">
    <cfset ezgidsn = #dsn3#>
<cfelseif attributes.type eq "product"><!--- Modül İse--->
	<cfset table = "EZGI_DESIGN_MAIN_IMAGES">
    <cfset identity_column = "DESIGN_MAIN_ROW_ID">
    <cfset ezgidsn = #dsn3#>
<cfelseif attributes.type eq "package"><!--- Paket İse --->
	<cfset table = "EZGI_DESIGN_PACKAGE_IMAGES">
    <cfset identity_column = "DESIGN_PACKAGE_ROW_ID">
    <cfset ezgidsn = #dsn3#>
<cfelseif attributes.type eq "lift_sub"><!--- Amortisör İse --->
	<cfset table = "#dsn_alias#.EZGI_LIFT_IMAGES">
    <cfset identity_column = "DESIGN_LIFT_TYPE_ID">
    <cfset ezgidsn = #dsn#>
<cfelseif attributes.type eq "lift_offer"><!--- Amortisör Teklif İse --->
 	<cfset table = "EZGI_LIFT_IMAGES">
  	<cfset identity_column = "ORDER_ROW_ID">
    <cfset ezgidsn = #dsn#>
</cfif>
    <cfquery name="get_image" datasource="#ezgidsn#">
    	SELECT
        	#identity_column#,
            PATH,
     		PATH_SERVER_ID,
          	PRD_IMG_NAME,
          	IMAGE_SIZE,
         	IS_INTERNET,
          	LANGUAGE_ID,
           	UPDATE_DATE,
          	UPDATE_EMP,
        	UPDATE_IP,
        	IS_EXTERNAL_LINK,
         	VIDEO_LINK,
           	VIDEO_PATH,
        	DETAIL
    	FROM
        	#table#
      	WHERE
        	#identity_column# = #attributes.id#	
            <cfif attributes.type eq "lift_offer">
         		AND EZGI_LIFT_IMAGE_DEFAULT_ID = #attributes.lift_default_id#
        	</cfif> 
    </cfquery>
    <cfsavecontent variable="right">
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#get_image.path_server_id#&old_file_name=#get_image.path#&asset_cat_id=-25</cfoutput>','adminTv','wrk_image_editor')"><img src="/images/canta.gif" alt="Edit" border="0"></a>
        <div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang_main no='3004.İmaj Upload Ediliyor'></b></font></div>
    </cfsavecontent>
    <cfset image_name = "#get_image.prd_img_name#">
<cfset getLanguage = getComponent.GET_LANGUAGE()>
<cf_popup_box title="#getLang('main',668)# #getLang('main',52)#" right_images="#right#">
<cfform name="gonderform" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_image&image_action_id=#attributes.id#&image_type=#attributes.type#" method="post" enctype="multipart/form-data">
<table>
    <cfif attributes.type eq "content">
        <input type="hidden" name="process_id" id="process_id" value="<cfoutput>#get_image.CONTENT_ID#</cfoutput>">
        <input type="hidden" name="up_type" id="up_type" value="img">
    </cfif>
    <cfif attributes.type eq "product">
        <tr>
            <td colspan="2"></td>
            <td ><input type="checkbox" name="is_internet" id="is_internet" <cfif get_image.is_internet eq 1> checked</cfif> value="1"><cf_get_lang_main no='667.İnternet'></td>
        </tr>
    </cfif>
    <cfif attributes.type eq "lift_offer">
    	<cfinput name="lift_default_id" type="hidden" value="#attributes.lift_default_id#">
 	</cfif>
    <tr>
        <td colspan="2"><cf_get_lang_main no='1584.Dil'></td>
        <td>
            <select name="language_id" id="language_id" style="width:60px;">
                <cfoutput query="getLanguage">
                    <option value="#language_short#" <cfif get_image.language_id is language_short> selected</cfif>>#language_set#</option>
                </cfoutput>
            </select>
        </td>
    </tr>
    <tr>
        <td colspan="2"><cfoutput>#getLang('content',109,'imaj adı')#</cfoutput>*</td>
        <td>
            <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang_main no='1965.İmaj'> <cf_get_lang_main no='485.Adı'> !</cfsavecontent>
            <cfinput type="text" name="image_name" id="image_name" required="yes" message="#message#" style="width:200px;" maxlength="250" value="#image_name#">
        </td>
    </tr>
    <tr>
        <td colspan="2"><cf_get_lang_main no='668.Resim'> *</td>
        <td><input type="File" name="image_file" id="image_file" onfocus="select_radio(1)" style="width:200px;"></td>
    </tr>
    <tr>
        <td colspan="2"></td>
        <td colspan="4"><cfoutput>#get_image.path#</cfoutput></td>
    </tr>
    <tr>
        <td colspan="2"><cf_get_lang_main no="1964.URL">*</td>
        <td><input type="text" name="image_url_link" id="image_url_link" value="<cfif isdefined("get_image.VIDEO_PATH") and len(get_image.VIDEO_PATH)><cfoutput>#get_image.VIDEO_PATH#</cfoutput></cfif>" onfocus="select_radio(2)" style="width:200px;"></td>
        <td><input type="checkbox" name="video_link" id="video_link" <cfif GET_IMAGE.VIDEO_LINK eq 1>checked="checked"</cfif>></td>
        <td>Video Link</td>
    </tr>                    
    <tr>
        <td colspan="2" style="vertical-align:top"><cf_get_lang_main no='217.Açıklama'></td>
        <td><textarea name="detail" id="detail" style="width:200px;height:60px;" ><cfoutput>#get_image.detail#</cfoutput></textarea></td>
    </tr>

    <tr>
        <td colspan="2"><cf_get_lang_main no='301.Boyut'></td>
        <td>
            <input type="radio" name="size" id="size" value="0" <cfif get_image.image_size eq 0> checked</cfif>><cf_get_lang_main no='515.Küçük'>
            <input type="radio" name="size" id="size" value="1" <cfif get_image.image_size eq 1> checked</cfif>><cf_get_lang_main no='516.Orta'>
            <input type="radio" name="size" id="size" value="2" <cfif get_image.image_size eq 2> checked</cfif>><cf_get_lang_main no='517.Büyük'>
        </td>
    </tr>
</table>
<cfset session.imPath = "#upload_folder#product#dir_seperator#">
<cfset session.module = "product">
<cf_popup_box_footer>
<table width="99%">
	<tr>
    	<td>
        	<cfif len(get_image.update_emp)>
                <cf_get_lang_main no='479.Güncelleyen'>: 
                <cfset temp_update = dateadd('h',session.ep.time_zone,get_image.update_date)>
                <cfoutput>#get_emp_info(get_image.update_emp,0,0)# - 
                #dateformat(temp_update,dateformat_style)#</cfoutput>
            </cfif>
        </td>
        <td style="text-align:right;">
        	<cfinput type="button" name="del_button" value="#getLang('main',51)#" style="background-color:red" onClick="del_control()">&nbsp;&nbsp;
            <cfinput type="submit" name="upd_button" value="#getLang('main',52)#" onClick="upd_control()">&nbsp;
        </td>
    </tr>
</table>
</cf_popup_box_footer>	
</cfform>
</cf_popup_box>
<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
	function go()
	{	   
	   if(control())
		   document.gonderform.submit();
	}
	
	function upd_control()
	{	
		if(document.getElementById('image_file_type1').checked == true)
		{
			var obj =  document.getElementById('image_file').value;
			if ((obj != "") && (!((obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'png')))){
				alert("<cf_get_lang_main no='3042.Lütfen bir resim dosyası (gif, jpg veya png) giriniz!'>");        
				return false;
			}
			<cfif  GET_IMAGE.IS_EXTERNAL_LINK eq 1>
			if(obj == "")
			{
				alert("<cf_get_lang_main no='2859.Dosya Seçiniz'> !");
				return false;
			}
			</cfif>
			document.getElementById('upload_status').style.display = '';
			return true;
		}
		else if(document.getElementById('image_file_type2').checked ==true)
		{
			if(trim(document.getElementById('image_url_link').value) =="")
			{
				alert("<cf_get_lang_main no='2139.URL Giriniz'> !");
				return false;
			}
		}
	}
	function del_control()
	{
		sor=confirm('<cf_get_lang_main no='121.Silmek İstediğinizden Emin Misiniz?'>');
		if(sor==true)
			window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_del_ezgi_image&image_action_id=#attributes.id#&image_type=#attributes.type#<cfif attributes.type eq 'lift_offer'>&lift_default_id=#attributes.lift_default_id#</cfif></cfoutput>";
		else
			return false;
	}
	function select_radio(selected)
	{
		if(selected == 1)
		document.getElementById('image_url_link').value='';
		
		document.getElementById('image_file_type'+selected).checked = true;
	}

</script>
