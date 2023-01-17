<!---<cfif session.ep.admin eq 1>--->
	<cfscript>
        marketplace = createObject("component","AddOns.watalogy.cfc.marketplace");
        marketplace.dsn = dsn;
        get_market_place = marketplace.get_market_place_fnc(attributes.marketplace_id);
    </cfscript>
	<cfif attributes.marketplace_id eq 1>
		<cfset market = #getLang('objects2',155)#>
	<cfelseif attributes.marketplace_id eq 2>
		<!--- <cfset market = #getLang('objects2',283)#> --->
		<cfset market = 'N11'>
	<cfelseif attributes.marketplace_id eq 3>
		<!--- <cfset market = #getLang('objects2',286)#> --->
		<cfset market = 'Hepsiburada'>
	<cfelseif attributes.marketplace_id eq 4>
		<!--- <cfset market = #getLang('objects2',285)#> --->
		<cfset market = 'Sahibinden'>
	<cfelseif attributes.marketplace_id eq 5>
		<!--- <cfset market = #getLang('objects2',293)#> --->
		<cfset market = 'Amazon'>
	</cfif>

<cf_popup_box title="#market# - #getLang('main',23)#">
	<cfform name="form_market_place" action="#request.self#?fuseaction=protein.emptypopup_upd_set_marketplace" enctype="multipart/form-data" method="post">
		<input name="marketplace_id" id="marketplace_id" type="hidden" value="<cfoutput>#attributes.marketplace_id#</cfoutput>">
		<div class="row">
			<div class="col col-12  uniqueRow">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-api_key">
								<label class="col col-4 col-xs-12">API Key</label>
								<div class="col col-8 col-xs-12"><input type="text" id="api_key" name="api_key" value="<cfoutput>#get_market_place.api_key#</cfoutput>"></div>
							</div>
							<div class="form-group" id="item-secret_key">
								<label class="col col-4 col-xs-12">Secret Key</label>
								<div class="col col-8 col-xs-12"><input type="text" id="secret_key" name="secret_key" value="<cfoutput>#get_market_place.secret_key#</cfoutput>"></div>
							</div>
							<div class="form-group" id="item-role_name">
								<label class="col col-4 col-xs-12">Role Name</label>
								<div class="col col-8 col-xs-12"><input type="text" id="role_name" name="role_name" value="<cfoutput>#get_market_place.role_name#</cfoutput>"></div>
							</div>						
							<div class="form-group" id="item-role_pass">
								<label class="col col-4 col-xs-12">Role Pass</label>
								<div class="col col-8 col-xs-12"><input type="text" id="role_pass" name="role_pass" value="<cfoutput>#get_market_place.role_pass#</cfoutput>"></div>
							</div>												
							<div class="form-group" id="item-role_pass">
								<label class="col col-4 col-xs-12">Merchant id</label>
								<div class="col col-8 col-xs-12"><input type="text" id="merchant_id" name="merchant_id" value="<cfoutput>#get_market_place.merchant_id#</cfoutput>"></div>
							</div>								
						</div>
					</div>
					<div class ="row formContentFooter">
						<div class="col col-12">
							<cf_record_info query_name="get_market_place" record_emp="record_emp" update_emp="update_emp">
							<cf_workcube_buttons is_upd='1' is_delete='0' add_function='control()'>
						</div>
					</div>
				</div>
			</div>
		</div>
	</cfform>							
</cf_popup_box> 
<!---<cfelse>
	Sistem Yöneticinize başvurun!
</cfif>--->
