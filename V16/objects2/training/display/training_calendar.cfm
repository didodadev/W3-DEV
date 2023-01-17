<cfset getComponent = createObject('component','V16.objects2.agenda.cfc.agenda_data')>
<cfset events = getComponent.GET_TR(site : GET_PAGE.PROTEIN_SITE)>

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
    background-color:#e38283; 
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

	.fc-toolbar .iconic-text{
    	padding-right:70px;
	}

	.fa-cube:before{
		margin-left:5px;
		margin-right:5px;
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
			events: [				
					<cfoutput query="events"> 
						{
							id: #class_id#,
							title: '#Replace(CLASS_NAME,"'","\'","all")#',
							start: '#DateFormat(START_DATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session_base.time_zone,START_DATE),"HH:mm:ss")#',
							end: '#DateFormat(FINISH_DATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session_base.time_zone,FINISH_DATE),"HH:mm:ss")#',
							url : '#USER_FRIENDLY_URL#'						
						},
					</cfoutput>                  			
			],
				editable: false,			
						
		});
	

	$("<div>")   

		
        $('<div>').addClass('calendar_head').text("<cf_get_lang dictionary_id='58043.Eğitim Ajandası'>").appendTo("div.fc-left");
		
		

		$('<span>').addClass('fa fa-chevron-left calendar-np-buttons').attr("onClick","$('#calendar').fullCalendar('prev');").prependTo("div.fc-center");
		$('<span>').addClass('fa fa-chevron-right calendar-np-buttons').attr("onClick","$('#calendar').fullCalendar('next');").appendTo("div.fc-center");

		$("<div>")
		.addClass('calendar-icon-content')
		.append(
			$('<span>')
				.addClass('iconic fa fa-calendar-o')
				.attr({
					onclick :"$('#calendar').fullCalendar('today');",
					title		:"<cfoutput>#getlang('main',530,'Bugün')#</cfoutput>"
				})
				.append('<i><cfoutput>#Day(NOW())#</cfoutput></i>')	
		)
		.append(
			$('<span>')
				.addClass('iconic fa fa-calendar')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'month');",
					title		:"<cfoutput>#getlang('main',1520,'Aylık')#</cfoutput>"
					
					})	
		)
	
		.append(
			$('<span>')
				.addClass('iconic fa fa-list-ul')
				.attr({
					onclick :"$('#calendar').fullCalendar('changeView', 'listWeek');",
					title		:"<cfoutput>#getlang('main',97,'Liste')#</cfoutput>"
				})	
		)

	
		.prependTo("div.fc-right");

  });
</script>