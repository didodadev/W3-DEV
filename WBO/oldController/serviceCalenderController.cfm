<cfscript>
	if (isdefined('url.gun')) 
		gun = url.gun;
	else
		gun = dateformat(now(),'dd');
	
	if (isdefined('url.ay'))
		ay = url.ay;
	else
		ay = dateformat(now(),'mm');
		
	if (isdefined('url.yil'))
		yil = url.yil;
	else
		yil = dateformat(now(),'yyyy');
	
	tarih = '#gun#/#ay#/#yil#';
	tarih=replace(tarih,' ','','all');
	try
		{
			temp_tarih = tarih;
			search_tarih_ = tarih;
			attributes.to_day = date_add('h', -session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
		}
	catch(Any excpt)
		{
			tarih = '1/#ay#/#yil#';
			temp_tarih = tarih;
			search_tarih_ = tarih;
			attributes.to_day = date_add('h', -session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-1'));
		}
</cfscript>

<cfparam name="attributes.care_type" default="3">
<cf_date tarih='search_tarih_'>

<cfsavecontent variable="head_">
	<table>
		<tr>
			<cfoutput>
				<td style="width:15px;">
				<cfif not listfindnocase(denied_pages,'service.dsp_service_calender')>
					<a href="#request.self#?fuseaction=service.dsp_service_calender&gun=#Dateformat(date_add('d',-1,search_tarih_),'dd')#&ay=#Dateformat(date_add('d',-1,search_tarih_),'mm')#&yil=#Dateformat(date_add('d',-1,search_tarih_),'yyyy')#&care_type=#attributes.care_type#"><img src="/images/previous20.gif" border=0 align="absmiddle"></a>
				</cfif>	
				</td>
				</cfoutput>
				<td class="headbold" nowrap><cfoutput>#temp_tarih#</cfoutput> - <cf_date tarih="tarih">
					<cfmodule template="../service/display/tr_tarih.cfm" output="1" format="dddd" tarih="#tarih#">
				</td>
				<cfoutput>
				<td style="width:15px;">
					<cfif not listfindnocase(denied_pages,'service.dsp_service_calender')>
						<a href="#request.self#?fuseaction=service.dsp_service_calender&gun=#Dateformat(date_add('d',1,search_tarih_),'dd')#&ay=#Dateformat(date_add('d',1,search_tarih_),'mm')#&yil=#Dateformat(date_add('d',1,search_tarih_),'yyyy')#&care_type=#attributes.care_type#"><img src="/images/next20.gif" border=0 align="absmiddle"></a>
					</cfif>
				</td>
			</cfoutput>
		</tr>
	</table>
</cfsavecontent>

<cfset Gun_ = Dateformat(date_add('d',0,search_tarih_),'dd')>
<cfset Ay_ = Dateformat(date_add('d',0,search_tarih_),'mm')>
<cfset Yil_ = Dateformat(date_add('d',0,search_tarih_),'yyyy')>

<script type="text/javascript">
	function reload_(gelen)
	{
	service_date.action = "<cfoutput>#request.self#?fuseaction=service.dsp_service_calender&gun=#Gun_#&ay=#Ay_#&yil=#Yil_#</cfoutput>"; 
	service_date.submit();
	return true;
	}
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'det';

	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'service.dsp_service_calender';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'service/display/dsp_service_calender.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'service.dsp_service_calender&event=det';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '';
</cfscript>
