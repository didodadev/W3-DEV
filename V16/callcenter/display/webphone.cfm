<cfset getComponent = createObject('component', 'WEX.cti.cfc.verimor')>
<cfset getCallInformations = getComponent.getCallInformations()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfif getCallInformations.recordcount and getCallInformations.IS_CTI_INTEGRATED eq 1 and len(getCallInformations.api_key) and len(getCallInformations.extension)>    
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62367.Adres Defteri Ara'></cfsavecontent>
            <cf_box title="#head#" id="div_phone_book">
                <div id="phone-book"></div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_flat_list>
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='62337.Cevapsız Çağrılar'></th>
                            </tr>
                        </thead>
                        <tbody id="missed_call">
                        </tbody>
                    </cf_flat_list>
                </div>
            </cf_box>
        </div>     
        <cfif isdefined("getCallInformations.tel_type") and getCallInformations.tel_type neq 3>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <cf_box title="Web Phone">
                    <div id="web_iframe_drag"></div>
                </cf_box>
            </div>
        </cfif>
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12 webphone" id="item-contact"></div>   
        <script>
            var records = {};
            records.api_key="<cfoutput>#getCallInformations.api_key#</cfoutput>";
            records.extension = "<cfoutput>#getCallInformations.extension#</cfoutput>";
            $(function (){
                AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone_book','phone-book');
                $.ajax({
                    url :'/wex.cfm/cti/webphone_iframe',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(records),
                    error :  function(response){
                        if(response.responseText.indexOf("cannot find employee for extension") != -1)
                            alert("<cf_get_lang dictionary_id='62462.Verdiğiniz dahili (extension) için personel hesabı oluşturulmamış'>!");
                        else if(response.responseText.indexOf("cannot find user for extension") != -1)
                            alert("<cf_get_lang dictionary_id='62463.Verdiğiniz dahili (extension) numarası geçersiz, bu numaralı bir dahili bulunamadı'>!");
                        else if(response.responseText.indexOf("missing extension") != -1)
                            alert("<cf_get_lang dictionary_id='62464.Dahili (extension) parametresini vermediniz!'>");
                        else{
                            var iframe = $('<iframe>');
                            iframe.attr({"src": "https://oim.verimor.com.tr/webphone?token="+response.responseText,"width":"100%" ,"height":"570px","allow":"microphone"});
                            $( '#web_iframe_drag' ).append(iframe);                                                 
                        }                          
                    
                    }
                });
                $.ajax({
                    url :'/wex.cfm/cti/cdrs',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(formObjects),
                    success : function(response){
                        var record_control = 0;

                        for (var i = 0; i < response.cdrs.length; i++) {                    
                            if(response.cdrs[i].result !== 'Cevaplandı' && response.cdrs[i].destination_number.includes(records.extension) ){
                                var tel = 'Bilinmeyen Numara';
                                var newRow, newCell;                   
                                newRow = document.getElementById("missed_call").insertRow();	
                                record_control = 1;
                                if(response.cdrs[i].direction == 'gelen')
                                    str = "SELECT TOP 1 COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS NAMES, COMPANY.FULLNAME FROM COMPANY_PARTNER LEFT JOIN COMPANY ON COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID WHERE CONCAT(COMPANY_PARTNER.MOBIL_CODE, COMPANY_PARTNER.MOBILTEL) LIKE '" + response.cdrs[i].caller_id_number + "' OR CONCAT(COMPANY.MOBIL_CODE, COMPANY.MOBILTEL) = '" + response.cdrs[i].caller_id_number +"' OR CONCAT(COMPANY_PARTNER.COMPANY_PARTNER_TELCODE, COMPANY_PARTNER.COMPANY_PARTNER_TEL) =  '" + response.cdrs[i].caller_id_number +"' OR CONCAT(COMPANY.COMPANY_TELCODE,COMPANY.COMPANY_TEL1)  LIKE  '" + response.cdrs[i].caller_id_number +"' OR CONCAT(COMPANY.COMPANY_TELCODE,COMPANY.COMPANY_TEL2) LIKE  '" + response.cdrs[i].caller_id_number +"' OR CONCAT(COMPANY.COMPANY_TELCODE,COMPANY.COMPANY_TEL3) LIKE  '" + response.cdrs[i].caller_id_number +"' UNION ALL SELECT CONSUMER_NAME  + ' ' + CONSUMER_SURNAME AS NAMES, COMPANY AS FULLNAME FROM CONSUMER WHERE CONCAT(CONSUMER_HOMETEL,CONSUMER_HOMETEL)  LIKE  '" + response.cdrs[i].caller_id_number +"' OR  CONCAT(MOBIL_CODE,MOBILTEL)  LIKE  '" + response.cdrs[i].caller_id_number +"'";
                                else if(response.cdrs[i].direction == 'Santral içi')
                                    str = "SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS NAMES, COMPANY.FULLNAME FROM EMPLOYEES LEFT JOIN COMPANY ON EMPLOYEES.COMPANY_ID = COMPANY.COMPANY_ID  WHERE EXTENSION = "+response.cdrs[i].caller_id_number;

                                var get_name = wrk_query(str,'dsn' );
                                if(get_name.NAMES && get_name.FULLNAME)
                                    tel = get_name.FULLNAME + " - " + get_name.NAMES ;
                                newCell = newRow.insertCell(newRow.cells.length);  
                                newCell.innerHTML =  tel + "<br>" + response.cdrs[i].caller_id_number  + "<br>" + response.cdrs[i].answer_stamp + '<i class="fa fa-copy fa-lg pull-right btnPointer" onclick="copy_tel('+response.cdrs[i].caller_id_number+')" style="color:#fd397a;"></i>   <i class="fa fa-phone fa-lg pull-right btnPointer" onclick="beginCall('+response.cdrs[i].caller_id_number+')" style="color:#0abb87;"></i>' ;
                            }
                        
                        
                            
                        }
                        if(record_control == 0){
                            newRow = document.getElementById("missed_call").insertRow();
                            newCell = newRow.insertCell(newRow.cells.length);  
                            newCell.innerHTML = '<cf_get_lang dictionary_id='57484.No record'>!';
                        }

                    }
                }).done(function() {
                    <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                        beginCall('<cfoutput>#attributes.keyword#</cfoutput>');                              
                    </cfif>       
                });
            });
            function beginCall(destination){
                records.destination=destination;
                $.ajax({
                    url :'/wex.cfm/cti/beginCall',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(records),
                    error :  function(response){   
                        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_callcenter&form_submitted=1&webphone=1&tel=' + destination + '&MOBILTEL=' + destination,'item-contact'); 
                    }

                });
            }
            function copy_tel(tel){
                var $temp = $("<input>");
                $("body").append($temp);
                $temp.val(tel).select();
                document.execCommand("copy");
                $temp.remove();
            }
        </script>
    <cfelse>
        <div class="ui-info-text">
            <h1><cf_get_lang dictionary_id='62460.Şirketin Sanal Santral Entegresyonu Yapılmamıştır!'></h1>
            <span><cf_get_lang dictionary_id='62461.Entegrasyon için iletişime geçiniz.'></span>
            <ul>
                <li><a href="tel:+90 850 441 23 23">+90 850 441 23 23</a></li>
                <li><a href="mailto:workcube@workcube.com">workcube@workcube.com</a></li>
            </ul>
        </div>
    </cfif>
</div>  