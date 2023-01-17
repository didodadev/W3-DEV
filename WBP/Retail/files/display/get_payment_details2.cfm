<cfquery name="get_comp" datasource="#dsn#">
	SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
</cfquery>

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD ORDER BY PERIOD_YEAR ASC
</cfquery>

<cfquery name="get_bakiye_all" datasource="#dsn2#">
SELECT
	T1.*,
    T2.ACTION_DATE AS K_ACTION_DATE,
    T2.DUE_DATE AS K_DUE_DATE,
    T2.PAPER_NO AS K_PAPER_NO,
    T2.ACTION_NAME AS K_ACTION_NAME,
    T2.ACTION_VALUE AS K_ACTION_VALUE,
    T2.K_PROJECT_HEAD
FROM
	(
	<cfoutput query="get_periods">
    <cfif currentrow neq 1>
        UNION ALL
    </cfif>
        SELECT 
            ISNULL((SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = CR.PROJECT_ID),'Projesiz') AS PROJECT_HEAD,
            '#period_id#_' + CAST(CARI_ACTION_ID AS NVARCHAR) AS ISLEM_KOD,
            #period_id# AS PERIOD_ID,
            CR.*,
            ISNULL((SELECT SUM(CRR.RELATED_VALUE) FROM #dsn_dev_alias#.CARI_ROW_RELATIONS CRR WHERE CRR.OUT_CARI_ACTION_ID = CR.CARI_ACTION_ID AND CRR.PERIOD_ID_OUT = #period_id#),0) AS KAPATTIGI,
            CRR.RELATED_VALUE,
            CRR.ROW_ID,
            CRR.PERIOD_ID AS IN_PERIOD_ID,
            CRR.IN_CARI_ACTION_ID
        FROM 
            #dsn#_#period_year#_#our_company_id#.CARI_ROWS CR,
            #dsn_dev_alias#.CARI_ROW_RELATIONS CRR
        WHERE
            CR.TO_CMP_ID = #attributes.company_id# AND
            CR.CARI_ACTION_ID = CRR.OUT_CARI_ACTION_ID AND
            CRR.PERIOD_ID_OUT = #period_id#
    </cfoutput>
    ) T1,
    (
    <cfoutput query="get_periods">
    <cfif currentrow neq 1>
        UNION ALL
    </cfif>
        SELECT 
            ISNULL((SELECT PP.PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS PP WHERE PP.PROJECT_ID = CR.PROJECT_ID),'Projesiz') AS K_PROJECT_HEAD,
            #period_id# AS PERIOD_ID,
            CR.*,
            CRR.ROW_ID
        FROM 
            #dsn#_#period_year#_#our_company_id#.CARI_ROWS CR,
            #dsn_dev_alias#.CARI_ROW_RELATIONS CRR
        WHERE
            CR.FROM_CMP_ID = #attributes.company_id# AND
            CR.CARI_ACTION_ID = CRR.IN_CARI_ACTION_ID AND
            CRR.PERIOD_ID = #period_id#
    </cfoutput>
    ) T2
WHERE
	T1.ROW_ID = T2.ROW_ID
ORDER BY
    T1.DUE_DATE DESC,
    T1.CARI_ACTION_ID ASC,
    T2.K_PROJECT_HEAD ASC
</cfquery>

<cfsavecontent variable="content_">
    <cfoutput>
        <cf_get_lang dictionary_id='63807.İşlem Bazlı Hareket Dökümü'> : #get_comp.FULLNAME#
    </cfoutput>
</cfsavecontent>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#content_#" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57416.Proje'></th>            
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                    <th><cf_get_lang dictionary_id='61991.Evrak Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='63808.Kapattığı'></th>
                </tr>
            </thead>
            <tbody>
            <cfset toplam_kalan = 0>
            <cfset sira_ = 0>
                <cfoutput query="get_bakiye_all" group="ISLEM_KOD">
                <cfset sira_ = sira_ + 1>
                <tr>
                    <td>#sira_#</td>
                    <td>#project_head#</td>
                    <td>#paper_no#</td>
                    <td><a href="javascript://" onclick="$('##td_#sira_#').toggle();get_row_detail('#ISLEM_KOD#');" class="tableyazi">#ACTION_NAME#</a></td>
                    <td>#dateformat(action_date,'dd/mm/yyyy')#</td>
                    <td>#dateformat(due_date,'dd/mm/yyyy')#</td>
                    <td style="text-align:right;">#tlformat(ACTION_VALUE,2)#</td>
                    <td style="text-align:right;">#tlformat(KAPATTIGI,2)#</td>
                </tr>
                <tr>
                    <td colspan="7" id="td_#sira_#" style="display:none;">
                        <div id="div_#ISLEM_KOD#"></div>
                    </td>
                </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<script>
function get_row_detail(islem_kod)
{
	div_name = 'div_' + islem_kod;
	AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_payment_details&islem_kod=' + islem_kod,div_name)
}
</script>