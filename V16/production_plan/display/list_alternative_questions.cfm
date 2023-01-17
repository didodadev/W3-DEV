<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_alternative_questions" datasource="#dsn#">
        SELECT 
            SAQ.QUESTION_NO,
            SAQ.QUESTION_ID,
            SAQ.QUESTION_NAME,
            SAQ.QUESTION_DETAIL,
            SAQ.ALTERNATIVE_PROCESS,
            PP.PROPERTY_ID,
            SAQ.PROPERTY_ID,
            PP.PROPERTY

        FROM 
            SETUP_ALTERNATIVE_QUESTIONS AS SAQ
            LEFT JOIN #DSN1#.PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=SAQ.PROPERTY_ID
        WHERE
        	1 = 1 
        	<cfif len(attributes.keyword)>
                AND (SAQ.QUESTION_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR QUESTION_DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
            </cfif>
    </cfquery>
<cfelse>
	<cfset get_alternative_questions.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_alternative_questions.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="#request.self#?fuseaction=prod.list_alternative_questions" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" >
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Alternatif Ürün Soruları','63637')#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id="58810.Soru"> <cf_get_lang dictionary_id="57487.No"></th>
                    <th><cf_get_lang dictionary_id='58810.Soru'></th>
                    <th><cf_get_lang dictionary_id="57629.Açıklama"></th>
                    <th><cf_get_lang dictionary_id='34311.Alternatif'><cf_get_lang dictionary_id='57692.İşlem'></th>
                    <th><cf_get_lang dictionary_id='46057.Ürün Özelliği'></th>
                    <th width="20" class="header_icn_none"> <cfoutput><a href="javascript://"onclick="openBoxDraggable('#request.self#?fuseaction=prod.list_alternative_questions&event=add')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></cfoutput></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_alternative_questions.recordcount>
                    <cfoutput query="get_alternative_questions" STARTROW="#attributes.startrow#" MAXROWS="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#question_no#</td>
                            <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=prod.list_alternative_questions&event=upd&question_id=#question_id#');">#question_name#</a></td>
                            <td>#left(QUESTION_DETAIL,150)#</td>
                            <td>
                                <cfif alternative_process eq 1>
                                    <cf_get_lang dictionary_id='57452.Stok'><cf_get_lang dictionary_id='35651.Değiştir'>
                                </cfif>
                                <cfif alternative_process eq 2>
                                    <cf_get_lang dictionary_id='57686.Ölçü'><cf_get_lang dictionary_id='35651.Değiştir'>
                                </cfif>
                                <cfif alternative_process eq 3>
                                    <cf_get_lang dictionary_id='57632.Özellik'><cf_get_lang dictionary_id='35651.Değiştir'>
                                </cfif>
                            </td>
                            <td>#property#</td>
                            <td><a href="javascript://"onclick="openBoxDraggable('#request.self#?fuseaction=prod.list_alternative_questions&event=upd&question_id=#question_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfset url_str = "">
        <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        <cfif isdefined("attributes.form_submitted")>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#get_alternative_questions.recordcount#"
            startrow="#attributes.startrow#"
            adres="prod.list_alternative_questions#url_str#">
    </cf_box>
</div>
