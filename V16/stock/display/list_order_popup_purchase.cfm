<cfset depo_id = listgetat(session.ep.user_location,1,'-') >
<cfparam name="attributes.department_id" default="#depo_id#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.keyword" default="" >
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfif isdefined("attributes.is_form_submitted")>
<cfinclude template="../query/get_order_list_purchase.cfm">
	<cfset arama_yapilmali = 0 >
<cfelse>
	<cfset get_order_list.recordcount = 0 >
	<cfset arama_yapilmali = 1 >
</cfif>
<cfinclude template="../query/get_department.cfm">
<cfinclude template="../query/get_commethod.cfm">
<cfparam name="attributes.totalrecords" default="#get_order_list.recordcount#"> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>  
<cfset sayac = 0 >
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr>
    <td class="headbold" height="35"><cf_get_lang no='51.Siparişler'></td>
		<td height="30" class="headbold" width="250">
      <!--- Arama --->
      <table width="250">
        <cfform action="#request.self#?fuseaction=stock.list_order_popup_purchase" method="post">
          <tr> 
            <td align="right" style="text-align:right;"><cf_get_lang_main no='48.Filtre'>:</td>
            <td width="100" align="right" style="text-align:right;">
              <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#">
            </td>
			<td>
             <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
				<select name="department_id" id="department_id">
					<option value="">Depo Seçiniz</option>
					<cfoutput query="get_department">
						<option value="#DEPARTMENT_ID#" <cfif attributes.department_id eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
					</cfoutput>
				</select>
			</td>
            <td width="25">
			<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
            </td>
            <td width="10"><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>	  
      <!--- Arama --->
    </td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
<td>
 <table width="100%" cellpadding="2" cellspacing="1">
   <tr class="color-header" height="22"> 
    <td class="form-title"><cf_get_lang_main no='75.no'></td>
    <td class="form-title"><cf_get_lang_main no='107.cari Hesap'></td>
    <td class="form-title"><cf_get_lang_main no='157.calısan'></td>
    <td class="form-title"><cf_get_lang_main no='233.tes tarhi'></td>
    <td class="form-title"><cf_get_lang_main no='73.öncelik'></td>
    <td class="form-title"><cf_get_lang_main no='1351.Depo'></td>
  </tr>
  <cfif not isDefined("url.id")>
  	<cfset id = "">
  </cfif>
 <cfif get_order_list.recordcount>
  <cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
   <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
      <td>
		<cfif len(DELIVER_DEPT)>
			<a href="#request.self#?fuseaction=stock.add_order_sale_popup_purchase&order_id=#order_id#&id=#id#&deliver_dept=#DELIVER_DEPT#&deliverdate=#DELIVERDATE#" class="tableyazi" >#order_number#</a>
		<cfelse>
			<a href="#request.self#?fuseaction=stock.add_order_sale_popup_purchase&order_id=#order_id#&id=#id#" class="tableyazi" >#order_number#</a>
		</cfif>
	  </td>
	  <!--- şirketi al --->
	  <cfif len(get_order_list.partner_id)>
        <td>#get_par_info(get_order_list.partner_id,0,0,0)#</td>
	  <cfelseif len(get_order_list.company_id)>
        <td>#get_par_info(company_id,1,0,0)#</a></td>
	  <cfelseif len(get_order_list.consumer_id)>
        <td>#get_cons_info(consumer_id,1,0)#</a></td>
	  </cfif>
      <td>#employee_name# #employee_surname#</td>
      <td>#dateformat(DELIVERDATE,dateformat_style)#</td>
	  <td><font color="#get_commethod.color#">#get_commethod.priority#</font></td>
		<td>
		  <cfif len(DELIVER_DEPT) and isnumeric(DELIVER_DEPT_ID)>
			  <cfinclude template="../query/get_dep_name.cfm">
			  #get_dep.DEPARTMENT_HEAD#
		  </cfif>
		</td>
	</tr>
  </cfoutput> 
  <cfelse>
  <tr>
  	<td colspan="10" class="color-row"><cfif arama_yapilmali eq 1>Filtre Ediniz<cfelse><cf_get_lang_main no='72.kayıt yok'></cfif> !</td>
  </tr>
  </cfif>
</table>
</td>
</tr>
</table>

<cfif attributes.totalrecords gt attributes.maxrows>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
  <tr> 
    <td>
		<cf_pages page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="stock.list_order_popup_purchase&keyword=#attributes.keyword#&department_id=#attributes.department_id#&is_form_submitted=1">
    </td>
    <td align="right" style="text-align:right;"><cf_get_lang_main no='80.toplam'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang_main no='169.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
  </tr>
</table>
</cfif>
