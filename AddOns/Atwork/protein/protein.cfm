<style>
	.proteinBox {
		height: 100px;
		width: 150px;
		background: red;
		border-radius: 5%; 
		margin: 0px auto 10px auto;
		text-align: center;
		box-shadow:inset 0 0 1px rgba(0,0,0,.5);
	}

	.proteinBox i {
		font-size:40px;
		line-height: 60px !important;
	}		
	.proteinIconTitle {
		display: block;
		font-size: 16px;
		font-weight: 400;
		margin: 0 auto;
		width:100px;
	}

	.proteinContent { 
		text-align: center;
		margin: 10px 0;
		height:100px;
	}
	 
	@media screen and (max-width: 1200px) {
		.proteinContent { width:20%!important; }
	}
	@media screen and (max-width: 992px) {
		.proteinContent { width:25% !important; }
	}
	@media screen and (max-width: 768px){
		.proteinContent { width:33%!important; }
	}
	@media screen and (max-width: 548px){
		.proteinContent { width:50%!important; }
	}
	@media screen and (max-width: 319px){
		.proteinContent { width:100%!important; }
	}		 

</style>

<div class="row">
	<div class="col col-12">
		<h3 class="workdevPageHead">Protein B2B2C Yönetim Paneli</h3>
	</div>
</div>
<div class="row">
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=protein.sites" target="blank_">
		<div class="col proteinContent fade"> 
			<div class="proteinBox color-C">  
				<i class="fa fa-globe"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',1874)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=protein.list_site_layouts" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-B">
				<i class="fa fa-newspaper-o"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('settings',1456)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=protein.list_banners" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-G">
				<i class="fa fa-image"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',729)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=protein.list_product_vision" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-D">
				<i class="fa fa-shopping-cart"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('product',469)#</cfoutput></p>	
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.list_content" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-E">
				<i class="fa fa-id-card-o"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',633)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=asset.list_asset" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-F">
				<i class="fa fa-file-text-o"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',156)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=report.partner_public_login_report" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-L">
				<i class="fa fa-bar-chart"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('content',196)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=campaign.list_survey" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-H">
				<i class="fa fa-tasks"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',535)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product_comment" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-Y">
				<i class="fa fa-comment"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',773)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.find_change" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-T">
				<i class="fa fa-search"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('content',165)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_ship_method_price" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-Z">
				<i class="fa fa-truck"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('crm',172)#</cfoutput></p>
			</div>
		</div>
	</a>	
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_callcenter" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-M">
				<i class="fa fa-group"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',5)#</cfoutput></p>
			</div>
		</div>
	</a>		
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-W">
				<i class="fa fa-jsfiddle"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('account',185)#</cfoutput></p>
			</div>
		</div>
	</a>		
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.list_social_media" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-D">
				<i class="fa fa-thumbs-o-up"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',1732)#</cfoutput></p>
			</div>
		</div>
	</a>	
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-S">
				<i class="fa fa-tags"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',152)#</cfoutput></p>
			</div>
		</div>
	</a>	
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product_cat" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-N">
				<i class="fa fa-sitemap"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',725)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_product_brands" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-M">
				<i class="fa fa-registered"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('objects',46)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_property" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-X">
				<i class="fa fa-ticket"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',1498)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=content.list_chapters" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-O">
				<i class="fa fa-puzzle-piece"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',727)#</cfoutput></p>
			</div>
		</div>
	</a>	
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_pos_relation" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-P">
				<i class="fa fa-credit-card"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('objects',1869)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=sales.list_online_sales" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-U">
				<i class="fa fa-shopping-basket"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',2218)#</cfoutput></p>
			</div>
		</div>
	</a>
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=member.list_analysis" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-B">
				<i class="fa fa-th-list"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',1971)#</cfoutput></p>
			</div>
		</div>
	</a>	
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=call.lead" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-T">
				<i class="fa fa-edit"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('main',1317)#</cfoutput></p>
			</div>
		</div>
	</a>		
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=campaign.list_campaign" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-I">
				<i class="fa fa-money"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('campaign',1)#</cfoutput></p>
			</div>
		</div>
	</a>		
	<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.form_search_depot" target="blank_">
		<div class="col proteinContent fade">
			<div class="proteinBox color-U">
				<i class="fa fa-shopping-bag"></i>
				<p class="proteinIconTitle"><cfoutput>#getLang('product',737)#</cfoutput></p>
			</div>
		</div>
	</a>
</div>

<!--- <div class="dashboard-box dasboard-box-clr3">
	<div class="dashboard-box-label-count">
		<span script="javascript://AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=myhome.emptypopup_list_markets_ajaxmarkets');" ></span>	   
	</div>
	<div class="dashboard-box-label-text">Piyasalar</div>            
</div>
 --->
	