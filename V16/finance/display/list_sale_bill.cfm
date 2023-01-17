<cfset attributes.purchase=1>
<cfinclude template="../query/get_bill.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=10>
<cfparam name="attributes.totalrecords" default="#get_bill.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="97%" border="0" cellspacing="0" cellpadding="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-list" height="22">
          <td class="txtboldblue">
		  <a href="javascript://" onclick="gizle_goster_img('list_sale_bill_img1','list_sale_bill_img2','list_sale_bill_menu');"><img src="/images/listele_down.gif" alt="<cf_get_lang no='132.Ayrıntıları Gizle'>" title="<cf_get_lang no='132.Ayrıntıları Gizle'>" width="12" height="7" border="0" align="absmiddle" id="list_sale_bill_img1" style="display:;cursor:pointer;"></a>
		  <a href="javascript://" onclick="gizle_goster_img('list_sale_bill_img1','list_sale_bill_img2','list_sale_bill_menu');"><img src="/images/listele.gif" alt="<cf_get_lang no='89.Ayrıntıları Göster'>" title="<cf_get_lang no='89.Ayrıntıları Göster'>" width="7" height="12" border="0" align="absmiddle" id="list_sale_bill_img2" style="display:none;cursor:pointer;"></a>
		  <cf_get_lang no='15.Son Satış Faturaları'>
		  </td>
        </tr>
        <tr class="color-row" id="list_sale_bill_menu">
          <td>
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
              <cfif get_bill.recordcount>
                <cfset company_id_list=''>
				<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            	<cfif len(company_id) and not listfind(company_id_list,company_id)>
              		<cfset company_id_list=listappend(company_id_list,company_id)>
            	</cfif>
				</cfoutput>
				<cfif len(company_id_list)>
            	<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
            	<cfquery name="get_company_detail" datasource="#dsn#">
					SELECT
						FULLNAME
					FROM
						COMPANY
					WHERE
						COMPANY_ID IN (#company_id_list#)
					ORDER BY
						COMPANY_ID
           		 </cfquery>
          		</cfif>
				<cfoutput query="get_bill" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>#dateformat(INVOICE_DATE,dateformat_style)#</TD>
                    <td width="70">
                      <cfif INVENTORY_ID eq "">
                        <a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#GET_BILL.INVOICE_NUMBER#</a>
                        <cfelse>
                        <a href="#request.self#?fuseaction=invent.form_upd_invent&id=#get_bill.INVENTORY_ID#" class="tableyazi">#GET_BILL.INVOICE_ID#</a>
                      </cfif>
                    </td>
                    <td>
                      <cfif len(company_id)>
                  		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');" class="tableyazi"> #get_company_detail.FULLNAME[listfind(company_id_list,COMPANY_ID,',')]# </a>
                        <cfelseif len(get_bill.PARTNER_ID)>
                        #get_par_info(get_bill.PARTNER_ID,0,0,1)#
                        <cfelseif len(get_bill.CON_ID)>
                        #get_cons_info(get_bill.CON_ID,0,1)#
                      </cfif>
                    </td>
                    <td width="150"  style="text-align:right;">#TLFormat(get_bill.NETTOTAL)# #session.ep.money#</td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr>
                  <td><cf_get_lang_main no='72.Kayit Yok'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br/>

