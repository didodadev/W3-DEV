<cfquery name="GET_MONEY_RATE" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY_STATUS=1
</cfquery>

<cfquery name="GET_OUR_COMPANIES" datasource="#dsn#">
	SELECT 
	    COMP_ID,
		COMPANY_NAME 
	FROM 
	    OUR_COMPANY
	ORDER BY 
		COMPANY_NAME
</cfquery>

<cfquery name="GET_CONSUMER_SECUREFUND" datasource="#DSN#">
SELECT 
	*
FROM 
	CONSUMER_SECUREFUND
WHERE 
	SECUREFUND_ID = #ATTRIBUTES.SECUREFUND_ID#
</cfquery>

<cfquery name="SETUP_SECUREFUND" datasource="#dsn#">
	SELECT 
	    *
	FROM 
	    SETUP_SECUREFUND
</cfquery>

<cfform name="add_secure" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=member.emptypopup_upd_consumer_securefund">
  <input type="hidden" name="securefund_id" id="securefund_id" value="<cfoutput>#ATTRIBUTES.SECUREFUND_ID#</cfoutput>">
  <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#GET_CONSUMER_SECUREFUND.consumer_id#</cfoutput>">
  <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" height="100%">
    <tr class="color-border">
      <td>
        <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
          <tr class="color-list">
            <td class="headbold" colspan="2" height="35">&nbsp;<cf_get_lang dictionary_id='30449.Teminat Güncelle'></td>
          </tr>
          <tr class="color-row">
            <td valign="top">
				
<table>
  <tr>
    <td width="100"><cf_get_lang dictionary_id='57493.Aktif'></td>
    <td width="200"><input type="checkbox" name="SECUREFUND_STATUS" id="SECUREFUND_STATUS" value="1"<cfif GET_CONSUMER_SECUREFUND.SECUREFUND_STATUS eq 1>checked</cfif>></td>
    <td width="80"><cf_get_lang dictionary_id='58930.masraf'></td>
    <td>
	<select name="money_cat_expense" id="money_cat_expense" style="width:50px;">
        <option value=""><cf_get_lang dictionary_id='57636.birim'></option>
        <cfoutput query="GET_MONEY_RATE">
            <option value="#money#"<cfif money is '#GET_CONSUMER_SECUREFUND.money_cat_expense#'> selected</cfif>>#money#</option>
        </cfoutput>
	</select>
	<cfif len(GET_CONSUMER_SECUREFUND.EXPENSE_TOTAL) and (GET_CONSUMER_SECUREFUND.EXPENSE_TOTAL neq 0)>
	<cfset a = TLFORMAT(GET_CONSUMER_SECUREFUND.EXPENSE_TOTAL)>
	<cfelse>
	<cfset a = "">
	</cfif>
	
	<cfinput type="text" name="expense_total" validate="float" range="0.01,"  style="width:95px;" value="#a#" passThrough="onkeyup=""return(FormatCurrency(this,event));""">
	</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id='30450.Teminat Veren Üye'></td>
    <td><input type="text" name="consumer" id="consumer" value="<cfoutput>#get_cons_info(GET_CONSUMER_SECUREFUND.consumer_id,0,0)#</cfoutput>" readonly style="width:150px;"></td>
    <td><cf_get_lang dictionary_id='57521.Banka'></td>
    <td><cfinput name="bank" type="text" style="width:150px;" value="#GET_CONSUMER_SECUREFUND.BANK#" maxlength="50"></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id='30451.Şirketimiz'></td>
    <td>
        <select name="our_company_id" id="our_company_id" style="width:150px;">
            <cfoutput query="get_our_companies">
            <option value="#COMP_ID#"<cfif comp_id eq GET_CONSUMER_SECUREFUND.OUR_COMPANY_ID> selected</cfif>>#company_name#</option>
            </cfoutput>
        </select>
	</td>
    <td><cf_get_lang dictionary_id='58933.Banka Şubesi'></td>
    <td><cfinput name="bank_branch" type="text" style="width:150px;" value="#GET_CONSUMER_SECUREFUND.BANK_BRANCH#" maxlength="50"></td>	
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id='30452.Teminat Kategorisi'>*</td>
    <td>
		<select name="SECUREFUND_CAT_ID" id="SECUREFUND_CAT_ID" style="width:150px;">
			<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option> 
			<CFOUTPUT query="SETUP_SECUREFUND">
				<option value="#SECUREFUND_CAT_ID#" <cfif SECUREFUND_CAT_ID eq GET_CONSUMER_SECUREFUND.SECUREFUND_CAT_ID>selected</cfif>>#SECUREFUND_CAT#</option>
			</CFOUTPUT>
		</select>
	</td>
    <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
    <td rowspan="4" valign="top"><textarea name="REALESTATE_DETAIL" id="REALESTATE_DETAIL" style="width:150px;height:100px;"><cfoutput>#GET_CONSUMER_SECUREFUND.REALESTATE_DETAIL#</cfoutput></textarea>
    </td>	
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id='58488.Alınan'>/<cf_get_lang dictionary_id='58490.Verilen'></td>
    <td>
        <select name="GIVE_TAKE" id="GIVE_TAKE" style="width:150px;">
            <option value="0"<cfif GET_CONSUMER_SECUREFUND.GIVE_TAKE EQ 0> selected</cfif>><cf_get_lang dictionary_id='58488.Alınan'></option>
            <option value="1"<cfif GET_CONSUMER_SECUREFUND.GIVE_TAKE EQ 1> selected</cfif>><cf_get_lang dictionary_id='58490.Verilen'></option>
        </select>
	</td>
    <td></td>
    </tr>
  <tr>
    <td><cf_get_lang dictionary_id='57673.Tutar'> - <cf_get_lang dictionary_id='57489.Para Birimi'>*</td>
    <td>
	<select name="money_type" id="money_type" style="width:50px;">
	<cfoutput query="GET_MONEY_RATE">
		<option value="#money#"<cfif money is '#GET_CONSUMER_SECUREFUND.money_cat#'> selected</cfif>>#money#</option>
	</cfoutput>
	</select>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57673.tutar '></cfsavecontent>
	<cfinput type="text" name="SECUREFUND_TOTAL" validate="float" range="0.01," required="yes" message="#message#" style="width:95px;" value="#TLFORMAT(GET_CONSUMER_SECUREFUND.SECUREFUND_TOTAL)#" passThrough="onkeyup=""return(FormatCurrency(this,event));""">
	</td>
    <td valign="top"></td>
    </tr>
  <tr>
    <td><cf_get_lang dictionary_id='57655.Başlama Tarihi'>*</td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlama Tarihi!'></cfsavecontent>
	<cfinput value="#dateformat(GET_CONSUMER_SECUREFUND.START_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="START_DATE" style="width:130px;"> 
	<cf_wrk_date_image date_field="START_DATE"></td>
    <td valign="top">&nbsp;</td>
    </tr>
  <tr>
    <td><cf_get_lang dictionary_id='57502.Bitiş Tarihi'>*</td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi!'></cfsavecontent>
	<cfinput value="#dateformat(GET_CONSUMER_SECUREFUND.FINISH_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="FINISH_DATE" style="width:130px;"> 
	<cf_wrk_date_image date_field="FINISH_DATE">
	</td>
    <td valign="top"><cf_get_lang dictionary_id='57468.Belge'></td>
    <td><cfoutput>
		<input  type="hidden" name="OLDSECUREFUND_FILE" id="OLDSECUREFUND_FILE" value="#GET_CONSUMER_SECUREFUND.SECUREFUND_FILE#">
		<input  type="hidden" name="OLDSECUREFUND_FILE_SERVER_ID" id="OLDSECUREFUND_FILE_SERVER_ID" value="#GET_CONSUMER_SECUREFUND.SECUREFUND_FILE_SERVER_ID#">
		<cfif Len(GET_CONSUMER_SECUREFUND.SECUREFUND_FILE)>
			<a href="javascript://" onclick="windowopen('#file_web_path#member/#GET_CONSUMER_SECUREFUND.SECUREFUND_FILE#','list')">#GET_CONSUMER_SECUREFUND.SECUREFUND_FILE#</a>
		<cfelse>
			<cf_get_lang dictionary_id='58546.yok'>
		</cfif>
	</cfoutput></td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id='57425.Uyarı Tarihi'>*</td>
    <td>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57425.uyarı'></cfsavecontent>
	<cfinput value="#dateformat(GET_CONSUMER_SECUREFUND.WARNING_DATE,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" type="text" name="WARNING_DATE" style="width:130px;"> 
	<cf_wrk_date_image date_field="WARNING_DATE">
	</td>
    <td valign="top"><cf_get_lang dictionary_id='30456.Yeni Belge'></td>
    <td valign="top"><input  type="file" name="SECUREFUND_FILE" id="SECUREFUND_FILE" style="width:150px;"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td> </td>
    <td colspan="2"  style="text-align:right;"><cf_workcube_buttons is_upd='1' delete_page_url = '#request.self#?fuseaction=member.emptypopup_del_consumer_securefund&oldsecurefund_file=#GET_CONSUMER_SECUREFUND.SECUREFUND_FILE#&oldsecurefund_file_server_id=#GET_CONSUMER_SECUREFUND.SECUREFUND_FILE_SERVER_ID#&securefund_id=#ATTRIBUTES.SECUREFUND_ID#' add_function="kontrol()"></td>
  </tr>
</table>
			</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>


<script type="text/javascript">
		function kontrol()
	{
		x = document.add_secure.SECUREFUND_CAT_ID.selectedIndex;
		if (document.add_secure.SECUREFUND_CAT_ID[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='30452.Teminat Kategorisi'>!");
			return false;
		}
		return unformat_fields();
	}
	
	function unformat_fields()
		{
			fld=document.add_secure.SECUREFUND_TOTAL;
			fld2=document.add_secure.expense_total;			
			fld.value=filterNum(fld.value);
			fld2.value=filterNum(fld2.value);
			return true;
		}	
</script>
