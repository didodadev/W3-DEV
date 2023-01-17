<cftry>
<cfif isdefined('image_type') and (image_type eq 'photo')>
	<cfif len(get_hr_detail.photo)>
	<!--- <cfoutput>#upload_folder#hr\#get_hr_detail.photo#</cfoutput><cfabort>  --->
			<cfset myPhoto = ImageNew("#upload_folder#hr\#get_hr_detail.photo#")>
			<cfset photo_width_target = photo_size_width><!--- XML ölçüleri için --->
			<cfset photo_height_target = photo_size_height>
			<cfset photo_height_rate = ImageGetHeight(myPhoto)/(photo_height_target)>
			<cfset photo_width_rate = ImageGetWidth(myPhoto)/(photo_width_target)>
				<cfif photo_height_rate gt photo_width_rate>
					<cfset photo_rate = photo_height_rate>
				<cfelse>
					<cfset photo_rate = photo_width_rate>
				</cfif>
			<cfset new_photo_height = ImageGetHeight(myPhoto)/photo_rate>
			<cfset new_photo_weight = ImageGetWidth(myPhoto)/photo_rate>
			<cfset ImageResize(myPhoto,new_photo_weight,new_photo_height,"highestQuality",1)>
		<cfimage action = "writeToBrowser" source = "#myPhoto#" isBase64="yes">
	</cfif> 
<cfelseif isdefined('image_type') and (image_type eq 'signature')>
	<tr>
		<td class="txtbold" valign="top" width="185"><cf_get_lang no ='808.Islak İmza'></td>
		<td valign="top"><input id="asset_file" type="FILE" name="signature_" style="width:300px;"></td>
		<td><cfif len(get_hr_detail.WET_SIGNATURE)>
				<cfset binary_signature_dsply = binarydecode(get_hr_detail.WET_SIGNATURE,'Base64')><!--- db den çektikten sonra da böyle çek ve aşağıdaki gibi göster --->
					<cfset myImage = ImageNew("#binary_signature_dsply#")>
						<cfset width_target = is_image_size_width>
						<cfset height_target = is_image_size_height>
						<cfset height_rate = (ImageGetHeight(myImage)/height_target)>
						<cfset width_rate = (ImageGetWidth(myImage)/width_target)>
					<cfif height_rate gt width_rate>
						<cfset my_rate = height_rate>
					<cfelse>
						<cfset my_rate = width_rate>
					</cfif>
					<cfset new_height = ImageGetHeight(myImage)/my_rate>
					<cfset new_weight = ImageGetWidth(myImage)/my_rate>
					<cfset ImageResize(myImage,new_weight,new_height,"highestQuality",1)>
				<cfimage action = "writeToBrowser" source = "#myImage#" isBase64="yes">
			</cfif>
		</td>
	</tr>	
</cfif>
<cfcatch type="any">
	<cf_get_server_file output_file="hr/#GET_HR_DETAIL.photo#" output_server="#GET_HR_DETAIL.photo_server_id#" output_type="0" image_width="120" image_height="160"><br/>
</cfcatch>
</cftry>

