<cfset color_row="##EEEEEE">
<cfset colorover="##CCCCCC">
<cfset colorselect="##FFD9A0">
<div class="table-responsive">
<table class="table table-borderless">
	<tr>
		<cfif attributes.stage eq 1>
			<td style="width:23%; background-color:<cfoutput>#colorselect#</cfoutput>;"><b><cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'></b></td>
		<cfelse>
			<td onmouseover="this.bgColor='<cfoutput>#colorover#</cfoutput>'; " onmouseout="this.bgColor='<cfoutput>#color_row#</cfoutput>';" style="cursor:pointer;width:23%; background-color:<cfoutput>#color_row#</cfoutput>;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_upd_cv_1</cfoutput>"><cf_get_lang dictionary_id='56130.Kimlik ve İletişim Bilgileri'></a></td>
		</cfif>
		
		<cfif attributes.stage eq 2>
			<td style="width:15%; background-color:<cfoutput>#colorselect#</cfoutput>;"><b><cf_get_lang dictionary_id='30236.Kişisel Bilgiler'></b></td>
		<cfelse>
			<td onmouseover="this.bgColor='<cfoutput>#colorover#</cfoutput>'; " onmouseout="this.bgColor='<cfoutput>#color_row#</cfoutput>';" style="cursor:pointer;width:12%; background-color:<cfoutput>#color_row#</cfoutput>;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_upd_cv_2</cfoutput>"><cf_get_lang dictionary_id='30236.Kişisel Bilgiler'></a></td>
		</cfif>
		
		<cfif isdefined('attributes.is_identity_detail') and attributes.is_identity_detail eq 1>
			<cfif attributes.stage eq 3> 
				<td style="width:18%; background-color:<cfoutput>#colorselect#</cfoutput>;"><b><cf_get_lang dictionary_id='35925.Diğer Kimlik Detayları'></b></td>
			<cfelse>
				<td onmouseover="this.bgColor='<cfoutput>#colorover#</cfoutput>'; " onmouseout="this.bgColor='<cfoutput>#color_row#</cfoutput>';" style="cursor:pointer;width:18%; background-color:<cfoutput>#color_row#</cfoutput>;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_upd_cv_3</cfoutput>"><cf_get_lang dictionary_id='35925.Diğer Kimlik Detayları'></a></td>
			</cfif>
		</cfif>
			
		<cfif attributes.stage eq 4> 
			<td style="width:15%; background-color:<cfoutput>#colorselect#</cfoutput>;"><b><cf_get_lang dictionary_id='30644.Eğitim Bilgileri'></b></td>
		<cfelse>
			<td onmouseover="this.bgColor='<cfoutput>#colorover#</cfoutput>'; " onmouseout="this.bgColor='<cfoutput>#color_row#</cfoutput>';" style="cursor:pointer;width:15%; background-color:<cfoutput>#color_row#</cfoutput>;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_upd_cv_4</cfoutput>"><cf_get_lang dictionary_id='30644.Eğitim Bilgileri'></a></td>
		</cfif>
		  
		<cfif attributes.stage eq 5> 
		   <td style="width:15%; background-color:<cfoutput>#colorselect#</cfoutput>;"><b><cf_get_lang dictionary_id='35226.İş Tecrübeleri'></b></td>
		<cfelse>
			<td onmouseover="this.bgColor='<cfoutput>#colorover#</cfoutput>'; " onmouseout="this.bgColor='<cfoutput>#color_row#</cfoutput>';" style="cursor:pointer;width:15%; background-color:<cfoutput>#color_row#</cfoutput>;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_upd_cv_5</cfoutput>"><cf_get_lang dictionary_id='35226.İş Tecrübeleri'></a></td>
		</cfif>

		<cfif attributes.stage eq 6>  
			<td style="width:23%; background-color:<cfoutput>#colorselect#</cfoutput>;"><b><cf_get_lang dictionary_id='35474.Çalışmak İstenilen Birim'></b></td>
		<cfelse>
			<td onmouseover="this.bgColor='<cfoutput>#colorover#</cfoutput>'; " onmouseout="this.bgColor='<cfoutput>#color_row#</cfoutput>';" style="cursor:pointer;width:18%; background-color:<cfoutput>#color_row#</cfoutput>;"> <a href="<cfoutput>#request.self#?fuseaction=objects2.form_upd_cv_6</cfoutput>"><cf_get_lang dictionary_id='35474.Çalışmak İstenilen Birim'></a></td>
		</cfif>
		  
		<cfif attributes.stage eq 7> 
			<td style="width:15%; background-color:<cfoutput>#colorselect#</cfoutput>;"><b><cf_get_lang no='888.Kabul'></b></td>
		<cfelse>
			<td onmouseover="this.bgColor='<cfoutput>#colorover#</cfoutput>'; " onmouseout="this.bgColor='<cfoutput>#color_row#</cfoutput>';" style="cursor:pointer;width:15%; background-color:<cfoutput>#color_row#</cfoutput>;"><a href="<cfoutput>#request.self#?fuseaction=objects2.form_upd_cv_7</cfoutput>"><cf_get_lang dictionary_id='35209.Kabul'></a></td>
		</cfif>		
  	</tr>
</table>
</div>

