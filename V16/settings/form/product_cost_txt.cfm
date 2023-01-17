<cfparam name="attributes.start_date" default="#dateformat(dateadd('d',-1,now()),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfif isdefined("attributes.deneme1_id")>
	<cfquery name="get_doc" datasource="#dsn#">
    	SELECT DOCUMENT_NAME FROM COST_TXT WHERE DOUMENT_ID = #attributes.deneme1_id#
    </cfquery>
    <cffile action="delete" file="#get_doc.DOCUMENT_NAME#">
    <cfquery name="delete_doc" datasource="#DSN#">
    	DELETE FROM COST_TXT WHERE DOUMENT_ID = #attributes.deneme1_id#
    </cfquery>
    <cflocation url="#request.self#?fuseaction=settings.list_product_cost_txt" addtoken="no">
</cfif>
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.start_date" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif isdefined("attributes.form_submit")>
	<cfquery name="get_maliyet_doc" datasource="#dsn#">
    	SELECT DOUMENT_ID,DOCUMENT_NAME,RECORD_DATE,RECORD_EMP FROM COST_TXT WHERE RECORD_DATE BETWEEN #attributes.start_date# and #dateadd('d',1,attributes.finish_date)#
    </cfquery>
<cfelse>
	<cfset get_maliyet_doc.recordcount = 0>	
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=settings.list_product_cost_txt" method="post">
            <input type="hidden" name="form_submit" id="form_submit" value="1" />
            <cf_box_search>
                <div class="form-group"> 
                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id='58053.Başlangıç tarihi'></cfsavecontent>
                    <div class="input-group">
                        <cfinput type="text" name="start_date" placeholder="#message1#" value="#dateformat(attributes.start_date,dateformat_style)#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.bitiş tarihi'></cfsavecontent>
                    <div class="input-group">
                        <cfinput type="text" name="finish_date" placeholder="#message#" value="#dateformat(attributes.finish_date,dateformat_style)#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Maliyet',58258)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='29800.Dosya Adı'></th>
                    <th><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th width="20" class="header_icn_none"><a href="javascript://"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.sil'>" alt="<cf_get_lang dictionary_id='57463.sil'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_maliyet_doc.recordcount>
                    <cfoutput query="get_maliyet_doc">
                        <tr>
                            <cfif listlen(DOCUMENT_NAME,'\') gt 6>
                                <td>#ListgetAt(DOCUMENT_NAME,6,'\')#</td>
                            <cfelse>
                                <td>#ListgetAt(DOCUMENT_NAME,2,'/')#</td>
                            </cfif>
                            <td>#get_emp_info(RECORD_EMP,0,1)#</td>
                            <td>#RECORD_DATE#</td>
                            <td><a target="_blank" class="tableyazi" href="#request.self#?fuseaction=settings.list_product_cost_txt&deneme_id=#DOUMENT_ID#" title="<cf_get_lang dictionary_id='48969.aç'>"><i class="icn-md fa fa-chain"></i></a></td>
                            <td><a href="#request.self#?fuseaction=settings.list_product_cost_txt&deneme1_id=#DOUMENT_ID#" title="<cf_get_lang dictionary_id='57463.sil'>"><i class="fa fa-minus"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<cfif isdefined("attributes.deneme_id")>
	<cfquery name="get_doc" datasource="#dsn#">
    	SELECT DOCUMENT_NAME FROM COST_TXT WHERE DOUMENT_ID = #attributes.deneme_id#
    </cfquery>
    <cfif listlen(get_doc.DOCUMENT_NAME,'\') gt 6>
        <cfset attributes.file_name = ListLast(get_doc.DOCUMENT_NAME,'\')>
     <cfelse>
        <cfset attributes.file_name = ListLast(get_doc.DOCUMENT_NAME,'/')>
     </cfif>
    <cfset DOCUMENT_NAME = upload_folder & 'settings\'& attributes.file_name>
    <cfheader name="Content-Disposition" value="attachment; filename=#attributes.file_name#">
    <cfcontent file="#Replace(DOCUMENT_NAME,'/','\','all')#" type="text/plain" deletefile="no">
    <!---<cflocation addtoken="no" url="#DOCUMENT_NAME#">--->
</cfif>