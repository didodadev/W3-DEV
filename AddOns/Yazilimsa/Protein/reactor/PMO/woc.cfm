<!---
    File :          AddOns\Yazilimsa\Protein\reactor\PMO\woc.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          26.06.2021
    Description :   workcube output center, çıktı verir pdf üretir pdf imzalar mail atar
    Notes :         
--->
<cfparam  name="attributes.action_type" default="">
<cfparam  name="attributes.action_id" default="">
<cfparam  name="attributes.woctoken" default="">
<cfset send_woc = deserializeJSON(decrypt(attributes.woctoken,'w3woc','CFMX_COMPAT','Hex'))>
<cfset WOC = createObject('component','CFC.SYSTEM.WOC')>
<cfset GET_TEMPLATES = WOC.GET_TEMPLATES(RELATED_WO:send_woc.RW)>

<html>
    <head>
      <!-- Bootstrap CSS -->
      <script  type="text/javascript" src="/src/assets/js/jquery.js"></script>
      <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>      
      <script  type="text/javascript" src="/src/assets/js/js_functions.js"></script>
      <script  type="text/javascript" src="/src/assets/js/js_functions_money.js"></script>
      <script  type="text/javascript" src="/src/assets/js/axios.min.js"></script>
      <script  type="text/javascript" src="/src/assets/js/vue.js"></script> 
      <script  type="text/javascript" src="/src/assets/plugin/js_calender/js/jscal2.js"></script>
      <script  type="text/javascript" src="/src/assets/js/protein.js"></script>
      <script  type="text/javascript" src="/src/assets/js/bootstrap.min.js"></script>
      <script  type="text/javascript" src="/src/assets/js/isotope.pkgd.min.js"></script>
      <link rel="stylesheet" type="text/css" href="/src/assets/css/protein.css?v=1234"> 
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/js_calender/css/jscal2.css">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/js_calender/css/border-radius.css">
      <link href="/src/assets/plugin/font_awsome/css/all.css" rel="stylesheet">
      <link href="/src/assets/css/bootstrap.min.css" rel="stylesheet">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/toastr/toastr.min.css">
      <script type="text/javascript" src="/src/assets/plugin/toastr/toastr.min.js"></script>
      <style>
            .woc-logo img {
                width: 200px;
                margin: 15px 0;
            }
      </style>
    </head>
    <body data-page="WOC" style="background: url(src/assets/img/woc_pattern.png) #fafafa;">
        <div class="container" id="wocapp">
            <div class="row">
                <div class="col-12">
                    <div class="woc-logo">
                       <img src="/src/assets/img/woc_logo.png"/>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-8">
                    <cf_box title="Önizleme">  
                        <iframe id="woc_preview" src="/<cfoutput>#site_language#</cfoutput>/wocpreview?woctoken=<cfoutput>#attributes.woctoken#</cfoutput>" style=" width: 683px; height: 881px; "></iframe>
                    </cf_box>
                </div>
                <div class="col-4">
                    <cf_box title="WOC"> 
                        <div class="form-group">
                            <label for="template">Şablon</label>
                            <select class="form-control" v-model="models[0].selected_templates" @change="preview_template()">
                                <option value="">Seçiniz</option>
                                <cfoutput query="GET_TEMPLATES">
                                    <option value="#WRK_OUTPUT_TEMPLATE_ID#">#WRK_OUTPUT_TEMPLATE_NAME#</option>
                                </cfoutput>  
                            </select>
                        </div>
                        <button type="button" v-show="false" class="btn btn-info">İmzalı Pdf İndir</button>
                        <button type="button" v-show="false" class="btn btn-success" @click="share_box();">Paylaş</button>  
                    </cf_box>
                </div>              
            </div>
            <!-- Modal -->
            <div class="modal fade" id="share_box_modal" tabindex="-1" role="dialog" aria-labelledby="Share" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                        <h5 class="modal-title" id="Share">WOC - Paylaş</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        </div>
                        <div class="modal-body">
                                    <div class="form-group row">
                                        <label class="col-md-3 col-form-label" for="addto">Alıcı</label>
                                        <div class="col-md-9">
                                            <div class="input-group">
                                                <input id="addto" v-model="share_models[0].addto" class="form-control" placeholder="exampe@workcube.com" type="text">
                                                <div class="input-group-prepend">
                                                    <div class="input-group-text" @click="add_to_list();">Ekle</div>
                                                </div>
                                            </div>
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item p-0 py-1" v-for="(item,index) in share_models[0].tolist">
                                                    <i class="fas fa-user-minus mr-1 text-danger" @click="del_to_list(index)" style=" cursor: pointer; "></i> {{item}}
                                                </li>
                                              </ul>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label class="col-md-3 col-form-label" for="share_message">Mesaj</label>
                                        <div class="col-md-9">                     
                                            <textarea class="form-control" id="share_message" v-model="share_models[0].share_message"></textarea>
                                        </div>
                                    </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Vazgeç</button>
                            <button type="button" class="btn btn-primary" @click="share()" >Paylaş</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            var wocapp = new Vue({
            el : '#wocapp',
            data : {
                protein : '2020',
                models : [{
                    templates : [],
                    selected_templates : '',
                    woc_token : '<cfoutput>#attributes.woctoken#</cfoutput>'     
                }],
                share_models : [{
                    addto : '',
                    tolist : [],
                    share_message : '',
                    template : '',
                    woc_token : '<cfoutput>#attributes.woctoken#</cfoutput>'
                }],
                error: [],
            },
            methods : {
                ss : function(e){
                    this.send_status = false;
                    axios.post( "/cfc/SYSTEM/LOGIN.cfc?method=GET_LOGIN_CONTROL", wocapp.models[0])
                    .then(response => {
                            console.log(response.data); 
                    })
                    .catch(e => {
                        wocapp.error.push({ecode: 1000, message:"Şuanda İşlem Yapılamıyor...."})
                        this.send_status = true;
                    })   
                    e.preventDefault(); return false;
                    
                },
                preview_template : function(e){
                    $('#woc_preview').attr('src','<cfoutput>#site_language#</cfoutput>/wocpreview?woctoken=' + wocapp.models[0].woc_token + '&preview=' + wocapp.models[0].selected_templates);
                },
                check_email : function(val){
                    if(!val.match(/\S+@\S+\.\S+/)){
                        return false;
                    }
                    if( val.indexOf(' ')!=-1 || val.indexOf('..')!=-1){
                        return false;
                    }
                    return true;
                },
                share_box : function(e){
                    $('#share_box_modal').modal('show');
                },
                share : function(){                    
                    var this_ = this;
                    this_.share_models[0].template = this_.models[0].selected_templates;
					axios.post( '/datagate', {
                        cfc : "/cfc/system/woc",
                        method : 'SHARE',
                        action : '',
                        form_data : this_.share_models[0]
                    })
					.then(response => {
						console.log(response.data);
						if(response.data.STATUS){
							toastr
							.success(
								response.data.SUCCESS_MESSAGE,
								'', 
								{timeOut: 5000, progressBar : true, closeButton : true}
							);
							$('#share_box_modal').modal('hide');
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
						this_.error.push({ecode: 1000, message:"Şuanda İşlem Yapılamıyor...."})
						
					}) 
                },
                add_to_list : function(e){
                    if(this.check_email(this.share_models[0].addto)){
                        this.share_models[0].tolist.push(this.share_models[0].addto);
                        this.share_models[0].addto = '';
                    }                 
                },
                del_to_list : function(i){
                    this.share_models[0].tolist.splice(i,(i == 0)? 1: i);
                }
            }
            })
        </script>    
    </body>
  </html>