<cfset getTraining = createObject("component","worknet.objects.worknet_objects").getTraining(training_id:attributes.id) />
<cfset getTrainers = createObject("component","worknet.objects.worknet_objects").getTraining(class_id:attributes.id) />
<cfif getTraining.recordcount>
	<cfif isdefined('session.pp.userid')>
		<cfset user_id = session.pp.userid>
		<cfset user_type = 1>
	<cfelseif isdefined('session.ww.userid')>
		<cfset user_id = session.ww.userid>
		<cfset user_type = 2>
	</cfif>
	<cfif len(getTraining.related_class_id) and (isdefined('session.pp.userid') or isdefined('session.ww.userid'))>
		<cfset get_Completed = createObject("component","worknet.objects.worknet_objects").getTrainingCompleted(
			member_id:user_id,
			member_type:user_type,
			training_id:getTraining.related_class_id
		) />
	<cfelse>
		<cfset get_Completed = 0>
	</cfif>
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cfif session_base.language is 'tr'>İHKİB<cfelse>IHKIB</cfif> <cf_get_lang no='207.Akademi'></h1></div>
		</div>
		<cfoutput>
			<div class="akademi_1">
			<div class="akademi_11">
				<ul>
					<li><a href="#request.self#?fuseaction=worknet.list_training"><cf_get_lang no='198.Guncel Egitimler'></a></li>
					<li><a href="#request.self#?fuseaction=worknet.online_training"><cf_get_lang no='199.Online Egitimler'></a></li>
					<li><a href="#request.self#?fuseaction=worknet.my_training"><cf_get_lang no='200.Aldigim Egitimler'></a></li>
					<li style="margin-right:0px;">
						<a href="training_recommendations"><cf_get_lang no='201.Egitim Onerileri'>
							<cfif isdefined('user_id')>
                                <cfset getTRNotRead = createObject("component","worknet.objects.worknet_objects").getTrainingRecommendations(member_id:user_id,member_type:user_type,is_read:0) />
                                <cfif getTRNotRead.recordcount><samp><cfoutput>#getTRNotRead.recordcount#</cfoutput></samp></cfif>
                            </cfif>
                        </a>
					</li>
				</ul>
			</div>
			<div class="akademi_12">
				<div class="sirketp_21">
					<div class="akademi_detay">#getTraining.class_name#</div>
					<div class="sirketp_212">
						<span><cf_get_lang_main no='74.Kategori'></span>
						<samp style="width:500px;">#getTraining.training_cat# / #getTraining.section_name#</samp>
					</div>
					<cfif getTraining.online eq 1>
						<div class="sirketp_211">
							<span><cf_get_lang no='208.Eğitim Türü'></span>
							<samp style="width:500px;"><cf_get_lang_main no='2218.Online'></samp>
						</div>
						<div class="sirketp_212">
							<span><cf_get_lang no='210.Eğitimci'></span>
							<samp style="width:500px;">
								<!--- <cfif len(getTraining.TRAINER_EMP)>
									#get_emp_info(getTraining.TRAINER_EMP,0,0)#
								</cfif> --->
								<cfif getTrainers.recordcount>
									<cfloop query="getTrainers">#trainer#<cfif getTrainers.recordcount neq 1>,</cfif></cfloop>
								</cfif>							
							</samp>
						</div>
					</cfif>
					<cfif getTraining.online eq 1>
						<div <cfif getTraining.online eq 1>class="sirketp_212"<cfelse>class="sirketp_211"</cfif>>
							<span><cf_get_lang_main no='89.Baslangic'>/<cf_get_lang_main no='90.Bitis'></span>
							<samp style="width:500px;">#dateformat(getTraining.start_date,dateformat_style)# #timeformat(date_add('h',session_base.time_zone,getTraining.start_date),timeformat_style)# - 
								#dateformat(getTraining.finish_date,dateformat_style)# #timeformat(date_add('h',session_base.time_zone,getTraining.finish_date),timeformat_style)#
							</samp>
						</div>
					</cfif>
					<cfif len(getTraining.RELATED_CLASS_ID)>
						<div class="sirketp_211">
							<span><cf_get_lang no='224.İlişkili Eğitim'></span>
							<samp style="width:500px;"><a href="#request.self#?fuseaction=worknet.dsp_training&id=#getTraining.related_class_id#" style="text-decoration: underline;color: blue;margin-left: 0px;">#getTraining.related_class_name#</a></samp>
						</div>
					</cfif>
					<div class="sirketp_211">
						<span><cf_get_lang no='211.Duyuru'></span>
						<samp style="width:500px;">#getTraining.CLASS_ANNOUNCEMENT_DETAIL#</samp>
					</div>
					<div class="sirketp_212">
						<span><cf_get_lang no='212.Amaç'></span>
						<samp style="width:500px;">#getTraining.CLASS_TARGET#</samp>
					</div>
					<div class="sirketp_211">
						<span><cf_get_lang_main no='241.İçerik'></span>
						<samp style="width:500px;">#getTraining.CLASS_OBJECTIVE#</samp>
					</div>
					<cfif isdefined('session.ww.userid') and len(getTraining.stock_id)>
						<div class="sirketp_212">
							<span><cf_get_lang_main no='672.Fiyat'></span>
							<samp style="width:500px;">#TLFormat(getTraining.price_kdv,2)# TL</samp>
						</div>
					</cfif>
					<div class="akademi_detay_2">
						<cfif isdefined('session.pp') or isdefined('session.ww.userid') or getTraining.is_free eq 1>
							<cfif len(getTraining.finish_date) and len(getTraining.start_date) AND ((datediff('n',now(),getTraining.start_date) lte 15) and (datediff('n',now(),getTraining.finish_date) gte 0)) and (getTraining.online eq 1)><!--- canli --->
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_online_white_board&class_id=#getTraining.class_id#&trainer_emp=#getTraining.trainer_emp#&trainer_par=#getTraining.trainer_par#&trainer_cons=#getTraining.trainer_cons#&educationName=#getTraining.class_name#','white_board');"><cf_get_lang no='214.Katıl'></a>
							<cfelseif getTraining.online neq 1 and len(getTraining.sco_id)>
								<cfif not len(getTraining.related_class_id) and get_Completed eq 0>
									<cfset encId = encrypt(getTraining.sco_id, 'trainingSCO','CFMX_COMPAT','hex')>
									<cfif isdefined('session.pp') or getTraining.is_free eq 1>	
										<a href="#request.self#?fuseaction=training.popup_rte&id=#encId#" class="dashboard_162_tumunu"  target="_blank"><cf_get_lang no='187.İzle'></a>
									<cfelseif isdefined('session.ww.userid') and len(getTraining.stock_id)>
										<!--- bireysel uye egitim satis kontrolu --->
										<cfset getSalesTraining = createObject("component","worknet.objects.worknet_objects").getSalesTraining(stock_id:getTraining.stock_id) />
										<cfif getSalesTraining.recordcount>
											<a href="#request.self#?fuseaction=training.popup_rte&id=#encId#" target="_blank" class="dashboard_162_tumunu" ><cf_get_lang no='187.İzle'></a>
										<cfelse>
											<a href="javascript://" onclick="showPayment('#TLFormat(getTraining.price_kdv,2)#')" class="dashboard_162_tumunu" ><cf_get_lang no='187.İzle'></a>
										</cfif>
									</cfif>
								<cfelse>
									<a onclick="sessionControl(2);" class="dashboard_162_tumunu" ><cf_get_lang no='187.İzle'></a>
								</cfif>
							</cfif>
							<cfif isdefined('session.pp') or isdefined('session.ww.userid')>
								<!--- degerlendirme formu --->
								<cfset getTrainingFormGenerator = createObject("component","worknet.objects.worknet_objects").getFormGenerator(
									action_id:getTraining.class_id,
									action_type:9
								) />
								<cfif getTrainingFormGenerator.recordcount>
									<!--- egitim tamamlanma durumu --->
									<cfset get_Completed_Training = createObject("component","worknet.objects.worknet_objects").getTrainingCompleted(
										member_id:user_id,
										member_type:user_type,
										training_id:getTraining.class_id
									) />
									<cfif get_Completed_Training eq 1 or getTraining.online eq 1 or not len(getTraining.sco_id)>
										<cfset getTrainingFormGeneratorResult = createObject("component","worknet.objects.worknet_objects").getTrainingFormGeneratorResult(
											training_id:getTraining.class_id,
											survey_id:getTrainingFormGenerator.survey_main_id
										) />
										<cfif getTrainingFormGeneratorResult.recordcount>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&survey_id=#getTrainingFormGenerator.survey_main_id#&result_id=#getTrainingFormGeneratorResult.SURVEY_MAIN_RESULT_ID#&is_popup=1','list');" class="dashboard_162_tumunu" ><cf_get_lang no='231.Değerlendirme Formu'></a>
										<cfelse>
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#getTrainingFormGenerator.survey_main_id#&action_type=9&action_type_id=#getTraining.class_id#&is_popup=1','list');" class="dashboard_162_tumunu" ><cf_get_lang no='231.Değerlendirme Formu'></a>
										</cfif>
									<cfelse>
										<a href="javascript://" onclick="return alert('<cf_get_lang no='232.Değerlendirme yapabilmek için eğitimi tamamlamış olmanız gerekmektedir'>!');" title="<cf_get_lang no='232.Değerlendirme yapabilmek için eğitimi tamamlamış olmanız gerekmektedir'>" class="dashboard_162_tumunu" ><cf_get_lang no='231.Değerlendirme Formu'></a>
									</cfif>
								</cfif>
								<!--- degerlendirme formu --->
								
								<!--- Test --->
								<cfset getTrainingQuiz = createObject("component","worknet.objects.worknet_objects").getTrainingQuiz(
									training_id:getTraining.class_id
								) />
								<cfif getTrainingQuiz.recordcount>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=training.popup_make_quiz&quiz_id=#getTrainingQuiz.quiz_id#&class_id=#getTraining.class_id#','medium');" class="dashboard_162_tumunu" ><cf_get_lang_main no='1414.Test'></a>
								</cfif>
								<!--- Test --->
                                
								<!--- egitim oner --->
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=worknet.popup_add_training_suggested&class_id=#getTraining.class_id#&class_name=#getTraining.class_name#','medium');" class="dashboard_162_tumunu" ><cf_get_lang no='215.Egitimi Öner'></a>
								<!--- egitim oner --->
							</cfif>
						<cfelse>
							<cfif len(getTraining.finish_date) and len(getTraining.start_date) AND ((datediff('n',now(),getTraining.start_date) lte 15) and (datediff('n',now(),getTraining.finish_date) gte 0)) and (getTraining.online eq 1)>
								<a href="javascript://" onClick="sessionControl(1);" class="dashboard_162_tumunu" ><cf_get_lang no='214.Katıl'></a>
							<cfelseif getTraining.online neq 1>
								<a onclick="sessionControl(1);" class="dashboard_162_tumunu" ><cf_get_lang no='187.İzle'></a>
							</cfif>
						</cfif>
					</div>
				</div>
			</div>
			<cfif isdefined('session.ww.userid') and len(getTraining.stock_id)>
				<div id="payment" style="display:none; float:left !important;"><cfinclude template="training_payment.cfm"></div>
			</cfif>
		</div>
		</cfoutput>
		<cfinclude template="training_cat.cfm">
	</div>
	<script language="javascript">
		function sessionControl(type)
		{
			if(type == 1)
			{
				alert("<cf_get_lang no='159.Lütfen Üye Girişi Yapınız'> !");
				return false;
			}
			else if(type == 2)
			{
				alert("<cf_get_lang no='225.Bu Eğitimi İzlemek için Öncelikle İlişkili Eğitimi Tamamlamalısınız'>!");
				return false;
			}
		}
	</script>
<cfelse>
	<cfinclude template="hata.cfm">
</cfif>

