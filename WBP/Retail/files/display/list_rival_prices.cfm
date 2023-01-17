<cfparam name="attributes.form_submitted" default="1">
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = date_add('d',-15,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = date_add('d',7,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>	
</cfif>

<cfparam name="attributes.table_code" default="">
<cfset attributes.table_code = replace(attributes.table_code,',','+','all')>

<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_table_codes" datasource="#dsn_dev#">
    	SELECT
        	E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            (SELECT COUNT(DISTINCT STP.PRODUCT_ID) AS SAYI FROM #dsn3_alias#.PRICE_RIVAL STP WHERE STP.TABLE_CODE = ST.TABLE_CODE) AS URUN_SAYISI,
            (SELECT E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = ST.UPDATE_EMP) AS GUNCELLEYEN,
            ST.*
        FROM
        	RIVAL_TABLES ST,
            #dsn_alias#.EMPLOYEES E
        WHERE
			<cfif len(attributes.table_code)>
            	<cfif listlen(attributes.table_code,'+') eq 1>
            		ST.TABLE_CODE LIKE '%#attributes.table_code#%' AND
                <cfelse>
                	(
                    	<cfloop from="1" to="#listlen(attributes.table_code,'+')#" index="ccc">
                        	<cfset code_ = listgetat(attributes.table_code,ccc,'+')>
                        	ST.TABLE_CODE LIKE '%#code_#'
                        	<cfif ccc neq listlen(attributes.table_code,'+')>OR</cfif>
                        </cfloop>
                    )
                    AND
                </cfif>
            </cfif>
            <cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
            	(
                ST.RECORD_EMP = #attributes.record_emp_id#
                OR
                ST.UPDATE_EMP = #attributes.record_emp_id#
                ) 
                AND
            </cfif>
            (
            ST.RECORD_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
            OR
            ST.RECORD_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
            ) 
            AND
        	ST.RECORD_EMP = E.EMPLOYEE_ID
    </cfquery>
<cfelse>
	<cfset get_table_codes.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_table_codes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search more="0">
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61483.Tablo No'></cfsavecontent>
                        <cfinput type="text" name="table_code" id="table_code" style="width:200px;" value="#attributes.table_code#" maxlength="500" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57899.Kaydeden'></cfsavecontent>
                        <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                        <input name="record_emp_name" type="text" id="record_emp_name" style="width:100px;" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off" placeholder="<cfoutput>#getLang("","Kaydeden",57899)#</cfoutput>">
                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.record_emp_id&field_name=search_form.record_emp_name&select_list=1&is_form_submitted=1','list','popup_list_positions');"><img src="/images/plus_thin.gif"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61493.Rakip Fiyat Listeleri'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='61478.Tablo Kodu'></th>
                    <th><cf_get_lang dictionary_id='61494.Tablo Açıklama'></th>
                    <th><cf_get_lang dictionary_id='45899.Ürün Sayısı'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th><cf_get_lang dictionary_id='58050.Son Güncelleme'></th>
                    <th><cf_get_lang dictionary_id='52377.Güncelleme Tarihi'></th>
                    <th width="20"><cfoutput><a href="#request.self#?fuseaction=retail.list_rival_price&event=add"><i class="fa fa-plus"></i></a></cfoutput></th>
                </tr> 
            </thead>
            <tbody>
                <cfif get_table_codes.recordcount>
                <cfoutput query="get_table_codes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td><a href="#request.self#?fuseaction=retail.list_rival_price&event=upd&table_code=#table_code#&is_form_submitted=1" class="tableyazi">#TABLE_CODE#</a></td>
                        <td>#table_info#</td>
                        <td>#URUN_SAYISI#</td>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                        <td>#dateformat(record_Date,'dd/mm/yyyy')#</td>
                        <td>#GUNCELLEYEN#</td>
                        <td>#dateformat(update_Date,'dd/mm/yyyy')#</td>
                        <td><a href="#request.self#?fuseaction=retail.list_rival_price&event=upd&table_code=#table_code#&is_form_submitted=1"><i class="fa fa-pencil"></i></a></td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif len(attributes.table_code)>
                <cfset url_string = '#url_string#&table_code=#attributes.table_code#'>
            </cfif>
            <cfif len(attributes.startdate)>
                <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif len(attributes.finishdate)>
                <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif isdefined("attributes.form_submitted")>
                <cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
            </cfif>	
            <cfif isdefined("attributes.record_emp_id")>
                <cfset url_string = '#url_string#&record_emp_id=#attributes.record_emp_id#'>
            </cfif>	
            <cfif isdefined("attributes.record_emp_name")>
                <cfset url_string = '#url_string#&record_emp_name=#attributes.record_emp_name#'>
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="retail.list_rival_price#url_string#">
        </cfif>
    </cf_box>
</div>

