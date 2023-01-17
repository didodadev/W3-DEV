<cfquery name="BRANCHES" datasource="#dsn#">
	SELECT * FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_POS_EQUIPMENT" datasource="#dsn3#">
	SELECT * FROM POS_EQUIPMENT_BANK WHERE POS_ID = #ATTRIBUTES.POS_ID#
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		BANK_BRANCH.*
	FROM
		ACCOUNTS,
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND
		<cfif session.ep.period_year lt 2009>
			(ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
		</cfif>
	ORDER BY
		BANK_NAME,
		ACCOUNT_NAME
</cfquery>
<cfparam  name="attributes.modal_id" default="">
<cf_box title="#getLang('','Banka','57521')##getLang('','Pos Tanımları','47182')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upd_pos" id="upd_pos" action="#request.self#?fuseaction=finance.emptypopup_upd_pos_bank" method="post">
    	<input type="hidden" name="pos_id" id="pos_id" value="<cfoutput>#attributes.pos_id#</cfoutput>">
		<input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-pos_code">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='54804.Cihaz Kodu'> *</label>
					<div class="col col-8 col-xs-12">
					<cfinput type="Text" name="pos_code"  maxlength="30" required="yes" value="#get_pos_equipment.pos_code#">
					</div>
				</div>		
				<div class="form-group" id="item-equipment">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='54805.Cihaz Adı'> *</label>
					<div class="col col-8 col-xs-12">
					<cfinput type="Text" name="equipment"  maxlength="100" required="yes" value="#get_pos_equipment.equipment#">									 
					</div>
				</div>          
				<div class="form-group" id="item-seller_code">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='54806.İşyeri Kodu'>*</label>
					<div class="col col-8 col-xs-12">
					<cfinput type="text" name="seller_code"  maxlength="30" required="yes" value="#get_pos_equipment.seller_code#">                                    									 
					</div>
				</div>          
				<div class="form-group" id="item-account_id">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57652.Hesap'> *</label>
					<div class="col col-8 col-xs-12">
					<select name="account_id" id="account_id" >
						<cfoutput query="get_accounts">
						<option value="#ACCOUNT_ID#" <cfif account_id eq get_pos_equipment.account_id>selected</cfif>>
						#ACCOUNT_NAME#&nbsp;#ACCOUNT_CURRENCY_ID#</option>
						</cfoutput>
					</select>                                    		                             									 
					</div>
				</div>        
				<div class="form-group" id="item-branch_id">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
					<div class="col col-8 col-xs-12">
					<select name="branch_id" id="branch_id" >
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="branches">
						<option value="#branch_id#" <cfif branch_id eq GET_POS_EQUIPMENT.branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>                                                                       	                             									 
					</div>
				</div>  
			</div>    
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">  
				<div class="form-group" id="item-assetp">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_pos_equipment.assetp_id#</cfoutput>">
							<cfif len(GET_POS_EQUIPMENT.assetp_id)>
							<cfset attributes.assetp_id = GET_POS_EQUIPMENT.assetp_id>
							<cfinclude template="../query/get_assetp_name.cfm">
							<input type="text" name="assetp" id="assetp"  value="<cfoutput>#get_assetp_name.assetp#</cfoutput>">
							<cfelse><input type="text" name="assetp" id="assetp" ></cfif> 
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_assets&field_id=upd_pos.assetp_id&field_name=upd_pos.assetp&event_id=0');"></span>   	                             									 
						</div>
					</div>
				</div>
				<div class="form-group" id="item-company_name">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='54808.Cari Kurumsal'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfif len(GET_POS_EQUIPMENT.company_id)> 
							<input  type="hidden" name="company_id" id="company_id" value="<cfoutput>#GET_POS_EQUIPMENT.COMPANY_ID#</cfoutput>">
							<input  type="text" name="company_name" id="company_name"  value="<cfoutput>#get_par_info(get_pos_equipment.company_id,1,0,0)#</cfoutput>">
							<cfelse>
							<input  type="hidden" name="company_id" id="company_id">
							<input  type="text" name="company_name" id="company_name" >
							</cfif>
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=upd_pos.company_id&field_comp_name=upd_pos.company_name&select_list=2');"></span>   	                             									 
						</div>
					</div>
				</div>    
				<div class="form-group" id="item-pos_code_text1">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='54577.Kasiyer'> 1</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="pos_code1" id="pos_code1" value="<cfoutput>#GET_POS_EQUIPMENT.CASHIER1#</cfoutput>">
							<cfif len(GET_POS_EQUIPMENT.CASHIER1)>
							<input  type="text" name="pos_code_text1" id="pos_code_text1"  value="<cfoutput>#get_emp_info(GET_POS_EQUIPMENT.CASHIER1,1,0)#</cfoutput>">
							<cfelse>
							<input  type="text" name="pos_code_text1" id="pos_code_text1" >
							</cfif>  
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_pos.pos_code1&field_name=upd_pos.pos_code_text1&select_list=1');"></span>   	                             									 
						</div>
					</div>
				</div>          
				<div class="form-group" id="item-pos_code_text2">
					<label class="col col-4 col-xs12"><cf_get_lang dictionary_id='54577.Kasiyer'> 2</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="pos_code2" id="pos_code2" value="<cfoutput>#GET_POS_EQUIPMENT.CASHIER2#</cfoutput>">
							<cfif len(GET_POS_EQUIPMENT.CASHIER2)>
							<input  type="text" name="pos_code_text2" id="pos_code_text2"  value="<cfoutput>#get_emp_info(GET_POS_EQUIPMENT.CASHIER2,1,0)#</cfoutput>">
							<cfelse>
							<input  type="text" name="pos_code_text2" id="pos_code_text2" >
							</cfif>                                          
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=upd_pos.pos_code2&field_name=upd_pos.pos_code_text2&select_list=1');"></span>   	                             									 
						</div>
					</div>  
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<div class="col col-6 col-xs-12">
				<cf_record_info 
					query_name = "get_pos_equipment"
					record_emp = "record_emp"
					update_emp = "update_emp" 
					record_date = "record_date"
					update_date ="update_date">
			</div>	
			<div class="col col-6 col-xs-12"> 
				<cf_workcube_buttons is_upd='1' is_delete="0" add_function='kontrol()&&#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_pos' , #attributes.modal_id#)"),DE(""))#'>                      
			</div>
		</cf_box_footer>	
	</cfform>
</cf_box>
<script type="text/javascript">

	function kontrol()
	{
		if(!$("#assetp").val().length)
		{
			
			$("#assetp_id").val('');
		}
		if(!$("#company_name").val().length)
		{
			
			$("#company_id").val('');
		}
		if(!$("#pos_code_text2").val().length)
		{
			
			$("#pos_code2").val('');
		}
		if(!$("#pos_code_text1").val().length)
		{
			
			$("#pos_code1").val('');
		}
		if(!$("#pos_code").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54811.Cihaz Kodu Girmelisiniz'>!</cfoutput>"})    
			return false;
		}
		if(!$("#equipment").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54584.Cihaz Adı Girmelisiniz'></cfoutput>"})    
			return false;
		}
		if(!$("#seller_code").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='54807.İşyeri Kodu Girmelisiniz'>!</cfoutput>"})    
			return false;
		}
		if(!$("#account_id").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='49008.Lütfen Hesap Seçiniz'></cfoutput>"})    
			return false;
		}
		



		
		x = document.upd_pos.branch_id.selectedIndex;
		if (document.upd_pos.branch_id[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'> !");
			return false;
		}
	}
</script>
