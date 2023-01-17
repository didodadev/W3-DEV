<cfinclude template="../query/get_our_companies.cfm">
<cfinclude template="../query/get_language.cfm">
<cfquery name="GET_CONTENT_CHAPTER_ID" datasource="#DSN#" maxrows="1">
	SELECT
		CONTENTCAT_ID
	FROM
		CONTENT_CHAPTER
	WHERE
		CONTENTCAT_ID = #url.id#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42127.İçerik Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_content_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_content_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="content_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_content_cat_upd" enctype="multipart/form-data">
                <cfquery name="CATEGORY" datasource="#dsn#">
                    SELECT
                        DISTINCT
                            CC.CONTENTCAT_ID, 
                            #dsn#.Get_Dynamic_Language(CC.CONTENTCAT_ID,'#session.ep.language#','CONTENT_CAT','CONTENTCAT',NULL,NULL,CC.CONTENTCAT) AS CONTENTCAT,
                            CC.FILE_TYPE1, 
                            CC.FILE_TYPE2, 
                            CC.CONTENTCAT_IMAGE1, 
                            CC.CONTENTCAT_IMAGE2, 
                            CC.CONTENTCAT_LINK1, 
                            CC.CONTENTCAT_ALT1, 
                            CC.CONTENTCAT_LINK2,
                            CC.CONTENTCAT_ALT2, 
                            CC.LANGUAGE_ID, 
                            CC.IS_RULE, 
                            CC.IS_HOMEPAGE, 
                            CC.COMPANY_ID, 
                            CC.RECORD_DATE, 
                            CC.RECORD_EMP, 
                            CC.RECORD_IP, 
                            CC.UPDATE_DATE, 
                            CC.UPDATE_EMP, 
                            CC.UPDATE_IP, 
                            CC.CONTENTCAT_IMAGE_SERVER_ID1, 
                            CC.CONTENTCAT_IMAGE_SERVER_ID2, 
                            CC.IS_TRAINING 
                    FROM 
                        CONTENT_CAT CC
                    WHERE 
                        
                        CC.CONTENTCAT_ID = #URL.ID#
                </cfquery>
                <cfquery name="GET_CONTENT_CAT" datasource="#DSN#">
                    SELECT COMPANY_ID FROM CONTENT_CAT_COMPANY WHERE CONTENTCAT_ID = #URL.ID#
                </cfquery>
                <cfset check_my_comp_id = valuelist(GET_CONTENT_CAT.COMPANY_ID)>
                <cfquery name="get_content_company" datasource="#dsn#">
                       SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY 
                </cfquery>
                <input type="Hidden" name="contentCat_ID" id="contentCat_ID" value="<cfoutput>#URL.ID#</cfoutput>">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-checkbox">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label>&nbsp</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                <div class="col col-4 col-md-4 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_homepage" id="is_homepage" <cfif category.is_homepage is 1>checked</cfif> value="1"><cf_get_lang dictionary_id='30320.Anasayfa'></label></div>
                                <div class="col col-4 col-md-4 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_rule" id="is_rule" <cfif category.is_rule is 1>checked</cfif> value="1"><cf_get_lang dictionary_id='57418.Literatür'></label></div>
                                <div class="col col-4 col-md-4 col-sm-12 col-xs-12"><label><input type="checkbox" name="is_training" id="is_training" <cfif category.is_training is 1>checked</cfif> value="1"><cf_get_lang dictionary_id='57419.Eğitim'></label></div>
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-contentCat">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57480.Konu'></label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="Text" name="contentCat" value="#category.contentCat#" maxlength="50" required="Yes" message="#message#">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="CONTENT_CAT" 
                                        column_name="CONTENTCAT" 
                                        column_id_value="#URL.ID#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="CONTENTCAT_ID" 
                                        control_type="0">
                                    </span>
                                </div>
                            </div>
                        </div>
                        <cfif len(category.contentcat_image1)>
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-file_type1">
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='29762.İmaj'>1</label></div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="contentCatImage_file" id="contentCatImage_file" value="<cfoutput>settings/#category.CONTENTCAT_IMAGE1#</cfoutput>">
                                        <input type="hidden" name="contentCatImage_server_id" id="contentCatImage_server_id" value="<cfoutput>#category.contentcat_image_server_id1#</cfoutput>">
                                        <cfinput type="file" name="CONTENTCAT_IMAGE1" id="image1" value="#category.contentcat_image1#">
                                        <span class="input-group-addon" onClick="windowopen('<cfoutput>#file_web_path#settings/#category.CONTENTCAT_IMAGE1#</cfoutput>','page');"><i class="fa fa-file-image-o"></i></span>
                                    </div>
                                </div>
                            </div>
                        <cfelse>
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-file_type1_new">
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='29762.İmaj'>1</label></div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <div class="col col-8 col md-8 col-sm-12 col-xs-12">
                                        <cfinput type="file" name="CONTENTCAT_IMAGE1" id="image1" value="#category.contentcat_image1#">
                                    </div>                                   
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-contentCatLink1">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='42371.Link'>1</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <cfinput type="text" name="CONTENTCAT_LINK1" id="CONTENTCAT_LINK1" value="#category.CONTENTCAT_LINK1#">
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-detail1">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57629.Açıklama'>1</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <cfinput type="text" name="CONTENTCAT_ALT1" id="CONTENTCAT_ALT1" value="#category.CONTENTCAT_ALT1#">
                            </div>
                        </div>
                        <cfif len(category.contentcat_image1)>
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-file_type2">
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='29762.İmaj'>2</label></div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="contentCatImage_file2" id="contentCatImage_file2" value="<cfoutput>settings/#category.CONTENTCAT_IMAGE2#</cfoutput>">
                                        <input type="hidden" name="contentCatImage_server_id2" id="contentCatImage_server_id2" value="<cfoutput>#category.contentcat_image_server_id2#</cfoutput>">
                                        <cfinput type="file" name="CONTENTCAT_IMAGE2" id="image2" value="#category.contentcat_image2#">
                                        <span class="input-group-addon" onClick="windowopen('<cfoutput>#file_web_path#settings/#category.CONTENTCAT_IMAGE2#</cfoutput>','page');"><i class="fa fa-file-image-o"></i></span>
                                    </div>
                                </div>
                            </div>
                        <cfelse>
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-file_type2_new">
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='29762.İmaj'>2</label></div>
                                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                    <div class="col col-8 col md-8 col-sm-12 col-xs-12">
                                        <cfinput type="file" name="CONTENTCAT_IMAGE2" id="image2" value="#category.contentcat_image2#">
                                    </div>                                    
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-contentCatLink2">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='42371.Link'>2</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <cfinput type="text" name="CONTENTCAT_LINK2" id="CONTENTCAT_LINK2" value="#category.CONTENTCAT_LINK2#">
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-detail2">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57629.Açıklama'>2</label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <cfinput type="text" name="CONTENTCAT_ALT2" id="CONTENTCAT_ALT2" value="#category.CONTENTCAT_ALT2#">
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-language">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='58996.Dil'></label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <select name="LANGUAGE_ID" id="LANGUAGE_ID">
                                    <cfoutput query="get_language">
                                        <cfif category.language_id is language_short>
                                          <option selected value="#language_short#">#LANGUAGE_SET#</option>
                                        <cfelse>
                                          <option value="#language_short#">#LANGUAGE_SET#</option>
                                        </cfif>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='30253.Kullanıcı Dostu URL'></label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <cf_publishing_settings fuseaction="settings.form_upd_content_cat" event="det" action_type="CONTENTCAT_ID" action_id="#url.id#">
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-company">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"><label><cf_get_lang dictionary_id='57574.Şirket'></label></div>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <select name="company_id" id="company_id" multiple="multiple">
                                    <cfoutput query="get_content_company">
                                        <option value="#comp_id#" <cfif listFind(check_my_comp_id,get_content_company.comp_id,',')>selected</cfif>>#company_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_record_info query_name="category">
                    <cfif get_content_chapter_id.recordcount>
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                    <cfelse>
                        <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_content_cat_del&contentcat_id=#url.id#&is_del=1'  add_function='kontrol()'>
                    </cfif>
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('is_homepage').checked == true && document.getElementById('is_rule').checked == true)
		{
			alert("<cf_get_lang dictionary_id='43821.Bir Kategori Hem Anasayfa Hem Literatür Olamaz'>!");
			return false;
		}
		if (document.getElementById('company_id').value == '')
		{
			alert("<cf_get_lang dictionary_id='43432.Lütfen Şirket Seçiniz'>!");
			return false;
		}
		return true;
	}
</script>