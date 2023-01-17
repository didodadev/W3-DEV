<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
<tr class="color-list" valign="middle">
  <td height="35" class="headbold"><cf_get_lang no='527.Yetki Grubu'></td>
  </tr>
	  <tr class="color-row">
		<td colspan="4" valign="top">
			<cfform action="#request.self#?fuseaction=settings.emptypopup_add_group" name="form_process_cat" method="post">
			<table width="100%">
			  <tr>
				<td width="70"><cf_get_lang no='1754.Grup İsim'>*</td>
				<td><input type="text" name="grup_isim" id="grup_isim" style="width:200;" maxlength="100"></td>
			  </tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="2"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
				</tr>
			</table>
			<table width="100%">
			<tr>
				<td height="300"><div id="cc" style="position:absolute;width:100%;height:99%; z-index:88; overflow:auto;">
				<cfsavecontent variable="txt_1"><cf_get_lang no='700.Yetkili Pozisyonlar'></cfsavecontent>
				<cf_workcube_to_cc 
					is_update="0" 
					to_dsp_name="#txt_1#" 
					form_name="form_process_cat" 
					str_list_param="1" 
					data_type="1">
					</div></td> 
				<td valign="top" height="300"><div id="cc" style="position:absolute;width:100%;height:99%; z-index:88; overflow:auto;">
					<input type="hidden" name="tbl_to_names_row_count_1" id="tbl_to_names_row_count_1" value="0">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions_multiuser&field_emp_id=to_emp_ids_1&field_pos_id=to_pos_ids_1&field_pos_code=to_pos_codes_1&row_count=tbl_to_names_row_count_1&table_name=tbl_to_names_1&field_grp_id=to_grp_ids_1&field_wgrp_id=to_wgrp_ids_1&function_row_name=workcube_to_delRow_1&table_row_name=workcube_to_row_1&select_list=1','list');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
					<font class="formbold"><cf_get_lang no='2144.Onay ve Uyarılacaklar'></font>
					<table id="tbl_to_names_1" width="100%">
					</table>
					</div></td>
				<td height="300"><div id="cc" style="position:absolute;width:100%;height:99%; z-index:88; overflow:auto;">
				<cfsavecontent variable="txt_2"><cf_get_lang_main no='1361.Bilgi Verilecekler'></cfsavecontent>
				<cf_workcube_to_cc 
					is_update="0" 
					cc_dsp_name="#txt_2#" 
					form_name="form_process_cat_2" 
					str_list_param="1" 
					data_type="1">
					</div></td> 
				</tr>
			</cfform>
		</table>              
	</td>
</tr>
</table>
<script type="text/javascript">
function kontrol()
{
	if(form_process_cat.grup_isim.value == "")
	{
		alert("<cf_get_lang no='1790.Lütfen Grup İsmi Giriniz'> !");
		return false;
	}
}
function workcube_to_delRow_1(yer)
{
	flag_custag=document.all.to_pos_ids_1.length;

	if(flag_custag > 0)
	{
		try{document.all.to_pos_ids_1[yer].value = '';}catch(e){}
		try{document.all.to_pos_codes_1[yer].value = '';}catch(e){}
		try{document.all.to_emp_ids_1[yer].value = '';}catch(e){}
		try{document.all.to_wgrp_ids_1[yer].value = '';}catch(e){}
	}
	else
	{
		try{document.all.to_pos_ids_1.value = '';}catch(e){}
		try{document.all.to_pos_codes_1.value = '';}catch(e){}
		try{document.all.to_emp_ids_1.value = '';}catch(e){}
		try{document.all.to_wgrp_ids_1.value = '';}catch(e){}
	}
	var my_element = eval('document.all.workcube_to_row_1' + yer);
	my_element.style.display = "none";
	my_element.innerText="";
}
</script>
