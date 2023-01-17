<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.member_type" default="">
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
<cfinclude template="../query/get_departments.cfm">
<cfinclude template="../query/get_position_cats.cfm">
<cfquery name="GET_TRAINING_CAT" datasource="#DSN#">
	SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT ORDER BY TRAINING_CAT
</cfquery>
<cfquery name="GET_TRAINING_SEC" datasource="#DSN#">
	SELECT TRAINING_SEC_ID,SECTION_NAME FROM TRAINING_SEC ORDER BY SECTION_NAME
</cfquery>
<cfsavecontent variable="ay1"><cf_get_lang dictionary_id ='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id ='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id ='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id ='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id ='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id ='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id ='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id ='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id ='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id ='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id ='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id ='57603.Aralık'></cfsavecontent>
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
	yer = '#request.self#?fuseaction=training_management.list_class_agenda&page_type=1';
	attributes.to_day = CreateODBCDatetime('#yil#-#ay#-#gun#');
</cfscript>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.POSITION_CODE#">)
	ORDER BY 
		BRANCH_ID
</cfquery>
<cfsavecontent variable="txt">
	<cfif attributes.page_type eq 1>
		<cfoutput>
            <a href="#yer#&ay=#ay#&yil=#oncekiyil#"><img src="/images/previous20.gif" border="0" align="absmiddle"></a>
            #Year(tarih)#
            <a href="#yer#&ay=#ay#&yil=#sonrakiyil#"><img src="/images/next20.gif" border="0" align="absmiddle"></a>
            <a href="#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif>"><img src="/images/previous20.gif" border="0" align="absmiddle"></a>
            #ListGetAt(aylar,Month(tarih))#
            <a href="#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif>"><img src="/images/next20.gif" border="0" align="absmiddle"></a>
        </cfoutput>
    </cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form1" method="post" action="#request.self#?fuseaction=training_management.list_class_agenda">
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="place"><cf_get_lang dictionary_id='46230.Eğitimci'></cfsavecontent>
                        <cf_wrk_employee_positions form_name='form1' emp_id='emp_id' emp_name='member_name'>
                        <cfinput type="text" name="member_name" value="#attributes.member_name#" placeholder="#place#" onKeyUp="get_emp_pos_1();" style="width:110px;">
                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form1.emp_id&field_name=form1.member_name&field_type=form1.member_type&field_partner=form1.par_id&field_consumer=form1.cons_id&select_list=1,2,3&keyword='+encodeURIComponent(document.form1.member_name.value)</cfoutput>)"></span>
                        <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">
                        <input type="hidden" name="par_id" id="par_id" value="<cfoutput>#attributes.par_id#</cfoutput>">
                        <input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#attributes.cons_id#</cfoutput>">
                        <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                    </div>
                </div>
                <div class="form-group">
                    <select name="training_cat_id" id="training_cat_id">
                        <option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
                        <cfoutput query="get_training_cat">
                            <option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and (attributes.training_cat_id eq training_cat_id)> selected</cfif>>#training_cat#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="training_sec_id" id="training_sec_id">
                        <option value=""><cf_get_lang dictionary_id='57995.Bölüm'></option>
                        <cfoutput query="get_training_sec">
                            <option value="#training_sec_id#" <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id eq training_sec_id)> selected</cfif>>#section_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id ='57453.Şube'></option>
                        <cfoutput query="get_branchs">
                            <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="page_type" id="page_type" style="width:60px">
                        <option value="0" <cfif attributes.page_type eq 0> selected</cfif>><cf_get_lang dictionary_id ='58458.Haftalık'></option>
                        <option value="1" <cfif attributes.page_type eq 1> selected</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
                        <option value="2" <cfif attributes.page_type eq 2> selected</cfif>><cf_get_lang dictionary_id='29400.Yıllık'></option>
                    </select>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box>
        <cfoutput>#txt#</cfoutput>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='58043.Eğitim Ajandası'></cfsavecontent>
    <cf_box title="#head#">
        <cf_grid_list>
            <cfif attributes.page_type eq 2>
                <cfinclude template="list_class_agenda_yearly.cfm">
            <cfelseif attributes.page_type eq 1>
                <cfinclude template="list_class_agenda_monthly.cfm">
            <cfelseif attributes.page_type eq 0>
                <cfinclude template="list_class_agenda_weekly.cfm">
            </cfif>
        </cf_grid_list>
    </cf_box>
</div>

