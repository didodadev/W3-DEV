<cfquery name="GET_GROUP" datasource="#DSN#">
	SELECT WORKGROUP_NAME FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
</cfquery>
<cfquery name="GET_PROCESS_TYPE_ROWS_CAUID" datasource="#DSN#">
	SELECT CAU_POSITION_ID FROM PROCESS_TYPE_ROWS_CAUID WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
</cfquery>
<cfscript>
	cau_id = valuelist(GET_PROCESS_TYPE_ROWS_CAUID.CAU_POSITION_ID, ',');
</cfscript>

<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
    <tr class="color-list" valign="middle">
        <td height="35" class="headbold"><cf_get_lang no ='527.Yetki Grubu'></td>
    </tr>
    <tr class="color-row">
	    <td colspan="4" valign="top">
            <cfform name="form_process_cat" action="#request.self#?fuseaction=settings.emptypopup_upd_workgroup" method="post">
                <table width="100%">
                    <tr>
                        <td width="70"><cf_get_lang no ='1754.Grup İsim'>*</td>
	                    <td><input type="text" name="grup_isim" id="grup_isim" style="width:200;" maxlength="100" value="<cfoutput>#get_group.workgroup_name#</cfoutput>"></td>
    	            </tr>
        	        <tr>
            		    <td>&nbsp;</td>
                		<td colspan="2"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_process_workgroup&workgroup_id=#attributes.workgroup_id#'></td>
                	</tr>
                </table>
                <table width="100%">
					<input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#attributes.workgroup_id#</cfoutput>">
                    <tr>
                        <td height="300">
                            <div id="cc" style="position:absolute;width:100%;height:99%; z-index:88; overflow:auto;">
                                <cfsavecontent variable="txt_1"><cf_get_lang no ='700.Yetkili Pozisyonlar'></cfsavecontent>
                                <cf_workcube_to_cc
                                    is_update="1"
                                    to_dsp_name="#txt_1#"
                                    form_name="upd_process_cat"
                                    str_list_param="1"
                                    action_dsn="#dsn#"
                                    str_action_names = "PRO_POSITION_ID AS TO_POS"
                                    str_alias_names = ""
                                    action_table="PROCESS_TYPE_ROWS_POSID"
                                    action_id_name="WORKGROUP_ID"
                                    data_type="2"
                                    action_id="#attributes.workgroup_id#">
                            </div>
                        </td> 
                        <td valign="top" height="300">
							<cfoutput>
                                <div id="cc" style="position:absolute;width:100%;height:99%; z-index:88; overflow:auto;">
                                    <input type="hidden" name="tbl_to_names_row_count_1" id="tbl_to_names_row_count_1" value="#listlen(cau_id,',')#">
                                    <input type="hidden" name="to_pos_ids_1" id="to_pos_ids_1" value="#cau_id#">
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions_multiuser&field_emp_id=to_emp_ids_1&field_pos_id=to_pos_ids_1&field_pos_code=to_pos_codes_1&row_count=tbl_to_names_row_count_1&table_name=tbl_to_names_1&field_grp_id=to_grp_ids_1&field_wgrp_id=to_wgrp_ids_1&function_row_name=workcube_to_delRow_1&table_row_name=workcube_to_row_1&select_list=1','list');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                                    <font class="formbold"><cf_get_lang no ='2144.Onay ve Uyarılacaklar'></font>
                                    <table id="tbl_to_names_1" width="100%">
                                    	<cfloop  list="#cau_id#" index="i">
                                    		<cfquery name="GET_EMP_NAME_1" datasource="#DSN#">
                                                SELECT 
                                                    EMPLOYEE_NAME,
                                                    EMPLOYEE_SURNAME
                                                FROM
                                                    EMPLOYEE_POSITIONS
                                                WHERE
                                                    EMPLOYEE_POSITIONS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                                            </cfquery>
                                            <tr id="workcube_to_row_1#i#" name="workcube_to_row_1#i#">
                                                <td><a href="javascript://" onclick="workcube_to_delRow_1('#i#');"><img src="/images/delete_list.gif" border="0" align="absbottom"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_emp_name_1.employee_name#&nbsp;#get_emp_name_1.employee_surname#</td>
                                            </tr>
                                        </cfloop>
                                    </table>
								</div>
							</cfoutput>
                        </td>
                        <td height="300">
                            <div id="cc" style="position:absolute;width:100%;height:99%; z-index:88; overflow:auto;">
                                <cfsavecontent variable="txt_2"><cf_get_lang_main no ='1361.Bilgi Verilecekler'></cfsavecontent>
                                <cf_workcube_to_cc
                                    is_update="1"
                                    cc_dsp_name="#txt_2#" 
                                    form_name="upd_process_cat_1"
                                    str_list_param="1"
                                    action_dsn="#dsn#"
                                    str_action_names = "INF_POSITION_ID AS CC_POS"
                                    str_alias_names = ""
                                    action_table="PROCESS_TYPE_ROWS_INFID"
                                    action_id_name="WORKGROUP_ID"
                                    data_type="2"
                                    action_id="#attributes.workgroup_id#">
                            </div>
                    	</td> 
 					</tr>
                </table> 
            </cfform>             
        </td>
    </tr>
</table>
<script type="text/javascript">
	function workcube_to_delRow_1(yer)
	{
		flag_custag=document.form_process_cat.to_pos_ids_1.length;

		if(flag_custag > 0)
		{
			try{document.form_process_cat.to_pos_ids_1[yer].value = '';}catch(e){}
			try{document.all.to_pos_codes_1[yer].value = '';}catch(e){}
			try{document.all.to_emp_ids_1[yer].value = '';}catch(e){}
			try{document.all.to_wgrp_ids_1[yer].value = '';}catch(e){}
		}
		else
		{
			try{document.form_process_cat.to_pos_ids_1.value = '';}catch(e){}
			try{document.all.to_pos_codes_1.value = '';}catch(e){}
			try{document.all.to_emp_ids_1.value = '';}catch(e){}
			try{document.all.to_wgrp_ids_1.value = '';}catch(e){}
		}
		var my_element = eval('document.all.workcube_to_row_1' + yer);
		my_element.style.display = "none";
		my_element.innerText="";
	}
</script>
