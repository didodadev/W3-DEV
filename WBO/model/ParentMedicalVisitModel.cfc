<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez		
Analys Date : 01/04/2016			Dev Date	: 17/05/2016		
Description :
	Bu component çalışan yakını visiteleri objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- get --->
    <cffunction name="get" access="public" returntype="query">
		<cfargument name="fee_id" type="numeric" default="0" required="yes" hint="Vizite ID">
        
		<cfquery name="get" datasource="#dsn#">
            SELECT
                ES.*,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                B.BRANCH_NAME,		
                B.SSK_OFFICE,
                B.SSK_NO
            FROM
                EMPLOYEES_SSK_FEE_RELATIVE ES
                INNER JOIN EMPLOYEES E ON  E.EMPLOYEE_ID = ES.EMPLOYEE_ID
                LEFT JOIN BRANCH B ON B.BRANCH_ID = ES.BRANCH_ID
            WHERE 
                ES.FEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.FEE_ID#">
        </cfquery>

        
		<cfreturn get>
	</cffunction>
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
		<cfargument name="employee_id" type="numeric" default="0" required="yes" hint="Çalışan ID">
        <cfargument name="feeDate" type="string" default="" required="yes" hint="Vizite Tarihi">
        <cfargument name="feeHour" type="numeric" default="0"  required="no" hint="Vizite Saati">
		<cfargument name="validator_pos_code" type="numeric" default="0" required="no" hint="Onaylayan Pozisyon Kodu">
        <cfargument name="validator_pos_code_1" type="numeric" default="0" required="no" hint="Onaylayan1 Pozisyon Kodu">
        <cfargument name="validator_pos_code_2" type="numeric" default="0" required="no" hint="Onaylayan2 Pozisyon Kodu">
        <cfargument name="ill_name" type="string" required="yes" hint="Vizite Alacak Kişinin Adı">
        <cfargument name="ill_surname" type="string" required="yes" hint="Vizite Alacak Kişinin Soyadı">
		<cfargument name="ill_relative" type="string" required="yes" hint="Vizite Alacak Kişinin Yakınlığı">
        <cfargument name="ill_sex" type="boolean" default="1" required="yes" hint="Vizite Alacak Kişinin Cinsiyeti">
        <cfargument name="birth_date" type="string" required="yes" hint="Vizite Alacak Kişinin Doğum Tarihi">
        <cfargument name="birth_place" type="string" required="yes" hint="Vizite Alacak Kişinin Doğum Yeri">
        <cfargument name="tc_identy_no" type="string" required="yes" hint="Vizite Alacak Kişinin TC Kimlik Numarası">
        <cfargument name="branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
        <cfargument name="in_out_id" type="numeric" default="0" required="yes" hint="Çalışan Ücret Kartı ID">
        <cfargument name="fbx_myhome" type="boolean" default="0" required="no" hint="Self Servisten Kayıt Edilirse">

        <cfquery name="ADD_SSK_FEE" datasource="#DSN#" result="MAX_ID">
            INSERT INTO EMPLOYEES_SSK_FEE_RELATIVE
                (
                EMPLOYEE_ID,
                FEE_DATE,
                FEE_HOUR,
                <cfif arguments.fbx_myhome eq 0>
					<cfif arguments.VALIDATOR_POS_CODE neq 0>
                        VALIDATOR_POS_CODE,
                    <cfelse>
                        VALID,
                        VALID_EMP,
                        VALID_DATE,
                    </cfif>
                <cfelse>
					<cfif arguments.VALIDATOR_POS_CODE_1 neq 0>
                        VALIDATOR_POS_CODE_1,
                    <cfelse>
                        VALID_1,
                        VALID_EMP_1,
                        VALID_DATE_1,
                    </cfif>
                    <cfif arguments.VALIDATOR_POS_CODE_2 neq 0>
                        VALIDATOR_POS_CODE_2,
                    <cfelse>
                        VALID_2,
                        VALID_EMP_2,
                        VALID_DATE_2,
                    </cfif>
               	</cfif>
                ILL_NAME,
                ILL_SURNAME,
                ILL_RELATIVE,
                ILL_SEX,
                BIRTH_DATE,
                BIRTH_PLACE,
                TC_IDENTY_NO,
                BRANCH_ID,
                RECORD_EMP,
                RECORD_IP,
                RECORD_DATE,
                IN_OUT_ID
                )
            VALUES
                (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                <cfif len(arguments.feeDate)>#arguments.feeDate#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feeHour#">,
                <cfif arguments.fbx_myhome eq 0>
					<cfif arguments.VALIDATOR_POS_CODE neq 0>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.validator_pos_code#">,
                    <cfelse>
                        1,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    </cfif>
                <cfelse>
					<cfif arguments.VALIDATOR_POS_CODE_1 neq 0>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.VALIDATOR_POS_CODE_1#">,
                    <cfelse>
                        1,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    </cfif>
                    <cfif arguments.VALIDATOR_POS_CODE_2 neq 0>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.VALIDATOR_POS_CODE2_#">,
                    <cfelse>
                        1,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    </cfif>
                </cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ill_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ill_surname#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ill_relative#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.ill_sex#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.birth_date#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.birth_place#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tc_identy_no#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
                )
        </cfquery>
        
		<cfreturn MAX_ID.IDENTITYCOL>
	</cffunction>
    
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
		<cfargument name="fee_id" type="numeric" default="0" required="yes" hint="Vizite ID">
        <cfargument name="employee_id" type="numeric" default="0" required="yes" hint="Çalışan ID">
        <cfargument name="feeDate" type="string" default="" required="yes" hint="Vizite Tarihi">
        <cfargument name="feeHour" type="numeric" default="0"  required="no" hint="Vizite Saati">
		<cfargument name="valid" type="any" default="" required="no" hint="Onay">
        <cfargument name="validator_pos_code" type="numeric" default="0" required="no" hint="Onaylayan Pozisyon Kodu">
        <cfargument name="ill_name" type="string" required="yes" hint="Vizite Alacak Kişinin Adı">
        <cfargument name="ill_surname" type="string" required="yes" hint="Vizite Alacak Kişinin Soyadı">
		<cfargument name="ill_relative" type="string" required="yes" hint="Vizite Alacak Kişinin Yakınlığı">
        <cfargument name="ill_sex" type="boolean" default="1" required="yes" hint="Vizite Alacak Kişinin Cinsiyeti">
        <cfargument name="birth_date" type="string" required="yes" hint="Vizite Alacak Kişinin Doğum Tarihi">
        <cfargument name="birth_place" type="string" required="yes" hint="Vizite Alacak Kişinin Doğum Yeri">
        <cfargument name="tc_identy_no" type="string" required="yes" hint="Vizite Alacak Kişinin TC Kimlik Numarası">
        <cfargument name="branch_id" type="numeric" default="0" required="yes" hint="Şube ID">
        <cfargument name="in_out_id" type="numeric" default="0" required="yes" hint="Çalışan Ücret Kartı ID">
        
		<cfquery name="upd" datasource="#DSN#">
            UPDATE
                EMPLOYEES_SSK_FEE_RELATIVE
            SET
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                FEE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.feeDate#">,
                FEE_HOUR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.feeHour#">,
                <cfif len(arguments.valid)>
                    VALID = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.valid#">,
                    VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfelseif arguments.validator_pos_code neq 0>
                    VALIDATOR_POS_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.validator_pos_code#">,
                </cfif>
                ILL_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ill_name#">,
                ILL_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ill_surname#">,
                ILL_RELATIVE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ill_relative#">,
                ILL_SEX = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.ill_sex#">,
                BIRTH_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.birth_date#">,
                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">,
                BIRTH_PLACE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.birth_place#">,
                TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tc_identy_no#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
            WHERE
                FEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fee_id#">
        </cfquery>
        
		<cfreturn arguments.fee_id>
	</cffunction>
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
		<cfargument name="fee_id" type="numeric" default="0" required="yes" hint="Vizite ID">
        
		<cfquery name="del" datasource="#DSN#">
            DELETE FROM EMPLOYEES_SSK_FEE_RELATIVE WHERE FEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.FEE_ID#">
        </cfquery>	
        
		<cfreturn true>
	</cffunction>
</cfcomponent>