<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.conscat" default="">
<cfparam name="attributes.company_sector" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.citycode" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.sales_county" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.pro_rows" default="">
<cfparam name="select_list" default="7,8">
<cfparam name="is_close" default="1">
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, PLATE_CODE FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="get_conscat" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfquery name="SZ" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_customer_value" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE  FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="get_company_sector" datasource="#DSN#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<cfquery name="GET_PRO_TYPEROWS" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		<cfif not isdefined("attributes.is_sales")>
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.form_add_consumer%">
		<cfelse>
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
		</cfif>
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>

<cfif len(attributes.is_submitted)>
	<cfinclude template="../query/get_consumers_crm.cfm">
<cfelse>
	<cfset get_consumer.recordcount = 0>
</cfif>
<cfparam name='attributes.totalrecords' default='#get_consumer.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	url_str = "";
	if (isdefined("attributes.record_num_") and len(attributes.record_num_))
	url_str = "#url_str#&record_num_=#attributes.record_num_#";
	if (isdefined("attributes.is_activity") and len(attributes.is_activity))
	url_str = "#url_str#&is_activity=#attributes.is_activity#";
	if (isdefined("attributes.kontrol_startdate") and len(attributes.kontrol_startdate))
	url_str = "#url_str#&kontrol_startdate=#attributes.kontrol_startdate#";
	if (isdefined("attributes.kontrol_finishdate") and len(attributes.kontrol_finishdate))
	url_str = "#url_str#&kontrol_finishdate=#attributes.kontrol_finishdate#";
	if (isdefined("attributes.is_single") and len(attributes.is_single))
	url_str = "#url_str#&is_single=#attributes.is_single#";
	if (isdefined("attributes.field_comp_id") and len(attributes.field_comp_id))
	url_str = "#url_str#&field_comp_id=#attributes.field_comp_id#";
	if (isdefined("attributes.field_comp_name") and len(attributes.field_comp_name))
	url_str = "#url_str#&field_comp_name=#attributes.field_comp_name#";
	if (isdefined("attributes.field_id") and len(attributes.field_id))
	url_str = "#url_str#&field_id=#attributes.field_id#";
	if (isdefined("attributes.field_name") and len(attributes.field_name))
	url_str = "#url_str#&field_name=#attributes.field_name#";
	if (isdefined("attributes.is_sales") and len(attributes.is_sales))
	url_str = "#url_str#&is_sales=#attributes.is_sales#";
	if (isdefined("attributes.is_active") and len(attributes.is_active))
	url_str = "#url_str#&is_active=#attributes.is_active#";
	if (isdefined("attributes.is_close") and len(attributes.is_close))
	url_str = "#url_str#&is_close=#attributes.is_close#";
	if(isdefined("attributes.is_choose_project") and len(attributes.is_choose_project))
	url_str = "#url_str#&is_choose_project=#attributes.is_choose_project#";
	if (isdefined("attributes.companycat")) url_str = "#url_str#&companycat=#attributes.companycat#";
	if (isdefined("attributes.company_sector")) url_str = "#url_str#&company_sector=#attributes.company_sector#";
	if (isdefined("attributes.customer_value")) url_str = "#url_str#&customer_value=#attributes.customer_value#";
	if (isdefined("attributes.sales_county")) url_str = "#url_str#&sales_county=#attributes.sales_county#";
</cfscript>

<cfsavecontent variable="head_">
	<div class="ui-form-list flex-list">
		<div class="form-group">
			<cfoutput>
				<select name="categories" id="categories" onChange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
					<cfif listcontainsnocase(select_list,7)>
						<option value="#request.self#?fuseaction=objects.popup_list_multiuser_company#url_str#" <cfif fusebox.fuseaction is "popup_list_all_pars"> selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,8)>
						<option value="#request.self#?fuseaction=objects.popup_list_multiuser_company#url_str#" <cfif fusebox.fuseaction is "popup_list_multiuser_consumer">selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
					</cfif>
				</select>
			</cfoutput>
		</div>
	</div>
</cfsavecontent>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Bireysel Üyeler',29406)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_str" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_company" method="post" action="#request.self#?fuseaction=objects.popup_list_multiuser_consumer">
			<input type="hidden" name="click_count" id="click_count" value="0">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cfoutput>
				<cfif isdefined("attributes.record_num_")><input type="hidden" name="record_num_" id="record_num_" value="#attributes.record_num_#"></cfif>
				<cfif isdefined("attributes.is_activity")><input type="hidden" name="is_activity" id="is_activity" value="#attributes.is_activity#"></cfif>
				<cfif isdefined("attributes.is_single")><input type="hidden" name="is_single" id="is_single" value="#attributes.is_single#"></cfif>
				<cfif isdefined("attributes.field_comp_id")><input type="hidden" name="field_comp_id" id="field_comp_id" value="#attributes.field_comp_id#"></cfif>
				<cfif isdefined("attributes.field_comp_name")><input type="hidden" name="field_comp_name" id="field_comp_name" value="#attributes.field_comp_name#"></cfif>
				<cfif isdefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="#attributes.field_id#"></cfif>
				<cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="#attributes.field_name#"></cfif>
				<cfif isdefined("attributes.is_sales")><input type="hidden" name="is_sales" id="is_sales" value="#attributes.is_sales#"></cfif>
				<cfif isdefined("attributes.is_close")><input type="hidden" name="is_close" id="is_close" value="#attributes.is_close#"></cfif>
				<cfif isdefined("attributes.is_position")><input type="hidden" name="is_position" id="is_position" value="#attributes.is_position#"></cfif>
				<cfif isdefined("attributes.is_choose_project")><input type="hidden" name="is_choose_project" id="is_choose_project" value="#attributes.is_choose_project#"></cfif>
				<input type="hidden" name="kontrol_startdate" id="kontrol_startdate" value="<cfif isdefined("attributes.kontrol_startdate")>#attributes.kontrol_startdate#</cfif>">
				<input type="hidden" name="kontrol_finishdate" id="kontrol_finishdate" value="<cfif isdefined("attributes.kontrol_finishdate")>#attributes.kontrol_finishdate#</cfif>">
			</cfoutput> 
			<cf_box_search>
				<div class="form-group" id="fullname">
					<cfinput type="text" name="fullname" value="#attributes.fullname#" maxlength="255" style="width:75px;" placeholder="#getLang('','Ad Soyad',57570)#">
				</div> 
				<div class="form-group" id="fullname">
					<select name="company_sector" id="company_sector" tabindex="25" style="width:120px;">
						<option value=""><cf_get_lang dictionary_id='51253.Sektör Seçiniz'>               
						<cfoutput query="get_company_sector">
							<option value="#sector_cat_id#" <cfif attributes.company_sector eq sector_cat_id> selected</cfif>>#sector_cat#</option>
						</cfoutput>
					</select>
				</div> 
				<div class="form-group" id="customer_value">
					<select name="customer_value" id="customer_value" style="width:95px;">
						<option value=""><cf_get_lang dictionary_id='58552.Müşteri Değeri'></option>
						<cfoutput query="get_customer_value">
							<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value> selected</cfif>>#customer_value#</option>
						</cfoutput>
					</select>
				</div> 
				<div class="form-group" id="is_active">
					<select name="is_active" id="is_active" style="width:50px;">
						<option value="0" <cfif attributes.is_active eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="1" <cfif attributes.is_active eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					</select>
				</div> 
				<div class="form-group small" id="maxrows">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" style="width:25px;">
				</div> 
				<div class="form-group" id="button">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_company' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_company' , #attributes.modal_id#)"),DE(""))#">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-city">
						<select name="city" id="city" onChange="county_id_clear()" style="width:110px;">
							<option value=""><cf_get_lang dictionary_id='33176.İl Seçiniz'></option>
							<cfoutput query="get_city">
								<option value="#city_id#" <cfif city_id eq attributes.city> selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
					</div>  
					<div class="form-group" id="item-county">
						<div class="input-group">
							<input type="hidden" name="county_id" id="county_id" readonly="" value=<cfoutput>"#attributes.county_id#"</cfoutput>>
							<cfinput type="text" name="county" value="#attributes.county#" maxlength="30" placeholder="#getLang('','İlçe',58638)#" style="width:100px;">
							<span class="input-group-addon icon-ellipsis" onClick="pencere_ac2();"></span>
						</div>
					</div>
				</div>	
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">	
					<div class="form-group" id="item-pro_rows">
						<select name="pro_rows" id="pro_rows" style="width:130px;">
							<option value=""><cf_get_lang dictionary_id='52009.Süreç Aşaması'></option>
							<cfoutput query="get_pro_typerows">
								<option value="#process_row_id#" <cfif attributes.pro_rows eq process_row_id> selected</cfif>>#stage#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-ims_code_id">
						<div class="input-group">
							<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
							<cfinput type="text" name="ims_code_name" placeholder="#getLang('','IMS Kodu',52400)#" value="#attributes.ims_code_name#" style="width:100px;">
							<span class="input-group-addon icon-ellipsis" onClick="pencere_ac();"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">	
					<div class="form-group" id="item-pos_code">
						<div class="input-group">
							<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
							<cfsavecontent variable="title_"><cf_get_lang dictionary_id="57908.Temsilci"></cfsavecontent>
							<input type="text" name="pos_code_text" placeholder="<cfoutput>#title_#</cfoutput>" id="pos_code_text" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>" style="width:100px;">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_company.pos_code&field_name=search_company.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1');return false"></span>
						</div>
					</div>
					<div class="form-group" id="item-conscat">
						<select name="conscat" id="conscat" style="width:140px;" tabindex="23">
							<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
							<cfoutput query="get_conscat">
								<option value="#conscat_id#" <cfif attributes.conscat eq conscat_id> selected</cfif>>#conscat#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-sales_county">
						<select name="sales_county" id="sales_county" style="width:140px;" tabindex="27">
							<option value=""><cf_get_lang dictionary_id='57659.Satis Bölgesi'></option>
							<cfoutput query="sz">
								<option value="#sz_id#" <cfif sz_id eq attributes.sales_county> selected</cfif>>#sz_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
		<tbody><cfoutput>#head_#</cfoutput></tbody>
		<cfform name="form_name" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_visit_row">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
						<th width="120"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th width="100"><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
						<cfif not isdefined("attributes.is_single")>
							<th width="20" class="text-center"><cfif attributes.totalrecords neq 0><input type="Checkbox" name="all" id="all" value="1" onClick="javascript: hepsi();"></cfif></th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<cfif get_consumer.recordcount>
						<cfoutput>
							<cfif isdefined("attributes.is_close")><input type="hidden" name="is_close" id="is_close" value="#attributes.is_close#"></cfif>
							<cfif isdefined("attributes.is_sales")><input type="hidden" name="is_sales" id="is_sales" value="#attributes.is_sales#"></cfif>
							<cfif isdefined("attributes.is_single")><input type="hidden" name="is_single" id="is_single" value="#attributes.is_single#"></cfif>
							<cfif isdefined("attributes.record_num_")><input type="hidden" name="record_num_" id="record_num_" value="#attributes.record_num_#"></cfif>
							<cfif isdefined("attributes.is_activity")><input type="hidden" name="is_activity" id="is_activity" value="#attributes.is_activity#"></cfif>
							<cfif isdefined("attributes.is_position")><input type="hidden" name="is_position" id="is_position" value="#attributes.is_position#"></cfif>
							<cfif isdefined("attributes.is_choose_project")><input type="hidden" name="is_choose_project" id="is_choose_project" value="#attributes.is_choose_project#"></cfif>
							<input type="hidden" name="fuseaction_name" id="fuseaction_name" value="#attributes.fuseaction#" />
							<input type="hidden" name="kontrol_startdate" id="kontrol_startdate" value="<cfif isdefined("attributes.kontrol_startdate")>#attributes.kontrol_startdate#</cfif>">
							<input type="hidden" name="kontrol_finishdate" id="kontrol_finishdate" value="<cfif isdefined("attributes.kontrol_finishdate")>#attributes.kontrol_finishdate#</cfif>">
						</cfoutput>
						<cfoutput query="get_consumer" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td width="30">#currentrow#</td>
								<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#fullname#</a></td>
								<td>#conscat#</td>
								<td>#company#</td>
								<cfif not isdefined("attributes.is_single")>
									<td class="text-center"><input type="checkbox" value="#consumer_id#" name="cons_ids" id="cons_ids"></td>
								</cfif>
							</tr>
						</cfoutput>
						<cfif not isdefined("attributes.is_single")>
							<tr>
								<td height="30" colspan="11" style="text-align:right;">
									<cf_workcube_buttons is_upd="0" add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_name' , #attributes.modal_id#)"),DE(""))#">
								</td>
							</tr>
						</cfif>
					<cfelse>
						<tr height="22">
							<td colspan="11" class="color-row"><cfif len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list> 
		</cfform>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.is_submitted)>
				<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
			</cfif>
			<cfif len(attributes.fullname)>
				<cfset url_str = "#url_str#&fullname=#attributes.fullname#">
			</cfif>
			<cfif len(attributes.ims_code_id)>
				<cfset url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#&ims_code_name=#attributes.ims_code_name#">
			</cfif>
			<cfif isdefined("attributes.click_count") and len(attributes.click_count)>
				<cfset url_str = "#url_str#&click_count=#attributes.click_count#">
			</cfif>
			<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
				<cfset url_str = "#url_str#&pos_code=#attributes.pos_code#&pos_code_text=#attributes.pos_code_text#">
			</cfif>
			<cfif len(attributes.city)>
				<cfset url_str = "#url_str#&city=#attributes.city#">
			</cfif>
			<cfif len(attributes.county) and len(attributes.county_id)>
				<cfset url_str = "#url_str#&county=#attributes.county#&county_id=#attributes.county_id#">
			</cfif>
			<cfif len(attributes.pro_rows)>
				<cfset url_str = "#url_str#&pro_rows=#attributes.pro_rows#">
			</cfif>
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
			</cfif>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.#fusebox.fuseaction##url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>  
	</cf_box>
</div>

<script type="text/javascript">
search_company.fullname.focus();
function pencere_ac(selfield)
{	
	if(document.search_company.city != undefined)
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_company.ims_code_name&field_id=search_company.ims_code_id&is_submitted=1&il_id=' +document.search_company.city.value);
	else
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_company.ims_code_name&field_id=search_company.ims_code_id&is_submitted=1');
}
function hepsi()
{
	if (document.getElementById('all').checked)
	{
		<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
			for(var i=0;i<form_name.cons_ids.length;i++) form_name.cons_ids[i].checked = true;
		<cfelseif attributes.totalrecords eq 1 or attributes.maxrows eq 1>
			form_name.cons_ids.checked = true;
		</cfif>
	}
	else
	{
		<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
			for(var i=0;i<form_name.cons_ids.length;i++) form_name.cons_ids[i].checked = false;
		<cfelseif attributes.totalrecords eq 1>
			form_name.cons_ids.checked = false;
		</cfif>
	}
}
function county_id_clear()
{	
	document.search_company.county.value = '';
	document.search_company.county_id.value = '';
	document.search_company.ims_code_id.value = '';
	document.search_company.ims_code_name.value = '';
}

function add_checked()
{
	var counter = 0;
	<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
		for (var i=0 ; i < form_name.cons_ids.length ; i++) 
			if (form_name.cons_ids[i].checked == true) 
			{
				counter = counter + 1;
			}
			
		if (counter == 0)
		{
			alert("<cf_get_lang dictionary_id='33181.Kişi seçmelisiniz'> !");
			return false;
		}
	<cfelseif attributes.totalrecords eq 1 or attributes.maxrows eq 1>
		if (form_name.cons_ids.checked == true) 
		{
			counter = counter + 1;
		}
		if (counter == 0)
		{
			alert("<cf_get_lang dictionary_id='33181.Kişi seçmelisiniz'> !");
			return false;
		}
	</cfif>
}
</script>
