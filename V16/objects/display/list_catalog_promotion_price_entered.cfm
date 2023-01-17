<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.search_date" default=''>
<cfparam name="attributes.page" default=1>
<cfinclude template="../query/get_catalog_promotion_price_entered.cfm">
<cfparam name="attributes.totalrecords" default=#get_catalog_names.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <tr>
    <td class="headbold"><cf_get_lang dictionary_id='58988.Aksiyonlar'></td>
    <td  style="text-align:right;">
      <table>
        <cfform name="prom_cat" action="" method="post">
          <input type="hidden" value="<cfif isdefined("attributes.field_id")><cfoutput>#attributes.field_id#</cfoutput></cfif>" name="field_id" id="field_id">
          <input type="hidden" value="<cfif isdefined("attributes.field_name")><cfoutput>#attributes.field_name#</cfoutput></cfif>" name="field_name" id="field_name">		  
          <tr>
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput type="Text" name="keyword" value="#attributes.keyword#" style="width:100px;"></td>
			<td>
			     <cfinput type="text" name="search_date" value="#dateformat(attributes.search_date,dateformat_style)#" style="width:80px;" validate="#validate_style#" maxlength="10" message="Başlangıç Tarihi !">
				 <cf_wrk_date_image date_field="search_date">
			</td>
            <td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</td>
			<td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr clasS="color-border">
    <td>
      <table cellpadding="2" cellspacing="1" border="0" width="100%">
        <tr clasS="color-header" height="22">
          <td width="30" class="form-title"><cf_get_lang dictionary_id='58527.ID'></td>
		  <td width="30" class="form-title"><cf_get_lang dictionary_id='33119.Aksiyon'></td>
          <td class="form-title"><cf_get_lang dictionary_id='33120.Başlama / Bitiş'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='33121.Kondüsyon'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='57899.Kaydeden'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='57500.Onay'></td>
        </tr>
        <cfif get_catalog_names.recordcount>
          <cfoutput query="get_catalog_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			  <cfset replaced_head = replace(CATALOG_HEAD,"'","\'",'All')>
              <td>#CATALOG_ID#</td>
			  <td><a href="javascript://" onClick="send_to_opener('#CATALOG_ID#','#replaced_head#');" class="tableyazi">#catalog_head#</a></td>
              <td>#DateFormat(STARTDATE,dateformat_style)# - #DateFormat(FINISHDATE,dateformat_style)#</td>
			  <td>#DateFormat(KONDUSYON_DATE,dateformat_style)# - #DateFormat(KONDUSYON_FINISH_DATE,dateformat_style)#</td>
			  <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
			  <td><cfif Len(VALID)><cf_get_lang dictionary_id='57616.Onaylı'><cfelse><cf_get_lang dictionary_id='57615.Onay Bekliyor'> / <cf_get_lang dictionary_id='32658.Onaysız'></cfif></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row" height="20">
            <td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfset str_url_params = "">
<cfif isdefined("attributes.field_id")>
	<cfset str_url_params = "&#str_url_params#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>		
	<cfset str_url_params = "&#str_url_params#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.search_date")>
	<cfset str_url_params = "&#str_url_params#&search_date=#attributes.search_date#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows >
  <table cellpadding="0" cellspacing="0" border="0" width="98%" align="center" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_catalog_promotion#str_url_params#"></td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif>
<script type="text/javascript">
	function send_to_opener(int_id,str_name)
	{
		<cfif isdefined("attributes.field_id")>
			opener.<cfoutput>#attributes.field_id#</cfoutput>.value=int_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>		
			opener.<cfoutput>#attributes.field_name#</cfoutput>.value=str_name;
		</cfif>
		window.close();
	}
</script>
