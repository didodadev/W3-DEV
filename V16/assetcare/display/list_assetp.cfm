<cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
<cfset get_api_key = googleapi.get_api_key()>
<cf_xml_page_edit fuseact="assetcare.list_assetp">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.serial_number" default="">
<cfparam name="attributes.assetp_catid" default="">
<cfparam name="attributes.branch_id" default="">
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
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.assetp_status" default="">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.assetp_sub_catid" default="">
<cfparam name="attributes.inventory_no" default="">
<cfparam name="attributes.sup_company_id" default="">
<cfparam name="attributes.sup_comp_name" default="">
<cfparam name="attributes.sup_partner_id" default="">
<cfparam name="attributes.sup_consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.asset_p_space_id" default="">
<cfparam name="attributes.asset_p_space_name" default="">
<cfparam name="attributes.page" default=1>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
    SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfscript>
    cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp");
    cmp_branch.dsn = dsn;
    get_branches = cmp_branch.get_branch(ehesap_control:1,branch_status:1);
</cfscript>
<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.list_assetp">
			<input type="hidden" name="form_submitted" id="form_submitted" value="0">
			<cf_box_search plus="0"><!-- sil -->
                <div class="form-group" id="item-form_ul_keyword">
                    <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
                </div>
                <div class="form-group" id="item-inventory_no">
                    <cfinput type="text" name="inventory_no" id="inventory_no" value="#attributes.inventory_no#" placeholder="#getLang('main',1466)#"/>
                </div>
                <div class="form-group" id="item-assetp_status">
                    <div class="input-group">
                        <cf_wrk_combo
                            name="assetp_status"
                            query_name="GET_ASSET_STATE"
                            option_name="asset_state"
                            option_value="asset_state_id"
                            value="#attributes.assetp_status#"
                            option_text="#getLang('main', 344)#"
                            width=75>
                    </div>
                </div>
                <div class="form-group" id="item-order_type">
                    <select id="order_type" name="order_type">
                        <option value="1" <cfif attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id='47960.Ada Göre Artan'></option>
                        <option value="2" <cfif attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id='47961.Ada Göre Azalan'></option>
                        <option value="3" <cfif attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id='47962.Varlık Tipine Göre'></option>
                        <option value="4" <cfif attributes.order_type eq 4>selected</cfif>><cf_get_lang dictionary_id='47974.Duruma Göre'></option>
                        <option value="5" <cfif attributes.order_type eq 5>selected</cfif>><cf_get_lang dictionary_id='47978.Tarihe Göre Artan'></option>
                        <option value="6" <cfif attributes.order_type eq 6>selected</cfif>><cf_get_lang dictionary_id='47983.Tarihe Göre Azalan'></option>
                        <option value="7" <cfif attributes.order_type eq 7>selected</cfif>><cf_get_lang dictionary_id='47893.Alış Tarihi'><cf_get_lang dictionary_id='29826.Artan'></option>
                        <option value="8" <cfif attributes.order_type eq 8>selected</cfif>><cf_get_lang dictionary_id='47893.Alış Tarihi'><cf_get_lang dictionary_id='29827.Azalan'></option>
                    </select>
                </div>
                <div class="form-group" id="item-is_active">
                    <select name="is_active" id="is_active">
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
                    <cf_wrk_search_button button_type="4" search_function='kontrol(1)'>
                </div>
                <div class="form-group">
                    <cfinclude template="../query/get_assetps1.cfm">
                    <cfif len(get_api_key.GOOGLE_API_KEY)>
                        <cfset assetId = arrayNew(1)>
                        <cfloop query="GET_ASSETPS">
                            <cfif len(coordinate_1) and len(coordinate_2)>
                                <cfset ArrayAppend(assetId, ASSETP_ID) />
                            </cfif>
                        </cfloop>
                        <cfoutput>
                            <a class="ui-btn ui-btn-green" target="_blank" href="#request.self#?fuseaction=assetcare.list_assetp&event=googleMap&zoom=6&type=list&assetId=#assetId.toString()#" title="<cf_get_lang dictionary_id='58849.Haritada Göster'>"><i class="fa fa-map-marker"></i></a>
                        </cfoutput>
                    </cfif>
                </div>
                <div class="form-group">
                    <a id="ui-plus" href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_assetp&event=add' class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                </div>
			</cf_box_search><!-- sil -->
			<cf_box_search_detail search_function="kontrol(1)">
				<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-GetAssetCat2">
						<label class="col col-12"><cf_get_lang dictionary_id='48388.Varlık Tipi'></label>
						<div class="col col-12">
							<cf_wrkassetcat moduleName="assetcare" Lang_main="322.Seciniz" it_asset="0" is_motorized="0" compenent_name="GetAssetCat2" assetp_catid="#attributes.assetp_catid#" onchange_action="get_assetp_sub_cat();">
						</div>
					</div>
					<div class="form-group" id="item-employee_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="emp_id" maxlength="50" id="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">      
								<input type="text" name="employee_name" maxlength="50" id="employee_name" value="<cfoutput>#attributes.employee_name#</cfoutput>" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','emp_id','','3','135');" />
								<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.emp_id&field_name=search_asset.employee_name&select_list=1&branch_related','list','popup_list_positions')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-employee_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57544.Sorumlu'>2</label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" maxlength="50" name="position_code2" id="position_code2" value="<cfif isdefined('attributes.member_type_2')><cfoutput>#attributes.position_code2#</cfoutput></cfif>" />
								<input type="hidden" maxlength="50" name="member_type_2" id="member_type_2" value="<cfif isdefined('attributes.member_type_2')><cfoutput>#attributes.member_type_2#</cfoutput></cfif>" />
								<input type="text" maxlength="50" name="position2" id="position2" value="<cfoutput><cfif isdefined('attributes.position_code2') and len(attributes.position2)><cfif len(attributes.member_type_2) and attributes.member_type_2 eq 'employee'>#get_emp_info(attributes.position_code2,0,0)#<cfelseif len(attributes.member_type_2) and attributes.member_type_2 eq 'partner'>#get_par_info(attributes.position_code2,0,0,0)#<cfelseif attributes.member_type_2 eq 'consumer'>#get_cons_info(attributes.position_code2,0,0)#</cfif></cfif></cfoutput>" onfocus="AutoComplete_Create('position2','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\',\'1\'','PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','position_code2,position_code2,position_code2,member_type_2','','3','225');" style="width:110px;">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_asset.position_code2&field_name=search_asset.position2&field_partner=search_asset.position_code2&field_consumer=search_asset.position_code2&field_emp_id=search_asset.position_code2&field_type=search_asset.member_type_2&select_list=1,7,8&branch_related','list','popup_list_positions')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item_assetp_space_id">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60386.Bulunduğu Yer">/<cf_get_lang dictionary_id="60371.Mekan"></label>
						<div class="col col-12 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="asset_p_space_id" id="asset_p_space_id" value="<cfoutput>#attributes.asset_p_space_id#</cfoutput>"> 
								<input type="text" name="asset_p_space_name" id="asset_p_space_name" value="<cfoutput>#attributes.asset_p_space_name#</cfoutput>" onFocus="AutoComplete_Create('asset_p_space_name','SPACE_NAME','SPACE_NAME','get_assetp_space','3','ASSET_P_SPACE_ID','asset_p_space_id','','3','135')">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_assetp_space&field_name=asset_p_space_name&field_id=asset_p_space_id</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="2">
					<div class="form-group" id="item-assetp_sub_catid">
						<label class="col col-12"><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></label>
						<div class="col col-12">
							<cfif len(attributes.assetp_catid)>
								<cfquery name="GET_SUB_CAT" datasource="#dsn#">
									SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #attributes.assetp_catid#
								</cfquery>
							</cfif>
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
					<div class="form-group" id="item-branch">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id" multiple>
								<option style="display:none" value="" <cfif not len(attributes.branch_id)>selected</cfif>></option> <!--- Actionda null değer gitmemesi için eklendi. --->
								<cfoutput query="get_branches" group="NICK_NAME">
									<optgroup label="#get_branches.NICK_NAME#"></optgroup>
									<cfoutput>
										<option value="#get_branches.BRANCH_ID#"<cfif listfind(attributes.branch_id,get_branches.branch_id,',')> selected</cfif>>#get_branches.BRANCH_NAME#</option>
									</cfoutput>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-getBrandType2">
						<label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
						<div class="col col-12">
							<cf_wrkbrandtypecat
								returninputvalue="brand_name,brand_type_id"
								returnqueryvalue="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_ID"
								brand_type_id="#attributes.brand_type_id#"
								width="105"
								compenent_name="getBrandType2"               
								boxwidth="200"
								boxheight="150"
								is_type_cat_id=0> 
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="3">
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
					<div class="form-group" id="item-department">
						<label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" maxlength="50" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
								<input type="text" maxlength="50" name="department" id="department" value="<cfoutput>#attributes.department#</cfoutput>">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=search_asset.department_id&field_dep_branch_name=search_asset.department','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-make_year">
						<label class="col col-12"><cf_get_lang dictionary_id='58225.Model'></label>
						<div class="col col-12">
							<select name="make_year" id="make_year">
								<option value=""><cf_get_lang dictionary_id='58225.Model'></option>
							<cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
								<cfoutput>
									<cfloop from="#yil#" to="1970" index="i" step="-1">
										<option value="#i#" <cfif i eq attributes.make_year>selected</cfif>>#i#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="4">
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
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_partner=search_asset.sup_partner_id&field_comp_name=search_asset.sup_comp_name&field_comp_id=search_asset.sup_company_id&field_consumer=search_asset.sup_consumer_id&select_list=2,3','list','popup_list_pars');"></span>
							</div>
						</div>
					</div>
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
					<div class="form-group" id="item-is_collective_usage">
						<label class="col col-12"><cf_get_lang dictionary_id ='48516.Ortak Kullanım'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="checkbox" name="is_collective_usage" id="is_collective_usage" value="1" <cfif attributes.is_collective_usage eq 1>checked</cfif>>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box id="list_box" title="#getLang(2207,'Fiziki Varlıklar',30004)#" uidrop="1" hide_table_column="1">
	</cf_box>
</div>
<script type="text/javascript">
function  kontrol(page) {
	if($('#employee_name').val() == "")
	   $('#emp_id').val()=="";
	
	if($('#department').val() == "")
	   $('#department_id').val()=="";
	
	if($('#brand_name').val() == "")
	   $('#brand_type_id').val()=="";
if ($("#is_collective_usage").is(":checked")) { collective=search_asset.is_collective_usage.value;}else{collective="";}
addition="&maxrows="+search_asset.maxrows.value+
"&keyword="+search_asset.keyword.value+
"&assetp_catid="+search_asset.assetp_catid.value+
"&branch_id="+$('#branch_id').val()+
"&department="+search_asset.department.value+
"&emp_id="+search_asset.emp_id.value+
"&employee_name="+search_asset.employee_name.value+
"&is_active="+search_asset.is_active.value+
"&brand_type_id="+search_asset.brand_type_id.value+
"&brand_name="+search_asset.brand_name.value+
"&make_year="+search_asset.make_year.value+
"&property="+search_asset.property.value+
"&is_collective_usage="+collective+
"&position_code2="+search_asset.position_code2.value+
"&assetp_status="+search_asset.assetp_status.value+
"&order_type="+search_asset.order_type.value+
"&assetp_sub_catid="+search_asset.assetp_sub_catid.value+
"&inventory_no="+search_asset.inventory_no.value+
"&member_type_2="+search_asset.member_type_2.value+
"&position2="+search_asset.position2.value+
"&asset_p_space_name="+search_asset.asset_p_space_name.value+
"&department_id="+search_asset.department_id.value+
"&sup_company_id="+search_asset.sup_company_id.value+
"&sup_partner_id="+search_asset.sup_partner_id.value+
"&sup_consumer_id="+search_asset.sup_consumer_id.value+
"&sup_comp_name="+search_asset.sup_comp_name.value+
"&company_id="+search_asset.company_id.value+
"&asset_p_space_id="+search_asset.asset_p_space_id.value+
"&page="+page+
"&startrow=<cfoutput>#attributes.startrow#</cfoutput>"+
"&form_submitted="+search_asset.form_submitted.value+"";
	AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_assetp&event=detlist'+addition,'body_list_box');
}
kontrol(<cfoutput>#attributes.page#</cfoutput>);
$('#keyword').focus();

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
