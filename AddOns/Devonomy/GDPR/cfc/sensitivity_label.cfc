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
    <cffunction name="add_sensitivity_label" access="public" returntype="boolean">
        <cfargument name="sensitivity_label" type="string" required="true">
        <cfargument name="sensitivity_label_description" type="string" required="true">
       <cftry>
            <cfquery name="add_query" datasource="#dsn#">
                INSERT INTO GDPR_SENSITIVITY_LABEL
                    (
                        SENSITIVITY_LABEL,
                        SENSITIVITY_LABEL_DESCRIPTION,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam value="#sensitivity_label#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#sensitivity_label_description#" cfsqltype="cf_sql_nvarchar">,
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
    <cffunction name="upd_sensitivity_label" access="public" returntype="boolean">
        <cfargument name="sensitivity_label_id" type="numeric" required="true">
        <cfargument name="sensitivity_label" type="string" required="true">
        <cfargument name="sensitivity_label_description" type="string" required="true">
        <cftry>
            <cfquery name="upd_query" datasource="#dsn#">
                UPDATE GDPR_SENSITIVITY_LABEL
                 SET  
                    SENSITIVITY_LABEL = <cfqueryparam value="#sensitivity_label#" cfsqltype="cf_sql_nvarchar">,
                    SENSITIVITY_LABEL_DESCRIPTION = <cfqueryparam value="#sensitivity_label_description#" cfsqltype="cf_sql_nvarchar">,
                    UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                    UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                    UPDATE_IP =  <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                WHERE 
                   SENSITIVITY_LABEL_ID = <cfqueryparam value="#sensitivity_label_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_sensitivity_label" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="">      
            <cfquery name="get_sensitivity_label" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                GDPR_SENSITIVITY_LABEL
                <cfif len(keyword)>
                WHERE 
                    SENSITIVITY_LABEL Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                    OR SENSITIVITY_LABEL_DESCRIPTION Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                </cfif>
            </cfquery>
       
        <cfreturn get_sensitivity_label />
    </cffunction>
    <cffunction name="get_sensitivity_label_byId" access="public" returntype="query">
        <cfargument name="sensitivity_label_id" type="numeric" required="true">
       
        <cfquery name="get_sensitivity_label_byId" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                GDPR_SENSITIVITY_LABEL
            WHERE 
                SENSITIVITY_LABEL_ID = <cfqueryparam value="#sensitivity_label_id#" cfsqltype="cf_sql_numeric">
        </cfquery>

        <cfreturn get_sensitivity_label_byId />
    </cffunction>
    <cffunction name="get_sensitivity_label_maxId" access="public" returntype="numeric">
            <cfquery name="get_sensitivity_label_maxId" datasource="#dsn#">
            SELECT 
               MAX(SENSITIVITY_LABEL_ID) SENSITIVITY_LABEL_ID
            FROM 
                GDPR_SENSITIVITY_LABEL
           </cfquery>

        <cfreturn get_sensitivity_label_maxId.SENSITIVITY_LABEL_ID />
    </cffunction>
    <cffunction name="del_data_category_type_byId" access="public" returntype="boolean">
        <cfargument name="sensitivity_label_id" type="numeric" required="true">
            <cfquery name="del_sensitivity_label_byId" datasource="#dsn#">
            DELETE
            FROM 
                GDPR_SENSITIVITY_LABEL
            WHERE 
                SENSITIVITY_LABEL_ID = <cfqueryparam value="#sensitivity_label_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfreturn true />
    </cffunction>
</cfcomponent>
