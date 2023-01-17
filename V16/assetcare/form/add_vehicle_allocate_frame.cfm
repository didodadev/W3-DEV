<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_usage_purpose.cfm">
<cfinclude template="../query/get_reasons.cfm">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">

	<cfform name="add_allocate" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_allocate" onSubmit="return unformat_fields();">
		<input type="hidden" name="is_detail" id="is_detail" value="0">
		<cf_box_elements>
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-assetp_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="assetp_id" id="assetp_id" value="">
							<input name="assetp_name" id="assetp_name" type="text" value="" maxlength="50" readonly>
							<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_allocate.assetp_id&field_name=add_allocate.assetp_name&field_pre_km=add_allocate.pre_km&field_last_date=add_allocate.pre_date&select_list=2&is_active=1&is_from_km_kontrol=1','list','popup_list_ship_vehicles');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-department_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48350.Tahsis Edilen Şube'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="department_id" id="department_id" value="">
							<input type="text" name="department" id="department" readonly>
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_dep_branch_name=add_allocate.department&field_id=add_allocate.department_id&is_get_all=1');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-employee_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48351.Tahsis Edilen'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="">
							<input type="text" name="employee_name" id="employee_name" value="" readonly>
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&form_name=&field_emp_id=add_allocate.employee_id&field_name=add_allocate.employee_name&select_list=1</cfoutput>');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-allocate_reason">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48353.Tahsis Tipi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="allocate_reason_id" id="allocate_reason_id">
							<option ""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_reasons">
								<option value="#reason_id#">#allocate_reason#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-allocate_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47989.Tahsis Adı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="allocate_name" id="allocate_name" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-detail">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<textarea name="detail" id="detail" style="width:185px;height:50px;"></textarea>
					</div>
				</div>
			</div>	
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-start_km">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48102.Başlangıç KM'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="start_km" id="start_km" onKeyUp="FormatCurrency(this,event,0);">
						<input type="hidden" name="pre_km" id="pre_km" value="">
						<input type="hidden" name="pre_date" id="pre_date" value="">
					</div>
				</div>
				<div class="form-group" id="item-item-start_date">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-6 col-md-12 col-sm-12 col-xs-12">			
							<div class="input-group">
								<input class="width" type="text" value=""  name="start_date" id="start_date" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
						<div class="col col-3 col-md-6 col-sm-6 col-xs-12">			
							<select name="start_hour" id="start_hour">
								<cfloop from="0" to="23" index="i">
									<option value=<cfoutput>"#i#"</cfoutput>>
										<cfoutput>#NumberFormat(i,'00')#</cfoutput>
									</option>
								</cfloop>
							</select>
						</div>
						<div class="col col-3 col-md-6 col-sm-6 col-xs-12">			
							<select name="start_min" id="start_min">
								<cfloop from="0" to="55" index="i" step="5">
									<option value=<cfoutput>"#i#"</cfoutput>>
										<cfoutput>#NumberFormat(i,'00')#</cfoutput>
									</option>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-item-finish_date">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-6 col-md-12 col-sm-12 col-xs-12">
							<div class="input-group">
								<input class="width" type="text" name="finish_date" id="finish_date" maxlength="10" value="">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
						<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
							<select name="finish_hour" id="finish_hour">
								<cfloop from="0" to="23" index="k">
									<option value=<cfoutput>"#k#"</cfoutput>><cfoutput>#NumberFormat(k,'00')#</cfoutput></option>
								</cfloop>
							</select>
						</div>
						<div class="col col-3 col-md-6 col-sm-6 col-xs-12">
							<select name="finish_min" id="finish_min">
								<cfloop from="0" to="55" index="l" step="5">
									<option value=<cfoutput>"#l#"</cfoutput>><cfoutput>#NumberFormat(l,'00')#</cfoutput></option>
								</cfloop>
							</select>
						</div>              
					</div>
				</div>
				<div class="form-group" id="item-destination">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47988.Gidilecek Yer'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="destination" id="destination" maxlength="100" />
					</div>
				</div>
				<div class="form-group" id="item-item-project_head">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfinput type="hidden" name="project_id" id="project_id" value="#attributes.project_id#">
							<cfinput name="project_head" type="text" id="project_head" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');" value="#attributes.project_head#" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.project_head&project_id=list_works.project_id</cfoutput>');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-item_process">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cf_workcube_process is_upd='0' is_detail="0" process_cat_width='133'>
					</div>
				</div>
				<div class="form-group" id="item-is_offtime">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48229.Mesai Dışı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="checkbox" name="is_offtime" id="is_offtime" value="1">
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-item-cc">
					<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='57590.Katılımcılar'></cfsavecontent>
						<cf_workcube_to_cc 
						is_update="0" 
						to_dsp_name="#txt_2#" 
						form_name="add_allocate" 
						str_list_param="1" 
						action_dsn="#DSN#"
						str_action_names="EMPLOYEE_ID AS TO_EMP"
						action_table="ASSET_P_KM_CONTROL_USERS"
						data_type="1">
				</div>
			</div>
		</cf_box_elements>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_basket_form_button>	
				<cf_workcube_buttons is_upd='0' is_cancel='0' is_reset='1' add_function='kontrol()'>
			</cf_basket_form_button>
		</div>
	</cfform>
<script type="text/javascript">
	var fld = document.add_allocate.pre_km;
	var fld2 = document.add_allocate.start_km;
	function unformat_fields()
	{
	  fld.value = filterNum(fld.value);
	  fld2.value = filterNum(fld2.value);
	}
	function kontrol()
	{
		a = filterNum(fld.value);
		b = filterNum(fld2.value);
		if(document.add_allocate.assetp_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='29453.Plaka'>!");
			return false;
		}
		if(document.add_allocate.department.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57453.Şube'>!");
			return false;
		}
		if(document.add_allocate.employee_name.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='48351.Tahsis Edilen'>!");
			return false;
		}
		if(document.add_allocate.start_km.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='48102.Başlangıç KM'>!");
			return false;
		}
		if(document.add_allocate.start_date.value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>!");
			return false;
		}
		
		x = (50 - add_allocate.detail.value.length);
		if ( x < 0 )
		{ 
			alert ("<cf_get_lang dictionary_id='57629.Açıklama'> "+ ((-1) * x) +" <cf_get_lang dictionary_id='29538.Karakter Uzun'>");
			return false;
		}
		
		if(!CheckEurodate(document.add_allocate.start_date.value,"<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>"))
		{
			return false;
		}
		if((document.add_allocate.finish_date.value != "") && (!CheckEurodate(document.add_allocate.finish_date.value,"<cf_get_lang_main no='288.Bitiş Tarihi'>")))
		{
			return false;
		}
		if((document.add_allocate.pre_date.value != "") && !date_check_hiddens(document.add_allocate.pre_date,document.add_allocate.start_date,"<cf_get_lang no='570.Başlangıç Tarihi Son KM Giriş Tarihinden Küçük Olamaz'>!"))
		{
			return false;
		}
		if((document.add_allocate.finish_date.value != "") && !date_check_hiddens(document.add_allocate.start_date,document.add_allocate.finish_date,"<cf_get_lang_main no='571.Tarih Aralığını Kontrol Ediniz'>!"))
		{
			return false;
		}
		
		if(document.add_allocate.pre_km.value == "")
		{
			alert("<cf_get_lang dictionary_id='48444.Bu Araca Ait Sonlandırılmamış Bir Tahsis Kaydı Var'>!");
			return false;
		} 
	}
</script>	