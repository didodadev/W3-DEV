<cfset x = structdelete(session,'report')>
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_reports.cfm">
<cfelse>
	<cfset get_reports.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_reports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_string = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.module_id" default="">
<cfparam name="attributes.report_status" default="1">
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.module_id)>
	<cfset url_string = "#url_string#&module_id=#attributes.module_id#">
</cfif>
<cfset url_string = "#url_string#&report_status=#attributes.report_status#">
<cfform name="filter" action="#request.self#?fuseaction=myhome.my_reports" method="post">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30764.Raporlarım'></cfsavecontent>
<cf_big_list_search title="#message#"> 
	<cf_big_list_search_area>
	<!-- sil -->
		<table >
			<tr>
            	<input type="hidden" value="1" name="is_form_submitted" id="is_form_submitted" />
				<td><cf_get_lang dictionary_id='57460.Filtre'></td>
				<td><cfinput type="Text" maxlength="50" value="#attributes.keyword#" name="keyword" id="keyword"></td>
				<td>
					<select name="report_STATUS" id="report_STATUS">
						<option value='1'><cf_get_lang dictionary_id='58081.hepsi'></option>
						<option value='0'<cfif attributes.report_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value='-1'<cfif attributes.report_status eq -1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					</select>		
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>
		<!-- sil -->
	<cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='58577.Sira'></th>
			<th><cf_get_lang dictionary_id='57434.Rapor'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th width="150"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
			<th width="65"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>			
		</tr>
	<thead>
	<tbody>
			<cfif get_reports.recordcount>
				<cfoutput query="get_reports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" group="REPORT_ID">
					<tr>
						<td width="35">#currentrow#</td>
						<td><a class="tableyazi" href="#request.self#?fuseaction=myhome.detail_report&report_id=#report_id#">#report_name#</a></td>
						<td>#REPORT_DETAIL#</td>
						<td>#get_emp_info(record_emp,0,1)#</td>
						<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id="57701.Filtre Ediniz">!</cfif></td>
				</tr>
			</cfif>
	</tbody>
</cf_big_list>
<cfif attributes.maxrows lt attributes.totalrecords>
	<table cellpadding="0" cellspacing="0" border="0" width="99%" align="center">
		<tr> 
			<td>
				<cfset adres = "">	
                <cfif isdefined("attributes.is_form_submitted")>
					<cfset adres = "&is_form_submitted=#attributes.is_form_submitted#">
                </cfif>		
				<CF_PAGES page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="myhome.my_reports#adres#"> 
			</td>
			<!-- sil --><td  style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Total Record'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> 
			</td><!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
