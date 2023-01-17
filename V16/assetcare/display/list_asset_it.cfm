<cfsetting showdebugoutput="yes">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.it_assept" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.serial_number" default="">
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
<cfparam name="attributes.assetp_status" default="">
<cfparam name="attributes.asset_p_space_id" default="">
<cfparam name="attributes.asset_p_space_name" default="">
<cfparam name="attributes.sup_company_id" default="">
<cfparam name="attributes.sup_comp_name" default="">
<cfparam name="attributes.sup_partner_id" default="">
<cfparam name="attributes.sup_consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
    SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<!-- sil -->
    <cf_box scroll="0">
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.list_asset_it">
			<input type="hidden" name="form_submitted" id="item-form_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="item-form_ul_keyword">				
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
				</div>			
				<div class="form-group" id="item-form_ul_is_active">
					<select name="is_active" id="is_active">
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group" id="item-assetp_status">
					<cf_wrk_combo
						name="assetp_status"
						query_name="GET_ASSET_STATE"
						option_name="asset_state"
						option_value="asset_state_id"
						value="#attributes.assetp_status#"
						option_text="#getLang('main','Durum',57756)#"
						width=75>
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı!',57537)#" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class ="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-GetAssetCat3">
						<input type="hidden" name="it_assept" id="it_assept" value="1">
						<label class="col col-12"><cf_get_lang dictionary_id='48388.Varlık Tipi'></label>
						<div class="col col-12">						
							<cf_wrkassetcat moduleName="assetcare" Lang_main="322.Seciniz" it_asset="1" is_motorized="0" compenent_name="GetAssetCat3" assetp_catid="#attributes.assetp_catid#" onchange_action="get_assetp_sub_cat();">
							<cfif len(attributes.assetp_catid)>
								<cfquery name="GET_SUB_CAT" datasource="#dsn#">
									SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #attributes.assetp_catid#
								</cfquery>						
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item_assetp_space_id">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60386.Bulunduğu Yer">/<cf_get_lang dictionary_id="60371.Mekan"></label>
						<div class="col col-12 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="asset_p_space_id" id="asset_p_space_id" value="<cfoutput>#attributes.asset_p_space_id#</cfoutput>"> 
								<input type="text" name="asset_p_space_name" id="asset_p_space_name" value="<cfoutput>#attributes.asset_p_space_name#</cfoutput>" onFocus="AutoComplete_Create('asset_p_space_name','SPACE_NAME','SPACE_NAME','get_assetp_space','3','ASSET_P_SPACE_ID','asset_p_space_id','','3','135')">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_assetp_space&field_name=asset_p_space_name&field_id=asset_p_space_id</cfoutput>','','ui-draggable-box-small');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-form_ul_employee_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" maxlength="50" name="emp_id" id="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">      
								<input type="text" maxlength="50" name="employee_name" id="employee_name" value="<cfoutput>#attributes.employee_name#</cfoutput>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','135');" />
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.emp_id&field_name=search_asset.employee_name&select_list=1&branch_related')"></span>			
							</div>
						</div>
					</div>
					<div class="form-group" id="item-form_ul_brand_type_cat_id">
						<label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
						<div class="col col-12">
							<cf_wrkbrandtypecat returninputvalue="brand_name,brand_type_cat_id" returnqueryvalue="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_CAT_ID" brand_type_cat_id="#attributes.brand_type_cat_id#" width="100" compenent_name="getBrandTypeCat3" boxwidth="235" boxheight="200" is_type_cat_id="1">
						</div>
					</div>			
				</div>
				<div class ="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-assetp_sub_catid">
						<label class="col col-12"><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></label>										
						<div class="col col-12">													
							<select name="assetp_sub_catid" id="assetp_sub_catid">
								<option value=""><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></option>
								<cfif len(attributes.assetp_sub_catid)>
									<cfoutput query="GET_SUB_CAT">
										<option value="#ASSETP_SUB_CATID#" <cfif  GET_SUB_CAT.ASSETP_SUB_CATID eq attributes.assetp_sub_catid> selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-form_ul_branch_id">
						<label class="col col-12">
							<cf_get_lang dictionary_id='57453.Şube'>
						</label>
						<div class="col col-12">
							<div class="input-group">						
								<input type="hidden" maxlength="50" name="branch_id" id="branch_id" placeholder="Şube" value="<cfoutput>#attributes.branch_id#</cfoutput>"> 
								<input type="text" maxlength="50" name="branch" id="branch" value="<cfoutput>#attributes.branch#</cfoutput>"> 
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_asset.branch&field_branch_id=search_asset.branch_id')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-form_ul_make_year">
						<label class="col col-12"><cf_get_lang dictionary_id='58225.Model'></label>
						<div class="col col-12">
							<select name="make_year" id="make_year">
								<option value=""><cf_get_lang dictionary_id='58225.Model'></option>
								<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
								<cfoutput>
									<cfloop from="#yil#" to="1970" index="i" step="-1">
										<option value="#i#" <cfif i eq attributes.make_year> selected</cfif>>#i#</option>
									</cfloop>
								</cfoutput>
							</select>					
						</div>
					</div>			
				</div>
				<div class ="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-form_ul_property">
						<label class="col col-12"><cf_get_lang dictionary_id='48063.Mülkiyet Tipi'></label>
						<div class="col col-12">
							<select name="property" id="property">
								<option value=""><cf_get_lang dictionary_id='48063.Mülkiyet Tipi'></option>
								<option value="1" <cfif attributes.property eq 1> selected</cfif>><cf_get_lang dictionary_id='57449.Satın Alma'></option>
								<option value="2" <cfif attributes.property eq 2> selected</cfif>><cf_get_lang dictionary_id='48065.Kiralama'></option>
								<option value="3" <cfif attributes.property eq 3> selected</cfif>><cf_get_lang dictionary_id='48066.Leasing'></option>
								<option value="4" <cfif attributes.property eq 4> selected</cfif>><cf_get_lang dictionary_id='48067.Sözleşmeli'></option>						
							</select>						
						</div>
					</div>

					<div class="form-group" id="item-form_ul_department_id">
						<label class="col col-12">
							<cf_get_lang dictionary_id='57572.Departman'>
						</label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" maxlength="50" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
								<input type="text" maxlength="50" name="department" id="department" value="<cfoutput>#attributes.department#</cfoutput>">
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=search_asset.department_id&field_dep_branch_name=search_asset.department','','ui-draggable-box-small');"></span>
							</div>
						</div>					
					</div>
					<div class="form-group" id="item-sup_company_id">	
						<label class="col col-12">
							<cf_get_lang dictionary_id='47892.Alınan Şirket'>
						</label>		
						<div class="col col-12">	
							<div class="input-group">
								<cfoutput>
									<input type="hidden" name="sup_company_id" id="sup_company_id" value="#attributes.sup_company_id#">
									<input type="hidden" name="sup_partner_id" id="sup_partner_id" value="#attributes.sup_partner_id#">
									<input type="hidden" name="sup_consumer_id" id="sup_consumer_id" value="#attributes.sup_consumer_id#">
									<input type="text" name="sup_comp_name" id="sup_comp_name" value="#attributes.sup_comp_name#"   onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','170');">
								</cfoutput>
								<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_partner=search_asset.sup_partner_id&field_comp_name=search_asset.sup_comp_name&field_comp_id=search_asset.sup_company_id&field_consumer=search_asset.sup_consumer_id&select_list=2,3');"></span>
							</div>
						</div>
					</div>

								
				</div>		
				<div class ="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">	
					<div class="form-group" id="item-company">
						<label class="col col-12"><cf_get_lang dictionary_id = "57574.Şirket"></label>
						<div class="col col-12">
							<select name="company_id" id="company_id">
								<option value=""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>							
								<cfoutput query="GET_OUR_COMPANY">
									<option value="#comp_id#" <cfif attributes.company_id eq comp_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-form_ul_is_collective_usage">
						<label class="col col-12" style="display:none;">
							<cf_get_lang dictionary_id="47675.Ortak Kullanım">
						</label>&nbsp;
						<div class="col col-12">
							<cf_get_lang dictionary_id="47675.Ortak Kullanım">
							<input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1" <cfif attributes.is_collective_usage eq 1>checked</cfif>>
						</div>
					</div>	
				</div>	
			</cf_box_search_detail>
		</cfform> 
	</cf_box>
	<!-- sil -->
	<cf_box title="#getLang('','IT Varlıkları','42310')#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='29452.Varlık'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57637.Seri No'></th>
					<th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
					<th><cf_get_lang dictionary_id='48388.Varlık Tipi'></th>
					<th><cf_get_lang dictionary_id='47876.Varlık alt kategori'></th>
					<th><cf_get_lang dictionary_id='58140.İş Grubu'></th>
					<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
					<th><cf_get_lang dictionary_id="60371.Mekan"></th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'> 1</th>
					<th><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></th>
					<th><cf_get_lang dictionary_id='47893.Alış Tarihi'></th>
					<th><cf_get_lang dictionary_id='48014.Mülkiyet'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='57482.Asama'></th>
					<!-- sil -->
						<th width="20" class="header_icn_none text-center" nowrap="nowrap"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_asset_it&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>"  title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_asset_it.recordcount>
					<cfoutput query="get_asset_it" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#assetp_id#" class="tableyazi">#assetp#</a></td>
							<td>#barcode#</td>
							<td>#serial_no#</td>
							<td>#inventory_number#</td>
							<td>#assetp_cat#</td>
							<td>#assetp_sub_cat#</td>
							<td>#group_name#</td>
							<td>
								<cfset get_branchs_deps = login_act.get_branchs_deps(department_id: get_asset_it.department_id)>
								#get_branchs_deps.branch_name# / #get_branchs_deps.department_head#
							</td>
							<td>#space_code# #space_name#</td>
							<td>
								<cfif len(employee_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">
								</cfif>
								#employee_name#&nbsp;#employee_surname#
								</a>
							</td>
							<td>#brand_name# - #brand_type_name# - #brand_type_cat_name#</td>
							<td>#DateFormat(sup_company_date,dateformat_style)#</td>
							<td>
								<cfswitch expression="#property#">
									<cfcase value="1"><cf_get_lang dictionary_id='57449.Satın Alma'></cfcase>
									<cfcase value="2"><cf_get_lang dictionary_id='48065.Kiralama'></cfcase>
									<cfcase value="3"><cf_get_lang dictionary_id='48066.Leasing'></cfcase>
									<cfcase value="4"><cf_get_lang dictionary_id='48067.Sözleşmeli'></cfcase>
								</cfswitch>
							</td>
							<td>#asset_state#</td>
							<td><cfif status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<!-- sil -->
								<td><a href="#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#assetp_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					
					<tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="17"><cfif len(attributes.form_submitted)><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

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
		<cfif isdefined("attributes.it_assept") and len(attributes.it_assept)>
			<cfset url_str = "#url_str#&it_assept=#attributes.it_assept#">
		</cfif>
		<cfif len(attributes.is_active)>
			<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
		</cfif>

		<cfif isdefined(attributes.assetp_status)>
			<cfset url_str = "#url_str#&assetp_status=#attributes.assetp_status#">
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
		<cfif len(attributes.asset_p_space_id)>
			<cfset url_str = "#url_str#&keyword=#attributes.asset_p_space_id#">
		</cfif>
		<!-- sil -->
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="assetcare.list_asset_it#url_str#">
		<!-- sil -->
	</cf_box>
</div>
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
	for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--)
		{
				$('#assetp_sub_catid option').eq(i).remove();
		}
	var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " + $("#assetp_catid").val()+" ORDER BY ASSETP_SUB_CAT","dsn");
	if(get_assetp_sub_cat.recordcount > 0)	
		
	{
		var selectBox = $("#assetp_sub_catid").attr('disabled');
		if(selectBox) $("#assetp_sub_catid").removeAttr('disabled');
		$("#assetp_sub_catid").append($("<option></option>").attr("value", '').text( "Seçiniz !" ));
			for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
			{
				$("#assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));
			}
	}
	else{
			
		$("#assetp_sub_catid").attr('disabled','disabled');
		
	}
}

</script>
