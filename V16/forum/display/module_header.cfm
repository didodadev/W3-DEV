<cfset url_str = "">
<cfinclude template="../query/get_company_name.cfm">
<cfset forumCFC = CreateObject("component","V16.forum.cfc.forum").init(dsn = application.systemParam.systemParam().dsn)>
<cfset userinfo = CreateObject("component","V16.forum.cfc.userinfo")>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.forumid" default="0">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.tarih" default="1">
<cfparam name="attributes.topic_status" default="1">
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset FORUMLIST = forumCFC.select()>

    <cfoutput> 
        <cfform method="post" action="#request.self#?fuseaction=forum.search">       
            <cf_box_search id="list_form" more="0" click="openBoxDraggable('#request.self#?fuseaction=forum.form_add_forum')">
                <input type="hidden" name="isSubmit" value="1">
                    <div class="form-group">
                        <input name="keyword" id="keyword" class="form-control" type="search" value="#attributes.keyword#" placeholder="<cfoutput>#getLang("forum",'Ne Aramıştınız?',54983)#</cfoutput>">
                    </div>
                    <div class="form-group">
                        <select class="custom-select"  name="forumid" id="forumid">
                            <option selected value="0"><cfoutput>#getLang("forum",'Forum Seçiniz',55000)#</cfoutput></option>
                            <cfloop query="forumlist">
                                <option value="#forumid#" <cfif attributes.forumid eq forumid>selected</cfif>>#forumname#</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="form-group">
                        <select class="custom-select" name="tarih" id="tarih">
                            <option value="1" <cfif isDefined('attributes.tarih') and attributes.tarih eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                            <option value="2" <cfif isDefined('attributes.tarih') and attributes.tarih eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select class="custom-select"  name="status" id="status">
                            <option <cfif len(attributes.status) eq 0>selected</cfif> value=""><cfoutput>#getLang("main",'Tümü',57708)#</cfoutput></option>
                            <option <cfif attributes.status eq 1>selected</cfif> value="1"><cfoutput>#getLang("main",'Aktif',57493)#</cfoutput></option>
                            <option <cfif attributes.status eq 0>selected</cfif> value="0"><cfoutput>#getLang("main",'Pasif',57494)#</cfoutput></option>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfinput name="maxrows" id="maxrows" class="form-control" type="text" value="#attributes.maxrows#" message="#getLang('','Kayıt Sayısını Boş Bırakmayınız',40353)#" required="yes" validate="integer" range="1,999" maxlength="3" onKeyUp="isNumber(this)">
                    </div>   
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                    </div>
                    <div class="form-group">
                        <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=forum.form_add_forum')" class="ui-btn ui-btn-gray">
                            <i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>"></i>
                        </a>
                    </div>
            </cf_box_search>
        </cfform>
    </cfoutput> 