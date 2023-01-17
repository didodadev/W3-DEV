<cfif isDefined('attributes.is_serial_no') and attributes.is_serial_no eq 1>
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
    <cfelse>
        <cfset get_seri_product.recordcount = 0>
    </cfif>
<cfelse>
	<cfset get_seri_product.recordcount = 0>
</cfif>

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
		<cfquery name="ADD_SERVICE" datasource="#dsn3#" result="MAX_ID">
            INSERT INTO
                SERVICE
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
                    SERVICE_CONSUMER_ID,
					<cfif len(attributes.appcat)>
                        SERVICECAT_ID,
                    </cfif>
                    SERVICECAT_SUB_ID,
			        SERVICECAT_SUB_STATUS_ID,
                    APPLICATOR_NAME,
                    APPLICATOR_COMP_NAME,
                    SERVICE_HEAD,
                    SERVICE_DETAIL,
                    APPLY_DATE,
                    START_DATE,
                    RECORD_DATE,
                    RECORD_PAR,
                    RECORD_CONS,
                    GUARANTY_START_DATE,
                    SERVICE_ADDRESS,
                    BRING_NAME,
                    BRING_TEL_NO,
                    ACCESSORY_DETAIL,
                    INSIDE_DETAIL
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
                    <cfif isdefined("attributes.seri_no")>'#attributes.seri_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.seri_no")>'#attributes.main_serial_no#'<cfelse>NULL</cfif>,
                    1,
                    0,
                    <cfif isdefined("session.pp")>
                        #session.pp.company_id#,
                        #session.pp.userid#,
                    <cfelse>
                        NULL,
                        NULL,
                    </cfif>
                    <cfif isdefined("session.ww.userid")>
                        #session.ww.userid#,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif len(attributes.appcat)>
                        #attributes.appcat#,
                    </cfif>
                    #attributes.appcat_sub_id#,
                    #attributes.appcat_sub_status_id#,
                    <cfif isdefined("session.pp")>'#session.pp.name# #session.pp.surname#',<cfelse>'#session.ww.name# #session.ww.surname#',</cfif>
                    <cfif isdefined("session.pp")>'#session.pp.company_nick#',<cfelse>NULL,</cfif>
                    '#system_paper_no#',
                    '#attributes.crm_detail#',
                    #now()#,
                    #now()#,
                    #now()#,
                    <cfif isdefined("session.pp")>#session.pp.userid#,<cfelse>NULL,</cfif>
                    <cfif isdefined("session.ww.userid")>#session.ww.userid#,<cfelse>NULL,</cfif>
                    <cfif get_seri_product.recordcount>#createodbcdatetime(get_seri_product.sale_start_date)#,<cfelse>#now()#,</cfif>
                    <cfif isdefined("attributes.service_address") and len(attributes.service_address)>'#attributes.service_address#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.bring_name") and len(attributes.bring_name)>'#attributes.bring_name#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.bring_tel_no") and len(attributes.bring_tel_no)>'#attributes.bring_tel_no#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.accessory_detail") and len(attributes.accessory_detail)>'#attributes.accessory_detail#'<cfelse>NULL</cfif>,
                    <cfif isdefined("attributes.inside_detail") and len(attributes.inside_detail)>'#attributes.inside_detail#'<cfelse>NULL</cfif>
                )
		</cfquery>
  	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=objects2.upd_service&service_id=#max_id.identitycol#" addtoken="No">
