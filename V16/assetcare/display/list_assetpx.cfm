<cf_xml_page_edit fuseact="assetcare.list_assetp">
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
<cfparam name="attributes.brand_type_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.make_year" default="">
<cfparam name="attributes.property" default="">
<cfparam name="attributes.position2" default="">
<cfparam name="attributes.position_code2" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.assetp_status" default="">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.assetp_sub_catid" default="">
<cfparam name="attributes.inventory_no" default="">
<cfset colspan = 11>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_assetps1.cfm">
	<cfparam name="attributes.totalrecords" default='#get_assetps.query_count#'>
<cfelse>
	<cfset get_assetps.recordcount = 0>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>

<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.list_assetp">
<cf_big_list_search title="#getLang('main',2207)#"> 
	<cf_big_list_search_area>
		<table>		
			<tr>
				<td><input type="hidden" name="form_submitted" id="form_submitted" value="1"></td>
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:100px">
                    <cf_get_lang_main no='1466.Demirbaş No'>
                    	<input type="text" name="inventory_no" id="inventory_no" style="width:90px;" value="<cfoutput>#attributes.inventory_no#</cfoutput>" />
						&nbsp;<cf_get_lang_main no='132.Sorumlu'>
						<input type="hidden" name="emp_id" maxlength="50" id="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">      
						<input type="text" name="employee_name" maxlength="50" id="employee_name" value="<cfoutput>#attributes.employee_name#</cfoutput>" style="width:100px;" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','135');" />
						<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.emp_id&field_name=search_asset.employee_name&select_list=1&branch_related','list','popup_list_positions')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a>
						&nbsp;<cf_get_lang_main no='41.Şube'>
							<input type="hidden" name="branch_id" maxlength="50" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
							<input type="text" name="branch" maxlength="50" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>" style="width:100px;"> 
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_asset.branch&field_branch_id=search_asset.branch_id','list','popup_list_branches')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='41.Şube'>"></a>
						&nbsp;<cf_get_lang_main no='160.Departman'>
							<input type="hidden" maxlength="50" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
							<input type="text" maxlength="50" name="department" id="department" value="<cfoutput>#attributes.department#</cfoutput>" style="width:100px;">
							<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=search_asset.department_id&field_dep_branch_name=search_asset.department','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='160.Departman'>"></a>
						&nbsp;
						<select name="is_active" id="is_active" style="width:50px;">
							<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
							<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
							<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
						</select>
				</td>
                <cfif xml_show_stage eq 1>
                    <td><cf_get_lang_main no='344.durum'></td>
                    <td>
                        <cf_wrk_combo
                            name="assetp_status"
                            query_name="GET_ASSET_STATE"
                            option_name="asset_state"
                            option_value="asset_state_id"
                            value="#attributes.assetp_status#"
                            option_text=""
                            width=75>
                    </td>
                </cfif>
                <td>
                    <select id="order_type" name="order_type" style="width:100px;">
                        <option value="1" <cfif attributes.order_type eq 1>selected</cfif>><cf_get_lang no='89. Ada Göre Artan'></option>
                        <option value="2" <cfif attributes.order_type eq 2>selected</cfif>><cf_get_lang no='90. Ada Göre Azalan'></option>
                        <option value="3" <cfif attributes.order_type eq 3>selected</cfif>><cf_get_lang no='91.Varlık Tipine Göre'></option>
                        <option value="4" <cfif attributes.order_type eq 4>selected</cfif>><cf_get_lang no='103. Duruma Göre'></option>
                        <option value="5" <cfif attributes.order_type eq 5>selected</cfif>><cf_get_lang no='107. Tarihe Göre Artan'></option>
                        <option value="6" <cfif attributes.order_type eq 6>selected</cfif>><cf_get_lang no='112.Tarihe Göre Azalan'></option>
                        <option value="7" <cfif attributes.order_type eq 7>selected</cfif>><cf_get_lang no='22.Alış Tarihi'><cf_get_lang_main no='2029.Artan'></option>
                        <option value="8" <cfif attributes.order_type eq 8>selected</cfif>><cf_get_lang no='22.Alış Tarihi'><cf_get_lang_main no='2030.Azalan'></option>
                    </select>
                </td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
				</td>
				<td>
					<cf_wrk_search_button search_function='kontrol()'>
				</td>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</tr>
		</table>
	</cf_big_list_search_area>	
	<cf_big_list_search_detail_area>
		<table>				
			<tr>
				<td>
					&nbsp;<cf_get_lang no='517.Varlık Tipi'>
					<cf_wrkassetcat moduleName="assetcare" Lang="517.Varlık Tipi" compenent_name="GetAssetCat2" assetp_catid="#attributes.assetp_catid#" onchange_action="get_assetp_sub_cat();">
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
						<select name="property" id="property" style="width:110px">
                            <option value=""></option>
                            <option value="1" <cfif attributes.property eq 1>selected</cfif>><cf_get_lang_main no='37.Satın Alma'></option>
                            <option value="2" <cfif attributes.property eq 2>selected</cfif>><cf_get_lang no='194.Kiralama'></option>
                            <option value="3" <cfif attributes.property eq 3>selected</cfif>><cf_get_lang no='195.Leasing'></option>
                            <option value="4" <cfif attributes.property eq 4>selected</cfif>><cf_get_lang no='196.Sözleşmeli'></option>						
						</select>
                    <cfif xml_show_responsible eq 1>
                    &nbsp;<cf_get_lang_main no='132.Sorumlu'>2
                        <input type="hidden" maxlength="50" name="position_code2" id="position_code2" value="<cfif isdefined('attributes.member_type_2')><cfoutput>#attributes.position_code2#</cfoutput></cfif>" />
                        <input type="hidden" maxlength="50" name="member_type_2" id="member_type_2" value="<cfif isdefined('attributes.member_type_2')><cfoutput>#attributes.member_type_2#</cfoutput></cfif>" />
                        <input type="text" maxlength="50" name="position2" id="position2" value="<cfoutput><cfif isdefined('attributes.position_code2') and len(attributes.position2)><cfif len(attributes.member_type_2) and attributes.member_type_2 eq 'employee'>#get_emp_info(attributes.position_code2,0,0)#<cfelseif len(attributes.member_type_2) and attributes.member_type_2 eq 'partner'>#get_par_info(attributes.position_code2,0,0,0)#<cfelseif attributes.member_type_2 eq 'consumer'>#get_cons_info(attributes.position_code2,0,0)#</cfif></cfif></cfoutput>" onfocus="AutoComplete_Create('position2','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','position_code2,position_code2,position_code2,member_type_2','','3','225');" style="width:125px;">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_asset.position_code2&field_name=search_asset.position2&field_partner=search_asset.position_code2&field_consumer=search_asset.position_code2&field_emp_id=search_asset.position_code2&field_type=search_asset.member_type_2&select_list=1,7,8&branch_related','list','popup_list_positions')"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
                    </cfif>
					&nbsp;<cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'>
						<cf_wrkbrandtypecat
							returninputvalue="brand_name,brand_type_id"
							returnqueryvalue="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_ID"
							brand_type_id="#attributes.brand_type_id#"
							width="105"
							compenent_name="getBrandType2"               
							boxwidth="200"
							boxheight="150"
							is_type_cat_id=0> 
                    &nbsp;<cf_get_lang_main no='813.Model'>
						<select name="make_year" id="make_year" style="width:55px;">
						<option value=""></option>
					<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
						<cfoutput>
							<cfloop from="#yil#" to="1970" index="i" step="-1">
								<option value="#i#" <cfif i eq attributes.make_year>selected</cfif>>#i#</option>
							</cfloop>
						</cfoutput>
					</select>
					&nbsp;&nbsp;
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
        	<th><cf_get_lang_main no='1165.Sıra'></th>
			<th><cf_get_lang_main no='1655.Varlık'></th>
			<cfif xml_show_detail eq 1>
				<cfset ++colspan>
				<th><cf_get_lang_main no='217.Açıklama'></th>
			</cfif>
				<th><cf_get_lang_main no='221.Barkod'></th>
				<th><cf_get_lang no='517.Varlık Tipi'></th>
				<th><cf_get_lang no='5.Varlık alt kategori'></th>
				<th><cf_get_lang_main no='2234.Lokasyon'></th>
				<th><cf_get_lang_main no='132.Sorumlu'> 1</th>
			<cfif xml_show_responsible eq 1>
				<cfset ++colspan>
				<th><cf_get_lang_main no='132.Sorumlu'> 2</th>
			</cfif>
				<th><cf_get_lang_main no='1435.Marka'> / <cf_get_lang_main no='2244.Marka Tipi'></th>
				<th><cf_get_lang no='143.Mülkiyet'></th>
			<cfif xml_show_stage eq 1>
				<cfset ++colspan>	
				<th><cf_get_lang_main no='344.Durum'></th>
			</cfif>
			<th><cf_get_lang_main no='70.Asama'></th>
			<cfif xml_company_date eq 1>
				<cfset ++colspan>
				<th><cf_get_lang no='22.Alış Tarihi'></th>
			</cfif>
			<cfif xml_show_tarih eq 1>
				<cfset ++colspan>
				<th><cf_get_lang_main no='215.Tarihi'></th>
			</cfif>
            <!-- sil --><th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_assetp&event=add"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_assetps.recordcount>
			<cfset brand_type_cat_id_list=''>
			<cfoutput query="get_assetps">
				<cfif len(brand_type_cat_id) and not listfind(brand_type_cat_id_list,brand_type_cat_id)>
					<cfset brand_type_cat_id_list = Listappend(brand_type_cat_id_list,brand_type_cat_id)>
				</cfif>	
			</cfoutput>
			<cfif len(brand_type_cat_id_list)>
				<cfset brand_type_cat_id_list=listsort(brand_type_cat_id_list,"numeric","ASC",",")>
				<cfquery name="GET_BRAND" datasource="#DSN#">
					SELECT
						SETUP_BRAND.BRAND_NAME,
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
			</cfif>
			<cfoutput query="get_assetps">
				<tr>
					<td>#RowNum#</td>
                    <td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#" class="tableyazi">#assetp#</a></td>
					<cfif xml_show_detail eq 1>
					<td <cfif len(ASSETP_DETAIL) gt 50>title="#ASSETP_DETAIL#"</cfif>>#left(ASSETP_DETAIL,50)#<cfif len(ASSETP_DETAIL) gt 50>...</cfif></td>
					</cfif>
					<td>#barcode#</td>
					<td>#assetp_cat#</td>
					<td>#assetp_sub_cat#</td>
					<td>#branch_name# / #department_head#</td>
					<td><cfif len(employee_id)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#EMP_NAME#</a></cfif></td>
					<cfif xml_show_responsible eq 1>
						<td>#NAME_2#</td>
					</cfif>
					<td>
						<cfif len(brand_type_cat_id)>
						#get_brand.brand_name[listfind(brand_type_cat_id_list,get_assetps.brand_type_cat_id,',')]# - #get_brand.brand_type_name[listfind(brand_type_cat_id_list,get_assetps.brand_type_cat_id,',')]# - #get_brand.brand_type_cat_name[listfind(brand_type_cat_id_list,get_assetps.brand_type_cat_id,',')]#
						</cfif>
					</td>
					<td>
						<cfswitch expression="#property#">
							<cfcase value="1"><cf_get_lang_main no='37.Satın Alma'></cfcase>
							<cfcase value="2"><cf_get_lang no='194.Kiralama'></cfcase>
							<cfcase value="3"><cf_get_lang no='195.Leasing'></cfcase>
							<cfcase value="4"><cf_get_lang no='196.Sözleşmeli'></cfcase>
						</cfswitch>
					</td>
					<cfif xml_show_stage eq 1>
						<td>#asset_state#</td>
					</cfif>
					<td><cfif status><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif></td>
					<cfif xml_company_date eq 1>
						<td>#dateformat(sup_company_date,dateformat_style)#</td>
					</cfif>
					<cfif xml_show_tarih eq 1>
						<td>#dateformat(date,dateformat_style)#</td>
					</cfif>
                    <!-- sil --><td><a href="#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#assetp_id#"><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></a></td><!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td height="21" colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
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
<cfif len(attributes.department)>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
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
<cfif len(attributes.brand_type_id)>
	<cfset url_str = "#url_str#&brand_type_id=#attributes.brand_type_id#">
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
<cfif len(attributes.position_code2) and len(attributes.member_type_2) and len(attributes.position2)>
	<cfset url_str = "#url_str#&position_code2=#attributes.position_code2#&member_type_2=#attributes.member_type_2#&position2=#attributes.position2#">
</cfif>
<cfif len(attributes.assetp_status)>
	<cfset url_str = "#url_str#&assetp_status=#attributes.assetp_status#">
</cfif>
<cfif len(attributes.order_type)>
	<cfset url_str = "#url_str#&order_type=#attributes.order_type#">
</cfif>
<cfif len(attributes.assetp_sub_catid)>
	<cfset url_str="#url_str#&assetp_sub_catid=#attributes.assetp_sub_catid#">
</cfif>
<cf_paging
	page="#attributes.page#"
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#"
	adres="assetcare.list_assetp#url_str#">
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
		document.search_asset.brand_type_id.value = "";
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
