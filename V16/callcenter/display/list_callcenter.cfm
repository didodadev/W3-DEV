<cf_xml_page_edit fuseact="call.list_callcenter">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.name" default="">
<cfparam name="attributes.member_status" default="1">
<cfparam name="attributes.partner_status" default="1">
<cfparam name="attributes.card_no" default="">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY
</cfquery>
<cfquery name="GET_MEMBER_DIRECT_DENIED" datasource="#DSN#">
	SELECT ISNULL(MEMBER_DIRECT_DENIED,0) AS MEMBER_DIRECT_DENIED FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>

<cfif isdefined("attributes.form_submitted")>
	<cfif session.ep.our_company_info.sales_zone_followup eq 1>
		<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
			SELECT
				DISTINCT
				SZ_HIERARCHY
			FROM
				SALES_ZONES_ALL_1
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
        <cfset row_block = 500>
	</cfif>
<cfquery name="GET_MEMBER" datasource="#DSN#">
    SELECT
        1 TYPE,
        COMPANY_PARTNER.COMPANY_ID,
        COMPANY_PARTNER.PARTNER_ID,
        COMPANY_PARTNER.COMPANY_PARTNER_STATUS,
        COMPANY_PARTNER.COMPANY_PARTNER_NAME,
        COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
        ISNULL(COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,COMPANY.COMPANY_EMAIL) AS EMAIL,
        COMPANY_PARTNER.COMPANY_PARTNER_TELCODE,
        COMPANY_PARTNER.COMPANY_PARTNER_TEL,
		COMPANY_PARTNER.COMPANY_PARTNER_TEL_EXT INTERNAL,
        COMPANY_PARTNER.MOBIL_CODE,
        COMPANY_PARTNER.MOBILTEL,
		(SELECT PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = COMPANY_PARTNER.MISSION) MISSION,
        COMPANY.TAXNO,
        COMPANY.MEMBER_CODE,
		COMPANY_PARTNER.COUNTRY COUNTRY_ID,
        COMPANY_PARTNER.COUNTY,
        COMPANY.COMPANY_STATUS,
        COMPANY.COMPANYCAT_ID MEMBER_CAT,
        COMPANY.FULLNAME,
        COMPANY_PARTNER.CITY CITY_ID,
        (SELECT COUNT(COMPANY_ID) COUNT FROM COMPANY_LAW_REQUEST WHERE COMPANY.COMPANY_ID = COMPANY_LAW_REQUEST.COMPANY_ID AND COMPANY_LAW_REQUEST.REQUEST_STATUS = 1) COMPANY_LAW_REQUEST
    FROM
		COMPANY LEFT JOIN COMPANY_PARTNER ON COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
    WHERE
	1=1
       	<cfif isdefined("attributes.member_status") and len(attributes.member_status)>
			 AND COMPANY.COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.member_status#"> 
		</cfif>
		<cfif isdefined("attributes.partner_status") and len(attributes.partner_status)>
			AND COMPANY_PARTNER.COMPANY_PARTNER_STATUS= <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.partner_status#"> 
        </cfif>
		<cfif isdefined("attributes.name") and len(attributes.name)>AND COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDecode(attributes.name)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
        <cfif isdefined("attributes.surname") and len(attributes.surname)>AND COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDecode(attributes.surname)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
        <cfif is_company eq 1>
            <cfif isdefined("attributes.firm") and len(attributes.firm) gte 3>
            	AND ( COMPANY.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDecode(attributes.firm)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR COMPANY.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDecode(attributes.firm)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
			<cfelseif isdefined("attributes.firm") and len(attributes.firm)>
            	AND ( COMPANY.FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(attributes.firm)#"> COLLATE SQL_Latin1_General_CP1_CI_AI OR COMPANY.NICKNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URLDecode(attributes.firm)#"> COLLATE SQL_Latin1_General_CP1_CI_AI)
			</cfif>
		</cfif>
		<cfif isdefined("attributes.mobiltel") and len(attributes.mobiltel)>
			AND CONCAT(COMPANY_PARTNER.MOBIL_CODE, COMPANY_PARTNER.MOBILTEL) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#RIGHT(attributes.mobiltel,10)#%">
			OR CONCAT(COMPANY.MOBIL_CODE, COMPANY.MOBILTEL) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#RIGHT(attributes.mobiltel,10)#%">
		</cfif>
		<cfif isdefined("attributes.TEL") and len(attributes.tel)>
			AND CONCAT(COMPANY_PARTNER.COMPANY_PARTNER_TELCODE, COMPANY_PARTNER.COMPANY_PARTNER_TEL) = '#attributes.tel#'
			OR CONCAT(COMPANY.COMPANY_TELCODE,COMPANY.COMPANY_TEL1)  LIKE '%#attributes.tel#%' 
			OR CONCAT(COMPANY.COMPANY_TELCODE,COMPANY.COMPANY_TEL2)  LIKE '%#attributes.tel#%' 
			OR CONCAT(COMPANY.COMPANY_TELCODE,COMPANY.COMPANY_TEL3)  LIKE '%#attributes.tel#%'
		</cfif>	
        
		<cfif isDefined("attributes.card_no") and Len(attributes.card_no)>
			AND COMPANY_PARTNER.PARTNER_ID IN (SELECT ACTION_ID FROM CUSTOMER_CARDS WHERE ACTION_TYPE_ID = 'PARTNER_ID' AND CARD_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_no#">)
		</cfif>
        <cfif isdefined("attributes.email") and len(attributes.email)>AND(COMPANY_PARTNER.COMPANY_PARTNER_EMAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDecode(attributes.email)#%"> OR COMPANY.COMPANY_EMAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#URLDecode(attributes.email)#%">)</cfif>
        <cfif isdefined("attributes.tc_identity") and len(attributes.tc_identity)>AND COMPANY_PARTNER.TC_IDENTITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tc_identity#"></cfif>
        <cfif isdefined("attributes.fax") and len(attributes.fax)>AND (COMPANY_PARTNER.COMPANY_PARTNER_FAX = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fax#"> OR COMPANY.COMPANY_FAX = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fax#">)</cfif>
        <cfif isdefined("attributes.city_id") and len(attributes.city_id)>AND COMPANY.CITY = #attributes.city_id#</cfif>
        <cfif isdefined("attributes.county_id") and len(attributes.county_id)>AND COMPANY.COUNTY = #attributes.county_id#</cfif>
        <cfif isdefined("attributes.semt") and len(attributes.semt)>AND (COMPANY.SEMT = '#UrlDecode(attributes.semt)#' OR COMPANY_PARTNER.SEMT = '#UrlDecode(attributes.semt)#')</cfif>
        <cfif isdefined("attributes.post_code") and len(attributes.post_code)>AND (COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE = '#attributes.post_code#' OR COMPANY.COMPANY_POSTCODE = '#attributes.post_code#')</cfif>
        <cfif isdefined("attributes.address") and len(attributes.address)>AND (COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS LIKE '%#UrlDecode(attributes.address)#%' OR COMPANY.COMPANY_ADDRESS LIKE '%#UrlDecode(attributes.address)#%')</cfif>
        <cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>AND COMPANY.TAXNO = '#attributes.tax_no#'</cfif>
        <cfif isdefined("attributes.uye_no") and len(attributes.uye_no)>AND COMPANY.MEMBER_CODE = '#attributes.uye_no#'</cfif>
        <cfif isdefined("attributes.ozel_kod") and len(attributes.ozel_kod)>AND COMPANY.OZEL_KOD = '#URLDecode(attributes.ozel_kod)#'</cfif><!--- '#attributes.ozel_kod#' --->
        <!--- Satış Bölge Kontrolü İçin Gerekli Kurumsal Müşteriler İçin Created By MCP 16092013--->
        <cfif session.ep.our_company_info.sales_zone_followup eq 1>
        	 <!---Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			AND 
			(
				COMPANY.IMS_CODE_ID IN (
											SELECT 
												DISTINCT IMS_ID
											FROM
												SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
												AND (COMPANY_CAT_IDS IS NULL OR (COMPANY_CAT_IDS IS NOT NULL AND ','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(COMPANY.COMPANYCAT_ID AS NVARCHAR)+',%'))
										)
        <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
		  	<cfif get_hierarchies.recordcount>
			OR COMPANY.IMS_CODE_ID IN (
											SELECT
												DISTINCT IMS_ID
											FROM
												SALES_ZONES_ALL_1
											WHERE											
												<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
													<cfset start_row=(page_stock*row_block)+1>	
													<cfset end_row=start_row+(row_block-1)>
													<cfif (end_row) gte get_hierarchies.recordcount>
														<cfset end_row=get_hierarchies.recordcount>
													</cfif>
														(
														<cfloop index="add_stock" from="#start_row#" to="#end_row#">
															<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
														</cfloop>													
														)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)                                
                                        
               </cfif>                         
            )
        </cfif>

        <!---16092013 --->
        
		AND COMPANY.COMPANYCAT_ID IN ( SELECT DISTINCT	COMPANYCAT_ID COMPANYCAT FROM GET_MY_COMPANYCAT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
UNION ALL
  	SELECT
        2 TYPE,
        CONSUMER_ID,
        0 AS PARTNER_ID,
        CONSUMER_STATUS COMPANY_PARTNER_STATUS,
        CONSUMER_NAME,
        CONSUMER_SURNAME,
        CONSUMER_EMAIL EMAIL,
        CONSUMER_HOMETELCODE,
        CONSUMER_HOMETEL,
		'' INTERNAL,
        MOBIL_CODE,
        MOBILTEL, 
		(SELECT PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = CONSUMER.MISSION) MISSION,
        TAX_NO,
        MEMBER_CODE,
        HOME_COUNTRY_ID COUNTRY_ID,
        HOME_COUNTY_ID,
        CONSUMER_STATUS,
        CONSUMER_CAT_ID MEMBER_CAT,
        COMPANY,
        HOME_CITY_ID CITY_ID,
        (SELECT COUNT(CONSUMER_ID) COUNT FROM COMPANY_LAW_REQUEST WHERE CONSUMER.CONSUMER_ID = COMPANY_LAW_REQUEST.CONSUMER_ID AND COMPANY_LAW_REQUEST.REQUEST_STATUS = 1) COMPANY_LAW_REQUEST
    FROM
        CONSUMER
    WHERE
    	1=1
   		<cfif isdefined("attributes.member_status") and len(attributes.member_status)>
			 AND CONSUMER_STATUS = #attributes.member_status#
        </cfif>
		<cfif isdefined("attributes.name") and len(attributes.name)>AND CONSUMER_NAME LIKE '%#URLDecode(attributes.name)#%'</cfif>
        <cfif isdefined("attributes.surname") and len(attributes.surname)>AND CONSUMER_SURNAME LIKE '%#URLDecode(attributes.surname)#%'</cfif>
        <cfif is_company eq 1>
			<cfif isdefined("attributes.firm") and len(attributes.firm) gte 3>
				AND COMPANY LIKE '#attributes.firm#%'
            <cfelseif isdefined("attributes.firm") and Len(attributes.firm)>
            	AND COMPANY = '#attributes.firm#'
            </cfif>
        </cfif>
		<cfif isDefined("attributes.card_no") and Len(attributes.card_no)>
			AND CONSUMER_ID IN (SELECT ACTION_ID FROM CUSTOMER_CARDS WHERE ACTION_TYPE_ID = 'CONSUMER_ID' AND CARD_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.card_no#">)
		</cfif>
		<cfif isdefined("attributes.tel") and len(attributes.tel)>
			AND CONCAT(CONSUMER_HOMETEL,CONSUMER_HOMETEL)  LIKE '%#attributes.tel#%'
		</cfif>
		<cfif isdefined("attributes.mobiltel") and len(attributes.mobiltel)>
			AND CONCAT(MOBIL_CODE,MOBILTEL)  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#RIGHT(attributes.mobiltel,10)#%">
		</cfif>		
        <cfif isdefined("attributes.email") and len(attributes.email)>AND CONSUMER_EMAIL LIKE '%#URLDecode(attributes.email)#%'</cfif>
        <cfif isdefined("attributes.fax") and len(attributes.fax)>AND CONSUMER_FAX = '#attributes.fax#'</cfif>
        <cfif isdefined("attributes.city_id") and len(attributes.city_id)>AND (HOME_CITY_ID = #attributes.city_id# OR WORK_CITY_ID = #attributes.city_id#)</cfif>
        <cfif isdefined("attributes.county_id") and len(attributes.county_id)>AND (HOME_COUNTY_ID = #attributes.county_id# OR WORK_COUNTY_ID = #attributes.county_id#)</cfif>
        <cfif isdefined("attributes.tc_identity") and len(attributes.tc_identity)>AND TC_IDENTY_NO = '#attributes.tc_identity#'</cfif>
        <cfif isdefined("attributes.semt") and len(attributes.semt)>AND (HOMESEMT = '#UrlDecode(attributes.semt)#' OR WORKSEMT = '#UrlDecode(attributes.semt)#' OR TAX_SEMT = '#UrlDecode(attributes.semt)#')</cfif>
        <cfif isdefined("attributes.post_code") and len(attributes.post_code)>AND (HOMEPOSTCODE = '#attributes.post_code#' OR WORKPOSTCODE = '#attributes.post_code#')</cfif>
        <cfif isdefined("attributes.address") and len(attributes.address)>AND (HOMEADDRESS LIKE '#UrlDecode(attributes.address)#%' OR WORKADDRESS LIKE '#UrlDecode(attributes.address)#%')</cfif>
        <cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>AND TAX_NO = '#attributes.tax_no#'</cfif>
        <cfif isdefined("attributes.uye_no") and len(attributes.uye_no)>AND MEMBER_CODE = '#attributes.uye_no#'</cfif>
        <cfif isdefined("attributes.ozel_kod") and len(attributes.ozel_kod)>AND OZEL_KOD = '#URLDecode(attributes.ozel_kod)#'</cfif><!--- '#attributes.ozel_kod#' --->
		  <!--- Satış Bölge Kontrolü İçin Gerekli Bireysel Müşteriler İçin Created By MCP 16092013--->
 		<cfif session.ep.our_company_info.sales_zone_followup eq 1>
			<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
			AND 
			(
				CONSUMER.IMS_CODE_ID IN (
											SELECT 
												DISTINCT IMS_ID
											FROM
												SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
												AND (CONSUMER_CAT_IDS IS NULL OR (CONSUMER_CAT_IDS IS NOT NULL AND ','+CONSUMER_CAT_IDS+',' LIKE '%,'+CAST(CONSUMER.CONSUMER_CAT_ID AS NVARCHAR)+',%'))
										)
			<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
	 	  	<cfif get_hierarchies.recordcount>
			OR CONSUMER.IMS_CODE_ID IN (
											SELECT
												DISTINCT IMS_ID
											FROM
												SALES_ZONES_ALL_1
											WHERE											
												<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
													<cfset start_row=(page_stock*row_block)+1>	
													<cfset end_row=start_row+(row_block-1)>
													<cfif (end_row) gte get_hierarchies.recordcount>
														<cfset end_row=get_hierarchies.recordcount>
													</cfif>
														(
														<cfloop index="add_stock" from="#start_row#" to="#end_row#">
															<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
														</cfloop>													
														)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)
			  </cfif>						
			)
		</cfif>
        <!--- 16/09/2013--->
        AND CONSUMER.CONSUMER_CAT_ID IN ( SELECT DISTINCT CONSCAT_ID COMPANYCAT FROM GET_MY_CONSUMERCAT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
 
    ORDER BY
		COMPANY_PARTNER_NAME,
		FULLNAME
</cfquery>

<cfelse>

	<cfset get_member.recordcount = 0>

</cfif>

<cfparam name="attributes.totalrecords" default='#get_member.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent  variable="pageHead">
	<cfif isdefined('attributes.webphone')><cf_get_lang dictionary_id='61834.Kontaklar'><cfelse><cf_get_lang dictionary_id='49273.Search Member'></cfif>
</cfsavecontent>
<div class="<cfif not isdefined('attributes.webphone')>col col-12 col-md-12 col-sm-12 col-xs-12</cfif>">
	<div <cfif isdefined('attributes.webphone')>style="display:none"</cfif>>
	<cf_box>
		<cfform name="get_part" id="get_part" method="post" action="#request.self#?fuseaction=call.list_callcenter">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
					<cfif is_company eq 1>
						<div class="form-group" id="item-firm">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="firm" id="firm" value="<cfif isdefined("attributes.firm")><cfoutput>#attributes.firm#</cfoutput></cfif>" maxlength="50" style="width:180px;" />
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="name"  id="name" value="<cfif isdefined("attributes.name")><cfoutput>#attributes.name#</cfoutput></cfif>" style="width:87px;">
									<span class="input-group-addon no-bg"></span>
									<input type="text" name="surname" id="surname" value="<cfif isdefined("attributes.surname")><cfoutput>#attributes.surname#</cfoutput></cfif>" style="width:87px;">
								</div>
							</div>
						</div>
					</cfif>
					<cfif is_company eq 1>
						<div class="form-group" id="item-namesurname">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="name" id="name" maxlength="150" value="<cfif isdefined("attributes.name")><cfoutput>#attributes.name#</cfoutput></cfif>" style="width:87px;">
									<span class="input-group-addon no-bg"></span>
									<input type="text" name="surname" id="surname" maxlength="250" value="<cfif isdefined("attributes.surname")><cfoutput>#attributes.surname#</cfoutput></cfif>" style="width:87px;">
								</div>
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-uye_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri no'> / <cf_get_lang dictionary_id='57789.Özel Kod'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
								<input type="text" name="uye_no" id="uye_no"  value="<cfif isdefined("attributes.uye_no")><cfoutput>#attributes.uye_no#</cfoutput></cfif>" style="width:87px;">
								<span class="input-group-addon no-bg"></span>
								<input type="text" name="ozel_kod" id="ozel_kod" value="<cfif isdefined("attributes.ozel_kod")><cfoutput>#attributes.ozel_kod#</cfoutput></cfif>" style="width:87px;">
								</div>
							</div>
						</div>
					</cfif>
					<cfif is_company eq 1>
						<div class="form-group" id="item-ozel_kod">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59341.Müşteri no '> / <cf_get_lang dictionary_id='57789.Özel Kod'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="uye_no" id="uye_no" maxlength="75" value="<cfif isdefined("attributes.uye_no")><cfoutput>#attributes.uye_no#</cfoutput></cfif>" style="width:87px;">
									<span class="input-group-addon no-bg"></span>
									<input type="text" name="ozel_kod" id="ozel_kod" maxlength="75" value="<cfif isdefined("attributes.ozel_kod")><cfoutput>#attributes.ozel_kod#</cfoutput></cfif>" style="width:87px;">
								</div>
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-ozel_kod">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.tc kimlik no'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="tc_identity"  id="tc_identity" value="<cfif isdefined("attributes.tc_identity")><cfoutput>#attributes.tc_identity#</cfoutput></cfif>" style="width:180px;">
							</div>
						</div>
					</cfif>
					<cfif is_company eq 1>
						<div class="form-group" id="item-tckno">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58025.tc kimlik no'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="tc_identity" id="tc_identity" maxlength="11" value="<cfif isdefined("attributes.tc_identity")><cfoutput>#attributes.tc_identity#</cfoutput></cfif>" style="width:180px;">
							</div>
						</div>
					<cfelse>
						<div class="form-group" id="item-tax_no">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="tax_no" id="tax_no"  value="<cfif isdefined("attributes.tax_no")><cfoutput>#attributes.tax_no#</cfoutput></cfif>" style="width:180px;">
							</div>
						</div>
					</cfif>
					<cfif is_company eq 1>
						<div class="form-group" id="item-tax_no2">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" maxlength="50" name="tax_no" id="tax_no" value="<cfif isdefined("attributes.tax_no")><cfoutput>#attributes.tax_no#</cfoutput></cfif>" style="width:180px;">
							</div>
						</div>
					</cfif>
					<cfif xml_customer_card_filter eq 1>
						<div class="form-group" id="item-tax_no2">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51661.Kart No'></label>
							<div class="col col-8 col-xs-12">
								<cfinput type="text" name="card_no" id="card_no" value="#attributes.card_no#" onKeyUp="isNumber(this);" maxlength="16" style="width:180px;">
								</div>
						</div>
					</cfif>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-tel">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49272.Tel'></label>
						<div class="col col-9 col-xs-12">
								<!--- <input type="text" name="telcode" id="telcode" onkeyup="isNumber(this)" value="<cfif isdefined("attributes.telcode")><cfoutput>#attributes.telcode#</cfoutput></cfif>" maxlength="4" style="width:50px;">
								<span class="input-group-addon no-bg"></span> --->
								<input type="text" name="tel" id="tel" onkeyup="isNumber(this)" value="<cfif isdefined("attributes.tel")><cfoutput>#attributes.tel#</cfoutput></cfif>" maxlength="12" style="width:80px;">
						</div>
					</div>
					<div class="form-group" id="item-mobil">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58473.mobil'></label>
						<div class="col col-9 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='29983.Mobil Kod'></cfsavecontent>
									<cfsavecontent variable="text"><cf_get_lang dictionary_id='58585.Kod/Mobil Tel'></cfsavecontent>
								<!--- <cfinput type="text" name="mobilcat_id" id="mobilcat_id" maxlength="10" validate="integer" onKeyUp="isNumber(this)" message="#message#" style="width:47px;" value="">
								<span class="input-group-addon no-bg"></span>--->
							
								<cfif isdefined("attributes.mobiltel")>
									<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20" validate="integer" onKeyUp="isNumber(this)" message="#text#" style="width:80px;" value="#attributes.mobiltel#">
								<cfelse>
									<cfinput type="text" name="mobiltel" id="mobiltel" maxlength="20" validate="integer" onKeyUp="isNumber(this)" message="#text#" style="width:80px;" value="">
								</cfif> 
								
								
						</div>
					</div>
					<div class="form-group" id="item-fax">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
						<div class="col col-9 col-xs-12">
							<div class="input-group">
								<input type="text" name="faxcode" id="faxcode" maxlength="4" value="<cfif isdefined("attributes.faxcode")><cfoutput>#attributes.faxcode#</cfoutput></cfif>" style="width:50px;">
								<span class="input-group-addon no-bg"></span>
								<input type="text" name="fax" id="fax" maxlength="10" value="<cfif isdefined("attributes.fax")><cfoutput>#attributes.fax#</cfoutput></cfif>" style="width:80px;">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-email">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57428.E-Mail'></label>
						<div class="col col-9 col-xs-12">
							<input type="text" name="email" id="email" maxlength="100" value="<cfif isdefined("attributes.email")><cfoutput>#attributes.email#</cfoutput></cfif>" style="width:134px;">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
					<div class="form-group" id="item-city_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'>/<cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-4 col-xs-12">
							<select name="city_id" id="city_id" style="width:138px;" onchange="LoadCounty(this.value,'county_id')">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_city">
									<option value="#city_id#" <cfif isdefined("attributes.city_id") and attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
								</cfoutput>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<select name="county_id" id="county_id" style="width:138px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
									<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
										SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#">
									</cfquery>
									<cfoutput query="get_county_name">
										<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-semt">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'>/<cf_get_lang dictionary_id='57472.Posta Kod'></label>
						<div class="col col-4 col-xs-12">
							<input type="text" name="semt" id="semt" value="<cfif isdefined("attributes.semt")><cfoutput>#attributes.semt#</cfoutput></cfif>" style="width:138px;">
						</div>
						<div class="col col-4 col-xs-12">
							<input type="text" name="post_code" id="post_code" onkeyup="isNumber(this);" value="<cfif isdefined("attributes.post_code")><cfoutput>#attributes.post_code#</cfoutput></cfif>" style="width:138px;">
						</div>
					</div>
					<div class="form-group" id="item-address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="address" id="address" style="height:50px;width:278px;"><cfif isdefined("attributes.address")><cfoutput>#attributes.address#</cfoutput></cfif></textarea>
						</div>
					</div>
					<div class="form-group" id="item-member_status">
						<label class="col col-4 col-xs-12">&nbsp;</label>
						<div class="col col-3 col-xs-12">
							<select name="member_status" id="member_status">
								<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
								<option value="1" <cfif attributes.member_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
								<option value="0" <cfif attributes.member_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
							</select>
						</div>
						<div class="col col-3 col-xs-12">
							<select name="partner_status" id="partner_status">
								<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
								<option value="1" <cfif attributes.partner_status eq 1>selected</cfif>><cf_get_lang dictionary_id='49222.Aktif Kurumsal Çalışanlar'></option>
								<option value="0" <cfif attributes.partner_status eq 0>selected</cfif>><cf_get_lang dictionary_id='49221.Pasif Çalışanlar'></option>
							</select>
						</div>
						<div class="col col-2 col-xs-12">
							<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" maxlength="3" style="width:25px;">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_wrk_search_button button_type="5" search_function='control()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
	</div>
	<cf_box title="#pageHead#" uidrop="#iif(isdefined('attributes.webphone'),DE(''),1)#" hide_table_column="#iif(isdefined('attributes.webphone'),DE(''),1)#">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57558.Üye No'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id='58607.Firma'></th>
					<th><cf_get_lang dictionary_id='58609.Üye Kategorisi'></th>
					<th><cf_get_lang dictionary_id='57971.Şehir'></th>
					<th><cf_get_lang dictionary_id='49271.Cep Tel'></th>
					<th><cf_get_lang dictionary_id='49272.Tel'></th>
					<th><cf_get_lang dictionary_id='49272.Tel'>2</th>
					<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
					<th><cf_get_lang dictionary_id='57428.E-Mail'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
				</tr>
			</thead>
			<tbody>
						<cfif get_member.recordcount>
							<cfset consumer_cat_list=''>
							<cfset company_cat_list=''>
							<cfset city_list=''>
							<cfset country_list = ''>
							<cfoutput query="get_member">
								<cfif type eq 2>
									<cfif not listfind(consumer_cat_list,member_cat)>
										<cfset consumer_cat_list=listappend(consumer_cat_list,member_cat)>
									</cfif>
								</cfif>
								<cfif type eq 1>
									<cfif not listfind(company_cat_list,member_cat)>
										<cfset company_cat_list=listappend(company_cat_list,member_cat)>
									</cfif>
								</cfif>
								<cfif len(city_id) and not listfind(city_list,city_id)>
									<cfset city_list=listappend(city_list,city_id)>
								</cfif>
								<cfif len(country_id) and not listfind(country_list,country_id)>
									<cfset country_list=listappend(country_list,country_id)>
								</cfif>
							</cfoutput>
							<cfset consumer_cat_list=listsort(consumer_cat_list,"numeric")>
							<cfset company_cat_list=listsort(company_cat_list,"numeric")>
							<cfif len(consumer_cat_list)>
								<cfset consumer_cat_list=listsort(consumer_cat_list,"numeric","ASC",",")>
								<cfquery name="GET_CONSCAT" datasource="#DSN#">
									SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT WHERE CONSCAT_ID IN (#consumer_cat_list#) ORDER BY CONSCAT_ID
								</cfquery>
								<cfset consumer_cat_list = listsort(listdeleteduplicates(valuelist(get_conscat.conscat_id,',')),'numeric','ASC',',')>
							</cfif>
							<cfif len(company_cat_list)>
								<cfset company_cat_list=listsort(company_cat_list,"numeric","ASC",",")>
								<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
									SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#company_cat_list#) ORDER BY COMPANYCAT_ID
								</cfquery>
								<cfset company_cat_list = listsort(listdeleteduplicates(valuelist(get_companycat.companycat_id,',')),'numeric','ASC',',')>
							</cfif>
							<cfif len(city_list)>
								<cfset city_list=listsort(city_list,"numeric","ASC",",")>
								<cfquery name="GET_CITY_MAIN" datasource="#DSN#">
									SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
								</cfquery>
								<cfset city_list = listsort(listdeleteduplicates(valuelist(get_city_main.city_id,',')),'numeric','ASC',',')>
							</cfif>
							<cfif Len(country_list)>
								<cfset country_list = listsort(country_list,"numeric","ASC",",")>
								<cfquery name="GET_COUNTRY_MAIN" datasource="#DSN#">
									SELECT COUNTRY_ID,COUNTRY_PHONE_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
								</cfquery>
								<cfset country_list = listsort(listdeleteduplicates(valuelist(get_country_main.country_id,',')),'numeric','ASC',',')>
							</cfif>
						<cfoutput query="get_member" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>#member_code#</td>
								<td>
									<cfif type eq 1>
										<a href="#request.self#?fuseaction=call.list_callcenter&event=det&cpid=#company_id#&partner_id=#partner_id#" target="_blank">#company_partner_name# #company_partner_surname#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=call.list_callcenter&event=det&cid=#company_id#"class="tableyazi">#company_partner_name# #company_partner_surname#</a>
									</cfif>
									<cfif COMPANY_LAW_REQUEST gt 0><font color="FF0000"><b>( <cf_get_lang dictionary_id='49319.Icraliktir'> )</b></font></cfif>
								</td>
								<td>
									#mission#
								</td>
								<td>#fullname#</td>
								<td><cfif type eq 1 and len(get_member.member_cat)>#get_companycat.companycat[listfind(company_cat_list,member_cat,',')]#<cfelseif type eq 2 and len(get_member.member_cat)>#get_conscat.conscat[listfind(consumer_cat_list,member_cat,',')]#</cfif></td>
								<td><cfif len(get_member.city_id)>#get_city_main.city_name[listfind(city_list,city_id,',')]#</cfif></td>
								<cf_santral tel="#company_partner_telcode##company_partner_tel#" mobil="#mobil_code##mobiltel#" table="1"  is_iframe="#iif(isdefined('attributes.webphone'),1,0)#"></cf_santral>
								<!--- <td><cfif len(country_id) and len(get_country_main.country_phone_code[listfind(country_list,country_id,',')])>(#get_country_main.country_phone_code[listfind(country_list,country_id,',')]#) </cfif><a href="tel://#company_partner_telcode##company_partner_tel#">#company_partner_telcode# #company_partner_tel# </a><cfif len(internal)> (#internal#)</cfif></td>
								<td><cfif len(country_id) and len(get_country_main.country_phone_code[listfind(country_list,country_id,',')])>(#get_country_main.country_phone_code[listfind(country_list,country_id,',')]#) </cfif><a href="tel://#mobil_code# #mobiltel#">#mobil_code# #mobiltel#</a></td>--->
								<td>#taxno#</td> 
								<td><cfif len(email)><a href="mailto:#email#">#email#</a></cfif></td>
								<td><cfif company_partner_status eq 1>
										<cf_get_lang dictionary_id='57493.Aktif'>
									<cfelseif company_partner_status eq 0>
										<font color="FFF0000"><cf_get_lang dictionary_id='57494.Pasif'></font>
									</cfif>
								</td>
							</tr>
						</cfoutput>
				</tbody>
				<cfelse>	
					<tbody>
						<tr>
								<td colspan="13" class="txtbold"> &nbsp;<cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='49296.Arama Sonucu'> : <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '>!</cfif></td>
						</tr>
					</tbody>
					<cfif isdefined("attributes.form_submitted")>
						<tfoot>
							<tr class="margin-right-10">
								<td class="text-right" colspan="13">
									<cfsavecontent variable="title_bireysel"><cf_get_lang dictionary_id='49262.Bireysel Üye Olarak Kaydet'></cfsavecontent>
									<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#title_bireysel#" extraFunction='bireysel()' extraButtonClass="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left">
									<cfsavecontent variable="title_kurumsal"><cf_get_lang dictionary_id='49261.Kurumsal Üye Olarak Kaydet'></cfsavecontent>
									<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#title_kurumsal#" extraFunction='kurumsal()' >
								</td>
							</tr>
						</tfoot>
					</cfif>
				</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "form_submitted=1">
			<cfif isdefined("attributes.firm") and Len(attributes.firm)><cfset url_str = "#url_str#&firm=#attributes.firm#"></cfif>
			<cfif isdefined("attributes.name") and Len(attributes.name)><cfset url_str = "#url_str#&name=#attributes.name#"></cfif>
			<cfif isdefined("attributes.surname") and Len(attributes.surname)><cfset url_str = "#url_str#&surname=#attributes.surname#"></cfif>
			<cfif isdefined("attributes.uye_no") and Len(attributes.uye_no)><cfset url_str = "#url_str#&uye_no=#attributes.uye_no#"></cfif>
			<cfif isdefined("attributes.ozel_kod") and Len(attributes.ozel_kod)><cfset url_str = "#url_str#&ozel_kod=#attributes.ozel_kod#"></cfif>
			<cfif isdefined("attributes.tc_identity") and Len(attributes.tc_identity)><cfset url_str = "#url_str#&tc_identity=#attributes.tc_identity#"></cfif>
			<cfif isdefined("attributes.tax_no") and Len(attributes.tax_no)><cfset url_str = "#url_str#&tax_no=#attributes.tax_no#"></cfif>
			<cfif isdefined("attributes.card_no") and Len(attributes.card_no)><cfset url_str = "#url_str#&card_no=#attributes.card_no#"></cfif>
			<cfif isdefined("attributes.tel") and Len(attributes.tel)><cfset url_str = "#url_str#&tel=#attributes.tel#"></cfif>
			<cfif isdefined("attributes.mobiltel") and Len(attributes.mobiltel)><cfset url_str = "#url_str#&mobiltel=#attributes.mobiltel#"></cfif>
			<cfif isdefined("attributes.fax") and Len(attributes.fax)><cfset url_str = "#url_str#&fax=#attributes.fax#"></cfif>
			<cfif isdefined("attributes.email") and Len(attributes.email)><cfset url_str = "#url_str#&email=#attributes.email#"></cfif>
			<cfif isdefined("attributes.city_id") and Len(attributes.city_id)><cfset url_str = "#url_str#&city_id=#attributes.city_id#"></cfif>
			<cfif isdefined("attributes.county_id")><cfset url_str = "#url_str#&county_id=#attributes.county_id#"></cfif>
			<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="call.list_callcenter&#url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
$( document ).ready(function() {
	$("#workcube_button").css("margin-left","5px");
});

	<cfif isDefined("form_submitted") and isdefined("is_report")>
		nextPreviousPage(1);//Ozel rapordan linke tıklandığında listelenmesi için eklendi. kaldirmayin hgul.20120424
	</cfif>
	var _city_= document.getElementById("city_id").value;
	<cfif isdefined('attributes.county_id') and not len(attributes.county_id)>
		if(_city_.length)
			LoadCounty(_city_,'county_id')
	</cfif>
	<cfif isdefined("is_company")>
		var is_company = '<cfoutput>#is_company#</cfoutput>';
	<cfelse>
		var is_company = 0;
	</cfif>
	function bireysel()
	{
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=member.consumer_list&event=add&consumer_name=' + document.getElementById("name").value + '&consumer_surname=' + document.getElementById("surname").value + '&home_tel=' + document.getElementById("tel").value + '&mobiltel=' + document.getElementById("mobiltel").value + '&work_faxcode=' + document.getElementById("faxcode").value + '&work_fax=' + document.getElementById("fax").value + '&consumer_email=' + document.getElementById("email").value + '&tax_no=' + document.getElementById("tax_no").value + '&home_city=' + document.getElementById("city_id").value + '&home_county=' + document.getElementById("county_id").value + '&home_city_id=' + document.getElementById("city_id").value + '&home_county_id=' + document.getElementById("county_id").value + '&home_semt=' + document.getElementById("semt").value + '&home_postcode=' + document.getElementById("post_code").value + '&home_address=' + document.getElementById("address").value + '&consumer_code=' + document.getElementById("uye_no").value+ '&ozel_kod=' + document.getElementById("ozel_kod").value+'&tc_identy_no=' + document.getElementById("tc_identity").value+'&city_id=' + document.getElementById("city_id").value+'&county_id=' + document.getElementById("county_id").value;
	}

	function kurumsal()
	{
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=member.form_list_company&event=add&name=' + document.getElementById("name").value + '&soyad=' + document.getElementById("surname").value + '&tel1=' + document.getElementById("tel").value + '&mobiltel=' + document.getElementById("mobiltel").value + '&fax=' + document.getElementById("fax").value + '&email=' + document.getElementById("email").value + '&vno=' + document.getElementById("tax_no").value +'&semt=' + document.getElementById("semt").value + '&postcod=' + document.getElementById("post_code").value + '&adres=' + document.getElementById("address").value + '&fullname=' + document.getElementById("firm").value + '&nickname=' + document.getElementById("firm").value+ '&company_code=' + document.getElementById("uye_no").value+ '&city_id=' + document.getElementById("city_id").value+'&county_id=' + document.getElementById("county_id").value+'&ozel_kod=' + document.getElementById("ozel_kod").value;
	}

	function control()
	{
		if(document.getElementById("maxrows").value == '')
		{
			alertObject({message:"<cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'>"})
			return false;
		}

		<cfif isdefined("xml_customer_card_filter") and xml_customer_card_filter eq 1>
			var card_no_ = document.getElementById("card_no").value;
		<cfelse>
			var card_no_ = 0;
		</cfif>

		if(is_company == 1) 
		{
			if(document.getElementById("firm").value == "" && document.getElementById("email").value == "" && document.getElementById("name").value == "" && document.getElementById("surname").value == "" && document.getElementById("tel").value == ""  && document.getElementById("tc_identity").value == ""  && document.getElementById("post_code").value == "" && document.getElementById("city_id").value == "" && document.getElementById("county_id").value == "" && document.getElementById("mobiltel").value == "" && document.getElementById("semt").value == "" && document.getElementById("uye_no").value == "" && document.getElementById("ozel_kod").value == "" && document.getElementById("address").value == "" && document.getElementById("tax_no").value == ""  && document.getElementById("fax").value == "" && card_no_ == "")
			{
				alertObject({message: "<cf_get_lang dictionary_id='57526.En Az Bir Alanda Filtre Ediniz'>" })
				return false;
			}
		}
		else
		{
			if(document.getElementById("name").value == "" && document.getElementById("email").value == "" && document.getElementById("surname").value == "" && document.getElementById("tel").value == ""  && document.getElementById("tc_identity").value == ""  && document.getElementById("post_code").value == "" && document.getElementById("city_id").value == "" && document.getElementById("county_id").value == "" && document.getElementById("mobiltel").value == "" && document.getElementById("semt").value == "" && document.getElementById("uye_no").value == "" && document.getElementById("ozel_kod").value == "" && document.getElementById("address").value == "" && document.getElementById("tax_no").value == ""  && document.getElementById("fax").value == "" && card_no_ == "")
			{
				alertObject({message: "<cf_get_lang dictionary_id='57526.En Az Bir Alanda Filtre Ediniz'>"})
				return false;
			}
		} 

		var numberformat = "1234567890";
		for (var i = 1; i < document.getElementById("tel").value.length; i++)
		{
			check_tel_code_number = numberformat.indexOf(document.getElementById("tel").value.charAt(i));
			if (check_tel_code_number < 0)
			{
				alertObject({message: "<cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.Tam Sayı'> <cf_get_lang dictionary_id='49243.Tel No'> !"})
				document.getElementById("tel").focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById("mobiltel").value.length; i++)
		{
			check_mobiltel = numberformat.indexOf(document.getElementById("mobiltel").value.charAt(i));
			if (check_mobiltel < 0)
			{
				alertObject({message: "<cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.Tam Sayı'> <cf_get_lang dictionary_id='49243.Tel No'> !"})
				document.getElementById("mobiltel").focus();
				return false;
			}
		}

		for (var i = 1; i < document.getElementById("fax").value.length; i++)
		{
			check_fax = numberformat.indexOf(document.getElementById("fax").value.charAt(i));
			if (check_fax < 0)
			{
				alertObject({message: "<cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.Tam Sayı'> <cf_get_lang dictionary_id='49243.Tel No'> !"})
				document.getElementById("fax").focus();
				return false;
			}
		}
		for (var i = 1; i < document.getElementById("tc_identity").value.length; i++)
		{
			check_tc_identity = numberformat.indexOf(document.getElementById("tc_identity").value.charAt(i));
			if (check_tc_identity < 0)
			{
				alertObject({message: "<cf_get_lang dictionary_id ='58746.Üye No Sayısal Olmalıdır'> !" })
				document.getElementById("tc_identity").focus();
				return false;
			}
		}

		for (var i = 1; i < document.getElementById("tax_no").value.length; i++)
		{
			check_tax_no = numberformat.indexOf(document.getElementById("tax_no").value.charAt(i));
			if (check_tax_no < 0)
			{
				alertObject({message: "<cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.Tam Sayı'> <cf_get_lang dictionary_id='57752.vergi No'> !" })
				document.getElementById("tax_no").focus();
				return false;
			}
		}
		/* if(document.getElementById("telcode").value != "")
		{
			for (var i = 1; i < document.getElementById("telcode").value.length; i++)
			{
				check_telcode = numberformat.indexOf(document.getElementById("telcode").value.charAt(i));
				if (check_telcode < 0)
				{
					alertObject({message: "<cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.Tam Sayı'> <cf_get_lang dictionary_id='49243.Tel No'> !" })
					document.getElementById("telcode").focus();
					return false;
				}
			}
		} */

		for (var i = 1; i < document.getElementById("post_code").value.length; i++)
		{
			check_post_code = numberformat.indexOf(document.getElementById("post_code").value.charAt(i));
			if (check_post_code < 0)
			{
				alertObject({message: "<cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.Tam Sayı'> <cf_get_lang dictionary_id='57472.posta kodu'> !" })
				document.getElementById("post_code").focus();
				return false;
			}
		}


		//pozisyon detayındaki yetki kısmı...
		<cfif get_member_direct_denied.member_direct_denied eq 1>
			var confirm_count = 0;
			if(document.getElementById('tc_identity').value != "") confirm_count++;
			if(document.getElementById('uye_no').value != "") confirm_count++;
			if(document.getElementById('mobiltel').value != "") confirm_count++;
			if(document.getElementById('tel').value != "") confirm_count++;
			if(confirm_count<2){
				alertObject({message: '<cf_get_lang dictionary_id="58025.tc kimlik no">,<cf_get_lang dictionary_id="57558.Üye No">,<cf_get_lang dictionary_id="49272.Tel"><cf_get_lang dictionary_id="49271.Cep Tel"> En Az 2 Tanesinin Dolu Olması Gereklidir!' })
				return false;
			}
		</cfif>

		return true;
		//var form_str = GetFormData(get_part);
		//AjaxPageLoad('<cfoutput>#request.self#?fuseaction=call.popup_ajax_get_members#xml_str#</cfoutput>&'+form_str+'','members_result_detail_div',1);
		//return false;

	}
	/*
	function nextPreviousPage(page)
	{
		var form_str = GetFormData(get_part);
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=call.popup_ajax_get_members#xml_str#</cfoutput>&page='+page+'&'+form_str+'','members_result_detail_div',1);
		return false;
	}
	*/
	function type_(company_id,partner_id,type)
	{
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_callcenter&event=det&cpid=' + company_id+'&partner_id=' + partner_id;
	}
	function type__(consumer_id,type)
	{
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_callcenter&event=det&cid=' + consumer_id;
	}
	<cfif is_company eq 1>
		document.getElementById("firm").focus();
	<cfelse>
		document.getElementById("name").focus();
	</cfif>
</script>
