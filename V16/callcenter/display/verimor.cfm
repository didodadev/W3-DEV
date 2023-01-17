<cfset getComponent = createObject('component', 'WEX.cti.cfc.verimor')>
<cfset getCallInformations = getComponent.getCallInformations()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfif getCallInformations.is_cti_integrated eq 1 and len(getCallInformations.api_key)>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62637.Arama Kayıtları'></cfsavecontent>
            <cf_box id="cdrs" title="#head#" widget_load="cdrs"></cf_box>
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62636.Rehber'></cfsavecontent>
            <cf_box id="contact_group" title="#head#" add_href="javascript:add_contact()">
                <cf_flat_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='44592.İsim'></th>
                            <th><cf_get_lang dictionary_id='44593.Soyisim'></th>
                            <th><cf_get_lang dictionary_id='57571.Ünvan'></th>
                            <th><cf_get_lang dictionary_id='57574.Company'></th>
                            <th><cf_get_lang dictionary_id='57499.Phone'></th>
                            <th><cf_get_lang dictionary_id='57428.Email'></th>
                            <th><cf_get_lang dictionary_id='39079.Birthday'></th>
                            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                            <th><cf_get_lang dictionary_id='62631.Aylık SMS Mesajı'></th>
                        </tr>
                    </thead>
                    <tbody id="contact_list"></tbody>
                </cf_flat_list>
            </cf_box>
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='58646.Kara Liste'></cfsavecontent>
            <cf_box id="blocked_numbers" title="#head#" add_href="javascript:add_block_number()">
                <cf_flat_list>
                    <thead>
                        <tr>
                            <th width="20"><a href="javascript://" onclick="add_block_number()" title="<cf_get_lang dictionary_id='44630.Ekle'>"><i class="fa fa-plus"></i></a></th>
                            <th><cf_get_lang dictionary_id='35669.Number'></th>
                        </tr>
                    </thead>
                    <tbody id="blocked_numbers_list"></tbody>
                </cf_flat_list>
            </cf_box>
        </div>
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62632.Kuyruklar'></cfsavecontent>
            <cf_box id="queues" title="#head#">
                <cf_flat_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='57487.No'></th>
                            <th><cf_get_lang dictionary_id='44592.İsim'></th>
                        </tr>
                    </thead>
                    <tbody id="queues_list"></tbody>
                </cf_flat_list>
            </cf_box>
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62633.MT Durumları'></cfsavecontent>
            <cf_box id="agent_status" title="#head#">
                <cf_flat_list>
                    <thead>
                       <tr>
                        <th><cf_get_lang dictionary_id='58795.Customer Representative'></th>
                        <th><cf_get_lang dictionary_id='57756.Status'></th>
                        <th><cf_get_lang dictionary_id='62632.Kuyruklar'></th>
                       </tr>
                    </thead>
                    <tbody id="agent_status_list"></tbody>
                </cf_flat_list>
            </cf_box>
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62634.Ses Dosyaları'></cfsavecontent>
            <cf_box id="announcements" title="#head#" <!--- add_href="javascript:add_announcements()" --->>
                <cf_flat_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='57487.No'></th>
                            <th><cf_get_lang dictionary_id='44592.İsim'></th>
                        </tr>
                    </thead>
                    <tbody id="announcements_list"></tbody>
                </cf_flat_list>
            </cf_box>
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62638.Dahili Durumları'></cfsavecontent>
            <cf_box id="user_status" title="#head#">
                <cf_flat_list>
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='30259.Dahili'></th>
                            <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                            <th><cf_get_lang dictionary_id='57756.Status'></th>
                       </tr>
                    </thead>
                    <tbody id="user_status_list"></tbody>
                </cf_flat_list>
            </cf_box>
        </div>
        <div id="black_list_modal" class="ui-cfmodal" style="display:none">
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='62635.Engelle'></cfsavecontent>
            <cf_box title="#head#" closable="1" draggable="1" close_href="javascript:gizle(black_list_modal)">
                <form id="black_list_add">
                    <div class="ui-row">
                        <div class="ui-form-list ui-form-block">                                   
                            <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                                <label><cf_get_lang dictionary_id='35669.Number'></label>
                                <input type="text" name="number" id="number" required>
                            </div>
                        </div>
                    </div>
                    <div class="ui-form-list-btn">
                        <div>
                            <input type="submit" id="black_list_add_button" class="ui-btn ui-btn-success" value="<cf_get_lang dictionary_id='44630.Ekle'>">
                        </div>
                    </div>
                </form>
            </cf_box>
        </div>
        <div id="contacts_add_modal" class="ui-cfmodal" style="display:none">
            <cfsavecontent  variable="head"><cf_get_lang dictionary_id='38344.Kişi Ekle'></cfsavecontent>        
            <cf_box title="#head#" closable="1" draggable="1" close_href="javascript:gizle(contacts_add_modal)">
                <form id="contacts_add">
                    <div class="ui-row">
                        <div class="ui-form-list ui-form-block">          
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='54265.TC No'></label>
                                    <input type="text" name="tckn" id="tckn">
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='44592.İsim'></label>
                                    <input type="text" name="name" id="name" required>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='44593.Soyisim'></label>
                                    <input type="text" name="surname" id="surname" required>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='39079.Birthday'></label>
                                    <div class="input-group">
                                        <input type="text" name="birthday" id="birthday">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="birthday"></span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <input type="text" name="description" id="description">
                                </div>
                            </div>   
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57574.Company'></label>
                                    <input type="text" name="company_name" id="company_name">
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57571.Ünvan'></label>
                                    <input type="text" name="title" id="title">
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57499.Phone'></label>
                                    <input type="text" name="phone" id="phone" required>
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57499.Phone'> 1</label>
                                    <input type="text" name="phone1" id="phone1">
                                </div>
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='57428.Email'></label>
                                    <input type="text" name="email" id="email">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ui-form-list-btn">
                        <div>
                            <input type="submit" id="contacts_add_button" class="ui-btn ui-btn-success" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
                        </div>
                    </div>
                </form>
            </cf_box>
        </div>
        <!--- Ses dosyası eklerken dönüştürme ile ilgili problem çözülene kadar kapatıldı. E.Yılmaz --->
        <!--- <div id="announcements_add_modal" class="ui-cfmodal" style="display:none">
            <cf_box title="Ses Dosyası Yükle" closable="1" draggable="1" close_href="javascript:gizle(announcements_add_modal)">
                <form id="announcements_add">
                    <div class="ui-row">
                        <div class="ui-form-list ui-form-block">          
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <div class="form-group">
                                    <label><cf_get_lang dictionary_id='44592.İsim'></label>
                                    <input type="text" name="name_sound" id="name_sound">
                                </div>
                                <textarea id="sounddata" name="sounddata" cols="100" rows="10" style="display:none"></textarea>
                                <div class="form-group">
                                    <label>Dosya</label>
                                    <input type="file" accept="audio/*" >
                                </div>
                                <!--- <button onclick="playSound()" disabled>Start</button>
                                <button onclick="stopSound()" disabled>Stop</button> --->
                            </div>  
                        </div>
                    </div>
                    <div class="ui-form-list-btn">
                        <div>
                            <input type="button" id="announcements_add_button" class="ui-btn ui-btn-success" value="Ekle">
                        </div>

                    </div>
                </form>
            </cf_box>
        </div> --->
        <script type="text/javascript">
            /* Ses dosyası dönüştürme fonksiyonları
            var context = new AudioContext();
            var source = null;
            var audioBuffer = null;
            // Converts an ArrayBuffer to base64, by converting to string 
            // and then using window.btoa' to base64. 
            var bufferToBase64 = function (buffer) {
                var bytes = new Uint8Array(buffer);
                var len = buffer.byteLength;
                var binary = "";
                for (var i = 0; i < len; i++) {
                    binary += String.fromCharCode(bytes[i]);
                }
                return window.btoa(binary);
            };
            var base64ToBuffer = function (buffer) {
                var binary = window.atob(buffer);
                var buffer = new ArrayBuffer(binary.length);
                var bytes = new Uint8Array(buffer);
                for (var i = 0; i < buffer.byteLength; i++) {
                    bytes[i] = binary.charCodeAt(i) & 0xFF;
                }
                return buffer;
            };
            function stopSound() {
                if (source) {
                    source.stop(0);
                }
            }
            function playSound() {
                // source is global so we can call .stop() later.
                source = context.createBufferSource();
                source.buffer = audioBuffer;
                source.loop = false;
                source.connect(context.destination);
                source.start(0); // Play immediately.
            }
            function initSound(arrayBuffer) {
                var base64String = bufferToBase64(arrayBuffer);
                var audioFromString = base64ToBuffer(base64String);
                document.getElementById("sounddata").value=base64String;
                context.decodeAudioData(audioFromString, function (buffer) {
                    // audioBuffer is global to reuse the decoded audio later.
                    audioBuffer = buffer;
                    var buttons = document.querySelectorAll('button');
                    buttons[0].disabled = false;
                    buttons[1].disabled = false;
                }, function (e) {
                    console.log('Error decoding file', e);
                });
            }
            // User selects file, read it as an ArrayBuffer and pass to the API.
            var fileInput = document.querySelector('input[type="file"]');
            fileInput.addEventListener('change', function (e) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    initSound(this.result);
                };
                reader.readAsArrayBuffer(this.files[0]);
            }, false);
            // Load file from a URL as an ArrayBuffer.
            // Example: loading via xhr2: loadSoundFile('sounds/test.mp3');
            function loadSoundFile(url) {
                var xhr = new XMLHttpRequest();
                xhr.open('GET', url, true);
                xhr.responseType = 'arraybuffer';
                xhr.onload = function (e) {
                    initSound(this.response); // this.response is an ArrayBuffer.
                };
                xhr.send();
            } */
            $(function (){
                var records = {};
                records.api_key="<cfoutput>#getCallInformations.api_key#</cfoutput>";
                records.extension = "<cfoutput>#getCallInformations.extension#</cfoutput>";
              
                $.ajax({
                    url :'/wex.cfm/cti/user_status',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(records),
                    success : function(response){
                        for (var i = 0; i < response.length; i++) {
                            var statu = '<cf_get_lang dictionary_id='46890.Çevrimdışı'>';
                            if(response[i].status == 'AVAILABLE')
                                statu = '<cf_get_lang dictionary_id='62644.Müsait'>';
                            else if(response[i].status == 'TALKING')
                                statu = '<cf_get_lang dictionary_id='62645.Çağrıda'>';
                            var newRow, newCell;
                            newRow = document.getElementById("user_status_list").insertRow();	
                            newCell = newRow.insertCell(newRow.cells.length);
                            newCell.innerHTML =  response[i].user;
                            newCell = newRow.insertCell(newRow.cells.length);
                            var get_name = wrk_query("SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EXTENSION LIKE '%"+response[i].user+"%'",'dsn' );
                            newCell.innerHTML =  get_name.EMPLOYEE;
                            newCell = newRow.insertCell(newRow.cells.length);
                            newCell.innerHTML =  statu;
                        }
                    },
                    error : function(){alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>! <cf_get_lang dictionary_id='62646.Dahililer listelenemedi'>!")}
                });
                $.ajax({
                    url :'/wex.cfm/cti/queues',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(records),
                    success : function(response){
                        if(response.length == 0){
                            var newRow, newCell;
                            newRow = document.getElementById("queues_list").insertRow();	
                            newCell = newRow.insertCell(newRow.cells.length);
                            newCell.innerHTML =  '<cf_get_lang dictionary_id='57484.Kayıt Yok'>!';
                            newCell = newRow.insertCell(newRow.cells.length);
                            newCell.innerHTML =  '';
                        }
                        else{
                            for (var i = 0; i < response.length; i++) {
                                var newRow, newCell;
                                newRow = document.getElementById("queues_list").insertRow();	
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response[i].number;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response[i].name;
                            }
                        }
                    },
                    error : function(){alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>! <cf_get_lang dictionary_id='62647.Kuyruklar listelenemedi'>.")}
                });
                $.ajax({
                    url :'/wex.cfm/cti/agent_status',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(records),
                    success : function(response){
                        if(response.length == 0){
                            var newRow, newCell;
                            newRow = document.getElementById("agent_status_list").insertRow();	
                            newCell = newRow.insertCell(newRow.cells.length);
                            newCell.colSpan = 3;
                            newCell.innerHTML =  '<cf_get_lang dictionary_id='57484.Kayıt Yok'>!';
                        }
                        else{
                            for (var i = 0; i < response.length; i++) {
                                var statu = '<cf_get_lang dictionary_id='62644.Müsait'>';
                                if(response[i].status == 'LOGGED_OUT')
                                    statu = '<cf_get_lang dictionary_id='46890.Çevrimdışı'>';
                                else if(response[i].status == 'TALKING')
                                    statu = '<cf_get_lang dictionary_id='62645.Çağrıda'>';
                                else if(response[i].status == 'ON_BREAK')
                                    statu = '<cf_get_lang dictionary_id='62648.Molada'>';
                                var newRow, newCell;
                                newRow = document.getElementById("agent_status_list").insertRow();	
                                newCell = newRow.insertCell(newRow.cells.length);
                                var get_name = wrk_query("SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS EMPLOYEE FROM EMPLOYEES WHERE EXTENSION LIKE '%"+response[i].agent+"%'",'dsn' );
                                newCell.innerHTML =  get_name.EMPLOYEE;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response[i].status;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  statu;
                            }
                        }
                    },
                    error : function(){alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>!  <cf_get_lang dictionary_id='62649.MT (Müşteri Temsilcisi) Durumları listelenemedi.'>")}
                });
                $.ajax({
                    url :'/wex.cfm/cti/announcements',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(records),
                    success : function(response){
                        if(response.length == 0){
                            var newRow, newCell;
                            newRow = document.getElementById("announcements_list").insertRow();	
                            newCell = newRow.insertCell(newRow.cells.length);
                            newCell.colSpan = 2;
                            newCell.innerHTML =  '<cf_get_lang dictionary_id='57484.Kayıt Yok'>!';
                        }
                        else{
                            for (var i = 0; i < response.length; i++) {
                                var newRow, newCell;
                                newRow = document.getElementById("announcements_list").insertRow();	
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  i+1;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response[i].name;
                            }
                        }
                    },
                    error : function(){alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>! <cf_get_lang dictionary_id='62650.Ses kayıtları listelenemedi'>.")}
                });               
                $.ajax({
                    url :'/wex.cfm/cti/contacts',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(records),
                    success :  function(response){ 
                        if(response.contacts.length == 0){
                            var newRow, newCell;
                            newRow = document.getElementById("contact_list").insertRow();	
                            newCell = newRow.insertCell(newRow.cells.length);
                            newCell.colSpan = 9;
                            newCell.innerHTML =  '<cf_get_lang dictionary_id='57484.Kayıt Yok'>!';
                        }
                        else{
                            for (var i = 0; i < response.contacts.length; i++) {
                                var newRow, newCell;
                                newRow = document.getElementById("contact_list").insertRow();	
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].name;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].surname;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].title;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].company_name;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].phone;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].email;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].birthday;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].description;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.contacts[i].monthly_sms_message;
                                // newCell = newRow.insertCell(newRow.cells.length);
                                // newCell.innerHTML =  '<a href="javascript://" onclick="del_contact('+response.contacts[i].id+')"><i class="fa fa-minus"></i></a>';
                            }
                        }
                    },
                    error : function(){
                        alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>! <cf_get_lang dictionary_id='62651.Rehbere Erişilemedi'>.");
                    }
                });
                $.ajax({
                    url :'/wex.cfm/cti/blocked_numbers',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(records),
                    success :  function(response){ ;
                        if(response.blocked_numbers.length == 0){
                            var newRow, newCell;
                            newRow = document.getElementById("blocked_numbers_list").insertRow();	
                            newCell = newRow.insertCell(newRow.cells.length);
                            newCell.colSpan = 2;
                            newCell.innerHTML =  '<cf_get_lang dictionary_id='57484.Kayıt Yok'>!';
                        }
                        else{
                            for (var i = 0; i < response.blocked_numbers.length; i++) {
                                var newRow, newCell;
                                newRow = document.getElementById("blocked_numbers_list").insertRow();	
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  i+1;
                                newCell = newRow.insertCell(newRow.cells.length);
                                newCell.innerHTML =  response.blocked_numbers[i].number;    
                            }
                        }
                    },
                    error : function(){
                        alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>! <cf_get_lang dictionary_id='62652.Kara Listeye Erişilemedi'>.");
                    }
                }); 
            }); 
            function add_block_number(){
                $('#black_list_modal').show();
                var formList = {};
            
                $('#black_list_add').on("submit", function(event) {
                    formList.api_key = "<cfoutput>#getCallInformations.api_key#</cfoutput>";
                    $.each($(this).serializeArray(),function(i, v) {
                        formList[v.name] = v.value;
                    });
                
                    $.ajax({
                        url :'/wex.cfm/cti/blocked_numbers_add',
                        method: 'post',
                        contentType: 'application/json; charset=utf-8',
                        dataType: "json",
                        data : JSON.stringify(formList),
                        success :  function(response){
                            alert("<cf_get_lang dictionary_id='62643.Kara listeye eklendi'>.");
                            location.reload();
                            
                        },
                        error :  function(){
                            alert("<cf_get_lang dictionary_id='62642.Ekleme başarısız'>.");
                            location.reload();
                            
                        }
                    });
                    
                });	
            
            }
            function add_contact(){
                $('#contacts_add_modal').show();
                var formList = {};
                formList.api_key = "<cfoutput>#getCallInformations.api_key#</cfoutput>";
                $('#contacts_add').on("submit", function(event) {
                    $.each($(this).serializeArray(),function(i, v) {
                        formList[v.name] = v.value;
                    });
                
                    $.ajax({
                        url :'/wex.cfm/cti/contacts_add',
                        method: 'post',
                        contentType: 'application/json; charset=utf-8',
                        dataType: "json",
                        data : JSON.stringify(formList),
                        success :  function(response){
                            alert("<cf_get_lang dictionary_id='62641.Kişi eklendi'>.");
                            location.reload();
                            
                        },
                        error :  function(){
                            alert("<cf_get_lang dictionary_id='62642.Ekleme başarısız'>.");
                            location.reload();
                            
                        }
                    });
                    
                });	
            }
            /* function del_contact(id){
                var obj = {};
                obj.api_key = "<cfoutput>#getCallInformations.api_key#</cfoutput>";
                obj.id = id;
                $.ajax({
                    url :'/wex.cfm/cti/contacts_del',
                    method: 'post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: "json",
                    data : JSON.stringify(obj),
                    success :  function(response){ 
                        alert("Kişi silindi!");
                        location.reload();
                    },
                    error : function(){
                        alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>! Silinemedi.");
                        location.reload();
                    }
                });
            }
            function add_announcements(){
                $('#announcements_add_modal').show();
                var formList = {};
            
                $('#announcements_add_button').click(function(event) {
                    formList.api_key = "<cfoutput>#getCallInformations.api_key#</cfoutput>";
                    formList.name = $('#name_sound').val();
                    formList.sounddata = $('#sounddata').val();
                    $.ajax({
                        url :'/wex.cfm/cti/announcements_upload',
                        method: 'post',
                        contentType: 'application/x-www-form-urlencoded',
                        dataType: "json",
                        data : JSON.stringify(formList),
                        success :  function(response){
                            alert("Ses dosyası yüklendi.");
                            location.reload();
                            
                        },
                        error :  function(){
                            alert("Ses dosyası yüklenirken hata oluştu.");
                            location.reload();
                            
                        }
                    });
                    
                });	
            } */
        </script>
    <cfelse>
        <cf_box>
            <div class="ui-info-text">
                <p><cf_get_lang dictionary_id='62639.Şirketin entegrasyon tanımlamaları eksik!'> <a href="<cfoutput>#request.self#?fuseaction=settings.form_list_company</cfoutput>"><cf_get_lang dictionary_id='62640.Şirket akış parametrelerinden tanımlayabilirsiniz'></a></p>
            </div>
        </cf_box>
    </cfif>
</div>
