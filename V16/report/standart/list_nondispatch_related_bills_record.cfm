<cfparam name="attributes.cat" default="">
<cfparam name="attributes.ship_action_id" default="">

<cfif isdefined("attributes.ship_id") and len(attributes.ship_id) and attributes.kontrol_form eq 1>
	<cfquery name="del_row" datasource="#dsn2#">
		<!---UPDATE SHIP SET IS_WITH_SHIP = 0 WHERE SHIP_ID = #attributes.ship_id#--->
        DELETE SHIP WHERE SHIP_ID = #attributes.ship_id#
	</cfquery>   
	<cflocation url="#request.self#?fuseaction=report.list_nondispatch_related_bills_record" addtoken="no">	
</cfif>   
    <cfset islem_tipi = '78,81,82,83,112,113,114,811,761,70,71,72,73,74,75,76,77,79,80,84,85,86,88,110,111,115,116,118,1182,119,140,141,811,1131'>   
    <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>  
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_all_cari" datasource="#dsn2#">
	SELECT 
		SHIP_ID,
		SHIP_NUMBER,
        PROCESS_CAT
	FROM 
		SHIP 
	WHERE 
		IS_WITH_SHIP = 1
		AND SHIP_ID NOT IN(SELECT SHIP_ID FROM INVOICE_SHIPS)
        <cfif isDefined("attributes.ship_action_id") and Len(attributes.ship_action_id)>
        AND SHIP_ID =#attributes.ship_action_id#
        </cfif>
        <cfif isDefined("attributes.cat") and Len(attributes.cat)>
        AND PROCESS_CAT IN (#attributes.cat#)
        </cfif>
</cfquery>
<cfelse>
	<cfset get_all_cari.recordcount = 0>
</cfif>
		<!---<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>--->
<cfform name="rapor"  action="#request.self#?fuseaction=report.list_nondispatch_related_bills_record" method="post">
	<input name="kontrol_form" id="kontrol_form" value="0" type="hidden">
	<input name="ship_id" value="" type="hidden">
	<input type="hidden" name="form_submitted" value="1" />
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='43729.Fatura Kaydı Olmayan İlişkili İrsaliyeler Raporu'></cfsavecontent>
    <cf_big_list_search title="#title#" >
    <cf_big_list_search_area>     
    <table>
        <tr>
            <td>Ship_Id * (Irsaliye ID)<cfinput type="text" name="ship_action_id" validate="integer" id="keyword" style="width:90px;" value="#attributes.ship_action_id#" maxlength="50"></td>
                    <td>											     
					<select name="cat" id="cat" style="width:140px;" onchange="cat_control();">
						<option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
						<cfoutput query="get_process_cat" group="process_type">
							<option value="#process_type#-0" <cfif '#process_type#-0' is attributes.cat> selected</cfif>>#get_process_name(process_type)#</option>										
							<cfoutput>
							<option value="#process_cat_id#" <cfif attributes.cat is '#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
							</cfoutput>
						</cfoutput>
					</select>  
				</td>	   
            <td align="left" width="50px">				
                        &nbsp;&nbsp;<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
                        <cf_workcube_buttons is_upd='0' add_function='control()' is_cancel='0' insert_info='#message#' insert_alert=''>
            </td>  
                      <td>
                     </td>    
        </tr>
    </table>  
     </cf_big_list_search_area>
    </cf_big_list_search> 
    <cf_big_list>         
	<thead>
		<tr> 
			<th style="width:30px;"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='42781.İşlem Id'></th>
			<th><cf_get_lang dictionary_id='58772.İşlem No'></th>
			<th style="width:10px;">&nbsp;</th>
		</tr>
     </thead>
     <tbody>
     <cfif get_all_cari.recordcount>
				<cfoutput query="get_all_cari">
				<tr>
					<td>#currentrow#</td>
					<td>
						#SHIP_ID#
                    </td>
                    <td>#SHIP_Number#</td>
					<td style="text-align:center;"><a href="javascript://" onClick="sil('#ship_id#');"><img  src="images/delete_list.gif" border="0"></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
    </tbody>
   </cf_big_list>
</cfform>
<script language="javascript">
	function sil(ship_id)
	{
		if(confirm("<cf_get_lang dictionary_id='29726.Siliniyor'> <cf_get_lang dictionary_id='48488.Emin misiniz'>?"))
		{
			document.all.kontrol_form.value = 1;
			document.all.ship_id.value = ship_id;
			document.rapor.submit();
			alert("<cf_get_lang dictionary_id='36146.Silme İşlemi Tamamlandı'>...");
			document.all.kontrol_form.value = 0;

		}
	}
</script>
