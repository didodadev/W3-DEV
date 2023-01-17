<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.action_type_id" default="0">
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = wrk_get_today()>
</cfif>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = dateadd('d',-45,wrk_get_today())>
</cfif>
<!--- <cfif isdefined("attributes.is_form_submitted")>
   <cfinvoke component="V16.finance.cfc.genel_virman" method="get_genel_virman" action_type_id="#attributes.action_type_id#" keyword="#attributes.keyword#" start_date="#attributes.start_date#" finish_date="#attributes.finish_date#" returnvariable="get_genelvirman">
<cfelse>
  <cfset get_genelvirman.recordcount = 0>
</cfif> --->
<cfif isDefined('attributes.is_form_submitted')>
    <cfset gv = createObject("component","V16.finance.cfc.genel_virman")/>
    <cfset get_genelvirman= gv.get_genel_virman(action_type_id:attributes.action_type_id,keyword:attributes.keyword,start_date:attributes.start_date,finish_date:attributes.finish_date)/>
<cfelse>
  <cfset get_genelvirman.recordcount = 0>	
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_genelvirman.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="header"><cf_get_lang dictionary_id="60101.5 Boyutlu İşlem"></cfsavecontent>
<div class="col col-12">
	<cf_box >
		<cfform id="metal" method="post" name="order_form" action="#request.self#?fuseaction=finance.list_genel_virman">
			<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-action_type_id">
					<select name="action_type_id" id="action_type_id">
						<option value="0" <cfif attributes.action_type_id eq 0>selected</cfif>><cf_get_lang dictionary_id="57734.Seçiniz"></option>
						<option value=""  <cfif attributes.action_type_id eq "">selected</cfif>><cf_get_lang dictionary_id="58930.Masraf"></option>
						<option value="1" <cfif attributes.action_type_id eq 1>selected</cfif>><cf_get_lang dictionary_id="57521.Banka"></option>
						<option value="2" <cfif attributes.action_type_id eq 2>selected</cfif>><cf_get_lang dictionary_id="57520.Kasa"></option>
						<option value="3" <cfif attributes.action_type_id eq 3>selected</cfif>><cf_get_lang dictionary_id="58061.Cari"></option>
						<option value="4" <cfif attributes.action_type_id eq 4>selected</cfif>><cf_get_lang dictionary_id="57447.Muhasebe"></option>
					</select>
				</div> 
				<div class="form-group" id="item-date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz !'></cfsavecontent>
						<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" required="Yes" message="#message#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz !'></cfsavecontent>
						<cfinput type="text" name="finish_date" id = "finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" required="Yes" message="#message#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_genel_virman&event=add"><i class="fa fa-plus"></i></a>
				</div>
			</cf_box_search>					
		</cfform>
	</cf_box>
	<cf_box title="#header#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th style="width:20px;"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58616.Belge Numarası'></th>
					<th><cf_get_lang dictionary_id='39422.Belge Tarihi'></th>
					<th><cf_get_lang dictionary_id='35573.Tahsil Eden'></th>
					<th><cf_get_lang dictionary_id='43121.Kayıt Eden'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<!-- sil --><th style="width:20px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_genel_virman&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='61052.Genel Virman Ekle'>" alt="<cf_get_lang dictionary_id='61052.Genel Virman Ekle'>" border="0" align="absmiddle"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_genelvirman.recordcount>
					<cfoutput query="get_genelvirman" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td>#currentrow#</td>
							<td>#virman_no#</td>
							<td>#dateformat(virman_date,'dd/mm/yyyy')#</td>
							<td>#employee_name# #employee_surname#</td>
							<td>#record_emp_name# #record_emp_surname#</td>
							<td>#virman_detail#</td>
							<!-- sil --><td><a href="#request.self#?fuseaction=finance.list_genel_virman&event=upd&virman_id=#virman_id#&action_type_id=#attributes.action_type_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='49025.Virman'> <cf_get_lang dictionary_id='57464.Güncelleme'>" border="0" align="absmiddle"></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres = "finance.list_genel_virman&keyword=#attributes.keyword#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#adres#&is_form_submitted=1">
	</cf_box>
</div>
<!-- sil -->
<script language="javascript">
	document.order_form.keyword.focus();
</script>
<!-- sil -->
