<cfset intranet = createObject('component','cfc.intranet')>
<cfset trainingSec = intranet.trainingSec()>
<cfset trainingClass = intranet.trainingClass(top:6)>
<cfset trainingAgenda = intranet.trainingClass(top:3)>
<cfset trainingAnounce = intranet.trainingAnounce()>
<cfparam name="attributes.keyword" default="">
<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset get_training_cat = cfc.get_training_cat()>
<cfset get_training_sec = cfc.get_training_sec()>
<cfset GET_RELATION_COMP_CAT = cfc.GET_RELATION_COMP_CAT(field_id:attributes.train_id)>
<cfset GET_RELATION_CONS_CAT = cfc.GET_RELATION_CONS_CAT(field_id:attributes.train_id)>
<cfset GET_RELATION_POS_CAT = cfc.GET_RELATION_POS_CAT(field_id:attributes.train_id)>
<cfset get_train = cfc.GET_TRAINING_SUBJECT(train_id:attributes.train_id)>
<style>
    .pageMainLayout{padding:0;}
</style>

<!--- <link rel="stylesheet" href="/css/assets/template/intranet/intranetSa.css" type="text/css"> --->
<cfinclude template="../../rules/display/rule_menu.cfm">
<div class="wrapper" style="margin-top:-5px;">
    <div class="col col-12">
	    <cfinclude template="general_training_menu.cfm">
    </div>
</div>

<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12">
         <div class="search_group">    
            <cf_box>
                <cfform name="subject_search" id="subject_search" action="#request.self#?fuseaction=training.curriculum" method="post">
                    <input type="hidden" name="form_submitted" id="form_submitted" value="1" />   
                    
                    <cf_box_search more="0">
                        <div class="form-group title_clever">
                            <cf_get_lang dictionary_id='46049.Müfredat'>
                        </div>
                        <div class="form-group" id="item-keyword">
                            <cfinput type="text" name="keyword" id="keyword" placeHolder="#getlang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                        </div>
                        <div class="form-group">
                            <select name="training_cat_id" id="training_cat_id">
                                <option value="0"><cf_get_lang dictionary_id='57486.Kategori'></option>
                                <cfoutput query="get_training_cat">
                                    <option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and (attributes.training_cat_id eq training_cat_id)>selected</cfif>>#training_cat#</option>
                                </cfoutput>
                            </select>
                        </div>
                        <div class="form-group">
                            <select name="training_sec_id" id="training_sec_id">
                                <option value="0"><cf_get_lang dictionary_id='57995.Bölüm'></option>
                                <cfoutput query="get_training_sec">
                                    <option value="#training_sec_id#" <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id eq training_sec_id)>selected</cfif>>#section_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                        <div class="form-group">
                            <select name="status" id="status">
                                <option VALUE="1" <cfif isdefined("attributes.status") and attributes.status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option VALUE="0" <cfif isdefined("attributes.status") and attributes.status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                <option VALUE="" <cfif isdefined("attributes.status") and not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                            </select>
                        </div>
                        <div class="form-group small">
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" onKeyUp="isNumber (this)">
                        </div>	
                        <div class="form-group">
                            <cf_wrk_search_button button_type="4">
                        </div>
                    </cf_box_search>
                </cfform>
            </cf_box>
        </div>

        <cfif get_train.recordcount>
            <cfoutput query="get_train">
                <div class="forum_item flex-col">
                    <div class="reply_item">
                        <div class="syllabus_name_border">                            
                            <a href="javascript://">
                                #train_head#
                            </a>
                            <span>
                                <cfset date = date_add('h',session.ep.time_zone,RECORD_DATE)>
                                <!--- #Dateformat(date,dateformat_style)# #Timeformat(date,timeformat_style)# --->
                            </span>     
                            <p class="text bold">#TRAIN_OBJECTIVE#</p>
                        </div>
                        <div class="syllabus_text">#TRAIN_DETAIL#</div>
                        <div class="syllabus_cat">
                            <p class="bold">
                                <cfif get_train.training_type eq 1><cfset type = "#getLang('','Standart Eğitim',46647)#">
                                <cfelseif get_train.training_type eq 2><cfset type = "#getLang('','Teknik Gelişim Eğitimi',46648)#">
                                <cfelseif get_train.training_type eq 3><cfset type = "#getLang('','Zorunlu Eğitim',46649)#">
                                <cfelseif get_train.training_type eq 4><cfset type = "#getLang('','Yetkinlik Gelişim Eğitimi',46650)#">
                                <cfelse><cfset type = ""></cfif>
                                <i class="wrk-uF0220" style="color:##d39241;"></i>
                                <span>
                                    <cfset attributes.sec_id = get_train.TRAINING_SEC_ID>
                                    <cfinclude template="../../training_management/query/get_training_sec_names.cfm">
                                    #GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#
                                </span>
                                
                                <cfset GET_TRAINING_STYLE = cfc.GET_TRAINING_STYLE()>
                                <i class="wrk-uF0022" style="color:##ef0000"></i>
                                <span>
                                    <cfloop query="get_training_style">
                                        <cfif get_train.training_style eq training_style_id>#TRAINING_STYLE#<cfbreak><cfelse><cfcontinue></cfif>
                                    </cfloop>
                                / #type#
                                </span>
                                <i class="wrk-uF0199" style="color:##4cb355;"></i><span>#total_day#&nbsp;<cf_get_lang dictionary_id='57490.Gün'> - #total_hours#&nbsp;<cf_get_lang dictionary_id='57491.Saat'></span>
                                <i class="wrk-uF0057" style="color:##52bfff;"></i><span>#tlformat(TRAINING_EXPENSE)#&nbsp;#MONEY_CURRENCY#</span>
                            </p>
                        </div>                        
                    </div>
                </div>
            </cfoutput>

            <div class="forum_item flex-col">
                <div class="reply_item">
                    <div class="syllabus_name">
                        <a href="javascript://">
                            <cf_get_lang dictionary_id='42553.Kimler İçin'>
                        </a>
                    </div>                    
                    <table class="syllabus_table">
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='30370.Çalışanlar'></td>
                            <td>
                                <cfoutput query="GET_RELATION_POS_CAT">
                                    #POSITION_CAT#<cfif recordcount gt currentrow>,</cfif>
                                </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='30266.Kurumsal'></td>
                            <td>
                                <cfoutput query="GET_RELATION_COMP_CAT">
                                    #COMPANYCAT#<cfif recordcount gt currentrow>,</cfif>
                                </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td width="100"><cf_get_lang dictionary_id='31101.Bireysel'></td>
                            <td>
                                <cfoutput query="GET_RELATION_CONS_CAT">
                                    #CONSCAT#<cfif recordcount gt currentrow>,</cfif>
                                </cfoutput>
                            </td>
                        </tr>
                    </table>                    
                </div>
            </div>                             

            <div class="forum_item flex-col">
                <div class="reply_item">
                    <div class="syllabus_name">
                        <a href="javascript://">
                            <cf_get_lang dictionary_id='58045.İçerikler'>
                        </a>
                    </div>
                    <div class="col col-12">
                        <cfset cfc = createObject("component","V16.objects.cfc.get_list_content_relation")>
                        <cfset getContent = cfc.GetContent(action_type : 'train_id', action_type_id : attributes.train_id)>
                        <table class="syllabus_table">
                            <cfoutput query="getContent">
                                <tr>
                                    <td class="bold" width="30">#currentrow#</td>
                                    <td>
                                        <a href="#request.self#?fuseaction=training.content&event=det&cntid=#CONTENT_ID#">#CONT_HEAD#</a>
                                    </td>
                                </tr>
                            </cfoutput>
                        </table>
                    </div>
                </div>
                <div class="training_items_bottom_btn">
                    <a href="<cfoutput>#request.self#?</cfoutput>fuseaction=training.content&status=1&training_subject=<cfoutput>#attributes.train_id#</cfoutput>">> <cf_get_lang dictionary_id='31140.Tüm'> <cf_get_lang dictionary_id='58045.İçerikler'></a>
                </div>
            </div>
        <cfelse>
            <cf_box>
                <cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif>
            </cf_box>
        </cfif>            
        </div>
    </div>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>