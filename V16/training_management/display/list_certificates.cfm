<cfset certificates= createObject("component","V16.training_management.cfc.certificates") />

<cfset get_certificates =certificates.get_certificates() />
<cfparam name="attributes.certificate_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.date_of_validity" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.date_of_validity") and len(attributes.date_of_validity)>
	<cf_date tarih = "attributes.date_of_validity">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
    
    <cfset get_certificates_list =certificates.get_training_certificates() />
	<cfscript>
                certificates.dsn = dsn;
				get_certificates_list = certificates.get_training_certificates(
                    certificate_id : '#iif(isdefined("attributes.certificate_id"),"attributes.certificate_id",DE(""))#' ,
                    employee_id: '#iif(isdefined("attributes.employee_id"),"attributes.employee_id",DE(""))#' ,
                    employee_name: '#iif(isdefined("attributes.employee_name"),"attributes.employee_name",DE(""))#' ,
                    consumer_id: '#iif(isdefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#' ,
                    partner_id: '#iif(isdefined("attributes.partner_id"),"attributes.partner_id",DE(""))#' ,
                    date_of_validity: '#iif(isdefined("attributes.date_of_validity"),"attributes.date_of_validity",DE(""))#' ,
                    startrow:'#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
                    maxrows:'#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
			);
	</cfscript>
    <cfparam name="attributes.totalrecords" default="#get_certificates_list.recordcount#">
<cfelse>
	<cfset get_certificates_list.recordcount=0>
    <cfparam name="attributes.totalrecords" default="0">
</cfif>
<cf_catalystHeader>

<div class="col col-12">
    <cf_box>
        <cfform name="search" id="search" method="post" action="#request.self#?fuseaction=training_management.certificates">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <select id="certificate_id" name="certificate_id">
                        <option value=""><cf_get_lang dictionary_id='46604.Sertifika'></option>
                        <cfoutput query="get_certificates">
                        <option value="#certificate_id#" <cfif attributes.certificate_id eq certificate_id>selected</cfif>>#certificate_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group large" id="form_ul_employee_id">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='46604.Sertifika'><cf_get_lang dictionary_id='57662.Alan'></cfsavecontent>
                    <div class="input-group">
                        <cfoutput>
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
                            <input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
                            <input type="text" name="employee_name" id="employee_name" placeholder="#message#" value="<cfif isdefined('attributes.employee_name')><cfoutput>#attributes.employee_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','consumer_id,PARTNER_ID,EMPLOYEE_ID','consumer_id,partner_id,employee_id','','3','200','get_company()');" passthrough="readonly">
                            <span class="input-group-addon icon-ellipsis btnPointer" 
                            onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&is_period_kontrol=0&field_location=service&field_emp_id=search.employee_id&field_partner=search.partner_id&field_consumer=search.consumer_id&field_name=search.employee_name&select_list=1,2,3</cfoutput>','list');"></span>
                        </cfoutput>
                    </div>
                </div>
                <div class="form-group" id="form_ul_start_date">
                    <cfsavecontent variable="tarih"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></cfsavecontent>
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'> !</cfsavecontent>
                        <cfinput type="text" name="date_of_validity" id="date_of_validity" value="#dateformat(attributes.date_of_validity,dateformat_style)#" validate="#validate_style#" placeholder="#tarih#" message="#message#" maxlength="10"  >
                        <span class="input-group-addon"><cf_wrk_date_image date_field="date_of_validity"></span>                 
                    </div>
                </div>  
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" >
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div  id="aa"></div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.certificates&event=add"> <i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box> 
    <cf_box title="#getLang(dictionary_id: 29693)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='46604.Sertifika'></th>
                <th><cf_get_lang dictionary_id='46604.Sertifika'><cf_get_lang dictionary_id='57662.Alan'></th>
                <th><cf_get_lang dictionary_id='32619.Alım Tarihi'></th>
                <th><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></th>
                <th><cf_get_lang dictionary_id='36199.Açıklama'></th> 
                <th><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.certificates&event=add"><i class="fa fa-plus"></i></a></th>
            </thead> 
            <cfif get_certificates_list.recordcount>
             
                <cfoutput query="get_certificates_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tbody>
                        <td width="30">#currentrow#</td>
                        <td>#certificate_name#</td>
                        <td>
                            <cfif len(employee_id)>
                                <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#get_emp_info(employee_id,0,0)#</a>
                            </cfif>
                            <cfif len(partner_id)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium');" class="tableyazi">#get_par_info(partner_id,0,0,0)#</a>
                            </cfif>
                            <cfif len(consumer_id)>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#consumer_id#','medium');" class="tableyazi">#get_cons_info(consumer_id,0,0,0)#</a>
                            </cfif>
                        </td>
                        <td>#dateFormat(get_date,dateformat_style)#</td>
                        <td>#dateFormat(date_of_validity,dateformat_style)#</td>
                        <td>#detail#</td>
                        <td><a href="#request.self#?fuseaction=training_management.certificates&event=upd&training_certificate_id=#training_certificate_id#"><i class="fa fa-pencil"></i></a></td>
                    </tbody>
                </cfoutput>
                <cfelse>
                    <tbody>
                    <td colspan="7"><cfif isDefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td></tbody>
                </cfif>
            
        </cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "is_form_submitted=1">
            <cfif Len(attributes.certificate_id)><cfset url_str = "#url_str#&certificate_id=#attributes.certificate_id#"></cfif>
            <cfif Len(attributes.date_of_validity)><cfset url_str = "#url_str#&date_of_validity=#attributes.date_of_validity#"></cfif>
            <cfif Len(attributes.employee_id) and Len(attributes.employee_name)>
                <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#&employee_name=#attributes.employee_name#">
            </cfif>
            <cfif Len(attributes.partner_id)>
                <cfset url_str = "#url_str#&partner_id=#attributes.partner_id#&employee_name=#attributes.employee_name#">
            </cfif>
            <cfif Len(attributes.consumer_id)>
                <cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#&employee_name=#attributes.employee_name#">
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="training_management.certificates&#url_str#">
        </cfif>
    </cf_box>
</div>
<script>
    	function open_history(url,id) {
	
		
		AjaxPageLoad(url,id,1);
		return false;
	}
</script>