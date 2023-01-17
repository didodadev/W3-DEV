<!--- sistem kampanya ilişkili kayıt eklemek içindir --->
<cfsetting showdebugoutput="no"><!--- ajax sayfa oldg. için --->
<cfquery name="get_related_camp" datasource="#dsn3#">
	SELECT * FROM CAMPAIGN_RELATION WHERE SUBSCRIPTION_ID = #attributes.relation_info_id#
</cfquery>
<cfform name="form_camp_relation" method="post" action="#request.self#?fuseaction=objects.emptypopup_camp_relation_act">
	<input type="hidden" name="record_num_camp" id="record_num_camp" value="<cfoutput>#get_related_camp.recordcount#</cfoutput>">
	<input type="hidden" name="system_id" id="system_id" value="<cfoutput>#attributes.relation_info_id#</cfoutput>">
	<cf_flat_list>
		<thead>
			<tr>
				<th width="20"><a onClick="add_row_camp();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				<th><cf_get_lang dictionary_id='57446.Kampanya'></th>
				<th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
				<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
			</tr>
		</thead>
		<tbody id="table_rel_camp">
			<cfoutput query="get_related_camp">
				<tr name="frm_row_camp_#currentrow#" id="frm_row_camp_#currentrow#">
					<td>
						<input type="hidden" name="row_kontrol_camp_#currentrow#" id="row_kontrol_camp_#currentrow#" value="1">
						<a onclick="sil_camp(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
					</td>
					<td><cfquery name="get_camp_name" datasource="#dsn3#">
							SELECT * FROM CAMPAIGNS WHERE CAMP_ID = #get_related_camp.camp_id#
						</cfquery>
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="rel_camp_id#currentrow#" id="rel_camp_id#currentrow#" value="<cfif isdefined('get_related_camp.camp_id') and len(get_related_camp.camp_id)>#get_related_camp.camp_id#</cfif>">
								<input type="text" name="rel_camp_name#currentrow#" id="rel_camp_name#currentrow#" value="#get_camp_name.camp_head#">
								<span class="input-group-addon btn_Pointer icon-ellipsis" onClick="pencere_ac('#currentrow#');"></span>
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<div class="input-group">
								<cfinput type="text" name="start_date#currentrow#" value="#dateformat(get_related_camp.start_date,dateformat_style)#" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date#currentrow#"></span>
							</div>
						</div>
					</td>
					<td>
						<div class="form-group">
							<div class="input-group">
								<cfinput type="text" name="finish_date#currentrow#" value="#dateformat(get_related_camp.finish_date,dateformat_style)#" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date#currentrow#"></span>
							</div>
						</div>
					</td>
				</tr> 	
			</cfoutput> 
		</tbody>
	</cf_flat_list>
	<cf_box_footer>
		<div id="show_user_message_camp" style="float:left;"></div>
		<cf_workcube_buttons is_upd='0' add_function='rel_kontrol_camp()' is_cancel="0">
	</cf_box_footer>
</cfform>
<script type="text/javascript">
row_count_camp=<cfoutput>#get_related_camp.recordcount#</cfoutput>;
function sil_camp(sy)
{
	var my_element=eval("form_camp_relation.row_kontrol_camp_"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_camp_"+sy);
	my_element.style.display="none";
}
function add_row_camp()
{
	row_count_camp++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_rel_camp").insertRow(document.getElementById("table_rel_camp").rows.length);
	newRow.setAttribute("name","frm_row_camp_" + row_count_camp);
	newRow.setAttribute("id","frm_row_camp_" + row_count_camp);	
	newRow.setAttribute("NAME","frm_row_camp_" + row_count_camp);
	newRow.setAttribute("ID","frm_row_camp_" + row_count_camp);				
	document.form_camp_relation.record_num_camp.value=row_count_camp;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="row_kontrol_camp_'+row_count_camp+'" value="1"><a onclick="sil_camp(' + row_count_camp + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="rel_camp_name'+row_count_camp+'" value=""> <input type="hidden" name="rel_camp_id'+row_count_camp+'" value=""><span class="input-group-addon btn_Pointer icon-ellipsis" onClick="pencere_ac('+row_count_camp+');"></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","start_date" + row_count_camp + "_td");
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="start_date'+row_count_camp+'" id="start_date'+row_count_camp+'" value=""><span class="input-group-addon btn_Pointer" id="sdate_'+row_count_camp+'"></span></div></div>';
	wrk_date_image('start_date' + row_count_camp);
	$('#sdate_'+row_count_camp).append($('#start_date'+row_count_camp+'_image'));

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("id","finish_date" + row_count_camp + "_td");
	newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" id="finish_date'+row_count_camp+'" name="finish_date'+row_count_camp+'" value=""><span class="input-group-addon btn_Pointer" id="fdate_'+row_count_camp+'"></span></div></div>';
	wrk_date_image('finish_date' + row_count_camp);
	$('#fdate_'+row_count_camp).append($('#finish_date'+row_count_camp+'_image'));
}
function pencere_ac(no)
{
	<cfif isdefined("attributes.xml_camp_relation_date") and attributes.xml_camp_relation_date eq 1>
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_campaigns&field_start_date=form_camp_relation.start_date'+no+'&field_finish_date=form_camp_relation.finish_date'+no+'&field_id=form_camp_relation.rel_camp_id'+no+'&field_name=form_camp_relation.rel_camp_name'+no);
	<cfelse>
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_campaigns&field_id=form_camp_relation.rel_camp_id'+no+'&field_name=form_camp_relation.rel_camp_name'+no);
	</cfif>
}

function rel_kontrol_camp()
{
	for(var i=1;i<=row_count_camp;i++)
	{
		if(eval('document.form_camp_relation.row_kontrol_camp_'+i).value == 1)
		{
			if(eval('document.form_camp_relation.rel_camp_id'+i).value == '' || eval('document.form_camp_relation.rel_camp_name'+i).value == '')
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57446.Kampanya'>!");
				return false;
			}
			if (!date_check(eval("document.getElementById('start_date"+ i + "')"), eval("document.getElementById('finish_date" + i + "')") , "Kampanya Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır !"))
				return false;
			for(var j=i+1;j<=row_count_camp;j++)
			{
				if(eval("document.getElementById('start_date"+ i + "')").value != '' && eval("document.getElementById('start_date" + i + "')").value == eval("document.getElementById('start_date" + j + "')").value )
				{
					alert("<cf_get_lang dictionary_id='34310.Aynı Tarihte 2 Kampanyayı İlişkili Olarak Ekleyemezsiniz'>!");
					return false;
				}
			}
		}
	}
	AjaxFormSubmit(form_camp_relation,'show_user_message_camp',0,'<cf_get_lang dictionary_id="58889.Kaydediliyor">','<cf_get_lang dictionary_id="58890.Kaydedildi">');
	return false;
}
</script> 

