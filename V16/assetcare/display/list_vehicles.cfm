
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.assetp_catid" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.is_collective_usage" default="">
<cfparam name="attributes.assetp" default="">
<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.brand_type_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.make_year" default="">
<cfparam name="attributes.property" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.assetp_sub_catid" default="">
<cfparam name="attributes.sup_company_id" default="">
<cfparam name="attributes.sup_comp_name" default="">
<cfparam name="attributes.sup_partner_id" default="">
<cfparam name="attributes.sup_consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_POSITION_CATS_" datasource="#dsn#">
	SELECT
		POSITION_CAT_ID,
		POSITION_CAT 
    FROM 
		SETUP_POSITION_CAT 
	WHERE 
		POSITION_CAT_STATUS = 1 
	ORDER BY 
		POSITION_CAT
</cfquery>
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
    SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_vehicles.cfm">
<cfelse>
	<cfset get_vehicles.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_vehicles.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-xs-12">
	<cf_box>
		<!-- sil -->
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.list_vehicles">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="1">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group" id="item-sup_company_id">				
					<div class="input-group">
						<cfoutput>
							<cfinput type="hidden" name="sup_company_id" id="sup_company_id" value="#attributes.sup_company_id#">
							<cfinput type="hidden" name="sup_partner_id" id="sup_partner_id" value="#attributes.sup_partner_id#">
							<cfinput type="hidden" name="sup_consumer_id" id="sup_consumer_id" value="#attributes.sup_consumer_id#">
							<cfinput type="text" name="sup_comp_name" id="sup_comp_name" value="#attributes.sup_comp_name#"  placeholder="#getLang(21,'Alınan Şirket',47892)#" onfocus="AutoComplete_Create('sup_comp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','1','COMPANY_ID,MEMBER_NAME,PARTNER_ID,MEMBER_PARTNER_NAME','sup_company_id,sup_comp_name,sup_partner_id,sup_partner_name','','3','170');">
						</cfoutput>
						<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_partner=search_asset.sup_partner_id&field_comp_name=search_asset.sup_comp_name&field_comp_id=search_asset.sup_company_id&field_consumer=search_asset.sup_consumer_id&select_list=2,3');"></span>
					</div>
				</div>
				<div class="form-group" id="item-company">
					<select name="company_id" id="company_id">
						<option value=""><cf_get_lang dictionary_id = "57574.Şirket"></option>							
						<cfoutput query="GET_OUR_COMPANY">
							<option value="#comp_id#" <cfif attributes.company_id eq comp_id>selected</cfif>>#company_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-branch">
					<div class="input-group large">
						<cfinput type="hidden" name="branch_id" id="branch_id" maxlength="50" value="#attributes.branch_id#"> 
						<cfinput type="text" name="branch" id="branch" maxlength="50" value="#attributes.branch#"  placeholder="#getLang(41,'Şube',57453)#"> 
						<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_asset.branch&field_branch_id=search_asset.branch_id','','ui-draggable-box-medium')"></span>
					</div>
				</div>							
				<div class="form-group" id="item-department">
					<div class="input-group large">
						<cfinput type="hidden" maxlength="50" name="department_id" id="department_id" value="#attributes.department_id#">
						<cfinput type="text" maxlength="50" name="department" id="department" value="#attributes.department#" placeholder="#getLang(160,'Departman',57572)#" >
						<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=search_asset.department_id&field_dep_branch_name=search_asset.department','','ui-draggable-box-small');"></span>
					</div>
				</div>
				<div class="form-group" id="item-assetp">
					<div class="input-group">
						<cfinput type="hidden" maxlength="50" name="assetp_id" id="assetp_id" value="#attributes.assetp_id#">
						<cfinput type="text" maxlength="50" name="assetp" id="assetp" value="#attributes.assetp#" placeholder="#getLang(1656,'Plaka',29453)#">  
						<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=search_asset.assetp_id&field_name=search_asset.assetp');"></span>
					</div>
				</div>
				<div class="form-group" id="item-is_active">
					<select name="is_active" id="is_active" >
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group small" id="item-maxrows">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)">				
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='kontrol()' button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-assetcare">
						<label class="col col-12"><cf_get_lang dictionary_id='47973.Araç Tipi'></label>
						<div class="col col-12">
							<cf_wrkassetcat moduleName="assetcare" Lang_main="322.Seciniz" it_asset="0" is_motorized="1" compenent_name="GetAssetCat1" assetp_catid="#attributes.assetp_catid#" onchange_action="get_assetp_sub_cat();">
						</div>
					</div>
					<div class="form-group" id="item-assetp_sub_catid">
						<label class="col col-12"><cf_get_lang dictionary_id='47881.Araç Alt Kategorisi'></label>
						<div class="col col-12">
							<cfif len(attributes.assetp_catid)>
								<cfquery name="GET_SUB_CAT" datasource="#dsn#">
									SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #attributes.assetp_catid#
								</cfquery>
							</cfif>
							<select name="assetp_sub_catid" id="assetp_sub_catid" >
								<option value=""><cf_get_lang dictionary_id='47881.Araç Alt Kategorisi'></option>
								<cfif len(attributes.assetp_sub_catid)>
									<cfoutput query="GET_SUB_CAT">
										<option value="#ASSETP_SUB_CATID#" <cfif  GET_SUB_CAT.ASSETP_SUB_CATID eq attributes.assetp_sub_catid> selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-property">
						<label class="col col-12"><cf_get_lang dictionary_id='48063.Mülkiyet Tipi'></label>
						<div class="col col-12">
							<select name="property" id="property">
								<option value=""><cf_get_lang dictionary_id='48063.Mülkiyet Tipi'></option>
								<option value="1" <cfif attributes.property eq 1>selected</cfif>><cf_get_lang dictionary_id='57449.Satın Alma'></option>
								<option value="2" <cfif attributes.property eq 2>selected</cfif>><cf_get_lang dictionary_id='48065.Kiralama'></option>
								<option value="3" <cfif attributes.property eq 3>selected</cfif>><cf_get_lang dictionary_id='48066.Leasing'></option>
								<option value="4" <cfif attributes.property eq 4>selected</cfif>><cf_get_lang dictionary_id='48067.Sözleşmeli'></option>						
							</select>
						</div>
					</div>
				</div>							
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-position_cat_id">
						<label class="col col-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
						<div class="col col-12">
							<select name="position_cat_id" id="position_cat_id">
								<option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></option>
								<cfoutput query="get_position_cats_">
									<option value="#position_cat_id#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-employee_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
						<div class="col col-12">
							<div class="input-group">
								<cfoutput>
								<input type="hidden" name="position_code" id="position_code" value="#attributes.position_code#" />
								<input type="hidden" name="emp_id" id="emp_id" value="#attributes.emp_id#" />
								<input type="text" name="employee_name" id="employee_name" value="#attributes.employee_name#"  onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,EMPLOYEE_ID','position_code,emp_id','','3','135','');">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=search_asset.position_code&field_name=search_asset.employee_name&field_emp_id=search_asset.emp_id</cfoutput>&select_list=1,9&branch_related')"></span>
								</cfoutput>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-is_collective_usage">
						<label class="col col-12"><cf_get_lang dictionary_id ='48516.Ortak Kullanım'></label>
						<div class="col col-12">
							<input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1" <cfif attributes.is_collective_usage eq 1>checked</cfif>>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-brand_name">
						<label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
						<div class="col col-12">
							<cf_wrkbrandtypecat	returninputvalue="brand_name,brand_type_id" returnqueryvalue="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_ID" brand_type_id="#attributes.brand_type_id#" is_type_cat_id=0 > 
						</div>
					</div>
					<div class="form-group" id="item-make_year">
						<label class="col col-12"><cf_get_lang dictionary_id='58225.Model'></label>
						<div class="col col-12">
							<select name="make_year" id="make_year" >
								<option value=""><cf_get_lang dictionary_id='58225.Model'></option>
								<cfset yil = dateformat(dateadd("yyyy",1,now()),"yyyy")>
								<cfoutput>
									<cfloop from="#yil#" to="1970" index="i" step="-1">
										<option value="#i#" <cfif i eq attributes.make_year>selected</cfif>>#i#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>		
		</cfform> 	
		<!-- sil -->
	</cf_box>	
	<cf_box title="#getLang('','Motorlu Taşıtlar',47158)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></td>
					<th><cf_get_lang dictionary_id='29453.Plaka'></th>
					<th><cf_get_lang dictionary_id='47973.Araç Tipi'></th>
					<th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
					<th><cf_get_lang dictionary_id="47881.Araç Alt Kategorisi"></th>
					<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'> 1</th>
					<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<th><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></th>
					<th><cf_get_lang dictionary_id="58225.Model"></th>
					<th><cf_get_lang dictionary_id='48014.Mülkiyet'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='57482.Asama'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_vehicles&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"/></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_vehicles.recordcount>
					<cfset brand_type_cat_id_list=''>
					<cfset position_code_list=''>
					<cfoutput query="get_vehicles" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(brand_type_cat_id) and not listfind(brand_type_cat_id_list,brand_type_cat_id)>
							<cfset brand_type_cat_id_list = Listappend(brand_type_cat_id_list,brand_type_cat_id)>
						</cfif>	
						<cfif len(position_code) and not listfind(position_code_list,position_code)>
							<cfset position_code_list = Listappend(position_code_list,position_code)>
						</cfif>
					</cfoutput>
					<cfif len(brand_type_cat_id_list)>
						<cfset brand_type_cat_id_list=listsort(brand_type_cat_id_list,"numeric","ASC",",")>
						<cfquery name="GET_BRAND" datasource="#DSN#">
							SELECT
								SETUP_BRAND.BRAND_NAME,
								SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
								SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID,
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
					<cfif len(position_code_list)>
						<cfset position_code_list=listsort(position_code_list,"numeric","ASC",",")>
						<cfquery name="get_position_name" datasource="#DSN#">
							SELECT 
								EP.POSITION_CODE,
								EP.EMPLOYEE_ID,
								EP.EMPLOYEE_NAME,
								EP.EMPLOYEE_SURNAME,
								SPC.POSITION_CAT 
							FROM 
								EMPLOYEE_POSITIONS EP,
								SETUP_POSITION_CAT SPC
							WHERE 
								SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID AND 
								EP.POSITION_CODE IN (#position_code_list#) 
							ORDER BY 
								EP.POSITION_CODE
						</cfquery>
						<cfset position_code_list = listsort(listdeleteduplicates(valuelist(get_position_name.POSITION_CODE,',')),"numeric","ASC",",")>
					</cfif>
					<cfoutput query="get_vehicles" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#assetp_id#" class="tableyazi">#assetp#</a></td>
							<td>#assetp_cat#</td>
							<td>#INVENTORY_NUMBER#</td>
							<td>#assetp_sub_cat#</td>
							<td>#branch_name#</td>
							<td><cfif len(finish_date)><font color="FF0000"><b>*</cfif><cfif len(position_code) and Len(get_position_name.employee_id[ListFind(position_code_list,position_code)])>
								<a href="javascript://" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position_name.employee_id[ListFind(position_code_list,position_code)]#');">#get_position_name.employee_name[ListFind(position_code_list,position_code)]# #get_position_name.employee_surname[ListFind(position_code_list,position_code)]#</a>
							<cfelseif Len(position_code)><!--- Pozisyon bosaltildiginda  --->
								#get_emp_info(position_code,1,1,1)#
							</cfif>
					<cfif len(finish_date)></font></b></cfif>
						</td>
						<td>#get_position_name.POSITION_CAT[ListFind(position_code_list,position_code)]#</td>
							<td><cfif len(brand_type_cat_id_list)>#get_brand.brand_name[listfind(brand_type_cat_id_list,get_vehicles.brand_type_cat_id,',')]# - #get_brand.brand_type_name[listfind(brand_type_cat_id_list,get_vehicles.brand_type_cat_id,',')]# - #get_brand.brand_type_cat_name[listfind(brand_type_cat_id_list,get_vehicles.brand_type_cat_id,',')]#</cfif></td>
							<td>#make_year#</td>
							<td><cfswitch expression="#property#">
									<cfcase value="1"><cf_get_lang dictionary_id='57449.Satın Alma'></cfcase>
									<cfcase value="2"><cf_get_lang dictionary_id='48065.Kiralama'></cfcase>
									<cfcase value="3"><cf_get_lang dictionary_id='48066.Leasing'></cfcase>
									<cfcase value="4"><cf_get_lang dictionary_id='48067.Sözleşmeli'></cfcase>
								</cfswitch>
							</td>
							<td>#asset_state#</td>
							<td><cfif status><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>	
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#assetp_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="14"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
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
		<cfif len(attributes.position_cat_id)>
			<cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
		</cfif>
		<cfif len(attributes.assetp_sub_catid)>
			<cfset url_str="#url_str#&assetp_sub_catid=#attributes.assetp_sub_catid#">
		</cfif>
		<!-- sil -->
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="assetcare.list_vehicles#url_str#">
		<!-- sil -->
	</cf_box>
</div>
<script language="JavaScript">	
	$('#keyword').focus();
	function kontrol()
	{
		if(document.search_asset.branch.value == "")
			document.search_asset.branch_id.value = "";
		
		if($('#employee_name').val()== "")
			$('#emp_id').val("");
		
		if(document.search_asset.assetp.value == "")
			document.search_asset.assetp_id.value = "";
			
		if(document.search_asset.department.value == "")
			document.search_asset.department_id.value = "";		
		
		if(document.search_asset.brand_name.value == "")
			document.search_asset.brand_type_id.value = "";
	
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
