<!--- Cache olmaması için --->
<cfsetting showdebugoutput="no">
<CFPARAM NAME="request.IsMSIE7" DEFAULT = "#IIf( CGI.USER_AGENT CONTAINS "MSIE 7", 1, 0 )#">
<CFPARAM NAME="request.IsMSIE8" DEFAULT = "#IIf( CGI.USER_AGENT CONTAINS "MSIE 8", 1, 0 )#">
<CFPARAM NAME="request.IsMSIE9" DEFAULT = "#IIf( CGI.USER_AGENT CONTAINS "MSIE 9", 1, 0 )#">
<CFPARAM NAME="request.IsOpera" DEFAULT = "#IIf( CGI.USER_AGENT CONTAINS "Opera", 1, 0 )#">
<CFPARAM NAME="request.IsGecko" DEFAULT = "#IIf( CGI.USER_AGENT CONTAINS "Gecko", 1, 0 )#">
<CFPARAM NAME="request.IsKonqueror" DEFAULT = "#IIf( CGI.USER_AGENT CONTAINS "Konqueror", 1, 0 )#">
<CFPARAM NAME="request.IsMac" DEFAULT = "#IIf( CGI.USER_AGENT CONTAINS "Mac", 1, 0 )#">
<CFPARAM NAME="request.IsNN" DEFAULT = "#IIf( request.IsMSIE7 OR request.IsMSIE8 OR request.IsMSIE9,1,0)#">


<cfcache action="flush">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<CFPARAM NAME="request.IsMSIE7" DEFAULT = "#IIf( CGI.USER_AGENT CONTAINS "MSIE 7", 1, 0 )#"><head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<script src="../../../JS/js_functions.js" type="text/javascript"></script>
<script src="/V16/agenda/display/event_calendar/samples/common/dhtmlxscheduler.js" type="text/javascript" charset="utf-8"></script>
<script src="/V16/agenda/display/event_calendar/samples/common/dhtmlxcommon.js" type="text/javascript" charset="utf-8"></script>
	

<cfobjectcache action="clear">
<cfset color = StructNew()>


<cfif isDefined('session.ep.design_color')>
	<cfif session.ep.design_color eq 1>			
		<cfset color.windowBgColor = '##a7caed'>
		<cfset color.windowFontColor = '##887A2E'>
		<cfset color.headerBgColor = '##daeaf8'>
		<cfset color.headerFontColor = 'black'>
	<cfelseif session.ep.design_color eq 2>
		<cfset color.windowBgColor = '##807568'>
		<cfset color.windowFontColor = 'white'>
		<cfset color.headerBgColor = '##AEA69F'>
		<cfset color.headerFontColor = 'white'>
	<cfelseif session.ep.design_color eq 3>
		<cfset color.windowBgColor = '##FFCC7f'>
		<cfset color.windowFontColor = 'black'>
		<cfset color.headerBgColor = '##FCF0C2'>
		<cfset color.headerFontColor = 'black'>
	<cfelseif session.ep.design_color eq 4>
		<cfset color.windowBgColor = '##CCCC99'>
		<cfset color.windowFontColor = 'black'>
		<cfset color.headerBgColor = '##ECEFD0'>
		<cfset color.headerFontColor = 'black'>
	<cfelseif session.ep.design_color eq 5>
		<cfset color.windowBgColor = '##AFBCC7'>
		<cfset color.windowFontColor = 'black'>
		<cfset color.headerBgColor = '##E4E8EB'>
		<cfset color.headerFontColor = 'black'>
	<cfelseif session.ep.design_color eq 6>
		<cfset color.windowBgColor = '##67BBC9'>
		<cfset color.windowFontColor = 'black'>
		<cfset color.headerBgColor = '##D2E9ED'>
		<cfset color.headerFontColor = 'black'>
	<cfelse>		
		<cfset color.windowBgColor = '##8bbb5c'>
		<cfset color.windowFontColor = 'black'>
		<cfset color.headerBgColor = '##ddf3c8'>
		<cfset color.headerFontColor = 'black'>		
	</cfif>
<cfelse>
	<link rel="stylesheet" href="../../../css/assets/template/win_ie.css" type="text/css" id="page_css">
</cfif>


<link rel="stylesheet" href="/V16/agenda/display/event_calendar/samples/common/dhtmlxscheduler.css" type="text/css" title="no title" charset="utf-8">
<style>
	.dhx_cal_light{
		height:400px;
		light:300px;		
		background-color:<cfoutput>#color.windowBgColor#</cfoutput>;
		
		font-family:Tahoma;
		font-size:8pt;
		border:1px solid #a7caed;
		color:<cfoutput>#color.windowFontColor#</cfoutput>;		
		
		position:absolute;
		z-index:10001;
		
		width:500px;
		height:300px;
	}

	.dhx_cal_lsection{
		background-color:<cfoutput>#color.headerBgColor#</cfoutput>;
		color:<cfoutput>#color.headerFontColor#</cfoutput>;
		font-size:8pt;
		font-weight:bold;
		padding:3px 0px 1px 5px;
	}
	.dhx_cal_larea{
		border:1px solid <cfoutput>#color.headerBgColor#</cfoutput>;
		background-color:white;
		overflow:hidden;
		
		margin-left:3px;
		
		width:492px;
		height:1px;
	}
</style>
<style type="text/css" media="screen">
	html, body{
		margin:0px;
		padding:0px;
		height:100%;
		overflow:hidden;
	}	
</style>

<script type="text/javascript" charset="utf-8">
function workdata_agenda(qry,prmt)
{			
	var new_query=new Object();
	var req;
	if(!qry) return false;
	if(prmt == undefined) prmt='';
	function callpage(url)
	{		
		req = false;
		if(window.XMLHttpRequest)
			try{
				req = new XMLHttpRequest();
			}catch(e){
				req = false;
			}
		else if(window.ActiveXObject)
			try {req = new ActiveXObject("Msxml2.XMLHTTP");}
			catch(e){
				try{
					req = new ActiveXObject("Microsoft.XMLHTTP");
				}catch(e){
					req = false;
				}
		}
		if(req)
		{
			function return_function_()
			{
			if (req.readyState == 4 && req.status == 200)
				try{					
					eval(req.responseText);					
					new_query = get_js_query;
				}catch(e){
					new_query = false;
				}
			}
			req.open("post", url, false);
			req.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
			req.setRequestHeader('pragma','nocache');
			var extra_params='';//gelen parametrelerin sınırsız olabilmesi için
			var prm_count=0;
			for(var prms_i=2; prms_i < workdata_agenda.arguments.length;prms_i++)
			{
				if(workdata_agenda.arguments[prms_i]!=undefined)
				{
					prm_count++;
					if(prm_count==1)
						param_name='extra';
					else
						param_name='extra'+prm_count;
					extra_params=extra_params+'&'+param_name+'='+encodeURI(workdata_agenda.arguments[prms_i]);
				}
			}
			//document.getElementById('sonuc').innerHTML = 'qry='+qry+"&"+encodeURI(prmt)+'&'+extra_params;
			req.send('qry='+qry+"&"+encodeURI(prmt)+'&'+extra_params);			
			return_function_();			
		}
	}	
	callpage('http://<cfoutput>#CGI.HTTP_HOST#</cfoutput>/index.cfm?fuseaction=objects2.emptypopup_get_workdata_agenda');	
	return new_query;
}
<cfset start_date = DateFormat(now(),"yyyy-mm-01")>
	function init() {
		scheduler.config.xml_date="%Y-%m-%d %H:%i";
		scheduler.config.lightbox.sections=[				
			{name:"description", height:100, map_to:"text", type:"textarea" , focus:true},					
			{name:"time", height:72, type:"time", map_to:"auto"}
		]
		scheduler.locale.labels.section_stage = "Durum"; 
		scheduler.locale.labels.section_category = "Kategori"; 

		scheduler.config.first_hour=4;
		scheduler.config.details_on_create=true;
		scheduler.config.details_on_dblclick=true;
		document.getElementById('scheduler_here').style.height = document.body.clientHeight + 'px';
		scheduler.init('scheduler_here',null,"week");
	}
</script>
<div id="sonuc"></div>
<body onLoad="init();">
	<div id="scheduler_here" class="dhx_cal_container" style='width:100%; height:100%;'>
		<div class="dhx_cal_navline">
			<div class="dhx_cal_prev_button">&nbsp;</div>
			<div class="dhx_cal_next_button">&nbsp;</div>
			<div class="dhx_cal_today_button"></div>
			<div class="dhx_cal_date"></div>
			<div class="dhx_cal_tab" name="day_tab" style="right:204px;"></div>
			<div class="dhx_cal_tab" name="week_tab" style="right:140px;"></div>
			<div class="dhx_cal_tab" name="month_tab" style="right:76px;"></div>
		</div>
		<div class="dhx_cal_header">
		</div>
		<div class="dhx_cal_data">
		</div>		
	</div>
</body>
