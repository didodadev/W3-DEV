
<cfquery name="get_content" datasource="#dsn#">
    SELECT TOP 3
        C.CONTENT_ID,
        C.CONT_HEAD,
        C.CONT_SUMMARY,
        CI.CONTIMAGE_SMALL,
        CI.CNT_IMG_NAME,
        COALESCE(CSLI.ITEM,CCH.CHAPTER) AS CHAPTER,
        C.STAGE_ID 
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
                AND CSLI.LANGUAGE = '#session_base.language#'
        
    WHERE 		
        C.INTERNET_VIEW = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> AND        
        CC.CONTENTCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.category_id#" list="yes">) AND
        C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session_base.language#"> AND 
        <cfif isDefined("attributes.stage_id") and len(attributes.stage_id)>
            C.STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stage_id#"> AND
        </cfif>
        C.CONTENT_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    ORDER BY 
        C.CONTENT_ID DESC
</cfquery>
<cfset images = ['a','b','c'] />
<section id="wiki_app">
    <div class="row">
        <cfoutput query="get_content">
            <div class="col-lg-4 col-md-4 col-sm-6 col-12">
                <div class="card mb-3" style=" border: 1px solid ##dee2e6 !important;">
                <cfif len( CONTIMAGE_SMALL )>
                    <img src="/documents/content/#CONTIMAGE_SMALL#.jpeg" class="card-img-top" alt="...">
                <cfelse>
                    <img src="/images/home_banner_#images[currentrow]#.jpeg" class="card-img-top" alt="...">
                </cfif>
                <div class="card-body">
                    <h5 class="card-title"><a href="#site_language_path#/detail/#CONTENT_ID#">#CONT_HEAD#</a></h5>
                    <p class="card-text" style="font-size: 15px;">#CONT_SUMMARY#</p>
                </div>
                </div>
            </div>
        </cfoutput>
    </div>
</section>