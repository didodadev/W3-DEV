<cfquery name="GET_OUR_COMPANIES" datasource="#dsn#">
	SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_paymethod.cfm">
<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT * FROM COMPANY_CREDIT WHERE COMPANY_CREDIT_ID = #ATTRIBUTES.COMPANY_CREDIT_ID#
</cfquery>

      <table cellspacing="1" cellpadding="2" border="0" width="98%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id='30459.risk tanımı'></td>
        </tr>
        <tr class="color-row" valign="top">
          <td>	  
				  <table>
                  </table>
          </td>
        </tr>
      </table>



<script type="text/javascript">
function control()
{
	if(add_credit.OPEN_ACCOUNT_RISK_LIMIT.value == "")
	{
		add_credit.OPEN_ACCOUNT_RISK_LIMIT.value = 0;
	}
	if(add_credit.FORWARD_SALE_LIMIT.value == "")
	{
		add_credit.FORWARD_SALE_LIMIT.value = 0;
	}
}
function unformat_fields()
{
	if(add_credit.paymethod_id.selectedIndex == 0)
	{
		alert("<cf_get_lang dictionary_id='58027.Lütfen Ödeme Yöntemi Seçiniz'>!");
		return false;
	}
	else
	{
		add_credit.OPEN_ACCOUNT_RISK_LIMIT.value = filterNum(add_credit.OPEN_ACCOUNT_RISK_LIMIT.value);
		add_credit.FORWARD_SALE_LIMIT.value = filterNum(add_credit.FORWARD_SALE_LIMIT.value);
		add_credit.PAYMENT_BLOKAJ.value = filterNum(add_credit.PAYMENT_BLOKAJ.value);
		return true;
	}	
}	
</script>
