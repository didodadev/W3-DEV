<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_PROTEIN_SITES" access="remote" returntype="any">
        <cfargument name="site" default="">
        <cfargument name="keyword" default="">
        <cfargument name="page_id" default="">
        <cfargument name="index" default="">
        <cfargument name="no_follow" default="">
        <cfargument name="no_archive" default="">
        <cfargument name="no_image_index" default="">
        <cfargument name="no_snipped" default="">
        <cfargument name="no_follow_external_links" default="">
        <cfargument name="related_wo" default="">
        <cfquery name="GET_PROTEIN_SITES" datasource="#dsn#">
            SELECT
                UFU.USER_FRIENDLY_URL,
                UFU.ACTION_ID,
                UFU.STATUS,
                UFU.PROTEIN_SITE,
                UFU.OPTIONS_DATA,
                UFU.ACTION_TYPE,
                UFU.PROTEIN_EVENT,
                PS.DOMAIN,
                PS.SITE_ID,
                PP.PAGE_ID,
                PP.TITLE,
                PP.PAGE_DATA,    
                PP.PAGE_ID
            FROM
                USER_FRIENDLY_URLS AS UFU
                LEFT JOIN PROTEIN_SITES  AS PS ON UFU.PROTEIN_SITE = PS.SITE_ID
                LEFT JOIN PROTEIN_PAGES AS PP ON UFU.PROTEIN_PAGE = PP.PAGE_ID
            WHERE
                <cfif isDefined("arguments.is_legacy") and arguments.is_legacy eq 1> 
                    1=1
                    <cfif isDefined("arguments.is_internet") and arguments.is_internet eq 1>
                    AND COALESCE((SELECT CONTENT_STATUS FROM CONTENT WHERE CONTENT_ID = UFU.ACTION_ID),0) = 1
                    AND COALESCE((SELECT INTERNET_VIEW FROM  CONTENT WHERE CONTENT_ID = UFU.ACTION_ID),0) = 1
                    </cfif>
                <cfelse>                
                    UFU.PROTEIN_SITE IS NOT NULL    
                    <cfif isDefined("arguments.site") and len(arguments.site)>
                        AND UFU.PROTEIN_SITE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">
                    </cfif>
                    AND PP.PAGE_DATA NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"related_wo":""%'>                
                    <!--- keyword filter --->
                    <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                        AND  UFU.USER_FRIENDLY_URL LIKE '%#arguments.keyword#%'
                    </cfif>
                    <!--- Pages filter --->
                    <cfif isDefined("arguments.page_id") and len(arguments.page_id)>
                        AND PP.PAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.page_id#">
                    </cfif>
                    <!--- Status Filter --->
                    <cfif isdefined("arguments.status") and arguments.status is 1>AND UFU.STATUS = 1</cfif>
                    <cfif isdefined("arguments.status") and arguments.status is 2>AND UFU.STATUS = 0</cfif>
                    <cfif isdefined("arguments.status") and arguments.status is 3>AND UFU.STATUS = 3</cfif>
                    <cfif isdefined("arguments.status") and arguments.status is 4>AND UFU.STATUS = 4</cfif>
                    <!--- Checkboxes Filter --->
                    <cfif isdefined("arguments.index") and len(arguments.index)>                    
                        AND UFU.OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"index":"1"%'>
                    </cfif>
                    <cfif isdefined("arguments.no_follow") and len(arguments.no_follow)>                    
                        AND UFU.OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"no_follow":"1"%'>
                    </cfif>
                    <cfif isdefined("arguments.no_archive") and len(arguments.no_archive)>                    
                        AND UFU.OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"no_archive":"1"%'>
                    </cfif>
                    <cfif isdefined("arguments.no_image_index") and len(arguments.no_image_index)>                    
                        AND UFU.OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"no_image_index":"1"%'>
                    </cfif>
                    <cfif isdefined("arguments.no_snipped") and len(arguments.no_snipped)>                    
                        AND UFU.OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"no_snipped":"1"%'>
                    </cfif>
                    <cfif isdefined("arguments.no_follow_external_links") and len(arguments.no_follow_external_links)>                    
                        AND UFU.OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"no_follow_external_links":"1"%'>
                    </cfif>
                    <!--- Related Wo Filter --->
                    <cfif isdefined("arguments.related_wo") and len(arguments.related_wo)>                    
                        AND PP.PAGE_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"related_wo":"#arguments.related_wo#"%'>
                    </cfif>
                </cfif>           
        </cfquery>
        <cfreturn GET_PROTEIN_SITES>
    </cffunction>

    <cffunction name="PROTEIN_PAGES" access="remote" returntype="any">
        <cfargument name="site" default="">        
        <cfargument name="page_id" default="">        
        <cfquery name="PROTEIN_PAGES" datasource="#dsn#">
            SELECT               
                PP.TITLE,
                PP.PAGE_DATA,    
                PP.PAGE_ID              
            FROM                
                PROTEIN_PAGES AS PP
            WHERE
                1 = 1
                <cfif isDefined("arguments.site") and len(arguments.site)>
                    AND PP.SITE= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">
                </cfif>
                AND PP.PAGE_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"related_wo":%'>
                AND PP.PAGE_DATA NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"related_wo":""%'>       
        </cfquery>
        <cfreturn PROTEIN_PAGES>
    </cffunction> 

    <cffunction name="PROTEIN_SITES" access="remote" returntype="any">
        <cfargument name="site" default="">              
        <cfquery name="PROTEIN_SITES" datasource="#dsn#">
            SELECT 
                PS.DOMAIN,
                PS.SITE_ID
            FROM
                PROTEIN_SITES AS PS 
            WHERE 
                1 = 1
                <cfif isDefined("arguments.site") and len(arguments.site)>
                    AND PS.SITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.site#">
                </cfif>
        </cfquery>
        <cfreturn PROTEIN_SITES>
    </cffunction> 
</cfcomponent>