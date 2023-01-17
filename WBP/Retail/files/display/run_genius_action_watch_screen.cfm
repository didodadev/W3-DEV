<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_last_action" datasource="#dsn_dev#">
	SELECT TOP 1
    	(SELECT COUNT(GAR.ACTION_ROW_ID) FROM GENIUS_ACTIONS_ROWS GAR WHERE GAR.FIS_TARIHI >= #bugun_# AND GAR.FIS_TARIHI < #dateadd('d',1,bugun_)#) AS GUN_HAREKET_SAYISI,
        (SELECT COUNT(GA2.ACTION_ID) FROM GENIUS_ACTIONS GA2 WHERE GA2.FIS_TARIHI >= #bugun_# AND GA2.FIS_TARIHI < #dateadd('d',1,bugun_)#) AS GUN_FIS_SAYISI,
        ISNULL((SELECT COUNT(GAR2.ACTION_ROW_ID) FROM GENIUS_ACTIONS_ROWS GAR2 WHERE GAR2.STOCK_ID IS NULL),0) AS HATALI_HAREKET_SAYISI,
        (SELECT TOP 1 GAR3.STOCK_ID FROM GENIUS_ACTIONS_ROWS GAR3 ORDER BY GAR3.ACTION_ROW_ID DESC) AS SON_STOCK_ID,
        GA.ACTION_DATE,
        GA.KASA_NUMARASI,
        GA.FIS_TARIHI,
        GA.FIS_NUMARASI,
        GA.HAREKET_SAYISI,
        GA.ODEME_SAYISI,
        (SELECT B.BRANCH_NAME FROM #dsn_alias#.BRANCH B WHERE B.BRANCH_ID = PE.BRANCH_ID) AS SUBE,
        '\documents\online' + '\' + PE.FILENAME AS DOSYA
    FROM
    	GENIUS_ACTIONS GA,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
    	GA.KASA_NUMARASI = PE.EQUIPMENT_CODE
    ORDER BY
    	GA.ACTION_DATE DESC,
        GA.ACTION_ID DESC
</cfquery>
<cfsavecontent variable="icerik_">
	<cfoutput query="get_last_action">
	<table>
    	<tr>
        <td valign="top" width="500">   
            <table>
                <tr>
                	<td colspan="2" class="txtboldblue">Hareket Bilgileri</td>
                </tr>
                <tr>
                    <td class="formbold" width="225">Kasa No</td>
                    <td>#KASA_NUMARASI#</td>
                </tr>
                <tr>
                    <td class="formbold" width="225">Şube</td>
                    <td>#SUBE#</td>
                </tr>
                <tr>
                    <td class="formbold">Dosya</td>
                    <td>#DOSYA#</td>
                </tr>
                <tr>
                    <td class="formbold">İşlem Zamanı</td>
                    <td>#dateformat(ACTION_DATE,'dd/mm/yyyy')# (#timeformat(ACTION_DATE,'HH:MM')#)</td>
                </tr>
                <tr>
                    <td class="formbold">Bugüne Ait Toplam Hareket Sayısı</td>
                    <td>#GUN_HAREKET_SAYISI#</td>
                </tr>
                <tr>
                    <td class="formbold">Bugüne Ait Toplam Fiş Sayısı</td>
                    <td>#GUN_FIS_SAYISI#</td>
                </tr>
                <tr>
                    <td class="formbold">Hatalı Kayıt Sayısı</td>
                    <td><cfif HATALI_HAREKET_SAYISI gt 0><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_manage_bad_rows','list');" class="tableyazi"><font color="red">#HATALI_HAREKET_SAYISI#</font></a></cfif></td>
                </tr>
            </table>
        </td>
        <td valign="top">
            <table>
            	<tr>
                	<td colspan="2" class="txtboldblue">Son Fiş Bilgileri</td>
                </tr>
                <tr>
                    <td class="formbold" width="125">Fiş No</td>
                    <td>#FIS_NUMARASI#</td>
                </tr>
                <tr>
                    <td class="formbold">Son Fiş Zamanı</td>
                    <td>#dateformat(FIS_TARIHI,'dd/mm/yyyy')# (#timeformat(FIS_TARIHI,'HH:MM')#)</td>
                </tr>
                <tr>
                    <td class="formbold">Fiş Satır Sayısı</td>
                    <td>#HAREKET_SAYISI#</td>
                </tr>
                <tr>
                    <td class="formbold">Fiş Ödeme Sayısı</td>
                    <td>#ODEME_SAYISI#</td>
                </tr>
                <tr>
                    <td class="formbold">Stok Kodu</td>
                    <td>#SON_STOCK_ID#</td>
                </tr>
                <tr>
                    <td class="formbold">Stok Adı</td>
                    <td>#get_product_name(stock_id:SON_STOCK_ID,with_property:0)#</td>
                </tr>
            </table>
        </td>
       	</tr>
    </table>
    </cfoutput>
    <br />
<cfquery name="get_message" datasource="#dsn_Dev#">
	SELECT * FROM TRANSFER_NOTE
</cfquery>   
 
    <cfif get_message.recordcount>
    	<cfoutput>#get_message.TRANSFER_NOTE#</cfoutput>
    </cfif>
</cfsavecontent>
<textarea id="g_r_input"><cfoutput>#icerik_#</cfoutput></textarea>
<script>
	document.getElementById('hareket_on').innerHTML = document.getElementById('g_r_input').value;
</script>