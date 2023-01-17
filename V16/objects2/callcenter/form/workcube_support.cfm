<cfquery name="GET_LICENSE" datasource="#DSN#">
	SELECT 
		*
	FROM
		LICENSE
</cfquery>

<cfparam name="attributes.language" default="tr">
<cfparam name="attributes.userid" default="0">
<cfparam name="attributes.company" default="#GET_LICENSE.COMPANY#">
<cfset session.ep.language = "#attributes.language#">
<cfset session.ep.userid = "#attributes.userid#">
<cfset getComponent = createObject('component','cfc.workcube_support')>
<cfset GET_SERVICE_APPCAT = getComponent.GET_SERVICE_APPCAT()>
<cfset GET_HELP = getComponent.GET_HELP()>
<cfset GET_MODULES = getComponent.GET_MODULES()>
<cfset GET_HELP_LANGUAGE = getComponent.GET_HELP_LANGUAGE()>
<cfparam name="attributes.workcube_id" default="1">
<cfset GET_WORKCUBE_ID = getComponent.GET_WORKCUBE_ID(attributes.workcube_id)>
<cfset GET_CONSUMER = getComponent.GET_CONSUMER()>
<cfset GET_PARTNER = getComponent.GET_PARTNER()>
<cfparam name="attributes.action_section" default="">
<cfparam name="attributes.company_id" default="#GET_WORKCUBE_ID.COMPANY_ID#">
<cfparam name="attributes.period_id" default="">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.app_name" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.workcube_id" default="">
<cfparam name="attributes.pid" default="#GET_WORKCUBE_ID.PARTNER_ID#">
<cfparam name="attributes.file_name" default="">
<cfparam name="attributes.is_elect_asset_cat" default="">
<cfparam name="attributes.is_cont_doc_type" default="">
<cfparam name="attributes.interaction_cat" default="">
<cfparam name="attributes.commethod_id" default="6">
<cfset modul_list = valuelist(get_modules.module_short_name)> 
<cfset modul_list = listappend(modul_list,"myhome,objects2")>
<cfset modul_id_list = valuelist(get_modules.module_id)> 
<cfset modul_id_list = listappend(modul_id_list,"53,54")>
<cfparam name="attributes.help" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_faq" default="">
<cfparam name="attributes.isfaq" default="">
<cfparam name="attributes.is_internet" default="">
<cfparam name="attributes.is_order_by" default="0">
<cfparam name="attributes.module_id" default="">
<cfparam name="attributes.c_module_id" default="">
<cfparam name="attributes.search_key" default="">
<cfparam name="attributes.help_language" default="tr">
<cfparam name="attributes.service_url" default="">
<cfparam name="attributes.help_page" default="">
<cfparam name="attributes.full_url" default="">
<cfparam name="attributes.release_no" default="">
<cfparam name="attributes.patch_no" default="">
<cfparam name="attributes.extra_info" default="">

<link rel="stylesheet" href="/src/assets/js/dropzone/dropzone.css" type="text/css">

<cfparam name="attributes.totalrecords" default='#get_help.recordcount#'>  
<cfif isDefined("attributes.help_page") and Len(attributes.help_page)>			
    <cfquery name="GET_FACTION" datasource="#DSN#">
        SELECT 
            WRK_OBJECTS_ID,FUSEACTION,FULL_FUSEACTION
        FROM 
            WRK_OBJECTS
        WHERE
            FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.help_page,2,".")#"> AND
            MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.help_page,1,".")#">	 
    </cfquery>
    <cfset user_faction = GET_FACTION.FULL_FUSEACTION>
</cfif>
<div class="modal fade" id="fileUpload" tabindex="-1" role="dialog" aria-labelledby="Yükleme Sepeti" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="Yükleme Sepeti"><cfoutput>#getLang('main',54,'Belge Ekle')#</cfoutput></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form class="dropzone" id="file-dropzone"></form>
      </div>
      <div class="modal-footer">
        <button id="remove-all" class="btn btn-danger"><cf_get_lang dictionary_id='57934.Temizle'></button> 
        <button type="button" class="btn btn-secondary" data-dismiss="modal"><cf_get_lang dictionary_id='57553.Kapat'></button>
      </div>
    </div>
  </div>
</div> 

<div id="myModals" class="modal">
    <div class="modal-dialog" role="document">        
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="Yükleme Sepeti"><cf_get_lang dictionary_id='59956.Değerli Kullanıcımız'></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <h3 style="text-align:center;"><cf_get_lang dictionary_id='59957.Bildiriminiz için teşekkür ederiz'>.</h3>  
                <h3 style="text-align:center;"><cf_get_lang dictionary_id='59958.En kısa sürede e-mailinize yanıt vermeye çalışacağız'>. <cf_get_lang dictionary_id='59959.Uygulamanız ile ilgili detayları buradan takip edebilirsiniz'>: <b>project.workcube.com</b> </h3>
                <h3 style="text-align:center;"><cf_get_lang dictionary_id='59960.Teşekkürler'>.</h3>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal"><cf_get_lang dictionary_id='57553.Kapat'></button>
            </div>
        </div>
    </div>
</div> 
    <div class="card mb-5 mt-5">
        <div class="card-header" style="margin-top:-48px;">
            <cf_get_lang dictionary_id='59963.Yardım Formu'>
        </div>
        <div class="card-body">
            <cfform class="form-horizontal" name="helpForm" id="helpForm">
                <div class="row">
                    <div class="col-12 col-md-6">            
                        <cfoutput>
                            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1" />  
                            <input type="hidden" name="is_popup" id="is_popup" value="1">
                            <input type="hidden" name="app_name" id="app_name" value="#attributes.app_name#">
                            <input type="hidden" name="app_cat" id="app_cat" value="#attributes.commethod_id#">
                            <input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                            <input type="hidden" name="pid" id="pid" value="#attributes.pid#">
                            <input type="hidden" name="action_id" id="action_id" value="">
                            <input type="hidden" name="workcube_id" id="workcube_id" value="#attributes.workcube_id#">
                            <input type="hidden" name="is_security" id="is_security" value="0" />
                            <input type="hidden" name="action_section" id="action_section" value="#attributes.action_section#">
                            <input type="hidden" name="full_url" id="full_url" value="#attributes.full_url#">
                            <input type="hidden" name="release_no" id="release_no" value="#attributes.release_no#">
                            <input type="hidden" name="patch_no" id="patch_no" value="#attributes.patch_no#">
                            <textarea name="extra_info" id="extra_info" style = "display:none;">#attributes.extra_info#</textarea>
                        </cfoutput>						
                        <div class="form-group row">
                            <label for="service_head" class="col-sm-3 col-form-label"><cfoutput>#getLang('main',1408,'başlık')#</cfoutput> *</label>
                            <div class="col-sm-9">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='59961.Özet Başlık Giriniz'></cfsavecontent>
                                <input type="text" name="service_head" class="help-forminput form-control" id="service_head" placeholder="<cfoutput>#message#</cfoutput>">
                            </div>
                        </div>
						<div class="form-group row">
                            <label for="" class="col-sm-3 col-form-label"><cfoutput>#getLang('main',68,'konu')#</cfoutput> *</label>
                            <div class="col-sm-9">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='59974.Detayları yazarsanız daha hızlı yanıt veririz.'></cfsavecontent>
                                <textarea name="service_detail" class="help-forminput form-control" id="service_detail" placeholder="<cfoutput>#message#</cfoutput>" style="height:150px;"></textarea>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="appcat_id" class="col-sm-3 col-form-label"><cfoutput>#getLang('main',74,'kategori')#</cfoutput> *</label>
                            <div class="col-sm-9">
                                <select name="appcat_id" id="appcat_id" class="help-forminput form-control">
                                    <option value=""><cfoutput>#getLang('main',322,'seçiniz')#</cfoutput></option>
                                    <cfoutput query="get_service_appcat">
                                        <option value="#servicecat_id#" >#servicecat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="member_name" class="col-sm-3 col-form-label"><cfoutput>#getLang('main',158,'ad soyad')#</cfoutput> *</label>
                            <div class="col-sm-9">
                                 <cfsavecontent variable="message"><cf_get_lang dictionary_id='35860.Lütfen Ad Soyad Giriniz'></cfsavecontent>
                                <cfif isdefined("session.ww.userid") and len(session.ww.userid)>
                                    <input type="text" class="help-forminput form-control" name="member_name" id="member_name" value="<cfoutput>#session.ww.name# #session.ww.surname#</cfoutput>" readonly maxlength="255" placeholder="<cfoutput>#message#</cfoutput>">
                                <cfelseif isdefined("session.pp.userid")>
                                    <input type="text" class="help-forminpu form-controlt" name="member_name" id="member_name" value="<cfoutput>#session.pp.name# #session.pp.surname#</cfoutput>" readonly maxlength="255" placeholder="<cfoutput>#message#</cfoutput>">
                                <cfelseif isdefined("attributes.app_name") and len(attributes.app_name)>
                                    <input type="text" class="help-forminput form-control" name="member_name" id="member_name" value="<cfoutput>#attributes.app_name#</cfoutput>" readonly maxlength="255" placeholder="<cfoutput>#message#</cfoutput>">
                                <cfelse>
                                    <input type="text" class="help-forminput form-control" name="member_name" id="member_name" value="" placeholder="<cfoutput>#message#</cfoutput>" required>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group row">
                            <label for="applicant_mail" class="col-sm-3 col-form-label"><cfoutput>#getLang('main',16,'email')#</cfoutput> *</label>
                            <div class="col-sm-9">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='35813.E-Posta Giriniz'></cfsavecontent>
                                <cfif isdefined("session.ww.userid") and len(session.ww.userid)>
                                    <input type="email" class="help-forminput form-control" name="applicant_mail" id="applicant_mail" value="<cfoutput>#get_consumer.consumer_email#</cfoutput>" readonly placeholder="<cfoutput>#message#</cfoutput>" required>
                                <cfelseif isdefined("session.pp.userid")>
                                    <input type="email" class="help-forminput form-control" name="applicant_mail" id="applicant_mail" value="<cfoutput>#get_partner.company_partner_email#</cfoutput>" readonly placeholder="<cfoutput>#message#</cfoutput>" required>
                                <cfelseif isdefined("attributes.email") and len(attributes.email)>
                                    <input type="email" class="help-forminput form-control" name="applicant_mail" id="applicant_mail" value="<cfoutput>#attributes.email#</cfoutput>" readonly maxlength="255" placeholder="<cfoutput>#message#</cfoutput>" required>
                                <cfelse>
                                    <input type="email" class="help-forminput form-control" name="applicant_mail" id="applicant_mail" value="" placeholder="<cfoutput>#message#</cfoutput>" required>
                                </cfif>
                            </div>
                        </div>                        
                        <div class="form-group row">
                            <label for="" class="col-sm-3 col-form-label"><cfoutput>#getLang('main',1964,'Url')#</cfoutput> (Fuseaction)</label>
                            <div class="col-sm-9">
                                <input type="text" id="service_url" name="service_url" value="<cfif len(attributes.help_page)><cfoutput>#attributes.help_page#</cfoutput><cfelse>""</cfif>" class="help-forminput form-control" required>
                            </div>
                        </div> 
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group row">
                            <label for="appcat_id" class="col-sm-3 col-form-label"><cfoutput>#getLang('main',54,'Belge Ekle')#</cfoutput></label>
                            <div class="col-sm-9">
                                <button type="button" class="btn btn-primary" onclick="fileUploadModal(this);" >
                                    <span class="badge badge-light">0</span>
                                    <cfoutput>#getLang('main',279,'dosya')#</cfoutput>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
						<div class="form-group row">
                            <div class="col-sm-9 offset-sm-3">	
								<small class="mb-2">
									<cf_get_lang dictionary_id='59962.Bazı sistem bilgileri Workcube e gönderilebilir. Bize verdiğiniz bilgileri Gizlilik Politikası ve Hizmet Şartlarına tabi olarak ürünlerimizi ve hizmetlerimizi iyileştirmek ve teknik sorunları gidermek amacıyla kullanırız.'>
								</small>
						   </div>
                        </div>
                        <div class="form-group row">
                            <div class="col-sm-9 offset-sm-3">								
                                <button type="button" class="btn btn-success" id="myBtnClicks" onclick="saveHelpDesk(this)"><cfoutput>#getLang('main',49,'KAYDET')#</cfoutput></button>
                            </div>
                        </div>
                    </div>
                </div>
            </cfform>
        </div>
    </div> 
<script src="/src/assets/js/dropzone/dropzone.js"></script>
<script src="/src/assets/js/dropzone/custom.js"></script>

<script type="text/javascript">
 
var saveHelpDesk = function(obj){
    var appcat_id = document.getElementById('appcat_id').value;
    var service_detail = document.getElementById('service_detail').value;
    var applicant_mail = document.getElementById('applicant_mail').value;
    var service_head = document.getElementById('service_head').value;
    /* var extra_info = document.getElementById('extra_info').value; */

    if(appcat_id.trim() == '')
    {
        alert("<cf_get_lang dictionary_id='59964.Kategori Alanı Dolu Olmalıdır'>!");
        document.getElementById('appcat_id').focus();
        return false;		
    }
    if(service_detail.trim() == "")
    {
        alert("<cf_get_lang dictionary_id='34363.Konu Alani Dolu Olmalidir'>");
        document.getElementById('service_detail').focus();
        return false;
    }
    if(applicant_mail.trim() == "")
    {
        alert("<cf_get_lang dictionary_id='59965.Email Alani Dolu Olmalidir'>");
        document.getElementById('applicant_mail').focus();
        return false;
    }
    if(service_head.trim() == "")
    {
        alert("<cf_get_lang dictionary_id='34415.Lütfen Bir Konu Başlığı Giriniz'>");
        document.getElementById('service_head').focus();
        return false;
    }
    /* if(appcat_id.trim() == 4 && extra_info.trim() == "")
    {
        alert("<cf_get_lang dictionary_id='813.Hata bildirimlerini hızlı bir şekilde incelenmesi için hatanın gerçekleştiği web sayfası üzerinden bildirmeniz gereklidir'>");
        return false;
    } */

    dataForm = $("#helpForm").serializeArray();
    attachment = 0;
    files = [];
    myDropzone.processQueue();
    attachmentReturn = '';
    fileRealNameList = '';
    fileRealNameFullList = '';
    fileSystemNameList = '';
    fileSize='';

    if (myDropzone.files.length == 0)
    {
        var data = new FormData(), parameters = {};
		data.append('cfc', '/cfc/workcube_support');
		data.append('method', 'SAVEHELPDESKFORM');

        if (dataForm.length > 0) dataForm.forEach((el) => { parameters[el.name] = el.value });
		data.append('form_data', JSON.stringify(parameters));
		AjaxControlPostDataJson('/datagate',data,function(response) {
            data_a = $.parseJSON( response );
            if (data_a > 0){
                $("#myModals").modal('show');                  
                setTimeout(function(){ window.location.reload(1);}, 2500); 
            }else {alert("<cf_get_lang dictionary_id='52126.Bir Hata oluştu'>!");}
        });

    }else 
    {
        dataForm1 = $("#helpForm").serialize();
        myDropzone.on("queuecomplete", function() {

            //try{
                attachmentReturn = $.parseJSON(returningValue);
                if(returningValue == 0 ) throw 'myException';
                for(k=0;k<attachmentReturn.length;k++)
                {
                    if(fileRealNameList.length)
                    {
                        fileRealNameList = fileRealNameList + ',' + myDropzone.files[k]._newFileName.value;
                        if(myDropzone.files[k]._newFileName.value.indexOf(attachmentReturn[k]['ext']) != -1)
                            fileRealNameFullList = fileRealNameFullList + ',' + myDropzone.files[k]._newFileName.value;
                        else
                            fileRealNameFullList = fileRealNameFullList + ',' + myDropzone.files[k]._newFileName.value+'.'+attachmentReturn[k]['ext'];
                            fileSystemNameList = fileSystemNameList + ',' + attachmentReturn[k]['systemName'];
                            fileSize = fileSize + ',' + attachmentReturn[k]['fileSize'];
                    }
                    else
                    {
                        fileRealNameList = myDropzone.files[k]._newFileName.value;
                        if(myDropzone.files[k]._newFileName.value.indexOf(attachmentReturn[k]['ext']) != -1)
                            fileRealNameFullList = myDropzone.files[k]._newFileName.value;
                        else
                            fileRealNameFullList = myDropzone.files[k]._newFileName.value+'.'+attachmentReturn[k]['ext'];
                            fileSystemNameList = attachmentReturn[k]['systemName'];
                            fileSize = attachmentReturn[k]['fileSize'];
                    }	
                }
                var data = dataForm1+"&fileRealNameList="+fileRealNameList+"&fileRealNameFullList="+fileRealNameFullList+"&fileSystemNameList="+fileSystemNameList+"&fileSize="+fileSize;
                $.ajax({
                    url :'/cfc/workcube_support.cfc?method=SAVEHELPDESK', 
                    data : data, 
                    type: 'POST',
                    async:false,
                    success : function(res){ 
                        data = $.parseJSON( res );
                    } 
                });
        
                if (data > 0){
                    $("#myModals").modal('show');
                    setTimeout(function(){ window.location.reload(1); }, 2500);
                } 
                
            /*}catch(e){
                alert("<cf_get_lang dictionary_id='59966.Dosya Yükleme İle İlgili Bir Sorun Oluştu'>, <cf_get_lang dictionary_id='59967.Dosyalarınızı Kontrol Edip Tekrar Deneyin'>!!");
                return false;
            }*/
            
        });

    }

}
</script>
<div id="fileUpload" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				<!-- Nav tabs -->
				<ul class="nav nav-tabs" role="tablist">
					<li class="active"><a href="#tabFileContent" role="tab" data-toggle="tab"><cf_get_lang dictionary_id='59968.Yükleme Sepeti'></a></li>
					<!---<li><a href="#tabFileDesc" role="tab" data-toggle="tab">Yükleme Detayı</a></li>--->
				</ul>
				<!-- Tab panes -->
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane fade in active" id="tabFileContent">
						<form class="dropzone" id="file-dropzone"></form>
					</div>
                    <!----
					<div role="tabpanel" class="tab-pane fade" id="tabFileDesc">
						<form class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-3 control-label">Kategori *</label>
								<div class="col-sm-9">
									<select id="assetcat_id" name="assetcat_id" class="form-control" required>
                                    	<option value=""><cfoutput>#getLang('main',322,'Seçiniz')#</cfoutput></option>
                                    	<cfoutput query="assetCat">
											<option value="#ASSETCAT_ID#">#ASSETCAT#</option>
                                        </cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-3 control-label">Döküman Tipi *</label>
								<div class="col-sm-9">
									<select id="property_id" name="property_id" class="form-control" required>
                                    	<option value=""><cfoutput>#getLang('main',322,'Seçiniz')#</cfoutput></option>
                                    	<cfoutput query="documentType">
											<option value="#CONTENT_PROPERTY_ID#">#NAME#</option>
                                        </cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-3 control-label">Açıklama</label>
								<div class="col-sm-9">
									<textarea name="asset_description" id="asset_description"  class="form-control" rows="3"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-3 control-label">Anahtar Kelimeler</label>
								<div class="col-sm-9">
									<textarea name="asset_detail" id="asset_detail" class="form-control" rows="3"></textarea>
								</div>
							</div>
						</form>
					</div>
					---->
				</div>				    
			</div>  
			<div class="modal-footer">
				<button id="remove-all" class="btn btn-danger"><cf_get_lang dictionary_id='57934.Temizle'></button>                 
			</div>         
		</div>
	</div>
</div>