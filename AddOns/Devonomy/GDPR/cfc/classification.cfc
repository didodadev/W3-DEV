<!---
    File: 
    Author: Devonomy-TolgaS <tolga@devonomy.com> 
    Date: 
    Description:
		
--->
<cfcomponent displayname="data classifaciton fonksiyonlar" output="false">
    <!---
    verilen dsn için GDPRClassificationWords tablosundaki ifadelerin olduğu tablo kolonlarını listeler	
    --->
    <cfscript>
        dsn = application.SystemParam.SystemParam().dsn;
    </cfscript>
    <cffunction name="add_classification" access="public" returntype="boolean">
        <cfargument name="data_officer_id" type="numeric" required="true">
        <cfargument name="classification_type_id" type="numeric" required="true">
        <cfargument name="data_category_id" type="numeric" required="true">
        <cfargument name="sensitivity_label_id" type="numeric" required="true">
        <cfargument name="db_name" type="string" default="">
        <cfargument name="schema_name" type="string" default="">
        <cfargument name="table_name" type="string" default="">
        <cfargument name="column_name" type="string" default="">
        <cfargument name="file_path" type="string" default="">
        <cfargument name="classification_description" default="" type="string">
        <cfargument name="data_fuseaction" default="" type="string">
        <cfargument name="key_column" default="" type="string">
        <cfargument name="plevne_door" default="0" type="numeric">

       <cftry>
        <cfquery name="add_classification" datasource="#dsn#">
            INSERT INTO	GDPR_CLASSIFICATION
            (
                DATA_OFFICER_ID,
                CLASSIFICATION_TYPE_ID,
                DATA_CATEGORY_ID,
                SENSITIVITY_LABEL_ID,
                DB_NAME,
                SCHEMA_NAME,
                TABLE_NAME,
                COLUMN_NAME,
                FILE_PATH,
                CLASSIFICATION_DESCRIPTION,
                PLEVNE_DOOR,
                KEY_COLUMN,
                FUSEACTION,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
           ValueS
           (
            <cfqueryparam value="#data_officer_id#" cfsqltype="cf_sql_numeric">,
            <cfqueryparam value="#classification_type_id#" cfsqltype="cf_sql_numeric">,
            <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_numeric">,
            <cfqueryparam value="#sensitivity_label_id#" cfsqltype="cf_sql_numeric">,
            <cfif len(db_name)><cfqueryparam value="#db_name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
            <cfif len(schema_Name)><cfqueryparam value="#schema_Name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
            <cfif len(table_Name)><cfqueryparam value="#table_Name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
            <cfif len(column_Name)><cfqueryparam value="#column_Name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
            <cfif len(file_path)><cfqueryparam value="#file_path#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
            <cfqueryparam value="#CLASSIFICATION_DESCRIPTION#" cfsqltype="cf_sql_nvarchar">,
            <cfif plevne_door gt 0><cfqueryparam value="#plevne_door#" cfsqltype="cf_sql_numeric"><cfelse>NULL</cfif>,
            <cfif len(key_column)><cfqueryparam value="#key_column#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
            <cfif len(data_fuseaction)><cfqueryparam value="#data_fuseaction#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
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

    <cffunction name="upd_classification" access="public" returntype="boolean">
        <cfargument name="data_officer_id" type="numeric" required="true">
        <cfargument name="classification_id" type="numeric" required="true">
        <cfargument name="classification_type_id" type="numeric" required="true">
        <cfargument name="data_category_id" type="numeric" required="true">
        <cfargument name="sensitivity_label_id" type="numeric" required="true">
        <cfargument name="db_name" type="string" default="">
        <cfargument name="schema_name" type="string" default="">
        <cfargument name="table_name" type="string" default="">
        <cfargument name="column_name" type="string" default="">
        <cfargument name="file_path" type="string" default="">
        <cfargument name="classification_description" type="string" default="">
        <cfargument name="data_fuseaction" default="" type="string">
        <cfargument name="key_column" default="" type="string">
        <cfargument name="plevne_door" default="0" type="numeric">
        <cftry>
        <cfquery name="get_classification" datasource="#dsn#">
            UPDATE GDPR_CLASSIFICATION
            SET
                CLASSIFICATION_TYPE_ID = <cfqueryparam value="#classification_type_id#" cfsqltype="cf_sql_numeric">,
                DATA_CATEGORY_ID = <cfqueryparam value="#DATA_CATEGORY_ID#" cfsqltype="cf_sql_numeric">,
                SENSITIVITY_LABEL_ID = <cfqueryparam value="#sensitivity_label_id#" cfsqltype="cf_sql_numeric">,
                DB_NAME = <cfif len(db_name)><cfqueryparam value="#db_name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                SCHEMA_NAME = <cfif len(schema_Name)><cfqueryparam value="#schema_Name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                TABLE_NAME = <cfif len(table_Name)><cfqueryparam value="#table_Name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                COLUMN_NAME = <cfif len(column_Name)><cfqueryparam value="#column_Name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                FILE_PATH = <cfif len(file_path)><cfqueryparam value="#file_path#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                CLASSIFICATION_DESCRIPTION = <cfqueryparam value="#CLASSIFICATION_DESCRIPTION#" cfsqltype="cf_sql_nvarchar">,
                PLEVNE_DOOR = <cfif plevne_door gt 0><cfqueryparam value="#plevne_door#" cfsqltype="cf_sql_numeric"><cfelse>NULL</cfif>,
                KEY_COLUMN = <cfif len(key_column)><cfqueryparam value="#key_column#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                FUSEACTION = <cfif len(data_fuseaction)><cfqueryparam value="#data_fuseaction#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                UPDATE_IP =  <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
           WHERE
                DATA_OFFICER_ID = <cfqueryparam value="#data_officer_id#" cfsqltype="cf_sql_numeric">
                AND CLASSIFICATION_ID = <cfqueryparam value="#classification_id#" cfsqltype="cf_sql_numeric">
        </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>
    <cffunction name="del_classification" access="public" returntype="boolean">
        <cfargument name="data_officer_id" type="numeric" required="true">
        <cfargument name="classification_id" type="numeric" required="true">
        <cftry>
            <cfquery name="del_category_type_byId" datasource="#dsn#">
                DELETE
                FROM 
                    GDPR_CLASSIFICATION
                WHERE 
                    CLASSIFICATION_ID = <cfqueryparam value="#classification_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_classification" access="public" returntype="query">
        <cfargument name="data_officer_id" type="numeric" required="true">
        <cfargument name="keyword" type="string" default="">
        <cfargument name="classification_type_id" default="1" type="numeric">
       
        <cfquery name="get_classification" datasource="#dsn#">
            SELECT 
                C.*,
                GDPR_DATA_CATEGORIES.DATA_CATEGORY,
                T3.SENSITIVITY_LABEL
            FROM 
                GDPR_CLASSIFICATION AS C
                INNER JOIN GDPR_DATA_CATEGORIES ON GDPR_DATA_CATEGORIES.DATA_CATEGORY_ID = C.DATA_CATEGORY_ID
                INNER JOIN  GDPR_SENSITIVITY_LABEL AS T3 ON T3.SENSITIVITY_LABEL_ID = C.SENSITIVITY_LABEL_ID
            WHERE
                C.DATA_OFFICER_ID = <cfqueryparam value="#data_officer_id#" cfsqltype="cf_sql_numeric">
                <cfif len(classification_type_id)>
                   AND C.CLASSIFICATION_TYPE_ID = <cfqueryparam value="#classification_type_id#" cfsqltype="cf_sql_numeric">
                </cfif>
                <cfif len(keyword)>
                    AND ( 
                        C.COLUMN_NAME Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                        OR C.FILE_PATH Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                        OR C.CLASSIFICATION_DESCRIPTION Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                    )
                </cfif>
        </cfquery>
        <cfreturn get_classification />
    </cffunction>

    <cffunction name="get_classification_maxId" access="public" returntype="numeric">
        <cfargument name="data_officer_id" type="numeric" required="true">
        <cfquery name="get_classification_maxId" datasource="#dsn#">
        SELECT 
           MAX(CLASSIFICATION_ID) CLASSIFICATION_ID
        FROM 
            GDPR_CLASSIFICATION
        WHERE DATA_OFFICER_ID = <cfqueryparam value="#data_officer_id#" cfsqltype="cf_sql_numeric">
       </cfquery>
        <cfreturn get_classification_maxId.CLASSIFICATION_ID />
    </cffunction>

    <cffunction name="get_classification_byId" access="public" returntype="query">
        <cfargument name="classification_id" type="numeric" required="true">
       <cftry>
            <cfquery name="get_classification" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_CLASSIFICATION
            WHERE 
                CLASSIFICATION_ID = <cfqueryparam value="#classification_id#" cfsqltype="cf_sql_integer">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_classification />
    </cffunction>

</cfcomponent>
