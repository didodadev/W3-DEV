<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.field_assetp_id")>
	<cfset url_str = "#url_str#&field_assetp_id=#attributes.field_assetp_id#">
</cfif>
<cfif isdefined("attributes.field_assetp_name")>
	<cfset url_str = "#url_str#&field_assetp_name=#attributes.field_assetp_name#">
</cfif>
<cfif isdefined("attributes.list_select")>
	<cfset url_str = "#url_str#&list_select=#attributes.list_select#">
</cfif>
<cfif isdefined("attributes.field_assetp")>
	<cfset url_str = "#url_str#&field_assetp=#attributes.field_assetp#">
</cfif>

<cfif isdefined("attributes.field_request_row_id")>
	<cfset url_str = "#url_str#&field_request_row_id=#attributes.field_request_row_id#">
</cfif>
<cfif isdefined("attributes.field_request_id")>
	<cfset url_str = "#url_str#&field_request_id=#attributes.field_request_id#">
</cfif>
<!--- 0 satis, 3 degistirme --->
<cfquery name="GET_SALES_VEHICLE" datasource="#DSN#">
	SELECT
	DISTINCT
		ASSET_P.ASSETP_ID,
		ASSET_P.ASSETP,
		ASSET_P_REQUEST_ROWS.REQUEST_TYPE_ID,
		ASSET_P_REQUEST_ROWS.ASSETP_ID,
		ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID,
		ASSET_P_REQUEST_ROWS.REQUEST_ID,
		ASSET_P_REQUEST_ROWS.REQUEST_DATE,
		PROCESS_TYPE_ROWS.STAGE,
		ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
		BRANCH.BRANCH_NAME,
		ASSET_P.MAKE_YEAR,
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_NAME
	FROM
		BRANCH,
		DEPARTMENT,
		PROCESS_TYPE_ROWS,
		ASSET_P_REQUEST_ROWS,
		ASSET_P,
		SETUP_BRAND,
		SETUP_BRAND_TYPE,
		SETUP_BRAND_TYPE_CAT
	WHERE
		ASSET_P.ASSETP_ID = ASSET_P_REQUEST_ROWS.ASSETP_ID AND
		ASSET_P.DEPARTMENT_ID2 = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		(
			(ASSET_P_REQUEST_ROWS.REQUEST_TYPE_ID = 0 AND ASSET_P_REQUEST_ROWS.IS_SALES = 0) OR
			(ASSET_P_REQUEST_ROWS.REQUEST_TYPE_ID = 3 AND (ASSET_P_REQUEST_ROWS.IS_SALES = 0 OR ASSET_P_REQUEST_ROWS.IS_SALES IS NULL) AND ASSET_P.PROPERTY = 1) <!--- IS NULL kosulu daha sonra kaldırılabilir hale gelecek --->
		) 
		AND ASSET_P_REQUEST_ROWS.REQUEST_STATE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
		AND ASSET_P.BRAND_ID = SETUP_BRAND.BRAND_ID
		AND ASSET_P.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID
		AND ASSET_P.BRAND_TYPE_CAT_ID = SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID
		<cfif len(attributes.keyword)>
			AND ASSET_P.ASSETP LIKE '%#attributes.keyword#%'
		</cfif>
	ORDER BY
		ASSET_P_REQUEST_ROWS.REQUEST_ID,
		ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_sales_vehicle.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='33358.Satıştaki Araçlar'></cfsavecontent>
<cf_box title="#head#" scroll="0" collapsable="1" resize="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">			
          <cfform name="search_accident" method="post" action="#request.self#?fuseaction=objects.popup_list_sales_vehicles&#url_str#">
			<cf_box_search>
				<div class="form-group" id="keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#">
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_req' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search> 
          </cfform>


	<cf_grid_list>
		<thead>
        <tr height="22" class="color-header">
			<td class="form-title"><cf_get_lang dictionary_id='58480.Araç'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57453.Şube'></td>
			<td class="form-title"><cf_get_lang dictionary_id='58847.Marka'></td>
			<td class="form-title"><cf_get_lang dictionary_id='58225.Model'></td>
			<td class="form-title"><cf_get_lang dictionary_id='33360.Talep Eden'></td>
			<td class="form-title"><cf_get_lang dictionary_id='33361.Talep Tarihi'></td>
			<td class="form-title"><cf_get_lang dictionary_id='33363.Talep-Sıra No'></td>
			<td class="form-title"><cf_get_lang dictionary_id='33362.Talep Durumu'></td>
		</tr>
	</thead>
	<tbody>
        <cfif get_sales_vehicle.recordcount>
		<cfoutput query="get_sales_vehicle" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
          <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td><a href="javascript://" onClick="send('#assetp_id#','#assetp#','#request_row_id#','#request_id#');">#assetp#</a></td>
			<td nowrap>#branch_name#</td>			
			<td nowrap>#brand_name# #brand_type_name# #brand_type_cat_name#</td>
			<td>#make_year#</td>
			<td nowrap>#get_emp_info(employee_id,0,1)#</td>
			<td>#dateformat(request_date,dateformat_style)#</td>
        	<td>#request_id#-#request_row_id#</td>
			<td>#stage#</td>
		  </tr>
        </cfoutput>
		<cfelse>
			<tr>
			  <td colspan="8" class="color-row"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
			</tr>
		</cfif>
	</tbody>
	</cf_grid_list>

<cfif attributes.totalrecords gt attributes.maxrows>
  <cfif len(attributes.keyword)>
    <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
  </cfif>
  <table width="98%" border="0" cellpadding="0" cellspacing="0" height="35" align="center" >
    <tr>
      <td><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="objects.popup_list_sales_vehicles&#url_str#"></td>
      <!-- sil -->
      <td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
      <!-- sil -->
    </tr>
  </table>
</cfif>
</cf_box>

<script type="text/javascript">
	function send(assetp_id,assetp_name,request_row_id,request_id)
	{
		<cfif isdefined("attributes.field_assetp_id")>
			opener.document.<cfoutput>#attributes.field_assetp_id#</cfoutput>.value = assetp_id;
		</cfif>
		<cfif isdefined("attributes.field_assetp_name")>
			opener.document.<cfoutput>#attributes.field_assetp_name#</cfoutput>.value = assetp_name;
		</cfif>
		<cfif isdefined("attributes.field_request_row_id")>
			opener.document.<cfoutput>#attributes.field_request_row_id#</cfoutput>.value = request_row_id;
		</cfif>
		<cfif isdefined("attributes.field_request_id")>
			opener.document.<cfoutput>#attributes.field_request_id#</cfoutput>.value = request_id;
		</cfif>
		window.close();
	}
</script>
