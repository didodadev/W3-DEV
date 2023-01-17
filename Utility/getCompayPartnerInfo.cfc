<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Fatih Ayık		
Analys Date : 20/05/2016			Dev Date	: 20/05/2016		
Description :
	Bu utility kurumsal üyeye ve kurumsal üyeye ait partnera ait bilgileri getirir applicationStart methodunda create edilir.
	
Patameters :
		partnerId : Kurumsal üye çalışna Id.
		companyId : Kurumsal üye Id
		
		bu iki parametreden birini mutlaka gönderilmesi gerekiyor.

Used : getCompanyPartnerId.get(partnerId:23);
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get" access="public" returntype="query">
        <cfargument name="partnerId" type="numeric" default="0" required="yes" hint="Kurumsal üye çalışna Id">
        <cfargument name="companyId" type="numeric" default="0" required="yes" hint="Kurumsal üye Id">
        
		<cfquery name="get" datasource="#DSN#">
            SELECT 
                C.COMPANY_ID,
                C.NICKNAME,
                C.FULLNAME,
                CP.PARTNER_ID,
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME,
                CP.COMPANY_PARTNER_EMAIL
            FROM 
            	COMPANY C
                LEFT JOIN COMPANY_PARTNER CP CP.COMPANY_ID = C.COMPANY_ID
            WHERE 
                <cfif arguments.companyId neq 0>
                    C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companyId#">
                <cfelse>
                    CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partnerId#">  
                </cfif>
        </cfquery> 
        
		<cfreturn get>
	</cffunction>
</cfcomponent>