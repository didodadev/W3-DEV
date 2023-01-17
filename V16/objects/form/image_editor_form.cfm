<cfform name="Test" method="post">
	<script type="text/javascript" charset="utf-8">
        // setup the callback function
        onEndCrop = function( coords, dimensions ) {
            $( 'testimage_x1' ).value = coords.x1;
            $( 'testimage_y1' ).value = coords.y1;
            $( 'testimage_x2' ).value = coords.x2;
            $( 'testimage_y2' ).value = coords.y2;
            $( 'testimage_width' ).value = dimensions.width;
            $( 'testimage_height' ).value = dimensions.height;
			$( 'width_info').value = dimensions.width + " px";
			$( 'height_info').value = dimensions.height + " px";
        }
        cropper = function() { 
            new Cropper.ImgWithPreview(
                'testimage',
                {
					previewWrap: 'previewWrap',
                    minWidth: 50,
                    minHeight: 50,
                    displayOnInit: true,
                    onEndCrop: onEndCrop,
                    onloadCoords: { x1: 1, y1: 1, x2: <cfoutput>#ImageInfo.width#</cfoutput>, y2: <cfoutput>#ImageInfo.height#</cfoutput> },
                }
            ) 
        }
        // set up cropper
        Event.observe( 
            window, 
            'load', 
            cropper
        );
    </script>
   <cf_medium_list_search title="#getLang('','İmaj Editör',35540)#">	
        <!---
    	<cf_medium_list_search_area>
            <table>
                <tr>
                    <td>
                        
                        <input type="hidden" name="testimage_x1" id="testimage_x1">
                        <input type="hidden" name="testimage_x1" id="testimage_x1">
                        <input type="hidden" name="uploaded_file" id="uploaded_file" value="<cfoutput>#file_path##file_name#</cfoutput>">
                        <input type="hidden" name="testimage_y1" id="testimage_y1">
                        <input type="hidden" name="testimage_x2" id="testimage_x2">
                        <input type="hidden" name="testimage_y2" id="testimage_y2">
                        <input type="hidden" name="testimage_width" id="testimage_width">
                        <input type="hidden" name="testimage_height" id="testimage_height">
                        <input type="submit" name="Left"	id="Left"	value="Sola Döndür"	title="Sola Döndür">
						<input type="submit" name="crop"   	id="crop"	value="Kırp"		title="Kırp">
                        <cfif isdefined('session.ep')>
                            <input type="submit" name="watermark" id="watermark"  value="Watermark Ekle" title="Watermark Ekle"/>
						</cfif>
						<div>
							<input type="submit" name="f90" id="flip90" value="Dikey Ters Al" title="Sağa Döndür" >
							<input type="submit" name="f180" id="flip180" value="Yatay Ters Al" title="Sola Döndür" >
							<input type="submit" name="f270" id="flip270" value="Yatay ve Dikey Ters Al" title="Kırp" >
						</div>
                    </td>
                </tr>
            </table>
    	</cf_medium_list_search_area>
    --->
    <input type="hidden" name="original_file_path" id="original_file_path" value="<cfoutput>#file_path#</cfoutput>">
    <input type="hidden" name="original_file_name" id="original_file_name" value="<cfoutput>#file_name#</cfoutput>">
    <input type="hidden" name="new_file_name" id="new_file_name" value="<cfoutput>#rand#.jpg</cfoutput>">
    <input type="submit" name="save_image" id="save_image" value="<cf_get_lang dictionary_id='59031.Kaydet'>" title="<cf_get_lang dictionary_id='59031.Kaydet'>">
    </cf_medium_list_search>
    <table cellpadding="3" cellspacing="3">
        <br />
        <td>
            <br />
            <cf_get_lang dictionary_id='61210.İşlem Başarılı'>!   
            </td>
        <tr>
            <td><div id="testimage_cropperWrap" class="wrap_471BDEA0F41008FBEA86E78BDBD51114">
    			<div class="imgCrop_wrap" style="width: <cfoutput>#ImageInfo.width#</cfoutput>px; height: <cfoutput>#ImageInfo.height#</cfoutput>px; ">
       			<img src="/documents/image_editor/<cfoutput>#rand#.jpg</cfoutput>" alt="" id="testimage" width="<cfoutput>#ImageInfo.width#</cfoutput>" height="<cfoutput>#ImageInfo.height#</cfoutput>">
                <div class="imgCrop_dragArea"><div class="imgCrop_overlay imgCrop_north" style="height: 0px; ">
                    <span></span>
                </div>
                <div class="imgCrop_overlay imgCrop_east" style="width: 0px; height: 0px; ">
                    <span></span>
                </div>
                <div class="imgCrop_overlay imgCrop_south" style="height: 0px; ">
                    <span> </span>
                </div>
                <div class="imgCrop_overlay imgCrop_west" style="width: 0px; height: 0px; ">
                    <span></span>
                </div>
            <div class="imgCrop_selArea" style="display: none; ">
                <div class="imgCrop_marqueeHoriz imgCrop_marqueeNorth">
                    <span></span>
                </div>
                <div class="imgCrop_marqueeVert imgCrop_marqueeEast">
                    <span></span>
                </div>
                <div class="imgCrop_marqueeHoriz imgCrop_marqueeSouth">
                    <span></span>
                </div>
                <div class="imgCrop_marqueeVert imgCrop_marqueeWest">
                    <span></span>
                </div>
                <div class="imgCrop_handle imgCrop_handleN"></div>
                <div class="imgCrop_handle imgCrop_handleNE"></div>
                <div class="imgCrop_handle imgCrop_handleE"></div>
                <div class="imgCrop_handle imgCrop_handleSE"></div>
                <div class="imgCrop_handle imgCrop_handleS"></div>
                <div class="imgCrop_handle imgCrop_handleSW"></div>
                <div class="imgCrop_handle imgCrop_handleW"></div>
                <div class="imgCrop_handle imgCrop_handleNW"></div>
                <div class="imgCrop_clickArea"></div>
            </div>
            <div class="imgCrop_clickArea"></div>
            </div>
            </div>
            </div>
            </td>
            <td style="display:none"><cf_get_lang dictionary_id='59807.Önizleme'>:
                <br />
                <br />
                <div id="previewWrap" ></div>
            </td>
        </tr>
    </table>
</cfform> 
