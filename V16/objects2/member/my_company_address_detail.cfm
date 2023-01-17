<cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
	SELECT
		*
	FROM
		COMPANY_BRANCH
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	ORDER BY
		COMPBRANCH__NAME
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_company_branch.recordcount#'>
<div class="table-responsive-lg">
	<table class="table">
		<thead class="main-bg-color">
			<tr>
				<td><cf_get_lang dictionary_id='35446.Adresler'>/<cf_get_lang dictionary_id='29434.Şubeler'></td>
				<td><cf_get_lang dictionary_id='58143.İletişim'></td>
			</tr>
		</thead>
		<tbody>
			<cfif get_company_branch.recordcount>
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
					SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
					</cfquery>
					<cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_company_branch.country_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_company_branch">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>
						<b>#compbranch__name#</b>: 
						#compbranch_address# 
						<cfif len(county_id)>#get_county_name.county_name[listfind(main_county_list,get_company_branch.county_id,',')]#</cfif>
						<cfif len(city_id)>#get_city_name.city_name[listfind(main_city_list,get_company_branch.city_id,',')]#</cfif>
						<cfif len(country_id)>#get_country_name.country_name[listfind(main_country_list,get_company_branch.country_id,',')]#</cfif></td>
						<td><img src="/images/tel.gif" title="Tel:#compbranch_telcode#-#compbranch_tel1#"> &nbsp;
							<cfif len(compbranch_email)>
							<a href="mailto:#compbranch_email#"><img src="/images/mail.gif" title="E-mail:#compbranch_email#" border="0"></a>
							</cfif>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</cfif>
		</tbody>
	</table>
</div>