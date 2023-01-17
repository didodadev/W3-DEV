<cf_get_lang_set module_name="ehesap">
<cfif not isdefined('attributes.keyword')>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,CreateDate(year(now()),month(now()),1)),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(CreateDate(year(now()),month(now()),DaysInMonth(now())),dateformat_style)#"> 
<cfinclude template="../query/get_branch_name.cfm">
<cfif arama_yapilmali eq 1>
	<cfset GET_FEES_RELATIVE.recordcount = 0>
<cfelse>
	<cfinclude template="../query/get_fees_relative.cfm">
	<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
		<cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
	</cfif>
	<cfif len(attributes.startdate) and isdate(attributes.startdate)>
		<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
	</cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_FEES_RELATIVE.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="#request.self#?fuseaction=#fusebox.circuit#.list_visited_relative" METHOD="POST"> 
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" style="width:100px;" placeholder="#place#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""<cfif not len(attributes.branch_id)> selected</cfif>><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                        <cfoutput query="GET_BRANCH_NAMES">
                            <option value="#BRANCH_ID#"<cfif attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
                        <cfinput type="text" name="startdate" style="width:70px;" value="#attributes.startdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
                        <cfinput type="text" name="finishdate" style="width:70px;" value="#attributes.finishdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button button_type="4" search_function="date_check(form.startdate,form.finishdate,'#message_date#')">
                </div>
            </cf_box_search>
        </cfform> 
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53141.Çalışan Yakını Viziteleri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list>   
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='53142.Vizite Yazılan'></th>
                    <th><cf_get_lang dictionary_id='53143.Yakınlığı'></th>
                    <th><cf_get_lang dictionary_id='53144.Vizite Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57500.Onay'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#</cfoutput>.list_visited_relative&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.ekle'>" alt="<cf_get_lang dictionary_id='57582.ekle'>"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif GET_FEES_RELATIVE.recordcount>  
                    <cfset branch_id_list = ''>
                    <cfset employee_id_list = ''>
                        <cfoutput query="get_fees_relative" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif len(VALID_EMP) and not listfind(employee_id_list,VALID_EMP)>
                                <cfset employee_id_list=listappend(employee_id_list,VALID_EMP)>
                            </cfif>
                            <cfif len(BRANCH_ID) and not listfind(branch_id_list,BRANCH_ID)>
                                <cfset branch_id_list=listappend(branch_id_list,BRANCH_ID)>
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
                        <cfoutput query="get_fees_relative" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	   
                            <tr>
                                <td width="35">#currentrow#</td>
                                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                                <td><cfif len(branch_id)>#get_branch_name.BRANCH_NAME[listfind(branch_id_list,BRANCH_ID,',')]#</cfif></td>
                                <td>#ILL_NAME# #ILL_SURNAME#</td>			  
                                <td>
                                    <cfif isnumeric(ILL_RELATIVE) and ILL_RELATIVE eq 1><cf_get_lang dictionary_id='53262.Baba'>
                                        <cfelseif isnumeric(ILL_RELATIVE) and ILL_RELATIVE eq 1><cf_get_lang dictionary_id='53272.Anne'>
                                        <cfelseif isnumeric(ILL_RELATIVE) and ILL_RELATIVE eq 1><cf_get_lang dictionary_id='53274.Eş'>
                                        <cfelseif isnumeric(ILL_RELATIVE) and ILL_RELATIVE eq 1><cf_get_lang dictionary_id='53277.Oğul'>
                                        <cfelseif isnumeric(ILL_RELATIVE) and ILL_RELATIVE eq 1><cf_get_lang dictionary_id='53278.Kız'>
                                        <cfelse>#ILL_RELATIVE#
                                    </cfif>
                                </td>
                                <td>#dateformat(FEE_DATE,dateformat_style)# #FEE_HOUR#:00</td>
                                <td>
                                <cfif len(VALID_EMP)><!--- Ehesaptaki Onaylayacak kişi varsa --->
                                    #get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,VALID_EMP,',')]#&nbsp;
                                    #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,VALID_EMP,',')]#
                                    <cfif VALID eq 1>
                                        <cf_get_lang dictionary_id='58699.Onaylandı'>
                                    <cfelseif VALID EQ 0>
                                        <cf_get_lang dictionary_id='57617.Reddedildi'>
                                    <cfelseif VALID_DATE eq "">
                                        IK <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                    </cfif>
                                <cfelse>
                                    <cfif VALID_2 eq 1>
                                        <cf_get_lang dictionary_id="35921.2. Amir"> <cf_get_lang dictionary_id='58699.Onaylandı'>
                                    <cfelseif VALID_2 eq 0>
                                        <cf_get_lang dictionary_id="35921.2. Amir"> <cf_get_lang dictionary_id='57617.Reddedildi'>
                                    <cfelseif VALID_2 eq "" and len(VALID_1)>
                                        <cfif VALID_1 eq 1>
                                            <cf_get_lang dictionary_id="35927.1. Amir"> <cf_get_lang dictionary_id='58699.Onaylandı'>, <cf_get_lang dictionary_id="35921.2. Amir"> <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                        <cfelseif VALID_1 eq 0>
                                            <cf_get_lang dictionary_id="35927.1. Amir"> <cf_get_lang dictionary_id='57617.Reddedildi'>
                                        </cfif>
                                    <cfelseif VALID_1 eq "">
                                        <cf_get_lang dictionary_id="35927.1. Amir"> <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>
                                    </cfif>
                                </cfif>
                                </td>
                                <!-- sil -->
                                <td style="text-align:center;" nowrap="nowrap">
                                    <a href="JAVASCRIPT://" onClick="windowopen('#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.popup_ssk_fee_relative_print&fee_id=#fee_id#&employee_id=#employee_id#','page')"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
                                    <a href="#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.list_visited_relative&event=upd&fee_id=#fee_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.güncelle'>" alt="<cf_get_lang dictionary_id='57464.güncelle'>"></i></a>
                                </td>
                                <!-- sil -->
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="8"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
                        </tr>
                </cfif>
            </tbody>
        </cf_flat_list>  
        <cfset url_str = "&keyword=#attributes.keyword#&branch_id=#attributes.branch_id#&startdate=#attributes.startdate#&finishdate=#attributes.finishdate#">
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="ehesap.list_visited_relative#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">    
