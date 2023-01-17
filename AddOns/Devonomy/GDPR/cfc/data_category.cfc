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
    <cffunction name="add_data_category" access="public" returntype="boolean">
        <cfargument name="data_category" type="string" required="true">
        <cfargument name="data_category_description" type="string" required="true">
        <cfargument name="data_category_type_id" type="string" required="true">
        <cfargument name="sensitivity_label_id" type="string" required="true">
        <cfargument name="is_active" default="True" type="boolean" required="true">
       <cftry>
            <cfquery name="add_query" datasource="#dsn#">
                INSERT INTO GDPR_DATA_CATEGORIES
                    (
                        DATA_CATEGORY,
                        DATA_CATEGORY_DESCRIPTION,
                        DATA_CATEGORY_TYPE_ID,
                        SENSITIVITY_LABEL_ID,
                        IS_ACTIVE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam value="#data_category#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_category_description#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_category_type_id#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#sensitivity_label_id#" cfsqltype="cf_sql_numeric">,
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

    <cffunction name="upd_data_category" access="public" returntype="boolean">
        <cfargument name="data_category" type="string" required="true">
        <cfargument name="data_category_description" type="string" required="true">
        <cfargument name="data_category_type_id" type="string" required="true">
        <cfargument name="sensitivity_label_id" type="string" required="true">
        <cfargument name="is_active" default="True" type="boolean" required="true">
       <cftry>
            <cfquery name="upd_query" datasource="#dsn#">
                UPDATE GDPR_DATA_CATEGORIES
                 SET 
                        DATA_CATEGORY = <cfqueryparam value="#data_category#" cfsqltype="cf_sql_nvarchar">,
                        DATA_CATEGORY_DESCRIPTION = <cfqueryparam value="#data_category_description#" cfsqltype="cf_sql_nvarchar">,
                        DATA_CATEGORY_TYPE_ID = <cfqueryparam value="#data_category_type_id#"  cfsqltype="cf_sql_numeric">,
                        SENSITIVITY_LABEL_ID = <cfqueryparam value="#sensitivity_label_id#"  cfsqltype="cf_sql_numeric">,
                        IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">,
                        UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                        UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                        UPDATE_IP =  <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                WHERE
                    DATA_CATEGORY_ID = <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_data_category" access="public" returntype="query">
        <cfargument name="keyword" default="" type="string">
        <cfargument name="data_category_type_id" default="0" type="numeric">
        <cfargument name="sensitivity_label_id" type="numeric" default="0">
        <cfargument name="is_active" default="True" type="string">
        
        <cfquery name="get_data_category" datasource="#dsn#">
        SELECT 
            T1.*,
            T2.DATA_CATEGORY_TYPE,
            T3.SENSITIVITY_LABEL
        FROM 
            GDPR_DATA_CATEGORIES AS T1
            INNER JOIN  GDPR_DATA_CATEGORIES_TYPE AS T2 ON T2.DATA_CATEGORY_TYPE_ID = T1.DATA_CATEGORY_TYPE_ID
            LEFT JOIN  GDPR_SENSITIVITY_LABEL AS T3 ON T3.SENSITIVITY_LABEL_ID = T1.SENSITIVITY_LABEL_ID
        WHERE
            1=1
            <cfif len(is_active)>
                AND T1.IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">
            </cfif>
            <cfif data_category_type_id gt 0>
                AND T1.DATA_CATEGORY_TYPE_ID = <cfqueryparam value="#data_category_type_id#" cfsqltype="cf_sql_numeric">
            </cfif>
            <cfif len(keyword)>
                AND T1.DATA_CATEGORY Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
            </cfif>
            <cfif sensitivity_label_id gt 0>
                AND T1.SENSITIVITY_LABEL_ID = <cfqueryparam value="#sensitivity_label_id#" cfsqltype="cf_sql_numeric">
            </cfif>
        </cfquery>
        <cfreturn get_data_category />
    </cffunction>

    <cffunction name="get_data_category_byId" access="public" returntype="query">
        <cfargument name="data_category_id" type="numeric" required="true">
       
            <cfquery name="get_data_category" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_DATA_CATEGORIES
            WHERE 
                DATA_CATEGORY_ID = <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_integer">                
            </cfquery>
            <cftry>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_data_category />
    </cffunction>

    <cffunction name="get_data_category_maxId" access="public" returntype="numeric">
        <cfquery name="get_data_category_maxId" datasource="#dsn#">
        SELECT 
           MAX(DATA_CATEGORY_ID) DATA_CATEGORY_ID
        FROM 
            GDPR_DATA_CATEGORIES
       </cfquery>

        <cfreturn get_data_category_maxId.DATA_CATEGORY_ID />
    </cffunction>

    <cffunction name="del_data_category_byId" access="public" returntype="boolean">
        <cfargument name="data_category_id" type="numeric" required="true">
            <cfquery name="del_data_category_byId" datasource="#dsn#">
            DELETE
            FROM 
                GDPR_DATA_CATEGORIES
            WHERE 
                DATA_CATEGORY_ID = <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfreturn true />
    </cffunction>
</cfcomponent>