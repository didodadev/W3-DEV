<script type="text/javascript" src="/JS/widget/domdrag.js"></script>
<script type="text/javascript" src="/JS/widget/homebox.js"></script>
<script src="../../../JS/Chart.min.js"></script>

<table cellpadding="0" cellspacing="0" width="98%" align="center">
	<tr> 
		<td height="35">
			<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" style="height:40px;">
				<tr>
					<td class="headbold"><cf_get_lang no="290.Worknet Dashboards"></td>
				</tr>
			</table>
		</td>		
	</tr>
	<tr>
		<td valign="top" width="49%"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr> 
					<!--- Uye Basvurulari ---> 
					<td valign="top" width="49%">
						<cfsavecontent variable="message"><cf_get_lang no="291.Üye Başvuruları"></cfsavecontent>
						<cf_box dragDrop="1" id="member" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=worknet.emptypopup_dsp_member_ajax"></cf_box>
					</td>
					<td width="1%"></td>
				</tr>
				<tr>  
					<!--- Urunler --->
					<td valign="top" width="49%">
						<cfsavecontent variable="message"><cf_get_lang_main no="152.Ürünler"></cfsavecontent>
						<cf_box dragDrop="1" id="product" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=worknet.emptypopup_dsp_product_ajax"></cf_box>
					</td>
				</tr>
				<tr> 
					<!--- Kataloglar --->
					<td valign="top" width="49%">
						<cfsavecontent variable="message"><cf_get_lang no="182.Kataloglar"></cfsavecontent>
						<cf_box dragDrop="1" id="catalog" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=worknet.emptypopup_dsp_catalog_ajax"></cf_box>
					</td> 
				</tr>
			</table>
		</td>
		<td valign="top" width="49%"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr> 
					<!--- Talepler --->
					<td valign="top" width="49%">
						<cfsavecontent variable="message"><cf_get_lang_main no="115.Talepler"></cfsavecontent>
						<cf_box dragDrop="1" id="demand" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=worknet.emptypopup_dsp_demand_ajax"></cf_box>
					</td> 
				</tr>
				<tr>  
					<!--- Etkilesimler --->
					<td valign="top" width="49%">
						<cfsavecontent variable="message"><cf_get_lang_main no="1317.Etkileşimler"></cfsavecontent>
						<cf_box dragDrop="1" id="interaction" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=worknet.emptypopup_dsp_interaction_ajax"></cf_box>
					</td>
				</tr>
				<tr> 
					<!--- Grafik --->
					<td valign="top" width="49%">
						<cfsavecontent variable="message"><cf_get_lang no="292.Grafik"></cfsavecontent>
						<cf_box dragDrop="1" id="graphic" title="#message#" closable="0" collapsed="0" collapsable="1" box_page="#request.self#?fuseaction=worknet.emptypopup_dsp_graphic_ajax"></cf_box>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

