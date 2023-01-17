<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">)
	ORDER BY 
		BRANCH_NAME
</cfquery>

<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT EVENTCAT_ID, EVENTCAT FROM EVENT_CAT
</cfquery>

<cfinclude template="../display/agenda_tr.cfm">
<cfform name="add_event_plan" id="add_event_plan" method="post" action="#request.self#?fuseaction=pda.emptypopup_add_event_plan">
	<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
		<tr style="height:35px;">
			<td class="headbold">Ziyaret Planı Ekle</td>
		</tr>
	</table>
	<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
		<tr>
			<td class="color-row">
				<table style="width:99%" align="center">
					<tr>
						<td class="infotag" style="width:30%">Plan Adı *</td>
						<td>
							<cfsavecontent variable="message">Lütfen plan adı giriniz!</cfsavecontent>
							<cfinput type="text" name="plan_name" id="plan_name" value="" style="width:212px;" required="yes" message="#message#">
							<a style="cursor:pointer" onClick="add_visit_plan();" title="Ekle"><img src="images/plus_list.gif" alt="Ekle" class="form_icon" style="vertical-align:middle"></a>
						</td>
					</tr>
					<tr>
						<td colspan="2"><div id="visit_plan_div" style="display:none;"></div></td>
					</tr>
					<tr>
						<td>Yetkili Şubeler *</td>
						<td>
							<select name="sales_zones" id="sales_zones" style="width:219px;">
						  	<option value=""><cf_get_lang_main no='41.Şube'></option>
						  	<cfoutput query="get_branch">
								<option value="#branch_id#">#branch_name#</option>
						  	</cfoutput>
						  	</select>
						</td>
                  	</tr>
                   	<tr>
 						<td>Ziyaret Formu *</td>
						<td>
							<cfsavecontent variable="message">Lütfen ziyaret formu adı giriniz!</cfsavecontent>
                            <input type="hidden" name="visit_analysis_id" id="visit_analysis_id" value="" />
							<cfinput type="text" name="visit_form" id="visit_form" value="" style="width:212px;" required="yes" message="#message#">
						</td>                   
                    </tr>
					<tr>
						<td>Tarih *</td>
						<td>
							<cfsavecontent variable="message">Lütfen başlama/bitiş tarihi giriniz!</cfsavecontent>
							<cfinput type="text" name="startdate" id="startdate" maxlength="10" required="yes" validate="eurodate" message="#message#" value="#dateformat(date_add('d',1,now()),'dd/mm/yyyy')#" style="width:80px; vertical-align:top"> 
							<cf_wrk_date_image date_field="startdate"> 
							<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" required="yes" validate="eurodate" message="#message#" value="#dateformat(date_add('d',1,now()),'dd/mm/yyyy')#" style="width:80px; vertical-align:top">
							<cf_wrk_date_image date_field="finishdate">
						</td>
					</tr>
					<tr>
						<td style="vertical-align:top">Açıklama</td>
						<td style="vertical-align:top"><textarea name="detail" id="detail" style="width:213px; height:70px;"></textarea></td>
					</tr>
					<tr style="height:60px;">
						<td colspan="2" style="vertical-align:top">
							<input type="checkbox" name="view_to_all" id="view_to_all" value="1" style="height:15px;" checked="checked">&nbsp;&nbsp;Bu olayı herkes görsün
						</td>
					</tr>
					<tr>
						<td colspan="2">	
							<input type="hidden" name="pos_emp_id" id="pos_emp_id" value="<cfoutput>#session.pda.position_code#</cfoutput>">		
							<input type="hidden" name="record_count" id="record_count" value="0">
							<input type="hidden" name="total_row_count" id="total_row_count" value="0"> 
							<table id="visit_rows" style="width:100%">
								<tr>
									<td colspan="2" style="width:20%">Ziyaret Edilecek</td>
									<td style="width:11%">Tarih</td>
									<td style="width:18%">Başlama / Bitiş Saati</td>
									<td style="width:13%">Ziyaret Nedeni</td>
									<td><a style="cursor:pointer" onClick="add_visit();" title="Ekle"><img src="images/plus_list.gif" alt="Ekle"></a></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2"><div id="company_all_div1" style="display:none;"></div></td>
					</tr>
					<tr>
						<td colspan="2" align="right"><cf_workcube_buttons is_upd='0' add_function='control()'></td>
					</tr>
				</table>				
			</td>
		</tr>
	</table>
	<br/>
</cfform>

<script language="javascript">
	function add_visit()
	{
		extra_course = document.getElementById('record_count').value;
		extra_course++;
		document.getElementById('record_count').value = extra_course;
		document.getElementById('total_row_count').value = extra_course;
		var newRow;
		var newCell;
		newRow = document.getElementById("visit_rows").insertRow(document.getElementById("visit_rows").rows.length);
		newRow.setAttribute("name","visit_row" + extra_course);
		newRow.setAttribute("id","visit_row" + extra_course);

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="company_id' + extra_course + '" id="company_id' + extra_course + '" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#attributes.cpid#</cfoutput></cfif>"><input type="hidden" name="partner_id' + extra_course + '" id="partner_id' + extra_course + '" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#get_partner.partner_id#</cfoutput></cfif>"><input type="hidden" name="member_type' + extra_course + '" id="member_type' + extra_course + '" value="<cfif isdefined('attributes.cpid') and get_company.recordcount>partner</cfif>"><input type="text" name="member_name' + extra_course + '" id="member_name' + extra_course + '" value="<cfif isdefined('attributes.cpid') and get_company.recordcount><cfoutput>#get_company.fullname#&nbsp;#get_partner.company_partner_name#&nbsp;#get_partner.company_partner_surname#</cfoutput></cfif>"  style="width:200px;">';

		newCell = newRow.insertCell(newRow.cells.length);  
		newCell.innerHTML = '<a href="javascript://" onClick="get_consumers_div(' + extra_course + ');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="ship_date' + extra_course + '" id="ship_date' + extra_course + '" value="<cfoutput>#dateformat(date_add('d',1,now()),'dd/mm/yyyy')#</cfoutput>"  validate="eurodate" maxlength="10" style="width:80px;">';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="event_start_clock' + extra_course + '" id="event_start_clock' + extra_course + '" style="width:42px;"><option value="0" selected></option><cfloop from="7" to="30" index="i"><cfset saat=i mod 24><option value="<cfoutput>#saat#" <cfif isDefined("attributes.hour") and attributes.hour eq saat>selected</cfif>>#saat#</cfoutput></option></cfloop></select><select name="event_start_minute' + extra_course + '" id="event_start_minute' + extra_course + '" style="width:42px;"><option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option></select><select name="event_finish_clock' + extra_course + '" id="event_finish_clock' + extra_course + '" style="width:42px;"><option value="0" selected></option><cfloop from="7" to="30" index="i"><cfset saat=i mod 24><option value="<cfoutput>#saat#" <cfif isDefined("attributes.hour") and attributes.hour eq saat>selected</cfif>>#saat#</cfoutput></option></cfloop></select><select name="event_finish_minute' + extra_course + '" id="event_finish_minute' + extra_course + '" style="width:42px;"><option value="00" selected>00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option></select>';

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="warning_id#currentrow#" style="width:150px;"><cfoutput query="get_event_cats"><option value="#eventcat_id#">#eventcat#</option></cfoutput></select><input type="hidden" name="row_control' + extra_course + '" id="row_control' + extra_course + '" value="1">';    

		newCell = newRow.insertCell(newRow.cells.length);	
		newCell.innerHTML = '<a style="cursor:pointer" onclick="del_row(' + extra_course + ');" ><img  src="images/delete_list.gif" border="0"></a>';
	}
	
	function del_row(sy)
	{
		document.getElementById('visit_row'+sy).style.display = 'none';
		document.getElementById('row_control'+sy).value = 0;
		extra_course = document.getElementById('record_count').value;
		extra_course--;
		document.getElementById('record_count').value = extra_course;
	}
	
	/* function get_company_all_div(excourse)
	{
		if(eval('document.getElementById("member_name' + excourse + '")').value.length <= 2)
		{
			alert("Lütfen listelemek için en az 3 karakter giriniz !");
			return false;
		}
		goster(company_all_div1);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_company_div_purchase&ref_member_name='+ eval("document.getElementById('member_name" + excourse + "')").value +'&div_name=company_all_div1' + '&is_my=1' + '&form_id=add_event_plan','company_all_div1');		
		return false;
	} */

	function add_consumer_div(consumer_name, consumer_surname, crntrw)
	{
		if(crntrw != undefined) eval('document.add_event_plan.member_name' + crntrw + '').value = consumer_name + ' ' + consumer_surname;
		else document.getElementById('member_name').value = consumer_name + ' ' + consumer_surname;
		gizle(company_all_div1);
	}
		
	function get_consumers_div(excourse)
	{
		if(eval('document.getElementById("member_name' + excourse + '")').value.length <= 2)
		{
			alert("Lütfen bireysel üye alanı için en az 3 karakter giriniz !");
			return false;
		}
		goster(company_all_div1);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_consumers_div&name='+ encodeURI(eval("document.getElementById('member_name" + excourse + "')").value) +'&crntrw='+excourse+'','company_all_div1');		
		return false;
	}

	function add_visit_plan()
	{
		goster(visit_plan_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_visit_plan_div&keyword=' + document.getElementById('plan_name').value + '','visit_plan_div');
		return false;
	}
		
		
	function add_event_plan_div(crntrow,start_date,finish_date,analy_id,analy_head)
	{
		document.getElementById('plan_name').value = eval("document.getElementById('event_plan_head_" + crntrow + "')").value;
		document.getElementById('visit_analysis_id').value = analy_id;
		document.getElementById('visit_form').value = analy_head;
		document.getElementById('startdate').value = start_date;
		document.getElementById('finishdate').value = finish_date;
		gizle(visit_plan_div);
	}
	
	function add_company_div(company_id,member_name,partner_id,member_type,div_name)
	{
		excourse = list_getat(div_name,2,'company_all_div');
		eval('document.add_event_plan.company_id' + excourse + '').value = company_id;
		eval('document.add_event_plan.member_name' + excourse + '').value = member_name;
		eval('document.add_event_plan.partner_id' + excourse + '').value = partner_id;
		eval('document.add_event_plan.member_type' + excourse + '').value = member_type;
		gizle(company_all_div1);
	}
	
	function control()
	{
		if(document.getElementById('record_count').value == 0)
		{
			alert('Lütfen en az bir adet ziyaret giriniz!');
			return false;
		}
	}
</script>
