<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.department" default="">
<cfinclude template="../query/get_departments.cfm">
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT_ID, POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfif isdefined("attributes.form_submit")>
	<cfinclude template="../query/get_positions.cfm">
<cfelse>
	<cfset get_positions.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_positions.recordcount#">	
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.single" default="">
<cfparam name="attributes.rowNumber" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str =''>
<cfset url_str = '#url_str#&form_submit=1'>
<div class="col col-12">
	<cf_box>
		<cf_wrk_alphabet keyword="url_str">
		<cfform name="list_members" action="#request.self#?fuseaction=objects.popup_list_members" method="post">
			<input type="hidden" name="single" id="single" value="<cfoutput>#attributes.single#</cfoutput>" />
			<input type="hidden" name="rowNumber" id="rowNumber" value="<cfoutput>#attributes.rowNumber#</cfoutput>" />
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<cf_box_search>	
				<div class="form-group" id="keyword">
					<div class="input-group x-12">
					<cfinput type="text" name="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#">
					</div>
				</div>	
				<div class="form-group" id="position_cat_id">
					<select name="position_cat_id" id="position_cat_id">
						<option value=""><cf_get_lang_main no='1592.Pozisyon Tipi'></option>
						<cfoutput query="get_position_cats">
							<option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#position_cat#
						</cfoutput>
					</select>
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
			<!-- sil -->   
				<div class="form-group col col-3 col-md-4 col-sm-6 col xs-12" id="company_id">
					<select name="company_id" id="company_id" onchange="showBranch(this.value)">
						<option value=""><cf_get_lang_main no='162.Şirket'></option>
						<cfoutput query="get_company">
							<option value="#comp_id#"<cfif isdefined("attributes.company_id") and (attributes.company_id eq comp_id)>selected</cfif>>#company_name#</option>
						</cfoutput>
					</select>
				</div>	
				<cfquery name="TITLES" datasource="#DSN#">
					SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
				</cfquery>
				<div class="form-group col col-3 col-md-4 col-sm-6 col xs-12" id="title_id">
					<select name="title_id" id="title_id">
						<option value=""><cf_get_lang_main no='159.Ünvan'></option>
						<cfoutput query="titles"> 
							<option value="#title_id#" <cfif attributes.title_id eq title_id>selected</cfif>>#title#</option> 
						</cfoutput>
					</select>
				</div>	
				<div class="form-group col col-3 col-md-4 col-sm-6 col xs-12" id="branch_place">
					<select name="branch_id" id="branch_id" onchange="showDepartment(this.value)">
						<option value=""><cf_get_lang_main no='41.Şube'></option>
						<cfoutput query="get_branches" group="NICK_NAME">
							<optgroup label="#nick_name#"></optgroup>
							<cfoutput>
								<option value="#branch_id#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#branch_name#</option>
							</cfoutput>
						</cfoutput>
					</select>
				</div>
				<div class="form-group col col-3 col-md-4 col-sm-6 col xs-12" id="department_place">
					<select name="department" id="department">
						<option value=""><cf_get_lang_main no='160.Departman'></option>
						<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
							<cfoutput query="get_departments">
								<option value="#department_id#" <cfif isdefined('attributes.department') and (attributes.department eq get_departments.department_id)>selected</cfif>>#department_head#</option>
							</cfoutput>
						</cfif>
					</select>
				</div>				
			</cf_box_search_detail>	
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="15"></th>
					<th width="120"><cf_get_lang_main no='158.Ad Soyad'></th>
					<th width="120"><cf_get_lang_main no='1085.Pozisyon'></th>
					<th width="120"><cf_get_lang no='593.Yetki Grubu'></th>
					<th width="100"><cf_get_lang_main no='159.Ünvan'></th>
					<th width="80"><cf_get_lang_main no='377.Özel Kod'></th>
					<th width="120"><cf_get_lang_main no='580.Bölge'></th>
					<th width="120"><cf_get_lang_main no='41.Şube'></th>
					<th width="80"><cf_get_lang_main no='160.Departman'></th>
					<cfif get_positions.recordcount and not (isdefined("attributes.single") and attributes.single eq 1)><th width="15"><input type="Checkbox" class="allEmpS" name="all_" id="all_" value="1"></th></cfif>
				</tr>
			</thead>
			<form action="" method="post" name="form_name">
				<cfif get_positions.recordcount>
					<tbody id="mainTbody">
						<cfoutput query="get_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td width="25"><cf_online id="#employee_id#" zone="ep"></td>
								<td><a href="javascript://" class="tableyazi" onclick="<cfif not (isdefined("attributes.single") and attributes.single eq 1)>windowopen('#request.self#?fuseaction=objects.popup_emp_det&department_id=#department_id#&emp_id=#employee_id#&pos_id=#position_code#','medium')<cfelse>add_checked('#employee_id#;#employee_name# #employee_surname#;#position_name#;#position_id#',#attributes.rowNumber#);</cfif>">#employee_name# #employee_surname#</a></td>
								<td>#position_name#</td>
								<td>#user_group_name#</td>
								<td>#title#</td>
								<td>#ozel_kod#</td>
								<td>#zone_name#</td>
								<td>#branch_name#</td>
								<td>#department_head#</td>
								<cfif not (isdefined("attributes.single") and attributes.single eq 1)>
									<td>
										<input type="checkbox" class="empId" name="emp_ids" id="emp_ids" value="#employee_id#;#employee_name# #employee_surname#;#position_name#;#position_id#">
										<input type="hidden" name="employee_name" id="employee_name" value="#employee_name#">
										<input type="hidden" name="employee_surname" id="employee_surname" value="#employee_surname#">
									</td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
					<cfif not (isdefined("attributes.single") and attributes.single eq 1)>
						<tfoot>
							<tr>
								<td  style="text-align:right;" colspan="10"><input type="button" value="<cf_get_lang_main no='49.Kaydet'>" onclick="add_checked();"></td>
							</tr>
						</tfoot>
					</cfif>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="9" align="left"><cfif isdefined("attributes.form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
						</tr>
					</tbody>
				</cfif>
			</form>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "">
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
				<cfset adres = "#adres#&position_cat_id=#attributes.position_cat_id#">
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
				<cfset adres = "#adres#&company_id=#attributes.company_id#">
			</cfif>
			<cfif isdefined("attributes.title_id") and len(attributes.title_id)>
				<cfset adres = "#adres#&title_id=#attributes.title_id#">
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department)>
				<cfset adres = "#adres#&department=#attributes.department#">
			</cfif>
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_list_members#adres#&form_submit=1">	
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$('.allEmpS').click(function () {
		$('.empId').prop('checked', this.checked);
	});
	$('.allEmpS').change(function () {
		var check = ($('.empId').filter(":checked").length == $('.empId').length);
		$('.empId').prop("checked", check);
	});
	function add_checked(param,row)
	{
		if(param)
			window.opener.addEmployeeRow(param,row);
		else
		{
			$(".empId").each(function(index,element){
				if($(element).filter(":checked").length)
					window.opener.addEmployeeRow($(element).val());
			})
		}
		//window.close();
	}
</script>
