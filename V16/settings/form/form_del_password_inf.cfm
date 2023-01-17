<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td height="35" class="headbold"><cf_get_lang no='1731.Bilgisayar Bilgisi Ekle'></td>
    </tr>
</table>
<table  width="98%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
    <tr class="color-row">
        <td width="200" valign="top">
        <cfquery name="VERILER" datasource="#DSN#">
            SELECT 
	            PASSWORD_ID,  
                PASSWORD_NAME
            FROM 
            	PASSWORD_CONTROL
        </cfquery>
            <table width="200" cellpadding="0" cellspacing="0" border="0">
                <tr> 
                    <td valign="top" class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1731.Bilgisayar Bilgisi'></td>
                </tr>
                <cfif VERILER.recordcount>
					<cfoutput query="VERILER">
                        <tr>
                            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                            <td width="180"><a href="#request.self#?fuseaction=test.serkan&ID=#PASSWORD_ID#" class="tableyazi">#PASSWORD_NAME#</a></td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
                        </tr>
                </cfif>
            </table>
        </td>
        <td class="color-row" valign="top">
            <table>
                <form action="#request.self#?fuseaction=test.click" method="post" name="computer_info">
                <input type="hidden" name="insert" id="insert">
                    <tr>
                        <td> Yeni Sifre Ekle :</td>
                        <td></td>  
                    </tr>
                    <tr>
                        <td>Active :</td>
                        <td><input type="checkbox" name="ACTIVE" id="ACTIVE"></td>
                    </tr>
                    <tr>    
                        <td>Sifre Adını Giriniz :</td>
                        <td><input type="text" name="PASSWORD_NAME" id="PASSWORD_NAME"> </td>
                    </tr>
                    <tr>    
                        <td>Sifre Uzunlugunu Giriniz: </td>
                        <td>
                            <select style="width:95;" name="SIFRE_UZUNLUK" id="SIFRE_UZUNLUK">
                                <option value="6">6 KARAKTER</option>
                                <option value="7">7 KARAKTER</option>
                                <option value="8">8 KARAKTER</option>
                                <option value="9">9 KARAKTER</option>
                                <option value="10">10 KARAKTER</option>
                                <option value="11">11 KARAKTER</option>
                                <option value="12">12 KARAKTER</option>
                                <option value="13">13 KARAKTER</option>
                                <option value="14" >14 KARAKTER</option>
                                <option value="15">15 KARAKTER</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Sifre Kucuk Harf Icersinmi:</td>
                    <td>
                        <select  style="width:95;" name="KUCUK_HARF_UZUNLUK" id="KUCUK_HARF_UZUNLUK">
                            <option value="0">0</option>
                            <option value="1">1 KARAKTER</option>
                            <option value="2">2 KARAKTER</option>
                            <option value="3">3 KARAKTER</option>
                            <option value="4">4 KARAKTER</option>
                            <option value="5">5 KARAKTER</option>
                        </select>
                    </td>
                    </tr>
                    <tr>
                        <td>Sifre Buyuk Harf Icersinmi:</td>
                        <td>
                            <select  style="width:95;" name="BUYUK_HARF_UZUNLUK" id="BUYUK_HARF_UZUNLUK" >
                                <option value="0">0</option>
                                <option value="1">1 KARAKTER</option>
                                <option value="2">2 KARAKTER</option>
                                <option value="3">3 KARAKTER</option>
                                <option value="4">4 KARAKTER</option>
                                <option value="5">5 KARAKTER</option>
                            </select>
                        </td> 
                    </tr>    
                    <tr>
                        <td>Sifre Rakam Icersinmi:</td>
                        <td>
                            <select  style="width:95;" name="RAKAM_UZUNLUK" id="RAKAM_UZUNLUK">
                                <option value="0">0 </option>
                                <option value="1">1 KARAKTER</option>
                                <option value="2">2 KARAKTER</option>
                                <option value="3">3 KARAKTER</option>
                                <option value="4">4 KARAKTER</option>
                                <option value="5">5 KARAKTER</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Sifre Ozel Karakter Icersınmı:</td>
                        <td>
                            <select  style="width:95;" name="OZEL_KARAKTER_UZUNLUK" id="OZEL_KARAKTER_UZUNLUK">
                                <option value="0">0</option>
                                <option value="1">1 KARAKTER</option>
                                <option value="2">2 KARAKTER</option>
                                <option value="3">3 KARAKTER</option>
                                <option value="4">4 KARAKTER</option>
                                <option value="5">5 KARAKTER</option>
                            </select>
                        </td>     
                    </tr>
                    <tr>
                        <td>Sifre Geriye Dogru Kontrol Sayısı:</td>
                        <td>
                            <select style="width:95;" name="KONTROL_SAYISI" id="KONTROL_SAYISI">
                                <option value="0">0</option>
                                <option value="1">1 KARAKTER</option>
                                <option value="2">2 KARAKTER</option>
                                <option value="3">3 KARAKTER</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Sifre Degisim Aralıgı:</td>
                        <td>
                            <select style="width:95;" name="KONTROL_GUN" id="KONTROL_GUN" >
                                <option value="0">0 GUN</option>
                                <option value="30">30 GUN</option>
                                <option value="60">60 GUN</option>
                                <option value="90">90 GUN</option>
                                <option value="120">120 GUN</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='0'></td>
                    </tr>
                </form>
            </table>
        </td>
    </tr>
</table>
