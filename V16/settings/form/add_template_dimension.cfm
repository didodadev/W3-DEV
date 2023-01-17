<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td  class="headbold"><p><cf_get_lang no='551.Output Şablon Ölçüleri'></p>
    </td>
  </tr>
</table>

      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
        <tr class="color-row">
         
          <td valign="top" >
            <table>
              <cfform action="#request.self#?fuseaction=settings.popup_add_template_dimension" method="post" name="asset_cat">
             
                <tr class="txtboldblue">
                  <td>&nbsp;</td>
				  <td><cf_get_lang no='752.aling'></td>
                  <td><cf_get_lang_main no='283.Genişlik'></td>
                  <td><cf_get_lang_main no='284.Yükseklik'></td>
                  <td><cf_get_lang_main no='661.Sol Marjin'></td>
                  <td><cf_get_lang_main no='659.Üst Marjin'></td>				  
                  <td><cf_get_lang_main no='224.Birim'></td>				  
                </tr>
                <tr>
                  <td><cf_get_lang no='555.Antetli'></td>
				  <cfset attributes.type = 1>
				  <cfinclude template="../query/get_template_dimension.cfm">
                  <td>
				  	<select name="template_align1" id="template_align1">
					     <option value="center"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'center'> selected</cfif>> center</option>
					     <option value="justify"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'justify'> selected</cfif>> justify</option>						 
					     <option value="left"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'left'> selected</cfif>> left</option>
						 <option value="right"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'right'> selected</cfif>> right</option>						 
					 </select>
                  </td>				  
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='130.Genişlik girmelisiniz'></cfsavecontent>
				  <cfinput name="template_width1" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_WIDTH#" style="width:80;"  validate="integer" message="#message#">
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='135.Yükseklik girmelisiniz'></cfsavecontent>
				  <cfinput name="template_height1" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_HEIGHT#" style="width:80;"  validate="integer" message="#message#"></td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='187.Sol Marjin girmelisiniz'></cfsavecontent>
				  <cfinput name="template_leftmargin1" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_LEFTMARGIN#" style="width:80;"  validate="integer" message="#message#">
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='206.Üst Marjin girmelisiniz'></cfsavecontent>
				  <cfinput name="template_topmargin1" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_TOPMARGIN#" style="width:80;"  validate="integer" message="#message#"></td>				  
                  <td>
				      <select name="template_unit1" id="template_unit1">
					     <option value="px"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'px'> selected</cfif>> pixel</option>		
					     <option value="mm"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'mm'> selected</cfif>> mm</option>					     						 
					     <option value="inch"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'inch'> selected</cfif>> inch</option>						 
					  </select>
				  </td>					
                </tr>
				  <tr>
                  <td><cf_get_lang no='556.Devam Kağıdı'></td>
				  <cfset attributes.type = 2>
				  <cfinclude template="../query/get_template_dimension.cfm">
                  <td>
				  	<select name="template_align2" id="template_align2">
					     <option value="center"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'center'> selected</cfif>> center</option>
					     <option value="justify"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'justify'> selected</cfif>> justify</option>						 
					     <option value="left"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'left'> selected</cfif>> left</option>
						 <option value="right"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'right'> selected</cfif>> right</option>						 
					 </select>
                  </td>				  				  
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='130.Genişlik girmelisiniz'></cfsavecontent>
				  <cfinput name="template_width2" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_WIDTH#" style="width:80;"  validate="integer" message="#message#">
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='135.Yükseklik girmelisiniz'></cfsavecontent>
				  <cfinput name="template_height2" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_HEIGHT#" style="width:80;"  validate="integer" message="#message#"></td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='187.Sol Marjin girmelisiniz'></cfsavecontent>
				  <cfinput name="template_leftmargin2" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_LEFTMARGIN#" style="width:80;"  validate="integer" message="#message#">
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='206.Üst Marjin girmelisiniz'></cfsavecontent>
				  <cfinput name="template_topmargin2" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_TOPMARGIN#" style="width:80;"  validate="integer" message="#message#"></td>				  
                  <td>
				      <select name="template_unit2" id="template_unit2">
					     <option value="px"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'px'> selected</cfif>> pixel</option>
					     <option value="mm"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'mm'> selected</cfif>> mm</option>					     						 
					     <option value="inch"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'inch'> selected</cfif>> inch</option>						 
					  </select>
				  </td>					
                </tr>
				  <tr>
                  <td><cf_get_lang_main no='76.Faks'></td>
				  <cfset attributes.type = 3>
				  <cfinclude template="../query/get_template_dimension.cfm">
                  <td>
				  	<select name="template_align3" id="template_align3">
					     <option value="center"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'center'> selected</cfif>> center</option>
					     <option value="justify"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'justify'> selected</cfif>> justify</option>						 
					     <option value="left"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'left'> selected</cfif>> left</option>
						 <option value="right"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'right'> selected</cfif>> right</option>						 
					 </select>
                  </td>				  				  
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='130.Genişlik girmelisiniz'></cfsavecontent>
				  <cfinput name="template_width3" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_WIDTH#" style="width:80;"  validate="integer" message="#message#">
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='135.Yükseklik girmelisiniz'></cfsavecontent>
				  <cfinput name="template_height3" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_HEIGHT#" style="width:80;"  validate="integer" message="#message#"></td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='187.Sol Marjin girmelisiniz'></cfsavecontent>
				  <cfinput name="template_leftmargin3" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_LEFTMARGIN#" style="width:80;"  validate="integer" message="#message#">
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='206.Üst Marjin girmelisiniz'></cfsavecontent>
				  <cfinput name="template_topmargin3" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_TOPMARGIN#" style="width:80;"  validate="integer" message="#message#"></td>				  
                  <td>
				      <select name="template_unit3" id="template_unit3">
					     <option value="px"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'px'> selected</cfif>> pixel</option>
					     <option value="mm"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'mm'> selected</cfif>> mm</option>					     						 
					     <option value="inch"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'inch'> selected</cfif>> inch</option>						 
					  </select>
				  </td>					
                </tr>
				 <tr>
                  <td><cf_get_lang no='557.Zarf'></td>
				  <cfset attributes.type = 4>
				  <cfinclude template="../query/get_template_dimension.cfm">
                  <td>
				  	<select name="template_align4" id="template_align4">
					     <option value="center"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'center'> selected</cfif>> center</option>
					     <option value="justify"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'justify'> selected</cfif>> justify</option>						 
					     <option value="left"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'left'> selected</cfif>> left</option>
						 <option value="right"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_ALIGN EQ 'right'> selected</cfif>> right</option>						 
					 </select>
                  </td>				  				  
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='130.Genişlik girmelisiniz'></cfsavecontent>
				  <cfinput name="template_width4" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_WIDTH#" style="width:80;"  validate="integer" message="#message#">
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='135.Yükseklik girmelisiniz'></cfsavecontent>
				  <cfinput name="template_height4" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_HEIGHT#" style="width:80;"  validate="integer" message="#message#"></td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='187.Sol Marjin girmelisiniz'></cfsavecontent>
				  <cfinput name="template_leftmargin4" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_LEFTMARGIN#" style="width:80;"  validate="integer" message="#message#">
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='206.Üst Marjin girmelisiniz'></cfsavecontent>
				  <cfinput name="template_topmargin4" type="text" value="#GET_TEMPLATE_DIMENSION.TEMPLATE_TOPMARGIN#" style="width:80;"  validate="integer" message="#message#"></td>				  
                  <td>
				      <select name="template_unit4" id="template_unit4">
					     <option value="px"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'px'> selected</cfif>> pixel</option>
					     <option value="mm"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'mm'> selected</cfif>> mm</option>					     						 
					     <option value="inch"<cfif GET_TEMPLATE_DIMENSION.TEMPLATE_UNIT EQ 'inch'> selected</cfif>> inch</option>						 
					  </select>
				  </td>					
                </tr>
                <tr>
                  <td align="right" height="35" colspan="6">
                    <cf_workcube_buttons is_upd='0'>
                  </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>	

