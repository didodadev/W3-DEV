<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.answer_state" default="1">

<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
</cfif>

<cfinclude template="../ehesap/query/get_branch_name.cfm">
<cfset emp_branch_list=valuelist(GET_BRANCH_NAMES.BRANCH_ID)>

<cfif isdefined('attributes.form_varmi')>
	<cfquery name="GET_PROTESTS" datasource="#DSN#">
		SELECT
			EPP.PROTEST_DETAIL,
			EPP.ANSWER_DETAIL,
			EPP.PROTEST_DATE,
			EPP.PROTEST_ID,
			EPP.ACTION_DATE,
			EPP.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_DAILY_IN_OUT_PROTESTS EPP,
			EMPLOYEES_IN_OUT EI,
			EMPLOYEES E
		WHERE 
			<cfif len(attributes.employee_id) and len(attributes.employee_name)>
				 EPP.EMPLOYEE_ID = #attributes.employee_id# AND
			</cfif>
			<cfif len(attributes.answer_state)>
				 <cfif attributes.answer_state eq 0 >
				 EPP.ANSWER_DETAIL IS NOT NULL AND
				 <cfelse>
				 EPP.ANSWER_DETAIL IS NULL AND
				 </cfif>
			</cfif>
			<cfif isDefined("attributes.STARTDATE")>
				<cfif len(attributes.STARTDATE) AND len(attributes.FINISHDATE)>
				<!--- IKI TARIH DE VAR --->
				(
					EPP.PROTEST_DATE >= #attributes.STARTDATE# AND
					EPP.PROTEST_DATE <= #attributes.FINISHDATE#
				)
				AND
				<cfelseif len(attributes.STARTDATE)>
				<!--- SADECE BAŞLANGIÇ --->
				(
				EPP.PROTEST_DATE >= #attributes.STARTDATE#
				)
				AND
				<cfelseif len(attributes.FINISHDATE)>
				<!--- SADECE BITIŞ --->
				(
				EPP.PROTEST_DATE <= #attributes.FINISHDATE#
				)
				AND
				</cfif>
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			EI.BRANCH_ID = #attributes.branch_id# AND
			</cfif>
			E.EMPLOYEE_ID=EPP.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			EI.FINISH_DATE IS NULL AND
			EI.BRANCH_ID IN (#emp_branch_list#)
	</cfquery>
<cfelse>
	<cfset GET_PROTESTS.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_PROTESTS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=hr.list_emp_daily_in_out_protest">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55673.PDKS İtirazları"></cfsavecontent>
<cf_big_list_search title="#message#">
    <cf_big_list_search_area>
        <table>
            <tr>
            <input type="hidden" name="form_varmi" id="form_varmi" value="1">
                <td><cf_get_lang dictionary_id='57576.Çalışan'></td>
                <td>
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                    <input type="text" name="employee_name" id="employee_name" style="width:100px;" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>">	
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.employee_id&field_name=search_form.employee_name&select_list=1','list');">
                    <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>		   
                </td>
                <td>
                    <select name="branch_id" id="branch_id">
                    	<option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
                        <cfoutput query="GET_BRANCH_NAMES"><option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and attributes.branch_id eq BRANCH_ID> selected</cfif>>#BRANCH_NAME#</option></cfoutput>
                    </select>
                </td>
                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç tarihini yazınız'>!</cfsavecontent>
                    <cfif isdefined("attributes.startdate")>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" maxlength="10" message="#message#" validate="#validate_style#" style="width:65px;">
                    <cfelse>
                        <cfinput type="text" name="startdate" value="" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#">
                    </cfif>
                    <cf_wrk_date_image date_field="startdate">
                </td>
                <td><cfsavecontent variable="message1"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                    <cfif isdefined("attributes.finishdate")>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" maxlength="10" message="#message1#" validate="#validate_style#" style="width:65px;">
                    <cfelse>
                        <cfinput type="text" name="finishdate" value="" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message1#">
                    </cfif>
                    <cf_wrk_date_image date_field="finishdate">
                </td>
                <td>
                    <select name="answer_state" id="answer_state" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="0"<cfif isdefined('attributes.answer_state') and (attributes.answer_state eq 0)> selected</cfif>><cf_get_lang dictionary_id='55723.Cevap Dönülen'></option>
                        <option value="1"<cfif isdefined('attributes.answer_state') and (attributes.answer_state eq 1)> selected</cfif>><cf_get_lang dictionary_id='55729.Cevap Dönülmeyen'></option>
                    </select>	
                </td>
                <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                  <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;"></td>
                <td><cf_wrk_search_button></td>
            </tr>
        </table>
    </cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='55730.İtiraz Eden'></th>
            <th width="550"><cf_get_lang dictionary_id='55719.İtiraz'></th>
            <th width="75"><cf_get_lang dictionary_id='55736.İtiraz Tarihi'></th>
            <th width="75"><cf_get_lang dictionary_id='55684.İlgili Tarih'></th>
            <th class="header_icn_none"></th>
        </tr>
    </thead>
    <tbody>
		<cfif isdefined("attributes.form_varmi") and get_protests.recordcount>
			<cfoutput query="GET_PROTESTS"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#GET_PROTESTS.EMPLOYEE_NAME#   #GET_PROTESTS.EMPLOYEE_SURNAME#</td>
                    <td>#left(GET_PROTESTS.PROTEST_DETAIL,100)#</td>
                    <td>#dateformat(GET_PROTESTS.PROTEST_DATE,dateformat_style)#</td>
                    <td>#dateformat(GET_PROTESTS.ACTION_DATE,dateformat_style)#</td>
                    <td width="15">
                        <a href="javascript://" onClick=" windowopen('#request.self#?fuseaction=hr.popup_add_protest_answer&id=#GET_PROTESTS.PROTEST_ID#&employee_id=#employee_id#','medium');"><cfif GET_PROTESTS.ANSWER_DETAIL IS NOT ""><img src="/images/update_list.gif" title="Cevap Güncelle"border="0"><cfelse><img src="/images/plus_list.gif" title="Cevap Yaz" border="0"></cfif></a>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
            	<td colspan="5"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfset adres="ehesap.list_emp_daily_in_out_protest&form_varmi=1">
<cfif isDefined('attributes.employee_id') and len(attributes.employee_name)>
	<cfset adres="#adres#&employee_id=#attributes.employee_id#">
</cfif>
<cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
	<cfset adres="#adres#&employee_name=#attributes.employee_name#">
</cfif>
<cfif isDefined('attributes.branch_id')>
	<cfset adres="#adres#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isDefined('attributes.startdate')>
	<cfset adres="#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
</cfif>
<cfif isDefined('attributes.finishdate')>
	<cfset adres="#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
</cfif>
<cfif isDefined('attributes.answer_state')>
	<cfset adres="#adres#&answer_state=#attributes.answer_state#">
</cfif>
<cf_paging 
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#adres#">
