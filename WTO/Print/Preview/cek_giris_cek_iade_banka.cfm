<!--- Cek Giris Cek Iade Banka --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">

<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT * FROM PAYROLL_MONEY WHERE ACTION_ID = #attributes.ACTION_ID# AND IS_SELECTED=1
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
        ASSET_FILE_NAME2,
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		ASSET_FILE_NAME2_SERVER_ID,
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
	SELECT * FROM PAYROLL WHERE	ACTION_ID=#URL.ID#
</cfquery>
<cfquery name="GET_CHEQUE_HISTORY" datasource="#dsn2#">
    SELECT 
        COUNT(CHEQUE_ID) AS KAYIT 
    FROM
        CHEQUE_HISTORY
    WHERE
        PAYROLL_ID = #URL.ID#
</cfquery>
<cfquery name="GET_CHEQUE_DETAIL" datasource="#dsn2#">
	SELECT
		CHEQUE.CURRENCY_ID,*		
	FROM
		CHEQUE_HISTORY,
		CHEQUE
	WHERE 
		CHEQUE_HISTORY.PAYROLL_ID = #URL.ID# AND 
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<cfset list_birim = ''>
<cfset list_birim = ListDeleteDupLicates(valuelist(GET_CHEQUE_DETAIL.CURRENCY_ID,','))>
<cfset toplam_tutar = 0>
<cfif GET_ACTION_DETAIL.payroll_type neq 90 and  GET_ACTION_DETAIL.payroll_type neq 105>
	<script type="text/javascript">
		alert("Belge tipi uygun değil!");
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfoutput query="GET_CHEQUE_DETAIL">
	<cfif (currentrow eq 1) or (GET_CHEQUE_DETAIL.currency_id eq GET_CHEQUE_DETAIL.currency_id[currentrow-1])>
		<cfset toplam_tutar = toplam_tutar + CHEQUE_VALUE>
	<cfelse>
		<cfset toplam_tutar = 0>
	</cfif>
</cfoutput>
<table style="width:210mm">
    <tr>
        <td>
            <table width="100%">
                <tr>
                    <td valign="top">
                        <cfoutput query="CHECK">
                            <strong style="font-size:14px;">#company_name#</strong><br/>
                            #address#<br/>
                            <b><cf_get_lang dictionary_id='57499.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# <br/>
                            <b><cf_get_lang dictionary_id='57488.Fax'>: </b> #fax# <br/>
                            <b><cf_get_lang dictionary_id='58762.Vergi Dairesi'> : </b> #TAX_OFFICE# <b><cf_get_lang_main no='340.No'> : </b> #TAX_NO#<br/>
                            #web# - #email#
                        </cfoutput>
                        </td>
                </tr> 
                <tr class="row_border">
                    <td class="print-head">
                        <table style="width:100%;"> 
                            <tr>
                                <cfif len(get_action_detail.payroll_type)>
                                    <cfif get_action_detail.payroll_type eq 90>
                                        <b><cf_get_lang dictionary_id='57852.Çek Giriş Bordrosu'></b>
                                    <cfelseif get_action_detail.payroll_type eq 105>
                                        <b><cf_get_lang dictionary_id='57856.Çek İade Giriş Bordrosu'>-<cf_get_lang dictionary_id='57521.Banka'></b>
                                    </cfif>
                                </cfif>
                                <td style="text-align:right;">
                                    <cfif len(check.asset_file_name2)>
                                    <cfset attributes.type = 1>
                                    <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                                    </cfif>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table style="width:100%">
                            <cfoutput>
                                <tr>
                                    <td><cf_get_lang dictionary_id='33983.Bordro No'>:<strong>&nbsp#get_action_detail.PAYROLL_NO#</strong></td>
                                    <td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>:<strong>&nbsp#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</strong></td>
                                </tr>
                                <tr>
                                    <td height="40" colspan="3" class="text">
                                        <cfif len(get_action_detail.COMPANY_ID)>
                                            <strong>#get_par_info(get_action_detail.COMPANY_ID,1,1,0)#</strong>
                                        <cfelseif len (get_action_detail.employee_id)>
                                            <strong>#get_emp_info(get_action_detail.employee_id,0,0)#</strong>
                                        <cfelseif len(get_action_detail.consumer_id)>
                                            <strong>#get_cons_info(get_action_detail.consumer_id,0,0)#</strong>
                                        </cfif>
                                        <cf_get_lang dictionary_id='33216.cari hesabına mahsuben'>
                                        <cfset myNumber = toplam_tutar>
                                        <cf_n2txt number="myNumber" para_birimi="#get_cheque_detail.CURRENCY_ID#"><strong>#myNumber#</strong> <cf_get_lang dictionary_id='49842.Çek Alınmıştır'>.
                                    </td>
                                </tr>
                                <cfif isdefined("get_action_detail.project_id") and len(get_action_detail.project_id)>
                                    <tr>
                                        <td><strong><cf_get_lang_main no='4.Proje'></strong> &nbsp;:#get_project_name(get_action_detail.project_id)#</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </table>
                        <table  class="print_border"  style="width:180mm">
                            <tr class="txtbold">
                                <td><cf_get_lang dictionary_id='32745.Çek No'></td>
                                <td><cf_get_lang dictionary_id='58182.Portföy No'></td>
                                <td><cf_get_lang dictionary_id='57521.Banka'></td>
                                <td><cf_get_lang dictionary_id='57453.Şube'></td>
                                <td><cf_get_lang dictionary_id='58178.Hesap No'></td>
                                <td><cf_get_lang dictionary_id='57640.Vade'></td>
                                <td><cf_get_lang dictionary_id='57673.Tutar'></td>
                                <cfif get_cheque_detail.CURRENCY_ID neq session.ep.money or listlen(list_birim) neq 1>
                                    <td><cfoutput>#session.ep.money#</cfoutput> <cf_get_lang dictionary_id='57673.Tutar'></td>
                                </cfif>
                            </tr>
                            <cfoutput query="GET_CHEQUE_DETAIL">
                                <tr>
                                    <td>#CHEQUE_NO#</td>
                                    <td>#CHEQUE_PURSE_NO#</td>
                                    <td>#BANK_NAME#</td>
                                    <td>#BANK_BRANCH_NAME#</td>
                                    <td>#ACCOUNT_NO#</td>
                                    <td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
                                    <td>#TLFormat(CHEQUE_VALUE)# #CURRENCY_ID#</td>
                                    <cfif CURRENCY_ID neq session.ep.money>
                                        <td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
                                    </cfif>
                                </tr>
                            </cfoutput>
                        </table>
                    </td>
                </tr>
                <cfoutput>
                    <tr>
                        <td width="200" class="text-right">
                            <table border="0">
                                <tr>
                                    <td width="120"><b><cf_get_lang dictionary_id='58645.Nakit'>:</b></td>
                                    <td>&nbsp</td>
                                </tr>
                                <tr>
                                    <td width="120"><strong><cf_get_lang dictionary_id='33483.Tahsil Eden'></strong></td>
                                    <td>
                                        <cfif isdefined("get_action_detail.REVENUE_COLLECTOR_ID") and len(get_action_detail.REVENUE_COLLECTOR_ID)>
                                            #get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#
                                        </cfif>
                                    </td>
                                </tr>
                                <cfif listlen(list_birim) eq 1 and list_birim neq session.ep.money>
                                    <tr>
                                        <td width="120"><strong><cf_get_lang dictionary_id='57492.Toplam'> #get_cheque_detail.CURRENCY_ID#</strong></td>
                                        <td> #TLFormat(toplam_tutar)# #get_cheque_detail.CURRENCY_ID#</td>	 
                                    </tr>
                                </cfif>
                                <tr>
                                    <td><strong><cf_get_lang dictionary_id='57492.Toplam'> #session.ep.money#</strong></td>
                                    <td><cfif len(get_action_detail.PAYROLL_TOTAL_VALUE)> #TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #session.ep.money#</cfif></td> 
                                </tr>
                                <tr>
                                    <td width="120"><strong><cf_get_lang dictionary_id='33212.Toplam Çek Sayısı'></strong></td>
                                    <td><strong></strong>#GET_CHEQUE_HISTORY.KAYIT#</td>
                                </tr>
                                <tr>
                                    <td width="120"><strong><cf_get_lang dictionary_id='57861.Ortalama Vade'></strong></td>
                                    <td><strong></strong>#dateformat(get_action_detail.PAYROLL_AVG_DUEDATE,dateformat_style)#</td>
                                </tr>
                                <cfif GET_MONEY_RATE.MONEY_TYPE neq session.ep.money>
                                    <tr>
                                        <td width="120"><strong>#GET_MONEY_RATE.MONEY_TYPE# <cf_get_lang dictionary_id='57648.Kur'></strong></td>
                                        <td><strong></strong>#GET_MONEY_RATE.RATE1# / #TLFormat(GET_MONEY_RATE.RATE2,4)#</td>
                                    </tr>
                                </cfif>
                            </table>
                        </td>
                        <td style="align:right">
                            <table border="0">
                                
                            </table>
                        </td>
                    </tr>
                </cfoutput>
            </table>
        </td>
    </tr>
</table>
<br><br>
    <table>
        <tr class="fixed">
		    <td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
	    </tr>
    </table>
