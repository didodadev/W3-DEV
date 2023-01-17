<!--- <cfset intranet = createObject('component','cfc.intranet')>
<cfset trainingSec = intranet.trainingSec()>
<cfset trainingClass = intranet.trainingClass(top:6)>
<cfset trainingAgenda = intranet.trainingClass(top:3)>
<cfset trainingAnounce = intranet.trainingAnounce()> --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.language" default="#session.ep.language#">
<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset GET_LANGUAGE = cmp.GET_LANGUAGE_F()>
<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset get_training_cat = cfc.get_training_cat()>
<cfset get_training_sec = cfc.get_training_sec()>
<cfif isdefined("attributes.form_submitted")>
    <cfparam name="attributes.status" default="1">
    <cfset GET_TRAININGS = cfc.GET_TRAININGS(
        KEYWORD :iif(isDefined("attributes.KEYWORD"),"attributes.KEYWORD",DE("")), 
        TRAINING_CAT_ID :iif(isDefined("attributes.TRAINING_CAT_ID"),"attributes.TRAINING_CAT_ID",DE("")), 
        TRAINING_SEC_ID : iif(isDefined("attributes.TRAINING_SEC_ID"),"attributes.TRAINING_SEC_ID",DE("")),
        STATUS : iif(isDefined("attributes.STATUS"),"attributes.STATUS",DE("")),
        LANGUAGE : iif(isDefined("attributes.language"),"attributes.language",DE(""))
    )>
<cfelse>
    <cfset get_trainings.recordcount = 0>
</cfif>
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
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_trainings.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

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
                        <div class="form-group">
                            <select name="language" id="language">
                                <cfloop query="GET_LANGUAGE">
                                    <option value="<cfoutput>#GET_LANGUAGE.LANGUAGE_SHORT#</cfoutput>" <cfif GET_LANGUAGE.LANGUAGE_SHORT eq attributes.language>selected</cfif>><cfoutput>#GET_LANGUAGE.LANGUAGE_SET#</cfoutput></option>
                                </cfloop>
                            </select>
                        </div>
                        <div class="form-group small">
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" onKeyUp="isNumber(this)">
                        </div>	
                        <div class="form-group">
                            <cf_wrk_search_button button_type="4">
                        </div>
                    </cf_box_search>
                </cfform>
            </cf_box>
        </div>

        <cfif get_trainings.recordcount>
            <cfoutput query="get_trainings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <div class="forum_item flex-col">
                    <div class="reply_item">
                        <div class="syllabus_name">
                            <a href="#request.self#?fuseaction=training.curriculum&event=det&train_id=#TRAIN_ID#">
                                #train_head#
                            </a>
                            <span>
                                <cfset date = date_add('h',session.ep.time_zone,RECORD_DATE)>
                                <!--- #Dateformat(date,dateformat_style)# #Timeformat(date,timeformat_style)# --->
                            </span>                        
                            <p class="text">#TRAIN_OBJECTIVE#</p>
                        </div>
                        <div class="syllabus_cat">
                            <p class="bold">
                                <cfif get_trainings.training_type eq 1><cfset type = "#getLang('','Standart Eğitim',46647)#">
                                <cfelseif get_trainings.training_type eq 2><cfset type = "#getLang('','Teknik Gelişim Eğitimi',46648)#">
                                <cfelseif get_trainings.training_type eq 3><cfset type = "#getLang('','Zorunlu Eğitim',46649)#">
                                <cfelseif get_trainings.training_type eq 4><cfset type = "#getLang('','Yetkinlik Gelişim Eğitimi',46650)#">
                                <cfelse><cfset type = ""></cfif>
                                <i class="wrk-uF0220" style="color:##d39241;"></i>
                                <span>
                                    <cfset attributes.sec_id = get_trainings.TRAINING_SEC_ID>
                                    <cfinclude template="../../training_management/query/get_training_sec_names.cfm">
                                    #GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#
                                </span>
                                
                                <cfset GET_TRAINING_STYLE = cfc.GET_TRAINING_STYLE()>
                                <i class="wrk-uF0022" style="color:##ef0000"></i>
                                <span>
                                    <cfloop query="get_training_style">
                                        <cfif get_trainings.training_style eq training_style_id>#TRAINING_STYLE#<cfbreak><cfelse><cfcontinue></cfif>
                                    </cfloop>
                                / #type# 
                                </span>
                                <i class="wrk-uF0199" style="color:##4cb355;"></i><span>#total_day#&nbsp;<cf_get_lang dictionary_id='57490.Gün'> - #total_hours#&nbsp;<cf_get_lang dictionary_id='57491.Saat'></span>
                            </p>
                        </div>
                    </div>
                </div>
            </cfoutput>
        <cfelse>
            <cf_box>
                <p class="text"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></p>
            </cf_box>
        </cfif>
        <cfif get_trainings.recordcount gt attributes.maxrows>
            <cfset adres = "">
            <cfset adres = "#adres#&form_submitted=1">
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined("attributes.training_sec_id")>
                <cfset adres = "#adres#&training_sec_id=#attributes.training_sec_id#">
            </cfif>
            <cfif isdefined("attributes.training_cat_id")>
                <cfset adres = "#adres#&training_cat_id=#attributes.training_cat_id#">
            </cfif>
            <cfif isdefined("attributes.status")>
                <cfset adres = "#adres#&status=#attributes.status#">
            </cfif>
            <cf_box>
                <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#get_trainings.recordcount#"
                    startrow="#attributes.startrow#"
                    adres="training.curriculum#adres#">
            </cf_box>
        </cfif>
        </div>
    </div>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>