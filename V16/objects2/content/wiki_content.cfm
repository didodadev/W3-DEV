<cfif isDefined("attributes.cid") AND LEN(attributes.cid)>
	<cfset attributes.param_2 = attributes.cid>  
<cfelse>
    <cfset attributes.CNTID  = attributes.param_2>
    <cfset attributes.CNT_RELATION_CNT_MAXROWS = 3>
</cfif>
 <cfquery name="get_content" datasource="#dsn#">
    SELECT TOP 3
        C.CONTENT_ID,
        C.CONT_HEAD,
        C.CONT_SUMMARY,
		C.CONT_BODY,
        COALESCE(CSLI.ITEM,CCH.CHAPTER) AS CHAPTER,
        CCH.CHAPTER_ID
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
        C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.param_2#"> AND
        C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session_base.language#"> AND 
        C.CONTENT_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    ORDER BY 
        C.CONTENT_ID DESC
</cfquery>

<style>
    .list_chapter_item-type2_title {
    font-weight: bold;
        }

        .list_chapter-type2 {
            padding: 5px;
        }
        .list_chapter-type2-card_body{
            border:1px solid rgba(0,0,0,.125);
            border-top:0px;
        }

        .list_chapter_item-type2 {
            background-color: white !important;
            margin-bottom: 15px !important;
        }

        .list_chapter_item-type2_text p {
            margin: 0;
        }
</style>
<div class="mt-1 mt-sm-1 mt-md-1 mt-lg-2 mr-n2">
<!--- <div style="border-right:1.5px solid #e6e6e6;"> --->
    <!--- <div class="row justify-content-center"> --->
    <div class="row mt-1 mt-sm-1 mt-md-1 mt-lg-2">
        <!--- <div class="col-12 col-md-11 px-0"> --->
        <div class="col-12 px-0">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb bg-transparent" itemscope="" itemtype="http://schema.org/BreadcrumbList">
                    <li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem" class="breadcrumb-item">
                        <a itemprop="item" href="/welcome">
                            <span itemprop="name"><cf_get_lang dictionary_id='40794.Anasayfa'></span>
                        </a>
                        <meta itemprop="position" content="1">
                    </li>
                    <li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem" class="breadcrumb-item">
                        <a itemprop="item" href="/welcome">
                            <span itemprop="name"><cf_get_lang dictionary_id='61271.Workcube Wiki'></span>
                        </a>
                        <meta itemprop="position" content="2">
                    </li>
                    <li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem" class="breadcrumb-item">
                        <a itemprop="item" href="<cfoutput>#site_language_path#/category_detail/#get_content.chapter_id#</cfoutput>">
                            <span itemprop="name"><cfoutput>#get_content.CHAPTER#</cfoutput></span>
                        </a>
                        <meta itemprop="position" content="2">
                    </li>
                    <li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem" class="breadcrumb-item active">
                        <span itemprop="item">
                            <span itemprop="name"><cfoutput>#get_content.CONT_HEAD#</cfoutput></span>
                        </span>
                        <meta itemprop="position" content="3">
                    </li>
                </ol>
            </nav>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-12 " style="font-size:15px; text-align: justify; text-justify: inter-word;">
            <cfoutput query="get_content">
                #CONT_BODY#
            </cfoutput>
        </div>
    </div>
</div>