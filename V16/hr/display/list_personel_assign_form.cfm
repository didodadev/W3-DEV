<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.our_company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.position_cat" default="">
<cfparam name="attributes.process_status" default="">
<cfparam name="attributes.process_stage" default="">
<cfset NewDate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
<cfparam name="attributes.startdate" default="#DateFormat(DateAdd('d',-7,NewDate),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#DateFormat(DateAdd('d',1,NewDate),dateformat_style)#">
<cfif isDate(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
<cfquery name="get_process_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.from_add_personel_assign_form%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="get_our_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE <cfif Len(attributes.our_company_id)>COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#"> AND</cfif> BRANCH_STATUS =1 ORDER BY BRANCH_NAME
</cfquery>
<cfif Len(attributes.branch_id)>
	<cfquery name="get_our_department" datasource="#dsn#">
		SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
	</cfquery>
</cfif>
<cfif isDefined("attributes.is_filtered")>
	<cfquery name="get_form" datasource="#dsn#">
		SELECT
			*
		FROM
			PERSONEL_ASSIGN_FORM PAF,
			PROCESS_TYPE_ROWS PTR
		WHERE
			PAF.PER_ASSIGN_STAGE = PTR.PROCESS_ROW_ID AND
			PAF.PERSONEL_ASSIGN_ID IS NOT NULL
			<cfif Len(attributes.process_status)>
				AND ISNULL(PAF.IS_FINISHED,-1) = #attributes.process_status#
			</cfif>
			<cfif Len(attributes.process_stage)>
				AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
			</cfif>
			<cfif Len(attributes.our_company_id)>
				AND PAF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
			</cfif>
			<cfif Len(attributes.branch_id)>
				AND PAF.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			<cfif Len(attributes.department_id)>
				AND PAF.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			</cfif>
			<cfif len(attributes.position_cat) and len(attributes.position_cat_id)>
				AND PAF.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#">
			</cfif>
			<cfif Len(attributes.keyword)>
				AND 
				(
					<cfif isNumeric(attributes.keyword)>
						PAF.PERSONEL_ASSIGN_ID = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.keyword#"> OR
					</cfif>
					PAF.PERSONEL_ASSIGN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					PAF.PERSONEL_TC_IDENTY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    <cfif database_type is "MSSQL">
						OR (PAF.PERSONEL_NAME + ' ' + PAF.PERSONEL_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					<cfelse>
                        OR (PAF.PERSONEL_NAME || ' ' || PAF.PERSONEL_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                    </cfif>
				)
			</cfif>
			<cfif not session.ep.ehesap>
				AND PAF.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif Len(attributes.startdate) and Len(attributes.finishdate)>
				AND ISNULL(PAF.UPDATE_DATE,PAF.RECORD_DATE) BETWEEN #attributes.startdate# AND #attributes.finishdate#
			</cfif>
		ORDER BY
			PAF.PERSONEL_ASSIGN_ID DESC
	</cfquery>
<cfelse>
	<cfset get_form.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_form.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" action="#request.self#?fuseaction=hr.list_personel_assign_form" method="post">
            <input type="hidden" name="is_filtered" id="is_filtered" value="1">
            <cf_box_search>
                <div class="form-group">
                    <input type="text" name="keyword" id="keyword" maxlength="50" value="<cfif Len(attributes.keyword)><cfoutput>#attributes.keyword#</cfoutput></cfif>" style="width:130px;" placeholder="<cfoutput><cf_get_lang dictionary_id='57460.Filtre'></cfoutput>">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfif len(attributes.position_cat)>#attributes.position_cat_id#</cfif>">
                        <input type="text" name="position_cat" id="position_cat" style="width:130px;" value="<cfif len(attributes.position_cat)><cfoutput>#attributes.position_cat#</cfoutput></cfif>" placeholder="<cfoutput><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></cfoutput>">
                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=search_form.position_cat_id&field_cat=search_form.position_cat','list');" title=""></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="process_status" id="process_status" style="width:90px;">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="0" <cfif attributes.process_status eq 0>selected</cfif>><cf_get_lang dictionary_id='29537.Red'></option>
                        <option value="1" <cfif attributes.process_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57500.Onay'></option>
                        <option value="-1" <cfif attributes.process_status eq -1>selected</cfif>><cf_get_lang dictionary_id='55120.Devam Ediyor'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <cfoutput>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-our_company_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                            <div class="col col-12">
                                <select name="our_company_id" id="our_company_id" style="width:180px;" onchange="showRelation(this.value,'branch_id','department_id',1);">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfloop query="get_our_company">
                                        <option value="#comp_id#" <cfif attributes.our_company_id eq get_our_company.comp_id>selected</cfif>>#company_name#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-12">
                                <select name="branch_id" id="branch_id" style="width:180px;" onChange="showRelation(this.value,'department_id','',2)">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfif Len(attributes.our_company_id)>
                                        <cfloop query="get_our_branch">
                                            <option value="#branch_id#"<cfif attributes.branch_id eq get_our_branch.branch_id>selected</cfif>>#branch_name#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-department_id">
                            <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                            <div class="col col-12">
                                <select name="department_id" id="department_id" style="width:180px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfif Len(attributes.branch_id)>
                                        <cfloop query="get_our_department">
                                            <option value="#department_id#" <cfif attributes.department_id eq get_our_department.department_id>selected</cfif>>#department_head#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                            <div class="col col-12">
                                <select name="process_stage" id="process_stage" style="width:180px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfloop query="get_process_stage">
                                        <option value="#process_row_id#" <cfif attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-startdate">
                            <label class="col col-12"><cf_get_lang dictionary_id="57501.Başlangıç"></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56704.Tarih Hatalı'></cfsavecontent>
                                    <cfif Len(attributes.startdate)><cfset startdate_ = dateformat(attributes.startdate,dateformat_style)><cfelse><cfset startdate_ = ""></cfif>
                                    <cfinput type="text" name="startdate" id="startdate" value="#startdate_#" style="width:65px;" maxlength="10" validate="#validate_style#" message="#alert#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-finishdate">
                            <label class="col col-12">#getLang(90,'Bitiş',57502)#</label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56704.Tarih Hatalı'></cfsavecontent>
                                    <cfif Len(attributes.finishdate)><cfset finishdate_ = dateformat(attributes.finishdate,dateformat_style)><cfelse><cfset finishdate_ = ""></cfif>
                                    <cfinput type="text" name="finishdate" id="finishdate" value="#finishdate_#" style="width:65px;" maxlength="10" validate="#validate_style#" message="#alert#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfoutput>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(547,'Atama Formları',55632)#" uidrop="1"  woc_setting = "#{ checkbox_name : 'print_form_choice', print_type : 256 }#">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='58820.Başlık'></th>
                    <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                    <th><cf_get_lang dictionary_id='55370.İhtiyaç Gerekçeleri'></th>
                    <th><cf_get_lang dictionary_id='56873.Personel Talebi'></th>
                    <th><cf_get_lang dictionary_id='57482.Aşama'></th>
                    <!-- sil -->
                        <th class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_personel_assign_form&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                        <th class="header_icn_none text-center" nowrap="nowrap"><a href="javascript://" onClick="send_print_choice();">
                            <input type="checkbox" name="all_choice" id="all_choice" value="1" onclick="send_check_all();">
                        </th>                   
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_form.recordcount>
                    <cfset position_cat_list = "">
                    <cfset our_company_id_list = "">
                    <cfset branch_id_list = "">
                    <cfset department_id_list = "">
                    <cfset personel_requirement_list = "">
                    <cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif Len(position_cat_id) and not ListFind(position_cat_list,position_cat_id,",")>
                    <cfset position_cat_list = ListAppend(position_cat_list,position_cat_id,",")>
                    </cfif>
                    <cfif Len(our_company_id) and not ListFind(our_company_id_list,our_company_id,",")>
                        <cfset our_company_id_list = ListAppend(our_company_id_list,our_company_id,",")>
                    </cfif>
                    <cfif Len(branch_id) and not ListFind(branch_id_list,branch_id,",")>
                        <cfset branch_id_list = ListAppend(branch_id_list,branch_id,",")>
                    </cfif>
                    <cfif Len(department_id) and not ListFind(department_id_list,department_id,",")>
                        <cfset department_id_list = ListAppend(department_id_list,department_id,",")>
                    </cfif>
                    <cfif Len(personel_req_id) and not ListFind(personel_requirement_list,personel_req_id,",")>
                        <cfset personel_requirement_list = ListAppend(personel_requirement_list,personel_req_id,",")>
                    </cfif>
                    </cfoutput>
                    <cfif ListLen(position_cat_list)>
                        <cfquery name="get_position_cat" datasource="#dsn#">
                            SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID IN (#position_cat_list#) ORDER BY POSITION_CAT_ID
                        </cfquery>
                        <cfset position_cat_list = ListSort(ListDeleteDuplicates(ValueList(get_position_cat.position_cat_id,",")),"numeric","asc",",")>
                    </cfif>
                    <cfif ListLen(our_company_id_list)>
                        <cfquery name="get_our_company_name" datasource="#dsn#">
                            SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#our_company_id_list#) ORDER BY COMP_ID
                        </cfquery>
                        <cfset our_company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_our_company_name.comp_id,",")),"numeric","asc",",")>
                    </cfif>
                    <cfif ListLen(branch_id_list)>
                        <cfquery name="get_branch_name" datasource="#dsn#">
                            SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
                        </cfquery>
                        <cfset branch_id_list = ListSort(ListDeleteDuplicates(ValueList(get_branch_name.branch_id,",")),"numeric","asc",",")>
                    </cfif>
                    <cfif ListLen(department_id_list)>
                        <cfquery name="get_department_name" datasource="#dsn#">
                            SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_id_list#) ORDER BY DEPARTMENT_ID
                        </cfquery>
                        <cfset department_id_list = ListSort(ListDeleteDuplicates(ValueList(get_department_name.department_id,",")),"numeric","asc",",")>
                    </cfif>
                    <cfif ListLen(personel_requirement_list)>
                        <cfquery name="get_requirement_name" datasource="#dsn#">
                            SELECT PERSONEL_REQUIREMENT_ID,PERSONEL_REQUIREMENT_HEAD,FORM_TYPE,OLD_PERSONEL_NAME,CHANGE_PERSONEL_NAME,TRANSFER_PERSONEL_NAME FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID IN (#personel_requirement_list#) ORDER BY PERSONEL_REQUIREMENT_ID
                        </cfquery>
                        <cfset personel_requirement_list = ListSort(ListDeleteDuplicates(ValueList(get_requirement_name.personel_requirement_id,",")),"numeric","asc",",")>
                    </cfif>
                    <form name="form_print_all">
                    <cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td width="35">#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=hr.list_personel_assign_form&event=upd&per_assign_id=#get_form.personel_assign_id#" class="tableyazi">#get_form.personel_assign_head#</a></td>
                            <td><cfif Len(our_company_id)>#get_our_company_name.nick_name[ListFind(our_company_id_list,our_company_id,',')]#</cfif></td>
                            <td><cfif Len(branch_id)>#get_branch_name.branch_name[ListFind(branch_id_list,branch_id,',')]#</cfif></td>
                            <td><cfif Len(department_id)>#get_department_name.department_head[ListFind(department_id_list,department_id,',')]#</cfif></td>
                            <td><cfif Len(position_cat_id)>#get_position_cat.position_cat[ListFind(position_cat_list,position_cat_id,',')]#</cfif></td>
                            <td>#personel_name# #personel_surname#</td>
                            <td><cfif Len(personel_req_id)>
                                <cfset form_type = get_requirement_name.form_type[ListFind(personel_requirement_list,personel_req_id,',')]>
                                <cfif form_type eq 1><cf_get_lang dictionary_id="55433.Ayrılan Kişinin Yerine">
                                    <cfelseif form_type eq 2><cf_get_lang dictionary_id="55574.Ek Kadro">
                                    <cfelseif form_type eq 3><cf_get_lang dictionary_id="55451.Pozisyon Değişikliği Yapan Personelin Yerine">
                                    <cfelseif form_type eq 4><cf_get_lang dictionary_id="55481.Nakil Olan Personelin Yerine">
                                    <cfelseif form_type eq 5><cf_get_lang dictionary_id="55579.Emeklilik Nedeniyle  Çıkış / Giriş Yapan Personelin Yerine">
                                    <cfelseif form_type eq 6><cf_get_lang dictionary_id="55449.Ek Kadro Süreli"></cfif>
                                    <cfif len(get_requirement_name.old_personel_name[ListFind(personel_requirement_list,personel_req_id,',')])> - #get_requirement_name.old_personel_name[ListFind(personel_requirement_list,personel_req_id,',')]#</cfif>
                                    <cfif len(get_requirement_name.change_personel_name[ListFind(personel_requirement_list,personel_req_id,',')])> - #get_requirement_name.change_personel_name[ListFind(personel_requirement_list,personel_req_id,',')]#</cfif>
                                    <cfif len(get_requirement_name.transfer_personel_name[ListFind(personel_requirement_list,personel_req_id,',')])> - #get_requirement_name.transfer_personel_name[ListFind(personel_requirement_list,personel_req_id,',')]#</cfif>
                                </cfif>
                            </td>
                            </td>
                            <td><cfif Len(personel_req_id)>#personel_req_id# - #get_requirement_name.personel_requirement_head[ListFind(personel_requirement_list,personel_req_id,',')]#</cfif></td>
                            <td>#stage#</td>
                            <!-- sil -->
                            <td width="20" align="center"><a href="#request.self#?fuseaction=hr.list_personel_assign_form&event=upd&per_assign_id=#get_form.personel_assign_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <td width="20" style="text-align:center;"><input type="checkbox" name="print_form_choice" id="print_form_choice" value="#personel_assign_id#"></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                    </form>
                    <cfelse>
                        <tr>
                            <td colspan="12"><cfif isDefined("attributes.is_filtered")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                        </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset url_str = "&is_filtered=1">
        <cfif Len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
        <cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
        <cfif Len(attributes.branch_id)><cfset url_str = "#url_str#&branch_id=#attributes.branch_id#"></cfif>
        <cfif Len(attributes.department_id)><cfset url_str = "#url_str#&department_id=#attributes.department_id#"></cfif>
        <cfif Len(attributes.position_cat) and Len(attributes.position_cat_id)>
            <cfset url_str = "#url_str#&position_cat=#attributes.position_cat#&position_cat_id=#attributes.position_cat_id#">
        </cfif>
        <cfif Len(attributes.process_stage)><cfset url_str = "#url_str#&process_stage=#attributes.process_stage#"></cfif>
        <cfif Len(attributes.startdate)><cfset url_str = "#url_str#&startdate=#DateFormat(attributes.startdate,dateformat_style)#"></cfif>
        <cfif Len(attributes.finishdate)><cfset url_str = "#url_str#&finishdate=#DateFormat(attributes.finishdate,dateformat_style)#"></cfif>
        <cf_paging page="#attributes.page#" 
            startrow="#attributes.startrow#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            adres="#attributes.fuseaction##url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	//Sirket- Sube- Departman Filtresine Gore Sonuc Doner
	function showRelation(field_id,relation_name,relation_name2,type)	
	{
		
		field_length = eval('document.getElementById("' + relation_name + '")').options.length;
		if(field_length > 0)
			for(jj=field_length;jj>=0;jj--)
				eval('document.getElementById("' + relation_name + '")').options[jj+1]=null;
				
		if(relation_name2 != "")
		{
			field_length = eval('document.getElementById("' + relation_name2 + '")').options.length;
			if(field_length > 0)
				for(jj=field_length;jj>=0;jj--)
					eval('document.getElementById("' + relation_name2 + '")').options[jj+1]=null;
		}

		if(field_id != "")
		{
			if (type == 1)
				var get_relation_table = wrk_query("SELECT BRANCH_ID RELATED_ID,BRANCH_NAME RELATED_NAME FROM BRANCH WHERE BRANCH_STATUS =1 AND COMPANY_ID = "+ field_id +" ORDER BY BRANCH_NAME","dsn");
			else
				var get_relation_table = wrk_query("SELECT DEPARTMENT_ID RELATED_ID,DEPARTMENT_HEAD RELATED_NAME FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = "+ field_id +" ORDER BY DEPARTMENT_HEAD","dsn");
			
			if(get_relation_table.recordcount > 0)
				for(xx=0;xx<get_relation_table.recordcount;xx++)
					eval('document.getElementById("' + relation_name + '")').options[xx+1]=new Option(get_relation_table.RELATED_NAME[xx],get_relation_table.RELATED_ID[xx]);
		}
	}
    function send_print_choice()
	{
		print_form_list = "";
		for (i=0; i < document.getElementsByName('print_form_choice').length; i++)
		{
			if(document.form_print_all.print_form_choice[i].checked == true)
			{
				print_form_list = print_form_list + document.form_print_all.print_form_choice[i].value + ',';
			}	
		}
		if(print_form_list.length == 0)
		{
			alert("<cf_get_lang dictionary_id='35384.En Az Bir Seçim Yapmalısınız'>!");
			return false;
		}
		else
		{
			return false;
		}
	}
	function send_check_all()
	{
		all_count = "<cfoutput><cfif get_form.recordcount lte attributes.maxrows>#get_form.recordcount#<cfelse>#attributes.maxrows#</cfif></cfoutput>";
		if(all_count > 1)
			for(cc=0;cc<all_count;cc++)
				document.form_print_all.print_form_choice[cc].checked = document.getElementById("all_choice").checked;
		else if(all_count == 1)
			document.getElementById('print_form_choice').checked = document.getElementById("all_choice").checked;
	}
</script>
