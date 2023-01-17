<cfparam name="attributes.form_submitted" default="1">
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(now())#-1-1')>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = date_add('d',7,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>	
</cfif>

<cfparam name="attributes.table_code" default="">
<cfset attributes.table_code = replace(attributes.table_code,',','+','all')>
<cfparam name="attributes.keyword" default="">

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_table_codes" datasource="#dsn_dev#">
    	SELECT
            ST.*
        FROM
        	PAYMENT_TABLE ST
        WHERE
			<cfif len(attributes.keyword)>
            	ST.TABLE_DETAIL LIKE '%#attributes.keyword#%' AND
            </cfif>
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
            (
            ST.ACTION_DATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
            OR
            ST.ACTION_STARDATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
            OR
            ST.ACTION_FINISHDATE BETWEEN #attributes.startdate# AND #attributes.finishdate#
            ) 
       ORDER BY
       	ST.TABLE_CODE DESC
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
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61483.Tablo No'></cfsavecontent>
                        <cfinput type="text" name="table_code" id="table_code" style="width:75px;" value="#attributes.table_code#" maxlength="500" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <cfinput type="text" name="keyword" id="keyword" style="width:75px;" value="#attributes.keyword#" maxlength="500" placeholder="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
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
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61486.Ödeme Tabloları'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='61478.Tablo Kodu'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th ><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th ><cf_get_lang dictionary_id='57501.Başlangıç'></th>
                    <th ><cf_get_lang dictionary_id='57502.Bitiş'></th>
                    <th width="20"><cfoutput><a href="#request.self#?fuseaction=retail.list_cheque_management&event=add"><i class="fa fa-plus"></i></a></cfoutput></th>
                </tr> 
            </thead>
            <tbody>
                <cfif get_table_codes.recordcount>
                <cfoutput query="get_table_codes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td><a href="#request.self#?fuseaction=retail.list_cheque_management&event=upd&table_code=#table_code#&is_submit=1" class="tableyazi">#TABLE_CODE#</a></td>
                        <td>#TABLE_DETAIL#</td>
                        <td>#dateformat(action_date,'dd/mm/yyyy')#</td>
                        <td>#dateformat(action_stardate,'dd/mm/yyyy')#</td>
                        <td>#dateformat(action_finishdate,'dd/mm/yyyy')#</td>
                        <td>
                            <a href="#request.self#?fuseaction=retail.list_cheque_management&event=upd&table_code=#table_code#&is_submit=1<cfif is_bank eq 1>&is_bank=1</cfif>"><i class="fa fa-pencil"></i></a>
                        </td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif len(attributes.table_code)>
                <cfset url_string = '#url_string#&table_code=#attributes.table_code#'>
            </cfif>
            <cfif len(attributes.keyword)>
                <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
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
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="retail.list_cheque_management#url_string#">
            
        </cfif>
    </cf_box>
</div>



