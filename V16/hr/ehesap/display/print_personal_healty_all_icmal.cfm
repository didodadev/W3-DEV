<table width="1000" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td colspan="2" class="TXTBOLD"><cf_get_lang dictionary_id="53821.SOSYAL SİGORTALAR KURUMU"></td>
    </tr>
    <tr>
        <td class="print">&nbsp;</td>
        <td rowspan="2" align="center" class="formbold"><cf_get_lang dictionary_id="46642.GÜNLÜK POLİKLİNİK İCMAL DEFTERİ"></td>
    </tr>
    <tr>
        <td class="print" width="200">&nbsp;</td>
    </tr>
</table>
<table width="1000" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="CCCCCC" class="print">
    <cfform name="poliklinik" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_poliklinik">
        <tr align="center" class="printbold">
            <td rowspan="5">&nbsp;</td>
            <td rowspan="5" style="writing-mode : tb-rl;direction : rtl;" align="center" width="25"><cf_get_lang dictionary_id="46641.Ayın Günleri"></td>
            <td colspan="18"><cf_get_lang dictionary_id="46638.MUAYENE EDİLEN ŞAHIS SAYISI"></td>
            <td rowspan="4" width="75"><cf_get_lang dictionary_id="29954.Genel"> <br/> <cf_get_lang dictionary_id="57492.Toplam"></td>
        </tr>
        <tr align="center" class="printbold">
            <td colspan="2" rowspan="2"><cf_get_lang dictionary_id="48002.KAZA"> <br/> <cf_get_lang dictionary_id="53462.MESLEK HASTALIĞI"></td>
            <td colspan="2" rowspan="2"><cf_get_lang dictionary_id="46637.ANALIK"></td>
            <td colspan="8"><cf_get_lang dictionary_id="46629.HASTALIK"></td>
            <td colspan="2" rowspan="2"><cf_get_lang dictionary_id="46628.SİGORTASIZLAR"></td>
            <td colspan="2" rowspan="2"><cf_get_lang dictionary_id="46620.BAĞKUR SİGORTALILARI"></td>
            <td colspan="2"><cf_get_lang dictionary_id="57492.Toplam"></td>
        </tr>
        <tr align="center" class="printbold">
            <td colspan="2"><cf_get_lang dictionary_id="46618.SİGORTALILAR"></td>
            <td colspan="2">
                <cf_get_lang dictionary_id="47795.Malüllük Yaşlılık Aylığı Alanlar">	 
            </td>
            <td colspan="2">
                <cf_get_lang dictionary_id="53274.EŞ">-<cf_get_lang dictionary_id="35917.ÇOCUK"><br/>
                <cf_get_lang dictionary_id="31328.ANA">-<cf_get_lang dictionary_id="31327.BABA"><br/>
                <cf_get_lang dictionary_id="51555.DUL">
                <cf_get_lang dictionary_id="47794.YETİM">
            </td>
            <td colspan="2"><cf_get_lang dictionary_id="47791.HASTALIK TOPLAMI"></td>
            <td rowspan="2"><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td rowspan="2"><cf_get_lang dictionary_id="53832.Eski"></td>
        </tr>
        <tr align="center" class="printbold">
            <td><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td><cf_get_lang dictionary_id="53832.Eski"></td>
            <td><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td><cf_get_lang dictionary_id="53832.Eski"></td>
            <td><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td><cf_get_lang dictionary_id="53832.Eski"></td>
            <td><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td><cf_get_lang dictionary_id="53832.Eski"></td>
            <td><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td><cf_get_lang dictionary_id="53832.Eski"></td>
            <td><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td><cf_get_lang dictionary_id="53832.Eski"></td>
            <td><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td><cf_get_lang dictionary_id="53832.Eski"></td>
            <td><cf_get_lang dictionary_id="58674.Yeni"></td>
            <td><cf_get_lang dictionary_id="53832.Eski"></td>
        </tr>
        <tr align="center" class="printbold">
            <td>1</td>
            <td>2</td>
            <td>3</td>
            <td>4</td>
            <td>5</td>
            <td>6</td>
            <td>7</td>
            <td>8</td>
            <td>9</td>
            <td>10</td>
            <td>11</td>
            <td>12</td>
            <td>13</td>
            <td>14</td>
            <td>15</td>
            <td>16</td>
            <td>17</td>
            <td>18</td>
            <td>19</td>
        </tr>
        <cfquery name="get_all_month" datasource="#dsn#">
            SELECT 
        	    SAL_YEAR, 
                SAL_MON, 
                SAL_DAY, 
                F1, 
                F2, 
                F3, 
                F4, 
                F5, 
                F6, 
                F7, 
                F8, 
                F9, 
                F10, 
                F11, 
                F12, 
                F13, 
                F14, 
                F15, 
                F16, 
                F17, 
                F18, 
                F19 
            FROM 
    	        EMPLOYEES_POLIKLINIK_ICMAL 
            WHERE 
	            SAL_YEAR = #ATTRIBUTES.SAL_YEAR# AND SAL_MON = #ATTRIBUTES.SAL_MON#
        </cfquery>
        <cfloop from="1" to="#daysinmonth(CreateDate(attributes.sal_year, attributes.sal_mon, 1))#" index="i">
            <cfquery name="get_days_records" dbtype="query">
                SELECT * FROM get_all_month WHERE SAL_DAY = #i#
            </cfquery>
            <tr>
                <td>&nbsp;</td>
                <td align="center"><cfoutput>#i#</cfoutput></td>
                <cfif get_days_records.recordcount>
                    <td><cfinput type="text" name="f1_#i#" size="3" maxlength="3" value="#get_days_records.f1#" validate="integer" message="1. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f2_#i#" size="3" maxlength="3" value="#get_days_records.f2#" validate="integer" message="2. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f3_#i#" size="3" maxlength="3" value="#get_days_records.f3#" validate="integer" message="3. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f4_#i#" size="3" maxlength="3" value="#get_days_records.f4#" validate="integer" message="4. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f5_#i#" size="3" maxlength="3" value="#get_days_records.f5#" validate="integer" message="5. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f6_#i#" size="3" maxlength="3" value="#get_days_records.f6#" validate="integer" message="6. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f7_#i#" size="3" maxlength="3" value="#get_days_records.f7#" validate="integer" message="7. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f8_#i#" size="3" maxlength="3" value="#get_days_records.f8#" validate="integer" message="8. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f9_#i#" size="3" maxlength="3" value="#get_days_records.f9#" validate="integer" message="9. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f10_#i#" size="3" maxlength="3" value="#get_days_records.f10#" validate="integer" message="10. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f11_#i#" size="3" maxlength="3" value="#get_days_records.f11#" validate="integer" message="11. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f12_#i#" size="3" maxlength="3" value="#get_days_records.f12#" validate="integer" message="12. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f13_#i#" size="3" maxlength="3" value="#get_days_records.f13#" validate="integer" message="13. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f14_#i#" size="3" maxlength="3" value="#get_days_records.f14#" validate="integer" message="14. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f15_#i#" size="3" maxlength="3" value="#get_days_records.f15#" validate="integer" message="15. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f16_#i#" size="3" maxlength="3" value="#get_days_records.f16#" validate="integer" message="16. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f17_#i#" size="3" maxlength="3" value="#get_days_records.f17#" validate="integer" message="17. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f18_#i#" size="3" maxlength="3" value="#get_days_records.f18#" validate="integer" message="18. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f19_#i#" size="3" maxlength="3" value="#get_days_records.f19#" validate="integer" message="19. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                <cfelse>
                    <td><cfinput type="text" name="f1_#i#" size="3" maxlength="3" value="0" validate="integer" message="1. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f2_#i#" size="3" maxlength="3" value="0" validate="integer" message="2. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f3_#i#" size="3" maxlength="3" value="0" validate="integer" message="3. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f4_#i#" size="3" maxlength="3" value="0" validate="integer" message="4. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f5_#i#" size="3" maxlength="3" value="0" validate="integer" message="5. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f6_#i#" size="3" maxlength="3" value="0" validate="integer" message="6. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f7_#i#" size="3" maxlength="3" value="0" validate="integer" message="7. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f8_#i#" size="3" maxlength="3" value="0" validate="integer" message="8. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f9_#i#" size="3" maxlength="3" value="0" validate="integer" message="9. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f10_#i#" size="3" maxlength="3" value="0" validate="integer" message="10. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f11_#i#" size="3" maxlength="3" value="0" validate="integer" message="11. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f12_#i#" size="3" maxlength="3" value="0" validate="integer" message="12. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f13_#i#" size="3" maxlength="3" value="0" validate="integer" message="13. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f14_#i#" size="3" maxlength="3" value="0" validate="integer" message="14. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f15_#i#" size="3" maxlength="3" value="0" validate="integer" message="15. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f16_#i#" size="3" maxlength="3" value="0" validate="integer" message="16. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f17_#i#" size="3" maxlength="3" value="0" validate="integer" message="17. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f18_#i#" size="3" maxlength="3" value="0" validate="integer" message="18. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                    <td><cfinput type="text" name="f19_#i#" size="3" maxlength="3" value="0" validate="integer" message="19. Kolon #i#. Satırda Hatalı Bilgi Var !"></td>
                </cfif>
            </tr>
        </cfloop>
        <tr>
            <td class="txtbold" width="80" nowrap><cf_get_lang dictionary_id="57680.Genel Toplam"></td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
            <input type="hidden" name="print_all" id="print_all" value="0">
            <input type="hidden" name="sal_mon" id="sal_mon" value="<cfoutput>#attributes.sal_mon#</cfoutput>">
            <input type="hidden" name="sal_year" id="sal_year" value="<cfoutput>#attributes.sal_year#</cfoutput>">
            <input type="hidden" name="days_count" id="days_count" value="<cfoutput>#daysinmonth(CreateDate(attributes.sal_year, attributes.sal_mon, 1))#</cfoutput>">
        <tr>
        <td colspan="21"  class="txtbold" style="text-align:right;"> <input type="submit" value="Kaydet ve Yazdır" onClick="poliklinik.print_all.value=1"> <input type="submit" value="Kaydet"></td>
    </cfform>
</table>
