<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
	SELECT
		DISTINCT
		SZ_HIERARCHY
	FROM
		SALES_ZONES_ALL_1
	WHERE
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset row_block = 500>
<!--- Kapanmis,Sube Degisikligi,Diger Bunun dısındaki subeler gelmeli  --->
<cfquery name="GET_COMPANY_BRANCH" datasource="#DSN#">
	SELECT
		DISTINCT 
		CBR.COMPANY_ID
	FROM
		COMPANY_BRANCH_RELATED CBR,
		EMPLOYEE_POSITION_BRANCHES EPB
	WHERE
		CBR.MUSTERIDURUM IS NOT NULL AND
		EPB.POSITION_CODE = #session.ep.position_code# AND
		CBR.MUSTERIDURUM NOT IN (1,4,66) AND 
		EPB.BRANCH_ID = CBR.BRANCH_ID
</cfquery>
<cfquery name="GET_COMPANY_ALL" datasource="#DSN#">
	SELECT
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.COUNTY,
		COMPANY.CITY,
		COMPANY.SEMT,
		COMPANY.MANAGER_PARTNER_ID,
		SETUP_IMS_CODE.IMS_CODE,
		SETUP_IMS_CODE.IMS_CODE_NAME
	FROM
		COMPANY,
		COMPANY_PARTNER,
		SETUP_IMS_CODE
	WHERE
		SETUP_IMS_CODE.IMS_CODE_ID = COMPANY.IMS_CODE_ID AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID
		<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
			AND COMPANY.COMPANY_ID = #attributes.company_id#
		</cfif>
		<!--- satis takimi ekipde ve satis takıminda ekip lideri ise --->
		AND 
		(
			COMPANY.IMS_CODE_ID IN (
					SELECT
						DISTINCT IMS_ID
					FROM
						SALES_ZONES_ALL_2
					WHERE
						POSITION_CODE = #session.ep.position_code# )
		<!--- satis takimi ekipde ve satis takıminda ekip lideri ise --->			
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
														<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
													</cfloop>
													
													)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
											</cfloop>											
									)
		  </cfif>						
		)
	ORDER BY 
		FULLNAME
</cfquery>
<cfquery name="GET_COMPANY" dbtype="query">
	SELECT 
		*
	FROM
		GET_COMPANY_BRANCH,
		GET_COMPANY_ALL
	WHERE
		GET_COMPANY_BRANCH.COMPANY_ID = GET_COMPANY_ALL.COMPANY_ID
	ORDER BY 
		GET_COMPANY_ALL.FULLNAME	
</cfquery>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_COMPANY.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_grid_list>
	<thead>
        <tr>
            <th>
                <cfif get_company.recordcount neq 0><input type="checkbox" name="all_check" id="all_check" value="1" onClick="javascript: hepsi();"></cfif>
                <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_company.recordcount#</cfoutput>">
            </th>
			<th width="4%"><cf_get_lang dictionary_id='57487.No'></th>
			<th height="22"><cf_get_lang dictionary_id='63893.Şirket'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<th><cf_get_lang dictionary_id='52115.Hedef Kodu'></th>
			<th><cf_get_lang dictionary_id='58134.Mikro Bolge Kodu'></th>
			<th><cf_get_lang dictionary_id='63898.İlçe'></th>		  
			<th><cf_get_lang dictionary_id='58608.İl'></th>
			<th><cf_get_lang dictionary_id='58132.Semt'></th>
        </tr>
    </thead>
    <tbody>
       	<cfif get_company.recordcount>
	   		<cfset city_id_list=''>
	   		<cfset county_id_list=''>
			<cfoutput query="get_company">
				<cfif len(city) and not listfind(city_id_list,city)>
					<cfset city_id_list = Listappend(city_id_list,city)>
				</cfif>
				<cfif len(county) and not listfind(county_id_list,county)>
					<cfset county_id_list = Listappend(county_id_list,county)>
				</cfif>
			</cfoutput>
			<cfif len(city_id_list)>
				<cfset city_id_list=listsort(city_id_list,"numeric","ASC",",")>			
				<cfquery name="GET_CITY" datasource="#DSN#">
					SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#) ORDER BY CITY_ID
				</cfquery>
				<cfset city_id_list = listsort(listdeleteduplicates(valuelist(get_city.city_id,',')),'numeric','ASC',',')>
			</cfif>			
			<cfif len(county_id_list)>
				<cfset county_id_list=listsort(county_id_list,"numeric","ASC",",")>			
				<cfquery name="GET_COUNTY" datasource="#DSN#">
					SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#) ORDER BY COUNTY_ID
				</cfquery>
				<cfset county_id_list = listsort(listdeleteduplicates(valuelist(get_county.county_id,',')),'numeric','ASC',',')>
			</cfif>			
      	<cfoutput query="get_company">
        	<tr>
				<td>
					<input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="#company_id#">
					<input type="hidden" name="partner_id_#currentrow#" id="partner_id_#currentrow#" value="#manager_partner_id#">
					<input type="checkbox" name="check_#currentrow#" id="check_#currentrow#" value="#company_id#" >
				</td>
				<td width="25">#currentrow#</td>
				<td>#get_par_info(company_id,1,1,1)#</td>
				<td>#company_partner_name# #company_partner_surname#</td>
				<td>#company_id#</td>
				<td>#ims_code# #ims_code_name#</td>
				<td><cfif len(county)>#get_county.county_name[listfind(county_id_list,get_company.county,',')]#</cfif></td>
				<td><cfif len(city)>#get_city.city_name[listfind(city_id_list,get_company.city,',')]#</cfif></td>
				<td>#semt#</td>
      		</tr>
      	</cfoutput>
			<tr>
				<td colspan="9"><cf_workcube_buttons is_upd='0' add_function='check()'></td>
			</tr>
        <cfelse>
          	<tr>
				<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
         	</tr>
        </cfif>
    </tbody>
</cf_grid_list>