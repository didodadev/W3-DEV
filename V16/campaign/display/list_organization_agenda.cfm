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

<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="organization_list" method="post" action="#request.self#?fuseaction=campaign.list_organization_agenda">
            <input type="hidden" name="ay" id="ay" value="<cfif isdefined('attributes.ay')><cfoutput>#attributes.ay#</cfoutput><cfelse><cfoutput>#Month(now())#</cfoutput></cfif>">
            <input type="hidden" name="yil" id="yil" value="<cfif isdefined('attributes.yil')><cfoutput>#attributes.yil#</cfoutput><cfelse><cfoutput>#Year(now())#</cfoutput></cfif>">
            <cf_box_search more="0">
                   <!---  <cfif attributes.page_type eq 1>
                        <div class="form-group">
                            <div class="input-group">
                               <label><a href="<cfoutput>#yer#&ay=#ay#&yil=#oncekiyil#</cfoutput>"><img src="/images/previous20.gif" alt=""></a><cfoutput>#Year(tarih)#</cfoutput><a href="<cfoutput>#yer#&ay=#ay#&yil=#sonrakiyil#</cfoutput>"><img src="/images/next20.gif" border="0" alt="" align="absmiddle"></a></label>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <span class="input-group-addon no-bg"><a href="<cfoutput>#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif></cfoutput>"><img src="/images/previous20.gif" alt=""></a></span>
                                <span class="input-group-addon no-bg"><cfoutput>#ListGetAt(aylar,Month(tarih))#</cfoutput></span>
                                <span class="input-group-addon no-bg"><a href="<cfoutput>#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif></cfoutput>"><img src="/images/next20.gif" alt="" ></a></span>
                            </div>
                        </div>
                    </cfif> --->
                    <div class="form-group">
                        <div class="input-group">
                            <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">
                            <input type="hidden" name="par_id" id="par_id" value="<cfoutput>#attributes.par_id#</cfoutput>">
                            <input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#attributes.cons_id#</cfoutput>"> 
                            <input type="hidden" name="member_type" id="member_type" value="<cfoutput>#attributes.member_type#</cfoutput>">
                            <input type="text" name="emp_par_name" id="emp_par_name" value="<cfoutput>#attributes.emp_par_name#</cfoutput>" style="width:150;" placeholder="<cf_get_lang dictionary_id='49714.Etkinlik Yetkilisi'>">
                            <span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='49714.Etkinlik Yetkilisi'>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=organization_list.emp_id&field_name=organization_list.emp_par_name&field_type=organization_list.member_type&field_partner=organization_list.par_id&field_consumer=organization_list.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','list');"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <cfsavecontent variable="text"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
                        <cf_wrk_combo 
                            query_name="GET_ORGANIZATION_CAT" 
                            name="organization_cat_id" 
                            option_value="organization_cat_id" 
                            option_name="organization_cat_name"
                            option_text="#text#"
                            value="#iif(isdefined("attributes.organization_cat_id"),'attributes.organization_cat_id',DE(''))#"
                            width=120>
                    </div>
                    <div class="form-group">
                        <select name="branch_id" id="branch_id">
                            <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                            <cfoutput query="get_branchs">
                            <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="page_type"  id="page_type" style="width:60px">
                            <option value="0" <cfif attributes.page_type eq 0> selected="selected"</cfif>><cf_get_lang dictionary_id='58458.Haftalık'></option>
                            <option value="1" <cfif attributes.page_type eq 1> selected="selected"</cfif>><cf_get_lang dictionary_id='58932.Aylık'></option>
                            <option value="2" <cfif attributes.page_type eq 2> selected="selected"</cfif>><cf_get_lang dictionary_id='29400.Yıllık'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <select name="is_active" id="is_active">
                            <option value=""<cfif not len (attributes.is_active)>selected="selected"</cfif>><cf_get_lang dictionary_id="57708.Tümü"></option>
                            <option value="1" <cfif attributes.is_active eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="57493.Aktif"></option>
                            <option value="0"<cfif attributes.is_active eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="57494.Pasif"></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                       <!---  <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
                    </div>
                </cf_box_search>
        </cfform>
    </cf_box>

    <cf_box title="#getLang('','Etkinlik Takvimi','49711')#" hide_table_column="1" uidrop="1">   
        <cfform name="organization_list_data" method="post" action="#request.self#?fuseaction=campaign.list_organization_agenda">
            <input type="hidden" name="ay" id="ay" value="<cfif isdefined('attributes.ay')><cfoutput>#attributes.ay#</cfoutput><cfelse><cfoutput>#Month(now())#</cfoutput></cfif>">
            <input type="hidden" name="yil" id="yil" value="<cfif isdefined('attributes.yil')><cfoutput>#attributes.yil#</cfoutput><cfelse><cfoutput>#Year(now())#</cfoutput></cfif>">
        </cfform>
        <cf_box_search more="0">
            <cfif attributes.page_type eq 1>
                <div class="form-group">
                    <div class="input-group">
                    <span class="input-group-addon no-bg"><a href="<cfoutput>#yer#&ay=#ay#&yil=#oncekiyil#</cfoutput>"><i class="fa fa-caret-left"></i></a></span>
                    <span class="input-group-addon no-bg"><cfoutput>#Year(tarih)#</cfoutput></span>
                    <span class="input-group-addon no-bg"><a href="<cfoutput>#yer#&ay=#ay#&yil=#sonrakiyil#</cfoutput>"><i class="fa fa-caret-right"></i></a></span>
                   </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-addon no-bg"><a href="<cfoutput>#yer#&ay=#oncekiay#&yil=<cfif ay eq 1>#oncekiyil#<cfelse>#yil#</cfif></cfoutput>"><i class="fa fa-caret-left"></i></a></span>
                        <span class="input-group-addon no-bg"><cfoutput>#ListGetAt(aylar,Month(tarih))#</cfoutput></span>
                        <span class="input-group-addon no-bg"><a href="<cfoutput>#yer#&ay=#sonrakiay#&yil=<cfif ay eq 12>#sonrakiyil#<cfelse>#yil#</cfif></cfoutput>"><i class="fa fa-caret-right"></i></a></span>
                    </div>
                </div>
            </cfif>
        </cf_box_search>
    <cfif attributes.page_type eq 2>
        <cfinclude template="list_organization_agenda_yearly.cfm">
    <cfelseif attributes.page_type eq 1>
        <cfinclude template="list_organization_agenda_monthly.cfm">
    <cfelseif attributes.page_type eq 0>
        <cfinclude template="list_organization_agenda_weekly.cfm">
    </cfif>
    </cf_box>
</div>