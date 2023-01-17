<!--- İlan Başvuruları Partner --->
<!--- TODO: arayüzü düzenlenecek. --->
<cfset get_components = createObject("component", "V16.objects2.career.cfc.data_career_partner")>
<cfset GET_NOTICESS = get_components.GET_NOTICE(company_id : session.pp.company_id)>

<cfset url_str = "">
<cfif not isdefined("attributes.keyword")>
	<cfset filtered = 0>
<cfelse>
	<cfset filtered = 1>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.date_status" default="1">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.pp.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',8,attributes.start_date)>
</cfif>
<cfset url_str = "#url_str#&keyword=#attributes.keyword#&status=#attributes.status#&date_status=#attributes.date_status#">
<cfif isDefined("attributes.notice_head") and IsDefined("attributes.notice_id") and len(attributes.notice_head)>
   <cfset url_str = "#url_str#&notice_id=#attributes.notice_id#&notice_head=#attributes.notice_head#">
</cfif>

<cfset notice_list="">
<cfoutput query="get_noticess">
	<cfset notice_list=listappend(notice_list,notice_id,',')>
	<cfset notice_list=listappend(notice_list,notice_no,',')>
	<cfset notice_list=listappend(notice_list,notice_head,',')>
</cfoutput>
<cfif filtered>
	<cfset GET_APPS = get_components.GET_APPS(
		keyword : attributes.keyword,
		status : attributes.status,
		date_status : attributes.date_status,
		start_date : attributes.start_date,
		finish_date : attributes.finish_date
	)>
<cfelse>
	<cfset get_apps.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_apps.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellspacing="0" cellpadding="0" align="center" style="width:100%; height:35px;">
	<tr>
		<!-- sil -->
		<td style="vertical-align:bottom;">
			<cfform name="list_app" action="#request.self#" method="post">
			<table align="right">
				<tr>
                    <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                    <td>
                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></cfsavecontent>
                    	<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date, 'dd/mm/yyyy')#" style="width:67px;" validate="eurodate" maxlength="10" message="#message#" required="yes">
                    	<cf_wrk_date_image date_field="start_date">
                    </td>
                    <td>
                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                    	<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date, 'dd/mm/yyyy')#" style="width:67px;" validate="eurodate" maxlength="10" message="#message#" required="yes">
                    	<cf_wrk_date_image date_field="finish_date">
                    </td>
                    <td>
                        <select name="date_status" id="date_status">
                            <option value="1" <cfif attributes.date_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'>
                            <option value="2" <cfif attributes.date_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'>
                            <option value="3" <cfif attributes.date_status eq 3>selected</cfif>><cf_get_lang dictionary_id='35246.Azalan Kayıt No'>
                            <option value="4" <cfif attributes.date_status eq 4>selected</cfif>><cf_get_lang dictionary_id='35247.Artan Kayıt No'>
                            <option value="5" <cfif attributes.date_status eq 5>selected</cfif>><cf_get_lang dictionary_id='35248.Alfabetik Azalan'>
                            <option value="6" <cfif attributes.date_status eq 6>selected</cfif>><cf_get_lang dictionary_id='35249.Alfabetik Artan'>
                        </select>
                    </td>
                    <td>
                        <select name="status" id="status">
                            <option value="" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
                            <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                            <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>		                        
                        </select>
                    </td>
                    <td>
                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>	
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
				<!--- 	<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
				</tr>
			</table>
			</cfform>
		</td>
		<!-- sil -->
	</tr>
</table>
<table cellspacing="1" cellpadding="2" border="0" style="width:100%;">
	<tr class="color-header" style="height:22px;">
		<td class="form-title" style="width:65px;"><cf_get_lang dictionary_id='57487.No'></td>
        <td class="form-title" style="width:60px;"><cf_get_lang dictionary_id='57742.Tarih'></td>
        <td class="form-title"><cf_get_lang dictionary_id='57570.Ad Soyad'></td>
        <td class="form-title"><cf_get_lang dictionary_id='35242.İlanlar'></td>
        <td class="form-title" style="width:40px;"><cf_get_lang dictionary_id='57756.Durum'></td>
        <td style="width:20px;"></td>
	</tr>
	<cfif get_apps.recordcount>
		<cfoutput query="get_apps" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">	
			<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                <td><a href="/#attributes.application_detail_url#?empapp_id=#empapp_id#&app_pos_id=#app_pos_id#" class="tableyazi">#app_pos_id#</a></td>
                <td>#dateformat(app_date,'dd/mm/yyyy')#</td>
                <td>#name# #surname#</td>
                <td>
					<cfif len(notice_id)>
                    	<a href="/#attributes.update_path_url#?notice_id=#notice_id#" class="tableyazi">#ListGetAt(notice_list,ListFind(notice_list,notice_id,',')+1,',')#-#ListGetAt(notice_list,ListFind(notice_list,notice_id,',')+2,',')#</a>
                    </cfif>
				</td>
				<td><cfif app_pos_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
				<td align="center" style="width:20px;"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_print_files&iid=#app_pos_id#&print_type=171','print_page','workcube_print');" title="<cf_get_lang_main no='62.Yazdır'>"><img src="/images/print2.gif" alt="<cf_get_lang_main no='62.Yazdır'>" border="0" /></a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row" style="height:20px;">
			<cfif filtered>
            	<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            <cfelse>
            	<td colspan="11"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
            </cfif>
		</tr>
	</cfif>
</table>
<cfif attributes.maxrows lt attributes.totalrecords>
    <table align="center" cellpadding="0" cellspacing="0" style="width:98%;">
    	<tr>
    		<td>
				<cfif isdate(attributes.start_date)>
	                <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#" >
                </cfif>
                <cfif isdate(attributes.finish_date)>
    	            <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#" >
                </cfif>
                <cf_pages page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="hr.apps#url_str#">
    		</td>
    		<!-- sil -->
            <td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
            <!-- sil -->
    	</tr>
    </table>
</cfif>
<br/>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
