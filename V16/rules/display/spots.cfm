<cfinclude template="../query/get_spots.cfm">
<cfoutput query="get_spots">
    <cfif currentrow eq 1 >
        <div class="blog_item" style="box-shadow:none; border-bottom: 3px dashed ##ddd;">
            <cfif len(CONTIMAGE_SMALL) >                
                <div class="blog_item_img">
                    <img src="../documents/content/#CONTIMAGE_SMALL#"  style="height:100px!important">
                </div>
            </cfif>
            <div class="blog_item_text" style="background-color:none; border-radius:none;">
                <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_spots.content_id#">#get_spots.cont_head#</a>
                <p class="padding-bottom-5">#Left(get_spots.cont_summary, 90)#...</p>
                <!--- <a class="read_more" href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_spots.content_id#"><i class="fa fa-angle-right"></i>devamını oku</a> --->
            </div>
        </div>
    <cfelse>
        <div class="blog_item" style="box-shadow:none; border-bottom: 3px dashed ##ddd;">
            <cfif len(CONTIMAGE_SMALL)>                
                <div class="blog_item_img">
                    <img src="../documents/content/#CONTIMAGE_SMALL#">
                </div>
            </cfif>       
            <div class="blog_item_text" style="background-color:none; border-radius:none;">
                <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_spots.content_id#">#get_spots.cont_head#</a>                
                <p class="padding-bottom-5">#Left(get_spots.cont_summary, 90)#...</p>
                <!--- <a class="read_more" href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_spots.content_id#"><i class="fa fa-angle-right"></i>devamını oku</a> --->
            </div>
        </div>
    </cfif>
</cfoutput>

