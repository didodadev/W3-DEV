<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfquery name="GET_MAILLIST" datasource="#DSN#">
	SELECT 
		MAILLIST_NAME,
		MAILLIST_SURNAME,
		MAILLIST_EMAIL,
		MAILLIST_TELCOD,
		MAILLIST_TEL,
		MAILLIST_CONTENT
	FROM
		MAILLIST
	<cfif len(attributes.keyword)>
	WHERE
		MAILLIST_NAME + ' ' + MAILLIST_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		MAILLIST_EMAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		MAILLIST_CONTENT LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		MAILLIST_TELCOD + ' ' + MAILLIST_TEL LIKE '%#attributes.keyword#%'
	</cfif>
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="20">
<cfparam name="attributes.totalrecords" default=#get_maillist.recordcount#>
<cfset attributes.startrow =((attributes.page-1)*attributes.maxrows+1)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="mail_form" action="#request.self#?fuseaction=campaign.list_maillist" method="post">
			<cf_box_search>
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<div class ="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class ="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(258,'Mail Listesi',49578)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='57428.E-mail'></th>
					<th><cf_get_lang dictionary_id='57499.Telefon'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_maillist.recordcount and form_varmi eq 1>
					<cfoutput query="get_maillist" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td> 
							<td>#maillist_name# #maillist_surname#</td>
							<td>#maillist_email#</td>
							<td>#maillist_telcod# <cf_duxi type="label" name="maillist_tel" id="maillist_tel" value="#maillist_tel#" hint="Phone" gdpr="2"></td>
							<td>#maillist_content#</td>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="6"><cfif form_varmi eq 0><cf_get_lang dictionary_id="57701.Filtre Ediniz">!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfset url_str = "">
		<cfif isdefined ("attributes.is_form_submitted") and len (attributes.is_form_submitted)>
			<cfset url_str = "#url_str#&is_form_submitted=1">
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif form_varmi eq 1>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#attributes.fuseaction##url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
	{
		if(!$("#maxrows").val().length){ 
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfoutput>"})
			return false;
		}
	}
</script>
