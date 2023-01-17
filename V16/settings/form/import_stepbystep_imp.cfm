<!--- 
    Oluşturan : Botan Kayğan
    Mail : botankaygan@workcube.com
    Tarih : 14.03.2021
    Açıklama : İmplementasyon Adımları import sayfasıdır. WBP/FactorySettings/install/implementation_step.txt dosyasını okuyarak adımları silerek import işlemini gerçekleştirir.
--->

<cf_box title="#getLang(dictionary_id : 62380)#" closable="0" collapsable="0">
    <cf_form_box>
        <cf_area>
            <table>
                <tr>
                    <td>
                        <p><cf_get_lang dictionary_id='62382.Mevcut veri silinerek adımlar yeniden oluşturulacaktır.'></p>
                        <p id="message_" style="display:none;"></p>
                    </td>
                </tr>
            </table>
        </cf_area>
        <cf_form_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='import_stepbystep_imp()' insert_info='#getLang(dictionary_id : 48972)#' insert_alert='#getLang(dictionary_id : 62381)#'>
        </cf_form_box_footer>
    </cf_form_box>
</cf_box>

<script type="text/javascript">
    function import_stepbystep_imp() {
        get_wrk_message_div("<cf_get_lang dictionary_id='29729.İşlem durumu'>","<cf_get_lang dictionary_id='29730.İşleminiz yapılıyor, lütfen bekleyiniz...'>");
        var data = new FormData();
		AjaxControlPostDataJson('V16/settings/cfc/StepByStep.cfc?method=import_implementation_steps',data,function(response) {
			if(response.STATUS == 1){
                alert("<cf_get_lang dictionary_id='52459.İmport İşlemi Başarıyla Tamamlandı'>!");
                $('#message_').html("<cf_get_lang dictionary_id='52459.İmport İşlemi Başarıyla Tamamlandı'>!");
                $('#message_').css('color','green');
            }
            else if (response.STATUS == 0){
                alert("<cf_get_lang dictionary_id='33592.Kaydetme işlemi yapılırken bir hata oluştu'>!");
                $('#message_').html("<cf_get_lang dictionary_id='33592.Kaydetme işlemi yapılırken bir hata oluştu'>!");
                $('#message_').css('color','red');
            }
            else{
                alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>!");
                $('#message_').html("<cf_get_lang dictionary_id='29450.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>!");
                $('#message_').css('color','red');
            }
            document.getElementById("working_div_main").style.display = 'none' ;
            $('#message_').css('display','');
		});
        return false;
    }
</script>