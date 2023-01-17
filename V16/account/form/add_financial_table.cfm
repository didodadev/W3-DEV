<cfif attributes.fintab_type eq 'SCALE_TABLE'>
	<cfset lang_no = 267>	<!--- Mizan Tablosu Ekle --->
<cfelseif attributes.fintab_type eq 'INCOME_TABLE'>
	<cfset lang_no = 268>	<!--- Gelir Tablosu Ekle --->
<cfelseif attributes.fintab_type eq 'COST_TABLE'>
	<cfset lang_no = 269>	<!--- Satış Maliyet Tablosu Ekle --->
<cfelseif attributes.fintab_type eq 'BALANCE_TABLE'>
	<cfset lang_no = 270>	<!--- Bilanço Tablosu Ekle --->
<cfelseif attributes.fintab_type eq 'CASH_FLOW_TABLE'>
	<cfset lang_no = 271>	<!--- Nakit Akım Tablosu Ekle --->
<cfelseif attributes.fintab_type eq 'FUND_FLOW_TABLE'>
	<cfset lang_no = 272>	<!--- Fon Akım Tablosu Ekle --->
</cfif>
<cfparam  name="attributes.user_given_name" default="">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('account',lang_no)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="balance_table" action="#request.self#?fuseaction=account.emptypopup_add_save_fintab#iif(isdefined('attributes.draggable'),DE('&draggable=1'),DE(''))#" method="post">
		<cf_box_elements vertical="1">
			<cfoutput>
				<input type="hidden" name="#trim(listfirst(session.light_mode,":"))#"  value="#trim(listlast(session.light_mode,":"))#">
				<cfif isDefined('attributes.save_date1') and isdate(attributes.save_date1)>
					<input type="hidden" name="save_date1" id="save_date1" value="#attributes.date1#">
				</cfif>
				<input type="hidden" name="save_date2" id="save_date2" value="#attributes.date2#">
				<input type="hidden" name="fintab_type" id="fintab_type" value="#attributes.fintab_type#">
				<textarea name="cons_last" id="cons_last" style="display:none;"></textarea> 
			</cfoutput>				
			<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
				<label>
					<cfif attributes.fintab_type eq 'SCALE_TABLE'>
						<cf_get_lang no='111.Mizan Tablosu'>*
					<cfelseif attributes.fintab_type eq 'INCOME_TABLE'>
						<cf_get_lang no='1.Gelir Tablosu'>*
					<cfelseif attributes.fintab_type eq 'COST_TABLE'>
						<cf_get_lang dictionary_id="56876.Yeni Satış Maliyet Tablosu"> *
					<cfelseif attributes.fintab_type eq 'BALANCE_TABLE'>
						<cf_get_lang dictionary_id="56881.Yeni Bilanço Tablosu"> *
					<cfelseif attributes.fintab_type eq 'CASH_FLOW_TABLE'>
						<cf_get_lang dictionary_id="56891.Yeni Nakit Akım Tablosu"> *
					<cfelseif attributes.fintab_type eq 'FUND_FLOW_TABLE'>
						<cf_get_lang dictionary_id="57182.Yeni Fon Akım Tablosu"> *
					</cfif>
				</label>
				<cfinput type="text" name="user_given_name" id="user_given_name" value="#attributes.user_given_name#" required="yes" message="#getlang('','Table Name',36201)#">
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="kontrol()&&loadPopupBox('balance_table')">
		</cf_box_footer>
	</cfform>
</cf_box>
			
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("user_given_name").value == "")
		{
			alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang no ='91.Tablo Adi'>");
			return false;
		}
		document.getElementById("cons_last").value = document.querySelector(".ui-scroll").outerHTML;
		return document.getElementById("balance_table").checkValidity();
		loadPopupBox('balance_table' , <cfoutput>#attributes.modal_id#</cfoutput>);
	}
</script>
