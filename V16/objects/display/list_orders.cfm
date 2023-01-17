<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_submitted")>
	<cfinclude template="../query/get_order_list_purchase.cfm">
<cfelse>
	<cfset get_order_list.recordcount=0> 
</cfif>
<cfinclude template="../query/get_commethod.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_order_list.recordcount#">  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>  
<cfset sayac = 0 >
<cfset url_str="">
<cfif isdefined("attributes.is_submitted")>
	<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.comp_id")>
	<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
</cfif>
<cfif isdefined("attributes.field_value")>
	<cfset url_str = "#url_str#&field_value=#field_value#">
</cfif>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr>
    <td class="headbold" height="35"><cf_get_lang dictionary_id='57528.Emirler'></td>
	  <td height="30" class="headbold" width="250">
      	<table width="250">
        <cfform action="#request.self#?fuseaction=objects.list_order_popup_purchase#url_str#" method="post">
        <input name="is_submitted" id="is_submitted" type="hidden"  value="1">
		  <tr> 
            <td  style="text-align:right;"><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td width="100"  style="text-align:right;">
            	<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255">
            </td>
            <td width="25">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td width="10"><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>	  
    </td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
	<td>
 	  <table width="100%" cellpadding="2" cellspacing="1">
   		<tr class="color-header" height="22"> 
    	  <td class="form-title" align="center"><cf_get_lang dictionary_id='57487.No'></td>
    	  <td class="form-title"><cf_get_lang dictionary_id='57673.Tutar'></td>
    	  <td class="form-title"><cf_get_lang dictionary_id='57611.Sipariş'></td>
    	  <td class="form-title"><cf_get_lang dictionary_id='57574.Şirket'>-<cf_get_lang dictionary_id='57578.Yetkili'></td>
    	  <td class="form-title"><cf_get_lang dictionary_id='57576.Çalışan'></td>
    	  <td class="form-title"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
    	  <td class="form-title"><cf_get_lang dictionary_id='57485.Öncelik'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57680.Genel Toplam'></td> 
  		</tr>
  		<cfif not isDefined("url.id")>
  			<cfset id = "">
  		</cfif>
 		<cfif get_order_list.recordcount>
		<cfset partner_id_list=''>
		<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
			  <cfset partner_id_list = Listappend(partner_id_list,partner_id)>
			</cfif>
		</cfoutput>
		<cfif len(partner_id_list)>
			<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>			
			<cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
				SELECT
					CP.COMPANY_PARTNER_NAME,	
					CP.COMPANY_PARTNER_SURNAME,
					CP.PARTNER_ID,
					CP.COMPANY_ID,
					C.NICKNAME
				FROM
					COMPANY_PARTNER CP,
					COMPANY C
				WHERE
					CP.COMPANY_ID = C.COMPANY_ID AND	    
					CP.PARTNER_ID IN (#partner_id_list#)
				ORDER BY
					CP.PARTNER_ID				
			</cfquery>						
		 </cfif>
  		<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
   		<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
      		<td><a href="javascript://" onClick="ekle(#order_id#,'#order_number#','#TLFormat(nettotal)#');" class="tableyazi" >#order_number#</a></td>
	  		<td  style="text-align:right;">#TLFormat(nettotal)#</td>
      		<td>#order_head#</td>
			<td> <cfif len(partner_id)>#get_partner_detail.nickname[listfind(partner_id_list,get_order_list.partner_id,',')]# -  #get_partner_detail.company_partner_name[listfind(partner_id_list,get_order_list.partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,get_order_list.partner_id,',')]#</cfif></td>
			<td>#employee_name# #employee_surname#</td>
			<td>#dateformat(ORDER_DATE,dateformat_style)# - #dateformat(DELIVERDATE,dateformat_style)#</td>
			<td><font color="#get_commethod.color#">#get_commethod.priority#</font></td>
			<td  style="text-align:right;">#TLFormat(get_order_list.nettotal)# #session.ep.money#</td>
	  	</tr>
  		</cfoutput> 
  <cfelse>
  	<tr>
  		<td colspan="10" class="color-row"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.kayıt yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
  	</tr>
  </cfif>
   </table>
  </td>	
 </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
  <tr> 
    <td>
	<cf_pages page="#attributes.page#"
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="objects.list_order_popup_purchase#url_str#"></td>
    <td  style="text-align:right;"><cf_get_lang dictionary_id='57492.toplam'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang dictionary_id='57581.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
  </tr>
</table>
</cfif>
<script type="text/javascript">
function ekle(order_no,order_head,value)
{
	opener.<cfoutput>#attributes.field_id#</cfoutput>.value=order_no;
	opener.<cfoutput>#attributes.field_name#</cfoutput>.value=order_head;
	<cfif isdefined("attributes.field_value")>
		opener.<cfoutput>#field_value#</cfoutput>.value = value;
	</cfif>
	window.close();
}
</script>
