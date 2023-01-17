<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.liste" default="">
<cfparam name="attributes.sector_cats" default="">
<cfparam name="attributes.rel_company_id" default="">
<cfparam name="attributes.company_size_cats" default="">
<cfparam name="attributes.companycats" default="">
<cfparam name="attributes.company_sales_zone" default="">
<cfparam name="attributes.company_value" default="">
<cfparam name="attributes.company_resource" default="">
<cfparam name="attributes.partner_department" default="">
<cfparam name="attributes.partner_mission" default="">
<cfparam name="attributes.company_ims_code" default="">
<cfparam name="attributes.company_hobby" default="">
<cfparam name="attributes.rel_type_id" default="">
<cfparam name="attributes.conscat_ids" default="">
<cfparam name="attributes.cons_sales_zone" default="">
<cfparam name="attributes.cons_resource" default="">
<cfparam name="attributes.cons_value" default="">
<cfparam name="attributes.cons_income_level" default="">
<cfparam name="attributes.cons_education" default="">
<cfparam name="attributes.cons_vocation_type" default="">
<cfparam name="attributes.cons_hobby" default="">
<cfparam name="attributes.cons_ims_code" default="">
<cfparam name="attributes.cons_society" default="">
<cfparam name="attributes.cons_sector_cats" default="">
<cfparam name="attributes.cons_size_cats" default="">
<cfparam name="attributes.tmarket_name" default="">
<cfparam name="attributes.company_ozel_kod1" default="">
<cfparam name="attributes.company_ozel_kod2" default="">
<cfparam name="attributes.company_ozel_kod3" default="">
<cfparam name="attributes.rel_company_name" default="">
<cfparam name="attributes.COMPANY_COUNTY_ID" default="">
<cfparam name="attributes.COMPANY_CITY_ID" default="">
<cfparam name="attributes.CONS_COUNTY_ID" default="">
<cfparam name="attributes.CONS_CITY_ID" default="">
<cfparam name="attributes.is_potantial" default="">
<cfparam name="attributes.is_cari" default="">
<cfparam name="attributes.partner_active" default="">
<cfparam name="attributes.partner_passive" default=""> 
<cfparam name="attributes.is_buyer" default="">
<cfparam name="attributes.is_seller" default="">
<cfparam name="attributes.partner_sex" default="">
<cfparam name="attributes.is_company_search" default="">
 <cfparam name="attributes.cons_is_potantial" default="">
<cfparam name="attributes.cons_is_cari" default="">
<cfparam name="attributes.cons_active" default="">
<cfparam name="attributes.cons_passive" default=""> 
<cfparam name="attributes.cons_sex" default="">
<cfparam name="attributes.cons_is_married" default="">
<cfparam name="attributes.is_consumer_search" default="">
<cfparam name="attributes.tmarket_membership_startdate" default="">
<cfparam name="attributes.tmarket_membership_finishdate" default="">
<cfparam name="attributes.cons_ozel_kod1" default="">
<cfparam name="attributes.age_lower" default="">
<cfparam name="attributes.age_upper" default="">
<cfparam name="attributes.child_lower" default="">
<cfparam name="attributes.child_upper" default="">
<cfparam name="attributes.req_comp" default="">
<cfparam name="attributes.req_cons" default="">
<cfparam name="attributes.comp_want_email" default="2">
<cfparam name="attributes.cons_want_email" default="2">
<cfparam name="attributes.related_branch_id" default="">

<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS=1 ORDER BY BRANCH_NAME
</cfquery>
<cfif listlen(attributes.company_county_id)>
	<cfquery name="get_company_county" datasource="#dsn#">
		SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#attributes.COMPANY_COUNTY_ID#)
	</cfquery>
</cfif>
<cfif listlen(attributes.company_city_id)>
<cfquery name="get_company_city" datasource="#dsn#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#attributes.COMPANY_CITY_ID#)
</cfquery>
</cfif>
<cfif listlen(attributes.cons_city_id)>
	<cfquery name="get_cons_city" datasource="#dsn#">
		SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#attributes.cons_CITY_ID#)
	</cfquery>
</cfif>
<cfif listlen(attributes.cons_county_id)>
	<cfquery name="get_cons_county" datasource="#dsn#">
		SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#attributes.cons_COUNTY_ID#)
	</cfquery>
</cfif>

<cfif isdate(attributes.tmarket_membership_startdate)><cf_date tarih = "attributes.tmarket_membership_startdate"></cfif>
<cfif isdate(attributes.tmarket_membership_finishdate)><cf_date tarih = "attributes.tmarket_membership_finishdate"></cfif>
<cfquery name="CONSUMER_CATS" datasource="#dsn#">
	<!--- SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY --->
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		HIERARCHY		
</cfquery>	
<cfquery name="GET_COMPANYCATS" datasource="#dsn#">
	<!--- SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT --->
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="GET_COMPANY_SIZE_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_COMPANY_SIZE_CATS
</cfquery>
<cfquery name="GET_PARTNER_POSITIONS" datasource="#dsn#">
	SELECT * FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID IS NOT NULL ORDER BY PARTNER_POSITION
</cfquery>
<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#dsn#">
	SELECT * FROM SETUP_PARTNER_DEPARTMENT WHERE PARTNER_DEPARTMENT_ID IS NOT NULL ORDER BY PARTNER_DEPARTMENT
</cfquery>
<cfquery name="GET_SECTOR_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="get_ims_code" datasource="#dsn#">
	SELECT IMS_CODE_ID,	IMS_CODE, IMS_CODE_NAME	FROM SETUP_IMS_CODE	WHERE IMS_CODE_ID IS NOT NULL ORDER BY IMS_CODE
</cfquery>
<cfquery name="get_hobby" datasource="#dsn#">
	SELECT HOBBY_ID,HOBBY_NAME FROM SETUP_HOBBY
</cfquery>
<cfquery name="GET_SALES_ZONE" datasource="#dsn#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_EDU_LEVEL" datasource="#dsn#">
	SELECT EDU_LEVEL_ID, EDUCATION_NAME FROM	SETUP_EDUCATION_LEVEL
</cfquery>
<cfquery name="GET_VOCATION_TYPE" datasource="#dsn#">
	SELECT VOCATION_TYPE_ID,VOCATION_TYPE FROM SETUP_VOCATION_TYPE ORDER BY	VOCATION_TYPE
</cfquery>
<cfquery name="GET_SOCIETIES" datasource="#DSN#">
	SELECT SOCIETY_ID,SOCIETY FROM SETUP_SOCIAL_SOCIETY ORDER BY SOCIETY
</cfquery>
<cfquery name="GET_INCOME_LEVEL" datasource="#DSN#">
	SELECT INCOME_LEVEL_ID, INCOME_LEVEL FROM SETUP_INCOME_LEVEL ORDER BY INCOME_LEVEL
</cfquery>
<cfquery name="get_req" datasource="#DSN#">
  SELECT * FROM SETUP_REQ_TYPE
</cfquery>
<cfquery name="GET_COMP_RESOURCE" datasource="#DSN#">
    SELECT RESOURCE_ID,RESOURCE FROM COMPANY_PARTNER_RESOURCE
</cfquery>
<cfset url_str = "">
<cfset url_str = "#url_str#">
<cfif attributes.is_consumer_search eq 1 OR attributes.is_company_search eq 1>
	<cfquery name="GET_MEMBER" datasource="#dsn#">
	<cfif isdefined('attributes.is_consumer_search') and attributes.is_consumer_search eq 1>
		SELECT DISTINCT
			1 TYPE,
		    CONSUMER.MOBIL_CODE,
			CONSUMER.MOBILTEL,
			CONSUMER.CONSUMER_WORKTELCODE WORKTELCODE,
			CONSUMER.CONSUMER_WORKTEL WORKTEL,
			CONSUMER.CONSUMER_HOMETELCODE HOMETELCODE,
			CONSUMER.CONSUMER_HOMETEL HOMETEL,
			CONSUMER.CONSUMER_EMAIL EMAIL,
			CONSUMER.MISSION MISSION,
			CONSUMER.DEPARTMENT DEPARTMENT,
			CONSUMER.CONSUMER_NAME MEMBER_NAME,
			CONSUMER.CONSUMER_SURNAME MEMBER_SURNAME,
			CONSUMER.CONSUMER_ID MEMBER_ID,
			CONSUMER.COMPANY COMPANY,
			CONSUMER.HOMEADDRESS HOMEADDRESS,
			CONSUMER.HOMEPOSTCODE HOMEPOSTCODE,
			CONSUMER.HOMESEMT HOMESEMT,
			CONSUMER.WORKADDRESS WORKADDRESS,
			CONSUMER.WORKPOSTCODE WORKPOSTCODE,
			CONSUMER.WORKSEMT WORKSEMT,
			CONSUMER.HOME_COUNTY_ID HOMECOUNTYID,
			CONSUMER.HOME_CITY_ID HOMECITYID,
			CONSUMER.WORK_COUNTY_ID WORKCOUNTYID,
			CONSUMER.WORK_CITY_ID WORKCITYID,
			CONSUMER.TAX_NO TASK_NO,
			CONSUMER.TAX_NO TASK_NO,
			CONSUMER.CONSUMER_CAT_ID CAT_ID,
			CONSUMER.SALES_COUNTY SALES_COUNTY,
			CONSUMER.CUSTOMER_VALUE_ID CUSTOMER_VALUE,
			CONSUMER.RESOURCE_ID RESOURCE_ID,
			CONSUMER.IMS_CODE_ID IMS_CODE_ID
		FROM 
			CONSUMER
		<cfif listlen(attributes.cons_hobby)>
			,CONSUMER_HOBBY
		</cfif>
		<cfif listlen(attributes.cons_sector_cats)>
			,SETUP_SECTOR_CATS
		</cfif>
		<cfif listlen(attributes.cons_size_cats)>
			,SETUP_COMPANY_SIZE_CATS
		</cfif>
		WHERE
			<cfif attributes.cons_want_email eq 1>
				WANT_EMAIL = 1
			<cfelseif attributes.cons_want_email eq 0>
				WANT_EMAIL = 0
			<cfelse>
				(WANT_EMAIL = 1 OR WANT_EMAIL = 0)
			</cfif>
			<cfif listlen(attributes.cons_hobby)>
				AND CONSUMER.CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER_HOBBY WHERE HOBBY_ID IN (#attributes.cons_hobby#)) 
			</cfif>
			<cfif listlen(attributes.cons_is_potantial)>
				AND ISPOTANTIAL IN (#LISTSORT(attributes.cons_is_potantial,"NUMERIC")#) 
			</cfif>
			<cfif listlen(attributes.cons_is_cari)>
				AND IS_CARI=1 
			</cfif>
			<cfif listlen(attributes.cons_active)>
				AND CONSUMER_STATUS=1 
			</cfif>
			<cfif listlen(attributes.cons_passive)>
				AND CONSUMER_STATUS=0 
			</cfif>
			<cfif listlen(attributes.cons_sex)>
				AND SEX IN (#attributes.cons_sex#) 
			</cfif>
			<cfif listlen(attributes.cons_is_married)>
				AND MARRIED IN (#attributes.cons_is_married#) 
			</cfif>
			<cfif listlen(attributes.conscat_ids)>
				AND CONSUMER_CAT_ID IN (#attributes.conscat_ids#) 
			</cfif>
			<cfif listlen(attributes.cons_sales_zone)>
				AND SALES_COUNTY IN (#cons_sales_zone#) 
			</cfif>
			<cfif listlen(attributes.cons_resource)>
				AND RESOURCE_ID IN (#attributes.cons_resource#) 
			</cfif>
			<cfif listlen(attributes.cons_value)>
				AND CUSTOMER_VALUE_ID IN (#attributes.cons_value#) 
			</cfif>
			<cfif listlen(attributes.cons_income_level)>
				AND INCOME_LEVEL_ID IN (#attributes.cons_income_level#) 
			</cfif>
			<cfif listlen(attributes.cons_education)>
				AND EDUCATION_ID IN (#attributes.cons_education#) 
			</cfif>
			<cfif listlen(attributes.cons_vocation_type)>
				AND VOCATION_TYPE_ID IN (#attributes.cons_vocation_type#) 
			</cfif>
			<cfif listlen(attributes.cons_ims_code)>
				AND IMS_CODE_ID IN (#attributes.cons_ims_code#)
			</cfif>
			<cfif listlen(attributes.cons_society)>
				 AND CONSUMER.SOCIAL_SOCIETY_ID IN (#attributes.cons_society#) 
			</cfif>
			<cfif listlen(attributes.cons_sector_cats)>
				AND CONSUMER.SECTOR_CAT_ID = SETUP_SECTOR_CATS.SECTOR_CAT_ID 
				AND CONSUMER.SECTOR_CAT_ID IN (#attributes.cons_sector_cats#) 
			</cfif>
			<cfif listlen(attributes.cons_size_cats)>
				AND CONSUMER.COMPANY_SIZE_CAT_ID = SETUP_COMPANY_SIZE_CATS.COMPANY_SIZE_CAT_ID 
				AND CONSUMER.COMPANY_SIZE_CAT_ID IN (#attributes.cons_size_cats#) 
			</cfif>
			<cfif listlen(attributes.cons_city_id)>
				AND
				(	
					CONSUMER.HOME_CITY_ID IN (#attributes.cons_city_id#)
					OR CONSUMER.WORK_CITY_ID IN (#attributes.cons_city_id#)
					OR CONSUMER.TAX_CITY_ID IN (#attributes.cons_city_id#)
				)
			</cfif>
			<cfif len(attributes.related_branch_id)>
				AND CONSUMER.CONSUMER_ID IN (SELECT CONSUMER_ID FROM COMPANY_BRANCH_RELATED WHERE BRANCH_ID IN(#attributes.related_branch_id#)AND CONSUMER_ID IS NOT NULL)
			</cfif>
			<cfif listlen(attributes.cons_county_id)>
				AND
				(
					CONSUMER.HOME_COUNTY_ID IN (#attributes.cons_county_id#) 
					OR CONSUMER.WORK_COUNTY_ID IN (#attributes.cons_county_id#)
					OR CONSUMER.TAX_COUNTY_ID IN (#attributes.cons_county_id#)
				)
			</cfif>
			<cfif len(attributes.cons_ozel_kod1)>
				AND CONSUMER.OZEL_KOD = ('#attributes.cons_ozel_kod1#') 
			</cfif>
			<cfif len(attributes.age_lower)>
				AND DATEDIFF(YEAR,CONSUMER.BIRTHDATE,#now()#) >= #attributes.age_lower# 
			</cfif>
			<cfif len(attributes.age_upper)>
				AND DATEDIFF(YEAR, CONSUMER.BIRTHDATE, #now()#) <= #attributes.age_upper#
			</cfif>
			<cfif len(attributes.child_lower)>
				 AND CONSUMER.CHILD >= #attributes.child_lower# 
			</cfif>
			<cfif len(attributes.child_upper)>
				AND CONSUMER.CHILD <= #attributes.child_upper#
			</cfif>
			<cfif isdefined('attributes.req_cons') and len(attributes.req_cons)> 
				<cfquery name="GET_REQ_PEOPLE_CONS" datasource="#DSN#">
					SELECT 
						CONSUMER_ID,COUNT (CONSUMER_ID)
						FROM 
							MEMBER_REQ_TYPE 
						WHERE 
							REQ_ID IN (#attributes.req_cons#)  
						GROUP BY 
							CONSUMER_ID HAVING COUNT(CONSUMER_ID)>=#ListLen(attributes.req_cons,',')#
				</cfquery>
				<cfset C_REQ_CONS=ValueList(GET_REQ_PEOPLE_CONS.CONSUMER_ID,',')>
				<cfif len(C_REQ_CONS)>AND CONSUMER.CONSUMER_ID IN (#C_REQ_CONS#)</cfif>
			</cfif>
			<cfif len(attributes.tmarket_membership_startdate)>
				AND CONSUMER.RECORD_DATE >= #attributes.tmarket_membership_startdate#
			</cfif>
			<cfif len(attributes.tmarket_membership_finishdate)>
				AND CONSUMER.RECORD_DATE <= #attributes.tmarket_membership_finishdate# 
			</cfif>
	</cfif>
	<cfif isdefined('attributes.is_consumer_search') and attributes.is_consumer_search eq 1	 and isdefined('attributes.is_company_search') and attributes.is_company_search eq 1>
		UNION ALL
	</cfif>
	<cfif isdefined('attributes.is_company_search')	and attributes.is_company_search eq 1>
		SELECT DISTINCT
		  	2 TYPE,'' AS MOBIL_CODE,
		  	'' AS MOBILTEL,
			COMPANY.COMPANY_TELCODE WORKTELCODE,
			COMPANY.COMPANY_TEL1 WORKTEL,
			'' HOMETELCODE,
			'' HOMETEL,
			'' AS EMAIL,
			COMPANY_PARTNER.MISSION AS MISSION,
			COMPANY_PARTNER.DEPARTMENT AS DEPARTMENT,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME AS MEMBER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS MEMBER_SURNAME,
			COMPANY.COMPANY_ID AS MEMBER_ID,
			COMPANY.FULLNAME AS COMPANY,
			'' AS HOMEADDRESS,
			'0' AS HOMEPOSTCODE,
			'' AS HOMESEMT,
			COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS AS WORKADDRESS,
			COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE AS WORKPOSTCODE,
			COMPANY_PARTNER.SEMT AS WORKSEMT,
			0 AS HOMECOUNTYID,
			0 AS HOMECITYID,
			COMPANY_PARTNER.COUNTY AS WORKCOUNTYID,
			COMPANY_PARTNER.CITY AS WORKCITYID,
			COMPANY.TAXNO AS TASK_NO,
			COMPANY.TAXNO AS TASK_NO,
			COMPANY.COMPANYCAT_ID AS CAT_ID,
			COMPANY.SALES_COUNTY AS SALES_COUNTY,
			COMPANY.COMPANY_VALUE_ID AS CUSTOMER_VALUE,
			COMPANY.RESOURCE_ID AS RESOURCE_ID,
			COMPANY.IMS_CODE_ID AS IMS_CODE_ID
		 FROM 
			COMPANY_PARTNER,
			COMPANY
		WHERE
			COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
			<cfif attributes.comp_want_email eq 1>
				AND WANT_EMAIL = 1  
			<cfelseif attributes.comp_want_email eq 0>
				AND WANT_EMAIL = 0 
			<cfelse>
				AND (WANT_EMAIL = 1 OR WANT_EMAIL = 0)
			</cfif>
			<cfif isdefined('attributes.req_comp') and len(attributes.req_comp)> 
				<cfquery name="GET_REQ_PEOPLE" datasource="#DSN#">
					SELECT 
						PARTNER_ID,COUNT (PARTNER_ID)
					FROM 
						MEMBER_REQ_TYPE 
					WHERE 
						REQ_ID IN (#attributes.req_comp#)  
					GROUP BY 
						PARTNER_ID HAVING COUNT(PARTNER_ID)>=#ListLen(attributes.req_comp,',')#
				</cfquery>
				<cfset C_REQ=ValueList(GET_REQ_PEOPLE.PARTNER_ID,',')>
				<cfif len(C_REQ)>AND COMPANY_PARTNER.COMPANY_ID IN (#C_REQ#)</cfif>
			</cfif>
			<cfif listlen(attributes.is_potantial)>
				AND COMPANY.ISPOTANTIAL IN(#attributes.is_potantial#)
			</cfif>
			<cfif listlen(attributes.is_cari)>
				AND (COMPANY.IS_BUYER=1 OR COMPANY.IS_SELLER=1)
			</cfif>
			<cfif listlen(attributes.partner_active)>
				AND COMPANY.COMPANY_STATUS=1
			</cfif>
			<cfif listlen(attributes.partner_passive)>
				AND COMPANY.COMPANY_STATUS=0
			</cfif>
			<cfif listlen(attributes.is_buyer)>
				AND COMPANY.IS_BUYER=1
			</cfif>
			<cfif listlen(attributes.is_seller)>
				AND COMPANY.IS_SELLER=1
			</cfif>
			<cfif listlen(attributes.partner_sex)>
				AND COMPANY_PARTNER.SEX IN(#attributes.partner_sex#)
			</cfif>
			<cfif listlen(attributes.companycats)>
				AND COMPANY.COMPANYCAT_ID IN (#attributes.companycats#)
			</cfif>
			<cfif listlen(attributes.company_sales_zone)>
				AND COMPANY.SALES_COUNTY IN(#attributes.company_sales_zone#)
			</cfif>
			<cfif listlen(attributes.company_value)>
				AND COMPANY.COMPANY_VALUE_ID IN(#attributes.company_value#)
			</cfif>
			<cfif listlen(attributes.company_resource)>
				AND COMPANY.RESOURCE_ID IN(#attributes.company_resource#)
			</cfif>
			<cfif listlen(attributes.partner_department)>
				AND COMPANY_PARTNER.DEPARTMENT IN(#attributes.partner_department#)
			</cfif>
			<cfif listlen(attributes.partner_mission)>
				AND COMPANY_PARTNER.MISSION IN(#attributes.partner_mission#)
			</cfif>
			<cfif listlen(attributes.sector_cats)>
				AND COMPANY.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_SECTOR_RELATION WHERE SECTOR_ID IN (#attributes.sector_cats#) )
			</cfif>
			<cfif listlen(attributes.company_size_cats)>
				AND COMPANY.COMPANY_SIZE_CAT_ID IN(#attributes.company_size_cats#)
			</cfif>
			<cfif listlen(attributes.company_ims_code)>
				AND COMPANY.IMS_CODE_ID IN(#attributes.company_ims_code#)
			</cfif>
			<cfif listlen(attributes.company_hobby)>
				AND COMPANY_PARTNER.PARTNER_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER_HOBBY WHERE HOBBY_ID IN (#attributes.company_hobby#)) 	
			</cfif>
			<cfif listlen(attributes.company_county_id)>
				AND COMPANY.COUNTY IN(#attributes.company_county_id#)
			</cfif>
			<cfif listlen(attributes.company_city_id)>
				AND COMPANY.CITY IN(#attributes.company_city_id#)
			</cfif>
			<cfif listlen(attributes.rel_type_id) or len(attributes.REL_COMPANY_ID)>
				AND COMPANY.COMPANY_ID IN (SELECT 
											CPB.PARTNER_COMPANY_ID
											FROM 
												COMPANY_PARTNER_RELATION CPB 
											WHERE
											<cfif len(attributes.REL_COMPANY_ID)>
												CPB.COMPANY_ID  = #attributes.REL_COMPANY_ID#
											</cfif> 
											<cfif len(attributes.rel_type_id) and len(attributes.REL_COMPANY_ID)>AND</cfif>
											<cfif len(attributes.rel_type_id)>
											CPB.PARTNER_RELATION_ID IN (#attributes.rel_type_id#)
											</cfif>
											)
			</cfif>
			<cfif listlen(attributes.company_ozel_kod1)>
				AND COMPANY.OZEL_KOD='#attributes.company_ozel_kod1#'
			</cfif>
			<cfif listlen(attributes.company_ozel_kod2)>
				AND COMPANY.OZEL_KOD_1='#attributes.company_ozel_kod2#'
			</cfif>
			<cfif listlen(attributes.company_ozel_kod3)>
				AND COMPANY.OZEL_KOD_2='#attributes.company_ozel_kod3#'
			</cfif>
		</cfif>	
		ORDER BY
			TYPE,
			MEMBER_NAME,
			MEMBER_SURNAME DESC
	</cfquery>
<cfelse>
	<cfset get_member.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.totalrecords" default='#GET_MEMBER.recordcount#'>
<!--- <table class="dph">
	<tr>
		<td class="dpht"><a href="javascript:gizle_goster_ikili('target_market','target_market_basket');">&raquo;</a><cf_get_lang dictionary_id='39717.Hedef Kitle Ekle'></td>
		<!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' is_ajax="1" tag_module="target_market_basket"><!-- sil -->
	</tr>
</table> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
	<cfform name="add_tmarket" method="post" action="#request.self#?fuseaction=report.report_target_market">
		<cfif isdefined('camp_id')>
			<input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#camp_id#</cfoutput>">
        </cfif>
            <cf_report_list_search title="#getLang('','Kurumsal Üye Özellikleri',39734)#" unique_box_id="kurumsal_box" style="box-shadow:none!important;">
                <cf_report_list_search_area>  
                    <div class="row">
                        <div class="col col-12 col-xs-12">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='58705.Kurumsal Üye Kategorisi'></label>
                                            <div class="col col-11">
                                                <select name="companycats" id="companycats" multiple>
                                                    <cfoutput query="get_companycats">
                                                        <option value="#companycat_id#"<cfif listfind(attributes.companycats,companycat_id,',')>selected</cfif>>#companycat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                                            <div class="col col-11">
                                                <select name="company_sales_zone" id="company_sales_zone" multiple>
                                                    <cfoutput query="GET_SALES_ZONE">
                                                        <option value="#SZ_ID#"<cfif listfind(attributes.company_sales_zone,SZ_ID,',')>selected</cfif>>#SZ_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
                                            <div class="col col-11">
                                                <select name="company_value" id="company_value" multiple>
                                                    <cfoutput query="get_customer_value">
                                                        <option value="#customer_value_id#" <cfif listfind(attributes.company_value,customer_value_id,',')>selected</cfif>>#customer_value#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><td width="200"><cf_get_lang dictionary_id='39224.İlişki Tipi'></label>
                                            <div class="col col-11">
                                                <cf_wrk_combo
                                                    name="company_resource"
                                                    query_name="GET_PARTNER_RESOURCE"
                                                    option_name="resource"
                                                    option_value="resource_id"
                                                    multiple="1"
                                                    value="#attributes.cons_resource#"
                                                    is_option_text="0"
                                                    width="170"
                                                    height="80">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                            <div class="col col-11">
                                                <select name="partner_department" id="partner_department" multiple>
                                                    <cfoutput query="get_partner_departments">
                                                        <option value="#PARTNER_DEPARTMENT_ID#"<cfif listfind(attributes.partner_department,PARTNER_DEPARTMENT_ID,',')>selected</cfif>>#PARTNER_DEPARTMENT#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57573.Görev'></label>
                                            <div class="col col-11">
                                                <select name="partner_mission" id="partner_mission" multiple>
                                                    <cfoutput query="get_partner_positions">
                                                        <option value="#PARTNER_POSITION_ID#"<cfif listfind(attributes.partner_mission,PARTNER_POSITION_ID,',')>selected</cfif>>#PARTNER_POSITION#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
                                            <div class="col col-11">
                                                <select name="sector_cats" id="sector_cats" multiple>
                                                    <cfoutput query="get_sector_cats">
                                                        <option value="#sector_cat_id#"<cfif listfind(attributes.sector_cats,sector_cat_id,',')>selected</cfif>>#sector_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39514.Şirketteki Çalışan Sayısı'></label>
                                            <div class="col col-11">
                                                <select name="company_size_cats" id="company_size_cats" multiple>
                                                    <cfoutput query="get_company_size_cats">
                                                        <option value="#company_size_cat_id#"<cfif listfind(attributes.company_size_cats,company_size_cat_id,',')>selected</cfif>>#company_size_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39080.Mikro Bölge'></label>
                                            <div class="col col-11">
                                                <select name="company_ims_code" id="company_ims_code" multiple>
                                                    <cfoutput query="get_ims_code">
                                                        <option value="#IMS_CODE_ID#"<cfif listfind(attributes.company_ims_code,IMS_CODE_ID,',')>selected</cfif>>#IMS_CODE_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39517.Hobiler'></label>
                                            <div class="col col-11">
                                                <select name="company_hobby" id="company_hobby" multiple>
                                                    <cfoutput query="get_hobby">
                                                        <option value="#HOBBY_ID#"<cfif listfind(attributes.company_hobby,HOBBY_ID,',')>selected</cfif>>#HOBBY_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                                            <div class="col col-11">
                                                <select name="company_city_id" id="company_city_id" multiple>
                                                    <cfif isdefined("COMPANY_CITY_ID") and len("COMPANY_CITY_ID")>
                                                    <cfoutput query="get_company_city">
                                                        <option value="#get_company_city.city_id#">#get_company_city.city_name#</option>
                                                    </cfoutput>
                                                    </cfif>
                                                </select>
                                            </div>
                                            <div class = "col col-1 pl-1">
                                                <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_tmarket.company_city_id&field_name=add_tmarket.company_city_id&coklu_secim=1','','ui-draggable-box-small');"><img src="/images/plus_list.gif" align="absmiddle"></a><br/>
                                                <a href="javascript://" onclick="remove_field('company_city_id');"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id ='57463.Sil'>"></a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                                <div class="col col-11 ">
                                                    <select name="company_county_id" id="company_county_id" multiple>
                                                        <cfif isdefined("COMPANY_COUNTY_ID") and len("COMPANY_COUNTY_ID")>
                                                        <cfoutput query="get_company_county">
                                                            <option value="#get_company_county.county_id#">#get_company_county.county_name#</option>
                                                        </cfoutput>
                                                        </cfif>
                                                    </select>
                                                </div>
                                                <div class = "col col-1 pl-1">
                                                    <a href="javascript://" onclick="city_county(1,0);" style="cursor:pointer;"><img src="/images/plus_list.gif" align="absmiddle"></a><br/>
                                                    <a href="javascript://" onclick="remove_field('company_county_id');"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id ='57463.Sil'>"></a>
                                                </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id ='39519.İlişkili Üyeler'></label>
                                            <div class="col col-11">
                                                <cfquery name="get_rel_type" datasource="#dsn#">
                                                    SELECT PARTNER_RELATION_ID, PARTNER_RELATION FROM SETUP_PARTNER_RELATION
                                                </cfquery>
                                                <select name="rel_type_id" id="rel_type_id" multiple>
                                                    <cfoutput query="get_rel_type">
                                                        <option value="#PARTNER_RELATION_ID#"<cfif listfind(attributes.rel_type_id,PARTNER_RELATION_ID,',')>selected</cfif>>#PARTNER_RELATION#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id ='57907.Yetkinlik'></label>
                                            <div class="col col-11">
                                                <select name="req_comp" id="req_comp" multiple><!--- Yetkinlik --->
                                                    <cfoutput query="get_req">
                                                        <option value="#get_req.REQ_ID#"<cfif ListFind(attributes.req_comp,get_req.REQ_ID,',')>selected</cfif>>#get_req.REQ_NAME#</option>			
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39522.İlişkili Kurumsal Üye'></label>
                                            <div class="col col-11">
                                                <div class="input-group">
                                                    <cfoutput>
                                                        <input type="text" name="rel_company_name" id="rel_company_name" value="#attributes.rel_company_name#" onfocus="AutoComplete_Create('rel_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','rel_company_id','','3','150');">
                                                        <input type="hidden" name="rel_company_id" id="rel_company_id" value="#attributes.REL_COMPANY_ID#">    
                                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_asset.company_&field_comp_id=search_asset.company_id_&field_consumer=search_asset.consumer_id_&field_member_name=search_asset.company_&select_list=2,3');"></span> 
                                                    </cfoutput>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57789.Özel Kod'>1</label>
                                            <div class="col col-11">
                                                <cfoutput>
                                                     <input type="text" name="company_ozel_kod1" id="company_ozel_kod1" value="#attributes.company_ozel_kod1#" maxlength="75">
                                                </cfoutput>
                                            </div>    
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57789.Özel Kod'>2</label>
                                            <div class="col col-11">
                                                <cfoutput>
                                                     <input type="text" name="company_ozel_kod1" id="company_ozel_kod1" value="#attributes.company_ozel_kod1#" maxlength="75"> 
                                                </cfoutput>
                                            </div>    
                                        </div>
                                    </div>

                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                           
                                            <div class="col col-11">
                                                <cfoutput>
                                                    <select name="comp_want_email" id="comp_want_email">
                                                        <option value=""><cf_get_lang dictionary_id='29463.Mail'></option>
                                                        <option value="2" <cfif attributes.comp_want_email eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                        <option value="1" <cfif attributes.comp_want_email eq 1>selected</cfif>><cf_get_lang dictionary_id='40706.İsteyen'></option>
                                                        <option value="0" <cfif attributes.comp_want_email eq 0>selected</cfif>><cf_get_lang dictionary_id='40707.İstemeyen'></option>
                                                    </select>
                                                    <label class="col col-12"><cf_get_lang dictionary_id='39734.Kurumsal Üye Özellikleri'><input type="checkbox" name="is_company_search" id="is_company_search" value="1" <cfif 1 eq #attributes.is_company_search#>checked="checked"</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='57577.Potansiyel'><input type="checkbox" name="is_potantial" id="is_potantial"  value="1" <cfif 1 eq #attributes.is_potantial#>checked="checked"</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='58061.Cari'><input type="checkbox" name="is_cari" id="is_cari" value="1" <cfif 1 eq (attributes.is_cari)>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="partner_active" id="partner_active" value="1"<cfif 1 eq (attributes.partner_active)>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='57494.Pasif'><input type="checkbox" name="partner_passive" id="partner_passive" value="1"<cfif 1 eq (attributes.partner_passive)>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='58733.Alıcı'><input type="checkbox" name="is_buyer" id="is_buyer" value="1"<cfif 1 eq(attributes.is_buyer)>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='58873.Satıcı'><input type="checkbox" name="is_seller" id="is_seller" value="1"<cfif 1 eq(attributes.is_seller)>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='39509.Bay'><input type="checkbox" name="partner_sex" id="partner_sex" value="1"<cfif ListFind(attributes.partner_sex,1,',')>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='38921.Bayan'><input type="checkbox" name="partner_sex" id="partner_sex" value="0"<cfif ListFind(attributes.partner_sex,0,',')>checked</cfif>></label>   
                                                </cfoutput>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
            	</cf_report_list_search_area>
            </cf_report_list_search>        
            <cf_report_list_search title="#getLang('','Bireysel Üye Özellikleri',39810)#" unique_box_id="bireysel_box" style="box-shadow:none!important;">
                <cf_report_list_search_area>  
                    <div class="row">
                        <div class="col col-12 col-xs-12">
                            <div class="row formContent">
                                <div class="row" type="row">
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                            <div class="col col-11">
                                                <select name="conscat_ids" multiple>
                                                    <cfoutput query="consumer_cats">
                                                    <option value="#CONSCAT_ID#"<cfif listfind(attributes.conscat_ids,CONSCAT_ID,',')>selected</cfif>>#CONSCAT#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
                                            <div class="col col-11">
                                                <select name="company_sales_zone" id="company_sales_zone" multiple>
                                                    <cfoutput query="GET_SALES_ZONE">
                                                        <option value="#SZ_ID#"<cfif listfind(attributes.company_sales_zone,SZ_ID,',')>selected</cfif>>#SZ_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
                                            <div class="col col-11">
                                                <select name="company_value" id="company_value" multiple>
                                                    <cfoutput query="get_customer_value">
                                                        <option value="#customer_value_id#" <cfif listfind(attributes.company_value,customer_value_id,',')>selected</cfif>>#customer_value#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><td width="200"><cf_get_lang dictionary_id='39224.İlişki Tipi'></label>
                                            <div class="col col-11">
                                                <cf_wrk_combo
                                                    name="company_resource"
                                                    query_name="GET_PARTNER_RESOURCE"
                                                    option_name="resource"
                                                    option_value="resource_id"
                                                    multiple="1"
                                                    value="#attributes.cons_resource#"
                                                    is_option_text="0"
                                                    width="170"
                                                    height="80">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39521.Eğitim Seviyesi'></label>
                                            <div class="col col-11">
                                                <select name="cons_education" multiple>
                                                    <cfoutput query="get_edu_level">
                                                        <option value="#EDU_LEVEL_ID#"<cfif listfind(attributes.cons_education,EDU_LEVEL_ID,',')>selected</cfif>>#EDUCATION_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39524.Meslek Tipi'></label>
                                            <div class="col col-11">
                                                <select name="cons_vocation_type" multiple>
                                                    <cfoutput query="GET_VOCATION_TYPE">
                                                        <option value="#VOCATION_TYPE_ID#"<cfif listfind(attributes.cons_vocation_type,VOCATION_TYPE_ID,',')>selected</cfif>>#VOCATION_TYPE#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39526.Şirket Sektörü'></label>
                                            <div class="col col-11">
                                                <select name="sector_cats" id="sector_cats" multiple>
                                                    <cfoutput query="get_sector_cats">
                                                        <option value="#sector_cat_id#"<cfif listfind(attributes.sector_cats,sector_cat_id,',')>selected</cfif>>#sector_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39514.Şirketteki Çalışan Sayısı'></label>
                                            <div class="col col-11">
                                                <select name="company_size_cats" id="company_size_cats" multiple>
                                                    <cfoutput query="get_company_size_cats">
                                                        <option value="#company_size_cat_id#"<cfif listfind(attributes.company_size_cats,company_size_cat_id,',')>selected</cfif>>#company_size_cat#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39080.Mikro Bölge'></label>
                                            <div class="col col-11">
                                                <select name="company_ims_code" id="company_ims_code" multiple>
                                                    <cfoutput query="get_ims_code">
                                                        <option value="#IMS_CODE_ID#"<cfif listfind(attributes.company_ims_code,IMS_CODE_ID,',')>selected</cfif>>#IMS_CODE_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39517.Hobiler'></label>
                                            <div class="col col-11">
                                                <select name="company_hobby" id="company_hobby" multiple>
                                                    <cfoutput query="get_hobby">
                                                        <option value="#HOBBY_ID#"<cfif listfind(attributes.company_hobby,HOBBY_ID,',')>selected</cfif>>#HOBBY_NAME#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
                                            <div class="col col-11">
                                                <select name="company_city_id" id="company_city_id" multiple>
                                                    <cfif isdefined("COMPANY_CITY_ID") and len("COMPANY_CITY_ID")>
                                                    <cfoutput query="get_company_city">
                                                        <option value="#get_company_city.city_id#">#get_company_city.city_name#</option>
                                                    </cfoutput>
                                                    </cfif>
                                                </select>
                                            </div>
                                            <div class = "col col-1 pl-1">
                                                <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_tmarket.company_city_id&field_name=add_tmarket.company_city_id&coklu_secim=1','','ui-draggable-box-small');"><img src="/images/plus_list.gif" align="absmiddle"></a><br/>
                                                <a href="javascript://" onclick="remove_field('company_city_id');"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id ='57463.Sil'>"></a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
                                                <div class="col col-11 ">
                                                    <select name="company_county_id" id="company_county_id" multiple>
                                                        <cfif isdefined("COMPANY_COUNTY_ID") and len("COMPANY_COUNTY_ID")>
                                                        <cfoutput query="get_company_county">
                                                            <option value="#get_company_county.county_id#">#get_company_county.county_name#</option>
                                                        </cfoutput>
                                                        </cfif>
                                                    </select>
                                                </div>
                                                <div class = "col col-1 pl-1">
                                                    <a href="javascript://" onclick="city_county(1,1);" style="cursor:pointer;"><img src="/images/plus_list.gif" align="absmiddle"></a><br/>
                                                    <a href="javascript://" onclick="remove_field('company_county_id');"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id ='57463.Sil'>"></a>
                                                </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row" type="row">
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id ='39733.İlişkili Şube'></label>
                                            <div class="col col-11">
                                                <select name="related_branch_id" multiple>
                                                    <cfoutput query="get_branch">
                                                        <option value="#branch_id#"<cfif listfind(attributes.related_branch_id,branch_id,',')>selected</cfif>>#branch_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='58715.Listele'></label>
                                            <div class="col col-11">    
                                                <select name="liste" id="liste" multiple="multiple">
                                                    <option value="1"<cfif listlen(attributes.liste) and listfind(liste,1)>selected</cfif>><cf_get_lang dictionary_id='57752.Vergi No'></option>
                                                    <option value="2"<cfif listlen(attributes.liste) and listfind(liste,2)>selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>
                                                    <option value="3"<cfif listlen(attributes.liste) and listfind(liste,3)>selected</cfif>><cf_get_lang dictionary_id='57659.Satış Bölgesi'></option>
                                                    <option value="4"<cfif listlen(attributes.liste) and listfind(liste,4)>selected</cfif>><cf_get_lang dictionary_id='58552.Müşteri Değeri'></option>
                                                    <option value="5"<cfif listlen(attributes.liste) and listfind(liste,5)>selected</cfif>><cf_get_lang dictionary_id='39224.İlişki Tipi'></option>
                                                    <option value="6"<cfif listlen(attributes.liste) and listfind(liste,6)>selected</cfif>><cf_get_lang dictionary_id='39080.Mikro Bölge'></option>
                                                    <option value="7"<cfif listlen(attributes.liste) and listfind(liste,7)>selected</cfif>><cf_get_lang dictionary_id='39811.Cep Tel No'></option>
                                                    <option value="8"<cfif listlen(attributes.liste) and listfind(liste,8)>selected</cfif>><cf_get_lang dictionary_id='55484.E-mail'></option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id ='57907.Yetkinlik'></label>
                                            <div class="col col-11">
                                                <select name="req_comp" id="req_comp" multiple><!--- Yetkinlik --->
                                                    <cfoutput query="get_req">
                                                        <option value="#get_req.REQ_ID#"<cfif ListFind(attributes.req_comp,get_req.REQ_ID,',')>selected</cfif>>#get_req.REQ_NAME#</option>			
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id ='39525.Sosyal Güvenlik Kurumu'></label>
                                            <div class="col col-11">
                                                <select name="cons_society" multiple>
                                                    <cfoutput query="GET_SOCIETIES">
                                                        <option value="#SOCIETY_ID#"<cfif listfind(attributes.cons_society,SOCIETY_ID,',')>selected</cfif>>#SOCIETY#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                                            <div class="col col-11">
                                                <cfoutput>
                                                    <input type="text" name="company_ozel_kod1" id="company_ozel_kod1" value="#attributes.company_ozel_kod1#" maxlength="75">
                                                </cfoutput>
                                            </div>    
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39531.Yaş Aralığı'></label>
                                            <div class="col col-11">
                                                <div class="col col-5">
                                                    <cfoutput>
                                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='49495.Yaş Aralığı Girmelisiniz'></cfsavecontent>
                                                        <input type="text" name="age_lower" value="#attributes.age_lower#" validate="integer" message="#message#">      
                                                    </cfoutput>    
                                                </div>
                                                <div class="col col-2 pl-5">
                                                    <cfoutput></cfoutput>    
                                                </div>
                                                <div class="col col-5">
                                                    <cfoutput>              
                                                        <input type="text" name="age_upper" value="#attributes.age_upper#" validate="integer" message="#message#">
                                                    </cfoutput>    
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39533.Çocuk Sayısı'></label>
                                            <div class="col col-11">
                                                <div class="col col-5">
                                                    <cfoutput>
                                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='39534.Çocuk Sayısı Aralığı Girmelisiniz '>!</cfsavecontent>
                                                        <cfinput type="text" name="child_lower" value="#attributes.child_lower#" validate="integer" message="#message#">
                                                    </cfoutput>    
                                                </div>
                                                <div class="col col-2">
                                                    <cfoutput></cfoutput>    
                                                </div>
                                                <div class="col col-5">
                                                    <cfoutput>              
                                                    <cfinput type="text" name="child_upper" value="#attributes.child_upper#" validate="integer" message="#message#">
                                                    </cfoutput>    
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39535.Üyelik Tarihi Başlangıç'></label>
                                            <div class="col col-11">
                                                <div class="input-group">
                                                   <cfinput type="text" name="tmarket_membership_startdate" value="#dateformat(attributes.tmarket_membership_startdate,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','Üyelik Tarihi Başlangıç Girmelisiniz',39536)# !" required="yes">
                                                   <cfif not isdefined('attributes.ajax')>
                                                   <span class="input-group-addon"><cf_wrk_date_image date_field="tmarket_membership_startdate"></span>
                                                   </cfif>
                                               </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='49333.Üyelik Tarihi Bitiş'></label>
                                            <div class="col col-11">
                                                <div class="input-group">
                                                   <cfinput type="text" name="tmarket_membership_finishdate" value="#dateformat(attributes.tmarket_membership_finishdate,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','Üyelik Tarihi Bitiş Girmelisiniz',39537)# !" required="yes">
                                                   <cfif not isdefined('attributes.ajax')>
                                                   <span class="input-group-addon"><cf_wrk_date_image date_field="tmarket_membership_finishdate"></span>
                                                   </cfif>
                                               </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-6 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='39810.Bireysel Üye Özellikleri'><input type="checkbox" name="is_company_search" id="is_company_search" value="1" <cfif 1 eq #attributes.is_company_search#>checked="checked"</cfif>></label>
                                            <div class="col col-11">
                                                <cfoutput>
                                                    <select name="comp_want_email" id="comp_want_email">
                                                        <option value=""><cf_get_lang dictionary_id='29463.Mail'></option>
                                                        <option value="2" <cfif attributes.comp_want_email eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                                        <option value="1" <cfif attributes.comp_want_email eq 1>selected</cfif>><cf_get_lang dictionary_id='40706.İsteyen'></option>
                                                        <option value="0" <cfif attributes.comp_want_email eq 0>selected</cfif>><cf_get_lang dictionary_id='40707.İstemeyen'></option>
                                                    </select>
                                                    <label><cf_get_lang dictionary_id='57577.Potansiyel'><input type="checkbox" name="is_potantial" id="is_potantial"  value="1" <cfif 1 eq #attributes.is_potantial#>checked="checked"</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='58061.Cari'><input type="checkbox" name="is_cari" id="is_cari" value="1" <cfif 1 eq (attributes.is_cari)>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="partner_active" id="partner_active" value="1"<cfif 1 eq (attributes.partner_active)>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='57494.Pasif'><input type="checkbox" name="partner_passive" id="partner_passive" value="1"<cfif 1 eq (attributes.partner_passive)>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='39509.Bay'><input type="checkbox" name="partner_sex" id="partner_sex" value="1"<cfif ListFind(attributes.partner_sex,1,',')>checked</cfif>></label>
                                                    <label><cf_get_lang dictionary_id='38921.Bayan'><input type="checkbox" name="partner_sex" id="partner_sex" value="0"<cfif ListFind(attributes.partner_sex,0,',')>checked</cfif>></label>   
                                                    <label><cf_get_lang dictionary_id='38916.Evli'><input type="checkbox" name="cons_is_married" id="cons_is_married" value="1"<cfif ListFind(attributes.cons_is_married,1,',') >checked</cfif>></label>   
                                                    <label><cf_get_lang dictionary_id='38915.Bekar'><input type="checkbox" name="cons_is_married" id="cons_is_married" value="0"<cfif ListFind(attributes.cons_is_married,0,',') >checked</cfif>></label>   
                                                </cfoutput>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
            	</cf_report_list_search_area>
            </cf_report_list_search>
        <div class="row ReportContentBorder col col-12">
            <div class="ReportContentFooter">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3">
                <cfelse>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3">
                </cfif>
                <cf_wrk_report_search_button insert_info='#getLang('','Çalıştır',57911)#' search_function='control()' button_type='1' is_excel='1'>
            </div>
        </div>
	</cfform>
</cf_box>
<cf_box id="target_market_basket" title="#getLang('','Detaylı Hedef Kitle Raporu',39438)#" uidrop="1" hide_table_column="1">
        <cf_grid_list class="basket_list">
            <thead>
                <tr>
                    <cfset cols_ = 2>
                    <th width="24" height="22"><cf_get_lang dictionary_id='57487.No'></th>
                    <th width="125" height="22"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th width="125" height="22"><cf_get_lang dictionary_id='57573.Görev'></th>
                    <th width="125" height="22"><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th width="125" height="22"><cf_get_lang dictionary_id='57574.Şirket'></th>
                    <th width="125" height="22"><cf_get_lang dictionary_id='58723.Adres'></th>
                    <cfif listfind(attributes.liste,1)><th width="25" height="22"><cf_get_lang dictionary_id='57752.Vergi No'></th><cfset cols_ = cols_ +1></cfif>
                    <cfif listfind(attributes.liste,2)><th width="25" height="22"><cf_get_lang dictionary_id='57486.Kategori'></th><cfset cols_ = cols_ +1></cfif>
                    <cfif listfind(attributes.liste,3)><th width="25" height="22"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th><cfset cols_ = cols_ +1></cfif>
                    <cfif listfind(attributes.liste,4)><th width="25" height="22"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></th><cfset cols_ = cols_ +1></cfif>
                    <cfif listfind(attributes.liste,5)><th width="25" height="22"><cf_get_lang dictionary_id='39224.İlişki Tipi'></th><cfset cols_ = cols_ +1></cfif>
                    <cfif listfind(attributes.liste,6)><th width="25" height="22"><cf_get_lang dictionary_id='39080.Mikro Bölge'></th><cfset cols_ = cols_ +1></cfif>
                    <cfif listfind(attributes.liste,7)><th width="50" height="22"><cf_get_lang dictionary_id='39811.Cep Tel No'></th><cfset cols_ = cols_ +1></cfif>
                    <cfif listfind(attributes.liste,8)><th width="50" height="22"><cf_get_lang dictionary_id='57428.E-mail'></th><cfset cols_ = cols_ +1></cfif>
                    <th width="25" height="22"><cf_get_lang dictionary_id='39530.Üye Tipi'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_member.recordcount>								
                    <cfoutput query="GET_MEMBER" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                        <cfif len(MISSION)>
                            <cfquery name="GET_PARTNER_POSITIONS_QUERY" dbtype="query">
                                SELECT PARTNER_POSITION FROM GET_PARTNER_POSITIONS WHERE PARTNER_POSITION_ID = #MISSION# 
                            </cfquery>
                        </cfif>
                        <cfif len(DEPARTMENT)>
                            <cfquery name="GET_PARTNER_DEPARTMENTS_QUERY" dbtype="query">
                                SELECT PARTNER_DEPARTMENT FROM GET_PARTNER_DEPARTMENTS WHERE PARTNER_DEPARTMENT_ID = #DEPARTMENT#
                            </cfquery>
                        </cfif>
                        <!--- Kurumsal Kategorilerini Getir --->
                        <cfif len(CAT_ID) and TYPE eq 2>
                            <cfquery name="GET_COMPANYCATS_QUERY" dbtype="query">
                                SELECT COMPANYCAT FROM GET_COMPANYCATS WHERE COMPANYCAT_ID=#CAT_ID#
                            </cfquery>
                        </cfif>
                        <!--- Bireysel Kategorilerini Getir --->
                        <cfif len(CAT_ID) and TYPE eq 1>
                            <cfquery name="CONSUMER_CATS_QUERY" dbtype="query">
                                SELECT CONSCAT FROM CONSUMER_CATS WHERE CONSCAT_ID=#CAT_ID#
                            </cfquery>
                        </cfif>
                        <!--- Satış Bölgesi Getir --->
                        <cfif len(SALES_COUNTY)>
                            <cfquery name="GET_SALES_ZONE_QUERY" dbtype="query">
                                SELECT SZ_NAME FROM GET_SALES_ZONE WHERE SZ_ID=#SALES_COUNTY#
                            </cfquery>
                        </cfif>
                        <!--- Müşteri Değeri Getir --->
                        <cfif len(CUSTOMER_VALUE)>
                            <cfquery name="get_customer_value_query" dbtype="query">
                                SELECT CUSTOMER_VALUE FROM get_customer_value WHERE CUSTOMER_VALUE_ID=#CUSTOMER_VALUE#
                            </cfquery>
                        </cfif>
                        <!--- İlişki Tipi Getir --->
                        <cfif len(RESOURCE_ID)>
                            <cfquery name="get_comp_resource_query" dbtype="query">
                                SELECT RESOURCE FROM get_comp_resource WHERE RESOURCE_ID=#RESOURCE_ID#
                            </cfquery>
                        </cfif>
                        <!--- Mikro Bölge Getir --->
                        <cfif len(IMS_CODE_ID)>
                            <cfquery name="get_ims_code_query" dbtype="query">
                                SELECT IMS_CODE_NAME FROM get_ims_code WHERE IMS_CODE_ID=#IMS_CODE_ID#
                            </cfquery>
                        </cfif>
                        <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
                            <td>#currentrow#</td>
                            <td>#MEMBER_NAME# #MEMBER_SURNAME# (#MEMBER_ID#)</td>
                            <td height="20"><cfif len(MISSION)>#GET_PARTNER_POSITIONS_QUERY.PARTNER_POSITION#</cfif></td>
                            <td><cfif len(DEPARTMENT)>#GET_PARTNER_DEPARTMENTS_QUERY.PARTNER_DEPARTMENT#</cfif></td>
                            <td>#COMPANY#</td>
                            <td><cfif isdefined("attributes.address_type") and attributes.address_type eq 2>
                                    #HOMEADDRESS# #HOMEPOSTCODE# #HOMESEMT# <cfif isdefined('get_counties')>#get_counties.COUNTY_NAME[listfind(county_list,home_county_id,',')]# /</cfif> <cfif isdefined('get_cities')>#get_cities.CITY_NAME[listfind(city_list,home_city_id,',')]#</cfif><cfif len(hometel)><cf_get_lang dictionary_id ='57499.Telefon'> : #hometelcode# #hometel#</cfif>
                                <cfelse>
                                    #WORKADDRESS# #WORKPOSTCODE# #WORKSEMT# <cfif isdefined('get_counties')>#get_counties.COUNTY_NAME[listfind(county_list,work_county_id,',')]# /</cfif> <cfif isdefined('get_cities')>#get_cities.CITY_NAME[listfind(city_list,work_city_id,',')]#</cfif><cfif len(worktel)><cf_get_lang dictionary_id ='57499.Telefon'>: #worktelcode# #worktel#</cfif>
                                </cfif>
                            </td>
                            <cfif listfind(attributes.liste,1)><td style="mso-number-format:'\@'">#TASK_NO#&nbsp;</td></cfif>	
                            <cfif listfind(attributes.liste,2)>
                                <td><cfif len(CAT_ID)>
                                        <cfif TYPE eq 2>#GET_COMPANYCATS_QUERY.COMPANYCAT#</cfif>
                                        <cfif TYPE eq 1>#CONSUMER_CATS_QUERY.CONSCAT#</cfif>
                                    </cfif>	
                                </td>
                            </cfif>
                            <cfif listfind(attributes.liste,3)>
                                <td><cfif len(SALES_COUNTY)>#GET_SALES_ZONE_QUERY.SZ_NAME#</cfif></td>
                            </cfif>
                            <cfif listfind(attributes.liste,4)>
                                <td><cfif len(CUSTOMER_VALUE)>#get_customer_value_query.CUSTOMER_VALUE#</cfif></td>
                            </cfif>
                            <cfif listfind(attributes.liste,5)>
                                <td><cfif len(RESOURCE_ID)>#get_comp_resource_query.RESOURCE#</cfif></td>
                            </cfif>
                            <cfif listfind(attributes.liste,6)>
                                <td><cfif len(IMS_CODE_ID)>#get_ims_code_query.IMS_CODE_NAME#</cfif></td>
                            </cfif>
                            <cfif listfind(attributes.liste,7)>
                                <td><cfif len(MOBIL_CODE) and len(MOBILTEL)>#MOBIL_CODE# #MOBILTEL#</cfif></td>
                            </cfif>
                            <cfif listfind(attributes.liste,8)>
                                <td><cfif len(email)>#email#</cfif></td>
                            </cfif>
                            <cfif TYPE eq 1><td>(B)</td></cfif> 
                            <cfif TYPE eq 2><td>(K)</td></cfif>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="7">
                            <cfif attributes.is_consumer_search eq 1>
                                <cf_get_lang dictionary_id ='57484.Kayıt Yok'>!
                            <cfelse>
                                <cf_get_lang dictionary_id='57701.Filtre Ediniz'>!
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>	  
        <cfif attributes.is_consumer_search eq 1 OR attributes.is_company_search eq 1>
            <cfset url_str = "#url_str#&is_consumer_search=#attributes.is_consumer_search#&is_company_search=#attributes.is_company_search#">
        </cfif>
        <cf_paging 
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="report.report_target_market#url_str#">
</cf_box>
</div>
<script type="text/javascript">
/* FS 20080716 burasi secili sehirlerin bagli olduklari ilcelerin goruntulenmesi icin eklendi */
function city_county(no,id)
{
	sehir_gonder = "";
	if (no == 1)
	{
		ilce_id = 'add_tmarket.company_county_id';
		sehir_id = document.add_tmarket.company_city_id;
	}
	else if (no == 2)
	{
		ilce_id = 'add_tmarket.cons_county_id';
		sehir_id = document.add_tmarket.cons_city_id;
	}
	if(sehir_id != undefined)
	for(kk = 0; kk < sehir_id.length; kk++)
	{
		if(sehir_id[kk].selected)
		{
			if(sehir_gonder != "")
				sehir_gonder = sehir_gonder  + ',' + sehir_id[kk].value;
			else
				sehir_gonder = sehir_id[kk].value;
		}
	}
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=' + ilce_id +'&field_name=' + ilce_id +'&city_id='+sehir_gonder+'&index='+id+'&coklu_secim=1','','ui-draggable-box-small');
}

function maxrov_arttir()
	{
		var my_startrow=document.add_tmarket.startrow.value;
		var my_maxrows=document.add_tmarket.maxrows.value;
		var my_recordcount=document.add_tmarket.record_count.value;
		if(my_recordcount-my_startrow>=my_maxrows)	
		{	
			son_startrow=parseInt(my_startrow)+parseInt(my_maxrows);
			document.add_tmarket.startrow.value=parseInt(son_startrow);
			document.add_tmarket.submit();
		}	
	}
function maxrov_azalt()
	{	
		var my_startrow=document.add_tmarket.startrow.value;
		var my_maxrows=document.add_tmarket.maxrows.value;
		var my_recordcount=document.add_tmarket.record_count.value;
		if((my_recordcount-my_startrow)>=(my_maxrows))	
		{	
			son_startrow=parseInt(my_startrow)-parseInt(my_maxrows);
			if(son_startrow !=0 && son_startrow>0)
			{
			document.add_tmarket.startrow.value=parseInt(son_startrow);
			document.add_tmarket.submit();
			}
		}
		if(parseInt((my_recordcount-my_startrow))<=parseInt(my_maxrows))
		{
			son_startrow=my_startrow-my_maxrows;
			if(son_startrow !=0 && son_startrow>0)
			{
			document.add_tmarket.startrow.value=son_startrow;
			document.add_tmarket.submit();
			}
		}	
	}	
function maxrov_last()
	{	
		var my_startrow=document.add_tmarket.startrow.value;
		var my_maxrows=document.add_tmarket.maxrows.value;
		var my_recordcount=document.add_tmarket.record_count.value;	
		var kalan=my_recordcount%my_maxrows;
		var sonuc=parseInt(my_recordcount/my_maxrows);
		if(my_recordcount-my_startrow>=my_maxrows)
		{	son_startrow=my_recordcount-kalan;
			document.add_tmarket.startrow.value=parseInt(son_startrow)+1;
			if(kalan==0)
			{
			son_startrow=(sonuc-1)*my_maxrows+1;
			document.add_tmarket.startrow.value=parseInt(son_startrow);
			}
			document.add_tmarket.submit();			
		}	
	}
	
function maxrov_first()
	{	
		var my_startrow=document.add_tmarket.startrow.value;
		var my_maxrows=document.add_tmarket.maxrows.value;
		var my_recordcount=document.add_tmarket.record_count.value;
		if(parseInt(my_startrow)!=1)
		{
			document.add_tmarket.startrow.value=1;
			document.add_tmarket.submit();
		}	
	}	
function remove_field(field_option_name)
{
	field_option_name_value = eval('document.add_tmarket.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
		{
			field_option_name_value.options.remove(i);
		}	
	}
}
function select_all(selected_field)
{
	var m = eval("document.add_tmarket." + selected_field + ".length");
	for(i=0;i<m;i++)
	{
		eval("document.add_tmarket."+selected_field+"["+i+"].selected=true")
	}
}

function hepsini_sec()
{
	select_all('cons_city_id');
	select_all('cons_county_id');
	select_all('company_city_id');
	select_all('company_county_id');
}

function limit_control()
{	
	if((add_tmarket.is_company_search.checked == false) && (add_tmarket.is_consumer_search.checked == false))
		{
			alert("<cf_get_lang dictionary_id='60812.Kurumsal Üye veya Bireysel Üye Özelliklerinden en az birisini Seçiniz'>!");
			return false;
		}
	document.add_tmarket.startrow.value=1;
	if((document.add_tmarket.age_lower.value != '') && (document.add_tmarket.age_upper.value != '') &&
	    (document.add_tmarket.age_lower.value > document.add_tmarket.age_upper.value)){
		alert("<cf_get_lang dictionary_id ='39813.Yaş Aralığı Düzgün Girilmedi'>!");
		return false;
	}
	if ((document.add_tmarket.tmarket_membership_startdate.value != '') && (document.add_tmarket.tmarket_membership_finishdate.value != '') &&
	    !date_check(add_tmarket.tmarket_membership_startdate,add_tmarket.tmarket_membership_finishdate,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
	hepsini_sec();
	return true;
}
</script>
<br/>
