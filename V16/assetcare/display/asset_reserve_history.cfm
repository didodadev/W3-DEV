<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-30,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date) and len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',31,attributes.start_date)>
</cfif>
<cfset attributes.asset_id = (IsDefined("attributes.asset_id") and len(attributes.asset_id) ? attributes.asset_id : attributes.assetp_id)>
<cfquery name="GET_ASSET_NAME" datasource="#DSN#">
	SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam value = "#attributes.asset_id#" CFSQLType = "cf_sql_integer">
</cfquery>
<cfquery name="GET_ASSETP_RESERVE" datasource="#DSN#">
	SELECT
		ASSETP_ID,
		EVENT_ID,
		CLASS_ID,
		PROJECT_ID,
        WORK_ID,
		EVENT_PLAN_ID,
		DETAIL,
		RECORD_EMP,
		STARTDATE,
		FINISHDATE,
		RECORD_DATE
	FROM
		ASSET_P_RESERVE
	WHERE 
		ASSETP_ID = <cfqueryparam value = "#attributes.asset_id#" CFSQLType = "cf_sql_integer">
	<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
		AND STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
	<cfelseif isdate(attributes.start_date)>
		AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
	<cfelseif isdate(attributes.finish_date)>
		AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
	</cfif>
		ORDER BY STARTDATE DESC
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_assetp_reserve.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Rezervasyonlar','33512')# : #get_asset_name.assetp#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<!--- <cf_box title="#getLang('','Rezervasyonlar','33512')# : #get_asset_name.assetp#" > --->
		<cfform name="list_history" action="#request.self#?fuseaction=assetcare.popup_asset_reserve_history" method="post">
			<cf_box_search more="0">
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>">
				<div class="form-group" id="item-start_date">
					<div class="input-group col col-6 x-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="start_date" id="start_date_" placeholder="#getLang('main',641)#" value="#dateformat(attributes.start_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date_"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<div class="input-group col col-6 x-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfinput type="text" name="finish_date" id="finish_date_" placeholder="#getLang('main',288)#" value="#dateformat(attributes.finish_date, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_"></span>
					</div>
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_history' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform> 
		<cf_grid_list>
			<thead>
				<tr>
					<th style="width:25%"><cf_get_lang dictionary_id='29510.Olay'></th>
					<th style="width:25%"><cf_get_lang dictionary_id='58467.Başlama'></th>
					<th style="width:25%"><cf_get_lang dictionary_id='57502.Bitiş'></th>
					<th style="width:25%"><cf_get_lang dictionary_id='57483.Kayıt'></th>
				</tr>
			</thead>
			<tbody>
			<cfif get_assetp_reserve.recordcount>
				<cfset employee_list = "">
				<cfoutput query="get_assetp_reserve" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(record_emp) and not listfind(employee_list,record_emp)>
						<cfset employee_list = listappend(employee_list,record_emp)>
					</cfif>
				</cfoutput>
				<cfif len(employee_list)>
					<cfquery name="get_emp" datasource="#DSN#">
						SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
					</cfquery>
					<cfset employee_list = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_assetp_reserve" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(get_assetp_reserve.event_id)>
						<cfquery name="get_event" datasource="#DSN#">
							SELECT EVENT_ID,EVENT_HEAD AS RESERVE_NAME FROM EVENT WHERE EVENT_ID = #get_assetp_reserve.event_id#
						</cfquery>
					<cfelseif len(get_assetp_reserve.class_id)>
						<cfquery name="get_event" datasource="#DSN#">
							SELECT CLASS_ID,CLASS_NAME AS RESERVE_NAME FROM TRAINING_CLASS WHERE CLASS_ID= #get_assetp_reserve.class_id#
						</cfquery>
					<cfelseif len(get_assetp_reserve.project_id)>
						<cfquery name="get_event" datasource="#DSN#">
							SELECT PROJECT_ID,PROJECT_HEAD AS RESERVE_NAME FROM PRO_PROJECTS WHERE PROJECT_ID = #get_assetp_reserve.project_id#
						</cfquery>
					<cfelseif len(get_assetp_reserve.event_plan_id)>
						<cfquery name="get_event" datasource="#DSN#">
							SELECT EVENT_PLAN_ID,EVENT_PLAN_HEAD AS RESERVE_NAME FROM EVENT_PLAN WHERE EVENT_PLAN_ID = #get_assetp_reserve.event_plan_id#
						</cfquery>
					<cfelseif len(get_assetp_reserve.work_id)>
						<cfquery name="get_event" datasource="#DSN#">
							SELECT WORK_ID,WORK_HEAD AS RESERVE_NAME FROM PRO_WORKS WHERE WORK_ID = #get_assetp_reserve.work_id#
						</cfquery>                		
					</cfif>
					<tr>
						<td>
							<cfif len(get_assetp_reserve.event_id) or len(get_assetp_reserve.class_id) or len(get_assetp_reserve.project_id) or len(get_assetp_reserve.event_plan_id) or len(get_assetp_reserve.work_id)>
								#get_event.reserve_name#
							<cfelse>
								<cf_get_lang no='213.Olaysız'>
							</cfif>
							<cfif len(get_assetp_reserve.event_id)>(<cf_get_lang dictionary_id='57415.Ajanda'>)
							<cfelseif len(get_assetp_reserve.class_id)>(<cf_get_lang dictionary_id='57419.Eğitim'>)
							<cfelseif len(get_assetp_reserve.project_id)>(<cf_get_lang dictionary_id='57416.Proje'>)
							<cfelseif len(get_assetp_reserve.event_plan_id)>(<cf_get_lang dictionary_id='58422.Ziyaret Plani'>)
							<cfelseif len(get_assetp_reserve.work_id)>(<cf_get_lang dictionary_id='58445.İş'>)
							</cfif>
						</td>
						<td><cfif len(startdate)>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,startdate),timeformat_style)#</cfif></td>
						<td><cfif len(finishdate)>#dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,finishdate),timeformat_style)#</cfif></td>
						<td nowrap="nowrap">#get_emp.employee_name[listfind(employee_list,record_emp,',')]# #get_emp.employee_surname[listfind(employee_list,record_emp,',')]# - #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#)</td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif form_varmi eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayit Bulunamadi'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

<cfif (attributes.totalrecords gt attributes.maxrows)>
	<cfset adres="assetcare.popup_asset_reserve_history&asset_id=#attributes.asset_id#">
	<cfif isdate(attributes.start_date)>
		<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#adres#"
	isAjax="#iif(isdefined("attributes.draggable"),1,0)#">	
</cfif>
		
</cf_box>
</div>