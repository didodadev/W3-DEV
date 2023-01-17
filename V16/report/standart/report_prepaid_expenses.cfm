<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.invoice_startdate" default="">
<cfparam name="attributes.invoice_finishdate" default="">
<cfparam name="attributes.is_form_submit" default="0">
<cfparam name="attributes.is_excel" default="0">

<cfif len(attributes.startdate)>
    <cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate)>
    <cf_date tarih="attributes.finishdate">
</cfif>
<cfif len(attributes.finishdate)>
    <cf_date tarih="attributes.invoice_startdate">
</cfif>
<cfif len(attributes.finishdate)>
    <cf_date tarih="attributes.invoice_finishdate">
</cfif>

<cfquery name="get_account_id" datasource="#dsn2#">
    SELECT ACCOUNT_ID
    FROM ACCOUNT_CARD_ROWS
    WHERE ( ACCOUNT_ID LIKE '180%' OR ACCOUNT_ID LIKE '280%' ) 
    GROUP BY ACCOUNT_ID
    ORDER BY ACCOUNT_ID
</cfquery>

<cfif attributes.is_form_submit>
    <cfquery name="get_account_info" datasource="#dsn2#">

    SELECT ACTION_ID, COMP_ID FROM (
    
        SELECT 
            I.INVOICE_ID AS ACTION_ID,
            I.COMPANY_ID AS COMP_ID
        FROM 
            INVOICE AS I
		WHERE I.INVOICE_CAT IN (59,60,63)
		AND I.INVOICE_ID IN ( SELECT ACTION_ID FROM ACCOUNT_CARD_ROWS AS ACR JOIN ACCOUNT_CARD AS AC ON ACR.CARD_ID = AC.CARD_ID WHERE AC.ACTION_ID = I.INVOICE_ID AND I.INVOICE_CAT = AC.ACTION_TYPE and (ACR.ACCOUNT_ID LIKE '180%' OR ACR.ACCOUNT_ID LIKE '280%' ))
        <cfif len(attributes.invoice_startdate) and not len(attributes.invoice_finishdate)>
            AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_startdate#">
        <cfelseif len(attributes.invoice_finishdate) and not len(attributes.invoice_startdate)>
            AND I.INVOICE_DATE =< <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_startdate#">
        <cfelseif len(attributes.invoice_startdate) and len(attributes.invoice_finishdate)>
            AND (I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_finishdate#">)
        </cfif>
        <cfif len(attributes.startdate) and not len(attributes.finishdate)>
            AND I.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
        <cfelseif len(attributes.finishdate) and not len(attributes.startdate)>
            AND I.RECORD_DATE =< <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
        <cfelseif len(attributes.startdate) and len(attributes.finishdate)>
            AND (I.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
        </cfif>
        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
            AND I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfif>

        UNION ALL

        SELECT 
            EXPENSE_ID AS ACTION_ID,
            CH_COMPANY_ID AS COMP_ID
        FROM EXPENSE_ITEM_PLANS AS EIP
		WHERE EIP.EXPENSE_ID IN ( SELECT ACTION_ID FROM ACCOUNT_CARD_ROWS AS ACR JOIN ACCOUNT_CARD AS AC ON ACR.CARD_ID = AC.CARD_ID WHERE EIP.EXPENSE_ID = AC.ACTION_ID AND EIP.ACTION_TYPE = AC.ACTION_TYPE AND (ACR.ACCOUNT_ID LIKE '180%' OR ACR.ACCOUNT_ID LIKE '280%') )
		AND EIP.ACTION_TYPE = 120
        <cfif len(attributes.invoice_startdate) and not len(attributes.invoice_finishdate)>
            AND EIP.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_startdate#">
        <cfelseif len(attributes.invoice_finishdate) and not len(attributes.invoice_startdate)>
            AND EIP.EXPENSE_DATE =< <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_startdate#">
        <cfelseif len(attributes.invoice_startdate) and len(attributes.invoice_finishdate)>
            AND (EIP.EXPENSE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.invoice_finishdate#">)
        </cfif>
        <cfif len(attributes.startdate) and not len(attributes.finishdate)>
            AND EIP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
        <cfelseif len(attributes.finishdate) and not len(attributes.startdate)>
            AND EIP.RECORD_DATE =< <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
        <cfelseif len(attributes.startdate) and len(attributes.finishdate)>
            AND (EIP.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">)
        </cfif>
        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
            AND EIP.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfif>

    ) T1
    </cfquery>
<cfelse>
    <cfset get_account_info.recordcount = 0>
</cfif>

<cfset url_str = "">
<cfif attributes.is_form_submit>
	<cfset url_str = '#url_str#&is_form_submit=1'>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	  <cfset url_str = "#url_str#&company_id=#attributes.company_id#">
    </cfif>
	<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	  <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	  <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
    </cfif>
    <cfif isdefined("attributes.invoice_startdate") and len(attributes.invoice_startdate)>
        <cfset url_str = "#url_str#&invoice_startdate=#dateformat(attributes.invoice_startdate,dateformat_style)#">
      </cfif>
      <cfif isdefined("attributes.invoice_finishdate") and len(attributes.invoice_finishdate)>
        <cfset url_str = "#url_str#&invoice_finishdate=#dateformat(attributes.invoice_finishdate,dateformat_style)#">
      </cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_account_info.recordcount#">

<cf_report_list_search title="#getLang('','Peşin Ödenen Giderler Denetim Raporu',62248)#">
    <cf_report_list_search_area>
        <cfform name="prepaid_expenses" id="prepaid_expenses" method="post" action="#request.self#?fuseaction=report.report_prepaid_expenses">
			<div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
							<input name="is_form_submit" id="is_form_submit" value="1" type="hidden">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="company_id" id="company_id"  value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                            <input type="text" name="company" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','prepaid_expenses','3','250');" autocomplete="off" value="<cfif isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" >
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=prepaid_expenses.company&field_comp_id=prepaid_expenses.company_id&field_name=prepaid_expenses.company&field_consumer=prepaid_expenses.consumer_id&select_list=2,3&keyword='+encodeURIComponent(document.prepaid_expenses.company.value),'list');"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='33203.Belge Tarihi'></label>
                                    <div class="col col-6">
                                        <div class="input-group">
                                            <cfinput type="text" name="invoice_startdate" id="invoice_startdate" value="#dateformat(attributes.invoice_startdate,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="invoice_startdate"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6">
                                        <div class="input-group">
                                            <cfinput type="text" name="invoice_finishdate" id="invoice_finishdate" value="#dateformat(attributes.invoice_finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="invoice_finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col  col-12 col-xs-12"><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></label>
                                    <div class="col col-6">
                                        <div class="input-group">
                                            <cfinput type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6">
                                        <div class="input-group">
                                            <cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
					</div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" style="width:20px;" maxlength="3">
                            <cf_wrk_report_search_button button_type="1" search_function='kontrol()'>
                        </div>
                    </div>
				</div>
			</div>
		</cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

<cfif attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>

<cfif attributes.is_excel eq 1>
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows = get_account_info.recordcount>
</cfif>

<cf_report_list>
    <thead>				
        <tr> 
            <th width="30"><cf_get_lang dictionary_id='36250.Sıra'></th>
            <th><cf_get_lang dictionary_id="57519.Cari Hesap"></th>
            <th><cf_get_lang dictionary_id="58133.Fatura No"></th>
            <th><cf_get_lang dictionary_id="30631.Tarih"></th>
            <cfoutput query="get_account_id">
                <th>#ACCOUNT_ID#</th>
            </cfoutput>
        </tr>
    </thead>
    <tbody>
        <cfif attributes.is_form_submit eq 1 and get_account_info.recordcount>
            <cfoutput query="get_account_info" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfquery name="get_acc_info2" datasource="#dsn2#">
                    SELECT C.FULLNAME, AC.ACTION_DATE, AC.ACTION_ID, AC.PAPER_NO, AC.ACTION_TYPE, ACR.ACCOUNT_ID, ACR.AMOUNT, ACR.CARD_ID FROM ACCOUNT_CARD AS AC
                    JOIN ACCOUNT_CARD_ROWS AS ACR ON AC.CARD_ID = ACR.CARD_ID
                    LEFT JOIN #dsn#.COMPANY AS C on C.COMPANY_ID = #get_account_info.COMP_ID#
                    WHERE AC.ACTION_ID = #get_account_info.ACTION_ID# AND (ACR.ACCOUNT_ID LIKE '180%' OR ACR.ACCOUNT_ID LIKE '280%')
                    ORDER BY ACCOUNT_ID
                </cfquery>
                <tr>
                    <td>#currentrow#</td>
                    <td>#get_acc_info2.FULLNAME#</td>
                    <td>
                        <cfif listfind("59,60,63",get_acc_info2.ACTION_TYPE,",")>
                            <cfif attributes.is_excel eq 0>
                                <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#get_acc_info2.ACTION_ID#" target="_blank">#get_acc_info2.paper_no#</a>
                            <cfelse>
                                #get_acc_info2.paper_no#
                            </cfif>
                        <cfelseif listfind("120",get_acc_info2.ACTION_TYPE,",")>
                            <cfif attributes.is_excel eq 0>
                                <a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#get_acc_info2.ACTION_ID#" target="_blank">#get_acc_info2.paper_no#</a>
                            <cfelse>
                                #get_acc_info2.paper_no#
                            </cfif>
                        <cfelse>
                            #get_acc_info2.paper_no#
                        </cfif>
                    </td>
                    <td>#dateformat(get_acc_info2.ACTION_DATE,dateformat_style)#</td>
                    <cfloop query="get_account_id">
                        <cfset total = 0.0>
                        <td class="text-right">
                            <cfloop query="get_acc_info2">
                                <cfif get_account_id.ACCOUNT_ID eq get_acc_info2.ACCOUNT_ID>
                                    <cfset total += get_acc_info2.AMOUNT>
                                </cfif>
                            </cfloop>
                            #(total gt 0) ? TLFormat(total) : "" #
                        </td>
                    </cfloop>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="14"><cfif attributes.is_form_submit><cf_get_lang dictionary_id='57484.kayıt yok'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</td>
            </tr>
        </cfif>
    </tbody>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
            <tr>
                <td> 
                <cfif attributes.is_excel eq 0>
                <cf_pages 
                    page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="report.report_prepaid_expenses#url_str#">
                </td>
                </cfif>
                <!-- sil --><td class="text-right"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
              </tr>
        </table>
    </cfif>
</cf_report_list>

<script>
    function kontrol(){
        if( $("#is_excel").is(':checked') ){
            $('#prepaid_expenses').attr('action', '<cfoutput>#request.self#</cfoutput>?fuseaction=report.emptypopup_report_prepaid_expenses');
        }else{
            $('#prepaid_expenses').attr('action', '<cfoutput>#request.self#</cfoutput>?fuseaction=report.report_prepaid_expenses');
            return true;
        }
    }
</script>