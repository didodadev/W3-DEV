<cfif isdefined('session.pp.userid') or isdefined('session.ww.userid')>
	<cfinclude template="../../training_management/scorm_engine/core.cfm">
	
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	
	<cfif isdefined('attributes.partner_id')>
		<cfset user_id = Decrypt(attributes.partner_id,'trainingDetail','CFMX_COMPAT','hex')>
		<cfset user_type = 1>
	<cfelseif isdefined('session.pp.userid')>
		<cfset user_id = session.pp.userid>
		<cfset user_type = 1>
	<cfelseif isdefined('session.ww.userid')>
		<cfset user_id = session.ww.userid>
		<cfset user_type = 2>
	</cfif>
	<cfset get_data = createObject("component","worknet.objects.worknet_objects").getTrainingData(
		member_id:user_id,
		member_type:user_type
	) />
	
	
	<cfparam name="attributes.totalrecords" default="#get_data.recordcount#">
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11">
				<h1>
					<cfif isdefined('attributes.partnerName') and len(attributes.partnerName)><cfoutput>#Decrypt(attributes.partnerName,'trainingDetail','CFMX_COMPAT','hex')# - </cfoutput></cfif>
					IHKIB <cf_get_lang no='207.Akademi'> 
				</h1>
			</div>
		</div>
		
		<div class="akademi_1">
			<cfif not isdefined('attributes.partner_id')>
				<div class="akademi_11">
					<cfset getTRNotRead = createObject("component","worknet.objects.worknet_objects").getTrainingRecommendations(member_id:user_id,member_type:user_type,is_read:0) />
					<cfoutput>
					<ul>
						<li><a href="#request.self#?fuseaction=worknet.list_training"><cf_get_lang no='198.Guncel Egitimler'></a></li>
						<li><a href="#request.self#?fuseaction=worknet.online_training"><cf_get_lang no='199.Online Egitimler'></a></li>
						<li><a class="aktif" href="#request.self#?fuseaction=worknet.my_training"><cf_get_lang no='200.Aldigim Egitimler'></a></li>
						<!---<li><a href="training_demands"><cf_get_lang no='213.Eğitim Taleplerim'></a></li>--->
						<li style="margin-right:0px;">
							<a href="training_recommendations"><cf_get_lang no='201.Egitim Onerileri'><cfif getTRNotRead.recordcount><samp><cfoutput>#getTRNotRead.recordcount#</cfoutput></samp></cfif></a>
						</li>
					</ul>
					</cfoutput>
				</div>
			</cfif>
			<div class="akademi_12" <cfif isdefined('attributes.partner_id')> style="width:910px;"</cfif>>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
					<tr class="mesaj_31">
						<td width="15" class="mesaj_311_1_1"><cf_get_lang_main no='75.No'></td>
						<td class="mesaj_311_1_1"><cf_get_lang_main no='7.Egitim'></td>
						<td class="mesaj_311_1_1"><cf_get_lang no='202.Oturum Suresi'></td>
						<td class="mesaj_311_1_1"><cf_get_lang no='203.Tamamlanma Orani'></td>
						<td class="mesaj_311_1_1"><cf_get_lang no='204.Tamamlanma Durumu'></td>
						<td class="mesaj_311_1_1"><cf_get_lang_main no='1975.Skor'></td>
						<td class="mesaj_311_1_1"><cf_get_lang no='229.Katılım Sertifikası'></td>
					</tr>
					<cfif get_data.recordcount>
						<cfloop query="get_data">
						<cfquery name="get_total_time" datasource="#APPLICATION_DB#">
							SELECT ISNULL(VAR_VALUE, '') AS TOTAL_TIME FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #get_data.USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'totalTime', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif get_total_time.recordCount eq 0>
							<cfset QueryAddRow(get_total_time, 1)>
							<cfset QuerySetCell(get_total_time, "TOTAL_TIME", "-", 1)>
						</cfif>
						
						<cfquery name="get_score" datasource="#APPLICATION_DB#">
							SELECT ISNULL(VAR_VALUE, '0') AS SCORE FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #get_data.USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'score', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif get_score.recordCount eq 0>
							<cfset QueryAddRow(get_score, 1)>
							<cfset QuerySetCell(get_score, "SCORE", "-", 1)>
						</cfif>
						
						<cfquery name="get_completion_status" datasource="#APPLICATION_DB#">
							SELECT ISNULL(VAR_VALUE, '') AS COMPLETION_STATUS FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #get_data.USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'completionStatus', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif get_completion_status.recordCount eq 0>
							<cfset QueryAddRow(get_completion_status, 1)>
							<cfset QuerySetCell(get_completion_status, "COMPLETION_STATUS", "-", 1)>
						</cfif>
						<cfquery name="get_success_status" datasource="#APPLICATION_DB#">
							SELECT ISNULL(VAR_VALUE, '') AS SUCCESS_STATUS FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #get_data.USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'successStatus', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif get_success_status.recordCount eq 0>
							<cfset QueryAddRow(get_success_status, 1)>
							<cfset QuerySetCell(get_success_status, "SUCCESS_STATUS", "-", 1)>
						</cfif>
						<cfquery name="get_progress" datasource="#APPLICATION_DB#">
							SELECT ISNULL(VAR_VALUE, '0') AS PROGRESS FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'progress', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif get_progress.recordCount eq 0>
							<cfset QueryAddRow(get_progress, 1)>
							<cfset QuerySetCell(get_progress, "PROGRESS", "-", 1)>
						</cfif>
						<cfquery name="get_data_id" datasource="#APPLICATION_DB#">
							SELECT DATA_ID FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'userID', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif get_data_id.recordCount eq 0>
							<cfset QueryAddRow(get_data_id, 1)>
							<cfset QuerySetCell(get_data_id, "DATA_ID", "-", 1)>
						</cfif>
						
						<cfset QuerySetCell(get_data, "TOTAL_TIME", get_total_time.TOTAL_TIME, currentRow)>
						<cfset QuerySetCell(get_data, "SCORE", "#get_score.SCORE#", currentRow)>
						<cfset QuerySetCell(get_data, "COMPLETION_STATUS", "#get_completion_status.COMPLETION_STATUS#", currentRow)>
						<cfset QuerySetCell(get_data, "SUCCESS_STATUS", "#get_success_status.SUCCESS_STATUS#", currentRow)>
						<cfset QuerySetCell(get_data, "PROGRESS", "#get_progress.PROGRESS#", currentRow)>
						<cfset QuerySetCell(get_data, "DATA_ID", "#get_data_id.DATA_ID#", currentRow)>
						
					</cfloop>
						<cfoutput query="get_data" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
							<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
								<td class="tablo1">#currentrow#</td>
								<td class="tablo1"><a href="#request.self#?fuseaction=worknet.dsp_training&id=#class_id#">#CLASS_NAME#</a></td>
								<td class="tablo1">#TOTAL_TIME#</td>
								<td class="tablo1"><cfif isNumeric(PROGRESS)>% #round(PROGRESS * 100)#<cfelse>#PROGRESS#</cfif></td>
								<td class="tablo1">
									<cfif COMPLETION_STATUS is 'incomplete'>
										<cf_get_lang_main no='2068.Tamamlanmamış'>
									<cfelseif COMPLETION_STATUS is 'completed'>
										<cf_get_lang_main no='1374.Tamamlandı'>
									</cfif>
								</td>
								<td class="tablo1"><cfif isNumeric(SCORE)>#round(SCORE)#<cfelse>#SCORE#</cfif></td>
								<td class="tablo2" style=" padding-left:25px;">
									<cfif COMPLETION_STATUS is 'completed'>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_katilim_belgesi&CLASS_NAME=#CLASS_NAME#&userid=#user_id#&usertype=#user_type#','project')"><img src="../../documents/templates/worknet/tasarim/print.gif" />
									</cfif>
								</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="mesaj_34">
							<td class="tablo1" colspan="7"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
						</tr>
					</cfif>
				</table>
			</div>
			
			<div class="maincontent">
				<cfif attributes.totalrecords gt attributes.maxrows>
					<cfset urlstr="">
					<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
						<cfset urlstr="#urlstr#&partner_id=#attributes.partner_id#">
					</cfif>
					<cfif isdefined('attributes.partnerName') and len(attributes.partnerName)>
						<cfset urlstr="#urlstr#&partnerName=#attributes.partnerName#">
					</cfif>
				
							  <cf_paging page="#attributes.page#" 
								page_type="1"
								maxrows="#attributes.maxrows#" 
								totalrecords="#attributes.totalrecords#" 
								startrow="#attributes.startrow#" 
								adres="#attributes.fuseaction##urlstr#">
						
				</cfif>
			</div>
		</div>
		<cfif not isdefined('attributes.partner_id')>
			<cfinclude template="training_cat.cfm">
		</cfif>
	</div>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
