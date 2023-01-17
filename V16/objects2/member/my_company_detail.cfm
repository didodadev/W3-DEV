<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		COMPANY.COMPANY_STATUS,
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
		COMPANY_CAT
	WHERE 
		COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
</cfquery>
<cfquery name="GET_WORK_POS" datasource="#DSN#">
	SELECT
		COMPANY_ID,
		OUR_COMPANY_ID,
		POSITION_CODE,
		IS_MASTER
	FROM
		WORKGROUP_EMP_PAR
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		COMPANY_ID IS NOT NULL AND
		<cfif isdefined('session.pp.userid')>
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
		<cfelseif isdefined('session.ww.userid')>
			OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.company_id#"> AND
		</cfif>
		IS_MASTER = 1
</cfquery>

<cfparam name="attributes.totalrecords" default='#get_company.recordcount#'>
<cfoutput>
	<div class="table-responsive-lg">
        <table class="table">
            <thead class="main-bg-color">
				<tr>
					<td><cf_get_lang dictionary_id='57571.Ünvan'></td>
					<td><cf_get_lang dictionary_id='57493.Aktif'></td>
					<td><cf_get_lang dictionary_id='57577.Potansiyel'></td>
					<td><cf_get_lang dictionary_id='57578.Yetkili'></td>
					<td><cf_get_lang dictionary_id='57486.Kategori'></td>
					<td><cf_get_lang dictionary_id ='57659.Satış Bölgesi'></td>
					<td><cf_get_lang dictionary_id ='58134.Mikro Bölge Kodu'></td>
					<td><cf_get_lang dictionary_id ='57908.Temsilci'></td>
					<td><cf_get_lang dictionary_id='58552.Müşteri Değeri'></td>
					<td><cf_get_lang dictionary_id='58585.Kod'> / <cf_get_lang dictionary_id='57499.Tel'></td>
					<td><cf_get_lang dictionary_id='58079.Internet'></td>
					<td><cf_get_lang dictionary_id='58585.Kod'> / <cf_get_lang dictionary_id='57488.fax'></td>
					<td><cf_get_lang dictionary_id='57428.E-Mail'></td>
					<td><cf_get_lang dictionary_id='58585.Kod'>/<cf_get_lang dictionary_id='58482.Mobil Tel'></td>
					<td><cf_get_lang dictionary_id='58723.Adres'></td>
					<td></td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>#get_company.fullname#</td>
					<td><cfif get_company.company_status eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
					<td><cfif get_company.ispotantial eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
					<td>#get_par_info(get_company.manager_partner_id,0,-1,0)#</td>
					<td>#get_company.companycat#</td>
					<td>
						<cfif len(get_company.sales_county)>
							<cfquery name="SALES_ZONES" datasource="#DSN#">
								SELECT SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE = 1 AND SZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.sales_county#">
							</cfquery>
							#sales_zones.sz_name#
						</cfif>
					</td>
					<td>
						<cfif len(get_company.ims_code_id)>
							<cfquery name="GET_IMS" datasource="#DSN#">
								SELECT IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.ims_code_id#">
							</cfquery>
							#get_ims.ims_code# #get_ims.ims_code_name#
						</cfif>
					</td>
					<td><cfif get_work_pos.recordcount>#get_emp_info(get_work_pos.position_code,1,0)#</cfif></td>
					<td>
						<cfif len(get_company.company_value_id)>
							<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
								SELECT CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE WHERE CUSTOMER_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.company_value_id#">
							</cfquery>
							#get_customer_value.customer_value#
						</cfif>
					</td>
					<td>#get_company.company_telcode# #get_company.company_tel1# #get_company.company_tel2# #get_company.company_tel3#</td>
					<td><a href="<cfif not find('http:',get_company.homepage)>http://</cfif>#get_company.homepage#" target="_blank" class="tableyazi">#get_company.homepage#</a></td>
					<td>#get_company.company_telcode# #get_company.company_fax#</td>
					<td><a href="mailto:#get_company.company_email#">#get_company.company_email#</a></td>
					<td>#get_company.mobil_code# - #get_company.mobiltel#</td>
					<td>#get_company.company_address# #get_company.company_postcode#</td>
					<td>
						#get_company.semt#
						<cfif len(get_company.county)>
							<cfquery name="GET_COUNTY" datasource="#DSN#">
								SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.county#">
							</cfquery>
							#get_county.county_name#
						</cfif>							
						<cfif len(get_company.city)>
							<cfquery name="GET_CITY" datasource="#DSN#">
								SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.city#">
							</cfquery>
							#get_city.city_name#
						</cfif>	
						<cfif len(get_company.country)>
							<cfquery name="GET_COUNTRY" datasource="#DSN#">
								SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.country#">
							</cfquery>
							#get_country.country_name#
						</cfif>		
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</cfoutput>