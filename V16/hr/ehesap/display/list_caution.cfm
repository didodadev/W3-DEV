<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="1/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.apol_startdate" default="">
<cfparam name="attributes.apol_finishdate" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.decision_no" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.cautionto_employee_id" default="">
<cfparam name="attributes.cautionto_employee_name" default="">
<cfif len(attributes.startdate) and isdate(attributes.startdate) >
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>
<cfif len(attributes.apol_startdate) and isdate(attributes.apol_startdate) >
	<cf_date tarih="attributes.apol_startdate">
<cfelse>
	<cfset attributes.apol_startdate = "">
</cfif>
<cfif len(attributes.apol_finishdate) and isdate(attributes.apol_finishdate)>
	<cf_date tarih="attributes.apol_finishdate">
<cfelse>
	<cfset attributes.apol_finishdate="">
</cfif>
<cfquery name="get_caution_type" datasource="#DSN#">
  SELECT * FROM SETUP_CAUTION_TYPE ORDER BY CAUTION_TYPE
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.list_caution%">
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
    SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS =1 AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfif isdefined('attributes.form_submit')>
	<cfinclude template="../query/get_cautions.cfm">
<cfelse>
	<cfset get_caution.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_CAUTION.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.list_caution" method="post" name="filter_list_caution">
            <input name="form_submit" id="form_submit" type="hidden" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#message#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58772.İşlem No'></cfsavecontent>
                    <cfinput type="text" name="decision_no" placeholder="#message#" style="width:100px;" value="#attributes.decision_no#" maxlength="50">                    
                </div>
                <div class="form-group">
                    <select name="is_active" id="is_active">
                        <option value="2" <cfif isDefined("attributes.is_active") and (attributes.is_active eq 2)>selected</cfif>><cf_get_lang dictionary_id ='57708.Tümü'></option>
                        <option value="1" <cfif isDefined("attributes.is_active") and (attributes.is_active eq 1)>selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
                        <option value="0" <cfif isDefined("attributes.is_active") and (attributes.is_active eq 0)>selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
                    </select>                    
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
                        <div class="col col-12">
                            <select name="process_stage" id="process_stage" style="width:110px;">
                                <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                                <cfoutput query="get_process_stage">
                                    <option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-caution_type">
                        <label class="col col-12"><cf_get_lang dictionary_id ='57630.Tip'></label>
                        <div class="col col-12">
                            <select name="caution_type" id="caution_type">
                                <option value=""><cf_get_lang dictionary_id ='57630.Tip'></option>
                                <cfoutput query="get_caution_type">
                                    <option value="#caution_type_id#" <cfif isDefined("attributes.caution_type") AND (attributes.caution_type EQ caution_type_id)>SELECTED</cfif>>#caution_type#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-cautionto_employee_name">
                        <label class="col col-12"><cf_get_lang dictionary_id ='53515.İşlem Yapılan'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="cautionto_employee_id" id="cautionto_employee_id" value="<cfoutput>#attributes.cautionto_employee_id#</cfoutput>">
                                <input type="text" name="cautionto_employee_name" id="cautionto_employee_name" value="<cfoutput>#attributes.cautionto_employee_name#</cfoutput>" style="width:140px;" onfocus="AutoComplete_Create('order_employee','member_name','member_name','get_member_autocomplete','3','employee_id','order_employee_id','','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1,9&field_name=filter_list_caution.cautionto_employee_name&field_emp_id2=filter_list_caution.cautionto_employee_id','list')" title="<cf_get_lang no='168.seçiniz'>"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-startdate">
                        <label class="col col-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></label>
                        <div class="col col-12">
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
                                        <cfinput validate="#validate_style#" type="text" name="startdate" maxlength="10" value="#dateformat(attributes.startdate,dateformat_style)#" style="width:65px;"> 
                                    <cfelse>
                                        <cfinput validate="#validate_style#" type="text" name="startdate" maxlength="10" value="" style="width:65px;"> 
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
                                        <cfinput validate="#validate_style#" type="text" name="finishdate" maxlength="10" value="#dateformat(attributes.finishdate,dateformat_style)#" style="width:65px;"> 
                                    <cfelse>
                                        <cfinput validate="#validate_style#" type="text" name="finishdate" maxlength="10" value="" style="width:65px;"> 
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-apol_startdate">
                        <label class="col col-12"><cf_get_lang dictionary_id="59305.Savunma Tarihi"></label>
                        <div class="col col-12">
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfif isdefined("attributes.apol_startdate") and len(attributes.apol_startdate)>
                                        <cfinput validate="#validate_style#" type="text" name="apol_startdate" maxlength="10" value="#dateformat(attributes.apol_startdate,dateformat_style)#" style="width:65px;"> 
                                    <cfelse>
                                        <cfinput validate="#validate_style#" type="text" name="apol_startdate" maxlength="10" value="" style="width:65px;"> 
                                    </cfif>
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="apol_startdate"></span>
                                </div>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfif isdefined("attributes.apol_finishdate") and len(attributes.apol_finishdate)>
                                        <cfinput validate="#validate_style#" type="text" name="apol_finishdate" maxlength="10" value="#dateformat(attributes.apol_finishdate,dateformat_style)#" style="width:65px;"> 
                                    <cfelse>
                                        <cfinput validate="#validate_style#" type="text" name="apol_finishdate" maxlength="10" value="" style="width:65px;"> 
                                    </cfif>                                       
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="apol_finishdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-department_id">
                        <label class="col col-12"><cf_get_lang dictionary_id="57995.Bölüm"></label>
                        <div class="col col-12">
                            <cf_multiselect_check 
                            query_name="get_department"  
                            name="department_id"
                            width="135" 
                            option_text="<cf_get_lang dictionary_id='57572.Departmam'>"
                            option_value="DEPARTMENT_ID"
                            option_name="DEPARTMENT_HEAD"
                            value="#attributes.department_id#">
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>  
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53176.Disiplin İşlemleri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list>             
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id ='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='58772.İşlem No'></th>
                    <th><cf_get_lang dictionary_id ='58820.Başlık'></th>
                    <th><cf_get_lang dictionary_id ='57630.Tip'></th>
                    <th><cf_get_lang dictionary_id ='53515.İşlem Yapılan'></th>
                    <th><cf_get_lang dictionary_id ='58586.İşlem Yapan'></th>
                    <th><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></th>
                    <th><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></th>
                    <th><cf_get_lang dictionary_id='51231.Sicil No'></th>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th>
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=ehesap.list_caution&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_caution.recordcount>
                    <cfset caution_id_list = ''>
                    <cfoutput query="GET_CAUTION"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(caution_type_id) and not listfind(caution_id_list,caution_type_id)>
                            <cfset caution_id_list=listappend(caution_id_list,caution_type_id)>
                        </cfif>
                    </cfoutput>
                    <cfif len(caution_id_list)>
                        <cfset caution_id_list=listsort(caution_id_list,"numeric","ASC",",")>
                        <cfquery name="get_type" dbtype="query">
                            SELECT CAUTION_TYPE FROM get_caution_type WHERE CAUTION_TYPE_ID IN (#caution_id_list#) ORDER BY CAUTION_TYPE_ID
                        </cfquery>
                    </cfif>
                    <cfoutput query="GET_CAUTION"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td width="35">#currentrow#</td>
                            <td>#decision_no#</td>
                            <td><a href="#request.self#?fuseaction=ehesap.list_caution&event=upd&caution_id=#caution_id#" class="tableyazi">#caution_head#</a></td>
                            <td>
                                <cfif len(caution_type_id)>
                                    #get_type.caution_type[listfind(caution_id_list,caution_type_id,',')]#
                                </cfif>
                            </td>
                            <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                            <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#warner#','medium');" class="tableyazi">#warner_name#</a></td>
                            <td>#dateformat(caution_date,dateformat_style)#</td>
                            <td>#dateformat(record_date,dateformat_style)#</td>
                            <td>#employee_no#</td>
                            <td>#position_cat#</td>
                            <td>#position_name#</td>
                            <!-- sil -->
                            <td style="text-align:center;" nowrap="nowrap"> 
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_caution_print&caution_id=#caution_id#','page')"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a> 
                            </td>
                            <td style="text-align:center;" nowrap="nowrap">
                                <a href="#request.self#?fuseaction=ehesap.list_caution&event=upd&caution_id=#caution_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> 
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="10"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.filtre ediniz'>!</cfif></td>
                        </tr>
                </cfif>
            </tbody>
        </cf_grid_list>    
        <cfif isdefined('attributes.form_submit')>
            <cfset url_str = "&form_submit=#attributes.form_submit#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined('attributes.caution_type') and len(attributes.caution_type)>
            <cfset url_str = "#url_str#&caution_type=#attributes.caution_type#">
        </cfif>
        <cfif isdefined('attributes.is_active') and len(attributes.is_active)>
            <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
        </cfif>
        <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
            <cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
        </cfif>
        <cfif isdefined('attributes.department_id') and len(attributes.department_id)>
            <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
        </cfif>
        <cfif isdefined('attributes.decision_no') and len(attributes.decision_no)>
            <cfset url_str = "#url_str#&decision_no=#attributes.decision_no#">
        </cfif>
        <cfif len(attributes.cautionto_employee_id) and len(attributes.cautionto_employee_name)>
            <cfset url_str = "#url_str#&cautionto_employee_id=#attributes.cautionto_employee_id#">
        </cfif>
        <cfif len(attributes.cautionto_employee_name)>
            <cfset url_str = "#url_str#&cautionto_employee_name=#attributes.cautionto_employee_name#">
        </cfif>
        <cfif len(attributes.startdate) and isdate(attributes.startdate)>
            <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
            <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
        </cfif>
        <cfif len(attributes.apol_startdate) and isdate(attributes.apol_startdate)>
            <cfset url_str = "#url_str#&apol_startdate=#dateformat(attributes.apol_startdate,dateformat_style)#">
        </cfif>
        <cfif len(attributes.apol_finishdate) and isdate(attributes.apol_finishdate)>
            <cfset url_str = "#url_str#&apol_finishdate=#dateformat(attributes.apol_finishdate,dateformat_style)#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="ehesap.list_caution#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
