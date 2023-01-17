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
    <cffunction name="add_data_officer" access="public" returntype="boolean">
        <cfargument name="data_officer_name" type="string" required="true">
        <cfargument name="data_officer_description" type="string" required="true">
        <cfargument name="data_officer_address" default="" type="string">
        <cfargument name="data_officer_kep_address" type="string">
        <cfargument name="contact_emp_id" default="0" type="numeric">
        <cfargument name="contact_name" default="" type="string">
        <cfargument name="verbis_user" type="string" required="true">
        <cfargument name="verbis_password" type="string" required="true">
        <cfargument name="verbis_registration_date" type="string" default="">
        <cfargument name="our_company_id" type="string" default="">
        <cfargument name="is_employee"  default="">
        <cfargument name="is_contacts"  default="">
        <cfargument name="is_accounts"  default="">
        <cftry>
        <cf_date tarih="attributes.verbis_registration_date">
            <cfquery name="add_query" datasource="#dsn#">
                INSERT INTO GDPR_DATA_OFFICER
                    (
                        DATA_OFFICER_NAME,
                        DATA_OFFICER_DESCRIPTION,
                        DATA_OFFICER_KEP_ADDRESS,
                        DATA_OFFICER_ADDRESS,
                        CONTACT_EMP_ID,
                        CONTACT_NAME,
                        VERBIS_USER,
                        VERBIS_PASSWORD,
                        VERBIS_REGISTRATION_DATE,
                        OUR_COMPANY_ID,
                        IS_EMPLOYEE,
                        IS_CONTACTS,
                        IS_ACCOUNTS,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                VALUES
                    (
                        <cfqueryparam value="#data_officer_name#" cfsqltype="cf_sql_nvarchar">,
                        <cfqueryparam value="#data_officer_description#" cfsqltype="cf_sql_nvarchar">,
                        <cfif len(data_officer_kep_address)><cfqueryparam value="#data_officer_kep_address#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len(data_officer_address)><cfqueryparam value="#data_officer_address#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif contact_emp_id gt 0><cfqueryparam value="#contact_emp_id#" cfsqltype="cf_sql_numeric"><cfelse>NULL</cfif>,
                        <cfif len(contact_name)><cfqueryparam value="#contact_name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len(verbis_user)><cfqueryparam value="#verbis_user#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif len(verbis_password)><cfqueryparam value="#verbis_password#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfqueryparam value="#dateFormat(verbis_registration_date, "d-m-yyyy")#" cfsqltype="cf_sql_date">,
                        <cfif len(our_company_id)><cfqueryparam value="#our_company_id#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                        <cfif isDefined('is_employee')>1<cfelse>0</cfif>,
                        <cfif isDefined('is_contacts')>1<cfelse>0</cfif>,
                        <cfif isDefined('is_accounts')>1<cfelse>0</cfif>,
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

    <cffunction name="upd_data_officer" access="public" returntype="boolean">
        <cfargument name="data_officer_id" type="numeric" required="true">
        <cfargument name="data_officer_name" type="string" required="true">
        <cfargument name="data_officer_description" type="string" required="true">
        <cfargument name="data_officer_address" default="" type="string">
        <cfargument name="data_officer_kep_address" default="" type="string">
        <cfargument name="contact_emp_id" default="0" type="numeric">
        <cfargument name="contact_name" default="" type="string">
        <cfargument name="verbis_user" type="string" required="true">
        <cfargument name="verbis_password" type="string" required="true">
        <cfargument name="verbis_registration_date" type="string"  default="">
        <cfargument name="our_company_id" type="string" default="">
        <cfargument name="is_employee" default="">
        <cfargument name="is_contacts" default="">
        <cfargument name="is_accounts" default="">
       <cftry>
        <cf_date tarih="attributes.verbis_registration_date">
            <cfquery name="upd_query" datasource="#dsn#">
                UPDATE GDPR_DATA_OFFICER
                 SET
                    DATA_OFFICER_NAME = <cfqueryparam value="#data_officer_name#" cfsqltype="cf_sql_nvarchar">,
                    DATA_OFFICER_DESCRIPTION = <cfqueryparam value="#data_officer_description#" cfsqltype="cf_sql_nvarchar">,
                    DATA_OFFICER_KEP_ADDRESS = <cfif len(data_officer_kep_address)><cfqueryparam value="#data_officer_kep_address#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    DATA_OFFICER_ADDRESS = <cfif len(data_officer_address)><cfqueryparam value="#data_officer_address#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    CONTACT_EMP_ID = <cfif contact_emp_id gt 0><cfqueryparam value="#contact_emp_id#" cfsqltype="cf_sql_numeric"><cfelse>NULL</cfif>,
                    CONTACT_NAME = <cfif len(contact_name)><cfqueryparam value="#contact_name#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    VERBIS_USER =  <cfif len(verbis_user)><cfqueryparam value="#verbis_user#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    VERBIS_PASSWORD = <cfif len(verbis_password)><cfqueryparam value="#verbis_password#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    VERBIS_REGISTRATION_DATE = <cfqueryparam value="#dateFormat(verbis_registration_date, "d-m-yyyy")#" cfsqltype="cf_sql_date">,
                    UPDATE_DATE = <cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">,
                    UPDATE_EMP = <cfqueryparam value="#SESSION.EP.USERID#" cfsqltype="cf_sql_numeric">,
                    UPDATE_IP =  <cfqueryparam value="#CGI.REMOTE_ADDR#" cfsqltype="cf_sql_nvarchar">,
                    OUR_COMPANY_ID = <cfif len(our_company_id)><cfqueryparam value="#our_company_id#" cfsqltype="cf_sql_nvarchar"><cfelse>NULL</cfif>,
                    IS_EMPLOYEE = <cfif isDefined('is_employee')><cfqueryparam value="#is_employee#" cfsqltype="cf_sql_bit"></cfif>,
                    IS_CONTACTS = <cfif isDefined('is_contacts')><cfqueryparam value="#is_contacts#" cfsqltype="cf_sql_bit"></cfif>,
                    IS_ACCOUNTS = <cfif isDefined('is_accounts')><cfqueryparam value="#is_accounts#" cfsqltype="cf_sql_bit"></cfif>
                WHERE
                    DATA_OFFICER_ID = <cfqueryparam value="#data_officer_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_data_officer" access="public" returntype="query">
        <cfargument name="keyword" default="" type="string">      
        <cfquery name="get_data_officer" datasource="#dsn#">
        SELECT 
            T1.*
        FROM 
            GDPR_DATA_OFFICER AS T1
        <cfif isdefined('keyword') and len(keyword)>
        WHERE 
                AND ( 
                    T1.DATA_OFFICER_NAME Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                    OR T1.DATA_OFFICER_DESCRIPTION Like <cfqueryparam value="%#keyword#%" cfsqltype="cf_sql_nvarchar">
                )
            </cfif>
        </cfquery>
        <cfreturn get_data_officer />
    </cffunction>

    <cffunction name="get_data_officer_byId" access="public" returntype="query">
        <cfargument name="data_officer_id" type="numeric" required="true">
        <cftry>
            <cfquery name="get_data_officer" datasource="#dsn#">
            SELECT 
                *
            FROM 
                GDPR_DATA_OFFICER
            WHERE 
                DATA_OFFICER_ID = <cfqueryparam value="#data_officer_id#" cfsqltype="cf_sql_integer">                
            </cfquery>
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn get_data_officer />
    </cffunction>

    <cffunction name="get_data_officer_maxId" access="public" returntype="numeric">
        <cfquery name="get_data_officer_maxId" datasource="#dsn#">
        SELECT 
           MAX(DATA_OFFICER_ID) DATA_OFFICER_ID
        FROM 
        GDPR_DATA_OFFICER
       </cfquery>

        <cfreturn get_data_officer_maxId.DATA_OFFICER_ID />
    </cffunction>
    <cffunction name="get_data_officer_all" access="public" returntype="query">
        <cfquery name="get_data_officer_all" datasource="#dsn#">
        SELECT 
           OUR_COMPANY_ID,DATA_OFFICER_ID
        FROM 
            GDPR_DATA_OFFICER
            WHERE OUR_COMPANY_ID IS NOT NULL
            GROUP BY DATA_OFFICER_ID,OUR_COMPANY_ID
       </cfquery>

        <cfreturn get_data_officer_all />
    </cffunction>
    <cffunction name="del_data_officer_byId" access="public" returntype="boolean">
        <cfargument name="data_officer_id" type="numeric" required="true">
            <cfquery name="del_data_officer_byId" datasource="#dsn#">
            DELETE
            FROM 
            GDPR_DATA_OFFICER
            WHERE 
            DATA_OFFICER_ID = <cfqueryparam value="#data_officer_id#" cfsqltype="cf_sql_numeric">
            </cfquery>
        <cfreturn true />
    </cffunction>
    <cffunction name="get_our_company" access="public" returntype="query">
        <cfquery name="get_our_company" datasource="#dsn#">
            SELECT COMP_ID, NICK_NAME,COMPANY_NAME FROM OUR_COMPANY
            ORDER BY COMPANY_NAME
        </cfquery>
        <cfreturn get_our_company />
    </cffunction>
    <cffunction name="get_company_data_officer" access="public" returntype="query">
        <cfargument name="comp_id" type="string">
        <cfquery name="get_company_data_officer" datasource="#DSN#">
			SELECT COMPANY_NAME,MANAGER FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
		</cfquery>	
        <cfreturn get_company_data_officer />
    </cffunction>
    <cffunction name="get_company_id" access="public" returntype="query">
        <cfargument name="our_company_ids" type="string">
        <cfquery name="get_company_id" datasource="#DSN#">
			SELECT DATA_OFFICER_ID FROM GDPR_DATA_OFFICER WHERE OUR_COMPANY_ID LIKE '%#arguments.our_company_ids#%'
		</cfquery>	
        <cfreturn get_company_id />
    </cffunction>
    <cffunction name="get_committee" access="public" returntype="query">
        <cfargument name="data_officer_id" type="numeric">
        <cfquery name="get_committee" datasource="#DSN#">
		SELECT * FROM GDPR_DATA_OFFICER_COMMITTEE WHERE DATA_OFFICER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.data_officer_id#">
		</cfquery>	
        <cfreturn get_committee />
    </cffunction>
</cfcomponent>