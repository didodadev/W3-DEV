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
    <cffunction name="add_data_precaution" access="public" returntype="boolean">
        <cfargument name="data_precaution" type="string" required="true">
        <cfargument name="data_precaution_type" type="numeric" required="true">
        <cfargument name="data_precaution_description" type="string" required="true">
        <cfargument name="is_active" default="True" type="boolean" required="true">
       <cftry>
            <cfquery name="add_query" datasource="#dsn#">
                INSERT INTO GDPR_DATA_PRECAUTION
                    (
                        DATA_PRECAUTION,
                        DATA_PRECAUTION_TYPE,
                        DATA_PRECAUTION_DESCRIPTION,
                        IS_ACTIVE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam value="#data_precaution#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_precaution_type#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#data_precaution_description#" cfsqltype="cf_sql_nvarchar">,
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
    <cffunction name="upd_data_precaution" access="public" returntype="boolean">
        <cfargument name="data_precaution_id" type="numeric" required="true">
        <cfargument name="data_precaution_type" type="numeric" required="true">
        <cfargument name="data_precaution" type="string" required="true">
        <cfargument name="data_precaution_description" type="string" required="true">
        <cfargument name="is_active" default="True" type="boolean" required="true">
        <cftry>
            <cfquery name="upd_query" datasource="#dsn#">
                UPDATE GDPR_DATA_PRECAUTION
                 SET  
                    DATA_PRECAUTION = <cfqueryparam value="#data_precaution#" cfsqltype="cf_sql_nvarchar">,
                    DATA_PRECAUTION_TYPE = <cfqueryparam value="#data_precaution_type#" cfsqltype="cf_sql_numeric">,
                    DATA_PRECAUTION_DESCRIPTION = <cfqueryparam value="#data_precaution_description#" cfsqltype="cf_sql_nvarchar">,
                    IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">,
                    UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                    UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                    UPDATE_IP =  <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                WHERE 
                    DATA_PRECAUTION_ID = <cfqueryparam value="#data_precaution_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_data_precaution" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="">
        <cfargument name="type" type="string" default="">
        <cfargument name="is_active" default="True" type="string">
       
            <cfquery name="get_data_precaution" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                GDPR_DATA_PRECAUTION
            WHERE
            1=1
                <cfif len(is_active)>
                    AND IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">
                </cfif>
                <cfif len(type)>
                    AND DATA_PRECAUTION_TYPE = <cfqueryparam value="#data_precaution_type#" cfsqltype="cf_sql_numeric">
                </cfif>
                <cfif len(keyword)>
                    AND DATA_PRECAUTION Like <cfqueryparam value="%#data_precaution#%" cfsqltype="cf_sql_nvarchar">
                    AND DATA_PRECAUTION_DESCRIPTION Like <cfqueryparam value="%#data_precaution_description#%" cfsqltype="cf_sql_nvarchar">
                </cfif>
            </cfquery>
       
        <cfreturn get_data_precaution />
    </cffunction>
    <cffunction name="get_data_precaution_byId" access="public" returntype="query">
        <cfargument name="data_precaution_id" type="numeric" required="true">
       
            <cfquery name="get_data_precaution_byId" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                GDPR_DATA_PRECAUTION
            WHERE 
                DATA_PRECAUTION_ID = <cfqueryparam value="#data_precaution_id#" cfsqltype="cf_sql_numeric">
            </cfquery>

        <cfreturn get_data_precaution_byId />
    </cffunction>
    <cffunction name="get_data_precaution_maxId" access="public" returntype="numeric">
        <cfquery name="get_data_precaution_maxId" datasource="#dsn#">
            SELECT 
               MAX(DATA_PRECAUTION_ID) DATA_PRECAUTION_ID
            FROM 
                GDPR_DATA_PRECAUTION
        </cfquery>

        <cfreturn get_data_precaution_maxId.DATA_PRECAUTION_ID />
    </cffunction>
    <cffunction name="del_data_precaution_byId" access="public" returntype="boolean">
        <cfargument name="data_precaution_id" type="numeric" required="true">
            <cfquery name="del_data_precaution_byId" datasource="#dsn#">
            DELETE
            FROM 
                GDPR_DATA_PRECAUTION
            WHERE 
                DATA_PRECAUTION_ID = <cfqueryparam value="#data_precaution_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfreturn true />
    </cffunction>
</cfcomponent>
