<cfcomponent displayname="WROControl">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = application.systemParam.systemParam().dsn&"_product">
    
    <cffunction name="getWatalogyGoogleProductCat" returntype="any" description="Webservise bağlanıp Watalogy Ürün Kategorilerini getirir" returnformat="JSON">
        <cfargument name="keyword" default="">
        <cfargument name="hierarchy" default="">
        <cfset return_value = structNew() />
        <cftry>
            <cfhttp url="http://watalogy.workcube.com/web_services/watalogyWebServices.cfc?method=getWatalogyCategories" result="response" charset="utf-8">
                <cfif len(arguments.keyword)>
                    <cfhttpparam name="keyword" type="formfield" value="#arguments.keyword#">
                </cfif>
                <cfif len(arguments.hierarchy)>
                    <cfhttpparam name="hierarchy" type="formfield" value="#arguments.hierarchy#">
                </cfif>
            </cfhttp>
            <cfset return_value = deserializeJSON(response.Filecontent)>
            <cfcatch type="any">
                <cfset return_value.STATUS = false>
            </cfcatch>
        </cftry>
        <cfreturn return_value>
    </cffunction>

    <cffunction name="getWatalogyGoogleProductCatNameByID" returntype="any" description="Webservise bağlanıp Watalogy Ürün Kategori ID ile kategori adını getirir" returnformat="JSON">
        <cfargument name="cat_id" default="">
        <cfset return_value = structNew() />
        <cfset return_value.STATUS = true>
        <cftry>
            <cfhttp url="http://watalogy.workcube.com/web_services/watalogyWebServices.cfc?method=getWatalogyCategoryNameByID" result="response" charset="utf-8">
                <cfhttpparam name="cat_id" type="formfield" value="#arguments.cat_id#">
            </cfhttp>
            <cfset return_value.DATA = deserializeJSON(response.Filecontent)>
            <cfcatch type="any">
                <cfset return_value.STATUS = false>
            </cfcatch>
        </cftry>
        <cfreturn return_value>
    </cffunction>
    <cffunction name="getCategories" returntype="any">
        <cfargument name="keyword" default="">
        <cfargument name="hierarchy" default="">
        <cfargument name="first_category" default="">
            <cfquery name="getWatalogyCategories" datasource="#dsn1#">
                SELECT 
                    GOOGLE_PRODUCT_CAT_ID,
                    CATEGORY_NAME AS TOP_CATEGORY_NAME,
                    HIERARCHY,
                    CATEGORY1,
                    CATEGORY2,
                    CATEGORY3,
                    CATEGORY4
                    CATEGORY5,
                    CATEGORY6,
                    CATEGORY7
                FROM
                    WATALOGY_GOOGLE_PRODUCT_CAT
                WHERE
                    1=1 
                    <cfif len(arguments.keyword)>
                        AND (
                            CATEGORY1 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%"> OR
                            CATEGORY2 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%"> OR
                            CATEGORY3 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%"> OR
                            CATEGORY4 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%"> OR
                            CATEGORY5 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%"> OR
                            CATEGORY6 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%"> OR
                            CATEGORY7 LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%">
                        )
                    </cfif>
                    <cfif len(arguments.first_category)>
                        AND CATEGORY2 IS NULL AND CATEGORY3  IS NULL AND CATEGORY4  IS NULL AND CATEGORY5  IS NULL AND CATEGORY6  IS NULL AND CATEGORY7  IS NULL
                    </cfif>
                    <cfif len(arguments.hierarchy)>
                        AND HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.hierarchy#.%">
                    </cfif>
                ORDER BY HIERARCHY
            </cfquery>
            
        <cfreturn getWatalogyCategories>
    </cffunction>

</cfcomponent>