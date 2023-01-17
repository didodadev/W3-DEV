<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.answer_state" default="1">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#"> 
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfinclude template="../query/get_branch_name.cfm">
<cfset emp_branch_list=valuelist(GET_BRANCH_NAMES.BRANCH_ID)>
<cfif isdefined("attributes.form_varmi")>
<cfinclude template="../query/get_protests.cfm">
	<cfset arama_yapilmali=0>
	<cfparam name="attributes.totalrecords" default="#get_protests.recordcount#">
<cfelse>
	<cfset get_protests.recordcount=0>
	<cfset arama_yapilmali=1>
	 <cfparam name="attributes.totalrecords" default="0">	
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_protests" method="post" action="#request.self#?fuseaction=ehesap.list_puantaj_protests" >
            <input name="form_varmi" id="form_varmi" value="1" type="hidden">
            <cf_box_search more="0">
                <div class="form-group">
                    <label><cf_get_lang dictionary_id='53628.İtiraz Eden'></label>
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                        <input type="text" name="employee_name" id="employee_name" style="width:100px;" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>">	
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_protests.employee_id&field_name=list_protests.employee_name&select_list=1','list');"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="sal_mon" id="sal_mon">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop from="1" to="12" index="i">
                            <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="sal_year" id="sal_year">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop from="#session.ep.period_year-3#" to="#session.ep.period_year+3#" index="i">
                            <cfoutput>
                                <option value="#i#"<cfif attributes.sal_year eq i> selected</cfif>>#i#</option>
                            </cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id ='30126.Şube Seçiniz'></option>
                        <cfoutput query="GET_BRANCH_NAMES"><option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and attributes.branch_id eq BRANCH_ID> selected</cfif>>#BRANCH_NAME#</option></cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="answer_state" id="answer_state" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="0"<cfif isdefined('attributes.answer_state') and (attributes.answer_state eq 0)> selected</cfif>><cf_get_lang dictionary_id='53630.Cevap Dönülen'></option>
                        <option value="1"<cfif isdefined('attributes.answer_state') and (attributes.answer_state eq 1)> selected</cfif>><cf_get_lang dictionary_id='53629.Cevap Dönülmeyen'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999"  maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53696.Bordro İtirazları"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list> 
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='53628.İtiraz Eden'></th>
                    <th><cf_get_lang dictionary_id='53631.İtiraz'></th>
                    <th><cf_get_lang dictionary_id='53632.İtiraz Tarihi'></th>
                    <th><cf_get_lang dictionary_id='58724.Ay'></th>
                    <th><cf_get_lang dictionary_id='58455.Yıl'></th>
                    <th class="header_icn_none text-center"></th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfinclude template="../query/get_protests.cfm">
                <cfif isdefined("attributes.form_varmi") and get_protests.recordcount>
                    <cfoutput query="GET_PROTESTS"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfset ay=ListGetAt(ay_list(),#GET_PROTESTS.SAL_MON#,',')>
                        <tr>
                            <td width="35">#currentrow#</td>
                            <td>#GET_PROTESTS.EMPLOYEE_NAME#   #GET_PROTESTS.EMPLOYEE_SURNAME#</td>
                            <td>#left(GET_PROTESTS.PROTEST_DETAIL,100)#</td>
                            <td>#dateformat(GET_PROTESTS.PROTEST_DATE,dateformat_style)#</td>
                            <td>#ay#</td>
                            <td>#GET_PROTESTS.SAL_YEAR#</td>
                            <!-- sil -->
                            <td width="15"><a href="javascript://" onClick=" windowopen('#request.self#?fuseaction=ehesap.list_puantaj_protests&event=add&sal_mon=#GET_PROTESTS.SAL_MON#&sal_year=#GET_PROTESTS.SAL_YEAR#&id=#GET_PROTESTS.PROTEST_ID#','medium');"><cfif GET_PROTESTS.ANSWER_DETAIL IS NOT ""><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='53634.Cevap Güncelle'>"border="0"><cfelse><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='53635.Cevap Yaz'>"></cfif></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="7"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list> 
        <cfset adres="ehesap.list_puantaj_protests">
        <cfif isDefined('attributes.form_varmi') and len(attributes.form_varmi)>
            <cfset adres="#adres#&form_varmi=#attributes.form_varmi#">
        </cfif>
        <cfif isDefined('attributes.employee_id') and len(attributes.employee_name)>
            <cfset adres="#adres#&employee_id=#attributes.employee_id#">
        </cfif>
        <cfif isDefined('attributes.employee_name') and len(attributes.employee_name)>
            <cfset adres="#adres#&employee_name=#attributes.employee_name#">
        </cfif>
        <cfif isDefined('attributes.sal_mon')>
            <cfset adres="#adres#&sal_mon=#attributes.sal_mon#">
        </cfif>
        <cfif isDefined('attributes.sal_year')>
            <cfset adres="#adres#&sal_year=#attributes.sal_year#">
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
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('employee_name').focus();
</script>
