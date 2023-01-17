<!---
    File: 
    Author: Devonomy-TolgaS <tolga@devonomy.com>
    Date: 
    Description:
		
--->
<cfcomponent displayname="" output="false">
    <cfscript>
        dsn = application.SystemParam.SystemParam().dsn;
    </cfscript>
    <cffunction name="add_data_subject_group" access="public" returntype="boolean">
        <cfargument name="data_subject_group" type="string" required="true">
        <cfargument name="data_subject_group_description" type="string" required="true">
        <cfargument name="is_active" default="True" type="boolean">
       <cftry>
            <cfquery name="add_query" datasource="#dsn#">
                INSERT INTO GDPR_DATA_SUBJECT_GROUP
                    (
                        DATA_SUBJECT_GROUP,
                        DATA_SUBJECT_GROUP_DESCRIPTION,
                        IS_ACTIVE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam value="#data_subject_group#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_subject_group_description#" cfsqltype="cf_sql_nvarchar">,
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
    <cffunction name="upd_data_subject_group" access="public" returntype="boolean">
        <cfargument name="data_subject_group_id" type="numeric" required="true">
        <cfargument name="data_subject_group" type="string" required="true">
        <cfargument name="data_subject_group_description" type="string" required="true">
        <cfargument name="is_active" default="True" type="boolean">
        <cftry>
            <cfquery name="upd_query" datasource="#dsn#">
                UPDATE GDPR_DATA_SUBJECT_GROUP
                 SET  
                    DATA_SUBJECT_GROUP = <cfqueryparam value="#data_subject_group#" cfsqltype="cf_sql_nvarchar">,
                    DATA_SUBJECT_GROUP_DESCRIPTION = <cfqueryparam value="#data_subject_group_description#" cfsqltype="cf_sql_nvarchar">,
                    IS_ACTIVE =  <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">,
                    UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                    UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                    UPDATE_IP =  <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                WHERE 
                    DATA_SUBJECT_GROUP_ID = <cfqueryparam value="#data_subject_group_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_data_subject_group" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="">    
        <cfargument name="is_active" default="True" type="string">
            <cfquery name="get_data_subject_group" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                GDPR_DATA_SUBJECT_GROUP
            WHERE
                1=1
                <cfif len(is_active)>
                    AND IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">
                </cfif>
                <cfif len(keyword)>
                    AND ( DATA_SUBJECT_GROUP Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                        OR DATA_SUBJECT_GROUP_DESCRIPTION Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                        )
                </cfif>
            </cfquery>
       
        <cfreturn get_data_subject_group />
    </cffunction>
    <cffunction name="get_data_subject_group_byId" access="public" returntype="query">
        <cfargument name="data_subject_group_id" type="numeric" required="true">
       
        <cfquery name="get_data_subject_group_byId" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                GDPR_DATA_SUBJECT_GROUP
            WHERE 
                DATA_SUBJECT_GROUP_ID = <cfqueryparam value="#data_subject_group_id#" cfsqltype="cf_sql_numeric">
        </cfquery>

        <cfreturn get_data_subject_group_byId />
    </cffunction>
    <cffunction name="get_data_subject_group_maxId" access="public" returntype="numeric">
            <cfquery name="get_data_subject_group_maxId" datasource="#dsn#">
            SELECT 
               MAX(DATA_SUBJECT_GROUP_ID) DATA_SUBJECT_GROUP_ID
            FROM 
                GDPR_DATA_SUBJECT_GROUP
           </cfquery>

        <cfreturn get_data_subject_group_maxId.DATA_subject_GROUP_ID />
    </cffunction>
    <cffunction name="del_data_category_type_byId" access="public" returntype="boolean">
        <cfargument name="data_subject_group_id" type="numeric" required="true">
            <cfquery name="del_data_subject_group_byId" datasource="#dsn#">
            DELETE
            FROM 
                GDPR_DATA_SUBJECT_GROUP
            WHERE 
                DATA_SUBJECT_GROUP_ID = <cfqueryparam value="#data_subject_group_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfreturn true />
    </cffunction>
</cfcomponent>
