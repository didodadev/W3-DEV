<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfinclude template="../query/get_mobilcat.cfm">
<cfquery name="GET_COMPANY_PARTNER" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		DEPARTMENT,
		TITLE,
		SEX,
		TC_IDENTITY,
		MOBIL_CODE,
		PARTNER_ID,
		COMPANY_PARTNER_EMAIL,
		MOBILTEL
	FROM 
		COMPANY_PARTNER 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
</cfquery>
<cfset row_count_cf = get_company_partner.recordcount>
<table border="0" cellpadding="2" cellspacing="1" class="color-border" style="width:98%">
	<tr class="color-list">
		<td><a href="javascript:gizle_goster(add_partner_id);gizle_goster(_image_1);gizle_goster(_image_2);"><img src="images\listele.gif" border="0" id="_image_1" style="display:none;"><img src="images\listele_down.gif" border="0" id="_image_2">&nbsp;<font class="txtboldblue"><cf_get_lang dictionary_id ='30224.Diğer Yetkililer'></font></a></td>
	</tr>
	<tr class="color-row" id="add_partner_id">
		<td>
		<cfform name="form_add_partner" method="post" action="#request.self#?fuseaction=member.emptypopup_add_company_partner">  
			<input type="hidden" name="record" id="record" value="<cfoutput>#row_count_cf#</cfoutput>">
			<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
			<table name="table1" id="table1">
				<tr>
					<td class="txtboldblue" style="width:80px;"><cf_get_lang dictionary_id ='57631.Ad'></td>
					<td class="txtboldblue" style="width:80px;"><cf_get_lang dictionary_id ='58726.Soyad'></td>
					<td class="txtboldblue" style="width:80px;"><cf_get_lang dictionary_id ='57571.Ünvan'></td>
					<td class="txtboldblue" style="width:120px;"><cf_get_lang dictionary_id ='57572.Departman'></td>
					<td class="txtboldblue" style="width:60px;"><cf_get_lang dictionary_id ='57764.Cinsiyet'></td>
					<td class="txtboldblue" style="width:80px;"><cf_get_lang dictionary_id='58025.TC Kimlik No'></td>
					<td class="txtboldblue" style="width:50px;"><cf_get_lang dictionary_id ='58585.Kod'></td>
					<td class="txtboldblue" style="width:70px;"><cf_get_lang dictionary_id ='58473.Mobil Tel'></td>
					<td class="txtboldblue" style="width:110px;"><cf_get_lang dictionary_id ='57428.E-Mail'></td>
					<td class="txtboldblue"><input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();"></td>
				</tr>
				<cfoutput query="get_company_partner">
					<tr id="frm_row#currentrow#">
						<td><input type="text" name="name#currentrow#" id="name#currentrow#" value="#company_partner_name#" style="width:80px;"></td>
						<td><input type="text" name="surname#currentrow#" id="surname#currentrow#" value="#company_partner_surname#" style="width:80px;"></td>
						<td><input type="text" name="title#currentrow#" id="title#currentrow#" value="#title#" style="width:80px;"></td>
						<td>
							<select name="department#currentrow#" id="department#currentrow#" style="width:120px;" tabindex="36">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfloop query="get_partner_departments">
									<option value="#partner_department_id#" <cfif get_company_partner.DEPARTMENT EQ partner_department_id>selected</cfif>>#partner_department#</option>
								</cfloop>
							</select>
						</td>
						<td><select name="sex#currentrow#" id="sex#currentrow#" style="width:60px;" tabindex="38">
								<option value="1"<cfif get_company_partner.SEX eq 1>selected</cfif>><cf_get_lang dictionary_id='58959.Erkek'></option>
								<option value="2"<cfif get_company_partner.SEX eq 0>selected</cfif>><cf_get_lang dictionary_id='58958.Kadin'></option>
							</select>
						</td>
						<td><input type="text" name="identity_no#currentrow#" id="identity_no#currentrow#" value="#get_company_partner.tc_identity#" style="width:80px;"></td>
						<td><select name="mobilcat_id_partner#currentrow#" id="mobilcat_id_partner#currentrow#"  style="width:50px;" tabindex="39">
								<option value=""><cf_get_lang dictionary_id='58585.Kod'></option>
								<cfset mobil_code_info = get_company_partner.mobil_code>
								<cfloop query="get_mobilcat">
									<option value="#mobilcat#"<cfif mobil_code_info eq mobilcat>selected</cfif>>#mobilcat#</option>
								</cfloop>
							</select>
						</td>
						<td><input type="text" name="mobiltel_partner#currentrow#" id="mobiltel_partner#currentrow#" maxlength="10" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined('get_company_partner.mobiltel') and len(get_company_partner.mobiltel)>#get_company_partner.mobiltel#</cfif>" style="width:70px;" tabindex="40"></td>
						<td><input type="text" name="email#currentrow#" id="email#currentrow#" validate="email" maxlength="100" style="width:130px;" value="<cfif isdefined('get_company_partner.company_partner_email') and len(get_company_partner.company_partner_email)>#get_company_partner.company_partner_email#</cfif>" tabindex="28"></td>
						<td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1"><a style="cursor:pointer" onclick="sil(#currentrow#);"><img src="images/delete_list.gif" title="<cf_get_lang dictionary_id ='57463.Sil'>" border="0" align="absmiddle"></a></td>
						<td><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#partner_id#" class="tableyazi"><img src="/images/update_list.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='57771.Detay'>"></a></td>
					</tr>
				</cfoutput>
			</table>
			<table border="0">	
				<tr>
                    <td style="width:650px;"></td>
                    <td>
                        <cfif get_company_partner.recordcount>
                        	<cf_workcube_buttons is_upd='1' is_delete='0' add_function='formcontrol()'>
                        <cfelse>
                        	<cf_workcube_buttons is_upd='0' is_delete='0' add_function='formcontrol()'>
                        </cfif>	
                    </td>
                </tr>
			</table>
		</cfform>
		</td>
	</tr>
</table>
<script type="text/javascript">
	row_count=<cfoutput>#row_count_cf#</cfoutput>;
	function add_row()
	{
		row_count=row_count+1;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="name'+ row_count +'" id="name'+ row_count +'" value="" style="width:80px;">';
				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="surname'+ row_count +'" id="surname'+ row_count +'" value="" style="width:80px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="title'+ row_count +'" id="title'+ row_count +'" value="" style="width:80px;">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="department'+row_count+'" id="department'+row_count+'" style="width:120px;" tabindex="36"><option value="">Seçiniz</option><cfoutput query="get_partner_departments"><option value="#partner_department_id#">#partner_department#</option></cfoutput></select>';	
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="sex'+row_count+'" id="sex'+row_count+'" style="width:60px;" tabindex="38"><option value="1">Erkek</option><option value="2">Kadin</option></select>';	

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="identity_no'+ row_count +'" id="identity_no'+ row_count +'" value="" style="width:80px;">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="mobilcat_id_partner'+row_count+'" id="mobilcat_id_partner'+row_count+'"  style="width:50px;" tabindex="39"><option value=""><cf_get_lang dictionary_id='58585.Kod'></option><cfoutput query="get_mobilcat"><option value="#mobilcat#">#mobilcat#</option></cfoutput></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="mobiltel_partner'+row_count+'" id="mobiltel_partner'+row_count+'" maxlength="10" onKeyup="isNumber(this);" onblur="isNumber(this);" value="<cfif isdefined("attributes.mobiltel")><cfoutput>#attributes.mobiltel#</cfoutput></cfif>" style="width:70px;" tabindex="40">';
										
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="email'+row_count+'" id="email'+row_count+'" validate="email" maxlength="100" style="width:130px;" value="" tabindex="28">';
									
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count + '" id="row_kontrol' + row_count + '"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img src="images/delete_list.gif" alt="<cf_get_lang dictionary_id ="57463.Sil">" border="0" align="absmiddle"></a>';
		document.form_add_partner.record.value=row_count;
	}
	function sil(no)
	{
		row_count=row_count-1;
		var my_element=eval("form_add_partner.row_kontrol"+no);
		my_element.value=0;
		
		var my_element=eval("frm_row"+no);
		my_element.style.display="none";
		document.form_add_partner.record.value=row_count;
	}
	function formcontrol()
		{
			if(row_count == 0 && row_count == '')
			{
				alert('<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='30214.En Az bir çalışan'>');
				return false;
			}
			for(i=1;i<=row_count;i++)
			{
				if(eval("document.form_add_partner.name"+i).value == '')
				{
					alert(i+'.<cf_get_lang dictionary_id ='30205.satır Ad Giriniz'>');
					return false;
				}
				else if(eval("document.form_add_partner.surname"+i).value == '')
				{
					alert(i+'.<cf_get_lang dictionary_id ='30207.satır Soyad Giriniz'>');
					return false;
				}
				else if(eval("document.form_add_partner.mission"+i).value == '')
				{
					alert(i+'.<cf_get_lang dictionary_id ='30210.satır Görev Seçiniz'>');
					return false;
				}
				else if(eval("document.form_add_partner.department"+i).value == '')
				{
					alert(i+'.<cf_get_lang dictionary_id ='30213.satır Departman Seçiniz'>');
					return false;
				}
			}
		}
</script>
