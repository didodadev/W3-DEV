<cfinclude template="../query/get_language.cfm">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfinclude template="../query/get_partners.cfm">
<cfinclude template="../query/get_analysis.cfm">
<cfquery name="GET_SITE_MENU" datasource="#DSN#">
SELECT SITE_ID, DOMAIN   FROM PROTEIN_SITES <!--- Yayımlanacak sitelerin proteinden gelmesi sağlandı. Dilek Ö. 25032021--->
	/* SELECT 
    	MENU_ID,
        SITE_DOMAIN,
        OUR_COMPANY_ID 
    FROM 
    	MAIN_MENU_SETTINGS 
    WHERE 
    	IS_ACTIVE = 1 AND 
        SITE_DOMAIN IS NOT NULL */
</cfquery>
<cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
	SELECT 
    	MENU_ID 
    FROM 
    	ANALYSIS_SITE_DOMAIN 
    WHERE 
    	ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> AND
		MENU_ID IS NOT NULL
</cfquery>
<!---20131112--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_analysis" method="post" action="#request.self#?fuseaction=member.emptypopup_upd_analysis">
            <cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2" divLang="#getLang('','Form',29764)#;#getLang('','Şablon',58640)#;">
            <div id="unique_sayfa_1" class="ui-info-text uniqueBox">
            <input type="hidden" value="<cfoutput>#grand_total_point#</cfoutput>" id="grand_total_point1" name="grand_total_point1">
            <input type="hidden" name="analysis_id" id="analysis_id" value="<cfoutput>#attributes.analysis_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-status">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="57756.Durum"></label>
                        <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                            <div class="col col-2 col-md-2 col-sm-3 col-xs-12">
                                <label><input type="checkbox" name="is_active" id="is_active" <cfif get_analysis.is_active eq 1> checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
                            </div>
                            <div class="col col-2 col-md-2 col-sm-3 col-xs-12">
                                <label><input type="checkbox" name="is_published" id="is_published" onclick="gizle_goster(is_site_display);" <cfif get_analysis.is_published eq 1> checked</cfif>><cf_get_lang dictionary_id='29479.Yayın'></label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-analysis_head">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <input type="text" name="analysis_head" id="analysis_head" value="<cfoutput>#get_analysis.analysis_head#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-analysis_objective">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='30277.Amaç'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <input type="text" name="analysis_objective" id="analysis_objective" value="<cfoutput>#get_analysis.analysis_objective#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-process">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <cf_workcube_process is_upd='0' is_detail="1" select_value="#get_analysis.analysis_stage#" process_cat_width='120'>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-language_short">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <select name="language_short" id="language_short">
                                <cfoutput query="get_language">
                                    <option value="#language_short#" <cfif get_language.language_short eq get_analysis.language_short> selected</cfif>>#language_set#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-analysis_product">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>
                        </label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <div class="input-group">
                                <!--- <cf_wrk_products form_name = 'upd_analysis' product_name='analysis_product' product_id='analysis_product_id'> --->
                                <input type="hidden" name="analysis_product_id" id="analysis_product_id" value="<cfoutput>#get_analysis.product_id#</cfoutput>">
                                    <cfif len(get_analysis.product_id)>
                                        <cfquery name="GET_PRO_NAME" datasource="#DSN3#">
                                            SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #get_analysis.product_id#
                                        </cfquery>
                                        <input type="text" name="analysis_product" id="analysis_product" value="<cfoutput>#get_pro_name.product_name#</cfoutput>" onFocus="AutoComplete_Create('analysis_product','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','analysis_product_id','','2','200');" autocomplete="off" style="width:200px;">
                                    <cfelse>
                                        <input type="text" name="analysis_product" id="analysis_product" value="" style="width:200px;" onFocus="AutoComplete_Create('analysis_product','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','analysis_product_id','','2','200');" autocomplete="off">
                                    </cfif>
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=upd_analysis.analysis_product_id&field_name=upd_analysis.analysis_product','list','popup_product_names');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-language_short">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <cf_publishing_settings fuseaction="member.list_analysis" event="det" action_type="ANALYSIS_ID" action_id="#attributes.analysis_id#">
                        </div>
                    </div>
                    <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-google_form_url">
                        <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='65060.Google Forms URL'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                            <cfinput type="text" name="google_form_url" id="google_form_url" value="#get_analysis.GOOGLE_FORMS_URL#">
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x4" type="column" index="2" sort="true">
                    <div class="form-group" id="item-for_who">
                        <label class="bold"><cf_get_lang dictionary_id='54997.Kimler İçin'>?</label>
                    </div>
                    <div class="form-group" id="item-checkbox">
                        <label valign="bottom"><input type="checkbox" name="all" id="all" value="1" onclick="hepsi();" ><cf_get_lang dictionary_id='57952.Herkes'></label>
                    </div>
                    <div class="form-group" id="item-partner_portal">
                        <label class="bold"><cf_get_lang dictionary_id='30426.Partner Portal'></label>
                    </div>
                    <cfoutput query="get_partner_cats"><!---20131115--->
                        <div class="form-group" id="item-analysis_partners">
                            <label><input type="checkbox" name="analysis_partners" id="analysis_partners" value="#companycat_id#" <cfif ListFind(get_analysis.analysis_partners,companycat_id)> checked</cfif>  >#companycat#</label>
                        </div>
                    </cfoutput>
                    <div class="form-group" id="item-public_portal">
                        <label class="bold"><cf_get_lang dictionary_id='30283.Public Portal'></label>
                    </div>
                    <cfoutput query="get_consumer_cat"><!---20131115--->
                        <div class="form-group" id="item-analysis_consumers">
                            <label> <input type="checkbox" name="analysis_consumers" id="analysis_consumers" value="#conscat_id#" <cfif ListFind(get_analysis.analysis_consumers,conscat_id)> checked</cfif>  >#conscat#<br/></label>
                        </div>
                    </cfoutput>
                    <div class="form-group" id="item-rakipler">
                        <label class="bold"><cf_get_lang dictionary_id='30193.Rakipler'></label>
                    </div>
                    <div class="form-group" id="item-analysis_rivals">
                        <label><input type="checkbox" name="analysis_rivals" id="analysis_rivals" value="1" <cfif get_analysis.analysis_rivals eq 1>checked</cfif>  ><br/></label>
                    </div>        
                </div>
                <cfif get_site_domain.recordcount>
                    <cfset my_analysis_list = valuelist(get_site_domain.menu_id)>
                </cfif>
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x4" id="is_site_display" <cfif get_analysis.is_published neq 1>style="display:none;"</cfif> type="column" index="3" sort="true">                        
                    <div class="form-group" id="item-checkbox2"> 
                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang dictionary_id ='30352.Yayınlanacak Site'></label>                   
                    </div>
                    <cfoutput query="get_site_menu">
                        <div class="form-group" id="item-analysis_rivals">
                            <label><input type="checkbox" name="menu_#SITE_ID#" id="menu_#SITE_ID#" value="#SITE_ID#" <cfif get_site_domain.recordcount and (isDefined('my_analysis_list') and ListFindNoCase(my_analysis_list,SITE_ID,','))>checked</cfif>>#domain#&nbsp;</label>
                        </div>
                    </cfoutput>
                </div>
            </cf_box_elements>
            </div>
                <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
                    <cf_box_elements>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-detail">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <label class="col col-12 col-md-12 col-sm-12 col-xs-12" style="display:none"><cf_get_lang dictionary_id='57771.Detay'></label>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                    <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="detail"
                                    value="#get_analysis.detail#"                                  
                                    >
                                </div>
                            </div> 
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-label-1">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_get_lang dictionary_id='30260.Uygunluk Yorumları (%40 doğru cevap verirse uygun değil gibi)'></div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-scores_1">
                            <label class="col col-8 col-md-8 col-sm-8 col-xs-12 bold"><cf_get_lang dictionary_id='62036.Puanlama'></label>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-scores_1">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="score1" id="score1" value="<cfoutput>#get_analysis.score1#</cfoutput>">
                                    <span class="input-group-addon no-bg">-</span>
                                    <cfset puan2 = (len(get_analysis.score2)?get_analysis.score2:0) + 1>
                                    <input type="text" name="puan2" id="puan2" value="<cfoutput>#puan2#</cfoutput>">
                                    <span class="input-group-addon no-bg btnPointer" onclick="openEditor('comment1-editor')"><i class="fa fa-lg fa-pencil"></i></span>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 hide" id="comment1-editor">
                                    <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="comment1"
                                    value="#get_analysis.comment1#" 
                                    >
                                </div>
                            </div>                                
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-scores_2">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="score2" id="score2" value="<cfoutput>#get_analysis.score2#</cfoutput>">
                                    <span class="input-group-addon no-bg">-</span>
                                    <cfset puan3 = (len(get_analysis.score3)?get_analysis.score3:0) + 1>
                                    <input type="text" name="puan3" id="puan3" value="<cfoutput>#puan3#</cfoutput>">
                                    <span class="input-group-addon no-bg btnPointer" onclick="openEditor('comment2-editor')"><i class="fa fa-lg fa-pencil"></i></span>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 hide" id="comment2-editor">
                                    <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="comment2"
                                    value="#get_analysis.comment2#"                                  
                                    >
                                </div>
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-scores_3">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="score3" id="score3" value="<cfoutput>#get_analysis.score3#</cfoutput>">
                                    <span class="input-group-addon no-bg">-</span>
                                    <cfset puan4 = (len(get_analysis.score4)?get_analysis.score4:0) + 1>
                                    <input type="text" name="puan4" id="puan4" value="<cfoutput>#puan4#</cfoutput>">
                                    <span class="input-group-addon no-bg btnPointer" onclick="openEditor('comment3-editor')"><i class="fa fa-lg fa-pencil"></i></span>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 hide" id="comment3-editor">
                                    <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="comment3"
                                    value="#get_analysis.comment3#"                                  
                                    >
                                </div>
                            </div>     
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-scores_4">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="score4" id="score4" value="<cfoutput>#get_analysis.score4#</cfoutput>">
                                    <span class="input-group-addon no-bg">-</span>
                                    <cfset puan5 = (len(get_analysis.score5)?get_analysis.score5:0) + 1>
                                    <input type="text" name="puan5" id="puan5" value="<cfoutput>#puan5#</cfoutput>">
                                    <span class="input-group-addon no-bg btnPointer" onclick="openEditor('comment4-editor')"><i class="fa fa-lg fa-pencil"></i></span>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 hide" id="comment4-editor">
                                    <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="comment4"
                                    value="#get_analysis.comment4#"                                  
                                    >
                                </div>
                            </div>  
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-scores_5">
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" name="score5" id="score5" value="<cfoutput>#get_analysis.score5#</cfoutput>">
                                    <span class="input-group-addon no-bg">-</span>
                                    <input type="text" name="puan6" id="puan6" value="0">
                                    <span class="input-group-addon no-bg btnPointer" onclick="openEditor('comment5-editor')"><i class="fa fa-lg fa-pencil"></i></span>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 hide" id="comment5-editor">
                                    <cfmodule
                                    template="/fckeditor/fckeditor.cfm"
                                    toolbarset="Basic"
                                    basepath="/fckeditor/"
                                    instancename="comment5"
                                    value="#get_analysis.comment5#"                                  
                                    >
                                </div>
                            </div> 
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-total_points">
                            <label class="col col-5 col-md-5 col-sm-5 col-xs-12 text-right"><cf_get_lang dictionary_id='58985.Toplam Puan'>*</label>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                                <div class="input-group padding-right-15">
                                    <input type="text" name="total_points" id="total_points" value="<cfoutput>#get_analysis.total_points#</cfoutput>" maxlength="3" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                    <span class="input-group-addon no-bg"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="item-analysis_average">
                            <label class="col col-5 col-md-5 col-sm-5 col-xs-12 text-right"><cf_get_lang dictionary_id='30238.Uygunluk Sınırı (%)'> *</label>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                                <div class="input-group padding-right-15">
                                    <input type="text" name="analysis_average" id="analysis_average" value="<cfoutput>#get_analysis.analysis_average#</cfoutput>" maxlength="3" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                                    <span class="input-group-addon no-bg"></span>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                </div>
            </cf_tab>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <cf_box_footer>	
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_record_info query_name="get_analysis"></div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='form_check()'></div>
                    <cfif isDefined ("attributes.grand_total_point")>
                        <cfinput type="text" name="grand_total" id="grand_total" value="#attributes.grand_total_point#">
                    </cfif>
                </cf_box_footer>
            </div>
        </cfform>
    </cf_box>
</div>
    <script type="text/javascript">
        function hepsi()
        {
            if (document.upd_analysis.all.checked)
            {
                for(i=0;i<document.upd_analysis.analysis_partners.length;i++) document.upd_analysis.analysis_partners[i].checked = true;
                for(i=0;i<document.upd_analysis.analysis_consumers.length;i++) document.upd_analysis.analysis_consumers[i].checked = true;
                for(i=0;i<document.upd_analysis.analysis_rivals.length;i++) document.upd_analysis.analysis_rivals[i].checked = true;
            }
            else
            {
                for(i=0;i<document.upd_analysis.analysis_partners.length;i++) document.upd_analysis.analysis_partners[i].checked = false;
                for(i=0;i<document.upd_analysis.analysis_consumers.length;i++) document.upd_analysis.analysis_consumers[i].checked = false;
                for(i=0;i<document.upd_analysis.analysis_rivals.length;i++) document.upd_analysis.analysis_rivals[i].checked = false;
            }
        }
        function form_check()
        {   
            if (document.getElementById('total_points').value == "")
            { 
                if($("#unique_sayfa_2").css("display") == "none"){
                    alert("<cf_get_lang dictionary_id='65162.Şablon Tabındaki Zorunlu Alanları Doldurunuz'>!");
                    return false;
                }
                else {
                    alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58985.Toplam Puan !'>");
                    return false;
                }
            }
            if(document.getElementById('total_points').value < document.getElementById('grand_total_point1').value)
            {
                alert("<cf_get_lang dictionary_id='58985.Toplam Puan'>: <cf_get_lang dictionary_id='37321.Minimum'>"+ $('#grand_total_point1').val()+" olmalıdır!");
                return false;
            } 
        
            if(document.getElementById('analysis_average').value == "")
            {
                if($("#unique_sayfa_2").css("display") == "none"){
                    alert("<cf_get_lang dictionary_id='65162.Şablon Tabındaki Zorunlu Alanları Doldurunuz'>!");
                    return false;
                }
                else {
                    alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29774.Uygunluk Sınırı'>!");
                    return false;
                }
            }
        
            flag = 0;
            for(i=0;i<document.upd_analysis.analysis_partners.length;i++) if (document.upd_analysis.analysis_partners[i].checked) flag = 1;
            for(i=0;i<document.upd_analysis.analysis_consumers.length;i++) if (document.upd_analysis.analysis_consumers[i].checked) flag = 1;
        
            if (flag == 0)
            {
                alert ("<cf_get_lang dictionary_id='30330.Testi En Az Bir Kullanıcı Grubuna Kaydedin'>!");
                return false;
            }
            return process_cat_control();
        }
        function openEditor(id){
            $('#'+id).toggleClass('hide');

        }
    </script>
