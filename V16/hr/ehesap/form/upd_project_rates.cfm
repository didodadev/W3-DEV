
<cfquery name="get_project_rate" datasource="#dsn#">
	SELECT * FROM PROJECT_ACCOUNT_RATES WHERE PROJECT_RATE_ID = #attributes.project_rate_id#
</cfquery>
<cfset payroll_accounts= createObject("component","V16.hr.ehesap.cfc.payroll_accounts_code") />
<cfset get_code_cat=payroll_accounts.GET_CODE_CAT(payroll_id : iif(isdefined("get_project_rate.ACCOUNT_BILL_TYPE"),"get_project_rate.ACCOUNT_BILL_TYPE",DE('')))/>
<cfquery name="get_project_rate_rows" datasource="#dsn#">
	SELECT (SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PRO_PROJECTS.PROJECT_ID=PROJECT_ACCOUNT_RATES_ROW.PROJECT_ID) PROJECT_HEAD,* FROM PROJECT_ACCOUNT_RATES_ROW WHERE PROJECT_RATE_ID = #attributes.project_rate_id#
</cfquery>

<cf_box title="#getLang('','Proje Muhasebe Oranları',47184)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="accounts" action="#request.self#?fuseaction=ehesap.emptypopup_upd_project_rates">
		<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_project_rate_rows.recordcount#</cfoutput>">
		<input name="project_rate_id" id="project_rate_id" type="hidden" value="<cfoutput>#attributes.project_rate_id#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
				<div class="form-group" id="item-period_code_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54117.Muhasebe Kod Grubu'></label>
					<div class="col col-8 col-xs-12">
						<select name="period_code_cat" id="period_code_cat">
							<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
							<cfoutput query="get_code_cat">
								<option value="#payroll_id#" <cfif payroll_id eq get_project_rate.account_bill_type>selected</cfif>>#definition#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-sal_year">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58455.Yıl"></label>
					<div class="col col-8 col-xs-12">
						<select name="sal_year" id="sal_year">
							<cfloop from="-5" to="5" index="ccc">
								<cfset this_ = session.ep.period_year + ccc>
								<cfoutput>
									<option value="#this_#" <cfif this_ eq get_project_rate.year>selected</cfif>>#this_#</option>
								</cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-sal_mon">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58724.Ay"></label>
					<div class="col col-8 col-xs-12">
						<select name="sal_mon" id="sal_mon">
							<cfloop from="1" to="12" index="j">
								<cfoutput>
									<option value="#j#" <cfif j eq get_project_rate.month>selected</cfif>>#listgetat(ay_list(),j,',')#</option>
								</cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="25"><a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<th width="400">&nbsp;<cf_get_lang dictionary_id='57416.Proje'> *</th>
					<th width="100">&nbsp;<cf_get_lang dictionary_id='58456.Oran'>*</th>
				</tr>
			</thead>
			<tbody id="link_table">
				<cfoutput query="get_project_rate_rows">
					<tr id="my_row_#currentrow#">
						<td nowrap="nowrap"><input type="hidden" value="1" name="row_kontrol_#currentrow#" id="row_kontrol_#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
						<td nowrap="nowrap">
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#get_project_rate_rows.project_id#">
									<input type="text" name="project_head#currentrow#" id="project_head#currentrow#" onFocus="autocomp_project('#currentrow#');" value="#project_head#" class="boxtext">
									<span class="input-group-addon icon-ellipsis" onClick="pencere_ac_project('#currentrow#');" title="<cf_get_lang dictionary_id='57734.Seçiniz'>"></span>								
								</div>
							</div>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="rate#currentrow#" id="rate#currentrow#" value="#tlformat(get_project_rate_rows.rate)#" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox">
							</div>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_flat_list>
		<cf_box_footer>
			<div class="col col-6 col-xs-12">
				<cf_record_info query_name="get_project_rate">
			</div>
			<div class="col col-6 col-xs-12">
				<cf_workcube_buttons add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('accounts' , #attributes.modal_id#)"),DE(""))#" is_upd="1" del_function="#isDefined('attributes.draggable') ? 'deleteFunc()' : ''#">
			</div>
		</cf_box_footer>
	</cfform>
</cf_box>

<script type="text/javascript">
	row_count=<cfoutput>#get_project_rate_rows.recordcount#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("document.accounts.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
		row_count--;
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
		document.accounts.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_'+ row_count +'" value="1" /><a onclick="sil(' + row_count + ');" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project_head'+ row_count +'" id="project_head'+ row_count +'" onFocus="autocomp_project('+row_count+');" value="" class="boxtext"><span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="rate' + row_count +'" id="rate' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event,2));" class="moneybox"></div>';
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=accounts.project_id' + no +'&project_head=accounts.project_head' + no +'');
	}
	function autocomp_project(no)
	{
		AutoComplete_Create("project_head"+no,"PROJECT_HEAD","PROJECT_HEAD","get_project","","PROJECT_ID","project_id"+no,"",3,200);
	}
	function kontrol()
	{
		document.accounts.record_num.value=row_count;
		if(document.accounts.period_code_cat.value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>");
			return false;
		}
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='34016.Lütfen Kayıt Giriniz'>!");
			return false;
		}
		for(var j=1;j<=row_count;j++)
		{
			if(eval('document.accounts.row_kontrol_'+j+'.value')==1)
			{
				if(eval('document.accounts.project_id'+j+'.value') == '' || eval('document.accounts.project_head'+j+'.value') == '')
				{
					alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="57416.Proje">');
					return false;
				}
				if(eval('document.accounts.rate'+j+'.value') == '')
				{
					alert('<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="58456.Oran">');
					return false;
				}
			}
		}
		return true;
	}
	<cfif isDefined('attributes.draggable')>
		function deleteFunc() 
		{
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_project_rates&project_rate_id=#attributes.project_rate_id#</cfoutput>',<cfoutput>#attributes.modal_id#</cfoutput>);
		}
	</cfif>	
</script>