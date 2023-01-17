
<!---
    Author: Workcube - Botan Kayğan <botankaygan@workcube.com>
    Date: 13.06.2021
    Description:
	    Süreç aşaması ile İşlem tipi kontrolü.
        Genel Amaçlı Süreç-Aşama ile İşlem Kategorisi seçiminin kontrol edilmesi ve uyarılmasını sağlar.
        Süreç IDler : process_ids değişkeninde set edilmeli. var process_ids = ["2"]; || var process_ids = ["2","3","4"]; şeklinde tanımlanmalıdır.
        İşlem Tipi IDler : process_cat_ids değişkeninde set edilmeli. var process_cat_ids = ["2"]; || var process_cat_ids = ["2","3","4"]; şeklinde tanımlanmalıdır.
        Uyarı mesajı : var warning_msg = 'Lütfen İşlem tipini veya süreci aşamasını kontrol ediniz!'; şeklinde tanımlanmalıdır.
--->
<script type="text/javascript">
    function process_cat_dsp_function()
    {   
        var process_ids = ["1","2"];
        var process_cat_ids = ["3","4"];
        var warning_msg = 'Lütfen İşlem tipini veya süreç aşamasını kontrol ediniz!';
        if( ($('#process_stage').val() != undefined && process_ids.indexOf($('#process_stage').val()) > -1) || ($('#process_cat').val() != undefined &&  process_cat_ids.indexOf($('#process_cat').val()) > -1) ){
            if( !confirm(warning_msg) ) return false;
            else return true;
        }
    }
</script>