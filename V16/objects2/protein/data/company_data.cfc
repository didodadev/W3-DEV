<cfcomponent>
    <cfparam name="dsn" default="#application.SystemParam.SystemParam().dsn#">
    <cfset companyComp = createObject("component","v16.member.cfc.member_company")>
    <cfset paper_data = createObject("component","V16.objects2.protein.data.paper_data")>

    <cffunction name="CREATE_COMPANY" returntype="any">
        <cfargument name="asset1" default="">
        <cfargument name="asset2" default="">
        <cfargument name="wrk_id" default="">
        <cfargument name="companycat_id" default="">
        <cfargument name="fullname" default="">
        <cfargument name="taxno" default="">
        <cfargument name="userid" default="#session.ep.userid#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="record_date" default="#now()#">
        <cfargument name="is_person" default="">

        <cftransaction>
            <cfset comp = companyComp.ADD_COMPANY(arguments)>
            <cfreturn comp.generatedkey>
        </cftransaction>
        <cfreturn "false">
    </cffunction>

    <cffunction name="ADD_WORKGROUP_MEMBER" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="our_company_id" default="#session.ep.company_id#">
        <cfargument name="pos_code" default="">
        <cfargument name="userid" default="#session.ep.userid#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="record_date" default="#now()#">

        <cfset companyComp.ADD_WORKGROUP_MEMBER(arguments)>
    </cffunction>

    <cffunction name="ADD_COMPANY_PERIOD" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="period_id" default="">

        <cfset companyComp.ADD_COMP_PERIOD(arguments)>
    </cffunction>

    <cffunction name="ADD_COMPANY_SECTORS" returntype="any">
        <cfargument name="company_sectors" default="">
        <cfargument name="company_id" default="">

        <cftransaction>
            <!--- Index yerine item olması gerekmezmi? --->
            <cfloop list="#attributes.company_sectors#" index="i">
                <cfset addCompanySector(sector_id:i, company_id:company_id)>
            </cfloop>
        </cftransaction>
    </cffunction>

    <cffunction name="ADD_COMPANY_SECTOR" returntype="any">
        <cfargument name="sector_id" default="">
        <cfargument name="company_id" default="">
        
        <cfset companyComp.ADD_COMP_SECTOR(arguments.sector_id, arguments.company_id)>
    </cffunction>

    <cffunction name="UPDATE_MEMBER_CODE" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="member_code" default="">
        
        <cfset companyComp.UPD_MEMBER_CODE(arguments.company_id, arguments.member_code)>
    </cffunction>

    <cffunction name="UPDATE_PARTNER_MANAGER" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="partner_id" default="">
        
        <cfset companyComp.UPD_MANAGER_PARTNER(arguments.company_id, arguments.partner_id)>
    </cffunction>

    <cffunction  name="GET_COMPANY_BY_ID">
        <cfargument name="company_id" required="yes">

        <cfquery name="GET_COMPANY_BY_ID" datasource="#dsn#">
            SELECT * FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
        </cfquery>
        <cfreturn GET_COMPANY_BY_ID>
    </cffunction>

    <cffunction name="GET_COMPANY_BY_CODE" access="public">
        <cfargument name="company_code" required="yes">
        <cfargument name="company_id" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">
        <cfset arguments.company_code = trim(arguments.company_code)>

        <cfreturn companyComp.GET_COMPANY_CODE(arguments.company_code, arguments.company_id)>
    </cffunction>

    <cffunction name="IS_DUPLICATE_COMPANY_CODE" access="public">
        <cfargument name="company_code" required="yes">
        <cfargument name="company_id" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">
        <cfset arguments.company_code = trim(arguments.company_code)>

        <cfset company = getCompanyByCode(arguments.company_code, arguments.company_id)>
        <cfreturn company.recordcount ? true : false>
    </cffunction>

    <cffunction name="GET_COMPANY_BY_NAME" access="public">
        <cfargument name="fullname" default="">
        <cfargument name="nickname" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">
        <cfset arguments.fullname = trim(arguments.fullname)>
        <cfset arguments.nickname = trim(arguments.nickname)>

        <cfreturn companyComp.GET_COMP_BY_NAME(arguments.fullname, arguments.nickname)>
    </cffunction>

    <cffunction name="IS_DUPLICATE_COMPANY_NAME" access="public">
        <cfargument name="fullname" default="">
        <cfargument name="nickname" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cfset company = getCompanyByName(arguments.fullname, arguments.nickname)>
        <cfreturn company.recordcount ? true : false>
    </cffunction>

    

    <cffunction name="createPartner" returntype="any">
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

    <cffunction name="updateMemberCode2" returntype="any">
        <cfargument name="partner_id" default="">

        <cfset companyComp.UPD_MEMBER_CODE(arguments.partner_id)>
    </cffunction>

    <cffunction name="addCompanyPartnerDetail" returntype="any">
        <cfargument name="partner_id" default="">
        
        <cfset companyComp.ADD_COMPANY_PARTNER_DETAIL(arguments.partner_id)>
    </cffunction>

    <cffunction name="addPartnerSettings" returntype="any">
        <cfargument name="partner_id" default="">
        <cfargument name="language" default="#session.ep.language#">

        <cfset companyComp.ADD_PART_SETTINGS(arguments.partner_id, arguments.language)>
    </cffunction>

    <cffunction name="getMaxPartner">
        <cfreturn companyComp.GET_MAX_PARTNER()>
    </cffunction>

    <cffunction name="createSubscriptionContract" access="public">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cftransaction>
            <cfset subscriptionContractComp.ADD_SUBSCRIPTION_CONTRACT(arguments)>
            <cfreturn getMaxSubscription(arguments.wrk_id).subscription_id>
        </cftransaction>
        <cfreturn "false">
    </cffunction>

    <cffunction name="addContractRows">
        <cfargument name="rows_" default="">
        <cfargument name="product_id" default="">
        <cfargument name="deliver_date" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cftransaction>
            <cfloop from="1" to="#attributes.rows_#" index="i">
                <cf_date tarih="attributes.deliver_date#i#">
                <cfinclude template="get_dis_amount.cfm">
                <cfif isdefined("attributes.product_id#i#") and len(evaluate("attributes.product_id#i#"))>
                    <cfset addContractRow(arguments)>
                </cfif>
            </cfloop>
        </cftransaction>
    </cffunction>

    <cffunction name="addContractRow">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cfset subscriptionContractComp.ADD_CONTRACT_ROW(arguments)>
    </cffunction>

    <cffunction name="getSubscriptionNoByPaper">
        <cfargument name="paper_code" default="">
        <cfargument name="paper_number" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">
        
        <cfreturn subscriptionContractComp.Check_No(arguments.DSN3, arguments.paper_code, arguments.paper_number)>
    </cffunction>

    <cffunction name="getMaxSubscription">
        <cfargument name="wrk_id" default="">
        <cfargument name="DSN3" default="#variables.dsn3#">

        <cfreturn subscriptionContractComp.GET_MAX_SUBSCRIPTION(arguments.DSN3, arguments.wrk_id)>
    </cffunction>
</cfcomponent>