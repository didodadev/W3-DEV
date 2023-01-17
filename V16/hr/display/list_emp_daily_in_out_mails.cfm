<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.answer_state" default="">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
</cfif>
<cfinclude template="../ehesap/query/get_branch_name.cfm">
<cfset emp_branch_list=valuelist(GET_BRANCH_NAMES.BRANCH_ID)>
<cfif isdefined('attributes.form_varmi')>
	<cfquery name="get_protests" datasource="#dsn#">
		SELECT
			*
		FROM
			EMPLOYEE_DAILY_IN_OUT_PROTESTS
	</cfquery>
	<cfquery name="GET_MAILS" datasource="#DSN#">
		SELECT
			EPP.*,
			E.EMPLOYEE_EMAIL,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_DAILY_IN_OUT_MAILS EPP,
			EMPLOYEES_IN_OUT EI,
			EMPLOYEES E
		WHERE 
			<cfif len(attributes.employee_id) and len(attributes.employee_name)>
				 EPP.EMPLOYEE_ID = #attributes.employee_id# AND
			</cfif>
			<cfif isDefined("attributes.STARTDATE")>
				<cfif len(attributes.STARTDATE) AND len(attributes.FINISHDATE)>
					(
						EPP.ACTION_DATE >= #attributes.STARTDATE# AND
						EPP.ACTION_DATE <= #attributes.FINISHDATE#
					)
					AND
				<cfelseif len(attributes.STARTDATE)>
					EPP.ACTION_DATE >= #attributes.STARTDATE# AND
				<cfelseif len(attributes.FINISHDATE)>
					EPP.ACTION_DATE <= #attributes.FINISHDATE# AND
				</cfif>
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				EI.BRANCH_ID = #attributes.branch_id# AND
			</cfif>
			E.EMPLOYEE_ID=EPP.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			EI.FINISH_DATE IS NULL AND
			EI.BRANCH_ID IN (#emp_branch_list#)
			<cfif len(attributes.answer_state)>
				AND E.EMPLOYEE_ID IN
				(
					SELECT
						EPP_.EMPLOYEE_ID
					FROM
						EMPLOYEE_DAILY_IN_OUT_PROTESTS EPP_
					WHERE
						EPP_.ACTION_DATE = EPP.ACTION_DATE
						 <cfif attributes.answer_state eq 0 >
							AND EPP_.ANSWER_DETAIL IS NOT NULL 
						 <cfelse>
							AND EPP_.ANSWER_DETAIL IS NULL 
						 </cfif>
				)
			</cfif>
		ORDER BY
			EPP.ACTION_DATE DESC
	</cfquery>
<cfelse>
	<cfset GET_MAILS.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_MAILS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=hr.list_emp_daily_in_out_mails">
            <input type="hidden" name="form_varmi" id="form_varmi" value="1">
            <cf_box_search>
                <!-- sil -->
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="input-group">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                            <input type="text" name="employee_name" id="employee_name" style="width:100px;" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>">	
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.employee_id&field_name=search_form.employee_name&select_list=1','list');"></span>
                        </div>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>                
                    </div>
                <!-- sil -->
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-branch">
                        <label class="col col-12"><cf_get_lang dictionary_id="57453.Şube"></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id">
                                <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                <cfoutput query="GET_BRANCH_NAMES"><option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and attributes.branch_id eq BRANCH_ID> selected</cfif>>#BRANCH_NAME#</option></cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                    <div class="form-group" id="item-startdate">
                        <label class="col col-12"><cf_get_lang dictionary_id="57742.Tarih"></label>
                        <div class="col col-12">
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç tarihini yazınız'>!</cfsavecontent>
                                    <cfif isdefined("attributes.startdate")>
                                        <cfinput type="text" name="startdate" id="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#" style="width:65px;">
                                    <cfelse>
                                        <cfinput type="text" name="startdate" id="startdate" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
                                    </cfif>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'>!</cfsavecontent>
                                    <cfif isdefined("attributes.finishdate")>
                                        <cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" message="#message1#" validate="#validate_style#" style="width:65px;">
                                    <cfelse>
                                        <cfinput type="text" name="finishdate" id="finishdate" value="" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message1#">
                                    </cfif>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
                    <div class="form-group">
                        <label class="col col-12"><cf_get_lang dictionary_id="49209.Cevap Durumu"></label>
                        <div class="col col-12">
                            <select name="answer_state" id="answer_state" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="0"<cfif isdefined('attributes.answer_state') and (attributes.answer_state eq 0)> selected</cfif>><cf_get_lang dictionary_id='55723.Cevap Dönülen'></option>
                                <option value="1"<cfif isdefined('attributes.answer_state') and (attributes.answer_state eq 1)> selected</cfif>><cf_get_lang dictionary_id='55729.Cevap Dönülmeyen'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(587,'PDKS Uyarıları',55672)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='55684.İlgili Tarih'></th>
                    <th><cf_get_lang dictionary_id='55685.Uyarı Gönderilen'></th>
                    <th><cf_get_lang dictionary_id='55686.Mail Adresi'></th>
                    <th><cf_get_lang dictionary_id='55687.İlk Mail'></th>
                    <th><cf_get_lang dictionary_id='55689.Son Mail'></th>
                    <th><cf_get_lang dictionary_id='55690.İlk Okuma'></th>
                    <th><cf_get_lang dictionary_id='55698.Son Okuma'></th>
                    <th><cf_get_lang dictionary_id='55707.İtiraz Metni'></th>
                    <th><cf_get_lang dictionary_id='55710.Cevap Metni'></th>
                    <th width="20" class="header_icn_none text-center"></th>
                    <th width="20" class="header_icn_none text-center"></th>
                </tr>
            </thead>
            <tbody>
                <cfif GET_MAILS.recordcount>
                    <cfoutput query="GET_MAILS"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif get_protests.recordcount>
                            <cfquery name="get_" dbtype="query">
                                SELECT * FROM get_protests WHERE ACTION_DATE = #createodbcdatetime(action_date)# AND EMPLOYEE_ID = #employee_id#
                            </cfquery>
                        </cfif>
                        <tr>
                            <td>#currentrow#</td>
                            <td>#dateformat(action_date,dateformat_style)#</td>
                            <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                            <td>#EMPLOYEE_EMAIL#</td>
                            <td><cfif len(first_mail_date)>#dateformat(first_mail_date,'dd/mm/yyyy HH:MM')#</cfif></td>
                            <td><cfif len(last_mail_date)>#dateformat(last_mail_date,'dd/mm/yyyy HH:MM')#</cfif></td>
                            <td><cfif len(first_read_date)>#dateformat(first_read_date,'dd/mm/yyyy HH:MM')#</cfif></td>
                            <td><cfif len(last_read_date)>#dateformat(last_read_date,'dd/mm/yyyy HH:MM')#</cfif></td>
                            <td><cfif isdefined('get_.recordcount')>#get_.protest_detail#<cfelse>-</cfif></td>
                            <td><cfif isdefined('get_.recordcount')>#get_.answer_detail#<cfelse>-</cfif></td>
                            <td style="text-align:center;">
                                <cfif isdefined('get_.recordcount')>
                                <!-- sil --><a href="javascript://" onclick=" windowopen('#request.self#?fuseaction=hr.popup_add_protest_answer&id=#get_.PROTEST_ID#','medium');"><cfif get_.ANSWER_DETAIL IS NOT ""><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='53634.Cevap Güncelle'>"></i><cfelse><i class="fa fa-plus" title="<cf_get_lang dictionary_id='53635.Cevap Yaz'>"></i></cfif></a><!-- sil -->
                                </cfif>
                            </td>
                            <td width="20"><!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.list_emp_pdks&event=mail&employee_id=#employee_id#&aktif_gun=#dateformat(action_date,dateformat_style)#','small');"><i class="fa fa-envelope" title="<cf_get_lang dictionary_id='55720.Uyarı Maili Gönder'>"></a><!-- sil --></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="12" class="color-row" height="20"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset adres="hr.list_emp_daily_in_out_mails&form_varmi=1">
            <cfif isDefined('attributes.employee_id') and len(attributes.employee_name)>
                <cfset adres="#adres#&employee_id=#attributes.employee_id#">
            </cfif>
            <cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
                <cfset adres="#adres#&employee_name=#attributes.employee_name#">
            </cfif>
            <cfif isDefined('attributes.branch_id')>
                <cfset adres="#adres#&branch_id=#attributes.branch_id#">
            </cfif>
            <cfif isDefined('attributes.answer_state')>
                <cfset adres="#adres#&answer_state=#attributes.answer_state#">
            </cfif>
            <cfif isDefined('attributes.startdate')>
                <cfset adres="#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
            </cfif>
            <cfif isDefined('attributes.finishdate')>
                <cfset adres="#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
            </cfif>
            <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#">
        </cfif>			
    </cf_box>
</div>

