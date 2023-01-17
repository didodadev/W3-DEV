<cfparam name="attributes.topic_status" default="">
<cfinclude template="../query/get_results.cfm">
<cfinclude template="../query/get_forums.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#results.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

	<div class="w3-forum">
		<article class="wrk_frm">
			<div class="container">	
				
				<!--  Header  -->
				<div class="row wrk_frm_header mb-4">
					<div class="col-md-2  d-flex justify-content-center align-items-center">
						<img src="css\assets\template\w3-forum\images\logo.png" class="img-fluid " alt="Workcube" width="120">
					</div>
					<div class="col-md-10 d-flex justify-content-start align-items-center text-md-left text-center">
						<h2 class="font-raleway-400 wrk_frm_headBaslik w-100">
						<a href="?fuseaction=forum.list_forum">
						<cfoutput>#session.ep.COMPANY_NICK#</cfoutput>
						</a>
						<span class="font-raleway-800 ">Forum</span></h2>
					</div>
				</div>
				<!--  #Header   -->

				<div class="row">	
					<div class="col-md-1 hidden-md-down"></div>
					<div class="col-md-11 col-12">
						<!-- Filtre Form -->
						<cfoutput>
							<cfform method="post" action="#request.self#?fuseaction=forum.search">
								<div class="wrk_frm_filtre mt-0">
									<div class="col-12 col-lg-8 col-md-12 wrk_forum_left">
										<div class="row wrk_forum_search">
											<div class="col-md-3 wrk_forum_search_item p-1">
												<div class="form m-0 w-100">
													<input name="keyword" id="keyword" class="form-control w-100" type="search" value="#attributes.keyword#" placeholder="Ne Aramıştınız?">
												</div>
											</div>
											<div class="col-md-3 wrk_forum_search_item wrk_forum_combosearch p-1">
												<select class="custom-select  w-100"  name="forumid" id="forumid">
													<option selected value="0">Seçim Yapınız..</option>
													<cfloop query="forums">
														<option value="#forumid#" >#forumname#</option>
													</cfloop>
												</select>
											</div>										
											<div class="col-md-2 wrk_forum_search_item wrk_forum_connumber p-1">
												<select class="custom-select  w-100" name="topic_status" id="topic_status">
													<option value="" <cfif attributes.topic_status eq 2>selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
													<option value="1" <cfif attributes.topic_status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
													<option value="0" <cfif attributes.topic_status eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>	                        
												</select>
											</div>

											<div class="col-md-2 wrk_forum_search_item wrk_forum_connumber p-1">
												<select class="custom-select w-100" name="tarih" id="tarih">
													<option value="1" <cfif isDefined('attributes.tarih') and attributes.tarih eq 1>selected</cfif>><cf_get_lang_main no='514.Azalan Tarih'></option>
													<option value="2" <cfif isDefined('attributes.tarih') and attributes.tarih eq 2>selected</cfif>><cf_get_lang_main no='513.Artan Tarih'></option>
												</select>
											</div>
											<div class="col-md-2 wrk_forum_search_item">
												<div class="row">
													<div class="col-md-6 wrk_forum_search_item wrk_forum_searchbtn p-1">
														<button type="submit" class="btn btn-primary btn-block m-auto w-100">
													<span class="wrk-search"></span>
												</button>
													</div>
													<div class="col-md-6 wrk_forum_search_item wrk_forum_searchbtn p-1">
														<a name="wrk_search_button" href="./<cfoutput>#request.self#</cfoutput>?fuseaction=forum.form_add_forum" class="btn btn-primary btn-block m-auto w-100">
															<span class="wrk-circular-button-add" ></span>
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</cfform>
						</cfoutput> 
						<!-- # Filtre Form --> 

						<!-- Sonuçlar -->
						<cfif results.recordcount>
							<cfoutput query="results">					
								<cfset attributes.topicid = topicid>
								<cfinclude template="../query/get_reply_count.cfm">
								<cfset topicNameFirtChar= UCase(left(title,1))>	

								<div class="row wrk_frm_section mt-3">							
									<div class="col-lg-8">
										<div class="row">
											<div class="col-md-12">
												<div class="wrk_frm_section_span_konu float-left">
													#topicNameFirtChar#
												</div>
												<div class="d-block wrk_frm_section_content">
													<h4>
														<a href="#request.self#?fuseaction=forum.view_reply&TOPICID=#topicid#">
															#title#
														</a>
													</h4>
													<h5 class="text-gray-ligt">
														<cf_get_lang_main no='9.Forum'>: 
														<a href="#request.self#?fuseaction=forum.view_topic&FORUMID=#forumid#">
															#forumname#
														</a>
													</h5>
													<h4>
														<p class="wrk_frm_sect_paragraf">
															#topic#
														</p>
													</h4>

													<div class="col-md-12 wrk_sec_per_tar mdpad p-0">
														#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#
													</div>
													
												</div>
											</div>
										</div>
									</div>

									<div class="col-lg-4 wrk_frm_section_sonmesaj  d-flex justify-content-center">
										<div class="col-md-12 float-left">
											<div class="row">
												<div class="col-lg-12 col-md-6 col-sm-6 mdresp mt-2">
													<i class="wrk-blank-squared-bubble mr-2"></i>
													<cf_get_lang no='46.Cevap Sayısı'>: 
													<span class="soncevap font-raleway-600">
														#reply_count#
													</span>
												</div>
												<div class="col-lg-12 col-md-6 col-sm-6 mdresp mt-2">
													<i class="wrk-eye mr-2"></i>
													Okuyan: 
													<span class="soncevap font-raleway-600">
														#view_count#
													</span>
												</div> 
											</div>
										</div>
									</div>
									<div class="col-md-12">
										<hr class="  mt-3 gray-lighten-12">
									</div>
								</div>
						
							</cfoutput>						
						<cfelse>
								<div class="row">
									<div class="col col-12">
										Kayıt Bulunamadı
									</div>
								</div>
						</cfif>
						<!-- # Sonuçlar -->

					</div>
				
				</div>
			
			</div>
		</article>
	</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
