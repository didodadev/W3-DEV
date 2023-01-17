<cfoutput>
  <cfswitch expression = "#session.module#">
    <cfcase value="asset">
    <cfif isDefined("session.port")>
      <input type="button" onClick="javascript:parent.location = '#request.self#?fuseaction=#session.module#.form_add_asset&eskiSil=yes'" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
      <cfelse>
      <input type="button" onClick="javascript:parent.location = '#request.self#?fuseaction=#session.module#.form_add_asset&eskiSil=yes'" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
    </cfif>
    </cfcase>
    <cfcase value="hr">
    <input type="button" onClick="javascript:parent.location = '#request.self#?fuseaction=#session.module#.form_upd_emp<cfif isDefined("session.employee_id")>&employee_id=#session.employee_id#</cfif>&eskiSil=yes'" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
    </cfcase>
    <cfcase value="member">
    <cfif isDefined("session.pid")>
      <input type="button" onClick="javascript:parent.location = '#request.self#?fuseaction=#session.module#.form_list_company&event=updPartner&pid=#session.pid#&eskiSil=yes'" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
      <cfelseif 	isDefined("session.cid")>
      <input type="button" onClick="javascript:parent.location = '#request.self#?fuseaction=#session.module#.consumer_list&event=det&cid=#session.cid#&eskiSil=yes'" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
    </cfif>
    </cfcase>
    <cfcase value="content">
    <input type="button" onClick="javascript:if (confirm('Yaptığınız Değişiklikleri Kaybedeceksiniz. Emin misiniz?')) parent.location = '#request.self#?fuseaction=#session.module#.image_popup<cfif isDefined("url.cntid")>&cntid=#url.cntid#</cfif>&eskiSil=yes'; else return;" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
    </cfcase>
    <cfcase value="product">
    <input type="button" onClick="javascript:if (confirm('Yaptığınız Değişiklikleri Kaybedeceksiniz. Emin misiniz?')) parent.location = '#request.self#?fuseaction=#session.module#.form_add_popup_image&pid=#url.pid#&eskiSil=yes'; else return;" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
    </cfcase>
    <cfcase value="training_management">
    <input type="button" onClick="javascript:if (confirm('Yaptığınız Değişiklikleri Kaybedeceksiniz. Emin misiniz?')) parent.location = '#request.self#?fuseaction=objects.popup_image_upload&eskiSil=yes'; else return;" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
    </cfcase>
    <cfdefaultcase>
    <input type="button" onClick="javascript:if (confirm('Yaptığınız Değişiklikleri Kaybedeceksiniz. Emin misiniz?')) parent.location = '#request.self#?fuseaction=objects.popup_image_upload&eskiSil=yes'; else return;" value="<cf_get_lang_main no='50.Vazgeç'>" style="width:65px;">
    </cfdefaultcase>
  </cfswitch>
</cfoutput>
