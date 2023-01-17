<cf_get_lang_set module_name="pos"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = date_add('d',-1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_FILE_EXPORTS" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
        SELECT
            FI.E_ID,
            FI.PRODUCT_COUNT,
            FI.TARGET_SYSTEM,
            FI.FILE_NAME,
            FI.FILE_SIZE,
            FI.STARTDATE,
            FI.FINISHDATE,
            FI.RECORD_DATE,
            FI.RECORD_EMP,
            FI.PRICE_RECORD_DATE,
            FI.PRODUCT_RECORD_DATE,
            FI.DEPARTMENT_ID,
            FI.IS_PHL,
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM
            FILE_EXPORTS FI,
            #dsn_alias#.EMPLOYEES E
        WHERE
            FI.RECORD_EMP = E.EMPLOYEE_ID AND
            FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
            AND FI.DEPARTMENT_ID IN 
            	(
            	SELECT 
                	D.DEPARTMENT_ID 
                FROM 
                	#dsn_alias#.DEPARTMENT D,
                    #dsn_alias#.BRANCH B 
                WHERE 
                	B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
                    B.BRANCH_ID = D.BRANCH_ID
                )
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
        </cfif>
        <cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
            AND FI.TARGET_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.target_pos#">
        </cfif>
            AND FI.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
            AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATE_ADD("d",1,attributes.finish_date)#">
        ORDER BY
            FI.RECORD_DATE DESC
    </cfquery>
<cfelse>
	<cfset get_file_exports.recordcount = 0>
</cfif>

<cfif fusebox.circuit is not 'store'>
	<cfinclude template="../../../../V16/pos/query/get_branch.cfm">
</cfif>
<cfif get_file_exports.recordcount>
	<cfinclude template="../../../../V16/pos/query/get_department.cfm">
	<cfset department_list = listsort(listdeleteduplicates(ValueList(get_department.department_id,',')),'numeric','ASC',',')>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_file_exports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.target_pos" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.list_stock_export">
            <input type="hidden" name="form_submitted" id="form_submitted" value="">
            <cf_box_search more="0">
                <div class="form-group">
                    <select name="target_pos" id="target_pos" style="width:120px;">
                        <option value=""><cf_get_lang dictionary_id='58594.Format'></option>
                        <option value="-1" <cfif attributes.target_pos eq -1>selected</cfif>>Genius</option>
                        <option value="-2" <cfif attributes.target_pos eq -2>selected</cfif>>Inter</option>
                        <option value="-3" <cfif attributes.target_pos eq -3>selected</cfif>>NCR</option>
                        <option value="-5" <cfif attributes.target_pos eq -5>selected</cfif>>NCR-AS@R</option>
                        <option value="-6" <cfif attributes.target_pos eq -6>selected</cfif>>ESPOS</option>
                        <option value="-4" <cfif attributes.target_pos eq -4>selected</cfif>>Workcube</option>
                        <option value="-8" <cfif attributes.target_pos eq -8>selected</cfif>>Wincor Nixdorf</option>
                    </select>
                </div>
                <cfif not fusebox.circuit is "store">
                    <div class="form-group">
                        <select name="branch_id" id="branch_id">
                            <option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                            <cfoutput query="get_branch">
                                <option value="#branch_id#" <cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </cfif>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='43958.Kayıt Sayısı Hatalı'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" maxlength="3" onKeyUp="isNumber(this)" range="1,250" required="yes" message="#message#" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=retail.list_stock_export&event=add<cfif fusebox.circuit is "store">&department_id=#listfirst(session.ep.user_location,"-")#&is_branch=1</cfif></cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36043.Export Ekle'>"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61830.Yazar Kasa Bilgi Hazırlama'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='61464.Şube/Depo'></th>
                    <th><cf_get_lang dictionary_id='58690.Tarih Aralığı'></th>
                    <th><cf_get_lang dictionary_id='58594.Format'></th>
                    <th><cf_get_lang dictionary_id='33886.Ürün Sayısı'></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cf_get_lang dictionary_id='57467.Not'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=retail.list_stock_export&event=add<cfif fusebox.circuit is "store">&department_id=#listfirst(session.ep.user_location,"-")#&is_branch=1</cfif></cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='36043.Export Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_file_exports.recordcount>
                    <cfoutput query="get_file_exports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#get_department.branch_name[listfind(department_list,department_id,',')]#/#get_department.department_head[listfind(department_list,department_id,',')]#</td>
                            <td>#dateformat(product_record_date,"dd/mm/yyyy")#-#dateformat(price_record_date,"dd/mm/yyyy")#</td>
                            <td><cfif target_system eq -1>Genius<cfelseif target_system eq -2>MPOS<cfelseif target_system eq -3>NCR<cfelseif target_system eq -4>Workcube<cfelseif target_system eq -5>NCR - AS@R<cfelseif target_system eq -6>ESPOS<cfelse><cf_get_lang dictionary_id='36057.Bilinmiyor'></cfif></td>
                            <td>#product_count#</td>
                            <td><a href="#file_web_path#store#dir_seperator##department_id##dir_seperator##file_name#"><img src="/images/attach.gif"></a><cfif len(FILE_SIZE)>#round(FILE_SIZE/1024)#Kb.</cfif></td>
                            <td><cfif is_phl eq 1>PHL</cfif></td>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                            <td>#dateformat(date_add("h",session.ep.time_zone,record_Date),"dd/mm/yyyy")# (#timeformat(date_add("h",session.ep.time_zone,record_Date),"HH:MM")#)</td>
                            <td width="20" class="header_icn_none"><cfif session.ep.admin><a href="#request.self#?fuseaction=retail.list_stock_export&event=delRow&e_id=#e_id#"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></cfif></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>

    <cfset url_string = ''>
    <cfif len(attributes.target_pos)>
        <cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
    </cfif>
    <cfif len(attributes.start_date)>
        <cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,"dd/mm/yyyy")#'>
    </cfif>
    <cfif len(attributes.finish_date)>
        <cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,"dd/mm/yyyy")#'>
    </cfif>
    <cfif len(attributes.branch_id)>
        <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfset url_string = "#url_string#&form_submitted=#attributes.form_submitted#">
    </cfif>
    <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#fusebox.circuit#.list_stock_export#url_string#">
<script type="text/javascript">
function kontrol()
{
	return date_check(document.search_form.start_date,document.search_form.finish_date,"<cf_get_lang dictionary_id='36063.Bitiş Tarihi Başlangıç Tarihinden Küçük'>!");
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->