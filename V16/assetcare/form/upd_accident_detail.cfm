<!---E.A 17 temmuz 2012 select ifadeleriyle alakalı işlem uygulanmıştır.--->
<cfinclude template="../query/get_accident_upd.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_fault_ratio.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfquery name="get_punishment" datasource="#dsn#">
	SELECT PUNISHMENT_ID FROM ASSET_P_PUNISHMENT WHERE ACCIDENT_ID = #attributes.accident_id#
</cfquery>
<!--- <cfsavecontent variable="right">
	<a href="javascript://"  onclick="kaza_kayit();"><img src="/images/plus1.gif" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
</cfsavecontent> --->


<cf_box title="#getLang('','Kaza Güncelle',48316)#" add_href="#request.self#?fuseaction=assetcare.form_add_accident">
<form name="upd_accident" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_upd_accident">
<input type="hidden" name="accident_id" id="accident_id" value="<cfoutput>#attributes.accident_id#</cfoutput>">
<input type="hidden" name="is_detail" id="is_detail" value="1">
<cf_box_elements>
	<!--- First Col --->
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
		<div class="form-group" id="branch_id">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55658.Kayıt No'></label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
				<input type="text" name="accident_num" id="accident_num" value="<cfoutput>#get_accident_upd.accident_id#</cfoutput>" readonly style="width:155px;">

			</div>
		  </div>
		  <div class="form-group" id="branch_id">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41443.Plaka'>*</label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
				<div class="input-group">
					<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_accident_upd.assetp_id#</cfoutput>"> 
					<input type="text" name="assetp_name" id="assetp_name" style="width:155px;" value="<cfoutput>#get_accident_upd.assetp#</cfoutput>" maxlength="50" readonly> 
					<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_accident.assetp_id&field_name=upd_accident.assetp_name&list_select=2&is_active=1','list');"></span>
				</div>
			</div>
		  </div>

		  
		  <div class="form-group" id="branch_id">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>*</label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
			  <div class="input-group">
				<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_accident_upd.employee_id#</cfoutput>"> 
				<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_accident_upd.employee_id,0,0,1)#</cfoutput>" readonly style="width:155px;"> 
				<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_positions&field_emp_id=upd_accident.employee_id&field_name=upd_accident.employee_name&select_list=9,1</cfoutput>','list')"></span>
			  </div>
			  </div>
		  </div>
	
		  <div class="form-group" id="branch_id">
			<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
			<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
			  <div class="input-group">
				<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_accident_upd.department_id#</cfoutput>"> 
				<input type="text" name="department" id="department" value="<cfoutput>#get_accident_upd.branch_name# - #get_accident_upd.department_head#</cfoutput>" readonly style="width:155px;"> 
				<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_accident.department_id&field_dep_branch_name=upd_accident.department','list');"></span>
			  </div>
			  </div>
		  </div>
		  <div class="form-group" id="item-accident_date">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48266.Kaza Tarihi'>*</label>
			<div class="col col-8 col-xs-12">
				<div class="input-group">
					<input type="text" name="accident_date" id="accident_date" value="<cfoutput>#dateformat(get_accident_upd.accident_date,dateformat_style)#</cfoutput>" maxlength="10" style="width:155px"> 
					<span class="input-group-addon"><cf_wrk_date_image date_field="accident_date"></span>
				</div>
			</div>
		</div>

		<div class="form-group" id="item-accident_type_id">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48268.Kaza Tipi'>*</label>
			<div class="col col-8 col-xs-12">
				<cf_wrk_combo
						query_name="GET_ACCIDENT_TYPE"
						name="accident_type_id"
						value="#get_accident_upd.accident_type_id#"
						option_name="accident_type_name"
						option_value="accident_type_id"
						width="155">
			</div>
		</div>

		<div class="form-group" id="item-document_type_id">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
			<div class="col col-8 col-xs-12">
				<select name="document_type_id" id="document_type_id" style="width:155px;">
					<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
					<cfoutput query="get_document_type">
						<option value="#document_type_id#" <cfif document_type_id eq get_accident_upd.document_type_id>selected</cfif>>#document_type_name#</option>																					
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group" id="item-document_num">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
			<div class="col col-8 col-xs-12">
				<input name="document_num" id="document_num" type="text" style="width:155px;" maxlength="20" value="<cfoutput>#get_accident_upd.document_num#</cfoutput>">

			</div>
		</div>
		
	</div>
	<!--- Second Col --->
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">

		<div class="form-group" id="item-document_num">
			<label class="col col-4 col-xs-12"><cf_get_lang no='399.Sigorta Ödemesi'></label>
			<div class="col col-8 col-xs-12">
				<input type="checkbox" name="insurance_payment" id="insurance_payment" value="1" <cfif get_accident_upd.insurance_payment eq 1>checked</cfif>>

			</div>
		</div>
		<div class="form-group" id="item-document_num">
			<label class="col col-4 col-xs-12"><cf_get_lang no='398.Kusur Oranı'></label>
			<div class="col col-8 col-xs-12">

				<select name="fault_ratio_id" id="fault_ratio_id" style="width:155px;">
					<option value=""></option>
					<cfoutput query="get_fault_ratio"> 
						<option value="#fault_ratio_id#" <cfif fault_ratio_id eq get_accident_upd.fault_ratio_id>selected</cfif>>#fault_ratio_name#</option>
					</cfoutput>
				</select>
		</div>
		</div>
			<div class="form-group" id="item-document_num">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-xs-12">
					<textarea name="accident_detail" id="accident_detail"></textarea>
				</div>
			</div>
	</div>
<cf_box_elements>

	<cf_box_footer>
		<cf_record_info query_name="get_accident_upd">
		<cfif get_punishment.recordCount>
			<cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' is_reset='0' is_delete='0' add_function='kontrol()'>
		<cfelse>
			<cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' is_reset='0' is_delete='1' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_accident&accident_id=#attributes.accident_id#&is_detail' add_function='kontrol()'>
		</cfif>
	</cf_box_footer>
</form>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{	
		y = (250 - upd_accident.accident_detail.value.length);
		if ( y < 0 )
		{ 
		alert ("<cf_get_lang_main no ='217.Açıklama'> "+ ((-1) * y) +"<cf_get_lang_main no='1741.Karakter Uzun'> ");
			return false;
		}	
			return true;		

		if(document.upd_accident.accident_date.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48266.Kaza Tarihi'>!");
			return false;
		}
		
		if(!CheckEurodate(document.upd_accident.accident_date.value,'<cf_get_lang dictionary_id='48266.Kaza Tarihi'>'))
		{
			return false;
		}
		
		x = document.upd_accident.accident_type_id.selectedIndex;
		if (document.upd_accident.accident_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='397.Kaza Tipi'>!");
			return false;
		}
			return true;
	}
	// function kaza_kayit()
	// {
	// 	window.opener.parent.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.form_add_accident';
	// 	window.close();
	// }
</script>
