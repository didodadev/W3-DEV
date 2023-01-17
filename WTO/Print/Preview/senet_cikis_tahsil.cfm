<cf_get_lang_set module_name="objects">
<!--- Senet Çıkış Tahsil  --->
<cfset url.id = attributes.action_id>
<cfquery name="Get_Action_Detail" datasource="#dsn2#">
	SELECT * FROM VOUCHER_PAYROLL WHERE ACTION_ID = #URL.ID#
</cfquery>
<cfif Get_Action_Detail.payroll_type neq 104>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="Our_Company" datasource="#dsn#">
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
<cfquery name="Get_Voucher_History" datasource="#dsn2#">
	SELECT COUNT(VOUCHER_ID) AS KAYIT FROM VOUCHER_HISTORY WHERE PAYROLL_ID = #URL.ID#
</cfquery>
<cfquery name="Get_Voucher_Detail" datasource="#dsn2#">
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
<style>
	.bold{ font-weight:bold;font-size:14px;}
	.kalin{ font-weight:bold;}
</style>
<table border="0" cellpadding="0" cellspacing="0" align="center">
	<tr>
    	<td>
        <table>
        	<tr>
            	<td>
                <table width="650" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <cfif len(Our_Company.ASSET_FILE_NAME3)>
                        <td style="text-align:left;">
                          <cfoutput>
                             <cf_get_server_file 
                                output_file="settings/#Our_Company.ASSET_FILE_NAME3#" 
                                output_server="#Our_Company.ASSET_FILE_NAME3_SERVER_ID#" 
                                output_type="5">
                          </cfoutput>
                        </td>
                        </cfif>
                        <td style="width:10mm;">&nbsp;</td>
                        <td valign="top" style="text-align:right;">
                        <cfoutput query="Our_Company">
                            <strong style="font-size:14px;">#company_name#</strong><br/>
                            #address#<br/>
                            <b><cf_get_lang_main no='87.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# <br/>
                            <b><cf_get_lang_main no='76.Fax'>: </b> #fax# <br/>
                            <b><cf_get_lang_main no='1350.Vergi Dairesi'>: </b> #TAX_OFFICE# <b><cf_get_lang_main no='75.No'>: </b> #TAX_NO#<br/>
                            #web# - #email#
                        </cfoutput>
                        </td>
                    </tr>
                    <tr><td colspan="3"><hr></td></tr>
                </table>
                </td>
            </tr>
            <tr><td class="bold" style="text-align:center;"><cf_get_lang_main no="599.SENET ÇIKIŞ BORDROSU"> - <cf_get_lang_main no="2223.TAHSİL"></td></tr>
            <tr><td><hr /></td></tr>
            <tr>
            	<td style="text-align:center;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
                <cfoutput>	
                	<tr>
                    	<td style="text-align:left;width:20mm;" class="kalin"><cf_get_lang no="1593.Bordro No"></td>
                        <td style="text-align:left;width:90mm;">: #Get_Action_Detail.Payroll_No#</td>
                        <td style="text-align:left;width:20mm;" class="kalin"><cf_get_lang_main no="330.Tarih"> </td>
                        <td style="text-align:left;">: #dateformat(Get_Action_Detail.PAYROLL_REVENUE_DATE,dateformat_style)#</td>
                    </tr>
                    <tr><td colspan="4" style="height:5mm;">&nbsp;</td></tr>
                    <tr>
                    	<td colspan="4">
						<cfif len(Get_Action_Detail.COMPANY_ID)>#get_par_info(Get_Action_Detail.COMPANY_ID,1,1,0)#</cfif><cf_get_lang no="826.cari hesabına mahsuben ">
                        <cfif listlen(list_senet) neq 1 or list_senet is session.ep.money>
							<cfset myNumber = Get_Action_Detail.PAYROLL_TOTAL_VALUE>
                            <cf_n2txt number="myNumber" para_birimi="#Get_Action_Detail.CURRENCY_ID#"><strong>#myNumber#</strong> <cf_get_lang no="829.senet alınmıştır">.
                        <cfelseif listlen(list_senet) eq 1 and not list_senet is session.ep.money>
                            <cfset myNumber = senet_toplam>
                            <cf_n2txt number="myNumber" para_birimi="#list_senet#"><strong>#myNumber#</strong> <cf_get_lang no="829.senet alınmıştır">.
                        </cfif>
                        </td>
                    </tr>
				</cfoutput>
                </table>
                </td>
            </tr>
            <tr><td>&nbsp;</td></tr>
            <tr>
            	<td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
                	<tr class="kalin">
                    	<td style="text-align:left;width:30mm;"><cf_get_lang_main no='1090.Senet No'></td>
                        <td style="text-align:left;width:30mm;"><cf_get_lang_main no='770.Portföy No'></td>
                        <td style="text-align:left;width:30mm;"><cf_get_lang_main no='768.Borçlu'></td>
                        <td style="text-align:left;width:30mm;"><cf_get_lang_main no='228.Vade'></td>
                        <td style="text-align:center;width:30mm;"><cf_get_lang_main no='261.Tutar'></td>
						<cfif Get_Voucher_Detail.Currency_Id neq session.ep.money or listlen(list_senet) neq 1>
                        <td style="text-align:center;width:30mm;"><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang_main no='261.Tutar'></td>
                        </cfif>
                    </tr>
                </table>
                </td>
            </tr>
            <tr>
            	<td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
                <cfoutput query="Get_Voucher_Detail">
                	<tr>
                    	<td style="text-align:left;width:30mm;">#VOUCHER_NO#</td>
                        <td style="text-align:left;width:30mm;">#VOUCHER_PURSE_NO#</td>
                        <td style="text-align:left;width:30mm;">#DEBTOR_NAME#</td>
                        <td style="text-align:left;width:30mm;">#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
                        <td style="text-align:right;width:30mm;">#TLFormat(VOUCHER_VALUE)# #CURRENCY_ID#</td>
                        <cfif CURRENCY_ID neq session.ep.money>
							<td style="text-align:right;width:30mm;">#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
                        </cfif>
                    </tr>
                </cfoutput>
                </table>
                </td>
            </tr>
            <tr><td><hr /></td></tr>
            <tr>
                <td style="text-align:right;">
                <table>
                <cfquery name="GET_MONEY" datasource="#dsn2#">
                    SELECT * FROM VOUCHER_PAYROLL_MONEY WHERE ACTION_ID = #URL.ID# AND IS_SELECTED=1
                </cfquery>
                <cfoutput>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td style="width:10mm;">&nbsp;</td>
                        <td style="width:30mm;" class="kalin"><cf_get_lang no='1093.Tahsil Eden'></td>
                        <td style="text-align:left;">: <cfif isdefined("get_action_detail.REVENUE_COLLECTOR_ID") and len(get_action_detail.REVENUE_COLLECTOR_ID)>
                        		#get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#
                              </cfif>
                        </td>
                    </tr>
                    <tr>
                    <cfif listlen(list_senet) eq 1 and list_senet neq session.ep.money>
                        <td style="width:30mm;" class="kalin"><cf_get_lang_main no='80.Toplam'> #get_voucher_detail.CURRENCY_ID#</td>
                        <td style="text-align:left;">: #TLFormat(senet_toplam)# #get_voucher_detail.CURRENCY_ID#</td>
                    <cfelse>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </cfif>
                        <td style="width:10mm;">&nbsp;</td>
                        <td style="width:30mm;" class="kalin"><cf_get_lang_main no='80.Toplam'></td>
                        <td>: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</td>
                    </tr>
				</cfoutput>
                </table>
                </td>
            </tr>
            <tr>
                <td>
                <table border="0" cellpadding="0" cellspacing="0">
                <cfoutput>
                    <tr><td colspan="2" style="height:5mm;">&nbsp;</td></tr>
                    <tr>
                        <td style="width:30mm;height:5mm;text-align:left;" class="kalin"><cf_get_lang_main no="80.Toplam"> <cf_get_lang_main no="596.Senet"></td>
                        <td style="width:30mm;"><strong>:</strong>&nbsp;&nbsp;&nbsp;#GET_VOUCHER_HISTORY.KAYIT#</td>
                    </tr>
                    <tr>
                        <td style="width:30mm;height:5mm;text-align:left;" class="kalin"><cf_get_lang_main no='449.Ortalama Vade'></td>
                        <td style="width:30mm;"><strong>:</strong>&nbsp;&nbsp;&nbsp;#dateformat(get_action_detail.payroll_avg_duedate,'dd/mm/yy')#</td>
                    </tr>
                    <cfif GET_VOUCHER_DETAIL.CURRENCY_ID neq session.ep.money>
                    	<tr>
                    	<cfif GET_MONEY.recordcount>
                            <td style="width:30mm;height:5mm;text-align:left;" class="kalin">#GET_MONEY.MONEY_TYPE# <cf_get_lang_main no="236.KUR"></td>
                            <td style="width:30mm;"><strong>:</strong>&nbsp;&nbsp;&nbsp;#GET_MONEY.RATE1# / #TLFormat(GET_MONEY.RATE2,4)#</td>
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
        </td>
    </tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
