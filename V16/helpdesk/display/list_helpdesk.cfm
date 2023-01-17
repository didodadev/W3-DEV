<cf_xml_page_edit fuseact="helpdesk.wiki">
<cfcollection  action="list" name="collections">
<cfset collection=[]>
<cfoutput query="collections">
    <cfscript>
        ArrayAppend(collection,  name, "true"); 
    </cfscript> 
</cfoutput>
<cfif not ArrayFind(collection, 'wiki_contents')>
    <script type="text/javascript">
        if (confirm("<cf_get_lang dictionary_id='62969.Solr servislerinizi ayarlamalısınız'>!")) 
            window.location.href = "<cfoutput>#request.self#?fuseaction=help.solr</cfoutput>";
    </script>
    <cfabort>
</cfif>
<cfinclude template="../query/get_help.cfm">
<cfparam name="attributes.help" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_order_by" default="0">
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.action_type_id" default="">
<cfparam name="attributes.cont_catid" default="">
<cfparam name="attributes.meta_desc" default="">
<cfparam name="attributes.chapters" default="">
<cfparam name="attributes.content_property_id" default="">
<cfparam name="attributes.stage_id" default="">
<cfparam name="attributes.lang" default="#session.ep.language#">
<cfparam name="attributes.totalrecords" default=0>
<cfset GET_LANGUAGE = createObject('component','V16.content.cfc.get_content').GET_LANGUAGE()>
<cfparam name="get_content_relation.recordcount" default=0>
<cfif isDefined('session.ep.maxrows')>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelseif isDefined('session.pp.maxrows')>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset cfc= createObject("component","V16.objects.cfc.get_list_content_relation")>


<cfif isdefined("attributes.cid")>
    <cfif isdefined("attributes.form_submitted")>
        <cfset get_content_relation = cfc.GetAddContentRelation(action_type:attributes.action_type,action_type_id:attributes.action_type_id,cid:attributes.cid)> 
	<cfelse>
		<cfset get_content_relation.recordcount = 0>
	</cfif>
	<script type="text/javascript">
		//ek function gonderilmek istenirse diye eklendi fbs 20100628
		//hataya neden oldugu icin kapatildi 20120828
		<!--- <cfif isDefined("attributes.call_function") and Len(attributes.call_function)>
			window.opener.<cfoutput>#attributes.call_function#</cfoutput>; --->
		<cfif isdefined("attributes.cid")>
			window.close();
			opener.location.reload();
		<cfelseif not isDefined("attributes.no_function")>
			window.opener.list_content_id_yukle();
		</cfif>
		window.close();
	</script>
	<cfabort>
</cfif>
<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<cfif isdefined("attributes.form_submitted")>
    <cfsearch
        name = "get_content_relation"
        collection = "wiki_contents"
        criteria = "#attributes.keyword#"
        contextpassages = "1"
        suggestions="always"
        status="info"
        category="#content_cat_id#">
</cfif>
<!---  META_DESCRIPTIONS.META_HEAD'e göre ilgili wikiler çekildi --->
<cfif get_content_relation.recordcount>
    <cfquery name="get_cont_rel_2" dbtype="query">
        SELECT
            *   
        FROM
            get_content_relation 
        WHERE
            1=1
            <cfif len(attributes.keyword)>
                AND (TITLE LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar">
                OR custom1 LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar">
                OR SUMMARY LIKE <cfqueryparam value="%#attributes.keyword#%" cfsqltype="cf_sql_varchar">)
            </cfif>
            <cfif len(attributes.meta_desc)>
                AND custom3 LIKE <cfqueryparam value="%#attributes.meta_desc#%" cfsqltype="cf_sql_varchar">
            </cfif>
            <cfif len(attributes.chapters)>
                AND custom4 LIKE <cfqueryparam value="%,#attributes.chapters#,%" cfsqltype="cf_sql_varchar">
            </cfif>
            <cfif len(attributes.lang)>
                AND custom4 LIKE <cfqueryparam value="%,#attributes.lang#" cfsqltype="cf_sql_varchar">
            </cfif>
    </cfquery>
    <cfif get_cont_rel_2.recordCount>
        <cfset attributes.totalrecords = get_cont_rel_2.recordcount>
    </cfif>
</cfif>

<script type="text/javascript" src="/JS/intranet.js"></script>
<cfif not len(attributes.action_type_id) and not len(attributes.action_type_id)>
    <cfinclude template="../../rules/display/rule_menu.cfm">
</cfif>
<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12">
         <div class="search_group">    
            <cf_box>
                <cfform name="help_search" id="help_search" action="#request.self#?fuseaction=help.wiki" method="post">
                    <cfinput type="hidden" name="action_type" id="action_type"  value="#attributes.action_type#">
                    <cfinput type="hidden" name="action_type_id" id="action_type_id"  value="#attributes.action_type_id#">
                    <input type="hidden" name="form_submitted" id="form_submitted" value="1" />   
                    
                    <cf_box_search more="0">
                        <cfoutput>
                            <div class="form-group title">
                                <cf_get_lang dictionary_id="60722.KURUM İÇİ WİKİ">
                            </div>
                            <div class="form-group">
                                <cfinput type="text" name="keyword" id="keyword" maxlength="100" value="#attributes.keyword#" placeholder="#getLang('','Filtre','57460')#">
                            </div>
                            <div class="form-group">
                                <cfinput type="text" name="meta_desc" id="meta_desc" maxlength="100" value="#attributes.meta_desc#" placeholder="#getLang('','Meta Tanımı','58993')#">
                            </div>
                            <div class="form-group">
                                <cfif len(content_cat_id)>
                                    <cfquery name="get_chapters" datasource="#dsn#">
                                        SELECT
                                            CPT.CHAPTER
                                        FROM
                                            CONTENT_CHAPTER AS CPT
                                        WHERE
                                            CPT.CONTENTCAT_ID = <cfqueryparam value="#content_cat_id#" cfsqltype="cf_sql_integer">
                                        GROUP BY CPT.CHAPTER, CPT.CHAPTER_ID
                                        ORDER BY CPT.CHAPTER
                                    </cfquery>
                                </cfif>
                                <select name="chapters" id="chapters">
                                    <option value=""><cf_get_lang dictionary_id='57995.Bölüm'></option>
                                    <cfif isDefined("get_chapters")>
                                        <cfloop query="get_chapters">
                                            <option value="#CHAPTER#" <cfif attributes.chapters eq get_chapters.CHAPTER>selected</cfif>>#CHAPTER#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>
                            <div class="form-group">
                                <select id="lang" name="lang">
                                    <option value=""><cf_get_lang dictionary_id='58996.Dil'></option>
                                    <cfloop query="get_language">
                                        <option value="#language_short#" <cfif attributes.lang eq language_short>selected="selected"</cfif>>#language_set#</option>
                                    </cfloop>
                                </select>
                            </div>
                            <div class="form-group small">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="4">
                            </div>
                            <div class="form-group">
                                <cf_wrk_search_button button_type="4" search_function="control()">
                            </div>
                            <div class="form-group">
                                <a class="ui-btn ui-btn-gray" href="#request.self#?fuseaction=content.list_content&event=add" target="_blank" title="<cf_get_lang dictionary_id="35036.Yeni içerik oluştur">"><i class="fa fa-plus"></i></a>
                            </div>
                        </cfoutput>
                    </cf_box_search>
                  <!---   <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_box_search_detail>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="form-group" id="item-cont_catid">
                                    <label><cf_get_lang dictionary_id='57486.Kategori'></label>
                                    <cfif fusebox.circuit eq 'training_management'>
                                        <cfset attributes.is_training = 1>
                                    <cfelse>
                                        <cfset attributes.is_training = 0>
                                    </cfif>
                                    <cfset GET_CONTENT_CAT = getComponent.GET_CONTENT_CAT()>
                                    <cfif fusebox.circuit eq 'training_management'>
                                        <cfset attributes.is_training = 1>
                                    <cfelse>
                                        <cfset attributes.is_training = 0>
                                    </cfif>
                                    <cf_wrk_selectlang
                                        name="cont_catid"
                                        width="130"
                                        option_name="contentcat"
                                        option_value="contentcat_id"
                                        onchange="showChapter(this.value);"
                                        table_name="CONTENT_CAT"
                                        value="#iif(isdefined("attributes.cntid"),"get_content.CONTENTCAT_ID",DE(""))#"
                                        condition="CONTENTCAT_ID <> 0 AND CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = #session.ep.company_id# OR COMPANY_ID IS NULL) AND IS_TRAINING =#attributes.is_training#">
                                </div>
                                <div class="form-group" id="item-chapter_id">
                                    <label><cf_get_lang dictionary_id='57995.Bölüm'></label>
                                    <div id="chapter_place">
                                        <cf_wrk_selectlang
                                            name="chapter"
                                            width="130"
                                            option_name="chapter"
                                            option_value="chapter_id"
                                            table_name="CONTENT_CHAPTER"
                                            value="#iif(isdefined("attributes.cntid"),"get_content.chapter_id",DE(""))#">
                                    </div>
                                </div>
                                <div class="form-group" id="item-content_property_id">
                                    <label><cf_get_lang dictionary_id='57630.Tip'></label>
                                    <div >
                                        <cf_wrk_combo
                                                name="content_property_id"
                                                query_name="GET_CONTENT_PROPERTY"
                                                option_name="name"
                                                option_value="content_property_id"
                                                value="#iif(isdefined("attributes.cntid"),"get_content.content_property_id",DE(""))#"
                                                width="100">	  
                                    </div>
                                </div>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id="58996.Dil"></label>
                                    <select name="help_language" id="help_language">
                                        <!--- <option value=""><cfoutput><cf_get_lang dictionary_id='57734.Seçiniz'></cfoutput></option> --->
                                        <cfoutput query="get_help_language">
                                            <option value="#language_short#" <cfif get_help_language.language_short eq attributes.help_language>selected</cfif>>#language_set#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57482.Aşama'></label>
                                    <select name="stage_id" id="stage_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_content_process_stages"> 
                                            <option value="#stage_name#" <cfif isdefined("attributes.stage_id") and len(attributes.stage_id) and (attributes.stage_id eq stage_id)>selected</cfif>>#stage_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id="58924.Sıralama"></label>
                                    <select name="is_order_by" id="is_order_by">
                                        <option value="0" <cfif 0 eq attributes.is_order_by> selected</cfif>> <cf_get_lang dictionary_id="49203.Konu Başlığına Göre Alfabetik"></option>
                                        <option value="1" <cfif 1 eq attributes.is_order_by> selected</cfif>> <cf_get_lang dictionary_id="38328.Güncellemeye Göre Azalan"></option>
                                    </select>               
                                </div>
                            </div>
                        </cf_box_search_detail>
                    </div> --->
                </cfform>
            </cf_box>
        </div>

        <cfif isDefined("get_cont_rel_2") and get_cont_rel_2.recordcount>
            <cfoutput query="get_cont_rel_2" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <div class="forum_item flex-col">
                    <div class="reply_item">
                        <p class="name">
                            <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#key#" target="_blank">
                                #title#
                                
                            </a>
                            <span>
                                <cfset dates =listToArray(custom3,",",false,true)>
                                <cfloop from="#ArrayLen(dates)#" to="1" index="i">
                                    <cfset date = date_add('h',session.ep.time_zone,dates[i])>
                                    #Dateformat(date,dateformat_style)# #Timeformat(date,timeformat_style)#
                                <cfbreak>
                                </cfloop>
                            </span>
                        </p>
                        <p class="text">#custom1#</p>
                    <cfset meta = Replace(custom2,","," / ","all")>
                    <cfif meta is not ' / '>
                        <cfset  metaes=listToArray(custom2,",",false,true)>
                        <cfif arrayLen(metaes)>
                            <p class="text">
                                <b>#metaes[1]# : </b>
                                <cfloop from="2" to="#ArrayLen(metaes)#"  index="i">
                                    <cfif metaes[i] is metaes.last()>
                                        #metaes[i]#
                                    <cfelse>
                                        #metaes[i]#,
                                    </cfif>
                                </cfloop>
                            </p>
                        </cfif>
                    </cfif>
                    <p class="category">
                        <span>
                            <cfset  content_property=listToArray(custom4,",",false,true)>
                            #content_property[1]# / #content_property[2]#
                            <cfif isNumeric(content_property.last())>
                                <cfquery name="Get_type" datasource="#DSN#">
                                    SELECT NAME FROM CONTENT_PROPERTY WHERE CONTENT_PROPERTY_ID=#content_property.last()#
                                </cfquery>
                                / #get_type.name#
                            </cfif>
                            <cfif arrayLen(dates) gte 2>
                                -
                                <cfloop from="2" to="#ArrayLen(dates)#"  index="i">
                                    <cfif dates[i] is dates.last()>
                                        #dates[i]#
                                    <cfelse>
                                        #dates[i]#,
                                    </cfif>
                                </cfloop>
                            </cfif>
                        </span>
                        <a class="read_more" href="#request.self#?fuseaction=content.list_content&event=det&cntid=#key#" target="_blank"><i class="fa fa-pencil"></i>
                            <cf_get_lang dictionary_id='57464.Güncelle'></a>
                        <cfif len(attributes.action_type_id) and len(attributes.action_type_id)>
                            <a class="read_more" class="title pull-right margin-left-5" href="#request.self#?fuseaction=help.wiki&cid=#key#&form_submitted=1&action_type_id=#attributes.action_type_id#&action_type=#attributes.action_type#" title="<cf_get_lang dictionary_id='
                            57909.İlişkilendir.'>" alt="<cf_get_lang dictionary_id='
                            57909.İlişkilendir.'>"><i class="fa fa cube"></i><cf_get_lang dictionary_id='
                            57909.İlişkilendir.'></a>
                        </cfif>
                    </p>
                    </div>
                </div>                                  
            </cfoutput>
        <cfelse>
            <cfif isDefined('attributes.form_submitted') and attributes.form_submitted eq 1>
                <div class="ui-form-list">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
                        <div class="training_item">
                            <p class="text"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</p>
                            <cfif isDefined("info.SuggestedQuery") and len(info.SuggestedQuery)>
                                <p class="text"><cf_get_lang dictionary_id='60909.Bunu mu demek istediniz ?'> <cfoutput><a href="#request.self#?fuseaction=help.wiki&form_submitted=1&keyword=#info.SuggestedQuery#" style="color:red">#info.SuggestedQuery#</a></cfoutput></p>
                            </cfif>
                        </div>
                    </div>
                </div>
            </cfif>
        </cfif>                 
        <cfif attributes.maxrows lt attributes.totalrecords>
                
            <cfset adres = attributes.fuseaction>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                <cfset adres = adres&"&keyword=#attributes.keyword#">
            </cfif>
            <cfif isDefined("attributes.help") and len(attributes.help)>
                <cfset adres = adres&"&help=#attributes.help#">
            </cfif>
            <cfif isDefined("attributes.is_order_by") and len(attributes.is_order_by)>
                <cfset adres = adres&"&is_order_by=#attributes.is_order_by#">
            </cfif>
            <cfif isDefined("attributes.lang") and len(attributes.lang)>
                <cfset adres = adres&"&lang=#attributes.lang#">
            </cfif>
            <cfif isDefined("attributes.chapters") and len(attributes.chapters)>
                <cfset adres = adres&"&chapters=#attributes.chapters#">
            </cfif>
            <cfif isDefined("attributes.meta_desc") and len(attributes.meta_desc)>
                <cfset adres = adres&"&meta_desc=#attributes.meta_desc#">
            </cfif>
            <cfif isDefined("attributes.form_submitted") and len(attributes.form_submitted)>
                <cfset adres = adres&"&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cf_box>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#"
                >
        </cfif>    
        </div>
    </div>
</div>
<script type="text/javascript">

    function showChapter(cont_catid)	
	{
		var cont_catid = document.getElementById('cont_catid').value;
		if (cont_catid != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=content.popup_ajax_list_chapter&cont_catid="+cont_catid;
			AjaxPageLoad(send_address,'chapter_place',1,'İlişkili Bölümler');
		}
    }
    function control(){
      var x= $( "select#chapter option:checked" ).text();
      $( "select#chapter option:checked" ).attr("value", x);

      var y= $( "select#content_property_id option:checked" ).text();
      $( "select#content_property_id option:checked" ).attr("value", y);
      return true;
    }
</script>