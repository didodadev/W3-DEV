<cf_xml_page_edit fuseact="ehesap.list_fire">
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfif not isdefined("attributes.keyword")>
	<cfset arama_yapilmali = 1>
	<cfset attributes.is_out_statue = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfif arama_yapilmali eq 1>
	<cfset GET_IN_OUTS.recordcount = 0>
<cfelse>
	<cfinclude template="../query/get_in_outs.cfm">
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
	
	duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
	if(isdefined("is_gov_payroll") and is_gov_payroll eq 1)
	{	
		QueryAddRow(duty_type,9);
	}
	else
	{
		QueryAddRow(duty_type,8);
	}
	QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('main',164)#",1);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',194)#",2);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',604)#",3);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',206)#",4);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',232)#",5);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',223)#",6);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',236)#",7);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',253)#",8);
	if(isdefined("is_gov_payroll") and is_gov_payroll eq 1)
	{
		QuerySetCell(duty_type,"DUTY_TYPE_ID",8,9);
		QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',1233)#/#getLang('main',1298)#",9);
	}
</cfscript>
<cfparam name="attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.tc_identy_no" default="">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.explanation_id" default="">
<cfparam name="attributes.explanation_id2" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.out_statue" default="">
<cfparam name="attributes.emp_status" default="-1">
<cfinclude template="../query/get_ssk_offices.cfm">
<cfparam name="attributes.page" default=1>
<cfset col_count = 16>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_in_outs.recordcount#>
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY
	WHERE
		1 = 1
		<cfif not session.ep.ehesap>
			AND COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY
		NICK_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search" action="#request.self#?fuseaction=ehesap.list_fire" method="post">
	<cf_box>
		<cf_box_search>
			<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
				<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
			</div>
			<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="57789.Özel Kod"></cfsavecontent>
				<cfinput type="text" name="hierarchy" id="hierarchy"  placeholder='#message#' value="#attributes.hierarchy#" maxlength="50">
			</div>
			<div class="form-group">
				<select name="emp_status" id="emp_status">
					<option value="-1"<cfif isdefined("attributes.emp_status") and (attributes.emp_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					<option value="1"<cfif isdefined("attributes.emp_status") and (attributes.emp_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="0"<cfif isdefined("attributes.emp_status") and (attributes.emp_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
				</select>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
					<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
						<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
					<cfelse>
						<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" >
					</cfif>
					<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
					<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
						<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
					<cfelse>
						<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" >
					</cfif>
					<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
				</div>
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" >
			</div>
			<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button search_function="date_check(search.startdate,search.finishdate,'#message_date#')" button_type="4">
			</div>
			<div class="form-group">
					<!--- <cf_workcube_file_action pdf='0' mail='0' doc='1' print='0'> --->
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_fire&event=addmulti" class="ui-btn ui-btn-gray2"><i class="fa fa-user-times" title="<cf_get_lang dictionary_id='58057.Toplu'><cf_get_lang dictionary_id='52993.İşten Çıkarmalar'>"></i></a>
			</div>
		</cf_box_search>
		<cf_box_search_detail>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<cfsavecontent variable="secmessage"><cf_get_lang dictionary_id='57734.Seçiniz'></cfsavecontent>
				<div class="form-group" id="item-get_company">
					<label><cf_get_lang dictionary_id="57574.Şirket"></label>
					<div class="multiselect-z2">
						<cf_multiselect_check 
							query_name="get_company"  
							name="comp_id"
							width="140" 
							option_text="#secmessage#" 
							option_value="COMP_ID"
							option_name="NICK_NAME"
							value="#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#"
							onchange="get_branch_list(this.value)">
					</div>
				</div>
				<div class="form-group" id="item-BRANCH_PLACE">
					<label><cf_get_lang dictionary_id="57453.Şube"></label>
					<div id="BRANCH_PLACE" class="multiselect-z2">
						<cf_multiselect_check 
						query_name="get_ssk_offices"  
						name="branch_id"
						width="140" 
						option_text="#secmessage#"
						option_value="BRANCH_ID"
						option_name="BRANCH_NAME-NICK_NAME"
						value="#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#"
						onchange="get_department_list(this.value)">
					</div>
				</div>
				<div class="form-group" id="item-DEPARTMENT_PLACE">
					<label><cf_get_lang dictionary_id="57572.Departman"></label>
					<div id="DEPARTMENT_PLACE" class="multiselect-z2">
						<cf_multiselect_check 
						query_name="get_department"  
						name="department"
						width="140" 
						option_text="#secmessage#"
						option_value="department_id"
						option_name="department_head"
						value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
					</div>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-inout_statue">
					<label><cf_get_lang dictionary_id='53208.Giriş ve Çıkışlar'></label>
					<select name="inout_statue" id="inout_statue" onchange="filtre_gizle_goster(this.value);">
						<option value=""><cf_get_lang dictionary_id='53208.Giriş ve Çıkışlar'></option>
						<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
						<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
						<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='53226.Aktif Çalışanlar'></option>
					</select>
				</div>
				
					<div class="form-group" id="explanation_id" <cfif attributes.inout_statue eq 0>style="display:'';"<cfelse> style="display:none;"</cfif>>
						<label><cf_get_lang dictionary_id='53882.İşten Çıkış Nedeni'></label>
						<select name="explanation_id" id="explanation_id">
							<option value=""><cf_get_lang dictionary_id='53882.İşten Çıkış Nedeni'></option>
							<cfloop list="#reason_order_list()#" index="ccc">
								<cfoutput><option value="#ccc#" <cfif attributes.explanation_id eq ccc>selected</cfif>>#listgetat(reason_list(),ccc,';')#</option></cfoutput>
							</cfloop>
						</select>
					</div>
					<div class="form-group" id="explanation_id2" <cfif attributes.inout_statue eq 1>style="display:'';"<cfelse> style="display:none;"</cfif>>
						<label><cf_get_lang dictionary_id='52990.Gerekçe'></label>
						<select name="explanation_id2" id="explanation_id2">
							<option value=""><cf_get_lang dictionary_id='52990.Gerekçe'></option>
							<option value="0" <cfif attributes.explanation_id2 eq 0>selected</cfif>><cf_get_lang dictionary_id='53317.Nakil'></option>
							<option value="1" <cfif attributes.explanation_id2 eq 1>selected</cfif>><cf_get_lang dictionary_id='53318.Yeni Giriş'></option>
						</select>
					</div>
					<div class="form-group" id="is_out_statue_td" <cfif attributes.inout_statue eq 1>style="display:'';"<cfelse> style="display:none;"</cfif>>
						<label><cf_get_lang dictionary_id='52990.Gerekçe'></label>
						<input type="checkbox" value="1" name="is_out_statue" id="is_out_statue" <cfif isdefined('attributes.is_out_statue') and attributes.is_out_statue eq 1>checked</cfif>><cf_get_lang dictionary_id="45481.Çıkışı Olanlar Getirilmesin">
					</div>
				<div class="form-group" id="item-out_statue">
					<label><cf_get_lang dictionary_id="45605.Çıkış Durumu"></label>
					<select name="out_statue" id="out_statue">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.out_statue eq 1>selected</cfif>><cf_get_lang dictionary_id='57616.Onaylı'></option>
						<option value="2" <cfif attributes.out_statue eq 2>selected</cfif>><cf_get_lang dictionary_id='53993.Onay Bekleyen'></option>
						<option value="3" <cfif attributes.out_statue eq 3>selected</cfif>><cf_get_lang dictionary_id="46139.Reddedilen"></option>
					</select>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<cfif x_get_duty_type>
					<div class="form-group" id="item-duty_type">
						<label><cf_get_lang dictionary_id="58538.Görev Tipi"></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="58538.Görev Tipi"></cfsavecontent>
						<div>
							<cf_multiselect_check 
							query_name="duty_type"  
							name="duty_type"
							width="135" 
							option_value="DUTY_TYPE_ID"
							option_name="DUTY_TYPE_NAME"
							value="#attributes.duty_type#"
							option_text="#message#">
						</div> 
					</div>
				</cfif>
			</div>
		</cf_box_search_detail>
	</cf_box>
</cfform>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="52965.İşe Giriş Çıkışlar"></cfsavecontent>
<cf_box title="#message#" hide_table_column="1" uidrop="1" woc_setting = "#{ checkbox_name : 'in_out_ids', print_type : 179 }#">
<cfform name="sgk_export_form" id="sgk_export_form" action="index.cfm?fuseaction=ehesap.list_fire_ins" method="post">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="40"><cf_get_lang dictionary_id='58577.Sıra'></td>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th width="150"><cf_get_lang dictionary_id='57576.Çalışan'></th>
				<th width="85"><cf_get_lang dictionary_id ='58025.TC Kimlik'></th>
				<th><cf_get_lang dictionary_id='52990.Gerekçe'></th>
				<th style="width:80px;"><cf_get_lang dictionary_id ='53701.İlgili Şirket'></th>
				<th style="width:80px;"><cf_get_lang dictionary_id='57453.Şube'></th>
				<th style="width:85px;"><cf_get_lang dictionary_id='57572.Departman'></th>
				<cfif x_get_duty_type><th style="width:75px;" nowrap="nowrap"><cf_get_lang dictionary_id='58538.Görev Tipi'></th></cfif>
				<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
				<cfif x_get_position_cat><th style="width:130px;"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th></cfif>
				<cfif x_get_kidem_date><th><cf_get_lang dictionary_id='53261.Kıdem Baz'></th></cfif>
				<th><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
				<th><cf_get_lang dictionary_id='29438.cıkıs tarihi'></th>
				<th><cf_get_lang dictionary_id='53974.Kıdem'></th>
				<th><cf_get_lang dictionary_id='53975.İhbar'></th>
				<cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
				<!-- sil -->
				<th class="text-center" width="20">
					<span class="fa fa-plus" href="javascript://" title="<cf_get_lang dictionary_id ='53976.İşe Giriş İşlemi Yap'>" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_fire&event=addIn');"></span>
				</th>
				<th class="text-center" width="20"><i class="fa fa-minus"></i></th>
				<th class="text-center" width="20"><i class="fa fa-thumbs-up" title="<cf_get_lang dictionary_id='30925.Onay Durumu'>"></i></th>
				<th class="text-center" width="20">
					<input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','in_out_ids');">
				</th>
				<!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfset lastRow = 0>
			<cfif get_in_outs.recordcount>
			
			<cfoutput query="get_in_outs" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<cfset lastRow = CURRENTROW>
				<tr <cfif len(FINISH_DATE)>style="color:red;"</cfif>>
					<td>#CURRENTROW#</td>
					<td>#employee_no#</td>
					<td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#IN_OUT_ID#&empName=#UrlEncodedFormat('#employee_name# #employee_surname#')#" <cfif len(FINISH_DATE)>style="color:red;"</cfif>>#employee_name# #employee_surname#</a></td>
					<td>#tc_identy_no#</td>
					<td>
						<cfif not len(finish_date)>
							<cfif len(ex_in_out_id)><cf_get_lang dictionary_id='53317.Nakil'><!---herhangi bir cikis kaydindan nakil ile otomatik acilmis ise --->
							<cfelse><cf_get_lang dictionary_id='53318.Yeni Giriş'></cfif>
						<cfelse><!--- cikis gerekceleri--->
						#get_explanation_name(explanation_id)#
						</cfif>
					</td>
					<td>#RELATED_COMPANY#</td>
					<td>#branch_name#</td>
					<td>#department_head#</td>
					<cfif x_get_duty_type>
						<cfset col_count++>
						<td>
							<cfif duty_type eq 0>
								<cf_get_lang dictionary_id='53550.İşveren'>
							<cfelseif duty_type eq 1>	
								<cf_get_lang dictionary_id='53140.İşveren Vekili'>
							<cfelseif duty_type eq 2>
								<cf_get_lang dictionary_id='57576.Çalışan'>
							<cfelseif duty_type eq 3>
								<cf_get_lang dictionary_id='53152.Sendikalı'>
							<cfelseif duty_type eq 4>
								<cf_get_lang dictionary_id='53178.Sözleşmeli'>
							<cfelseif duty_type eq 5>
								<cf_get_lang dictionary_id='53169.Kapsam Dışı'>
							<cfelseif duty_type eq 6>
								<cf_get_lang dictionary_id='53182.Kısmi İstihdam'>
							<cfelseif duty_type eq 7>
								<cf_get_lang dictionary_id='53199.Taşeron'>
							<cfelseif duty_type eq 8>
								<cf_get_lang dictionary_id="54179.Derece">/<cf_get_lang dictionary_id="58710.Kademe">
							</cfif>
						</td>
					</cfif>
					<td>#position_name#</td>
					<cfif x_get_position_cat>
						<cfset col_count++>
						<td><a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#POSITION_ID#" target="_blank" class="tableyazi">#POSITION_CAT#</a></td>
					</cfif>
					<cfif x_get_kidem_date><cfset col_count++><td>#dateformat(KIDEM_DATE,dateformat_style)#</td></cfif>
					<td>#dateformat(START_DATE,dateformat_style)#</td>
					<td>#dateformat(FINISH_DATE,dateformat_style)#</td>
					<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TlFormat(KIDEM_AMOUNT)#"></td>
					<td><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TlFormat(IHBAR_AMOUNT)#"></td>
					<cfif isDefined("x_show_level") and x_show_level eq 1>
						<td>                            
							<cfset up_dep_len = listlen(HIERARCHY_DEP_ID1,'.')>
							<cfif up_dep_len gt 0>
								<cfset temp = up_dep_len> 
								<cfloop from="1" to="#up_dep_len#" index="i" step="1">
									<cfif isdefined("HIERARCHY_DEP_ID1") and listlen(HIERARCHY_DEP_ID1,'.') gt temp>
										<cfset up_dep_id = ListGetAt(HIERARCHY_DEP_ID1, listlen(HIERARCHY_DEP_ID1,'.')-temp,".")>
										<cfquery name="get_upper_departments" datasource="#dsn#">
											SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
										</cfquery>
										<cfset up_dep_head = get_upper_departments.department_head>
										#up_dep_head# 
											<cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
											<cfif get_org_level.recordcount>
												(#get_org_level.ORGANIZATION_STEP_NAME#)
											</cfif>
										<cfif up_dep_len neq i>
											>
										</cfif>
									<cfelse>
										<cfset up_dep_head = ''>
									</cfif>
									<cfset temp = temp - 1>
								</cfloop>
							</cfif>​
						</td>
					</cfif>
					<!-- sil -->
					<td align="center" nowrap="nowrap">
						<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_fire&event=updIn&in_out_id=#in_out_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
					</td>
					<td>
						<cfif not len(FINISH_DATE)>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_fire&event=addOut&draggable=1&in_out_id=#in_out_id#','#attributes.modal_id#','ui-draggable-box-large');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='53977.İşten Çıkarma İşlemi Yap'>"></i></a>
						</cfif>
					</td>
					<td>
						<cfif len(FINISH_DATE)>
							<cfif valid eq 1>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_fire&event=updOut&in_out_id=#in_out_id#');"><i class="fa fa-thumbs-up" style="color:##13be54!important;" title="<cf_get_lang dictionary_id='58699.Onaylandı'>"></i></a>
							<cfelseif valid eq 0>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_fire&event=updOut&in_out_id=#in_out_id#');"><i class="fa fa-thumbs-down" style="color:##e7505a!important;" title="<cf_get_lang dictionary_id='57617.Reddedildi'>"></i></a>
							<cfelse>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_fire&event=updOut&in_out_id=#in_out_id#');"><i class="fa fa-thumbs-up" title="<cf_get_lang dictionary_id='57615.Onay Bekliyor'>"></i></a>
							</cfif>
						</cfif>
					</td>
					<td><input type="checkbox" name="in_out_ids" id="in_out_ids" value = "#GET_IN_OUTS.in_out_id#" data-action-type ="#in_out_id#"></td>
					<!-- sil -->
				</tr>
			</cfoutput>
			</cfif>
			<!--- <cfif not get_in_outs.recordcount>
				<tr>
					<td colspan="17"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id ='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</cfif></td>
				</tr>
			</cfif> --->
		</tbody>
	</cf_grid_list>
	<cfif get_in_outs.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</cfif></p>
		</div>
	</cfif>
	<cfif get_in_outs.recordcount and arama_yapilmali neq 1>
		<cf_box_footer>
			<cfoutput>
				<input type="submit" class="ui-wrk-btn ui-wrk-btn-success" name="gonder" value="#getLang('','Giriş Bildirge Dosyası Oluştur',49474)#" onClick="send_form('index.cfm?fuseaction=ehesap.list_fire_ins')">
				<input type="submit" class="ui-wrk-btn ui-wrk-btn-red" name="gonder2" value="#getLang('','Çıkış Bildirge Dosyası Oluştur',49477)#" onClick="send_form('index.cfm?fuseaction=ehesap.list_fire_outs')">
				<input type="submit" class="ui-wrk-btn ui-wrk-btn-extra" name="gonder3" value="#getLang('','Giriş Maili Gönder',49478)#"  onClick="send_form('index.cfm?fuseaction=ehesap.list_ins_mail')">
				<input type="submit" class="ui-wrk-btn ui-wrk-btn-warning" name="gonder4" value="#getLang('','Çıkış Maili Gönder',49492)#"  onClick="send_form('index.cfm?fuseaction=ehesap.list_outs_mail')">
				<input type="submit" class="ui-wrk-btn ui-wrk-btn-info" name="gonder5"  value="#getLang('','İşkur Bildirge Dosyası Oluştur',49497)#"  onClick="send_form('index.cfm?fuseaction=ehesap.list_fire_iskur')">
			</cfoutput>
		</cf_box_footer>
	</cfif>
</cfform>
	<cfset adres=attributes.fuseaction>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
    <cfset adres = "#adres#&hierarchy=#attributes.hierarchy#">
    <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
    <cfset adres = "#adres#&inout_statue=#attributes.inout_statue#">
    <cfset adres = "#adres#&explanation_id=#attributes.explanation_id#">
    <cfset adres = "#adres#&explanation_id2=#attributes.explanation_id2#">
    <cfif isdefined('attributes.is_out_statue') and len(attributes.is_out_statue)>
    	<cfset adres = "#adres#&is_out_statue=#attributes.is_out_statue#">
    </cfif>
    <cfif len(attributes.out_statue)>
        <cfset adres = "#adres#&out_statue=#attributes.out_statue#">
    </cfif>
    <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
    <cfelse>
        <cfset adres = "#adres#&startdate=">
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
    <cfelse>
        <cfset adres = "#adres#&finishdate=">
    </cfif>
    <cfif isdefined("attributes.record_startdate") and isdate(attributes.record_startdate)>
        <cfset adres = "#adres#&record_startdate=#dateformat(attributes.record_startdate,dateformat_style)#">
    </cfif>
    <cfif isdefined("attributes.record_finishdate") and isdate(attributes.record_finishdate)>
        <cfset adres = "#adres#&record_finishdate=#dateformat(attributes.record_finishdate,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.emp_status") and len(attributes.emp_status)>
		<cfset adres = "#adres#&emp_status=#attributes.emp_status#">
	</cfif>
	<cfif x_get_position_cat>
		<cfset adres = "#adres#&is_position_cat=1">
	</cfif>
	<cfif x_get_duty_type>
		<cfset adres = "#adres#&duty_type=#attributes.duty_type#">
	</cfif>
	<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#adres#"> 
	
		

	
	
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function send_form(url) {
		document.sgk_export_form.action= url;
		$('#sgk_export_form').submit();
	}
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
	
		function date_check(date1,date2)
	{
		
		if(date1<date2)
			{
				alert("<cf_get_lang dictionary_id='54641.Tarih Hatası'>!")
				return false;
			}
		else
			return true;
	}
	function filtre_gizle_goster(value){
		if(value == 0){
			document.getElementById('explanation_id').style.display = '';
			document.getElementById('explanation_id2').style.display = 'none';
			document.getElementById('is_out_statue_td').style.display = 'none';
			document.getElementById('explanation_id2').value = '';
		}
		else if(value == 1) {
			document.getElementById('is_out_statue').checked = true;
			document.getElementById('explanation_id2').style.display = '';
			document.getElementById('is_out_statue_td').style.display = '';
			document.getElementById('explanation_id').style.display = 'none';
			document.getElementById('explanation_id').value = '';
		} else {
			document.getElementById('explanation_id').style.display = 'none';
			document.getElementById('explanation_id').value = '';
			document.getElementById('explanation_id2').style.display = 'none';
			document.getElementById('explanation_id2').value = '';
			document.getElementById('is_out_statue_td').style.display = 'none';
			document.getElementById('is_out_statue').value = '';
		}
	}
	function select_all_inout(mainCheck)
	{
		for(var i=0; i<<cfoutput>#lastRow#</cfoutput>; i++)
		{
				document.getElementsByName("in_out_ids")[i].checked = mainCheck.checked;
		}
	}
	function get_branch_list(gelen)
	{		
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&dept=2,3&is_ssk_offices=1&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&dept=2,3&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}

	function is_check(deger)
	{
		if(deger == 18)
		{
			document.cari.action = "";
			gizle1.style.display = '';
			gizle2.style.display = '';
			gizle3.style.display = '';
			gizle4.style.display = '';
			gizle5.style.display = '';
			gizle6.style.display = '';
			gizle7.style.display = '';
			gizle_kod_grubu.style.display = '';
			document.cari.action = "<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_fire</cfoutput>";//nakil ise direk kayıt ekranına yönlendir
		}
		else 
		{
			document.cari.action = "";
			gizle1.style.display = 'none';
			gizle2.style.display = 'none';
			gizle3.style.display = 'none';
			gizle4.style.display = 'none';
			gizle5.style.display = 'none';
			gizle6.style.display = 'none';
			gizle7.style.display = 'none';
			gizle_kod_grubu.style.display = 'none';
			document.cari.action = "<cfoutput>#request.self#?fuseaction=ehesap.popup_form_fire2</cfoutput>";//nakil değil ise ücret işlemlerinin yapıldığı ekrana yönlendir
		}
	}
</script>