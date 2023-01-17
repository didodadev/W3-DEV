<cfquery name="PERIODS" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD ORDER BY PERIOD
</cfquery>	
<cf_box title="#getLang('','settings',43929)#">
    <cfform name="form_import" enctype="multipart/form-data" method="post"action="#request.self#?fuseaction=settings.add_member_period_import">
    <cf_box_elements>
        <input type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html">
    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
    <div class="form-group">
        <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43385.Belge Formatı'></label>
        <div class="col col-8 col-md-6 col-xs-12">
            <select name="file_format" id="file_format" style="width:200px;">
                <option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                <option value="ISO-8859-9"><cf_get_lang dictionary_id='43386.ISO-8859-9 (Türkçe)'></option>
            </select>
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='57468.Belge'>*</label>
        <div class="col col-8 col-md-6 col-xs-12">
            <input type="file" name="uploaded_file" id="uploaded_file">
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
        <div class="col col-8 col-md-6 col-xs-12">
            <a  href="/IEF/standarts/import_example_file/uye_muhasebe_kodu_aktarimi.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
        <div class="col col-8 col-md-6 col-xs-12">
            <select name="period_id" id="period_id" style="width:200px;">
                <cfoutput query="periods"><option value="#PERIOD_ID#,#PERIOD_YEAR#,#OUR_COMPANY_ID#" <cfif PERIOD_ID eq session.ep.period_id>select</cfif>>#PERIOD#</option></cfoutput>
            </select>
        </div>
    </div>
    <div class="form-group">
        <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id ='43928.Referans Kolon'></label>
        <div class="col col-8 col-md-6 col-xs-12">
            <select name="referans_type" id="referans_type" style="width:200px;">
                <option value="member_code"><cf_get_lang dictionary_id ='57558.Üye No'></option>
                <option value="ozel_kod"><cf_get_lang dictionary_id ='57789.Özel Kod'></option>
            </select>
        </div>
    </div>
</div>
<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">
       <h3><cf_get_lang dictionary_id='58594.Format'></h3>
            <cf_get_lang dictionary_id ='44195.Belgede toplam'> <b><font color="FF0000">15</font></b> <cf_get_lang dictionary_id ='44196.alan olacaktır'>. <cf_get_lang dictionary_id ='44197.Alanlar sırasıyla'> <br/>
            <b><font color="FF0000">1_<cf_get_lang dictionary_id ='43926.Üye Tipi'></font></b>: <cf_get_lang dictionary_id ='44198.Kurumsal yada bireysel üyeyi ayırt etmek için kullanmanız gerekiyor'>. <cf_get_lang dictionary_id ='44199.Kurumsal ise K'>,<cf_get_lang dictionary_id ='44201.Bireysel ise B harfini yazınız'>.<br/>
            <b><font color="FF0000">2_<cf_get_lang dictionary_id ='57485.Öncelik'></font></b>: <cf_get_lang dictionary_id ='44200.Ekleyeceğiniz muhasebe kodunuz bu üye için öncelikli kod olacak ise 1,değilse 0yazınız'>.<br/>
            <b><font color="FF0000">3_<cf_get_lang dictionary_id ='43925.Cari Kodu veya Özel Kod'></font></b>: <cf_get_lang dictionary_id ='44202.Aktarımda referans olarak kullanacağınız alanı yazmanız gerekiyor'>. <cf_get_lang dictionary_id ='44203.Yalnız bir aktarım aynı anda hem cari kodu hemde özel kod ile yapılamaz,bir dosyadaki kodların hepsinin aynı olması gerekmektedir,yani bazıları cari kodu bazıları ise özel kod olamaz'>.<br/>
            <b><font color="FF0000">4_<cf_get_lang dictionary_id ='43194.Muhasebe Hes'></font></b>: <cf_get_lang dictionary_id ='44204.Sisteminizde kayıtlı olan muhasebe hesap numaralarından bir tanesini girmeniz gerekmektedir,eğer sisteminizde tanımılı değilse bu numara kayıt yapılmayacaktır'>. <br/>
            <b><font color="FF0000">5_<cf_get_lang dictionary_id='57916.Konsinye Mal Hesabı'> </font></b>: <cf_get_lang dictionary_id ='44204.Sisteminizde kayıtlı olan muhasebe hesap numaralarından bir tanesini girmeniz gerekmektedir,eğer sisteminizde tanımılı değilse bu numara kayıt yapılmayacaktır'>.(<cf_get_lang dictionary_id ='44205.Sadece kurumsal üyeler için geçerlidir,bireysel üyeler için boş bırakılabilir'>)<br/>
            <b><font color="FF0000">6_<cf_get_lang dictionary_id='58733.Alıcı'></font></b>: <cf_get_lang dictionary_id ='44206.Üyeniz Alıcı ise 1,değilse 0yazınız'>.<br/>
            <b><font color="FF0000">7_<cf_get_lang dictionary_id='58873.Satıcı'></font></b>:<cf_get_lang dictionary_id ='44207.Üyeniz Satıcı ise 1,değilse0 yazınız'>.<br/>
            <b><font color="FF0000">8_ <cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'></font></b> : <cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'> <cf_get_lang dictionary_id='57613.yazınız'>.<br/>
            <b><font color="FF0000">9_ <cf_get_lang dictionary_id='38373.Satış Hesabı'></font></b>: <cf_get_lang dictionary_id='38373.Satış Hesabı'><cf_get_lang dictionary_id='57613.yazınız'>.<br/>
            <b><font color="FF0000">10_ <cf_get_lang dictionary_id='38375.Alış Hesabı'></font></b>: <cf_get_lang dictionary_id='38375.Alış Hesabı'><cf_get_lang dictionary_id='57613.yazınız'>.<br/>
            <b><font color="FF0000">11_ <cf_get_lang dictionary_id='40316.Alınan Teminat'><cf_get_lang dictionary_id='48668.Hesabı'></font></b>: <cf_get_lang dictionary_id='40316.Alınan Teminat'><cf_get_lang dictionary_id='48668.Hesabı'><cf_get_lang dictionary_id='57613.yazınız'>.<br/>
            <b><font color="FF0000">12_ <cf_get_lang dictionary_id='58490.Verilen'><cf_get_lang dictionary_id='58689.Teminat'><cf_get_lang dictionary_id='48668.Hesabı'></font></b>: <cf_get_lang dictionary_id='58490.Verilen'><cf_get_lang dictionary_id='58689.Teminat'><cf_get_lang dictionary_id='48668.Hesabı'><cf_get_lang dictionary_id='57613.yazınız'>.<br/>
            <b><font color="FF0000">13_ <cf_get_lang dictionary_id='58488.Alınan'><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'></font></b>: <cf_get_lang dictionary_id='58488.Alınan'><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'><cf_get_lang dictionary_id='57613.yazınız'>.<br/>
            <b><font color="FF0000">14_ <cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38373.Satış Hesabı'></font></b>: <cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38373.Satış Hesabı'><cf_get_lang dictionary_id='57613.yazınız'>  .<br/>
            <b><font color="FF0000">15_ <cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38375.Alış Hesabı'></font></b>: <cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38375.Alış Hesabı'><cf_get_lang dictionary_id='57613.yazınız'>.<br/>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="3" sort="true">
    <br /><b>&nbsp;<cf_get_lang dictionary_id ='43927.Örnek CSV dosyanız aşağıdaki gibi olmalıdır'></b><br/><br/>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id ='43926.Üye Tipi'></th>
                    <th><cf_get_lang dictionary_id ='57485.Öncelik'></th>
                    <th><cf_get_lang dictionary_id ='43925.Cari Kodu veya Özel Kod'></th>
                    <th><cf_get_lang dictionary_id ='43194.Muhasebe Hes'></th>
                    <th><cf_get_lang dictionary_id='57916.Konsinye Mal Hesabı'></th>
                    <th><cf_get_lang dictionary_id='58733.Alıcı'></th>
                    <th><cf_get_lang dictionary_id='58873.Satıcı'></th>
                    <th><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'></th>
                    <th><cf_get_lang dictionary_id='38373.Satış Hesabı'></th>
                    <th><cf_get_lang dictionary_id='38375.Alış Hesabı'></th>
                    <th><cf_get_lang dictionary_id='40316.Alınan Teminat'><cf_get_lang dictionary_id='48668.Hesabı'></th>
                    <th><cf_get_lang dictionary_id='58490.Verilen'><cf_get_lang dictionary_id='58689.Teminat'><cf_get_lang dictionary_id='48668.Hesabı'></th>
                    <th><cf_get_lang dictionary_id='58488.Alınan'><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'></th>
                    <th><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38373.Satış Hesabı'></th>
                    <th><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38375.Alış Hesabı'></th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td> K</td>
                    <td> 1</td>
                    <td> C13</td>
                    <td> 320.50.01</td>
                    <td> 100.20.00001</td>
                    <td> 1</td>
                    <td> 1</td>
                    <td> 100.01.002</td>
                    <td> 100.01.3</td>
                    <td> 100.03.001</td>
                    <td> 100.03.001</td>
                    <td> 101.01.001</td>
                    <td> 100.01.002</td>
                    <td> 101.01.008</td>
                    <td> 100.25.003</td>
                </tr>
                <tr>
                    <td> B</td>
                    <td> 1</td>
                    <td> B899</td>
                    <td> 320.50.01</td>
                    <td> 102.10.00010</td>
                    <td> 0</td>
                    <td> 1</td>
                    <td> 100.03.008</td>
                    <td> 100.11.3</td>
                    <td> 100.03.021</td>
                    <td> 100.03.001</td>
                    <td> 111.01.001</td>
                    <td> 100.01.102</td>
                    <td> 101.01.004</td>
                    <td> 100.15.001</td>
                </tr>
            </tbody>
        </cf_grid_list>
        <div>
       
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer> 
    </cf_box_elements>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(form_import.uploaded_file.value.length ==0)
	{
		alert("<cf_get_lang dictionary_id ='43424.Belge Seçmelisiniz'>");
		return false;
	}
		if(form_import.period_id.value.length ==0)
	{
		alert("<cf_get_lang dictionary_id ='43274.Dönem Seçmelisiniz'>");
		return false;
	}
		return true;
}
</script>

