<!---
    File: V16\hr\ehesap\display\view_personnel_form.cfm
    Author: Dilek Özdemir <dilekozdemir@workcube.com>
    Date: 2022-01-17
    Description: Personel Bildirim Formu
    History:
    To Do:
--->

<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon, 1)>
<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end)>
	<cfset temp_ay_basi = createdate(attributes.sal_year_end,attributes.sal_mon_end, 1)>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,temp_ay_basi))>
<cfelse>
	<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
</cfif>
<cfset gecen_ay_basi = date_add('m',-1,bu_ay_basi)>
<cfset gecen_ay_sonu = date_add('D',30,gecen_ay_basi)>

<cfquery name="last_month_active" datasource="#dsn#">
    SELECT
        COUNT(EMPLOYEE_ID) AS total_emp,
        SUM(COUNT(EMPLOYEE_ID)) OVER() AS total_count,
        EMPLOYEE_ID
    FROM
        EMPLOYEES_IN_OUT
    WHERE 
        EMPLOYEES_IN_OUT.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_puantaj_personal.EMPLOYEE_ID)#" list="yes">) AND
        (
        EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_basi#"> AND
        EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_sonu#">
        )
        OR
        (
        EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_basi#"> AND
        EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
        )
        OR
        (
        EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_basi#"> AND
        EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_sonu#">
        )
        OR
        (
        EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_basi#"> AND
        EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
        )
    GROUP BY EMPLOYEE_ID
</cfquery>
<cfquery name="last_month_out" datasource="#dsn#">
    SELECT
        EMPLOYEE_ID
    FROM
        EMPLOYEES_IN_OUT
    WHERE 
        EMPLOYEES_IN_OUT.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_puantaj_personal.EMPLOYEE_ID)#" list="yes">) AND
        (
        EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_basi#"> AND
        EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_sonu#">
        )
        OR
        (
        EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_basi#"> AND
        EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#gecen_ay_sonu#">
        )
    
    GROUP BY EMPLOYEE_ID
</cfquery>

<cfif last_month_active.recordCount>
    <cfset last_month_emp_count= last_month_active.recordCount - last_month_out.recordCount>   <!--- Geçen Dönem Aktif Çalışan Sayısı - Geçen Dönem İşten Çıkan Sayısı --->
<cfelse>
    <cfset last_month_emp_count= 0>
</cfif>
<cfquery name="this_month_in" datasource="#dsn#">
    SELECT
        EMPLOYEES_IN_OUT.EMPLOYEE_ID,
        EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
        EMPLOYEE_POSITIONS.POSITION_NAME
    FROM
        EMPLOYEES_IN_OUT
    LEFT JOIN 
        EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID= EMPLOYEES_IN_OUT.EMPLOYEE_ID
    LEFT JOIN 
        EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID= EMPLOYEES_IN_OUT.EMPLOYEE_ID
    WHERE 
        EMPLOYEES_IN_OUT.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_puantaj_personal.EMPLOYEE_ID)#" list="yes">) AND
        EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#">
        AND EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
        AND EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#">
        AND  EMPLOYEES.EMPLOYEE_NAME IS NOT NULL
        
    GROUP BY
        EMPLOYEES_IN_OUT.EMPLOYEE_ID,
        EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
        EMPLOYEE_POSITIONS.POSITION_NAME
</cfquery>
<cfquery name="this_month_out" datasource="#dsn#">
    SELECT
        EMPLOYEES_IN_OUT.EMPLOYEE_ID,
        EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
        EMPLOYEE_POSITIONS.POSITION_NAME
    FROM
        EMPLOYEES_IN_OUT

    LEFT JOIN
        EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID= EMPLOYEES_IN_OUT.EMPLOYEE_ID
    LEFT JOIN 
        EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID= EMPLOYEES_IN_OUT.EMPLOYEE_ID
    WHERE 
        EMPLOYEES_IN_OUT.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_puantaj_personal.EMPLOYEE_ID)#" list="yes">) AND
        EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#">
        AND EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#">
        AND	EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL
        AND  EMPLOYEES.EMPLOYEE_NAME IS NOT NULL
    GROUP BY 
        EMPLOYEES_IN_OUT.EMPLOYEE_ID,
        EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
        EMPLOYEE_POSITIONS.POSITION_NAME
</cfquery>
<cfquery name="get_unpaid_leave" datasource="#dsn#">
	SELECT
		OFFTIME.EMPLOYEE_ID
	FROM
		OFFTIME
    LEFT JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
	WHERE
        OFFTIME.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_puantaj_personal.EMPLOYEE_ID)#" list="yes">) AND
		OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND
		OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND 
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
        SETUP_OFFTIME.OFFTIMECAT_ID = 4 OR OFFTIME.SUB_OFFTIMECAT_ID = 4
    GROUP BY  OFFTIME.EMPLOYEE_ID
</cfquery>

<cfquery name="get_disease_leave" datasource="#dsn#">
	SELECT
		OFFTIME.EMPLOYEE_ID,
        EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
        SUM(DATEDIFF(D,OFFTIME.STARTDATE,OFFTIME.FINISHDATE))+1 AS THIS_MONTH_DISEASE_DAY
	FROM
		OFFTIME
    LEFT JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
    LEFT JOIN EMPLOYEES ON OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
	WHERE
        OFFTIME.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_puantaj_personal.EMPLOYEE_ID)#" list="yes">) AND
		OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#"> AND
		OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND 
		OFFTIME.IS_PUANTAJ_OFF = 0 AND
        SETUP_OFFTIME.EBILDIRGE_TYPE_ID = 1
    GROUP BY 
        OFFTIME.EMPLOYEE_ID,
        EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>
<cfset get_title_cmp = createObject("component","V16.hr.cfc.get_titles")>
<cf_box title="#getLang('','Personel Bildirim Formu','64918')#" uidrop="1">
    <div class="printThis">
        <style>
            .printableArea{
                display: block;
                position: relative;
                page-break-after: always;
                width: 209mm;
                height: 296mm;
                display: block;
                position: relative;
                margin: 0 auto;
            }    
            .printableArea * {
                font-family: Arial,Helvetica Neue,Helvetica,sans-serif; 
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
                font-size: 12px;
            }
        
            .printableArea *:before,
            .printableArea *:after {
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
                box-sizing: border-box;
            }
            <!--- SADECE DEVELOPER DA AÇ --->
                /* .printableArea div{border:1px solid red;}
        
                .printableArea{border: 1px solid #2196F3; } */
        
            <!--- SADECE DEVELOPER DA AÇ --->   
            table#tablo_ust_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
            }
            table#tablo_ust_baslik th {
            border: 1px solid black;
            padding: 3mm;
            }
            table#tablo_alt_baslik {
                width: 100%;
                padding: 10px 200px;
                box-sizing: border-box;
                border-collapse: collapse;
                border: 0px;
                margin-top:3mm;
            }
            table#tablo_alt_baslik td {
            border: 1px solid black;
            padding: 3mm;
            }
            #bordrologo{
                width: 100px  !important;
                height: 50px  !important;
                display: block;
                margin-left: auto;
                margin-right: auto;
                width: 50%;
                -webkit-filter: grayscale(100%); /* Safari 6.0 - 9.0 */
                filter: grayscale(100%);
            }
            #paper_title{
                text-align: center;
                vertical-align: middle;
                line-height: 90px;
                font-size: 16pt;
            }
        
        
            table#tablo_ust_ekbilgi {
        
                min-width: 110mm;
        
                margin: 2mm 0mm;
        
            }
        
        
            @media print      {
        
                .printableArea{
        
                    page-break-after:always;
        
                }
        
            }
        
        
        </style>
        <div class="printableArea" id="printBordro">
            <div id="logo">
                <img src="https://ms.hmb.gov.tr/uploads/2018/12/logo.png" id="bordrologo"/>
            </div>
            <div id = "paper_title">
                <cfoutput>#ucase(getLang('','Personel Bildirim Formu','64918'))#</cfoutput>
            </div>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <table style="width:100%">
                    <cfoutput>
                        <tr>
                            <th><cf_get_lang dictionary_id='64935.Muhasebe Birim Kodu'> - <cf_get_lang dictionary_id='57897.Adı'> : #GET_PUANTAJ_PERSONAL.BRANCH_POSTCODE# - #GET_PUANTAJ_PERSONAL.related_company#</th>
                            <th><cf_get_lang dictionary_id='58455.Yıl'> : #attributes.sal_year#</th>
                        </tr>
                        <tr>
                            <th><cf_get_lang dictionary_id='51485.Kurum Kodu'> - <cf_get_lang dictionary_id='57897.Adı'>: #GET_PUANTAJ_PERSONAL.BRANCH_ID# - #GET_PUANTAJ_PERSONAL.related_company#</th>
                            <th><cf_get_lang dictionary_id='58724.Ay'> : #attributes.sal_mon#</th>
                        </tr>
                        <tr>
                            <th><cf_get_lang dictionary_id='64936.VKN No'> / <cf_get_lang dictionary_id='64937.VKN Adı'> : #GET_PUANTAJ_PERSONAL.BRANCH_TAX_NO# / #GET_PUANTAJ_PERSONAL.branch_fullname#</th>
                            <th><cf_get_lang dictionary_id='64941.Maaş Belge No'> :?</th>
                        </tr>
                        <tr>
                            <th></th>
                            <th><cf_get_lang dictionary_id='64953.'> :?</th>
                        </tr>
                    </cfoutput>
                </table>
                <table id="tablo_alt_baslik">
                    <cfoutput>
                        <cfif last_month_active.recordCount>
                            <cfquery name="last_month_active_sum" dbtype="query">
                                SELECT
                                    SUM(NET_UCRET) AS ACTIVE_NET_TOTAL,
                                    SUM(TOTAL_SALARY) AS ACTIVE_BRUT_TOTAL
                                FROM 
                                    get_puantaj_personal 
                                WHERE 
                                    EMPLOYEE_ID IN  (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(last_month_active.EMPLOYEE_ID)#" list="yes">)
                            </cfquery> 
                        </cfif>
                        <cfif last_month_out.recordCount>
                            <cfquery name="last_month_out_sum" dbtype="query">
                                SELECT
                                    SUM(NET_UCRET) AS OUT_NET_TOTAL,
                                    SUM(TOTAL_SALARY) AS OUT_BRUT_TOTAL
                                FROM 
                                    get_puantaj_personal 
                                WHERE 
                                    EMPLOYEE_ID IN  (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(last_month_out.EMPLOYEE_ID)#" list="yes">)
                            </cfquery> 
                        </cfif>
                        <cfif this_month_in.recordCount>
                            <cfquery name="this_month_in_sum" dbtype="query">
                                SELECT
                                    SUM(NET_UCRET) AS IN_NET_TOTAL,
                                    SUM(TOTAL_SALARY) AS IN_BRUT_TOTAL
                                FROM 
                                    get_puantaj_personal 
                                WHERE 
                                    EMPLOYEE_ID IN  (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(this_month_in.EMPLOYEE_ID)#" list="yes">)
                            </cfquery> 
                        </cfif>
                        <cfif this_month_out.recordCount>
                            <cfquery name="this_month_out_sum" dbtype="query">
                                SELECT
                                    SUM(NET_UCRET) AS OUT_NET_TOTAL,
                                    SUM(TOTAL_SALARY) AS OUT_BRUT_TOTAL
                                FROM 
                                    get_puantaj_personal 
                                WHERE 
                                    EMPLOYEE_ID IN  (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(this_month_out.EMPLOYEE_ID)#" list="yes">)
                            </cfquery> 
                        </cfif>
                        <cfif get_unpaid_leave.recordCount>
                            <cfquery name="get_unpaid_leave_sum" dbtype="query">
                                SELECT
                                    SUM(NET_UCRET) AS LEAVE_NET_TOTAL,
                                    SUM(TOTAL_SALARY) AS LEAVE_BRUT_TOTAL
                                FROM 
                                    get_puantaj_personal 
                                WHERE 
                                    EMPLOYEE_ID IN  (<cfqueryparam cfsqltype="cf_sql_integer" value="#valuelist(get_unpaid_leave.EMPLOYEE_ID)#" list="yes">)
                            </cfquery> 
                        </cfif>
                    
                        <tr>
                            <td style="border:none;border-left-style:hidden"></td>
                            <td style="border:none"></td>
                            <td class="bold" width="150"><cf_get_lang dictionary_id='64965.Bütçe Yılı'></td>
                            <td colspan="2"><cfoutput>#attributes.sal_year#</cfoutput></td>
                        </tr>
                        <tr>
                            <td style="border:none;border-left-style:hidden"></td>
                            <td style="border:none"></td>
                            <td class="bold"><cf_get_lang dictionary_id='64966.Tahakkuk Toplamı'></td>
                            <td class="text-right bold" colspan="2"><cf_get_lang dictionary_id='64967.Ele Geçen Toplam'></td>
                        </tr>
                        <tr style="border-left-style:">
                            <td width="25">1</td>
                            <td width="300" class="bold"><cf_get_lang dictionary_id='64968.Geçen Ay Personel Sayısı'></td>
                            <td class="text-center">#last_month_emp_count#</td>
                            <td class="text-right">
                                <cfif not isDefined("last_month_active_sum.ACTIVE_BRUT_TOTAL") or not len(last_month_active_sum.ACTIVE_BRUT_TOTAL)>
                                    <cfset active_brut_totals= 0>
                                <cfelse>
                                    <cfset active_brut_totals= last_month_active_sum.ACTIVE_BRUT_TOTAL>
                                </cfif>
                                <cfif not isDefined("last_month_out_sum.OUT_BRUT_TOTAL") or not len(last_month_out_sum.OUT_BRUT_TOTAL)>
                                    <cfset out_brut_totals= 0>
                                <cfelse>
                                    <cfset out_brut_totals= last_month_out_sum.OUT_BRUT_TOTAL>
                                </cfif>
                               
                                <cfset last_month_brut = active_brut_totals - out_brut_totals>
                                #TlFormat(last_month_brut)# #session.ep.money#
                            </td>
                            <td class="text-right">
                                <cfif not isDefined("last_month_active_sum.ACTIVE_NET_TOTAL") or not len(last_month_active_sum.ACTIVE_NET_TOTAL)>
                                    <cfset last_month_active_sum_total= 0>
                                <cfelse>
                                    <cfset last_month_active_sum_total= last_month_active_sum.ACTIVE_NET_TOTAL>

                                </cfif>
                                <cfif not isDefined("last_month_out_sum.OUT_NET_TOTAL") or not len(last_month_out_sum.OUT_NET_TOTAL)>
                                    <cfset last_month_out_sum_total = 0>
                                <cfelse>
                                    <cfset last_month_out_sum_total =last_month_out_sum.OUT_NET_TOTAL>

                                </cfif>
                                <cfset last_month_net = last_month_active_sum_total - last_month_out_sum_total>
                                #TlFormat(last_month_net)# #session.ep.money#
                            </td>
                        </tr>
                        <tr>
                            <td width="20">2</td>
                            <td class="bold"><cf_get_lang dictionary_id='64969.Bu Ay İçinde Giren'>(X)</td>
                            <td class="text-center">#this_month_in.recordCount#</td>
                            <td class="text-right"></td>
                            <td class="text-right"></td>
                        </tr>
                        <tr>
                            <td width="20">3</td>
                            <td class="bold"><cf_get_lang dictionary_id='64970.Bu Ay İçinde Çıkan'></td>
                            <td class="text-center">#this_month_out.recordCount#</td>
                            <td class="text-right"></td>
                            <td class="text-right"></td>
                        </tr>
                        <tr>
                            <td width="20">4</td>
                            <td class="bold"><cf_get_lang dictionary_id='64971.Aylıksız İzinde(GSSP Kesilen)'></td>
                            <td class="text-center">#get_unpaid_leave.recordCount#</td>
                            <td class="text-right"></td>
                            <td class="text-right"></td>
                        </tr>
                        <tr>
                            <td width="20">5</td>
                            <td class="bold"><cf_get_lang dictionary_id='64972.Ödeme Yapılacak Personel'></td>
                            <cfset to_be_paid = last_month_emp_count + this_month_in.recordCount - this_month_out.recordCount - get_unpaid_leave.recordCount>
                            <td class="text-center">#to_be_paid#</td>
                            <td class="text-right">
                                <cfif not isDefined("this_month_in_sum.IN_BRUT_TOTAL") or not len(this_month_in_sum.IN_BRUT_TOTAL)>
                                    <cfset this_month_in_sum.IN_BRUT_TOTAL= 0>
                                </cfif>
                                <cfif not isDefined("this_month_out_sum.OUT_BRUT_TOTAL") or not len(this_month_out_sum.OUT_BRUT_TOTAL)>
                                    <cfset this_month_out_sum.OUT_BRUT_TOTAL= 0>
                                </cfif>
                                <cfif not isDefined("get_unpaid_leave_sum.LEAVE_BRUT_TOTAL") or not len(get_unpaid_leave_sum.LEAVE_BRUT_TOTAL)>
                                    <cfset get_unpaid_leave_sum.LEAVE_BRUT_TOTAL= 0>
                                </cfif>
                                <cfset total_pay_brut = last_month_brut + this_month_in_sum.IN_BRUT_TOTAL - this_month_out_sum.OUT_BRUT_TOTAL - get_unpaid_leave_sum.LEAVE_BRUT_TOTAL>
                                #TlFormat(total_pay_brut)# #session.ep.money#
                            </td>
                            <td class="text-right">
                                <cfif not isDefined("this_month_in_sum.IN_NET_TOTAL") or not len(this_month_in_sum.IN_NET_TOTAL)>
                                    <cfset this_month_in_sum.IN_NET_TOTAL= 0>
                                </cfif>
                                <cfif not isDefined("this_month_out_sum.OUT_NET_TOTAL") or not len(this_month_out_sum.OUT_NET_TOTAL)>
                                    <cfset this_month_out_sum.OUT_NET_TOTAL= 0>
                                </cfif>
                                <cfif not isDefined("get_unpaid_leave_sum.LEAVE_NET_TOTAL") or not len(get_unpaid_leave_sum.LEAVE_NET_TOTAL)>
                                    <cfset get_unpaid_leave_sum.LEAVE_NET_TOTAL= 0>
                                </cfif>
                                <cfset total_pay_net = last_month_net + this_month_in_sum.IN_NET_TOTAL - this_month_out_sum.OUT_NET_TOTAL - get_unpaid_leave_sum.LEAVE_NET_TOTAL>
                                #TlFormat(total_pay_net)# #session.ep.money#
                            </td>
                        </tr>
                    </cfoutput>
                </table>
                </br></br>
                <div class="form-group bold"><cf_get_lang dictionary_id='64973.Hastalık İzni Kullanan Personel Bilgileri'></div>
                <table id="tablo_alt_baslik">
                    <tr class="bold"> 
                        <td width="25"><cf_get_lang dictionary_id='48171.Sıra No'></td>
                        <td width="300"><cf_get_lang dictionary_id='55757.Adı Soyadı'></td>
                        <td><cf_get_lang dictionary_id='64974.Geçen Aylarda Kullandığı Hastalık İzni Süresi'></td>
                        <td><cf_get_lang dictionary_id='64975.Bu Ay Kullandığı Hastalık İzni Süresi'></td>
                        <td><cf_get_lang dictionary_id='64976.Toplam Hastalık İzni Süresi'></td>
                    </tr>
                    <cfif get_disease_leave.recordCount>
                        <cfoutput query="get_disease_leave"> 
                            <cfquery name="last_months_disease_leave" datasource="#dsn#">
                                SELECT
                                    SUM(DATEDIFF(D,OFFTIME.STARTDATE,OFFTIME.FINISHDATE))+1 AS LAST_MONTH_DISEASE_DAY
                                FROM
                                    OFFTIME
                                LEFT JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
                                LEFT JOIN EMPLOYEES ON OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
                                WHERE
                                    OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_disease_leave.EMPLOYEE_ID#"> AND
                                    OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND
                                    OFFTIME.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#"> AND 
                                    OFFTIME.IS_PUANTAJ_OFF = 0 AND
                                    SETUP_OFFTIME.EBILDIRGE_TYPE_ID = 1
                            </cfquery>
                            <tr>
                                <td>#currentrow#</td>
                                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                                <td>
                                    <cfif not len(last_months_disease_leave.LAST_MONTH_DISEASE_DAY)>
                                        <cfset last_months_disease_leave.LAST_MONTH_DISEASE_DAY= 0>
                                    </cfif>
                                    #last_months_disease_leave.LAST_MONTH_DISEASE_DAY#
                                </td>
                                <td>#THIS_MONTH_DISEASE_DAY#</td>
                                <td>
                                    <cfset total_disease_day= last_months_disease_leave.LAST_MONTH_DISEASE_DAY + THIS_MONTH_DISEASE_DAY>
                                    #total_disease_day#
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                        </tr>
                    </cfif>
                </table>
                </br></br>
                <div class="form-group bold"><cf_get_lang dictionary_id='64977.Göreve Başlayan Personel Bilgileri'></div>
                <table id="tablo_alt_baslik">
                    <tr class="bold">
                        <td width="25"><cf_get_lang dictionary_id='48171.Sıra No'></td>
                        <td><cf_get_lang dictionary_id='55757.Adı Soyadı'></td>
                        <td style="text-transform : capitalize">
                            <cfset unvan_= (lCase(getLang('','Unvan','54847')))>
                            <cfoutput>#unvan_#</cfoutput>
                        </td>
                    </tr>
                    <cfif this_month_in.recordCount>
                        <cfoutput query="this_month_in">
                            <tr>
                                <td>#currentrow#</td>
                                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                                <td>#POSITION_NAME#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                        </tr>
                    </cfif>
                </table>
                </br></br>
                <div class="form-group bold"><cf_get_lang dictionary_id='64978.Görevden Ayrılan Personel Bilgileri'></div>
                <table id="tablo_alt_baslik">
                    <tr class="bold">
                        <td width="25"><cf_get_lang dictionary_id='48171.Sıra No'></td>
                        <td><cf_get_lang dictionary_id='55757.Adı Soyadı'></td>
                        <td style="text-transform : capitalize">
                            <cfoutput>#unvan_#</cfoutput>
                        </td>
                    </tr>
                    <cfif this_month_out.recordCount>
                        <cfoutput query="this_month_out">
                            <tr>
                                <td>#currentrow#</td>
                                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                                <td>#POSITION_NAME#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                        </tr>
                    </cfif>
                </table>
                <div class="form-group"><cf_get_lang dictionary_id='64998.Bordro Kayıtlarına Uygundur, Kontrol Edilmiştir.'></div>
                </br></br>
                <table id="tablo_alt_baslik">
                    <cfoutput>
                        <tr class="bold">
                            <td style="border:none;border-left-style:hidden"></td>
                            <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'>(<cf_get_lang dictionary_id='64962.Maaş Mutemedi'>)</td>
                            <td><cf_get_lang dictionary_id='64961.Gerçekleştirme Görevlisi'></td>
                            <td><cf_get_lang dictionary_id='62976.Harcama Yetkilisi'></td>
                        </tr>
                        <tr>
                            <td class="bold"><cf_get_lang dictionary_id='55757.Adı Soyadı'></td>
                            <td><cfif len(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                            <td><cfif len(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                            <td><cfif len(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID)>#get_emp_info(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID,1,0)#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                        </tr>
                        <tr>
                            <td style="text-transform : capitalize" class="bold"><cfoutput>#unvan_#</cfoutput></td>
                            <td><cfif len(GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID)>#get_title_cmp.get_position_title(position_id: GET_PUANTAJ_PERSONAL.SALARY_SYNDIC_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                            <td><cfif len(GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID)>#get_title_cmp.get_position_title(position_id: GET_PUANTAJ_PERSONAL.FULFILLMENT_OFFICER_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                            <td><cfif len(GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID)>#get_title_cmp.get_position_title(position_id: GET_PUANTAJ_PERSONAL.EXPENSE_USER_POS_ID).TITLE#<cfelse><cf_get_lang dictionary_id='41461.Lütfen İlgili Şube Seçiniz'></cfif></td>
                        </tr>
                        <tr>
                            <td class="bold"><cf_get_lang dictionary_id='64960.Sistem Onay Tarih / Saati'></td>
                            <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                            <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                            <td>#dateFormat(now(),dateformat_style)# #timeFormat(now(),timeformat_style)#</td>
                        </tr>
                        <tr>
                            <td class="bold"><cf_get_lang dictionary_id='58957.İmza'></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </cfoutput>
                </table>
            </div>
        </div>
    </div>

</cf_box>