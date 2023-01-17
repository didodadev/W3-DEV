<cfinclude template="../query/get_crm_name.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfif form_varmi eq 1>
	<cfinclude template="../query/get_crm.cfm">
<cfelse>
	<cfset get_crm.recordcount=0>
</cfif>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset attributes.finish_date = dateformat(attributes.finish_date, dateformat_style)>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_crm.recordcount#>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function add_user(id,name,comp_id)
{
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_comp_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#field_comp_id#</cfoutput>.value = comp_id;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
<!--- letters --->
<cfset url_string = "">
<cfif isdefined("attributes.islem")>
  <cfset url_string = "#url_string#&islem=#islem#">
</cfif>
<cfif isdefined("attributes.field_type")>
  <cfset url_string = "#url_string#&field_type=#field_type#">
</cfif>
<cfif isdefined("attributes.var_new")>
  <cfset url_string = "#url_string#&var_new=#var_new#">
</cfif>
<cfif isdefined("attributes.field_name")>
  <cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("url.come")>
  <cfset url_string = "#url_string#&come=#url.come#">
</cfif>
<cfif isdefined("attributes.field_id")>
  <cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("attributes.field_code")>
  <cfset url_string = "#url_string#&field_code=#field_code#">
</cfif>
<cfif isdefined("attributes.field_comp_id")>
  <cfset url_string = "#url_string#&field_comp_id=#field_comp_id#">
</cfif>
<cfif isdefined("attributes.field_partner")>
  <cfset url_string = "#url_string#&field_partner=#field_partner#">
</cfif>
<cfif isdefined("attributes.field_emp_id")>
  <cfset url_string = "#url_string#&field_emp_id=#field_emp_id#">
</cfif>
<cfif isdefined("attributes.field_dep_name")>
  <cfset url_string = "#url_string#&field_dep_name=#field_dep_name#">
</cfif>
<cfif isdefined("attributes.field_branch_name")>
  <cfset url_string = "#url_string#&field_branch_name=#field_branch_name#">
</cfif>
<cfif isdefined("attributes.field_consumer")>
  <cfset url_string = "#url_string#&field_consumer=#field_consumer#">
</cfif>
<cfif isdefined("attributes.field_consno")>
  <cfset url_string = "#url_string#&field_consno=#field_consno#">
</cfif>
<cfif isdefined("attributes.startdate")>
  <cfset url_string = "#url_string#&startdate=#startdate#">
</cfif>
<cfif isdefined("attributes.finishdate")>
  <cfset url_string = "#url_string#&finishdate=#finishdate#">
</cfif>
<cfif isdefined("attributes.field_comp_name")>
  <cfset url_string = "#url_string#&field_comp_name=#field_comp_name#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Servis',57656)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_crm" action="#request.self#?fuseaction=myhome.popup_add_crm#url_string#" method="post">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_crm',#attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_crm',#attributes.modal_id#)"),DE(""))#">
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
								<input type="text" name="project_head" id="project_head" value="<cfif isdefined("attributes.project_head") and len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span>
							</div>
						</div>	 
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31036.Basvuru'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="EMPLOYEE_ID_" id="EMPLOYEE_ID_" value="<cfif isdefined("attributes.employee_id_")><CFOUTPUT>#attributes.employee_id_#</CFOUTPUT></cfif>">
								<input type="hidden" name="PARTNER_ID_" id="PARTNER_ID_" value="<cfif isdefined("attributes.partner_id_")><CFOUTPUT>#attributes.partner_id_#</CFOUTPUT></cfif>">
								<input type="hidden" name="consumer_id_" id="consumer_id_" value="<cfif isdefined("attributes.consumer_id_")><CFOUTPUT>#attributes.consumer_id_#</CFOUTPUT></cfif>">
								<input type="hidden" name="company_id_" id="company_id_" value="<cfif isdefined("attributes.company_id_")><CFOUTPUT>#attributes.company_id_#</CFOUTPUT></cfif>">
								<input type="text" name="made_application" id="made_application" value="<cfif isdefined("attributes.made_application")><cfoutput>#attributes.made_application#</cfoutput></cfif>" maxlength="255">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_location=service&field_emp_id=search_crm.EMPLOYEE_ID_&field_partner=search_crm.PARTNER_ID_&field_consumer=search_crm.consumer_id_&field_comp_id=search_crm.company_id_&field_name=search_crm.made_application&select_list=1,2,3,5,6&keyword='+encodeURIComponent(document.search_crm.made_application.value),'list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="start_date" value="#attributes.start_date#" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="finish_date" value="#attributes.finish_date#" validate="#validate_style#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='31036.Başvuru'></th>
					<th><cf_get_lang dictionary_id='31362.Başvuru Tarihi'></th>
					<th><cf_get_lang dictionary_id='29514.Başvuru Yapan'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_crm.recordcount and form_varmi eq 1>
					<cfset company_id_list=''>
					<cfset consumer_id_list=''>
					<cfset employee_id_list=''>
					<cfset project_name_list = ''>
					<cfoutput query="get_crm" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<cfif len(SERVICE_COMPANY_ID) and not listfind(company_id_list,SERVICE_COMPANY_ID)>
						<cfset company_id_list=listappend(company_id_list,SERVICE_COMPANY_ID)>
						</cfif>
						<cfif len(SERVICE_CONSUMER_ID) and not listfind(consumer_id_list,SERVICE_CONSUMER_ID)>
						<cfset consumer_id_list=listappend(consumer_id_list,SERVICE_CONSUMER_ID)>
						</cfif>
						<cfif len(SERVICE_EMPLOYEE_ID) and not listfind(employee_id_list,SERVICE_EMPLOYEE_ID)>
						<cfset employee_id_list=listappend(employee_id_list,SERVICE_EMPLOYEE_ID)>
						</cfif>
						<cfif len(PROJECT_ID) and not listfind(project_name_list,PROJECT_ID)>
							<cfset project_name_list = Listappend(project_name_list,PROJECT_ID)>
						</cfif>
					</cfoutput>
					<cfif len(company_id_list)>
						<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
						<cfquery name="get_company_detail" datasource="#dsn#">
							SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="get_consumer_detail" datasource="#dsn#">
							SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif>
					<cfif len(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="get_emp_detail" datasource="#dsn#">
							SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfif len(project_name_list)>
						<cfset project_name_list = listsort(project_name_list,"numeric","ASC",",")>
						<cfquery name="get_project" datasource="#dsn#">
							SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
						</cfquery>
					</cfif>  
					<cfoutput query="get_crm" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="50">#service_ID#</td>
							<td><cfset service_head_ = Replace(service_head,"'","","all")>
								<a href="javascript://" onclick="add_user('#service_id#','#service_head_#','#SERVICE_COMPANY_ID#');">#service_head#</a></td>
							<td><cfif len(APPLY_DATE)>#dateformat(APPLY_DATE,dateformat_style)# #timeformat(APPLY_DATE,timeformat_style)#</cfif></td>
							<td><cfif len(GET_CRM.SERVICE_COMPANY_ID)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#SERVICE_COMPANY_ID#','medium');" class="tableyazi"> #get_company_detail.NICKNAME[listfind(company_id_list,SERVICE_COMPANY_ID,',')]# </a> - #APPLICATOR_NAME#
								<cfelseif len(GET_CRM.SERVICE_CONSUMER_ID)>
									#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,SERVICE_CONSUMER_ID,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,SERVICE_CONSUMER_ID,',')]#
								<cfelseif len(GET_CRM.SERVICE_EMPLOYEE_ID)>
									#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,SERVICE_EMPLOYEE_ID,',')]#&nbsp; #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,SERVICE_EMPLOYEE_ID,',')]#
								</cfif>
							</td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif get_crm.recordcount eq 0>
			<div class="ui-info-bottom">
				<p><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</cfif></p>
			</div>
		</cfif>
		<cfif get_crm.recordcount>
			<cfset adres = ''>
			<cfif isdefined("attributes.keyword")>
				<cfset adres = adres & "&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.start_date")>
				<cfset adres = adres & "&start_date=#attributes.start_date#">
			</cfif>
			<cfif isdefined("attributes.finish_date")>
				<cfset adres = adres & "&finish_date=#attributes.finish_date#">
			</cfif>
			<cfif isdefined("attributes.employee_id_")>
				<cfset adres = adres & "&employee_id_=#attributes.employee_id_#">
			</cfif>
			<cfif isdefined("attributes.partner_id_")>
				<cfset adres = adres & "&partner_id_=#attributes.partner_id_#">
			</cfif>
			<cfif isdefined("attributes.consumer_id_")>
				<cfset adres = adres & "&consumer_id_=#attributes.consumer_id_#">
			</cfif>
			<cfif isdefined("attributes.made_application")>
				<cfset adres = adres & "&made_application=#attributes.made_application#">
			</cfif>
			<cfif isdefined('attributes.project_id') and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
					<cfset adres = adres & "&project_id=#attributes.project_id#&project_head=#URLEncodedFormat(attributes.project_head)#">
				</cfif>
			<cfset adres = "#adres#&is_form_submitted=1">
				<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="myhome.popup_add_crm#adres#"></td>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	$("#wrk_search_button").click(function() {
		return date_check(document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='56017.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
		});
</script>	
