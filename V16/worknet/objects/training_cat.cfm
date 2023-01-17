<cfscript>
	if (isDefined('session.ep.userid') and len(session.ep.language)) lang=ucase(session.ep.language);
	else if (isDefined('session.ww.language') and len(session.ww.language)) lang=ucase(session.ww.language);
	else if (isDefined('session.pp.userid') and len(session.pp.language)) lang=ucase(session.pp.language);
	else if (isDefined('session.pda.userid') and len(session.pda.language)) lang=ucase(session.pda.language);
	else if (isDefined('session.wp') and len(session.wp.language)) lang=ucase(session.wp.language);
</cfscript>

<cfquery name="getTrainingCat" datasource="#dsn#">
	SELECT 
		TRAINING_CAT_ID,
		#dsn_alias#.Get_Dynamic_Language(TRAINING_CAT_ID,'#lang#','TRAINING_CAT','TRAINING_CAT',NULL,NULL,TRAINING_CAT) AS TRAINING_CAT
	FROM 
		TRAINING_CAT
</cfquery>
<cf_get_lang_set module_name="training"><!--- sayfanin en altinda kapanisi var --->
<div class="akademi_2">
	<div class="akademi_21"><cf_get_lang no='172.Egitim Katalogu'></div>
	<div class="akademi_22">
		<cfoutput query="getTrainingCat">
			<cfset getTrainingCat_ = createObject("component","worknet.objects.worknet_objects").getTraining(
				cat_id:getTrainingCat.TRAINING_CAT_ID,
				language:lang,
				training_type:0
			) />
			<cfif getTrainingCat_.recordcount>
				<cfquery name="getTrainingSec" datasource="#dsn#">
					SELECT 
						TRAINING_SEC_ID,
						#dsn_alias#.Get_Dynamic_Language(TRAINING_SEC_ID,'#lang#','TRAINING_SEC','SECTION_NAME',NULL,NULL,SECTION_NAME) AS SECTION_NAME
					FROM 
						TRAINING_SEC 
					WHERE 
						TRAINING_CAT_ID = #getTrainingCat.TRAINING_CAT_ID#
				</cfquery>
				<ul>
					<li><a <cfif isdefined('attributes.training_cat_id') and attributes.training_cat_id eq training_cat_id>class="aktif"</cfif> href="#request.self#?fuseaction=worknet.list_training&cat_id=#training_cat_id#">#getTrainingCat.training_cat#</a>
						<cfif getTrainingSec.recordcount>
							<ul id="akademi_menu_#currentrow#">
								<cfloop query="getTrainingSec">
									<cfset getTrainingSec_ = createObject("component","worknet.objects.worknet_objects").getTraining(
										sec_id:getTrainingSec.training_sec_id,
										language:lang,
										training_type:0
									) />
									<cfif getTrainingSec_.recordcount>
										<li><a <cfif isdefined('attributes.training_sec_id') and attributes.training_sec_id eq training_sec_id>class="aktif"</cfif> href="#request.self#?fuseaction=worknet.list_training&sec_id=#training_sec_id#">#getTrainingSec.section_name#</a></li>
									</cfif>
								</cfloop>
							</ul>
						</cfif>
					</li>
				</ul>
			</cfif>
		</cfoutput>
	</div>	
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
