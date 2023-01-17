<!---E.A select ifadeleri ile ilgili düzenleme yapıldı.17.07.2012--->
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="assetcare.popup_list_assetps">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.userId" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.assetp_catid" default="">
<cfparam name="attributes.asset_cat" default="">
<cfparam name="attributes.assetp_sub_catid" default="">
<cfparam name="attributes.emp_id" default="#session.ep.userid#">
<cfparam name="attributes.position_code_1" default="">
<cfparam name="attributes.employee_name" default="#session.ep.name# #session.ep.surname#">
<cfquery name="GET_ASSETP_CATS_RESERVE" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>
<cfscript>
	url_str = '&form_submitted=1';
	if (isdefined('attributes.function_name')) url_str = '#url_str#&function_name=#attributes.function_name#';
	if (isdefined('attributes.field_id')) url_str = '#url_str#&field_id=#attributes.field_id#';
	if (isdefined('attributes.width')) url_str = '#url_str#&width=#attributes.width#';
	if (isdefined('attributes.length')) url_str = '#url_str#&length=#attributes.length#';
	if (isdefined('attributes.height')) url_str = '#url_str#&height=#attributes.height#';
	if (isdefined('attributes.field_name')) url_str = '#url_str#&field_name=#attributes.field_name#';
	if (isdefined('attributes.field_motorized_vehicle')) url_str = '#url_str#&field_motorized_vehicle=#attributes.field_motorized_vehicle#';
	if (isdefined('attributes.event_id')) url_str = '#url_str#&event_id=#attributes.event_id#';
	if (isdefined('attributes.motorized_vehicle')) url_str = '#url_str#&motorized_vehicle=#attributes.motorized_vehicle#';
	if (isdefined('attributes.call_function')) url_str = '#url_str#&call_function=#attributes.call_function#';
	if (isdefined('attributes.only_physical_asset')) url_str = '#url_str#&only_physical_asset=#attributes.only_physical_asset#';
	if (isdefined('attributes.only_it_asset')) url_str = '#url_str#&only_it_asset=#attributes.only_it_asset#';
	if (isdefined('attributes.userId')) url_str = '#url_str#&userId=#attributes.userId#';
	if (isdefined('attributes.company')) url_str = '#url_str#&company=#attributes.company#';
	if (isdefined('attributes.position_code')) url_str = '#url_str#&position_code=#attributes.position_code#';
	if (isdefined('attributes.employee_id')) url_str = '#url_str#&employee_id=#attributes.employee_id#';
	if (isdefined('attributes.position_employee_name')) url_str = '#url_str#&position_employee_name=#attributes.position_employee_name#';
	if (isdefined('attributes.member_type')) url_str = '#url_str#&member_type=#attributes.member_type#';
	if (isdefined('attributes.only_motorized_vehicle')) url_str = '#url_str#&only_motorized_vehicle=#attributes.only_motorized_vehicle#';
	if (isdefined('attributes.xmlvalue')) url_str = '#url_str#&xmlvalue=#attributes.xmlvalue#';
	if (isdefined('attributes.exp_center_id')) url_str = '#url_str#&exp_center_id=#attributes.exp_center_id#';
	if (isdefined('attributes.exp_center_name')) url_str = '#url_str#&exp_center_name=#attributes.exp_center_name#';
	if (isdefined('attributes.assetp_id')) url_str = '#url_str#&assetp_id=#attributes.assetp_id#';
	if (isdefined('attributes.assetp')) url_str = '#url_str#&assetp=#attributes.assetp#';
	if (isdefined('attributes.satir')) url_str = '#url_str#&satir=#attributes.satir#';
	if (isdefined('attributes.expense_branch_id')) url_str = '#url_str#&expense_branch_id=#attributes.expense_branch_id#';
</cfscript>
<cfif isdefined("attributes.xmlvalue") and attributes.xmlvalue eq 3><cfset attributes.motorized_vehicle = 1><cfelse><cfset attributes.motorized_vehicle = 0></cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_ASSETP_NAMES" datasource="#DSN#">
		SELECT
			ASSET_P.ASSETP,
			ASSET_P.ASSETP_ID,
			ASSET_P.POSITION_CODE,
			ASSET_P_CAT.ASSETP_CAT,
			ASSET_P_CAT.MOTORIZED_VEHICLE,
            ASSET_P.SUP_COMPANY_DATE,
            ASSET_P.ASSETP_DETAIL,
            ASSET_P.INVENTORY_NUMBER,
            ASSET_P.SERIAL_NO,
			ASSET_P.BARCODE,
            C.FULLNAME,
            ISNULL(ASSET_P.PHYSICAL_ASSETS_HEIGHT,0) as PHYSICAL_ASSETS_HEIGHT,
            ISNULL(ASSET_P.PHYSICAL_ASSETS_SIZE,0) as PHYSICAL_ASSETS_SIZE,
            ISNULL (ASSET_P.PHYSICAL_ASSETS_WIDTH,0) as PHYSICAL_ASSETS_WIDTH,
            DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			EP.POSITION_NAME,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.EMPLOYEE_ID,
			ZONE.ZONE_NAME,
			AP.ASSETP RELATION_ASSETP,
			AP.ASSETP_ID RELATION_ASSETP_ID
		FROM
			EMPLOYEE_POSITIONS EP,
			ASSET_P
				LEFT JOIN ASSET_P AP ON ASSET_P.RELATION_PHYSICAL_ASSET_ID = AP.ASSETP_ID
                LEFT JOIN COMPANY C ON C.COMPANY_ID =ASSET_P.SUP_COMPANY_ID,
			ASSET_P_CAT,			
			DEPARTMENT,
			BRANCH,
			ZONE
		WHERE
			ASSET_P.POSITION_CODE = EP.POSITION_CODE AND
			ASSET_P.STATUS = 1
            AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) 
            AND ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID  
            AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID 
            AND ZONE.ZONE_ID = BRANCH.ZONE_ID
			AND ASSET_P_CAT.ASSETP_CATID = ASSET_P.ASSETP_CATID
			<cfif isdefined('attributes.company') and len(attributes.company) and isdefined('attributes.userId') and len(attributes.userId)>
				AND (ASSET_P.COMPANY_PARTNER_ID = #attributes.userId# ) 
			</cfif>	
            <cfif (isdefined("attributes.xmlvalue") and attributes.xmlvalue eq 1) or isdefined("attributes.only_it_asset")>AND ASSET_P_CAT.IT_ASSET = 1</cfif>
			<cfif (isdefined("attributes.xmlvalue") and attributes.xmlvalue eq 2) or isdefined("attributes.only_physical_asset")>AND (ASSET_P_CAT.IT_ASSET = 0 AND ASSET_P_CAT.MOTORIZED_VEHICLE = 0)</cfif>
            <cfif (isdefined("attributes.xmlvalue") and attributes.xmlvalue eq 3) or isdefined("attributes.only_motorized_vehicle")>AND ASSET_P_CAT.MOTORIZED_VEHICLE = 1</cfif>
			<cfif len(attributes.keyword)> 
				AND (
                        ASSET_P.ASSETP LIKE '%#attributes.keyword#%' OR
                        ASSET_P.SERIAL_NO LIKE '%#attributes.keyword#%' OR
                        ASSET_P.INVENTORY_NUMBER LIKE '%#attributes.keyword#%' OR
						ASSET_P.BARCODE LIKE '%#attributes.keyword#%'
					)
			</cfif>
            <cfif len(attributes.emp_id) and len(attributes.employee_name)>AND ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"></cfif>
			<cfif len(attributes.asset_cat)>AND ASSET_P_CAT.ASSETP_CATID = #attributes.asset_cat#</cfif>
            <cfif len(attributes.assetp_catid)>AND ASSET_P.ASSETP_CATID = #attributes.assetp_catid#</cfif>
            <cfif len(attributes.assetp_sub_catid)>AND ASSET_P.ASSETP_SUB_CATID = #attributes.assetp_sub_catid#</cfif>
    </cfquery>
<cfelse>
	<cfset get_assetp_names.recordcount = 0>
</cfif>
<script type="text/javascript">
function add_pro(assetp_id,assetp)
{  
	<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>basket && satir > -1) 
		//Basket satırlarına fiziki varlık düşürmek için düzenlendi.ASSETP_ID -> ROW_ASSETP_ID, ASSETP -> ROW_ASSETP_NAME olarak değiştiğinden kapatıldı.
		//upd: 02/10/2019 - Uğur Hamurpet
		//window.opener.updateBasketItemFromPopup(satir, { ASSETP_ID: assetp_id, ASSETP: assetp});
		<cfif not isdefined("attributes.draggable")>window.opener.</cfif>updateBasketItemFromPopup(satir, { ROW_ASSETP_ID: assetp_id, ROW_ASSETP_NAME: assetp}); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_assetp_names.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Varlık',29452)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_search_asset" id="list_search_asset" method="post" action="#request.self#?fuseaction=assetcare.popup_list_assetps#url_str#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="">
			<cfif isdefined("attributes.draggable")>
				<input type="hidden" name="draggable" id="draggable" value="1">
			</cfif>
    		<cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" placeholder="#getlang('main','Filtre',57460)#" value="#attributes.keyword#" maxlength="255">
                </div>
                <cfif xml_show_responsible eq 1>
                    <div class="form-group">
                        <div class="input-group">
                            <input type="hidden" name="emp_id" maxlength="50" id="emp_id" value="<cfif len(attributes.emp_id) and len(attributes.employee_name)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">      
                            <input type="text" name="employee_name" maxlength="50" placeholder="<cf_get_lang dictionary_id='57576.Çalışan'>" id="employee_name" value="<cfif len(attributes.emp_id) and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','135');" />
                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_search_asset.emp_id&field_name=list_search_asset.employee_name&select_list=1&branch_related')"></span>
                        </div>
                    </div>
				<cfelseif xml_show_responsible eq 2>
					<div class="form-group">
                        <div class="input-group">
							<input type="hidden" name="emp_id" maxlength="50" id="emp_id" value="">
							<input type="text" name="employee_name" maxlength="50" id="employee_name" value=""/>
                            <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_search_asset.emp_id&field_name=list_search_asset.employee_name&select_list=1&branch_related')"></span>
						</div>
                    </div>
                </cfif>
                <div class="form-group">
					<select name="asset_cat" id="asset_cat">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_assetp_cats_reserve">
							<option value="#assetp_catid#" <cfif len(attributes.asset_cat) and (attributes.asset_cat eq assetp_catid)>selected</cfif>>#assetp_cat#</option>
						</cfoutput>
					</select>
                </div>
                <div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_search_asset' , #attributes.modal_id#)"),DE(""))#">
                </div>
    		</cf_box_search>
    		<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_search_asset' , #attributes.modal_id#)"),DE(""))#">
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-assetp_catid" type="column" index="1" sort="true">
					<label><cf_get_lang dictionary_id="36646.Varlık Tipi"></label>
					<cf_wrkAssetCat moduleName="assetcare" Lang="517.Varlık Tipi" compenent_name="GetAssetCat2" assetp_catid="#attributes.assetp_catid#" width="120" onchange_action="get_assetp_sub_cat();">
				</div>
				<div class="form-group col col-3 col-md-4 col-sm-6 col-xs-12" id="item-assetp_sub_catid" type="column" index="2" sort="true">
					<label><cf_get_lang dictionary_id='42756.Varlık Alt Kategorisi'></label>
					<cfif len(attributes.assetp_catid)>
						<cfquery name="GET_SUB_CAT" datasource="#DSN#">
							SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_catid#">
						</cfquery>
					</cfif>
					<select name="assetp_sub_catid"  id="assetp_sub_catid">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfif len(attributes.assetp_catid)>
							<cfoutput query="get_sub_cat">
								<option value="#assetp_sub_catid#" <cfif get_sub_cat.assetp_sub_catid eq attributes.assetp_sub_catid> selected="selected"</cfif>>#assetp_sub_cat#</option>
							</cfoutput>
						</cfif>
					</select>
				</div>
    		</cf_box_search_detail>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<cfset cols = 1>
					<cfif isdefined('xml_assetp_relation') and xml_assetp_relation eq 1><cfset ++cols><th></th></cfif>
					<th>
						<cfif attributes.motorized_vehicle eq 1><cf_get_lang dictionary_id='58480.Araç'><cfelse><cf_get_lang dictionary_id='29452.Varlık'></cfif>
					</th>
					<cfif isdefined('xml_assetp_relation') and xml_assetp_relation eq 1>
						<cfset ++cols>
						<th><cf_get_lang dictionary_id='48653.Bileşenler'></th>
					</cfif>
					<cfif isdefined("xml_assetp_user_location") and xml_assetp_user_location eq 1>
						<cfset ++cols>
						<th width="100"><cf_get_lang dictionary_id='57930.Kullanıcı'> <cf_get_lang dictionary_id='30031.Lokasyon'></th>
					</cfif>
					<cfif (xml_show_responsible eq 1) || (xml_show_responsible eq 2)><cfset ++cols><th width="100"><cf_get_lang dictionary_id='57544.Sorumlu'></th></cfif>
					<cfif isdefined("xml_assetp_category") and xml_assetp_category eq 1>
						<cfset ++cols>
						<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					</cfif>
					<cfif isdefined("xml_assetp_physical_type") and xml_assetp_physical_type eq 1>
						<cfset ++cols>
						<th><cf_get_lang dictionary_id='48479.A x B x H'></th>
					</cfif>
					<cfif isdefined("xml_assetp_sup_date") and xml_assetp_sup_date eq 1>
						<cfset ++cols>
						<th><cf_get_lang dictionary_id='59327.Alış Tarihi'></th>
					</cfif>
					<cfif isdefined("xml_assetp_detail") and xml_assetp_detail eq 1>
						<cfset ++cols>
						<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					</cfif>
					<cfif isdefined("xml_assetp_fullname") and xml_assetp_fullname eq 1>
						<cfset ++cols>
						<th><cf_get_lang dictionary_id='47892.Alınan Şirket'></th>
				</cfif>
				<cfif isdefined("xml_assetp_inventory_no") and xml_assetp_inventory_no eq 1>
						<cfset ++cols>	
						<th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
				</cfif>
				<cfif isdefined("xml_assetp_serial_no") and xml_assetp_serial_no eq 1>  
						<cfset ++cols>
						<th><cf_get_lang dictionary_id='57637.Seri No'></th>
				</cfif>
				<cfif isdefined("xml_assetp_barcode") and xml_assetp_barcode eq 1>
						<cfset ++cols>
						<th><cf_get_lang dictionary_id='57633.Barkod'></th>
				</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_assetp_names.recordcount>
					<cfif fusebox.use_period eq true>
						<cfset dsn2_alias = dsn2_alias>
					<cfelse>
						<cfset dsn2_alias = dsn>
					</cfif>
					<cfoutput query="get_assetp_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(employee_id)>
							<cfquery name="get_exp_center_id" datasource="#dsn#">
								SELECT TOP 1 
									EIOP.EXPENSE_CENTER_ID,
									EC.EXPENSE,
									EC.EXPENSE_BRANCH_ID
								FROM 
									EMPLOYEES_IN_OUT_PERIOD EIOP,
									EMPLOYEES_IN_OUT EIO,
									#dsn2_alias#.EXPENSE_CENTER EC
								WHERE 
									EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND
									EIO.EMPLOYEE_ID = #employee_id# AND
									EIOP.PERIOD_ID = #session.ep.period_id# AND
									EC.EXPENSE_ID = EIOP.EXPENSE_CENTER_ID
								ORDER BY 
									EIO.START_DATE DESC
							</cfquery>
							<cfset exp_center_id_ = get_exp_center_id.EXPENSE_CENTER_ID>
							<cfset exp_center_name_ = get_exp_center_id.EXPENSE>
							<cfset exp_branch_id_ = get_exp_center_id.EXPENSE_BRANCH_ID>
						<cfelse>
							<cfset exp_center_id_ = ''>
							<cfset exp_center_name_ = ''>
							<cfset exp_branch_id_ = ''>
						</cfif>
						<tr>
							<cfif isdefined('xml_assetp_relation') and xml_assetp_relation eq 1>
								<td class="iconL"><a href="javascript://" id="order_row#currentrow#" onClick="gizle_goster(document.getElementById('assetp_info_goster#currentrow#'));open_assetp_relation(#currentrow#,#assetp_id#);gizle_goster(document.getElementById('assetp_info_gizle#currentrow#'));">
									<i class="fa fa-caret-right"></i></a>
								</td>
							</cfif>
							<td>
								<cfset assetp_ = replace(assetp,"'","","all")>
								<cfif isdefined("attributes.event_id") and attributes.event_id is 0>
									<cfif isdefined("attributes.satir") and len(attributes.satir)>
										<a href="javascript://" onClick="add_pro('#assetp_id#','#assetp#')" class="tableyazi">#assetp#</a>
									<cfelse>
											<a href="javascript://" onClick="get_asset_care('#assetp_id#','#assetp_#','#motorized_vehicle#','#PHYSICAL_ASSETS_WIDTH#','#PHYSICAL_ASSETS_SIZE#','#PHYSICAL_ASSETS_HEIGHT#','#position_code#','#employee_name# #employee_surname#','#employee_id#','#exp_center_id_#','#exp_center_name_#','#branch_id#');" class="tableyazi">#assetp#</a>
									</cfif>
								<cfelse>
									#assetp#
								</cfif>
							</td>
							<cfif isdefined('xml_assetp_relation') and xml_assetp_relation eq 1>
								<td>#relation_assetp#</td>
							</cfif>
							<cfif isdefined("xml_assetp_user_location") and xml_assetp_user_location eq 1>
								<td>#zone_name# / #branch_name# / #department_head#</td>
							</cfif>
							<cfif (xml_show_responsible eq 1) || (xml_show_responsible eq 2)><td><cfif len(employee_id)><a href="javascript://" class="tableyazi" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','ui-draggable-box-medium');">#employee_name# #employee_surname#</a></cfif></td></cfif>
							<cfif isdefined("xml_assetp_category") and xml_assetp_category eq 1>
								<td>#assetp_cat#</td>
							</cfif>
							<cfif isdefined("xml_assetp_physical_type") and xml_assetp_physical_type eq 1><td nowrap="nowrap"><cfif len(physical_assets_width)>#physical_assets_width# <cfelse> 0</cfif> x <cfif len(physical_assets_size)>#physical_assets_size# <cfelse>0</cfif> x <cfif len(physical_assets_height)> #physical_assets_height# <cfelse>0</cfif></td></cfif>
							<cfif isdefined("xml_assetp_sup_date") and xml_assetp_sup_date eq 1><td>#dateformat(sup_company_date,dateformat_style)#</td></cfif>
							<cfif isdefined("xml_assetp_detail") and xml_assetp_detail eq 1><td>#assetp_detail#</td></cfif>
							<cfif isdefined("xml_assetp_fullname") and xml_assetp_fullname eq 1><td>#fullname#</td></cfif>
							<cfif isdefined("xml_assetp_inventory_no") and xml_assetp_inventory_no eq 1><td>#inventory_number#</td></cfif>
							<cfif isdefined("xml_assetp_serial_no") and xml_assetp_serial_no eq 1><td>#serial_no#</td></cfif>
							<cfif isdefined("xml_assetp_barcode") and xml_assetp_barcode eq 1><td>#barcode#</td></cfif>
						</tr> 
					
						<tr style="display:none;" id="row_assetp_relation_#currentrow#">
							<td colspan="#cols#">
								<div id="div_assetp_relation_#currentrow#" style="display:none; outset cccccc;"></div>
							</td>
						</tr> 
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfoutput>#cols#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.asset_cat)>
				<cfset url_str = "#url_str#&asset_cat=#attributes.asset_cat#">
			</cfif>
			<cfif len(attributes.assetp_catid)>
				<cfset url_str = "#url_str#&assetp_catid=#attributes.assetp_catid#">
			</cfif>
			<cfif len(attributes.assetp_catid) and len(attributes.assetp_sub_catid)>
				<cfset url_str = "#url_str#&assetp_sub_catid=#attributes.assetp_sub_catid#">
			</cfif>
			<cfif isdefined("attributes.emp_id")>
				<cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
			</cfif>
			<cfif isdefined("attributes.employee_name")>
				<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
			</cfif>

			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="assetcare.popup_list_assetps&#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){

    $( "form[name=list_search_asset] #keyword" ).focus();

});
	function get_asset_care(id,assetp,motorized_vehicle,width,length,height,position_code,position_name,employee_id,exp_center_id,exp_center_name,expense_branch_id)
	{
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = assetp;
		</cfif>
		<cfif isdefined("attributes.field_motorized_vehicle")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_motorized_vehicle#</cfoutput>.value = motorized_vehicle;
		</cfif>
		<cfif isdefined("attributes.width")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#width#</cfoutput>.value = width;
		</cfif>
		<cfif isdefined("attributes.length")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#length#</cfoutput>.value = length;
		</cfif>
		<cfif isdefined("attributes.position_code")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#position_code#</cfoutput>.value = position_code;
		</cfif>
		<cfif isdefined("attributes.employee_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#employee_id#</cfoutput>.value = employee_id;
		</cfif>	
		<cfif isdefined("attributes.exp_center_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#exp_center_id#</cfoutput>.value = exp_center_id;
		</cfif>		
		<cfif isdefined("attributes.expense_branch_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#expense_branch_id#</cfoutput>.value = expense_branch_id;
		</cfif>	
		<cfif isdefined("attributes.exp_center_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#exp_center_name#</cfoutput>.value = exp_center_name;
		</cfif>	
		<cfif isdefined("attributes.position_employee_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#position_employee_name#</cfoutput>.value = position_name;
		</cfif>
		<cfif isdefined("attributes.member_type")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#member_type#</cfoutput>.value = 'employee';
		</cfif>
		<cfif isdefined("attributes.height")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#height#</cfoutput>.value = height;
		</cfif>
		<cfif isdefined("attributes.call_function")>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif><cfoutput>#attributes.call_function#();</cfoutput>
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
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
	<cfif isdefined('xml_assetp_relation') and xml_assetp_relation eq 1>
		var form_str = GetFormData(list_search_asset);
		function open_assetp_relation(row,assetp_id)
		{
			gizle_goster(document.getElementById('row_assetp_relation_' + row));
			gizle_goster(document.getElementById('div_assetp_relation_' + row));
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=assetcare.emptypopup_relation_list_assetps&asset_id='+assetp_id+'&#url_str#<cfif isdefined("attributes.draggable")>&draggable=#attributes.draggable#</cfif>','div_assetp_relation_'+row,1</cfoutput>);
		}
	</cfif>
</script>
