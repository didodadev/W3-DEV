<!---
    File: 
    Author: 
    Date: 
    Description:
		
--->
<cfcomponent displayname="" output="false">
    <cfscript>
        dsn = application.SystemParam.SystemParam().dsn;
    </cfscript>
    <cffunction name="add_classification_keyword" access="public" returntype="boolean">
        <cfargument name="keyword" type="string" required="true">
        <cfargument name="data_category_id" type="numeric" required="true">
        <cfargument name="keyword_type" type="numeric" required="true">
        <cfargument name="search_type" type="numeric" required="true">
        <cfargument name="is_active" default="True" type="boolean" required="true">
       <cftry>
            <cfquery name="add_classification_keyword" datasource="#dsn#">
                INSERT INTO 
                    GDPR_CLASSIFICATION_KEYWORDS
                    (
                        KEYWORD,
                        DATA_CATEGORY_ID,
                        KEYWORD_TYPE,
                        SEARCH_TYPE,
                        IS_ACTIVE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam value="#keyword#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#keyword_type#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#search_type#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">,
                        <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                        <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                    )
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>
    <cffunction name="upd_classification_keyword" access="public" returntype="boolean">
        <cfargument name="keyword_id" type="numeric" required="true">
        <cfargument name="keyword" type="string" required="true">
        <cfargument name="data_category_id" type="numeric" required="true">
        <cfargument name="search_type" type="numeric" required="true">
        <cfargument name="keyword_type" type="numeric" required="true">
        <cfargument name="is_active" default="True" type="boolean" required="true">
        <cftry>
            <cfquery name="upd_classification_keyword" datasource="#dsn#">
                UPDATE GDPR_CLASSIFICATION_KEYWORDS
                 SET  
                    KEYWORD = <cfqueryparam value="#keyword#" cfsqltype="cf_sql_nvarchar">,
                    DATA_CATEGORY_ID = <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_numeric">,
                    KEYWORD_TYPE = <cfqueryparam value="#keyword_type#" cfsqltype="cf_sql_numeric">,
                    SEARCH_TYPE = <cfqueryparam value="#search_type#" cfsqltype="cf_sql_numeric">,
                    IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">,
                    UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                    UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                    UPDATE_IP = <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
               WHERE
                    KEYWORD_ID  = <cfqueryparam value="#keyword_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_classification_keyword" access="public" returntype="query">
        <cfargument name="keyword" type="string">
        <cfargument name="data_category_id" default="0" type="numeric">
        <cfargument name="keyword_type" >
        <cfargument name="is_active" default="True" type="string">
       
            <cfquery name="get_classification_keyword" datasource="#dsn#">
            SELECT 
                T1.*,
                T2.DATA_CATEGORY,
                T2.DATA_CATEGORY_DESCRIPTION
            FROM 
                GDPR_CLASSIFICATION_KEYWORDS AS T1
                INNER JOIN GDPR_DATA_CATEGORIES AS T2 ON T1.DATA_CATEGORY_ID = T2.DATA_CATEGORY_ID
            WHERE
                1=1
                <cfif len(is_active)>
                    AND T1.IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">
                </cfif>
                <cfif isDefined("keyword_type") and len(keyword_type)>
                    AND T1.KEYWORD_TYPE = <cfqueryparam value="#keyword_type#" cfsqltype="cf_sql_numeric">
                </cfif>
                <cfif isDefined("keyword") and len(keyword)>
                    AND T1.KEYWORD Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                </cfif>
                <cfif isDefined("data_category_id") and data_category_id gt 0>
                   AND T1.DATA_CATEGORY_ID = <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_numeric">
                </cfif>
            </cfquery>
            <cftry>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_classification_keyword />
    </cffunction>
    <cffunction name="get_classification_keyword_maxId" access="public" returntype="numeric">
        <cfquery name="get_classification_keyword_maxId" datasource="#dsn#">
        SELECT 
           MAX(KEYWORD_ID) KEYWORD_ID
        FROM 
            GDPR_CLASSIFICATION_KEYWORDS
       </cfquery>

        <cfreturn get_classification_keyword_maxId.KEYWORD_ID />
    </cffunction>
    <cffunction name="get_classification_keyword_byId" access="public" returntype="query">
        <cfargument name="keyword_id" type="numeric">
       <cftry>
            <cfquery name="get_classification_keyword" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_CLASSIFICATION_KEYWORDS
            WHERE 
                KEYWORD_ID = <cfqueryparam value="#keyword_id#" cfsqltype="cf_sql_integer">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_classification_keyword />
    </cffunction>
    
</cfcomponent>