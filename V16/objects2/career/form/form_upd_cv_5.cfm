<!--- Özgeçmişim / İş Tecrübelerim (Stage: 5) --->
<!--- TODO: Popuplar düzeltilecek --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career")>
<cfset get_app = get_components.get_app()>
<cfset get_partner_positions = get_components.get_partner_positions()>
<cfset get_relatives = get_components.get_relatives()>
<cfset get_emp_reference = get_components.get_emp_reference()>
<cfset get_reference_type = get_components.get_reference_type()>
<cfset get_work_info = get_components.get_work_info()>

<cfparam name="attributes.stage" default="5"><!--- hangi sayfa olduğunu belirleyen değer--->
<cfform name="employe_detail" method="post" >
<input type="hidden" name="stage" id="stage" value="<cfoutput>#attributes.stage#</cfoutput>">
<div class="row">
	<div class="col-md-12">
		<cfinclude template="../display/add_sol_menu.cfm">
	</div>
</div>
<div class="table-responsive">
<table class="table table-borderless">
	<tr>
		<td class="font-weight-bold"><cf_get_lang dictionary_id='31446.Özgeçmişim'> \ <cf_get_lang dictionary_id='35226.İş Tecrübeleri'></td>
	</tr>
	<tr>
		<td>
			<table class="table">
				<tr>
					<td class="pl-0">
						<cfif get_work_info.recordcount>
							<table id="table_work_info" class="table">
								<tr>
									<td colspan="7" class="font-weight-bold pl-0"><h5><cf_get_lang dictionary_id='32336.Deneyim'></h5></td>
								</tr>
								<input type="hidden" name="row_count" id="row_count" value="<cfoutput>#get_work_info.recordcount#</cfoutput>">
								<tr class="main-bg-color">
									<td class="font-weight-bold"><cf_get_lang dictionary_id='31549.Çalışılan Yer'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='57579.Sektör'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
									<td class="font-weight-bold"><input type="hidden" name="record_num" id="record_num" value="0"><a href="javascript://" title="<cf_get_lang dictionary_id='31526.İş Tecrübesi Ekle'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_upd_work_info&control=0</cfoutput>','page');"><img src="/images/button_gri.gif" alt="<cf_get_lang dictionary_id='31526.İş Tecrübesi Ekle'>" border="0" /></a></td>
									<td></td>	
								</tr>
								<cfoutput query="get_work_info">
									<tr id="frm_row#currentrow#"  onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
										<input type="hidden" name="empapp_row_id#currentrow#" id="empapp_row_id#currentrow#" class="boxtext" style="width:100%;" value="#empapp_row_id#">
										<td><input type="text" name="exp_name#currentrow#"  id="exp_name#currentrow#" class="boxtext form-control" value="#exp#" readonly></td>
										<td><input type="text" name="exp_position#currentrow#" id="exp_position#currentrow#" class="boxtext form-control" value="#exp_position#" readonly></td>
										<td>
											<input type="hidden" name="exp_sector_cat#currentrow#" id="exp_sector_cat#currentrow#" class="boxtext" value="#exp_sector_cat#">
											<cfif len(exp_sector_cat)>
												<cfquery name="get_sector_cat" datasource="#dsn#">
													SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#exp_sector_cat#">
												</cfquery>
											</cfif>
											<input type="text" name="exp_sector_cat_name#currentrow#" id="exp_sector_cat_name#currentrow#" class="boxtext form-control" value="<cfif isdefined("get_sector_cat") and len(get_sector_cat.sector_cat)>#get_sector_cat.sector_cat#</cfif>" readonly>
										</td>
										<td>
											<input type="hidden" name="exp_task_id#currentrow#" id="exp_task_id#currentrow#" class="boxtext" value="#exp_task_id#">
											<cfif len(exp_task_id) and exp_task_id neq ' '>
												<cfquery name="GET_EXP_TASK_NAME" dbtype="query">
													SELECT * FROM GET_PARTNER_POSITIONS WHERE PARTNER_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#exp_task_id#">
												</cfquery>
											</cfif>
											<input type="text" name="exp_task_name#currentrow#" id="exp_task_name#currentrow#" class="boxtext form-control" value="<cfif len(exp_task_id) and len(get_exp_task_name.partner_position)>#get_exp_task_name.partner_position#</cfif>" readonly>
										</td>
										<td>
											<input type="text" name="exp_start#currentrow#" id="exp_start#currentrow#" class="boxtext form-control" value="#dateformat(exp_start,'dd/mm/yyyy')#" readonly>
										</td>
										<td>
											<input type="text" name="exp_finish#currentrow#" id="exp_finish#currentrow#" class="boxtext form-control" value="#dateformat(exp_finish,'dd/mm/yyyy')#" readonly>
										</td>
										<td><a href="javascript://" title="<cf_get_lang dictionary_id='31694.İş Tecrübesi Güncelle'>" onclick="gonder_upd('#currentrow#');"><img src="../../images/update_list.gif" alt="<cf_get_lang dictionary_id='31694.İş Tecrübesi Güncelle'>" border="0" /></a></td>
										<td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a href="javascript://" title="<cf_get_lang_main no='51.Sil'>" onclick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id='57463.Sil'>" /></a></td>
										<input type="hidden" name="exp_telcode#currentrow#" id="exp_telcode#currentrow#" class="boxtext" value="#exp_telcode#">
										<input type="hidden" name="exp_tel#currentrow#" id="exp_tel#currentrow#" class="boxtext" value="#exp_tel#">
										<input type="hidden" name="exp_money_type#currentrow#" id="exp_money_type#currentrow#" class="boxtext" value="#exp_money_type#">
										<input type="hidden" name="exp_salary#currentrow#" id="exp_salary#currentrow#" class="boxtext" value="#exp_salary#">
										<input type="hidden" name="exp_extra_salary#currentrow#" id="exp_extra_salary#currentrow#" class="boxtext" value="#exp_extra_salary#">
										<input type="hidden" name="exp_extra#currentrow#" id="exp_extra#currentrow#" class="boxtext" value="#exp_extra#">
										<input type="hidden" name="exp_reason#currentrow#" id="exp_reason#currentrow#" class="boxtext" value="#exp_reason#">
										<input type="hidden" name="is_cont_work#currentrow#" id="is_cont_work#currentrow#" class="boxtext" value="#is_cont_work#">
									</tr>
								</cfoutput>
							</table>
						<cfelse>
							<table id="table_work_info" class="table">
								<tr>
									<td colspan="7" class="font-weight-bold"><cf_get_lang no='759.Deneyim'></td>
								</tr>
								<input type="hidden" name="row_count" id="row_count" value="0">
								<tr>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='31549.Çalışılan Yer'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='57579.Sektör'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></td>
									<td class="font-weight-bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></td>
									<td class="txtboldblue"><input type="hidden" name="record_numb" id="record_numb" value="0"><a href="javascript://" title="<cf_get_lang dictionary_id='31526.İş Tecrübesi Ekle'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_upd_work_info&control=0</cfoutput>','page');"><img src="/images/button_gri.gif" alt="<cf_get_lang dictionary_id='31526.İş Tecrübesi Ekle'>" border="0 /"></a></td>
								</tr>
									<input type="hidden" name="exp_name" id="exp_name" value="">
									<input type="hidden" name="exp_position" id="exp_position" value="">
									<input type="hidden" name="exp_sector_cat" id="exp_sector_cat" value="">
									<input type="hidden" name="exp_task_id" id="exp_task_id" value="">
									<input type="hidden" name="exp_start" id="exp_start" value="">
									<input type="hidden" name="exp_finish" id="exp_finish" value="">
									<input type="hidden" name="exp_telcode" id="exp_telcode" value="">
									<input type="hidden" name="exp_tel" id="exp_tel" value="">
									<input type="hidden" name="exp_money_type" id="exp_money_type" value="">
									<input type="hidden" name="exp_salary" id="exp_salary" value="">
									<input type="hidden" name="exp_extra_salary" id="exp_extra_salary" value="">
									<input type="hidden" name="exp_extra" id="exp_extra" value="">
									<input type="hidden" name="exp_reason" id="exp_reason" value="">
									<input type="hidden" name="is_cont_work" id="is_cont_work" value="">
							</table>
						</cfif>
					</td>
				</tr>
			</table>
			<table class="table" id="ref_info">
				<tr>
					<td colspan="7" class="font-weight-bold pl-0"><h5><cf_get_lang dictionary_id='31695.Referans Bilgileri'></h5></td>
				</tr>
				<input type="hidden" name="add_ref_info" id="add_ref_info" value="<cfoutput>#get_emp_reference.recordcount#</cfoutput>">
				<tr class="main-bg-color">
					<td class="font-weight-bold"><cf_get_lang dictionary_id='31063.Referans Tipi'></td>
					<td class="font-weight-bold"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
					<td class="font-weight-bold"><cf_get_lang dictionary_id='57574.Şirket'></td>
					<td class="font-weight-bold"><cf_get_lang dictionary_id='30316.Telefon Kodu'></td>
					<td class="font-weight-bold"><cf_get_lang dictionary_id='48176.Telefon No'></td>
					<td class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
					<td class="font-weight-bold"><cf_get_lang dictionary_id='57428.E-posta'></td>
					<td><a href="#" onclick="add_ref_info_();"><img src="images/plus_list.gif" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></a></td>
				</tr>
				<input type="hidden" name="referance_info" id="referance_info" value="<cfoutput>#get_emp_reference.recordcount#</cfoutput>">
				<cfif isdefined("get_emp_reference")>
					<cfoutput query="get_emp_reference">
						<tr id="ref_info_#currentrow#">
							<td>
								<select name="ref_type#currentrow#" id="ref_type#currentrow#" style="width:95px;">
									<option value=""><cf_get_lang dictionary_id='31063.Referans Tipi'></option>
									<!--- <option value="1"<cfif len(get_emp_reference.reference_type) and (get_emp_reference.reference_type eq 1)>selected</cfif>>Grup İçi</option>
									<option value="2"<cfif len(get_emp_reference.reference_type) and (get_emp_reference.reference_type eq 2)>selected</cfif>>Diğer</option> --->
									<cfloop query="get_reference_type">
										<option value="#reference_type_id#"<cfif len(get_emp_reference.reference_type) and (get_emp_reference.reference_type eq reference_type_id)>selected</cfif>>#reference_type#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" class="form-control" name="ref_name#currentrow#" id="ref_name#currentrow#" value="#reference_name#"></td>
							<td><input type="text" class="form-control" name="ref_company#currentrow#" id="ref_company#currentrow#" value="#reference_company#"></td>
							<td><input type="text" class="form-control" name="ref_telcode#currentrow#" id="ref_telcode#currentrow#" onkeyup="isNumber(this);" value="#reference_telcode#"> </td>
							<td><input type="text" class="form-control" name="ref_tel#currentrow#" id="ref_tel#currentrow#" onkeyup="isNumber(this);" value="#reference_tel#"></td>
							<td><input type="text" class="form-control" name="ref_position#currentrow#" id="ref_position#currentrow#" value="#reference_position#"></td>
							<td>
								<input type="text" class="form-control" name="ref_mail#currentrow#" id="ref_mail#currentrow#" value="#reference_email#">
								<input type="hidden" name="del_ref_info#currentrow#" id="del_ref_info#currentrow#" value="1">
							</td>
							
							<td nowrap><a href="##" onclick="del_ref('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
						</tr>
					</cfoutput>
				</cfif>
			</table>
			<div class="form-group row mr-2">
				<label class="col-md-6 col-form-label"><h5><cf_get_lang dictionary_id='35178.Özel İlgi Alanlarınız'> - <cf_get_lang dictionary_id='35179.Üye Olduğunuz Klüp Ve Dernekler'></h5></label>				
			</div>
			<div class="form-group row mr-2">
				<label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='35178.Özel İlgi Alanlarınız'></label>
				<div class="col-12 col-md-6 col-lg-6 col-xl-3">
					<textarea class="form-control" name="hobby" id="hobby" maxlength="300" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);"><cfoutput>#get_app.hobby#</cfoutput></textarea>
				</div>
			</div>
			<div class="form-group row mr-2">
				<label class="col-md-2 col-form-label"><cf_get_lang dictionary_id='35179.Üye Olduğunuz Klüp Ve Dernekler'></label>
				<div class="col-12 col-md-6 col-lg-6 col-xl-3">
					<textarea class="form-control" name="club" id="club" maxlength="300" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);"><cfoutput>#get_app.club#</cfoutput></textarea>
				</div>
			</div>			
			<table class="table">
				<tr>
					<td class="font-weight-bold pl-0"><h5><cf_get_lang dictionary_id='31698.Aile Bilgileri'></h5></td>
					<td><input type="button" class="btn btn-primary float-right" value="<cf_get_lang dictionary_id='35184.Aile Bireyi Ekle'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_form_add_relative','small');"></td>
				</tr>
				<tr>
				  <td colspan="2" class="pl-0">
				  	<cfif get_relatives.recordcount>
						<table id="table_list" class="table">
							<tr class="main-bg-color">
								<td class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'></td>
								<td class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'></td>
								<td class="font-weight-bold"><cf_get_lang dictionary_id='31277.Yakınlık Derecesi'></td>
								<td></td>
							</tr>
							<cfoutput query="get_relatives">
							<tr>
								<td>#get_relatives.name#</td>
								<td>#get_relatives.surname#</td>
								<td><cfif get_relatives.relative_level eq 1><cf_get_lang dictionary_id='31962.Babası'>
									<cfelseif get_relatives.relative_level eq 2><cf_get_lang dictionary_id='31963.Annesi'>
									<cfelseif get_relatives.relative_level eq 3><cf_get_lang dictionary_id='31329.Eşi'>
									<cfelseif get_relatives.relative_level eq 4><cf_get_lang dictionary_id='31330.Oğlu'>
									<cfelseif get_relatives.relative_level eq 5><cf_get_lang dictionary_id='31331.Kızı'>
									<cfelseif get_relatives.relative_level eq 6><cf_get_lang dictionary_id='31449.Kardeşi'></cfif>
								</td>
								<td><a href="javascript://" title="<cf_get_lang dictionary_id='57464.Güncelle'>" onclick="windowopen('#request.self#?fuseaction=objects2.popup_form_upd_relative&relative_id=#get_relatives.relative_id#','small');"><img src="../../images/update_list.gif" border="0" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" /></a></td>
							</tr>
							</cfoutput>
						</table>
					</cfif>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<cfsavecontent variable="alert"><cf_get_lang dictionary_id='35495.Kaydet ve İlerle'></cfsavecontent>
			<!--- <cf_workcube_buttons is_upd='0' insert_info='#alert#' is_cancel='0' class="mr-3"> --->
			<cf_workcube_buttons is_insert='1'	data_action="/V16/objects2/career/cfc/data_career:add_cv_5" next_page="#request.self#" insert_info="#alert#">
		</td>
	</tr>
</table>
</div>

</cfform>
<br/>
<form name="form_work_info" method="post" action="">
	<input type="hidden" name="exp_name_new" id="exp_name_new" value="">
	<input type="hidden" name="exp_position_new" id="exp_position_new" value="">
	<input type="hidden" name="exp_sector_cat_new" id="exp_sector_cat_new" value="">
	<input type="hidden" name="exp_task_id_new" id="exp_task_id_new" value="">
	<input type="hidden" name="exp_start_new" id="exp_start_new" value="">
	<input type="hidden" name="exp_finish_new" id="exp_finish_new" value="">
	<input type="hidden" name="exp_telcode_new" id="exp_telcode_new" value="">
	<input type="hidden" name="exp_tel_new" id="exp_tel_new" value="">
	<input type="hidden" name="exp_money_type" id="exp_money_type" value="">
	<input type="hidden" name="exp_salary_new" id="exp_salary_new" value="">
	<input type="hidden" name="exp_extra_salary_new" id="exp_extra_salary_new" value="">
	<input type="hidden" name="exp_extra_new" id="exp_extra_new" value="">
	<input type="hidden" name="exp_reason_new" id="exp_reason_new" value="">
	<input type="hidden" name="is_cont_work_new" id="is_cont_work_new" value="">
</form>
<br/>
<script type="text/javascript">
	function kontrol()
	{
		if (document.getElementById('exp1').value.length!=0 || document.getElementById('exp1_position').value.length!=0 || document.getElementById('exp1_start').value.length!=0)
		{
			if(document.getElementById('exp1').value.length==0 || document.getElementById('exp1_position.value').length==0 || document.getElementById('exp1_start').value.length==0)
			{
				alert('1. İş Tecrübenizin Şirketini, görevinizi ve başlangıç tarihinizi girmelisiniz!');
				document.getElementById('exp1').focus();
				return false;
			}
		}
		
		if (document.getElementById('exp2').value.length!=0 || document.getElementById('exp2_position').value.length!=0 || document.getElementById('exp2_start').value.length!=0)
		{
			if(document.getElementById('exp2').value.length==0 || document.getElementById('exp2_position').value.length==0 || document.getElementById('exp2_start').value.length==0)
			{
				alert('2.İş Tecrübenizin Şirketini, görevinizi ve başlangıç tarihinizi girmelisiniz!');
				document.getElementById('exp2').focus();
				return false;
			}
		}
		
		if (document.getElementById('exp3').value.length!=0 || document.getElementById('exp3_position').value.length!=0 || document.getElementById('exp3_start').value.length!=0)
		{
			if(document.getElementById('exp3').value.length==0 || document.getElementById('exp3_position').value.length==0 || document.getElementById('exp3_start').value.length==0)
			{
				alert('3. İş Tecrübenizin Şirketini, görevinizi ve başlangıç tarihinizi girmelisiniz!');
				document.getElementById('exp3').focus();
				return false;
			}
		}
		
		if (document.getElementById('exp4').value.length!=0 || document.getElementById('exp4_position').value.length!=0 || document.getElementById('exp4_start').value.length!=0)
		{
			if(document.getElementById('exp4').value.length==0 || document.getElementById('exp4_position').value.length==0 || document.getElementById('exp4_start').value.length==0)
			{
				alert('4. İş Tecrübenizin Şirketini, görevinizi ve başlangıç tarihinizi girmelisiniz!');
				document.getElementById('exp4').focus();
				return false;
			}
		}
	
		document.getElementById('exp1_salary').value = filterNum(document.getElementById('exp1_salary').value);
		document.getElementById('exp2_salary').value = filterNum(document.getElementById('exp2_salary').value);
		document.getElementById('exp3_salary').value = filterNum(document.getElementById('exp3_salary').value);
		document.getElementById('exp4_salary').value = filterNum(document.getElementById('exp4_salary').value);
		return true;
	}
	
	<cfif isdefined('get_work_info') and (get_work_info.recordcount)>
		row_count=<cfoutput>#get_work_info.recordcount#</cfoutput>;
		satir_say=0;
	<cfelse>
		row_count=0;
		satir_say=0;
	</cfif>
	
	function sil(sy)
	{
		var my_element=eval("document.getElementById('row_kontrol"+sy+"')");
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		satir_say--;
	}
	
	function gonder_upd(count)
	{
		form_work_info.exp_name_new.value = eval("document.getElementById('exp_name"+count+"')").value;
		form_work_info.exp_position_new.value = eval("document.getElementById('exp_position"+count+"')").value;
		form_work_info.exp_sector_cat_new.value = eval("document.getElementById('exp_sector_cat"+count+"')").value;
		form_work_info.exp_task_id_new.value = eval("document.getElementById('exp_task_id"+count+"')").value;
		form_work_info.exp_start_new.value = eval("document.getElementById('exp_start"+count+"')").value;
		form_work_info.exp_finish_new.value = eval("document.getElementById('exp_finish"+count+"')").value;
		form_work_info.exp_telcode_new.value = eval("document.getElementById('exp_telcode"+count+"')").value;
		form_work_info.exp_tel_new.value = eval("document.getElementById('exp_tel"+count+"')").value;
		form_work_info.exp_salary_new.value = eval("document.getElementById('exp_salary"+count+"')").value;
		form_work_info.exp_money_type.value = eval("document.getElementById('exp_money_type"+count+"')").value;
		form_work_info.exp_extra_salary_new.value = eval("document.getElementById('exp_extra_salary"+count+"')").value;
		form_work_info.exp_extra_new.value = eval("document.getElementById('exp_extra"+count+"')").value;
		form_work_info.exp_reason_new.value = eval("document.getElementById('exp_reason"+count+"')").value;
		form_work_info.is_cont_work_new.value = eval("document.getElementById('is_cont_work"+count+"')").value;
		windowopen('','page','kariyer_pop');
		form_work_info.target='kariyer_pop';
		form_work_info.action = '<cfoutput>#request.self#?fuseaction=objects2.popup_upd_work_info&my_count='+count+'&control=1</cfoutput>';
		form_work_info.submit();	
	}
	
	function del_ref(dell){
		var my_emement1 = eval("document.getElementById('del_ref_info"+dell+"')")
		my_emement1.value=0;
		var my_element1=eval("ref_info_"+dell);
		my_element1.style.display="none";
	}
	
	var add_ref_info=<cfif isdefined("get_emp_reference")><cfoutput>#get_emp_reference.recordcount#</cfoutput><cfelse>0</cfif>;
	
	function add_ref_info_()
	{
		add_ref_info++;
		document.getElementById('add_ref_info').value = add_ref_info;
		var newRow;
		var newCell;
		newRow = document.getElementById("ref_info").insertRow(document.getElementById("ref_info").rows.length);
		newRow.setAttribute("name","ref_info_" + add_ref_info);
		newRow.setAttribute("id","ref_info_" + add_ref_info);
		document.getElementById('referance_info').value=add_ref_info;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="ref_type' + add_ref_info +'" id="ref_type' + add_ref_info +'" style="width:95px;"><option value="">Referans Tipi</option><cfoutput query="get_reference_type"><option value="#reference_type_id#">#reference_type#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_name' + add_ref_info +'" id="ref_name' + add_ref_info +'" style=" width:90px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_company' + add_ref_info +'" id="ref_company' + add_ref_info +'" style=" width:90px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_telcode' + add_ref_info +'" id="ref_telcode' + add_ref_info +'" onKeyUp="isNumber(this);" style=" width:90px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_tel' + add_ref_info +'" id="ref_telcode' + add_ref_info +'" onKeyUp="isNumber(this);" style=" width:90px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_position' + add_ref_info +'" id="ref_position' + add_ref_info +'" style=" width:90px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="text" name="ref_mail' + add_ref_info +'" id="ref_mail' + add_ref_info +'" style=" width:90px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input type="hidden" value="1" name="del_ref_info'+ add_ref_info +'" id="del_ref_info'+ add_ref_info +'"><a style="cursor:pointer" onclick="del_ref(' + add_ref_info + ');"><img  src="images/delete_list.gif" border="0" alt="<cf_get_lang_main no ="51.sil">"></a>';
	}
	
	function gonder(exp_name,exp_position,exp_start,exp_finish,exp_sector_cat,exp_task_id,exp_telcode,exp_tel,exp_salary,exp_extra_salary,exp_money_type,exp_extra,exp_reason,control,my_count,is_cont_work)
	{
		if(control == 1)
		{
			eval("document.getElementById('exp_name"+my_count+"')").value=exp_name;
			eval("document.getElementById('exp_position"+my_count+"')").value=exp_position;
			eval("document.getElementById('exp_start"+my_count+"')").value=exp_start;
			eval("document.getElementById('exp_finish"+my_count+"')").value=exp_finish;
			eval("document.getElementById('exp_sector_cat"+my_count+"')").value=exp_sector_cat;
			if(exp_sector_cat != '')
			{
				var get_emp_cv_new = wrk_safe_query("obj2_get_emp_cv_new",'dsn',0,exp_sector_cat);
					var exp_sector_cat_name = get_emp_cv_new.SECTOR_CAT;
			}
			else var exp_sector_cat_name = '';
			eval("document.getElementById('exp_sector_cat_name"+my_count+"')").value=exp_sector_cat_name;
			eval("document.getElementById('exp_task_id"+my_count+"')").value=exp_task_id;
			if(exp_task_id != '')
			{
				var get_emp_task_cv_new = wrk_safe_query("obj2_get_emp_task_cv_new",'dsn',0,exp_task_id);
					var exp_task_name = get_emp_task_cv_new.PARTNER_POSITION;
			}
			else
				var exp_task_name = '';
			eval("document.getElementById('exp_task_name"+my_count+"')").value=exp_task_name;
			eval("document.getElementById('exp_money_type"+my_count+"')").value=exp_money_type;
			eval("document.getElementById('exp_telcode"+my_count+"')").value=exp_telcode;
			eval("document.getElementById('exp_tel"+my_count+"')").value=exp_tel;
			eval("document.getElementById('exp_salary"+my_count+"')").value=exp_salary;
			eval("document.getElementById('exp_extra_salary"+my_count+"')").value=exp_extra_salary;
			eval("document.getElementById('exp_money_type"+my_count+"')").value=exp_money_type;
			eval("document.getElementById('exp_extra"+my_count+"')").value=exp_extra;
			eval("document.getElementById('exp_reason"+my_count+"')").value=exp_reason;
			eval("document.getElementById('is_cont_work"+my_count+"')").value=is_cont_work;
		}
		else
		{
			row_count++;
			document.getElementById('row_count').value = row_count;
			satir_say++;
			var new_Row;
			var new_Cell;
			new_Row = document.getElementById("table_work_info").insertRow(document.getElementById("table_work_info").rows.length);
			new_Row.setAttribute("name","frm_row" + row_count);
			new_Row.setAttribute("id","frm_row" + row_count);		
			new_Row.setAttribute("NAME","frm_row" + row_count);
			new_Row.setAttribute("ID","frm_row" + row_count);		
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="text" name="exp_name' + row_count + '" id="exp_name' + row_count + '" value="'+ exp_name +'" class="boxtext" readonly>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="text" name="exp_position' + row_count + '" id="exp_position' + row_count + '" value="'+ exp_position +'" class="boxtext" readonly>';
			if(exp_sector_cat != '')
			{
				var get_emp_cv = wrk_safe_query("obj2_get_emp_cv_new",'dsn',0,exp_sector_cat);
					var exp_sector_cat_name = get_emp_cv.SECTOR_CAT;
			}
			else
				var exp_sector_cat_name = '';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="text" name="exp_sector_cat_name' + row_count + '" id="exp_sector_cat_name' + row_count + '" value="'+exp_sector_cat_name+'" class="boxtext" readonly>';
			if(exp_task_id != '')
			{
				var get_emp_task_cv = wrk_safe_query("obj2_get_emp_task_cv_new",'dsn',0,exp_task_id);
					var exp_task_name = get_emp_task_cv.PARTNER_POSITION;
			}
			else
				var exp_task_name = '';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="text" name="exp_task_name' + row_count + '" id="exp_task_name' + row_count + '" value="'+exp_task_name+'" class="boxtext" style="width:100px" readonly>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="text" name="exp_start' + row_count + '" id="exp_start' + row_count + '" value="'+ exp_start +'" class="boxtext" style="width:65px;" readonly>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="text" name="exp_finish' + row_count + '" id="exp_finish' + row_count + '" value="'+ exp_finish +'" class="boxtext" style="width:65px;" readonly>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<a href="javascript://" onClick="gonder_upd('+row_count+');"><img src="/images/update_list.gif" alt="Güncelle" border="0" align="absbottom"></a>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_sector_cat' + row_count + '" id="exp_sector_cat' + row_count + '" value="'+ exp_sector_cat +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_task_id' + row_count + '" id="exp_task_id' + row_count + '" value="'+ exp_task_id +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_telcode' + row_count + '" id="exp_telcode' + row_count + '" value="'+ exp_telcode +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_tel' + row_count + '" id="exp_tel' + row_count + '" value="'+ exp_tel +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_money_type' + row_count + '" id="exp_money_type' + row_count + '" value="'+ exp_money_type +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_salary' + row_count + '" id="exp_salary' + row_count + '" value="'+ exp_salary +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_extra_salary' + row_count + '" id="exp_extra_salary' + row_count + '" value="'+ exp_extra_salary +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_extra' + row_count + '" id="exp_extra' + row_count + '" value="'+ exp_extra +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="exp_reason' + row_count + '" id="exp_reason' + row_count + '" value="'+ exp_reason +'">';
			new_Cell = new_Row.insertCell(new_Row.cells.length);
			new_Cell.innerHTML = '<input type="hidden" name="is_cont_work' + row_count + '" id="is_cont_work' + row_count + '" value="'+ is_cont_work +'">';
		}
	}
</script>
