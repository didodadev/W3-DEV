<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<style type="text/css">
	.DynarchCalendar-topCont  {
		top:0% !important;
		margin-left:250px;
	}
</style>
<cfsetting showdebugoutput="no">
<!--- Bu sayfanın Hedefde add_optionsda calisan hali mevcut BK20090319 --->
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_assetp_cats.cfm">
<cfinclude template="../query/get_fault_ratio.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfquery name="GET_MAX_ACCIDENT" datasource="#DSN#">
	SELECT MAX(ACCIDENT_ID) AS MAX_ACCIDENT_ID FROM ASSET_P_ACCIDENT 
</cfquery>

<cfif len(get_max_accident.max_accident_id)>
	<cfset max_accident_id = get_max_accident.max_accident_id>
	<cfset max_accident_id = max_accident_id + 1>
<cfelse>
	<cfset max_accident_id = 1>
</cfif>

<cf_box  title="#getLang('','Kaza Kayıt',47977)#">
<form name="add_accident" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_add_accident">
	<input type="hidden" name="is_detail" id="is_detail" value="0">
	<input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
	<cf_box_elements>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-fuel_num">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48261.Kayıt No'></label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="fuel_num" id="fuel_num" value="<cfoutput>#max_accident_id#</cfoutput>" readonly>
				</div>
			</div>
			<div class="form-group" id="item-assetp_name">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'></label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="assetp_id" id="assetp_id" value="">
						<input type="text" name="assetp_name" id="assetp_name" value=""  onfocus="AutoComplete_Create('assetp_name','ASSETP','ASSETP','get_assetp_autocomplete','2','ASSETP_ID','assetp_id','','3','148');">
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_accident.assetp_id&field_name=add_accident.assetp_name&field_emp_id=add_accident.employee_id&field_emp_name=add_accident.employee_name&field_dep_name=add_accident.department&field_dep_id=add_accident.department_id&list_select=2&is_active=1','list','popup_list_ship_vehicles');"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-employee_name">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="">
						<input type="text" name="employee_name" id="employee_name" value="" readonly>
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_accident.employee_id&field_name=add_accident.employee_name&select_list=1&branch_related</cfoutput>','list','popup_list_positions')"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-department">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="department_id" id="department_id" value="">
						<input type="text" name="department" id="department" readonly>
						<span class="input-group-addon icon-ellipsis"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_accident.department_id&field_dep_branch_name=add_accident.department','list','popup_list_departments');"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="item-accident_date">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48266.Kaza Tarihi'></label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input type="text" name="accident_date" id="accident_date" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="accident_date"></span>
						<input type="hidden" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#">
					</div>
				</div>
			</div>
		</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item-accident_type_id">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48268.Kaza Tipi'></label>
				<div class="col col-8 col-xs-12">
					<cf_wrk_combo
						name="accident_type_id"
						query_name="GET_ACCIDENT_TYPE"
						option_name="accident_type_name"
						option_value="accident_type_id"
						option_text=""
						width="155">
				</div>
			</div>
			<div class="form-group" id="item-fault_ratio_id">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48269.Kusur Oranı'></label>
				<div class="col col-8 col-xs-12">
					<select name="fault_ratio_id" id="fault_ratio_id">
						<option value=""></option>
						<cfoutput query="get_fault_ratio">
							<option value="#fault_ratio_id#">#fault_ratio_name#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group" id="item-document_type_id">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
				<div class="col col-8 col-xs-12">
					<select name="document_type_id" id="document_type_id">
						<option value=""></option>
						<cfoutput query="get_document_type">
							<option value="#document_type_id#">#document_type_name#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group" id="item-document_num">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
				<div class="col col-8 col-xs-12">
					<input name="document_num" type="text" id="document_num" maxlength="20">
				</div>
			</div>

		</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" id="item-document_num">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-xs-12">
					<textarea name="accident_detail" id="accident_detail"></textarea>
				</div>
			</div>
		</div>
	</cf_box_elements>


	<cf_box_footer>
		<cf_workcube_buttons type_format='1' is_upd='0' is_cancel='0' add_function='kontrol()'>
	</cf_box_footer>

</form>
</cf_box>

<script type="text/javascript">
	function kontrol()
	{
		if(document.add_accident.assetp_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29453.Plaka'>!");
			return false;
		}
		
		if(document.add_accident.employee_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57544.Sorumlu'>!");
			return false;
		}
		
		if(document.add_accident.department.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'>!");
			return false;
		}
		
		if(document.add_accident.accident_date.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48266.Kaza Tarihi'>!");
			return false;
		}
		
		tarih1_ = add_accident.accident_date.value.substr(6,4) + add_accident.accident_date.value.substr(3,2) + add_accident.accident_date.value.substr(0,2);
		tarih2_ = add_accident.today_value_.value.substr(6,4) + add_accident.today_value_.value.substr(3,2) + add_accident.today_value_.value.substr(0,2);
		if((add_accident.accident_date.value != "") && (tarih1_ > tarih2_))
		{
			alert("Kaza Tarihi Bugünden Büyük Olamaz!");
			return false;
		}	
			
		x = document.add_accident.accident_type_id.selectedIndex;
		if (document.add_accident.accident_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48268.Kaza Tipi'>!");
			return false;
		}
		
		y = (1000 - add_accident.accident_detail.value.length);
		if ( y < 0 )
		{ 
			alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * y) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
			return false;
		}	
		return true;
	}
</script>
