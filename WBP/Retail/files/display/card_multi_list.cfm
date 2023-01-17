<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = "">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = "">
</cfif>
<cfset attributes.form_submitted = 1>
<cfparam name="attributes.kod" default="">

<cfif isdefined("attributes.form_submitted")>
    <cfquery name="GET_CARDS" datasource="#DSN_dev#"> 
        SELECT
        	(SELECT COUNT(SUB_ROW_ID) FROM GENIUS_POINT_ADDS_ROWS GAPR WHERE GAPR.ROW_ID = GAP.ROW_ID) AS URUN_SAYISI,
            GAP.*,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM 
        	GENIUS_POINT_ADDS GAP,
            #dsn_alias#.EMPLOYEES E
        WHERE 
        	GAP.RECORD_EMP = E.EMPLOYEE_ID
         	<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                AND GAP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                AND GAP.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.finish_date)#">
            </cfif>
            <cfif len(attributes.kod)>
            	AND GAP.WRK_ID = '#attributes.kod#'
            </cfif>
        ORDER BY 
        	RECORD_DATE DESC    
   </cfquery>
<cfelse>
	<cfset get_cards.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif GET_CARDS.recordcount>
	<cfparam name="attributes.totalrecords" default='#GET_CARDS.RECORDCOUNT#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfset total_kazanilan = 0>
<cfset total_kullanilan = 0>
<cfset total_alan = 0>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="srch_form" action="#request.self#?fuseaction=retail.card_multi_list" method="post">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='58585.Kod'></cfsavecontent>
                    <cfinput type="text" name="kod" placeholder="#message#" value="#attributes.kod#">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                        <cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" placeholder="#message#">				
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                        <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" placeholder="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='43958.Kayıt Sayısı Hatalı'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='61839.Genius Müşteri Kartı Toplu İşlemler'></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58585.Kod'></th>
                    <th><cf_get_lang dictionary_id='58586.İşlem Yapan'></th>
                    <th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
                    <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='61840.Sıfırlama'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id='61841.Kart Sayısı'></th>
                    <th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.card_multi_list&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></a></th>
                </tr>
            </thead>
            <tbody>
            <cfif get_cards.recordcount>
                <cfoutput query="GET_CARDS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.card_multi_list%event=upd&row_id=#row_id#','list');" class="tableyazi">#wrk_id#</a></td>
                        <td>#employee_name# #employee_surname#</td>
                        <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                        <td>#detail#</td>
                        <td><cfif is_clear eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></td>
                        <td style="text-align:right;">#URUN_SAYISI#</td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr><td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td></tr>
            </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>


<cfset adres = attributes.fuseaction>
<cfif isdefined('form_submitted')><cfset adres = adres&"&form_submitted=1"></cfif>
<cfif len(attributes.kod)>
	<cfset adres = adres&"&kod=#attributes.kod#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset adres = adres&"&finish_date=#attributes.finish_date#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset adres = adres&"&start_date=#attributes.start_date#">
</cfif>

<cf_paging 
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#attributes.totalrecords#"
	startrow="#attributes.startrow#" 
	adres="#adres#">