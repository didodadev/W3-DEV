<cfif not isDefined("attributes.crop")
and not isDefined("attributes.right") 
and not isDefined("attributes.left")
and not isDefined("attributes.flip90") 
and not isDefined("attributes.flip180") 
and not isDefined("attributes.flip270") 
and not isdefined("attributes.save_image")
and not isdefined("attributes.image_sizer")
and not isDefined("attributes.watermark")
>
<cfif not directoryExists("#upload_folder#image_editor")>
    <cfdirectory action="create" directory="#upload_folder#image_editor">
</cfif>
<cf_box title="#getLang('','İmaj Editör',35540)#" >
<cfform name="image_editor_form" method="post">
<cfimage source="#file_path##file_name#" action="info" structName="ImageInfo" name="abc">
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
		   minWidth:<cfoutput>#ImageInfo.width#</cfoutput>/2,
		   minHeight:<cfoutput>#ImageInfo.height#</cfoutput>/2, //yatay ve dikey çözünürlüğün oranı kaybolmasın istiyorum.
		   displayOnInit: true,
		   onEndCrop: onEndCrop,
		   onloadCoords: { x1: 1, y1:1 , x2: 
						   <cfoutput>#ImageInfo.width#</cfoutput>, y2: 
						   <cfoutput>#ImageInfo.height#</cfoutput> },
						   <cfif isDefined("attributes.crop")>
							   <cftry>
								   <cfimage source="#file_path##file_name#" action="info" structName="ImageInfo" name="abc">
								   <cfset ImageFlip(abc,"90")>
								   <cfimage source="#abc#" action="writeToBrowser">
								   <cfset rand = RandRange(0,100000,"SHA1PRNG")>  <!--- Browser ın cache tutmaması için random bir adla kaydedilir --->
								   <cfimage source="#abc#" action="write" destination="#upload_folder#image_editor#dir_seperator##rand#.jpg" overwrite="yes">
								   <cfimage source="#upload_folder#image_editor#dir_seperator##rand#.jpg" action="info" structName="ImageInfo">
								   <cfinclude template="image_editor_form.cfm"> 
							   <cfcatch type="Any">
								   <cf_get_lang dictionary_id='38764.İşlem Yapılamadı'>!                    
							   </cfcatch>
							   </cftry>
						   </cfif>
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
<cfimage source="#file_path##file_name#" action="info" structName="ImageInfo" name="abc">	
<!--- <cfsavecontent variable="message"><cf_get_lang dictionary_id='35540.İmaj Editör'></cfsavecontent> --->
	<cf_medium_list_search >

		<cf_medium_list_search_area>
		<table>
		   <tr></tr>
			   <br/>
		   
			   <tr>
				   <td>
					   <input type="hidden" name="original_file_path" id="original_file_path" value="<cfoutput>#file_path#</cfoutput>">
					   <input type="hidden" name="original_file_name" id="original_file_name" value="<cfoutput>#file_name#</cfoutput>">
					   <input type="hidden" name="testimage_x1" id="testimage_x1">
					   <input type="hidden" name="testimage_x1" id="testimage_x1">
					   <input type="hidden" name="uploaded_file" id="uploaded_file" value="<cfoutput>#file_path##file_name#</cfoutput>">
					   <input type="hidden" name="testimage_y1" id="testimage_y1">
					   <input type="hidden" name="testimage_x2" id="testimage_x2">
					   <input type="hidden" name="testimage_y2" id="testimage_y2">
					   <input type="hidden" name="testimage_width" id="testimage_width">
					   <input type="hidden" name="testimage_height" id="testimage_height">
					   <input type="submit" name="left"	id="left"	value="<cf_get_lang dictionary_id='64301.Sola Döndür'>"	title="<cf_get_lang dictionary_id='64301.Sola Döndür'>">
					   <input type="submit" name="right" id="right"	value="<cf_get_lang dictionary_id='64303.Sağa Döndür'>"	title="<cf_get_lang dictionary_id='64303.Sağa Döndür'>">
					   <input type="submit" name="crop" id="crop"	value="<cf_get_lang dictionary_id='64302.Kırp'>"title="<cf_get_lang dictionary_id='64302.Kırp'>">
						<input type="submit" name="flip90" id="flip90" value="<cf_get_lang dictionary_id='64306.Dikey Ters Al'>" title="<cf_get_lang dictionary_id='64306.Dikey Ters Al'>" >
						<input type="submit" name="flip180" id="flip180" value="<cf_get_lang dictionary_id='64307.Yatay Ters Al'>" title="<cf_get_lang dictionary_id='64307.Yatay Ters Al'>" >
						<input type="submit" name="flip270" id="flip270" value="<cf_get_lang dictionary_id='64308.Yatay ve Dikey Ters Al'>" title="<cf_get_lang dictionary_id='64308.Yatay ve Dikey Ters Al'>" >
					   
					   <cfif isdefined('session.ep')>
						   <input type="submit" name="watermark" id="watermark" value="<cf_get_lang dictionary_id='64305.Watermark Ekle'>" title="<cf_get_lang dictionary_id='64305.Watermark Ekle'>"/>
					   </cfif>
				   </td>
			   </tr>
		</table>
		
		</cf_medium_list_search_area>
</cf_medium_list_search>
<table cellpadding="3" cellspacing="3">
<tr>
   <td>
	   <div id="img_info_area">
		   <h4><cf_get_lang dictionary_id='62710.Orjinal'> <cf_get_lang dictionary_id='59807.Önizleme'></h4>	
		   <div id="testimage_cropperWrap" class="imaj_editor" oncontextmenu="return false;">
			   
			   <div class="imgCrop_wrap" style="width: <cfoutput>#ImageInfo.width#</cfoutput>px; height: <cfoutput>#ImageInfo.height#</cfoutput>px; ">
				   
				   <cfimage source="#file_path##file_name#" action="writeToBrowser" name="testimage" id="testimage">
					   <div class="imgCrop_dragArea"><div class="imgCrop_overlay imgCrop_north" style="height: 0px; ">
						   <span></span>
					   </div>
					   <div class="imgCrop_overlay imgCrop_east" style="width: 0px; height: 0px; ">
						   <span></span>
					   </div>
					   <div class="imgCrop_overlay imgCrop_south" style="height: 0px; ">
						   <span></span>
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
						   <span>sss</span>
					   </div>
					   <div class="imgCrop_handle imgCrop_handleN"></div>
					   <div class="imgCrop_handle imgCrop_handleNE"></div>
					   <div class="imgCrop_handle imgCrop_handleE"></div>
					   <div class="imgCrop_handle imgCrop_handleSE"></div>
					   <div class="imgCrop_handle imgCrop_handleS"></div>
					   <div class="imgCrop_handle imgCrop_handleSW"></div>
					   <div class="imgCrop_handle imgCrop_handleW"></div>
					   <div class="imgCrop_handle imgCrop_handleNW"></div>
					   <div class="imgCrop_clickArea"></div></div>
					   <div class="imgCrop_clickArea"></div>
					   </div>
				   </div>
			   </div>
	   </div>
	</td>
		   <td>
			<cf_get_lang dictionary_id='64338.Kırpma'> <cf_get_lang dictionary_id='59807.Önizleme'>
			   <br />
			   <br />
			   <div id="previewWrap"></div>
			   <br />
			   <br />
		   </td>
</tr>
<tr>
	   				<td>
				
					   <cf_get_lang dictionary_id='58571.Mevcut'><cf_get_lang dictionary_id='57695.Genişlik'>: <input type="text" name="image_file_name" id="width_info" class="width_inf" value="<cfoutput>#ImageInfo.width#</cfoutput>px" readonly="readonly" >
					   <br />
					   <br />
					   <cf_get_lang dictionary_id='58571.Mevcut'><cf_get_lang dictionary_id='57696.Yükseklik'>: <input type="text" name="width_info" id="width_info" class="width_inf" value="<cfoutput>#ImageInfo.height#</cfoutput>px" readonly="readonly" >
					   <br />
					   <br />
					
				</td>
				<td>
				
				   <cfform name="image_sizer_form" method="post"> 
					   <p><cf_get_lang dictionary_id='58674.Yeni'> <cf_get_lang dictionary_id='57695.Genişlik'> :
					   <cfinput type = "Text" name = "MyRange" range = "100,10000" message = "You must enter an integer from 1 to 5" validate = "integer" required = "no">
					   <br />
					   <p><cf_get_lang dictionary_id='58674.Yeni'><cf_get_lang dictionary_id='57696.Yükseklik'> :
					   <cfinput type = "Text" name = "MyRange" range = "100,10000" message = "You must enter an integer from 1 to 5" validate = "integer" required = "no">
					   <br />
					   <br />
					   <input type="submit" name="image_sizer" id="image_sizer"	value="<cf_get_lang dictionary_id='64339.Yeniden Boyutlandır'>"	title="<cf_get_lang dictionary_id='64339.Yeniden Boyutlandır'>">
				   </cfform>
					
					
	   				</td>
	</tr>
</table>
</cfform> 
</cf_box>
</cfif>
<!--- crop action --->
<cfif isDefined("attributes.crop")>
<cftry>
<cf_get_lang dictionary_id='61210.İşlem Başarılı'>!
<cfimage source="#attributes.uploaded_file#" name="abc">
<cfset ImageCrop(abc,attributes.testimage_x1,attributes.testimage_y1,attributes.testimage_width,attributes.testimage_height)>
<cfset rand = RandRange(0,100000,"SHA1PRNG")>
<cfimage source="#abc#" action="write" destination="#upload_folder#image_editor#dir_seperator##rand#.jpg" overwrite="yes">
<br />
<cfimage source="#upload_folder#image_editor#dir_seperator##rand#.jpg" action="info" structName="ImageInfo">
<cf_get_lang dictionary_id='61210.İşlem Başarılı'>!
<cfinclude template="image_editor_form.cfm"> 
<cfcatch type="Any">
<cf_get_lang dictionary_id='38764.İşlem Yapılamadı'>!                    
</cfcatch>
</cftry>
</cfif>
<!--- crop action --->

<!--- watermark action --->
<cfif isDefined("attributes.watermark")>
<cftry>
<cf_get_lang dictionary_id='61210.İşlem Başarılı'>!
<cfset abc = ImageRead("#attributes.uploaded_file#")/>
<cfset objWatermark = ImageNew("#upload_folder#image_editor#dir_seperator#wmark.png") />
<cfset ImageSetAntialiasing(abc,"on") />
<cfset ImageSetAntialiasing(objWatermark,"on") />
<cfset ImageSetDrawingTransparency(abc,40) />
<cfset ImageResize(objWatermark,abc.GetWidth(),abc.GetHeight(),"blackman",2)>
<cfset ImagePaste(abc,objWatermark,(abc.GetWidth() - objWatermark.GetWidth()),(abc.GetHeight() - objWatermark.GetHeight())) />
<cfset rand = RandRange(0,100000,"SHA1PRNG")>
<cfimage source="#abc#" action="write" destination="#upload_folder#image_editor#dir_seperator##rand#.jpg" overwrite="yes"><br />
<cfimage source="#upload_folder#image_editor#dir_seperator##rand#.jpg" action="info" structName="ImageInfo">
<cfinclude template="image_editor_form.cfm">
<cfcatch type="Any">
<cf_get_lang dictionary_id='38764.İşlem Yapılamadı'>!                   
</cfcatch>
</cftry>
</cfif>
<!--- watermark action --->

<!--- turn action --->
<cfif isDefined("attributes.right") OR isDefined("attributes.Left")>
<cftry>
<cfimage source="#attributes.uploaded_file#" name="abc">
<cfset ImageSetAntialiasing(abc,"on")>
<cfif isDefined("attributes.right")>
   <cfset ImageRotate(abc,90)>
<cfelse>
   <cfset ImageRotate(abc,270)>
</cfif>
<cfset rand = RandRange(0,100000,"SHA1PRNG")>
<cfimage source="#abc#" action="write" destination="#upload_folder#image_editor#dir_seperator##rand#.jpg" overwrite="yes"><br />
<cfimage source="#upload_folder#image_editor#dir_seperator##rand#.jpg" action="info" structName="ImageInfo">
<cfinclude template="image_editor_form.cfm">
<cfcatch type="Any">
<cf_get_lang dictionary_id='38764.İşlem Yapılamadı'>!               
</cfcatch>
</cftry>
</cfif>
<!--- turn action --->

<!--- flip action 90 : yatay ters alma ---> 
<cfif isDefined("attributes.flip90")>
<cftry>

   <cfset abc = ImageRead("#attributes.uploaded_file#")/>
   <cfset ImageFlip(abc,"vertical")> 
   <cfset rand = RandRange(0,100000,"SHA1PRNG")>
   <cfimage source="#abc#" action="write" destination="#upload_folder#image_editor#dir_seperator##rand#.jpg" overwrite="yes"><br />
   <cfimage source="#upload_folder#image_editor#dir_seperator##rand#.jpg" action="info" structName="ImageInfo">
   <cfinclude template="image_editor_form.cfm">
<cfcatch type="Any">
   <cf_get_lang dictionary_id='38764.İşlem Yapılamadı'>!                   
</cfcatch>
</cftry>
</cfif>

<!--- flip action 180 : düşey ters alma --->
<cfif isDefined("attributes.flip180")>
<cftry>
   <cfimage source="#attributes.uploaded_file#" name="abc">
   <cfset ImageFlip(abc,"horizontal")> 
   <cfset rand = RandRange(0,100000,"SHA1PRNG")>
   <cfimage source="#abc#" action="write" destination="#upload_folder#image_editor#dir_seperator##rand#.jpg" overwrite="yes"><br />
   <cfimage source="#upload_folder#image_editor#dir_seperator##rand#.jpg" action="info" structName="ImageInfo">
   <cfinclude template="image_editor_form.cfm">
   <cfcatch type="Any">
	   <cf_get_lang dictionary_id='38764.İşlem Yapılamadı'>!
   </cfcatch>
</cftry>
</cfif>

<!--- flip action 270 : yatay ve düşey ters alma --->
<cfif isDefined("attributes.flip270")>
<cftry>
   <cfimage source="#attributes.uploaded_file#" name="abc">
   <cfset ImageFlip(abc,"diagonal")> 			
   <cfset rand = RandRange(0,100000,"SHA1PRNG")>
   <cfimage source="#abc#" action="write" destination="#upload_folder#image_editor#dir_seperator##rand#.jpg" overwrite="yes"><br />
   <cfimage source="#upload_folder#image_editor#dir_seperator##rand#.jpg" action="info" structName="ImageInfo">
   <cfinclude template="image_editor_form.cfm">
   <cfcatch type="Any">
	   <cf_get_lang dictionary_id='38764.İşlem Yapılamadı'>! 
   </cfcatch>
</cftry>
</cfif>

<!--- save action --->
<cfif isDefined("attributes.save_image")>
	<cftry>
		<cf_get_lang dictionary_id='61210.Transaction Successful'>
		<cffile
			result ="file_status"
			action = "rename"
			destination = "#upload_folder#image_editor#dir_seperator##attributes.original_file_name#" 
			source = "#upload_folder#image_editor#dir_seperator##attributes.new_file_name#">
		<cffile action="delete"	file="#attributes.original_file_path##attributes.original_file_name#">
		<cffile 
			action = "move" 
			source = "#upload_folder#image_editor#dir_seperator##attributes.original_file_name#" 
			destination = "#attributes.original_file_path#">
		<cf_get_lang dictionary_id='56819.Yeni Dosyanız Oluşturuldu'>!
		<br />
		<cfimage source="#attributes.original_file_path##attributes.original_file_name#" action="writeToBrowser">
		<cfcatch type="Any">
			<cf_get_lang dictionary_id='38764.İşlem Yapılamadı'>! 
		</cfcatch>
	</cftry>
</cfif>
<!--- save action --->

<!--- resize action --->
<cfif isDefined("attributes.image_sizer")>

   <cfimage source="#attributes.uploaded_file#" name="abc">
   <cfset ImageResize(abc, 100,100,"blackman",2)>		
   <cfset rand = RandRange(0,100000,"SHA1PRNG")>
   <cfimage source="#abc#" action="write" destination="#upload_folder#image_editor#dir_seperator##rand#.jpg" overwrite="yes"><br />
   <cfimage source="#upload_folder#image_editor#dir_seperator##rand#.jpg" action="info" structName="ImageInfo">
   <cfinclude template="image_editor_form.cfm">

</cfif>