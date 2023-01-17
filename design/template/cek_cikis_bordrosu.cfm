<!--- Cek Cikis Bordrosu --->
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfquery name="GET_MONEY_RATE" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS=1 AND RATE1=RATE2
</cfquery>
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
<cfset url.id=attributes.ACTION_ID>
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT * FROM PAYROLL WHERE ACTION_ID=#URL.ID# AND PAYROLL_TYPE = 91
</cfquery>
<cfquery name="GET_CHEQUE_HISTORY" datasource="#dsn2#">
	SELECT COUNT(CHEQUE_ID) AS KAYIT FROM CHEQUE_HISTORY WHERE PAYROLL_ID = #URL.ID# 
</cfquery>
<cfquery name="GET_CHEQUE_DETAIL" datasource="#dsn2#">
	SELECT
		CHEQUE.CURRENCY_ID,
		CHEQUE.RECORD_EMP,
		CHEQUE.UPDATE_EMP
		,*
	FROM
		CHEQUE_HISTORY,
		CHEQUE
	WHERE 
		CHEQUE_HISTORY.PAYROLL_ID = #url.id# AND 
		(CHEQUE_HISTORY.STATUS = 4 OR CHEQUE_HISTORY.STATUS = 6) AND 
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
	ORDER BY CHEQUE.CHEQUE_ID ASC
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNTS.*,
		BANK_BRANCH.BANK_NAME,
		BANK_BRANCH.BANK_BRANCH_NAME
	FROM
		ACCOUNTS,	
		BANK_BRANCH,
		#dsn2_alias#.SETUP_MONEY AS SM
	WHERE
	<cfif isDefined("GET_CHEQUE_DETAIL.ACCOUNT_ID") and len(GET_CHEQUE_DETAIL.ACCOUNT_ID)>
		ACCOUNTS.ACCOUNT_ID=#GET_CHEQUE_DETAIL.ACCOUNT_ID# AND
	</cfif>
		ACCOUNTS.ACCOUNT_CURRENCY_ID = SM.MONEY AND
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
<cfif GET_ACTION_DETAIL.payroll_type neq 91>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<div align="center">
	<br/>
    <table width="650" border="0" cellspacing="0" cellpadding="0">
        <tr> 
			<cfif len(CHECK.asset_file_name3)>
                <td style="text-align:right;">
                <cfoutput><cf_get_server_file output_file="settings/#CHECK.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5"></cfoutput>
                </td>
            </cfif>
            <td style="width:10mm;">&nbsp;</td>
            <td valign="top">
			<cfoutput query="CHECK">
                <strong style="font-size:14px;">#company_name#</strong><br/>
                #address#<br/>
                <b><cf_get_lang dictionary_id='57499.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# <br/>
                <b><cf_get_lang dictionary_id='57488.Fax'>: </b> #fax# <br/>
                <b><cf_get_lang dictionary_id='58762.Vergi Dairesi'> : </b> #TAX_OFFICE# <b><cf_get_lang dictionary_id='57752.No'> : </b> #TAX_NO#<br/>
                #web# - #email#
			</cfoutput>
            </td>
        </tr>
        <tr><td colspan="3"><hr></td></tr>
    </table>
    <br/>
    <table width="650" height="30" border="0">
        <tr>
            <td style="text-align:center" class="formbold"><b><cf_get_lang dictionary_id='30089.Çek Çıkış Bordrosu'></b></td>
        </tr>
    </table>
    <table width="650" border="0">
        <cfoutput>
        <tr>
            <td><cf_get_lang dictionary_id='33983.Bordro No'>: <strong>#get_action_detail.PAYROLL_NO#</strong></td>
            <td style="text-align:right;"> <cf_get_lang dictionary_id='57742.Tarih'>:
            	<strong>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong>
            </td>
        </tr>
        <tr>
            <td height="50" colspan="3">
                <cfif len(get_action_detail.COMPANY_ID)>
                    <strong>#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#</strong>
                <cfelseif len (get_action_detail.employee_id)>
                    <strong>#get_emp_info(get_action_detail.employee_id,0,0)#</strong>
                <cfelseif len(get_action_detail.consumer_id)>
                    <strong>#get_cons_info(get_action_detail.consumer_id,0,0)#</strong>
                </cfif>
                <cf_get_lang dictionary_id="50231.cari hesabına mahsuben">
                <cfset myNumber = get_action_detail.PAYROLL_TOTAL_VALUE>
                <cf_n2txt number="myNumber" para_birimi="#get_action_detail.CURRENCY_ID#"><strong>#myNumber#</strong> <cf_get_lang dictionary_id="50230.Çek Verilmiştir">.</td>
            </td>
        </tr>
		</cfoutput>
    </table>
    <table width="650">
        <tr height="22" class="txtbold">
			<td><cf_get_lang dictionary_id='58007.Çek'> <cf_get_lang dictionary_id='57487.No'></td>
            <td><cf_get_lang dictionary_id='58182.Portföy No'></td>
       		<td><cf_get_lang dictionary_id='57521.Banka'></td>
            <td><cf_get_lang dictionary_id='57453.Şube'></td>
       		<td><cf_get_lang dictionary_id='58178.Hesap No'></td>
            <td><cf_get_lang dictionary_id='57640.Vade'></td>
            <td><cf_get_lang dictionary_id='57673.Tutar'></td>
            <td><cf_get_lang dictionary_id='58180.Borçlu'></td>
        </tr>
		<!--- Burasi cek sayisi kadar artacak..--->
        <cfoutput query="get_cheque_detail">
        <tr>
            <td>#CHEQUE_NO#</td>
            <td>#CHEQUE_PURSE_NO#</td>
            <td>#BANK_NAME#</td>
            <td>#BANK_BRANCH_NAME#</td>
            <td><cfif len(ACCOUNT_ID)>#GET_ACCOUNTS.ACCOUNT_NO#<cfelse>#ACCOUNT_NO#</cfif></td>
            <td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
            <td>#TLFormat(CHEQUE_VALUE)# #CURRENCY_ID#</td>
            <td>#DEBTOR_NAME#</td>
        </tr>
        <tr valign="top"><td colspan="8"><hr></td></tr>
        </cfoutput>
    </table>
    <table width="650">
        <tr>
            <td style="text-align:right;">
            <table border="0">
                <cfoutput>
                <tr>
                    <td width="110"><strong><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='50244.Çek Sayısı'></strong></td>
                    <td width="110"><strong>:</strong>&nbsp;&nbsp;&nbsp;#GET_CHEQUE_HISTORY.KAYIT#</td>
                    <td width="50"><strong><cf_get_lang dictionary_id='58645.Nakit'></strong></td>
                    <td width="85">:</td>
                    <td width="75"><strong><cf_get_lang dictionary_id='57775.Teslim Alan'></strong></td>
                    <td width="150"> :<!---<cfif len(get_action_detail.COMPANY_ID)>
					<cfquery name="geT_manager_partner" datasource="#dsn#">
						SELECT MANAGER_PARTNER_ID FROM COMPANY WHERE COMPANY_ID = #get_action_detail.COMPANY_ID#
					</cfquery>
					<cfif len(geT_manager_partner.manager_partner_id)>
					<cfoutput>#get_par_info(geT_manager_partner.manager_partner_id,0,-1,0)#</cfoutput>
					</cfif>
					<cfelseif len (get_action_detail.employee_id)>
					<cfoutput>#get_emp_info(get_action_detail.employee_id,0,0)#</cfoutput>
					<cfelseif len(get_action_detail.consumer_id)>
					<cfoutput>#get_cons_info(get_action_detail.consumer_id,0,0)#</cfoutput>
					</cfif> --->
					<!--- Carinin yetkilisinin gelmesi istendi
					<cfif isdefined("get_action_detail.PAYROLL_REV_MEMBER") and len(get_action_detail.PAYROLL_REV_MEMBER)>
					<cfoutput>#get_emp_info(get_action_detail.PAYROLL_REV_MEMBER,0,0)#</cfoutput>
					</cfif>---></td>
                </tr>
                <tr><!---<cfif get_action_detail.PAYROLL_OTHER_MONEY neq session.ep.money>
                <td><strong>Toplam #get_action_detail.PAYROLL_OTHER_MONEY#</strong></td>
                <td>: #TLFormat(get_action_detail.PAYROLL_OTHER_MONEY_VALUE)# #get_action_detail.PAYROLL_OTHER_MONEY#</td>
                </cfif>--->
                    <td>&nbsp;</td> 
                    <td>&nbsp;</td>
                    <td width="75"><strong><cf_get_lang dictionary_id='57492.Toplam'> #session.ep.money#</strong></td>
                    <td width="85">: #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</td>
                    <td>&nbsp;<strong><cf_get_lang dictionary_id="50232.Teslim Eden"></strong></td> 
                    <td width="150">: &nbsp;
						<cfif len(GET_ACTION_DETAIL.update_emp)><!--- get_cheque_detail --->
                            #get_emp_info(GET_ACTION_DETAIL.update_emp,0,0)#
                        <cfelse>
                            #get_emp_info(GET_ACTION_DETAIL.record_emp,0,0)#
                        </cfif>  			
                    </td>
                </tr>
				</cfoutput>
            </table>
        </td>
    </tr>
</table>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
