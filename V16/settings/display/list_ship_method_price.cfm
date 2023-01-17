<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_SHIP_METHOD_PRICE" datasource="#DSN#">
		SELECT
			SMP.*,
			C.FULLNAME,
			EMP.EMPLOYEE_NAME,
			EMP.EMPLOYEE_SURNAME
		FROM
			SHIP_METHOD_PRICE SMP,
			COMPANY C,
			EMPLOYEES EMP
		WHERE
			SMP.COMPANY_ID = C.COMPANY_ID AND
			SMP.RECORD_EMP = EMP.EMPLOYEE_ID
		  <cfif len(attributes.company_id)>
			AND SMP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value=" #attributes.company_id#">
		  </cfif>
	</cfquery>
<cfelse>
	<cfset get_ship_method_price.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_ship_method_price.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box  >
<cfform name="list_ship_method_price" method="post" action="#request.self#?fuseaction=settings.list_ship_method_price">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_box_search more="0">

		<div class="row"> 
			<div class="col col-12 form-inline">
				<div class="form-group">
					<label><cf_get_lang_main no='107.Cari Hesap'></label>
				</div>
				<div class="form-group">
					<div class="input-group">
					   <input type="hidden" name="company_id"  id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company#</cfoutput></cfif>">
						 <input name="employee" type="text" id="company" >
					   <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_member_name=list_ship_method_price.company&field_comp_id=list_ship_method_price.company_id&select_list=2');return false"></span>
					</div>
				</div>
				 <div class="form-group">
					  <div class="input-group x-3_5">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		          <input type="text" name="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
						</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</div>
				
	    </div> 
    </div> 

</cf_box_search>
</cfform>
</cf_box>
<cf_box title="#getLang('','Sevk Fiyatları',43001)#"  hide_table_column="1" uidrop="1" >
<cf_grid_list>
	<thead>
		<tr>

			<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
			<th width="300"><cf_get_lang_main no='107.Cari Hesap'></th>
			<th width="200"><cf_get_lang_main no='487.Kaydeden '></th>
			<th><cf_get_lang_main no='215. Kayıt Tarihi'></th>
			<th><cf_get_lang dictionary_id='55055.Güncelleme Tarihi'></th>

			<th class="header_icn_none text-center" id="add_item">
				<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_ship_method_price')"><i class="fa fa-plus" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170. Ekle'>"></i></a>
				</th>

			
		</tr>
	</thead>
	<tbody>
		<cfif isdefined("attributes.form_submitted") and get_ship_method_price.recordcount>
		<cfoutput query="get_ship_method_price" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#currentrow#</td>
				<td>#fullname#</td>
				<td>#employee_name#&nbsp;#employee_surname#</td>
				<td>#dateformat(record_date,dateformat_style)#</td>
				<td>#dateformat(update_date,dateformat_style)#</td>
				<!-- sil -->
				<td class="header_icn_none text-center" id="upd_item">
				<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=settings.form_upd_ship_method_price&ship_method_price_id=#ship_method_price_id#')"><i class="fa fa-pencil" alt="<cf_get_lang_main no='52. Guncelle'>" title="<cf_get_lang_main no='52. Guncelle'>"></i></a>
					</td>
				<!-- sil -->

			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
     </tbody>
</cf_grid_list>

<cfset url_str = 'settings.list_ship_method_price'>
<cfif isdefined("attributes.form_submitted") and len (attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif len(attributes.company_id) and len(attributes.company)>
	<cfset url_str = "#url_str#&company=#attributes.company#">
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cf_paging 
	page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#url_str#"> 
</cf_box>
<script type="text/javascript">
	document.getElementById('company').focus();
</script>
