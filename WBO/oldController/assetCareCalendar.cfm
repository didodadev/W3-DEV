<cf_get_lang_set module_name="assetcare">
<cfscript>
	if (isdefined('url.gun')) 
		gun = url.gun;
	else
		gun = dateformat(now(), 'dd');
	if (isdefined('url.ay'))
		ay = url.ay;
	else
		ay = dateformat(now(),'mm');
	if (isdefined('url.yil'))
		yil = url.yil;
	else
		yil = dateformat(now(),'yyyy');
	
	tarih = '#gun#/#ay#/#yil#';
	try
	{
		temp_tarih = tarih;
		attributes.to_day = date_add('h', -session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
	}
	catch(Any excpt)
	{
		tarih = '1/#ay#/#yil#';
		temp_tarih = tarih;
		attributes.to_day = date_add('h', -session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-1'));
	}
</cfscript>
<cf_date tarih="temp_tarih">

<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cf_xml_page_edit fuseact="assetcare.dsp_care_calender">
	<cfparam name="attributes.official_emp_id" default="">
    <cfparam name="attributes.assetpcatid" default="">
    <cfparam name="attributes.official_emp" default="">
    <cfparam name="attributes.asset_id" default="">
    <cfparam name="attributes.asset_name" default="">
    <cfparam name="attributes.asset_cat" default=""> 
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.branch" default="">
    <cfparam name="attributes.xml_single_asset_care" default="">
    <cfparam name="attributes.time_type" default="1">
    <cfscript>
        if (isdefined('url.gun')) 
            gun = trim(url.gun);
        else
            gun = dateformat(now(), 'dd');
        if (isdefined('url.ay'))
            ay = trim(url.ay);
        else
            ay = dateformat(now(),'mm');
        if (isdefined('url.yil'))
            yil = trim(url.yil);
        else
            yil = dateformat(now(),'yyyy');
        
        tarih = '#gun#/#ay#/#yil#';
    
        try
        {
            temp_tarih = tarih;
            attributes.to_day = date_add('h', -session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
        }
        catch(Any excpt)
        {
            tarih = '1/#ay#/#yil#';
            temp_tarih = tarih;
            attributes.to_day = date_add('h', -session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-1'));
        }
    </cfscript>
	<cfif isdefined(xml_single_asset_care) and xml_single_asset_care eq 1>
	<cfset xml_single_asset_care = 1>
	<cfelse>
	<cfset xml_single_asset_care = 0>
	</cfif> 
	<cfset temp_adres = "">
	<cfif len(attributes.assetpcatid)>
		<cfset temp_adres = "#temp_adres#&assetpcatid=#attributes.assetpcatid#">
	</cfif>
	<cfif len(attributes.asset_id)>
		<cfset temp_adres = "#temp_adres#&asset_id=#attributes.asset_id#">
	</cfif>
	<cfif len(attributes.asset_cat)>
		<cfset temp_adres = "#temp_adres#&asset_cat=#attributes.asset_cat#">
	</cfif>
	<cfif len(attributes.department_id)>
		<cfset temp_adres = "#temp_adres#&department_id=#attributes.department_id#">
	</cfif>
	<cfif len(attributes.branch_id)>
		<cfset temp_adres = "#temp_adres#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif len(attributes.official_emp_id)>
		<cfset temp_adres = "#temp_adres#&official_emp_id=#attributes.official_emp_id#">
	</cfif>
	<cfset adres="#temp_adres#&time_type=#attributes.time_type#">
    <cfquery name="GET_ASSETP_CAT" datasource="#DSN#">
        SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT <!--- WHERE MOTORIZED_VEHICLE = 1 ---> ORDER BY ASSETP_CAT
    </cfquery>
    <cfquery name="GET_ASSET_CAT" datasource="#dsn#">
        SELECT ASSET_CARE_ID, ASSET_CARE,ASSETP_CAT FROM ASSET_CARE_CAT ORDER BY ASSET_CARE
    </cfquery>

    <cfif isDefined("url.ay")>
	  <cfset ay = url.ay>
      <cfelseif isDefined("attributes.ay")>
      <cfset ay = attributes.ay>
      <cfelse>
      <cfset ay = DateFormat(now(),"mm")>
    </cfif>
    <cfif isDefined("url.yil")>
      <cfset yil = url.yil>
      <cfelseif isDefined("attributes.yil")>
      <cfset yil = attributes.yil>
      <cfelse>
      <cfset yil = DateFormat(now(),"yyyy")>
    </cfif>
    <cfif not isdefined("attributes.mode")>
      <cfset attributes.mode = "">
    </cfif>
    <cfset oncekiyil = yil-1>
    <cfset sonrakiyil = yil+1>
    <cfset oncekiay = ay-1>
    <cfset sonrakiay = ay+1>
    <cfif ay EQ 1>
      <cfset oncekiay=12>
    </cfif>
    <cfif ay EQ 12>
      <cfset sonrakiay=1>
    </cfif>
    <cfsavecontent variable="ocak"><cf_get_lang_main no='180.ocak'></cfsavecontent>
    <cfsavecontent variable="subat"><cf_get_lang_main no='181.şubat'></cfsavecontent>
    <cfsavecontent variable="mart"><cf_get_lang_main no='182.mart'></cfsavecontent>
    <cfsavecontent variable="nisan"><cf_get_lang_main no='183.nisan'></cfsavecontent>
    <cfsavecontent variable="mayis"><cf_get_lang_main no='184.mayıs'></cfsavecontent>
    <cfsavecontent variable="haziran"><cf_get_lang_main no='185.haziran'></cfsavecontent>
    <cfsavecontent variable="temmuz"><cf_get_lang_main no='186.temmuz'></cfsavecontent>
    <cfsavecontent variable="agustos"><cf_get_lang_main no='187.agustos'></cfsavecontent>
    <cfsavecontent variable="eylul"><cf_get_lang_main no='188.eylül'></cfsavecontent>
    <cfsavecontent variable="ekim"><cf_get_lang_main no='189.ekim'></cfsavecontent>
    <cfsavecontent variable="kasim"><cf_get_lang_main no='190.ksaım'></cfsavecontent>
    <cfsavecontent variable="aralik"><cf_get_lang_main no='191.aralık'></cfsavecontent>
    <cfset aylar="#trim(ocak)#,#trim(subat)#,#trim(mart)#,#trim(nisan)#,#trim(mayis)#,#trim(haziran)#,#trim(temmuz)#,#trim(agustos)#,#trim(eylul)#,#trim(ekim)#,#trim(kasim)#,#trim(aralik)#">
    <cfset tarih = createDate(yil,ay,1)>
    <cfset bas = DayofWeek(tarih)-1> <!---gun değerini rakam olarak dondurur--->
    <cfif bas EQ 0>
      <cfset bas=7>
    </cfif>
    <cfset son = DaysinMonth(tarih)><!--- aydaki gun sayısını verir--->
    <cfset gun = 1>
    <cfset yer = "#cgi.script_name#?fuseaction=#attributes.fuseaction#&mode=#attributes.mode#">
<cfelseif isdefined("attributes.event") and attributes.event is 'weekly'>	
    <cf_xml_page_edit fuseact="assetcare.dsp_care_calender">
    <cfparam name="attributes.official_emp_id" default="">
    <cfparam name="attributes.assetpcatid" default="">
    <cfparam name="attributes.official_emp" default="">
    <cfparam name="attributes.asset_id" default="">
    <cfparam name="attributes.asset_name" default="">
    <cfparam name="attributes.asset_cat" default=""> 
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.branch" default="">
    <cfparam name="attributes.time_type" default="2">
    <cfscript>
        if (isdefined('url.yil'))
            tarih = url.yil;
        else
            tarih = dateformat(now(),'yyyy');
        if (isdefined('url.ay'))
            tarih=tarih&'-'&url.ay;
        else
            tarih=tarih&'-'&dateformat(now(),'mm');
        if (isdefined('url.gun'))
            tarih=tarih&'-'&url.gun;
        else
            tarih=tarih&'-'&dateformat(now(),'d');
            fark = (-1)*(dayofweek(tarih)-2);
        if (fark eq 1) fark = -6;
            last_week = date_add('d',fark-1,tarih);
            first_day = date_add('d',fark,tarih);
            second_day = date_add('d',1,first_day);
            third_day = date_add('d',2,first_day);
            fourth_day = date_add('d',3,first_day);
            fifth_day = date_add('d',4,first_day);
            sixth_day = date_add('d',5,first_day);
            seventh_day = date_add('d',6,first_day);
            next_week = date_add('d',7,first_day);
            attributes.day = date_add('h', -session.ep.time_zone, first_day);
    </cfscript>
    
    <cfset temp_adres = "">
    <cfif len(attributes.assetpcatid)>
        <cfset temp_adres = "#temp_adres#&assetpcatid=#attributes.assetpcatid#">
    </cfif>
    <cfif len(attributes.asset_id)>
        <cfset temp_adres = "#temp_adres#&asset_id=#attributes.asset_id#">
    </cfif>
    <cfif len(attributes.asset_cat)>
        <cfset temp_adres = "#temp_adres#&asset_cat=#attributes.asset_cat#">
    </cfif>
    <cfif len(attributes.department_id)>
        <cfset temp_adres = "#temp_adres#&department_id=#attributes.department_id#">
    </cfif>
    <cfif len(attributes.branch_id)>
        <cfset temp_adres = "#temp_adres#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif len(attributes.official_emp_id)>
        <cfset temp_adres = "#temp_adres#&official_emp_id=#attributes.official_emp_id#">
    </cfif>
    <cfset adres="#temp_adres#time_type=#attributes.time_type#">
<cfelseif isdefined("attributes.event") and attributes.event is 'monthly'>	
    <cf_xml_page_edit fuseact="assetcare.dsp_care_calender">
    <cfparam name="attributes.official_emp_id" default="">
    <cfparam name="attributes.assetpcatid" default="">
    <cfparam name="attributes.official_emp" default="">
    <cfparam name="attributes.asset_id" default="">
    <cfparam name="attributes.asset_name" default="">
    <cfparam name="attributes.asset_cat" default=""> 
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department" default="">
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.branch" default="">
    <cfparam name="attributes.time_type" default="3">
    <cfsavecontent variable="ay1"><cf_get_lang_main no ='180.Ocak'></cfsavecontent>
    <cfsavecontent variable="ay2"><cf_get_lang_main no ='181.Şubat'></cfsavecontent>
    <cfsavecontent variable="ay3"><cf_get_lang_main no ='182.Mart'></cfsavecontent>
    <cfsavecontent variable="ay4"><cf_get_lang_main no ='183.Nisan'></cfsavecontent>
    <cfsavecontent variable="ay5"><cf_get_lang_main no ='184.Mayıs'></cfsavecontent>
    <cfsavecontent variable="ay6"><cf_get_lang_main no ='185.Haziran'></cfsavecontent>
    <cfsavecontent variable="ay7"><cf_get_lang_main no ='186.Temmuz'></cfsavecontent>
    <cfsavecontent variable="ay8"><cf_get_lang_main no ='187.Ağustos'></cfsavecontent>
    <cfsavecontent variable="ay9"><cf_get_lang_main no ='188.Eylül'></cfsavecontent>
    <cfsavecontent variable="ay10"><cf_get_lang_main no ='189.Ekim'></cfsavecontent>
    <cfsavecontent variable="ay11"><cf_get_lang_main no ='190.Kasım'></cfsavecontent>
    <cfsavecontent variable="ay12"><cf_get_lang_main no ='191.Aralık'></cfsavecontent>
    <cfscript>
        if (isDefined('url.ay'))
            ay = url.ay;
        else if (isDefined('attributes.ay'))
            ay = attributes.ay;
        else
            ay = DateFormat(now(),'mm');
        if (isDefined('url.yil'))
            yil = url.yil;
        else if (isDefined('attributes.yil'))
            yil = attributes.yil;
        else
            yil = DateFormat(now(),'yyyy');
        if (not isdefined('attributes.mode'))
            attributes.mode = '';
            oncekiyil = yil-1;
            sonrakiyil = yil+1;
            oncekiay = ay-1;
            sonrakiay = ay+1;
        if (ay eq 1)
            oncekiay=12;
        if (ay eq 12)
            sonrakiay=1;
            aylar = '#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#';
            tarih = createDate(yil,ay,1);
            bas = DayofWeek(tarih)-1;
        if (bas eq 0)
            bas = 7;
            son = DaysinMonth(tarih);
            gun = 1;
            yer = '#request.self#?fuseaction=assetcare.list_monthly_report';
            attributes.day = date_add("h",-session.ep.time_zone, CreateODBCDatetime('#yil#-#ay#-#gun#'));
    </cfscript>
    <cfset adres="assetpcatid=#attributes.assetpcatid#&official_emp=#attributes.official_emp#&asset_id=#attributes.asset_id#&asset_cat=#attributes.asset_cat#&department_id=#attributes.department_id#&branch_id=#attributes.branch_id#&time_type=#attributes.time_type#&official_emp_id=#attributes.official_emp_id#">
</cfif>
<script type="text/javascript">
	<cfif (not isdefined("attributes.event") or attributes.event is 'list') or listfind('weekly,monthly',attributes.event)>
	function kontrol()
	{
		if(document.service_date_.time_type.value == '')
		{
			alert('<cf_get_lang dictionary_id="52216.Bakım Periyodu Seçmelisiniz">!');
			return false;
		}
		else	
		{	
			if(document.service_date_.time_type.value == 1) 
			{
				service_date_.action = <cfoutput>'#request.self#?fuseaction=assetcare.dsp_care_calender'</cfoutput>; 
				service_date_.submit();
			}
			else if(document.service_date_.time_type.value == 2) 
			{
				service_date_.action = <cfoutput>'#request.self#?fuseaction=assetcare.dsp_care_calender&event=weekly<cfif isdefined("seventh_day") and len(seventh_day)>&yil=#dateformat(seventh_day,"yyyy")#&ay=#dateformat(seventh_day,"mm")#&gun=#dateformat(seventh_day,"dd")#</cfif>'</cfoutput>; 
				service_date_.submit();
			}
			else if(document.service_date_.time_type.value == 3) 
			{
				service_date_.action = <cfoutput>'#request.self#?fuseaction=assetcare.dsp_care_calender&event=monthly&yil=#yil#&ay=#ay#&gun=#gun#'</cfoutput>; 
				service_date_.submit();
			}
		}
	}
	function get_value(assetp_id)
	{
		var get_care_type_no=wrk_safe_query('ascr_get_care_type_no','dsn',0,assetp_id);
		var asset_cat_len = eval('document.getElementById("asset_cat")').options.length;
		for(j=asset_cat_len;j>=0;j--)
			eval('document.getElementById("asset_cat")').options[j] = null;	
			eval('document.getElementById("asset_cat")').options[0] = new Option('Seçiniz','');
		for(var jj=0;jj < get_care_type_no.recordcount;jj++)
			eval('document.getElementById("asset_cat")').options[jj+1]=new Option(''+get_care_type_no.ASSET_CARE[jj]+'',''+get_care_type_no.ASSET_CARE_ID[jj]+'');
	}
	</cfif>	
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.dsp_care_calender';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'assetcare/display/dsp_care_calender.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'assetcare/display/dsp_care_calender.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'assetcare.dsp_care_calender';
	
	WOStruct['#attributes.fuseaction#']['weekly'] = structNew();
	WOStruct['#attributes.fuseaction#']['weekly']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['weekly']['fuseaction'] = 'assetcare.list_weekly_report';
	WOStruct['#attributes.fuseaction#']['weekly']['filePath'] = 'assetcare/display/list_weekly_report.cfm';
	WOStruct['#attributes.fuseaction#']['weekly']['queryPath'] = 'assetcare/display/list_weekly_report.cfm';
	WOStruct['#attributes.fuseaction#']['weekly']['nextEvent'] = 'assetcare.dsp_care_calender';
	
	WOStruct['#attributes.fuseaction#']['monthly'] = structNew();
	WOStruct['#attributes.fuseaction#']['monthly']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['monthly']['fuseaction'] = 'assetcare.list_monthly_report';
	WOStruct['#attributes.fuseaction#']['monthly']['filePath'] = 'assetcare/display/list_monthly_report.cfm';
	WOStruct['#attributes.fuseaction#']['monthly']['queryPath'] = 'assetcare/display/list_monthly_report.cfm';
	WOStruct['#attributes.fuseaction#']['monthly']['nextEvent'] = 'assetcare.dsp_care_calender';
	
</cfscript>