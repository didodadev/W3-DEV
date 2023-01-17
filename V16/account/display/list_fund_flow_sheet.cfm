<!--- Fon Akim Tablosu --->
<cfinclude template="../query/get_branch_list.cfm">
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.search_date" default="#dateformat(now(),dateformat_style)#">
<cf_date tarih="attributes.search_date">
<cfparam name="attributes.table_code_type" default="0">
<cfif isdefined("is_submitted")>
	<cfinclude template="../query/get_fund_flow_setup.cfm">
	<cfinclude template="../query/get_fund_flow_table.cfm">
<cfelse>
	<cfset GET_FUND_FLOW_DEF.recordcount=0>
	<cfset GET_FUND_FLOW.recordcount=0>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="fund_flow" action="#request.self#?fuseaction=account.list_fund_flow_detail" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinclude template="../query/get_money_list.cfm">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='47349.Lütfen Islem Baslangiç Tarihini Giriniz !'></cfsavecontent>
						<cfinput type="text" name="search_date" id="search_date" maxlength="10" value="#dateformat(attributes.search_date,dateformat_style)#" required="Yes" validate="#validate_style#" message="#message#" >
						<span class="input-group-addon"><cf_wrk_date_image date_field="search_date"></span>
					</div>	                           
				</div>
				<div class="form-group">
					<select name="table_code_type" id="table_code_type">
						<option value="0" <cfif attributes.table_code_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
						<option value="1" <cfif attributes.table_code_type eq 1>selected</cfif>><cf_get_lang dictionary_id='47352.UFRS Bazinda'></option>
					</select>                     	
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
				</div>
				<cfif isdefined("attributes.is_submitted") and attributes.is_submitted eq 1 and not listfindnocase(denied_pages,'account.popup_add_financial_table')>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray2" href="javascript://" onClick="save_fund_flow_table();"><i class="fa fa-save"></i></a>
					</div>
				</cfif>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-acc_card_type">
						<label class="col col-12"><cfoutput>#getlang(1344,'Açılış Fişi',58756)#</cfoutput></label>
						<div class="col col-12">
							<cfquery name="get_acc_card_type" datasource="#dsn3#">
							SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
							</cfquery>
							<select multiple="multiple" name="acc_card_type" id="acc_card_type" >
								<cfoutput query="get_acc_card_type" group="process_type">
									<cfoutput>
										<option value="#process_type#-#process_cat_id#" <cfif listfind(attributes.acc_card_type,'#process_type#-#process_cat_id#',',')>selected</cfif>>#process_cat#</option>
									</cfoutput>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-acc_branch_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12">
							<select multiple="multiple" name="acc_branch_id" id="acc_branch_id" >
								<optgroup label="<cf_get_lang dictionary_id='57453.Şube'>"></optgroup>
								<cfoutput query="get_branchs">
									<option value="#BRANCH_ID#" <cfif isdefined('attributes.acc_branch_id') and listfind(attributes.acc_branch_id,BRANCH_ID)>selected</cfif>>#BRANCH_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-is_bakiye">
						<label><cf_get_lang dictionary_id ='47402.Sadece Bakiyesi Olanlar'><input type="checkbox" name="is_bakiye" id="is_bakiye" value="1" <cfif isdefined('attributes.is_bakiye')>checked</cfif>></label>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
<cfif isdefined("is_submitted")>
	<cfif GET_FUND_FLOW_DEF.RECORDCOUNT>
		<cfform action="#request.self#?fuseaction=account.popup_add_financial_table" method="post" name="income_table">
			<input type="hidden" name="fintab_type" id="fintab_type" value="FUND_FLOW_TABLE">
			<cfif year(now()) gt session.ep.period_year>
				<cfset kayit_donemi = '31/12/#session.ep.period_year#'>
			<cfelse>
				<cfset kayit_donemi = dateformat(now(),dateformat_style)>
			</cfif>
			<input type="hidden" name="save_date1" id="save_date1" value="<cfoutput>#kayit_donemi#</cfoutput>">
			<cfsavecontent variable="cont">
				<!--- <cf_big_list> --->
				<cf_box title="#getLang(10,'Fon Akım Tablosu',47272)#" uidrop="1" hide_table_column="1">
					<cf_grid_list>
						<thead>
							<cfset gecensene = SESSION.EP.PERIOD_YEAR - 1 >
							<cfinclude template="../query/get_table.cfm">
							<cfif GET_TABLE.RECORDCOUNT and GET_SETUP.RECORDCOUNT and GET_SETUP.DISPLAYS contains 2>
								<tr>
									<th colspan="2"></th>
									<th colspan="4"><cf_get_lang dictionary_id ='47338.Önceki Dönem'></th>
									<th colspan="4"><cf_get_lang dictionary_id ='47330.Cari Dönem'></th>
								</tr>
							</cfif>
							<tr>
								<th><cf_get_lang dictionary_id='47299.Hesap Kodu'></th>
								<th><cf_get_lang dictionary_id='47300.Hesap Adı'></th>
								<cfif GET_TABLE.RECORDCOUNT>
								<cfif GET_SETUP.RECORDCOUNT and GET_SETUP.DISPLAYS contains 1>
									<th style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></th>
									<th style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'> </th>
									<th style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></th>
								</cfif>
								</cfif>
								<cfif GET_SETUP.RECORDCOUNT and GET_SETUP.DISPLAYS contains 2>
								<cfif GET_TABLE.RECORDCOUNT>
									<th style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'> <cfoutput>#gecensene#</cfoutput></th>
								</cfif>
								<th style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'> <cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput></th>
								</cfif>
								<cfif GET_SETUP.RECORDCOUNT and GET_SETUP.DISPLAYS contains 1>
									<th style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></th>
									<th style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></th>
									<th style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></th>
								</cfif>
							</tr>
						</thead>
						<tbody>
							<cfinclude template="../query/get_fund_flow_now_totals.cfm">
							<cfinclude template="../query/get_fund_flow_lyear_totals.cfm">
							<cfset currentrow_srm =  1 >
							<cfset currentrow_srm_b =  1 >				
							<cfif GET_FUND_FLOW.RECORDCOUNT>
								<cfoutput query="GET_FUND_FLOW">	
									<cfif currentrow_srm eq 1 and currentrow eq 1>
										<cfset currentrow_srm = 2 >
									<cfelseif GET_FUND_FLOW.RECORDCOUNT eq currentrow>
										<cfset currentrow_srm =  currentrow_srm_b >
									<cfelseif lefT(GET_FUND_FLOW.CODE[currentrow],1) neq lefT(GET_FUND_FLOW.CODE[currentrow+1],1)>	
										<cfset currentrow_srm =  1 >
										<cfset currentrow_srm_b = currentrow + 1 >							
									<cfelseif currentrow_srm neq 1>
										<cfset currentrow_srm =  currentrow_srm + 1 >
									<cfelse>
										<cfset currentrow_srm =  currentrow + 1 >						
									</cfif>
									<cfset alacak = Evaluate("_#currentrow_srm#_alacak")/attributes.rate>
									<cfset borc = Evaluate("_#currentrow_srm#_borc")/attributes.rate>
									<cfset bakiye = Evaluate("_#currentrow_srm#_bakiye")/attributes.rate>
									<cfset general_=Evaluate("general_total#currentrow_srm#")/attributes.rate>
									
									<cfif general_ neq 0 or not isdefined('attributes.is_bakiye')>
										<tr>
										<td>
											<cfif ListLen(GET_FUND_FLOW.CODE[currentrow_srm],".") neq 1>
												<cfloop from="1" to="#ListLen(GET_FUND_FLOW.CODE[currentrow_srm],".")#" index="i">&nbsp;</cfloop>
											</cfif>
											#GET_FUND_FLOW.CODE[currentrow_srm]#
										</td>
										<td>
											<cfif ListLen(GET_FUND_FLOW.CODE[currentrow_srm],".") neq 1>
												<cfloop from="1" to="#ListLen(GET_FUND_FLOW.CODE[currentrow_srm],".")#" index="i">&nbsp;</cfloop>
											</cfif>
											#GET_FUND_FLOW.NAME[currentrow_srm]#
										</td>
										<cfif GET_TABLE.RECORDCOUNT>
											<cfif GET_SETUP.RECORDCOUNT and GET_SETUP.DISPLAYS contains 1>
												<td style="text-align:right;">
													<cfset borc_l_=evaluate("_#currentrow_srm#_borc_l")/attributes.rate>
													#TLFormat(abs(borc_l_))# #attributes.money#
												</td>
												<td style="text-align:right;">
													<cfset alacak_l_=evaluate("_#currentrow_srm#_alacak_l")/attributes.rate>
													#TLFormat(abs(alacak_l_))# #attributes.money#
												</td>
												<td style="text-align:right;">
													<cfset bakiye_l_=evaluate("_#currentrow_srm#_bakiye_l")/attributes.rate>
													#TLFormat(abs(bakiye_l_))# #attributes.money#
												</td> 
											</cfif>
										</cfif>
										<cfif GET_SETUP.RECORDCOUNT and GET_SETUP.DISPLAYS contains 2>
											<cfif GET_TABLE.RECORDCOUNT>
												<td style="text-align:right;">
												<cfset general_l_=Evaluate("general_total_l#currentrow_srm#")/attributes.rate>
												#TLFormat(abs(general_l_))#
												</td>
											</cfif>
											<td style="text-align:right;">
												#TLFormat(abs(general_))# 
											</td>
										</cfif>
										<cfif GET_SETUP.RECORDCOUNT and GET_SETUP.DISPLAYS contains 1>
											<td style="text-align:right;">#TLFormat(abs(borc))# #attributes.money#</td> 
											<td style="text-align:right;">#TLFormat(abs(alacak))# #attributes.money#</td> 
											<td style="text-align:right;">#TLFormat(abs(bakiye))# #attributes.money#</td>
										</cfif>
									</tr>
									</cfif>
								</cfoutput>	
							<cfelse>
								<tr>
									<td colspan="11"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
								</tr>
							</cfif>
						</tbody>
					<!--- </cf_big_list> --->
					</cf_grid_list>
				</cf_box>
			</cfsavecontent>
			<cfoutput>#cont#</cfoutput>
		</cfform>
	<cfelse>
		<cf_box>
			<cf_grid_list>
				<tr>
					<td class="headbold"><cf_get_lang dictionary_id='47394.Fon Akım Tablosu Tanımlarınızı Yapınız !'></td>
				</tr>
			</cf_grid_list>
		</cf_box>
	</cfif>
	<cfelse>
		<cf_box>
			<cf_grid_list>
				<tbody>
					<tr>
						<td height="25"><cf_get_lang dictionary_id='57701.Filtre Ediniz!'></td>
					</tr>
				</tbody>
			</cf_grid_list>
		</cf_box>
	</cfif>
</div>
<script type="text/javascript">
	function save_fund_flow_table()
	{
		if(document.getElementById("search_date").value=='')
		{
			alert("<cf_get_lang dictionary_id ='47459.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		date2 = document.getElementById("search_date").value;
		//fintab_type_ = $('#fintab_type').val();
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=account.popup_add_financial_table&draggable=1&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&fintab_type=FUND_FLOW_TABLE&date2='+date2);
	}
</script>
<cfsetting SHOWDEBUGOUTPUT="YES">