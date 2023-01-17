<cfif session.ep.admin eq 1>
<cfoutput>
<div class="col col-12">
	<h3 class="workdevPageHead">Pazaryeri Entegrasyonları</h3>
</div> 

<div class="row">
	<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
		<div class="col col-12 portBox">                                                    
			<div class="portHead color-">Pazar Yeri Ayarları</div>
			<div class="portBody" style="display: block;">       
				<ul class="hoverList small scrollContent" style="height:200px">  
					<li>
						<a href="javascript://"onclick="windowopen('#request.self#?fuseaction=protein.popup_setting_marketplace&marketplace_id=1','list');" target="_blank" style="font-size:16px"><!---<i class="fa fa-cog fa-spin"></i> --->
							<span>&nbsp;&nbsp;<img src="/images/pazaryeri/gittigidiyor.png" height="22"> GittiGidiyor</span>	
						</a>
					</li>			
					<li>
						 <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=protein.popup_setting_marketplace&marketplace_id=2','list');" target="_blank" style="font-size:16px"><!---<i class="fa fa-cog fa-spin"></i> --->
							<span>&nbsp;&nbsp;<img src="/images/pazaryeri/n11.png"  height="22"> N11</span>
						</a>
					</li>
					
					<li>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=protein.popup_setting_marketplace&marketplace_id=3','list');" style="font-size:16px" target="_blank"><!---<i class="fa fa-cog fa-spin"></i> --->
							<span>&nbsp;&nbsp;<img src="/images/pazaryeri/hepsiburada.png"  height="22"> Hepsiburada</span>
						</a>
					</li>
					
					<li>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=protein.popup_setting_marketplace&marketplace_id=4','list');" style="font-size:16px" target="_blank"><!---<i class="fa fa-cog fa-spin"></i> --->
							<span>&nbsp;&nbsp;<img src="/images/pazaryeri/sahibinden.png"  height="22"> Sahibinden</span>
						</a>
					</li>
					
					<li>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=protein.popup_setting_marketplace&marketplace_id=5','list');" style="font-size:16px" target="_blank"><!---<i class="fa fa-cog fa-spin"></i> --->
							<span>&nbsp;&nbsp;<img src="/images/pazaryeri/amazon.png" height="22"> Amazon</span>
						</a>
					</li>
					
				</ul>
			</div>
		</div> 
		<div class="col col-12 portBox">                                                    
			<div class="portHead color-">Kategori Eşitleme</div>
			<div class="portBody" style="display: block;">       
				<ul class="hoverList small scrollContent" style="height:200px">  
					<li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=protein.list_product_cat_marketplace','list');" target="_blank"><span> Kategoriler</span></a></li>
				</ul>
			</div>
		</div> 
	</div>	
	<!---<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
		<div class="col col-12 portBox">
			<cf_box id="get_related_cat" title="Kategoriler" closable="0" box_page="#request.self#?fuseaction=protein.list_product_cat_marketplace"></cf_box>
		</div>
	</div> --->
	<div class="col col-9 col-md-6 col-sm-6 col-xs-12">
		<div class="col col-12 portBox">		
			<cf_box id="get_products" title="Ürünler" closable="0" box_page="#request.self#?fuseaction=product.emptypopup_ajax_list_marketplace_products"></cf_box>			
		</div>
	</div>

</div>


 </cfoutput>
 
 <cfoutput>
<script type="text/javascript">
	function connectAjax()
	{
		var load_url_ = '#request.self#?fuseaction=protein.setting_gittigidiyor';
		AjaxPageLoad(load_url_);
	}
</script>
</cfoutput>
<cfelse>
	Sistem Yöneticinize başvurun!
</cfif>
