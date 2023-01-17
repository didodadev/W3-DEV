<cf_xml_page_edit fuseact="objects.form_assetp_reserve">
<cfscript>
	STARTDATE_TEMP = "";
	FINISHDATE_TEMP = "";
	startdate = "";
	starthour = 0;
	startmin = 0;
	finishdate = "";
	finishhour = 0;
	finishmin = 0;
</cfscript>
<cfif isDefined("attributes.event_id")>
	<cfquery name="EVENT_DATES" datasource="#dsn#">
		SELECT
			STARTDATE,
			FINISHDATE
		FROM
			EVENT
		WHERE
			EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
	</cfquery>
	<cfscript>
		STARTDATE_TEMP = date_add('h',session.ep.time_zone,EVENT_DATES.startdate);
		FINISHDATE_TEMP = date_add('h',session.ep.time_zone,EVENT_DATES.finishdate);
		startdate = dateformat(STARTDATE_TEMP,dateformat_style);
		starthour = timeformat(STARTDATE_TEMP,"HH");
		startmin = timeformat(STARTDATE_TEMP,"MM");
		finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
		finishhour = timeformat(FINISHDATE_TEMP,"HH");
		finishmin = timeformat(FINISHDATE_TEMP,"MM");
	</cfscript>
<cfelseif isDefined("attributes.class_id")>
	<cfquery name="get_class_dates" datasource="#dsn#">
		SELECT
			START_DATE,
			FINISH_DATE
		FROM
			TRAINING_CLASS
		WHERE
			CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
	</cfquery>  
	<cfif len(get_class_dates.start_date) and len(get_class_dates.finish_date)>
		<cfscript>
			STARTDATE_TEMP = date_add('h',session.ep.time_zone,get_class_dates.start_date);
			FINISHDATE_TEMP = date_add('h',session.ep.time_zone,get_class_dates.finish_date);
			startdate = dateformat(STARTDATE_TEMP,dateformat_style);
			starthour = timeformat(STARTDATE_TEMP,"HH");
			startmin = timeformat(STARTDATE_TEMP,"MM");
			finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
			finishhour = timeformat(FINISHDATE_TEMP,"HH");
			finishmin = timeformat(FINISHDATE_TEMP,"MM");
		</cfscript>
	</cfif>
<cfelseif isDefined("attributes.eventid")><!--- Satış Planma Ziyareti ise --->
	<cfquery name="EVENT_PLAN_DATES" datasource="#dsn#">
		SELECT
			MAIN_START_DATE,
			MAIN_FINISH_DATE
		FROM
			EVENT_PLAN
		WHERE
			EVENT_PLAN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.eventid#">
	</cfquery>
	<cfscript>
		STARTDATE_TEMP = date_add('h',session.ep.time_zone,EVENT_PLAN_DATES.MAIN_START_DATE);
		FINISHDATE_TEMP = date_add('h',session.ep.time_zone,EVENT_PLAN_DATES.MAIN_FINISH_DATE);
		startdate = dateformat(STARTDATE_TEMP,dateformat_style);
		starthour = timeformat(STARTDATE_TEMP,"HH");
		startmin = timeformat(STARTDATE_TEMP,"MM");
		finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
		finishhour = timeformat(FINISHDATE_TEMP,"HH");
		finishmin = timeformat(FINISHDATE_TEMP,"MM");
	</cfscript>
<cfelseif isDefined("attributes.prod_order_id")><!--- Uretim Emri ise --->
	<cfquery name="PROD_ORDER_DATES" datasource="#dsn3#">
		SELECT
			START_DATE,
			FINISH_DATE
		FROM
			PRODUCTION_ORDERS
		WHERE
			P_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_order_id#">
	</cfquery>
	<cfscript>
		STARTDATE_TEMP = PROD_ORDER_DATES.START_DATE;
		FINISHDATE_TEMP = PROD_ORDER_DATES.FINISH_DATE;
		startdate = dateformat(STARTDATE_TEMP,dateformat_style);
		starthour = timeformat(STARTDATE_TEMP,"HH");
		startmin = timeformat(STARTDATE_TEMP,"MM");
		finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
		finishhour = timeformat(FINISHDATE_TEMP,"HH");
		finishmin = timeformat(FINISHDATE_TEMP,"MM");
	</cfscript>
<cfelseif isDefined("attributes.project_id")><!--- projeden fiziki varlık rezerve edilecekse --->
	<cfquery name="PROJECT_DATES" datasource="#dsn#">
		SELECT
			TARGET_START,
			TARGET_FINISH
		FROM
			PRO_PROJECTS
		WHERE
			PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfquery>
	<cfscript>
		STARTDATE_TEMP = PROJECT_DATES.TARGET_START;
		FINISHDATE_TEMP = PROJECT_DATES.TARGET_FINISH;
		startdate = dateformat(STARTDATE_TEMP,dateformat_style);
		starthour = timeformat(STARTDATE_TEMP,"HH");
		startmin = timeformat(STARTDATE_TEMP,"MM");
		finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
		finishhour = timeformat(FINISHDATE_TEMP,"HH");
		finishmin = timeformat(FINISHDATE_TEMP,"MM");
	</cfscript>
<cfelseif isDefined("attributes.work_id")><!--- İş Detayından fiziki varlık rezerve edilecekse --->
	<cfset attributes.work_id = listdeleteduplicates(attributes.work_id)>
	<cfquery name="WORK_DATES" datasource="#dsn#">
		SELECT
			TARGET_START,
			TARGET_FINISH
		FROM
			PRO_WORKS
		WHERE
			WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
	</cfquery>
	<cfscript>
		STARTDATE_TEMP = WORK_DATES.TARGET_START;
		FINISHDATE_TEMP = WORK_DATES.TARGET_FINISH;
		startdate = dateformat(STARTDATE_TEMP,dateformat_style);
		starthour = timeformat(STARTDATE_TEMP,"HH");
		startmin = timeformat(STARTDATE_TEMP,"MM");
		finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
		finishhour = timeformat(FINISHDATE_TEMP,"HH");
		finishmin = timeformat(FINISHDATE_TEMP,"MM");
	</cfscript>
<cfelseif isDefined("attributes.class_id")><!--- sınıftan fiziki varlık rezerve edilecekse --->
	<cfquery name="TRAINING_CLASS" datasource="#dsn#">
		SELECT
			START_DATE,
			FINISH_DATE
		FROM
			TRAINING_CLASS
		WHERE
			CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
	</cfquery>
	<cfscript>
		STARTDATE_TEMP = TRAINING_CLASS.START_DATE;
		FINISHDATE_TEMP = TRAINING_CLASS.FINISH_DATE;
		startdate = dateformat(STARTDATE_TEMP,dateformat_style);
		starthour = timeformat(STARTDATE_TEMP,"HH");
		startmin = timeformat(STARTDATE_TEMP,"MM");
		finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
		finishhour = timeformat(FINISHDATE_TEMP,"HH");
		finishmin = timeformat(FINISHDATE_TEMP,"MM");
	</cfscript>
<cfelseif isDefined("attributes.organization_id")><!--- Etkinlikten fiziki varlık rezerve edilecekse --->
	<cfset attributes.organization_id = listdeleteduplicates(attributes.organization_id)>
	<cfquery name="ORG_DATES" datasource="#dsn#">
		SELECT
			START_DATE,
			FINISH_DATE
		FROM
			ORGANIZATION
		WHERE
			ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_id#">
	</cfquery>
	<cfscript>
		STARTDATE_TEMP = ORG_DATES.START_DATE;
		FINISHDATE_TEMP = ORG_DATES.FINISH_DATE;
		startdate = dateformat(STARTDATE_TEMP,dateformat_style);
		starthour = timeformat(STARTDATE_TEMP,"HH");
		startmin = timeformat(STARTDATE_TEMP,"MM");
		finishdate = dateformat(FINISHDATE_TEMP,dateformat_style);
		finishhour = timeformat(FINISHDATE_TEMP,"HH");
		finishmin = timeformat(FINISHDATE_TEMP,"MM");
	</cfscript>    
</cfif>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Rezervasyonlar','33512')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" list_href="javascript:openBoxDraggable('#request.self#?fuseaction=assetcare.popup_asset_reserve_history&asset_id=#assetp_id#')"  list_href_title="#getLang('','Rezervasyonlar','33512')#">
		<cfform name="assetp_reserve" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_assetp_reserve">
			<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
			<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfif isDefined("attributes.event_id")>
				<input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
			</cfif>
			<cfif isDefined("attributes.class_id")>
				<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
			</cfif>
			<cfif isDefined("attributes.project_id")>
				<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
			</cfif>
			<cfif isDefined("attributes.work_id")>
				<input type="hidden" name="work_id" id="work_id" value="<cfoutput>#attributes.work_id#</cfoutput>">
			</cfif>
			<cfif isDefined("attributes.prod_order_id")>
				<input type="hidden" name="prod_order_id" id="prod_order_id" value="<cfoutput>#attributes.prod_order_id#</cfoutput>">
			</cfif>
			<cfif isDefined("attributes.eventid")>
				<input type="hidden" name="event_plan_id" id="event_plan_id" value="<cfoutput>#attributes.eventid#</cfoutput>"><!--- Satış Planlamada Geliyorsa --->
			</cfif>
			<cfif isDefined("attributes.organization_id")>
				<input type="hidden" name="organization_id" id="organization_id" value="<cfoutput>#attributes.organization_id#</cfoutput>">
			</cfif>
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='100' is_detail='0'>
							<!---  <input type="checkbox" name="multiple" id="multiple" value="1">&nbsp;Çoklu Giriş Çıkış --->
						</div>
					</div>
					<cfif x_is_show_startdate>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz !'></cfsavecontent>
									<cfinput type="text" name="startdate" required="Yes" validate="#validate_style#" message="#message#" value="#startdate#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>	
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">	
								<cf_wrkTimeFormat name="event_start_clock" value="#starthour#">
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
								<select name="event_start_minute" id="event_start_minute">
									<option value="" selected><cf_get_lang dictionary_id='58827.dk'></option>
									<cfloop from="0" to="59" index="i">
										<cfoutput>
											<option value="#i#" <cfif startmin eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
					</cfif>
					<cfif x_is_show_finishdate>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz !'></cfsavecontent>
									<cfinput type="text" name="finishdate" required="Yes" validate="#validate_style#" message="#message#" value="#finishdate#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
								</div>
							</div>	
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
								<cf_wrkTimeFormat name="event_finish_clock" value="#finishhour#">
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
								<select name="event_finish_minute" id="event_finish_minute">
									<option value="" selected><cf_get_lang dictionary_id='58827.dk'></option>
									<cfloop from="0" to="59" index="i">
										<cfoutput>
											<option value="#i#" <cfif finishmin eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
					</cfif>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="employee_id" id="employee_id" value="#session.ep.userid#">
								<cfsavecontent variable="message1"><cf_get_lang dictionary_id='38201.Gorevli Seçmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="employee_name" required="yes" message="#message1#" value="#get_emp_info(session.ep.userid,0,0)#" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0,0','EMPLOYEE_ID','employee_id','list_works','3','250');"> 
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=assetp_reserve.employee_id&field_name=assetp_reserve.employee_name&select_list=1</cfoutput>');"></span>
							</div>
						</div>
					</div>	
					<div class="form-group" style="margin-bottom:20px;">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<textarea name="detail" id="detail"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<div class="ui-form-list-btn flex-end">
				<cf_workcube_buttons is_upd='0' add_function='form_check()' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function form_check()
{
		
	if(document.getElementById('startdate').value=="")
		{
			alert("<cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz !'>");
			return false;
		}
		if(document.getElementById('finishdate').value=="")
		{
			alert("<cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz !'>");
			return false;
		}
	<cfif x_is_show_finishdate eq 1 and x_is_show_startdate eq 1>
		if ( (assetp_reserve.startdate.value != "") && (assetp_reserve.finishdate.value != "") )
			var xx = time_check(assetp_reserve.startdate, assetp_reserve.event_start_clock, assetp_reserve.event_start_minute, assetp_reserve.finishdate,  assetp_reserve.event_finish_clock, assetp_reserve.event_finish_minute, "<cf_get_lang dictionary_id='33514.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır !'>");
		if(xx == false)
			return false;
	</cfif>
	return process_cat_control();
}
function form_close()
{
	 window.opener.opener.reload();
}
</script>
