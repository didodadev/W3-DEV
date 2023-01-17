<!---
    File: 
    Author: 
    Date: 
    Description: Veri envanterinde transfer edilecek verilerin detaylarını tutar
		
--->
<cfcomponent displayname="" output="false" accessors="true">
    <cfproperty name="data_officer_id" type="numeric" required="true" setter="true"/>
    <cfproperty name="data_inventory_id" type="numeric" required="true" setter="true"/>
    <cfscript>
        dsn = application.SystemParam.SystemParam().dsn;
    </cfscript>
    <cffunction name="add_data_inventory_transfer" access="public" returntype="boolean">
        <cfargument name="adequate_protection" default="false" type="boolean">
        <cfargument name="corporation_desicion" default="false" type="boolean">
        <cfargument name="written_commitment" default="false" type="boolean">
        <cfargument name="clear_consent" default="false" type="boolean">
        <cfargument name="other_law" default="false" type="boolean">
        <cfargument name="transfer_detail" type="string">
       
            <cfquery name="add_data_inventory_transfer" datasource="#dsn#">
                INSERT INTO 
                GDPR_DATA_INVENTORY_TRANSFER
                (
                    DATA_OFFICER_ID,
                    DATA_INVENTORY_ID,
                    ADEQUATE_PROTECTION,
                    CORPORATION_DESICION,
                    WRITTEN_COMMITMENT,
                    CLEAR_CONSENT,
                    OTHER_LAW,
                    TRANSFER_DETAIL,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">,
                    <cfqueryparam value="#this.getData_inventory_id()#" cfsqltype="cf_sql_numeric">,
                    <cfqueryparam value="#adequate_protection#" cfsqltype="cf_sql_bit">,
                    <cfqueryparam value="#corporation_desicion#" cfsqltype="cf_sql_bit">,
                    <cfqueryparam value="#written_commitment#" cfsqltype="cf_sql_bit">,
                    <cfqueryparam value="#clear_consent#" cfsqltype="cf_sql_bit">,
                    <cfqueryparam value="#other_law#" cfsqltype="cf_sql_bit">,
                    <cfqueryparam value="#transfer_detail#" cfsqltype="cf_sql_nvarchar">,
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
    <cffunction name="upd_data_inventory_transfer" access="public" returntype="boolean">
        <cfargument name="data_inventory_transfer_id" type="numeric" required="true">
        <cfargument name="adequate_protection" default="false" type="boolean">
        <cfargument name="corporation_desicion" default="false" type="boolean">
        <cfargument name="written_commitment" default="false" type="boolean">
        <cfargument name="clear_consent" default="false" type="boolean">
        <cfargument name="other_law" default="false" type="boolean">
        <cfargument name="transfer_detail" type="string">
        <cftry>
            <cfquery name="upd_data_inventory_transfer" datasource="#dsn#">
                UPDATE GDPR_DATA_INVENTORY_TRANSFER
                SET
                    ADEQUATE_PROTECTION = <cfqueryparam value="#adequate_protection#" cfsqltype="cf_sql_bit">,
                    CORPORATION_DESICION = <cfqueryparam value="#corporation_desicion#" cfsqltype="cf_sql_bit">,
                    WRITTEN_COMMITMENT = <cfqueryparam value="#written_commitment#" cfsqltype="cf_sql_bit">,
                    CLEAR_CONSENT = <cfqueryparam value="#clear_consent#" cfsqltype="cf_sql_bit">,
                    OTHER_LAW = <cfqueryparam value="#other_law#" cfsqltype="cf_sql_bit">,
                    TRANSFER_DETAIL = <cfqueryparam value="#transfer_detail#" cfsqltype="cf_sql_nvarchar">,
                    UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                    UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                    UPDATE_IP = <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">
               WHERE
                    DATA_INVENTORY_ID = <cfqueryparam value="#this.getData_inventory_id()#" cfsqltype="cf_sql_numeric">
                    AND DATA_INVENTORY_TRANSFER_ID = <cfqueryparam value="#data_inventory_transfer_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_data_inventory_transfer" access="public" returntype="query">
        <cftry>
            <cfquery name="get_data_officer_inventory_transfer" datasource="#dsn#">
                SELECT 
                    *
                FROM 
                    GDPR_DATA_INVENTORY_TRANSFER
                WHERE
                    DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
                    AND DATA_INVENTORY_ID = <cfqueryparam value="#this.getData_inventory_id()#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_data_officer_inventory_transfer />
    </cffunction>

    <cffunction name="get_data_officer_inventory_transfer" access="public" returntype="query">
        <cftry>
            <cfquery name="get_data_officer_inventory_transfer" datasource="#dsn#">
                SELECT 
                    *
                FROM 
                    GDPR_DATA_INVENTORY_TRANSFER
                WHERE
                    DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_data_officer_inventory_transfer />
    </cffunction>

    <cffunction name="get_data_inventory_transfer_maxId" access="public" returntype="numeric">
        <cfquery name="get_data_inventory_transfer_maxId" datasource="#dsn#">
        SELECT 
           MAX(DATA_INVENTORY_TRANSFER_ID) DATA_INVENTORY_TRANSFER_ID
        FROM 
            GDPR_DATA_INVENTORY_TRANSFER
        WHERE
            DATA_INVERTORY_ID = <cfqueryparam value="#this.getData_inventory_id()#" cfsqltype="cf_sql_numeric">
            AND DATA_OFFICER_ID = <cfqueryparam value="#this.getData_officer_id()#" cfsqltype="cf_sql_numeric">
       </cfquery>

        <cfreturn get_data_inventory_transfer_maxId.DATA_INVENTORY_TRANSFER_ID />
    </cffunction>
    <cffunction name="get_data_inventory_transfer_byId" access="public" returntype="query">
        <cfargument name="data_inventory_transfer_id" type="numeric">
        
            <cfquery name="get_data_inventory_transfer_byId" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_DATA_INVENTORY_TRANSFER
            WHERE 
                DATA_INVENTORY_TRANSFER_ID = <cfqueryparam value="#data_inventory_transfer_id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cftry>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_data_inventory_transfer_byId />
    </cffunction>
    
</cfcomponent>