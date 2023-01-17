<cf_get_lang_set module_name="objects">
<cfparam name="attributes.EMP_ID" default="">
<cfquery name="GET_MONEY_RATE" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY_STATUS=1 AND 
		RATE1=RATE2
</cfquery>
<cfset url.id=attributes.action_id>

<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT
		*
	FROM
		VOUCHER_PAYROLL
	WHERE
		ACTION_ID=#URL.ID#
</cfquery>
<cfquery name="GET_VOUCHER_HISTORY" datasource="#dsn2#">
		SELECT 
			COUNT(VOUCHER_ID) AS KAYIT 
		FROM
			VOUCHER_HISTORY
		WHERE
			PAYROLL_ID = #URL.ID#
</cfquery>

<cfquery name="GET_VOUCHER_DETAIL" datasource="#dsn2#">
	SELECT
		*
	FROM
		VOUCHER_HISTORY,
		VOUCHER
	WHERE 
		VOUCHER_HISTORY.PAYROLL_ID = #URL.ID# AND 
		VOUCHER.VOUCHER_ID = VOUCHER_HISTORY.VOUCHER_ID
</cfquery>
<cfset list_senet = ''>
<cfset list_senet = ListDeleteDupLicates(valuelist(GET_VOUCHER_DETAIL.CURRENCY_ID,','))>
<cfset senet_toplam = 0>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT
	    COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
	    COMP_ID = #session.pp.company_id#
	</cfif> 
</cfquery>
<cfif GET_ACTION_DETAIL.payroll_type neq 101>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfoutput query="GET_VOUCHER_DETAIL">
	<cfif (currentrow eq 1) or (GET_VOUCHER_DETAIL.currency_id eq GET_VOUCHER_DETAIL.currency_id[currentrow-1])>
		<cfset senet_toplam = senet_toplam + VOUCHER_VALUE>
	<cfelse>
		<cfset senet_toplam = ''>
	</cfif>
</cfoutput>
<div align="center">
  <br/>
  <table width="650" border="0" cellspacing="0" cellpadding="0">
	  <tr> 
	  	   <cfif len(CHECK.asset_file_name3)>
		  <td style="text-align:right;">
			  <cfoutput>
				 <cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5">
			  </cfoutput>
		  </td>
		  </cfif>
		  <td style="width:10mm;">&nbsp;</td>
		  <td valign="top">
			  <cfoutput QUERY="CHECK">
				 <strong style="font-size:14px;">#company_name#</strong><br/>
				  #address#<br/>
				  <b><cf_get_lang_main no='87.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# <br/>
				  <b><cf_get_lang_main no='76.Fax'>: </b> #fax# <br/>
				  <b><cf_get_lang_main no='1350.Vergi Dairesi'>: </b> #TAX_OFFICE# <b><cf_get_lang_main no='75.No'> : </b> #TAX_NO#<br/>
				  #web# - #email#
			  </cfoutput>
		  </td>
	  </tr>
	  <tr>
	 	 <td colspan="3"><hr></td>
	  </tr>
  </table>
  <cfset cumle = ''>
  <table width="100%" height="30">
	<tr>
		<td align="center" class="formbold">
			
			<cfif isdefined("attributes.type")>
				<cfif attributes.type eq 101>
					<cfoutput><b><cf_get_lang_main no='1805.Senet Çikis Iade Bordrosu'></b></cfoutput>
					<cfset cumle = 'Senet İade Edilmiştir'>
				</cfif>
			</cfif>
		</td>
	</tr>
  </table>
  <table width="650">
    <tr>
      <td><cf_get_lang no='1593.Bordro No'>: <cfoutput><strong>#get_action_detail.PAYROLL_NO#</strong></cfoutput></td>
      <td style="text-align:right;"> <cf_get_lang_main no='330.Tarih'>:
	   <cfoutput><strong>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong></cfoutput>
	   </td>
    </tr>
    <tr>
      <td height="50" colspan="2">
        <cfif len(get_action_detail.COMPANY_ID)>
          <cfoutput><strong>#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#</strong></cfoutput>
        </cfif>
        <cf_get_lang no="826.cari hesabına mahsuben">
		<cfif listlen(list_senet) neq 1 or list_senet is session.ep.money>
			<cfset myNumber = get_action_detail.PAYROLL_TOTAL_VALUE>
			<cf_n2txt number="myNumber" para_birimi="#get_action_detail.CURRENCY_ID#"><cfoutput><strong>#myNumber#</strong> #cumle#.</cfoutput><cf_get_lang no="830.senet iade edilmiştir">
		<cfelseif listlen(list_senet) eq 1 and not list_senet is session.ep.money>
			<cfset myNumber = senet_toplam>
			<cf_n2txt number="myNumber" para_birimi="#list_senet#"><cfoutput><strong>#myNumber#</strong> #cumle#.</cfoutput> <cf_get_lang no="830.senet iade edilmiştir">
		</cfif>
      </td>
    </tr>
  </table>
  <table width="650">
    <tr height="22" class="txtbold">
      <td><cf_get_lang_main no='1090.Senet No'></td>
	  <td><cf_get_lang_main no='770.Portföy No'></td>
	  <td><cf_get_lang_main no='768.Borçlu'></td>
      <td><cf_get_lang_main no='228.Vade'></td>
      <td><cf_get_lang_main no='261.Tutar'></td>
    <cfif get_voucher_detail.CURRENCY_ID neq session.ep.money or listlen(list_senet) neq 1>
	  <td><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang_main no='261.Tutar'></td>
	</cfif>
    </tr>
    <cfoutput query="GET_VOUCHER_DETAIL">
      <tr>
        <td>#VOUCHER_NO#</td>
		<td>#VOUCHER_PURSE_NO#</td>
		<td>#DEBTOR_NAME#</td>
        <td>#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
        <td>#TLFormat(VOUCHER_VALUE)# #CURRENCY_ID#</td>
	    <cfif CURRENCY_ID neq session.ep.money>
		 <td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
		</cfif>
      </tr>
      <tr valign="top">
	   <cfif CURRENCY_ID neq session.ep.money or listlen(list_senet) neq 1>
	 	 <td colspan="6"><hr>
	   <cfelse>
         <td colspan="5"><hr>
		</td></cfif>
        
      </tr>
    </cfoutput>
  </table>
  <table width="650">
    <tr>
      <td style="text-align:right;">
        <table border="0">
			<cfquery name="GET_MONEY" datasource="#dsn2#">
				SELECT
					*
				FROM
					VOUCHER_PAYROLL_MONEY
				WHERE
					ACTION_ID = #URL.ID# AND
					IS_SELECTED=1
			</cfquery>
		 <tr>
		  	<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td style="width:10mm;">&nbsp;</td>
		  	<td width="75"><strong><cf_get_lang_main no='363.Teslim Alan'></strong></td>
            <td>:
               <cfif isdefined("get_action_detail.PAYROLL_REV_MEMBER") and len(get_action_detail.PAYROLL_REV_MEMBER)>
                 <cfoutput>#get_emp_info(get_action_detail.PAYROLL_REV_MEMBER,0,0)#</cfoutput>
               </cfif>
            </td>
          </tr>
		 <tr>
			<cfif listlen(list_senet) eq 1 and list_senet neq session.ep.money>
				<cfoutput> 
				<td><strong><cf_get_lang_main no='80.Toplam'> #get_voucher_detail.CURRENCY_ID#</strong></td>
				<td>: #TLFormat(senet_toplam)# #get_voucher_detail.CURRENCY_ID#</td>
				</cfoutput>	
			<cfelse>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</cfif>
			<cfoutput>
			<td style="width:10mm;">&nbsp;</td>
            <td><strong><cf_get_lang_main no='80.Toplam'> #session.ep.money#</strong></td>
            <td>: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</td>
			</cfoutput>
          </tr>
        </table>
      </td>
    </tr>
	<tr>
		<td>
			<table>
				<tr><td colspan="2" style="height:4mm;">&nbsp;</td></tr>
				<tr>
					<td style="height:5mm;"><strong><cf_get_lang_main no="80.Toplam"> <cf_get_lang_main no="596.Senet"></strong></td>
					<td><strong>:</strong>&nbsp;&nbsp;&nbsp;<cfoutput>#GET_VOUCHER_HISTORY.KAYIT#</cfoutput></td>
				</tr>
				<cfoutput>
				<cfif GET_VOUCHER_DETAIL.CURRENCY_ID neq session.ep.money>
				<tr>
				<cfif GET_MONEY.recordcount>
					<td style="height:5mm;"><strong>#GET_MONEY.MONEY_TYPE# <cf_get_lang_main no="236.KUR"></strong></td>
					<td><strong>:</strong>&nbsp;&nbsp;&nbsp;#GET_MONEY.RATE1# / #TLFormat(GET_MONEY.RATE2,4)#</td>
				<cfelse>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</cfif>
				</tr>
			</cfif>
			</cfoutput>
			</table>
		</td>
	</tr>
  </table>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
