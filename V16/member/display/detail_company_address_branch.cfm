<cfsetting showdebugoutput="no">
<cfparam name="attributes.branch_status" default="">
<cfinclude template="../query/get_company_branch.cfm">
<cfform name="form_branch" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.popupajax_detail_company_address_branch&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#">
	<cf_box_search more="0">
		<div class="form-group">
			<select name="branch_status" id="branch_status" style="width:60px;">
				<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
				<option value="1" <cfif attributes.branch_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
				<option value="0" <cfif attributes.branch_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
			</select>
		</div>
		<div class="form-group">
			<cf_wrk_search_button button_type="4" search_function='connectAjax_branch()'>
		</div>
	</cf_box_search>
</cfform>
<cf_flat_list>
	<thead>
        <tr>
            <th><cf_get_lang dictionary_id='29532.Şube Adı'></th>
            <th><cf_get_lang dictionary_id='59005.Şube Kodu'></th>
            <th>Alias</th>
            <th><cf_get_lang dictionary_id='58638.ilçe'></th>
            <th><cf_get_lang dictionary_id='57971.Şehir'></th>
            <th><cf_get_lang dictionary_id='58219.Ülke'></th>
            <th><cf_get_lang dictionary_id='58143.İletişim'></th>
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
				<tr>
					<td><a href="#request.self#?fuseaction=member.form_list_company&event=updBranch&brid=#get_company_branch.compbranch_id#&cpid=#url.cpid#" class="tableyazi">#compbranch__name#</a></td>
					<td>#compbranch_code#</td>
					<td>#compbranch_alias#</td>
					<td><cfif len(county_id)>#get_county_name.county_name[listfind(main_county_list,get_company_branch.county_id,',')]#</cfif></td>
					<td><cfif len(city_id)>#get_city_name.city_name[listfind(main_city_list,get_company_branch.city_id,',')]#</cfif></td>
					<td><cfif len(country_id)>#get_country_name.country_name[listfind(main_country_list,get_company_branch.country_id,',')]#</cfif></td>
					<td>
						<i class="fa fa-phone"  title="<cf_get_lang dictionary_id='57499.Tel'>:#compbranch_telcode#-#compbranch_tel1#">&nbsp;</i>
						<cfif len(get_company_branch.coordinate_1) and len(get_company_branch.coordinate_2)>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="58849.Haritada Göster"></cfsavecontent>
						<a href="javascript://" ><img src="/images/gmaps.gif" border="0" title="<cfoutput>#message#</cfoutput>" onclick="windowopen('#request.self#?fuseaction=objects.popup_view_map&coordinate_1=#get_company_branch.coordinate_1#&coordinate_2=#get_company_branch.coordinate_2#&title=#get_company_branch.compbranch__name#','list','popup_view_map')" align="absmiddle"></a>
						</cfif>
						<cfif len(compbranch_email)>
						<a href="mailto:#compbranch_email#"><i class="fa fa-envelope" title="E-mail:#compbranch_email#" border="0"></i></a>
						</cfif>
						<cfif len(compbranch_fax)>&nbsp;<i class="fa fa-fax" title="<cf_get_lang dictionary_id ='57488.Fax'>:#compbranch_fax#" border="0"></i></cfif>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
    </tbody>
    <div style="width:300px;display:none;" id="show_branch_message"></div>
</cf_flat_list>
<script type="text/javascript">
	function connectAjax_branch()
	{
		branch_status = document.getElementById("branch_status").value ;
		AjaxFormSubmit(form_branch,'show_branch_message',0,' ',' ','<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popupajax_detail_company_address_branch&cpid=#attributes.cpid#&maxrows=#session.ep.maxrows#&is_active='+branch_status</cfoutput>,'body_detail_company_address_branch');
	}
</script>
