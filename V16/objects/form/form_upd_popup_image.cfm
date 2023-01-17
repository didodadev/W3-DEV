<cf_xml_page_edit fuseact="product.form_add_popup_image">
<cfparam name="table" default="">
<cfparam name="identity_column" default="">
<cfparam name="datasource" default="#dsn1#">
<cfset getComponent = createObject('component','cfc.wrk_images')>
<cfif attributes.type eq "brand"><!--- Ürün kategorilerinden Eklenmişse --->
	<cfset table = "PRODUCT_BRANDS_IMAGES">
    <cfset identity_column = "BRAND_IMAGEID">
<cfelseif attributes.type eq "product"><!--- Ürün den eklenmişse --->
	<cfset table = "PRODUCT_IMAGES">
    <cfset identity_column = "PRODUCT_IMAGEID">
</cfif>
<cfif attributes.type eq "product">
    <cfset get_image = getComponent.GET_IMAGE_(table:table,identity_column:identity_column,action_id:attributes.action_id)>
    <cfsavecontent variable="right">
      <li> <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_image_editor&old_file_server_id=#get_image.path_server_id#&old_file_name=#get_image.path#&asset_cat_id=-25</cfoutput>','adminTv','wrk_image_editor')"><i class="fa fa-edit" alt="Edit"></i></a>
      </li>
        <div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><cf_get_lang no='125.İmaj Upload Ediliyor!!'></b></font></div>
    </cfsavecontent>
   
    <cfset image_name = "#get_image.prd_img_name#">
<cfelseif attributes.type eq "content">
    <cfset identity_column = "CONTIMAGE_ID">
	<cfset table = "CONTENT_IMAGE">
    <cfset datasource = "#dsn#">
    <cfset get_image = getComponent.GET_IMAGE_CONTENT(action_id:attributes.action_id)>
    <cfsavecontent variable="right">
        <div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
        <b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor!!'></b></font></div>
    </cfsavecontent>
    <cfset image_name = "#get_image.cnt_img_name#">
<cfelseif attributes.type eq "training">
    <cfset identity_column = "CLASS_ID">
    <cfset table = "TRAINING_CLASS">
    <cfset datasource = "#dsn#">
    <cfset get_image = getComponent.GET_TRAINING_CLASS_IMG()>
    <cfsavecontent variable="right">
        <div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
        <b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor!!'></b></font></div>
    </cfsavecontent>
    <cfset image_name = "#get_image.name#">
<cfelseif attributes.type eq "train_subject">
    <cfset identity_column = "TRAIN_ID">
    <cfset table = "TRAINING">
    <cfset datasource = "#dsn#">
    <cfset get_image = getComponent.GET_TRAINING_SUBJECT_IMG()>
    <cfsavecontent variable="right">
        <div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
        <b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor!!'></b></font></div>
    </cfsavecontent>
    <cfset image_name = "#get_image.name#">
<cfelseif attributes.type eq "train_group">
    <cfset identity_column = "TRAIN_GROUP_ID">
    <cfset table = "TRAINING_CLASS_GROUPS">
    <cfset datasource = "#dsn#">
    <cfset get_image = getComponent.GET_TRAINING_CLASS_GROUPS_IMG()>    
    <cfsavecontent variable="right">
        <div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
        <b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor!!'></b></font></div>
    </cfsavecontent>
    <cfset image_name = "#get_image.name#">
<cfelseif attributes.type eq "sample">
    <cfset identity_column = "product_sample_image_id">
    <cfset table = "PRODUCT_SAMPLE_IMAGE">
    <cfset datasource = "#dsn3#">
    <cfset get_image = getComponent.GET_PRODUCT_SAMPLE_IMG(action_id:attributes.action_id)>    
    <cfsavecontent variable="right">
        <div id="upload_status"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
        <b><cf_get_lang dictionary_id='37136.İmaj Upload Ediliyor!!'></b></font></div>
    </cfsavecontent>
    <cfset image_name = "#get_image.name#">
</cfif>

<cfif attributes.type eq "product"><!--- Ürün den eklenmişse --->
    <cfset getStocks = getComponent.GET_STOCKS(stocksId:get_image.product_id)>
</cfif>
<cfset getLanguage = getComponent.GET_LANGUAGE()>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','İmaj Güncelle',37075)#" right_images="#right#" draggable="1" closable="1" popup_box="1">
    <cfform name="gonderform" action="#request.self#?fuseaction=objects.emptypopup_upd_image&image_action_id=#attributes.action_id#&image_type=#attributes.type#" method="post" enctype="multipart/form-data">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cfif attributes.type eq "content">
                    <input type="hidden" name="process_id" id="process_id" value="<cfoutput>#get_image.CONTENT_ID#</cfoutput>">
                    <input type="hidden" name="up_type" id="up_type" value="img">
                </cfif>
                <cfif attributes.type eq "product">
                    <div class="form-group">
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><input type="checkbox" name="is_internet" id="is_internet" <cfif get_image.is_internet eq 1> checked</cfif> value="1"><cf_get_lang dictionary_id='58079.İnternet'></label>
                    </div>
                </cfif>
                <cfif attributes.type eq "training">
                    <input type="hidden" name="class_id" id="class_id" value="<cfoutput>#action_id#</cfoutput>">
                    <input type="hidden" name="up_types" id="up_types" value="imgs">
                </cfif>
                <cfif attributes.type eq "train_group">
                    <input type="hidden" name="train_group_id" id="train_group_id" value="<cfoutput>#action_id#</cfoutput>">
                    <input type="hidden" name="up_typ" id="up_typ" value="im">
                </cfif>
                <cfif attributes.type eq "train_subject">
                    <input type="hidden" name="train_id" id="train_id" value="<cfoutput>#action_id#</cfoutput>">
                    <input type="hidden" name="up_typs" id="up_typs" value="imgs">
                </cfif>
                <cfif attributes.type eq "sample">
                    <input type="hidden" name="product_sample_image_id" id="product_sample_image_id" value="<cfoutput>#action_id#</cfoutput>">
                    <input type="hidden" name="up_typ" id="up_typ" value="im">
                </cfif>                    
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="language_id" id="language_id" style="width:60px;">
                            <cfoutput query="getLanguage">
                                <option value="#language_short#" <cfif get_image.language_id is language_short> selected</cfif>>#language_set#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50608.İmaj Adı'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='50608.İmaj Adı !'></cfsavecontent>
                            <cfinput type="text" name="image_name" id="image_name" required="yes" message="#message#" style="width:200px;" maxlength="250" value="#image_name#">
                         
                         <cfif attributes.type eq "product">
                            <span class="input-group-addon">
                                <cf_language_info 
                                    table_name="#table#" 
                                    column_name="PRD_IMG_NAME" 
                                    column_id_value="#attributes.action_id#" 
                                    maxlength="500" 
                                    datasource="#datasource#" 
                                    column_id="#identity_column#" 
                                    control_type="0">
                            </span>   
                        </cfif>
                        </div>     
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58080.Resim'> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="File" name="image_file" id="image_file" style="width:200px;"></div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="hidden" name="old_image_file" id="old_image_file" value="<cfoutput>#get_image.path#</cfoutput>">
                        <cfoutput>#get_image.path#</cfoutput></div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="29761.URL">*</label>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <input type="text" name="image_url_link" id="image_url_link" value="<cfif isdefined("get_image.VIDEO_PATH") and len(get_image.VIDEO_PATH)><cfoutput>#get_image.VIDEO_PATH#</cfoutput></cfif>" style="width:200px;">
                    </div>
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="video_link" id="video_link" <cfif GET_IMAGE.VIDEO_LINK eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id="33506.Video Link"> Embed</label>
                </div>                    
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">                            
                        <cfif len(table) and len(identity_column)>
                            <div class="input-group">
                                <cfinput type="text" name="detail" id="detail" value="#get_image.detail#" maxlength="2000" >
                                <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="#table#" 
                                        column_name="DETAIL" 
                                        column_id_value="#attributes.action_id#" 
                                        maxlength="2000" 
                                        datasource="#datasource#" 
                                        column_id="#identity_column#" 
                                        control_type="0">
                                </span>
                            </div>
                        <cfelse>
                            <textarea name="detail" id="detail" maxlength="1000"><cfoutput>#get_image.detail#</cfoutput></textarea>
                        </cfif>
                    </div>
                </div>
                <!--- xml deki stoga resim eklensin parametresi --->
                <cfif is_stock_picture and attributes.type eq "product">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57452.Stok"></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <select name="stock_id" id="stock_id" style="width:200px; height:70px;" multiple>
                                <cfoutput query="getStocks">
                                    <option value="#stock_id#" <cfif listfind(get_image.stock_id, stock_id)>selected</cfif>>#stock_code#-#property#</option>
                                </cfoutput>
                            </select>					
                        </div>
                    </div>	
                </cfif>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <label><input type="radio" name="size" id="size" value="0" <cfif get_image.image_size eq 0> checked</cfif>><cf_get_lang dictionary_id='57927.Küçük'></label>
                        <label><input type="radio" name="size" id="size" value="1" <cfif get_image.image_size eq 1> checked</cfif>><cf_get_lang dictionary_id='57928.Orta'></label>
                        <label><input type="radio" name="size" id="size" value="2" <cfif get_image.image_size eq 2> checked</cfif>><cf_get_lang dictionary_id='57929.Büyük'></label>
                        <label><input type="radio" name="size" id="size" value="3" <cfif get_image.image_size eq 3> checked</cfif>><cf_get_lang dictionary_id='58029.İkon'>- <cf_get_lang dictionary_id='58637.Logo'></label>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cfset session.imPath = "#upload_folder#product#dir_seperator#">
        <cfset session.module = "product">
        <cf_box_footer>
            <div class="col col-6 col-xs-12">
                <cf_record_info query_name="get_image">
            </div>
            <div class="col col-6 col-xs-12">
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()' type_format='1'>
            </div>
        </cf_box_footer>	
    </cfform>
</cf_box>
<script type="text/javascript">
	document.getElementById('upload_status').style.display = 'none';
	function go()
	{	   
	   if(control())
		   document.gonderform.submit();
	}
	
	function control()
	{	

       /*  x = (500 - document.getElementById('detail').value.length);
            if ( x < 0 )
            { 
                alert ("<cf_get_lang dictionary_id='50599.Açıklama Alanı Uzun !'>"+ ((-1) * x) +"");
                return false;
            } */

		if(document.getElementById('image_file').value != "")
		{
			var obj =  document.getElementById('image_file').value;
			if ((obj != "") && (!((obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'svg')   || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.lastIndexOf('.')+1,obj.lastIndexOf('.') + 4).toLowerCase() == 'png')))){
				alert("<cf_get_lang dictionary_id='37708.Lütfen bir resim dosyası(gif,jpg,png veya svg) giriniz'>!!");        
				return false;
			}
			<cfif  GET_IMAGE.IS_EXTERNAL_LINK eq 1>
			if(obj == "")
			{
				alert("<cf_get_lang dictionary_id='43275.Dosya Seçmelisiniz'> !");
				return false;
			}
			</cfif>
			document.getElementById('upload_status').style.display = '';
                <cfif isdefined("attributes.draggable")>
                loadPopupBox('gonderform' , <cfoutput>#attributes.modal_id#</cfoutput>)
                return false;
                </cfif>
			return true;
		}
		else if(document.getElementById('image_url_link').value != "")
		{
			if(trim(document.getElementById('image_url_link').value) =="")
			{
				alert("<cf_get_lang dictionary_id='29936.URL Giriniz'> !");
				return false;
			}
        }
            <cfif isdefined("attributes.draggable")>
                loadPopupBox('gonderform' , <cfoutput>#attributes.modal_id#</cfoutput>)
                return false;
            </cfif>
            return true;
	}

</script>
