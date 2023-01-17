<cfparam  name="attributes.privacy_modal_setting" default="0">
<cfif attributes.privacy_modal_setting eq 0>
    <style>
        .protein-cookie-container-main {
            position: fixed;
            background: #212121;
            z-index: 999;
            color: #e0e0e0;
            left: 0;
            bottom: 0;
            width: 100%;
            padding: 25px 25px;
            font-family: 'PoppinsR';
            font-size: 12px;
        }

        span.cookie-container-close-button {
            position: absolute;
            right: 13px;
        }

        #protein-cookie-settings{
            color:#9e9e9e;
        }
    </style>

    <div class="protein-cookie-container-main" id="privacy_manager_app_bar" v-show="show_cokie_panel" v-if="show_cokie_panel">
        <div class="container-fluid">
            <div class="protein-cookie-message row">
                <div class="protein-cookie-message-text col-lg-7">
                    <p>
                        <cf_get_lang dictionary_id='64990."Tümüne İzin Ver"i tıkladığınızda, sitede gezinmeyi geliştirmek, site kullanımını analiz etmek ve pazarlama çabalarımıza yardımcı olmak için cihazınızda çerezlerin saklanmasını kabul etmiş olursunuz.'>
                        <a href="javasctipt://" onclick="openBoxDraggable('widgetloader?widget_load=privacy_modal&privacy_modal_setting=show&isbox=1')"><cf_get_lang dictionary_id='64991.Çerez Bildirimi'></a>
                    </p>
                </div>
                <div class="protein-cookie-button col-lg-5">
                    <div class="row">
                    <button id="protein-cookie-settings" class="btn btn-sm btn-muted mr-2" onclick="openBoxDraggable('widgetloader?widget_load=privacy_modal&privacy_modal_setting=show&isbox=1')"><cf_get_lang dictionary_id='64992.Ayarları Düzenle'></button>
                    </div>
                        <div class="row">
                    
                        <button id="protein-cookie-all-acccept" class="btn btn-sm btn-success mr-2" @click="allSave()"><cf_get_lang dictionary_id='64996.Tümüne İzin Ver'></button>
                    <button id="protein-cookie-all-decline" class="btn btn-sm btn-success mr-2" @click="allDecline()"><cf_get_lang dictionary_id='64997.Tümünü Red Et'></button>
                </div>
                </div>
                <span class="cookie-container-close-button" onClick="document.querySelector('.protein-cookie-container-main').style.display = 'none';"><i class="fas fa-times"></i></span>
            </div>
        </div>
    </div>
    <script>
        var proteinAppPrivacyBar = new Vue({
            el: '#privacy_manager_app_bar',
            data: {  
                show_cokie_panel: false,      
                data_packet  : {
                    cfc : 'V16/objects2/protein/data/privacy',
                    method : 'set_privacy',
                    form_data:{
                        cookie_id:null,
                        analytic_switch:1,
                        marketing_switch:1,
                        personisation_switch:1,
                        IS_APPROVE_ALL:1,
                        IS_APPROVE_CUSTOM:1
                    }
                }         
            },
            methods: {
                setCookie : function(cname, cvalue, exdays) {
                    const d = new Date();
                    d.setTime(d.getTime() + (exdays*24*60*60*1000));
                    let expires = "expires="+ d.toUTCString();
                    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
                },
                getCookie : function(cname){ 
                    let name = cname + "=";
                    let decodedCookie = decodeURIComponent(document.cookie);
                    let ca = decodedCookie.split(';');
                    for(let i = 0; i <ca.length; i++) {
                        let c = ca[i];
                        while (c.charAt(0) == ' ') {
                        c = c.substring(1);
                        }
                        if (c.indexOf(name) == 0) {
                        return c.substring(name.length, c.length);
                        }
                    }
                    return "";
                },                
                save : function(){
                    const this_ = this;
                    axios.post( '/datagate', this_.data_packet)
					.then(response => {
						if(response.data.STATUS){
                            this_.setCookie('IS_ANALYTIC',response.data.DATA[0].IS_ANALYTIC,365);
                            this_.setCookie('IS_APPROVE_ALL',response.data.DATA[0].IS_APPROVE_ALL,365);
                            this_.setCookie('IS_APPROVE_CUSTOM',response.data.DATA[0].IS_APPROVE_CUSTOM,365);
                            this_.setCookie('IS_MARKETING',response.data.DATA[0].IS_MARKETING,365);
                            this_.setCookie('IS_PERSONAL',response.data.DATA[0].IS_PERSONAL,365);
                            this_.setCookie('WRK_COOKIE',response.data.DATA[0].WRK_COOKIE,365);
                            this_.setCookie('WRK_COOKIE_ID',response.data.DATA[0].WRK_COOKIE_ID,365);                           
							toastr
							.success(
								response.data.SUCCESS_MESSAGE,
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);
                            this_.show_cokie_panel = false;
                            
						}else{
							toastr
							.error(
								response.data.DANGER_MESSAGE,
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);
						}						
											
					})
					.catch(e => {
                        toastr
							.error(
								"<cf_get_lang dictionary_id='33469.Opps! bir hata meydana geldi, hemen ilgileniyoruz daha sonra tekrar deneyin..'>",
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);						
					}) 
                    
                 
                },
                allSave : function() {
                    const this_ = this;
                    this_.data_packet.form_data.analytic_switch = 1,
                    this_.data_packet.form_data.marketing_switch = 1,
                    this_.data_packet.form_data.personisation_switch = 1,
                    this_.data_packet.form_data.IS_APPROVE_ALL = 1,
                    this_.data_packet.form_data.IS_APPROVE_CUSTOM = 1
                    this_.save();
                   
                },
                allDecline : function() {
                    const this_ = this;
                    this_.data_packet.form_data.analytic_switch = 0,
                    this_.data_packet.form_data.marketing_switch = 0,
                    this_.data_packet.form_data.personisation_switch = 0,
                    this_.data_packet.form_data.IS_APPROVE_ALL = 0,
                    this_.data_packet.form_data.IS_APPROVE_CUSTOM = 0
                    this_.save();                  
                }
            },
            mounted () { 
            const this_ = this;
               if(this_.getCookie('WRK_COOKIE').length == 0) this_.show_cokie_panel = true;
            }
        })
    </script>
<cfelse>
    <cfset PRIVACY_DATA = deserializeJSON(GET_SITE.PRIVACY_DATA)[session_base.language]> 
    <cfset CONTENT_SERVICE = createObject('component','/V16/objects2/content/cfc/content')>
    <cfset GET_CONTENT = deserializeJSON(CONTENT_SERVICE.GET_CONTENT(content_id:PRIVACY_DATA.privacy_text))>
    <cfoutput>         
        <p>#(ArrayLen(GET_CONTENT.DATA) NEQ 0)?GET_CONTENT.DATA[1].CONT_BODY:"privacy_text"#</p>         
    </cfoutput> 
    <div id="privacy_manager_app">        
        <div class="accordion mt-3" id="accordionPrivacyModal">   
            <div class="mb-0 d-flex mt-2">
                <span class="float-left font-weight-bold mr-2 cursor-pointer" data-toggle="collapse" data-target="#standart_text" aria-expanded="true" aria-controls="standart_text">
                    <cf_get_lang dictionary_id='64993.Zorunlu Tanımlama Bilgileri'>
                </span>
            </div>                
            <div id="standart_text" class="collapse show" aria-labelledby="headingOne" data-parent="#accordionPrivacyModal">            
                <cfoutput>#PRIVACY_DATA.standart_text#</cfoutput> 
            </div>
            <div class="mb-0 d-flex mt-2">
                <span class="float-left font-weight-bold mr-2 cursor-pointer" data-toggle="collapse" data-target="#analytic_text" aria-expanded="true" aria-controls="collaanalytic_textpseOne">
                    <cf_get_lang dictionary_id='64994.Analitik Çerezler'>
                </span>
                <div class="custom-control custom-switch float-left mt-1">
                    <input type="checkbox" class="custom-control-input" id="analytic_switch" v-model="data_packet.form_data.analytic_switch" true-value="1" false-value="0">
                    <label class="custom-control-label" for="analytic_switch"></label>
                </div>
            </div>                
            <div id="analytic_text" class="collapse" aria-labelledby="headingOne" data-parent="#accordionPrivacyModal">            
                <cfoutput>#PRIVACY_DATA.analytic_text#</cfoutput> 
            </div>
            <div class="mb-0 d-flex mt-2">
                <span class="float-left font-weight-bold mr-2 cursor-pointer" data-toggle="collapse" data-target="#marketing_text" aria-expanded="true" aria-controls="marketing_text">
                    <cf_get_lang dictionary_id='64995.Pazarlama Çerezleri'>
                </span>
                <div class="custom-control custom-switch float-left mt-1">
                    <input type="checkbox" class="custom-control-input" id="marketing_switch" v-model="data_packet.form_data.marketing_switch" true-value="1" false-value="0">
                    <label class="custom-control-label" for="marketing_switch"></label>
                </div>
            </div>                
            <div id="marketing_text" class="collapse" aria-labelledby="headingOne" data-parent="#accordionPrivacyModal">            
                <cfoutput>#PRIVACY_DATA.marketing_text#</cfoutput> 
            </div>
            <div class="mb-0 d-flex mt-2">
                <span class="float-left font-weight-bold mr-2 cursor-pointer" data-toggle="collapse" data-target="#personisation_text" aria-expanded="true" aria-controls="personisation_text">
                    <cf_get_lang dictionary_id='64630.Kişiselleştirme Çerezi'>
                </span>
                <div class="custom-control custom-switch float-left mt-1">
                    <input type="checkbox" class="custom-control-input" id="personisation_switch" v-model="data_packet.form_data.personisation_switch" true-value="1" false-value="0">
                    <label class="custom-control-label" for="personisation_switch"></label>
                </div>
            </div>                
            <div id="personisation_text" class="collapse" aria-labelledby="headingOne" data-parent="#accordionPrivacyModal">            
                <cfoutput>#PRIVACY_DATA.personisation_text#</cfoutput> 
            </div>
        </div>
        <div class="card-footer-bottom-margin" style=" display: block; height: 65px; "></div>
        <div class="card-footer text-muted" style=" width: 100%; left: 0; bottom: -2px; z-index: 9999; position: absolute; background: #f7f7f7; ">
            <a href="#" class="btn btn-primary float-right" @click="save()"><cf_get_lang dictionary_id='59031.Kaydet'></a>
        </div>
    </div>
    <script>
        var proteinAppPrivacy = new Vue({
            el: '#privacy_manager_app',
            data: {             
                data_packet  : {
                    cfc : 'V16/objects2/protein/data/privacy',
                    method : 'set_privacy',
                    form_data:{
                        cookie_id:null,
                        analytic_switch:1,
                        marketing_switch:1,
                        personisation_switch:1
                    }
                }         
            },
            methods: {
                setCookie : function(cname, cvalue, exdays) {
                    const d = new Date();
                    d.setTime(d.getTime() + (exdays*24*60*60*1000));
                    let expires = "expires="+ d.toUTCString();
                    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
                },
                getCookie : function(cname){ 
                    let name = cname + "=";
                    let decodedCookie = decodeURIComponent(document.cookie);
                    let ca = decodedCookie.split(';');
                    for(let i = 0; i <ca.length; i++) {
                        let c = ca[i];
                        while (c.charAt(0) == ' ') {
                        c = c.substring(1);
                        }
                        if (c.indexOf(name) == 0) {
                        return c.substring(name.length, c.length);
                        }
                    }
                    return "";
                },
                save : function(){
                    const this_ = this;
                    axios.post( '/datagate', this_.data_packet)
					.then(response => {
						if(response.data.STATUS){
                            this_.setCookie('IS_ANALYTIC',response.data.DATA[0].IS_ANALYTIC,365);
                            this_.setCookie('IS_APPROVE_ALL',response.data.DATA[0].IS_APPROVE_ALL,365);
                            this_.setCookie('IS_APPROVE_CUSTOM',response.data.DATA[0].IS_APPROVE_CUSTOM,365);
                            this_.setCookie('IS_MARKETING',response.data.DATA[0].IS_MARKETING,365);
                            this_.setCookie('IS_PERSONAL',response.data.DATA[0].IS_PERSONAL,365);
                            this_.setCookie('WRK_COOKIE',response.data.DATA[0].WRK_COOKIE,365);
                            this_.setCookie('WRK_COOKIE_ID',response.data.DATA[0].WRK_COOKIE_ID,365);                           
							toastr
							.success(
								response.data.SUCCESS_MESSAGE,
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);	
                            document.querySelector('.catalystClose').click();
                            document.querySelector('.cookie-container-close-button').click()
                            
						}else{
							toastr
							.error(
								response.data.DANGER_MESSAGE,
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);
						}						
											
					})
					.catch(e => {
                        toastr
							.error(
								"<cf_get_lang dictionary_id='33469.Opps! bir hata meydana geldi, hemen ilgileniyoruz daha sonra tekrar deneyin..'>",
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);						
					}) 
                    
                 
                }
            }
        })
    </script>
</cfif>