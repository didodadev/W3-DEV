<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfquery name="get_prize_type" datasource="#DSN#">
	SELECT 
	    PRIZE_TYPE_ID, 
        PRIZE_TYPE, 
        DETAIL
    FROM 
    	SETUP_PRIZE_TYPE
</cfquery>
<cfif isdefined('attributes.form_submit')>
	<cfinclude template="../query/get_prizes.cfm">
<cfelse>
	<cfset get_prize.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_PRIZE.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform action="#request.self#?fuseaction=ehesap.list_prizes" method="post" name="filter_list_prize">
			<input name="form_submit" id="form_submit" type="hidden" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" placeholder="#message#" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="PRIZE_TYPE" id="PRIZE_TYPE">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_prize_type">
							<option value="#PRIZE_TYPE_ID#" <cfif isDefined("attributes.PRIZE_TYPE") AND (attributes.PRIZE_TYPE EQ PRIZE_TYPE_ID)>SELECTED</cfif>>#PRIZE_TYPE#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input validate="<cfoutput>#validate_style#</cfoutput>" type="text" name="DATE" id="DATE" placeholder="<cfoutput><cf_get_lang dictionary_id='57742.Tarih'></cfoutput>" value="<cfif isDefined("attributes.DATE")><cfoutput>#dateformat(attributes.DATE,dateformat_style)#</cfoutput></cfif>" style="width:65px;"> 
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="DATE"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="53084.Ödüller"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>  
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='53122.Ödül'></th>
					<th><cf_get_lang dictionary_id='53506.Ödül Tipi'></th>
					<th><cf_get_lang dictionary_id='53123.Ödül Alan'></th>
					<th><cf_get_lang dictionary_id='53124.Ödül Veren'></th>
					<th><cf_get_lang dictionary_id='53125.Veriliş Tarihi'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'> </th>
                    <th><cf_get_lang dictionary_id='51231.Sicil No'></th>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center">
						<a href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.list_prizes&event=add</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif GET_PRIZE.recordcount>
					<cfset prize_id_list = ''>
					<cfset employee_id_list = ''>
					<cfoutput query="GET_PRIZE"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(PRIZE_TYPE_ID) and not listfind(prize_id_list,PRIZE_TYPE_ID)>
							<cfset prize_id_list=listappend(prize_id_list,PRIZE_TYPE_ID)>
						</cfif>
						<cfif len(PRIZE_GIVE_PERSON) and not listfind(employee_id_list,PRIZE_GIVE_PERSON)>
							<cfset employee_id_list=listappend(employee_id_list,PRIZE_GIVE_PERSON)>
						</cfif>
					</cfoutput>
					<cfif len(prize_id_list)>
						<cfset prize_id_list=listsort(prize_id_list,"numeric","ASC",",")>
						<cfquery name="get_type" dbtype="query">
							SELECT PRIZE_TYPE FROM get_prize_type WHERE PRIZE_TYPE_ID IN (#prize_id_list#) ORDER BY PRIZE_TYPE_ID
						</cfquery>
					</cfif>
					<cfif len(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="get_eployee_detail" datasource="#dsn#">
							SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfoutput query="GET_PRIZE"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td><a href="JAVASCRIPT://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_prizes&event=upd&prize_id=#prize_id#')" class="tableyazi">#prize_head#</a></td>
							<td><cfif len(PRIZE_TYPE_ID)>#get_type.PRIZE_TYPE[listfind(prize_id_list,PRIZE_TYPE_ID,',')]#</cfif>
							</td>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
							<td>
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#PRIZE_GIVE_PERSON#');" class="tableyazi">
								#get_eployee_detail.EMPLOYEE_NAME[listfind(employee_id_list,PRIZE_GIVE_PERSON,',')]#&nbsp;
								#get_eployee_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,PRIZE_GIVE_PERSON,',')]#
							</a> 
							</td>
							<td>#dateformat(PRIZE_DATE,dateformat_style)#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
                            <td>#employee_no#</td>
                            <td>#position_cat#</td>
                            <td>#position_name#</td>
							<!-- sil -->
							<td align="center"> 
								<a href="javascript://"onclick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_prizes&event=upd&prize_id=#prize_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> 
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="11"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.filtre ediniz'>!</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>   
		<cfif isdefined("attributes.PRIZE_TYPE") and len(attributes.PRIZE_TYPE)>
			<cfset url_str = "#url_str#&PRIZE_TYPE=#attributes.PRIZE_TYPE#">
		</cfif>
		<cfif isdefined("attributes.DATE") and len(attributes.DATE)>
			<cfset url_str = "#url_str#&DATE=#dateformat(attributes.DATE,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
			<cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
		</cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="ehesap.list_prizes#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
