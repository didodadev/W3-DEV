<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.emp_name" default="">
<cfif isdefined('attributes.emp_id') and len(attributes.emp_id)>
	<cfquery name="GET_PAPER" datasource="#dsn3#" maxrows="1">
		SELECT 
    	    PAPER_ID, 
            REVENUE_RECEIPT_NO, 
            REVENUE_RECEIPT_NUMBER, 
            INVOICE_NO, 
            INVOICE_NUMBER, 
            SHIP_NO, 
            SHIP_NUMBER, 
            EMPLOYEE_ID, 
            OFFER_NO, 
            OFFER_NUMBER, 
            ORDER_NO, 
            ORDER_NUMBER,
            PAPER_TYPE
        FROM 
	        PAPERS_NO 
        WHERE 
            EMPLOYEE_ID = #attributes.emp_id# 
        ORDER BY 
	        PAPER_ID DESC
	</cfquery>
<cfelse>
	<cfset GET_PAPER.recordcount = 0>
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='518.Çalışan Sayfa Numaraları'></td>
    <td align="right" style="text-align:right;"> 
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_paperno"><img src="../images/plus1.gif" border="0" alt="Ekle" align="absmiddle"></a></td>
  </tr>
</table>
 <table cellpadding="2" cellspacing="1" border="0" width="98%" align="center" class="color-border">   
		 <cfform name="form_paper" action="#request.self#?fuseaction=settings.form_add_paperno" method="post"> 
		<tr class="color-row">
          <td>
            <table>
              <tr>
                <td width="100"><cf_get_lang_main no='164.Çalışan'></td>
                <td>
					<cfsavecontent variable="message"><cf_get_lang no='1298.Çalışan Seçmelisiniz'> !</cfsavecontent>
					<cfinput type="hidden" name="emp_id" value="#attributes.emp_id#" required="yes" message="#message#" readonly="readonly">
					<cfinput type="text" name="emp_name" value="#attributes.emp_name#">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&field_id=form_paper.emp_id&field_name=form_paper.emp_name</cfoutput>','list');">
					<img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='322.seçiniz'>" border="0" align="absmiddle"></a>
				</td>
				<td><cf_wrk_search_button></td>
              </tr>
            </table>
          </td>
        </tr>
	  </cfform>
	 <cfif isdefined('attributes.emp_id') and len(attributes.emp_id)>
	  <cfform name="add_paper" action="#request.self#?fuseaction=settings.add_paper" method="post">
		  <tr>
			<td class="color-row">
			  <table>
			  <cfoutput>
				<tr>
					<input type="hidden" name="form_emp_id" id="form_emp_id" value="#attributes.emp_id#">
				  <td width="100"><cf_get_lang no='519.Tahsilat Makbuzu No'></td>
				  <td><input type="Text" name="revenue_receipt_no" id="revenue_receipt_no" value="<cfif get_paper.recordcount>#GET_PAPER.REVENUE_RECEIPT_NO#</cfif>" style="width:97px;">
					<input type="Text" name="revenue_receipt_number" id="revenue_receipt_number" value="<cfif get_paper.recordcount>#GET_PAPER.REVENUE_RECEIPT_NUMBER#</cfif>" size="4" style="width:50px;"></td>
				</tr>
				<tr>
				  <td><cf_get_lang_main no='721.Fatura No'></td>
				  <td><input type="Text" name="invoice_no" id="invoice_no" value="<cfif get_paper.recordcount>#GET_PAPER.INVOICE_NO#</cfif>" style="width:97px;">
					<input type="Text" name="invoice_number" id="invoice_number" value="<cfif get_paper.recordcount>#GET_PAPER.INVOICE_NUMBER#</cfif>" size="4" style="width:50px;"></td>
				</tr>
				<tr>
				  <td><cf_get_lang_main no='726.İrsaliye No'></td>
				  <td><input type="Text" name="ship_no" id="ship_no" value="<cfif get_paper.recordcount>#GET_PAPER.SHIP_NO#</cfif>" style="width:97px;">
					<input type="Text" name="ship_nUMBER" id="ship_nUMBER" value="<cfif get_paper.recordcount>#GET_PAPER.SHIP_NUMBER#</cfif>" size="4" style="width:50px;"></td>
				</tr>
				<tr>
				  <td align="right" colspan="2" height="35"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
				</tr>
				</cfoutput>
			  </table>
			</td>
		  </tr>
		</cfform>
      </table>
	</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(add_paper.form_emp_id.value=="")
		{
			alert("<cf_get_lang no='1298.Çalışan Seçmelisiniz'> !");
			return false;
		}
	}		
</script>
