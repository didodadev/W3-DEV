<cf_xml_page_edit fuseact="campaign.list_organization_agenda">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.emp_par_name" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.member_name" default="">
<cfif not isdefined("attributes.month_id")>
	<cfset attributes.month_id=dateformat(Now(),'m')>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.online)>
	<cfset url_str = "#url_str#&online=#attributes.online#">
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfif isDefined("attributes.training_sec_id")>
       <cfset url_str = "#url_str#&training_sec_id=#attributes.training_sec_id#">
    </cfif>
    <cfif isDefined("attributes.training_cat_id")>
       <cfset url_str = "#url_str#&training_cat_id=#attributes.training_cat_id#">
    </cfif>
    <cfif len(attributes.emp_id)>
        <cfset url_str= "#url_str#&emp_id=#attributes.emp_id#">
    </cfif>
    <cfif len(attributes.par_id)>
        <cfset url_str= "#url_str#&par_id=#attributes.par_id#">
    </cfif>
    <cfif len(attributes.cons_id)>
        <cfset url_str= "#url_str#&cons_id=#attributes.cons_id#">
    </cfif>
    <cfif len(attributes.branch_id)>
        <cfset url_str= "#url_str#&branch_id=#attributes.branch_id#">
    </cfif>
    <cfif len(attributes.member_type)>
        <cfset url_str= "#url_str#&member_type=#attributes.member_type#">
    </cfif>
    <cfif len(attributes.member_name)>
        <cfset url_str= "#url_str#&member_name=#attributes.member_name#">
    </cfif>
    <cfparam name="attributes.page_type" default="1">
    
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
</cfif>
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
	
	if (ay EQ 1)
		oncekiay=12;
	
	if (ay EQ 12)
		sonrakiay=1;
	aylar = '#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#';
	tarih = createDate(yil,ay,1);
	bas = DayofWeek(tarih)-1;
	if (bas EQ 0)
		bas=7;
	son = DaysinMonth(tarih);
	gun = 1;
	yer = '#request.self#?fuseaction=campaign.list_organization_agenda&page_type=1';
	attributes.to_day = CreateODBCDatetime('#yil#-#ay#-#gun#');
</cfscript>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.POSITION_CODE#"> 	
					)
	ORDER BY BRANCH_ID
</cfquery>

<cfscript>	
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_organization_agenda';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'campaign/display/list_organization_agenda.cfm';;
</cfscript>
