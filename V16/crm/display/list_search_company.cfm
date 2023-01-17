
<cf_grid_list>
    <thead>
        <tr>
            <th ><cf_get_lang_main no='75.No'></th>
            <th ><cf_get_lang no='668.Hedef Kodu'></th>
            <th><cf_get_lang_main no='338.İşyeri Adı'></th>
            <th ><cf_get_lang_main no='158.Ad Soyad'></th>
            <th ><cf_get_lang_main no='722.Mikro Bolge Kodu'></th>
            <th ><cf_get_lang_main no='340.Vergi No'></th>
            <th ><cf_get_lang_main no='613.TC Kimlik No'></th>				
            <th ><cf_get_lang_main no='1226.İlçe'></th>
            <th ><cf_get_lang_main no='1196.İl'></th>
            <th ><cf_get_lang_main no='87.Telefon'></th>
            <th><cf_get_lang_main no='41.Şube'></th>
            <th ><cf_get_lang_main no='482.Statü'></th>
        </tr>
    </thead>
    <tbody>
		<cfif get_company.recordcount>
		  <cfset city_name_list = "">
		  <cfset county_name_list = "">
		  <cfset ims_code_list = "">
		   <cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<cfif len(city) and not listfind(city_name_list,city)>
					<cfset city_name_list=listappend(city_name_list,city)>
				</cfif>
				<cfif len(county) and not listfind(county_name_list,county)>
					<cfset county_name_list=listappend(county_name_list,county)>
				</cfif>
				<cfif len(ims_code_id) and not listfind(ims_code_list,ims_code_id)>
					<cfset ims_code_list=listappend(ims_code_list,ims_code_id)>
				</cfif>
		   </cfoutput>
		   <cfif len(city_name_list)>
				<cfquery name="get_city_name" datasource="#DSN#">
					SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_name_list#) ORDER BY CITY_ID
				</cfquery>
				<cfset city_name_list = listsort(listdeleteduplicates(valuelist(get_city_name.city_id,',')),'numeric','ASC',',')>
		   </cfif>
		   <cfif len(county_name_list)>
		   		<cfquery name="get_county_name" datasource="#DSN#">
					SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_name_list#) ORDER BY COUNTY_ID
				</cfquery>
				<cfset county_name_list = listsort(listdeleteduplicates(valuelist(get_county_name.county_id,',')),'numeric','ASC',',')>
		   </cfif>
		   <cfif len(ims_code_list)>
		   		<cfquery name="get_ims_name" datasource="#DSN#">
					SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID IN (#ims_code_list#) ORDER BY IMS_CODE_ID
				</cfquery>
				<cfset ims_code_list = listsort(listdeleteduplicates(valuelist(get_ims_name.ims_code_id,',')),'numeric','ASC',',')>
		   </cfif>
		  
		  <cfoutput query="get_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfquery name="get_comp_info" dbtype="query">
				SELECT TR_NAME, BRANCH_NAME, CARIHESAPKOD, IS_SELECT FROM GET_COMPANY_ACCOUNT WHERE COMPANY_ID = #get_company.company_id#
			</cfquery>
			<tr>
				<td width="30">#currentrow#</td>
				<td>#company_id#</td>
				<td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#&is_search=1" class="tableyazi">#fullname#<cfif ispotantial neq 0> - <cf_get_lang_main no='165.Potansiyel'></cfif></a></td>
				<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#');" >#company_partner_name# #company_partner_surname#</a></td>
				<td title="#get_ims_name.ims_code_name[listfind(ims_code_list,ims_code_id,',')]#">#get_ims_name.ims_code[listfind(ims_code_list,ims_code_id,',')]#</td>
				<td>#taxno#</td>
				<td>#tc_identity#</td>
				<td>#get_county_name.county_name[listfind(county_name_list,county,',')]#</td>
				<td>#get_city_name.city_name[listfind(city_name_list,city,',')]#</td>
				<td>#company_telcode# #company_tel1#</td>
				<td><cfloop query="get_comp_info">#get_comp_info.branch_name# <cfif len(get_comp_info.carihesapkod)>/ #get_comp_info.carihesapkod#</cfif><cfif get_comp_info.is_select eq 0> - <cf_get_lang_main no='165.Potansiyel'></cfif><br/></cfloop></td>
				<td><cfloop query="get_comp_info"><cfif len(get_comp_info.tr_name)>#get_comp_info.tr_name#</cfif><br/></cfloop></td>
			</tr>
		  </cfoutput>
		<cfelse>
			<tr>
				<td colspan="30"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
    </tbody>
</cf_grid_list>

<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
		<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
	</cfif>
				<cf_paging 
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="crm.#fusebox.fuseaction##url_str#"
					isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
			<!--- <td style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td> --->
</cfif>

<script type="text/javascript">
	search_company.fullname.focus();
</script>
