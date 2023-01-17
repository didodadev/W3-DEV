<cfparam name="attributes.date" default="#dateformat(createodbcdatetime('#session.ep.period_year#-#month(now())#-1'),dateformat_style)#">
<cfparam name="attributes.date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.form_submitted" default="0">
<cfparam name="attributes.browser_info" default="">
<cfparam name="attributes.visit_site" default="">
<cfparam name="attributes.visit_module" default="">
<cfparam name="attributes.tip" default="">
<cfparam name="attributes.visit_fuseaction" default="">
<cfif isdefined("attributes.tip")>
	<cfif attributes.tip is 'Ziyaretci'>
        <cfset attributes.tip = -1>
    <cfelseif attributes.tip is 'Consumer'>
        <cfset attributes.tip = 2>
    <cfelseif attributes.tip is 'Partner'>
        <cfset attributes.tip = 1>
    <cfelseif attributes.tip is 'Calisan'>
        <cfset attributes.tip = 0>
    </cfif> 
</cfif>
<cf_date tarih="attributes.date">
<cf_date tarih="attributes.date2">
<cfquery datasource="#dsn#" name="get_wrk_visit_report">
	SELECT TOP 1000
		BROWSER_INFO,
		VISIT_SITE,
		VISIT_MODULE,
		CASE USER_TYPE 
				 WHEN '0' THEN 'Calisan'
				 WHEN '1' THEN 'Partner'
				 WHEN '2' THEN 'Consumer'
				 WHEN '-1' THEN 'Ziyaretci'
		END AS USER_TYPE,
		(CASE USER_TYPE 
				 WHEN '0' THEN (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID=WS.USER_ID)
				 WHEN '1' THEN 	(SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME AS NAME FROM COMPANY_PARTNER WHERE PARTNER_ID =WS.USER_ID)
				 WHEN '2' THEN (SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID=WS.USER_ID )
				 WHEN '-1' THEN VISIT_IP
		END )AS FULLNAME  ,
		VISIT_FUSEACTION,
        VISIT_DATE		
	FROM 
		WRK_VISIT WS
	WHERE
		1=1
		<cfif isdefined("attributes.browser_info") and len(attributes.browser_info)>
			AND BROWSER_INFO='#attributes.browser_info#'
		</cfif>
		<cfif isdefined("attributes.visit_site") and len(attributes.visit_site)>
			and VISIT_SITE='#attributes.visit_site#' 
		</cfif>
		<cfif isdefined("attributes.visit_module") and len(attributes.visit_module)>
			and VISIT_MODULE='#attributes.visit_module#' 
		</cfif>
		<cfif isdefined("attributes.tip") and len(attributes.tip)>
			and USER_TYPE=#attributes.tip#  
		</cfif>
		<cfif isdefined("attributes.visit_fuseaction") and len(attributes.visit_fuseaction)>
			AND	VISIT_FUSEACTION ='#attributes.visit_fuseaction#' 
		</cfif>
		<cfif isdefined("attributes.date") and len(attributes.date) and isdefined("attributes.date2") and len(attributes.date2)>
			AND  VISIT_DATE < #attributes.date2# and VISIT_DATE > #attributes.date#
		</cfif>
        <cfif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type  is 'Consumer' and isdefined("attributes.consumer_id") and isdefined("attributes.company") and len(attributes.company)>
        	and USER_ID = #attributes.consumer_id#
        <cfelseif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type  is 'partner' and isdefined("attributes.partner_id") and isdefined("attributes.company") and len(attributes.company)>
        	and USER_ID = #attributes.partner_id#
        <cfelseif isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type  is 'employee' and isdefined("attributes.employee_id") and isdefined("attributes.company") and len(attributes.company)>
        	and USER_ID = #attributes.employee_id#
        </cfif>         
	ORDER BY 
			VISIT_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_wrk_visit_report.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40716.Ziyaret Takip Raporu'><cf_get_lang dictionary_id='32403.Bireysel'>(1000)</cfsavecontent>
	<cf_box title="#title#">
		<cfform name="form" action="#request.self#?fuseaction=report.visit_report_user_detail" method="post">
			<cf_box_search >
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<input type="hidden" name="browser_info" id="browser_info" value="<cfoutput>#attributes.browser_info#</cfoutput>" />
				<input type="hidden" name="VISIT_SITE" id="VISIT_SITE" value="<cfoutput>#attributes.VISIT_SITE#</cfoutput>" />
				<input type="hidden" name="VISIT_MODULE" id="VISIT_MODULE" value="<cfoutput>#attributes.VISIT_MODULE#</cfoutput>" />
				<input type="hidden" name="TIP" id="TIP" value="<cfoutput>#attributes.TIP#</cfoutput>" />
				<input type="hidden" name="VISIT_FUSEACTION" id="VISIT_FUSEACTION" value="<cfoutput>#attributes.VISIT_FUSEACTION#</cfoutput>" />
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
						<input type="hidden" name="consumer_id" id="consumer_id"  value="<cfif len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
						<input type="hidden" name="company_id" id="company_id"  value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
						<input name="company" type="text" id="company" placeholder="<cf_get_lang dictionary_id="57519.Cari Hesap">" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','PARTNER_ID,COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','partner_id,company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=form.company&field_partner=form.partner_id&field_comp_id=form.company_id&field_consumer=form.consumer_id&field_member_name=form.company&field_emp_id=form.employee_id&field_name=form.company&field_type=form.member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,9</cfoutput>&keyword='+encodeURIComponent(document.form.company.value),'list')"><img src="/images/plus_thin.gif" align="absbottom" title="<cf_get_lang_main no='322.seçiniz'>"></a></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi Giriniz'></cfsavecontent>	
						<cfinput value="#dateformat(attributes.date,dateformat_style)#" type="text" name="date" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='41040.Lütfen Bitiş Tarihi Giriniz'></cfsavecontent>	
						<cfinput value="#dateformat(attributes.date2,dateformat_style)#" type="text" name="date2" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date2"></span>
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button is_excel="0" button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_report_list>
		<thead>
		<tr class="color-header">
			<th width="15"><cf_get_lang dictionary_id="58577.Sıra"></th>
			<th width="100"><cf_get_lang dictionary_id="60135.Browser Info"></th>
			<th width="100"><cf_get_lang dictionary_id="57892.Domain"></th>
			<th width="80"><cf_get_lang dictionary_id="52749.Module"></th>
			<th><cf_get_lang dictionary_id="36185.Fuseaction"></th>
			<th><cf_get_lang dictionary_id="38925.User Type"></th>
			<th><cf_get_lang dictionary_id="61332.Name"></th>
			<th width="90"><cf_get_lang dictionary_id="52773.Date"></th>
		</tr>
		</thead>
		<tbody>
		<cfif get_wrk_visit_report.recordcount>	
		<cfoutput query="get_wrk_visit_report" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td width="15">#currentrow#</td>
				<td>#BROWSER_INFO#</td>
				<td>#VISIT_SITE#</td>
				<td>#VISIT_MODULE#</td>
				<td>#VISIT_FUSEACTION#</td> 
				<td>#USER_TYPE#</td>
				<td>#FULLNAME#</td>
				<td>#dateformat(VISIT_DATE,dateformat_style)# #timeformat(VISIT_DATE,timeformat_style)#</td>	
			</tr>
			</cfoutput>				
		<cfelse>
			<tr>
				<td colspan="8"><cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
		</tbody>
	</cf_report_list>
</div>
	<cfset url_string = ''>
    <cfif isdefined("attributes.date") and len(attributes.date)>
		<cfset url_string = "#url_string#&date=#dateformat(attributes.date,dateformat_style)#">
	</cfif>
    <cfif isdefined("attributes.date2") and len(attributes.date2)>
		<cfset url_string = "#url_string#&date2=#dateformat(attributes.date2,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.browser_info") and len(attributes.browser_info)>
		<cfset url_string = '#url_string#&browser_info=#attributes.browser_info#'>
	</cfif>
	<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
		<cfset url_string = '#url_string#&form_submitted=1'>
	</cfif>
	<cfif isdefined("attributes.visit_site") and len(attributes.visit_site)>
		<cfset url_string = '#url_string#&visit_site=#attributes.visit_site#'>
	</cfif>
	<cfif isdefined("attributes.visit_module") and len(attributes.visit_module)>
		<cfset url_string = '#url_string#&visit_module=#attributes.visit_module#'>
	</cfif>
	<cfif isdefined("attributes.visit_fuseaction") and len(attributes.visit_fuseaction)>
		<cfset url_string = '#url_string#&visit_fuseaction=#attributes.visit_fuseaction#'>
	</cfif>
	<cfif isdefined("attributes.tip") and len(attributes.tip)>
		<cfset url_string = '#url_string#&tip=#attributes.tip#'>
	</cfif>
    <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfset url_string = '#url_string#&company_id=#attributes.company_id#'>
	</cfif>
    <cfif isdefined("attributes.company") and len(attributes.company)>
		<cfset url_string = '#url_string#&company=#attributes.company#'>
	</cfif>
    <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
		<cfset url_string = '#url_string#&employee_id=#attributes.employee_id#'>
	</cfif>
    <cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>
		<cfset url_string = '#url_string#&partner_id=#attributes.partner_id#'>
	</cfif>
    <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfset url_string = '#url_string#&consumer_id=#attributes.consumer_id#'>
	</cfif>
	<cfif isdefined("attributes.member_type") and len(attributes.member_type)>
		<cfset url_string = '#url_string#&member_type=#attributes.member_type#'>
	</cfif>
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="report.visit_report_user_detail#url_string#">
</cfif>	


