<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_txt" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("is_submitted")>
	<cfinclude template="../query/get_marketplace_commands.cfm">
	<cfset location_id=get_marketplace.LOCATION_IN>
	<cfset arama_yapilmali=0>
	<cfif isdate(attributes.start_date)>
		<cfset attributes.start_date = dateformat(attributes.start_date, "dd/mm/yyyy")>
	</cfif>
	<cfif isdate(attributes.finish_date)>
		<cfset attributes.finish_date = dateformat(attributes.finish_date, "dd/mm/yyyy")>
	</cfif>	
<cfelse>
	<cfset arama_yapilmali=1>
	<cfset get_marketplace.recordcount=0>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
	<cfform name="form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands" method="post">
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
		<cf_box_search plus="0">
			<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
				<cfinput type="text" name="keyword" placeholder="#message#" style="width:100px;" value="#attributes.keyword#" maxlength="255">
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
				<cfinput type="text" name="maxrows" style="width:25px;"  required="yes" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" passthrough = "onKeyup='return(FormatCurrency(this,event,0));'">
			</div>  
			<div class="form-group">
				<cf_wrk_search_button button_type="4">
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			</div>
		</cf_box_search>
		<cf_box_search_detail>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-location_id">
					<div class="input-group">
					   <cfinclude template="../query/get_stores.cfm"> 
					   <input type="hidden" name="location_id" id="location_id" value="">
					   <input type="hidden" name="department_id" id="department_id" <cfif len(attributes.department_txt)>value="<cfoutput>#attributes.department_id#</cfoutput>"</cfif>>
					   <cfsavecontent variable="message"><cf_get_lang dictionary_id="58763.Depo"></cfsavecontent>
					   <input type="Text" name="department_txt"  placeholder="<cfoutput>#message#</cfoutput>" id="department_txt" value="<cfoutput>#attributes.department_txt#</cfoutput>">
					   <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form&field_name=department_txt&field_id=department_id&field_location_id=location_id<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif></cfoutput>','list')"></span>
					 </div>
				 </div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-start_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
					    <cfsavecontent variable="place1"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
					    <cfinput type="text" name="start_date" value="#attributes.start_date#" style="width:80px;" validate="#validate_style#" maxlength="10" message="#message#" placeholder="#place1#" >
					    <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-finish_date">
					<div class="input-group">
					  	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
						<cfsavecontent variable="place2"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
					  	<cfinput type="text" name="finish_date" value="#attributes.finish_date#" style="width:80px;" validate="#validate_style#" maxlength="10" message="#message#" placeholder="#place2#">
					  	<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
				  </div>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
				<div class="form-group" id="item-consumer_id">
					<div class="input-group">
					   <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
					   <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
					   <cfsavecontent variable="message"><cf_get_lang dictionary_id="57519.Cari Hesap"></cfsavecontent>
					   <input type="text" name="company" placeholder="<cfoutput>#message#</cfoutput>" id="company" style="width:135px;" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>">
					   <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&keyword='+document.form.company.value,'list')"></span>
				   </div>
				 </div>
			</div>
		</cf_box_search_detail>
	</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="57819.Hal Faturası"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='58794.Referans No'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='58763.Depo'></th>
				</tr>
			</thead>
			<cfset attributes.totalrecords = get_marketplace.recordcount>
			<cfif get_marketplace.recordcount>
				<cfif len(get_marketplace.DEPARTMENT_IN)>
					<cfset dept_id_list=''>
					<cfoutput query="get_marketplace" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif not listfind(dept_id_list,get_marketplace.DEPARTMENT_IN)>
							<cfset dept_id_list=listappend(dept_id_list,get_marketplace.DEPARTMENT_IN)>
						</cfif>
					</cfoutput>
					<cfset dept_id_list=listsort(dept_id_list,"numeric")>
					<cfquery name="get_dept_name" dbtype="query">
							SELECT 
								DEPARTMENT_HEAD 
							FROM 
								stores
							WHERE
								DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#dept_id_list#">)
							ORDER BY
								DEPARTMENT_ID
						</cfquery>
					</cfif>
					<cfset company_id_list=''>
					<cfset consumer_id_list=''>
					<cfoutput query="get_marketplace" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(company_id)>
							<cfif not listfind(company_id_list,get_marketplace.company_id)>
								<cfset company_id_list=listappend(company_id_list,get_marketplace.company_id)>
							</cfif>
						<cfelseif len(consumer_id)>
							<cfif not listfind(consumer_id_list,get_marketplace.consumer_id)>
								<cfset consumer_id_list=listappend(consumer_id_list,get_marketplace.consumer_id)>
							</cfif>
						</cfif>
					</cfoutput>
					<cfif len(company_id_list)>
						<cfset company_id_list=listsort(company_id_list,"numeric")>
						<cfquery name="get_company" datasource="#dsn#">
							SELECT FULLNAME	FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric")>
						<cfquery name="get_consumer" datasource="#dsn#">
							SELECT CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
						</cfquery>
					</cfif>
					<cfform name="add_m_bill" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands&event=add">
						<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
						<tbody>
							<cfoutput query="get_marketplace" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<tr>
									<td width="20">
										<input name="list_of_ship" id="list_of_ship" type="checkbox" value="#SHIP_ID#">
										<input name="company_id_#SHIP_ID#" id="company_id_#SHIP_ID#" type="hidden" value="#COMPANY_ID#">
										<input name="partner_id_#SHIP_ID#" id="partner_id_#SHIP_ID#" type="hidden" value="#PARTNER_ID#">
										<input name="consumer_id_#SHIP_ID#"id="consumer_id_#SHIP_ID#" type="hidden" value="#CONSUMER_ID#">
									</td>
									<td>#dateformat(SHIP_DATE,dateformat_style)#</td>
									<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_ship&SHIP_ID=#SHIP_ID#','list');" class="tableyazi">#SHIP_NUMBER#</a></td>
									<td>
										<cfif len(company_id) and company_id neq 0>
											#get_company.FULLNAME[listfind(company_id_list,get_marketplace.COMPANY_ID,',')]#
										<cfelseif len(consumer_id)>
											#get_consumer.CONSUMER_NAME[listfind(consumer_id_list,get_marketplace.consumer_id,',')]# &nbsp; #get_consumer.CONSUMER_SURNAME[listfind(consumer_id_list,get_marketplace.consumer_id,',')]#
										</cfif>
									</td>
									<td>#get_dept_name.DEPARTMENT_HEAD[listfind(dept_id_list,get_marketplace.DEPARTMENT_IN,',')]#</td>
								</tr>
						   </cfoutput>
						</tbody>
					</cfform>  
				<cfelse>
					<tbody>
						<tr>
							<td colspan="5" height="20"><cfif arama_yapilmali><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
						</tr>
					</tbody>
				</cfif>		
		</cf_grid_list>
		<cf_box_footer>
			<input class=" ui-wrk-btn ui-wrk-btn-success" name="ekle" id="ekle" type="button"  onClick="kontrol_checkbox();" value="<cf_get_lang dictionary_id ='57345.Fatura Oluştur'>">
		</cf_box_footer>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfscript>
				url_str = "";
				if(len(attributes.department_id))
					url_str = "#url_str#&department_id=#attributes.department_id#" ;
				if(len(attributes.department_txt))
					url_str = "#url_str#&department_txt=#attributes.department_txt#" ;
				if((len(attributes.company_id) and len(attributes.company) ) or (len(attributes.consumer_id) and len(attributes.company)))
					url_str = "#url_str#&company_id=#attributes.company_id#&company=#attributes.company#&consumer_id=#attributes.consumer_id#" ;
				if(isdefined("attributes.cat") and len(attributes.cat))
					url_str = "#url_str#&cat=#attributes.cat#";
				if(len(attributes.start_date))
					url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#" ;
				if(len(attributes.finish_date))
					url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" ;
				if (isdefined("is_submitted"))
					url_str = "#url_str#&is_submitted";
			</cfscript>
			<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands&keyword=#attributes.keyword##url_str#">	
		</cfif>
	</cf_box>
</div>

<br/>
<script type="text/javascript">
	function kontrol_checkbox()
	{
		int_sayac = 0;
		try{
			if(add_m_bill.list_of_ship.length == undefined){
				if(add_m_bill.list_of_ship.checked) int_sayac = 1;
			}else{
				for (i = 0 ; i < add_m_bill.list_of_ship.length ; i = i + 1)
					if(add_m_bill.list_of_ship[i].checked){
						int_sayac = int_sayac + 1;
					}
			}
			if(int_sayac == 0){
				alert("<cf_get_lang dictionary_id='57346.İrsaliye Seçimi Yapınız'>!");
				return false; 
			}else{
				add_m_bill.submit(); 
			}
		}catch(e){}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
