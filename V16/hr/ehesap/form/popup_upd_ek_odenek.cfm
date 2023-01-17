<cfparam name="attributes.related_year" default="#year(now())#">
<cfset get_payments_cfc = createObject('component','V16.hr.ehesap.cfc.get_payments')>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>

<!--- Ek ödenekler sayfası  Proje bazlı ödenek verilsin mi? XML'i--->
<cfset get_project_allowance = get_fuseaction_property.get_fuseaction_property(
	company_id : session.ep.company_id,
	fuseaction_name : 'ehesap.list_payments',
	property_name : 'is_project_allowance'
)>
<cfif get_project_allowance.recordcount gt 0 and get_project_allowance.PROPERTY_VALUE eq 1>
	<cfset is_project_allowance = 1>
<cfelse>
	<cfset is_project_allowance = 0>
</cfif>
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process_stage = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.popup_form_upd_odenek_hr')>

<cfquery name="GET_DET" datasource="#dsn#">
	SELECT
		SSK_EXEMPTION_TYPE,
		*
	FROM
		SALARYPARAM_PAY
	WHERE
        TERM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_year#"> 
		AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
	ORDER BY
		TERM,
		START_SAL_MON
</cfquery>
<cfquery name="GET_EMP_DET" datasource="#dsn#">
	SELECT
		*
	FROM
	 EMPLOYEES_IN_OUT EIO
	 LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
	WHERE
        EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
		AND (EIO.FINISH_DATE IS NOT NULL AND E.EMPLOYEE_STATUS = 0)
</cfquery>

<cf_box id="search" title="#getLang('','Ek Ödenekler',53399)# #get_emp_info(attributes.employee_id,0,0)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_form" id="search_form" method="post" action="#request.self#?fuseaction=ehesap.popup_form_upd_odenek_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#">
		<cf_box_search more="0">
			<cfoutput>
				<div class="form-group">
					<select name="monthField" id="monthField" style="width:65px;" onchange="filterMonth()">
						<option value=""><cf_get_lang dictionary_id ='58724.Ay'></option>
						<cfloop from="1" to="12" index="j">
							<option value="#j#">#listgetat(ay_list(),j,',')#</option>
						</cfloop>
					</select>
				</div>
			</cfoutput>
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
					<cf_wrk_search_button button_type="4" search_function="loadPopupBox('search_form' ,  #attributes.modal_id#)">
				</cfif>
			</div>
		</cf_box_search>
	</cfform>
	<cfform name="form_basket" id="form_basket" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_form_upd_odenek_hr">
		<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
		<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
		<input type="hidden" name="rowCount" id="rowCount" value="">

		<cfif isdefined("attributes.from_upd_salary") and attributes.from_upd_salary eq 1>
			<input type="hidden" name="from_upd_salary" id="from_upd_salary" value="1">
		</cfif>
		<cfif isdefined("attributes.draggable") and attributes.draggable eq 1>
			<input type="hidden" name="draggable" id="draggable" value="1">
		</cfif>
		<input type="hidden" name="rowCount_sabit" id="rowCount_sabit" value="<cfoutput>#GET_DET.recordcount#</cfoutput>">
		<cf_grid_list id="table_list">
			<thead>
				<tr>
					<cfif not get_emp_det.recordCount><th width="20"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_list_odenek&draggable=1<cfif isdefined("attributes.use_ssk") and len(attributes.use_ssk)>&use_ssk=#attributes.use_ssk#</cfif></cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th></cfif>
					<th colspan="2"><cf_get_lang dictionary_id='53179.Bordro'>/<cf_get_lang dictionary_id='58233.Tanım'></th>
					<th><cf_get_lang dictionary_id ='54032.Net/Brüt'></th>
					<th><cf_get_lang dictionary_id ='58714.SGK'></th>
					<th><cf_get_lang dictionary_id ='53332.Vergi'></th>
					<th><cf_get_lang dictionary_id ='54121.Damga'></th>
					<th><cf_get_lang dictionary_id ='54120.İşsizlik'></th>
					<th><cf_get_lang dictionary_id ='53310.Periyod'></th>
					<th><cf_get_lang dictionary_id ='29472.Yöntem'></th>
					<th width="75"><cf_get_lang dictionary_id ='58472.Dönem'></th>
					<th width="75"><cf_get_lang dictionary_id ='57501.Başlangıç'></th>
					<th width="75"><cf_get_lang dictionary_id ='57502.Bitiş'></th>
					<th><cf_get_lang dictionary_id ='53396.Rakam'></th>
					<th></th>
					<th width="75"><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<cfif is_project_allowance eq 1><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
					<th><cf_get_lang dictionary_id ='58859.Süreç'></th>
				</tr>
			</thead>
			<cfoutput query="GET_DET" group="TERM">
				<tbody id="my_div_#term#">
					<cfoutput>
						<tr id="sabit_my_row_#currentrow#" title="<cfif len(record_date)>Kayıt : #get_emp_info(record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</cfif>  <cfif len(update_date)> &nbsp;&nbsp;&nbsp;&nbsp; Güncelleme : #get_emp_info(update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#)</cfif>">
						<cfif not get_emp_det.recordCount><td><cfif is_ehesap neq 1 or session.ep.ehesap><a style="cursor:pointer;" onClick="sabit_sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></cfif></td></cfif>
						<td>
							<div class="form-group">
								<input type="hidden" name="sabit_money#currentrow#" id="sabit_money#currentrow#" value="#money#">
								<input type="hidden" name="sabit_spp_id#currentrow#" id="sabit_spp_id#currentrow#" value="#spp_id#">
								<input type="hidden" name="sabit_row_kontrol_#currentrow#" id="sabit_row_kontrol_#currentrow#" value="1">
								<input type="hidden" name="sabit_is_income#currentrow#" id="sabit_is_income#currentrow#" value="#is_income#">
								<input type="hidden" name="sabit_is_not_execution#currentrow#" id="sabit_is_not_execution#currentrow#" value="#is_not_execution#">
								<input type="hidden" name="sabit_comment_type#currentrow#" id="sabit_comment_type#currentrow#" value="#comment_type#">
								<input type="hidden" name="sabit_factor_type#currentrow#" id="sabit_factor_type#currentrow#" value="#factor_type#">
								<input type="hidden" name="sabit_ssk#currentrow#" id="sabit_ssk#currentrow#" value="#ssk#">
								<input type="hidden" name="sabit_tax#currentrow#" id="sabit_tax#currentrow#" value="#tax#">
								<input type="hidden" name="sabit_is_damga#currentrow#" id="sabit_is_damga#currentrow#" value="#is_damga#">
								<input type="hidden" name="sabit_is_issizlik#currentrow#" id="sabit_is_issizlik#currentrow#" value="#is_issizlik#">
								<input type="hidden" name="sabit_is_ehesap#currentrow#" id="sabit_is_ehesap#currentrow#" value="<cfif is_ehesap eq 1>1<cfelse>0</cfif>">
								<input type="hidden" name="sabit_is_kidem#currentrow#"  id="sabit_is_kidem#currentrow#" value="#is_kidem#">
								<input type="hidden" name="sabit_period_pay#currentrow#" id="sabit_period_pay#currentrow#" value="#period_pay#">
								<input type="hidden" name="sabit_calc_days#currentrow#" id="sabit_calc_days#currentrow#" value="#calc_days#">
								<input type="hidden" name="sabit_comment_pay_id#currentrow#" id="sabit_comment_pay_id#currentrow#" value="#comment_pay_id#">
								<input type="hidden" name="sabit_ssk_exemption_rate#currentrow#" id="sabit_ssk_exemption_rate#currentrow#" value="#ssk_exemption_rate#">
								<input type="hidden" name="sabit_tax_exemption_rate#currentrow#" id="sabit_tax_exemption_rate#currentrow#" value="#tax_exemption_rate#">
								<input type="hidden" name="sabit_ssk_exemption_type#currentrow#" id="sabit_ssk_exemption_type#currentrow#" value="#ssk_exemption_type#">
								<input type="hidden" name="sabit_is_ayni_yardim#currentrow#" id="sabit_is_ayni_yardim#currentrow#" value="<cfif is_ayni_yardim eq 1>1<cfelse>0</cfif>">
								<input type="hidden" name="sabit_is_rd_damga#currentrow#" id="sabit_is_rd_damga#currentrow#" value="<cfif is_rd_damga eq 1>1<cfelse>0</cfif>">
								<input type="hidden" name="sabit_is_rd_gelir#currentrow#" id="sabit_is_rd_gelir#currentrow#" value="<cfif is_rd_gelir eq 1>1<cfelse>0</cfif>">
								<input type="hidden" name="sabit_is_rd_ssk#currentrow#" id="sabit_is_rd_ssk#currentrow#" value="<cfif is_rd_ssk eq 1>1<cfelse>0</cfif>">
								<cfif show eq 1>
									<img border="0" src="/images/b.gif" align="absmiddle" title="Bordro">
								</cfif>
								<cfif is_ayni_yardim eq 1>
									<img border="0" src="/images/ok_list.gif" align="absmiddle" title="Ayni Yardım">
								</cfif>
								<input type="hidden" name="sabit_show#currentrow#" id="sabit_show#currentrow#" value="#show#">
							</div>
						</td>
						<td><div class="form-group">	<input type="text" name="sabit_comment_pay#currentrow#" id="sabit_comment_pay#currentrow#" style="width:150px;" <cfif find('"',comment_pay)>value='#comment_pay#'<cfelse>value="#comment_pay#"</cfif> readonly></div></td>
						<td><div class="form-group"><input type="hidden" name="sabit_from_salary#currentrow#" id="sabit_from_salary#currentrow#" value="#from_salary#">
							<cfif from_salary eq 1>
								Brüt
							<cfelseif from_salary eq 0>
								Net
							</cfif></td>
						</td>
						<td><div class="form-group"><cfif ssk eq 1><cf_get_lang dictionary_id='53401.Muaf'><cfelseif ssk eq 2><cf_get_lang dictionary_id='53402.Muaf Değil'></cfif></div></td>
						<td><div class="form-group"><cfif tax eq 1><cf_get_lang dictionary_id='53401.Muaf'><cfelseif tax eq 2><cf_get_lang dictionary_id='53402.Muaf Değil'></cfif></div></td>
						<td><div class="form-group"><cfif is_damga eq 1><cf_get_lang dictionary_id='53402.Muaf Değil'><cfelseif is_damga eq 0><cf_get_lang dictionary_id='53401.Muaf'></cfif></div></td>
						<td><div class="form-group"><cfif is_issizlik eq 1><cf_get_lang dictionary_id='53402.Muaf Değil'><cfelseif is_issizlik eq 0><cf_get_lang dictionary_id='53401.Muaf'></cfif></div></td>
						<td><div class="form-group"><cfif period_pay eq 1><cf_get_lang dictionary_id='53311.Ayda'><cfelseif period_pay eq 2>3 <cf_get_lang dictionary_id='53311.Ayda'><cfelseif period_pay eq 3>6 <cf_get_lang dictionary_id='53311.Ayda'><cfelseif period_pay eq 4><cf_get_lang dictionary_id='53312.Yılda'></cfif> 1</div></td>
						<td><div class="form-group"><input type="hidden" name="sabit_method_pay#currentrow#" id="sabit_method_pay#currentrow#" value="#method_pay#" />
							<cfif method_pay eq 1>
								<cf_get_lang dictionary_id='53136.Artı'>
							<cfelseif method_pay eq 2>
								% Ay
							<cfelseif method_pay eq 3>
								% Gün
							<cfelseif  method_pay eq 4>
								% Saat
							</cfif></div>
						</td>
						<td>
							<div class="form-group">
								<select name="sabit_term#currentrow#" id="sabit_term#currentrow#" style="70">
									<cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j">
										<option value="#j#" <cfif term eq j>selected</cfif>>#j#</option>
									</cfloop>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="sabit_start_sal_mon#currentrow#" id="sabit_start_sal_mon#currentrow#" style="width:65px;" onchange="change_mon('sabit_end_sal_mon#currentrow#',this.value);">
									<cfloop from="1" to="12" index="j">
										<option value="#j#"<cfif start_sal_mon eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
									</cfloop>
								</select>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="sabit_end_sal_mon#currentrow#" id="sabit_end_sal_mon#currentrow#" style="width:65px;">
									<cfloop from="1" to="12" index="j">
										<option value="#j#"<cfif end_sal_mon eq j> selected</cfif>>#listgetat(ay_list(),j,',')#</option>
									</cfloop>
								</select>
							</div>
						</td>
						<td><div class="form-group"><input type="text" name="sabit_amount_pay#currentrow#" id="sabit_amount_pay#currentrow#" style="width:100px;" class="moneybox" value="#TLFormat(amount_pay,2)#" onkeyup="return(FormatCurrency(this,event,2));"></div></td>
						<td style="<cfif (term[currentrow] neq term[currentrow-1] and currentrow neq 1) or (term[currentrow] neq term[currentrow+1])> border_bottom:0px; border-top:0px;</cfif>"><div class="form-group">#money#</div></td>
						<td><div class="form-group"><input type="text" name="sabit_detail#currentrow#" id="sabit_detail#currentrow#" value="#detail#"></div></td>
						<cfif is_project_allowance eq 1>
								<td nowrap="nowrap">
									<div clas="form-group">
										<div class="input-group">
											<cfif len(project_id)>
												<cfset project_head = get_payments_cfc.get_project(project_id)>
											</cfif>
											<input type="hidden" name="sabit_project_id#currentrow#" id="sabit_project_id#currentrow#" value="#project_id#">
											<input name="sabit_project_head#currentrow#" type="text" id="sabit_project_head#currentrow#"  onfocus="AutoComplete_Create('sabit_project_head#currentrow#','PROJECT_HEAD','PROJECT_HEAD,FULLNAME','get_project','','PROJECT_ID','sabit_project_id#currentrow#','','3','150',true,'');" value="<cfif len(project_id)>#project_head.PROJECT_HEAD#</cfif>">
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=add_ext_salary.sabit_project_head#currentrow#&project_id=add_ext_salary.sabit_project_id#currentrow#');"></span>
										</div>
									</div>
								</td>
							</cfif>
							<td>
								<cf_workcube_process is_upd='0' select_value='#PROCESS_STAGE#' process_cat_width='188' is_detail='1' select_name="sabit_process_stage#currentrow#">
							</td>
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
			<cfif not get_emp_det.recordCount><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></cfif>
		</cf_box_footer>
	</cfform>
</cf_box>

<script type="text/javascript">
rowCount_sabit = <cfif get_det.recordcount><cfoutput>#get_det.recordcount#</cfoutput><cfelse>0</cfif>;
rowCount = 0;
function add_row(is_damga,is_issizlik,ssk,tax,is_kidem,show,comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,from_salary,row_id_,is_ehesap,is_ayni_yardim,SSK_EXEMPTION_RATE,TAX_EXEMPTION_RATE,TAX_EXEMPTION_VALUE,money,comment_pay_id,SSK_EXEMPTION_TYPE,is_income,comment_type,factor_type,is_not_execution,is_rd_damga,is_rd_gelir,is_rd_ssk)
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
	newCell.innerHTML = '<a onClick="sil(' + rowCount + ');"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id="57463.Sil">" border="0"></i></a>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol_' + rowCount +'"><input type="Hidden" name="ssk' + rowCount +'" value="' + ssk + '">';
	newCell.innerHTML+= '<input type="hidden" name="tax' + rowCount +'" value="' + tax + '">';
	newCell.innerHTML+= '<input type="hidden" name="money' + rowCount +'" value="' + money + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_damga' + rowCount +'" value="' + is_damga + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_income' + rowCount +'" value="' + is_income + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_not_execution' + rowCount +'" value="' + is_not_execution + '">';
	newCell.innerHTML+= '<input type="hidden" name="comment_type' + rowCount +'" value="' + comment_type + '">';
	newCell.innerHTML+= '<input type="hidden" name="factor_type' + rowCount +'" value="' + factor_type + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_issizlik' + rowCount +'" value="' + is_issizlik + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_kidem' + rowCount +'" value="' + is_kidem + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_ehesap' + rowCount +'" value="' + is_ehesap + '">';
	newCell.innerHTML+= '<input type="hidden" name="period_pay' + rowCount +'" value="' + period_pay + '">';
	newCell.innerHTML+= '<input type="hidden" name="method_pay' + rowCount +'" value="' + method_pay + '">';
	newCell.innerHTML+= '<input type="hidden" name="calc_days' + rowCount +'" value="' + calc_days + '">';
	newCell.innerHTML+= '<input type="hidden" name="show' + rowCount +'" value="' + show + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_ayni_yardim' + rowCount +'" value="' + is_ayni_yardim + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_rd_damga' + rowCount +'" value="' + is_rd_damga + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_rd_gelir' + rowCount +'" value="' + is_rd_gelir + '">';
	newCell.innerHTML+= '<input type="hidden" name="is_rd_ssk' + rowCount +'" value="' + is_rd_ssk + '">';
	newCell.innerHTML+= '<input type="hidden" name="ssk_exemption_rate' + rowCount +'" value="' + SSK_EXEMPTION_RATE + '">';
	newCell.innerHTML+= '<input type="hidden" name="ssk_exemption_type' + rowCount +'" value="' + SSK_EXEMPTION_TYPE + '">';
	newCell.innerHTML+= '<input type="hidden" name="TAX_EXEMPTION_RATE' + rowCount +'" value="' + TAX_EXEMPTION_RATE + '">';
	newCell.innerHTML+= '<input type="hidden" name="from_salary' + rowCount +'" value="' + from_salary + '"><input type="hidden" name="comment_pay_id' + rowCount +'" value="' + comment_pay_id + '">';
	if (show == '1')
		newCell.innerHTML+= '<img border="0" src="/images/b.gif" align="absmiddle">';
	if (is_ayni_yardim == '1')
		newCell.innerHTML+= '<img border="0" src="/images/ok_list.gif" align="absmiddle">';
	newCell = newRow.insertCell(newRow.cells.length);
	if(comment_pay.search('"') > -1)
		newCell.innerHTML = '<input type="text" name="comment_pay' + rowCount +'" style="width:150px;"'+"readonly value='" + comment_pay + "'>";
	else
		newCell.innerHTML = '<input type="text" name="comment_pay' + rowCount +'" style="width:150px;" readonly value="' + comment_pay + '">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	if (from_salary == '1')
		newCell.innerHTML = 'Brüt';
	else if (from_salary == '0')
		newCell.innerHTML = 'Net';

	newCell = newRow.insertCell(newRow.cells.length);
	if (ssk == '1')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53401.Muaf'>";
	else if (ssk == '2')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53402.Muaf Değil'>";

	newCell = newRow.insertCell(newRow.cells.length);
	if (tax == '1')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53401.Muaf'>";
	else if (tax == '2')

		newCell.innerHTML = "<cf_get_lang dictionary_id='53402.Muaf Değil'>";
		
	newCell = newRow.insertCell(newRow.cells.length);
	if (is_damga == '0')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53401.Muaf'>";
	else if (is_damga == '1')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53402.Muaf Değil'>";
		
	newCell = newRow.insertCell(newRow.cells.length);
	if (is_issizlik == '0')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53401.Muaf'>";
	else if (is_issizlik == '1')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53402.Muaf Değil'>";

	newCell = newRow.insertCell(newRow.cells.length);
	if (period_pay == '1')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53311.Ayda'>";
	else if (period_pay == '2')
		newCell.innerHTML = "3 <cf_get_lang dictionary_id='53311.Ayda'>";
	else if (period_pay == '3')
		newCell.innerHTML = "6 <cf_get_lang dictionary_id='53311.Ayda'>";
	else if (period_pay == '4')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53312.Yılda'>";
	newCell.innerHTML+= ' 1';

	newCell =  newRow.insertCell(newRow.cells.length);
	if(method_pay == '1')
		newCell.innerHTML = "<cf_get_lang dictionary_id='53136.Artı'>";
	else if(method_pay == '2')
		newCell.innerHTML = "% Ay";
	else if(method_pay == '3')
		newCell.innerHTML = "% Gün";
	else if(method_pay == '4')
		newCell.innerHTML = "% Saat";
		
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="term' + rowCount +'"><cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+2#" index="j"><option value="<cfoutput>#j#</cfoutput>" <cfif year(now()) eq j>selected</cfif>><cfoutput>#j#</cfoutput></option></cfloop></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="start_sal_mon' + rowCount +'" style="70" onchange="change_mon(\'end_sal_mon'+rowCount+'\',this.value);"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,",")#</cfoutput></option></cfloop></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="end_sal_mon' + rowCount +'" id="end_sal_mon' + rowCount +'" style="70"><cfloop from="1" to="12" index="j"><option value="<cfoutput>#j#</cfoutput>"><cfoutput>#listgetat(ay_list(),j,",")#</cfoutput></option></cfloop></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input name="amount_pay' + rowCount +'" type="text" style="width:100px;" class="moneybox" value="'+amount_pay+'" onkeyup="return(FormatCurrency(this,event,2));">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = money;

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input name="detail' + rowCount +'" id = "detail' + rowCount + '" type="text"  value="" >';

	<cfif is_project_allowance eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div clas="form-group"><div class="input-group"><input type="hidden" name="project_id' + rowCount +'" id="project_id' + rowCount +'" value=""><input name="project_head' + rowCount +'" type="text" id="project_head' + rowCount +'"  onfocus="AutoComplete_Create(\'project_head' + rowCount +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD,FULLNAME\',\'get_project\',\'\',\'PROJECT_ID\',\'project_id' + rowCount +'\',\'\',\'3\',\'150\',true,\'\');" value=""><span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=add_ext_salary.project_head' + rowCount +'&project_id=add_ext_salary.project_id' + rowCount +'\');"></span></div></div>';

	</cfif>

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="process_stage' + rowCount +'"  id="process_stage' + rowCount +'"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select></div>';
		

	//eval("form_basket.method_pay" + rowCount).selectedIndex = method_pay-1;
	eval("form_basket.start_sal_mon" + rowCount).selectedIndex = start_sal_mon-1;
	eval("form_basket.end_sal_mon" + rowCount).selectedIndex = end_sal_mon-1;
	//eval("form_basket.term" + rowCount).selectedIndex = term-1;
	
	return true;
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
				 if(eval("form_basket.amount_pay" + k).value.length == 0)
					{
					alert("<cf_get_lang dictionary_id ='54119.Ödenek Girmelinisiz'>!");
					return false;
					}				
			}
		for (m=0; m < rowCount; m++)
			{
				var c = m + 1;
				eval("form_basket.amount_pay" + c).value = filterNum(eval("form_basket.amount_pay" + c).value,4);
			}
			
		for (i=0; i < rowCount_sabit; i++)
			{
				var k = i + 1;
				 if(eval("form_basket.sabit_amount_pay" + k).value.length == 0)
					{
					alert("<cf_get_lang dictionary_id ='54119.Ödenek Girmelinisiz'>!");
					return false;
					}				
			}
		for (m=0; m < rowCount_sabit; m++)
			{
				var c = m + 1;
				eval("form_basket.sabit_amount_pay" + c).value = filterNum(eval("form_basket.sabit_amount_pay" + c).value,4);
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
	function filterMonth(){
		$("#table_list tbody tr").each(function(index,element){
			$(element).css('display','');
		})
		if($("#monthField").val() != ''){
			$("#table_list tbody tr").each(function(index,element){
				if(!(parseFloat($(element).find("select[name*='start_sal_mon']").val()) <= parseFloat($("#monthField").val()) && parseFloat($(element).find("select[name*='end_sal_mon']").val()) >= parseFloat($("#monthField").val())))
					$(element).css('display','none');
			})
		}
	}
	function ajax_function()
	{
		monthField = $("#monthField").val();
		related_year = $("#related_year").val();

		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.popup_form_upd_odenek_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#</cfoutput>&from_upd_salary=1&monthField='+monthField+'&related_year='+related_year,'ajax_right');

		return false;
	}
</script>
