<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfparam name="attributes.branch_id" default="">
<cfif isdefined("attributes.start_dates") and isdate(attributes.start_dates)>
	<cf_date tarih = "attributes.start_dates">
</cfif>
<cfif isdefined("attributes.finish_dates") and isdate(attributes.finish_dates)>
	<cf_date tarih = "attributes.finish_dates">
</cfif>
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_shifts.cfm"> 
<cfelse>
	<cfset get_shifts.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_shifts.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="shits_search" method="post" action="#request.self#?fuseaction=ehesap.shift">
			<input type="hidden" name="is_submit" id="is_submit" value="1"/>
			<input type="hidden" name="is_filter" id="is_filter" value="1"/>
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" maxlength="50" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput name="start_dates" validate="#validate_style#" placeholder="#getLang('','Başlangıç Tarihi',58053)#" maxlength="10" value="#dateformat(attributes.start_dates,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span>
					</div>
				</div>	
				<div class="form-group">
					<div class="input-group">
						<cfinput name="finish_dates" validate="#validate_style#" placeholder="#getLang('','Bitiş Tarihi',57700)#" maxlength="10" value="#dateformat(attributes.finish_dates,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates"></span>
					</div>
				</div>		
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function="date_check(shits_search.start_dates,shits_search.finish_dates,'#getLang('','Tarih Değerini Kontrol Ediniz',57782)#!')" button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Vardiya Tanımları',63621)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='53063.Vardiya'></th>
					<th><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></th>
					<th><cf_get_lang dictionary_id ='58467.Başlama'></th>
					<th><cf_get_lang dictionary_id ='57502.Bitiş'></th>
					<th><cf_get_lang dictionary_id ='57609.Cumartesi'></th>
					<!-- sil -->
					<th class="header_icn_none text-center" width="20">
						<a href="<cfoutput>#request.self#?fuseaction=ehesap.shift&event=add&shift_id</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='53068.Vardiya Ekle'>"/></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_shifts.recordcount>
				<cfscript>
					function sifirEkle(zamanDegeri)
					{
						if (Len(zamanDegeri) == 1)
						return "0" & zamanDegeri;
						else
						return zamanDegeri;
					}
				</cfscript>
				<cfoutput query="get_shifts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset BRANCHID = BRANCH_ID>
						<tr> 
							<td>#currentrow#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.shift&event=upd&shift_id=#shift_id#','wide')">#shift_name#</a></td>
							<td>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
							<td>#sifirEkle(start_hour)#:#sifirEkle(start_min)#</td> 
							<td>#sifirEkle(end_hour)#:#sifirEkle(END_MIN)#</td>
							<td><cfif std_start_hour neq 0>#sifirEkle(std_start_hour)#:#sifirEkle(std_start_min)#</cfif> - <cfif std_end_hour neq 0>#sifirEkle(std_end_hour)#:#sifirEkle(std_end_min)#</cfif></td>
							<!-- sil -->
								<td><a href="#request.self#?fuseaction=ehesap.shift&event=upd&shift_id=#shift_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>" /></i></a></td>
							<!-- sil -->
						</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>        	
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif isdefined("attributes.is_submit")>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.start_dates)>
				<cfset url_str="#url_str#&start_dates=#dateformat(attributes.start_dates,dateformat_style)#">
			</cfif>
			<cfif len(attributes.finish_dates)>
				<cfset url_str="#url_str#&finish_dates=#dateformat(attributes.finish_dates,dateformat_style)#">
			</cfif>
			<cfif len(attributes.is_submit)>
				<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
			</cfif>          
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="ehesap.shift#url_str#">
		</cfif>
	</cf_box>
</div>
<!---Bu kısım şube ve departmana göre çalışacağı zaman açılcak olan yukardaki bloğun js'leri.Silmeyiniz.M.ER 20071121  --->
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function get_departments(branch_id)
	{
		var get_dep = wrk_safe_query('hr_get_dep','dsn',0,branch_id)
		document.shits_search.department_id.options.length=0;
		document.shits_search.department_id.options[0] = new Option('Departman','');
		if (get_dep.recordcount)
		{
			for(var jj=0;jj<get_dep.recordcount;jj++)
			document.shits_search.department_id.options[jj+1] = new Option(get_dep.DEPARTMENT_HEAD[jj],get_dep.DEPARTMENT_ID[jj]);
		}
	}
</script>
<!---  --->
