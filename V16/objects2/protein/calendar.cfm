<cfset agenda_lang = session.pp.language>
<cfif agenda_lang neq 'eng' and timeformat_style neq 'h:mm tt'>    
	<script src='/src/assets/js/fullcalendar/<cfoutput>#agenda_lang#</cfoutput>.js'></script>
</cfif>

<cfset value_is_sales = 1>
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.action_section" default="">
<!---<cfinclude template="../query/get_all_agenda_department_branch.cfm">
<cfinclude template="../query/view_daily.cfm">
<cfinclude template="../query/get_all_agenda.cfm"><!--- Egitimler ve ziyaretler--->
<cfinclude template="../../agenda/query/get_daily_warning.cfm"><!--- Uyarilar (Ajanda ve Uyari) --->
--->
 <style>
	body {
    background: #f4f7f9 !important;
	}
	.calendar-icon-content {
    display: block;
    float: left;
    margin-bottom: 7px;
	}
	
	.calendar-search{
    float: right;
    margin-top: -0.7px;
	}
	.calendar-search .iconic{
    z-index: 99;
    position: relative;
	}
	input.calender-search-input.s-input-off {
    width: 0px;
    margin: 0px -12px 0px 0px;
	}
	.calender-search-input{
    margin: 0px -3px 0 0;    
    width: 180px;
    top: 1px;
    left: 5px;
    position: relative;
    border: 1px solid #3dd598;
    border-radius: 3px;
    z-index: 1;
    box-shadow: none !important;
    outline: none;
    padding: 2px 6px;
    -webkit-transition: all ease .3s;
    -moz-transition: all ease .3s;
    -ms-transition: all ease .3s;
    -o-transition: all ease .3s;
    transition: all ease .3s;
	}
	.fc-toolbar .iconic{
    color: #fff;
    /* background-color:#5C6BC0; */
    border-radius: 3px;
    font-size: 17px;
    height: 29px;
    width: 29px;
    display: inline-block;
    line-height: 29px;
    text-align: center;
    vertical-align: middle;
    margin-right: 5px;
    font-weight: 100;
    cursor:pointer;
    position: relative;
	}

	.fc-toolbar .iconic:last-child {
    margin-right:0px
	}

	.iconic i {
    top: 2.5px;
    left: 9.4px;
    font-size: 9px;
    position: absolute;
    font-weight: bold;
    font-style: normal;
    font-family: monospace;
	}

	.fc-center h2 {
    margin: 0 20px !important;
    text-align: center;
    color: #e38283;
    font-size: 1.5em;
	}

	.fc-center .calendar-np-buttons {
    margin: 0 !important;
    font-size: 20px;
    display: block;
    top: 6px;
    position: relative;
    color: #BDBDBD;
    cursor: pointer;
	}

	.fc-center .calendar-np-buttons:hover {
    color: #828181;
	}

	.fc-toolbar.fc-header-toolbar {
    background: white;
    padding: 18px 10px 10px 10px;
    margin: -10px -10px 35px -10px;
		}
	.fc-day-number {
    font-size: 14px;
    font-weight: bold;
    padding: 4px 4px !important;
    margin-bottom: -5px;
	}
	.fc-title, .fc-time{
    color:black;
	}
	.fc-bg {
    background: white;
	}

	th.fc-day-header.fc-widget-header {
    font-size: 15px;
    padding: 5px 0px;
	}

	.fc-unthemed td.fc-today {
    background: #FFEBEE;
	}

	.fc-view-container {
    border: none;
	}

	.fc-row.fc-widget-header {
    background: #f5f5f5;
	}

	.fc-text-group {
    margin-right: 10px !important;   
    margin-left: 10px !important;
	}

	.fc-text-group form {
    float: left;
	}

	.fc-view.fc-listWeek-view.fc-list-view.fc-widget-content {
    background: #FFF;
	}

	.fc-row.fc-widget-header th {
    /* color: black; */
	}      
    
    thead tr th{
	background-color:#fff;             
    }
    
    .fc th{
	border:none;
    }

    .fc td{
    border: 2px dashed #eaeaec;    
    }   
   
    td.fc-head-container.fc-widget-header{
    border-top: 0;        
    }   

    .fc tr td:first-child {
    border-left: 0;
    }

    .fc tr:last-child td {
    border-bottom: 0;
    }

    .fc tr td:last-child {
    border-right: 0;
    } 
</style>	
	
<div id='calendar'></div>	

<script>
  $(document).ready(function() {

		$('#calendar').fullCalendar({
			header: {
				left: '',
				center: 'title',
				right: ''
			},
				navLinks: true, // can click day/week names to navigate views
				eventLimit: true, // allow "more" link when too many events
			<!---events: [
				<cfif isdefined('attributes.action_id') and len(attributes.action_id)>
					<cfoutput query="GET_RELATED_EVENTS"> 
						{
							id: #event_id#,
							title: '#Replace(EVENT_HEAD,"'","\'","all")#',
							start: '#DateFormat(STARTDATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,STARTDATE),"HH:mm:ss")#',
							end: '#DateFormat(FINISHDATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,FINISHDATE),"HH:mm:ss")#',
							color: '#COLOUR#',
							url : '#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#EVENT_ID#'
						},
					</cfoutput>
				<cfelse>
					<cfoutput query="getQueryAgenda"> 
						{
							id: #event_id#,
							title: '#Replace(EVENT_HEAD,"'","\'","all")#',
							start: '#DateFormat(STARTDATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,STARTDATE),"HH:mm:ss")#',
							end: '#DateFormat(FINISHDATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,FINISHDATE),"HH:mm:ss")#',
							color: '#COLOUR#',
							url : '#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#EVENT_ID#'
						},
					</cfoutput>
					<cfoutput query="get_all_agenda"> 
						{
							id1: #class_id#,
							title: '#Replace(CLASS_NAME,"'","\'","all")#'+'(Eğitim)',
							start: '#DateFormat(START_DATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,START_DATE),"HH:mm:ss")#',
							end: '#DateFormat(FINISH_DATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,FINISH_DATE),"HH:mm:ss")#',
							color: '##6699cc',
							url : '#request.self#?fuseaction=training.view_class&class_id=#class_id#'
						},
					</cfoutput>
					<cfoutput query="get_plan_rows"> 
						{
							id2: #EVENT_PLAN_ID#,
							title: '#Replace(EVENT_PLAN_HEAD,"'","\'","all")#'+'(Ziyaret)',
							start: '#DateFormat(START_DATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,START_DATE),"HH:mm:ss")#',
							end: '#DateFormat(FINISH_DATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,FINISH_DATE),"HH:mm:ss")#',
							color: '##5b9aa0',
							url2:'#request.self#?fuseaction=objects.event_plan_result&event=upd&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#member_id#&result_id=#value_is_sales#'		    
						},
					</cfoutput>
					<cfoutput query="GET_DAILY_WARNINGS">	
						<cfif type neq 1>
							<cfset parent_id_ = contentEncryptingandDecodingAES(isEncode:1,content:#GET_DAILY_WARNINGS.parent_event_id#,accountKey:'wrk')>
							<cfset event_id_ = contentEncryptingandDecodingAES(isEncode:1,content:#GET_DAILY_WARNINGS.event_id#,accountKey:'wrk')> 
							{ 
								id3: #event_id#,
								title: '#Replace(event_head,"'","\'","all")#'+'(Uyarı)',
								start: '#DateFormat(WARNING_START, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,WARNING_START),"HH:mm:ss")#',
								end: '#DateFormat(WARNING_START, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,WARNING_START),"HH:mm:ss")#',
								color: '##FF4500',
								url3:'#request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=#parent_id_#&warning_is_active=0&sub_warning_id=#event_id_#'	
							},
						</cfif>
					</cfoutput> 
				</cfif>					
			],--->
				editable: true,
				eventClick: function(event) {
					if (event.url2) {
					openBoxDraggable(event.url2);
					return false;
					}
				 	if (event.url3) {
					windowopen(event.url3);
					return false;
					} 
				},
				eventDrop: function(event, delta, revertFunc) {
					if (!confirm("<cfoutput>#getlang('main',124,'güncellemek istediğinize emin misiniz?')#</cfoutput>")) 
								{
										revertFunc();
								}
								else
								{
						if(event.id){
							var str_begin = event.start.format().toString();
							var split_begin_data = str_begin.split('-');
							var begin_hour_split = split_begin_data[2].split('T');
							var begin_hour_split_ = begin_hour_split[1].split(':');
							var start_year = split_begin_data[0];
							var start_month = split_begin_data[1];
							var start_day = begin_hour_split[0];
							var start_hour = begin_hour_split_[0];
							var start_minute = begin_hour_split_[1];

							var str =  event.end.format().toString();
							var split_data = str.split('-');
							var hour_split = split_data[2].split('T');
							var hour_split_ = hour_split[1].split(':');
							var year = split_data[0];
							var month = split_data[1];
							var day = hour_split[0];
							var hour = hour_split_[0];
							var minute = hour_split_[1];

							$.ajax({ 
								type:'POST',  
								url:'V16/agenda/query/upd_drag_drop.cfc?method=get_daily',
								data: {
									event_id : event.id,
									start_year :start_year,
									start_month : start_month,
									start_day : start_day,
									start_hour : start_hour,
									start_minute : start_minute,
									year :  year,
									month : month,
									day : day,
									hour : hour,
									minute : minute

								},
								success: function (returnData) {  
									console.log('Saat değiştirildi..');  
								},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							});
						}else if(event.id1){
							var str_begin = event.start.format().toString();
							var split_begin_data = str_begin.split('-');
							var begin_hour_split = split_begin_data[2].split('T');
							var begin_hour_split_ = begin_hour_split[1].split(':');
							var start_year = split_begin_data[0];
							var start_month = split_begin_data[1];
							var start_day = begin_hour_split[0];
							var start_hour = begin_hour_split_[0];
							var start_minute = begin_hour_split_[1];

							var str =  event.end.format().toString();
							var split_data = str.split('-');
							var hour_split = split_data[2].split('T');
							var hour_split_ = hour_split[1].split(':');
							var year = split_data[0];
							var month = split_data[1];
							var day = hour_split[0];
							var hour = hour_split_[0];
							var minute = hour_split_[1];

							$.ajax({ 
								type:'POST',  
								url:'V16/agenda/query/upd_drag_drop.cfc?method=get_daily',
								data: {
									class_id : event.id1,
									start_year :start_year,
									start_month : start_month,
									start_day : start_day,
									start_hour : start_hour,
									start_minute : start_minute,
									year :  year,
									month : month,
									day : day,
									hour : hour,
									minute : minute

								},
								success: function (returnData) {  
									console.log('Saat değiştirildi(eğitim)..');  
								},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							});
						}else if(event.id2){
							var str_begin = event.start.format().toString();
							var split_begin_data = str_begin.split('-');
							var begin_hour_split = split_begin_data[2].split('T');
							var begin_hour_split_ = begin_hour_split[1].split(':');
							var start_year = split_begin_data[0];
							var start_month = split_begin_data[1];
							var start_day = begin_hour_split[0];
							var start_hour = begin_hour_split_[0];
							var start_minute = begin_hour_split_[1];

							var str =  event.end.format().toString();
							var split_data = str.split('-');
							var hour_split = split_data[2].split('T');
							var hour_split_ = hour_split[1].split(':');
							var year = split_data[0];
							var month = split_data[1];
							var day = hour_split[0];
							var hour = hour_split_[0];
							var minute = hour_split_[1];

							$.ajax({ 
								type:'POST',  
								url:'V16/agenda/query/upd_drag_drop.cfc?method=get_daily',
								data: {
									event_plan_id : event.id2,
									start_year :start_year,
									start_month : start_month,
									start_day : start_day,
									start_hour : start_hour,
									start_minute : start_minute,
									year :  year,
									month : month,
									day : day,
									hour : hour,
									minute : minute

								},
								success: function (returnData) {  
									console.log('Saat değiştirildi(ziyaret)..');  
								},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							});
						}else if(event.id3){
							var str_begin = event.start.format().toString();
							var split_begin_data = str_begin.split('-');
							var begin_hour_split = split_begin_data[2].split('T');
							var begin_hour_split_ = begin_hour_split[1].split(':');
							var start_year = split_begin_data[0];
							var start_month = split_begin_data[1];
							var start_day = begin_hour_split[0];
							var start_hour = begin_hour_split_[0];
							var start_minute = begin_hour_split_[1];

							
							$.ajax({
								type:'POST',  
								url:'V16/agenda/query/upd_drag_drop.cfc?method=get_daily',
								data: {
									event_id3 : event.id3,
									start_year :start_year,
									start_month : start_month,
									start_day : start_day,
									start_hour : start_hour,
									start_minute : start_minute
								

								},
								success: function (returnData) {  
									console.log('Saat değiştirildi(ziyaret)..');  
								},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							}); 
						}
					}
				},
				eventResize: function(event, delta, revertFunc) {
					if(event.id){
						var str_begin = event.start.format().toString();
						var split_begin_data = str_begin.split('-');
						var begin_hour_split = split_begin_data[2].split('T');
						var begin_hour_split_ = begin_hour_split[1].split(':');
						var start_year = split_begin_data[0];
						var start_month = split_begin_data[1];
						var start_day = begin_hour_split[0];
						var start_hour = begin_hour_split_[0];
						var start_minute = begin_hour_split_[1];

						var str =  event.end.format().toString();
						var split_data = str.split('-');
						var hour_split = split_data[2].split('T');
						var hour_split_ = hour_split[1].split(':');
						var year = split_data[0];
						var month = split_data[1];
						var day = hour_split[0];
						var hour = hour_split_[0];
						var minute = hour_split_[1];

						$.ajax({ 
								type:'POST',  
								url:'V16/agenda/query/upd_drag_drop.cfc?method=get_daily',
								data: {
									event_id : event.id,
									start_year :start_year,
									start_month : start_month,
									start_day : start_day,
									start_hour : start_hour,
									start_minute : start_minute,
									year :  year,
									month : month,
									day : day,
									hour : hour,
									minute : minute

								},
								success: function (returnData) {  
									console.log('Saat değiştirildi..');  
								},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							});
					}else if(event.id1){
						var str_begin = event.start.format().toString();
						var split_begin_data = str_begin.split('-');
						var begin_hour_split = split_begin_data[2].split('T');
						var begin_hour_split_ = begin_hour_split[1].split(':');
						var start_year = split_begin_data[0];
						var start_month = split_begin_data[1];
						var start_day = begin_hour_split[0];
						var start_hour = begin_hour_split_[0];
						var start_minute = begin_hour_split_[1];

						var str =  event.end.format().toString();
						var split_data = str.split('-');
						var hour_split = split_data[2].split('T');
						var hour_split_ = hour_split[1].split(':');
						var year = split_data[0];
						var month = split_data[1];
						var day = hour_split[0];
						var hour = hour_split_[0];
						var minute = hour_split_[1];

						$.ajax({ 
								type:'POST',  
								url:'V16/agenda/query/upd_drag_drop.cfc?method=get_daily',
								data: {
									class_id : event.id1,
									start_year :start_year,
									start_month : start_month,
									start_day : start_day,
									start_hour : start_hour,
									start_minute : start_minute,
									year :  year,
									month : month,
									day : day,
									hour : hour,
									minute : minute
								},
								success: function (returnData) {  
									console.log('Saat değiştirildi(ziyaret)..');  
								},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							});
					}
					else if(event.id2){
						var str_begin = event.start.format().toString();
						var split_begin_data = str_begin.split('-');
						var begin_hour_split = split_begin_data[2].split('T');
						var begin_hour_split_ = begin_hour_split[1].split(':');
						var start_year = split_begin_data[0];
						var start_month = split_begin_data[1];
						var start_day = begin_hour_split[0];
						var start_hour = begin_hour_split_[0];
						var start_minute = begin_hour_split_[1];

						var str =  event.end.format().toString();
						var split_data = str.split('-');
						var hour_split = split_data[2].split('T');
						var hour_split_ = hour_split[1].split(':');
						var year = split_data[0];
						var month = split_data[1];
						var day = hour_split[0];
						var hour = hour_split_[0];
						var minute = hour_split_[1];

						$.ajax({ 
								type:'POST',  
								url:'V16/agenda/query/upd_drag_drop.cfc?method=get_daily',
								data: {
									event_plan_id : event.id2,
									start_year :start_year,
									start_month : start_month,
									start_day : start_day,
									start_hour : start_hour,
									start_minute : start_minute,
									year :  year,
									month : month,
									day : day,
									hour : hour,
									minute : minute
								},
								success: function (returnData) {  
									console.log('Saat değiştirildi(ziyaret)..');  
								},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							});
					}else if(event.id3){
						var str_begin = event.start.format().toString();
						var split_begin_data = str_begin.split('-');
						var begin_hour_split = split_begin_data[2].split('T');
						var begin_hour_split_ = begin_hour_split[1].split(':');
						var start_year = split_begin_data[0];
						var start_month = split_begin_data[1];
						var start_day = begin_hour_split[0];
						var start_hour = begin_hour_split_[0];
						var start_minute = begin_hour_split_[1];


						$.ajax({ 
								type:'POST',  
								url:'V16/agenda/query/upd_drag_drop.cfc?method=get_daily',
								data: {
									event_id3 : event.id3,
									start_year :start_year,
									start_month : start_month,
									start_day : start_day,
									start_hour : start_hour,
									start_minute : start_minute
								
								},
								success: function (returnData) {  
									console.log('Saat değiştirildi(ziyaret)..');  
								},
								error: function () 
								{
									console.log('CODE:8 please, try again..');
									return false; 
								}
							}); 
					}
				}
		});
	

	$("<div>")
		.addClass('calendar-icon-content')
		.append(
				$('<span>')
					.addClass('iconic fa fa-globe btn-color-2')
					.attr({
						onclick :'submit_agenda_daily(3)',
						title		:'<cfoutput>#getLang('agenda',81,'network')#</cfoutput>'})		
		).append(
				$('<span>')
					.addClass('iconic fa fa-building btn-color-3')
					.attr({
						onclick :'submit_agenda_daily(2)',
						title		:'<cfoutput>#getLang('agenda',78,'şube ajanda')#</cfoutput>'})		
		).append(
				$('<span>')
					.addClass('iconic fa fa-group btn-color-4')
					.attr({
						onclick :'submit_agenda_daily(1)',
						title		:'<cfoutput>#getLang('agenda',79,'departman ajanda')#</cfoutput>'})		
		).append(
				$('<span>')
					.addClass('iconic fa fa-user btn-color-5')
					.attr({
						onclick :'submit_agenda_daily(4)',
						title		:'<cfoutput>#getLang('agenda',80,'Bana özel ajanda')#</cfoutput>'})		
		)
		<cfif isdefined('attributes.action_id') and len(attributes.action_id)>
		.append(
				$('<span>')
					.addClass('iconic fa fa-calendar-plus-o btn-color-6')
					.attr({
						onclick :'location.href="<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=add&date=#dateFormat(now(),"dd.mm.yyyy")#</cfoutput>"'})
		)
		<cfelse>
		.append(
				$('<span>')
					.addClass('iconic fa fa-calendar-plus-o btn-color-6')
					.attr({
						onclick :'location.href="<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=add&date=#dateFormat(now(),"dd.mm.yyyy")#</cfoutput>"'})
		)
		</cfif>
		.append(
				$('<div>')
					.addClass('calendar-search')
					.append(
						$('<input>')
							.addClass('calender-search-input s-input-off')
							.attr({
								placeholder	:'<cfoutput>#getLang('agenda',71,'Arama')#</cfoutput>',
								onkeypress	:'return runSearch(event)'
							})
					)
					.append(
						$('<span>')
							.addClass('iconic fa fa-search btn-color-7')
							.attr({
								onclick :'submit_agenda_daily(5)',
								title		:'<cfoutput>#getLang('agenda',71,'Arama')#</cfoutput>'})	
					)						
		)
		.prependTo("div.fc-left");

		$('<span>').addClass('fa fa-chevron-left calendar-np-buttons').attr("onClick","$('#calendar').fullCalendar('prev');").prependTo("div.fc-center");
		$('<span>').addClass('fa fa-chevron-right calendar-np-buttons').attr("onClick","$('#calendar').fullCalendar('next');").appendTo("div.fc-center");

		$("<div>")
		.addClass('calendar-icon-content')
		.append(
			$('<span>')
				.addClass('iconic fa fa-calendar-o btn-color-5')
				.attr({
					onclick :"$('#calendar').fullCalendar('today');",
					title		:"<cfoutput>#getlang('main',530,'Bugün')#</cfoutput>"
				})
				.append('<i><cfoutput>#Day(NOW())#</cfoutput></i>')	
		)
		.append(
			$('<span>')
				.addClass('iconic fa fa-calendar btn-color-5')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'month');",
					title		:"<cfoutput>#getlang('main',1520,'Aylık')#</cfoutput>"
					
					})	
		)
		.append(
			$('<span>')
				.addClass('iconic fa fa-columns btn-color-5')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'agendaWeek');",
					title		:"<cfoutput>#getlang('main',1046,'Aylık')#</cfoutput>"
					})	
		)
		.append(
			$('<span>')
				.addClass('iconic fa fa-list-ul btn-color-5')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'listWeek');",
					title		:"<cfoutput>#getlang('main',97,'Liste')#</cfoutput>"
				})	
		)
		.prependTo("div.fc-right");

  });
</script>
<script>
	function add_event()
	{
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=add&date=#dateFormat(now(),"dd.mm.yyyy")#</cfoutput>';
	}
	function submit_agenda_daily(agenda_type)
	{
		if (agenda_type=='1')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_daily&view_agenda=1</cfoutput>';
		else if(agenda_type=='2')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_daily&view_agenda=2</cfoutput>';
		else if(agenda_type=='3')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_daily&view_agenda=3</cfoutput>';
		else if(agenda_type=='4')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_daily</cfoutput>';
		else if(agenda_type=='5'){
			if(!$('.calender-search-input').hasClass('s-input-off') && $('.calender-search-input').val().length == 0){
				$('.calender-search-input').addClass('s-input-off');
			}else if($('.calender-search-input').val().length){
				window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.view_daily&event=search&form_varmi=1&keyword='+$('.calender-search-input').val();
			}else{
				$('.calender-search-input').removeClass('s-input-off');
			}
		}
	}
	function runSearch(e) {
			if (e.keyCode == 13) {
				if($('.calender-search-input').val().length)
					window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.view_daily&event=search&form_varmi=1&keyword='+$('.calender-search-input').val();
				else
					window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=agenda.view_daily&event=search'
			}
	}
</script>