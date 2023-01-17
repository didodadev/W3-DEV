<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="1">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="paymethods" datasource="#dsn#">
		SELECT 
			#dsn#.Get_Dynamic_Language(PAYMETHOD_ID,'#session.ep.language#','SETUP_PAYMETHOD','PAYMETHOD',NULL,NULL,PAYMETHOD) AS PAYMETHOD_,
			*
		FROM 
			SETUP_PAYMETHOD 
		WHERE 
			1 = 1
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND PAYMETHOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
			<cfif attributes.is_active is 1>
				AND PAYMETHOD_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#">
			<cfelseif attributes.is_active is 0>
				AND PAYMETHOD_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#">
			</cfif>
		ORDER BY 
			PAYMETHOD
	</cfquery>
<cfelse>
	<cfset paymethods.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#paymethods.recordcount#">
<div class="col col-12 col-xs-12">
	<cf_box  title="#getLang('settings',47)#" uidrop="1" hide_table_column="1">
		<cfform name="paymethod" action="#request.self#?fuseaction=settings.list_paymethods" method="post">
			<input name="form_submitted" id="form_submitted" type="hidden" value="">
			<cf_box_search more="0"> 
				<div class="form-group large">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
				</div>
				<div class="form-group medium">
					<select name="is_active" id="is_active">
						<option value="1" <cfif attributes.is_active is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
						<option value="0" <cfif attributes.is_active is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
						<option value="2" <cfif attributes.is_active is 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
					</select>
				</div>
				<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>		
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="150"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
					<th width="75"><cf_get_lang dictionary_id='57861.Ortalama Vade'></th>
					<th width="75"><cf_get_lang dictionary_id='31550.Taksit Sayisi'></th>
					<th width="75"><cf_get_lang dictionary_id='34690.Peşinat Oranı'> %</th>
					<th width="75"><cf_get_lang dictionary_id='42492.Vade Farkı Oranı %/Ay'></th>
					<th width="100"><cf_get_lang dictionary_id='42494.Ödeme aracı'></th>
					<!-- sil --><th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_paymethod"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_submitted") and paymethods.recordcount>
					<cfoutput query="paymethods" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
						<td width="20">#currentrow#</td>
						<td width="150"><a href="#request.self#?fuseaction=settings.form_upd_paymethod&paymethod_id=#paymethod_id#">#paymethod_#</a></td>
						<td width="50" class="moneybox">#due_day#</td>
						<td width="50" class="moneybox">#due_month#</td>
						<td width="50" class="moneybox">#in_advance#</td>
						<td width="50" class="moneybox">#due_date_rate#</td>
						<td width="100">
							<cfif paymethods.payment_vehicle eq 1>
								<cf_get_lang dictionary_id='58007.Çek'>
							<cfelseif paymethods.payment_vehicle eq 2>
								<cf_get_lang dictionary_id='58008.Senet'>
							<cfelseif paymethods.payment_vehicle eq 3>
								<cf_get_lang dictionary_id='32736.Havale'>
							<cfelseif paymethods.payment_vehicle eq 6>
								<cf_get_lang dictionary_id='58645.Nakit'>
							<cfelseif paymethods.payment_vehicle eq 7>
								<cf_get_lang dictionary_id="42319.Kapıda Ödeme">
							<cfelseif paymethods.payment_vehicle eq 8>
								DBS
							</cfif>
						</td>
						<!-- sil -->
						<td width="20"><a href="#request.self#?fuseaction=settings.form_upd_paymethod&paymethod_id=#paymethod_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
				<tr>
					<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "settings.list_paymethods">
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.is_active") and len(attributes.is_active)>
			<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#"> 
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
