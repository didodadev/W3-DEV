<cfparam name="attributes.from_our_company" default="">
<cfparam name="attributes.to_our_company" default="">

<cfquery name="get_company" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY
</cfquery>

<table class="dph">
	<tr>
    	<td class="dpht">&nbsp; Üye Aktarım Arayüzü</td>
	</tr>
</table>
<table class="dpm" align="center">
	<tr>
		<td class="dpml" >
			<cfform name="form_transfer" id="form_transfer" method="post" action="">
				<cf_form_box width="100%">
					<table>
						<tr>
							<td>
								<input type="button" name="project_transfer" id="project_transfer" value="Projeleri Aktar">
							</td>
							<td>
								<input type="button" name="baglanti_transfer" id="baglanti_transfer" value="Bağlantı Aktar">
							</td>
							<td>
								<input type="button" name="bakiye_transfer" id="bakiye_transfer" value="Bakiyeleri Aktar">
							</td>
							<td>
								<input type="button" name="teminat_transfer" id="teminat_transfer" value="Teminatları Aktar">
							</td>
							<td>
								<input type="button" name="risc_transfer" id="risc_transfer" value="Risk Bilgilerini Aktar">
							</td>
						</tr>
					</table>
				</cf_form_box>
				<br />
				<cf_form_list width="100%">
					<thead>
						<th>Sıra</th>
						<th>
							Aktarılacak Üye
							<select name="from_our_company" id="from_our_company" style="width:150px;" onchange="delete_company(this.name);"> 
								<option value="">Kaynak Şirket</option> 
								<cfoutput query="get_company">
									<option value="#comp_id#">#nick_name#</option> 
								</cfoutput>
							</select>
						</th>
						<th>&nbsp;</th>
						<th>
							Aktarım Yapılacak Üye
							<select name="to_our_company" id="to_our_company" style="width:150px;" onchange="delete_company(this.name);"> 
								<option value="">Hedef Şirket</option> 
								<cfoutput query="get_company">
									<option value="#comp_id#">#nick_name#</option> 
								</cfoutput>
							</select>
						</th>
					</thead>
					<tbody>
						<cfloop from="1" to="20" index="xx">
							<cfoutput>
							<tr>
								<td>#xx#</td>
								<td>
									<input type="hidden" name="from_company_id_#xx#" id="from_company_id_#xx#" value="">
									<input type="text" name="from_company_name_#xx#" id="from_company_name_#xx#" value="" style="width:250px;" autocomplete="off">	  
									<a href="javascript://" onclick="our_company_control_from(#xx#);">
									<img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
								</td>
								<td>-----></td>
								<td>
									<input type="hidden" name="to_company_id_#xx#" id="to_company_id_#xx#" value="">
									<input type="text" name="to_company_name_#xx#" id="to_company_name_#xx#" value="" style="width:250px;" autocomplete="off">	  
									<a href="javascript://" onClick="our_company_control_to(#xx#);">
									<img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
								</td>
							</tr>
							</cfoutput>
						</cfloop>
					</tbody>
				</cf_form_list>
			</cfform>
		</td>
	</tr>
</table>

<script type="text/javascript">
	function our_company_control_from(sira_no)
	{
		count_from_company = 0;
		for(i=1; i<=20; i++)
			if(document.getElementById('from_company_name_'+i).value != '')
				count_from_company = 1;
		
		if(count_from_company == 0 && document.getElementById('from_our_company').value == '')
		{
			alert("Aktarılacak Üyeler İçin Kaynak Şirket Seçiniz!");
			return false;
		}
		else
		{
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&field_comp_id=form_transfer.from_company_id_'+sira_no+'&field_comp_name=form_transfer.from_company_name_'+sira_no+'&select_list=2&period_id=0;'+document.getElementById("from_our_company").value+';'+document.getElementById("from_our_company").value</cfoutput>,'list');
		}
	}
	function our_company_control_to(sira_no)
	{
		count_to_company = 0;
		for(i=1; i<=20; i++)
			if(document.getElementById('to_company_name_'+i).value != '')
				count_to_company = 1;
		
		if(count_to_company == 0 && document.getElementById('to_our_company').value == '')
		{
			alert("Aktarım Yapılacak Üyeler İçin Hedef Şirket Seçiniz!");
			return false;
		}
		else
		{
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_pars&field_comp_id=form_transfer.to_company_id_'+sira_no+'&field_comp_name=form_transfer.to_company_name_'+sira_no+'&select_list=2&period_id=0;'+document.getElementById("to_our_company").value+';'+document.getElementById("to_our_company").value</cfoutput>,'list');
		}
	}
	function delete_company(comp)
	{
		for(j=1; j<=20; j++)
		{
			if(comp == 'from_our_company')
			{
				document.getElementById('from_company_id_'+j).value = '';
				document.getElementById('from_company_name_'+j).value = '';
				document.getElementById('from_company_name_'+j).disabled = false;
			}
			else
			{
				document.getElementById('to_company_id_'+j).value = '';
				document.getElementById('to_company_name_'+j).value = '';
				document.getElementById('to_company_name_'+j).disabled = false;
			}
		}
	}
</script>