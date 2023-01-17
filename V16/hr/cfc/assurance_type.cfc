<!---
File: assurance_type.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Date: 22.11.2019
Controller: -
Description: Sağlık Teminatı Tipleri Fonksiyonları ;
Ekleme, Güncelleme, Veri alma
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cffunction name="GET_MAIN_ASSURANCE_TYPES" access="public"  returntype="any">
        <cfargument name="assurance_id" default="">
        <cfquery name="GET_MAIN_ASSURANCE_TYPES" datasource="#dsn#">
            SELECT
                ASSURANCE_ID,
                ASSURANCE
            FROM
                SETUP_HEALTH_ASSURANCE_TYPE
            WHERE
                IS_MAIN = 1 AND
                IS_ACTIVE = 1
                <cfif len(arguments.assurance_id)>
                    AND ASSURANCE_ID != <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_MAIN_ASSURANCE_TYPES> 
    </cffunction>
    <cffunction name="ADD_HEALTH_ASSURANCE_TYPE" access="remote"  returnFormat="json" returntype="any"><!--- Sağlık teminatı tipi ekleme --->
        <cfargument name="is_active" default=""> <!--- aktif / pasif --->
        <cfargument name="assurance" default=""> <!--- Teminat --->
        <cfargument name="detail" default=""> <!--- detay --->
        <cfargument name="working_type" default=""> <!--- Çalışma Tipi --->
        <cfargument name="period" default=""> <!--- Periyot --->
        <cfargument name="calc_formula" default=""> <!--- Formül --->
        <cfargument name="is_main" default="">
        <cfargument name="main_assurance_type_id" default="">
        <cfargument name="is_requested" default="">
        <cfquery name="ADD_HEALTH_ASSURANCE_TYPE" datasource="#dsn#" result="MAX_ID">
            INSERT INTO
                SETUP_HEALTH_ASSURANCE_TYPE
                (
                    IS_ACTIVE,
                    ASSURANCE,
                    DETAIL,
                    WORKING_TYPE,
                    PERIOD,
                    CALCULATION_FORMULA,
                    RECORD_IP,
                    RECORD_DATE,
                    RECORD_EMP,
                    IS_MAIN,
                    MAIN_ASSURANCE_TYPE_ID,
                    IS_REQUESTED
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.assurance#">,
                    <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.working_type#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#">,
                    <cfif len(arguments.calc_formula)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.calc_formula#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_main#">,
                    <cfif len(arguments.main_assurance_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_assurance_type_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_requested#">
                )
        </cfquery>
        <cfreturn Replace( serializeJSON(MAX_ID.IDENTITYCOL), "//", "" ) />
    </cffunction>
    <cffunction name="GET_HEALTH_ASSURANCE_TYPE" access="remote"  returntype="any"><!--- Sağlık teminatı filtreleme, upd select --->
        <cfargument name="assurance_id" default=""> 
        <cfargument name="keyword" default="">
        <cfargument name="is_active" default="">
        <cfargument name="startrow" default="1">
        <cfargument name="maxrows" default="20">
        <cfquery name="GET_HEALTH_ASSURANCE_TYPE" datasource="#dsn#" result="MAX_ID">
            WITH CTE1 AS (
                SELECT
                    *,
                    #dsn#.Get_Dynamic_Language(ASSURANCE_ID,'#session.ep.language#','SETUP_HEALTH_ASSURANCE_TYPE','ASSURANCE',NULL,NULL,ASSURANCE) AS ASSURANCE_NEW
                FROM   
                    SETUP_HEALTH_ASSURANCE_TYPE
                WHERE
                    1 = 1
                    <cfif isdefined("arguments.assurance_id") and len(arguments.assurance_id)>
                        AND ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
                    </cfif>
                    <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                        AND ASSURANCE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%">
                    </cfif>
                    <cfif isdefined("arguments.is_active") and arguments.is_active eq 1>
                        AND IS_ACTIVE = 1
                    <cfelseif isdefined("arguments.is_active") and arguments.is_active eq 2>
                        AND IS_ACTIVE = 0
                    </cfif>
                ),
                CTE2 AS (
                     SELECT
                         CTE1.*,
                         ROW_NUMBER() OVER ( ORDER BY ASSURANCE_ID DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                         FROM
                             CTE1
                     )
                     SELECT
                         CTE2.*
                     FROM
                         CTE2
                     WHERE
                         RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>
        <cfreturn GET_HEALTH_ASSURANCE_TYPE>
    </cffunction>
    <cffunction name="UPD_HEALTH_ASSURANCE_TYPE" access="remote" returntype="any"><!--- Sağlık güvence tipi güncelleme ---->
        <cfargument name="is_active" default=""> <!--- aktif / pasif --->
        <cfargument name="assurance" default=""> <!--- Teminat --->
        <cfargument name="detail" default=""> <!--- detay --->
        <cfargument name="working_type" default=""> <!--- Çalışma Tipi --->
        <cfargument name="period" default=""> <!--- Periyot --->
        <cfargument name="assurance_id" default=""> 
        <cfargument name="calc_formula" default=""> <!--- Formül --->
        <cfargument name="is_main" default="">
        <cfargument name="main_assurance_type_id" default="">
        <cfargument name="is_requested" default="">
        <cfquery name="UPD_HEALTH_ASSURANCE_TYPE" datasource="#dsn#">
            UPDATE
                SETUP_HEALTH_ASSURANCE_TYPE
            SET
                IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#">,
                ASSURANCE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.assurance#">,
                DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                WORKING_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.working_type#">,
                PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#">,
                CALCULATION_FORMULA = <cfif len(arguments.calc_formula)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.calc_formula#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                IS_MAIN = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_main#">,
                MAIN_ASSURANCE_TYPE_ID = <cfif len(arguments.main_assurance_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_assurance_type_id#"><cfelse>NULL</cfif>,
                IS_REQUESTED = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_requested#">
            WHERE
                ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <cffunction name="ADD_HEALTH_ASSURANCE_TYPE_SUPPORT" access="remote"  returntype="any"><!--- Sağlık güvence tipi limitler ekleme--->
        <cfargument name="is_active" default=""> <!--- aktif / pasif --->
        <cfargument name="min" default=""> <!--- minumum tutar --->
        <cfargument name="max" default=""> <!--- maximum tutar --->
        <cfargument name="money" default=""> <!--- para birimi --->
        <cfargument name="effective_date" default=""> <!--- yürürlülük tarihi --->
        <cfargument name="assurance_id" default=""><!--- Teminat Id---> 
        <cfargument name="rate" default=""> <!--- Kamu - Oran --->
        <cfargument name="private_rate" default=""> <!--- Özel - Oran --->
        <cfargument name="quantity" default=""> <!--- Birim --->
        <cfquery name="ADD_HEALTH_ASSURANCE_TYPE_SUPPORT" datasource="#dsn#">
            INSERT INTO
                SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT
                (
                    IS_ACTIVE,
                    ASSURANCE_ID,
                    QUANTITY,
                    MIN,
                    MAX,
                    MONEY,
                    RATE,
                    EFFECTIVE_DATE,
                    RECORD_IP,
                    RECORD_DATE,
                    RECORD_EMP,
                    PRIVATE_COMP_RATE
                )
                VALUES
                (
                    <cfif len(arguments.is_active)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.quantity)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.quantity#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.min)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.max)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.money)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.effective_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.effective_date#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfif len(arguments.private_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.private_rate#"><cfelse>NULL</cfif>
                )
        </cfquery>
    </cffunction>
    <cffunction name="UPD_HEALTH_ASSURANCE_TYPE_SUPPORT" access="remote"  returntype="any"><!--- Sağlık güvence tipi limitler güncelleme--->
        <cfargument name="is_active" default=""> <!--- aktif / pasif --->
        <cfargument name="min" default=""> <!--- minumum tutar --->
        <cfargument name="max" default=""> <!--- maximum tutar --->
        <cfargument name="money" default=""> <!--- para birimi --->
        <cfargument name="effective_date" default=""> <!--- yürürlülük tarihi --->
        <cfargument name="assurance_id" default=""><!--- Teminat Id---> 
        <cfargument name="rate" default=""> <!--- Kamu - Oran --->
        <cfargument name="private_rate" default=""> <!--- Özel - Oran --->
        <cfargument name="quantity" default=""> <!--- Birim --->
        <cfquery name="UPD_HEALTH_ASSURANCE_TYPE_SUPPORT" datasource="#dsn#">
            UPDATE
                SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT
            SET 
                IS_ACTIVE = <cfif len(arguments.is_active)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_active#"><cfelse>NULL</cfif>,
                ASSURANCE_ID = <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                QUANTITY =  <cfif len(arguments.quantity)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.quantity#"><cfelse>NULL</cfif>,
                MIN = <cfif len(arguments.min)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.min#"><cfelse>NULL</cfif>,
                MAX = <cfif len(arguments.max)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max#"><cfelse>NULL</cfif>,
                MONEY = <cfif len(arguments.money)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.money#"><cfelse>NULL</cfif>,
                RATE =  <cfif len(arguments.rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.rate#"><cfelse>NULL</cfif>,
                EFFECTIVE_DATE = <cfif len(arguments.effective_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.effective_date#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                PRIVATE_COMP_RATE =  <cfif len(arguments.private_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.private_rate#"><cfelse>NULL</cfif>
            WHERE
                SUPPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
    </cffunction>
    <cffunction name="GET_HEALTH_ASSURANCE_TYPE_SUPPORT" access="remote"  returntype="any"><!---Limitler select ---->
        <cfargument name="assurance_id" default=""> 
        <cfquery name="GET_HEALTH_ASSURANCE_TYPE_SUPPORT" datasource="#dsn#" result="MAX_ID">
            SELECT
                *
            FROM   
                SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT
            WHERE
                ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
        </cfquery>
        <cfreturn GET_HEALTH_ASSURANCE_TYPE_SUPPORT>
    </cffunction>
    <cffunction name="DEL_HEALTH_ASSURANCE_TYPE_SUPPORT" access="remote"  returntype="any"><!--- LLimit satır silme ---->
        <cfargument name="id" default=""> 
        <cfquery name="DEL_HEALTH_ASSURANCE_TYPE_SUPPORT" datasource="#dsn#">
            DELETE FROM SETUP_HEALTH_ASSURANCE_TYPE_SUPPORT WHERE SUPPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
    </cffunction>
    <cffunction name="GET_MONEY" access="remote"  returntype="any">
        <cfquery name="GET_MONEY" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
        </cfquery>
        <cfreturn GET_MONEY> 
    </cffunction>
    <cffunction name="GET_HEALTH_PRICE_PROTOCOL" access="remote"  returntype="any"><!---Fiyat protokolü--->
        <cfquery name="GET_HEALTH_PRICE_PROTOCOL" datasource="#dsn#">
            SELECT * FROM HEALTH_PRICE_PROTOCOL 
        </cfquery>
        <cfreturn GET_HEALTH_PRICE_PROTOCOL> 
    </cffunction>
    <cffunction name="GET_HEALTH_ASSURANCE_CONTRACT_COMPANY" access="remote"  returntype="any"><!--- Anlaşmalı Kurumlar ---->
        <cfargument name="assurance_id" default=""> 
        <cfquery name="GET_HEALTH_ASSURANCE_CONTRACT_COMPANY" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                HEALTH_ASSURANCE_CONTRACT_COMPANY 
            WHERE 
                ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
        </cfquery>
        <cfreturn GET_HEALTH_ASSURANCE_CONTRACT_COMPANY> 
    </cffunction>
    <cffunction name="ADD_HEALTH_ASSURANCE_CONTRACT_COMPANY" access="remote"  returntype="any"><!--- Anlaşmalı Kurumlar Ekleme ---->
        <cfargument name="assurance_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="contrat_no" default="">
        <cfargument name="protocol_id" default="">
        <cfargument name="discount" default="">
        <cfquery name="ADD_HEALTH_ASSURANCE_CONTRACT_COMPANY" datasource="#dsn#">
            INSERT INTO 
                HEALTH_ASSURANCE_CONTRACT_COMPANY 
                (
                    COMPANY_ID,
                    CONTRACT_NO,
                    PROTOCOL_ID,
                    DISCOUNT,
                    ASSURANCE_ID,
                    RECORD_IP,
                    RECORD_DATE,
                    RECORD_EMP
                )
            VALUES
                (
                    <cfif len(arguments.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.contrat_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.contrat_no#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.protocol_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.protocol_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.discount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
        </cfquery>
    </cffunction>
    <cffunction name="UPD_HEALTH_ASSURANCE_CONTRACT_COMPANY" access="remote"  returntype="any"><!--- Anlaşmalı Kurumlar Ekleme ---->
        <cfargument name="assurance_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="contrat_no" default="">
        <cfargument name="protocol_id" default="">
        <cfargument name="discount" default="">
        <cfargument name="company_contract_id" default="">
        <cfquery name="UPD_HEALTH_ASSURANCE_CONTRACT_COMPANY" datasource="#dsn#">
            UPDATE 
                HEALTH_ASSURANCE_CONTRACT_COMPANY 
            SET
                COMPANY_ID = <cfif len(arguments.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
                CONTRACT_NO = <cfif len(arguments.contrat_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.contrat_no#"><cfelse>NULL</cfif>,
                PROTOCOL_ID = <cfif len(arguments.protocol_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.protocol_id#"><cfelse>NULL</cfif>,
                DISCOUNT = <cfif len(arguments.discount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.discount#"><cfelse>NULL</cfif>,
                ASSURANCE_ID = <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
            WHERE
                CONTRACT_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_contract_id#">
        </cfquery>
    </cffunction>
    <cffunction name="DEL_HEALTH_ASSURANCE_CONTRACT_COMPANY" access="remote"  returntype="any">
        <cfargument name="id" default=""> 
        <cfquery name="DEL_HEALTH_ASSURANCE_CONTRACT_COMPANY" datasource="#dsn#">
            DELETE FROM HEALTH_ASSURANCE_CONTRACT_COMPANY WHERE CONTRACT_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
    </cffunction>
    <cffunction name="GET_HEALTH_ASSURANCE_TYPE_TREATMENTS" access="remote"  returntype="any">
        <cfargument name="assurance_id" default=""> 
        <cfquery name="GET_HEALTH_ASSURANCE_TYPE_TREATMENTS" datasource="#dsn#" result="MAX_ID">
            SELECT
                SHATT.*,
                SC.COMPLAINT
            FROM   
                SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS SHATT LEFT JOIN SETUP_COMPLAINTS SC ON SHATT.SETUP_COMPLAINT_ID = SC.COMPLAINT_ID
            WHERE
                ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
        </cfquery>
        <cfreturn GET_HEALTH_ASSURANCE_TYPE_TREATMENTS>
    </cffunction>
    <cffunction name="ADD_HEALTH_ASSURANCE_TYPE_TREATMENTS" access="remote"  returntype="any">
        <cfargument name="treatment" default=""> <!--- TEDAVİ --->
        <cfargument name="period" default=""> <!---  periyot --->
        <cfargument name="max_trea_" default=""> <!--- maximum tutar --->
        <cfargument name="assurance_id" default=""><!--- Teminat Id--->
        <cfargument name="note_trea" default=""><!--- NOT--->
        <cfargument name="money_limit_trea" default=""><!--- money--->
        <cfargument name="payment_rate" default=""><!--- ödeme oranı%--->  
        <cfargument name="treatment_id" default="">
        <cfquery name="ADD_HEALTH_ASSURANCE_TYPE_TREATMENTS" datasource="#dsn#">
            INSERT INTO
                SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS
                (
                    ASSURANCE_ID,
                    TREATMENT,
                    PERIOD,
                    MAX,
                    NOTE,
                    MONEY_LIMIT,
                    PAYMENT_RATE,
                    SETUP_COMPLAINT_ID
                )
                VALUES
                (
                    <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.treatment)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.treatment#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.max_trea_)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_trea_#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.note_trea)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.note_trea#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.money_limit_trea#">,
                    <cfif len(arguments.payment_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.payment_rate#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.treatment_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.treatment_id#"><cfelse>NULL</cfif>
                )
        </cfquery>
    </cffunction>
    <cffunction name="UPD_HEALTH_ASSURANCE_TYPE_TREATMENTS" access="remote"  returntype="any">
        <cfargument name="treatment" default=""> <!--- TEDAVİ --->
        <cfargument name="period" default=""> <!---  periyot --->
        <cfargument name="max_trea_" default=""> <!--- maximum tutar --->
        <cfargument name="assurance_id" default=""><!--- Teminat Id--->
        <cfargument name="treatment_id" default=""><!--- Tedavi Id--->
        <cfargument name="note_trea" default=""><!--- NOT--->
        <cfargument name="payment_rate" default=""><!--- ödeme oranı%--->
        <cfargument name="setup_treatment_id" default="">
        <cfquery name="UPD_HEALTH_ASSURANCE_TYPE_TREATMENTS" datasource="#dsn#">
            UPDATE
                SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS
            SET 
                ASSURANCE_ID = <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                TREATMENT =  <cfif len(arguments.treatment)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.treatment#"><cfelse>NULL</cfif>,
                MAX = <cfif len(arguments.max_trea_)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_trea_#"><cfelse>NULL</cfif>,
                PERIOD = <cfif len(arguments.period)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period#"><cfelse>NULL</cfif>,
                NOTE =  <cfif len(arguments.note_trea)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.note_trea#"><cfelse>NULL</cfif>,
                MONEY_LIMIT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.money_limit_trea#">,
                PAYMENT_RATE =  <cfif len(arguments.payment_rate)><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#arguments.payment_rate#"><cfelse>NULL</cfif>,
                SETUP_COMPLAINT_ID = <cfif len(arguments.setup_treatment_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.setup_treatment_id#"><cfelse>NULL</cfif>
            WHERE
                TREATMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.treatment_id#">
        </cfquery>
    </cffunction>
    <cffunction name="DEL_HEALTH_ASSURANCE_TYPE_TREATMENTS" access="remote"  returntype="any">
        <cfargument name="treatment_id" default=""> 
        <cfquery name="DEL_HEALTH_ASSURANCE_TYPE_TREATMENTS" datasource="#dsn#">
            DELETE FROM SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS WHERE TREATMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.treatment_id#">
        </cfquery>
    </cffunction>
    <cffunction name="GET_HEALTH_ASSURANCE_TYPE_MEDICATION" access="remote"  returntype="any">
        <cfargument name="assurance_id" default=""> 
        <cfquery name="GET_HEALTH_ASSURANCE_TYPE_MEDICATION" datasource="#dsn#" result="MAX_ID">
            SELECT
                SHATM.*,
                SD.DRUG_MEDICINE
            FROM   
                SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION SHATM LEFT JOIN SETUP_DECISIONMEDICINE SD ON SHATM.DRUG_ID = SD.DRUG_ID
            WHERE
                ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#">
        </cfquery>
        <cfreturn GET_HEALTH_ASSURANCE_TYPE_MEDICATION>
    </cffunction>
    <cffunction name="ADD_HEALTH_ASSURANCE_TYPE_MEDICATION" access="remote"  returntype="any">
        <cfargument name="medication" default=""> <!--- ilaç/malzeme --->
        <cfargument name="period_med" default=""> <!---  periyot --->
        <cfargument name="max_med" default=""> <!--- maximum tutar --->
        <cfargument name="assurance_id" default=""><!--- Teminat Id---> 
        <cfargument name="note_med" default=""><!--- not---> 
        <cfargument name="money_limit_drug" default=""><!--- money--->
        <cfargument name="payment_rate" default=""><!--- ödeme oranı%--->  
        <cfargument name="drug_id" default="">
        <cfquery name="ADD_HEALTH_ASSURANCE_TYPE_MEDICATION" datasource="#dsn#">
            INSERT INTO
                SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION
                (
                    ASSURANCE_ID,
                    MEDICATION,
                    PERIOD,
                    MAX,
                    NOTE,
                    MONEY_LIMIT,
                    PAYMENT_RATE,
                    DRUG_ID
                )
                VALUES
                (
                    <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.medication)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.medication#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.period_med)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_med#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.max_med)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_med#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.note_med)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.note_med#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.money_limit_drug#">,
                    <cfif len(arguments.payment_rate)><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#arguments.payment_rate#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.drug_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.drug_id#"><cfelse>NULL</cfif>
                )
        </cfquery>
    </cffunction>
    <cffunction name="UPD_HEALTH_ASSURANCE_TYPE_MEDICATION" access="remote"  returntype="any">
        <cfargument name="medication" default=""> <!--- ilaç/malzeme --->
        <cfargument name="period_med" default=""> <!---  periyot --->
        <cfargument name="max_med" default=""> <!--- maximum tutar --->
        <cfargument name="assurance_id" default=""><!--- Teminat Id--->
        <cfargument name="medication_id" default=""> <!--- İlaç Id --->
        <cfargument name="note_med" default=""><!--- not--->
        <cfargument name="money_limit_drug" default=""><!--- money---> 
        <cfargument name="payment_rate" default=""><!--- ödeme oranı---> 
        <cfargument name="drug_id" default="">
        <cfquery name="UPD_HEALTH_ASSURANCE_TYPE_MEDICATION" datasource="#dsn#">
            UPDATE
                SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION
            SET 
                ASSURANCE_ID = <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                MEDICATION =  <cfif len(arguments.medication)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.medication#"><cfelse>NULL</cfif>,
                MAX = <cfif len(arguments.max_med)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_med#"><cfelse>NULL</cfif>,
                PERIOD = <cfif len(arguments.period_med)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_med#"><cfelse>NULL</cfif>,
                NOTE = <cfif len(arguments.note_med)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.note_med#"><cfelse>NULL</cfif>,
                MONEY_LIMIT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.money_limit_drug#">,
                PAYMENT_RATE =  <cfif len(arguments.payment_rate)><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#arguments.payment_rate#"><cfelse>NULL</cfif>,
                DRUG_ID = <cfif len(arguments.drug_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.drug_id#"><cfelse>NULL</cfif>
            WHERE
                MEDICATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.medication_id#">
        </cfquery>
    </cffunction>
    <cffunction name="DEL_HEALTH_ASSURANCE_TYPE_MEDICATION" access="remote"  returntype="any">
        <cfargument name="medication_id" default=""> 
        <cfquery name="DEL_HEALTH_ASSURANCE_TYPE_MEDICATION" datasource="#dsn#">
            DELETE FROM SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION WHERE MEDICATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.medication_id#">
        </cfquery>
    </cffunction>
    <cffunction name="UPD_HEALTH_EXPENSES_ROW" access="remote" returnformat="JSON" returntype="any">
        <cfargument name="expense_id" default="">
        <cfargument name="assurance_type" default="">
        <cfargument name="comp_health_amount" default="">
        <cfargument name="emp_health_amount" default="">
        <cfset queryStatus = true>
        
            <cfquery name="UPD_HEALTH_EXPENSES_ROW" datasource="#dsn2_alias#">
                UPDATE
                    EXPENSE_ITEM_PLANS
                SET
                    ASSURANCE_ID = <cfif isdefined("arguments.assurance_type") and len(arguments.assurance_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_type#"><cfelse>NULL</cfif>,
                    COMPANY_HEALTH_AMOUNT = <cfif isdefined("arguments.comp_health_amount") and len(arguments.comp_health_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.comp_health_amount#"><cfelse>NULL</cfif>,
                    EMPLOYEE_HEALTH_AMOUNT = <cfif isdefined("arguments.emp_health_amount") and len(arguments.emp_health_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.emp_health_amount#"><cfelse>NULL</cfif>
                WHERE
                    EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.expense_id#">
            </cfquery>
            
        <cfreturn queryStatus>
    </cffunction>
    <cffunction name="GET_HEALTH_ASSURANCE_TYPE_LIMB" access="remote"  returntype="any">
        <cfargument name="assurance_id" default=""> 
        <cfquery name="GET_HEALTH_ASSURANCE_TYPE_LIMB" datasource="#dsn#" result="MAX_ID">
            SELECT
                ASSURANCE_LIMB_ID,
                SHL.LIMB_ID,
                ASSURANCE_ID,
                PERIOD,
                MAX,
                NOTE,
                LIMB_NAME,
                MONEY_LIMIT,
                PAYMENT_RATE
            FROM   
                SETUP_HEALTH_ASSURANCE_TYPE_LIMB SHL LEFT JOIN 
                SETUP_LIMB SL ON SHL.LIMB_ID=SL.LIMB_ID
            WHERE
                ASSURANCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"> 
        </cfquery>
        <cfreturn GET_HEALTH_ASSURANCE_TYPE_LIMB>
    </cffunction>
    <cffunction name="ADD_HEALTH_ASSURANCE_TYPE_LIMB" access="remote"  returntype="any">
        <cfargument name="period_limb_" default=""> <!---  periyot --->
        <cfargument name="max_limb_" default=""> <!--- maximum tutar --->
        <cfargument name="assurance_id" default=""><!--- Teminat Id--->
        <cfargument name="limb_id" default=""><!--- Limb Id--->
        <cfargument name="note_limb" default=""><!--- NOT --->
        <cfargument name="money_limit_limb" default=""><!--- money --->
        <cfargument name="payment_rate_limb" default=""><!--- ödeme oranı --->
        <cfquery name="ADD_HEALTH_ASSURANCE_TYPE_LIMB" datasource="#dsn#">
            INSERT INTO
                SETUP_HEALTH_ASSURANCE_TYPE_LIMB
                (
                    LIMB_ID,
                    ASSURANCE_ID,
                    PERIOD,
                    MAX,
                    NOTE,
                    MONEY_LIMIT,
                    PAYMENT_RATE
                )
                VALUES
                (
                    <cfif len(arguments.limb_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limb_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.period_limb_)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_limb_#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.max_limb_)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_limb_#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.note_limb)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.note_limb#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.money_limit_limb#">,
                    <cfif len(arguments.payment_rate_limb)><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#arguments.payment_rate_limb#"><cfelse>NULL</cfif>
                )
        </cfquery>
    </cffunction>
    <cffunction name="UPD_HEALTH_ASSURANCE_TYPE_LIMB" access="remote"  returntype="any">
        <cfargument name="ASSURANCE_LIMB_ID" default=""> <!---  ASSURANCE_LIMB_ID --->
        <cfargument name="period_limb_" default=""> <!---  periyot --->
        <cfargument name="max_limb_" default=""> <!--- maximum tutar --->
        <cfargument name="assurance_id" default=""><!--- Teminat Id--->
        <cfargument name="limb_id_" default=""><!--- Uzuv Id--->
        <cfargument name="note_limb" default=""><!--- NOT--->
        <cfargument name="money_limit_limb" default=""><!--- money --->
        <cfargument name="payment_rate_limb" default=""><!--- ödeme oranı --->
        <cfquery name="UPD_HEALTH_ASSURANCE_TYPE_LIMB" datasource="#dsn#">
            UPDATE
                SETUP_HEALTH_ASSURANCE_TYPE_LIMB
            SET   
                LIMB_ID =  <cfif len(arguments.limb_id_)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.limb_id_#"><cfelse>NULL</cfif>,              
                ASSURANCE_ID = <cfif len(arguments.assurance_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_id#"><cfelse>NULL</cfif>,
                PERIOD = <cfif len(arguments.period_limb_)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_limb_#"><cfelse>NULL</cfif>,               
                MAX = <cfif len(arguments.max_limb_)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_limb_#"><cfelse>NULL</cfif>,             
                NOTE =  <cfif len(arguments.note_limb)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.note_limb#"><cfelse>NULL</cfif>,
                MONEY_LIMIT = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.money_limit_limb#">,
                PAYMENT_RATE =  <cfif len(arguments.payment_rate_limb)><cfqueryparam cfsqltype="CF_SQL_FLOAT" value="#arguments.payment_rate_limb#"><cfelse>NULL</cfif>
            WHERE
                ASSURANCE_LIMB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ASSURANCE_LIMB_ID#">
        </cfquery>
    </cffunction>
    <cffunction name="DEL_HEALTH_ASSURANCE_TYPE_LIMB" access="remote"  returntype="any">
        <cfargument name="assurance_limb_id" default=""> 
        <cfquery name="DEL_HEALTH_ASSURANCE_TYPE_LIMB" datasource="#dsn#">
            DELETE FROM SETUP_HEALTH_ASSURANCE_TYPE_LIMB WHERE ASSURANCE_LIMB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assurance_limb_id#">
        </cfquery>
    </cffunction>
</cfcomponent>