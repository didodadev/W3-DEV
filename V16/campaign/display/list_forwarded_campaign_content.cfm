<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.task_par_id" default="">
<cfparam name="attributes.task_cmp_id" default="">
<cfparam name="attributes.task_employee_id" default="">
<cfparam name="attributes.task_person_name" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.form_submitted" default="0">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = "">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = "">
</cfif>
<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>
	<cfquery name="get_forwarded_mail_list" datasource="#dsn3#">
	SELECT 
			E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,
			SC.CONT_ID,SC.SENDER_EMP,
			SC.SEND_DATE,
			CAM.CAMP_ID,
            CAM.CAMP_HEAD,
			C.CONT_HEAD
		FROM 
			#dsn_alias#.SEND_CONTENTS SC ,
			CAMPAIGNS CAM,
			#dsn_alias#.CONTENT_RELATION CR,
			#dsn_alias#.CONTENT C,
			#dsn_alias#.EMPLOYEES E
		WHERE
		 	CR.ACTION_TYPE = 'CAMPAIGN_ID'
			AND CR.ACTION_TYPE_ID=CAM.CAMP_ID
			AND SC.CONT_ID = C.CONTENT_ID 
			AND CR.CONTENT_ID = C.CONTENT_ID
			AND E.EMPLOYEE_ID=SC.SENDER_EMP
			AND SC.CAMP_ID=CAM.CAMP_ID
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				CAM.CAMP_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
				CAM.CAMP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
				CAM.CAMP_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif len(attributes.task_employee_id)>
			AND SC.SENDER_EMP=#attributes.task_employee_id#
		</cfif>
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND SC.SEND_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		</cfif>
		<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
			AND SC.SEND_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',7,attributes.finish_date)#">
		</cfif>
		ORDER BY SC.SEND_DATE DESC
	</cfquery>
    <cfset ids_list2="">
	<cfset campaign_id_list2 = ValueList(get_forwarded_mail_list.camp_id)>
    <cfoutput query="get_forwarded_mail_list">
        <cfset ids_list2 = listappend(ids_list2,"#camp_id#-#cont_id#")>
    </cfoutput>
    <cfset sender_id_list2 = ValueList(get_forwarded_mail_list.sender_emp)>
<cfelse>
	<cfset get_forwarded_mail_list.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.totalrecords" default="#get_forwarded_mail_list.recordcount#">
<cfset attributes.startrow =((attributes.page-1)*attributes.maxrows+1)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="mail_form" action="#request.self#?fuseaction=campaign.list_forwarded_campaign_content" method="post">
			<cf_box_search>
				<cfinput type="hidden" name="form_submitted" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang('main',48)#" maxlength="50">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input name="task_person_name" type="text" id="task_person_name" placeholder="<cfoutput>#getLang('campaign',41)#</cfoutput>" onFocus="AutoComplete_Create('task_person_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','task_employee_id','','3','125');" value="<cfif len(attributes.task_person_name) and (len(attributes.task_employee_id) or len(attributes.task_cmp_id))><cfoutput>#attributes.task_person_name#</cfoutput></cfif>" autocomplete="off">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_partner=mail_form.task_par_id&field_comp_id=mail_form.task_cmp_id&field_name=mail_form.task_person_name&field_emp_id=mail_form.task_employee_id&select_list=1</cfoutput>','list');" title="Gönderi Yapan"></span>
						<input type="hidden" name="task_par_id" id="task_par_id" value="<cfif len(attributes.task_par_id)><cfoutput>#attributes.task_par_id#</cfoutput></cfif>">
						<input type="hidden" name="task_cmp_id" id="task_cmp_id" value="<cfif len(attributes.task_cmp_id)><cfoutput>#attributes.task_cmp_id#</cfoutput></cfif>">
						<input type="hidden" name="task_employee_id" id="task_employee_id" style="width:100px;" value="<cfif len(attributes.task_employee_id)><cfoutput>#attributes.task_employee_id#</cfoutput></cfif>">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfif session.ep.our_company_info.unconditional_list>
							<cfinput name="start_date" validate="#validate_style#" maxlength="10" placeholder="#place#" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;">
						<cfelse>
							<cfinput name="start_date" validate="#validate_style#" maxlength="10" placeholder="#place#" value="#dateformat(attributes.start_date,dateformat_style)#" required="yes">
						</cfif>
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place2"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfif session.ep.our_company_info.unconditional_list>
							<cfinput name="finish_date" validate="#validate_style#" maxlength="10" placeholder="#place2#" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;">
						<cfelse>
							<cfinput name="finish_date" validate="#validate_style#" maxlength="10" placeholder="#place2#" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" required="yes">
						</cfif>
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,299" required="yes" onKeyUp="isNumber (this)" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('campaign',166)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang_main no="1165.Sıra"></th>
					<th><cf_get_lang_main no="34.Kampanya"></th>
					<th><cf_get_lang no="166.Gönderiler"></th>
					<th><cf_get_lang no="39.Gönderi Tarihi"></th>
					<th><cf_get_lang no="41.Gönderi Yapan"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_forwarded_mail_list.recordcount and form_varmi eq 1>
					<cfoutput query="get_forwarded_mail_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>
								<a href="#request.self#?fuseaction=campaign.list_campaign&event=upd&camp_id=#camp_id#" class="tableyazi">
									#get_forwarded_mail_list.camp_head[listfind(campaign_id_list2,camp_id,',')]#
								</a>
							</td>
							<td>#get_forwarded_mail_list.cont_head[listfind(ids_list2,'#camp_id#-#cont_id#',',')]#</td>
							<td><cfif Len(get_forwarded_mail_list.send_date)>#dateformat(get_forwarded_mail_list.send_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_forwarded_mail_list.send_date),timeformat_style)#</cfif></td>
							<td>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#sender_emp#','medium');" class="tableyazi">
									#get_forwarded_mail_list.employee_name[listfind(sender_id_list2,sender_emp,',')]# #get_forwarded_mail_list.employee_surname[listfind(sender_id_list2,sender_emp,',')]#
								</a>
							</td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="6"><cfif form_varmi eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayit Bulunamadi'>!</cfif></td>
						</tr>				
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfset adres="campaign.list_forwarded_campaign_content">
		<cfif isdefined("attributes.form_submitted")>
			<cfset adres="#adres#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset adres="#adres#&keyword=#URLEncodedFormat(attributes.keyword)#">
		</cfif>
		<cfif isDefined('attributes.send_date') and len(attributes.send_date)>
			<cfset adres = "#adres#&send_date=#dateformat(attributes.send_date,dateformat_style)#" >
		</cfif>
		<cfif  len(attributes.start_date)>
			<cfset adres="#adres#&start_dates=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cfset adres="#adres#&finish_dates=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif len(attributes.task_person_name)>
			<cfset adres="#adres#&task_person_name=#attributes.task_person_name#">
		</cfif>
		<cfif len(attributes.task_par_id)>
			<cfset adres="#adres#&task_par_id=#attributes.task_par_id#">
		</cfif>
		<cfif len(attributes.task_cmp_id)>
			<cfset adres="#adres#&task_cmp_id=#attributes.task_cmp_id#">
		</cfif>
		<cfif len(attributes.task_employee_id)>
			<cfset adres="#adres#&task_employee_id=#attributes.task_employee_id#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
		{
			<cfif not session.ep.our_company_info.unconditional_list>
				if(!$("#start_date").val().length)
				{
					alertObject({message: "<cfoutput><cf_get_lang_main no ='326.Başlama Tarihi Girmelisiniz'> !</cfoutput>"})    
					return false;	
				}
				if(!$("#finish_date").val().length)
				{
					alertObject({message: "<cfoutput><cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'> !</cfoutput>"}) 
					return false;	
				}
			</cfif>
			if(!$("#maxrows").val().length)
			{
				alertObject({message: "<cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'>"}) 
				return false;	
			}
			if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
	document.getElementById('keyword').focus();
</script>
