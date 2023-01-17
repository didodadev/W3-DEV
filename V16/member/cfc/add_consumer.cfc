<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset DSN2 = "#dsn#_#session.ep.company_id#">
    <cfset dsn_alias = "#dsn#">
    <cfset dsn2_alias = "#dsn2#">
    
	<cffunction name="chk_tckn" access="remote" returnformat="plain" returntype="any" hint="Aynı TC TC Kimlik Numaralı Bireysel Uye Kontrolu Yapar">
        <cfargument name="tc_identity" type="string" required="yes">
        <cfargument name="consumer_status" type="string" required="no" default="">
		<cfif isdefined("session.ep.userid")>        
			<cfset return_val = "">
            <cfquery name="get_consumer_tc_kontrol" datasource="#dsn2#">
                SELECT
                    CONSUMER_ID,
                    TERMINATE_DATE,
                    CONSUMER_STATUS
                FROM
                    #dsn_alias#.CONSUMER
                WHERE
                    TC_IDENTY_NO = '#trim(arguments.tc_identity)#'
                    <cfif len(arguments.consumer_status)>
                        AND CONSUMER_STATUS = #arguments.consumer_status#
                    </cfif>
            </cfquery>
            <cfif get_consumer_tc_kontrol.recordcount gte 1>
                <cfif get_consumer_tc_kontrol.consumer_status eq 0>
                    <cfset return_val="Girilen TC kimlik No Sistemden Çıkmış Olan Bir Üyeye Ait. Lütfen Sistem Yöneticisine Başvurunuz !">
                <cfelse>
                    <cfset return_val="Aynı Tc Kimlik Numarası ile Kayıtlı Bir Üye Var. Lütfen Kontrol Ediniz !">
                </cfif>
            </cfif>
        <cfelse>
            <cfset return_val = ' '>
        </cfif>
		<cfreturn return_val>
    </cffunction>
	<cffunction name="chk_mobil" access="remote" returnformat="plain" returntype="any" hint="Aynı Mobil Telefon Numaralı Uye Kontrolu Yapar">
        <cfargument name="mobiltel" type="string" required="yes">
        <cfargument name="consumer_status" type="string" required="no" default="">
		<cfif isdefined("session.ep.userid")>        
			<cfset return_val = "">
            <cfquery name="get_consumer_mobil_kontrol" datasource="#dsn2#">
                SELECT
                    CONSUMER_ID,
                    TERMINATE_DATE,
                    CONSUMER_STATUS
                FROM
                    #dsn_alias#.CONSUMER
                WHERE
                    ISNULL(MOBIL_CODE,'')+MOBILTEL = '#arguments.mobiltel#'
				<cfif len(arguments.consumer_status)>
                    AND CONSUMER_STATUS = #arguments.consumer_status#
                </cfif>
            </cfquery>
            <cfif get_consumer_mobil_kontrol.recordcount gte 1>
            	<cfset return_val="1">
            <cfelse>
            	<cfset return_val="0">
            </cfif>
            
        <cfelse>
            <cfset return_val = ' '>
        </cfif>
		<cfreturn return_val>
    </cffunction>    
    <cffunction name="add_consumer" access="remote"  returnformat="plain" returntype="string" hint="Bireysel Üye Ekleme">
		<cfargument name="member_name" type="string" required="yes">
        <cfargument name="member_surname" type="string" required="yes">
		<cfargument name="tc_identity" type="string" required="no" default="">
        <cfargument name="member_special_code" type="string" required="no" default="">
        <cfargument name="cons_member_cat" type="string" required="no" default="">
        <cfargument name="consumer_stage" type="string" required="yes">
        <cfargument name="adres_type" type="string" required="no" default="">
        <cfargument name="email" type="string" required="no" default="">
        <cfargument name="fax_number" type="string" required="no" default="">
        <cfargument name="faxcode" type="string" required="no" default="">
        <cfargument name="comp_name" type="string" required="no" default="">
        <cfargument name="mobil_code" type="string" required="no" default="">
        <cfargument name="mobil_tel" type="string" required="no" default="">
        <cfargument name="mobil_code_2" type="string" required="no" default="">
        <cfargument name="mobil_tel_2" type="string" required="no" default="">
        <cfargument name="tax_office" type="string" required="no" default="">
        <cfargument name="tax_num" type="string" required="no" default="">
        <cfargument name="tel_number" type="string" required="no" default="">
        <cfargument name="tel_code" type="string" required="no" default="">
        <cfargument name="address" type="string" required="no" default="">
        <cfargument name="county_id" type="string" required="no" default="">
        <cfargument name="city" type="string" required="no" default="">
        <cfargument name="district_id" type="string" required="no" default="">
        <cfargument name="vocation_type" type="string" required="no" default="">
        <cfargument name="ims_code_id" type="string" required="no" default="">
        <cfargument name="userid" type="string" required="no" default="">
        <cfargument name="member_code" type="string" required="no" default="">
        <cfargument name="acc" type="string" required="no" default="">
        <cfargument name="use_efatura" type="string" required="no" default="0">
        <cfargument name="efatura_data" type="string" required="no" default="">
        <cfargument name="xml_kontrol_tcnumber" type="string" required="no" default="0">
    	<cfif isdefined("session.ep.userid")>
			<cfif len(mobil_tel) eq 10>
            	<cfset mobil_code = left(mobil_tel,3)>
                <cfset mobil_tel = right(mobil_tel,7)>
            </cfif>
            
			<cfset cmp = "">

			<cfif len(arguments.tc_identity) and arguments.xml_kontrol_tcnumber neq 0>
                <cfset cmp = createObject("component","V16.member.cfc.add_consumer") />
				<cfset cmp.chk_tckn(
                        tc_identity:arguments.tc_identity
                    ) />
            </cfif>	
            <cfif not len(cmp)>
            
				<cfset list="',""">
                <cfset list2=" , ">
                <cfset arguments.member_name=replacelist(arguments.member_name,list,list2)>
                <cfset arguments.member_surname=replacelist(arguments.member_surname,list,list2)>
                
                <cfquery name="ADD_CONSUMER" datasource="#DSN2#">
                    INSERT INTO
                        #dsn_alias#.CONSUMER
                    (
                        IS_CARI,
                        ISPOTANTIAL,
                        OZEL_KOD,
                        CONSUMER_CAT_ID,
                        CONSUMER_STAGE,
                        CONSUMER_EMAIL,
                        CONSUMER_FAX,
                        CONSUMER_FAXCODE,
                        COMPANY,
                        CONSUMER_NAME,
                        CONSUMER_SURNAME,
                        MOBIL_CODE,
                        MOBILTEL,
                        MOBIL_CODE_2,
                        MOBILTEL_2,
                        TAX_OFFICE,
                        TAX_NO,
                    <cfif len(arguments.adres_type)>
                        CONSUMER_HOMETEL,
                        CONSUMER_HOMETELCODE,
                        HOMEADDRESS,
                        HOME_COUNTY_ID,
                        HOME_CITY_ID,
                        HOME_DISTRICT_ID,
                    <cfelse>
                        CONSUMER_WORKTEL,
                        CONSUMER_WORKTELCODE,
                        TAX_ADRESS,
                        TAX_COUNTY_ID,
                        TAX_CITY_ID,
                        TAX_DISTRICT_ID,
                    </cfif>
                        TC_IDENTY_NO,
                        VOCATION_TYPE_ID,
                        IMS_CODE_ID,
                        PERIOD_ID,
                        RECORD_IP,
                        RECORD_MEMBER,
                        RECORD_DATE,
                        USE_EFATURA,
                        EFATURA_DATE
                    )
                    VALUES 	 
                    (
                        1,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_special_code#" null="#not len(arguments.member_special_code)#">,
                        <cfif len(arguments.cons_member_cat)>#cons_member_cat#,<cfelse>#consumer_cat_id#,</cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.consumer_stage#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" null="#not len(arguments.email)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fax_number#" null="#not len(arguments.fax_number)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.faxcode#" null="#not len(arguments.faxcode)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comp_name#" null="#not len(arguments.comp_name)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_surname#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobil_code#" null="#not len(arguments.mobil_code)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobil_tel#" null="#not len(arguments.mobil_tel)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobil_code_2#" null="#not len(arguments.mobil_code_2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobil_tel_2#" null="#not len(arguments.mobil_tel_2)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_office#" null="#not len(arguments.tax_office)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_num#" null="#not len(arguments.tax_num)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_number#" null="#not len(arguments.tel_number)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel_code#" null="#not len(arguments.tel_code)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.address#" null="#not len(arguments.address)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#" null="#not len(arguments.county_id)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#" null="#not len(arguments.city)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.district_id#" null="#not len(arguments.district_id)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tc_identity#" null="#not len(arguments.tc_identity)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vocation_type#" null="#not len(arguments.vocation_type)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ims_code_id#" null="#not len(arguments.ims_code_id)#">,
                        #session.ep.period_id#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        #session.ep.userid#,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.use_efatura#">,
                        <cfqueryparam cfsqltype="cf_sql_datetime" value="#arguments.efatura_data#" null="#not len(arguments.efatura_data)#">
                    )
                    SELECT SCOPE_IDENTITY() MAX_CONS
                </cfquery>
    
                <cfset get_max_cons.max_cons = ADD_CONSUMER.MAX_CONS>
    
                <cfquery name="UPD_MEMBER_CODE" datasource="#DSN2#">
                    UPDATE 
                        #dsn_alias#.CONSUMER 
                    SET 
                        <cfif isdefined("arguments.member_code") and len(arguments.member_code)>
                            MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.member_code)#">
                        <cfelse>
                            MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="B#get_max_cons.max_cons#">
                        </cfif>
                    WHERE 
                        CONSUMER_ID = #get_max_cons.max_cons#
                </cfquery>
                
                <cfquery name="ADD_COMP_PERIOD" datasource="#DSN2#">
                    INSERT INTO
                        #dsn_alias#.CONSUMER_PERIOD
                    (
                        CONSUMER_ID,
                        PERIOD_ID,
                        ACCOUNT_CODE
                    )
                    VALUES
                    (
                        #get_max_cons.max_cons#,
                        #session.ep.period_id#,
                        <cfif len(acc)><cfqueryparam cfsqltype="cf_sql_varchar" value="#acc#"><cfelse>NULL</cfif>
                    )
                </cfquery>
                
                <cfquery name="add_branch_related" datasource="#DSN2#">
                    INSERT INTO
                        #dsn_alias#.COMPANY_BRANCH_RELATED
                    (
                        CONSUMER_ID,
                        OUR_COMPANY_ID,
                        BRANCH_ID,
                        OPEN_DATE,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
                </cfquery>
                
                <cfif session.ep.our_company_info.is_efatura and len(arguments.tc_identity)>
                    <cfset cmp = createObject("component","V16.objects.cfc.upd_einvoice_status") />
                    <cfset cmp.upd_einvoice_status(
                            tc_identity:arguments.tc_identity
                        ) />
                </cfif>
            	<cfset return_val = get_max_cons.max_cons>            
            <cfelse>
            	<cfset return_val = cmp>
            </cfif>

        <cfelse>
        	<cfset return_val = ''>
        </cfif>

		<cfreturn return_val>
	</cffunction>
	
</cfcomponent>
