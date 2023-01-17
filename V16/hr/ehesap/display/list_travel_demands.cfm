<cf_get_lang_set module_name="ehesap">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.startdate" default="#date_add('m',-1,CreateDate(year(now()),month(now()),1))#">
<cfparam name="attributes.finishdate" default="#CreateDate(year(now()),month(now()),DaysInMonth(now()))#"> 
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined('attributes.form_submit')>
	<cfif attributes.branch_id eq "all">
    	<cfset attributes.branch_id = "">
    </cfif>
	<cfif attributes.comp_id eq "all">
    	<cfset attributes.comp_id = "">
    </cfif>
	<cfif attributes.department eq "all">
    	<cfset attributes.department = "">
    </cfif>
    <cf_date tarih="attributes.startdate">
    <cf_date tarih="attributes.finishdate">
	<cfscript>
        get_demands = createObject("component","V16.myhome.cfc.get_travel_demands");
        get_demands.dsn = dsn;
        get_travel_demand = get_demands.travel_demands
                        (
                         	keyword : attributes.keyword,
							comp_id : attributes.comp_id,
							branch_id : attributes.branch_id,
							department_id : attributes.department,
							process_stage : attributes.process_stage,
							startdate : attributes.startdate,
							finishdate : attributes.finishdate
                        );
    </cfscript>	
<cfelse>
	<cfset get_travel_demand.recordcount = 0>
</cfif>

<cfscript>
	url_str = "";
	url_str = "#url_str#&keyword=#attributes.keyword#";
	if (isdefined('attributes.form_submit'))
		url_str = "#url_str#&form_submit=#attributes.form_submit#";
	if (isdefined('attributes.comp_id'))
		url_str = "#url_str#&comp_id=#attributes.comp_id#";
	if (isdefined('attributes.branch_id'))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if (isdefined('attributes.department'))
		url_str = "#url_str#&department=#attributes.department#";
	if (isdefined('attributes.startdate'))
		url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#";
	if (isdefined('attributes.finishdate'))
		url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#";
	if (isdefined('attributes.process_stage') and len(attributes.process_stage))
		url_str = "#url_str#&process_stage=#attributes.process_stage#";

	get_comp_ = createObject("component","V16.hr.cfc.get_our_company");
	get_comp_.dsn = dsn;
	get_our_company = get_comp_.get_company();
	
	get_process = createObject("component","V16.hr.cfc.get_process_rows");
	get_process.dsn = dsn;
	get_process_row = get_process.get_process_type_rows(
		faction : 'ehesap.list_travel_demands'
	);
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_travel_demands" name="myform" method="post">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-12"><cf_get_lang dictionary_id="57482.Aşama"></label>
						<div class="col col-12">
							<select name="process_stage" id="process_stage" style="width:120px;">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_process_row">
									<option value="#PROCESS_ROW_ID#" <cfif isdefined('attributes.process_stage') and attributes.process_stage eq PROCESS_ROW_ID>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-12"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
								<cfinput type="text" name="startdate" style="width:65px;" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>
					</div>				
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-comp_id">
						<label class="col col-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
						<div class="col col-12">
						<select name="comp_id" id="comp_id" style="width:150px;" onChange="showBranch(this.value)">
								<option value="all"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_our_company">
									<option value="#comp_id#"<cfif attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-finishdate">
						<label class="col col-12"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
								<cfinput type="text" name="finishdate" style="width:65px;" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="BRANCH_PLACE">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<select name="branch_id" id="branch_id" style="width:150px;" onChange="showDepartment(this.value)">
								<option value="all"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfif isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all">
									<cfscript>
										branch_ = createObject("component","V16.hr.cfc.get_branches");
										branch_.dsn = dsn;
										get_branch = branch_.get_branch(
																			comp_id:attributes.comp_id
																		);
									</cfscript>	
									<cfoutput query="get_branch">
										<option value="#branch_id#"<cfif attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="DEPARTMENT_PLACE">
						<label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-12">
							<select name="department" id="department" style="width:150px;">
								<option value="all"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
									<cfscript>
										department = createObject("component","V16.hr.cfc.get_departments");
										department.dsn = dsn;
										get_department = department.get_department(
																			branch_id:attributes.branch_id
																			);
									</cfscript>	
									<cfoutput query="get_department">
										<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option></cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>  	
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="49729.Seyahat Talepleri"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr> 
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id="45446.Göreve Gideceği Yer"></th>
					<th><cf_get_lang dictionary_id="45410.Gidiş Tarihi"></th>
					<th><cf_get_lang dictionary_id="45408.Dönüş Tarihi"></th>
					<th><cf_get_lang dictionary_id="45409.Konaklama Notu"></th>
					<th><cf_get_lang dictionary_id="45591.Görev Nedenleri"></th>
					<th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_travel_demands&event=add&employee_id=<cfoutput>#session.ep.userid#</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='45588.Seyahat Talebi Ekle'>" alt="<cf_get_lang dictionary_id='45588.Seyahat Talebi Ekle'>"></i></a></th>
				</tr>
			</thead>
				<cfparam name="attributes.totalrecords" default="#get_travel_demand.recordcount#">
				<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
				<cfif get_travel_demand.recordcount>
					<cfoutput query="get_travel_demand" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td width="20">#currentrow#</td>
						<td>#EMPNAME_SURNAME#</td>
						<td>#nick_name#</td>
						<td>#branch_name#</td>
						<td>#department_head#</td>
						<td>#stage#</td>
						<td>#place# / #city#</td>
						<td>#dateformat(DEPARTURE_DATE,dateformat_style)#</td>
						<td>#dateformat(DEPARTURE_OF_DATE,dateformat_style)#</td>
						<td>#Task_detail#</td>
						<td>#TASK_CAUSES#</td>
						<td width="20"><a href="#request.self#?fuseaction=ehesap.list_travel_demands&event=upd&TRAVEL_DEMAND_ID=#TRAVEL_DEMAND_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='30923.İzin Güncelle'>" alt="<cf_get_lang dictionary_id='30923.İzin Güncelle'>"></i></a></td>
					</tr>
					</cfoutput>
				<cfelse>	
					<tr> 
						<td colspan="17"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</tbody>
				</cfif>
		</cf_flat_list>
		<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#listfirst(attributes.fuseaction,'.')#.list_travel_demands&#url_str#">
	</cf_box>
</div> 
<script type="text/javascript">
	document.getElementById('keyword').focus();
function showDepartment(branch_id)	
{
	var branch_id = document.myform.branch_id.value;
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
	var comp_id = document.myform.comp_id.value;
	if (comp_id != "")
	{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang dictionary_id="55769.İlişkili Şubeler">');
	}
	else {document.myform.branch_id.value = "";document.myform.department.value ="";}
	//departman bilgileri sıfırla
	var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
	AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang dictionary_id="55770.İlişkili Departmanlar">');
}	
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
