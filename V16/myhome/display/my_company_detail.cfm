<cf_get_lang_set module_name="myhome">
<cfif not isdefined("GET_COMPANY")>
	<cfset attributes.maxrows = session.ep.maxrows>
	<cfset attributes.startrow = 1>
	<cfquery name="GET_COMPANY" datasource="#DSN#">
		SELECT
			COMPANY.COMPANY_STATUS,
            COMPANY.MEMBER_CODE,
			COMPANY.ISPOTANTIAL,
			COMPANY.FULLNAME, 
			COMPANY.COMPANY_ID, 
			COMPANY.COMPANY_TELCODE, 
			COMPANY.COMPANY_TEL1, 
			COMPANY.TAXNO, 
			COMPANY.DISTRICT, 
			COMPANY.TAXOFFICE, 
			COMPANY.MAIN_STREET, 
			COMPANY.COMPANY_ADDRESS, 
			COMPANY.DUKKAN_NO, 
			COMPANY.COMPANY_TEL2, 
			COMPANY.COMPANY_TEL3, 
			COMPANY.SEMT, 
			COMPANY.COMPANY_FAX_CODE, 
			COMPANY.COMPANY_FAX, 
			COMPANY.COMPANY_EMAIL, 
			COMPANY.COMPANY_POSTCODE, 
			COMPANY.COUNTY, 
			COMPANY.CITY, 
			COMPANY.COUNTRY,
			COMPANY.HOMEPAGE, 
			COMPANY.MANAGER_PARTNER_ID, 
			COMPANY.STREET,
			COMPANY.COMPANY_VALUE_ID,
			COMPANY.SALES_COUNTY,
			COMPANY.IMS_CODE_ID,
			COMPANY.MOBIL_CODE,
			COMPANY.MOBILTEL,
			COMPANY_CAT.COMPANYCAT, 
			COMPANY_CAT.COMPANYCAT_ID
		FROM 
			COMPANY, 
			COMPANY_CAT, 
			COMPANY_PARTNER 
		WHERE 
			COMPANY.COMPANY_ID = #attributes.cpid#  
			AND COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID  
			AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID   
	</cfquery>
</cfif>
<cfquery name="get_work_pos" datasource="#dsn#">
	SELECT
		COMPANY_ID,
		OUR_COMPANY_ID,
		POSITION_CODE,
		IS_MASTER
	FROM
		WORKGROUP_EMP_PAR
	WHERE
		COMPANY_ID = #attributes.cpid# AND
		COMPANY_ID IS NOT NULL AND
		OUR_COMPANY_ID = #session.ep.company_id# AND
		IS_MASTER = 1
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_company.recordcount#'>
<cfif Len(get_company.country)>
	<cfquery name="GET_COUNTRY" datasource="#dsn#">
		SELECT COUNTRY_NAME,COUNTRY_PHONE_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_company.country#
	</cfquery>
</cfif>
<cfoutput>
	<cfset index = 1>
	<div class="row" id="comp_member_detail">
		<div class="row" type="row">
        	<div class="col col-12 col-xs-12" type="column" sort="false" index="<cfoutput>#index#</cfoutput>">
            	<cfset index = index + 1>
            	<div class="form-group" id="item-MEMBER_CODE">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id="57558.üye no"> :</label>
                    <label class="col col-8 col-xs-12">#get_company.MEMBER_CODE#</label>
                </div>
            	<div class="form-group" id="item-company_status">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57493.Aktif'> :</label>
                    <label class="col col-8 col-xs-12"><cfif get_company.company_status eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></label>
                </div>
            	<div class="form-group" id="item-MANAGER_PARTNER_ID">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57578.Yetkili'> :</label>
                    <label class="col col-8 col-xs-12">#get_par_info(get_company.MANAGER_PARTNER_ID,0,-1,0)#</label>
                </div>
            	<div class="form-group" id="item-sales_county">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id ='57659.Satış Bölgesi'> :</label>
                    <label class="col col-8 col-xs-12">
						<cfif len(get_company.sales_county)>
                            <cfquery name="sales_zones" datasource="#dsn#">
                                SELECT SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE = 1 AND SZ_ID = #get_company.sales_county#
                            </cfquery>
                            #sales_zones.sz_name#
                        </cfif>
                    </label>
                </div>
            	<div class="form-group" id="item-emp_info">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57908.Temsilci'> :</label>
                    <label class="col col-8 col-xs-12"><cfif get_work_pos.recordcount>#get_emp_info(get_work_pos.position_code,1,0)#</cfif></label>
                </div>
            	<div class="form-group" id="item-country_phone_code">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='31281.Kod / Tel'> :</label>
                    <label class="col col-8 col-xs-12"><cfif Len(get_company.country) and len(get_country.country_phone_code)>(#get_country.country_phone_code#) </cfif>#get_company.company_telcode# #get_company.company_tel1# #get_company.company_tel2# #get_company.company_tel3#</label>
                </div>
            	<div class="form-group" id="item-company_fax">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='31391.Kod / Fax'> :</label>
                    <label class="col col-8 col-xs-12">#get_company.company_telcode# #get_company.company_fax#</label>
                </div>
            	<div class="form-group" id="item-company_mobiltel">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='31920.Kod/Mobil Tel'> :</label>
                    <label class="col col-8 col-xs-12">#get_company.mobil_code# #get_company.mobiltel#</label>
                </div>
            	<div class="form-group" id="item-company_Adres">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58723.Adres'> :</label>
                    <label class="col col-8 col-xs-12">
                    	#get_company.company_address# #get_company.company_postcode#
                        #get_company.semt#
						<cfif len(get_company.county)>
                            <cfquery name="GET_COUNTY" datasource="#DSN#">
                                SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_company.county#
                            </cfquery>
                            #get_county.county_name#
                        </cfif>							
                        <cfif len(get_company.city)>
                            <cfquery name="GET_CITY" datasource="#DSN#">
                                SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_company.city#
                            </cfquery>
                            #get_city.city_name#
                        </cfif>	
                        <cfif len(get_company.country) and Len(GET_COUNTRY.country_name)>
                            #get_country.country_name#
                        </cfif>
                    </label>
                </div>
            </div>
        	<div class="col col-12 col-xs-12" type="column" sort="false" index="<cfoutput>#index#</cfoutput>">
	            <cfset index = index + 1>
            	<div class="form-group" id="item-fullname">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57571.Ünvan'> :</label>
                    <label class="col col-8 col-xs-12">#get_company.fullname#</label>
                </div>
            	<div class="form-group" id="item-ispotantial">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57577.Potansiyel'> :</label>
                    <label class="col col-8 col-xs-12"><cfif get_company.ispotantial eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></label>
                </div>
            	<div class="form-group" id="item-companycat">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57486.Kategori'> :</label>
                    <label class="col col-8 col-xs-12">#get_company.companycat#</label>
                </div>
            	<div class="form-group" id="item-ims_code">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id ='58134.Mikro Bölge Kodu'> :</label>
                    <label class="col col-8 col-xs-12">
						<cfif len(get_company.ims_code_id)>
                            <cfquery name="get_ims" datasource="#dsn#">
                                SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #get_company.ims_code_id#
                            </cfquery>
                            #get_ims.ims_code# #get_ims.ims_code_name#
                        </cfif>
                    </label>
                </div>
            	<div class="form-group" id="item-get_customer_value">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58552.Müşteri Değeri'> :</label>
                    <label class="col col-8 col-xs-12">
						<cfif len(get_company.company_value_id)>
                            <cfquery name="get_customer_value" datasource="#dsn#">
                                SELECT CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE WHERE CUSTOMER_VALUE_ID = #get_company.company_value_id#
                            </cfquery>
                            #get_customer_value.customer_value#
                        </cfif>
                    </label>
                </div>
            	<div class="form-group" id="item-Internet">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58079.Internet'> :</label>
                    <label class="col col-8 col-xs-12"><a href="<cfif not find('http:',get_company.homepage)>http://</cfif>#get_company.homepage#" target="_blank" class="tableyazi">#get_company.homepage#</a></label>
                </div>
            	<div class="form-group" id="item-E-Mail">
                	<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57428.E-Mail'> :</label>
                    <label class="col col-8 col-xs-12"><a href="mailto:#get_company.company_email#">#get_company.company_email#</a></label>
                </div>
            	<div class="form-group" id="item-is_sales_for_self">
                	<label class="col col-4 col-xs-12 bold">&nbsp;</label>
					<cfif isdefined("is_sales_for_self") and is_sales_for_self eq 1>
                        <label class="col col-8 col-xs-12 bold">
                            <i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i> <a href="#request.self#?fuseaction=objects2.basket_expres&company_id=#get_company.company_id#&partner_id=#get_company.manager_partner_id#" target="_blank"><cf_get_lang dictionary_id='32277.Kendi Adına Sipariş Giriş'></a>
                        </label>
                    </cfif>
                </div>
            </div>
		</div>
	</div>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
