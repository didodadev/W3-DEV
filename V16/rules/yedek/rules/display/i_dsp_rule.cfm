<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-57b2bf8be5b4014c"></script>

<cfparam name="attributes.content_id"  default="">
<cfquery name="GET_PRODUCT_COMMENT" datasource="#DSN#">
	SELECT 
		*
	FROM
		CONTENT_COMMENT
	WHERE
		CONTENT_ID = <cfqueryparam value ="#attributes.cntid#">  		
		AND STAGE_ID = -2 
</cfquery>
<cfprocessingdirective pageEncoding = "utf-8"/>

	
<div class="row r-content ">
	<div class="col-12 r-share-nav">
		<h3 class="">Toplam Kalite Yönetimi > Erp Nedir?</h3>
	</div>

	<div class="col-12">
		<div class="row">
			<div class=" col-8 r-share-content">
				<div class="col-12">
					<cfif get_content.is_dsp_header eq 0>
						<h3 class="col-12"><cfoutput>#get_content.cont_head#</cfoutput></h3>					    
					</cfif>
					<cfif get_our_company_info.is_content_follow eq 1>					
						<script type="text/javascript">connectAjax();</script>
					<cfelse>
						<cfif get_content.is_dsp_summary eq 0>
							<p class="col-12 bold"><cfoutput>#get_content.cont_summary#</cfoutput></p>                             
						</cfif>
						<p class="col-12"><cfoutput>#get_content.cont_body#</cfoutput></p>
					</cfif>
				<hr class="col-12"/>
				</div>
				<div class="row px-3">
					<div class="col-md-6 empl-info">								
						<img src="../../../css/assets/template/w3-assets/images/boy.jpg" class="img-circle" alt="Responsive image">
						
						<a href=""> 
							<cfoutput>#get_content.employee_name# #get_content.employee_surname#</cfoutput>
						</a>
						<p>
							<cfoutput>
							<cfif len(get_content.record_date)>#dateformat(date_add('h',session.ep.time_zone,get_content.record_date),'dd/mm/yy')# #timeformat(date_add('h',session.ep.time_zone,get_content.record_date),timeformat_style)#</cfif> <span>V.<cfoutput>#get_content.upd_count#</cfoutput></span>
							</cfoutput>
							</p>
						<p class="pr-0">
							<cf_get_lang_main no='583.Bölüm'>:
							<cfoutput query="get_chapter_menu"> 
								<cfif get_content.chapter_id is chapter_id>#chapter#</cfif> 
							</cfoutput>
						</p>
					</div>
					<div class="col-6 r-soc-menu addthis_sharing_toolbox">
					<!-- Go to www.addthis.com/dashboard to customize your tools --> 
					
						
					</div>
				</div>

				<div class="col-12 r-share-comments">
				<cfinclude template="../query/get_content_head.cfm">
					<div class="row ">			
						<div class="col-9">
						<hr class="hr-c"></hr>
						</div>
						<div class="col-3 comment-title">
						YORUMLAR
						</div>
					</div>
				<cfif GET_PRODUCT_COMMENT.RECORDCOUNT>
					<div class="col col-12" id="comments">
					
					<cfoutput query="GET_PRODUCT_COMMENT">
						<div class="col-12 comment-content">											
							<img src="../../../css/assets/template/w3-assets/images/boy.jpg" class="img-circle" alt="Responsive image">
							#content_comment#
							<a class="col-12" href="">#name# #surname#</a><br/>
							<span class="col-12">#record_date#</span>
							<hr/>
						</div>
					</cfoutput>
					</div>
				<cfelse>	
						<p><cf_get_lang no='27.Yayınlanan Yorum Bulunamadı'></p>
				</cfif>
					
					<cfquery name="get_employee_email" datasource="#dsn#">
						SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
					</cfquery>
					<form name="employe_detail" id="employe_detail" method="post" 
					action="<cfoutput>#request.self#</cfoutput>?fuseaction=rule.emptypopup_add_content_comment">
						<div class="row comment-add">
							<h3 class="col-10">YORUM EKLE</h3>
							<div class="col-2 ">
							<cfsavecontent variable="message"><cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='16.E-mail !'></cfsavecontent>
							<input type="hidden" name="MAIL_ADDRESS" id="MAIL_ADDRESS" value="<cfoutput>#get_employee_email.employee_email#</cfoutput>" required="yes" message="#MESSAGE#" >
								
							</div>
							
							<input name="CONTENT_COMMENT_POINT" id="CONTENT_COMMENT_POINT" type="hidden" value="5">
								<div class="col-12 px-0">

								<cfmodule
											template="/fckeditor/fckeditor.cfm"
											toolbarset="WRKContent"
											basepath="/fckeditor/"
											instancename="CONTENT_COMMENT"
											valign="top"
											value=""
											width="100%"
											height="100"
											label="">	
								<!--
									<input class="form-control col-12 w-100" name="keyword" id="keyword" type="search" value=""> -->
									
								</div>
								<div class="col-12 d-flex justify-content-end align-items-center">
									<button is_upd='0' type="button" onclick="control()"  class=" col-2 btn btn-primary btn-block" >
										<span class="wrk-circular-button-add"></span>
									</button>
								</div>
						</div>
						<div id="editor_div"></div>
					</form>
				</div>
			</div>
			<div class="col-4 r-share-other">
				<cfif get_asset.recordcount>	
				<cfquery name="GET_ASSETS" dbtype="query">
						SELECT * FROM GET_ASSET WHERE ASSET_FILE_NAME NOT LIKE '%.flv%' AND ASSET_FILE_NAME NOT LIKE '%.swf%'
				</cfquery>
				<div class="col-12 r-documents">
					<div class="col-12 px-0">
						<cfif get_asset.recordcount>
							<hr/>
								<h4 class=""><cf_get_lang_main no ='156.Belgeler'></h4>
							<hr/>
							<cfoutput query="get_assets">	
								<ul class="col-12 px-0">								
									<cfquery name="GET_ASSET_CAT" dbtype="query">
										SELECT ASSETCAT_ID,ASSETCAT_PATH FROM GET_ASSET_CATS WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetcat_id#">
									</cfquery>
									<cfif not len(asset_file_path_name)>
										<cfif assetcat_id gte 0>
											<cfset folder="asset/#get_asset_cat.assetcat_path#">
										<cfelse>
											<cfset folder="#get_asset_cat.assetcat_path#">
										</cfif>
									</cfif>
									<li>							
										<a href="javascript:windowopen('#file_web_path##folder#/#asset_file_name#','small');" title="#asset_detail#" class="tableyazi"><i class="wrk-document-with-folded-corner"></i>
										#asset_name# (#name#)
										</a>
									</li>													
								</ul>
							</cfoutput>	
						</cfif>					
						<cfquery name="GET_VIDEOS" dbtype="query">
							SELECT * FROM GET_ASSET WHERE ASSET_FILE_NAME LIKE '%.flv%' OR ASSET_FILE_NAME LIKE '%.swf%' ORDER BY ASSET_NAME
						</cfquery>						
						
						<cfif get_videos.recordcount>
							<cfoutput query="get_videos">
								<hr/>
									<h4 class=""><cf_get_lang no ='3.Videolar'></h4>
								<hr/>
								<ul class="col-12 px-0">								
									<cfquery name="GET_ASSET_CAT" dbtype="query">
										SELECT ASSETCAT_ID,ASSETCAT_PATH FROM GET_ASSET_CATS WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#assetcat_id#">
									</cfquery>
									<cfif not len(asset_file_path_name)>
										<cfif assetcat_id gte 0>
												<cfset folder="asset/#get_asset_cat.assetcat_path#">
											<cfelse>
												<cfset folder="#get_asset_cat.assetcat_path#">
										</cfif>
									</cfif>
									<li>
										<a href="javascript:windowopen('#file_web_path##folder#/#asset_file_name#','small');" title="#asset_detail#" class="tableyazi"><i class="wrk-video-play"></i>
											#asset_name# (#name#)
										</a>
									</li>
								</ul>
							</cfoutput>							
						</cfif>						
					</div>
				</div>
				</cfif>

				<cfinclude template="../query/get_image_cont.cfm">
					<div class="col-12 img-content px-0">
						<cfoutput query="get_image_cont">
							<a class="col-12" href="javascript://" onclick="windowopen('#file_web_path#content/#contimage_small#','small');" title="#detail#">
								<img src="#file_web_path#content/#contimage_small#" title="<cf_get_lang no='16.Orjinal Resim İçin Tıklayınız...'>"  class="col-12 img-fuild">
							</a>					
						</cfoutput> 
					</div>		
				<cfinclude template="../query/get_spots.cfm">
					<cfoutput query="get_spots">
						<div class="other-post">
							<div class="col-12 px-0">				
								<img src="../../../css/assets/template/w3-assets/images/time.jpg" class="col-12 img-fuild" alt="Responsive image">
							</div>
							<div class="col-12">					
								<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_spots.content_id[1]#">
									<h4 class="">#get_spots.cont_head#</h4>
								</a>
							</div>
							<div class="col-12">
								<p>#get_spots.cont_summary#</p>	
							</div>
							<ul class="col-12 mb-5">
								<li>
									<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#"><cf_get_lang_main no='714.Devam'>
								</li>
							</ul>
						</div>
					</cfoutput>		
			</div>
		</div>
	</div>			   
</div>

<script type="text/javascript">
	function control(){

	/*sendData = 'postBody='+encodeURIComponent(CKEDITOR.instances.CONTENT_COMMENT.getData())+
		'Content_id='+<cfoutput>#attributes.cntid#</cfoutput>+
		'name='+$('#name').val()+
		',surname='+$('#surname').val()+
		',CONTENT_COMMENT_POINT'+$('#CONTENT_COMMENT_POINT').val()+
		',MAIL_ADDRESS'+$('#MAIL_ADDRESS').val(); 
		
		encodeURIComponent(CKEDITOR.instances.CONTENT_COMMENT.getData())					
	*/


var q = CKEDITOR.instances.CONTENT_COMMENT.document.getBody().getHtml();

		var data = {
			CONTENT_COMMENT : q,
			Content_id : <cfoutput>#attributes.cntid#</cfoutput>,
			name : '<cfoutput>#session.ep.name#</cfoutput>',
			surname : '<cfoutput>#session.ep.surname#</cfoutput>',
			CONTENT_COMMENT_POINT : +$('#CONTENT_COMMENT_POINT').val(),
			MAIL_ADDRESS : '<cfoutput>#get_employee_email.employee_email#</cfoutput>'
		};			
		$.ajax({

		url: '<cfoutput>#request.self#</cfoutput>?fuseaction=rule.emptypopup_add_content_comment',
		type: "POST",
		data: data,          

			success: function (returnData) {


				var today = new Date();
					var dd = today.getDate();
					var mm = today.getMonth()+1; 
					var yyyy = today.getFullYear();

					if(dd<10) {
						dd = '0'+dd
					} 

					if(mm<10) {
						mm = '0'+mm
					} 

					today = mm + '/' + dd + '/' + yyyy

					var comment = '<div class="col-12 comment-content">' +
											'<img src="../../../css/assets/template/w3-assets/images/boy.jpg" class="img-circle" alt="Responsive image">'+
													data.CONTENT_COMMENT +
												'<a class="col-12" href="">'+
													data.name + data.surname+ 
													'</a><br/> <span class="col-12">'+
													today +'</span><hr/></div>';


					$('#comments').append(comment);
					CKEDITOR.instances.CONTENT_COMMENT.setData("");

					/*if(returnData>=1)
					{
						alertObject({type:
						'success',message:
						'İçerik Güncellendi..', 
						closeTime: 5000});                    
					}
					else if(returnData==0)
					{
						alertObject({type:
						'danger',message:
						'Daha sonra tekrar deneyiniz...', 
						closeTime: 5000});

					}*/
			},

				error: function () 
				{
					alert("Bir Hata Oluştu");
				}

		});

	}
</script>
 				