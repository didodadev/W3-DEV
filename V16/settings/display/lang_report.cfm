<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.lang" default="tr">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("form1_submit")>
	<cfquery name="get_modul_list" datasource="#dsn#">
		SELECT 
			COUNT(ITEM) TOPLAM,
			REPLACE(REPLACE(REPLACE(ITEM,',','_'),'!','_'),'.','_') ITEM,
			MODULE_ID
		FROM 
			SETUP_LANGUAGE_TR
		WHERE
			ITEM LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#">
		GROUP BY 
			ITEM,MODULE_ID
		ORDER BY 
			ITEM ASC
	</cfquery>
	<cfquery name="get_modul_list_2" datasource="#dsn#">
		SELECT 
			DISTINCT MODULE_ID
		FROM 
			SETUP_LANGUAGE_TR
		WHERE
			ITEM LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#">
		ORDER BY
			 MODULE_ID ASC
	</cfquery>
	<cfquery name="get_language" datasource="#dsn#">
		SELECT DISTINCT
			REPLACE(REPLACE(REPLACE(ITEM,',','_'),'!','_'),'.','_') ITEM
		FROM 
			SETUP_LANGUAGE_TR 
		WHERE
			ITEM LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#">
		ORDER BY 
			ITEM ASC	
	</cfquery>
	<cfoutput query="get_language" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfscript>
			if( get_modul_list.recordcount neq 0)
				for(x=1; x lte get_modul_list.recordcount; x=x+1)
					if(get_language.ITEM eq get_modul_list.ITEM[x])
					{
						'item_#ReplaceList(get_language.ITEM," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#_#ReplaceList(get_modul_list.MODULE_ID[x]," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#'=get_modul_list.TOPLAM[x];
					}
		</cfscript>
	</cfoutput>
<cfelse>
	<cfset get_language.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_language.recordcount#">
<table width="98%" border="0" cellpadding="2" cellspacing="1" align="center" <cfif isdefined("attributes.form1_submit") and get_language.recordcount>height="100%"</cfif>>
	<tr>
	    <td height="10" class="headbold"><cf_get_lang no ='2577.Dil Arama Rapor'></td>
	   <!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'><!-- sil -->
	</tr>
	<!-- sil -->
	<tr height="10">
		<td colspan="2">
			<table width="100%" border="0" cellpadding="2" cellspacing="1" align="center" class="color-border">
				<cfform name="form1" method="post" action="#request.self#?fuseaction=settings.lang_report">
					<input type="hidden" name="form1_submit" id="form1_submit" value="1">
					<tr>
						<td class="color-row" valign="top" colspan="2">
							<table border="0">
								<tr>
									<td>
										<cf_get_lang_main no ='48.Filtre'>: <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" required="no" message="<cf_get_lang no ='2578.Lütfen Filtre Giriniz'> !">
									</td>
									<td>						
										<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
										<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1," message="#message#" maxlength="3" style="width:25px;">	
										<cf_wrk_search_button search_function="kontrol()">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</cfform>
			</table>
		</td>
	</tr>
	<!-- sil -->
	<cfif isdefined('form1_submit')>
		<tr>
			<td colspan="2">
				<!-- sil --><div id="cc" style="position:absolute;width:100%;height:100%;z-index:77;overflow:scroll;"> <!-- sil -->
					<table width="100%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
						<tr class="color-header" height="22">
							<td  nowrap class="form-title" ><cf_get_lang no ='319.Kelime'></td>
								<cfoutput query="get_modul_list_2">
									<td class="form-title">#module_id#</td>
									<!---<cfset 'toplam_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#' = 0>--->                                   
                                    <cfset 'toplam_#filterSpecialChars(get_modul_list_2.module_id)#' = 0>                          
								</cfoutput>
							<td class="form-title"><cf_get_lang_main no ='80.Toplam'></td>
						</tr>
						<cfif get_language.recordcount>
							<cfoutput query="get_language" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<cfset satir_toplam = 0>
								<tr  height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';"  class="color-row" title="#item#">
									<td>#item#</td>
										<cfloop query="get_modul_list_2">
											<td align="center">
												<cfif isdefined('item_#ReplaceList(get_language.ITEM," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#') and len(evaluate('item_#ReplaceList(get_language.ITEM," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#'))>
														#evaluate('item_#ReplaceList(get_language.ITEM," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#')#
													<cfset satir_toplam = satir_toplam + evaluate('item_#ReplaceList(get_language.ITEM," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#')>
													<cfset 'toplam_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#' = evaluate('toplam_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#') + evaluate('item_#ReplaceList(get_language.ITEM," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#')>
												<cfelse>
													0
												</cfif>	
											</td>
										</cfloop>
									<td align="center" class="txtbold">
									#satir_toplam#
									</td>
								</tr>
							</cfoutput>
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td class="txtbold" align="right"><cf_get_lang_main no ='80.Toplam'></td>
								<cfset son_toplam = 0>
								<cfoutput query="get_modul_list_2">
									<td class="txtbold" align="center">#evaluate('toplam_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#')# </td>
                                     <cfset 'toplam_#filterSpecialChars(get_modul_list_2.module_id)#' = 0>
									 <!---<cfset son_toplam = son_toplam + evaluate('toplam_#ReplaceList(get_modul_list_2.MODULE_ID," ,%,"",',:,?,/,-,\,&,(,),,","_,_,_,_,_,_,_,_,_,_,_,_,_")#')>--->
									 <cfset son_toplam = son_toplam + evaluate('toplam_#filterSpecialChars(get_modul_list_2.module_id)#')>
								</cfoutput>
								<td class="txtbold" align="center"><cfoutput>#son_toplam#</cfoutput></td>
							</tr>
						<cfelse>
							<tr class="color-row">
								<td colspan="2" height="10"><cf_get_lang_main no ='1074.Kayit Bulunamadı'>!</td>
							</tr>
						</cfif>
					</table>
					<cfif get_language.recordcount and (attributes.maxrows lt attributes.totalrecords)>
						<cfset adres = "settings.lang_report&form1_submit=1&keyword=#attributes.keyword#">	
						<!-- sil -->
						<table width="100%" cellpadding="2" cellspacing="1" border="0">
							<tr>
								<td>
									<cf_pages page="#attributes.page#" 
									maxrows="#attributes.maxrows#"
									totalrecords="#attributes.totalrecords#"
									startrow="#attributes.startrow#"
									adres="#adres#">
								</td>			
								<td colspan="2" align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayit'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
							</tr>
						</table>
						<!-- sil -->
					</cfif>
				<!-- sil --></div><!-- sil -->
			</td>
		</tr> 
	 <cfelse>
		<tr>
			<td colspan="2">
			<table width="100%" border="0" cellpadding="2" cellspacing="1" align="center" class="color-border">
				<tr class="color-row"><td><cf_get_lang_main no ='289.Filtre Ediniz'> !</td></tr>
			</table>
			</td>
		</tr> 
	</cfif>
</table>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
	{
		if(document.getElementById('keyword').value=="")
		{
			alert('Deger Giriniz !');
			return false;
		}
		else 
			return true;
	}	
</script>
