<cfsetting showdebugoutput="no">
<cfset METHODS = createObject('component','V16.objects2.cfc.widget.training')>
<cfset GET_CLASS_COUNT = METHODS.GET_CLASS_COUNT(class_id : attributes.class_id)>
<cfif GET_CLASS_COUNT.recordcount>
	<cfset lesson_list = valueList(GET_CLASS_COUNT.LESSON_ID)>
</cfif>
<cfset GET_CLASS_DETAIL = METHODS.GET_CLASS_DETAIL(class_id : attributes.class_id)>
<cfset GET_TRAIN_DETAIL = METHODS.GET_TRAIN_DETAIL(TRAIN_ID : GET_CLASS_DETAIL.TRAIN_ID)>
<cfset GET_CONTENT_COUNT = METHODS.GET_CONTENT_COUNT(TRAIN_ID : GET_CLASS_DETAIL.TRAIN_ID)>
<cfset GET_ASSET_COUNT = METHODS.GET_ASSET_COUNT(TRAIN_ID : GET_CLASS_DETAIL.TRAIN_ID)>
<cfset training_group_class =createObject("component","V16.training_management.cfc.training_groups").GET_TRAININGS(train_group_id: attributes.class_id)>

<cfquery name="get_slides" dbtype="query">
	SELECT COUNT(*) AS SLIDE_COUNT FROM GET_ASSET_COUNT WHERE (ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%.pptx%'>) OR (ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%.slide%'>)
</cfquery>
<cfquery name="get_videos" dbtype="query">
	SELECT COUNT(*) AS VIDEO_COUNT FROM GET_ASSET_COUNT WHERE (EMBEDCODE_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%loom.com%'>) OR (EMBEDCODE_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%youtube.com%'>) OR (EMBEDCODE_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%youtu.be%'>)
</cfquery>
<cfquery name="get_podcast" dbtype="query">
	SELECT COUNT(*) AS PODCAST_COUNT FROM GET_ASSET_COUNT WHERE (ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%.mp3%'>) OR (ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%.pcast%'>)
</cfquery>

<style>
	.training_items{max-height: none; overflow: hidden;}
	.training_items .training_items_head{padding: 5px 0 5px 0;}
	.training_items .training_items_head a{text-decoration: none;color: #44b6ae;font-size: 20px; font-family: 'TitilliumWebBlack';}
	.training_items .training_items_cat{padding: 0 0 5px 0; color: #939393;}
	.training_items_bottom_btn{padding: 10px 0 10px 0;}
	.training_items_bottom_btn a{color: #E08283;}
	.training_items .training_items_cont_sum{color: #000; white-space:normal; padding: 0 0 5px 0;font-size: 12px !important;}
	.training_items .training_items_bottom{display: flex;  align-items: center; padding-bottom: 5px; padding-top: 5px;}
	.training_items .training_items_bottom .training_items_bottom_num{color:#939393 ;}
	.training_items .training_items_bottom .training_items_bottom_icon{ margin-right: 5px;}
	.training_items .training_items_bottom .training_items_bottom_rbtn{ margin-left: auto;}
	.training_items .training_items_bottom .training_items_bottom_rbtn a{font-size: 13px;  color: #000;}
	.training_items .training_items_agenda{padding: 5px 0 5px 0;}
	.training_items .training_items_agenda_left{width: 23%; float: left;}
	.training_items .training_items_agenda_left .training_items_date{background-color: #97d997;  height: 65px; border-radius: 10px; display: flex;  flex-direction: column; justify-content: center; align-items: center; margin: 0 10px 5px 0;}
	.training_items .training_items_agenda_left .training_items_date .training_items_date_d{font-size: 22px;color: #fff;font-weight: bold;}
	.training_items .training_items_agenda_left .training_items_date .training_items_date_m{font-size: 12px;color: #fff;}
	.training_items .training_items_agenda_right .training_items_h{color: #b8b8b8; font-weight: bold;font-size: 15px;padding:0 0 5px 0}
	.training_items .training_items_agenda_right .training_items_class_name{padding:0 0 5px 0}
	.training_items .training_items_agenda_right .training_items_class_name a{color: #000; font-weight: bold;font-size: 15px;}
	.training_items .training_items_agenda_right .training_items_class_name a:hover{color: #E08283;}
	.training_items .training_items_agenda_right .training_items_loc{display:flex; align-items: center; color: #b8b8b8;  font-weight: bold; font-size: 12px;}
	.training_items .training_items_agenda_right .training_items_loc span{background-repeat: no-repeat; display: block; min-width: 15px; height: 15px; margin: 0 5px 0 0;}
</style>
<cfif isdefined("attributes.list_content_width") and isnumeric(attributes.list_content_width)>
	<cfset my_image_width = attributes.list_content_width>
<cfelse>
	<cfset my_image_width = 500>
</cfif>
<cfif isdefined("attributes.list_content_height") and isnumeric(attributes.list_content_height)>
	<cfset my_image_height = attributes.list_content_height>
<cfelse>
	<cfset my_image_height = 500>
</cfif>

<div class="list_content_item_detail">
	<cfif get_class_detail.recordcount>
		<cfoutput>
			<div class="justify-content-center training_item_time">
				<div class="training_item_time_icon">
					<img src="/themes/protein_business/assets/img/google_meet.svg" height="40px" width="40px">
					<cfset start_date_ = date_add('h', session_base.time_zone, get_class_detail.start_date)>
					<cfset finish_date_ = date_add('h', session_base.time_zone, get_class_detail.finish_date)>
					<label style="color:##0e5aa6;font-size:18px;margin-left:10px">
						#dateformat(start_date_,'dd.mm.yyyy')# - #dateformat(finish_date_,'dd.mm.yyyy')#
					</label><br>
					<label style="color:##0e5aa6;font-size:18px;margin-left:55px">
						#GET_CLASS_COUNT.COUNT_CLASS# <cf_get_lang dictionary_id='47799.Ders'> - <cf_get_lang dictionary_id='57492.Toplam'> #GET_CLASS_COUNT.HOUR_NO# <cf_get_lang dictionary_id='57491.Saat'>
					</label>
				</div>
			</div>
			<div class="list_content_item_detail_title">
				<cfif isDefined('attributes.training_head') and attributes.training_head eq 1>
					<h3 style="margin-top: 20px;">#get_class_detail.class_name#</h3>
				</cfif>
			</div>
			<div class="list_chapter_item-type2_img">
				<cfif isDefined("attributes.is_image") and attributes.is_image eq 1>
					<cfif isDefined("get_class_detail.path") and len(get_class_detail.path)>
						<img src="/documents/training/#get_class_detail.path#" style="width:#my_image_width#; height:#my_image_height#;">
					<cfelseif isDefined("get_class_detail.video_path") and len(get_class_detail.video_path)>
						<img src="#get_class_detail.video_path#" style="width:#my_image_width#; height:#my_image_height#;">
					</cfif>
				</cfif>
			</div>
			<div class="list_content_item_detail_content">
				#get_class_detail.CLASS_OBJECTIVE#
			</div>
			<div style="height: 60px;"></div>
			<table style="width:100%">
				<thead>
					<tr style="border-bottom:1px solid ##eb6b6d">
						<th colspan="5" style="color:##eb6b6d;font-size:20px;padding:10px 0"><cf_get_lang dictionary_id='46049.Müfredat'></th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="GET_TRAIN_DETAIL">
						<tr style="border-bottom:1px solid ##d1d1d1">
							<td style="padding:10px 0;margin: 0 10px!important;width:50%">
								<h5>#TRAIN_HEAD#</h5>
								<p style="margin-right:10px">#TRAIN_OBJECTIVE#</p>
							</td>
							<td style="width:12.5%">
								<img style="margin-left:10px" src="/images/google-docs.svg" height="40px" width="40px"><br>
								#GET_CONTENT_COUNT.CONTENT_COUNT# Subject
							</td>
							<td style="width:12.5%">
								<img style="margin-left:10px" src="/images/google-slides.svg" height="40px" width="40px"><br>
								<cfif get_slides.recordCount>#get_slides.SLIDE_COUNT#<cfelse>0</cfif> Slide
							</td>
							<td style="width:12.5%">
								<img style="margin-left:10px" src="/images/ctl-tv-screen.svg" height="40px" width="40px"><br>
								<cfif get_videos.recordCount>#get_videos.VIDEO_COUNT#<cfelse>0</cfif> Video
							</td>
							<td style="width:12.5%">
								<img style="margin-left:10px" src="/images/google-podcasts.svg" height="40px" width="40px"><br>
								<cfif get_podcast.recordCount>#get_podcast.PODCAST_COUNT#<cfelse>0</cfif> Podcast
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<div style="height: 60px;"></div>
			<table style="width:100%" cellpadding="0">
				<thead>
					<tr style="border-bottom:1px solid ##eb6b6d">
						<th colspan="5" style="color:##eb6b6d;font-size:20px;padding:10px 0"><cf_get_lang dictionary_id='47799.Ders'>-<cf_get_lang dictionary_id='57415.Ajanda'></th>
					</tr>
				</thead>
				<tbody>
					<cfset xxx = 0>
					<cfif training_group_class.recordcount>
						<cfloop query="training_group_class">
							<cfif xxx lte training_group_class.recordcount>
								<cfif training_group_class.recordcount lte 1>
									<cfset line_no = 1>
								<cfelse>
									<cfset line_no = round(training_group_class.recordcount / 3)>
								</cfif>
								<cfloop from="1" to="#line_no#" index="rw"><!--- row number --->
									<tr>
										<cfloop from="1" to="3" index="cl"><!--- column number --->
											<cfset xxx++>
											<td style="width:20%">
												<div class="protein-table training_items">
													<table style="table-layout: fixed;width:100%">
														<tbody>
															<cfif DateCompare(now(),training_group_class.finish_date[1]) eq 0 or DateCompare(now(),training_group_class.finish_date[1]) eq -1>
																<tr>
																	<td style="word-wrap: break-word;white-space: normal;">
																		<cfif training_group_class.is_active[xxx] eq 1>
																			<div class="training_items_agenda">
																				<div class="training_items_agenda_left">
																					<div class="training_items_date">
																						<div class="training_items_date_d">
																							#dateFormat(start_date[xxx], 'dd')#
																						</div>
																						<div class="training_items_date_m">
																							#monthAsString(month(start_date[xxx]),"tr")#
																						</div>
																					</div>
																				</div>
																				<div class="training_items_agenda_right">
																					<div class="training_items_h">
																						#dateFormat(training_group_class.start_date[xxx], 'HH:mm')# - #dateFormat(training_group_class.finish_date[xxx], 'HH:mm')#
																					</div>
																					<div class="training_items_class_name">
																						<a>#training_group_class.class_name[xxx]#</a>
																					</div>
																					<div class="training_items_loc">
																						<cfif training_group_class.is_internet[xxx]>
																							<span class="ctl-whiteboard"></span><cf_get_lang dictionary_id='30015.Online'>
																						<cfelse>
																							<span class="ctl-professor"></span><cf_get_lang dictionary_id='63589.Sınıf Eğitimi'>
																						</cfif>
																					</div>
																				</div>
																			</div>
																		</cfif>
																	</td>
																</tr>
															</cfif>
														</tbody>
													</table>
												</div>
											</td>
										</cfloop>
									</tr>
								</cfloop>
							</cfif>
						</cfloop>
					<cfelse>
						<cf_get_lang dictionary_id='57484.Kayıt Yok'>
					</cfif>
				</tbody>
			</table>
			<br>
			<cfif training_group_class.recordcount><cf_get_lang dictionary_id='65491.Bu sınıfa katılmak isteyenler yukarıdaki ajandaya uygun olarak derslere katılabilirler.'></cfif>
			
			<div class="list_content_item_btn" style="margin-top:20px">
				<cfif isDefined("attributes.join") and attributes.join eq 1>
					<a class="btn btn-success" style="background-color:##f17575;border-color:##f17575" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=trainingForm&isbox=1&class_id=#attributes.class_id#')"><cf_get_lang dictionary_id='65164.Katılmak için tıklayın'></a>
				</cfif>
			</div>			
		</cfoutput>
	</cfif>
</div>