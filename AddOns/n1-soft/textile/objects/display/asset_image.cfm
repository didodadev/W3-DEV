
<style>
    .mySlides {display:none;}
    </style>

<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/dropzone.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/fileupload-min.css" type="text/css">

<cfset uploadFolder = application.systemParam.systemParam().upload_folder />
<cfset fileSystem = CreateObject("component","V16.asset.cfc.file_system")>

<cfscript>

	imageSettings =	{///thumbnail Settings

		1	:	{
			folderName	:	"icon",
			PositionX	:	0,
			PositionY	:	0,
			newWidth	:	64,
			newHeight	:	64
		},
		2	:	{
			folderName	:	"middle",
			PositionX	:	0,
			PositionY	:	0,
			newWidth	:	512,
			newHeight	:	256
		}
	};

</cfscript>

<cfset icon = false>
<cfset fileType = "">
<cfset imagePath = "">
<cfset add_=''>
<cfset info_='&is_image=1'>
<cfset add2_ = '#request.self#?fuseaction=asset.list_asset&event=add&module=textile&module_id=99&action=REQ_ID&action_id=#attributes.req_id#&asset_cat_id=-3&action_type=0#add_##info_#'> 
<cf_box  add_href="#add2_#" add_href_size="wide"> 
        <cfif getAsset.recordcount>
            <div class="w3-content w3-section">
            <cfoutput query="getAsset">
			
									<cfset ext="">
						<cfset url_="">
						<cfset url_ = "#file_web_path#product/">
											<cfset path = "#upload_folder#product#dir_seperator#">
												<cfset file_path = '#path##getAsset.asset_file_name#'>
			<cfif len(getAsset.asset_file_name) and FileExists(file_path)>
						<cfif len(getAsset.asset_file_name) and FileExists("#uploadFolder#thumbnails/middle/#getAsset.asset_file_name#")>
							<cfset imagePath = "documents/thumbnails/middle/#getAsset.asset_file_name#">
							<cfset icon = false>
							<cfset ext=lcase(listlast(getAsset.asset_file_name, '.')) />
						<cfelse>
							<cfset fileSystem.newFolder("#uploadFolder#","thumbnails") /> <!---upload folder --- /documents klasörü ---->
							<cfset fileSystem.newFolder("#uploadFolder#thumbnails","icon") />
							<cfset fileSystem.newFolder("#uploadFolder#thumbnails","middle") />

							<cfset imageOperations = CreateObject("Component","cfc.image_operations") />
						<cfif FileExists(file_path)>
							<cfloop from="1" to="#imageSettings.count()#" index="row">
								
								<cfset imageOperations.imageCrop(
													imagePath : "#file_path#",
													imageThumbPath : "#uploadFolder#thumbnails/" & imageSettings[row]["folderName"] &"/#getAsset.asset_file_name#",
													imageCropType	:	1, <!--- Orantılı boyutlandır --->
													newWidth : #imageSettings[row]["newWidth"]#,
													newHeight : #imageSettings[row]["newHeight"]#
													) />

							</cfloop>
						</cfif>
							<cfset imagePath = "documents/thumbnails/middle/#getAsset.asset_file_name#" />
							<cfset icon = false>

						</cfif>
			<cfelse>
						<cfset imagePath = "images/intranet/no-image.png">
						<cfset icon = true>
			</cfif>
		
            <div class="box-list box-list-small col col-12 col-md-12 col-sm-6 col-xs-12 mySlides" >
                <div class="box-list-content col col-12" >
                        <div class="box-list-image box-list-image-big" >
                                <div class="box-list-image-content" >
                                    <div class="image" >
                                        <cfif icon>
                                            <img  src="#imagePath#" >
                                        <cfelse>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##getAsset.asset_file_name#&file_control=asset.form_upd_asset&asset_id=#getAsset.asset_id#&assetcat_id=#getAsset.assetcat_id#','medium');">
                                                <img src="#imagePath#" >
                                            </a>
                                        </cfif>
                                    </div>
                                </div>
                        </div>
                        <div class="box-list-text">
                                    <div class="box-list-header">
                                                <!---<div class="box-list-title col col-6" title="Orjinal Dosya Adı :<!--- #getAsset.asset_file_real_name#--->">
                                                   <span style="font-size:0.6em;"> #getAsset.asset_name#</span>
                                                </div>--->
                                    </div>
                                    <div class="box-list-footer">
                                        <!---<div class="box-list-footer-top">
                                            <i class="fa fa-calendar"></i><span class="date">#dateformat(getAsset.record_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,getAsset.record_date),timeformat_style)#</span> 
                                            <i class="fa fa-pie-chart"></i><span class="filesize"> #getAsset.asset_file_size# KB</span>
                                        </div>--->
										<cfset is_saveimage=0>
											<cfif (isDefined("attributes.is_saveimage") and attributes.is_saveimage eq 1)>
												<cfset is_saveimage=1>
											</cfif>
                                <cfif is_saveimage>
                                        <div class="box-list-footer-bottom">
												<div class="box-list-button-panel col col-12" style="padding-right:10px margin:0 auto; positoin:absolite; bottom:0px">
													<ul class="box-button-panel">
                                                        <li title><i class="fa fa-plus" title="#getLang('main',54)#" onclick="window.open('#add2_#','medium');"></i></li>
                                                            <cfif filetype eq "video">
                                                                <!---#my_video_file_path#--->
                                                                <li title="#getLang('asset',6)#"><i class="fa fa-download" onclick="windowopen('index.cfm?fuseaction=objects.popup_flvplayer&video=#my_video_file_path#&ext=#ext#&content_id=#asset_id#','video');"></i></li>
                                                            <!---<cfelseif listfind(mediaplayer_extensions, "."&ext)>
                                                                <a href="#url_##asset_file_name#" class="tableyazi">#asset_name#</a>--->
                                                            <cfelse>
                                                                <li title="#getLang('asset',6)#"><i class="fa fa-download" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##getAsset.asset_file_name#&file_control=asset.form_upd_asset&asset_id=#getAsset.asset_id#&assetcat_id=#getAsset.assetcat_id#','medium');"></i></li>
                                                            </cfif>
                                                        <a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#getAsset.asset_id#&assetcat_id=#getAsset.assetcat_id#"><li title="#getLang('main',52)#"><i class="fa fa-edit"></i></li></a>
                                                        <cfif not listfindnocase(denied_pages,'objects.emptypopup_del_asset')><li title="#getLang('main',51)#"><i class="fa fa-times" onclick="javascript:if(confirm('#getLang('main',1057)#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_asset&asset_id=#ASSET_ID#&module=textile&file_name=#ASSET_FILE_NAME#&file_server_id=#ASSET_FILE_SERVER_ID#','small'); else return false;" border="0" alt="#getLang('main',51)#"></i></li>  </cfif>
                                                    </ul>
                                                </div>
										<!---
                                            <span class="author">
                                                <cfif len(getAsset.record_emp)>
                                                <!--- <a href="javascript://" onclick="nModal({head: 'Profil',page:'#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(get_emp_list_2,getAsset.record_emp,',')]#'});" class="tableyazi">#get_emp.employee_name[listfind(get_emp_list_2,getAsset.record_emp,',')]# #get_emp.employee_surname[listfind(get_emp_list_2,getAsset.record_emp,',')]#</a>--->
                                                <cfelseif len(getAsset.record_pub)>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_cons.consumer_id[listfind(get_cons_list_2,record_pub,',')]#','medium')" class="tableyazi">#get_cons.consumer_name[listfind(get_cons_list_2,record_pub,',')]# #get_cons.consumer_surname[listfind(get_cons_list_2,record_pub,',')]#</a>
                                                <cfelseif len(getAsset.record_par)>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_par.partner_id[listfind(get_par_list_2,record_par,',')]#','medium')" class="tableyazi">#get_par.company_partner_name[listfind(get_par_list_2,record_par,',')]# #get_par.company_partner_surname[listfind(get_par_list_2,record_par,',')]#</a>
                                                </cfif>
                                            </span>
											--->
                                        </div>
									</cfif>
                                    </div>
                        </div>
                </div>
 </div>
			
                                    
        </cfoutput>
      </div>
    <cfelse>
                <cfform name="asset_add" action="#request.self#?fuseaction=textile.emptypopup_upd_req" enctype="multipart/form-data">
                    <input type="hidden" name="asset_add">
                    <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#attributes.req_id#</cfoutput>">
                        <div class="col col-11 col-md-11 col-sm-6 col-xs-12" >
                                <div class="form-group" id="item-asset">
                                    <cfset foldername =createUUID()>
									<input type="hidden" name="foldername" value="<cfoutput>#foldername#</cfoutput>">
									<input type="hidden" name="message_Del" id="message_Del" value="Sil">
									<input type="hidden" name="message_Cancel" id="message_Cancel" value="İptal Et">
                                        <div id="fileUpload" class="fileUpload" style="heigth:10px;">
                                            <cfoutput>
                                            <div style="heigth:10px;" class=" col col-12 col-md-12 col-sm-10 col-xs-12 offset-1">
                                                <!-- Nav tabs -->
                                               
                                                <input type="hidden" name="asset" id="asset" value="">
                                                <input type="hidden" name="is_image" id="is_image" value="1">
                                                <div class="dropzone dz-clickable dropzonescroll" style="heigth:5mm;" id="file-dropzone">
                                                <div class="dz-default dz-message">
                                                        <span>Numune resimlerinizi sürükleyerek bırakın ya da burayı tıklayarak seçin.</span>
                                                    </div>
                                                </div>
                                                                    
                                            </div>  
                                            </cfoutput>      
                                        </div>  
                                </div>
                                <cfset is_saveimage=0>
                                <cfif (isDefined("attributes.is_saveimage") and attributes.is_saveimage eq 1)>
                                    <cfset is_saveimage=1>
                                </cfif>
                                <cfif is_saveimage>
                                        <div class="form-group" id="item-asset">
                                            <div clas="input-group" style="float:right">
                                                <button class="btn btn-success btn-small">Kaydet</button>
                                            </div>
                                        </div>
                                </cfif>
                        </div>
                </cfform>
    </cfif>
</cf_box>  
   	
    <script>
        
		var myIndex = 0;
        carousel();
        
        function carousel() {
          var i;
          var x = document.getElementsByClassName("mySlides");
		  if(x.length > 0){
          for (i = 0; i < x.length; i++) {
            x[i].style.display = "none";  
          }
          myIndex++;
          if (myIndex > x.length) {myIndex = 1}    
          x[myIndex-1].style.display = "block";  
          setTimeout(carousel, 3000); // Change image every 2 seconds
		  }
        }
        </script>