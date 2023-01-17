<cf_get_lang_set module_name="ehesap">
<cfif not isdefined('attributes.keyword')>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.ACC_TYPE_ID" default="">
<cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),dateformat_style)#"> 
<cfinclude template="../query/get_branch_name.cfm">
<cfif arama_yapilmali eq 1>
	<cfset get_fees.recordcount = 0>
<cfelse>
	<cfinclude template="../query/get_fees.cfm">
	<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
		<cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
	</cfif>
	<cfif len(attributes.startdate) and isdate(attributes.startdate)>
		<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
	</cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_FEES.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=#fusebox.circuit#.list_visited" method="post" name="filter_list_visited">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#place#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""<cfif not len(attributes.branch_id)> selected</cfif>><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        <cfoutput query="GET_BRANCH_NAMES"><option value="#BRANCH_ID#"<cfif attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option></cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <cfinclude template="../query/get_work_accident_type.cfm">
                    <select name="ACC_TYPE_ID" id="ACC_TYPE_ID">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="GET_WORK_ACCIDENT_TYPE">
                            <option value="#ACCIDENT_TYPE_ID#"<cfif attributes.ACC_TYPE_ID eq ACCIDENT_TYPE_ID> selected</cfif>>#accident_type#</option>
                        </cfoutput>
                    </select>                    
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="58053.Başlangıç Tarihi">!</cfsavecontent>
                        <cfinput type="text" name="startdate" style="width:65px;" value="#attributes.startdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57700.Bitiş Tarihi">!</cfsavecontent>
                        <cfinput type="text" name="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">                    
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                    <cf_wrk_search_button button_type="4" search_function="date_check(filter_list_visited.startdate,filter_list_visited.finishdate,'#message_date#')">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>                    
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>

    <cfsavecontent variable="message"><cf_get_lang dictionary_id="54002.Çalışan Viziteleri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list>    
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id ='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='53146.Vizite Çıkış'></th>
                    <th><cf_get_lang dictionary_id='53144.Vizite Tarih'></th>
                    <th><cf_get_lang dictionary_id='57500.Onay'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='53147.İş Kazası'></th>
                    <th class="form-title"><cf_get_lang dictionary_id='53469.Kaza Çeşidi'></th>
                    <!-- sil -->
                        <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_visited&event=add</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif GET_FEES.recordcount>
                    <cfset branch_id_list = ''>
                    <cfset employee_id_list = ''>
                    <cfset accident_type_list =''>
                    <cfoutput query="GET_FEES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(VALID_EMP) and not listfind(employee_id_list,VALID_EMP)>
                            <cfset employee_id_list=listappend(employee_id_list,VALID_EMP)>
                        </cfif>
                        <cfif len(BRANCH_ID) and not listfind(branch_id_list,BRANCH_ID)>
                            <cfset branch_id_list=listappend(branch_id_list,BRANCH_ID)>
                        </cfif>
                        <cfif len(ACCIDENT_TYPE_ID) and not listfind(accident_type_list,ACCIDENT_TYPE_ID)>
                            <cfset accident_type_list=listappend(accident_type_list,ACCIDENT_TYPE_ID)>
                        </cfif>                    
                    </cfoutput>
                    <cfif len(branch_id_list)>
                    <cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
                        <cfquery name="get_branch_name" dbtype="query">
                            SELECT BRANCH_NAME FROM get_branch_names WHERE BRANCH_ID IN (#branch_id_list#) ORDER BY BRANCH_ID
                        </cfquery>
                    </cfif>
                    <cfif len(employee_id_list)>
                        <cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
                        <cfquery name="get_emp_detail" datasource="#dsn#">
                            SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
                        </cfquery>
                    </cfif>
                    <cfif len(accident_type_list)>
                        <cfset accident_type_list=listsort(accident_type_list,"numeric","ASC",",")>
                        <cfquery name="get_work_accident_type" datasource="#DSN#">
                            SELECT ACCIDENT_TYPE FROM EMPLOYEE_WORK_ACCIDENT_TYPE WHERE ACCIDENT_TYPE_ID IN (#accident_type_list#) ORDER BY ACCIDENT_TYPE_ID
                        </cfquery>
                    </cfif>                
                    <cfoutput query="GET_FEES" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                            <td><cfif len(branch_id)>#get_branch_name.BRANCH_NAME[listfind(branch_id_list,BRANCH_ID,',')]#</cfif>
                            </td>
                            <td>#dateformat(FEE_DATE,dateformat_style)#  #timeformat("#FEE_HOUR#:00",timeformat_style)#</td>
                            <td>#dateformat(FEE_DATEOUT,dateformat_style)#  #timeformat("#FEE_HOUROUT#:00",timeformat_style)#</td>
                            <td>
                                <cfif len(VALID_EMP)>
                                    #get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,VALID_EMP,',')]#&nbsp;
                                    #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,VALID_EMP,',')]#
                                    <cfif valid eq 1>
                                        <cf_get_lang dictionary_id="58699.Onaylandı">
                                    <cfelse>
                                        <cf_get_lang dictionary_id="57617.Reddedildi">
                                    </cfif>
                                <cfelseif not len(VALID_EMP) and len(VALID_EMP_1)>
                                        #get_emp_info(validator_pos_code_1,1,0)#
                                        <cfif valid_1 EQ 1>
                                            <cf_get_lang dictionary_id='58699.Onaylandı'>
                                        <cfelse>
                                            <cf_get_lang dictionary_id='57617.Reddedildi'>
                                        </cfif>
                                <cfelseif len(VALID_EMP_2) and len(VALID_1) and VALID_1 eq 1 AND len(VALID_2)>
                                    #get_emp_info(validator_pos_code_2,1,0)#
                                    <cfif valid_2 EQ 1>
                                        <cf_get_lang dictionary_id='58699.Onaylandı'>
                                    <cfelse>
                                        <cf_get_lang dictionary_id='57617.Reddedildi'>
                                    </cfif>
                                <cfelse>
                                    <cfif len(validator_pos_code)>
                                        #get_emp_info(validator_pos_code,1,0)#
                                    <cfelseif not len(validator_pos_code) and len(validator_pos_code_1)>
                                        #get_emp_info(validator_pos_code_1,1,0)#
                                    <cfelseif not len(validator_pos_code) and not len(validator_pos_code_1) and len(validator_pos_code_2)>
                                        #get_emp_info(validator_pos_code_2,1,0)#
                                    </cfif>
                                    <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                </cfif>
                            </td>
                            <td><cfif accident eq 1><cf_get_lang dictionary_id='53147.İş Kazası'><cfelse><cf_get_lang dictionary_id='53148.Normal Vizite'></cfif></td>
                            <td>
                                <cfif len(ACCIDENT_TYPE_ID)>
                                    #get_work_accident_type.ACCIDENT_TYPE[listfind(accident_type_list,ACCIDENT_TYPE_ID,',')]#
                                </cfif>
                            </td>
                            <!-- sil -->
                            <td nowrap="nowrap">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_ssk_fee_self_print&fee_id=#fee_id#&employee_id=#employee_id#','page')"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
                                <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_visited&event=upd&fee_id=#fee_id#"><i class=" fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                            </td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="9"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
                        </tr>
                </cfif>
            </tbody>
        </cf_grid_list>  
        <cfset url_str = "&keyword=#attributes.keyword#&branch_id=#attributes.branch_id#&startdate=#attributes.startdate#&finishdate=#attributes.finishdate#">
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#fusebox.circuit#.list_visited#url_str#">
    </cf_box>
</div>
<cf_get_lang_set module_name="#fusebox.circuit#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>