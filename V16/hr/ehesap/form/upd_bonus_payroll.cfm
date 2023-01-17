<!---
    File: upd_bonus_payroll.cfm
    Controller: PayrollPaymentsController.cfm
    Folder: V16\hr\ehesap\form\upd_bonus_payroll.cfm
    Author: Esma R. Uysal
    Date: 16.01.2020 
    Description:Prim bordrosu için hazırlanmıştır.
--->
<cf_papers paper_type="additional_allowance">
<cf_xml_page_edit fuseact="ehesap.list_payments">
<cfset get_payments_cfc = createObject('component','V16.hr.ehesap.cfc.get_payments')>
<!--- Satır query --->
<cfset get_payments_row = get_payments_cfc.get_payments(
                        bonus_id : attributes.bonus_id<!---prim id --->
                    )>
<!--- Belge query --->
<cfset get_payments_paper =  get_payments_cfc.GET_BONUS_PAYROLL(
                        bonus_id : attributes.bonus_id<!---prim id --->
					)>
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process_stage = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.list_payments')>
<script type="text/javascript">
	<cfif isdefined("get_payments_row") and get_payments_row.recordcount><!---  --->
		row_count = <cfoutput>#get_payments_row.recordcount#</cfoutput>;
		is_payment = 1;
	<cfelse>
		row_count = 0;
		is_payment = 0;
	</cfif>
</script>
<cfif get_payments_paper.recordcount eq 0>
	<cf_get_lang dictionary_id ="56834.Bu formu görüntülemeye yetkiniz yok">
	<cfabort>
</cfif>
<!--- Yıl bilgisi --->
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
<cf_catalystHeader>
<cf_box>
    <cfform name="add_ext_salary" action="" method="post">
		<div class="form-group col" id="show_img_baslik1" style="display:none;">
			<div id="show_img0" style="display:none;">
				<input type="hidden" name="show0" id="show0" value="0">
				<i class="fa fa-check-square"></i>
			</div>
		</div>
        <input name="record_num" id="record_num" type="hidden" value="0">
        <input type="hidden" name="bonus_id" id="bonus_id" value="<cfoutput>#attributes.bonus_id#</cfoutput>">
		<cf_box_elements id="ext_salary_element" vertical="1">
			<cfoutput query="get_payments_paper">
				<div class="col col-5 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-pos_cat_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57800.işlem Tipi"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process_cat process_cat = "#process_cat#">
						</div>
					</div>
					<div class="form-group " id="item-paper_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57880.Belge no"></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="paper_no" id="paper_no" value="<cfoutput>#paper_no#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-paper_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="33203.Belge Tarihi"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='33203.Belge Tarihi'></cfsavecontent>
								<cfinput type="text" name="documentdate" id="documentdate" style="width:100px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(paper_date,dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="documentdate"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' is_detail='1' select_value="#process_id#">
						</div>
					</div>
					<div class="form-group"  id="item-emp">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54606.Düzenleyen"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="#employee_id#">
								<input type="text" name="employee_name" id="employee_name" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',0,0,0,2,1,0,0,1','EMPLOYEE_ID,MEMBER_TYPE','employee_id','','3','135');" style="width:120px;" value="#get_emp_info(employee_id,0,0)#">
								<span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&is_cari_action=1&field_emp_id=add_ext_salary.employee_id&field_name=add_ext_salary.employee_name&field_type=add_ext_salary.employee_id&select_list=1,9&draggable=1');"></span>
							</div>
						</div>
					</div>
					
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
						<div class="col col-8 col-xs-12"><textarea name="detail" id="detail">#detail#</textarea></div>
					</div>
				</div>
			</cfoutput>	
			<cf_grid_list>
				<thead>
					<tr>
						<th style="width:10px"><input type="button" class="eklebuton text-center" title="" onClick="add_row2();"></th>
						<th style="width:70px"><cf_get_lang dictionary_id='58487.Çalışan No'></th>
						<cfif is_employee_identity eq 1><th style="width:100px"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th></cfif>
						<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'>/<cf_get_lang dictionary_id='57572.Departman'></th>
						<th id="show_img_baslik2"><i class="fa fa-check-square"></i></th>
						<th style="width:250px"><cf_get_lang dictionary_id='53610.Ödenek'></th>
						<th><cf_get_lang dictionary_id='58472.Dönem'>&emsp;</th>
						<th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
						<th><cf_get_lang dictionary_id='57502.Bitiş'>&emsp;&emsp;</th>
						<th style="width:100px"><cf_get_lang dictionary_id='57673.Tutar'>&emsp;</th>
						<cfif is_project_allowance eq 1><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
						<th><cf_get_lang dictionary_id ='58859.Süreç'></th>
					</tr>
				</thead>
                <tbody id="link_table">
                    <cfoutput query="get_payments_row">
                        <tr id="my_row_#currentrow#">
                            <td><a style="cursor:pointer" onclick="sil(#currentrow#);" ><i class="fa fa-minus"></i></a></td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="empno#currentrow#" id="empno#currentrow#" value="#employee_no#" readonly>
                                </div>
                            </td>
							<cfif is_employee_identity eq 1>
								<td><div clas="form-group"><input type="text" name="tc_identity#currentrow#" id="tc_identity#currentrow#" value="#TC_IDENTY_NO#" readonly></div></td>
							</cfif>
                            <td nowrap>
                                <div class="form-group">
                                    <div class="input-group">
                                        <input type="hidden" value="1" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#">
                                        <input type="hidden" value="#COMMENT_PAY_ID#" name="odkes_id#currentrow#" id="odkes_id#currentrow#" />
                                        <input type="hidden" name="employee_id#currentrow#" id="employee_id#currentrow#" value="#employee_id#">
                                        <input type="hidden" name="employee_in_out_id#currentrow#" id="employee_in_out_id#currentrow#" value="#in_out_id#" style="width:20">
                                        <input name="employee#currentrow#" id="employee#currentrow#" type="text" style="width:120px;" readonly value="#employee_name# #employee_surname#"><span class="input-group-addon icon-ellipsis btnPointer" href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_ext_salary.employee_in_out_id#currentrow#&field_emp_name=add_ext_salary.employee#currentrow#&field_emp_id=add_ext_salary.employee_id#currentrow#&field_branch_and_dep=add_ext_salary.department#currentrow#<cfif is_employee_identity eq 1>&field_tcno=tc_identity#currentrow#</cfif>&draggable=1' ,'list');"></span>
                                    </div>
                                </div>
                            </td>
                            <td><div clas="form-group"><input type="text" name="department#currentrow#" id="department#currentrow#" value="#branch_name#/#department_head#" readonly></div></td>
                            <td id="show_img#currentrow#"  class="text-center"><cfif show eq 1><i class="fa fa-check-square"></i></cfif></td>
                            <td nowrap="nowrap">
                                <div clas="form-group">
                                    <div class="input-group">
                                        <input type="hidden" name="show#currentrow#" id="show#currentrow#" value="0"><input type="text" name="comment_pay#currentrow#" id="comment_pay#currentrow#" style="width:120px;" value="#COMMENT_PAY#" onfocus="AutoComplete_Create('comment_pay#currentrow#','COMMENT_PAY','COMMENT_PAY,ODKES_ID','get_additional_allowance','','ODKES_ID','odkes_id#currentrow#','','3','150',true,'from_odenek(row_count)');" autocomplete="on">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_odenek&row_id_=#currentrow#&draggable=1');"></span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div clas="form-group">
                                    <select name="term#currentrow#" id="term#currentrow#" style="width:100%">
                                        <cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
                                            <option value="#i#"<cfif i eq term>selected<cfelseif year(now()) eq i> selected</cfif>>#i#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </td>
                            <td>
                                <div clas="form-group">
                                    <select name="start_sal_mon#currentrow#" id="start_sal_mon#currentrow#" style="width:100%;" onchange="change_mon('end_sal_mon#currentrow#',this.value);">
                                        <cfloop from="1" to="12" index="j">
                                        <option value="#j#" <cfif j eq start_sal_mon>selected</cfif>>#listgetat(ay_list(),j,',')#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <select name="end_sal_mon#currentrow#" id="end_sal_mon#currentrow#" style="width:100%;">
                                        <cfloop from="1" to="12" index="j">
                                        <option value="#j#" <cfif j eq end_sal_mon>selected</cfif>>#listgetat(ay_list(),j,',')#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </td>
                            <td>
                                <div class="form-group">
                                    <input type="text" name="amount_pay#currentrow#" id="amount_pay#currentrow#" style="width:100%;" class="moneybox" value="#TlFormat(AMOUNT_PAY)#"  onkeyup="return(FormatCurrency(this,event));" onchange="convert_val(this)">
                                </div>
                            </td>
							<cfif is_project_allowance eq 1>
								<td>
									<div clas="form-group">
										<div class="input-group">
											<cfif len(project_id)>
												<cfset project_head = get_payments_cfc.get_project(project_id)>
											</cfif>
											<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="<cfif len(project_id)>#project_id#</cfif>">
											<input name="project_head#currentrow#" type="text" id="project_head#currentrow#"  onfocus="AutoComplete_Create('project_head#currentrow#','PROJECT_HEAD','PROJECT_HEAD,FULLNAME','get_project','','PROJECT_ID','project_id#currentrow#','','3','150',true,'');" value="<cfif len(project_id)>#project_head.PROJECT_HEAD#</cfif>">
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=add_ext_salary.project_head#currentrow#&project_id=add_ext_salary.project_id#currentrow#');"></span>
										</div>
									</div>
								</td>	
							</cfif>
							<td>
								<cf_workcube_process is_upd='0' select_value='#PROCESS_STAGE#' process_cat_width='188' is_detail='1' select_name="process_stage_#currentrow#">
							</td>
                        </tr>
                    </cfoutput>
                </tbody>
			</cf_grid_list>
		</cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_payments_paper" record_emp="record_emp" update_emp="UPDATE_EMP">
			<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url="#request.self#?fuseaction=ehesap.list_payments&event=del&bonus_id=#attributes.bonus_id#&is_del_bonus=1">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">

	function hepsi(satir,nesne,baslangic)
	{
		deger = document.getElementById(nesne + '0');
		if(deger != undefined && deger.value.length!=0)//değer boşdegilse çalıştır foru
		{
			if(!baslangic){baslangic=1;}//başlangıc tüm elemanları değlde sadece bir veya bir kaçtane yapacaksak forun başlayacağı sayıyı vererek okadar dönmesini sağlayabilirz
			for(var i=baslangic;i<=satir;i++)
			{
				nesne_tarih=eval('document.getElementById( nesne + i )');
				nesne_tarih.value=deger.value;
			}
		}
	}
	function sil(sy)
	{
		var my_element = document.getElementById('row_kontrol_' + sy);
		my_element.value=0;
		var my_element = document.getElementById('my_row_' +sy);
		my_element.style.display="none";
	}
	function goster(show)
	{
		if(show==1)
		{
			
			show_img_baslik1.style.display='';
			show_img_baslik2.style.display='';
			for(var i=0;i<=row_count;i++)
			{
				satir=eval("show_img"+i);
				satir.style.display='';
			}
		}
		else
		{
			show_img_baslik1.style.display='none';
			show_img_baslik2.style.display='none';
			for(var i=0;i<=row_count;i++)
			{
				satir=eval("document.getElementById('show_img" + i + "')");
				satir.style.display='none';
			}
		}
	}
	
	function add_row(is_damga,is_issizlik,ssk,tax,is_kidem,show,comment_pay,period_pay,method_pay,term,start_sal_mon,end_sal_mon,amount_pay,calc_days,from_salary,row_id_,ehesap,ayni_yardim,ssk_exemption_rate,tax_exemption_rate,tax_exemption_value,money,odkes_id,ssk_exemption_type)
	{
		if(row_count == 0 )
		{
			alert("<cf_get_lang dictionary_id='53611.Satır Eklemediniz'>!");
			return false;
		}
		
		if(row_id_ != undefined && row_id_ != '' && row_id_ != '0')
		{	
			document.getElementById('show'+row_id_).value = show;
			document.getElementById('odkes_id'+row_id_).value = odkes_id;
			document.getElementById('comment_pay'+row_id_).value=comment_pay;
			document.getElementById('start_sal_mon'+row_id_).value=start_sal_mon;
			document.getElementById('end_sal_mon'+row_id_).value=end_sal_mon;
			document.getElementById('amount_pay'+row_id_).value=amount_pay;
			document.getElementById('term'+row_id_).value=term;
		}
		else if(row_id_ != undefined && row_id_ == '0')
		{
			document.getElementById('show0').value=show;
			hepsi(row_count,'show');
			goster(show);
			document.getElementById('odkes_id0').value = odkes_id;
			hepsi(row_count,'odkes_id');
			document.getElementById('comment_pay0').value=comment_pay;
			hepsi(row_count,'comment_pay');
			document.getElementById('term0').value=term;
			hepsi(row_count,'term');
			document.getElementById('start_sal_mon0').value=start_sal_mon;
			hepsi(row_count,'start_sal_mon');
			document.getElementById('end_sal_mon0').value=end_sal_mon;
			hepsi(row_count,'end_sal_mon');
			document.getElementById('amount_pay0').value=amount_pay;
			hepsi(row_count,'amount_pay');
		}else{
			document.getElementById('odkes_id_0').value = odkes_id;
			document.getElementById('comment_pay_0').value=comment_pay;
		}
	}
	function from_project(row_count,baslangic)
	{
		hepsi(row_count,"project_head",baslangic);
		hepsi(row_count,'project_id',baslangic);
	}
		
	function add_row2()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
					
		document.getElementById('record_num').value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus"></i></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" id="empno' + row_count +'" name="empno' + row_count +'"  readonly value=""></div>';
		
		<cfif is_employee_identity eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" id="tc_identity' + row_count +'" name="tc_identity' + row_count +'"  readonly value=""></div>';
		</cfif>

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.whiteSpace = 'nowrap';
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="employee_in_out_id' + row_count +'" name="employee_in_out_id' + row_count +'" style="width:10px;" value="employee_in_out_id#currentrow#"><input type="text" id="employee' + row_count +'" name="employee' + row_count +'"  onFocus="AutoComplete_Create(\'employee'+ row_count +'\',\'MEMBER_NAME\',\'MEMBER_PARTNER_NAME3\',\'get_member_autocomplete\',\'3\',\'EMPLOYEE_ID,IN_OUT_ID,BRANCH_DEPT\',\'employee_id' + row_count +',employee_in_out_id' + row_count +',department' + row_count +'\',\'my_week_timecost\',3,116);" style="width:120px;" value=""><span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable(\'<cfoutput>#request.self#?fuseaction=hr.popup_list_emp_in_out</cfoutput>&draggable=1<cfif is_employee_identity eq 1>&field_tcno=tc_identity'+ row_count +'</cfif>&field_in_out_id=employee_in_out_id'+row_count+'&field_emp_name=employee'+ row_count + '&field_emp_id=employee_id'+ row_count + '&field_emp_no=empno' + row_count + '&field_branch_and_dep=department'+ row_count + '\' );"></span><input type="hidden" value="" name="odkes_id' + row_count + '" id="odkes_id' + row_count + '" /><input  type="hidden" id="employee_id' + row_count +'"  value=""  name="employee_id' + row_count +'"><input  type="hidden"  value="1" id="row_kontrol_' + row_count +'"  name="row_kontrol_' + row_count +'"></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" id="department' + row_count +'" name="department' + row_count +'"  readonly value=""></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","show_img" + row_count);
		if(is_payment != 1)
			newCell.innerHTML = '<i class="fa fa-check-square"></i>';
		
		if(document.add_ext_salary.show0.value==0 && is_payment == 0)/* eklerken satırı show0 değerini göre resim gözüksün gözükmesin ayarı*/
		{
			satir=eval("show_img"+row_count);
			satir.style.display='none';
			show_img_baslik2.style.display='none';			
		}
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.style.whiteSpace = 'nowrap';
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" id="show' + row_count +'" name="show' + row_count +'" value="0"><input type="text" id="comment_pay' + row_count +'" name="comment_pay' + row_count +'" style="width:120px;" onfocus="AutoComplete_Create(\'comment_pay'+row_count+'\',\'COMMENT_PAY\',\'COMMENT_PAY,ODKES_ID\',\'get_additional_allowance\',\'\',\'ODKES_ID\',\'odkes_id'+row_count+'\',\'\',\'3\',\'150\',true,\'from_odenek(row_count)\');" autocomplete="on" value=""><span class="input-group-addon icon-ellipsis btnPointer" onClick="send_odenek('+row_count+');"></span></div></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="term' + row_count +'" id="term' + row_count +'" style="width:100%"><cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif year(now()) eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="start_sal_mon' + row_count +'" name="start_sal_mon' + row_count +'" style="width:100%;" onchange="change_mon(\'end_sal_mon'+row_count+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select id="end_sal_mon' + row_count +'" name="end_sal_mon' + row_count +'" style="width:100%;"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input id="amount_pay' + row_count +'" name="amount_pay' + row_count +'" type="text" style="width:90px;" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));" onchange="convert_val(this)"></div>';
		
		<cfif is_project_allowance eq 1>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div clas="form-group"><div class="input-group"><input type="hidden" name="project_id' + row_count +'" id="project_id' + row_count +'" value=""><input name="project_head' + row_count +'" type="text" id="project_head' + row_count +'"  onfocus="AutoComplete_Create(\'project_head' + row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD,FULLNAME\',\'get_project\',\'\',\'PROJECT_ID\',\'project_id' + row_count +'\',\'\',\'3\',\'150\',true,\'\');" value=""><span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=add_ext_salary.project_head' + row_count +'&project_id=add_ext_salary.project_id' + row_count +'\');"></span></div></div>';
			from_project(row_count,row_count);
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="process_stage_' + row_count +'"  id="process_stage' + row_count +'"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select></div>';
		

		hepsi(row_count,'show',row_count);
		hepsi(row_count,'comment_pay',row_count);
		hepsi(row_count,'term',row_count);
		hepsi(row_count,'start_sal_mon',row_count);
		hepsi(row_count,'end_sal_mon',row_count);
		hepsi(row_count,'amount_pay',row_count);
		hepsi(row_count,'odkes_id',row_count);
		
		odenek_text = document.getElementById('document.add_ext_salary.comment_pay' + row_count);
		return true;
	}
	function send_odenek(row_count)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_odenek&draggable=1&row_id_='+ row_count);
	}
	function kontrol()
	{
		document.getElementById('record_num').value=row_count;
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53082.Ek Ödenek'>");
			return false;
		}
		for(var i=1;i<=row_count;i++)
		{
			 if(eval("document.add_ext_salary.amount_pay"+i).value.length == 0)
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='53610.Ödenek'>");
					return false;
				}
		}
		for(var i=1;i<=row_count;i++)
		{
			nesne=eval("document.add_ext_salary.amount_pay"+i);
			nesne.value=filterNum(nesne.value);
		}
		return true;
	}
	function change_mon(id,i)
	{
		$('#'+id).val(i);
	}	
	function change_filter(){//Ek Ödenek Kopyalama Div'i için eklenmiştir. 20191001ERU
		if(add_ext_salary_search.copy.checked == true){
			copy_div.style.display = '';
			special_code.style.display = 'none';
			row_count = 1;
		}else{
			special_code.style.display = '';
			copy_div.style.display = 'none';
		}
	}
	function control(){//Ek Ödenek Kopyalama İşlemi ise Özel Kod, Çalışma Durumu, Başlangıç Ve Bitiş tarihleri boşaltılıyor.
		if(add_ext_salary_search.copy.checked == true){
			document.getElementById("hierarchy").value  = '';
			document.getElementById("inout_statue").value  = '';
			document.getElementById("startdate").value  = '';
			document.getElementById("finishdate").value  = '';
		}else{
			document.getElementById("odkes_id_0").value  = '';
			document.getElementById("comment_pay_0").value  = '';
		
			document.getElementById("start_sal_mon_0").value  = '';	
			document.getElementById("end_sal_mon_0").value  = '';
		}
	}
	$('.multip-select').select2();
    function convert_val(val_){
        val_.value = commaSplit(parseFloat(filterNum(val_.value)));
    }
    
</script>
