<cfif session.ep.admin eq 1>
	<cfscript>
        marketplace = createObject("component","V16.add_options.b2b2c.protein.cfc.marketplace");
        marketplace.dsn = dsn;
        marketplace.dsn1 = dsn1;
        get_market_place_product_catid = marketplace.get_market_place_product_cat_fnc(attributes.product_catid);
    </cfscript>
	
	<link rel="stylesheet" type="text/css" href="/V16/add_options/b2b2c/protein/assets/css/typehead.css" />

<cf_popup_box title="#getLang('main',155)# - #getLang('main',23)#">
	<cfform name="form_market_place" action="#request.self#?fuseaction=protein.emptypopup_marketplace_product_cat" enctype="multipart/form-data" method="post">
		<input name="product_catid" id="product_catid" type="hidden" value="<cfoutput>#attributes.product_catid#</cfoutput>">
		<input name="marketplace_pc_id" id="marketplace_pc_id" type="hidden" value="<cfoutput>#get_market_place_product_catid.marketplace_pc_id#</cfoutput>">
		<div class="row">
			<div class="col col-12  uniqueRow">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-w3_product_cat">
								<label class="col col-4 col-xs-12"><b style="color:red;">W3 Kategori Kategorisi</b></label>
								<div class="col col-4 col-xs-6"><input type="text" id="w3_hierarchy" name="w3_hierarchy" value="<cfoutput>#get_market_place_product_catid.hierarchy#</cfoutput>" style="color:red;" readonly></div>
								<div class="col col-4 col-xs-6"><input type="text" id="w3_product_cat" name="w3_product_cat" value="<cfoutput>#get_market_place_product_catid.product_cat#</cfoutput>" style="color:red;" readonly></div>
							</div>
							<div class="form-group" id="item-gittigidiyor">
								<label class="col col-4 col-xs-12">Gittigidiyor Kategorisi</label>
								<div class="col col-4 col-xs-6"><input type="text" id="gittigidiyor_hierarchy" name="gittigidiyor_hierarchy" value="<cfoutput>#get_market_place_product_catid.gittigidiyor_hierarchy#</cfoutput>" readonly></div>
								<div class="col col-4 col-xs-6 typeahead_container">
									<input class="typeahead tt-input" type="text" id="gittigidiyor_product_cat" name="gittigidiyor_product_cat" value="<cfoutput>#get_market_place_product_catid.gittigidiyor_product_cat#</cfoutput>" >
								</div>								 
							</div>
							<div class="form-group" id="item-n11">
								<label class="col col-4 col-xs-12">N11 Kategorisi</label>
								<div class="col col-4 col-xs-6"><input type="text" id="n11_hierarchy" name="n11_hierarchy" value="<cfoutput>#get_market_place_product_catid.n11_hierarchy#</cfoutput>" readonly></div>
								<div class="col col-4 col-xs-6"><input type="text" id="n11_product_cat" name="n11_product_cat" value="<cfoutput>#get_market_place_product_catid.n11_product_cat#</cfoutput>" ></div>									 
							</div>						
							<div class="form-group" id="item-hepsiburada">
								<label class="col col-4 col-xs-12">Hepsiburada Kategorisi</label>
								<div class="col col-4 col-xs-6"><input type="text" id="hepsiburada_hierarchy" name="hepsiburada_hierarchy" value="<cfoutput>#get_market_place_product_catid.hepsiburada_hierarchy#</cfoutput>" readonly></div>
								<div class="col col-4 col-xs-6"><input type="text" id="hepsiburada_product_cat" name="hepsiburada_product_cat" value="<cfoutput>#get_market_place_product_catid.hepsiburada_product_cat#</cfoutput>" ></div>								 
							</div>												
							<div class="form-group" id="item-sahibinden">
								<label class="col col-4 col-xs-12">Sahibinden Kategorisi</label>
								<div class="col col-4 col-xs-6"><input type="text" id="sahibinden_hierarchy" name="sahibinden_hierarchy" value="<cfoutput>#get_market_place_product_catid.sahibinden_hierarchy#</cfoutput>" readonly></div>
								<div class="col col-4 col-xs-6"><input type="text" id="sahibinden_product_cat" name="sahibinden_product_cat" value="<cfoutput>#get_market_place_product_catid.sahibinden_product_cat#</cfoutput>" ></div>								 
							</div>		
							<div class="form-group" id="item-amazon">
								<label class="col col-4 col-xs-12">Amazon Kategorisi</label>
								<div class="col col-4 col-xs-6"><input type="text" id="amazon_hierarchy" name="amazon_hierarchy" value="<cfoutput>#get_market_place_product_catid.amazon_hierarchy#</cfoutput>" readonly></div>
								<div class="col col-4 col-xs-6"><input type="text" id="amazon_product_cat" name="amazon_product_cat" value="<cfoutput>#get_market_place_product_catid.amazon_product_cat#</cfoutput>" ></div>							 
							</div>	
							<div class="form-group" id="item-pttavm">
								<label class="col col-4 col-xs-12">PattAvm Kategorisi</label>
								<div class="col col-4 col-xs-6"><input type="text" id="pttavm_hierarchy" name="pttavm_hierarchy" value="<cfoutput>#get_market_place_product_catid.pttavm_hierarchy#</cfoutput>" readonly></div>
								<div class="col col-4 col-xs-6"><input type="text" id="pttavm_product_cat" name="pttavm_product_cat" value="<cfoutput>#get_market_place_product_catid.pttavm_product_cat#</cfoutput>" ></div>							 
							</div>	

						</div>
					</div>
					<div class ="row formContentFooter">
						<div class="col col-12">
							<cf_record_info query_name="get_market_place_product_catid" record_emp="record_emp" update_emp="update_emp">
							<cf_workcube_buttons is_upd='0' is_delete='0' add_function='control()'>
						</div>
					</div>
				</div>
			</div>
		</div>
	</cfform>							
</cf_popup_box>

<cfinclude template="check_marketplace_cats.cfm">

<cfelse>
	Sistem Yöneticinize başvurun!
</cfif>
