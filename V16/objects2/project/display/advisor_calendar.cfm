<cfset getComponent = createObject('component','V16.objects2.agenda.cfc.agenda_data')>
<cfset advisor_events = getComponent.PAR_EVENTS()>
<cfset employee_events = getComponent.EMP_EVENTS()>
<cfif isDefined("attributes.emp_id") and len(attributes.emp_id)>
    <cfset my_settings = getComponent.MY_SETTINGS()>
</cfif>
<cfset partner_info = getComponent.GET_PAR()>
<cfscript>
	CreateCompenent = createObject("component", "V16/project/cfc/projectData");
	get_projects = CreateCompenent.get_projects();
</cfscript>
<cfset agenda_lang = session.pp.language>
<cfif agenda_lang neq 'eng' and timeformat_style neq 'h:mm tt'>    
	<script src='/src/assets/js/fullcalendar/<cfoutput>#agenda_lang#</cfoutput>.js'></script>
</cfif>
<cfset value_is_sales = 1>
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>

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

	.calendar_head{
        font-size:20px;
        color: #e38283;
        text-decoration:none;
        font-weight:600;
    }	

    .calendar_head a{
        font-size:20px;
        color: #e38283;
        text-decoration:none;
        font-weight:600;
    }
	
</style>	

<cfoutput query="partner_info">
   <div class="calendar_head"><cfif isDefined("attributes.emp_id") and len(attributes.emp_id)>#get_emp_info(attributes.emp_id,0,0)#<cfelse>#get_par_info(partner_id,0,0,1)#</cfif></div>
</cfoutput>

<div id='calendar'></div>

<script>
  $(document).ready(function() {

		$('#calendar').fullCalendar({
			header: {
				left: 'time',
				center: 'title',
				right: ''
			},
            weekends: true,
            timeFormat: 'h:mm',
            displayEventEnd :true,
            axisFormat: 'hh:mma',
            firstDay: 1,
            slotMinutes: 15,
            defaultView: 'month',
            navLinks: true, // can click day/week names to navigate views
            eventLimit: true, // allow "more" link when too many events
            navLinkDayClick: function(date, jsEvent, view) {
                openBoxDraggable('widgetloader?widget_load=addEvent&isbox=1&style=maxi&emp_id=<cfif isDefined("attributes.emp_id") and len(attributes.emp_id)><cfoutput>#attributes.emp_id#</cfoutput></cfif>&date='+date.toISOString());
            },
			events: [
					<cfoutput query="advisor_events">
                        <cfif is_google_cal eq 1 and len(online_meet_link)>
                            <cfset advisor_cal_url = 'https://meet.google.com/'&'#online_meet_link#'>
                        <cfelse>
                            <cfset advisor_cal_url = '#cgi.HTTP_REFERER#'>
                        </cfif>
						{
							id: #event_id#,
							title: '#Replace(event_head,"'","\'","all")#',
							start: '#DateFormat(startdate, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.pp.time_zone,startdate),"HH:mm:ss")#',
							end: '#DateFormat(finishdate, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.pp.time_zone,finishdate),"HH:mm:ss")#',
							color: '#colour#',
                            url: '/eventDetail??event_id=#event_id#<cfif isDefined("attributes.emp_id") and len(attributes.emp_id)>&emp_id=#attributes.emp_id#</cfif>',
						},
					</cfoutput>
                    <cfif isdefined("my_settings") and my_settings.agenda eq 1>
                        <cfoutput query="employee_events">
                            {
                                id: #event_id#,
                                title: '#Replace(event_head,"'","\'","all")#',
                                start: '#DateFormat(startdate, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.pp.time_zone,startdate),"HH:mm:ss")#',
                                end: '#DateFormat(finishdate, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.pp.time_zone,finishdate),"HH:mm:ss")#',
                                color: '#colour#',
                                url: '/eventDetail??event_id=#event_id#<cfif isDefined("attributes.emp_id") and len(attributes.emp_id)>&emp_id=#attributes.emp_id#</cfif>',
                            },
                        </cfoutput>
                    </cfif>
                    <cfif get_projects.recordcount>
                        <cfoutput query="get_projects">
                            {
                                id: #project_id#,
                                <cfif (isDefined("attributes.emp_id") and len(attributes.emp_id)) and PROJECT_EMP_ID eq attributes.emp_id>
                                    title: '#Replace(project_head,"'","\'","all")#',
                                    url: '/projectDetail??id=#project_id#',
                                <cfelse>
                                    title: '#MAIN_PROCESS_CAT#',
                                </cfif>
                                start: '#DateFormat(target_start, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.pp.time_zone,target_start),"HH:mm:ss")#',
                                end: '#DateFormat(target_finish, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.pp.time_zone,target_finish),"HH:mm:ss")#',
                                color: '##22ff55',
                            },
                        </cfoutput>
                    </cfif>
			],
            editable: false,		
							
		});

        document.querySelectorAll('.fc-event').forEach(e => { // meet linki varsa yeni sayfada açmak için target ekliyor
            if( e.href.search('meet') != -1 ){
	            e.target = '_blank';
            }
        });

	$("<div>")
		
		.prependTo("div.fc-left");

		$('<span>').addClass('fa fa-chevron-left calendar-np-buttons').attr("onClick","$('#calendar').fullCalendar('prev');").prependTo("div.fc-center");
		$('<span>').addClass('fa fa-chevron-right calendar-np-buttons').attr("onClick","$('#calendar').fullCalendar('next');").appendTo("div.fc-center");

		$("<div>")
		.addClass('calendar-icon-content')
		.append(
			$('<span>')
				.addClass('iconic fa fa-calendar-plus-o btn-color-5')
				.attr({
					onclick :"openBoxDraggable('widgetloader?widget_load=addEvent&isbox=1&style=maxi<cfif isDefined("attributes.emp_id") and len(attributes.emp_id)>&emp_id=<cfoutput>#attributes.emp_id#</cfoutput></cfif>')",
					title		:"<cfoutput>#getlang('','Toplantı Talep Edin',62024)#</cfoutput>"
				})	
		)
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
				.addClass('iconic fa fa-list-ul btn-color-5')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'listWeek');",
					title		:"<cfoutput>#getlang('main',97,'Liste')#</cfoutput>"
				})	
		)
		.prependTo("div.fc-right");

  });
</script>