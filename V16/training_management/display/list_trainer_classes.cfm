<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfscript>
	url_str = "";
	if (len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (len(attributes.online))
		url_str = "#url_str#&online=#attributes.online#";
	if (len(attributes.tip))
		url_str = "#url_str#&tip=#attributes.tip#";
	if (len(attributes.trainer_id))
		url_str = "#url_str#&trainer_id=#attributes.trainer_id#";
</cfscript>
<cfif attributes.tip is "calisan">
	<cfset attributes.employee_id = attributes.trainer_id>
<cfelseif attributes.tip is "partner">
	<cfset attributes.partner_id = attributes.trainer_id>
<cfelseif attributes.tip is "consumer">
	<cfset attributes.consumer_id = attributes.trainer_id>
<cfelseif attributes.tip is "group">
	< cf_get_lang dictionary_id='52485.grup'>
	<cfset attributes.group_id = attributes.trainer_id>
</cfif>
<cfinclude template="../query/get_trainer_classes.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_trainer_classes.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.trail")>
	<cfif attributes.tip is "calisan">
		<cfinclude template="view_employee_info.cfm">
	<cfelseif attributes.tip is "partner">
		<cfinclude template="view_partner_info.cfm">
	<cfelseif attributes.tip is "group">
		<cf_get_lang dictionary_id='52485.grup'>
		<cfset attributes.group_id = attributes.trainer_id>
	</cfif>
</cfif>
<cfsavecontent variable="head_">
	<cf_get_lang dictionary_id='55913.Eğitimci'>:
		<cfif attributes.tip is "calisan">
			<cfset attributes.employee_id = attributes.trainer_id>
			<cfinclude template="../query/get_employee.cfm">
			<cfoutput>#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#</cfoutput>
		<cfelseif attributes.tip is "partner">
			<cfset attributes.partner_id = attributes.trainer_id>
			<cfinclude template="../query/get_partner.cfm">
			<cfoutput>#GET_PARTNER.COMPANY_PARTNER_NAME# #GET_PARTNER.COMPANY_PARTNER_SURNAME#/#GET_PARTNER.FULLNAME#</cfoutput>
		<cfelseif attributes.tip is "consumer">
			<cfset attributes.con_id = attributes.trainer_id>
		<cfinclude template="../query/get_consumer.cfm">
			<cfoutput>#GET_CONSUMER.CONSUMER_NAME# #GET_CONSUMER.CONSUMER_SURNAME#/ #GET_CONSUMER.COMPANY#</cfoutput>
		</cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#head_#" scroll="1" collapsable="1" uidrop="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">

<cf_grid_list>
	<thead>
		<tr>
			<th colspan="5"><cf_get_lang dictionary_id='46389.Verdiği Eğitimler'></th>
		</tr>
		<tr>
			<!-- sil -->
			<!--- <th width="20"></th> --->
			<!-- sil -->
			<th width="150"><cf_get_lang dictionary_id='29912.Eğitimler'></th>
			<th><cf_get_lang dictionary_id='58580.Başarı'></th>
			<th width="130"><cf_get_lang dictionary_id='57742.Tarih'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_trainer_classes.RecordCount>
			<cfoutput query="get_trainer_classes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset attributes.class_id = get_trainer_classes.CLASS_ID>
				<cfinclude template="../query/get_class.cfm">
				<cfloop query="get_class" >
					<tr>
					<!-- sil -->
						<!--- <td width="20" align="center"> #attributes.class_id#
							<cfif Len(start_date) AND Len(finish_date) AND (datediff('n',now(),start_date) lte 15) and (datediff('n',now(),finish_date) gte 0)>
								<a href="javascript://" onClick="windowopen('/COM_MX/onlineclass.swf?class_id=#class_id#&username=#session.ep.username#&server=#employee_domain#&appDirectory=#dsn#','project');"><img src="/images/onlineuser.gif"  border="0" title="<cf_get_lang dictionary_id='46232.Derse Katıl'>"></a>
							</cfif>
						</td> --->
						<!-- sil -->
						<td><a href="javascript://" onClick="<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.location.href='#request.self#?fuseaction=training_management.form_upd_class&class_id=#class_id#';self.close();">#class_name#</a></td>
						<cfinclude template="../query/get_trainer_success_rate.cfm">
						<td>#success_rate#</td>
						<td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
					</tr>
				</cfloop>
			</cfoutput>
			<cfelse>
			<tr>
				<td colspan="5"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="training_management.popup_trainer_classes#url_str#"
		isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
</cfif>

</cf_box>
</div>