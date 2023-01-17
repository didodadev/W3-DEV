<cfparam name="attributes.related_year" default="#year(now())#">
<cfquery name="GET_DET" datasource="#dsn#">
	SELECT
		*
	FROM
		SALARYPARAM_EXCEPT_TAX
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_year#">
		AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>

<cf_box title="#getLang('','Vergi İstisnaları',53085)# #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">	
	<cfform name="search_form" method="post" action="#request.self#?fuseaction=ehesap.popup_form_upd_vergi_istisna_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#">
		<cf_box_search more="0">
			<cfoutput>
				<div class="form-group">
					<select name="related_year" id="related_year">
						<cfloop from="#year(now())+2#" to="2008" index="i" step="-1">
						<cfoutput>
							<option value="#i#"<cfif attributes.related_year eq i> selected</cfif>>#i#</option>
						</cfoutput>
						</cfloop>
					</select>
				</div>
			</cfoutput>
			<div class="form-group">
				<!--- Ücret Odenek Ajaxından --->
				<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
					<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
					<label id="ajax_label" style="display:none!important;"></label>
					<cf_wrk_search_button button_type="4" search_function="ajax_function()">
				<cfelse>
					<cf_wrk_search_button button_type="4" search_function="loadPopupBox('search_form' ,  #attributes.modal_id#)">
				</cfif>
			</div>
		</cf_box_search>
	</cfform>
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_form_upd_vergi_istisna_hr">
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
		<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
		<input type="hidden" name="rowCount" id="rowCount" value="<cfoutput>#get_det.recordcount#</cfoutput>">
		<input type="hidden" name="related_year" id="related_year" value="<cfoutput>#attributes.related_year#</cfoutput>">
		<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
			<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
		</cfif>
		<cfif isdefined("attributes.draggable") and attributes.draggable eq 1>
			<input type="hidden" name="draggable" id="draggable" value="1">
		</cfif>
		<cf_grid_list id="table_list">
			<thead>
				<tr>
					<th width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_tax_exception')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<th width="20"></th>
					<th width="200"><cf_get_lang dictionary_id='58233.Tanım'></th>
					<th width="50"><cf_get_lang dictionary_id='58455.Yıl'></th>
					<th width="75"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
					<th width="75"><cf_get_lang dictionary_id='57502.Bitiş'></th>
					<th width="125"  style="text-align:right;"><cf_get_lang dictionary_id='53396.Rakam'></th>
				</tr>
			</thead>
			<cfoutput query="GET_DET">
				<tbody id="my_div_#term#">
					<tr id="my_row_#currentrow#">
						<td><a style="cursor:pointer;" onClick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
						<td>
						<input type="hidden" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#" value="1">
						<input type="hidden" name="calc_days#currentrow#" id="calc_days#currentrow#" value="#calc_days#">
						<input type="hidden" name="yuzde_sinir#currentrow#" id="yuzde_sinir#currentrow#" value="#yuzde_sinir#">
						<input type="hidden" name="is_all_pay#currentrow#" id="is_all_pay#currentrow#" value="<cfif is_all_pay eq 1>1<cfelse>0</cfif>">
						<input type="hidden" name="is_isveren#currentrow#" id="is_isveren#currentrow#" value="<cfif is_isveren eq 1>1<cfelse>0</cfif>">
						<input type="hidden" name="is_ssk#currentrow#" id="is_ssk#currentrow#" value="<cfif is_ssk eq 1>1<cfelse>0</cfif>">
						<input type="hidden" name="exception_type#currentrow#" id="exception_type#currentrow#" value="<cfif len(exception_type)>#exception_type#</cfif>">
						<img border="0" src="/images/b_ok.gif">
						</td>
						<td><input type="text" name="tax_exception#currentrow#" id="tax_exception#currentrow#" style="width:200px;" value="#tax_exception#" readonly></td>
						<td><select name="term#currentrow#" id="term#currentrow#">
								<cfloop from="#year(now())+2#" to="#year(now())-1#" index="i" step="-1">
								<cfoutput>
									<option value="#i#"<cfif term eq i> selected</cfif>>#i#</option>
								</cfoutput>
								</cfloop>
							</select>
						</td>
						<td>
						<select name="start_sal_mon#currentrow#" id="start_sal_mon#currentrow#" style="75" onchange="change_mon('end_sal_mon#currentrow#',this.value);">
							<cfloop from="1" to="12" index="j">
							<option value="#j#"<cfif start_month eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
							</cfloop>
						</select>
						</td>
						<td>
						<select name="end_sal_mon#currentrow#" id="end_sal_mon#currentrow#" style="75">
							<cfloop from="1" to="12" index="j">
							<option value="#j#"<cfif finish_month eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
							</cfloop>
						</select>
						</td>
						<td><input type="text" name="amount#currentrow#" id="amount#currentrow#" class="moneybox" style="width:125px;" value="#TLFormat(amount)#" onkeyup="return(FormatCurrency(this,event));"></td>
					</tr>
				</tbody>
			</cfoutput>
		</cf_grid_list>
		<cfquery name="get_recorder" dbtype="query" maxrows="1">
			SELECT
				*
			FROM
				GET_DET
			WHERE
				RECORD_EMP IS NOT NULL
			ORDER BY RECORD_DATE DESC
		</cfquery>
		<cf_box_footer>
			<cfif get_recorder.recordcount><cf_record_info query_name="get_recorder"></cfif>
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function='check_form()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	rowCount = <cfif get_det.recordcount><cfoutput>#get_det.recordcount#</cfoutput><cfelse>0</cfif>;
	function add_row(tax_exception, term, start_sal_mon, end_sal_mon, amount, calc_days, yuzde_sinir,tamamini_ode,is_isveren,is_ssk,exception_type,row_id_,tax_exception_id,modal_id_)
	{
		rowCount++;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
		newRow.className = 'color-row';
		newRow.setAttribute("name","my_row_" + rowCount);
		newRow.setAttribute("id","my_row_" + rowCount);		
		newRow.setAttribute("NAME","my_row_" + rowCount);
		newRow.setAttribute("ID","my_row_" + rowCount);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a onClick="sil(' + rowCount +')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';	
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML+= '<input  type="hidden"  value="1"  name="row_kontrol_' + rowCount +'">';
		newCell.innerHTML+= '<input type="Hidden" name="calc_days' + rowCount +'" value="' + calc_days + '">';
		newCell.innerHTML+= '<input type="Hidden" name="yuzde_sinir' + rowCount +'" value="' + yuzde_sinir + '"><input type="Hidden" name="is_all_pay' + rowCount +'" value="' + tamamini_ode + '"><input type="Hidden" name="is_ssk' + rowCount +'" value="' + is_ssk + '"><input type="hidden" name="is_isveren' + rowCount +'" value="' + is_isveren + '"><input type="hidden" name="exception_type' + rowCount +'" value="' + exception_type + '">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="tax_exception' + rowCount +'" style="width:200px;" readonly value="' + tax_exception + '">';
	
		newCell = newRow.insertCell(newRow.cells.length);

		newCell.innerHTML = '<select name="term' + rowCount +'"><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif attributes.related_year eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="start_sal_mon' + rowCount +'" style="75" onchange="change_mon(\'end_sal_mon'+rowCount+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="end_sal_mon' + rowCount +'" id="end_sal_mon' + rowCount +'" style="75"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option></cfloop></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input name="amount' + rowCount +'" type="text" class="moneybox" style="width:125px;" value="'+amount+'" onkeyup="return(FormatCurrency(this,event));">';
	
		eval("form_basket.start_sal_mon" + rowCount).selectedIndex = start_sal_mon-1;
		eval("form_basket.end_sal_mon" + rowCount).selectedIndex = end_sal_mon-1;

		closeBoxDraggable( modal_id_);
		
		return true;
	}
	function sil(sy)
	{
		var my_element=eval("form_basket.row_kontrol_"+sy);
		my_element.value=0;
	
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
	}
	function check_form()
	{
	form_basket.rowCount.value = rowCount;
		for (i=1; i <= rowCount; i++)
			{
					if(eval("form_basket.amount" + i).value.length == 0)
					{
					alert("<cf_get_lang dictionary_id ='54122.İstisna Girmelinisiz'>!");
					return false;
					}				
			}
		for (m=1; m <= rowCount; m++)
			{
				eval("form_basket.amount" + m).value = filterNum(eval("form_basket.amount" + m).value);
			}
		<cfif isdefined("attributes.draggable") and attributes.draggable eq 1>
			loadPopupBox('form_basket' , <cfoutput>#attributes.modal_id#</cfoutput>);
			return false;
		<cfelse>
			return true;
		</cfif>
	}
	function change_mon(id,i)
	{
		$('#'+id).val(i);
	}
	function ajax_function()
	{
		related_year = $("#related_year").val();

		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_vergi_istisna_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>&from_upd_salary=1&related_year='+related_year,'ajax_right');

		return false;
	}
</script>
