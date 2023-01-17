<cfif (month(now()) eq 11) or (month(now()) eq 12)>
	<cfparam name="attributes.start_date" default="#year(now())+1#">
<cfelse>
	<cfparam name="attributes.start_date" default="#year(now())#">
</cfif>
<cfsavecontent variable="right">
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#session.ep.userid#</cfoutput>','project');" class="tableyazi"><img src="/images/quiz_paper.gif" title="<cf_get_lang no ='165.Geçmiş Eğitimler'>"></a>
<cfif get_module_user(3)>
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_dsp_performance_form&emp_id=#session.ep.userid#</cfoutput>','project');" class="tableyazi"><img src="/images/carier.gif" title="<cf_get_lang no ='166.Hedef Yetkinlik Değerlendirme Formu'>"></a>
</cfif>
</cfsavecontent> 
<cf_form_box title="#getLang('training',103)#" right_images="#right#">
	<cfform name="add_class_request" method="post" action="#request.self#?fuseaction=training.emptypopup_add_class_request">
        <table>
            <tr>
                <td><cf_get_lang no ='104.Talep Yılı'>&nbsp;&nbsp;&nbsp;</td>
                <td valign="top" class="txtbold"> :<cfoutput>
                    <cfif (month(now()) eq 11) or (month(now()) eq 12)>
                        <input type="hidden" name="request_year" id="request_year" value="#year(now())+1#">#year(now())+1#
                    <cfelse>
                        <input type="hidden" name="request_year" id="request_year" value="#year(now())#">#year(now())#
                    </cfif>
                    </cfoutput>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>
                <cf_form_list>
                    <thead>
                        <tr>
                            <th colspan="4"><cf_get_lang no ='109.Yetkinlik Gelisim Egitimleri'></th>
                        </tr>
                            <input type="hidden" name="record_num_pos_req" id="record_num_pos_req" value="0">
                        <tr>
                            <th width="15"><input type="button" class="eklebuton" title="" onClick="add_row_pos_req();"></th>				
                            <th><cf_get_lang no ='72.Egitim Adi'></th>
                            <th width="30"><cf_get_lang_main no ='73.Öncellik'></th>
                            <th width="500"><cf_get_lang no ='110.Is Hedefine Katkisi'></th>
                        </tr>
                    </thead>
                    <tbody id="table_pos_req"></tbody>
                </cf_form_list>
                </td>
              </tr>
         </table>
        <cf_form_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function="controlform()"></cf_form_box_footer>
    </cfform>
</cf_form_box>
<form name="year_ch" id="year_ch" action="" method="post">
	<input type="hidden" name="start_date" id="start_date">
</form>
<script type="text/javascript">
function year_change(nesne)
{
	document.year_ch.start_date.value=nesne.value;
	year_ch.submit();
}
var row_count_pos_req=0;
var row_count_tech=0;
function kontrol_pos_req()
{
	var satir=0;
	for(var i=1;i<=row_count_pos_req;i++)
		if(eval("add_class_request.row_kontrol_pos_req"+i).value==1) satir=satir+1;
	<!---if(<cfoutput>#get_trains_standart.recordcount#</cfoutput>+satir >= 3)--->
	if(satir>=3)
	{
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no='147.En Fazla 3 '>-<cf_get_lang no='105.standart eğitim'>/<cf_get_lang no='138.yetkinlik gelişim eğitimi'>!");
		return false;
	}
	return true;
}
function add_row_pos_req()
{
	if(!kontrol_pos_req())return false;
	row_count_pos_req++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_pos_req").insertRow(document.getElementById("table_pos_req").rows.length);
	newRow.className = 'color-row';	
	newRow.setAttribute("name","frm_row_pos_req" + row_count_pos_req);
	newRow.setAttribute("id","frm_row_pos_req" + row_count_pos_req);		
	
	document.add_class_request.record_num_pos_req.value=row_count_pos_req;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_pos_req('+ row_count_pos_req +');"><img  src="/images/delete_list.gif" border="0"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol_pos_req' + row_count_pos_req +'" ><input type="text" readonly name="class_name_pos_req' + row_count_pos_req + '" value="" style="width:200px;"><input type="hidden" name="class_id_pos_req' + row_count_pos_req + '" value=""><a onclick="javascript:open_train('+row_count_pos_req+',1);"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="priority_pos_req' + row_count_pos_req + '" value="" onBlur="control1(' + row_count_pos_req + ');" style="width:30px;" maxlength="2">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<textarea name="work_addition_pos_req' + row_count_pos_req + '" style="width:500px;height:45px;"></textarea>';
}
function sil_pos_req(sy)
{
	var my_element=eval("add_class_request.row_kontrol_pos_req"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_pos_req"+sy);
	my_element.style.display="none";	
}
function add_row_tech()
{
	row_count_tech++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_tech").insertRow(document.getElementById("table_tech").rows.length);
	newRow.className = 'color-row';
	newRow.setAttribute("name","frm_row_tech" + row_count_tech);
	newRow.setAttribute("id","frm_row_tech" + row_count_tech);		
	
	document.add_class_request.record_num_tech.value=row_count_tech;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol_tech' + row_count_tech +'" ><input type="text" name="class_name_tech' + row_count_tech + '" onBlur="tech_id_kontrol('+ row_count_tech +')" value="" style="width:200px;"><input type="hidden" name="class_id_tech' + row_count_tech + '" value=""><a onclick="javascript:open_train('+row_count_tech+',2);"><img src="/images/plus_thin.gif" border="0" align="absmiddle" style="cursor:pointer;"></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="priority_tech' + row_count_tech + '" value="" onBlur="control2(' + row_count_tech + ');" style="width:30px;" maxlength="2">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<textarea name="work_addition_tech' + row_count_tech + '" style="width:200px;height:45;"></textarea>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_pos_tech('+ row_count_tech +');"><img  src="/images/delete_list.gif" border="0"></a>';
}
function sil_pos_tech(sy)
{
	var my_element=eval("add_class_request.row_kontrol_tech"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_tech"+sy);
	my_element.style.display="none";
}
function tech_id_kontrol(st)
{
	var my_element=eval("add_class_request.class_id_tech"+st);
	my_element.value='';
}
function open_train(sy,type)
{
if(type == 1)
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_id=add_class_request.class_id_pos_req'+sy+'&field_name=add_class_request.class_name_pos_req'+sy+'&list_type=1','project');
else
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_id=add_class_request.class_id_tech'+sy+'&field_name=add_class_request.class_name_tech'+sy+'&class_type=2','project');
}
function isSayi(nesne) 
{
	inputStr=nesne.value;
	if(inputStr.length>0)
	{
		var oneChar = inputStr.substring(0,1)
		if (oneChar < "1" ||  oneChar > "9") 
		{
			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang_main no='783.tam sayı'>!");
			nesne.focus();
		}
	}
}
function control1(id)
{
	deger_my_value = eval("document.add_class_request.priority_pos_req"+id);
	if(deger_my_value.value > 3 || deger_my_value.value < 0)
	{
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang no ='149.1 İle 3 Arası'>!");
		deger_my_value.value = "";
	}
	if(deger_my_value.value != "")
	{
		var oneChar = deger_my_value.value.substring(0,1)
		if (oneChar < "1" ||  oneChar > "9") 
		{
			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang_main no='783.tam sayı'>!");
			deger_my_value.value = '';
			deger_my_value.focus();
		}
		else
		{
			for (var r=1;r<=row_count_pos_req;r++)
			{
				deger_row_kontrol = eval("document.add_class_request.row_kontrol_pos_req"+r);
				if(deger_row_kontrol.value == 1)
				{
					if(r != id)
					{
						deger_other_value = eval("document.add_class_request.priority_pos_req"+r);
						if(deger_my_value.value == deger_other_value.value)
						{
							alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='250.alan'> <cf_get_lang_main no='781.tekrarı'>!");
							deger_my_value.value = "";
							break;
						}
					}
				}
			}
		}
	}
}
function control2(id)
{
	deger_my_value = eval("document.add_class_request.priority_tech"+id);
	if(deger_my_value.value > 3 || deger_my_value.value < 0)
	{
		alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang no ='149.1 İle 3 Arası'>!");
		deger_my_value.value = "";
	}
	if(deger_my_value.value != "")
	{
		var oneChar = deger_my_value.value.substring(0,1)
		if (oneChar < "1" ||  oneChar > "9") 
		{
			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='73.Öncelik '>-<cf_get_lang_main no='783.tam sayı'>!");
			deger_my_value.value = '';
			deger_my_value.focus();
		}
		else
		{
			for (var r=1;r<=row_count_tech;r++)
			{
				deger_row_kontrol = eval("document.add_class_request.row_kontrol_tech"+r);
				if(deger_row_kontrol.value == 1)
				{
					if(r != id)
					{
						deger_other_value = eval("document.add_class_request.priority_tech"+r);
						if(deger_my_value.value == deger_other_value.value)
						{
							alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no ='250.alan'> <cf_get_lang_main no='781.tekrarı'>!");
							deger_my_value.value = "";
							break;
						}
					}
				}
			}
		}
	}
}
function controlform()
{
	var sayac=0;
	for (var r=1;r<=row_count_pos_req;r++)
	{
		deger_row_kontrol = eval("document.add_class_request.row_kontrol_pos_req"+r);
		deger_my_value = eval("document.add_class_request.priority_pos_req"+r);
		deger_work_addition_pos_req = eval("document.add_class_request.work_addition_pos_req"+r);
		if(deger_row_kontrol.value == 1)
		{
			if(deger_my_value.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='138.yetkinlik gelişim eğitimi'>-<cf_get_lang_main no ='73.Öncelik '>!");
				return false;
				break;
			}
			if(deger_work_addition_pos_req.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='138.yetkinlik gelişim eğitimi'>-<cf_get_lang no ='110.İş Hedefine Katkısı'> !");
				return false;
				break;
			}
		   sayac++;
		}
	}
	for (var r=1;r<=row_count_tech;r++)
	{
		deger_row_kontrol = eval("document.add_class_request.row_kontrol_tech"+r);
		deger_my_value = eval("document.add_class_request.priority_tech"+r);
		deger_work_addition_tech = eval("document.add_class_request.work_addition_tech"+r);
		if(deger_row_kontrol.value == 1)
		{
			if(deger_my_value.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='121.teknik gelişim eğitimi'>-<cf_get_lang_main no ='73.Öncelik '>!");
				return false;
				break;
			}
			if(deger_work_addition_tech.value == "")
			{
				alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='121.teknik gelişim eğitimi'>-<cf_get_lang no ='110.İş Hedefine Katkısı'>!");
				return false;
				break;
			}
			sayac++;
		}
	}
	if(sayac == 0)
	{alert("Eğitim satırı seçmediniz!");
		return false;
	}
}
</script>
