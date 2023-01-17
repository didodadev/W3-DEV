<cfsetting showdebugoutput="yes">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.record_employee_name" default="">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.record_employee_id" default="">
<cfparam name="attributes.stock_status" default="1">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.is_main_spec" default="3">
<cfif isdefined("attributes.is_submit")>
	<cfscript>
        get_tree_action = createObject("component", "V16.production_plan.cfc.get_tree");
        get_tree_action.dsn3 = dsn3;
        get_tree = get_tree_action.get_tree_fnc(
			keyword : '#IIf(IsDefined("keyword"),"keyword",DE(""))#',
			cat : '#IIf(IsDefined("attributes.cat"),"attributes.cat",DE(""))#',
			record_employee_id : '#IIf(IsDefined("attributes.record_employee_id"),"attributes.record_employee_id",DE(""))#',
			record_employee_name : '#IIf(IsDefined("attributes.record_employee_name"),"attributes.record_employee_name",DE(""))#',
			brand_id : '#IIf(IsDefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
			brand_name : '#IIf(IsDefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
			product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
			product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
			is_main_spec : '#IIf(IsDefined("attributes.is_main_spec"),"attributes.is_main_spec",DE(""))#',
			product_employee_id : '#IIf(IsDefined("attributes.product_employee_id"),"attributes.product_employee_id",DE(""))#',
			employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
			stock_status : '#IIf(IsDefined("attributes.stock_status"),"attributes.stock_status",DE(""))#'
		);
	</cfscript>
<cfelse>
	<cfset get_tree.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_tree.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	url_str='';
	if(len(attributes.employee_name)) url_str = '#url_str#&employee_name=#attributes.employee_name#';
	if(len(attributes.record_employee_name)) url_str = '#url_str#&record_employee_name=#attributes.record_employee_name#';
	if(len(attributes.product_employee_id)) url_str = '#url_str#&product_employee_id=#attributes.product_employee_id#';
	if(len(attributes.product_employee_id)) url_str = '#url_str#&product_employee_id=#attributes.product_employee_id#';
	if(len(attributes.record_employee_id)) url_str = '#url_str#&record_employee_id=#attributes.record_employee_id#';
	if(len(attributes.stock_status)) url_str = '#url_str#&stock_status=#attributes.stock_status#';
	if(len(attributes.brand_id)) url_str = '#url_str#&brand_id=#attributes.brand_id#';
	if(len(attributes.brand_name)) url_str = '#url_str#&brand_name=#attributes.brand_name#';
	if(len(attributes.keyword)) url_str = '#url_str#&keyword=#attributes.keyword#';
	if(len(attributes.cat)) url_str = '#url_str#&cat=#attributes.cat#';
	if(len(attributes.is_main_spec)) url_str = '#url_str#&is_main_spec=#attributes.is_main_spec#';
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=prod.list_product_tree" method="post" name="get_prod">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
				</div>
				<div class="form-group">
					<cfinclude template="../query/get_product_cat.cfm">
					<select name="cat" id="cat" >
						<option value=""><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></option>
						<cfoutput query="get_product_cat">
							<option value="#hierarchy#"<cfif attributes.cat eq hierarchy and len(attributes.cat) eq len(hierarchy)>selected</cfif>>#hierarchy#-#product_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="stock_status" id="stock_status" >
						<option value="" <cfif attributes.stock_status eq ''>selected</cfif>><cf_get_lang dictionary_id ='57708.Tümü'></option>
						<option value="1" <cfif attributes.stock_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
						<option value="0" <cfif attributes.stock_status eq 0>selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="is_main_spec" id="is_main_spec">
						<option value="1" <cfif attributes.is_main_spec eq 1>selected</cfif>><cf_get_lang dictionary_id='36833.Main Spec Olan Ürünler'></option>
						<option value="2" <cfif attributes.is_main_spec eq 2>selected</cfif>><cf_get_lang dictionary_id='30112.Main Spec Olmayan Ürünler'></option>
						<option value="3" <cfif attributes.is_main_spec eq 3>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" >
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<cfoutput>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-responsible">
							<label><cf_get_lang dictionary_id='57544.Sorumlu'></label>
							<div class="input-group">
								<input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name) and len(attributes.product_employee_id)>#attributes.product_employee_id#</cfif>">
								<input type="text" name="employee_name" id="employee_name" value="<cfif len(attributes.employee_name)>#attributes.employee_name#</cfif>" maxlength="50">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&field_code=get_prod.product_employee_id&field_name=get_prod.employee_name&select_list=1&keyword='+encodeURIComponent(document.getElementById('employee_name').value)+'','list');"></span>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-record">
							<label><cf_get_lang dictionary_id='57899.Kaydeden'></label>
							<div class="input-group">
								<input type="hidden" name="record_employee_id" id="record_employee_id"  value="<cfif len(attributes.record_employee_name) and len(attributes.record_employee_id)>#attributes.record_employee_id#</cfif>">
								<input type="text" name="record_employee_name" id="record_employee_name" value="<cfif len(attributes.record_employee_name)>#attributes.record_employee_name#</cfif>" maxlength="50">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&field_emp_id=get_prod.record_employee_id&field_name=get_prod.record_employee_name&select_list=1&keyword='+encodeURIComponent(document.getElementById('record_employee_name').value)+'','list');"></span>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-brand">
							<label><cf_get_lang dictionary_id='58847.Marka'></label>
							<div class="input-group">
								<input type="hidden" name="brand_id" id="brand_id" value="<cfif len(attributes.brand_name)>#attributes.brand_id#</cfif>">
								<input type="text" name="brand_name" id="brand_name"  value="<cfif len(attributes.brand_name)>#attributes.brand_name#</cfif>" maxlength="50">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=get_prod.brand_id&brand_name=get_prod.brand_name&keyword='+encodeURIComponent(document.getElementById('brand_name').value)</cfoutput>,'small');"></span>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group" id="item-product">
							<label><cf_get_lang dictionary_id='57657.Ürün'></label>
							<div class="input-group">
								<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name)>#attributes.product_id#</cfif>">
								<input type="text" name="product_name" id="product_name" value="<cfif len(attributes.product_name)>#attributes.product_name#</cfif>" maxlength="50">
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=get_prod.product_id&field_name=get_prod.product_name&keyword='+encodeURIComponent(document.getElementById('product_name').value),'list');"></span>
							</div>
						</div>
					</div>
				</cfoutput>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='36320.Ağaçlar'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id="45182.Main Spec"></th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='58847.Marka'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<!-- sil --><th class="header_icn_none" width="20"><a href="javascript://"><i class="fa fa-pencil"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_tree.RECORDCOUNT >
					<cfset product_manager_list = ''>
					<cfset record_emp_list = ''>
					<cfset brand_list = ''>
					<cfoutput query="get_tree" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(PRODUCT_MANAGER) and not listfind(product_manager_list,PRODUCT_MANAGER)>
							<cfset product_manager_list = ListAppend(product_manager_list,PRODUCT_MANAGER)>
						</cfif>
						<cfif len(RECORD_EMP) and not listfind(record_emp_list,RECORD_EMP)>
							<cfset record_emp_list = ListAppend(record_emp_list,RECORD_EMP)>
						</cfif>
						<cfif len(BRAND_ID) and not listfind(brand_list,BRAND_ID)>
							<cfset brand_list = ListAppend(brand_list,BRAND_ID)>
						</cfif>
					</cfoutput>
					<cfif len(product_manager_list)>
						<cfset product_manager_list=listsort(product_manager_list,"numeric","ASC",",")>
						<cfquery name="GET_POSITIONS" datasource="#dsn#">
							SELECT
								EMPLOYEE_NAME,
								EMPLOYEE_SURNAME,
								EMPLOYEE_ID,
								POSITION_CODE
							FROM
								EMPLOYEE_POSITIONS
							WHERE
								POSITION_CODE IN (#product_manager_list#)
							ORDER BY
								POSITION_CODE
						</cfquery>
						<cfset product_manager_list = listsort(listdeleteduplicates(valuelist(GET_POSITIONS.POSITION_CODE,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(record_emp_list)>
						<cfset record_emp_list=listsort(record_emp_list,"numeric","ASC",",")>
						<cfquery name="GET_EMP" datasource="#dsn#">
							SELECT
								EMPLOYEE_NAME,
								EMPLOYEE_SURNAME,
								EMPLOYEE_ID
							FROM
								EMPLOYEES
							WHERE
								EMPLOYEE_ID IN (#record_emp_list#)
							ORDER BY
								EMPLOYEE_ID
						</cfquery>
						<cfset record_emp_list = listsort(listdeleteduplicates(valuelist(GET_EMP.EMPLOYEE_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfif len(brand_list)>
						<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
						<cfquery name="GET_BRAND" datasource="#dsn3#">
							SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#) ORDER BY BRAND_ID
						</cfquery> 
						<cfset brand_list = listsort(listdeleteduplicates(valuelist(GET_BRAND.BRAND_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_tree" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td class="text-center" width="35">#currentrow#</td>
							<td><a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#STOCK_ID#" class="tableyazi">#STOCK_CODE#</a></td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#&sid=#STOCK_ID#','list');" class="tableyazi"> #BARCOD# </a> </td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#&sid=#STOCK_ID#','list');" class="tableyazi"> #PRODUCT_NAME#<cfif trim(PROPERTY) neq "-" >-#PROPERTY#</cfif></a></td>
							<td>#main_spec#</td>
							<td>
							<cfif len(PRODUCT_MANAGER)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_POSITIONS.EMPLOYEE_ID[listfind(product_manager_list,get_tree.PRODUCT_MANAGER,',')]#','medium');" class="tableyazi">
								#GET_POSITIONS.EMPLOYEE_NAME[listfind(product_manager_list,get_tree.PRODUCT_MANAGER,',')]#&nbsp;#GET_POSITIONS.EMPLOYEE_SURNAME[listfind(product_manager_list,get_tree.PRODUCT_MANAGER,',')]#
								</a>                   
							</cfif>
							</td>
							<td>
							<cfif len(RECORD_EMP)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_EMP.EMPLOYEE_ID[listfind(record_emp_list,get_tree.RECORD_EMP,',')]#','medium');" class="tableyazi">
								#GET_EMP.EMPLOYEE_NAME[listfind(record_emp_list,get_tree.RECORD_EMP,',')]#&nbsp;#GET_EMP.EMPLOYEE_SURNAME[listfind(record_emp_list,get_tree.RECORD_EMP,',')]#
								</a>                   
							</cfif>
							</td>
							<td>
							<cfif len(BRAND_ID)>
								#GET_BRAND.BRAND_NAME[listfind(brand_list,get_tree.BRAND_ID,',')]#
							</cfif>
							</td>
							<td><cfif STOCK_STATUS eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<!-- sil --><td><a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#STOCK_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="11"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></td></cfif>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif isdefined ("attributes.is_submit") and len(attributes.is_submit)>
			<cfset url_str='#url_str#&is_submit=#attributes.is_submit#'>
		</cfif>
		<cf_paging PAGE="#attributes.page#" 
			MAXROWS="#attributes.maxrows#" 
			TOTALRECORDS="#attributes.totalrecords#" 
			STARTROW="#attributes.startrow#" 
			ADRES="prod.list_product_tree&#url_str#">
	</cf_box> 
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
