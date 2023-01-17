<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Emin Yaşartürk		Developer	: Emin Yaşartürk
Analys Date : 27/05/2016			Dev Date	: 27/05/2016
Description :

	* Bu controller Oryantasyon Eğitimlerini içerir.
	
	* add,upd ve list eventlerini içerisinde barındırır.
----------------------------------------------------------------------->

<!------------------------------------------------------
	Event lere göre kontroller yapılıyor
-------------------------------------------------------->

<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfset url_str = "">
	<cfparam name="is_filtered" default="0">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.startdate" default="#date_add('m',-1,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))#">
	<cfparam name="attributes.finishdate" default="#date_add('m',1,attributes.startdate)#">
	<cfif is_filtered>
		<cfif len(attributes.startdate)>
			<cf_date tarih="attributes.startdate">
		</cfif>
		<cfif len(attributes.finishdate)>
			<cf_date tarih="attributes.finishdate">
		</cfif>
		<cfscript>
			get_orientation = OrientationModel.get(
				keyword 		: attributes.keyword,
				startdate		: attributes.startdate,
				finishdate		: attributes.finishdate	,
				orientationId	: 0			
			);
		</cfscript>
	<cfelse>
    	<cfset get_orientation.recordcount = 0>
	</cfif>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default="#get_orientation.recordcount#">
<cfelse>
	<cfparam name="attributes.orientation_head" default="">
	<cfparam name="attributes.emp_id" default="">
	<cfparam name="attributes.emp_name" default="">
	<cfparam name="attributes.trainer_emp_id" default="">
	<cfparam name="attributes.trainer_emp_name" default="">
	<cfparam name="attributes.start_date" default="">
	<cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.detail" default="">
    <cfif attributes.event is 'upd'>
		<cfscript>
            get_orientation = OrientationModel.get(
                orientationId	: attributes.orientation_id		
            );
			attributes.orientation_head = get_orientation.ORIENTATION_HEAD;
			attributes.emp_id = get_orientation.ATTENDER_EMP;
			attributes.emp_name = get_emp_info(get_orientation.attender_emp,0,0);
			attributes.trainer_emp_id = get_orientation.trainer_emp;
			attributes.trainer_emp_name = get_emp_info(get_orientation.trainer_emp,0,0);
			attributes.start_date = dateformat(get_orientation.start_date,'dd/mm/yyyy');
			attributes.finish_date = dateformat(get_orientation.finish_date,'dd/mm/yyyy');
			attributes.detail = get_orientation.DETAIL;
        </cfscript>
    </cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TRAINING_ORIENTATION';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ORIENTATION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-orientation_head','item-emp_name','item-start_date','item-finish_date']";
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn;
		
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_orientation';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_orientation.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.list_orientation';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/formOrientation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_orientation&event=upd&orientation_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'orientation';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'validate().check()';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.list_orientation';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/formOrientation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_orientation&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'orientation_id=##attributes.orientation_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_orientation.orientation_id##';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'orientation';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_orientation';
	
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'validate().check()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.list_orientation&orientation_id=#attributes.orientation_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_orientation';
	}
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=hr.list_orientation&event=add','page');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))
	{
		attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
		if (len(attributes.keyword))
			url_str = "#url_str#&keyword=#attributes.keyword#";
		if (isdefined('attributes.is_filtered'))
			url_str = "#url_str#&is_filtered=#attributes.is_filtered#";
		if (len(attributes.startdate))
			url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#";
		if (len(attributes.finishdate))
			url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#";
	}
</cfscript>

<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1>
	<cfif isdefined("attributes.event") and listFindNoCase('add,upd',attributes.event,',')>
		<cfif len(attributes.start_date)>
            <cf_date tarih="attributes.start_date">
        </cfif>    
        <cfif len(attributes.finish_date)>
            <cf_date tarih="attributes.finish_date">
        </cfif>
		<cfif attributes.event is 'add'>
        	<cfscript>
				add = OrientationModel.add (
					orientation_head	: attributes.orientation_head,
					detail 				: attributes.detail,
					start_date			: attributes.start_date,
					finish_date 		: attributes.finish_date,
					emp_id 				: attributes.emp_id,
					emp_name			: attributes.emp_name,
					trainer_emp_id		: attributes.trainer_emp_id,
					trainer_emp_name	: attributes.trainer_emp_name
					);
					attributes.actionId = add;
			</cfscript>
        <cfelse>
        	<cfscript>
				upd = OrientationModel.upd (
					orientation_head	: attributes.orientation_head,
					detail 				: attributes.detail,
					start_date			: attributes.start_date,
					finish_date 		: attributes.finish_date,
					emp_id 				: attributes.emp_id,
					emp_name			: attributes.emp_name,
					trainer_emp_id		: attributes.trainer_emp_id,
					trainer_emp_name	: attributes.trainer_emp_name,
					orientation_id		: attributes.orientation_id	
					);
					attributes.actionId = upd;
			</cfscript>
         </cfif>
	<cfelseif isdefined("attributes.event") and attributes.event is 'del'>
    	<cfscript>
			del = OrientationModel.del (
				orientation_id		: attributes.orientation_id	
				);
				attributes.actionId = del;
		</cfscript>
    </cfif>
</cfif>