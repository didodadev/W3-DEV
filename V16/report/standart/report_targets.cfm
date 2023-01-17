
<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.targetcat_id" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_excel" default="">
<cfif isdefined('attributes.is_submitted')>
	<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
	<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
	<cfif isdefined('attributes.is_sec') and len(attributes.is_sec)>
		<cfquery name="get_targets" datasource="#dsn#">
			SELECT 
					TARGET.TARGET_ID,
					TARGET.OUR_COMPANY_ID,
					TARGET.STARTDATE,
					TARGET.FINISHDATE,
					TARGET.TARGET_HEAD,
					TARGET.TARGET_NUMBER,
					TARGET.TARGETCAT_ID,
					TARGET_CAT.TARGETCAT_NAME,
					TARGET.TARGET_EMP,
					TARGET.RECORD_EMP,
					TARGET.CALCULATION_TYPE,
					TARGET.SUGGESTED_BUDGET,
					TARGET.TARGET_MONEY,
					TARGET.TARGET_WEIGHT
				FROM 
					TARGET,
					TARGET_CAT
				WHERE
					TARGET_CAT.TARGETCAT_ID = TARGET.TARGETCAT_ID	
					<cfif isdefined('attributes.is_sec') and attributes.is_sec eq 1>
						AND TARGET.OUR_COMPANY_ID IS NOT NULL
						AND TARGET.OUR_COMPANY_ID IN 
							(SELECT 
								O.COMP_ID
							FROM 
								DEPARTMENT D,BRANCH B,OUR_COMPANY O 
							WHERE 
								D.BRANCH_ID = B.BRANCH_ID AND
								B.COMPANY_ID = O.COMP_ID AND
								B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
							)
					<cfelseif isdefined('attributes.is_sec') and attributes.is_sec eq 2>
						AND TARGET.DEPARTMENT_ID IS NOT NULL
						AND TARGET.DEPARTMENT_ID IN 
							(SELECT 
								DEPARTMENT_ID
							FROM
								DEPARTMENT
							WHERE 
								DEPARTMENT.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
								)				
					</cfif>
					<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
						AND TARGET.OUR_COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">) 
					</cfif>
					<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
						AND TARGET.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#" list = "yes">) 
					</cfif>
					<cfif isdefined ('attributes.branch_id') and len(attributes.branch_id)>
						AND TARGET.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
					</cfif> 
					<cfif isdefined("attributes.keyword") and len(attributes.keyword)>AND TARGET_HEAD LIKE '%#attributes.keyword#%'</cfif>
					<cfif isdefined('attributes.targetcat_id') and len(attributes.targetcat_id)>AND TARGET.TARGETCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#" list = "yes">)</cfif>
					<cfif isdefined('attributes.start_date') and len(attributes.start_date)>AND STARTDATE >= #attributes.start_date#</cfif>
					<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>AND FINISHDATE <= #attributes.finish_date#</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="GET_TARGETS" datasource="#dsn#">
			SELECT 
				TARGET.TARGET_ID,
				TARGET.POSITION_CODE,
				TARGET.STARTDATE,
				TARGET.FINISHDATE,
				TARGET.TARGET_HEAD,
				TARGET.TARGET_NUMBER,
				TARGET.TARGETCAT_ID,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_ID,
				TARGET_CAT.TARGETCAT_NAME,
				TARGET.TARGET_EMP,
				TARGET.RECORD_EMP,
				TARGET.CALCULATION_TYPE,
				TARGET.SUGGESTED_BUDGET,
				TARGET.TARGET_MONEY,
				TARGET.TARGET_WEIGHT
			FROM 
				TARGET,
				TARGET_CAT,
				EMPLOYEE_POSITIONS,
				DEPARTMENT,
				BRANCH,
				OUR_COMPANY
			WHERE
				TARGET.POSITION_CODE IS NOT NULL AND
				TARGET_CAT.TARGETCAT_ID = TARGET.TARGETCAT_ID AND
				EMPLOYEE_POSITIONS.POSITION_CODE = TARGET.POSITION_CODE AND
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
				BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
				BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
				<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
					AND TARGET.OUR_COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list = "yes">) 
				</cfif>
				<cfif isdefined('attributes.department_id') and len(attributes.department_id)>
					AND TARGET.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#" list = "yes">) 
				</cfif>
				<cfif isdefined ('attributes.branch_id') and len(attributes.branch_id)>
					AND TARGET.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list = "yes">)
				</cfif> 
				<cfif isdefined('attributes.position_cat_id') and len(attributes.position_cat_id)>
				AND EMPLOYEE_POSITIONS.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#" list = "yes">)
				</cfif>
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND (TARGET_HEAD LIKE '%#attributes.keyword#%' OR EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%')
				</cfif>
				<cfif isdefined('attributes.targetcat_id') and len(attributes.targetcat_id)>AND TARGET.TARGETCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#" list = "yes">)</cfif>
				<cfif isdefined('attributes.start_date') and len(attributes.start_date)>AND STARTDATE >= #attributes.start_date#</cfif>
				<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>AND FINISHDATE <= #attributes.finish_date#</cfif>
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_targets.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_targets.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT * FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="GET_TARGET_CATS" datasource="#dsn#">
	SELECT * FROM TARGET_CAT
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH  WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT  WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>
<cfquery name="get_company_name" datasource="#dsn#">
	SELECT NICK_NAME,COMP_ID,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID IN 
						(SELECT 
							O.COMP_ID
						FROM 
							DEPARTMENT D,BRANCH B,OUR_COMPANY O 
						WHERE 
							D.BRANCH_ID = B.BRANCH_ID AND
							B.COMPANY_ID = O.COMP_ID AND
							B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
						)
</cfquery>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='39043.Hedefler Raporu'></cfsavecontent>
<cfform name="theform" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#" >
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-12 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
											<div class="col col-12">
													<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255">
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='41613.Hedef Tipi'></label>
											<div class="col col-12">
												<select name="is_sec" id="is_sec">
													<option value=""><cf_get_lang dictionary_id='39025.Kişisel Hedefler'></option>
													<option value="1" <cfif isdefined('attributes.is_sec') and attributes.is_sec eq 1>selected</cfif>><cf_get_lang dictionary_id='39044.Şirket Hedefleri'></option>
													<option value="2" <cfif isdefined('attributes.is_sec') and attributes.is_sec eq 2>selected</cfif>><cf_get_lang dictionary_id='39045.Departman Hedefleri'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
											<div class="col col-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="GET_POSITION_CATS"  
													name="position_cat_id"
													option_value="POSITION_CAT_ID"
													option_name="POSITION_CAT"
													option_text="#getLang('main',322)#"
													value="#attributes.position_cat_id#">
												</div>												
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-12 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
											<div class="col col-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_target_cats"  
													name="targetcat_id"
													option_value="targetcat_id"
													option_name="targetcat_name"
													option_text="#getLang('main',322)#"
													value="#attributes.targetcat_id#">
												</div>												
											</div>
										</div>
										<div class="form-group">
												<label class="col col-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
												<div class="col col-12">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Başlama Tarihi'></cfsavecontent>
														<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
														<span class="input-group-addon">
															<cf_wrk_date_image date_field="start_date">
														</span>
													</div>
												</div>
										</div>	
										<div class="form-group">	
												<label class="col col-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
												<div class="col col-12">
													<div class="input-group">
														<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
														<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
														<span class="input-group-addon">
															<cf_wrk_date_image date_field="finish_date">
														</span>
													</div>
												</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-12 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="col col-12 col-md-12">
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
											<div class="col col-12">
												<div class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_company_name"  
													name="comp_id"
													option_value="COMP_ID"
													option_name="COMPANY_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.comp_id#"
													onchange="get_branch_list(this.value)">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<div class="col col-12">
												<div id="BRANCH_PLACE" class="multiselect-z2">
													<cf_multiselect_check 
													query_name="get_branch"  
													name="branch_id"
													option_value="BRANCH_ID"
													option_name="BRANCH_NAME"
													option_text="#getLang('main',322)#"
													value="#attributes.branch_id#"
													onchange="get_department_list(this.value)">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
											<div class="col col-12">
												<div class="multiselect-z2" id="DEPARTMENT_PLACE">
													<cf_multiselect_check 
													query_name="get_department"  
													name="department"
													option_text="#getLang('main',322)#" 
													option_value="department_id"
													option_name="department_head"
													value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
												</div>
											</div>
										</div>										
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_submitted" id="is_submitted" type="hidden" value="1">
							<cf_wrk_report_search_button button_type='1' is_excel='1' search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cf_report_list>
		<thead>
				<tr> 
						<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th width="150"><cf_get_lang dictionary_id='57951.Hedef'></th>
						<cfif not isdefined('attributes.is_sec') or not len(attributes.is_sec)><th width="150"><cf_get_lang dictionary_id='57570.Ad Soyad'></th></cfif>
						<th><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th><cf_get_lang dictionary_id='39047.Hedef Veren'></th>
						<th><cf_get_lang dictionary_id='39048.Rakam'></th>
						<th><cf_get_lang dictionary_id='39049.Ayrılan Bütçe'></th>
						<th><cf_get_lang dictionary_id='29784.Ağırlık'></th>
						<th width="65"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
						<th width="65"><cf_get_lang dictionary_id='57502.Bitiş'></th>
				</tr>
		</thead>
		<cfif get_targets.recordcount>
		<cfset target_emp_list=''>
		<cfoutput query="get_targets" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfif len(target_emp) and not listfind(target_emp_list,target_emp)>
				<cfset target_emp_list=listappend(target_emp_list,target_emp)>
			</cfif>
		</cfoutput>
		<cfif len(target_emp_list)>
			<cfset target_emp_list=listsort(target_emp_list,"numeric","ASC",",")>
			<cfquery name="get_target_emp" datasource="#dsn#">
				SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#target_emp_list#) ORDER BY EMPLOYEE_ID
			</cfquery>
		</cfif>
		<tbody>
			<cfoutput query="get_targets" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td height="20">#currentrow#</td>
					<cfif attributes.is_excel eq 1>
						<td>#target_head#</td>
					<cfelse>
					<td height="20">
						<cfif isdefined('attributes.is_sec') and len(attributes.is_sec)>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_target&event=upd&target_id=#target_id#','medium');" class="tableyazi">
						<cfelse>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_target&event=upd&target_id=#target_id#&position_code=#get_targets.position_code#','medium');" class="tableyazi">
						</cfif>
						#target_head#</a>
					</td>
					</cfif>
					<cfif attributes.is_excel eq 1>
					<td>#employee_name# #employee_surname#</td>
					<cfelse>	<cfif not isdefined('attributes.is_sec') or not len(attributes.is_sec)>
								<td height="20"><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#get_targets.employee_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
						</cfif>
					</cfif>
					<td height="20">#targetcat_name#</td>	
					<td height="20">
						<cfif len(target_emp)>
							<cfif attributes.is_excel eq 1>
								#get_target_emp.EMPLOYEE_NAME[listfind(target_emp_list,TARGET_EMP,',')]#&nbsp; #get_target_emp.EMPLOYEE_SURNAME[listfind(target_emp_list,TARGET_EMP,',')]#
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#target_emp#','medium');" class="tableyazi">#get_target_emp.EMPLOYEE_NAME[listfind(target_emp_list,TARGET_EMP,',')]#&nbsp; #get_target_emp.EMPLOYEE_SURNAME[listfind(target_emp_list,TARGET_EMP,',')]#</a>
							</cfif>
						</cfif>
					</td>		
					<td height="20">
						<cfif len(target_number)>#tlformat(target_number)#&nbsp;
							(<cfif CALCULATION_TYPE eq 1> + (<cf_get_lang dictionary_id='39471.Artış Hedefi'>)
							<cfelseif CALCULATION_TYPE eq 2>- (<cf_get_lang dictionary_id='39472.Düşüş Hedefi'>)
							<cfelseif CALCULATION_TYPE eq 3>+% (<cf_get_lang dictionary_id='39473.Yüzde'> <cf_get_lang dictionary_id='39471.Artış Hedefi'>)
							<cfelseif CALCULATION_TYPE eq 4>-% (<cf_get_lang dictionary_id='39473.Yüzde'> <cf_get_lang dictionary_id='39472.Düşüş Hedefi'>)
							<cfelseif CALCULATION_TYPE eq 5>= (<cf_get_lang dictionary_id='56014.Hedeflenen Rakam'>)	
							</cfif>)
						</cfif>
					</td>    
					<td height="20" style="text-align:right"><cfif len(suggested_budget)>#tlformat(suggested_budget)#&nbsp;#target_money#</cfif></td>
					<td height="20" style="text-align:right">#tlformat(target_weight)#</td>
					<td width="100">#dateformat(startdate,dateformat_style)#</td>
					<td width="100">#dateformat(finishdate,dateformat_style)#</td>
				</tr>
			</cfoutput>
		</tbody>
		<cfelse>
		<tbody>
		<tr>
			<td colspan="10"><cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
		</tr>
		</tbody>
		</cfif>
	</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = attributes.fuseaction>
	<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)> 
		<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif isdefined("attributes.is_sec") and len(attributes.is_sec)> 
		<cfset url_str = "#url_str#&is_sec=#attributes.is_sec#">
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)> 
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)> 
		<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.department_id") and len(attributes.department_id)> 
		<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
	</cfif>
	<cfif isdefined("attributes.start_date")>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.finish_date")>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.targetcat_id")>
	  <cfset url_str = "#url_str#&targetcat_id=#attributes.targetcat_id#">
	</cfif>
	<cfif isdefined("attributes.position_cat_id")>
	  <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
	</cfif>
		<td><cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#"></td>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function control()	
	{
			if( (document.getElementById('maxrows').value == "") || (document.getElementById('maxrows').value <= 0))
		{
			alertObject({message:"<cfoutput><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfoutput>"});
			return false;
		}

		start_date = document.getElementById('start_date');
		finish_date = document.getElementById('finish_date');
		if(start_date.value != "" || finish_date.value != ""){
			
			if(date_check(start_date,finish_date,"<cfoutput>#getLang('asset',96)#</cfoutput>",1)) return true;
			else return false;

		}
			if(document.theform.is_excel.checked==false)
			{
					document.theform.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
					return true;
			}
			else
					document.theform.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_report_targets</cfoutput>"
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
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
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
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
</script>
