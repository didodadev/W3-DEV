<cffunction name="get_account_code">
	<cfargument name="CPID">
	<cfargument name="period_id">	
	<cfargument name="type_id">
	<cfargument name="account_code_type">
	<cfquery name="GET_PERIOD_INFO" datasource="#DSN#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = #period_id#
	</cfquery>
	
	<cfquery name="GET_ACC_CODE" datasource="#DSN#">
		SELECT
			AP.ACCOUNT_NAME,
			COMPANY_PERIOD.ACCOUNT_CODE,
			COMPANY_PERIOD.KONSINYE_CODE,
			COMPANY_PERIOD.ADVANCE_PAYMENT_CODE,
            COMPANY_PERIOD.SALES_ACCOUNT,
			COMPANY_PERIOD.PURCHASE_ACCOUNT,
			COMPANY_PERIOD.RECEIVED_GUARANTEE_ACCOUNT,
			COMPANY_PERIOD.GIVEN_GUARANTEE_ACCOUNT,
			COMPANY_PERIOD.RECEIVED_ADVANCE_ACCOUNT,
			COMPANY_PERIOD.EXPORT_REGISTERED_SALES_ACCOUNT,
			COMPANY_PERIOD.EXPORT_REGISTERED_BUY_ACCOUNT
		FROM
			COMPANY_PERIOD,
			#dsn#_#get_period_info.period_year#_#get_period_info.our_company_id#.ACCOUNT_PLAN AP
		WHERE
			COMPANY_PERIOD.#account_code_type# = AP.ACCOUNT_CODE AND
			PERIOD_ID = #period_id# AND
			COMPANY_ID = #CPID#
	</cfquery>
	<cfif get_acc_code.recordcount>
		<cfswitch expression="#type_id#">
			<cfcase value="1"><cfset code=get_acc_code.ACCOUNT_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="2"><cfset code=get_acc_code.KONSINYE_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="3"><cfset code=get_acc_code.ADVANCE_PAYMENT_CODE><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="4"><cfset code=get_acc_code.SALES_ACCOUNT><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="5"><cfset code=get_acc_code.PURCHASE_ACCOUNT><cfset name=get_acc_code.ACCOUNT_NAME></cfcase>
			<cfcase value="6"><cfset code=get_acc_code.RECEIVED_GUARANTEE_ACCOUNT><cfset name=get_acc_code.RECEIVED_GUARANTEE_ACCOUNT></cfcase>
			<cfcase value="7"><cfset code=get_acc_code.GIVEN_GUARANTEE_ACCOUNT><cfset name=get_acc_code.GIVEN_GUARANTEE_ACCOUNT></cfcase>
			<cfcase value="8"><cfset code=get_acc_code.RECEIVED_ADVANCE_ACCOUNT><cfset name=get_acc_code.RECEIVED_ADVANCE_ACCOUNT></cfcase>
			<cfcase value="9"><cfset code=get_acc_code.EXPORT_REGISTERED_SALES_ACCOUNT><cfset name=get_acc_code.EXPORT_REGISTERED_SALES_ACCOUNT></cfcase>
			<cfcase value="10"><cfset code=get_acc_code.EXPORT_REGISTERED_BUY_ACCOUNT><cfset name=get_acc_code.EXPORT_REGISTERED_BUY_ACCOUNT></cfcase>
		</cfswitch>
		<cfset acc_inf = StructNew()>
		<cfset new_struct = StructInsert(acc_inf, "acc_code", code)>
		<cfset new_struct = StructInsert(acc_inf, "acc_name", name)>
		<cfreturn acc_inf>
	<cfelse>	
		<cfset acc_inf = StructNew()>
		<cfset new_struct = StructInsert(acc_inf, "acc_code", "")>
		<cfset new_struct = StructInsert(acc_inf, "acc_name", "")>
		<cfreturn acc_inf>
	</cfif>
</cffunction> 
<cf_xml_page_edit fuseact="objects.popup_list_periods">
<cfinclude template="../query/get_company_period_details.cfm">

<cfset period_selected=ValueList(get_company_periods.period_id)>
<cfsavecontent variable="right">
	<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=member.popup_member_periods_history&member_type=company&member_id=#attributes.cpid#</cfoutput>','','ui-draggable-box-large');" class="font-red-pink"><i class="fa fa-history" title="<cf_get_lang dictionary_id='57473.Tarihçe'>"></i></a>
</cfsavecontent>
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Muhasebe Dönemleri',32707)#" right_images='#right#' scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_period" method="post" action="#request.self#?fuseaction=objects.add_periods_to_company&cpid=#attributes.cpid#">
		<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_other_companies.recordcount#</cfoutput>">
		<input type="hidden" name="is_buyer" id="is_buyer" value="<cfoutput>#GET_COMPANY_PERIODS.IS_BUYER#</cfoutput>">
		<input type="hidden" name="is_seller" id="is_seller" value="<cfoutput>#GET_COMPANY_PERIODS.IS_SELLER#</cfoutput>">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="20"><cf_get_lang dictionary_id='58693.Seç'></th>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="300"><cf_get_lang dictionary_id='32691.Period'></th>
					<th width="70"><cf_get_lang dictionary_id='57485.Öncelik'></th>
					<th width="20"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_other_companies.recordcount>
					
					<cfoutput query="get_other_companies" >
					<tr>
					<td><input type="checkbox" name="periods" id="periods" class = "periods" value="#PERIOD_ID#" <cfif ListFind(period_selected,PERIOD_ID,",") and len(AUTHORITY_STATUS) >Checked</cfif> <cfif not len(AUTHORITY_STATUS)>disabled</cfif> onClick = "check_period_exists();"></td>
						<td>#currentrow#</td>
						<td>#PERIOD#</td>
						<td>
							<cfif (GET_COMPANY_PERIODS.DEFAULT_PERIOD is GET_OTHER_COMPANIES.PERIOD_ID) and (len(GET_COMPANY_PERIODS.DEFAULT_PERIOD) or len(GET_OTHER_COMPANIES.PERIOD_ID))>
								<input type="radio" name="period_default" id="period_default"  value="#PERIOD_ID#" checked <cfif not len(AUTHORITY_STATUS)>disabled</cfif>>
							<cfelse>
								<input type="radio" name="period_default" id="period_default"  value="#PERIOD_ID#" <cfif not len(AUTHORITY_STATUS)>disabled</cfif>>
							</cfif>
						</td>
						<td>
							<input type="button" name="period_detail" class = "period_detail" id="#PERIOD_ID#"  value="<cf_get_lang dictionary_id='57771.Detay'>">
						</td>
					</tr>
					</cfoutput> 
				</cfif>	
			</tbody>
		</cf_grid_list>
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="the_Div">
				<cfif get_other_companies.recordcount>
					<cfoutput query="get_other_companies">
						<input type="hidden" name="dsn_#PERIOD_ID#" id="dsn_#PERIOD_ID#" value="#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#">
						<input type="hidden" name="for_control" id="for_control" value="#PERIOD_YEAR#-#OUR_COMPANY_ID#-#PERIOD_ID#">
						<div id="#PERIOD_ID#" style="display:none;" class="childDiv2">
							<div class="form-group">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='32693.Period Yıl'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<select name="PERIOD_YEAR" id="PERIOD_YEAR">
										<cfloop query="GET_PERIOD_YEAR">
											<option value="#GET_PERIOD_YEAR.PERIOD_YEAR#" <cfif len(get_other_companies.PERIOD_YEAR) and get_other_companies.PERIOD_YEAR eq GET_PERIOD_YEAR.PERIOD_YEAR> selected</cfif>>#GET_PERIOD_YEAR.PERIOD_YEAR#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group"  id="myAccount#PERIOD_ID#">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='29436.Standart Hesap'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,1,'ACCOUNT_CODE')>
											<input type="text" name="account_code#PERIOD_ID#" id="account_code#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('account_code#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_code#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('account_code','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<cfif xml_konsinye_code eq 1>
								<div class="form-group" id="item-konsinye_code#PERIOD_ID#">
									<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='45518.Konsinye'><cf_get_lang dictionary_id='57448.Satış'><cf_get_lang dictionary_id='48668.Hesabı'></label>
									<div class="col col-8 col-md-8 col-xs-12 paddingNone">
										<div class="input-group">
											<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,2,'KONSINYE_CODE')>
											<input type="text" name="konsinye_code#PERIOD_ID#" id="konsinye_code#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('konsinye_code#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','konsinye_code#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
											<cfif len(AUTHORITY_STATUS)>
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('konsinye_code','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
											</cfif>
										</div>
									</div>
								</div>
							</cfif>
							<cfif xml_advance_payment_code eq 1>
								<div class="form-group" id="item_advance_payment_code#PERIOD_ID#"> 
									<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58490.Verilen'> <cf_get_lang dictionary_id='58204.Avans'> <cf_get_lang dictionary_id='48668.Hesabı'></label>
									<div class="col col-8 col-md-8 col-xs-12 paddingNone">
										<div class="input-group">
											<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,3,'ADVANCE_PAYMENT_CODE')>
												<input type="text" name="advance_payment_code#PERIOD_ID#" id="advance_payment_code#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('advance_payment_code#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','advance_payment_code#PERIOD_ID#','','3','200');"  <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
											<cfif len(AUTHORITY_STATUS)>
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('advance_payment_code','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
											</cfif>
										</div>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="SalesAcc#PERIOD_ID#">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='38373.Satış Hesabı'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,4,'SALES_ACCOUNT')>
											<input type="text" name="SALES_ACCOUNT#PERIOD_ID#" id="SALES_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('SALES_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','SALES_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('SALES_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="PurchaseAcc#PERIOD_ID#">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='38375.Alış Hesabı'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,5,'PURCHASE_ACCOUNT')>
											<input type="text" name="PURCHASE_ACCOUNT#PERIOD_ID#" id="PURCHASE_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('PURCHASE_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','PURCHASE_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('PURCHASE_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="ReceivedGuaranteeAcc#PERIOD_ID#">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='40316.Alınan Teminat'> <cf_get_lang dictionary_id='48668.Hesabı'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,6,'RECEIVED_GUARANTEE_ACCOUNT')>
											<input type="text" name="RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#" id="RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('RECEIVED_GUARANTEE_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="GivenGuaranteeAcc#PERIOD_ID#">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58490.Verilen'><cf_get_lang dictionary_id='58689.Teminat'><cf_get_lang dictionary_id='48668.Hesabı'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,7,'GIVEN_GUARANTEE_ACCOUNT')>
											<input type="text" name="GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#" id="GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('GIVEN_GUARANTEE_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="ReceivedAdvanceAcc#PERIOD_ID#">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58488.Alınan'><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,8,'RECEIVED_ADVANCE_ACCOUNT')>
											<input type="text" name="RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#" id="RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('RECEIVED_ADVANCE_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="ExpRegSalesAcc#PERIOD_ID#">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38373.Satış Hesabı'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,9,'EXPORT_REGISTERED_SALES_ACCOUNT')>
											<input type="text" name="EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#" id="EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('EXPORT_REGISTERED_SALES_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</div>
							<div class="form-group" id="ExpRegBuyAcc#PERIOD_ID#">
								<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38375.Alış Hesabı'></label>
								<div class="col col-8 col-md-8 col-xs-12 paddingNone">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,10,'EXPORT_REGISTERED_BUY_ACCOUNT')>
											<input type="text" name="EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#" id="EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('EXPORT_REGISTERED_BUY_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</div>
						</div>
					</cfoutput>
				</cfif>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' insert_info='#getLang('','Ekle',57582)#' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol_default_period() && loadPopupBox('add_period' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>	
	</cfform>
</cf_box>				
<script type="text/javascript">
	$( document ).ready(function() {
		check_period_exists();
	});
	$("input[name=period_detail]").click(function()
		{
			var id = $(this).attr("id");
			$("#the_Div .childDiv2").each(function()
				{
					if(id!=$(this).attr("id")) $(this).hide();
					else $(this).show();
				}
			)
			
		}

	);

	function check_period_exists() {
		//$("#the_Div .childDiv2").hide();
		$('.periods').each(function(i, obj1) {
			if(obj1.checked) {
				$("#" + obj1.value).prop('disabled',false);
				$("#" + obj1.value).show();
			} else {
				$("#" + obj1.value).prop('disabled',true);
				$("#" + obj1.value).hide();
			}
		});
	}

	function kontrol_default_period()
	{
		//Muhasebe hesabı alt hesaplar gelirken üst hesapların yazılamaması kontrolü
		<cfoutput query="get_other_companies"> 
			var new_dsn_value = document.getElementById("dsn_#PERIOD_ID#").value;
			var account_code_value = document.getElementById("account_code#PERIOD_ID#").value;
				if(account_code_value != "")
				{ 
					if(WrkAccountControl(account_code_value,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="52213.Muhasebe Hesabı Hesap Planında Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}
				<cfif xml_konsinye_code eq 1>
				var konsinye_code_value = document.getElementById("konsinye_code#PERIOD_ID#").value;
				if(konsinye_code_value != "")
				{ 
					if(WrkAccountControl(konsinye_code_value,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60159.Konsinye Kod Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}
				</cfif>
				<cfif xml_advance_payment_code eq 1>
					var advance_payment_value = document.getElementById("advance_payment_code#PERIOD_ID#").value;
					if(advance_payment_value != "")
					{ 
						if(WrkAccountControl(advance_payment_value,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60160.Avans Kod Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
						return false;
					}
				</cfif>
				var sales_account_value = document.getElementById("SALES_ACCOUNT#PERIOD_ID#").value;
				if(sales_account_value != "")
				{
					if(WrkAccountControl(sales_account_value,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60161.Satış Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}
				var purchase_account_value = document.getElementById("PURCHASE_ACCOUNT#PERIOD_ID#").value;
				if(purchase_account_value != "")
				{
					if(WrkAccountControl(purchase_account_value,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60162.Alış Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}
				var received_guarantee_account_value = document.getElementById("RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#").value;
				if(received_guarantee_account_value != "")
				{
					if(WrkAccountControl(received_guarantee_account_value,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60163.Alınan Teminat Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}
				var given_guarantee_account_value = document.getElementById("GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#").value;
				if(given_guarantee_account_value != "")
				{
					if(WrkAccountControl(given_guarantee_account_value,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60164.Verilen Teminat Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}
				var received_advance_account_value = document.getElementById("RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#").value;
				if(received_advance_account_value != "")
				{
					if(WrkAccountControl(received_advance_account_value,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60165.Alınan Avans Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}
				var export_registered_sales_account = document.getElementById("EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#").value;
				if(export_registered_sales_account != "")
				{
					if(WrkAccountControl(export_registered_sales_account,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60166.İhraç Kayıtlı Satış Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}
				var export_registered_buy_account = document.getElementById("EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#").value;
				if(export_registered_buy_account != "")
				{
					if(WrkAccountControl(export_registered_buy_account,'#currentrow#. <cf_get_lang dictionary_id="58508.Satır">: <cf_get_lang dictionary_id="60167.İhraç Kayıtlı Alış Hesabı Tanımlı Değildir">!',new_dsn_value) == 0)
					return false;
				}

		</cfoutput>
		temp1=0;
		for(i=0;i<add_period.period_default.length;i++)
			if (add_period.period_default[i].checked==1)
			{
				temp1 = 1;
			}
		if (temp1 == 0)
		{
			if(add_period.period_default.checked == 1 ){
				return true;
			}
			alert("<cf_get_lang dictionary_id ='33372.Öncelik Kolonundan Standart Bir Dönem Seçmelisiniz'>!");
			return false;
		}
		return true;
	}
	function pencere_ac(field_name,row,cid,pyear)
	{
		temp_field_id='add_period.'+field_name+row;
		temp_account_code = eval(temp_field_id).value;
		if (temp_account_code.length != 0)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id='+temp_field_id+'&account_code=' + temp_account_code + '&period_year='+pyear+'&db_source='+cid+'&is_title=1');
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id='+temp_field_id+'&period_year='+pyear+'&db_source='+cid+'&is_title=1');
	}
</script>