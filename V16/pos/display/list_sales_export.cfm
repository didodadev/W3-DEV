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
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME
        FROM
            FILE_EXPORTS FI,
            #dsn_alias#.EMPLOYEES E
        WHERE
            FI.RECORD_EMP = E.EMPLOYEE_ID AND
            FI.PROCESS_TYPE = -13
        <cfif session.ep.isBranchAuthorization>
            AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
        </cfif>
        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
            AND FI.DEPARTMENT_ID IN (SELECT D.DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT D WHERE D.BRANCH_ID = #attributes.branch_id#)
        </cfif>
        <cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
            AND FI.TARGET_SYSTEM = #attributes.target_pos#
        </cfif>
            AND FI.RECORD_DATE BETWEEN #attributes.start_date#
            AND #DATEADD("d",1,attributes.finish_date)#
        ORDER BY
            FI.RECORD_DATE DESC
    </cfquery>
<cfelse>
	<cfset get_file_exports.recordcount = 0>
</cfif>

<cfif fusebox.circuit is 'pos'>
	<cfinclude template="../query/get_branch.cfm">
</cfif>
<cfif get_file_exports.recordcount>
	<cfinclude template="../query/get_department.cfm">
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
		<cfform name="search_form" method="post" action="#request.self#?fuseaction=pos.list_sales_export">
			<cf_box_search more="0"> 
			<input type="hidden" name="form_submitted" id="form_submitted" value="">
				<div class="form-group">
					<select name="target_pos" id="target_pos" style="width:75px;">
						<option value=""><cf_get_lang dictionary_id='58594.Format'></option>
						<option value="-1" <cfif attributes.target_pos eq -1>selected</cfif>><cf_get_lang dictionary_id='32843.Genius'></option>
						<option value="-2" <cfif attributes.target_pos eq -2>selected</cfif>><cf_get_lang dictionary_id='50158.Inter'></option>
						<option value="-3" <cfif attributes.target_pos eq -3>selected</cfif>>N C R</option>
						<option value="-4" <cfif attributes.target_pos eq -4>selected</cfif>><cf_get_lang dictionary_id='58783.Workcube'></option>
					</select>
				</div>
				<cfif session.ep.isBranchAuthorization eq 0>
					<div class="form-group">
						<select name="branch_id" id="branch_id">
						<option value=""><cf_get_lang dictionary_id='29495.T??m ??ubeler'></option>
						<cfoutput query="get_branch">
							<option value="#branch_id#" <cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
						</cfoutput>
						</select>
					</div>
				</cfif>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#" style="width:25px;">
				</div>
				<div class="form-group">            
					<cf_wrk_search_button button_type="4" search_function="kontrol()">                
				</div>
			</cf_box_search>
		</cfform>
    </cf_box>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='57448.Sat????'> <cf_get_lang dictionary_id='59097.Export'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57453.??ube'>/ <cf_get_lang dictionary_id='58763.Depo'></th>
                    <th><cf_get_lang dictionary_id='58690.Tarih Aral??????'></th>
                    <th><cf_get_lang dictionary_id='58594.Format'></th>
                    <th><cf_get_lang dictionary_id='36019.??r??n Say??s??'></th>
                    <th><cf_get_lang dictionary_id='57468.Belge'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kay??t Tarihi'></th>
                    <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_form_sales_export<cfif session.ep.isBranchAuthorization>&department_id=#listfirst(session.ep.user_location,"-")#&is_branch=1</cfif></cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil --><!-- sil -->
                </tr>
			</thead>
			<tbody>
				<cfif get_file_exports.recordcount>
					<cfoutput query="get_file_exports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						  <td>#get_department.branch_name[listfind(department_list,department_id,',')]#/#get_department.department_head[listfind(department_list,department_id,',')]#</td>
						  <td>#dateformat(product_record_date,dateformat_style)#-#dateformat(price_record_date,dateformat_style)#</td>
						  <td><cfif target_system eq -1>Genius<cfelseif target_system eq -2>MPOS<cfelseif target_system eq -3>NCR<cfelseif target_system eq -4>Workcube<cfelse><cf_get_lang dictionary_id ='36057.Bilinmiyor'></cfif></td>
						  <td>#product_count#</td>
						  <td><a href="#file_web_path#store#dir_seperator##file_name#"><img src="/images/attach.gif" border="0" align="absmiddle"></a><cfif len(FILE_SIZE)>#round(FILE_SIZE/1024)#Kb.</cfif></td>
						  <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
						  <td>#dateformat(date_add("h",session.ep.time_zone,record_Date),dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_Date),timeformat_style)#)</td>
						  <td><cfif session.ep.admin><a href="javascript://" onClick="javascript:if(confirm('Kay??tl?? Stok Export Belgesini Siliyorsunuz! Emin misiniz?')) windowopen('#request.self#?fuseaction=pos.emptypopup_del_stock_export_file&e_id=#e_id#','small'); else return false;"><i class="fa fa-minus" border="0"></a></cfif></td>
						</tr>
				  </cfoutput>
				<cfelse>
					<tr class="color-row" height="20">
						<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kay??t Bulunamad??'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
				  	</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_string = ''>
			<cfif len(attributes.target_pos)>
				<cfset url_string = '#url_string#&target_pos=#attributes.target_pos#'>
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset url_string = '#url_string#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset url_string = '#url_string#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
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
				adres="#fusebox.circuit#.list_sales_export#url_string#">
		</cfif>		
	</cf_box>
</div>

		
		

		
<script type="text/javascript">
function kontrol()
{
	return date_check(document.search_form.start_date,document.search_form.finish_date,"<cf_get_lang dictionary_id ='36063.Biti?? Tarihi Ba??lang???? Tarihinden K??????k'> !");
}
</script>
