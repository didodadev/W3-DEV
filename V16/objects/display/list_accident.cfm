<!--- <cfoutput>ARİF</cfoutput> --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfparam name="attributes.modal_id" default="">
<cfset url_str = "">
<cfif isdefined("attributes.field_accident_id")>
	<cfset url_str = "#url_str#&field_accident_id=#attributes.field_accident_id#">
</cfif>
<cfif isdefined("attributes.field_accident_name")>
	<cfset url_str = "#url_str#&field_accident_name=#attributes.field_accident_name#">
</cfif>
<cfif isdefined("attributes.field_assetp_id")>
	<cfset url_str = "#url_str#&field_assetp_id=#attributes.field_assetp_id#">
</cfif>
<cfif isdefined("attributes.field_assetp_name")>
	<cfset url_str = "#url_str#&field_assetp_name=#attributes.field_assetp_name#">
</cfif>
<cfif isdefined("attributes.field_employee_id")>
	<cfset url_str = "#url_str#&field_employee_id=#attributes.field_employee_id#">
</cfif>
<cfif isdefined("attributes.field_employee_name")>
	<cfset url_str = "#url_str#&field_employee_name=#attributes.field_employee_name#">
</cfif>
<cfif isdefined("attributes.field_dep_id")>
	<cfset url_str = "#url_str#&field_dep_id=#attributes.field_dep_id#">
</cfif>
<cfif isdefined("attributes.field_dep_name")>
	<cfset url_str = "#url_str#&field_dep_name=#attributes.field_dep_name#">
</cfif>
<cfif isdefined("attributes.field_date")>
	<cfset url_str = "#url_str#&field_date=#attributes.field_date#">
</cfif>
<cfquery name="GET_ACCIDENT" datasource="#dsn#">
	SELECT
		ASSET_P.ASSETP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		ASSET_P_ACCIDENT.ACCIDENT_ID,
		ASSET_P_ACCIDENT.EMPLOYEE_ID,
		ASSET_P_ACCIDENT.DEPARTMENT_ID,
		ASSET_P_ACCIDENT.ACCIDENT_DATE,
		ASSET_P_ACCIDENT.ASSETP_ID,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM
		ASSET_P_ACCIDENT,
		ASSET_P,
		EMPLOYEES,
		BRANCH,
		DEPARTMENT
	WHERE
		ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID AND
		EMPLOYEES.EMPLOYEE_ID = ASSET_P_ACCIDENT.EMPLOYEE_ID AND
		ASSET_P_ACCIDENT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		<cfif len(attributes.keyword)>
			AND (ASSET_P.ASSETP LIKE '%#attributes.keyword#%' OR
			EMPLOYEES.EMPLOYEE_NAME  LIKE '%#attributes.keyword#%' OR
			EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%')
		</cfif>
	ORDER BY
		ASSET_P_ACCIDENT.ACCIDENT_DATE
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_accident.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','Kazalar',57778)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<!--- search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_par' , #attributes.modal_id#)"),DE(""))#" --->
	<cfform name="search_accident" method="post" action="#request.self#?fuseaction=objects.popup_list_accident&#url_str#">
	
	<cf_box_search>
		<div class="form-group" id="item-keyword">
			<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" >
		</div>

		<div class="form-group small">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" tabindex="3" name="maxrows" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" >
		</div>
		<div class="form-group">
			<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_accident' , #attributes.modal_id#)"),DE(""))#">
		</div>
</cf_box_search>
</cfform>
<cf_grid_list>
	<thead>
        <tr height="22" class="color-header">
          <td class="form-title"><cf_get_lang dictionary_id='58480.Araç'></td>
          <td class="form-title"><cf_get_lang dictionary_id='33475.Şöför'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></td>
        </tr>
	</thead>
	<tbody>
        <cfif get_accident.recordcount>
		<cfoutput query="get_accident" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
          <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td><a href="javascript://" onClick="send('#accident_id#','#assetp# - #dateformat(accident_date,dateformat_style)# tarihli kaza kaydı','#assetp_id#','#assetp#','#employee_id#','#employee_name# #employee_surname#','#department_id#','#branch_name# - #department_head#','#dateformat(accident_date,dateformat_style)#');">#assetp#</a></td>
            <td>#employee_name# #employee_surname#</td>
            <td>#dateformat(accident_date,dateformat_style)#</td>
          </tr>
        </cfoutput>
		<cfelse>
			<tr>
			  <td colspan="3" class="color-row"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>

			<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
						
							<tr>
							<td><cf_pages page="#attributes.page#"
										maxrows="#attributes.maxrows#"
										totalrecords="#attributes.totalrecords#"
										startrow="#attributes.startrow#"
										adres="objects.popup_list_accident&#url_str#"
										isAjax="#iif(isdefined("attributes.draggable"),1,0)#"></td>
							<!-- sil -->
							<td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
							<!-- sil -->
							</tr>
						</tbody>
			</cfif>
</cf_grid_list>
</cf_box>

<script type="text/javascript">
function send(accident_id,accident_name,assetp_id,assetp_name,employee_id,employee_name,dep_id,dep_name,accident_date)
{
	<cfif isdefined("attributes.field_accident_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_accident_id#</cfoutput>.value = accident_id;
	</cfif>
	<cfif isdefined("attributes.field_accident_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_accident_name#</cfoutput>.value = accident_name;
	</cfif>
	<cfif isdefined("attributes.field_assetp_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_assetp_id#</cfoutput>.value = assetp_id;
	</cfif>
	<cfif isdefined("attributes.field_assetp_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_assetp_name#</cfoutput>.value = assetp_name;
	</cfif>
	<cfif isdefined("attributes.field_employee_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_employee_id#</cfoutput>.value = employee_id;
	</cfif>
	<cfif isdefined("attributes.field_employee_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_employee_name#</cfoutput>.value = employee_name;
	</cfif>
	<cfif isdefined("attributes.field_dep_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_dep_id#</cfoutput>.value = dep_id;
	</cfif>
	<cfif isdefined("attributes.field_dep_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_dep_name#</cfoutput>.value = dep_name;
	</cfif>
	<cfif isdefined("attributes.field_date")>
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_date#</cfoutput>.value = accident_date;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>

}
</script>
