<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.task_status" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.form_submitted" default="0">
<cfif attributes.form_submitted>
	<cfquery name="get_warehouse_tasks" datasource="#dsn3#">
		SELECT 
			WTLM.*,
			C.NICKNAME,
			PP.PROJECT_HEAD,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS ACTION_MAN
		FROM 
			WAREHOUSE_TASKS_LOCATION_MANAGEMENT WTLM
				LEFT JOIN  #dsn_alias#.PRO_PROJECTS PP ON WTLM.PROJECT_ID=PP.PROJECT_ID
				LEFT JOIN  #dsn_alias#.COMPANY C ON WTLM.COMPANY_ID=C.COMPANY_ID
				LEFT JOIN  #dsn_alias#.EMPLOYEES E ON WTLM.EMPLOYEE_ID=E.EMPLOYEE_ID
		WHERE
			WTLM.MANAGEMENT_ID IS NOT NULL
		  <cfif len(attributes.keyword)>
			AND (
				WTLM.MANAGEMENT_NO LIKE '#attributes.keyword#' OR 
				C.FULLNAME LIKE '#attributes.keyword#%' OR
				C.NICKNAME LIKE '#attributes.keyword#%'
				)
		  </cfif>
		  <cfif len(attributes.start_date)>
			AND WTLM.ACTION_DATE >= #attributes.start_date#
		  </cfif>
		  <cfif len(attributes.finish_date)>
		  	AND WTLM.ACTION_DATE <= #attributes.finish_date#
		  </cfif>
		  <cfif len(attributes.company_id) and len(attributes.company)>
		  	AND WTLM.COMPANY_ID = #attributes.company_id#
		 <cfelseif len(attributes.consumer_id) and len(attributes.company)>
		  	AND WTLM.CONSUMER_ID = #attributes.consumer_id#
		  </cfif>
		  <cfif len(attributes.project_id) and len(attributes.project_head)>
		  	AND WTLM.PROJECT_ID = #attributes.project_id#
		  </cfif>
		ORDER BY 
			WTLM.MANAGEMENT_ID DESC
	</cfquery>
<cfelse>
	<cfset get_warehouse_tasks.recordCount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_warehouse_tasks.recordcount#'>
<cf_box>
<cfform name="service_form" method="post" action="#request.self#?fuseaction=stock.location_management">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<cf_box_search>
            	<div class="form-group">
						<cfinput type="text" placeholder="#getlang('','Filtre','57460')#" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:60px;">
                </div>
				<div class="form-group" style="display:none;">
					<select name="task_status" id="task_status" style="width:90px;">
						<option value="">Status</option>
						<option value="-1" <cfif (attributes.task_status eq -1)> selected</cfif>>Processing</option>
						<option value="1" <cfif (attributes.task_status eq 1)> selected</cfif>>Approved</option>
						<option value="0" <cfif (attributes.task_status eq 0)> selected</cfif>>Canceled</option>
					</select>  
                </div>			
                <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                        <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                        <cf_wrk_search_button button_type="4" search_function="date_check(service_form.start_date,service_form.finish_date,'#message_date#')">
                </div>
	</cf_box_search>
	<cf_box_search_detail>
        	<cfif not isdefined("session.pp.userid")>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            	<div class="form-group" id="item-company">
                	<label class="col col-12"><cf_get_lang dictionary_id="57574.Şirket"></label>
                    <div class="col col-12">
                    	<div class="input-group">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                            <input type="text" name="company" id="company" value="<cfoutput>#attributes.company#</cfoutput>" style="width:130px;">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=service_form.company_id&field_comp_name=service_form.company&field_consumer=service_form.consumer_id&field_member_name=service_form.company&select_list=2,3','list','popup_list_all_pars');"></span>
                        </div>
                    </div>
                </div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item_project_head">
				<label class="col col-12"><cf_get_lang dictionary_id="57416.Proje"></label>
					<div class="col col-12">
					<div class="input-group">
						<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
						<input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head&project_id=frm_search.project_id</cfoutput>');"></span>
					</div>
				</div>
			</div>
		</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-employee_id">						
                	<label class="col col-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>			
                    <div class="col col-12">
                        <div class="input-group">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                            <input name="employee_name" type="text" id="employee_name"  onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=service_form.employee_id&field_name=service_form.employee_name&is_form_submitted=1&select_list=1','list');"></span>
                        </div>
                    </div>
                </div>
			</div>
			</cfif>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-date">
                	<label class="col col-12"><cfoutput><cf_get_lang dictionary_id="57742.Tarih"></cfoutput></label>
                    <div class="col col-12">
                    	<div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.start_date,dateformat_style)#" type="text" name="start_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                            <span class="input-group-addon no-bg"></span>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.finish_date,dateformat_style)#" type="text" name="finish_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                </div>
            </div>
         
	</cf_box_search_detail>
</cfform>
</cf_box>
<cfset t_quantity = 0>
<cfset t_pallet = 0>
<cf_box title="#getlang('','3pl depo içi İşlem','63840')#">
<cf_grid_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='63921.Servis No'></th>
			<th><cf_get_lang dictionary_id='57574.Şirket'></th>
			<th><cf_get_lang dictionary_id='57416.Proje'></th>
			<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
			<th><cf_get_lang dictionary_id='57742.Tarih'></th>
            <!-- sil -->
			<th width="20" class="header_icn_none">
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.location_management&event=add"><i class="fa fa-plus"></i></a>
			</th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_warehouse_tasks.recordcount>	
		<cfoutput query="get_warehouse_tasks" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#currentrow#</td>
				<td><a href="#request.self#?fuseaction=stock.location_management&event=upd&management_id=#management_id#" class="tableyazi">#MANAGEMENT_NO#</a></td>
				<td><cfif len(task_id)><a href="#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#task_id#" class="tableyazi">#task_id#</a></cfif></td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#NICKNAME#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#project_head#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#ACTION_MAN#</td>
				<td style="<cfif IS_ACTIVE eq 0>color:red;</cfif>">#dateformat(ACTION_DATE,dateformat_style)#</td>
				<!-- sil -->
				<td class="header_icn_none">
					<a href="#request.self#?fuseaction=stock.location_management&event=upd&management_id=#management_id#" title="<cf_get_lang dictionary_id='57464. Guncelle'>"><i class="fa fa-pencil"></i></a> 
				</td>
				<!-- sil -->
			</tr>
		</cfoutput>
		</cfif>
	</tbody>
</cf_grid_list>
<cfif not get_warehouse_tasks.recordcount>	
<div class="ui-info-bottom">
	<p><cfif attributes.form_submitted><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
	</div>
</cfif>
</cf_box>
<cfset url_str="stock.location_management">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif len(attributes.company_id)>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif len(attributes.consumer_id)>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif len(attributes.company)>
	<cfset url_str = "#url_str#&company=#attributes.company#">
</cfif>
<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
	<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#" >
</cfif>
<cfif isdefined("attributes.service_type") and len(attributes.service_type)>
	<cfset url_str = "#url_str#&service_type=#attributes.service_type#" >
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.task_status") and len(attributes.task_status)>
	<cfset url_str = "#url_str#&task_status=#attributes.task_status#">
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#url_str#">