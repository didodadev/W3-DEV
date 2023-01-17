<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfscript>
	bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1);
	bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi));

	attributes.startrow = ((attributes.page-1) * attributes.maxrows) + 1;
	if (fuseaction contains "popup")
		is_popup = 1;
	else
		is_popup = 0;
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_our_company = cmp_company.get_company();
	cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps");
	cmp_org_step.dsn = dsn;
	get_organization_steps = cmp_org_step.get_organization_step();
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branch = cmp_branch.get_branch(comp_id : '#iif(isdefined("attributes.comp_id") and len(attributes.comp_id),"attributes.comp_id",DE(""))#');
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#');
	
	url_str = "";
	if (isdefined("attributes.comp_id") and len(attributes.comp_id))
		url_str = "#url_str#&comp_id=#attributes.comp_id#";
	if (isdefined("attributes.branch_id") and len(attributes.branch_id))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if (isdefined("attributes.department") and len(attributes.department))
		url_str = "#url_str#&department=#attributes.department#";
	if (isdefined("attributes.keyword") and len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (isdefined("attributes.sal_year") and len(attributes.sal_year))
		url_str = "#url_str#&sal_year=#attributes.sal_year#";
	if (isdefined("attributes.sal_mon") and len(attributes.sal_mon))
		url_str = "#url_str#&sal_mon=#attributes.sal_mon#";
	if (isdefined("attributes.is_form_submit") and len(attributes.is_form_submit))
		url_str = "#url_str#&is_form_submit=#attributes.is_form_submit#";
		
	if (isdefined('attributes.is_form_submit'))
	{
		cmp_norm_pos = createObject("component","V16.hr.cfc.get_norm_positions");
		cmp_norm_pos.dsn = dsn;
		get_norm_positions = cmp_norm_pos.get_norm_pos_minus(
			sal_year: attributes.sal_year,
			sal_mon: attributes.sal_mon,
			comp_id: '#iif(isdefined("attributes.comp_id") and len(attributes.comp_id),"attributes.comp_id",DE(""))#',
			branch_id: attributes.branch_id,
			department: attributes.department,
			keyword: attributes.keyword,
			start_date: bu_ay_basi,
			finish_date: bu_ay_sonu
		);
	}
	else
		get_norm_positions.recordcount = 0;
	top_gereken = 0;
    top_varolan = 0;
    top_fark = 0;
    total_gereken = 0;
    total_varolan = 0;
    total_fark = 0;
</cfscript>

<cfparam name="attributes.totalrecords" default='#get_norm_positions.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" action="#request.self#?fuseaction=hr.list_norm_staff_minus" method="post">
			<input type="hidden" name="is_form_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="50" id="keyword" value="#attributes.keyword#" style="width:100px;" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group">
					<select name="sal_year" id="sal_year">
						<cfloop from="#session.ep.period_year-5#" to="#session.ep.period_year+5#" index="ccm">
							<cfoutput>
								<option value="#ccm#" <cfif attributes.sal_year eq ccm>selected</cfif>>#ccm#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<select name="sal_mon" id="sal_mon">
						<cfloop from="1" to="12" index="ccm">
							<cfoutput>
								<option value="#ccm#" <cfif attributes.sal_mon eq ccm>selected</cfif>>#listgetat(ay_list(),ccm)#</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-comp_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<div class="col col-12">
							<select name="comp_id" id="comp_id" style="width:150px;" onChange="showBranch(this.value)">
								<option value=""><cfoutput>#getLang(322,'Seçiniz',57734)#</cfoutput></option>
								<cfoutput query="get_our_company">
									<option value="#comp_id#"<cfif isdefined('attributes.comp_id') and attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-branch_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<div width="150" id="BRANCH_PLACE">
							<select name="branch_id" id="branch_id" style="width:150px;" onChange="showDepartment(this.value)">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
								<cfoutput query="get_branch"><option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option></cfoutput>
								</cfif>
							</select>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-department">
					<label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div width="125" id="DEPARTMENT_PLACE">
							<select name="department" id="department" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='55104.Departman Seciniz'></option>
								<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
									<cfoutput query="get_department">
										<option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(8,'Norm Kadro Eksiklikleri/Fazlalıkları',55093)#" uidrop="1" hide_table_column="1">
		<cf_flat_list> 
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id ='57453.Şube'></th>
					<th><cf_get_lang dictionary_id ='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id ='58581.Gereken'></th>
					<th><cf_get_lang dictionary_id ='58582.Varolan'></th>
					<th width="20"><cf_get_lang dictionary_id ='58583.Fark'></th>
				</tr>
			</thead>
			<tbody>
				<cfif attributes.page neq 1 and get_norm_positions.recordcount>
				<cfoutput query="get_norm_positions" startrow="1" maxrows="#attributes.startrow-1#">
						<cfset deger_ = pos_count - evaluate("get_norm_positions.employee_count#attributes.sal_mon#")><!--- #bu_ay# --->
						<cfset total_gereken = total_gereken + evaluate("get_norm_positions.employee_count#attributes.sal_mon#")><!--- #bu_ay# --->
						<cfset total_varolan = total_varolan + pos_count>
						<cfset total_fark = total_fark + deger_>						
					</cfoutput>
				</cfif>
				<cfif get_norm_positions.recordcount>
					<cfoutput query="get_norm_positions" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset deger_ = pos_count - evaluate("get_norm_positions.employee_count#attributes.sal_mon#")>
						<tr>
							<td width="35">#currentrow#</td>
							<td>#nick_name#</td>
							<td>#branch_name#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.list_norm_positions&event=upd&branch_id=#branch_id#&norm_year=#attributes.sal_year#','page_display')" class="tableyazi">#department_head#</a></td>
							<td>#position_cat#</td>
							<td style="text-align:right;">
								#tlformat(evaluate("get_norm_positions.employee_count#attributes.sal_mon#"),0)#
								<cfset top_gereken = top_gereken + evaluate("get_norm_positions.employee_count#attributes.sal_mon#")>
							</td>
							<td style="text-align:right;">
								#pos_count#
								<cfset top_varolan = top_varolan + pos_count>
							</td>
							<td style="text-align:right;">
								#tlformat(deger_,0)#
								<cfset top_fark = top_fark + deger_>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<cfoutput>
					<tfoot>
						<tr>
							<td colspan="5" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='55447.Sayfa Toplam'></td>
							<td class="txtbold" style="text-align:right;">#tlformat(top_gereken,0)#</td>
							<td class="txtbold" style="text-align:right;">#tlformat(top_varolan,0)#</td>
							<td class="txtbold" style="text-align:right;">#tlformat(top_fark,0)#</td>
						</tr>
						<cfif attributes.page neq 1>
							<tr>
								<td colspan="5" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
								<td class="txtbold" style="text-align:right;">#tlformat(total_gereken+top_gereken,0)#</td>
								<td class="txtbold" style="text-align:right;">#tlformat(total_varolan+top_varolan,0)#</td>
								<td class="txtbold" style="text-align:right;">#tlformat(total_fark+top_fark,0)#</td>
							</tr>
						</cfif>
					</tfoot>
				</cfoutput>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="8"><cfif not isdefined('attributes.is_form_submit')><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</cfif></td>
						</tr>
					</tbody>
				</cfif>
		</cf_flat_list> 

		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="hr.list_norm_staff_minus&#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function showDepartment(branch_id)	
{
	var branch_id = document.getElementById('branch_id').value;
	if (branch_id != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	else
	{
		var myList = document.getElementById("department");
		myList.options.length = 0;
		var txtFld = document.createElement("option");
		txtFld.value='';
		txtFld.appendChild(document.createTextNode('<cf_get_lang dictionary_id="57572.Departman">'));
		myList.appendChild(txtFld);
	}
}
function showBranch(comp_id)	
{
	var comp_id = document.getElementById('comp_id').value;
	if (comp_id != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang dictionary_id="55769.İlişkili Şubeler">');
	}
	else {document.getElementById('branch_id').value = "";document.getElementById('department').value ="";}
	//departman bilgileri sıfırla
	var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
	AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id="55770.İlişkili Departmanlar">');
}
</script>
