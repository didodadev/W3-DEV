<cfif not isdefined("attributes.keyword")>
	<cfset filtered = 0>
<cfelse>
	<cfset filtered = 1>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.in_status" default="">
<cfparam name="attributes.date_status" default="1">
<cfparam name="attributes.commethod_id" default="0">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.notice_cat_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<!--- <cfparam name="attributes.process_stage" default=""> &process_stage=#attributes.process_stage#--->
<cfscript>
	attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
	url_str = "";
	url_str = "#url_str#&keyword=#attributes.keyword#&status=#attributes.status#&date_status=#attributes.date_status#&commethod_id=#attributes.commethod_id#&company_id=#attributes.company_id#&company=#attributes.company#&in_status=#attributes.in_status#";
	if (isdefined("attributes.notice_head") and isdefined("attributes.notice_id") and len(attributes.notice_head))
		url_str = "#url_str#&notice_id=#attributes.notice_id#&notice_head=#attributes.notice_head#";
	if (isdate(attributes.start_date))
    	url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#";
    if (isdate(attributes.finish_date))
    	url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#";
	if (filtered)
	{
		cmp_app = createObject("component","V16.hr.cfc.get_app");
		cmp_app.dsn = dsn;
		get_apps = cmp_app.get_app(
			start_date: attributes.start_date,
			finish_date: attributes.finish_date,
			keyword: attributes.keyword,
			commethod_id: attributes.commethod_id,
			status: attributes.status,
			company_id: '#iif(len(attributes.company_id) and len(attributes.company),"attributes.company_id",DE(""))#',
			process_stage: '#iif(isdefined("attributes.process_stage") and len(attributes.process_stage),"attributes.process_stage",DE(""))#',
			department_id: '#iif(isdefined("attributes.department_id") and len(attributes.department_id) and isdefined("attributes.department") and len(attributes.department),"attributes.department_id",DE(""))#',
			branch_id: '#iif(isdefined("attributes.branch") and len(attributes.branch) and isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#',
			our_company_id: '#iif(isdefined("attributes.our_company_id") and len(attributes.our_company_id),"attributes.our_company_id",DE(""))#',
			notice_id: '#iif(isdefined("attributes.notice_id") and len(attributes.notice_id) and isdefined("attributes.notice_head") and len(attributes.notice_head),"attributes.notice_id",DE(""))#',
			in_status: attributes.in_status,
			notice_cat_id: attributes.notice_cat_id,
			date_status: attributes.date_status,
			maxrows: attributes.maxrows,
			startrow: attributes.startrow
		);
	}
	else
		get_apps.recordcount = 0;
	cmp_notice_group = createObject("component","V16.hr.cfc.get_notice_groups");
	cmp_notice_group.dsn = dsn;
	get_notice_groups = cmp_notice_group.get_notice_group();
	cmp_notice = createObject("component","V16.hr.cfc.get_noticess");
	cmp_notice.dsn = dsn;
	get_noticess = cmp_notice.get_notice();
	notice_list="";
	notice_cat_list="";
</cfscript>

<cfoutput query="GET_NOTICESS">
	<cfset notice_list=listappend(notice_list,NOTICE_ID,',')>
	<cfset notice_list=listappend(notice_list,NOTICE_NO,',')>
	<cfset notice_list=listappend(notice_list,NOTICE_HEAD,',')>
	<cfset notice_cat_list = ListAppend(notice_cat_list,NOTICE_CAT_ID)>
</cfoutput>
<cfif len(notice_cat_list)>
	<cfset notice_cat_list=listsort(notice_cat_list,"numeric","ASC",",")>
	<cfquery name="get_notice_groups_" dbtype="query">
		SELECT
			NOTICE_CAT_ID,NOTICE
		FROM
			get_notice_groups
		WHERE
			NOTICE_CAT_ID IN (#notice_cat_list#)
		ORDER BY
			NOTICE_CAT_ID
	</cfquery>
	<cfset notice_cat_list = listsort(listdeleteduplicates(valuelist(get_notice_groups_.NOTICE_CAT_ID,',')),'numeric','ASC',',')>
</cfif>
<cfinclude template="../query/get_commethods.cfm">

<cfparam name="attributes.totalrecords" default='#get_apps.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_app" action="#request.self#?fuseaction=hr.apps" method="post">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="date_status" id="date_status">
                        <option value="1" <cfif attributes.date_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                        <option value="2" <cfif attributes.date_status eq 2>selected</cfif>><cf_get_lang dictionary_id ='57925.Artan Tarih'></option>
                        <option value="3" <cfif attributes.date_status eq 3>selected</cfif>><cf_get_lang dictionary_id ='56506.Azalan Kayıt No'></option>
                        <option value="4" <cfif attributes.date_status eq 4>selected</cfif>><cf_get_lang dictionary_id ='56507.Artan Kayıt No'></option>
                        <option value="5" <cfif attributes.date_status eq 5>selected</cfif>><cf_get_lang dictionary_id ='56508.Alfabetik Azalan'></option>
                        <option value="6" <cfif attributes.date_status eq 6>selected</cfif>><cf_get_lang dictionary_id ='56509.Alfabetik Artan'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="status" id="status">
                        <option value="" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button button_type="4" search_function="date_check(list_app.start_date,list_app.finish_date,'#message_date#')">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-notice_cat_id">
                        <label class="col col-12"><cf_get_lang dictionary_id ='56510.İlan Grubu'></label>
                        <div class="col col-12">
                            <select name="notice_cat_id" id="notice_cat_id" style="width:170px;">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="get_notice_groups">
                                    <option value="#notice_cat_id#"<cfif attributes.notice_cat_id eq notice_cat_id>selected</cfif>>#notice#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-commethod_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
                        <div class="col col-12">
                            <cfset commethod_list="">
                            <select name="commethod_id" id="commethod_id">
                                <option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="get_commethods">
                                    <option value="#commethod_id#" <cfif attributes.commethod_id eq commethod_id>selected</cfif>>#commethod#</option>
                                    <cfset commethod_list=ListAppend(commethod_list,commethod_id,',')>
                                    <cfset commethod_list=ListAppend(commethod_list,commethod,',')>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-notice_head">
                        <label class="col col-12"><cf_get_lang dictionary_id='55174.İK İlanları'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="notice_id" id="notice_id" value="<cfif IsDefined('attributes.notice_head') and len(attributes.notice_head) and len(attributes.notice_id)><cfoutput>#attributes.notice_id#</cfoutput></cfif>">
                                <input type="text" name="notice_head" id="notice_head" value="<cfif IsDefined('attributes.notice_head') and len(attributes.notice_head)><cfoutput>#attributes.notice_head#</cfoutput></cfif>" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=list_app.notice_id&field_name=list_app.notice_head','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-in_status">
                        <label class="col col-12"><cf_get_lang dictionary_id='58561.İç'> / <cf_get_lang dictionary_id='58562.Dış'></label>
                        <div class="col col-12">
                            <select name="in_status" id="in_status">
                                <option value="" <cfif attributes.in_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1" <cfif attributes.in_status eq 1>selected</cfif>><cf_get_lang dictionary_id='58561.İç'></option>
                                <option value="0" <cfif attributes.in_status eq 0>selected</cfif>><cf_get_lang dictionary_id='58562.Dış'></option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-company">
                        <label class="col col-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <cf_wrk_members form_name='list_app' member_name='company' company_id='company_id' select_list='2'>
                                <input type="text" name="company" id="company" style="width:120px;" onkeyup="get_member();" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=list_app.company&field_comp_id=list_app.company_id&select_list=2&keyword='+encodeURIComponent(document.list_app.company.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-start_date">
                        <label class="col col-12"><cf_get_lang dictionary_id="57699.Baş.Tarihi"> - <cf_get_lang dictionary_id="57700.Bitiş Tarihi"></label>
                        <div class="col col-12">
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.başlama tarihi'></cfsavecontent>
                                    <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:67px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                </div>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
                                    <span class="input-group-addon no-bg"></span>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.bitiş tarihi'></cfsavecontent>
                                    <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:67px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfform name="setProcessForm" id="setProcessForm" method="post" action="">
        <cf_box title="#getLang(774,'Başvuralar',58186)#" uidrop="1" hide_table_column="1">
            <cf_grid_list> 
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th><cf_get_lang dictionary_id='46835.İlanlar'></th>
                        <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                        <th><cf_get_lang dictionary_id ='56510.İlan Grubu'></th>
                        <th><cf_get_lang dictionary_id='55745.Yaş'></th>
                        <th><cf_get_lang dictionary_id='57709.Okul'></th>
                        <th><cf_get_lang dictionary_id='57995.Bölüm'></th>
                        <th><cf_get_lang dictionary_id='55912.Son Tecrübe'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>		
                        <th width="20" class="header_icn_none text-center"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_apps.recordcount>
                        <cfoutput query="get_apps" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	
                        <cfif len(POSITION_CAT_ID)>
                            <cfset attributes.position_cat_id = get_apps.POSITION_CAT_ID>
                            <cfinclude template="../query/get_position_cat.cfm">
                            <cfset position_cat = "#GET_POSITION_CAT.POSITION_CAT#">
                        <cfelse>
                            <cfset attributes.position_cat_id = "">
                            <cfset position_cat = "">
                        </cfif>	
                        <cfset attributes.COMMETHOD_ID = COMMETHOD_ID>
                        <cfset attributes.step_no = step_no>
                            <tr>
                                <td>#currentrow#</td>
                                <td>#dateformat(app_date,dateformat_style)#</td>
                                <td><a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#empapp_id#" class="tableyazi">#name# #surname#</a></td>
                                <td><cfif len(notice_id)>
                                        <a href="#request.self#?fuseaction=hr.list_notice&event=upd&notice_id=#notice_id#" class="tableyazi">#notice_no#-#notice_head#</a>
                                    </cfif>
                                </td>
                                <td>#position_cat#</td>
                                <td><cfif len(notice)>#notice#<cfelse>--</cfif></td>
                                <td><cfif len(birth_date)>
                                        <cfset yas = datediff("yyyy",birth_date,now())>
                                        <cfif yas neq 0>#yas#</cfif>	
                                    </cfif>
                                </td>
                                <td><cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
                                        SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EDU_START DESC
                                    </cfquery>
                                    <cfif get_app_edu_info.recordcount> #get_app_edu_info.edu_name#</cfif>
                                </td>
                                <td nowrap="nowrap"><cfif get_app_edu_info.recordcount>#get_app_edu_info.edu_part_name#</cfif></td>
                                <td nowrap="nowrap"><cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
                                        SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #empapp_id# ORDER BY EXP_START DESC
                                    </cfquery>
                                    <cfif get_app_work_info.recordcount>
                                        #get_app_work_info.exp#-#get_app_work_info.exp_position#-#dateformat(get_app_work_info.exp_finish,'mm/yyyy')#
                                    </cfif>
                                </td>
                                <td><cfif app_pos_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                                <!-- sil -->
                                <td><a href="#request.self#?fuseaction=hr.apps&event=upd&empapp_id=#empapp_id#&app_pos_id=#app_pos_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#app_pos_id#&print_type=171','print_page','workcube_print');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
                                <!-- sil -->
                            </tr>
                        </cfoutput>
                        <cfelse>
                            <tr>
                                <cfif filtered><td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td><cfelse><td colspan="12"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td></cfif>
                            </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
            <cfif attributes.totalrecords gt attributes.maxrows>  
                <cf_paging 
                    name="setProcessForm"
                    page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="hr.apps#url_str#"
                    is_form="1">
            </cfif>
        </cf_box>
    </cfform>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
