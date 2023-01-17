<!---
    File: Callcenter Başvuru Main Action
    Folder: 
	Controller: 
    Author: Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
    Date: 2020-03-17 15:15:56 
    Description:
        
    History:
        
    To Do:

--->

<cfif attributes.process_stage Eq 818 Or attributes.process_stage Eq 819 Or attributes.process_stage Eq 481><!--- Çözüme ulaştı, Kapatıldı ve Kullanım Yardımı Yapıldı --->
    <cfquery datasource="#attributes.data_source#">
        UPDATE
            G_SERVICE
        SET
            SERVICE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
            FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        WHERE
            SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
            AND FINISH_DATE IS NULL
            AND SERVICE_ACTIVE = 1
    </cfquery>
<cfelseif attributes.process_stage Eq 823>
    <cfquery datasource="#attributes.data_source#">
        UPDATE
            G_SERVICE
        SET
            START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        WHERE
            SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
    </cfquery>
</cfif>