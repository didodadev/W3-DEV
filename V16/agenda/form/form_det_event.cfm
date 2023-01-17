<meta charset='utf-8' />
<link href='css/assets/template/fullCalendar/fullcalendar.css' rel='stylesheet' />
<link href='css/assets/template/fullCalendar/fullcalendar.print.min.css' rel='stylesheet' media='print' />
<script src='JS/fullCalendar/moment.min.js'></script>
<script src='JS/fullCalendar/fullcalendar.js'></script>
<cfset agenda_lang = session.ep.language>
<cfif agenda_lang neq 'eng' and timeformat_style neq 'h:mm tt'>
	<script src='JS/fullCalendar/<cfoutput>#agenda_lang#</cfoutput>.js'></script>
</cfif>
<cfset value_is_sales = 1>
<cfset attributes.to_day = CreateDate(year(now()),month(now()), day(now()))>
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.action_section" default="">


<cfinclude template="../query/get_emp_events.cfm">

<cfif isDefined("attributes.emp_id")>
    <cfinclude template="../../objects/query/get_emp_det.cfm">
    <cfinclude template="../../objects/query/get_emp.cfm">
</cfif>
<cfif isDefined("attributes.par_id")>
    <cfinclude template="../../objects/query/get_par_det.cfm">
</cfif>
<cfif isDefined("attributes.con_id")>
    <cfinclude template="../../objects/query/get_con_det.cfm">
</cfif>


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
    border: 1px solid #5C6BC0;
    border-radius: 3px;
    z-index: 1;
    box-shadow: none !important;
    outline: none;
    padding: 6px;
    -webkit-transition: all ease .3s;
    -moz-transition: all ease .3s;
    -ms-transition: all ease .3s;
    -o-transition: all ease .3s;
    transition: all ease .3s;
	}
	.fc-toolbar .iconic{
		color: #fff;
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
			color: #f5393d;
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
		border: 1px solid #ddd;
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

    .emp_name_info{
        font-size:22px;
        color:#E08283;
        font-weight:bold;
    }
</style>
<body>
	<cf_box>
		<div id='calendar'></div>
	</cf_box>
</body>
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
			events: [
                    <cfif isDefined("attributes.emp_id")>
                        <cfoutput query="EMP_EVENTS"> 
                            {
                                id: #ID#,
                                title: '#Replace(name,"'","\'","all")#',
                                start: '#DateFormat(target_start, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,target_start),"HH:mm:ss")#',
                                end: '#DateFormat(target_finish, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,target_finish),"HH:mm:ss")#'							
                                
                            },
                        </cfoutput>
				    </cfif>
                    <cfif isDefined("attributes.par_id")>
                        <cfoutput query="PAR_EVENTS"> 
                            {
                                id: #ID#,
                                title: '#Replace(name,"'","\'","all")#',
                                start: '#DateFormat(target_start, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,target_start),"HH:mm:ss")#',
                                end: '#DateFormat(target_finish, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,target_finish),"HH:mm:ss")#'					
                               
                            },
                        </cfoutput>
				    </cfif>
                    <cfif isDefined("attributes.con_id")>
                        <cfoutput query="CONS_EVENT"> 
                            {
                                id: #ID#,
                                title: '#Replace(name,"'","\'","all")#',
                                start: '#DateFormat(target_start, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,target_start),"HH:mm:ss")#',
                                end: '#DateFormat(target_finish, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,target_finish),"HH:mm:ss")#'					
                               
                            },
                        </cfoutput>
				    </cfif>							
			],
				editable: false,
				eventClick: function(event) {
					if (event.url2) {
					openBoxDraggable(event.url2);
					return false;
					}
				 	if (event.url3) {
					windowopen(event.url3);
					return false;
					} 
					if (event.url4) {
						window.open(event.url4);
						return false;
					} 
					if (event.url5) {
						window.open(event.url5);
						return false;
					} 
					if (event.url6) {
						window.open(event.url6);
						return false;
					} 
				},
				
				
		});
	

	$("<div>")	
        <cfif isDefined("attributes.emp_id") and len(attributes.emp_id)>
            .append(
                    $('<span>')
                    .addClass('emp_name_info')
                    .attr({							
                        title		:'<cfoutput>#detail_emp.employee_name# #detail_emp.employee_surname#</cfoutput>'})
                        .text("<cfoutput>#detail_emp.employee_name# #detail_emp.employee_surname#</cfoutput>")	)
                    .prependTo("div.fc-left");
        </cfif>
        <cfif isDefined("attributes.par_id") and len(attributes.par_id)>
            .append(
                    $('<span>')
                    .addClass('emp_name_info')
                    .attr({							
                        title		:'<cfoutput>#DETAIL_PAR.COMPANY_PARTNER_NAME# #DETAIL_PAR.COMPANY_PARTNER_SURNAME#</cfoutput>'})
                        .text("<cfoutput>#DETAIL_PAR.COMPANY_PARTNER_NAME# #DETAIL_PAR.COMPANY_PARTNER_SURNAME#</cfoutput>")	)
                    .prependTo("div.fc-left");
        </cfif>
        <cfif isDefined("attributes.con_id") and len(attributes.con_id)>
            .append(
                    $('<span>')
                    .addClass('emp_name_info')
                    .attr({							
                        title		:'<cfoutput>#DETAIL_CON.CONSUMER_NAME# #DETAIL_CON.CONSUMER_SURNAME#</cfoutput>'})
                        .text("<cfoutput>#DETAIL_CON.CONSUMER_NAME# #DETAIL_CON.CONSUMER_SURNAME#</cfoutput>")	)
                    .prependTo("div.fc-left");
        </cfif>

		$('<span>').addClass('fa fa-chevron-left calendar-np-buttons').attr("onClick","$('#calendar').fullCalendar('prev');").prependTo("div.fc-center");
		$('<span>').addClass('fa fa-chevron-right calendar-np-buttons').attr("onClick","$('#calendar').fullCalendar('next');").appendTo("div.fc-center");

		$("<div>")
		.addClass('calendar-icon-content')
		.append(
			$('<span>')
				.addClass('iconic fa fa-calendar-o color-R')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView','agendaDay');",
					title		:"<cfoutput>#getlang('','Bugün','58457')#</cfoutput>"
				})
				.append('<i><cfoutput>#Day(NOW())#</cfoutput></i>')	
		)
		.append(
			$('<span>')
				.addClass('iconic fa fa-calendar color-I')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'month');",
					title		:"<cfoutput>#getlang('','Aylık','58932')#</cfoutput>"
					
					})	
		)
		.append(
			$('<span>')
				.addClass('iconic fa fa-columns color-I')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'agendaWeek');",
					title		:"<cfoutput>#getlang('','Haftalık','58458')#</cfoutput>"
					})	
		)
		.append(
			$('<span>')
				.addClass('iconic fa fa-list-ul color-I')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'listWeek');",
					title		:"<cfoutput>#getlang('','Haftalık','58458')# #getlang('','Liste','57509')#</cfoutput>"
				})	
		)
		.prependTo("div.fc-right");

  });
</script>
