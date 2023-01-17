<cf_xml_page_edit fuseact="finance.list_credits">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.our_company_id" default='#session.ep.company_id#'>
<cfif isdefined("attributes.form_submitted")>
<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT 
		CC.*
	FROM 
		COMPANY_CREDIT CC,
		COMPANY C
	WHERE 
		CC.COMPANY_ID = C.COMPANY_ID
		<cfif len(attributes.keyword)>
			AND
			(
			C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ATTRIBUTES.KEYWORD#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			OR
			C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ATTRIBUTES.KEYWORD#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif len(attributes.our_company_id)>
			AND CC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		</cfif>
	UNION ALL
	SELECT 
		CC.*
	FROM 
		COMPANY_CREDIT CC,
		CONSUMER C
	WHERE 
		CC.CONSUMER_ID = C.CONSUMER_ID
		<cfif len(attributes.keyword)>
			AND
			(
			C.CONSUMER_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			OR
			C.CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
		<cfif len(attributes.our_company_id)>
			AND CC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		</cfif>
</cfquery>
<cfelse>
	<cfset get_credit_limit.recordcount=0>
</cfif>
<cfquery name="GET_OUR_COMPANIES" datasource="#dsn#">
	SELECT 
	    COMP_ID,
		COMPANY_NAME 
	FROM 
	    OUR_COMPANY
	ORDER BY 
		COMPANY_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_CREDIT_LIMIT.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=finance.list_credits">    
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
				</div>
				<cfif isdefined("is_show_company") and is_show_company eq 1>
					<div class="form-group">
						<select name="our_company_id" id="our_company_id">
							<cfoutput query="get_our_companies">
								<option value="#COMP_ID#" <cfif comp_id eq attributes.our_company_id>selected</cfif>>#company_name#</option>
							</cfoutput>
						</select>
					</div>
				</cfif>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(269,'Risk Tanımları',54655)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id ='57558.Üye No'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='57519.cari hesap'></th>
					<th><cf_get_lang dictionary_id='54531.Alış Ödeme Yöntemi'></th>
					<th><cf_get_lang dictionary_id='54532.Satış Ödeme Yöntemi'></th>
					<th><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id='57875.Açık Hesap Limiti'> <cf_get_lang dictionary_id='57677.Döviz'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id='54657.Vadeli Ödeme Aracı Limiti'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>
					<th><cf_get_lang dictionary_id='54657.Vadeli Ödeme Aracı Limiti'> <cf_get_lang dictionary_id='57677.Döviz'></th>
					<th><cf_get_lang dictionary_id ='57489.Para Br'></th>		
					<th><cf_get_lang dictionary_id='54658.Ödeme Blokajı'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_credits&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>	<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfset consumer_list=''>
				<cfset company_list=''>
				<cfset paymethod_list=''>
				<cfif get_credit_limit.recordcount>
					<cfoutput query="get_credit_limit" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(company_id) and not listfind(company_list,company_id)>
							<cfset company_list=listappend(company_list,company_id)>
						</cfif>
						<cfif len(consumer_id) and not listfind(consumer_list,consumer_id)>
							<cfset consumer_list=listappend(consumer_list,consumer_id)>
						</cfif>
						<cfif len(paymethod_id) and not listfind(paymethod_list,paymethod_id)>
							<cfset paymethod_list=listappend(paymethod_list,paymethod_id)>
						</cfif>
						<cfif len(revmethod_id) and not listfind(paymethod_list,revmethod_id)>
							<cfset paymethod_list=listappend(paymethod_list,revmethod_id)>
						</cfif>
					</cfoutput>
					<cfif listlen(company_list)>
						<cfset company_list=listsort(company_list,"numeric","ASC",',')>
						<cfquery name="get_company" datasource="#dsn#">
							SELECT
								COMPANY_ID,
								FULLNAME,
								MEMBER_CODE,
								OZEL_KOD
							FROM 
								COMPANY 
							WHERE
								COMPANY_ID IN (#company_list#)
							ORDER BY
								COMPANY_ID
						</cfquery>
						<cfset main_company_list = listsort(listdeleteduplicates(valuelist(get_company.company_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif listlen(consumer_list)>
						<cfset consumer_list=listsort(consumer_list,"numeric","ASC",',')>
						<cfquery name="get_consumer" datasource="#dsn#">
							SELECT
								CONSUMER_NAME,
								CONSUMER_SURNAME,
								CONSUMER_ID,
								MEMBER_CODE,
								OZEL_KOD 
							FROM 
								CONSUMER 
							WHERE
								CONSUMER_ID IN (#consumer_list#)
							ORDER BY
								CONSUMER_ID
						</cfquery>
						<cfset main_consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif listlen(paymethod_list)>
						<cfquery name="GET_PAYMETHOD" datasource="#dsn#">
							SELECT 
								PAYMETHOD,
								PAYMETHOD_ID 
							FROM 
								SETUP_PAYMETHOD
							WHERE
								PAYMETHOD_ID IN (#paymethod_list#)
							ORDER BY
								PAYMETHOD_ID
						</cfquery>
						<cfset paymethod_list = listsort(listdeleteduplicates(valuelist(get_paymethod.paymethod_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_credit_limit" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td><cfif len(company_id)>#get_company.member_code[listfind(main_company_list,company_id,',')]#<cfelseif len(consumer_id)>#get_consumer.member_code[listfind(main_consumer_list,consumer_id,',')]#</cfif></td>
							<td><cfif len(company_id)>#get_company.ozel_kod[listfind(main_company_list,company_id,',')]#<cfelseif len(consumer_id)>#get_consumer.ozel_kod[listfind(main_consumer_list,consumer_id,',')]#</cfif></td>
							<td>
								<cfif len(company_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">
										#get_company.fullname[listfind(main_company_list,company_id,',')]#
									</a>
								<cfelseif len(consumer_id)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');">
										#get_consumer.consumer_name[listfind(main_consumer_list,consumer_id,',')]# #get_consumer.consumer_surname[listfind(main_consumer_list,consumer_id,',')]#								
									</a>
								</cfif>
							</td>
							<td><cfif len(paymethod_id)>#get_paymethod.PAYMETHOD[listfind(paymethod_list,paymethod_id,',')]#</cfif></td>
							<td><cfif len(revmethod_id)>#get_paymethod.PAYMETHOD[listfind(paymethod_list,revmethod_id,',')]#</cfif></td>
							<td class="text-right"><cfif len(OPEN_ACCOUNT_RISK_LIMIT)>#tlformat(OPEN_ACCOUNT_RISK_LIMIT)#</cfif></td>
							<td><cfif len(OPEN_ACCOUNT_RISK_LIMIT)>#session.ep.money#</cfif></td>
							<td class="text-right"><cfif len(OPEN_ACCOUNT_RISK_LIMIT_OTHER)>#tlformat(OPEN_ACCOUNT_RISK_LIMIT_OTHER)#</cfif></td>
							<td><cfif len(OPEN_ACCOUNT_RISK_LIMIT_OTHER)>#money#</cfif></td>						
							<td class="text-right"><cfif len(FORWARD_SALE_LIMIT)>#tlformat(FORWARD_SALE_LIMIT)#</cfif></td>
							<td><cfif len(FORWARD_SALE_LIMIT)>#session.ep.money#</cfif></td>
							<td class="text-right"><cfif len(FORWARD_SALE_LIMIT_OTHER)>#tlformat(FORWARD_SALE_LIMIT_OTHER)#</cfif></td>
							<td><cfif len(FORWARD_SALE_LIMIT_OTHER)>#money#</cfif></td>
							<td class="text-right"><cfif len(PAYMENT_BLOKAJ)>#PAYMENT_BLOKAJ#</cfif></td>
							<!-- sil --><td><a href="#request.self#?fuseaction=finance.list_credits&event=upd&company_id=#company_id#&consumer_id=#consumer_id#&our_company_id=#our_company_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="16"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "finance.list_credits">
		<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined ("attributes.our_company_id") and len(attributes.our_company_id)>
			<cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
		</cfif>
		<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#"> 
	</cf_box>	
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
