<!--- Bu degerler nereden/neden geliyor? --->
<cfif not isDefined("attributes.field_faction_id")><cfset field_faction_id = "add_faction.faction_id"></cfif>
<cfif not isDefined("attributes.field_faction")><cfset field_faction = "add_faction.faction"></cfif>
<cfif not isDefined("attributes.field_modul")><cfset field_modul = "add_faction.modul_name"></cfif>
<!--- //Bu degerler nereden/neden geliyor? --->
<cfparam name="attributes.modal_id" default="">

<script type="text/javascript">
	<cfif isDefined("attributes.field_faction_id") and isDefined("attributes.field_faction")and isDefined("attributes.field_modul")>
		function add_faction(f_id,f_name,m_name)
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_faction_id#</cfoutput>.value=f_id;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_faction#</cfoutput>.value=f_name;
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_modul#</cfoutput>.value=m_name;
			<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		}
	</cfif>
</script>
<cfif isDefined("attributes.module") AND len(attributes.module)>
	<cfquery name="GET_NAME" datasource="#DSN#">
		SELECT MODULE_SHORT_NAME FROM MODULES WHERE MODULE_ID = #attributes.module#
	</cfquery>
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfinclude template="../query/get_faction.cfm">
<cfelse>
	<cfset get_faction.recordcount = 0>  
</cfif>
<cfquery name="get_modules" datasource="#dsn#">
	SELECT MODULE_SHORT_NAME,MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME<> '' ORDER BY MODULE_SHORT_NAME
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_faction.recordcount#">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
	<cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="form_faction_list" method="post" action="#request.self#?fuseaction=settings.popup_faction_list">
		<cf_box title="#getLang('','Fuseaction','36185')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cf_box_search>
				<div class="form-group">
					<cfoutput>
						<input type="hidden" name="field_faction_id" id="field_faction_id" value="<cfif isDefined("attributes.field_faction_id")>#attributes.field_faction_id#</cfif>">
						<input type="hidden" name="field_faction" id="field_faction" value="<cfif isDefined("attributes.field_faction")>#attributes.field_faction#</cfif>">
						<input type="hidden" name="field_modul" id="field_modul" value="<cfif isDefined("attributes.field_modul")>#attributes.field_modul#</cfif>">
					</cfoutput>
				</div>
				<div class="form-group">
					<input type="hidden" name="is_submitted" id="is_submittted" value="1"/>
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre','57460')#" value="#attributes.keyword#" maxlength="255">
				</div>
				<div class="form-group">
					<select name="module" id="module">
						<option value="" selected><cf_get_lang dictionary_id='52745.Moduls'></option>
						<cfoutput query="get_modules">
							<option value="#MODULE_ID#" <cfif isDefined('attributes.module') and get_modules.MODULE_ID eq attributes.module>selected</cfif>>#MODULE_SHORT_NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayı Hatası Mesaj','34135')#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_faction_list' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
			<cf_flat_list>
				<thead>
					<tr>
					  <th><cf_get_lang dictionary_id='34970.Modül'></td>
					  <th><cf_get_lang dictionary_id='36185.Fuseaction'></td>
				  </tr>
				  </thead>
				  <tbody>
					<cfif get_faction.recordcount>
						<cfoutput query="get_faction" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">	  
								<td>#modul#</td>
								<td height="20"><a href="javascript://" onClick="add_faction('#wrk_objects_id#','#fuseaction#','<cfif len(base)>#base#<cfelse>#modul_short_name#</cfif>');" class="tableyazi">#fuseaction#</a></td> 
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="color-row">
							<td colspan="3"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
						</tr>
					</cfif>
				  </tbody>
			</cf_flat_list>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
					 <tr> 
					  <td>
					  <cfset adres = "#attributes.fuseaction#">
					  <cfif len(attributes.keyword)>
						  <cfset adres = "#adres#&keyword=#attributes.keyword#">
					  </cfif>
					  <cfif isDefined('attributes.module') and len(attributes.module)>
						  <cfset adres = "#adres#&module=#attributes.module#">
					  </cfif>
					  <cfif isdefined("attributes.field_faction_id") and len(attributes.field_faction_id)>
						  <cfset adres = "#adres#&field_faction_id=#attributes.field_faction_id#">
					  </cfif>
					  <cfif isdefined("attributes.field_faction") and len(attributes.field_faction)>
						  <cfset adres = "#adres#&field_faction=#attributes.field_faction#">
					  </cfif>
					  <cfif isdefined("attributes.field_modul") and len(attributes.field_modul)>
						  <cfset adres = "#adres#&field_modul=#attributes.field_modul#">
					  </cfif>
					  <cf_pages page="#attributes.page#"
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#adres#&is_submitted=1">
				 
					   </td>
					  <!-- sil --><td colspan="2" align="right" style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
					 </tr>
				   </table>
			</cfif>			  
		</cf_box>
	</cfform>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
