<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
  <tr>
    <td clasS="headbold"><cf_get_lang dictionary_id="32524.Faturayı Maliyet Merkezlerine Dağıt"></td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr class="color-border">
        <td valign="top">
            <table cellpadding="2" cellspacing="1" border="0" width="100%" >
                <tr class="color-list" height="22">
                    <td colspan="9"><cf_get_lang dictionary_id="57519.Cari Hesap:"><cf_get_lang dictionary_id="58133.Fatura No:"><cf_get_lang dictionary_id="58759.Fatura Tarihi:"> </td>
                </tr>
                <tr class="color-header" height="22">
                    <td class="form-title" width="120"><cf_get_lang dictionary_id="57486.Kategori"></td>
                    <td class="form-title" width="145"><cf_get_lang dictionary_id="57629.Açıklama"></td>
                    <td width="55"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57635.Miktar"></td>
                    <td width="120"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57673.Tutar"></td>
                    <td width="125" class="form-title" ><cf_get_lang dictionary_id="51644.Maliyet Merkezi"></td>
                    <td width="125" class="form-title" ><cf_get_lang dictionary_id="58551.Gider Kalemi"></td>
                    <td width="10" class="form-title"><img src="/images/cuberelation.gif" alt="<cf_get_lang dictionary_id= "33874.Ayrıntılı">" title="<cf_get_lang dictionary_id="33874.Ayrıntılı">" border="0"></td>
                </tr>
                <tr class="color-row">
                    <td><cf_get_lang dictionary_id="51647.Reklam"></td>
                    <td><cf_get_lang dictionary_id="51662.Broşür"></td>
                    <td  style="text-align:right;">1000 Br</td>
                    <td  style="text-align:right;">&nbsp;</td>
                    <td><select name="select" id="select" style="width:125px;"></select></td>
                    <td><select name="select" id="select" style="width:125px;"></select></td>
                    <td>
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=cost.popup_add_expensecenter_invoice_detail</cfoutput>','medium');"><img src="/images/cuberelation.gif" alt="<cf_get_lang dictionary_id= "33874.Ayrıntılı">"  title="<cf_get_lang dictionary_id="33874.Ayrıntılı">" border="0"></a>
                    </td>
                </tr>
                    <tr class="color-row" height="22">
                    <td colspan="9"  style="text-align:right;">
                    <input name="cek" value="Vazgeç" type="button">  <input name="cek" value="<cf_get_lang dictionary_id="57461.Kaydet">" type="button">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
