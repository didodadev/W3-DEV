<cfif isdefined('session.pp.userid') or isdefined('session.ww.userid')>
	<cfparam name="attributes.keyword" default="">
	<div class="haber_liste" style="width:600px; background-color:#FFF;">
		<div class="haber_liste_1" style="width:600px;">
			<div class="haber_liste_11"><h1><cf_get_lang no='215.Eğitimi Öner'></h1></div>
		</div>
        <div class="mesaj_2" style="width:600px;">
           <table height="100%">
            <cfform name="add_suggested" action="#request.self#?fuseaction=training.emptypopup_add_suggested" method="post">
            <cfoutput>
            <input type="hidden" name="class_id" id="class_id" value="#attributes.class_id#" />
            <tr>
                <td><div class="mesaj_211"><cf_get_lang_main no='7.Eğitim'></div></td>
                <td><b>#attributes.class_name#</b></td>
            </tr>
            <tr>
                <td width="130"><div class="mesaj_211"><cf_get_lang_main no='512.Kime'> *</div></td>
                <td><input type="hidden" name="emp_id" id="emp_id" value="">
					<input type="hidden" name="cons_id" id="cons_id" value="">
					<input type="hidden" name="par_id" id="par_id" value="">
					<input type="hidden" name="member_type" id="member_type" value="PARTNER">
					<input type="text" name="emp_par_name" id="emp_par_name" value="" style="width:300px;" />
                    <a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=worknet.popup_contact_list&field_id=add_suggested.par_id&field_name=add_suggested.emp_par_name</cfoutput>','list');" style="position:absolute;">
                        <img src="../documents/templates/worknet/tasarim/icon_9.png" width="22" height="22" />
                    </a>
                </td>
            </tr>
            <tr>
                <td valign="top"><div class="mesaj_211"><cf_get_lang_main no='131.Mesaj'> *</div></td>
                <td>
                    <textarea name="detail" id="detail" style="width:450px; height:250px;"></textarea>
                </td> 
            </tr>
            <tr height="35">
                <td colspan="2" align="right" style="text-align:right;"><input class="mesaj_22_btn" style="border:0;" type="button" value="<cf_get_lang_main no='1331.Gönder'>" onclick="kontrol();" /></td>
            </tr>
            </cfoutput>    
        </cfform>
        </table>
        </div>
	</div>
	<script language="javascript">
		function kontrol()
		{
			if(document.getElementById('par_id').value == '' || document.getElementById('emp_par_name').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='512.Kime'>");
				document.getElementById('emp_par_name').focus();
				return false;
			}
			if(document.getElementById('detail').value == '')
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no='131.Mesaj'>");
				document.getElementById('detail').focus();
				return false;
			}
			
			document.getElementById('add_suggested').submit();
		}
	</script>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
