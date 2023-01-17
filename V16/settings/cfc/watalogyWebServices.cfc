<cfcomponent extends="cfc.queryJSONConverter">

    <cfset dsn = application.SystemParam.SystemParam().dsn>
    <cfset dsn1 = application.SystemParam.SystemParam().dsn&"_product">

    <cffunction name="returnResponse" returnType="any" access="public" returnformat="JSON">
        <cfargument name="queryResult" type="any" required="yes">

        <cfset response = StructNew() />
        <cfif arguments.queryResult.recordcount>
            <cfset response.status = true />
            <cfset response.data = this.returnData(Replace(serializeJSON(arguments.queryResult),"//","")) />
        <cfelse>
            <cfset response.status = false />
        </cfif>
        <cfreturn Replace(serializeJSON(response),"//","") />
    </cffunction>

    <cffunction name="getWatalogyCategories" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="keyword" default="">
        <cfquery name="getWatalogyCategories" datasource="#dsn1#">
            SELECT 
                GOOGLE_PRODUCT_CAT_ID,
                CATEGORY1 AS TOP_CATEGORY_NAME
            FROM
                WATALOGY_GOOGLE_PRODUCT_CAT
            WHERE
                1=1 
                AND CATEGORY2 IS NULL
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
            ORDER BY GOOGLE_PRODUCT_CAT_ID
        </cfquery>
        <cfreturn this.returnResponse(getWatalogyCategories)/>
    </cffunction>

    <cffunction name="getWatalogyCategories2" access="remote" returntype="any">
        <cfquery name="getWatalogyCategories2" datasource="#dsn1#">
            SELECT 
                GOOGLE_PRODUCT_CAT_ID,
                CATEGORY1 AS TOP_CATEGORY_NAME
            FROM
                WATALOGY_GOOGLE_PRODUCT_CAT
            WHERE
                CATEGORY2 IS NULL
            ORDER BY GOOGLE_PRODUCT_CAT_ID
        </cfquery>
        <cfreturn getWatalogyCategories2/>
    </cffunction>

    <cffunction name="getWatalogyCategoryNameByID" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="cat_id" default="">
        <cfquery name="getWatalogyCategoryNameByID" datasource="#dsn1#">
            SELECT
                CASE
                    WHEN CATEGORY2 IS NULL THEN CATEGORY1
                    WHEN CATEGORY3 IS NULL THEN CATEGORY2
                    WHEN CATEGORY4 IS NULL THEN CATEGORY3
                    WHEN CATEGORY5 IS NULL THEN CATEGORY4
                    WHEN CATEGORY6 IS NULL THEN CATEGORY5
                    WHEN CATEGORY7 IS NULL THEN CATEGORY6
                    ELSE CATEGORY7
                END AS CATEGORY_NAME
            FROM
                WATALOGY_GOOGLE_PRODUCT_CAT
            WHERE
                1=1 
                <cfif len(arguments.cat_id)>
                    AND GOOGLE_PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#">
                </cfif>
        </cfquery>
        <cfreturn Replace(serializeJSON(getWatalogyCategoryNameByID.CATEGORY_NAME),"//","") />
    </cffunction>

    <cffunction name="getWatalogyCategory" access="remote" returntype="any">
        <cfargument name="cat_id" default="">
        <cfquery name="getWatalogyCategory" datasource="#dsn1#">
            SELECT
                CASE
                    WHEN CATEGORY2 IS NULL THEN CATEGORY1
                    WHEN CATEGORY3 IS NULL THEN CATEGORY2
                    WHEN CATEGORY4 IS NULL THEN CATEGORY3
                    WHEN CATEGORY5 IS NULL THEN CATEGORY4
                    WHEN CATEGORY6 IS NULL THEN CATEGORY5
                    WHEN CATEGORY7 IS NULL THEN CATEGORY6
                    ELSE CATEGORY7
                END AS CATEGORY_NAME,
                HIERARCHY
            FROM
                WATALOGY_GOOGLE_PRODUCT_CAT
            WHERE
                1=1 
                <cfif len(arguments.cat_id)>
                    AND GOOGLE_PRODUCT_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cat_id#" list="yes">)
                </cfif>
        </cfquery>
        <cfreturn getWatalogyCategory />
    </cffunction>
</cfcomponent>