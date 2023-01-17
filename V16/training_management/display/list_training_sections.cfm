<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_cat_id")>
  <cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
<cfelse>
  <cfset attributes.training_cat_id = 0>
</cfif>
<cfinclude template="../query/get_training_cats.cfm">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_training_secs.cfm">
<cfelse>
	<cfset get_training_secs.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_training_secs.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.training_cat_id") and attributes.training_cat_id>
	<cfquery name="GET_CAT" datasource="#dsn#">
		SELECT TRAINING_CAT, TRAINING_CAT_ID FROM TRAINING_CAT WHERE TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
	</cfquery>
	<cfset head_ = get_cat.training_cat>
<cfelse>
	<cfset head_ = "">
</cfif>
<cf_box>
	<cfform name="form1" method="post" action="#request.self#?fuseaction=training_management.definitions">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<cf_box_search>
			<div class="form-group">
				<cfinput placeHolder="#getlang(48,'Filtre',57460)#" type="text" id="keyword" name="keyword" maxlength="50" value="#attributes.keyword#">
			</div>
			<div class="form-group">
				<select name="training_cat_id" id="training_cat_id">
					<option value="0" selected><cf_get_lang dictionary_id='58137.Kategoriler'> </option>
					<cfoutput query="get_training_cats">
					<option value="#training_cat_id#" <cfif attributes.training_cat_id eq training_cat_id>selected</cfif>>#training_cat#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" onKeyup="isNumber (this)">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4">
			</div>
		</cf_box_search>
	</cfform>
</cf_box>
<cf_box title="#getLang(727,'Bölümler',58139)#" uidrop="1" hide_table_column="1">
	<cf_flat_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='58577.Sira'></th>
				<th><cf_get_lang dictionary_id='57995.Bölüm'></th>
				<th><cf_get_lang dictionary_id='57486.Kategori'></th>
				<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				<th class="header_icn_none"><cf_get_lang dictionary_id='57480.Konu'></th>
				<th class="header_icn_none"><cf_get_lang dictionary_id='29912.Eğitimler'></th>
				<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.definitions&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_training_secs.recordcount gt 0>
				<cfoutput query="get_training_secs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td width="35">#currentrow#</td>
						<td><a href="#request.self#?fuseaction=training_management.definitions&event=upd&training_sec_id=#training_sec_id#" class="tableyazi">#section_name#</a></td>
						<td>
							<cfquery name="GET_CAT" datasource="#dsn#">
								SELECT 
									TRAINING_CAT
								FROM 
									TRAINING_CAT 
								WHERE 
									TRAINING_CAT_ID=#TRAINING_CAT_ID#
							</cfquery>
								#GET_CAT.TRAINING_CAT#
						</td>
						<td>#dateformat(record_date,dateformat_style)#</td>
						<!-- sil -->
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_list_training_subjects_popup&training_sec_id=#training_sec_id#','list');"><i class="icn-md icon-file-text-o" title="<cf_get_lang dictionary_id='46584.Bağlı Konular'>"></i></a></td>
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_list_class&training_sec_id=#training_sec_id#','list');"><i class="icn-md icon-pencil-square-o" title="<cf_get_lang dictionary_id='46413.Bağlı Eğitimler'>"></i></a></td>
						<td style="text-align:center" width="15"><a href="#request.self#?fuseaction=training_management.definitions&event=upd&training_sec_id=#training_sec_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
		<cfif len(attributes.form_submitted)>
			<cfset url_str="#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#attributes.fuseaction##url_str#">
	</cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>