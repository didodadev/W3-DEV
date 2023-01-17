
<cfsetting showdebugoutput="yes">
<cfquery name="get_actions" datasource="#dsn2#">
		SELECT  
	CA.PAPER_NO,
	CA.ACTION_VALUE ,
	C.NICKNAME alacakli,
	C2.NICKNAME borclu,
	CA.ACTION_DATE AS ROW_DATE,
	CA.ACTION_CURRENCY_ID,
	CA.OTHER_MONEY,
	CA.OTHER_CASH_ACT_VALUE,
    CAM.ACTION_DATE AS PAPER_DATE
FROM
	CARI_ACTIONS CA
    LEFT JOIN CARI_ACTIONS_MULTI CAM ON CAM.MULTI_ACTION_ID=CA.MULTI_ACTION_ID
	LEFT JOIN #dsn#.COMPANY C ON  CA.FROM_CMP_ID = C.COMPANY_ID
	LEFT JOIN #dsn#.COMPANY C2 ON  CA.TO_CMP_ID = C2.COMPANY_ID
WHERE 
    CA.MULTI_ACTION_ID = #attributes.iid#
	
</cfquery>
<style>
@media print
 {
html,body {background: white;}
table{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
tr{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
td{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
}

@media screen
{
html,body{height: 100%;width:100%;}
table{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color: #333333;}
tr{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
td{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
}
</style>

<style>
        .box_yazi{ font-weight:bold;}
		.stil{ font-weight:bold;font-size:16px;}
    </style>

 <table border="0" cellspacing="0" cellpadding="0" align="left" style="width:180mm;">
        <tr>
            <td rowspan="40" style="width:10mm;">&nbsp;</td>
            <td style="height:10mm;">&nbsp;</td>
        </tr>
        <tr>
            <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td colspan="4" class="stil" style="text-align:center;height:14mm;">
                   		<h3>Toplu Cari Virman</h3>
                    </td>
                </tr>
                <tr>
                	<td>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
					<cfoutput>
                    	
                        <tr>
                        	<td style="height:6mm;width:25mm;"><strong><cf_get_lang_main no="330.Tarih"> :</strong></td>
                            <td>#dateformat(get_actions.PAPER_DATE,dateformat_style)#</td>
                        </tr>
					</cfoutput>
                    </table>
                    </td>
                </tr>
                <tr><td colspan="4">&nbsp;</td></tr>
                <tr>
                    <td colspan="4" valign="top">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr class="box_yazi">
                            <td style="width:50mm;height:6mm;"><cf_get_lang_main no="468.Belge No"></td>
                            <td style="width:15mm;">Tarih</td>
                            <td style="width:67mm;"> Alacaklı Hesap</td>
                            <td style="width:65mm;">Borçlu Hesap</td>
                            <td style="width:25mm;">Tutar</td>
                            <td style="width:70mm;">Dvz.Tutar</td>
                             <td style="width:50mm;">&nbsp;</td>
                        </tr>
                       	
                        	<cfoutput query="get_actions">
                            <tr>
                                <td style="width:19mm;">#paper_no#</td>
                                <td style="width:25mm;">#dateformat(ROW_DATE,dateformat_style)#</td>
                                <td style="width:45mm;height:6mm;">
                              		#alacakli#
                                </td>
                                <td style="width:25mm;">#borclu#</td>
                                <td style="width:25mm;">#TLFormat(ACTION_VALUE)# #ACTION_CURRENCY_ID#</td>
                                <td style="width:25mm;">#TLFormat(OTHER_CASH_ACT_VALUE)# #OTHER_MONEY#</td>
                                 <td style="width:50mm;">&nbsp;</td>
                            </tr>
                            </cfoutput>
                        </table>
                    </td>
                </tr>
                <tr>
                	<td colspan="4">
                    <table>
					<cfoutput>
                    	<tr><td style="height:5mm;">&nbsp;</td></tr>
                    	<tr>
                        	<td style="height:10mm;"><font size="2">
							
                            </td>
                        </tr>
                        <tr>
                        	<td class="box_yazi"><font size="2">#session.ep.company#</font></td>
                        </tr>
					</cfoutput>
                    </table>
                    </td>
                </tr>
            </table>
            </td>
        </tr>
    </table>

