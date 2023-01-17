<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.modal_id" default="">
<cfquery name="ASSETP_RESERVATIONS" datasource="#dsn#">
	SELECT 
		ASSET_P_RESERVE.EVENT_ID,
		ASSET_P_RESERVE.ASSETP_RESID,
		ASSET_P_RESERVE.STARTDATE,
		ASSET_P_RESERVE.FINISHDATE,
		ASSET_P_RESERVE.RECORD_EMP,
		ASSET_P_RESERVE.RECORD_DATE,
		ASSET_P_RESERVE.CLASS_ID,
		ASSET_P_RESERVE.PROJECT_ID
	FROM 
		ASSET_P,
		ASSET_P_RESERVE
	WHERE
		ASSET_P.ASSETP_ID = #attributes.assetp_id# AND
		ASSET_P.ASSETP_ID = ASSET_P_RESERVE.ASSETP_ID
		<cfif len(attributes.startdate)>
		AND ASSET_P_RESERVE.STARTDATE <= #attributes.startdate# 
		</cfif>
		<cfif len(attributes.finishdate)>
		AND ASSET_P_RESERVE.FINISHDATE > #attributes.finishdate#
		</cfif>
</cfquery>
<cfinclude template="../query/get_assetp.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default=#assetp_reservations.recordcount#>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('assetcare',72)# : #get_assetp.assetp#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_asset" method="post" action="#request.self#?fuseaction=assetcare.popup_list_assetp_reservations&assetp_id=#assetp_id#">
			<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#assetp_id#</cfoutput>">
			<cf_box_search>
				<div class="form-group col col-3" id="item-start_date">
					<div class="input-group">
						<cfinput type="text" name="startdate" id="startdate_" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" placeholder="#getLang('','Başlangıç Tarihi','58053')#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate_"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<div class="input-group">
						<cfinput type="text" name="finishdate" id="finishdate_" value="#dateformat(attributes.finishdate,dateformat_style)#"  validate="#validate_style#" maxlength="10" placeholder="#getLang('','Bitiş Tarihi','57700')#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate_"></span>
					</div>
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>	
				<div class="form-group">	
					<cf_wrk_search_button search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_asset' , #attributes.modal_id#)"),DE(""))#" button_type="4">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="120"><cf_get_lang_main no='1713.Olay'></th>
					<th width="80"><cf_get_lang_main no='89.Başlama'></th>
					<th width="80"><cf_get_lang_main no='90.Bitiş'></th>
					<th><cf_get_lang_main no='71.Kayıt'></th>
				</tr>
			</thead>
			<tbody>
				<cfif assetp_reservations.recordcount>
					<cfoutput query="assetp_reservations">
						<cfif len(assetp_reservations.EVENT_ID)>
							<cfquery name="GET_EVENT" datasource="#DSN#">
								SELECT EVENT_ID, EVENT_HEAD AS RESERVE_NAME FROM EVENT WHERE EVENT_ID = #assetp_reservations.event_id#
							</cfquery>
						<cfelseif len(assetp_reservations.CLASS_ID)>
							<cfquery name="GET_EVENT" datasource="#DSN#">
								SELECT CLASS_ID, CLASS_NAME AS RESERVE_NAME from TRAINING_CLASS WHERE CLASS_ID= #assetp_reservations.class_id#
							</cfquery>
						<cfelseif len(assetp_reservations.PROJECT_ID)>
							<cfquery name="GET_EVENT" datasource="#DSN#">
								SELECT PROJECT_ID, PROJECT_HEAD AS RESERVE_NAME FROM PRO_PROJECTS WHERE PROJECT_ID = #assetp_reservations.project_id#
							</cfquery>
						</cfif>			
						<tr>
							<td>
							<cfif (len(assetp_reservations.EVENT_ID) or len(assetp_reservations.CLASS_ID) or len(assetp_reservations.PROJECT_ID)) and len(get_event.reserve_name)>#get_event.reserve_name#</cfif>
							<cfif len(assetp_reservations.event_id)>(<cf_get_lang_main no='3.Ajanda'>)
								<cfelseif len(assetp_reservations.class_id)>(<cf_get_lang_main no='7.Eğitim'>)
								<cfelseif len(assetp_reservations.project_id)>(<cf_get_lang_main no='4.Proje'>)
								<cfelse><cf_get_lang no='213.Olaysız'>
							</cfif> 
								</td>
								<td>#dateformat(STARTDATE,dateformat_style)# #timeformat(STARTDATE,timeformat_style)#</td> 
								<td>#dateformat(FINISHDATE,dateformat_style)# #timeformat(finishDATE,timeformat_style)#</td>
								<td>
								<cfif len(record_emp)>
									#get_emp_info(record_emp,0,0)# - 
									#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#
									#timeformat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#
								</cfif>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<script type="text/javascript">
function check(){
	if ( (search_asset.startdate.value != "") && (search_asset.finishdate.value != "") )
		return (search_asset.startdate, search_asset.finishdate, "<cf_get_lang no='52.Başlangıç tarihi bitiş tarininden küçük olmalıdır !'>");
		return true;
	}
</script>
