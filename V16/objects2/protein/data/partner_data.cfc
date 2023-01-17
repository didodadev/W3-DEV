<cfcomponent>
    <cfset variables.dsn = application.systemParam.systemParam().dsn>
    <cfset companyComp = createObject("component","v16.member.cfc.member_company")>

    <cffunction name="CREATE_PARTNER" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="name" default="">
        <cfargument name="soyad" default="">
        <cfargument name="company_partner_status" default="">
        <cfargument name="title" default="">
        <cfargument name="sex" default="">
        <cfargument name="language" default="#session.ep.language#">
        <cfargument name="department" default="">
        <cfargument name="company_partner_email" default="">
        <cfargument name="mobilcat_id_partner" default="">
        <cfargument name="mobiltel_partner" default="">
        <cfargument name="telcod" default="">
        <cfargument name="tel1" default="">
        <cfargument name="tel_local" default="">
        <cfargument name="fax" default="">
        <cfargument name="homepage" default="">
        <cfargument name="mission" default="">
        <cfargument name="record_date" default="#now()#">
        <cfargument name="userid" default="#session.ep.userid#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="adres" default="">
        <cfargument name="postcod" default="">
        <cfargument name="county_id" default="">
        <cfargument name="city_id" default="">
        <cfargument name="country" default="">
        <cfargument name="semt" default="">
        <cfargument name="tc_identity" default="">
        <cfargument name="birthdate" default="">
        
        <cftransaction>
            <cfset companyComp.ADD_PARTNER(arguments)>
            <cfreturn getMaxPartner().partner_id>
        </cftransaction>
        <cfreturn "false">
    </cffunction>

    <cffunction name="UPDATE_MEMBER_CODE" returntype="any">
        <cfargument name="partner_id" default="">

        <cfset companyComp.UPD_MEMBER_CODE(arguments.partner_id)>
    </cffunction>

    <cffunction name="ADD_COMPANY_PARTNER_DETAIL" returntype="any">
        <cfargument name="partner_id" default="">
        
        <cfset companyComp.ADD_COMPANY_PARTNER_DETAIL(arguments.partner_id)>
    </cffunction>

    <cffunction name="ADD_PARTNER_SETTINGS" returntype="any">
        <cfargument name="partner_id" default="">
        <cfargument name="language" default="#session.ep.language#">

        <cfset companyComp.ADD_PART_SETTINGS(arguments.partner_id, arguments.language)>
    </cffunction>

    <cffunction name="GET_MAX_PARTNER">
        <cfreturn companyComp.GET_MAX_PARTNER()>
    </cffunction>

    <cffunction name="GET_PARTNER_BY_ID" returntype="query">
        <cfargument name="partner_id" default="">

        <cfquery name="GET_PARTNER_BY_ID" datasource="#dsn#">
            SELECT * FROM COMPANY_PARTNER WHERE PARTNER_ID = #arguments.partner_id#
        </cfquery>
        <cfreturn GET_PARTNER_BY_ID>
    </cffunction>
</cfcomponent>