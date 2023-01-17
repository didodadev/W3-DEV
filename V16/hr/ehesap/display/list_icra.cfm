<cfinclude template="calc_icra.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.form_submitted" default="1">
<cfif len(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
</cfif>

<cfif len(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
</cfif>

<cfquery name="get_docs" datasource="#DSN#">
	SELECT
		EP.*,
		E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KAYIT_EDEN,
		(SELECT E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME FROM EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = EP.EMPLOYEE_ID) AS ILGILI
	FROM
		COMMANDMENT EP,
		EMPLOYEES E
	WHERE
		EP.RECORD_EMP = E.EMPLOYEE_ID
		<cfif len(attributes.keyword)>
			AND 
				(
				EP.SERIAL_NO + EP.SERIAL_NUMBER LIKE '%#attributes.keyword#%'
				OR
				'IC-' + CAST(EP.COMMANDMENT_ID AS NVARCHAR) LIKE '%#attributes.keyword#%'
				)
		</cfif>

		<cfif len(attributes.startdate) and not len(attributes.finishdate)>
			AND EP.COMMANDMENT_DATE >= #attributes.startdate#
		</cfif>
		<cfif len(attributes.finishdate) and not len(attributes.startdate)>
			AND EP.COMMANDMENT_DATE <= #attributes.finishdate#
		</cfif>
		<cfif len(attributes.startdate) and len(attributes.finishdate)>
			AND 
				(
					(EP.COMMANDMENT_DATE >= #attributes.startdate# AND EP.COMMANDMENT_DATE <= #attributes.finishdate#)
				)
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			AND EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
	ORDER BY
		EP.RECORD_DATE DESC
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_docs.recordcount#'>
<cfform name="arama_form" method="post" action="#request.self#?fuseaction=ehesap.list_icra">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_big_list_search title="İcra Kesintileri"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td><cf_get_lang dictionary_id="57460.Filtre"></td>
				<td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:60px;"></td>
				<!--Talep Eden 12102015-->
				<td><cf_get_lang dictionary_id="53089.İlgili Kişi"></td>
                <td>
					<input type="hidden" name="employee_id" maxlength="50" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
					<input type="text" name="employee"  maxlength="50" id="employee" style="width:125px;"  onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','search_asset','3','135')" value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" autocomplete="off">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=arama_form.employee&field_emp_id=arama_form.employee_id&select_list=1,9','list');return false"><img src="/images/plus_thin.gif"></a>
				</td>
				<!--Talep Eden 12102015-->
				<td>
					
				<td><cf_get_lang dictionary_id="57699.Baş.Tarihi">
					<cfsavecontent variable="message"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
					<cfinput value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" type="text" name="startdate" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
					<cf_wrk_date_image date_field="startdate">
				</td>
				<td><cf_get_lang dictionary_id="57700.Bitiş Tarihi">
					<cfsavecontent variable="message"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
					<cfinput value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" type="text" name="finishdate" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
					<cf_wrk_date_image date_field="finishdate">
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)"  required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="15"><cf_get_lang dictionary_id="58577.Sıra"></th>
			<th><cf_get_lang dictionary_id="57487.No"></th>
			<th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
			<th><cf_get_lang dictionary_id="53089.İlgili Kişi"></th>
			<th><cf_get_lang dictionary_id="59088.Tip"></th>
			<th><cf_get_lang dictionary_id="31746.İcra Tarihi"></th>
			<th><cf_get_lang dictionary_id="45515.İcra No"></th>
			<th><cf_get_lang dictionary_id="57673.Tutar"></th>
			<th><cf_get_lang dictionary_id="57899.Kaydeden"></th>
			<th width="35"><cf_get_lang dictionary_id="57691.Dosya"></th>
			<th><cf_get_lang dictionary_id="57756.Durum"></th>
			<!-- sil --><th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.add_icra"><img src="images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_docs.recordcount>
		<cfoutput query="get_docs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td width="15">#currentrow#</td>
				<td><a href="#request.self#?fuseaction=ehesap.upd_icra&COMMANDMENT_ID=#COMMANDMENT_ID#" class="tableyazi">IC-#COMMANDMENT_ID#</a></td>
				<td>#dateformat(record_date,'dd/mm/yyyy')# #timeformat(record_date,'HH:MM')#</td>
				<td>#ILGILI#</td>
				<td><cfif COMMANDMENT_TYPE eq 1><cf_get_lang dictionary_id="50363.İcra"><cfelse><cf_get_lang dictionary_id="45514.Nafaka"></cfif></td>
				<td>#dateformat(COMMANDMENT_DATE,'dd/mm/yyyy')#</td>
				<td>#serial_no# #serial_number#</td>
				<td style="text-align:right;">#tlformat(COMMANDMENT_VALUE)#</td>
				<td>#kayıt_eden#</td>
				<td>
					<cfif len(COMMANDMENT_FILE)>
					<a href="javascript://" onclick="windowopen('/documents/ehesap/#COMMANDMENT_FILE#','medium');"><center><img src="/images/file.gif"/></center></a>
					</cfif>
				</td>
				<td><cfif is_apply eq 1>Kabul<cfelseif is_refuse eq 1><cf_get_lang dictionary_id="29537.Red"><cfelse><cf_get_lang dictionary_id="31112.Bekliyor"></cfif></td>
				<!-- sil --><td class="header_icn_none"><a href="#request.self#?fuseaction=ehesap.upd_icra&COMMANDMENT_ID=#COMMANDMENT_ID#"><img src="images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></a></td><!-- sil -->
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
</tbody>
</cf_big_list>
<cfset url_str="ehesap.list_icra">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.startdate)>
	<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
</cfif>
<cfif len(attributes.finishdate)>
	<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
</cfif>

<cfif len(attributes.employee_id)>
	<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
</cfif>
<cfif len(attributes.employee)>
	<cfset url_str = "#url_str#&employee=#attributes.employee#">
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>