<!--- Url üzerinden position_code gönderildiğinde çalışacak hale getirildi. Position code a göre employee_id yi bulup ona göre çalışıyor... --->
<cfif attributes.fuseaction eq 'rule.list_hr'>
	<cf_xml_page_edit fuseact="rule.list_hr">
<cfelse>
	<cf_xml_page_edit fuseact="objects.popup_emp_det">
</cfif>
	<cfinclude template="../query/get_emp_det.cfm">
	<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
		<cf_date tarih = "attributes.startdate">
	<cfelse>
		<cfset attributes.startdate = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
	</cfif>
	<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
		<cf_date tarih = "attributes.finishdate">
	<cfelse>
		<cfset attributes.finishdate = date_add('d',7,attributes.startdate)>
	</cfif>
	<cfif len(get_emp_pos.title_id)>
		<cfset attributes.title_id = get_emp_pos.title_id>
		<cfinclude template="../query/get_title.cfm">
	</cfif>
	<cfif len(get_emp_pos.department_id)>
		<cfset attributes.department_id = get_emp_pos.department_id>
		<cfinclude template="../query/get_location.cfm">
		<cfif len(get_location.company_id)>
			<cfquery name="GET_COMPANY" datasource="#DSN#">
				SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_location.company_id#">
			</cfquery>
		</cfif>
	<cfelse>
		<cfset attributes.department_id = 0>
	</cfif>
	<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
		<cfset attributes.pos_id = attributes.pos_code>
	<cfelseif len(get_emp_pos.position_code)>
		<cfset attributes.pos_id = get_emp_pos.position_code>
	</cfif>
	<cfif isdefined("attributes.pos_id") and len(attributes.pos_id)>
		<cfquery name="GET_CHIEFS" datasource="#DSN#">
			SELECT CHIEF1_CODE,CHIEF2_CODE FROM EMPLOYEE_POSITIONS_STANDBY WHERE EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_id#">
		</cfquery>
	</cfif>
	<cfquery name="GET_EMP_ALL_POS" datasource="#DSN#">
		SELECT 
			POSITION_CODE,
			POSITION_NAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#">
		<cfelse>
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
		</cfif>
	</cfquery>
	<cfif Len(detail_emp.employee_id)>
		<cfquery name="get_employee_detail" datasource="#dsn#">
			SELECT ED.MOBILCODE_SPC, ED.MOBILTEL_SPC, ED.EMAIL_SPC, E.EXTENSION, ISNULL(HOMECOUNTRY,0) HOMECOUNTRY FROM EMPLOYEES_DETAIL AS ED LEFT JOIN EMPLOYEES AS E ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID WHERE E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_emp.employee_id#">
		</cfquery>
		<cfif len(get_employee_detail.homecountry)>
			<cfquery name="get_country_info" datasource="#dsn#">
				SELECT COUNTRY_PHONE_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee_detail.homecountry#">
			</cfquery>
		</cfif>
	</cfif>
	<script type="text/javascript">
		function open_emp_info()
		{
			goster(eval("document.getElementById('div_emp_info')"));
			adres_ = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_emp_events&emp_id=#attributes.emp_id#</cfoutput>';
			if(document.get_events.startdate.value!='')
				adres_ = adres_ + '&startdate=' + document.get_events.startdate.value;
			if(document.get_events.finishdate.value!='')
				adres_ = adres_ + '&finishdate=' + document.get_events.finishdate.value;
			AjaxPageLoad(adres_,'div_emp_info',1);
		}
	</script>
	<!---<cfsavecontent variable="head"><cf_get_lang dictionary_id="53457.Çalışan Detay"></cfsavecontent>--->
	
	<cfif isdefined('attributes.fuseaction') and attributes.fuseaction eq 'rule.list_hr'>
		<cfinclude template="../../rules/display/rule_menu.cfm">
	</cfif>
	<cfparam name="attributes.modal_id" default="">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='53457.Employee Detail'></cfsavecontent>
	<div class="wrapper" id="who_content">
		<cf_box title="#head#"  closable="1" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined('attributes.draggable'),1,0)#">
			<cfoutput> 
				<div class="who_item_detail">
					<div class="who_item_detail_info">				
						<div class="who_item_detail_img">
							<cfif len(detail_emp.photo)><img src="/documents/hr/#detail_emp.photo#"><cfelse><img src="/images/maleicon.jpg"></cfif>
						</div>	
						<div class="who_item_detail_text">
							<p>#detail_emp.employee_name# #detail_emp.employee_surname#</p>
							<cfquery name="POSITION" datasource="#DSN#">
								SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
							</cfquery>
							<p><cfif len(get_emp_pos.title_id)>#get_title.title#</cfif> / #position.position_name#</p>
							<p><cfif attributes.department_id neq 0 and isdefined('get_company.company_name') and len(get_company.company_name)>#get_company.company_name#</cfif> - 
								<cfif attributes.department_id neq 0>#get_location.zone_name#</cfif> / <cfif attributes.department_id neq 0>#get_location.branch_name#</cfif> -
								<cfif attributes.department_id neq 0>#get_location.department_head#</cfif>
							</p>	
							
							<cfif not isdefined('attributes.draggable')>
								<div class="who_item_detail_btn">
								
									<a href="javascript://"><i class="fa fa-phone"></i> <cf_santral tel="#detail_emp.direct_telcode##detail_emp.direct_tel#" is_iframe="#iif(isdefined('attributes.webphone'),1,0)#"></cf_santral></a>									
									<a href="javascript://"><i class="fa icon-phone"></i> <cf_santral mobil="#detail_emp.mobilcode##detail_emp.mobiltel#" is_iframe="#iif(isdefined('attributes.webphone'),1,0)#"></cf_santral></a>
									<cfif Len(detail_emp.employee_email) and xml_mail eq 1>
										<a href="mailto:#detail_emp.employee_email#"><i class="fa icon-envelope-o"></i></a>
									</cfif>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_form_add_warning&employee_id=#attributes.emp_id#')"><i class="catalyst-share"></i></a>
									
								</div>
							</cfif>	
							<div class="who_item_detail_agenda">
								<a href="#request.self#?fuseaction=agenda.view_daily&event=det&emp_id=#attributes.emp_id#">
								<i class="fa fa-calendar"></i> <cf_get_lang dictionary_id='63035.Ajandamı incelemek için tıklayın'>.
								</a>
							</div>				
						</div>
						<div class="who_item_detail_right">
							<label>Rating</label>
							<div class="who_item_detail_svg">
								<div class="who_item_detail_svg_icon">
									<img src="css/assets/icons/catalyst-icon-svg/einstein.svg" width="50px" height="80px"><span>4.4</span>
								</div>
								<div class="who_item_detail_svg_icon">
									<img src="css/assets/icons/catalyst-icon-svg/BruceLee.svg" width="50px" height="80px"><span class="brcle">5.0</span>	
								</div>												
							</div>
						</div>
					</div>
					<div class="who_item_detail_certificate">
						<div class="who_item_detail_certificate_head">
							<cf_get_lang dictionary_id='62019.Sertifikalarım'>
						</div>
						<div class="who_item_detail_certificate_certificates">
							<cfquery name="GET_CERTIFICATES" datasource="#DSN#">
								SELECT EMPLOYEE_ID,CERTIFICATE_NAME
								FROM SETTINGS_CERTIFICATE SC 
								LEFT JOIN TRAINING_CERTIFICATE TC ON SC.CERTIFICATE_ID = TC.CERTIFICATE_ID 
								WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
							</cfquery>
							<cfloop query="GET_CERTIFICATES">
							<span>#GET_CERTIFICATES.CERTIFICATE_NAME#</span>
							</cfloop>
						</div>						
					</div>
					<div class="who_item_detail_about">
						<cfquery name="GET_RESUME_TEXT" datasource="#DSN#">
							SELECT RESUME_TEXT 
							FROM EMPLOYEES_APP 
							
							WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfquery>
						<cfif attributes.emp_id eq session.ep.userid>
							<div class="who_item_detail_about_head">
							<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=rule.add_cv&emp_id=#attributes.emp_id#</cfoutput>')"><i class="fa fa-pencil"></i></a>
							</div>
						</cfif>
						<div class="who_item_detail_about_head">
							<cf_get_lang dictionary_id='62022.Hakkımda'>
						</div>
						
						<cfif len(GET_RESUME_TEXT.RESUME_TEXT)>
						<div class="who_item_detail_about_content">						
							#GET_RESUME_TEXT.RESUME_TEXT#
						</div>
						<!--- <div class="who_item_detail_about_more">
							<i class="fa fa-angle-down"> Devamını Oku</i>
						</div> --->
						</cfif>
					</div>
					<div class="who_item_detail_busy">
						<!--- Projects --->
						<cfquery name="EMP_PROJECT_COUNT" datasource="#DSN#">
							SELECT 
								PROJECT_EMP_ID,PROJECT_STATUS								 
							FROM 
								PRO_PROJECTS 
							WHERE
								PROJECT_STATUS = 1 AND PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfquery>												
						<!--- Works --->					
						<cfquery name="EMP_WORK_COUNT" datasource="#DSN#">
							SELECT PROJECT_EMP_ID,WORK_STATUS,ESTIMATED_TIME FROM PRO_WORKS WHERE WORK_STATUS = 1 AND PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfquery>
						<cfquery name="EMP_WORK_BUSY_ESTIMATED" datasource="#DSN#">
							SELECT 
								SUM(ESTIMATED_TIME) AS WORK_BUSY 
							FROM 
								PRO_WORKS 
							WHERE 
								WORK_STATUS = 1 AND PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfquery>
						<cfquery name="EMP_WORK_BUSY_SPENT" datasource="#DSN#">
							SELECT 
								SUM(TOTAL_TIME_HOUR) AS TOTAL_WORK_HOUR,
								SUM(TOTAL_TIME_MINUTE) AS TOTAL_WORK_MINUTE 
							FROM 
								PRO_WORKS_HISTORY 
							WHERE 	
								WORK_STATUS = 1 AND PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfquery>
						<!--- Calls --->
						<cfquery name="EMP_CALL_COUNT" datasource="#DSN#">
							SELECT RESP_EMP_ID,SERVICE_ACTIVE FROM G_SERVICE WHERE SERVICE_ACTIVE = 1 AND RESP_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfquery>
						<!--- Services --->
						<cfquery name="EMP_SERVICE_COUNT" datasource="#DSN3#">
							SELECT SERVICE_EMPLOYEE_ID,SERVICE_ACTIVE FROM SERVICE WHERE SERVICE_ACTIVE = 1 AND SERVICE_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfquery>
						<!--- Opportunities --->
						<cfquery name="EMP_OPP_COUNT" datasource="#DSN3#">
							SELECT SALES_EMP_ID,OPP_STATUS FROM OPPORTUNITIES WHERE OPP_STATUS = 1 AND SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
						</cfquery>
						<!--- Events --->
						<cfquery name="EMP_EVENT_COUNT" datasource="#DSN#">
							SELECT STARTDATE,EVENT_TO_POS FROM EVENT WHERE FINISHDATE >= #DATEADD('h',session.ep.time_zone-3,now())# AND EVENT_TO_POS LIKE '%,#attributes.emp_id#,%'
						</cfquery>
						<cfquery name="EMP_EVENT_BUSY" datasource="#DSN#">
							SELECT 
								EVENT_BUSY = SUM(DATEDIFF(MINUTE, STARTDATE, FINISHDATE)) 
							FROM 
								EVENT 
							WHERE STARTDATE >= #DATEADD('h',session.ep.time_zone-3,now())# AND FINISHDATE >= #DATEADD('h',session.ep.time_zone-3,now())# AND EVENT_TO_POS LIKE '%,#attributes.emp_id#,%'
						</cfquery>											
						<div class="who_item_detail_busy_head">
							<cfif len(EMP_WORK_BUSY_ESTIMATED.WORK_BUSY) and len(EMP_WORK_BUSY_SPENT.TOTAL_WORK_HOUR) and len(EMP_WORK_BUSY_SPENT.TOTAL_WORK_MINUTE)>
								<cfset w_busy_est = EMP_WORK_BUSY_ESTIMATED.WORK_BUSY>
								<cfset w_busy_spent = (EMP_WORK_BUSY_SPENT.TOTAL_WORK_HOUR * 60) + (EMP_WORK_BUSY_SPENT.TOTAL_WORK_MINUTE)> 
								<cfset w_busy_result = w_busy_est - w_busy_spent>
							<cfelse>
								<cfset w_busy_est = 0>
								<cfset w_busy_spent = 0> 
								<cfset w_busy_result = 0>
							</cfif>
							
							<cfif len(EMP_EVENT_BUSY.EVENT_BUSY)>
								<cfset e_busy = EMP_EVENT_BUSY.EVENT_BUSY>
							<cfelse>
								<cfset e_busy = 0>
							</cfif>	

							<cfset total_busy_m = w_busy_result + e_busy>
							<cfset busy_h = total_busy_m / 60>
							<cfset busy_m = total_busy_m % 60>
							<cf_get_lang dictionary_id='63036.Yoğunluk'>: <span><cfscript>writeOutput(Numberformat(floor(Abs(busy_h)),00));</cfscript> <cf_get_lang dictionary_id='57491.Saat'> <cfscript>writeOutput(Numberformat(Abs(busy_m),00))</cfscript> <cf_get_lang dictionary_id='58827.Dk'></span>							
						</div>
						<div class="who_item_detail_circle">
							<div class="who_item_detail_circle_item">								
								<p><cf_get_lang dictionary_id='57416.Proje'></p> <p>#EMP_PROJECT_COUNT.recordCount#</p>
							</div>
							<div class="who_item_detail_circle_item">								
								<p><cf_get_lang dictionary_id='58445.İş'></p> <p>#EMP_WORK_COUNT.recordCount#</p>
							</div>								
							<div class="who_item_detail_circle_item">								
								<p><cf_get_lang dictionary_id='62263.Çağrı'></p> <p>#EMP_CALL_COUNT.recordCount#</p>
							</div>								
							<div class="who_item_detail_circle_item">															
								<p><cf_get_lang dictionary_id='57656.Servis'></p> <p>#EMP_SERVICE_COUNT.recordCount#</p>
							</div>								
							<div class="who_item_detail_circle_item">									
								<p><cf_get_lang dictionary_id='57612.Fırsat'></p> <p>#EMP_OPP_COUNT.recordCount#</p>
							</div>								
							<div class="who_item_detail_circle_item">							
								<p><cf_get_lang dictionary_id='31065.Toplantı'></p> <p>#EMP_EVENT_COUNT.recordCount#</p>
							</div>								
						</div>
					</div>

					<div class="who_item_detail_busy">
						<div class="who_item_detail_busy_head">
							<cf_get_lang dictionary_id='58045.İçerikler'>
						</div>
						<div class="who_item_detail_circle">
							<div class="who_item_detail_circle_item">
								<cfquery name="EMP_WIKI_COUNT" datasource="#DSN#">
									SELECT C.OUTHOR_EMP_ID FROM CONTENT C 
									LEFT JOIN CONTENT_CHAPTER CC ON C.CHAPTER_ID = CC.CHAPTER_ID 
									LEFT JOIN CONTENT_CAT CCAT ON  CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID
									WHERE C.CONTENT_STATUS = 1 AND CCAT.CONTENTCAT_ID IN (<cfqueryparam value="#xml_wiki_cat_id#" cfsqltype="cf_sql_integer" list="true">)
									AND C.OUTHOR_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
                                    <cfif isdefined("xml_process_stage") and xml_process_stage eq 123>
									    AND C.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="123">
                                    <cfelseif isdefined("xml_process_stage") and xml_process_stage eq 122>
									    AND C.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="122">
                                    </cfif>
								</cfquery>
								<p><cf_get_lang dictionary_id='60721.Wiki'></p> <p>#EMP_WIKI_COUNT.recordCount#</p>
							</div>
							<div class="who_item_detail_circle_item">								
								<cfquery name="EMP_TIPS_COUNT" datasource="#DSN#">
									SELECT 									
										UPDATE_ID 
									FROM 
										HELP_DESK 
									WHERE 									
										UPDATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
								</cfquery>
								<cfquery name="EMP_TIPS_COUNT2" datasource="#DSN#">
									SELECT 									
										RECORD_ID 
									FROM 
										HELP_DESK 
									WHERE 									
										RECORD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
								</cfquery>
								<cfif len(EMP_TIPS_COUNT.recordCount)>
									<p>Tips</p> <p>#EMP_TIPS_COUNT.recordCount#</p>
								<cfelse>
									<p>Tips</p> <p>#EMP_TIPS_COUNT2.recordCount#</p>
								</cfif>								
							</div>								
							<div class="who_item_detail_circle_item">
								<cfquery name="EMP_BLOG_COUNT" datasource="#DSN#">
									SELECT C.OUTHOR_EMP_ID FROM CONTENT C 
									LEFT JOIN CONTENT_CHAPTER CC ON C.CHAPTER_ID = CC.CHAPTER_ID 
									LEFT JOIN CONTENT_CAT CCAT ON  CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID
									WHERE C.CONTENT_STATUS = 1 AND CCAT.CONTENTCAT_ID IN (<cfqueryparam value="#xml_blog_cat_id#" cfsqltype="cf_sql_integer" list="true">)									
									AND C.OUTHOR_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
                                    <cfif isdefined("xml_process_stage") and xml_process_stage eq 123>
									    AND C.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="123">
                                    <cfelseif isdefined("xml_process_stage") and xml_process_stage eq 122>
									    AND C.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="122">
                                    </cfif>
								</cfquery>
								<p><cf_get_lang dictionary_id='62731.Blog'></p> <p>#EMP_BLOG_COUNT.recordCount#</p>
							</div>								
							<div class="who_item_detail_circle_item">
								<cfquery name="EMP_TOPIC_COUNT" datasource="#DSN#">
									SELECT RECORD_EMP FROM FORUM_TOPIC WHERE RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
								</cfquery>
								<cfquery name="EMP_REPLY_COUNT" datasource="#DSN#">
									SELECT RECORD_EMP FROM FORUM_REPLYS WHERE RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
								</cfquery>
								<p><cf_get_lang dictionary_id='57421.Forum'></p> <p><span title="<cf_get_lang dictionary_id='58820.Başlık'>">#EMP_TOPIC_COUNT.recordCount#</span>-<span title="<cf_get_lang dictionary_id='58654.Cevap'>">#EMP_REPLY_COUNT.recordCount#</span></p>
							</div>								
							<div class="who_item_detail_circle_item">
								<cfquery name="EMP_VIDEO_COUNT" datasource="#DSN#">
									SELECT 
										RECORD_EMP 
									FROM 
										ASSET 
									WHERE 
										(ASSET_FILE_NAME LIKE '%.mp4%' OR 
										ASSET_FILE_NAME LIKE '%.mpeg%' OR 
										ASSET_FILE_NAME LIKE '%.avi%' OR 
										ASSET_FILE_NAME LIKE '%.flv%' OR
										ASSET_FILE_NAME LIKE '%.mkv%'OR 
										ASSET_FILE_NAME LIKE '%.3gp%' OR
										EMBEDCODE_URL LIKE '%youtu%'OR
										EMBEDCODE_URL LIKE '%loom%'OR										
										EMBEDCODE_URL LIKE '%dailymotion%')										
										AND	RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
								</cfquery>
								<p><cf_get_lang dictionary_id='46931.Video'></p> <p>#EMP_VIDEO_COUNT.recordCount#</p>
							</div>																					
						</div>
					</div>
					
				</div>			 
				<!---
					<div class="row overview">
						<div class="col col-12 user-pad text-center">
							<h4 class="white"><span class="bold"><cf_get_lang dictionary_id='32836.Pozisyonlar'></span>
							<cfloop query="get_emp_all_pos">						
							#position_name#,  	
							</cfloop>
							</h4>
							<cfif attributes.department_id neq 0>	
								<cfinclude template="workgroup_emp.cfm">
							</cfif>               		
						</div>
					</div> 
				--->				
			</cfoutput>
		</cf_box>
	</div>
		
	<script>
		var myColors = [
    	'#ffdb5c', '#68e2bb', '#8ecfff', '#efb8b8', '#d2a6c9', '#b3ced2','#d2a6c9','#ffe485','#9dd6ff' ,'#65e2ba' ,'#fcc675'
		];
		var i = 0;
		$('.who_item_detail_circle_item').each(function() {
			$(this).css('background-color', myColors[i]);
			i = (i + 1) % myColors.length;
		});
	</script>

<script>
	var myColors = [
	'#ffdb5c', '#68e2bb', '#8ecfff', '#efb8b8', '#d2a6c9', '#b3ced2','#d2a6c9','#ffe485','#9dd6ff' ,'#65e2ba' ,'#fcc675'
	];
	var i = 0;
	$('.who_item_detail_certificate_certificates span').each(function() {
		$(this).css('background-color', myColors[i]);
		i = (i + 1) % myColors.length;
	});
</script>
