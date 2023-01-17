<cfquery name="GET_BRANCH_CAT" datasource="#DSN#">
	SELECT BRANCH_CAT_ID,BRANCH_CAT FROM SETUP_BRANCH_CAT ORDER BY BRANCH_CAT
</cfquery>

<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0
</cfquery>
<cfquery name="GET_RISK_LIMIT_DEFINITION" datasource="#DSN#">
	SELECT 
    	DEFINITION_ID, 
        BRANCH_CAT_ID, 
        COMPANY_CAT_ID, 
        AMOUNT,
		OPENING_UPPER_RISK_LIMIT,
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
    	RISK_LIMIT_DEFINITION 
    ORDER BY 
    	BRANCH_CAT_ID
</cfquery>
<cf_box title="#getLang('','Müşteri Tipleri ve Risk Limiti','63117')#">
    <cfform name="form_risk_limit" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_risk_limit_definition">
		<cf_box_elements>
    	<cf_grid_list name="table1" id="table1">
        	<thead>
                <tr>
                    <th width="30"> <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_risk_limit_definition.recordcount#</cfoutput>"><a title="<cf_get_lang dictionary_id ='57582.Ekle'>" href="javascript://" onclick="add_row();"><i class= "fa fa-plus"></a></th>
                    <th width="140" align="left" class="txtbold"><cf_get_lang dictionary_id ='52480.Şube Tipi'> *</th>
                    <th width="140" align="left" class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'> *</th>
                    <th width="125" class= "text-right" class="txtbold"><cf_get_lang dictionary_id ='57673.Tutar'> *</th>
					<th width="125" class= "text-right" class="txtbold"><cf_get_lang dictionary_id="30729.Açılış Üst Risk Limiti"> *</th>
                </tr>
            </thead>
            <tbody>
				<cfif get_risk_limit_definition.recordCount>
                    <cfoutput query="get_risk_limit_definition">
                        <tr id="frm_row#currentrow#">
                        	<td nowrap><a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(#currentrow#);"><i class="fa fa-minus"> </i>  </a></td>
                            <td nowrap>
                                <input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                <input type="hidden" name="definition_id#currentrow#" id="definition_id#currentrow#" value="#definition_id#">
                                <cfset temp_branch_cat = get_risk_limit_definition.branch_cat_id>
								<div class="form-group">
									<select name="branch_cat#currentrow#" id="branch_cat#currentrow#">
										<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
										<cfloop query="get_branch_cat">
											<option value="#branch_cat_id#" <cfif temp_branch_cat eq get_branch_cat.branch_cat_id> selected</cfif>>#branch_cat#</option>
										</cfloop>
									</select>
								</div>
                            </td>
                            <td nowrap>
                                <cfset temp_companycat_id = get_risk_limit_definition.company_cat_id>
								<div class="form-group">
									<select name="companycat_id#currentrow#" id="companycat_id#currentrow#">
										<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
										<cfloop query="get_company_cat">
											<option value="#companycat_id#" <cfif temp_companycat_id eq get_company_cat.companycat_id> selected</cfif>>#companycat#</option>
										</cfloop>
										<option value="0" <cfif temp_companycat_id eq 0> selected</cfif>><cf_get_lang dictionary_id='58156.Diger'></option>
									</select>
								</div>
                            </td>
                            <td><div class="form-group"><input type="text" name="amount#currentrow#" id="amount#currentrow#" value="#tlformat(get_risk_limit_definition.amount,4)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" style="width:100px;"></div></td>
							<td><div class="form-group"><input type="text" name="opening_upper_risk_limit#currentrow#" id="opening_upper_risk_limit#currentrow#" value="#tlformat(get_risk_limit_definition.opening_upper_risk_limit,4)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" style="width:100px;"></div></td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
		</cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
row_count = <cfoutput>#get_risk_limit_definition.recordcount#</cfoutput>;
function add_row()
{
	row_count++;
	var newRow;
	var newCell;

	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);
				
	document.form_risk_limit.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>" onClick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a>';							
		<cfquery name="GET_BRANCH_CAT" datasource="#DSN#">
	SELECT BRANCH_CAT_ID,BRANCH_CAT FROM SETUP_BRANCH_CAT ORDER BY BRANCH_CAT
</cfquery>
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><input type="hidden" name="definition_id' + row_count +'" value=""><input type="hidden" name="row_kontrol' + row_count +'" value="1"><select name="branch_cat'+ row_count +'" style="width:140px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_branch_cat"><option value="#branch_cat_id#">#branch_cat#</option></cfoutput></select><a href="javascript://" onClick="pencere_ac1('+ row_count +');" style="cursor:pointer;"></a></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<div class="form-group"><select name="companycat_id'+ row_count +'" style="width:140px;"><option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option><cfoutput query="get_company_cat"><option value="#companycat_id#">#companycat#</option></cfoutput><option value="0"><cf_get_lang dictionary_id='58156.Diğer'></option></select></div>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="amount' + row_count +'" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" style="width:100px;">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="opening_upper_risk_limit' + row_count +'" value="" class="moneybox" onKeyUp="return(FormatCurrency(this,event));" style="width:100px;">';
}

function pencere_ac1(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_related_branches&branch_id=form_branch_transfer_definition.branch_id'+ no +'&branch_name=form_branch_transfer_definition.branch'+ no,'list');
}

function sil(sy)
{
	var my_element=eval("document.form_risk_limit.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

function kontrol()
{
	temp_kontrol = 0;
	temp_kontrol_other =0;
	if(document.form_risk_limit.record_num.value > 0)
	{
		for(r=1;r<=document.form_risk_limit.record_num.value;r++)
		{
			if(eval("document.form_risk_limit.row_kontrol"+r).value == 1)
			{
				temp_kontrol ++;
				if(eval("document.form_risk_limit.branch_cat"+r).value == "")
				{
					alert("<cf_get_lang dictionary_id ='52481.Şube Tipi Seçmelisiniz'> !");
					return false;
				}

				if(eval("document.form_risk_limit.companycat_id"+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'>!");
					return false;
				}

				if(eval("document.form_risk_limit.companycat_id"+r).value == 0)
					temp_kontrol_other ++;

				if(eval("document.form_risk_limit.amount"+r).value == "")
				{
					alert("<cf_get_lang_main dictionary_id='54619.Tutar Girmelisiniz'> !");
					return false;
				}
				
				if(eval("document.form_risk_limit.opening_upper_risk_limit"+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='30728.Açılış Üst Risk Limiti Girmelisiniz'>");
					return false;
				}
			}
		}
	}
	
	//diger secenegi n tane olmalı kac tane sube kategorisi varsa
	if(temp_kontrol == 0)
	{
		alert("<cf_get_lang dictionary_id ='52482.Risk Limiti Tanımlarını Kontrol Ediniz'> !");
		return false;
	}
	for(r=1;r<=document.form_risk_limit.record_num.value;r++)
	{
		document.getElementById("item-tax_2")
		eval("document.form_risk_limit.amount"+r).value =  filterNum(eval("document.form_risk_limit.amount"+r).value);
		eval("document.form_risk_limit.opening_upper_risk_limit"+r).value =  filterNum(eval("document.form_risk_limit.opening_upper_risk_limit"+r).value);
	}

	return true;
}
</script>
