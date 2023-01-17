<cfquery name="GET_SERI_PRODUCT" datasource="#DSN3#" maxrows="1">
	SELECT 
    	SGN.STOCK_ID,
        S.PRODUCT_NAME,
        S.PRODUCT_ID,
        SALE_START_DATE 
    FROM 
    	SERVICE_GUARANTY_NEW SGN,
        STOCKS S 
    WHERE 
    	SGN.STOCK_ID = S.STOCK_ID AND 
        SGN.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.seri_no#"> AND 
        SGN.SALE_START_DATE IS NOT NULL 
</cfquery>
<cfif get_seri_product.recordcount>
	<cfset seri_stock_id = get_seri_product.stock_id>
	<cfset seri_product_id = get_seri_product.product_id>
	<cfset seri_product_name = get_seri_product.product_name>
</cfif>

<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pp.userid#_'&round(rand()*100)>
<cfquery name="GET_STAGE" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		<cfif isdefined("session.pp.userid")>
			PTR.IS_PARTNER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww.userid")>
			PTR.IS_CONSUMER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
	ORDER BY
		PTR.PROCESS_ROW_ID
</cfquery>
<cfif not get_stage.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1503.Servis Durumu Bulunamadı! Müşteri Hizmetlerine Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif isdefined("attributes.is_new_member")>
	<cfquery name="GET_STAGE_COMP" datasource="#DSN#" maxrows="1">
		SELECT TOP 1
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            <cfif isdefined("session.pp.userid")>
                PTR.IS_PARTNER = 1 AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
            <cfelseif isdefined("session.ww.userid")>
                PTR.IS_CONSUMER = 1 AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
            </cfif>
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
        ORDER BY
            PTR.PROCESS_ROW_ID
	</cfquery>
	<cfif not get_stage_comp.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1504.Müşteri Aşaması Durumu Bulunamadı! Müşteri Hizmetlerine Başvurunuz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>

	<cftransaction>
        <cf_papers paper_type="SERVICE_APP">
        <cfset system_paper_no=paper_code & '-' & paper_number>
        <cfset system_paper_no_add=paper_number>
        
        <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
            UPDATE
                GENERAL_PAPERS
            SET
                SERVICE_APP_NUMBER = #system_paper_no_add#
            WHERE
                SERVICE_APP_NUMBER IS NOT NULL
        </cfquery>
    </cftransaction>	

    <cflock name="#CREATEUUID()#" timeout="20">
      	<cftransaction>
            <cfquery name="INS_COMP" datasource="#DSN#">
                INSERT INTO 
                    COMPANY
                    (
                        WRK_ID,
                        COMPANY_STATUS,
                        COMPANY_STATE,
                        FULLNAME,
                        NICKNAME,
                        COMPANY_TELCODE,
                        COMPANY_TEL1,
                        COMPANY_ADDRESS,
                        SEMT,
                        COMPANY_POSTCODE,
                        COUNTY,
                        CITY,
                        COMPANY_EMAIL,
                        IS_BUYER,
                        PERIOD_ID,
                        RECORD_PAR,
                        RECORD_IP,
                        RECORD_DATE
                    )
                    VALUES
                    (
                        '#wrk_id#',
                        1,
                        #get_stage_comp.process_row_id#,
                        '#attributes.comp_name#',
                        '#attributes.comp_name#',
                        <cfif len(attributes.tel_code)>'#attributes.tel_code#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.tel_number)>'#attributes.tel_number#'<cfelse>NULL</cfif>,	
                        <cfif len(attributes.address)>'#attributes.address#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.postcod)>'#attributes.postcod#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
                        <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
                        <cfif len(attributes.email)>'#trim(attributes.email)#'<cfelse>NULL</cfif>,
                        1,
                        #session.pp.period_id#,
                        #session.pp.userid#,
                        '#cgi.remote_addr#',
                        #now()#			
                    )
            </cfquery>
            <cfquery name="GET_MAX" datasource="#DSN#">
                SELECT MAX(COMPANY_ID) AS MAX_COMPANY FROM COMPANY WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
            </cfquery>	
            <cfquery name="ADD_COMP_PERIOD" datasource="#DSN#">
                INSERT INTO
                    COMPANY_PERIOD
                    (
                        COMPANY_ID,
                        PERIOD_ID
                    )
                    VALUES
                    (
                        #get_max.max_company#,
                        #session.pp.period_id#
                    )
            </cfquery>
            <cfquery name="ADD_PARTNER" datasource="#DSN#">
                INSERT INTO 
                    COMPANY_PARTNER
                    (
                        COMPANY_ID,
                        COMPANY_PARTNER_NAME,
                        COMPANY_PARTNER_SURNAME,
                        COMPANY_PARTNER_TELCODE,
                        COMPANY_PARTNER_TEL,
                        MOBIL_CODE,
                        MOBILTEL,
                        COMPANY_PARTNER_ADDRESS,
                        COMPANY_PARTNER_POSTCODE,
                        COUNTY,
                        CITY,
                        SEMT,
                        RECORD_DATE,
                        RECORD_PAR,
                        RECORD_IP	
                    )
                    VALUES
                    (
                        #get_max.max_company#,
                        '#attributes.member_name#',
                        '#attributes.member_surname#',
                        <cfif len(attributes.tel_code)>'#attributes.tel_code#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.tel_number)>'#attributes.tel_number#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.mobil_code)>'#attributes.mobil_code#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.mobil_tel)>'#attributes.mobil_tel#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.address)>'#attributes.address#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.postcod)>'#attributes.postcod#'<cfelse>NULL</cfif>,
                        <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
                        <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
                        #now()#,
                        #session.pp.userid#,
                        '#cgi.remote_addr#'	
                    )
            </cfquery>
            <cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
                SELECT
                    MAX(PARTNER_ID) MAX_PARTNER_ID
                FROM
                    COMPANY_PARTNER
            </cfquery>
            <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
                UPDATE
                    COMPANY_PARTNER
                SET
                    MEMBER_CODE = 'CP#get_max_partner.max_partner_id#'
                WHERE
                    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_partner.max_partner_id#">
            </cfquery>
            <cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
                INSERT INTO
                    COMPANY_PARTNER_DETAIL
                    (
                        PARTNER_ID
                    )
                    VALUES
                    (
                        #get_max_partner.max_partner_id#
                    )
            </cfquery>
            <cfquery name="ADD_PART_SETTINGS" datasource="#DSN#">
                INSERT INTO 
                    MY_SETTINGS_P 
                    (
                        PARTNER_ID,
                        TIME_ZONE,
                        MAXROWS,
                        TIMEOUT_LIMIT
                    )
                    VALUES 
                    (
                        #get_max_partner.max_partner_id#,
                        0,
                        20,
                        30
                    )
            </cfquery>
            <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
                UPDATE 
                    COMPANY 
                SET		
                    MEMBER_CODE='C#get_max.max_company#'
                WHERE 
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
            </cfquery>
            <cfquery name="UPD_MANAGER_PARTNER" datasource="#DSN#">
                UPDATE
                    COMPANY
                SET
                    MANAGER_PARTNER_ID = #get_max_partner.max_partner_id#
                WHERE
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
            </cfquery>
      	</cftransaction>
    </cflock>
</cfif>
<cfquery name="ADD_SERVICE" datasource="#DSN#" result="MAX_ID">
    INSERT INTO
        #dsn3_alias#.SERVICE
        (
            SERVICE_NO,
            SERVICE_STATUS_ID,
            COMMETHOD_ID,
            PRIORITY_ID,
            STOCK_ID,
            SERVICE_PRODUCT_ID,
            PRODUCT_NAME,
            PRO_SERIAL_NO,
            MAIN_SERIAL_NO,
            SERVICE_ACTIVE,
            ISREAD,
            SERVICE_COMPANY_ID,
            SERVICE_PARTNER_ID,
            <cfif len(appcat)>SERVICECAT_ID,</cfif>
            APPLICATOR_NAME,
            SERVICE_HEAD,
            SERVICE_DETAIL,
            APPLY_DATE,
            START_DATE,
            RECORD_DATE,
            RECORD_PAR,
            GUARANTY_START_DATE,
            SERVICE_ADDRESS,
            BRING_NAME,
            BRING_TEL_NO
        )
        VALUES
        (
            '#system_paper_no#',
            #get_stage.process_row_id#,
            6,
            1,
            <cfif isdefined("seri_stock_id")>#seri_stock_id#<cfelse>NULL</cfif>,
            <cfif isdefined("seri_product_id")>#seri_product_id#<cfelse>NULL</cfif>,
            <cfif isdefined("seri_product_name")>'#seri_product_name#'<cfelse>NULL</cfif>,
            '#attributes.seri_no#',
            '#attributes.main_serial_no#',
            1,
            0,
            <cfif isdefined("attributes.is_new_member")>
                #get_max.max_company#,
                #get_max_partner.max_partner_id#,
            <cfelse>
                #attributes.company_id#,
                #attributes.partner_id#,
            </cfif>
            <cfif len(appcat)>#appcat#,</cfif>
            <cfif isdefined("attributes.is_new_member")>'#attributes.member_name# #attributes.member_surname#',<cfelse>'#attributes.partner_name#'</cfif>
            '#system_paper_no#',
            '#crm_detail#',
            #now()#,
            #now()#,
            #now()#,
            #session.pp.userid#,
            <cfif get_seri_product.recordcount>#createodbcdatetime(get_seri_product.sale_start_date)#,<cfelse>#now()#,</cfif>
            <cfif isdefined("attributes.service_address") and len(attributes.service_address)>'#attributes.service_address#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.bring_name") and len(attributes.bring_name)>'#attributes.bring_name#'<cfelse>NULL</cfif>,
            <cfif isdefined("attributes.bring_tel_no") and len(attributes.bring_tel_no)>'#attributes.bring_tel_no#'<cfelse>NULL</cfif>
        )
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.upd_service&service_id=#max_id.identitycol#" addtoken="No">
