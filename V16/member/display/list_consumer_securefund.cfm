<cfquery name="GET_CONSUMER_SECUREFUND" datasource="#DSN#">
SELECT 
	CS.*,
	OC.COMPANY_NAME,
	SS.SECUREFUND_CAT
FROM 
	CONSUMER_SECUREFUND CS,
	OUR_COMPANY OC,
	SETUP_SECUREFUND SS
WHERE 
	CS.CONSUMER_ID = #ATTRIBUTES.CONSUMER_ID# 
	AND
	CS.OUR_COMPANY_ID = OC.COMP_ID
	AND
	SS.SECUREFUND_CAT_ID = CS.SECUREFUND_CAT_ID
	<cfif isdefined("attributes.keyword")>
	AND
	SS.SECUREFUND_CAT LIKE '%#attributes.keyword#%'
	</cfif>
ORDER BY 
	CS.FINISH_DATE DESC
</cfquery>

<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_CONSUMER_SECUREFUND.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr> 
    <td class="headbold"><cf_get_lang dictionary_id='57676.Teminatlar'></td>
	<!-- sil -->
    <td  class="headbold" style="text-align:right;"> 
      <!--- Arama --->
      <table>
    <cfform name="search" method="post" action="">
	<input type="hidden" value="<cfoutput>#attributes.CONSUMER_ID#</cfoutput>" name="CONSUMER_ID" id="CONSUMER_ID">
	  <tr>
  <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
	<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
	<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
	<td><cf_wrk_search_button></td>
	</tr>
	</cfform>
	</table>
      <!--- Arama --->
	</td>
	<!-- sil -->
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
	<td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
				<tr class="color-header" height="22"> 
		          <td class="form-title" width="100"><cf_get_lang dictionary_id='30451.Şirketimiz'></td>
				  <td class="form-title" width="100"><cf_get_lang dictionary_id='57658.Üye'></td>
				  <td class="form-title" width="60"><cf_get_lang dictionary_id='58176.Alış'> - <cf_get_lang dictionary_id='57448.Satış'></td>
				  <td class="form-title"><cf_get_lang dictionary_id='57676.Teminat'></td>
				  <td class="form-title" width="65"><cf_get_lang dictionary_id='57502.Bitiş Tarihi'></td>
				  <td width="100"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
				  <td width="15"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_form_add_consumer_securefund&CONSUMER_ID=#attributes.CONSUMER_ID#','medium','popup_form_add_consumer_securefund')"><img src="/images/plus_square.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0"></a></cfoutput></td>			  
			    </tr>
				<cfif GET_CONSUMER_SECUREFUND.recordcount>
	       			 <cfoutput query="GET_CONSUMER_SECUREFUND" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#COMPANY_NAME#</td>
						<td>#get_cons_info(consumer_id,0,1)#</td>
						<td><cfif GIVE_TAKE eq 0><cf_get_lang dictionary_id='58176.Alış'><cfelse><cf_get_lang dictionary_id='57448.Satış'></cfif></td>
						<td>#SECUREFUND_CAT#</td>
						<td>#DATEFORMAT(FINISH_DATE,dateformat_style)#</td>
						<td  style="text-align:right;">#tlformat(SECUREFUND_TOTAL)# #MONEY_CAT#</td>											
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_form_upd_consumer_securefund&securefund_id=#SECUREFUND_ID#','medium','popup_form_upd_consumer_securefund')"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>" border="0"></a></td>
					  </tr>
				</cfoutput>
				<cfelse>
					<tr class="color-row" height="20">
					<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
      </table>
    </td>
 </tr>
</table> 
<cfif attributes.totalrecords gt attributes.maxrows>
<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
  <tr> 
	<td>
	<cf_pages 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="member.popup_list_securefund#url_str#&company_id#attributes.company_id#"> 
	</td>
	<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>
