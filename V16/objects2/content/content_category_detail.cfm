<cfparam name="attributes.keyword" default="">
<cfsearch 
    name="get_content" 
    collection="wiki" 
    criteria="#attributes.keyword#" 
    suggestions="Always" 
    contextPassages="15"
    contextHighlightBegin = "<span class='text-highlight'>"
    contextHighlightEnd = "</span>"
    status="searchinfo"
>
<cfif get_content.recordcount>
    <cfquery name="get_content" dbtype="query">
        SELECT
            *   
        FROM
            get_content 
        WHERE
            custom1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> 
             <cfif isDefined("attributes.param_2") and len(attributes.param_2)>
                AND custom3 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.param_2#">
            </cfif>
    </cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='10'>
<cfparam name="attributes.totalrecords" default='#get_content.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset url_str="">
<cfif isdefined("attributes.param_1") and len(attributes.param_1)>
    <cfset url_str = "#url_str#/#attributes.param_1#">
</cfif>
<cfif isdefined("attributes.param_2") and len(attributes.param_2)>
    <cfset url_str = "#url_str#/#attributes.param_2#">
</cfif>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
    <cfset url_str = "#url_str#?keyword=#attributes.keyword#">
</cfif>

<section id="wiki_app">
    <div class="row">
        <cfif attributes.view_type eq 1>
            <ul class="list-group list-group-flush col-12 col-sm-12 col-md-10 col-lg-9">
                <li class="list-group-item px-0 py-0 aos-init">
                    <a href="" class="text-decoration-none">
                        <h5 class="text-primary mb-0" style="color: #FF9800!important;font-size: 23px;">
                            <cf_get_lang dictionary_id='57697.Kütüphane'>  
                            <cfif isDefined("attributes.param_2") and len(attributes.param_2)>
                                <cfquery name="get_chapter" datasource="#dsn#">
                                    SELECT
                                       ITEM
                                    FROM  
                                        SETUP_LANGUAGE_INFO 
                                    WHERE
                                        COLUMN_NAME ='CHAPTER'
                                        AND TABLE_NAME = 'CONTENT_CHAPTER'
                                        AND LANGUAGE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
                                        AND UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.param_2#">
                                </cfquery>
                                / <cfoutput>#get_chapter.ITEM#</cfoutput>
                            </cfif>
                        </h5>
                    </a>
                </li>
            </ul>
            <ul class="list-group list-group-flush col-12 col-sm-12 col-md-11 col-lg-11 px-1 py-2">
                <cfif get_content.recordCount>
                    <cfoutput query="get_content" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <li class="list-group-item px-0 aos-init">
                            <a href="#site_language_path#/detail/#key#" class="text-decoration-none">
                                <h5 class="text-primary mb-0">#title#</h5>
                                <p class="text-muted pt-1">#custom4#</p>
                                <cfquery name="get_chapter" datasource="#dsn#">
                                    SELECT
                                       ITEM
                                    FROM  
                                        SETUP_LANGUAGE_INFO 
                                    WHERE
                                        COLUMN_NAME ='CHAPTER'
                                        AND TABLE_NAME = 'CONTENT_CHAPTER'
                                        AND LANGUAGE =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
                                        AND UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#custom3#">
                                </cfquery>
                                <small class="text-success h6"><span class="badge badge-info">#get_chapter.item#</span></small>
                                <cfif len(custom2)><label>#custom2#</label></cfif>
                            </a>
                        </li>
                    </cfoutput>
                <cfelse>
                    <cfif isDefined("searchinfo.SuggestedQuery") and len(searchinfo.SuggestedQuery)>
                        <p class="text pl-3"><cf_get_lang dictionary_id='60909.Bunu mu demek istediniz ?'> <cfoutput><a href="#site_language_path#/category_detail?keyword=#searchinfo.SuggestedQuery#" style="color:red">#searchinfo.SuggestedQuery#</a></cfoutput></p>
                        <cfelse>
                            <cf_get_lang dictionary_id='57936.Aradığınız Kriterlere Uygun Kayıt Bulunamadı'>.
                    </cfif>
                    
                </cfif>
            </ul>
        <cfelse>
            <cfoutput query="get_content">
                <div class="col-lg-3 col-md-4 col-sm-6 col-12">
                    <div class="card mb-3">
                        <div class="card-body">
                            <h5 class="card-title"><a href="#site_language_path#/detail/#key#">#title#</a></h5>
                            <p class="card-text">#custom4#</p>
                            <cfif len(custom2)><label>#custom2#</label></cfif>
                        </div>
                    </div>
                </div>
            </cfoutput>
        </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <table width="99%" cellpadding="0" cellspacing="0" border="0" align="center" height="35" class="table">
                <tr>
                    <td><cf_pages page="#attributes.page#"
                        maxrows="#attributes.maxrows#"
                        totalrecords="#attributes.totalrecords#"
                        startrow="#attributes.startrow#"
                        adres="#url_str#">
                        <!--- font_type="1"> --->
                    </td>
                    <td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'> : #attributes.totalrecords#&nbsp;-&nbsp; <cf_get_lang dictionary_id='57581.Sayfa'> :#attributes.page#/#lastpage#</cfoutput></td>
                </tr>
            </table>
        </cfif>
    </div>
</section>
