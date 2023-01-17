<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Süreç Grubu','31787')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=process.emptypopup_add_group" name="form_process_cat" method="post">
            <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_elements>
				<div class="col col-6 col-md-8 col-sm-12 col-xs-12" type="column" index="1" sort="true">									
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='36239.Grup İsim'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="grup_isim" id="grup_isim" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-process_cat2">
						<cfsavecontent variable="txt_1"><cf_get_lang dictionary_id ='36167.Yetkili Pozisyonlar'></cfsavecontent>
						<cf_workcube_to_cc is_update="0" to_dsp_name="#txt_1#" form_name="form_process_cat" str_list_param="1,2" data_type="1">
					</div>
					<div class="form-group" id="item-process_cat3">
						<cfsavecontent variable="txt_3"><cf_get_lang dictionary_id='36200.Onay ve Uyarılacaklar'></cfsavecontent>
						<cf_workcube_to_cc is_update="0" cc2_dsp_name="#txt_3#" form_name="form_process_cat_3" str_list_param="1,2" data_type="1">     
					</div>
					<div class="form-group" id="item-process_cat4">
						<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
						<cf_workcube_to_cc is_update="0" cc_dsp_name="#txt_2#" form_name="form_process_cat_2" str_list_param="1,2" data_type="1">
					</div> 
				</div> 
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>    

<script type="text/javascript">
	function kontrol()
	{
		if(form_process_cat.grup_isim.value == "")
		{
			alert("<cf_get_lang dictionary_id ='36240.Lütfen Grup İsmi Giriniz'>!");
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
