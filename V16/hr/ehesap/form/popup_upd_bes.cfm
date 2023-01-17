<cf_xml_page_edit fuseact="ehesap.popup_form_upd_bes_hr">
<cfparam name="attributes.related_year" default="#year(now())#">
<cfparam name="attributes.modal_id" default="">
<cfquery name="GET_DET" datasource="#dsn#">
	SELECT
		*
	FROM
		SALARYPARAM_BES
	WHERE
        TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_year#"> 
		AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	ORDER BY
		TERM,
		START_SAL_MON
</cfquery>
<cfquery name="GET_DET_EMP" datasource="#dsn#">
	SELECT
		DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) AS AGE,
		EMPLOYEE_ID
	FROM
	EMPLOYEES_IDENTY
	WHERE
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	GROUP BY EMPLOYEE_ID,
	BIRTH_DATE
</cfquery>
<cf_box title="#getLang('','Otomatik Bes',59344)# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_form" method="post" action="#request.self#?fuseaction=ehesap.popup_form_upd_bes_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#">
		<cf_box_search more="0">
			<div class="form-group">
				<select name="related_year" id="related_year">
					<cfloop from="#year(now())+2#" to="2008" index="i" step="-1">
					<cfoutput>
						<option value="#i#"<cfif attributes.related_year eq i> selected</cfif>>#i#</option>
					</cfoutput>
					</cfloop>
				</select>
			</div>
			<div class="form-group">
				<!--- Ücret Odenek Ajaxından --->
				<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
					<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
					<label id="ajax_label" style="display:none!important;"></label>
					<cf_wrk_search_button button_type="4" search_function="ajax_function()">
				<cfelse>
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#">
				</cfif>
			</div>
		</cf_box_search>
	</cfform>
	<cfform name="form_basket" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_form_upd_bes_hr">
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
		<input type="hidden" name="emp_age" id="emp_age" value="<cfoutput>#GET_DET_EMP.Age#</cfoutput>">
		<input type="hidden" name="rowCount" id="rowCount" value="">
		<input type="hidden" name="rowCount_sabit" id="rowCount_sabit" value="<cfoutput>#GET_DET.recordcount#</cfoutput>">
		<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
			<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
		</cfif>
		<cfif isdefined("attributes.draggable") and attributes.draggable eq 1>
			<input type="hidden" name="draggable" id="draggable" value="1">
		</cfif>
		<cf_grid_list id="table_list">
			<thead>
				<tr>
				<th width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_bes');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				<th width="150"><cf_get_lang dictionary_id='58233.Tanım'></th>
				<th width="65"><cf_get_lang dictionary_id='53310.Period'></th>
				<th width="65"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
				<th width="65"><cf_get_lang dictionary_id='57502.Bitiş'></th>
				<th width="115"><cf_get_lang dictionary_id='45126.BES Oranı'></th>
				</tr>
			</thead>
			<cfoutput query="GET_DET" group="TERM">
				<tbody id="my_div_#term#">
					<cfoutput>
						<tr id="sabit_my_row_#currentrow#" title="<cfif len(record_date)>Kayıt : #get_emp_info(record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif>  <cfif len(update_date)> &nbsp;&nbsp;&nbsp;&nbsp; Güncelleme : #get_emp_info(update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)</cfif>">
							<td><a onClick="sabit_sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
							<td>
								<input type="hidden" name="sabit_spb_id#currentrow#" id="sabit_spb_id#currentrow#" value="#SPB_ID#">
								<input type="hidden" name="sabit_row_kontrol_#currentrow#" id="sabit_row_kontrol_#currentrow#" value="1">
								<input type="hidden" name="sabit_comment_bes_id#currentrow#" id="sabit_comment_bes_id#currentrow#" value="#comment_bes_id#">
								<input type="text" name="sabit_comment_bes#currentrow#" id="sabit_comment_bes#currentrow#" style="width:150px;" <cfif find('"',comment_bes)>value='#comment_bes#'<cfelse>value="#comment_bes#"</cfif> readonly>
							</td>
							<td>
								<select name="sabit_term#currentrow#" id="sabit_term#currentrow#" style="70">
									<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j">
										<option value="#j#" <cfif term eq j>selected</cfif>>#j#</option>
									</cfloop>
								</select>
							</td>
							<td>
								<select name="sabit_start_sal_mon#currentrow#" id="sabit_start_sal_mon#currentrow#" style="width:65px;" onchange="change_mon('sabit_end_sal_mon#currentrow#',this.value);">
									<cfloop from="1" to="12" index="j">
										<option value="#j#"<cfif start_sal_mon eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
									</cfloop>
								</select>
							</td>
							<td>
								<select name="sabit_end_sal_mon#currentrow#" id="sabit_end_sal_mon#currentrow#" style="width:65px;">
									<cfloop from="1" to="12" index="j">
										<option value="#j#"<cfif end_sal_mon eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="sabit_amount_bes#currentrow#" id="sabit_amount_bes#currentrow#" style="width:100px;" class="moneybox" value="#TLFormat(rate_bes,2)#" onkeyup="return(FormatCurrency(this,event,2));"></td>
						</tr>
					</cfoutput>
				</tbody>
			</cfoutput>
		</cf_grid_list>
		<cfquery name="get_recorder" dbtype="query" maxrows="1">
			SELECT
				*
			FROM
				GET_DET
			WHERE
				UPDATE_EMP IS NOT NULL
			ORDER BY UPDATE_DATE DESC
		</cfquery>
		<cf_box_footer>
			<cfif get_recorder.recordcount><cf_record_info query_name="get_recorder"></cfif>
			<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
rowCount_sabit = <cfif get_det.recordcount><cfoutput>#get_det.recordcount#</cfoutput><cfelse>0</cfif>;
rowCount = 0;
function add_row(comment_bes, term, start_sal_mon, end_sal_mon, amount_bes, row_id_,comment_bes_id,modal_id)
{
	rowCount++;
	var newRow;
	var newCell;
	newRow = table_list.insertRow();
	newRow.className = 'color-row';
	newRow.setAttribute("name","my_row_" + rowCount);
	newRow.setAttribute("id","my_row_" + rowCount);		
	newRow.setAttribute("NAME","my_row_" + rowCount);
	newRow.setAttribute("ID","my_row_" + rowCount);	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a onClick="sil(' + rowCount + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id="57463.Sil">" alt="<cf_get_lang dictionary_id="57463.Sil">"></i></a><input  type="hidden"  value="1"  name="row_kontrol_' + rowCount +'"><input type="hidden" name="comment_bes_id' + rowCount +'" value="' + comment_bes_id + '">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	if(comment_bes.search('"') > -1)
		newCell.innerHTML = '<input type="text" name="comment_bes' + rowCount +'" style="width:150px;"'+"readonly value='" + comment_bes + "'>";
	else
		newCell.innerHTML = '<input type="text" name="comment_bes' + rowCount +'" style="width:150px;" readonly value="' + comment_bes + '">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="term' + rowCount +'"><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif year(now()) eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="start_sal_mon' + rowCount +'" style="70" onchange="change_mon(\'end_sal_mon'+rowCount+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,",")#</cfoutput></option></cfloop></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="end_sal_mon' + rowCount +'" id="end_sal_mon' + rowCount +'" style="70"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,",")#</cfoutput></option></cfloop></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input name="amount_bes' + rowCount +'" type="text" style="width:100px;" class="moneybox" value="'+amount_bes+'" onkeyup="return(FormatCurrency(this,event,2));">';

	eval("form_basket.start_sal_mon" + rowCount).selectedIndex = start_sal_mon-1;
	eval("form_basket.end_sal_mon" + rowCount).selectedIndex = end_sal_mon-1;
	closeBoxDraggable( modal_id );
	
	return false;
}

function sil(sy)
{
	var my_element=eval("form_basket.row_kontrol_"+sy);
	my_element.value=0;

	var my_element=eval("my_row_"+sy);
	my_element.style.display="none";
}

function sabit_sil(sy)
{
	var my_element=eval("form_basket.sabit_row_kontrol_"+sy);
	my_element.value=0;

	var my_element=eval("sabit_my_row_"+sy);
	my_element.style.display="none";
}

function kontrol()
{
		form_basket.rowCount.value = rowCount;
		
		for (i=0; i < rowCount; i++)
			{
				var k = i + 1;
				 if(eval("form_basket.amount_bes" + k).value.length == 0)
					{
					alert("<cf_get_lang dictionary_id='59670.Otomatik BES Tanımı Girmelisiniz'>!");
					return false;
					}				
			}
		
		for (m=0; m < rowCount; m++)
			{
				var c = m + 1;
				eval("form_basket.amount_bes" + c).value = filterNum(eval("form_basket.amount_bes" + c).value,4);
			}
		
		for (i=0; i < rowCount_sabit; i++)
			{
				var k = i + 1;
				 if(eval("form_basket.sabit_amount_bes" + k).value.length == 0)
					{
					alert("<cf_get_lang dictionary_id='59670.Otomatik BES Tanımı Girmelisiniz'>!");
					return false;
					}				
			}
		for (m=0; m < rowCount_sabit; m++)
			{
				var c = m + 1;
				eval("form_basket.sabit_amount_bes" + c).value = filterNum(eval("form_basket.sabit_amount_bes" + c).value,4);
			}
		var xml_bes_age = <cfoutput>#xml_bes_definition_age#</cfoutput>;
		var emp_age_ = $('#emp_age').val();

		if (emp_age_ > xml_bes_age)
		{
			alert("<cfoutput>#getlang('','Çalışan Yaşı','40114')#</cfoutput>" + xml_bes_age + " <cfoutput>#getlang('','yaşından büyük olduğu için Bes sistemine dahil edilemez','64067')#</cfoutput>");
			return false;
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

		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_bes_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>&from_upd_salary=1&related_year='+related_year,'ajax_right');

		return false;
	}
</script>