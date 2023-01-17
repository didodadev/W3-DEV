<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.BRANCH_ID")>
	<cfset url_str = "#url_str#&BRANCH_ID=#attributes.BRANCH_ID#">
<cfelse>
	<cfset attributes.BRANCH_ID = "">
</cfif>
<cfif isdefined("attributes.POSITION_CAT_ID")>
	<cfset url_str = "#url_str#&POSITION_CAT_ID=#attributes.POSITION_CAT_ID#">
<cfelse>
	<cfset attributes.POSITION_CAT_ID = "">
</cfif>
<cfinclude template="../query/get_class.cfm">
<cfquery name="get_training_class_attendance" datasource="#dsn#">
	SELECT 
		CLASS_ATTENDANCE_ID,
		CLASS_ID,
		START_DATE,
		FINISH_DATE 
	FROM 
		TRAINING_CLASS_ATTENDANCE 
	WHERE 
		CLASS_ID=#attributes.CLASS_ID# 
	ORDER BY 
		START_DATE,FINISH_DATE 
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_training_class_attendance.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.trail")>
	<cfinclude template="view_class.cfm">
</cfif>
<cf_popup_box title="#getLang('training_management',186)#">	  
	<cf_medium_list>
		<thead>
			<tr> 
				<th width="125"><cf_get_lang_main no='243.Başlangıç Tarihi'></th>
				<th><cf_get_lang_main no='288.Bitiş Tarihi'></th>
				<th width="15" align="center"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=training_management.popup_form_add_class_attendance&class_id=#attributes.class_id#</cfoutput>','medium');"><img src="/images/plus_list.gif" align="absbottom" title="<cf_get_lang no='21.Yoklama Ekle'>" border="0"></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_training_class_attendance.RECORDCOUNT>
				<cfoutput query="get_training_class_attendance"> 
					<cfset start_date_NEW = date_add('h', session.ep.time_zone, start_date)>
					<cfset finish_date_NEW = date_add('h', session.ep.time_zone, finish_date)>
					<tr>
						<td>#DateFormat(start_date_NEW,dateformat_style)# #TimeFormat(start_date_NEW,timeformat_style)#</td>
						<td>#DateFormat(finish_date_NEW,dateformat_style)# #TimeFormat(finish_date_NEW,timeformat_style)#</td>
						<td width="15" align="center">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_form_upd_class_attendance&class_id=#attributes.class_id#&class_attendance_id=#CLASS_ATTENDANCE_ID#','medium');"><img src="/images/update_list.gif" align="absbottom" title="<cf_get_lang no='92.Yoklama Güncelle'>" border="0"></a>
						</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="4">
					<cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td> 
				</tr>
			</cfif> 
		</tbody>
	</cf_medium_list>
</cf_popup_box>

