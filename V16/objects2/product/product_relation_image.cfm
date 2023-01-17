<cfif isdefined("attributes.product_id")>
	<cfset attributes.pid = attributes.product_id>
</cfif>
<cfif isdefined("attributes.product_image_width") and len(attributes.product_image_width) and attributes.product_image_width neq 0>
	<cfset product_image_width = #attributes.product_image_width#>
<cfelse>
	<cfset product_image_width = '200'>
</cfif>
<cfif isdefined("attributes.product_image_height") and len(attributes.product_image_height) and attributes.product_image_height neq 0>
	<cfset product_image_height = #attributes.product_image_height#>
<cfelse>
	<cfset product_image_height = '200'>
</cfif>
<cfif isdefined("attributes.product_image_maxrows") and len(attributes.product_image_maxrows)>
	<cfset product_maxrows = #attributes.product_image_maxrows#>
<cfelse>
	<cfset product_maxrows = 5>
</cfif>
<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN#" maxrows="#product_maxrows#">
	SELECT 
		COALESCE(SLIPIN.ITEM,PI.PRD_IMG_NAME) AS PRD_IMG_NAME,
		PI.PATH,
		PI.PATH_SERVER_ID,
		COALESCE(SLIPI.ITEM,PI.DETAIL) AS DETAIL		
	FROM 
		#dsn1_alias#.PRODUCT_IMAGES PI
		LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPI
                        ON SLIPI.UNIQUE_COLUMN_ID = PI.PRODUCT_IMAGEID 
                        AND SLIPI.COLUMN_NAME ='DETAIL'
                        AND SLIPI.TABLE_NAME = 'PRODUCT_IMAGES'
                        AND SLIPI.LANGUAGE = '#session_base.language#' 
		LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPIN
                        ON SLIPIN.UNIQUE_COLUMN_ID = PI.PRODUCT_IMAGEID 
                        AND SLIPIN.COLUMN_NAME ='PRD_IMG_NAME'
                        AND SLIPIN.TABLE_NAME = 'PRODUCT_IMAGES'
                        AND SLIPIN.LANGUAGE = '#session_base.language#'
	WHERE 
		PI.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		<cfif isdefined("attributes.prod_relation_img_logo") and attributes.prod_relation_img_logo eq 0>
			AND (PI.IMAGE_SIZE = 0 OR PI.IMAGE_SIZE = 1 OR PI.IMAGE_SIZE = 2)
		<cfelseif isdefined("attributes.prod_relation_img_logo") and attributes.prod_relation_img_logo eq 1>
			AND (IMAGE_SIZE = 3)
		</cfif>
	ORDER BY 
		PI.UPDATE_DATE
</cfquery>
<link type="text/css" rel="stylesheet" href="/themes/protein_project/assets/css/magicthumb.css"/>
<script type="text/javascript" src="/themes/protein_project/assets/js/magicthumb.js"></script>
<style>
	.mgt-figure div, .mgt-figure span, .MagicThumb div, .MagicThumb span{display:none!important}
</style>
<cfif get_product_images.recordcount>	
	<div class="description description-type3">
		<div class="row">
			<cfoutput query="get_product_images">
				<div class="col col-<cfif isdefined("attributes.product_relation_image") and attributes.product_relation_image eq 0>3<cfelse>12</cfif> d-flex justify-content-end flex-wrap products">
					<div class="col-12 col-sm-6 col-md-<cfif (isdefined("attributes.prod_relation_img_name") and attributes.prod_relation_img_name eq 0) or (isdefined("attributes.prod_relation_img_detail") and attributes.prod_relation_img_detail eq 0)>12<cfelse>6</cfif>">
						<cfif isdefined("attributes.prod_relation_img") and attributes.prod_relation_img eq 1>		
							<div class="description_image">
							<a href="/documents/product/#get_product_images.path#" class="MagicThumb" ><img src="/documents/product/#get_product_images.path#" /></a>
								<!--- <img id="img#currentrow#" onclick="bigSize(#currentrow#)" class="<cfif isdefined("attributes.product_relation_image_size") and attributes.product_relation_image_size eq 1>img-min<cfelse>img-fluid</cfif>" src="/documents/product/#get_product_images.path#" height="<cfif isdefined("attributes.product_relation_image_size") and attributes.product_relation_image_size eq 1>200px<cfelse>400px</cfif>" style=" transition: 1s"> --->
							</div>
						</cfif>
					</div>
					<cfif (isdefined("attributes.prod_relation_img_name") and attributes.prod_relation_img_name eq 1) or (isdefined("attributes.prod_relation_img_detail") and attributes.prod_relation_img_detail eq 1)>
						<div class="col-12 col-sm-6 col-md-5">
							<cfif isdefined("attributes.prod_relation_img_name") and attributes.prod_relation_img_name eq 1>
								<h4>#PRD_IMG_NAME#</h4>
							</cfif>
							<cfif isdefined("attributes.prod_relation_img_detail") and attributes.prod_relation_img_detail eq 1>				
								<p>#detail#</p>
							</cfif>
						</div>
					</cfif>
				</div>				
			</cfoutput>
		</div>
	</div>		
</cfif>

<script>
	function bigSize(id){
   		$('#img'+id ).toggleClass( "img-fluid" );
	}

</script>
