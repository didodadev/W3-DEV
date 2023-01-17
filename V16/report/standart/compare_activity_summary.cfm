<!--- GET_ACTIVITY_SUMMARY viewini(işlem tiplerine göre cari hareketleri gruplar) kullanarak 
aylık,günlük,3 aylık bazlarda gruplanmış işlem tiplerine göre cari işlem tutarları getirir...Ayşenur20070328--->
<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id ='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id ='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id ='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id ='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id ='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id ='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id ='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id ='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id ='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id ='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id ='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id ='57603.Aralık'></cfsavecontent>
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfset type_index = 'GET_PURCHASES,GET_SALES_RETURN1,GET_PURCHASE_DIFF,GET_PURCHASE_RETURN,GET_EXPENSE,ALIS_TOPLAM,GET_SALES,GET_PURCHASE_RETURN1,GET_SALES_DIFF,GET_SALES_RETURN,GET_INCOME,SATIS_TOPLAM,GET_CASH,GET_CHEQUE,GET_CHEQUE_RETURN,GET_CHEQUE_P_RETURN,GET_VOUCHER,GET_VOUCHER_RETURN,GET_VOUCHER_P_RETURN,GET_REVENUE,GET_CREDIT_REVENUE,TAHSILAT_TOPLAM,GET_PAYM,GET_CHEQUE_P,GET_CHEQUE_P_RETURN1,GET_CHEQUE_RETURN1,GET_VOUCHER_P,GET_VOUCHER_P_RETURN1,GET_VOUCHER_RETURN1,GET_PAYMENTS,GET_CREDIT_PAYMENTS,ODEME_TOPLAM'>
<cfset month_first_element = 0>
<cfset month_last_element = 0>
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.time_type" default="">
<cfparam name="attributes.period_type" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id ='39593.Karşılaştırmalı Cari Faaliyet Özeti'></cfsavecontent>
    <cf_box>
        <cfform name="form_report" action="#request.self#?fuseaction=report.compare_activity_summary" method="post">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                        <cf_wrk_members form_name='form_report' company_id='company_id' consumer_id='consumer_id' member_name='company' select_list='2,3'>
                        <input type="text" placeHolder="<cf_get_lang dictionary_id ='57519.Cari Hesap'>" name="company" id="company" onkeyup="get_member();" value="<cfif isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_member_name=form_report.company&field_name=form_report.company&field_comp_id=form_report.company_id&field_consumer=form_report.consumer_id&select_list=2,3</cfoutput>&keyword='+encodeURIComponent(document.form_report.company.value),'list')"></span> 
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                        <cf_wrk_projects project_id='project_id' project_name='project_head' form_name='form_report'>
                        <input type="text" name="project_head" id="project_head" onkeyup="get_project_1();" placeHolder="<cf_get_lang dictionary_id ='57416.Proje'>" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');">
                        <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_report.project_id&project_head=form_report.project_head');"></span> 
                    </div>                   
                </div>
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id ='57453.Şube'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#" <cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
               <!---  <td><cf_get_lang dictionary_id='58690.Tarih Aralığı'> *</td> --->
                <div class="form-group">
                    <select name="startdate" id="startdate">
                        <option value="1" <cfif attributes.startdate eq 1>selected</cfif>><cf_get_lang dictionary_id ='57592.Ocak'></option>
                        <option value="2" <cfif attributes.startdate eq 2>selected</cfif>><cf_get_lang dictionary_id ='57593.Şubat'></option>
                        <option value="3" <cfif attributes.startdate eq 3>selected</cfif>><cf_get_lang dictionary_id ='57594.Mart'></option>
                        <option value="4" <cfif attributes.startdate eq 4>selected</cfif>><cf_get_lang dictionary_id ='57595.Nisan'></option>
                        <option value="5" <cfif attributes.startdate eq 5>selected</cfif>><cf_get_lang dictionary_id ='57596.Mayıs'></option>
                        <option value="6" <cfif attributes.startdate eq 6>selected</cfif>><cf_get_lang dictionary_id ='57597.Haziran'></option>
                        <option value="7" <cfif attributes.startdate eq 7>selected</cfif>><cf_get_lang dictionary_id ='57598.Temmuz'></option>
                        <option value="8" <cfif attributes.startdate eq 8>selected</cfif>><cf_get_lang dictionary_id ='57599.Ağustos'></option>
                        <option value="9" <cfif attributes.startdate eq 9>selected</cfif>><cf_get_lang dictionary_id ='57600.Eylül'></option>
                        <option value="10" <cfif attributes.startdate eq 10>selected</cfif>><cf_get_lang dictionary_id ='57601.Ekim'></option>
                        <option value="11" <cfif attributes.startdate eq 11>selected</cfif>><cf_get_lang dictionary_id ='57602.Kasım'></option>
                        <option value="12" <cfif attributes.startdate eq 12>selected</cfif>><cf_get_lang dictionary_id ='57603.Aralık'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="finishdate" id="finishdate"  <cfif attributes.time_type eq 1>disabled</cfif>>
                        <option value="1" <cfif attributes.finishdate eq 1>selected</cfif>><cf_get_lang dictionary_id ='57592.Ocak'></option>
                        <option value="2" <cfif attributes.finishdate eq 2>selected</cfif>><cf_get_lang dictionary_id ='57593.Şubat'></option>
                        <option value="3" <cfif attributes.finishdate eq 3>selected</cfif>><cf_get_lang dictionary_id ='57594.Mart'></option>
                        <option value="4" <cfif attributes.finishdate eq 4>selected</cfif>><cf_get_lang dictionary_id ='57595.Nisan'></option>
                        <option value="5" <cfif attributes.finishdate eq 5>selected</cfif>><cf_get_lang dictionary_id ='57596.Mayıs'></option>
                        <option value="6" <cfif attributes.finishdate eq 6>selected</cfif>><cf_get_lang dictionary_id ='57597.Haziran'></option>
                        <option value="7" <cfif attributes.finishdate eq 7>selected</cfif>><cf_get_lang dictionary_id ='57598.Temmuz'></option>
                        <option value="8" <cfif attributes.finishdate eq 8>selected</cfif>><cf_get_lang dictionary_id ='57599.Ağustos'></option>
                        <option value="9" <cfif attributes.finishdate eq 9>selected</cfif>><cf_get_lang dictionary_id ='57600.Eylül'></option>
                        <option value="10" <cfif attributes.finishdate eq 10>selected</cfif>><cf_get_lang dictionary_id ='57601.Ekim'></option>
                        <option value="11" <cfif attributes.finishdate eq 11>selected</cfif>><cf_get_lang dictionary_id ='57602.Kasım'></option>
                        <option value="12" <cfif attributes.finishdate eq 12>selected</cfif>><cf_get_lang dictionary_id ='57603.Aralık'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="time_type" id="time_type" onchange="change_month();">
                        <option value=""><cf_get_lang dictionary_id ='57497.Zaman Dilimi'></option>
                        <option value="1" <cfif attributes.time_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
                        <option value="3" <cfif attributes.time_type eq 3>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
                        <option value="4" <cfif attributes.time_type eq 4>selected</cfif>>3<cf_get_lang dictionary_id='58724.Ay'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button is_excel='0' search_function='control()' button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box  title="#head#" uidrop="1" hide_table_column="1">
            <cfif attributes.time_type eq 1><!--- gün bazında --->
                <cfset tarih_farki = DaysInMonth(CreateDate(session.ep.period_year,attributes.startdate,1))>
            <cfelseif listfind('3,4',attributes.time_type)><!--- ay --->
                <cfset tarih_farki = (attributes.finishdate-attributes.startdate)>
            </cfif>
            <cfif len(attributes.is_submitted)>
                <cfset month_list = ''>
                <cfif listfind('3,4',attributes.time_type)><!--- ay --->
                    <cfloop from="#attributes.startdate#" to="#attributes.startdate+tarih_farki#" index="i">
                        <cfset month_list=listappend(month_list,i)>
                    </cfloop>
                <cfelseif attributes.time_type eq 1><!--- gün bazında --->
                    <cfloop from="1" to="#tarih_farki#" index="gg">
                        <cfset month_list=listappend(month_list,gg)>
                    </cfloop>
                </cfif>
                <cfquery name="GET_ACTIVITY_SUMMARY" datasource="#dsn2#">
                    SELECT
                        SUM(GET_PURCHASES) AS GET_PURCHASES,
                        SUM(GET_PURCHASES2) AS GET_PURCHASES2,
                        SUM(GET_PURCHASE_DIFF) AS GET_PURCHASE_DIFF,
                        SUM(GET_PURCHASE_DIFF2) AS GET_PURCHASE_DIFF2,
                        SUM(GET_PURCHASE_RETURN) GET_PURCHASE_RETURN,
                        SUM(GET_PURCHASE_RETURN2) GET_PURCHASE_RETURN2,
                        SUM(GET_PURCHASE_RETURN) GET_PURCHASE_RETURN1,<!--- Alış iadeleri satış toplama eklemek için tekrar çektim --->
                        SUM(GET_PURCHASE_RETURN2) GET_PURCHASE_RETURN12,
                        SUM(GET_EXPENSE) GET_EXPENSE,
                        SUM(GET_EXPENSE2) GET_EXPENSE2,
                        0 ALIS_TOPLAM,<!--- Alış alt toplamlarını almak için eklendi bu alanlar --->
                        0 ALIS_TOPLAM2,<!--- Alış alt toplamlarını almak için eklendi bu alanlar --->
                        SUM(GET_SALES) GET_SALES,
                        SUM(GET_SALES2) GET_SALES2,
                        SUM(GET_SALES_DIFF) GET_SALES_DIFF,
                        SUM(GET_SALES_DIFF2) GET_SALES_DIFF2,
                        SUM(GET_SALES_RETURN) GET_SALES_RETURN,
                        SUM(GET_SALES_RETURN2) GET_SALES_RETURN2,
                        SUM(GET_SALES_RETURN) GET_SALES_RETURN1,<!--- Satış iadeleri alış toplama eklemek için tekrar çektim --->
                        SUM(GET_SALES_RETURN2) GET_SALES_RETURN12,
                        SUM(GET_INCOME) GET_INCOME,
                        SUM(GET_INCOME2) GET_INCOME2,
                        0 SATIS_TOPLAM,<!--- Satış alt toplamlarını almak için eklendi bu alanlar --->
                        0 SATIS_TOPLAM2,<!--- Satış alt toplamlarını almak için eklendi bu alanlar --->
                        SUM(GET_CASH) GET_CASH,
                        SUM(GET_CASH2) GET_CASH2,
                        SUM(GET_CHEQUE) GET_CHEQUE,
                        SUM(GET_CHEQUE2)GET_CHEQUE2,
                        SUM(GET_CHEQUE_RETURN) GET_CHEQUE_RETURN,
                        SUM(GET_CHEQUE2_RETURN)GET_CHEQUE_RETURN2,
                        SUM(GET_CHEQUE_RETURN) GET_CHEQUE_RETURN1,
                        SUM(GET_CHEQUE2_RETURN)GET_CHEQUE_RETURN12,
                        SUM(GET_VOUCHER) GET_VOUCHER,
                        SUM(GET_VOUCHER2)GET_VOUCHER2,
                        SUM(GET_VOUCHER_RETURN) GET_VOUCHER_RETURN,
                        SUM(GET_VOUCHER2_RETURN)GET_VOUCHER_RETURN2,
                        SUM(GET_VOUCHER_RETURN) GET_VOUCHER_RETURN1,
                        SUM(GET_VOUCHER2_RETURN)GET_VOUCHER_RETURN12,
                        SUM(GET_REVENUE) GET_REVENUE,
                        SUM(GET_REVENUE2)GET_REVENUE2,
                        SUM(GET_CREDIT_REVENUE) GET_CREDIT_REVENUE,
                        SUM(GET_CREDIT_REVENUE2)GET_CREDIT_REVENUE2,
                        0 TAHSILAT_TOPLAM,<!--- Tahsilat alt toplamlarını almak için eklendi bu alanlar --->
                        0 TAHSILAT_TOPLAM2,<!--- Tahsilat alt toplamlarını almak için eklendi bu alanlar --->
                        SUM(GET_PAYM) GET_PAYM,
                        SUM(GET_PAYM2)GET_PAYM2,
                        SUM(GET_CHEQUE_P) GET_CHEQUE_P,
                        SUM(GET_CHEQUE_P2) GET_CHEQUE_P2,
                        SUM(GET_CHEQUE_P_RETURN) GET_CHEQUE_P_RETURN,
                        SUM(GET_CHEQUE_P2_RETURN) GET_CHEQUE_P_RETURN2,
                        SUM(GET_CHEQUE_P_RETURN) GET_CHEQUE_P_RETURN1,
                        SUM(GET_CHEQUE_P2_RETURN) GET_CHEQUE_P_RETURN12,
                        SUM(GET_VOUCHER_P) GET_VOUCHER_P,
                        SUM(GET_VOUCHER_P2) GET_VOUCHER_P2,
                        SUM(GET_VOUCHER_P_RETURN) GET_VOUCHER_P_RETURN,
                        SUM(GET_VOUCHER_P2_RETURN) GET_VOUCHER_P_RETURN2,
                        SUM(GET_VOUCHER_P_RETURN) GET_VOUCHER_P_RETURN1,
                        SUM(GET_VOUCHER_P2_RETURN) GET_VOUCHER_P_RETURN12,
                        SUM(GET_PAYMENTS) GET_PAYMENTS,
                        SUM(GET_PAYMENTS2) GET_PAYMENTS2,
                        SUM(GET_CREDIT_PAYMENTS) GET_CREDIT_PAYMENTS,
                        SUM(GET_CREDIT_PAYMENTS2) GET_CREDIT_PAYMENTS2,
                        0 ODEME_TOPLAM,<!--- Ödeme alt toplamlarını almak için eklendi bu alanlar --->
                        0 ODEME_TOPLAM2,<!--- Ödeme alt toplamlarını almak için eklendi bu alanlar --->
                    <cfif listfind('3,4',attributes.time_type)>
                        DATEPART(MM,ACTION_DATE) AY
                    <cfelseif attributes.time_type eq 1>
                        DATEPART(DD,ACTION_DATE) AY
                    </cfif>
                    FROM
                    <cfif len(attributes.company_id) and len(attributes.company)>
                        ACTIVITY_SUMMARY_DAILY_FOR_COMPANY
                    <cfelseif len(attributes.consumer_id) and len(attributes.company)>
                        ACTIVITY_SUMMARY_DAILY_FOR_CONSUMER
                    <cfelse>
                        ACTIVITY_SUMMARY_DAILY
                    </cfif>
                    WHERE
                    <cfif len(attributes.company_id) and len(attributes.company)>
                        COMPANY_ID = #attributes.company_id# AND
                    <cfelseif len(attributes.consumer_id) and len(attributes.company)>
                        CONSUMER_ID = #attributes.consumer_id# AND
                    </cfif>
                    <cfif len(attributes.project_id) and len(attributes.project_head)>
                        PROJECT_ID = #attributes.project_id# AND
                    </cfif>
                    <cfif len(attributes.branch_id)>
                        (TO_BRANCH_ID = #attributes.branch_id# OR FROM_BRANCH_ID = #attributes.branch_id#) AND
                    </cfif>
                    <cfif listfind('3,4',attributes.time_type)>
                        MONTH(ACTION_DATE) >= #attributes.startdate# AND 
                        MONTH(ACTION_DATE) < #attributes.finishdate+1#
                    <cfelseif attributes.time_type eq 1>
                        MONTH(ACTION_DATE) = #attributes.startdate#
                    </cfif>
                    GROUP BY
                    <cfif listfind('3,4',attributes.time_type)>
                        DATEPART(MM,ACTION_DATE)
                    <cfelseif attributes.time_type eq 1>
                        DATEPART(DD,ACTION_DATE)
                    </cfif>
                </cfquery>
                <cfloop list="#month_list#" index="month_index">
                    <cfoutput query="GET_ACTIVITY_SUMMARY">
                        <cfif (AY eq month_index)>
                            <cfloop list="#type_index#" index="tt_index">
                                <cfset 'alan_#tt_index#_#month_index#' = evaluate(tt_index)>
                                <cfset 'alan_2_#tt_index#_#month_index#' = evaluate('#tt_index#2')>
                            </cfloop>
                        </cfif>
                    </cfoutput>
                </cfloop>
                <cfif attributes.time_type eq 4>				
                    <cfset mont_count=0>
                    <cfset mont_part_count=1>
                    <cfset mont_part_value =0>
                    <cfloop list="#month_list#" index="month_list_index">					
                        <cfset mont_count=mont_count+1>
                        <cfloop list="#type_index#" index="index_type">
                            <cfif isdefined('alan_#index_type#_#month_list_index#') and len(evaluate('alan_#index_type#_#month_list_index#'))>
                                <cfif isdefined('mont_part_value_#index_type#_#mont_part_count#') and len(evaluate('mont_part_value_#index_type#_#mont_part_count#'))>
                                    <cfset 'mont_part_value_#index_type#_#mont_part_count#' = evaluate('mont_part_value_#index_type#_#mont_part_count#') + evaluate('alan_#index_type#_#month_list_index#')>
                                <cfelse>
                                    <cfset 'mont_part_value_#index_type#_#mont_part_count#' = evaluate('alan_#index_type#_#month_list_index#')>
                                </cfif>
                            </cfif>
                            <cfif isdefined('alan_2_#index_type#_#month_list_index#') and len(evaluate('alan_2_#index_type#_#month_list_index#'))>
                                <cfif isdefined('mont_part_value2_#index_type#_#mont_part_count#') and len(evaluate('mont_part_value2_#index_type#_#mont_part_count#'))>
                                    <cfset 'mont_part_value2_#index_type#_#mont_part_count#' = evaluate('mont_part_value2_#index_type#_#mont_part_count#') + evaluate('alan_2_#index_type#_#month_list_index#')>
                                <cfelse>
                                    <cfset 'mont_part_value2_#index_type#_#mont_part_count#' = evaluate('alan_2_#index_type#_#month_list_index#')>
                                </cfif>
                            </cfif>
                        </cfloop>
                        <cfif mont_count eq 3 or month_list_index eq listlast(month_list)>
                            <cfset mont_part_count = mont_part_count+1>
                            <cfset mont_count=0>
                        </cfif>
                    </cfloop>
                </cfif>	
                <!--- Alt toplam değişkenleri tanımlanıyor --->	
                <cfif attributes.time_type eq 3>
                    <cfloop list="#month_list#" index="kk">
                        <cfset "net_alis_toplam_#kk#" = 0>
                        <cfset "net_alis_toplam_doviz_#kk#" = 0>
                        <cfset "net_satis_toplam_#kk#" = 0>
                        <cfset "net_satis_toplam_doviz_#kk#" = 0>
                        <cfset "net_tahsilat_toplam_#kk#" = 0>
                        <cfset "net_tahsilat_toplam_doviz_#kk#" = 0>
                        <cfset "net_odeme_toplam_#kk#" = 0>
                        <cfset "net_odeme_toplam_doviz_#kk#" = 0>
                    </cfloop>
                <cfelse>
                    <cfloop from="1" to="#tarih_farki+1#" index="kk">
                        <cfset "net_alis_toplam_#kk#" = 0>
                        <cfset "net_alis_toplam_doviz_#kk#" = 0>
                        <cfset "net_satis_toplam_#kk#" = 0>
                        <cfset "net_satis_toplam_doviz_#kk#" = 0>
                        <cfset "net_tahsilat_toplam_#kk#" = 0>
                        <cfset "net_tahsilat_toplam_doviz_#kk#" = 0>
                        <cfset "net_odeme_toplam_#kk#" = 0>
                        <cfset "net_odeme_toplam_doviz_#kk#" = 0>
                    </cfloop>
                </cfif>
                <cf_grid_list>
                    <thead>
                    <tr>
                        <th>&nbsp;</th>
                        <cfif attributes.time_type eq 4>
                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                <th align="center" colspan="2"><cfoutput>#jj#</cfoutput></th>
                            </cfloop>
                        <cfelseif attributes.time_type eq 1>
                            <cfloop from="1" to="#tarih_farki#" index="tt">
                                <th align="center" colspan="2"><cfoutput><cfif attributes.time_type eq 3>#listgetat(aylar,(attributes.startdate+tt),',')#<cfelseif attributes.time_type eq 1>#tt#</cfif></cfoutput></th>
                            </cfloop>
                        <cfelse>
                            <cfloop from="0" to="#tarih_farki#" index="kk">
                                <th align="center" colspan="2"><cfoutput><cfif attributes.time_type eq 3>#listgetat(aylar,(attributes.startdate+kk),',')#<cfelseif attributes.time_type eq 1>#kk#</cfif></cfoutput></th>
                            </cfloop>
                        </cfif>
                        <cfif attributes.time_type eq 3><th colspan="2" align="right" style="text-align:right;"><cf_get_lang dictionary_id="58456.Oran">%</th></cfif>
                    </tr>
                    </thead>
                    <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id ='40307.İşlem Tipleri'></th>
                        <cfif attributes.time_type eq 4>
                            <cfloop from="1" to="#mont_part_count-1#" index="fff">
                                <th align="center"><cfoutput>#session.ep.money#</cfoutput></th>
                                <th align="center"><cfoutput>#session.ep.money2#</cfoutput></th>
                            </cfloop>
                        <cfelseif attributes.time_type eq 1>
                            <cfloop from="1" to="#tarih_farki#" index="k">
                                <th align="center"><cfoutput>#session.ep.money#</cfoutput></th>
                                <th align="center"><cfoutput>#session.ep.money2#</cfoutput></th>
                            </cfloop>
                        <cfelse>
                            <cfloop from="1" to="#tarih_farki+1#" index="k">
                                <th align="center"><cfoutput>#session.ep.money#</cfoutput></th>
                                <th align="center"><cfoutput>#session.ep.money2#</cfoutput></th>
                            </cfloop>
                        </cfif>
                        <cfif attributes.time_type eq 3><th align="right" style="text-align:right;">&nbsp;</th></cfif>
                    </tr>
                    </thead>
                    <tbody>
                    <cfloop list="#type_index#" index="ii_index">
                    <tr>
                        <td nowrap>
                            <cfif ii_index is 'GET_PURCHASES'><cf_get_lang dictionary_id ='39821.Alışlar'>
                            <cfelseif ii_index is 'GET_SALES_RETURN1'><cf_get_lang dictionary_id='58314.Satıştan İadeler'> (+)
                            <cfelseif ii_index is 'GET_PURCHASE_DIFF'><cf_get_lang dictionary_id ='39822.Fiyat ve Vade Farkları'>
                            <cfelseif ii_index is 'GET_PURCHASE_RETURN'><cf_get_lang dictionary_id ='39824.Alıştan İadeler'> (-)
                            <cfelseif ii_index is 'GET_EXPENSE'><cf_get_lang dictionary_id ='39825.Masraf Fiş ve Dekont'>
                            <cfelseif ii_index is 'ALIS_TOPLAM'><font color="##FF0000"><cf_get_lang dictionary_id ='39826.Net Alış'><cf_get_lang dictionary_id ='57492.Toplam'></font><!--- Alışlar bitti alt toplamlar yazılacak --->
                            <cfelseif ii_index is 'GET_SALES'><cf_get_lang dictionary_id ='39545.Satışlar'>
                            <cfelseif ii_index is 'GET_PURCHASE_RETURN1'><cf_get_lang dictionary_id ='39824.Alıştan İadeler'>(+)
                            <cfelseif ii_index is 'GET_SALES_DIFF'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id ='39822.Fiyat ve Vade Farkları'>
                            <cfelseif ii_index is 'GET_SALES_RETURN'><cf_get_lang dictionary_id='58314.Satıştan İadeler'> (-)
                            <cfelseif ii_index is 'GET_INCOME'><cf_get_lang dictionary_id ='39839.Gelir Fiş ve Dekont'>
                            <cfelseif ii_index is 'SATIS_TOPLAM'><font color="##FF0000"><cf_get_lang dictionary_id ='39826.Net Alış'><cf_get_lang dictionary_id ='57492.Toplam'></font><!--- Satışlar bitti alt toplamlar yazılacak --->
                            <cfelseif ii_index is 'GET_CASH'><cf_get_lang dictionary_id='58645.Nakit'><cf_get_lang dictionary_id ='57845.Tahsilat'> 
                            <cfelseif ii_index is 'GET_CHEQUE'><cf_get_lang dictionary_id ='39831.Çek Tahsilat'>
                            <cfelseif ii_index is 'GET_CHEQUE_RETURN'><cf_get_lang dictionary_id ='39832.Çek İade Çıkış'> (-)
                            <cfelseif ii_index is 'GET_CHEQUE_P_RETURN'><cf_get_lang dictionary_id ='39833.Çek İade Giriş'> (+)
                            <cfelseif ii_index is 'GET_VOUCHER'><cf_get_lang dictionary_id ='39834.Senet Tahsilat'>
                            <cfelseif ii_index is 'GET_VOUCHER_RETURN'><cf_get_lang dictionary_id ='39835.Senet İade Çıkış'> (-)
                            <cfelseif ii_index is 'GET_VOUCHER_P_RETURN'><cf_get_lang dictionary_id ='39836.Senet İade Giriş'> (+)
                            <cfelseif ii_index is 'GET_REVENUE'><cf_get_lang dictionary_id ='57521.Banka'><cf_get_lang dictionary_id ='57845.Tahsilat'>
                            <cfelseif ii_index is 'GET_CREDIT_REVENUE'><cf_get_lang dictionary_id ='57839.Kredi Tahsilatı'>
                            <cfelseif ii_index is 'TAHSILAT_TOPLAM'><font color="##FF0000"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id ='57845.Tahsilat'><cf_get_lang dictionary_id ='57492.Toplam'></font><!--- Tahsilatlar bitti alt toplamlar yazılacak --->
                            <cfelseif ii_index is 'GET_PAYM'><cf_get_lang dictionary_id='58645.Nakit'><cf_get_lang dictionary_id ='57847.Ödeme'> 
                            <cfelseif ii_index is 'GET_CHEQUE_P'><cf_get_lang dictionary_id ='39840.Çek Ödeme'>
                            <cfelseif ii_index is 'GET_CHEQUE_P_RETURN1'><cf_get_lang dictionary_id ='39833.Çek İade Giriş'> (-)
                            <cfelseif ii_index is 'GET_CHEQUE_RETURN1'><cf_get_lang dictionary_id ='39832.Çek İade Çıkış'>(+)
                            <cfelseif ii_index is 'GET_VOUCHER_P'><cf_get_lang dictionary_id ='39841.Senet Ödeme'> 
                            <cfelseif ii_index is 'GET_VOUCHER_P_RETURN1'><cf_get_lang dictionary_id ='39836.Senet İade Giriş'>(-)
                            <cfelseif ii_index is 'GET_VOUCHER_RETURN1'><cf_get_lang dictionary_id ='39835.Senet İade Çıkış'>(+)
                            <cfelseif ii_index is 'GET_PAYMENTS'><cf_get_lang dictionary_id ='57521.Banka'><cf_get_lang dictionary_id ='57847.Ödeme'>
                            <cfelseif ii_index is 'GET_CREDIT_PAYMENTS'><cf_get_lang dictionary_id ='57838.Kredi Ödemes'>
                            <cfelseif ii_index is 'ODEME_TOPLAM'><font color="##FF0000"><cf_get_lang dictionary_id ='40400.Net Ödeme'><cf_get_lang dictionary_id ='57492.Toplam'></font><!--- Ödemeler bitti alt toplamlar yazılacak --->
                            </cfif>
                        </td>
                        <cfoutput>
                        <cfif attributes.time_type eq 4>
                            <cfloop from="1" to="#mont_part_count-1#" index="ddd">
                                <td align="right" style="text-align:right;">
                                    <cfif isdefined('mont_part_value_#ii_index#_#ddd#') and len(evaluate('mont_part_value_#ii_index#_#ddd#'))>
                                        <cfif not listfind("ALIS_TOPLAM,SATIS_TOPLAM,TAHSILAT_TOPLAM,ODEME_TOPLAM",ii_index)>
                                            #TLFormat(evaluate('mont_part_value_#ii_index#_#ddd#'))#
                                        </cfif>
                                        <!--- Kontroller yapılıp alt toplamlar bulunuyor veya yazılıyor --->
                                        <cfif listfind("GET_PURCHASES,GET_PURCHASE_DIFF,GET_SALES_RETURN1,GET_EXPENSE",ii_index)>
                                            <cfset "net_alis_toplam_#ddd#" =  evaluate("net_alis_toplam_#ddd#") + evaluate("mont_part_value_#ii_index#_#ddd#")>
                                        <cfelseif ii_index is 'GET_PURCHASE_RETURN'>
                                            <cfset "net_alis_toplam_#ddd#" =  evaluate("net_alis_toplam_#ddd#") - evaluate("mont_part_value_#ii_index#_#ddd#")>
                                        <cfelseif  ii_index is 'ALIS_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_alis_toplam_#ddd#"))#</font>
                                        <cfelseif listfind("GET_SALES,GET_SALES_DIFF,GET_PURCHASE_RETURN1,GET_INCOME",ii_index)>
                                            <cfset "net_satis_toplam_#ddd#" =  evaluate("net_satis_toplam_#ddd#") + evaluate("mont_part_value_#ii_index#_#ddd#")>
                                        <cfelseif ii_index is 'GET_SALES_RETURN'>
                                            <cfset "net_satis_toplam_#ddd#" =  evaluate("net_satis_toplam_#ddd#") - evaluate("mont_part_value_#ii_index#_#ddd#")>
                                        <cfelseif  ii_index is 'SATIS_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_satis_toplam_#ddd#"))#</font>
                                        <cfelseif listfind("GET_CASH,GET_CHEQUE,GET_CHEQUE_P_RETURN,GET_VOUCHER,GET_VOUCHER_P_RETURN,GET_REVENUE,GET_CREDIT_REVENUE",ii_index)>
                                            <cfset "net_tahsilat_toplam_#ddd#" =  evaluate("net_tahsilat_toplam_#ddd#") + evaluate("mont_part_value_#ii_index#_#ddd#")>
                                        <cfelseif ii_index is 'GET_CHEQUE_RETURN' or  ii_index is 'GET_VOUCHER_RETURN'>
                                            <cfset "net_tahsilat_toplam_#ddd#" =  evaluate("net_tahsilat_toplam_#ddd#") - evaluate("mont_part_value_#ii_index#_#ddd#")>
                                        <cfelseif  ii_index is 'TAHSILAT_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_tahsilat_toplam_#ddd#"))#</font>
                                        <cfelseif listfind("GET_PAYM,GET_CHEQUE_P,GET_CHEQUE_RETURN1,GET_VOUCHER_RETURN1,GET_VOUCHER_P,GET_PAYMENTS,GET_CREDIT_PAYMENTS",ii_index)>
                                            <cfset "net_odeme_toplam_#ddd#" =  evaluate("net_odeme_toplam_#ddd#") + evaluate("mont_part_value_#ii_index#_#ddd#")>
                                        <cfelseif ii_index is 'GET_CHEQUE_P_RETURN1' or ii_index is 'GET_VOUCHER_P_RETURN1'>
                                            <cfset "net_odeme_toplam_#ddd#" =  evaluate("net_odeme_toplam_#ddd#") - evaluate("mont_part_value_#ii_index#_#ddd#")>
                                        <cfelseif  ii_index is 'ODEME_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_odeme_toplam_#ddd#"))#</font>
                                        </cfif>
                                    <cfelseif listfind("ALIS_TOPLAM,SATIS_TOPLAM,TAHSILAT_TOPLAM,ODEME_TOPLAM",ii_index)>
                                        <font color="##FF0000">#TLFormat(0)#</font>
                                    <cfelse>
                                        #TLFormat(0)#
                                    </cfif>
                                </td>
                                <td align="right" style="text-align:right;">
                                    <cfif isdefined('mont_part_value2_#ii_index#_#ddd#') and len(evaluate('mont_part_value2_#ii_index#_#ddd#'))>
                                        <cfif not listfind("ALIS_TOPLAM,SATIS_TOPLAM,TAHSILAT_TOPLAM,ODEME_TOPLAM",ii_index)>
                                            #TLFormat(evaluate('mont_part_value2_#ii_index#_#ddd#'))#
                                        </cfif>
                                        <!--- Kontroller yapılıp alt toplamlar bulunuyor veya yazılıyor --->
                                        <cfif listfind("GET_PURCHASES,GET_PURCHASE_DIFF,GET_SALES_RETURN1,GET_EXPENSE",ii_index)>
                                            <cfset "net_alis_toplam_doviz_#ddd#" =  evaluate("net_alis_toplam_doviz_#ddd#") + evaluate("mont_part_value2_#ii_index#_#ddd#")>
                                        <cfelseif ii_index is 'GET_PURCHASE_RETURN'>
                                            <cfset "net_alis_toplam_doviz_#ddd#" =  evaluate("net_alis_toplam_doviz_#ddd#") - evaluate("mont_part_value2_#ii_index#_#ddd#")>
                                        <cfelseif  ii_index is 'ALIS_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_alis_toplam_doviz_#ddd#"))#</font>
                                        <cfelseif listfind("GET_SALES,GET_SALES_DIFF,GET_PURCHASE_RETURN1,GET_INCOME",ii_index)>
                                            <cfset "net_satis_toplam_doviz_#ddd#" =  evaluate("net_satis_toplam_doviz_#ddd#") + evaluate("mont_part_value2_#ii_index#_#ddd#")>
                                        <cfelseif ii_index is 'GET_SALES_RETURN'>
                                            <cfset "net_satis_toplam_doviz_#ddd#" =  evaluate("net_satis_toplam_doviz_#ddd#") - evaluate("mont_part_value2_#ii_index#_#ddd#")>
                                        <cfelseif  ii_index is 'SATIS_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_satis_toplam_doviz_#ddd#"))#</font>
                                        <cfelseif listfind("GET_CASH,GET_CHEQUE,GET_CHEQUE_P_RETURN,GET_VOUCHER,GET_VOUCHER_P_RETURN,GET_REVENUE,GET_CREDIT_REVENUE",ii_index)>
                                            <cfset "net_tahsilat_toplam_doviz_#ddd#" =  evaluate("net_tahsilat_toplam_doviz_#ddd#") + evaluate("mont_part_value2_#ii_index#_#ddd#")>
                                        <cfelseif ii_index is 'GET_CHEQUE_RETURN' or  ii_index is 'GET_VOUCHER_RETURN'>
                                            <cfset "net_tahsilat_toplam_doviz_#ddd#" =  evaluate("net_tahsilat_toplam_doviz_#ddd#") - evaluate("mont_part_value2_#ii_index#_#ddd#")>
                                        <cfelseif  ii_index is 'TAHSILAT_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_tahsilat_toplam_doviz_#ddd#"))#</font>
                                        <cfelseif listfind("GET_PAYM,GET_CHEQUE_P,GET_CHEQUE_RETURN1,GET_VOUCHER_RETURN1,GET_VOUCHER_P,GET_PAYMENTS,GET_CREDIT_PAYMENTS",ii_index)>
                                            <cfset "net_odeme_toplam_doviz_#ddd#" =  evaluate("net_odeme_toplam_doviz_#ddd#") + evaluate("mont_part_value2_#ii_index#_#ddd#")>
                                        <cfelseif ii_index is 'GET_CHEQUE_P_RETURN1' or ii_index is 'GET_VOUCHER_P_RETURN1'>
                                            <cfset "net_odeme_toplam_doviz_#ddd#" =  evaluate("net_odeme_toplam_doviz_#ddd#") - evaluate("mont_part_value2_#ii_index#_#ddd#")>
                                        <cfelseif  ii_index is 'ODEME_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_odeme_toplam_doviz_#ddd#"))#</font>
                                        </cfif>
                                    <cfelseif listfind("ALIS_TOPLAM,SATIS_TOPLAM,TAHSILAT_TOPLAM,ODEME_TOPLAM",ii_index)>
                                        <font color="##FF0000">#TLFormat(0)#</font>
                                    <cfelse>
                                        #TLFormat(0)#
                                    </cfif>
                                </td>
                            </cfloop>
                        <cfelse>
                            <cfloop list="#month_list#" index="ddd_other">
                                <td align="right" style="text-align:right;">
                                    <cfif isdefined('alan_#ii_index#_#ddd_other#') and len(evaluate('alan_#ii_index#_#ddd_other#'))>
                                        <cfif not listfind("ALIS_TOPLAM,SATIS_TOPLAM,TAHSILAT_TOPLAM,ODEME_TOPLAM",ii_index)>
                                            #TLFormat(evaluate('alan_#ii_index#_#ddd_other#'))#
                                        </cfif>
                                        <cfif ListFirst(month_list) eq ddd_other>
                                            <cfset month_first_element = evaluate('alan_#ii_index#_#ddd_other#')>
                                        </cfif>
                                        <cfif ListLast(month_list) eq ddd_other>
                                            <cfset month_last_element = evaluate('alan_#ii_index#_#ddd_other#')>
                                        </cfif>	
                                        <!--- Kontroller yapılıp alt toplamlar bulunuyor veya yazılıyor --->
                                        <cfif listfind("GET_PURCHASES,GET_PURCHASE_DIFF,GET_SALES_RETURN1,GET_EXPENSE",ii_index)>
                                            <cfset "net_alis_toplam_#ddd_other#" =  evaluate("net_alis_toplam_#ddd_other#") + evaluate("alan_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'GET_PURCHASE_RETURN'>
                                            <cfset "net_alis_toplam_#ddd_other#" =  evaluate("net_alis_toplam_#ddd_other#") - evaluate("alan_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'ALIS_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_alis_toplam_#ddd_other#"))#</font>
                                        <cfelseif listfind("GET_SALES,GET_SALES_DIFF,GET_PURCHASE_RETURN1,GET_INCOME",ii_index)>
                                            <cfset "net_satis_toplam_#ddd_other#" =  evaluate("net_satis_toplam_#ddd_other#") + evaluate("alan_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'GET_SALES_RETURN'>
                                            <cfset "net_satis_toplam_#ddd_other#" =  evaluate("net_satis_toplam_#ddd_other#") - evaluate("alan_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'SATIS_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_satis_toplam_#ddd_other#"))#</font>
                                        <cfelseif listfind("GET_CASH,GET_CHEQUE,GET_CHEQUE_P_RETURN,GET_VOUCHER,GET_VOUCHER_P_RETURN,GET_REVENUE,GET_CREDIT_REVENUE",ii_index)>
                                            <cfset "net_tahsilat_toplam_#ddd_other#" =  evaluate("net_tahsilat_toplam_#ddd_other#") + evaluate("alan_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'GET_CHEQUE_RETURN' or  ii_index is 'GET_VOUCHER_RETURN'>
                                            <cfset "net_tahsilat_toplam_#ddd_other#" =  evaluate("net_tahsilat_toplam_#ddd_other#") - evaluate("alan_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'TAHSILAT_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_tahsilat_toplam_#ddd_other#"))#</font>
                                        <cfelseif listfind("GET_PAYM,GET_CHEQUE_P,GET_CHEQUE_RETURN1,GET_VOUCHER_RETURN1,GET_VOUCHER_P,GET_PAYMENTS,GET_CREDIT_PAYMENTS",ii_index)>
                                            <cfset "net_odeme_toplam_#ddd_other#" =  evaluate("net_odeme_toplam_#ddd_other#") + evaluate("alan_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'GET_CHEQUE_P_RETURN1' or ii_index is 'GET_VOUCHER_P_RETURN1'>
                                            <cfset "net_odeme_toplam_#ddd_other#" =  evaluate("net_odeme_toplam_#ddd_other#") - evaluate("alan_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'ODEME_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_odeme_toplam_#ddd_other#"))#</font>
                                        </cfif>
                                    <cfelseif listfind("ALIS_TOPLAM,SATIS_TOPLAM,TAHSILAT_TOPLAM,ODEME_TOPLAM",ii_index)>
                                        <font color="##FF0000">#TLFormat(0)#</font>
                                    <cfelse>
                                        #TLFormat(0)#
                                    </cfif>
                                </td>
                                <td align="right" style="text-align:right;">
                                    <cfif isdefined('alan_2_#ii_index#_#ddd_other#') and len(evaluate('alan_2_#ii_index#_#ddd_other#'))>
                                        <cfif not listfind("ALIS_TOPLAM,SATIS_TOPLAM,TAHSILAT_TOPLAM,ODEME_TOPLAM",ii_index)>
                                            #TLFormat(evaluate('alan_2_#ii_index#_#ddd_other#'))#
                                        </cfif>
                                        <!--- Kontroller yapılıp alt toplamlar bulunuyor veya yazılıyor --->
                                        <cfif listfind("GET_PURCHASES,GET_PURCHASE_DIFF,GET_SALES_RETURN1,GET_EXPENSE",ii_index)>
                                            <cfset "net_alis_toplam_doviz_#ddd_other#" =  evaluate("net_alis_toplam_doviz_#ddd_other#") + evaluate("alan_2_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'GET_PURCHASE_RETURN'>
                                            <cfset "net_alis_toplam_doviz_#ddd_other#" =  evaluate("net_alis_toplam_doviz_#ddd_other#") - evaluate("alan_2_#ii_index#_#ddd_other#")>
                                        <cfelseif  ii_index is 'ALIS_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_alis_toplam_doviz_#ddd_other#"))#</font>
                                        <cfelseif listfind("GET_SALES,GET_SALES_DIFF,GET_PURCHASE_RETURN1,GET_INCOME",ii_index)>
                                            <cfset "net_satis_toplam_doviz_#ddd_other#" =  evaluate("net_satis_toplam_doviz_#ddd_other#") + evaluate("alan_2_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'GET_SALES_RETURN'>
                                            <cfset "net_satis_toplam_doviz_#ddd_other#" =  evaluate("net_satis_toplam_doviz_#ddd_other#") - evaluate("alan_2_#ii_index#_#ddd_other#")>
                                        <cfelseif  ii_index is 'SATIS_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_satis_toplam_doviz_#ddd_other#"))#</font>
                                        <cfelseif listfind("GET_CASH,GET_CHEQUE,GET_CHEQUE_P_RETURN,GET_VOUCHER,GET_VOUCHER_P_RETURN,GET_REVENUE,GET_CREDIT_REVENUE",ii_index)>
                                            <cfset "net_tahsilat_toplam_doviz_#ddd_other#" =  evaluate("net_tahsilat_toplam_doviz_#ddd_other#") + evaluate("alan_2_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'GET_CHEQUE_RETURN' or  ii_index is 'GET_VOUCHER_RETURN'>
                                            <cfset "net_tahsilat_toplam_doviz_#ddd_other#" =  evaluate("net_tahsilat_toplam_doviz_#ddd_other#") - evaluate("alan_2_#ii_index#_#ddd_other#")>
                                        <cfelseif  ii_index is 'TAHSILAT_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_tahsilat_toplam_doviz_#ddd_other#"))#</font>
                                        <cfelseif listfind("GET_PAYM,GET_CHEQUE_P,GET_CHEQUE_RETURN1,GET_VOUCHER_RETURN1,GET_VOUCHER_P,GET_PAYMENTS,GET_CREDIT_PAYMENTS",ii_index)>
                                            <cfset "net_odeme_toplam_doviz_#ddd_other#" =  evaluate("net_odeme_toplam_doviz_#ddd_other#") + evaluate("alan_2_#ii_index#_#ddd_other#")>
                                        <cfelseif ii_index is 'GET_CHEQUE_P_RETURN1' or ii_index is 'GET_VOUCHER_P_RETURN1'>
                                            <cfset "net_odeme_toplam_doviz_#ddd_other#" =  evaluate("net_odeme_toplam_doviz_#ddd_other#") - evaluate("alan_2_#ii_index#_#ddd_other#")>
                                        <cfelseif  ii_index is 'ODEME_TOPLAM'>
                                            <font color="##FF0000">#TLFormat(evaluate("net_odeme_toplam_doviz_#ddd_other#"))#</font>
                                        </cfif>
                                    <cfelseif listfind("ALIS_TOPLAM,SATIS_TOPLAM,TAHSILAT_TOPLAM,ODEME_TOPLAM",ii_index)>
                                        <font color="##FF0000">#TLFormat(0)#</font>
                                    <cfelse>
                                        #TLFormat(0)#
                                    </cfif>
                                </td>
                            </cfloop>
                        </cfif>
                        </cfoutput>
                        <cfif attributes.time_type eq 3>
                            <td align="right" style="text-align:right;">
                            <cfoutput>
                                <cfif len(month_first_element) and month_first_element gt 0>
                                    #TLFormat((100*(month_last_element-month_first_element))/month_first_element)#
                                <cfelse>
                                    #TLFormat((100*(month_last_element-month_first_element))/1)#
                                </cfif>
                            </cfoutput>
                            </td>
                        </cfif>
                    </tr>
                    </cfloop>
                    </tbody>
                </cf_grid_list>
                <cfif attributes.time_type neq 1>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                        <cfif attributes.time_type eq 4>
                            <cfset genislik = 900>
                        <cfelse>
                            <cfset my_len = listlen(month_list)>
                            <cfif my_len gt 7 >
                                <cfset genislik = 900+((my_len-5)*220)>
                            <cfelse>
                                <cfset genislik = 900>
                            </cfif>
                        </cfif>
                        <script src="JS/Chart.min.js"></script>
                        <cfset attributes.graph_type = 'bar'>
                        <cfif attributes.time_type eq 4>    
                            <canvas id="myChart" style="width:600px;height:600px;"></canvas>
                            <script>
                            var ctx = document.getElementById("myChart");
                            var myChart = new Chart(ctx, {
                                type: 'bar',
                                data: {
                                    labels: [ <cfloop from="1" to="#mont_part_count-1#" index="jj"><cfoutput> #jj#</cfoutput>,</cfloop> ],
                                    datasets: [{
                                        label: '<cf_get_lang dictionary_id ="39826.Net Alış">',
                                        data: [ <cfloop from="1" to="#mont_part_count-1#" index="jj"><cfoutput>#NumberFormat(evaluate('net_alis_toplam_#jj#'),'00')#</cfoutput>,</cfloop>],
                                        backgroundColor: [
                                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                            'rgba(255, 99, 132, 0.2)',
                                            </cfloop>
                                        ],
                                        borderColor: [
                                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                            'rgba(255,99,132,1)',
                                            </cfloop>
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '<cf_get_lang dictionary_id ="39828.Net Satış">',
                                        data: [ <cfloop from="1" to="#mont_part_count-1#" index="jj"><cfoutput>#NumberFormat(evaluate('net_satis_toplam_#jj#'),'00')#</cfoutput>,</cfloop>],
                                        backgroundColor: [
                                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                            'rgba(54, 162, 235, 0.2)',
                                            </cfloop>
                                        ],
                                        borderColor: [
                                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                            'rgba(54, 162, 235, 1)',
                                            </cfloop>
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '<cf_get_lang dictionary_id ="40399.Net Tahsilat">',
                                        data: [ <cfloop from="1" to="#mont_part_count-1#" index="jj"><cfoutput>#NumberFormat(evaluate('net_tahsilat_toplam_#jj#'),'00')#</cfoutput>,</cfloop>],
                                        backgroundColor: [
                                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                            'rgba(255, 206, 86, 0.2)',
                                            </cfloop>
                                        ],
                                        borderColor: [
                                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                            'rgba(255, 206, 86, 1)',
                                            </cfloop>
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '<cf_get_lang dictionary_id ="40400.Net Ödeme">',
                                        data: [ <cfloop from="1" to="#mont_part_count-1#" index="jj"><cfoutput>#NumberFormat(evaluate('net_odeme_toplam_#jj#'),'00')#</cfoutput>,</cfloop>],
                                        backgroundColor: [
                                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                            'rgba(75, 192, 192, 0.2)',
                                            </cfloop>
                                        ],
                                        borderColor: [
                                            <cfloop from="1" to="#mont_part_count-1#" index="jj">
                                            'rgba(75, 192, 192, 1)',
                                            </cfloop>
                                        ],
                                        borderWidth: 1 
                                    }    
                                    ]
                                },
                                options: {
                                    scales: {
                                        yAxes: [{
                                            ticks: {
                                                beginAtZero:true
                                            }
                                        }]
                                    }
                                }
                            });
                            </script>
                        <cfelse>
                            <canvas id="myChart" style="width:600px;height:600px;"></canvas>
                            <script>
                            var ctx = document.getElementById("myChart");
                            var myChart = new Chart(ctx, {
                                type: 'bar',
                                data: {
                                    labels: [ <cfloop list="#month_list#" index="ay_indx"><cfoutput>"#listgetat(aylar,ay_indx,',')#"</cfoutput>,</cfloop> ],
                                    datasets: [{
                                        label: '<cf_get_lang dictionary_id ="39826.Net Alış">',
                                        data: [ <cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(evaluate('net_alis_toplam_#ay_indx#'),'00')#</cfoutput>,</cfloop>],
                                        backgroundColor: [
                                            <cfloop list="#month_list#" index="ay_indx">
                                            'rgba(255, 99, 132, 0.2)',
                                            </cfloop>
                                        ],
                                        borderColor: [
                                            <cfloop list="#month_list#" index="ay_indx">
                                            'rgba(255,99,132,1)',
                                            </cfloop>
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '<cf_get_lang dictionary_id ='39828.Net Satış'>',
                                        data: [ <cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(evaluate('net_satis_toplam_#ay_indx#'),'00')#</cfoutput>,</cfloop>],
                                        backgroundColor: [
                                            <cfloop list="#month_list#" index="ay_indx">
                                            'rgba(54, 162, 235, 0.2)',
                                            </cfloop>
                                        ],
                                        borderColor: [
                                            <cfloop list="#month_list#" index="ay_indx">
                                            'rgba(54, 162, 235, 1)',
                                            </cfloop>
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '<cf_get_lang dictionary_id ='40399.Net Tahsilat'>',
                                        data: [ <cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(evaluate('net_tahsilat_toplam_#ay_indx#'),'00')#</cfoutput>,</cfloop>],
                                        backgroundColor: [
                                            <cfloop list="#month_list#" index="ay_indx">
                                            'rgba(255, 206, 86, 0.2)',
                                            </cfloop>
                                        ],
                                        borderColor: [
                                            <cfloop list="#month_list#" index="ay_indx">
                                            'rgba(255, 206, 86, 1)',
                                            </cfloop>
                                        ],
                                        borderWidth: 1
                                    },
                                    {
                                        label: '<cf_get_lang dictionary_id ='40400.Net Ödeme'>',
                                        data: [ <cfloop list="#month_list#" index="ay_indx"><cfoutput>#NumberFormat(evaluate('net_odeme_toplam_#ay_indx#'),'00')#</cfoutput>,</cfloop>],
                                        backgroundColor: [
                                            <cfloop list="#month_list#" index="ay_indx">
                                            'rgba(75, 192, 192, 0.2)',
                                            </cfloop>
                                        ],
                                        borderColor: [
                                            <cfloop list="#month_list#" index="ay_indx">
                                            'rgba(75, 192, 192, 1)',
                                            </cfloop>
                                        ],
                                        borderWidth: 1 
                                    }    
                                    ]
                                },
                                options: {
                                    scales: {
                                        yAxes: [{
                                            ticks: {
                                                beginAtZero:true
                                            }
                                        }]
                                    }
                                }
                            });
                            </script>
                        </cfif>
                    </div>
                </cfif>
            </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	function control()
	{
		if(form_report.time_type.value == "")
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='57497.Zaman Dilimi'>");
			return false;
		}
		else
			return true;
	}
	function change_month()
	{
		if(form_report.time_type.value == 1)
			form_report.finishdate.disabled = true;
		else
			form_report.finishdate.disabled = false;
	}
</script>

