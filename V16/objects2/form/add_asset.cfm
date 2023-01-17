<cfparam name="attributes.stream_name" default="#createUUID()#" />
<cfinclude template="../../asset/query/get_asset_cats.cfm">
<cfinclude template="../../objects/display/imageprocess/imcontrol.cfm">
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr> 
   		<td class="headbold"><cf_get_lang no ='1274.Varlık Ekle'></td>
	</tr>
</table>
<cfset session.resim = 3>
<cfset session.module = "asset">
<script type="text/javascript">
	function goLocation(loc){
		var obj =  document.add_asset.asset.value;
		if ((obj == "") || !((obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'jpg')   || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'gif') || (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == 'png'))){
			alert("<cf_get_lang no='515.Lütfen bir resim dosyası(gif,jpg veya png) giriniz!!'>");        
			return false;
		}
		else
		if (obj != ""){
		  document.add_asset.action = loc;
		  return true;
		}		
		return false;								
	}
</script>
<table width="98%" align="center" cellpadding="2" cellspacing="1" border="0" class="assetform">
	<cfform name="add_asset" method="post" action="#request.self#?fuseaction=objects2.#xfa.add#" enctype="multipart/form-data">
	<tr>
      	<td> 
        	<table border="0">
                <tr> 
                  	<td width="100"><cf_get_lang_main no='74.Kategori'> </td>
                  	<td> 
                    	<select name="assetcat_id" id="assetcat_id" style="width:250px;">
                      	<cfoutput query="get_asset_cats"> 
                        	<option value="#assetcat_id#">#assetcat#</option>
                      	</cfoutput> 
                    	</select>
						<input type="Hidden" id="stream_name" name="stream_name" value="">
					  	<input type="Hidden" id="is_stream" name="is_stream" value="0">
					</td>
					<td id="is_site" style="display:none;" rowspan="8" valign="top">&nbsp;</td>
				</tr>				  
				<tr>
					<td width="100"><cf_get_lang_main no ='655.Döküman Tipi'>  *</td>
					<td>
						<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
							SELECT 
								CONTENT_PROPERTY_ID,
								NAME 
							FROM 
								CONTENT_PROPERTY
							ORDER BY
								NAME
						</cfquery>
						<select name="property_id" id="property_id"  style="width:250px;">
							<option value="-1">--<cf_get_lang no='8.Döküman Tipi seçiniz'>--						  
							<cfoutput query="get_content_property">
                            	<option value="#content_property_id#">#name# 
							</cfoutput>
                        </select>
					</td>
				</tr>				
                <tr> 
                  	<td><cf_get_lang_main no='1655.Varlık '> *</td>
                  	<td> 
                    	<cfsavecontent variable="message"><cf_get_lang no='80.Varlık Adı Girmelisiniz'></cfsavecontent>
						<cfinput type="text"  name="asset_name"  id="asset_name" style="width:250px;"required="Yes" message="#message#">                  
					</td>
				</tr>
                <tr> 
                  	<td><cf_get_lang_main no='1688.Döküman'>  *</td>
                  	<td> 
                    	<input type="file" name="asset" id="asset_file" style="width:250px;">
						<cfif structKeyExists(variables, "mx_com_server") and mx_com_server neq ""><cfoutput><a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects2.popup_add_video_stream&stream_name=#attributes.stream_name#','','resizable=yes,scrollbars=yes,width=350,height=350,left=150,top=150');"> <img src="/images/camera.gif" title="Video Camcorder" align="absmiddle" border="0" /></a></cfoutput></cfif>                  
					</td>
      			</tr>
                <tr>
                  	<td valign="top"><cf_get_lang_main no ='217.Açıklama'></td>
                  	<td><textarea name="asset_description" id="asset_description" style="width:250px; height:100px;" onchange="detail();"></textarea></td>
                </tr>
                <tr> 
                  	<td valign="top"><cf_get_lang no ='1276.Anahtar Kelimeler'></td>
                  	<td> 
                    	<textarea name="asset_detail" id="asset_detail" style="width:250px; height:60px;" rows="3" onChange="detail();"></textarea>
					</td>
				</tr>
				<tr>
				  	<td>&nbsp;</td>
				  	<td><input name="is_live" type="checkbox" id="is_live" <cfif isdefined('is_live')>checked</cfif> /><cf_get_lang no ='1277.Canlı Yayın'></td>
			    </tr>
				<tr>
				  	<td>&nbsp;</td>
				  	<td><input type="checkbox" name="featured" id="featured" <cfif isdefined('featured')>checked</cfif> /><cf_get_lang no ='1278.Önemli'></td>
			    </tr>
                <tr> 
                  	<td style="text-align:right;" colspan="2" height="35"> 
	                 	<cf_workcube_buttons is_='0' add_function='check()'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</table>
 		</td>
 	</tr>
 	</cfform>
</table>

<script type="text/javascript">
	function attachStream(streamName) 
	{
		document.getElementById("asset_file").disabled = "true";
		// document.getElementById("asset_file").disabled = true;
		document.getElementById("stream_name").value = streamName;
		document.getElementById("is_stream").value = "1";
	}
	
	function detach(streamName) 
	{
		document.getElementById("asset_file").disabled = "false";
		document.getElementById("stream_name").value = "";
		document.getElementById("is_stream").value = "0";
	}
	
	function check()
	{
		var obj =  document.getElementById('asset_file').value;
		var restrictedFormat = new Array('php','jsp','asp','cfm','cfml');
		for(i=0;i<restrictedFormat.length;i++)
			if (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 4).toLowerCase() == restrictedFormat[i])
			{
					alert("<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");        										
					return false;										
			}
			else
				if((obj.length == (obj.indexOf('.') + 5)) && (obj.substring(obj.indexOf('.')+1,obj.indexOf('.') + 5).toLowerCase() == restrictedFormat[i]))
				{
					alert("<cf_get_lang no='133.php,jsp,asp,cfm,cfml Formatlarda Dosya Girmeyiniz'>");        										
					return false;										
			  	}						
			
				if ((document.getElementById("stream_name").value == "") && (document.getElementById('asset_file').value == ""))
				{
						alert("<cf_get_lang_main no='1655.Varlık'>");
						return false;
				}
				else	
		  			if (document.getElementById('asset_file').value == "")
					{
							alert("<cf_get_lang_main no='1655.Varlık'>");
							return false;
					}
					else	
						if (document.getElementById('property_id').value < 0)
						{
							alert("<cf_get_lang no ='1279.Döküman tipi seçmelisiniz'>!!");
							return false;
						}				
						else
						{
							return true;
						}
	}
	
	function chk_1(gelen)
	{
		if ( (gelen == 1) && (document.getElementById('our_company_id').checked) ) document.getElementById('our_company_id').checked = false;
	}
	
	function detail()
	{ 
		if (document.getElementById('asset_detail').value.length >100)
   		{ 
			alert("<cf_get_lang no ='1280.100 karakterden fazla giremezsiniz'>!");
     		return true;
		}
        return false;
	}
</script>

