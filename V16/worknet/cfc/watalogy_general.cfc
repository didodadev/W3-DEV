<cfcomponent>
    <cfset dsn = application.SystemParam.SystemParam().dsn>
    <cfset dsn1 = application.SystemParam.SystemParam().dsn&"_product">

    <cffunction name="get_watalogy_google_product_cats" access="public" hint="Get Watalogy Product Categories">
        <cfargument name="keyword" default="">
        <cfquery name="get_watalogy_google_product_cats" datasource="#dsn1#">
            SELECT 
                GOOGLE_PRODUCT_CAT_ID,
                CATEGORY1,
                CATEGORY2,
                CATEGORY3,
                CATEGORY4,
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
            ORDER BY
                CATEGORY1,
                CATEGORY2,
                CATEGORY3,
                CATEGORY4,
                CATEGORY5,
                CATEGORY6,
                CATEGORY7
        </cfquery>
        <cfreturn get_watalogy_google_product_cats>
    </cffunction>

</cfcomponent>