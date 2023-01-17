<cfset cfc = createObject('component','V16.training_management.cfc.training_groups')>
<cfset get_training_subjects = cfc.get_training_group_subjects_all()>
<cfinclude template="../../rules/display/rule_menu.cfm">
<div class="wrapper" style="margin-top:-5px; padding:0 5px 0 5px;">
    <div class="col col-12">
	    <cfinclude template="general_training_menu.cfm">
    </div>
</div>
<cfinclude template="../../rules/query/get_content_cat.cfm">
<cfinclude template="../../rules/query/get_content_property.cfm">

<cfparam name="attributes.training" default="1">
<cfinclude template="../../rules/query/get_content.cfm">
<cfif isdefined("url.chpid") or isdefined("id")>
  <cfinclude template="../../rules/query/get_chapter_name.cfm">
</cfif>

<cfset getComponent= createObject("component","V16.training_management.cfc.training_management")>

<cfif isDefined("attributes.lesson_id") and len(attributes.lesson_id)>
    <cfset get_content = getComponent.GetContent(action_type : 'CLASS_ID', action_type_id : attributes.lesson_id)>>
</cfif>

<cfif isDefined("attributes.training_subject") and len(attributes.training_subject)>
    <cfset getComponent= createObject("component","V16.objects.cfc.get_list_content_relation")>
    <cfset get_content = getComponent.GetContent(action_type : 'train_id', action_type_id : attributes.training_subject)>
</cfif>

<!--- Sayfaya training.list_train_groups üzerinden geliyorsa, Sınıfa ekli dersleri çekiyor. --->
<cfif isDefined("attributes.train_group_id") and len(attributes.train_group_id)>
    <cfset trainings = getComponent.GET_TRAININGS(train_group_id: attributes.train_group_id)>
</cfif>
<!--- //Sayfaya training.list_train_groups üzerinden geliyorsa, Sınıfa ekli dersleri çekiyor. --->

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_content.recordcount#">
<cfparam name="attributes.keyword1" default="">
<cfparam name="attributes.language_id" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.chapter" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
            <cf_box class="clever" style="margin:-5px 1px!important">
                <ul class="menuDropdown lit_list">
                    <div class="menuDropdownItem lit_list_item">
                        <cfinclude template="list_content_chapter.cfm">
                    </div>
                </ul>
            </cf_box>
        </div>
        <div class="col col-10 col-md-10 col-sm-10 col-xs-12">
            <div class="search_group">
                <cf_box>
                    <cfform name="search_content" action="#request.self#?fuseaction=training.content" method="post">
                        <cf_box_search id="training_content" plus="0" more="0" extra="1" btn_id="intranet-button">
                            <div class="form-group">
                                <div class="blog_title" style="margin:5px;color:#13be54;">
                                    <cf_get_lang dictionary_id='58045.İçerikler'>
                                </div>
                            </div>
                            <div class="form-group xxlarge">
                                <input type="text" name="keyword1" id="keyword1" value="" placeholder="<cf_get_lang dictionary_id='54983.What are you looking for?'>">
                            </div>
                            <div class="form-group small">
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" onKeyUp="isNumber(this)">
                            </div>	
                            <div class="form-group" id="intranet-button">
                                <cf_wrk_search_button button_type="4" search_function="gonder()">
                            </div>
                        </cf_box_search>
                        <cf_box_search_detail search_function="gonder()">
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='46049.Müfredat'></label>
                                    <select name="training_subject" id="training_subject" onchange="selectSubject(this.value);">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_training_subjects">
                                            <option value="#TRAIN_ID#"<cfif isdefined("attributes.training_subject") and attributes.training_subject is "#TRAIN_ID#">selected</cfif>>#TRAIN_HEAD# </option>
                                        </cfoutput>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id ='57486.Kategori'></label>
                                    <cf_wrk_selectlang
                                        name="cont_catid"
                                        width="130"
                                        option_name="contentcat"
                                        option_value="contentcat_id"
                                        onchange="showChapter(this.value);"
                                        table_name="CONTENT_CAT"
                                        value="#iif(isdefined("attributes.cont_catid"),"attributes.cont_catid",DE(""))#"
                                        condition="CONTENTCAT_ID <> 0 AND CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = #session.ep.company_id# OR COMPANY_ID IS NULL) AND IS_TRAINING =1">
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id ='57995.Blm'></label>
                                    <div id="chapter_place">
                                        <select name="chapter" id="chapter">
                                            <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class=" col col-3 col-md-3 col-sm-3 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id ='57756.Durumu'></label>
                                    <select name="status" id="status">
                                        <option value="1" <cfif isdefined("attributes.status") and attributes.status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                        <option value="2" <cfif isdefined("attributes.status") and attributes.status is 2>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                        <option value="3" <cfif isdefined("attributes.status") and attributes.status is 3>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='58996.Dil'></label>
                                    <select name="language_id" id="language_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                        <option value="tr" <cfif isdefined("attributes.language_id") and attributes.language_id is "tr">selected</cfif>><cf_get_lang dictionary_id="38745.Türkçe">
                                        <option value="eng" <cfif isdefined("attributes.language_id") and attributes.language_id is "eng">selected</cfif>><cf_get_lang dictionary_id='32650.English'>
                                        <option value="de" <cfif isdefined("attributes.language_id") and attributes.language_id is "de">selected</cfif>><cf_get_lang dictionary_id='62712.Deutch'>
                                    </select>
                                </div>
                            </div>
                        </cf_box_search_detail>
                    </cfform>
                    <div id="list_content_" style="position:absolute;"></div>
                </cf_box>
            </div>
        </div>
    
        <div class="col col-10 col-md-10 col-sm-10 col-xs-12 pull-right">
            <cfif get_content.recordcount or (isDefined("trainings") and trainings.recordcount)>
                <cfif isDefined("attributes.train_group_id") and len(attributes.train_group_id)>
                    <cfoutput query="trainings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfset get_content = getComponent.get_training_groups_contents(action_type : 'CLASS_ID', action_type_id : trainings.class_id)>
                        <cfif get_content.recordcount>
                            <cfloop query="get_content" group="content_id">
                                <div class="forum_item flex-col">
                                    <div class="reply_item">
                                        <p class="name">
                                            <a href="#request.self#?fuseaction=training.content&event=det&cntid=#get_content.CONTENT_ID#" title="#get_content.cont_head#">#get_content.cont_head#</a>
                                        </p>
                                        <p class="text">
                                            #get_content.cont_summary#
                                        </p>
                                        <div style="background-color:none; border-radius:none;">
                                            <div style="border-bottom: 2px dashed ##eee;">
                                                <div class="col col-6 col-xs-12"><p style="float:left;color:##a2a2a2;padding:10px 0 0 0;">#get_content.CONTENTCAT# / #get_content.CHAPTER# / #get_content.NAME#</p></div>
                                                <div class="col col-6 col-xs-12"><div style="float:right!important;color:##a2a2a2;padding:10px 0 0 0;"><cf_record_info query_name="get_content"></div></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </cfloop>
                        </cfif>
                    </cfoutput>
                <cfelseif isDefined("attributes.keyword1") and len(isDefined("attributes.keyword1"))>
                    <cfoutput query="get_content" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <div class="forum_item flex-col">
                            <div class="reply_item">
                                <p class="name">
                                    <a href="#request.self#?fuseaction=training.content&event=det&cntid=#CONTENT_ID#" title="#cont_head#">#cont_head#</a>
                                </p>
                                <p class="text">
                                    #cont_summary#
                                </p>
                                <div style="background-color:none; border-radius:none;">
                                    <div style="border-bottom: 2px dashed ##eee;">
                                        <div class="col col-6 col-xs-12"><p style="float:left;color:##a2a2a2;padding:10px 0 0 0;">#CONTENTCAT# / #CHAPTER# / #NAME#</p></div>
                                        <div class="col col-6 col-xs-12"><div style="float:right!important;color:##a2a2a2;padding:10px 0 0 0;"><cf_record_info query_name="get_content"></div></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfoutput>
                <cfelse>
                    <cfoutput query="get_content" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cf_box class="clever">
                            <div class="ui-info-text">
                                <div>
                                    <div class="portHeadLight" style="border-bottom:none!important;">
                                        <div class="portHeadLightTitle" style="margin:-10px 0px 0px 0px;">
                                            <span>
                                                <a class="title blog_detail_content_title" href="#request.self#?fuseaction=training.content&event=det&cntid=#get_content.CONTENT_ID#" title="#get_content.cont_head#">#get_content.cont_head#</a>
                                            </span>
                                        </div>
                                    </div>
                                    <div style="background-color:none; border-radius:none;">
                                        <p class="padding-bottom-right">#get_content.cont_summary#</p>
                                        <div style="box-shadow:none; border-bottom: 2px dashed ##ddd;">
                                            <div class="col col-6 col-xs-12" style="padding:2px 0px 0px 0px;"><p>#get_content.CONTENTCAT# / #get_content.CHAPTER# / #get_content.NAME#</p></div>
                                            <div class="col col-6 col-xs-12" style="padding:2px 0px 0px 0px;"><div style="float:right!important;"><cf_record_info query_name="get_content"></div></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </cf_box>
                    </cfoutput>
                </cfif>
            <cfelse>
                <cf_box>
                    <h1><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</h1>
                </cf_box>
            </cfif>
            <cfif get_content.recordcount gt attributes.maxrows>
                <cfset adres = "">
                <cfset adres = "#adres#&form_submitted=1">
                <cfif isdefined("attributes.keyword1") and len(attributes.keyword1)>
                    <cfset adres = "#adres#&keyword1=#attributes.keyword1#">
                </cfif>
                <cfif isdefined("attributes.training_subject")>
                    <cfset adres = "#adres#&training_subject=#attributes.training_subject#">
                </cfif>
                <cfif isdefined("attributes.cont_catid")>
                    <cfset adres = "#adres#&cont_catid=#attributes.cont_catid#">
                </cfif>
                <cfif isdefined("attributes.chapter")>
                    <cfset adres = "#adres#&chapter=#attributes.chapter#">
                </cfif>
                <cfif isdefined("attributes.status")>
                    <cfset adres = "#adres#&status=#attributes.status#">
                </cfif>
                <cfif isdefined("attributes.language_id")>
                    <cfset adres = "#adres#&language_id=#attributes.language_id#">
                </cfif>
                <cf_box>
                    <cf_paging page="#attributes.page#"
                        maxrows="#attributes.maxrows#"
                        totalrecords="#get_content.recordcount#"
                        startrow="#attributes.startrow#"
                        adres="training.content#adres#">
                </cf_box>
            </cfif>
        </div>
    </div>
</div>
<script type="text/javascript">
    <cfif isDefined("attributes.cont_catid") and len(attributes.cont_catid)>
        showChapter(<cfoutput>#attributes.cont_catid#</cfoutput>);
    </cfif>
    function gonder()
    {
        keyword_ = document.getElementById('keyword1').value;
        language_id_ = document.getElementById('language_id').value;
        status_ = document.getElementById('status').value;
        training_subject_ = document.getElementById('training_subject').value;
        if(training_subject_ != 0){
            cont_catid_ = "";
            chapter_ = "";
        }
        else{
            cont_catid_ = document.getElementById('cont_catid').value;
            chapter_ = document.getElementById('chapter').value;
        }
            
    
        <cfoutput>
            url_string = '#request.self#?fuseaction=training.content&keyword1='+keyword_+'&language_id='+language_id_+'&status='+status_+'&chapter='+chapter_+'&cont_catid='+cont_catid_+'&training_subject='+training_subject_;
            top.location.href= url_string;
        </cfoutput>
    }
    
    function showChapter(cont_catid)	
	{
		var cont_catid = document.getElementById('cont_catid').value;
		if (cont_catid != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=content.popup_ajax_list_chapter&cont_catid="+cont_catid;
			AjaxPageLoad(send_address,'chapter_place',1,'İlişkili Bölümler');
		}
        if (cont_catid != 0)
        {
            $("#training_subject").val('');
        }
	}
    
    var groups=document.search_content.cat.options.length;
    var group=new Array(groups);
    
    for (i=0; i<groups; i++)
    group[i]=new Array();
    
    group[0][0]=new Option("Bölüm Seçiniz","");
    
    <cfset cnt_cat = ArrayNew(1)>
    <cfoutput query="get_content_cat">
        <cfset Cnt_cat[currentrow] = #CONTENTCAT_ID#>
    </cfoutput>
    <cfloop from="1" to="#ArrayLen(Cnt_cat)#" index="indexer">
        <cfquery name="CHPT_SEC" datasource="#dsn#">
            SELECT CHAPTER_ID,CHAPTER FROM CONTENT_CHAPTER WHERE CONTENTCAT_ID = #CNT_CAT[INDEXER]#
        </cfquery>
        <cfif CHPT_SEC.recordcount>
            <cfoutput query="Chpt_sec">
                <cfset deg = currentrow -1>
                group[#indexer#][#deg#]=new Option("#chapter#","#chapter_ID#");
            </cfoutput>
        <cfelse>
            <cfset deg = 0>
            <cfoutput>
                group[#indexer#][#deg#]=new Option("<cf_get_lang dictionary_id ='40775.Bölüm Seçiniz'>","");
            </cfoutput>
        </cfif>
    </cfloop>
    
    var temp=document.search_content.chapter;
    function redirect(x)
    {
        for (m=temp.options.length-1;m>0;m--)
            temp.options[m]=null;
        for (i=0;i<group[x].length;i++)
        {
            temp.options[i]=new Option(group[x][i].text,group[x][i].value);
        }
        document.search_content.style.display = "";
    }
    
    function open_list_content()
    {
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=training.content#url_address#' ,'list_content_','0');
    }
</script>