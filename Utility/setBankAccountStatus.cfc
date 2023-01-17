<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Cemil Durgan			Developer	: Cemil Durgan		
Analys Date : 03/06/2016			Dev Date	: 03/06/2016	
Description :
	Bu utility banka hesabının durumunu günceller.
Parameters :
		bankAccountId	: banka hesap ID,
		status			: set edilecek status (0 ya da 1)
		
Usage : 	setBankAccountStatus.set(bankAccountId: 10,status: 1);
----------------------------------------------------------------------->
<cfcomponent>
	<cffunction name="set" access="public" returntype="boolean">
		<cfargument name="bankAccountId" type="numeric" required="yes" hint="Banka Hesap ID">
        <cfargument name="status" type="numeric" required="yes" hint="Status (0 : Pasif, 1 : Aktif)">
        
        <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset dsn2 = dsn & '_' & session.ep.period_year & '_' & session.ep.company_id>
        <cfset dsn3 = dsn & '_' & session.ep.company_id>
        
        <cfquery name="getAccountStatus" datasource="#dsn2#">
            SELECT
            	IS_OPEN
            FROM
            	#dsn3#.ACCOUNTS_OPEN_CONTROL
            WHERE
                ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#bankAccountId#">
                AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ep.period_id#">
        </cfquery>
        <cfif not getAccountStatus.recordcount>
            <cfquery name="addAccountStatus" datasource="#dsn2#">
                INSERT INTO
                #dsn3#.ACCOUNTS_OPEN_CONTROL
                (
                    ACCOUNT_ID,
                    IS_OPEN,
                    PERIOD_ID
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#bankAccountId#">,
                    1,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ep.period_id#">
                )
            </cfquery>
        </cfif>
        <cfquery name="updAccountStatus" datasource="#dsn2#">
            UPDATE
                #dsn3#.ACCOUNTS_OPEN_CONTROL
            SET
                IS_OPEN = #status#
            WHERE
                ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#bankAccountId#">
                AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ep.period_id#">
        </cfquery>
		<cfreturn true>
	</cffunction>
</cfcomponent>