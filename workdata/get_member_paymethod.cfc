<!---
Desc: Üyenin Risk ve çalışma bilgilerindeki seçili ödeme yöntemini çekebilmek için yazıldı
Pınar Yıldız
092019
 ---->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_PAYMETHOD_FNC">
        <cfargument name="member_id" default="" required="yes">
        <cfargument name="member_type" default="1">
        <cfif member_type eq 1>
            <cfquery name="GET_PAYMETHOD" datasource="#DSN#">
                SELECT
                    CC.PAYMETHOD_ID,
                    SP.PAYMETHOD,
                    ISNULL(SP.DUE_DAY,0) AS DUE_DAY
                FROM
                    COMPANY_CREDIT CC
                        LEFT JOIN SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = CC.PAYMETHOD_ID
                WHERE
                    CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
                    AND CC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.COMPANY_ID#">
            </cfquery>
        <cfelse>
            <cfquery name="GET_PAYMETHOD" datasource="#DSN#">
                SELECT
                    CC.PAYMETHOD_ID,
                    SP.PAYMETHOD,
                    ISNULL(SP.DUE_DAY,0) AS DUE_DAY
                FROM
                    COMPANY_CREDIT CC
                        LEFT JOIN SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = CC.PAYMETHOD_ID
                WHERE
                    CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
                    AND CC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.COMPANY_ID#">
            </cfquery>
        </cfif>
        <cfreturn GET_PAYMETHOD>
    </cffunction>
</cfcomponent>

