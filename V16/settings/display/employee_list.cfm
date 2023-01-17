<cfquery name="get_emp" datasource="#dsn#">
	SELECT 
		POSITION_CODE,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		SETUP_POSITION_CAT.POSITION_CAT_ID,
		POSITION_NAME,
		POSITION_CAT,
		EMPLOYEE_POSITIONS.USER_GROUP_ID
	FROM 
		EMPLOYEE_POSITIONS,
		SETUP_POSITION_CAT
		WHERE
		SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
		</cfif> 
	ORDER BY 
		EMPLOYEE_NAME
</cfquery>
<cfparam name="attributes.modal_id" default="">

<script type="text/javascript">
  function add_faction(pos_code,e_name,pos_cat,user_group)
  {
    <cfif isdefined("attributes.field_pos_code")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_pos_code#</cfoutput>.value=pos_code;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value=e_name;
	</cfif>
	<cfif isdefined("attributes.field_pos_cat")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_pos_cat#</cfoutput>.value=pos_cat;
	</cfif>
	<cfif isdefined("attributes.field_user_group")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_user_group#</cfoutput>.value=user_group;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
  }
</script>

<cfset adres = "settings.popup_emp_list">
 <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
 </cfif>
 <cfif isDefined("attributes.field_pos_code") and len(attributes.field_pos_code)>
	<cfset adres = "#adres#&field_pos_code=#attributes.field_pos_code#">
 </cfif>
 
 <cfif isDefined("attributes.field_name") and len(attributes.field_name)>
	<cfset adres = "#adres#&field_name=#attributes.field_name#">
 </cfif>

<cfif isDefined("attributes.field_pos_cat") and len(attributes.field_pos_cat)>
	<cfset adres = "#adres#&field_pos_cat=#attributes.field_pos_cat#">
 </cfif>
 
 <cfif isDefined("attributes.field_user_group") and len(attributes.field_user_group)>
	<cfset adres = "#adres#&field_user_group=#attributes.field_user_group#">
 </cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_emp.recordcount#>
<cfparam name="attributes.keyword" default = "" >
<cfparam name="attributes.page" default=1>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
	<cfset attributes.maxrows = session.ep.maxrows>
  </cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Çalışanlar','30370')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form1" method="post" action="#request.self#?fuseaction=settings.popup_emp_list">
			<cf_box_search more="0">
				<input type="hidden" name="field_pos_code" id="field_pos_code" value="<cfoutput>#attributes.field_pos_code#</cfoutput>"> 
				<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"> 
				<cfif isdefined("attributes.field_pos_cat") and isdefined("attributes.field_user_group")>
					<input type="hidden" name="field_pos_cat" id="field_pos_cat" value="<cfoutput>#attributes.field_pos_cat#</cfoutput>">
					<input type="hidden" name="field_user_group" id="field_user_group" value="<cfoutput>#attributes.field_user_group#</cfoutput>">
				</cfif>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayı Hatası Mesaj','34135')#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4"  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form1' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_grid_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th><cf_get_lang dictionary_id='63573.Pozisyon Kategorisi'></th>
						<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="get_emp" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr class="color-row">	
							<td height="20"><a href="##" onClick="add_faction('#position_code#','#employee_name# #employee_surname#','#position_cat_id#','#user_group_id#');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td>#position_cat#</td> 
							<td>#position_name#</td>
						</tr>
						<cfif not get_emp.recordcount>
							<tr class="color-row">
								<td colspan="3"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
							</tr>
						</cfif>
					</cfoutput>
				</tbody>
			</cf_grid_list>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
					<tr> 
						<td>
							<cf_pages page="#attributes.page#"
								maxrows="#attributes.maxrows#"
								totalrecords="#attributes.totalrecords#"
								startrow="#attributes.startrow#"
								adres="#adres#">	
						</td>
						  <!-- sil --><td colspan="2" align="right" style="text-align:right;"> <cf_get_lang dictionary_id='55072.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
					</tr>
				</table>
			</cfif>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

