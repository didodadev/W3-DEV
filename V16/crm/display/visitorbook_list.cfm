<cfparam name="attributes.visit_name" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cfparam name="attributes.start_date" default="#dateformat(attributes.start_date,dateformat_style)#">
<cfelse>
	<cfparam name="attributes.start_date" default="#dateformat((date_add('m',-1,CreateDate(year(now()),month(now()),1))),dateformat_style)#">
</cfif>
<cfparam name="attributes.finish_date" default="#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),dateformat_style)#">
<cfparam name="attributes.keyword" default="">

<cfset visitbookdata = createObject("component","V16.crm.cfc.visitorbook")>
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
    <cfset visitordata = visitbookdata.getlist(visit_name : attributes.visit_name,start_date : attributes.start_date,finish_date : attributes.finish_date,keyword : attributes.keyword)>
<cfelse>
    <cfset visitordata.recordcount=0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#visitordata.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfscript>
	url_str = "";
	if (len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (isdefined("attributes.startdate"))
		url_str = "#url_str#&startdate=#attributes.start_date#";
	if (isdefined("attributes.finishdate"))
		url_str = "#url_str#&finishdate=#attributes.finish_date#";
	if (isdefined("attributes.is_submitted"))
		url_str = "#url_str#&is_submitted=1";
</cfscript>

<cfif isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="list_visit" method="post" action="#request.self#?fuseaction=crm.visitorbook">
        <input type="hidden" name="is_submitted" id="is_submitted" value="1">
        <cf_box>
            <cf_box_search more=0>
                <div class="form-group" id="item-keyword">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
                </div>

                <div class="form-group" id="item-start_date">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlangıç tarihi girmelisiniz'></cfsavecontent>
                        <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                            <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.start_date,dateformat_style)#">
                        <cfelse>
                            <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" message="#message#">
                        </cfif>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>

                <div class="form-group" id="item-finish_date">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
                        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                            <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finish_date,dateformat_style)#">
                        <cfelse>
                            <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" message="#message#">
                        </cfif>
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                
                <div class="form-group small" id="item-max_rows">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>

                <div class="form-group" id="item-search_button">
                    <cf_wrk_search_button  search_function='change_action()'  button_type="4">
                </div>
                <div class="form-group" id="item-add_button">
                    <a href="<cfoutput>#request.self#?fuseaction=crm.visitorbook&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
        </cf_box>
    </cfform>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='61443.Ziyaret Defteri'></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1" add_href="#request.self#?fuseaction=crm.visitorbook&event=add" >
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='30364.Kart Numarası'></th>
                    <th><cf_get_lang dictionary_id='55757.Name Last Name'></th>
                    <th><cf_get_lang dictionary_id='52370.Ziyaret Tarihi'></th>
                    <th><cf_get_lang dictionary_id='61007.Giriş Saati'></th>
                    <th><cf_get_lang dictionary_id='61008.Çıkış Saati'></th>
                    <th><cf_get_lang dictionary_id='39774.Ziyaret Nedeni'></th>
                    <th><cf_get_lang dictionary_id='44688.Çalışan Adı'></th>
                    <th><cf_get_lang dictionary_id='29532.Şube Adı'></th>
                    <th><cf_get_lang dictionary_id='42424.Departman Adı'></th>
                    <th style="width:20px;"><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted) and visitordata.recordcount neq 0>
                    <cfoutput query="visitordata" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#visitordata.CARD_NO#</td>
                            <td>#visitordata.VISIT_NAME# #visitordata.VISIT_SURNAME#</td>
                            <td>#dateformat(VISIT_DATE,dateformat_style)#</td>
                            <td>#visitordata.START_TIME# : #visitordata.START_MINUTE#</td>
                            <td>#visitordata.END_TIME# : #visitordata.FINISH_MINUTE# </td>
                            <td>#visitordata.REASON_VISIT#</td>
                            <td>#visitordata.EMPLOYEE_NAME# #visitordata.EMPLOYEE_SURNAME#</td>
                            <td>#visitordata.BRANCH_NAME#</td>
                            <td>#visitordata.DEPARTMENT_HEAD#</td>
                            <td><a href="#request.self#?fuseaction=crm.visitorbook&event=upd&visit_id=#VISIT_ID#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="12">
                        <cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="crm.visitorbook#url_str#">
    </cf_box>
</div>

<script type="text/javascript">
  function change_action()
	{
		if( !date_check(document.all.list_visit.start_date, document.all.list_visit.finish_date, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	}
</script>