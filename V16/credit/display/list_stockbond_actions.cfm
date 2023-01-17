<cfparam name="attributes.cat" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif isdefined("attributes.start_date") and not len(attributes.start_date)>
	<cfset attributes.start_date = "">
<cfelse>
    <cfset attributes.start_date = dateadd('d',-7,wrk_get_today())>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif isdefined("attributes.finish_date") and not len(attributes.finish_date)>
	<cfset attributes.finish_date = "">
<cfelse>
	<cfset attributes.finish_date = dateadd('d',7,attributes.start_date)>
</cfif>
<cfif isdefined('attributes.form_exist')>
	<cfscript>
        getCredit_=createobject("component","V16.credit.cfc.credit");
        getCredit_.dsn3=#dsn3#;
		getStockbondData = getCredit_.getStockbondData(
			start_date : attributes.start_date ,
			finish_date : attributes.finish_date ,
			cat : attributes.cat ,
			company_id : attributes.company_id ,
			company_name : attributes.company_name ,
			employee_id : attributes.employee_id ,
			employee_name : attributes.employee_name ,
			startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
		);
    </cfscript>
    <cfparam name="attributes.totalrecords" default="#getStockbondData.QUERY_COUNT#">
<cfelse>
	<cfset getStockbondData.recordcount = 0>	
    <cfparam name="attributes.totalrecords" default="0">
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_credit_contract" method="post" action="#request.self#?fuseaction=credit.list_stockbond_actions">
			<input type="hidden" name="form_exist" id="form_exist" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="text" name="employee_name" id="employee_name" style="width:100px;" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_id) and isdefined('attributes.employee_name') and len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','list_credit_contract','3','125');" placeholder="<cf_get_lang dictionary_id ='58586.İşlem Yapan'>">	
						<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id ='58586.İşlem Yapan'>" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_credit_contract.employee_id&field_name=list_credit_contract.employee_name&select_list=1','list');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" maxlength="50" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
						<input name="company_name" type="text" id="company_name" style="width:100px;" value="<cfoutput>#attributes.company_name#</cfoutput>" onfocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','225');"  autocomplete="off" placeholder="<cf_get_lang dictionary_id ='57519.Cari Hesap'>">
						<span class="input-group-addon icon-ellipsis btnPointer" title="<cfoutput>#getLang('main',322)#​</cfoutput>" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_comp_id=list_credit_contract.company_id&field_member_name=list_credit_contract.company_name</cfoutput>&keyword='+encodeURIComponent(document.list_credit_contract.company_name.value),'list')"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="cat" id="cat" style="width:150px;">
						<option selected value=""><cf_get_lang dictionary_id ='51360.Menkul Kıymet Hareketi'></option>
						<option value="293" <cfif attributes.cat eq "293">selected</cfif>><cf_get_lang dictionary_id ='57840.Menkul Kıymet Alış'></option>
						<option value="294" <cfif attributes.cat eq "294">selected</cfif>><cf_get_lang dictionary_id ='57841.Menkul Kıymet Satış'></option>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(84,'Menkul Kıymet Hareketleri',51416)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id ='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id ='57630.Tip'></th>
					<th><cf_get_lang dictionary_id ='58585.Kod'></th>
					<th><cf_get_lang dictionary_id ='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>	
					<th><cf_get_lang dictionary_id ='58586.İşlem Yapan'></th>	
					<th><cf_get_lang dictionary_id ='57673.Tutar'></th>	
					<th><cf_get_lang dictionary_id ='58056.Tutar Döviz'></th>	
					<th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_exist") and getStockbondData.recordcount>
					<cfoutput query="getStockbondData" >
						<tr>
						<td>#rownum#</td>
						<td>#get_process_name(process_type)#</td>
						<td>#paper_no#</td>
						<td>#dateformat(action_date,dateformat_style)#</td>
						<td>#fullname#</td>
						<td>#employee_name#&nbsp;
							#employee_surname#</td>
						<td style="text-align:right;">#TLFormat(net_total,session.ep.our_company_info.rate_round_num)#</td>
						<td style="text-align:right;">#TLFormat(other_money_value,session.ep.our_company_info.rate_round_num)#</td>
						<!-- sil --><td>
						<cfif process_type eq 293>
						<a href="#request.self#?fuseaction=credit.add_stockbond_purchase&event=upd&action_id=#ACTION_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						<cfelse>
						<a href="#request.self#?fuseaction=credit.add_stockbond_sale&event=upd&action_id=#ACTION_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						</cfif>
						</td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
				<tr>
					<td colspan="11"><cfif isdefined("attributes.form_exist")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset adres="form_exist=1">
		<cfif isDefined('attributes.cat') and len(attributes.cat)>
			<cfset adres = "#adres#&cat=#attributes.cat#">
		</cfif>
		<cfif isdate(attributes.start_date)>
			<cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
		</cfif>
		<cfif isdate(attributes.finish_date)>
			<cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
		</cfif>
		<cfif len(attributes.company_name)>
			<cfset adres = "#adres#&company_name=#attributes.company_name#" >
		</cfif>
		<cfif len(attributes.company_id)>
			<cfset adres = "#adres#&company_id=#attributes.company_id#" >
		</cfif>
		<cfif len(attributes.employee_name)>
			<cfset adres = "#adres#&employee_name=#attributes.employee_name#" >
		</cfif>
		<cfif len(attributes.employee_id)>
			<cfset adres = "#adres#&employee_id=#attributes.employee_id#" >
		</cfif>
		<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="credit.list_stockbond_actions&#adres#">
	</cf_box>
</div>
<script>
$('#employee_name').focus();
function kontrol()
	{
		if(!$("#maxrows").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfoutput>"})    
			return false;
		}
		if( !date_check(document.getElementById('start_date'),document.getElementById('finish_date'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
			return false;
		else
			return true;
	}

</script>
