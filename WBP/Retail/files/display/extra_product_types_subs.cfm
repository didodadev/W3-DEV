<!---
<cf_wrk_grid search_header = "Ürün Ektra Tanımları (Alt Tanımlar)" dictionary_count="1" table_name="EXTRA_PRODUCT_TYPES_SUBS" sort_column="SUB_TYPE_NAME" u_id="SUB_TYPE_ID" datasource="#dsn_dev#" is_delete="1" search_areas = "SUB_TYPE_NAME">
    <cf_wrk_grid_column name="SUB_TYPE_ID" header="ID" display="yes" width="50" select="no"/>
    <cf_wrk_grid_column name="TYPE_ID" header="Üst Grup" display="yes" width="75" select="yes"/>
    <cf_wrk_grid_column name="SUB_TYPE_NAME" header="Tip" select="yes" display="yes"/>
</cf_wrk_grid>
--->
<cfparam name="attributes.form_submitted" default="1">

<cfparam name="attributes.type_id" default="">
<cfparam name="attributes.keyword" default="">

<cfquery name="get_types" datasource="#dsn_dev#">
	SELECT * FROM EXTRA_PRODUCT_TYPES ORDER BY TYPE_NAME
</cfquery>

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_table_codes" datasource="#dsn_dev#">
    	SELECT
        	E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            (SELECT E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = ST.UPDATE_EMP) AS GUNCELLEYEN,
            ST.*,
            EPT.TYPE_NAME
        FROM
        	EXTRA_PRODUCT_TYPES_SUBS ST,
            EXTRA_PRODUCT_TYPES EPT,
            #dsn_alias#.EMPLOYEES E
        WHERE
        	<cfif len(attributes.type_id)>
            	ST.TYPE_ID = #attributes.type_id# AND
            </cfif>
			<cfif len(attributes.keyword)>
            	(
                ST.SUB_TYPE_NAME LIKE '%#attributes.keyword#%' 
               	OR
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
                OR
                EPT.TYPE_NAME LIKE '%#attributes.keyword#%'
                )
                AND
            </cfif>
            ST.TYPE_ID = EPT.TYPE_ID AND
        	ST.RECORD_EMP = E.EMPLOYEE_ID
        ORDER BY
        	EPT.TYPE_NAME,
            ST.SUB_TYPE_NAME
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
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.extra_product_types_subs">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
             <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'> </cfsavecontent>
                        <cfinput type="text" name="keyword" id="keyword" style="width:75px;" placeholder="#message#" value="#attributes.keyword#" maxlength="500">
                    </div>
                </div>
                <div class="form-group">
                    <select name="type_id">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <cfoutput query="get_types">
                        <option value="#type_id#" <cfif attributes.type_id eq type_id>selected</cfif>>#type_name#</option>
                        </cfoutput>
                    </select>
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
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61510.Ürün Ektra Tanımları (Alt Tanımlar)'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id ='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='61509.Üst Kriter'></th>
                    <th><cf_get_lang dictionary_id='50669.Kriter'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th><cf_get_lang dictionary_id ='57627.Kayit Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57703.Güncelleme'></th>
                    <th><cf_get_lang dictionary_id='52377.Güncelleme Tarihi'></th>
                    <th width="20"><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.extra_product_types_subs&event=add','medium');"><i class="fa fa-plus"></i></a></cfoutput></th>
                </tr> 
            </thead>
            <tbody>
                <cfif get_table_codes.recordcount>
                <cfoutput query="get_table_codes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#TYPE_NAME#</td>
                        <td>#SUB_TYPE_NAME#</td>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                        <td>
                            <cfset record_ = dateadd("h",session.ep.time_zone,record_Date)>
                            #dateformat(record_,'dd/mm/yyyy')# #timeformat(record_,'HH:MM')#
                        </td>
                        <td>#GUNCELLEYEN#</td>
                        <td>
                            <cfif len(update_Date)>
                                <cfset update_ = dateadd("h",session.ep.time_zone,update_Date)>
                                #dateformat(update_,'dd/mm/yyyy')# #timeformat(update_,'HH:MM')#
                            </cfif>
                        </td>
                        <td width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.extra_product_types_subs&event=upd&sub_type_id=#sub_type_id#','medium');"><img src="/images/update_list.gif" /></a></td>
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
            <cfif len(attributes.keyword)>
                <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
            </cfif>
            <cfif isdefined("attributes.type_id")>
                <cfset url_string = '#url_string#&type_id=#attributes.type_id#'>
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="retail.extra_product_types_subs#url_string#">
            
        </cfif>
    </cf_box>
</div>

