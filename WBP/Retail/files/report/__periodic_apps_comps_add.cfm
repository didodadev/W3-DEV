<cfif not isdefined("attributes.checked_row")>
	<script>
		alert('İşlem Satırı Seçmelisiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>

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

<cfquery name="get_comp" datasource="#dsn#">
SELECT
    *
FROM
	(
        <cfif isdefined("attributes.project_id") and len(attributes.project_id) and attributes.project_id neq 0>
        	SELECT
                CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(PP.PROJECT_ID AS NVARCHAR) AS COMP_CODE,
                PP.PROJECT_ID,
                C.COMPANY_ID,
                C.NICKNAME TEDARIKCI_ADI,
                PP.PROJECT_HEAD AS PROJE_ADI,
                C.MEMBER_CODE,
                C.CITY,
                CC.COMPANYCAT
            FROM
                COMPANY C,
                COMPANY_CAT CC,
                PRO_PROJECTS PP
            WHERE
                C.COMPANY_ID = #attributes.cpid# AND
                PP.PROJECT_ID = #attributes.project_id# AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                C.COMPANY_ID = PP.COMPANY_ID
        <cfelse>
        	SELECT
                CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(0 AS NVARCHAR) AS COMP_CODE,
                0 AS PROJECT_ID,
                C.COMPANY_ID,
                C.NICKNAME AS TEDARIKCI_ADI,
                '' AS PROJE_ADI,
                C.MEMBER_CODE,
                C.CITY,
                CC.COMPANYCAT
            FROM
                COMPANY C,
                COMPANY_CAT CC
            WHERE
                C.COMPANY_ID = #attributes.cpid# AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                C.COMPANY_ID NOT IN (SELECT PP.COMPANY_ID FROM PRO_PROJECTS PP WHERE PP.COMPANY_ID IS NOT NULL)
        </cfif>
        ) 
        T1
ORDER BY
    T1.TEDARIKCI_ADI ASC,
    T1.PROJE_ADI ASC
</cfquery>



<cfquery name="get_donemsel_rows" datasource="#dsn_dev#">
	SELECT
    	'0' AS TYPE,
        CAST(PROCESS_TYPE AS NVARCHAR) AS ACTION_TYPE,
        TAX AS VERGI,
        ROW_ID AS ACTION_ID,
        RECORD_DATE,
        (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = PROCESS_ROWS.DEPARTMENT_ID) AS DEPARTMENT_HEAD,
        (SELECT PC.TYPE_NAME FROM SEARCH_TABLE_PROCESS_TYPES PC WHERE PC.TYPE_ID = PROCESS_ROWS.PROCESS_TYPE) AS TIP,
        COST AS BRUT,
        PROCESS_DETAIL,
        QUANTITY,
        CAST(PERIOD AS NVARCHAR) AS PERIOD,     
        PROCESS_STARTDATE,
        PROCESS_FINISHDATE,
        ACTION_STARTDATE,
        ACTION_FINISHDATE,
        PAYMENT_DATE,
        PAID_DATE,
        COST,
        ISNULL(COST_PAID,0) ODENEN,
        CAST(ROW_ID AS NVARCHAR) AS ACTION_NO,
        '' AS FATURA_NO,
        '' AS PRODUCT_CODE,
        (SELECT PC.TYPE_NAME FROM SEARCH_TABLE_PROCESS_TYPES PC WHERE PC.TYPE_ID = PROCESS_ROWS.PROCESS_TYPE) AS PROPERTY
    FROM
    	PROCESS_ROWS
    WHERE
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
        PROJECT_ID = #attributes.project_id# AND
        </cfif>
    	COMPANY_ID = #attributes.cpid# AND
        COST <> 0
	ORDER BY 
    	PROCESS_STARTDATE ASC
</cfquery>

<cfquery name="get_ff_rows" datasource="#dsn_dev#">
	SELECT 
    	'2' AS TYPE,
        CAST(IFR.FF_TYPE AS NVARCHAR) AS ACTION_TYPE,
        P.TAX_PURCHASE AS VERGI,
        IFR.FF_ROW_ID AS ACTION_ID,
        IFR.INVOICE_DATE AS RECORD_DATE,
        '' AS DEPARTMENT_HEAD,
        CASE 
        	WHEN IFR.FF_TYPE = 0 THEN 'Fiyat Farkı'
            WHEN IFR.FF_TYPE = 1 THEN 'Kasa Çıkışı'
            ELSE 'Diğer' END AS TIP,
        IFR.FF_GROSS * IFR.AMOUNT AS BRUT,
        '' AS PROCESS_DETAIL,
        AMOUNT AS QUANTITY,
        '1' AS PERIOD,
        INVOICE_DATE AS PROCESS_STARTDATE,
        INVOICE_DATE AS PROCESS_FINISHDATE,
        GETDATE() AS ACTION_STARTDATE,
        GETDATE() AS ACTION_FINISHDATE,
        GETDATE() AS PAYMENT_DATE,
        PAID_DATE,
        FF_NET AS COST,
        FF_PAID AS ODENEN,
        CAST(IFR.FF_ROW_ID AS NVARCHAR) AS ACTION_NO,
        IFR.INVOICE_NUMBER AS FATURA_NO,
        P.PRODUCT_CODE,
        S.PROPERTY
    FROM 
    	INVOICE_FF_ROWS IFR,
        #dsn1_alias#.STOCKS S,
        #dsn1_alias#.PRODUCT P        
    WHERE 
    	COMP_CODE = '#get_comp.COMP_CODE#' AND
        IFR.STOCK_ID = S.STOCK_ID AND
        S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<cfquery name="get_ciro_rows" datasource="#dsn_dev#">
	SELECT 
    	'1' AS TYPE,
        IRR.REVENUE_RATE AS ACTION_TYPE,
        P.TAX_PURCHASE AS VERGI,
        IRR.C_ROW_ID AS ACTION_ID,
        IRR.INVOICE_DATE AS RECORD_DATE,
        '' AS DEPARTMENT_HEAD,
        '%' + CAST(IRR.REVENUE_RATE AS NVARCHAR) + ' CİRO PRİMİ' TIP,
        IRR.REVENUE_GROSS AS BRUT,
        '' AS PROCESS_DETAIL,
        IRR.AMOUNT AS QUANTITY,
        CASE 
            	WHEN REVENUE_PERIOD = 1 THEN '1A' + CAST(MONTH(INVOICE_DATE) AS NVARCHAR)
                WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (1,2) THEN '2A12'
                WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (3,4) THEN '2A34'
                WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (5,6) THEN '2A56'
                WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (7,8) THEN '2A78'
                WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (9,10) THEN '2A910'
                WHEN REVENUE_PERIOD = 2 AND MONTH(INVOICE_DATE) IN (11,12) THEN '2A1112'
                WHEN REVENUE_PERIOD = 3 AND MONTH(INVOICE_DATE) IN (1,2,3) THEN '3A123'
                WHEN REVENUE_PERIOD = 3 AND MONTH(INVOICE_DATE) IN (4,5,6) THEN '3A456'
                WHEN REVENUE_PERIOD = 3 AND MONTH(INVOICE_DATE) IN (7,8,9) THEN '3A789'
                WHEN REVENUE_PERIOD = 3 AND MONTH(INVOICE_DATE) IN (10,11,12) THEN '3A101112'
                WHEN REVENUE_PERIOD = 6 AND MONTH(INVOICE_DATE) IN (1,2,3,4,5,6) THEN '6A123456'
                WHEN REVENUE_PERIOD = 6 AND MONTH(INVOICE_DATE) IN (7,8,9,10,11,12) THEN '6A789101112'
                WHEN REVENUE_PERIOD = 12 THEN '12A'
                END AS PERIOD,
       	IRR.INVOICE_DATE AS PROCESS_STARTDATE,
        IRR.INVOICE_DATE AS PROCESS_FINISHDATE,
        GETDATE() AS ACTION_STARTDATE,
        GETDATE() AS ACTION_FINISHDATE,
        GETDATE() AS PAYMENT_DATE,
        IRR.PAID_DATE,
        IRR.REVENUE_NET AS COST,
        IRR.REVENUE_PAID AS ODENEN,
        CAST(IRR.C_ROW_ID AS NVARCHAR) AS ACTION_NO,
        IRR.INVOICE_NUMBER AS FATURA_NO,
        P.PRODUCT_CODE,
        S.PROPERTY
    FROM 
    	INVOICE_REVENUE_ROWS IRR,
        #dsn1_alias#.STOCKS S,
        #dsn1_alias#.PRODUCT P
    WHERE 
    	IRR.COMP_CODE = '#get_comp.COMP_CODE#' AND
        IRR.STOCK_ID = S.STOCK_ID AND
        S.PRODUCT_ID = P.PRODUCT_ID
</cfquery>

<cfquery name="get_all_rows" dbtype="query">
	SELECT * FROM get_donemsel_rows
    	WHERE
		COST > ODENEN AND
		<cfset count_ = 0>
        <cfloop list="#attributes.checked_row#" index="ccc">
            <cfset count_ = count_ + 1>
            <cfset r_type = evaluate("attributes.TYPE_#ccc#")>
            <cfset r_id_ = evaluate("attributes.ROW_ID_#ccc#")>
            <cfset r_rate_ = evaluate("attributes.revenue_rate_#ccc#")>
            <cfset r_start_ = evaluate("attributes.action_start_#ccc#")>
            <cfset r_finish_ = evaluate("attributes.action_finish_#ccc#")>
            <cfset r_period_ = evaluate("attributes.period_#ccc#")>
            <cf_date tarih="r_start_">
            <cf_date tarih="r_finish_">
            <cfif r_type eq 0>
                (TYPE = '0' AND ACTION_ID = #r_id_#)
            <cfelseif r_type eq 1>
                (
                    TYPE = '1' AND 
                    ACTION_TYPE = '#r_rate_#' AND
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            <cfelse>
            	(
                    TYPE = '2' AND 
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            </cfif>
            <cfif count_ neq listlen(attributes.checked_row)>
            OR
            </cfif> 
        </cfloop>
    UNION
    SELECT * FROM get_ciro_rows
   		WHERE
		COST > ODENEN AND
		<cfset count_ = 0>
        <cfloop list="#attributes.checked_row#" index="ccc">
            <cfset count_ = count_ + 1>
            <cfset r_type = evaluate("attributes.TYPE_#ccc#")>
            <cfset r_id_ = evaluate("attributes.ROW_ID_#ccc#")>
            <cfset r_rate_ = evaluate("attributes.revenue_rate_#ccc#")>
            <cfset r_start_ = evaluate("attributes.action_start_#ccc#")>
            <cfset r_finish_ = evaluate("attributes.action_finish_#ccc#")>
            <cfset r_period_ = evaluate("attributes.period_#ccc#")>
            <cf_date tarih="r_start_">
            <cf_date tarih="r_finish_">
            <cfif r_type eq 0>
                (TYPE = '0' AND ACTION_ID = #r_id_#)
            <cfelseif r_type eq 1>
                (
                    TYPE = '1' AND 
                    ACTION_TYPE = '#r_rate_#' AND
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            <cfelse>
            	(
                    TYPE = '2' AND 
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            </cfif>
            <cfif count_ neq listlen(attributes.checked_row)>
            OR
            </cfif> 
        </cfloop>
    UNION
    SELECT * FROM get_ff_rows
   		WHERE
		COST > ODENEN AND
		<cfset count_ = 0>
        <cfloop list="#attributes.checked_row#" index="ccc">
            <cfset count_ = count_ + 1>
            <cfset r_type = evaluate("attributes.TYPE_#ccc#")>
            <cfset r_id_ = evaluate("attributes.ROW_ID_#ccc#")>
            <cfset r_rate_ = evaluate("attributes.revenue_rate_#ccc#")>
            <cfset r_start_ = evaluate("attributes.action_start_#ccc#")>
            <cfset r_finish_ = evaluate("attributes.action_finish_#ccc#")>
            <cfset r_period_ = evaluate("attributes.period_#ccc#")>
            <cf_date tarih="r_start_">
            <cf_date tarih="r_finish_">
            <cfif r_type eq 0>
                (TYPE = '0' AND ACTION_ID = #r_id_#)
            <cfelseif r_type eq 1>
                (
                    TYPE = '1' AND 
                    ACTION_TYPE = '#r_rate_#' AND
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            <cfelse>
            	(
                    TYPE = '2' AND 
                    PERIOD = '#r_period_#' AND
                    RECORD_DATE BETWEEN #r_start_# AND #r_finish_#
                ) 
            </cfif>
            <cfif count_ neq listlen(attributes.checked_row)>
            OR
            </cfif> 
        </cfloop>
ORDER BY
	TYPE ASC,
    PROCESS_STARTDATE ASC
</cfquery>
<cfform name="add_invoice_" action="#request.self#?fuseaction=invoice.form_add_bill" method="post">
<input type="hidden" value="<cfoutput>#get_comp.company_id#</cfoutput>" id="cpid" name="cpid"/>
<input type="hidden" value="<cfoutput>#get_comp.project_id#</cfoutput>" id="project_id" name="project_id"/>
<input type="hidden" value="<cfoutput>#get_comp.TEDARIKCI_ADI#</cfoutput>" id="company_name" name="company_name"/>
<input type="hidden" value="<cfoutput>#get_comp.PROJE_ADI#</cfoutput>" id="project_head" name="project_head"/>
<input type="hidden" value="<cfoutput>#get_all_rows.recordcount#</cfoutput>" id="row_count" name="row_count"/>
<input type="hidden" value="1" id="ciro_islem" name="ciro_islem"/>
<input type="hidden" value="" id="last_row" name="last_row"/>
<table align="left" cellpadding="0" cellspacing="0">
<tr>
<td>
<cfsavecontent variable="header_"><cfoutput>#get_comp.TEDARIKCI_ADI# <cfif len(get_comp.PROJE_ADI)>(#get_comp.PROJE_ADI#)</cfif></cfoutput> Havuz İcmali</cfsavecontent>
<cf_big_list_search title="#header_#"></cf_big_list_search>
<table class="big_list" style="margin-left:10px;">
	<thead>
    	<tr>
        	<th width="35" rowspan="2">Lokasyon Adı</th>
            <th rowspan="2"><input type="checkbox" value="1" name="s_all" id="s_all" onclick="check_all_rows();"/></th>
            <th rowspan="2">Uygulama No</th>
            <th rowspan="2">Ürün Kodu</th>
            <th rowspan="2">Ürün Adı</th>
            <th rowspan="2">Uygulama Tipi</th>
            <th rowspan="2">Hesaplama Şekli</th>
            <th colspan="4">Uygulama Tarihleri</th>
            <th colspan="3">Miktarlar</th>
            <th colspan="3">Fiyat</th>
            <th colspan="3">Maliyeti Yüksek Olan Eldeki Stok</th>
            <th colspan="5">Tutarlar</th>
            <th rowspan="2">Stc. İrsaliye Tarihi</th>
            <th rowspan="2">Stc.İrs.No</th>
            <th rowspan="2">Sist.No</th>
            <th rowspan="2">Fark Çıkan Stc Fat. No</th>
            <th rowspan="2">Satıcı Fat. No</th>
            <th rowspan="2">Açıklama</th>
        </tr>
        <tr>           
            <th>Baş. Tar.</th>
            <th>Bit. Tar</th>
            <th>İadeler Dş</th>
            <th>KDV</th>
            <th>Satış Miktarı</th>
            <th>Alış Miktarı</th>
            <th>Hes. Miktarı</th>
            <th>Fat. Alış Fiyatı</th>
            <th>Uyg. Net Alış</th>
            <th>Önc. Stok Maliyet Fiyatı</th>
            <th>Fazla Stok</th>
            <th>Fazla Stok Fark</th>
            <th>Fazla Stok Fark</th>
            <th>Tutar</th>
            <th>Toplam Fark Tu.</th>
            <th>Ödenen</th>
            <th>Kalan</th>
            <th>Kesilecek</th>
        </tr>
    </thead>
    <cfset rows_ = 0>
	<cfset brut_toplam = 0>
    <cfset cost_toplam = 0>
    <cfset odenen_toplam = 0>
    <cfset bakiye_toplam = 0>
    
    <tbody>
    	<cfsavecontent variable="body">
           <cfoutput query="get_all_rows">
            <tr>
            	<td>#DEPARTMENT_HEAD#</td>
                <td>
                <input type="hidden" name="tax_#currentrow#" value="#VERGI#"/>
                <input type="checkbox" name="row_type_#currentrow#" id="row_type_#currentrow#" onclick="check_row_cont('#currentrow#');" value="#TYPE#_#ACTION_ID#"/></td>
                <td>#ACTION_NO#</td>
                <td style="background-color:##bc8f8f;color:white;"><cfif len(PRODUCT_CODE)>#listlast(PRODUCT_CODE,'.')#</cfif></td>
                <td>#PROPERTY#</td>
                <td><cfif type eq 0>Dönemsel<cfelseif type eq 1>#TIP#<cfelseif type eq 2>#TIP#</cfif></td>
                <td><cfif type eq 0>-<cfelseif type eq 1>-<cfelse>-</cfif></td>
                <td style="background-color:##90ff90;">#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</td>
                <td style="background-color:##90ff90;">#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#</td>
                <td style="background-color:##90ff90;"></td>
                <td style="background-color:##90ff90;">#VERGI#</td>
                <td style="background-color:##ffe4b5;"><cfif type eq 0>#QUANTITY#</cfif></td>
                <td style="background-color:##ffe4b5;"><cfif type eq 1>#QUANTITY#</cfif></td>
                <td style="background-color:##ffe4b5;">#QUANTITY#</td>                
                <td style="text-align:right;">
                	<cfif type eq 0>
                    	-
                    <cfelseif type gt 1>
                    	#tlformat(BRUT)#
                    </cfif>
                </td>
                <td>
                	<cfif type eq 0>
                    	-
                    <cfelseif type eq 1>
                    	-
                    </cfif>
                </td>
                <td>
                	<cfif type eq 0>
                    	-
                    <cfelseif type eq 1>
                    	-
                    </cfif>
                </td>    
                <td style="text-align:right; background-color:##8fbc8f;">
                	<cfif type eq 0>
                    	-
                    <cfelseif type eq 1>
                    	-
                    </cfif>
                </td>
                <td style="text-align:right; background-color:##8fbc8f;">
                	<cfif type eq 0>
                    	-
                    <cfelseif type eq 1>
                    	-
                    </cfif>
                </td>
                <td style="text-align:right; background-color:##8fbc8f;">
                	<cfif type eq 0>
                    	-
                    <cfelseif type eq 1>
                    	-
                    </cfif>
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                	<cfif type eq 0>
                    	-
                    <cfelseif type eq 1>
                    	-
                    </cfif>
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                    	#tlformat(COST)#
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                    	#tlformat(ODENEN)#
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                	<input type="hidden" name="row_start_value_#currentrow#" id="row_start_value_#currentrow#" value="#COST - ODENEN#" />
                    	#tlformat(COST - ODENEN)#
                </td>
                <td style="text-align:right; background-color:##adff2f;">
                	<input type="text" name="row_end_value_#currentrow#" id="row_end_value_#currentrow#" value="" onfocus="document.getElementById('last_row').value=this.value;" onblur="hesapla('#currentrow#');" onkeyup="return(control_row('#currentrow#') && FormatCurrency(this,event,2));" style="width:50px;"/>
                </td>
                <td style="text-align:right; background-color:##afeeee;"></td>
                <td style="text-align:right; background-color:##ffedb5;"></td>
                <td style="text-align:right; background-color:##fa8072;"></td>
                <td style="text-align:right; background-color:##fa8072;"></td>
                <td style="text-align:right; background-color:##fa8072;">#FATURA_NO#</td>
                <td style="text-align:right; background-color:##fa8072;"></td>
            </tr>
            <!---toplamlar--->
            <cfif type eq 1>
            	<cfset brut_toplam = brut_toplam + brut>
			</cfif>
            <cfset cost_toplam = cost_toplam + cost>
            <cfset odenen_toplam = odenen_toplam + ODENEN>
            <cfset bakiye_toplam = bakiye_toplam + (cost - ODENEN)>
            </cfoutput>
    	</cfsavecontent>
            <cfoutput>
         	<tr>
            	<td style="text-align:right; background-color:##0000cd; color:white;" colspan="7">Toplamlar <input type="submit" value="Gönder"/></td>                
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;">
                	<input type="text" name="end_value_total" id="end_value_total" readonly style="width:50px;"/>
                </td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
                <td style="text-align:right; background-color:##0000cd; color:white;"></td>
            </tr>
            #body#
            </cfoutput>
    </tbody>
</table>

</td>
</tr>
</table>
</cfform>
<script>
function check_row_cont(sira_)
{
	if(document.getElementById('row_type_' + sira_).checked == true)
	{
		document.getElementById('row_end_value_' + sira_).value = commaSplit(document.getElementById('row_start_value_' + sira_).value);
		
		if(document.getElementById('end_value_total').value != '')
			total_ = parseFloat(filterNum(document.getElementById('end_value_total').value));
		else
			total_ = 0;
			
		total_ = total_ + parseFloat(document.getElementById('row_start_value_' + sira_).value);
		document.getElementById('end_value_total').value = commaSplit(total_);
	}	
	else
	{
		deger_ = document.getElementById('row_type_' + sira_).value;
		document.getElementById('row_end_value_' + sira_).value = '';
		
		if(document.getElementById('end_value_total').value != '')
			total_ = parseFloat(filterNum(document.getElementById('end_value_total').value));
		else
			total_ = 0;
			
		total_ = total_ - parseFloat(document.getElementById('row_start_value_' + sira_).value);
		document.getElementById('end_value_total').value = commaSplit(total_);	
	}
}
function check_all_rows()
{
	satir_sayisi_ = document.getElementById('row_count').value;
	document.getElementById('end_value_total').value = '';
	for(var m=1; m <= satir_sayisi_; m++)
	{
		if(document.getElementById('s_all').checked == true)
		{
			document.getElementById('row_type_' + m).checked = true;
			document.getElementById('row_end_value_' + m).value = commaSplit(document.getElementById('row_start_value_' + m).value);
			
			if(document.getElementById('end_value_total').value != '')
				total_ = parseFloat(filterNum(document.getElementById('end_value_total').value));
			else
				total_ = 0;
				
			total_ = total_ + parseFloat(document.getElementById('row_start_value_' + m).value);
			document.getElementById('end_value_total').value = commaSplit(total_);
		}
		else
		{
			document.getElementById('row_type_' + m).checked = false;
			document.getElementById('row_end_value_' + m).value = '';	
			document.getElementById('end_value_total').value = '';
		}
	}
}
function hesapla(sira_)
{
	if(document.getElementById('row_end_value_' + sira_).value == '')
	{
		document.getElementById('row_type_' + sira_).checked = false;	
	}
	else
	{
		last_ = filterNum(document.getElementById('last_row').value);
		yeni_deger_ = filterNum(document.getElementById('row_end_value_' + sira_).value);
		if(last_ != yeni_deger_)
		{
			if(last_ != '')
			{
				if(document.getElementById('end_value_total').value != '')
					total_ = parseFloat(filterNum(document.getElementById('end_value_total').value));
				else
					total_ = 0;
					
				total_ = total_ - parseFloat(filterNum(last_));			
				total_ = total_ + parseFloat(filterNum(document.getElementById('row_end_value_' + sira_).value));
				
				document.getElementById('end_value_total').value = commaSplit(total_);		
			}				
		}
	}
}
function control_row(sira_)
{
	if(document.getElementById('row_type_' + sira_).checked == false)
	{
		document.getElementById('row_end_value_' + sira_).value = '';
		alert('Rakam Girebilmek İçin Satırı Seçiniz!');
		return false;	
	}
}
</script>