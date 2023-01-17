<cfparam name="is_filtered" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.record_date2" default="">
<cfparam name="attributes.list_stage" default="">
<cfscript>
	cmp_process = createObject("component","V16.hr.cfc.get_process_rows");
	cmp_process.dsn = dsn;
	get_process_type = cmp_process.get_process_type_rows(
		faction: "%hr.emp_app_select_list%"
	);
</cfscript>
<cfif is_filtered>
	<cfif isdate(attributes.record_date)>
		<cf_date tarih = "attributes.record_date">
	</cfif>
	<cfif isdate(attributes.record_date2)>
		<cf_date tarih = "attributes.record_date2">
	</cfif>
	<cfquery name="get_list" datasource="#dsn#">
		SELECT
			EL.LIST_ID,
			EL.LIST_NAME,
			EL.LIST_DETAIL,
			EL.LIST_STATUS,
			EL.NOTICE_ID,
			EL.OUR_COMPANY_ID,
			EL.DEPARTMENT_ID,
			EL.BRANCH_ID,
			EL.COMPANY_ID,
			EL.RECORD_DATE,
			EL.RECORD_EMP,
			EL.SEL_LIST_STAGE,
			COUNT(ER.LIST_ROW_ID) SATIR_SAYISI
		FROM
			EMPLOYEES_APP_SEL_LIST EL,
			EMPLOYEES_APP_SEL_LIST_ROWS ER
		WHERE
			ER.LIST_ID = EL.LIST_ID
			<cfif isdefined("list_authority")><!---myhome da yetkisi olan listeleri görsün--->
				AND EL.LIST_ID IN (#list_authority#)
			</cfif>
			<cfif len(attributes.keyword)>
				AND EL.LIST_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
			</cfif>
			<cfif len(attributes.status)>
				AND EL.LIST_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status#">
			</cfif>
			<cfif isdefined('attributes.notice_head') and len(attributes.notice_head) and len(attributes.notice_id)>
				AND EL.NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
			</cfif>
			<cfif isdefined('attributes.company_id') and isdefined('attributes.company') and len(attributes.company)>
				AND EL.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif isdefined('attributes.branch_id') and isdefined('attributes.branch') and len(attributes.branch)>
				AND EL.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			<cfif isdefined('attributes.position_cat') and isdefined('attributes.position_cat_id') and len(attributes.position_cat)>
				AND EL.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
			</cfif>
			<cfif isdefined('attributes.position') and isdefined('attributes.position_id') and len(attributes.position)>
				AND EL.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">
			</cfif>
			<cfif isdate(attributes.record_date)>
				AND EL.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
			</cfif>
			<cfif isdate(attributes.record_date2)>
				AND EL.RECORD_DATE < #CreateODBCDateTime(DATEADD("d",1,attributes.record_date2))#
			</cfif>
            <cfif len(attributes.list_stage)>
				AND EL.SEL_LIST_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_stage#">
			</cfif>
		GROUP BY
			EL.LIST_ID,
			EL.LIST_NAME,
			EL.LIST_DETAIL,
			EL.LIST_STATUS,
			EL.NOTICE_ID,
			EL.OUR_COMPANY_ID,
			EL.DEPARTMENT_ID,
			EL.BRANCH_ID,
			EL.COMPANY_ID,
			EL.RECORD_DATE,
			EL.RECORD_EMP,
			EL.SEL_LIST_STAGE
		ORDER BY 
			EL.RECORD_DATE DESC 
	</cfquery>
<cfelse>
	<cfset get_list.recordcount = 0>
</cfif>
<cfif isdate(attributes.record_date)>
	<cfset attributes.record_date = dateformat(attributes.record_date, dateformat_style)>
<cfelse>
	<cfset attributes.record_date =''>
</cfif>
<cfif isdate(attributes.record_date2) and isdate(attributes.record_date2)>
	<cfset attributes.record_date2 = dateformat(attributes.record_date2, dateformat_style)>
<cfelse>
	<cfset attributes.record_date2 =''>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default=#get_list.recordcount#>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_app" action="#request.self#?fuseaction=hr.emp_app_select_list" method="post">
            <input type="hidden" name="is_filtered" id="is_filtered" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#getlang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="place"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi"></cfsavecontent>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58566.Kayıt Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="record_date" id="record_date" placeholder="#place#" value="#attributes.record_date#" validate="#validate_style#" maxlength="10" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="place2"><cf_get_lang dictionary_id="57700.Bitiş Tarihi"></cfsavecontent>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58566.Kayıt Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="record_date2" id="record_date2" placeholder="#place2#" value="#attributes.record_date2#" validate="#validate_style#" maxlength="10" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="record_date2"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="list_stage" id="list_stage">
                        <option value=""><cf_get_lang dictionary_id='58859.Süreç'></option>
                        <cfoutput query="get_process_type">
                            <option value="#process_row_id#"<cfif attributes.list_stage eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="status" id="status">
                        <option value="" <cfif not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
                        <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                        <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button search_function="date_check(list_app.record_date,list_app.record_date2,'#message_date#')" button_type="4">
                </div>
                <div class="form-group">
					<a class="ui-btn ui-btn-gray" target="_blank" href="<cfoutput>#request.self#?fuseaction=hr.search_app</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a> 
				</div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-notice_head">
                        <label class="col col-12"><cf_get_lang dictionary_id='31334.ilan'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="notice_id" id="notice_id" value="<cfif isdefined('attributes.notice_head') and IsDefined('attributes.notice_id') and len(attributes.notice_id)><cfoutput>#attributes.notice_id#</cfoutput></cfif>">
                                <input type="text" name="notice_head" id="notice_head" value="<cfif isdefined('attributes.notice_head')><cfoutput>#attributes.notice_head#</cfoutput></cfif>">            	
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_notices&field_id=list_app.notice_id&field_name=list_app.notice_head','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-position">
                        <label class="col col-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="Hidden" name="position_id" id="position_id" value="<cfif isdefined('attributes.position') and len(attributes.position)><cfoutput>#attributes.position_id#</cfoutput></cfif>" maxlength="50">
                                <input type="text" name="position" id="position" value="<cfif isdefined('attributes.position')><cfoutput>#attributes.position#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=list_app.position_id&field_pos_name=list_app.position&show_empty_pos=1','list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-company">
                        <label class="col col-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <cf_wrk_members form_name='list_app' member_name='company' company_id='company_id' select_list='2'>
                                <input type="text" name="company" id="company" onkeyup="get_member();" value="<cfif isdefined("attributes.company_id") and isdefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=list_app.company&field_comp_id=list_app.company_id&select_list=2&keyword='+encodeURIComponent(document.list_app.company.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-branch">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
                                <input type="text" name="branch" id="branch" value="<cfif IsDefined('attributes.branch') and len(attributes.branch)><cfoutput>#attributes.branch#</cfoutput></cfif>" >
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_name=list_app.branch&field_branch_id=list_app.branch_id</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-position_cat">
                        <label class="col col-12"><cf_get_lang dictionary_id ='59004.Pozisyon Tipi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="Hidden" name="position_cat_id" id="position_cat_id" value="<cfif isdefined('attributes.position_cat') and len(attributes.position_cat)><cfoutput>#attributes.position_cat_id#</cfoutput></cfif>">
                                <input type="text" name="position_cat" id="position_cat"  value="<cfif isdefined('attributes.position_cat')><cfoutput>#attributes.position_cat#</cfoutput></cfif>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_position_cats&field_cat_id=list_app.position_cat_id&field_cat=list_app.position_cat','list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id ='31337.Seçim Listeleri'></cfsavecontent>    
    <cf_box title="#title#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57509.Liste'></th>
                    <th><cf_get_lang dictionary_id='56213.Aday'> <cf_get_lang dictionary_id ='39852.Sayısı'></th>
                    <th><cf_get_lang dictionary_id='55159.İlan'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57585.Kurumsal Üye'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=hr.search_app</cfoutput>" target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_list.recordcount>
                    <cfset record_emp_list = ''>
                    <cfset notice_list = ''>
                    <cfset branch_list = ''>
                    <cfset company_list = ''>
                    <cfset stage_id_list = ''>
                    <cfoutput query="get_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif not listfind(record_emp_list,get_list.record_emp)>
                            <cfset record_emp_list = listappend(record_emp_list,get_list.record_emp)>
                        </cfif> 
                        <cfif not listfind(notice_list,get_list.notice_id)>
                            <cfset notice_list = listappend(notice_list,get_list.notice_id)>
                        </cfif>
                        <cfif not listfind(branch_list,get_list.branch_id)>
                            <cfset branch_list = listappend(branch_list,get_list.branch_id)>
                        </cfif>
                        <cfif not listfind(company_list,get_list.company_id)>
                            <cfset company_list = listappend(company_list,get_list.company_id)>
                        </cfif>
                        <cfif not listfind(stage_id_list,get_list.SEL_LIST_STAGE)>
                            <cfset stage_id_list = listappend(stage_id_list,get_list.SEL_LIST_STAGE)>
                        </cfif>
                    </cfoutput>
                    <cfif len(record_emp_list)>
                        <cfset record_emp_list = listsort(record_emp_list,"numeric","ASC",",")>
                        <cfquery name="get_emp_detail" datasource="#dsn#">
                            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
                        </cfquery>
                    </cfif>
                    <cfif len(notice_list )>
                        <cfset notice_list = listsort(notice_list, "numeric","ASC",",")>
                        <cfquery name="get_notice" datasource="#dsn#">
                            SELECT NOTICE_HEAD,NOTICE_NO FROM NOTICES WHERE NOTICE_ID IN (#notice_list#) ORDER BY NOTICE_ID
                        </cfquery>
                    </cfif>
                    <cfif len(branch_list)>
                        <cfset branch_list = listsort(branch_list,"numeric","ASC",",")>
                        <cfquery name="get_branch" datasource="#dsn#">
                            SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_list#) ORDER BY BRANCH_ID
                        </cfquery>
                    </cfif>
                    <cfif len(company_list)>
                        <cfset company_list = listsort(company_list,"NUMERIC","ASC",",")>
                        <cfquery name="get_company" datasource="#dsn#">
                            SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
                        </cfquery>
                    </cfif>
                    <cfif len(stage_id_list)>
                        <cfset stage_id_list = listsort(stage_id_list,"NUMERIC","ASC",",")>
                        <cfquery name="get_stage_name" dbtype="query">
                            SELECT STAGE FROM GET_PROCESS_TYPE WHERE PROCESS_ROW_ID IN (#stage_id_list#) ORDER BY PROCESS_ROW_ID
                        </cfquery>
                    </cfif>
                    <cfoutput query="get_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=hr.emp_app_select_list&event=det&list_id=#get_list.list_id#" class="tableyazi">#get_list.list_name# </a></td>
                            <td>#get_list.SATIR_SAYISI#</td>
                            <td><cfif len(get_list.notice_id)>#get_notice.NOTICE_NO[listfind(notice_list,NOTICE_ID,',')]#/#get_notice.NOTICE_HEAD[listfind(notice_list,NOTICE_ID,',')]#</cfif></td>
                            <td><cfif len(get_list.department_id) and len(get_list.our_company_id) and len(branch_list)>#get_branch.BRANCH_NAME[listfind(branch_list,BRANCH_ID,',')]#</cfif></td>
                            <td><cfif len(get_list.company_id)>#get_company.FULLNAME[listfind(company_list,company_id,',')]#</cfif></td>
                            <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#record_emp#','medium');">#get_emp_detail.EMPLOYEE_NAME[listfind(record_emp_list,RECORD_EMP,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(record_emp_list,RECORD_EMP,',')]#</a></td>
                            <td>#dateformat(get_list.record_date,dateformat_style)#</td>
                            <td>#get_stage_name.STAGE[listfind(stage_id_list,get_list.SEL_LIST_STAGE,',')]#</td>
                            <td><cfif get_list.list_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                            <td style="text-align:center;"><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=hr.emp_app_select_list&event=upd&list_id=#get_list.list_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="10"><cfif is_filtered><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                        </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset url_str = "">
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#&status=#attributes.status#">
        <cfscript>
            if (isdefined('attributes.company') and len(attributes.company)) 
                url_str="#url_str#&company_id=#attributes.company_id#";
            if (isdefined('attributes.notice_head') and len(attributes.notice_head))
                url_str="#url_str#&notice_head=#attributes.notice_head#&notice_id=#attributes.notice_id#";
            if (isdefined('attributes.branch') and len(attributes.branch))
                url_str="#url_str#&branch=#attributes.branch#&branch_id=#attributes.branch_id#";
            if (isdefined('attributes.position') and len(attributes.position))
                url_str="#url_str#&position=#attributes.position#&position_id=#attributes.position_id#";
            if (isdefined('attributes.position_cat') and len(attributes.position_cat))
                url_str="#url_str#&position_cat=#attributes.position_cat#&position_cat_id=#attributes.position_cat_id#";
            if (len('attributes.record_date'))
                url_str="#url_str#&record_date=#attributes.record_date#";
            if (len('attributes.record_date2'))
                url_str="#url_str#&record_date2=#attributes.record_date2#";
            if (isdefined('attributes.is_filtered'))
                url_str="#url_str#&is_filtered=#attributes.is_filtered#";
            if (len('attributes.list_stage'))
                url_str="#url_str#&list_stage=#attributes.list_stage#";
        </cfscript>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="hr.emp_app_select_list#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>