<!--- İlanlar Partner --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
<cfparam name="attributes.status_notice" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfset get_notices = get_components.GET_NOTICE(company_id: session.pp.company_id,
status_notice: attributes.status_notice,
keyword: attributes.keyword
)>

<cfparam name="attributes.totalrecords" default=#get_notices.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<cfform name="list_notice_" method="post" action="#request.self#" class="form-inline">
	<div class="form-group mb-2">
		<label class="sr-only"><cf_get_lang dictionary_id='57460.Filter'></label>
		<cfinput type="text" name="keyword" class="form-control" value="#attributes.keyword#">
	</div>
	<div class="form-group mx-sm-3 mb-2">
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Incorrect Record Number'></cfsavecontent>
			<select name="status_notice" id="status_notice" class="form-control">
			<option value=""><cf_get_lang_main no='344.Durum'></option>
			<option value="-1"<cfif attributes.status_notice eq -1>selected</cfif>><cf_get_lang dictionary_id='35100.Preparation'></option>
			<option value="-2"<cfif attributes.status_notice eq -2>selected</cfif>><cf_get_lang dictionary_id='29479.Publication'></option>
		</select>
	</div>
	<div class="form-group mb-2">
		<cfinput type="text" name="maxrows" style="width:50px;" class="form-control" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
	</div>
	<div class="form-group mx-sm-3 mb-2">
	<cf_wrk_search_button>
	</div>
</cfform>
  
  <!-- sil -->
<table cellpadding="1" cellspacing="1" width="100%" border="0">
	<tr class="color-header">
		<td width="40" height="22" class="form-title"><cf_get_lang_main no='75.No'></td>
		<td width="130" class="form-title"><cf_get_lang_main no='68.İlan Başlığı'></td>
		<td width="110" class="form-title"><cf_get_lang_main no='1085.Poziyon'></td>
		<td class="form-title"><cf_get_lang_main no='344.Durum'></td>
		<td width="110" class="form-title"><cf_get_lang_main no='162.Şirket'></td>
		<td class="form-title"><cf_get_lang_main no='559.Şehir'></td>
	</tr>
	<cfif get_notices.recordcount>
		<cfoutput query="get_notices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="50"><a href="/#attributes.update_path_url#?notice_id=#notice_id#" class="tableyazi">#NOTICE_NO#</a></td>
				<td width="150"><a href="/#attributes.update_path_url#?notice_id=#notice_id#" class="tableyazi">#notice_head#</a></td>
				<td>#POSITION_NAME#</td>
				<td><cfif get_notices.status_notice eq -1><cf_get_lang dictionary_id='35100.Preparation'><cfelse><cf_get_lang dictionary_id='29479.Publication'></cfif></td>
				<td>#get_notices.company#</td>
				<td><cfif listlen(get_notices.notice_city) and listfind(get_notices.notice_city,0,',')>
						<cf_get_lang dictionary_id='35107.All of Turkey'>
					<cfelseif listlen(get_notices.notice_city)>
					<cfset row_count = 0>
					<cfloop list="#get_notices.notice_city#" index="i">
					    <cfset row_count = row_count + 1>
						<cfquery name="GET_CITY" datasource="#dsn#">
							SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
						</cfquery>
						  #GET_CITY.city_name#<cfif row_count lt listlen(get_notices.notice_city,',')>, </cfif>
					 </cfloop>
					</cfif>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" height="20">
			<td colspan="6"><cf_get_lang dictionary_id='57484.No record'>!</td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
<table cellpadding="0" cellspacing="0" width="100%" align="center" height="35">
  <tr>
	<td>
	  <cfset adres="">
	  <cfif len(attributes.keyword)>
		<cfset adres="#adres#&keyword=#attributes.keyword#">
	  </cfif>
	<cf_pages page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#attributes.fuseaction#&#adres#"></td>
	<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main  no='128.Toplam Kayıt'> : #get_notices.recordcount#&nbsp;-&nbsp;<cf_get_lang_main  no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>

