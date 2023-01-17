<cfquery name="GET_CARES" datasource="#dsn#">
	SELECT
		CARE_STATES.CARE_ID,
		CARE_STATES.PERIOD_ID,
		CARE_STATES.PERIOD_TIME,
		CARE_STATES.PROCESS_TYPE,
		CARE_STATES.INS_COMPANY_ID,
		CARE_STATES.POLICY_NUM,
		CARE_STATES.AGENCY_NUM,
		COMPANY.NICKNAME
	FROM 
		CARE_STATES,
		COMPANY
	WHERE
		CARE_STATES.CARE_ID IS NOT NULL 
		AND CARE_STATES.ASSET_ID = #attributes.assetp_id#
		AND CARE_STATES.IS_DETAIL = 1
		AND CARE_STATES.INS_COMPANY_ID = COMPANY.COMPANY_ID
	UNION ALL 
	SELECT
		CARE_STATES.CARE_ID,
		CARE_STATES.PERIOD_ID,
		CARE_STATES.PERIOD_TIME,
		CARE_STATES.PROCESS_TYPE,
		CARE_STATES.INS_COMPANY_ID,
		CARE_STATES.POLICY_NUM,
		CARE_STATES.AGENCY_NUM,
		'' AS NICKNAME
	FROM 
		CARE_STATES
	WHERE
		CARE_STATES.INS_COMPANY_ID IS NULL
		AND CARE_STATES.ASSET_ID = #attributes.assetp_id#
		AND CARE_STATES.IS_DETAIL = 1
	ORDER BY CARE_STATES.CARE_ID
</cfquery>
<cfset row = get_cares.recordcount>
<cf_popup_box title="#getLang('assetcare',508)#">
<cfform name="vehicle_insurance" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_vehicle_insurance&assetp_id=#attributes.assetp_id#"> 
<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>"> 
	<cf_form_list>
		<thead>
			<tr id="list_correspondence1_menu2"> 
				<th><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#row#</cfoutput>"><input type="button" class="eklebuton" title="" onClick="add_row();"></th>
                <th><cf_get_lang_main no='388.İşlem Tipi'> *</th>
				<th><cf_get_lang no='509.Sigorta Şirketi'></th>
				<th><cf_get_lang no='242.Poliçe No'></th>
				<th><cf_get_lang no='486.Acenta No'></th>
				<th><cf_get_lang no='81.Periyot'> *</th>
				<th><cf_get_lang_main no='330.Tarih'> *</th>
			</tr>
		</thead>
		<tbody name="table1" id="table1" >
			<cfif get_cares.recordCount>
				<cfoutput query="get_cares"> 
					<tr id="frm_row#currentrow#"> 
                        <td><a style="cursor:pointer" onClick="sil_sor(#currentrow#);"><img  src="images/delete_list.gif" border="0" alt="" align="absmiddle"></a></td>
                        <td> <input type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"> 
                            <select name="process_type#currentrow#" id="process_type#currentrow#" style="width:100px" onChange="goster(#currentrow#);">
                                <option value="1" <cfif get_cares.process_type eq 1>selected</cfif>><cf_get_lang no='289.Kasko'></option>
                                <option value="2" <cfif get_cares.process_type eq 2>selected</cfif>><cf_get_lang no='291.Trafik Sig'></option>
                                <option value="3" <cfif get_cares.process_type eq 3>selected</cfif>><cf_get_lang no='290.Emisyon'></option>
                                <option value="4" <cfif get_cares.process_type eq 4>selected</cfif>><cf_get_lang no='461.Fenni Muayene'></option>
                            </select>
                        </td>
                        <td>
                            <input type="hidden" name="insurance_comp_id#currentrow#" id="insurance_comp_id#currentrow#" value="#ins_company_id#">
                            <input type="text" name="insurance_comp#currentrow#" id="insurance_comp#currentrow#" style="width:125" readonly="yes" <cfif (process_type eq 1) or (process_type eq 2)> value="#nickname#" <cfelse> disabled </cfif>> 
                            <a href="javascript://" onClick="pencere_ac(#currentrow#);"> 
                            <img border="0" src="/images/plus_thin.gif" align="absmiddle" alt=""></a> 
                        </td>
                            <td> <input  type="text"  <cfif (process_type eq 1) or (process_type eq 2)> value="#policy_num#"<cfelse>disabled</cfif> name="policy_num#currentrow#" id="policy_num#currentrow#" style="width:100"> 
                        </td>
                        <td> <input  type="text" name="agency_num#currentrow#" id="agency_num#currentrow#" style="width:100" <cfif (process_type eq 1) or (process_type eq 2)> value="#agency_num#"<cfelse>disabled</cfif>> 
                        </td>
                        <td><select name="care_period#currentrow#" id="care_period#currentrow#" style="width:100" <cfif (process_type eq 1) or (process_type eq 2)> disabled</cfif>>
                                <option value=""></option>
                                <option value="1" <cfif period_id eq 1>selected</cfif>><cf_get_lang no='76.Haftada  Bir'></option>
                                <option value="2" <cfif period_id eq 2>selected</cfif>>15 <cf_get_lang no='77.Günde Bir'></option>
                                <option value="3" <cfif period_id eq 3>selected</cfif>><cf_get_lang no='78.Ayda Bir'></option> 
                                <option value="4" <cfif period_id eq 4>selected</cfif>>2<cf_get_lang no='78.Ayda Bir'></option>    
                                <option value="5" <cfif period_id eq 5>selected</cfif>>3<cf_get_lang no='78.Ayda Bir'></option> 
                                <option value="6" <cfif period_id eq 6>selected</cfif>>4<cf_get_lang no='78.Ayda Bir'></option>
                                <option value="7" <cfif period_id eq 7>selected</cfif>>6<cf_get_lang no='78.Ayda Bir'></option>
                                <option value="8" <cfif period_id eq 8>selected</cfif>><cf_get_lang no='79.Yilda Bir'></option>
                            </select></td>
                        <td> 
                            <input  type="text"  value="#dateFormat(period_time,dateformat_style)#"  name="care_date#currentrow#" id="care_date#currentrow#" style="width:75">	
                            <cf_wrk_date_image date_field="care_date#currentrow#">
                        </td>
					</tr>
				</cfoutput> 
			</cfif>
		</tbody>
	</cf_form_list>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' is_reset='0' is_cancel='0' add_function='son_kontrol()'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
	row_count=<cfoutput>#row#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("document.vehicle_insurance.row_kontrol"+sy);		
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function kontrol_et()
	{
		if(row_count ==0)
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
					
		document.vehicle_insurance.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_sor(' + row_count + ');"><img src="images/delete_list.gif" alt="Sil" border="0" align="absmiddle"></a>';							

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" ><input type="hidden" name="is_upd" value="0"><select name="process_type' + row_count +'" style="width:100px" onChange="goster(' + row_count +');"><option value="1"><cf_get_lang no="289.Kasko"></option><option value="2"><cf_get_lang no="291.Trafik Sig"></option><option value="3"><cf_get_lang no="290.Emisyon"></option><option value="4"><cf_get_lang no="461.Fenni Muayene"></option></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="insurance_comp_id' + row_count +'" value=""><input type="text"  value=""  name="insurance_comp' + row_count +'" style="width:125" readonly><a href="javascript://" onClick="pencere_ac(' + row_count + ');"> <img border="0"  src="/images/plus_thin.gif" alt="" align="absmiddle"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="text"  value=""  name="policy_num' + row_count +'" style="width:100">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<input  type="text"  value=""  name="agency_num' + row_count +'" style="width:100">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML ='<select name="care_period' + row_count + '" style="width:100"><option value=""></option><option value="1"><cf_get_lang no="76.Haftada  Bir"></option><option value="2">15 <cf_get_lang no="77.Günde Bir"></option><option value="3"><cf_get_lang no="78.Ayda Bir"></option><option value="4">2 <cf_get_lang no="78.Ayda Bir"></option><option value="5">3 <cf_get_lang no="78.Ayda Bir"></option><option value="6">4 <cf_get_lang no="78.Ayda Bir"></option><option value="7">6 <cf_get_lang no="78.Ayda Bir"></option><option value="8"><cf_get_lang no="79.Yilda Bir"></option></select>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("id","care_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" name="care_date' + row_count +'" class="text" maxlength="10" style="width:75px;" value="">';
		wrk_date_image('care_date' + row_count);

	}		
	function pencere_ac(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=vehicle_insurance.insurance_comp'+ no +'&field_comp_id=vehicle_insurance.insurance_comp_id' + no ,'medium','popup_list_pars');
	}
	function sil_sor(param)
	{
		if(confirm("<cf_get_lang no ='733.Silme işlemi yapacaksınız Emin misiniz'>?"))
			sil(param);	
		else
			return false;
	}
	/* Trafik sigorta ve kasko seçilmezse ilgili alanlar disabled oluyor. Onur P...*/ 
	function goster(no)
	{
		deger_process_type = eval("document.vehicle_insurance.process_type"+no);
		deger_insurance_comp = eval("document.vehicle_insurance.insurance_comp"+no);
		deger_policy_num = eval("document.vehicle_insurance.policy_num"+no);
		deger_agency_num = eval("document.vehicle_insurance.agency_num"+no);
		deger_care_period = eval("document.vehicle_insurance.care_period"+no);
		if(deger_process_type.value == 1 || deger_process_type.value == 2)
		{
		deger_insurance_comp.disabled = false ;
		deger_policy_num.disabled = false ;
		deger_agency_num.disabled = false ;
		deger_care_period.disabled = true ;
		}
		else 
		{
		deger_insurance_comp.disabled = true;
		deger_policy_num.disabled = true;
		deger_agency_num.disabled = true;
		deger_care_period.disabled = false;
		}
	}
	/* Silinmiş row'un kontrolünü yapmıyoruz!  Onur P...*/
	function son_kontrol()
	{
		for(i=1;i<row_count+1;i++)
		{
			deger_row_kontrol = eval("document.vehicle_insurance.row_kontrol"+i);
			deger_care_date = eval("document.vehicle_insurance.care_date"+i);
			deger_care_period = eval("document.vehicle_insurance.care_period"+i);
			deger_insurance_comp_id = eval("document.vehicle_insurance.insurance_comp_id"+i);
			deger_policy_num = eval("document.vehicle_insurance.policy_num"+i);
			deger_agency_num = eval("document.vehicle_insurance.agency_num"+i);
			deger_process_type = eval("document.vehicle_insurance.process_type"+i);
			a = deger_care_period.selectedIndex;
			b = deger_process_type.selectedIndex;
			if(deger_row_kontrol.value != 0)
			{
				if(deger_care_period[a].value == "" && (deger_process_type[b].value != 1 && deger_process_type[b].value != 2))
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='81.Periyot'>!");
					return false;
					break;
				}
				
				if(deger_care_date.value == "")
				{
					alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='330.Tarih'>!");
					return false;
					break;
				}
				
				if(!CheckEurodate(deger_care_date.value,'<cf_get_lang no ="744.Tarih alanı">'))
				{
					return false;
					break;
				}
			}
			deger_insurance_comp_id.disabled = false ;
			deger_policy_num.disabled = false ;
			deger_agency_num.disabled = false ;
			deger_care_period.disabled = false ;
		}
	} 
</script>

