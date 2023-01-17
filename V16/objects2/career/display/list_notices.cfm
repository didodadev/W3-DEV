<!--- İlan Liste --->
<cfparam name="attributes.keyword" default="">

<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
<cfset get_notices = get_components.get_notices(keyword : attributes.keyword)>

<cfset temp_colspan =3>
<cfparam name="attributes.page" default=1>
<cfif isdefined('session.pp.userid')>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelseif isdefined('session.ww')>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.cp.maxrows#'>
</cfif>

<cfparam name="attributes.totalrecords" default=#get_notices.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined('attributes.is_icon') and attributes.is_icon eq 1> 
	<cfinclude template="list_notices1.cfm">
<cfelse>
	<!-- sil -->
	<cfform name="search" method="post" action="#request.self#">
		<div class="form-group row">
			<label class="col-md-1 col-form-label"><cf_get_lang dictionary_id='57460.Filtre'></label>
			<div class="col-12 col-md-3 col-lg-3 col-xl-2 py-1">
				<cfinput type="text" class="form-control" name="keyword" id="keyword" value="#attributes.keyword#">
			</div>
			<div class="col-12 col-md-3 col-lg-3 col-xl-1 py-1">
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" class="form-control" name="maxrows" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
			</div>
			<div class="col-12 col-md-3 col-lg-3 col-xl-1 py-1"><cf_wrk_search_button></div>
		</div>	
	</cfform>
	<!-- sil -->
	<div class="table-responsive">
	<table class="table">
		<tr class="main-bg-color"> 
			<td class="font-weight-bold"><cf_get_lang dictionary_id='57487.No'></td>
			<td class="font-weight-bold"><cf_get_lang dictionary_id='31477.İlan Başlığı'></td>
			<cfif isdefined("attributes.is_positions") and attributes.is_positions eq 1>
				<cfset temp_colspan = temp_colspan+1>
				<td class="font-weight-bold"><cf_get_lang dictionary_id='58497.Pozisyon'></td>
			</cfif>
			<cfif isdefined("attributes.is_companies") and attributes.is_companies eq 1>
				<cfset temp_colspan = temp_colspan+1>
				<td class="font-weight-bold"><cf_get_lang dictionary_id='57574.Şirket'></td>
			</cfif>
			<cfif isdefined("attributes.is_city") and attributes.is_city eq 1>
				<cfset temp_colspan = temp_colspan+1>
				<td class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'></td>
			</cfif>
		</tr>
	
		<cfif get_notices.recordcount>
			<cfoutput query="get_notices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td><a href="/#attributes.update_path_url#?notice_id=#notice_id#" class="tableyazi">#notice_no#</a></td>
                    <td><a href="/#attributes.update_path_url#?notice_id=#notice_id#" class="tableyazi">#notice_head#</a></td>
                    <cfif isdefined("attributes.is_positions") and attributes.is_positions eq 1>
                        <td>#position_name#</td>
                    </cfif>
                    <cfif isdefined("attributes.is_companies") and attributes.is_companies eq 1>
                        <cfif len(get_notices.department_id) and len(get_notices.branch_id) and len(get_notices.our_company_id)>
							<cfset GET_BRANCHS = get_components.GET_BRANCHS(
								our_company_id : get_notices.our_company_id,
								branch_id : get_notices.branch_id,
								department_id : get_notices.department_id
							)>
                        </cfif>
                        <td>
                        <cfif len(get_notices.company_id) and get_notices.is_view_company_name eq 1>#get_par_info(get_notices.company_id,1,0,0)#<cfelseif len(get_notices.department_id) and len(get_notices.branch_id) and len(get_notices.our_company_id) and get_notices.is_view_company_name eq 1>#get_branchs.nick_name#</cfif>&nbsp;</td>
                    </cfif>
                    <cfif isdefined("attributes.is_city") and attributes.is_city eq 1>
                        <td>
                            <cfif listlen(get_notices.notice_city) and listfind(get_notices.notice_city,0,',')>
                                <cf_get_lang no='786.Tüm Türkiye'>
                            <cfelseif listlen(get_notices.notice_city)>
                                <cfset row_count = 0>
                                <cfloop list="#get_notices.notice_city#" index="i">
                                    <cfset row_count = row_count + 1>
                                    <cfquery name="GET_CITY" datasource="#DSN#">
                                        SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"> 
                                    </cfquery>
                                    #get_city.city_name#<cfif row_count lt listlen(get_notices.notice_city,',')>, </cfif>
                                </cfloop>
                            </cfif>
                        </td>
                    </cfif>
                </tr>
            </cfoutput>
        <cfelse>
            <tr class="color-row">
                <td colspan="<cfoutput>#temp_colspan#</cfoutput>"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
	</table>
	</div>	
	<cfif attributes.totalrecords gt attributes.maxrows>
		<table cellpadding="0" cellspacing="0" align="center" height="35" style="width:100%; height:35px;">
			<tr>
				<td>
					<cfset adres="">
					<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
						<cfset adres="#adres#&keyword=#attributes.keyword#">
					</cfif>
					<cf_pages page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="#attributes.fuseaction#&#adres#">
				</td>
				<!-- sil -->
				<td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='55072.Toplam Kayıt'> : #get_notices.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
			</tr>
		</table>
	</cfif>
</cfif>
