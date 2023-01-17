<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sal_mon" default="#dateformat(now(),'m')#"> 
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.gross_type" default="1">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.branch_id" default="">
<cfquery name="get_branch" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE 
		<cfif not session.ep.ehesap>
			BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
		</cfif>
		BRANCH_ID IS NOT NULL
</cfquery>
<cfif isdefined('attributes.is_submitted')>
	<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
	<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
	<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)))>
	<cfquery name="get_puantaj" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			EO.IN_OUT_ID,
			EPS.GROSS_NET,
			EPS.NET_UCRET,
			EPS.TOTAL_SALARY,
			EPS.TOTAL_DAYS,
			EPS.TOTAL_PAY,
			EPS.TOTAL_PAY_SSK_TAX,
			EPS.TOTAL_PAY_SSK,
			EPS.TOTAL_PAY_TAX,
			EPS.EMPLOYEE_PUANTAJ_ID,
			EPS.VERGI_INDIRIMI
		FROM
			EMPLOYEES E,
			EMPLOYEES_PUANTAJ EP,
			EMPLOYEES_PUANTAJ_ROWS EPS ,
			EMPLOYEES_IN_OUT EO
		WHERE
			EP.PUANTAJ_TYPE = -1 AND
			EO.START_DATE < #puantaj_finish_# AND 
			(EO.FINISH_DATE >= #puantaj_start_# OR EO.FINISH_DATE IS NULL) AND
			E.EMPLOYEE_ID = EPS.EMPLOYEE_ID
			AND EPS.EMPLOYEE_ID = EO.EMPLOYEE_ID
			<cfif isdefined("attributes.sal_year") and len(attributes.sal_year)>
				AND EP.SAL_YEAR = #attributes.sal_year# 
			</cfif>
			<cfif isdefined("attributes.sal_mon") and len(attributes.sal_mon)>
				AND	EP.SAL_MON = #attributes.sal_mon# 		
			</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND	(E.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%')
			</cfif>
			<cfif isdefined("attributes.gross_type") and len(attributes.gross_type)>
				AND	EPS.GROSS_NET = #attributes.gross_type#
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND	EO.BRANCH_ID = #attributes.branch_id#
			<cfelse>
				AND	EO.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
			</cfif>
			AND EP.PUANTAJ_ID = EPS.PUANTAJ_ID
		ORDER BY
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_puantaj.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_puantaj.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="header"><cf_get_lang dictionary_id ='47811.Puantaj Karşılaştırma Raporu'></cfsavecontent>
<cfform name="theform" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	<cf_report_list_search title="#header#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-md-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                            <div class="col col-12 col-md-12">
                                                <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255">
                                            </div>	
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-md-12"><cf_get_lang dictionary_id='57453.Şube'></label>				
                                            <div class="col col-12 col-md-12">
                                                <select name="branch_id" id="branch_id">
                                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>
                                                    <cfoutput query="get_branch">
                                                        <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </div>					
                                        </div>
                                    </div>
                                </div>
							</div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="col col-12 col-md-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12"><cf_get_lang dictionary_id='58083.Net'>/<cf_get_lang dictionary_id='56257.Brüt'></label>	
                                            <div class="col col-12 col-md-12">
                                                <select name="gross_type" id="gross_type">
                                                    <option value="1" <cfif attributes.gross_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58083.Net'></option>
                                                    <option value="0" <cfif attributes.gross_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='38990.Brüt'></option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            
                                            <div class="col col-12 col-md-12 paddingNone">
                                                <div class="col col-6"><label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
                                                    <select name="sal_mon" id="sal_mon">
                                                        <cfloop from="1" to="12" index="i">
                                                        <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                                <div class="col col-6"><label class="col col-12 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
                                                    <select name="sal_year" id="sal_year">
                                                        <cfloop from="#session.ep.period_year-3#" to="#session.ep.period_year+3#" index="i">
                                                            <cfoutput>
                                                            <option value="#i#"<cfif attributes.sal_year eq i> selected</cfif>>#i#</option>
                                                            </cfoutput>
                                                        </cfloop>
                                                    </select>
                                                </div>
                                            </div>			
                                        </div>
                                    </div>
                                </div>
                            </div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                            <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
                            </cfif>
                            <input name="is_submitted" id="is_submitted" type="hidden" value="1">
                            <cf_wrk_report_search_button button_type="1" is_excel='1' search_function="control()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
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
<cfif isdefined("attributes.is_submitted")>
	<cfif attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows = get_puantaj.recordcount>
	</cfif>
    <cf_report_list>
            <thead>
                <tr> 
                    <th width="30"><cf_get_lang dictionary_id='58577.Sira'></th>
                    <th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id ='40071.Maaş'></th>
                    <th nowrap><cf_get_lang dictionary_id ='57489.Para Br'></th>
                    <th><cf_get_lang dictionary_id ='38979.Ücret Tipi'></th>
                    <th><cf_get_lang dictionary_id ='58650.Puantaj'><cf_get_lang dictionary_id ='38999.Net Ücret'></th>
                    <th><cf_get_lang dictionary_id ='58650.Puantaj'><cf_get_lang dictionary_id ='38879.Gün Sayısı'></th>
                    <th><cf_get_lang dictionary_id ='40073.Ödenek'></th>
                    <th><cf_get_lang dictionary_id ='39992.Kesinti'><cf_get_lang dictionary_id ='57492.Toplam'></th>
                    <th><cf_get_lang dictionary_id ='38988.Vergi İstisnası'><cf_get_lang dictionary_id ='57492.Toplam'></th>
                    <!-- sil --><th class="header_icn_none">&nbsp;</th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_puantaj.recordcount>
                    <cfset salary_in_out_id_list = ''>
                        <cfset main_salary_in_out_id_list = ''>
                        <cfoutput query="get_puantaj" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfset salary_in_out_id_list = listappend(salary_in_out_id_list,IN_OUT_ID,',')>
                        </cfoutput>
                        <cfset salary_in_out_id_list=listsort(salary_in_out_id_list,"numeric","ASC",",")>
                        <cfif listlen(salary_in_out_id_list)>
                            <cfquery name="get_maas_all" datasource="#dsn#">
                                SELECT
                                    M#attributes.sal_mon# AS MAAS,
                                    MONEY AS SALARY_MONEY,
                                    IN_OUT_ID
                                FROM 
                                    EMPLOYEES_SALARY 
                                WHERE
                                    IN_OUT_ID IN (#salary_in_out_id_list#)
                                    <cfif isdefined("attributes.sal_year") and len(attributes.sal_year)>
                                        AND PERIOD_YEAR = #attributes.sal_year#
                                    </cfif>
                                ORDER BY
                                    IN_OUT_ID
                            </cfquery>
                            <cfset main_salary_in_out_id_list = listsort(listdeleteduplicates(valuelist(get_maas_all.IN_OUT_ID,',')),'numeric','ASC',',')>
                        </cfif>
                    <cfoutput query="get_puantaj" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <cfif attributes.is_excel eq 1>
                            <td>#employee_name# #employee_surname#</td>
                            <cfelse>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            </cfif>
                            <td style="text-align:right;"><cfif listfind(main_salary_in_out_id_list,IN_OUT_ID,',')><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(get_maas_all.MAAS[listfind(main_salary_in_out_id_list,IN_OUT_ID,',')])#"><cfelse><cf_get_lang dictionary_id='58845.Tanımsız'></cfif></td>
                            <td>&nbsp;#get_maas_all.SALARY_MONEY[listfind(main_salary_in_out_id_list,IN_OUT_ID,',')]#</td>
                            <td style="text-align:right;"><cfif gross_net eq 0><cf_get_lang dictionary_id ='38990.Brüt'><cfelse><cf_get_lang dictionary_id='58083.Net'></cfif></td>
                            <td style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(net_ucret)#"></td>
                            <td style="text-align:right;">#total_days#</td>
                            <td style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total_pay+total_pay_ssk_tax+total_pay_ssk+total_pay_tax)#"></td>
                            <td style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(total_salary-net_ucret)#"></td>
                            <td style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(vergi_indirimi)#"></td>
                            <cfif attributes.is_excel eq 0>
                            <!-- sil --><td align="center">
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ehesap.popup_view_price_compass&style=one&employee_puantaj_id=#employee_puantaj_id#&employee_id=#employee_id#&sal_mon=#sal_mon#&sal_year=#sal_year#&puantaj_type=-1','page');"><img src="/images/transfer.gif" border="0" title="<cf_get_lang dictionary_id ='40070.Puantaj Detay'>"></a>
                            </td><!-- sil -->
                            <cfelse><td></td>
                            </cfif>
                        </tr>
                    </cfoutput>
                <cfelse>
                <tr>
                    <td colspan="11"><!-- sil --><cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!<!-- sil --></td>
                </tr>
                </cfif>
            </tbody>
        
    </cf_report_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfset url_str = attributes.fuseaction>
        <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)> 
            <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
        </cfif>
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)> 
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)> 
            <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif isdefined("attributes.sal_mon") and len(attributes.sal_mon)> 
            <cfset url_str = "#url_str#&sal_mon=#attributes.sal_mon#">
        </cfif>
        <cfif isdefined("attributes.sal_year") and len(attributes.sal_year)> 
            <cfset url_str = "#url_str#&sal_year=#attributes.sal_year#">
        </cfif>
        <cfif isdefined("attributes.gross_type") and len(attributes.gross_type)> 
            <cfset url_str = "#url_str#&gross_type=#attributes.gross_type#">
        </cfif>
        
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#">
    </cfif>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
    function control()	
	{
            if(document.theform.is_excel.checked==false)
            {
                document.theform.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.theform.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_puantaj_check_report</cfoutput>"
    }
</script>
