<cfsetting showdebugoutput="no"><!--- ajax oldg. için --->
<cfinclude template="../query/get_consumer_contact.cfm">
<cf_get_lang_set module_name="member">
<table class="ajax_list">
	<thead>
	<tr>
		<th><cf_get_lang dictionary_id='30508.Adres Adı'></th>
		<th><cf_get_lang dictionary_id='58143.İletişim'></th>
		<th><cf_get_lang dictionary_id='58638.ilçe'></th>
		<th><cf_get_lang dictionary_id='57971.Şehir'></th>
		<th><cf_get_lang dictionary_id='58219.Ülke'></th>
		<th><cf_get_lang dictionary_id='57756.Durum'></th>
	</tr>	
	</thead>
	<tbody>
	<cfif get_consumer_contact.recordcount>
		<cfset county_list=''>
		<cfset city_list=''>
		<cfset country_list=''>	
		<cfoutput query="get_consumer_contact">
			<cfif len(contact_county_id) and not listfind(county_list,contact_county_id)>
				<cfset county_list = Listappend(county_list,contact_county_id)>
			</cfif>
			<cfif len(contact_city_id) and not listfind(city_list,contact_city_id)>
				<cfset city_list = Listappend(city_list,contact_city_id)>
			</cfif>
			<cfif len(contact_country_id) and not listfind(country_list,contact_country_id)>
				<cfset country_list = Listappend(country_list,contact_country_id)>
			</cfif>	
		</cfoutput>
		<cfif len(county_list)>
			<cfset county_list=listsort(county_list,"numeric","ASC",",")>			
			<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
				SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
			</cfquery>
			<cfset main_county_list = listsort(listdeleteduplicates(valuelist(get_county_name.county_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(city_list)>
			<cfset city_list=listsort(city_list,"numeric","ASC",",")>			
			<cfquery name="GET_CITY_NAME" datasource="#DSN#">
				SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
			</cfquery>
			<cfset main_city_list = listsort(listdeleteduplicates(valuelist(get_city_name.city_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(country_list)>
			<cfset country_list=listsort(country_list,"numeric","ASC",",")>			
			<cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
				SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
			</cfquery>
			<cfset main_country_list = listsort(listdeleteduplicates(valuelist(get_country_name.country_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_consumer_contact">
			<tr>
				<td><a href="#request.self#?fuseaction=#fusebox.circuit#.upd_consumer_contact&contactid=#contact_id#&cid=#url.cid#" class="tableyazi">#contact_name#</a></td>
				<td><img src="/images/tel.gif"  title="Tel:#contact_telcode#-#contact_tel1#"> &nbsp;
					<cfif len(contact_email)>
						<a href="mailto:#contact_email#"><img src="/images/mail.gif"  title="E-mail:#contact_email#" border="0"></a>
					</cfif>
				</td>
				<td><cfif len(contact_county_id)>#get_county_name.county_name[listfind(main_county_list,get_consumer_contact.contact_county_id,',')]#</cfif></td>
				<td><cfif len(contact_city_id)>#get_city_name.city_name[listfind(main_city_list,get_consumer_contact.contact_city_id,',')]#</cfif></td>
				<td><cfif len(contact_country_id)>#get_country_name.country_name[listfind(main_country_list,get_consumer_contact.contact_country_id,',')]#</cfif></td>
				<td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
			</tr>
		</cfoutput>
<cfelse>
	<tr>
		<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
	</tr>
</cfif>
</tbody>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
