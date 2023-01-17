<cfparam name="attributes.status" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_submit")>
  <cfset get_complaint_list = createObject("component","V16.settings.cfc.setupComplaints").getComplaints(is_default:attributes.status,keyword:attributes.keyword)>
<cfelse>
	<cfset get_complaint_list.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_complaint_list.recordcount#">
<cfform name="list_complaint" action="#request.self#?fuseaction=settings.list_complaints" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('settings',118)#"> 
	<cf_big_list_search_area>
		<!-- sil -->
		<table>					
			<tr>
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" id="keyword" style="width:80px;" value="#attributes.keyword#" maxlength="50"></td>
				<td><select name="status" id="status">
						<option value=""><cf_get_lang_main no='296.Tümü'></option>
						<option value="1" <cfif attributes.status is 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
						<option value="0" <cfif attributes.status is 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
					</select>
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>
		<!-- sil -->
</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no='1165. Sıra'></th>
			<th><cf_get_lang no='118.Tanı'></th>
			<!-- sil --><th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_complaints"><img src="/images/plus_list.gif" title="<cf_get_lang no='118.Tanı'> <cf_get_lang_main no='170.İlaç İsimleri'>"></a></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
			<cfif get_complaint_list.recordcount>
				<cfoutput query="get_complaint_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="35">#currentrow#</td>
					<td><a href="#request.self#?fuseaction=settings.form_upd_complaints&complaint_id=#complaint_id#" class="tableyazi">#complaint#</a></td>
					<!-- sil -->
					<td width="15"><a href="#request.self#?fuseaction=settings.form_upd_complaints&complaint_id=#complaint_id#" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
					<!-- sil -->
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
				<td colspan="4"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
				</tr>
			</cfif>
	</tbody>
</cf_big_list>
<cfif get_complaint_list.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr> 
			<td><cfset url_str = "">
				<cfif len(attributes.keyword)>
					<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
				</cfif>
				<cfif len(attributes.status)>
					<cfset url_str = "#url_str#&status=#attributes.status#">
				</cfif>
				<cfif len(attributes.is_submit)>
					<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
				</cfif>              	              
				<cf_pages page="#attributes.page#"
				  maxrows="#attributes.maxrows#"
				  totalrecords="#attributes.totalrecords#"
				  startrow="#attributes.startrow#"
				  adres="settings.list_complaints#URL_STR#"> </td>
				<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
			</td><!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

