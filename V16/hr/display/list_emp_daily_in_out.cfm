<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
<!--- <cfelse>
	<cfset attributes.startdate = date_add('d',-1,createodbcdatetime('#(now())#'))> --->
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
<!--- <cfelse>
	<cfset attributes.finishdate = date_add('d',1,attributes.startdate)> --->
</cfif>

<cfif isdefined('attributes.form_submit')>
<cfquery name="get_file_imports" datasource="#dsn#">
	SELECT
		FI.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		FILE_IMPORTS_MAIN AS FI,
		EMPLOYEES E
	WHERE
		FI.PROCESS_TYPE = -1 AND <!--- pdks --->
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			FI.BRANCH_ID = #attributes.BRANCH_ID# AND
		<cfelseif session.ep.ehesap neq 1>
		(
		FI.BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #session.ep.position_code# AND
                            DEPARTMENT_ID IS NULL
						)
		OR
		FI.BRANCH_ID IS NULL
		)
		AND
		</cfif>
		FI.RECORD_EMP = E.EMPLOYEE_ID
		<cfif isdefined('attributes.startdate') and len(attributes.startdate) and isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND FI.RECORD_DATE <= #DATEADD("d",1,attributes.finishdate)# AND FI.RECORD_DATE >= #attributes.startdate#
		<cfelseif isdefined ('attributes.finishdate') and len(attributes.finishdate)>
			AND FI.RECORD_DATE <= #DATEADD("d",1,attributes.finishdate)#
		<cfelseif isdefined('attributes.startdate') and len(attributes.startdate)>
			AND FI.RECORD_DATE >= #attributes.startdate#
		</cfif>
	ORDER BY
		FI.IMPORTED,
		FI.RECORD_DATE DESC
</cfquery>
<cfelse>
<cfset get_file_imports.recordcount = 0>
</cfif>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE 
		BRANCH_STATUS = 1
		<cfif session.ep.ehesap neq 1>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #session.ep.position_code#
						)
		</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_file_imports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=hr.list_emp_daily_in_out">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                        <cfoutput query="get_branch">
                            <option value="#get_branch.branch_id#"<cfif attributes.branch_id eq get_branch.branch_id> selected</cfif>>#get_branch.branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlama Tarihi	'>!</cfsavecontent>
                        <cfif isdefined("attributes.startdate")>
                            <cfinput type="text" name="startdate" id="startdate" placeholder="#getLang("","",58053)#" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#" style="width:65px;">
                        <cfelse>
                            <cfinput type="text" name="startdate" id="startdate" placeholder="#getLang("","",58053)#" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
                        </cfif>
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message1"><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>!</cfsavecontent>
                        <cfif isdefined("attributes.finishdate")>
                            <cfinput type="text" name="finishdate" id="finishdate" placeholder="#getLang("","",57700)#" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" message="#message1#" validate="#validate_style#" style="width:65px;">
                        <cfelse>
                            <cfinput type="text" name="finishdate" id="finishdate" placeholder="#getLang("","",57700)#" value="" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message1#">
                        </cfif>
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                    <cf_wrk_search_button button_type="4" search_function="date_check(search_form.startdate,search_form.finishdate,'#message_date#')">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(1476,'PDKS İmport',56561)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id ='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='56880.Import Dosya Adı'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id ='56562.Satır Sayısı'></th>
                    <!-- sil --><th><cf_get_lang dictionary_id='57468.Belge'></th><!-- sil -->
                    <th><cf_get_lang dictionary_id ='57483.Kayıt'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none text-center"><a title="<cf_get_lang dictionary_id ='48972.İmport Et'>" href="javascript://"><i class="fa fa-upload"></i></a></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center"><a href="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.list_emp_daily_in_out&event=Add</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='30456.Yeni Belge'> <cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='30456.Yeni Belge'> <cf_get_lang dictionary_id='44630.Ekle'>"></i></a></th>
                    <!-- sil -->
                </tr> 
            </thead>
            <tbody>
                <cfif get_file_imports.recordcount>
                    <cfoutput query="get_file_imports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td width="30">#currentrow#</td>
                        <td><!--- <cfif paper_type eq 1>Multiport<cfelseif paper_type eq 2>XML Base<cfelseif paper_type eq 3>ERK<cfelseif paper_type eq 4>TXT File<cfelseif paper_type eq 5>Toplu PDKS Giriş<cfelseif paper_type eq 6>Özgür Zaman<cfelseif paper_type eq 7>EmreXCL<cfelseif paper_type eq 8>TA</cfif> --->
                            #get_file_imports.REAL_NAME#
                        </td>
                        <td><cfif len(branch_id)>
                                <cfquery name="get_branch" datasource="#dsn#">SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #branch_id#</cfquery>
                                #get_branch.BRANCH_NAME#
                            <cfelse>
                                <cf_get_lang dictionary_id='29495.Tüm Şubeler'>
                            </cfif>
                        </td>
                        <td>#get_file_imports.line_count#</td>
                        <!-- sil --><td><div class="col col-12"><a href="#file_web_path#hr#dir_seperator##get_file_imports.file_name#"><i class="fa fa-paperclip"></i></a>&nbsp;#round(get_file_imports.file_size/1024)#Kb.</td><!-- sil -->
                        <td>#get_file_imports.employee_name# #get_file_imports.employee_surname#</div></td>
                        <td>#dateformat(date_add("h",session.ep.time_zone,get_file_imports.record_date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,get_file_imports.record_date),timeformat_style)#)</td>
                        <!-- sil -->
                            <div class="col col-12">   <cfsavecontent variable="del_message"><cf_get_lang dictionary_id ='56783.Belgeyi Silmek İstediğinizden Emin misiniz'></cfsavecontent>
                                <cfsavecontent  variable="pro_message"><cf_get_lang dictionary_id ='56784.Belgeyi İşletmek İstediğinizden Emin misiniz'></cfsavecontent>
                                <cfif not imported>	
                                    <td><a title="<cf_get_lang dictionary_id ='48972.İmport Et'>" href="javascript://" onClick="if (confirm(' #pro_message#')) windowopen('#request.self#?fuseaction=hr.emptypopupflush_add_import_pdks_row&i_id=#i_id#','small','pdks_import_popup');"><i class="fa fa-upload"></i></a></td>				
                                    <td><a title="<cf_get_lang dictionary_id ='48973.Belge Sil'>" href="javascript://" onClick="if (confirm('#del_message#')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_file_import_pdks&i_id=#i_id#','small');"><i  class="icon-minus"></i></td>
                                <cfelse>
                                    <td>
                                    <cfsavecontent variable="back_message"><cf_get_lang dictionary_id ='56785.Bu Belge İle Yapılan Hareketleri Geri Alıyorsunuz ! Tekrar Dosyayı İşletmeniz Gerekecektir !Emin misiniz'></cfsavecontent>
                                    <a href="javascript://" title="<cf_get_lang dictionary_id ='52379.İmport Sil'>" onClick="if (confirm('#back_message#')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_file_import_pdks&just_actions=1&i_id=#i_id#','small');">
                                      <i class="icon-times"></i></a></td>
                                      <td><cfsavecontent variable="del_message"><cf_get_lang dictionary_id ='56786.İşletilmiş Belgeyi Silerseniz Belgenin Oluşturduğu Satırları Kaybedersiniz! Emin misiniz'></cfsavecontent>
                                    <a title="<cf_get_lang dictionary_id ='48973.Belge Sil'>" href="javascript://" onClick="if (confirm('#del_message#')) windowopen('#request.self#?fuseaction=hr.emptypopup_del_file_import_pdks&i_id=#i_id#','small');">
                                       <i  class="icon-minus"></i></a>
                                    </td>
                                </cfif></div>
                        <!-- sil -->
                    </tr>
                    </cfoutput>
                <cfelse>              
                    <tr>
                        <td colspan="9"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset url_string = ''>
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            <cfset url_string = '&branch_id=#attributes.branch_id#'>
        </cfif>
        <cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
            <cfset url_string = '&form_submit=#attributes.form_submit#'>
        </cfif>
        <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
            <cfset url_string = "#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
            <cfset url_string = "#url_string#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
        </cfif>
        <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="hr.list_emp_daily_in_out#url_string#">
    </cf_box>
</div>
