<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.assetp_catid" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.is_collective_usage" default="">
<cfparam name="attributes.brand_type_cat_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.make_year" default="">
<cfparam name="attributes.property" default="">
<cfparam name="attributes.assetp_sub_catid" default="">
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfif len(attributes.form_submitted)>
	<cfinclude template="../query/get_it_assets.cfm">
<cfelse>
	<cfset get_asset_it.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_asset_it.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.list_asset_it">
<cf_big_list_search title="#getLang('assetcare',3)#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><input type="hidden" name="form_submitted" id="form_submitted" value="1"></td>
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:100px">
					&nbsp;<cf_get_lang_main no='41.Şube'>
					<input type="hidden" maxlength="50" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
					<input type="text" maxlength="50" name="branch" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>" style="width:130px;"> 
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_asset.branch&field_branch_id=search_asset.branch_id','list','popup_list_branches')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='48.Filtre'>"></a>
					&nbsp;<cf_get_lang_main no='160.Departman'>
					<input type="hidden" maxlength="50" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
					<input type="text" maxlength="50" name="department" id="department" value="<cfoutput>#attributes.department#</cfoutput>" style="width:130px;">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=search_asset.department_id&field_dep_branch_name=search_asset.department','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='160.Departman'>"></a>&nbsp;
					<select name="is_active" id="is_active" style="width:50px;">
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
						<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
					</select>
				</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
				</td>
				<td>
					<cf_wrk_search_button search_function='kontrol()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</td>
			</tr>
		</table>
	</cf_big_list_search_area>	
	<cf_big_list_search_detail_area>
		<table>				
			<tr>
				<td>
					&nbsp;<cf_get_lang no='517.Varlık Tipi'>
					<cf_wrkassetcat moduleName="assetcare" Lang="517.Varlık Tipi" compenent_name="GetAssetCat3" assetp_catid="#attributes.assetp_catid#" onchange_action="get_assetp_sub_cat();">
					&nbsp;<cf_get_lang no='5.Varlık Alt Kategorisi'>
					<cfif len(attributes.assetp_catid)>
						<cfquery name="GET_SUB_CAT" datasource="#dsn#">
							SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #attributes.assetp_catid#
						</cfquery>
					</cfif>
					<select name="assetp_sub_catid" id="assetp_sub_catid" style="width:110px;">
						<option value=""></option>
						<cfif len(attributes.assetp_sub_catid)>
							<cfoutput query="GET_SUB_CAT">
								<option value="#ASSETP_SUB_CATID#" <cfif  GET_SUB_CAT.ASSETP_SUB_CATID eq attributes.assetp_sub_catid> selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
							</cfoutput>
						</cfif>
					</select>
                    &nbsp;<cf_get_lang no='192.Mülkiyet Tipi'>
					<select name="property" id="property" style="width:105px">
					<option value=""></option>
						<option value="1" <cfif attributes.property eq 1> selected</cfif>><cf_get_lang_main no='37.Satın Alma'></option>
						<option value="2" <cfif attributes.property eq 2> selected</cfif>><cf_get_lang no='194.Kiralama'></option>
						<option value="3" <cfif attributes.property eq 3> selected</cfif>><cf_get_lang no='195.Leasing'></option>
						<option value="4" <cfif attributes.property eq 4> selected</cfif>><cf_get_lang no='196.Sözleşmeli'></option>						
					</select>
					&nbsp;<cf_get_lang_main no='132.Sorumlu'>
					<input type="hidden" maxlength="50" name="emp_id" id="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">      
					<input type="text" maxlength="50" name="employee_name" id="employee_name" value="<cfoutput>#attributes.employee_name#</cfoutput>" style="width:125px;" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','135');" />
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.emp_id&field_name=search_asset.employee_name&select_list=1&branch_related','list','popup_list_positions')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>"></a>					
					&nbsp;<cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'>
						<cf_wrkbrandtypecat
								returninputvalue="brand_name,brand_type_cat_id"
								returnqueryvalue="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_CAT_ID"
								brand_type_cat_id="#attributes.brand_type_cat_id#"
								width="105"
								compenent_name="getBrandTypeCat3"               
								boxwidth="200"
								boxheight="200"
								is_type_cat_id="1">                      
					&nbsp;<cf_get_lang_main no='813.Model'>
					<select name="make_year" id="make_year" style="width:55px;">
                        <option value=""></option>
                        <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                        <cfoutput>
                            <cfloop from="#yil#" to="1970" index="i" step="-1">
                                <option value="#i#" <cfif i eq attributes.make_year> selected</cfif>>#i#</option>
                            </cfloop>
                        </cfoutput>
					</select>&nbsp;&nbsp;
					<cf_get_lang no ='645.Ortak Kullanım'>
					<input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1" <cfif attributes.is_collective_usage eq 1>checked</cfif>>
				</td>
			</tr>
		</table>
	</cf_big_list_search_detail_area>
</cf_big_list_search> 
</cfform> 
<cf_big_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang_main no='1165. Sıra'></th>
				<th><cf_get_lang_main no='1655.Varlık'></th>
				<th><cf_get_lang_main no='221.Barkod'></th>
				<th width="100"><cf_get_lang no='517.Varlık Tipi'></th>
                <th><cf_get_lang no='5.Varlık alt kategori'></th>
				<th width="125"><cf_get_lang_main no='2234.Lokasyon'></th>
				<th width="130"><cf_get_lang_main no='132.Sorumlu'> 1</th>
				<th width="125"><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></th>
				<th width="65"><cf_get_lang no='143.Mülkiyet'></th>
				<th width="65"><cf_get_lang_main no='344.Durum'></th>
				<th width="65"><cf_get_lang_main no='70.Asama'></th>
				<!-- sil -->
				<th class="header_icn_none" nowrap="nowrap"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_asset_it&event=add"><img src="/images/plus_list.gif" alt=""  title="<cf_get_lang_main no='170.Ekle'>"></a></th>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif get_asset_it.recordcount>
			<cfset emp_id_list=''>
			<cfset state_list=''>
			<cfset brand_type_cat_id_list=''>
			<cfoutput query="get_asset_it" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(employee_id) and not listfind(emp_id_list,employee_id)>
					<cfset emp_id_list = Listappend(emp_id_list,employee_id)>
				</cfif>
				<cfif len(assetp_status) and not listfind(state_list,assetp_status)>
					<cfset state_list = Listappend(state_list,assetp_status)>
				</cfif>
				<cfif len(brand_type_cat_id) and not listfind(brand_type_cat_id_list,brand_type_cat_id)>
					<cfset brand_type_cat_id_list = Listappend(brand_type_cat_id_list,brand_type_cat_id)>
				</cfif>	
			</cfoutput>
			<cfif len(state_list)>
				<cfset state_list=listsort(state_list,"numeric","ASC",",")>			
				<cfquery name="GET_STATE" datasource="#DSN#">
					SELECT ASSET_STATE_ID,ASSET_STATE FROM ASSET_STATE WHERE ASSET_STATE_ID IN (#state_list#) ORDER BY ASSET_STATE_ID
				</cfquery>
				<cfset main_state_list = listsort(listdeleteduplicates(valuelist(GET_STATE.ASSET_STATE_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(emp_id_list)>
				<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
				<cfquery name="GET_POSITION" datasource="#DSN#">
					SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IN (#emp_id_list#) AND IS_MASTER = 1 ORDER BY EMPLOYEE_ID
				</cfquery>		
				<cfset emp_id_list = listsort(valuelist(GET_POSITION.EMPLOYEE_ID,','),'numeric','ASC',',')>		
			</cfif>
			<cfif len(brand_type_cat_id_list)>
				<cfset brand_type_cat_id_list=listsort(brand_type_cat_id_list,"numeric","ASC",",")>
				<cfquery name="GET_BRAND" datasource="#DSN#">
					SELECT
						SETUP_BRAND.BRAND_NAME,
						SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID,
						SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
						SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME
					FROM
						SETUP_BRAND,
						SETUP_BRAND_TYPE,
						SETUP_BRAND_TYPE_CAT
					WHERE
						SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID IN (#brand_type_cat_id_list#) AND
						SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND
						SETUP_BRAND.BRAND_ID = SETUP_BRAND_TYPE.BRAND_ID
					ORDER BY
						SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID
				</cfquery>
				<cfset brand_type_cat_id_list = listsort(listdeleteduplicates(valuelist(GET_BRAND.BRAND_TYPE_CAT_ID,',')),'numeric','ASC',',')>	
			</cfif>
			<cfoutput query="get_asset_it" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#currentrow#</td>
				<td><a href="#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#assetp_id#" class="tableyazi">#assetp#</a></td>
				<td>#barcode#</td>
				<td>#assetp_cat#</td>
                <td>#assetp_sub_cat#</td>
				<td>#branch_name# / #department_head#</td>
				<td><cfif len(employee_id)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position.employee_id[listfind(emp_id_list,get_asset_it.employee_id,',')]#','medium');">#get_position.employee_name[listfind(emp_id_list,employee_id,',')]#&nbsp;#get_position.employee_surname[listfind(emp_id_list,get_asset_it.employee_id,',')]#</a></cfif></td>
				<td>#get_brand.brand_name[listfind(brand_type_cat_id_list,get_asset_it.brand_type_cat_id,',')]# - #get_brand.brand_type_name[listfind(brand_type_cat_id_list,get_asset_it.brand_type_cat_id,',')]# - #get_brand.brand_type_cat_name[listfind(brand_type_cat_id_list,get_asset_it.brand_type_cat_id,',')]#</td>
				<td><cfswitch expression="#property#">
						<cfcase value="1"><cf_get_lang_main no='37.Satın Alma'></cfcase>
						<cfcase value="2"><cf_get_lang no='194.Kiralama'></cfcase>
						<cfcase value="3"><cf_get_lang no='195.Leasing'></cfcase>
						<cfcase value="4"><cf_get_lang no='196.Sözleşmeli'></cfcase>
					</cfswitch>
				</td>
				<td><cfif len(assetp_status)>#get_state.asset_state[listfind(main_state_list,get_asset_it.assetp_status,',')]#</cfif></td>
				<td><cfif status><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif></td>
				<!-- sil -->	
				<td><a href="#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#assetp_id#"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>" alt=""></a></td>
				<!-- sil -->
			</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="11"><cfif len(attributes.form_submitted)><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
				</tr>
			</cfif>
		</tbody>
</cf_big_list>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.assetp_catid)>
	<cfset url_str = "#url_str#&assetp_catid=#attributes.assetp_catid#">
</cfif>	
<cfif len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif len(attributes.branch)>
	<cfset url_str = "#url_str#&branch=#attributes.branch#">
</cfif>
<cfif len(attributes.department_id)>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
</cfif>
<cfif len(attributes.department)>
	<cfset url_str = "#url_str#&department=#attributes.department#">
</cfif>
<cfif len(attributes.emp_id)>
	<cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
</cfif>
<cfif len(attributes.employee_name)>
	<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
</cfif>		
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif len(attributes.is_active)>
	<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
</cfif>
<cfif len(attributes.brand_type_cat_id)>
	<cfset url_str = "#url_str#&brand_type_cat_id=#attributes.brand_type_cat_id#">
</cfif>
<cfif len(attributes.brand_name)>
	<cfset url_str = "#url_str#&brand_name=#attributes.brand_name#">
</cfif>
<cfif len(attributes.make_year)>
	<cfset url_str = "#url_str#&make_year=#attributes.make_year#">
</cfif>
<cfif len(attributes.property)>
	<cfset url_str = "#url_str#&property=#attributes.property#">
</cfif>
<cfif len(attributes.is_collective_usage)>
	<cfset url_str = "#url_str#&is_collective_usage=#attributes.is_collective_usage#">
</cfif>
<cfif len(attributes.assetp_sub_catid)>
	<cfset url_str="#url_str#&assetp_sub_catid=#attributes.assetp_sub_catid#">
</cfif>
<cf_paging
	page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="assetcare.list_asset_it#url_str#">
<script type="text/javascript">	
document.getElementById('keyword').focus();
function kontrol()
{
	if(document.search_asset.branch.value == "")
		document.search_asset.branch_id.value = "";
		
	if(document.getElementById("employee_name").value == "")
		document.getElementById("emp_id").value = "";
		
	if(document.search_asset.department.value == "")
		document.search_asset.department_id.value = "";
		
	if(document.search_asset.brand_name.value == "")
		document.search_asset.brand_type_cat_id.value = "";
	return true;		
}
function get_assetp_sub_cat()
{
	for (i=document.getElementById("assetp_sub_catid").options.length-1;i>-1;i--)
	{
		document.getElementById("assetp_sub_catid").options.remove(i);
	}	

	var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " + document.getElementById("assetp_catid").value+" ORDER BY ASSETP_SUB_CAT","dsn");

	if(get_assetp_sub_cat.recordcount > 0)
	{
		document.getElementById("assetp_sub_catid").options.add(new Option('Seçiniz ', ''));
		for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
		{
			document.getElementById("assetp_sub_catid").options.add(new Option(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1], get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]));
		}
	}
}
</script>
