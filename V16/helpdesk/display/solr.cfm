<cfcollection  action="list" name="collections">
<cfset collection=[]>
    <cfoutput query="collections">
        <cfscript>
            ArrayAppend(collection,  name, "true"); 
        </cfscript> 
    </cfoutput>
<cfinclude template="../../helpdesk/query/get_help.cfm">
<cfif isdefined("attributes.form_submitted") and isdefined("attributes.index_id") and index_id eq 1>
    <cfif not ArrayFind(collection, 'wiki_contents')>
        <cfcollection collection="wiki_contents" action="create" path="gettemplatepath()&\V16\helpdesk\display\list_helpdesk.cfm">
    </cfif>
    <cfindex
        query="GET_HELP"
        collection="wiki_contents"
        action="refresh"
        type="Custom"
        key="CONTENT_ID"
        title="CONT_HEAD"
        body="CONT_HEAD,CONT_SUMMARY,CONT_BODY,META_KEYWORDS,META_TITLE,META_DESC_HEAD,CONTENTCAT,CHAPTER,CONTENT_PROPERTY_ID,LANGUAGE_SHORT,RECORD_DATE"
        status="status"
        custom1="CONT_SUMMARY"
        custom2="META_TITLE,META_KEYWORDS"
        custom3="RECORD_DATE,META_DESC_HEAD"
        custom4="CONTENTCAT,CHAPTER,CHAPTER_ID,CONTENT_PROPERTY_ID,LANGUAGE_SHORT"
        category="CONTENTCAT_ID,CHAPTER,NAME,LANGUAGE_ID,PROCESS_STAGE"
    >
    <script type="text/javascript">
        if (confirm("Kurum içi wiki güncellendi. Wikilere gözat!")) {
            window.location.href = "<cfoutput>#request.self#?fuseaction=help.wiki</cfoutput>";
        } 
    </script>
<cfelseif isdefined("attributes.form_submitted") and isdefined("attributes.index_id") and index_id eq 2 and ArrayFind(collection, 'wiki_coll')>
    <cfquery name="get_content2" datasource="#dsn#">
            SELECT
                C.CONTENT_ID,
                C.CONT_HEAD,
                C.CONT_BODY,
                C.CONT_SUMMARY,
                CI.CONTIMAGE_SMALL,
                CI.CNT_IMG_NAME,
                CK.KEYWORD,
                CCH.CHAPTER_ID,
                C.LANGUAGE_ID,
                COALESCE(CSLI.ITEM,CCH.CHAPTER) AS CHAPTER
            FROM 
                CONTENT C 
                LEFT JOIN CONTENT_IMAGE CI ON C.CONTENT_ID = CI.CONTENT_ID
                LEFT JOIN CONTENT_KEYWORDS CK ON C.CONTENT_ID = CK.CONTENT_ID       
                LEFT JOIN CONTENT_CHAPTER CCH ON C.CHAPTER_ID = CCH.CHAPTER_ID
                LEFT JOIN CONTENT_CAT CC ON  CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID
                LEFT JOIN SETUP_LANGUAGE_INFO CSLI 
                        ON CSLI.UNIQUE_COLUMN_ID = CCH.CHAPTER_ID 
                        AND CSLI.COLUMN_NAME ='CHAPTER'
                        AND CSLI.TABLE_NAME = 'CONTENT_CHAPTER'
                
            WHERE 		
                C.INTERNET_VIEW = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND
                C.STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="-2"> AND
                CC.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="49">
            ORDER BY 
                C.CONT_HEAD ASC
        </cfquery>
        <cfindex
            collection="wiki"
            action="delete">
        <cfindex
            query="get_content2"
            collection="wiki"
            action="refresh"
            type="Custom"
            key="CONTENT_ID"
            title="CONT_HEAD"
            body="CONT_HEAD,CHAPTER,CONT_BODY,CONT_SUMMARY,CONTIMAGE_SMALL,CNT_IMG_NAME,KEYWORD"
            custom1 = "LANGUAGE_ID"
            custom2 = "KEYWORD"
            custom3 = "CHAPTER_ID"
            custom4 = "CONT_SUMMARY"
        > 
    <script type="text/javascript">
        if (confirm("Kurum içi wiki güncellendi. Wikilere gözat!")) {
            location.href = "https://wiki.workcube.com";
        } 
    </script>
</cfif>
<cfquery name="get_kurum_wiki_date" datasource="#dsn#" maxrows="1">
    SELECT RECORD_DATE, UPDATE_DATE FROM CONTENT ORDER BY CONTENT_ID DESC
</cfquery>
<cfset kurum_wiki_date=get_kurum_wiki_date.record_date>
<cfif len(get_kurum_wiki_date.update_date)>
    <cfset kurum_wiki_date=get_kurum_wiki_date.update_date>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='61021.SOLR'></cfsavecontent>
    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57911.Run'></cfsavecontent>
    <cf_box title="#head#">
        <cfform name="solr" id="solr" action="" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1" />   
            <input type="hidden" name="index_id" id="index_id" value="" />  
            <cf_grid_list>
                <thead>
                    <tr>
                        <th>#</th>
                        <th><cf_get_lang dictionary_id='61270.Index Name'></th>
                        <th><cf_get_lang dictionary_id='62341.İçerik Sayısı'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id='57911.Run'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput>
                        <tr>
                            <td>1</td>
                            <td><cf_get_lang dictionary_id='60722.INHOUSE WIKI'></td>
                            <td>#get_help.recordcount#</td>
                            <td>#dateformat(kurum_wiki_date,dateformat_style)#</td>
                            <td><cf_wrk_search_button button_type="2" button_name="#message#" search_function="solrIndex(1)"></td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><cf_get_lang dictionary_id='61271.Workcube Wiki'></td>
                            <td>#get_content.recordcount#</td>
                            <td>#dateformat(now(),dateformat_style)#</td>
                            <td><cf_wrk_search_button button_type="2" button_name="#message#" search_function="solrIndex(2)"></td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function solrIndex(id){
        $('#index_id').val(id);
    }
</script>