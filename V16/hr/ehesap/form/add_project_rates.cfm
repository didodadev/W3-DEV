
<cfset payroll_accounts= createObject("component","V16.hr.ehesap.cfc.payroll_accounts_code") />
<cfset get_code_cat=payroll_accounts.GET_CODE_CAT()/>

<cf_box title="#getLang('','Proje Muhasebe Oranları',47184)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="accounts" action="#request.self#?fuseaction=ehesap.emptypopup_add_project_rates">
		<input name="record_num" id="record_num" type="hidden" value="0">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
				<div class="form-group" id="item-period_code_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54117.Muhasebe Kod Grubu'></label>
					<div class="col col-8 col-xs-12">
						<select name="period_code_cat" id="period_code_cat">
							<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="get_code_cat">
								<option value="#payroll_id#">#definition#</option>
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
									<option value="#this_#" <cfif this_ eq session.ep.period_year>selected</cfif>>#this_#</option>
								</cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-sal_mon">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58724.Ay"></label>
					<div class="col col-8 col-xs-12">
						<select name="sal_mon" id="sal_mon">
							<cfloop from="1" to="#listlen(ay_list())#" index="j">
								<cfoutput>
									<option value="#j#"cf>#listgetat(ay_list(),j,',')#</option>
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
					<th width="100">&nbsp;<cf_get_lang dictionary_id='58456.Oran'> *</th>
				</tr>
			</thead>
			<tbody id="link_table">
			</tbody>
		</cf_flat_list>
		<cf_box_footer>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('accounts' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	row_count=0;
	function sil(sy)
	{
		var my_element=eval("document.accounts.row_kontrol_"+sy);
		my_element.value=0;
		var my_element=eval("my_row_"+sy);
		my_element.style.display="none";
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
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" name="project_head'+ row_count +'" id="project_head'+ row_count +'" onFocus="autocomp_project('+row_count+');" value="" class="boxtext"><span class="input-group-addon icon-ellipsis" title="<cf_get_lang dictionary_id="57734.Seçiniz">" onClick="pencere_ac_project('+ row_count +');"></span></div></div>';
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
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'>");
			return false;
		}
		if(row_count == 0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57483.Kayıt'>");
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
					alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="58456.Oran">');
					return false;
				}
			}
		}
		return true;
	}	
</script>