<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.keyword" default="">
<cfset dahil_olmayan_uyeler = "510">
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(now())#-1-1')>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = now()>	
</cfif>

<cfset bu_ay_basi_ = createodbcdatetime(createdate(year(now()),month(now()),1))>

<cfquery name="get_comps" datasource="#dsn#">
SELECT
    *
FROM
	(
    SELECT
        *,
        ISNULL((SELECT SUM(IFR.FF_NET) FROM #dsn_dev_alias#.INVOICE_FF_ROWS IFR WHERE IFR.STATUS = 1 AND IFR.COMP_CODE = T1.COMP_CODE),0) FF_TOPLAM,
        ISNULL((SELECT SUM(IRR.REVENUE_NET) FROM #dsn_dev_alias#.INVOICE_REVENUE_ROWS IRR WHERE IRR.STATUS = 1 AND IRR.COMP_CODE = T1.COMP_CODE),0) REVENUE_TOPLAM,
        ISNULL((SELECT SUM(IFR.FF_PAID) FROM #dsn_dev_alias#.INVOICE_FF_ROWS IFR WHERE IFR.STATUS = 1 AND IFR.COMP_CODE = T1.COMP_CODE),0) FF_TOPLAM_P,
        ISNULL((SELECT SUM(IFR.FF_NET - IFR.FF_PAID) FROM #dsn_dev_alias#.INVOICE_FF_ROWS IFR WHERE IFR.STATUS = 1 AND IFR.COMP_CODE = T1.COMP_CODE AND ISNULL(IFR.FF_PAID,0) < IFR.FF_NET AND IFR.INVOICE_DATE >= #bu_ay_basi_#),0) FF_LATER,
        ISNULL((SELECT SUM(IRR.REVENUE_PAID) FROM #dsn_dev_alias#.INVOICE_REVENUE_ROWS IRR WHERE IRR.STATUS = 1 AND IRR.COMP_CODE = T1.COMP_CODE),0) REVENUE_TOPLAM_P,
        ISNULL((
        	SELECT 
            	SUM(IRR.REVENUE_NET - IRR.REVENUE_PAID) 
            FROM 
            	#dsn_dev_alias#.INVOICE_REVENUE_ROWS IRR 
            WHERE 
            	IRR.STATUS = 1 AND 
                IRR.COMP_CODE = T1.COMP_CODE AND 
                ISNULL(IRR.REVENUE_PAID,0) < IRR.REVENUE_NET AND 
                (
                    (
                    IRR.REVENUE_PERIOD = 1 AND
                    IRR.INVOICE_DATE >= #bu_ay_basi_#
                    )
                   	OR
                    (
                    IRR.REVENUE_PERIOD = 3 AND
                    MONTH(IRR.INVOICE_DATE) IN (1,2,3) AND
                    IRR.INVOICE_DATE < #CREATEODBCDATETIME(CREATEDATE(session.ep.period_year,4,1))#
                    )
                    OR
                    (
                    IRR.REVENUE_PERIOD = 3 AND
                    MONTH(IRR.INVOICE_DATE) IN (4,5,6) AND
                    IRR.INVOICE_DATE < #CREATEODBCDATETIME(CREATEDATE(session.ep.period_year,7,1))#
                    )
                    OR
                    (
                    IRR.REVENUE_PERIOD = 3 AND
                    MONTH(IRR.INVOICE_DATE) IN (7,8,9) AND
                    IRR.INVOICE_DATE < #CREATEODBCDATETIME(CREATEDATE(session.ep.period_year,10,1))#
                    )
                    OR
                    (
                    IRR.REVENUE_PERIOD = 3 AND
                    MONTH(IRR.INVOICE_DATE) IN (10,11,12) AND
                    IRR.INVOICE_DATE <= #CREATEODBCDATETIME(CREATEDATE(session.ep.period_year,12,31))#
                    )
                )
           ),0) REVENUE_LATER,
        ISNULL((SELECT SUM(PR.COST) FROM #dsn_dev_alias#.PROCESS_ROWS PR WHERE PR.STATUS = 1 AND CAST(PR.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(PR.PROJECT_ID,0) AS NVARCHAR) = T1.COMP_CODE AND PR.PAYMENT_DATE > #attributes.finishdate# AND PR.COST IS NOT NULL AND PR.COST > 0 AND ISNULL(PR.COST_PAID,0) < PR.COST),0) UYGULAMA_LATER,
        ISNULL((SELECT SUM(PR.COST) FROM #dsn_dev_alias#.PROCESS_ROWS PR WHERE PR.STATUS = 1 AND CAST(PR.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(PR.PROJECT_ID,0) AS NVARCHAR) = T1.COMP_CODE AND PR.COST IS NOT NULL AND PR.COST > 0),0) UYGULAMA_ALL,
        ISNULL((SELECT SUM(PR.COST_PAID) FROM #dsn_dev_alias#.PROCESS_ROWS PR WHERE PR.STATUS = 1 AND CAST(PR.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(PR.PROJECT_ID,0) AS NVARCHAR) = T1.COMP_CODE AND PR.COST_PAID IS NOT NULL AND PR.COST_PAID > 0),0) UYGULAMA_P
    FROM
        (
            SELECT
                CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(0 AS NVARCHAR) AS COMP_CODE,
                0 AS PROJECT_ID,
                C.COMPANY_ID,
                C.NICKNAME AS TEDARIKCI_ADI,
                '' AS PROJE_ADI,
                C.MEMBER_CODE,
                C.CITY,
                CC.COMPANYCAT,
                ISNULL((SELECT top 1  PROPERTY1 FROM INFO_PLUS WHERE INFO_OWNER_TYPE = -1 AND OWNER_ID = C.COMPANY_ID AND PROPERTY1 <> ''),'Hayır') AS LISTEDE_GETIRME
            FROM
                COMPANY C,
                COMPANY_CAT CC
            WHERE
                C.COMPANY_ID NOT IN (#dahil_olmayan_uyeler#) AND
                C.FULLNAME LIKE '%#attributes.keyword#%' AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID 
		
        UNION ALL
            SELECT
                CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(PP.PROJECT_ID AS NVARCHAR) AS COMP_CODE,
                PP.PROJECT_ID,
                C.COMPANY_ID,
                C.NICKNAME TEDARIKCI_ADI,
                PP.PROJECT_HEAD AS PROJE_ADI,
                C.MEMBER_CODE,
                C.CITY,
                CC.COMPANYCAT,
                ISNULL((SELECT top 1 PROPERTY1 FROM INFO_PLUS WHERE INFO_OWNER_TYPE = -1 AND OWNER_ID = C.COMPANY_ID AND PROPERTY1 <> ''),'Hayır') AS LISTEDE_GETIRME
            FROM
                COMPANY C,
                COMPANY_CAT CC,
                PRO_PROJECTS PP
            WHERE
                C.FULLNAME + ' - ' + PP.PROJECT_HEAD LIKE '%#attributes.keyword#%' AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                C.COMPANY_ID = PP.COMPANY_ID
        ) 
        T1
     ) 
     T2
WHERE
	LISTEDE_GETIRME = 'Hayır' AND
    (FF_TOPLAM > 0 OR  REVENUE_TOPLAM > 0 OR UYGULAMA_ALL > 0)
ORDER BY
    T2.TEDARIKCI_ADI ASC,
    T2.PROJE_ADI ASC
</cfquery>



<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_comps.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>



<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <cf_box_search>
                    <div class="form-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id ='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" id="keyword" placeholder="#message#" style="width:75px;" value="#attributes.keyword#" maxlength="500">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" >
                    </div>
                </cf_box_search>
            </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61476.Havuz İcmali'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='58061.Cari'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th>	
                    <th style="text-align:right;">Hv T.</th>
                    <th style="text-align:right;">Hv Fat Ed</th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61513.Havuz Bakiye'></th>
                    <th style="text-align:right;">Bitmemiş Dev. E. Uy.</th>
                    <th style="text-align:right;">Bitmiş Fat. Kesilmemiş</th>
                </tr>
            </thead>
            <cfset h_toplam = 0>
            <cfset kesilmis_toplam = 0>
            <cfset bakiye_toplam = 0>
            <cfset sonraki_toplam = 0>
            <cfset bitmis_kesilmemis_toplam = 0>
            <cfsavecontent variable="body_">
                <cfoutput query="get_comps">
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=retail.periodic_apps_comps&cpid=#company_id#&project_id=#PROJECT_ID#" class="tableyazi" target="member_screen">#TEDARIKCI_ADI#</a></td>
                        <td><a href="#request.self#?fuseaction=retail.periodic_apps_comps&cpid=#company_id#&project_id=#PROJECT_ID#" class="tableyazi" target="member_screen">#PROJE_ADI#</a></td>
                        <td>
                            <cfif isdefined("SIFIR_BEDELLI_#COMP_CODE#")>
                                *
                            </cfif>
                        </td>
                        <td style="text-align:right;" title="Uygulamalar:#tlformat(UYGULAMA_ALL)# Fiyat Farkları:#tlformat(FF_TOPLAM)# Ciro:#tlformat(REVENUE_TOPLAM)#">
                            <cfset row_havuz_total = FF_TOPLAM + REVENUE_TOPLAM + UYGULAMA_ALL>
                            #tlformat(row_havuz_total)#
                        </td>
                        <td style="text-align:right;">
                            <cfset row_kesilmis_ = FF_TOPLAM_P + REVENUE_TOPLAM_P + UYGULAMA_P>
                            #tlformat(row_kesilmis_)#
                        </td>
                        <td style="text-align:right;">
                           #tlformat(row_havuz_total - row_kesilmis_)#
                        </td>
                        <td style="text-align:right;" title="Uygulamalar:#tlformat(UYGULAMA_LATER)# Fiyat Farkları:#tlformat(FF_LATER)# Ciro:#tlformat(REVENUE_LATER)#">
                            #tlformat(UYGULAMA_LATER+FF_LATER+REVENUE_LATER)#
                        </td>
                        <td style="text-align:right;">
                              #tlformat(row_havuz_total - row_kesilmis_ - (UYGULAMA_LATER+FF_LATER+REVENUE_LATER))#
                        </td>
                    </tr>
                    <cfset h_toplam = h_toplam + row_havuz_total>
                    <cfset kesilmis_toplam = kesilmis_toplam + row_kesilmis_>
                    <cfset bakiye_toplam = bakiye_toplam + row_havuz_total - row_kesilmis_>
                    <cfset sonraki_toplam = sonraki_toplam + (UYGULAMA_LATER+FF_LATER+REVENUE_LATER)>
                    <cfset bitmis_kesilmemis_toplam = bitmis_kesilmemis_toplam + row_havuz_total - row_kesilmis_ - (UYGULAMA_LATER+FF_LATER+REVENUE_LATER)>
                </cfoutput>
            </cfsavecontent>
            <cfoutput>
            <tbody>       
            <tr>
                <td style="text-align:right"></td>
                <td style="text-align:right"></td>
                <td style="text-align:right">Toplamlar</td>
                <td style="text-align:right">#tlformat(h_toplam)#</td>
                <td style="text-align:right">#tlformat(kesilmis_toplam)#</td>
                <td style="text-align:right">#tlformat(bakiye_toplam)#</td>
                <td style="text-align:right">#tlformat(sonraki_toplam)#</td>
                <td style="text-align:right">#tlformat(bitmis_kesilmemis_toplam)#</td>
            </tr>
            #body_#
            </tbody>
            </cfoutput>
        </cf_grid_list>

    </cf_box>

</div>
       
