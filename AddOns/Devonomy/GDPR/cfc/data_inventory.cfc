<!---
    File: 
    Author: 
    Date: 
    Description:
		
--->
<cfcomponent displayname=""  output="false" accessors="true">
    <cfproperty name="data_officer_id" type="numeric" required="true" setter="true"/>
    <cfscript>
        dsn = application.SystemParam.SystemParam().dsn;
    </cfscript>
    <cffunction name="add_data_inventory" access="public" returntype="boolean">
        <cfargument name="data_inventory" type="string" required="true">
        <cfargument name="data_inventory_description" type="string" required="true">
        <cfargument name="data_inventory_legal_justification" type="string" required="true">
        <cfargument name="data_category_id" type="numeric" required="true">
        <cfargument name="data_subject_group_id" type="numeric" required="true">
        <cfargument name="is_transfer" default="false" type="boolean" required="true">
        <cfargument name="is_foreign_transfer" default="false" type="boolean" required="true"> 
        <cfargument name="storage_type" type="numeric" required="true">
        <cfargument name="period" type="numeric" default="0" >
        <cfargument name="is_active" default="true" type="boolean" required="true">

            <cfquery name="add_data_inventory" datasource="#dsn#">
                INSERT INTO 
                    GDPR_DATA_INVENTORY
                    (
                        DATA_OFFICER_ID,
                        DATA_INVENTORY,
                        DATA_INVENTORY_DESCRIPTION,
                        DATA_INVENTORY_LEGAL_JUSTIFICATION,
                        DATA_CATEGORY_ID,
                        DATA_SUBJECT_GROUP_ID,
                        IS_TRANSFER,
                        IS_FOREIGN_TRANSFER,
                        STORAGE_TYPE,
                        PERIOD,
                        IS_ACTIVE,
                        IS_DELETE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#data_inventory#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_inventory_description#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_inventory_legal_justification#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#data_subject_group_id#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#is_transfer#" cfsqltype="cf_sql_bit">,
                        <cfqueryparam value="#is_foreign_transfer#" cfsqltype="cf_sql_bit">,
                        <cfqueryparam value="#storage_type#" cfsqltype="cf_sql_bit">,
                        <cfif isNumeric(period)><cfqueryparam value="#period#" cfsqltype="cf_sql_numeric"><cfelse>0</cfif>,
                        <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">,
                        <cfqueryparam value="false" cfsqltype="cf_sql_bit">,
                        <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                        <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                        <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
                    )
            </cfquery>
       <cftry>
       <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>
    <cffunction name="upd_data_inventory" access="public" returntype="boolean">
        <cfargument name="data_inventory_id" type="numeric" required="true">
        <cfargument name="data_inventory" type="string" required="true">
        <cfargument name="data_inventory_description" type="string" required="true">
        <cfargument name="data_inventory_legal_justification" type="string" required="true">
        <cfargument name="data_category_id" type="numeric" required="true">
        <cfargument name="data_subject_group_id" type="numeric" required="true">
        <cfargument name="is_transfer" default="true" type="boolean" required="true">
        <cfargument name="is_foreign_transfer" default="true" type="boolean" required="true">
        <cfargument name="storage_type" type="numeric" required="true">
        <cfargument name="period" type="numeric" required="true">
        <cfargument name="is_active" default="true" type="boolean" required="true">
        <cftry>
            <cfquery name="upd_data_inventory" datasource="#dsn#">
                UPDATE GDPR_DATA_INVENTORY
                SET  
                    DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_integer">,
                    DATA_INVENTORY =  <cfqueryparam value="#data_inventory#" cfsqltype="cf_sql_nvarchar">,
                    DATA_INVENTORY_DESCRIPTION = <cfqueryparam value="#data_inventory_description#" cfsqltype="cf_sql_nvarchar">,
                    DATA_INVENTORY_LEGAL_JUSTIFICATION = <cfqueryparam value="#data_inventory_legal_justification#" cfsqltype="cf_sql_nvarchar">,
                    DATA_CATEGORY_ID = <cfqueryparam value="#data_category_id#" cfsqltype="cf_sql_integer">,
                    DATA_SUBJECT_GROUP_ID = <cfqueryparam value="#data_subject_group_id#" cfsqltype="cf_sql_integer">,
                    IS_TRANSFER = <cfqueryparam value="#is_transfer#" cfsqltype="cf_sql_bit">,
                    IS_FOREIGN_TRANSFER = <cfqueryparam value="#is_foreign_transfer#" cfsqltype="cf_sql_bit">,
                    STORAGE_TYPE = <cfqueryparam value="#storage_type#" cfsqltype="cf_sql_integer">,
                    PERIOD = <cfqueryparam value="#period#" cfsqltype="cf_sql_integer">,
                    IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">,
                    IS_DELETE = <cfqueryparam value="false" cfsqltype="cf_sql_bit">,
                    UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                    UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_integer">,
                    UPDATE_IP = <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
               WHERE
                    DATA_INVENTORY_ID  = <cfqueryparam value="#data_inventory_id#" cfsqltype="cf_sql_integer">
                    AND DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_integer">
            </cfquery>
            
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_data_inventory" access="public" returntype="query">
        <cfargument name="keyword" type="string">
        <cfargument name="data_category_id" default="0" type="numeric">
        <cfargument name="is_active" default="True" type="string">
        <cfquery name="get_data_inventory" datasource="#dsn#">
            SELECT 
                T1.*,
                T2.DATA_CATEGORY,
                T3.DATA_SUBJECT_GROUP
            FROM 
                GDPR_DATA_INVENTORY AS T1
                INNER JOIN GDPR_DATA_CATEGORIES AS T2 ON T1.DATA_CATEGORY_ID = T2.DATA_CATEGORY_ID
                INNER JOIN GDPR_DATA_SUBJECT_GROUP AS T3 ON T1.DATA_SUBJECT_GROUP_ID = T3.DATA_SUBJECT_GROUP_ID
            WHERE
                T1.DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
                AND T1.IS_DELETE = <cfqueryparam value="false" cfsqltype="cf_sql_bit">
                <cfif len(is_active)>
                    AND T1.IS_ACTIVE = <cfqueryparam value="#is_active#" cfsqltype="cf_sql_bit">
                </cfif>
                <cfif isDefined("keyword") and len(keyword)>
                    AND T1.DATA_INVENTORY Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
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
        <cfreturn get_data_inventory />
    </cffunction>
    <cffunction name="get_data_inventory_maxId" access="public" returntype="numeric">
        <cfquery name="get_data_inventory_maxId" datasource="#dsn#">
        SELECT 
           MAX(DATA_INVENTORY_ID) DATA_INVENTORY_ID
        FROM 
            GDPR_DATA_INVENTORY
        WHERE 
            DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
       </cfquery>

        <cfreturn get_data_inventory_maxId.DATA_INVENTORY_ID />
    </cffunction>
    <cffunction name="get_data_inventory_byId" access="public" returntype="query">
        <cfargument name="data_inventory_id" type="numeric">
       <cftry>
            <cfquery name="get_data_inventory" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_DATA_INVENTORY
            WHERE 
                DATA_INVENTORY_ID = <cfqueryparam value="#data_inventory_id#" cfsqltype="cf_sql_integer">
                AND DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_data_inventory />
    </cffunction>
    
</cfcomponent>