<cf_xml_page_edit fuseact="objects.popup_add_work">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.currency" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.work_cat" default="">
<cfparam name="attributes.workgroup_id" default="">
<cfparam name="attributes.satir" default=""><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
<cfparam name="attributes.modal_project_id" default="#attributes.project_id#">
<cfparam name="attributes.modal_project_head" default="#attributes.project_head#">
<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND HIERARCHY IS NOT NULL ORDER BY WORKGROUP_NAME
</cfquery>
<cfquery name="GET_WORK_CAT" datasource="#DSN#">
	SELECT WORK_CAT_ID,WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
</cfquery>
<cfif xml_show_employee_name eq 1>
	<cfparam name="attributes.employee_id" default="#session.ep.userid#">
	<cfparam name="attributes.employee" default="#get_emp_info(attributes.employee_id,0,0)#">
<cfelse>
	<cfparam name="attributes.employee_id" default="">
	<cfparam name="attributes.employee" default="">
</cfif>
<cfinclude template="../query/get_works.cfm">
<cfset url_str = "">
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.comp_id")>
	<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
</cfif>
<cfif isdefined("attributes.comp_name")>
	<cfset url_str = "#url_str#&comp_name=#attributes.comp_name#">
</cfif>
<cfif isdefined("attributes.field_pro_id")>
	<cfset url_str = "#url_str#&field_pro_id=#attributes.field_pro_id#">
</cfif>
<cfif isdefined("attributes.field_pro_name")>
	<cfset url_str = "#url_str#&field_pro_name=#attributes.field_pro_name#">
</cfif>
<cfif isdefined("attributes.rel_workid")>
  <cfset url_str = "#url_str#&rel_workid=#attributes.rel_workid#">
</cfif>
<cfif isdefined("attributes.work_no")>
  <cfset url_str = "#url_str#&work_no=#attributes.work_no#">
</cfif>
<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
	<cfset adres= "#url_str#&workgroup_id=#attributes.workgroup_id#">
</cfif>
<cfif isdefined("attributes.work_cat") and len(attributes.work_cat)>
	<cfset adres= "#url_str#&work_cat=#attributes.work_cat#">
</cfif>
<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.popup_add_work%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_works.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','İşler/Görevler',49233)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="list_work" method="post" action="#request.self#?fuseaction=objects.popup_add_work&#url_str#">
			<cfinput type="hidden" name="satir" value="#attributes.satir#"><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
			<cf_wrk_alphabet keyword="url_str" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfinput type="hidden" name="is_form_submitted" value="1">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="work_cat">
					<select name="work_cat" id="work_cat">
					<option value=""><cf_get_lang dictionary_id='57486.kategori'></option>
						<cfoutput query="get_work_cat">
							<option value="#get_work_cat.work_cat_id#" <cfif attributes.work_cat eq get_work_cat.work_cat_id>selected</cfif>>#get_work_cat.work_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="currency">
					<select name="currency" id="currency">
						<option value="" selected><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_procurrency">
							<option value="#process_row_id#"<cfif attributes.currency eq get_procurrency.process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="workgroup_id">
					<select name="workgroup_id" id="workgroup_id">				  
						<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
						<cfoutput query="get_workgroups">
							<option value="#get_workgroups.workgroup_id#"<cfif attributes.workgroup_id eq workgroup_id>selected</cfif>>#get_workgroups.workgroup_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="status">
					<select name="status" id="status">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>			                        
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" maxlength="3" onKeyUp="isNumber(this)" name="maxrows" value="#attributes.maxrows#">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_work', #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search> 
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_work', #attributes.modal_id#)"),DE(""))#">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<div class="col col-12">
							<div class="input-group">
								<cfif isdefined('attributes.sarf_project_id') and len(attributes.sarf_project_id)>
									<cfquery name="get_project" datasource="#dsn#">
										SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID=#attributes.sarf_project_id#
									</cfquery>
									<input type="hidden" name="sarf_project_id"  id="sarf_project_id"  value="<cfoutput>#attributes.sarf_project_id#</cfoutput>">
									<input name="sarf_project_head" type="text" id="sarf_project_head" readonly="readonly"  value="<cfoutput>#get_project.project_head#</cfoutput>" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.sarf_project_head&sarf_project_id=list_works.sarf_project_id</cfoutput>');"></span>
								<cfelse>
									<input type="hidden" name="modal_project_id"  id="modal_project_id" value="<cfoutput>#attributes.modal_project_id#</cfoutput>">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
									<input type="text" name="modal_project_head" placeholder="<cfoutput>#message#</cfoutput>" id="modal_project_head"  onFocus="AutoComplete_Create('modal_project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','modal_project_id','list_work','3','250');" value="<cfoutput>#attributes.modal_project_head#</cfoutput>" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=list_works.modal_project_head&project_id=list_works.modal_project_id</cfoutput>');"></span>
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57569.Görevli'></cfsavecontent>
								<input type="hidden" name="employee_id" placeholder="<cfoutput>#message#</cfoutput>" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
								<input type="text" name="employee" id="employee" value="<cfif isdefined("attributes.employee") and len(attributes.employee)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" >
								<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_work.employee_id&field_name=list_work.employee&select_list=1');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group">
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='58766.Başlangıç Tarihi Yanlış'></cfsavecontent>
								<cfinput name="date1" type="text" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" valign="middle" message="#alert#" style=" text-align:right;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='58767.Bitiş Tarihi Yanlış'></cfsavecontent>
								<cfinput name="date2" type="text" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" valign="middle" message="#alert#" style=" text-align:right;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>   
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id ='58527.ID'></th>
					<th><cf_get_lang dictionary_id ='57487.No'></th>
					<th><cf_get_lang dictionary_id ='58445.İş'></th>
					<th><cf_get_lang dictionary_id ='57416.Proje'></th>
					<th><cf_get_lang dictionary_id ='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id ='57569.Görevli'></th>
					<th><cf_get_lang dictionary_id ='58467.Başlama'></th>
					<th><cf_get_lang dictionary_id ='57502.Bitiş'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_works.recordcount and isdefined("attributes.is_form_submitted")>
					<cfset project_stage_list = "">
					<cfoutput query="get_works" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(work_currency_id) and not listfind(project_stage_list,work_currency_id)>
							<cfset project_stage_list=listappend(project_stage_list,work_currency_id)>
						</cfif>
					</cfoutput>
					<cfif len(project_stage_list)>
						<cfset project_stage_list = listsort(project_stage_list,'numeric','ASC',',')>
						<cfquery name="get_currency_name" datasource="#dsn#">
							SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#project_stage_list#) ORDER BY PROCESS_ROW_ID
						</cfquery>
					</cfif>
					<cfoutput query="get_works" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(company_id)>
							<cfquery name="get_comp" datasource="#dsn#">
								SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #company_id#
							</cfquery>
							<cfset comp_name = #get_comp.fullname#>
						<cfelse>
							<cfset comp_name = ''>
						</cfif>
						<cfif len(project_id)>
							<cfquery name="get_pro_name" datasource="#dsn#">
								SELECT PROJECT_HEAD,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID = #project_id#
							</cfquery>
							<cfset field_pro_name = get_pro_name.project_head>
							<cfset field_pro_number = get_pro_name.project_number>
						<cfelse>
							<cfset field_pro_name = ''>
							<cfset field_pro_number = ''>
						</cfif>
						<tr>
							<td width="15">#work_id#</td>
							<td width="30">#work_no#</td>
							<td><a href="javascript://" onclick="add_user('#work_id#','#replace(replace(work_head,"'"," ","all"),'"',' ','all')#','#company_id#','#comp_name#','#project_id#','#replace(replace(field_pro_name,'"',' ','all'),"'"," ","all")#','#work_no#');" class="tableyazi">#work_head#</a></td>
							<td width="90"><cfif len(project_id)>#field_pro_number# - #field_pro_name#</cfif></td>
							<td>#get_currency_name.stage[listfind(project_stage_list,work_currency_id,',')]#</td>
							<td>#get_emp_info(PROJECT_EMP_ID,0,1)#</td>
							<td>#dateformat(target_start,dateformat_style)#</td>
							<td>#dateformat(target_finish,dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.currency)>
			<cfset url_str = "#url_str#&currency=#attributes.currency#">
		</cfif>
		<cfif len(attributes.status)>
			<cfset url_str = "#url_str#&status=#attributes.status#">
		</cfif>
		<cfif len(attributes.date1)>
			<cfset url_str = "#url_str#&date1=#dateformat(attributes.date1,dateformat_style)#">
		</cfif>
		<cfif len(attributes.date2)>
			<cfset url_str = "#url_str#&date2=#dateformat(attributes.date2,dateformat_style)#">
		</cfif>
		<cfif len(attributes.modal_project_id)>
			<cfset url_str = "#url_str#&modal_project_id=#attributes.modal_project_id#">
		</cfif>
		<cfif len(attributes.modal_project_head)>
			<cfset url_str = "#url_str#&modal_project_head=#attributes.modal_project_head#">
		</cfif>
		<cfif len(attributes.employee_id)>
			<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
		</cfif>
		<cfif isdefined("attributes.employee")>
			<cfset url_str = "#url_str#&employee=#attributes.employee#">
		</cfif>
		<cfif isdefined("attributes.rel_workid")>
			<cfset url_str = "#url_str#&rel_workid=#attributes.rel_workid#">
		</cfif>
		<cfif isdefined("attributes.work_no")>
			<cfset url_str = "#url_str#&work_no=#attributes.work_no#">
		</cfif>
		<cfif isdefined("attributes.sarf_project_id") and len(attributes.sarf_project_id)>
			<cfset url_str="#url_str#&sarf_project_id=#attributes.sarf_project_id#">
		</cfif>
		<cfif isdefined("attributes.workgroup_id") and len(attributes.workgroup_id)>
			<cfset url_str= "#url_str#&workgroup_id=#attributes.workgroup_id#">
		</cfif>
		<cfif isdefined("attributes.is_form_submitted")>
			<cfset url_str= "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>
		<cfif isdefined("attributes.work_cat") and len(attributes.work_cat)>
			<cfset url_str= "#url_str#&work_cat=#attributes.work_cat#">
		</cfif>
		<cfif isdefined("attributes.satir") and len(attributes.satir)><!--- Basket Çalışmaları için eklendi. Kaldırmayınız. EY20140826--->
			<cfset url_str= "#url_str#&satir=#attributes.satir#">
		</cfif>
		<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
			<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows and isdefined("is_form_submitted")>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="objects.popup_add_work&#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$( "#keyword" ).focus();
	});
	function add_user(id,name,comp_id,comp_name,pro_id,pro_name,work_no)
	{
		<cfif isdefined("attributes.satir") and len(attributes.satir)>
			var satir = <cfoutput>#attributes.satir#</cfoutput>;
		<cfelse>
			var satir = -1;
		</cfif>
		if(window.basketManager !== undefined){updateBasketItemFromPopup(satir, { ROW_WORK_ID: id, ROW_WORK_NAME: name });}
		else{
			
			if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.basket && satir > -1) 
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.updateBasketItemFromPopup(satir, { ROW_WORK_ID: id, ROW_WORK_NAME: name }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
			else
			{
				<cfif isdefined("attributes.field_id") and listlen(attributes.field_id,'.') eq 2> 
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
				<cfelseif isdefined("attributes.field_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
				</cfif>
				<cfif isdefined("attributes.field_name") and listlen(attributes.field_name,'.') eq 2>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.focus();
				<cfelseif isdefined("attributes.field_name")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_name#</cfoutput>.focus();
				</cfif>
				<cfif isdefined("attributes.comp_id") and listlen(attributes.comp_id,'.') eq 2>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.comp_id#</cfoutput>.value = comp_id;
				<cfelseif isdefined("attributes.comp_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.comp_id#</cfoutput>.value = comp_id;
				</cfif>
				<cfif isdefined("attributes.comp_name") and listlen(attributes.comp_name,'.') eq 2>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.comp_name#</cfoutput>.value = comp_name;
				<cfelseif isdefined("attributes.comp_name")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.comp_name#</cfoutput>.value = comp_name;
				</cfif>
				<cfif isdefined("attributes.field_pro_id") and listlen(attributes.field_pro_id,'.') eq 2>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pro_id#</cfoutput>.value = pro_id;
				<cfelseif isdefined("attributes.field_pro_id")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_pro_id#</cfoutput>.value = pro_id;
				</cfif>
				<cfif isdefined("attributes.field_pro_name") and listlen(attributes.field_pro_name,'.') eq 2>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_pro_name#</cfoutput>.value = pro_name;
				<cfelseif isdefined("attributes.field_pro_name")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_pro_name#</cfoutput>.value = pro_name;
				</cfif>
				<cfif isdefined("attributes.work_no")>
					<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.work_no#</cfoutput>.value = work_no;
				</cfif>
			}
		}
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>
