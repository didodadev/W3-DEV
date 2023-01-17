<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfif isdefined("attributes.is_submit")>
	<cfquery name="get_odenek" datasource="#dsn#">
	  SELECT 
		SO.*
	  FROM 
		SETUP_PAYMENT_INTERRUPTION SO
	  WHERE 
		SO.IS_ODENEK = 1 AND
        ISNULL(SO.IS_BES,0) = 0
		<cfif len(attributes.keyword)> 
			AND SO.COMMENT_PAY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		<cfif isDefined("attributes.status") and len(attributes.status)>
			AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_odenek.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_odenek.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform action="#request.self#?fuseaction=ehesap.list_odenek" method="post" name="filter_list_odenek">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="status" id="status">
						<option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
						<option value="1" <cfif isDefined("attributes.status") and (attributes.status eq 1)> selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
						<option value="0" <cfif isDefined("attributes.status") and (attributes.status eq 0)> selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Ek Ödenek Tanımları',45827)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58233.Tanım'></th>
					<th><cf_get_lang dictionary_id='53606.SSK Durumu'></th>
					<th><cf_get_lang dictionary_id ='54032.Net/Brüt'></th>
					<th><cf_get_lang dictionary_id='29472.Yöntem'></th>
					<th><cf_get_lang dictionary_id="53970.Tutar Günü"></th>
					<th><cf_get_lang dictionary_id='58714.SSK'></th>
					<th><cf_get_lang dictionary_id='53332.Vergi'></th>
					<th><cf_get_lang dictionary_id ='54121.Damga'></th>
					<th><cf_get_lang dictionary_id ='54120.İşsizlik'></th>
					<th><cf_get_lang dictionary_id='53132.Başlangıç Ay'></th>
					<th><cf_get_lang dictionary_id='53133.Bitiş Ay'></th>
					<th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="JAVASCRIPT://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.list_odenek&event=add</cfoutput>','','ui-draggable-box-large')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_odenek.recordcount>
					<cfoutput QUERY="get_odenek"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="35">#currentrow#</td>
							<td><a href="JAVASCRIPT://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_odenek&event=upd&odkes_id=#ODKES_ID#','','ui-draggable-box-large')">#comment_pay#</a></td>
							<td>
								<cfif get_odenek.ssk_statue eq 0><cf_get_lang dictionary_id='57734.Seçiniz'>
								<cfelseif get_odenek.ssk_statue eq 1><cf_get_lang dictionary_id='45049.Worker'>
								<cfelseif get_odenek.ssk_statue eq 2><cf_get_lang dictionary_id='62870.Memur'>
								<cfelseif get_odenek.ssk_statue eq 3><cf_get_lang dictionary_id='62871.Serbest Çalışan'>
								</cfif>
							</td>
							<td><cfif get_odenek.from_salary eq 1><cf_get_lang dictionary_id="53131.Brüt"><cfelseif get_odenek.from_salary eq 0><cf_get_lang_main no="671.Net"></cfif></td>
							<td>
								<cfif get_odenek.METHOD_PAY EQ 1>
										<cf_get_lang dictionary_id='53136.Artı'>
									<cfelseif get_odenek.METHOD_PAY EQ 2>
										<cf_get_lang dictionary_id='53135.Yüzde'> <cf_get_lang dictionary_id="53243.Aylık Ücret">
									<cfelseif get_odenek.METHOD_PAY EQ 3>
										<cf_get_lang dictionary_id='53135.Yüzde'> <cf_get_lang dictionary_id="53242.Günlük Ücret">
									<cfelseif get_odenek.METHOD_PAY EQ 4>
										<cf_get_lang dictionary_id='53135.Yüzde'> <cf_get_lang dictionary_id="53260.Saatlik"> <cf_get_lang dictionary_id="53127.Ücret">
									<cfelseif get_odenek.METHOD_PAY EQ 5>
										<cf_get_lang dictionary_id='57491.Saat'> x <cf_get_lang dictionary_id='63048.Ödenek Tutarı'>
								</cfif>
							</td>
							<td>
								<cfif calc_days EQ 1><cf_get_lang dictionary_id="57490.Gün">                        
								<cfelseif calc_days EQ 2><cf_get_lang dictionary_id="53968.Fiili Gün">
								<cfelseif calc_days EQ 0><cf_get_lang dictionary_id="57708.Tümü">
								</cfif> 
							</td>
							<td>
								<cfif ssk eq 1>
									<cf_get_lang dictionary_id='53401.Muaf'>
								<cfelseif ssk eq 2>
									<cf_get_lang dictionary_id='53402.Muaf Değil'>
								</cfif>
							</td>
							<td>
								<cfif tax eq 1>
									<cf_get_lang dictionary_id='53401.Muaf'>
								<cfelseif tax eq 2>
									<cf_get_lang dictionary_id='53402.Muaf Değil'>
								</cfif>
							</td>
							<td>
								<cfif is_damga eq 1><cf_get_lang dictionary_id='53402.Muaf Değil'>
								<cfelseif is_damga eq 0><cf_get_lang dictionary_id='53401.Muaf'>
								</cfif>
							</td>
							<td>
								<cfif is_issizlik eq 1><cf_get_lang dictionary_id='53402.Muaf Değil'>
								<cfelseif is_issizlik eq 0><cf_get_lang dictionary_id='53401.Muaf'>
								</cfif>
							</td>	
							</td>
							<td>#LISTgetat(ay_list(),start_SAL_MON,',')#</td>
							<td>#LISTgetat(ay_list(),END_SAL_MON,',')#</td>
							<td class="text-right">#TLFormat(AMOUNT_PAY)#</td>
							<td>#money#</td>
							<!-- sil -->
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_odenek&event=upd&odkes_id=#ODKES_ID#','','ui-draggable-box-large')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="15"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif isdefined("attributes.is_submit")>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
				<cfset url_str = "#url_str#&sal_year=#attributes.sal_year#">
			<cfif len(attributes.is_submit)>
				<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
			</cfif>
			<cfif isdefined("attributes.status") and len(attributes.status)>
				<cfset url_str = "#url_str#&status=#attributes.status#">
			</cfif>          
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="ehesap.list_odenek#url_str#">
		</cfif> 
	</cf_box>
</div>         
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
