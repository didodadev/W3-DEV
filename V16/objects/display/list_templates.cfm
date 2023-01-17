<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif isdefined("attributes.module")>
	<cfset url_str = "#url_str#&module=#attributes.module#">
</cfif>
<cfif isdefined("attributes.assetcat_id")>
	<cfset url_str = "#url_str#&assetcat_id=#attributes.assetcat_id#">
</cfif>
<cfif isdefined("attributes.submitted")>
	<cfinclude template="../query/get_templates.cfm">
<cfelse>
	<cfset get_templates.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_templates.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform action="#request.self#?fuseaction=objects.popup_list_templates#url_str#" method="post" name="search">
<input type="hidden" name="submitted" id="submitted" value="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33093.Şablonlar'></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cf_medium_list_search_area>
		<table style="text-align:right;">
			<tr>
				<td><cf_get_lang dictionary_id='57460.Filtre'></td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>
	</cf_medium_list_search_area>
</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr>
			<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57480.Başlık'></th>
		</tr>
	</thead>
	<tbody>
		<cfset index = 0> 
		<cfif get_templates.recordcount>
			<cfoutput query="get_templates" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset index = index + 1>
				<tr>
					<td width="25">#index#</td>
					<td>
						<a href="##" class="tableyazi"  onClick="windowopen('#request.self#?fuseaction=objects.popup_arrange_template&template_id=#template_id##page_code#','page')">#template_head#</a>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td height="20" colspan="9"><cfif isdefined("attributes.submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="99%" align="center">
    <tr>
      <td>
		  <cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="objects.popup_list_templates#url_str#&keyword=#attributes.keyword#"> </td>
      <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#get_templates.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
    </tr>
  </table>
</cfif><br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
