
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

<script type="text/javascript" src="V16/agenda/jquery.calendar.js"></script>
<link rel="stylesheet" media="screen" href="V16/agenda/jquery.calendar.css"/>
<cfinclude template="../query/get_all_agenda_department_branch.cfm">
<cfinclude template="../query/view_weekly.cfm">

<script type="text/javascript">
$(function(){
	
	$calendar = $('#calendar').cal({
		
		monthstodisplay	: 1,
		
		allowmove		: true,
		allowselect		: true,
		allowremove		: true,
		allownotesedit	: true,
		
		eventselect : function( uid ){
			console.log( 'Selected event: '+uid );
		},
		
		eventremove : function( uid ){
			console.log( 'Removed event: '+uid );
		},
		
		eventnotesedit : function( uid ){
			console.log( 'Edited Notes for event: '+uid );
		},
		
		events : [	
			<cfoutput query="getQueryAgenda"> 
				{
					uid:#event_id#,
					title: '#Replace(EVENT_HEAD,"'","\'","all")#',
					begins: '#DateFormat(STARTDATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,STARTDATE),"HH:mm:ss")#',
					ends: '#DateFormat(FINISHDATE, "yyyy-mm-dd")#T#TimeFormat(dateAdd("H",session.ep.time_zone,FINISHDATE),"HH:mm:ss")#',
					color: '#COLOUR#'
				},
			</cfoutput>
		]
		
	});
	
	/**
	 * Set the initial header value.
	 */
	$('#date_head').text($.cal.date().format('F Y'));
	
	/**
	 * Button click handler. 
	 *
	 * TODO: Turn this into a drop-in module for calendars once we've got the capability to 
	 * 		 toggle calendar views without reloading. Include 'formatRange' method.
	 */
	$('#controls').on('click','button[name]',function(){
		
		var $this = $(this), action = $this.attr('name');
		
		// If this is already the current state, just exit.
		if( $this.is('.on') ) return;
		
		// Switch to the new state.
		switch( action ) {
			
			/** 
			 * TODO: For now... ideally you'd be able to toggle between views without reloading.
			 */
			case 'week'		: window.location = '<cfoutput>#request.self#?fuseaction=agenda.view_weekly</cfoutput>'; break;
			case 'day'		: window.location = '<cfoutput>#request.self#?fuseaction=agenda.view_daily</cfoutput>'; break;
			case 'month'	: window.location = '<cfoutput>#request.self#?fuseaction=agenda.view_monthly</cfoutput>'; break;
			
			case 'prev'		:
			case 'today'	:
			case 'next'		:
				
				var today	 = $.cal.date(),
					starting = $calendar.cal('option','startdate'),
					duration = $calendar.cal('option','monthstodisplay'),
					newstart = starting,
					newend;
				
				switch( action ){	
					case 'next' : newstart = starting.addMonths(duration); $('button[name="today"]').parent().removeClass('on'); break;
					case 'prev'	: newstart = starting.addMonths(0-duration); $('button[name="today"]').parent().removeClass('on'); break;
					case 'today': newstart = $.cal.date().addDays(1-$.cal.date().format('d')); break;
				}
				
				// Work out the new end date.
				newend = newstart.addDays(duration-1);
				 
				// Set the new startdate.
				$calendar.cal( 'option','startdate', newstart );
				
				if( today >= newstart && today <= newend ) $('button[name="today"]').parent().addClass('on');
				
				// Set the new date in the header.
				$('#date_head').text( newstart.format('F Y') )
			break;
		}
	});
});
</script>

<style type="text/css">
#calendar{
position: absolute;
top: 181px;
left: 50px;
right: 50px;
bottom: 50px;
border: 1px solid #bbb;
}

#date_head{
position: absolute;
right: 200px;
margin: auto;
text-align: center;
left: 200px;
width : 50% !important;
}

#controls{
position: absolute;
top: 130px;
height: 23px;
left: 50px;
right: 50px;
margin: 0;
padding: 0;
}

#controls ol{
list-style-type: none;
margin: 0;
padding: 0;
border: 1px solid #B3B3B3;
border-radius: 2px;
overflow: hidden;
-moz-background-clip: padding;     /* Firefox 3.6 */
-webkit-background-clip: padding;  /* Safari 4? Chrome 6? */
background-clip: padding-box;      /* Firefox 4, Safari 5, Opera 10, IE 9 */
height: 21px;
}

#controls ol li{
display: inline-block;
float: left;
height: 100%;
padding: 0;
margin: 0;
border: 0;
background: #CACACA url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAUCAYAAABMDlehAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAADlJREFUeNp0y6sNACAAxNALBs0ArM9QbMEnJKiD4jEvNZXtEiRVEBg2LJgwoEN7pbtlSBBBX44AAwARiCdWebcYiAAAAABJRU5ErkJggg==) repeat-x 0 0; /* Old browsers */
text-shadow: rgba(255, 255, 255, 0.5) 0px 1px 0px;
color: #333;
}

#controls ol li:hover{
background-color: #C0C0C0;
color: #000;
}

#controls ol li.on{
background: #C4C4C4;
color: #555;
}

#controls ol li button{
margin: 0;
background: transparent;
border: 0;
border-left: 1px solid #B3B3B3;
height: 100%;
padding: 0 10px;
color: inherit;
text-shadow: inherit;
cursor: pointer;
}

#controls ol li:first-child button{
border-left: 0;
}

#cals{
float: left;
}

#nav{
float: right;
}

#ajanda{
	float: right;
}
</style>
<div id="controls">
	<cfoutput>
	<ol id="cals">
		<li class="on"><button name="day">#getLang('main',1045,'g??nl??k')#</button></li>
		<li><button name="week">#getLang('main',1046,'haftal??k')#</button></li>
		<li><button name="month">#getLang('main',1520,'y??ll??k')#</button></li>
		
	</ol>

	<h1 id="date_head"></h1>
	<ol id="nav">
		<li><button name="ekle" title="#getLang('main',170,'geri')#"class="fa fa-plus" onclick="add_event()"></button></li>
		<li><button name="prev">#getLang('main',20,'geri')#</button></li>
		<li class="on"><button name="today">#getLang('main',530,'bug??n')#</button></li>
		<li><button name="next">#getLang('main',1431,'ileri')#</button></li>
	</ol>
	</br></br>
	<ol id="ajanda">
		<li><button name="#getLang('agenda',81,'network')#"  onclick="submit_agenda_daily(3)">#getLang('agenda',81,'network')#</button></li>
		<li><button name="#getLang('agenda',78,'network')#" onclick="submit_agenda_daily(2)">#getLang('agenda',78,'??ube ajanda')#</button></li>
		<li><button name="#getLang('agenda',79,'departman ajanda')#" onclick="submit_agenda_daily(1)">#getLang('agenda',79,'departman ajanda')#</button></li>
		<li><button name="#getLang('agenda',80,'Bana ??zel ajanda')#" onclick="submit_agenda_daily(4)">#getLang('agenda',80,'Bana ??zel ajanda')#</button></li>
		<li><button name="#getLang('agenda',71,'Arama')#" onclick="submit_agenda_daily(5)">#getLang('agenda',71,'Arama')#</button></li>
	</ol>
	</cfoutput>
</div>
<div id="calendar"></div>
<script>
	function add_event()
	{
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.form_add_event&date=#dateFormat(now(),"dd.mm.yyyy")#</cfoutput>';
	}
	function submit_agenda_daily(agenda_type)
	{
		if (agenda_type=='1')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_weekly&view_agenda=1</cfoutput>';
		else if(agenda_type=='2')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_weekly&view_agenda=2</cfoutput>';
		else if(agenda_type=='3')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_weekly&view_agenda=3</cfoutput>';
		else if(agenda_type=='4')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.view_weekly</cfoutput>';
		else if(agenda_type=='5')
			window.location.href='<cfoutput>#request.self#?fuseaction=agenda.search</cfoutput>';
	}

</script>