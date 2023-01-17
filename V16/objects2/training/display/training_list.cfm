<cfparam  name="attributes.is_language" default="">
<cfsavecontent variable="ocak"><cf_get_lang_main no='180.ocak'></cfsavecontent>
	<cfsavecontent variable="subat"><cf_get_lang_main no='181.şubat'></cfsavecontent>
	<cfsavecontent variable="mart"><cf_get_lang_main no='182.mart'></cfsavecontent>
	<cfsavecontent variable="nisan"><cf_get_lang_main no='183.nisan'></cfsavecontent>
	<cfsavecontent variable="mayis"><cf_get_lang_main no='184.mayıs'></cfsavecontent>
	<cfsavecontent variable="haziran"><cf_get_lang_main no='185.haziran'></cfsavecontent>
	<cfsavecontent variable="temmuz"><cf_get_lang_main no='186.temmuz'></cfsavecontent>
	<cfsavecontent variable="agustos"><cf_get_lang_main no='187.agustos'></cfsavecontent>
	<cfsavecontent variable="eylul"><cf_get_lang_main no='188.eylül'></cfsavecontent>
	<cfsavecontent variable="ekim"><cf_get_lang_main no='189.ekim'></cfsavecontent>
	<cfsavecontent variable="kasim"><cf_get_lang_main no='190.ksaım'></cfsavecontent>
	<cfsavecontent variable="aralik"><cf_get_lang_main no='191.aralık'></cfsavecontent>
	<cfset aylar="#trim(ocak)#,#trim(subat)#,#trim(mart)#,#trim(nisan)#,#trim(mayis)#,#trim(haziran)#,#trim(temmuz)#,#trim(agustos)#,#trim(eylul)#,#trim(ekim)#,#trim(kasim)#,#trim(aralik)#">
	<cfscript>
		gun = dateformat(now(), 'dd');
		ay = dateformat(now(),'mm');
		yil = dateformat(now(),'yyyy');
		tarih = '#gun#/#ay#/#yil#';
		bugun = date_add('h', -session_base.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
	</cfscript>
	<cfset METHODS = createObject('component','V16.objects2.cfc.widget.training')>
	<cfset GET_CLASS = METHODS.GET_CLASS(START_DATE : bugun, 
	join:attributes.join,
	site : GET_PAGE.PROTEIN_SITE ,
	cat_id : attributes.cat_id ,
	maxrows : attributes.maxrows,
	language:attributes.is_language,
	limitdate:iif(isdefined('attributes.limitdate') and len(attributes.limitdate),'attributes.limitdate', 2))>
	<cfset get_training_group.recordcount = 0>
	<cfset training_group_count.recordcount = 0>
<cfif get_class.recordcount>
	<cfif len(get_class.TRAIN_GROUP_ID)>
		<cfset get_training_group = METHODS.get_training_group(train_group_id: get_class.TRAIN_GROUP_ID)>
		<cfset training_group_count = METHODS.training_group_count(train_group_id: get_class.TRAIN_GROUP_ID)>
	</cfif>
	
</cfif>
	<!--- <a href="TrainingManagementAgenda" class="btn btn-info float-right"><cf_get_lang dictionary_id='58043.Eğitim Ajandası'></a> --->
<cfscript>
	totalMinutes = 0;
	days = 0;
	minutesRemaining = 0;
	hours = 0;
	minutes = 0;
</cfscript>
<cfif get_class.recordcount>
	<div class="training">
		<div class="training_header">
			<h2 class="text-center"><cf_get_lang dictionary_id='64420.EĞİTİM VE ETKİNLİK GÜNDEMİ'> </h2>			
		</div> 
		<!--- Dersler --->
	<!--- 	<div id="training_item" class="training_item justify-content-center training_item">
			<cfif get_class.recordcount>
				<cfoutput query="get_class">
					<cfscript>
						totalMinutes = datediff("n", get_class.start_date, get_class.finish_date);
						days = int(totalMinutes /(24 * 60)) ;
						minutesRemaining = totalMinutes - (days * 24 * 60);
						hours = int(minutesRemaining / 60);
						minutes = minutesRemaining mod 60;
					</cfscript>
					<div class="col-md-6 py-3 px-2">
						<div class="training_item_img">
							<cfif isDefined("attributes.is_image") and attributes.is_image eq 1>
								<cfif isDefined("path") and len(path)>
									<img src="/documents/training/#path#" height="200px" width="200px">
								<cfelseif isDefined("video_path") and len(video_path)>
									<img src="#video_path#" height="200px" width="200px">
								</cfif>
							</cfif>
						</div>
						<div class="justify-content-center training_item_time">
							<div class="training_item_time_icon">
								<img src="/themes/protein_business/assets/img/google_meet.svg" height="40px" width="40px">
							</div>
							<cfset start_date_ = date_add('h', session_base.time_zone, get_class.start_date)>
							<cfset finish_date_ = date_add('h', session_base.time_zone, get_class.finish_date)>
							<cfif session_base.language eq 'eng'>
								#dateformat(start_date_,'dd.mm.yyyy')# - #dateformat(finish_date_,'dd.mm.yyyy')# <span> #SDAY_EN# </span> <cf_get_lang dictionary_id='57491.Saat'> : <span> #timeformat(start_date_,'HH:MM')# / #timeformat(finish_date_,'HH:MM')# </span>
							<cfelseif session_base.language eq 'DE'>
								#dateformat(start_date_,'dd.mm.yyyy')# - #dateformat(finish_date_,'dd.mm.yyyy')# <span> #SDAY_DE# </span> <cf_get_lang dictionary_id='57491.Saat'> : <span> #timeformat(start_date_,'HH:MM')# / #timeformat(finish_date_,'HH:MM')# </span>
							<cfelse>
								#dateformat(start_date_,'dd.mm.yyyy')# - #dateformat(finish_date_,'dd.mm.yyyy')# <span> #SDAY# </span> <cf_get_lang dictionary_id='57491.Saat'> : <span> #timeformat(start_date_,'HH:MM')# / #timeformat(finish_date_,'HH:MM')# </span>
							</cfif>
						</div>
						<div class="justify-content-center training_item_content">
							<div class="training_item_name">
								#class_name#
							</div>
							<div class="training_item_objective">
								<p>#CLASS_ANNOUNCEMENT_DETAIL#</p> 						
							</div>
							<div class="training_item_btn d-flex justify-content-center">
								<a class="training_det_btn" href="#site_language_path#/TrainingDetail?class_id=#class_id#"><cf_get_lang dictionary_id='57771.Detay'></a>
								<cfif isDefined("attributes.join") and attributes.join eq 1>
									<a class="training_join_btn" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=trainingForm&isbox=1&class_id=#class_id#')"><cf_get_lang dictionary_id='46962.Katıl'></a>
								</cfif>
							</div>
						</div>
					</div>			
				</cfoutput>
			<cfelse>			
				<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!			
			</cfif>	
		</div> --->
		<!--- Sınıflar --->
		<div class="training_item justify-content-center training_item">
			<cfif get_training_group.recordcount>				
				<cfoutput query="get_training_group">
					<div class="col-md-6 py-3 px-2">
						<div class="training_item_img">
							<cfif isDefined("attributes.is_image") and attributes.is_image eq 1>
								<cfif isDefined("path") and len(path)>
									<img src="/documents/training/#path#" height="200px" width="200px">
								<cfelseif isDefined("video_path") and len(video_path)>
									<img src="#video_path#" height="200px" width="200px">
								</cfif>
							</cfif>
						</div>
						<div class="justify-content-center training_item_time">
							<div class="training_item_time_icon">
								<img src="/themes/protein_business/assets/img/google_meet.svg" height="40px" width="40px">
							</div>
							<cfset start_date_ = date_add('h', session_base.time_zone, get_training_group.start_date)>
							<cfset finish_date_ = date_add('h', session_base.time_zone, get_training_group.finish_date)>
							#dateformat(start_date_,'dd.mm.yyyy')# - #dateformat(finish_date_,'dd.mm.yyyy')#
						</div>
						<div class="justify-content-center training_item_content">
							<div class="training_item_name">
								#group_head#
							</div>
							<div class="training_item_objective">
								<p>#GROUP_DETAIL#</p> 						
							</div>
							<div class="justify-content-center training_item_time">
								<p>#training_group_count.class_count# <cf_get_lang dictionary_id='46015.Ders'> - <cf_get_lang dictionary_id='57492.Toplam'> #hours# <cf_get_lang dictionary_id='57491.Saat'> #minutes# <cf_get_lang dictionary_id='58127.Dakika'></p> 						
							</div>
							<div class="training_item_btn d-flex justify-content-center">
								<a class="training_det_btn" href="#site_language_path#/TrainingDetail?class_id=#TRAIN_GROUP_ID#"><cf_get_lang dictionary_id='57771.Detay'></a>
								<cfif isDefined("attributes.join") and attributes.join eq 1>
									<cfsavecontent  variable="title"><cf_get_lang dictionary_id='54708.?'>
									</cfsavecontent>
									<cfset description= replace(group_head, "'", " ")&'-#TRAIN_GROUP_ID#'>
									<a class="training_join_btn" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=trainingForm&isbox=1&class_id=#TRAIN_GROUP_ID#&style=maxi&title=#title#&description=#description#')"><cf_get_lang dictionary_id='46962.Katıl'></a>
								</cfif>
							</div>
						</div>
					</div>			
				</cfoutput>
			<cfelse>			
				<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!			
			</cfif>	
		</div>
	</div>
<cfelse>
	<cfset widget_live = "die"><!--- kayıt yoksa widget ölür --->
</cfif>
<script>
	<cfif get_class.recordcount gt 2>
		$(function(){
			$('#training_item').slick({
				slidesToShow: 2,
				slidesToScroll: 1,
				dots:false,
				speed: 700,
				responsive: 
				[
					{
					breakpoint: 768,
					settings: {
						slidesToShow: 2
					}
					},
					{
					breakpoint: 480,
					settings: {
						slidesToShow: 1,
					}
					}
				]
			});
		})
	</cfif>
</script>