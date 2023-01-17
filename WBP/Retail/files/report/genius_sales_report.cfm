<cfparam name="attributes.branch_ids" default="">
<cfparam name="attributes.group_type" default="1">
<cfparam name="attributes.search_department_id" default="">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	BRANCH_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#merkez_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cf_report_list_search title="#getLang('','Satış Kontrol Raporu',61860)#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.genius_sales_report" method="post" name="search_">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">	
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check 
                                        query_name="get_departments_search"  
                                        name="search_department_id"
                                        option_text="#getLang('','Şube',57453)#" 
                                        width="180"
                                        option_name="department_head" 
                                        option_value="BRANCH_ID"
                                        filter="0"
                                        value="#attributes.search_department_id#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="group_type">
                                            <option value="1" <cfif attributes.group_type eq 1>selected</cfif>><cf_get_lang dictionary_id='35974.Şube Bazında'></option>
                                            <option value="2" <cfif attributes.group_type eq 2>selected</cfif>><cf_get_lang dictionary_id='62330.Kasa Bazında'></option>
                                            <option value="3" <cfif attributes.group_type eq 3>selected</cfif>><cf_get_lang dictionary_id='62331.Z Bazında'></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <cf_wrk_search_button button_type="1">
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>



<cfquery name="get_ciro_report" datasource="#dsn_dev#">
SELECT
    GROUP_NAME,
    FIS_TARIH,
    SUM(FIS_TOPLAM) AS FIS_TOPLAM,
    SUM(FIS_TOPLAM_KDV) AS FIS_TOPLAM_KDV,
    SUM(FIS_TOPLAM_INDIRIM) AS FIS_TOPLAM_INDIRIM,
    SUM(IADE_FIS_TOPLAM) AS IADE_FIS_TOPLAM,
    SUM(KARTLI_MUSTERI_TUTARI) AS KARTLI_MUSTERI_TUTARI_TOPLAM,
    SUM(KAZANILAN_PUAN) AS KAZANILAN_PUAN_TOPLAM,
    SUM(HARCANILAN_PUAN) AS HARCANILAN_PUAN_TOPLAM
FROM
	(
    SELECT
        <cfif attributes.group_type eq 1>
        	B.BRANCH_NAME AS GROUP_NAME,
        <cfelseif  attributes.group_type eq 2>
        	B.BRANCH_NAME + ' - ' + PE.EQUIPMENT_CODE AS GROUP_NAME,
        <cfelse>
        	B.BRANCH_NAME + ' - ' + PE.EQUIPMENT_CODE + ' - ' + GA.ZNO AS GROUP_NAME,
        </cfif>
        FIS_TOPLAM,
        FIS_TOPLAM_KDV,
        (FIS_PROMOSYON_INDIRIM + FIS_SATIR_ALTI_INDIRIM) AS FIS_TOPLAM_INDIRIM,
        0 AS IADE_FIS_TOPLAM,
        0 AS KARTLI_MUSTERI_TUTARI,
        KAZANILAN_PUAN,
        KULLANILAN_PUAN AS HARCANILAN_PUAN,
        CAST(DAY(FIS_TARIHI) AS NVARCHAR) + '/' + CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '/' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) AS FIS_TARIH
    FROM
        #dsn_alias#.BRANCH B,
        GENIUS_ACTIONS GA,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        <cfif not session.ep.ehesap>
            B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        <cfif isdefined("attributes.search_department_id") and len(attributes.search_department_id)>
        	B.BRANCH_ID IN (#attributes.search_department_id#) AND
        </cfif>
        GA.BELGE_TURU NOT IN ('2','P','L') AND
        GA.FIS_IPTAL = 0 AND
        PE.BRANCH_ID = B.BRANCH_ID AND
        PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
        GA.FIS_TARIHI >= #attributes.startdate# AND GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
UNION ALL
    SELECT
        <cfif attributes.group_type eq 1>
        	B.BRANCH_NAME AS GROUP_NAME,
        <cfelseif  attributes.group_type eq 2>
        	B.BRANCH_NAME + ' - ' + PE.EQUIPMENT_CODE AS GROUP_NAME,
        <cfelse>
        	B.BRANCH_NAME + ' - ' + PE.EQUIPMENT_CODE + ' - ' + GA.ZNO AS GROUP_NAME,
        </cfif>
        0 AS FIS_TOPLAM,
        0 AS FIS_TOPLAM_KDV,
        0 AS FIS_TOPLAM_INDIRIM,
        FIS_TOPLAM AS IADE_FIS_TOPLAM,
        0 AS KARTLI_MUSTERI_TUTARI,
        0 AS KAZANILAN_PUAN,
        0 AS HARCANILAN_PUAN,
        CAST(DAY(FIS_TARIHI) AS NVARCHAR) + '/' + CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '/' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) AS FIS_TARIH
    FROM
        #dsn_alias#.BRANCH B,
        GENIUS_ACTIONS GA,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        <cfif not session.ep.ehesap>
            B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        <cfif isdefined("attributes.search_department_id") and len(attributes.search_department_id)>
        	B.BRANCH_ID IN (#attributes.search_department_id#) AND
        </cfif>
        GA.BELGE_TURU = '2' AND
        GA.FIS_IPTAL = 0 AND
        PE.BRANCH_ID = B.BRANCH_ID AND
        PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
        GA.FIS_TARIHI >= #attributes.startdate# AND GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
UNION ALL
    SELECT
        <cfif attributes.group_type eq 1>
        	B.BRANCH_NAME AS GROUP_NAME,
        <cfelseif  attributes.group_type eq 2>
        	B.BRANCH_NAME + ' - ' + PE.EQUIPMENT_CODE AS GROUP_NAME,
        <cfelse>
        	B.BRANCH_NAME + ' - ' + PE.EQUIPMENT_CODE + ' - ' + GA.ZNO AS GROUP_NAME,
        </cfif>
        0 AS FIS_TOPLAM,
        0 AS FIS_TOPLAM_KDV,
        0 AS FIS_TOPLAM_INDIRIM,
        0 AS IADE_FIS_TOPLAM,
        FIS_TOPLAM AS KARTLI_MUSTERI_TUTARI,
        0 AS KAZANILAN_PUAN,
        0 AS HARCANILAN_PUAN,
        CAST(DAY(FIS_TARIHI) AS NVARCHAR) + '/' + CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '/' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) AS FIS_TARIH
    FROM
        #dsn_alias#.BRANCH B,
        GENIUS_ACTIONS GA,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        <cfif not session.ep.ehesap>
            B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        <cfif isdefined("attributes.search_department_id") and len(attributes.search_department_id)>
        	B.BRANCH_ID IN (#attributes.search_department_id#) AND
        </cfif>
        GA.MUSTERI_NO <> '' AND
        GA.BELGE_TURU <> '2' AND
        GA.FIS_IPTAL = 0 AND
        PE.BRANCH_ID = B.BRANCH_ID AND
        PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
        GA.FIS_TARIHI >= #attributes.startdate# AND GA.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
    ) AS T1
GROUP BY
    T1.GROUP_NAME,
    T1.FIS_TARIH
ORDER BY
    T1.GROUP_NAME,
    T1.FIS_TARIH
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='61506.Mağaza Adı'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='40624.Toplam Satış Tutarı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='62328.İndirimli Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id="61548.KDV'lİ İade Tutar"></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id="62329.KDV'li Net Tutar"></th>
                </tr>
            </thead>
            <tbody>
            <cfscript>
                indirimli_brut_kdvli_tutar = 0;
                brut_kdvli_tutar = 0;
                iskonto_tutar = 0;
                net_kdvli_tutar = 0;
                iade_tutar = 0;
                kartli_musteri_tutar = 0;
                kartli_musteri_sayisi = 0;
                musteri_sayisi = 0;
                puan_arti = 0;
                puan_eksi = 0;
                kdv_tutar = 0;
            </cfscript>
            <cfoutput query="get_ciro_report">
                <tr>
                    <td>#GROUP_NAME#</td>
                    <td>#FIS_TARIH#</td>
                    <td style="text-align:right;">#tlformat(FIS_TOPLAM)#<cfset brut_kdvli_tutar = brut_kdvli_tutar + (FIS_TOPLAM)></td>
                    <td style="text-align:right;">#tlformat(FIS_TOPLAM_INDIRIM)#<cfset indirimli_brut_kdvli_tutar = indirimli_brut_kdvli_tutar + (FIS_TOPLAM_INDIRIM)></td>
                    <td style="text-align:right;">#tlformat(IADE_FIS_TOPLAM)#<cfset iade_tutar = iade_tutar + IADE_FIS_TOPLAM></td>
                    <td style="text-align:right;">#tlformat(FIS_TOPLAM - IADE_FIS_TOPLAM)#<cfset net_kdvli_tutar = net_kdvli_tutar + FIS_TOPLAM - IADE_FIS_TOPLAM></td>
                </tr>
            </cfoutput>
            </tbody>
            <cfif get_ciro_report.recordcount>
            <tfoot>
                <cfoutput>
                    <tr>
                        <td colspan="2"><cf_get_lang dictionary_id='40302.Toplamlar'></td>
                        <td style="text-align:right;">#tlformat(brut_kdvli_tutar)#</td>
                        <td style="text-align:right;">#tlformat(indirimli_brut_kdvli_tutar)#</td>
                        <td style="text-align:right;">#tlformat(iade_tutar)#</td>
                        <td style="text-align:right;">#tlformat(net_kdvli_tutar)#</td>
                    </tr>
                </cfoutput>
            </tfoot>
            </cfif>
        </cf_grid_list>
    </cf_box>
</div>