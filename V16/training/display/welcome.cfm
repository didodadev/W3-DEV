<cfset intranet = createObject('component','cfc.intranet')>
<cfset trainingSec = intranet.trainingSec()>
<cfset trainingClass = intranet.trainingClass(top:6)>
<cfset trainingAgenda = intranet.trainingClass(top:3)>
<cfset trainingAnounce = intranet.trainingAnounce()>
<style>
	.ui-form-list-btn{justify-content:end;}
    .joinLink {padding: 5px;}
    .joinLink:hover {background-color: #44b6ae;}
</style>
<cfinclude template="../../rules/display/rule_menu.cfm">
<div style="margin-top:-5px;padding:0 10px;" class="col col-12">
	<cfinclude template="general_training_menu.cfm">
</div>
<cfset cfc = createObject('component','V16.training_management.cfc.trainingcat')>
<cfset get_trainings = cfc.GET_TRAININGS()>
<cfset get_content = cfc.get_content()>
<cfset get_class = cfc.get_class()>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">

<div class="col col-12">
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<cf_box class="clever" scroll="0">
			<div class="portHeadLight">
				<div class="portHeadLightTitle">
					<span>
						<a href="javascript://"><cf_get_lang dictionary_id='46049.Müfredat'></a>
					</span>
				</div>
			</div>
			<div class="protein-table training_items">
				<table style="table-layout: fixed;">
					<tbody>
						<cfoutput query="get_trainings" maxrows="5">
							<tr>
								<td style="word-wrap: break-word;white-space: normal;">
									<cfset attributes.sec_id = get_trainings.TRAINING_SEC_ID>
									<cfinclude template="../../training_management/query/get_training_sec_names.cfm">
									<div class="training_items_head">
										<a href="#request.self#?fuseaction=training.curriculum&event=det&train_id=#train_id#">#train_head#</a>
									</div>
									<div class="training_items_cat">
										#GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#
									</div>
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
			</div>
			<div class="training_items_bottom_btn">
				<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training.curriculum&form_submitted=1">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
			</div>
		</cf_box>
	</div>
		
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<cf_box class="clever" scroll="0">
			<div class="portHeadLight">
				<div class="portHeadLightTitle">
					<span>
						<a href="javascript://"><cf_get_lang dictionary_id='63579.Öne Çıkan İçerikler'></a>
					</span>
				</div>
			</div>
			<div class="protein-table training_items">
				<table style="table-layout: fixed;">
					<tbody>
						<cfoutput query="get_content">
							<tr>
								<td style="word-wrap: break-word;white-space: normal;">
									<cfif len(PHOTO)>
										<img src="documents/content/#PHOTO#" style="width:100%" height="150px">
									</cfif>
									<div class="training_items_head">
										<a href="#request.self#?fuseaction=training.content&event=det&cntid=#content_id#">#CONT_HEAD#</a>
									</div>
									<div class="training_items_cont_sum">
										#CONT_SUMMARY#
									</div>
									<div class="training_items_cat">
										#CONTENTCAT#/#CHAPTER#
									</div>
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
			</div>
			<div class="training_items_bottom_btn">
				<a href="<cfoutput>#request.self#?fuseaction=training.content</cfoutput>">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
			</div>
		</cf_box>
	</div>

	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<cf_box class="clever" scroll="0">
			<div class="portHeadLight">
				<div class="portHeadLightTitle">
					<span>
						<a href="javascript://"><cf_get_lang dictionary_id='58049.Sınıflar'></a>
					</span>
				</div>
			</div>
			<div class="protein-table training_items">
				<table style="table-layout: fixed;">
					<tbody>
						<cfset groups = createObject("component","V16.training_management.cfc.training_groups")>
						<cfset training_groups ="#groups.get_training_groups(keyword: attributes.keyword, status: attributes.status)#">
						<cfoutput query="training_groups" maxrows="5">
							<tr>
								<td style="word-wrap: break-word;white-space: normal;">
                                    <cfif FileExists("documents/train_group/#path#")>
                                        <img src="documents/train_group/#path#" style="width:100%" height="150px">
                                    </cfif>
									<div class="training_items_head">
										<a href="#request.self#?fuseaction=training.list_training_groups&event=upd&train_group_id=#TRAIN_GROUP_ID#">#group_head#</a>
									</div>
									<div class="training_items_bottom">
										<div class="training_items_bottom_icon">
											<i class="icon-SUBO" style="color:##f8a128"></i> 
										</div>
										<div class="training_items_bottom_num">
											#quota#
										</div>
										<div class="training_items_bottom_rbtn">
											<cfset attenders ="#groups.get_training_group_attenders(train_group_id: train_group_id)#">
                                            <cfif attenders.emp_id neq session.ep.userid>
                                                <a class="joinLink" href="javascript://" onclick="joinClass(#training_groups.train_group_id#)">
                                                    <cf_get_lang dictionary_id='46962.Katıl'>
                                                </a>
                                            </cfif>
										</div>
									</div>
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
			</div>
			<div class="training_items_bottom_btn">
				<a href="javascript://">> <cf_get_lang dictionary_id='36496.Tamamı'></a>
			</div>
		</cf_box>
	</div>
	
	<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
		<cf_box class="clever" scroll="0">
			<div class="portHeadLight">
				<div class="portHeadLightTitle">
					<span>
						<a href="javascript://"><cf_get_lang dictionary_id='58063.Dersler'>-<cf_get_lang dictionary_id='57415.Ajanda'></a>
					</span>
				</div>
			</div>
			<div class="protein-table training_items">
				<table style="table-layout: fixed;">
					<tbody>
						<cfoutput query="get_class" maxrows="5">
							<cfset get_training_groups = cfc.get_training_groups(class_id:get_class.class_id)>
							<cfif get_training_groups.emp_id EQ session.ep.userid>
								<tr>
									<td style="word-wrap: break-word;white-space: normal;">
										<cfif is_active>
											<div class="training_items_agenda">
												<div class="training_items_agenda_left">
													<div class="training_items_date">
														<div class="training_items_date_d">
															#dateFormat(start_date, 'dd')#
														</div>
														<div class="training_items_date_m">
															#monthAsString(month(start_date),"tr")#
														</div>
													</div>
												</div>
												<div class="training_items_agenda_right">
													<div class="training_items_h">
														#dateFormat(start_date, 'HH:mm')# - #dateFormat(finish_date, 'HH:mm')#
													</div>
													<div class="training_items_class_name">
														<a href="#request.self#?fuseaction=training.lesson&event=det&lesson_id=#class_id#">#class_name#</a>
													</div>
													<div class="training_items_loc">
														<cfif is_internet>
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
						</cfoutput>
					</tbody>
				</table>
			</div>
			<div class="training_items_bottom_btn">
				<a href="<cfoutput>#request.self#?</cfoutput>fuseaction=training.lesson">> <cf_get_lang dictionary_id='58932.Aylık'><cf_get_lang dictionary_id='57415.Ajanda'></a>
			</div>
		</cf_box>
	</div>
</div>
<script>
    function joinClass(requestId){
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=training.list_training_groups&event=joinClass&train_group_id=</cfoutput>'+requestId);
    }
</script>