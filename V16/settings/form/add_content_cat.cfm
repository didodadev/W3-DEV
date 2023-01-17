<cfinclude template="../query/get_our_companies.cfm">
<cfinclude template="../query/get_language.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42127.İçerik Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_content_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_content_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="content_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_content_cat_add" enctype="multipart/form-data">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-checkbox">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label>&nbsp</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                <div class="col col-4 col-md-4 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_homepage" id="is_homepage" value="1"><cf_get_lang dictionary_id='30320.Anasayfa'></label></div>
                                <div class="col col-4 col-md-4 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_rule" id="is_rule" value="1"><cf_get_lang dictionary_id='57418.Literatür'></label></div>
                                <div class="col col-4 col-md-4 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_training" id="is_training" value="1"><cf_get_lang dictionary_id='57419.Eğitim'></label></div>
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-contentCat">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57480.Konu'></label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'>!</cfsavecontent>
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="text" name="contentCat" id="contentCat" message="#message#" value="" required>
                                        <input type="hidden" name="contentCat_dictionary_id" id="contentCat_dictionary_id" value="">
                                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_list_lang_settings&is_use_send&lang_dictionary_id=content_cat.contentCat_dictionary_id&lang_item_name=content_cat.contentCat');return false"></span>
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-file_type1">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='29762.İmaj'>1</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <div class="col col-8 col-md-8 col-sm-12 col-xs-12">
                                    <input type="File" name="CONTENTCAT_IMAGE1" id="CONTENTCAT_IMAGE1">
                                </div>                               
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-contentCatLink1">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='42371.Link'>1</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <input type="text" name="CONTENTCAT_LINK1" id="CONTENTCAT_LINK1" value="">
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-detail1">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57629.Açıklama'>1</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <input type="text" name="CONTENTCAT_ALT1" id="CONTENTCAT_ALT1" value="">
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-file_type2">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='29762.İmaj'>2</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <div class="col col-8 col-md-8 col-sm-12 col-xs-12">
                                    <input type="File" name="CONTENTCAT_IMAGE2" id="CONTENTCAT_IMAGE2">
                                </div>                              
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-contentCatLink2">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='42371.Link'>2</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <input type="text" name="CONTENTCAT_LINK2" id="CONTENTCAT_LINK2" value="">
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-detail2">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57629.Açıklama'>2</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <input type="text" name="CONTENTCAT_ALT2" id="CONTENTCAT_ALT2" value="">
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-language">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='58996.Dil'></label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <select name="LANGUAGE_ID" id="LANGUAGE_ID">
                                    <cfoutput query="get_language">
                                        <option value="#LANGUAGE_SHORT#">#LANGUAGE_SET#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-company">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57574.Şirket'></label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <select name="company_id" id="company_id" multiple="multiple">
                                    <cfoutput query="our_company">
                                        <option value="#comp_id#">#company_name# </option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">
    function kontrol()
    {
        if ((document.getElementById('is_homepage').checked == true) && (document.getElementById('is_rule').checked == true))
        {
            alert("<cf_get_lang dictionary_id='43821.Bir Kategori Hem Anasayfa Hem Literatür Olamaz'>");
            return false;
        }
        if (document.getElementById('company_id').value == '')
        {
            alert("<cf_get_lang dictionary_id='43432.Lütfen Şirket Seçiniz'>!");
            return false;
        }
        
        var str="";
        for(i=0;i<document.getElementById('company_id').options.length;++i)
        {
            if(document.getElementById('company_id').options[i].selected == true)
            {
            str=str+", "+document.getElementById('company_id').options[i].text;
            }
        }
        alert ("Yeni Kategori "+str+" Şirketleri için Eklenecektir.");
        return true;
    }
    </script>