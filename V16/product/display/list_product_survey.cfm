<cfinclude template="../query/get_surveys.cfm">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_surveys.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.modal_id" default="">

<cf_box title="#getLang('','Anketler',57947)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search" method="post" action="#request.self#?fuseaction=product.popup_list_product_surveys">
		<cf_box_search more="0">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
			</div>		
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr> 
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58662.Anket'></th>
				<th><cf_get_lang dictionary_id='58810.Soru'></th>
				<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
				<th><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_surveys.recordcount and form_varmi eq 1>
				<cfoutput query="get_surveys" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<cfquery name="GET_EMPS" datasource="#dsn#">
						SELECT
							EMPLOYEE_ID,
							EMPLOYEE_NAME,
							EMPLOYEE_SURNAME
						FROM
							EMPLOYEES
						WHERE
							EMPLOYEE_ID  = #RECORD_EMP#
					</cfquery>
					<tr> 
					<td>#survey_id#</td>
					<td>
					<cfif get_module_user(15)>
					<a href="#request.self#?fuseaction=campaign.form_vote_survey&survey_id=#survey_id#" target="_blank">#survey_head#</a>
					<cfelse>
					#survey_head#
					</cfif>				  
					</td>
					<td>#survey#</td>
					<td><cfif GET_EMPS.RecordCount><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_EMPS.employee_id#')">#GET_EMPS.employee_name# #GET_EMPS.employee_surname#</a></cfif></td>
					<td>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</td>
					<td>#STAGE_NAME#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr> 
				<td colspan="6"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfset url_str = "#url_str#&is_form_submitted=1">
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#&product_id=#attributes.product_id#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 
	</cfif>
</cf_box>
