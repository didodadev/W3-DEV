
<cf_catalystHeader>
<cfsavecontent variable="getlang_title"><cf_get_lang dictionary_id='59926'></cfsavecontent>
<cf_box>
    <cfset listBeforeFunction = "checkform()" />
		<cfset listBeforeFunction = listAppend( listBeforeFunction, "checkform()", "|" ) />
        <cf_tab defaultOpen="vekalet_ver" divId="vekalet_ver,vekalet_al" divLang="#getLang('','Vekalet Ver',59926)#;#getLang('','Vekalet Al',60288)#" beforeFunction="#listBeforeFunction#">
        <div id="unique_vekalet_ver" class="ui-info-text uniqueBox">
            <cfset attributes.is_mandate = "1">
            <cfinclude template="../widgets/add/widget.cfm">
        </div>
        <div id="unique_vekalet_al" class="ui-info-text uniqueBox">
            <cfset attributes.is_mandate = "0">
            <cfinclude template="../widgets/add/widget.cfm">          
        </div>
    </cf_tab>    
</cf_box>
<script>
    function control() {
    
        var vekalet_ver = document.getElementById("unique_vekalet_ver").style.display;

        if (vekalet_ver == 'block' ) {
            
            var mandate_id=document.getElementById("mandate_mandate_id").value;
            var employee_id=document.getElementById("mandate_employee_id_").value;
            var startdate=document.getElementById("startdate").value;
            var finishdate=document.getElementById("finishdate").value;

            if (mandate_id == '') {
                alert("<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="60285.Vekalet Alan"></cfoutput>"); 
                return false;
            }

            if(datediff(document.getElementById('startdate').value,document.getElementById('finishdate').value,0)<0)
            {
                alert("<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!");
                return false;
            }  
            else if(datediff(document.getElementById('startdate').value,document.getElementById('finishdate').value,0)<=0)
            {
                    if (document.getElementById('start_hour').value > document.getElementById('end_hour').value)
                {
                    alert("<cf_get_lang dictionary_id='53594.Başlangıç Saati Bitiş saatinden büyük olamaz'> !");
                    return false;
                }
                else if ((document.getElementById('start_hour').value == document.getElementById('end_hour').value) && (document.getElementById('start_min').value >= document.getElementById('end_min').value))
                {
                    alert("<cf_get_lang dictionary_id='53595.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz'> !");
                    return false;
                }   
            }
        }
        else 
        {
            var employee_id=document.getElementById("mandate_employee_id").value;
            var mandate_id=document.getElementById("mandate_mandate_id_").value;
            var startdate=document.getElementById("startdate_").value;
            var finishdate=document.getElementById("finishdate_").value;
            if (employee_id == '') {
                alert("<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="59855.Vekalet Veren"></cfoutput>");
                return false;
            }

        if(datediff(document.getElementById('startdate_').value,document.getElementById('finishdate_').value,0)<0)
            {
                alert("<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!");
                return false;
            }  
        else if(datediff(document.getElementById('startdate_').value,document.getElementById('finishdate_').value,0)<=0)
            {
                if (document.getElementById('start_hour_').value > document.getElementById('end_hour_').value)
                {
                    alert("<cf_get_lang dictionary_id='53594.Başlangıç Saati Bitiş saatinden büyük olamaz'> !");
                    return false;
                }
                else if ((document.getElementById('start_hour_').value == document.getElementById('end_hour_').value) && (document.getElementById('start_min_').value >= document.getElementById('end_min_').value))
                {
                    alert("<cf_get_lang dictionary_id='53595.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz'> !");
                    return false;
                }   
            }

            if((document.getElementById('startdate_').value == '') || (document.getElementById('finishdate_').value == ''))
            {
                alert("<cf_get_lang dictionary_id='36830.Başlangıç ve bitiş tarihi giriniz'>!");
                return false;
            } 
        }     

        if (mandate_id == employee_id) {
            alert("<cfoutput><cf_get_lang dictionary_id="60906.Vekalet Alan ile Vekalet Veren Aynı Olamaz "></cfoutput>"); 
            return false;

        }   
        var start_new = js_date(startdate);
        var finish_new = js_date(finishdate);
        var listParam = start_new + "*"+ finish_new + "*" + employee_id;
        employee_mandate_control = wrk_safe_query("hr_employee_mandate",'dsn',0,listParam);        
        if(employee_mandate_control.recordcount > 0)
        {
            alert('<cf_get_lang dictionary_id="60907.Aynı Tarih Aralığında Girilmiş Vekalet Kaydınız Bulunmaktadır."><cf_get_lang dictionary_id="59842.Lütfen Kaydı Kontrol Ediniz">');
            return false;
        }
         return process_cat_control();          
    }
    function checkform(){
        var alert=confirm("<cf_get_lang dictionary_id="50458.Yaptığınız Değişiklikleri Kaybedeceksiniz. Emin misiniz">?");
        if (alert == true) {      
        //Vekalet Ver Form   
            $('#start_hour').val('0');
            $('#start_min').val('0');
            $('#end_hour').val('0');
            $('#end_min').val('0');
            $('#mandate_employee_id').val('');
            $('#mandate_employee_name').val('');
            $('#startdate').val('');
            $('#finishdate').val('');
            $('#mandate_detail').val('');
        //Vekalet Al form
            $('#mandate_mandate_id').val('');
            $('#mandate_mandate_name').val(''); 
            $('#mandate_detail_').val('');  
            $('#start_hour_').val('0');
            $('#start_min_').val('0');
            $('#end_hour_').val('0');
            $('#end_min_').val('0');
            $('#startdate_').val('');
            $('#finishdate_').val('');
        return true;
        }
        else{
            return false;
        }
    }
</script>