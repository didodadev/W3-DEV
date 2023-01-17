<cf_date tarih='attributes.give_date'>
<cfquery name="get_banknot_types" datasource="#dsn_dev#">
	SELECT * FROM BANKNOTE_TYPES ORDER BY TYPE_MULTIPLIER DESC
</cfquery>

<cfoutput query="get_banknot_types">
	<cfset 'adet_#TYPE_ID#' = 0>
    <cfset 'tutar_#TYPE_ID#' = 0>
</cfoutput>

<cfif isdefined("attributes.con_id")>
	<cfquery name="get_zno" datasource="#dsn_Dev#">
    	SELECT * FROM POS_CONS WHERE CON_ID = #attributes.CON_ID#
    </cfquery>
    
    <cfquery name="get_zno_payments" datasource="#dsn_Dev#">
    	SELECT * FROM POS_CONS_BANKNOTES WHERE CON_ID = #attributes.CON_ID#
    </cfquery>
    
    <cfoutput query="get_zno_payments">
    	<cfset 'adet_#TYPE_ID#' = TYPE_ADET>
		<cfset 'tutar_#TYPE_ID#' = TYPE_TUTAR>
    </cfoutput>
</cfif>


<cfquery name="get_kdv_tutar" datasource="#dsn_dev#" result="query_r">
SELECT
	 ISNULL(SUM(T1.KDV0),0) AS KDV0,
     ISNULL(SUM(T1.KDV1),0) AS KDV1,
     ISNULL(SUM(T1.KDV8),0) AS KDV8,
     ISNULL(SUM(T1.KDV18),0) AS KDV18
FROM
	(
    SELECT
        SUM(GA2.KDV0) AS KDV0,
        SUM(GA2.KDV1) AS KDV1,
        SUM(GA2.KDV8) AS KDV8,
        SUM(GA2.KDV18) AS KDV18
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU = '0' AND
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
        MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
        DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
        ZNO = '#attributes.z_number#' AND
        GA2.KASA_NUMARASI = #attributes.kasa_id#
    ) T1	
</cfquery>

<cfquery name="get_ciro_report_cash_kdv_matrah" datasource="#dsn_dev#" result="query_r">
    SELECT
        SUM(GAR2.SATIR_TOPLAM - (GAR2.SATIR_INDIRIM + GAR2.SATIR_PROMOSYON_INDIRIM)) AS KDV_MATRAH,
        GAR2.SATIR_KDV
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        GENIUS_ACTIONS_ROWS GAR2,
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        GA2.ACTION_ID = GAR2.ACTION_ID AND
        GAR2.SATIR_IPTALMI = 0 AND
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU = '0' AND
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
        MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
        DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
        ZNO = '#attributes.z_number#' AND
        GA2.KASA_NUMARASI = #attributes.kasa_id#
    GROUP BY
        GAR2.SATIR_KDV
</cfquery>


<cfquery name="get_ciro_report_cash_kdv_matrah_iptal" datasource="#dsn_dev#" result="query_r">
    SELECT
        SUM(GAR2.SATIR_TOPLAM - (GAR2.SATIR_INDIRIM + GAR2.SATIR_PROMOSYON_INDIRIM)) AS KDV_MATRAH,
        GAR2.SATIR_KDV
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        GENIUS_ACTIONS_ROWS GAR2,
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        GA2.ACTION_ID = GAR2.ACTION_ID AND
        GAR2.SATIR_IPTALMI = 1 AND
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU = '0' AND
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
        MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
        DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
        ZNO = '#attributes.z_number#' AND
        GA2.KASA_NUMARASI = #attributes.kasa_id#
    GROUP BY
    	GAR2.SATIR_KDV
</cfquery>

<cfquery name="get_ciro_report_cash_kdv_matrah_iade" datasource="#dsn_dev#" result="query_r2">
    SELECT
        SUM(
        	CASE WHEN GAR2.SATIR_IPTALMI = 0 THEN
        		(GAR2.SATIR_TOPLAM - (GAR2.SATIR_INDIRIM + GAR2.SATIR_PROMOSYON_INDIRIM))
             ELSE
             	-1 * (GAR2.SATIR_TOPLAM - (GAR2.SATIR_INDIRIM + GAR2.SATIR_PROMOSYON_INDIRIM)) END
           ) AS KDV_MATRAH,
        GAR2.SATIR_KDV
    FROM 
        #dsn_alias#.BRANCH B2,
        GENIUS_ACTIONS GA2,
        GENIUS_ACTIONS_ROWS GAR2,
        #dsn3_alias#.POS_EQUIPMENT PE2
    WHERE 
        GA2.ACTION_ID = GAR2.ACTION_ID AND
        GA2.FIS_IPTAL = 0 AND
        GA2.BELGE_TURU = '2' AND
        PE2.BRANCH_ID = B2.BRANCH_ID AND
        PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
        YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
        MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
        DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
        ZNO = '#attributes.z_number#' AND
        GA2.KASA_NUMARASI = #attributes.kasa_id#
    GROUP BY
    	GAR2.SATIR_KDV
</cfquery>

<cfset matrah0 = 0>
<cfset matrah1 = 0>
<cfset matrah8 = 0>
<cfset matrah18 = 0>

<cfset kdv0 = 0>
<cfset kdv1 = 0>
<cfset kdv8 = 0>
<cfset kdv18 = 0>

<cfoutput query="get_ciro_report_cash_kdv_matrah">
	<cfset 'matrah#SATIR_KDV#' = KDV_MATRAH>
</cfoutput>

<cfoutput query="get_ciro_report_cash_kdv_matrah_iptal">
    <cfset 'matrah#SATIR_KDV#' = evaluate('matrah#SATIR_KDV#') - KDV_MATRAH>
</cfoutput>

<table>
<tr>
<td valign="top">
    <cf_ajax_list style="margin-left:5px; float:left; width:200px;">
        <thead>
            <tr>
                <th>Küpür</th>
                <th>Adet</th>
                <th>Tutar</th>
            </tr>
        </thead>
        <tbody>
        <cfoutput query="get_banknot_types">
            <input type="hidden" name="money_#TYPE_ID#" id="money_#TYPE_ID#" value="#TYPE_MULTIPLIER#"/>
            <tr>
                <td style="text-align:right;">#TYPE_NAME#</td>
                <td><input type="text" style="width:50px;" class="moneybox" autocomplete="off" name="money_adet_#TYPE_ID#" id="money_adet_#TYPE_ID#" value="#tlformat(evaluate('adet_#TYPE_ID#'),0)#" onkeyup="return(formatcurrency(this,event,0));" onblur="hesapla_money('#TYPE_ID#');"/></td>
                <td><input type="text" style="width:75px;" class="moneybox" name="money_tutar_#TYPE_ID#" id="money_tutar_#TYPE_ID#" value="#tlformat(evaluate('tutar_#TYPE_ID#'))#" readonly="readonly"/></td>
            </tr>
        </cfoutput>
            <tr>
                <td style="text-align:right;" class="formbold">Toplam</td>
                <td><input type="text" style="width:50px;" class="moneybox" name="money_count" id="money_count" value="0" readonly="readonly"/></td>
                <td><input type="text" style="width:75px;" class="moneybox" name="tutar_count" id="tutar_count" value="0" readonly="readonly"/></td>
            </tr>
        </tbody>
    </cf_ajax_list>
</td>
<td valign="top">
	<!--- kdv matrahlar --->
    <table width="200" align="center" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="4" style="text-align:center;" class="formbold">TOPLAM KDV BİLGİLERİ</td>
        </tr>
        <tr>
            <td class="txtboldblue" width="20">%</td>
            <td class="txtboldblue" style="text-align:right;">KDV Matrahı</td>
            <td class="txtboldblue" style="text-align:right;">KDV Tutarı</td>
            <td class="txtboldblue" style="text-align:right;">KDV'li Toplam</td>
        </tr>
		<cfoutput>
        <tr>
            <td style="background-color:##FFC;">0</td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDV_MATRAH0" value="#tlformat(matrah0 - get_kdv_tutar.kdv0)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDV0" value="#tlformat(get_kdv_tutar.kdv0)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDVLI0" value="#tlformat(matrah0)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
        </tr>
        <tr>
            <td>1</td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDV_MATRAH1" value="#tlformat(matrah1 - get_kdv_tutar.kdv1)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDV1" value="#tlformat(get_kdv_tutar.kdv1)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDVLI1" value="#tlformat(matrah1)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
        </tr>
        <tr>
            <td style="background-color:##FFC;">8</td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDV_MATRAH8" value="#tlformat(matrah8 - get_kdv_tutar.kdv8)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDV8" value="#tlformat(get_kdv_tutar.kdv8)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDVLI8" value="#tlformat(matrah8)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
        </tr>
        <tr>
            <td>18</td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDV_MATRAH18" value="#tlformat(matrah18 - get_kdv_tutar.kdv18)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDV18" value="#tlformat(get_kdv_tutar.kdv18)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
            <td style="text-align:right; background-color:##FFC;""><input type="text" name="KDVLI18" value="#tlformat(matrah18)#" class="moneybox" style="width:75px;" readonly="readonly"/></td>
        </tr>
        <tr>
            <td style="background-color:##FC9;">TOP.</td>
            <td style="text-align:right;background-color:##FC9;">#tlformat(matrah0 + matrah1 + matrah8 + matrah18 - (get_kdv_tutar.kdv0 + get_kdv_tutar.kdv1 + get_kdv_tutar.kdv8 + get_kdv_tutar.kdv18))#</td>
            <td style="text-align:right;background-color:##FC9;">#tlformat(get_kdv_tutar.kdv0 + get_kdv_tutar.kdv1 + get_kdv_tutar.kdv8 + get_kdv_tutar.kdv18)#</td>
            <td style="text-align:right;background-color:##FC9;">#tlformat(matrah0 + matrah1 + matrah8 + matrah18)#</td>
        </tr>
        </cfoutput>
    </table>
    <!--- kdv matrahlar --->
</td>
</tr>
</table>
<script>
function hesapla_toplam_money()
{
	para_sayisi_ = 0;
	tutar_ = 0;
	<cfoutput query="get_banknot_types">
		if(document.getElementById('money_adet_#TYPE_ID#').value != '')
		{
			para_sayisi_ = para_sayisi_ + parseFloat(filterNum(document.getElementById('money_adet_#TYPE_ID#').value));
			tutar_ = tutar_ + parseFloat(filterNum(document.getElementById('money_tutar_#TYPE_ID#').value));
		}
	</cfoutput>
	document.getElementById('money_count').value = commaSplit(para_sayisi_,0);	
	document.getElementById('tutar_count').value = commaSplit(tutar_,2);
	
	if(document.getElementById('odeme_turu_1').value == '0')
	{
		document.getElementById('teslim_tutar_1').value = commaSplit(tutar_,2);
		hesapla_odeme('1');
	}
}
function hesapla_money(row_id)
{
	carpan_ = parseFloat(document.getElementById('money_' + row_id).value);
	deger_ = document.getElementById('money_adet_' + row_id).value;
	if(deger_ == '')
	{
		document.getElementById('money_tutar_' + row_id).value = 0;
		document.getElementById('money_adet_' + row_id).value = 0;
	}
	else
	{
		deger_ = parseFloat(filterNum(deger_));
		document.getElementById('money_tutar_' + row_id).value = commaSplit(carpan_ * deger_);
		document.getElementById('money_adet_' + row_id).value = commaSplit(deger_,0);
	}
	hesapla_toplam_money();
}
<cfif isdefined("attributes.con_id")>
	hesapla_toplam_money();
</cfif>
</script>