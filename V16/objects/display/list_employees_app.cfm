<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="">
<cfset url_str = "">
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif len("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfquery name="get_cv" datasource="#dsn#">
	SELECT
		AP.EMPAPP_ID,
		AP.NAME,
		AP.SURNAME,
		AP.RECORD_DATE
	FROM
		EMPLOYEES_APP AP
	WHERE
		1=1
		<cfif len(attributes.keyword)>
			 AND (AP.NAME+' '+AP.SURNAME LIKE '%#attributes.keyword#%')
		</cfif>
		<cfif len(attributes.status)>
			 AND AP.APP_STATUS=#attributes.status#
		</cfif>
	ORDER BY 
		NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_cv.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29767.CV'></cfsavecontent>
<cf_medium_list_search title="#message#">
	<cfform name="search_form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_employees_app" method="post">
	<cf_medium_list_search_area>
		<table>
			<cfif isdefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>"></cfif>
			<cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"></cfif>
			<tr>
                <td><cf_get_lang dictionary_id='57631.Ad'> <cf_get_lang dictionary_id='58726.Soyad'></td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>	
				<td>
                    <select name="status" id="status">
					  <option value="" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>	
					  <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                      <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>			                        
                    </select>
                  </td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>          
			</tr>
		</table>
	</cf_medium_list_search_area>
	</cfform>
</cf_medium_list_search>
<cf_medium_list>
	<thead>	
	<tr>
		<th width="25"><cf_get_lang dictionary_id ='57487.No'></th>
		<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
		<th class="form-title"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
	</tr>
	</thead>
	<tbody>
	<cfif get_cv.recordcount>
		<cfoutput query="get_cv" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#currentrow#</td>
				<td><a href="javascript://" class="tableyazi"  onClick="add_app('#empapp_id#','#name# #surname#')">#name# #surname#</a></td>
				<td>#dateformat(record_date,dateformat_style)#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr height="20" class="color-row">
			<td colspan="4"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
		</tr>
	</cfif>
	</tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
		<tr> 
			<td>
				<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#listgetat(attributes.fuseaction,1,'.')#.popup_list_employees_app#url_str#"> 
			</td>
			<!-- sil --><td  style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayit'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	function add_app(empapp_id,name)
	{
		<cfif isdefined("attributes.field_id")>
		opener.<cfoutput>#field_id#</cfoutput>.value = empapp_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		window.close();
	}
</script>
