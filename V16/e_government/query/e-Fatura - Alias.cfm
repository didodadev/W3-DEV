<!---
    File: 
    Folder: 
	Controller: 
    Author:
    Date:
    Description:
        Bu rapor ile üye detayında yer alan şube kodu&alias tanımlamaları kontrol edilir.
    History:
        
    To Do:

--->

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_einv_comp_min_efaturadate" datasource="#DSN#">
    SELECT MIN(EFATURA_DATE) AS date
    FROM COMPANY
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_EINV_COMP" datasource="#DSN#">
        WITH CTE1 AS (
            SELECT 
                C.COMPANY_ID,
                C.MEMBER_CODE,
                C.OZEL_KOD,
                C.FULLNAME,
                C.TAXNO,
                C.EFATURA_DATE,
                T1.ALIAS_COUNT,
                COUNT(CCOC.COMPANYCAT_ID) AS CC_COUNT,
                COUNT(CB.COMPBRANCH_ID) AS CB_COUNT,
                COUNT(CB.COMPBRANCH_ALIAS) AS CB_ALIAS_COUNT
            FROM
                COMPANY_CAT CC
                LEFT JOIN COMPANY_CAT_OUR_COMPANY CCOC ON CCOC.COMPANYCAT_ID = CC.COMPANYCAT_ID AND CCOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,        
                COMPANY C
                LEFT JOIN COMPANY_BRANCH CB ON CB.COMPANY_ID = C.COMPANY_ID AND CB.COMPBRANCH_STATUS = 1,
                (SELECT TAX_NO, COUNT(ALIAS) AS ALIAS_COUNT FROM EINVOICE_COMPANY_IMPORT GROUP BY TAX_NO HAVING COUNT(TAX_NO) > 1) AS T1
            WHERE
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                C.TAXNO = T1.TAX_NO 
                <cfif len(attributes.date1)>
                    AND	C.EFATURA_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(attributes.date1,'dd/mm/yyyy')#"> 
                </cfif>
                <cfif len(attributes.date2)>
                    AND C.EFATURA_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(attributes.date2,'dd/mm/yyyy')#">
                </cfif>
            <cfif len(attributes.keyword)>
                AND (C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR C.TAXNO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif>
            GROUP BY
                C.COMPANY_ID,
                C.MEMBER_CODE,
                C.OZEL_KOD,
                C.FULLNAME,
                C.TAXNO,
                C.EFATURA_DATE,
                T1.ALIAS_COUNT
        ),
        CTE2 AS (
                SELECT
                    CTE1.*,
                    ROW_NUMBER() OVER (	ORDER BY FULLNAME
                                    ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                    CTE1
            )
            SELECT
                CTE2.*
            FROM
                CTE2
            WHERE
                RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
	<cfparam name="attributes.totalrecords" default='#get_einv_comp.query_count#'>
<cfelse>
	<cfset get_einv_comp.recordcount =0>
</cfif>
<cf_basket_form>
	<cfform name="search_form" action="#request.self#?fuseaction=#attributes.fuseaction#&event=det&report_id=#attributes.report_id#" method="post">
        <table>
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <tr>
            	<td><cf_get_lang_main no='48.Filtre'></td>
                <td><cfsavecontent variable="key_title"><cf_get_lang_main no='162.Şirket'>,<cf_get_lang_main no='340.Vergi No'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" title="#key_title#" value="#attributes.keyword#" style="width:150px;"></td>
                <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </td>
                <td><cf_wrk_search_button button_type='1' is_excel="0" add_function=date_control()></td>
                <td>
   					Mükellef Kayıt Tarihi: <cfinput type="text" name="date1" id="date1" value="#dateformat(attributes.date1, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:75px;">
					<cfif not isdefined('attributes.ajax')>
                        <cf_wrk_date_image date_field="date1"> / 
                    </cfif>
                    <cfinput type="text" name="date2" id="date2" value="#dateformat(attributes.date2, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" style="width:75px;">
                    <cfif not isdefined('attributes.ajax')>
                     <cf_wrk_date_image date_field="date2">
                    </cfif>
				</td>
            </tr>
        </table>
    </cfform>
</cf_basket_form>
<cf_basket>
	<cf_wrk_html_table class="detail_basket_list">
    	<cf_wrk_html_thead>
        	<cf_wrk_html_tr>
            	<cf_wrk_html_th width="35"><cf_get_lang_main no='1165.Sıra'></cf_wrk_html_th>
                <cf_wrk_html_th><cf_get_lang_main no='146.Üye No'></cf_wrk_html_th>
                <cf_wrk_html_th><cf_get_lang_main no='377.Özel Kod'></cf_wrk_html_th>
                <cf_wrk_html_th><cf_get_lang_main no='162.Şirket'></cf_wrk_html_th>
                <cf_wrk_html_th><cf_get_lang_main no='340.Vergi No'></cf_wrk_html_th>
                <cf_wrk_html_th>Alias Sayısı</cf_wrk_html_th>
                <cf_wrk_html_th>Şube Sayısı</cf_wrk_html_th>
                <cf_wrk_html_th>Şube Alias Kullanım Sayısı</cf_wrk_html_th>
                <cf_wrk_html_th>Mükellef Kayıt Tarihi</cf_wrk_html_th>
            </cf_wrk_html_tr>
        </cf_wrk_html_thead>
        <cf_wrk_html_tbody>
        	<cfif isdefined("get_einv_comp") and get_einv_comp.recordcount>
            	<cfoutput query="get_einv_comp">
                	<cf_wrk_html_tr>
                    	<cf_wrk_html_td width="35">#rownum#</cf_wrk_html_td>
                        <cf_wrk_html_td>#member_code#</cf_wrk_html_td>
                        <cf_wrk_html_td>#ozel_kod#</cf_wrk_html_td>
                        <cf_wrk_html_td><cfif cc_count><a href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#company_id#" class="tableyazi" target="_blank">#fullname#</a><cfelse>#fullname#</cfif></cf_wrk_html_td>
                        <cf_wrk_html_td>#taxno#</cf_wrk_html_td>
                        <cf_wrk_html_td>#alias_count#</cf_wrk_html_td>
                        <cf_wrk_html_td>#cb_count#</cf_wrk_html_td>
                        <cf_wrk_html_td>#cb_alias_count#</cf_wrk_html_td>
                        <cf_wrk_html_td>#dateformat(get_einv_comp.efatura_date, 'dd/mm/yyyy')#</cf_wrk_html_td>
                    </cf_wrk_html_tr>
				</cfoutput>
           	<cfelse>
            	<cf_wrk_html_tr>
                	<cf_wrk_html_td colspan="9">
                		<cfif isdefined("attributes.form_submitted") and get_einv_comp.recordcount eq 0><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif>
                	</cf_wrk_html_td>
                </cf_wrk_html_tr>
            </cfif>
        </cf_wrk_html_tbody>
    </cf_wrk_html_table>
</cf_basket>
<cfif isdefined("attributes.form_submitted")>
	<cfif get_einv_comp.recordcount and (attributes.maxrows lt attributes.totalrecords)>
        <cfset url_str = "#attributes.fuseaction#&event=det&report_id=#attributes.report_id#&form_submitted=1">
        <cfif Len(attributes.date1)><cfset url_str = "#url_str#&date1=#attributes.date1#"></cfif>
        <cfif Len(attributes.date2)><cfset url_str = "#url_str#&date2=#attributes.date2#"></cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_str#">
    </cfif>
</cfif>