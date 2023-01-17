<!---
Author: Pınar Yıldız
Date: 2020-06-03
Description:
Sağlık harcama taleplerinin muhasebe bilgisi ile listelenmesi için kullanılır
--->
<cf_xml_page_edit fuseact="hr.health_expense_approve">
<cfif (not isDefined("x_rnd_nmbr")) or (isDefined("x_rnd_nmbr") and not len(x_rnd_nmbr))>
    <cfset x_rnd_nmbr = 2>
</cfif>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
    <cfset attributes.maxrows = session.ep.maxrows />
</cfif>
<cfparam name="attributes.page" default="1" />
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.sub_accounts" default="0">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.search_date1" default="" />
<cfparam name="attributes.search_date2" default="" />
<cfparam name="attributes.sortType" default="">
<cfparam name="attributes.box_submitted" default="" />
<cfparam name="attributes.is_account" default="" />
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 />
<cfparam name="health_id" default="" />
<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
    <cf_date tarih = "attributes.search_date1">
</cfif>
<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
    <cf_date tarih = "attributes.search_date2">
</cfif>
<cfset HealthExpense    = createObject("component","V16.report.cfc.health_expense") />
<cfset GET_EXPENSE = HealthExpense.GET_EXPENSE_LIST(
        search_date1 :'#iif(isdefined("attributes.search_date1") and len(attributes.search_date1),"attributes.search_date1",DE(""))#',
        search_date2 :'#iif(isdefined("attributes.search_date2") and len(attributes.search_date2),"attributes.search_date2",DE(""))#',
        acc_code1_1 :'#iif(isdefined("attributes.acc_code1_1") and len(attributes.acc_code1_1),"attributes.acc_code1_1",DE(""))#',
        acc_code2_1 :'#iif(isdefined("attributes.acc_code2_1") and len(attributes.acc_code2_1),"attributes.acc_code2_1",DE(""))#',
        startrow :'#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
        maxrows :'#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
        module_name: fusebox.circuit,
        is_account : '#iif(isdefined("attributes.is_account") and len(attributes.is_account),"attributes.is_account",DE(""))#',
        is_excel : '#iif(isdefined("attributes.is_excel") and len(attributes.is_excel),"attributes.is_excel",DE(""))#'
    ) />
<cfset get_assurance    = HealthExpense.GetAssurance() />
<cfparam name="attributes.totalrecords" default='#GET_EXPENSE.query_count#' />
<cfif isDefined("attributes.create_excel") and attributes.create_excel eq 1>
    <cfinclude template="health_expense_excel.cfm">
</cfif>
<cfset adres="report.health_expense" />
<cfif len(attributes.search_date1)>
    <cfset adres = "#adres#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#">
</cfif>
<cfif len(attributes.search_date2)>
    <cfset adres = "#adres#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#">
</cfif>
<cfif len(attributes.acc_code1_1)>
    <cfset adres = "#adres#&acc_code1_1=#attributes.acc_code1_1#">
</cfif>
<cfif len(attributes.acc_code2_1)>
    <cfset adres = "#adres#&acc_code2_1=#attributes.acc_code2_1#">
</cfif>
<cfif len(attributes.is_account)>
    <cfset adres = "#adres#&is_account=#attributes.is_account#">
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="33706.Sağlık Harcaması"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="health_expense_approve" method="post" action="">
        <cf_box id="list_health_expense_search"  scroll="0">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></cfsavecontent>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-0 padding-right-5">
                        <div class="input-group">
                            <cfinput type="text" name="acc_code1_1" value="#attributes.acc_code1_1#" maxlength="255" onFocus="AutoComplete_Create('acc_code1_1','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');" placeholder="#message#">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=health_expense_approve.acc_code1_1&keyword='+encodeURIComponent(health_expense_approve.acc_code1_1.value),'list');"></span>
                            <cfoutput>
                        </div>	
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-0">
                        <div class="input-group">		
                            <cfinput type="text" name="acc_code2_1" value="#attributes.acc_code2_1#" maxlength="255" onFocus="AutoComplete_Create('acc_code2_1','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');"  placeholder="#message#">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=health_expense_approve.acc_code2_1&keyword='+encodeURIComponent(health_expense_approve.acc_code2_1.value),'list');"></span>
                            </cfoutput> 
                        </div>	
                    </div>
                </div>
                    <div class="form-group" id="item-search_date">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="60928.Belge Başlangıç Tarihi"></cfsavecontent>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-0  padding-right-5">
                        <div class="input-group">
                            <cfsavecontent variable="txt1"><cf_get_lang dictionary_id="57782.Tarih Değerini Kontrol Ediniz">!</cfsavecontent>
                            <cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#"  placeholder="#message#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date1"></span>
                        </div>
                    </div>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="60929.Belge Bitiş Tarihi"></cfsavecontent>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12 padding-0">
                        <div class="input-group">
                            <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2, dateformat_style)#" validate="#validate_style#" maxlength="10" message="#txt1#" placeholder="#message#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date2"></span> 
                        </div>
                    </div>
                </div>
                    <div class="form-group">
                    <select name="is_account" id="is_Account">
                        <option><cf_get_lang dictionary_id='64649.Muhasebeleşme'></option>
                        <option value="1" <cfif attributes.is_account is 1>selected="selected"</cfif>><cf_get_lang dictionary_id='64647.Muhasebeleşenler'></option>
                        <option value="0" <cfif attributes.is_account is 0>selected="selected"</cfif>><cf_get_lang dictionary_id='64648.Muhasebeleşmeyenler'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
            </cf_box_search>
        </cf_box>
    </cfform>
</div>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>	
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="setProcessForm" id="setProcessForm" method="post" action="">
     <cf_box id="list_health_expense_list" title="#title#" hide_table_column="1">
            <cfif not isDefined("attributes.wrkflow")>
                <input type="hidden" name="box_submitted" id="box_submitted" value="1">
            </cfif>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="50"><cf_get_lang dictionary_id='57880.Belge No'></th>
                        <th width="50"><cf_get_lang dictionary_id='32328.Sicil No'></th>
                        <th><cf_get_lang dictionary_id="57576.Çalışan"></th>
                        <th><cf_get_lang dictionary_id='31277.Yakınlık Derecesi'></th>
                        <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                        <th><cf_get_lang dictionary_id='41542.Anlaşmalı'>-<cf_get_lang dictionary_id='60922.Anlaşmasız'></th>
                        <th class="moneybox"><cf_get_lang dictionary_id="41154.Kurum Payı"> (<cf_get_lang dictionary_id='37345.TL'>)</th>
                        <th><cf_get_lang dictionary_id='60923.Muhasebeleşme Durumu'></th>
                        <th><cf_get_lang dictionary_id='60924.Mahsup Fiş Tarihi'></th>
                        <th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
                        <th class="moneybox"><cf_get_lang dictionary_id='60925.Muhasebeleşen Tutar'></th>
						<th><cf_get_lang dictionary_id='59088.Tip'></th>
						<!--- <th><cf_get_lang dictionary_id='32191.Kesinti'> Muhasebe Kodu</th>
                        <th><cf_get_lang dictionary_id='32191.Kesinti'></th> --->
                        <th><cf_get_lang dictionary_id='33214.Kdv Tutarı'></th>
                        <th><cf_get_lang dictionary_id="41154.Kurum Payı">-<cf_get_lang dictionary_id='33214.Kdv Tutarı'></th>
                    </tr>
                </thead>
                <cfif GET_EXPENSE.recordcount>
                    <tbody>
                        <cfoutput query="GET_EXPENSE">
                                <cfset health_id = expense>
                                <tr>
                                    <cfset relative_name = '' />
                                    <td><cfif type_ eq 0><a href="#request.self#?fuseaction=hr.health_expense_approve&event=upd&health_id=#health_id#">&nbsp;#paper_no#</a><cfelse>&nbsp;#paper_no#</cfif></td>
                                    <td>#EMPLOYEE_NO#</td>
                                    <td><cfif type_ eq 0>#get_emp_info(EMP_ID, 0, 1)#<cfelse>#get_emp_info(EMP_ID, 0, 0)#</cfif></td> 
                                    <cfif Len(RELATIVE_ID) and len(RELATIVE_LEVEL)>
                                        <cfswitch expression="#RELATIVE_LEVEL#">
                                            <cfcase value="1">
                                                <cfset relative_name = 'Babası' />
                                            </cfcase>
                                            <cfcase value="2">
                                                <cfset relative_name = 'Annesi' />
                                            </cfcase>
                                            <cfcase value="3">
                                                <cfset relative_name = 'Eşi' />
                                            </cfcase>
                                            <cfcase value="4">
                                                <cfset relative_name = 'Oğlu' />
                                            </cfcase>
                                            <cfcase value="5">
                                                <cfset relative_name = 'Kızı' />
                                            </cfcase>
                                            <cfcase value="6">
                                                <cfset relative_name = 'Kardeşi' />
                                            </cfcase>
                                        </cfswitch>
                                        <td>#relative_name#</td>
                                    <cfelse>
                                        <td><cf_get_lang dictionary_id="40429.kendisi"></td>
                                    </cfif>
                                    <td><cfif len(SYSTEM_RELATION)>#SYSTEM_RELATION#<cfelse>#INVOICE_NO#</cfif></td>
                                    <td><cfif len(company_id)><cf_get_lang dictionary_id='41542.Anlaşmalı'><cfelse><cf_get_lang dictionary_id='60922.Anlaşmasız'></cfif></td>
                                    <td class="moneybox">#TLFormat(OUR_COMPANY_HEALTH_AMOUNT,x_rnd_nmbr)#</td>
                                    <td><cfif len(card_id)><cf_get_lang dictionary_id='60926.Muhasebeleşti'><cfelse><cf_get_lang dictionary_id='60927.Muhasebeleşmedi'></cfif></td> 
                                    <td>#dateformat(ACTION_DATE,'dd/mm/yyyy')#</td>
                                    <td>#account_id#</td>
                                    <td class="moneybox">#tlformat(amount,x_rnd_nmbr)#</td>
									<td>
										<cfquery name="get_AMOUNTS" datasource="#dsn#">
                                           SELECT AMOUNT_GET FROM SALARYPARAM_GET WHERE EXPENSE_HEALTH_ID = #GET_EXPENSE.EXPENSE#
                                        </cfquery>
										<cfif get_AMOUNTS.recordcount and treated eq 2 AND ACCOUNT_ID EQ '770.01.04.0003'>
											KESİNTİ
										<CFELSE>
											YAPILAN ÖDEME
										</cfif>
									</td>
									<!---
									<td style="text-align:center"> 
										770.01.04.0003
									</td>
                                    <td class="moneybox">
									<!--- #S_GET#--->
										<cfquery name="get_AMOUNTS" datasource="#dsn#">
                                           SELECT AMOUNT_GET FROM SALARYPARAM_GET WHERE EXPENSE_HEALTH_ID = #GET_EXPENSE.EXPENSE#
                                        </cfquery>
										<cfif get_AMOUNTS.recordcount>
											#tlformat(get_AMOUNTS.AMOUNT_GET,x_rnd_nmbr)#
										</cfif>
									</td>
									---->
                                    <td>
                                       <!--- <cfquery name="get_kdvs" dbtype="query">
                                            SELECT AMOUNT_KDV_1, AMOUNT_KDV_2, AMOUNT_KDV_3, AMOUNT_KDV_4 FROM GET_EXPENSE_LIST WHERE EXPENSE_ID = #EXPENSE#
                                        </cfquery> --->
										<cfif treated eq 2> <!--- Çalışan Yakını ---->
											#tlformat(0)#
											<cfset CALC_AMOUNT = 0 >
										<cfelse><!--- Kendisi ---->
											<cfif not len(company_id)>
												<cfset corparate_health_amount = (NET_TOTAL_AMOUNT - (employee_health_amount + PAYMENT_INTERRUPTION_VALUE))>
												<cfscript>
													calc_amount = 0;
													attributes.kdv_1 = 8;
													attributes.kdv_2 = 18;
													attributes.kdv_3 = 1;
													attributes.kdv_4 = 0;
													for(kdv=1; kdv<=4 ;kdv++){
														if(evaluate('amount_kdv_#kdv#') neq 0){
															kdv_amaunt = evaluate('amount_kdv_#kdv#');// KDV'li tutar
															kdv_val = evaluate('attributes.kdv_#kdv#');//KDV oranı
															amount_without_kdv = evaluate('amount_#kdv#'); //Tutar
															//KDV oranlarına göre indirilecek KDV Hesabı
															/*writeoutput('amount_without_kdv:#amount_without_kdv#<br>');
															writeoutput('kdv_val:#kdv_val#<br>');
															writeoutput('corparate_health_amount:#corparate_health_amount#<br>');
															writeoutput(NET_TOTAL_AMOUNT);*/
															calc_amount = calc_amount + (amount_without_kdv * kdv_val / 100) * (corparate_health_amount / NET_TOTAL_AMOUNT);
														   
														}
													}
													writeoutput(tlformat(calc_amount,x_rnd_nmbr));
												</cfscript>
											<cfelse>
													<CFSET CALC_AMOUNT = net_kdv_amount neq '' ? net_kdv_amount : 0>
													#tlformat(CALC_AMOUNT,x_rnd_nmbr)#
											</cfif>
										</cfif>
                                    </td>
                                    <td>#Tlformat(OUR_COMPANY_HEALTH_AMOUNT-CALC_AMOUNT,x_rnd_nmbr)#</td>
                                </tr>
                        </cfoutput>
                    </tbody>
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="19"><cf_get_lang dictionary_id ="57484. kayıt yok"></td>
                        </tr>
                    </tbody>
                </cfif>
            </cf_grid_list>
            <cf_paging
                name="setProcessForm"
                page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#"
                is_form="1">
      </cf_box>
    </cfform>
</div>
<script type="text/javascript">
    function kontrol()
    {
        if(document.getElementById('search_date1').value != '' && document.getElementById('search_date2').value != ''){
            if(!date_check (document.getElementById('search_date1'),document.getElementById('search_date2'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!")){
                document.getElementById('search_date1').focus();
                return false;
            }
        }
        if($("#is_excel").prop('checked') == false)
		{
            $('#health_expense_approve').attr('action', '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>');
		}
		else{
           
            $('#health_expense_approve').attr('action', '<cfoutput>#request.self#?fuseaction=report.emptypopup_health_expense</cfoutput>');

        }
        return true;
    }
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
