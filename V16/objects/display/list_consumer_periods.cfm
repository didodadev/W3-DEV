<cffunction name="get_account_code">
	<cfargument name="cpid">
	<cfargument name="period_id">
    <cfargument name="type_id">
	<cfargument name="account_code_type">
	<cfquery name="GET_PERIOD_INFO" datasource="#DSN#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#">
	</cfquery>
	<cfquery name="GET_ACC_CODE" datasource="#DSN#">
		SELECT
			AP.ACCOUNT_NAME,
			CONSUMER_PERIOD.ACCOUNT_CODE,
			CONSUMER_PERIOD.KONSINYE_CODE,
            CONSUMER_PERIOD.ADVANCE_PAYMENT_CODE,
			CONSUMER_PERIOD.SALES_ACCOUNT,
			CONSUMER_PERIOD.PURCHASE_ACCOUNT,
			CONSUMER_PERIOD.RECEIVED_GUARANTEE_ACCOUNT,
			CONSUMER_PERIOD.GIVEN_GUARANTEE_ACCOUNT,
			CONSUMER_PERIOD.RECEIVED_ADVANCE_ACCOUNT,
			CONSUMER_PERIOD.EXPORT_REGISTERED_SALES_ACCOUNT,
			CONSUMER_PERIOD.EXPORT_REGISTERED_BUY_ACCOUNT
		FROM
			CONSUMER_PERIOD WITH (NOLOCK),
			#dsn#_#get_period_info.period_year#_#get_period_info.our_company_id#.ACCOUNT_PLAN AP
		WHERE
			CONSUMER_PERIOD.#account_code_type# = AP.ACCOUNT_CODE AND
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#"> AND
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cpid#">
	</cfquery>
	<cfif get_acc_code.recordcount >
    	<cfswitch expression="#type_id#">
			<cfcase value="1"><cfset code=get_acc_code.account_code><cfset name=get_acc_code.account_name></cfcase>
			<cfcase value="2"><cfset code=get_acc_code.advance_payment_code><cfset name=get_acc_code.account_name></cfcase>
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
<cfinclude template="../query/get_consumer_period_details.cfm">
<cfset period_selected=ValueList(get_consumer_periods.period_id)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Muhasebe Dönemleri','32707')#" history_href="javascript:openBoxDraggable('#request.self#?fuseaction=member.popup_member_periods_history&member_type=consumer&member_id=#attributes.cpid#')" history_title="#getLang('','Tarihçe','57473')#" popup_box="1">
		<cfform name="add_period" method="post" action="#request.self#?fuseaction=objects.add_periods_to_consumer&cpid=#attributes.cpid#">
			<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_other_consumers.recordcount#</cfoutput>">
			<div class="col col-6 col-md-4 col-sm-6 col-xs-12">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20"><cf_get_lang dictionary_id='58693.Seç'></th>
							<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
							<th width="300"><cf_get_lang dictionary_id='32691.Periot'></th>
							<th width="70"><cf_get_lang dictionary_id='57485.Öncelik'></th>
							<th width="70"><cf_get_lang dictionary_id='32693.Period Yıl'></th>
							<th width="20">&nbsp;</th>
						</tr>
					</thead>
					<tbody>
						<cfif get_other_consumers.recordcount>
							<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_other_consumers.recordcount#</cfoutput>">
							<cfoutput query="get_other_consumers">    
								<tr>
									<td><input type="checkbox" name="periods" id="periods" class = "periods" value="#PERIOD_ID#" <cfif ListFind(period_selected,PERIOD_ID,",") and len(AUTHORITY_STATUS) >Checked</cfif> <cfif not len(AUTHORITY_STATUS)>disabled</cfif> onClick = "check_period_exists();"></td>
									<td>#currentrow#</td>
									<td>#period#</td>
									<td>
										<cfif (get_consumer_periods.default_period is get_other_consumers.period_id) and (len(get_consumer_periods.default_period) or len(get_other_consumers.period_id))>
											<input type="radio" name="period_default" id="period_default" value="#period_id#" checked <cfif not len(authority_status)>disabled</cfif>>
										<cfelse>
											<input type="radio" name="period_default" id="period_default" value="#period_id#" <cfif not len(authority_status)>disabled</cfif>>
										</cfif>
									</td>
									<td>
										#period_year#
										<input type="hidden" name="for_control" id="for_control" value="#period_year#-#our_company_id#-#period_id#">
										<input type="hidden" name="dsn_#period_id#" id="dsn_#period_id#" value="#dsn#_#period_year#_#our_company_id#">
									</td>
									<td>
										<!--- <input type="button" name="period_detail" class="period_detail" id="#PERIOD_ID#" value="<cf_get_lang dictionary_id='57771.Detay'>"> --->
										<a href="javascript:// " name="period_detail" class="period_detail" id="#PERIOD_ID#"><i class="fa fa-cube" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a>
									</td>
								</tr>
							</cfoutput> 
						</cfif>	
					</tbody>
				</cf_grid_list>
			</div>
			<div class="col col-6 col-md-4 col-sm-6 col-xs-12" id="the_Div" >
				<cfif get_other_consumers.recordcount>
					<cfoutput query="get_other_consumers">
						<input type="hidden" name="dsn_#PERIOD_ID#" id="dsn_#PERIOD_ID#" value="#dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#">
						<input type="hidden" name="for_control" id="for_control" value="#PERIOD_YEAR#-#OUR_COMPANY_ID#-#PERIOD_ID#">
						<div id="#PERIOD_ID#" style="display:none;" class="childDiv2">
							<cf_box_elements>
								<div class="form-group col col-12">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='32693.Period Yıl'></label>
									<div class="col col-3 col-md-8 col-xs-12 paddingNone">
										<select name="PERIOD_YEAR" id="PERIOD_YEAR">
											<cfloop query="GET_PERIOD_YEAR">
												<option value="#GET_PERIOD_YEAR.PERIOD_YEAR#" <cfif len(get_other_consumers.PERIOD_YEAR) and get_other_consumers.PERIOD_YEAR eq GET_PERIOD_YEAR.PERIOD_YEAR> selected</cfif>>#GET_PERIOD_YEAR.PERIOD_YEAR#</option>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="form-group col col-12"  id="myAccount#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='29436.Standart Hesap'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,1,'ACCOUNT_CODE')>
											<input type="text" name="account_code#PERIOD_ID#" id="account_code#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('account_code#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_code#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('account_code','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="item-konsinye_code#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='45518.Konsinye'> <cf_get_lang dictionary_id='57448.Satış'> <cf_get_lang dictionary_id='48668.Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,2,'KONSINYE_CODE')>
										<input type="text" name="konsinye_code#PERIOD_ID#" id="konsinye_code#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('konsinye_code#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','konsinye_code#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('konsinye_code','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="item_advance_payment_code#PERIOD_ID#"> 
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58490.Verilen'> <cf_get_lang dictionary_id='58204.Avans'> <cf_get_lang dictionary_id='48668.Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,3,'ADVANCE_PAYMENT_CODE')>
											<input type="text" name="advance_payment_code#PERIOD_ID#" id="advance_payment_code#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('advance_payment_code#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','advance_payment_code#PERIOD_ID#','','3','200');"  <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('advance_payment_code','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="SalesAcc#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='38373.Satış Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,4,'SALES_ACCOUNT')>
											<input type="text" name="SALES_ACCOUNT#PERIOD_ID#" id="SALES_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('SALES_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','SALES_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('SALES_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="PurchaseAcc#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='38375.Alış Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,5,'PURCHASE_ACCOUNT')>
											<input type="text" name="PURCHASE_ACCOUNT#PERIOD_ID#" id="PURCHASE_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('PURCHASE_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','PURCHASE_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('PURCHASE_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="ReceivedGuaranteeAcc#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='40316.Alınan Teminat'> <cf_get_lang dictionary_id='48668.Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,6,'RECEIVED_GUARANTEE_ACCOUNT')>
											<input type="text" name="RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#" id="RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','RECEIVED_GUARANTEE_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('RECEIVED_GUARANTEE_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="GivenGuaranteeAcc#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58490.Verilen'> <cf_get_lang dictionary_id='58689.Teminat'> <cf_get_lang dictionary_id='48668.Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,7,'GIVEN_GUARANTEE_ACCOUNT')>
											<input type="text" name="GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#" id="GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','GIVEN_GUARANTEE_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('GIVEN_GUARANTEE_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="ReceivedAdvanceAcc#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58488.Alınan'> <cf_get_lang dictionary_id='58204.Avans'> <cf_get_lang dictionary_id='48668.Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,8,'RECEIVED_ADVANCE_ACCOUNT')>
											<input type="text" name="RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#" id="RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','RECEIVED_ADVANCE_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('RECEIVED_ADVANCE_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="ExpRegSalesAcc#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38373.Satış Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,9,'EXPORT_REGISTERED_SALES_ACCOUNT')>
											<input type="text" name="EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#" id="EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','EXPORT_REGISTERED_SALES_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('EXPORT_REGISTERED_SALES_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
								<div class="form-group col col-12" id="ExpRegBuyAcc#PERIOD_ID#">
									<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38375.Alış Hesabı'></label>
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.CPID,PERIOD_ID,10,'EXPORT_REGISTERED_BUY_ACCOUNT')>
											<input type="text" name="EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#" id="EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" style="width:75px" onfocus="AutoComplete_Create('EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','EXPORT_REGISTERED_BUY_ACCOUNT#PERIOD_ID#','','3','200');" <cfif not len(AUTHORITY_STATUS)>readonly</cfif>>
										<cfif len(AUTHORITY_STATUS)>
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="pencere_ac('EXPORT_REGISTERED_BUY_ACCOUNT','#PERIOD_ID#','#OUR_COMPANY_ID#','#PERIOD_YEAR#');"></span>
										</cfif>
									</div>
								</div>
							</cf_box_elements>
						</div>
					</cfoutput>
				</cfif>
			</div>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57582.Ekle'></cfsavecontent>
					<cf_workcube_buttons type_format='1' is_upd='0' insert_info='#message#' add_function='kontrol_default_period()'>
				</cf_box_footer>
			</div>	
		</cfform>
	</cf_box>
</div>
<script language="JavaScript1.1">
	$( document ).ready(function() {
		check_period_exists();
	});

	$("a[name=period_detail]").click(function()
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
		<!---Muhasebe hesabı ve avans alt hesaplar gelirken üst hesapların yazılamaması kontrolü--->
	 	<cfoutput query="get_other_consumers"> 
			var new_dsn_value = document.getElementById("dsn_#period_id#").value;
			var account_code_value = document.getElementById("account_code#period_id#").value;
			
			if(account_code_value != "")
 			{ 
				if(WrkAccountControl(account_code_value,'#currentrow#. Satır: Muhasebe Hesabı Hesap Planında Tanımlı Değildir!',new_dsn_value) == 0)
 				return false;
 			}
			var advance_payment_value = document.getElementById("advance_payment_code#period_id#").value;
 			if(advance_payment_value != "")
 			{ 
				if(WrkAccountControl(advance_payment_value,'#currentrow#. Satır: Avans Kod Hesabı Tanımlı Değildir!',new_dsn_value) == 0)
 				return false;
 			}
 		</cfoutput>	
		temp1=0;
		
		for(i=0;i<add_period.period_default.length;i++)
			if (add_period.period_default[i].checked==1)
				temp1 = 1;
	
		if (temp1 == 0)
		{
			if(add_period.period_default.checked == 1)
					return true;		

			alert("<cf_get_lang dictionary_id ='33372.Öncelik Kolonundan Standart Bir Dönem Seçmelisiniz'>!");
			return false;
		}
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
