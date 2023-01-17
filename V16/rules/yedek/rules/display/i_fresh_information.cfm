
<cfprocessingdirective pageEncoding = "utf-8"/>
	
<div class="col-4 hp-left px-4">

	<div class="col-12 px-0">
		<h3 class="fresh-information-title ">TAZE BİLGİ</h3>
	</div>
	<div class="col-12">
	<cfinclude template="../query/get_spots.cfm">
		<cfoutput query="get_spots">
		
			<div class="row fresh-information-content">
			
				<div class="col-12 px-0">				
					<img src="<cfif len(CONTIMAGE_SMALL) neq 0>/documents/content/#CONTIMAGE_SMALL#<cfelse>/images/no_photo.gif</cfif>" class="col-12 img-fuild" alt="Responsive image">
				</div>
				<div class="col-12">
					<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_spots.content_id[1]#">
						<h4 class="">#get_spots.cont_head#</h4>
					</a>
				</div>
				<div class="col-12">
					<p>#get_spots.cont_summary#</p>	
				</div>
				<ul class="col-12">
					<li>
						<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#"><cf_get_lang_main no='714.Devam'>
					</li>
				</ul>
			</div>
		</cfoutput>

		<cfinclude template="../query/get_homepage_news.cfm">
			<cfoutput query="get_homepage_news">
				<cfquery name="cimage" datasource="#DSN#" maxrows="3">
					SELECT
						CONTIMAGE_SMALL
					FROM  
						CONTENT_IMAGE
					WHERE 
						CONTENT_ID = #content_id# 
				</cfquery>
			<form name="list_main_cont" action="" method="post">
				<div class="row fresh-information-content-2 mt-3">

					<div class="col-4 kolon px-0">
						<a href="">
							<cfif len(cimage.CONTIMAGE_SMALL)>
								
								<img src="/documents/content/#cimage.CONTIMAGE_SMALL#" class="img-fluid" style="height: 100%;">
							<cfelse>
								<img src="/images/no_photo.gif" class="img-fluid" style="height: 100%;">
							</cfif>


							
						</a>
					</div>
					
					<div class="row col-8 d-flex align-items-center">
						<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#" title="#cont_head#">
							<h5 class="col-12">#cont_head#</h5>
						</a>
							
						<cfif is_dsp_summary eq 0>
							<p class="col-12">#cont_summary#</p>
						</cfif>
						<ul class="col-12">
							<li>
								<a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#content_id#"><cf_get_lang_main no='714.Devam'>
							</li>
						</ul>
						
					</div>
					
				</div>
				</form>	
			</cfoutput>
			<!-- Tümünü Gör Butonu
			<div class="col-12 all-look">
				<a href="##">TÜMÜNÜ GÖR</a>
			</div>
			-->
	</div>
			   
</div>
 				