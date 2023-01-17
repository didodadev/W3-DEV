<cfcomponent extends = "V16/member/cfc/member_company">

    <cfif IsDefined("session.ep")>
        <cfparam name="session_base" default="#session.ep#">
    <cfelseif IsDefined("session.pp")>
        <cfparam name="session_base" default="#session.pp#">
    <cfelseif IsDefined("session.ww")>
        <cfparam name="session_base" default="#session.ww#">
    </cfif>

    <cffunction name = "add_corporate_info" returnType = "any" returnformat = "JSON" access = "public" description = "add company - partner">
        <cfargument name="wrk_id" type="string" default="#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_'&round(rand()*100)#">

        <!--- <cfdump var = "#arguments#" abort> --->

        <cftransaction>

            <cfset ADD_COMPANY = this.ADD_COMPANY( argumentCollection = arguments ) />

            <cfset get_max.max_company = ADD_COMPANY.MAX_COMPANY>
            
            <cfset ADD_COMP_PERIOD = this.ADD_COMP_PERIOD(
                company_id:get_max.max_company,
                period_id:arguments.period_id
            ) />

            <cfset arguments.partner_username = arguments.company_partner_email />
            
            <cf_cryptedpassword password="#partner_password#" output="partner_password">

            <cfset ADD_PARTNER = this.ADD_PARTNER(
                company_id:get_max.max_company,
                name:'#iIf(isdefined('arguments.name') and len(arguments.name),"arguments.name",DE(""))#',
                soyad:'#iIf(isdefined('arguments.soyad') and len(arguments.soyad),"arguments.soyad",DE(""))#',
                company_partner_status:'#iIf(isdefined('arguments.company_partner_status') and len(arguments.company_partner_status),"arguments.company_partner_status",DE(""))#',
                title:'#iIf(isdefined('arguments.title') and len(arguments.title),"arguments.title",DE(""))#',
                company_partner_email:'#iIf(isdefined('arguments.company_partner_email') and len(arguments.company_partner_email),"arguments.company_partner_email",DE(""))#',
                mobilcat_id_partner:'#iIf(isdefined('arguments.mobilcat_id_partner') and len(arguments.mobilcat_id_partner),"arguments.mobilcat_id_partner",DE(""))#',
                mobiltel_partner:'#iIf(isdefined('arguments.mobiltel_partner') and len(arguments.mobiltel_partner),"arguments.mobiltel_partner",DE(""))#',
                telcod:'#iIf(isdefined('arguments.telcod') and len(arguments.telcod),"arguments.telcod",DE(""))#',
                tel1:'#iIf(isdefined('arguments.tel1') and len(arguments.tel1),"arguments.tel1",DE(""))#',
                homepage:'#iIf(isdefined('arguments.homepage') and len(arguments.homepage),"arguments.homepage",DE(""))#',
                mission:'#iIf(isdefined('arguments.mission') and len(arguments.mission),"arguments.mission",DE(""))#',
                adres:'#iIf(isdefined('arguments.adres') and len(arguments.adres),"arguments.adres",DE(""))#',
                postcod: '#iIf(isdefined('arguments.postcod') and len(arguments.postcod),"arguments.postcod",DE(""))#',
                county_id:'#iIf(isdefined('arguments.county_id') and len(arguments.county_id),"arguments.county_id",DE(""))#',
                city_id:'#iIf(isdefined('arguments.city_id') and len(arguments.city_id),"arguments.city_id",DE(""))#',
                country:'#iIf(isdefined('arguments.country') and len(arguments.country),"arguments.country",DE(""))#',
                semt:'#iIf(isdefined('arguments.semt') and len(arguments.semt),"arguments.semt",DE(""))#',
                partner_username: '#iIf(isdefined('arguments.partner_username') and len(arguments.partner_username),"arguments.partner_username",DE(""))#',
                partner_password: '#iIf(isdefined('partner_password') and len(partner_password),"partner_password",DE(""))#'
            )>
            <cfset GET_MAX_PARTNER = this.GET_MAX_PARTNER()>
            <cfset UPD_MEMBER_CODE = this.UPD_MEMBER_CODE(partner_id:get_max_partner.max_partner_id)>
            <cfset ADD_COMPANY_PARTNER_DETAIL = this.ADD_COMPANY_PARTNER_DETAIL(partner_id:get_max_partner.max_partner_id)>
            <cfset ADD_PART_SETTINGS = this.ADD_PART_SETTINGS(partner_id:get_max_partner.max_partner_id)>
            
            <cf_addressbook
			design		= "1"
			type		= "2"
			type_id		= "#get_max_partner.max_partner_id#"
			active		= "#arguments.company_partner_status#"
			name		= "#arguments.name#"
			surname		= "#arguments.soyad#"
			sector_id	= "#arguments.company_sector#"
			company_name= "#arguments.fullname#"
			title		= "#arguments.title#"
			email		= "#arguments.company_partner_email#"
			telcode		= "#arguments.telcod#"
			telno		= "#arguments.tel1#"
			faxno		= "#iIf(isdefined('arguments.fax') and len(arguments.fax),"arguments.fax",DE(""))#"
			mobilcode	= "#arguments.mobilcat_id_partner#"
			mobilno		= "#arguments.mobiltel_partner#"
			web			= "#arguments.homepage#"
			postcode	= "#arguments.postcod#"
			address		= "#arguments.adres#"
			semt		= "#arguments.semt#"
			county_id	= "#arguments.county_id#"
			city_id		= "#arguments.city_id#"
			country_id	= "#arguments.country#">

            <cfset member_code_ = 'C#get_max.max_company#'>
            
            <cfset UPD_MEMBER_CODE = this.UPD_MEMBER_CODE_COMPANY(company_id:get_max.max_company, member_code:member_code_)>
            <cfset UPD_MANAGER_PARTNER = this.UPD_MANAGER_PARTNER(company_id:get_max.max_company, partner_id:get_max_partner.max_partner_id)>

            <!--- <cfif isdefined("arguments.upper_sector_cat") and len(arguments.upper_sector_cat)>
                <cfloop list="#arguments.upper_sector_cat#" index="i">
                    <cfset ADD_COMP_SECTOR = this.ADD_COMP_SECTOR(sector_id:i, company_id:get_max.max_company)>
                </cfloop>
            </cfif> --->
            
            <cfif isdefined("arguments.company_sector") and len(arguments.company_sector)>
                <cfloop list="#arguments.company_sector#" index="i">
                    <cfset ADD_COMP_SECTOR = this.ADD_COMP_SECTOR(sector_id:i, company_id:get_max.max_company)>
                </cfloop>
            </cfif>
            
            <!--- <cfif isdefined("get_x_user_friendly.property_value") and get_x_user_friendly.property_value eq 1>
                <cf_workcube_user_friendly user_friendly_url='#left(arguments.fullname,250)#' action_type='COMPANY_ID' action_id='#get_max.max_company#' action_page='member.form_list_company&event=det&cpid=#get_max.max_company#'>
            </cfif> --->

        </cftransaction>

    </cffunction>

</cfcomponent>