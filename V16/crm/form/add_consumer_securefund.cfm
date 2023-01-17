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

<cfquery name="SETUP_SECUREFUND" datasource="#dsn#">
	SELECT 
	    *
	FROM 
	    SETUP_SECUREFUND
</cfquery>


<cfform name="add_secure" method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=crm.emptypopup_add_consumer_securefund">
  <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" height="100%">
    <tr class="color-border">
      <td>
        <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
          <tr class="color-list">
            <td class="headbold" colspan="2" height="35">&nbsp;<cf_get_lang no='239.Teminat Ekle'></td>
          </tr>
          <tr class="color-row">
            <td valign="top">
			<table>
			  <tr>
				<td width="100"><cf_get_lang_main no='81.Aktif'></td>
				<td width="200"><input type="checkbox" name="SECUREFUND_STATUS" id="SECUREFUND_STATUS" value="1" checked></td>
				<td width="80"><cf_get_lang_main no='1518.masraf'></td>
				<td>
				<select name="money_cat_expense" id="money_cat_expense" style="width:50px;">
                    <option value=""><cf_get_lang_main no='224.birim'></option>
                    <cfoutput query="GET_MONEY_RATE">
                        <option value="#money#">#money#</option>
                    </cfoutput>
				</select>
				<cfinput type="text" name="expense_total" validate="float" range="0.01," style="width:95px;" value="" onkeyup="return(FormatCurrency(this,event));">
				</td>
			  </tr>
			  <tr>
				<td><cf_get_lang no='240.Teminat Veren Üye'></td>
				<td>
				<input type="text" name="consumer" id="consumer" value="<cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>" readonly style="width:150px;">
				<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
				</td>
				<td><cf_get_lang_main no='109.Banka'></td>
				<td><cfinput name="bank" type="text" style="width:150px;" value="" maxlength="50"></td>
			  </tr>
			  <tr>
				<td><cf_get_lang no='241.Kendi Şirketimiz'></td>
				<td>
				<select name="our_company_id" id="our_company_id" style="width:150px;">
					<cfoutput query="get_our_companies">
						<option value="#COMP_ID#"<cfif comp_id eq session.ep.company_id> selected</cfif>>#company_name#</option>
					</cfoutput>
				</select>
				</td>
				<td><cf_get_lang_main no='1521.Banka Şubesi'></td>
				<td><cfinput name="bank_branch" type="text" style="width:150px;" value="" maxlength="50"></td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='74.Teminat Kategorisi'>*</td>
				<td>
					<select name="SECUREFUND_CAT_ID" id="SECUREFUND_CAT_ID" style="width:150px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option> 
						<cfoutput query="SETUP_SECUREFUND">
							<option value="#SECUREFUND_CAT_ID#">#SECUREFUND_CAT#</option>
						</cfoutput>
					</select>
				</td>
				<td><cf_get_lang_main no='217.Açıklama'></td>
				<td rowspan="5" valign="top"><textarea name="REALESTATE_DETAIL" id="REALESTATE_DETAIL" style="width:150px;height:115px;"></textarea></td>
			  </tr>
			  <tr>
				<td><cf_get_lang_main no='1076.Alınan'>/<cf_get_lang_main no='1078.Verilen'></td>
				<td>
				<select name="GIVE_TAKE" id="GIVE_TAKE" style="width:150px;">
					<option value="0" selected><cf_get_lang_main no='1076.Alınan'></option>
					<option value="1"><cf_get_lang_main no='1078.Verilen'></option>
				</select>
				</td>
				<td></td>
				</tr>
			  <tr>
				<td><cf_get_lang_main no='261.Tutar'> - <cf_get_lang_main no='77.Para Birimi'>*</td>
				<td>
				<select name="money_type" id="money_type" style="width:50px;">
					<cfoutput query="GET_MONEY_RATE">
                        <option value="#money#">#money#</option>
                    </cfoutput>
				</select>
				<cfsavecontent variable="message"><cf_get_lang_main no='1738.tutar girmelisiniz'></cfsavecontent>
				<cfinput type="text" name="SECUREFUND_TOTAL" validate="float" range="0.01," required="yes" message="#message#" style="width:95px;" value="" onkeyup="return(FormatCurrency(this,event));">
				</td>
				<td>&nbsp;</td>
				</tr>
			  <tr>
				<td><cf_get_lang_main no='243.Başlama Tarihi'>*</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='1333.başlama girmelisiniz'></cfsavecontent>
				<cfinput value="" validate="#validate_style#" required="Yes" message="#message#" type="text" name="START_DATE" style="width:130px;"> 
				<cf_wrk_date_image date_field="START_DATE"></td>
				<td>&nbsp;</td>
				</tr>
			  <tr>
				<td><cf_get_lang_main no='288.Bitiş Tarihi'>*</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='327.bitiş girmelisiniz'></cfsavecontent>
				<cfinput value="" validate="#validate_style#" required="Yes" message="#message#" type="text" name="FINISH_DATE" style="width:130px;"> 
				<cf_wrk_date_image date_field="FINISH_DATE">
				</td>
				<td>&nbsp;</td>
				</tr>
			  <tr>
				<td><cf_get_lang no='167.Uyarı Tarihi'>*</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang no='265.uyarı girmelisiniz'></cfsavecontent>
				<cfinput value="" validate="#validate_style#" required="Yes" message="#message#" type="text" name="WARNING_DATE" style="width:130px;"> 
				<cf_wrk_date_image date_field="WARNING_DATE">
				</td>
				<td><cf_get_lang_main no='54.Belge'></td>
				<td><input  type="file" name="SECUREFUND_FILE" style="width:150px;"></td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td> </td>
				<td></td>
				<td  style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function="kontrol()"></td>
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
			alert ("<cf_get_lang no='314.Teminat Kategorisi'>!");
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
