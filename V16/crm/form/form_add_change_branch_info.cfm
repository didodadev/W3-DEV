<!--- Aktarım Islemi Boyunca Her sube Gecisinde  Asagidaki listeye Yeni Subeler Eklenecektir. --->
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH_NAME, 
		BRANCH_ID 
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE 
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND 
		COMPANY_BOYUT_DEPO_KOD.DEPO_KOD_ID NOT IN(26,27,28,29,30,31,0)
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="GET_BRANCH_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES ORDER BY TR_NAME
</cfquery>
<cfquery name="GET_PRO_TYPEROWS" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.popup_form_add_change_branch_info%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cf_box title="#getLang('','Toplu Şube Bilgisi Değiştir',52161)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
   <cfform name="add_change_branch_info" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_change_branch_info">
		<cf_box_elements width="400">			
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='65152.Cari Hesap (Muhasebe) Kodu Aktar'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="is_muhasebe" id="is_muhasebe"></div>
                </div>
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52162.Referans Şube'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="branch_id" id="branch_id">
							<option value=""><cf_get_lang_main no='41.Şube'></option>
							<cfoutput query="get_branch">
								<option value="#branch_id#">#branch_name#</option>
							</cfoutput>
						</select>
                    </div>
                </div>
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52163.Aktarılacak Şube'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="target_branch_id" id="target_branch_id">
							<option value=""><cf_get_lang_main no='41.Şube'></option>
							<cfoutput query="get_branch">
								<option value="#branch_id#">#branch_name#</option>
							</cfoutput>
						</select>
                    </div>
                </div>
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="pro_rows" id="pro_rows">
							<option value=""><cf_get_lang no='562.Süreç Aşaması'></option>
							<cfoutput query="get_pro_typerows">
								<option value="#process_row_id#">#stage#</option>
							</cfoutput>
						</select>
                    </div>
                </div>
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57894.Statü'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="branch_state" id="branch_state">
                            <option value=""><cf_get_lang_main no='482.Statü'></option>
                            <cfoutput query="get_branch_status">
                                <option value="#tr_id#">#tr_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div> 
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.durum'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="is_active" id="is_active">
							<option value="0"><cf_get_lang_main no='82.Pasif'></option>
							<option value="1"><cf_get_lang_main no='81.Aktif'></option>
						</select>
                    </div>
                </div>
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52046.cep sıra'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="text" name="cep_sira" id="cep_sira" value="">
                    </div>
                </div>
				<div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52155.bsm'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="bsm_id" id="bsm_id" value="">
                                <input type="text" name="bsm" id="bsm" readonly="" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_change_branch_info.bsm_id&field_name=add_change_branch_info.bsm&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');">
                                </span>
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfsavecontent variable = "message"><cf_get_lang dictionary_id="32260.Lütfen BSM Boyut Kodunu Sayısal Giriniz !"></cfsavecontent>
                            <cfinput type="text" name="yeni_boyut_bsm" validate="integer" placeHolder="#getLang('','',58674)#" message="#message#" maxlength="3">                            
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfinput name="eski_boyut_bsm" id="eski_boyut_bsm" placeHolder="#getLang('','',53832)#" type="text">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52142.Saha Satış'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="saha_id" id="saha_id" value="">
                            <input type="text" name="saha" id="saha" readonly="" value="">
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_change_branch_info.saha_id&field_name=add_change_branch_info.saha&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');"></span>
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfsavecontent variable = "message"><cf_get_lang dictionary_id="32257.Lütfen Saha Satış Görevlisi Boyut Kodunu Sayısal Giriniz !"></cfsavecontent>
                            <cfinput type="text" name="yeni_boyut_saha" validate="integer" placeHolder="#getLang('','',58674)#" message="#message#" maxlength="3">                            
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfinput name="eski_boyut_saha" id="eski_boyut_saha" placeHolder="#getLang('','',53832)#" type="text">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52156.Telefonla Satış'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="telefon_id" id="telefon_id" value="">
                                <input type="text" name="telefon" id="telefon" readonly="" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_change_branch_info.telefon_id&field_name=add_change_branch_info.telefon&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');"></span>
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfsavecontent variable = "message"><cf_get_lang dictionary_id="33608.Lütfen Telefonla Satış Görevlisi Boyut Kodunu Sayısal Giriniz !"></cfsavecontent>
                            <cfinput type="text" name="yeni_boyut_telefon" validate="integer" placeHolder="#getLang('','',58674)#" message="#message#" maxlength="3">                            
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfinput name="eski_boyut_telefon" id="eski_boyut_telefon" placeHolder="#getLang('','',53832)#" type="text">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57845.Tahsilat'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="tahsilat_id" id="tahsilat_id" value="">
                                <input type="text" name="tahsilat" id="tahsilat" readonly="" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_change_branch_info.tahsilat_id&field_name=add_change_branch_info.tahsilat&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');"></span>
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfsavecontent variable = "message"><cf_get_lang dictionary_id="33607.Lütfen Tahsilat Görevlisi Boyut Kodunu Sayısal Giriniz !"></cfsavecontent>
                            <cfinput type="text" name="yeni_boyut_tahsilat" validate="integer" placeHolder="#getLang('','',58674)#" message="#message#" maxlength="3">                            
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfinput name="eski_boyut_tahsilat" id="eski_boyut_tahsilat" placeHolder="#getLang('','',53832)#" type="text">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52157.Itriyat'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="itriyat_id" id="itriyat_id" value="">
                                <input type="text" name="itriyat" id="itriyat" readonly="" value="">
                                <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_change_branch_info.itriyat_id&field_name=add_change_branch_info.itriyat&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');"></span>                                
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfsavecontent variable = "message"><cf_get_lang dictionary_id="33605.Lütfen Itriyat Görevlisi Boyut Kodunu Sayısal Giriniz !"></cfsavecontent>
                            <cfinput type="text" name="yeni_boyut_itriyat" validate="integer" placeHolder="#getLang('','',58674)#" message="#message#" maxlength="3">                            
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                            <cfinput name="eski_boyut_itriyat" id="eski_boyut_itriyat" placeHolder="#getLang('','',53832)#" type="text">
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='65151.Seçilmiş Olan IMS Kodlarına Gö'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="radio" name="is_type" id="is_type" value="0" checked="checked">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52147.Seçilmiş Olan Müşterilere Göre'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="radio" name="is_type" id="is_type" value="1">
                    </div>
                </div>				
			</div>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_ajax_list>
                        <thead>
                            <tr>								
                                <th width="10"><input name="record_num" id="record_num" type="hidden" value="0"><a href="javascript://" onClick="pencere_ac_company();"><i class="fa fa-plus"></i></a></th>
                                <th><cf_get_lang dictionary_id='58673.Müşteriler'></th>	
                            </tr>
                            <tbody>
                                <tr id="table1">
    
                                </tr>
                            </tbody>
                        </thead>			
                    </cf_ajax_list>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_ajax_list id="table2">
                        <thead>
                            <tr>								
                                <th width="10"><input name="record_num1" id="record_num1" type="hidden" value="0"><a href="javascript://" onClick="add_row1();"><i class="fa fa-plus"></i></a></th>
                                <th><cf_get_lang dictionary_id='52159.IMS Brickleri'></th>	
                            </tr>
                            <tbody>
                                <tr>
    
                                </tr>
                            </tbody>
                        </thead>			
                    </cf_ajax_list>
                </div>
            </div>
		</cf_box_elements>
		<cf_box_footer><cf_workcube_buttons is_upd='0'  add_function="kontrol() && loadPopupBox('add_change_branch_info')"></cf_box_footer>
  </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	x = document.add_change_branch_info.branch_id.selectedIndex;
	if (document.add_change_branch_info.branch_id[x].value == "")
	{ 
		alert ("<cf_get_lang no='718.Lütfen Referans Şubeyi Seçiniz'> !");
		return false;
	}
	x = document.add_change_branch_info.target_branch_id.selectedIndex;
	if (document.add_change_branch_info.target_branch_id[x].value == "")
	{ 
		alert ("<cf_get_lang no='719.Lütfen Hedef Şubeyi Seçiniz'> !");
		return false;
	}
	x = document.add_change_branch_info.pro_rows.selectedIndex;
	if (document.add_change_branch_info.pro_rows[x].value == "")
	{ 
		alert ("<cf_get_lang no='720.Lütfen Süreç-Aşama Seçiniz'> !");
		return false;
	}
	x = document.add_change_branch_info.branch_state.selectedIndex;
	if (document.add_change_branch_info.branch_state[x].value == "")
	{ 
		alert ("<cf_get_lang no='721.Lütfen Statü Seçiniz'> !");
		return false;
	}
	x = document.add_change_branch_info.is_active.selectedIndex;
	if (document.add_change_branch_info.is_active[x].value == "")
	{ 
		alert ("<cf_get_lang no='722.Lütfen Durum Seçiniz'> !");
		return false;
	}
	if (document.add_change_branch_info.cep_sira.value == "")
	{ 
		alert ("<cf_get_lang no='723.Lütfen Cep Sira Seçiniz'> !");
		return false;
	}
	if(document.add_change_branch_info.bsm_id != "")
	{
		if(document.add_change_branch_info.yeni_boyut_bsm == "")
		{
			alert("<cf_get_lang no='724.Lütfen Bölge Satış Müdürü Boyut Kodunu Giriniz'> !");
		}
	}
	if(document.add_change_branch_info.saha_id != "")
	{
		if(document.add_change_branch_info.yeni_boyut_saha == "")
		{
			alert("<cf_get_lang no='725.Lütfen Saha Satış Görevlisi Boyut Kodunu Giriniz'> !");
		}
	}
	if(document.add_change_branch_info.telefon_id != "")
	{
		if(document.add_change_branch_info.yeni_boyut_telefon == "")
		{
			alert("<cf_get_lang no='726.Lütfen Telefonla Satış Görevlisi Boyut Kodunu Giriniz'> !");
		}
	}
	if(document.add_change_branch_info.tahsilat_id != "")
	{
		if(document.add_change_branch_info.yeni_boyut_tahsilat == "")
		{
			alert("<cf_get_lang no='581.Lütfen Tahsilat Görevlisi Boyut Kodunu Giriniz'> !");
		}
	}
	if(document.add_change_branch_info.itriyat_id != "")
	{
		if(document.add_change_branch_info.yeni_boyut_itriyat == "")
		{
			alert("<cf_get_lang no='727.Lütfen Itriyat Görevlisi Boyut Kodunu Giriniz'> !");
		}
	}
	loadPopupBox('add_change_branch_info' , <cfoutput>#attributes.modal_id#</cfoutput>);
}
row_count=0;
row_count1=0;
function sil(sy)
{
	var my_element=eval("add_change_branch_info.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}
function sil1(sy)
{
	var my_element1=eval("add_change_branch_info.row_kontrol1"+sy);
	my_element1.value=0;
	var my_element1=eval("frm_row1"+sy);
	my_element1.style.display="none";
}
function kontrol_et()
{
	if(row_count ==0)
		return false;
	else
		return true;
}
function kontrol_et1()
{
	if(row_count1 ==0)
		return false;
	else
		return true;
}
function add_row()
{
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);		
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);		
	document.add_change_branch_info.record_num.value=row_count;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'"><input type="text" name="company_name' + row_count +'" id="company_name' + row_count +'" style="width:160px;"><a href="javascript://" onClick="pencere_ac('+ row_count +');"><img  src="images/plus_thin.gif" border="0" align="absmiddle"></a>';
}
function add_row1()
{
	row_count1++;
	var newRow1;
	var newCell1;
	newRow1 = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
	newRow1.setAttribute("name","frm_row1" + row_count1);
	newRow1.setAttribute("id","frm_row1" + row_count1);		
	newRow1.setAttribute("NAME","frm_row1" + row_count1);
	newRow1.setAttribute("ID","frm_row1" + row_count1);	
	document.add_change_branch_info.record_num1.value=row_count1;
	newCell1 = newRow1.insertCell(newRow1.cells.length);
	newCell1.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol1' + row_count1 +'" id="row_kontrol1' + row_count1 +'" ><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
	newCell1 = newRow1.insertCell(newRow1.cells.length);
	newCell1.innerHTML = '<input type="hidden" name="ims_code_id' + row_count1 +'" id="ims_code_id' + row_count1 +'"><input type="text" name="ims_code_name' + row_count1 +'" id="ims_code_name' + row_count1 +'" style="width:160px;"><a href="javascript://" onClick="pencere_ims('+ row_count1 +');"><img  src="images/plus_thin.gif" border="0" align="absmiddle"></a>';
}
function pencere_ac(no)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&field_comp_id=add_change_branch_info.company_id'+ no +'&field_comp_name=add_change_branch_info.company_name'+ no +'&is_single=1');
}
function pencere_ims(no)
{
	alert('eeeeee');
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_id=add_change_branch_info.ims_code_id'+ no +'&field_name=add_change_branch_info.ims_code_name'+ no );
}
function pencere_ac_company(no)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&record_num_=' + add_change_branch_info.record_num.value +'&is_first=1&is_position=1');
}
</script>

