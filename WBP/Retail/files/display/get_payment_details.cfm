<cfparam name="attributes.startdate" default="#createodbcdatetime(createdate(session.ep.period_year,1,1))#">
<cf_date tarih = "attributes.startdate">
<cf_date tarih = "attributes.finishdate">

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD ORDER BY PERIOD_YEAR ASC
</cfquery>

<cfif isdefined("attributes.islem_kod")>
	<cfset period_ = listgetat(attributes.islem_kod,1,'_')>
    <cfset cari_row_id_ = listgetat(attributes.islem_kod,2,'_')>
    
    <cfquery name="get_period" dbtype="query">
    	SELECT * FROM get_periods WHERE PERIOD_ID = #period_#
    </cfquery>
    
    <cfquery name="get_islem" datasource="#dsn#">
    	SELECT
        	C.FULLNAME,
            C.COMPANY_ID,
            ISNULL((SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = CR.PROJECT_ID),'') AS PROJECT_HEAD,
            CR.*
        FROM
        	COMPANY C,
            #dsn#_#get_period.period_year#_#get_period.our_company_id#.CARI_ROWS CR
       	WHERE
        	C.COMPANY_ID = CR.TO_CMP_ID AND
            CR.CARI_ACTION_ID = #cari_row_id_#
    </cfquery>
    <cfset get_comp.FULLNAME = get_islem.FULLNAME>
    <cfset attributes.company_id = get_islem.company_id>
    <cfset attributes.finishdate = createodbcdatetime(get_islem.due_date)>
<cfelse>
    <cfquery name="get_comp" datasource="#dsn#">
        SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
    </cfquery>
</cfif>

<cfquery name="get_bakiye_all" datasource="#dsn2#">
    SELECT
        *
    FROM
        (
        <cfoutput query="get_periods">
        <cfif currentrow neq 1>
            UNION ALL
        </cfif>
            SELECT 
                ISNULL((SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = CR.PROJECT_ID),'Projesiz') AS PROJECT_HEAD,
                #period_id# AS PERIOD_ID,
                CR.*,
                ISNULL(
                	(
                    	SELECT 
                        	SUM(CRR.RELATED_VALUE) 
                        FROM 
                        	#dsn_dev_alias#.CARI_ROW_RELATIONS CRR 
                        WHERE 
                        	CRR.IN_CARI_ACTION_ID = CR.CARI_ACTION_ID AND 
                            CRR.PERIOD_ID = #period_id#
                            <cfif isdefined("attributes.islem_kod")>
                             AND   
                             	CRR.OUT_CARI_ACTION_ID = #cari_row_id_# 
                             AND
                                CRR.PERIOD_ID_OUT = #period_#
                            </cfif>
                   ),0) AS KAPATILAN
            FROM 
                #dsn#_#period_year#_#our_company_id#.CARI_ROWS CR
            WHERE
                CR.ACTION_DATE <= #attributes.finishdate# AND
                CR.FROM_CMP_ID = #attributes.company_id#
                <cfif period_year neq 2014>
                    AND CR.ACTION_TYPE_ID <> 40
                </cfif>
                AND CR.ACTION_TYPE_ID NOT IN (24,240)
        </cfoutput>
        ) T1
    WHERE
        <cfif isdefined("attributes.islem_kod")>
        	CAST(T1.PERIOD_ID AS NVARCHAR) + '_' + CAST(T1.CARI_ACTION_ID AS NVARCHAR)
            	IN
                (
                	SELECT
                    	CAST(CRR.PERIOD_ID AS NVARCHAR) + '_' + CAST(CRR.IN_CARI_ACTION_ID AS NVARCHAR)
                    FROM
                    	#dsn_dev_alias#.CARI_ROW_RELATIONS CRR
                    WHERE
                    	CRR.OUT_CARI_ACTION_ID = #cari_row_id_# AND
                        CRR.PERIOD_ID_OUT = #period_#
                )
             AND
            	KAPATILAN > 0
        <cfelse>
            ROUND(ACTION_VALUE,2) > ROUND(KAPATILAN,2)
        </cfif>
    ORDER BY
        PROJECT_HEAD ASC,
        DUE_DATE ASC,
        PERIOD_ID ASC
</cfquery>


<cfsavecontent variable="content_">
    <cfoutput>
        <cf_get_lang dictionary_id='63806.Hareket Dökümü'> : #get_comp.FULLNAME# - (#dateformat(attributes.startdate,'dd/mm/yyyy')# - #dateformat(attributes.finishdate,'dd/mm/yyyy')#)
    </cfoutput>
</cfsavecontent>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#content_#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                    <th><cf_get_lang dictionary_id='61991.Evrak Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57640.Vade'></th>
                    <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                    <th><cf_get_lang dictionary_id='54821.Ödeme Günü'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58661.Kapatılan'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
                </tr>
            </thead>
            <tbody>
            <cfset toplam_kalan = 0>
            <cfset grand_e_total = 0>
            <cfset grand_e_base_total = 0>
            
            <cfset grand_v_total = 0>
            <cfset grand_v_base_total = 0>
            
                <cfoutput query="get_bakiye_all" group="PROJECT_HEAD">
                <cfset toplam_p_kalan = 0>
                <cfset p_grand_e_total = 0>
                <cfset p_grand_e_base_total = 0>
                
                <cfset p_grand_v_total = 0>
                <cfset p_grand_v_base_total = 0>
                
                    <cfoutput>
                    
                    <cfif isdefined("attributes.islem_kod")>
                        <cfset deger_ = KAPATILAN>
                    <cfelse>
                        <cfset deger_ = (ACTION_VALUE - KAPATILAN)>
                    </cfif>
                    
                    <cfset fark_ = Ceiling(datediff('d',attributes.startdate,action_date))>
                    <cfset p_grand_e_total = p_grand_e_total + deger_>
                    <cfset p_grand_e_base_total = p_grand_e_base_total + (deger_ * fark_)>
                    
                    <cfset fark_ = Ceiling(datediff('d',attributes.startdate,due_date))>
                    <cfset p_grand_v_total = p_grand_v_total + deger_>
                    <cfset p_grand_v_base_total = p_grand_v_base_total + (deger_ * fark_)>
                    
                    <cfset fark_ = Ceiling(datediff('d',attributes.startdate,action_date))>
                    <cfset grand_e_total = grand_e_total + deger_>
                    <cfset grand_e_base_total = grand_e_base_total + (deger_ * fark_)>
                    
                    <cfset fark_ = Ceiling(datediff('d',attributes.startdate,due_date))>
                    <cfset grand_v_total = grand_v_total + deger_>
                    <cfset grand_v_base_total = grand_v_base_total + (deger_ * fark_)>
                    <tr>
                        <td>#currentrow#</td>
                        <td>#PROJECT_HEAD#</td>
                        <td>#paper_no#</td>
                        <td>#ACTION_NAME#</td>
                        <td>#dateformat(action_date,'dd/mm/yyyy')#</td>
                        <td>#datediff("d",action_date,due_date)#</td>
                        <td>#dateformat(due_date,'dd/mm/yyyy')#</td>
                        <td><cfif isdefined("attributes.islem_kod")>#dateformat(get_islem.due_date,'dd/mm/yyyy')#</cfif></td>
                        <td style="text-align:right">#tlformat(ACTION_VALUE,2)#</td>
                        <td style="text-align:right">#tlformat(KAPATILAN,2)#</td>
                        <td style="text-align:right">#tlformat(ACTION_VALUE - KAPATILAN,2)#</td>
                    </tr>
                    <cfset toplam_kalan = toplam_kalan + deger_>
                    <cfset toplam_p_kalan = toplam_p_kalan + deger_>
                    </cfoutput>
                    <tr>
                        <td colspan="4" class="formbold" style="text-align:right">#PROJECT_HEAD# Toplam Bakiye</td>
                        <td class="formbold" >
                            <cfset ortalama_evrak_gunu_ = Ceiling(p_grand_e_base_total / p_grand_e_total)>
                            <cfset ortalama_evrak_tarihi_ = dateadd('d',ortalama_evrak_gunu_,attributes.startdate)>
                            #dateformat(ortalama_evrak_tarihi_,'dd/mm/yyyy')#
                        </td>
                        <td class="formbold" >
                            <cfset ortalama_vade_gunu_ = Ceiling(p_grand_v_base_total / p_grand_v_total)>
                            <cfset ortalama_vade_tarihi_ = dateadd('d',ortalama_vade_gunu_,attributes.startdate)>
                        </td>
                        <td class="formbold" style="text-align:right">#dateformat(ortalama_vade_tarihi_,'dd/mm/yyyy')#</td>
                        <td class="formbold" ><cfif isdefined("attributes.islem_kod")>#dateformat(get_islem.due_date,'dd/mm/yyyy')#</cfif></td>
                        <td colspan="3" class="formbold" style="text-align:right">#tlformat(toplam_p_kalan,2)#</td>
                    </tr>
                </cfoutput>
                <cfoutput>
                <cfif grand_e_total gt 0>
                <tr>
                    <td colspan="4" class="formbold" style="text-align:right">Toplam Bakiye</td>
                    <td class="formbold" >
                        <cfset ortalama_evrak_gunu_ = Ceiling(grand_e_base_total / grand_e_total) + 1>
                        <cfset ortalama_evrak_tarihi_ = dateadd('d',ortalama_evrak_gunu_,attributes.startdate)>
                        #dateformat(ortalama_evrak_tarihi_,'dd/mm/yyyy')#
                    </td>
                    <td class="formbold" >
                        <cfset ortalama_vade_gunu_ = Ceiling(grand_v_base_total / grand_v_total) + 1>
                        <cfset ortalama_vade_tarihi_ = dateadd('d',ortalama_vade_gunu_,attributes.startdate)>
                    </td>
                    <td class="formbold" style="text-align:right">#dateformat(ortalama_vade_tarihi_,'dd/mm/yyyy')#</td>
                    <td class="formbold" ><cfif isdefined("attributes.islem_kod")>#dateformat(get_islem.due_date,'dd/mm/yyyy')#</cfif></td>
                    <td colspan="3" class="formbold" style="text-align:right">#tlformat(toplam_kalan,2)#</td>
                </tr>
                </cfif>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

