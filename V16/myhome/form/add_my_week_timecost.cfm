<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
	<tr>
	  <td class="headbold" height="35"><cf_get_lang dictionary_id='32311.Haftam'></td>
	</tr>
	<tr class="color-border">
		<td>
			<table width="100%" align="center" height="100%" cellpadding="2" cellspacing="1">
				<cfform name="my_week_timecost" method="post" action="#request.self#?fuseaction=myhome.add_my_week_timecost">	
					<tr class="color-row">
					  <td valign="top">
					  <div id="cc" style="position:absolute;width:100%;height:99%; z-index:88; overflow:auto;">
						<table name="table1" id="table1" class="color-border" border="0" cellpadding="0" cellspacing="1">
							<tr class="color-header" height="20">
								<td><input name="record_num" id="record_num" type="hidden" value="0">
									<input type="button" class="eklebuton" title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row();"></td>
								<td class="form-title" width="110" nowrap><cf_get_lang dictionary_id='57629.Açıklama'>*</td>
								<td class="form-title" width="75" nowrap><cf_get_lang dictionary_id='57576.Çalışan'></td>
								<td class="form-title" width="90" nowrap><cf_get_lang dictionary_id='57490.Gün'></td>
								<td class="form-title" width="40" nowrap><cf_get_lang dictionary_id='57491.Saat'></td>
								<td class="form-title" width="40" nowrap><cf_get_lang dictionary_id='58827.Dk'></td>
								<td class="form-title" width="125" nowrap><cf_get_lang dictionary_id='57416.Proje'></td>
								<td class="form-title" width="125" nowrap><cf_get_lang dictionary_id='57656.Servis'></td>
								<td class="form-title" width="125" nowrap><cf_get_lang dictionary_id='31065.Toplantı'></td>
								<td class="form-title" width="125" nowrap><cf_get_lang dictionary_id='58460.Masraf Merkezi'></td>
								<td class="form-title" width="125" nowrap><cf_get_lang dictionary_id='57519.Cari Hesap'></td>
								<td class="form-title" width="125" nowrap><cf_get_lang dictionary_id='58445.İş'></td>
								<td class="form-title" width="125" nowrap><cf_get_lang dictionary_id='58832.Abone'></td>
								<td class="form-title" width="125" nowrap><cf_get_lang dictionary_id='57419.Eğitim'></td>
							</tr>
						</table>
						<br/>
							<cf_workcube_buttons is_upd='0' add_function='kontrol_et()'>
						</div>
						</td>
					</tr>
				</cfform>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("my_week_timecost.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function kontrol_et()
	{
		if(row_count ==0) return false;
		else return true;
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
		newRow.className = 'color-row';
		document.my_week_timecost.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="comment' + row_count +'" style="width:100px;" class="boxtext">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="emloyee' + row_count +'" value="<cfoutput>#session.ep.name#&nbsp;#session.ep.surname#</cfoutput>" readonly style="width:75px;" class="boxtext">';
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell.setAttribute("id","today" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="today' + row_count +'" class="text" maxlength="10" style="width:75px;" value="<cfoutput>#DateFormat(Now(),dateformat_style)#</cfoutput>" validate="#validate_style#" required="yes" class="boxtext">';
		wrk_date_image('today' + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="total_time_hour' + row_count +'" style="width:40;" class="boxtext" onKeyup="return(FormatCurrency(this,event,0));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="total_time_minute' + row_count +'" style="width:40;" class="boxtext">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" value=""><input type="text" name="project'+ row_count +'" value="" style="width:115px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="service_id' + row_count +'" value=""><input type="text" name="service_head' + row_count +'" value="" style="width:115px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_service('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="event_id' + row_count +'" value=""><input type="text" name="event_head' + row_count +'" value="" style="width:115px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_event('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="expense_id' + row_count +'" value=""><input type="text" name="expense' + row_count +'" value="" style="width:115px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_expense('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="consumer_id' + row_count +'" value=""><input type="hidden" name="partner_id' + row_count +'" value=""><input type="hidden" name="company_id' + row_count +'" value=""><input type="text" name="member_name' + row_count +'" value="" style="width:115px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="work_id' + row_count +'" value=""><input type="text" name="work_head' + row_count +'" value="" style="width:115px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_work('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="subscription_id' + row_count +'" value=""><input type="text" name="subscription_no' + row_count +'" style="width:115px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_subscription('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="class_id' + row_count +'" value=""><input type="text" name="class_name' + row_count +'" style="width:115px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_class('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=my_week_timecost.project_id' + no +'&project_head=my_week_timecost.project' + no);
	}
	function pencere_ac_service(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_crm&field_id=my_week_timecost.service_id' + no +'&field_name=my_week_timecost.service_head' + no,'list');
	}
	function pencere_ac_event(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_event&field_id=my_week_timecost.event_id' + no +'&field_name=my_week_timecost.event_head' + no,'list');
	}
	function pencere_ac_expense(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=my_week_timecost.expense_id' + no +'&field_name=my_week_timecost.expense' + no,'list');
	}
	function pencere_ac_work(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=my_week_timecost.work_id' + no +'&field_name=my_week_timecost.work_head' + no,'list');
	}
	function pencere_ac_subscription(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=my_week_timecost.subscription_id' + no +'&field_no=my_week_timecost.subscription_no' + no,'list');
	}
	function pencere_ac_class(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_training_classes&field_id=my_week_timecost.class_id' + no +'&field_name=my_week_timecost.class_name' + no,'list');
	}
	function pencere_ac_company(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_consumer=my_week_timecost.consumer_id' + no +'&field_comp_id=my_week_timecost.company_id' + no +'&field_member_name=my_week_timecost.member_name' + no +'&field_partner=my_week_timecost.partner_id' + no,'list');
	}
</script>

