<cfinclude template="../query/get_our_comp_and_branch_name.cfm">
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
</cfquery>
<cfquery name="get_position_branch" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		POSITION_CODE,
		RECORD_EMP,
		RECORD_DATE
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_pos.position_code#">
</cfquery>
<cfset my_list = valuelist(get_position_branch.branch_id)>
<script type="text/javascript">
	function islem_yap_dept_loc(sube_id,kayit_sayisi)
	{
		kontrol = 1;
		$('#active_branch_id').val(sube_id);
		/*if(kayit_sayisi == '1')
		{
			if($('#department_location_' + sube_id + '_' +1).is(':checked'))
				$('#active_dept_loc_list').val($('#department_location_' + sube_id + '_'+1).val());
			else
			{
				if ($('#department_location_' + sube_id + '_'+1).val().search('-') > 0)
				{
					start_index = $('#department_location_' + sube_id + '_'+1).val().search('-') + 1;
					last_index = $('#department_location_' + sube_id + '_'+1).val().length;
					$("input[id^='location_id_']").each(function() {
						if ($(this).val() == $('#department_location_' + sube_id + '_'+1).val().substr(start_index,last_index) && $('#department_id_'+this.id.substr(12,this.id.length)).val() ==  $('#department_location_' + sube_id + '_'+1).val().substr(0,start_index-1))
						{
							alert($('#location_name_'+this.id.substr(12,this.id.length)).val() + ' öncelikli lokasyon olarak seçilmiştir. Lütfen kontrol ediniz !');
							kontrol = 0;
						}
					});
				}
				else
				{
					$("input[id^='department_id_']").each(function() {
						if ($(this).val() == $('#department_location_' + sube_id + '_' + 1).val())
						{
							alert($('#department_name_'+this.id.substr(14,this.id.length)).val()  + ' öncelikli departman olarak seçilmiştir. Lütfen kontrol ediniz !');
							kontrol = 0;
						}
					});
				}
			}
		}
		else
		{
			deger_ = '';
			for(i=1;i<=kayit_sayisi;i++)
			{
				if($('#department_location_' + sube_id + '_' + i).is(':checked'))
				{
					deger_ = deger_ + $('#department_location_' + sube_id + '_' + i).val() + ';';
				}
				else
				{
					if ($('#department_location_' + sube_id + '_'+i).val().search('-') > 0)
					{
						start_index = $('#department_location_' + sube_id + '_'+i).val().search('-') + 1;
						last_index = $('#department_location_' + sube_id + '_'+i).val().length;
						$("input[id^='location_id_']").each(function() {
							if ($(this).val() == $('#department_location_' + sube_id + '_'+i).val().substr(start_index,last_index) && $('#department_id_'+this.id.substr(12,this.id.length)).val() ==  $('#department_location_' + sube_id + '_'+i).val().substr(0,start_index-1))
							{
								alert($('#location_name_'+this.id.substr(12,this.id.length)).val() + ' öncelikli lokasyon olarak seçilmiştir. Lütfen kontrol ediniz !');
								kontrol = 0;
							}
						});
					}
					else
					{
						$("input[id^='department_id_']").each(function() {
							if ($(this).val() == $('#department_location_' + sube_id + '_' + i).val())
							{
								alert($('#department_name_'+this.id.substr(14,this.id.length)).val() + ' öncelikli departman olarak seçilmiştir. Lütfen kontrol ediniz !');
								kontrol = 0;
							}
						});
					}
				}
			}
			$('#active_dept_loc_list').val(deger_);
		}*/
		deger_ = '';
		$("input[id^='department_location_"+sube_id+"_']").each(function() {
			if($(this).is(':checked'))
				deger_ = deger_ + $(this).val() + ';';
			else
			{
				temp_val = $(this).val();
				if (temp_val.search('-') > 0)
				{
					start_index = temp_val.search('-') + 1;
					last_index = temp_val.length;
					$("input[id^='location_id_']").each(function() {
						if ($(this).val() == temp_val.substr(start_index,last_index) && $('#department_id_'+this.id.substr(12,this.id.length)).val() ==  temp_val.substr(0,start_index-1))
						{
							alert($('#location_name_'+this.id.substr(12,this.id.length)).val() + '<cf_get_lang dictionary_id="45187.öncelikli lokasyon"> ! <cf_get_lang dictionary_id="48547.Lütfen kontrol ediniz"> !');
							kontrol = 0;
						}
					});
				}
				else
				{
					$("input[id^='department_id_']").each(function() {
						if ($(this).val() == temp_val)
						{
							alert($('#department_name_'+this.id.substr(14,this.id.length)).val() + ' <cf_get_lang dictionary_id="60098.öncelikli departman"> ! <cf_get_lang dictionary_id="48547.Lütfen kontrol ediniz"> !');
							kontrol = 0;
						}
					});
				}
			}
			$('#active_dept_loc_list').val(deger_);
		});
		if (kontrol == 1)
		{ 
			<cfif isdefined("attributes.from_sec") and len(attributes.from_sec)>
				get_auth_emps(1,0,1);
			</cfif>
			var load_url_ = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_list_employee_department&position_code=#get_emp_pos.position_code#</cfoutput>&frm_list=1&branch_id='+ sube_id;
			AjaxFormSubmit('add_department_location','DISPLAY_DEPARTMENT'+sube_id,0,'Kaydediliyor!','Kaydedildi!',load_url_,'DISPLAY_DEPARTMENT'+sube_id,'');
		}
	}
</script>
<cfparam name="attributes.modal_id" default="">
<cfform name="add_department_location" action="#request.self#?fuseaction=objects.emptypopup_add_emp_to_branch&position_code=#get_emp_pos.position_code#&record_type=1">
	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
	<input type="hidden" id="active_branch_id" name="active_branch_id" value="">
	<input type="hidden" id="active_dept_loc_list" name="active_dept_loc_list" value="">
	<input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
	<input type="hidden" name="auth_emps_pos_codes" id="auth_emps_pos_codes" value="">
	<input type="hidden" name="from_sec" id="from_sec" value="<cfif isdefined('attributes.from_sec') and len(attributes.from_sec)>1<cfelse>0</cfif>">
</cfform>
<cfform name="add_branch_in" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_emp_to_branch&position_code=#get_emp_pos.position_code#">
	<cf_grid_list>
		<input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
		<input type="hidden" name="auth_emps_pos_codes" id="auth_emps_pos_codes" value="">
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		<input type="hidden" name="position_id" id="position_id" value="<cfoutput>#attributes.position_id#</cfoutput>">
		<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
		<input type="hidden" name="from_sec" id="from_sec" value="<cfif isdefined('attributes.from_sec') and len(attributes.from_sec)>1<cfelse>0</cfif>">
			<input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
		<thead>
			 <tr>
                <th colspan="5"><cf_get_lang dictionary_id='33374.Şube ve Departman Yetkisi'></th>
             </tr>
             <tr>
                <th width="20"></th>
                <th width="35"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                <th width="300"><cf_get_lang dictionary_id='57453.Şube'></th>
                <th width="20"><input type="Checkbox" name="all_view_branch" id="all_view_branch" value="1" onClick="javascript: wrk_select_all('all_view_branch','branches');"></th>
            </tr>
        </thead>
        <tbody>
			<cfif get_com_branch.recordcount>
                <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_com_branch.recordcount#</cfoutput>">
                <cfoutput query="get_com_branch">
                    <tr>
                        <td align="center" id="row#currentrow#" class="color-row" onClick="gizle_goster(detail#branch_id#);connectAjax_branch_dept('#BRANCH_ID#');">
                            <img id="goster#currentrow#" src="/images/listele.gif" border="0" title="<cf_get_lang dictionary_id ='58596.Göster'>">
                            <img id="gizle#currentrow#" src="/images/listele_down.gif" border="0" title="<cf_get_lang dictionary_id ='58628.Gizle'>" style="display:none">
                        </td>	 			
                        <td>#currentrow#</td>
                        <td>#nick_name#</td>
                        <td>#branch_name#</td>
                        <td width="2%"><input type="checkbox" name="branches" id="branches" value="#branch_id#" <cfif ListFind(my_list,branch_id,",")>checked</cfif>></td>
                    </tr>
                    <tr id="detail#branch_id#" style="display:none;" class="nohover">
                        <td colspan="5"><div align="left" id="DISPLAY_DEPARTMENT#branch_id#" class="nohover_div"></div></td>
                    </tr>
                </cfoutput>
            </cfif>
        </tbody>
	</cf_grid_list>
	<cf_box_footer>
		<cf_record_info query_name="get_position_branch">
		<cf_workcube_buttons is_upd="0" add_function="branch_dep_control()">
	</cf_box_footer>
</cfform>
<script type="text/javascript">
	function change_depot()
	{
		document.add_branch_in.location.value = '';
		document.add_branch_in.priority_location_id.value = '';
	}
	function connectAjax_branch_dept(branch_id)
	{		
		var load_url_ = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_list_employee_department&position_code=#get_emp_pos.position_code#</cfoutput>&frm_list=1&branch_id='+ branch_id+'<cfif isdefined('attributes.from_sec') and len(attributes.from_sec)>&from_sec=1</cfif>';
		AjaxPageLoad(load_url_,'DISPLAY_DEPARTMENT'+branch_id,1);
	}
	function branch_dep_control()
	{
		sube_kntrl = 1;
		$("input[name='branches']").each(function() {
			if (!$(this).is(':checked'))
			{
				branch_id_val = $(this).val();
				$("input[id^='branch_id_']").each(function() {
					if(branch_id_val == $(this).val())
					{
						alert($('#branch_name_'+this.id.substr(10,this.id.length)).val() + ' <cf_get_lang dictionary_id='60099.Öncelikli Şube'> <cf_get_lang dictionary_id="48547.Lütfen kontrol ediniz">!');
						sube_kntrl = 0;
					}
				});
			}
				
		});
		if (sube_kntrl) get_auth_emps(1,0,1);
		
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('add_branch_in' , <cfoutput>#attributes.modal_id#</cfoutput>)
		<cfelse>
			return false;
		</cfif>
	}
</script>
