<cfsavecontent variable="title"><cf_get_lang dictionary_id="60999.Teminat Aktarım"></cfsavecontent>
<cf_box title="#title#" closable="0">
    <cf_form_box>
        <cfform name="formimport" action="#request.self#?fuseaction=finance.emptypopup_securefund_import" enctype="multipart/form-data" method="post">
            <cf_area width="400">
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                    <div class="col col-8">
                        <input type="file" name="uploaded_file" id="uploaded_file">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                    <div class="col col-8">
                        <a href="/IEF/standarts/import_example_file/TeminatAktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                    </div>
                </div>
            </cf_area>
            <cf_area>
                <table>
                    <tr height="30">
                        <td class="headbold" colspan="2" valign="top"><cf_get_lang dictionary_id='58594.Format'></td>
                    </tr>                       
                    <tr>
                        <td><cf_get_lang dictionary_id='57629.Açıklama'>:</td>
                    </tr>
                    <tr>
                        <td>
                            <cf_get_lang dictionary_id='44342.	Dosya uzantısı csv olmalı,alan araları noktalı virgül (;) ile ayrılmalı ve kaydedilirken karakter desteği olarak UTF-8 seçilmelidir'><br/>
                            <cf_get_lang dictionary_id='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri mutlaka olmalıdır'>.
                        </td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='44951.Bu belgede olması gereken alan sayısı'> : 25</td>
                    </tr>
                    <tr>
                        <td><cf_get_lang dictionary_id='44197.Alanlar sırasıyla'>;</td>
                    </tr>
                    <tr>
                        <td>
                            1-<cf_get_lang dictionary_id='30452.Teminat Kategorisi'> ID*<br/>
                            2-<cf_get_lang dictionary_id='57800.işlem tipi'> ID* (<cf_get_lang dictionary_id='64327.Muhasebe ve cari işlemler yapılmayacaktır'>.)<br/>
                            3-<cf_get_lang dictionary_id='30451.Şirketimiz'> ID*<br/>
                            4-<cf_get_lang dictionary_id='57658.Üye'> ID*<br/>
                            5-<cf_get_lang dictionary_id='57493.Aktif'>* (1:<cf_get_lang dictionary_id='57493.Aktif'> | 0:<cf_get_lang dictionary_id='57494.Pasif'>)<br/>
                            6-<cf_get_lang dictionary_id='57673.Tutar'>* ( <cf_get_lang dictionary_id='58967.Örnek'> : 1.499,99 | 1.000)<br/>
                            7-<cf_get_lang dictionary_id='58791.Komisyon'>% ( <cf_get_lang dictionary_id='58967.Örnek'> : 3 | 5,75)<br/>
                            8-<cf_get_lang dictionary_id ='30635.Döviz Tutar'>* ( <cf_get_lang dictionary_id='58967.Örnek'> : 44 | 49,99)<br/>
                            9-<cf_get_lang dictionary_id='58488.Alınan'>/<cf_get_lang dictionary_id='58490.Verilen'>* (0:<cf_get_lang dictionary_id='58488.Alınan'>| 1:<cf_get_lang dictionary_id='58490.Verilen'>)<br/>
                            10-<cf_get_lang dictionary_id ='30636.İşlem Para Birimi'>* ( <cf_get_lang dictionary_id='58967.Örnek'> : TL | EUR)<br/>
                            11-<cf_get_lang dictionary_id='58930.Masraf'> ( <cf_get_lang dictionary_id='58967.Örnek'> : 44 | 49,99)<br/>
                            12-<cf_get_lang dictionary_id='58930.Masraf'><cf_get_lang dictionary_id='58864.Para br.'> ( <cf_get_lang dictionary_id='58967.Örnek'> : TL | EUR)<br/>
                            13-<cf_get_lang dictionary_id='58933.Banka Şubesi'> ID<br/>
                            14-<cf_get_lang dictionary_id='57629.Açıklama'><br/>
                            15-<cf_get_lang dictionary_id='57655.Başlama Tarihi'>* ( <cf_get_lang dictionary_id='58967.Örnek'> : 17.06.2020 | 17/06/2020)<br/>
                            16-<cf_get_lang dictionary_id ='57700.Bitiş Tarihi'>* ( <cf_get_lang dictionary_id='58967.Örnek'> : 16.06.2020 | 16/06/2020)<br/>
                            17-<cf_get_lang dictionary_id ='30635.Döviz Tutar'>(<cfoutput>#session.ep.money2#</cfoutput>)* ( <cf_get_lang dictionary_id='58967.Örnek'> : 1.499,99 | 1.000)<br/>
                            18-<cf_get_lang dictionary_id='58790.Teminat Alacak Hesabı'><br/>
                            19-<cf_get_lang dictionary_id='58789.Teminat Borç Hesabı'><br/>
                            20-Period ID *<br/>
                            21-<cf_get_lang dictionary_id='57416.Proje'> ID<br/>
                            22-<cf_get_lang dictionary_id='58963.Kredi Limiti'> ID<br/>
                            23-<cf_get_lang dictionary_id='29522.Sozlesme'> ID<br/>
                            24-<cf_get_lang dictionary_id='57545.Teklif'> ID<br/>
                            25-<cf_get_lang dictionary_id='30127.Şubemiz'> ID*<br/>
                        </td>
                    </tr>
                </table>
            </cf_area>
            <cf_form_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'> 
            </cf_form_box_footer>
        </cfform>
    </cf_form_box>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(formimport.uploaded_file.value.length == 0){
			alert("<cf_get_lang dictionary_id='43424.Belge Seçmelisiniz'>!");
			return false;
        }
        return true;
	}
</script>