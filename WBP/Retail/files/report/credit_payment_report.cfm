<cfif isdefined("attributes.start_date_1") and len(attributes.start_date_1)>
	<cf_date tarih = "attributes.start_date_1">
<cfelse>
	<cfparam name="attributes.start_date_1" default="">
</cfif>

<cfif isdefined("attributes.finish_date_1") and len(attributes.finish_date_1)>
	<cf_date tarih = "attributes.finish_date_1">
<cfelse>
	<cfparam name="attributes.finish_date_1" default="">
</cfif>
<cfparam name="attributes.credit_type_id" default="">
<cfquery name="get_credit_type" datasource="#dsn#">
    SELECT * FROM SETUP_CREDIT_TYPE ORDER BY CREDIT_TYPE_ID
</cfquery>
<cfset credit_type_list = valuelist(get_credit_type.CREDIT_TYPE_ID)>

<cf_report_list_search title="#getLang('','Kredi Ödeme Raporu',61864)#">
    <cf_report_list_search_area>
        <cfform name="report" id="report" method="post" action="#request.self#?fuseaction=retail.credit_payment_report">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='34283.Kredi Türü'></label>
										<div class="col col-12 col-xs-122">
                                            <cf_multiselect_check 
                                            query_name="get_credit_type"  
                                            name="credit_type_id"
                                            option_text="#getLang('','Kredi Türü',34283)#" 
                                            width="180"
                                            option_name="CREDIT_TYPE" 
                                            option_value="CREDIT_TYPE_ID"
                                            value="#attributes.credit_type_id#">
                                        </div>
                                    </div>
                                    <div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62343.Ödeme Tarihi Başlangıcı'></label>
										<div class="col col-12 col-xs-122">
                                            <div class="input-group">
                                                <cfinput type="text" name="start_date_1" id="start_date_1"  maxlength="10" value="#dateformat(attributes.start_date_1,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date_1"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62342.Ödeme Tarihi Bitişi'></label>
										<div class="col col-12 col-xs-122">
                                            <div class="input-group">
                                                <cfinput type="text" name="finish_date_1" id="finish_date_1"  maxlength="10" value="#dateformat(attributes.finish_date_1,"dd/mm/yyyy")#" style="width:65px;" validate="eurodate">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_1"></span
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
							<cf_wrk_search_button is_excel="1" button_type="1">					
					    </div>	  
					</div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

    

<cfquery name="get_rows" datasource="#dsn3#">
    SELECT
        CR.*,
        CC.AGREEMENT_NO,
        CC.CREDIT_TYPE,
        CC.CREDIT_NO,
        CC.COMPANY_ID,
        CC.CREDIT_EMP_ID,
        CC.CREDIT_DATE,
        (SELECT E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E WHERE E.EMPLOYEE_ID = CC.CREDIT_EMP_ID) AS KREDI_SORUMLUSU,
        (SELECT C.FULLNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = CC.COMPANY_ID) AS KREDI_FIRMA
    FROM
        CREDIT_CONTRACT_ROW CR,
        CREDIT_CONTRACT CC
    WHERE
        <cfif isdefined("attributes.start_date_1") and isdate(attributes.start_date_1)>
            CR.PROCESS_DATE >= #attributes.start_date_1# AND
        </cfif>
        <cfif isdefined("attributes.finish_date_1") and isdate(attributes.finish_date_1)>
            CR.PROCESS_DATE < #dateadd("d",1,attributes.finish_date_1)# AND
        </cfif>
        <cfif isdefined("attributes.credit_type_id") and len(attributes.credit_type_id)>
            CC.CREDIT_TYPE IN (#attributes.credit_type_id#) AND
        </cfif>
        CC.CREDIT_CONTRACT_ID = CR.CREDIT_CONTRACT_ID AND
        CR.CREDIT_CONTRACT_TYPE = 1 AND
        CR.IS_PAID = 0 AND
        ISNULL(CR.IS_PAID_ROW,0) = 0
</cfquery>
<cfset tutar_toplam_ = 0>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='43280.Kredi No'></th>
                <th><cf_get_lang dictionary_id='30044.Sözleşme No'></th>
                <th><cf_get_lang dictionary_id='34283.Kredi Türü'></th>
                <th><cf_get_lang dictionary_id='30631.Tarih'></th>
                <th><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></th>
                <th><cf_get_lang dictionary_id='51334.Kredi Kurumu'></th>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
                <th style="text-align:right;"><cf_get_lang dictionary_id='48543.Ödeme Tutarı'></th>
                </tr>
            </thead>
            <tbody>
            <cfoutput query="get_rows">
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=credit.detail_credit_contract&credit_contract_id=#credit_contract_id#" class="tableyazi">#credit_no#</a></td>
                        <td>#agreement_no#</td>
                        <td><cfif len(credit_type)>#get_credit_type.CREDIT_TYPE[listfind(credit_type_list,CREDIT_TYPE,',')]#</cfif></td>
                        <td>#dateformat(credit_date,'dd/mm/yyyy')#</td>
                        <td>#dateformat(PROCESS_DATE,'dd/mm/yyyy')#</td>
                        <td>
                            <cfif len(company_id)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">#kredi_firma#</a>
                            </cfif>
                        </td>
                        <td>#detail#</td>
                        <td>
                            <cfif len(credit_emp_id)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#credit_emp_id#','medium');" class="tableyazi">#kredi_sorumlusu#</a>
                            </cfif>
                        </td>
                        <td style="text-align:right;">#tlformat(TOTAL_PRICE)#</td>
                    </tr>
                    <cfset tutar_toplam_ = tutar_toplam_ + TOTAL_PRICE>
            </cfoutput>
            </tbody>
            <cfoutput>
            <tfoot>
                    <tr>
                        <td colspan="9" style="text-align:right;" class="formbold"><cf_get_lang dictionary_id='39895.Toplam Ödeme'></td>
                        <td style="text-align:right;" class="formbold">#tlformat(tutar_toplam_)#</td>
                    </tr>
            </tfoot>
            </cfoutput>
        </cf_grid_list>
    </cf_box>
</div>