<cf_catalystHeader>
    <cfobject name="myhome_employee_mandate_component" component="V16.myhome.cfc.myhome_employee_mandate">
<cfset myhome_employee_mandate_component.init()>
<cfset mandate_query = myhome_employee_mandate_component.mandate_get(argumentCollection=attributes)>

    <cfif mandate_query.mandate_id eq session.ep.userid>
        <cfset attributes.is_mandate = 0>
        <cfsavecontent variable="getlang_title"><cf_get_lang dictionary_id="58488.Alınan"><cf_get_lang dictionary_id='59872.Vekalet'></cfsavecontent>
        <cfelse>
            <cfset attributes.is_mandate = 1>
            <cfsavecontent variable="getlang_title"><cf_get_lang dictionary_id="58490.Verilen"><cf_get_lang dictionary_id='59872.Vekalet'></cfsavecontent>
        </cfif>
    <cf_box title="#getlang_title#">           
            <cfinclude template="../widgets/upd/widget.cfm">
    </cf_box>
    <script>

        function kontrol() { 
    
                var mandate_id=document.getElementById("mandate_mandate_id").value;
                if (mandate_id == '') {
                    alert("<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="60285.Vekalet Alan"></cfoutput>"); 
                    return false;
                }
                
                var employee_id=document.getElementById("mandate_employee_id").value;
                if (employee_id == '') {
                    alert("<cfoutput><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id="59855.Vekalet Veren"></cfoutput>");
                    return false;
                }
                
                if (mandate_id == employee_id) {
                    alert("<cfoutput><cf_get_lang dictionary_id="60906.Vekalet Alan ile Vekalet Veren Aynı Olamaz "></cfoutput>"); 
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

                var start_new = js_date(document.getElementById('startdate').value);
                var finish_new = js_date(document.getElementById('finishdate').value);
                var listParam = start_new + "*"+ finish_new + "*" + employee_id;
                employee_mandate_control = wrk_safe_query("hr_employee_mandate",'dsn',0,listParam);        
                if(employee_mandate_control.recordcount > 0)
                {
                    alert('<cf_get_lang dictionary_id="60907.Aynı Tarih Aralığında Girilmiş Vekalet Kaydınız Bulunmaktadır."><cf_get_lang dictionary_id="59842.Lütfen Kaydı Kontrol Ediniz">');
                    return false;
                }
        
                return process_cat_control();          
        }
    </script>