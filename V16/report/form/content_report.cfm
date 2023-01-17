<cfparam name="attributes.search_type" default="0">
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
  <tr>
  	<td class="headbold" height="35"><cf_get_lang dictionary_id='39595.İçerik Raporlama'></td>
  </tr>
  <tr class="color-border">
    <td>
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
		<tr class="color-row">
		<td valign="top">
			<table>
				<cfform name="form" action="#request.self#?fuseaction=report.content_report" method="post">
				<input type="hidden" name="is_submit" id="is_submit" value="1">
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='56649.Çalışan Seç'></td>
					<td>
						<input type="hidden" name="employee_id" id="employee_id" style="width:150px;" value="<cfif isDefined('attributes.employee_id')><cfoutput>#attributes.employee_id#</cfoutput></cfif>" >
						<input type="text" name="employee" id="employee" style="width:150px;" value="<cfif isDefined('attributes.employee')><cfoutput>#attributes.employee#</cfoutput></cfif>" >
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form.employee_id&field_name=form.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.form.employee.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='40133.İçerik Seç'></td>
					<td><input type="hidden" name="content_id" id="content_id" style="width:150px;" value="<cfif isDefined('attributes.content_id')><cfoutput>#attributes.content_id#</cfoutput></cfif>" >
						<input type="text" name="content_head" id="content_head" style="width:150px;" value="<cfif isDefined('attributes.content_head')><cfoutput>#attributes.content_head#</cfoutput></cfif>" >
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_content_relation&content=form.content_id&content_name=form.content_head&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.form.content_head.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
				</tr>
				<tr>
					<td class="txtbold"><cf_get_lang dictionary_id='56859.Detaylı Dök'></td>
					<td>
					<input type="checkbox" name="detayli_dok" id="detayli_dok" value="1" <cfoutput><cfif isDefined('attributes.detayli_dok')>checked</cfif></cfoutput>>
					<cf_wrk_search_button button_type='1'>
					</td>
				</tr>
				</cfform>
			  </table>
			</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<cfif isdefined("attributes.is_submit")>
	<cfquery name="get_read_list" datasource="#dsn#">
	SELECT 
		DISTINCT
			<cfif not isdefined("attributes.detayli_dok")>
				MAX(READ_DATE) AS MAX_READ,
				COUNT(C.CONTENT_ID) AS KAC_KEZ,
			<cfelse>
				CF.READ_DATE,
			</cfif>
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			CCH.CHAPTER,
			CC.CONTENTCAT,
			C.CONTENT_ID,
			C.CONT_HEAD
			
		FROM
			CONTENT_FOLLOWS CF,
			CONTENT C,
			EMPLOYEES E,
			CONTENT_CHAPTER CCH,
			CONTENT_CAT CC
			
		WHERE
			E.EMPLOYEE_ID = CF.EMPLOYEE_ID AND
			<cfif len(attributes.employee_id) and len(attributes.employee)>
				E.EMPLOYEE_ID = #attributes.employee_id# AND
			</cfif>
			<cfif len(attributes.content_id) and len(attributes.content_head)>
				C.CONTENT_ID = #attributes.content_id# AND
			</cfif>
			C.CHAPTER_ID = CCH.CHAPTER_ID AND
			CF.CONTENT_ID = C.CONTENT_ID AND
			CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID
		<cfif not isdefined("attributes.detayli_dok")>
		GROUP BY 
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			CCH.CHAPTER,
			CC.CONTENTCAT,
			C.CONTENT_ID,			
			C.CONT_HEAD
		</cfif>
		ORDER BY
			<cfif not isdefined("attributes.detayli_dok")>C.CONT_HEAD,E.EMPLOYEE_NAME<cfelse>READ_DATE DESC</cfif>		
	</cfquery>
	
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfparam name="attributes.totalrecords" default=#get_read_list.recordcount#>
	
	<cfset url_str = 'report.content_report&employee_id=#attributes.employee_id#&employee=#attributes.employee#&search_type=#attributes.search_type#'>
	<cfif isDefined('attributes.content_id')>
		<cfset url_str = url_str&'&content_id=#attributes.content_id#&content_head=#attributes.content_head#'>
	</cfif>
	<cfif isDefined('attributes.crid') and len(attributes.crid)>
		<cfset url_str = url_str&'&crid='&attributes.crid>
	</cfif>
	
	<cfif isDefined('attributes.detayli_dok')>
		<cfset url_str = url_str&'&detayli_dok=1'>
	</cfif>
	
	<table cellpadding="2" width="98%" cellspacing="1"  border="0" align="center" class="color-border">
		<tr class="color-header" height="22">
			<td class="form-title"><cf_get_lang dictionary_id='57480.Konu'></td>
			<td class="form-title" width="150"><cf_get_lang dictionary_id='47783.Okuyucu'></td>
			<td class="form-title" width="100"><cf_get_lang dictionary_id='57486.Kategori'></td>
			<td class="form-title" width="100"><cf_get_lang dictionary_id='57995.Bölüm'></td>
			<td class="form-title" width="85"><cf_get_lang dictionary_id='40135.Okuma T.'></td>
			<cfif not isdefined("attributes.detayli_dok")><td class="form-title" width="50"><cf_get_lang dictionary_id='50661.Okuma'></td></cfif>
		</tr>
		<cfif get_read_list.recordcount>
			<cfoutput query="get_read_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
					<td height="20"><a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#CONTENT_ID#" class="tableyazi">#CONT_HEAD#</a></td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>#CONTENTCAT#</td>
					<td>#CHAPTER#</td>					
					<td>
					<cfif not isdefined("attributes.detayli_dok")>
						<cfset D_DATE=date_add('h',session.ep.time_zone,MAX_READ)>
						#dateformat(D_DATE,'dd/mm/yy')# #timeformat(D_DATE,timeformat_style)#
					<cfelse>
						<cfset D_DATE=date_add('h',session.ep.time_zone,READ_DATE)>
						#dateformat(D_DATE,'dd/mm/yy')# #timeformat(D_DATE,timeformat_style)#
					</cfif>
					</td>
					<cfif not isdefined("attributes.detayli_dok")><td>#KAC_KEZ#</td></cfif>
				</tr>
			</cfoutput>
		<cfelse>
			<tr height="20" class="color-row">
				<td colspan="<cfif not isdefined("attributes.detayli_dok")>6<cfelse>5</cfif>"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</table>
	<cfif attributes.maxrows lt attributes.totalrecords>
	  <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%" height="35">
		<tr>
		  <td>
			<cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="#url_str#&is_submit=1"></td>
		  <!-- sil --><td align="right" style="text-align:right;"> 
		  <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#</cfoutput>&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:<cfoutput>#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	  </table>
	</cfif>
</cfif>
