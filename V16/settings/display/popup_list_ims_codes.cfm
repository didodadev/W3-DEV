<cfparam name="attributes.keyword" default="">
<cfquery name="GET_IMS_CODE" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_IMS_CODE 
	WHERE 
		IMS_CODE_ID IS NOT NULL
		<cfif len(attributes.keyword)>
		 AND
		 (
		 IMS_CODE LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
		 IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		 )
		</cfif>
	ORDER BY
		IMS_CODE, IMS_CODE_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.totalrecords" default='#get_ims_code.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Mikro Bölge Kodları','43164')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_ims" action="#request.self#?fuseaction=settings.popup_list_ims_codes" method="post">
			<cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre','57460')#">
                </div>			
                <div class="form-group small"> 
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#">
                </div>
                <div>
                    <cf_wrk_search_button button_type="4">	
                </div>
                <cfoutput>
                    <input type="hidden" name="field_ims_code_id" id="field_ims_code_id" value="#attributes.field_ims_code_id#">
                    <input type="hidden" name="field_ims_code" id="field_ims_code" value="#attributes.field_ims_code#">
                    <input type="hidden" name="field_old_ims_code" id="field_old_ims_code" value="#attributes.field_old_ims_code#">
                </cfoutput>           
			</cf_box_search>
            <cf_grid_list>
                <thead>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'>(1001)</th>
                    <th><cf_get_lang dictionary_id='33344.Mikro Bölge Adı'>(1001)</th>
                    <th><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'>(500)</th>
                    <th><cf_get_lang dictionary_id='33344.Mikro Bölge Adı'>(500)</th>
                    <th class="header_icn_none"><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_add_ims_codes</cfoutput>');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></th>
                </thead>
                <tbody>
                    <cfif get_ims_code.RECORDCOUNT>
                        <cfoutput query="GET_IMS_CODE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                                <td>#currentrow#</td>
                                <td><a href="javascript://" onClick="gonder('#ims_code#','#ims_code_id#');" class="tableyazi">#ims_code#</a></td>
                                <td><a href="javascript://" onClick="gonder('#ims_code#','#ims_code_id#');" class="tableyazi">#ims_code_name#</a></td>
                                <td>#ims_code_501#</td>
                                <td>#ims_code_501_name#</td>
                                <!-- sil -->
                                <td width="15" align="right" style="text-align:right;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_ims_codes&ims_id=#ims_code_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
                                <!-- sil -->
                            </tr>
                        </cfoutput>
                    <cfelse>
                    <!-- sil -->
                        <tr height="20" class="color-row">
                            <td colspan="6"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                        </tr>
                    <!-- sil -->
                    </cfif>  
                </tbody>
            </cf_grid_list>
            <cfif attributes.totalrecords gt attributes.maxrows>
                <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%" height="35">
                    <tr>
                        <td>
                            <cfset adres = "">
                            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                                <cfset adres = "#adres#&keyword=#attributes.keyword#">
                            </cfif>
							<cfif isdefined("attributes.field_ims_code")>
								<cfset adres = "#adres#&field_ims_code=#attributes.field_ims_code#">
                            </cfif>
							<cfif isdefined("attributes.field_ims_code_id")>
	                            <cfset adres = "#adres#&field_ims_code_id=#attributes.field_ims_code_id#">
                            </cfif>
							<cfif isdefined("attributes.field_old_ims_code")>
	                            <cfset adres = "#adres#&field_old_ims_code=#attributes.field_old_ims_code#">
                            </cfif>
                            <cf_pages page="#attributes.page#"
                            maxrows="#attributes.maxrows#"
                            totalrecords="#attributes.totalrecords#"
                            startrow="#attributes.startrow#"
                            adres="settings.popup_list_ims_codes#adres#">
                        </td>
                        <td align="right" style="text-align:right;">
                            <cf_get_lang dictionary_id='55072.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
                        </td><!-- sil -->
                    </tr>
                </table>
            </cfif>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function gonder(ims_code,ims_code_id)
	{		
		<cfif isdefined("attributes.field_ims_code")>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.getElementById('<cfoutput>#attributes.field_ims_code#</cfoutput>').value=ims_code;
		</cfif>
		<cfif isdefined("attributes.field_ims_code_id")>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.getElementById('<cfoutput>#attributes.field_ims_code_id#</cfoutput>').value=ims_code_id;
		</cfif>
		<cfif isdefined("attributes.field_old_ims_code")>
            <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.getElementById('<cfoutput>#attributes.field_old_ims_code#</cfoutput>').value=ims_code;
		</cfif>	
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' ); </cfif>	
	}
</script>

