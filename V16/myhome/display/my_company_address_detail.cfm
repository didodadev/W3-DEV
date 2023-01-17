<cf_get_lang_set module_name="myhome">
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
		COMPANY.PARTNER_ID,
		COMPANY.STREET,
		COMPANY.COMPANY_VALUE_ID,
		COMPANY.SALES_COUNTY,
		COMPANY.IMS_CODE_ID,
		COMPANY.MOBIL_CODE,
		COMPANY.MOBILTEL,
		COMPANY_CAT.COMPANYCAT, 
		COMPANY_CAT.COMPANYCAT_ID,
        (SELECT COUNT(COMPANY_ID) COUNT FROM COMPANY_LAW_REQUEST WHERE COMPANY.COMPANY_ID = COMPANY_LAW_REQUEST.COMPANY_ID AND COMPANY_LAW_REQUEST.REQUEST_STATUS = 1) COMPANY_LAW_REQUEST
	FROM 
		COMPANY,
		COMPANY_CAT, 
		COMPANY_PARTNER
	WHERE 
		COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
		AND COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID  
		AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID  
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
			AND
				(
				(COMPANY.COMPANY_ID IS NULL) 
				OR (COMPANY.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				)
		</cfif> 
</cfquery>
<cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
	SELECT * FROM COMPANY_BRANCH WHERE COMPANY_ID = #attributes.cpid# ORDER BY COMPBRANCH__NAME
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_company_branch.recordcount#'>
	<cf_ajax_list>
			<cfset county_list=''>
			<cfset city_list=''>
			<cfset country_list=''>
			<cfoutput query="get_company_branch">
				<cfif len(county_id) and not listfind(county_list,county_id)>
					<cfset county_list = Listappend(county_list,county_id)>
				</cfif>
				<cfif len(city_id) and not listfind(city_list,city_id)>
					<cfset city_list = Listappend(city_list,city_id)>
				</cfif>
				<cfif len(country_id) and not listfind(country_list,country_id)>
					<cfset country_list = Listappend(country_list,country_id)>
				</cfif>
			</cfoutput>
			<cfif len(county_list)>
				<cfset county_list=listsort(county_list,"numeric","ASC",",")>
				<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
					SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
				</cfquery>
				<cfset main_county_list = listsort(listdeleteduplicates(valuelist(get_company_branch.county_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(city_list)>
				<cfset city_list=listsort(city_list, "numeric","ASC",",")>
				<cfquery name="GET_CITY_NAME" datasource="#DSN#">
					SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
				</cfquery>
				<cfset main_city_list = listsort(listdeleteduplicates(valuelist(get_company_branch.city_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(country_list)>
				<cfset country_list=listsort(country_list,"numeric","ASC",",")>
				<cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
					SELECT COUNTRY_ID,COUNTRY_NAME,COUNTRY_PHONE_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
				</cfquery>
				<cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_company_branch.country_id,',')),'numeric','ASC',',')>
			</cfif>
			<thead>
				<tr>
					<th colspan="3"><cf_get_lang dictionary_id="57453.Şube"></th>
				</tr>
			</thead>
		<cfif get_company_branch.recordcount>
			<tbody>
				<cfoutput query="get_company_branch">
					<tr>
						<td>
							<b>#compbranch__name#</b>: 
							#compbranch_address# 
							<cfif len(county_id)>#get_county_name.county_name[listfind(main_county_list,get_company_branch.county_id,',')]#</cfif>
							<cfif len(city_id)>#get_city_name.city_name[listfind(main_city_list,get_company_branch.city_id,',')]#</cfif>
							<cfif len(country_id)>#get_country_name.country_name[listfind(main_country_list,get_company_branch.country_id,',')]#</cfif>
						</td>
						<td>
							<ul class="ui-icon-list">
								<cfif len(compbranch_email)>
									<li><a href="mailto:#compbranch_email#"><i class="icon-envelope-o" title="E-mail:#compbranch_email#"></i></a></li>
								</cfif>
								<li>
									<a href="javascript://" title="Tel: <cfif len(country_id) and Len(get_country_name.country_phone_code[listfind(main_country_list,get_company_branch.country_id,',')])>(#get_country_name.country_phone_code[listfind(main_country_list,get_company_branch.country_id,',')]#) </cfif>#compbranch_telcode#-#compbranch_tel1#"> 
									<i class="fa fa-phone"></i>
									</a>
								</li>	
								<li>
									<cfif not listfindnocase(denied_pages,'member.popup_add_partner"')>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.list_contact&event=add&is_popup=1&compid=#attributes.cpid#&comp_cat=#get_company.COMPANYCAT_ID#&compbranch_id=#compbranch_id#','medium');"><i class="icon-pluss"></i></a>
									</cfif>
								</li>							
							</ul>
						</td>
					
					</tr>
				</cfoutput>
			</tbody>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
				</tr>
			</tbody>
		</cfif>
</cf_ajax_list>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
