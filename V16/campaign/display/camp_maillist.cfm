<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_camp_mail" datasource="#dsn#">
	SELECT 
		MAILLIST_EMAIL,
		PAPER_NO,
		MAILLIST_CONTENT,
		MAILLIST_NAME,
		MAILLIST_SURNAME,
		MAILLIST_TELCOD,
		MAILLIST_TEL,
		RECORD_DATE
	FROM 
		MAILLIST
	WHERE 
		CAMPAIGN_ID = #attributes.camp_id#
		<cfif len(attributes.keyword)>
			AND MAILLIST_NAME LIKE '%#attributes.keyword#%' OR
			MAILLIST_SURNAME LIKE '%#attributes.keyword#%' OR
			MAILLIST_EMAIL LIKE '%#attributes.keyword#%'
		</cfif>
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_camp_mail.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Mail Listesi',49578)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form_mail_list" action="#request.self#?fuseaction=campaign.popup_camp_maillist&camp_id=#attributes.camp_id#" method="post">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#" maxlength="255">
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#"></td>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_mail_list' , #attributes.modal_id#)"),DE(""))#"> 
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="30"><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang dictionary_id ='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id="55484.E-Mail"></th>
					<th><cf_get_lang dictionary_id ='57499.Telefon'></th>
					<th><cf_get_lang dictionary_id ='58133.Fatura No'></th>
					<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_camp_mail.recordcount>
					<cfoutput query="get_camp_mail" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#maillist_name# #maillist_surname#</td>
							<td>#maillist_email#</td>
							<td>#maillist_telcod# #maillist_tel#</td>
							<td>#paper_no#</td>
							<td>#MAILLIST_CONTENT#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction#&camp_id=#attributes.camp_id#&keyword=#attributes.keyword#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>

