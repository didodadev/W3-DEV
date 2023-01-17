<!--- form_add_cc_cons.cfm --->
<cfif isDefined("url.ccid")>
<script type="text/javascript">
function del_cc()
{
	<cfoutput>
	window.location.href = '#request.self#?fuseaction=crm.del_cc&ccid=#url.ccid#';
	</cfoutput>
	return true;
}
</script>
</cfif>
<cfif isdefined("form.cc_no") and not isdefined("url.ccid")>
	<cfquery name="ADD_CC" datasource="#dsn#">
	INSERT
	INTO 
	CONSUMER_CC 
	(
		CONSUMER_ID,
		CONSUMER_CC_TYPE,
		CONSUMER_CC_NUMBER,
		CONSUMER_EX_MONTH,
		CONSUMER_EX_YEAR,
		CONS_CVS
	)
	VALUES 
	(   
		#FORM.CID#,
		#FORM.CC_TYPE#,
		#FORM.CC_NO#,
		#FORM.MONTH#,
		#FORM.YEAR#,
		#FORM.CVS#
   )
	</cfquery>
	<script type="text/javascript">
	wrk_opener_reload();	
	window.close();
	</script>
</cfif>
<cfif isdefined("url.ccid")>
	<cfif isdefined("form.ccid")>
	<cfquery name="UPD_CC" datasource="#dsn#">
		UPDATE 
			CONSUMER_CC  
		SET 
			CONSUMER_ID = #FORM.CID#,
			CONSUMER_CC_TYPE =#FORM.CC_TYPE#,
			CONSUMER_CC_NUMBER = #FORM.CC_NO#,
			CONSUMER_EX_MONTH = #FORM.MONTH#,
			CONSUMER_EX_YEAR = #FORM.YEAR#,
			CONS_CVS = #FORM.CVS#
		WHERE 
			CONSUMER_CC_ID = #FORM.CCID#						   
	</cfquery>
		<script type="text/javascript">
		wrk_opener_reload();	
		window.close();
		</script>
	</cfif>
	<cfquery name="GET_CONS_CC" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			CONSUMER_CC
		WHERE 
			CONSUMER_CC_ID = #URL.CCID#
		ORDER BY
			CONSUMER_CC_TYPE
	</cfquery>
</cfif>
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border"> 
    <td valign="middle"> 
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle"> 
          <td height="35"> 
            <table width="98%" align="center">
              <tr> 
                <td valign="bottom" class="headbold"><cf_get_lang no='224.Kredi Kartı Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top"> 
          <td> 
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr> 
                <td colspan="2"><br/>	
				<cfform action="" method="post">
				<cfoutput>
				<input type="hidden" value="#url.cid#" name="cid" id="cid">
				<cfif isdefined("url.ccid")>
				<input type="hidden" value="#url.ccid#" name="ccid" id="ccid">
				</cfif>
				</cfoutput>
                <table>
                  <tr> 
				      <td width="100"><cf_get_lang no='225.Kart Tipi'></td>
				        <td> 
						<select name="cc_type" id="cc_type" style="width:220px;">
                       		<cfquery name="get_card" datasource="#dsn#">
								SELECT 
									CARDCAT,
									CARDCAT_ID
								FROM
									SETUP_CREDITCARD
							</cfquery>
							<option value="0"><cf_get_lang_main no='322.Seçiniz'>
							<cfoutput query="get_card">
							<option value="#CARDCAT_ID#" <cfif isdefined("url.ccid") and get_card.CARDCAT_ID eq get_cons_cc.CONSUMER_CC_TYPE>selected</cfif>>#CARDCAT#</option>
							</cfoutput>
                          </select> 						
						</td>
				    </tr>
				    <tr> 
				      <td><cf_get_lang no='226.Kart Numarası'></td>
				      <td> 
				        <cfif isdefined("url.ccid")>
						<cfinput type="Text" name="cc_no" required="Yes"  value="#get_cons_cc.consumer_cc_number#" style="width:220px;">
						<cfelse>
						<cfinput type="Text" name="cc_no" required="Yes" style="width:220px;">
						</cfif>
				      </td>
				    </tr>
				    <tr> 
				      <td><cf_get_lang no='227.Son Kullanma Tarihi'></td>
				      <td> 
					  	<cfif isdefined("url.ccid")>
				        <cfinput type="Text" size="3" name="month" value="#get_cons_cc.CONSUMER_EX_MONTH#" required="Yes" maxlength="2" style="width:97px;">
				        <cf_get_lang_main no='1312.Ay'> /
						<cfinput required="Yes" type="Text" name="year" value="#get_cons_cc.CONSUMER_EX_YEAR#" size="5" maxlength="4" style="width:97px;">
				        <cf_get_lang no='229.Yıl'>
						<cfelse>
						<cfinput type="Text" size="3" name="month" required="Yes" maxlength="2" style="width:97px;">
				        <cf_get_lang_main no='1312.Ay'> /
						<cfinput required="Yes" type="Text" name="year" size="5" maxlength="4" style="width:97px;">
				        <cf_get_lang no='229.Yıl'>
						</cfif>
					  </td>
				    </tr>
				    <tr> 
				      <td><cf_get_lang no='230.CVS NO'></td>
				      <td> 
					  	<cfif isdefined("url.ccid")>
				        <cfinput type="Text" name="CVS" required="Yes" style="width:220px;" value="#get_cons_cc.CONS_CVS#">
						<cfelse>
						<cfinput type="Text" name="CVS" required="Yes" style="width:220px;">
						</cfif>
				      </td>
				    </tr>
				    <tr> 
				      <td style="text-align:right;" colspan="2"> 
					  	<cfif isdefined("url.ccid")>
					 	<cf_workcube_buttons is_upd='1' is_delete='1' del_function='del_cc()'>
						<cfelse>
						<cf_workcube_buttons is_upd='0' del_function='del_cc()'>
                        </cfif>
                        &nbsp; &nbsp; </td>
				    </tr>
				  </table>
				</cfform>         
				</td>
              </tr>
           </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>


