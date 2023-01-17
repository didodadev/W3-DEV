<cfcomponent>
     <cfset dsn = application.systemParam.systemParam().dsn>
     <cfset dateformat_style = session.ep.dateformat_style>
     <cfif dateformat_style is 'dd/mm/yyyy'>
     	<cfset dateformat_style_ = 'dd/MM/yyyy'>
     <cfelse>
     	<cfset dateformat_style_ = 'MM/dd/yyyy'>
     </cfif>
     
    <!--- Sites List --->
    <cffunction name="GET_SITES" access="remote" returntype="query">
        <cfquery name="GET_SITES" datasource="#dsn#">        	
			SELECT
            	SITE_ID,
                SITE_NAME,
                SITE_PATH
             FROM 
             	B2B2C_SITES    
        </cfquery>
        <cfreturn GET_SITES>
    </cffunction> 
    
    <!--- Sites List JSON--->
    <cffunction name="GET_SITES_JSON" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_SITES" datasource="#dsn#">        	
			SELECT
            	SITE_ID,
                SITE_NAME,
                SITE_PATH
             FROM 
             	B2B2C_SITES    
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_SITES),'//','')>
    </cffunction>
    
    <!--- Sites Update --->
    <cffunction name="sites_update" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.primary)>
        	<cfquery name="GET_SITESUPDATE" datasource="#dsn#">        	
                UPDATE
                    B2B2C_SITES
                SET
                    SITE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITE_NAME#">,
                    SITE_PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITE_PATH#">                
                WHERE 
                    SITE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#"> 
            </cfquery>
        	<cfset returnData =1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    
    <!--- Sites Add --->
    <cffunction name="sites_add_new" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.SITE_NAME) and len(arguments.SITE_PATH)>
        	<cfquery name="GET_SITESNEW" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    B2B2C_SITES (SITE_NAME, SITE_PATH)
                VALUES
                	(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITE_NAME#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITE_PATH#">)
            </cfquery>
        	<cfset returnData = #query_result.identitycol#> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>  
    
    <!--- Sites Del --->
    <cffunction name="sites_delete" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.primary)>
        	<cfquery name="GET_SITESUPDATE" datasource="#dsn#">	
                DELETE FROM B2B2C_SITES WHERE SITE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#">
            </cfquery>
        	<cfset returnData = 1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>

     <!--- PAGES List --->
        <cffunction name="GET_PAGES" access="remote" returntype="query">
            <cfquery name="GET_PAGES" datasource="#dsn#">        	
                SELECT
                    PAGE_ID, SITE_ID, PAGE_FRIENDLY_URL, PAGE_HEAD
                FROM 
                    B2B2C_PAGES 
            </cfquery>
            <cfreturn GET_PAGES>
        </cffunction> 

     <!--- PAGES Update --->
    <cffunction name="pages_update" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.primary)>
        	<cfquery name="GET_PAGESUPDATE" datasource="#dsn#">        	
                UPDATE
                    B2B2C_PAGES
                SET
                    SITE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITE_ID#">,
                    PAGE_FRIENDLY_URL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAGE_FRIENDLY_URL#">,
                    PAGE_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAGE_HEAD#">                              
                WHERE 
                    PAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#"> 
            </cfquery>
        	<cfset returnData =1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    
    <!--- PAGES Add --->
    <cffunction name="pages_add_new" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.SITE_ID) and len(arguments.PAGE_HEAD)>
        	<cfquery name="GET_PAGESNEW" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    B2B2C_PAGES (SITE_ID, PAGE_FRIENDLY_URL, PAGE_HEAD)
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.SITE_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAGE_FRIENDLY_URL#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAGE_HEAD#">
                    )
            </cfquery>
        	<cfset returnData = #query_result.identitycol#> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>  
    
    <!--- PAGES Del --->
    <cffunction name="pages_delete" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.primary)>
        	<cfquery name="GET_PAGESUPDATE" datasource="#dsn#">	
                DELETE FROM B2B2C_PAGES WHERE PAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#">
            </cfquery>
        	<cfset returnData = 1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    
    <!--- COMPONENT List --->
        <cffunction name="GET_COMPONENT" access="remote" returntype="query">
            <cfquery name="GET_COMPONENT" datasource="#dsn#">        	
                SELECT
                    COMPONENT_ID, PAGE_ID, COMPONENT_NAME, PATH
                FROM 
                    B2B2C_COMPONENTS 
            </cfquery>
            <cfreturn GET_COMPONENT>
        </cffunction> 

     <!--- COMPONENT Update --->
    <cffunction name="component_update" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.primary)>
        	<cfquery name="GET_COMPONENTUPDATE" datasource="#dsn#">        	
                UPDATE
                    B2B2C_COMPONENTS
                SET
                    PAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAGE_ID#">,
                    COMPONENT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.COMPONENT_NAME#">,
                    PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PATH#">                              
                WHERE 
                    COMPONENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#"> 
            </cfquery>
        	<cfset returnData =1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    
    <!--- COMPONENT Add --->
    <cffunction name="component_add_new" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.PAGE_ID) and len(arguments.PATH)>
        	<cfquery name="GET_PAGESNEW" datasource="#dsn#" result="query_result">	
                INSERT INTO
                    B2B2C_COMPONENTS  (PAGE_ID, COMPONENT_NAME, PATH)
                VALUES
                	(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PAGE_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.COMPONENT_NAME#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PATH#">
                    )
            </cfquery>
        	<cfset returnData = #query_result.identitycol#> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>  
    
    <!--- COMPONENT Del --->
    <cffunction name="component_delete" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.primary)>
        	<cfquery name="GET_PAGESUPDATE" datasource="#dsn#">	
                DELETE FROM B2B2C_COMPONENTS WHERE COMPONENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#">
            </cfquery>
        	<cfset returnData = 1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>

    <!--- Category List --->
    <cffunction name="GET_CATES" access="remote" returntype="query">
        <cfquery name="GET_CATES" datasource="#dsn#">        	
			SELECT
                CONTENTCAT_ID,
            	CONTENTCAT,
                CONTENTCAT_ALT1,
                LANGUAGE_ID
             FROM 
             	CONTENT_CAT   
        </cfquery>
        <cfreturn GET_CATES>
    </cffunction> 

    <!--- Category Add --->
    <cffunction name="cates_add_new" access="remote" returntype="any" returnFormat="json">
        <cfif len(arguments.primary) and len(arguments.CONTENTCAT) and len(arguments.LANGUAGE_ID)>
            <cfquery name="INSCONTENTCAT" datasource="#dsn#" result="query_result">
                INSERT INTO 
                    CONTENT_CAT
                (
                    CONTENTCAT,
                    CONTENTCAT_ALT1,
                    LANGUAGE_ID,
                    RECORD_IP,
                    RECORD_DATE,
                    RECORD_EMP
                ) 
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CONTENTCAT#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CONTENTCAT_ALT1#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.LANGUAGE_ID#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    #now()#,
                    #session.ep.userid#
                )           
            </cfquery>
        	<cfset returnData = #query_result.identitycol#> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>        
    </cffunction>

    <!--- Category Update --->
    <cffunction name="cates_update" access="remote" returntype="any" returnFormat="json">
        <cfif len(arguments.primary)>
            <cfquery name="GET_CATESUPDATE" datasource="#dsn#">        	
                UPDATE
                    CONTENT_CAT
                SET
                    CONTENTCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CONTENTCAT#">,
                    CONTENTCAT_ALT1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CONTENTCAT_ALT1#">,  
                    LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.LANGUAGE_ID#">          
                WHERE 
                    CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#"> 
            </cfquery>
            <cfset returnData =1> 
        <cfelse>
            <cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    
    <!--- Post ADD --->    
    <cffunction name="post_add_new" access="remote" returntype="any" returnFormat="json">
    	<cfset postBody = arguments.postBody>
         <cf_date tarih="arguments.postStartDate">
        <cf_date tarih="arguments.postFinishDate">
        <cf_date tarih="arguments.postDate">
    	<cfquery name="CONTENT_INST" datasource="#dsn#" result="query_result">
            INSERT INTO 
                CONTENT
            (                
               	CONT_BODY, 
                CONT_SUMMARY, 
                CONT_HEAD, 
                CHAPTER_ID, 
                <cfif len(arguments.postAuthor)>OUTHOR_EMP_ID,</cfif>
                INTERNET_VIEW,
                CONSUMER_CAT,
                CONTENT_STATUS,
                <cfif len(arguments.postDate)>WRITING_DATE,</cfif>
                <cfif len(arguments.postStartDate)>VIEW_DATE_START,</cfif>
                <cfif len(arguments.postFinishDate)> VIEW_DATE_FINISH,</cfif>
                SPOT,
                LANGUAGE_ID,
                RECORD_MEMBER, 
                RECORD_IP,
                RECORD_DATE,
                WRITE_VERSION,
                USER_FRIENDLY_URL
            )
            VALUES 
            (    
    			'#postBody#',
             	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postDescription#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postHead#">,
                #arguments.postChapter#,
                <cfif len(arguments.postAuthor)>#arguments.postAuthor#,</cfif>
                1,
                <cfif len(arguments.postSites)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postSites#">,</cfif>
                #arguments.postStatus#,
                <cfif len(arguments.postDate)>#arguments.postDate#,</cfif>
                <cfif len(arguments.postStartDate)>#arguments.postStartDate#,</cfif>
                <cfif len(arguments.postFinishDate)>#arguments.postFinishDate#,</cfif>
                #arguments.postSpot#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postLanguage#">,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                #Now()#,
                'CONTES',
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postURL#">         
            )
    	</cfquery>
        <cfquery name="ADD_META_DESCRIPTIONS" datasource="#DSN#">
            INSERT INTO
                META_DESCRIPTIONS
                (
                    ACTION_TYPE,
                    ACTION_ID,
                    META_TITLE,
                    META_DESC_HEAD,
                    META_KEYWORDS,
                    LANGUAGE_SHORT,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )	
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="CONTENT_ID">,
                    #query_result.identitycol#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaHead#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaDescription#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaKeyword#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postLanguage#">,
                    #session.ep.userid#,
                    #Now()#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                )
        </cfquery>

        <cfset returnData = #query_result.identitycol#>
        <cfif len(returnData)>
        <cfelse>
        <cfset returnData = 0>
        </cfif>  
        <cfreturn Replace(SerializeJSON(returnData),'//','')>        
    </cffunction>
    
    <!--- Post UPD --->    
    <cffunction name="post_upd" access="remote" returntype="any" returnFormat="json">
    	<cfset postBody = arguments.postBody>
        <cf_date tarih="arguments.postStartDate">
        <cf_date tarih="arguments.postFinishDate">
        <cf_date tarih="arguments.postDate">
    	<cfquery name="CONTENT_UPD" datasource="#dsn#" result="query_result">
        	UPDATE 
            	CONTENT 
           	SET 
            	CONT_BODY='#postBody#',
                CONT_SUMMARY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postDescription#">,
                CONT_HEAD=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postHead#">,
                CHAPTER_ID=#arguments.postChapter#,
                <cfif len(arguments.postAuthor)>OUTHOR_EMP_ID=#arguments.postAuthor#,</cfif>
                <cfif len(arguments.postSites)>CONSUMER_CAT=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postSites#">,</cfif>
                CONTENT_STATUS=#arguments.postStatus#,
                USER_FRIENDLY_URL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postURL#">,
                <cfif len(arguments.postDate)> WRITING_DATE=#arguments.postDate#,</cfif>
                <cfif len(arguments.postStartDate)>VIEW_DATE_START=#arguments.postStartDate#</cfif>,
                <cfif len(arguments.postFinishDate)>VIEW_DATE_FINISH=#arguments.postFinishDate#,</cfif>
                SPOT=#arguments.postSpot#,
                LANGUAGE_ID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postLanguage#">,
                RECORD_MEMBER=#session.ep.userid#,
                RECORD_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#remote_addr#">,
                RECORD_DATE=#Now()#                
            WHERE
            	CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postId#"> 
    	</cfquery>
        <cfquery name="CONTROL_META_DESCRIPTIONS" datasource="#DSN#">
            SELECT ACTION_ID FROM META_DESCRIPTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postId#"> 
        </cfquery>
        <cfif CONTROL_META_DESCRIPTIONS.RecordCount GTE 1>
            <cfquery name="ADD_META_DESCRIPTIONS" datasource="#DSN#">
                UPDATE 
                    META_DESCRIPTIONS 
                SET
                    META_TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaHead#">,
                    META_DESC_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaDescription#">,
                    META_KEYWORDS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaKeyword#">,
                    LANGUAGE_SHORT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postLanguage#">,
                    RECORD_EMP = #session.ep.userid#,
                    RECORD_DATE = #Now()#,
                    RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                WHERE
                    ACTION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postId#">   
            </cfquery>
        <cfelse>
            <cfquery name="ADD_META_DESCRIPTIONS" datasource="#DSN#">
                INSERT INTO
                    META_DESCRIPTIONS
                    (
                        ACTION_TYPE,
                        ACTION_ID,
                        META_TITLE,
                        META_DESC_HEAD,
                        META_KEYWORDS,
                        LANGUAGE_SHORT,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )	
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="CONTENT_ID">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postId#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaHead#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaDescription#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaKeyword#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postLanguage#">,
                        #session.ep.userid#,
                        #Now()#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
            </cfquery>
        </cfif>        
        <cfset returnData = 1>
        
        <cfreturn Replace(SerializeJSON(returnData),'//','')>        
    </cffunction>
    
     <!--- Post Del --->
        <cffunction name="post_delete" access="remote" returntype="any" returnFormat="json">
            <cfif len(arguments.primary)>
                <cfquery name="GET_POSTDELETE" datasource="#dsn#">	
                    DELETE FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#">
                    DELETE FROM META_DESCRIPTIONS WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.primary#">
                </cfquery>
                <cfset returnData = 1> 
            <cfelse>
                <cfset returnData =0>           
            </cfif>
            <cfreturn Replace(SerializeJSON(returnData),'//','')>
        </cffunction>    
    
    <!--- Post List JSON--->
    <cffunction name="GET_POST_JSON" access="remote" returntype="string" returnFormat="json">        
        <cfif isDefined('arguments.record_count') and len(arguments.record_count) >
            <cfquery name="GET_POST" datasource="#dsn#">    
        	    SELECT
                    PT.CONTENT_ID 
                FROM 
                    CONTENT AS PT
                WHERE
                    1=1
                    <cfif isDefined('arguments.searchKey') and len(arguments.searchKey)>
                        AND PT.CONT_HEAD LIKE '%#arguments.searchKey#%'
                    </cfif>
                    <cfif isDefined('arguments.postStatus') and len(arguments.postStatus)>
                        AND PT.CONTENT_STATUS = '#arguments.postStatus#'
                    </cfif>
                    <cfif isDefined('arguments.postSpot') and len(arguments.postSpot)>
                        AND PT.SPOT = '#arguments.postSpot#'
                    </cfif>
                    <cfif isDefined('arguments.postChapter') and len(arguments.postChapter)  and arguments.postChapter neq 'null'>
                        AND PT.CHAPTER_ID = '#arguments.postChapter#'
                    </cfif>                   
                    <cfif isDefined('arguments.postLanguage') and len(arguments.postLanguage)  and arguments.postLanguage neq 'null'>
                        AND PT.LANGUAGE_ID = '#arguments.postLanguage#'
                    </cfif>                    
                    <cfif isDefined('arguments.postSites') and len(arguments.postSites) and arguments.postSites neq 'null'>
                        AND PT.CONSUMER_CAT = '#arguments.postSites#'
                    </cfif>  
            </cfquery>
            <cfreturn Replace(serializeJSON(GET_POST.RecordCount),'//','')>
        <cfelse>
            <cfquery name="GET_POST" datasource="#dsn#">    
                SELECT
                    PT.CONT_BODY, 
                    PT.CONT_SUMMARY, 
                    PT.CONT_HEAD, 
                    PT.CHAPTER_ID,
                    POST_CHAPTER.CONTENTCAT_ID,
                    PT.OUTHOR_EMP_ID,
                    EMP.EMPLOYEE_NAME + ' ' + EMP.EMPLOYEE_SURNAME AS Author,
                    PT.INTERNET_VIEW,
                    PT.CONSUMER_CAT,
                    PT.CONTENT_STATUS,
                    FORMAT(PT.WRITING_DATE, '#dateformat_style_#') AS WRITING_DATE,
                    FORMAT(PT.VIEW_DATE_START, '#dateformat_style_#') AS VIEW_DATE_START,
                    FORMAT(PT.VIEW_DATE_FINISH, '#dateformat_style_#') AS VIEW_DATE_FINISH,
                    PT.SPOT,
                    PT.LANGUAGE_ID,
                    PT.CONTENT_ID,
                    MD.META_TITLE,
                    MD.META_DESC_HEAD,
                    MD.META_KEYWORDS,
                    PT.USER_FRIENDLY_URL
                FROM 
                    CONTENT AS PT
                    LEFT JOIN CONTENT_CHAPTER AS POST_CHAPTER ON POST_CHAPTER.CHAPTER_ID = PT.CHAPTER_ID
                    LEFT JOIN EMPLOYEES AS EMP ON PT.OUTHOR_EMP_ID = EMP.EMPLOYEE_ID
                    LEFT JOIN META_DESCRIPTIONS AS MD ON PT.CONTENT_ID = MD.ACTION_ID        
                WHERE
                    1=1
                    <cfif isDefined('arguments.postId') and len(arguments.postId)>
                    AND PT.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postId#">  
                    </cfif>
                    <cfif isDefined('arguments.searchKey') and len(arguments.searchKey)>
                        AND PT.CONT_HEAD LIKE '%#arguments.searchKey#%'
                    </cfif>
                    <cfif isDefined('arguments.postStatus') and len(arguments.postStatus)>
                        AND PT.CONTENT_STATUS = '#arguments.postStatus#'
                    </cfif>
                    <cfif isDefined('arguments.postSpot') and len(arguments.postSpot)>
                        AND PT.SPOT = '#arguments.postSpot#'
                    </cfif>
                    <cfif isDefined('arguments.postChapter') and len(arguments.postChapter)  and arguments.postChapter neq 'null'>
                        AND PT.CHAPTER_ID = '#arguments.postChapter#'
                    </cfif>                   
                    <cfif isDefined('arguments.postLanguage') and len(arguments.postLanguage)  and arguments.postLanguage neq 'null'>
                        AND PT.LANGUAGE_ID = '#arguments.postLanguage#'
                    </cfif>                    
                    <cfif isDefined('arguments.postSites') and len(arguments.postSites) and arguments.postSites neq 'null'>
                        AND PT.CONSUMER_CAT = '#arguments.postSites#'
                    </cfif>
                ORDER BY <cfif isDefined('arguments.postSorter') and arguments.postSorter eq 1> PT.CONT_POSITION <cfelse> PT.RECORD_DATE DESC </cfif>
                <cfif isDefined('arguments.page') and len(arguments.page)>
                OFFSET #(arguments.page*25)-25# ROWS FETCH NEXT 25 ROWS ONLY
                </cfif>                   	  
            </cfquery>
            <cfreturn Replace(serializeJSON(GET_POST),'//','')>
        </cfif>  
    </cffunction>
    
    <!--- POST CAT--->
    <cffunction name="GET_POSTCAT_JSON" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_POSTCAT" datasource="#dsn#">        	
			SELECT
            	CONTENTCAT_ID,
                CONTENTCAT,
                LANGUAGE_ID,
                COMPANY_ID
            FROM
            	CONTENT_CAT
            WHERE
            	LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.LANGUAGE_ID#">
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_POSTCAT),'//','')>
    </cffunction>   
    
     <!--- POST CHAPTER--->
    <cffunction name="GET_POSTCHAPTER_JSON" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_CHAPTER" datasource="#dsn#">      
        	SELECT
            	CHAPTER_ID,
                CHAPTER
            FROM
            	CONTENT_CHAPTER
            WHERE
            	CONTENT_CHAPTER_STATUS=1 
                AND CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CONTENTCAT_ID#">  
        </cfquery>
        <cfreturn Replace(serializeJSON(GET_CHAPTER),'//','')>
    </cffunction>  
    
    
    
    
    <!--- USERS JSON--->
    <cffunction name="GET_USERS_JSON" access="remote" returntype="string" returnFormat="json">
        <cfquery name="GET_USERS" datasource="#dsn#">        	
			SELECT 
                E.EMPLOYEE_ID ,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP,
                E.PHOTO,
                E2.SEX                         
            FROM
                EMPLOYEES AS E
                LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = E.EMPLOYEE_ID 
            WHERE
                E.EMPLOYEE_STATUS = 1 and  E.EMPLOYEE_ID >1 
        </cfquery>        
        <cfreturn Replace(serializeJSON(GET_USERS),'//','')>
        
    </cffunction>


    <!--- POST SORTER --->
    <cffunction name="post_sorter" access="remote" returntype="any" returnFormat="json">
    	<cfif len(arguments.sortlist)>
        	<cfquery name="que_post_sorter" datasource="#dsn#">        	
                With SORT As
                (
                    SELECT 
                        ROW_NUMBER() OVER (ORDER  BY CHARINDEX('x'+CAST(CONTENT_ID AS VARCHAR)+'x', '#arguments.sortlistorder#')) AS RN,
                        CONT_POSITION
                    FROM
                        CONTENT
                    WHERE
                        CONTENT_ID IN (#arguments.sortlist#)
                )
                UPDATE SORT SET CONT_POSITION = RN
            </cfquery>
        	<cfset returnData =1> 
        <cfelse>
        	<cfset returnData =0>           
        </cfif>
        <cfreturn Replace(SerializeJSON(returnData),'//','')>
    </cffunction>
    

    
          
</cfcomponent>