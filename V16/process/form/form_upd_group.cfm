<cfquery name="GET_GROUP" datasource="#DSN#">
	SELECT RECORD_EMP,RECORD_DATE,UPDATE_EMP,UPDATE_DATE,WORKGROUP_NAME FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
</cfquery>
<cfquery name="GET_RELATED_PROCESS_ID" datasource="#DSN#">
	SELECT MAINWORKGROUP_ID FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE MAINWORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#"> AND PROCESS_ROW_ID IS NOT NULL
</cfquery>
<cfparam  name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Süreç Grubu','31787')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform action="#request.self#?fuseaction=process.emptypopup_upd_workgroup" name="form_process_cat" method="post">
            <cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_elements>
                <div class="col col-6 col-md-8 col-sm-12 col-xs-12" type="column" index="1" sort="true">									
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='36239.Grup İsim'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="grup_isim" id="grup_isim" style="width:250px;" maxlength="100" value="<cfoutput>#get_group.workgroup_name#</cfoutput>">
                        </div>
                    </div>
                    <input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#attributes.workgroup_id#</cfoutput>">
                    <div class="form-group" id="item-process_cat2">
                        <cfsavecontent variable="txt_1"><cf_get_lang dictionary_id ='36167.Yetkili Pozisyonlar'></cfsavecontent>
                        <cf_workcube_to_cc
                        is_update="1"
                        to_dsp_name="#txt_1#"
                        form_name="upd_process_cat"
                        str_list_param="1,2"
                        action_dsn="#dsn#"
                        str_action_names = "PRO_POSITION_ID AS TO_POS,PRO_PARTNER_ID AS TO_PAR"
                        str_alias_names = ""
                        action_table="PROCESS_TYPE_ROWS_POSID"
                        action_id_name="WORKGROUP_ID"
                        data_type="2"
                        action_id="#attributes.workgroup_id#">
                    </div> 
                    <div class="form-group" id="item-process_cat3">
                        <cfsavecontent variable="txt_3"><cf_get_lang dictionary_id='36200.Onay ve Uyarılacaklar'></cfsavecontent>
                        <cf_workcube_to_cc
                        is_update="1"
                        cc2_dsp_name="#txt_3#"
                        form_name="upd_process_cat"
                        str_list_param="1,2"
                        action_dsn="#dsn#"
                        str_action_names = "CAU_POSITION_ID AS CC2_POS,CAU_PARTNER_ID AS CC2_PAR"
                        str_alias_names = ""
                        action_table="PROCESS_TYPE_ROWS_CAUID"
                        action_id_name="WORKGROUP_ID"
                        data_type="2"
                        action_id="#attributes.workgroup_id#">     
                    </div> 
                    <div class="form-group" id="item-process_cat4">
                        <cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
                        <cf_workcube_to_cc
                        is_update="1"
                        cc_dsp_name="#txt_2#" 
                        form_name="upd_process_cat_1"
                        str_list_param="1,2"
                        action_dsn="#dsn#"
                        str_action_names = "INF_POSITION_ID AS CC_POS,INF_PARTNER_ID AS CC_PAR"
                        str_alias_names = ""
                        action_table="PROCESS_TYPE_ROWS_INFID"
                        action_id_name="WORKGROUP_ID"
                        data_type="2"
                        action_id="#attributes.workgroup_id#">
                    </div> 
                </div>
			</cf_box_elements>
            <cf_box_footer>
                <cf_record_info query_name="get_group" record_emp="record_emp" record_date="record_date" update_emp="update_emp" update_date="update_date">
                <cfif get_related_process_id.recordcount>
                    <cf_workcube_buttons is_upd='1' is_delete="0">
                <cfelse>
                    <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=process.emptypopup_del_process_workgroup&workgroup_id=#attributes.workgroup_id#&draggable=#iif(isdefined("attributes.draggable"),1,0)#'>
                </cfif>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
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
