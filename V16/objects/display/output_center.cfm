<link rel="stylesheet" href="/css/assets/template/w3-bootstrap/bootstrap-catalyst.css" type="text/css">
<script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
<script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
<style>
	iframe.template-preview-zoom {
		transform: unset !important;
		position: fixed;
		top: 5px;
		height: 700px !important;
		width: 700px !important;
		left: calc(50% - 350px);
		background: white;
		border: 3px solid #c1c1c1 !important;
		box-shadow: -1px 0px 5px 0px #00000082;
		z-index: 999;
	}
	table.big_list_head {
		display: none;
	}
	.sticky-bar-priview {
		position: sticky;
		top: 0px;
	}
	table.fixed_headers thead tr th {
		background:white;
		border-bottom: none !important;
		position: sticky;
		top: 0px;
		box-shadow: inset 0px -2px 0 #dee2e6;
	}
	#preview_load{
		position: absolute;font-size: 50px;top: 200px;left: 114px;
	}

</style>
<cfset files = #attributes.files# >
<cfquery name="GET_FORM" datasource="#dsn3#">
	SELECT
		IS_STANDART,
		TEMPLATE_FILE,
		FORM_ID,
		NAME,
		PROCESS_TYPE,
		MODULE_ID,
		IS_DEFAULT,
		ISNULL((SELECT FORM_ID FROM SETUP_PRINT_FILES WHERE PROCESS_TYPE = #attributes.form_type# AND IS_DEFAULT=1),0) AS DEFAULT_FORM
	FROM 
		SETUP_PRINT_FILES	
	WHERE
		PROCESS_TYPE = #attributes.form_type#
</cfquery>
<section class="row bootstrap-catalyst ml-2" id="create_output_app">
	<div class="rw mx-0">
		<div class="cl-12 px-0 mt-2">
			<div class="frn-group">
				<i class="fa fa-circle text-info"></i>
				<label class="mr-2"><cf_get_lang dictionary_id='57063.İşlenmemiş'></label>
				<i class="fa fa-circle text-warning"></i>
				<label class="mr-2"><cf_get_lang dictionary_id='57705.İşleniyor'></label>
				<i class="fa fa-circle text-success"></i>
				<label class="mr-2"><cf_get_lang dictionary_id='55387.Başarılı'></label>
				<i class="fa fa-circle text-danger"></i>
				<label><cf_get_lang dictionary_id='58197.Başarısız'></label>
				
			</div>
		</div>
	</div>
	<div class="rw justify-content-center">
		<div class="cl-8">
			<div class="card">
				<div class="card-header text-white bg-purple-plum">
					<i class="fa fa-share-square-o text-white"></i> <cf_get_lang dictionary_id='59883.Çıktı Merkezi'>
					<span class="float-right"><cfoutput>#listLen(files)-1#</cfoutput></span>
				</div>
				<div class="card-body pt-0">
					<table class="table table-hover fixed_headers">
						<thead>
							<tr>
								<th scope="col">#</th>
								<th scope="col">Name</th>
								<th class="text-center" scope="col">Referer</th>
								<th scope="col">Receiver</th>
								<th class="text-center" scope="col">Status</th>
							</tr>
						</thead>
						<tbody>	
							<cfset rwc = 1>						
							<cfloop list="#files#" index="file_id">
								<cfoutput>
									<cfif file_id neq 0>
										<tr data-row="#rwc#" :data-id="file_list[#rwc-1#]=#file_id#" data-receiver="" data-status="0">
											<td>#rwc#</td>
											<td data-file-name>{{file_emp_prefix_fn(#rwc#)}}{{file_prefix}}_#file_id#{{receiver_emp(#file_id#,'#attributes.wo#',#rwc#)}}</td>
											<td class="text-center">
												<a href="#attributes.det##file_id#" target="_blank"><i class="fa fa-link text-info"></i></a>
											</td>	
											<td data-receiver-emp></td>											
											<td class="text-center" data-icon @click="preview_id =#file_id# "><i class="fa fa-circle text-info btnPointer" style="font-size: 18px;"></i></td>								
										</tr>
										<cfset rwc += 1>
									</cfif>
								</cfoutput>									
							</cfloop>
						</tbody>
					</table>				
				</div>
			</div>
		</div>
		<div class="cl-4">
			<div class="sticky-bar-priview">
				<div class="rw mx-0">
					<div class="cl-12 px-0 mt-2">
						<div class="frm-group">
							<label><cf_get_lang dictionary_id='58640.Şablon'></label>
							<select v-model="template" class="frm-control" id="template">
								<cfoutput query="GET_FORM">
									<option value="#FORM_ID#" data-name="#name#" <cfif IS_DEFAULT eq 1>selected</cfif>>#name#</option>
								</cfoutput>						
							</select>
						</div>
					</div>
				</div>
				<div class="card card mb-0">
					<div class="card-header">
						<cf_get_lang dictionary_id='59807.Önizleme'>
						<i class="catalyst-size-fullscreen float-right btnPointer" onClick="$('iframe#template-preview').toggleClass('template-preview-zoom')"></i>
					</div>
					<div class="card-body pt-0" style="height: 250px; overflow: hidden; ">
						<i class="fa fa-spinner fa-spin text-info" id="preview_load" style="display: none;"></i>
						<iframe v-if="preview_id != null" id="template-preview" style="overflow-x: hidden; transform: scale(0.3); margin: 0 !important; width: 210mm; height: 190mm; transform-origin: top left; border: 1px solid black; "  frameborder="0" :src="'/WDO/workdev/cfc/output_center.cfc?method=preview_template&action_id=' + preview_id + '&form_type=' + template" ></iframe>
					</div>
				</div>
				<div class="card no-bg no-border">					
					<div class="rw mx-0">
						<div class="cl-12 px-0 mt-2">
							<div class="frn-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='60151.Dosya Ön Eki'></cfsavecontent>
								<label><cfoutput>#message#</cfoutput></label>
								<input type="text" class="frm-control" name="file_prefix" v-model="file_prefix" placeholder="<cfoutput>#message#</cfoutput>">
							</div>
						</div>
					</div>
					<div class="frm-check pl-0 mt-2">
						<input v-show="true" class="form-check-input" type="checkbox" id="add_file_emp_prefix" value="" v-model="file_emp_prefix">
						<label v-show="true" class="form-check-label mr-2 mt-0" for="add_file_emp_prefix">
							<cf_get_lang dictionary_id='60152.Dosya Ön Ekine Ad Soyad Ekle'>
						</label>
						<input v-show="true" class="form-check-input" type="checkbox" id="send_mail" value="" v-model="send_mail">
						<label v-show="true" class="form-check-label mr-2 mt-0" for="send_mail">
							<cf_get_lang dictionary_id='34514.E-Posta Gönder'>
						</label>
						<input v-show="false" class="form-check-input" type="checkbox" id="send_kep" value="" v-model="send_kep">
						<label v-show="false" class="form-check-label mr-2 mt-0" for="send_kep">
							<cf_get_lang dictionary_id='59812.KEP Gönder'>
						</label>						
						<input class="form-check-input" type="checkbox" id="copy_two" value="" v-model="copy_two">
						<label class="form-check-label mr-2 mt-0" for="copy_two">
							2 <cf_get_lang dictionary_id='59813.Nüsha Oluştur'>
						</label>
					</div>
					<div class="frm-check pl-0 mt-2" v-if="send_mail">
						<textarea v-model="mail_note" rows="4" maxlength="140" class="frm-control mb-2" placeholder="Mail Notunuzu Giriniz..."></textarea>
						<kbd class="mr-2" @click="mail_note+='[receiver]'"><cf_get_lang dictionary_id='48174.Alıcı Adını Girmelisiniz'></kbd><kbd class="mr-2" @click="mail_note+='[sender]'"><cf_get_lang dictionary_id='60154.Gönderici Adını Ekle'></kbd><kbd @click="mail_note+='[file]'"><cf_get_lang dictionary_id='55652.Belge Adını'> <cf_get_lang dictionary_id ='44630.Ekle'></kbd> 
						<div class="clearfix mb-3"></div>
					</div>
					<button type="button" class="btn btn-danger" @click="runJob()"><cf_get_lang dictionary_id='60155.Başlat'></button>
					<button type="button" class="btn btn-success mt-2" id="downloadPdfArchive" @click="downloadPdfArchive()" v-if="download_archive"><cf_get_lang dictionary_id='59809.Arşivi İndir'></button>
				</div>
			</div>
		</div>
	</div>  
	</section>
<script>
	var wcp = new Vue({
		el: '#create_output_app',
		data: {   
		file_list:[],
		template : '<cfoutput>#GET_FORM.DEFAULT_FORM#</cfoutput>',
		preview_id : 0, 
		sequence : 0,
		send_kep : false,
		send_mail: true,
		mail_note:'',
		copy_two : false,
		file_emp_prefix : false,
		file_prefix : '',
		folder_prefix : '',
		download_archive: false,
		sender : '<cfoutput>#attributes.employee_id#</cfoutput>',
		error: []
		},
		mounted () {
			var random_prefix = "";
			var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
			
			for (var i = 0; i < 6; i++){
				random_prefix += possible.charAt(Math.floor(Math.random() * possible.length));
			}
				
			this.file_prefix = $('#template option:selected').data('name'); 
			this.folder_prefix = random_prefix;			
		},
		methods: {
			receiver_emp : function (action_id,wo,row){
				axios
					.get("/WDO/workdev/cfc/output_center.cfc",{
						params:{
							method		: 'receiver_emp',
							action_id	: action_id,
							wo			: wo
						}
					})
					.then(
						response => {
							$('[data-row="'+row+'"]').attr('data-receiver',response.data.DATA[0].RECEIVER_EMPID);	
							$('[data-row="'+row+'"] [data-receiver-emp]').html(response.data.DATA[0].RECEIVER_EMP);								
						}
					)
					.catch(
						e => {
								
						}
					);
				
			},
			runJob: function(value){
				if (!value) value = wcp.file_list[0];
				if (wcp.sequence <= wcp.$data.file_list.length){
										
					var status_content = $('[data-id="'+value+'"] [data-icon]');
					var status = $('[data-id="'+value+'"]').data('status');
					if(status == 0 || status == -1 ){
						$(status_content).empty().append('<i class="fa fa-spinner fa-spin text-warning btnPointer" style="font-size: 18px; z-index:-1;"></i>');
						axios
							.get("/WDO/workdev/cfc/output_center.cfc",{
								params:{
									method		: 'runJob',
									id			: value,
									form_type	: wcp.template,
									send_kep	: wcp.send_kep,
									send_mail	: wcp.send_mail,
									mail_note	: wcp.mail_note,
									copy_two	: wcp.copy_two,
									file_prefix : wcp.file_prefix,
									folder_prefix : wcp.folder_prefix,
									file_name	: $('[data-id="'+value+'"] [data-file-name]').text(),
									wo			: '<cfoutput>#attributes.wo#</cfoutput>',
									receiver	: $('[data-id="'+value+'"]').data('receiver'),
									sender 		: wcp.sender
								}
							})
							.then(
								response => {
									console.log(response.data);
									if(response.data.STATUS == true){
										$(status_content).empty().append('<i class="fa fa-circle text-success btnPointer" style="font-size: 18px;"></i>');
										$('[data-id="'+value+'"]').data('status',1).attr('data-status',1);
									}else{
										wcp.error.push({ecode: 1000, message:response.data.error}) 
										$(status_content).empty().append('<i class="fa fa-circle text-danger btnPointer" style="font-size: 18px;" title="'+response.data.ERROR+'"></i>');
										$('[data-id="'+value+'"]').data('status',-1).attr('data-status',-1);
									}
									wcp.sequence = wcp.sequence + 1;
									wcp.runJob(wcp.file_list[wcp.sequence]);											
								}
							)
							.catch(
								e => {
										wcp.error.push({ecode: 2000, message:response.data.ERROR}) 
										$(status_content).empty().append('<i class="fa fa-circle text-danger btnPointer" style="font-size: 18px;"></i>');
										$('[data-id="'+value+'"]').data('status',-1).attr('data-status',-1);
										wcp.sequence = wcp.sequence + 1;
										wcp.runJob(wcp.file_list[wcp.sequence]);
								}
							);								
					}else{
						wcp.sequence = wcp.sequence + 1;
						wcp.runJob(wcp.file_list[wcp.sequence]);
					}
				
				}else{
					wcp.download_archive = true;
					wcp.sequence = 0;
				}
			},
			downloadPdfArchive: function(){
				console.info('download pdf archive fn');
				$('#downloadPdfArchive').attr('disabled',true);
				$('#downloadPdfArchive').html('<i class="fa fa-spinner fa-spin text-white"></i> Paketleniyor');
				
				axios
					.get("/WDO/workdev/cfc/output_center.cfc",{
						params:{
							method		: 'zip_pdf',
							copy_two	: wcp.copy_two,
							file_prefix : wcp.file_prefix,
							folder_prefix : wcp.folder_prefix
						}
					})
					.then(
						response => {
							console.log(response.data.INVOICE);
							if(response.data.STATUS == true){
								$('#downloadPdfArchive').html('<i class="fa fa-spinner fa-spin text-white"></i> İndiriliyor');
								console.log(response.data);
								window.open(response.data.ZIP,"_self",'zip');
								console.log(response.data.ZIP_COPY.length);
								if(response.data.ZIP_COPY.length){	
									setTimeout(function(){
										window.open(response.data.ZIP_COPY,"_self",'zip_copy');
										}, 500);										
									
								}
								$('#downloadPdfArchive').html('Arşivi İndir');
								$('#downloadPdfArchive').attr('disabled',false);								
								wcp.error.push({ecode: 4000, message:response.data.error}) 
							}
						}
					)
					.catch(
						e => {
							$('#downloadPdfArchive').html('Arşivi İndir');
							$('#downloadPdfArchive').attr('disabled',false);
							wcp.error.push({ecode: 3000, message:response.data.ERROR}) 
						}
					);

			},
			folder_prefix: function generateRandomString(length) {
				var text = "";
				var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
				
				for (var i = 0; i < length; i++)
					text += possible.charAt(Math.floor(Math.random() * possible.length));
				
				return text;
			},
			file_emp_prefix_fn: function generateRandomString(row) {
				var prefix = '';
				if(this.file_emp_prefix){
					var prefix = $('[data-row="'+row+'"] [data-receiver-emp]').text().replace(/\ /g,'_')+'_';	
				}	
				
				return prefix;
			}
		},
		watch:{
				preview_id: function () {
					$('#preview_load').show();
					setTimeout(function(){
						$('#preview_load').hide();
					}, 1200);
				},
				template: function () {
					this.file_prefix = $('#template option:selected').data('name'); 
				}
				
		}   
	})		
</script>