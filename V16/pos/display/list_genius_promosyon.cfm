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
<cfquery name="get_price_change_genius" datasource="#DSN2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		E_ID,
		FILE_NAME,
		FILE_SIZE,
		STARTDATE,
		FINISHDATE,
		TARGET_SYSTEM,
		PRODUCT_COUNT,
		FILE_EXPORTS.RECORD_DATE,
		FILE_EXPORTS.RECORD_EMP,
		#DSN_ALIAS#.EMPLOYEES.EMPLOYEE_NAME,
		#DSN_ALIAS#.EMPLOYEES.EMPLOYEE_SURNAME,
		#DSN_ALIAS#.DEPARTMENT.DEPARTMENT_HEAD,
		#DSN_ALIAS#.BRANCH.BRANCH_NAME
	FROM
		FILE_EXPORTS,
		#DSN_ALIAS#.EMPLOYEES,
		#DSN_ALIAS#.DEPARTMENT,
		#DSN_ALIAS#.BRANCH
	WHERE
		FILE_EXPORTS.DEPARTMENT_ID = #DSN_ALIAS#.DEPARTMENT.DEPARTMENT_ID
		AND #DSN_ALIAS#.DEPARTMENT.BRANCH_ID = #DSN_ALIAS#.BRANCH.BRANCH_ID
		AND FILE_EXPORTS.RECORD_EMP = #DSN_ALIAS#.EMPLOYEES.EMPLOYEE_ID
		AND FILE_EXPORTS.PROCESS_TYPE = -4 <!--- Promosyon --->
		<cfif session.ep.isBranchAuthorization>
			AND #DSN_ALIAS#.DEPARTMENT.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND #DSN_ALIAS#.BRANCH.BRANCH_ID = #ATTRIBUTES.BRANCH_ID#
		</cfif>
		AND 
			FILE_EXPORTS.RECORD_DATE BETWEEN #attributes.start_date# AND #DATEADD("d",1,attributes.finish_date)#
	ORDER BY FILE_EXPORTS.RECORD_DATE DESC
</cfquery>
<cfif fusebox.circuit is "pos">
	<cfinclude template="../query/get_branch.cfm">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_price_change_genius.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.branch_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.list_genius_promosyon">
            <cf_box_search more="0" plus="0">
                <div class="form-group">
                    <select name="branch_id" id="branch_id">
                        <option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                        <cfoutput query="get_branch">
                            <option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:70px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="control()" is_excel='0'>
                </div>
                  <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=pos.list_genius_promosyon&event=add&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>');"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='36108.Promosyon Belgesi'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57453.Şube'>/<cfif session.ep.isBranchAuthorization><cf_get_lang dictionary_id='58763.Depo'><cfelseif fusebox.circuit is 'pos'><cf_get_lang dictionary_id='58763.Depo'></cfif></th>
                    <th><cfif session.ep.isBranchAuthorization><cf_get_lang dictionary_id='58690.Tarih Aralığı'><cfelseif fusebox.circuit is 'pos'><cf_get_lang dictionary_id='58690.Tarih Aralığı'></cfif></th>
                    <th><cfif session.ep.isBranchAuthorization><cf_get_lang dictionary_id='58594.Format'><cfelseif fusebox.circuit is 'pos'><cf_get_lang dictionary_id='58594.Format'></cfif></th>
                    <th nowrap="nowrap"><cfif session.ep.isBranchAuthorization><cf_get_lang dictionary_id='36019.Ürün Sayısı'><cfelseif fusebox.circuit is 'pos'><cf_get_lang dictionary_id='36019.Ürün Sayısı'></cfif></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cfif session.ep.isBranchAuthorization><cf_get_lang dictionary_id='57899.Kaydeden'><cfelseif fusebox.circuit is 'pos'><cf_get_lang dictionary_id='57899.Kaydeden'></cfif></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th  width ="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=pos.list_genius_promosyon&event=add&department_id=#listfirst(session.ep.user_location,"-")#</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='45919.Export Ekle'>"></i></a></th>
                </tr> 
            </thead>
            <tbody>
                <cfoutput query="get_price_change_genius" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                 <tr>
                    <td>#branch_name#/#department_head#</td>
                    <td>#dateformat(startdate,dateformat_style)#-#dateformat(finishdate,dateformat_style)#</td>
                    <td><cfif target_system eq -1><cf_get_lang dictionary_id='45932.Genius'><cfelseif target_system eq -2><cf_get_lang dictionary_id='45933.SPS'><cfelse><cf_get_lang dictionary_id ='36057.Bilinmiyor'></cfif></td>
                    <td>#product_count#</td>
                    <td><a href="#file_web_path#store#dir_seperator##file_name#"><img src="/images/attach.gif"></a><cfif len(file_size)>#round(file_size/1024)#Kb.</cfif></td>
                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
                    <cfset new_record_date = date_add("h",session.ep.time_zone,record_Date)>
                    <td>#dateformat(new_record_date,dateformat_style)# (#timeformat(new_record_date,timeformat_style)#)</td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='36074.Kayıtlı Genius Promosyon Belgesini Siliyorsunuz! Emin misiniz'></cfsavecontent>
                <td><cfif session.ep.admin><a href="javascript://" onClick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=pos.emptypopup_del_genius_promotion&e_id=#e_id#','small'); else return false;"><i class="fa fa-minus" border="0"></a></cfif></td>             
             </tr>
                </cfoutput>
                <cfif not get_price_change_genius.recordcount>
                  <tr class="color-row" height="20">
                    <td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                  </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                <cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                <cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
            </cfif>
            <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
            </cfif>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="pos.list_price_change_genius#url_string#"> 
        </cfif>        
    </cf_box>
</div>
<script>
    function control(){
       // return date_check(document.search_form.start_date,document.search_form.finish_date,'<cfoutput>#message#</cfoutput>');
       return true;
    }
</script>


